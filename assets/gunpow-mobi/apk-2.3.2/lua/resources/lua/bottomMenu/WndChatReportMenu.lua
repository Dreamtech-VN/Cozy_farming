--WndChatReportMenu.lua
--@brief	WndChatReportMenu的UI模块
--@date		2019/08/14
--@author	Tianxiang_Xu
--@note		举报按钮


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChatReportMenu:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChatReportMenu:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成
function WndChatReportMenu:onEnterTransitionDidFinish(element)
	--body
	WndChat:stopFrashMsgList()
end

--@brief 	关闭举报按钮
function WndChatReportMenu:closeMenuWin()
	-- body
	if self.m_root then 
		self.m_root:removeFromParentAndCleanup(true)
	end

	WndChat:stopFrashMsgList()
end


--@brief 	点击举报
function WndChatReportMenu:onClickReport(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tClickMsgData == nil then return end 

	if ProjConfig.LANGUAGE == "cn" then
		WndChatReport:showInterface(WndChat.m_root, self.m_tClickMsgData)
	else
		MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT1)
	end
	self:closeMenuWin()
end

--@brief 	点击复制
function WndChatReportMenu:onClickCopy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tClickMsgData == nil then return end 

	local edit = WndChat:_getCurEditBox()
	if edit then
		edit:setText(self.m_tClickMsgData.content)
	end
	self:closeMenuWin()
end

--@brief	检查坐标点是否在VIP按钮范围内
--@param	pt:鼠标点击的世界坐标
--@return	在按钮范围内返回true,否则返回false
function WndChatReportMenu:checkPointInBtn(pt)
	WZLog("WndChatReportMenu:checkPoint")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, "conBtnReport_WndChatReportMenu", WZUIContainer)

	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("获得btn 世界坐标",ptA.x,ptA.y)
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false
	end 

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
