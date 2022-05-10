<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BOARD</title>
<link rel="stylesheet" href="/resources/assets/css/main.css">
<style>
	.mdf{
		height:75px; width:100%; resize:none;
	}
</style>
</head>
<body class="is-preload">
	<div id="main">
		<div class="wrapper">
			<div class="inner">
				<header class="major">
					<h1 class="home">Board</h1>
					<p>게시글 상세보기</p>
				</header>
				<a href="/board/list${cri.listLink}" class="button primary small">목록 보기</a>
				<br>
				<br>
				<div class="col-12">
					<form method="post" action="/board/remove">
						<input type="hidden" value="${cri.pagenum}" name="pagenum">
						<input type="hidden" value="${cri.amount}" name="amount">
						<input type="hidden" value="${cri.keyword}" name="keyword">
						<input type="hidden" value="${cri.type}" name="type">
						<div class="col-12">
							<h4>번호</h4>
							<input name="boardnum" type="text" value="${board.boardnum}" readonly>
						</div>
						<hr>
						<div class="col-12">
							<h4>제목</h4>
							<input name="boardtitle" type="text" value="${board.boardtitle }" readonly>
						</div>
						<hr>
						<div class="col-12">
							<h4>내용</h4>
							<textarea name="boardcontents" rows="10" style="resize:none;" readonly>${board.boardcontents }</textarea>
						</div>
						<hr>
						<div class="col-12">
							<h4>작성자</h4>
							<input name="boardwriter" type="text" value="${board.boardwriter }" readonly>
						</div>
						<hr>
						<div class="col-12">
							<input type="button" value="수정" class="primary" onclick="location.href='/board/modify${cri.listLink}&boardnum=${board.boardnum}'">
							<input type="submit" value="삭제" class="primary">
						</div>
					</form>
					<hr>
					<h3 style="text-align:center;">댓 글</h3>
					<a href="#" class="button primary regist">댓글 등록</a>
					<br>
					<br>
					<!-- style="display:none" -->
					<div class="replyForm row" style="display:none; justify-content: center; ">
						<div style="width:15%;">
							<h4>작성자</h4>
							<input name="replywriter" placeholder="Writer" type="text">						
						</div>
						<div style="width:65%; ">
							<h4>내용</h4>
							<textarea name="replycontents" rows="2" style="resize:none;" placeholder="Contents"></textarea>
						</div>
						<div style="width:10%; margin-left:1%" class="row">
							<h4 style="margin-bottom:1.3rem !important;">&nbsp;</h4>
							<a href="#" style="margin-bottom:0.7rem;" class="button primary small finish">등록</a>
							<a href="#" class="button primary small cancel">취소</a>
						</div>
					</div>
					<!-- 댓글 띄우는 ul -->
					<ul class="alt replies"></ul>
					<!-- 댓글 페이징 처리할 div -->
					<div class="page" style="text-align:center">
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="/resources/assets/js/jquery.min.js"></script>
<script src="/resources/assets/js/jquery.dropotron.min.js"></script>
<script src="/resources/assets/js/browser.min.js"></script>
<script src="/resources/assets/js/breakpoints.min.js"></script>
<script src="/resources/assets/js/util.js"></script>
<script src="/resources/assets/js/main.js"></script>
<script src="/resources/assets/js/reply.js"></script>
<script>
	//document.getElementsByClassName("regist")	[요소1,요소2,...]
	//요소1.addEventListener("click",function(e){
	//	클릭되었을 때 수행할 문장
	//})
	let check = false;
	$(".regist").on("click",function(e){
		e.preventDefault();
		$(".replyForm").show();
		$(this).hide();
	})
	$(".cancel").on("click",function(e){
		e.preventDefault();
		$("[name='replywriter']").val("");
		$("[name='replycontents']").val("");
		$(".replyForm").hide();
		$(".regist").show();
	})
	$(".finish").on("click",function(e){
		let boardnum = "${board.boardnum}";
		let replywriter = $("input[name='replywriter']").val();
		let replycontents = $("textarea[name='replycontents']").val();
		
		replyService.add(
			{boardnum:boardnum,replywriter:replywriter,replycontents:replycontents},
			function(result){
				alert("댓글 등록 완료!");
			},
			function(result){
				alert("댓글 등록 실패!");
			}
		)
		//원래는 DOM 써서 내용 바꾸기
		location.reload();
	})
	
	$(document).ready(function(){
		let boardnum = "${board.boardnum}";
		let replies = $(".replies");
		let pagenum = 1;
		let page = $(".page");
		
		showList(1);
		
		function showList(pagenum){
			//매개변수 page : 현재 띄워주어야 할 댓글의 페이지 번호
			replyService.getList(
				{boardnum : boardnum, pagenum : pagenum || 1},
				function(replyCnt,list){
					if(list == null || list.length == 0){
						replies.html("<li>댓글이 없습니다.</li>");
						return
					}
					//검색해온 list 안의 내용들로 DOM 이용해서 화면에 뿌리기
					/*
						<li style="clear:both">
							<div style="display:inline;float:left;">
								<strong>apple</strong>
								<p>노잼 댓글</p>
							</div>
							<div style="text-align:right">
								<strong>2022-02-25 19:55:55</strong><br>
								<a href="#">수정</a>&nbsp;&nbsp;
								<a href="#">삭제</a>
							</div>
						</li>
					*/
					let str = "";
					for(let i=0, len = list.length ; i<len ; i++){
						str += '<li style="clear:both;">';
						str += '<div style="display:inline;float:left;width:80%;">';
						//만들어지는 모양 : <strong class="replywriter3">apple</strong>
						str += '<strong class="replywriter'+list[i].replynum+'">'+list[i].replywriter+'</strong>';
						//str += `<strong>${list[i].replywriter}</strong>`;
						str += '<p class="reply'+ list[i].replynum +'">'+list[i].replycontents+'</p></div>'
						//str += `<p class="${list[i].replynum}">${list[i].replycontents}</p></div>`;
						str += '<div style="text-align:right">';
						str += '<strong>'+replyService.displayTime(list[i])+'</strong><br>';
						str += '<a href="'+list[i].replynum+'" class="modify">수정</a>'
						str += '<a href="'+list[i].replynum+'" class="mfinish" style="display:none;">수정완료</a>&nbsp;&nbsp;'
						str += '<a href="'+list[i].replynum+'" class="remove">삭제</a></div></li>';
					}
					
					replies.html(str);
					//페이징 처리하는 함수 호출
					showReplyPage(replyCnt);
					$(".remove").on("click",function(e){
						e.preventDefault();
						let replynum = $(this).attr("href");
						replyService.remove(
								replynum,
								function(result){
									if(result == "success"){
										alert(replynum+"번 댓글 삭제 완료!");	
									}
								},
								function(e){
									alert("에러발생!\n"+e);
								}
						);
						//DOM으로 댓글 리스트 수정
						location.reload();
					})
					$(".modify").on("click",function(e){
						e.preventDefault();
						if(!check){
							let replynum = $(this).attr("href");
							let replytag = $(".reply"+replynum);//댓글 내용이 써져있는 p 태그	<p><textarea>노잼댓글</textarea></p>
							
							//<p class="reply3"><textarea class="3 mdf">노잼댓글</textarea></p>
							replytag.html('<textarea class="'+replynum+' mdf">'+replytag.text()+'</textarea>')
							$(this).hide();
							
							$(this).next().show();
							
							check = true;
						}
						else{
							alert("이미 수정중인 댓글이 있습니다!");
						}
					})
					$(".mfinish").on("click",function(e){
						e.preventDefault();
						
						let replynum = $(this).attr("href");
						let boardnum = "${board.boardnum}"
						let replywriter = $(".replywriter"+replynum).text();
						let replycontents = $("."+replynum).val();
						
						replyService.modify(
							{replynum:replynum, replycontents:replycontents, boardnum:boardnum, replywriter:replywriter},
							function(result){
								if(result == "success"){
									alert(replynum+"번 댓글 수정 완료!")
								}
							},
							function(e){
								alert(e);
							}
						)
						location.reload();
					})
					
				}
			)
		}
		function showReplyPage(replyCnt){
			//pagenum : 7
			//endPage : 10
			let endPage = Math.ceil(pagenum/5.0)*5;
			//startPage : 6
			let startPage = endPage-4;
			
			//true
			let prev = startPage!=1;
			let next = false;
			
			if(endPage*5>=replyCnt){
				endPage = Math.ceil(replyCnt/5);
			}
			
			if(endPage*5 < replyCnt){
				next = true;
			}
			
			let str = "";
			
			if(matchMedia("screen and (max-width:918px)").matches){
				//핸드폰 환경의 DOM 작성				< 13 >
				if(pagenum > 1){
					str += "<a class='changePage' href='"+ (pagenum-1) +"'><code>&lt;</code></a>";
				}
				str += "<code>"+pagenum+"</code>"
				if(pagenum != endPage){
					str += "<a class='changePage' href='"+ (pagenum+1) +"'><code>&gt;</code></a>";
				}
			}else{
				//PC 환경의 DOM 작성
				//<<	>>
				let start = pagenum != 1;
				//128/5 -> 25.6 -> 26.0
				let last = pagenum != Math.ceil(replyCnt/5)
				
				if(start){
					str += "<a class='changePage' href='1'><code>&lt;&lt;</code></a>";
				}
				if(prev){
					str += "<a class='changePage' href='"+ (startPage-1) +"'><code>&lt;</code></a>";
				}
				for(let i=startPage;i<=endPage;i++){
					if(i == pagenum){
						str += "<code>"+i+"</code>";
					}
					else{
						str += "<a class='changePage' href='"+i+"'><code>"+i+"</code></a>"
					}
				}
				if(next){
					str += "<a class='changePage' href='"+ (endPage+1) +"'><code>&gt;</code></a>";
				}
				if(last){
					str += "<a class='changePage' href='"+ Math.ceil(replyCnt/5) +"'><code>&gt;&gt;</code></a>";
				}
			}
			page.html(str);
			
			$(".changePage").on("click",function(e){
				e.preventDefault();
				let target = $(this).attr("href");
				pagenum = parseInt(target);
				showList(pagenum);
			})
		}
	})

</script>
</html>









