--CellTeamMember.lua
--@brief	CellTeamMember的UI模块
--@date		2016/06/22
--@author	Tianxiang_Xu
--@note		战队队员


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTeamMember:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTeamMember:onExit(element)
	self:_unInit()
end

--@brief    点击队员回调
function CellTeamMember:onClickCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellTeamMember:onClickCheck", self.m_tData.id)
    WndCheckOther:show(self.m_tData.id)
end

--@brief    重新设置位置
function CellTeamMember:resetRelativePosition()
    -- body
    local  txtName = GetElement(self.m_root, "txtName_CellTeamMember", WZUILabelTTF)
    txtName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtName:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    local conHead = GetElement(self.m_root, "conHead_CellTeamMember", WZUIContainer)
    conHead:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellTeamMember:_update()
    -- body
    --名字
    local  txtName = GetElement(self.m_root, "txtName_CellTeamMember", WZUILabelTTF)
    txtName:setText(self.m_tData.name)
    --头像
    local conHead = GetElement(self.m_root, "conHead_CellTeamMember", WZUIContainer)
    local cellElement =  CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex, nil, nil, nil, self.m_tData.headColor)
    cellElement:setScale(0.9)
    --MVP
    local imgMvp = GetElement(self.m_root, "imgMvp_CellTeamMember", WZUIImage)
    if self.m_tData.mvpMark == 1 then
        imgMvp:setVisible(true)
    else
        imgMvp:setVisible(false)
    end
end




-------------------------------------私有方法模块End----------------------------------------
