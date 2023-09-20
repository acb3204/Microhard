<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String bl_ismem = "n";
String bl_writer = request.getParameter("bl_writer");
String bl_pw = request.getParameter("bl_pw");
String bl_title = getRequest(request.getParameter("bl_title"));
String bl_content = getRequest(request.getParameter("bl_content"));
String id = request.getParameter("id");
String pms = request.getParameter("pms");
String bl_ip = request.getRemoteAddr();
if (isLogin) {
	bl_ismem = "y";
	bl_writer = loginInfo.getMi_nick();
} else {
	bl_writer = getRequest(bl_writer);
	bl_pw = getRequest(bl_pw);
}

try {
	stmt = conn.createStatement();
	int idx = 1;	// 게시글이 하나도 없을때 가져다 쓸 변수 
	sql = "select max(bl_idx) from t_board_" + id + "_list";
	rs = stmt.executeQuery(sql);
	if (rs.next()) idx = rs.getInt(1) + 1;
	
	sql = "insert into t_board_" + id + "_list (bl_idx, bl_ismem, bl_writer, bl_pw, bl_title, bl_content, bl_ip)  values (" + idx + ", '" + bl_ismem + "', '" + bl_writer + "', '" + bl_pw + "', '" + bl_title + "', '" + bl_content + "', '" + bl_ip + "')";
	if (pms.equals("a"))
		sql = "insert into t_board_" + id + "_list (bl_idx, mi_nick, bl_title, bl_content, bl_ip)  values (" + idx + ", '" + bl_writer + "', '" + bl_title + "', '" + bl_content + "', '" + bl_ip + "')";
	
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	if (result == 1) {
		response.sendRedirect("board_view.jsp?id=" + id + "&cpage=1&idx=" + idx);		//가져갈 값이 한글이 있을경우 자바스크립트 사용
	} else {
		out.println("<script>");
		out.println("alert('자유게시판  글 등록에 실패했습니다. \n 다시 시도하세요.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch (Exception e) {
	out.println("게시판 글 등록시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();	stmt.close();
	} catch (Exception e){
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>