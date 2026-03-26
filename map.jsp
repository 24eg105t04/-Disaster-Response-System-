<html>

<head>

<title>Disaster Map</title>

<style>

#map{
height:500px;
width:100%;
}

</style>

<script src="https://maps.googleapis.com/maps/api/js"></script>

<script>

function initMap(){

var map=new google.maps.Map(document.getElementById("map"),{
zoom:5,
center:{lat:20,lng:78}
});

var disaster={lat:28.6139,lng:77.2090};

var marker=new google.maps.Marker({
position:disaster,
map:map,
title:"Disaster Location"
});

}

</script>

</head>

<body onload="initMap()">

<h1>Disaster Location Map</h1>

<div id="map"></div>

</body>

</html>