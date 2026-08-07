--WndSpacePhoto.lua
--@brief	WndSpacePhoto的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人照片墙


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpacePhoto:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpacePhoto:onExit(element)
	self:_unInit()
end

----@brief onEnter函数执行完成回调
function WndSpacePhoto:onEnterTransitionDidFinish(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新留言
function WndSpacePhoto:update()
	if self.m_root == nil then return end
	local tableContainer = GetElement(self.m_root,"tbCon_WndSpacePhoto",WZUITableContainer)
	tableContainer:cleanTable()
	for i = 1,8 do 
		local celElement,tCell = CellSpacePhoto:createElement()
		tCell.m_nIndex = i
		celElement:setTag(i-1)    --从0开始设置Tag值
		celElement:setScale(0.89)
		tableContainer:setCellElement(celElement)
		tCell:update(self.m_tData,i)
	end 
end




-------------------------------------私有方法模块End----------------------------------------
