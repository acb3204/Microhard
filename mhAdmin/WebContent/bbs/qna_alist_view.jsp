<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String args = "?cpage=" + cpage;

// view 화면에서 보여줄 게시글의 정보들을 저장할 변수들
String  ql_title = "", ql_content = "", ql_ip = "", ql_qdate = "", ql_adate = "", ql_isanswer = "", ql_atitle = "", ql_answer = "", mi_nick = "";

		//처리상태에 따라 텍스트 표시 변경
		String statusText = "";
		

try {
	stmt = conn.createStatement();

	sql = "select * from t_qna_list where ql_isview = 'y' and ql_idx = " + idx;
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		mi_nick = rs.getString("mi_nick");
		ql_title = rs.getString("ql_title");
		ql_content = rs.getString("ql_content").replace("\r\n", "<br />");;
		ql_ip = rs.getString("ql_ip");
		ql_qdate = rs.getString("ql_qdate");
		ql_adate = rs.getString("ql_adate");
		ql_isanswer = rs.getString("ql_isanswer");
		ql_atitle = rs.getString("ql_atitle");
		ql_answer = rs.getString("ql_answer");
		
		if (ql_isanswer.equals("n")) {
			 statusText = "답변 전";
			} else if (ql_isanswer.equals("y")) {
			 statusText = "답변 완료";
			}

	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}

} catch(Exception e) {
	out.println("QnA글 보기 시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<div align="center">
<h2>QnA 글 보기</h2>
<table width="700" cellpadding="5">
<tr>
<th width="12%">작성자</th>
<td width="15%"><%=mi_nick %></td>
<th width="12%">작성일</th><td width="*"><%=ql_qdate %></td>
<th width="12%">답변 상태</th><td width="*"><%=statusText %></td>
</tr>
<tr><th>제목</th><td colspan="5"><%=ql_title %></td></tr>
<tr><th>내용</th><td colspan="5"><%=ql_content %></td></tr>
<tr><td colspan="6" align="center"><hr />

<!-- 답변 보기 -->
<div align="center">
<table width="700" cellpadding="5">
<% if (statusText.equals("답변 완료")) { %>
<tr>
<th width="12%">작성자</th>
<td width="15%">관리자</td>
<th width="12%">작성일</th><td width="*"><%=ql_adate %></td>
</tr>
<tr><th>제목</th><td colspan="5"><%=ql_atitle %></td></tr>
<tr><th>내용</th><td colspan="5"><%=ql_answer %></td></tr>
<tr><td colspan="4" align="center">
	<input type="button" value="글 목록" onclick="location.href='qna_alist.jsp<%=args %>'" />
</td></tr>
<% } else { %>
<form action="qna_proc_in.jsp" method="post">
<input type="hidden" name=cpage value="<%=cpage %>" />
<input type="hidden" name=idx value="<%=idx %>" /> 
<tr><th>답변 제목</th><td colspan="3">	<input type="text" name="ql_atitle" size="60" value="" /></td></tr>
<tr><th>답변 내용</th><td colspan="3">	<textarea name="ql_answer" cols="65" rows="10"></textarea></td></tr>
<tr><td colspan="4" align="center">
	<input type="submit" value="답변 하기" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" value="글 목록" onclick="location.href='qna_alist.jsp<%=args %>'" />
</td></tr>
</form>
<% } %>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>
