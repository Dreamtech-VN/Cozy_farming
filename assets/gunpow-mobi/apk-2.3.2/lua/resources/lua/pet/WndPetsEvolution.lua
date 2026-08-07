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
    -- WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
    self:actionCallback()
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
  -- WindowManager:removeWindow(self.m_root, self, true)
  WndPetsEvolution.m_root:removeFromParentAndCleanup(true)
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
    if self.m_petInfo.upgradeLevel < self.n_needLv and GDatatab_item["id_"..self.m_petInfo.itemId].quality < 4 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.PETNOADVANCELEVEL, self.n_needLv))
        return
    end
    if self.m_petInfo.advancedLevel >= 7 then
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
    -- local wndPetRaffle = WndPetRaffle:createElement()
    -- WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
    WndSummonEntrance:showInterface(2)
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
    if self.m_petInfo.upgradeLevel < self.n_needLv and GDatatab_item["id_"..self.m_petInfo.itemId].quality < 4 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.PETNOADVANCELEVEL, self.n_needLv))
        return false
    end
    if self.m_petInfo.advancedLevel >= 7 then
        MsgBoxManager:showTipBox(LocalStrings.PETFULLADVANCELEVEL)
        return false 
    end 
    for i = 1, 4 do
        if self.m_tUsePet[i] == nil then
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
        if nTag then 
            self.m_tUsePet[nTag] = nil
        else
            for i= 1, #self.m_tUsePet do
                if self.m_tUsePet[i] == cell then 
                    self.m_tUsePet[i] = nil 
                end
            end
        end
        self.n_canUseNum = self.n_canUseNum + 1
    end 
    self:updateChoosePetNum()
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
  self:showFight()
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
end

--@breif 显示宠物战力
function WndPetsEvolution:showFight()
  local fight = WndPets:getCurPetFight()
  local qualification = WndPets:getCurPetQualification()

  local txtFight = GetElement(self.m_root,"txtFight_WndPetsEvolution",WZUILabelTTF)
  CCNodePropertySetter:setValue(txtFight, "skewX", 10)
  -- local ftbFight = GetElement(self.m_root,"ftbFight_WndPetsEvolution",WZUIFreeTextBox)
  -- ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER1,fight))
  local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPetsEvolution",WZUILabelTTF)
  txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..qualification)
end

--查看宠物属性
function WndPetsEvolution:onShowAttribute(element)
  WndPets:showAttributeTips(element,self.m_root,1)
end

--@brief    获取当前选中的宠物数量
function WndPetsEvolution:getChoosePetNum()
    -- body
    local num = 0
    for i = 1, 4 do
        if  self.m_tUsePet[i] ~= nil then
            num = num + 1
        end
    end

    return num 
end

--@breif  展示当前宠物属性
function WndPetsEvolution:checkEnoughAdvance(levelUp)
    local bool = false
    if  self.m_petInfo.upgradeLevel < levelUp and GDatatab_item["id_"..self.m_petInfo.itemId].quality < 4 then
        bool = true
        GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF):setText(string.format(LocalStrings.PETNOADVANCELEVEL, levelUp))
    end
    if self.m_petInfo.advancedLevel >= 7 then
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
 
  -- --等级
  -- local lvtext = GetElement(self.m_root,"txtLv_WndPetsEvolution",WZUILabelTTF)
  -- lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
  -- WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)
  
   --星星品质
   local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
  for i = 1, 7 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetsEvolution",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsEvolution",aptitude)
  
  --属性
  local petProperty = self.m_petInfo.property
  local petJ =  json.decode(petProperty)
  local petHP = petJ["1"]
  local petAttack = petJ["3"]
  local petDefense = petJ["4"]
  local txtPetWarD = GetElement(self.m_root,"txtPetWarD_WndPetsEvolution",WZUILabelAtlasFont)
  txtPetWarD:setText(self.m_petInfo.fighting)
  GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF):setText(self.m_petInfo.advancedLevel)
  GetElement(self.m_root,"txtPetHPD1_WndPetsEvolution",WZUILabelTTF):setText(petHP)
  GetElement(self.m_root,"txtPetAPD1_WndPetsEvolution",WZUILabelTTF):setText(petAttack)
  GetElement(self.m_root,"txtPetDPD1_WndPetsEvolution",WZUILabelTTF):setText(petDefense)
  GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF):setText(self:_getSkillNum(advancedLevel))

  --动物动画
  local petImage = GetElement(self.m_root,"conPet1_WndPetsEvolution",WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  self.petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation, self.m_petInfo.advancedLevel)
  self:playAttackAni()
  --petAni:getAnimNode():setScale(1.3)
end

function WndPetsEvolution:playAttackAni()
  local conPet = GetElement(self.m_root,"conPet1_WndPetsEvolution",WZUIContainer)
  conPet:disableSchedule()
  
  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPetsEvolution:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet1_WndPetsEvolution",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end

--@breif  展示当前宠物属性
function WndPetsEvolution:showNextPetInfo(bool) 
  local rate = 0
  local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
  local id =  quality < 4 and self.m_petInfo.itemId or self.m_petInfo.itemId -20000
  for k,v in pairs(GDatatab_pet_advanced) do
    if v.item_id == id and v.level == math.min((self.m_petInfo.advancedLevel +1),7) then
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
    local icon = GDatatab_item["id_" .. self.t_cost[1][1]].icon
    GetElement(self.m_root, "imgCostIcon_WndPetsEvolution", WZUIImage):setFile(icon)
    GetElement(self.m_root,"txtLvE2_WndPetsEvolution",WZUILabelTTF):setText(self.t_cost[1][2])
    GetElement(self.m_root,"txtLvE3_WndPetsEvolution",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM, CacheCenter:getPlayerItemCountById(self.t_cost[1][1])))
    self:updateChoosePetNum()
end

--@breif 初始化宠物列表
function WndPetsEvolution:initChoiceList()
  local pets = self:findMatchPets()
  local tableList = GetElement(self.m_root,"conPetList_WndPetsEvolution", WZUITableContainer)
  if tableList == nil then
      return
  end
  tableList:cleanTable()
  GetElement(self.m_root,"conNoPet_WndPetsEvolution",WZUIContainer):setVisible(#pets <= 0)
  if #pets <= 0 then
    return
  end
  for i = 1, #pets do
      local celElement, tCell = CellPetSell:createElement()
      celElement = WZUIContainer:luaTo(celElement)
      celElement:setTag(i - 1)
      tCell:setData(pets[i], 2)
      tableList:setCellElement(celElement)
      table.insert(self.m_tMatchList,tCell)
  end

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
  if advanceLevel >= 7 then 
      return 5
  elseif advanceLevel >= 6 then
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
	GetElement(self.m_root, "conChoice_WndPetsEvolution",WZUIContainer):setVisible(bShow)
	GetElement(self.m_root, "conUnChoice_WndPetsEvolution",WZUIContainer):setVisible(bShow)
	GetElement(self.m_root, "conShowBtn_WndPetsEvolution",WZUIContainer):setVisible(bShow)
	self.b_eatPet = bShow
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

--@brief   更新选中宠物的数量
function WndPetsEvolution:updateChoosePetNum()
    -- body
    local nChooseNum = self:getChoosePetNum()
    GetElement(self.m_root, "txtMyPetsNum_WndPetsEvolution", WZUILabelTTF):setText(nChooseNum .. "/" .. self.t_cost[2][2])
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

function WndPetsEvolution:_adaptLanguage_ug(  )
  local txtPetEP1 = GetElement(self.m_root,"txtPetEP1_WndPetsEvolution",WZUILabelTTF)
  txtPetEP1:setScale(0.8)
  txtPetEP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetEP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetEP2 = GetElement(self.m_root,"txtPetEP2_WndPetsEvolution",WZUILabelTTF)
  txtPetEP2:setScale(0.8)
  txtPetEP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetEP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetHP1 = GetElement(self.m_root,"txtPetHP1_WndPetsEvolution",WZUILabelTTF)
  txtPetHP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetHP2 = GetElement(self.m_root,"txtPetHP2_WndPetsEvolution",WZUILabelTTF)
  txtPetHP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetAP1 = GetElement(self.m_root,"txtPetAP1_WndPetsEvolution",WZUILabelTTF)
  txtPetAP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetAP2 = GetElement(self.m_root,"txtPetAP2_WndPetsEvolution",WZUILabelTTF)
  txtPetAP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetDP1 = GetElement(self.m_root,"txtPetDP1_WndPetsEvolution",WZUILabelTTF)
  txtPetDP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetDP2 = GetElement(self.m_root,"txtPetDP2_WndPetsEvolution",WZUILabelTTF)
  txtPetDP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetSkill1 = GetElement(self.m_root,"txtPetSkill1_WndPetsEvolution",WZUILabelTTF)
  txtPetSkill1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSkill1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetSkill2 = GetElement(self.m_root,"txtPetSkill2_WndPetsEvolution",WZUILabelTTF)
  txtPetSkill2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSkill2:setRelativePosition(GlobalMethod:ccp(1,0.5))

  local txtPetEPD1 = GetElement(self.m_root,"txtPetEPD1_WndPetsEvolution",WZUILabelTTF)
  txtPetEPD1:setScale(0.8)
  txtPetEPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetEPD1:setRelativePosition(GlobalMethod:ccp(0.07,0.5))
  local txtPetEPD2 = GetElement(self.m_root,"txtPetEPD2_WndPetsEvolution",WZUILabelTTF)
  txtPetEPD2:setScale(0.8)
  txtPetEPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetEPD2:setRelativePosition(GlobalMethod:ccp(0.62,0.5))
  local txtPetHPD1 = GetElement(self.m_root,"txtPetHPD1_WndPetsEvolution",WZUILabelTTF)
  txtPetHPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetHPD2 = GetElement(self.m_root,"txtPetHPD2_WndPetsEvolution",WZUILabelTTF)
  txtPetHPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
  local txtPetAPD1 = GetElement(self.m_root,"txtPetAPD1_WndPetsEvolution",WZUILabelTTF)
  txtPetAPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetAPD2 = GetElement(self.m_root,"txtPetAPD2_WndPetsEvolution",WZUILabelTTF)
  txtPetAPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
  local txtPetDPD1 = GetElement(self.m_root,"txtPetDPD1_WndPetsEvolution",WZUILabelTTF)
  txtPetDPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetDPD2 = GetElement(self.m_root,"txtPetDPD2_WndPetsEvolution",WZUILabelTTF)
  txtPetDPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
  local txtPetSkillD1 = GetElement(self.m_root,"txtPetSkillD1_WndPetsEvolution",WZUILabelTTF)
  txtPetSkillD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSkillD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetSkillD2 = GetElement(self.m_root,"txtPetSkillD2_WndPetsEvolution",WZUILabelTTF)
  txtPetSkillD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetSkillD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))

  GetElement(self.m_root,"txtMyPets2_WndPetsEvolution",WZUILabelTTF):setScale(0.7)

  GetElement(self.m_root,"txtLvE1_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.98,0.45))
  GetElement(self.m_root,"conImgCwjjd_WndPetsEvolution",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.62,0.45))
  GetElement(self.m_root,"txtLvE2_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.45))
  GetElement(self.m_root,"txtLvE3_WndPetsEvolution",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.07,0.45))

  GetElement(self.m_root,"txtShowBtn1_WndPetsEvolution",WZUILabelTTF):setScale(0.7)
  GetElement(self.m_root,"txtShowBtn2_WndPetsEvolution",WZUILabelTTF):setScale(0.7)
  GetElement(self.m_root,"txtShowBtn3_WndPetsEvolution",WZUILabelTTF):setScale(0.7)
  local txtPetUp1 = GetElement(self.m_root,"txtPetUp1_WndPetsEvolution",WZUILabelTTF)
  txtPetUp1:setScale(0.7)
  txtPetUp1:setDimensions(GlobalMethod:CCSize(160))
  local txtPetUp2 = GetElement(self.m_root,"txtPetUp2_WndPetsEvolution",WZUILabelTTF)
  txtPetUp2:setScale(0.7)
  txtPetUp2:setDimensions(GlobalMethod:CCSize(160))
  local txtPetChoice1 = GetElement(self.m_root,"txtPetChoice1_WndPetsEvolution",WZUILabelTTF)
  txtPetChoice1:setScale(0.6)
  txtPetChoice1:setDimensions(GlobalMethod:CCSize(160))
  local txtPetChoice2 = GetElement(self.m_root,"txtPetChoice2_WndPetsEvolution",WZUILabelTTF)
  txtPetChoice2:setScale(0.6)
  txtPetChoice2:setDimensions(GlobalMethod:CCSize(160))

  local txtNoAdvance = GetElement(self.m_root,"txtNoAdvanceDesc_WndPetsEvolution",WZUILabelTTF)
  txtNoAdvance:setDimensions(GlobalMethod:CCSize(600,0))
  txtNoAdvance:setScale(0.6)
end
-------------------------------------语言适配模块End--------------------------------------
