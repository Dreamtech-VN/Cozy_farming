--CellTaskGoals.lua
--@brief	CellTaskGoals的UI模块
--@date		2014/09/09
--@author	SuYuan
--@note		主线任务目标Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTaskGoals:onEnter(element)
	self.m_root = element

	self:_setStaticText()
	
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTaskGoals:onExit(element)
	self:_unInit()
end

--@brief 	设置任务目标
--@param 	sTaskGoals:任务目标
function CellTaskGoals:setTaskGoals(sTaskGoals)
	--GetElement(self.m_root, "txtGoals_CellTaskGoals", WZUIFreeTextBox):setShowText(sTaskGoals)
    GetElement(self.m_root, "txtTitle_CellTaskGoals", WZUIFreeTextBox):setShowText(sTaskGoals)
end
--[[
--@brief    获得文字尺寸大小
function CellTaskGoals:_getTxtSize(  )
    if self.m_root == nil then
        return
    end
    local txtTitle_CellTaskGoals = self.m_root:getChildElement("txtTitle_CellTaskGoals")
    if txtTitle_CellTaskGoals == nil then
        return
    end

    txtTitle_CellTaskGoals = WZUIFreeTextBox:luaTo(txtTitle_CellTaskGoals)
    local size = txtTitle_CellTaskGoals:getLabelContentSize()
    return  size
end]]
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置界面上的静态文本
function CellTaskGoals:_setStaticText()
	GetElement(self.m_root, "txtTitle_CellTaskGoals_name", WZUILabelTTF):setText(LocalStrings.TASK_TARGET)
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function CellTaskGoals:_adaptLanguage_en()
end

-------------------------------------语言适配模块End----------------------------------------



