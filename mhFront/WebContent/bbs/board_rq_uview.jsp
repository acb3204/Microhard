<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String args = "?cpage=" + cpage;
String br_select = "", br_title = "", br_content = "",  br_boradpms = "", br_replyuse = "", br_replypms = "", br_isanswer="";
try {
	stmt = conn.createStatement();
	sql = "SELECT * FROM t_board_request WHERE br_idx = " + idx;
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		br_select = rs.getString("br_select");
		br_title = rs.getString("br_title");
		br_content = rs.getString("br_content").replace("\r\n", "<br />");
		br_boradpms = rs.getString("br_boradpms");
		br_replyuse = rs.getString("br_replyuse");
		br_replypms = rs.getString("br_replypms");
		br_isanswer = rs.getString("br_isanswer");
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch(Exception e) {
	out.println("게시글 보기시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<script>
function isDel() {
	if (confirm("정말 삭제하시겠습니까?")) {
		location.href = "board_rq_proc_del.jsp?idx=<%=idx %>";
	}
}
</script>
<table width="700" cellpadding="5" align="center">
	<tr>
		<th>분류</th>
		<td colspan="5">
<% if (br_select.equals("a")) { %>
			스포츠
<% } else if (br_select.equals("b")) { %>
			연예
<% } else { %>
			게임
<% } %>
		</td>
	</tr>
	<tr>
		<th>게시판 이름</th>
		<td colspan="5"><%=br_title %></td>
	</tr>
	<tr>
		<th>용도</th>
		<td colspan="5"><%=br_content %></td>
	</tr>
	<tr>
		<th>게시판 사용 권한</th>
		<td colspan="5">
			<div>
				<input type="radio" name="boradpms" <% if(br_boradpms.equals("a")) {%> checked <% } %> onclick="return(false);" />회원
				<input type="radio" name="boradpms" <% if(br_boradpms.equals("b")) {%> checked <% } %> onclick="return(false);" />비회원
			</div>
		</td>
	</tr>
		<tr>
		<th>댓글 사용 여부</th>
		<td colspan="5">
			<div>
				<input type="radio" name="replyuse" <% if(br_replyuse.equals("a")) {%> checked <% } %> onclick="return(false);" />사용
				<input type="radio" name="replyuse" <% if(br_replyuse.equals("b")) {%> checked <% } %> onclick="return(false);" />미사용
			</div>
		</td>
	</tr>
<% if (br_replyuse.equals("a")) { %>
	<tr>
		<th>게시판 사용 권한</th>
		<td colspan="5">
			<div>
				<input type="radio" name="replypms" <% if(br_replypms.equals("a")) {%> checked <% } %> onclick="return(false);" />회원
				<input type="radio" name="replypms" <% if(br_replypms.equals("b")) {%> checked <% } %> onclick="return(false);" />비회원
			</div>
		</td>
	</tr>
<% } %>
	<tr>
	<td><input type="button" value="목록" onclick="location.href='board_rq_ulist.jsp<%=args %>'"/></td>
	<td><% if(br_isanswer.equals("a")) { %><input type="button" value="삭제" onclick="isDel()" /><% } %></td>
	</tr>
</table>
<%@ include file="../_inc/inc_foot.jsp" %>