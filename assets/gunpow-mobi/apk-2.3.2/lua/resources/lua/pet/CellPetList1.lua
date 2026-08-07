--CellPetList1.lua
--@brief	CellPetList1的UI模块
--@date		2021/03/01
--@author	hyc
--@note		宠物列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetList1:onEnter(element)
    self.m_root = element
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function CellPetList1:onExit(element)
    self:_unInit()
end

--@brief    获取表参数
--@param    #1, tCellData:邮件信息
function CellPetList1:setCellAllElement(tPetInfo)
--    WZLog("CellMailList1:setCellAllElement")
    self.t_PetInfo = tPetInfo
    
end

--@brief  设置cell中的内容
--@param  tPetInfo:设置宠物的属性
function CellPetList1:onLoadData(element)
--    WZLog("CellPetList1:setCellAllElement")
    local cellElementPetList = WZUISystem:getInstance():createElement("CellPetList1")
    self.m_root:addChild(cellElementPetList)
    AdaptLanguage(self)
    local tPetInfo = self.t_PetInfo

    local petIcon = string.gsub(tPetInfo.icon,".png","_1.png")
--    WZLog("单个宠物icon",Serialize(tPetInfo))
    GetElement(self.m_root,"imgIcon_CellPetList1",WZUIImage):setFile(petIcon)
    GetElement(self.m_root,"txtName_CellPetList1",WZUILabelTTF):setText(tPetInfo.name) 
    local lv = "Lv"..tPetInfo.upgradeLevel
    GetElement(self.m_root,"txtLv_CellPetList1",WZUILabelTTF):setText(lv)
    local quality = GDatatab_item["id_"..tPetInfo.itemId].quality
    local ownBg = g_tQualityBG[quality]
    local ownTxtBg = g_tQualityNameBG[quality]
    GetElement(self.m_root,"imgBg_CellPetList1",WZUI9Image):setFile(ownBg)
    GetElement(self.m_root,"imgTxtBg_CellPetList1",WZUIImage):setFile(ownTxtBg)
    local s0 = WndPets:getTypeById(tPetInfo.itemId)
    GetElement(self.m_root,"imgExp_CellPetList1",WZUIImage):setFile(s0)
    local xing = WndPets:getAptitude(tPetInfo.giftSkill)
--    WZLog("背景资源",xing)
    GetElement(self.m_root,"txtXingxing_CellPetList1",WZUILabelTTF):setText(xing)

    -- --经验宝宝
    if WndPets:isExpPet(tPetInfo.itemId) then

        GetElement(self.m_root,"imgExp_CellPetList1",WZUIImage):setVisible(false)
        GetElement(self.m_root,"imgFight_CellPetList1",WZUIImage):setVisible(false)
        GetElement(self.m_root,"txtLv_CellPetList1",WZUILabelTTF):setText(tPetInfo.num)
    else
        self:_setWarState(self.t_PetInfo.isInUsed)
    end
    self:setState(self.choiceState)
end

function CellPetList1:getPetId()
    return self.t_PetInfo.playerPetId
end

function CellPetList1:onSiClick(element, table)
    WZLog("CellPetList:onSiClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setState(true)
    WndPets:setPetInfo(self.t_PetInfo, self)
end

function CellPetList1:setState(bState)
--    WZLog("CellPetList:setState", bState)
    -- local element =  GetElement(self.m_root,"conSel_CellPetList",WZUIContainer)
    local element = GetElement(self.m_root,"imgChoose_CellPetList1",WZUI9Image)
    if element == nil then
        self.choiceState = bState
        return
    end
    element:setVisible(bState)
end

function CellPetList1:onFighting()
    WZLog("---------------------fighting----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    TeachGroup1:endTeachStep({12,7})
    self:setState(true)
    WndPets:setPetInfo(self.t_PetInfo, self)
    WndPets:onToWar()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetList1:_setWarState(isWar)
    WZLog("CellPetList1:_setWarState:",isWar)
    if self.m_root == nil then
        return
    end
    self.t_PetInfo.isInUsed = isWar
    -- GetElement(self.m_root,"imgFight_CellPetList1",WZUIImage):setVisible(isWar)
    local war = GetElement(self.m_root,"imgFight_CellPetList1",WZUIImage)
    war:setVisible(isWar)
end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------------语言适配Begin---------------------------------------
-- function CellPetList:_adaptLanguage_th(  )
--     local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
--     txtName:setMaxWidth(500)
--     txtName:setScale(0.8)
-- end

-- function CellPetList:_adaptLanguage_en(  )
--     local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
--     txtName:setMaxWidth(500)
--     txtName:setScale(0.7)
-- end

-- function CellPetList:_adaptLanguage_pt(  )
--     local txtName = GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox)
--     txtName:setMaxWidth(500)
--     txtName:setScale(0.7)
-- end

function CellPetList1:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtName_CellPetList1",WZUILabelTTF):setScale(0.7)
end

-- function CellPetList:_adaptLanguage_es(  )
--     GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.65)
--     GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setFontSize(10)
-- end

-- function CellPetList:_adaptLanguage_tr(  )
--     GetElement(self.m_root,"txtWarState_CellPetList",WZUILabelTTF):setScale(0.8)
    
--     GetElement(self.m_root,"txtName_CellPetList",WZUIFreeTextBox):setScale(0.7)
-- end
------------------------------------------语言适配End-----------------------------------------