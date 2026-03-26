<%@ page import="java.sql.*" %>

<%

String name=request.getParameter("name");
String item=request.getParameter("item");
String quantity=request.getParameter("quantity");
String location=request.getParameter("location");
String contact=request.getParameter("contact");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/disaster_response",
"root",
"Akshara@123"
);

PreparedStatement ps=con.prepareStatement(
"INSERT INTO donations(donor_name,item,quantity,location,contact,status) VALUES(?,?,?,?,?,?)"
);

ps.setString(1,name);
ps.setString(2,item);
ps.setInt(3,Integer.parseInt(quantity));
ps.setString(4,location);
ps.setString(5,contact);
ps.setString(6,"Pending");

ps.executeUpdate();

%>

<script>

alert("Donation Registered Successfully!");

window.location="donation.jsp";

</script>