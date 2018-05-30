<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="/assets/css/stylesheet.css">

   

  </head>

  <body id="transport">
  

    <div class="container-fluid" style="height: 90vh; overflow: hidden;">
      
        <table class="table">
          <tr>
            <th>Action</th>
            <th>Customer</th>
            <th>Description</th>
            <th class="cell-center">Type</th>
            <th class="cell-center">Department</th>
            <th class="cell-center">Date</th>
          </tr>
          {{range .Reports}}
          <tr>
            <td id="actionflag">{{if eq .ActionFlag "Deliver"}} &larr; Deliver {{end}}
                {{if eq .ActionFlag "Collect"}} &rarr; Collect {{end}}</td>
            <td>{{.Customer}}</td>
            <td>{{.JobDescription}}</td>
            <td class="cell-center">{{if eq .ServiceType "Regular"}} <p class="job-card">{{end}} 
                                    {{if eq .ServiceType "Emergency"}} <p class="job-card emergency">{{end}}
                                    {{.ServiceType}}</p></td>
            <td class="cell-center"><p class="job-card">{{.Department}}</p></td>
            <td class="cell-center"><p class="job-card">{{.TransportDate}}</p></td>
          </tr>
          {{end}}
          </table>
          </div>
    
           <!-- Load jQuery-->
        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>

        <script>

        // Wait 5 seconds
        // Scroll to bottom of page - final parameter is the duration...
        // Yours will be something like 10000 + (2000 * no of jobs)
        // Wait another 5 seconds
        // Reload page
        
        $(".container-fluid")
            .delay(5000)
            .animate({ scrollTop: $('.container-fluid').prop("scrollHeight")}, 20000)
            .delay(5000)
            .queue(function() { location.reload(true) })

        </script>


  </body>
</html>
