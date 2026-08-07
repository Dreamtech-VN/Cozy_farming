--CellKidSchoolApprove.lua
--@brief	CellKidSchoolApprove的UI模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校会员审批-子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidSchoolApprove:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidSchoolApprove:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function CellKidSchoolApprove:onEnterTransitionDidFinish(element)
    self:updateUI()
end

--@brief	更新界面
function CellKidSchoolApprove:updateUI()

	--孩子头像
	local conHead = GetElement(self.m_root,"conHead_CellKidSchoolApprove",WZUIContainer)
	local imgHead = CellHead:show(conHead, self.m_tData.cheadId, self.m_tData.cfaceId, self.m_tData.csex, nil, nil, nil, nil, nil, nil, nil, true, self.m_tData.headEffectId)
	local txtCName = GetElement(self.m_root,"txtCName_CellKidSchoolApprove",WZUILabelTTF)
	txtCName:setText(self.m_tData.cname)
	--父母
	local ftbName1 = GetElement(self.m_root,"ftbName1_CellKidSchoolApprove",WZUIFreeTextBox)
	local ftbName2 = GetElement(self.m_root,"ftbName2_CellKidSchoolApprove",WZUIFreeTextBox)
	local strParent = {[0]=LocalStrings.KID_TEXT119,LocalStrings.KID_TEXT120}
	local strFormat = [[<T C="229,105,22" S="20" P="0">%s: </T><T C="127,70,26" S="20" P="1">%s</T>]]
	if #self.m_tData.parents == 1 then
		ftbName1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
		ftbName1:setRelativePosition(GlobalMethod:ccp(0.32,0.5))
	elseif #self.m_tData.parents == 2 then
		ftbName1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
		ftbName2:setShowText(string.format(strFormat, strParent[self.m_tData.parents[2].sex], self.m_tData.parents[2].name))
		ftbName1:setRelativePosition(GlobalMethod:ccp(0.32,0.7))
		ftbName2:setRelativePosition(GlobalMethod:ccp(0.32,0.3))
	end
end

--@brief	获得选中状态
function CellKidSchoolApprove:getSelectedState()
	return self.m_bIsSelectedState
end

function CellKidSchoolApprove:showSelectedState(bState)
    self.m_bIsSelectedState = bState
	local nCheckIndex = 0
	if bState then
		nCheckIndex = 1
	end
	local checkGou = GetElement(self.m_root,"checkGou_CellKidSchoolApprove",WZUICheckBox)
	checkGou:setCheckIndex(nCheckIndex)
end

--@brief	点击勾选按钮回调
function CellKidSchoolApprove:onClickGou(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:showSelectedState(not self.m_bIsSelectedState)

    WndKidSchoolApprove:updateCheckAll()
end

--@brief	点击孩子头像按钮回调
function CellKidSchoolApprove:onClickHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.parents[1].applyId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
