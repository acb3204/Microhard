<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% %>
<%@ include file="../_inc/inc_head.jsp" %>

<% 

if (!isLogin) {
	out.println("<script>");
	out.println("alert('다시 로그인해 주세요.');");
	out.println("location.href='../login_form.jsp?url=bbs/ref_form.jsp?kind=in';");
	out.println("</script>");
	out.close();
}

request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록";		// 버튼에 사용할 캡션 문자열

String rl_title = "", rl_content =  "", rl_isview = "",  rl_name = "";


int idx = 0;				// 글번호를 저장할 변수로 '수정'일 경우에만 사용됨 
int cpage = 1;				// 페이지 번호를 저장할 변수로 '수정'일 경우에만 사용됨 
String schtype = request.getParameter("schtype");		
String keyword = request.getParameter("keyword");
String args = "";
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
	args = "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리 스트링으로 연결해줌 
}


if (kind.equals("up")) {	// 공지글 수정 폼일 경우 
	caption = "수정";
	idx = Integer.parseInt(request.getParameter("idx"));
	cpage = Integer.parseInt(request.getParameter("cpage"));
	// action = "ref_proc_up.jsp";
	
	try {
		stmt = conn.createStatement();		
		sql = "select * from t_ref_list where rl_isview = 'y' and  rl_idx = " + idx;
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			rl_title = rs.getString("rl_title"); rl_content = rs.getString("rl_content");
				rl_isview = rs.getString("rl_isview"); rl_name = rs.getString("rl_name");
				// response.sendRedirect("location.href='ref_form.jsp");

		} else {
			out.println("<script>");
			out.println("alert('존재하지 않는 자료실 게시물 입니다.');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
		}
	} catch (Exception e) {
		out.println("자료실 글 수정폼에서문제가 발생했습니다.");
		e.printStackTrace();
	} finally {
		try { rs.close();	stmt.close(); } 
		catch (Exception e){ e.printStackTrace(); }
	}
}
%>
<div align="center">
<h2>자료실 글 <%=caption %> 폼</h2>
<form action="<%=ROOT_URL %>uploadPartProc3" method="post"  enctype="multipart/form-data" >
<input type="hidden" name="kind" value="<%=kind %>">
<% if (kind.equals("up")) { %>
<input type="hidden" name="idx" value="<%=idx %>">
<input type="hidden" name="cpage" value="<%=cpage %>">
<% if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) { %>		
	<input type="hidden" name="schtype" value="<%=schtype %>">
	<input type="hidden" name="keyword" value="<%=keyword %>">	
<% 
	} 
}
%>
<table width="600" cellpadding="5">
<tr>
<th width="15%">글 제목</th>
<td>
	<input type="text" name="rl_title" size="49" value="<%=rl_title %>"/>
</td>
<tr>
<th width="15%">파일 업로드 </th>
	<td>
	<% if (kind.equals("up")) { %>
	<input type="file" name="rl_name" />
	원본 파일명 :<%=rl_name %>
	<%}  else { %>
	<input type="file" name="rl_name" />
	<%} %>
	</div>
	</td>
</tr>

<tr>
<th>글내용</th>
	<td>
	<textarea name="rl_content" rows="10" cols="65"><%=rl_content %></textarea><br />
	<input type="hidden" name="rl_isview" value="y">
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	<input type="submit" value="글<%=caption %>"/>
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="reset" value="다시 입력"/>
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" value="글 목록" onclick="location.href='ref_list.jsp?cpage=<%=cpage + args %>';"/>
	</td>
</tr>
</table>
</form>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>