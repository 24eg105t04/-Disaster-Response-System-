<%@ page import="java.sql.*" %>

<html>

<head>

<title>Relief Donations</title>

<style>

body{
background:#0f172a;
color:white;
font-family:Arial;
text-align:center;
}

table{
margin:auto;
border-collapse:collapse;
width:80%;
}

th,td{
border:1px solid white;
padding:10px;
}

th{
background:#1e293b;
}

</style>

</head>

<body>

<h1> Relief Donations</h1>

<table>

<tr>

<th>ID</th>
<th>Donor</th>
<th>Item</th>
<th>Quantity</th>
<th>Location</th>
<th>Status</th>

</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123"
);

Statement st=con.createStatement();

ResultSet rs=st.executeQuery("SELECT * FROM donations");

while(rs.next()){

%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("donor_name")%></td>
<td><%=rs.getString("item")%></td>
<td><%=rs.getInt("quantity")%></td>
<td><%=rs.getString("location")%></td>
<td><%=rs.getString("status")%></td>

</tr>

<%

}

%>

</table>

</body>

</html>