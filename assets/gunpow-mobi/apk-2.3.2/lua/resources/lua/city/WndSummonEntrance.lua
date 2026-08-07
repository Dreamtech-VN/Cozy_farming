--WndSummonEntrance.lua
--@brief	WndSummonEntrance的UI模块
--@date		2016/12/26
--@author	Tianxiang_Xu
--@note		爬塔和世界BOSS的入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSummonEntrance:onEnter(element)
    self.m_root = element

    -- self:_adaptIphoneX()
    self:showTitleBtn()
    -- AdaptLanguage(self)
    TeachGroup1:startGroup({41,2,self.m_root},{42,3,self.m_root})
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSummonEntrance:onExit(element)
    local level = tonumber(CacheCenter:getPlayerInfo().level)
    if level == 9 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvBackCity2)
    end
    -- SceneCity:updateZhaohuanRedDot(GlobalGame.g_tRedPointList.lottery1_redPoint,GlobalGame.g_tRedPointList.lottery2_redPoint,GlobalGame.g_tRedPointList.lottery3_redPoint,GlobalGame.g_tRedPointList.lottery4_redPoint,GlobalGame.g_tRedPointList.lottery6_redPoint)
	self:_unInit()
end

--@brief    弹窗动画完成后的回调
function WndSummonEntrance:actionCallback(element, data)
    -- WZLog("WndSummonEntrance:actionCallback", tostring(GlobalGame.g_tRedPointList["lottery1_redPoint"]), tostring(GlobalGame.g_tRedPointList["lottery2_redPoint"]), tostring(GlobalGame.g_tRedPointList["lottery3_redPoint"]), tostring(GlobalGame.g_tRedPointList["lottery4_redPoint"], tostring(GlobalGame.g_tRedPointList["lottery5_redPoint"])))

    self:updateRedPoint1(GlobalGame.g_tRedPointList.lottery1_redPoint, GlobalGame.g_tRedPointList.lottery2_redPoint, GlobalGame.g_tRedPointList.lottery3_redPoint, GlobalGame.g_tRedPointList.lottery4_redPoint, GlobalGame.g_tRedPointList.lottery5_redPoint,GlobalGame.g_tRedPointList.lottery6_redPoint)
end

function WndSummonEntrance:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_zhaohuan.png",WndSummonEntrance,WndSummonEntrance.onClickClose,true,true,false,"WndSummonEntrance")
    self.topCell = {cell = cell, tcell = tcell}
end

function WndSummonEntrance:updateRedPoint(isOne, isTow, isThree, isFour, isFive)

end
function WndSummonEntrance:updateRedPoint1(isOne, isTow, isThree, isFour, isFive, isSix)
    WZLog("WndSummonEntrance:updateRedPoint1", tostring(isOne), tostring(isTow), tostring(isThree), tostring(isFour), tostring(isFive))

    if self.m_root then
        if isOne ~= nil then
            WZLog("isOneRedDot")
            local btn = GetElement(self.m_root, "checkbox1_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isOne, GlobalMethod:ccp(177,65),0.8)
        end

        if isTow ~= nil then
            local btn = GetElement(self.m_root, "checkbox2_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isTow, GlobalMethod:ccp(177,65),0.8)
        end

        if isThree ~= nil then
            local btn = GetElement(self.m_root, "checkbox5_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isThree, GlobalMethod:ccp(177,65),0.8)
        end

        if isFour ~= nil then
            local btn = GetElement(self.m_root, "checkbox6_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isFour, GlobalMethod:ccp(177,65),0.8)
        end

        if isFive ~= nil then
            local btn = GetElement(self.m_root, "checkbox7_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isFive, GlobalMethod:ccp(177,65),0.8)
        end

        if isSix ~= nil then
            local btn = GetElement(self.m_root, "checkbox8_WndSummonEntrance", WZUICheckBox)
            SceneCity:setRedPoint(btn, isSix, GlobalMethod:ccp(177,65),0.8)
        end
    end
end

--@brief onEnter函数执行完成回调
function WndSummonEntrance:onEnterTransitionDidFinish(element)
    -- self:_addTop()
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    点击图标回调
function WndSummonEntrance:onClickEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 0 then   --幸运召唤
        TeachGroup1:endTeachStep({41,2})
        if CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY) then
            local wndEquipmentLottery = WndEquipmentLottery:createElement()
            WindowManager:addWindow(wndEquipmentLottery,WndEquipmentLottery)
        end
    elseif nTag == 1 then --砸蛋
        if CheckButtonOpen(ISLAND_RIGHT_PET) then
            local wndPetRaffle = WndPetRaffle:createElement()
            WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
        end
    elseif nTag == 2 then --祈福
        TeachGroup1:endTeachStep({42,3})
        if CheckButtonOpen(BLESS_LUCKY_DRAW) then
            local wndBless = WndBless:createElement()
            if wndBless ~= nil then
                WindowManager:addWindow(wndBless,WndBless)
                return
            end
        end
    elseif nTag == 3 then --符文
        if CheckButtonOpen(ISLAND_UP_RUNE) then
            SceneRuneLockDraw:show()
        end
    end
end

--@brief    点击关闭按钮回调
function WndSummonEntrance:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    关闭整个窗口的动画效果
function WndSummonEntrance:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

function WndSummonEntrance:closeWin()
    WindowManager:removeWindow(WndSummonEntrance.m_root , WndSummonEntrance , true)
end

--@brief    显示标题按钮
function WndSummonEntrance:showTitleBtn()
    local openList = {11,46,205,115,196,197,198,224}
    local psList = {{0.5,0.94},{0.5,0.818},{0.5,0.696},{0.5,0.574},{0.5,0.452},{0.5,0.330},{0.5,0.208},{0.5,0.086}}

    local nIndex = 1
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i=1,#openList do
        local checkbox = GetElement(self.m_root,"checkbox"..i.."_WndSummonEntrance",WZUICheckBox)
        if playerLevel >= GDatatab_button_info["id_"..openList[i]].show_level then
            checkbox:setVisible(true)
            checkbox:setRelativePosition(GlobalMethod:ccp(psList[nIndex][1],psList[nIndex][2]))
            nIndex = nIndex + 1
        else
            checkbox:setVisible(false)
        end
    end
end

--@brief    点击标题按钮回调
function WndSummonEntrance:onTabWin(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nTag = element:getTag()
    local isOpen = false
    if nTag == 1 then
        WZLog("点击标题按钮回调",CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY))
        if CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY) then
            isOpen = true
        end
    elseif nTag == 2 then
        WZLog("点击标题按钮回调",CheckButtonOpen(PET_EGG))
        if CheckButtonOpen(PET_EGG) then
            isOpen = true
        end
    elseif nTag == 5 then
        WZLog("点击标题按钮回调",CheckButtonOpen(MOUNT_LOTTERY))
        if CheckButtonOpen(MOUNT_LOTTERY) then
            isOpen = true
        end
    elseif nTag == 6 then
        WZLog("点击标题按钮回调",CheckButtonOpen(PHANTOM_LOTTERY))
        if CheckButtonOpen(PHANTOM_LOTTERY) then
            isOpen = true
        end
    elseif nTag == 7 then
        WZLog("点击标题按钮回调",CheckButtonOpen(FOOT_LOTTERY))
        if CheckButtonOpen(FOOT_LOTTERY) then
            isOpen = true
        end
    elseif nTag == 8 then
        WZLog("点击标题按钮回调",CheckButtonOpen(PET_EQUIPMENT_LOTTERY))
        if CheckButtonOpen(PET_EQUIPMENT_LOTTERY) then
            isOpen = true
        end
    end
    if isOpen then
        self:showTabWin(nTag)
    end
end


--@brief    点击标题按钮回调
function WndSummonEntrance:showTabWin(nTag)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndSummonEntrance",WZUIContainer)
    if self.m_commonTag == nTag then
        return
    end
    self.m_commonTag = nTag
    conMidContent:removeAllChildrenWithCleanup(true)
    if nTag == 1 then   --幸运召唤
        -- TeachGroup1:endTeachStep({41,2})
        if CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY) then
            -- self:setMountChildTitle(false)
            -- self:setPhantomChildTitle(false)
            -- self:setPetEquipChildTitle(false)
            local wndEquipLottery = WndEquipLottery:createElement()
            conMidContent:addChild(wndEquipLottery)
            PostPlayerEvent:postEvent(PostPlayerEvent.event_nineLvClickLuckyCall)
        end
    elseif nTag == 2 then --砸蛋
        if CheckButtonOpen(PET_EGG) then
            -- self:setPetEquipChildTitle(false)
            local wndPetLottery = WndPetLottery:createElement()
            conMidContent:addChild(wndPetLottery)
        end
    elseif nTag == 3 then --祈福
        TeachGroup1:endTeachStep({42,3})
        if CheckButtonOpen(BLESS_LUCKY_DRAW) then
            local wndBless = WndBless:createElement()
            conMidContent:addChild(wndBless)
        end
    elseif nTag == 4 then --符文
        if CheckButtonOpen(ISLAND_UP_RUNE) then
            local sceneRuneLockDraw = SceneRuneLockDraw:createElement()
            conMidContent:addChild(sceneRuneLockDraw)
        end
    elseif nTag == 5 then --坐骑
        if CheckButtonOpen(MOUNT_LOTTERY) then
            -- self:setPhantomChildTitle(false)
            -- self:setPetEquipChildTitle(false)
            -- self:setMountChildTitle(true, self.m_nMountChildIndex)
            local wndMountLottery = WndMountLottery:createElement()
            if wndMountLottery then
                conMidContent:addChild(wndMountLottery)
            end
        end
    elseif nTag == 6 then --皮肤
        if CheckButtonOpen(PHANTOM_LOTTERY) then
            -- self:setMountChildTitle(false)
            -- self:setPetEquipChildTitle(false)
            -- self:setPhantomChildTitle(true, self.m_nPhantomChildIndex)
            local WndPhantomLottery = WndPhantomLottery:createElement()
            conMidContent:addChild(WndPhantomLottery)
        end
    elseif nTag == 7 then --足迹
        WZLog("足迹抽奖",CheckButtonOpen(FOOT_LOTTERY))
        if CheckButtonOpen(FOOT_LOTTERY) then
            local WndFootLottery = WndFootLottery:createElement()
            conMidContent:addChild(WndFootLottery)
        end    
    elseif nTag == 8 then --宠物装备
        if CheckButtonOpen(PET_EQUIPMENT_LOTTERY) then
            -- self:setMountChildTitle(false)
            -- self:setPhantomChildTitle(false)
            -- self:setPetEquipChildTitle(true, self.m_nPetEquipChildIndex)
            local wndPetEquipLottery = WndPetEquipLottery:createElement()
            conMidContent:addChild(wndPetEquipLottery)
        end 
    end
end

--坐骑下面的二级标签
function WndSummonEntrance:setMountChildTitle(visible, index)
    local mountChildTitle = GetElement(self.m_root,"mountChildTitle",WZUIContainer)
    mountChildTitle:setVisible(visible)
    if visible == false then
        GetElement(self.m_root,"checkbox6_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.574))
        GetElement(self.m_root,"checkbox8_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.452))
        return 
    end
    GetElement(self.m_root,"checkbox6_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.33))
    GetElement(self.m_root,"checkbox8_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.208))
    local title_num = 2
    if self.m_tMountChileTitle == nil then
        self.m_tMountChileTitle = {}
        for i=1, title_num do
            local tab = {}
            local btn = GetElement(mountChildTitle,"btnMountLottery".. i,WZUIButton)
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
end

--幻化下面的二级标签
function WndSummonEntrance:setPhantomChildTitle(visible, index)
    local phantomChildTitle = GetElement(self.m_root,"phantomChildTitle",WZUIContainer)
    phantomChildTitle:setVisible(visible)
    if visible == false then
        GetElement(self.m_root,"checkbox8_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.452))
        return 
    end
    GetElement(self.m_root,"checkbox8_WndSummonEntrance",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.208))
    if self.m_tPhantomChileTitle == nil then
      self.m_tPhantomChileTitle = {}
      for i=1,2 do
        local tab = {}
        local btn = GetElement(phantomChildTitle,"btnPhantomLottery"..i,WZUIButton)
        tab.normal = GetElement(btn,"normal",WZUIImage)
        tab.select = GetElement(btn,"select",WZUIImage)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
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

--宠物装备下面的二级标签
function WndSummonEntrance:setPetEquipChildTitle(visible, index)
    local petEquipChildTitle = GetElement(self.m_root,"petEquipChildTitle",WZUIContainer)
    petEquipChildTitle:setVisible(visible)
    if visible == false then
        return 
    end
    if self.m_tPetEquipChileTitle == nil then
      self.m_tPetEquipChileTitle = {}
      for i=1,2 do
        local tab = {}
        local btn = GetElement(petEquipChildTitle,"btnPetEquipLottery"..i,WZUIButton)
        tab.normal = GetElement(btn,"normal",WZUIImage)
        tab.select = GetElement(btn,"select",WZUIImage)
        tab.name = GetElement(btn,"name",WZUILabelTTF)
        self.m_tPetEquipChileTitle[i] = tab
      end
      self.m_nPetEquipChildIndex = index or 1
      self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].normal:setVisible(false)
      self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].select:setVisible(true)
      self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
      self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setEnableStroke(false)
    end
    self:setPetEquipChangeChildView(self.m_nPetEquipChildIndex)
end

--@brief坐骑页面
function WndSummonEntrance:setChangeChildView(n_index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndSummonEntrance",WZUIContainer)
    local wndMountLottery = WndMountLottery:createElement()
    WndMountLottery:setViewIndex(n_index)
    if wndMountLottery then
        conMidContent:addChild(wndMountLottery)
    end 
end

--@brief皮肤页面
function WndSummonEntrance:setPhantomChangeChildView(n_index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndSummonEntrance",WZUIContainer)
    local wndPhantomLottery = WndPhantomLottery:createElement()
    WndPhantomLottery:setViewIndex(n_index)
    if wndPhantomLottery then
        conMidContent:addChild(wndPhantomLottery) 
    end    
    
end

--@brief宠物装备页面
function WndSummonEntrance:setPetEquipChangeChildView(n_index)
    local conMidContent = GetElement(self.m_root,"conMidContent_WndSummonEntrance",WZUIContainer)
    local wndPetEquipLottery = WndPetEquipLottery:createElement()
    WndPetEquipLottery:setViewIndex(n_index)
    if wndPetEquipLottery then
        conMidContent:addChild(wndPetEquipLottery)
    end
end

--切换坐骑显示页面
function WndSummonEntrance:onBtnMountChild(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
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
  WndMountLottery:setViewIndex(tag)

  self.m_nMountChildIndex = tag
end

--切换皮肤显示界面
function WndSummonEntrance:onBtnPhantomChild(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
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
      WndPhantomLottery:setViewIndex(tag)

      self.m_nPhantomChildIndex = tag
end

--切换宠物装备显示界面
function WndSummonEntrance:onBtnPetEquipChild(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
      if tag == self.m_nPetEquipChildIndex then return end

      if self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex] then
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].normal:setVisible(true)
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].select:setVisible(false)
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setEnableStroke(true)
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setStrokeSize(4)
          self.m_tPetEquipChileTitle[self.m_nPetEquipChildIndex].name:setStrokeColor(GlobalMethod:ccc3(132,66,29))
      end
      if self.m_tPetEquipChileTitle[tag] then
          self.m_tPetEquipChileTitle[tag].normal:setVisible(false)
          self.m_tPetEquipChileTitle[tag].select:setVisible(true)
          self.m_tPetEquipChileTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
          self.m_tPetEquipChileTitle[tag].name:setEnableStroke(false)
      end
      WndPetEquipLottery:setViewIndex(tag)

      self.m_nPetEquipChildIndex = tag
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    适配iphoneX 
function WndSummonEntrance:_adaptIphoneX()
    -- body
    if IsIphoneX() then
        GetElement(self.m_root, "conTitleBtns_WndSummonEntrance", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.45))
    end
end

function WndSummonEntrance:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txt1_WndSummonEntrance",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txt2_WndSummonEntrance",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txt3_WndSummonEntrance",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txt4_WndSummonEntrance",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------