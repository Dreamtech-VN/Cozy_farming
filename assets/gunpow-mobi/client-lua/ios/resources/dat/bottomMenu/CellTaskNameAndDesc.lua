--CellTaskNameAndDesc.lua
--@brief	CellTaskNameAndDesc的UI模块
--@date		2014/09/09
--@author	SuYuan
--@note		主线任务名称和描述Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTaskNameAndDesc:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTaskNameAndDesc:onExit(element)
	self:_unInit()
end

--@brief 	设置任务名称
--@param 	sTaskName:任务名称
function CellTaskNameAndDesc:setTaskName(sTaskName)
	GetElement(self.m_root, "txtTaskName_CellTaskNameAndDesc", WZUILabelTTF):setText(sTaskName)
end

--@brief 	设置任务描述
--@param 	sTaskDesc:任务描述
function CellTaskNameAndDesc:setTaskDesc(sTaskDesc)
	GetElement(self.m_root, "txtDesc_CellTaskNameAndDesc", WZUILabelTTF):setText(sTaskDesc)
    --self:_rollContainerLayer()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function CellTaskNameAndDesc:_setStaticText()
	GetElement(self.m_root, "txtTitle_CellTaskNameAndDesc", WZUILabelTTF):setText(LocalStrings.TASK_DESCRIPTION)
end

-------------------------------------私有方法模块End----------------------------------------

--@brief    获得文字尺寸大小
function CellTaskNameAndDesc:_getTaskDescTxtSize(  )
    if self.m_root == nil then
        return
    end
    local txtRewardDesc = self.m_root:getChildElement("txtDesc_CellTaskNameAndDesc")
    if txtRewardDesc == nil then
        return
    end

    txtRewardDesc = WZUILabelTTF:luaTo(txtRewardDesc)
    local size = txtRewardDesc:getLabelContentSize()
    return  size
end

--@brief    说明文字滚动层
function CellTaskNameAndDesc:_rollContainerLayer()
    if self.m_root == nil then
        return
    end
    --获得滚动容器
    local  txtSize = self:_getTaskDescTxtSize()
    local rollconExplanation_WndTask = self.m_root:getChildElement("rollconExplanation_WndTask")
    if rollconExplanation_WndTask == nil then
        WZLog("rollconExplanation_WndTask is nil...")
        return
    end
    rollconExplanation_WndTask = WZUIMoveContainer:luaTo(rollconExplanation_WndTask)
    local  rollSize = rollconExplanation_WndTask:getAbsContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconExplanation_WndTask:getMoveElement()
    local size = moveElement:getRelativeSize()
    moveElement:setRelativeSize( CCSize( 1, txtSize.height/rollSize.height ) )
    rollconExplanation_WndTask:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconExplanation_WndTask:getMinPosition().y)
    
end
-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function CellTaskNameAndDesc:_adaptLanguage_en()
end

-------------------------------------语言适配模块End----------------------------------------



