<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");

String mi_name = request.getParameter("mi_name");
String mi_id = request.getParameter("mi_id");
String mi_pw = request.getParameter("mi_pw");
String mi_nick = request.getParameter("mi_nick");
String p2 = request.getParameter("p2");
String p3 = request.getParameter("p3");
String email1 = request.getParameter("email1");
String email2 = request.getParameter("email2");
String mi_phone = "010-" + p2 + "-" + p3;
String mi_email = email1 + "@" + email2;

try {
   stmt = conn.createStatement();
   int idx = 1;
   sql = "select max(ql_idx) + 1 from t_qna_list";
   rs = stmt.executeQuery(sql);
   if (rs.next()) idx = rs.getInt(1);   
   
   sql = "insert into t_member_info (mi_id, mi_pw, mi_name, mi_nick, mi_phone, mi_email) values (?, ?, ?, ?, ?, ?)";
   PreparedStatement pstmt = conn.prepareStatement(sql);
   pstmt.setString(1, mi_id);
   pstmt.setString(2, mi_pw);
   pstmt.setString(3, mi_name);
   pstmt.setString(4, mi_nick);
   pstmt.setString(5, mi_phone);
   pstmt.setString(6, mi_email);
   // System.out.println(sql);
   // stmt.executeQuery(sql);
   
   int result = pstmt.executeUpdate();
   if (result == 1 ) {
      response.sendRedirect("join_succes.jsp");
   } else {
      out.println("<script>");
      out.println("alert('회원가입에 실패했습니다.\n다시 시도하세요');");
      out.println("history.back();");
      out.println("</script>");   
      out.close();
   }   
} catch (Exception e) {
   out.println("회원가입에 시 문제가 발생했습니다.");
   e.printStackTrace();
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>