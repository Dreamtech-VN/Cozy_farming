--WndAnnouncement.lua
--@brief	WndAnnouncement的UI模块
--@date		2015/04/23
--@author	weidong_wu
--@modify   qixiang_xie
--@note		游戏公告页面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAnnouncement:onEnter(element)
	self.m_root = element
	--ProtocolProcessorWndActivityOnLine:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAnnouncement:onExit(element)
    GlobalGame.g_bIsActivityUIShow = false
    GlobalGame.g_AnnouncementNeedReaq = true 
	self:_unInit()
	--ProtocolProcessorWndActivityOnLine:unregAll()
end

--@brief    onenter函数已执行
function WndAnnouncement:onEnterTransitionDidFinish(element)
    WZLog("WndAnnouncement:onEnterTransitionDidFinish")
    self:actionCallback()
end

--@brief    弹窗动画完成后的回调
function WndAnnouncement:actionCallback()
    local title,content = g_gameNoticeInfo.title,g_gameNoticeInfo.content
    if title and content then
        self:GetAnnouncementOk(title,content)
    end
end

--@brief    弹窗动画完成后的回调
function WndAnnouncement:actionCallback_close(element,data)
    WZLog("WndAnnouncement:actionCallback_close = ",GlobalGame.g_bIsActivityUIShow)
    WindowManager:removeWindow(self.m_root , WndAnnouncement , true)
end

--@brief    关闭窗口
function WndAnnouncement:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tMsgData ~= nil then
        WZLog("************* WndAnnouncement:actionCallback_close *********")
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManager:removeWindow(self.m_root , WndAnnouncement , true)
end

--查看公告
function WndAnnouncement:onClickBtn(element)
    WZLog("WndAnnouncement:onClickBtn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    element = WZUIButton:luaTo(element)
    local tag = element:getTag()
    if self.m_eleCurSelNode then
        self.m_eleCurSelNode:setTouchEnable(true)
    end
    element:setTouchEnable(false)
    self.m_eleCurSelNode = element
    self.m_nCurrentPage = tag + 1
    self:_setMessagInfo()
end

function WndAnnouncement:show(title,content)
    WZLog("WndAnnouncement:show")
    local wndAnnounce = WndAnnouncement:createElement()
    WindowManager:addWindow(wndAnnounce , WndAnnouncement, nil, nil, nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  是否需要请求公告内容
function WndAnnouncement:_isNeedRequest()
	if PrefetchCache:hasBulletinList() then 
		return false 
	else 
		return true
	end 
	return false 
end

--@brief 设置公告内容信息
function WndAnnouncement:_setMessagInfo()
    WZLog("ListAnnouncementCount="..#self.m_tAnnounceList)

	local txtcontext_WndAnnouncement = GetElement(self.m_root,"txtcontext_WndAnnouncement",WZUIFreeTextBox)
	txtcontext_WndAnnouncement:setShowText(self.m_tAnnounceList[self.m_nCurrentPage].content)
    WZLog("WndAnnouncement:_setMessagInfo", self.m_tAnnounceList[self.m_nCurrentPage].content)
	self:_rollContainerLayer()
end

--@brief    说明文字滚动层
function WndAnnouncement:_rollContainerLayer()

    if self.m_root == nil then
        return
    end
    local txtcontext_WndAnnouncement = self.m_root:getChildElement("txtcontext_WndAnnouncement")
    if txtcontext_WndAnnouncement == nil then
        return
    end

    txtcontext_WndAnnouncement = WZUIFreeTextBox:luaTo(txtcontext_WndAnnouncement)
    --获得滚动容器
    local  txtSize = txtcontext_WndAnnouncement:getContentSize()
    local rollconExplanation_WndAnnouncement = GetElement(self.m_root,"rollconExplanation_WndAnnouncement",WZUIScrollContainer)
    if rollconExplanation_WndAnnouncement == nil then
        WZLog("rollconExplanation_WndAnnouncement is nil...")
        return
    end
    local  rollSize = rollconExplanation_WndAnnouncement:getAbsContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconExplanation_WndAnnouncement:getMoveElement()
    local size = moveElement:getRelativeSize()
    moveElement:setRelativeSize( CCSize( 1 , txtSize.height/rollSize.height ) )
    rollconExplanation_WndAnnouncement:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconExplanation_WndAnnouncement:getMinPosition().y)
    
end


--@brief   创建加载框
function WndAnnouncement:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndAnnouncement:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end
-------------------------------------私有方法模块End----------------------------------------
