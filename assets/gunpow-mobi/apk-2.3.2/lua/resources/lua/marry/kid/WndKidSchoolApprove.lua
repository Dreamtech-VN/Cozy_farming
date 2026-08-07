--WndKidSchoolApprove.lua
--@brief	WndKidSchoolApprove的UI模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校会员审批


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolApprove:onEnter(element)
	WZLog("WndKidSchoolApprove:onEnter")
	self.m_root = element
    ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolApprove:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndKidSchoolApprove:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    界面加载完成回调
function WndKidSchoolApprove:onEnterTransitionDidFinish(element)
    
end

--@brief    更新界面
function WndKidSchoolApprove:updateUI()
    local checkAll = GetElement(self.m_root,"checkAll_WndKidSchoolApprove",WZUICheckBox)
    checkAll:setCheckIndex(0)

    GetElement(self.m_root,"txtPeopleNum_WndKidSchoolApprove",WZUILabelTTF):setText(#self.m_tData)
	local tcStudent = GetElement(self.m_root,"tcStudent_WndKidSchoolApprove",WZUITableContainer)
	tcStudent:cleanTable()
	local conStudent = GetElement(self.m_root, "conStudent_WndKidSchoolApprove", WZUIContainer)
    if self.m_tData == nil or #self.m_tData == 0 then
        ShowPanelNullTip( conStudent, LocalStrings.COMMUNITY_COMPETE_TEXT43, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conStudent)

	for i=1,#self.m_tData do
	    self.m_nStudentStartIndex = 1
	    self.m_tStudentObjList = {}
	    tcStudent:enableSchedule("_addStudentSchedule")
	end
end

--@brief  每帧加载学生
function WndKidSchoolApprove:_addStudentSchedule(element)
    local tcStudent = GetElement(self.m_root,"tcStudent_WndKidSchoolApprove",WZUITableContainer)
    
    local endIndex = #self.m_tData
    for i=self.m_nStudentStartIndex,endIndex do
        local celElement, tNewObj = CellKidSchoolApprove:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tData[i])
            table.insert(self.m_tStudentObjList,tNewObj)
            tcStudent:setCellElement(celElement)
        end
        self.m_nStudentStartIndex = self.m_nStudentStartIndex + 1
    end
    if self.m_nStudentStartIndex > #self.m_tData then
        tcStudent:disableSchedule()
    end
end

--@brief    点击拒绝按钮回调
function WndKidSchoolApprove:onClickRefuse(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --没勾选任何一个
	local bIsEmpty = true
    for i=1,#self.m_tStudentObjList do
    	if self.m_tStudentObjList[i]:getSelectedState() == true then
    		bIsEmpty = false
    		break
    	end
    end
    if bIsEmpty == true then
    	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT153)
    	return
    end

    local ids = WZLuaVector_int_:create()
    for i=1,#self.m_tStudentObjList do
    	if self.m_tStudentObjList[i]:getSelectedState() == true then
            ids:push(self.m_tData[i].id)
    	end
    end
    ProtocolProcessorKidSchool:send_SCHOOL_Approve(ids, 2)

end

--@brief    点击同意按钮回调
function WndKidSchoolApprove:onClickAgree(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --没勾选任何一个
	local bIsEmpty = true
    for i=1,#self.m_tStudentObjList do
    	if self.m_tStudentObjList[i]:getSelectedState() == true then
    		bIsEmpty = false
    		break
    	end
    end
    if bIsEmpty == true then
    	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT153)
    	return
    end

    local ids = WZLuaVector_int_:create()
    for i=1,#self.m_tStudentObjList do
        if self.m_tStudentObjList[i]:getSelectedState() == true then
            ids:push(self.m_tData[i].id)
        end
    end
    ProtocolProcessorKidSchool:send_SCHOOL_Approve(ids, 1)

end

--@brief    点击全选按钮回调
function WndKidSchoolApprove:onCheckAll(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    local checkAll = GetElement(self.m_root,"checkAll_WndKidSchoolApprove",WZUICheckBox)
    local nCheckState = checkAll:getCheckIndex()
    local bShowCheck = false
    if nCheckState == 1 then
    	bShowCheck = true
    end

    for i=1,#self.m_tStudentObjList do
    	self.m_tStudentObjList[i]:showSelectedState(bShowCheck)
    end
end

--@brief    刷新全选选项状态
function WndKidSchoolApprove:updateCheckAll()

	local nCheckCount = 0
    for i=1,#self.m_tStudentObjList do
    	if self.m_tStudentObjList[i]:getSelectedState() == true then
    		nCheckCount = nCheckCount + 1
    	end
    end

    local checkAll = GetElement(self.m_root,"checkAll_WndKidSchoolApprove",WZUICheckBox)
    if nCheckCount == #self.m_tStudentObjList then
    	checkAll:setCheckIndex(1)
    else
    	checkAll:setCheckIndex(0)
    end


	local bIsFull = true
    for i=1,#self.m_tStudentObjList do
    	if self.m_tStudentObjList[i]:getSelectedState() ~= true then
    		bIsFull = false
    		break
    	end
    end
    local checkAll = GetElement(self.m_root,"checkAll_WndKidSchoolApprove",WZUICheckBox)
    if bIsFull == true then
    	checkAll:setCheckIndex(1)
    else
    	checkAll:setCheckIndex(0)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
