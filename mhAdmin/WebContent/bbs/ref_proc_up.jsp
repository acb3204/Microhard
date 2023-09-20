<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {		// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('로그인 후 다시 시도해 주세요.'"); 
	out.println("location.href='../login_form.jsp';");
	out.println("</script>");
	out.close();
}

request.setCharacterEncoding("utf-8");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int idx = Integer.parseInt(request.getParameter("idx"));
String schtype = request.getParameter("schtype");	// 검색조건
String keyword = request.getParameter("keyword");	// 검색어
String args = "?cpage=" + cpage + "&idx=" + idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {
	args += "&schtype=" + schtype + "&keyword=" + keyword;
}

String rl_title = request.getParameter("rl_title");
String rl_content = request.getParameter("rl_content");
String rl_ip = request.getRemoteAddr();
String rl_isview = "n"; // 예시로 "n"으로 초기화
String oname = ""; // 예시로 빈 문자열로 초기화
String name = ""; // 예시로 빈 문자열로 초기화

try {
	stmt = conn.createStatement();	
	sql = "update t_ref_list set " + 
	"rl_title = '"    + rl_title    + "', " +    "rl_content = '"  + rl_content  + "', " + 
	"rl_ip = '" + rl_ip + "', " + "rl_isview = '"    + rl_isview + "' " +
	" where nl_idx = " + idx;
//	System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('ref_view.jsp" + args + "');");	
	} else {
		out.println("alert('자료실 글 수정에 실패했습니다.\n다시 시도하세요.'"); 
		out.println("history.back();");
	}
	out.println("</script>");
	
} catch (Exception e) {
	out.println("공지사항 수정시 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try {
		stmt.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>




<%@ include file="../_inc/inc_foot.jsp" %>