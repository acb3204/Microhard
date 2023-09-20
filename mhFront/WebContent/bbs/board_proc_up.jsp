<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%

request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));

String pms = request.getParameter("pms");
String id = request.getParameter("id");
String schtype = request.getParameter("schtype");		
String keyword = request.getParameter("keyword");
String args = "?id=" + id + "&cpage=" + cpage + "&idx=" + idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
	args += "&schtype=" + schtype + "&keyword=" + keyword;
}
System.out.println(pms);
String bl_title = getRequest(request.getParameter("bl_title"));	
String bl_content = getRequest(request.getParameter("bl_content"));	
String mi_nick = "";
String bl_pw = "";
String bl_ismem = "";

String where = " where bl_idx = " + idx;
if (pms.equals("b")) {
	bl_pw = request.getParameter("bl_pw");
	bl_ismem = request.getParameter("bl_ismem");
	if (bl_ismem.equals("n")) 
		where += " and bl_pw = '" + bl_pw + "' ";
	else 					
		where += " and bl_writer = '" + loginInfo.getMi_nick() + "' ";
} else {
	where += " and mi_nick='" + loginInfo.getMi_nick() + "' ";
}

try {
	stmt = conn.createStatement();
	sql = "update t_board_" + id + "_list set " + 
	"bl_title = '" + bl_title + "' , bl_content = '" + bl_content +  "' " + where;
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('board_view.jsp" + args + "');"); }
	 else  {
		out.println("alert('게시글 수정에 실패했습니다 \\n 다시 시도하세요.');");
		out.println("history.back();");
	 }
	out.println("</script>");
	
} catch (Exception e) {
	
		out.println("게시글 수정시 문제가 발생했습니다.");
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