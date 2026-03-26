<%@ page import="java.sql.*" %>
<%
String name     = request.getParameter("name");
String username = request.getParameter("username");
String email    = request.getParameter("email");
String password = request.getParameter("password");
String role     = request.getParameter("role");

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");

    // Check if username already exists
    PreparedStatement check = con.prepareStatement(
        "SELECT * FROM users WHERE username=?");
    check.setString(1, username);
    ResultSet rs = check.executeQuery();

    if(rs.next()){
        out.print("Username already exists. Please choose another.");
        con.close();
        return;
    }

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO users(name,username,email,password,role) VALUES(?,?,?,?,?)");
    ps.setString(1,name);
    ps.setString(2,username);
    ps.setString(3,email);
    ps.setString(4,password);
    ps.setString(5,role);
    ps.executeUpdate();
    con.close();
    out.print("success");

}catch(Exception e){
    out.print("Error: "+e.getMessage());
}
%>