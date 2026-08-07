--CellCommunityKnockout1.lua
--@brief	CellCommunityKnockout1的UI模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间参战成员子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityKnockout1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityKnockout1:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellCommunityKnockout1:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellCommunityKnockout1")
    self.m_root:addChild(celElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief    点击cell回调
function CellCommunityKnockout1:onClickCell(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1])
    end
end

--@brief	查看玩家信息
function CellCommunityKnockout1:onCheck(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end

--@brief	没有权限的提示
function CellCommunityKnockout1:onTip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showTipBox(LocalStrings.KNOCKOUT10)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellCommunityKnockout1:_update()
    -- body
    local conPresident = GetElement(self.m_root, "conPresident_CellCommunityKnockout1", WZUIContainer)
    local conMember = GetElement(self.m_root, "conMember_CellCommunityKnockout1", WZUIContainer)
    local imgFighting = GetElement(self.m_root, "imgFighting_CellCommunityKnockout1", WZUIImage)
    if self.m_tData == nil then
        if self.m_nType == 1 then
            conPresident:setVisible(true)
            conMember:setVisible(false)
        elseif self.m_nType == 2 then
            conPresident:setVisible(false)
            conMember:setVisible(true)
        end

        if imgFighting then
            imgFighting:setVisible(false)
        end

        return 
    end
    conPresident:setVisible(false)
    conMember:setVisible(false)
    if imgFighting then
        imgFighting:setVisible(true)
    end
    local imgBK = GetElement(self.m_root, "imgBK_CellCommunityKnockout1", WZUI9Image)
    if imgBK then
        if self.m_tData.id == CacheCenter:getPlayerInfo().id then 
            imgBK:setFile("ui/common/common_scale9_di38.png")
        end
    end
    --等级、
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCommunityKnockout1", WZUILabelTTF)
    if txtLevel then
        txtLevel:setText("Lv " .. self.m_tData.level)
    end
    --名字
    local txtName = GetElement(self.m_root, "txtName_CellCommunityKnockout1", WZUILabelTTF)
    if txtName then
        txtName:setText(self.m_tData.name)
    end
    --战斗力
    local txtFighting = GetElement(self.m_root, "txtFighting_CellCommunityKnockout1", WZUILabelAtlasFont)
    if txtFighting then
        txtFighting:setText(self.m_tData.fighting)
    end
    --头像
    self:_showHead()
end

--@brief    显示头像
function CellCommunityKnockout1:_showHead()
    -- body
    local conHead = GetElement(self.m_root, "conHead_CellCommunityKnockout1", WZUIContainer)
    if conHead then
        local element = CellHead:show(conHead, self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,nil,nil,self.m_tData.vipLevel, self.m_tData.headColor)
        element:setScale(0.75)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------
function CellCommunityKnockout1:_adaptLanguage_en(  )
    local txtPresident = GetElement(self.m_root,"txtPresident_CellCommunityKnockout1",WZUILabelTTF)
    txtPresident:setFontSize(12)

    local txtName = GetElement(self.m_root, "txtName_CellCommunityKnockout1", WZUILabelTTF)
    if txtName then
        txtName:setScale(0.8)
    end
end

function CellCommunityKnockout1:_adaptLanguage_pt(  )
    local txtPresident = GetElement(self.m_root,"txtPresident_CellCommunityKnockout1",WZUILabelTTF)
    txtPresident:setScale(0.55)
    txtPresident:setDimensions(GlobalMethod:CCSize(220))
end

function CellCommunityKnockout1:_adaptLanguage_vn(  )
    local txtPresident = GetElement(self.m_root,"txtPresident_CellCommunityKnockout1",WZUILabelTTF)
    txtPresident:setDimensions(GlobalMethod:CCSize(100,0))
    txtPresident:setFontSize(14)
end

function CellCommunityKnockout1:_adaptLanguage_es(  )
    local txtPresident = GetElement(self.m_root,"txtPresident_CellCommunityKnockout1",WZUILabelTTF)
    txtPresident:setDimensions(GlobalMethod:CCSize(100,0))
    txtPresident:setFontSize(14)
end

function CellCommunityKnockout1:_adaptLanguage_tr(  )
    local txtPresident = GetElement(self.m_root,"txtPresident_CellCommunityKnockout1",WZUILabelTTF)
    txtPresident:setScale(0.6)
    txtPresident:setDimensions(GlobalMethod:CCSize(200))

    local txtName = GetElement(self.m_root, "txtName_CellCommunityKnockout1", WZUILabelTTF)
    if txtName then
        txtName:setScale(0.8)
    end
end
-------------------------------------语言适配End----------------------------------------