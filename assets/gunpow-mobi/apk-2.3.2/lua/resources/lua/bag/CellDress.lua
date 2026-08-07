--CellDress.lua
--@brief	CellDress的UI模块
--@date		2015/03/06
--@author	zsq
--@note		时装格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDress:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDress:onExit(element)
	self:_unInit()
end

--@brief	格子被点击响应函数
function CellDress:onCheck(element)
	WZLog("CellDress:onCheck")
	if self.m_nShowType == 3 then 
		WndAscending:addFirstDress(self)
	end
end

--@brief	点击显示tips
function CellDress:onTips()
	WZLog("CellDress:onTips", self.m_tData.maintype, self.m_nShowType)
	if WndItemInfo.m_root ~= nil then return end
	if self.m_tData.basicInfo.main_type == 31 then
		if WndKidDress.m_tTryWearList == nil then WndKidDress.m_tTryWearList = {} end
		if WndKidDress.m_tTryClothesData == nil then WndKidDress.m_tTryClothesData = {} end

		if self.m_nShowType == 1 then
			if WndKidDress.m_root then
	    		WndItemInfo:showInfo(self.m_root,WndKidDress.m_root,1,self.m_tData,true)
	    	end
		else
			--判断是否已经试穿
			if WndKidDress.m_tTryWearList[self.m_tData.basicInfo.sub_type] == self.m_tData.basicInfo.id then
				self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.CANCEL}
	    		WndItemInfo:showInfo(self.m_root,WndKidDress.m_root,1,self.m_tData,true)
				WndItemInfo:setClickButtonCallback(self,self.cancelKidWear)
			else
				self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.TRYWEAR}
	    		WndItemInfo:showInfo(self.m_root,WndKidDress.m_root,1,self.m_tData,true)
				WndItemInfo:setClickButtonCallback(self,self.tryWear)
			end
		end
	else
		if WndDressList.m_tTryWearList == nil then WndDressList.m_tTryWearList = {} end

		if self.m_nShowType == 1 then
			if WndDressList.m_root then
	    		WndItemInfo:showInfo(self.m_root,WndDressList.m_root,1,self.m_tData,true)
	    	end
		else
			--判断是否已经试穿
			if WndDressList.m_tTryWearList[self.m_tData.basicInfo.sub_type+1] == self.m_tData.basicInfo.id then
				self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.CANCEL}
	    		WndItemInfo:showInfo(self.m_root,WndDressList.m_root,1,self.m_tData,true)
				WndItemInfo:setClickButtonCallback(self,self.cancelWear)
			else
				self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.TRYWEAR}
	    		WndItemInfo:showInfo(self.m_root,WndDressList.m_root,1,self.m_tData,true)
				WndItemInfo:setClickButtonCallback(self,self.tryWear)
			end
		end
	end
end

--@brief	试穿
function CellDress:tryWear(tag)
	WZLog("CellDress:tryWear")
	WndItemInfo:onCloseClick()
	if tag == 1 then
		self:onBuyBtn()
		return
	end

	if self.m_tData.basicInfo.main_type == 31 then
		--试穿格子
		if WndKidDress.m_root == nil then return end
		--删除上个试穿标志
		if WndKidDress.m_tTryWearGrid ~= nil then
			if WndKidDress.m_tTryWearGrid.gridLuaObj then
				WndKidDress.m_tTryWearGrid.gridLuaObj:_removeTryWear()
			end 
		end
		WndKidDress.m_tTryWearGrid = self

		local dressType = {[1]=1,[2]=2,[3]=3}

		for i = 1, 3 do
			if self.m_tData.basicInfo.sub_type == dressType[i] then
	    		self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.CANCEL}
				WndKidDress.m_tDressGrid[i]:setCellGoodItem(self.m_tData,18)
				WndKidDress.m_tDressGrid[i]:_addTryWear()
				self.gridLuaObj:_addTryWear()
	    		local txt = GetElement(WndKidDress.m_root, "dressTxt" .. i .. "_WndKidDress", WZUIImage)
				txt:setVisible(false)
			end
		end
		--试穿人物
		local conPlayer = WndKidDress.conPlayer
		local animation_index_code = self.m_tData.basicInfo.animation_index_code 
		if self.m_tData.basicInfo.sub_type == 1 then
			conPlayer:setHead(animation_index_code)
		elseif self.m_tData.basicInfo.sub_type == 2 then
			conPlayer:setFace(animation_index_code)
		elseif self.m_tData.basicInfo.sub_type == 3 then
			conPlayer:setBody(animation_index_code)
		end
		conPlayer:play("wait", true)
		--记录试穿的时装itemId
		if WndKidDress.m_tTryWearList == nil then WndKidDress.m_tTryWearList = {} end
		if WndKidDress.m_tTryClothesData == nil then WndKidDress.m_tTryClothesData = {} end
		WndKidDress.m_tTryWearList[self.m_tData.basicInfo.sub_type] = self.m_tData.basicInfo.id
		WndKidDress.m_tTryClothesData[self.m_tData.basicInfo.sub_type] = self.m_tData
		return 
	end
	--试穿格子
	if Wndwardrobe.m_root == nil then return end
	--删除上个试穿标志
	if WndDressList.m_tTryWearGrid ~= nil then
		if WndDressList.m_tTryWearGrid.gridLuaObj then
			WndDressList.m_tTryWearGrid.gridLuaObj:_removeTryWear()
		end 
	end
	WndDressList.m_tTryWearGrid = self

	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}

	for i=1,4 do
		if self.m_tData.basicInfo.sub_type == dressType[i] then
    		self.m_tData.tBtnList = {LocalStrings.BUY, LocalStrings.CANCEL}
			Wndwardrobe.m_tDressGrid[i]:setCellGoodItem(self.m_tData,18)
			Wndwardrobe.m_tDressGrid[i]:_addTryWear()
			self.gridLuaObj:_addTryWear()
    		local txt = GetElement(Wndwardrobe.m_root, "dressTxt"..i, WZUIImage)
			txt:setVisible(false)
		end
	end
	--试穿人物
	local conPlayer = Wndwardrobe.conPlayer
	local animation_index_code = self.m_tData.basicInfo.animation_index_code 
	if self.m_tData.basicInfo.sub_type == 0 then
		conPlayer:setHead(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 1 then
		conPlayer:setFace(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 2 then
		conPlayer:setBody(animation_index_code)
		conPlayer:setBodyRanSe(0)
	elseif self.m_tData.basicInfo.sub_type == 3 then
		conPlayer:setWing(animation_index_code)
	end
	conPlayer:play("wait0",true)
	--记录试穿的时装itemId
	if WndDressList.m_tTryWearList == nil then WndDressList.m_tTryWearList = {} end
	WndDressList.m_tTryWearList[self.m_tData.basicInfo.sub_type+1] = self.m_tData.basicInfo.id
end

--@brief	取消
function CellDress:cancelWear(tag)
	WZLog("CellDress:cancelWear")
	WndItemInfo:onCloseClick()
	if tag == 1 then
		self:onBuyBtn()
		return
	end
	local color = 0

	--获得当前拥有的时装
	local equipmentList = CacheCenter:getEquipmentList()
	local animation_index_code

	--取消格子
	if Wndwardrobe.m_root == nil then return end
	local i = self.m_tData.basicInfo.sub_type + 1
	local set = false
	local txt = GetElement(Wndwardrobe.m_root, "dressTxt"..i, WZUIImage)
	for j=1,#equipmentList do
		if equipmentList[j].maintype == 5 and equipmentList[j].subtype == self.m_tData.basicInfo.sub_type then
			Wndwardrobe.m_tDressGrid[i]:setCellGoodItem(equipmentList[j], 18)
			self.gridLuaObj:_removeTryWear()
			animation_index_code = equipmentList[j].basicInfo.animation_index_code
			color = equipmentList[j].color
			txt:setVisible(false)
			set = true
		end
	end
	if set == false then
		Wndwardrobe.m_tDressGrid[i]:removeAllChild()
		Wndwardrobe.m_tDressGrid[i]:setSZBg()
		txt:setVisible(true)
		--设置默认显示
		local gameParam = CacheCenter:getGameParam()
		if CacheCenter:getPlayerInfo().sex == 0 then
			if self.m_tData.basicInfo.sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManFaceId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManBodyId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = 0
			end
		else
			if self.m_tData.basicInfo.sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = 0
			end
		end
	end

	--取消人物
	local conPlayer = Wndwardrobe.conPlayer
	if self.m_tData.basicInfo.sub_type == 0 then
		conPlayer:setHead(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 1 then
		conPlayer:setFace(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 2 then
		conPlayer:setBody(animation_index_code)
		conPlayer:setBodyRanSe(color)
	elseif self.m_tData.basicInfo.sub_type == 3 then
		conPlayer:setWing(animation_index_code)
	end
	conPlayer:play("wait0",true)
	--取消记录试穿的时装itemId
	if WndDressList.m_tTryWearList == nil then WndDressList.m_tTryWearList = {} end
	WndDressList.m_tTryWearList[self.m_tData.basicInfo.sub_type+1] = nil
end

--@brief	取消小孩
function CellDress:cancelKidWear(tag)
	WZLog("CellDress:cancelKidWear")
	WndItemInfo:onCloseClick()
	if tag == 1 then
		self:onBuyBtn()
		return
	end

	--获得当前拥有的时装
	local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
	local equipmentList = CacheCenter:getKidEquipmentDressList(tCurKidData.sex, tCurKidData.id)
	local animation_index_code

	--取消格子
	if WndKidDress.m_root == nil then return end
	local i = self.m_tData.basicInfo.sub_type
	local set = false
	local txt = GetElement(WndKidDress.m_root, "dressTxt" .. i .. "_WndKidDress", WZUIImage)
	self.gridLuaObj:_removeTryWear()
	for j=1, #equipmentList do
		if equipmentList[j].maintype == 31 and equipmentList[j].subtype == self.m_tData.basicInfo.sub_type then
			WndKidDress.m_tDressGrid[i]:setCellGoodItem(equipmentList[j], 18)
			animation_index_code = equipmentList[j].basicInfo.animation_index_code
			txt:setVisible(false)
			set = true
		end
	end
	if set == false then
		WndKidDress.m_tDressGrid[i]:removeAllChild()
		WndKidDress.m_tDressGrid[i]:setSZBg()
		txt:setVisible(true)
		--设置默认显示
		local gameParam = CacheCenter:getGameParam()
		if tCurKidData.sex == 0 then
			if self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleFaceId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleBodyId].animation_index_code
			end
		else
			if self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			end
		end
	end

	--取消人物
	local conPlayer = WndKidDress.conPlayer
	if self.m_tData.basicInfo.sub_type == 1 then
		conPlayer:setHead(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 2 then
		conPlayer:setFace(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 3 then
		conPlayer:setBody(animation_index_code)
	end
	conPlayer:play("wait", true)
	--取消记录试穿的时装itemId
	if WndKidDress.m_tTryWearList == nil then WndKidDress.m_tTryWearList = {} end
	if WndKidDress.m_tTryClothesData == nil then WndKidDress.m_tTryClothesData = {} end
	WndKidDress.m_tTryWearList[self.m_tData.basicInfo.sub_type] = nil
	WndKidDress.m_tTryClothesData[self.m_tData.basicInfo.sub_type] = nil
end

--@brief	设置是否高亮
function CellDress:setHighLight(bool)
	GetElement(self.m_root,"imgHighlight_CellDress",WZUI9Image):setVisible(bool)
end

--@brief	设置显示续费按钮
function CellDress:setRenew()
	WZLog("CellDress:setRenew")
end

--@brief	更新Cell
--@param	data:物品数据
--@param	showType:显示类型1自己拥有的时装2商城出售的时装3圣光时装进阶界面的时装
function CellDress:update(data,showType)
	if self.m_root == nil then return end
--    WZLog("CellDress:update", self.m_root:getTag())
	--测试数据
	--data.lastTime = "26978"
	--data.isUse = true
	--data.disappearTime = 5000

	self.m_tData = data
	self.m_nShowType = showType or 1
end

function CellDress:updateCell(data,showType)
	if self.m_root == nil then return end
	if data ~= nil and showType ~= nil then
		self.m_tData = data
		self.m_nShowType = showType or 1
	end

	--还没有初始化节点，不更新界面
	if GetElement(self.m_root,"CellDress",WZUIContainer) == nil then return end

	self.m_root:setVisible(true)
	--WZLog(debug.traceback(),self.m_nShowType,Serialize(self.m_tData))
	GetElement(self.m_root,"imgEquiped_CellDress",WZUIImage):setVisible(false)

	local data = self.m_tData

	--时装图片
	local con = self.m_root:getChildElement("conItem")
	if con ~= nil then
		con:removeAllChildrenWithCleanup(true)
		self.gridElement,self.gridLuaObj = CellGoodItem:createElement()
		if self.gridElement ~= nil and self.gridLuaObj ~= nil then
			con:addChild(self.gridElement)
			self.gridLuaObj:setSZBg()
    		self.gridLuaObj:setItemClickFun(self,self.onItemClick)
		end
	end
   	self.gridLuaObj:setCellGoodItem(data,5)
   	self.gridLuaObj:_removeTryWear()
	if WndDressList.m_tTryWearList ~= nil then 
		for k,v in pairs(WndDressList.m_tTryWearList) do
			if data.basicInfo.id == v then
   				self.gridLuaObj:_addTryWear()
			end
		end
	end
	if WndKidDress.m_tTryWearList ~= nil then 
		for k,v in pairs(WndKidDress.m_tTryWearList) do
			if data.basicInfo.id == v then
   				self.gridLuaObj:_addTryWear()
			end
		end
	end
	self.gridLuaObj:_addSidebarTime(nil, GlobalMethod:ccp(-0.17,1.22))
	if data.floorPrice ~= nil then
		self.gridLuaObj:_addSidebarPrice(data.floorPrice, data.moneyId)
	end
	GetElement(self.gridLuaObj.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")

	--时装名称
	local name = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
	name:setText(data.basicInfo.name)
--	WZLog("CellDress:updateCell", Serialize(data))
	local quality = data.basicInfo.quality
   	if data.basicInfo.main_type == 31 then
   		name:setFontSize(18)
   		local nSex = CacheCenter:getPlayerInfo().sex
   		local imgPlayerMark = GetElement(self.m_root, "imgPlayerMark_CellDress", WZUIImage)
   		local txtSexMark = GetElement(self.m_root, "txtSexMark_CellDress", WZUILabelTTF)
   		if data.ownerId and data.ownerId == CacheCenter:getPlayerInfo().id then
   			imgPlayerMark:setVisible(true)
   			if nSex == 0 then
   				imgPlayerMark:setFile("ui/kid/kidicon/couple_scale9_008.png")
   				txtSexMark:setText(LocalStrings.KID_TEXT119)
   			else
   				imgPlayerMark:setFile("ui/kid/kidicon/couple_scale9_009.png")
   				txtSexMark:setText(LocalStrings.KID_TEXT120)
   			end
   		elseif data.ownerId and data.ownerId > 0 then
   			imgPlayerMark:setVisible(true)
   			if nSex == 0 then
   				imgPlayerMark:setFile("ui/kid/kidicon/couple_scale9_009.png")
   				txtSexMark:setText(LocalStrings.KID_TEXT120)
   			else
   				imgPlayerMark:setFile("ui/kid/kidicon/couple_scale9_008.png")
   				txtSexMark:setText(LocalStrings.KID_TEXT119)
   			end
   		end
   	elseif data.basicInfo.main_type == 5 then
   		local _, _, bIsAdvance = GetDressAdvanceData(data.basicInfo.id)
	    if bIsAdvance then 
	    	quality = data.basicInfo.quality + 1
	    end
   	end
   	name:setColor(QUALITYCOLOR[quality])

	if self.m_nShowType == 1 then
		--剩余时间
		local countdown
		--物品未过期，计算过期时间;已过期，计算消失时间
		if data.lastTime == 0 then
			countdown = data.disappearTime - (os.time() - SETITEMSTIME)
			--countdown = data.disappearTime
			self.m_sDisappear = LocalStrings.DISAPPEAR
		elseif data.lastTime == -1 then
			
		else
			countdown = data.lastTime - (os.time() - SETITEMSTIME)
			--countdown = data.lastTime
			self.m_sDisappear = ""
		end
		
		self.m_nCountdown = countdown
		if data.lastTime ~= -1 then
			self:onCountdown(self.m_root,1)
			self.m_root:enableSchedule("onCountdown",1)
		end

		if tonumber(data.lastTime) == -1 then
			--无限期
			local time = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
			time:setText(LocalStrings.NOLIMIT)
		elseif tonumber(data.lastTime) <= 0 then
			GetElement(self.m_root,"imgEquiped_CellDress",WZUIImage):setVisible(false)
		end

		if data.isUse then
            if self.m_root:getTag() == 0 then
                TeachGroup1.ISHAVEDRESS = false
            end
			GetElement(self.m_root,"imgEquiped_CellDress",WZUIImage):setVisible(true)
		else
			GetElement(self.m_root,"imgEquiped_CellDress",WZUIImage):setVisible(false)
		end
	elseif self.m_nShowType == 2 then
		GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF):setVisible(false)
	elseif self.m_nShowType == 3 then 
		GetElement(self.m_root, "conDesk_CellDress", WZUIContainer):setVisible(true)
		local conBg = GetElement(self.m_root, "conBg_CellDress", WZUIContainer)
		conBg:setAbsContentSize(GlobalMethod:CCSize(122, 154))
		conBg:updateRelativeSize()
		GetElement(self.m_root, "imgBg_CellDress", WZUI9Image):setFile("ui/common/frame_23.png")
		con:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
	end


	if self.m_tData.maxFight ~= nil and self.m_tData.maxFight == true then
		self:setFight(true)
	end

	self:setSelectState(self.m_bIsSel)
end

--@brief
function CellDress:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellDress")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)
	self.m_bIsLoaded = true 

	self:updateCell()
	AdaptLanguage(self)
end

--@brief	倒计时
function CellDress:onCountdown(element,t)
	--WZLog("CellDress:onCountdown",self.m_nCountdown)
	if self.m_nCountdown == nil then 
		element:disableSchedule()
		return 
	end
	self.m_nCountdown = self.m_nCountdown - 1
	if self.m_nCountdown <= 0 then
		element:disableSchedule()
		element:setVisible(false)
	end

	local countdown = self.m_nCountdown
	local tip = ""
	local desc = ""
	if countdown == nil then return end
	if self.m_sDisappear == nil then self.m_sDisappear = "" end
	--WZLog("倒计时倒计时倒计时",tip,countdown,self.m_sDisappear,countdown+57600,os.date("%X",countdown+57600))
	if tonumber(countdown) > 86400 then
		desc = tip..math.ceil(countdown/86400)..LocalStrings.DAY..LocalStrings.BAGTIP41..self.m_sDisappear
	elseif tonumber(countdown) > 3600 then
		desc = tip..math.ceil(countdown/3600)..LocalStrings.HOUR1..LocalStrings.BAGTIP41..self.m_sDisappear
	else
		s = countdown % 60--s
		countdown = math.floor(countdown/60)
		m = countdown % 60--m
		countdown = math.floor(countdown/60)
		h = countdown % 24--h
		countdown = math.floor(countdown/24)
		d = countdown --d
		if tonumber(h) < 10 then h = "0"..h end
		if tonumber(m) < 10 then m = "0"..m end
		if tonumber(s) < 10 then s = "0"..s end
		--desc = tip..h..":"..m..":"..s..self.m_sDisappear
		desc = tip..m..":"..s..LocalStrings.BAGTIP41..self.m_sDisappear
	end
	local time = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
	time:setText(desc)
	if WndDressList.m_nCurrentIndex == 6 then
		time:setVisible(true)
	else
		time:setVisible(false)
	end
end

--@brief	续费按钮点击
function CellDress:onRenew()
	WZLog("CellDress:onRenew",self.m_root:getTag(),self.m_tData.basicInfo.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--调用设置的回调函数
	--if self.renewBackFunc then
	--	self.renewBackFunc[2](self.renewBackFunc[1],self.m_tData)
	--end
	local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
	WndPurchase:showBuyInterface(nType[self.m_tData.basicInfo.sub_type],self.m_tData.basicInfo.id,self,self.buyOK)
end

--@brief	穿戴按钮点击
function CellDress:onDress(element)
	WZLog("CellDress:onDress",self.m_root:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element:setVisible(false)
	--调用设置的回调函数
	--if self.dressBackFunc then
	--	self.dressBackFunc[2](self.dressBackFunc[1],self.m_tData)
	--end

	WndBag:onItemClick(2,self.m_tData)
end

--@brief	购买按钮点击
--@param	nBuyType: 商品类型：1:武器 2:头饰 3:脸谱 4：衣服 5：翅膀 6：道具 
function CellDress:onBuyBtn()
	WZLog("CellDress:onBuyBtn",self.m_root:getTag(),self.m_tData.shopItemId)
	local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellDress.m_current_click = self
	if self.m_tData.basicInfo.main_type == 31 then
		WndPurchase:showBuyInterface(self.m_tData.basicInfo.sub_type + 1, self.m_tData.shopItemId, self,self.buyOK)
	else
		WndPurchase:showBuyInterface(nType[self.m_tData.basicInfo.sub_type],self.m_tData.shopItemId,self,self.buyOK)
	end
end

--@brief	购买成功回调
function CellDress:buyOK()
	WZLog("CellDress:buyOK", type(CellDress.m_current_click.m_tData))
	if CellDress.m_current_click and CellDress.m_current_click.m_tData then
		if CellDress.m_current_click.m_tData.basicInfo.main_type == 31 then
		else
			Wndwardrobe.m_tIDList = {self.m_tData.basicInfo.id}
		end
	end
end

function CellDress:onItemClick(element,tag,tData)
	WZLog("CellDress:onItemClick",tData.basicInfo.name)
	if self.m_nShowType == 3 then 
		WndAscending:addFirstDress(self)
	else
		if tData.basicInfo.main_type == 31 then
			self:onTips()
		else
			if Wnddyeing.m_root ~= nil then
				Wnddyeing:finishChoose(tData)
				return
			end

			if Wnddyeing.m_root == nil then
				self:onTips()
			end
		end
	end
end

--@brief 	设置名字字体的大小
function CellDress:setNameFontSize(nSize)
	-- body
	local ttfName = GetElement(self.m_root, "ttfName_CellDress", WZUILabelTTF)
	if ttfName then
		ttfName:setFontSize(nSize)
	end
end

--@brief 	设置选中状态
function CellDress:setSelectState(bVisible)
	self.m_bIsSel = bVisible
	if not self.m_bIsLoaded then return end

    local img = GetElement(self.m_root,"imgSel_CellDress",WZUI9Image)
    img:setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellDress:_adaptLanguage_vn()
	local imgEquiped = GetElement(self.m_root,"imgEquiped_CellDress",WZUIImage)
	if imgEquiped then
		imgEquiped:setRelativePosition(GlobalMethod:ccp(0.697667,0.3))
	end
end

function CellDress:_adaptLanguage_en(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(12)
	    ttfName:setDimensions(GlobalMethod:CCSize(105))
	end

	local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(60))
	    ttfDeadTime:setFontSize(8)
	end
end

function CellDress:_adaptLanguage_tr(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(12)
	    ttfName:setDimensions(GlobalMethod:CCSize(105))
	end

	local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(60))
	    ttfDeadTime:setFontSize(8)
	end
end

function CellDress:_adaptLanguage_es(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(11)
	    ttfName:setDimensions(GlobalMethod:CCSize(105))
	end

	local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(80))
	    ttfDeadTime:setFontSize(12)
	end
end

function CellDress:_adaptLanguage_pt(  )
	for i=1,2 do
		local txtBuy1 = GetElement(self.m_root,"txtBuy"..i.."_CellGoodsList",WZUILabelTTF)
		if txtBuy1 then
			txtBuy1:setFontSize(15)
		end
	end
    
    local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(11)
	    ttfName:setDimensions(GlobalMethod:CCSize(105))
	end
    
    local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(110))
	    ttfDeadTime:setFontSize(12)
	end
end

function CellDress:_adaptLanguage_th(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(12)
	    ttfName:setDimensions(GlobalMethod:CCSize(105))
	end
	
	local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(80))
	    ttfDeadTime:setFontSize(12)
	end
end

function CellDress:_adaptLanguage_vn(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setMaxLength(64)
	    ttfName:setFontSize(12)
	    ttfName:setDimensions(GlobalMethod:CCSize(100))
	end
	
	local ttfDeadTime = GetElement(self.m_root,"ttfDeadTime_CellDress",WZUILabelTTF)
    if ttfDeadTime ~= nil then
	    ttfDeadTime:setMaxLength(64)
	    ttfDeadTime:setDimensions(GlobalMethod:CCSize(80))
	    ttfDeadTime:setFontSize(12)
	end
end

function CellDress:_adaptLanguage_ug(  )
	local ttfName = GetElement(self.m_root,"ttfName_CellDress",WZUILabelTTF)
    if ttfName ~= nil then
	    ttfName:setScale(0.7)
	end
end

-------------------------------------私有方法模块End----------------------------------------
