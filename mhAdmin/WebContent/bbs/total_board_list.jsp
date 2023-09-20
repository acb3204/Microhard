<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/total_board_list.jsp';");
	out.println("</script>");	
	out.close();
}
request.setCharacterEncoding("utf-8");
String id = "";

try {
	stmt = conn.createStatement();
	sql = "SELECT bt_name, bt_id FROM t_board_total_list ORDER BY bt_name DESC";
	rs = stmt.executeQuery(sql);
} catch (Exception e) {
	out.println("게시판 목록에서 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<style>
td { border: 1px solid white; }
table {
  border-spacing: 20px;
}
</style>
<table align="center">
<tr>
<td><a href='free_list.jsp'>자유게시판</a></td></tr>
<tr>
<%
if (rs.next()) {
	do {
		id = rs.getString("bt_id");
%>
<td><a href='board_list.jsp?id=<%=id %>'><%=rs.getString("bt_name") %>게시판</a></tr>
<%
	} while(rs.next());
} else {
	
}
%>
</tr>
</table>
<%@ include file="../_inc/inc_foot.jsp" %>