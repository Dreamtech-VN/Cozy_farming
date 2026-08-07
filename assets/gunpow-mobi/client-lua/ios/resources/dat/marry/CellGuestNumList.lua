--CellGuestNumList.lua
--@brief	CellGuestNumList的UI模块
--@date		2014/5/14
--@author   林庆凯
--@note     显示结婚列表的UI模块，以方便让其它容器动态创建


-------------------------------------公有方法模块--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuestNumList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuestNumList:onExit(element)
	self:_unInit()
end

--@brief	判断点击cell事件是那个窗口的函数
--@param	element:表绑定的UI节点引用
function CellGuestNumList:onClickButtonCell(element)
	if self.m_cellRoot == nil or element == nil then
		WZLog("CellGuestNumList:onClickButtonCell(element) m_root or element is nil")
		return
	end
	element = WZUIButton:luaTo(element)
	WndGuest:onClickCellBtn(element,self.m_cellRoot,self.m_sName,self.m_nPlayerId)	
end 

--加载数据
function CellGuestNumList:onLoadData(element)
	WZLog("CellGuestNumList:onLoadData")
	local cellElement = WZUISystem:getInstance():createElement("CellGuestNumList")
	element:addChild(cellElement)
	self.m_cellRoot = cellElement
	self:_update()
end

-------------------------------------私有方法模块--------------------------------------

--@brief  更新容器中的显示内容，包括姓名，等级，性别
function CellGuestNumList:_update()
	if self.m_cellRoot == nil then 
		WZLog("CellGuestNumList:_updateCellContent m_cellRoot is nil ~~~~")
		return 
	end 
	
	--在线不在线的图片
	local imgOnLine = GetElement(self.m_cellRoot,"imgOnLine_CellGuestNumList",WZUI9Image)
	if imgOnLine ~= nil then 
		if imgOnLine ~= nil then 
			if  self.m_bFlagOnLine == false then 
				imgOnLine:setOpacity(168)
			else 
				imgOnLine:setOpacity(255)
			end 
		end 
	end 
	
	WZLog("CellGuestNumList:_updateCellContent m_root not nil ~~~~")
	--等级
	if self.m_sLevel ~= nil  then 
		self:_setWhichAtlasFontVisable(0,sLevel)
	end 
	
	--姓名
	local txtName = GetElement(self.m_cellRoot,"txtName_CellGuestNumList",WZUILabelTTF)
	if txtName ~= nil then 
		txtName:setText(self.m_sName)
	end 
	
	local conLevel = GetElement(self.m_cellRoot,"conLevel_CellGuestNumList",WZUIContainer)

	local headNode= CellHead:show(conLevel,self.m_nHeadId,self.m_nFaceId,self.m_sImgSex,nil,nil,self.m_nVipLevel,self.m_nHeadColor)
	headNode:setScale(1.2)
end 


--@brief  设置那种颜色字体控件可见的函数
--@param nTag 标记
--@param sLevel 等级
function CellGuestNumList:_setWhichAtlasFontVisable(nTag,sLevel)
	if self.m_cellRoot == nil then 
		WZLog("CellGuestNumList:_setWhichAtlasFontVisable() self.m_root is nil ")
		return 
	end
	local txtLevel = self.m_cellRoot:getChildElement("txtLevel_CellGuestNumList")
	if txtLevel ~= nil then 
		txtLevel = WZUILabelTTF:luaTo(txtLevel)
		if txtLevel ~= nil then 
			txtLevel:setText("Lv".. self.m_sLevel)
			txtLevel:setVisible(true)
		end
	end 
end 




