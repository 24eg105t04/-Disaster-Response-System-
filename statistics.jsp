<%@ page import="java.sql.*" %>
<%
int total=0,high=0,med=0,low=0,flood=0,earthquake=0,cyclone=0,fire=0,landslide=0,other=0;
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    Statement st=con.createStatement(); ResultSet rs;
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters"); if(rs.next()) total=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='High'"); if(rs.next()) high=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='Medium'"); if(rs.next()) med=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE severity='Low'"); if(rs.next()) low=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE type='Flood'"); if(rs.next()) flood=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE type='Earthquake'"); if(rs.next()) earthquake=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE type='Cyclone'"); if(rs.next()) cyclone=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE type='Fire'"); if(rs.next()) fire=rs.getInt(1);
    rs=st.executeQuery("SELECT COUNT(*) FROM disasters WHERE type='Landslide'"); if(rs.next()) landslide=rs.getInt(1);
    other=total-flood-earthquake-cyclone-fire-landslide;
    con.close();
}catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Statistics</title>
<link rel="stylesheet" href="style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
.chart-panel { background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:25px;backdrop-filter:blur(10px); }
.chart-title { font-family:'Orbitron',monospace;font-size:12px;color:var(--accent);letter-spacing:2px;margin-bottom:20px; }
.charts-grid { display:grid;grid-template-columns:1fr 1fr;gap:25px;margin-top:25px; }
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
    <a href="statistics.jsp" class="active"><span class="nav-icon"></span> Statistics</a>
    <a href="sos.jsp"><span class="nav-icon"></span> SOS Emergency</a>
  </nav>
  <div class="sidebar-footer"><span class="status-dot"></span> SYSTEM ONLINE</div>
</div>

<div class="main">
  <div class="page-header">
    <a href="dashboard.jsp" class="back-btn">← BACK</a>
    <div>
      <div class="page-title">DISASTER <span>ANALYTICS</span></div>
      <div class="page-subtitle">Visual insights and live statistics</div>
    </div>
  </div>
  <div class="cards-grid">
    <div class="card"><div class="card-label">TOTAL</div><div class="card-value"><%=total%></div><div class="card-icon"></div></div>
    <div class="card danger"><div class="card-label">HIGH</div><div class="card-value" style="color:#ff6b85"><%=high%></div><div class="card-icon"></div></div>
    <div class="card warning"><div class="card-label">MEDIUM</div><div class="card-value" style="color:#f0c040"><%=med%></div><div class="card-icon"></div></div>
    <div class="card"><div class="card-label">LOW</div><div class="card-value" style="color:#00e676"><%=low%></div><div class="card-icon"></div></div>
  </div>
  <div class="charts-grid">
    <div class="chart-panel">
      <div class="chart-title"> SEVERITY DISTRIBUTION</div>
      <canvas id="severityChart" height="220"></canvas>
    </div>
    <div class="chart-panel">
      <div class="chart-title"> DISASTER TYPES</div>
      <canvas id="typeChart" height="220"></canvas>
    </div>
  </div>
</div>

<script>
Chart.defaults.color='#4a7090';
Chart.defaults.borderColor='rgba(0,200,255,0.08)';
new Chart(document.getElementById('severityChart'),{
  type:'doughnut',
  data:{
    labels:['HIGH','MEDIUM','LOW'],
    datasets:[{
      data:[<%=high%>,<%=med%>,<%=low%>],
      backgroundColor:['rgba(255,61,90,0.7)','rgba(240,192,64,0.7)','rgba(0,230,118,0.7)'],
      borderColor:['#ff3d5a','#f0c040','#00e676'],borderWidth:2
    }]
  },
  options:{ plugins:{legend:{labels:{font:{family:'Rajdhani',size:13},color:'#cde8ff'}}},cutout:'65%' }
});
new Chart(document.getElementById('typeChart'),{
  type:'bar',
  data:{
    labels:['Flood','Earthquake','Cyclone','Fire','Landslide','Other'],
    datasets:[{
      label:'Incidents',
      data:[<%=flood%>,<%=earthquake%>,<%=cyclone%>,<%=fire%>,<%=landslide%>,<%=other%>],
      backgroundColor:['rgba(0,200,255,0.5)','rgba(255,61,90,0.5)','rgba(240,192,64,0.5)','rgba(255,120,0,0.5)','rgba(150,100,50,0.5)','rgba(100,150,200,0.5)'],
      borderColor:['#00c8ff','#ff3d5a','#f0c040','#ff7800','#966432','#6496c8'],
      borderWidth:1,borderRadius:6
    }]
  },
  options:{
    plugins:{legend:{display:false}},
    scales:{
      x:{ticks:{font:{family:'Rajdhani'},color:'#4a7090'}},
      y:{ticks:{font:{family:'Orbitron',size:10},color:'#4a7090'},beginAtZero:true}
    }
  }
});
</script>
</body>
</html>