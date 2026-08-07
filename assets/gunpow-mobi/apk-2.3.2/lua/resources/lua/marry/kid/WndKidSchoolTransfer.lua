--WndKidSchoolTransfer.lua
--@brief	WndKidSchoolTransfer的UI模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-转让


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolTransfer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolTransfer:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidSchoolTransfer:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief    点击关闭按钮回调
function WndKidSchoolTransfer:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    更新界面
function WndKidSchoolTransfer:updateUI()
	local tcParent = GetElement(self.m_root,"tcParent_WndKidSchoolTransfer",WZUITableContainer)
	tcParent:cleanTable()

	local conParent = GetElement(self.m_root, "conParent_WndKidSchoolTransfer", WZUIContainer)
    if self.m_tData == nil or #self.m_tData == 0 then
        ShowPanelNullTip( conParent, LocalStrings.CHARM_RESULT, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conParent)

	for i=1,#self.m_tData do
	    self.m_nSchoolStartIndex = 1
	    tcParent:enableSchedule("_addParentSchedule")
	end
end

--@brief  每帧加载学校
function WndKidSchoolTransfer:_addParentSchedule(element)
    local tcParent = GetElement(self.m_root,"tcParent_WndKidSchoolTransfer",WZUITableContainer)

    for i=self.m_nSchoolStartIndex,#self.m_tData do
        local celElement, tNewObj = CellKidSchoolTransfer:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tData[i])
            tcParent:setCellElement(celElement)
        end
        self.m_nSchoolStartIndex = self.m_nSchoolStartIndex + 1
    end
    if self.m_nSchoolStartIndex > #self.m_tData then
        tcParent:disableSchedule()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
