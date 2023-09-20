<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
// view 화면에서 보여줄 게시글의 정보들을 저장할 변수들 
String fl_ismem = "", fl_writer = "", fl_title = "", fl_content = "", fl_ip = "", fl_date = "";
int fl_read = 0, fl_replay = 0;

try {
	stmt = conn.createStatement();
	sql = "update t_free_list set fl_read = fl_read + 1 where fl_idx = " + idx;
	stmt.executeUpdate(sql);		 // 조회수 증가 쿼리 실행
	
	sql = "select * from t_free_list where fl_isview = 'y' and  fl_idx = " + idx;
	rs = stmt.executeQuery(sql);
	
	if (rs.next()) {
		fl_ismem = rs.getString("fl_ismem");	fl_writer = rs.getString("fl_writer");
		fl_title = rs.getString("fl_title");	fl_ip = rs.getString("fl_ip");			
		fl_date = rs.getString("fl_date");		fl_read = rs.getInt("fl_read");
		fl_content = rs.getString("fl_content").replace("\r\n", "<br />");
		fl_replay = rs.getInt("fl_replay");
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}
	
} catch (Exception e) {
	out.println("게시판 글 보기시 문제가 발생했습니다.");
	e.printStackTrace();
} 
%>

<div align="center">
<h2>자유게시판 글 보기 </h2>
<table width="700" cellpadding="5">
<tr>
<th width="12%">작성자</th>
<td width="15%"><%=fl_writer %></td>
<th width="12%">작성일</th><td width="*"><%=fl_date %></td>
<th width="12%">조회수</th><td width="10%"><%=fl_read %></td>
</tr>
<tr><th>제목</th><td colspan="5"><%=fl_title %></td></tr>
<tr><th>내용</th><td colspan="5"><%=fl_content %></td></tr>
<tr><td colspan="6" align="center">
<%
boolean isPms = false; 		// 수정과 삭제 버튼을 현 사용자에게 보여줄지 여부를 저장할 변수 
String upLink = "", delLink = "";
if (fl_replay == 0){			// 댓글이 없을 경우에만 수정과 삭제를 허용 
	if (fl_ismem.equals("n")) {	// 현재 글이 비회원 글일 경우
		isPms = true;
		upLink = "free_form_pw.jsp" + args + "&kind=up&idx=" + idx;
		delLink = "free_form_pw.jsp" + args + "&kind=del&idx=" + idx;
	} else {	// 현재 글이 회원 글일 경우
		if (isLogin && loginInfo.getMi_nick().equals(fl_writer)) {
		// 현재 로그인이 되어 있는 상태에서 현 로그인 사용자가 현 게시글을 입력한 회원일 경우 
			isPms = true;
			upLink = "free_form_in.jsp" + args + "&kind=up&idx=" + idx;
			delLink = "free_proc_del.jsp?idx=" + idx;
		}
	}
}
if (isPms) {
%>
<hr width="700" align="left" />
	<input type="button" value="글수정" onclick="location.href='<%=upLink %>';"/>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<script>
function isDel () {
	if (confirm("정말 삭제하시겠습니까 ? \n 삭제된 글은 되살릴 수 없습니다.")) {
		location.href ="<%=delLink %>";
	} 
}
</script>
	<input type="button" value="글삭제" onclick="isDel();" />
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% } %>
	<input type="button" value="글목록" onclick="location.href='free_list.jsp<%=args %>';"/>
</td></tr>
</table>

<%

String msg = " placeholder='로그인 후에 사용하실수 있습니다 .'";
String dis = " disabled='disabled'";
String login = " onclick='goLogin(\"댓글 등록\");'";
if (isLogin) {
	msg = ""; dis = "";	login = "";
}


%>
<style>
.txt { width:530px; height:60px; }
.btn { width:100px; height:60px; }
.frmUp { display:none; }
</style>
<script>
function goLogin(msg) {
	if (confirm(msg + " 로그인이 필요합니다.\n로그인 화면으로 이동하시겠습니까?")) {
		location.href="../login_form.jsp?url=<%=loginUrl %>";
	}
}

function setCharCount(con, fr_idx) {
	var cnt = con.value.length;
	var obj = document.getElementById("charCnt" + fr_idx);
	obj.innerHTML = cnt;
	
	if (cnt > 200) {
		alert("댓글은 200자 까지만 입력가능합니다.");
		con.value = con.value.substring(0, 200);
		obj.innerHTML = 200;
	}
}

function replyDel(fr_idx) {
	if (confirm("정말 삭제하시겠습니까?")) {
		location.href="free_reply_proc.jsp<%=args %>&kind=del&fl_idx=<%=idx %>&fr_idx=" + fr_idx;
	}
}

function replyUp(fr_idx) {
// 'u'버튼을 클릭한 위치의 폼을 보여주거나 숨기는 함수 
	var frm = document.getElementById("frm" + fr_idx);
	if (frm.style.display == "block")
		frm.style.display = "none";
	else 
		frm.style.display = "block";
}

function goGnB(gnb, fr_idx) {		// 로그인한 회원이 '좋아요' 또는 '싫어요'를 클릭할 경우 이동시키는 함수 
	var frm = document.frmGnB;
	frm.kind.value = gnb;
	frm.fr_idx.value = fr_idx;
	frm.submit();
}
</script>

<hr width="700" align="center" />

<!-- 댓글 영역 시작 -->
<div id="replyBox" style="width:700px; text-align:center;">
	<form name="frmReply" action="free_reply_proc.jsp<%=args %>" method="post">
	<input type="hidden" name="kind" value="in" />
	<input type="hidden" name="fl_idx" value="<%=idx %>" />
	<table width="100%" cellpadding="5" >
	<tr>
	<td width="550" align="right">
		<textarea name="fr_content" class="txt" <%=msg + login %> onkeyup="setCharCount(this, ''); " ></textarea>
		<br />200자 이내로 입력하세요. (<span id="charCnt">0</span> / 200)
	</td>
	<td width="*" valign="top">
		<input type="submit" value="댓글 등록" class="btn" <%=dis %> />
	</td>
	</tr>
	</table>
	</form>
	<hr />
	<table width="100%" cellpadding="0" cellspacing="0" border="0" id="list">
	<tr><td colspan="5" align="left">댓글 개수 : <%=fl_replay %>개</td></tr>
<%
sql = "select * from t_free_reply where fr_isview = 'y' and fl_idx = " + idx;
try {
	rs = stmt.executeQuery(sql);
	if (rs.next()) {			// 해당 게시글에 댓글이 있을경우
		do {
			String date = rs.getString("fr_date").substring(2, 10) + 
					"<br />" + rs.getString("fr_date").substring(11);
					
			String gLink = "goLogin('좋아요와 싫어요는');", bLink = "goLogin('좋아요와 싫어요는');";
			if (isLogin) {
				sql = "select 1 from t_free_reply_gnb where mi_id = '" + loginInfo.getMi_id() + "' and fr_idx = " + rs.getInt("fr_idx");
				Statement stmt2 = conn.createStatement();
				ResultSet rs2 = stmt2.executeQuery(sql);
				if (rs2.next()) {		// 이미 현 댓글에 대해 좋아요 또는 싫어요를 했을 경우 
					gLink = "alert('이미 참여했습니다.');"; 
					bLink = gLink;
				} else {				// 아직 좋아요 또는 싫어요를 안했을 경우 
					gLink = "goGnB('g', " + rs.getInt("fr_idx") + ");";
					bLink = "goGnB('b', " + rs.getInt("fr_idx") + ");";
				}
				
				try { rs2.close(); stmt2.close(); } 
				catch(Exception e) { e.printStackTrace(); }
			}
%>
<tr align="left" valign="top">
<td width="100"><%=rs.getString("mi_nick") %> : </td> 
&nbsp;  
<td width="*"><%=rs.getString("fr_content").replace("\r/n", "<br />") %></td>
<td width="70"><%=date %></td>
<td width="70" align="right"> 
	<img src="../img/G.png" width="20" title="좋아요" class="hand" onclick="<%=gLink %>" />
	<%=rs.getInt("fr_good") %><br />
	<img src="../img/b.png" width="20" title="싫어요" class="hand" onclick="<%=bLink %>" />
	<%=rs.getInt("fr_bad") %>
</td>
<td width="22" align="right"> 
<% if (isLogin && loginInfo.getMi_nick().equals(rs.getString("mi_nick"))) { %>
	<img src="../img/delect.png" width="20" title="댓글 삭제" class="hand" onclick="replyDel(<%=rs.getInt("fr_idx") %>);" align=""/><br />
<% } %>
</td>
</tr>
<tr ><td colspan="5">
<% if (isLogin && loginInfo.getMi_nick().equals(rs.getString("mi_nick"))) { %>
	<form action="free_reply_proc.jsp<%=args %>" method="post" class="frmUp" id="frm<%=rs.getInt("fr_idx") %>">
	<input type="hidden" name="kind" value="up" />
	<input type="hidden" name="fl_idx" value="<%=idx %>" />
	<input type="hidden" name="fr_idx" value="<%=rs.getInt("fr_idx") %>" />
	<table width="100%" cellpadding="5">
	<tr>
	<td width="550" align="right">
		<textarea name="fr_content" class="txt" onkeyup="setCharCount(this, '<%=rs.getInt("fr_idx") %>');"><%=rs.getString("fr_content") %></textarea>
		<br />200자 이내로 입력하세요. (<span id="charCnt<%=rs.getInt("fr_idx") %>"><%=rs.getString("fr_content").length() %></span> / 200)
	</td>
	<td width="*" valign="top">
		<input type="submit" value="댓글 수정" class="btn" />
	</td>
	</tr>
	</table>
	</form>
<% } %>
</td></tr>
<% 
		} while (rs.next());
	} else {					// 해당 게시글에 댓글이 있을경우
		out.println("<tr><td align='center'>댓글이 없습니다.</td></tr>");
	}
	
} catch (Exception e) {
	out.println("댓글 목록에서 문제가 생겼습니다.");
	e.printStackTrace(); 
} finally {
	try { rs.close();	stmt.close(); } 
	catch (Exception e){ e.printStackTrace(); }
}
%>
	</table>
</div>
<form name="frmGnB" action="free_reply_proc.jsp<%=args %>" method="post">
<input type="hidden" name="kind" value="" />
<input type="hidden" name="fl_idx" value="<%=idx %>" />
<input type="hidden" name="fr_idx" value="" />
</form>
</div>
<br /><br /><br />
<br /><br /><br />
<br /><br /><br />
<%@ include file="../_inc/inc_foot.jsp" %>