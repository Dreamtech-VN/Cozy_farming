--CellInviteSuccess.lua
--@brief	CellInviteSuccess的UI模块
--@date		2014/01/05
--@author	liangguang_long
--@note		邀请成功清单模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellInviteSuccess:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellInviteSuccess:onExit(element)
	self:_unInit()
end

--点击上一页按钮回调函数
--@note	 发送上一页邀请清单列表协议
function CellInviteSuccess:onInviteUpPage()
	local nPage = self.m_nCurPage
	if nPage == 1 then 
		return 
	end
	nPage = nPage - 1
	--发送请求上一页协议	
	
end

--点击下一页按钮回调函数
--@note	 发送下一页邀请清单列表协议
function CellInviteSuccess:onInviteDownPage()
	local nPage = self.m_nCurPage
	local nTotalPage = self.m_nTotalPage
	nPage = nPage + 1
	if nPage > nTotalPage then 
		return 
	end
	--发送请求下一页协议	
	
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellInviteSuccess:_update()
	if self.m_root == nil then 
		return
	end
	--邀请清单顺序
	self:_upSort()
	--服务器名称
	self:_upServerName()
	--玩家名称
	self:_upPlayerName()
end

--@brief	邀请清单顺序函数
function CellInviteSuccess:_upSort()
	if self.m_root == nil then
		return
	end
	local txtSort = self.m_root:getChildElement("txtSort_CellInviteSuccess")
	if txtSort == nil then
		return
	end
	txtSort = WZUILabelTTF:luaTo(txtSort)
	txtSort:setText( self.m_nSort )		--邀请清单顺序
end

--@brief	服务器名称函数
function CellInviteSuccess:_upServerName()
	if self.m_root == nil then
		return
	end
	local txtServerName = self.m_root:getChildElement("txtServerName_CellInviteSuccess")
	if txtServerName == nil then
		return
	end
	txtServerName = WZUILabelTTF:luaTo(txtServerName)
	txtServerName:setText( self.m_sServerName )
end
			
--@brief	玩家名称函数
function CellInviteSuccess:_upPlayerName()
	if self.m_root == nil then
		return
	end
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellInviteSuccess")
	if txtPlayerName == nil then
		return
	end
	txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
	txtPlayerName:setText( self.m_sPlayerName )
end

--@brief  显示上一页函数
function CellInviteSuccess:_updateUpPage()
	if self.m_root == nil then 
		return 
	end 
	--容器
	local conInvitePage = WZUIContainer:create()
	if conInvitePage == nil then 
		return 
	end
		
	--背景图
	local imgInvitePage = WZUIImage:create()
	if imgInvitePage == nil then 
		return 
	end
	imgInvitePage:setFile("ui/bottomMenu/mail/item_background.png")
	imgInvitePage:setUseOriginSize(true)
	
	--选中背景图
	local imgInvitePageSel = WZUIImage:create()
	if imgInvitePageSel == nil then 
		return 
	end
	imgInvitePageSel:setFile("ui/bottomMenu/mail/item_background_sel.png")
	imgInvitePageSel:setUseOriginSize(true)
	
	--label文本
	local txtInvitePageNumber = WZUILabelTTF:create()
	if txtInvitePageNumber == nil then 
		return
	end
	local text = tostring( self.m_sPageText )
	txtInvitePageNumber:setText(text)
	txtInvitePageNumber:setColor(GlobalMethod:ccc3(255,255,255))
	txtInvitePageNumber:setFontSize(32) 
	
	--按钮
	local btnPage = WZUIButton:create()
	btnPage:setNormalElement(imgInvitePage)
	btnPage:setSelectElement(imgInvitePageSel)
	
	--容器加载背景按钮和文本
	conInvitePage:addChild(btnPage)
	conInvitePage:addChild(txtInvitePageNumber) 
	--加载容器
	self.m_root:addChild(conInvitePage)
	
	--回调函数
	btnPage:setLuaDoneFunctionName("onInviteUpPage")
end

--@brief  显示下一页函数
function CellInviteSuccess:_updateDownPage()
	if self.m_root == nil then 
		return 
	end 
	--容器
	local conInvitePage = WZUIContainer:create()
	if conInvitePage == nil then 
		return
	end
		
	--背景图
	local imgInvitePage = WZUIImage:create()
	if imgInvitePage == nil then 
		return 
	end
	imgInvitePage:setFile("ui/bottomMenu/mail/item_background.png")
	imgInvitePage:setUseOriginSize(true)
	
	--选中背景图
	local imgInvitePageSel = WZUIImage:create()
	if imgInvitePageSel == nil then 
		return 
	end
	imgInvitePageSel:setFile("ui/bottomMenu/mail/item_background_sel.png")
	imgInvitePageSel:setUseOriginSize(true)
	
	--label文本
	local txtInvitePageNumber = WZUILabelTTF:create()
	if txtInvitePageNumber == nil then 
		return 
	end
	local text = tostring(self.m_sPageText)
	txtInvitePageNumber:setText(text)
	txtInvitePageNumber:setColor(GlobalMethod:ccc3(255,255,255))
	txtInvitePageNumber:setFontSize(32) 
	
	--按钮
	local btnPage = WZUIButton:create()
	btnPage:setNormalElement(imgInvitePage)
	btnPage:setSelectElement(imgInvitePageSel)
	
	--容器加载背景按钮和文本
	conInvitePage:addChild(btnPage)
	conInvitePage:addChild(txtInvitePageNumber) 
	--加载容器
	self.m_root:addChild(conInvitePage)
	
	--回调函数
	btnPage:setLuaDoneFunctionName("onInviteDownPage")
end


-------------------------------------私有方法模块End----------------------------------------
