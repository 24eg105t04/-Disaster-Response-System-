<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
// SESSION CHECK
if(session.getAttribute("user") == null){
    response.sendRedirect("index.jsp");
    return;
}
String loggedUser = (String) session.getAttribute("user");
String loggedRole = (String) session.getAttribute("role");
String fullName = (String) session.getAttribute("name");

Connection con = null;
Statement st = null;
ResultSet rs = null;

int totalDisasters = 0;
int mediumAlerts   = 0;
int criticalAlerts = 0;
boolean highAlert  = false;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/disaster_reports", "root", "Akshara@123");
    st = con.createStatement();

    rs = st.executeQuery("SELECT COUNT(*) FROM disasters");
    if (rs.next()) totalDisasters = rs.getInt(1);

    rs = st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='Medium'");
    if (rs.next()) mediumAlerts = rs.getInt(1);

    rs = st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='High'");
    if (rs.next()) { criticalAlerts = rs.getInt(1); if(criticalAlerts>0) highAlert=true; }

} catch (Exception e) {
    out.println("<!-- DB Error: " + e.getMessage() + " -->");
}

String now = new SimpleDateFormat("dd MMM yyyy  HH:mm:ss").format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Disaster Command Center</title>
<link rel="stylesheet" href="style.css">
<style>
.ticker-wrap {
  overflow:hidden; white-space:nowrap;
  background:rgba(0,200,255,0.06);
  border-top:1px solid var(--border);
  border-bottom:1px solid var(--border);
  padding:10px 0; margin-bottom:30px;
  font-size:13px; color:var(--accent);
  letter-spacing:1px; font-family:'Orbitron',monospace;
}
.ticker { display:inline-block; animation:ticker 25s linear infinite; }
@keyframes ticker { 0%{transform:translateX(100vw)} 100%{transform:translateX(-100%)} }
.clock { font-family:'Orbitron',monospace; font-size:12px; color:var(--muted); letter-spacing:2px; margin-left:auto; }
.feed-row-count { font-size:12px; color:var(--muted); font-family:'Orbitron',monospace; letter-spacing:1px; }
</style>
</head>
<body>

<div id="soundUnlock">
  <div class="unlock-icon"></div>
  <h2>COMMAND CENTER</h2>
  <p>Disaster Response &amp; Emergency Management</p>
  <button class="enter-btn"> ENTER SYSTEM</button>
</div>

<div id="flashOverlay"></div>
<div id="alertBanner"> HIGH SEVERITY DISASTER DETECTED — IMMEDIATE ACTION REQUIRED </div>
<button id="dismissBtn" onclick="dismissAlert()">✕ DISMISS</button>
<audio id="alertSound" loop>
  <source src="sounds/alert.mp3" type="audio/mpeg">
</audio>

<%@ include file="sidebar.jsp" %>

<div class="main">

  <div class="ticker-wrap">
    <span class="ticker">
       SYSTEM ACTIVE &nbsp;|&nbsp;
      TOTAL INCIDENTS: <%=totalDisasters%> &nbsp;|&nbsp;
      CRITICAL ALERTS: <%=criticalAlerts%> &nbsp;|&nbsp;
      MEDIUM ALERTS: <%=mediumAlerts%> &nbsp;|&nbsp;
      LAST UPDATED: <%=now%> &nbsp;|&nbsp;
      <%=highAlert ? " HIGH SEVERITY ACTIVE — UNITS DEPLOYED" : "NO CRITICAL THREATS"%>
      &nbsp;&nbsp;&nbsp;&nbsp;
    </span>
  </div>



<div class="page-header">

  <!-- LEFT SIDE -->
  <div>
    <div class="page-title">
      DISASTER <span>COMMAND</span> CENTER
    </div>

    <!--  WELCOME MESSAGE -->
    <div style="
      font-size:13px;
      color:#00ffc3;
      margin-top:6px;
      font-family:'Orbitron', monospace;
      letter-spacing:1px;
    ">
      Welcome!
    </div>

    <div class="page-subtitle">
      <span class="status-dot"></span>
      LIVE MONITORING ACTIVE &nbsp;|&nbsp; <%=now%>
    </div>
  </div>

  <!-- RIGHT SIDE -->
  <div style="display:flex; align-items:center; gap:15px; margin-left:auto;">

    <div class="clock" id="liveClock"></div>

    <!--  LOGOUT BUTTON -->
    <form action="logout.jsp" method="post">
      <button style="
        padding:6px 14px;
        font-size:12px;
        border-radius:6px;
        border:none;
        cursor:pointer;
        background:#ff4d6d;
        color:white;
        font-family:'Orbitron', monospace;
        letter-spacing:1px;
      ">
        LOGOUT
      </button>
    </form>

  </div>

</div>

  <div class="cards-grid">
    <div class="card">
      <div class="card-label">TOTAL INCIDENTS</div>
      <div class="card-value"><%=totalDisasters%></div>
      <div class="card-icon"></div>
    </div>
    <div class="card warning">
      <div class="card-label">MEDIUM ALERTS</div>
      <div class="card-value" style="color:#f0c040"><%=mediumAlerts%></div>
      <div class="card-icon"></div>
    </div>
    <div class="card danger <%=criticalAlerts>0?"critical-flash":""%>">
      <div class="card-label">CRITICAL ALERTS</div>
      <div class="card-value" style="color:#ff6b85"><%=criticalAlerts%></div>
      <div class="card-icon"></div>
    </div>
    <div class="card">
      <div class="card-label">LOW SEVERITY</div>
      <div class="card-value" style="color:#00e676"><%=totalDisasters-mediumAlerts-criticalAlerts%></div>
      <div class="card-icon"></div>
    </div>
  </div>

  <div class="table-wrapper">
    <div class="table-header">
      <div class="table-title"> LIVE DISASTER FEED</div>
      <div class="feed-row-count">RECORDS: <%=totalDisasters%></div>
    </div>
    <table>
      <thead>
        <tr>
          <th>ID</th><th>TYPE</th><th>LOCATION</th>
          <th>SEVERITY</th><th>DESCRIPTION</th><th>ACTION</th>
        </tr>
      </thead>
      <tbody>
      <%
      try {
          rs = st.executeQuery("SELECT * FROM disasters ORDER BY id DESC LIMIT 10");
          boolean hasRows = false;
          while (rs.next()) {
              hasRows = true;
              String sev = rs.getString("severity");
              String rowClass = sev.equalsIgnoreCase("High") ? "high-row" : "";
              String badgeClass = sev.equalsIgnoreCase("High") ? "badge-high" :
                                  sev.equalsIgnoreCase("Medium") ? "badge-medium" : "badge-low";
              String dot = sev.equalsIgnoreCase("High")?"":sev.equalsIgnoreCase("Medium")?"":"";
      %>
      <tr class="<%=rowClass%>">
        <td style="font-family:'Orbitron',monospace;color:var(--muted)">#<%=rs.getInt("id")%></td>
        <td style="font-weight:600"><%=rs.getString("type")%></td>
        <td><%=rs.getString("location")%></td>
        <td><span class="badge <%=badgeClass%>"><%=dot%> <%=sev.toUpperCase()%></span></td>
        <td style="color:var(--muted)"><%=rs.getString("description")%></td>
        <td><a href="viewDisasters.jsp" class="btn btn-primary" style="padding:6px 14px;font-size:12px">VIEW ALL</a></td>
      </tr>
      <%
          }
          if(!hasRows) {
      %>
      <tr><td colspan="6">
        <div class="empty-state">
          <div class="empty-icon"></div>
          <p>NO DISASTER RECORDS FOUND</p>
        </div>
      </td></tr>
      <%
          }
      } catch(Exception e) {
          out.println("<tr><td colspan='6' style='color:var(--accent2);padding:20px'>Feed Error: "+e.getMessage()+"</td></tr>");
      } finally {
          if(con!=null) try{con.close();}catch(Exception ignored){}
      }
      %>
      </tbody>
    </table>
  </div>

</div>

<script>
function updateClock(){
  var d=new Date();
  document.getElementById('liveClock').textContent=
    d.toLocaleDateString('en-IN',{day:'2-digit',month:'short',year:'numeric'})+
    '  '+d.toLocaleTimeString('en-IN',{hour12:false});
}
setInterval(updateClock,1000); updateClock();

var reloadInterval = setInterval(function(){ location.reload(); }, 30000);
var highAlert = <%=highAlert%>;

function dismissAlert(){
  document.getElementById('flashOverlay').style.display='none';
  document.getElementById('alertBanner').style.display='none';
  document.getElementById('dismissBtn').style.display='none';
  document.getElementById('alertSound').pause();
  document.getElementById('alertSound').currentTime=0;
  clearInterval(reloadInterval);
}

function triggerAlerts(){
  document.getElementById('flashOverlay').style.display='block';
  document.getElementById('alertBanner').style.display='block';
  document.getElementById('dismissBtn').style.display='block';
  var s=document.getElementById('alertSound');
  s.volume=1.0; s.play();
  setTimeout(function(){ document.getElementById('flashOverlay').style.display='none'; },10000);
}

document.getElementById('soundUnlock').addEventListener('click', function(){
  this.style.display='none';
  if(highAlert) triggerAlerts();
});
</script>
</body>
</html>