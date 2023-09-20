<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=../login_form.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));

String mi_id = request.getParameter("mi_id");
String mi_nick = request.getParameter("mi_nick");
String ql_title = getRequest(request.getParameter("ql_title"));
String ql_content = getRequest(request.getParameter("ql_content"));
String args = "?cpage=" + cpage + "&idx=" + idx;

String where = "where ql_idx = " + idx;
// 회원글 수정 일 경우
where += " and mi_id = '" + loginInfo.getMi_id() + "' ";
try {
	stmt = conn.createStatement();
	sql = "update t_qna_list set ql_title = '" + ql_title + "', ql_content = '" + ql_content + "' " + where;
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1 ) {		
		out.println("location.replace('qna_list_view.jsp" + args +"');");
	} else {
		out.println("alert('QnA 글 수정에 실패했습니다.\\n다시 시도하세요');");
		out.println("history.back();");
	}
	out.println("</script>");
} catch (Exception e) {
	out.println("QnA 수정 시 문제가 발생했습니다.");
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