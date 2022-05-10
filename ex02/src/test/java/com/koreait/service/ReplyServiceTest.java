package com.koreait.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyDTO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class ReplyServiceTest {
	@Setter(onMethod_ = @Autowired)
	private ReplyService service;
	
//	@Test
//	public void serviceTest() {
//		assertNotNull(service);
//		log.info(service);
//	}
	
//	@Test
//	public void registTest() {
//		ReplyDTO reply = new ReplyDTO();
//		reply.setBoardnum(10L);
//		reply.setReplywriter("apple");
//		reply.setReplycontents("노잼댓글");
//		
//		service.regist(reply);
//		log.info(reply.getReplynum());
//	}
	
	@Test
	public void getListTest() {
		Criteria cri = new Criteria();
		cri.setPagenum(1);
		cri.setAmount(10);
		log.info(service.getList(cri, 10L));
	}
}






















