package com.koreait.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyDTO;
import com.koreait.domain.ReplyPageDTO;
import com.koreait.service.ReplyService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RequestMapping("/reply/*")
@Log4j
@RestController// : JSON 형태로 객체 데이터를 반환하기 위한 Controller  
public class ReplyController {
	@Setter(onMethod_ = @Autowired)
	private ReplyService service;
	
	//ResponseEntity : 서버의 상태코드, 응답 메세지, 데이터 등을 담을 수 있는 타입
	//consumes : 이 메소드가 호출될 때 소비할 데이터의 타입(넘겨지는 body의 데이터 타입)
	//@RequestBody : 넘겨지는 body의 데이터 타입을 해석해서 해당 파라미터에 채워넣기
	@PostMapping(value = "/regist", consumes = "application/json")
	public ResponseEntity<String> regist(@RequestBody ReplyDTO reply) {
		boolean check = service.regist(reply);
		return check ? new ResponseEntity<String>("success",HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//produces : 이 메소드가 호출된 결과로 생산해낼 데이터의 타입(돌려주는 body의 데이터 타입)
	@GetMapping(value = "/pages/{boardnum}/{pagenum}",
			produces = {
					MediaType.APPLICATION_JSON_UTF8_VALUE,
					MediaType.APPLICATION_XML_VALUE
			}
	)
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("boardnum") Long boardnum,@PathVariable("pagenum") int pagenum) {
		Criteria cri = new Criteria(pagenum, 5);
		return new ResponseEntity<ReplyPageDTO>(service.getList(cri, boardnum),HttpStatus.OK);
	}
	
	//DeleteMapping : REST방식 이용시 삭제 요청을 보낼 때 사용하는 매핑
	@DeleteMapping(value = "/{replynum}", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> remove(@PathVariable("replynum") Long replynum) {
		return service.remove(replynum)?
				new ResponseEntity<>("success",HttpStatus.OK):
				new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	//PUT
	//	모든 데이터들을 다 전달해야 함, 자원의 전체 수정, 자원 내의 모든 필드를 전달해야 함, 전달되지 않은 필드는 모두 초기화 처리
	//PATCH
	//	자원의 일부 수정, 수정할 필드만 전송
	@RequestMapping(
			method = {RequestMethod.PUT,RequestMethod.PATCH}, value = "/{replynum}",
			consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE
	)
	public ResponseEntity<String> modify(@RequestBody ReplyDTO reply) {
		log.info("@@@@@@@@@@modify : "+reply);
		if(service.modify(reply)) {
			return new ResponseEntity<>("success",HttpStatus.OK); 
		}
		else {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}























