--WndPets.lua
--@brief	WndPets的UI模块
--@date		2015/03/26
--@author	qixiang_xie
--@note		宠物模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPets:onEnter(element)
    WZLog("WndPets:onEnter")
  	self.m_root = element 
  	AdaptLanguage(self)

	PET_MAX_NUM = tonumber(CacheCenter:getGameParam()["petNumUpper"])
    
    --self:_conAddChild()P 

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
    if isEndTeach19 ~= true and teachStep19 > 1 and CacheCenter:getPlayerInfo().level == 26 then
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
  local check1 = GetElement(self.m_root,"checkbox1_WndPartner",WZUICheckBox)
  local check2 = GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox)
  local check3 = GetElement(self.m_root,"checkbox3_WndPartner",WZUICheckBox)

  if not CheckButtonOpen(ISLAND_RIGHT_MOUNT, true) then
    check2:setVisible(false)
  end

  if not CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, true) then
    check3:setVisible(false)
  end

  SceneCity:setRedPoint(check2, CacheCenter:getRedState("btnMount"), GlobalMethod:ccp(115,55))
  SceneCity:setRedPoint(check3, CacheCenter:getRedState("btnFootMark"), GlobalMethod:ccp(115,55))
end

--@brief  宠物被选中时调用的函数
function WndPets:onPetSelect(element)
  if WndPets.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndPets = WndPets:createElement()
    if wndPets ~= nil then
        WindowManager:addWindow(wndPets, WndPets, false)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
  
end

--@brief  坐骑被选中时调用的函数
function WndPets:onMountSelect(element)
  if WndMounts.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndMounts = WndMounts:createElement()
    if wndMounts ~= nil then
        WindowManager:addWindow(wndMounts, WndMounts, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
end

--@brief  足迹被选中时调用的函数
function WndPets:onFootSelect(element)
  if WndFootMark.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndFootMark = WndFootMark:createElement()
    if wndFootMark ~= nil then
        WindowManager:addWindow(wndFootMark, WndFootMark, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
  end
end

--@brief   获取抽奖宠物时间成功
function WndPets:getTime(type,time)
  if self.m_root == nil then
    return
  end
  local con1 = self.m_root:getChildElement("btnObtainPet_WndPets")
    local isRed = WndBottomBar:isShowPetRed(time[1])
  WZLog("WndPets:getTime:",time[1], time[2], isRed)
  if not isRed then
    AddRemark(con1, false)
  else
    AddRemark(con1, true)
  end
end

function WndPets:updatePlayerInfoData()
    if self.m_root and  self.m_isToWar then
        self.m_isToWar = false
        upPlayerFightingAni()
    end
end

--@brief    关闭按钮点击被调用的函数
--@param	element:表绑定的UI节点引用
--@note		退出当前场景
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

--@brief	返回上一个场景
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
    elseif tag == 2 then  --升级
        self:onUpgradeClick()
    elseif tag == 3 then  --进阶
        self:onEvolutionClick()
    elseif tag == 4 then  --技能
        self:onSkillClick()
    elseif tag == 5 then  --获取宠物
        self:onObtainPetClick()
    elseif tag == 6 then  --重生
        if self.m_tCurPetsInfo and self.m_tCurPetsInfo.upgradeLevel > 1 or self.m_tCurPetsInfo.advancedLevel > 0 then
          self:onRebirthClick(element)
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
        WndPetFetter:showInterface(self.m_tCurPetsInfo)
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
--@param	element:表绑定的UI节点引用
--@note		跳转到获取宠物系统
function WndPets:onObtainPetClick()
	  WZLog("WndPets:onObtainPetClick")
    if self.m_root == nil then
    	return
    end
    if m_tPets ~= nil and #m_tPets >= PET_MAX_NUM then
          MsgBoxManager:showTipBox(LocalStrings.PET_SUM_EXCEED_ALTER)
          return
    end
    local wndPetRaffle = WndPetRaffle:createElement()
    WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
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
   GetElement(self.m_root,"btnWashGift_WndPets",WZUIButton):setVisible(not self:_isMax())
   GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setText(math.ceil(self.m_tCurPetsInfo.giftSkill/100))
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
  if self.m_tCurPetsInfo ~= nil then
    self:showLoading()
    ProtocolProcessorScenePets:send_PET_ChangeState(self.m_tCurPetsInfo.playerPetId)
    self.m_bISAlter = true
  end
end

--@brief    宠物升级按钮点击调用函数
--@param	element:表绑定的UI节点引用
--@note		宠物升级
function WndPets:onUpgradeClick()
    WZLog("WndPets:onUpgradeClick")
    self:_setConChildVisble(3)
    WndPetsUpgrade:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物进化按钮点击调用函数
--@param	element:表绑定的UI节点引用
--@note		宠物进化
function WndPets:onEvolutionClick()
    WZLog("WndPets:onEvolutionClick")
    if self.m_tCurPetsInfo.advancedLevel >= 6 then
      MsgBoxManager:showTipBox(LocalStrings.PETFULLADVANCELEVEL)
      return
    end
	  self:_setConChildVisble(4)
    WndPetsEvolution:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物技能按钮点击调用函数
--@param	element:表绑定的UI节点引用
--@note	    宠物技能
function WndPets:onSkillClick()
    WZLog("WndPets:onSkillClick")
    if self.m_tCurPetsInfo.advancedLevel < 1 then
      MsgBoxManager:showTipBox(LocalStrings.PETNEEDUPADVANCELEVEL)
      return
    end
    self:_setConChildVisble(6)
    WndPetsSkill:setPetInfo(self.m_tCurPetsInfo)
end

--@brief    宠物重生按钮点击调用函数
--@param	element:表绑定的UI节点引用
--@note		宠物重生
function WndPets:onRebirthClick()
    WZLog("WndPets:onRebirthClick")
    self:_setConChildVisble(5)
    --self:showPetInfo()
    WndPetsRebirth:setPetInfo(self.m_tCurPetsInfo)
end

--@brief  初始化宠物列表
--@param bShow:是否重新显示宠物信息，可不设置，默认为显示
function WndPets:setPetList(bShow, tPets)
  WZLog("WndPets:setPetList")
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
  GetElement(self.m_root,"txtPetNum_WndPets",WZUILabelTTF):setText(#pets.."/"..PET_MAX_NUM)  
  GetElement(self.m_root,"txtPetNum_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.881182,0.0418059))
  local tableList = GetElement(self.m_root,"conPetList_WndPets",WZUIFreeListContainer)
  if tableList == nil then
        return
  end
  if tableList:size() > 0 then
      tableList:removeAll()
  end
  self.m_choicePetList = nil
  self.n_cellTag = 1
  self.t_cellPet =  CopyTable(pets)
  tableList:enableSchedule("createPetCell")  
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

--@brief  显示宠物信息 
function WndPets:showPetInfo()
  --星星品质
    local aptitude = self:getAptitude(self.m_tCurPetsInfo.giftSkill)
    for i =1 ,5 do
        GetElement(self.m_root,"imgAptitude"..i.."_WndPets",WZUIImage):setVisible(i <= aptitude)
    end
    self:setAptitudePost(self.m_root, "conAptitude_WndPets", aptitude)
    --名字
    local nameText = GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox)
    self:setPetName(self.m_tCurPetsInfo.itemId, nameText)
    --等级
    local lvText = GetElement(self.m_root,"txtLv_WndPets",WZUILabelTTF)
    lvText:setText("Lv"..self.m_tCurPetsInfo.upgradeLevel)
    self:setTextColor(GDatatab_item["id_"..self.m_tCurPetsInfo.itemId].quality, lvText)

    local bExpPet = self:isExpPet(self.m_tCurPetsInfo.itemId)
    GetElement(self.m_root,"conPetPro_WndPets",WZUIContainer):setVisible(not bExpPet)
    GetElement(self.m_root,"conExpPetPro_WndPets",WZUIContainer):setVisible(bExpPet)
    GetElement(self.m_root,"conPetLeft2_WndPets",WZUIContainer):setVisible(not bExpPet)

    --属性
    local petProperty = self.m_tCurPetsInfo.property
    local petJ =  json.decode(petProperty)
    local petHP = petJ["1"]
    local petAttack = petJ["3"]
    local petDefense = petJ["4"]

    local ftbFight = GetElement(self.m_root,"ftbFight_WndPets",WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER2,self.m_tCurPetsInfo.fighting))

    GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setText(petHP)
    GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setText(petAttack)
    GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setText(petDefense)
    GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setText(math.ceil(self.m_tCurPetsInfo.giftSkill/100))

    GetElement(self.m_root,"btnWashGift_WndPets",WZUIButton):setVisible(not self:_isMax())
    local tPetData = {}
    tPetData.upgradeLevel = self.m_tCurPetsInfo.upgradeLevel
    tPetData.advancedLevel = self.m_tCurPetsInfo.advancedLevel
    tPetData.quality = GDatatab_item["id_"..self.m_tCurPetsInfo.itemId].quality
    GetElement(self.m_root,"btnShengguang_WndPets",WZUIButton):setVisible(false)
    --动物动画
    local petImage = GetElement(self.m_root,"conPet_WndPets",WZUIContainer)
    petImage:setTouchEnable(false)
    petImage:removeAllChildrenWithCleanup(true)
    local petAni = CreatePetAni(petImage, nil, self.m_tCurPetsInfo.animation, self.m_tCurPetsInfo.advancedLevel, self.m_tCurPetsInfo.petSkinItemId)

    local txtPhantoming = GetElement(self.m_root, "txtPhantoming_WndPets", WZUILabelTTF)
    if txtPhantoming then
        if self.m_tCurPetsInfo.petSkinItemId > 0 then
            txtPhantoming:setVisible(true)
        else
            txtPhantoming:setVisible(false)
        end
    end
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
function WndPets:setPetName(nNum,txtObj,sName, nLevel, bShowWar)
  WZLog("WndPets:setPetName:",bShowWar)
  if nNum == nil then return end
  local txtColor = {[["99,255,95"]],[["93,222,254"]],[["198,130,255"]],[["233,166,62"]]}
  local petQuality = GDatatab_item["id_"..nNum].quality
  local level = nLevel or self.m_tCurPetsInfo.advancedLevel
  local color = txtColor[petQuality]
  local s0 = self:getTypeById(nNum)
  if sName ~= null then
    sName = " "..sName
  end
  local s1 = sName or " "..self.m_tCurPetsInfo.name
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
  local sLevel = string.format([[<I>%s</I><T C=%s S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T><T C="0,255,0" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T><T C="255,89,74" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]],s0,color, s1, s2, s3)
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
    return "ui/common/common_icon_xue.png"
  elseif petType == 2 then --攻击
    return "ui/common/common_icon_gong.png"
  elseif petType == 3 then --防御
    return "ui/common/common_icon_fang.png"
  elseif petType == 4 then --均衡
    return "ui/common/common_icon_jun.png"
  elseif petType == 5 then --经验
    return "ui/common/common_icon_cwexp.png"
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
    
    WndPetPhantom:showInterface()
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
end


--@brief  添加金币图标动画
function WndPets:_addTop()
  local cell, tcell = CellTopHandle:createElement()
  self.m_root:addChild(cell)
  tcell:setTopData("ui/pet/commom_icon_hb3.png", WndPets, self.onCloseClick,true,nil,nil,nil)
end

--@brief   控制容器控件里那个子节点可以显示
function WndPets:_setConChildVisble(tag)
  WZLog("WndPets:_setConChildVisble")
    if tag == 3 then
      if WndPetsUpgrade.m_root ~= nil then return end
      local element = WndPetsUpgrade:createElement()
      WindowManager:addWindow(element, WndPetsUpgrade)
    elseif tag == 4 then
      if WndPetsEvolution.m_root ~= nil then return end
      local element = WndPetsEvolution:createElement()
      WindowManager:addWindow(element, WndPetsEvolution)
    elseif tag == 5 then
      if WndPetsRebirth.m_root ~= nil then return end
      local element = WndPetsRebirth:createElement()
      WindowManager:addWindow(element, WndPetsRebirth)
    elseif tag == 6 then
      if WndPetsSkill.m_root ~= nil then return end
      local element = WndPetsSkill:createElement()
      WindowManager:addWindow(element, WndPetsSkill)
    end
	
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
end

function WndPets:_adaptLanguage_pt(  )
  GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF):setFontSize(18)

  GetElement(self.m_root,"txtPetAPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.12649,0.85))
  GetElement(self.m_root,"txtPetDPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.14871,0.7))
  GetElement(self.m_root,"txtPetHPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.859828,0.55))
  GetElement(self.m_root,"txtPetSPD_WndPets",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(2.4,0.4))

  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setScale(0.6)

  GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtTransfer5_WndStrengthen",WZUILabelTTF):setScale(0.75)
  GetElement(self.m_root,"txtTransfer6_WndStrengthen",WZUILabelTTF):setScale(0.75)

  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))
  
end

function WndPets:_adaptLanguage_th()
	GetElement(self.m_root,"conPetD_WndPets",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.3,0.5))
  GetElement(self.m_root,"txtName_WndPets",WZUIFreeTextBox):setMaxWidth(360)

  GetElement(self.m_root,"txtExpPetPro_WndPets",WZUILabelTTF):setFontSize(20)
end

function WndPets:_adaptLanguage_vn()
	local con = GetElement(self.m_root,"conPetD_WndPets",WZUIContainer)
  con:setRelativePosition(GlobalMethod:ccp(0.3,0.5))

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
end

function WndPets:_adaptLanguage_tr(  )
  -- GetElement(self.m_root,"txtObtain1_WndPets",WZUILabelTTF):setScale(0.9)
  -- GetElement(self.m_root,"txtObtain2_WndPets",WZUILabelTTF):setScale(0.9)

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
    GetElement(self.m_root,"txtWashGift_WndPets",WZUILabelTTF):setFontSize(10)
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

    local txtObtainPet1 = GetElement(self.m_root,"txtObtainPet1_WndPets",WZUILabelTTF)
    txtObtainPet1:setDimensions(GlobalMethod:CCSize(120))
    txtObtainPet1:setScale(0.8)
    local txtObtainPet2 = GetElement(self.m_root,"txtObtainPet2_WndPets",WZUILabelTTF)
    txtObtainPet2:setDimensions(GlobalMethod:CCSize(120))
    txtObtainPet2:setScale(0.8)
    
  GetElement(self.m_root,"btnPetPhantom_WndPets",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.926201,0.87))
end
-------------------------------------语言适配模块End--------------------------------------
