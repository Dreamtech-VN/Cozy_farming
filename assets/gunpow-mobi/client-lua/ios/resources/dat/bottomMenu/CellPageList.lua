--CellPageList.lua
--@brief	CellPageList的UI模块
--@date		2013/12/22
--@author	林庆凯
--@note		用来显示好友列表上一页，下一页的控件


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPageList:onEnter(element)
	self.m_root = element
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPageList:onExit(element)
	self:_unInit()
end


--@brief	点击时的上一页，下一页响应函数
--@param	element:表绑定的UI节点引用
function CellPageList:onClickBtnPageList(element)
	WZLog("CellPageList:onClickBtnPageList(element)")
	if self.m_root == nil or element == nil then 
		WZLog("function CellPageList:onClickBtnPageList(element) is nil ")
		return 
	end 
	--把上一页和下一页的内容传到WndFriend窗口，WndFriend窗口根据传来的消息判断该发送那个协议
	WndFriend:onClickBtnByCellPageListsendPage(self:getTxtPageContent())
end 


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新页面是上一页，下一页响应函数
function CellPageList:_update()
	WZLog("CellPageList:_update()")
	if self.m_root == nil then 
		WZLog(" CellPageList:_update() self.m_root is nil ")
	end 
	
	--设置上一页还是下一页
	local txtFrontOrNextPage  = self.m_root:getChildElement("txtFrontOrNextPage_CellPageList")
	if txtFrontOrNextPage  ~= nil then 
		txtFrontOrNextPage = WZUILabelTTF:luaTo(txtFrontOrNextPage)
		if txtFrontOrNextPage  ~= nil then 
			txtFrontOrNextPage:setText(self.m_sTxtContent)
		end 
	end 
	
end 




-------------------------------------私有方法模块End----------------------------------------
