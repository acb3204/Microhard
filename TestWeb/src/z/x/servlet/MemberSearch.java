package z.x.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

public class MemberSearch extends HttpServlet {

	private static final long serialVersionUID = 1L; 

	@Override
	public void init(ServletConfig config) throws ServletException {
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		// doPost 호출
		doPost(req, res);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		res.setContentType("application/json;charset=UTF-8");
		res.setCharacterEncoding("UTF-8");

		PrintWriter out = res.getWriter();
		
		// json 형태로 리턴하기 위한 json객체 생성
		JSONObject obj = new JSONObject();
		
		String mi_idx = req.getParameter("mi_idx");
		String mi_phone = req.getParameter("mi_phone");
		
		System.out.println("입력받은 mi_idx:: " + mi_idx);
		
		
		if (mi_idx == null || "".equals(mi_idx)) {
			obj.put("result", "false");
			obj.put("msg", "회원 일련번호가 입력되지 않았습니다.");
		} else {
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			
			try {
				String driver = "com.mysql.cj.jdbc.Driver";
				String dbURL = "jdbc:mysql://localhost:3306/hard?useUnicode=true&characterEncoding=UTF8&verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";
			
				// db 연결
				Class.forName(driver);
				conn = DriverManager.getConnection(dbURL, "root", "1234");
				String sql = "SELECT mi_idx, mi_id, mi_name, mi_nick, mi_phone, mi_phone, mi_email, mi_status, mi_date FROM t_member_info where mi_idx = " + mi_idx;
				stmt = conn.createStatement();
				stmt.executeQuery(sql);
				
				rs = stmt.getResultSet();
				if (rs.next()) {
					// 여기에 추가
					
					String mi_status = rs.getString("mi_status");
					String mi_nick = rs.getString("mi_nick");
					String mi_name = rs.getString("mi_name");
					String mi_id = rs.getString("mi_id");
					String mi_pw = rs.getString("mi_pw");
					String mi_email = rs.getString("mi_email");
					String mi_date = rs.getString("mi_date");
					
					//...
					obj.put("result", "true");
					obj.put("mi_idx", mi_idx);
					obj.put("mi_status", mi_status);
					obj.put("mi_nick", mi_nick);
					obj.put("mi_phone", mi_phone);
					obj.put("mi_name", mi_name);
					obj.put("mi_id", mi_id);
					obj.put("mi_pw", mi_pw);
					obj.put("mi_email", mi_email);
					obj.put("mi_date", mi_date);
				} else {
					obj.put("result", "false");
					obj.put("msg", "회원정보가 없습니다.");
				}
			} catch(Exception e) {
				out.println("DB연결에 문제가 발생했습니다.");
				e.printStackTrace();
			} finally {
				// DB 작업 종료(무조건 추가!!!)
		        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
		        if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
		        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		    }
		}
		
		
//		res.setContentType("application/json");
		out.print(obj.toJSONString()); 
		
//		PrintWriter out = rsp.getWriter();
//		out.print("<h2>서블릿 초기 추출 변수</h2>");
//		out.print("<h3>ID : aaa</h3>");
//		out.print("<h3>PASSWORD : bbb </h3>");
//		out.close();
	}
}
