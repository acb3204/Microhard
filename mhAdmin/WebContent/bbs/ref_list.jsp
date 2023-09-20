<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=bbs/ref_list.jsp';");
	out.println("</script>");	
	out.close();
}
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 10, rcnt = 0, pcnt = 0;
// 페이지 번호         페이지크기 ,   블록크기   , 레코드(게시글), 페이지 개수 등을 저장할 변수

if (request.getParameter("cpage") != null)  cpage = Integer.parseInt(request.getParameter("cpage"));
// cpage 값이 있으면 int형으로 형변환하여 받음(보안상의 이유와 산술연산을 해야 하기 때문)

String schtype = request.getParameter("schtype");      // 검색 조건
String keyword = request.getParameter("keyword");      // 검색어
String schargs = "";                        // 검색관련 쿼리스트링을 저잘할 변수 
String where = " where rl_isview = 'y' ";         // 검색조건이 있을경우 where 절을 저장할 변수 

if (schtype == null || schtype.equals("") || keyword == null || keyword.equals("")) {      // 검색을 하지 않는 경우
   schtype = ""; keyword = "";
} else {   // 검색을 할 경우
   keyword = getRequest(keyword);
   URLEncoder.encode(keyword, "utf-8");
   // 쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수도 있으므로 유니코드로 변환
   
   if (schtype.equals("tc")) {   // 검색조건이 '제목 + 내용'일 경우
      where += " and (rl_title like '%" + keyword + "%' " +
     " or rl_content like '%" + keyword + "%') ";
   } else {      // 검색조건이 '제목'이거나  '내용'일 경우
      where += " and rl_" + schtype + " like '%" + keyword + "%' ";
   }
   schargs = "&schtype=" + schtype + "&keyword=" + keyword;
   // 검색조건이 있을 경우 링크의url에 붙일 쿼리스트링 완성 
}

try {
   stmt = conn.createStatement();
   
   sql = "select count(*) from t_ref_list " + where;
   // 검색된 레코드의 총 개수를 구하는 쿼리: 페이지 개수를 구하기 위해서 
   rs = stmt.executeQuery(sql);
   if (rs.next()) rcnt = rs.getInt(1);   //count()함수를 사용하므로 ResultSet 안에 데이터 유무를 검사할 필요가 없음 
   
   pcnt = rcnt / psize;
   if (rcnt % psize > 0) pcnt++;      // 전체 페이지 수 
   
   int start = (cpage - 1) * psize;   
   sql = "select rl_idx, rl_title,  rl_read, rl_name, " +
         " if (curdate() = date(rl_date),  time(rl_date), replace(mid(rl_date, 3, 8), '-', '.')) rldate " +
         " from t_ref_list " + where + " order by rl_idx desc limit " + start + ", " + psize;
//   System.out.println(sql);
   rs = stmt.executeQuery(sql);
   
} catch (Exception e) {
   out.println("공지사항 목록에서 문제가 발생했습니다 .");
   e.printStackTrace();
}
%>
<div align="center">
<h2>자료실 목록</h2>
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
<tr height="30">
<th width="10%">번호</th><th width="*">제목</th>
<th width="15%">작성일</th><th width="10%">조회</th>
</tr>
<%
if (rs.next()) {
   int num = rcnt - (cpage - 1) * psize;
   do {   
      String title = rs.getString("rl_title");
      String allTitle = null, title2 = "";
      if (title.length() > 23) { 
         allTitle = title;
         title = title.substring(0,22) + "...";
      }
    
      title2 = "<a href='ref_view.jsp?idx=" + rs.getInt("rl_idx") + 
            "&cpage=" + cpage + schargs + "'";
      if (allTitle != null) title2 += " title='" + allTitle + "'";
      title2 += ">" + title + "</a>";
      
      String nnn = rs.getString("rl_name");
      
%>
<tr height="30" align="center">
<td><%=num %></td>
<td align="left"><%=title2 %> <% if (!rs.getString("rl_name").equals("")) { %>
				 <img src="../img/disk.png" height="14" width="16"> 
				 <% } else { %>
				 <img src="../img/hidden.png" height="14" width="16">
				 <% } %></td>
<td><%=rs.getString("rldate") %></td>
<td><%=rs.getString("rl_read") %></td>
</tr>   
<%
   num --;
   } while (rs.next());
   
} else {      // 보여줄 게시글이 없을 경우 
   out.println("<tr height='30'><td colspan='5' align='center'> ");
   out.println("검색결과가 없습니다.</td></tr>");
}
%>
</table>
<br />
<table width="700" border="0" cellpadding="5">
<tr>
<td width="600">
<%
if (rcnt > 0) {
   String link = "ref_list.jsp?cpage=";
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
   }
   
   if (cpage == pcnt) {
      out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
   } else {
      out.println("&nbsp;&nbsp;<a href='" + link + (cpage + 1) + schargs + "'>[다음]</a>");
      out.println("&nbsp;&nbsp;<a href='" + link + pcnt + schargs + "'>[마지막]</a>");
   }
}
%>
</td>
<td width="*" align="right">
<% if (isLogin) { %>
   <input type="button" value="지료실 등록" onclick="location.href='ref_form.jsp?kind=in';" />
<% } %>
</td>
</tr>
<tr><td colspan="2">
   <form name="frmSch">
   <!--  action 과 method 속성은 각각 기본값인 현재 파일과 get 을 사용할 것임 -->
   <fieldset>
      <legend>자료실 검색</legend>
      <select name="schtype">
         <option value="title" <% if (schtype.equals("title")) { %> selected="selected"<% } %>>제목</option>
         <option value="content" <% if (schtype.equals("content")) { %> selected="selected"<% } %>>내용</option>
         <option value="tc" <% if (schtype.equals("tc")) { %> selected="selected"<% } %>>제목 + 내용</option>
      </select>
      <input type="text" name="keyword" value="<%=keyword %>" />
      <input type="submit" value="검색" />
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" value="전체 글보기" onclick="location.href='ref_list.jsp';" />
   </fieldset>
   </form>
</td></tr>
</table>
</div>
<%@ include file="../_inc/inc_foot.jsp" %>