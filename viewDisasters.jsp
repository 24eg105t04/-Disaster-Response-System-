<%@ page import="java.sql.*" %>
<%
Connection con = null; Statement st = null; ResultSet rs = null;
int total=0,high=0,med=0,low=0;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    st = con.createStatement();
    ResultSet rc;
    rc=st.executeQuery("SELECT COUNT(*) FROM disasters"); if(rc.next()) total=rc.getInt(1);
    rc=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='High'"); if(rc.next()) high=rc.getInt(1);
    rc=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='Medium'"); if(rc.next()) med=rc.getInt(1);
    rc=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='Low'"); if(rc.next()) low=rc.getInt(1);
    rs=st.executeQuery("SELECT * FROM disasters ORDER BY id DESC");
} catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>View Disasters</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<div id="overlay" onclick="cancelDelete()"></div>
<div id="confirmBox">
  <div class="confirm-icon"></div>
  <h3>CONFIRM DELETION</h3>
  <p>This record will be permanently removed.</p>
  <div class="confirm-btns">
    <button class="btn btn-danger" onclick="confirmDelete()">YES, DELETE</button>
    <button class="btn" style="background:rgba(255,255,255,0.05);border:1px solid var(--border);color:var(--muted)" onclick="cancelDelete()">CANCEL</button>
  </div>
</div>

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
    <a href="viewDisasters.jsp" class="active"><span class="nav-icon"></span> View Disasters</a>
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
      <div class="page-title">DISASTER <span>REGISTRY</span></div>
      <div class="page-subtitle">All reported disaster incidents</div>
    </div>
    <div style="margin-left:auto">
      <a href="reportDisaster.jsp" class="btn btn-success">+ REPORT NEW</a>
    </div>
  </div>

  <div class="cards-grid" style="margin-bottom:25px">
    <div class="card"><div class="card-label">TOTAL</div><div class="card-value"><%=total%></div><div class="card-icon"></div></div>
    <div class="card danger"><div class="card-label">HIGH</div><div class="card-value" style="color:#ff6b85"><%=high%></div><div class="card-icon"></div></div>
    <div class="card warning"><div class="card-label">MEDIUM</div><div class="card-value" style="color:#f0c040"><%=med%></div><div class="card-icon"></div></div>
    <div class="card"><div class="card-label">LOW</div><div class="card-value" style="color:#00e676"><%=low%></div><div class="card-icon"></div></div>
  </div>

  <div class="table-wrapper">
    <div class="table-header">
      <div class="table-title"> ALL REPORTED DISASTERS</div>
      <span style="font-size:12px;color:var(--muted);font-family:'Orbitron',monospace"><%=total%> RECORDS</span>
    </div>
    <table>
      <thead>
        <tr><th>ID</th><th>TYPE</th><th>LOCATION</th><th>SEVERITY</th><th>DESCRIPTION</th><th>ACTION</th></tr>
      </thead>
      <tbody>
      <%
      try {
          boolean hasRows=false;
          while(rs!=null && rs.next()){
              hasRows=true;
              String sev=rs.getString("severity");
              String rowClass=sev.equalsIgnoreCase("High")?"high-row":"";
              String badgeClass=sev.equalsIgnoreCase("High")?"badge-high":sev.equalsIgnoreCase("Medium")?"badge-medium":"badge-low";
              String dot=sev.equalsIgnoreCase("High")?"":sev.equalsIgnoreCase("Medium")?"":"";
      %>
      <tr class="<%=rowClass%>">
        <td style="font-family:'Orbitron',monospace;color:var(--muted);font-size:12px">#<%=rs.getInt("id")%></td>
        <td style="font-weight:600"><%=rs.getString("type")%></td>
        <td><%=rs.getString("location")%></td>
        <td><span class="badge <%=badgeClass%>"><%=dot%> <%=sev.toUpperCase()%></span></td>
        <td style="color:var(--muted)"><%=rs.getString("description")%></td>
        <td><button class="btn btn-danger" style="padding:6px 14px;font-size:12px" onclick="askDelete(<%=rs.getInt("id")%>)"> REMOVE</button></td>
      </tr>
      <%
          }
          if(!hasRows){
      %>
      <tr><td colspan="6"><div class="empty-state"><div class="empty-icon"></div><p>NO RECORDS FOUND</p></div></td></tr>
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

<script>
var deleteId=null;
function askDelete(id){ deleteId=id; document.getElementById('confirmBox').style.display='block'; document.getElementById('overlay').style.display='block'; }
function cancelDelete(){ deleteId=null; document.getElementById('confirmBox').style.display='none'; document.getElementById('overlay').style.display='none'; }
function confirmDelete(){ if(deleteId!==null) window.location.href='deleteDisaster.jsp?id='+deleteId; }
</script>
</body>
</html>