<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<% 
if (isLogin) {	// 이미 로그인이 되어 있다면
	out.println("<script>");
	out.println("alert('잘못된 경로로 들어오셨습니다.'); history.back();");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");
String mi_email = "", mail = "";
%>

<body>
<script>
function email_change(value) { // 체크박스에서 이메일 선택시 값변경
	if(value == 0) {
		document.getElementById("mail2").value = "";
		// document.getElementById("mail2").readonly = false;
	} else {
		document.getElementById("mail2").value = value;
		// document.getElementById("mail2").readonly = true;
	}
}

function email_check() { // 이메일 인증
	if( !emailValCheck() )
		return false;
}

function emailValCheck() { // 이메일 유효성 검사
	var emailPattern= /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	var email = document.getElementById("mail1").value + "@" + document.getElementById("mail2").value;
	if(!check(emailPattern, email, "유효하지 않은 이메일 주소입니다.")) {
		return false;
	}
    return true;
}

function check(pattern, taget, message) { // 이메일 유효성 검사
	if(pattern.test(taget)) {
    	return true;
    }
    alert(message);
    return false;
}
</script>
<form name="frmLogin" action="find_pw_proc.jsp" method="post">
	<div style="background:black; margin:20px -0.5% 0px -20px; text-align:center; height:400px; border: 1px solid; font-size: 150%;  box-sizing: border-box;">
		<h2>&nbsp;&nbsp;&nbsp;비밀번호 찾기</h2>
		이름: &nbsp;&nbsp;&nbsp;<input type="text" name="mi_name" placeholder="이름 입력" maxlength="20" style="height:30px;" text-align="center" font-weight="bold;"  /><br />
		<br />
		아이디: <input type="text" name="mi_id" placeholder="아이디 입력" style="height:30px;" text-align="center" font-weight="bold;" /><br />
		<br />
		이메일: <input type="text" id="mail1" name="mail1" placeholder="이메일 입력" style="height:30px;" text-align="center" font-weight="bold;"/> @ 
		<input type="text" id="mail2" name="mail2" style="height:30px;" text-align="center" font-weight="bold;" />
		<select id="email" onchange="email_change(this.value)" style="height:35px;" text-align="center" font-weight="bold;">
			<option value="0">직접입력</option>
			<option value="naver.com">naver.com</option>
			<option value="hanmail.net">hanmail.net</option>
			<option value="nate.com">nate.com</option>
			<option value="gmail.com">gmail.com</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;<br /><br />
		<input type="submit" value="비밀번호 찾기" style="height:30px; font-size:20px;" />
	</div>
</form> <!-- 
<form name="frmFindID" action="find_id_proc.jsp" method="post">
이름:<input type="text" name="mi_name" placeholder="이름 입력" maxlength="20" size="10"/><br />
이메일:<input type="text" id="mail1" name="mail1" placeholder="이메일 입력" size="10" />@
<input type="text" id="mail2" name="mail2" size="10" />
<select id="email" onchange="email_change(this.value)" >
	<option value="0">직접입력</option>
	<option value="naver.com">naver.com</option>
	<option value="hanmail.net">hanmail.net</option>
	<option value="nate.com">nate.com</option>
	<option value="gmail.com">gmail.com</option>
</select>
<br />
<input type="submit" value="아이디 찾기"/>
</form> -->
</body>

<%@ include file="../_inc/inc_foot.jsp" %>