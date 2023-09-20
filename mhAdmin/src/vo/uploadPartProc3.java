package vo;

import java.io.*;
import java.sql.*;
import javax.servlet.*;	
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@MultipartConfig(
		fileSizeThreshold = 0,
		location = "E:/lhj/web/mhAdmin/WebContent/upload"
	)

@WebServlet("/uploadPartProc3")
public class uploadPartProc3 extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public uploadPartProc3() {
        super();  
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		Part part = request.getPart("rl_name");
		
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		String contentDisposition = part.getHeader("content-disposition");
		// System.out.println(contentDisposition);
				
		  String uploadName = getUploadFileName(contentDisposition);
	      if (part.getSize() > 0) {
	          part.write(uploadName);
	      } else {
	    	  uploadName = ""; // 파일을 첨부하지 않은 경우, 빈 파일 이름으로 설정
	 		}
	      String parameter = request.getParameter("parameter");
	      if (parameter != null && !parameter.isEmpty()) {
	          int value = Integer.parseInt(parameter);
	          // 정수로 변환된 값을 사용하는 코드 작성
	      }
		
		
		
		// DB연결 부분
		String driver1 = "com.mysql.cj.jdbc.Driver";
		String dbURL1 = "jdbc:mysql://localhost:3306/hard?useUnicode=true&characterEncoding=UTF8&verifyServerCertificate=false&useSSL=false&serverTimezone=UTC";

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = null;
		// db 연결
		try {		
			Class.forName(driver1);
			conn = DriverManager.getConnection(dbURL1, "root", "1234");
		} catch(Exception e) {
			out.println("DB연결에 문제가 발생했습니다.");
			e.printStackTrace();
		}

		
		//업로드 // 수정
		String kind = request.getParameter("kind");
	//	System.out.println(kind);
		String rl_title = request.getParameter("rl_title");
		String rl_content = request.getParameter("rl_content");
		String rl_ip = request.getRemoteAddr();
		String rl_isview = request.getParameter("rl_isview");
		String rl_oname = part.getName(); 	// 
		String rl_name = uploadName;	// 
		
		
		int cpage = 0, idx = 0;
		if (kind.equals("up")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
			idx = Integer.parseInt(request.getParameter("idx"));
		}
		
		//System.out.println(idx);
		String schtype = request.getParameter("schtype");		
		String keyword = request.getParameter("keyword");
		String args = "?cpage=" + cpage + "&idx=" + idx;
		if (schtype != null && !schtype.equals("") && keyword != null && !keyword.equals("")) {		
			args += "&schtype=" + schtype + "&keyword=" + keyword;
		}
		
		try {
			stmt = conn.createStatement();
			if (kind.equals("in")) {
			
	         sql = "select max(rl_idx) from t_ref_list";
	         rs = stmt.executeQuery(sql);
	         //System.out.println(sql);
	         
	         if (rs.next()) idx = rs.getInt(1) + 1;
	         
	         sql = "insert into t_ref_list (rl_idx, rl_title, rl_content, rl_ip, rl_isview, rl_oname, rl_name) values (?,?,?,?,?,?,?)";
	            
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         //System.out.println(sql);
	         
	         pstmt.setInt(1, idx);         pstmt.setString(2, rl_title);
	         pstmt.setString(3, rl_content);   pstmt.setString(4, rl_ip);
	         pstmt.setString(5, rl_isview); pstmt.setString(6, rl_oname);
	          pstmt.setString(7, rl_name);
	          int result = pstmt.executeUpdate();
	             if (result == 1) {
	               // response.sendRedirect(rl_name);
	               // response.sendRedirect(rl_oname);
	                response.sendRedirect("/mhAdmin/bbs/ref_view.jsp?cpage=1&idx=" + idx);      //가져갈 값이 한글이 있을경우 자바스크립트 사용
	   
	            } else {
	               out.println("<script>");
	               out.println("alert('자료실  글 등록에 실패했습니다. \n 다시 시도하세요.');");
	               out.println("history.back();");
	               out.println("</script>");
	               out.close();
	            }
	          
	         } else {          
	            stmt = conn.createStatement();
	            //System.out.println(sql);
	            
	            sql = "update t_ref_list set " + 
	            "rl_title = '" + rl_title +  "' , rl_content = '" + rl_content + "' , rl_isview = '" + rl_isview + "' " + 
	            ", rl_name = '" + rl_name + "', rl_oname = '" + rl_oname + "' " +
	            " where rl_idx = " + idx;
	            
	            int result = stmt.executeUpdate(sql);
	            System.out.println(sql);
	            
	            out.println("<script>");
	            if (result == 1) {
	               out.println("location.replace('/mhAdmin/bbs/ref_view.jsp" + args + "');");
	               
	            } else {
	               out.println("alert('자료글 수정에 실패했습니다 \n 다시 시도하세요.');");
	               out.println("history.back();");
	            }
	            out.println("</script>");
	            
	          }     
			
			
		}  catch (Exception e) {
			out.println("자료실 프록 등록시 문제가 발생했습니다.");
			e.printStackTrace();
		} finally {
			try {
				rs.close();	stmt.close();
			} catch (Exception e){
				e.printStackTrace();
			}
		}
	}
		
	
	private String getUploadFileName(String cd) {
		String uploadName = null;
		String[] arrContent = cd.split(";");
		
		int fIdx = arrContent[2].indexOf("\"");
		int sIdx = arrContent[2].lastIndexOf("\"");
		
		uploadName = arrContent[2].substring(fIdx + 1,sIdx);
		return uploadName;
		
	} 
	
}
