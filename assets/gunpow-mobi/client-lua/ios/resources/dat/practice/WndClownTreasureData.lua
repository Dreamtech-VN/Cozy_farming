--WndClownTreasureData.lua
--@brief	WndClownTreasure的数据模块
--@date		2017/11/27
--@author	zhangming
--@note		小丑寻宝
WndClownTreasure = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndClownTreasure:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_speed = 140                    --滚动速度
	self.t_data = {}                    --修炼的数据表
	self.n_rollTime = 0                 --滚动时间
	self.t_bActionOver = {}         	--动作完成的数组
	self.t_nConListPosY = {}            --滚动列表对应的y坐标
	self.t_imgMoveElement = {}          --飞行时候的移动节点
	self.m_nLoadingId = 0               --loadId
	self.n_fighting = 0                 --当前战斗力
	self.m_nTag = nil
	self.m_tLuckDrawData = nil
	self.m_tRewardData = nil
	self.m_nStatus = 0
	self.m_bOpenByStore = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndClownTreasure:_unInit()
	self.m_root = nil
	self.n_speed = nil
	self.t_data = nil
	self.n_rollTime = nil
	self.b_actionOver = nil
	self.t_nConListPosY = nil          
	self.t_bActionOver = nil
	self.t_imgMoveElement = nil
	self.m_nLoadingId = nil  
	self.n_fighting = nil
	self.m_nTag = nil
	self.m_tLuckDrawData = nil
	self.m_tRewardData = nil
	self.m_nStatus = nil
	self.m_bOpenByStore = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndClownTreasure:createElement()
	if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndClownTreasure")
	assert(element, "WndClownTreasure create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndClownTreasure:showInterface(bStore)
	-- body
	WZLog("WndClownTreasure:showInterface")
	local wndClownTreasure = WndClownTreasure:createElement()
	if wndClownTreasure ~= nil then
	    WindowManager:addWindow(wndClownTreasure, WndClownTreasure, true,nil,nil,true)
	    self.m_bOpenByStore = bStore
	end
end

--拉杆信息
function WndClownTreasure:setTreasureInfo(raffleMark, status, raffleNum, raffleReset)
	-- body
	WZLog("WndClownTreasure:setTreasureInfo ",Serialize(raffleMark),status,raffleNum,raffleReset)
	if self.m_root == nil then return end
	self.m_tRaffleMark = raffleMark
	self.m_nStatus = status
	self.m_nRaffleNum = raffleNum
	self.m_nRaffleReset = raffleReset
	self:updateUI()
	self:changTip()
end


--拉杆抽奖成功
function WndClownTreasure:raffleSuccess(raffleMark)
	-- body
	WZLog("WndClownTreasure:raffleSuccess ",Serialize(raffleMark))
	if self.m_root == nil then return end
	self.m_tLuckDrawData = raffleMark
	self.m_nStatus = 1
	self.m_nRaffleNum = self.m_nRaffleNum + 1
	self.m_nRaffleReset = 0
	GetElement(self.m_root,"conAll_WndClownTreasure",WZUIContainer):setTouchEnable(false)
	self:_startRoll()
	GetElement(self.m_root,"spine3_WndClownTreasure",WZUISpine):setVisible(false)
	local spine2 = GetElement(self.m_root,"spine2_WndClownTreasure",WZUISpine)
	spine2:play("animation", false)
	spine2:enableSchedule("_anctionOver2")
	if GlobalGame.G_ClownTreasure_Quick == 0 then
		local spine = GetElement(self.m_root,"spine1_WndClownTreasure",WZUISpine)
		spine:play("a_1", false)
		spine:enableSchedule("_anctionOver")
	end
	self:changTip()
end

--@breif 指针开始结束
function WndClownTreasure:_anctionOver(element)
	WZLog("WndClownTreasure:_anctionOver:", element)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		spine:play("a_2",true)
	end	
end

--@breif 指针开始结束
function WndClownTreasure:_anctionOver2(element)
	WZLog("WndClownTreasure:_anctionOver2:", element)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		GetElement(self.m_root,"spine3_WndClownTreasure",WZUISpine):setVisible(true)
	end	
end

--解析奖励信息
function WndClownTreasure:AnalysisReward()
	-- body
	local reward = CacheCenter:getGameParam().raffleReward
	--[23,70]&[22,2]|[23,20]|[23,30]|[23,50]&[22,1]|[23,70]&[22,2]	
	WZLog("WndClownTreasure:AnalysisReward ",reward)
	local tReward = SplitStringWithSeparator(reward,"&")
	local temp = nil
	local tempT = {}
	local b = {}
	local c = nil
	local length = nil
	local bTwo = false
	for i,v in ipairs(tReward) do
		temp = SplitStringWithSeparator(v,"|")
		length = #temp
		for j,k in ipairs(temp) do
			temp = SplitStringToTable(k)
			if j == length then
				bTwo = true
			end
			if bTwo then
				table.insert(b,tonumber(temp[1]))
				table.insert(b,tonumber(temp[2]))
				if #b == 4 then
					table.insert(tempT,b)
					bTwo = false
					b = {}
				end
			else
				local a = {}
				table.insert(a,tonumber(temp[1]))
				table.insert(a,tonumber(temp[2]))
				table.insert(tempT,a)
			end
		end
	end

	self.m_tRewardData = tempT
end


function WndClownTreasure:receiveGoods(itemId,itemNum,status)
	-- body
	WZLog("WndClownTreasure:receiveGoods ",status)
	self.m_nStatus = status
	self:updateUI()
	self:changTip()
	WndRewardShow:showById(itemId,itemNum)
end

--重置单个槽位
function WndClownTreasure:resertSingleSlot(raffleMark)
	-- body
	WZLog("WndClownTreasure:resertSingleSlot ",Serialize(self.m_tRaffleMark),self.m_nTag)
	if self.m_root == nil then return end
	GetElement(self.m_root,"conAll_WndClownTreasure",WZUIContainer):setTouchEnable(false)
	self.m_tLuckDrawData = self.m_tRaffleMark
	self.m_tLuckDrawData[self.m_nTag] = raffleMark
	self.m_nSingleRaffleMark = raffleMark
	self.m_nRaffleReset  = self.m_nRaffleReset  + 1
	self:_startSingleRoll()
	self:changTip()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
