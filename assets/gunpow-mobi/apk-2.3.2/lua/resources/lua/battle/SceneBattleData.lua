--SceneBattleData.lua
--@brief	SceneBattle的数据模块
--@date		2013/12/31
--@author	Zjh
--@note		战斗界面

SceneBattle = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneBattle:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sMapId = "0"					--地图id
	self.m_bRunTurnShow = false
	self.m_nFrontLayerWidth = nil
	self.m_nFrontLayerHeight = nil
    self.m_tTextureCache = nil
    self.m_nMapEventIndex = 0
    self.m_nMapEventShow = 0
    self.m_bIsLostNet = nil
    self.m_bIsLostNetSingleMap = 0
    BattleMsgGameOver.m_bIsConnect = 0
    BattleScreenControl.m_bIsFirstScaleOk = nil
    self.m_count = 0
    self.m_bIsCreate = true
    self.m_nHeroBlinkTimes = 3 
    self.m_fogLayer = nil 
    self.m_midLayer = nil 
    self.m_bgLayer = nil 
    self.m_frontLayer = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneBattle:_unInit()
    WZLog("SceneBattle:_unInit")
	if self.m_root then
		self.m_root:disableSchedule()
	end
	self.m_loop = nil
	self.m_touch = nil
	if not g_TOWER_TAG then
		self:removeAll()
	end
	self.m_pointsLine = nil
	self.m_bRunTurnShow = false

	self.m_nFrontLayerWidth = nil
	self.m_nFrontLayerHeight = nil
	self.m_root = nil
    self.m_tTextureCache = nil
    self.m_nMapEventIndex = 0
    self.m_nMapEventShow = 0
    self.m_bIsLostNet = nil
    self.m_bIsLostNetSingleMap = 0

    self.m_count = 0
    self.m_bIsCreate = nil
    self.m_nHeroBlinkTimes = nil 
    self.m_fogLayer = nil 
    self.m_midLayer = nil 
    self.m_bgLayer = nil 
    self.m_frontLayer = nil 
end

--@brief 
function SceneBattle:removeAll()
	WBattleGlobal:getCurrent():cleanBigSkillAnim()
	WBattleGlobal:getCurrent():destroy()
	BattleMapManager:clear()
	MsgManager:clear()
	BattleShowHeroUse:removeHeroUse()
	BattleHeroUse:clear()
    BattleMsgGameOver.m_bIsConnect = 0
	BattleScreenControl.m_bIsFirstScaleOk = nil
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneBattle:createElement()
    --WZDataFile:getInstance():loadTexturePackFile("battle/hud/battle_hud.plist")
	local element = WZUISystem:getInstance():createElement("SceneBattle")
	assert(element, "SceneBattle create element failed!")
	self:_init()
	self.m_root = element
	return element
end

--@brief	设置地图id
--@note		id为字符串
function SceneBattle:setMapId(nMapId)
	self.m_sMapId = nMapId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
