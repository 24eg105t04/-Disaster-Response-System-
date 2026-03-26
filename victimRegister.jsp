<%@ page import="java.sql.*" %>
<%
Connection con=null; Statement st=null; ResultSet rs=null;
String msg="",msgType="";
if("POST".equals(request.getMethod())){
    String name=request.getParameter("name");
    String age=request.getParameter("age");
    String gender=request.getParameter("gender");
    String location=request.getParameter("location");
    String status=request.getParameter("status");
    String contact=request.getParameter("contact");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps=con.prepareStatement(
            "INSERT INTO victims(name,age,gender,location,status,contact) VALUES(?,?,?,?,?,?)");
        ps.setString(1,name);ps.setString(2,age);ps.setString(3,gender);
        ps.setString(4,location);ps.setString(5,status);ps.setString(6,contact);
        ps.executeUpdate(); con.close();
        msg=" Victim registered."; msgType="success";
    }catch(Exception e){ msg=" Error: "+e.getMessage(); msgType="error"; }
}
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    st=con.createStatement();
    rs=st.executeQuery("SELECT * FROM victims ORDER BY id DESC");
}catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Victim Registry</title>
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
    <a href="victimRegister.jsp" class="active"><span class="nav-icon"></span> Victims</a>
    <div class="nav-section">SUPPORT</div>
    <a href="womenSafety.jsp"><span class="nav-icon"></span> Women Safety</a>
    <a href="shelters.jsp"><span class="nav-icon"></span> Safety Shelters</a>
    <a href="donation.jsp"><span class="nav-icon"></span> Donations</a>
    <div class="nav-section">ANALYTICS</div>
    <a href="disasterMap.jsp"><span class="nav-icon"></span> Live Map</a>
    <a href="statistics.jsp"><span class="nav-icon"></span> Statistics</a>
    <a href="sos.jsp"><span class="nav-icon">🆘</span> SOS Emergency</a>
  </nav>
  <div class="sidebar-footer"><span class="status-dot"></span> SYSTEM ONLINE</div>
</div>

<div class="main">
  <div class="page-header">
    <a href="dashboard.jsp" class="back-btn">← BACK</a>
    <div>
      <div class="page-title">VICTIM <span>REGISTRY</span></div>
      <div class="page-subtitle">Register and track affected individuals</div>
    </div>
  </div>
  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>"><%=msg%></div><% } %>
  <div style="display:grid;grid-template-columns:1fr 1.8fr;gap:25px;align-items:start">
    <div class="form-panel">
      <form method="POST">
        <div style="font-family:'Orbitron',monospace;font-size:13px;color:var(--accent);letter-spacing:2px;margin-bottom:20px">+ REGISTER VICTIM</div>
        <div class="form-row"><label>FULL NAME</label><input type="text" name="name" placeholder="Full Name" required></div>
        <div class="form-grid">
          <div class="form-row"><label>AGE</label><input type="number" name="age" placeholder="Age" min="0" max="120"></div>
          <div class="form-row"><label>GENDER</label>
            <select name="gender"><option>Male</option><option>Female</option><option>Other</option></select>
          </div>
        </div>
        <div class="form-row"><label>LOCATION FOUND</label><input type="text" name="location" placeholder="e.g. Warangal Relief Camp" required></div>
        <div class="form-row"><label>CONTACT</label><input type="text" name="contact" placeholder="Emergency contact"></div>
        <div class="form-row"><label>STATUS</label>
          <select name="status">
            <option value="Safe"> Safe</option>
            <option value="Injured"> Injured</option>
            <option value="Missing"> Missing</option>
            <option value="Critical"> Critical</option>
          </select>
        </div>
        <button type="submit" class="btn btn-success" style="width:100%"> REGISTER</button>
      </form>
    </div>
    <div class="table-wrapper">
      <div class="table-header"><div class="table-title"> VICTIM RECORDS</div></div>
      <table>
        <thead><tr><th>ID</th><th>NAME</th><th>AGE</th><th>LOCATION</th><th>CONTACT</th><th>STATUS</th></tr></thead>
        <tbody>
        <%
        try{
            boolean hasRows=false;
            while(rs!=null && rs.next()){
                hasRows=true;
                String status=rs.getString("status");
                String sColor=status.equals("Safe")?"#00e676":status.equals("Missing")?"#ff6b85":status.equals("Critical")?"#aaa":"#f0c040";
        %>
        <tr>
          <td style="font-family:'Orbitron',monospace;color:var(--muted);font-size:12px">#<%=rs.getInt("id")%></td>
          <td style="font-weight:600"><%=rs.getString("name")%></td>
          <td><%=rs.getString("age")%></td>
          <td><%=rs.getString("location")%></td>
          <td style="font-family:'Orbitron',monospace;font-size:12px"><%=rs.getString("contact")%></td>
          <td><span class="badge" style="color:<%=sColor%>;border-color:<%=sColor%>;background:transparent"><%=status.toUpperCase()%></span></td>
        </tr>
        <%
            }
            if(!hasRows){
        %>
        <tr><td colspan="6"><div class="empty-state"><div class="empty-icon"></div><p>NO VICTIMS REGISTERED</p></div></td></tr>
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