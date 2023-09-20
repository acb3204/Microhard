<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.* " %>
<%! // 공용으로 사용할 메소드 선언 및 정의 영역
  public String getRequest(String req) {
	return req.trim().replace("<", "&lt;");
}
%>
<%
	String driver = "com.mysql.cj.jdbc.Driver";
String dbURL = "jdbc:mysql://localhost:3306/hard?useUnicode=true&characterEncoding=UTF8&verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";

final String ROOT_URL = "/mhFront/"; 


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
MemberInfo loginInfo = (MemberInfo)session.getAttribute("loginInfo");
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
.box2 {  background-image:url('img/bimg12.jpg'); color:#fff; background-repeat:no-repeat; }

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
@media screen and (max-width: 768px) {
   .navbar {
      flex-diretion: column;
   }
   .menu {
      flex-diretion: column;
   }
}

.button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
}
</style>

<nav class="navbar">
	<div class="logo">
		<a href="<%=ROOT_URL %>"><img src="/mhFront/img/logo.png" width="200px;" height="100;" ></a>
	</div>
	<div class="menu">
    	<ul>
			<a href="/mhFront/bbs/total_board_list.jsp">게시판</a>
			<a href="/mhFront/bbs/ref_list.jsp">자료실</a>
			<a href="/mhFront/bbs/notice_list_front.jsp">공지</a>
			<a href="/mhFront/bbs/board_rq_ulist.jsp">게시판 요청</a>
			<a href="/mhFront/bbs/qna_list.jsp">QnA</a>
	 </div>
	 <div class="menu2">
			<% if (isLogin) { %>
			<a href="/mhFront/logout.jsp" >로그아웃</a>&nbsp;/&nbsp;<a href="/mhFront/member/member_info.jsp" >정보변경</a>
			<% } else { %>
			<a href="/mhFront/login_form.jsp">로그인</a>&nbsp;/&nbsp;<a href="/mhFront/member/member_join.jsp">회원가입</a>
			<% } %>
	 </div>
    	</ul>
    </div>
</nav>
</head>
<body>
