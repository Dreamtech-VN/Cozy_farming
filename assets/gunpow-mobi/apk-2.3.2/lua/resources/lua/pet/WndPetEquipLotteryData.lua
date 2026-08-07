--WndPetEquipLotteryData.lua
--@brief	WndPetEquipLottery的数据模块
--@date		2022/05/18
--@author	yrd
--@note		宠物装备召唤

WndPetEquipLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetEquipLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_topCellLua = nil
	self.m_usePinkDiamond = false			--是否使用礼钻
	self.m_allBatch = nil 				--最大批次
	self.m_curBatch = nil 				--当前批次
	self.m_lotteryShowTag = nil
	self.m_tag = nil

	self.m_lType = nil
	self.m_batch = nil
	self.m_lotteryNum = nil
	self.m_reTime = nil
	self.m_freeTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetEquipLottery:_unInit()
	self.m_root = nil
	self.m_topCellLua = nil
	self.m_usePinkDiamond = nil
	self.m_allBatch = nil
	self.m_curBatch = nil
	self.m_lotteryShowTag = nil
	self.m_tag = nil

	self.m_lType = nil
	self.m_batch = nil
	self.m_lotteryNum = nil
	self.m_reTime = nil
	self.m_freeTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetEquipLottery:createElement()
	if WndPetEquipLottery.m_root ~= nil then
		WindowManager:removeWindow(WndPetEquipLottery.m_root, WndPetEquipLottery, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetEquipLottery")
	assert(element, "WndPetEquipLottery create element failed!")
	self:_init()
	return element
end


--@brief	请求返回的抽奖信息
function WndPetEquipLottery:setLotteryData(lType,batch,lotteryNum,reTime,freeTime)
	self.m_lType = lType
	self.m_batch = batch
	self.m_lotteryNum = lotteryNum
	self.m_reTime = reTime
	self.m_freeTime = freeTime 

	if self.m_usePinkDiamond == true then
		self.m_curBatch = self.m_batch[1]
	elseif self.m_usePinkDiamond == false then
		self.m_curBatch = self.m_batch[2]
	end
	self:updateAllBatch()
	self:initRightContent()
	self:updateUI()
	
	self:upRedDot()
end

--1--银 2--金
function WndPetEquipLottery:setViewIndex(n_index)
	WZLog("WndPetEquipLottery:setViewIndex",n_index)
	if self.m_usePinkDiamond == nil then
		if n_index == 1 then
			self.m_usePinkDiamond = true
		elseif n_index == 2 then
			self.m_usePinkDiamond = false
		end
	else 
		if n_index == 1 then
			if self.m_usePinkDiamond == false then --切换银币召唤页签的时候修改成银币召唤默认批次
				self.m_curBatch = self.m_batch[1]
			end
			self.m_usePinkDiamond = true
		elseif n_index == 2 then
			if self.m_usePinkDiamond == true then --切换金币召唤页签的时候修改成金币召唤默认批次
				self.m_curBatch = self.m_batch[2]
			end
			self.m_usePinkDiamond = false
		end
		self:initRightContent()
		self:updateUI()
	end
end

--@brief	领取自选礼包成功
function WndPetEquipLottery:getLotteryReward(lType,itemId,num)
	-- body
	if lType ~= 6 or itemId == nil and num == nil then return end
	if itemId and next(itemId) then
		g_bIsShowWndDressUp = true
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(6)
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

--@brief	抽奖成功
function WndPetEquipLottery:successLottery(lType,itemId,num,coinId,coinNum,natural,data)
	if itemId == nil or num == nil then return end
	self.m_lotteryShowTag = nil
	local highQuality = {}
	local tData = GDatatab_total_draw
	for i = 1,#itemId do 
		for k,v in pairs(tData) do
			if v.item_id[1][1] == itemId[i] and v.item_id[1][2] == num[i] and v.type == lType then
				WZLog("抽奖成功",v.item_id[1][1],itemId[i])
				if v.quality >= 6 then
					table.insert(highQuality,itemId[i])
					break 
				end
			end
		end
	end
	WZLog("高品质宠物装备",Serialize(highQuality))
	WndLotteryShow:showLottery(lType, itemId, num, highQuality, coinId, coinNum, {}, natural, data)
end

--@brief	分享奖励
function WndPetEquipLottery:getShareReward(lType,itemId,num)
	-- body
	if lType ~= 6 or itemId == nil or num == nil then return end
	if itemId and next(itemId) then
		WndRewardShow:showById(itemId,num,nil,nil,nil,nil,nil,nil,nil)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
