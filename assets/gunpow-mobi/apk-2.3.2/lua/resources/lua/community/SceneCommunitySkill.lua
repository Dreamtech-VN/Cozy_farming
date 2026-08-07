--SceneCommunitySkill.lua
--@brief	SceneCommunitySkill的UI模块
--@date		2013/12/26
--@author	zsq
--@note		公会技能的场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunitySkill:onEnter(element)
	self.m_root = element
    local conLog = GetElement(self.m_root,"conLog_SceneCommunitySkill",WZUIContainer)
    conLog:setVisible(false)
	--静态初始化UI文本
	self:_updateStaticUiText()
	

	self.m_nSkillTag = 1

	if self.m_tSkillLevels == nil then
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuildSkill( )
	else
		--刷新界面
		self:_update()
	end

	--多语言版本界面适配
    AdaptLanguage(self)
end

function SceneCommunitySkill:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/community/common_icon_jjxt.png",SceneCommunitySkill,SceneCommunitySkill.onClose,true,false,false,"SceneCommunitySkill")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunitySkill:onExit(element)
	self:_unInit()
end

--@brief	触摸开始回调
function SceneCommunitySkill:onTouchBegin(element, pt)
	-- body
	if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief	关闭按钮
function SceneCommunitySkill:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
   	--replaceScene(SceneCommunityMain:createElement())
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	技能学堂升级
function SceneCommunitySkill:onUpgrade()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--技能学堂已是最高等级
	if guildInfo.schoolLevel >= GUILDMAXLEVEL then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO33)
		return
	end

	--技能学堂等级和公会等级相同
	if guildInfo.guildLevel == guildInfo.schoolLevel then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO30)
		return
	end

	local cost = 0
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 2 and v.level == (guildInfo.schoolLevel + 1) then
			cost = v.cost[1][2]
		end
	end 

	WndCommunityUpgrade:showSchoolUpgrade(guildInfo.schoolLevel, cost) 
	WndCommunityUpgrade.m_nCost = cost
end

--@brief	技能学堂说明
function SceneCommunitySkill:onInfo()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CommunityExplain2)
end

--@brief	学习技能
function SceneCommunitySkill:onLearn(element)
	WZLog("SceneCommunitySkill:onLearn")
	local tag = element:getTag()
	WZLog("按钮tag",tag)
	local guildInfo = CacheCenter:getGuildInfo()
	if tag == 1 then
		self.learnNum = 1
	end
	local skillCanLevel = 0
	for k, v in pairs(GDatatab_guild_property) do
		if v.gh_level == guildInfo.schoolLevel then
			-- skillCanLevel = guildInfo.level
			if skillCanLevel < v.level then
				skillCanLevel = v.level
			end
		end
	end
	if tag == 5 then
		 if skillCanLevel - self.m_tSkillLevels[self.m_nSkillTag].level >= 5 then
		 	self.learnNum = 5
		 else 
		 	self.learnNum = skillCanLevel - self.m_tSkillLevels[self.m_nSkillTag].level
		 end
	end
	self.n_leranNum = self.learnNum
	--如果正在发送协议，返回
	if self.m_nLoadingCircleId ~= nil then return end
	if self.m_tSkillLevels == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--判断金币是否足够
	if CacheCenter:getMoneyList().gold < self.m_nNeedGold then
		MsgBoxManager:showConfirmCancelBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil)
		return
	end

	
	WZLog("tag = ",tag,guildInfo.skillCanLevel,self.m_tSkillLevels[self.m_nSkillTag].level)
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--技能已经达到最高级
	if self.m_tSkillLevels[self.m_nSkillTag].level >= skillCanLevel then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO42)
		return
	end

	--技能等级和学堂等级相同
	if skillCanLevel <= self.m_tSkillLevels[self.m_nSkillTag].level then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO41)
		return
	end

	--个人贡献是否足够
	local needDonate = GetElement(self.m_root, "donateCost1", WZUILabelTTF):getText()
	local needGold = GetElement(self.m_root, "goldCost1", WZUILabelTTF):getText()
	if tag == 5 then
		for i = 1,self.learnNum do
			for k,v in pairs(GDatatab_guild_property) do
				if v.type == self.m_tSkillLevels[self.m_nSkillTag].id and v.level == (self.m_tSkillLevels[self.m_nSkillTag].level + i) then
					needDonate = needDonate + v.cost[1][2]
					needGold = needGold + v.cost[2][2]
				end
			end
		end
	end
	if tag == 5 then 
		if CacheCenter:getMoneyList().gold < needGold then
			MsgBoxManager:showConfirmCancelBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil)
		return
		end
	end
	WZLog("个人贡献是否足够",needDonate)
	if tonumber(guildInfo.totalDonate) >= tonumber(needDonate) then
		self.m_nUpgrade = true
		self.m_needDonate = needDonate
		self.m_nLoadingCircleId = 0
		self.m_root:enableSchedule("onLearn1",0.27)
	else
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO37)
	end
end

--@brief	延迟调用升级技能
function SceneCommunitySkill:onLearn1(element,t)
	element:disableSchedule()
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
	ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill(self.m_tSkillLevels[self.m_nSkillTag].id,self.learnNum )
	self.learnNum = 1
    MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO109)
end

--@brief	快速购买金币框
function SceneCommunitySkill:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end

--@brief	点击技能1
function SceneCommunitySkill:onSkill1()
	WZLog("SceneCommunitySkill:onSkill1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng2.png")
	self.m_nSkillTag = 1
	self:_update()
end

--@brief	点击技能2
function SceneCommunitySkill:onSkill2()
	WZLog("SceneCommunitySkill:onSkill2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng3.png")
	self.m_nSkillTag = 2
	self:_update()
end

--@brief	点击技能3
function SceneCommunitySkill:onSkill3()
	WZLog("SceneCommunitySkill:onSkill3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng4.png")
	self.m_nSkillTag = 3
	self:_update()
end

--@brief	点击技能4
function SceneCommunitySkill:onSkill4()
	WZLog("SceneCommunitySkill:onSkill4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng1.png")
	self.m_nSkillTag = 4
	self:_update()
end

--@brief	点击技能5
function SceneCommunitySkill:onSkill5()
	WZLog("SceneCommunitySkill:onSkill5")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng5.png")
	self.m_nSkillTag = 5
	self:_update()
end

--@brief	点击技能6
function SceneCommunitySkill:onSkill6()
	WZLog("SceneCommunitySkill:onSkill6")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng7.png")
	self.m_nSkillTag = 6
	self:_update()
end

--@brief	点击技能7
function SceneCommunitySkill:onSkill7()
	WZLog("SceneCommunitySkill:onSkill7")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng6.png")
	self.m_nSkillTag = 7
	self:_update()
end

function SceneCommunitySkill:onSkill8()
	WZLog("SceneCommunitySkill:onSkill8")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng9.png")
	self.m_nSkillTag = 8
	self:_update()
end

function SceneCommunitySkill:onSkill9()
	WZLog("SceneCommunitySkill:onSkill9")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng11.png")
	self.m_nSkillTag = 9
	self:_update()
end

function SceneCommunitySkill:onSkill10()
	WZLog("SceneCommunitySkill:onSkill10")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng12.png")
	self.m_nSkillTag = 10
	self:_update()
end

function SceneCommunitySkill:onSkill11()
	WZLog("SceneCommunitySkill:onSkill11")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng10.png")
	self.m_nSkillTag = 11
	self:_update()
end

function SceneCommunitySkill:onSkill12()
	WZLog("SceneCommunitySkill:onSkill12")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root, "learnSkillIcon", WZUIImage):setFile("ui/community/common_icon_jineng8.png")
	self.m_nSkillTag = 12
	self:_update()
end

function SceneCommunitySkill:onCloseResult()
	-- body
	GetElement(self.m_root,"conLog_SceneCommunitySkill",WZUIContainer):setVisible(false)
end

function SceneCommunitySkill:updateLogTime()
    local conLog = GetElement(self.m_root,"conLog_SceneCommunitySkill",WZUIContainer)
    conLog:disableSchedule()
    self.logTime = 0
end
function SceneCommunitySkill:updateUpLog(num)
	local conLog = GetElement(self.m_root, "conLog_SceneCommunitySkill", WZUIContainer)
	conLog:setVisible(true)
	conLog:setScale(0)

	local disTime = 0.3
	local tData = {}
	local num1 = 0--贡献
	local num2 = 0--金币
	for i = 1,5 do
		local ftb = GetElement(self.m_root,"tfbLog"..i.."_SceneCommunitySkill",WZUIFreeTextBox):setVisible(false)
	end
	local currentLv = self.m_tSkillLevels[self.m_nSkillTag].level 
	WZLog("升级后的当前等级",currentLv)
	for i = 1,num do
		local ftb = GetElement(self.m_root,"tfbLog"..i.."_SceneCommunitySkill",WZUIFreeTextBox)
		for k,v in pairs(GDatatab_guild_property) do
			if v.type == self.m_tSkillLevels[self.m_nSkillTag].id and v.level == self.m_tSkillLevels[self.m_nSkillTag].level+ i then
				num1 = num1 + v.cost[1][2]
				num2 = num2 + v.cost[2][2]
				-- MOUNT_UP_LOG5 = [[<T C="195,171,148" S="22" P="0">第%d次升级，%d->%d，消耗%d金币，消耗%d元魂</T>]],
				ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG7,i,currentLv,currentLv + 1,v.cost[2][2],v.cost[1][2]))
				currentLv = self.m_tSkillLevels[self.m_nSkillTag].level + i
			end
            ftb:setScale(0)
            ftb:setVisible(true)
            local act1 = CCDelayTime:create(0.1+disTime*i)
            local act2 = CCScaleTo:create(0,1)
            local act = CCSequence:createWithTwoActions(act1,act2)
            ftb:runAction(act)
		end
	end
	local ftb = GetElement(self.m_root,"tfbLog6_SceneCommunitySkill",WZUIFreeTextBox)
	ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG8,num,num2,num1))
    ftb:setScale(0)
    local act1 = CCDelayTime:create(0.1+disTime*(num+1))
    local act2 = CCScaleTo:create(0,1)
    local act = CCSequence:createWithTwoActions(act1,act2)
    ftb:runAction(act)

    local act1 = CCScaleTo:create(0.1,1)
    conLog:runAction(act1)

    self.logTime = disTime*(num+1)+0.1
    conLog:enableSchedule("updateLogTime",self.logTime)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新界面
function SceneCommunitySkill:_update()
	if self.m_tSkillLevels == nil then return end
	if self.m_root == nil then return end
	for i=1,#self.m_tSkillLevels do
		GetElement(self.m_root, "skillLevel"..i, WZUILabelTTF):setText(LocalStrings.LV..self.m_tSkillLevels[i].level)
	end

	local guildInfo = CacheCenter:getGuildInfo()

	--设置公会威望
	GetElement(self.m_root, "CommunityPrestige1", WZUILabelTTF):setText(guildInfo.prestige)

	--设置个人贡献
	GetElement(self.m_root, "CommunityDonate1", WZUILabelTTF):setText(guildInfo.totalDonate)

	--设置技能学堂等级
	GetElement(self.m_root, "SchoolLevel1", WZUILabelTTF):setText(guildInfo.schoolLevel)
	
	--是否显示升级建筑按钮
	if guildInfo.position >= 3 then
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnUpgrade", WZUIButton):setVisible(false)
		--GetElement(self.m_root, "btnInfo", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.16))
	end

	local needGold = 0
	local needDonate = 0
	local curVal = 0
	local nextVal = 0
	local attrTitle = ""
	for k,v in pairs(GDatatab_guild_property) do
		if v.type == self.m_tSkillLevels[self.m_nSkillTag].id and v.level == (self.m_tSkillLevels[self.m_nSkillTag].level) then
			if v.property == 0 then
				curVal = 0
			else
				curVal = v.property[1][2]
			end
		end
		if v.type == self.m_tSkillLevels[self.m_nSkillTag].id and v.level == (self.m_tSkillLevels[self.m_nSkillTag].level + 1) then
			needGold = v.cost[2][2]
			needDonate = v.cost[1][2]

			nextVal = v.property[1][2]
			attrTitle = ATTR_TITLE[v.property[1][1]]
		end
	end


	--设置金币消耗
	GetElement(self.m_root, "goldCost1", WZUILabelTTF):setText(needGold)
	self.m_nNeedGold = tonumber(needGold)

	--设置个人贡献消耗
	GetElement(self.m_root, "donateCost1", WZUILabelTTF):setText(needDonate)

	--设置属性增长
	GetElement(self.m_root, "curLevel", WZUILabelTTF):setText(LocalStrings.LV..self.m_tSkillLevels[self.m_nSkillTag].level)
	GetElement(self.m_root, "nextLevel", WZUILabelTTF):setText(LocalStrings.LV..(tonumber(self.m_tSkillLevels[self.m_nSkillTag].level)+1))

	GetElement(self.m_root, "txtAttrTitle_SceneCommunitySkill", WZUILabelTTF):setText(ATTR_TITLE[self.m_tSkillLevels[self.m_nSkillTag].id]..": ")
	GetElement(self.m_root, "txtAttrTitle1_SceneCommunitySkill", WZUILabelTTF):setText(ATTR_TITLE[self.m_tSkillLevels[self.m_nSkillTag].id]..": ")
	GetElement(self.m_root, "skillValue", WZUILabelTTF):setText(curVal)
	GetElement(self.m_root, "skillValue1", WZUILabelTTF):setText(nextVal)

	GetElement(self.m_root, "arrow1", WZUIImage):setVisible(true)
	GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(true)
	GetElement(self.m_root, "btnFiveLearn", WZUIButton):setTouchEnable(true)
	--技能满级
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	local skillCanLevel = 0
	for k,v in pairs(GDatatab_guild_property) do
		if v.gh_level == guildInfo.schoolLevel then
			-- skillCanLevel = v.level
			if skillCanLevel < v.level then
				skillCanLevel = v.level
			end
		end
	end
	WZLog("技能最大可升级数",skillCanLevel,guildInfo.schoolLevel)
	if self.m_tSkillLevels[self.m_nSkillTag].level >= skillCanLevel then
		GetElement(self.m_root, "nextLevel", WZUILabelTTF):setText("")
		GetElement(self.m_root, "skillValue1", WZUILabelTTF):setText("")
		GetElement(self.m_root, "arrow1", WZUIImage):setVisible(false)
		GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(false)
		GetElement(self.m_root, "btnFiveLearn", WZUIButton):setTouchEnable(false)
	end

	local learnNum = 5
	if skillCanLevel - self.m_tSkillLevels[self.m_nSkillTag].level >= 5 then
	 	learnNum = 5
	else 
	 	learnNum = skillCanLevel - self.m_tSkillLevels[self.m_nSkillTag].level
	end
	for i = 1,3 do
		local fiveTxt =  GetElement(self.m_root, "txt5Skill"..i.."_SceneCommunitySkill",WZUILabelTTF)
		fiveTxt:setText(string.format(LocalStrings.COMMUNITYINFO239,tonumber(learnNum)))
	end
	--技能等级和学堂等级相同
	if skillCanLevel <= self.m_tSkillLevels[self.m_nSkillTag].level then
		GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(false)
		GetElement(self.m_root, "btnFiveLearn", WZUIButton):setTouchEnable(false)
	end

	--设置选中的技能
	for i=1,12 do
		GetElement(self.m_root,"name"..i,WZUILabelTTF):setText(ATTR_TITLE[self.m_tSkillLevels[i].id])
		GetElement(self.m_root, "skillBg"..i, WZUI9Image):setVisible(false)
	end
	GetElement(self.m_root, "skillBg"..self.m_nSkillTag, WZUI9Image):setVisible(true)
end

--@brief 更新静态UI文本
function SceneCommunitySkill:_updateStaticUiText()

end 

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Begin----------------------------------------

--@brief	葡语适配函数
function SceneCommunitySkill:_adaptLanguage_pt()
	GetElement(self.m_root,"curLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.3,0.5))
	GetElement(self.m_root,"skillValue",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.4,0.5))
	GetElement(self.m_root,"SchoolLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.204167,0.5))
	GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.48))
	GetElement(self.m_root,"CommunityDonate1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.5))
	for i=1,3 do
    	local txtSkill = GetElement(self.m_root,"txtSkill"..i.."_SceneCommunitySkill",WZUILabelTTF)
    	txtSkill:setScale(0.8)
    	txtSkill:setDimensions(GlobalMethod:CCSize(100,0))
    end
    GetElement(self.m_root,"CommunityDonate",WZUILabelTTF):setFontSize(18)
end 

--@brief	越南语适配
function SceneCommunitySkill:_adaptLanguage_vn()
	GetElement(self.m_root,"CommunityDonate1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,0.45))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.425))

	GetElement(self.m_root,"txtUpgrade_SceneCommunitySkill",WZUILabelTTF):setScale(0.7)
end 

--@brief	英语适配
function SceneCommunitySkill:_adaptLanguage_en(  )
	GetElement(self.m_root,"curLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.486667,0.5))
	
	local skillValue = GetElement(self.m_root,"skillValue",WZUILabelTTF)
	skillValue:setRelativePosition(GlobalMethod:ccp(-0.486667,0.5))
	skillValue:setFontSize(16)

	GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.48))
	GetElement(self.m_root,"CommunityDonate1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.5))
end

function SceneCommunitySkill:_adaptLanguage_tr(  )
	GetElement(self.m_root,"curLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.3,0.5))
	local skillValue = GetElement(self.m_root,"skillValue",WZUILabelTTF)
	skillValue:setRelativePosition(GlobalMethod:ccp(-0.38,0.5))
	skillValue:setFontSize(16)
	
	local schoolLevel = GetElement(self.m_root,"SchoolLevel",WZUILabelTTF)
	schoolLevel:setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	schoolLevel:setFontSize(16)

	GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.5))
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.48))
	GetElement(self.m_root,"CommunityDonate1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.5))
	for i=1,3 do
		GetElement(self.m_root,"txtSkill"..i.."_SceneCommunitySkill",WZUILabelTTF):setScale(0.8)
	end
end

function SceneCommunitySkill:_adaptLanguage_th(  )
	local skillValue = GetElement(self.m_root,"skillValue",WZUILabelTTF)
	skillValue:setRelativePosition(GlobalMethod:ccp(-0.3,0.5))
end

function SceneCommunitySkill:_adaptLanguage_es(  )
	local skillValue = GetElement(self.m_root,"skillValue",WZUILabelTTF)
	skillValue:setRelativePosition(GlobalMethod:ccp(-0.3,0.5))
	skillValue:setFontSize(16)
	skillValue:setDimensions(GlobalMethod:CCSize(110,0))

	local communityPrestige1 = GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF)
	communityPrestige1:setRelativePosition(GlobalMethod:ccp(0.4,0.5))

	local txtCost = GetElement(self.m_root,"txtCost_SceneCommunitySkill",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.03,0.253027))
	for i=1,3 do
		local txtSkill = GetElement(self.m_root,"txtSkill"..i.."_SceneCommunitySkill",WZUILabelTTF)
		txtSkill:setDimensions(GlobalMethod:CCSize(130,0))
		txtSkill:setScale(0.8)
	end
	GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	GetElement(self.m_root,"txtUpgrade_SceneCommunitySkill",WZUILabelTTF):setScale(0.8)
end
------------------------------------语言适配模块End----------------------------------------


