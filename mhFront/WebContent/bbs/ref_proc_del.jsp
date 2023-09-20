<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {
	out.println("<script>");
	out.println("alert('로그인 후 시도해 주세요.');");
	out.println("location.href='../login_form.jsp';");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");

int idx = Integer.parseInt(request.getParameter("idx"));

try {
	stmt = conn.createStatement();
	sql = "update t_ref_list set  rl_isview = 'n' where rl_idx = " + idx;
	
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('ref_list.jsp');");
	} else {
		out.println("alert('공지글 삭제에 실패했습니다 \n 다시 시도하세요.');");
		out.println("history.back();");
	}
	out.println("</script>");
	
} catch (Exception e) {
		out.println("자료실 글 삭제시 문제가 발생했습니다.");
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