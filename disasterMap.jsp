<html>

<head>

<title>Live Disaster Map</title>

<style>

body{
font-family:Arial;
background:#0f172a;
color:white;
text-align:center;
}

#map{
height:500px;
width:80%;
margin:auto;
border-radius:10px;
}

.back{
position:absolute;
top:20px;
left:20px;
background:#334155;
color:white;
padding:8px 14px;
text-decoration:none;
border-radius:6px;
}

</style>

</head>

<body>

<a href="dashboard.jsp" class="back"> Back</a>

<h1> Live Disaster Map</h1>

<div id="map"></div>

<script>

function initMap(){

var location1={lat:17.3850,lng:78.4867};  // Example Hyderabad

var map=new google.maps.Map(document.getElementById("map"),{
zoom:6,
center:location1
});

new google.maps.Marker({
position:location1,
map:map,
title:"Flood Disaster"
});

}

</script>

<script async defer
src="https://maps.googleapis.com/maps/api/js?callback=initMap">
</script>

</body>

</html>