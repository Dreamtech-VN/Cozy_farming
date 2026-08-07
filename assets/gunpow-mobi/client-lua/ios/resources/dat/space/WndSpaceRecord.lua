--WndSpaceRecord.lua
--@brief	WndSpaceRecord的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人记录

local pageSize = 20

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceRecord:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceRecord:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpaceRecord:onClose(element)
    WZLog("WndSpaceRecord:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置为访客记录
function WndSpaceRecord:setType3()
	self.m_nType = 3
	self.pageNumber = 1
	ProtocolProcessorWndSpace:send_SPACE_GetVisitorsList()
end

--@brief	设置为踩一踩记录
function WndSpaceRecord:setType1()
	self.m_nType = 1
	self.pageNumber = 1
	ProtocolProcessorWndSpace:send_SPACE_GetJoinList(WndSpaceMain.m_nPlayerId)
end

--@brief	设置为收鲜花记录
function WndSpaceRecord:setType2()
	self.m_nType = 2
	self.pageNumber = 1
	ProtocolProcessorWndSpace:send_SPACE_GetFlowersList(WndSpaceMain.m_nPlayerId)
end

--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function WndSpaceRecord:onPageUp(element)
	WZLog("WndSpaceRecord:onPageUp",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData and self:_getUpPage() then 
		self.pageNumber = self.pageNumber - 1
		self:update()
	end
end

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function WndSpaceRecord:onPageDown(element)
	WZLog("WndSpaceRecord:onPageDown",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData and self:_getDownPage() then 
		self.pageNumber = self.pageNumber + 1
		self:update()
	end
end

--@brief	更新界面
function WndSpaceRecord:update()
	if self.m_root == nil then return end
	self:_setUIStaticText()

	if self.m_tData == nil or #self.m_tData.playerId == 0 then 
		ShowPanelNullTip(GetElement(self.m_root,"conMid_WndSpaceRecord",WZUIContainer))
		return 
	end
	self.totalNumber = math.ceil((#self.m_tData.playerId - 1)/pageSize)
	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceRecord",WZUITableContainer)
	tableContainer:cleanTable()
	removeShowPanelNullTip(GetElement(self.m_root,"conMid_WndSpaceRecord",WZUIContainer))
	--上下拉触发分页
	if self:_getUpPage() then
		--Begin:翻页效果2
		tableContainer:setEnableDropRefresh(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.FRONT_PAGE)
		ttf:setFontSize(22)
		ttf:setUseOriginSize(true)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		tableContainer:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
		tableContainer:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
		tableContainer:setEnableTopElement(true)--设置TopElement是否可用
		tableContainer:setVisibleHeight(30)
		tableContainer:setHideTopElement(false)--设置topElement是否隐藏
		tableContainer:setTopElement(ttf)--设置容器的TopElement对象
	else
		tableContainer:setEnableDropRefresh(false)
		tableContainer:setEnableTopElement(false)
		tableContainer:setHideTopElement(true)
	end
	if self:_getDownPage() then
		--Begin:翻页效果2
		tableContainer:setEnableDagLoading(false)
		local ttf = WZUILabelTTF:create()
		ttf:setText(LocalStrings.NEXT_PAGE)
		ttf:setFontSize(22)
		ttf:setColor(GlobalMethod:ccc3(255,236,193))
		ttf:setUseOriginSize(true)
		tableContainer:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
		tableContainer:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
		tableContainer:setVisibleHeight(30)
		tableContainer:setEnableBottomElement(true)--设置BottomElement是否可用
		tableContainer:setHideBottomElement(false)--设置bottomElement是否隐藏
		tableContainer:setBottomElement(ttf)--设置容器的BottomElement对象
	else 
		tableContainer:setEnableDagLoading(false)
		tableContainer:setEnableBottomElement(false)
		tableContainer:setHideBottomElement(true)
	end
	for i = 1,pageSize do 
		if self.m_tData.playerId[i+(self.pageNumber-1)*pageSize] ~= nil then
			local celElement,tCell = CellSpaceRecord:createElement()
			celElement:setTag(i-1)    --从0开始设置Tag值
			tableContainer:setCellElement(celElement)
			tCell["setType"..self.m_nType](tCell,self.m_tData,i+(self.pageNumber-1)*pageSize)
		end
	end
end

--@brief	设置下方文字
--@note		设置下方文字
function WndSpaceRecord:_setUIStaticText()
	if self.m_nType == nil then return end
	local titleList = {LocalStrings.SPACE2,LocalStrings.SPACE3,LocalStrings.SPACE5}

	local text1List = {LocalStrings.SPACE9,LocalStrings.SPACE11,LocalStrings.SPACE6}
	local text2List = {"",LocalStrings.SPACE4,LocalStrings.SPACE8}
	local text3List = {LocalStrings.SPACE10,LocalStrings.SPACE12,LocalStrings.SPACE7}
	local text4List = {LocalStrings.SPACE4,"",LocalStrings.SPACE8}

	GetElement(self.m_root,"title_WndSpaceRecord",WZUI9Label):setText(titleList[self.m_nType])
	local string = [[<T C="62,34,8" S="20" P="0">%s:</T><T C="128,54,13" S="20" P="0">%d%s</T>]]
	GetElement(self.m_root,"txtLeft_WndSpaceRecord",WZUIFreeTextBox):setShowText(string.format(string,text1List[self.m_nType],self.m_tData.num1,text2List[self.m_nType]))
	GetElement(self.m_root,"txtRight_WndSpaceRecord",WZUIFreeTextBox):setShowText(string.format(string,text3List[self.m_nType],self.m_tData.num2,text4List[self.m_nType]))
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSpaceRecord:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtRight_WndSpaceRecord",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.5,0.08))
end
-------------------------------------语言适配End--------------------------------------------
