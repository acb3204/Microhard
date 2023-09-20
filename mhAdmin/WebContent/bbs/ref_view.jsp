<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));

String schtype = request.getParameter("schtype");		
String keyword = request.getParameter("keyword");
String args = "?cpage=" + cpage;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리 스트링으로 연결해줌 
}

String rl_title = "", rl_content =  "", rl_isview = "", rl_date = "", rl_name = "", rl_oname = "";
int  rl_read = 0; 

try {
	stmt = conn.createStatement();
	sql = "update t_ref_list set rl_read = rl_read + 1 where rl_idx = " + idx;
	stmt.executeUpdate(sql);		 // 조회수 증가 쿼리 실행
	
	sql = "select * from t_ref_list where rl_isview = 'y' and  rl_idx = " + idx;
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		rl_content = rs.getString("rl_content").replace("\r\n", "<br />");	// "\r\n" (엔터) 를 br 태그로 변경하여 nl_content 에 저장
		rl_title = rs.getString("rl_title");	rl_isview = rs.getString("rl_isview");
		rl_date = rs.getString("rl_date");		rl_read = rs.getInt("rl_read");
		rl_name = rs.getString("rl_name");  rl_oname = rs.getString("rl_oname");
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
} catch (Exception e) {
	out.println("자료실 글보기시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try { rs.close();	stmt.close(); } 
	catch (Exception e){ e.printStackTrace(); }
}
%>
<div align="center">
<h2>자료실 글 보기 </h2>
<table width="600" cellpadding="5">
<tr>
<th width="15%">작성일</th><td width="35%"><%=rl_date %></td>
<th width="15%">조회수</th><td width="35%"><%=rl_read %></td>
</tr>

<tr><th>글 제목</th><td colspan="3"> <%=rl_title %></td></tr>
<tr><th>첨부파일</th><td colspan="3"> <a href="file_download.jsp?file=<%=rl_name %>" di><%=rl_name %></a></td></tr>
<tr><th>글 내용</th><td colspan="3"><%=rl_content %></td></tr>
<tr><td colspan="4" align="center">
<% if (isLogin) { %>
	<input type="button" value="글수정" onclick="location.href='ref_form.jsp<%=args %>&kind=up&idx=<%=idx %>';"/>
	&nbsp;&nbsp;&nbsp;&nbsp;
<script>
function isDel () {
	if (confirm("정말 삭제하시겠습니까 ?")) {
		location.href = "ref_proc_del.jsp?idx=<%=idx %>";
	} 
}
</script>
	<input type="button" value="글삭제" onclick="isDel(); "/>
	&nbsp;&nbsp;&nbsp;&nbsp;
<% } %>
	<input type="button" value="글 목록" onclick="location.href='ref_list.jsp<%=args %>';"/>
</td></tr>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>
