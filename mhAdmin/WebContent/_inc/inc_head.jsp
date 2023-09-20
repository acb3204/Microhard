<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%! // 공용으로 사용할 메소드 선언 및 정의 영역
  public String getRequest(String req) {
   return req.trim().replace("<", "&lt;");
}
%>
<%
	String driver = "com.mysql.cj.jdbc.Driver";
String dbURL = "jdbc:mysql://localhost:3306/hard?useUnicode=true&characterEncoding=UTF8&verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";

final String ROOT_URL = "/mhAdmin/"; 


Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String sql = null;

try {		// db 연결
	Class.forName(driver);
	conn = DriverManager.getConnection(dbURL, "root", "1234");
} catch(Exception e) {
	out.println("DB연결에 문제가 발생했습니다.");
	e.printStackTrace();
}

boolean isLogin = false;  // 로그인 상태 처리 
AdminInfo loginInfo = (AdminInfo)session.getAttribute("loginInfo");
if (loginInfo != null) isLogin = true;

String loginUrl = request.getRequestURI();
if (request.getQueryString() != null) 
	loginUrl += "?" +  URLEncoder.encode(request.getQueryString().replace('&', '~'),"utf-8");	// 주의
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>

html, body {
  height: 100%; 
    background-color: black;
    color:#fff;   margin:0;
  
}
.box2 {  background-image:url('/mhAdmin/img/bimg12.jpg'); color:#fff; background-repeat:no-repeat; }

.navbar {
   display: flex;
   justify-content: space-between;
   align-items: center;
   background-color: black;
    padding: 8px 12px;
    font-size:24px;
   font-family:cursive;
}

a { 
   color:ghostwhite; 
   text-decoration-line:none;
   text-decoration:none;  
 }
 
.logo {
   width:20%;
}
.menu {
   display: flex;
   list-style: none;
   width:60%;
   padding: 8px 12px;
}
.menu a{
   padding: 8px 15px;
}
.menu2 {
   display: flex;
   list-style: none;
   width:20%;
   padding: 8px 12px;
}
#login { margin-right: 100px; }
@media screen and (max-width: 768px) {
   .navbar {
      flex-diretion: column;
   }
   .menu {
      flex-diretion: column;
   }
}
body {
    font-family: "Lato", sans-serif;
}
.sidenav {
    height: 100%;
    width: 250px;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: #111;
    overflow-x: hidden;
    transition: 0.5s;
    padding-top: 60px;
}

.sidenav a {
    padding: 8px 8px 8px 32px;
    text-decoration: none;
    font-size: 20px;
    color: #818181;
    display: block;
    transition: 0.3s;
}

.sidenav a:hover {
    color: #f1f1f1;
}

.sidenav .closebtn {
    position: absolute;
    top: 0;
    right: 25px;
    font-size: 36px;
    margin-left: 50px;
}

@media screen and (max-height: 450px) {
  .sidenav {padding-top: 15px;}
  .sidenav a {font-size: 18px;}
}
/* 팝업 스타일 */
.modal-bg {display:none;width:100%;height:100%;position:fixed;top:0;left:0;right:0;background: rgba(0, 0, 0, 0.6);z-index:999;}
.modal-wrap {display:none;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:300px;height:300px;background:#fff;z-index:1000;background-color: darkslategray;}

</style>

<nav class="navbar">
	<div class="logo">
		<a href="<%=ROOT_URL %>"><img src="/mhAdmin/img/logo.png" width="200px;" height="100;" ></a>
	</div>
			<% if (isLogin) { %>
	<div class="menu">
    		<a href="/mhAdmin/member/memberManage.jsp"">회원 관리</a>
			<a href="/mhAdmin/bbs/total_board_list.jsp">게시판 관리</a>
			<a href="/mhAdmin/bbs/qna_alist.jsp">QnA 관리</a>
			<a href="/mhAdmin/bbs/ref_list.jsp">자료실 관리</a>
			<a href="/mhAdmin/bbs/board_rq_alist.jsp">게시판 요청관리</a>
			<a href="/mhAdmin/bbs/notice_list.jsp">공지사항 관리</a>
	 </div>
	 <div class="menu2">
			<a href="/mhAdmin/logout.jsp" >로그아웃</a>
			<% } else { %>
			<a id="login" href="/mhAdmin/login_form.jsp">로그인</a>
			<% } %>
	 </div>
</nav>
</head>
<body>
<% if (isLogin) { %>
<div id="mySidenav" class="sidenav">
  <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
  <a href="/mhAdmin/member/memberManage.jsp">1. 회원 관리</a>
  <a href="/mhAdmin/bbs/total_board_list.jsp">2. 게시판관리</a>
  <a href="/mhAdmin/bbs/qna_alist.jsp">3. QnA관리</a>
  <a href="/mhAdmin/bbs/ref_list.jsp">4. 자료실관리</a>
  <a href="/mhAdmin/bbs/board_rq_alist.jsp">5. 게시판 요청관리</a>
  <a href="/mhAdmin/bbs/notice_list.jsp">6. 공지사항 관리</a>
</div>

<h2>Microhard Admin</h2>
<p>Microhard Adminside navigation menu.</p>
<span style="font-size:30px;cursor:pointer" onclick="openNav()">&#9776; open</span>
<% } %>
<script>
function openNav() {
    document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}
</script>
</head>
<body>