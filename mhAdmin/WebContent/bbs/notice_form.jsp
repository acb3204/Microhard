<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('다시 로그인 해주세요.';");
	out.println("location.href='../login_form.jsp?url=bbs/notice_form.jsp?kind=in';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록";		// 버튼에 사용할 캡션 문자열
String action = "notice_proc_in.jsp";
String nl_ctgr = "", nl_title = "", nl_content = "", nl_isview = "n";
int idx = 0;	// 글번호를 저장할 변수로 '수정'일 경우에만 사용됨
int cpage = 1;

String schtype = request.getParameter("schtype");	// 검색 조건
String keyword = request.getParameter("keyword");	// 검색어
String args = "";
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
	args = "&schtype=" + schtype + "&keyword=" + keyword;	// 링크에 검색 관련 값들을 쿼리스트링으로 연결해줌
}

if (kind.equals("up")) {	// 공지글 수정 폼일 경우
	caption = "수정";
	cpage = Integer.parseInt(request.getParameter("cpage"));
	idx = Integer.parseInt(request.getParameter("idx"));	
	action = "notice_proc_up.jsp";
	
try {
	stmt = conn.createStatement();
	sql = "select * from t_notice_list where nl_isview = 'y' and nl_idx=" + idx;	
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		nl_ctgr = rs.getString("nl_ctgr");
		nl_title = rs.getString("nl_title");
		nl_content = rs.getString("nl_content");
		nl_isview = rs.getString("nl_isview");
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");	
		out.close();
	}	
	
} catch (Exception e) {
	out.println("공지사항 글 수정 폼에서 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();
		stmt.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
}
%>
<div align="center">
	<h2>공지사항 글 <%=caption %> 폼</h2>
	<form name="frm" action="<%=action %>" method="post">
	<% if (kind.equals("up")) { %>
	<input type="hidden" name="idx" value="<%=idx %>" />
	<input type="hidden" name="cpage" value="<%=cpage %>" />
	<% if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) { %>
	<input type="hidden" name="schtype" value="<%=schtype %>" />
	<input type="hidden" name="keyword" value="<%=keyword %>" />
	<%
		}
	} 
	%>
	<table width="600" cellpadding="5">
	<tr>
	<th width="15%" value="<%=nl_title %>">글 제목</th>
	<td width="*">
		<select name="nl_ctgr">
			<option <% if (nl_ctgr.equals("공지")) { %>selected="selected" <% } %>>공지</option>
			<option <% if (nl_ctgr.equals("이벤트")) { %>selected="selected" <% } %>>이벤트</option>
			<option <% if (nl_ctgr.equals("보도자료")) { %>selected="selected" <% } %>>보도자료</option>	
		</select>
		<input type="text" name="nl_title" size="51" value="<%=nl_title %>" />
	</td>
	</tr>
	<tr>
	<th>글 내용</th>
	<td>
		<textarea name="nl_content" rows="10" cols="65"><%=nl_content %></textarea><br />
		현재 <%=caption %>하는 공지글을 
		<input type="radio" name="nl_isview" value="n" id="vn"  <% if (nl_isview.equals("n")) {%>checked="checked"<% } %> />
		<label for="vn">미게시</label>
		<input type="radio" name="nl_isview" value="y" id="vy" <% if (nl_isview.equals("y")) {%>checked="checked"<% } %> />
		<label for="vy">게시</label> 하겠습니다.
	</td>
	</tr>
	<tr><td colspan="2" align="center">
		<input type="submit" value="글 <%=caption %>" />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="reset" value="다시 입력" />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="글 목록" onclick="location.href='notice_list.jsp?cpage=<%=cpage + args %>';" />
	</td></tr>
	</table>
	</form>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>