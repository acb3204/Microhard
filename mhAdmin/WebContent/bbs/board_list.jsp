<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/board_list.jsp';");
	out.println("</script>");	
	out.close();
}
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 10, rcnt = 0, pcnt = 0;
// 피이지 번호,	 페이지 크기, 	블록크기 ,	레코드(개시글)개수 , 페이지 개수 등을 저장할 병수 

if (request.getParameter("cpage") != null) 
	cpage = Integer.parseInt(request.getParameter("cpage"));

String schtype = request.getParameter("schtype");	// 검색 조건 
String keyword = request.getParameter("keyword");	// 검색어 
String schargs = "";
String where = " where bl_isview = 'y' ";
String id = request.getParameter("id");
String bt_boardpms = "", bt_name = "";

if (schtype == null || schtype.equals("") || keyword == null || keyword.equals("")) {      // 검색을 하지 않는 경우
	   schtype = ""; keyword = "";
	} else {   // 검색을 할 경우
		bt_boardpms = request.getParameter("bt_boardpms");
	   	keyword = getRequest(keyword);
	   	URLEncoder.encode(keyword, "utf-8");
	   	// 쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수도 있으므로 유니코드로 변환
	   
	  	if (schtype.equals("tc")) {   // 검색조건이 '제목 + 내용'일 경우
	  		where += " and (bl_title like '%" + keyword + "%' " +
	     	" or bl_content like '%" + keyword + "%') ";
	   	} else if (schtype.equals("writer")){	// 검색조건이 작성자 일 경우 
		   if (bt_boardpms.equals("a")) {
			   where += " and mi_nick = '" + keyword + "' ";
		   } else {
			   where += " and bl_writer = '" + keyword + "' ";
		   }
	   	} else {      // 검색조건이 '제목'이거나  '내용'일 경우
	      	where += " and bl_" + schtype + " like '%" + keyword + "%' ";
	   	}
	   	schargs = "&schtype=" + schtype + "&keyword=" + keyword;
	   	// 검색조건이 있을 경우 링크의url에 붙일 쿼리스트링 완성 
	}

try {
	stmt = conn.createStatement();
	
	// 게시판관련 정보 받아오는 쿼리
	sql = "SELECT bt_boardpms, bt_name FROM t_board_total_list WHERE bt_id = '" + id + "'";
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		bt_boardpms = rs.getString("bt_boardpms");
		bt_name =  rs.getString("bt_name");
	}
	
	try {
		stmt.close();
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	stmt = conn.createStatement();
	
	// 게시판 레코드의 개수(검색조건 포함 )를 받아 올 쿼리
	sql = "select count(*) from t_board_" + id + "_list " + where;
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if (rs.next()) rcnt = rs.getInt(1);
	
	pcnt = rcnt / psize;
	if (rcnt % psize > 0) pcnt++;
	
	int start = (cpage - 1) * psize;
	if (bt_boardpms.equals("a")) {
		// 회원만 작성 가능한 게시판 쿼리
		sql = "select bl_idx, mi_nick, bl_title, bl_replay, bl_read, " +
				"if (curdate() = date(bl_date),  time(bl_date), replace(mid(bl_date, 3, 8), '-', '.')) bldate " +
				" from t_board_" + id + "_list " +  where + " order by bl_idx desc limit " + start + ", " + psize;
	} else {
		// 비회원도 작성 가능한 게시판 쿼리
		sql = "select bl_idx, bl_ismem, bl_writer, bl_title, bl_replay, bl_read, " +
				"if (curdate() = date(bl_date),  time(bl_date), replace(mid(bl_date, 3, 8), '-', '.')) bldate " +
				" from t_board_" + id + "_list " +  where + " order by bl_idx desc limit " + start + ", " + psize;
	}
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);		
	
} catch (Exception e) {
	out.println(bt_name + " 목록에서 문제가 발생했습니다 .");
	e.printStackTrace();
}
%>
<div align="center">
<h2><%=bt_name %> 게시판 목록</h2>

<table width="700" border="0" cellpadding="0" cellspacing="0" id="list" >
<tr height="30">
<th width="10%">번호</th>
<th width="*">제목</th>
<th width="15%">작성자</th>
<th width="15%">작성일</th>
<th width="10%">조회</th>
</tr>
<%
if (rs.next()) {			// rs.next 제일 먼저 rs가 있는지 검사해야함 
	int num = rcnt - (cpage - 1) * psize;
	// fl_idx 가 글번호가 아니기 때문에 num 이라는 변수를 선언해 보여줄 글 번호를 따로 구함 (밖에다 선언해도 문제는 없음 근데 if 안에다 하는게 정석 )
	do {	// // next 를 썻기에 do while 을 사용함 
		// 제목은 링크달아주기, 글자수 ,
		int titleCnt = 24;
		String reply = "", title = rs.getString("bl_title");
		// 댓글			// 타이틀이라는 변수에  rs.getString("fl_title") 사용해 DB에서 불러온 값을 넣어줌;
		if (rs.getInt("bl_replay") > 0) {
			titleCnt = titleCnt - 3;
			reply = " [" + rs.getInt("bl_replay") + "]";
		}  //  제목 뒤에 댓글 개수 보여주려고 댓글 개수를 구함 [] 안에 댓글 개수 넣어줌 
		if (title.length() > titleCnt)   title = title.substring(0, titleCnt - 3) + "...";
	      // 타이틀의 길이가 21자가 넘어가면 뒤에 ... 을 붙여줌 
		title = "<a href='board_view.jsp?id=" + id + "&idx=" + rs.getInt("bl_idx") + "&cpage=" + cpage + schargs + "'>" + title + "</a>" + reply;
	      // 타이틀2 라는 변수에 뒤에 쿼리 스트링을 붙여 생성하고 누르면 free_view 라는 jsp 파일로 넘어가게 함  // 뒤에 제목 뒤에 댓글 개수 보여줌
%>
<tr height="30" align="center">
<td><%=num %></td>
<td align="left"><%=title %></td>
<% if (bt_boardpms.equals("a")) { %>
<td><%=rs.getString("mi_nick") %></td>
<% } else { %>
<td><%=rs.getString("bl_writer") %></td>
<% }%>
<td><%=rs.getString("bldate") %></td>
<td><%=rs.getString("bl_read") %></td>
</tr>
<% 	      
	num--; 
	} while (rs.next());
	 
} else {		// 보여줄 게시글 결과가 없을 때
	 out.println("<tr height='30'><td colspan='5' align='center'> ");
	 out.println("검색결과가 없습니다.</td></tr>");		
}

%>
</table>
<br />
<table width="700">
<tr>
<td width="600">
<%
if (rcnt > 0) {		// 게시글이 있을경우만 번호를 찍음
	String link = "board_list.jsp?id=" + id + "&cpage=";			// 이동할 링크를 미리 변수에 담아둠 
	if (cpage == 1) {
	      out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
	   } else {
	      out.println("<a href='" + link + "1" + schargs + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");
	      out.println("<a href='" + link + (cpage - 1) + schargs + "'>[이전]</a>&nbsp;&nbsp;&nbsp;");
	   }
	
	   int spage = (cpage - 1) / bsize * bsize + 1;      // 블록 시작페이지 번호 
	   for (int i = 1, j = spage ; i <= bsize && j <= pcnt; i++,j++) {
	   // i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수 
	   // j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
	      if (j == cpage) {
	         out.println("&nbsp;<strong>"+ j + "</strong>&nbsp;");
	      } else {
	         out.println("&nbsp;<a href='" + link + j + schargs + "'>" + j + "</a>&nbsp;");
	      }
	   }			// 페이지 번호
	
	if (cpage == pcnt) {
	      out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
	   } else {
	      out.println("&nbsp;&nbsp;<a href='" + link + (cpage + 1) + schargs + "'>[다음]</a>");
	      out.println("&nbsp;&nbsp;<a href='" + link + pcnt + schargs + "'>[마지막]</a>");
	   }		// 복사에서 쓸때는 link 변수 에 들어가는 url 만 확인하셈
}
%>
</tr>
<tr>
<td>
<div style="width:700px; text-align:right;">		<!-- 검색 폼 생성  -->
<form name="frmSch" >
<fieldset>		<!-- 컨트롤을 묶어줄때는  fieldset 을 사용-->
	<legend></legend>
	<input type="hidden" name="id" value="<%=id %>" />
	<input type="hidden" name="bt_boardpms" value="<%=bt_boardpms %>" />
	<select name="schtype">			<!-- 검색 창에 사용될  select 를 생성 -->
		<option value="title" <% if (schtype.equals("title")) { %> selected="selected"<% } %>>제목</option>
		<option value="content" <% if (schtype.equals("content")) { %> selected="selected"<% } %>>내용</option>
		<option value="writer" <% if (schtype.equals("writer")) { %> selected="selected"<% } %>>작성자</option>
		<option value="tc" <% if (schtype.equals("tc")) { %> selected="selected"<% } %>>제목+내용</option>
	</select>
	<input type="text" name="keyword" value="<%=keyword %>" />
	<input type="submit" value="검색" />&nbsp;&nbsp;&nbsp;&nbsp;			<!-- 검색 창에 사용될  컨트롤 들을 생성 -->
	<input type="button" value="전체 글보기" onclick="location.href='board_list.jsp?id=<%=id %>';" />
</fieldset>
</form>
</div>
</td>
</tr>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>