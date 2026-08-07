--CellPastureAnimalData.lua
--@brief	CellPastureAnimal的数据模块
--@date		2021/05/14
--@author	hyx
--@note		牧场坐骑

CellPastureAnimal = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPastureAnimal:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPlayerId = nil
	self.m_tPastureBaseData = {} --牧场基础信息
	self.m_sAniAreaContainer = nil
	self.m_nMountNum = 0 --坐骑的个数（虚拟的）
	self.m_nHasMountNum = 0 --当前拥有的坐骑个数
	self.m_tPlayerMountContainer = {} --坐骑的容器，主要用于坐骑的移动和碰撞
	self.m_tPlayerMount = {} --坐骑的创建
	self.m_tAniPosList = {} --坐骑走动的坐标
	self.m_nPastureAniScheduleId = nil --走动的定时器
	self.m_bMountAniReplace = {} --动物走动的时候 用于判断是否运动和静止交替两种状态
	self.m_bIsMountRunOrWait = false --用于判断跑动和停止在哪一只
	self.m_tMountRunORWait = {} --控制哪只坐骑的跑动和停止
	self.m_tPastureAnimalId = {} --牧场坐骑的信息
	self.m_tIsStop = {}
	self.m_tMountIndex = {}
	self.m_nManagerScheduleTime = nil
	self.m_nManagerTime = 0
	self.m_sManegerMaster = nil
	self.m_txtManagerTime = nil
	self.m_nMountMaxLevel = 1
	self.m_nStealPlayerId = nil
	self.m_bIsMyPastureNotTouch = nil
	self.m_nBuyMountCount = 0 --购买的坐骑
	self.m_sTxtPastureCoin = {}
	self.m_nInitPastureExp = 0 --初始化的经验
	self.m_tAnimalWalkControl = {} --控制动物行走
	self.m_tMountLevelData = {} --专门处理坐骑等级的

	self.m_sTouchStealMount = nil --偷取来的坐骑时候
	self.m_nStealMountNum = 0 --偷来的坐骑
	self.m_sAniComposeSpine = nil --合成特效

	self.m_tCreateCoinContainer = {} --创建用于产生金币的对象
	self.m_tCreateMinCoinData = {} --用于计算产生的金币

	self.m_sMountStealTimeSchedule = nil
	self.m_tTxtMountStealTime = {}
	self.m_tMountStealTime = {}
	self.m_nStealIndex = 1
	self.m_tStealMountId = {} --偷来的id
	--合成时新的位置起点
	self.m_nComposeEndPosX = nil
	self.m_nComposeEndPosY = nil
	--好友牧场的时候
	self.m_tFriendPastureData = {} -- 好友牧场的数据
	self.m_nCurFriendIndex = nil
	self.m_tBtnFriendTitle = {}
	self.m_tStealFriendData = {} --偷取好友
	self.m_tOpenTitleFriendView = {} --打开过的面板
	self.m_sIsQuickBuyMount = nil --是否是快速购买
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPastureAnimal:_unInit()
	self.m_root = nil
	self.m_nPlayerId = nil
	self.m_tPastureBaseData = {}
	self.m_sAniAreaContainer = nil
	self.m_nMountNum = 0
	self.m_nHasMountNum = 0
	self.m_tPlayerMountContainer = {}
	self.m_tPlayerMount = {}
	self.m_tAniPosList = {}
	self.m_nPastureAniScheduleId = nil
	self.m_bMountAniReplace = {}
	self.m_bIsMountRunOrWait = false
	self.m_tMountRunORWait = {}
	self.m_tPastureAnimalId = {}
	self.m_tIsStop = {}
	self.m_tMountIndex = {}
	self.m_nManagerScheduleTime = nil
	self.m_nManagerTime = 0
	self.m_sManegerMaster = nil
	self.m_txtManagerTime = nil
	self.m_nMountMaxLevel = 1
	self.m_nStealPlayerId = nil
	self.m_bIsMyPastureNotTouch = nil
	self.m_nBuyMountCount = 0
	self.m_sTxtPastureCoin = {}
	self.m_nInitPastureExp = 0
	self.m_tAnimalWalkControl = {}
	self.m_tMountLevelData = {} 
	self.m_sTouchStealMount = nil
	self.m_tCreateCoinContainer = {}
	self.m_tCreateMinCoinData = {}

	self.m_sMountStealTimeSchedule = nil
	self.m_tTxtMountStealTime = {}
	self.m_tMountStealTime = {}
	self.m_nStealIndex = 1
	self.m_tStealMountId = {}
	self.m_nComposeEndPosX = nil
	self.m_nComposeEndPosY = nil
	self.m_nStealMountNum = 0
	self.m_sAniComposeSpine = nil

	self.m_tFriendPastureData = {}
	self.m_nCurFriendIndex = nil
	self.m_tBtnFriendTitle = {}
	self.m_tOpenTitleFriendView = {}
	self.m_tStealFriendData = {}
	self.m_sIsQuickBuyMount = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPastureAnimal:createElement(m_nPlayerId)
	if CellPastureAnimal.m_root ~= nil then
		WindowManager:removeWindow(CellPastureAnimal.m_root, CellPastureAnimal, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPastureAnimal")
	assert(element, "CellPastureAnimal create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nPlayerId = m_nPlayerId
	return element, tNewObj
end

function CellPastureAnimal:setBasePastureInfo(data)
	self.m_tPastureBaseData = data
end
function CellPastureAnimal:getBasePastureInfo()
	return self.m_tPastureBaseData
end
--判断是否是他人牧场
function CellPastureAnimal:setIsOtherPasture()
	return self.m_bIsMyPastureNotTouch
end
--牧场等级
function CellPastureAnimal:setPastureLevel(lev)
	self.m_nPastureLevel = lev
end
function CellPastureAnimal:getPastureLevel()
	return self.m_nPastureLevel or 1
end

function CellPastureAnimal:getCurPastureMountMaxLevel()
	return self.m_nMountMaxLevel
end

function CellPastureAnimal:getHasMountNum()
	return self.m_nHasMountNum-self.m_nStealMountNum
end
function CellPastureAnimal:setFriendPastureData(playerId, name, sex, isOnline, vipLevel, pastureLevel, faceItemId, headItemId, headColor, 
	beStolenCount, isThief, stoleTime, canSteal, serverId)
	local data = {}
	self.m_tStealFriendData = {}
	if playerId and next(playerId) ~= nil then
		for i=1,#playerId do
			local tab = {}
			tab.playerId = playerId[i]
			tab.name = name[i]
			tab.sex = sex[i]
			tab.isOnline = isOnline[i]
			tab.vipLevel = vipLevel[i]
			tab.pastureLevel = pastureLevel[i]
			tab.faceItemId = faceItemId[i]
			tab.headItemId = headItemId[i]
			tab.headColor = headColor[i]
			tab.isThief = isThief[i]
			tab.stoleTime = stoleTime[i]
			tab.beStolenCount = beStolenCount[i]
			tab.canSteal = canSteal[i]
			local idMyServer = false --是否本服
			if CacheCenter:getPlayerInfo().serverId == serverId[i] then
				idMyServer = true
			end
			tab.idMyServer = idMyServer
			if isThief[i] == 1 then
				table.insert(self.m_tStealFriendData, tab)
			end
			data[i] = tab
		end
		local function funcSort(a,b)
			if a.canSteal == 0 and b.canSteal == 1 then
				return false
			elseif a.canSteal == 1 and b.canSteal == 0 then
				return true
			elseif (a.canSteal == 0 and b.canSteal == 0) or (a.canSteal == 1 and b.canSteal == 1) then
				return a.pastureLevel > b.pastureLevel
			else
				return a.pastureLevel > b.pastureLevel
			end
		end
		table.sort( data, funcSort)
	end
	return data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPastureAnimal:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------

--============= 好友牧场 =================
CellPastureFriendItem = {}
function CellPastureFriendItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPastureFriendItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellPastureFriendItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(334,90))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellPastureFriendItem:setBaseFriendData(index, data, isFriend)
	self.m_nFriendIndex = index
	self.m_tFriendData = data
	self.m_bIsFriend = isFriend or false --true为好友的时候可以跳转到好友牧场
end

--@brief 	开始加载
function CellPastureFriendItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellFriendItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setCellItemData()
end

function CellPastureFriendItem:setCellItemData()
	if not self.m_tFriendData then return end

	local data = self.m_tFriendData

	GetElement(self.m_root,"btnClickCheck",WZUIButton):setVisible(true)
	GetElement(self.m_root,"imgKuafu",WZUIImage):setVisible(not data.idMyServer)
	local txtRanking = GetElement(self.m_root,"txtRanking",WZUILabelAtlasFont)
	txtRanking:setVisible(false)
	local imgName = GetElement(self.m_root,"imgName",WZUIImage)
	imgName:setVisible(false)
	if self.m_bIsFriend == true then
		GetElement(self.m_root,"imgThief",WZUIImage):setVisible(data.canSteal == 1)
	end
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if self.m_nFriendIndex <= 3 then
		imgName:setVisible(true)
		imgName:setFile(rank_name[self.m_nFriendIndex])
	else
		txtRanking:setVisible(true)
		txtRanking:setText(self.m_nFriendIndex)
	end

	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(data.name)
	GetElement(self.m_root,"txtLevel",WZUILabelTTF):setText(LocalStrings.PASTURE_TEXT22..data.pastureLevel)
	local conHead = GetElement(self.m_root,"conHead",WZUIContainer)
	CellHead:show(conHead, data.headItemId, data.faceItemId, data.sex, false, nil, nil, data.headColor)
end
function CellPastureFriendItem:setCallFunc(func)
	self.m_sCallFunc = func
end

function CellPastureFriendItem:onClickCheck()
	if self.m_sCallFunc then
		self.m_sCallFunc()
	end
	if self.m_tFriendData then
		ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPlayerMountsPasture(self.m_tFriendData.playerId)
	end
end

--@return	新建的表实例对象
function CellPastureFriendItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--==============================