<%@ page import="java.sql.*" %>

<%
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

PreparedStatement ps = con.prepareStatement(
"INSERT INTO users(name,email,password) VALUES(?,?,?)");

ps.setString(1,name);
ps.setString(2,email);
ps.setString(3,password);

ps.executeUpdate();

out.println("User Registered Successfully!");

}catch(Exception e){
out.println(e);
}
%>