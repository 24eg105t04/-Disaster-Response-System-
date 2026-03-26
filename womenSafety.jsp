<%@ page import="java.sql.*" %>
<%
String msg="",msgType="";
if("POST".equals(request.getMethod())){
    String name=request.getParameter("name");
    String age=request.getParameter("age");
    String location=request.getParameter("location");
    String issue=request.getParameter("issue");
    String contact=request.getParameter("contact");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps=con.prepareStatement(
            "INSERT INTO women_safety(name,age,location,issue,contact) VALUES(?,?,?,?,?)");
        ps.setString(1,name);ps.setString(2,age);ps.setString(3,location);ps.setString(4,issue);ps.setString(5,contact);
        ps.executeUpdate(); con.close();
        msg="✅ Report submitted successfully."; msgType="success";
    }catch(Exception e){ msg="❌ Error: "+e.getMessage(); msgType="error"; }
}
Connection con=null; ResultSet rs=null;
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    rs=con.createStatement().executeQuery("SELECT * FROM women_safety ORDER BY id DESC");
}catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Women Safety</title>
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
    <a href="womenSafety.jsp" class="active"><span class="nav-icon"></span> Women Safety</a>
    <a href="shelters.jsp"><span class="nav-icon"></span> Safety Shelters</a>
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
      <div class="page-title">WOMEN <span>SAFETY</span></div>
      <div class="page-subtitle">Emergency support and safety reporting</div>
    </div>
  </div>
  <div style="padding:16px 20px;background:rgba(255,61,90,0.06);border:1px solid rgba(255,61,90,0.2);border-radius:10px;margin-bottom:25px;font-size:14px">
     Women Helpline: <strong style="color:var(--accent);font-family:'Orbitron',monospace">1091</strong>
    &nbsp;|&nbsp;
     National Emergency: <strong style="color:var(--accent);font-family:'Orbitron',monospace">112</strong>
  </div>
  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>"><%=msg%></div><% } %>
  <div style="display:grid;grid-template-columns:1fr 1.6fr;gap:25px;align-items:start">
    <div class="form-panel">
      <form method="POST">
        <div style="font-family:'Orbitron',monospace;font-size:13px;color:#ff6b85;letter-spacing:2px;margin-bottom:20px"> SUBMIT REPORT</div>
        <div class="form-row"><label>NAME</label><input type="text" name="name" placeholder="Full Name" required></div>
        <div class="form-row"><label>AGE</label><input type="number" name="age" placeholder="Age"></div>
        <div class="form-row"><label>LOCATION</label><input type="text" name="location" placeholder="Current Location" required></div>
        <div class="form-row"><label>CONTACT</label><input type="text" name="contact" placeholder="Phone number"></div>
        <div class="form-row"><label>ISSUE / CONCERN</label>
          <textarea name="issue" placeholder="Describe the situation..." required></textarea>
        </div>
        <button type="submit" class="btn" style="width:100%;background:linear-gradient(135deg,#8b0040,#cc0060);color:white;padding:12px;letter-spacing:1px">
           SUBMIT SAFETY REPORT
        </button>
      </form>
    </div>
    <div class="table-wrapper">
      <div class="table-header"><div class="table-title"> SAFETY REPORTS</div></div>
      <table>
        <thead><tr><th>ID</th><th>NAME</th><th>AGE</th><th>LOCATION</th><th>CONTACT</th></tr></thead>
        <tbody>
        <%
        try{
            boolean hasRows=false;
            while(rs!=null && rs.next()){
                hasRows=true;
        %>
        <tr>
          <td style="font-family:'Orbitron',monospace;color:var(--muted);font-size:12px">#<%=rs.getInt("id")%></td>
          <td style="font-weight:600"><%=rs.getString("name")%></td>
          <td><%=rs.getString("age")%></td>
          <td><%=rs.getString("location")%></td>
          <td style="font-family:'Orbitron',monospace;font-size:12px"><%=rs.getString("contact")%></td>
        </tr>
        <%
            }
            if(!hasRows){
        %>
        <tr><td colspan="5"><div class="empty-state"><div class="empty-icon"></div><p>NO REPORTS SUBMITTED</p></div></td></tr>
        <%
            }
        } catch(Exception e2){
            out.println("<tr><td colspan='5'>Error: "+e2.getMessage()+"</td></tr>");
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