--CellGoldData.lua
--@brief	CellGold的数据模块
--@date		2014/08/20
--@author	周亚茜
--@note		底部金币公共模块

CellGold = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGold:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tAddDiamon = nil		--钻石回调
	self.m_tAddGold = nil		--金币回调
	self.m_tAddLove = nil       --爱心回调
	self.m_tAddBadge = nil		--徽章回调
	self.m_tAddSoulDebri = nil	--星魂回调
	self.m_nSoulDebri = 0		--星魂列表
	self.m_tGold  = nil 		--金币列表
	self.m_nShowTag = 0         --需要显示的道具
	--Add By Tianxiang_Xu
	self.m_tGoldNumForAni = nil --玩家钻石、金币、活力每次变化前的值
	self.m_tBlueDiamondData = nil --钻石数量的各个位数的数字
	self.m_nType = 0 			--区分用那种背景0：默认；1:为主城
	self.m_tItemIdList = nil 	--货币的物品ID
	self.m_tNeedAddIcon = nil 	--货币是否需要+号标记

	-- add by binshao
	self.shieldClick = false

	self.m_bUpdateState = true --数据到达实时刷新 开关
	self.m_tResetCallBack = nil 	--点击觉醒重置按钮回调
	self.m_bIsMatching = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGold:_unInit()
	self.m_root = nil
	self.m_tAddDiamon = nil
	self.m_tAddGold = nil 
	self.m_tAddLove = nil
	self.m_tAddBadge = nil
	self.m_tAddSoulDebri = nil
	self.m_tGold  = nil 
	self.m_nShowTag = nil
	--Add By Tianxiang_Xu
	self.m_tGoldNumForAni = nil --玩家钻石、金币、活力每次变化前的值
	self.m_tBlueDiamondData = nil --钻石数量的各个位数的数字
	self.m_nType = nil 			--区分用那种背景0：默认；1:为主城
	self.m_tItemIdList = nil 	--货币的物品ID
	self.m_tNeedAddIcon = nil 	--货币是否需要+号标记

	self.shieldClick = nil

	self.m_bUpdateState = true
	self.m_tResetCallBack = nil 	--点击觉醒重置按钮回调
	self.m_bIsMatching = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGold:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGold table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellGold")
	assert(element, "CellGold element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置保存变化前的数据，以备下次使用
--@param 	当前钻石、金币数据
function CellGold:setDataForAni(tData)
	-- body
	if self.m_tGoldNumForAni == nil then
		self.m_tGoldNumForAni ={}
	end

	self.m_tGoldNumForAni.blueDiamond   = tData.blueDiamond
	self.m_tGoldNumForAni.gold 			= tData.gold
	self.m_tGoldNumForAni.vigor 		= CacheCenter:getPlayerInfo().vigor
end

--@brief 	设置保存个数据每次的变化量
--@param 	当前钻石、金币数据
function CellGold:setEachDataForAni(tData)
	-- body
	if self.m_tGoldNumForAni == nil then
		self.m_tGoldNumForAni ={}
	end

	self.m_tGoldNumForAni.eachDiamondNum = math.abs(tData.blueDiamond - self.m_tGoldNumForAni.blueDiamond)
	self.m_tGoldNumForAni.eachGoldNum = math.abs(tData.gold - self.m_tGoldNumForAni.gold)
	self.m_tGoldNumForAni.eachVigorNum = math.abs(CacheCenter:getPlayerInfo().vigor - self.m_tGoldNumForAni.vigor)

	-- local nDataNum = math.floor(math.log10(self.m_tGoldNumForAni.eachDiamondNum))
	-- local eachDiamondNum = 0

	-- for i = 1, nDataNum + 1 do
	-- 	eachDiamondNum = eachDiamondNum * 10 + 1
	-- end
	-- self.m_tGoldNumForAni.eachDiamondNum = eachDiamondNum

	-- nDataNum = math.floor(math.log10(self.m_tGoldNumForAni.eachGoldNum))
	-- local eachGoldNum = 0
	-- for i = 1, nDataNum + 1 do
	-- 	eachGoldNum = eachGoldNum * 10 + 1
	-- end
	-- self.m_tGoldNumForAni.eachGoldNum = eachGoldNum

	-- nDataNum = math.floor(math.log10(self.m_tGoldNumForAni.eachVigorNum))
	-- local eachVigorNum = 0
	-- for i = 1, nDataNum + 1 do
	-- 	eachVigorNum = eachVigorNum * 10 + 1
	-- end
	-- self.m_tGoldNumForAni.eachVigorNum = eachVigorNum
	self.m_tGoldNumForAni.eachDiamondNum = self:getEachNum(self.m_tGoldNumForAni.eachDiamondNum)
	self.m_tGoldNumForAni.eachGoldNum = self:getEachNum(self.m_tGoldNumForAni.eachGoldNum)
	self.m_tGoldNumForAni.eachVigorNum = self:getEachNum(self.m_tGoldNumForAni.eachVigorNum)

	WZLog("*********** CellGold:setEachDataForAni ************", self.m_tGoldNumForAni.eachDiamondNum, self.m_tGoldNumForAni.eachGoldNum, self.m_tGoldNumForAni.eachVigorNum)
end

--@brief 获得每次加成
function CellGold:getEachNum(value)
	local nDataNum = math.floor(math.log10(value))
	nDataNum = (nDataNum + 1)* 2
	if nDataNum > 30 then
		nDataNum = 30
	end
	local eachGoldNum = math.ceil(value/nDataNum)
	
	if eachGoldNum < 0 then
		eachGoldNum = 0
	end

	return eachGoldNum
end

--@brief 	设置类型
function CellGold:setCellType(nType)
	-- body
	self.m_nType = nType or 0
	-- self:_setGoldTypeBk()
end


--@brief 	确认缓存数据是否来到更新界面
function CellGold:getStartInfoList()
	local  bIsHasInfo = CacheCenter:hasPlayerInfo()
	if bIsHasInfo == true then
		--玩家信息
		self:_recvGold(CacheCenter:getMoneyList())
	else
    	WZLog("等待缓存数据到来")
	end
end

--@brief 自动刷新状态
function CellGold:setUpdateState(value)
	self.m_bUpdateState = value
	WZLog("CellGold:setUpdateState",tostring(value))
end

--@brief	接收缓存信息
function CellGold:_recvGold(tData)
	WZLog("CellGold:_recvGold",tostring(self.m_bUpdateState))
	self.m_tGold = {} --获取玩家信息列表
	self.m_tGold = tData
	self.m_nSoulDebri = tostring(CacheCenter:getPlayerItemCount(8, 18))

	if not self.m_bUpdateState then
		return
	end

	if self.m_tGoldNumForAni == nil then
		self:_update()
	else
		self:setEachDataForAni(tData)
		self.m_root:enableSchedule("aniForNum", 0.03)
	end
end

--@brief	创建点击添加钻石按钮回调
function CellGold:setDiamonbackFun(tCell,backFun)
	self.m_tAddDiamon = nil 
	if tCell and backFun then
		self.m_tAddDiamon[1] = tCell
		self.m_tAddDiamon[2] = backFun
	end
end

--@brief	创建点击添加金币按钮回调
function CellGold:setGoldBackFun(tCell,backFun)
	self.m_tAddGold = nil 
	if tCell and backFun then
		self.m_tAddGold[1] = tCell
		self.m_tAddGold[2] = backFun
	end
end

--@brief	创建点击添加爱心按钮回调
function CellGold:setLoveBackFun(tCell,backFun)
	self.m_tAddLove = nil 
	if tCell and backFun then
		self.m_tAddLove[1] = tCell
		self.m_tAddLove[2] = backFun
	end
end

--@brief	创建点击添加钻石按钮回调
function CellGold:setBadgeFun(tCell,backFun)
	self.m_tAddBadge = nil 
	if tCell and backFun then
		self.m_tAddBadge[1] = tCell
		self.m_tAddBadge[2] = backFun
	end
end

--@brief	监听动态更新数据列表  观察者回调方法
function CellGold:updateMoneyData()
	self:_recvGold(CacheCenter:getMoneyList())
end

--@brief	监听动态更新数据列表
function CellGold:updateOtherData()
	local  bIsHasInfo = CacheCenter:hasPlayerInfo()
	if bIsHasInfo == true then
		self:_recvGold(CacheCenter:getMoneyList())
		self.m_nSoulDebri = tostring(CacheCenter:getPlayerItemCount(8, 18))
	end
end

-- 设置屏蔽点击参数
function CellGold:setShieldClick(bFlag)
	self.shieldClick = bFlag
end

function CellGold:getShieldClick()
	return self.shieldClick
end

--@brief 	设置匹配状态
function CellGold:setMatchState(bMatching)
	--body
	self.m_bIsMatching = bMatching
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGold:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------
