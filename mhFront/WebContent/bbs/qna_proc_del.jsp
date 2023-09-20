<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인을 다시 시도해 주세요.');");
	out.println("location.href='../login_form.jsp?url=../login_form.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));

String where = "where ql_idx = " + idx;
where += " and mi_id = '" + loginInfo.getMi_id() + "' ";
try {
	stmt = conn.createStatement();
	sql = "update t_qna_list set ql_isview = 'n' " + where;
	//	System.out.println(sql);
	
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1 ) {
		out.println("alert('QnA글이 삭제 되었습니다.');");	
		out.println("location.replace('qna_list.jsp');");
	} else {
		out.println("alert('QnA글 삭제에 실패했습니다.\\n다시 시도하세요');");
		out.println("history.back();");
	}
	out.println("</script>");
} catch (Exception e) {
	out.println("QnA글 수정 시 문제가 발생했습니다.");
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