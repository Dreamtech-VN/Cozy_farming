--WndMasterTip.lua
--@brief	WndMasterTip的UI模块
--@date		2015/05/29
--@author	zsq
--@note		师徒系统弹框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterTip:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterTip:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndMasterTip:onClose(element)
	WZLog("WndMasterTip:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end 
end

--@brief	拒绝拜师/收徒
function WndMasterTip:onClose4(element)
	WZLog("WndMasterTip:onClose4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bReceivedRequest == true then
		--收到拜师/收徒消息弹窗
		ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_tData.id), 0 )
	end
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end 
end

--@brief	拜师/收徒
function WndMasterTip:onBaiShi(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_bReceivedRequest == true then
		--收到拜师/收徒消息弹窗
		ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_tData.id), 1 )
	else
		--取得编辑框文字
		local txtInPut = self:getEditBoxContent()
		if txtInPut == nil or txtInPut == "" then 
			MsgBoxManager:showTipBox(LocalStrings.INPUTDETAIL .. "!") 
			return 
		end 
		--发送拜师收徒消息
		local playerInfo = CacheCenter:getPlayerInfo()
		local id = self.m_tData.id
		--发送的消息添加拜师或收徒后缀标识
		txtInPut = g_MasterMessage_Mark .. txtInPut
		local textTable = {lv="Lv"..playerInfo.level,name=playerInfo.name,info=txtInPut,date=os.date("%m-%d %H:%M",os.time())}
		local text = json.encode(textTable)
		WZLog("WndMasterTip:onBaiShi",id,text)
		if playerInfo.level < MASTERLEVEL then
			--我的等级小于等于35,拜师
			self.m_tCurID = id
			self.m_tCurText = txtInPut
			self.m_tCurName = self.m_tData.name
			ProtocolProcessorWndMaster:send_MENTORING_Baishi(id, text )
		else
			--我的等级大于35,收徒
			self.m_tCurID = id
			self.m_tCurText = txtInPut
			self.m_tCurName = self.m_tData.name
			ProtocolProcessorWndMaster:send_MENTORING_Shoutu(id, text )
		end
		self.m_tChatInfo = {}
		self.m_tChatInfo.chatMsg = txtInPut
		self.m_tChatInfo.receivePlayerId = id
		self.m_tChatInfo.receivePlayerName = self.m_tData.name
		self.m_tChatInfo.receivePlayerSex = self.m_tData.sex
		self.m_tChatInfo.receivePlayerLevel = self.m_tData.level
		self.m_tChatInfo.receivePlayerVipLevel = self.m_tData.vipLevel
		self.m_tChatInfo.receivePlayerHead = self.m_tData.headId
		self.m_tChatInfo.receivePlayerFace = self.m_tData.faceId
		self.m_tChatInfo.receivePlayerHeadColor = self.m_tData.headColor
	end
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end 
end

function WndMasterTip:valInTable(val, table)
	if table == nil or val == nil then return false end
	for i=1,#table do
		if table[i] == val then return true end
	end
	return false
end

--@brief	取消解除关系
function WndMasterTip:onCancel(element)
	WZLog("WndMasterTip:onCancel")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end 
end

--@brief	确认解除关系
function WndMasterTip:onComfirm(element)
	WZLog("WndMasterTip:onComfirm")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndMaster:send_MENTORING_Disassociate(self.m_tData.id, 0)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end 
end

--@brief	使用钻石解除关系
function WndMasterTip:onRemove(element)
	WZLog("WndMasterTip:onRemove")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local level = CacheCenter:getPlayerInfo().level
	local cost = 0
	if level >= MASTERLEVEL then
		cost = tonumber(CacheCenter:getGameParam().JCTDGX)
	else
		cost = tonumber(CacheCenter:getGameParam().JCSFGX)
	end

	if CacheCenter:getGameParam().isUseTicket == "0" then
		if not JudgeMoneyIsEnough(70, cost, nil, nil, Chat_Channel_Master_Apprentice, nil, nil, nil, nil, self, self.clickSureMoney) then
			return 
		end
	else
		if not JudgeMoneyIsEnough(1, cost, nil, nil, Chat_Channel_Master_Apprentice, nil, nil, nil, nil, self, self.clickSureMoney) then
			return 
		end
	end

	 self:clickSureMoney()
end

--@brief	点击确定充值回调
function WndMasterTip:clickSureMoney()
	ProtocolProcessorWndMaster:send_MENTORING_Disassociate(self.m_tData.id, 1)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndMasterTip, true)
	end
end

--@brief	查看请求人物信息
function WndMasterTip:onCheck(element)
	WZLog("WndMasterTip:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end

--@brief	设置编辑框内容的函数
--@return	 sTxtContent  输入内容
function WndMasterTip:setEditBoxContent(sTxtContent)
	if self.m_root == nil  then 
		return 
	end 
   	GetElement(self.m_root, "editBox_WndMasterTip", WZUIEditBox):setText(sTxtContent)
end 

--@brief	取得编辑框内容的函数
--@return	 sTxtContent  输入内容
function WndMasterTip:getEditBoxContent()
	if self.m_root == nil  then 
		return 
	end 
	
	return GetElement(self.m_root, "editBox_WndMasterTip", WZUIEditBox):getText()
end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	窗口显示奖励内容
--@param    tData:数据,nType:弹窗类型
--@param    nType:1拜师弹窗2收徒弹窗3解除关系4师德升级5离线两天后解除关系
function WndMasterTip:showByType(tData,nType)
	if self.m_root == nil then
		local Wnd = WndMasterTip:createElement()
	    WindowManager:addWindow(Wnd , WndMasterTip,nil,nil,nil,true)
	end

	for i=1,5 do
   		GetElement(self.m_root, "con"..i.."_WndMasterTip", WZUIContainer):setVisible(false)
	end
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndMasterTip", WZUI9Image)
	if imgCostIcon1 then
		if CacheCenter:getGameParam().isUseTicket == "0" then
			imgCostIcon1:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon1:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon1:setScale(0.5)
	end

	self.m_tData = tData
	if nType == 1 then
    	GetElement(self.m_root, "con1_WndMasterTip", WZUIContainer):setVisible(true)
		local randomId = math.random(6,10)
		local info = LocalStrings["MASTERINFO"..randomId]
		self:setEditBoxContent(info)
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO18)
		--设置按钮文字
    	GetElement(self.m_root, "txtBtnName1_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO18)
		--设置拜师文字
    	GetElement(self.m_root, "txtDesc_WndMasterTip", WZUILabelTTF):setText(string.format(LocalStrings.MASTERINFO29,LocalStrings.MASTER))
	elseif nType == 2 then
    	GetElement(self.m_root, "con1_WndMasterTip", WZUIContainer):setVisible(true)
		local randomId = math.random(11,15)
		local info = LocalStrings["MASTERINFO"..randomId]
		self:setEditBoxContent(info)
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO19)
		--设置按钮文字
    	GetElement(self.m_root, "txtBtnName1_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO19)
		--设置收徒文字
    	GetElement(self.m_root, "txtDesc_WndMasterTip", WZUILabelTTF):setText(string.format(LocalStrings.MASTERINFO29,LocalStrings.APPRENTICE))
	elseif nType == 3 then
		local level = CacheCenter:getPlayerInfo().level
		local info = ""
		if level >= MASTERLEVEL then
			info = string.format(LocalStrings.MASTERINFO17,tData.name,48,LocalStrings.MASTERINFO19)
    		GetElement(self.m_root, "txtBtnName1_WndRewardShow", WZUILabelTTF):setText(CacheCenter:getGameParam().JCTDGX)
		else
			info = string.format(LocalStrings.MASTERINFO17,tData.name,24,LocalStrings.MASTERINFO18)
    		GetElement(self.m_root, "txtBtnName1_WndRewardShow", WZUILabelTTF):setText(CacheCenter:getGameParam().JCSFGX)
		end
    	GetElement(self.m_root, "con2_WndMasterTip", WZUIContainer):setVisible(true)
    	GetElement(self.m_root, "txtDesc2_WndMasterTip", WZUIFreeTextBox):setShowText(info)
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO20)
	elseif nType == 4 then
   		GetElement(self.m_root, "conBg", WZUIContainer):setVisible(false)
    	GetElement(self.m_root, "con3_WndMasterTip", WZUIContainer):setVisible(true)
		--tData = {}
		--tData.level = "2"
		WZLog(tData.level)
		local masterInfo = GDatatab_morality["id_"..tData.level]
		local infoNext = GDatatab_morality["id_"..(tonumber(tData.level)+1)]
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO21)
		local levelUp = [[<T C="236,209,108" S="20">Lv%d   </T><I Z="1">ui/common/common_icon_jiantou3.png</I><T C="99,255,95" S="20">   Lv%d</T>]]
    	GetElement(self.m_root, "con3Level", WZUILabelAtlasFont):setText((tData.level - 1))
    	GetElement(self.m_root, "con3LevelUp", WZUILabelAtlasFont):setText((tData.level))
		local txt1 = LocalStrings.MASTERINFO41
    	GetElement(self.m_root, "con3Txt1", WZUIFreeTextBox):setShowText(string.format(txt1,masterInfo.max_pupil))
		local txt2 = LocalStrings.MASTERINFO42
    	GetElement(self.m_root, "con3Txt2", WZUIFreeTextBox):setShowText(string.format(txt2,masterInfo.title))
		local txt3 = LocalStrings.MASTERINFO43
    	GetElement(self.m_root, "con3Txt3", WZUIFreeTextBox):setShowText(string.format(txt3,ATTR_TITLE[masterInfo.buff[1][1]],masterInfo.buff[1][2],ATTR_TITLE[masterInfo.buff[2][1]],masterInfo.buff[2][2],ATTR_TITLE[masterInfo.buff[3][1]],masterInfo.buff[3][2]))
		local txt4 = LocalStrings.MASTERINFO44
    	GetElement(self.m_root, "con3Txt4", WZUIFreeTextBox):setShowText(string.format(txt4,ATTR_TITLE[masterInfo.pupil_buff[1][1]],masterInfo.pupil_buff[1][2],ATTR_TITLE[masterInfo.pupil_buff[2][1]],masterInfo.pupil_buff[2][2],ATTR_TITLE[masterInfo.pupil_buff[3][1]],masterInfo.pupil_buff[3][2]))
	elseif nType == 5 then
		local level = CacheCenter:getPlayerInfo().level
		local info = string.format(LocalStrings.MASTERINFO59,tData.name)
    	GetElement(self.m_root, "con5_WndMasterTip", WZUIContainer):setVisible(true)
    	GetElement(self.m_root, "txtDesc3_WndMasterTip", WZUIFreeTextBox):setShowText(info)
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO20)
	end
end

--@brief	收到拜师/收徒请求时弹窗
--@param    tData:数据,nType:弹窗类型
--@param    1:收徒消息,2:拜师消息
function WndMasterTip:receivedRequest(tData,nType)
	if self.m_root == nil then
		local Wnd = WndMasterTip:createElement()
	    WindowManager:addWindow(Wnd , WndMasterTip,nil,nil,nil,true)
	end

	self.m_tData = tData
	self.m_bReceivedRequest = true

	for i=1,4 do
   		GetElement(self.m_root, "con"..i.."_WndMasterTip", WZUIContainer):setVisible(false)
	end
   	GetElement(self.m_root, "con4_WndMasterTip", WZUIContainer):setVisible(true)

	self.m_tData = tData
	if nType == 1 then
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO19..LocalStrings.MASTERINFO30)
	elseif nType == 2 then
		--设置标题
    	GetElement(self.m_root, "title_WndMasterTip", WZUILabelTTF):setText(LocalStrings.MASTERINFO18..LocalStrings.MASTERINFO30)
	end

	--设置等级
   	GetElement(self.m_root, "ttf1Con4_WndMasterTip", WZUILabelTTF):setText(LocalStrings.LV..tData.level)
	--设置名字
   	GetElement(self.m_root, "ttf2Con4_WndMasterTip", WZUILabelTTF):setText(tData.name)
	--设置消息
	local tMessage = json.decode(tData.message)
   	GetElement(self.m_root, "ttf3Con4_WndMasterTip", WZUILabelTTF):setText(tMessage.info)
	--设置头像
	CellHead:show(GetElement(self.m_root, "conHeadCon4_WndMasterTip", WZUIContainer),tData.headId,tData.faceId,tData.sex)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------------
function WndMasterTip:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(350,0))
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(390)
end

function WndMasterTip:_adaptLanguage_en(  )
	local txt = GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(360,0))
	txt:setFontSize(16)

	local txt1 = GetElement(self.m_root,"txtBtnName1_WndMasterTip",WZUILabelTTF)
	txt1:setFontSize(20)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtBtnName1_WndRewardShow",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtBtnName2_WndRewardShow",WZUILabelTTF):setFontSize(17)
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(390)
end

function WndMasterTip:_adaptLanguage_pt(  )
	local txt = GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(330,0))
	txt:setFontSize(16)

	local txt1 = GetElement(self.m_root,"txtBtnName1_WndMasterTip",WZUILabelTTF)
	txt1:setFontSize(20)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtBtnName1_WndRewardShow",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtBtnName2_WndRewardShow",WZUILabelTTF):setFontSize(17)
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(400)
	txtDesc:setScale(0.88)
end

function WndMasterTip:_adaptLanguage_vn(  )
	local txt = GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF)
	txt:setFontSize(16)
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(390)
	GetElement(self.m_root,"txtBtnName1_WndRewardShow",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtBtnName2_WndRewardShow",WZUILabelTTF):setFontSize(17)
	local txtDesc1 = GetElement(self.m_root,"txtDesc3_WndMasterTip",WZUIFreeTextBox)
	txtDesc1:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc1:setMaxWidth(390)
	local con3Txt4 = GetElement(self.m_root,"con3Txt4",WZUIFreeTextBox)
	con3Txt4:setScale(0.73)
	con3Txt4:setMaxWidth(500)
	local con3Txt3 = GetElement(self.m_root,"con3Txt3",WZUIFreeTextBox)
	con3Txt3:setScale(0.73)
	con3Txt3:setMaxWidth(500)
end

function WndMasterTip:_adaptLanguage_tr(  )
	local txt = GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(330,0))
	txt:setFontSize(16)

	local txt1 = GetElement(self.m_root,"txtBtnName1_WndMasterTip",WZUILabelTTF)
	txt1:setFontSize(20)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtBtnName1_WndRewardShow",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtBtnName2_WndRewardShow",WZUILabelTTF):setFontSize(17)
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(440)
	txtDesc:setScale(0.83)
end

function WndMasterTip:_adaptLanguage_es(  )
	local txt = GetElement(self.m_root,"txtDesc_WndMasterTip",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(330,0))
	txt:setFontSize(16)

	local txt1 = GetElement(self.m_root,"txtBtnName1_WndMasterTip",WZUILabelTTF)
	txt1:setFontSize(20)
	txt1:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtBtnName1_WndRewardShow",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBtnName2_WndRewardShow",WZUILabelTTF):setScale(0.6)
	local txtDesc = GetElement(self.m_root,"txtDesc2_WndMasterTip",WZUIFreeTextBox)
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.018,0.95))
	txtDesc:setMaxWidth(440)
	txtDesc:setScale(0.8)

	GetElement(self.m_root,"txtDesc3_WndMasterTip",WZUIFreeTextBox):setScale(0.8)
end
-------------------------------------语言适配End-------------------------------------------------