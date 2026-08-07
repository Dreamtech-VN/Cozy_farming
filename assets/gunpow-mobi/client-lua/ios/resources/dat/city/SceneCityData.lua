--SceneCityData.lua
--@brief	SceneCity的数据模块
--@date		2015/2/9
--@author	莫剑峰
--@note		主城界面

SceneCity = {
	--请不要在这里定义变量
    --m_bIfActivitiesClicked = false, --小金人是否被点过
    bOnlineReward = nil,
    m_ncheckPushId = nil,
    m_currentFullScreenCount = 0,

}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCity:_init(isNoRelease, isWndCopyTop)
	self.m_root = nil	 	  			--场景根节点
	self.m_nFrontLayerWidth = nil
	self.m_nFrontLayerHeight = nil
    self.m_tTextureCache = nil
    self.m_nDeltaTime = 0
    self.m_nOldScale = 0
    self.m_tOldPos = {x=0,y=0}
    self.m_tPrePoints = {}
    self.m_bNeedUpdateBg = true
    self.m_tTouchBeganPos = nil
    self.m_tBgMoveBeganPos = nil
    self.m_tBgAdornMoveBeganPos = nil
    self.m_tBuildMoveBeganPos = nil
    self.m_tFigureMoveBeganPos = nil
    self.m_nTouchMode = 0
    self.m_tTouchPos = nil
    self.m_nTouchTurn = nil
    self.m_scheduleId = -1
    self.m_count = 0
    self.m_bOnEnter = nil
    self.m_bIsMoveBg = nil
    self.m_tFigure = nil
    self.m_tPosForFigureLayer = nil
    self.m_nTouchState = 0
    self.m_nTouchBeganTime = -1
    self.m_nTouchEndTime = -1
    self.m_bIsClickOther = nil
    self.m_nClickBtnTag = -1

    self.m_tBtnsInfo = nil
    self.m_nLoadingBoxId = nil          --加载框消息id
    self.m_tHallDialogLuaObj = nil      --游戏大厅对话框绑定的Lua对象
    self.m_tActivitiesDialogLuaObj = nil--小金人对话框绑定的Lua对象
    self.m_bTeachFisth = false          --第一次进小岛开始教学
    self.m_tWeibo = nil                 --微博列表
    self.m_count = 0                    --帧率计数变量
    self.m_scheduleId = -1              --定时器id
    --self.m_scheduleLoopId = -1
    self.m_tPlayerInfo = nil            --玩家信息表
    self.m_bIsadaptLanguage_pt = false  --葡语包适配
    self.m_bIsCanClick = nil
    self.m_tWndBottomBarObj = nil
    self.m_bIsUpdateBoat = nil
    self.m_bIsUpdateHudie = nil
    self.m_bIsUpdatefeiting = nil
    --self.m_currentFullScreenCount = 0
    self.m_nTime = 0
    self.m_nStartTime = nil
    self.m_bIsTipsAppear1 = nil
    self.m_bIsTipsAppear2 = nil
    self.m_tButtonTipsAnim1 = nil
    self.m_tButtonTipsAnim2 = nil
    self.m_tButtonTipsDialog1 = nil
    self.m_tButtonTipsDialog2 = nil
    self.m_bFromChurch = false  --是否从婚礼场景跳转过来
    self.m_nTeachStep = nil
    self.m_bIsNoTeach = nil
    --获取g_bHaveNewDesi的值
    if not g_bHaveRedPointForAchieEntry then
        g_bHaveRedPointForAchieEntry = g_bHaveNewDesi
    end
    self.tabCur = nil
    self.tabStartHero = nil
    self.tabEndHero = nil
    self.tabStartRank = nil
    self.tabEndRank = nil
    self.startTime32OneData = nil
    self.startTime32OneTime = nil
    self.endTime32OneTime = nil
    self.startTime32TwoTime = nil
    self.endTime32TwoTime = nil
    self.startTime32ThreeTime = nil
    self.endTime32ThreeTime = nil
    self.startTime16OneData = nil
    self.startTime16OneTime = nil
    self.endTime16OneTime = nil
    self.startTime16TwoTime = nil
    self.endTime16TwoTime = nil
    self.startTime16ThreeTime = nil
    self.endTime16ThreeTime = nil
    self.startTime8OneData = nil
    self.startTime8OneTime = nil
    self.endTime8OneTime = nil
    self.startTime8TwoTime = nil
    self.endTime8TwoTime = nil
    self.startTime8ThreeTime = nil
    self.endTime8ThreeTime = nil
    self.startTime4OneData = nil
    self.startTime4OneTime = nil
    self.endTime4OneTime = nil
    self.startTime4TwoTime = nil
    self.endTime4TwoTime = nil
    self.startTime4ThreeTime = nil
    self.endTime4ThreeTime = nil
    self.startTimeFOneData = nil
    self.startTimeFOneTime = nil
    self.endTimeFOneTime = nil
    self.startTimeFTwoTime = nil
    self.endTimeFTwoTime = nil
    self.startTimeFThreeTime = nil
    self.endTimeFThreeTime = nil
    self.m_heroMatchType = nil
    self.m_tWndBottomBar = nil
    self.m_bIsNoRelease = isNoRelease
    self.m_bIsWndCopyTop = isWndCopyTop

    self.m_secondScheduleId = -1              --定时器id
    self.m_bIsHudiePlay = nil
    self.m_bIsLevelUp = nil
    self.m_bIsPlayMovie = nil
    self.m_nRewardLingthTime1 = -1
    self.m_nRewardLingthTime2 = -1
    self.m_nCurLingthType = nil

    self.m_tButtonTipsAnim3 = nil
    self.m_tButtonTipsDialog3 = nil
    self.m_bIsTipsAppear3 = nil
    self.m_nStartTime2 = nil
    self.m_nTime2 = 0
    self.m_tSceneLayer = nil
    self.m_nCheckOpenTreeTime = 0
    self.m_bIsCreate = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCity:_unInit()
    WZLog("SceneCity:_unInit")
	if self.m_root then
		self.m_root:disableSchedule()
	end
    self.m_root = nil
    --self.m_currentFullScreenCount = 0
	self.m_nFrontLayerWidth = nil
	self.m_nFrontLayerHeight = nil
    self.m_tTextureCache = nil
    self.m_nDeltaTime = 0
    self.m_nOldScale = 0
    self.m_tOldPos = {x=0,y=0}
    self.m_tPrePoints = {}
    self.m_bNeedUpdateBg = true
    self.m_tTouchBeganPos = nil
    self.m_tBgMoveBeganPos = nil
    self.m_tBgAdornMoveBeganPos = nil
    self.m_tBuildMoveBeganPos = nil
    self.m_tFigureMoveBeganPos = nil
    self.m_nTouchMode = 0
    self.m_tTouchPos = nil
    self.m_nTouchTurn = nil
    self.m_scheduleId = -1
    self.m_count = 0
    self.m_bOnEnter = nil
    self.m_bIsMoveBg = nil
    self.m_tFigure = nil
    self.m_tPosForFigureLayer = nil
    self.m_nTouchState = 0
    self.m_nTouchBeganTime = -1
    self.m_nTouchEndTime = -1
    self.m_bIsClickOther = nil
    self.m_nClickBtnTag = -1

    self.m_tBtnsInfo = nil
    self.m_nLoadingBoxId = nil
    self.m_tHallDialogLuaObj = nil  
    self.m_tActivitiesDialogLuaObj = nil
    self.m_bTeachFisth = nil            --第一次进小岛开始教学
    self.m_tWeibo = nil                 --微博列表
    self.m_tPlayerInfo = nil 
    self.m_bIsadaptLanguage_pt = nil
    self.m_bIsCanClick = nil
    self.m_tWndBottomBarObj = nil
    self.m_bIsUpdateBoat = nil
    self.m_bIsUpdateHudie = nil
    self.m_bIsUpdatefeiting = nil
    self.m_nTime = 0
    self.m_nStartTime = nil
    self.m_bIsTipsAppear1 = nil
    self.m_bIsTipsAppear2 = nil
    self.m_tButtonTipsAnim1 = nil
    self.m_tButtonTipsAnim2 = nil
    self.m_tButtonTipsDialog1 = nil
    self.m_tButtonTipsDialog2 = nil
    self.m_nTeachStep = nil
    self.m_bFromChurch = nil
    self.m_bIsNoTeach = nil
    self.tabCur = nil
    self.tabStartHero = nil
    self.tabEndHero = nil
    self.tabStartRank = nil
    self.tabEndRank = nil
        self.startTime32OneData = nil
    self.startTime32OneTime = nil
    self.endTime32OneTime = nil
    self.startTime32TwoTime = nil
    self.endTime32TwoTime = nil
    self.startTime32ThreeTime = nil
    self.endTime32ThreeTime = nil
    self.startTime16OneData = nil
    self.startTime16OneTime = nil
    self.endTime16OneTime = nil
    self.startTime16TwoTime = nil
    self.endTime16TwoTime = nil
    self.startTime16ThreeTime = nil
    self.endTime16ThreeTime = nil
    self.startTime8OneData = nil
    self.startTime8OneTime = nil
    self.endTime8OneTime = nil
    self.startTime8TwoTime = nil
    self.endTime8TwoTime = nil
    self.startTime8ThreeTime = nil
    self.endTime8ThreeTime = nil
    self.startTime4OneData = nil
    self.startTime4OneTime = nil
    self.endTime4OneTime = nil
    self.startTime4TwoTime = nil
    self.endTime4TwoTime = nil
    self.startTime4ThreeTime = nil
    self.endTime4ThreeTime = nil
    self.startTimeFOneData = nil
    self.startTimeFOneTime = nil
    self.endTimeFOneTime = nil
    self.startTimeFTwoTime = nil
    self.endTimeFTwoTime = nil
    self.startTimeFThreeTime = nil
    self.endTimeFThreeTime = nil
    self.m_heroMatchType = nil
    self.m_tWndBottomBar = nil
    self.m_bIsNoRelease = nil
    self.m_bIsWndCopyTop = nil
    self.m_secondScheduleId = -1              --定时器id
    self.m_bIsHudiePlay = nil
    self.m_bIsLevelUp = nil
    self.m_bIsPlayMovie = nil
    self.m_nRewardLingthTime1 = -1
    self.m_nRewardLingthTime2 = -1
    self.m_nCurLingthType = nil
    self.m_tButtonTipsAnim3 = nil
    self.m_tButtonTipsDialog3 = nil
    self.m_bIsTipsAppear3 = nil
    self.m_nStartTime2 = nil
    self.m_nTime2 = 0
    self.m_tSceneLayer = nil
    self.m_nCheckOpenTreeTime = 0
    self.m_bIsCreate = nil
    WZLog("SceneCity:_unInitOK")
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCity:createElement(isNoRelease, isWndCopyTop, isLevelUp)
    WZLog("SceneCity:createElement1")
    --ios 主动加载资源
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if WZFileUtil:isFileExist("pack/city_new_ui/pack_city_new_ui_0.plist") and platForm == 1 then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/city_new_ui/pack_city_new_ui_0.plist")
    end
    if WZFileUtil:isFileExist("pack/city/pack_city_0.plist") and platForm == 1 then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/city/pack_city_0.plist")
    end
    WZLog("SceneCity:createElement2")
	local element = WZUISystem:getInstance():createElement("SceneCity")
	assert(element, "SceneCity create element failed!")
	self:_init(isNoRelease, isWndCopyTop)
	self.m_root = element
    self.m_bIsLevelUp = isLevelUp
	
    self:setScenePos()
	return element
end

function SceneCity:setOnlineRewardStart(bReward)
    self.bOnlineReward = bReward
end

--@brief    接收人物缓存信息
function SceneCity:getPlayerInfo()
    local  bIsHasInfo = CacheCenter:hasPlayerInfo()
    if bIsHasInfo == true then 
        self:setPlayerInfo(CacheCenter:getPlayerInfo())
    end
end

--@brief    更新人物缓存信息
function SceneCity:updatePlayerInfoData()
    WZLog("SceneCity:updatePlayerInfoData")
    self:setPlayerInfo(CacheCenter:getPlayerInfo())
end

--@brief    设置人物缓存信息
function SceneCity:setPlayerInfo(data)
    self.m_tPlayerInfo = data
    if data and data.zsLevel == 1 and data.level <2 then
        GlobalGame.g_tPlayerInfo.nLevel = data.level+99
    end
end

--@brief    处理协议返回的错误
--@param    sMessage:错误消息
function SceneCity:errorProcess(sMessage)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
    MsgBoxManager:showTipBox(sMessage)   
end

SceneIsland = {}
function SceneIsland:createElement()
    return SceneCity:createElement()
end

function SceneCity:receiveLeagueInvite()
    WZLog("SceneCity:receiveLeagueInvite")
    SceneLeagueMain:showInterface(2)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
