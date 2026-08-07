--WndPetRecover.lua
--@brief	WndPetRecover的UI模块
--@date		2016/11/17
--@author	zhangming
--@note		宠物回收 


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetRecover:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetRecover:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndPetRecover:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
    AdaptLanguage(self)
end

--@brief  窗口动画完成回调
function WndPetRecover:actionCallback(elem,data)
   self:setPetList()
   GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.t_choiceList.."/16")
  --petAni:getAnimNode():setScale(1.5)    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetRecover:onCloseClick(element)
	WZLog("WndPetRecover:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndPets.m_tCurPetsInfo = nil
    WndPets:doRefresh()
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndPetRecover:checkPetSpill()
	if #self.t_choiceList <16 then
		return true
	else
		return false
	end
end

function WndPetRecover:recycleSucc()
	self:closeLoadingBox()
  	self:setPetList()
	self.t_choiceList = {}
	self:upChoiceList()
end

--@brief  初始化宠物列表
function WndPetRecover:setPetList()
  	WZLog("WndPetRecover:setPetList")
  	local tableList = GetElement(self.m_root,"conPetList_WndPetRecover",WZUITableContainer)
	tableList:setLoadCountPerFrame(4)
  	if tableList == nil then
        return
  	end
  	tableList:cleanTable()
  	local pets = self:findMatchPets()
  	WZLog("WndPetRecover:findMatchPets22:",#pets)
  	table.sort( pets, sortUpPets)
  	WZLog("WndPetRecover:findMatchPets_0",Serialize(pets))
  	GetElement(self.m_root,"txtNoPet_WndPetRecover", WZUILabelTTF):setVisible(#pets <= 0)
  	if #pets <= 0 then
  	  	return
  	end
  	self.t_PetList = {}
  	for i=1,#pets do
  	  	local celElement , tCell = CellPetSell:createElement()
  	  	celElement = WZUIContainer:luaTo(celElement)
  	  	celElement:setTag(i-1)
  	  	tCell:setData(pets[i])
  	  	tableList:setCellElement(celElement)
  		table.insert(self.t_PetList,tCell)
  	end 
  	tableList:getMoveElement():setPositionY(tableList:getMinPosition().y)
end

--@brief   查找所有符合升级可以吞噬的宠物
function WndPetRecover:findMatchPets()
	WZLog("WndPetRecover:findMatchPets")
	local cachePets = CacheCenter:getPlayerPetInfo()
	local m_tMatchPets = {}
	for k,v in pairs(cachePets) do
		local tItem = GDatatab_item["id_"..v.itemId]
    WZLog("WndPetRecover:findMatchPets:", v.itemId,tItem.recycle, v.upgradeLevel, v.advancedLevel)
		if v.isInUsed == false and tItem.recycle == 1 and v.upgradeLevel <= 1 and v.advancedLevel <= 0 then --and v.upgradeLevel <= 1 
		   table.insert(m_tMatchPets,v)
		end
	end
	return m_tMatchPets
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
function WndPetRecover:onRecover(element)
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  	
    local bHavePhantomPet = false 
  	for k ,v in pairs(self.t_choiceList) do
      	if v.petSkinItemId and v.petSkinItemId > 0 then
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

--@brief  继续回收
function WndPetRecover:continueToExtranction()
    -- body
    local VansPriceID = WZLuaVector_int_:create()
    local VansNum = WZLuaVector_int_:create()
    for k ,v in pairs(self.t_choiceList) do
        VansPriceID:push(v.playerPetId)
        VansNum:push(1)
    end
    self:createLoadingBox()
    ProtocolProcessorScenePets:send_PET_RecyclePet(VansPriceID, VansNum)
end

--@brief  快速选择
function WndPetRecover:onQuickChoice(element)
  	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local find = false
  	for i = 1, math.min(#self.t_PetList, 16) do
		local f = self.t_PetList[i]:doQuickRecover()
  	  	find = find or f
  	end
	if not find then
		if #self.t_choiceList == 16 then
			MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT8)
		else
			MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT5)
		end
	end
  	if #self.t_PetList > 0 then
  	  	for i = 1, #self.t_PetList do
  	  	  	if GDatatab_item["id_"..self.t_PetList[i]:getPetInfo().itemId].quality < 3 then
  	  	  	  return
  	  	  	end
  	  	end
  	  	MsgBoxManager:showTipBox(LocalStrings.PET_HIGH_QULITY)
  	end
end


--@brief   宠物列表排序
function sortUpPets(a,b)
  local aQuality = GDatatab_item["id_"..a.itemId].quality
  local bQuality = GDatatab_item["id_"..b.itemId].quality
  if aQuality == bQuality then
       return a.giftSkill < b.giftSkill        
  else
       return aQuality < bQuality
  end
end

--@brief 检测是否还有选取栏可以选取宠物
function WndPetRecover:addChoicePet(bAdd,petInfo)
  WZLog("WndPetRecover:addChoicePet:",bAdd, Serialize(petInfo))
  if bAdd then
    	table.insert(self.t_choiceList, petInfo)
  else
    	for i= 1, #self.t_choiceList do
    		if self.t_choiceList[i].playerPetId == petInfo.playerPetId then
    			table.remove(self.t_choiceList,i)
          break
    		end
    	end
  end
  WZLog("WndPetRecover:addChoicePet:",#self.t_choiceList) 
  self:upChoiceList()
end

--@brief	开始按下回调函数
function WndPetRecover:onTouchBegin(element,pt)
	WZLog("WndPetRecover:onTouchBegin",pt.x,pt.y)
	WndItemInfo:onCloseClick()
end

--@brief 刷新列表
function WndPetRecover:upChoiceList()
  WZLog("WndPetRecover:upChoiceList:",#self.t_choiceList)
  GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.t_choiceList.."/16")
  local t_eatPets = {}
  for k, v in pairs(self.t_choiceList) do
    local bAdd = true
    local itemId = v.itemId
     WZLog("upChoiceList333:", itemId)
  	local cost = GDatatab_item["id_"..itemId].recycleMess
    for k1, v1 in pairs(t_eatPets) do
      if cost[1][1] == v1.id then
        v1.num =  v1.num + cost[1][2]
        bAdd = false
        break
      end
    end
    if bAdd then
      local addPet = {}
      addPet.id = cost[1][1]
      addPet.num = cost[1][2]
      table.insert(t_eatPets, addPet)
    end
  end
  WZLog("upChoiceList:", Serialize(t_eatPets))
  self:setGetList(t_eatPets)
end

--@brief 设置获得的列表
function WndPetRecover:setGetList(getList)
		--清空获得列表
	local tableConLeft = WZUITableContainer:luaTo(self.m_root:getChildElement("tableCon_WndPetRecover"))
	tableConLeft:cleanTable()
	for i=1,#getList do
    	local key = "id_"..getList[i].id
    	if GDatatab_item[key] ~= nil then
	        local name = GDatatab_item[key].name
	        local path = GDatatab_item[key].icon
	        local num =  getList[i].num
	        local quality = GDatatab_item[key].quality
	        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			local cellElement,tCell = CellGoodItem:createElement()
			tCell:setCellGoodItem(itemInfo,10)
			tCell:setItemClickFun(self,self.onClickCallback2)
			cellElement:setTag(i-1)
			tableConLeft:setCellElement(cellElement)
    	end
	end
end

--@brief  点击回收获得物品，显示tips
function WndPetRecover:onClickCallback2(tCell,tag,tData)
  WZLog("WndPetRecover:onClickCallback2")
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData)
end

function WndPetRecover:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    end
end

function WndPetRecover:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndPetRecover:_adaptLanguage_vn(  )
  GetElement(self.m_root,"txtBtn1_WndPetRecover",WZUILabelTTF):setScale(0.8)
  GetElement(self.m_root,"txtBtn2_WndPetRecover",WZUILabelTTF):setScale(0.8)
  GetElement(self.m_root,"txtChoicePet_WndPetRecover",WZUILabelTTF):setScale(0.8)
end

function WndPetRecover:_adaptLanguage_en(  )
  GetElement(self.m_root,"txtBtn1_WndPetRecover",WZUILabelTTF):setScale(0.73)

  local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF)
  txtChoiceNum:setScale(0.65)
  txtChoiceNum:setDimensions(GlobalMethod:CCSize(300))
  local txtChoicePet = GetElement(self.m_root,"txtChoicePet_WndPetRecover", WZUILabelTTF)
  txtChoicePet:setScale(0.7)
  txtChoicePet:setDimensions(GlobalMethod:CCSize(290))
end

function WndPetRecover:_adaptLanguage_pt(  )
  local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndPetRecover",WZUILabelTTF)
  txtBtn1:setScale(0.7)
  txtBtn1:setDimensions(GlobalMethod:CCSize(110))
  GetElement(self.m_root,"txtBtn2_WndPetRecover",WZUILabelTTF):setScale(0.9)

  local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF)
  txtChoiceNum:setScale(0.65)
  txtChoiceNum:setDimensions(GlobalMethod:CCSize(300))
  local txtChoicePet = GetElement(self.m_root,"txtChoicePet_WndPetRecover", WZUILabelTTF)
  txtChoicePet:setScale(0.7)
  txtChoicePet:setDimensions(GlobalMethod:CCSize(290))
end

function WndPetRecover:_adaptLanguage_es(  )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndPetRecover",WZUILabelTTF)
    txtBtn1:setDimensions(GlobalMethod:CCSize(130,0))
    txtBtn1:setScale(0.78)
    
  local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF)
  txtChoiceNum:setScale(0.65)
  txtChoiceNum:setDimensions(GlobalMethod:CCSize(300))
  local txtChoicePet = GetElement(self.m_root,"txtChoicePet_WndPetRecover", WZUILabelTTF)
  txtChoicePet:setScale(0.7)
  txtChoicePet:setDimensions(GlobalMethod:CCSize(290))
end

function WndPetRecover:_adaptLanguage_tr(  )
  GetElement(self.m_root,"txtBtn1_WndPetRecover",WZUILabelTTF):setScale(0.8)

  GetElement(self.m_root,"imgArrow1_WndPetRecover",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
  GetElement(self.m_root,"imgArrow2_WndPetRecover",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.78,0.5))

  local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndPetRecover", WZUILabelTTF)
  txtChoiceNum:setScale(0.65)
  txtChoiceNum:setDimensions(GlobalMethod:CCSize(300))
  local txtChoicePet = GetElement(self.m_root,"txtChoicePet_WndPetRecover", WZUILabelTTF)
  txtChoicePet:setScale(0.7)
  txtChoicePet:setDimensions(GlobalMethod:CCSize(290))
end
-------------------------------------语言适配End--------------------------------------------
