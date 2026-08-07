--CellPetChoiceList.lua
--@brief	CellPetChoiceList的UI模块
--@date		2015/05/22
--@author	zhangming
--@note		宠物选择Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetChoiceList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetChoiceList:onExit(element)
	self:_unInit()
end

--@brief    获取表参数
--@param    #1, tCellData:邮件信息
function CellPetChoiceList:setCellAllElement(tPetInfo, nTag)
    self.t_PetInfo = tPetInfo
    self.m_nType  = nTag
    if nTag == 1 then
        --宠物被吞噬经验
        for k,v in pairs(GDatatab_pet) do
          if v.item_id == self.t_PetInfo.itemId then
            self.m_nOtherValue  = v.exp 
            bool = true
            break
          end
        end
        local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
        --宠物等级经验
        for k,v in pairs(GDatatab_pet_upgrade) do
          if v.level == (self.t_PetInfo.upgradeLevel-1) and v.quality == quality then
            self.m_nOtherValue  = self.m_nOtherValue + v.total_exp
            WZLog(" CellPetChoiceList:setCellAllElement:", v.level, v.quality, v.total_exp)
            break
          end
        end
        --宠物当前经验
        self.m_nOtherValue = self.m_nOtherValue + self.t_PetInfo.petExp
        WZLog(" CellPetChoiceList:setCellAllElement:", self.m_nOtherValue, self.t_PetInfo.petExp)
        if self.m_nOtherValue == nil then
            self.m_nOtherValue = 0
        end
    end
end

--@brief  设置cell中的内容
--@param  tPetInfo:设置宠物的属性
--@param  nTag:设置宠物的属性类型
function CellPetChoiceList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellPetChoiceList")
    self.m_root:addChild(cellElement)
    AdaptLanguage(self)
    local tPetInfo = self.t_PetInfo 
    local nTag = self.m_nType 
    if nTag == 1 then
    	self:_initUpChoiceList()
    elseif nTag == 2 then
        self:_initEvolutionChoiceList()
    elseif self.m_nType == 3 then
        self:_initEvolutionChoiceList() 
    end
    self:_setButtonState(self.b_isClick)     
end

--@brief 选择按钮被按
function CellPetChoiceList:onSiClick(element)
    WZLog("CellPetChoiceList:onSiClick:", self.m_nType)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 1 then
        self:_doClickUp()
    elseif self.m_nType == 2 then
        self:_doClickEvolution()
    elseif self.m_nType == 3 then
        self:_doClickRecover() 
    end     
end

--重生界面按钮被按
function CellPetChoiceList:doQuickRecover()
    if self.b_isClick then
    else
        if GDatatab_item["id_"..self.t_PetInfo.itemId].quality >= 3 then --不能选择紫宠以上的
            return
        end
        local bool,nTag = WndPetRecover:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetRecover:addChoicePet(true, self.t_PetInfo)
            self:_setButtonState(true)
        end
    end
end

--@brief 宠物升级的一键添加
--@brief return  0为正常， 1为高品质
function CellPetChoiceList:addOneKeyToUp(nTag)
    WZLog("CellPetChoiceList:addOneKeyToUp")
    if self.b_isClick then
        return 0
    end
    local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
    if quality >= 3 then
        return 1
    end
    WndPetsUpgrade:setPetExp(self.t_PetInfo, true, self.m_nOtherValue)
    WndPetsUpgrade:addChoicePet(true,nTag,self)
    self.n_Tag = nTag
    self:_setButtonState(true)
    return 0
end

--@brief 宠物进阶的升级选取
--@brief true为经验溢出，不需在添加了，false为可添加
function CellPetChoiceList:choicePetOnUpgrade(nTag)
    WZLog("CellPetChoiceList:choicePetOnUpgrade")
    if not self.b_isClick then
        self.n_Tag = nTag
        WndPetsUpgrade:setPetExp(self.t_PetInfo, true, self.m_nOtherValue)
        self:_setButtonState(true)
        return true,self
    end
    if self.n_Tag ~= nil and self.n_Tag == nTag then
        WndPetsUpgrade:setPetExp(self.t_PetInfo, false, self.m_nOtherValue)
    end
    return false
end


--@brief 宠物进阶的自动选取
--@brief true为经验溢出，不需在添加了，false为可添加
function CellPetChoiceList:choicePetOnEvolution(nTag)
    WZLog("CellPetChoiceList:choicePetOnEvolution")
    if self.t_PetInfo ~= nil then
    end
    if not self.b_isClick then
        self.n_Tag = nTag
        self:_setButtonState(true)
        return true,self
    end
    return false
end

--@brief 返回宠物的属性
function CellPetChoiceList:getPetInfo()
    WZLog("CellPetChoiceList:getPetInfo")
    if self.t_PetInfo ~= nil then
        return self.t_PetInfo
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--升级界面的初始化
function CellPetChoiceList:_initUpChoiceList()
    --GetElement(self.m_root,"conBg_CellPetChoiceList",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(610,120))
    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.t_PetInfo.icon)
    local element =  GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
    WndPets:setIconQuality(element, quality)
    local name = "Lv"..self.t_PetInfo.upgradeLevel.." "..self.t_PetInfo.name--.."  ".."Lv."..self.t_PetInfo.upgradeLevel
    local nameText = GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF)
    nameText:setText(name)
    WndPets:setTextColor(GDatatab_item["id_"..self.t_PetInfo.itemId].quality, nameText)
   
   local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i =1 ,5 do
    	GetElement(self.m_root,"imgAptitude"..i.."_CellPetChoiceList",WZUIImage):setVisible(i <= aptitude)
    end
    GetElement(self.m_root,"conExp_CellPetChoiceList",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"txtLv_CellPetChoiceList",WZUILabelTTF):setText("+"..self.m_nOtherValue)
end

--进阶界面的初始化
function CellPetChoiceList:_initEvolutionChoiceList()
    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.t_PetInfo.icon)
    local element =  GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
    WndPets:setIconQuality(element, quality)
    local name = "Lv"..self.t_PetInfo.upgradeLevel.." "..self.t_PetInfo.name --.."  ".."Lv."..self.t_PetInfo.upgradeLevel
    local nameText = GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF)
    nameText:setText(name)
    WndPets:setTextColor(GDatatab_item["id_"..self.t_PetInfo.itemId].quality, nameText)
   
   local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i =1 ,5 do
        GetElement(self.m_root,"imgAptitude"..i.."_CellPetChoiceList",WZUIImage):setVisible(i <= aptitude)
    end

    --GetElement(self.m_root,"txtLv_CellPetChoiceList",WZUILabelTTF):setVisible(false)
end

--重生界面的初始化
function CellPetChoiceList:_initRebirthChoiceList()
    GetElement(self.m_root,"conBg_CellPetChoiceList",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(485,92))
    GetElement(self.m_root,"conInfo_CellPetChoiceList",WZUIContainer):setRelativePosition(ccp(-0.05,0.5))
    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.t_PetInfo.icon)
    local element =  GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.t_PetInfo.itemId].quality
    WndPets:setIconQuality(element, quality)
    local name = self.t_PetInfo.name--.."  ".."Lv:"..self.t_PetInfo.upgradeLevel
    local nameText = GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF)
    nameText:setText(name)
    WndPets:setTextColor(GDatatab_item["id_"..self.t_PetInfo.itemId].quality, nameText)
   
   local aptitude = WndPets:getAptitude(self.t_PetInfo.giftSkill)
    for i =1 ,5 do
        GetElement(self.m_root,"imgAptitude"..i.."_CellPetChoiceList",WZUIImage):setVisible(i <= aptitude)
    end
    self.m_nOtherValue = self.t_PetInfo.fighting
    GetElement(self.m_root,"conWar_CellPetChoiceList",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"txtPetWarD_CellPetChoiceList",WZUILabelAtlasFont):setText(self.m_nOtherValue)
end


--升级界面按钮被按
function CellPetChoiceList:_doClickUp()
    if self.b_isClick then
        self:_setButtonState(false)
        WndPetsUpgrade:setPetExp(self.t_PetInfo,false, self.m_nOtherValue)
        WndPetsUpgrade:addChoicePet(false, self.n_Tag)
    else
        local bool,nTag = WndPetsUpgrade:checkExpSpill()
        if not  bool then
            self:_setButtonState(true)
            WZLog("GGGGGGGGGGGGG:",nTag)
            self.n_Tag = nTag
            WndPetsUpgrade:addChoicePet(true,self.n_Tag,self)
            WndPetsUpgrade:setPetExp(self.t_PetInfo,true, self.m_nOtherValue)
        end
    end
end

--进阶界面按钮被按
function CellPetChoiceList:_doClickEvolution()
    if self.b_isClick then
        self:_setButtonState(false)
        WndPetsEvolution:addChoicePet(false, self.n_Tag)
    else
        local bool,nTag = WndPetsEvolution:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetsEvolution:addChoicePet(true, self.n_Tag, self)
            self:_setButtonState(true)
        end
    end
end

--重生界面按钮被按
function CellPetChoiceList:_doClickRecover()
    if self.b_isClick then
        self:_setButtonState(false)
        WndPetRecover:addChoicePet(false, self.t_PetInfo)
    else
        local bool,nTag = WndPetRecover:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetRecover:addChoicePet(true, self.t_PetInfo)
            self:_setButtonState(true)
        end
    end
end

--设置选择按钮的现实状态
function CellPetChoiceList:_setButtonState(bState)
    WZLog("CellPetChoiceList:_setButtonState")
    if bState ~= nil then
        self.b_isClick = bState
    end
    local element = GetElement(self.m_root,"conGou_CellPetChoiceList",WZUIContainer)
    if element then
        element:setVisible(self.b_isClick)
    end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Began------------------------------------------
function CellPetChoiceList:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLv_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setScale(0.7)
end

function CellPetChoiceList:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
end

function CellPetChoiceList:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
end

function CellPetChoiceList:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
end

function CellPetChoiceList:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtName_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtLv_CellPetChoiceList",WZUILabelTTF):setFontSize(18)
end
-------------------------------------语言适配End--------------------------------------------
