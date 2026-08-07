--WndLuckyGiftData.lua
--@brief	WndLuckyGift的数据模块
--@date		2017/01/09
--@author	peiting_mao
--@note		幸运礼盒

WndLuckyGift = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLuckyGift:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_CardList = nil				--系统配置的礼盒奖励表
	self.m_FreeTimes = nil 				--剩余的免费抽奖次数
	self.m_TurnedTimes = nil   			--当天已翻牌次数
	self.m_CurTurnCost = nil 			--当前翻牌需要消耗的钻石数
	self.m_CardId = nil					--翻牌时卡牌对应的系统奖励配置id
	self.m_RecordCardId = nil 			--记录已翻过的卡牌的奖励配置ID
	self.m_TurnBombState = nil 			--判断是否抽到炸弹 1是 0否
	self.index = nil					--卡牌栏位ID
	self.tag = nil 						--记录点击翻牌的卡牌位置
	self.cardPos = {}					--记录卡牌的原始位置
	self.time = 1						--爆炸特效播放时间
	self.result = nil 					--翻牌结果（1翻牌成功，2钻石不足）
	self.flag = nil 					    --系统卡牌版本
	self.resetState = nil 				--是否重置（1重置，0不重置）
	self.itemNum = nil 					--记录已翻牌的物品数量
	self.ratio = nil					--消耗倍率
	self.count = nil 					--翻牌得到的物品数量
	--self.ratioIndex = nil 				--记录翻牌前的概率卡位置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLuckyGift:_unInit()
	self.m_root = nil
	self.m_CardList = nil				
	self.m_FreeTimes = nil 				
	self.m_TurnedTimes = nil   			
	self.m_CurTurnCost = nil 			
	self.m_CardId = nil					
	self.m_TurnBombState = nil 			
	self.index = nil	
	self.tag = nil
	self.cardPos = nil
	self.time = nil
	self.flag = nil
	self.resetState = nil
	self.itemNum = nil 					
	self.ratio = nil					
	self.count = nil
	--self.ratioIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLuckyGift:createElement()
	local element = WZUISystem:getInstance():createElement("WndLuckyGift")
	assert(element, "WndLuckyGift create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获得初次打开礼盒的数据
-- function WndLuckyGift:getSysCardsList( cardIdList,freeTimes,flag )
-- 	self.m_CardList = cardIdList
-- 	self.m_FreeTimes = freeTimes
-- 	self.flag = flag
-- 	self:_FirstDraw()
-- end

--@brief	获得当天福利翻牌记录列表
function WndLuckyGift:getPlayerCardsRecord(index,cardId,todayTurnedTimes,curTurnCost,freeTimes,version,count,ratio)
	self.index = index
--	WZLog("WndLuckyGift:self.index",Serialize(cardId))
	self.m_RecordCardId = cardId
	self.m_TurnedTimes = todayTurnedTimes
	self.m_CurTurnCost = curTurnCost
	self.m_FreeTimes = freeTimes
	self.flag = version
	self.m_TurnedTimes = self.m_TurnedTimes + 1
	self.itemNum = count
	self.ratio = ratio
	WZLog("WndLuckyGift:ratio",ratio/10)
	self:_IsFirstDraw()
end

--@brief 	获得翻牌结果
function WndLuckyGift:getTurnCardOk(restFreeTimes,todayTurnedTimes,curTurnCost,turnBombState,cardId,result,resetState,count,ratio)
	if self.m_FreeTimes == 1 and restFreeTimes == 0 then
		WndWelfare:removeRedDot(190)
	end
	WZLog("--WndLuckyGift:cardId--",cardId)
	self.m_FreeTimes = restFreeTimes
	self.m_TurnedTimes = todayTurnedTimes
	self.m_CurTurnCost = curTurnCost
	self.m_TurnBombState = turnBombState
	self.m_CardId = cardId
	self.result = result
	self.resetState = resetState
	self.m_TurnedTimes = self.m_TurnedTimes + 1
	self.count = count
	self.ratio = ratio
	--WZLog("--WndLuckyGift:result--",self.result,self.m_CurTurnCost, self.resetState, self.index[1])
	
	local num = 0
	if self.resetState == 0 then --不重置
		self:_starDraw()
	elseif self.resetState == 1 then --重置
		WZLog("--self.resetState--",self.resetState)
		ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord( )
	end
end

--@brief 	充值回调
function WndLuckyGift:clickSureMoney(  )
	PassportSdkManager:gotoPaymentPage()
end

-------------------------------------私有方法模块End----------------------------------------
