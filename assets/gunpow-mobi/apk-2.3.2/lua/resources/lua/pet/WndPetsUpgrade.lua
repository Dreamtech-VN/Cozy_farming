--WndPetsUpgrade.lua
--@brief	WndPetsUpgrade的UI模块
--@date		2015/03/31
--@author	qixiang_xie 
--@note		宠物升级
-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作

function WndPetsUpgrade:onEnter(element)
   WZLog("WndPetsUpgrade:onEnter")
   self.m_root = element
   AdaptLanguage(self)
   local ani = GetElement(self.m_root,"armAddStar_WndPetsUpgrade",WZArmature)
   ani:setAnimationFinishLuaFunction("armAddStarFinish")
   CacheCenter:registerUpatePlayerPetInfoObserver(self) 
end

-- 进阶动画播放完毕
function WndPetsUpgrade:armAddStarFinish()
    local ani = GetElement(self.m_root,"armAddStar_WndPetsUpgrade",WZArmature)
    ani:setVisible(false)
end

-- 播放动画1
function WndPetsUpgrade:playAddStarAndUpdateAni(tag)
    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ISUPGRADE)
    local aniUp = GetElement(self.m_root,"armAddStar_WndPetsUpgrade",WZArmature)
    aniUp:setVisible(true)
    local armature = aniUp:getArmature()
    armature:getAnimation():playByIndex(tag,-1,-1,0)
end

--@brief onEnter函数执行完成回调
function WndPetsUpgrade:onEnterTransitionDidFinish(element)
    -- WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
    self:actionCallback()
end

--@brief  窗口动画完成回调
function WndPetsUpgrade:actionCallback(elem,data)
    -- 初始化邮件系统
   self.n_curFighting = self.m_petInfo.fighting
   self:setPetExpInfo(self.m_petInfo)
   self:showPetInfo()
   --动物动画
  local petImage = GetElement(self.m_root,"conPet1_WndPetsUpgrade",WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  self.petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation, self.m_petInfo.advancedLevel)
  self:playAttackAni()
  --petAni:getAnimNode():setScale(1.5)    
end

function WndPetsUpgrade:playAttackAni()
  local conPet = GetElement(self.m_root,"conPet1_WndPetsUpgrade",WZUIContainer)
  conPet:disableSchedule()
  
  self.petAni:play("attack",false)
  conPet:enableSchedule("_updateWaitAni")
end

function WndPetsUpgrade:_updateWaitAni(element)
  local isEnd = self.petAni:isCurrentAnimationDone()
  if isEnd then
    local conPet = GetElement(self.m_root,"conPet1_WndPetsUpgrade",WZUIContainer)
    conPet:disableSchedule()
    self.petAni:play("wait",true)
  end
end

--@brief  初始化宠物列表
function WndPetsUpgrade:setPetList()
    if self.b_Up then
        self.b_Up = false
        return
    end
    WZLog("WndPetsUpgrade:setPetList")
    self.m_bIsAlter = false
    local tableList = GetElement(self.m_root,"conPetList_WndPetsUpgrade",WZUITableContainer)
    if tableList == nil then
        return
    end
    tableList:cleanTable()
    local pets = self:findMatchPets()
    GetElement(self.m_root,"conNoPet_WndPetsUpgrade",WZUIContainer):setVisible(#pets <= 0)
    if #pets <= 0 then
        return
    end
    local addNum = 0
    local expPet = {}
    --添加不同经验宠物类型的判断
    for i = 1, #pets do
      	if WndPets:isExpPet(pets[i].itemId) then
            local bAdd = true
            --检测该经验宠物是否添加过
            for j =1, #expPet do
          		  if expPet[j].itemId == pets[i].itemId then
                    bAdd = false
                    break
                end
            end
            if bAdd then
                table.insert(expPet, pets[i])
        		end
      	end
    end
    -- WZLog("addPetList:", addNum)
    -- WZLog("添加经验宝宝",Serialize(expPet))
    self.m_tMatchList = {}
    --添加经验宝宝
    for i = 1, #expPet do
        -- WZLog("addPetList:", expPet[i].num)
        -- for j = 1, expPet[i].num do
        --     if addNum < 100 then
        --         local celElement, tCell = CellPetSell:createElement()
        --         celElement = WZUIContainer:luaTo(celElement)
        --         celElement:setTag(addNum)
        --         tCell:setData(expPet[i], 1)
        --         tableList:setCellElement(celElement)
        --         table.insert(self.m_tMatchList,tCell)

        --         addNum = addNum + 1
        --     else
        --         break
        --     end
        -- end
            if addNum < 100 then
              WZLog("经验宠物的标记",addNum)
                local celElement, tCell = CellPetSell:createElement()
                celElement = WZUIContainer:luaTo(celElement)
                celElement:setTag(addNum)
                tCell:setData(expPet[i], 1, expPet[i].num,addNum)
                tableList:setCellElement(celElement)
                table.insert(self.m_tMatchList,tCell)

                addNum = addNum + 1
            else
                break
            end
    end
    WZLog("addPetList2:",addNum) 
    for i=1,#pets do
        if addNum < 100 then
            if not WndPets:isExpPet(pets[i].itemId) then
                local celElement, tCell = CellPetSell:createElement()
                celElement = WZUIContainer:luaTo(celElement)
                celElement:setTag(addNum)
                tCell:setData(pets[i], 1)
                tableList:setCellElement(celElement)
                table.insert(self.m_tMatchList,tCell)

                addNum = addNum + 1
            end
        else
            break
        end
    end
    
    tableList:getMoveElement():setPositionY(tableList:getMinPosition().y)
end

--@brief 改变选择经验宠物个数
function WndPetsUpgrade:changePetNum(num,tag,data)
    -- body
    -- WZLog("改变选择的经验宠物个数",num,tag,data.num)
    local tCell = self.m_tMatchList[tag+1]
    WZLog("改变选择的经验宠物个数",Serialize(data),Serialize(tCell.m_tData))
    self:addChoiceExpPet(true,tag,tCell,num)
    tCell:changePetNum(num,data)
    tCell:setSelected(true)
end

--@brief   展示宠物基本信息
function WndPetsUpgrade:showPetInfo()
	WZLog("WndPetsUpgrade:showPetInfo")
	self:showCurPetInfo()
	self:showNextPetInfo()
  self:_initUseData()
  self:setPetList() 
  self:showFight()
end

--@breif 显示宠物战力
function WndPetsUpgrade:showFight()
  local fight = WndPets:getCurPetFight()
  local qualification = WndPets:getCurPetQualification()

  local txtFight = GetElement(self.m_root,"txtFight_WndPetsUpgrade",WZUILabelTTF)
  CCNodePropertySetter:setValue(txtFight, "skewX", 10)
  -- local ftbFight = GetElement(self.m_root,"ftbFight_WndPetsUpgrade",WZUIFreeTextBox)
  -- ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER1,fight))
  local txtPetQualification = GetElement(self.m_root,"txtPetQualification_WndPetsUpgrade",WZUILabelTTF)
  txtPetQualification:setText(LocalStrings.PETINTELLIGENCE..qualification)
end

--查看宠物属性
function WndPetsUpgrade:onShowAttribute(element)
  WndPets:showAttributeTips(element,self.m_root,1)
end

--@breif  展示当前宠物属性
function WndPetsUpgrade:showCurPetInfo()
  if not self.m_petInfo then return end

   --名字
  local name = self.m_petInfo.name or ""
  local advancedLevel = self.m_petInfo.advancedLevel or 0
  local nameText = GetElement(self.m_root,"txtName_WndPetsUpgrade",WZUIFreeTextBox)
  WndPets:setPetName(self.m_petInfo.itemId, nameText, name, advancedLevel, false, self.m_petInfo.upgradeLevel)
  --nameText:setText(name)
 
  -- --等级
  -- local lvtext = GetElement(self.m_root,"txtLv_WndPetsUpgrade",WZUILabelTTF)
  -- lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
  -- WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)
  
  --经验
  self:setShowExp(self.m_petInfo.upgradeLevel, self.m_petInfo.petExp)

   --星星品质
  local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill or 0)
  for i = 1, 7 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetsUpgrade",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsUpgrade",aptitude)
  
  if self.m_petInfo.property then
    --属性
    local petProperty = self.m_petInfo.property
    local petJ =  json.decode(petProperty)
    local petHP = petJ["1"]
    local petAttack = petJ["3"]
    local petDefense = petJ["4"]
    GetElement(self.m_root,"txtPetWarD_WndPetsUpgrade",WZUILabelAtlasFont):setText(self.m_petInfo.fighting)
    GetElement(self.m_root,"txtPetEPD1_WndPetsUpgrade",WZUILabelTTF):setText("Lv"..self.m_petInfo.upgradeLevel)
    GetElement(self.m_root,"txtPetHPD1_WndPetsUpgrade",WZUILabelTTF):setText(petHP)
    GetElement(self.m_root,"txtPetAPD1_WndPetsUpgrade",WZUILabelTTF):setText(petAttack)
    GetElement(self.m_root,"txtPetDPD1_WndPetsUpgrade",WZUILabelTTF):setText(petDefense)
  end
end

--@breif  展示当前宠物属性
function WndPetsUpgrade:showNextPetInfo(_addLv) 
  if not self.m_petInfo or not self.m_petInfo.itemId then return end

  local rate = 0
  local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
  local id =  quality < 4 and self.m_petInfo.itemId or self.m_petInfo.itemId -20000
  for k,v in pairs(GDatatab_pet_advanced) do
    if v.item_id == id and v.level == math.min((self.m_petInfo.advancedLevel),7) then
      rate = (v.property_rate)/10000
      break
    end
  end
 local addLv = _addLv or 0
  --属性
  local petProperty = self.m_petInfo.property
  local petJ =  json.decode(petProperty)
  local aa = GDatatab_item["id_"..self.m_petInfo.itemId].property
  local bb = {}
  local level = self.m_petInfo.upgradeLevel + addLv
  for  k,v in pairs(GDatatab_pet) do
      if v.item_id == self.m_petInfo.itemId then
          bb = v.property
          break
      end
  end
  local petHP = math.floor(aa[1][2]+bb[1][2]/100*level)
  petHP =  petHP + math.ceil(petHP*rate)
  local petAttack = math.floor(aa[2][2]+bb[2][2]/100*level)
  petAttack =  petAttack + math.ceil(petAttack*rate)
  local petDefense = math.floor(aa[3][2]+bb[3][2]/100*level)
  petDefense =  petDefense + math.ceil(petDefense*rate)
  --加上羁绊属性
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
  GetElement(self.m_root,"txtPetEPD2_WndPetsUpgrade",WZUILabelTTF):setText(addLv)
  GetElement(self.m_root,"txtPetHPD2_WndPetsUpgrade",WZUILabelTTF):setText(petHP)
  GetElement(self.m_root,"txtPetAPD2_WndPetsUpgrade",WZUILabelTTF):setText(petAttack)
  GetElement(self.m_root,"txtPetDPD2_WndPetsUpgrade",WZUILabelTTF):setText(petDefense)
end

--@brief 设置宠物经验进度条
function WndPetsUpgrade:setShowExp(lv, exp, nextExp)
   if nextExp == nil then
      nextExp = self:getMaxExp(lv)
   end
   if lv < tonumber(CacheCenter:getGameParam().gameMaxLevel) then
      local petExp = exp
      GetElement(self.m_root,"txtLvExp_WndPetsUpgrade",WZUILabelTTF):setText(petExp.."/"..nextExp)
      local percent = math.min((petExp/nextExp) * 100, 100)
      GetElement(self.m_root,"ipgPetExp_WndPetsUpgrade",WZUIProgress):setPercentage(percent)
   else
     GetElement(self.m_root,"txtLvExp_WndPetsUpgrade",WZUILabelTTF):setText("MAX")
     GetElement(self.m_root,"ipgPetExp_WndPetsUpgrade",WZUIProgress):setPercentage(100)
   end    
end

--@brief 获得当前等级宠物升级经验
--@brief lv宠物当前等级
function WndPetsUpgrade:getMaxExp(lv)
  for  k,v in pairs(GDatatab_pet_upgrade) do
    if v.quality == GDatatab_item["id_"..self.m_petInfo.itemId].quality and v.level ==  lv then
        return v.exp
    end
  end
end

--@brief  设置当前经验值
function WndPetsUpgrade:setCurExp()
  	WZLog("WndPetsUpgrade:setCurExp")
  	local num = ""..self.n_addExp
  	local level = self.n_curLv
  	local level2 = level -1
  	local allExp = self.n_curExp + self.n_addExp
  	local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
  	if level2 > 0 then
  		allExp = allExp + tonumber(self:_getTotalExp(level2, quality).total_exp)
  	end
  	while (allExp >= tonumber(self:_getTotalExp(level, quality).total_exp)) do
  		level = level + 1
  	end
  	WZLog("WndPetsUpgrade:setCurExp:",level, self.n_addExp)
  	self:showNextPetInfo(level - level2 - 1)
  	GetElement(self.m_root,"txtLvE2_WndPetsUpgrade",WZUILabelTTF):setText(math.floor(self.n_addExp))
  	GetElement(self.m_root,"txtLvE3_WndPetsUpgrade",WZUILabelTTF):setText(self.n_addExp)
    GetElement(self.m_root, "txtChooseNum_WndPetsUpgrade", WZUILabelTTF):setText(self.n_choiceNum .. "/" .. self.m_nMaxNum)
end

--@brief 判断是否已经溢出经验
--@param bShow 是否提示溢出消息
--@param isQuickChooice 是否一键选择溢出消息
--@param bLevelAddBtn 是否屏蔽数量判断
--@return 溢出为true，否则为false
function WndPetsUpgrade:checkExpSpill(bShow,isQuickChooice, bWithoutMax)
  	WZLog("WndPetsUpgrade:checkExpSpill")
  	if bShow == nil then
  		  bShow = true
  	end
  	local fullPets = true
  	local num = -1
  	for i = 1, self.m_nMaxNum do
      	if self.m_tUsePet[i] == nil then
        		fullPets = false
        		num = i
        		break
     		end
    end
    if not bWithoutMax then 
      	if fullPets then 
            if bShow then
        		  MsgBoxManager:showTipBox(LocalStrings.PETENOUGHNUM)
            end
        		return true
      	end
    end
  	local bool = self.n_addExp  >= self.n_nextExp
  	WZLog("WndPetsUpgrade:checkExpSpill", self.n_nextExp, self.n_addExp)
    --判断等级,当经验溢出的时候，宠物依然能吃经验
    if CacheCenter:getPlayerInfo().level > self.m_petInfo.upgradeLevel then
        WZLog("AAAAAAAAAAAAAAAAAA")
        if not isQuickChooice then --快速选择则不让选取了
            bool = false
        else
            if bool then
                MsgBoxManager:showTipBox(LocalStrings.PETEXPFULL)
            end
        end 
    else
        if self.n_nextExp <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
            return bool
        end
    end
  	if bool and bShow then
  		  MsgBoxManager:showTipBox(LocalStrings.PETENOUGHEXP)
  	end
  	return bool, num
end

--@brief 根据选择的宠物添加经验
--@param petInfo: 宠物的信息
--@param bAdd：是添加还是删除
--@param nExp: 宠物的经验
function WndPetsUpgrade:setPetExp(petInfo, bAdd, nExp, num)
  	WZLog("WndPetsUpgrade:setPetExp:", bAdd, nExp,num)
  	if bAdd then
        if num ~=nil and num > 1 then
            for i = 1, num do
                self.n_addExp = self.n_addExp + nExp
          		  self.n_choiceNum = self.n_choiceNum + 1
                table.insert(self.m_tPets, petInfo)
            end
        else 
            self.n_addExp = self.n_addExp + nExp
            self.n_choiceNum = self.n_choiceNum + 1
            table.insert(self.m_tPets,petInfo)
        end
  	else
        if num ~= nil and num > 1 then
            for i = 1, num do
                self.n_addExp = self.n_addExp - nExp
          		  self.n_choiceNum = math.max((self.n_choiceNum - 1), 0)
                for i = 1, #self.m_tPets do
                    if self.m_tPets[i].playerPetId == petInfo.playerPetId then
                        table.remove(self.m_tPets, i)
                        break
                    end
                end 
            end
        else 
            self.n_addExp = math.max((self.n_addExp - nExp), 0)
            self.n_choiceNum = math.max((self.n_choiceNum - 1), 0)
        		for i = 1, #self.m_tPets do
          			if self.m_tPets[i].playerPetId == petInfo.playerPetId then
                    table.remove(self.m_tPets, i)
              			break
          			end
        		end 
        end
        
  	end
  	self:setCurExp()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetsUpgrade:onGoGet(element)
	WZLog("WndPetsUpgrade:onGoGet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- local wndPetRaffle = WndPetRaffle:createElement()
 --    WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
  WndSummonEntrance:showInterface(2)
    -- WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetsUpgrade:onGetWar(element)
	WZLog("WndPetsUpgrade:onGetWar")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	replaceScene(SceneCopy:createElement())
	SceneCopy:showScene(3)
    SceneCopy:setBackSceneLuaObj(WndPets)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetsUpgrade:onCloseClick(element)
	WZLog("WndPetsUpgrade:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
  WndPets:doRefresh()
	-- WindowManager:removeWindow(self.m_root, self, true)
  WndPetsUpgrade.m_root:removeFromParentAndCleanup(true)
	-- WndPets:setCon()
 --    self:_cleanDate()
end

--去获取宠物
function WndPetsUpgrade:onGetPet(element)
  WZLog("WndPetsUpgrade:onGetPet")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  -- local wndPetRaffle = WndPetRaffle:createElement()
  -- WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
  WndSummonEntrance:showInterface(2)
end

--@brief 检测是否还有选取栏可以选取宠物
function WndPetsUpgrade:addChoicePet(bAdd,nTag,cell,num)
    WZLog("WndPetsUpgrade:addChoicePet:",bAdd, nTag, cell)
    WZLog("检测是否还有选取栏可以选取宠物",cell.m_tData.num)
    if bAdd then
        self.m_tUsePet[nTag] = {}
        self.m_tUsePet[nTag] = cell
        local nOtherValue = self:getExpPetExp(cell.m_tData)
        self:setPetExp(cell.m_tData, true, nOtherValue, num)
    else
        local nOtherValue = self:getExpPetExp(cell.m_tData)
        self:setPetExp(cell.m_tData, false, nOtherValue, num)
        if nTag then 
            self.m_tUsePet[nTag] = nil
        else
            for i= 1, #self.m_tUsePet do
                if self.m_tUsePet[i] == cell then 
                    self.m_tUsePet[i] = nil 
                end
            end
        end
    end 
end

--@brief	一键选择
--@param	element:表绑定的UI节点引用
function WndPetsUpgrade:onPetChoiceClick(element)
  	WZLog("WndPetsUpgrade:onPetChoiceClick", #self.m_tMatchList)
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local playerLv = CacheCenter:getPlayerInfo().level
    if playerLv <= self.n_curLv then
        MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
        return 
    end
    if self.n_choiceNum and self.n_choiceNum >= self.m_nMaxNum then return end 
    local bNeedTips = true  --是否需要提示都是高星宠物
    if #self.m_tMatchList < 1 then
        bNeedTips = false
        self:_setChoiceViewState(true)
        MsgBoxManager:showTipBox(LocalStrings.PETNOUPEXP)
    end
    local count = 0
    local count1 = 0
    local temp_count= 0
    local leftNum = self.m_nMaxNum - self.n_choiceNum
    for i=1,#self.m_tMatchList do
--        WZLog("self.m_tMatchList[i].itemId.....: ",i,self.m_tMatchList[i].m_tData.itemId)
        if self.m_tMatchList[i].m_tData.itemId == 11000 then
            local chooseNum = self.m_tMatchList[i]:getChooseNum()
            count = self.m_tMatchList[i].num - chooseNum 
            if count > 0 and leftNum > 0 then
                if count >= leftNum then 
                    self.m_tMatchList[i]:dochoiceRecover(leftNum, true)
                    self.m_tMatchList[i]:setSelected(true)
                    self.m_tMatchList[i]:changePetNum(leftNum + chooseNum, self.m_tMatchList[i].m_tData)
                    leftNum = 0
                    bNeedTips = false
                    break
                else
                    self.m_tMatchList[i]:dochoiceRecover(count, true)
                    self.m_tMatchList[i]:setSelected(true)
                    self.m_tMatchList[i]:changePetNum(self.m_tMatchList[i].num, self.m_tMatchList[i].m_tData)          
                    leftNum = leftNum - count
                    bNeedTips = false
                end
            end
            temp_count = temp_count + 1
        elseif self.m_tMatchList[i].m_tData.itemId == 11007 then
            local chooseNum = self.m_tMatchList[i]:getChooseNum()
            count1 = self.m_tMatchList[i].num - chooseNum
            if count1 > 0 and leftNum > 0 then
                if count1 >= leftNum then 
                    self.m_tMatchList[i]:dochoiceRecover(leftNum, true)
                    self.m_tMatchList[i]:setSelected(true)
                    self.m_tMatchList[i]:changePetNum(chooseNum + leftNum, self.m_tMatchList[i].m_tData) 
                    leftNum = 0
                    bNeedTips = false                  
                    break 
                else 
                    self.m_tMatchList[i]:dochoiceRecover(count1, true)
                    self.m_tMatchList[i]:setSelected(true)
                    self.m_tMatchList[i]:changePetNum(self.m_tMatchList[i].num,self.m_tMatchList[i].m_tData)
                    leftNum = leftNum - count1 
                    bNeedTips = false                  
                end                          
            end
            temp_count = temp_count + 1
        end 
    end

    for i = 1 + temp_count, temp_count + leftNum do
        if self.m_tMatchList[i] and not self.m_tMatchList[i]:getSelectedState()  then 
            local bool, nTag = self:checkExpSpill(false,true)
            if bool then 
                return 
            else
                if self.m_tMatchList[i]:doQuickRecover() == true then 
                    bNeedTips = false
                end
            end
        end
    end
  	if bNeedTips then
  	 	  MsgBoxManager:showTipBox(LocalStrings.PET_HIGH_QULITY)
  	end
end

--@brief 快速选择升一级所需宠物
function WndPetsUpgrade:onbatchClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local bNeedTips = true  --是否需要提示都是高星宠物
    local addLevel = GetElement(self.m_root, "txtPetEPD2_WndPetsUpgrade", WZUILabelTTF):getText()
    local petLv = self.n_curLv + addLevel
    local playerLv = CacheCenter:getPlayerInfo().level
    if playerLv <= petLv then
        MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
        return 
    end

    if #self.m_tMatchList < 1 then
        bNeedTips = false
        self:_setChoiceViewState(true)
        MsgBoxManager:showTipBox(LocalStrings.PETNOUPEXP)
        return 
    end
    local bEnoughPet = self:_judgeEnoughPetForNextLevel()
    if not bEnoughPet then 
        MsgBoxManager:showTipBox(LocalStrings.PETNOTUPONE)
        return 
    end
    
    local quality = GDatatab_item["id_"..self.m_petInfo.itemId].quality
    if playerLv >= petLv + 1 then
        local totalExp = self:_getTotalExp(petLv, quality).total_exp
        local nowExp = 0
        if self.n_curLv == 1 then 
            nowExp = self.n_curExp
        else
            nowExp = self:_getTotalExp(self.n_curLv - 1, quality).total_exp + self.n_curExp 
        end
        local needExp = totalExp - nowExp - self.n_addExp

        WZLog("快速选择升一级所需经验", needExp, totalExp, nowExp, self.n_addExp)
        if needExp > 0 then 
            local bEnoughForUp = false 

            for i =1,#self.m_tMatchList do
              -- WZLog("快速选择升一级所需经验",Serialize(self.m_tMatchList[i]))
                if self.m_tMatchList[i].m_tData.itemId == 11007 or self.m_tMatchList[i].m_tData.itemId == 11000 then
                    --已选择的数量
                    local chooseNum = self.m_tMatchList[i]:getChooseNum()
                    --剩余数量
                    local leftNum = self.m_tMatchList[i].num - chooseNum 
                    WZLog("剩余经验宠物数量", leftNum, self.m_tMatchList[i].num, chooseNum)
                    if leftNum > 0 then 
                        bNeedTips = false
                        local nOtherValue = self:getExpPetExp(self.m_tMatchList[i].m_tData)
                        local useNum = 0 
                        for k = 1, leftNum do
                            needExp = needExp - nOtherValue 
                            useNum = useNum + 1
                            if needExp <= 0 then 
                                bEnoughForUp = true
                                break 
                            end
                        end
                        self.m_tMatchList[i]:dochoiceRecover(useNum, true)
                        self.m_tMatchList[i]:setSelected(true)
                        self.m_tMatchList[i]:changePetNum(useNum + chooseNum, self.m_tMatchList[i].m_tData)
                        if bEnoughForUp then 
                            break 
                        end
                    end
                else
                    local nOtherValue = self:getExpPetExp(self.m_tMatchList[i].m_tData)

                    if self.m_tMatchList[i]:doQuickRecover() == true then
                        bNeedTips = false
                        needExp = needExp - nOtherValue 
                        if needExp <= 0 then 
                            break
                        end
                    end
                end 
            end
        end
        if bNeedTips then
            MsgBoxManager:showTipBox(LocalStrings.PET_HIGH_QULITY)
        end
    else
        MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetsUpgrade:onPetUpClick(element)
  	WZLog("WndPetsUpgrade:onPetUpClick")
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  	if self.m_bIsAlter == true then
    		WZLog("m_bIsAlter == true")
    		return
  	end
  	if self.n_addExp <= 0 then
    		MsgBoxManager:showTipBox(LocalStrings.PETNOUPEXP)
    		return
  	end
  	local lv = CacheCenter:getPlayerInfo().level
    WZLog("WndPetsUpgrade:onPetUpClick:", self.m_petInfo.upgradeLevel, lv)
  	if self.m_petInfo.upgradeLevel > lv then
    		MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
    		return
  	end
  	local count =  CacheCenter:getPlayerItemCountById(self.m_iCostType)
  	local needMoney = math.ceil(self.n_addExp)
  	if JudgeMoneyIsEnough(self.m_iCostType, needMoney,nil,nil,61)then
  	   	 --PassportSdkManager:gotoPaymentPage()
  	else
  		  return
  	end
	
  	local t_eatPets = {}
    local bHavePhantomPet = false 
  	for k, v in pairs(self.m_tPets) do
  	  	local bAdd = true
  	  	for k1, v1 in pairs(t_eatPets) do
    	  	  if v.playerPetId == v1.playerPetId then
      	  	    v1.num =  v1.num + 1
      	  	    bAdd = false
      	  	    break
    	  	  end
  	  	end
  	  	if bAdd then
    	  	  local addPet = {}
    	  	  addPet.playerPetId = v.playerPetId
    	  	  addPet.num = 1
    	  	  table.insert(t_eatPets, addPet)
            if v.petSkinItemId and v.petSkinItemId > 0 then
                bHavePhantomPet = true
            end
  	  	end
  	end

    self.m_tTempEatPet = CopyTable(t_eatPets)
    if bHavePhantomPet then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBox(LocalStrings.PET_TEXT10, self, self.continueToExtranction, nil, tCustomUIConfig)
        return 
    end

    self:continueToExtranction()
end

--@brief  继续
function WndPetsUpgrade:continueToExtranction()
    -- body
    local VansPriceID = WZLuaVector_int_:create()
    local VansNum = WZLuaVector_int_:create()
  	for k ,v in pairs(self.m_tTempEatPet) do
  	  	WZLog("addPet:", v.playerPetId, v.num)
  	  	VansPriceID:push(v.playerPetId)
  	  	VansNum:push(v.num)
  	end
  	WZLog("WndPetsUpgrade:onPetUpClick11", Serialize(self.m_tTempEatPet))
  	self.m_bIsAlter = true
  	WndPets:setPlayExp(self.m_petInfo.upgradeLevel, self.m_petInfo.petExp)
    WZLog("快速选择的所有宠物id及数量",self.m_petInfo.playerPetId,VansPriceID,VansNum)
  	ProtocolProcessorScenePets:send_PET_Upgrade(self.m_petInfo.playerPetId,VansPriceID,VansNum)
end

--@brief   查找所有符合升级可以吞噬的宠物
function WndPetsUpgrade:findMatchPets()
	WZLog("WndPetsUpgrade:findMatchPets")
	self.m_tMatchPets = {}
	local cachePets = CacheCenter:getPlayerPetInfo()
  WZLog("WndPetsUpgrade:findMatchPets22:",#cachePets)
  if self.m_petInfo then
    WZLog("WndPetsUpgrade:findMatchPets33:",Serialize(self.m_petInfo))
  end
	table.sort( cachePets, sortUpPets)
	for k,v in pairs(cachePets) do
    if v and v.itemId and self.m_petInfo.itemId then
  		if v.isInUsed == false and v.playerPetId ~= self.m_petInfo.playerPetId and GDatatab_item["id_"..v.itemId].quality <= GDatatab_item["id_"..self.m_petInfo.itemId].quality and v.advancedLevel <= 0 then --and v.upgradeLevel <= 1 
  		   table.insert(self.m_tMatchPets,v)
  		end
    end
	end
  WZLog("WndPetsUpgrade:findMatchPets44:",#self.m_tMatchPets)
	return self.m_tMatchPets
end

--@brief   宠物列表排序
function sortUpPets(a,b)
  local aQuality = GDatatab_item["id_"..a.itemId].quality
  local bQuality = GDatatab_item["id_"..b.itemId].quality
  if aQuality == bQuality then
       return a.upgradeLevel < b.upgradeLevel        
  else
       return aQuality < bQuality
  end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetsUpgrade:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerPetInfoObserver(self)
end

--@brief   反注册监听
function WndPetsUpgrade:unRegisterPetInfoObserver()
  WZLog("WndPetsUpgrade:unRegisterPetInfoObserver")
end

--@brief   注册监听
function WndPetsUpgrade:RegisterPetInfoObserver()
  WZLog("WndPetsUpgrade:RegisterPetInfoObserver")
end

--@brief    更新升级按钮状态
function WndPetsUpgrade:updateBtnStats(bolean)
	local btn =  self.m_root:getChildElement("btnPetStatus_WndPetsUpgrade")
	btn = WZUIButton:luaTo(btn)
    btn:setTouchEnable(bolean)
end

--@brief   从缓存中心监听到宠物信息有改变则刷新宠物信息
function WndPetsUpgrade:updatePlayerPetInfoData()
  WZLog("WndPetsUpgrade:updatePlayerPetInfoData")
  if self.m_petInfo == nil then
    return
  end
  if self.m_bIsAlter == true then
  	 self.m_bIsAlter = false
     local pet = {}
     self.b_Up = true
     for k,v in pairs(CacheCenter:getPlayerPetInfo()) do
        if v.playerPetId == self.m_petInfo.playerPetId then
          WZLog("ddddddddd:",v.upgradeLevel)
          pet = v
          self:_cleanDate()
        break
      end
     end
     WZLog("SSSSSSS:",self.m_petInfo.upgradeLevel, self.n_curLv) 
     if pet.upgradeLevel > self.n_curLv then
        PopupResult("ui/common/common_icon_sjz.png")
        self:playAddStarAndUpdateAni(0)
        if self.m_petInfo.isInUsed then
          WZLog("FFFFFFFFFFFFF:",self.m_petInfo.fighting, self.n_curFighting) 
  	 	    upPlayerFightingAni(self.m_petInfo.fighting - self.n_curFighting)	
  	    end
      else
        self:playAddStarAndUpdateAni(1)
     end
     self:setPetInfo(pet)
     self.n_curFighting = self.m_petInfo.fighting
     self:setPetExpInfo(self.m_petInfo)
     self:showPetInfo()    
  end
end

--@brief  宠物升级失败
function WndPetsUpgrade:updateError()
	WZLog("WndPetsUpgrade:updateError")
	self.m_bIsAlter = false
	MsgBoxManager:showTipBox(STAR_SOUL_LIGHT_FAIL)
end

function WndPetsUpgrade:addChoiceExpPet(bAdd,nTag,cell,num)
  -- body
    WZLog("WndPetsUpgrade:addChoiceExpPet:",bAdd,nTag, Serialize(cell.m_tData),num)
    if bAdd then
        self.m_tUsePet[nTag] = {}
        self.m_tUsePet[nTag] = cell
        local nOtherValue = self:getExpPetExp(cell.m_tData)
        self:setPetExp(cell.m_tData, true, nOtherValue, num)
    else
        local nOtherValue = self:getExpPetExp(cell.m_tData)
        self:setPetExp(cell.m_tData, false, nOtherValue, num)
        if nTag then
            self.m_tUsePet[nTag] = nil
        else
            for i = 1, #self.m_tUsePet do
                if self.m_tUsePet[i] == cell then
                    self.m_tUsePet[i] = nil
                end
            end
        end
    end
end

function WndPetsUpgrade:getExpPetExp(tPetInfo)
  -- body
  local nOtherValue = 0
  --宠物被吞噬经验
  for k,v in pairs(GDatatab_pet) do
    if v.item_id == tPetInfo.itemId then
      nOtherValue = v.exp
      break
    end
  end
  WZLog("单个经验宠物吞噬经验",nOtherValue)
  return nOtherValue
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif 清除数据
function WndPetsUpgrade:_cleanDate()
  	self.n_addExp = 0
  	self.n_choiceNum = 0
  	self.m_tPets = {}                  
  	self.m_tMatchPets = {}
    self.n_whileLv = self.m_petInfo.upgradeLevel

    local tableList = GetElement(self.m_root, "conPetList_WndPetsUpgrade", WZUITableContainer)
    for i, tCell in pairs(self.m_tUsePet) do
        for j = 1, #self.m_tMatchList do
            if self.m_tMatchList[j] == tCell then
                if GDatatab_item["id_" .. self.m_tMatchList[j].m_tData.itemId].sub_type == 0 then 
                    local chooseNum = self.m_tMatchList[j]:getChooseNum()
                    if chooseNum == self.m_tMatchList[j].num then 
                        tableList:removeCellElement(WZUIContainer:luaTo(self.m_tMatchList[j].m_root))
                        table.remove(self.m_tMatchList, j)
                    else
                        self.m_tMatchList[j].num = self.m_tMatchList[j].num - chooseNum
                        self.m_tMatchList[j]:updatePetNum(self.m_tMatchList[j])
                        self.m_tMatchList[j]:setSelected(false)
                    end
                else
                    WZLog("WndPetsUpgrade:_cleanDate", j, self.m_tMatchList[j].m_tData.itemId)
                    tableList:removeCellElement(WZUIContainer:luaTo(self.m_tMatchList[j].m_root))
                    table.remove(self.m_tMatchList, j)
                end
                break
            end
        end
    end
    --如果宠物列表都未nil了，则重新添加宠物
    if #self.m_tMatchList < 100 then
  	    self.b_Up = false
    end
    GetElement(self.m_root,"conNoPet_WndPetsUpgrade",WZUIContainer):setVisible(#self.m_tMatchList < 1)             
    self.m_tUsePet = {}                --记录格子里的宠物			
end

--@brief 设置选择宠物界面的状态
function WndPetsUpgrade:_setChoiceViewState(bShow)
	GetElement(self.m_root, "conChoice_WndPetsUpgrade",WZUIContainer):setVisible(bShow)
	GetElement(self.m_root, "conUnChoice_WndPetsUpgrade",WZUIContainer):setVisible(bShow)
	self.b_eatPet = bShow
end

--@brief onEnter函数执行完成回调
function WndPetsUpgrade:_initUseData()
    GetElement(self.m_root,"txtLvE2_WndPetsUpgrade",WZUILabelTTF):setText(0)
    GetElement(self.m_root,"txtLvE3_WndPetsUpgrade",WZUILabelTTF):setText(0)
    GetElement(self.m_root, "txtChooseNum_WndPetsUpgrade", WZUILabelTTF):setText(self.n_choiceNum .. "/" .. self.m_nMaxNum)
end

--@brief    获取宠物经验
function WndPetsUpgrade:getCellPetExp(tPetInfo)
    local nOtherValue = nil 
    --宠物被吞噬经验
    for k,v in pairs(GDatatab_pet) do
      if v.item_id == tPetInfo.itemId then
        nOtherValue  = v.exp 
        bool = true
        break
      end
    end
    local quality = GDatatab_item["id_"..tPetInfo.itemId].quality
    --宠物等级经验
    for k,v in pairs(GDatatab_pet_upgrade) do
      if v.level == (tPetInfo.upgradeLevel-1) and v.quality == quality then
        nOtherValue  = nOtherValue + v.total_exp
        WZLog(" WndPetsUpgrade:getCellPetExp:", v.level, v.quality, v.total_exp)
        break
      end
    end
    --宠物当前经验
    nOtherValue = nOtherValue + tPetInfo.petExp
    WZLog(" WndPetsUpgrade:getCellPetExp:", nOtherValue, tPetInfo.petExp)
    if nOtherValue == nil then
        nOtherValue = 0
    end

    return nOtherValue
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndPetsUpgrade:_adaptLanguage_en()
	GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtNoUpgradeDesc_WndPetsUpgrade",WZUILabelTTF):setFontSize(18)
end

function WndPetsUpgrade:_adaptLanguage_pt(  )
  local txtOneKey = GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF)
  txtOneKey:setDimensions(GlobalMethod:CCSize(95))
  txtOneKey:setRelativePosition(GlobalMethod:ccp(0.5,0.464286))
  txtOneKey:setFontSize(16)

  GetElement(self.m_root,"txtNoUpgradeDesc_WndPetsUpgrade",WZUILabelTTF):setFontSize(18)
  GetElement(self.m_root,"txt_WndPetsUpgrade",WZUILabelTTF):setFontSize(21)
  GetElement(self.m_root,"txtPetUp_WndPetsUpgrade",WZUILabelTTF):setFontSize(22)
  
end

function WndPetsUpgrade:_adaptLanguage_vn()
	GetElement(self.m_root,"txtPetUp_WndPetsUpgrade",WZUILabelTTF):setFontSize(20)
  GetElement(self.m_root,"txtPetAPD1_WndPetsUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.255,0.5))
  GetElement(self.m_root,"txtPetAPD2_WndPetsUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.835,0.5))
  -- GetElement(self.m_root,"txt_WndPetsUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.98))
  GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF):setFontSize(20)
end

function WndPetsUpgrade:_adaptLanguage_tr()
    GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF):setFontSize(18)

  GetElement(self.m_root,"imgArrow1_WndPetsUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.29,0.5))
  GetElement(self.m_root,"imgArrow2_WndPetsUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.71,0.5))
    
end

function WndPetsUpgrade:_adaptLanguage_es(  )
    local txtPetAPD1 = GetElement(self.m_root,"txtPetAPD1_WndPetsUpgrade",WZUILabelTTF)
    txtPetAPD1:setRelativePosition(GlobalMethod:ccp(0.24,0.5))
    local txtPetAPD2 = GetElement(self.m_root,"txtPetAPD2_WndPetsUpgrade",WZUILabelTTF)
    txtPetAPD2:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
    local txtPetDPD1 = GetElement(self.m_root,"txtPetDPD1_WndPetsUpgrade",WZUILabelTTF)
    txtPetDPD1:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    local txtPetDPD2 = GetElement(self.m_root,"txtPetDPD2_WndPetsUpgrade",WZUILabelTTF)
    txtPetDPD2:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
    local txtLvE1 = GetElement(self.m_root,"txtLvE1_WndPetsUpgrade",WZUILabelTTF)
    txtLvE1:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
    txtLvE1:setFontSize(18)
    local txtOneKey = GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF)
    txtOneKey:setFontSize(18)
    txtOneKey:setDimensions(GlobalMethod:CCSize(130,0))
    GetElement(self.m_root,"txtNoUpgradeDesc_WndPetsUpgrade",WZUILabelTTF):setFontSize(16)

    GetElement(self.m_root,"imgArrow1_WndPetsUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.17,0.5))
    GetElement(self.m_root,"imgArrow2_WndPetsUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
    
end

function WndPetsUpgrade:_adaptLanguage_ug(  )
  GetElement(self.m_root,"txtLvE1_WndPetsUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.984609,0.45))
  local txtLvE3 = GetElement(self.m_root,"txtLvE3_WndPetsUpgrade",WZUILabelTTF)
  txtLvE3:setRelativePosition(GlobalMethod:ccp(0.494341,0.45))
  txtLvE3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  GetElement(self.m_root,"conImgLvE1_WndPetsUpgrade",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.262935,0.5))
  local txtLvE2 = GetElement(self.m_root,"txtLvE2_WndPetsUpgrade",WZUILabelTTF)
  txtLvE2:setRelativePosition(GlobalMethod:ccp(0.204115,0.45))
  txtLvE2:setAnchorPoint(GlobalMethod:ccp(1,0.5))

  GetElement(self.m_root,"txt_WndPetsUpgrade",WZUILabelTTF):setScale(0.7)

  local txtPetHP1 = GetElement(self.m_root,"txtPetHP1_WndPetsUpgrade",WZUILabelTTF)
  txtPetHP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetHP2 = GetElement(self.m_root,"txtPetHP2_WndPetsUpgrade",WZUILabelTTF)
  txtPetHP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetAP1 = GetElement(self.m_root,"txtPetAP1_WndPetsUpgrade",WZUILabelTTF)
  txtPetAP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetAP2 = GetElement(self.m_root,"txtPetAP2_WndPetsUpgrade",WZUILabelTTF)
  txtPetAP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAP2:setRelativePosition(GlobalMethod:ccp(1,0.5))
  local txtPetDP1 = GetElement(self.m_root,"txtPetDP1_WndPetsUpgrade",WZUILabelTTF)
  txtPetDP1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP1:setRelativePosition(GlobalMethod:ccp(0.45,0.5))
  local txtPetDP2 = GetElement(self.m_root,"txtPetDP2_WndPetsUpgrade",WZUILabelTTF)
  txtPetDP2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDP2:setRelativePosition(GlobalMethod:ccp(1,0.5))

  local txtPetHPD1 = GetElement(self.m_root,"txtPetHPD1_WndPetsUpgrade",WZUILabelTTF)
  txtPetHPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetHPD2 = GetElement(self.m_root,"txtPetHPD2_WndPetsUpgrade",WZUILabelTTF)
  txtPetHPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetHPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
  local txtPetAPD1 = GetElement(self.m_root,"txtPetAPD1_WndPetsUpgrade",WZUILabelTTF)
  txtPetAPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetAPD2 = GetElement(self.m_root,"txtPetAPD2_WndPetsUpgrade",WZUILabelTTF)
  txtPetAPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetAPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
  local txtPetDPD1 = GetElement(self.m_root,"txtPetDPD1_WndPetsUpgrade",WZUILabelTTF)
  txtPetDPD1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDPD1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
  local txtPetDPD2 = GetElement(self.m_root,"txtPetDPD2_WndPetsUpgrade",WZUILabelTTF)
  txtPetDPD2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
  txtPetDPD2:setRelativePosition(GlobalMethod:ccp(0.7,0.5))

  local txtPetUp = GetElement(self.m_root,"txtPetUp_WndPetsUpgrade",WZUILabelTTF)
  txtPetUp:setScale(0.5)
  txtPetUp:setDimensions(GlobalMethod:CCSize(220))
  local txtOneKey = GetElement(self.m_root,"txtOneKey_WndPetsUpgrade",WZUILabelTTF)
  txtOneKey:setScale(0.6)
  txtOneKey:setDimensions(GlobalMethod:CCSize(160))
  GetElement(self.m_root,"txtConfirm_WndPetsUpgrade",WZUILabelTTF):setScale(0.6)
end
-------------------------------------语言适配模块End--------------------------------------
