--WndLotteryShow.lua
--@brief	WndLotteryShow的UI模块
--@date		2021/05/20
--@author	hyc
--@note		抽奖结果展示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLotteryShow:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll4()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLotteryShow:onExit(element)
	if self.m_root then 
		local spineBg = GetElement(self.m_root, "spineBg_WndLotteryShow", WZUISpine) 
		spineBg:disableSchedule()
	end
	self:_unInit()
	WndEquipLottery.m_lotteryShowTag = nil
	WndPetLottery.m_lotteryShowTag = nil
	WndMountLottery.m_lotteryShowTag = nil
	WndPhantomLottery.m_lotteryShowTag = nil
	WndFootLottery.m_lotteryShowTag = nil
	WndPetEquipLottery.m_lotteryShowTag = nil
	-- ProtocolProcessorWndRankList:unregAll()
end

--@brief    加载界面完成回调
function WndLotteryShow:onEnterTransitionDidFinish(element)
    SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)
    
		self:_setBallAni()
		self.m_nParticleRemoveIndex = 0
		self.m_nRewardCount = #self.n_itemId
    local spineBg = GetElement(self.m_root, "spineBg_WndLotteryShow", WZUISpine)
    local spinePath2 = "ui/otherUI/choujiang"
		local existSpine2 = CheckEffectFile(spinePath2)
		if existSpine2 then 
   	 		spineBg:enableSchedule("event", 4.5)
   	else
   		self:event(element)
   	end
end

--@brief 	spine动画
function WndLotteryShow:event(element)
	-- body
	WZLog("spine动画")
	local spineBg = GetElement(self.m_root, "spineBg_WndLotteryShow", WZUISpine) 
	spineBg:disableSchedule()
	--if spineBg:isCurrentAnimationDone() then 
	    local conBg = GetElement(self.m_root, "conBg_WndLotteryShow", WZUIContainer)
		local winSize = CCDirector:sharedDirector():getWinSize()

		local posXList = GetRandomNum(10, winSize.width, 0)
		self.m_tTargetPoint = {}
		for i = 1, #posXList do
			table.insert(self.m_tTargetPoint, {posXList[i], winSize.height + 200})
		end
		conBg:enableSchedule("_displayTrainParticle", 0.01)
	--end
end

--@brief 	弹窗加载后回调
function WndLotteryShow:actionCallback()
	-- body
	WZLog("加载界面",Serialize(self.n_highCount))
	-- if self.n_highCount ~= {} and self.n_highCount ~= nil then
	-- 	self:showHighQuality()
	-- else 
		if #self.n_itemId > 1 then
			self:showTenLottery()
		else 
			self:showOneLottery() 
		end
--	end
end

--@brief 调整星级数量
--@param nNum:宠物的品质
function WndLotteryShow:getAptitude(nNum)
  WZLog("WndLotteryShow:getAptitude:", nNum)
  local nGift = math.ceil(nNum/100)
  local tab = GDatatab_petStar
  for k,v in pairs(tab) do
    local gift = v.gift
    if  nGift >  gift[1][1] and nGift <= gift[1][2] then
      WZLog("WndLotteryShow:getAptitude:", nGift, v.id)
      return v.id
    end
  end
  return 1
end

--@brief 调整星级位置
function WndLotteryShow:setAptitudePost(root, elementName, nNum)
  if root == nil or elementName == nil then
     return
  end
  local element = GetElement(root,elementName,WZUIContainer)
  local pos = element:getRelativePosition()
  if nNum % 2 == 0 then
    element:setRelativePosition(GlobalMethod:ccp(0.54,pos.y))
  else
    element:setRelativePosition(GlobalMethod:ccp(0.5,pos.y))
  end
end

--@展示高品质物品
function WndLotteryShow:showHighQuality()
	WZLog("WndLotteryShow:showHighQuality")

	GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(false)

	self.n_haveShow = self.n_haveShow + 1
	local conHight = GetElement(self.m_root,"conHigh_WndLotteryShow",WZUIContainer)
	conHight:setVisible(true)
	GetElement(self.m_root, "conTen_WndLotteryShow", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conOne_WndLotteryShow", WZUIContainer):setVisible(false)

	local txtHighDesc = GetElement(self.m_root,"txtHighDesc",WZUILabelTTF)
	local shareReward = json.decode(CacheCenter:getGameParam()["rewardDrawShare"])
	WZLog("分享奖励",Serialize(shareReward))
	txtHighDesc:setText(string.format(LocalStrings.LOTTERY_TEXT6,shareReward[2]))

	if self.n_haveShow > #self.n_highCount then
		conHight:setVisible(false)
		if #self.n_itemId > 1 then
			self:showTenLottery()
			return
		else 
			self:showOneLottery()
			return
		end
	end
	local imgTitle = GetElement(self.m_root,"imgTitle_WndLotteryShow",WZUIImage)
	imgTitle:setFile("ui/common/bt_text_xydj.png")
	local conShow = GetElement(self.m_root,"conShow_WndLotteryShow",WZUIContainer)
	-- if conShow:getChildByTag(99) then conShow:removeChildByTag(99,true) end
	conShow:removeAllChildrenWithCleanup(true)

	local id = self.n_highCount[self.n_haveShow]
	local highName = GetElement(self.m_root,"txtHighName_WndLottery",WZUILabelTTF)
	local highNameValue = GDatatab_item["id_"..id].name
	highName:setText(highNameValue)
	local colorType = {ccc3(255,255,255),ccc3(99,255,95),ccc3(93,222,254),ccc3(198,130,255),ccc3(233,166,62), ccc3(255,89,74),ccc3(255,0,0)}
	highName:setColor(colorType[GDatatab_item["id_"..id].quality + 1])

	local tData = GDatatab_total_draw
	local info = {}
	if self.n_type ~= 4 then
		for k,v in pairs(tData) do
			if v.item_id[1][1] == self.n_highCount[self.n_haveShow] and v.type == self.n_type then
				table.insert(info,v)
			end
		end
	else 
		local sex = CacheCenter:getPlayerInfo().sex
		local m_Data = {}
		for k,v in pairs(tData) do
			if v.type == 4 then
				table.insert(m_Data,v)
			end
		end
		for k,v in pairs(m_Data) do
			if GDatatab_item["id_"..v.item_id[1][1]].main_type == 20 then
				if v.item_id[sex+1][1] == self.n_highCount[self.n_haveShow] and v.type == self.n_type then
					table.insert(info,v)
				end
			else 
				if v.item_id[1][1] == self.n_highCount[self.n_haveShow] and v.type == self.n_type then
					table.insert(info,v)
				end
			end
			-- if v.batch_pink ~= 0 or v.batch_blue ~= 0 then
			-- 	if v.item_id[sex + 1][1] == self.n_highCount[self.n_haveShow] and v.type == self.n_type then
			-- 		table.insert(info,v)
			-- 	end	
			-- else
			-- 	if v.item_id[sex + 1][1] == self.n_highCount[self.n_haveShow] and v.type == self.n_type then
			-- 		table.insert(info,v)
			-- 	end			
			-- end
		end 
	end   				

	WZLog("展示的高品质物品信息",Serialize(info))
	if self.n_type == 1 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 4 or GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 37 then
				imgTitle:setFile("ui/common/bt_text_xyzb.png")
			else 
				imgTitle:setFile("ui/common/bt_text_xydj.png")
			end
			
			local key = "id_"..info[i].item_id[1][1]
			local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = info[i].item_id[1][2]
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 15)
		    celElement:setScale(0.8)
			conShow:addChild(celElement)
		end
	elseif self.n_type == 2 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 10 then
				imgTitle:setFile("ui/common/bt_text_xycw.png")
				local petAni = CreatePetAni(conShow, nil, GDatatab_item["id_"..info[i].item_id[1][1]].animation_index_code)
				local index = 0
				for j = 1,#self.n_itemId do 
					WZLog("展示高品质宠物",info[i].item_id[1][1],self.n_itemId[j])
					if info[i].item_id[1][1] == self.n_itemId[j] then
						index = j
						break
					end
				end
			    -- local aptitude = self:getAptitude(self.m_natural[index])
			    -- for i = 1, 7 do
			    --     GetElement(self.m_root,"imgAptitude"..i.."_WndPets",WZUIImage):setVisible(i <= aptitude)
			    -- end
			    -- self:setAptitudePost(conShow, "conAptitude_WndPets", aptitude)
			else 
				imgTitle:setFile("ui/common/bt_text_xydj.png")
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
				conShow:addChild(celElement)
			end
		end
	elseif self.n_type == 3 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 11 then
				imgTitle:setFile("ui/common/bt_text_xyzq.png")
				self:_createMountAni(conShow,info[i])
			else
				imgTitle:setFile("ui/common/bt_text_xydj.png")
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
				conShow:addChild(celElement)				
			end 

		end
	elseif self.n_type == 4 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 20 then
				imgTitle:setFile("ui/common/bt_text_xypf.png")
				self:showPlayer(conShow,info[i])
			else 
				imgTitle:setFile("ui/common/bt_text_xydj.png")
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
				conShow:addChild(celElement)
			end 				
		end
	elseif self.n_type == 5 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 23 then
				imgTitle:setFile("ui/common/bt_text_xyzj.png")
				for k,v in pairs(GDatatab_footmark) do
					if v.item_id == info[i].item_id[1][1] then
						local m_sRoleSpine = FootEffectManager:addEffect1(conShow,v.id,{x=130,y=50 },true)
						m_sRoleSpine:setRelativePosition(GlobalMethod:ccp(0.5 ,0))
						break 
					end
				end
			else 
				imgTitle:setFile("ui/common/bt_text_xydj.png")
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
				conShow:addChild(celElement)
			end 				
		end		
	elseif self.n_type == 6 then
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 43 then
				imgTitle:setFile("ui/common/bt_text_xyzb.png")
			else 
				imgTitle:setFile("ui/common/bt_text_xydj.png")
			end
			
			local key = "id_"..info[i].item_id[1][1]
			local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = info[i].item_id[1][2]
		    local extraInfo = nil
		    if self.m_data[i] and self.m_data[i] ~= "" then
		    	extraInfo = json.decode(self.m_data[i])
		    	extraInfo.randAttr = json.decode(extraInfo.randAttr)
	    	end
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),extraInfo=extraInfo}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 15)
		    tLuaObj:_showItemNum()
		    celElement:setScale(0.8)
			conShow:addChild(celElement)
		end		
	end
end

function WndLotteryShow:onCloseHighShow(element)
	if self.m_bIsClickTenSkip then
		if self.n_haveShow < #self.n_highCount then
			self:showHighQuality()
			return
		else
			if self.m_nRewardCount > 1 then 
				GetElement(self.m_root, "conTenAllInfo_WndLotteryShow", WZUIContainer):setVisible(true)
			else
				GetElement(self.m_root, "conOneAllInfo_WndLotteryShow", WZUIContainer):setVisible(true)
			end

			GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(false)

			pushEquipInList()
			g_bIsShowWndDressUp = true
		end
	else
		self:_displayDropParticle()
	end

	GetElement(self.m_root,"conHigh_WndLotteryShow",WZUIContainer):setVisible(false)
	if self.m_nRewardCount > 1 then 
		GetElement(self.m_root,"conTen_WndLotteryShow",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "conOne_WndLotteryShow", WZUIContainer):setVisible(true)
	end

	if not self.m_bIsClickTenSkip then
		GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(true)
	end
end

--@brief 根据宠物Id获取宠物类型图标
function WndLotteryShow:getTypeById(petId)
  WZLog("WndPets:getTypeById:",petId)
  local petType = 0
  for k, v in pairs(GDatatab_pet) do
    if v.item_id == petId then
      petType = v.id_type
    end
  end
  if petType == 1 then --生命
    return "ui/common/common_cw_xue.png"
  elseif petType == 2 then --攻击
    return "ui/common/common_cw_gong.png"
  elseif petType == 3 then --防御
    return "ui/common/common_cw_fang.png"
  elseif petType == 4 then --均衡
    return "ui/common/common_cw_jun.png"
  elseif petType == 5 then --经验
    return "ui/common/common_cw_exp.png"
  end
  return ""
end

--@单次抽奖展示页面
function WndLotteryShow:showOneLottery()
	-- body\
	WZLog("WndLotteryShow:showOneLottery")
	local mountDrawConfig
	local txtName = GetElement(self.m_root,"conOneName_WndLotteryShow",WZUILabelTTF)
	local itemKey = "id_"..self.n_itemId[1]
	local name1 = GDatatab_item[itemKey].name
	txtName:setText(name1)
	local colorType = {ccc3(255,255,255),ccc3(99,255,95),ccc3(93,222,254),ccc3(198,130,255),ccc3(233,166,62), ccc3(255,89,74),ccc3(255,0,0)}
	txtName:setColor(colorType[GDatatab_item[itemKey].quality + 1])
	local petTypeBg = GetElement(self.m_root,"petTypeBg",WZUIImage)
	petTypeBg:setVisible(false)

	local conTexiao = GetElement(self.m_root,"conTexiao_WndlotteryShow",WZUIContainer)
	conTexiao:setVisible(false)
	local conBg = GetElement(self.m_root,"conOneBg_WndLotteryShow",WZUIImage)
	conBg:setVisible(false)
	local drawQuality = 0
	local basicInfo = GDatatab_item[itemKey]
	if self.n_type == 3 and basicInfo.main_type == 38 and basicInfo.sub_type >= 9 and basicInfo.sub_type <= 13 then 
		if self.m_natural[1] >= 1 and self.m_natural[1] <= 49 then
			drawQuality = 1
		elseif self.m_natural[1] >= 50 and self.m_natural[1] <= 79 then
			drawQuality = 2
		elseif self.m_natural[1] >= 80 and self.m_natural[1] <= 94 then
			drawQuality = 3
		elseif self.m_natural[1] >= 95 and self.m_natural[1] <= 100 then
			drawQuality = 4
		end
		txtName:setColor(colorType[drawQuality + 1])
	else
		for k,v in pairs(GDatatab_total_draw) do
			if v.item_id[1][1] == self.n_itemId[1] and v.item_id[1][2] == self.n_num[1] then
				drawQuality = v.quality
			end
		end
	end
	if drawQuality == 1 then
		conBg:setVisible(true)
		conBg:setFile("ui/common/common_icon_lg.png")
	elseif drawQuality == 2 then
		conBg:setVisible(true)
		conBg:setFile("ui/common/common_icon_ng.png")
	elseif drawQuality == 3 then
		conBg:setVisible(true)
		conBg:setFile("ui/common/common_icon_zg.png")	
	elseif drawQuality == 4 then
		conBg:setVisible(true)
		conBg:setFile("ui/common/common_icon_hg.png")
	elseif drawQuality >= 5 then
		conTexiao:setVisible(true)
	end 


	local txtOne = GetElement(self.m_root,"txtOneCost_WndLotteryShow",WZUIFreeTextBox)
	local txtBtnOne = GetElement(self.m_root,"txtBtnOne",WZUILabelTTF)
	local iconPath1,costOneNum,coinNum
	if self.n_type == 1 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])

		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndEquipLottery.m_tag == 1 then
			coinNum = CacheCenter:getPlayerItemCountById(otherId1)
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			if coinNum >= otherNum1 * 10 then
				costOneNum = otherNum1 * 10
				txtBtnOne:setText(LocalStrings.TEN_LOTTERY)
			else 
				WZLog("单次抽")
				costOneNum = otherNum1
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			end
		elseif WndEquipLottery.m_tag == 2 then
			coinNum = CacheCenter:getPlayerItemCountById(otherId2)
			if coinNum >= otherNum2 then
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			else 
				coinNum = CacheCenter:getPlayerItemCountById(pinkId1)
				iconPath1 = GDatatab_item["id_"..pinkId1].icon
				costOneNum = pinkNum1
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			end
		end
	elseif self.n_type == 2 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])

		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndPetLottery.m_tag == 1 then
			coinNum = CacheCenter:getPlayerItemCountById(otherId1)
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			if coinNum >= otherNum1 * 10 then
				costOneNum = otherNum1 * 10
				txtBtnOne:setText(LocalStrings.TEN_LOTTERY)
			else 
				costOneNum = otherNum1
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			end
		elseif WndPetLottery.m_tag == 2 then
			coinNum = CacheCenter:getPlayerItemCountById(otherId2)
			if coinNum >= otherNum2 then
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			else 
				coinNum = CacheCenter:getPlayerItemCountById(pinkId1)
				iconPath1 = GDatatab_item["id_"..pinkId1].icon
				costOneNum = pinkNum1
				txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
			end
		end
	elseif self.n_type == 3 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndMountLottery.m_usePinkDiamond then
			iconPath1 = GDatatab_item["id_"..pinkId1].icon
			costOneNum = pinkNum1
		else
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			costOneNum = otherNum1
		end
		txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
	elseif self.n_type == 4 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["skinDrawConfig"])
		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndPhantomLottery.m_usePinkDiamond then
			iconPath1 = GDatatab_item["id_"..pinkId1].icon
			costOneNum = pinkNum1
		else
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			costOneNum = otherNum1
		end
		txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
	elseif self.n_type == 5 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["footprintDrawConfig"])
		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndFootLottery.m_usePinkDiamond then
			iconPath1 = GDatatab_item["id_"..pinkId1].icon
			costOneNum = pinkNum1
		else
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			costOneNum = otherNum1
		end
		txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
	elseif self.n_type == 6 then
		local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
		local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])		
		local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
		local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

		local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
		local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
		local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

		if WndPetEquipLottery.m_usePinkDiamond then
			iconPath1 = GDatatab_item["id_"..pinkId1].icon
			costOneNum = pinkNum1
		else
			iconPath1 = GDatatab_item["id_"..otherId1].icon
			costOneNum = otherNum1
		end
		txtBtnOne:setText(LocalStrings.ONE_LOTTERY)
	end
	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]

	local conTxtOne = GetElement(self.m_root,"conOneText_WndLotteryShow",WZUIContainer)
	local txtOneHave = GetElement(self.m_root,"txtOneHave_WndLotteryShow",WZUIFreeTextBox)
	local txtOneRepeat = GetElement(self.m_root,"txtOneRepeat_WndLotteryshow",WZUILabelTTF)
	local conOne = GetElement(self.m_root,"conOne_WndLotteryShow",WZUIContainer)
	conOne:setVisible(true)
	local tokenNum = 0
	if self.n_tokenNum and next(self.n_tokenNum) then
		for i = 1,#self.n_tokenNum do
			tokenNum = tokenNum + self.n_tokenNum[i]
		end
	end
	if tokenNum > 0 then
		local iconP = GDatatab_item["id_"..self.n_tokenId[1]].icon
		conTxtOne:setVisible(true)
		txtOneHave:setShowText(string.format(LocalStrings.LOTTERY_TEXT2,tokenNum,iconP))	
	else 
		conTxtOne:setVisible(false)
	end	

	local conOneShow = GetElement(conOne,"conOneShow_WndLotteryShow",WZUIContainer)
	local tData = GDatatab_total_draw
	local info = {}
	WZLog("单次抽奖展示页面",Serialize(self.n_itemId))
	for i = 1,#self.n_itemId do
		for k,v in pairs(tData) do
			WZLog("---:",v.item_id[1][1],self.n_itemId[i])
			if v.item_id[1][1] == self.n_itemId[i] and v.item_id[1][2] == self.n_num[i] and v.type == self.n_type then
				table.insert(info,v)
				break 
			end
		end
	end
	if self.n_type == 1 then
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
		for i = 1,#info do
			local key = "id_"..info[i].item_id[1][1]
			local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = info[i].item_id[1][2]
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 15)
		    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
		    celElement:setScale(0.8)
		    celElement:setTag(99)
			conOneShow:addChild(celElement)
		end			
	elseif self.n_type == 2 then
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 10 then
				local petAni = CreatePetAni(conOneShow, nil, GDatatab_item["id_"..info[i].item_id[1][1]].animation_index_code)
				 petTypeBg:setFile(self:getTypeById(info[i].item_id[1][1]))
				 petTypeBg:setVisible(true)
			    local aptitude = self:getAptitude(self.m_natural[1])
			    for i = 1, 7 do
			        GetElement(self.m_root,"conAptitudeOne"..i.."_WndPets",WZUIImage):setVisible(i <= aptitude)
			    end
			    self:setAptitudePost(self.m_root, "conAptitudeOne_WndPets", aptitude)
			else 
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
			    celElement:setScale(0.8)
			    celElement:setTag(99)
				conOneShow:addChild(celElement)
			end
		end
	elseif self.n_type == 3 then
		txtOneRepeat:setText(LocalStrings.LOTTERY_TEXT1)
		WZLog("单次抽奖展示页面3",Serialize(info))
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 11 then
				self:_createMountAni(conOneShow,info[i])
			else 
					local key = "id_"..info[i].item_id[1][1]
					local basicData = GDatatab_item[key]
					local name = basicData.name
			    local path = basicData.icon
			    local quality = basicData.quality
			    local num = info[i].item_id[1][2]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(basicData)}
					if basicData.main_type == 38 and basicData.sub_type >= 9 and basicData.sub_type <= 13 then 
							itemInfo.extraInfo = {}
							itemInfo.extraInfo.spriteStoneQuality = self.m_natural[1]
					end
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
			    celElement:setTag(99)
					conOneShow:addChild(celElement)
			end
		end
	elseif self.n_type == 4 then
		WZLog("单次抽奖展示页面4",Serialize(info))
		txtOneRepeat:setText(LocalStrings.LOTTERY_TEXT8)
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["skinDrawConfig"])
		local sex = CacheCenter:getPlayerInfo().sex
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 20 then
				self:showPlayer(conOneShow,info[i])
			else 
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
			    celElement:setScale(0.8)
			    celElement:setTag(99)
				conOneShow:addChild(celElement)
			end
		end
	elseif self.n_type == 5 then
		WZLog("单次抽奖展示页面5",Serialize(info))
		txtOneRepeat:setText(LocalStrings.LOTTERY_TEXT9)
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["footprintDrawConfig"])
		for i = 1,#info do
			if GDatatab_item["id_"..info[i].item_id[1][1]].main_type == 23 then
				for k,v in pairs(GDatatab_footmark) do
					if v.item_id == info[i].item_id[1][1] then
						local m_sRoleSpine = FootEffectManager:addEffect1(conOneShow,v.id,{x=130,y=50 },true)
						m_sRoleSpine:setRelativePosition(GlobalMethod:ccp(0.5 ,0))
						break 
					end
				end
			else 
				local key = "id_"..info[i].item_id[1][1]
				local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = info[i].item_id[1][2]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
			    tLuaObj:setCellGoodItem(itemInfo, 15)
			    celElement:setScale(0.8)
				conOneShow:addChild(celElement)
			end 				
		end
	elseif self.n_type == 6 then
		WZLog("单次抽奖展示页面6",Serialize(info))
		mountDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
		for i = 1,#info do
			local key = "id_"..info[i].item_id[1][1]
			local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = info[i].item_id[1][2]
		    local extraInfo = nil
		    if self.m_data[i] and self.m_data[i] ~= "" then
		    	extraInfo = json.decode(self.m_data[i])
		    	extraInfo.randAttr = json.decode(extraInfo.randAttr)
	    	end
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),extraInfo=extraInfo}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 15)
		    tLuaObj:setItemClickFun(WndLotteryShow,self.onItemClick)
		    tLuaObj:_showItemNum()
		    celElement:setScale(0.8)
		    celElement:setTag(99)
			conOneShow:addChild(celElement)
		end	
	end
	WZLog("单次抽奖配置",Serialize(mountDrawConfig))
	local itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
	-- local costOneId,costOneNum = tonumber(itemId[1]),tonumber(num[1])
	-- local iconPath1 = GDatatab_item["id_"..costOneId].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))

	local conOneOutSize = GetElement(self.m_root, "conOneOutSize_WndLotteryShow", WZUIContainer)
	table.insert(self.m_tRewardElement, conOneOutSize)
	conOneOutSize:setVisible(false)
end

function WndLotteryShow:onItemClick(tCell,tag,tData)
	-- body
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndLotteryShow.m_root,1,tData,false,nil,true)	
end

function WndLotteryShow:showTenLottery()
	-- body
	WZLog("WndLotteryShow:showTenLottery1",Serialize(self.n_itemId))
	local mountDrawConfig
	local conTen = GetElement(self.m_root,"conTen_WndLotteryShow",WZUIContainer)
	conTen:setVisible(true)
	local tabTen = GetElement(conTen,"tabTen_WndLotteryShow",WZUITableContainer)
	tabTen:cleanTable()

	local conTxtOne = GetElement(self.m_root,"conTenText_WndLotteryShow",WZUIContainer)
	local txtOneHave = GetElement(self.m_root,"txtTenHave_WndLotteryShow",WZUIFreeTextBox)
	local txtTenRepeat = GetElement(self.m_root,"txtTenRepeat_WndLotteryshow",WZUILabelTTF)
	local txtBtnTen = GetElement(self.m_root,"txtBtnTen",WZUILabelTTF)
	local tokenNum = 0
	local index = 0
	local iconPath1,costOneNum,coinNum
	if self.n_tokenNum and next(self.n_tokenNum) then
		for i = 1,#self.n_tokenNum do
			tokenNum = tokenNum + self.n_tokenNum[i]
		end
	end
	if tokenNum > 0 then
		for i=1,#self.n_tokenId do
			if self.n_tokenId[i] ~= 0 then
				index = i
			end
		end
		local iconP = GDatatab_item["id_"..self.n_tokenId[index]].icon
		conTxtOne:setVisible(true)
		txtOneHave:setShowText(string.format(LocalStrings.LOTTERY_TEXT2,tokenNum,iconP))	
	else 
		conTxtOne:setVisible(false)
	end	

	local tData = GDatatab_total_draw
	local index = 1
	if self.n_type == 1 then
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

			if WndEquipLottery.m_tag == 1 then 
					coinNum = CacheCenter:getPlayerItemCountById(otherId1)
					if coinNum >= otherNum1 * 10 then
						iconPath1 = GDatatab_item["id_"..otherId1].icon
						costOneNum = otherNum1 * 10 
						txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
					else 
						iconPath1 = GDatatab_item["id_"..otherId1].icon
						costOneNum = otherNum1
						txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					end
			elseif WndEquipLottery.m_tag == 2 then
					coinNum = CacheCenter:getPlayerItemCountById(otherId2)
					if coinNum >= otherNum2 * 10 then
						iconPath1 = GDatatab_item["id_"..otherId2].icon
						costOneNum = otherNum2 * 10 
						txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
					elseif coinNum < otherNum2 * 10 and coinNum >= otherNum2 then
						iconPath1 = GDatatab_item["id_"..otherId2].icon
						costOneNum = otherNum2 
						txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					else 
						coinNum = CacheCenter:getPlayerItemCountById(pinkId1)
						iconPath1 = GDatatab_item["id_"..pinkId1].icon
						costOneNum = pinkNum1
						txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					end
			elseif WndEquipLottery.m_tag == 3 then
					iconPath1 = GDatatab_item["id_"..pinkId2].icon
					costOneNum = pinkNum2
					txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
			end
	elseif self.n_type == 2 then
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])

			if WndPetLottery.m_tag == 1 then 
					coinNum = CacheCenter:getPlayerItemCountById(otherId1)
					if coinNum >= otherNum1 * 10 then
							iconPath1 = GDatatab_item["id_"..otherId1].icon
							costOneNum = otherNum1 * 10 
							txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
					else 
							iconPath1 = GDatatab_item["id_"..otherId1].icon
							costOneNum = otherNum1
							txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					end
			elseif WndPetLottery.m_tag == 2 then
					coinNum = CacheCenter:getPlayerItemCountById(otherId2)
					if coinNum >= otherNum2 * 10 then
						iconPath1 = GDatatab_item["id_"..otherId2].icon
						costOneNum = otherNum2 * 10 
						txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
					elseif coinNum < otherNum2 * 10 and coinNum >= otherNum2 then
						iconPath1 = GDatatab_item["id_"..otherId2].icon
						costOneNum = otherNum2 
						txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					else 
						coinNum = CacheCenter:getPlayerItemCountById(pinkId1)
						iconPath1 = GDatatab_item["id_"..pinkId1].icon
						costOneNum = pinkNum1
						txtBtnTen:setText(LocalStrings.ONE_LOTTERY)
					end
			elseif WndPetLottery.m_tag == 3 then
					iconPath1 = GDatatab_item["id_"..pinkId2].icon
					costOneNum = pinkNum2
					txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
			end
	elseif self.n_type == 3 then
			txtTenRepeat:setText(LocalStrings.LOTTERY_TEXT1)
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])
			if WndMountLottery.m_usePinkDiamond then
				iconPath1 = GDatatab_item["id_"..pinkId2].icon
				costOneNum = pinkNum2
			else 
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2	
			end 		

			txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
	elseif self.n_type == 4 then
			txtTenRepeat:setText(LocalStrings.LOTTERY_TEXT8)
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["skinDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])
			if WndPhantomLottery.m_usePinkDiamond then
				iconPath1 = GDatatab_item["id_"..pinkId2].icon
				costOneNum = pinkNum2
			else 
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2	
			end 	
			txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
	elseif self.n_type == 5 then
			txtTenRepeat:setText(LocalStrings.LOTTERY_TEXT9)
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["footprintDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])
			if WndFootLottery.m_usePinkDiamond then
				iconPath1 = GDatatab_item["id_"..pinkId2].icon
				costOneNum = pinkNum2
			else 
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2	
			end 	
			txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
	elseif self.n_type == 6 then
			mountDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
			local pinkId,pinkNum = SplitItemString(mountDrawConfig["pinkPrice"])
			local pinkId1,pinkNum1 = tonumber(pinkId[1]),tonumber(pinkNum[1])
			local pinkId2,pinkNum2 = tonumber(pinkId[2]),tonumber(pinkNum[2])

			local otherId,otherNum = SplitItemString(mountDrawConfig["bluePrice"])
			local otherId1,otherNum1 = tonumber(otherId[1]),tonumber(otherNum[1])
			local otherId2,otherNum2 = tonumber(otherId[2]),tonumber(otherNum[2])
			if WndPetEquipLottery.m_usePinkDiamond then
				iconPath1 = GDatatab_item["id_"..pinkId2].icon
				costOneNum = pinkNum2
			else 
				iconPath1 = GDatatab_item["id_"..otherId2].icon
				costOneNum = otherNum2	
			end 	
			txtBtnTen:setText(LocalStrings.TEN_LOTTERY)
	end
	if self.n_type ~= 4 then
		for i = 1,#self.n_itemId do
			for k,v in pairs(tData) do
				if self.n_itemId[i] == v.item_id[1][1] and self.n_num[i] == v.item_id[1][2] and self.n_type == v.type then
					local cell,tCell = CellLotteryShow:createElement()
					local tempData = CopyTable(v)

					tempData.m_data = self.m_data[i]

					tCell:setData(self.n_type,tempData)
					if self.n_type == 2 or self.n_type == 3 then --宠物资质、坐骑灵石品质
						tCell:setNatural(self.m_natural[i])
					end
					cell:setTag(i - 1)
					tabTen:setCellElement(cell)

					table.insert(self.m_tRewardElement, cell)
					cell:setVisible(false)
					break 
				end
			end
		end
	else 
		local sex = CacheCenter:getPlayerInfo().sex
		local mData = {}
		for k,v in pairs(tData) do
			if v.type == 4 then
				table.insert(mData,v)
			end
		end
		for i = 1,#self.n_itemId do
			for k,v in pairs(mData) do
				if v.batch_blue ~= 0 or v.batch_pink ~= 0 then
					if self.n_itemId[i] == v.item_id[sex+1][1] and self.n_type == v.type then
						local cell,tCell = CellLotteryShow:createElement()
						tCell:setData(self.n_type,v)
						cell:setTag(i - 1)
						tabTen:setCellElement(cell)

						table.insert(self.m_tRewardElement, cell)
						cell:setVisible(false)
						break 
					end					
				else 
					if self.n_itemId[i] == v.item_id[1][1] and self.n_type == v.type then
						local cell,tCell = CellLotteryShow:createElement()
						tCell:setData(self.n_type,v)
						cell:setTag(i - 1)
						tabTen:setCellElement(cell)

						table.insert(self.m_tRewardElement, cell)
						cell:setVisible(false)
						break 
					end
				end
			end
		end
	end

	local txtOne = GetElement(self.m_root,"txtTenCost_WndLotteryShow",WZUIFreeTextBox)
	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	local itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
	WZLog("继续抽十次",Serialize(itemId),Serialize(num))
	-- local costOneId,costOneNum = tonumber(itemId[2]),tonumber(num[2])
	-- local iconPath1 = GDatatab_item["id_"..costOneId].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))
end

--皮肤动画
function WndLotteryShow:showPlayer(conP,tdata)
	local data = {}
	local playerInfo = CacheCenter:getPlayerInfo()
	local sex = playerInfo.sex
	for k,v in pairs(GDatatab_shape_skins) do
		if v.channel == tdata.item_id[sex+1][1] then
			data = v
		end
	end
	if conP:getChildByTag(99) then conP:removeChildByTag(99,true) end
	local tEquip1 = CacheCenter:getPlayerItems()
	if tEquip1 == nil then return end

	local tEquip = {}
	for k,v in pairs(tEquip1) do
		if v.isUse == true then
			table.insert(tEquip, v)
		end
	end

    -- local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conAni_CellBookItem"))
	--local tData = self.m_tSelectedCell.m_tData
	local showId = data.id
	WZLog("皮肤1")

	local conPlayer
	local isMonster = true
	if isMonster then
   		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
    	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
	end
	conPlayer:setScale(0.6)
	self.conPlayer = conPlayer
    conP:addChild(conPlayer:getAnimNode(),0,99)

end

-- 坐骑动画
function WndLotteryShow:_createMountAni(con,info)
	WZLog("坐骑动画",info.item_id[1][1])
    local sex = CacheCenter:getPlayerInfo().sex == 1 and true or false
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end
	WZLog("坐骑动画1",info.item_id[1][1])
    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    local animation_index_code = GDatatab_item["id_"..info.item_id[1][1]].animation_index_code
    ani:setMount(animation_index_code)
	WZLog("坐骑动画2",info.item_id[1][1])
    local node = ani:getAnimNode()
    node:setScale(0.4)
    node:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    node:setRelativePosition(GlobalMethod:ccp(0.5,0))
    con:addChild(node,0,99)
    -- con:setScale(0)
	WZLog("坐骑动画3",info.item_id[1][1])
    local scaleTo = CCScaleTo:create(0.5,1,1)

    con:runAction(scaleTo)
end
--@分享
function WndLotteryShow:onClickShare(element)
	-- body
	WZLog("点击分享")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local key = "id_"..self.n_highCount[self.n_haveShow]
	local name = GDatatab_item[key].name
	ProtocolProcessorWndRankList:send_PLAYER2_ShareLotteryReward(self.n_type,name)

	self:onCloseHighShow(element)
end

--@brief 继续抽奖
function WndLotteryShow:onContinueOne(element)
	local tag = element:getTag()
	local consumeType = 1
	if self.n_type == 1 then		
		tag = WndEquipLottery.m_tag
		-- ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.n_type,tag,1,self.m_batch[1])
		if WndEquipLottery.m_root then
			WndEquipLottery:onContinue(tag)
		end
	elseif self.n_type == 2 then
		tag = WndPetLottery.m_tag
		-- ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.n_type,tag,1,0)
		if WndPetLottery.m_root then
			WndPetLottery:onContinue(tag)
		end
	elseif self.n_type == 3 then
		tag = WndMountLottery.m_tag
		if WndMountLottery.m_root then
			WndMountLottery:onContinue(tag)
		end
		-- ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.n_type,tag,consumeType,0)
	elseif self.n_type == 4 then
		tag = WndPhantomLottery.m_tag
		if WndPhantomLottery.m_root then
			WndPhantomLottery:onContinue(tag)
		end
		-- ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.n_type,tag,consumeType,0)
	elseif self.n_type == 5 then
		tag = WndFootLottery.m_tag
		if WndFootLottery.m_root then
			WndFootLottery:onContinue(tag)
		end
		-- ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.n_type,tag,consumeType,0)
	elseif self.n_type == 6 then
		tag = WndPetEquipLottery.m_tag
		if WndPetEquipLottery.m_root then
			WndPetEquipLottery:onContinue(tag)
		end
	end
end


--@ 关闭页面
function WndLotteryShow:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
	-- WndSummonEntrance:closeWin()

	--add 新手引导
	WZLog("WndLotteryShow:onClickClose")
	if WndEquipLottery.m_root then
		local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
		WZLog("WndLotteryShow:onClickClose1-1", isEndTeach41, step41)
		if isEndTeach41 ~= true and step41 < 5 then
			local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
			local otherId,otherNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
			local otherOneId,otherOneNum = tonumber(otherId[2]),tonumber(otherNum[2])
			local CoinNum1 = CacheCenter:getPlayerItemCountById(otherOneId)
			WZLog("~WndLotteryShow:onClickClose1-2" , otherOneNum, otherTowNum)
			if otherOneNum <= CoinNum1 then
			    TeachGroup1:startGroup({41,5,WndEquipLottery.m_root})
			else
				TeachGroup1:setTeachFinish(41,-1)
            	TeachGroup1:removeTeach()
			end
		end
	elseif WndPetLottery.m_root then
		local isEndTeach12, step12 = TeachGroup1:isTeachFinish(12)
		WZLog("WndLotteryShow:onClickClose2-1", isEndTeach12, step12)
		if isEndTeach12 ~= true and step12 < 5 then
			local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
			local otherId,otherNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
			local otherOneId,otherOneNum = tonumber(otherId[2]),tonumber(otherNum[2])
			local CoinNum1 = CacheCenter:getPlayerItemCountById(otherOneId)
			WZLog("~WndLotteryShow:onClickClose2-2" , otherOneNum, otherTowNum)
			if otherOneNum <= CoinNum1 then
			    TeachGroup1:startGroup({12,5,WndPetLottery.m_root})
			else
				TeachGroup1:setTeachFinish(12,-1)
            	TeachGroup1:removeTeach()
			end
		elseif isEndTeach12 ~= true and step12 >= 5 then
	        TeachGroup1:startGroup({12,6,WndPetLottery.m_root})
		end
	end
	--end

end

--@BRIEF 	点击跳过回调
function WndLotteryShow:onClickSkip(element)
	-- body
	if self.m_bIsClickSkip then return end 

	self.m_bIsClickSkip = true 
	local spineBg = GetElement(self.m_root, "spineBg_WndLotteryShow", WZUISpine)
    spineBg:disableSchedule()
    local conBg = GetElement(self.m_root, "conBg_WndLotteryShow", WZUIContainer)
    conBg:disableSchedule()
    GetElement(self.m_root, "btnSkip_WndLotteryShow", WZUIButton):setVisible(false)
    GetElement(self.m_root, "txtSkip_WndLotteryShow", WZUILabelTTF):setVisible(false)

    self:afterFadeToGrayBg()
end


--@brief 	点击跳过十连抽回调
function WndLotteryShow:onClickTenSkip(element)
	if self.m_bIsClickTenSkip then return end

	self.m_bIsClickTenSkip = true
    GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(false)

    while self.m_nParticleIndex < self.m_nRewardCount do
    	self:_displayDropParticle()
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    挖到宝物的特效
function WndLotteryShow:_displayTrainParticle(element)
    -- body
    WZLog("WndLotteryShow:_displayTrainParticle")
    --屏蔽触摸层
    -- local img9Black = WZUI9Image:create()
    -- img9Black:setOpacity(0)
    -- img9Black:setFile("ui/common/common_black_bg.png")
    -- img9Black:setTag(888)
    -- self.m_root:addChild(img9Black)
    self.m_nParticleIndex = self.m_nParticleIndex + 1
    if self.m_nParticleIndex > self.m_nRewardCount then 
    	element:disableSchedule()
    	return 
    end

    local winSize = CCDirector:sharedDirector():getWinSize()
    local particleTrain = CCParticleSystemQuad:create("particle/particle_lizi_2.plist")
    particleTrain:setDuration(kCCParticleDurationInfinity)
    particleTrain:setAutoRemoveOnFinish(true)
    local startPos = {winSize.width/2, 250}
    particleTrain:setPosition(startPos[1], startPos[2])

    local conBg = GetElement(self.m_root, "conBg_WndLotteryShow", WZUIContainer)
    particleTrain:setZOrder(2)
    conBg:addChild(particleTrain)

    if particleTrain then
        particleTrain:setVisible(true)

        local arrayAni = CCArray:create()

        local delayAni2 = CCDelayTime:create(0.01)
    	local xDis = self.m_tTargetPoint[self.m_nParticleIndex][1] - startPos[1]
    	local yDis = self.m_tTargetPoint[self.m_nParticleIndex][2] - startPos[2]
    	local xStep = xDis/4
    	local yStep = yDis/4
    	local yIndex = 1
    	local xDir = -1
    	local xOffset = 100
    	for i = 1, 4 do
    		if i % 2 == 0 then 
    			xDir = 1
    		end
    		local tempPos = {}
    		local pos1 = {startPos[1] + i * xStep, startPos[2] + i * yStep}
    		table.insert(tempPos, pos1)
    		local pos2 = {startPos[1] + i * xStep + xOffset * xDir, startPos[2] + yDis*yIndex/12}
    		table.insert(tempPos, pos2)
    		yIndex = yIndex + 1
    		local pos3 = {startPos[1] + i * xStep + xOffset * xDir, startPos[2] + yDis*yIndex/12}
    		table.insert(tempPos, pos3)
    		yIndex = yIndex + 1

	    	local configInfo = ccBezierConfig()
		    configInfo.endPosition = GlobalMethod:ccp(pos1[1], pos1[2])
	        configInfo.controlPoint_1 = GlobalMethod:ccp(pos2[1],pos2[2])
	        configInfo.controlPoint_2 = GlobalMethod:ccp(pos3[1],pos3[2])
	        local moveTo = CCBezierTo:create(0.2, configInfo)
        	arrayAni:addObject(moveTo)
    	end

        local functionAni4 = CCCallFuncN:create(afterParticle_Lottery)
        arrayAni:addObject(delayAni2)
        arrayAni:addObject(functionAni4)

        local sequence = CCSequence:create(arrayAni)
        particleTrain:runAction(sequence)
    end
end

--@brief    特效播放完成后的回调
function afterParticle_Lottery(element)
    -- body
    WndLotteryShow.m_nParticleRemoveIndex = WndLotteryShow.m_nParticleRemoveIndex + 1
    if element then
        element:removeFromParentAndCleanup(true)
    end

    if WndLotteryShow.m_nParticleRemoveIndex >= WndLotteryShow.m_nRewardCount and not WndLotteryShow.m_bIsClickSkip then 
    	GetElement(WndLotteryShow.m_root, "btnSkip_WndLotteryShow", WZUIButton):setVisible(false)
   	    GetElement(WndLotteryShow.m_root, "txtSkip_WndLotteryShow", WZUILabelTTF):setVisible(false)

    	GetElement(WndLotteryShow.m_root, "conBgStatic_WndLotteryShow", WZUIContainer):setVisible(true)
    	WndLotteryShow:doGrayBgFadeOut()
    end
end

--@brief 	灰色背景渐渐隐藏
function WndLotteryShow:doGrayBgFadeOut()
	-- body
	WndLotteryShow:actionCallback()

	local img9GrayBg = GetElement(self.m_root, "img9GrayBg_WndLotteryShow", WZUI9Image)
	local fadeTo = WZUIActionFadeTo:create()
	fadeTo:setOpacity(0)
    fadeTo:setDuration(0.6)
    fadeTo:setFinishLuaFunction("afterFadeToGrayBg")

    img9GrayBg:runUIAction(fadeTo)
end

--@brief 	执行粒子砸进来的动画
function WndLotteryShow:afterFadeToGrayBg()
	-- body

	self.m_bIsClickTenSkip = false
	GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(true)

	if self.m_bIsClickSkip then 
		WndLotteryShow:actionCallback()

		GetElement(WndLotteryShow.m_root, "conBgStatic_WndLotteryShow", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "img9GrayBg_WndLotteryShow", WZUI9Image):setOpacity(0)
	end
	self.m_nParticleRemoveIndex = 0
	self.m_nParticleIndex = 0
	self:_displayDropParticle()
end

--@brief    显示砸进来的特效
function WndLotteryShow:_displayDropParticle()
    -- body
    WZLog("WndLotteryShow:_displayDropParticle", self.m_nParticleIndex, self.m_nRewardCount)
    self.m_nParticleIndex = self.m_nParticleIndex + 1
    if self.m_nParticleIndex > self.m_nRewardCount then 
    	pushEquipInList()
    	g_bIsShowWndDressUp = true
    	return 
    end

    if self.m_nRewardCount > 1 then 
    	self:createParticleExploreSpine()
    else
	    local rewardElement = self.m_tRewardElement[self.m_nParticleIndex]
	    local rewardPosX = rewardElement:getPositionX()
	    local rewardPosY = rewardElement:getPositionY()
	    local conParticle = GetElement(self.m_root, "conParticle_WndLotteryShow", WZUIContainer)
	    if self.m_nRewardCount > 1 then 
	    	local ptA = rewardElement:convertToWorldSpace(GlobalMethod:ccp(0,0))
	    	local point = conParticle:convertToNodeSpace(ptA)

	    	rewardPosX = point.x + 100
	    	rewardPosY = point.y + 120
	    end
	    
	    local winSize = CCDirector:sharedDirector():getWinSize()
	    local particleTrain = CCParticleSystemQuad:create("particle/particle_lizi_2.plist")
	    particleTrain:setDuration(kCCParticleDurationInfinity)
	    particleTrain:setAutoRemoveOnFinish(true)
	    particleTrain:setPositionType(kCCPositionTypeRelative)
	    local startPos = {rewardPosX, winSize.height + 50 }
	    particleTrain:setPosition(startPos[1], startPos[2])
	    WZLog("WndLotteryShow:_displayDropParticle two", startPos[1], startPos[2])
	    conParticle:addChild(particleTrain)

	    if particleTrain then
	        particleTrain:setVisible(true)
	        local arrayAni = CCArray:create()

	    	local moveTo = CCMoveTo:create(0.2, GlobalMethod:ccp(rewardPosX, rewardPosY))
	    	local ccEase = CCEaseIn:create(moveTo, 0.2)
	        arrayAni:addObject(ccEase)
	        local functionAni4 = CCCallFuncN:create(afterParticleEaseIn)
	        arrayAni:addObject(functionAni4)

	        local sequence = CCSequence:create(arrayAni)
	        particleTrain:runAction(sequence)
	    end
	end
end

--@brief 	特效砸进来完成
function afterParticleEaseIn(element)
	WndLotteryShow:createParticleExploreSpine()
	if element then 
		element:removeFromParentAndCleanup(true)
	end
end

--@brief 	创建爆破，展示奖励
function WndLotteryShow:createParticleExploreSpine()
	-- body
	local rewardElement = self.m_tRewardElement[self.m_nParticleIndex]
	local rewardPosX = rewardElement:getPositionX()
	local rewardPosY = rewardElement:getPositionY()
	local conParticle = GetElement(self.m_root, "conParticle_WndLotteryShow", WZUIContainer)
	if self.m_nRewardCount > 1 then 
		local ptA = rewardElement:convertToWorldSpace(GlobalMethod:ccp(0,0))
		local point = conParticle:convertToNodeSpace(ptA)

		rewardPosX = point.x + 100
		rewardPosY = point.y + 120
	end
	WZLog("WndLotteryShow:createParticleExploreSpine", self.m_nParticleIndex, rewardPosX, rewardPosY)

    local spineFilePath  = "ui/otherUI/choujiang2"
	local existSpine = CheckEffectFile(spineFilePath)
	if existSpine then 
		local spineExplore = WZUISpine:create()
		spineExplore:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
		spineExplore:setUseAbsCoordinate(true)
		spineExplore:setAbsPosition(GlobalMethod:ccp(rewardPosX, rewardPosY))
		spineExplore:setTouchEnable(false)
		spineExplore:setFileJson(spineFilePath .. ".json")
		spineExplore:setFileAtlas(spineFilePath .. ".atlas")
		spineExplore:setAnimationName("wait")
		spineExplore:setLuaSpineEventFunc("afterExploreFunc")
		spineExplore:setTag(self.m_nParticleIndex)

		conParticle:addChild(spineExplore)
	else
		self:afterExploreFunc(nil, "end")
	end
end

--@brief 	爆炸完后，显示奖励，继续下一个奖励
function WndLotteryShow:afterExploreFunc(element, name, eventName)
	if name == "end" then
		local tag = self.m_nParticleIndex
		if element then 
				tag = element:getTag()
		end

		local rewardElement = self.m_tRewardElement[tag]
		if rewardElement then 
			rewardElement:setVisible(true)
		end

		local nCurItemId = self.n_itemId[tag]
		if self.m_bIsClickTenSkip then

		else
			if utilsValueInTable(nCurItemId, self.n_highCount) then 
				self:showHighQuality()
			end
		end
		if tag >= self.m_nRewardCount then 
			if self.m_bIsClickTenSkip and self.n_haveShow < #self.n_highCount then
				-- self:showHighQuality()
				element:enableSchedule("_scheduleExplore",0.4)
			else
				if self.m_nRewardCount > 1 then 
					GetElement(self.m_root, "conTenAllInfo_WndLotteryShow", WZUIContainer):setVisible(true)
				else
					GetElement(self.m_root, "conOneAllInfo_WndLotteryShow", WZUIContainer):setVisible(true)
				end

				GetElement(self.m_root, "btnTenSkip_WndLotteryShow", WZUIButton):setVisible(false)

				pushEquipInList()
				g_bIsShowWndDressUp = true
			end
		else
			if self.m_bIsClickTenSkip then

			else
				if not utilsValueInTable(nCurItemId, self.n_highCount) then 
					self:_displayDropParticle()
				end
			end
		end
	end
end

function WndLotteryShow:_scheduleExplore(element)
	self:showHighQuality()
	element:disableSchedule()
	if element then
		element:removeFromParentAndCleanup(true)
	end
end

--@brief 	设置待机特效
function WndLotteryShow:_setBallAni()
		local spinePath = "activity/ui_common_xyzq"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			local spineHigh = GetElement(self.m_root, "spineHigh_WndLotteryShow", WZUISpine)
			if spineHigh then 
				spineHigh:setFileJson(spinePath .. ".json")
				spineHigh:setFileAtlas(spinePath .. ".atlas")
				spineHigh:play("wait_1", true)
			end
		else
			local _sIndex = "ui_common_xyzq"
			local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
			if downloadInfo then 
				DownloadManager:addDownloadTask(70361, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndLotteryShow)
			end
		end

		local spinePath2 = "ui/otherUI/choujiang"
		local existSpine2 = CheckEffectFile(spinePath2)
		if existSpine2 then 
				local spineBg = GetElement(self.m_root, "spineBg_WndLotteryShow", WZUISpine)
				if spineBg then 
						spineBg:setFileJson(spinePath2 .. ".json")
						spineBg:setFileAtlas(spinePath2 .. ".atlas")
						spineBg:play("animation", false)
				end
		end
end

function WndLotteryShow:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndLotteryShow:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndLotteryShow:_adaptLanguage_vn()
	local txtTenRepeat = GetElement(self.m_root,"txtTenRepeat_WndLotteryshow",WZUILabelTTF)
	txtTenRepeat:setScale(0.7)
	txtTenRepeat:setRelativePosition(GlobalMethod:ccp(0.05,0.75))
	local txtTenHave = GetElement(self.m_root,"txtTenHave_WndLotteryShow",WZUIFreeTextBox)
	txtTenHave:setScale(0.7)
	txtTenHave:setRelativePosition(GlobalMethod:ccp(0.05,0.31))
	txtTenHave:setMaxWidth(330)
	local txtOneRepeat = GetElement(self.m_root,"txtOneRepeat_WndLotteryshow",WZUILabelTTF)
	txtOneRepeat:setScale(0.7)
	txtOneRepeat:setRelativePosition(GlobalMethod:ccp(0.05,0.75))
	local txtOneHave = GetElement(self.m_root,"txtOneHave_WndLotteryShow",WZUIFreeTextBox)
	txtOneHave:setScale(0.7)
	txtOneHave:setRelativePosition(GlobalMethod:ccp(0.05,0.31))
	txtOneHave:setMaxWidth(330)
end
-------------------------------------语言适配end----------------------------------------
