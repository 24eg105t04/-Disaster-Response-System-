<%@ page import="java.sql.*" %>

<%

String name=request.getParameter("name");

String location=request.getParameter("location");

String issue=request.getParameter("issue");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

PreparedStatement ps=con.prepareStatement(
"INSERT INTO women_safety_reports(name,location,issue,status) VALUES(?,?,?,?)");

ps.setString(1,name);
ps.setString(2,location);
ps.setString(3,issue);
ps.setString(4,"Pending");

ps.executeUpdate();

%>

<script>

alert("Report submitted successfully!");

window.location="womenSafety.jsp";

</script>