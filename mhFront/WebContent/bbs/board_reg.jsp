<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
if (!isLogin) {	// 로그인이 되어 있지 않다면
	out.println("<script>");
	out.println("alert('잘못된 접근입니다.');");
	out.println("location.href='../index.jsp';");
	out.println("</script>");
	out.close();
}
request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));
String br_table = request.getParameter("br_table");
String br_select = request.getParameter("br_select");
String br_title = request.getParameter("br_title");
String br_boradpms = request.getParameter("br_boradpms");
String br_replyuse = request.getParameter("br_replyuse");
String br_replypms = request.getParameter("br_replypms");

String boradpms = "", replay = "";

try {
	stmt = conn.createStatement();
	sql = "UPDATE t_board_request SET br_table='" + br_table + "', br_isanswer='b' WHERE br_idx=" + idx + ";";
	// System.out.println(sql);
	int result = stmt.executeUpdate(sql);
	if(!(result == 1)) {
		out.println("<script>alert('테이블 이름 등록에 실패했습니다.');");
		out.println("history.back();</script>");
		out.close();
	}
	sql = "INSERT INTO t_board_total_list (bt_id, bt_name, bt_select, bt_boardpms, bt_replyuse, bt_replypms) VALUES ('" + br_table + "', '" + br_title + "', '" + br_select + "', '" + br_boradpms + "', '" + br_replyuse + "', '" + br_replypms + "')";
	// System.out.println(sql);
	result = stmt.executeUpdate(sql);
	if (result == 1) {
		if (br_boradpms.equals("b")) { // 비회원만 사용가능한 게시판
			sql = "CREATE TABLE t_board_" + br_table + "_list(bl_idx INT PRIMARY KEY, bl_ismem CHAR(1) DEFAULT 'y', bl_writer VARCHAR(20) NOT NULL, bl_pw VARCHAR(20), bl_title VARCHAR(10) NOT NULL, bl_content TEXT NOT NULL, bl_replay INT DEFAULT 0, bl_read INT DEFAULT 0, bl_ip VARCHAR(15) NOT NULL, bl_isview CHAR(1) DEFAULT 'y', bl_date DATETIME DEFAULT NOW() );";
		} else { // 회원만 사용가능한 게시판
			sql = "CREATE TABLE t_board_" + br_table + "_list(bl_idx INT PRIMARY KEY, mi_nick VARCHAR(20) NOT NULL, bl_title VARCHAR(100) NOT NULL, bl_content TEXT NOT NULL, bl_replay INT DEFAULT 0, bl_read INT DEFAULT 0, bl_ip VARCHAR(15) NOT NULL, bl_isview CHAR(1) DEFAULT 'y', bl_date DATETIME DEFAULT NOW(), CONSTRAINT fk_board_" + br_table + "_list_mi_nick FOREIGN KEY (mi_nick) REFERENCES t_member_info(mi_nick) ON UPDATE CASCADE);";
		}
		// System.out.println(sql);
		stmt.executeUpdate(sql);

		if (br_replyuse.equals("a") && br_replypms.equals("a")) { // 회원만 댓글 사용가능
			sql = "CREATE TABLE t_board_" + br_table + "_reply(br_idx INT PRIMARY KEY AUTO_INCREMENT, bl_idx INT NOT NULL, mi_nick VARCHAR(20) NOT NULL, br_content VARCHAR(200) NOT NULL, br_good INT DEFAULT 0, br_bad INT DEFAULT 0, br_ip VARCHAR(15) NOT NULL, br_isview CHAR(1) DEFAULT 'y', br_date DATETIME DEFAULT NOW(), CONSTRAINT fk_board_" + br_table + "_reply_bl_idx FOREIGN KEY (bl_idx) REFERENCES t_board_" + br_table + "_list(bl_idx), CONSTRAINT fk_board_" + br_table + "_reply_mi_nick FOREIGN KEY (mi_nick) REFERENCES t_member_info(mi_nick) ON UPDATE CASCADE);";
		} else if (br_replyuse.equals("a") && br_replypms.equals("b")) { // 비회원 댓글 사용가능
			sql = "CREATE TABLE t_board_" + br_table + "_reply(br_idx INT PRIMARY KEY AUTO_INCREMENT, bl_idx INT NOT NULL, br_ismem CHAR(1) DEFAULT 'y', br_writer VARCHAR(20) NOT NULL, br_pw VARCHAR(20), br_content VARCHAR(200) NOT NULL, br_good INT DEFAULT 0, br_bad INT DEFAULT 0, br_ip VARCHAR(15) NOT NULL, br_isview CHAR(1) DEFAULT 'y', br_date DATETIME DEFAULT NOW(), CONSTRAINT fk_board_" + br_table + "_reply_bl_idx FOREIGN KEY (bl_idx) REFERENCES t_board_" + br_table + "_list(bl_idx));";
		} else { // 댓글기능 사용안함
			response.sendRedirect("board_rq_alist.jsp");
		}
		// System.out.println(sql);
		stmt.executeUpdate(sql);
		
		sql = "CREATE TABLE t_board_" + br_table + "_reply_gnb(brg_idx INT AUTO_INCREMENT UNIQUE, mi_id VARCHAR(20) NOT NULL, br_idx INT NOT NULL, brg_gnb CHAR(1) DEFAULT 'g', brg_date DATETIME DEFAULT NOW(), CONSTRAINT pk_board_" + br_table + "_reply_gnb PRIMARY KEY (mi_id, br_idx), CONSTRAINT fk_board_" + br_table + "_reply_gnb_mi_id FOREIGN KEY (mi_id) REFERENCES t_member_info(mi_id), CONSTRAINT fk_board_" + br_table + "_reply_gnb_br_idx FOREIGN KEY (br_idx) REFERENCES t_board_" + br_table + "_reply(br_idx));";
		// System.out.println(sql);
		stmt.executeUpdate(sql);
		
		response.sendRedirect("board_rq_alist.jsp");
	} else {
		out.println("<script>alert('테이블 정보 등록에 실패했습니다.');");
		out.println("history.back();</script>");
		out.close();
	}
	
} catch(Exception e) {
	out.println("테이블 등록시 문제가 발생했습니다.");
	e.printStackTrace();
}

%>
<%@ include file="../_inc/inc_foot.jsp" %>