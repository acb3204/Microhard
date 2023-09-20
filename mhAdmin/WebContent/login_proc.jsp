<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="_inc/inc_head.jsp" %>
<%
	if (isLogin) {
	out.println("<script>");
	out.println("alert('잘못된 경로로 들어오셨습니다.'); history.back();");
	out.println("</script>");	
	out.close();
}
/* 로그인 처리
1. 사용자가 입력한 아이디와 암호 받아오기
2. 받아온 데이터를 이용하여 쿼리 생성
3. 쿼리를 실행시켜 로그인 여부를 검사
3-1. 로그인 성공 시 받아온 회원 데이터를 MemberInfo형 인스턴스에 저장한 후 세션에 저장
 - 저장후 이동(이동할 곳이 있으면 해당 url로 없으면 index로 이동)
3-2. 로그인 실패시 로그인 폼으로 이동시킨 후
"아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요." 메시지를 보여줌
 - 이동할 url이 있으면 그 값도 로그인 폼으로 이동시 같이 보내줌
*/

request.setCharacterEncoding("utf-8");
String ai_id = getRequest(request.getParameter("ai_id")).toLowerCase();
String ai_pw = getRequest(request.getParameter("ai_pw"));
String url = request.getParameter("url");

if (ai_id == null || ai_id.equals("") || ai_pw == null || ai_pw.equals("")) {
	out.println("<script>");
	out.println("alert('아이디와 비밀번호를 입력하세요.'); history.back();");
	out.println("</script>");
	out.close();
}
try {
	stmt = conn.createStatement();
	sql = "select * from t_admin_info where ai_use = 'y' and ai_id = '" + ai_id + "' and ai_pw ='" + ai_pw + "' ";
//	System.out.println(sql);
	rs = stmt.executeQuery(sql);
	

	if (rs.next()) {						// 로그인 성공 시
		AdminInfo ai = new AdminInfo();	// 로그인 할 회원의 정보들을 저장할 인스턴스 생성
		ai.setAi_id(ai_id);
		ai.setAi_pw(ai_pw);
		ai.setAi_name(rs.getString("ai_name"));
		ai.setAi_use(rs.getString("ai_use"));
		ai.setAi_date(rs.getString("ai_date"));
		session.setAttribute("loginInfo", ai);	// 로그인한 회원 정보를 담은 AdminInfo형 인스턴스 mi를 세션에 "loginInfo"라는 이름의 속성으로 저장
		
		response.sendRedirect(url);
		
	} else {								// 로그인 실패 시
		out.println("<script>");
		out.println("alert('아이디와 비밀번호를 확인 후 다시 로그인하세요.'); history.back();");
		out.println("</script>");		
	}

} catch (Exception e) {
	out.println("로그인 처리시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();
		stmt.close();
	} catch (Exception e) {
		e.printStackTrace();	
	}
}
%>
<%@ include file="_inc/inc_foot.jsp" %>
