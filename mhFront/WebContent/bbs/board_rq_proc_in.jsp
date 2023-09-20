<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('잘못된 접근입니다.\\n로그인 해주세요.');");
	out.println("location.href='../index.jsp';");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");
String br_select = request.getParameter("br_select");
String br_title = request.getParameter("br_title");
String br_content = request.getParameter("br_content");
String br_boradpms = request.getParameter("br_boradpms");
String br_replyuse = request.getParameter("br_replyuse");
String br_replypms = request.getParameter("br_replypms");
String mi_id = loginInfo.getMi_id();
String mi_nick = loginInfo.getMi_nick();
String br_ip = request.getRemoteAddr();

try {
	int idx = 1;
	stmt = conn.createStatement();
	
	sql = "SELECT MAX(br_idx) + 1 FROM t_board_request";
	rs = stmt.executeQuery(sql);
	if (rs.next())
		idx = rs.getInt(1);
	
//	sql = "INSERT INTO t_board_request t_board_request (mi_id, mi_nick, br_title, br_select, br_content, br_boradpms, br_replyuse, br_ip) VALUES ('" + mi_id + "', '" + mi_nick + "', '" + br_title + "', '" + br_select + "', '" + br_content + "', '" + br_boradpms + "', '" + br_replyuse + "', '" + br_ip + "');";
//	if (br_replyuse.equals("a")) {
		
	sql = "INSERT INTO t_board_request (mi_id, mi_nick, br_title, br_select, br_content, br_boradpms, br_replyuse, br_replypms, br_ip) VALUES ('" + mi_id + "', '" + mi_nick + "', '" + br_title + "', '" + br_select + "', '" + br_content + "', '" + br_boradpms + "', '" + br_replyuse + "', '" + br_replypms + "', '" + br_ip + "');";
//	}
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	if (result == 1) {
		out.println("<script>location.replace('board_rq_finish.jsp');</script>");
	} else {
		out.println("");
		out.println("<script>alert('게시판 요청에 실패했습니다. \n다시 시도하세요.');history.back();</script>");
		out.close();
	}
} catch(Exception e) {
	out.println("게시판요청 등록시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();
		stmt.close();
	} catch(Exception e) {
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>