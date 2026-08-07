--WndEquipLotteryData.lua
--@brief	WndEquipLottery的数据模块
--@date		2021/05/29
--@author	hyc
--@note		装备抽奖

WndEquipLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEquipLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_topCellLua = nil
	self.m_lType = nil					--类型
	self.m_batch = {}					--批次
	self.m_reTime = nil					--下一次刷新时间
	self.m_lotteryNum = nil				--抽奖次数
	self.m_freeTime = nil				--折扣时间
	self.m_usePinkDiamond = true		--是否使用礼钻
	self.m_tag = nil
	self.m_consumeType = nil
	self.m_lotteryShowTag = nil
	self.m_allBatch = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEquipLottery:_unInit()
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
	self.m_allBatch = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEquipLottery:createElement()
	if WndEquipLottery.m_root ~= nil then
		WndEquipLottery.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndEquipLottery")
	assert(element, "WndEquipLottery create element failed!")
	self:_init()
	return element
end

--@brief	请求返回的抽奖信息
function WndEquipLottery:setLotteryData(lType,batch,lotteryNum,reTime,freeTime)
	-- body
	-- WZLog("请求宠物返回的抽奖信息",lType,batch,lotteryNum,reTime,freeTime,ser)
	--reTime 折扣时间(第二个按钮) freetime免费一抽时间（第一个按钮）
	self.m_lType = lType
	self.m_batch = batch
	self.m_lotteryNum = lotteryNum
	self.m_reTime = reTime
	self.m_freeTime = freeTime 

	--add 新手引导
	local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
	WZLog("WndEquipLottery:setLotteryData",isEndTeach41, step41)
	if isEndTeach41 ~= true and step41 < 3 then
		if self.m_freeTime <= 0 then
		    TeachGroup1:startGroup({41,3,WndEquipLottery.m_root})
		else
			TeachGroup1:setTeachFinish(41,-1)
            TeachGroup1:removeTeach()
		end
	end
	--end
	self:onUpdateUi()
	self:initRightContent()
	self:upRedDot()
end

--@brief	抽奖成功
function WndEquipLottery:successLottery(lType,itemId,num,coinId,coinNum,natural,data)
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
	WZLog("高品质宠物",Serialize(highQuality))
	WndLotteryShow:showLottery(lType,itemId,num,highQuality,coinId,coinNum,self.m_batch,natural, data)
end

--@brief	领取自选礼包成功
function WndEquipLottery:getLotteryReward(lType,itemId,num)
	-- body
	if lType ~= 1 or itemId == nil and num == nil then return end
	if itemId and next(itemId) then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(1)
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

function WndEquipLottery:getShareReward(lType,itemId,num)
	-- body
	if lType ~= 1 or itemId == nil or num == nil then return end
	if itemId and next(itemId) then
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

--把秒 转化成XX时XX分XX秒
function WndEquipLottery:formatTime(time)
	WZLog("WndEquipLottery:formatTime",time)
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	local rtTime = string.format("%s:%s:%s",hour,minute,second)
    WZLog("转化后的时间",rtTime)
    return rtTime
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
