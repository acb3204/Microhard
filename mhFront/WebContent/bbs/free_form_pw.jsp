<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
int cpage = Integer.parseInt(request.getParameter("cpage"));	
int idx = Integer.parseInt(request.getParameter("idx"));
String schtype = request.getParameter("schtype");		
String keyword = request.getParameter("keyword");
String action = "free_form_in.jsp";		// 수정시 이동할 파일

if (kind.equals("del")) action = "free_proc_del.jsp";	// 삭제시 이동할 파일 

// 현재 비밀번호를 입력받을 게시글이 비회원 글이 맞는지 검사 하는 영역

try {
	stmt = conn.createStatement();
	sql = "select 1 from t_free_list where fl_isview = 'y' and fl_ismem = 'n' and fl_idx = " + idx;
	rs = stmt.executeQuery(sql);
	if (!rs.next()) {	// rs에 데이터가 없으면 (idx에 해당하는 게시글이 비회원이 아니면)
		out.println("<script>");
		out.println("alert('잘못된 경로로 들어오셨습니다 .');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch (Exception e) {
	out.println("자유게시판 비밀번호 입력 폼에서 문제가 발생했습니다.");
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
<form name="frm" action="<%=action %>" method="post">
<input type="hidden" name="fl_ismem" value="n" />
<input type="hidden" name="idx" value="<%=idx %>" />
<input type="hidden" name="kind" value="<%=kind %>" />
<input type="hidden" name="cpage" value="<%=cpage %>" />
<% if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) { %>	
	<input type="hidden" name="schtype" value="<%=schtype %>" />
	<input type="hidden" name="keyword" value="<%=keyword %>" />	
<% } %>
<div id="box">
	<p>비밀번호를 입력하세요.</p>
	<input type="password" name="fl_pw" style="margin-bottom:10px;" /><br />
	<input type="button"  value="취 소" onclick="history.back();" />
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="submit"  value="확 인"  />
</div>
</form>
<script>
document.frm.fl_pw.focus();	// 비밀번호 입력 폼
</script>
<%@ include file="../_inc/inc_foot.jsp" %>