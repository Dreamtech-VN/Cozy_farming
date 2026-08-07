--WndPetsRebirth.lua
--@brief	WndPetsRebirth的UI模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物重生

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetsRebirth:onEnter(element)
	self.m_root = element
end

--@brief   反注册监听
function WndPetsRebirth:unRegisterPetInfoObserver()
end

--@brief   注册监听
function WndPetsRebirth:RegisterPetInfoObserver()
  
end

--@brief onEnter函数执行完成回调
function WndPetsRebirth:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true,"actionCallback",self)
end

--@brief  窗口动画完成回调
function WndPetsRebirth:actionCallback(elem,data)
  self:_setLocalText()
  local ani = GetElement(self.m_root,"armAddStar_WndPetsRebirth",WZArmature)
  ani:setAnimationFinishLuaFunction("armAddStarFinish")
  CacheCenter:registerUpatePlayerPetInfoObserver(self)
  self:initDate()
  AdaptLanguage(self)
end

-- 播放动画
function WndPetsRebirth:playAddStarAndUpdateAni()
    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
    local aniUp = GetElement(self.m_root,"armAddStar_WndPetsRebirth",WZArmature)
    aniUp:setVisible(true)
    local armature = aniUp:getArmature()
    armature:getAnimation():playByIndex(0,-1,-1,0)
end

-- 进阶动画播放完毕
function WndPetsRebirth:armAddStarFinish()
    local ani = GetElement(self.m_root,"armAddStar_WndPetsRebirth",WZArmature)
    ani:setVisible(false)
    --self:_cleanDate()
    DelayCallFunction(self.close, self,1.5,tData)
    --self:initDate()
end

-- 进阶动画播放完毕
function WndPetsRebirth:close()
   WndPets:doRefresh()
   WindowManager:removeWindow(self.m_root, self, true)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetsRebirth:onExit(element)
    CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
	self:_unInit()
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsRebirth:onCloseClick(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WZLog("WndPetsRebirth:onCloseClick")
  WndPets:doRefresh()
  WindowManager:removeWindow(self.m_root, self, true)
  -- WndPets:setCon()
  -- self:_cleanDate()
end

--@brief  点击选取被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsRebirth:onClickChange(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WZLog("WndPetsRebirth:onClickChange")
  local childNode = GetElement(self.m_root,"conChoiceList_WndPetsEvolution",WZUIContainer)
  if childNode:isVisible() then
    return
  end
  childNode:setVisible(true)
  WindowManagerAni:createAction(childNode, self.b_firstOpen)
  self.b_firstOpen = false
end

--@brief  点击选取被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsRebirth:onCloseChoice(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WZLog("WndPetsRebirth:onCloseChoice")
  if self.m_choicePet ~= nill then
     WZLog("WndPetsRebirth:has Pet")
    self:setShowState(self.m_choicePet:getPetInfo())

  else
    WZLog("WndPetsRebirth:no Pet")
    self:setShowState()
  end
  GetElement(self.m_root,"conChoiceList_WndPetsEvolution",WZUIContainer):setVisible(false)
  
end


--@brief	宠物重生
--@param	element:表绑定的UI节点引用
function WndPetsRebirth:onClickRebirth(element)
	WZLog("WndPetsRebirth:onRebirthClick")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  if self.m_bISAlter == true then
    return
  end
  if self.m_petInfo.isInUsed == true then  
    MsgBoxManager:showTipBox(LocalStrings.PETNOREBIIRTH)
    return
  end
  
  MsgBoxManager:showConfirmBox(LocalStrings.PETCONFIRMREBIRTH, WndPetsRebirth,self.doRebirth)
end



function WndPetsRebirth:doRebirth(element)
   DelayCallFunction(self.doRebirth2, self, 0.25)
end

function WndPetsRebirth:doRebirth2(element)
   if self.m_petInfo.upgradeLevel > 1 or self.m_petInfo.advancedLevel > 0 then
        WZLog("WndPetsRebirth:doRebirth:", self.m_nCostType,self.m_nConsumeCount)
        if JudgeMoneyIsEnough(self.m_nCostType, self.m_nConsumeCount,nil,nil,66, nil, nil, nil, nil, self, self.sureUseDiamondInstead)  then
            self:sureUseDiamondInstead()
        end
    else
         --MsgBoxManager:showTipBox("宠物等级为1和进阶等级为0不能进行重")
    end
end

--@brief  确认用钻石代理礼券重生
function WndPetsRebirth:sureUseDiamondInstead()
    -- body
    ProtocolProcessorScenePets:send_PET_Rebirth(self.m_petInfo.playerPetId)
    self.m_bISAlter = true
end

--@brief    更新进化按钮状态
function WndPetsRebirth:updateBtnStats()
	local btn =  self.m_root:getChildElement("btnPetRebirth_WndPetsRebirth")
	btn = WZUIButton:luaTo(btn)
	if self.m_petInfo then
        if self.m_petInfo.isInUsed then
        	btn:setTouchEnable(false)
        end
    else
    	btn:setTouchEnable(true)
	end
end

--@breif 设置宠物的现实信息
function WndPetsRebirth:initDate()
  self:showPetInfo()
  -- self:setShowState(self.m_petInfo)
  -- self:initChoiceList()
end

--@breif 设置宠物的现实信息
function WndPetsRebirth:setShowState(petInfo)
  if petInfo == nil then
    WZLog("WndPetsRebirth:setShowState no show")
     GetElement(self.m_root,"conPetInfo1_WndPetsRebirth",WZUIContainer):setVisible(false)
     GetElement(self.m_root,"conPetInfo3_WndPetsRebirth",WZUIContainer):setVisible(true)
     GetElement(self.m_root,"conGetMetarial_WndPetsRebirth",WZUIContainer):setVisible(false)
  else
    WZLog("WndPetsRebirth:setShowState has show")
     GetElement(self.m_root,"conPetInfo1_WndPetsRebirth",WZUIContainer):setVisible(true)
     GetElement(self.m_root,"conPetInfo3_WndPetsRebirth",WZUIContainer):setVisible(false)
     GetElement(self.m_root,"conGetMetarial_WndPetsRebirth",WZUIContainer):setVisible(true)
     self:updatePetInfo(petInfo)
     self:showPetInfo()
  end
end

--@breif 展示宠物的信息
function WndPetsRebirth:showPetInfo()
  WZLog("WndPetsRebirth:sshowPetInfo")
   --星星品质
   local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
  for i =1 ,5 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetsRebirth",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsRebirth", aptitude)
  --名字
   local name = self.m_petInfo.name
  local advancedLevel = self.m_petInfo.advancedLevel
  local nameText = GetElement(self.m_root,"txtName_WndPetsRebirth",WZUIFreeTextBox)
  WndPets:setPetName(self.m_petInfo.itemId, nameText, name, advancedLevel, false)
  --nameText:setText(name)
 
  --等级
  local lvtext = GetElement(self.m_root,"txtLv_WndPetsRebirth",WZUILabelTTF)
  lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
  WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)

  --动物动画
  local petImage = GetElement(self.m_root,"conPetImage_WndPetsRebirth",WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  local petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation,advancedLevel)
  --petAni:getAnimNode():setScale(1.5)
  self:showPetInfo2()
end

--@breif 初始化宠物可选取列表
function WndPetsRebirth:initChoiceList()
  local pets = self:findMatchPets()
  local tableList = GetElement(self.m_root,"conPetList_WndPetsRebirth",WZUIFreeListContainer)
  if tableList == nil then
        return
  end
  if tableList:size() > 0 then
      tableList:removeAll()
  end
  if #pets <= 0 then
    return
  end
  for i=1,#pets do
      local celElement , tCell = CellPetChoiceList:createElement()
      tCell:setCellAllElement(pets[i], 3)
      tableList:pushBack(WZUIContainer:luaTo(celElement))
      celElement:setContentSize(GlobalMethod:CCSize(420,120))
      celElement:setRelativeSize(GlobalMethod:CCSize(1,120/370))
  end
  tableList:update()
  tableList:getMoveElement():setPositionY(tableList:getMinPosition().y)
end

--@brief 选取宠物的处理
function WndPetsRebirth:choicePet(bAdd, tCell)
  WZLog("WndPetsRebirth:choicePet")
  if bAdd then
    if self.m_choicePet ~= nil then
      self.m_choicePet:_setButtonState(false)
    end
     WZLog("WndPetsRebirth:choicePet ADD")
    self.m_choicePet = {}
    self.m_choicePet = tCell
  else
     WZLog("WndPetsRebirth:choicePet nil")
    self.m_choicePet = nil
  end
end

--@brief  从宠物中心查找可以被当前宠物吞噬的宠物
function WndPetsRebirth:findMatchPets()
  WZLog("WndPetsRebirth:findMatchPets")
  self.m_tMatchPets = {}
  local cachePets = CacheCenter:getPlayerPetInfo()
  for k,v in pairs(cachePets) do 
    if  v.upgradeLevel > 1 or v.advancedLevel > 0 then
      table.insert(self.m_tMatchPets,v)
    end
  end
  return self.m_tMatchPets
end

--@breif  展示宠物信息
function WndPetsRebirth:showPetInfo2()
  WZLog("WndPetsRebirth:showPetInfo2")
  
	local conGoods1 = WZUIImage:luaTo(self.m_root:getChildElement("imgIconBg1_WndPetsRebirth"))
	local conGoods2 = WZUIImage:luaTo(self.m_root:getChildElement("imgIconBg2_WndPetsRebirth"))

	local tpets = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNum2_WndPetsRebirth"))
	local tExpPets = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNum1_WndPetsRebirth"))

  local imgCostType = WZUIImage:luaTo(self.m_root:getChildElement("imgSpendType_WndPetsRebirth"))
    
  local total_exp = 0
  local expPets = 0
  local eatPetCount = 1
  local petLevel = self.m_petInfo.upgradeLevel
  local levelPex = 0
  local rebirthCost = 0
  local costCount  = 0
  local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
  self.m_nCostType = 2
  rebirthCost = GDatatab_pet_rebirth["id_"..self.m_petInfo.advancedLevel].cost
  costCount= rebirthCost[1][2]
  self.m_nCostType = rebirthCost[1][1]
  --返回的经验宝宝数量
  local petId = 1
  local petId2 = 11000
  if petLevel > 1 or self.m_petInfo.advancedLevel > 0 then
      for i,v in pairs(GDatatab_pet) do
          if v.item_id == self.m_petInfo.itemId then
             levelPex = levelPex + v.exp
             WZLog("sss:", self.m_petInfo.itemId, levelPex)
              break
          end
      end
      if petLevel > 1 then
          total_exp= 0
          for  k,v in pairs(GDatatab_pet_upgrade) do
            if v.quality == quality and v.level ==  (petLevel-1) then
              total_exp = v.total_exp
              break
            end
          end
          WZLog("sss:",total_exp, self.m_petInfo.petExp )
          total_exp = total_exp + self.m_petInfo.petExp 
      end
      if petLevel == 1 then
          total_exp = levelPex+self.m_petInfo.petExp
      end
    
      WZLog("total_exp = ",total_exp)
      if total_exp >= 10000 then
         petId = 2
         petId2 = 11007
      end
      expPets = math.floor(total_exp / GDatatab_pet["id_"..petId].exp)
      if expPets < 0 then
          expPets =0
      end      
  end
local showItemId = self.m_petInfo.itemId
  if quality == 4 then
    eatPetCount = eatPetCount + GDatatab_pet_advance_evo["id_"..showItemId].number
    showItemId = showItemId - 20000
  end 
  --记录吃的宠物多少个
  for k,v in pairs(GDatatab_pet_advanced) do
        if v.item_id == showItemId and v.level == self.m_petInfo.advancedLevel then
            eatPetCount =eatPetCount + v.total_pet
        end
  end

  local tConsumeGoodsNum = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSpendSum_WndPetsRebirth"))

  tConsumeGoodsNum:setText(costCount)
  self.m_nConsumeCount = costCount
  local iconIconPath = GDatatab_item["id_" .. self.m_nCostType].icon
  imgCostType:setFile(iconIconPath)
  imgCostType:setScale(0.6)
  WZLog("WndPetsRebirth:showPetInfo eatPetCount = ",eatPetCount , expPets)

  tExpPets:setText("("..LocalStrings.NUM1..":"..eatPetCount..")")
  tpets:setText("("..LocalStrings.NUM1..":"..expPets..")")

  local curPetInfo = {}
  for k,v in pairs(GDatatab_pet) do
    if v.item_id == showItemId then
      curPetInfo = GDatatab_item["id_"..v.item_id]
      break
    end
  end 
  conGoods1:setFile(curPetInfo.icon)

  local itemId = GDatatab_pet["id_"..petId].item_id
  conGoods2:setFile(GDatatab_item["id_"..itemId].icon)

  local element =  GetElement(self.m_root,"imgIconBgQuality1_WndPetsRebirth",WZUIImage)
  local quality = GDatatab_item["id_"..showItemId].quality
  WndPets:setIconQuality(element, quality)
  local element2 =  GetElement(self.m_root,"imgIconBgQuality2_WndPetsRebirth",WZUIImage)
  local quality2 = GDatatab_item["id_"..petId2].quality
  WndPets:setIconQuality(element2, quality2)

  local nameText = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
  nameText:setText(curPetInfo.name)
  WndPets:setTextColor(GDatatab_item["id_"..showItemId].quality, nameText)
  local lvText = GetElement(self.m_root,"txtLv1_WndPetsRebirth",WZUILabelTTF)
  lvText:setText("Lv"..1)
  WndPets:setTextColor(GDatatab_item["id_"..showItemId].quality, lvText)
  local nameText2 = GetElement(self.m_root,"txtName2_WndPetsRebirth",WZUILabelTTF)
  nameText2:setText(GDatatab_item["id_"..petId2].name)
  WndPets:setTextColor(GDatatab_item["id_"..petId2].quality, nameText2)

  -- for i = 1, 5 do
  --   GetElement(self.m_root,"imgAptitude2"..i.."_WndPetsRebirth",WZUIImage):setVisible((i-1) <= GDatatab_item["id_"..self.m_petInfo.itemId].quality)
  -- end
  -- for i =1, 5 do
  --   GetElement(self.m_root,"imgAptitude3"..i.."_WndPetsRebirth",WZUIImage):setVisible((i-1) <= 1)
  -- end

end

function WndPetsRebirth:updatePlayerPetInfoData()
  WZLog("WndPetsRebirth:updatePlayerPetInfoData")
  if self.m_petInfo == nil then
    return 
  end   
  if self.m_bISAlter == true then
     self.m_bISAlter = false
     self:playAddStarAndUpdateAni()
     PopupResult("ui/common/common_icon_csz.png")
    -- MsgBoxManager:showTipBox(LocalStrings.PET_REBORN_SUCCESS)
  end
end

function WndPetsRebirth:rebornError()
   WZLog("WndPetsRebirth:rebornError")
   self.m_bISAlter = false
   MsgBoxManager:showTipBox(LocalStrings.PET_REBORN_ERROR)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPetsRebirth:_cleanDate()
  WZLog("WndPetsRebirth:_cleanDate")
  self.m_tMatchPets = {}
  self.m_choicePet = nil
  local tConsumeGoodsNum = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSpendSum_WndPetsRebirth"))
  tConsumeGoodsNum:setText(0)       
end

--@brief 调整星级位置
function WndPetsRebirth:_setAptitudePost(nNum)
  if nNum % 0 == 0 then
    GetElement(self.m_root,"conAptitude_WndPetsRebirth",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.475628,0.684379))
  else
     GetElement(self.m_root,"conAptitude_WndPetsRebirth",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.431711,0.684379))
  end
end

--@brief	设置本地界面文本
function WndPetsRebirth:_setLocalText()
	WZLog("WndPetsRebirth:_setLocalText")
  GetElement(self.m_root,"txtMyPets1_WndPetsRebirth",WZUILabelTTF):setText(LocalStrings.PET_REBIRTH)
  GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF):setText(LocalStrings.REBIRTH)
  GetElement(self.m_root,"txtPetRebirth_WndPetsRebirth",WZUILabelTTF):setText(LocalStrings.PET_REBIRTH)
  GetElement(self.m_root,"txtRebirthExplain_WndPetsRebirth",WZUILabelTTF):setText(LocalStrings.PET_REBRITH_EXPLAIN)
  
end




-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Star--------------------------------------
function WndPetsRebirth:_adaptLanguage_en()
	local txt = GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF)
  txt:setFontSize(20)
  txt:setRelativePosition(GlobalMethod:ccp(0.725327,0.5))
  local txtSum = GetElement(self.m_root,"txtSpendSum_WndPetsRebirth",WZUILabelTTF)
  txtSum:setRelativePosition(GlobalMethod:ccp(0.318888,0.5))
  txtSum:setFontSize(20)

  GetElement(self.m_root,"txtPetRebirth_WndPetsRebirth",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.506916,0.70151))
  local txtRebirthExplain = GetElement(self.m_root,"txtRebirthExplain_WndPetsRebirth",WZUILabelTTF)
  txtRebirthExplain:setRelativePosition(GlobalMethod:ccp(0.020564,0.424228))
  txtRebirthExplain:setDimensions(GlobalMethod:CCSize(394))
  txtRebirthExplain:setScale(0.8)

  GetElement(self.m_root,"txtLv1_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
  local txtName = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
  txtName:setRelativePosition(GlobalMethod:ccp(0.25,0.5))

  local txtSpendSum = GetElement(self.m_root,"txtSpendSum_WndPetsRebirth",WZUILabelTTF)
  txtSpendSum:setScale(0.8)
  txtName:setScale(0.7)
  GetElement(self.m_root,"txtName2_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
end

function WndPetsRebirth:_adaptLanguage_pt(  )
  local txt = GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF)
  txt:setFontSize(20)
  txt:setRelativePosition(GlobalMethod:ccp(0.481577,0.5))
  local txtSum = GetElement(self.m_root,"txtSpendSum_WndPetsRebirth",WZUILabelTTF)
  txtSum:setFontSize(20)
  txtSum:setRelativePosition(GlobalMethod:ccp(0.675138,0.5))
  
  GetElement(self.m_root,"txtRebirthExplain_WndPetsRebirth",WZUILabelTTF):setFontSize(17)
  GetElement(self.m_root,"txtPetRebirth_WndPetsRebirth",WZUILabelTTF):setFontSize(16)

  GetElement(self.m_root,"txtLv1_WndPetsRebirth",WZUILabelTTF):setScale(0.8)
  local txtName = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
  txtName:setRelativePosition(GlobalMethod:ccp(0.274545,0.5))
  txtName:setScale(0.8)
  GetElement(self.m_root,"txtName2_WndPetsRebirth",WZUILabelTTF):setScale(0.8)
end

function WndPetsRebirth:_adaptLanguage_th()
	GetElement(self.m_root,"txtPetRebirth_WndPetsRebirth",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.72))
end

function WndPetsRebirth:_adaptLanguage_vn(  )
  GetElement(self.m_root,"txtSpendSum_WndPetsRebirth",WZUILabelTTF):setFontSize(16)
  GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF):setFontSize(16)
  local txtName = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
  txtName:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
  txtName:setScale(0.7)
end

function WndPetsRebirth:_adaptLanguage_tr()
  local txtPetRebirthe = GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF)
  txtPetRebirthe:setDimensions(GlobalMethod:CCSize(60,0))
  txtPetRebirthe:setFontSize(16)

  GetElement(self.m_root,"imgArrow1_WndPetsRebirth",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
  GetElement(self.m_root,"imgArrow2_WndPetsRebirth",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.78,0.5))

  GetElement(self.m_root,"txtPetRebirth_WndPetsRebirth",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.506916,0.69526))
  local txtRebirthExplain = GetElement(self.m_root,"txtRebirthExplain_WndPetsRebirth",WZUILabelTTF)
  txtRebirthExplain:setRelativePosition(GlobalMethod:ccp(0.020564,0.424228))
  txtRebirthExplain:setDimensions(GlobalMethod:CCSize(380))
  txtRebirthExplain:setScale(0.9)

  GetElement(self.m_root,"txtLv1_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
  local txtName = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
  txtName:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
  txtName:setScale(0.7)
  GetElement(self.m_root,"txtName2_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
end

function WndPetsRebirth:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtPetRebirthe_WndPetsRebirth",WZUILabelTTF):setFontSize(18)
    local txtSpendSum = GetElement(self.m_root,"txtSpendSum_WndPetsRebirth",WZUILabelTTF)
    txtSpendSum:setFontSize(18)
    txtSpendSum:setRelativePosition(GlobalMethod:ccp(0.313,0.5))

    GetElement(self.m_root,"txtLv1_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
    local txtName1 = GetElement(self.m_root,"txtName1_WndPetsRebirth",WZUILabelTTF)
    txtName1:setScale(0.7)
    txtName1:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    GetElement(self.m_root,"txtName2_WndPetsRebirth",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配模块End--------------------------------------
