<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 이용 가능합니다.');");
	out.println("location.href='../login_form.jsp?url=/mhAdmin/member/memberManage.jsp';");
	out.println("</script>");	
	out.close();
}
request.setCharacterEncoding("utf-8");
int cpage = 1, psize = 10, bsize = 6, rcnt = 0, pcnt = 0, joindate = 0;   // 페이지 번호, 페이지 크기, 블록 크기, 레코드(게시글) 개수, 페이지 개수 등을 저장할 변수, 회원가입일

if (request.getParameter("cpage") != null)   cpage = Integer.parseInt(request.getParameter("cpage"));   // cpage 값이 있으면 int형으로 형변환 하여 받음(보안상의 이유와 산술연산);

String schtype = request.getParameter("schtype");   // 검색 조건
String keyword = request.getParameter("keyword");   // 검색어
String schargs = "";                        // 검색관련 쿼리스트링을 저장할 변수
String where = " where 1 = 1 ";            // 검색 조건이 항상 참일 때 where절을 저장할 변수

if (schtype == null || schtype.equals("") || keyword == null || keyword.equals("")) {         // 검색을 하지 않은 경우
   schtype = "";   keyword = "";
} else {
   keyword = getRequest(keyword);
   URLEncoder.encode(keyword, "UTF-8");   // 쿼리스트링으로 주고 받는 검색어가 한글일 경우 IE에서 문제가 발생할 수도 있으므로 유니코드로 변환
   
   if (schtype.equalsIgnoreCase("nn")) {   // 검색조건이 '이름 + 닉네임'일 경우
      where += " and (mi_name like '%" + keyword + "%' " + " or mi_nick like '%" + keyword + "%') ";   
   } else {               // 검색조건이 '이름'이거나 '닉네임'일경우
      where += " and mi_" + schtype + " like '%" + keyword + "%' ";
   }
   schargs = "&schtype=" + schtype + "&keyword=" + keyword;   //   검색조건이 있을 경우 링크의 url에 붙일 쿼리스트링 완성
}
try {
   stmt = conn.createStatement();
   
   sql = "select count(*) from t_member_info " + where;   // 검색된 레코드의 총 개수를 구하는 쿼리 : 페이지 개수를 구하기 위해
   rs = stmt.executeQuery(sql);
   if (rs.next()) rcnt = rs.getInt(1);   // count() 함수를 사용하므로 ResultSet 안의 데이터 유무는 검사할 필요가 없음
   pcnt = rcnt / psize;
   if (rcnt % psize > 0) pcnt++;   // 전체 페이지 수
   
   int start = (cpage - 1) * psize;
   sql = "select mi_idx, mi_id, mi_name, mi_nick, if (date(mi_date) = curdate(), time(mi_date), replace(mid(mi_date, 3, 8), '-', '.')) midate, mi_status " + 
   " from t_member_info " + where + " order by mi_idx desc limit " + start +", " + psize;
 //  System.out.println(sql);
   rs = stmt.executeQuery(sql);
} catch (Exception e) {
   out.println("회원목록에서 문제가 발생했습니다");
   e.printStackTrace();
}
%>
 <script>
 
function getMemberInfo(miIdx) {
  var http = new XMLHttpRequest();
  var url = '/mhAdmin/member/memberSearch.jsp';
  var params = 'mi_idx=' + miIdx;
  http.open('POST', url, true);

  http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

  http.onreadystatechange = function() {
    if (http.readyState === 4 && http.status === 200) {
      var resData = JSON.parse(http.responseText);
      console.log(resData);
      
      // Handle the received data here
      // For example, update the modal with the member information
      var content = "<div>";
      content += resData.mi_id + "<br>";
      content += resData.mi_pw + "<br>";
      content += resData.mi_name + "<br>";
      content += resData.mi_nick + "<br>";
      content += resData.mi_phone + "<br>";
      content += resData.mi_email + "<br>";
      content += resData.mi_status + "<br>";
      content += resData.mi_date;
      content += "</div>";
      
      document.getElementById("mbr_result").innerHTML = content;
      modalOpen();
    }
  };
  http.send(params);
}

// document.getElementById  이게 뭔지. getElementById 얜 뭐하는 앤지..??
      // style.display  이런건 뭔지?

//모달열기
function modalOpen(){
   var modal = document.getElementById('modal');
   var modalBg = document.querySelector('.modal-bg');
   
   modal.style.display = "block"; // 노출 설정
    modalBg.style.display = "block";
}

// 모달닫기
function modalClose(){
   var modal = document.getElementById('modal');
   var modalBg = document.querySelector('.modal-bg');
   modal.style.display = "none";   // 숨김 설정
   modalBg.style.display = "none";
}

//초기화 함수. 해당 페이지 로딩이 끝나면 실행됨
window.onload = function() {
   // 모달닫기/배경화면 클릭시 모달닫기 클릭이벤트 연결
   document.querySelector('.modal-bg, .modal-close').addEventListener('click', function(e) {
      modalClose();
   });
}

</script>

<!-- table 태그는 어떻게 쓰는지..   -->
<div align="center">
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
<tr height="30">
<tr><td colspan="2">
   <form name="frmSch">   <!-- action과 method속성은 각각 기본값인 현재 파일과 get을 사용할 것임 -->
   <fieldset>
      <legend>회원 검색</legend>
      <select name="schtype">
         <option value="name" <% if (schtype.equals("name")) { %>selected="selected"<% } %>>이름</option>
         <option value="nick" <% if (schtype.equals("nick")) { %>selected="selected"<% } %>>닉네임</option>
         <option value="nn" <% if (schtype.equals("nn")) { %>selected="selected"<% } %>>이름+닉네임</option>
      </select>
      <input type="text" name="keyword" value="<%=keyword %>" />
      <input type="submit" value="검색" />
      &nbsp;&nbsp;&nbsp;&nbsp;
   </fieldset>
   </form>
</td></tr>
</table>
<h2>회원 목록</h2>
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
<tr height="30">
<th width="10%">번호</th><th width="15%">회원상태</th><th width="*%">닉네임</th><th width="15%">이름</th><th width="25%">회원아이디</th><th width="25%">회원가입일</th></tr>
<%
if (rs.next()) {
   int num = rcnt - (cpage - 1) * psize;
   do {
      String title = rs.getString("mi_name");
      String allTitle = null, title2 = "";
      if (title.length() > 20) {
         allTitle = title;
         title = title.substring(0, 19) + "...";
        
         } 
		String mistatus = "정상";
		if (rs.getString("mi_status").equals("b"))
			mistatus = "휴면";
		else if (rs.getString("mi_status").equals("c"))
			mistatus = "탈퇴";
%>
<tr height="30" align="center">

<td onclick="modal('my_modal', <%=rs.getString("mi_idx")%>)"><%=num %></td>
<td><%=mistatus %></td>
<td><%=rs.getString("mi_nick") %></td>
<td><%=rs.getString("mi_name") %></td>
<td><%=rs.getString("mi_id") %><button id="popup_open_btn" onclick="getMemberInfo(<%=rs.getString("mi_idx")%>)">회원정보</button></td>
<td><%=rs.getString("midate") %></td>
</tr>

<%      
      num--;
   } while (rs.next());
} else {   // 보여줄 게시글이 없는 경우
   out.println("<tr height='30'><td colspan='6' align='center'>");
   out.println("검색결과가 없습니다.</td></tr>");
}
%>
</table>
<br />
<table width="700" border="0" cellpadding="6">
<tr>
<td width="600"></td>
<%
if (rcnt >0) {
   String link = "memberManage.jsp?cpage=";
   if (cpage == 1) {
      out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
   } else {
      out.println("<a href='" + link + "1" + schargs + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");
      out.println("<a href='" + link + (cpage-1) + schargs + "'>[이전]</a>&nbsp;&nbsp;");
   }

   int spage = (cpage -1) / bsize * bsize +1;   // 블록 시작 페이지 번호
   
   for (int i = 1, j = spage; i <= bsize && j <= pcnt; i++, j++) {   // i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수 j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
      if (j == cpage) {
         out.println("&nbsp;<strong>" + j + "</strong>&nbsp;");
      } else {
         out.println("&nbsp;<a href='" + link + j + schargs + "'>" + j + "</a>&nbsp;");
      }
   }

   if (cpage == pcnt) {
      out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
   } else {
      out.println("<a href='" + link + (cpage+1) + schargs + "'>[다음]</a>&nbsp;&nbsp;");
      out.println("<a href='" + link + pcnt + schargs + "'>[마지막]</a>&nbsp;&nbsp;&nbsp;");
   }
}
%>
</table>

<%@ include file="../_inc/inc_foot.jsp" %>

<!-- modal 영역 -->
<div class="modal-bg" onClick="javascript:modalClose();"></div>
<div id="modal" class="modal-wrap">
    <button class="modal-close" style="float:right" onClick="javascript:modalClose();">닫기</button>
    <div id="mbr_result" style="padding:30px">
    </div>
</div>
</div>
<!-- //modal 영역 -->