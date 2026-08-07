--WndCommunityLog.lua
--@brief	WndCommunityLog的UI模块
--@date		2015/04/28
--@author	zsq
--@note		入会限制


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityLog:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	加载完成
--function WndCommunityLog:onEnterTransitionDidFinish(element)
--	self:onCheck2()
--end

--@brief    onenter函数已执行
function WndCommunityLog:onEnterTransitionDidFinish(element)
    WZLog("WndWelfare:onEnterTransitionDidFinish")
	AdaptLanguage(self)
    --弹窗动画
    self:updateSetting()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityLog:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityLog:onClose(element)
	WZLog("WndCommunityLog:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityLog, true)
	end 
end

--@brief	增加等级
function WndCommunityLog:onAddLv(element)
	WZLog("WndCommunityLog:onAddLv", CacheCenter:getGameParam().gameMaxLevel)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local gameMaxLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)
	if tonumber(self.m_nLv)%5 ~= 0 and (self.m_nLv) <= gameMaxLevel then
		self.m_nLv = self.m_nLv + (5-tonumber(self.m_nLv)%5)
	elseif (self.m_nLv + 5) <= gameMaxLevel then
		self.m_nLv = self.m_nLv + 5
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO63, tostring(CacheCenter:getGameParam().gameMaxLevel)))
	end
	GetElement(self.m_root, "editBoxInputLv_WndCommunityLog", WZUIEditBox):setText(self.m_nLv)
end

--@brief	减少等级
function WndCommunityLog:onReduceLv(element)
	WZLog("WndCommunityLog:onReduceLv")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tonumber(self.m_nLv)%5 ~= 0 and (self.m_nLv) > self.m_nMinLv then
		self.m_nLv = self.m_nLv - tonumber(self.m_nLv)%5
	elseif self.m_nLv - 5 >= self.m_nMinLv then
		self.m_nLv = self.m_nLv - 5
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO228, tostring(self.m_nMinLv)))
	end
	GetElement(self.m_root, "editBoxInputLv_WndCommunityLog", WZUIEditBox):setText(self.m_nLv)
end

--@brief	增加VIP等级
function WndCommunityLog:onAddVip(element)
	WZLog("WndCommunityLog:onAddVip", CacheCenter:getGameParam().newMaxVip)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local maxVip = tonumber(CacheCenter:getGameParam().newMaxVip)
	if (self.m_nVipLevel + 1) <= maxVip then
		self.m_nVipLevel = self.m_nVipLevel + 1
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO229, tostring(CacheCenter:getGameParam().newMaxVip)))
	end
	GetElement(self.m_root, "editBoxInputVip_WndCommunityLog", WZUIEditBox):setText(self.m_nVipLevel)
end

--@brief	减少VIP等级
function WndCommunityLog:onReduceVip(element)
	WZLog("WndCommunityLog:onReduceVip")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nVipLevel - 1 >= 0 then
		self.m_nVipLevel = self.m_nVipLevel - 1
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO230, "0"))
	end
	GetElement(self.m_root, "editBoxInputVip_WndCommunityLog", WZUIEditBox):setText(self.m_nVipLevel)
end

--@brief	增加战力
function WndCommunityLog:onAddFight(element)
	WZLog("WndCommunityLog:onAddFight")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local gameMaxLevel = 50000000
	if tonumber(self.m_nFighting)%self.m_nFightStep ~= 0 and (self.m_nFighting) <= gameMaxLevel then
		self.m_nFighting = self.m_nFighting + (self.m_nFightStep-tonumber(self.m_nFighting)%self.m_nFightStep)
	elseif (self.m_nFighting + self.m_nFightStep) <= gameMaxLevel then
		self.m_nFighting = self.m_nFighting + self.m_nFightStep
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[29], tostring(gameMaxLevel)))
	end
	GetElement(self.m_root, "editBoxInputFight_WndCommunityLog", WZUIEditBox):setText(self.m_nFighting)
end

--@brief	减少战力
function WndCommunityLog:onReduceFight(element)
	WZLog("WndCommunityLog:onReduceFight")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFighting - self.m_nFightStep >= 0 then
		self.m_nFighting = self.m_nFighting - self.m_nFightStep
	elseif self.m_nFighting > 0 then 
		self.m_nFighting = 0 
	else
		MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[28])
	end
	GetElement(self.m_root, "editBoxInputFight_WndCommunityLog", WZUIEditBox):setText(self.m_nFighting)
end

--@brief	点击确定按钮时被调用的函数
--@param	element:表绑定的UI节点引用
function WndCommunityLog:onSureSetting(element)
	WZLog("WndCommunityLog:onSureBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--获得审批方式
	local examine = GetElement(self.m_root, "checkBox_WndCommunityLog", WZUICheckBoxGroup):getCheckIndex()
	--获得入会等级
	local lv = GetElement(self.m_root, "editBoxInputLv_WndCommunityLog", WZUIEditBox):getText()
	--获得入会vip等级
	local vipLevel = GetElement(self.m_root, "editBoxInputVip_WndCommunityLog", WZUIEditBox):getText()

	if tonumber(lv) ~= nil then     --输入全是数字
		local setInput = tonumber(lv)		
		--输入是小数或整数
		local maxLv = tonumber(CacheCenter:getGameParam().gameMaxLevel)
		if (math.floor(setInput) < setInput) or (setInput < 0) or setInput > maxLv then
			if setInput > maxLv then
				MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO63, maxLv))
			else
				MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO48)
			end
	  	else
			--设置进入公会等级
			if self.m_nWinType == 0 then 
				WZLog("公会设置", tonumber(lv), tonumber(examine), tonumber(vipLevel))
				ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting(tonumber(lv), 0, tonumber(examine), tonumber(vipLevel))
		
				local guildInfo = CacheCenter:getGuildInfo()
				guildInfo.examine = tonumber(examine)
				guildInfo.setting = lv
				guildInfo.joinVipLevel = tonumber(vipLevel)
			elseif self.m_nWinType == 1 then 
				--获得入盟战力
				local fight = GetElement(self.m_root, "editBoxInputFight_WndCommunityLog", WZUIEditBox):getText()
				WZLog("Union Set", tonumber(lv), tonumber(examine), tonumber(vipLevel))
				ProtocolProcessorUnion:send_LEAGUE_Setting(tonumber(examine), tonumber(lv), tonumber(fight), tonumber(vipLevel))
		
				local guildInfo = CacheCenter:getUnionInfo()
				guildInfo.examine = tonumber(examine)
				guildInfo.setting = lv
				guildInfo.joinVipLevel = tonumber(vipLevel)
				guildInfo.fight = tonumber(fight)
			end
	  	end
	else  
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO48)
	end 
end 

function WndCommunityLog:onCover() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showTipBox(LocalStrings.NEWCOMMUNITY8)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityLog:updateSetting()
	local infoData = nil 
	local fId = 0 --功能Id
	local position = 0
	if self.m_nWinType == 0 then 
		infoData = CacheCenter:getGuildInfo()
		fId = 9
		GetElement(self.m_root, "txtWinTitle_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO237)
		GetElement(self.m_root, "txtMain2Open1_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.REVIEW3)
		GetElement(self.m_root, "txtMain2Open2_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.REVIEW4)
		position = tonumber(CacheCenter:getPlayerInfo().position)	
	elseif self.m_nWinType == 1 then 
		infoData = CacheCenter:getUnionInfo()
		position = infoData.position
		self.m_nFighting = infoData.fight or 0
		fId = 230
		GetElement(self.m_root, "txtWinTitle_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[6])
		GetElement(self.m_root, "txtMain2Open1_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[18])
		GetElement(self.m_root, "txtMain2Open2_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[20])
		GetElement(self.m_root, "txtMain2Open3_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[19])

		GetElement(self.m_root, "conLvLimit_WndCommunityLog", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.469477,0.61))
		GetElement(self.m_root, "conFightLimit_WndCommunityLog", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conVipLimit_WndCommunityLog", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.469477,0.345))
		GetElement(self.m_root, "editBoxInputFight_WndCommunityLog", WZUIEditBox):setText(self.m_nFighting)
	end
	local examine = tonumber(infoData.examine)
	self.m_nLv = tonumber(infoData.setting)
	self.m_nVipLevel = tonumber(infoData.joinVipLevel)
	local open_level = 15
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_" .. fId] ~= nil then
		open_level = GDatatab_button_info["id_" .. fId].open_level
	end
	self.m_nMinLv = open_level 
	if self.m_nLv < open_level then self.m_nLv = open_level end
	GetElement(self.m_root, "txtCheckTitle_WndCommunityLog", WZUILabelTTF):setText(LocalStrings.NEWCOMMUNITY10 .. ":")
	--设置审批方式
	GetElement(self.m_root, "checkBox_WndCommunityLog", WZUICheckBoxGroup):setCheckIndex(examine)
	--设置入会等级
	GetElement(self.m_root, "editBoxInputLv_WndCommunityLog", WZUIEditBox):setText(self.m_nLv)
	--设置入会vip等级
	GetElement(self.m_root, "editBoxInputVip_WndCommunityLog", WZUIEditBox):setText(self.m_nVipLevel)
	GetElement(self.m_root, "btnCover", WZUIButton):setVisible(true)

	WZLog("公会职位",position)
	local tPresident = {COMMUNITY_PRESIDENT, UNION_PRESIDENT}
	if position == tPresident[self.m_nWinType + 1] then
		GetElement(self.m_root,"btnCover",WZUIButton):setVisible(false)
	end
end


function WndCommunityLog:_adaptLanguage_vn()
    WZLog("WndCommunityLog:_adaptLanguage_vn ")
   
end

function WndCommunityLog:_adaptLanguage_tr()
    WZLog("WndCommunityLog:_adaptLanguage_tr ")
    
end

function WndCommunityLog:_adaptLanguage_es(  )
	
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin-----------------------------------

function WndCommunityLog:_adaptLanguage_vn(  )
	GetElement(self.m_root, "txtMain2Open1_WndCommunityLog", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.05,0.5))
	GetElement(self.m_root, "txtMain2Open2_WndCommunityLog", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.05,0.5))
	GetElement(self.m_root, "txtMain2Open3_WndCommunityLog", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.05,0.5))
end

---------------------------------------------语言适配End--------------------------------------
