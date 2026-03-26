<%@ page import="java.sql.*" %>
<%
String msg="",msgType="";
if("POST".equals(request.getMethod())){
    String name=request.getParameter("name");
    String location=request.getParameter("location");
    String capacity=request.getParameter("capacity");
    String contact=request.getParameter("contact");
    String status=request.getParameter("status");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps=con.prepareStatement(
            "INSERT INTO shelters(name,location,capacity,contact,status) VALUES(?,?,?,?,?)");
        ps.setString(1,name);ps.setString(2,location);ps.setString(3,capacity);ps.setString(4,contact);ps.setString(5,status);
        ps.executeUpdate(); con.close();
        msg="✅ Shelter registered."; msgType="success";
    }catch(Exception e){ msg="❌ Error: "+e.getMessage(); msgType="error"; }
}
Connection con=null; ResultSet rs=null;
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    rs=con.createStatement().executeQuery("SELECT * FROM shelters ORDER BY id DESC");
}catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Safety Shelters</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<div class="sidebar">
  <div class="sidebar-logo">
    <span class="logo-icon"></span>
    <h2>DISASTER<br>RESPONSE</h2>
    <span>COMMAND CENTER</span>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">MAIN</div>
    <a href="dashboard.jsp"><span class="nav-icon"></span> Dashboard</a>
    <div class="nav-section">OPERATIONS</div>
    <a href="reportDisaster.jsp"><span class="nav-icon"></span> Report Disaster</a>
    <a href="viewDisasters.jsp"><span class="nav-icon"></span> View Disasters</a>
    <a href="rescueTeams.jsp"><span class="nav-icon"></span> Rescue Teams</a>
    <a href="victimRegister.jsp"><span class="nav-icon"></span> Victims</a>
    <div class="nav-section">SUPPORT</div>
    <a href="womenSafety.jsp"><span class="nav-icon"></span> Women Safety</a>
    <a href="shelters.jsp" class="active"><span class="nav-icon"></span> Safety Shelters</a>
    <a href="donation.jsp"><span class="nav-icon"></span> Donations</a>
    <div class="nav-section">ANALYTICS</div>
    <a href="disasterMap.jsp"><span class="nav-icon"></span> Live Map</a>
    <a href="statistics.jsp"><span class="nav-icon"></span> Statistics</a>
    <a href="sos.jsp"><span class="nav-icon"></span> SOS Emergency</a>
  </nav>
  <div class="sidebar-footer"><span class="status-dot"></span> SYSTEM ONLINE</div>
</div>

<div class="main">
  <div class="page-header">
    <a href="dashboard.jsp" class="back-btn">← BACK</a>
    <div>
      <div class="page-title">SAFETY <span>SHELTERS</span></div>
      <div class="page-subtitle">Register and manage relief shelter locations</div>
    </div>
  </div>
  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>"><%=msg%></div><% } %>
  <div style="display:grid;grid-template-columns:1fr 1.6fr;gap:25px;align-items:start">
    <div class="form-panel">
      <form method="POST">
        <div style="font-family:'Orbitron',monospace;font-size:13px;color:var(--accent);letter-spacing:2px;margin-bottom:20px"> ADD SHELTER</div>
        <div class="form-row"><label>SHELTER NAME</label><input type="text" name="name" placeholder="e.g. City Relief Camp" required></div>
        <div class="form-row"><label>LOCATION</label><input type="text" name="location" placeholder="Full address" required></div>
        <div class="form-row"><label>CAPACITY (persons)</label><input type="number" name="capacity" placeholder="e.g. 500" required></div>
        <div class="form-row"><label>CONTACT NUMBER</label><input type="text" name="contact" placeholder="In-charge number"></div>
        <div class="form-row"><label>STATUS</label>
          <select name="status">
            <option value="Open"> Open</option>
            <option value="Full"> Full</option>
            <option value="Closed"> Closed</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary" style="width:100%"> REGISTER SHELTER</button>
      </form>
    </div>
    <div class="table-wrapper">
      <div class="table-header"><div class="table-title"> SHELTER LOCATIONS</div></div>
      <table>
        <thead><tr><th>ID</th><th>NAME</th><th>LOCATION</th><th>CAPACITY</th><th>CONTACT</th><th>STATUS</th></tr></thead>
        <tbody>
        <%
        try{
            boolean hasRows=false;
            while(rs!=null && rs.next()){
                hasRows=true;
                String status=rs.getString("status");
                String sColor=status.equals("Open")?"#00e676":status.equals("Full")?"#ff6b85":"#4a7090";
        %>
        <tr>
          <td style="font-family:'Orbitron',monospace;color:var(--muted);font-size:12px">#<%=rs.getInt("id")%></td>
          <td style="font-weight:600"><%=rs.getString("name")%></td>
          <td><%=rs.getString("location")%></td>
          <td style="font-family:'Orbitron',monospace;color:var(--accent)"><%=rs.getString("capacity")%></td>
          <td style="font-size:12px"><%=rs.getString("contact")%></td>
          <td><span class="badge" style="color:<%=sColor%>;border-color:<%=sColor%>;background:transparent"><%=status.toUpperCase()%></span></td>
        </tr>
        <%
            }
            if(!hasRows){
        %>
        <tr><td colspan="6"><div class="empty-state"><div class="empty-icon"></div><p>NO SHELTERS REGISTERED</p></div></td></tr>
        <%
            }
        } catch(Exception e2){
            out.println("<tr><td colspan='6'>Error: "+e2.getMessage()+"</td></tr>");
        } finally {
            if(con!=null) try{con.close();}catch(Exception ignored){}
        }
        %>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>