<%@ page import="java.sql.*" %>
<%
String msg="",msgType="";
if("POST".equals(request.getMethod())){
    String donor=request.getParameter("donor");
    String item=request.getParameter("item");
    String qty=request.getParameter("qty");
    String area=request.getParameter("area");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
        PreparedStatement ps=con.prepareStatement(
            "INSERT INTO donations(donor_name,item,quantity,area) VALUES(?,?,?,?)");
        ps.setString(1,donor);ps.setString(2,item);ps.setString(3,qty);ps.setString(4,area);
        ps.executeUpdate(); con.close();
        msg="✅ Donation recorded. Thank you!"; msgType="success";
    }catch(Exception e){ msg="❌ Error: "+e.getMessage(); msgType="error"; }
}
Connection con=null; ResultSet rs=null;
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection("jdbc:mysql://localhost:3306/disaster_reports","root","Akshara@123");
    rs=con.createStatement().executeQuery("SELECT * FROM donations ORDER BY id DESC");
}catch(Exception e){ out.println("<!-- "+e.getMessage()+" -->"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Donations</title>
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
    <a href="shelters.jsp"><span class="nav-icon"></span> Safety Shelters</a>
    <a href="donation.jsp" class="active"><span class="nav-icon"></span> Donations</a>
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
      <div class="page-title">RELIEF <span>DONATIONS</span></div>
      <div class="page-subtitle">Track relief material contributions</div>
    </div>
  </div>
  <% if(!msg.isEmpty()){ %><div class="alert-msg alert-<%=msgType%>"><%=msg%></div><% } %>
  <div style="display:grid;grid-template-columns:1fr 1.6fr;gap:25px;align-items:start">
    <div class="form-panel">
      <form method="POST">
        <div style="font-family:'Orbitron',monospace;font-size:13px;color:var(--accent);letter-spacing:2px;margin-bottom:20px"> LOG DONATION</div>
        <div class="form-row"><label>DONOR NAME</label><input type="text" name="donor" placeholder="Name or Organization" required></div>
        <div class="form-row"><label>ITEM / MATERIAL</label><input type="text" name="item" placeholder="e.g. Water Bottles" required></div>
        <div class="form-row"><label>QUANTITY</label><input type="text" name="qty" placeholder="e.g. 500 units" required></div>
        <div class="form-row"><label>DELIVERY AREA</label><input type="text" name="area" placeholder="e.g. Vizag Relief Camp" required></div>
        <button type="submit" class="btn btn-success" style="width:100%"> SUBMIT DONATION</button>
      </form>
    </div>
    <div class="table-wrapper">
      <div class="table-header"><div class="table-title"> DONATION LOG</div></div>
      <table>
        <thead><tr><th>ID</th><th>DONOR</th><th>ITEM</th><th>QTY</th><th>AREA</th></tr></thead>
        <tbody>
        <%
        try{
            boolean hasRows=false;
            while(rs!=null && rs.next()){
                hasRows=true;
        %>
        <tr>
          <td style="font-family:'Orbitron',monospace;color:var(--muted);font-size:12px">#<%=rs.getInt("id")%></td>
          <td style="font-weight:600"><%=rs.getString("donor_name")%></td>
          <td><%=rs.getString("item")%></td>
          <td style="color:#00e676;font-weight:600"><%=rs.getString("quantity")%></td>
          <td><%=rs.getString("area")%></td>
        </tr>
        <%
            }
            if(!hasRows){
        %>
        <tr><td colspan="5"><div class="empty-state"><div class="empty-icon"></div><p>NO DONATIONS YET</p></div></td></tr>
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