<%@ page import="java.sql.*" %>
<%
String id = request.getParameter("id");
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    PreparedStatement ps = con.prepareStatement("DELETE FROM disasters WHERE id=?");
    ps.setInt(1, Integer.parseInt(id));
    ps.executeUpdate(); con.close();
} catch(Exception e){ out.println("Error: "+e.getMessage()); }
response.sendRedirect("viewDisasters.jsp");
%>