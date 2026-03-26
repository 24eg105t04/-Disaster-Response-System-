<%@ page import="java.sql.*" %>
<%
String msg="",msgType="";
if("POST".equals(request.getMethod())){
    String name=request.getParameter("name");
    String phone=request.getParameter("phone");
    String location=request.getParameter("location");
    String emergency=request.getParameter("emergency");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps=con.prepareStatement(
            "INSERT INTO sos_alerts(name,phone,location,emergency_type) VALUES(?,?,?,?)");
        ps.setString(1,name);ps.setString(2,phone);ps.setString(3,location);ps.setString(4,emergency);
        ps.executeUpdate(); con.close();
        msg="🆘 SOS Alert sent! Help is on the way."; msgType="success";
    }catch(Exception e){ msg=" Error: "+e.getMessage(); msgType="error"; }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SOS Emergency</title>
<link rel="stylesheet" href="style.css">
<style>
.sos-hero {
  text-align:center; padding:40px 20px; margin-bottom:30px;
  background:rgba(255,61,90,0.06); border:1px solid rgba(255,61,90,0.2);
  border-radius:16px; position:relative; overflow:hidden;
}
.sos-hero::before {
  content:''; position:absolute; inset:0;
  background:radial-gradient(circle at center,rgba(255,61,90,0.08) 0%,transparent 70%);
  animation:sosPulse 2s ease-in-out infinite;
}
@keyframes sosPulse { 0%,100%{opacity:0.5} 50%{opacity:1} }
.sos-btn-big {
  display:inline-block; width:130px; height:130px; line-height:130px;
  border-radius:50%; font-size:46px;
  background:radial-gradient(circle,#cc0000,#8b0000);
  box-shadow:0 0 0 10px rgba(255,61,90,0.2),0 0 0 20px rgba(255,61,90,0.1);
  animation:sosBtnPulse 1.5s ease-in-out infinite;
  margin-bottom:20px;
}
@keyframes sosBtnPulse {
  0%,100%{box-shadow:0 0 0 10px rgba(255,61,90,0.2),0 0 0 20px rgba(255,61,90,0.1)}
  50%{box-shadow:0 0 0 15px rgba(255,61,90,0.3),0 0 0 30px rgba(255,61,90,0.15)}
}
</style>
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
    <a href="shelters.jsp"><span class="nav-icon"></span> Safety Shelters</a>
    <a href="donation.jsp"><span class="nav-icon"></span> Donations</a>
    <div class="nav-section">ANALYTICS</div>
    <a href="disasterMap.jsp"><span class="nav-icon"></span> Live Map</a>
    <a href="statistics.jsp"><span class="nav-icon"></span> Statistics</a>
    <a href="sos.jsp" class="active"><span class="nav-icon"></span> SOS Emergency</a>
  </nav>
  <div class="sidebar-footer"><span class="status-dot"></span> SYSTEM ONLINE</div>
</div>

<div class="main">
  <div class="page-header">
    <a href="dashboard.jsp" class="back-btn"> BACK</a>
    <div>
      <div class="page-title">SOS <span>EMERGENCY</span></div>
      <div class="page-subtitle">Immediate emergency alert system</div>
    </div>
  </div>

  <div class="sos-hero">
    <div class="sos-btn-big"></div>
    <h2 style="font-family:'Orbitron',monospace;font-size:22px;color:#ff6b85;letter-spacing:3px;margin-bottom:10px">EMERGENCY SOS</h2>
    <p style="color:var(--muted);font-size:14px">Fill the form below to send an immediate distress signal</p>
  </div>

  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>" style="max-width:700px"><%=msg%></div><% } %>

  <div class="form-panel" style="max-width:700px;border-color:rgba(255,61,90,0.3)">
    <form method="POST">
      <div style="font-family:'Orbitron',monospace;font-size:13px;color:#ff6b85;letter-spacing:2px;margin-bottom:20px">SEND SOS ALERT</div>
      <div class="form-grid">
        <div class="form-row"><label>YOUR NAME</label><input type="text" name="name" placeholder="Full Name" required></div>
        <div class="form-row"><label>PHONE NUMBER</label><input type="text" name="phone" placeholder="Emergency contact" required></div>
      </div>
      <div class="form-row"><label>YOUR LOCATION</label><input type="text" name="location" placeholder="Describe your exact location" required></div>
      <div class="form-row"><label>EMERGENCY TYPE</label>
        <select name="emergency">
          <option>Flood Trapped</option><option>Building Collapse</option>
          <option>Medical Emergency</option><option>Fire</option>
          <option>Landslide</option><option>Other</option>
        </select>
      </div>
      <button type="submit" class="btn" style="width:100%;background:linear-gradient(135deg,#8b0000,#cc0000);color:white;padding:14px;font-size:15px;letter-spacing:2px;font-family:'Orbitron',monospace">
         SEND EMERGENCY ALERT
      </button>
    </form>
  </div>

  <div style="margin-top:25px;padding:20px;background:rgba(255,61,90,0.05);border:1px solid rgba(255,61,90,0.15);border-radius:12px;max-width:700px">
    <div style="font-family:'Orbitron',monospace;font-size:12px;color:#ff6b85;letter-spacing:2px;margin-bottom:12px"> EMERGENCY HELPLINES</div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:14px">
      <div> National Emergency: <strong style="color:var(--accent)">112</strong></div>
      <div> Ambulance: <strong style="color:var(--accent)">108</strong></div>
      <div> Fire: <strong style="color:var(--accent)">101</strong></div>
      <div> Police: <strong style="color:var(--accent)">100</strong></div>
      <div> Disaster Mgmt: <strong style="color:var(--accent)">1078</strong></div>
      <div> Women Helpline: <strong style="color:var(--accent)">1091</strong></div>
    </div>
  </div>
</div>
</body>
</html>