<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="z.x.dao.MemberDao" %>
<%@page import="z.x.dto.MemberDto" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
 /*   
  * 팝업 임시 버튼 스타일 
  * . 으로 시작하는건 태그에 class 명에 적용됨. html 내에 있는 전체 class 에 적용. ex) class="modal-bg"
  * # 으로 시작하는건 태그에 id 명에 적용됨. 원칙적으로 id 는 html 에 하나만 선언해야 함. 중복 작성할때는 태그에 태그를 검색해서 적용할 것. html내에 하나만 적용됨. css selector 검색해볼것.
  */
/* 팝업 스타일 */
.modal-bg {display:none;width:100%;height:100%;position:fixed;top:0;left:0;right:0;background: rgba(0, 0, 0, 0.6);z-index:999;}
.modal-wrap {display:none;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:300px;height:300px;background:#fff;z-index:1000;background-color: darkslategray;}
</style>
<script>
// 회원조회
function memberSearch(mi_idx) {
	// 전달받은 회원일련번호
	if (mi_idx == null || mi_idx == undefined) {
		alert("회원번호가 입력되지 않았습니다.");
		return;
	}
	
	// ajax 객체 생성
	var http = new XMLHttpRequest();
	// 서블릿 호출 주소
	// 서블릿 호출을 하기 위해서는 프로젝트/WebContent/WEB-INF/web.xml 에   servlet, servlet-mapping 을 선언해 줘야 한다.
	// servlet-mapping 의 url-pattern 이 호출할 수 있는 주소가 된다.
	// servlet-class 에 선언된 클래스가 호출된다. 
    var url = '/TestWeb/memberSearch';
    var params = 'mi_idx='+mi_idx;
    http.open('POST', url, true);  // POST 방식 전송, form data 가 넘어감 ==> 서블릿 doPost 로 전달됨
    //http.open('GET', url, true);  // GET 방식 전송(주소줄에 파라미터가 붙어서 넘어감. http://localhost/memberSearch?mi_idx=1), form data 가 넘어감 ==> 서블릿 doGet 로 전달됨
    http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	
    // ajax 상태 변화시
    http.onreadystatechange = function() {
    	// 4는 잘 모르겠고,  200: http 호출 성공 코드임
        if(http.readyState == 4 && http.status == 200) {
        	// 응답데이터(문자열)를 json객체로 변환(json 객체로 변환된다음은 resData.mi_name 과 같이 . 찍은 후 필드 접근 가능)
            resData = JSON.parse(http.responseText);
            console.log(resData);
            
            // id 로 선언된 태그 mbr_result(모달안에 있음) 내부의 html 을 지워버림 
            document.getElementById("mbr_result").innerHTML = '';
            
            if (resData.result == "true") {
                // id 로 선언된 태그 mbr_result(모달안에 있음) 내부의 html 에 데이터 출력
                // 여기에 추가
                document.getElementById("mbr_result").insertAdjacentHTML("beforeend", "<div>"+resData.mi_id+"<br>"+resData.mi_name+"</div>");
            } else {
            	document.getElementById("mbr_result").insertAdjacentHTML("beforeend", "<div>"+resData.msg+"</div>");
            }
            // 모달 오픈
            modalOpen();
        }
    }
    // ajax 호출
    http.send(params);
}

// 초기화 함수
function init(){
	// 모달닫기/배경화면 클릭시 모달닫기 클릭이벤트
	document.querySelector('.modal-bg, .modal-close').addEventListener('click', function(e) {
		modalClose();
	});
}

// 모달열기
function modalOpen(){
	var modal = document.getElementById('modal');
	var modalBg = document.querySelector('.modal-bg');
	
	modal.style.display = "block"; // 노출 설정
    modalBg.style.display = "block";
}
// 모달닫기
function modalClose(){
	var modal = document.getElementById('modal');
	var modalBg = document.querySelector('.modal-bg');
	modal.style.display = "none";	// 숨김 설정
	modalBg.style.display = "none";
}


/*
 * HTML(JSP)는 위에서부터 순서대로 읽는다.
 * document.getElementById('modal'); 라인보다 선언되어 있는 id="modal" 이 아래에 있으면, 찾지를 못한다. 
 * 그렇기 때문에, body에 onload 이벤트로 실행할 초기화 함수 같은걸 호출하게끔 해준다.
 * body onload 는 body 가 다 읽어진 후 실행 할 함수를 적으면 된다.
 * body onload 같은거 해주기 불편할 때는 script 를 문서 최하단에 작성하면 된다..
 */
</script>
</head>
<body onload="init()">
    <div id="wrap">

<!-- 메뉴 -->
<%@ include file="/_inc/inc_head.jsp" %>

        <section class="content">
            <div class="container">

<%
	int cpage = 1;
	int bsize = 6;
	
	if (request.getParameter("cpage") != null) {
		cpage = Integer.parseInt(request.getParameter("cpage"));   // cpage 값이 있으면 int형으로 형변환 하여 받음(보안상의 이유와 산술연산);
	}
	String schtype = request.getParameter("schtype");
	String keyword = request.getParameter("keyword");
	if (schtype == null) schtype = "";
	if (keyword == null) keyword = "";
	
	String schargs = "&schtype=" + schtype + "&keyword=" + keyword;   //   검색조건이 있을 경우 링크의 url에 붙일 쿼리스트링 완성
%>
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
<tr height="30">
<tr><td colspan="2">
   <form name="frmSch">   <!-- action과 method속성은 각각 기본값인 현재 파일과 get을 사용할 것임 -->
   <fieldset>
      <legend>회원 검색</legend>
      <select name="schtype">
         <option value="name" <% if (schtype.equals("name")) { %>selected="selected"<% } %>>이름</option>
         <option value="nick" <% if (schtype.equals("nick")) { %>selected="selected"<% } %>>닉네임</option>
         <option value="nn" <% if (schtype.equals("nn")) { %>selected="selected"<% } %>>이름+닉네임</option>
      </select>
      <input type="text" name="keyword" value="<%=keyword %>" />
      <input type="submit" value="검색" />
      &nbsp;&nbsp;&nbsp;&nbsp;
   </fieldset>
   </form>
</td></tr>
</table>
<h2>회원 목록</h2>
<table width="700" border="0" cellpadding="0" cellspacing="0" id="list">
	<th width="10%">번호</th><th width="15%">회원상태</th><th width="*%">닉네임</th><th width="15%">이름</th><th width="25%">회원아이디</th><th width="25%">회원가입일</th></tr>
<%
	MemberDao memberDao = new MemberDao();
	Map<String, Object> map = memberDao.getMemberList(cpage, schtype, keyword);
	int rcnt = (int) map.get("rcnt"); //전체건수
	int pcnt = (int) map.get("pcnt"); //페이지수
	if (rcnt > 0) {
		List<MemberDto> list = (List<MemberDto>) map.get("memberList");
		for(MemberDto dto : list) {
%>
	<tr height="30" align="center">
		<td><%=dto.getMi_idx() %></td>
		<td><%=dto.getMi_status() %></td>
		<td><%=dto.getMi_nick() %></td>
		<td><%=dto.getMi_name() %></td>
		<td><%=dto.getMi_id() %><button onclick="memberSearch(<%=dto.getMi_idx()%>)">회원정보</button></td>
		<td><%=dto.getMi_date() %></td>
	</tr>
<%
		}
	} else {
%>
	<tr height='30'><td colspan='6' align='center'>검색결과가 없습니다.</td></tr>
<%
	}
%>
</table>
<%
if (rcnt >0) {
	String link = "index.jsp?cpage=";
    if (cpage == 1) {
        out.println("[처음]&nbsp;&nbsp;&nbsp;[이전]&nbsp;&nbsp;");
    } else {
        out.println("<a href='" + link + "1" + schargs + "'>[처음]</a>&nbsp;&nbsp;&nbsp;");
        out.println("<a href='" + link + (cpage-1) + schargs + "'>[이전]</a>&nbsp;&nbsp;");
    }

    int spage = (cpage -1) / bsize * bsize +1;   // 블록 시작 페이지 번호
   
    for (int i = 1, j = spage; i <= bsize && j <= pcnt; i++, j++) {   // i : 블록에서 보여줄 페이지의 개수만큼 루프를 돌릴 조건으로 사용되는 변수 j : 실제 출력할 페이지 번호로 전체 페이지 개수(마지막 페이지 번호)를 넘지 않게 할 변수
		if (j == cpage) {
			out.println("&nbsp;<strong>" + j + "</strong>&nbsp;");
        } else {
           out.println("&nbsp;<a href='" + link + j + schargs + "'>" + j + "</a>&nbsp;");
        }
    }

    if (cpage == pcnt) {
        out.println("&nbsp;&nbsp;[다음]&nbsp;&nbsp;&nbsp;[마지막]");
    } else {
        out.println("<a href='" + link + (cpage+1) + schargs + "'>[다음]</a>&nbsp;&nbsp;");
        out.println("<a href='" + link + pcnt + schargs + "'>[마지막]</a>&nbsp;&nbsp;&nbsp;");
    }
}
%>

            
            </div>
        </section>
    </div>

    <!-- modal 영역 -->
    <div class="modal-bg" onClick="javascript:modalClose();"></div>
    <div id="modal" class="modal-wrap">
        <button class="modal-close" style="float:right" onClick="javascript:modalClose();">닫기</button>
        <div id="mbr_result" style="padding:30px">
        </div>
    </div>
    <!-- //modal 영역 -->
</body>
</html>