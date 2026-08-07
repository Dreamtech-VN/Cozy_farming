--WndNewYearMainData.lua
--@brief	WndNewYearMain的数据模块
--@date		2020/12/01
--@author	hyx
--@note		元旦求签

WndNewYearMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewYearMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sImgSelectDayGet = nil
	self.m_sTxtActivityTime = nil
	self.m_tJoinRewardId = {}
	self.m_tJoinRewardNum = {}
	self.m_nJoinRewardCount = 0
	self.m_nJoinRewardStatus = 0
	self.m_nTouchSignTicker = nil
	self.m_nDivinationCostId = 0
	self.m_nDivinationCostNum = 0
	self.m_tSignReward = {}
	self.m_sRemainTimeTicker = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewYearMain:_unInit()
	self.m_root = nil
	self.m_sImgSelectDayGet = nil
	self.m_sTxtActivityTime = nil
	self.m_tJoinRewardId = {}
	self.m_tJoinRewardNum = {}
	self.m_nJoinRewardCount = 0
	self.m_nJoinRewardStatus = 0
	self.m_nTouchSignTicker = nil
	self.m_nDivinationCostId = 0
	self.m_nDivinationCostNum = 0
	self.m_tSignReward = {}
	self.m_sRemainTimeTicker = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewYearMain:createElement()
	if WndNewYearMain.m_root ~= nil then
		WindowManager:removeWindow(WndNewYearMain.m_root, WndNewYearMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewYearMain")
	assert(element, "WndNewYearMain create element failed!")
	self:_init()
	return element
end

function WndNewYearMain:setConfigInitData()
	--领取参与个数
	local divinationConfig = CacheCenter:getGameParam().divinationConfig
	if divinationConfig then
		local array = SplitStringWithSeparator(divinationConfig,"&")
		if array[1] then
			local _string = string.sub(array[1],2,-2)
			self.m_nJoinRewardCount = SplitStringWithSeparator(_string,",")[2]
		end
	end
	--获取参与奖励
	local divinationJoinReward = CacheCenter:getGameParam().divinationJoinReward
	if divinationJoinReward then
		local array = SplitStringWithSeparator(divinationJoinReward,"&")
		local table_insert = table.insert
		local ids = {}
		local nums = {}
		for i=1,#array do
			local _string = string.sub(array[i],2,-2) 
			local id = nil
			if CacheCenter:getPlayerInfo().sex == 0 then
				id = SplitStringWithSeparator(_string,",")[1]
			else
				id = SplitStringWithSeparator(_string,",")[2]
			end
			local num = SplitStringWithSeparator(_string,",")[3]
			table_insert(ids,id)
			table_insert(nums,num)
		end
		self.m_tJoinRewardId = ids
		self.m_tJoinRewardNum = nums
	end
	--求签道具消耗和数量
	local divinationCost = CacheCenter:getGameParam().divinationCost
	if divinationCost then
		local _string = string.sub(divinationCost,2,-2)
     	self.m_nDivinationCostId = SplitStringWithSeparator(_string,",")[1]
     	self.m_nDivinationCostNum = SplitStringWithSeparator(_string,",")[2]
	end
end
function WndNewYearMain:getJoinRewardData()
	return self.m_tJoinRewardId, self.m_tJoinRewardNum
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
