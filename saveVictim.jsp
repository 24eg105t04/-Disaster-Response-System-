<%@ page import="java.sql.*" %>

<%

String name = request.getParameter("name");
String ageStr = request.getParameter("age");
String location = request.getParameter("location");
String status = request.getParameter("status");

int age = 0;

if(ageStr != null && !ageStr.equals("")){
    age = Integer.parseInt(ageStr);
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123");

PreparedStatement ps = con.prepareStatement(
"INSERT INTO victims(name,age,location,status) VALUES(?,?,?,?)"
);

ps.setString(1,name);
ps.setInt(2,age);
ps.setString(3,location);
ps.setString(4,status);

ps.executeUpdate();

%>

<script>
alert("Victim Registered Successfully");
window.location="victimRegister.jsp";
</script>