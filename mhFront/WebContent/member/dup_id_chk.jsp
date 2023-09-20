<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.* " %>
<%
String driver = "com.mysql.cj.jdbc.Driver";
String dbURL = "jdbc:mysql://localhost:3306/hard?useUnicode=true&characterEncoding=UTF8&verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";

Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String sql = null;

try {      // db 연결
   Class.forName(driver);
   conn = DriverManager.getConnection(dbURL, "root", "1234");
} catch(Exception e) {
   out.println("DB연결에 문제가 발생했습니다.");
   e.printStackTrace();
}

/*
1. 사용자가 입력한 아이디를 받아옴
2. 받아온 아이디와 동일한 아이디가 회원테이블에 있는지 여부를 검사하기 위해 쿼리 생성 후 실행 
3. 중복여부를 현 파일을 포함하고 있는 join_form.jsp에서 표시해줌 
*/
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
String mi_id = request.getParameter("mi_id");
String mi_nick = request.getParameter("mi_nick");
String mi_email = request.getParameter("mi_email");

try {
   stmt = conn.createStatement();
   sql = "select 1 from t_member_info where mi_";
   if (kind.equals("id")) {   
      sql += "id = '" + mi_id + "'";
   } else if (kind.equals("nick")) {
      sql += "nick = '" + mi_nick + "'";
   } else {
      sql += "email = '" + mi_email + "'";
   }
   rs = stmt.executeQuery(sql);
%>
<script>
   var msg = parent.document.getElementById("msg");
   var isDup = parent.frmJoin.isDup;
<%
if (kind.equals("id")) {
   if (rs.next()){
%>
   msg.innerHTML = "<span style='color:red; font-weight:bold; font-size:13px;'>" + "이미 사용중인 아이디 입니다 </span>";
    isDup.value = "n";
<%   } else {   %>
   msg.innerHTML = "<span style='color:blue; font-weight:bold; font-size:13px;'>" + "사용할 수 있는 아이디 입니다  </span>";
    isDup.value = "y";
<%
   }
} else if (kind.equals("nick")) {
%>
   var msg1 = parent.document.getElementById("msg1");
   var isDup1 = parent.frmJoin.isDup1;
<%
   if (rs.next()){
%>
   msg1.innerHTML = "<span style='color:red; font-weight:bold; font-size:13px;'>" + "이미 사용중인 닉네임 입니다 </span>";
   isDup1.value = "n";
<%   } else {   %>
   msg1.innerHTML = "<span style='color:blue; font-weight:bold; font-size:13px;'>" + "사용할 수 있는 닉네임 입니다  </span>";
   isDup1.value = "y";
<%
   }
} else {
%>
   var msg2 = parent.document.getElementById("msg2");
   var isDup2 = parent.frmJoin.isDup2;
<%
   if (rs.next()){
%>
   msg2.innerHTML = "<span style='color:red; font-weight:bold; font-size:13px;'>" + "이미 사용중인 이메일 입니다 </span>";
   isDup2.value = "n";
<%   } else {   %>
   msg2.innerHTML = "<span style='color:blue; font-weight:bold; font-size:13px;'>" + "사용할 수 있는 이메일 입니다  </span>";
   isDup2.value = "y";
<%
   }
}
%>
</script>
<% 
} catch (Exception e) {
   out.println("아이디, 닉네임, 이메일 중복 검사에서 문제가 발생했습니다.");
   e.printStackTrace();
} finally {
   try { rs.close(); stmt.close(); } 
   catch (Exception e){ e.printStackTrace(); }
}

%>
<%@ include file="../_inc/inc_foot.jsp" %>