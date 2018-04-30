package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"strconv"

	_ "github.com/denisenkom/go-mssqldb"
	"github.com/julienschmidt/httprouter"
)

//Config file structure
type Config struct {
	Server string `json:"server"`
	User   string `json:"user"`
	Pwd    string `json:"pwd"`
	Db     string `json:"db"`
	Port   int    `json:"port"`
}

type report struct {
	TransportID    int
	ActionFlag     string
	JobNo          int
	Customer       string
	Department     string
	JobDescription string
	TransportDate  string
	DateDiff       int
}

type data struct {
	ReportsCollect       []report
	ReportsDeliver       []report
	ReportsCollectFuture []report
	ReportsDeliverFuture []report
}

var config Config
var db *sql.DB

func init() {

	fmt.Println("entered func init")

	// Load application configuration from settings file
	file, err := os.Open("config.json")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	err = json.NewDecoder(file).Decode(&config)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("config file opened")

	// Connect to the database and test connection

	connection := fmt.Sprintf("Server=%s;User ID=%s;Password=%s;database=%s;",
		config.Server,
		config.User,
		config.Pwd,
		config.Db)

	db, err = sql.Open("mssql", connection)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(connection)

	fmt.Println("connected to DB")

	if err = db.Ping(); err != nil {
		log.Fatal(err)
	}

}

func main() {

	router := httprouter.New()

	router.ServeFiles("/assets/*filepath", http.Dir("./assets"))

	router.GET("/transporthome", home)

	log.Fatal(http.ListenAndServe(":"+strconv.Itoa(config.Port), router))
}

func home(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {

	fmt.Println("entered home")

	var output data

	sql := `SELECT action_flag, job_no, customer, department, job_description, COALESCE(CONVERT(NVARCHAR(11), transport_date, 106), '-'), datediff(d, cast(current_timestamp as date), cast(transport_date as date))
			 FROM transport
			 WHERE is_active = 'Y'
			 ORDER BY transport_date DESC`

	rows, err := db.Query(sql)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("sql executed")

	output.ReportsCollect = make([]report, 0)
	output.ReportsDeliver = make([]report, 0)
	output.ReportsCollectFuture = make([]report, 0)
	output.ReportsDeliverFuture = make([]report, 0)

	for rows.Next() {

		var r report

		err := rows.Scan(&r.ActionFlag, &r.JobNo, &r.Customer, &r.Department, &r.JobDescription, &r.TransportDate, &r.DateDiff)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println(r.DateDiff)

		if r.Department == "EL" {
			r.Department = "Electrical"
		} else if r.Department == "ME" {
			r.Department = "Mechanical"
		} else if r.Department == "PM" {
			r.Department = "Electronics"
		} else if r.Department == "HI" {
			r.Department = "Hi-Cycle"
		} else if r.Department == "BA" {
			r.Department = "Balancing"
		} else {
			r.Department = "?"
		}

		if r.ActionFlag == "C" {
			//if the collection date is today
			if r.DateDiff == 0 {
				output.ReportsCollect = append(output.ReportsCollect, r)
				//else append to ReportsCollectFuture
			} else if r.DateDiff > 0 {
				output.ReportsCollectFuture = append(output.ReportsCollectFuture, r)
			}

		} else if r.ActionFlag == "D" {
			if r.DateDiff == 0 {
				//if the delivery date is today
				output.ReportsDeliver = append(output.ReportsDeliver, r)
				//else append to ReportsDeliverFuture
			} else if r.DateDiff > 0 {
				output.ReportsDeliverFuture = append(output.ReportsDeliverFuture, r)
			}

		}
	}
	t, err := template.ParseFiles("assets/templates/home.tpl")
	if err != nil {
		log.Fatal(err)
	}

	err = t.Execute(w, output)
	if err != nil {
		log.Fatal(err)
	}

}
