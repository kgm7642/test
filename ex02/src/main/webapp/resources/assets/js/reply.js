/**
	reply 관리할 모듈(module)
 */

//function create(){
//	return {brand:"Ferrari"};
//}
//const mycar = create();
const mycar = (function create(){
	return {brand:"Ferrari"};
})();
//console.log(mycar.brand);

function factory(f){
	return f();
}

//factory(create);

const replyService = (function(){
	function insert(reply,callback,err){
		console.log('add reply......');
		//callback, err 는 외부에서 전달받을 함수이다.
		//자바스크립트는 함수의 파라미터 개수를 일치시킬 필요가 없기 때문에
		//사용시 callback이나 err와 같은 것은 상황에 따라 작성한다.
		$.ajax(
			{
				type:"POST",
				url:"/reply/regist",
				data:JSON.stringify(reply),//JSON.stringify(JS객체) : JS객체 -> JSON으로 변환
				contentType:"application/json; charset=utf-8",
				success:function(result,status,xhr){
					if(callback){
						console.log("regist result : "+result);
						//DOM 써서 내용 바꾸기
						callback(result);
					}
				},
				error:function(xhr,status,e){
					if(err){
						err(e);
					}
				}
			}		
		)
	}
	
	//data : {boardnum:123, pagenum:3}  ,   callback : DOM으로 리스트를 만들어주는 함수 function(replyCnt,list)
	function selectAll(data,callback,err){
		let boardnum = data.boardnum;//123
		let pagenum = data.pagenum;//3
		$.getJSON(
			"/reply/pages/"+boardnum+"/"+pagenum+".json",//	/reply/pages/123/3.json
			//위의 uri의 json을 정상적으로 읽어왔다면 아래에 있는 함수를 호출해준다. 그 때 매개변수 data에 읽어온 json 내용이 담기게 된다.
			function(data){
				//data : {replyCnt:댓글개수, list:[ReplyDTO,...]}
				if(callback){
					//function(replyCnt,list)
					//getJSON 요청으로 받아온 데이터의 replyCnt, list를 넘겨주면서 호출한다.
					//흐름이 다시 get.jsp의 137번줄로 이동된다.
					callback(data.replyCnt,data.list);
				}
			}
		).fail(
			function(xhr,status,e){
				if(err){
					err(e);
				}
			}
		)
	}
	
	function fmtTime(reply){
		let regdate = reply.regdate;
		let updatedate = reply.updatedate;
		let now = new Date();
		let check = regdate == updatedate;
		
		let dateObj = new Date(check?regdate:updatedate)
		
		//데이트객체.getTime() : 그 시간 정보를 밀리초로 변환
		let gap = now.getTime() - dateObj.getTime();
		
		let str = "";
		if(gap < 1000*60*60*24){
			let hh = dateObj.getHours();
			let mi = dateObj.getMinutes();
			let ss = dateObj.getSeconds();
					
			str = (hh>9?'':'0')+hh+":"+(mi>9?'':'0')+mi+":"+(ss>9?'':'0')+ss;
		}
		else{
			let yy = dateObj.getFullYear();
			let mm = dateObj.getMonth()+1;//(1월 : 0, 2월 : 1, ...)
			let dd = dateObj.getDate();
			
			str = yy+'/'+(mm>9?'':'0')+mm+'/'+(dd>9?'':'0')+dd;
		}
		return (check?'':'(수정됨)')+str;
	}
	// reply/3 
	function drop(replynum, callback, err){
		$.ajax({
			type:"DELETE",
			url:"/reply/"+replynum,
			success:function(result,status,xhr){
				if(callback){
					callback(result);
				}
			},
			error:function(xhr,status,e){
				if(err){
					err(e);
				}
			}
		})
		
	}
	
	function update(reply, callback, err){
		$.ajax({
			type:"PUT",
			url:"/reply/"+reply.replynum,
			data:JSON.stringify(reply),
			contentType:"application/json; charset=utf-8",
			success:function(result,status,xhr){
				if(callback){
					callback(result);
				}
			},
			error:function(xhr,status,e){
				if(err){
					err(e);
				}
			}
		})
	}
	
	
	return {add:insert, getList:selectAll, remove:drop, modify:update, get:"", displayTime:fmtTime};
})();

//replyService.add() --> insert()











