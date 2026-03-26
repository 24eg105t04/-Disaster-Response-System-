<%@ page import="java.sql.*" %>

<%

String type=request.getParameter("type");
String location=request.getParameter("location");
String severity=request.getParameter("severity");
String description=request.getParameter("description");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disasterdb",
"root",
"Akshara@123"
);

PreparedStatement ps=con.prepareStatement(
"insert into disasters(type,location,severity,description) values(?,?,?,?)"
);

ps.setString(1,type);
ps.setString(2,location);
ps.setString(3,severity);
ps.setString(4,description);

ps.executeUpdate();

response.sendRedirect("viewDisasters.jsp");

}

catch(Exception e){
out.println(e);
}

%>