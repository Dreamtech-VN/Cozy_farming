--SceneTeachBattleLoading.lua
--@brief	SceneTeachBattleLoading的UI模块
--@date		2014/01/08
--@author	李光森
--@note		战斗载入场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneTeachBattleLoading:onEnter(element)
    WZLog("SceneTeachBattleLoading:onEnter")
	self.m_root = element

    TeachBattle:startTeach(Teach.DATA.saveStep[1].step , nil)
	ProtocolProcessorSceneTeachBattleLoading:regAll()		--注册协议
    GlobalGame:setIfInBattle(true)
	
	self:_update()
	self.m_root:enableSchedule("_updateLoading")

	self.m_tStepFunction = {}
	table.insert(self.m_tStepFunction,self._getTips)
	table.insert(self.m_tStepFunction,self._getPlayerInfo)
	table.insert(self.m_tStepFunction,self._initBoss)
	table.insert(self.m_tStepFunction,self._initPlayer)
	table.insert(self.m_tStepFunction,self._loadMap)
	table.insert(self.m_tStepFunction,self._waitting)
	table.insert(self.m_tStepFunction,self._endLoading)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneTeachBattleLoading:onExit(element)
	ProtocolProcessorSceneTeachBattleLoading:unregAll()		--反注册协议
	self:_unInit()
end

--@brief	返回在MakePairOk表中自己的数据的下标
--@param	tMakePair:MakePairOk表
--@return	#1:下标,-1:没有找到
function SceneTeachBattleLoading:getSelfIndex(tMakePair)
	WZLog("SceneTeachBattleLoading:getSelfIndex")
	for i=1,tMakePair.playerCount do
		if tMakePair.playerId[i] == CacheCenter:getPlayerInfo().id then
			return i
		end
	end
	return -1
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获取提示语
function SceneTeachBattleLoading:_getTips()
    WZLog("SceneTeachBattleLoading:_getTips")
	ProtocolProcessorSceneTeachBattleLoading:send_BATTLE_GetTips()
	return true
end

function SceneTeachBattleLoading:_getPlayerInfo()
    WZLog("SceneTeachBattleLoading:_getPlayerInfo")
	ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo(1)
	return true
end

--@brief	初始化怪物
--@return	#1:true:完成,false:未完成
function SceneTeachBattleLoading:_initBoss()
	WZLog("SceneTeachBattleLoading:_initBoss")
	--着装
	local element = WZUISystem:getInstance():createElement("conCellPlayer_SceneBattleLoading")

	WZLog("SceneTeachBattleLoading:_initBoss element",element)
	--boss表
	self.m_tBoss = TeachBoss:buildGuai()
	WZLog("SceneTeachBattleLoading:_initBoss build guai",self.m_tBoss)
	TeachBattle:setBoss(self.m_tBoss)
	WZLog("SceneTeachBattleLoading:_initBoss set guai",self.m_tBoss)
	TeachBattle:initBoss(LocalStrings.TEACH_BOSS_NAME)
	WZLog("SceneTeachBattleLoading:_initBoss init guai",self.m_tBoss)

	WZLog("SceneTeachBattleLoading:_initBoss boss",self.m_tBoss)
	--boss显示图片
	local bossImg = WZUIImage:create()
	bossImg:setFile("common/teach/guai2.png")
	bossImg:setUseOriginSize(true)

	WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(bossImg)
	WZUIProgress:luaTo(GetElement(element,"progPlayerLoad_SceneBattleLoading")):setPercentage(100)

	WZLog("SceneTeachBattleLoading:_initBoss addChild",bossImg)
	--名字
	WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setText(LocalStrings.TEACH_BOSS_NAME)
	--等级(分为转生与没转生)
    WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",1))):setVisible(true)
    WZUILabelAtlasFont:luaTo(GetElement(element,string.format("txtPlayerLevel%d_SceneBattleLoading",1))):setText(99)
    WZUILabelAtlasFont:luaTo(GetElement(element,string.format("txtPlayerLevel%d_SceneBattleLoading",1))):setVisible(true)
	
	local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conBossSeatFor%d_SceneBattleLoading",1)))
	WZUIContainer:luaTo(GetElement(conSeats,string.format("conBossSeat%d_SceneBattleLoading",1))):addChild(element)
	
	element:setVisible(true)

	WZLog("SceneTeachBattleLoading:_initBoss end")
	return true
end

--@brief	初始化玩家
--@return	#1:true:完成,false:未完成
function SceneTeachBattleLoading:_initPlayer()
	WZLog("SceneTeachBattleLoading:_initPlayer")
	if self.m_tPlayerInfo ~= nil then
		local tEquipList = {}
		StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_head)
		StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_face)
		StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_body)
		StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_weapon)
		StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_wing)

		self.m_tPlayer = TeachHero:buildHero(tEquipList , self.m_tPlayerInfo.playerSex , self.m_tPlayerInfo.weapon_type )
		TeachBattle:setMyHero(self.m_tPlayer)
		TeachBattle:initHero(self.m_tPlayerInfo.playerName)

		--着装
		local element = WZUISystem:getInstance():createElement("conCellPlayer_SceneBattleLoading")

		WZUIContainer:luaTo(GetElement(element,"conPlayer_SceneBattleLoading")):addChild(self.m_tPlayer:getShopAnimation())
		local size = GetElement(element,"conPlayer_SceneBattleLoading"):getAbsContentSize()
		self.m_tPlayer:getShopAnimation():setPosition(size.width*0.5,0)

		--名字
		WZUILabelTTF:luaTo(GetElement(element,"txtPlayerName_SceneBattleLoading")):setText(self.m_tPlayerInfo.playerName)

		--等级(分为转生与没转生)
   		WZUIImage:luaTo(GetElement(element,string.format("imgPlayerLevelBack%d_SceneBattleLoading",1))):setVisible(true)
    	WZUILabelAtlasFont:luaTo(GetElement(element,string.format("txtPlayerLevel%d_SceneBattleLoading",1))):setText(99)
    	WZUILabelAtlasFont:luaTo(GetElement(element,string.format("txtPlayerLevel%d_SceneBattleLoading",1))):setVisible(true)

    	local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",1)))
		WZUIContainer:luaTo(GetElement(conSeats,string.format("conLeftPlayer%d_SceneBattleLoading",1))):addChild(element)

		element:setVisible(true)

		self:_updatePercent(50)
		return true
	else
		return false
	end
	return true
end

function SceneTeachBattleLoading:_loadMap()
	WZLog("SceneTeachBattleLoading:_loadMap")
	BattleMapManager:loadMap("41")
	self:_updatePercent(100)
end

function SceneTeachBattleLoading:_waitting()
	WZLog("SceneTeachBattleLoading:_waitting")
	if self.__lala__ == nil then
		self.__lala__ = 100
	end
	self.__lala__ = self.__lala__ - 1
	if self.__lala__ > 0 then
		return false
	end
	return true
end

--[[function SceneTeachBattleLoading:( ... )
	-- body
end]]

--@brief	结束loading
--@return	#1:true:完成,false:未完成
function SceneTeachBattleLoading:_endLoading()
	WZLog("SceneTeachBattleLoading:_endLoading")
	local sceneTeachBattle = SceneTeachBattle:createElement()
	SceneTeachBattle:init()

	replaceScene(sceneTeachBattle)

	

	return true
end

--@brief	更新函数
function SceneTeachBattleLoading:_updateLoading()
	--WZLog("SceneTeachBattleLoading:_updateLoading")

	--[[if WBattleGlobal:getCurrent().m_tMakePairOk == nil then
		WZLog("SceneTeachBattleLoading:_updateLoading m_tMakePairOk is nil")
		return
	end]]

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
	else
		self.m_root:disableSchedule()
	end
end

--@brief	更新函数
--@note		实际上的初始化函数
function SceneTeachBattleLoading:_update()
	WZLog("SceneTeachBattleLoading:_update")

	--[[if WBattleGlobal:getCurrent().m_tMakePairOk == nil then
		WZLog("SceneTeachBattleLoading:_update m_tMakePairOk is nil")
		return
	end]]

	--更新UI文本
	self:_updateUIText()

	--更新地图
	self:_updateMap()

	--更新Tips
	self:_updateTips()
end

--@brief	更新界面文本
--@note		主要用于语言适配
function SceneTeachBattleLoading:_updateUIText()
	WZLog("SceneTeachBattleLoading:_updateUIText")
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTipsTitle_SceneBattleLoading")):setText(LocalStrings.TIPS..":")
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMapTitle_SceneBattleLoading")):setText(LocalStrings.LITLE_MAP..":")
end

--@brief	更新地图
function SceneTeachBattleLoading:_updateMap()
	WZLog("SceneTeachBattleLoading:_updateMap")

	WZUIImage:luaTo(GetElement(self.m_root,"imgMap_SceneBattleLoading")):setFile(self:_getMapBgByIcon("map41"))
	WZUIImage:luaTo(GetElement(self.m_root,"imgMapTitle_SceneBattleLoading")):setFile(self:_getMapTitleByIcon("map41"))
	WZUIContainer:luaTo(GetElement(self.m_root,"conMap_SceneBattleLoading")):setVisible(true)
end

--@brief	更新Tips
function SceneTeachBattleLoading:_updateTips()
	WZLog("SceneTeachBattleLoading:_updateTips")
	if self.m_tTips ~= nil and #self.m_tTips.tips then
		local tip = self.m_tTips.tips[math.random(#self.m_tTips.tips)]
		WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTips_SceneBattleLoading")):setText(tip)
	end
end

--@brief	根据icon返回地图背景图
--@param	mapIcon:地图icon
--@return	#1:地图背景图string
function SceneTeachBattleLoading:_getMapBgByIcon(mapIcon)
	WZLog("SceneTeachBattleLoading:_getMapBgByIcon")
	return RESOURCE_MAP_PATH..mapIcon:match("%w+").."_bg.png"
end

--@brief	根据icon返回地图标题图
--@param	mapIcon:地图icon
--@return	#1:地图标题图string
function SceneTeachBattleLoading:_getMapTitleByIcon(mapIcon)
	WZLog("SceneTeachBattleLoading:_getMapTitleByIcon")
	return RESOURCE_MAP_TITLE_PATH..mapIcon:match("%w+")..".png"
end

--@brief	更新currentPlayerId的玩家的百分比
--@param	percent:百分比
function SceneTeachBattleLoading:_updatePercent(percent)
	WZLog("SceneTeachBattleLoading:_updatePercent")
	local conSeats = WZUIContainer:luaTo(GetElement(self.m_root,string.format("conLeftSeatFor%d_SceneBattleLoading",1)))
	local conElement = GetElement(conSeats,string.format("conLeftPlayer%d_SceneBattleLoading",1))
	WZUIProgress:luaTo(GetElement(conElement,"progPlayerLoad_SceneBattleLoading")):setPercentage(percent)
end
-------------------------------------私有方法模块End----------------------------------------
