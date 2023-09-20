<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 다시 시도해주세요.';");
	out.println("location.href='../login_form.jsp?url=../login_form.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String schtype = request.getParameter("schtype");	// 검색 조건
String keyword = request.getParameter("keyword");	// 검색어
String args = "?cpage=" + cpage + "&idx=" + idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
	args += "&schtype=" + schtype + "&keyword=" + keyword;	// 링크에 검색 관련 값들을 쿼리스트링으로 연결해줌
}

String nl_ctgr = request.getParameter("nl_ctgr");
String nl_title = getRequest(request.getParameter("nl_title"));
String nl_content = getRequest(request.getParameter("nl_content"));
String nl_isview = request.getParameter("nl_isview");

try {
	stmt = conn.createStatement();
	sql = "update t_notice_list set nl_ctgr = '" + nl_ctgr + "', nl_title = '" + nl_title + "', nl_content = '" + nl_content + "', nl_isview = '" + nl_isview + "'  where nl_idx = '" + idx + "'";
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1 ) {		
		out.println("location.replace('notice_view.jsp" + args + "');");
	} else {
		out.println("alert('공지 글 수정에 실패했습니다.\n다시 시도하세요');");
		out.println("history.back();");
	}	
	out.println("</script>");
} catch (Exception e) {
	out.println("공지사항 수정 시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		stmt.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>