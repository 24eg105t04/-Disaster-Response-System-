<%@ page import="java.sql.*" %>

<h2>Animal Rescue Centers</h2>

<table border="1">

<tr>
<th>ID</th>
<th>Center Name</th>
<th>Location</th>
<th>Contact</th>
<th>Capacity</th>
</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

Statement st = con.createStatement();

ResultSet rs = st.executeQuery("SELECT * FROM animal_rescue_centers");

while(rs.next()){

%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("center_name")%></td>
<td><%=rs.getString("location")%></td>
<td><%=rs.getString("contact")%></td>
<td><%=rs.getInt("capacity")%></td>

</tr>

<%
}
%>

</table>