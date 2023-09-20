<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
%>
<body>
<h2 align="center">게시판 요청이 완료되었습니다.</h2>
<table align="center">
<tr>
	<td>
		<button onclick="location.href='board_rq_ulist.jsp';">리스트로 가기</button>
	</td>
</tr>
</table>

</body>
<%@ include file="../_inc/inc_foot.jsp" %>