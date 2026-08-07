--WndMarriageData.lua
--@brief	WndMarriage的数据模块
--@date		2022/07/19
--@author	yrd
--@note		夫妻界面-姻缘

WndMarriage = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarriage:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bPlayerLoadFinish = nil 			--人物加载完毕

	self.loveId = nil
	self.m_sManeName = nil
	self.m_sWomanName = nil
	self.m_nManHeadId = nil
	self.m_nManFaceId = nil
	self.m_nManBodyId = nil
	self.m_nManWingId = nil
	self.m_nManHeadColor = nil
	self.m_nManBodyColor = nil
	self.m_nManServerId = nil
	self.m_nWomanHeadId = nil
	self.m_nWomanFaceId = nil
	self.m_nWomanBodyId = nil
	self.m_nWomanWingId = nil
	self.m_nWomanHeadColor = nil
	self.m_nWomanBodyColor = nil
	self.m_nWomanServerId = nil
	self.m_nWifeId = nil
	self.m_nHudandId = nil

	self.m_nLvl = nil
	self.m_nExp = nil
	self.m_nLuckyValue = nil
	self.m_nCoupleLvl = nil

	self.m_tCostItemList = nil 				--升级时消耗物品对象列表
	self.m_nCostSelectIdx = 1 				--升级时选中的消耗物品索引

	self.m_bIsTraining = false  				--正在执行升级动画

	self.m_tTargetPoint = {{262,238}}
	self.m_tStartPoint = {{66,58}, {150,58}, {234,58}}
	self.m_tSecondPoint = {{{78,158},{142,88}}, {{148,145},{216,95}}, {{206,142},{280,120}}}
	self.m_tThirdPoint = {{{148,210},{232,145}}, {{190,200},{265,153}}, {{217,186},{292,174}}}

	self.m_nTempBaseExp = nil 
	self.m_nDoubleTimes = nil 
	self.m_nTotalExpForAni = nil 
	self.m_nTempExp = 0 
	self.m_nEachAddExpForPgr = 1      --本次培养进度条的步长
	self.m_nTempLevel = 0 
	self.m_nIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarriage:_unInit()
	self.m_root = nil
	self.m_bPlayerLoadFinish = nil
	
	self.loveId = nil
	self.m_sManeName = nil
	self.m_sWomanName = nil
	self.m_nManHeadId = nil
	self.m_nManFaceId = nil
	self.m_nManBodyId = nil
	self.m_nManWingId = nil
	self.m_nManHeadColor = nil
	self.m_nManBodyColor = nil
	self.m_nManServerId = nil
	self.m_nWomanHeadId = nil
	self.m_nWomanFaceId = nil
	self.m_nWomanBodyId = nil
	self.m_nWomanWingId = nil
	self.m_nWomanHeadColor = nil
	self.m_nWomanBodyColor = nil
	self.m_nWomanServerId = nil
	self.m_nWifeId = nil
	self.m_nHudandId = nil

	self.m_nLvl = nil
	self.m_nExp = nil
	self.m_nLuckyValue = nil
	self.m_nCoupleLvl = nil

	self.m_tCostItemList = nil
	self.m_nCostSelectIdx = nil

	self.m_bIsTraining = nil

	self.m_tTargetPoint = nil
	self.m_tStartPoint = nil
	self.m_tSecondPoint = nil
	self.m_tThirdPoint = nil

	self.m_nTempBaseExp = nil 
	self.m_nDoubleTimes = nil 
	self.m_nTotalExpForAni = nil 
	self.m_nTempExp = nil
	self.m_nEachAddExpForPgr = nil
	self.m_nTempLevel = nil
	self.m_nIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarriage:createElement()
	if WndMarriage.m_root ~= nil then
		WindowManager:removeWindow(WndMarriage.m_root, WndMarriage, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMarriage")
	assert(element, "WndMarriage create element failed!")
	self:_init()
	return element
end

--@brief  获取夫妻形象信息
function WndMarriage:updatePlayerInfo()
	WZLog("WndMarriage:updatePlayerInfo")
	local myHeadId = 0
	local myFaceId = 0
	local myBodyId = 0
	local myWingId = 0
	for k,v in pairs(CacheCenter:getPlayerItems()) do
		if v.basicInfo then
			local maintype = v.basicInfo.main_type
			local subtype = v.basicInfo.sub_type
			if v.isUse == true then
				if maintype == 5 and subtype == 3 then -- 物品是否是翅膀装备
					myWingId =  v.id 
				elseif maintype == 5 and subtype == 2 then --物品是否是衣服 
					myBodyId = v.id
				elseif maintype == 5 and subtype == 1 then --物品是否是脸谱
					myFaceId = v.id
				elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
					myHeadId = v.id
				end
			end
		end
	end
	local myHeadColor, myBodyColor = CacheCenter:getHeadAndBodyColor()

	local tIdList = SplitStringWithSeparator(CacheCenter:getPlayerInfo().coupleMes, "|", nil, true)

	if CacheCenter:getPlayerInfo().sex == 0 then
		self.m_nHudandId = CacheCenter:getPlayerInfo().id
		self.m_sManeName = CacheCenter:getPlayerInfo().name
		self.m_nManHeadId = myHeadId
		self.m_nManFaceId = myFaceId
		self.m_nManBodyId = myBodyId
		self.m_nManWingId = myWingId
		self.m_nManHeadColor = myHeadColor
		self.m_nManBodyColor = myBodyColor
		self.m_nManServerId = CacheCenter:getPlayerInfo().serverId

		self.m_nWifeId = tIdList[7]
		self.m_sWomanName = CacheCenter:getPlayerInfo().mateName
		self.m_nWomanHeadId = tIdList[2]
		self.m_nWomanFaceId = tIdList[1]
		self.m_nWomanBodyId = tIdList[4]
		self.m_nWomanWingId = tIdList[6]
		self.m_nWomanHeadColor = tIdList[3]
		self.m_nWomanBodyColor = tIdList[5]
		self.m_nWomanServerId = tIdList[8]
	else
		self.m_nWifeId = CacheCenter:getPlayerInfo().id
		self.m_sWomanName = CacheCenter:getPlayerInfo().name
		self.m_nWomanHeadId = myHeadId
		self.m_nWomanFaceId = myFaceId
		self.m_nWomanBodyId = myBodyId
		self.m_nWomanWingId = myWingId
		self.m_nWomanHeadColor = myHeadColor
		self.m_nWomanBodyColor = myBodyColor
		self.m_nWomanServerId = CacheCenter:getPlayerInfo().serverId

		self.m_nHudandId = tIdList[7]
		self.m_sManeName = CacheCenter:getPlayerInfo().mateName
		self.m_nManHeadId = tIdList[2]
		self.m_nManFaceId = tIdList[1]
		self.m_nManBodyId = tIdList[4]
		self.m_nManWingId = tIdList[6]
		self.m_nManHeadColor = tIdList[3]
		self.m_nManBodyColor = tIdList[5]
		self.m_nManServerId = tIdList[8]
	end

	if self.m_root ~= nil then
		self:updateInfo()
	end
end

--@brief  夫妻姻缘信息
function WndMarriage:getMarriageInfoOk(lvl, exp, luckyValue, coupleLvl)
	if self.m_root == nil then
		return
	end
	self.m_nLvl = lvl
	self.m_nExp = exp
	self.m_nLuckyValue = luckyValue
	self.m_nCoupleLvl = coupleLvl

	if self.m_bIsTraining ~= true then
		self:updateMarriageInfo()
	end
end

--@brief  结缘成功
function WndMarriage:getMarriageBreakOk(succ, luckyValue)
	if succ then
		MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[5])
		self.m_nLvl = self.m_nLvl + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[6])
	end

	self.m_nLuckyValue = luckyValue
	self:updateMarriageInfo()
end

--@brief  升级成功
function WndMarriage:getMarriageUpgradeOk(currentLevel, currentExp, baseExp, multiple, preLevel, level)
	if self.m_bIsTraining then 
		self.m_bIsTraining = false

		self.m_nSoulLevel = self.m_nLvl 
		self.m_nCurSoulExp = self.m_nExp

		self:resetImmediately()
	end

	self.m_bIsTraining = true

	self.m_nLvl = currentLevel 
	self.m_nExp = currentExp

	self:trainOK(currentLevel, currentExp, baseExp, multiple, preLevel, level)
end

--@brief    如果连续点击升级，上一次的直接跳过动画
function WndMarriage:resetImmediately()
	if self.m_root == nil then return end

	local conSoulLeft = GetElement(self.m_root, "conLoveProgress_WndMarriage", WZUIContainer)
	conSoulLeft:disableSchedule()

	self:updateMarriageInfo()
end

--动画

--@brief    培养成功
function WndMarriage:trainOK(currentLevel, currentExp, baseExp, multiple, preLevel, level)
	self.m_nIndex = 1
	self.m_nTempBaseExp = baseExp[self.m_nIndex] 
	self.m_nDoubleTimes = multiple[self.m_nIndex] 

	self.m_nAniNum = #baseExp
	self.m_nCurAniNum = 1

	self.baseExp = baseExp
	self.multiple = multiple
	self.preLevel = preLevel
	self.level = level
	self:_displayTrainParticle(self.m_nCostSelectIdx)
	if self.m_nAniNum > 1 then
		self.m_root:enableSchedule("_displayTrainParticle0", 0.1)
	end
end

function WndMarriage:_displayTrainParticle0(dt) 
	self.m_nCurAniNum = self.m_nCurAniNum + 1
	if self.m_nCurAniNum > self.m_nAniNum then 
		self.m_root:disableSchedule() 
		return
	end

	self:_displayTrainParticle(self.m_nCostSelectIdx)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
