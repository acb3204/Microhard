<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
/*
1. 사용자가 입력한 아이디를 받아옴
2. 받아온 아이디와 동일한 아이디가 회원 테이블에 있는지 여부를 검사하기 위해 쿼리 생성 후 실행
3. 중복 여부를 현 파일을 포함하고 있는 join_form.jsp에서 표시해줌
*/
request.setCharacterEncoding("utf-8");
String bt_id = request.getParameter("bt_id");

try {
	stmt = conn.createStatement();
	sql = "SELECT 1 FROM t_board_total_list WHERE bt_id='" + bt_id + "'";
	// System.out.println("dup_id_chk : " + sql);
	rs = stmt.executeQuery(sql);
%>
	<script>
	var msg = parent.document.getElementById("msg");
	var isDup = parent.table_name.isDup;
<%	if (rs.next()) { %>
		var tmp = "<span style='color: red; font-weight: blod;'>" + "이미 사용중인 테이블 이름 입니다.</span>";
		isDup.value = "n";
<%	} else { %>
		var tmp = "<span style='color: blue; font-weight: blod;'>" + "사용 가능한 테이블 이름 입니다.</span>";
		isDup.value = "y";
<%	} %>
	msg.innerHTML = tmp;
	</script>
<%
} catch(Exception e) {
	out.println("테이블 이름 중복 검사에서 문제가 발생했습니다.");
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