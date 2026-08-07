--WndMasterLog.lua
--@brief	WndMasterLog的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒消息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterLog:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterLog:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新消息
function WndMasterLog:update()
	WZLog("WndMasterLog:update",self.m_bLog1Received,self.m_bLog2Received,Serialize(self.m_tMasterLog1),Serialize(self.m_tMasterLog2))
	if self.m_bLog1Received ~= true or self.m_bLog2Received ~= true then
		return
	end
	if self.m_root == nil then return end

    if #self.m_tMasterLog1 == 0 then
        GlobalGame.g_tRedPointList.master = false
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(93)
        local masterInfo = CacheCenter:getMasterInfo()
        if masterInfo == nil or masterInfo.taskfinish == 0 then
            SceneCity:updateRedDotBuilding("master", false)
        end
    end

	local freeListContainer = GetElement(self.m_root,"freecon_WndMasterLog",WZUIFreeListContainer)
	freeListContainer:removeAll()
	removeShowPanelNullTip(self.m_root)
	if #self.m_tMasterLog1 == 0 and #self.m_tMasterLog2 == 0 then
		ShowPanelNullTip( self.m_root )
	end
	if freeListContainer ~= nil then 
		for i = 1 ,#self.m_tMasterLog1 do
			local celElement,tFreeCell = CellMasterInfo1:createElement()
			if celElement ~= nil and tFreeCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tFreeCell:setMasterInfo1(self.m_tMasterLog1[i])
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				WZLog("容器和cell大小",cellSize.width,freeconSize.width)
				freeListContainer:pushBack(celElement)
				celElement:setScale(1)
			end 
		end 
		for j = 1 ,#self.m_tMasterLog2 do
			local celElement,tFreeCell = CellMasterInfo2:createElement()
			if celElement ~= nil and tFreeCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tFreeCell:setMasterInfo2(self.m_tMasterLog2[j])
				local freeconSize = freeListContainer:getContentSize()				
				local cellSize = celElement:getAbsContentSize()
				--自由列表只能支持相对大小
				--celElement:setRelativeSize(GlobalMethod:CCSize(cellSize.width/freeconSize.width, cellSize.height/freeconSize.height))
				WZLog("容器和cell大小1",cellSize.width,freeconSize.width)
				freeListContainer:pushBack(celElement)
				celElement:setScale(1)
			end 
		end 
	end 
    freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end




-------------------------------------私有方法模块End----------------------------------------
