<%@ page import="java.sql.*" %>

<html>

<body>

<h2>Women Safety Reports</h2>

<table border="1">

<tr>
<th>ID</th>
<th>Name</th>
<th>Location</th>
<th>Issue</th>
<th>Status</th>
<th>Time</th>
</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

Statement st=con.createStatement();

ResultSet rs=st.executeQuery("SELECT * FROM women_safety_reports");

while(rs.next()){
%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("name")%></td>
<td><%=rs.getString("location")%></td>
<td><%=rs.getString("issue")%></td>
<td><%=rs.getString("status")%></td>
<td><%=rs.getString("report_time")%></td>

</tr>

<% } %>

</table>

</body>

</html>