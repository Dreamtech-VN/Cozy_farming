--SceneCommunityMain.lua
--@brief	SceneCommunityMain的UI模块
--@date		2015/04/20
--@author	zsq
--@note		公会场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityMain:onEnter(element)
	self.m_root = element
	WndChat:addChatWindowToCurScene()
	AdaptLanguage(self)
	CacheCenter:registerUpatePlayerInfoObserver(self)

    --鲜花榜协议
    Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")

end

function SceneCommunityMain:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_tTopHangle = tcell
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_ghz.png",SceneCommunityMain,SceneCommunityMain.onBuildClickBack,true,true,true,"SceneCommunityMain")
end

--@brief	
function SceneCommunityMain:onEnterTransitionDidFinish(element)
    ChangeChatChannel(Chat_Channel_Guild_Scene)

	--获取公会大厅信息
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	if SceneCommunityMain.jumpTo == "shop" or SceneCommunityMain.jumpTo == "totem" or SceneCommunityMain.jumpTo == "hall" then

	else
		SceneCommunityMain:createLoading()
	end
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
	self:AdaptResolution()

	self:_addTop()

	--先把建筑名字设置不可见
	for i=1,4 do
		GetElement(self.m_root, "img"..i.."_SceneCommunity", WZUIImage):setVisible(false)
	end

	self:showBtns()

	self:checkBossReward()
	self:initScene()
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_COMMUNITY)

	if WndGangsterInn.m_bShouldClose == true then
		WndGangsterInn.m_bShouldClose = false
		MsgBoxManager:showTipBox(LocalStrings.INN12)
	end

    --延时显示成就特效
    ShowDelayAchie()
end

--@brief	判断是否显示功能按钮
function SceneCommunityMain:showBtns()
	--判断是否显示公会战
    if CheckButtonShow(56) and GlobalMethod:crossServiceOpen() == 1 then
		GetElement(self.m_root,"btnList2_SceneCommunityMain",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnList5_SceneCommunityMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.26,-1.15))
	else
		GetElement(self.m_root,"btnList2_SceneCommunityMain",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnList5_SceneCommunityMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.18,-1.15))
	end
	--公会战红点
	if GlobalGame.g_bIsGuildWarHaveRedDot then
		GetElement(self.m_root,"redPoint2_SceneCommunityMain",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"redPoint2_SceneCommunityMain",WZUIImage):setVisible(false)
	end

	--判断是否显示公会副本
    if self:isShowCopy() then
		GetElement(self.m_root,"btnList5_SceneCommunityMain",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btnList5_SceneCommunityMain",WZUIButton):setVisible(false)
	end

	--判断是否显示设置代理人
	self:setBtn6Position()

	AdaptLanguage(self)
end

--@brief 判断公会boss奖励
function SceneCommunityMain:checkBossReward()
	
	-- SceneCommunityMain.m_tBossReward = {
	-- {itemId = 1,itemCnt = 1 },
	-- {itemId = 2,itemCnt = 1 },
	-- {itemId = 5,itemCnt = 1 },
	-- {itemId = 1,itemCnt = 1 },
	-- {itemId = 2,itemCnt = 1 },
	-- {itemId = 5,itemCnt = 1 },
	-- {itemId = 6,itemCnt = 1 },
	-- {itemId = 1,itemCnt = 1 },
	-- {itemId = 6,itemCnt = 1 }}
	
	if SceneCommunityMain.m_tBossReward and #SceneCommunityMain.m_tBossReward > 0 then
		GetElement(self.m_root,"conBossReward_SceneCommunityMain", WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conBossRewardBg_SceneCommunityMain", WZUIContainer):setVisible(true)
		self:setBossRewardStep()
	else
		GetElement(self.m_root,"conBossReward_SceneCommunityMain", WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conBossRewardBg_SceneCommunityMain", WZUIContainer):setVisible(false)
	end
end

function SceneCommunityMain:setBossRewardStep()
	self.m_tStepList = {}
    table.insert(self.m_tStepList,{self._boxSpineAction})
    table.insert(self.m_tStepList,{self._boxSpineDelay})

    table.insert(self.m_tStepList,{self._showItemAction})
    table.insert(self.m_tStepList,{self._waitForItemAction})
    table.insert(self.m_tStepList,{self._itemDelay})
    table.insert(self.m_tStepList,{self._showItemActionSec})
    table.insert(self.m_tStepList,{self._waitForItemSecAction})
    table.insert(self.m_tStepList,{self._actionAllDone})
    self.m_tTopHangle:setTopTouchEnable(false)
    -- self.m_root:enableSchedule("updateBossReward",0)
end

function SceneCommunityMain:updateBossReward(dt)
	if not SceneCommunityMain.m_tBossReward or #SceneCommunityMain.m_tBossReward == 0 then
		return
	end
	 --延迟
    if self.m_nDelayTime then
        self.m_nDelayTime = self.m_nDelayTime - dt
        if self.m_nDelayTime < 0 then
            self.m_nDelayTime = nil
        else
            return
        end
    end

    --步骤执行
    if #self.m_tStepList > 0 then
        local res = self.m_tStepList[1][1](self,self.m_tStepList[1][2],self.m_tStepList[1][3],self.m_tStepList[1][4])
        if res == true or res == nil then
            table.remove(self.m_tStepList,1)
        end
        return 
    end
end



--判断是否显示公会副本
function SceneCommunityMain:isShowCopy()
	--local guildLevel = tonumber(CacheCenter:getGuildInfo().guildLevel)
	--local open_level = 1
	--for k,v in pairs(GDatatab_guild_building) do
	--	if v.type == 5 then
	--		open_level = v.open_level
	--	end
	--end

	--return (CheckButtonShow(99) and (guildLevel >= open_level))
	return CheckButtonShow(99, false)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityMain:onExit(element)
	--足迹
    FootEffectManager:getInstance():destroy()
    
    --add by wuweidong
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","SceneCommunityMain")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","SceneCommunityMain")
	FigureSceneManager:getInstance():release()
	CacheCenter:unregisterUpatePlayerInfoObserver(self)

    --鲜花榜协议
    Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")

	if self.m_root ~= nil then
    	self.m_root:disableSchedule()
	end
	self:_unInit()
end

function SceneCommunityMain:initScene()
	WZLog("SceneCommunityMain:initScene")
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneCommunityMain"))
    ---[[
    self.m_tWinSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local scaleY = self.m_tWinSize.height/640
    local scaleX = self.m_tWinSize.width/960
    local realScale = scaleY/scaleX

    scene:setScaleX(realScale)
    if scaleX < scaleY then
        local diff = 960*scaleY-self.m_tWinSize.width
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960-diff,640))
        print("SceneCity:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 960*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960+diff,640))
        print("SceneCity:initScene TWO", scaleY, scaleX, diff)
    end
	scene:UpdateInsidePosition()
	local maxPos = scene:getMaxPosition()
	local minPos = scene:getMinPosition()
	local moveElement = scene:getMoveElement()
	moveElement:setPositionX((maxPos.x + minPos.x)/2)

    local playerLayer = scene:getPlayerLayer()
    --足迹
    FootEffectManager:setFootLayer(playerLayer,true)

    self.m_tSceneLayer = scene
    self.m_tPlayerLayer = playerLayer
    playerLayer:setDrawInfo(false)
    playerLayer:setStartMoveCallback("startMoveCallback")
    playerLayer:setEndMoveCallback("endMoveCallback")
    playerLayer:setNextMoveCellCallback("nextMoveCellCallback")

    FigureSceneManager:getInstance():setCurrentScene(self,Chat_Channel_Guild_Scene)
    FigureSceneManager:getInstance():setFigureLayer(self.m_tPlayerLayer)
    FigureSceneManager:getInstance():initFigure()

    self.m_root:enableSchedule("loop",0)
end

--@note     定时器回调
function SceneCommunityMain:loop(element, dt)
    if --[[g_testFigureScene and]] FigureSceneManager:getInstance().m_bCanUpdate then
        FigureSceneManager:getInstance():update()
    end
    self:updateBossReward(dt)
end

--@brief	点击场景
function SceneCommunityMain:onClickBg(element,event,x,y)
    FigureSceneManager:getInstance():onClickBg(element,event,x,y)
	if WndItemInfo then WndItemInfo:onCloseClick() end
end

--@brief	开始移动
function SceneCommunityMain:startMoveCallback(element,node,x,y)
    FigureSceneManager:getInstance():startMoveCallback(element,node,x,y)
end

--@brief	移动中
function SceneCommunityMain:nextMoveCellCallback(element,node,x,y,index)
    FigureSceneManager:getInstance():nextMoveCellCallback(element,node,x,y,index)
end

--@brief	结束移动
function SceneCommunityMain:endMoveCallback(element,node)
    FigureSceneManager:getInstance():endMoveCallback(element,node)
end

--@brief    协议成功返回
function SceneCommunityMain:getDataOk()
	local guildLevel = tonumber(CacheCenter:getGuildInfo().guildLevel)
	if self.m_root == nil then return end
    --商店等级
    local imgShop = GetElement(self.m_root, "img1_SceneCommunity", WZUIImage)
    if imgShop then
        self:createLVNote(imgShop, CacheCenter:getGuildInfo().storeLevel, 0.25)
    end
    --大厅等级
    local imgHall = WZUIImage:luaTo(GetElement(self.m_root, "img2_SceneCommunity", WZUIImage))
    self:createLVNote(imgHall, CacheCenter:getGuildInfo().guildLevel, 0.25)
    --图腾等级
    local imgTotem = WZUIImage:luaTo(GetElement(self.m_root, "img3_SceneCommunity", WZUIImage))
    self:createLVNote(imgTotem, CacheCenter:getGuildInfo().totemLevel, 0.25)

	--创建图腾图片
	if self.m_tImgTotem ~= nil then
		self.m_tImgTotem:removeFromParentAndCleanup(true)
		self.m_tImgTotem = nil
	end
	if self.m_tSpine ~= nil then
		self.m_tSpine:removeFromParentAndCleanup(true)
		self.m_tSpine = nil
	end
	if self.m_tImgTotem == nil then
    	local spine = WZUISpine:create()
    	spine:setTouchEnable(false)
    	spine:setFileJson("ui/guild_tuteng.json")
    	spine:setFileAtlas("ui/guild_tuteng.atlas")
    	spine:setAnimationName("effect")
    	spine:setUseOriginSize(true)
    	spine:setRelativePosition(GlobalMethod:ccp(0.504,0.62))
		spine:play("effect",true)
    	GetElement(self.m_root,"background",WZUIContainer):addChild(spine,0)
		self.m_tSpine = spine

  		self.m_tImgTotem = WZUIImage:create()
  		self.m_tImgTotem:setFile("ui/community/common_icon_gonghui"..CacheCenter:getGuildInfo().totemLevel..".png")
    	self.m_tImgTotem:setTouchEnable(false)
  		self.m_tImgTotem:setUseOriginSize(true)
  		self.m_tImgTotem:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
  		self.m_tImgTotem:setRelativePosition(GlobalMethod:ccp(0.505, 0.43))
		self.m_tImgTotem:setScale(0.66)
  		GetElement(self.m_root,"background",WZUIContainer):addChild(self.m_tImgTotem,0,668)

		--设置图腾一直上下浮动
    	local array = CCArray:create()
    	array:addObject(CCMoveBy:create(1.25,GlobalMethod:ccp(0,10)))
    	array:addObject(CCMoveBy:create(1.25,GlobalMethod:ccp(0,-10)))
    	local action =  CCRepeatForever:create(CCSequence:create(array))
    	self.m_tImgTotem:runAction(action)
	end

    --技能等级
    local imgSkill = WZUIImage:luaTo(GetElement(self.m_root, "img4_SceneCommunity", WZUIImage)) 
	if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
		self:createLVNote(imgSkill, CacheCenter:getGuildInfo().schoolLevel, 0)
	else
		self:createLVNote(imgSkill, CacheCenter:getGuildInfo().schoolLevel, 0.15)
	end
	imgHall:setVisible(true)
	imgTotem:setVisible(true)

	if guildLevel < 2 then
		imgShop:setVisible(false)
	else
		imgShop:setVisible(true)
	end

	if guildLevel < 3 then
		imgSkill:setVisible(false)
	else
		imgSkill:setVisible(true)
	end

	--提示新申请的红点
	--删除重复节点
	if imgHall:getChildByTag(668) then
		imgHall:removeChildByTag(668,true)
	end
    --提示
    if CacheCenter:getGuildInfo().position >= 2 and GlobalGame.g_tRedPointList.community then
    	local imgLv = WZUIImage:create()
    	imgLv:setFile("ui/common/common_icon_xiaodianzhui.png")
    	imgLv:setUseOriginSize(true)
    	imgLv:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    	imgLv:setRelativePosition(GlobalMethod:ccp(0.9, 0.9))
    	imgHall:addChild(imgLv,668,668)
	end

	--跳转
	if tonumber(guildLevel) >= 2 and self.jumpTo == "shop" then
		self.jumpTo = nil
		self:onBuildClickShop()
	elseif self.jumpTo == "totem" then
		self.jumpTo = nil
		self:onBuildClickTotem()
	elseif self.jumpTo == "hall" then
		self.jumpTo = nil
		if SceneMemberList.m_root == nil then
			local sceneMemberList =  SceneMemberList:createElement()
			WindowManager:addWindow(sceneMemberList,SceneMemberList)
		end
	end

	--会长形象
    self:_createPresident()
end

--@brief 	点击徽章形象回调
function SceneCommunityMain:onClickPresident(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tPresidentInfo = json.decode(CacheCenter:getGuildInfo().presidentInfo)

	WndCheckOther:show(tonumber(tPresidentInfo.id))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	公会图腾点击响应
function SceneCommunityMain:onBuildClickTotem(element)
	WZLog("SceneCommunityMain:onBuildClickTotem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local sceneCommunityTotem = SceneCommunityTotem:createElement()
	WindowManager:addWindow(sceneCommunityTotem,SceneCommunityTotem)
end

--@brief	公会大厅点击响应
function SceneCommunityMain:onBuildClickHall(element)
	WZLog("SceneCommunityMain:onBuildClickHall")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sceneMemberList =  SceneMemberList:createElement()
	WindowManager:addWindow(sceneMemberList,SceneMemberList)
end

--@brief	公会技能点击响应
function SceneCommunityMain:onBuildClickSkill(element)
	WZLog("SceneCommunityMain:onBuildClickSkill")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	local guildLevel
	if guildInfo == nil then
		guildLevel = SceneMemberList.m_nGuildLevel
	else
		guildLevel = guildInfo.guildLevel
	end
	if guildLevel == nil or guildLevel < 3 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO43,3)) 
	else
		local sceneCommunitySkill = SceneCommunitySkill:createElement()
		WindowManager:addWindow(sceneCommunitySkill,SceneCommunitySkill)
	end
end

--@brief	公会商店点击响应
function SceneCommunityMain:onBuildClickShop(element)
	WZLog("SceneCommunityMain:onBuildClickShop")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--MsgBoxManager:showTipBox(LocalStrings.WELFARE_COMPETE_TEXT1)
	--do return end

	local guildInfo = CacheCenter:getGuildInfo()
	local guildLevel
	if guildInfo == nil then
		guildLevel = SceneMemberList.m_nGuildLevel
	else
		guildLevel = guildInfo.guildLevel
	end
	if guildLevel == nil or guildLevel < 2 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO43,2)) 
	else
		--local sceneCommunityShop = SceneCommunityShop:createElement()
		--WindowManager:addWindow(sceneCommunityShop,SceneCommunityShop)
		WndStore:showStoreByType(2)
	end
end

--@brief	公会试炼点击响应
function SceneCommunityMain:onBuildClickTrial(element)
	WZLog("SceneCommunityMain:onBuildClickTrial")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief	主城传送点击响应
function SceneCommunityMain:onBuildClickBack(element)
	WZLog("SceneCommunityMain:onBuildClickBack")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	replaceScene(SceneCity:createElement())
end

--@brief	公会排行点击响应
function SceneCommunityMain:onBuildClick(element)
	WZLog("SceneCommunityMain:onBuildClick")
	--有两个音效，屏蔽一个
    --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneCommunity:openCommunityList()
end

--@brief	点击公会战绩排行
function SceneCommunityMain:onRankClick(element)
	WZLog("SceneCommunityMain:onRankClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wndCommunityRank = WndCommunityRank:createElement()
	WindowManager:addWindow(wndCommunityRank,WndCommunityRank)
end

--@brief	点击帮助
function SceneCommunityMain:onDesc(element)
	WZLog("SceneCommunityMain:onDesc")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CommunityExplain4)
end

--@brief	点击公会战
function SceneCommunityMain:onFightClick(element)
	WZLog("SceneCommunityMain:onFightClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CheckButtonOpen(56) ~= true then
		return
	end

	--周一到周六开放,周日不开放
	--if os.date("%w") == "0" then
	--	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO68) 
	--	return
	--end

	--2级开放
	--local open_level = 1
	--for k,v in pairs(GDatatab_guild_building) do
	--	if v.type == 4 then
	--		open_level = v.open_level 
	--	end
	--end
	--local guildLevel = tonumber(CacheCenter:getGuildInfo().guildLevel)
	--if guildLevel < open_level then
	--	MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO69,open_level)) 
	--	return
	--end

    --WndCommunityHall:showWnd()
    SceneCommunityWar:showInterface()
    SceneCommunityWar:setCallBackFunc(SceneCommunityMain, SceneCommunityMain.showInterface)

	--ProtocolProcessorSceneCommunity:send_GUILD_CreateWarRoom( )
	--ProtocolProcessorSceneCommunity:send_GUILD_QuickGame( )
end

--@brief	点击公会任务
function SceneCommunityMain:onTask(element)
	WZLog("SceneCommunityMain:onTask")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd =  WndCommunityTask:createElement()
	WindowManager:addWindow(wnd,WndCommunityTask)
end

--@brief	公会弹劾
function SceneCommunityMain:onImpeach(element)
	WZLog("SceneCommunityMain:onImpeach")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd =  WndImpeach:createElement()
	WindowManager:addWindow(wnd,WndImpeach)
end

--@brief	公会副本
function SceneCommunityMain:onCopy()
	WZLog("SceneCommunityMain:onCopy")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(99) ~= true then return end

	local guildLevel = tonumber(CacheCenter:getGuildInfo().guildLevel)
	local open_level = 1
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 5 then
			open_level = v.open_level
		end
	end

	if guildLevel < open_level then
		MsgBoxManager:showTipBox(string.format(LocalStrings.GUILD_SKILL_OPEN_TIP, tonumber(open_level)))
		return
	end

	SceneCommunityCopy:show()
end

--@brief	设置代理人
function SceneCommunityMain:onSetAgent()
	WZLog("SceneCommunityMain:onCopy")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCompeteAgentSetting:showWnd()
end

--@brief	设置代理人按钮显示
function SceneCommunityMain:setBtn6Position()
	WZLog("SceneCommunityMain:setBtn6Position", CacheCenter:getPlayerInfo().position)
	if self.m_root == nil then return end
	--显示设置代理人
	GetElement(self.m_root,"btnList6_SceneCommunityMain",WZUIButton):setVisible(false)
	-- if tonumber(CacheCenter:getPlayerInfo().position) == COMMUNITY_PRESIDENT then 
		--改为是会员就能进去
		GetElement(self.m_root,"btnList6_SceneCommunityMain",WZUIButton):setVisible(true)
	-- end 

	local positionX = 0.18
	--判断是否显示公会战
    if CheckButtonShow(56) and GlobalMethod:crossServiceOpen() == 1 then
		positionX = positionX + 0.08
	end

	--显示公会副本
	if self:isShowCopy() then
		positionX = positionX + 0.08
	end

	GetElement(self.m_root,"btnList6_SceneCommunityMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(positionX,-1.15))
end

--@brief	设置公会弹劾按钮显示
function SceneCommunityMain:setImpeachBtn()
	if self.m_root == nil then return end
	local positionX = 0.18
	--判断是否显示公会战
    if CheckButtonShow(56) then
		positionX = positionX + 0.08
	end

	--显示公会副本
	if self:isShowCopy() then
		positionX = positionX + 0.08
	end

	--显示设置代理人
	--if tonumber(CacheCenter:getPlayerInfo().position) == COMMUNITY_PRESIDENT then
		positionX = positionX + 0.08
	--end 

	GetElement(self.m_root,"btnList4_SceneCommunityMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(positionX,-1.15))

	if WndImpeach.offlineDays == 0 then
		GetElement(self.m_root,"btnList4_SceneCommunityMain",WZUIButton):setVisible(false)
	else
		GetElement(self.m_root,"btnList4_SceneCommunityMain",WZUIButton):setVisible(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------
--@brief	适配分辨率
function SceneCommunityMain:AdaptResolution()
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("SceneCommunityMain:AdaptResolution",directorSize.width,directorSize.height)
	--iphone4适配
	if directorSize.width == 960 and directorSize.height == 640 then
		--GetElement(self.m_root,"btnBossMap_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(130 + (1136 - 960)/2,370))
		--GetElement(self.m_root,"btnResearch_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(1036 - (1136 - 960)/2,388))
		--GetElement(self.m_root,"img1_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(193 + (1136 - 960)/2,217))
		--GetElement(self.m_root,"img4_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(931 - (1136 - 960)/2,215))
	end
	--iphone5适配
	if directorSize.width > 960 then
	end
	--ipad适配
	if directorSize.height == 768 then
		--GetElement(self.m_root,"btnBossMap_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(130 + (1136 - 960)/2,370))
		--GetElement(self.m_root,"btnResearch_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(1036 - (1136 - 960)/2,388))
		--GetElement(self.m_root,"img1_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(193 + (1136 - 960)/2,217))
		--GetElement(self.m_root,"img4_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(931 - (1136 - 960)/2,215))
	end
	if directorSize.width == 2048 and directorSize.height == 1536 then
		--GetElement(self.m_root,"btnBossMap_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(130 + (1136 - 960)/2,370))
		--GetElement(self.m_root,"btnResearch_SceneCityScene",WZUIButton):setPosition(GlobalMethod:ccp(1036 - (1136 - 960)/2,388))
		--GetElement(self.m_root,"img1_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(193 + (1136 - 960)/2,217))
		--GetElement(self.m_root,"img4_SceneCommunity",WZUIImage):setPosition(GlobalMethod:ccp(931 - (1136 - 960)/2,215))
	end
end

--@brief    创建添加LV等级节点
--@param    #1将节点添加到的父节点
--@param    #2等级
--@param    #3等级数字X锚点
function SceneCommunityMain:createLVNote(element, level, nAnchorPointX)
    -- body
    WZLog("********** SceneCommunityMain:createLVNote ****************",SceneCommunityMain.m_bRecruitChecked)
	--删除重复节点
	if element:getChildByTag(666) then
		element:removeChildByTag(666,true)
	end
    --等级值
    local atlasLevel = WZUILabelAtlasFont:create()
    atlasLevel:setCharMapFileName("ui/common_num/common_num_ghdj.png")
    atlasLevel:setStartChar(48)
    atlasLevel:setHeight(24)
    atlasLevel:setWidth(16)
    atlasLevel:setUseOriginSize(true)
    atlasLevel:setAnchorPoint(GlobalMethod:ccp(1, 0.5))
    atlasLevel:setRelativePosition(GlobalMethod:ccp(nAnchorPointX, 0.5))

    atlasLevel:setText(level)

    element:addChild(atlasLevel,666,666)

    --LV标记
    local imgLv = WZUIImage:create()
    imgLv:setFile("ui/common/common_icon_ghdj.png")
    imgLv:setUseOriginSize(true)
    imgLv:setAnchorPoint(GlobalMethod:ccp(1, 0.5))
    imgLv:setRelativePosition(GlobalMethod:ccp(0, 0.5))
    atlasLevel:addChild(imgLv)

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
    	ProjConfig.LANGUAGE == "es" then
    	atlasLevel:setRelativePosition(GlobalMethod:ccp(nAnchorPointX-0.1,0.5))
    elseif ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "tr" then
    	atlasLevel:setRelativePosition(GlobalMethod:ccp(nAnchorPointX-0.05,0.5))
    end
end


--@宝箱动画
function SceneCommunityMain:_boxSpineAction()
    WZLog("SceneCommunityMain:_boxSpineAction")
    GetElement(self.m_root,"spineBossReward_SceneCommunityMain",WZUISpine):play("open",false)
end

--@宝箱动画等待
function SceneCommunityMain:_boxSpineDelay()
    self.m_nDelayTime = 0.5
end

--@物品动画等待
function SceneCommunityMain:_itemDelay()
    self.m_nDelayTime = 0.5
end

--@brief 获取奖励动画
function SceneCommunityMain:_showItemAction()
    WZLog("SceneCommunityMain:_showItemAction")
    local x,y = GetElement(self.m_root,"conStartPos_SceneCommunityMain",WZUIContainer):getPosition()
    local startPos = BattleCommon:getPointTable(x,y)
    local x,y = GetElement(self.m_root,"conMidPos_SceneCommunityMain",WZUIContainer):getPosition()
    local targetPos = BattleCommon:getPointTable(x,y)
    self.m_nBossRewardItemCount = #SceneCommunityMain.m_tBossReward
    self.m_tBossRewardItem = {}
    local itemWid = 80
    
    local row = 1
    local posListX = {}
    while self.m_nBossRewardItemCount > 5 do
    	self.m_nBossRewardItemCount = self.m_nBossRewardItemCount - 5
    	table.insert(posListX,targetPos.x - math.floor(5 / 2) * itemWid  + ((5 - 1) % 2) * itemWid/2)
    end
    table.insert(posListX,targetPos.x - math.floor(self.m_nBossRewardItemCount / 2) * itemWid  + ((self.m_nBossRewardItemCount - 1) % 2) * itemWid/2)

    local itemCon = GetElement(self.m_root,"conBossReward_SceneCommunityMain",WZUIContainer)
    for i = 1, #SceneCommunityMain.m_tBossReward do
        if i > 5*row then
       		row = row + 1
       	end
       	local index = i - (row - 1)*5

        local tmpPos = GlobalMethod:ccp(posListX[row] + itemWid*(index-1),targetPos.y - row * itemWid)
        local item = self:_createCellGoodItem(SceneCommunityMain.m_tBossReward[i])
        itemCon:addChild(item)
        item:setPosition(GlobalMethod:ccp(startPos.x,startPos.y))
        item:runUIAction(self:_getItemAction(i,tmpPos))
        table.insert(self.m_tBossRewardItem,item)
    end
end

--@brief 获取物品动画
function SceneCommunityMain:_getItemAction(index,targetPos)
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)
    action:setFinishLuaFunction("_actionItemDone")
    action:setFinishLuaTable(self)

    local actionTime = 0.6
    local actionTime2 = 0.8

    if index > 1 then
        local delay = (index - 1) * 0.1
        local actionDelay = WZUIActionDelayTime:create()
        actionDelay:setDuration(delay)
        action:setChildAction(actionDelay)
    end


    local actionSpawn = WZUIActionSpawn:create()
    action:setChildAction(actionSpawn)

    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(targetPos.x,targetPos.y))
    actionMoveTo:setDuration(actionTime)

    local actionRotateTo = WZUIActionRotateTo:create()
    actionRotateTo:setDuration(actionTime2)
    actionRotateTo:setAngle(1440)

    local actionScale = WZUIActionScaleTo:create()
    actionScale:setDuration(actionTime2)
    actionScale:setScaleX(0.9)
    actionScale:setScaleY(0.9)

    actionSpawn:setChildAction(actionMoveTo)
    actionSpawn:setChildAction(actionRotateTo)
    actionSpawn:setChildAction(actionScale)

    return action
end

--@brief 物品动画结束
function SceneCommunityMain:_actionItemDone(element)
    self.m_nBossRewardItemCount = self.m_nBossRewardItemCount - 1
end

--@brief 等待物品动画结束
function SceneCommunityMain:_waitForItemAction()
    WZLog("SceneCommunityMain:_waitForItemAction")
    return self.m_nBossRewardItemCount <= 0
end

--@brief 获取奖励动画
function SceneCommunityMain:_showItemActionSec()
    WZLog("SceneCommunityMain:_showItemActionSec")
    local point = GetElement(self.m_root,"conEndPos_SceneCommunityMain",WZUIContainer):convertToWorldSpace(GlobalMethod:ccp(0,0))
  	point = GetElement(self.m_root,"conBossReward_SceneCommunityMain",WZUIContainer):convertToNodeSpace(point)
    local targetPos = point
    self.m_nBossRewardItemSecCount = #self.m_tBossRewardItem

    for i = 1, #self.m_tBossRewardItem do
        local item = self.m_tBossRewardItem[i]
        item:runUIAction(self:_getItemActionSec(i,targetPos))
    end
    self.m_tBossRewardItem = nil
end

--@brief 获取物品动画
function SceneCommunityMain:_getItemActionSec(index,targetPos)
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)
    action:setFinishLuaFunction("_actionItemSecDone")
    action:setFinishLuaTable(self)

    local actionTime = 0.6
    local actionTime2 = 0.8

    if index > 1 then
        local delay = (index - 1) * 0.1
        local actionDelay = WZUIActionDelayTime:create()
        actionDelay:setDuration(delay)
        action:setChildAction(actionDelay)
    end


    local actionSpawn = WZUIActionSpawn:create()
    action:setChildAction(actionSpawn)

    local actionMoveTo = WZUIActionMoveToPosition:create()
    actionMoveTo:setPosition(GlobalMethod:ccp(targetPos.x,targetPos.y))
    actionMoveTo:setDuration(actionTime)

    local actionScale = WZUIActionScaleTo:create()
    actionScale:setDuration(actionTime2)
    actionScale:setScaleX(0.1)
    actionScale:setScaleY(0.1)

    actionSpawn:setChildAction(actionMoveTo)
    actionSpawn:setChildAction(actionScale)

    return action
end

--@brief 物品动画结束
function SceneCommunityMain:_actionItemSecDone(element)
    self.m_nBossRewardItemSecCount = self.m_nBossRewardItemSecCount - 1
    if element and element:getParent() then
    	element:removeFromParentAndCleanup(true)
    end
end

--@brief 等待物品动画结束
function SceneCommunityMain:_waitForItemSecAction()
    WZLog("SceneCommunityMain:_waitForItemSecAction")
    return self.m_nBossRewardItemSecCount <= 0
end

--@brief    创建一个物品格子
--@param    nIndex，序号
--@param    nItemId，物品id
--@param    nCount，物品数量
function SceneCommunityMain:_createCellGoodItem(reward)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setTag(nIndex-1)
    eItem:setScale(0)
    --tItem:setFromTag(nIndex-1)
    local tData = {
        id = reward.itemId,
        lastNum = reward.itemCnt,
        lastTime = reward.itemCnt,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(reward.itemId)
    }
    tItem:setCellGoodItem(tData, 4)

    return eItem, tItem
end

--@brief 物品动画结束
function SceneCommunityMain:_actionAllDone(element)
	SceneCommunityMain.m_tBossReward = nil
	GetElement(self.m_root,"conBossReward_SceneCommunityMain", WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conBossRewardBg_SceneCommunityMain", WZUIContainer):setVisible(false)
	self.m_tTopHangle:setTopTouchEnable(true)
end

local function nodeHide(element)
	-- body
	element:setVisible(false)
end

local function showNode(element)
	-- body
	element:setVisible(true)
end

--@brief 	创建徽章形象
function SceneCommunityMain:_createPresident()
	-- body
	local btnPresident = GetElement(self.m_root, "btnPresident_SceneCommunityScene", WZUIButton)
	WZLog("SceneCommunityMain:_createPresident", CacheCenter:getGuildInfo().presidentInfo)
	if CacheCenter:getGuildInfo() == nil or CacheCenter:getGuildInfo().presidentInfo == nil then return end 

	local tPresidentInfo = json.decode(CacheCenter:getGuildInfo().presidentInfo)
	local nSex = tonumber(tPresidentInfo.sex)
	local tEquip = {}
    table.insert(tEquip, tonumber(tPresidentInfo.headId))
    table.insert(tEquip, tonumber(tPresidentInfo.faceId))
    table.insert(tEquip, tonumber(tPresidentInfo.bodyId))
    table.insert(tEquip, tonumber(tPresidentInfo.wingId))

	if btnPresident then
		btnPresident:removeAllChildrenWithCleanup(true)
		--底座
        local imgDizuo = WZUIImage:create()
        imgDizuo:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        imgDizuo:setRelativePosition(GlobalMethod:ccp(0.5,0))
        imgDizuo:setUseOriginSize(true)
        imgDizuo:setFile("ui/community/building/community_pic_presidentdown.png")
        imgDizuo:setTouchEnable(false)
        btnPresident:addChild(imgDizuo)
        --雕像
		conPlayer = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tonumber(tPresidentInfo.headcolour), tonumber(tPresidentInfo.bodycolour))
		conPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0.09))
        btnPresident:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(0.6)

        --名字
        local txtName = WZUILabelTTF:create()
        txtName:setRelativePosition(GlobalMethod:ccp(0.5, 0.95))
        txtName:setText(tPresidentInfo.name)
        txtName:setFontSize(20)
        txtName:setEnableStroke(true)
        txtName:setStrokeSize(4)
        txtName:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        txtName:setColor(GlobalMethod:ccc3(255,236,193))
        btnPresident:addChild(txtName)
        --职位
        local txtPosition = WZUILabelTTF:create()
        txtPosition:setRelativePosition(GlobalMethod:ccp(0.5, 1.08))
        txtPosition:setText(LocalStrings.PRESIDENT)
        txtPosition:setFontSize(22)
        txtPosition:setEnableStroke(true)
        txtPosition:setStrokeSize(4)
        txtPosition:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        txtPosition:setColor(GlobalMethod:ccc3(229,105,22))
        btnPresident:addChild(txtPosition)

        local desc = CacheCenter:getGuildInfo().desc
        local nInputTextLen = WndBag:_checkInputTxtLen(desc)

        local conTalk = WZUIContainer:create()
        conTalk:setUseAbsSize(true)
        conTalk:setRelativePosition(GlobalMethod:ccp(0.5, 1.3))
        conTalk:setAbsContentSize(GlobalMethod:CCSize(230, 120))
        -- if nInputTextLen <= 24 * 2 then
        -- 	conTalk:setAbsContentSize(GlobalMethod:CCSize(200, 100))
        -- else
        -- 	conTalk:setAbsContentSize(GlobalMethod:CCSize(300, 120))
        -- end
        conTalk:setTouchEnable(false)
        btnPresident:addChild(conTalk)

        local img9 = WZUI9Image:create()
        img9:setFile("ui/common/common_icon_duihuakuang.png")
        img9:setTouchEnable(false)
        conTalk:addChild(img9)

        local txtDesc = WZUILabelTTF:create()
        txtDesc:setText(desc)
        txtDesc:setColor(GlobalMethod:ccc3(127,76,26))
        txtDesc:setFontSize(20)
        txtDesc:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
        txtDesc:setAlignment(kCCTextAlignmentLeft)
        txtDesc:setDimensions(GlobalMethod:CCSize(210,0))
        txtDesc:setRelativePosition(GlobalMethod:ccp(0.05, 0.58))
        txtDesc:setTouchEnable(false)
        -- if nInputTextLen <= 24 * 2 then
        -- 	txtDesc:setDimensions(GlobalMethod:CCSize(180,0))
        -- else
        -- 	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05, 0.55))
        -- 	txtDesc:setDimensions(GlobalMethod:CCSize(280,0))
        -- end
        
        conTalk:addChild(txtDesc)

        local arrayAni = CCArray:create()
        local nDelayTime = math.floor(math.random(3,12))
    	local delayAni1 = CCDelayTime:create(nDelayTime)
    	local delayAni2 = CCDelayTime:create(5)
    	nDelayTime = math.floor(math.random(3,12))
    	local delayAni3 = CCDelayTime:create(nDelayTime)
    	local functionAni1 = CCCallFuncN:create(nodeHide)
    	local functionAni2 = CCCallFuncN:create(showNode)

    	arrayAni:addObject(delayAni2)
    	arrayAni:addObject(functionAni1)
    	arrayAni:addObject(delayAni3)
    	arrayAni:addObject(functionAni2)
    	local sequence = CCSequence:create(arrayAni)
    	local repeatAni = CCRepeatForever:create(sequence)
    	conTalk:runAction(repeatAni)
	end
end



--------------------------------------语言适配Begin-----------------------------------------
function SceneCommunityMain:_adaptLanguage_tr(  )
	for i = 1, 6 do
		GetElement(self.m_root,"imgBtnList"..i.."_SceneCommunityMain",WZUIImage):setScale(0.7)
	end
end

---------------------------------------语言适配End------------------------------------------