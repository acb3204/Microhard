<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int bl_idx = Integer.parseInt(request.getParameter("bl_idx"));
String rpms = request.getParameter("rpms");
String id = request.getParameter("id");
String br_ip = request.getRemoteAddr(); 

String schtype = request.getParameter("schtype");
String keyword = request.getParameter("keyword");
String args = "?id=" + id + "&cpage=" + cpage + "&idx=" + bl_idx;

String br_writer = "", br_pw = "", br_ismem = "y";



if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
	args += "&schtype=" + schtype + "&keyword=" + keyword;
	// 링크에 검색 관련 값들을 쿼리 스트링으로 연결해줌 
}

int br_idx = 0;
String br_content = request.getParameter("br_content");
if (!kind.equals("in")) 								// 댓글 등록이 아닐 경우 
	br_idx = Integer.parseInt(request.getParameter("br_idx"));
	
// System.out.println(kind);

try {
	stmt = conn.createStatement();
	Statement stmt1 = conn.createStatement();
	if (kind.equals("in")) {				// 댓글 등록일 경우 
		sql = "update t_board_" + id + "_list set bl_replay = bl_replay + 1 where bl_idx = " + bl_idx;
		stmt.executeUpdate(sql);			// 게시글의 댓글 수 증가 쿼리 실행 
		
		sql = "insert into t_board_" + id + "_reply (bl_idx, mi_nick, br_content, br_ip) values " + 
		"(" + bl_idx + ", '" + br_writer + "', '" + br_content + "', '" + br_ip + "') ";
		if ((rpms.equals("b")) && !(isLogin)) {
			sql = "INSERT INTO t_board_" + id + "_reply (bl_idx, br_ismem, br_writer, br_pw, br_content, br_ip) VALUES ('" + bl_idx + "', '" + br_ismem + "', '" + br_writer + "', '" + br_pw + "', '" + br_content + "', '" + br_ip + "')";
		} else if (rpms.equals("b")) {
			sql = "INSERT INTO t_board_" + id + "_reply (bl_idx, br_ismem, br_writer, br_content, br_ip) VALUES ('" + bl_idx + "', '" + br_ismem + "', '" + br_writer + "', '" + br_content + "', '" + br_ip + "');";
		}
	
	} else if (kind.equals("del")) { 		// 댓글 삭제일 경우 
	
			sql = "update t_board_" + id + "_list set bl_replay = bl_replay - 1 where bl_idx = " + bl_idx;
			stmt.executeUpdate(sql);
			
			sql = "update t_board_" + id + "_reply set br_isview = 'n' where  br_idx = " + br_idx;
		
		
	} else if (kind.equals("g") || kind.equals("b")) { 			//댓글 좋아요 및 싫어요일 경우 
		sql = "update t_board_" + id + "_reply set  br_" + (kind.equals("g") ? "good" : "bad") + " = br_" + (kind.equals("g") ? "good" : "bad") +
		" + 1 where br_idx = " + br_idx;
		// System.out.println(sql);
		stmt.executeUpdate(sql);			// 댓글의 좋아요/ 싫어요 증가 쿼리 실행  

		sql = "insert into t_board_" + id + "_reply_gnb (mi_id, br_idx, brg_gnb) values ('" + br_writer + "', " + br_idx + ", '" + kind + "')"; 
		//System.out.println(sql);
 
	} else {		
		out.println("<script>");
		out.println("history.back();");
		out.println("</script>");
	}
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	
	out.println("<script>");
	if (result == 1) {
		out.println("location.replace('board_view.jsp" + args + "');");
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