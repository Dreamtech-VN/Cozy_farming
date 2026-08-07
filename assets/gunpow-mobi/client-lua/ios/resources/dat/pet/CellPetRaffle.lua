--CellPetRaffle.lua
--@brief  CellPetRaffle的UI模块
--@date   2015/09/22
--@author zhangming
--@note   宠物抽奖宠物


-------------------------------------公有方法模块Begin--------------------------------------

--@brief  进入场景时被调用的函数
--@param  element:表绑定的UI节点引用
--@note   在这里做场景进入前的准备工作
function CellPetRaffle:onEnter(element)
  self.m_root = element
  AdaptLanguage(self)
end

--@brief  退出场景时被调用的函数
--@param  element:表绑定的UI节点引用
--@note   在这里做场景退出前的清理工作
function CellPetRaffle:onExit(element)
  self:_unInit()
end

--@brief  点击返回按钮执行的函数ss
--@param  element:表绑定的UI节点引用
function CellPetRaffle:onReturnClick(element)
  WZLog("CellPetRaffle:onReturnClick")
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  self:doTenMove()
  GetElement(WndPetRaffle.m_root,"imgLightBg3_WndPetRaffle",WZUIImage):setVisible(false)
  GetElement(WndPetRaffle.m_root,"imgLightBg4_WndPetRaffle",WZUIImage):setVisible(false)
  GetElement(self.m_root,"conTenButton_CellPetRaffle",WZUIContainer):setVisible(false)
end

--下落动画
function CellPetRaffle:downAction1()
	WZLog("CellPetRaffle:downAction1")
	if WndPetRaffle.m_root == nil then return end
  	local element = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  	local actionArray = CCArray:create()
  	actionArray:addObject(CCMoveBy:create(0,GlobalMethod:ccp(0, 800)))
  	actionArray:addObject(CCCallFuncN:create(function() element:setVisible(true) end))
  	actionArray:addObject(CCMoveBy:create(0.2,GlobalMethod:ccp(0,-800))) --下落速度
  	actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,20)))
  	actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,-20)))

  	actionArray:addObject(CCCallFuncN:create(function() self:openAction1() end))

  	local repH = CCSequence:create(actionArray)
  	element:runAction(repH) 
end

--@brief 开蛋的动画
function CellPetRaffle:openAction1()
	if WndPetRaffle.m_root == nil then return end
  	local actionNum = (WndPetRaffle.tag-1)*2
	WZLog("开蛋动画类型", WndPetRaffle.n_type, actionNum)
  	local myAni = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  	local myArmature = myAni:getArmature()
    WZLog("CellPetRaffle:openAction1", actionNum)
  	myArmature:getAnimation():playByIndex(actionNum)
  	myAni:setAnimationFinishLuaFunction("openOver1")

	WndPetRaffle:tenPetCall()
end

function CellPetRaffle:openOver1()
	WZLog("CellPetRaffle:openOver1")
	if WndPetRaffle.m_root == nil then return end
    local con = GetElement(WndPetRaffle.m_root,"conTen1_WndPetRaffle",WZUIContainer)
    con:setVisible(false)
end

--@brief 下落的动画
function CellPetRaffle:downAction()
  local element = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  local actionArray = CCArray:create()
  actionArray:addObject(CCMoveBy:create(0,GlobalMethod:ccp(0, 800)))
  actionArray:addObject(CCCallFuncN:create(function() element:setVisible(true) end))
  if self.n_type == 2 then --十连抽的
  actionArray:addObject(CCMoveBy:create(0.2,GlobalMethod:ccp(0,-800))) --下落速度
  actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,20)))
  actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,-20)))
  else  --单抽的
  actionArray:addObject(CCMoveBy:create(0.3,GlobalMethod:ccp(0,-800))) --下落速度
  actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,20)))
  actionArray:addObject(CCMoveBy:create(0.1,GlobalMethod:ccp(0,-20)))
  end
  if self.n_type ~= 2 then
    actionArray:addObject(CCCallFuncN:create(function() self:openAction() end))
  end
  local repH = CCSequence:create(actionArray)
  element:runAction(repH) 
end

--@brief 开蛋的动画
function CellPetRaffle:openAction(index)

  local actionNum = self.n_type*2
  --if self.t_data.quality >= 3 then
  --  actionNum = actionNum + 1
  --  SoundManager:playEffectSound(SoundDefine.E_S_PET_ZHADAN10)
  --else
  --  SoundManager:playEffectSound(SoundDefine.E_S_PET_ZHADAN)
  --end
  if index == nil or index == 1 then
  	WZLog("开蛋声音")
  	SoundManager:playEffectSound(SoundDefine.E_S_PET_ZHADAN)
  end
  local myAni = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  local myArmature =  myAni:getArmature()
  WZLog("CellPetRaffle:openAction", actionNum)
  myArmature:getAnimation():playByIndex(actionNum)
  myAni:setAnimationFinishLuaFunction("openOver")
  --if self.t_data.quality < 3 then
  --  DelayCallFunction(function() self:showPet() end,self, 0.6)--单抽宠物出现时间
  --  if  self.n_type == 2 then
  --     --DelayCallFunction(function() WndPetRaffle:tenPetOpen() end,WndPetRaffle, 0.01)--十连开蛋出现时间
  --  end
  --end

    DelayCallFunction(function() self:showPet() end,self, 0.6)--单抽宠物出现时间
end

--@brief 开蛋的动画结束
function CellPetRaffle:openOver()
  	local myAni = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  	myAni:setVisible(false)
 	--if self.t_data.quality >= 3 then
 	--   WndPetRaffle:showLightBg(self)
 	--end
end

--@brief 显示宠物动画结束
function CellPetRaffle:showPet()
  WndPetRaffle:showView()
  local con = GetElement(self.m_root,"conOnePet_CellPetRaffle",WZUIContainer)
  con:setVisible(true) 
  local element = self.m_root:getChildElement("conPetAnim_CellPetRaffle")
  local actionArray = CCArray:create()
  --if  self.t_data.quality < 3 then
  --  actionArray:addObject(CCScaleTo:create(0.4,1.0,1.0))
  --else
  --  actionArray:addObject(CCMoveBy:create(0,GlobalMethod:ccp(0,40)))
  --  actionArray:addObject(CCScaleTo:create(0.4,1.5,1.5))
  --end
  actionArray:addObject(CCScaleTo:create(0.4,1.0,1.0))
  if self.n_type == 2 then
    --if self.t_data.quality >= 3 then
    --local elementp = self.m_root
    --self.m_root:getParentElement():setZOrder(10)
    --self.n_px, self.n_py = elementp:getPosition()
    --local point = self.m_root:getParentElement():convertToWorldSpace(GlobalMethod:ccp(self.n_px, self.n_py))
    --local size = CCDirector:sharedDirector():getVisibleSize()
    --local sizeX,sizeY = size.width/2,size.height/2
    --point = self.m_root:getParentElement():convertToNodeSpace(GlobalMethod:ccp(sizeX, sizeY))
    --elementp:setPosition(GlobalMethod:ccp(point.x,  point.y))
    --actionArray:addObject(CCCallFuncN:create(function() GetElement(self.m_root,"conTenButton_CellPetRaffle",WZUIContainer):setVisible(true) end))
    --end
  end
  local repH = CCSequence:create(actionArray)
  element:runAction(repH)
end

--@brief 十连抽的时候获得5星宠物的特殊动画
function CellPetRaffle:doTenMove()
  local time = 0.2
  local petElement = self.m_root:getChildElement("conPetAnim_CellPetRaffle")
  petElement:runAction(CCMoveBy:create(0,GlobalMethod:ccp(0,-40)))
  petElement:runAction(CCScaleTo:create(time,1.0,1.0))
  local img = GetElement(self.m_root,"imgOneLight_CellPetRaffle",WZUIImage)
  --img:setScale(1)
  img:setVisible(false)
  local element = self.m_root
  local moveX,moveY = self.n_px, self.n_py
  local actionArray = CCArray:create()
  actionArray:addObject(CCMoveTo:create(time,GlobalMethod:ccp(self.n_px,self.n_py)))
  actionArray:addObject(CCCallFuncN:create(function() self:moveOver() end))
  local repH = CCSequence:create(actionArray)
  element:runAction(repH)
end

--@brief 显示宠物动画结束
function CellPetRaffle:moveOver()
   local img = GetElement(self.m_root,"imgOneLight_CellPetRaffle",WZUIImage)
   img:setVisible(true)
   self.m_root:getParentElement():setZOrder(1)
   --WndPetRaffle:tenPetOpen() 
end

--@brief 设置基础数据
--@petTab  petTab:宠物信息
function CellPetRaffle:setData(petTab, nType)
  WZLog("CellPetRaffle:createRafflePet")
  self.t_data = petTab
  --self.t_data.quality = 4
  self.n_type = nType
  --添加动画
  local petImg = self.m_root:getChildElement("conPetAnim_CellPetRaffle")
  petImg = WZUIContainer:luaTo(petImg)

  CreatePetAni(petImg, nil,  petTab.animation_index_code)
  petImg:setScale(0)

  --添加星星
  local quality = petTab.quality
  local aptitude = WndPets:getAptitude(petTab.aptitude)

  WZLog("RRRRRRRRRRRRR:",aptitude)
  for i=1, 5 do
    petAptitude = self.m_root:getChildElement("imgAptitude"..i.."_CellPetRaffle")
    petAptitude = WZUIImage:luaTo(petAptitude)
    petAptitude:setVisible(i <= aptitude)
  end
  local aptitudeElement = self.m_root:getChildElement("conAptitude_CellPetRaffle")
  aptitudeElement = WZUIContainer:luaTo(aptitudeElement)
  WndPetRaffle:_setAptitudePost(aptitudeElement, aptitude)
  --添加名字
  local txtName = self.m_root:getChildElement("txtPetName_CellPetRaffle")
  local txtColor = {[["99,255,95"]],[["93,222,254"]],[["198,130,255"]],[["233,166,62"]]}
  local color = txtColor[quality]
  local s0 = WndPets:getTypeById(petTab.id)
  local sLevel = string.format([[<I>%s</I><T C=%s S="24" P="1">%s</T>]],s0, color, petTab.name)
  if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
    local sLevel = string.format([[<I>%s</I><T C=%s S="20" P="1">%s</T>]],s0, color, petTab.name)
    txtName = WZUIFreeTextBox:luaTo(txtName)
    txtName:setShowText(sLevel)
  end
  txtName = WZUIFreeTextBox:luaTo(txtName)
  txtName:setShowText(sLevel)
  -- txtName = WZUILabelTTF:luaTo(txtName)
  -- txtName:setText(petTab.name)
  -- WndPetRaffle:setTextColor(quality, txtName)

  local myAni = GetElement(self.m_root,"armAddStar_CellPetRaffle",WZArmature)
  if nType == 2 then
    myAni:setScale(0.85)
  end
  GetElement(self.m_root,"imgOneLight_CellPetRaffle",WZUIImage):setScale(0.8)
  --if self.t_data.quality >= 3 then
  --   GetElement(self.m_root,"imgOneLight_CellPetRaffle",WZUIImage):setScale(5)
  --   GetElement(self.m_root,"imgPetName_CellPetRaffle",WZUIImage):setOpacity(204)
  --end
  local myArmature =  myAni:getArmature()
  local actionNum = self.n_type + 6
  myArmature:getAnimation():playByIndex(actionNum)

  -- local ani =  GetElement(self.m_root,"aniPet_CellPetRaffle",WZArmatureAnimationById)
  -- ani:playByIndex(0)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

----------------------------------------语言适配Begin------------------------------------------
function CellPetRaffle:_adaptLanguage_th(  )
  local txtPetName = GetElement(self.m_root,"txtPetName_CellPetRaffle",WZUIFreeTextBox)
  txtPetName:setScale(0.8)
  txtPetName:setMaxWidth(500)
end

function CellPetRaffle:_adaptLanguage_pt(  )
  GetElement(self.m_root,"txtPetName_CellPetRaffle",WZUIFreeTextBox):setScale(0.6)
end

function CellPetRaffle:_adaptLanguage_es(  )
  GetElement(self.m_root,"txtPetName_CellPetRaffle",WZUIFreeTextBox):setScale(0.6)
end
function CellPetRaffle:_adaptLanguage_tr(  )
  GetElement(self.m_root,"txtPetName_CellPetRaffle",WZUIFreeTextBox):setScale(0.8)
end
function CellPetRaffle:_adaptLanguage_en(  )
  GetElement(self.m_root,"txtPetName_CellPetRaffle",WZUIFreeTextBox):setScale(0.7)
end
----------------------------------------语言适配End--------------------------------------------
