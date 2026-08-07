--CellPetSell.lua
--@brief	CellPetSell的UI模块
--@date		2018/01/25
--@author	zsq
--@note		回收宠物cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetSell:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetSell:onExit(element)
	self:_unInit()
end

--@param  nType : 0->回收界面；1->升级界面 num:经验宝宝数量
function CellPetSell:setData(tData, nType,num,tag)
    self.m_nType = nType or 0
    self.m_tData = tData
    self.num = num or 0
    self.tag = tag

    self:_setStoneData(tData)
end

function CellPetSell:onClickBegan(element)
	WZLog("CellPetSell:onClickBegan")
	--self.selected = not self.selected
	--GetElement(self.m_root,"conSelect",WZUIContainer):setVisible(self.selected)
	self.onTouch = true
	self.m_root:enableSchedule("showTip",0.5)
end

function CellPetSell:showTip()
	WZLog("CellPetSell:showTip")
    self.m_root:disableSchedule()
    if self.onTouch then
        local parentNode = WndPetRecover.m_root
        if self.m_nType == 1 then 
            parentNode = WndPetsUpgrade.m_root
        elseif self.m_nType == 2 then 
            parentNode = WndPetsEvolution.m_root
        end

        if self.m_tData.basicInfo and self.m_tData.basicInfo.main_type == 43 then --宠物装备
            WndItemInfo:showInfo(self.m_root,parentNode,1,self.m_tData,false)
        else
            local tData = {}
            setmetatable(tData, {__index = self.m_tData})
            local tItem = GDatatab_item["id_"..tData.itemId]
            tData.quality = tItem.quality
            tData.gift = self.m_tData.giftSkill
            local tProperty = json.decode(self.m_tData.property)
            for i=1,20 do
                tData[tostring(i)] = tProperty[tostring(i)]
            end
    		WndTips:show(self.m_root, parentNode,13,tData,GlobalMethod:ccp(230,-10))
        end
    end
end

function CellPetSell:onMoveOut(element)
	WZLog("CellPetSell:onMoveOut")
	
end

function CellPetSell:onClickEnd(element)
	  WZLog("CellPetSell:onClickEnd")
	  self.onTouch = false
	
    if self.selected then
        self:setSelected(false)
        if self.m_nType == 1 then 
            
            if GDatatab_item["id_"..self.m_tData.itemId].sub_type == 0 then
                GetElement(self.m_root,"num",WZUILabelTTF):setText(tostring(self.m_tData.num))
                WZLog("取消1",self.chooseNum)
                WndPetsUpgrade:addChoiceExpPet(false, nil, self, self.chooseNum)
                self.chooseNum = 0
            else 
                WZLog("取消2")
                WndPetsUpgrade:addChoicePet(false, nil, self,self.chooseNum)
            end
        elseif self.m_nType == 2 then 
            WndPetsEvolution:addChoicePet(false, nil, self)
        else
            WndPetRecover:addChoicePet(false, self.m_tData)
        end
    else
        if self.m_nType == 1 then 
            local bool, nTag = WndPetsUpgrade:checkExpSpill(true)
            if not bool then 
                self.n_Tag = nTag
                -- local tag = self:getTag()

                if GDatatab_item["id_"..self.m_tData.itemId].sub_type == 0 then
                    -- WZLog("经验宠物弹出选择数量弹窗",Serialize(self.m_tData))
                    WZLog("经验宠物弹出选择数量弹窗",self.tag)
                    -- self:setSelected(false)
                    local nMaxNum = WndPetsUpgrade:getNeedMaxExpPetNum(self.m_tData.itemId)
                    if nMaxNum > 0 then 
                        local wndOpenChest = WndOpenChest:createElement()
                        WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
                        WndOpenChest:setPetData(self.m_tData, self.tag, self, nMaxNum)
                    else
                        MsgBoxManager:showTipBox(LocalStrings.PETNOTUPONE2)
                    end
                else 
                    if not WndPetsUpgrade:judgeLargerThanPlayer() then 
                        self:setSelected(true)
                        WndPetsUpgrade:addChoicePet(true, nTag, self,self.chooseNum)
                    end
                end

            end
        elseif self.m_nType == 2 then 
            local bool, nTag = WndPetsEvolution:checkPetSpill(true)
            if bool then 
                self.n_Tag = nTag
                WndPetsEvolution:addChoicePet(true, nTag, self)
                self:setSelected(true)
            end
        else
            local bool, nTag = WndPetRecover:checkPetSpill()
            if bool then
                self.n_Tag = nTag
                WndPetRecover:addChoicePet(true, self.m_tData)
                self:setSelected(true)
            end
        end
    end
end

function CellPetSell:getPetInfo()
    return self.m_tData
end

function CellPetSell:setSelected(bool)
    local conSelect = GetElement(self.m_root,"conSelect",WZUIContainer)
    if conSelect then
    	self.selected = bool
    	GetElement(self.m_root,"conSelect",WZUIContainer):setVisible(bool)
    end
end

function CellPetSell:doQuickRecover()
	if self.selected then return nil end
    if GDatatab_item["id_"..self.m_tData.itemId].quality >= 3 then --不能选择紫宠以上的
        return false
    end

    if self.m_nType == 1 then 
        local bool, nTag = WndPetsUpgrade:checkExpSpill(true)
        if not bool then 
            self.n_Tag = nTag 
            WndPetsUpgrade:addChoicePet(true, nTag, self)
            self:setSelected(true)
            return true
        end
    elseif self.m_nType == 2 then 
        local bool, nTag = WndPetsEvolution:checkPetSpill(true)
        if bool then 
            self.n_Tag = nTag
            WndPetsEvolution:addChoicePet(true, nTag, self)
            self:setSelected(true)
            return true
        end
    else
        local bool,nTag = WndPetRecover:checkPetSpill()
        if bool then
            self.n_Tag = nTag
            WndPetRecover:addChoicePet(true, self.m_tData)
            self:setSelected(true)
    	      return true
        end
    end

    return nil 
end

function CellPetSell:dochoiceRecover(num, bExcept)
    -- body
    if not bExcept then
        if self.selected then return nil end
    end
    if GDatatab_item["id_"..self.m_tData.itemId].quality >= 3 then --不能选择紫宠以上的
        return false
    end

    if self.m_nType == 1 then 
        local bool, nTag = WndPetsUpgrade:checkExpSpill(true, nil, bExcept)
        if not bool then 
            self.n_Tag = nTag 
            WndPetsUpgrade:addChoiceExpPet(true, nTag, self,num)
            self:setSelected(true)
            return true
        end
    end
    return nil 
end

function CellPetSell:doQuickChose(num1,num2)
    -- body
    if self.selected then return nil end
    if GDatatab_item["id_"..self.m_tData.itemId].quality >= 3 then --不能选择紫宠以上的
        return false
    end  
    if num1 == 16 then
        WndPetsUpgrade:addChoiceExpPet(true,1,self,16)
    elseif num1 < 16 and num1 + num2 == 16 then
        WndPetsUpgrade:addChoiceExpPet(true,1,self,num1)
        WndPetsUpgrade:addChoiceExpPet(true,2,self,16 - num1)
    elseif num1 + num2 < 16 then
        WndPetsUpgrade:addChoiceExpPet(true,1,self,num1)
        WndPetsUpgrade:addChoiceExpPet(true,2,self,num2)
        local lastNum = 16 - num1 - num2
        for i = 3,lastNum do 
            WndPetsUpgrade:addChoicePet(true,i,self)
            self:setSelected(true)
            return true
        end
    end
end

--@brief 改变选择经验宠物个数
function CellPetSell:changePetNum(num,data)
    -- body
    self.chooseNum = num
    GetElement(self.m_root,"num",WZUILabelTTF):setText(tostring(num).."/"..tostring(data.num))
end

--@brief    获取选中状态
function CellPetSell:getSelectedState()
    --body
    return self.selected
end

--@brief 更新经验宠物个数
function CellPetSell:updatePetNum(data)
    -- body
    self.chooseNum = 0
    GetElement(self.m_root,"num",WZUILabelTTF):setText(tostring(data.num))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetSell:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellPetSell")
	assert(cellElement, "CellPetSell cellElement create failed!")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

    GetElement(self.m_root,"imgIconBg_CellPetChoiceList",WZUIImage):setFile(self.m_tData.icon)
    local bg = GetElement(self.m_root,"imgIconBgQuality_CellPetChoiceList",WZUIImage)
    local quality = GDatatab_item["id_"..self.m_tData.itemId].quality
  	local qualtyFile = {"frame_green.png","frame_bule.png","frame_violet.png","frame_orange.png"}
  	local file = "ui/common/"..qualtyFile[quality]
  	bg:setFile(file)
    if self.m_tData.basicInfo and self.m_tData.basicInfo.main_type == 43 then --宠物装备

        GetElement(self.m_root,"starImg",WZUIImage):setVisible(false)
        GetElement(self.m_root,"star",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"lv",WZUILabelTTF):setVisible(false)
        if self.m_tData.extraInfo.starLevel and self.m_tData.extraInfo.starLevel > 0 then
            GetElement(self.m_root,"starImg",WZUIImage):setVisible(true)
            GetElement(self.m_root,"star",WZUILabelTTF):setVisible(true)
            GetElement(self.m_root,"star",WZUILabelTTF):setText(self.m_tData.extraInfo.starLevel)
        end
        if self.m_tData.extraInfo.strongLevel and self.m_tData.extraInfo.strongLevel > 0 then
            GetElement(self.m_root,"lv",WZUILabelTTF):setVisible(true)
            GetElement(self.m_root,"lv",WZUILabelTTF):setText(LocalStrings.LV..self.m_tData.extraInfo.strongLevel)
        end
        self:_showStone()
    elseif self.m_tData.itemId == 11007 or self.m_tData.itemId == 11000 then
        WZLog("经验宝宝item")
        GetElement(self.m_root,"starImg",WZUIImage):setVisible(false)
        GetElement(self.m_root,"star",WZUILabelTTF):setVisible(false)
        local num = GetElement(self.m_root,"num",WZUILabelTTF)
        num:setVisible(true)
        num:setText(self.m_tData.num)
    else 
    	--宠物星级
       local aptitude = WndPets:getAptitude(self.m_tData.giftSkill)
       GetElement(self.m_root,"star",WZUILabelTTF):setText(aptitude)
       --宠物等级
       GetElement(self.m_root,"lv",WZUILabelTTF):setText(LocalStrings.LV..self.m_tData.upgradeLevel)
   end 
end


--@brief    宝石列表
function CellPetSell:_setStoneData(tItemData)
    if tItemData == nil then
        return
    end
    self.m_tStone = {}
    local tData = tItemData.extraInfo
    
    if tData ~= nil then
        if tData.attackStone and tData.attackStone > 0 then--攻击宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.attackStone])
        end
        if tData.defendStone and tData.defendStone > 0 then--防御宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.defendStone])
        end
        if tData.hpStone and tData.hpStone > 0 then--生命宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.hpStone])
        end
        if tData.gongmingStone and tData.gongmingStone > 0 then--共鸣宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.gongmingStone])
        end
    end
end

--@brief    装备镶嵌
function CellPetSell:_showStone(xOffset, yOffset)
    if self.m_root == nil then return end
    if self.m_tStone == nil or #self.m_tStone == 0 then
        return
    end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    for i = 1, 5 do
        if conItem:getChildByTag(9990 + i) then 
            conItem:removeChildByTag(9990 + i, true)
        end
    end
    local x = -0.01
    local hasStone = false
    local index = 1
    local offsetX = xOffset or 0
    local offsetY = yOffset or 0
    WZLog("CellGoodItem:_showStone")
    for i,data in pairs(self.m_tStone) do
        x = x + self.m_nSpace
        local image
        if i==3 then
            image = self:_createImgStone(data.icon,ccp(x + offsetX,0.255 + offsetY),0.24)
        else
            image = self:_createImgStone(data.icon,ccp(x + offsetX,0.25 + offsetY),0.24)
        end
        image:setTag(9990 + i)
        conItem:addChild(image,10)
        self:_createAniStone(data,index,0+i*15)
        index = index + 1
        hasStone = true
    end
    --有宝石的话加上底图
    if hasStone then
        local image = self:_createImgStone("ui/common/common_scale9_di40.png",ccp(0.43 + offsetX,0.128 + offsetY),1,ccp(0.5,0.5),true)
        image:setScaleX(1.26)
        image:setTag(9995)
        conItem:addChild(image)
    end
end

--@brief    装备镶嵌图片
function CellPetSell:_createImgStone(icon,pt,scale,anchor,bOrigin)
    pt = pt or ccp(0.5,0.5)
    anchor = anchor or ccp(0.5,1)
    scale = scale or 1
    bOrigin = bOrigin or true
    local image = WZUIImage:create()
    image:setFile(icon)
    image:setAnchorPoint(anchor)
    image:setRelativePosition(pt)
    image:setUseOriginSize(bOrigin)
    image:setScale(scale)
    return image
end

--@brief    装备镶嵌特效
function CellPetSell:_createAniStone(tData,index,positionX)
    if self.m_root == nil then return end
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    local ani = self["m_aniStone"..index]
    WZLog("CellGoodItem:_createAniStone","m_aniStone"..index)
    local level  = tData.value
    if level < 8 then return end
    if ani == nil then
        ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
        ani:getAnimNode():setUseAbsCoordinate(true)
        ani:getAnimNode():setAbsPosition(ccp(positionX,10))
        ani:getAnimNode():setLoop(true)
        conItem:addChild(ani:getAnimNode(),9)

        if level == 8 or level == 9 then
            ani:play("xiangqian_bai",true)  
        elseif level >= 10 then
            ani:play("xiangqian_jin",true)  
        end
    end
    self["m_aniStone"..index] = ani
end

-------------------------------------私有方法模块End----------------------------------------
