<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/qna_proc_in.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
String ql_title = getRequest(request.getParameter("ql_title"));
String ql_content = getRequest(request.getParameter("ql_content"));
String ql_ip = request.getRemoteAddr();
String ql_isanswer = "n";


try {
	stmt = conn.createStatement();
	int idx = 1;
	sql = "select max(ql_idx) + 1 from t_qna_list";
	rs = stmt.executeQuery(sql);
	if (rs.next()) idx = rs.getInt(1);	
	
	sql = "insert into t_qna_list (ql_idx, mi_id, mi_nick, ql_title, ql_content, ql_ip) values (?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, idx);
	pstmt.setString(2, loginInfo.getMi_id());
	pstmt.setString(3, loginInfo.getMi_nick());
	pstmt.setString(4, ql_title);
	pstmt.setString(5, ql_content);
	pstmt.setString(6, ql_ip);
	// System.out.println(sql);
	// stmt.executeQuery(sql);
	
	int result = pstmt.executeUpdate();
	if (result == 1 ) {
		response.sendRedirect("qna_list_view.jsp?cpage=1&idx=" + idx);
	} else {
		out.println("<script>");
		out.println("alert('QnA 글 등록에 실패했습니다.\n다시 시도하세요');");
		out.println("history.back();");
		out.println("</script>");	
		out.close();
	}	
} catch (Exception e) {
	out.println("QnA글 등록 시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>