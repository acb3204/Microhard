<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<% 
request.setCharacterEncoding("utf-8"); 
%>

<title>회원가입</title>
<style type="text/css">
label {
	width: 160px;
	display: inline-block;
	float: center;
	
}
   table {
    width: 48%;
    border-top: 1px solid #444444;
    border-collapse: collapse;
    text-align : center;
  }
  th, td {
    border-bottom: 1px solid #444444;
    padding: 10px;
    text-align: center;
  }
  th:nth-child(2n), td:nth-child(2n) {
    background-color: FFFAFA;
  }
  th:nth-child(2n+1), td:nth-child(2n+1) {
    background-color: 	#FFF0F5;
  }
 #td1 { color: #000; }
</style>

<script> 
function dupID(id) {
   if (id.length > 3) {
      var dup = document.getElementById("dup");
      dup.src = "dup_id_chk.jsp?kind=id&mi_id=" + id;
   } else {   // 입력한 아이디가 4글자 미만일 경우 
      var msg = document.getElementById("msg");
      msg.innerHTML = "아이디는 4~20자 이내로 입력하세요.";
   }
}

function dupNick(nick) {
	   if (nick.length > 1) {
	      var dup = document.getElementById("dup");
	      dup.src = "dup_id_chk.jsp?kind=nick&mi_nick=" + nick;
	   } else {   // 입력한 닉네임이 2글자 미만일 경우 
	      var msg1 = document.getElementById("msg1");
	      msg1.innerHTML = "닉네임은 2~20자 이내로 입력하세요.";
	   }
	}
	
function dupEmail() {
	var frm = document.frmJoin;
	var email = frm.firstmail.value + "@" + frm.lastmail.value;
	if (email.length > 1) {
		var dup = document.getElementById("dup");
		dup.src = "dup_id_chk.jsp?kind=email&mi_email=" + email;
	} else {   // 이메일을 입력하지 않았을 경우 
		var msg2 = document.getElementById("msg2");
		msg2.innerHTML = "이메일을 입력해 주세요.";
	}
}

function chkVal(frm) {
	if (frm.mi_name.value == "") {
		alert("이름을  써주세요.");
		frm.mi_name.focus();
		return false;
	}

	var mi_pw = frm.mi_pw.value;
	if (mi_pw == "") {
      alert("비밀번호를 입력하세요");
      frm.mi_pw.focus();   
      return false;
   }
	
   var isDup1 = frm.isDup1.value;
   if (isDup1 == "n") {
      alert("닉네임 중복확인을 하세요.");
      frm.mi_nick.focus();   // 디테일 하게 닉네임 중복 검사후 포커스를 아이디로 줌 
      return false;
   }

	if (frm.email1.value == "") {
		alert("이메일을 작성해주세요.");
		frm.email1.focus();
		return false;
	}
	
	var isDup2 = frm.isDup2.value;
	   if (isDup2 == "n") {
	      alert("이메일 중복확인을 하세요.");
	      frm.mi_email.focus();   // 디테일 하게 이메일 중복 검사후 포커스를 아이디로 줌 
	      return false;
	   }
	
	if (frm.mail.value == "") {
		alert("도메인을 직접 입력해주시거나 선택해주세요.");
		frm.mail.focus();
		return false;
	}
	
	if (frm.p2.value.length < 4) {
		alert("휴대폰 번호를 입력해 주세요.");
		frm.p2.focus();
		return false;
	}
	
	if (frm.p3.value.length < 4) {
		alert("휴대폰 번호를 입력해 주세요.");
		frm.p3.focus();
		return false;
	}
   return true;
}

function email_change(value) { // 체크박스에서 이메일 선택시 값변경
   if(value == 0) {
      document.getElementById("lastmail").value = "";
      // document.getElementById("mail2").disabled = false;
   } else {
      document.getElementById("lastmail").value = value;
      // document.getElementById("mail2").disabled = true;
   }
}

function handleOnInput(e)  {
	  e.value = e.value.replace(/[^A-Za-z0-9]/ig, '')
	}
</script>
	<iframe src="" style="display:none;" id="dup"></iframe>
	<form name="frmJoin" action="member_proc_up.jsp" method="post" onsubmit="return chkVal(this);">
	<input type="hidden" name="isDup" value="n" />
	<input type="hidden" name="isDup1" value="n" />
	<input type="hidden" name="isDup2" value="n" />
		<div align="center">
			<table>
				<tr>
					<td id="td1"><span style="color: red;">*</span> 이름</td>
					<td><input type="text" id="name" name="mi_name" maxlength="20" value="<%=loginInfo.getMi_name() %>"  disabled /></td>
				</tr>
				<tr>
					<td id="td1"><span style="color: red;" >*</span> 아이디</td>
					<td><input type="text" name="mi_id" maxlength="20"  value="<%=loginInfo.getMi_id() %>"  disabled />
					<br />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg" style="font-size:13px;">아이디는 변경 불가능 입니다</span></td>
				</tr>
				<tr>
					<td id="td1"><span style="color: red;">*</span> 비밀번호</td>
					<td><input type="password" id="password" name="mi_pw" maxlength="20" value="<%=loginInfo.getMi_pw() %>" /></td>
				</tr>
				<tr>
					<td id="td1"><span style="color: red;">*</span> 닉네임</td>
					<td>
					<input type="text" name="mi_nick" maxlength="20" onkeyup="dupNick(this.value);"  
					value="<%=loginInfo.getMi_nick() %>"  />
					<br />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg1" style="font-size:13px;">닉네임은 2~20자 이내로 입력하세요.</span></td>
				</tr>
				<tr>
					<td id="td1"><span style="color: red;">*</span> 이메일</td>
					<td><input type="text" id="firstmail" name="email1" size="10" onkeyup="dupEmail();" 
					value="<%=loginInfo.getMi_email().substring(0, loginInfo.getMi_email().indexOf("@")) %>" /> @
					 <input type="text" id="lastmail" name="email2" size="10" onkeyup="dupEmail();" 
					 value="<%=loginInfo.getMi_email().substring(loginInfo.getMi_email().indexOf("@") + 1) %>"/>
					<select id="mail" name="mail" size="1" onchange="email_change(this.value)" >
						<option value="">선택</option>
						<option value="naver.com">naver.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="daum.net">daum.net</option>
						<option value="nate.com">nate.com</option>
						<option value="">직접입력</option>
					</select><br />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg2" style="font-size:13px;">이메일을 입력해 주세요.</span></td>
				</tr>
				<tr>
					<td id="td1"><span style="color: red;">*</span> 핸드폰번호</td>
				 	<td><input type="text" id="mi_phone" name="p1" size="4" value="010" maxlength="3" readonly/> - 
					<input type="text" name="p2" size="4" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" style="text-align:center;" maxlength="4" 
					value="<%=loginInfo.getMi_phone().substring(4,8)%>" /> - 
					<input type="text" name="p3" size="4" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" style="text-align:center;" maxlength="4" 
					value="<%=loginInfo.getMi_phone().substring(9)%> " /></td>
				</tr>
				
				<tr>
					<td id="td1">메일/SMS 정보 수신</td>
					<td><input type="radio" id="chk_mail_yes" name="chk_mail" value="yes" checked="checked" />수신 
					<input type="radio" id="chk_mail_no" name="chk_mail" value="no" />거부</td>
				</tr>
			</table>
			<br /><br /><br />
			<div id="button">
				<input type="reset" value="다시 입력" style="font-size:20px;" />&nbsp;&nbsp;
				<input type="submit" value="수정완료" style="font-size:20px;" />
			</div>
		</div>
	</form>
<%@ include file="../_inc/inc_foot.jsp" %>