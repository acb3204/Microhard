<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="mail.SMTPAuthenticatior"%>
<%@ page import="javax.mail.Authenticator"%>
<%@ page import="java.util.Properties"%>
<% 
if (isLogin) {	// 이미 로그인이 되어 있다면
	out.println("<script>");
	out.println("alert('잘못된 경로로 들어오셨습니다.'); history.back();");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");
String mi_name = getRequest(request.getParameter("mi_name")).toLowerCase();
String mail1 = request.getParameter("mail1").toLowerCase(); 
String mail2 = request.getParameter("mail2");

if (mi_name == null || mi_name.equals("") || mail1 == null || mail1.equals("") || mail2 == null || mail2.equals("")) {
	out.println("<script>");
	out.println("alert('이름과 이메일을 입력하세요.'); history.back();");
	out.println("</script>");
	out.close();
}

String mi_email = mail1 + "@" + mail2;

try {
	stmt = conn.createStatement();
	sql = "SELECT 1 FROM t_member_info WHERE mi_name = '" + mi_name + "' AND mi_email = '" + mi_email + "' ";
	// System.out.println(sql);
	
	rs = stmt.executeQuery(sql);
	
	if (rs.next()) {
		String id = "";
		ResultSet rs1 = null;
		try {
			sql = "SELECT mi_id FROM t_member_info WHERE mi_email = '" + mi_email + "'";
			System.out.println(sql);
			rs1 = stmt.executeQuery(sql);
			if (rs1.next()){
				id = rs1.getString("mi_id");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				rs1.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		Properties p = new Properties(); // 정보를 담을 객체

		p.put("mail.smtp.host","smtp.naver.com"); // 네이버 SMTP

		p.put("mail.smtp.port", "465");
		p.put("mail.smtp.starttls.enable", "true");
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.debug", "true");
		p.put("mail.smtp.socketFactory.port", "465");
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		p.put("mail.smtp.socketFactory.fallback", "false");
		// SMTP 서버에 접속하기 위한 정보들

		try{
		    Authenticator auth = new SMTPAuthenticatior();
		    Session ses = Session.getInstance(p, auth);
		    
		    ses.setDebug(true);
		    
		    MimeMessage msg = new MimeMessage(ses); // 메일의 내용을 담을 객체
		    msg.setSubject("아이디 찾기 결과입니다."); // 제목
		    
		    msg.setFrom(new InternetAddress("h-ju10@naver.com")); // 보내는 사람 SMTPauthenticatior.java 에 작성한 이메일하고 일치해야함
		    
		    Address toAddr = new InternetAddress(mi_email);
		    msg.addRecipient(Message.RecipientType.TO, toAddr); // 받는 사람
		    
		    msg.setContent("아이디는 " + id + "입니다.", "text/html;charset=UTF-8"); // 내용과 인코딩
		    
		    Transport.send(msg); // 전송
		} catch(Exception e){
		    e.printStackTrace();
		    out.println("<script>alert('Send Mail Failed..');history.back();</script>");
		    // 오류 발생시 뒤로 돌아가도록
		    return;
		}

		out.println("<script>alert('등록된 메일로 아이디를 전송했습니다.!!');location.href='../login_form.jsp';</script>");
		// 성공 시
	} else {
		out.println("<script>alert('이름과 이메일을 확인 해주세요.'); history.back();</script>");
		out.close();
	}
} catch(Exception e) {
	out.println("아이디 찾기시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		rs.close();		stmt.close();
	} catch(Exception e) {
		e.printStackTrace();
	}
}
%>

<%@ include file="../_inc/inc_foot.jsp" %>