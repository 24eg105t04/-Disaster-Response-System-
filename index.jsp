<%@ page import="java.sql.*" %>
<%
String error = "";
if("POST".equalsIgnoreCase(request.getMethod())){
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/disaster_reports",
            "root",
            "Akshara@123"
        );

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM users WHERE username=? AND password=?"
        );

        ps.setString(1, username);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){
                       session.setAttribute("user", username);
session.setAttribute("role", rs.getString("role"));
session.setAttribute("name", rs.getString("name")); //  ADD THIS
                        response.sendRedirect("dashboard.jsp");
        } else {
            error = "Invalid username or password!";
        }

        con.close();

    }catch(Exception e){
        error = "Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Disaster Command Center</title>

<style>
*{
  margin:0;
  padding:0;
  box-sizing:border-box;
  font-family:'Segoe UI',sans-serif;
}

body{
  background:#020c0f;
  background-image: url('https://images.unsplash.com/photo-1547683905-f686c993aae5?w=1600&q=80');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height:100vh;
  display:flex;
  align-items:center;
  justify-content:center;
  color:#00ffc3;
  overflow:hidden;
}

/* DARK OVERLAY so grid + card stay readable over the image */
body::after{
  content:'';
  position:fixed;
  inset:0;
  background:rgba(2,12,15,0.65);
  pointer-events:none;
  z-index:1;
}

/* GRID BACKGROUND */
body::before{
  content:'';
  position:fixed;
  inset:0;
  background-image:
    linear-gradient(rgba(0,255,195,0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,255,195,0.05) 1px, transparent 1px);
  background-size:40px 40px;
  pointer-events:none;
}

/* MAIN CARD */
.container{
  width:900px;
  height:520px;
  display:flex;
  border-radius:18px;
  overflow:hidden;
  background:rgba(0,20,25,0.9);
  box-shadow:0 0 40px rgba(0,255,195,0.15);
  border:1px solid rgba(0,255,195,0.2);
  position:relative;
  z-index:2;
}

/* LEFT PANEL */
.left{
  width:45%;
  padding:40px;
  border-right:1px solid rgba(0,255,195,0.2);
  display:flex;
  flex-direction:column;
  justify-content:center;
}

.left h1{
  font-size:32px;
  letter-spacing:3px;
}

.left p{
  margin-top:10px;
  color:#66ffe0;
  font-size:14px;
}

.left ul{
  margin-top:30px;
}

.left ul li{
  margin-bottom:12px;
  font-size:14px;
}

/* RIGHT PANEL */
.right{
  width:55%;
  display:flex;
  align-items:center;
  justify-content:center;
}

/* BOX */
.box{
  width:300px;
}

/* TITLE */
.box h2{
  margin-bottom:20px;
}

/* INPUT */
input, select{
  width:100%;
  padding:12px;
  margin-bottom:15px;
  background:transparent;
  border:1px solid rgba(0,255,195,0.3);
  color:#00ffc3;
  border-radius:6px;
}

input:focus, select:focus{
  outline:none;
  border-color:#00ffc3;
  box-shadow:0 0 10px rgba(0,255,195,0.3);
}

/* BUTTON */
button{
  width:100%;
  padding:12px;
  background:#00ffc3;
  border:none;
  border-radius:6px;
  font-weight:bold;
  cursor:pointer;
  transition:0.3s;
}

button:hover{
  box-shadow:0 0 15px #00ffc3;
}

/* ERROR */
.error{
  color:#ff4d6d;
  margin-bottom:10px;
}

/* SWITCH */
.switch{
  margin-top:10px;
  font-size:13px;
}

.switch a{
  color:#00ffc3;
  cursor:pointer;
}

/* HIDE */
.hidden{
  display:none;
}
</style>
</head>

<body>

<div class="container">

  <!-- LEFT -->
  <div class="left">
    <h1>DISASTER<br>COMMAND CENTER</h1>
    <p>Real-time monitoring & emergency control</p>

    <ul>
      <li> Live Incident Tracking</li>
      <li> Rescue Team Management</li>
      <li> Alerts & Notifications</li>
      <li> Analytics Dashboard</li>
    </ul>
  </div>

  <!-- RIGHT -->
  <div class="right">

    <!-- LOGIN -->
    <div class="box" id="loginBox">
      <h2>Login</h2>

      <% if(!error.isEmpty()){ %>
        <div class="error"><%=error%></div>
      <% } %>

      <form method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">LOGIN</button>
      </form>

      <div class="switch">
        New user? <a onclick="toggle()">Register</a>
      </div>
    </div>

    <!-- REGISTER -->
    <div class="box hidden" id="registerBox">
      <h2>Register</h2>

      <form onsubmit="registerUser(event)">
        <input type="text" id="name" placeholder="Full Name" required>
        <input type="text" id="user" placeholder="Username" required>
        <input type="email" id="email" placeholder="Email" required>
        <input type="password" id="pass" placeholder="Password" required>

        <select id="role">
          <option>Admin</option>
          <option>Operator</option>
          <option>Viewer</option>
        </select>

        <button type="submit">CREATE ACCOUNT</button>
      </form>

      <div class="switch">
        Already have account? <a onclick="toggle()">Login</a>
      </div>
    </div>

  </div>
</div>

<script>
function toggle(){
  document.getElementById("loginBox").classList.toggle("hidden");
  document.getElementById("registerBox").classList.toggle("hidden");
}

function registerUser(e){
  e.preventDefault();

  let url = "register.jsp?name="+encodeURIComponent(name.value)+
            "&username="+encodeURIComponent(user.value)+
            "&email="+encodeURIComponent(email.value)+
            "&password="+encodeURIComponent(pass.value)+
            "&role="+encodeURIComponent(role.value);

  fetch(url)
  .then(r=>r.text())
  .then(res=>{
      alert(res);
  });
}
</script>

</body>
</html>