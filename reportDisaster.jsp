<%@ page import="java.sql.*" %>
<%
String msg = "", msgType = "";
if("POST".equals(request.getMethod())){
    String type     = request.getParameter("type");
    String location = request.getParameter("location");
    String severity = request.getParameter("severity");
    String desc     = request.getParameter("description");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO disasters(type,location,severity,description) VALUES(?,?,?,?)");
        ps.setString(1,type); ps.setString(2,location);
        ps.setString(3,severity); ps.setString(4,desc);
        ps.executeUpdate(); con.close();
        msg=" Disaster reported successfully."; msgType="success";
    } catch(Exception e){ msg="Error: "+e.getMessage(); msgType="error"; }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Report Disaster</title>
<link rel="stylesheet" href="style.css">
<style>
.severity-pills { display:flex; gap:12px; flex-wrap:wrap; }
.severity-pill {
  flex:1; min-width:120px; padding:12px 16px; border-radius:10px;
  border:2px solid var(--border); background:rgba(0,200,255,0.04);
  color:var(--muted); font-size:13px; font-weight:600; cursor:pointer;
  text-align:center; transition:all 0.3s; font-family:'Rajdhani',sans-serif; letter-spacing:1px;
}
.severity-pill:hover { border-color:var(--accent); color:var(--accent); }
.severity-pill input { display:none; }
.severity-pill.low:has(input:checked)  { border-color:#00e676; background:rgba(0,230,118,0.1); color:#00e676; }
.severity-pill.med:has(input:checked)  { border-color:#f0c040; background:rgba(240,192,64,0.1); color:#f0c040; }
.severity-pill.high:has(input:checked) { border-color:#ff6b85; background:rgba(255,61,90,0.12); color:#ff6b85; }
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
    <a href="reportDisaster.jsp" class="active"><span class="nav-icon"></span> Report Disaster</a>
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
    <a href="sos.jsp"><span class="nav-icon"></span> SOS Emergency</a>
  </nav>
  <div class="sidebar-footer"><span class="status-dot"></span> SYSTEM ONLINE</div>
</div>

<div class="main">
  <div class="page-header">
    <a href="dashboard.jsp" class="back-btn">← BACK</a>
    <div>
      <div class="page-title">REPORT <span>DISASTER</span></div>
      <div class="page-subtitle">Log a new disaster incident into the system</div>
    </div>
  </div>

  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>"><%=msg%></div><% } %>

  <div class="form-panel">
    <form method="POST" action="reportDisaster.jsp">
      <div class="form-grid">
        <div class="form-row">
          <label>DISASTER TYPE</label>
          <select name="type" required>
            <option value="">— Select Type —</option>
            <option>Flood</option><option>Earthquake</option>
            <option>Cyclone</option><option>Landslide</option>
            <option>Fire</option><option>Drought</option>
            <option>Tsunami</option><option>Other</option>
          </select>
        </div>
        <div class="form-row">
          <label>LOCATION</label>
          <input type="text" name="location" placeholder="e.g. Hyderabad, Telangana" required>
        </div>
      </div>
      <div class="form-row">
        <label>SEVERITY LEVEL</label>
        <div class="severity-pills">
          <label class="severity-pill low"><input type="radio" name="severity" value="Low" required> LOW</label>
          <label class="severity-pill med"><input type="radio" name="severity" value="Medium"> MEDIUM</label>
          <label class="severity-pill high"><input type="radio" name="severity" value="High"> HIGH</label>
        </div>
      </div>
      <div class="form-row">
        <label>DESCRIPTION</label>
        <textarea name="description" placeholder="Describe the disaster, affected areas, casualties..." required></textarea>
      </div>
      <div style="display:flex;gap:15px;align-items:center;flex-wrap:wrap">
        <button type="submit" class="btn btn-success">📡 SUBMIT REPORT</button>
        <a href="viewDisasters.jsp" class="btn btn-primary"> VIEW ALL</a>
        <button type="reset" class="btn" style="background:rgba(255,255,255,0.05);border:1px solid var(--border);color:var(--muted)">↺ CLEAR</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>