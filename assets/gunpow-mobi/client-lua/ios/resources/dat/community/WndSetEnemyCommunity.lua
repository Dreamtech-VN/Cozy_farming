--WndSetEnemyCommunity.lua
--@brief	WndSetEnemyCommunity的UI模块
--@date		2015/12/28
--@author	zsq
--@note		公会设置

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSetEnemyCommunity:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
end

function WndSetEnemyCommunity:onEnterTransitionDidFinish(element)
	self:update()
    WindowManagerAni:createAction(element,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSetEnemyCommunity:onExit(element)
	self:_unInit()
end

function WndSetEnemyCommunity:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndSetEnemyCommunity, true)
	end 
end

function WndSetEnemyCommunity:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root, WndSetEnemyCommunity, true)
end

--@brief	点击关闭按钮时被调用的函数
function WndSetEnemyCommunity:onCloseBtn(element)
	if self.m_root ~= nil then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	选择审核方式
function WndSetEnemyCommunity:onCheck(element)
	WZLog("WndSetEnemyCommunity:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief	增加等级
function WndSetEnemyCommunity:onAddLv(element)
	WZLog("WndSetEnemyCommunity:onAddLv", CacheCenter:getGameParam().gameMaxLevel)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local gameMaxLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)
	if tonumber(self.m_nLv)%5 ~= 0 and (self.m_nLv) <= gameMaxLevel then
		self.m_nLv = self.m_nLv + (5-tonumber(self.m_nLv)%5)
	elseif (self.m_nLv + 5) <= gameMaxLevel then
		self.m_nLv = self.m_nLv + 5
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO63, tostring(CacheCenter:getGameParam().gameMaxLevel)))
	end
	GetElement(self.m_root, "editBoxInputLv_WndSetEnemyCommunity", WZUIEditBox):setText(self.m_nLv)
end

--@brief	减少等级
function WndSetEnemyCommunity:onReduceLv(element)
	WZLog("WndSetEnemyCommunity:onReduceLv")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tonumber(self.m_nLv)%5 ~= 0 and (self.m_nLv) > 15 then
		self.m_nLv = self.m_nLv - tonumber(self.m_nLv)%5
	elseif self.m_nLv - 5 >= 15 then
		self.m_nLv = self.m_nLv - 5
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO228, "15"))
	end
	GetElement(self.m_root, "editBoxInputLv_WndSetEnemyCommunity", WZUIEditBox):setText(self.m_nLv)
end

--@brief	增加VIP等级
function WndSetEnemyCommunity:onAddVip(element)
	WZLog("WndSetEnemyCommunity:onAddVip", CacheCenter:getGameParam().maxVip)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local maxVip = tonumber(CacheCenter:getGameParam().maxVip)
	if (self.m_nVipLevel + 1) <= maxVip then
		self.m_nVipLevel = self.m_nVipLevel + 1
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO229, tostring(CacheCenter:getGameParam().maxVip)))
	end
	GetElement(self.m_root, "editBoxInputVip_WndSetEnemyCommunity", WZUIEditBox):setText(self.m_nVipLevel)
end

--@brief	减少VIP等级
function WndSetEnemyCommunity:onReduceVip(element)
	WZLog("WndSetEnemyCommunity:onReduceVip")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nVipLevel - 1 >= 0 then
		self.m_nVipLevel = self.m_nVipLevel - 1
	else
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO230, "0"))
	end
	GetElement(self.m_root, "editBoxInputVip_WndSetEnemyCommunity", WZUIEditBox):setText(self.m_nVipLevel)
end

--@brief	点击确定按钮时被调用的函数
--@param	element:表绑定的UI节点引用
function WndSetEnemyCommunity:onSureBtn(element)
	WZLog("WndSetEnemyCommunity:onSureBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--获得审批方式
	local examine = GetElement(self.m_root, "checkBox_WndSetEnemyCommunity", WZUICheckBoxGroup):getCheckIndex()
	--获得入会等级
	local lv = GetElement(self.m_root, "editBoxInputLv_WndSetEnemyCommunity", WZUIEditBox):getText()
	--获得入会vip等级
	local vipLevel = GetElement(self.m_root, "editBoxInputVip_WndSetEnemyCommunity", WZUIEditBox):getText()

	if tonumber(lv) ~= nil then     --输入全是数字
		local setInput = tonumber(lv)		
		--输入是小数或整数
		if (math.floor(setInput) < setInput) or (setInput < 0) or setInput >= 100 then
			if setInput >= 100 then
				MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO63)
			else
				MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO48)
			end
	  	else
			--设置进入公会等级
			WZLog("公会设置", tonumber(lv), tonumber(examine), tonumber(vipLevel))
			ProtocolProcessorSceneCommunity:send_GUILD_GuildSetting(tonumber(lv), 0, tonumber(examine), tonumber(vipLevel))
	
			local guildInfo = CacheCenter:getGuildInfo()
			guildInfo.examine = tonumber(examine)
			guildInfo.setting = lv
			guildInfo.joinVipLevel = tonumber(vipLevel)
	  	end
	else  
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO48)
	end 

	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndSetEnemyCommunity, true)
	end 
end 

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
function WndSetEnemyCommunity:update()
	local examine = tonumber(CacheCenter:getGuildInfo().examine)
	self.m_nLv = tonumber(CacheCenter:getGuildInfo().setting)
	self.m_nVipLevel = tonumber(CacheCenter:getGuildInfo().joinVipLevel)
	local open_level = 15
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_9"] ~= nil then
		open_level = GDatatab_button_info["id_9"].open_level
	end
	if self.m_nLv < open_level then self.m_nLv = open_level end
	--设置审批方式
	GetElement(self.m_root, "checkBox_WndSetEnemyCommunity", WZUICheckBoxGroup):setCheckIndex(examine)
	--设置入会等级
	GetElement(self.m_root, "editBoxInputLv_WndSetEnemyCommunity", WZUIEditBox):setText(CacheCenter:getGuildInfo().setting)
	--设置入会vip等级
	GetElement(self.m_root, "editBoxInputVip_WndSetEnemyCommunity", WZUIEditBox):setText(self.m_nVipLevel)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@return	无
--@note		备注
function WndSetEnemyCommunity:_adaptLanguage_en()
	GetElement(self.m_root,"txtLv_WndSetEnemyCommunity",WZUILabelTTF):setScale(0.8)
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setScale(0.77)
	txtCheck1:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
	txtCheck2:setScale(0.8)
end

function WndSetEnemyCommunity:_adaptLanguage_th()
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
end

function WndSetEnemyCommunity:_adaptLanguage_vn()
	GetElement(self.m_root,"txtLv1_WndSetEnemyCommunity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLv_WndSetEnemyCommunity",WZUILabelTTF):setScale(0.8)
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setScale(0.8)
	txtCheck1:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setScale(0.8)
	txtCheck2:setRelativePosition(GlobalMethod:ccp(0.76,0.5))
end

function WndSetEnemyCommunity:_adaptLanguage_pt(  )
	local txtLv1 = GetElement(self.m_root,"txtLv1_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv1:setDimensions(GlobalMethod:CCSize(260,0))
	txtLv1:setScale(0.7)
	local txtLv = GetElement(self.m_root,"txtLv_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv:setDimensions(GlobalMethod:CCSize(260,0))
	txtLv:setScale(0.7)
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck1:setScale(0.8)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(130,0))
	txtCheck2:setScale(0.8)
end

function WndSetEnemyCommunity:_adaptLanguage_pt(  )
	local txtLv1 = GetElement(self.m_root,"txtLv1_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv1:setDimensions(GlobalMethod:CCSize(300,0))
	txtLv1:setScale(0.7)
	local txtLv = GetElement(self.m_root,"txtLv_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv:setDimensions(GlobalMethod:CCSize(300,0))
	txtLv:setScale(0.6)
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck1:setScale(0.8)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(130,0))
	txtCheck2:setScale(0.8)
end

function WndSetEnemyCommunity:_adaptLanguage_es(  )
	local txtLv1 = GetElement(self.m_root,"txtLv1_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv1:setDimensions(GlobalMethod:CCSize(300,0))
	txtLv1:setScale(0.7)
	local txtLv = GetElement(self.m_root,"txtLv_WndSetEnemyCommunity",WZUILabelTTF)
	txtLv:setDimensions(GlobalMethod:CCSize(300,0))
	txtLv:setScale(0.6)
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck1:setScale(0.8)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSetEnemyCommunity",WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(130,0))
	txtCheck2:setScale(0.8)
end
------------------------------------语言适配模块End----------------------------------------