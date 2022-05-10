package com.koreait.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyDTO;

public interface ReplyMapper {
	int insert(ReplyDTO reply);
	int getTotal(Long boardnum);
	
	//MyBatis는 두개 이상의 데이터를 파라미터로 넘길 때 객체나 Map, List 등 혹은 @Param을 이용한다.
	//정해진 파라미터는 MyBatis에서 #{param명}으로 사용 가능하다.
	List<ReplyDTO> getList(@Param("cri") Criteria cri,@Param("boardnum") Long boardnum);
	int delete(Long replynum);
	int update(ReplyDTO reply);
}
