<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('다시 로그인 해주세요.';");
	out.println("location.href='../login_form.jsp?url=bbs/notice_form.jsp?kind=in';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
String nl_ctgr = request.getParameter("nl_ctgr");
String nl_title = getRequest(request.getParameter("nl_title"));
String nl_content = getRequest(request.getParameter("nl_content"));
String nl_isview = request.getParameter("nl_isview");

try {
	stmt = conn.createStatement();
	
	int idx = 1;
	sql = "select max(nl_idx) from t_notice_list;";
	rs = stmt.executeQuery(sql);
	if (rs.next()) idx = rs.getInt(1) + 1;
	
	sql = "insert into t_notice_list values (" + idx + ", 1, '" + nl_ctgr + "', '" + nl_title + "', '" + nl_content + "', 0, '" + nl_isview + "', now());";
	int result = stmt.executeUpdate(sql);	
	if (result == 1 ) {
		response.sendRedirect("notice_view.jsp?cpage=1&idx=" + idx);
	} else {
		out.println("<script>");
		out.println("alert('공지 글 등록에 실패했습니다.\n다시 시도하세요');");
		out.println("history.back();");
		out.println("</script>");	
		out.close();
	}	
} catch (Exception e) {
	out.println(nl_ctgr + " 등록시 문제가 발생했습니다.");
	e.printStackTrace();
}

%>
<%@ include file="../_inc/inc_foot.jsp" %>