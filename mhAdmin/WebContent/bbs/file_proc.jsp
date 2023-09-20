<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%
String uploadPath = request.getRealPath("/upload");

int maxSize = 1024 * 1024 * 10; // 업로드 최대 용량을 지정할 값(10MB)으로 byte 단위
String name="", title = ""; 	// 사용자가 입력한 데이터를 저장한 변수 
String file1 = "",	file2 = "";	// 업로드한 파일의 이름을 저장할 변수
String old1 = "", old2 = "";	// 업로드한 파일의 원래 이름을 저장할 변수

try {
	MultipartRequest multi = new MultipartRequest(
			request, uploadPath, maxSize, "utf-8", new DefaultFileRenamePolicy());
	
	name = multi.getParameter("name");
	title = multi.getParameter("title");
	
	Enumeration files = multi.getFileNames();
	
	String f1 = (String)files.nextElement();
	file1 = multi.getFilesystemName(f1);
	old1 = multi.getOriginalFileName(f1);
	
	String f2 = (String)files.nextElement();
	file2 = multi.getFilesystemName(f2);
	old2 = multi.getOriginalFileName(f2);
} catch(Exception e) { 
	e.printStackTrace();
}

%>
<form name="frm" action="upload_cos_result.jsp" method="post">
<input type="hidden" name="name" value="<%=name %>" />
<input type="hidden" name="title" value="<%=title %>" />
<input type="hidden" name="file1" value="<%=file1 %>" />
<input type="hidden" name="file2" value="<%=file2 %>" />
<input type="hidden" name="old1" value="<%=old1 %>" />
<input type="hidden" name="old2" value="<%=old2 %>" />
</form>
