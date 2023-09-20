<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%

request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));
int br_idx = Integer.parseInt(request.getParameter("br_idx"));
int cpage = Integer.parseInt(request.getParameter("cpage"));
String id = request.getParameter("id");
String fl_pw = 	request.getParameter("br_pw");
String fl_ismem = request.getParameter("br_ismem");	

String where = " where br_idx = " + br_idx + " and br_pw = '" + fl_pw + "' ";
try {
	stmt = conn.createStatement();
	sql = "update t_board_" + id + "_list set bl_replay = bl_replay - 1 where bl_idx = " + idx;
	stmt.executeUpdate(sql);

	sql = "update t_board_" + id + "_reply set br_isview = 'n' " + where;
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) { 
		out.println("location.replace('board_view.jsp?id=" + id + "&cpage=" + cpage + "&idx=" + idx + "');");
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