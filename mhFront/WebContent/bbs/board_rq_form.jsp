<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
%>
<script>
function cls() {
	if (confirm("글 작성을 취소하시겠습니까?")) {
		location.href = "board_rq_ulist.jsp";
	}
}

function setDisplay(tem) {
	if(tem == "a") {
		document.getElementById("show").style.display = "";
	} else {
		document.getElementById("show").style.display = "none";
	}
}

function dupTitle(title) {
	if (title.length > 1) {
		var dup = document.getElementById("dup");
		dup.src = "dup_chk.jsp?br_title=" + title;
	} else { // 입력한 테이블 이름이 2글자 미만일 경우
		var msg = document.getElementById("msg");
		msg.InnerHTML = "게시판 이름은 2~20자 이내로 입력하세요.";
	}

}

function chkVal(frm) {
	   var isDup = frm.isDup.value;
	   if (isDup == "n") {
	      alert("게시판 이름을 확인 하세요.");
	      frm.br_title.focus();   // 디테일 하게 게시판 이름 중복 검사후 포커스를 아이디로 줌 
	      return false;
	   }
	   
	   return true;
}

</script>
<h2 align="center">게시판 요청</h2>
<iframe src="" id="dup" style="width:500px;  height:200px; border:1px black solid; display:none;"></iframe>
<form name="frm" action="board_rq_proc_in.jsp" method="post" onsubmit="return chkVal(this);">
<input type="hidden" name="isDup" value="n" />
<table width="700" cellpadding="5" align="center">
	<tr>
		<th>분류</th>
		<td colspan="5">
		<select name="br_select">
			<option value="a">스포츠</option>
			<option value="b">연예</option>
			<option value="c">게임</option>
		</select>
		</td>
	</tr>
	<tr>
		<th>요청할 게시판 이름</th>
		<td colspan="5">
		<input type="text" name="br_title" placeholder="게시판 이름 입력" maxlength="20" onkeyup="dupTitle(this.value);" />
		<input type="text" style="display: none;" />
		<span id="msg" style="font-size:13px">게시판 이름은 2~20자 이내로 입력하세요.</span>
		</td>
	</tr>
	<tr>
		<th>용도</th>
		<td colspan="5"><textarea name="br_content" cols="65" rows="10" maxlength="1000"></textarea></td>
	</tr>
	<tr>
		<th>게시판 사용 권한</th>
		<td colspan="5">
			<input type="radio" id="br_boradpms" name="br_boradpms" value="a" checked="checked" />회원
			<input type="radio" id="br_boradpms" name="br_boradpms" value="b" />비회원
		</td>
	</tr>
		<tr>
		<th>댓글 사용 여부</th>
		<td colspan="5">
			<input type="radio" id="br_replyuse" name="br_replyuse" value="a" onclick="setDisplay(this.value)" />사용
			<input type="radio" id="br_replyuse" name="br_replyuse" value="b" checked="checked" onclick="setDisplay(this.value)" />미사용
		</td>
	</tr>
	<tr id=show style="display: none;">
		<th>댓글 사용 권한</th>
		<td colspan="5">
			<input type="radio" id="br_replypms" name="br_replypms" value="a" checked="checked" />회원
			<input type="radio" id="br_replypms" name="br_replypms" value="b" />비회원
		</td>
	</tr>
	<tr>
	<td><input type="submit" value="요청하기" /></td>
	<td><input type="button" value="취소" onclick="cls()"/></td>
	<td></td>
	</tr>
</table>
</form>
<%@ include file="../_inc/inc_foot.jsp" %>