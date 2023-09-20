<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String caption = "등록";		// 버튼에 사용할 캡션 문자열
String action = "qna_proc_in.jsp";	
String ql_qdate = "", ql_adate = "", ql_atitle = "", ql_answer = "", ql_ip = "", ql_isanswer = "n";

int idx = 0;	// 글번호를 저장할 변수로 '수정'일 경우에만 사용됨
int cpage = 1;	// 페이지번호를 저장할 변수로 '수정'일 경우에만 사용됨


	idx = Integer.parseInt(request.getParameter("idx"));
	cpage = Integer.parseInt(request.getParameter("cpage"));
	
	String where = " where ql_isview = 'y' and ql_idx = " + idx + " and ql_isanswer = '" + ql_isanswer + "' ";
	where += " and ai_id = '" + loginInfo.getAi_id() + "' ";
	sql = "select * from t_qna_list " + where;
	
	try {
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		if (rs.next()) {	// 게시글이 있으면
			ql_atitle = rs.getString("ql_atitle");
			ql_answer = rs.getString("ql_answer");
			ql_qdate = rs.getString("ql_qdate");
		} else {			// 게시글이 없으면
			out.println("<script>");
			out.println("alert('잘못된 경로로 들어오셨습니다.');");
			out.println("history.back();");
			out.println("</script>");	
			out.close();
		}
		
	} catch (Exception e) {
		out.println("QnA글 수정 폼에서 문제가 발생했습니다.");
		e.printStackTrace();
	} finally {
		try {
			rs.close();
			stmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

%>
<h2>QnA <%=caption %> 폼</h2>
<form name="frm" action="<%=action %>" method="post">
<% if (kind.equals("up")) { %>
<input type="hidden" name="idx" value="<%=idx %>">
<input type="hidden" name="cpage" value="<%=cpage %>">
<% 
	}
%>
<table width="700" cellpadding="5">
<tr>
<% 
if (kind.equals("in")){
if (isLogin) { %>
<th width="15%">작성자</th><td width="35%"><%=loginInfo.getAi_name() %></td>
<th width="15%">작성일</th><td width="35%"><%=LocalDateTime.now() %></td>

<%
} else {
%>
<th width="15%">작성자</th><td width="35%"><%=loginInfo.getAi_name() %></td>
<th width="15%">작성일</th><td width="35%"><%=LocalDateTime.now() %></td>
<%
	}
}
%>
</tr>

<tr><th>글제목</th><td colspan="3">	<input type="text" name="ql_atitle" size="60" value="<%=ql_atitle %>" /></td></tr>
<tr><th>글내용</th><td colspan="3">	<textarea name="ql_answer" cols="65" rows="10"><%=ql_answer %></textarea></td></tr>
<tr><td colspan="4" align="center">
	<input type="submit" value="글<%=caption %>" />&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="reset" value="다시 입력" />&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" value="글목록" onclick="location.href='qna_list.jsp?cpage=<%=cpage %>';" />
</td></tr>
</table>
</form>
<%@ include file="../_inc/inc_foot.jsp" %>
