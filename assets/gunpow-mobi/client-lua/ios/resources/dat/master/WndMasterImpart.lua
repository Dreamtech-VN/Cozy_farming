--WndMasterImpart.lua
--@brief	WndMasterImpart的UI模块
--@date		2016/07/23
--@author	zsq
--@note		师傅授业


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterImpart:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	加载动画
function WndMasterImpart:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	加载动画完
function WndMasterImpart:actionCallback()

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterImpart:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndMasterImpart:onClose(element)
	WZLog("WndMasterTip:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterImpart, true)
	end 
end

--@brief	授业按钮
function WndMasterImpart:onImpart(element)
	WZLog("WndMasterImpart:onImpart")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--没有徒弟在线不能授业
	if self.m_nExp == nil or self.m_nExp == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO77)
		return
	end
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	--冷却时间
	WZLog("冷却时间",SystemTime:getServerTime(),masterInfo.lastTime,(SystemTime:getServerTime() - masterInfo.lastTime),CacheCenter:getGameParam().shouyeCoolTime)
	if (SystemTime:getServerTime() - masterInfo.lastTime) <= tonumber(CacheCenter:getGameParam().shouyeCoolTime) then
		local lastTime = CacheCenter:getGameParam().shouyeCoolTime - (SystemTime:getServerTime() - masterInfo.lastTime)
		MsgBoxManager:showTipBox(math.ceil(lastTime/60)..LocalStrings.MASTERINFO73)
		return
	end
	--次数限制
	WZLog("次数限制",masterInfo.honorTime,CacheCenter:getGameParam().shouyeNum)
	if tonumber(masterInfo.honorTime) >= tonumber(CacheCenter:getGameParam().shouyeNum) then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO74)
		return
	end
	ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
	--ProtocolProcessorWndMaster:send_MENTORING_ShouYe()
end

--@brief	授业回调
function WndMasterImpart:onImpartCall()
	WZLog("WndMasterImpart:onImpartCall",WndMasterMember.m_nOnlineNum)
	if self.m_root == nil then return end
	self:update()

	--在线徒弟为0不能授业
	if WndMasterMember.m_nOnlineNum == nil or WndMasterMember.m_nOnlineNum == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO77)
		return
	end
	ProtocolProcessorWndMaster:send_MENTORING_ShouYe()
	--发送私聊
	if WndMasterMember.m_tMyPupils == nil or #WndMasterMember.m_tMyPupils == 0 then return end
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	local moralityLevel = masterInfo.moralityLevel
	local shouyeExp = tonumber(CacheCenter:getGameParam().shouyeExp) * moralityLevel
	for i = 1,#WndMasterMember.m_tMyPupils do 
		local tData = WndMasterMember.m_tMyPupils[i]
		if tData.isOnline == true then 
			WndChat:sendChat(CHANNEL_WHISPER,string.format(LocalStrings.MASTERINFO78,shouyeExp),tData.id,tData.name,tData.sex,tData.level,tData.vipLevel,tData.headId,tData.faceId,tData.headColor)
		end
	end 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMasterImpart:update(element)
	WZLog("WndMasterTip:update")
	self.m_nExp = 0
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end

	local moralityLevel = masterInfo.moralityLevel
	local moralityExp = masterInfo.moralityExp
	local exp = 0
	if tonumber(moralityLevel) < 10 then
		exp = GDatatab_morality["id_"..(moralityLevel+1)].exp
	end
	--称号
	if tonumber(moralityLevel) ~= 0 then
		local tMaster = GDatatab_morality["id_"..(moralityLevel)]
		GetElement(self.m_root,"title_MasterImpart",WZUILabelTTF):setText(tMaster.title)
	end
    --设置当前显示师德等级
	GetElement(self.m_root,"numIcon_MasterImpart",WZUILabelAtlasFont):setText(moralityLevel)
	if tonumber(moralityLevel) == 0 then
		GetElement(self.m_root,"numIcon_MasterImpart",WZUILabelAtlasFont):setText(1)
	end
	--设置师德经验
	GetElement(self.m_root, "expPer_MasterImpart", WZUILabelTTF):setText(moralityExp.."/"..exp)
	if tonumber(moralityLevel) >= 10 then
		GetElement(self.m_root, "expPer_MasterImpart", WZUILabelTTF):setText(moralityExp.."/max")
	end
	--设置经验条
	if tostring(exp) ~= "0" then
		local percent = tonumber(moralityExp)*100/tonumber(exp)
		GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setPercentage(percent)
	else
		GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setPercentage(0)
	end

	local shouyeShide = tonumber(CacheCenter:getGameParam().shouyeShide)
	local shouyeExp = tonumber(CacheCenter:getGameParam().shouyeExp) * moralityLevel
	local onlineNum = tonumber(WndMasterMember.m_nOnlineNum)
	local shouyeXiShu = tonumber(CacheCenter:getGameParam().shouyeXiShu)
	if shouyeShide == nil then shouyeShide = 2 end
	if shouyeExp == nil then shouyeExp = 1000 end
	self.m_nExp = shouyeShide*onlineNum
	GetElement(self.m_root,"freeText1",WZUIFreeTextBox):setShowText(string.format(LocalStrings.MASTERINFO62,shouyeShide*onlineNum,onlineNum,5))
	GetElement(self.m_root,"freeText2",WZUIFreeTextBox):setShowText(string.format(LocalStrings.MASTERINFO63,shouyeExp,shouyeExp*shouyeXiShu/100,moralityLevel))

	--倒计时
   	self.m_root:enableSchedule("countDown",1)
end

--@brief	授业倒计时
function WndMasterImpart:countDown()
	local masterInfo = CacheCenter:getMasterInfo()
	local countDown = CacheCenter:getGameParam().shouyeCoolTime - (SystemTime:getServerTime() - masterInfo.lastTime)
	--if masterInfo ~= nil and masterInfo.lastTime ~= nil and CacheCenter:getGameParam().shouyeCoolTime ~= nil and
	--		(SystemTime:getServerTime() - masterInfo.lastTime) <= tonumber(CacheCenter:getGameParam().shouyeCoolTime) then
   	--	self.m_root:enableSchedule("countDown",1)
	--end
	if countDown <= 0 then
		if CacheCenter:getGameParam().shouyeNum ~= nil then
			local lastTime = CacheCenter:getGameParam().shouyeNum - masterInfo.honorTime
			GetElement(self.m_root,"freeText3",WZUIFreeTextBox):setShowText(string.format(LocalStrings.MASTERINFO72,lastTime))
		end
		return
	end
	local min = math.floor(countDown / 60)
	if min < 10 then min = "0"..min end
	local sec = countDown % 60
	if sec < 10 then sec = "0"..sec end
	GetElement(self.m_root,"freeText3",WZUIFreeTextBox):setShowText(string.format(LocalStrings.MASTERINFO64,min..":"..sec))
end



-------------------------------------私有方法模块End----------------------------------------

--------------------------------------------------语言适配Begin--------------------------------
function WndMasterImpart:_adaptLanguage_en(  )
	GetElement(self.m_root,"freeText1",WZUIFreeTextBox):setMaxWidth(600)
	local txt = GetElement(self.m_root,"freeText2",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.04,0.37))
	txt:setMaxWidth(550)

	local title = GetElement(self.m_root,"title_MasterImpart",WZUILabelTTF)
	title:setRelativePosition(GlobalMethod:ccp(0.75,0.85))

	GetElement(self.m_root,"progressBg_MasterImpart",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"expPer_MasterImpart",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.86541,0.529728))
end

function WndMasterImpart:_adaptLanguage_pt(  )
	GetElement(self.m_root,"freeText1",WZUIFreeTextBox):setMaxWidth(600)
	local txt = GetElement(self.m_root,"freeText2",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.04,0.37))
	txt:setMaxWidth(550)

	local title = GetElement(self.m_root,"title_MasterImpart",WZUILabelTTF)
	title:setRelativePosition(GlobalMethod:ccp(0.75,0.85))

	GetElement(self.m_root,"progressBg_MasterImpart",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"expPer_MasterImpart",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.86541,0.529728))
end

function WndMasterImpart:_adaptLanguage_th(  )
	GetElement(self.m_root,"progressBg_MasterImpart",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"expPer_MasterImpart",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.86541,0.529728))
	GetElement(self.m_root,"freeText1",WZUIFreeTextBox):setScale(0.76)
	GetElement(self.m_root,"freeText2",WZUIFreeTextBox):setScale(0.78)
end

function WndMasterImpart:_adaptLanguage_vn(  )
	local freeText1 = GetElement(self.m_root,"freeText1",WZUIFreeTextBox)
	freeText1:setScale(0.9)
	freeText1:setRelativePosition(GlobalMethod:ccp(0.04,0.6))
	freeText1:setMaxWidth(600)
	local freeText2 = GetElement(self.m_root,"freeText2",WZUIFreeTextBox)
	freeText2:setScale(0.9)
	freeText2:setRelativePosition(GlobalMethod:ccp(0.04,0.362))
	freeText2:setMaxWidth(600)
end

function WndMasterImpart:_adaptLanguage_tr(  )
	GetElement(self.m_root,"freeText1",WZUIFreeTextBox):setMaxWidth(550)
	local txt = GetElement(self.m_root,"freeText2",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.04,0.37))
	txt:setMaxWidth(550)

	local title = GetElement(self.m_root,"title_MasterImpart",WZUILabelTTF)
	title:setRelativePosition(GlobalMethod:ccp(0.75,0.85))

	GetElement(self.m_root,"progressBg_MasterImpart",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"progrExpProgress_MasterImpart",WZUIProgress):setRelativePosition(GlobalMethod:ccp(0.884732,0.529728))
	GetElement(self.m_root,"expPer_MasterImpart",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.86541,0.529728))
end

function WndMasterImpart:_adaptLanguage_es(  )
	local freeText1 = GetElement(self.m_root,"freeText1",WZUIFreeTextBox)
	freeText1:setMaxWidth(600)
	freeText1:setScale(0.8)

	local txt = GetElement(self.m_root,"freeText2",WZUIFreeTextBox)
	txt:setRelativePosition(GlobalMethod:ccp(0.04,0.37))
	txt:setMaxWidth(550)
	txt:setScale(0.8)
end
--------------------------------------------------语言适配End-------------------------------------