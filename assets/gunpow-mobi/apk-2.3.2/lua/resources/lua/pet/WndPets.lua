--WndPets.lua
--@brief  WndPets的UI模块
--@date   2015/03/26
--@author qixiang_xie
--@note   宠物模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief  进入场景时被调用的函数
--@param  element:表绑定的UI节点引用
--@note   在这里做场景进入前的准备工作
function WndPets:onEnter(element)
    WZLog("WndPets:onEnter")
    self.m_root = element 
    AdaptLanguage(self)

  PET_MAX_NUM = tonumber(CacheCenter:getGameParam()["petNumUpper"])
    
    --self:_conAddChild()

    ProtocolProcessorScenePets:regAll()
    ProtocolProcessorScenePets:send_PET_GetFreeTime()
    local hasPetInfo  =  CacheCenter:hasPlayerPetInfo()
    WZLog("WndPets:onEnter hasPetInfo:",hasPetInfo)
    if true or hasPetInfo ==false then
        --获取宠物缓存信息
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
        ProtocolProcessorScenePets:send_PET_GetAllPetList()
    else
        table.sort(CacheCenter:getPlayerPetInfo(),sortPets)
        self:setPetList()
    end
    self:_addTop()

    --监听玩家宠物信息改变
    CacheCenter:registerUpatePlayerPetInfoObserver(self)
    CacheCenter:registerUpatePlayerInfoObserver(self)
     --左右容器移动动画
    local leftCon = GetElement(self.m_root,"conPetLeft_WndPets",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,false)

    local rightCon = GetElement(self.m_root,"conPetRight_WndPets",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(rightCon,1,false)

    --新手定推礼包入口
    CreateLimitPackage(27, leftCon, GlobalMethod:ccp(0.08,0.9))

    local isEndTeach12, teachStep12 = TeachGroup1:isTeachFinish(12)
    if isEndTeach12 ~= true and teachStep12 < 5 then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {12,3,WndPets.m_root})
    end

    local isEndTeach19, teachStep19 = TeachGroup1:isTeachFinish(19)
    if isEndTeach19 ~= true and teachStep19 > 1 and CacheCenter:getPlayerInfo().level == 20 then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {19,3,WndPets.m_root})
    end

    self:updatePartner()
    --羁绊入口红点
    self:setFetterRedDot()
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
--@note   在这里做场景退出前的清理工作
function WndPets:onExit(element)
  WZLog("WndPets:onExit")
  self:_unInit()
  CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
  CacheCenter:unregisterUpatePlayerInfoObserver(self)
  CCArmatureDataManager:sharedArmatureDataManager():removeAll()
end

--@brief  更新伙伴
function WndPets:updatePartner()
    if self.m_root == nil then return end 
    
    local check1 = GetElement(self.m_root,"checkbox1_WndPartner",WZUICheckBox)
    local check2 = GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox)
    local check3 = GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox)
    local check4 = GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox)


    if not CheckButtonOpen(ISLAND_RIGHT_MOUNT, true) then
        check2:setVisible(false)
    end

    if not CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, true) then
        check3:setVisible(false)
        check4:setRelativePosition(GlobalMethod:ccp(0.5,0.35))
    end

    if not CheckButtonOpen(ISLAND_RIGHT_PHANTOM, true) then
        check4:setVisible(false)
    end

    self:updateRedDot()

    self:showSpecifyContent()
end

--@brief  更新红点
function WndPets:updateRedDot()
    local redDot0 = GetElement(WndPets.m_root,"redDot0_WndPets",WZUIImage)
    local redDot1 = GetElement(WndPets.m_root,"redDot1_WndPets",WZUIImage)
    local redDot2 = GetElement(WndPets.m_root,"redDot2_WndPets",WZUIImage)
    local redDot3 = GetElement(WndPets.m_root,"redDot3_WndPets",WZUIImage)

    local check1 = GetElement(self.m_root,"checkbox1_WndPartner",WZUICheckBox)
    local check2 = GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox)
    local check3 = GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox)
    local check4 = GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox)
    SceneCity:setRedPoint(check1, GlobalGame.g_tRedPointList.petFetter, GlobalMethod:ccp(150,60))
    SceneCity:setRedPoint(check2, CacheCenter:getRedState("btnMount"), GlobalMethod:ccp(150,60))
    SceneCity:setRedPoint(check3, CacheCenter:getRedState("btnFootMark"), GlobalMethod:ccp(150,60))
    SceneCity:setRedPoint(check4, CacheCenter:getRedState("btnPhantom") or GlobalGame.g_tRedPointList.phantomEquipment or GlobalGame.g_tRedPointList.phantomGroup, GlobalMethod:ccp(150,60))

    --幻化二级标签红点-皮肤装备
    local btn4_2 = GetElement(self.m_root,"btn4_2",WZUIButton)
    SceneCity:setRedPoint(btn4_2, GlobalGame.g_tRedPointList.phantomEquipment, GlobalMethod:ccp(135,55))
    --幻化二级标签红点-共生录
    local btn4_3 = GetElement(self.m_root,"btn4_3",WZUIButton)
    SceneCity:setRedPoint(btn4_3, GlobalGame.g_tRedPointList.phantomGroup, GlobalMethod:ccp(135,55))

    --坐骑灵石红点
    local status = false
    if CheckButtonShow(MOUNTSTONE) then
        status = GlobalGame.g_tRedPointList.mountstone_redpoint
    end
    local btnMountStone = GetElement(self.m_root,"btnMountStone2_WndPets",WZUIButton)
    SceneCity:setRedPoint(btnMountStone, status, GlobalMethod:ccp(135,55))
    --坐骑二级标签红点
    local btnMountStone1 = GetElement(self.m_root,"btnMountStone1_WndPets",WZUIButton)
    SceneCity:setRedPoint(btnMountStone1, CacheCenter:getRedState("btnMount"), GlobalMethod:ccp(135,55))

end

--@brief  宠物被选中时调用的函数
function WndPets:onPetSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    GetElement(self.m_root,"conForPet_WndPets",WZUIContainer):setVisible(true)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
    conMidContent:setVisible(false)
    conMidContent:removeAllChildrenWithCleanup(true)
    GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)

    local con = GetElement(self.m_root,"conPetSub_WndPets",WZUIContainer)
    con:removeAllChildrenWithCleanup(true)

    self:setMountChildTitle(false)
    self:setPhantomChildTitle(false)
    self:setPetChildTitle(true, self.m_nPetChildIndex)
    self:setFootChildTitle(false)

    WndPets:showPetUI(true,false)
end

--@brief  坐骑被选中时调用的函数
function WndPets:onMountSelect(element)
  if WndMounts.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    GetElement(self.m_root,"conForPet_WndPets",WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)

    self:setPetChildTitle(false)
    self:setPhantomChildTitle(false)
    self:setMountChildTitle(true, self.m_nMountChildIndex)
    self:setFootChildTitle(false)

  end
end

--@brief  足迹被选中时调用的函数
function WndPets:onFootSelect(element)
  if WndFootMark.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    GetElement(self.m_root,"conForPet_WndPets",WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)

    self:setPetChildTitle(false)
    self:setMountChildTitle(false)
    self:setPhantomChildTitle(false)
    self:setFootChildTitle(true, self.m_nFootChildIndex)

  end
end

--@brief    幻化被选中时调用的函数
function WndPets:onPhantomSelect(element)
  if WndPhantom.m_root == nil then
    self.m_nSpecifyIndex = 4
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    GetElement(self.m_root, "conForPet_WndPets", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)

    self:setPetChildTitle(false)
    self:setMountChildTitle(false)
    self:setPhantomChildTitle(true, self.m_nPhantomChildIndex)
    self:setFootChildTitle(false)
  end
end



--宠物下面的二级标签
function WndPets:setPetChildTitle(visible, index)
    WZLog("WndPets:setPetChildTitle")
    local petChildTitle = GetElement(self.m_root,"petChildTitle",WZUIContainer)
    petChildTitle:setVisible(visible)
    if visible == false then
        GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.6))
        GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
        GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.35))
        return 
    end
    local tBtnId = {27,222} --对应功能开放表id
    local tBtnTxt = {LocalStrings.BAG7,LocalStrings.PET_EQUIPMENT_1}
    for i=#tBtnId,1,-1 do
      if not CheckButtonOpen(tBtnId[i],true) then
        table.remove(tBtnId,i)
        table.remove(tBtnTxt,i)
      end
    end
    GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.6-#tBtnId*0.25))
    GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1-#tBtnId*0.25))
    GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.35-#tBtnId*0.25))

    if self.m_tPetChileTitle == nil then
      self.m_tPetChileTitle = {}
      for i=1,#tBtnId do
        local tab = {}
        local btn = GetElement(petChildTitle,"btn1_"..i,WZUIButton)
        btn:setVisible(true)
        tab.normal = GetElement(btn,"normal",WZUIImage)
        tab.select = GetElement(btn,"select",WZUIImage)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
        tab.name:setText(tBtnTxt[i])
        tab.nId = tBtnId[i]
        self.m_tPetChileTitle[i] = tab
      end
      self.m_nPetChildIndex = index or 1
      self.m_tPetChileTitle[self.m_nPetChildIndex].normal:setVisible(false)
      self.m_tPetChileTitle[self.m_nPetChildIndex].select:setVisible(true)
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setEnableStroke(false)
    end
    self:setPetChangeChildView(self.m_nPetChildIndex)
end

--@param    element:可以传数字tag值
function WndPets:onBtnPetChild( element )
  local tag = type(element) == "number" and element or element:getTag()
  if tag == self.m_nPetChildIndex then return end

  if self.m_tPetChileTitle[self.m_nPetChildIndex] then
      self.m_tPetChileTitle[self.m_nPetChildIndex].normal:setVisible(true)
      self.m_tPetChileTitle[self.m_nPetChildIndex].select:setVisible(false)
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setEnableStroke(true)
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setStrokeSize(4)
      self.m_tPetChileTitle[self.m_nPetChildIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
  end
  if self.m_tPetChileTitle[tag] then
      self.m_tPetChileTitle[tag].normal:setVisible(false)
      self.m_tPetChileTitle[tag].select:setVisible(true)
      self.m_tPetChileTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tPetChileTitle[tag].name:setEnableStroke(false)
  end
  self.m_nPetChildIndex = tag
  self:setPetChangeChildView(tag)
end

function WndPets:setPetChangeChildView(index)
    if self.m_tPetChileTitle[self.m_nPetChildIndex].nId == 27 then
      GetElement(self.m_root,"conForPet_WndPets",WZUIContainer):setVisible(true)
      GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)
      local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
      conMidContent:setVisible(false)
      conMidContent:removeAllChildrenWithCleanup(true)

      local con = GetElement(self.m_root,"conPetSub_WndPets",WZUIContainer)
      con:removeAllChildrenWithCleanup(true)

      WndPets:showPetUI(true,false)
    elseif self.m_tPetChileTitle[self.m_nPetChildIndex].nId == 222 then
      GetElement(self.m_root, "conForPet_WndPets", WZUIContainer):setVisible(false)
      GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(0)
      local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
      conMidContent:setVisible(true)
      conMidContent:removeAllChildrenWithCleanup(true)

      --宠物装备
      local wndPetsEquipment = WndPetsEquipment:createElement()
      conMidContent:addChild(wndPetsEquipment)
    end
end



--幻化下面的二级标签
function WndPets:setPhantomChildTitle(visible, index)
    WZLog("WndPets:setPhantomChildTitle")
    local phantomChildTitle = GetElement(self.m_root,"phantomChildTitle",WZUIContainer)
    phantomChildTitle:setVisible(visible)
    if visible == false then
        GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
        return 
    end
    local tBtnId = {118,202,219} --对应功能开放表id
    local tBtnTxt = {LocalStrings.PHANTOM1,LocalStrings.PHANTOM_EQUIPMENT1,LocalStrings.PHANTOM_COMBINATION_1}
    for i=#tBtnId,1,-1 do
      if not CheckButtonOpen(tBtnId[i],true) then
        table.remove(tBtnId,i)
        table.remove(tBtnTxt,i)
      end
    end
    GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1-#tBtnId*0.25))

    if self.m_tPhantomChileTitle == nil then
      self.m_tPhantomChileTitle = {}
      for i=1,#tBtnId do
        local tab = {}
        local btn = GetElement(phantomChildTitle,"btn4_"..i,WZUIButton)
        btn:setVisible(true)
        tab.normal = GetElement(btn,"normal",WZUIImage)
        tab.select = GetElement(btn,"select",WZUIImage)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
        tab.name:setText(tBtnTxt[i])
        tab.nId = tBtnId[i]
        self.m_tPhantomChileTitle[i] = tab
      end
      self.m_nPhantomChildIndex = index or 1
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].normal:setVisible(false)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].select:setVisible(true)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setEnableStroke(false)
    end
    self:setPhantomChangeChildView(self.m_nPhantomChildIndex)
end

--@param    element:可以传数字tag值
function WndPets:onBtnPhantomChild( element )
  local tag = type(element) == "number" and element or element:getTag()
  if tag == self.m_nPhantomChildIndex then return end

  if self.m_tPhantomChileTitle[self.m_nPhantomChildIndex] then
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].normal:setVisible(true)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].select:setVisible(false)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setEnableStroke(true)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setStrokeSize(4)
      self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
  end
  if self.m_tPhantomChileTitle[tag] then
      self.m_tPhantomChileTitle[tag].normal:setVisible(false)
      self.m_tPhantomChileTitle[tag].select:setVisible(true)
      self.m_tPhantomChileTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tPhantomChileTitle[tag].name:setEnableStroke(false)
  end
  self.m_nPhantomChildIndex = tag
  self:setPhantomChangeChildView(tag)
end

function WndPets:setPhantomChangeChildView(index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
    conMidContent:setVisible(true)
    conMidContent:removeAllChildrenWithCleanup(true)
    if self.m_tPhantomChileTitle[self.m_nPhantomChildIndex] == nil then return end 
    
    if self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].nId == 118 then
      local wndPhantom = WndPhantom:createElement()
      conMidContent:addChild(wndPhantom)
      if self.m_nSelectedShapeId then
        WndPhantom:setSelectedShapeId(self.m_nSelectedShapeId)
      end
    elseif self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].nId == 202 then
      local wndPhantomEquipment = WndPhantomEquipment:createElement()
      conMidContent:addChild(wndPhantomEquipment)
    elseif self.m_tPhantomChileTitle[self.m_nPhantomChildIndex].nId == 219 then
      local wndPhantomGroup = WndPhantomGroup:createElement()
      conMidContent:addChild(wndPhantomGroup)
    end
end

--坐骑下面的二级标签
function WndPets:setMountChildTitle(visible, index)
    local mountChildTitle = GetElement(self.m_root,"mountChildTitle",WZUIContainer)
    mountChildTitle:setVisible(visible)
    if visible == false then
        GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
        GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.35))
        return 
    end
    local title_num = 0
    if CheckButtonShow(MOUNTSTONE) then
        title_num = 2
    end
    if self.m_tMountChileTitle == nil then
        self.m_tMountChileTitle = {}
        for i=1, title_num do
            local tab = {}
            local btn = GetElement(mountChildTitle,"btnMountStone"..i.."_WndPets",WZUIButton)
            btn:setVisible(true)
            tab.normal = GetElement(btn,"normal",WZUIImage)
            tab.select = GetElement(btn,"select",WZUIImage)
            tab.name = GetElement(btn,"name",WZUILabelTTF)
            self.m_tMountChileTitle[i] = tab
        end
        self.m_nMountChildIndex = index or 1
        if self.m_tMountChileTitle[self.m_nMountChildIndex] then
            self.m_tMountChileTitle[self.m_nMountChildIndex].normal:setVisible(false)
            self.m_tMountChileTitle[self.m_nMountChildIndex].select:setVisible(true)
            self.m_tMountChileTitle[self.m_nMountChildIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
            self.m_tMountChileTitle[self.m_nMountChildIndex].name:setEnableStroke(false)
        end
    end
    self:setChangeChildView(self.m_nMountChildIndex)
    
    if title_num == 1 then
        GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,-0.15))
        GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.1))
    elseif title_num == 2 then
        GetElement(self.m_root,"checkbox3_WndPet",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,-0.4))
        GetElement(self.m_root,"checkbox4_WndPartner",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,-0.15))
    end
end
function WndPets:onBtnMountChild( element )
  local tag = element:getTag()
  if tag == self.m_nMountChildIndex then return end

  if self.m_tMountChileTitle[self.m_nMountChildIndex] then
      self.m_tMountChileTitle[self.m_nMountChildIndex].normal:setVisible(true)
      self.m_tMountChileTitle[self.m_nMountChildIndex].select:setVisible(false)
      self.m_tMountChileTitle[self.m_nMountChildIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
      self.m_tMountChileTitle[self.m_nMountChildIndex].name:setEnableStroke(true)
      self.m_tMountChileTitle[self.m_nMountChildIndex].name:setStrokeSize(4)
      self.m_tMountChileTitle[self.m_nMountChildIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
  end
  if self.m_tMountChileTitle[tag] then
      self.m_tMountChileTitle[tag].normal:setVisible(false)
      self.m_tMountChileTitle[tag].select:setVisible(true)
      self.m_tMountChileTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tMountChileTitle[tag].name:setEnableStroke(false)
  end
  self:setChangeChildView(tag)

  self.m_nMountChildIndex = tag
end
function WndPets:setChangeChildView(index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
    conMidContent:setVisible(true)
    conMidContent:removeAllChildrenWithCleanup(true)
    if index == 1 then
      local wndMounts = WndMounts:createElement()
      conMidContent:addChild(wndMounts)
    elseif index == 2 then
      GetElement(self.m_root, "conGroup_WndPets", WZUIContainer):setZOrder(1)
      local wndStone = WndMountStone:createElement()
      conMidContent:addChild(wndStone)
    end
end


--足迹下面的二级标签
function WndPets:setFootChildTitle(visible, index)
    WZLog("WndPets:setFootChildTitle")
    local footChildTitle = GetElement(self.m_root,"footChildTitle",WZUIContainer)
    footChildTitle:setVisible(visible)
    if visible == false then
        return 
    end
    local tBtnId = {141,203} --对应功能开放表id
    local tBtnTxt = {LocalStrings.PARTNER_2,LocalStrings.FOOT_STAR_TEXT1}
    for i=#tBtnId,1,-1 do
      if not CheckButtonOpen(tBtnId[i],true) then
        table.remove(tBtnId,i)
        table.remove(tBtnTxt,i)
      end
    end

    if self.m_tFootChileTitle == nil then
      self.m_tFootChileTitle = {}
      for i=1,#tBtnId do
        local tab = {}
        local btn = GetElement(footChildTitle,"btn3_"..i,WZUIButton)
        btn:setVisible(true)
        tab.normal = GetElement(btn,"normal",WZUIImage)
        tab.select = GetElement(btn,"select",WZUIImage)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
        tab.name:setText(tBtnTxt[i])
        tab.nId = tBtnId[i]
        self.m_tFootChileTitle[i] = tab
      end
      self.m_nFootChildIndex = index or 1
      self.m_tFootChileTitle[self.m_nFootChildIndex].normal:setVisible(false)
      self.m_tFootChileTitle[self.m_nFootChildIndex].select:setVisible(true)
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setEnableStroke(false)
    end
    self:setFootChangeChildView(self.m_nFootChildIndex)
end

--@param    element:可以传数字tag值
function WndPets:onBtnFootChild( element )
  local tag = type(element) == "number" and element or element:getTag()
  if tag == self.m_nFootChildIndex then return end

  if self.m_tFootChileTitle[self.m_nFootChildIndex] then
      self.m_tFootChileTitle[self.m_nFootChildIndex].normal:setVisible(true)
      self.m_tFootChileTitle[self.m_nFootChildIndex].select:setVisible(false)
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setEnableStroke(true)
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setStrokeSize(4)
      self.m_tFootChileTitle[self.m_nFootChildIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
  end
  if self.m_tFootChileTitle[tag] then
      self.m_tFootChileTitle[tag].normal:setVisible(false)
      self.m_tFootChileTitle[tag].select:setVisible(true)
      self.m_tFootChileTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tFootChileTitle[tag].name:setEnableStroke(false)
  end
  self.m_nFootChildIndex = tag
  self:setFootChangeChildView(tag)
end

function WndPets:setFootChangeChildView(index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndPets",WZUIContainer)
    conMidContent:setVisible(true)
    conMidContent:removeAllChildrenWithCleanup(true)
    if self.m_tFootChileTitle[self.m_nFootChildIndex].nId == 141 then
      local wndFootMark = WndFootMark:createElement()
      conMidContent:addChild(wndFootMark)
    elseif self.m_tFootChileTitle[self.m_nFootChildIndex].nId == 203 then
      local wndFootStar = WndFootStar:createElement()
      conMidContent:addChild(wndFootStar)
    end
end


--@brief    用来在共生录跳转到皮肤界面指定皮肤
function WndPets:jumpPhantomGroup(shapeId)
  if WndPets.m_root == nil then
    return
  end
  self.m_nSelectedShapeId = shapeId
  WndPets:onPhantomSelect() --点击幻化一级按钮
  WndPets:onBtnPhantomChild(1) --点击幻化二级按钮
  self.m_nSelectedShapeId = nil
end

--@brief   获取抽奖宠物时间成功
function WndPets:getTime(type,time)
  WZLog("wndpets:gettime",GlobalGame.g_tRedPointList.lottery2_redPoint)
  if self.m_root == nil then
    return
  end
  local con1 = self.m_root:getChildElement("btnObtainPet_WndPets")
  local isRed = GlobalGame.g_tRedPointList.lottery2_redPoint
  if not isRed then
    AddRemark(con1, false)
  else
    AddRemark(con1, true, GlobalMethod:ccp(0.8,0.8))
  end
end

function WndPets:updatePlayerInfoData()
    if self.m_root and  self.m_isToWar then
        self.m_isToWar = false
        upPlayerFightingAni()
    end
end

--@brief    关闭按钮点击被调用的函数
--@param  element:表绑定的UI节点引用
--@note   退出当前场景
function WndPets:onCloseClick(element)
  WZLog("WndPets:onCloseClick")
  SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
   WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.onClose,true)
  
end

--@brief  移除场景
function WndPets:onClose()
  WZLog("WndPets:onClose")
  WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  返回上一个场景
function WndPets:goBack()
  local scene = self.m_tBackSceneLuaObj:createElement()
  replaceScene(scene)
end

--切换场景
function WndPets:setCon(bTag)
  WZLog("WndPets:setCon")
  if bTag == nil then
    bTag = 1
  end
  self:_setConChildVisble(bTag)
end


--@brief    获取宠物按钮点击调用的函数
--@param  element:表绑定的UI节点引用
function WndPets:onClassifyClick(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local tag = element:getTag()
  self.m_nTag = tag - 1
  self:setPetList(false)
end

--@brief  宠物功能按钮点击调用的函数
--@param  element:表绑定的UI节点引用
function WndPets:onFunctionClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    TeachGroup1:endTeachStep({12,3},{12,7})
    local tag = element:getTag()
    local buttonId = {27,44,45,47,46,48}
    -- if false or not CheckButtonOpen(buttonId[tag]) then
    --   return
    -- end
    --经验宠物不执行非抽奖动作
    if tag ~= 5 and tag ~= 7 and tag ~= 8 and self.m_tCurPetsInfo and self:isExpPet(self.m_tCurPetsInfo.itemId) then
        MsgBoxManager:showTipBox(LocalStrings.ISEXPPET)
        return
    end
    --如果不是出战界面，否则都需添加新界面
    if tag ~= 1 then
        self.n_refreshState = 1
    end
    if tag == 1 then      --出战
      if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then
        self.n_refreshState = 0
        MsgBoxManager:showTipBox(LocalStrings.PET_FETTER6)
        return
      end
      self.m_choicePetList:onFighting()
    elseif tag == 2 then  --升级
        if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.PET_FETTER6)
            return 
        end
        self:onUpgradeClick()
    elseif tag == 3 then  --进阶
        if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.PET_FETTER6)
            return 
        end
        self:onEvolutionClick()
    elseif tag == 4 then  --技能
        if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.PET_FETTER6)
            return 
        end
        self:onSkillClick()
    elseif tag == 5 then  --获取宠物
        self:onObtainPetClick()
    elseif tag == 6 then  --重生
      if self.m_tCurPetsInfo == "" then
          self.n_refreshState = 0
          MsgBoxManager:showTipBox(LocalStrings.PETNOREBIRTH)
          return
      end
      if self.m_tCurPetsInfo then
        if self.m_tCurPetsInfo.upgradeLevel > 1 or self.m_tCurPetsInfo.advancedLevel > 0 then
          self:onRebirthClick(element)
        end
      else
        self.n_refreshState = 0
        MsgBoxManager:showTipBox(LocalStrings.PETNOREBIRTH)
      end
    elseif tag == 7 then  --回收 
        self:onRecoverClick()
    elseif tag == 8 then  --商店  
        self:onShopClick()
    elseif tag == 9 then  --资质洗练
        self:onWashGiftClick()
    elseif tag == 10 then
        JumpByUIId(188)
    elseif tag == 11 then --羁绊
        if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.PET_FETTER6)
            return 
        end
        if self:isExpPet(self.m_tCurPetsInfo.itemId) then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.ISEXPPET)
            return 
        end 
        if GDatatab_item["id_" .. self.m_tCurPetsInfo.itemId].quality < 3 then 
            self.n_refreshState = 0
            MsgBoxManager:showTipBox(LocalStrings.PET_FETTER5)
            return 
        end 
        -- WndPetFetter:showInterface(self.m_tCurPetsInfo)
        local wndPetFetter = WndPetFetter:createElement()
        WndPetFetter:setCurPetsInfoData(self.m_tCurPetsInfo)
        local conPetSub = GetElement(self.m_root, "conPetSub_WndPets", WZUIContainer)
        conPetSub:addChild(wndPetFetter)

        WndPets:showPetUI(false,true)
    end
end

--@brief  宠物功能按钮点击调用的函数
--@param  element:表绑定的UI节点引用
function WndPets:onFunctionDown(element)
   --WZLog("WndPets:onFunctionDown")
   --BtnActionManager:onDownAction(element)
end

--@brief  宠物功能按钮点击调用的函数
--@param  element:表绑定的UI节点引用
function WndPets:onFunctionOut(element)
   --WZLog("WndPets:onFunctionOut")
  -- BtnActionManager:onUpAction(element)
end

--@brief  点击返回按钮执行的函数
--@param  element:表绑定的UI节点引用
function WndPets:onPetSkill(element)
  WZLog("WndPets:onPetSkill")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local tag =  element:getTag()
  local s = ""
  if tag == 1 then
    if self.m_tCurPetsInfo.commonSkill1 ~=nil and self.m_tCurPetsInfo.commonSkill1 ~= 0 then
      s = self:setSkillDesc(self.m_tCurPetsInfo.commonSkill1)
    else
      s = LocalStrings.PETSKILLDESC1
    end
    local con = GetElement(self.m_root,"conPetSkill1_WndPets",WZUIContainer)
    local parent = GetElement(self.m_root,"conPetLeft_WndPets",WZUIContainer)
    WndItemInfo:showInfo(con,parent,3,s,false)
  end
  if tag == 2 then
    if self.m_tCurPetsInfo.commonSkill2 ~=nil and self.m_tCurPetsInfo.commonSkill2 ~= 0 then
      s = self:setSkillDesc(self.m_tCurPetsInfo.commonSkill2)
    else
      s = LocalStrings.PETSKILLDESC2
    end
    local con = GetElement(self.m_root,"conPetSkill2_WndPets",WZUIContainer)
    local parent = GetElement(self.m_root,"conPetLeft_WndPets",WZUIContainer)
    WndItemInfo:showInfo(con,parent,3,s,false)
  end
  if tag == 3 then
     if self.m_tCurPetsInfo.birthSkill ~=nil and self.m_tCurPetsInfo.birthSkill ~= 0 then
      s = self:setSkillDesc(self.m_tCurPetsInfo.birthSkill)
    else
      s = LocalStrings.PETSKILLDESC3
    end
    local con = GetElement(self.m_root,"conPetSkill3_WndPets",WZUIContainer)
    local parent = GetElement(self.m_root,"conPetLeft_WndPets",WZUIContainer)
    WndItemInfo:showInfo(con,parent,3,s,false)
  end
end

--@brief 点击详情查看
function WndPets:onLookSp(element)
   WZLog("WndPets:onLookSp")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local parent = GetElement(self.m_root,"conPetLeft2_WndPets",WZUIContainer)
  if not self.m_tCurPetsInfo then
    return
  end 
  local tData = {value = math.ceil(self.m_tCurPetsInfo.giftSkill/100)}
  WndTips:show(element,parent,5,tData,GlobalMethod:ccp(300,60))
    --去详情查看
end

--@brief 判断设置技能描述
--param skillID 宠物技能id
function WndPets:setSkillDesc(skillID)
  WZLog("WndPets:setSkillDesc")
  local tab = GDatatab_pet_skill_new["id_"..skillID]
  local s = tab.name..":"..tab.desc
  return s
end

function WndPets:onTouchBegin(element,pt)
    WZLog("WndPets:onTouchBegin")
    WndItemInfo:onCloseClick()
    WndTips:onCloseClick()
    WndPhantom:hideRefineRecord()
    WndPetsEquipment:hideScheme(element, pt)
end

--@brief    宠物回收按钮点击调用的函数
function WndPets:onRecoverClick()
    WZLog("WndPets:WndPetRecover")
    if self.m_root == nil then
      return
    end
    local wndPetRecover = WndPetRecover:createElement()
    WindowManager:addWindow(wndPetRecover, WndPetRecover)
end

--@brief    宠物商店按钮点击调用的函数
function WndPets:onShopClick()
    WZLog("WndPets:onShopClick")
    if self.m_root == nil then
      return
    end
    WndStore:showStoreByType(3)
end

--@brief    宠物商店按钮点击调用的函数
function WndPets:onWashGiftClick()
    WZLog("WndPets:onWashGiftClick")
    if self.m_root == nil then
      return
    end
    local wndPetGift = WndPetGift:createElement()
    WindowManager:addWindow(wndPetGift, WndPetGift)
    WndPetGift:setPetInfo(self.m_tCurPetsInfo)
end


--@brief    获取宠物按钮点击调用的函数
--@param  element:表绑定的UI节点引用
--@note   跳转到获取宠物系统
function WndPets:onObtainPetClick()
    WZLog("WndPets:onObtainPetClick")
    if self.m_root == nil then
      return
    end
    if m_tPets ~= nil and #m_tPets >= PET_MAX_NUM then
          MsgBoxManager:showTipBox(LocalStrings.PET_SUM_EXCEED_ALTER)
          return
    end
    -- local wndPetRaffle = WndPetRaffle:createElement()
    -- WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
    WndSummonEntrance:showInterface(2)
end

--@brief 判断是否是经验宝宝
--@param petId 宠物的id
function WndPets:isExpPet(petId)
  if GDatatab_item["id_"..petId].sub_type == 0 then
    return true
  end
  return false
end

--@brief  宠物洗练资质成功
--@param  element:表绑定的UI节点引用
function WndPets:washGiftOk(gift)
   WZLog("WndPets:washGiftOk")
   self.m_tCurPetsInfo.giftSkill = gift
   local bExpPet = self:isExpPet(self.m_tCurPetsInfo.itemId)
   GetElement(self.m_root,"btnWashGift_WndPets",WZUIButton):setVisible(not bExpPet and not self:_isMax())
   GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setText(math.ceil(self.m_tCurPetsInfo.giftSkill/100)..LocalStrings.PET_TEXT15)
end

function WndPets:toWarFinsh()
    self:closeLoading()
    self.m_bISAlter = false
end

function WndPets:onToWar()
  WZLog("WndPets:onToWar")
  if self.m_bISAlter == true then
    return
  end
  WZLog("出战的宠物id",self.m_tCurPetsInfo.playerPetId)
  if self.m_tCurPetsInfo ~= nil then
    self:showLoading()
    ProtocolProcessorScenePets:send_PET_ChangeState(self.m_tCurPetsInfo.playerPetId)
    self.m_bISAlter = true
  end
end

--@brief    宠物升级按钮点击调用函数
--@param  element:表绑定的UI节点引用
--@note   宠物升级
function WndPets:onUpgradeClick()
    WZLog("WndPets:onUpgradeClick")
    if not self.m_tCurPetsInfo then return end
    self:_setConChildVisble(3)
    -- WndPetsUpgrade:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物进化按钮点击调用函数
--@param  element:表绑定的UI节点引用
--@note   宠物进化
function WndPets:onEvolutionClick()
    WZLog("WndPets:onEvolutionClick")
    if not self.m_tCurPetsInfo then return end
    if self.m_tCurPetsInfo.advancedLevel >= 7 then
        MsgBoxManager:showTipBox(LocalStrings.PETFULLADVANCELEVEL)
        return
    end
    self:_setConChildVisble(4)
    -- WndPetsEvolution:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物技能按钮点击调用函数
--@param  element:表绑定的UI节点引用
--@note     宠物技能
function WndPets:onSkillClick()
    WZLog("WndPets:onSkillClick")
    if not self.m_tCurPetsInfo then return end
    if self.m_tCurPetsInfo.advancedLevel < 1 then
      MsgBoxManager:showTipBox(LocalStrings.PETNEEDUPADVANCELEVEL)
      return
    end
    self:_setConChildVisble(6)
    -- WndPetsSkill:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物重生按钮点击调用函数
--@param  element:表绑定的UI节点引用
--@note   宠物重生
function WndPets:onRebirthClick()
    WZLog("WndPets:onRebirthClick")
    if not self.m_tCurPetsInfo then return end
    self:_setConChildVisble(5)
    --self:showPetInfo()
    -- WndPetsRebirth:setPetInfo(self.m_tCurPetsInfo)
end

--@brief  初始化宠物列表
--@param bShow:是否重新显示宠物信息，可不设置，默认为显示
function WndPets:setPetList(bShow, tPets)
  WZLog("WndPets:setPetList",bShow,tPets)
  if self.m_root == nil then
      return
  end
  if bShow == nil then
    bShow = true
  end
  if tPets ~= nil then
    self:_changeWarState()
    return
  end
  local pets =  CacheCenter:getPlayerPetInfo()

  local isAllExpPet = true
  for i, petInfo in pairs(pets) do
    WZLog("WndPets:setPetList111", i, petInfo.name, petInfo.fighting, tostring(petInfo.fighting ~= 0))
    if petInfo.fighting ~= 0 then
        isAllExpPet = false
    end
  end
  local isEndTeach12, teachStep12 = TeachGroup1:isTeachFinish(12)
  if isEndTeach12 ~= true and teachStep12 < 5 then
      TeachGroup1:startGroup({12,3,WndPets.m_root})
  elseif isEndTeach12 ~= true and teachStep12 >= 5 then
      if isAllExpPet ~= true then
        TeachGroup1:startGroup({12,7,WndPets.m_root})
      else
        TeachGroup1:setTeachFinish(12,-1)
        TeachGroup1:removeTeach()
      end
  end

  self.m_tPets = pets
  WZLog("WndPets:setPetList222:",#pets)
  if #pets <= 0 then
    return
  end 
  -- GetElement(self.m_root,"txtPetNum_WndPets",WZUILabelTTF):setText(#pets.."/"..PET_MAX_NUM)  
  -- local tableList = GetElement(self.m_root,"conPetList_WndPets",WZUIFreeListContainer)
  -- if tableList == nil then
  --       return
  -- end
  -- if tableList:size() > 0 then
  --     tableList:removeAll()
  -- end
  self.m_choicePetList = nil
  self.n_cellTag = 1
  -- self.t_cellPet =  CopyTable(pets)
  -- tableList:enableSchedule("createPetCell")  

  local con = GetElement(self.m_root,"conPetRight1_WndPets",WZUITableContainer)
  con:cleanTable()
  for i = 1,#pets do
    local celElement,tCell = CellPetList1:createElement()
    celElement:setTag(i - 1)
    con:setCellElement(celElement)
    tCell:setCellAllElement(pets[i])
    if pets[i].isInUsed then
      WZLog("出战的宠物有没有赋值")
      self.m_warPet = tCell
    end
    if self.m_tCurPetsInfo == nil then
      self.m_tCurPetsInfo = pets[1]
      self:showPetInfo()
      self.m_choicePetList = tCell
      tCell:setState(true)
      if self.n_openInterfaceTag ~= nil then
        self:_openInterfaceTag(self.self.n_openInterfaceTag)
        self.n_openInterfaceTag = nil
      end
    else 
      if self.m_tCurPetsInfo.playerPetId == pets[i].playerPetId then
        self.m_tCurPetsInfo = pets[i]
        self:showPetInfo()
        self.m_choicePetList = tCell
        tCell:setState(true)
      end
    end
    self.n_cellTag = self.n_cellTag + 1
  end

  if self.m_tCurPetsInfo.isInUsed then
    WZLog("当前宠物出战状态1",self.m_tCurPetsInfo.isInUsed)
    self.m_warPet = self.m_choicePetList
      GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(false)
      GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(true)
  else
      GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(true)
      GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(false)
  end
end

--@brief 创建宠物列表
function WndPets:createPetCell(tPet)
  local tableList = GetElement(self.m_root,"conPetList_WndPets",WZUIFreeListContainer)
  local pets = self.t_cellPet
  for j=1, 10 do
    if self.n_cellTag > #self.t_cellPet then
      WZLog("ssssssssssssssssssssss:", self.n_cellTag,  #self.t_cellPet)
      tableList:disableSchedule() 
      tableList:updateTopDownPosition()
      --tableList:update()
      return
    end
    WZLog("createPetCell:", j, self.n_cellTag)
    local i = self.n_cellTag
    --用于宠物显示界面更新
    local celElement , tCell = CellPetList:createElement()
    tCell:setCellAllElement(pets[i])
    if pets[i].isInUsed then
      self.m_warPet = tCell
    end
    tableList:pushBack(WZUIContainer:luaTo(celElement))
    tableList:getMoveElement():setPositionY(tableList:getMinPosition().y)
    -- celElement:setContentSize(GlobalMethod:CCSize(450,100))
    -- celElement:setRelativeSize(GlobalMethod:CCSize(1,100/370))
    if self.m_tCurPetsInfo == nil then
      self.m_tCurPetsInfo = pets[1]
      self:showPetInfo()
      self.m_choicePetList = tCell
      tCell:setState(true)
      if self.n_openInterfaceTag ~= nil then
         self:_openInterfaceTag(self.n_openInterfaceTag)
         self.n_openInterfaceTag = nil
      end
    else
      if self.m_tCurPetsInfo.playerPetId == pets[i].playerPetId then
        self.m_tCurPetsInfo = pets[i]
        self:showPetInfo()
        self.m_choicePetList = tCell
        tCell:setState(true)
      end
    end
     self.n_cellTag = self.n_cellTag + 1
   end
end
-- function WndPets:createPetCell()
--     local pets = self.t_cellPet
--     -- for j=1, 10 do
--     --   if self.n_cellTag > #self.t_cellPet then
--     --     WZLog("ssssssssssssssssssssss:", self.n_cellTag,  #self.t_cellPet)
--     --     self.conPetRight1:disableSchedule() 
--     --     self.conPetRight1:updateTopDownPosition()
--     --     return
--     --   end
--     -- end
--     -- WZLog("宠物列表",Serialize(self.m_tPets))
--     for i = 1,#pets do
--         local celElement,tCell = CellPetList1:createElement()
--         celElement:setTag(i-1)
--         self.conPetRight1:setCellElement(celElement)
--         -- tCell:setCellAllElement(pets[i])
--         if pets[i].isInUsed then
--           self.m_warPet = tCell
--         end
--     if self.m_tCurPetsInfo == nil then
--        self.m_tCurPetsInfo = pets[1]
--        self:showPetInfo()
--        self.m_choicePetList = tCell
--        tCell:setState(true)
--        if self.n_openInterfaceTag ~= nil then
--           self:_openInterfaceTag(self.n_openInterfaceTag)
--           self.n_openInterfaceTag = nil
--        end
--     else
--        if self.m_tCurPetsInfo.playerPetId == pets[i].playerPetId then
--          self.m_tCurPetsInfo = pets[i]
--          self:showPetInfo()
--          self.m_choicePetList = tCell
--          tCell:setState(true)
--        end
--     end
--      self.n_cellTag = self.n_cellTag + 1
--    end     
-- end
--@brief  显示宠物信息 
function WndPets:showPetInfo()
  --星星品质
    local aptitude = self:getAptitude(self.m_tCurPetsInfo.giftSkill)
    for i = 1, 7 do
        GetElement(self.m_root,"imgAptitude"..i.."_WndPets",WZUIImage):setVisible(i <= aptitude)
    end
    self:setAptitudePost(self.m_root, "conAptitude_WndPets", aptitude)
    --名字
    local nameText = GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox)
    self:setPetName(self.m_tCurPetsInfo.itemId, nameText)
    -- --等级
    -- local lvText = GetElement(self.m_root,"txtLv_WndPets",WZUILabelTTF)
    -- lvText:setText("Lv"..self.m_tCurPetsInfo.upgradeLevel)
    -- self:setTextColor(GDatatab_item["id_"..self.m_tCurPetsInfo.itemId].quality, lvText)

    local bExpPet = self:isExpPet(self.m_tCurPetsInfo.itemId)
    GetElement(self.m_root,"conPetPro_WndPets",WZUIContainer):setVisible(not bExpPet)
    GetElement(self.m_root,"btnAttribute_WndPets",WZUIButton):setVisible(not bExpPet)
    GetElement(self.m_root,"conExpPetPro_WndPets",WZUIContainer):setVisible(bExpPet)
    GetElement(self.m_root,"conPetLeft2_WndPets",WZUIContainer):setVisible(false)
    if self.m_tCurPetsInfo.isInUsed then
      WZLog("当前宠物出战状态1",self.m_tCurPetsInfo.isInUsed)
        GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(true)
    else
        GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(true)
        GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(false)
      end

    --属性
    local petProperty = self.m_tCurPetsInfo.property
    local petJ =  json.decode(petProperty)
    local petHP = petJ["1"]
    local petAttack = petJ["3"]
    local petDefense = petJ["4"]

    local txtFight = GetElement(self.m_root,"txtFight_WndPets",WZUILabelTTF)
    CCNodePropertySetter:setValue(txtFight, "skewX", 10)
    local ftbFight = GetElement(self.m_root,"ftbFight_WndPets",WZUIFreeTextBox)
    local FIGHT_POWER1 = LocalStrings.FIGHT_POWER1
    if ProjConfig.LANGUAGE == "vn" then
      FIGHT_POWER1 = [[<A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]]
    end
    ftbFight:setShowText(string.format(FIGHT_POWER1,self.m_tCurPetsInfo.fighting))
    if ProjConfig.LANGUAGE == "vn" then
      ftbFight:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
      ftbFight:setScale(0.8)
    end
    GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setText(petHP)
    GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setText(petAttack)
    GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setText(petDefense)
    GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setText(math.ceil(self.m_tCurPetsInfo.giftSkill/100))

    local value = math.ceil(self.m_tCurPetsInfo.giftSkill/100)
    local text1 = string.format(LocalStrings.PET_4,math.floor(value)/1,"%")
    local text2 = string.format(LocalStrings.PET_5,math.floor(value)/1,"%")
    GetElement(self.m_root,"txtQualification1_WndPets",WZUILabelTTF):setText(text1)
    GetElement(self.m_root,"txtQualification2_WndPets",WZUILabelTTF):setText(text2)

    local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPets",WZUILabelTTF)
    if self:isExpPet(self.m_tCurPetsInfo.itemId) then
      txtPetQualification:setText("")
    else
      txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..value)
    end

    GetElement(self.m_root,"btnWashGift_WndPets",WZUIButton):setVisible(not bExpPet and not self:_isMax())
    local tPetData = {}
    tPetData.upgradeLevel = self.m_tCurPetsInfo.upgradeLevel
    tPetData.advancedLevel = self.m_tCurPetsInfo.advancedLevel
    tPetData.quality = GDatatab_item["id_"..self.m_tCurPetsInfo.itemId].quality
    GetElement(self.m_root,"btnShengguang_WndPets",WZUIButton):setVisible(false)
    --动物动画
    local petImage = GetElement(self.m_root,"conPet_WndPets",WZUIContainer)
    petImage:setTouchEnable(false)
    petImage:removeAllChildrenWithCleanup(true)
    self.petAni = CreatePetAni(petImage, nil, self.m_tCurPetsInfo.animation, self.m_tCurPetsInfo.advancedLevel, self.m_tCurPetsInfo.petSkinItemId)
    self:playAttackAni()

    local txtPhantoming = GetElement(self.m_root, "txtPhantoming_WndPets", WZUILabelTTF)
    if txtPhantoming then
        if self.m_tCurPetsInfo.petSkinItemId > 0 then
            txtPhantoming:setVisible(true)
        else
            txtPhantoming:setVisible(false)
        end
    end
end

function WndPets:playAttackAni()
  WndPets:showPetUI(true,false)

  local conPet = GetElement(self.m_root,"conPet_WndPets",WZUIContainer)
  conPet:disableSchedule()

  local bExpPet = self:isExpPet(self.m_tCurPetsInfo.itemId)
  if bExpPet then return end

  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPets:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet_WndPets",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end

--@brief   获得当前宠物战力
function WndPets:getCurPetFight()
  if self.m_tCurPetsInfo and self.m_tCurPetsInfo.fighting then
    return self.m_tCurPetsInfo.fighting
  end
  return 0
end

--@brief   获得当前宠物资质
function WndPets:getCurPetQualification()
  if self.m_tCurPetsInfo and self.m_tCurPetsInfo.giftSkill then
    return math.ceil(self.m_tCurPetsInfo.giftSkill/100)
  end
  return 0
end

function WndPets:_isMax()
    local maxGift = 0
    for k,v in pairs(GDatatab_pet) do
        if v.item_id == self.m_tCurPetsInfo.itemId then
          maxGift = v.gift[1][2]
          break
        end
    end
    WZLog("WndPets:_isMax:",maxGift)
    if maxGift*100 <= tonumber(self.m_tCurPetsInfo.giftSkill) then
      return true
    end
    return false
end

--@brief   宠物列表排序
function sortPets(a,b)
  if a.isInUsed ~= b.isInUsed then
    return a.isInUsed
  end
  local aType = GDatatab_item["id_"..a.itemId].sub_type
  local bType = GDatatab_item["id_"..b.itemId].sub_type
  if aType ~= bType then
    return aType > bType
  end
  local aQuality = GDatatab_item["id_"..a.itemId].quality
  local bQuality = GDatatab_item["id_"..b.itemId].quality
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  if a.advancedLevel ~= b.advancedLevel then
    return a.advancedLevel > b.advancedLevel
  end
  return a.fighting > b.fighting
end

--@brief   根据不同宠物的品质设置不同的字体颜色
--@param nNum 宠物的品质
--@param sName 宠物的名称
--@param txtObj 字体的节点
--@param nLevel 宠物的进阶等级
--@param bShowWar 是否显示出战状态
--@param nlv 宠物等级
function WndPets:setPetName(nNum,txtObj,sName, nLevel, bShowWar, nlv)
  WZLog("WndPets:setPetName:",bShowWar)
  if nNum == nil then return end
  local txtColor = g_sFtxtQualityColor
  local petQuality = GDatatab_item["id_"..nNum].quality
  local level = nLevel or self.m_tCurPetsInfo.advancedLevel
  local lv = nlv or self.m_tCurPetsInfo.upgradeLevel
  local color = txtColor[petQuality]
  local s0 = self:getTypeById(nNum)
  if sName ~= null then
    sName = " "..sName
  end
  local s1 = sName or " "..self.m_tCurPetsInfo.name
  s1 = " Lv"..lv..s1
  local s2 = ""
  if level >= 1 then
    s2 = " +"..level
  end
  local s3 = ""
  if bShowWar == nil or bShowWar == true then
    if self.m_tCurPetsInfo.isInUsed then
      s3 = "("..LocalStrings.PETATWAR..")"
    else
      s3 = "("..LocalStrings.PETREST..")" 
    end
  end
  if self:isExpPet(nNum)  then
    s3 = ""
  end
  local sLevel = string.format([[<I>%s</I><T C=%s S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T><T C="0,255,0" S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T><T C="255,89,74" S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T>]],s0,color, s1, s2, s3)
  txtObj:setShowText(sLevel)
end

--@brief 根据宠物Id获取宠物类型图标
function WndPets:getTypeById(petId)
  WZLog("WndPets:getTypeById:",petId)
  local petType = 0
  for k, v in pairs(GDatatab_pet) do
    if v.item_id == petId then
      petType = v.id_type
    end
  end
  if petType == 1 then --生命
    return "ui/common/common_cw_xue.png"
  elseif petType == 2 then --攻击
    return "ui/common/common_cw_gong.png"
  elseif petType == 3 then --防御
    return "ui/common/common_cw_fang.png"
  elseif petType == 4 then --均衡
    return "ui/common/common_cw_jun.png"
  elseif petType == 5 then --经验
    return "ui/common/common_cw_exp.png"
  end
  return ""
end

--@brief   根据不同宠物的品质设置不同的品质框
function WndPets:setIconQuality(element, quality)
  local qualtyFile = {"frame_green.png","frame_bule.png","frame_violet.png","frame_orange.png"}
  local file = "ui/common/"..qualtyFile[quality]
  element:setFile(file)
end

--@brief   根据不同宠物的品质设置不同的品质框
function WndPets:setSkillQuality(element, skillId)
  if skillId == nil or skillId == 0 then
    element:setVisible(false)
  else
    WZLog("WndPets:setSkillQuality:", skillId)
    local quality =   GDatatab_skill["id_"..skillId].lv_icon
    local qualtyFile = {"frame_green.png","frame_bule.png","frame_violet.png","frame_orange.png","frame_orange.png"}
    local file = quality--"ui/common/"..qualtyFile[quality]
    element:setVisible(true)
    element:setFile(file) 
  end
end



--@brief   根据不同宠物的品质设置不同的字体颜色
function WndPets:setTextColor(nNum,txtObj,txtObj2)
  WZLog("WndPets:setTextColor")
  local color = QUALITYCOLOR[nNum]
  local petQuality = nNum
  if txtObj ~= nil then
    txtObj:setColor(color)
  end
  if txtObj2 ~= nil then
    txtObj2:setColor(color)
  end
end

--@brief   刷新宠物信息
function WndPets:updatePlayerPetInfoData()
    WZLog("WndPets:updatePlayerPetInfoData")
    if self.n_refreshState ~= 0 then --如果在其它窗口界面下，择不执行刷新动作
        WZLog("WndPets:updatePlayerPetInfoData333")
        self.n_refreshState = 2
        return
    end
    WZLog("WndPets:updatePlayerPetInfoData22222")  
    if not self.b_isWarState then
        table.sort(CacheCenter:getPlayerPetInfo(),sortPets)
        self:setPetList()
    else
        self:setPetList(false, self.m_tPets)
        self.b_isWarState= false
        self:toWarFinsh()
    end
end

--@breif   设置返回按钮是否可见
function WndPets:setBackBtnVisible(visible)
  WZLog("WndPets:setBackBtnVisible")
  local backBtn = WZUIButton:luaTo(self.m_root:getChildElement("btnBack_WndPets"))
  local closeBtn = WZUIButton:luaTo(self.m_root:getChildElement("btnClose_WndPets"))
  
  if visible then
    closeBtn:setVisible(false)
    backBtn:setVisible(true)
  else
    closeBtn:setVisible(true)
    backBtn:setVisible(false)
  end
end

--@brief 设置宠物播放经验动画
--param nExp:当前拥有经验, 
--param nLv:当前等级
function WndPets:setPlayExp(nLv,nExp)
  self.b_playexp = true
  self.n_exp = nExp
  self.n_lv = nLv                   
end

--@brief 播放增加经验动画
function WndPets:playExp()
  self.b_playexp = false
  self.n_addExp = 0  
  if self.n_lv == self.m_tCurPetsInfo.upgradeLevel then
    self.n_addExp = self.m_tCurPetsInfo.petExp -  self.n_exp
  else
    local lv = self.n_lv
      while lv < self.m_tCurPetsInfo.upgradeLevel do
        self.n_addExp = self:getMaxExp(lv) + self.n_addExp
        lv = lv +1 
      end
  end
  self.n_nextExp = self:getMaxExp(self.n_lv)
  self.m_root:enableSchedule("updateExp")
end

--@brief 更新宠物当前的经验
function WndPets:updateExp(element, time)
  local nAddExp = self.n_addExp/10
  if self.n_lv == self.m_tCurPetsInfo.upgradeLevel then
    if self.n_exp >= self.m_tCurPetsInfo.petExp then
      element:disableSchedule()
      return
    else
      nAddExp = math.min(self.m_tCurPetsInfo.petExp-self.n_exp, nAddExp)
    end
  end
  self.n_exp = self.n_exp + nAddExp
  if self.n_exp >= self.n_nextExp and self.n_lv < self.m_tCurPetsInfo.upgradeLevel then
     self.n_lv = self.n_lv + 1
     self.n_exp =  self.n_exp - self.n_nextExp
     self.n_nextExp = self:getMaxExp(self.n_lv)
  end
  self:setPetExp(self.n_lv,  math.floor(self.n_exp), self.n_nextExp)
end

--@brief 设置宠物经验进度条
function WndPets:setPetExp(lv, exp, nextExp)
   if nextExp == nil then
      nextExp = self:getMaxExp(lv)
   end
   if lv < 99 then
      local petExp = exp
      GetElement(self.m_root,"txtLvExp_WndPets",WZUILabelTTF):setText(petExp.."/"..nextExp)
      local percent = math.min((petExp/nextExp) * 100, 100)
      GetElement(self.m_root,"ipgPetExp_WndPets",WZUIProgress):setPercentage(percent)
   else
     GetElement(self.m_root,"txtLvExp_WndPets",WZUILabelTTF):setText("MAX")
     GetElement(self.m_root,"ipgPetExp_WndPets",WZUIProgress):setPercentage(100)
   end    
end

--@brief 调整星级数量
--@param nNum:宠物的品质
function WndPets:getAptitude(nNum)
  WZLog("WndPets:getAptitude:", nNum)
  local nGift = math.ceil(nNum/100)
  local tab = GDatatab_petStar
  for k,v in pairs(tab) do
    local gift = v.gift
    if  nGift >  gift[1][1] and nGift <= gift[1][2] then
      WZLog("WndPets:getAptitude:", nGift, v.id)
      return v.id
    end
  end
  return 1
end

--@brief 调整星级位置
function WndPets:setAptitudePost(root, elementName, nNum)
  if root == nil or elementName == nil then
     return
  end
  local element = GetElement(root,elementName,WZUIContainer)
  local pos = element:getRelativePosition()
  if nNum % 2 == 0 then
    element:setRelativePosition(GlobalMethod:ccp(0.54,pos.y))
  else
    element:setRelativePosition(GlobalMethod:ccp(0.5,pos.y))
  end
end

--@brief 
function WndPets:setWarState(petId, isInUsed)
  WZLog("WndPets:setWarState:")
  self.b_isWarState = true
  for i = 1, #petId do
    if self.m_choicePetList:getPetId() == petId[i] then
      self.m_tCurPetsInfo.isInUsed = isInUsed[i]
      if self.m_tCurPetsInfo.isInUsed then
        WZLog("当前宠物出战状态1",self.m_tCurPetsInfo.isInUsed)
          GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(false)
          GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(true)
      else
          GetElement(self.m_root,"btnFight_WndPets",WZUIButton):setVisible(true)
          GetElement(self.m_root,"btnCancel_WndPets",WZUIButton):setVisible(false)
      end
    end
  end
end

--@brief  点击限时特惠礼包按钮回调
function WndPets:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end

--@brief  点击幻型按钮回调
function WndPets:onClickPhantom(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCurPetsInfo == nil or self.m_tCurPetsInfo == {} then 
        MsgBoxManager:showTipBox(LocalStrings.PET_TEXT9)
        return 
    end
    local magicValue = self:_getPetMagicValue(self.m_tCurPetsInfo.itemId)
    if magicValue == -1 then
        MsgBoxManager:showTipBox(LocalStrings.PET_TEXT6)
        return 
    end
  
  local con = GetElement(self.m_root,"conPetSub_WndPets",WZUIContainer)
  local wndtemp = WndPetPhantom:createElement()
  con:addChild(wndtemp)

  WndPets:showPetUI(false,true)
end

--@brief  点击宠物属性按钮回调
function WndPets:onShowAttribute(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

  self:showAttributeTips(element,self.m_root,1,true)
end

--@brief  显示宠物属性tips
function WndPets:showAttributeTips(element,parentElement,showType,bShowAll)
  local tData={}
  tData.showType = showType

  local petProperty = WndPets.m_tCurPetsInfo.property
  local petJ = json.decode(petProperty)
  local petHP = petJ["1"]
  local petAttack = petJ["3"]
  local petDefense = petJ["4"]
  tData.petAP = petAttack
  tData.petDP = petDefense
  tData.petHP = petHP
  tData.petSP = math.ceil(WndPets.m_tCurPetsInfo.giftSkill/100)

  local value = math.ceil(WndPets.m_tCurPetsInfo.giftSkill/100)
  tData.qualification1 = string.format(LocalStrings.PET_4,math.floor(value)/1,"%")
  tData.qualification2 = string.format(LocalStrings.PET_5,math.floor(value)/1,"%")
  
  tData.petNum = #WndPets.m_tPets.."/"..PET_MAX_NUM

  WndTips:show(element,parentElement,63,tData,GlobalMethod:ccp(100,200),bShowAll)
end

function WndPets:getCurPetInfo()
  -- body
  return self.m_tCurPetsInfo
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 打开宠物子界面
--@param  tag子界面的id：3=升级，4=进化，5=重生， 6=技能
function WndPets:_openInterfaceTag(tag)
  if tag == 3 then
    self:onUpgradeClick()
  elseif tag == 4 then
    self:onEvolutionClick()
  elseif tag == 5 then
    if self.m_tCurPetsInfo and self.m_tCurPetsInfo.upgradeLevel > 1 or self.m_tCurPetsInfo.advancedLevel > 0 then
      self:onRebirthClick(element)
    else
      self.n_refreshState = 0
      MsgBoxManager:showTipBox(LocalStrings.PETNOREBIRTH)
    end
  elseif tag == 6 then
    self:onSkillClick()
  end
end

--@brief 
function WndPets:_changeWarState()
  WZLog("WndPets:_changeWarState:",self.m_tCurPetsInfo.isInUsed)
  local bUsed = self.m_tCurPetsInfo.isInUsed
  if self.m_warPet ~= nil then
    self.m_warPet:_setWarState(false)
  end
  self.m_choicePetList:_setWarState(bUsed)
  self.m_warPet = self.m_choicePetList
  local nameText = GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox)
  self:setPetName(self.m_tCurPetsInfo.itemId, nameText)
  -- if self.m_tCurPetsInfo.isInUsed then
  --   for i = 1,2 do
  --     -- GetElement(self.m_root,"txtFight"..i.."_WndPets",WZUILabelTTF):setText(LocalStrings.PETREST)
  --     local txtSure = self.m_root:getChildElement("txtFight"..i.."_WndPets")
  --     if txtSure then
  --       txtSure = WZUILabelTTF:luaTo(txtSure)
  --       txtSure:setText( LocalStrings.PETREST)
  --     end
  --   end
  -- else
  --   for i = 1,2 do
  --     -- GetElement(self.m_root,"txtFight"..i.."_WndPets",WZUILabelTTF):setText(LocalStrings.PETREST)
  --     local txtSure = self.m_root:getChildElement("txtFight"..i.."_WndPets")
  --     if txtSure then
  --       txtSure = WZUILabelTTF:luaTo(txtSure)
  --       txtSure:setText( LocalStrings.PETATWAR)
  --     end
  --   end
  -- end
end


--@brief  添加金币图标动画
function WndPets:_addTop()
  local cell, tcell = CellTopHandle:createElement()
  local topHandleContainer = GetElement(self.m_root,"topHandleContainer",WZUIContainer)
  topHandleContainer:addChild(cell)
  tcell:setTopData("ui/common/common_icon_hb.png", WndPets, self.onCloseClick,true,nil,nil,nil)
  tcell:setTopType()    
end

--@brief   控制容器控件里那个子节点可以显示
function WndPets:_setConChildVisble(tag)
  WZLog("WndPets:_setConChildVisble")
  local con = GetElement(self.m_root,"conPetSub_WndPets",WZUIContainer)
  WZTempLog("WndPets:_setConChildVisble...: ",tag)
    if tag == 3 then
      if WndPetsUpgrade.m_root ~= nil then return end
      local element = WndPetsUpgrade:createElement()
      WndPetsUpgrade:setPetInfo(self.m_tCurPetsInfo)
      con:addChild(element)
    elseif tag == 4 then
      if WndPetsEvolution.m_root ~= nil then return end
      local element = WndPetsEvolution:createElement()
      WndPetsEvolution:setPetInfo(self.m_tCurPetsInfo)
      con:addChild(element)
    elseif tag == 5 then
      if WndPetsRebirth.m_root ~= nil then return end
      local element = WndPetsRebirth:createElement()
      WndPetsRebirth:setPetInfo(self.m_tCurPetsInfo)
      con:addChild(element)
    elseif tag == 6 then
      if WndPetsSkill.m_root ~= nil then return end
      local element = WndPetsSkill:createElement()
      WndPetsSkill:setPetInfo(self.m_tCurPetsInfo)
      con:addChild(element)
    end
  
  WndPets:showPetUI(false,true)
end

--@brief  根据物品id获取宠物是否可幻型
function WndPets:_getPetMagicValue(itemId)
    -- body
    for i, value in pairs(GDatatab_pet) do
        if value.item_id == itemId then
            return value.magic
        end
    end
end

--@brief  设置羁绊入口红点
function WndPets:setFetterRedDot()
    -- body
    if self.m_root == nil then return end 
    
    if GlobalGame.g_tRedPointList.petFetter then
        GetElement(self.m_root, "imgFetterRedDot_WndPets", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "imgFetterRedDot_WndPets", WZUIImage):setVisible(false)
    end
end

--@brief    显示指定标签内容
function WndPets:showSpecifyContent()
    -- body
    if self.m_nSpecifyIndex == nil then return end 

    WZLog("WndPets:showSpecifyContent", self.m_nSpecifyIndex)
    GetElement(self.m_root, "checkGroup_WndPartner", WZUICheckBoxGroup):setCheckIndex(self.m_nSpecifyIndex - 1)
    if self.m_nSpecifyIndex == 1 then 
        self.m_nPetChildIndex = self.m_nSubIndex
        self:onPetSelect()
    elseif self.m_nSpecifyIndex == 2 then 
        self.m_nMountChildIndex = self.m_nSubIndex
        self:onMountSelect()
    elseif self.m_nSpecifyIndex == 3 then 
        self.m_nFootChildIndex = self.m_nSubIndex
        self:onFootSelect()
    elseif self.m_nSpecifyIndex == 4 then 
        self.m_nPhantomChildIndex = self.m_nSubIndex
        self:onPhantomSelect()
    end
end

function WndPets:showPetUI(bShow1,bShow2)
  GetElement(self.m_root,"conPetMain_WndPets",WZUIContainer):setVisible(bShow1)
  GetElement(self.m_root,"conPetSub_WndPets",WZUIContainer):setVisible(bShow2)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndPets:_adaptLanguage_en()
  GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.17094,0.85))
  GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.19316,0.7))
  GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.904272,0.55))
  GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(2.08205,0.4))
  
  GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF):setFontSize(18)
  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setFontSize(9)

  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))
  GetElement(self.m_root,"btnPetReborn_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.74))

  GetElement(self.m_root,"txtPetReborn_WndPets",WZUILabelTTF):setScale(0.8)
end

function WndPets:_adaptLanguage_pt(  )
  GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF):setFontSize(18)

  GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.12649,0.85))
  GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.14871,0.7))
  GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.859828,0.55))
  GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(2.4,0.4))

  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setScale(0.6)

  GetElement(self.m_root,"txtCheck1_WndPets",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtCheck2_WndPets",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtCheck3_WndPets",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtCheck4_WndPets",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtCheck5_WndPets",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtCheck6_WndPets",WZUILabelTTF):setScale(0.75)

  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))
  GetElement(self.m_root,"btnPetReborn_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.74))
  
end

function WndPets:_adaptLanguage_th()
  GetElement(self.m_root,"conPetD_WndPets",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.3,0.5))
  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF):setFontSize(20)
end

function WndPets:_adaptLanguage_vn()
  local con = GetElement(self.m_root,"conPetD_WndPets",WZUIContainer)
  if con then
    con:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
  end
  local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF)
  txtPetAPD:setRelativePosition(GlobalMethod:ccp(1.48205,0.85))
  txtPetAPD:setFontSize(18)
  local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF)
  txtPetDPD:setRelativePosition(GlobalMethod:ccp(1.17094,0.7))
  txtPetDPD:setFontSize(18)
  local txtPetHPD = GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF)
  txtPetHPD:setRelativePosition(GlobalMethod:ccp(1.19316,0.55))
  txtPetHPD:setFontSize(18)
  local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF)
  txtPetSPD:setRelativePosition(GlobalMethod:ccp(1.61538,0.4))
  txtPetSPD:setFontSize(18)

  local txt2 = GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF)
  txt2:setDimensions(GlobalMethod:CCSize(280,80))
  txt2:setFontSize(18)

  GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.519811))

  local txtPetReborn = GetElement(self.m_root,"txtPetReborn_WndPets",WZUILabelTTF)
  if txtPetReborn then
    txtPetReborn:setScale(0.65)
  end
  
  local btn4_2 = GetElement(self.m_root,"btn4_2",WZUIButton)
  GetElement(btn4_2,"name",WZUILabelTTF):setScale(0.9)
  local btn3_2 = GetElement(self.m_root,"btn3_2",WZUIButton)
  GetElement(btn3_2,"name",WZUILabelTTF):setScale(0.8)

  for i=1,4 do
    local txtPetBtn_1 = GetElement(self.m_root,"txtPetBtn"..i.."_1_WndPets",WZUILabelTTF)
    local txtPetBtn_2 = GetElement(self.m_root,"txtPetBtn"..i.."_2_WndPets",WZUILabelTTF)
    txtPetBtn_1:setFontSize(16)
    txtPetBtn_2:setFontSize(16)
  end
end

function WndPets:_adaptLanguage_tr(  )
  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))

  GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.17094,0.85))
  GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.19316,0.7))
  GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.904272,0.55))
  GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(2,0.4))
  GetElement(self.m_root,"txtPetSP_WndPets",WZUILabelTTF):setFontSize(18)

  local txt2 = GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF)
  txt2:setDimensions(GlobalMethod:CCSize(280,80))
  txt2:setFontSize(18)

  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setScale(0.55)
  
  local txtRecycling = GetElement(self.m_root,"txtRecycling_WndPets",WZUILabelTTF)
  txtRecycling:setScale(0.8)
  txtRecycling:setDimensions(GlobalMethod:CCSize(140))
end

function WndPets:_adaptLanguage_es(  )
    local txtWashGift = GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF)
    txtWashGift:setScale(0.52)
    txtWashGift:setDimensions(GlobalMethod:CCSize(100))
    local txtName = GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox)
    txtName:setScale(0.8)
    txtName:setMaxWidth(500)
    -- GetElement(self.m_root,"txtPetSP_WndPets",WZUILabelTTF):setFontSize(16)
    -- local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF)
    -- txtPetSPD:setRelativePosition(GlobalMethod:ccp(1.79,0.4))
    -- txtPetSPD:setFontSize(18)
    -- local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF)
    -- txtPetAPD:setRelativePosition(GlobalMethod:ccp(1.66,0.85))
    -- txtPetAPD:setFontSize(18)
    -- local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF)
    -- txtPetDPD:setRelativePosition(GlobalMethod:ccp(1.95,0.7))
    -- txtPetDPD:setFontSize(18)
    GetElement(self.m_root,"txtPetAP_WndPets",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtPetDP_WndPets",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtPetHP_WndPets",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtPetSP_WndPets",WZUILabelTTF):setScale(0.9)
    local txtPetDPD = GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF)
    txtPetDPD:setScale(0.9)
    txtPetDPD:setRelativePosition(GlobalMethod:ccp(1.52667,0.85))
    local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF)
    txtPetDPD:setScale(0.9)
    txtPetDPD:setRelativePosition(GlobalMethod:ccp(1.79444,0.7))
    local txtPetDPD = GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF)
    txtPetDPD:setScale(0.9)
    txtPetDPD:setRelativePosition(GlobalMethod:ccp(0.770939,0.55))
    local txtPetDPD = GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF)
    txtPetDPD:setScale(0.9)
    txtPetDPD:setRelativePosition(GlobalMethod:ccp(2.27889,0.4))

    
  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))
  GetElement(self.m_root,"btnPetReborn_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.74))

  GetElement(self.m_root,"txtPetReborn_WndPets",WZUILabelTTF):setScale(0.65)
end

function WndPets:_adaptLanguage_ug(  )
  GetElement(self.m_root,"txtObtainPet1_WndPets",WZUILabelTTF):setScale(0.8)
  GetElement(self.m_root,"txtObtainPet2_WndPets",WZUILabelTTF):setScale(0.8)
  GetElement(self.m_root,"txtRecycling_WndPets",WZUILabelTTF):setScale(0.8)

  local txtWashGift = GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF)
  txtWashGift:setDimensions(GlobalMethod:CCSize(100))
  txtWashGift:setScale(0.5)
  local txtShengguang = GetElement(self.m_root,"txtShengguang_WndPets",WZUILabelTTF)
  txtShengguang:setDimensions(GlobalMethod:CCSize(100))
  txtShengguang:setScale(0.5)
  
  local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
  txtTransfer1:setScale(0.6)
  txtTransfer1:setDimensions(GlobalMethod:CCSize(170))
  local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
  txtTransfer2:setScale(0.6)
  txtTransfer2:setDimensions(GlobalMethod:CCSize(170))
  local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF)
  txtTransfer3:setScale(0.6)
  txtTransfer3:setDimensions(GlobalMethod:CCSize(170))
  local txtTransfer4 = GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF)
  txtTransfer4:setScale(0.6)
  txtTransfer4:setDimensions(GlobalMethod:CCSize(170))

  local txtPetAP = GetElement(self.m_root,"txtPetAP_WndPets",WZUILabelTTF)
  txtPetAP:setScale(0.8)
  txtPetAP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP:setRelativePosition(GlobalMethod:ccp(3,0.85))
  local txtPetDP = GetElement(self.m_root,"txtPetDP_WndPets",WZUILabelTTF)
  txtPetDP:setScale(0.8)
  txtPetDP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP:setRelativePosition(GlobalMethod:ccp(3,0.7))
  local txtPetHP = GetElement(self.m_root,"txtPetHP_WndPets",WZUILabelTTF)
  txtPetHP:setScale(0.8)
  txtPetHP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP:setRelativePosition(GlobalMethod:ccp(3,0.55))
  local txtPetSP = GetElement(self.m_root,"txtPetSP_WndPets",WZUILabelTTF)
  txtPetSP:setScale(0.8)
  txtPetSP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSP:setRelativePosition(GlobalMethod:ccp(3,0.4))
  local txtPetAP = GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF)
  txtPetAP:setScale(0.8)
  txtPetAP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP:setRelativePosition(GlobalMethod:ccp(1.83761,0.85))
  local txtPetDP = GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF)
  txtPetDP:setScale(0.8)
  txtPetDP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP:setRelativePosition(GlobalMethod:ccp(1.19316,0.7))
  local txtPetHP = GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF)
  txtPetHP:setScale(0.8)
  txtPetHP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP:setRelativePosition(GlobalMethod:ccp(1.19316,0.55))
  local txtPetSP = GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF)
  txtPetSP:setScale(0.8)
  txtPetSP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSP:setRelativePosition(GlobalMethod:ccp(0.970939,0.4))

  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))

  local txtExpPetPro = GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF)
  txtExpPetPro:setScale(0.6)
  txtExpPetPro:setDimensions(GlobalMethod:CCSize(440))
  
  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)
end
-------------------------------------语言适配模块End--------------------------------------
