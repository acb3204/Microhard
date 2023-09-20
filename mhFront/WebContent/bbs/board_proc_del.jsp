<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%

request.setCharacterEncoding("utf-8");

String id = request.getParameter("id");
String pms = request.getParameter("pms");
int idx = Integer.parseInt(request.getParameter("idx"));

String bl_pw = "";
String bl_ismem = "";

String where = " where bl_idx = " + idx;
if (pms.equals("b")) {
	bl_pw = request.getParameter("bl_pw");
	bl_ismem = request.getParameter("bl_ismem");
	if (bl_pw != null && bl_ismem.equals("n")) 	// 비회원글 삭제일 경우 
		where += " and bl_pw = '" + bl_pw + "' ";
	else	// 회원글 삭제일 경우 			
		where += " and bl_writer = '" + loginInfo.getMi_nick() + "' ";
} else {
	where += " AND mi_nick='" + loginInfo.getMi_nick() + "' ";
}

try {
	stmt = conn.createStatement();
	sql = "update t_board_" + id + "_list set bl_isview = 'n' " + where;
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) { 
		out.println("location.replace('board_list.jsp?id=" + id + "');");
	}
	 else {
		 out.println("alert('게시글 삭제에 실패했습니다 \\n 다시 시도하세요.');");
		out.println("history.back();");
		}
		out.println("</script>");
	
} catch (Exception e) {
		out.println("게시글 삭제시 문제가 발생했습니다.");
		e.printStackTrace();
} finally {
	try {
		stmt.close();
	} catch (Exception e){
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>