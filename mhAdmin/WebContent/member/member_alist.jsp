<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.* " %>
<%@ include file="../_inc/inc_head.jsp" %>

<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/qna_list.jsp';");
	out.println("</script>");	
	out.close();
}

//1.한글처리, 파라미터 
request.setCharacterEncoding("UTF-8");
String id = (String) session.getAttribute("id");//object를 string으로 다운캐스팅
String name = request.getParameter("name");
//1-1. id없이는 진입불가, id없는 경우 로그인페이지로 이동

%>
<h2>관리자님 환영합니다.</h2>
<br>

<input type="button" value="회원정보관리" onclick="location.href='listMembers1.jsp'">
<input type="button" value="게시판관리" onclick="location.href='updateForm.jsp'">
<input type="button" value="QnA관리" onclick="location.href='/mhAdmin/bbs/qna_alist.jsp'">
<input type="button" value="자료실  관리" onclick="location.href='deleteForm.jsp'">
<input type="button" value="게시판 관리" onclick="location.href='deleteForm.jsp'">
<input type="button" value="공지사항 관리" onclick="location.href='/mhAdmin/bbs/notice_list.jsp'">

<!-- 관리자일때만 메뉴확인가능 -->
<% if(id != null){
	if(id.equals("admin")){ %>
	<input type="button" value="회원전체목록(관리자용)" onclick="location.href='memberList.jsp'">
<%
	}
}
%>

<%@ include file="../_inc/inc_foot.jsp" %>
