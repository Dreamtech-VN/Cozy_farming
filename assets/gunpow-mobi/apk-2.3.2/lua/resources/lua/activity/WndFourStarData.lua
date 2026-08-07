--WndFourStarData.lua
--@brief	WndFourStar的数据模块
--@date		2021/02/19
--@author	hyx
--@note		四象星宿

WndFourStar = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFourStar:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBoxProgressData = {} --宝箱的数据
	self.m_tSummonReward = {} --青龙,白虎,朱雀,玄武
	self.m_nSummonChoose = nil --1:召唤  2:选择奖励
	self.m_nSummonCount = 0 --召唤卷的数量
	self.m_nSummonVersion = nil
	self.m_sBoxCommonObj = nil
	self.m_sSummonRewardSpine = nil
	self.m_sSummonRewardData = nil
	self.m_sSummonStartSpine = nil
	self.m_sIsFirstComeIn = nil --是否需要进入界面打开规则面板
	self.m_nCalabashType = 0 	--十连抽复选框选中状态
	self.m_nCoinId = 160040 		--货币id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFourStar:_unInit()
	self.m_root = nil
	self.m_tBoxProgressData = {}
	self.m_tSummonReward = {}
	self.m_nSummonChoose = nil
	self.m_nSummonCount = 0
	self.m_nSummonVersion = nil
	self.m_sBoxCommonObj = nil
	self.m_sSummonRewardSpine = nil
	self.m_sSummonRewardData = nil
	self.m_sSummonStartSpine = nil
	self.m_sIsFirstComeIn = nil
	self.m_nCalabashType = nil 
	self.m_nCoinId = nil 		--货币id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFourStar:createElement()
	if WndFourStar.m_root ~= nil then
		WindowManager:removeWindow(WndFourStar.m_root, WndFourStar, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFourStar")
	assert(element, "WndFourStar create element failed!")
	self:_init()
	return element
end
--宝箱数据
function WndFourStar:setBoxProgressData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
	local index = 1
	local table_insert = table.insert
	for i,v in ipairs(rewardCounts) do
		local tab = {}
		tab.id = rewardId[i]
		tab.tager = finishCondition[i]
		tab.status = status[i]
		local reward_id = {}
		local reward_num = {}
		for m=1,rewardCounts[i] do
			table_insert(reward_id,rewardItems[index])
			table_insert(reward_num,rewardItemsParamCount[index])
			index = index + 1
		end
		tab.reward_id = reward_id
		tab.reward_num = reward_num
		self.m_tBoxProgressData[rewardId[i]] = tab
	end
end
--召唤奖励
function WndFourStar:setSummonReward(data)
	local index = 1
	data = data or {}
	for i,v in ipairs(data.selectSs) do
		local tab = {}
		tab.status = data.selectSs[i]
		tab.id = data.selectSIds[i]
		tab.num = data.selectSNums[i]
		self.m_tSummonReward[index] = tab
		index = index + 1
	end
	for i,v in ipairs(data.selectAs) do
		local tab = {}
		tab.status = data.selectAs[i]
		tab.id = data.selectAIds[i]
		tab.num = data.selectANums[i]
		self.m_tSummonReward[index] = tab
		index = index + 1
	end
	self.m_nSummonVersion = data.version or 1
	self.m_sIsFirstComeIn = data.guide or nil
	if self.m_tSummonReward[1] and self.m_tSummonReward[1].status == -1 then
		self.m_nSummonChoose = 2
	else
		self.m_nSummonChoose = 1
	end
end

function WndFourStar:setFourStarRedPoint(id, _type)
	local status = false
	if _type == 1 then
		status = true
	end
	if not self.m_sCollectRedPoint then
		self.m_sCollectRedPoint = false
	end
	if not self.m_sTaskRedPoint then
		self.m_sTaskRedPoint = false
	end
    if id == 17008 then
		self.m_sCollectRedPoint = status
    elseif id == 27008 then
    	self.m_sTaskRedPoint = status
    end
    self:setImgLibraryRedPoint(self.m_sCollectRedPoint)
    WndFourStarLabrary:setRewardRedPoint(self.m_sTaskRedPoint)
end
function WndFourStar:getLibraryRedPoint()
	local status = false
	status = self.m_sCollectRedPoint or self.m_sTaskRedPoint
	return status
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取上次保存的球杆
function WndFourStar:getPoleType()
    WZLog("WndFourStar:getPoleType")
    local _KeyString = ""
    local curDate = os.date("*t", SystemTime:getServerTime())
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "FOURSTAR" .. tostring(CacheCenter:getPlayerInfo().id)
    local strValue =  data:getStringValue("CALABASH_MARK", _KeyString)
    local curValue = string.format("%02d%02d", curDate.month, curDate.day)
    if strValue ~= nil and strValue ~= "" then
        local result = SplitStringWithSeparator(strValue, "_")
        if result[1] == curValue then 
        	self.m_nCalabashType = tonumber(result[2])
        	if self.m_nCalabashType ~= 0 then 
        		GetElement(self.m_root, "cbTen_WndFourStar", WZUICheckBox):setCheckIndex(self.m_nCalabashType)
        	end
        end
    end
end





-------------------------------------私有方法模块End----------------------------------------
