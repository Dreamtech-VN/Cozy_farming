--WndPetsSkill.lua
--@brief	WndPetsSkill的UI模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物技能

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetsSkill:onEnter(element)
	  self.m_root = element
end

--@brief onEnter函数执行完成回调
function WndPetsSkill:onEnterTransitionDidFinish(element)
    -- WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
    self:actionCallback()
end

--@brief  窗口动画完成回调
function WndPetsSkill:actionCallback(elem,data)
    local data = CacheCenter:getGameParam()["petWashingNum"]
    WZLog("WndPetsSkill:actionCallback:", data)
    self.m_tPetDate[1],self.m_tPetDate[2] = SplitItemString(data)
    local data2 = CacheCenter:getGameParam()["petWashingLock"]
    self.m_tPetDate[3],self.m_tPetDate[4] = SplitItemString(data2)
    CacheCenter:registerUpatePlayerPetInfoObserver(self)
    CacheCenter:registerUpatePlayerItemObserver(self)
    self:showFight()
    self:setSkillInfo()
    self:showCurPetInfo()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetsSkill:onExit(element)
  	WZLog("WndPetsSkill:onExit")
  	self:_unInit()
  	CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
  	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
function WndPetsSkill:onCloseClick(element)
  	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
  	WndPets:doRefresh()
  	-- WindowManager:removeWindow(self.m_root, self, true)
  WndPetsSkill.m_root:removeFromParentAndCleanup(true)
end

--@brief  退出场景时被调用的函数
function WndPetsSkill:onTouchBegin(element,pt)
  	WZLog("WndPetsSkill:onTouchBegin")
  	if not WndTips:checkPointInBtn(pt) then
  		  WndTips:onCloseClick()
  	end
end

--@brief   反注册监听
function WndPetsSkill:unRegisterPetInfoObserver()
end

--@brief   注册监听
function WndPetsSkill:RegisterPetInfoObserver()
end


--@breif 显示宠物战力
function WndPetsSkill:showFight()
  local fight = WndPets:getCurPetFight()
  local qualification = WndPets:getCurPetQualification()

  local txtFight = GetElement(self.m_root,"txtFight_WndPetsSkill",WZUILabelTTF)
  CCNodePropertySetter:setValue(txtFight, "skewX", 10)
  local ftbFight = GetElement(self.m_root,"ftbFight_WndPetsSkill",WZUIFreeTextBox)
  local FIGHT_POWER1 = [[<A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]]
  ftbFight:setShowText(string.format(FIGHT_POWER1,fight))
  if ProjConfig.LANGUAGE == "vn" then
      ftbFight:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
      ftbFight:setScale(0.8)
    end
  local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPetsSkill",WZUILabelTTF)
  txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..qualification)
end

function WndPetsSkill:onShowAttribute(element)
  WndPets:showAttributeTips(element,self.m_root,1)
end

--@breif  展示当前宠物属性
function WndPetsSkill:showCurPetInfo()
    --名字
    local name = self.m_petInfo.name
    local advancedLevel = self.m_petInfo.advancedLevel
    local nameText = GetElement(self.m_root,"txtName_WndPetsSkill",WZUIFreeTextBox)
    WndPets:setPetName(self.m_petInfo.itemId, nameText, name, advancedLevel, false)
   
    -- --等级
    -- local lvtext = GetElement(self.m_root,"txtLv_WndPetsSkill",WZUILabelTTF)
    -- lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
    -- WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)
    
     --星星品质
    local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
    for i = 1, 7 do
        GetElement(self.m_root,"imgAptitude"..i.."_WndPetsSkill",WZUIImage):setVisible(i <= aptitude)
    end
    WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsSkill",aptitude)
    
    --动物动画
    local petImage = GetElement(self.m_root,"conPet1_WndPetsSkill",WZUIContainer)
    petImage:removeAllChildrenWithCleanup(true)
    self.petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation, advancedLevel)
    self:playAttackAni()
end

function WndPetsSkill:playAttackAni()
  local conPet = GetElement(self.m_root,"conPet1_WndPetsSkill",WZUIContainer)
  conPet:disableSchedule()
  
  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPetsSkill:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet1_WndPetsSkill",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end

function WndPetsSkill:getCost()
    local num = 0
    for i = 1, #self.n_tSkillId do
  	    local checkBox = GetElement(self.m_root,"lock"..(i*2),WZUICheckBox)
        if checkBox:getCheckIndex() == 1 then
          num = num +1
        end
    end
    self.locakNum = num
    return num
end

function WndPetsSkill:getCost567()
    local num = 0
    for i = 1, #self.n_tSkillId do
  	    local checkBox = GetElement(self.m_root,"lock"..(i*2-1),WZUICheckBox)
        if checkBox:getCheckIndex() == 1 then
          num = num +1
        end
    end
    return num
end

--@brief 设置技能洗练
function WndPetsSkill:setSkillInfo()
    WZLog("WndPetsSkill:setSkillInfo:",self.m_petInfo.skill)
    local skillId = {}
    skillId = SplitStringWithSeparator(self.m_petInfo.skill,"|")
    if #self.n_tSkillId < 1 then
        for i = 1, #skillId do
            local tab = GDatatab_skill["id_"..skillId[i]]
            tab.btnType = 1
            tab.uiTag = i
            table.insert(self.n_tSkillId, tab)
        end
    else
        for i =1, #self.n_tSkillId do
            WZLog("WndPetsSkill:setSkillInfo222:",self.n_tSkillId[i].id, skillId[i])
            if self.n_tSkillId[i].id ~= tonumber(skillId[i]) then
                local tab = GDatatab_skill["id_"..skillId[i]]
                tab.btnType = 1
                tab.uiTag = i
                self.n_tSkillId[i] = tab
                --self:_doSkillArm(i)
            end
        end
    end
    for i = 1, 5 do
        if i <= #self.n_tSkillId then
            self:setSkillList(i,self.n_tSkillId[i].id)
            GetElement(self.m_root,"imgLock"..i.."_WndPetSkill",WZUIImage):setVisible(false)
        else
            self:setSkillList(i,0)
        end
    end
    self:setHasGoods()
    self:setUseGoods()
    GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF):setText(self:getCost567().."/"..CacheCenter:getPlayerItemCountById(567))
    --self:_setView()
end

--@brief 设置技能洗练
function WndPetsSkill:setSkillList(nTag,nSkillId)
    WZLog("WndPetsSkill:setSkillList",nTag, nSkillId)
    --128，54，13
    --198，130，255
    local name = {LocalStrings.PETSKILL1, LocalStrings.PETSKILL2, LocalStrings.PETSKILL3, LocalStrings.PETSKILL4, LocalStrings.PETSKILL5}
    local desc = {LocalStrings.PETSKILLDESC1, LocalStrings.PETSKILLDESC2, LocalStrings.PETSKILLDESC3, LocalStrings.PETSKILLDESC4, LocalStrings.PETSKILLDESC5}
    local bool = nSkillId == 0
    if not bool then
        GetElement(self.m_root,"txtName"..nTag.."_WndPetsSkill",WZUILabelTTF):setText(self.n_tSkillId[nTag].name)
        GetElement(self.m_root,"txtLvK"..nTag.."_WndPetsSkill",WZUILabelTTF):setText(self.n_tSkillId[nTag].tool_desc)
        GetElement(self.m_root,"imgSkillP"..nTag.."_WndPetSkill",WZUIImage):setFile(self.n_tSkillId[nTag].icon)
        GetElement(self.m_root,"imgSkillLv"..nTag.."_WndPetSkill",WZUIImage):setFile(self.n_tSkillId[nTag].lv_icon)
    else
        GetElement(self.m_root,"txtName"..nTag.."_WndPetsSkill",WZUILabelTTF):setText(name[nTag])
        GetElement(self.m_root,"txtLvK"..nTag.."_WndPetsSkill",WZUILabelTTF):setText(desc[nTag])
    end
    GetElement(self.m_root,"imgLockIn"..nTag.."_WndPetSkill",WZUIImage):setVisible(bool)
    GetElement(self.m_root,"imgSkillP"..nTag.."_WndPetSkill",WZUIImage):setVisible(not bool)

    GetElement(self.m_root,"conLock"..nTag,WZUIContainer):setVisible(not bool)
end

--@brief 设置当前拥有材料的显示
function WndPetsSkill:setHasGoods()
    -- local txt = string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(104))
    -- GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF):setText(txt)
    -- local txt2 = string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(105))
    -- GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF):setText(txt2)
    -- local txt3 = string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(567))
    -- GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF):setText(txt3)
    GetElement(self.m_root,"imgCost3",WZUIImage):setFile(GDatatab_item["id_567"].icon)
    WZLog("WndPetsSkill:setHasGoods:",self.m_tPetDate[2],self.m_tPetDate[2][1])
    GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF):setText(self.m_tPetDate[2][1].."/"..CacheCenter:getPlayerItemCountById(104))
end

--@brief 设置当前消耗材料的显示
function WndPetsSkill:setUseGoods()
    local cost = self:getCost()
    GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF):setText(cost.."/"..CacheCenter:getPlayerItemCountById(105))
end

function WndPetsSkill:onClickSure(element)
    WZLog("dddddddddddd")
    local VansPriceID = WZLuaVector_int_:create()
    local lockLvID = WZLuaVector_int_:create()
    local checkBox
    for i = 1, #self.n_tSkillId do
  	    checkBox = GetElement(self.m_root,"lock"..(i*2),WZUICheckBox)
        if checkBox:getCheckIndex() == 1 then
            VansPriceID:push(i)
        end
  	    checkBox = GetElement(self.m_root,"lock"..(i*2-1),WZUICheckBox)
        if checkBox:getCheckIndex() == 1 then
            lockLvID:push(i)
        end
    end
    self.m_bISAlter = true
    local con = GetElement(self.m_root,"conRight_WndPetsUpgrade",WZUIContainer)
    con:enableSchedule("setAlter", 2)
    ProtocolProcessorScenePets:send_PET_ResetSkill(self.m_petInfo.playerPetId,VansPriceID,lockLvID)
end

--@brief	技能洗练
--@param	element:表绑定的UI节点引用
function WndPetsSkill:onSkillUpdate(element)
	if self.getCache == true then return end
	WZLog("WndPetsSkill:onSkillUpdate = ", self.m_bISAlter, self.m_petInfo.playerPetId,self.m_petSkillLockId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

  if self.m_bISAlter == true then
    return
  end
  -- local cost1 = tonumber(GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF):getText())
  if tonumber(CacheCenter:getPlayerItemCountById(104)) < tonumber(self.m_tPetDate[2][1])  then
    --checkIsOnSale(104)
	  WndFastGetItems:show(104)
    return
  end
  if tonumber(CacheCenter:getPlayerItemCountById(105)) < tonumber(self:getCost())  then
    --checkIsOnSale(105)
	WndFastGetItems:show(105)
    return
  end
  if tonumber(CacheCenter:getPlayerItemCountById(567)) < tonumber(self:getCost567())  then
    --checkIsOnSale(567)
	WndFastGetItems:show(567)
    return
  end
  local hasHighSkill = false
  local VansPriceID = WZLuaVector_int_:create()
  local lockLvID = WZLuaVector_int_:create()
  local checkBox
  for i = 1, #self.n_tSkillId do
	    checkBox = GetElement(self.m_root,"lock"..(i*2),WZUICheckBox)
      if checkBox:getCheckIndex() == 1 then
          VansPriceID:push(i)
      else
          if self.n_tSkillId[i].specialAttackParam > 3 then
            hasHighSkill = true
            break
          end
      end
	    checkBox = GetElement(self.m_root,"lock"..(i*2-1),WZUICheckBox)
      if checkBox:getCheckIndex() == 1 then
          lockLvID:push(i)
      end
  end
  if hasHighSkill then
      local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
      MsgBoxManager:showConfirmBoxWithBg(LocalStrings.PETSKILL_LOCK_ASK2, self, self.onClickSure, nil, tCustomUIConfig)
      return
  end
  self.m_bISAlter = true
  local con = GetElement(self.m_root,"conRight_WndPetsUpgrade",WZUIContainer)
  con:enableSchedule("setAlter", 2)

  WZLog("洗练宠物", Serialize(VectorToTable(VansPriceID)), Serialize(VectorToTable(lockLvID)))
	ProtocolProcessorScenePets:send_PET_ResetSkill(self.m_petInfo.playerPetId,VansPriceID,lockLvID)
end

function WndPetsSkill:setAlter() 
  	local con = GetElement(self.m_root,"conRight_WndPetsUpgrade",WZUIContainer)
    con:disableSchedule()
	
  	self.m_bISAlter = false
end

--更新商品购买后的界面显示
function WndPetsSkill:updatePlayerItemData()
  WZLog("WndPetsSkill:updatePlayerItemData")
  local txt = self.m_tPetDate[2][1].."/"..CacheCenter:getPlayerItemCountById(104)
  GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF):setText(txt)
  local cost = self:getCost()
  local txt2 = cost.."/"..CacheCenter:getPlayerItemCountById(105)
  GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF):setText(txt2)
  local txt3 = self:getCost567().."/"..CacheCenter:getPlayerItemCountById(567)
  GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF):setText(txt3)
end

--@brief  技能锁的id改变
--@param  element:表绑定的UI节点引用
function WndPetsSkill:onSiClick(element)
  WZLog("WndPetsSkill:onSiClick")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local tag = element:getTag()
  if tag > #self.n_tSkillId then
    return
  end
  local tData = self.n_tSkillId[tag]
   WndTips:show(element,self.m_root,24,tData,GlobalMethod:ccp(120,0),true)
end

--@brief  跳转至升级界面
--@param  element:表绑定的UI节点引用
function WndPetsSkill:onGotoUp(element)
  WZLog("WndPetsSkill:onGotoUp")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WndPets:onUpgradeClick()
  WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  跳转至升级界面
--@param  element:表绑定的UI节点引用
function WndPetsSkill:onGoToAdvance(element)
   WZLog("WndPetsSkill:onGotoUp")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WndPets:onEvolutionClick()
  WindowManager:removeWindow(self.m_root, self, true)
end


--@brief    更新洗炼按钮状态
function WndPetsSkill:updateBtnStats(nTag, bLock)
   GetElement(self.m_root,"imgBtn"..nTag.."_WndPetsSkill",WZUIImage):setVisible(bLock)
end


function WndPetsSkill:updatePlayerPetInfoData()
  WZLog("WndPetsSkill:updatePlayerPetInfoData")
  if self.m_petInfo == nil then
    return
  end
  if self.m_bISAlter == true then
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
    PopupResult("ui/pet/common_icon_lwcg.png",0.5,0.5)
  end
  WZLog("当前全部宠物", Serialize(CacheCenter:getPlayerPetInfo()))
  local tPet = CacheCenter:getPlayerPetInfo()
  if tPet == nil or #tPet == 0 then
    self.getCache = true
	ProtocolProcessorScenePets:send_PET_GetAllPetList()
	return
  end
  for k,v in pairs(CacheCenter:getPlayerPetInfo()) do
	  WZLog("当前宠物id", self.m_petInfo.playerPetId)
      if v.playerPetId == self.m_nPetId then
      --if v.playerPetId == self.m_petInfo.playerPetId then
		 WZLog("更新当前宠物信息")
         self:setPetInfo(v)
         self:setSkillInfo()
         break
      end
  end 
  	--播放特效
    for i =1, #self.n_tSkillId do
		local checkBox = GetElement(self.m_root,"lock"..(i*2),WZUICheckBox)
    	if checkBox:getCheckIndex() == 0 then
        	self:_doSkillArm(i)
		end
	end
  self.getCache = false
end

--@brief     洗炼技能成功
function WndPetsSkill:_doSkillArm(tag)
  WZLog("WndPetsSkill:_doSkillArm ",tag)
  local ani = GetElement(self.m_root,"arm"..tag.."_WndPetSkill",WZUISpine)
  ani:setVisible(true)
  ani:play("effectc",false)
  ani:enableSchedule("_anctionOver")
end

--@breif 指针开始结束
function WndPetsSkill:_anctionOver(element)
  WZLog("WndPetsSkill:_anctionOver:", element)
  local spine = WZUISpine:luaTo(element)
  if spine:isCurrentAnimationDone() then
    element:disableSchedule()
    element:setVisible(false)
    self.m_bISAlter = false
  end 
end

--@brief     洗炼技能成功
function WndPetsSkill:_changeSkillOk(playerPetId,commonSkill1,commonSkill2)
    WZLog("WndPetsSkill:_changeSkillOk ",playerPetId,commonSkill1,commonSkill2)
    self.m_bISAlter = false
end

--@brief  宠物技能洗练失败
function WndPetsSkill:changeSkillError()
   self.m_bISAlter = false
   if self.m_bISAlter == true then
       MsgBoxManager:showTipBox(LocalStrings.CHANGE_PET_SKILL_ERROR)
   end
end

--@brief  宠物说明按钮点击事件 
function WndPetsSkill:onDescription( element )
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  	WndSingleMapDesc:showInterface1(LocalStrings.PETSKILL_DES)
end

--@brief	锁住技能或者等级
function WndPetsSkill:onLock(element) 
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  	local tag = element:getTag()	
  	local checkBox = GetElement(self.m_root,"lock"..tag,WZUICheckBox)
  	WZLog("WndPetsSkill:onLock", tag)
  	local tData = self.n_tSkillId[math.ceil(tag/2)]
  	if tag%2 == 0 then
  		  GetElement(self.m_root,"lock"..(tag-1),WZUICheckBox):setCheckIndex(0)
  	elseif tag%2 == 1 then
  		  GetElement(self.m_root,"lock"..(tag+1),WZUICheckBox):setCheckIndex(0)
  	end

  	self.m_nCheckTag = tag
  	self.m_root:enableSchedule("onLockCall",0)
end

function WndPetsSkill:onLockCall() 
	self.m_root:disableSchedule()

	local tag = self.m_nCheckTag
	local checkBox = GetElement(self.m_root,"lock"..tag,WZUICheckBox)
	if math.ceil(tag/2) > #self.n_tSkillId then
		checkBox:setCheckIndex(0)
	end
	if tag%2 == 0 and self:getCost() >= #self.n_tSkillId then
		checkBox:setCheckIndex(0)
		MsgBoxManager:showTipBox(LocalStrings.PETLOCK3)
	end

	local cost = self:getCost()
  	GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF):setText(cost.."/"..CacheCenter:getPlayerItemCountById(105))
	GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF):setText(self:getCost567().."/"..CacheCenter:getPlayerItemCountById(567))
  	local bool = self.locakNum >= #self.n_tSkillId
  	WZLog("WndPetsSkill:doLock:", self.locakNum, #self.n_tSkillId,bool)
  	GetElement(self.m_root, "btnSkill_WndPetsSkill",WZUIButton):setTouchEnable(not bool)
end

--@brief    点击转移按钮回调
function WndPetsSkill:onSkillTransfer(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- WndPetSkillTransfer:showInterface(self.m_petInfo)
    local con = GetElement(self.m_root,"conConter_WndPetsSkill",WZUIContainer)
    local wndtemp = WndPetSkillTransfer:createElement()
    WndPetSkillTransfer:setPetInfo(self.m_petInfo)
    con:addChild(wndtemp)
    WndPetsSkill:showPetsSkillMainUI(false)
end

--@brief    点击消耗物回调
function WndPetsSkill:onClickCost(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  local tData = {}
  local tag = element:getTag()
  if tag == 1 then
    tData.id = 104
  elseif tag == 2 then
    tData.id = 105
  elseif tag == 3 then
    tData.id = 567
  end
    
  WndItemInfo:showInfo(element, self.m_root, 1, tData, false, nil, true)

end

--@brief    点击消耗物回调
function WndPetsSkill:showPetsSkillMainUI(bShow)
    local conMain = GetElement(self.m_root,"conMain_WndPetsSkill",WZUIContainer)
    if conMain then
        conMain:setVisible(bShow)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  设置是否显示技能消耗界面
function WndPetsSkill:_setView()
  WZLog("WndPetsSkill:_setView")
  local bool = self.n_skillNum < 1
  GetElement(self.m_root,"conNoShow_WndPetsSkill",WZUIContainer):setVisible(bool)
  GetElement(self.m_root,"conShow_WndPetsSkill",WZUIContainer):setVisible(not bool)
end

-------------------------------------私有方法模块End----------------------------------------
----------------------------------------语言适配Begin------------------------------------
function WndPetsSkill:_adaptLanguage_vn(  )
    for i=1, 5 do
        local txtName = GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF)
        --txtName:setRelativePosition(GlobalMethod:ccp(0.2,0.785))
        txtName:setFontSize(14)
        local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
        txtLvK:setFontSize(14)
        --txtLvK:setRelativePosition(GlobalMethod:ccp(0.2,0.3))
    end

    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.8)
    txtLvE2:setRelativePosition(GlobalMethod:ccp(0.21,0.46))
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.8)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.24,0.46))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.8)
    txtLvE3:setRelativePosition(GlobalMethod:ccp(0.54,0.46))
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.8)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.545,0.46))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.8)
    txtLvE6:setRelativePosition(GlobalMethod:ccp(0.855,0.46))
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.8)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.86,0.46))
end

function WndPetsSkill:_adaptLanguage_pt(  )
    for i=1,3 do
        GetElement(self.m_root,"txtSkill"..i.."_WndPetsSkill",WZUILabelTTF):setScale(0.8)
    end

    for i = 1, 10 do
      GetElement(self.m_root,"txtLock"..i.."_WndPetSkill",WZUILabelTTF):setScale(0.65)
    end

    GetElement(self.m_root,"imgLeftArrow_WndPetsSkill",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    GetElement(self.m_root,"imgRightArrow_WndPetsSkill",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.73,0.5))

    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.7)
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.7)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.21,0.46))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.7)
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.7)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.52,0.46))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.7)
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.7)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.82,0.46))

  for i = 1, 5 do
      GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.785))
      local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
      txtLvK:setFontSize(13)
  end
end

function WndPetsSkill:_adaptLanguage_es(  )
    for i=1, 5 do
        GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.785))
        local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
        txtLvK:setFontSize(14)
    end
    GetElement(self.m_root,"txtNoSkillDesc_WndPetsSkill",WZUILabelTTF):setFontSize(20)

    GetElement(self.m_root,"txtSkill1_WndPetsSkill",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtSkill2_WndPetsSkill",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtSkill3_WndPetsSkill",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtLvE1_WndPetsUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.177273,0.5))
    GetElement(self.m_root,"imgE1_WndPetsSkill",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.211364,0.5))
    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.7)
    txtLvE2:setRelativePosition(GlobalMethod:ccp(0.258182,0.46))
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.7)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.275455,0.46))
    GetElement(self.m_root,"imgE2_WndPetsSkill",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.472727,0.5))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.7)
    txtLvE3:setRelativePosition(GlobalMethod:ccp(0.532728,0.46))
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.7)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.542272,0.46))
    GetElement(self.m_root,"imgE3_WndPetsSkill",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.745455,0.5))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.7)
    txtLvE6:setRelativePosition(GlobalMethod:ccp(0.800909,0.46))
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.7)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.805909,0.46))
    
end

function WndPetsSkill:_adaptLanguage_th(  )
    for i=1, 5 do
        GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.785))
        local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
        txtLvK:setRelativePosition(GlobalMethod:ccp(0.2,0.34))
        txtLvK:setDimensions(GlobalMethod:CCSize(230,42))
    end

    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.8)
    txtLvE2:setRelativePosition(GlobalMethod:ccp(0.21,0.46))
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.8)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.24,0.46))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.8)
    txtLvE3:setRelativePosition(GlobalMethod:ccp(0.54,0.46))
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.8)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.545,0.46))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.8)
    txtLvE6:setRelativePosition(GlobalMethod:ccp(0.855,0.46))
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.8)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.86,0.46))
end

function WndPetsSkill:_adaptLanguage_en(  )
  for i=1, 10 do
    GetElement(self.m_root,"txtLock"..i.."_WndPetSkill",WZUILabelTTF):setScale(0.5)
  end

    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.65)
    txtLvE2:setRelativePosition(GlobalMethod:ccp(0.21,0.46))
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.65)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.24,0.46))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.65)
    txtLvE3:setRelativePosition(GlobalMethod:ccp(0.54,0.46))
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.65)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.545,0.46))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.65)
    txtLvE6:setRelativePosition(GlobalMethod:ccp(0.855,0.46))
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.65)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.86,0.46))

  for i=1, 5 do
      local txtName = GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF)
      txtName:setFontSize(14)
      local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
      txtLvK:setFontSize(14)
  end
  local txtNoSkillDesc = GetElement(self.m_root,"txtNoSkillDesc_WndPetsSkill",WZUILabelTTF)
  txtNoSkillDesc:setScale(0.8)
end

function WndPetsSkill:_adaptLanguage_tr(  )
    for i=1,3 do
        GetElement(self.m_root,"txtSkill"..i.."_WndPetsSkill",WZUILabelTTF):setScale(0.8)
    end

    for i=1, 10 do
      local txtLock = GetElement(self.m_root,"txtLock"..i.."_WndPetSkill",WZUILabelTTF)
      txtLock:setScale(0.62)
      txtLock:setDimensions(GlobalMethod:CCSize(80))
    end

    GetElement(self.m_root,"imgLeftArrow_WndPetsSkill",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    GetElement(self.m_root,"imgRightArrow_WndPetsSkill",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.73,0.5))

    local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
    txtLvE2:setScale(0.7)
    local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
    txtLvE4:setScale(0.7)
    txtLvE4:setRelativePosition(GlobalMethod:ccp(0.21,0.46))
    local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
    txtLvE3:setScale(0.7)
    local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
    txtLvE5:setScale(0.7)
    txtLvE5:setRelativePosition(GlobalMethod:ccp(0.52,0.46))
    local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
    txtLvE6:setScale(0.7)
    local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
    txtLvE7:setScale(0.7)
    txtLvE7:setRelativePosition(GlobalMethod:ccp(0.82,0.46))

  for i=1, 5 do
      GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.785))
      local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
      txtLvK:setFontSize(13)
  end
  local txtNoSkillDesc = GetElement(self.m_root,"txtNoSkillDesc_WndPetsSkill",WZUILabelTTF)
  txtNoSkillDesc:setScale(0.5)
  txtNoSkillDesc:setDimensions(GlobalMethod:CCSize(800))
end

function WndPetsSkill:_adaptLanguage_ug(  )
  for i=1,8 do
    local txtLock = GetElement(self.m_root,"txtLock"..i.."_WndPetSkill",WZUILabelTTF)
    txtLock:setScale(0.4)
    txtLock:setDimensions(GlobalMethod:CCSize(160))
  end
  for i=1,4 do
    local txtName = GetElement(self.m_root,"txtName"..i.."_WndPetsSkill",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtName:setRelativePosition(GlobalMethod:ccp(0.46,0.8))
    local txtLvK = GetElement(self.m_root,"txtLvK"..i.."_WndPetsSkill",WZUILabelTTF)
    txtLvK:setFontSize(18)
    txtLvK:setScale(0.7)
    txtLvK:setDimensions(GlobalMethod:CCSize(360))
    txtLvK:setRelativePosition(GlobalMethod:ccp(0.17,0.355))
    txtLvK:setAlignment(kCCTextAlignmentCenter)
  end
  local txtNoSkillDesc = GetElement(self.m_root,"txtNoSkillDesc_WndPetsSkill",WZUILabelTTF)
  txtNoSkillDesc:setScale(0.5)
  txtNoSkillDesc:setDimensions(GlobalMethod:CCSize(600))
  GetElement(self.m_root,"txtNoSkillDesc2_WndPetsSkill",WZUILabelTTF):setScale(0.8)

  local txtLvE1 = GetElement(self.m_root,"txtLvE1_WndPetsUpgrade",WZUILabelTTF)
  txtLvE1:setScale(0.6)
  txtLvE1:setRelativePosition(GlobalMethod:ccp(1.00682,0.5))
  local imgE1 = GetElement(self.m_root,"imgE1_WndPetsSkill",WZUIContainer)
  imgE1:setScale(0.4)
  imgE1:setRelativePosition(GlobalMethod:ccp(0.81091,0.5))
  local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsSkill",WZUILabelTTF)
  txtLvE2:setScale(0.6)
  txtLvE2:setRelativePosition(GlobalMethod:ccp(0.767727,0.46))
  local txtLvE4 = GetElement(self.m_root,"txtLvE4_WndPetsSkill",WZUILabelTTF)
  txtLvE4:setScale(0.6)
  txtLvE4:setRelativePosition(GlobalMethod:ccp(0.74591,0.46))
  txtLvE4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  local imgE2 = GetElement(self.m_root,"imgE2_WndPetsSkill",WZUIContainer)
  imgE2:setScale(0.6)
  imgE2:setRelativePosition(GlobalMethod:ccp(0.525001,0.5))
  local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsSkill",WZUILabelTTF)
  txtLvE3:setScale(0.6)
  txtLvE3:setRelativePosition(GlobalMethod:ccp(0.485001,0.46))
  local txtLvE5 = GetElement(self.m_root,"txtLvE5_WndPetsSkill",WZUILabelTTF)
  txtLvE5:setScale(0.6)
  txtLvE5:setRelativePosition(GlobalMethod:ccp(0.462727,0.46))
  txtLvE5:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  local imgE3 = GetElement(self.m_root,"imgE3_WndPetsSkill",WZUIContainer)
  imgE3:setScale(0.4)
  imgE3:setRelativePosition(GlobalMethod:ccp(0.225,0.5))
  local txtLvE6 = GetElement(self.m_root,"txtLvE6_WndPetsSkill",WZUILabelTTF)
  txtLvE6:setScale(0.6)
  txtLvE6:setRelativePosition(GlobalMethod:ccp(0.185909,0.46))
  local txtLvE7 = GetElement(self.m_root,"txtLvE7_WndPetsSkill",WZUILabelTTF)
  txtLvE7:setScale(0.6)
  txtLvE7:setRelativePosition(GlobalMethod:ccp(0.163182,0.46))
  txtLvE7:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  
end
---------------------------------------语言适配End---------------------------------------