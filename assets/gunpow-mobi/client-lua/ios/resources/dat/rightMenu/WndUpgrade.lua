--WndUpgrade.lua
--@brief	WndUpgrade的UI模块
--@date		2014/01/10
--@author	xiaoyu_wu
--@note		人物升级模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUpgrade:onEnter(element)
    WZLog("WndUpgrade:onEnter")
    GlobalGame.m_bIsUpgrade = nil
	self.m_root = element
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
	--self:setEquipData(CacheCenter:getEquipmentList())
	self:_updatePlayerPro()
	self.dtTime = 0
	self.m_root:enableSchedule("onSchedule",0.25)
	SoundManager:playEffectSound(SoundDefine.E_MUSIC_ISUPGRADE)
	--self.m_root:enableSchedule("onSchedule")

    --非审核,形象改变
    if CacheCenter:getGameParam().gameStatus == "1" then
        GetElement(self.m_root, "imgInstructor_WndUpgrade", WZUIImage):setFile("ui/combat/common_pic_meinv4.png")
    end
	--多语言版本界面适配
    AdaptLanguage(self)
end

function WndUpgrade:onSchedule(element, dt)
	WZLog(" WndUpgrade:onSchedule")
	self.dtTime = self.dtTime + 0.95
	if self.dtTime > 0.75 then
		WZLog(" WndUpgrade:onSchedule _scaleValueImg")
		local spine = GetElement(self.m_root, "spine1_WndUpgrade", WZUISpine)
		spine:setFileAtlas("ui/ui_lvlup_effect_01.atlas")
		spine:setFileJson("ui/ui_lvlup_effect_01.json")
		spine:play("shengji", false)
		spine:setVisible(true)
		spine:enableSchedule("_onUpEnd")
		GetElement(self.m_root,"labelLevelNum_WndUpgrade",WZUILabelAtlasFont):setVisible(true)
		local actionArray = CCArray:create()
     	actionArray:addObject(CCScaleTo:create(0.15,1,1))
     	actionArray:addObject(CCCallFuncN:create(_scaleValueImg))
     	local repH = CCSequence:create(actionArray)
     	local curTenImg = GetElement(self.m_root,"labelLevelNum_WndUpgrade",WZUILabelAtlasFont)
     	--local curTenImg =  GetElement(WndUpgrade.m_root,"textValue"..WndUpgrade.n_actionTag.."_WndUpgrade",WZUIFreeTextBox)
	 	curTenImg:runAction(repH)
		element:disableSchedule()
	end
end

--@brief	加载动画_scaleValueImg
function WndUpgrade:onEnterTransitionDidFinish(element)
	WZLog("WndUpgrade:onEnterTransitionDidFinish:::")
	--@brief onEnter函数执行完成回调
    WindowManagerAni:createAction(self.m_root,true)

    DelayCallFunction(function() upPlayerFightingAni(GlobalGame.g_tInfo.nFighting) end, self, 0.25)
    
end

--@brief	动画加载完成回调
function WndUpgrade:actionCallback(element,data)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUpgrade:onExit(element)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
    ProtocolProcessorWndUpgrade:unregAll()
    element:disableSchedule()
    self.m_bIsExit = true

    WZLog("WndUpgrade:onExit zero", self.m_bIsReplace)
    if SceneRoom ~= nil and self.bShowInfo ~= 2 then
        SceneRoom:send_ROOM_UpdateRoom()
    end
    if SceneBossRoom ~= nil and self.bShowInfo ~= 2 then
        SceneBossRoom:updateRoom()
    end
    if SceneWorldTeamBossRoom ~= nil and self.bShowInfo ~= 2 then
    	SceneWorldTeamBossRoom:updateRoom()
    end

    local isTalk = false
    if GDatatab_story_talk and WndTeachTalk:IsNoExist() then
        for i ,v in pairs (GDatatab_story_talk) do
            if type(v.triggerWay) == "table" then
                --WZLog("WndUpgrade:onExit one",i,v.triggerWay[1][1],v.triggerWay[1][2],CacheCenter:getPlayerInfo().level)
                if v.triggerWay[1][1] == TRIGGER_LEVEL_UP and v.triggerWay[1][2] == CacheCenter:getPlayerInfo().level then
                    --WZLog("WndUpgrade:onExit two")
                    CreateStoryTalkGroup(v.storyId, false, nil, nil, nil, nil, self.m_bIsReplace, true, self.m_nButtonId)
                    isTalk = true
                    break
                end
            end
        end
    end

    if isTalk == false and self.m_bIsReplace then
    	GlobalGame.m_nTrailerId = self.m_nButtonId
        SceneRoom:exitRoom()
        if SceneCity.m_root == nil then
            replaceScene(SceneCity:createElement())
        else
            WZLog("WndUpgrade:onExit four")
            SceneCity.m_bIsNoRelease = true
            replaceScene(SceneCity:createElement(true))
        end
    elseif isTalk == false and self.m_nButtonId then
    	WZLog("WndUpgrade:onExit three")
    	addTrailerAnim(self.m_nButtonId)
    end

    if isTalk == false and self.m_bIsReplace ~= true and self.m_nButtonId == nil then
    	WZLog("WndUpgrade:onExit five")
        self:teach()
    end

    self:_unInit()
end

function WndUpgrade:teach(isTrailerAnim)
	local isEndTeach32, teachStep32 = TeachGroup1:isTeachFinish(32)
    local isTeach = SceneCity:teach(true, isTrailerAnim)
    WZLog("WndUpgrade:teach three", tostring(isEndTeach32), tostring(teachStep32), tostring(isTeach), tostring(isTeach ~= false))
    if (isEndTeach32 ~= true and teachStep32 == 0 or isEndTeach32 == true) and isTeach ~= false then
        WZLog("WndUpgrade:teach four", tostring(WndTask.m_root), tostring(WndRewardShow.m_root))
        if WndRewardShow.m_root then
            WndRewardShow.m_bIsTeach = true
            WindowManager:removeWindow(WndRewardShow.m_root , WndRewardShow , true)
        end

        if WndTask.m_root then
            WndTask.m_bIsTeach = true
            WindowManager:removeWindow(WndTask.m_root , WndTask , true)
        end
    end

    WZLog("WndUpgrade:teach five", tostring(WndTask.m_root and WndTask.m_tTaskList and WndTask.m_tTaskList.tMainTask and WndTask.m_tTaskList.tMainTask[1].nId), tostring(WndTask.m_root and WndTask.m_tTaskList and WndTask.m_tTaskList.tMainTask and WndTask.m_tTaskList.tMainTask[1].nTaskStatus))
    if WndDressUp.m_root and WndTask.m_root and WndTask.m_tTaskList and WndTask.m_tTaskList.tMainTask and WndTask.m_tTaskList.tMainTask[1].nId == TeachGroup1.TASK_ID_10 and WndTask.m_tTaskList.tMainTask[1].nTaskStatus == 0 then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {32,5,WndDressUp.m_root})
    end

end

function WndUpgrade:showInfo(isSend)
	if WndRewardShow and WndRewardShow.m_root ~= nil then
		WndRewardShow:onClose()
	end
	if self.m_root == nil then
		WZLog("WndUpgrade:showInfo one")
		local level = CacheCenter:getPlayerInfo().level
		local tab = GDatatab_Trailer_info
		for k,v in pairs(tab) do
			if v.level == level then
				if v.jump == 1 then
					GlobalGame.m_bIsUpgrade = true
					WZLog("WndUpgrade:showInfo two")
					SceneRoom:exitRoom(isSend)
					if SceneCity.m_root == nil then
            			replaceScene(SceneCity:createElement(nil, nil, true), true)
        			else
            			GlobalGame.m_bIsLevelUp = true
            			SceneCity.m_bIsNoRelease = true
            			replaceScene(SceneCity:createElement(true, nil, true), true)
        			end
				end
				break
			end
		end
		local upgrade = WndUpgrade:createElement()
		WindowManager:addWindow(upgrade, WndUpgrade)
	end
end

--@brief	获得当前升级状态
--@return	state:当前功能状态： 1.新功能预告，2.新功能开启， 3.已达最大限度
--@return	imgPath:当前功能的显示图片
function WndUpgrade:getUpgradeState()
	local level = CacheCenter:getPlayerInfo().level
	local tab = GDatatab_Trailer_info
	local state = 3
	local tempTab = {}
	for k,v in pairs(tab) do
		table.insert(tempTab,v)
	end
	local function SortLevel(a ,b)
		return a.level < b.level
	end
	table.sort(tempTab, SortLevel)
	for k,v in pairs(tempTab) do
		WZLog("SSSS:",level, v.level)
		if level == v.level then
			state = 2
			self.t_levelInfo.imgPath = "ui/"..v.icon
			self.t_levelInfo.desc = v.test
			self.bShowInfo = 1
			-- if v.jump == 1 then
			-- 	self.bShowInfo = 1
			-- end
			self.m_nButtonId = {buttonId=v.buttonid, icon="ui/"..v.icon}
			break
		elseif level < v.level then
			state = 1
			self.t_levelInfo.imgPath = "ui/"..v.icon
			self.t_levelInfo.desc = v.test
			self.t_levelInfo.levelGap = v.level - level
			self.t_levelInfo.level = v.level
			break
		end
	end
	return state
end


--@brief	设置升级界面的显示
--@param	state:当前功能状态
--@return	imgPath:当前功能的显示图片
function WndUpgrade:setUpgradeUi(state)
	if state == 1 then  --未开启
		GetElement(self.m_root,"imgHasNew_WndUpgrade",WZUIImage):setFile("ui/upgrade/common_icon_xgnyg.png")
		GetElement(self.m_root,"imgNewIcon_WndUpgrade",WZUIImage):setFile(self.t_levelInfo.imgPath)
		GetElement(self.m_root,"btnNew_WndUpgrade",WZUIButton):setTouchEnable(true)
		local txtLv = GetElement(self.m_root,"txtLvOpen_WndUpgrade",WZUILabelTTF)
		txtLv:setVisible(true)
		txtLv:setText(string.format(LocalStrings.UPGRADE_LEVEL_UNREACHED,self.t_levelInfo.level))
	elseif state == 2 then  --开启
		GetElement(self.m_root,"imgHasNew_WndUpgrade",WZUIImage):setFile("ui/upgrade/common_icon_xgngn.png")
		GetElement(self.m_root,"imgNewIcon_WndUpgrade",WZUIImage):setFile(self.t_levelInfo.imgPath)
		GetElement(self.m_root,"imgNewIcon2_WndUpgrade",WZUIImage):setFile(self.t_levelInfo.imgPath)
		GetElement(self.m_root,"txtDesc_WndUpgrade",WZUILabelTTF):setText(self.t_levelInfo.desc)
	elseif state == 3 then	--等级高的飞起
		local num = math.random(4)
		local txt = {LocalStrings.UPGRADE_TIPS1,LocalStrings.UPGRADE_TIPS2,LocalStrings.UPGRADE_TIPS3,LocalStrings.UPGRADE_TIPS4}
		GetElement(self.m_root,"txtDesc2_WndUpgrade",WZUILabelTTF):setText(txt[num])
		GetElement(self.m_root,"conHasNew_WndUpgrade",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conNoNew_WndUpgrade",WZUIContainer):setVisible(true)
	end
end

--@brief	升级界面开启功能
function WndUpgrade:showNewUi(state)
	self.dtTime = 0
	GetElement(self.m_root,"conUp_WndUpgrade",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conNew_WndUpgrade",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"txtNext_WndUpgrade",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"btnConfirm_WndUpgrade",WZUIButton):setVisible(false)
	local spine = GetElement(self.m_root, "spine2_WndUpgrade", WZUISpine)
	spine:play("xingongneng", false)
	spine:setVisible(true)
	spine:enableSchedule("_onNewEnd")
	self.m_root:enableSchedule("onScheduleNew",0.25)
end

function WndUpgrade:onScheduleNew(element, dt)
	self.dtTime = self.dtTime + dt
	if self.dtTime > 0.75 then
		self:actionOver()
		element:disableSchedule()
	end
end

--@brief	点击继续游戏按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndUpgrade:onNew(element)
    WZLog("WndUpgrade:onNew")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = {icon=self.t_levelInfo.imgPath, level=self.t_levelInfo.levelGap, desc=self.t_levelInfo.desc}
    WZLog("Tdata:", self.t_levelInfo.imgPath, tonumber(self.t_levelInfo.levelGap), self.t_levelInfo.desc)
    local con = GetElement(self.m_root, "conBg_WndUpgrade", WZUIContainer)
	WndTips:show(element,con,12,tData) 
end


--@brief	点击继续游戏按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndUpgrade:onContinue(element)
    WZLog("WndUpgrade:onContinue")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.bShowInfo == 1 then
    	self:showNewUi()
    	self.bShowInfo = 2
    	return 
    end

	local nLevel = CacheCenter:getPlayerInfo().level
    Teach:OpenTeachStep(Teach.TYPE_LEVEL, nLevel)
	if false and ProjConfig.USE_DOWNLOAD == 1 then
        local extendLastestVer = WZUpdateManager:getInstance():getExtendUpdateVersion()  --当前更新到的增量包版本
        if ProjConfig.ISOPEN_EXTEND == 1 then
            if CacheCenter:getPlayerInfo().level >= ProjConfig.EXTEND_LEVEL and extendLastestVer < "1.0.1.0"  then
                SavePlayerLevel(CacheCenter:getPlayerInfo().level)
				WndDownLoad.bIsPopDownloadTips = true
                WndDownloadReward:showDownloadReward()
                WndDownloadReward:closeCallBack(self,self.downloadTipCallback)
             end
        end
    end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)

	if self.bShowInfo == 2 or TeachGroup1.ISTEACH == true then
        --self.m_bIsReplace = true
    end
end

function WndUpgrade:onCloseActionCallback(element,data)
	local fade = WZUIActionContainerFadeFromTo:create()
    fade:setOpacityFrom(255)
    fade:setOpacityTo(0)
    fade:setDuration(0.5)
    self.m_root:runUIAction(fade)

    local fade2 = WZUIActionContainerFadeFromTo:create()
    fade2:setOpacityFrom(255)
    fade2:setOpacityTo(0)
    fade2:setDuration(0.5)
    local labelLevelNum = GetElement(self.m_root, "labelLevelNum_WndUpgrade", WZUILabelAtlasFont)
    if labelLevelNum then
        labelLevelNum:runUIAction(fade2)
    end

    local actionArray = CCArray:create()
    actionArray:addObject(CCScaleTo:create(0.5,1.0,1.0))
    actionArray:addObject(CCCallFuncN:create(_wndUpgradeOver))
    local repH = CCSequence:create(actionArray)
    self.m_root:runAction(repH)
	GetElement(self.m_root,"labelLevelNum_WndUpgrade",WZUILabelAtlasFont):setVisible(false)
    --
    for i = 1, 5 do
        GetElement(self.m_root, "textValue" .. (i-1) .."_WndUpgrade", WZUIFreeTextBox):setVisible(false)
    end
    GetElement(self.m_root, "txtLvOpen_WndUpgrade", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtDesc_WndUpgrade", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtDescAtt_WndUpgrade", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtDesc2_WndUpgrade", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtNext_WndUpgrade", WZUILabelTTF):setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin-------------------------------------
function _wndUpgradeOver()
	WindowManager:removeWindow(WndUpgrade.m_root, WndUpgrade, true)
end


--@breif 清除数据
function WndUpgrade:_onUpEnd(element)
	WZLog("WndUpgrade:onUpEnd:", element, event)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		spine:play("shengji_chixu", true)
	end	
end


--@breif 清除数据
function WndUpgrade:_onNewEnd(element)
	WZLog("WndUpgrade:_onNewEnd:", element, event)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		spine:play("xingongneng_chixu", true)
	end		
end

--@brief	更新玩家属性
function WndUpgrade:_updatePlayerPro()
	local level = GlobalGame.g_upgradePro.level or 1
	local playData = CacheCenter:getPlayerInfo()
	GlobalGame.g_upgradePro.level =  playData.level
	WZLog("WndUpgrade:_updatePlayerPro",level )
	--更细等级Icon
	local atlas = GetElement(self.m_root,"labelLevelNum_WndUpgrade",WZUILabelAtlasFont)
	atlas:setText(""..(playData.level))
	atlas:setScale(0)
	--更新属性列表
	local curData2 = self:_getProData(GDatatab_player_upgrade["id_"..level].property)
	local level2 = playData.level
	local curData = self:_getProData(GDatatab_player_upgrade["id_"..level2].property)
	curData.hp = curData.hp - curData2.hp
	curData.attack = curData.attack - curData2.attack
	curData.defend = curData.defend - curData2.defend
	local addSkillNum = CacheCenter:getGameParam()["upLevelSkillNum"]
	local curSkillNum = tonumber(CacheCenter:getSkill().skillNum) - tonumber(addSkillNum)
	local s1 = {LocalStrings.MOUNT_LEVEL1, LocalStrings.SHOP_LIFT,LocalStrings.SHOP_GONGJI,LocalStrings.SHOP_DEFEND,LocalStrings.SKILLNUM}
	local s2 = {""..level, ""..(playData.hp-curData.hp), ""..(playData.attack-curData.attack), ""..(playData.defend-curData.defend),curSkillNum}
	local levelNum = level2 - level
	local s3 = {" +"..levelNum," +"..curData.hp," +"..curData.attack," +"..curData.defend," +"..addSkillNum}
	local sLevel = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[1], s2[1], s3[1])
	local text1 = GetElement(self.m_root,"textValue0_WndUpgrade",WZUIFreeTextBox)
	text1:setShowText(sLevel)
	text1:setScale(0)
	local sHp = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[2], s2[2], s3[2])
	local text2 = GetElement(self.m_root,"textValue1_WndUpgrade",WZUIFreeTextBox)
	text2:setShowText(sHp)
	text2:setScale(0)
	local sAttack = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[3], s2[3], s3[3])
	local text3 = GetElement(self.m_root,"textValue2_WndUpgrade",WZUIFreeTextBox)
	text3:setShowText(sAttack)
	text3:setScale(0)
	local sDefend = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[4], s2[4], s3[4])
	local text4 = GetElement(self.m_root,"textValue3_WndUpgrade",WZUIFreeTextBox)
	text4:setShowText(sDefend)
	text4:setScale(0)
	local sDefend = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[5], s2[5], s3[5])
	local text5 = GetElement(self.m_root,"textValue4_WndUpgrade",WZUIFreeTextBox)
	text5:setShowText(sDefend)
	text5:setScale(0)
	--初始化新功能并设置为不可见
	WndUpgrade.n_actionTag = 0
	GetElement(self.m_root,"txtNext_WndUpgrade",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"btnConfirm_WndUpgrade",WZUIButton):setVisible(false)
	self:setUpgradeUi(self:getUpgradeState())
end

function _scaleValueImg()
	local num = WndUpgrade.n_actionTag
     WndUpgrade.n_actionTag = WndUpgrade.n_actionTag + 1
     if WndUpgrade.n_actionTag > 5 then
     	WndUpgrade:actionOver()
     	return
     end
     local actionArray = CCArray:create()
     actionArray:addObject(CCScaleTo:create(0.15,1.0,1.0))
     actionArray:addObject(CCCallFuncN:create(_scaleValueImg))
     local repH = CCSequence:create(actionArray)
     local curTenImg =  GetElement(WndUpgrade.m_root,"textValue"..num.."_WndUpgrade",WZUIFreeTextBox)
	 curTenImg:runAction(repH)
end

--@brief	创建彩色文本
function WndUpgrade:actionOver()
	GetElement(self.m_root,"txtNext_WndUpgrade",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"btnConfirm_WndUpgrade",WZUIButton):setVisible(true)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配方法模块End----------------------------------------

--@brief    英文适配函数
--@note     英文适配函数
function WndUpgrade:_adaptLanguage_th()
    --WZLog("WndTeachTalk:_adaptLanguage_en")
    WZGetElement(self.m_root,"txtNext_WndUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.12))
end

function WndUpgrade:_adaptLanguage_en(  )
	local txt = GetElement(self.m_root,"txtDesc2_WndUpgrade",WZUILabelTTF)
	txt:setFontSize(16)
	txt:setDimensions(GlobalMethod:CCSize(190,0))

	for i = 0, 4 do
		local textValue = GetElement(self.m_root,"textValue" .. i .. "_WndUpgrade",WZUIFreeTextBox)
		textValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		textValue:setRelativePosition(GlobalMethod:ccp(0.5,0.88-i*0.2))
    end
end

function WndUpgrade:_adaptLanguage_pt(  )
	local txt = GetElement(self.m_root,"txtDesc2_WndUpgrade",WZUILabelTTF)
	txt:setFontSize(16)
	txt:setDimensions(GlobalMethod:CCSize(190,0))

	GetElement(self.m_root,"imgHasNew_WndUpgrade",WZUIImage):setScale(0.7)

	for i = 0, 4 do
		local textValue = GetElement(self.m_root,"textValue" .. i .. "_WndUpgrade",WZUIFreeTextBox)
		textValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		textValue:setRelativePosition(GlobalMethod:ccp(0.5,0.88-i*0.2))
    end
	
end

function WndUpgrade:_adaptLanguage_vn(  )
	local txt = GetElement(self.m_root,"txtDesc2_WndUpgrade",WZUILabelTTF)
	txt:setFontSize(14)
	txt:setDimensions(GlobalMethod:CCSize(190,0))
end

function WndUpgrade:_adaptLanguage_es(  )
	local txt = GetElement(self.m_root,"txtDesc2_WndUpgrade",WZUILabelTTF)
	txt:setFontSize(16)
	txt:setDimensions(GlobalMethod:CCSize(190,0))

	local txtLv = GetElement(self.m_root,"txtLvOpen_WndUpgrade",WZUILabelTTF)
	txtLv:setFontSize(16)

	GetElement(self.m_root,"imgHasNew_WndUpgrade",WZUIImage):setScale(0.85)

	for i = 0, 4 do
		local textValue = GetElement(self.m_root,"textValue" .. i .. "_WndUpgrade",WZUIFreeTextBox)
		textValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		textValue:setRelativePosition(GlobalMethod:ccp(0.5,0.88-i*0.2))
    end
end

function WndUpgrade:_adaptLanguage_tr(  )
	GetElement(self.m_root,"imgHasNew_WndUpgrade",WZUIImage):setScale(0.7)
end
--------------------------------------------------语言适配End--------------------------------------