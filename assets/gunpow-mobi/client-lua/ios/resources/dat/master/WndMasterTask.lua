--WndMasterTask.lua
--@brief	WndMasterTask的UI模块
--@date		2016/07/23
--@author	zsq
--@note		师傅任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterTask:onEnter(element)
	self.m_root = element
end

function WndMasterTask:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndMaster:send_MENTORING_GetTask()
	--self:setData()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterTask:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMasterTask:update()
	if self.m_root == nil then return end
	local freeListContainer = GetElement(self.m_root,"freecon_WndMasterTask",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellMasterTask:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			freeListContainer:pushBack(celElement)
			freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
		end 
	end

	--重置时间
	GetElement(self.m_root,"txtTime",WZUIFreeTextBox):setShowText(string.format(LocalStrings.MASTERINFO66,"00:00"))
end




-------------------------------------私有方法模块End----------------------------------------
