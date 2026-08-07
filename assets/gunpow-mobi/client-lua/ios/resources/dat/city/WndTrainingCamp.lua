--WndTrainingCamp.lua
--@brief	WndTrainingCamp的UI模块
--@date		2017/2/10
--@author	莫剑峰
--@note		训练营


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTrainingCamp:onEnter(element)
	self.m_root = element
    ProtocolProcessorSingleMap:regAll()
    ProtocolProcessorSingleMap:send_MAP_TrainMes()
    -- self:setRebateList()
    -- self:update(1, nil, nil, true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTrainingCamp:onExit(element)
	self:_unInit()
end

--@brief    弹窗动画完成后的回调
function WndTrainingCamp:actionCallback(element, data)
    WZLog("WndTrainingCamp:actionCallback")
end

--@brief onEnter函数执行完成回调
function WndTrainingCamp:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    刷新
function WndTrainingCamp:update(index)
    local tab = GetElement(self.m_root,"tabRebate_WndTrainingCamp",WZUITableContainer)
    tab:cleanTable()
    WZLog("WndTrainingCamp:update")
    if self.index then
        GetElement(self.m_root,"conSel".. self.index .."_WndTrainingCamp",WZUIContainer):setVisible(false)
    end
    GetElement(self.m_root,"conSel".. index .."_WndTrainingCamp",WZUIContainer):setVisible(true)
    self.index = index
    local rebateList = self.m_tRebateList[index]
    for i = 1, #rebateList do
        local rData = rebateList[i]
        local cell,tcell = CellTrainingRewardList:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(rData)
    end
end

--@brief    点击按钮回调
function WndTrainingCamp:onClick(element, parm, parm, isMust)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = element:getTag()
    WZLog("WndTrainingCamp:onClick", self.index, tag)

    if (self.index or isMust) and self.index ~= tag then
        self:update(tag)
    end
end

--@brief    点击关闭按钮回调
function WndTrainingCamp:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    规则详细
function WndTrainingCamp:clickDec( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ROOM_RULE)
end

--@brief    关闭整个窗口的动画效果
function WndTrainingCamp:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
