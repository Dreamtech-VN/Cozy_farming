--WndPetShow.lua
--@brief	WndPetShow的UI模块
--@date		2015/12/11
--@author	zhangming
--@note		宠物预览界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetShow:onEnter(element)
	self.m_root = element
  AdaptLanguage(self)
end


--@brief onEnter函数执行完成回调
function WndPetShow:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief  窗口动画完成回调
function WndPetShow:actionCallback(elem,data) 
  self:_initShow()
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetShow:onExit(element)
	self:_unInit()
end


--关闭宠物预览界面
function WndPetShow:onCloseShow(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
  WindowManager:removeWindow(self.m_root, self, true)
end

--切换宠物预览界面
function WndPetShow:onChange(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndPetShow:onChange:", self.m_State)
  if self.m_State == 0 then
    local petId = GDatatab_item["id_"..self.petId].quality == 4 and self.petId or self.petId+20000
    local bCan = false
    for k,v in pairs(GDatatab_pet_advance_evo) do
      if v.id == petId then
        bCan = true
        break
      end
    end
    if bCan then
      self:_showOrangePet(petId)
    else
      MsgBoxManager:showTipBox(LocalStrings.PETNOOPEN)
    end
  else
    local petId = GDatatab_item["id_"..self.petId].quality == 4 and self.petId-20000 or self.petId
    self:_showPurplePet(petId)
  end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  设置本地界面文本
function WndPetShow:_initShow()
  local quality = GDatatab_item["id_"..self.petId].quality

  --切换按钮的显示设置
  GetElement(self.m_root,"conButton_WndPetShow",WZUIContainer):setVisible(quality>=3)
  if quality == 4 then --紫宠
    self:_showOrangePet(self.petId)
  else
    self:_showPurplePet(self.petId)
  end
end


--@brief  设置本地界面文本
function WndPetShow:_showPurplePet(petId)
  self.m_State = 0
  local showName = {LocalStrings.PETSHOWNAME1,LocalStrings.PETSHOWNAME2,LocalStrings.PETSHOWNAME3}
  local aniName = {"","",""}
  local aniLevel = {3,4,6}
  for k, v in pairs(GDatatab_pet_advanced) do
    if v.item_id == petId then
      if v.level == aniLevel[1] then
        aniName[1] = v.animation
      elseif v.level == aniLevel[2] then
        aniName[2] = v.animation
      elseif v.level == aniLevel[3] then
        aniName[3] = v.animation
      end
    end
  end
  for i =1, 3 do
    GetElement(self.m_root,"txtName"..i.."_WndPetShow",WZUIFreeTextBox):setShowText(showName[i])
    local petImage = GetElement(self.m_root,"conPet"..i.."_WndPetShow",WZUIContainer)
    petImage:removeAllChildrenWithCleanup(true)
    local petAni,backFire = CreatePetAni(petImage, nil, aniName[i],aniLevel[i])
    petAni:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
    if backFire then
      local size = petAni:getAnimNode():getContentSize()
       backFire:setPositionY(backFire:getPositionY()+size.height/2)
    end
    --petAni:setScale(self:_getScale(petId, i))
  end
  local showDesc = {LocalStrings.PETSHOWTIP1,LocalStrings.PETSHOWTIP2,LocalStrings.PETSHOWTIP3,LocalStrings.PETSHOWTIP4,LocalStrings.PETSHOWTIP5,LocalStrings.PETSHOWTIP6}
  for i =1, 6 do
	GetElement(self.m_root,"txtDesc"..i.."_WndPetShow",WZUIFreeTextBox):setShowText(showDesc[i])
  end
  --紫橙显示相关
  GetElement(self.m_root,"conPetz1_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.175,0.6))
  GetElement(self.m_root,"conPetz3_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.825,0.6))
  GetElement(self.m_root,"conAll_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.56))
  GetElement(self.m_root,"txtBtn_WndPetShow",WZUILabelTTF):setText(LocalStrings.PURPLEPET)
  GetElement(self.m_root,"conPetz2_WndPetShow",WZUIContainer):setVisible(true)
  GetElement(self.m_root,"conArrow1_WndPetShow",WZUIContainer):setVisible(true)
  GetElement(self.m_root,"conArrow2_WndPetShow",WZUIContainer):setVisible(false)
end

--@brief  设置本地界面文本
function WndPetShow:_showOrangePet(petId)
  self.m_State = 1
  local showName = {LocalStrings.PETSHOWNAME2,LocalStrings.PETSHOWNAME2,LocalStrings.PETSHOWNAME3}
  local aniLevel = {4,4,6}
  local aniName = GDatatab_item["id_"..petId].animation_index_code
  for i =1, 3 do
    GetElement(self.m_root,"txtName"..i.."_WndPetShow",WZUIFreeTextBox):setShowText(showName[i])
    local petImage = GetElement(self.m_root,"conPet"..i.."_WndPetShow",WZUIContainer)
    petImage:removeAllChildrenWithCleanup(true)
    local petAni,backFire = CreatePetAni(petImage, nil, aniName,aniLevel[i])
    petAni:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
    if backFire then
      local size = petAni:getAnimNode():getContentSize()
       backFire:setPositionY(backFire:getPositionY()+size.height/2)
    end
    --petAni:setScale(self:_getScale(petId, i))
  end
  local showDesc = {LocalStrings.PETSHOWTIP1,LocalStrings.PETSHOWTIP2,LocalStrings.PETSHOWTIP3,LocalStrings.PETSHOWTIP4,LocalStrings.PETSHOWTIP5,LocalStrings.PETSHOWTIP6}
  for i =1, 6 do
  GetElement(self.m_root,"txtDesc"..i.."_WndPetShow",WZUIFreeTextBox):setShowText(showDesc[i])
  end
  --紫橙显示相关
  GetElement(self.m_root,"conPetz1_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.25,0.6))
  GetElement(self.m_root,"conPetz3_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75,0.6))
  GetElement(self.m_root,"conAll_WndPetShow",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.576))
  GetElement(self.m_root,"txtBtn_WndPetShow",WZUILabelTTF):setText(LocalStrings.ORANGEPET)
  GetElement(self.m_root,"conPetz2_WndPetShow",WZUIContainer):setVisible(false)
  GetElement(self.m_root,"conArrow1_WndPetShow",WZUIContainer):setVisible(false)
  GetElement(self.m_root,"conArrow2_WndPetShow",WZUIContainer):setVisible(true)
end

--@brief 获得宠物的缩放大小
function WndPetShow:_getScale(petId, level)
    local num = (level-1)*2
    for k, v in pairs(GDatatab_pet_advanced) do
      if v.item_id == petId and v.level == num then
        return v.move/100
      end
    end
    return 1
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin----------------------------------------
function WndPetShow:_adaptLanguage_en(  )
  GetElement(self.m_root,"img1_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
  GetElement(self.m_root,"img2_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.25,0.5))

  GetElement(self.m_root,"imgLeft_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.26,0.5))
  GetElement(self.m_root,"imgRight_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.27,0.5))
end

function WndPetShow:_adaptLanguage_th(  )
  GetElement(self.m_root,"imgLeft_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.15,0.5))
  GetElement(self.m_root,"imgRight_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.16,0.5))
end


function WndPetShow:_adaptLanguage_pt(  )
  for i=1,6 do
    local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndPetShow",WZUIFreeTextBox)
    txtDesc:setScale(0.8)
    txtDesc:setMaxWidth(800)
  end
  
  GetElement(self.m_root,"img1_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
  GetElement(self.m_root,"img2_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.25,0.5))

  GetElement(self.m_root,"imgLeft_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.25,0.5))
  GetElement(self.m_root,"imgRight_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.26,0.5))
end

function WndPetShow:_adaptLanguage_tr()
    for i =1, 4 do
        GetElement(self.m_root,"txtDesc"..i.."_WndPetShow",WZUIFreeTextBox):setMaxWidth(700)
    end

  GetElement(self.m_root,"img1_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
  GetElement(self.m_root,"img2_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.25,0.5))

  GetElement(self.m_root,"imgLeft_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.47,0.5))
  GetElement(self.m_root,"imgRight_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.47,0.5))
end

function WndPetShow:_adaptLanguage_vn(  )
  GetElement(self.m_root,"imgLeft_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.15,0.5))
  GetElement(self.m_root,"imgRight_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.16,0.5))
end

function WndPetShow:_adaptLanguage_es()
    for i =1, 6 do
        local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndPetShow",WZUIFreeTextBox)
        txtDesc:setMaxWidth(880)
        txtDesc:setScale(0.85)
    end
    local txtBtn = GetElement(self.m_root,"txtBtn_WndPetShow",WZUILabelTTF)
    txtBtn:setDimensions(GlobalMethod:CCSize(110,0))
    txtBtn:setScale(0.8)

  GetElement(self.m_root,"img1_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
  GetElement(self.m_root,"img2_WndPetShow",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.17,0.5))
end
-------------------------------------私有方法模块End----------------------------------------