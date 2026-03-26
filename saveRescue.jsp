<%@ page import="java.sql.*" %>

<%

String id=request.getParameter("id");
String team=request.getParameter("team");
String status=request.getParameter("status");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

PreparedStatement ps=con.prepareStatement(
"UPDATE disasters SET rescue_team=?, status=? WHERE id=?");

ps.setString(1,team);
ps.setString(2,status);
ps.setInt(3,Integer.parseInt(id));

ps.executeUpdate();

response.sendRedirect("viewDisasters.jsp");

%>