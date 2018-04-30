<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="60">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="/assets/css/stylesheet.css">
</head>

<body id="transport">

    <div class="container-fluid">
        <!--  Content Area-->
        <div class="row content">

          <div class="col-md-3 col-sm-6">
            <h3>Today's Collections</h3> 
            {{range .ReportsCollect}}
            <div class="job-card">
                <p>{{.Customer}} ({{.JobNo}})</p>
                <p>{{.Department}}</p>
                <p>{{.JobDescription}}</p>
                <p>{{.TransportDate}}</p>
              </div>
            {{end}}
          </div>


          <div class="col-md-3 col-sm-6">
            <h3>Today's Deliveries</h3> 
            {{range .ReportsDeliver}}
              <div class="job-card">
                <p>{{.Customer}} ({{.JobNo}})</p>
                <p>{{.Department}}</p>
                <p>{{.JobDescription}}</p>
                <p>{{.TransportDate}}</p>
              </div>
            {{end}}
          </div>
              
          <div class="col-md-3 col-sm-6">
            <h3>Future Deliveries</h3> 
            {{range .ReportsDeliverFuture}}
            <div class="job-card">
                <p>{{.Customer}} ({{.JobNo}})</p>
                <p>{{.Department}}</p>
                <p>{{.JobDescription}}</p>
                <p>{{.TransportDate}}</p>
              </div>
            {{end}}
          </div>
          
          <div class="col-md-3 col-sm-6">
            <h3>Future Collections</h3> 
            {{range .ReportsCollectFuture}}
            <div class="job-card">
                <p>{{.Customer}} ({{.JobNo}})</p>
                <p>{{.Department}}</p>
                <p>{{.JobDescription}}</p>
                <p>{{.TransportDate}}</p>
              </div>
            {{end}}
          </div>

        </div>
      </div>
        
</body>
</html> 