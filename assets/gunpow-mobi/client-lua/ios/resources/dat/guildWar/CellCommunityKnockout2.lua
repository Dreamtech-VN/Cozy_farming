--CellCommunityKnockout2.lua
--@brief	CellCommunityKnockout2的UI模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间参战成员子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityKnockout2:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityKnockout2:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellCommunityKnockout2:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellCommunityKnockout2")
    self.m_root:addChild(celElement)

    self:_update()
end

--@brief    点击cell回调
function CellCommunityKnockout2:onClickCell(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1])
    end
end

--@brief	查看玩家信息
function CellCommunityKnockout2:onCheck(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end

--@brief	邀请玩家
function CellCommunityKnockout2:onInvite()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local txtState = GetElement(self.m_root,"txtState_CellCommunityKnockout2",WZUILabelTTF)
	txtState:setColor(GlobalMethod:ccc3(138,112,106))
	txtState:setText(LocalStrings.HAVED_INVITED)

	ProtocolProcessorCommunityWar:send_GUILDWAR_Invite(self.m_tData.id )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellCommunityKnockout2:_update()
    -- body
    local imgFighting = GetElement(self.m_root, "imgFighting_CellCommunityKnockout2", WZUIImage)
    if self.m_tData == nil then
        if imgFighting then
            imgFighting:setVisible(false)
        end

        return 
    end
    if imgFighting then
        imgFighting:setVisible(true)
    end
    local imgBK = GetElement(self.m_root, "imgBK_CellCommunityKnockout2", WZUI9Image)
    if imgBK then
        if self.m_tData.id == CacheCenter:getPlayerInfo().id then 
            imgBK:setFile("ui/common/common_scale9_di38.png")
        end
    end
    --等级、
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCommunityKnockout2", WZUILabelTTF)
    if txtLevel then
        txtLevel:setText("Lv" .. self.m_tData.level)
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellCommunityKnockout2", WZUILabelTTF)
    if txtName then
        txtName:setText(self.m_tData.name)
    end
    --战斗力
    local txtFighting = GetElement(self.m_root, "txtFighting_CellCommunityKnockout2", WZUILabelAtlasFont)
    if txtFighting then
        txtFighting:setText(self.m_tData.fighting)
    end
    --头像
    self:_showHead()

	--状态1:在线,状态2:房间内,状态3:离线,状态4:XX组,状态10:在线但不能被邀请
	local btnInvite = GetElement(self.m_root,"btnInvite",WZUIButton)
	local state = self.m_tData.state
	local txtState = GetElement(self.m_root,"txtState_CellCommunityKnockout2",WZUILabelTTF)
	local zu = {LocalStrings.KNOCKOUT1,LocalStrings.KNOCKOUT2,LocalStrings.KNOCKOUT3}
	btnInvite:setVisible(false)
	if state == 1 then
		txtState:setColor(GlobalMethod:ccc3(5,180,0))
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
		btnInvite:setVisible(true)
	elseif state == 2 then
		txtState:setColor(GlobalMethod:ccc3(230,105,22))
		txtState:setText(LocalStrings.KNOCKOUT9)
	elseif state == 3 then
		txtState:setColor(GlobalMethod:ccc3(138,112,106))
		txtState:setText(LocalStrings.OFFLINESTATE)
	elseif state == 4 then
		txtState:setColor(GlobalMethod:ccc3(230,105,22))
		txtState:setText(zu[self.m_tData.teamId])
	elseif state == 10 then
		txtState:setColor(GlobalMethod:ccc3(5,180,0))
		txtState:setText(LocalStrings.REWARD_BTN_ONLINE)
	end
end

--@brief    显示头像
function CellCommunityKnockout2:_showHead()
    -- body
    local conHead = GetElement(self.m_root, "conHead_CellCommunityKnockout2", WZUIContainer)
    if conHead then
        local element = CellHead:show(conHead, self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,nil,nil,self.m_tData.vipLevel, self.m_tData.headColor)
        --element:setScale(0.99)
    end
end


-------------------------------------私有方法模块End----------------------------------------
