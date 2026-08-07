--WndGameShare.lua
--@brief	WndGameShare的UI模块
--@date		2015-04-30
--@author	binshao
--@note		分享窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameShare:onEnter(element)
    WZLog("WndGameShare:onEnter")
	self.m_root = element
	self:_initMoreLanguage()
	self:_addList()
end

--@brief    弹窗动画完成后的回调
function WndGameShare:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndGameShare:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameShare:onExit(element)
    WZLog("WndGameShare:onExit")
	self:_unInit()
end

function WndGameShare:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndGameShare , true)--关闭设置窗口
end

-- @brief  关闭公告界面Btn
function WndGameShare:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
end

-- @brief 新浪分享
function WndGameShare:onBtnSinaShare( element )
	WZLog("*-*-*-**-*-*新浪分享*-*-*-*-*-*-*-*-")
	local url = ""
	--WZPush:openURL(url)
end

-- @brief 微信分享
function WndGameShare:onBtnWeChatShare( element )
	WZLog("*-*-*-**-*-*微信分享*-*-*-*-*-*-*-*-")
	local url = ""
	--WZPush:openURL(url)
end

--@brief	添加分享的借口
function WndGameShare:_addList()
	local elemtList = GetElement(self.m_root,"tabShareList_WndGameShare",WZUITableContainer)
	elemtList:cleanTable()
	for i = 1, 1 do 
		local cellActivity = WZUISystem:getInstance():createElement("conShare_CellGameShare")
        cellActivity:setTag(i - 1)
        elemtList:setCellElement(cellActivity)
        local icon1 = GetElement(cellActivity,"imgIcon1_CellGameShare",WZUIImage)
        local icon2 = GetElement(cellActivity,"imgIcon2_CellGameShare",WZUIImage)
        local name = GetElement(cellActivity,"txtName_CellGameShare",WZUILabelTTF)
	end
	elemtList:UpdateInsidePosition()
end

--@brief	初始化多语言版本
function WndGameShare:onBtnShare(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndGameShare:onBtnShare", element:getTag())
	MsgBoxManager:showTipBox("该功能未开启")
end

--@brief	初始化多语言版本
function WndGameShare:_initMoreLanguage()
	local txtSina = self.m_root:getChildElement("txtSina_WndGameShare")
	if txtSina ~= nil then
		WZUILabelTTF:luaTo(txtSina):setText("新浪")
	end

	local txtWechat= self.m_root:getChildElement("txtWeChat_WndGameShare")
	if txtWechat ~= nil then
		WZUILabelTTF:luaTo(txtWechat):setText("微信")
	end
end

-------------------------------------私有方法模块End----------------------------------------
