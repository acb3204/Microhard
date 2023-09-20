<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/qna_alist.jsp';");
	out.println("</script>");	
	out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 5, rcnt = 0, pcnt = 0;	// 페이지 번호, 페이지 크기, 블록 크기, 레코드(게시글) 개수, 페이지 개수 등을 저장할 변수
if (request.getParameter("cpage") != null)	cpage = Integer.parseInt(request.getParameter("cpage"));
String where =" where ql_isview = 'y' ";




try {
	stmt = conn.createStatement();
	sql = "select count(*) from t_qna_list " + where;
	rs = stmt.executeQuery(sql);
	if (rs.next()) rcnt = rs.getInt(1);
	
	pcnt = rcnt / psize;
	if (rcnt % psize > 0) pcnt++;
	
	int start = (cpage -1) * psize;
	sql = "select ql_idx,  mi_id, mi_nick, ql_title, if (date(ql_qdate) = curdate(), time(ql_qdate), replace(mid(ql_qdate, 3, 8), '-', '.')) qldate " +
			", ql_isanswer from t_qna_list " + where + "  order by ql_idx desc limit " + start + " , " + psize;
	rs = stmt.executeQuery(sql);
	// System.out.println(sql);
} catch (Exception e) {
	out.println("QnA 목록에서 문제가 발생했습니다");
	e.printStackTrace();
}

%>
<div align="center">
<h2>QnA 목록</h2>
<table width="700" border="0" cellpadding="10" cellspacing="0" id="list" >
<tr height="30">
<th width="10%">번호</th>
<th width="15%">답변 상태</th>
<th width="*" align="left">제목</th>
<th width="15%">작성일</th>
</tr>
<%
if (rs.next()) {
	int num = rcnt - (cpage - 1) * psize;
	do { 
		int titleCnt = 24;
		String title = rs.getString("ql_title"), isanswer = rs.getString("ql_isanswer");
		
		if (title.length() > titleCnt) 
			title = title.substring(0,titleCnt-3) + "...";
		title = "<a href='qna_alist_view.jsp?idx=" + rs.getInt("ql_idx") + "&cpage=" + cpage + "'>" + title + "</a>";

		//처리상태에 따라 텍스트 표시 변경
		String statusText = "";
		if (isanswer.equals("n")) {
		 statusText = "답변 전";
		} else if (isanswer.equals("y")) {
		 statusText = "답변 완료";
		}
		// System.out.println(title);
	
%>
<tr height="30" align="center">
<td><%=num %></td>
<td><%=statusText %></td>
<td align="left"><%=title %></td>
<td><%=rs.getString("qldate") %></td>
</tr>	
<% 
	num--;
	} while(rs.next());
}  %>
</table>
<br />
<table width="700">
<tr>
<td width="600">
<%
if (rcnt > 0) {	// 게시글이 있으면
	String link = "qna_alist.jsp?cpage=";
	if (cpage == 1) {
		out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
	} else {
		out.println("<a href='" + link + "1" + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");
		out.println("<a href='" + link + (cpage-1) +  "'>[이전]</a>&nbsp;&nbsp;");
	}
	
	int spage = (cpage -1) / bsize * bsize +1;	// 블록 시작 페이지 번호
	for (int i = 1, j = spage; i <= bsize && j <= pcnt; i++, j++) {	// i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수 j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
		if (j == cpage) {
			out.println("&nbsp;<strong>" + j + "</strong>&nbsp;");
		} else {
			out.println("&nbsp;<a href='" + link + j + "'>" + j + "</a>&nbsp;");
		}
	}
	
	if (cpage == pcnt) {
		out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
	} else {
		out.println("<a href='" + link + (cpage+1) + "'>[다음]</a>&nbsp;&nbsp;");
		out.println("<a href='" + link + pcnt + "'>[마지막]</a>&nbsp;&nbsp;&nbsp;");
	}
}
%>
</td>
</tr>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>
