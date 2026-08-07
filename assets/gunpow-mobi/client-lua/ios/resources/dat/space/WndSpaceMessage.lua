--WndSpaceMessage.lua
--@brief	WndSpaceMessage的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人留言板


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceMessage:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceMessage:onExit(element)
	self:_unInit()
end

----@brief onEnter函数执行完成回调
function WndSpaceMessage:onEnterTransitionDidFinish(element)
	self.pageNumber = 1
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function WndSpaceMessage:onPageUp(element)
	WZLog("WndSpaceMessage:onPageUp",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData and self:_getUpPage() then 
		self.pageNumber = self.pageNumber - 1
		self:update()
	end
end

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function WndSpaceMessage:onPageDown(element)
	WZLog("WndSpaceMessage:onPageDown",self.pageNumber,self.totalNumber)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData and self:_getDownPage() then 
		self.pageNumber = self.pageNumber + 1
		self:update()
	end
end

--@brief	更新留言
function WndSpaceMessage:update()
	if self.m_root == nil then return end
	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceMessage",WZUITableContainer)
	tableContainer:cleanTable()
	if self.m_tData == nil or #self.m_tData.playerLevel == 0 then 
		ShowPanelNullTip(GetElement(self.m_root,"tbCon_WndSpaceMessage",WZUITableContainer),nil,GlobalMethod:ccc3(255,236,193))
		return 
	end
	self.totalNumber = math.ceil((#self.m_tData.playerId - 1)/8)
	removeShowPanelNullTip(GetElement(self.m_root,"tbCon_WndSpaceMessage",WZUITableContainer))
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
	for i = 1,8 do 
		if self.m_tData.playerId[i+(self.pageNumber-1)*8] ~= nil then
			local celElement,tCell = CellSpaceDetail:createElement()
			celElement:setTag(i-1)    --从0开始设置Tag值
			tableContainer:setCellElement(celElement)
			tCell:update(self.m_tData,i+(self.pageNumber-1)*8)
		end
	end 
end




-------------------------------------私有方法模块End----------------------------------------
