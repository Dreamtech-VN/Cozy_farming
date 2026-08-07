--WndAssistFigureSetting.lua
--@brief	WndAssistFigureSetting的UI模块
--@date		2021/04/19
--@author	XTX
--@note		出战孩子形象设置界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAssistFigureSetting:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAssistFigureSetting:onExit(element)
	self:_unInit()
end

--@brief    加载动画完后调用
function WndAssistFigureSetting:onEnterTransitionDidFinish(element)
    --body
    self:_setTitle()
    self:setData()
end

--@brief    关闭按钮回调事件
function WndAssistFigureSetting:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击赠送按钮回调
function WndAssistFigureSetting:onClickSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_tSelCell == nil then 
    	MsgBoxManager:showTipBox(LocalStrings.ASSIST_SKILL10)
    	return 
    end
    if self.m_nSelFigureId ~= self.m_tSelCell.tData.id then 
    	ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistInfo(self.m_nType, self.m_tSelCell.tData.id)
    end
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	选中列表某项回调
function WndAssistFigureSetting:selectCallBack(tCell)
	-- body
	if self.m_tSelCell == nil then 
		self.m_tSelCell = tCell
	else
		self.m_tSelCell:setSelectState(false)
		self.m_tSelCell = tCell
	end

	self.m_tSelCell:setSelectState(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面信息
function WndAssistFigureSetting:_update()
    -- body
    local tGiftList = self.m_tData
    local tableList = GetElement(self.m_root, "tableList_WndAssistFigureSetting", WZUITableContainer)
    WZLog("***** WndAssistFigureSetting:_update *****", Serialize(tGiftList), self.m_nSelFigureId)
    for i = 1, #tGiftList do
        local element, tNewObj = CellMounts:createElement()
        if element and tNewObj then 
	        element:setTag(i - 1)
	        tNewObj:setCellAllElement(tGiftList[i])
	        tNewObj:setListType(self.m_nType)
	        if self.m_nSelFigureId ~= 0 and self.m_nSelFigureId == tGiftList[i].id then 
	        	tNewObj:setSelectState(true)
	        	self.m_tSelCell = tNewObj
	        end
	        tableList:setCellElement(element)
	    end
    end
end

--@brief 	设置标题
function WndAssistFigureSetting:_setTitle()
	-- body
	local txtTitle = GetElement(self.m_root, "txtTitle_WndAssistFigureSetting", WZUILabelTTF)
	if txtTitle then 
		if self.m_nType == 1 then 
			txtTitle:setText(LocalStrings.ASSIST_SKILL6)
		elseif self.m_nType == 2 then
			txtTitle:setText(LocalStrings.ASSIST_SKILL5)
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
