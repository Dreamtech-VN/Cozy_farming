--WndChangeSex.lua
--@brief	WndChangeSex的UI模块
--@date		2018/01/08
--@author	zsq
--@note		变性确认


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChangeSex:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndChangeSex:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
end

function WndChangeSex:actionCallback( )
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChangeSex:onExit(element)
	self:_unInit()
end

function WndChangeSex:show()
	WZLog("WndChangeSex:show")
	local wnd = WndChangeSex:createElement()
	WindowManager:addWindow(wnd, WndChangeSex, nil)
end

function WndChangeSex:onCancel(element)
	WZLog("WndChangeSex:onCancel")
    WindowManager:removeWindow(self.m_root , self , true)
end

function WndChangeSex:onConfirm(element)
	WZLog("WndChangeSex:onConfirm")
	if not self.rule1 then
		MsgBoxManager:showTipBox(LocalStrings.CHANGESEX6)
		return
	end
	if not self.rule2 then
		MsgBoxManager:showTipBox(LocalStrings.CHANGESEX7)
		return
	end

	local tData = CacheCenter:getPlayerItemById(31)
	if tData == nil then return end
	self.changeSex = true
	ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(tData.playerItemId, 1, "")
    WindowManager:removeWindow(self.m_root , self , true)
end

function WndChangeSex:changeSuccess()
	if self.changeSex == true then
		self.changeSex = false
		MsgBoxManager:showTipBox(LocalStrings.CHANGESEX8)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndChangeSex:update( )
	WZLog("WndChangeSex:update")
	local color1 = "255,89,74"
	local desc1 = ""
	local color2 = "255,89,74"
	local desc2 = ""
	--是否单身
	if CacheCenter:getPlayerInfo().marryFlag == 0 then
		color1 = "5,180,0"	
		desc1 = LocalStrings.CHANGESEX2
	else
		color1 = "255,89,74"	
		desc1 = LocalStrings.CHANGESEX3
	end
	--是否领取完附件
	local tMailList = CacheCenter:getMailList()
	local hasAttachment = false
	for i=1,#tMailList do
		--if tMailList[i].attachments ~= "" then
		if tMailList[i].attachments ~= "" and tMailList[i].isRead ~= 2 and tMailList[i].isRead ~= 4 and tMailList[i].isRead ~= 6 and tMailList[i].isRead ~= 7 and tMailList[i].isRead ~= 8 then
			hasAttachment = true
			break
		end
	end
	if hasAttachment then
		color2 = "255,89,74"	
		desc2 = LocalStrings.CHANGESEX4
	else
		color2 = "5,180,0"	
		desc2 = LocalStrings.TRAINCAMP_DEC2
	end
	local text = string.format(LocalStrings.CHANGESEX1, color1, desc1, color2, desc2)
	GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox):setShowText(text)

	self.rule1 = (CacheCenter:getPlayerInfo().marryFlag == 0)
	self.rule2 = not hasAttachment
end

function WndChangeSex:_adaptLanguage_vn( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(460)
end

function WndChangeSex:_adaptLanguage_en( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(460)

	GetElement(self.m_root,"txtChange_WndChangeSex",WZUILabelTTF):setScale(0.8)
end

function WndChangeSex:_adaptLanguage_th( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(460)
end
function WndChangeSex:_adaptLanguage_es( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(460)

	GetElement(self.m_root,"txtChange_WndChangeSex",WZUILabelTTF):setScale(0.8)
end
function WndChangeSex:_adaptLanguage_pt( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.7)
	txtFreeBox:setMaxWidth(500)

	GetElement(self.m_root,"txtChange_WndChangeSex",WZUILabelTTF):setScale(0.7)
end

function WndChangeSex:_adaptLanguage_tr( )
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndChangeSex",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(460)
	
	GetElement(self.m_root,"txtChange_WndChangeSex",WZUILabelTTF):setScale(0.8)
end
-------------------------------------私有方法模块End----------------------------------------
