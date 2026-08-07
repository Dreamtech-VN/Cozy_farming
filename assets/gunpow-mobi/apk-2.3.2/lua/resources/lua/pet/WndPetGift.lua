--WndPetGift.lua
--@brief	WndPetGift的UI模块
--@date		2016/11/16
--@author	zhangming
--@note		宠物资质洗脸


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetGift:onEnter(element)
	self.m_root = element
	self.m_petInfo = {}                 --宠物信息
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetGift:onExit(element)
	self:_unInit()
	self.m_petInfo = nil
end

--@brief onEnter函数执行完成回调
function WndPetGift:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self) 
    AdaptLanguage(self)
end

--@brief  窗口动画完成回调
function WndPetGift:actionCallback(elem,data)
   self:showPetInfo() 
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetGift:onCloseClick(element)
	WZLog("WndPetsUpgrade:WndPetGift")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
  WndPets:doRefresh()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetGift:onClickGift(element)
	WZLog("WndPetsUpgrade:onClickGift")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  if self:_isMax() then
    MsgBoxManager:showTipBox(LocalStrings.PETMAXGIFT)
    return
  end
  	local costData = CacheCenter:getGameParam()["petGiftWashCost"]
  	local costId,costNum = SplitItemString(costData)
  	if JudgeMoneyIsEnough(tonumber(costId[1]), tonumber(costNum[1]),nil,nil,59) then
	   if JudgeMoneyIsEnough(tonumber(costId[2]), tonumber(costNum[2]),nil,nil,59) then
	   		self:createLoadingBox()
	   		ProtocolProcessorScenePets:send_WashPetGift(self.m_petInfo.playerPetId)
	   end
	end
end

--洗练宠物成功
function WndPetGift:washGiftOk(giftSkill)
	self:closeLoadingBox()
  --提示升级成功
  PopupResult("ui/common/common_icon_xilz.png")
  --洗练成功音效
  SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
  --播放洗练特效动画
  local spineSophistic = GetElement(self.m_root, "spineSophistic_WndPetGift", WZUISpine)
  spineSophistic:setVisible(true)
  spineSophistic:play("effect", false)
	 --星星品质
  self.m_petInfo.giftSkill = giftSkill
  local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
  for i = 1, 7 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetGift",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetGift",aptitude)
  --宠物资质
   --宠物消耗
  local costData = CacheCenter:getGameParam()["petGiftWashCost"]
  local costId,costNum = SplitItemString(costData)
  GetElement(self.m_root,"txtLvE4_WndPetGift",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM,CacheCenter:getPlayerItemCountById(costId[2])))
  local minGift,maxGift
  for k,v in pairs(GDatatab_pet) do
    if v.item_id == self.m_petInfo.itemId then
        minGift = v.gift[1][1]
        maxGift = v.gift[1][2]
        break
    end
  end
  GetElement(self.m_root,"txtGift_WndPetGift",WZUILabelTTF):setText(LocalStrings.PETINTELLIGENCE..self.m_petInfo.giftSkill/100)
  GetElement(self.m_root,"txtGift1_WndPetGift",WZUILabelTTF):setText("("..minGift.."-"..maxGift..")")
end

--@brief   展示宠物基本信息
function WndPetGift:showPetInfo()
	WZLog("WndPetGift:showPetInfo")
	if self.m_petInfo == nil then return end
	if self.m_petInfo.name == nil then return end
	if self.m_petInfo.advancedLevel == nil then return end
	if self.m_petInfo.itemId == nil then return end
	if self.m_petInfo.upgradeLevel == nil then return end
	if self.m_petInfo.giftSkill == nil then return end
	if self.m_petInfo.animation == nil then return end
	--名字
  local name = self.m_petInfo.name
  local advancedLevel = self.m_petInfo.advancedLevel
  local nameText = GetElement(self.m_root,"txtName_WndPetGift",WZUIFreeTextBox)
  WndPets:setPetName(self.m_petInfo.itemId, nameText, name, advancedLevel, false)
  --nameText:setText(name)
 
  --等级
  local lvtext = GetElement(self.m_root,"txtLv_WndPetGift",WZUILabelTTF)
  lvtext:setText("Lv"..self.m_petInfo.upgradeLevel)
  WndPets:setTextColor(GDatatab_item["id_"..self.m_petInfo.itemId].quality, lvtext)

   --星星品质
  local aptitude = WndPets:getAptitude(self.m_petInfo.giftSkill)
  for i = 1, 7 do
      GetElement(self.m_root,"imgAptitude"..i.."_WndPetGift",WZUIImage):setVisible(i <= aptitude)
  end
  WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetGift",aptitude)

  local minGift,maxGift
  for k,v in pairs(GDatatab_pet) do
    if v.item_id == self.m_petInfo.itemId then
        minGift = v.gift[1][1]
        maxGift = v.gift[1][2]
        break
    end
  end
  --宠物资质
  GetElement(self.m_root,"txtGift_WndPetGift",WZUILabelTTF):setText(LocalStrings.PETINTELLIGENCE..self.m_petInfo.giftSkill/100)
  GetElement(self.m_root,"txtGift1_WndPetGift",WZUILabelTTF):setText("("..minGift.."-"..maxGift..")")
  --宠物动画
  local petImage = GetElement(self.m_root,"conPetImage_WndPetGift",WZUIContainer)
  petImage:removeAllChildrenWithCleanup(true)
  local petAni = CreatePetAni(petImage, nil, self.m_petInfo.animation, self.m_petInfo.advancedLevel)

  --宠物消耗
  local costData = CacheCenter:getGameParam()["petGiftWashCost"]
  --costData = "[1,100]&[2,100]"
   WZLog("WndPetRaffle:onEnter:", costData)
  local costId,costNum = SplitItemString(costData)
  WZLog("WndPetRaffle:onEnter:",costId[1],costId[2],costNum[1],costNum[2])
  local filePath = GDatatab_item["id_"..costId[1]].icon
  local filePath2 = GDatatab_item["id_"..costId[2]].icon
   GetElement(self.m_root,"imgCost1_WndPetGift",WZUIImage):setFile(filePath)
   GetElement(self.m_root,"imgCost2_WndPetGift",WZUIImage):setFile(filePath2)
   GetElement(self.m_root,"txtLvE2_WndPetGift",WZUILabelTTF):setText(costNum[1])
   GetElement(self.m_root,"txtLvE3_WndPetGift",WZUILabelTTF):setText(costNum[2])
   local num = CacheCenter:getPlayerItemCountById(tonumber(costId[2]))
   GetElement(self.m_root,"txtLvE4_WndPetGift",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM,num))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPetGift:_isMax()
    local maxGift = 0
    for k,v in pairs(GDatatab_pet) do
        if v.item_id == self.m_petInfo.itemId then
          maxGift = v.gift[1][2]
          break
        end
    end
    WZLog("WndPetGift:_isMax:",maxGift)
    if maxGift*100 <= tonumber(self.m_petInfo.giftSkill) then
      return true
    end
    return false
end

--@brief  宠物洗练的规则说明
function WndPetGift:onDes( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PETDES)
end

function WndPetGift:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    end
end

function WndPetGift:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndPetGift:_adaptLanguage_en()
  GetElement(self.m_root,"imgRightArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
  GetElement(self.m_root,"imgLeftArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
end

function WndPetGift:_adaptLanguage_vn()
  local imgLeftArrow = GetElement(self.m_root,"imgLeftArrow_WndPetGift",WZUIImage)
  if imgLeftArrow then
    imgLeftArrow:setRelativePosition(GlobalMethod:ccp(0.23,0.5))
  end
  local imgRightArrow = GetElement(self.m_root,"imgRightArrow_WndPetGift",WZUIImage)
  if imgRightArrow then
    imgRightArrow:setRelativePosition(GlobalMethod:ccp(0.77,0.5))
  end
end

function WndPetGift:_adaptLanguage_pt()
  GetElement(self.m_root,"imgLeftArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
  GetElement(self.m_root,"imgRightArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
end

function WndPetGift:_adaptLanguage_es()
  GetElement(self.m_root,"imgLeftArrow_WndPetGift",WZUIImage):setVisible(false)
  GetElement(self.m_root,"imgRightArrow_WndPetGift",WZUIImage):setVisible(false)

  GetElement(self.m_root,"txtName_WndPetGift",WZUIFreeTextBox):setMaxWidth(600)
end
function WndPetGift:_adaptLanguage_tr()
  GetElement(self.m_root,"imgLeftArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
  GetElement(self.m_root,"imgRightArrow_WndPetGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
end
-------------------------------------语言适配End--------------------------------------------