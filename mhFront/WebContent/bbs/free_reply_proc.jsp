<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int fl_idx = Integer.parseInt(request.getParameter("fl_idx"));
String schtype = request.getParameter("schtype");		
String keyword = request.getParameter("keyword");
String args = "?cpage=" + cpage + "&idx=" + fl_idx;
if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리 스트링으로 연결해줌 
}

int fr_idx = 0;
String fr_content = request.getParameter("fr_content");
String mi_id = loginInfo.getMi_id(), fr_ip = request.getRemoteAddr(), mi_nick = loginInfo.getMi_nick(); 
if (!kind.equals("in")) 								// 댓글 등록이 아닐 경우 
	fr_idx = Integer.parseInt(request.getParameter("fr_idx"));
	
try {
	stmt = conn.createStatement();
	if (kind.equals("in")) {				// 댓글 등록일 경우 
		sql = "update t_free_list set fl_replay = fl_replay + 1 where fl_idx = " + fl_idx;
		stmt.executeUpdate(sql);			// 게시글의 댓글 수 증가 쿼리 실행 
		
		sql = "insert into t_free_reply (fl_idx, mi_id, mi_nick, fr_content, fr_ip) values " + 
	 "(" + fl_idx + ", '" + mi_id + "', '"  + mi_nick + "', '" + fr_content + "', '" + fr_ip + "') ";
		
	
	} else if (kind.equals("del")) { 		// 댓글 삭제일 경우 
		sql = "update t_free_list set fl_replay = fl_replay - 1 where fl_idx = " + fl_idx;
		stmt.executeUpdate(sql);			// 게시글의 댓글 수 증가 쿼리 실행 
		
		sql = "update t_free_reply set fr_isview = 'n' where mi_id = '" + loginInfo.getMi_id() + "' and fr_idx = " + fr_idx; 
	 	
	} else if (kind.equals("g") || kind.equals("b")) { 			//댓글 좋아요 및 싫어요일 경우 
		sql = "update t_free_reply set  fr_" + (kind.equals("g") ? "good" : "bad") + " = fr_" + (kind.equals("g") ? "good" : "bad") +
		" + 1 where fr_idx = " + fr_idx;
		//System.out.println(sql);
		stmt.executeUpdate(sql);			// 댓글의 좋아요/ 싫어요 증가 쿼리 실행  

		sql = "insert into t_free_reply_gnb (mi_id, fr_idx, frg_gnb) values ('" + 
		mi_id + "', " + fr_idx + ", '" + kind + "')"; 
		//System.out.println(sql);
 
	} else {		
		out.println("<script>");
		out.println("history.back();");
		out.println("</script>");
	}

	int result = stmt.executeUpdate(sql);
	
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('free_view.jsp" + args + "');");
	} else {
		out.println("alert('댓글 등록에 실패했습니다.\\n다시 시도하세요.');");
		out.println("history.back();");
	}
	out.println("</script>");
	
	
} catch (Exception e) {
	out.println("댓글 관련 문제가 발생했습니다.");
	e.printStackTrace();
} finally {
	try { stmt.close(); } 
	catch (Exception e){ e.printStackTrace(); }
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>