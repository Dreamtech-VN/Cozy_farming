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

	--静态初始化UI文本
	self:_updateStaticUiText()
	

	self.m_nSkillTag = 1

	self:_addTop()
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
    tcell:setTopData("ui/community/common_icon_jnxt.png",SceneCommunitySkill,SceneCommunitySkill.onClose,true,false,false,"SceneCommunitySkill")
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
function SceneCommunitySkill:onLearn()
	WZLog("SceneCommunitySkill:onLearn")
	--如果正在发送协议，返回
	if self.m_nLoadingCircleId ~= nil then return end
	if self.m_tSkillLevels == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--判断金币是否足够
	if CacheCenter:getMoneyList().gold < self.m_nNeedGold then
		MsgBoxManager:showConfirmCancelBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil)
		return
	end

	local guildInfo = CacheCenter:getGuildInfo()
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--技能已经达到最高级
	if self.m_tSkillLevels[self.m_nSkillTag].level >= GUILDMAXLEVEL * 10 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO42)
		return
	end

	--技能等级和学堂等级相同
	if guildInfo.schoolLevel * 10 <= self.m_tSkillLevels[self.m_nSkillTag].level then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO41)
		return
	end

	--个人贡献是否足够
	local needDonate = GetElement(self.m_root, "donateCost1", WZUILabelTTF):getText()
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
	ProtocolProcessorSceneCommunity:send_GUILD_LearnGuildSkill(self.m_tSkillLevels[self.m_nSkillTag].id )
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

	--设置公会等级
	GetElement(self.m_root, "CommunityLv1", WZUILabelTTF):setText(guildInfo.guildLevel)

	--设置技能学堂等级
	GetElement(self.m_root, "SchoolLevel1", WZUILabelTTF):setText(guildInfo.schoolLevel)

	--公会等级名称id
	local info = [[<T C="255,227,116" S="20" P="0">Lv%s </T><T C="255,236,193" S="20" P="0">%s  </T><T C="255,236,193" S="20" P="0">(ID:%s)</T>]]
	local info1 = string.format(info,guildInfo.guildLevel,guildInfo.guildName,guildInfo.guildId)
	GetElement(self.m_root,"infoFree_SceneCommunitySkill",WZUIFreeTextBox):setShowText(info1)
	
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
	self.m_needDonate = needDonate

	--设置属性增长
	GetElement(self.m_root, "curLevel", WZUILabelTTF):setText(LocalStrings.LV..self.m_tSkillLevels[self.m_nSkillTag].level)
	GetElement(self.m_root, "nextLevel", WZUILabelTTF):setText(LocalStrings.LV..(tonumber(self.m_tSkillLevels[self.m_nSkillTag].level)+1))

	GetElement(self.m_root, "skillValue", WZUILabelTTF):setText(ATTR_TITLE[self.m_tSkillLevels[self.m_nSkillTag].id]..":"..curVal)
	GetElement(self.m_root, "skillValue1", WZUILabelTTF):setText(nextVal)

	GetElement(self.m_root, "arrow1", WZUIImage):setVisible(true)
	GetElement(self.m_root, "arrow2", WZUIImage):setVisible(true)
	GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(true)
	--技能满级
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	if self.m_tSkillLevels[self.m_nSkillTag].level >= GUILDMAXLEVEL * 10 then
		GetElement(self.m_root, "nextLevel", WZUILabelTTF):setText("")
		GetElement(self.m_root, "skillValue1", WZUILabelTTF):setText("")
		GetElement(self.m_root, "arrow1", WZUIImage):setVisible(false)
		GetElement(self.m_root, "arrow2", WZUIImage):setVisible(false)
		GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(false)
	end

	--技能等级和学堂等级相同
	if guildInfo.schoolLevel * 10 <= self.m_tSkillLevels[self.m_nSkillTag].level then
		GetElement(self.m_root, "btnLearn", WZUIButton):setTouchEnable(false)
	end

	--设置选中的技能
	for i=1,7 do
		GetElement(self.m_root, "skillBg"..i, WZUIImage):setVisible(false)
	end
	GetElement(self.m_root, "skillBg"..self.m_nSkillTag, WZUIImage):setVisible(true)
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
	GetElement(self.m_root,"CommunityPrestige1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.429167,0.425))
    GetElement(self.m_root,"CommunityDonate1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.715,0.45))
    GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    GetElement(self.m_root,"SchoolLevel1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.529167,0.44))

    GetElement(self.m_root,"curLevel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.496667,0.5))

    GetElement(self.m_root,"skillValue",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.486667,0.5))

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


