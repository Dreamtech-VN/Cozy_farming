--CellAuctionHouseData.lua
--@brief	CellAuctionHouse的数据模块
--@date		2020/08/03
--@author	yrd
--@note		拍卖行活动

CellAuctionHouse = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellAuctionHouse:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_currencyId = 163024 			--竞拍币id
	self.m_markupRate = {0.05,0.25,1} 	--加价比率
	self.m_activityId = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_status = nil
	self.m_auctions = nil
	self.m_auction = nil
	self.m_initPrice = nil
	self.m_price = nil
	self.m_name = nil
	self.m_totalTime = nil
	self.m_time = nil
	self.m_weekName = nil
	self.m_bidInfo = nil
	self.m_nBtnCDStatus = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellAuctionHouse:_unInit()
	self.m_root = nil
	self.m_currencyId = nil
	self.m_markupRate = nil
	self.m_activityId = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_status = nil
	self.m_auctions = nil
	self.m_auction = nil
	self.m_initPrice = nil
	self.m_price = nil
	self.m_name = nil
	self.m_totalTime = nil
	self.m_time = nil
	self.m_weekName = nil
	self.m_bidInfo = nil
	self.m_nBtnCDStatus = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellAuctionHouse:createElement()
	if CellAuctionHouse.m_root ~= nil then
		WindowManager:removeWindow(CellAuctionHouse.m_root, CellAuctionHouse, true)
	end
	local element = WZUISystem:getInstance():createElement("CellAuctionHouse")
	assert(element, "CellAuctionHouse create element failed!")
	self:_init()
	return element
end

function CellAuctionHouse:setMessage(activityId, startTime, endTime, status, auctions, auction, initPrice, price, name, totalTime, time, weekName, bidInfo, auctionStartTime)
	self.m_activityId = activityId
	self.m_startTime = startTime
	self.m_endTime = endTime
	self.m_status = status
	self.m_auctions = auctions
	self.m_auction = auction
	self.m_initPrice = initPrice
	self.m_price = price
	self.m_name = name
	self.m_totalTime = totalTime
	self.m_time = time
	self.m_weekName = weekName
	self.m_bidInfo = bidInfo
	self.m_auctionStartTime = auctionStartTime
end

--出价协议返回
function CellAuctionHouse:auctionBidOk(bType, result)
    local auctionScore = string.sub(CacheCenter:getGameParam()["auctionScore"],2,-2)
    local tAuctionScore = SplitStringWithSeparator(auctionScore, ",")
	local nAaddScore = tonumber(tAuctionScore[bType+1])

	if result == 1 then --成功
		if bType == 0 then --出价
			MsgBoxManager:showTipBox(string.format(LocalStrings.AUCTION_HOUSE_TEXT30,nAaddScore))
		else --加价
			MsgBoxManager:showTipBox(string.format(LocalStrings.AUCTION_HOUSE_TEXT25,nAaddScore))
		end
	else --失败
		if bType == 0 then --出价
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT31)
		else --加价
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT26)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
