package z.x.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import z.x.common.MbConstants;
import z.x.dto.MemberDto;

public class MemberDao {
	
	
	public Map<String, Object> getMemberList(int cpage, String schtype, String keyword){
		Map<String, Object> resultMap = new HashMap<>();
		List<MemberDto> memberList = new ArrayList<>();
		
		int psize = 10, pcnt = 0, rcnt = 0;
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			String where = " where 1 = 1 ";
			
			if (keyword != null && !"".equals(keyword)) {
				if (schtype != null && schtype.equalsIgnoreCase("nn")) {   // 검색조건이 '이름 + 닉네임'일 경우
				      where += " and (mi_name like '%" + keyword + "%' " + " or mi_nick like '%" + keyword + "%') ";   
				   } else {               // 검색조건이 '이름'이거나 '닉네임'일경우
				      where += " and mi_" + schtype + " like '%" + keyword + "%' ";
				   }
			}
			
			// db 연결
			Class.forName(MbConstants.DB_DRIVER);
			conn = DriverManager.getConnection(MbConstants.DB_URL, "root", "1234");
			String sql = "select count(*) from t_member_info " + where;
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			if (rs.next()) rcnt = rs.getInt(1);   // count() 함수를 사용하므로 ResultSet 안의 데이터 유무는 검사할 필요가 없음
		    pcnt = rcnt / psize;
		    if (rcnt % psize > 0) pcnt++;   // 전체 페이지 수
		   
		    resultMap.put("rcnt", rcnt);
		    resultMap.put("pcnt", pcnt);
		    
		    if (pcnt > 0) {
			    int start = (cpage - 1) * psize;
			    sql = "select mi_idx, mi_id, mi_name, mi_nick, if (date(mi_date) = curdate(), time(mi_date), replace(mid(mi_date, 3, 8), '-', '.')) midate, mi_status " + 
			    " from t_member_info " + where + " order by mi_idx desc limit " + start +", " + psize;
			   
			    System.out.println(sql);
			    rs = stmt.executeQuery(sql);
			    
			    while(rs.next()) {
			    	MemberDto m = new MemberDto();
			    	m.setMi_idx(rs.getInt("mi_idx"));
			    	m.setMi_id(rs.getString("mi_id"));
			    	m.setMi_name(rs.getString("mi_name"));
			    	m.setMi_nick(rs.getString("mi_nick"));
			    	m.setMi_date(rs.getString("midate"));
			    	m.setMi_status(rs.getString("mi_status"));
			    	
			    	memberList.add(m);
			    }
		    }
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// DB 작업 종료(무조건 추가!!!)
	        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
	        if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
	        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
	    }
		
		resultMap.put("memberList", memberList);
		
		return resultMap;
			   
			   
		
	}
}
