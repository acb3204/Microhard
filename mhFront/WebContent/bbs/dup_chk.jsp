<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String bt_name = request.getParameter("br_title");

try {
	stmt = conn.createStatement();
	sql = "SELECT 1 FROM t_board_total_list WHERE bt_name='" + bt_name + "'";
	// System.out.println("dup_id_chk : " + sql);
	rs = stmt.executeQuery(sql);
%>
	<script>
	var msg = parent.document.getElementById("msg");
	var isDup = parent.frm.isDup;
<%	if (rs.next()) { %>
		var tmp = "<span style='color: red; font-weight: blod;'>" + "이미 사용중인 게시판 이름 입니다.</span>";
		isDup.value = "n";
<%	} else { %>
		var tmp = "<span style='color: blue; font-weight: blod;'>" + "사용 가능한 게시판 이름  입니다.</span>";
		isDup.value = "y";
<%	} %>
	msg.innerHTML = tmp;
	</script>
<%
} catch(Exception e) {
	out.println("게시판 이름  중복 검사에서 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();
		stmt.close(); 
	} catch(Exception e) {
		e.printStackTrace(); 
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>