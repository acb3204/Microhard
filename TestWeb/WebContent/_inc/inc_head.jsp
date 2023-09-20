<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String ROOT_URL = "/mhAdmin/";
	boolean isLogin = false;  // 로그인 상태 처리 
	if (session.getAttribute("loginInfo") != null) {
		isLogin = true;
	}
%>
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
@media screen and (max-width: 768px) {
   .navbar {
      flex-diretion: column;
   }
   .menu {
      flex-diretion: column;
   }
}
</style>
<nav class="navbar">
	<div class="logo">
		<a href="<%=ROOT_URL %>"><img src="/mhAdmin/img/logo.png" width="200px;" height="100;" ></a>
	</div>
	<div class="menu">
    	<ul>
			<a href="/<%=ROOT_URL %>/bbs/total_board_list.jsp">게시판</a>
			<a href="/<%=ROOT_URL %>/bbs/ref_list.jsp">자료실</a>
			<a href="/<%=ROOT_URL %>/bbs/notice_list.jsp">공지</a>
			<a href="/<%=ROOT_URL %>/bbs/board_rq_alist.jsp">게시판 요청</a>
			<a href="/<%=ROOT_URL %>/bbs/qna_alist.jsp">QnA</a>
	 </div>
	 <div class="menu2">
			<% if (isLogin) { %>
			<a href="/<%=ROOT_URL %>/logout.jsp" >로그아웃</a>&nbsp;/&nbsp;<a href="/<%=ROOT_URL %>/member_infoup.jsp" >정보변경</a>
			<% } else { %>
			<a href="/<%=ROOT_URL %>/login_form.jsp">로그인</a>&nbsp;/&nbsp;<a href="/<%=ROOT_URL %>/member_join.jsp">회원가입</a>
			<% } %>
	 </div>
    	</ul>
    </div>
</nav>