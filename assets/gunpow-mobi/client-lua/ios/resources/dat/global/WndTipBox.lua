--WndTipBox.lua
--@brief	WndTipBox的UI模块
--@date		2013/12/18
--@author	xiaoyu_wu
--@note		提示框模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTipBox:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)--多语言版本界面适配
	self:_update()

end

--@brief	加载动画
function WndTipBox:onEnterTransitionDidFinish(element)
	local txtLength = GetElement(self.m_root,"txtTip_WndTipBox",WZUILabelTTF):getContentSize().width
	WZLog("文本长度",txtLength)
	if txtLength > 385 then
        local conList = GetElement(self.m_root,"conBg_WndTipBox",WZUIContainer)
        conList:setScaleX((txtLength+90)/475)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTipBox:onExit(element)
    element:disableSchedule()
	self:_unInit()
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		显示文本一段时间后逐渐消失
function WndTipBox:scheduleDisappear(element, delta)
	WZLog("WndTipBox:scheduleDisappear")
	element:disableSchedule()

end

--@brief	从消息队列中删除本消息
function WndTipBox:scheduleRemoveFromTeam(element, delta)
	WZLog("WndTipBox:scheduleRemoveFromTeam",self.m_bIsRemoveOne)
	element:disableSchedule()

	MsgBoxManager:_removeMsgByType(MSGBOXTYPE_TIPBOX,self.m_bIsRemoveOne)
end

--@brief	渐出动画完成时的回调方法
--@param	element:表绑定的UI节点引用
--@note		渐出动画完成后移出窗口
function WndTipBox:onFadeActionFinish(element)
    if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_TIMEOUT)
	end
    if self.m_root then
        self.m_root:removeFromParentAndCleanup(true)
    end
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	界面更新函数
--@note		根据消息数据生成提示框
function WndTipBox:_update()
	if self.m_root == nil or self.m_tMsgData == nil then
		return
	end
	
	local txtTip = self.m_root:getChildElement("txtTip_WndTipBox")
	if txtTip == nil then
		return
	end
	txtTip = WZUILabelTTF:luaTo(txtTip)
    local nStart = string.find(self.m_tMsgData.sMsgBody, "<T")
    if nStart == nil then
	   txtTip:setText(self.m_tMsgData.sMsgBody)
       txtTip:setVisible(true)
    else
        txtTip:setVisible(false)
        local ftxtTip = WZUIFreeTextBox:create()
        ftxtTip:setMaxWidth(470)
        local sContentTips = string.gsub(self.m_tMsgData.sMsgBody, "20", "22")
        ftxtTip:setShowText(sContentTips)
        GetElement(self.m_root, "conTop_WndTipBox", WZUIContainer):addChild(ftxtTip)
    end
    WZLog("self.m_tMsgData.sMsgBody:",string.len(self.m_tMsgData.sMsgBody))
	
	self.m_root:setVisible(true)

	self.m_root:enableSchedule("scheduleRemoveFromTeam", 1.07)
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief    英语适配
function WndTipBox:_adaptLanguage_en()
    -- body
    local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

function WndTipBox:_adaptLanguage_pt(  )
	local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

function WndTipBox:_adaptLanguage_es(  )
    local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

--@brief    英语适配
function WndTipBox:_adaptLanguage_th()
    -- body
    local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

--@brief    越南语适配
function WndTipBox:_adaptLanguage_vn()
    local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

function WndTipBox:_adaptLanguage_tr()
    -- body
    local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end

function WndTipBox:_adaptLanguage_es(  )
	local txtTip = GetElement(self.m_root, "txtTip_WndTipBox", WZUILabelTTF)
    if txtTip then
        txtTip:setFontSize(22)
        txtTip:setDimensions(GlobalMethod:CCSize(600))
    end
end
-------------------------------------语言适配模块End----------------------------------------