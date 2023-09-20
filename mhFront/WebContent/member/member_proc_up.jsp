<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");

String mi_name = request.getParameter("mi_name");
String mi_id = request.getParameter("mi_id");
String mi_pw = request.getParameter("mi_pw");
String mi_nick = request.getParameter("mi_nick");
String p2 = request.getParameter("p2");
String p3 = request.getParameter("p3");
String email1 = request.getParameter("email1");
String email2 = request.getParameter("email2");
String mi_phone = "010-" + p2 + "-" + p3;
String mi_email = email1 + "@" + email2;
String where = " where mi_id = '" + loginInfo.getMi_id() + "' ";
try {
	stmt = conn.createStatement();
	sql = "update t_member_info set " + 
	"mi_pw = '" + mi_pw + "' , mi_nick = '" + mi_nick +  "', mi_phone = '" + mi_phone + "', mi_email = '" + mi_email + "' " +  where;
	//System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) {
		out.println("alert('회원 정보 수정 완료 .\\n 다시 로그인 후 이용해주세요.');");
		session.invalidate();
		out.println("location.replace('../login_form.jsp');");
		 }
	 else  {
		out.println("alert('회원 정보 수정에 실패했습니다.\\n 다시 시도하세요.');");
		out.println("history.back();");
	 }
	out.println("</script>");
	
} catch (Exception e) {
   out.println("회원정보 수정시 문제가 발생했습니다.");
   e.printStackTrace();
}
%>

<%@ include file="../_inc/inc_foot.jsp" %>