<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
out.println("<script>");
out.println("alert('로그인 후 이용 가능합니다.');");
out.println("location.href='../login_form.jsp?url=bbs/board_rq_alist.jsp';");
out.println("</script>");	
out.close();
}
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 10, rcnt = 0, pcnt = 0;

if (request.getParameter("cpage") != null)
	cpage = Integer.parseInt(request.getParameter("cpage"));

String schargs = "";
// String mi_id = loginInfo.getMi_id();
String where = " WHERE br_isview = 'y' ";

try {
	stmt = conn.createStatement();
	
	sql = "SELECT COUNT(*) FROM t_board_request ";
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if(rs.next()) 
		rcnt = rs.getInt(1);
	
	pcnt = rcnt / psize;
	if(rcnt % psize > 0)
		pcnt++;
	
	int start = (cpage - 1) * psize;
	sql = "SELECT br_idx, mi_id, mi_nick, br_isanswer, br_select, br_title, IF (CURDATE() = DATE(br_date), TIME(br_date), REPLACE(MID(br_date, 3, 8), '-', '.')) br_date, br_read FROM t_board_request " + where + "order by br_idx desc limit " + start + ", " + psize;
	// System.out.println(sql);
	
	rs = stmt.executeQuery(sql);
} catch(Exception e) {
	out.println("게시판 요청등록 목록에서 문제가 발생했습니다.");
	e.printStackTrace();
}
%>

<h2 align="center">게시판 요청 목록</h2>
<table width="800" border="0" cellpadding="0" cellspacing="0" id="list" align="center">
	<tr height="30">
		<th width="8%">번호</th>
		<th width="15%">승인 / 미승인</th>
		<th width="8%">분류</th>
		<th width="*" align="left">게시판 이름</th>
		<th width="10%">아이디</th>
		<th width="10%">닉네임</th>
		<th width="12%">작성일</th>
		<th width="8%">조회</th>
	</tr>
	<%
	if (rs.next()) {
		int num = rcnt - ((cpage - 1) * psize);
		do {
			int titleCnt = 24;
			String reply = "",  title = rs.getString("br_title"), id = rs.getString("mi_id"), nick = rs.getString("mi_nick");
			
			if (title.length() > titleCnt)
				title = title.substring(0, titleCnt - 3) + "...";
			title = "<a href='board_rq_aview.jsp?idx=" + rs.getInt("br_idx") + "&cpage=" + cpage + schargs + "'>" + title + "</a>";
			// System.out.println(title);
			
			String isanswer = "승인전";
			if (rs.getString("br_isanswer").equals("b"))
				isanswer = "승인";
			else if (rs.getString("br_isanswer").equals("c"))
				isanswer = "반려";
			
			String select = "게임";
			if (rs.getString("br_select").equals("a"))
				select = "스포츠";
			else if (rs.getString("br_select").equals("b"))
				select = "연예";
	%>
	<tr height="30" align="center">
	<td><%=num %></td>
	<td><%=isanswer %></td>
	<td><%=select %></td>
	<td align="left"><%=title %></td>
	<td><%=id %></td>
	<td><%=nick %></td>
	<td><%=rs.getString("br_date") %></td>
	<td><%=rs.getString("br_read") %></td>
	</tr>
	<%
			num--;
		} while(rs.next());
	}else {	// 보여줄 게시글이 없을 경우
		out.println("<tr height='30'><td colspan='5' align='center'>글이 없습니다.</td></tr>");
	}
	%>
</table>
<table width="800" align="center">
	<tr align="center">
		<td>
		<% 
		if (rcnt > 0) { // 게시글이 있으면
			String link = "board_rq_alist.jsp?cpage=";
			if (cpage == 1) {
				out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
			} else {
				out.println("<a href='" + link + "1" + schargs + "'>[처음]</a>");
				out.println("&nbsp;&nbsp;&nbsp;");
				out.println("<a href='" + link + (cpage - 1) + schargs + "'>[이전]</a>");
				out.println("&nbsp;&nbsp;");
			}
			
			int spage = (cpage - 1) / bsize * bsize + 1;	// 블록 시작페이지 번호
			for (int i = 1, j = spage; i <= bsize && j <= pcnt; i++, j++) {
			// i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수
			// j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
				if (j == cpage) {
					out.println("&nbsp;<strong>" + j + "</strong>&nbsp;");
				} else {
					out.println("&nbsp;<a href='" + link + j + schargs + "'>" + j + "</a>&nbsp;");
				}
			}
			
			if (cpage == pcnt) {
				out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
			} else {
				out.println("&nbsp;&nbsp;");
				out.println("<a href='" + link + (cpage + 1) + schargs + "'>[다음]</a>");
				out.println("&nbsp;&nbsp;&nbsp;");
				out.println("<a href='" + link + pcnt + schargs + "'>[마지막]</a>");
			}
		}
		%>
		</td>
	</tr>
</table>

<%@ include file="../_inc/inc_foot.jsp" %>