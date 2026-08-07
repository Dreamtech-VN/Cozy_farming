--WndPetRaffleData.lua
--@brief	WndPetRaffle的数据模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物抽取

WndPetRaffle = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetRaffle:_init()
	self.m_root = nil	 	  			--场景根节点
  self.m_bISAlter = false     --标识是否正在进行抽奖，防止多次点击事件
  self.t_freeTime = {}        --免费抽奖时间
  self.m_nMaxNum = 0          --最多拥有宠物数量
  self.m_tPetDate = {}        --宠物抽奖的数据
  self.n_actionTag = 1        --10连抽动作tag
  self.m_tItem = {}           --所有宠物的date
  self.m_tItemChoice = nil    --当前图鉴所选取宠物
  self.n_type = 0             --抽奖方式
  self.t_tenPet = {}          --是个抽奖宠物的cell
  self.n_waitTime = 0         --下落时间值
  self.n_showPetId = 0        --展示宠物的Id
  self.b_hasAddList = false
  self.needWeChat = false     --需要分享微信游戏按钮
  self.tag = nil              --1：蛋壳抽奖，2：宠物券或者钻石抽奖，3：钻石十连抽
  self.note = nil             --1：单抽，2：十连抽
  self.m_nTempPetNum = nil 
  self.m_topCellLua = nil 
  self.n_fyberTime = 0        --fyber的时间
  self.isUseTicket = nil      --是否使用双货币
  self.itemId = nil
  self.giftSkill = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetRaffle:_unInit()
	self.m_root = nil
  self.m_bISAlter = nil
  self.t_freeTime = nil
  self.m_nMaxNum = nil
  self.m_tPetDate = nil
  self.n_actionTag = nil
  self.m_tItem = nil
  self.n_type = nil
  self.n_waitTime = nil
  self.t_tenPet = nil
  self.n_showPetId = nil
  self.m_tItemChoice = nil
  self.b_hasAddList = nil
  self.needWeChat = nil
  self.tag = nil
  self.note = nil
  self.m_nTempPetNum = nil 
  self.m_topCellLua = nil 
  self.n_fyberTime = nil
  self.isUseTicket = nil
  self.itemId = nil
  self.giftSkill = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetRaffle:createElement()
	local element = WZUISystem:getInstance():createElement("WndPetRaffle")
	assert(element, "WndPetRaffle create element failed!")
	self:_init()
	return element
end


--@brief  设置点击返回按钮返回的场景绑定的Lua表引用
--@param  tLuaObj，场景绑定的Lua表引用
--@note   点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function WndPetRaffle:setBackSceneLuaObj(tLuaObj)
  self.m_tBackSceneLuaObj = tLuaObj
end

--@brief  设置返回按钮点击回调(可置空)
--@param  callback:回调函数引用
--@param  tLuaObj:回调函数所属表对象
--@note   主要用于退出场景时回调
function WndPetRaffle:setBackButtonCallback(callback, tLuaObj)
    self.m_lpBackButtonCallback = callback
  self.m_tCallBackLuaObjMap[callback] = tLuaObj
end


--@brief    抽取宠物成功
function WndPetRaffle:rafflePetsData(itemId,giftSkill)
  WZLog("WndPetRaffle:rafflePetsData = ",#itemId)
  self.itemId = itemId
  self.giftSkill = giftSkill
  self:_getRaffleType()
  WndPets.n_refreshState = 2 --宠物界面需要进行刷新动作
  self.m_bISAlter = false
  ProtocolProcessorScenePets:send_PET_GetFreeTime()
  self.t_cellPet = {}
  self.needWeChat = false
  if  #itemId == 1 then  --抽一个
    WZLog("WndPetRaffle:rafflePetsData",Serialize(itemId),self.n_type)
    self:controlViewShow(3)
    local con = GetElement(self.m_root,"conOne_WndPetRaffle",WZUIContainer)
    con:removeAllChildrenWithCleanup(true)
    local cell,obj = CellPetRaffle:createElement()
    con:addChild(cell)
    local tab = GDatatab_item["id_"..itemId[1]]
    tab.aptitude = giftSkill[1]
    WZLog("HHHHHHHHHHH1:",giftSkill[1] )
    obj:setData(tab, self.n_type)
    obj:downAction()
    if tab.quality >= 3 then --紫宠
        self.needWeChat = true
    end
    local element = GetElement(self.m_root,"conOnePet_WndPetRaffle",WZUIContainer)
    if self.needWeChat then
      addWeChatBtn(element,3,GlobalMethod:ccp(1.5,-0.22127))
    else
      if element:getChildByTag(888) then
        element:removeChildByTag(888, true)
      end 
    end

    local imgOneRafType = GetElement(self.m_root,"imgOneRafType_WndPetRaffle",WZUIImage)
    local txtOneRafCount = GetElement(self.m_root,"txtOneRafCount_WndPetRaffle",WZUILabelTTF)
    local txtOneRafAgain = GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF)
    --WZLog("--self.t_freeTime--",self.t_freeTime[1])
    -- if self.n_type == 0 and self.t_freeTime[1] <= 0 then
    --   self.note = 1
    --   imgOneRafType:setFile("ui/common/common_icon_dk.png")
    --   imgOneRafType:setScale(0.5)
    --   txtOneRafCount:setText(LocalStrings.PETFREE2)
    --   txtOneRafAgain:setText(LocalStrings.PETOPENEGE1)
    -- else
    if self.tag == 1 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4]) >= tonumber(self.m_tPetDate[2][4]*10) then
      self.note = 2
      imgOneRafType:setFile("ui/common/common_icon_dk.png")
      imgOneRafType:setScale(0.5)
      txtOneRafCount:setText(self.m_tPetDate[2][4]*10)
      txtOneRafAgain:setText(LocalStrings.PETOPENEGE3)
    elseif self.tag == 1 then
      self.note = 1
      imgOneRafType:setFile("ui/common/common_icon_dk.png")
      imgOneRafType:setScale(0.5)
      txtOneRafCount:setText(self.m_tPetDate[2][4])
      txtOneRafAgain:setText(LocalStrings.PETOPENEGE1)
    elseif self.tag == 2 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) >= tonumber(self.m_tPetDate[2][1]) then
      self.note = 1
      imgOneRafType:setFile("shopitems/chongwujiang_1.png")
      imgOneRafType:setScale(0.5)
      txtOneRafCount:setText(self.m_tPetDate[2][1])
      txtOneRafAgain:setText(LocalStrings.PETOPENEGE4)
    elseif self.tag == 2 then
      self.note = 1
      imgOneRafType:setFile(GDatatab_item["id_" .. self.m_tPetDate[1][2]].icon)
      imgOneRafType:setScale(0.6)
      txtOneRafCount:setText(self.m_tPetDate[2][2])
      txtOneRafAgain:setText(LocalStrings.PETOPENEGE2)
    end
  else  --抽十个
    self:controlViewShow(2)

    local con = GetElement(self.m_root,"conTen1_WndPetRaffle",WZUIContainer)
    con:removeAllChildrenWithCleanup(true)
	con:setVisible(true)
    local cell,obj = CellPetRaffle:createElement()
    con:addChild(cell)
    local tab = GDatatab_item["id_"..itemId[1]]
    tab.aptitude = giftSkill[1]
    WZLog("HHHHHHHHHHH1:",giftSkill[1] )
    obj:setData(tab, self.tag-1)
    obj:downAction1()
  end
end

function WndPetRaffle:tenPetCall()
	self.m_root:enableSchedule("tenPetCall1",0.6)
end

function WndPetRaffle:tenPetCall1()
	if self.m_root == nil then return end
	self.m_root:disableSchedule()
	self.m_root:enableSchedule("tenPetCall2",0.06)
	local itemId = self.itemId
	local giftSkill = self.giftSkill

    self.t_tenPet = {}
    self.n_actionTag = 0
    for i = 1, 5 do
      local con = GetElement(self.m_root,"conTenPet"..i.."_WndPetRaffle",WZUIContainer)
      con:removeAllChildrenWithCleanup(true)
      local cell,obj = CellPetRaffle:createElement()
      con:addChild(cell)
      local tab = GDatatab_item["id_"..itemId[i]]
      tab.aptitude = giftSkill[i]
      WZLog("HHHHHHHHHHH2:",giftSkill[i] )
      obj:setData(tab, 2)
      table.insert(self.t_tenPet, obj)
      if tab.quality >= 3 then --紫宠
        self.needWeChat = true
      end
    end
	for i=1,5 do
		self:tenPetDown1()
	end
	for i=1,5 do
      	self.t_tenPet[i]:openAction(i)
	end
	--WndPetRaffle:tenPetOpen()

    local imgTenRafType = GetElement(self.m_root,"imgTenRafType_WndPetRaffle",WZUIImage)
    local txtTenRafCount = GetElement(self.m_root,"txtTenRafCount_WndPetRaffle",WZUILabelTTF)
    local txtTenRafAgain = GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF)
    if self.tag == 1 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4]) >= tonumber(self.m_tPetDate[2][4]*10) then
      self.note = 2
      imgTenRafType:setFile("ui/common/common_icon_dk.png")
      imgTenRafType:setScale(0.5)
      txtTenRafCount:setText(self.m_tPetDate[2][4]*10)
      txtTenRafAgain:setText(LocalStrings.PETOPENEGE3)
    elseif self.tag == 1 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4]) < tonumber(self.m_tPetDate[2][4]*10) then
      self.note = 1
      imgTenRafType:setFile("ui/common/common_icon_dk.png")
      imgTenRafType:setScale(0.5)
      txtTenRafCount:setText(self.m_tPetDate[2][4])
      txtTenRafAgain:setText(LocalStrings.PETOPENEGE1)
    elseif self.tag == 2 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) >= tonumber(self.m_tPetDate[2][1]*10) then
      self.note = 2
      imgTenRafType:setFile("shopitems/chongwujiang_1.png")
      imgTenRafType:setScale(0.5)
      txtTenRafCount:setText(self.m_tPetDate[2][1]*10)
      txtTenRafAgain:setText(LocalStrings.PETOPENEGE3)
    elseif self.tag == 2 and CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) < tonumber(self.m_tPetDate[2][1]*10) then
      --local conOne = GetElement(self.m_root,"conOne_WndPetRaffle",WZUIContainer)
      --conOne:setVisible(true)
     -- conOne:setRelativePosition(GlobalMethod:ccp(0.244387,0.0572895))
      self.note = 1
      imgTenRafType:setFile("shopitems/chongwujiang_1.png")
      imgTenRafType:setScale(0.5)
      txtTenRafCount:setText(self.m_tPetDate[2][1])
      txtTenRafAgain:setText(LocalStrings.PETOPENEGE4)
    elseif self.tag == 3 then
      self.note = 2
      imgTenRafType:setFile(GDatatab_item["id_" .. self.m_tPetDate[1][3]].icon)
      imgTenRafType:setScale(0.6)
      txtTenRafCount:setText(self.m_tPetDate[2][3])
      txtTenRafAgain:setText(LocalStrings.PETOPENEGE3)
    end
end

function WndPetRaffle:tenPetCall2()
	self.m_root:disableSchedule()

	local itemId = self.itemId
	local giftSkill = self.giftSkill
    for i = 6, 10 do
      local con = GetElement(self.m_root,"conTenPet"..i.."_WndPetRaffle",WZUIContainer)
      con:removeAllChildrenWithCleanup(true)
      local cell,obj = CellPetRaffle:createElement()
      con:addChild(cell)
      local tab = GDatatab_item["id_"..itemId[i]]
      tab.aptitude = giftSkill[i]
      WZLog("HHHHHHHHHHH2:",giftSkill[i] )
      obj:setData(tab, 2)
      table.insert(self.t_tenPet, obj)
      if tab.quality >= 3 then --紫宠
        self.needWeChat = true
      end
    end
	for i=6,11 do
		self:tenPetDown1()
	end
	for i=6,10 do
      	self.t_tenPet[i]:openAction(i)
	end
	WndPetRaffle:tenPetOpen()
end

--@brief    抽取宠物成功
function WndPetRaffle:tenPetDown(elelment)
    self.n_actionTag = self.n_actionTag + 1
    if self.n_actionTag > 10 then
      self.n_actionTag = 1
      self.t_tenPet[1]:openAction()
      elelment:disableSchedule()
      return
    end
    self.t_tenPet[self.n_actionTag]:downAction()
end

function WndPetRaffle:tenPetDown1()
    self.n_actionTag = self.n_actionTag + 1
	WZLog("WndPetRaffle:tenPetDown1", self.n_actionTag)
    if self.n_actionTag > 10 then
      self.n_actionTag = 1
      return
    end
    --self.t_tenPet[self.n_actionTag]:downAction()
end

--@brief    抽取宠物成功
function WndPetRaffle:tenPetOpen()
	if self.m_root == nil then return end
    --self.n_actionTag = self.n_actionTag + 1
    --if self.n_actionTag > 10 then
       local element = GetElement(self.m_root,"conTenPet_WndPetRaffle",WZUIContainer)
      if self.needWeChat then
        addWeChatBtn(element,3,GlobalMethod:ccp(0.88,0.0533334))
      end
      if self.tag == 1 and self.t_freeTime[1] <= 0 then
        self.note = 1
        local imgTenRafType = GetElement(self.m_root,"imgTenRafType_WndPetRaffle",WZUIImage)
        imgTenRafType:setFile("ui/common/common_icon_dk.png")
        imgTenRafType:setScale(0.5)
        GetElement(self.m_root,"txtTenRafCount_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETFREE2)
        GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETOPENEGE1)
      end
      GetElement(self.m_root,"conTenButton_WndPetRaffle",WZUIContainer):setVisible(true)
      GetElement(self.m_root,"conTen_WndPetRaffle",WZUIContainer):setVisible(true)
      --return
    --end
    --self.t_tenPet[self.n_actionTag]:openAction()
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
function WndPetRaffle:showLightBg(luaTable)
    local element = nil
    local element2 = nil 
    if self.n_type ~= 2 then 
      element = GetElement(self.m_root,"imgLightBg_WndPetRaffle",WZUIImage)
      element2 = GetElement(self.m_root,"imgLightBg2_WndPetRaffle",WZUIImage)
    else
      element = GetElement(self.m_root,"imgLightBg3_WndPetRaffle",WZUIImage)
      element2 = GetElement(self.m_root,"imgLightBg4_WndPetRaffle",WZUIImage)
    end
    element:setOpacity(0)
    element:setVisible(true)
    element2:setOpacity(0)
    element2:setVisible(true)
    local actionArray = CCArray:create()
    local actionFadeTo = CCFadeIn:create(1)
    local actionFadeTo2 = CCFadeOut:create(1)
    actionArray:addObject(actionFadeTo)
    actionArray:addObject(CCCallFuncN:create(function() luaTable:showPet() end))
    -- actionArray:addObject(actionFadeTo2)
    -- actionArray:addObject(CCCallFuncN:create(function() element:setVisible(false) end))
    local repH = CCSequence:create(actionArray)
    element2:runAction(CCFadeIn:create(1))
    element:runAction(repH)  
end

function WndPetRaffle:showView()
  if self.n_type ~= 2 then
    if self.n_type == 0 and self.t_freeTime[1] <= 0 then
      self.note = 1
      local imgOneRafType = GetElement(self.m_root,"imgOneRafType_WndPetRaffle",WZUIImage)
      imgOneRafType:setFile("ui/common/common_icon_dk.png")
      imgOneRafType:setScale(0.5)
      GetElement(self.m_root,"txtOneRafCount_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETFREE2)
      GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETOPENEGE1)
    end
    GetElement(self.m_root,"conOnePet_WndPetRaffle",WZUIContainer):setVisible(true)
  else
    GetElement(self.m_root,"conTenPet_WndPetRaffle",WZUIContainer):setVisible(true)
  end
end

function _scalePetTenImg()
     WndPetRaffle.n_actionTag = WndPetRaffle.n_actionTag + 1
     local actionArray = CCArray:create()
     actionArray:addObject(CCScaleTo:create(0.5,1.0,1.0))
     actionArray:addObject(CCCallFuncN:create(_scalePetTenImg))
     local repH = CCSequence:create(actionArray)
     local curTenImg =  GetElement(WndPetRaffle.m_root,"conTenPet"..WndPetRaffle.n_actionTag.."_WndPetRaffle",WZUIContainer)
     if WndPetRaffle.n_actionTag > 9 then
         curTenImg:runAction(CCScaleTo:create(0.5,1.0,1.0))
     else
         curTenImg:runAction(repH)
     end
end


-------------------------------------私有方法模块End----------------------------------------
