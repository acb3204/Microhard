<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('잘못된 접근입니다.');");
	out.println("location.href='../index.jsp';");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));

try {
	stmt = conn.createStatement();
	sql = "UPDATE t_board_request SET br_isanswer = 'c' WHERE br_idx = " + idx;
	
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('board_rq_alist.jsp');");
	} else {
		out.println("alert('게시판 요청 미승인에 실패했습니다.\n다시 시도하세요.');");
		out.println("history.back();");
	}
	out.println("</script>");
	
} catch(Exception e) {
	out.println("게시판 요청 미승인시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		stmt.close();
	} catch(Exception e) {
		e.printStackTrace();
	}
}
%>

<%@ include file="../_inc/inc_foot.jsp" %>