--WndFootLotteryData.lua
--@brief	WndFootLottery的数据模块
--@date		2021/04/25
--@author	hyc
--@note		足迹抽奖

WndFootLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_topCellLua = nil
	self.m_lType = nil					--类型
	self.m_batch = {}					--批次
	self.m_reTime = nil					--下一次刷新时间
	self.m_lotteryNum = nil				--抽奖次数
	self.m_freeTime = nil				--折扣时间
	self.m_usePinkDiamond = false		--是否使用礼钻
	self.m_tag = nil
	self.m_consumeType = nil
	self.m_lotteryShowTag = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootLottery:_unInit()
	self.m_root = nil
	self.m_topCellLua = nil
	self.m_lType = nil					--类型
	self.m_batch = nil					--批次
	self.m_reTime = nil					--下一次刷新时间
	self.m_lotteryNum = nil				--抽奖次数
	self.m_freeTime = nil				--折扣时间
	self.m_usePinkDiamond = nil
	self.m_tag = nil
	self.m_consumeType = nil
	self.m_lotteryShowTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootLottery:createElement()
	if WndFootLottery.m_root ~= nil then
		WindowManager:removeWindow(WndFootLottery.m_root, WndFootLottery, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFootLottery")
	assert(element, "WndFootLottery create element failed!")
	self:_init()
	return element
end

--@brief	请求返回的抽奖信息
function WndFootLottery:setLotteryData(lType,batch,lotteryNum,reTime,freeTime)
	-- body
	-- WZLog("请求坐骑返回的抽奖信息",lType,batch,lotteryNum,reTime,freeTime,ser)
	self.m_lType = lType
	self.m_batch = batch
	self.m_lotteryNum = lotteryNum
	self.m_reTime = reTime
	self.m_freeTime = freeTime 

	self:onUpdateUi()
	self:initRightContent()
	self:upRedDot()
end

--@brief	抽奖成功
function WndFootLottery:successLottery(lType,itemId,num,coinId,coinNum,natural,data)
	if itemId == nil or num == nil then return end
	self.m_lotteryShowTag = nil
	local highQuality = {}
	local tData = GDatatab_total_draw
	for i = 1,#itemId do 
		for k,v in pairs(tData) do
			if v.item_id[1][1] == itemId[i] and v.type == lType then
				WZLog("抽奖成功",v.item_id[1][1],itemId[i])
				if v.quality >= 6 then
					table.insert(highQuality,itemId[i])
					break 
				end
			end
		end
	end
	-- ntype,itemId,num,highCount,tokenId,tokenNum,m_batch
	WZLog("高品质足迹",Serialize(highQuality))
	WndLotteryShow:showLottery(lType,itemId,num,highQuality,coinId,coinNum,{},natural, data)
end

--@brief	领取自选礼包成功
function WndFootLottery:getLotteryReward(lType,itemId,num)
	-- body
	if lType ~= 5 or itemId == nil and num == nil then return end
	if itemId and next(itemId) then
		g_bIsShowWndDressUp = true
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(5)
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

function WndFootLottery:getShareReward(lType,itemId,num)
	-- body
	if lType ~= 5 or itemId == nil or num == nil then return end
	if itemId and next(itemId) then
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

--把秒 转化成XX时XX分XX秒
function WndFootLottery:formatTime(time)
	WZLog("WndEquipmentLottery:formatTime")
	local day = math.floor(time/3600/24)
	local hour = math.floor((time-day*3600*24)/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	if day == 0 then
		if hour < 1 then
			return LocalStrings.LOTTERY_TEXT3
		else 		
			local rtTime = string.format(LocalStrings.LOTTERY_TEXT5,hour)
		    return rtTime
		end
	else
		local rtTime = string.format(LocalStrings.LOTTERY_TEXT4,day,hour)
	    return rtTime
	end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
