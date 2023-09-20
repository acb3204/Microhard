<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));
int br_idx = Integer.parseInt(request.getParameter("br_idx"));
int cpage = Integer.parseInt(request.getParameter("cpage"));
String id = request.getParameter("id");

// 현재 비밀번호를 입력받을 게시글이 비회원 글이 맞는지 검사 하는 영역
try {
	stmt = conn.createStatement();
	sql = "select 1 from t_board_" + id + "_reply where br_isview = 'y' and br_ismem = 'n' and br_idx = " + br_idx;
	rs = stmt.executeQuery(sql);
	if (!rs.next()) {	// rs에 데이터가 없으면 (idx에 해당하는 게시글이 비회원이 아니면)
		out.println("<script>");
		out.println("alert('잘못된 경로로 들어오셨습니다 .');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch (Exception e) {
	out.println("댓글 비밀번호 입력 폼에서 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try { rs.close();	stmt.close(); } 
	catch (Exception e){ e.printStackTrace(); }
}
%>

<style>
#box { width:200px; height:100px; margin:30px auto 0; border:1px solid black; text-align:center; font-size:12px ;}
</style>

<h2 align="center">비밀번호 입력 폼</h2>
<form name="frm" action="board_reply_proc_del.jsp" method="post">
<input type="hidden" name="bl_ismem" value="n" />
<input type="hidden" name="pms" value="b" />
<input type="hidden" name="idx" value="<%=idx %>" />
<input type="hidden" name="br_idx" value="<%=br_idx %>" />
<input type="hidden" name="id" value="<%=id %>" />
<input type="hidden" name="cpage" value="<%=cpage %>" />
<div id="box">
	<p>비밀번호를 입력하세요.</p>
	<input type="password" name="br_pw" style="margin-bottom:10px;" /><br />
	<input type="button"  value="취 소" onclick="history.back();" />
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="submit"  value="확 인"  />
</div>
</form>
<script>
document.frm.br_pw.focus();	// 비밀번호 입력 폼
</script>
<%@ include file="../_inc/inc_foot.jsp" %>