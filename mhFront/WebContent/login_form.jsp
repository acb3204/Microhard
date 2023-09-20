<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp" %>
<div align="right">
<% if (isLogin) { %>
<%=loginInfo.getMi_nick() %>님 환영합니다.<br />
<% } %>
</div>
<%
if (isLogin) {	// 이미 로그인이 되어 있다면
	out.println("<script>");
	out.println("alert('이미 로그인 상태 입니다.'); history.back();");
	out.println("</script>");	
	out.close();
}
request.setCharacterEncoding("utf-8");
String url = request.getParameter("url");

if (url == null)	url = ROOT_URL;
else				url = url.replace('~', '&');


%>
<form name="frmLogin" action="login_proc.jsp" method="post">
	<div style="background:black; margin:20px -0.5% 0px -20px; text-align:center; height:400px; border: 1px solid; font-size: 150%;  box-sizing: border-box;">
		<h2>&nbsp;&nbsp;&nbsp;</h2>
		<input type="hidden" name="url" value="<%=url %>"  />
		아이디 &nbsp;&nbsp;&nbsp;<input type="text" name="mi_id" placeholder="아이디 입력" value="" maxlength="20" style="height:30px;" text-align="center" font-weight="bold;"  /><br />
		<br />
		비밀번호 <input type="password" name="mi_pw" placeholder="비밀번호 입력" value="" maxlength="20"  style="height:30px;" text-align="center" font-weight="bold;" /><br />
		
		<br />
		&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" value="로그인" style="width:80px; height:30px; font-size:20px;"/>	
		<input type="button" value="아이디 찾기" onclick="location.href='/mhFront/member/find_id.jsp'" style="height:30px; font-size:20px;"/>
		<input type="button" value="비밀번호 찾기" onclick="location.href='/mhFront/member/find_pw.jsp'" style="height:30px; font-size:20px;"/>
	</div>
</form>

<%@ include file="_inc/inc_foot.jsp" %>