--CellCardListItem.lua
--@brief	CellCardListItem的UI模块
--@date		2016/07/27
--@author	Tianxiang_Xu
--@note		四个卡牌项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCardListItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCardListItem:onExit(element)
	self:_unInit()
end

--@brief    将创建的卡牌节点添加到cell中
function CellCardListItem:addCardCell(tNewObj)
    -- body
    if self.m_tCallBack then
        self.m_tCallBack[3](self.m_tCallBack[1], tNewObj)
    end
end

--@brief    加载
function CellCardListItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellCardListItem")
    self.m_root:addChild(celElement)

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellCardListItem:_update()
    -- body
    if self.m_tData == nil or #self.m_tData == 0 then
        return
    end

    for i = 1, #self.m_tData do
        local conItem = GetElement(self.m_root, string.format("conItem%d_CellCardListItem", i), WZUIContainer)
        local celElement, tNewObj = CellCardItem:createElement()
        if celElement and tNewObj then
            tNewObj:setData(self.m_tData[i])
            self:addCardCell(tNewObj)
            tNewObj:setCallBackFunc(self.m_tCallBack[1], self.m_tCallBack[2])
            conItem:addChild(celElement)
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------
