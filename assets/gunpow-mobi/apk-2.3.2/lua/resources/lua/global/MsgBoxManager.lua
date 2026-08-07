--MsgBoxManager.lua
--@brief	消息组件管理表对象
--@date  	2013/12/13
--@author 	xiaoyu_wu
--@note 	管理所有的说明框，加载框，确认框等

MsgBoxManager = {
	m_tHighLevelMsgList = {}, --高优先级消息队列
	m_tNormalLevelMsgList = {}, --中优先级消息队列
	m_tLowLevelMsgList = {}, --低优先级消息队列
	m_tTipBoxList = {},--淡入淡出提示队列

	m_nIdTag = 0, --记录当前最新的消息的id，用于生成新消息的id
	m_tMsgBoxElementList = {},	--正在处理的消息的界面节点引用,主键为消息表对象
	m_tMsgBoxLuaObjList = {}, --正在处理的消息的界面节点绑定的Lua表对象,主键为消息表对象

	m_tAutoLoadingBoxList = {}, --自动管理loading框列表
    
    m_nScheduleId = 0, --定时器id
	m_nTimePass = 0, --计时器
}

--单条消息的数据表,里面各种类型定义参见GlobalDefine中消息组件管理相关定义部分
MsgData = {
	nId = 0, --消息id
	nLevel = 0, --消息优先级
	nType = 0, --消息种类
	nTimeout = 0, --消息超时
	nStatus = 0, --消息状态
	sMsgBody = nil, --消息主体内容
	tCallbackLuaObj = nil, --消息完成后回调的表对象
	fCallbackFunc = nil, --消息完成后回调的方法，回调返回2个参数：
	--第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
	tCustomUIConfig = nil, --用于存储自定义界面的配置信息表，具体内容参见宏定义
	--例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
}

--@brief	创建一个新的消息数据表
--@return	#1,新的消息数据表
function MsgData:create()
	local tNewObj = {}
	setmetatable(tNewObj, MsgData)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块--------------------------------------
--@brief	初始化方法
--@note		游戏开始运行时调用
function MsgBoxManager:init()
	self.m_nIdTag = 0
	self.m_tHighLevelMsgList = {}
	self.m_tNormalLevelMsgList = {}
	self.m_tLowLevelMsgList = {}
	self.m_tMsgBoxElementList = {}
	self.m_tMsgBoxLuaObjList = {}
	self.m_tTipBoxList = {}--淡入淡出提示队列
	self.m_tAutoLoadingBoxList = {}
	if self.m_nScheduleId > 0 then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
		self.m_nScheduleId = 0
	end 
	self.m_nScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.mainLoop, 0, false)
end

--@brief	清空所有消息队列
function MsgBoxManager:clear()
	self.m_tHighLevelMsgList = {}
	self.m_tNormalLevelMsgList = {}
	self.m_tLowLevelMsgList = {}
	self.m_tMsgBoxElementList = {}
	self.m_tMsgBoxLuaObjList = {}
	self.m_tTipBoxList = {}--淡入淡出提示队列
	self.m_tAutoLoadingBoxList = {} --自动管理loading队列
end

--@brief	停止消息管理
function MsgBoxManager:stop()
    self.m_nIdTag = 0
	self.m_tHighLevelMsgList = {}
	self.m_tNormalLevelMsgList = {}
	self.m_tLowLevelMsgList = {}
	self.m_tMsgBoxElementList = {}
	self.m_tMsgBoxLuaObjList = {}
	self.m_tTipBoxList = {}--淡入淡出提示队列
	self.m_tAutoLoadingBoxList = {} --自动管理loading队列
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
	self.m_nScheduleId = 0
end

--@brief	显示确认框(只有一个确认按钮)
--@param	sMsgBody,消息主体内容
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
--@param 	bIsOnlyOneButton:true 只显示确定按钮，默认显示两个按钮
--@param 	RedAttText :不为nil显示红色字体提示，默认没有
--@param 	nTIme : 倒计时,时间到自动确定
--@param 	bIsManualConfirm : 若存在倒计时，结束后是否需要手动确认，默认为自动确认
--@return	#1,消息id
--@note		添加一条确认框消息到消息队列中
function MsgBoxManager:showConfirmBox(sMsgBody, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, bIsOnlyOneButton, RedAttText, isMust, fCallbackCancel, nTime, bIsManualConfirm)
	if sMsgBody == nil then
		WZLog("MsgBoxManager:showConfirmBox: sMsgBody is nil")
		return
	end

    WZLog("MsgBoxManager:showConfirmBox one", sMsgBody, type(fCallbackCancel))

	local bIsExist = self:_isMsgExistByType(MSGBOXTYPE_CONFIRM)
	if bIsExist == true and isMust ~= true then return end

	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	if nLevel == nil then
		nLevel = MSGBOXLEVEL_LOW
	end
	self.m_nIdTag = self.m_nIdTag + 1

	if bIsOnlyOneButton == nil or bIsOnlyOneButton == false then
		tMsg.bIsOnlyOneButton = false
	else
		tMsg.bIsOnlyOneButton = true
	end

	tMsg.RedAttText = RedAttText

	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = nLevel
	tMsg.nType = MSGBOXTYPE_CONFIRM
	tMsg.sMsgBody = sMsgBody
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = tCallbackLuaObj
	tMsg.fCallbackFunc = fCallbackFunc
	tMsg.fCallbackCancel = fCallbackCancel
	tMsg.tCustomUIConfig = tCustomUIConfig
	tMsg.nTime = nTime
	tMsg.bIsManualConfirm = bIsManualConfirm
	self:_pushMsg(tMsg)

	if TeachGroup1 and TeachGroup1.GROUP > 0 and TeachGroup1.GROUP ~= 20 then
		TeachGroup1:removeTeach()
		TeachGroup1:setTeachFinish(TeachGroup1.GROUP, -1)
	end
	return tMsg.nId
end

--@brief	显示删除角色二级(最终)提示框 - 不需加入队列，仅是一个弹框
--@param	sMsgBody,消息主体内容
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
--@param 	bIsOnlyOneButton:true 只显示确定按钮，默认显示两个按钮
--@param 	RedAttText :不为nil显示红色字体提示，默认没有
--@param 	nTIme : 倒计时,时间到自动确定
--@param 	nMsgType : 弹窗类型-默认:MSGBOXTYPE_CONFIRM
function MsgBoxManager:showWndConfirmBoxWithOtherWidget(sMsgBody, nLevel, tCustomUIConfig, bIsOnlyOneButton, RedAttText, nTime)
	WZLog("sun---MsgBoxManager:showWndConfirmBoxWithOtherWidget", GlobalGame.g_tPlayerInfo.nPlayerStatus, GlobalGame.g_tPlayerInfo.nUnregisterTime, os.time() - GlobalGame.g_tPlayerInfo.nUnregisterTime)

	if sMsgBody == nil then
		WZLog("MsgBoxManager:showWndConfirmBoxWithOtherWidget: sMsgBody is nil")
		--return
	end

	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	tMsg.bIsOnlyOneButton = bIsOnlyOneButton
	tMsg.nTime = nTime
	tMsg.RedAttText = false
	tMsg.nId = 999
	tMsg.nLevel = MSGBOXLEVEL_HIGH
	tMsg.nType = MSGBOXTYPE_CONFIRM
	tMsg.sMsgBody = sMsgBody
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = nil
	tMsg.fCallbackFunc = nil
	tMsg.fCallbackCancel = nil
	tMsg.tCustomUIConfig = nil
	tMsg.nPlayerStatus = GlobalGame.g_tPlayerInfo.nPlayerStatus
	--tMsg.bIsManualConfirm = true

	local wndConfirmBoxWithOtherWidget = WndConfirmBoxWithOtherWidget:createElement()
    if wndConfirmBoxWithOtherWidget ~= nil then
        WndConfirmBoxWithOtherWidget:setMsgData(tMsg)
        WindowManager:addWindow(wndConfirmBoxWithOtherWidget,WndConfirmBoxWithOtherWidget,nil,false)
    end
end

--@brief	显示确认取消框(有确认和取消两个按钮)
--@param	sMsgBody,消息主体内容
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
--@param 	sTicketMark: 礼钻不足不再提示标记
--@param 	itemId: 用于活力不足传进来消耗的增长活力的物品Id
--@return	#1,消息id
--@note		添加一条确认取消框到消息队列中
function MsgBoxManager:showConfirmCancelBox(sMsgBody, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, sTicketMark, itemId)
	-- if true then --确认取消框和确认框合并
 --        self:showConfirmBox(sMsgBody, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig)
 --        return
 --    end
    if sMsgBody == nil then
		WZLog("MsgBoxManager:showConfirmBox: sMsgBody is nil")
		return
	end

	local bIsExist = self:_isMsgExistByType(MSGBOXTYPE_CONFIRMCANCEL)
	if bIsExist == true then return end

	if g_bShowWndMsgConfirmBox ~= nil and sTicketMark then
		for k,v in pairs(g_bShowWndMsgConfirmBox) do
			--如果有保存这次提示的句子，直接返回
			WZLog("MsgBoxManager:showConfirmCancelBox",v)
			if v == sTicketMark then
				if tCallbackLuaObj then 
					fCallbackFunc(tCallbackLuaObj, self.m_nIdTag + 1, MSGBOXRESTYPE_CONFIRM)
				else
					fCallbackFunc(self.m_nIdTag + 1, MSGBOXRESTYPE_CONFIRM)
				end
				return 
			end
		end
	end

	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	if nLevel == nil then
		nLevel = MSGBOXLEVEL_LOW
	end
	self.m_nIdTag = self.m_nIdTag + 1

	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = nLevel
	tMsg.nType = MSGBOXTYPE_CONFIRMCANCEL
	tMsg.sMsgBody = sMsgBody
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = tCallbackLuaObj
	tMsg.fCallbackFunc = fCallbackFunc
	tMsg.tCustomUIConfig = tCustomUIConfig
	tMsg.checkMark = sTicketMark
	tMsg.costItemId = itemId
	self:_pushMsg(tMsg)
	return tMsg.nId, tMsg
end

--@brief	显示确认取消框(有确认和取消两个按钮和背景图，没有关闭)
--@param	sMsgBody,消息主体内容
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
--@param 	sOnlyAttKey:确认购买框的显示与否的唯一key；如果不为空，优先于sMsgBody
--@return	#1,消息id
--@note		添加一条确认取消框到消息队列中
function MsgBoxManager:showConfirmBoxWithBg(sMsgBody, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, sOnlyAttKey)
	WZLog("MsgBoxManager:showConfirmBoxWithBg", Serialize(g_bShowWndMsgConfirmBox))
	
    if sMsgBody == nil then
		WZLog("MsgBoxManager:showConfirmBox: sMsgBody is nil")
		return
	end

	local bIsExist = self:_isMsgExistByType(MSGBOXTYPE_HAVEBG)
	if bIsExist == true then return end
	local saveText = sMsgBody
	if sOnlyAttKey then 
		saveText = sOnlyAttKey
	end

	if g_bShowWndMsgConfirmBox ~= nil then
		for k,v in pairs(g_bShowWndMsgConfirmBox) do
			--如果有保存这次提示的句子，直接返回
			WZLog("MsgBoxManager:showConfirmBoxWithBg",v)
			if v == saveText then
				WZLog("已保存不弹出确认框")
				ISSHOW_USELEVEL = true
				fCallbackFunc(tCallbackLuaObj)
				return 
			end
		end
	end

	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	if nLevel == nil then
		nLevel = MSGBOXLEVEL_LOW
	end
	self.m_nIdTag = self.m_nIdTag + 1

	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = nLevel
	tMsg.nType = MSGBOXTYPE_HAVEBG
	tMsg.sMsgBody = sMsgBody
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = tCallbackLuaObj
	tMsg.fCallbackFunc = fCallbackFunc
	tMsg.tCustomUIConfig = tCustomUIConfig
	if sOnlyAttKey then
		tMsg.onlyAttKey = sOnlyAttKey
	end
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	显示加载框
--@param	nTimeout,超时,可赋空(使用默认超时时间)
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
--@return	#1,消息id
--@note		添加一条加载框消息到消息队列中
function MsgBoxManager:showLoadingBox(nTimeout, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, isNotRemoveTeach, text, isNoChangeWifi, isNoSwallowTouch)
	--没有时间的 使用默认的loading
	if not nTimeout then
		return -1
	end
	return self:createLoadingBox(nTimeout, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, isNotRemoveTeach, text, isNoChangeWifi, isNoSwallowTouch)
end

--@brief 创建loading遮挡
function MsgBoxManager:createLoadingBox(nTimeout, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig, isNotRemoveTeach, text, isNoChangeWifi, isNoSwallowTouch)
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	text = text or LocalStrings.WIFFTP1
	local loadingBoxText = g_tLoadingBox and g_tLoadingBox.m_root and GetElement(g_tLoadingBox.m_root,"conWifiOut_WndLoadingBox"):isVisible() and GetElement(g_tLoadingBox.m_root,"txtWifiOut_WndLoadingBox",WZUILabelTTF):getText() 
	if loadingBoxText and loadingBoxText ~= text then
		GetElement(g_tLoadingBox.m_root,"txtWifiOut_WndLoadingBox",WZUILabelTTF):setText(text)
	end

	if g_tLoadingBox and g_tLoadingBox.m_root then
		g_tLoadingBox.m_root:setTouchEnable(isNoSwallowTouch ~= true)
	end

	local bIsExist = self:_isMsgExistByType(MSGBOXTYPE_LOADING)
	WZLog("MsgBoxManager:showLoadingBox_one", tostring(g_tLoadingBox), tostring(g_tLoadingBox and g_tLoadingBox.m_root), tostring(g_tLoadingBox and g_tLoadingBox.m_root and GetElement(g_tLoadingBox.m_root,"conWifiOut_WndLoadingBox"):isVisible()), tostring(loadingBoxText), "text=", tostring(text), type(text), tostring(bIsExist))
	if bIsExist == true then return end

	if nTimeout == nil then
		nTimeout = 5
	end
	if nLevel == nil then
		nLevel = MSGBOXLEVEL_LOW
	end
	self.m_nIdTag = self.m_nIdTag + 1
    
    WZLog("MsgBoxManager:showLoadingBox_two", self.m_nIdTag, tostring(nTimeout), tostring(tCallbackLuaObj), tostring(fCallbackFunc), tostring(tCustomUIConfig))
	
--    self:_removeMsgByType(MSGBOXTYPE_LOADING)
    
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = nLevel
	tMsg.nType = MSGBOXTYPE_LOADING
	tMsg.nTimeout = nTimeout
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = tCallbackLuaObj
	tMsg.fCallbackFunc = fCallbackFunc
	tMsg.tCustomUIConfig = tCustomUIConfig
	tMsg.sText = text
	tMsg.bIsNoChangeWifi = isNoChangeWifi
	tMsg.bIsNoSwallowTouch = isNoSwallowTouch
	self:_pushMsg(tMsg)

    if isNotRemoveTeach ~= true then
        if TeachGroup1 and TeachGroup1.SCHEDULE then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
        end
        WindowManager:removeTeachShelterLayer()
        if TeachGroup1 then
            TeachGroup1:removeTeachAnim()
        end

        if WndTeachTalk then
            WndTeachTalk:removeWindow()
        end
    end

	return tMsg.nId
end

--@创建loading遮挡 带自动管理
function MsgBoxManager:createAutoLoadingBox(mainId,subId)
	if Protocol:isAutoLoadingMsgBox(mainId, subId) then
		local loadingId = self:createLoadingBox(5, nil, nil, nil, nil, true)
		if loadingId ~= nil then
			table.insert(self.m_tAutoLoadingBoxList,loadingId)	
		end
		WZLog("MsgBoxManager:protocolCallBack-1",mainId,subId,loadingId)
	end
end

--@创建loading遮挡 带自动管理
function MsgBoxManager:protocolCallBack()
	for i = #self.m_tAutoLoadingBoxList,1,-1 do
		local loadingId = self.m_tAutoLoadingBoxList[i]
		self:stopLoadingBoxByMsgId(loadingId)
		WZLog("MsgBoxManager:protocolCallBack-2",loadingId)
	end
	self.m_tAutoLoadingBoxList = {}
end

--@brief	弹出战斗力
function MsgBoxManager:showFightAni(msg)
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_LOW
	tMsg.nType = MSGBOXTYPE_FIGHTANI
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.sMsgBody = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出成功失败图片
function MsgBoxManager:showPopupResult(msg, x, y)
	WZLog("MsgBoxManager:showPopupResult")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_LOW
	tMsg.nType = MSGBOXTYPE_POPUPRESULT
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.sMsgBody = msg
	tMsg.x = x
	tMsg.y = y
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出成就
function MsgBoxManager:showAchie(msg)
	WZLog("MsgBoxManager:showAchie")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_LOW
	tMsg.nType = MSGBOXTYPE_DESIGNATION
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.sMsgBody = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出穿上装备框
function MsgBoxManager:showEquipDressUp(msg)
	WZLog("MsgBoxManager:showEquipDressUp", CacheCenter.m_tPlayerInfo.level)
	--黑店出现时不显示装备框
	if WndGangsterInn.m_root ~= nil then return end
    if CacheCenter.m_tPlayerInfo.level <= 3 or CacheCenter.m_tPlayerInfo.level == 8 and WndUpgrade.m_root then
        return
    end
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_LOW
	tMsg.nType = MSGBOXTYPE_EQUIPDRESSUP     
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)

	WZLog("MsgBoxManager:showEquipDressUp finish")
    GlobalGame.m_bIsShowEquipDressUp = true
	return tMsg.nId
end

--@brief	弹出签到
function MsgBoxManager:showSignIn(msg)
	WZLog("MsgBoxManager:showSignIn")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_LOW
	tMsg.nType = MSGBOXTYPE_SIGNIN     
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出公告
function MsgBoxManager:showAnnouncement(msg)
	WZLog("MsgBoxManager:showAnnouncement")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_ANNOUNCEMENT     
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出活动
function MsgBoxManager:showGameActivity(msg)
	WZLog("MsgBoxManager:showGameActivity")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_GAMEACTIVITY
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出福利
function MsgBoxManager:showWelfare(msg)
	WZLog("MsgBoxManager:showWelfare")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_WELFARE
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出回归活动
function MsgBoxManager:showReturneeActivity(msg)
	WZLog("MsgBoxManager:showReturneeActivity")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_RETURNEEACTIVITY
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end


--@brief 	弹出一周年活动
function MsgBoxManager:showNewActivity(msg)
	WZLog("MsgBoxManager:showNewActivity")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_NEWACTIVITY
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end
--@brief 	弹出回流活动活动
function MsgBoxManager:showReturnActivity(msg)
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_RETURNACTIVITY
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief 	弹出暑假活动
function MsgBoxManager:showSummerActivity(msg)
	WZLog("MsgBoxManager:showSummerActivity")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_SUMMACTIVITY
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出感恩打卡
function MsgBoxManager:showThankfulSign(msg)
	WZLog("MsgBoxManager:showThankfulSign")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_THANKFULSIGN     
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出欢迎回来
function MsgBoxManager:showWelcomeBack(msg)
	WZLog("MsgBoxManager:showWelcomeBack")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_WELCOMEBACK
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	弹出七周年签到
function MsgBoxManager:showSevenYear(msg)
	WZLog("MsgBoxManager:showSevenYear")
	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end
	self.m_nIdTag = self.m_nIdTag + 1
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_NORMAL
	tMsg.nType = MSGBOXTYPE_SEVENYEAR     
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tData = msg
	self:_pushMsg(tMsg)
	return tMsg.nId
end

--@brief	根据加载框消息id停止显示加载框
--@param	nId,加载框消息的id
--@note		从场景移出
function MsgBoxManager:stopLoadingBoxByMsgId(nId)
    if nId == nil then
        return
    end
	local tMsg, tList, nIndex = self:_getMsgById(nId)
	if tMsg == nil then
		return
	end
	local tLuaObj = self.m_tMsgBoxLuaObjList[tMsg]
	if tLuaObj ~= nil and tLuaObj.stopLoading ~= nil then --正在运行中
		tLuaObj:stopLoading()
	end
	self:_removeMsg(tList, nIndex)
end

--@brief	显示提示框(自动消失)
--@param	sMsgBody,消息主体内容
--@param	nDisappearDelay,消息消失延迟，可赋空(默认显示1秒)
--@param	tCallbackLuaObj,消息完成后回调的表对象,可赋空
--@param	fCallbackFunc,消息完成后回调的方法,可赋空.回调返回2个参数：
--			第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
--@param	nLevel,优先级,可赋空(默认加入Normal队列中)
--@param	tCustomUIConfig,用于存储自定义界面的配置信息表,具体内容参见宏定义
--			例如tCustomUIConfig[MSGBOXUICFG_CONFIRM] = "充值",将确认按钮的文本重命名为充值
-- @param	nOrder:界面的层次
-- isPos    自定义相对位置
--@return	#1,消息id
--@note		添加一条说明框消息到消息队列中
--提示框需求比较特殊，不再加入到消息队列中，单独处理
function MsgBoxManager:showTipBox(sMsgBody, nDisappearDelay, tCallbackLuaObj, fCallbackFunc, nLevel, tCustomUIConfig,nOrder,GrayRender, isRemoveOne, isPos)
	if sMsgBody == nil then
		WZLog("MsgBoxManager:showConfirmBox: sMsgBody is nil")
		return
	end

	local tMsg = MsgData:create()
	if tMsg == nil then
		return
	end

	if nDisappearDelay == nil then
		nDisappearDelay = 0.01
	end
	if nLevel == nil then
		nLevel = MSGBOXLEVEL_LOW
	end
	self.m_nIdTag = self.m_nIdTag + 1

	isPos = isPos or {x=0.5,y=0.5}
	tMsg.nId = self.m_nIdTag
	tMsg.nLevel = MSGBOXLEVEL_TIPBOX
	tMsg.nType = MSGBOXTYPE_TIPBOX
	tMsg.nTimeout = nDisappearDelay
	tMsg.sMsgBody = sMsgBody
	tMsg.nStatus = MSGBOXSTATUS_INIT
	tMsg.tCallbackLuaObj = tCallbackLuaObj
	tMsg.fCallbackFunc = fCallbackFunc
	tMsg.tCustomUIConfig = tCustomUIConfig
	tMsg.order = nOrder
	tMsg.GrayRender = GrayRender
    tMsg.isRemoveOne = isRemoveOne
    tMsg.isPos = isPos
    --提示框需求比较特殊，不再加入到消息队列中，单独处理
	self:_pushMsg(tMsg)
    --WndTipBox:setMsgData(tMsg)
    WZLog("MsgBoxManager:showTipBox" ,sMsgBody)
	return tMsg.nId
end

--@brief	根据消息id移除消息和消息框
--@param	nId,消息的id
function MsgBoxManager:removeMsgById(nId)
	local tMsg, tList, nIndex = self:_getMsgById(nId)
	if tMsg == nil then
		return
	end
	local tLuaObj = self.m_tMsgBoxLuaObjList[tMsg]
    local element = self.m_tMsgBoxElementList[tMsg]
	if tLuaObj ~= nil and element ~= nil then
		WindowManager:removeWindow(element, tLuaObj, true)
	end
	self:_removeMsg(tList, nIndex)
end

--@brief	消息管理主循环
--@note		初始化后开始循环处理消息队列
function MsgBoxManager:mainLoop()
	local self = MsgBoxManager

	local tMsgTip = self.m_tTipBoxList[1]
	if tMsgTip ~= nil then
    	if tMsgTip.nStatus == MSGBOXSTATUS_DONE then
    	    self:_popMsg(tMsgTip.nLevel)
    	elseif tMsgTip.nStatus == MSGBOXSTATUS_INIT then
    	    self:_showMsg(tMsgTip)
    	elseif tMsgTip.nStatus == MSGBOXSTATUS_DOING then
    	    local bIsValid = self:_checkDoingMsgIsValid(tMsgTip)
    	    if bIsValid == false then
    	        self:_popMsg(tMsgTip.nLevel)
    	    end
    	end
	end

	local tMsg = self:_getCurHighestPriorityMsg()
	if tMsg == nil then
		return
	end

    if tMsg.nStatus == MSGBOXSTATUS_DONE then
        self:_popMsg(tMsg.nLevel)
    elseif tMsg.nStatus == MSGBOXSTATUS_INIT then
        self:_showMsg(tMsg)
    elseif tMsg.nStatus == MSGBOXSTATUS_DOING then
        local bIsValid = self:_checkDoingMsgIsValid(tMsg)
        if bIsValid == false then
            self:_popMsg(tMsg.nLevel)
        end
    end
end

-------------------------------------私有方法模块--------------------------------------
--@brief	获取当前优先级最高的消息
--@return	#1,优先级最高的消息
--@note		先从高优先级队列中取第一个，如果没有则从中优先级队列中取第一个，再没有则从低优先队列中取第一个
function MsgBoxManager:_getCurHighestPriorityMsg()
	local tMsg = self.m_tHighLevelMsgList[1]
	if tMsg == nil then
		tMsg = self.m_tNormalLevelMsgList[1]
	end
	if tMsg == nil then
		tMsg = self.m_tLowLevelMsgList[1]
	end
	return tMsg
end

--@brief	根据优先级在对应队列尾部压入新消息
--@param	tMsg,要压入队列的消息
function MsgBoxManager:_pushMsg(tMsg)
	if tMsg.nLevel == MSGBOXLEVEL_TIPBOX then
		table.insert(self.m_tTipBoxList, tMsg)
	end
	if tMsg.nLevel == MSGBOXLEVEL_HIGH then
		table.insert(self.m_tHighLevelMsgList, tMsg)
	elseif tMsg.nLevel == MSGBOXLEVEL_NORMAL then
		table.insert(self.m_tNormalLevelMsgList, tMsg)
	elseif tMsg.nLevel == MSGBOXLEVEL_LOW then
		table.insert(self.m_tLowLevelMsgList, tMsg)
	end
end

--@brief	根据优先级删除对应队列头部的消息
--@param	nLevel,优先级
function MsgBoxManager:_popMsg(nLevel)
    WZLog("MsgBoxManager:_popMsg", nLevel)
	if nLevel == MSGBOXLEVEL_TIPBOX then
		self:_removeMsg(self.m_tTipBoxList, 1)
	end
	if nLevel == MSGBOXLEVEL_HIGH then
		self:_removeMsg(self.m_tHighLevelMsgList, 1)
	elseif nLevel == MSGBOXLEVEL_NORMAL then
		self:_removeMsg(self.m_tNormalLevelMsgList, 1)
	elseif nLevel == MSGBOXLEVEL_LOW then
		self:_removeMsg(self.m_tLowLevelMsgList, 1)
	end
end

--@brief	显示(执行)消息
--@param	tMsg,要压入队列的消息
function MsgBoxManager:_showMsg(tMsg)
	local boxElement = nil
	local tLuaObj = nil
	WZLog("MsgBoxManager:_showMsg0", tMsg.nType)
	if tMsg.nType == MSGBOXTYPE_CONFIRM then
		boxElement, tLuaObj = WndConfirmBox:createElement()
	elseif tMsg.nType == MSGBOXTYPE_CONFIRMCANCEL then
		boxElement, tLuaObj = WndConfirmCancelBox:createElement()
	elseif tMsg.nType == MSGBOXTYPE_LOADING then
		boxElement, tLuaObj = WndLoadingBox:createElement()
    elseif tMsg.nType == MSGBOXTYPE_HAVEBG then
		boxElement, tLuaObj = WndMsgConfirmBox:createElement()
	elseif tMsg.nType == MSGBOXTYPE_TIPBOX then
		boxElement, tLuaObj = WndTipBox:createElement()
		local isPos = tMsg.isPos or {}
		tMsg.x = isPos.x or 0.5
		tMsg.y = isPos.y or 0.5
		boxElement:setRelativePosition(GlobalMethod:ccp(tMsg.x,tMsg.y))
	elseif tMsg.nType == MSGBOXTYPE_FIGHTANI then
		boxElement, tLuaObj = WndFighting:createElement()
	elseif tMsg.nType == MSGBOXTYPE_POPUPRESULT then
		boxElement, tLuaObj = WndResult:createElement()
		boxElement:setRelativePosition(GlobalMethod:ccp(tMsg.x,tMsg.y))
	elseif tMsg.nType == MSGBOXTYPE_DESIGNATION then
		WndAchie:showAchieWithText(tMsg.sMsgBody.id, tMsg.sMsgBody.m_sTitle )
	elseif tMsg.nType == MSGBOXTYPE_GAMEACTIVITY then
		WndActivityIntegrate:showInterface(2)
	elseif tMsg.nType == MSGBOXTYPE_THANKFULSIGN then
		WndThankfulSign:showInterface(1, tMsg)
	elseif tMsg.nType == MSGBOXTYPE_WELCOMEBACK then
		WndWelcomeBackActivity:showInterface(1, tMsg)
	elseif tMsg.nType == MSGBOXTYPE_SEVENYEAR then
		WndSevenYear:showInterface(1, tMsg)
	elseif tMsg.nType == MSGBOXTYPE_WELFARE then
		WndActivityIntegrate:showInterface(1, nil, tMsg)
	elseif tMsg.nType == MSGBOXTYPE_EQUIPDRESSUP then  
		if WndRewardShow.m_root == nil and WndOpenChest.m_root == nil then
			WndDressUp:show(tMsg)
		end
		return
	elseif tMsg.nType == MSGBOXTYPE_NEWACTIVITY then
		WndNewActivity:showInterface()
	elseif tMsg.nType == MSGBOXTYPE_SUMMACTIVITY then
		WndSumVacAct:showInterface()
	elseif tMsg.nType == MSGBOXTYPE_RETURNEEACTIVITY then
		WndReturneeActivity:showInterface(6)
	elseif tMsg.nType == MSGBOXTYPE_RETURNACTIVITY then
		WndReturnActivityTips:showInterface()
	end
	
	if boxElement == nil or tLuaObj == nil then
		WZLog("*************** MSGBOXSTATUS_DONE **************")
		tMsg.nStatus = MSGBOXSTATUS_DONE
		return
	end
	tMsg.nStatus = MSGBOXSTATUS_DOING
	
	WZLog("MsgBoxManager:_showMsg1", tMsg.nType, type(tMsg.fCallbackCancel),tMsg.fCallbackCancel)
	tLuaObj:setMsgData(tMsg)
	--boxElement:setZOrder(tMsg.nLevel*100000)
	if tMsg.nType == MSGBOXTYPE_FIGHTANI then
		WindowManager:addWindow(boxElement, tLuaObj,nil,nil,nil,false) 
	elseif tMsg.nType == MSGBOXTYPE_POPUPRESULT then
		WindowManager:addWindow(boxElement, tLuaObj,nil,nil,true,false) 
	elseif tMsg.nType == MSGBOXTYPE_TIPBOX then
		local nOrder = 990000
		nOrder = tMsg.order or nOrder
    	WindowManager:getSceneRoot():addChild(boxElement,nOrder)
    else
		WindowManager:addWindow(boxElement, tLuaObj,nil,nil,nil,false) 
	end
	self.m_tMsgBoxElementList[tMsg] = boxElement
	self.m_tMsgBoxLuaObjList[tMsg] = tLuaObj
end

--@brief	检查正在进行的消息是否有效
--@param	tMsg,要检查的消息
--@return   #1,是否有效
function MsgBoxManager:_checkDoingMsgIsValid(tMsg)
    local tLuaObj = self.m_tMsgBoxLuaObjList[tMsg]
    if tLuaObj == nil or tLuaObj.m_root == nil then
        return false
    end
    return true
end

--@brief	根据id获取消息数据表
--@param	nId,消息id
--@return	#1,消息表对象
--@return	#2,消息所在的消息列表
--@return	#3,消息所在消息列表的位置
function MsgBoxManager:_getMsgById(nId)
	for i,v in ipairs(self.m_tTipBoxList) do
		if v.nId == nId then
			return v, self.m_tTipBoxList, i
		end
	end
	for i,v in ipairs(self.m_tHighLevelMsgList) do
		if v.nId == nId then
			return v, self.m_tHighLevelMsgList, i
		end
	end
	for i,v in ipairs(self.m_tNormalLevelMsgList) do
		if v.nId == nId then
			return v, self.m_tNormalLevelMsgList, i
		end
	end
	for i,v in ipairs(self.m_tLowLevelMsgList) do
		if v.nId == nId then
			return v, self.m_tLowLevelMsgList, i
		end
	end
end

--@brief	从队列中删除消息
--@param	tList,消息列表(高中低3个队列和提示队列)
--@param	nIndex,第几个
function MsgBoxManager:_removeMsg(tList, nIndex)
	--WZLog("MsgBoxManager:_removeMsg")
	local tMsg = tList[nIndex]
	if tMsg ~= nil and self.m_tMsgBoxElementList ~= nil then
		self.m_tMsgBoxElementList[tMsg] = nil
	end
	if tMsg ~= nil and self.m_tMsgBoxLuaObjList ~= nil then
		self.m_tMsgBoxLuaObjList[tMsg] = nil
	end
	table.remove(tList, nIndex)
end

--@brief	从队列中删除消息
--@param	nType,消息类型
function MsgBoxManager:_removeMsgByType(nType,bIsRemoveOne)
    local tbToRemove = {}
    
    for i,v in ipairs(self.m_tTipBoxList) do
        if v.nType == nType then 
            table.insert(tbToRemove, v)
            if bIsRemoveOne then
            	break
        	end
        end 
    end
    for i = #tbToRemove, 1, -1 do
        table.remove(self.m_tTipBoxList,i)
        if bIsRemoveOne then
            return
        end
    end
    
    tbToRemove = {}
    
    for i,v in ipairs(self.m_tHighLevelMsgList) do
        if v.nType == nType then 
            table.insert(tbToRemove, v)
            if bIsRemoveOne then
            	break
        	end
        end 
    end
--    for i,v in ipairs(tbToRemove) do
--        table.remove(self.m_tHighLevelMsgList,v)
--    end
    for i = #tbToRemove, 1, -1 do
        table.remove(self.m_tHighLevelMsgList,i)
        if bIsRemoveOne then
            return
        end
    end

    tbToRemove = {}
    
    for i,v in ipairs(self.m_tNormalLevelMsgList) do
        if v.nType == nType then 
            table.insert(tbToRemove, v)
            if bIsRemoveOne then
            	break
        	end
        end 
    end
--    for i,v in ipairs(tbToRemove) do
--        table.remove(self.m_tNormalLevelMsgList,v)
--    end
    for i = #tbToRemove, 1, -1 do
        table.remove(self.m_tNormalLevelMsgList,i)
        if bIsRemoveOne then
            return
        end
    end
    
    tbToRemove = {}
    
    for i,v in ipairs(self.m_tLowLevelMsgList) do
        if v.nType == nType then 
            table.insert(tbToRemove, v)
            if bIsRemoveOne then
            	break
        	end
        end 
    end
--    for i,v in ipairs(tbToRemove) do
--        table.remove(self.m_tLowLevelMsgList,v)
--    end
    for i = #tbToRemove, 1, -1 do
        table.remove(self.m_tLowLevelMsgList,i)
        if bIsRemoveOne then
            return
        end
    end
end

--@brief	判断列表中是否已经有该信息
--@param	nType,消息类型
function MsgBoxManager:_isMsgExistByType(nType)
    
    local bIsExist = false 
    
    for i,v in ipairs(self.m_tHighLevelMsgList) do
        if v.nType == nType then 
            bIsExist = true
            return bIsExist
        end 
    end

    for i,v in ipairs(self.m_tNormalLevelMsgList) do
        if v.nType == nType then 
            bIsExist = true
            return bIsExist
        end 
    end

    
    for i,v in ipairs(self.m_tLowLevelMsgList) do
        if v.nType == nType then 
            bIsExist = true
            return bIsExist
        end 
    end

    return bIsExist
end


