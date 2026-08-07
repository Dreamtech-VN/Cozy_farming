--WndSelectMap.lua
--@brief	WndSelectMap的UI模块
--@date		2013/12/27
--@author	李光森
--@note		房间中选择地图窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSelectMap:onEnter(element)
	self.m_root = element
	
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSelectMap:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
--@param	element:绑定的UI节点引用
function WndSelectMap:onCloseClick(element)
	WZLog("WndSelectMap:onCloseClick")
	WindowManager:removeWindow(self.m_root,WndSelectMap,true)
end

--@brief	地图列表点击回调
--@param	element:绑定的UI节点引用
function WndSelectMap:onMapCellClick(element)
	WZLog("WndSelectMap:onMapListClick")
	
	if self.m_tData == nil then
		WZLog("WndSelectMap:_update m_tData is nil.")
		return
	end
	if self.m_lpClickCallback ~= nil then
		self.m_lpClickCallback(self.m_tCallbackTable,element:getTag())
	end
	
	self:onCloseClick(nil)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   sortById
function sortById(a,b)
	if a < b then
		return true
	else
		return false
	end
end 

--@brief	wnd更新函数
--@note		实际上的初始化函数
function WndSelectMap:_update()
	if self.m_root == nil then
        WZLog("WndSelectMap:_update m_root is nil.")
		return
    end
	
	WZLog("current channel:"..self.m_nCurChannel)
	WZUITableContainer:luaTo(GetElement(self.m_root,"tbconMapList_WndSelectMap")):cleanTable()
    if self.m_tData == nil then
    	self.m_tData = {}
    	for k,v in pairs(GDatatab_map) do
	    	if v.channel == self.m_nCurChannel then
	    		table.insert(self.m_tData,v.id)
	    	end
        end
        table.sort(self.m_tData,sortById)
    end
  

	for i=1,#self.m_tData do
		local mKey = self.m_tData[i]
		local element = self:_createAMapCell(GDatatab_map["id_"..mKey].icon,GDatatab_map["id_"..mKey].dese)
		element:setTag(i-1)
		GetElement(element,"btnCell_WndSelectMap"):setTag(mKey)
		
		--if self.m_nCurChannel ~= nil and self.m_nCurChannel < self.m_tData.mapChannel[i] then
		--	self:_lockMap(element)
		--end
		
		WZUITableContainer:luaTo(GetElement(self.m_root,"tbconMapList_WndSelectMap")):setCellElement(element)
	end
end

--@brief	创建一个地图列表项
--@return	#1:创建出来的cell引用
function WndSelectMap:_createAMapCell(mapIcon,mapDesc)
	WZLog("WndSelectMap:_createAMapCell")
	--WZLog("icon:"..mapIcon,"desc:"..KLuaSocket:utfToGBK(mapDesc))
	local sI,_ = string.find(mapIcon,"_bg.png")
	local mapBgPath = RESOURCE_MAP_PATH..mapIcon
	local mapTitlePath = RESOURCE_MAP_TITLE_PATH..string.sub(mapIcon,1,sI-1)..".png"
	
	local element = WZUISystem:getInstance():createElement("CellMapList_WndSelectMap")
	WZUIImage:luaTo(GetElement(element,"imgMap_WndSelectMap")):setFile(mapBgPath)
	WZUIImage:luaTo(GetElement(element,"imgMapTitle_WndSelectMap")):setFile(mapTitlePath)
	WZUILabelTTF:luaTo(GetElement(element,"txtMapDesc_WndSelectMap")):setText(mapDesc)
	element:setVisible(true)
	return element
end

--@brief	锁定地图项
--@param	element:cell的表引用
function WndSelectMap:_lockMap(element)
	WZLog("WndSelectMap:_lockMap")
	WZUILabelTTF:luaTo(GetElement(element,"txtMapDesc_WndSelectMap")):setText(LocalStrings.OPEN_ON_ADVANCED_CHANNEL)
	WZUIButton:luaTo(GetElement(element,"btnCell_WndSelectMap")):setTouchEnable(false)
	GetElement(element,"conMapNot_WndSelectMap"):setVisible(true)
end

-------------------------------------私有方法模块End----------------------------------------
