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
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String args = "?cpage=" + cpage;
String br_select = "", br_title = "", br_content = "",  br_boradpms = "", br_replyuse = "", br_replypms = "", br_isanswer = "", mi_id = "", mi_nick = "";
try {
	stmt = conn.createStatement();
	sql = "update t_board_request set br_read = br_read + 1 where br_idx = " + idx;
	// System.out.println(sql);
	stmt.executeUpdate(sql);	// 조회수 증가 쿼리 실행
	
	sql = "select * from t_board_request where br_idx = " + idx;
	// System.out.println(sql);
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		br_select = rs.getString("br_select");
		br_title = rs.getString("br_title");
		br_content = rs.getString("br_content").replace("\r\n", "<br />");
		br_boradpms = rs.getString("br_boradpms");
		br_replyuse = rs.getString("br_replyuse");
		br_replypms = rs.getString("br_replypms");
		br_isanswer = rs.getString("br_isanswer");
		mi_id = rs.getString("mi_id");
		mi_nick = rs.getString("mi_nick");
	} else {
		out.println("<script>");
		out.println("alert('존재하지 않는 게시물입니다.');");
		out.println("history.back();");
		out.println("</script>");
		out.close();
	}

} catch(Exception e) {
	out.println("게시글 보기시 문제가 발생했습니다.");
	e.printStackTrace();
}
%>
<script>
function isDel() {
	if (confirm("정말 삭제하시겠습니까?")) {
		location.href = "board_rq_proc_del.jsp?idx=<%=idx %>";
	}
}

function reject() {
	if (confirm("반려하시겠습니까?")) {
		location.href = "board_rj.jsp?idx=<%=idx %>";
	}
}

function dupTable(table) {
	if (table.length > 0) {
		var dup = document.getElementById("dup");
		dup.src = "dup_table_chk.jsp?bt_id=" + table;
	} else { // 입력한 테이블 이름이 2글자 미만일 경우
		var msg = document.getElementById("msg");
		msg.InnerHTML = "게시판 이름은 2~20자 이내로 입력하세요.";
	}
}

function chkVal(frm) {
	   var isDup = table_name.isDup.value;
	   if (isDup == "n") {
	      alert("테이블 이름 중복확인을 하세요.");
	      table_name.br_table.focus();   // 디테일 하게 게시판 이름 중복 검사후 포커스를 아이디로 줌 
	      return false;
	   }
	   
	   return true;
}

</script>
<h2 align="center">게시판 요청</h2>
<iframe src="" id="dup" style="width:500px;  height:200px; border:1px black solid; display:none;"></iframe>
<table width="600" align="center">
	<tr>
		<th>작성자 아이디</th>
		<td><%=mi_id %></td>
		<th>작성자 닉네임</th>
		<td><%=mi_nick %></td>
	</tr>
</table>
<table width="700" cellpadding="5" align="center">
	<tr>
		<th>분류</th>
		<td colspan="5">
<% if (br_select.equals("a")) { %>
			스포츠
<% } else if (br_select.equals("b")) { %>
			연예
<% } else { %>
			게임
<% } %>
		</td>
	</tr>
	<tr>
		<th>게시판 이름</th>
		<td colspan="5"><%=br_title %></td>
	</tr>
	<tr>
		<th>용도</th>
		<td colspan="5"><%=br_content %></td>
	</tr>
	<tr>
		<th>게시판 사용 권한</th>
		<td colspan="5">
			<div>
				<input type="radio" name="boradpms" <% if(br_boradpms.equals("a")) {%> checked <% } %> onclick="return(false);" />회원
				<input type="radio" name="boradpms" <% if(br_boradpms.equals("b")) {%> checked <% } %> onclick="return(false);" />비회원
			</div>
		</td>
	</tr>
		<tr>
		<th>댓글 사용 여부</th>
		<td colspan="5">
			<div>
				<input type="radio" name="replyuse" <% if(br_replyuse.equals("a")) {%> checked <% } %> onclick="return(false);" />사용
				<input type="radio" name="replyuse" <% if(br_replyuse.equals("b")) {%> checked <% } %> onclick="return(false);" />미사용
			</div>
		</td>
	</tr>
<% if (br_replyuse.equals("a")) { %>
	<tr>
		<th>게시판 사용 권한</th>
		<td colspan="5">
			<div>
				<input type="radio" name="replypms" <% if(br_replypms.equals("a")) {%> checked <% } %> onclick="return(false);" />회원
				<input type="radio" name="replypms" <% if(br_replypms.equals("b")) {%> checked <% } %> onclick="return(false);" />비회원
			</div>
		</td>
	</tr>
<% } %>
</table>
<form name="table_name" action="board_reg.jsp" align="center" method="post" onsubmit="return chkVal(this);">
<input type="hidden" name="isDup" value="n" />
<% if(br_isanswer.equals("a")) { %>
	테이블 이름 : <input type="text" name="br_table" maxlength="20" size="12px" onkeyup="dupTable(this.value);" />
	<input type="text" style="display: none;" /><span id="msg" style="font-size:13px">20자 이내로 영어와 숫자로만 입력하세요.</span>
	<input type="hidden" name=idx value=<%=idx %> />
	<input type="hidden" name="br_select" value=<%=br_select %> />
	<input type="hidden" name="br_title" value=<%=br_title %> />
	<input type="hidden" name="br_boradpms" value=<%=br_boradpms %> />
	<input type="hidden" name="br_replyuse" value=<%=br_replyuse %> />
	<input type="hidden" name="br_replypms" value=<%=br_replypms %> />
<% } %>
<table width="700" cellpadding="5" align="center">
	<tr>
		<td><input type="button" value="목록" onclick="location.href='board_rq_alist.jsp<%=args %>'"/></td>
		<% if(br_isanswer.equals("a")) { %><td><input type="button" value="미승인" onclick="reject()" /></td><% } %>
		<td><% if(br_isanswer.equals("a")) { %><input type="submit" value="승인" /><% } %></td>
	</tr>
</table>
</form>
<%@ include file="../_inc/inc_foot.jsp" %>