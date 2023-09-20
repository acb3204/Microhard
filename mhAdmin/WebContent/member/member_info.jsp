<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
h1{
    text-align: center;
}
table{
    text-align: center;
}
th{
    width: 200px;
}
td{
    width: 400px;
}
.cls1{
    font-size: 40px;
    text-align: center;
}
 
</style>
<title>회원정보 수정창</title>
</head>
<body>
	 <div align="center">
    <h1 class="cls1">회원 정보 수정창</h1>
    <form method="post" action="${contextPath}/member/modMember.do?id=${memInfo.id}">
        <table>
            <tr>
                <th>
                    <p align="right">아이디</p>
                </th>
                <td><input type="text" name="id" value="${memInfo.id}" disabled></td>
            </tr>
            
            <tr>
                <th>
                    <p align="right">비밀번호</p>
                </th>
                <td><input type="password" name="pwd" value="${memInfo.pwd}" value="${memInfo.pwd }"></td>
            </tr>
                <tr>
                <th>
                    <p align="right">비밀번호확인</p>
                </th>
                <td><input type="password" name="pwd" value="${memInfo.pwd}" value="${memInfo.pwd }"></td>
            </tr>
            
            <tr>
                <th>
                    <p align="right">이름</p>
                </th>
                <td><input type="text" name="name" value="${memInfo.name}"></td>
            </tr>
            
             <tr>
                <th>
                    <p align="right">닉네임</p>
                </th>
                <td><input type="text" name="name" value="${memInfo.nickname}"></td>
            </tr>
            
            <tr>
                <th>
                    <p align="right">이메일</p>
                </th>
                <td><input type="text" name="email" value="${memInfo.email}"></td>
            </tr>
            
            <tr>
                <th>
                    <p align="right">휴대폰번호</p>
                </th>
                <td><input type="text" name="joinDate" value="${memInfo.joinDate}" disabled></td>
            </tr>
            
            <tr align="center">
                <td></td>
                <td><input type="submit" value="수정완료"></td>
            </tr>
 
            <tr align="center">
            <td></td>
            <td ><input type="reset" value="취소"></td>
            </tr>
        </table>
    
    </form>
 </div>
</body>
</html>
