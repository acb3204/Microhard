<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>

<%



if (!isLogin) {
	out.println("<script>");
	out.println("alert('다시 로그인해 주세요.');");
	out.println("location.href='../login_form.jsp?url=bbs/ref_form.jsp?kind=in';");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");

String rl_title = request.getParameter("rl_title");
String rl_content = request.getParameter("rl_content");
String rl_ip = request.getRemoteAddr();
String rl_isview = "n"; // 예시로 "n"으로 초기화
String oname = ""; // 예시로 빈 문자열로 초기화
String name = ""; // 예시로 빈 문자열로 초기화

	try {
		stmt = conn.createStatement();
		int idx = 1;
		sql = "select max(rl_idx) from t_ref_list";
		rs = stmt.executeQuery(sql);
		
		if (rs.next()) idx = rs.getInt(1) + 1;
			
		sql = "insert into t_ref_list (rl_idx, rl_title, rl_content, rl_ip, rl_isview, rl_oname, rl_name) values (?,?,?,?,?,?,?)";
			
		PreparedStatement pstmt = conn.prepareStatement(sql);
		 System.out.println(sql);
		
			pstmt.setInt(1, idx);			pstmt.setString(2, rl_title);
			pstmt.setString(3, rl_content);	pstmt.setString(4, rl_ip);
			pstmt.setString(5, rl_isview); pstmt.setString(6, oname);
		    pstmt.setString(7, name);
		    
		    int result = stmt.executeUpdate(sql);
	

	} catch (Exception e) {
		out.println("자료실 등록시 문제가 발생했습니다.");
		e.printStackTrace();
	} finally {
		try {
			rs.close();	stmt.close();
		}	 catch (Exception e){
			e.printStackTrace();
		}
	}


%>
<%@ include file="../_inc/inc_foot.jsp" %>