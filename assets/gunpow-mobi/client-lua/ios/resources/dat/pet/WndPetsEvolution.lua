--WndPetsEvolution.lua
--@brief	WndPetsEvolution的UI模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物进化
-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetsEvolution:onEnter(element)
  WZLog("WndPetsEvolution:onEnter")
	self.m_root = element
  AdaptLanguage(self)
	self:_setLocalText()
  local ani = GetElement(self.m_root,"armAddStar_WndPetsEvolution",WZArmature)
  ani:setAnimationFinishLuaFunction("armAddStarFinish")
  CacheCenter:registerUpatePlayerItemObserver(self)
  CacheCenter:registerUpatePlayerPetInfoObserver(self)
end

-- 进阶动画播放完毕
function WndPetsEvolution:armAddStarFinish()
    local ani = GetElement(self.m_root,"armAddStar_WndPetsEvolution",WZArmature)
    ani:setVisible(false)
end

-- 播放动画
function WndPetsEvolution:playAddStarAndUpdateAni()
    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR) --0.5,0.37   0.26
    local aniUp = GetElement(self.m_root,"armAddStar_WndPetsEvolution",WZArmature)
    aniUp:setVisible(true)
    local armature = aniUp:getArmature()
    armature:getAnimation():playByIndex(0,-1,-1,0)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetsEvolution:onExit(element)
  WZLog("WndPetsEvolution:onExit")
	self:_unInit()
  CacheCenter:unregisterUpatePlayerItemObserver(self)
  CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
end

--@brief onEnter函数执行完成回调
function WndPetsEvolution:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief  窗口动画完成回调
function WndPetsEvolution:actionCallback(elem,data)
  self:initDate()
end

--@brief   反注册监听
function WndPetsEvolution:unRegisterPetInfoObserver()
  WZLog("WndPetsEvolution:unRegisterPetInfoObserver")
 
end

--@brief   注册监听
function WndPetsEvolution:RegisterPetInfoObserver()
  WZLog("WndPetsEvolution:RegisterPetInfoObserver")
end

--更新商品购买后的界面显示
function WndPetsEvolution:updatePlayerItemData()
   WZLog("WndPetsEvolution:updatePlayerItemData")
  GetElement(self.m_root,"txtLvE3_WndPetsEvolution",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(self.t_cost[1][1])))
end

--@brief	宠物进化
--@param	element:表绑定的UI节点引用
--@note     满足指定条件才能进行进化
function WndPetsEvolution:onClickEvolution(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bISAlter == true then
        return
    end
    if self:canAdvance() then
        local bHavePhantomPet = false 
        for i = 1, #self.t_usePetId do
            if self.t_usePetId[i].petSkinItemId > 0 then
                bHavePhantomPet = true
                break 
            end
        end
        if bHavePhantomPet then
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
            MsgBoxManager:showConfirmBox(LocalStrings.PET_TEXT10, self, self.continueToExtranction, nil, tCustomUIConfig)
            return 
        end
        self:continueToExtranction()
    end
end

--@brief  继续
function WndPetsEvolution:continueToExtranction()
    --body
    local VansPriceID = WZLuaVector_int_:create()
    for i = 1, #self.t_usePetId do
        VansPriceID:push(self.t_usePetId[i].playerPetId)
    end
    self.m_bISAlter = true
    ProtocolProcessorScenePets:send_PET_Advanced(self.m_petInfo.playerPetId,VansPriceID)
end

--打开宠物预览界面
function WndPetsEvolution:onClickShow(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WZLog("WndPetsEvolution:onClickShow")
  WndPetShow:show(self.m_petInfo.itemId)
end

--@brief 判断是否能进阶
--@return 是否能进阶, petTable,宠物栏存蓄物品的id
function WndPetsEvolution:canAdvance()
    WZLog("WndPetsEvolution:canAdvance")
    if CacheCenter:getPlayerItemCountById(self.t_cost[1][1]) < self.t_cost[1][2] then
        --checkIsOnSale(self.t_cost[1][1])
  	    WndFastGetItems:show(self.t_cost[1][1])
        --MsgBoxManager:showTipBox(LocalStrings.PETNOADVANCEGOODS)
        return false
    end
    local num = 0
    self.t_usePetId = {}
    for i = 1, 4 do
        if self.m_tUsePet[i] ~= nil then
            local tItem = {}
            tItem.playerPetId = self.m_tUsePet[i]:getPetInfo().playerPetId
            tItem.petSkinItemId = self.m_tUsePet[i]:getPetInfo().petSkinItemId

            num = num + 1
            table.insert(self.t_usePetId, tItem)
        end
    end
    if num < self.t_cost[2][2] then
        MsgBoxManager:showTipBox(LocalStrings.PETNOENOUGHNUM)
        return false
    end
    return true
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsEvolution:onCloseClick(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
  WZLog("WndPetsEvolution:onCloseClick")
  WndPets:doRefresh()
  WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  退出选择宠物时被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsEvolution:onCloseChoice(element)
  WZLog("WndPetsEvolution:onCloseChoice")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  self:_setChoiceViewState(false)
end

--@brief  宠物进化添加宠物按钮被点击
--@param  element:表绑定的UI节点引用
function WndPetsEvolution:onAddPetClick(element)
  WZLog("WndPetsEvolution:onAddPetClick=")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  if  self.m_petInfo.upgradeLevel < self.n_needLv and GDatatab_item["id_"..self.m_petInfo.itemId].quality < 4 then
     MsgBoxManager:showTipBox(string.format(LocalStrings.PETNOADVANCELEVEL, self.n_needLv))
     return
  end
  if  self.m_petInfo.advancedLevel >= 6 then
     MsgBoxManager:showTipBox(LocalStrings.PETFULLADVANCELEVEL)
	 return
  end 
  if self.b_eatPet then
	self:onPetChoice(element)
  else
	self:_setChoiceViewState(true)
  end
end

--去获取宠物
function WndPetsEvolution:onGetPet(element)
  WZLog("WndPetsEvolution:onGetPet")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local wndPetRaffle = WndPetRaffle:createElement()
  WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
end

--@brief  宠物进化选取宠物按钮被点击
--@param  element:表绑定的UI节点引用
function WndPetsEvolution:onPetChoice(element)
  WZLog("WndPetsEvolution:onPetChoice=")
  local tag = element:getTag()
  if self.m_tUsePet[tag] == nil then
    if self:checkPetSpillNeed() then
      MsgBoxManager:showTipBox(LocalStrings.PETENOUGHNUM)
      return 
    end
    for i=1, #self.m_tMatchList do
      local bool,tcell = self.m_tMatchList[i]:choicePetOnEvolution(tag)
      if bool then
        self:addChoicePet(true,tag,tcell)
        break
      end
    end
  else
    self.m_tUsePet[tag]:_setButtonState(false)
    self:addChoicePet(false,tag)
  end
end

--@brief 检测是否还有选取栏可以选取宠物
--return true为可添加，i为可添加格子的id
function WndPetsEvolution:checkPetSpill()
  if self:checkPetSpillNeed() then
     MsgBoxManager:showTipBox(LocalStrings.PETENOUGHNUM)
    return false
  end
  for i = 1, 4 do
    if  self.m_tUsePet[i] == nil then
      return true,i
    end
  end
  WZLog(" WndPetsEvolution:checkPetSpill")
  MsgBoxManager:showTipBox(LocalStrings.PETENOUGHNUM)
  return false
end

--@brief 检测是否超出进阶所需求的宠物
--return true为可添加，i为可添加格子的id
function WndPetsEvolution:checkPetSpillNeed()
  local num = 0
  for i = 1, 4 do
    if  self.m_tUsePet[i] ~= nil then
      num = num + 1
    end
  end
  WZLog("checkPetSpillNeed", num, self.t_cost[2][2])
  return (num >= self.t_cost[2][2]) 
end

--@brief 检测是否还有选取栏可以选取宠物
function WndPetsEvolution:addChoicePet(bAdd,nTag,cell)
  WZLog("WndPetsEvolution:addChoicePet:",bAdd, nTag, cell)
  if bAdd then
    self.m_tUsePet[nTag] = {}
    self.m_tUsePet[nTag] = cell
    self.n_canUseNum = self.n_canUseNum - 1
  else
    self.m_tUsePet[nTag] = nil
    self.n_canUseNum = self.n_canUseNum + 1
  end 
  self:upAddBtn(nTag)
end

--@brief 更新化当前界面数据
function WndPetsEvolution:initDate()
  local levelUp = -1
  for k,v in pairs(GDatatab_pet_advanced) do
    local itemId = v.item_id
    if GDatatab_item["id_"..self.m_petInfo.itemId].quality == 4 then
      itemId = itemId +20000
    end
    if itemId == self.m_petInfo.itemId and v.level == (self.m_petInfo.advancedLevel +1) then
      self.t_cost = v.cost
      levelUp = v.need_level
      self.n_needLv = levelUp
      break
    end
  end
  local bool = self:checkEnoughAdvance(levelUp)
  GetElement(self.m_root,"conNoShow_WndPetsEvolution",WZUIContainer):setVisible(bool)
  GetElement(self.m_root,"conShow_WndPetsEvolution",WZUIContainer):setVisible(not bool)
  self:showCurPetInfo()
  self:showNextPetInfo(bool)
  self:initUseMaterial()
  --如果是无法进阶，就不需要在寻找宠物表和更新按钮了
  if bool then
    WZLog("WndPetsEvolution:initDate true")
    --return
  end
  if self.m_tMatchPets == nil then
      WZLog("WndPetsEvolution:initDate m_tMatchPets")
      self:initChoiceList()
  end
  self:initBtnIcon()
  self:upAddBtn()
end



--@breif  展示当前宠物属性
function WndPetsEvolution:checkEnoughAdvance(levelUp)
  local bool = false
  if  self.m_petInfo.upgradeLevel < levelUp and GDatatab_item["id_"..self.m_petInfo.itemId].quality < 4 then
    bool = true
    GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setText(string.format(LocalStrings.PETNOADVANCELEVEL, levelUp))
  end
  if  self.m_petInfo.advancedLevel >= 6 then
    GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setText(LocalStrings.PETFULLADVANCELEVEL)
    bool = true
  end 
  GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setVisible(bool)
  GetElement(self.m_root,"btnDoAdvance_WndPetsEvolution",WZUIButton):setTouchEnable(not bool)
  return bool
end


--@breif  展示当前宠物属性
function WndPetsEvolution:showCurPetInfo()
   --名字
  local name = self.m_petInfo.name
  local advancedLevel = self.m_petInfo.advancedLevel
  local nameText = GetElement(self.m_root,"txtName_WndPetsEvolution",WZUIFreeTextBox)
  WndPets:setPetName(self.m_petInfo.itemId, nameText, name, advancedLevel, false)
  --nameText:setText(name)
 
  --等级
  local lvtext = GetElement(self.m_root,"txtLv_WndPetsEvolution",WZUILabelTTF)
  lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
  WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)
  
   --星星品质
   local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
  for i =1 ,5 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetsEvolution",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsEvolution",aptitude)
  
  --属性
  local petProperty = self.m_petInfo.property
  local petJ =  json.decode(petProperty)
  local petHP = petJ["1"]
  local petAttack = petJ["3"]
  local petDefense = petJ["4"]
  GetElement(self.m_root,"txtPetWarD_WndPetsEvolution",WZUILabelAtlasFont):setText(self.m_petInfo.fighting)
  GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF):setText(self.m_petInfo.advancedLevel)
  GetElement(self.m_root,"txtPetHPD1_WndPetsEvolution",WZUILabelTTF):setText(petHP)
  GetElement(self.m_root,"txtPetAPD1_WndPetsEvolution",WZUILabelTTF):setText(petAttack)
  GetElement(self.m_root,"txtPetDPD1_WndPetsEvolution",WZUILabelTTF):setText(petDefense)
  GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF):setText(self:_getSkillNum(advancedLevel))

  --动物动画
  local petImage = GetElement(self.m_root,"conPet1_WndPetsEvolution",WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  local petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation, self.m_petInfo.advancedLevel)
  --petAni:getAnimNode():setScale(1.3)
end

--@breif  展示当前宠物属性
function WndPetsEvolution:showNextPetInfo(bool) 
  local rate = 0
  local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
  local id =  quality < 4 and self.m_petInfo.itemId or self.m_petInfo.itemId -20000
  for k,v in pairs(GDatatab_pet_advanced) do
    if v.item_id == id and v.level == math.min((self.m_petInfo.advancedLevel +1),6) then
      rate = (v.property_rate)/10000
      break
    end
  end
  --属性
  local petProperty = self.m_petInfo.property
  local petJ =  json.decode(petProperty)
  local aa = GDatatab_item["id_"..self.m_petInfo.itemId].property
  WZLog("WndPetsEvolution:showNextPetInfo:",self.m_petInfo.itemId,Serialize(aa))
  local bb = {}
  local level = self.m_petInfo.upgradeLevel
  for  k,v in pairs(GDatatab_pet) do
      if v.item_id == self.m_petInfo.itemId then
          bb = v.property
          break
      end
  end
  local petHP = math.floor(aa[1][2]+bb[1][2]/100*level)
  petHP = petHP + math.ceil(petHP*rate)
  local petAttack = math.floor(aa[2][2]+bb[2][2]/100*level)
  petAttack = petAttack + math.ceil(petAttack*rate)
  local petDefense = math.floor(aa[3][2]+bb[3][2]/100*level)
  petDefense = petDefense + math.ceil(petDefense*rate)
  --添加羁绊属性
  local tFetterState = SplitStringWithSeparator(self.m_petInfo.fetterStatus, "|", nil, true) --
  local fetterConfig = WndPetFetter:_getFetterConfig(self.m_petInfo.itemId)
  for i = 1, #tFetterState do
      if tFetterState[i] ~= 0 then 
          for k = 1, #fetterConfig["attribute" .. i] do
              if fetterConfig["attribute" .. i][k][1] == 1 then 
                  petHP = petHP + fetterConfig["attribute" .. i][k][2]
              elseif fetterConfig["attribute" .. i][k][1] == 3 then 
                  petAttack = petAttack + fetterConfig["attribute" .. i][k][2]
              elseif fetterConfig["attribute" .. i][k][1] == 4 then 
                  petDefense = petDefense + fetterConfig["attribute" .. i][k][2]
              end
          end
      end
  end
  --计算战力用的
  local petHP2 = math.ceil(petHP*self.m_petInfo.giftSkill/10000)
  local petAttack2 = math.ceil(petAttack*self.m_petInfo.giftSkill/10000)
  local petDefense2 = math.ceil(petDefense*self.m_petInfo.giftSkill/10000)
  local fighting = math.ceil((petHP2+4.8*petAttack2+6*petDefense2)*0.75)
  if bool then
      GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF):setText("???")
    	GetElement(self.m_root,"txtPetHPD2_WndPetsEvolution",WZUILabelTTF):setText("???")
    	GetElement(self.m_root,"txtPetAPD2_WndPetsEvolution",WZUILabelTTF):setText("???")
    	GetElement(self.m_root,"txtPetDPD2_WndPetsEvolution",WZUILabelTTF):setText("???")
      GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF):setText("???")
  else
      GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF):setText(self.m_petInfo.advancedLevel +1)
    	GetElement(self.m_root,"txtPetHPD2_WndPetsEvolution",WZUILabelTTF):setText(petHP)
    	GetElement(self.m_root,"txtPetAPD2_WndPetsEvolution",WZUILabelTTF):setText(petAttack)
    	GetElement(self.m_root,"txtPetDPD2_WndPetsEvolution",WZUILabelTTF):setText(petDefense)
      GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF):setText(self:_getSkillNum(self.m_petInfo.advancedLevel+1))
  end

end

--初始化材料
function WndPetsEvolution:initUseMaterial()
    GetElement(self.m_root,"txtLvE2_WndPetsEvolution",WZUILabelTTF):setText(self.t_cost[1][2])
    GetElement(self.m_root,"txtLvE3_WndPetsEvolution",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(self.t_cost[1][1])))
end

--初始化按钮图标
function WndPetsEvolution:initBtnIcon()
  WZLog("WndPetsEvolution:initBtnIcon:", self.m_petInfo.itemId)
  local id = self.m_petInfo.itemId
  local quality = GDatatab_item["id_"..id].quality
  if quality >= 4 then
    id = id - 20000
    quality = 3
  end
  local icon = GDatatab_item["id_"..id].icon
  local num = self.t_cost[2][2]
  for i = 1, 4 do
    local element = GetElement(self.m_root,"imgIconBgQuality"..i.."_WndPetsEvolution",WZUIImage)
    WndPets:setIconQuality(element, quality)
    if i <= self.t_cost[2][2] then
      local element2 = GetElement(self.m_root,"imgChoiceIcon"..i.."_WndPetsEvolution",WZUIImage)
	    element2:setScale(1)
	    element2:setFile(icon)
      GetElement(self.m_root,"imgChoiceBg"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(true)
    else
      GetElement(self.m_root,"imgAddChoice"..i.."_WndPetsEvolution",WZUIImage):setVisible(false)
      GetElement(self.m_root,"txtHasNum"..i.."_WndPetsEvolution",WZUILabelTTF):setVisible(false)
      GetElement(self.m_root,"imgChoiceBg"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(true)
      element:setGrayRender(true)
      local element2 = GetElement(self.m_root,"imgChoiceIcon"..i.."_WndPetsEvolution",WZUIImage)
	    element2:setScale(0.5)
      element2:setFile("ui/common/common_icon_suo.png")
    end
    GetElement(self.m_root,"conAddBtn"..i.."_WndPetsEvolution",WZUIContainer):setTouchEnable(i <= self.t_cost[2][2])
  end
end

--@breif 设置添加按钮的状态
function WndPetsEvolution:upAddBtn(nTag, _bChoice)
  local k,v = 0,0
  local bChoice = _bChoice or false
  WZLog("WndPetsEvolution:upAddBtn", bChoice)
  if nTag ~= nil then
    k,v = nTag,nTag
  else
    k,v = 1, self.t_cost[2][2]
  end
  for i = k, v do
    if self.m_tUsePet[i] ~= nil then
       GetElement(self.m_root,"imgChoiceIcon"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(false)
       GetElement(self.m_root,"imgIconBgQuality"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(false)
       GetElement(self.m_root,"imgAddChoice"..i.."_WndPetsEvolution",WZUIImage):setVisible(false)
       GetElement(self.m_root,"txtHasNum"..i.."_WndPetsEvolution",WZUILabelTTF):setVisible(false)
       GetElement(self.m_root,"imgChoiceBg"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(false)
    else
      GetElement(self.m_root,"imgChoiceBg"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(true)
       GetElement(self.m_root,"imgChoiceIcon"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(true)
       GetElement(self.m_root,"imgIconBgQuality"..i.."_WndPetsEvolution",WZUIImage):setGrayRender(true)
       GetElement(self.m_root,"imgAddChoice"..i.."_WndPetsEvolution",WZUIImage):setVisible(true)
       GetElement(self.m_root,"txtHasNum"..i.."_WndPetsEvolution",WZUILabelTTF):setVisible(true)
       GetElement(self.m_root,"txtHasNum"..i.."_WndPetsEvolution",WZUILabelTTF):setText(""..(self.n_canUseNum).."/1")
    end
	GetElement(self.m_root,"txtHasNum"..i.."_WndPetsEvolution",WZUILabelTTF):setVisible(bChoice)
  end
end

--@breif 设置选择宠物的文字颜色
function WndPetsEvolution:setColorNum(txt, bChoice, num)
  if bChoice then
    txt:setTextColor(GlobalMethod:ccc3(0,255,0))
  else
    if num > 0 then
      txt:setTextColor(GlobalMethod:ccc3(255,255,255))
    else
       txt:setTextColor(GlobalMethod:ccc3(255,0,0))
    end
  end
end

--@breif 初始化宠物列表
function WndPetsEvolution:initChoiceList()
  local pets = self:findMatchPets()
  local tableList = GetElement(self.m_root,"conPetList_WndPetsEvolution",WZUIFreeListContainer)
  if tableList == nil then
        return
  end
  if tableList:size() > 0 then
      tableList:removeAll()
  end
  GetElement(self.m_root,"conNoPet_WndPetsEvolution",WZUIContainer):setVisible(#pets <= 0)
  if #pets <= 0 then
    return
  end
  for i=1,#pets do
      local celElement , tCell = CellPetChoiceList:createElement()
      tCell:setCellAllElement(pets[i], 2)
      tableList:pushBack(WZUIContainer:luaTo(celElement))
      celElement:setContentSize(GlobalMethod:CCSize(460,90))
      celElement:setRelativeSize(GlobalMethod:CCSize(1,90/256))
      table.insert(self.m_tMatchList, tCell)
  end
  tableList:update()
  tableList:getMoveElement():setPositionY(tableList:getMinPosition().y)
end


--@brief  从宠物中心查找可以被当前宠物吞噬的宠物
function WndPetsEvolution:findMatchPets()
  WZLog("WndPetsEvolution:findMatchPets")
  self.m_tMatchPets = {}
  local cachePets = CacheCenter:getPlayerPetInfo()
  local petId = tonumber(self.t_cost[2][1])
  for k,v in pairs(cachePets) do
    WZLog("gggggg:",petId, v.itemId, v.advancedLevel, v.isInUsed)
    if petId == v.itemId and self.m_petInfo.playerPetId ~= v.playerPetId and 
      v.isInUsed == false  and v.advancedLevel < 1 then
       table.insert(self.m_tMatchPets,v)
    end
  end
  self.n_canUseNum = #self.m_tMatchPets
  return self.m_tMatchPets
end


--@brief   监听宠物信息有变化时执行此方法
function WndPetsEvolution:updatePlayerPetInfoData()
  WZLog("WndPetsEvolution:updatePlayerPetInfoData")
  if self.m_petInfo == nil then
    return
  end
  if self.m_bISAlter == true then
     self.m_bISAlter = false
     for k,v in pairs(CacheCenter:getPlayerPetInfo()) do
      if v.playerPetId == self.m_petInfo.playerPetId then
         PopupResult("ui/common/common_icon_jhz.png")
         self:playAddStarAndUpdateAni()
         upPlayerFightingAni(v.fighting - self.n_curFighting)
         self:_cleanDate()
         self:setPetInfo(v)
         self:initDate()
         break
      end
     end
     
     -- MsgBoxManager:showTipBox(LocalStrings.ADVANCED_SUCCESS)
     
  end
end

--@brief  进阶失败
function WndPetsEvolution:advancedError(sMessage)
  WZLog("WndPetsEvolution:advancedError")
  self.m_bISAlter = false
  MsgBoxManager:showTipBox(LocalStrings.ADVANCED_ERROR..":"..sMessage)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif 清除数据
function WndPetsEvolution:_cleanDate()
  self.n_canUseNum = 0
  self.t_usePetId = {}
  self.m_tUsePet = {}                --记录格子里的宠物
  self.m_tMatchPets = nil             --存放可以被当前宠物吞噬的宠物
  self.m_tMatchList = {}
end

--@breif 清除数据
function  WndPetsEvolution:_getSkillNum(advanceLevel)
  if advanceLevel >= 6 then
    return 4
  elseif advanceLevel >= 5 then
    return 3
  elseif advanceLevel >= 3 then
    return 2
  elseif advanceLevel >= 1 then
    return 1
  else
    return 0
  end
end

--@brief 设置选择宠物界面的状态
function WndPetsEvolution:_setChoiceViewState(bShow)
	if bShow then
		GetElement(self.m_root, "conChoicePet_WndPetsEvolution",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.26))
	else
		GetElement(self.m_root, "conChoicePet_WndPetsEvolution",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.37))
	end
	GetElement(self.m_root, "conChoice_WndPetsEvolution",WZUIContainer):setVisible(bShow)
	GetElement(self.m_root, "conUnChoice_WndPetsEvolution",WZUIContainer):setVisible(not bShow)
	GetElement(self.m_root, "conShowBtn_WndPetsEvolution",WZUIContainer):setVisible(not bShow)
	self.b_eatPet = bShow
	--self.upAddBtn(nil, bShow)
end

--@brief	设置本地界面文本
function WndPetsEvolution:_setLocalText()
  --标题名称
end

--@brief    宠物进阶后返回的数据
function WndPetsEvolution:petEvolutionData(itemId, name, icon,animation,advancedLevel,upgradeLevel ,property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId, originType,num,petExp,fighting)
    if originType[1] ==1 then
      WZLog("WndPetsEvolution:petEvolutionData")
      CacheCenter:updatePlayerPetInfo(itemId, name, icon,animation,advancedLevel,upgradeLevel ,property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting)
    end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndPetsEvolution:_adaptLanguage_en()
	GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setFontSize(22)
end

function WndPetsEvolution:_adaptLanguage_pt(  )
  GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setFontSize(14)
  GetElement(self.m_root,"txtMyPets2_WndPetsEvolution",WZUILabelTTF):setFontSize(21)
end

function WndPetsEvolution:_adaptLanguage_vn(  )
  GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.25,0.5))
  GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
  GetElement(self.m_root,"txtPetHPD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.184857,0.5))
  GetElement(self.m_root,"txtPetHPD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.762857,0.5))
  GetElement(self.m_root,"txtPetAPD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
  GetElement(self.m_root,"txtPetAPD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
  GetElement(self.m_root,"txtPetDPD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.5))
  GetElement(self.m_root,"txtPetDPD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.76,0.5))
  GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.242857,0.5))
  GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.822857,0.5))

  GetElement(self.m_root,"txtMyPets2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.98))
  GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.25,0.5))
  GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
end

function WndPetsEvolution:_adaptLanguage_th(  )
  GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setFontSize(20)
end

function WndPetsEvolution:_adaptLanguage_tr()
  GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setScale(0.75)
  for i=1,2 do
       GetElement(self.m_root,"txtPetEP"..i.."_WndPetsEvolution",WZUILabelTTF):setFontSize(18)
  end
  local txtPetEPD1 = GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF)
  txtPetEPD1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
  local txtPetEPD2 = GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF)
  txtPetEPD2:setRelativePosition(GlobalMethod:ccp(0.88,0.5))

  local txtPetSkillD1 = GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF)
  txtPetSkillD1:setRelativePosition(GlobalMethod:ccp(0.26,0.5))
  local txtPetSkillD2 = GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF)
  txtPetSkillD2:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
end

function WndPetsEvolution:_adaptLanguage_es(  )
    local txtPetEPD1 = GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF)
    txtPetEPD1:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
    local txtPetEPD2 = GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF)
    txtPetEPD2:setRelativePosition(GlobalMethod:ccp(0.93,0.5))
    local txtPetAPD1 = GetElement(self.m_root,"txtPetAPD1_WndPetsEvolution",WZUILabelTTF)
    txtPetAPD1:setRelativePosition(GlobalMethod:ccp(0.24,0.5))
    local txtPetAPD2 = GetElement(self.m_root,"txtPetAPD2_WndPetsEvolution",WZUILabelTTF)
    txtPetAPD2:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
    local txtPetDPD1 = GetElement(self.m_root,"txtPetDPD1_WndPetsEvolution",WZUILabelTTF)
    txtPetDPD1:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    local txtPetDPD2 = GetElement(self.m_root,"txtPetDPD2_WndPetsEvolution",WZUILabelTTF)
    txtPetDPD2:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    local txtPetSkillD1 = GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF)
    txtPetSkillD1:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    txtPetSkillD1:setFontSize(18)
    local txtPetSkillD2 = GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF)
    txtPetSkillD2:setRelativePosition(GlobalMethod:ccp(0.91,0.5))
    txtPetSkillD2:setFontSize(18)
    local txtLvE1 = GetElement(self.m_root,"txtLvE1_WndPetsEvolution",WZUILabelTTF)
    txtLvE1:setFontSize(17)
    txtLvE1:setRelativePosition(GlobalMethod:ccp(0.183,0.45))
    local txtNoAdvance = GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF)
    txtNoAdvance:setDimensions(GlobalMethod:CCSize(400,0))
    txtNoAdvance:setFontSize(20)

    GetElement(self.m_root,"imgArrow1_WndPetsEvolution",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
    GetElement(self.m_root,"imgArrow2_WndPetsEvolution",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.78,0.5))

    --GetElement(self.m_root,"txtPetShow1_WndPetsEvolution",WZUILabelTTF):setScale(0.8)
    --GetElement(self.m_root,"txtPetShow2_WndPetsEvolution",WZUILabelTTF):setScale(0.8)
    --GetElement(self.m_root,"txtPetShow3_WndPetsEvolution",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配模块End--------------------------------------
