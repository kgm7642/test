package com.koreait.service;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyDTO;
import com.koreait.domain.ReplyPageDTO;

public interface ReplyService {
	boolean regist(ReplyDTO reply);
	ReplyPageDTO getList(Criteria cri, Long boardnum);
	boolean remove(Long replynum);
	boolean modify(ReplyDTO reply);
}
