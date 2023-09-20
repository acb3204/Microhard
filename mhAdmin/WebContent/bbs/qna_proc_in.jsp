<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 세션이 만료되었습니다.\\n다시 로그인 해주세요.');");
	out.println("location.href='../login_form.jsp?url=bbs/qna_proc_in.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String ql_atitle = getRequest(request.getParameter("ql_atitle"));
String ql_answer = getRequest(request.getParameter("ql_answer"));
String args = "?cpage=" + cpage + "&idx=" + idx;

try {
	stmt = conn.createStatement();
	String where = "where ql_idx = " + idx;
	sql = "update t_qna_list set ql_isanswer = 'y', ql_ai_idx =" + loginInfo.getAi_idx() + ", ql_atitle = '" + ql_atitle + "', ql_answer = '" + ql_answer + "', ql_adate = now() " + where;
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1 ) {		
		out.println("location.replace('qna_alist_view.jsp" + args +"');");
	} else {
		out.println("alert('QnA 글 답변 등록에 실패했습니다.\n다시 시도하세요');");
		out.println("history.back();");
	}
	out.println("</script>");

} catch (Exception e) {
	out.println("QnA글 답변 등록 시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>
