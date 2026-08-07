--WndPopupMenu.lua
--@brief	WndPopupMenu的UI模块
--@date		2013/12/11
--@author	xiaoyu_wu
--@note		弹出菜单模块

local CELLMENUITEM_HEIGHT = 60 --每一个弹出菜单选项的高度

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPopupMenu:onEnter(element)
	self.m_root = element
	self:holdWindows()
	self:_update()
	element:setVisible(false)
end

function WndPopupMenu:holdWindows()
	--local view = CCEGLView:sharedOpenGLView()
	--local x = view:getScaleX()
	--local y = view:getScaleY()
	--local minScale = math.min(x,y)
	--x = minScale/x
	--y = minScale/y
	--local tRoot = WZUIElementContainer:luaTo(self.m_root)
	--tRoot:setScaleX(x)
	--tRoot:setScaleY(y)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPopupMenu:onExit(element)
	self:_unInit()
end

--@brief	移除菜单
function WndPopupMenu:delMenu()
	if self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
		self.m_root = nil 
	end
end

--@brief	菜单选项被点击后的响应方法
--@param	element:被点击的选项的UI节点引用
--@param	nId:被点击的选项的Id
--@note		由各个菜单选项表实例的点击响应方法调用该方法，然后该方法再回调给主界面
function WndPopupMenu:onClickMenuItem(element, nId)
	if self.m_tCallBackLuaObj ~= nil and self.m_fCallBackFunc ~= nil then
		self.m_fCallBackFunc(self.m_tCallBackLuaObj, element, nId)
	elseif self.m_fCallBackFunc ~= nil then
		self.m_fCallBackFunc(element, nId)
	end
end

--@brief	在指定位置弹出菜单
--@param	element:弹出菜单所在的界面的UI节点引用
--@param	point:弹出菜单的位置，CCPoint对象
--@note		在指定位置弹出菜单，并且自动调整三角形的位置
function WndPopupMenu:popUpAtPoint(element, point)
	if self.m_root == nil or point == nil or element == nil then
		return
	end
	self.m_root:setVisible(true)
    self.m_root:setPositionX(point.x)
	local totalSize = element:getContentSize()
	local menuSize = self.m_root:getContentSize()
	local nTriangleOffset = CELLMENUITEM_HEIGHT*1.5
	if menuSize.height <= CELLMENUITEM_HEIGHT*2 then
		nTriangleOffset = menuSize.height/2
	end
	
	--弹出菜单锚点Y为1
	local nMinY = menuSize.height
	local nMaxY = totalSize.height
	
	if nMinY >= nMaxY then --如果弹出菜单最小点比最大点还大(即弹出框比主界面还高)，则直接设在最小点
		self.m_root:setPositionY(nMinY)
	else --其他则根据point计算，但是计算出来的结果限制在最小值和最大值之间
		local nPosY = point.y + nTriangleOffset
		nPosY = math.min(nPosY, nMaxY)
		nPosY = math.max(nPosY, nMinY)
		self.m_root:setPositionY(nPosY)
	end
	local imgTriangle = WZUIImage:luaTo(self.m_root:getChildElement("imgTriangle_WndPopupMenu"))
	local size = imgTriangle:getContentSize()
	local view = CCEGLView:sharedOpenGLView()
	local x = view:getScaleX()
	local y = view:getScaleY()
	local minScale = math.min(x,y)
	x = minScale/x
	y = minScale/y
	WZLog("x:y:x:y:;",x,y,point.y,size.height)
	local nPosY = point.y - (self.m_root:getPositionY() - menuSize.height)--+size.height*2*(1-y)
	imgTriangle:setPositionY(nPosY)
end

--@brief	隐藏弹出菜单
--@note		隐藏弹出菜单
function WndPopupMenu:disappear()
	if self.m_root == nil then
		return
	end
	self.m_root:setVisible(false)
end

--@brief	显示弹出菜单
--@note		显示弹出菜单

function WndPopupMenu:show()
	WZLog("WndPopupMenu:show")    
	if self.m_root == nil then
		WZLog("WndPopupMenu:show 1")    
		return
	end
	self.m_root:setVisible(true)
end

--@brief	判断一个点是否在弹出菜单内部
--@param	point:需要判断的点,世界坐标系
--@note		判断一个点是否在弹出菜单内部

function WndPopupMenu:ifPointInMenu(point)
	if self.m_root == nil then
		return false
	end
    point = self.m_root:convertToNodeSpace(point)

	local menuSize = self.m_root:getContentSize()
	local nMinX = 0
	local nMaxX = menuSize.width
	local nMinY = 0
	local nMaxY = menuSize.height
	if point.x >= nMinX and point.x <= nMaxX and point.y >= nMinY and point.y <= nMaxY then
        return true
	end
	return false
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		根据菜单选项生成菜单
function WndPopupMenu:_update()
	WZLog("WndPopupMenu:_update",g_tPopupMenuString[POPUPMENU_VARIABLE])
	if self.m_root == nil or self.m_tMenuItems == nil or #self.m_tMenuItems == 0 then
		return
	end
	local tbconMenuItem = self.m_root:getChildElement("tbconMenuItem_WndPopupMenu")
	if tbconMenuItem == nil then
		return
	end
	tbconMenuItem = WZUITableContainer:luaTo(tbconMenuItem)
	local tbconMenuItemRelativeSize = tbconMenuItem:getRelativeSize()
	local tbconMenuItemRelativePos = tbconMenuItem:getRelativePosition()
	
	local imgBg = self.m_root:getChildElement("imgBg_WndPopupMenu")
	if imgBg == nil then
		return
	end
	local imgBgRelativeSize = imgBg:getRelativeSize()
	local imgBgRelativePos = imgBg:getRelativePosition()
	
	local size = self.m_root:getContentSize()
	local width = self:_getWinWidth(self.m_tMenu) or size.width
	local w = width/size.width
	size.height = CELLMENUITEM_HEIGHT*#self.m_tMenuItems
	local tCellMenu = {}
	tCellMenu.width = size.width-width
	size.width = width
	if #self.m_tMenuItems >2 then 
		self.m_root:setContentSize(size)
	end 
	tbconMenuItem:setCellElementHeight(1/#self.m_tMenuItems)
	--调整容器大小后需要重设里面使用了相对大小和相对位置的子节点
	tbconMenuItem:setRelativeSize(tbconMenuItemRelativeSize)
	tbconMenuItem:setRelativePosition(tbconMenuItemRelativePos)
	imgBg:setRelativeSize(imgBgRelativeSize)
	imgBg:setRelativePosition(imgBgRelativePos)
	
	local tData = {}
	tbconMenuItem:cleanTable()

	for i=1,#self.m_tMenuItems do
		local cellElement, tCell = CellPopupMenu:createElement()
		if cellElement ~= nil and tCell ~= nil then
			cellElement:setTag(i-1)
			tbconMenuItem:setCellElement(cellElement)
			if type(self.m_tMenuItems[i]) == "string" then
				tCell:setLightUp(true)	
			else
				tCell:setLightUp(false)	
			end
			if self.m_nType ~= nil then
				if self.m_nType == 2 then
					tCell:setBtnType(self.m_nType)
				elseif self.m_nType == 3 and i == 1 then
					tCell:setBtnType(self.m_nType)
				end
			end
			table.insert(tData,tCell)
		end
	end
	for i,data in pairs(tData) do
		data:setMenuItemID(tonumber(self.m_tMenuItems[i]),tCellMenu)
	end
	local moveElement = tbconMenuItem:getMoveElement()
	local moveSize = moveElement:getRelativeSize()
	local movePt = moveElement:getRelativePosition()
	moveElement:setRelativeSize(moveSize)
	moveElement:setRelativePosition(movePt)
	tbconMenuItem:UpdateInsidePosition()--更新容器内部布局
	moveElement:setPositionX(tbconMenuItem:getMinPosition().x)
	moveElement:setPositionY(tbconMenuItem:getMinPosition().y)
end

function WndPopupMenu:_getWinWidth(tMenu)
	if tMenu == nil or tMenu.width == nil then
		return
	end
	return tMenu.width
end
-------------------------------------私有方法模块End----------------------------------------
