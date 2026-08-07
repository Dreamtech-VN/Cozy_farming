--WndHoraryBigReward.lua
--@brief	WndHoraryBigReward的UI模块
--@date		2021/07/30
--@author	hyx
--@note		占星大奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHoraryBigReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHoraryBigReward:onExit(element)
	NOTRECYCLEIDS_COPY = {}
	if self.m_sFishSpine then
		self.m_sFishSpine:removeFromParentAndCleanup(true)
		self.m_sFishSpine = nil
	end
	self:_unInit()
end

--@brief 	外部接口
--@param 	data2:后续还要显示的不同类型奖励
function WndHoraryBigReward:showInterface(_type, data, data2, data3)
	if WndHoraryBigReward.m_root == nil then 
		local wndBigReward = WndHoraryBigReward:createElement()
		if wndBigReward ~= nil then
		    WindowManager:addWindow(wndBigReward,WndHoraryBigReward,nil,false)
		end
		self.m_nBigType = _type
		self.m_tBigData = data
		self.m_tOtherBigReward = data2
		self.m_tSpecialReward = data3
	else
		if _type == self.m_nBigType and _type == 6 then 
			for i = 1, #data do
				table.insert(self.m_tBigData, data[i])
			end
		elseif _type == 6 and self.m_nBigType == 8 then 
			for i = 1, #data do
				table.insert(self.m_tOtherBigReward, data[i])
			end
		end
	end
end

function WndHoraryBigReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndHoraryBigReward:actionCallback()
	if self.m_nBigType == 1 then
		self:setRewardType1()
	elseif self.m_nBigType == 2 then
		self:setRewardType2()
	elseif self.m_nBigType == 3 then --钓鱼的大奖
		self:setRewardType3()
	elseif self.m_nBigType == 4 then --弹珠
		self:setRewardType4()
	elseif self.m_nBigType == 5 then --房产
		self:setRewardType5()
	elseif self.m_nBigType == 6 then --水之国度/张灯结彩大奖特奖
		self:setRewardType6()
	elseif self.m_nBigType == 7 or self.m_nBigType == 10 or self.m_nBigType == 11 or self.m_nBigType == 13 or self.m_nBigType == 15 or self.m_nBigType == 16 then --张灯结彩奖
		self:setRewardType7()
	elseif self.m_nBigType == 8 or self.m_nBigType == 9 or self.m_nBigType == 17 then --暴打策划
		self:setRewardType7()
	elseif self.m_nBigType == 12 or self.m_nBigType == 14 then  --丹道修真
		self:setRewardType8()
	elseif self.m_nBigType == 18 then  --疯狂扭蛋
		self:setRewardType9()
	elseif self.m_nBigType == 19 then --出售鲜花收益
		self:setRewardType10()
	elseif self.m_nBigType == 20 then --两个大奖同时展示
		self:setRewardType11()
	end
end
--类型1
function WndHoraryBigReward:setRewardType1()
	local reward_1 = GetElement(self.m_root,"reward_1",WZUIContainer)
	reward_1:setVisible(true)
	local goods_con = GetElement(reward_1,"goods_con",WZUIContainer)
	local item = self.m_tBigData.id
	if GDatatab_item["id_"..item] then
		local itemInfo = {lastTime=self.m_tBigData.num,lastNum=self.m_tBigData.num,basicInfo=CopyTable(GDatatab_item["id_"..item])}
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(self,self.onItemClick)
	end
end
--类型2
function WndHoraryBigReward:setRewardType2()
	local reward_2 = GetElement(self.m_root,"reward_2",WZUIContainer)
	reward_2:setVisible(true)
	local goods_con = GetElement(reward_2,"goods_con",WZUIContainer)
	local item = self.m_tBigData.id
	if GDatatab_item["id_"..item] then
		local itemInfo = {lastTime=self.m_tBigData.num,lastNum=self.m_tBigData.num,basicInfo=CopyTable(GDatatab_item["id_"..item])}
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(self,self.onItemClick)
	end
	local gxId = self.m_tBigData.gxId or -1
	local str = nil
	if gxId == 0 then --没有卦象的时候
		str = LocalStrings.ACTIVITY_TEXT87
	else
		str = LocalStrings.ACTIVITY_TEXT86[gxId]
	end
	if str then
		local _str = SplitStringWithSeparator(str,",")
		for i=1,#_str do
			local img = GetElement(reward_2,"img_"..i,WZUIImage)
			img:setVisible(true)
			GetElement(img,"txtName",WZUILabelTTF):setText(_str[i])
		end
	end
end
--类型3
function WndHoraryBigReward:setRewardType3()
	local reward_3 = GetElement(self.m_root,"reward_3",WZUIContainer)
	reward_3:setVisible(true)
	local imgRewardTitle = GetElement(reward_3,"imgRewardTitle",WZUIImage)
	local txtBigDesc = GetElement(reward_3,"txtBigDesc",WZUIFreeTextBox)

	--判断大奖还是特殊奖
	local _type = 1
	local bigId1,bigNum1, bigId2,bigNum2 = nil,nil,0,0
	if next(self.m_tBigData.bigIds) ~= nil and next(self.m_tBigData.specialIds) ~= nil then --全都有
		bigId1 = self.m_tBigData.bigIds[1]
		bigNum1 = self.m_tBigData.bigNums[1]
		self.m_bDoubleBigRewardType = true
	else --只存在一种的情况
		if next(self.m_tBigData.bigIds) ~= nil then
			bigId1 = self.m_tBigData.bigIds[1]
			bigNum1 = self.m_tBigData.bigNums[1]
		elseif next(self.m_tBigData.specialIds) ~= nil then
			bigId1 = self.m_tBigData.specialIds[1]
			bigNum1 = self.m_tBigData.specialNums[1]
			_type = 2
		end
	end
	self:showBigReward(bigId1,bigNum1, _type)
end
--
function WndHoraryBigReward:showBigReward(id, num, _type)
	if not self.m_root then
		return
	end
	local reward_3 = GetElement(self.m_root,"reward_3",WZUIContainer)
	
	local spine_con = GetElement(reward_3,"spine_con",WZUIContainer)
	if self.m_sFishSpine then
		self.m_sFishSpine:removeFromParentAndCleanup(true)
		self.m_sFishSpine = nil
	end
	local data = {}
	data.path = "activity/ui_common_hjmb"
	data.play = "wait_2"
	local existSpine = CheckEffectFile(data.path)
	if existSpine then 
		self.m_sFishSpine = createEffectSpine(spine_con,data)
	else
		local _sIndex = "ui_common_hjmb"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14004,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end

	local str_title = {"ui/activityWords/text_dy_dydj.png","ui/activityWords/text_dy_hyjl.png"}
	GetElement(reward_3,"imgRewardTitle",WZUIImage):setFile(str_title[_type])
	local str_desc = {LocalStrings.ACTIVITY_TEXT126, LocalStrings.ACTIVITY_TEXT127}
	GetElement(reward_3,"txtBigDesc",WZUIFreeTextBox):setShowText(str_desc[_type])

	local goods_con = GetElement(reward_3,"goods_con",WZUIContainer)
	if not self.m_sBigRewardItem then
		local celElement,tLuaObj = CellGoodItem:createElement()
		self.m_sBigRewardItem = tLuaObj
		goods_con:addChild(celElement)
	end
	if self.m_sBigRewardItem then
		local info = GDatatab_item["id_"..id]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(info)}
		self.m_sBigRewardItem:setCellGoodItem(itemInfo, 17)
		self.m_sBigRewardItem:setItemClickFun(self,self.onItemClick)
	end
end
--类型4
function WndHoraryBigReward:setRewardType4()
	if not self.m_root then
		return
	end
	local reward_4 = GetElement(self.m_root,"reward_4",WZUIContainer)
	reward_4:setVisible(true)
	if self.m_sFishSpine then
		self.m_sFishSpine:removeFromParentAndCleanup(true)
		self.m_sFishSpine = nil
	end
	local goods_con = GetElement(reward_4,"goods_con",WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	goods_con:addChild(celElement)
	local info = GDatatab_item["id_"..self.m_tBigData.id[1]]
	if info then
		local itemInfo = {lastTime=self.m_tBigData.num[1],lastNum=self.m_tBigData.num[1],basicInfo=CopyTable(info)}
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(self,self.onItemClick)
	end
	local data = {}
	data.path = "activity/ui_common_dzhjmb"
	data.play = "wait_1"
	local existSpine = CheckEffectFile(data.path)
	if existSpine then 
		self.m_sFishSpine = createEffectSpine(reward_4,data)
	else
		local _sIndex = "ui_common_dzhjmb"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14003,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end
end
--类型5
function WndHoraryBigReward:setRewardType5()
	if not self.m_root then
		return
	end

	local reward_5 = GetElement(self.m_root,"reward_5",WZUIContainer)
	reward_5:setVisible(true)
	local type1_con = GetElement(reward_5,"type1_con",WZUIContainer)
	local type2_con = GetElement(reward_5,"type2_con",WZUIContainer)
	if next(self.m_tBigData.upItemIds) ~= nil then
		type1_con:setVisible(true)
		local good1_con = GetElement(type1_con,"good1_con",WZUIContainer)
		local _size = good1_con:getContentSize()
		local start_x = _size.width * 0.5 - ((#self.m_tBigData.upItemIds-1) * 40)
		for i=1,#self.m_tBigData.upItemIds do
			local tab_info = GDatatab_item["id_"..self.m_tBigData.upItemIds[i]]
			if tab_info then
				local cellElement, tLuaObj = CellGoodItem:createElement()
				good1_con:addChild(cellElement)
				cellElement:setUseAbsCoordinate(true)
				local itemInfo = {lastTime=self.m_tBigData.upItemNums[i],lastNum=self.m_tBigData.upItemNums[i],basicInfo=CopyTable(tab_info)}
				tLuaObj:setCellGoodItem(itemInfo, 17)
				tLuaObj:setItemClickFun(WndHoraryBigReward,self.onItemClick)
				local _x = start_x + (i-1) * 80 + ((i-1)*10)
				cellElement:setAbsPosition(GlobalMethod:ccp(_x, _size.height*0.5))
				cellElement:setVisible(true)
			end
		end
		self.m_tBigData.upItemIds = {}
	else
		self:showType5OtherReward()
	end
end
function WndHoraryBigReward:showType5OtherReward()
	local reward_5 = GetElement(self.m_root,"reward_5",WZUIContainer)
	local type1_con = GetElement(reward_5,"type1_con",WZUIContainer)
	local type2_con = GetElement(reward_5,"type2_con",WZUIContainer)
	type1_con:setVisible(false)
	type2_con:setVisible(true)
	local imgTitle = GetElement(type2_con,"imgTitle",WZUIImage)
	local good2_con = GetElement(type2_con,"good2_con",WZUIContainer)
	if not self.m_sBigRewardItem then
		local celElement,tLuaObj = CellGoodItem:createElement()
		self.m_sBigRewardItem = tLuaObj
		good2_con:addChild(celElement)
	end
	local id, num = 1,1
	if next(self.m_tBigData.fItemIds) ~= nil then
		imgTitle:setFile("ui/activityWords/text_fcdh_tzdl.png")
		id = self.m_tBigData.fItemIds[1]
		num = self.m_tBigData.fItemNums[1]
		self.m_tBigData.fItemIds = {}
	elseif next(self.m_tBigData.sItemIds) ~= nil then
		imgTitle:setFile("ui/activityWords/text_fcdh.png")
		id = self.m_tBigData.sItemIds[1]
		num = self.m_tBigData.sItemNums[1]
		self.m_tBigData.sItemIds = {}
	end
	if self.m_sBigRewardItem then
		local info = GDatatab_item["id_"..id]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(info)}
		self.m_sBigRewardItem:setCellGoodItem(itemInfo, 17)
		self.m_sBigRewardItem:setItemClickFun(self,self.onItemClick)
	end
end
function WndHoraryBigReward:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
end
function WndHoraryBigReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_bDoubleBigRewardType then
		self.m_bDoubleBigRewardType = nil
		self:showBigReward(self.m_tBigData.specialIds[1], self.m_tBigData.specialNums[1], 2)
	else
		if self.m_nBigType == 6 and #self.m_tBigData > 0 then 
			self:setRewardType6()
		elseif self.m_nBigType == 7 then 
			--显示张灯结彩奖励以后，判断有没有大奖和特奖
			if self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				self.m_nBigType = 6 
				self.m_tBigData = self.m_tOtherBigReward
				GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
				self:setRewardType6()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 8 then 
			--显示隐藏大奖奖励以后，判断有没有大奖和特奖
			if self.m_tSpecialReward and #self.m_tSpecialReward > 0 then 
				self.m_tBigData = CopyTable(self.m_tSpecialReward[1])
				self:setRewardType7()
				table.remove(self.m_tSpecialReward, 1)
			elseif self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				if self.m_tOtherBigReward[1].type and self.m_tOtherBigReward[1].type == 26 then 
					self.m_nBigType = 6 
					self.m_tBigData = self.m_tOtherBigReward
					GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
					self:setRewardType6()
				else 
					self.m_nBigType = 9 
					self.m_tBigData = self.m_tOtherBigReward
					self:setRewardType7()
				end
			else
				if self.m_tCallBackFun then 
					self.m_tCallBackFun[2](self.m_tCallBackFun[1])
				end
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 9 and #self.m_tBigData > 0 then 
			self:setRewardType7()
		elseif self.m_nBigType == 10 then 
			if self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				self.m_tBigData = CopyTable(self.m_tOtherBigReward)
				self.m_tOtherBigReward = nil 
				self:setRewardType7()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 11 then 
			if self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				self.m_tBigData = CopyTable(self.m_tOtherBigReward)
				self.m_tOtherBigReward = nil  
				GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
				self.m_nBigType = 12
				self:setRewardType8()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 12 then 
			if self.m_tBigData ~= nil and #self.m_tBigData > 0 then 
				self:setRewardType8()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 13 then 
			if self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				self.m_tBigData = CopyTable(self.m_tOtherBigReward)
				self.m_tOtherBigReward = nil  
				GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
				self.m_nBigType = 14
				self:setRewardType8()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 14 then 
			if self.m_tBigData ~= nil and #self.m_tBigData > 0 then 
				self:setRewardType8()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 15 then 
			if self.m_tOtherBigReward ~= nil and #self.m_tOtherBigReward > 0 then 
				self.m_tBigData = CopyTable(self.m_tOtherBigReward)
				self.m_tOtherBigReward = nil  
				GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
				self.m_nBigType = 6
				self:setRewardType6()
			else
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 17 then 
			if self.m_tBigData ~= nil and #self.m_tBigData > 0 then 
				if self.m_tBigData[1][1].type == 18 then 
					GetElement(self.m_root,"reward_7",WZUIContainer):setVisible(false)
					self:setRewardType6()
				else
					self:setRewardType7()
				end
			else
				if self.m_tCallBackFun then 
					self.m_tCallBackFun[2](self.m_tCallBackFun[1])
				else
					pushEquipInList()
				end
				WindowManager:removeWindow(self.m_root, self, true)
			end
		elseif self.m_nBigType == 19 then 
			pushEquipInList()
			WindowManager:removeWindow(self.m_root, self, true)
		elseif self.m_nBigType == 20 then 
			pushEquipInList()
			WindowManager:removeWindow(self.m_root, self, true)
		else
			if (self.m_tBigData.fItemIds and next(self.m_tBigData.fItemIds) ~= nil) or (self.m_tBigData.sItemIds and next(self.m_tBigData.sItemIds) ~= nil) then
				self:setRewardType5()
			else
				if self.m_tCallBackFun then 
					self.m_tCallBackFun[2](self.m_tCallBackFun[1])
				end
				pushEquipInList()
				WindowManager:removeWindow(self.m_root, self, true)
			end
		end
	end
end

--@brief 	水之国度大奖和特奖   类型6
function WndHoraryBigReward:setRewardType6()
	if not self.m_root then
		return
	end
	local reward_6 = GetElement(self.m_root,"reward_6",WZUIContainer)
	reward_6:setVisible(true)
	local goods_con = GetElement(reward_6,"goods_con",WZUIContainer)
	goods_con:removeAllChildrenWithCleanup(true)
	local celElement,tLuaObj = CellGoodItem:createElement()
	goods_con:addChild(celElement)
	goods_con:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	local info = self.m_tBigData[1]
	if self.m_nBigType == 17 then 
		info = self.m_tBigData[1][1]
	end
	local imgRewardTitle = GetElement(reward_6, "imgRewardTitle_WndHoraryBigReward", WZUIImage)
	local imgTitle = GetElement(reward_6, "imgTitle_WndHoraryBigReward", WZUIImage)
	imgTitle:setFile("")
	local imgBk = GetElement(reward_6, "imgBk_WndHoraryBigReward", WZUIImage)
	imgBk:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	local ftxtTitle = GetElement(reward_6, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
	local conLongBg = GetElement(reward_6, "conLongBg_WndHoraryBigReward", WZUIContainer)
	conLongBg:setVisible(false)
	WZLog("WndHoraryBigReward:setRewardType6", info.type)
	if info.type == 3 or info.type == 4 then 
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.565))
		imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.908))
		imgBk:setFile("ui/newActivity/hd_pic_zdjc_dj.png")
	elseif info.type == 5 or info.type == 6 then 
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.385))
		imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.725))
		imgBk:setFile("ui/newActivity/hd_pic_nsdzz_dj.png")
	elseif info.type == 10 or info.type == 11 or info.type == 14 or info.type == 15 then 
		imgBk:setFile("ui/newActivity/hd_pic_tqq_dj.png")
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.47))
		local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if ProjConfig.LANGUAGE == "vn" then
			strTitleFormat = [[<T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		end
		if info.type == 10 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.SETCIRCLE_TEXT1[9]))
		elseif info.type == 11 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.SETCIRCLE_TEXT1[10]))
		elseif info.type == 14 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.CAFFEE_TEXT1[7]))
		elseif info.type == 15 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.CAFFEE_TEXT1[8]))
		end
	elseif info.type == 12 or info.type == 13 then 
		imgBk:setFile("ui/newActivity/hd_pic_tqq_dj.png")
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.47))
		local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if ProjConfig.LANGUAGE == "vn" then
			strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		end
		if info.type == 12 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.GARDEN_TEXT1[9], LocalStrings.ATH_REWARD_CHECK))
		else
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.GARDEN_TEXT1[10], LocalStrings.ATH_REWARD_CHECK))
		end
	elseif info.type == 16 or info.type == 17 then 
		imgBk:setFile("ui/newActivity/hd_pic_xrxg_dj.png")
		imgBk:setRelativePosition(GlobalMethod:ccp(0.53, 0.5))
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.47))
		local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if ProjConfig.LANGUAGE == "vn" then
			strTitleFormat = [[<T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		end
		if info.type == 16 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.WATERMELON_TEXT1[19]))
		elseif info.type == 17 then 
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.WATERMELON_TEXT1[20]))
		end
	elseif info.type == 18 then 
		imgBk:setFile("ui/newActivity/hd_pic_mjct_dj.png")
		imgTitle:setFile("ui/activityWords/text_mjct_dj.png")
	elseif info.type == 19 or info.type == 20 then 
		if info.type == 19 then 
			imgBk:setFile("ui/newActivity/hd_pic_tqq_dj.png")
			goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.47))
		else
			goods_con:setRelativePosition(GlobalMethod:ccp(0.51, 0.52))
			imgBk:setFile("ui/newActivity/hd_pic_bzch_dj.png")
		end
	elseif info.type == 21 or info.type == 22 then 
		local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if ProjConfig.LANGUAGE == "vn" then
			strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		end
		GetElement(reward_6, "imgBkDiWen_WndHoraryBigReward", WZUIImage):setFile("ui/newActivity/hd_pic_fknd_nddj_01.png")
		goods_con:setRelativePosition(GlobalMethod:ccp(0.515,0.605))
		if info.type == 21 then 
			imgBk:setFile("ui/newActivity/hd_pic_fknd_ndxj.png")
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.CRAZY_GASHAPON_TEXT3[5], LocalStrings.CRAZY_GASHAPON_TEXT3[7]))
		else
			imgBk:setFile("ui/newActivity/hd_pic_fknd_nddj.png")
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.CRAZY_GASHAPON_TEXT3[5], LocalStrings.CRAZY_GASHAPON_TEXT3[6]))
		end
	elseif info.type == 23 or info.type == 24 or info.type == 25 then 
		local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="46" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		if ProjConfig.LANGUAGE == "vn" then
			strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
		end
		if info.type == 23 then 
			imgBk:setFile("ui/newActivity/hd_pic_syst_dj.png")
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.MIDNIGHTDINER_TEXT1[20], LocalStrings.ATH_REWARD_CHECK))
			goods_con:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
		elseif info.type == 24 then 
			imgBk:setFile("ui/newActivity/hd_pic_syst_dj_01.png")
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.MIDNIGHTDINER_TEXT1[21], LocalStrings.ATH_REWARD_CHECK))
			goods_con:setRelativePosition(GlobalMethod:ccp(0.5,0.41))
		elseif info.type == 25 then 
			imgBk:setFile("ui/newActivity/hd_pic_syst_dj_02.png")
			ftxtTitle:setShowText(string.format(strTitleFormat, LocalStrings.MIDNIGHTDINER_TEXT1[22], LocalStrings.ATH_REWARD_CHECK))
			goods_con:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
		end
	elseif info.type == 26 then 
		if info.bIsShowLongBg then 
			conLongBg:setVisible(true)
			if info.imgLongBg then 
				GetElement(reward_6, "img9BG_WndHoraryBigReward", WZUI9Image):setFile(info.imgLongBg)
			end
		end
		if info.goodsconPt then 
		    if type(info.goodsconPt) == "table" then 
		    	goods_con:setRelativePosition(GlobalMethod:ccp(info.goodsconPt[1], info.goodsconPt[2]))
		    else
		    	goods_con:setRelativePosition(info.goodsconPt)
		    end
		end
		if info.imgBK then 
			imgBk:setFile(info.imgBK)
			if info.imgBKPt then 
				if type(info.imgBKPt) == "table" then 
					imgBk:setRelativePosition(GlobalMethod:ccp(info.imgBKPt[1], info.imgBKPt[2]))
				else
					imgBk:setRelativePosition(info.imgBKPt)
				end
			end
		end
		if info.imgRewardTitle then 
			imgRewardTitle:setFile(info.imgRewardTitle)
		else
			imgRewardTitle:setFile("")
		end
		if info.titlePt then 
			if type(info.titlePt) == "table" then 
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(info.titlePt[1], info.titlePt[2]))
			else
				imgRewardTitle:setRelativePosition(info.titlePt)
			end
		end
		if info.strTitle then 
			ftxtTitle:setShowText(info.strTitle)
			if info.txtTitlePt then 
				if type(info.txtTitlePt) == "table" then 
					ftxtTitle:setRelativePosition(GlobalMethod:ccp(info.txtTitlePt[1], info.txtTitlePt[2]))
				else
					ftxtTitle:setRelativePosition(info.txtTitlePt)
				end
			end
		else
			local tempStr = [[<T C="229,105,22" S="22" P="1"></T>]]
			ftxtTitle:setShowText(tempStr)
		end
		if info.imgTitle then 
			imgTitle:setFile(info.imgTitle)
			if info.imgTitlePt then 
				if type(info.imgTitlePt) == "table" then 
					imgTitle:setRelativePosition(GlobalMethod:ccp(info.imgTitlePt[1], info.imgTitlePt[2]))
				else
					imgTitle:setRelativePosition(info.imgTitlePt)
				end
			end
		else
			imgTitle:setFile("")
		end
	end
	if info then
		tLuaObj:setCellGoodLocalId(info.itemId, info.itemNum, 17, nil, info.playerItemId)
		tLuaObj:setItemClickFun(self,self.onItemClick)
		if info.type == 26 then 
			if info.showNum then 
				tLuaObj:setGoodItemCount(info.showNum)
			end
		end

		if info.type == 1 then 
			imgRewardTitle:setFile("ui/activity/bt_text_gxhd_1.png")
		elseif info.type == 2 then 
			imgRewardTitle:setFile("ui/activity/text_dy_hddj.png")
		elseif info.type == 3 or info.type == 5 then 
			imgRewardTitle:setFile("ui/activityWords/text_hd_zdjc_y.png")
		elseif info.type == 4 or info.type == 6 then 
			imgRewardTitle:setFile("ui/activityWords/text_hd_zdjc_t.png")
		elseif info.type == 8 then 
			imgRewardTitle:setFile("ui/activity/bt_text_hddj.png")
		elseif info.type == 10 or info.type == 11 or info.type == 12 or info.type == 13 or info.type == 14 or info.type == 15 or info.type == 16 or info.type == 17 or info.type == 21 or info.type == 22 or info.type == 23 or info.type == 24 or info.type == 25 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_tqq_di.png")
		elseif info.type == 18 then 
			imgRewardTitle:setFile("ui/newActivity/bt_text_mjct_jld.png")
		elseif info.type == 19 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_twzj_xydj.png")
		elseif info.type == 20 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_twzj_cjdj.png")
		end
	end
	if self.m_sFishSpine then
		self.m_sFishSpine:removeFromParentAndCleanup(true)
		self.m_sFishSpine = nil
	end
	local data = {}
	if info.type == 3 or info.type == 4 then 
		data.path = "activity/ui_common_zdjc"
		data._sIndex = "ui_common_zdjc"
	elseif info.type == 5 or info.type == 6 then 
		data.path = "activity/ui_common_nsdzz"
		data._sIndex = "ui_common_nsdzz"
	elseif info.type == 10 then 
		data.path = "activity/ui_tqq_ptj"
		data._sIndex = "ui_tqq_ptj"
	elseif info.type == 11 then 
		data.path = "activity/ui_tqq_dj"
		data._sIndex = "ui_tqq_dj"
	elseif info.type == 12 or info.type == 13 or info.type == 19 then 
		data.path = "activity/ui_xngy_dj"
		data._sIndex = "ui_xngy_dj"
	elseif info.type == 14 then 
		data.path = "activity/ui_kf_ptj"
		data._sIndex = "ui_kf_ptj"
	elseif info.type == 15 then 
		data.path = "activity/ui_kf_dj"
		data._sIndex = "ui_kf_dj"
	elseif info.type == 16 or info.type == 17 then 
		data.path = "activity/ui_xigua_dj"
		data._sIndex = "ui_xigua_dj"
	elseif info.type == 18 then 
		data.path = "activity/hd_pic_mjct_daxiaojinag"
		data._sIndex = "hd_pic_mjct_daxiaojinag"
	elseif info.type == 20 then 
		data.path = "activity/ui_bzch_dj"
		data._sIndex = "ui_bzch_dj"
	elseif info.type == 21 or info.type == 22 then 
		data.path = "activity/hd_pic_niudang_daxiao"
		data._sIndex = "hd_pic_niudang_daxiao"
	elseif info.type == 23 then 
		data.path = "activity/common_pic_shitang_daiji"
		data._sIndex = "common_pic_shitang_daiji"
	elseif info.type == 24 then 
		data.path = "activity/common_pic_shitang_wanghou"
		data._sIndex = "common_pic_shitang_wanghou"
	elseif info.type == 25 then 
		data.path = "activity/common_pic_shitang_mingxing"
		data._sIndex = "common_pic_shitang_mingxing"
	elseif info.type == 26 then 
		if info.spineEffect then 
			data = info.spineEffect
		end
	else
		data.path = "activity/ui_common_sdsc_dj"
		data._sIndex = "ui_common_sdsc_dj"
	end
	if info.type == 1 then 
		data.play = "wait1"
	elseif info.type == 2 then 
		data.play = "wait2"
	elseif info.type == 3 then 
		data.play = "wait2"
	elseif info.type == 4 then 
		data.play = "wait1"
	elseif info.type == 5 then 
		data.play = "wait1"
	elseif info.type == 6 or info.type == 22 then 
		data.play = "wait2"
		if info.type == 22 then 
			data.ccp = GlobalMethod:ccp(0.5, 0.9)
		end
	elseif info.type == 10 or info.type == 11 or info.type == 12 or info.type == 13 or info.type == 14 or info.type == 15 or info.type == 16 or info.type == 17 or info.type == 19 or info.type == 20 or info.type == 21 then 
		data.play = "wait1"
		if info.type == 21 then 
			data.ccp = GlobalMethod:ccp(0.5, 0.9)
		end
	elseif info.type == 18 then 
		data.play = "wait_2"
		data.ccp = GlobalMethod:ccp(0.5, 1.1)
	elseif info.type == 23 or info.type == 24 then 
		data.play = "wait"
		data.ccp = GlobalMethod:ccp(0.5, 0.95)
	elseif info.type == 25 then 
		data.play = "animation"
		data.ccp = GlobalMethod:ccp(0.5, 0.95)
	end
	if data.path then 
		local existSpine = CheckEffectFile(data.path)
		if existSpine then 
			self.m_sFishSpine = createEffectSpine(reward_6, data)
		else
			local _sIndex = data._sIndex
	        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14002,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
	end

	if info and info.type == 26 and info.subType and info.subType == 1 then 
		self.m_tBigData = {}
	else
		table.remove(self.m_tBigData, 1)
	end
end

--@brief 	张灯结彩奖励   类型7
function WndHoraryBigReward:setRewardType7()
	if not self.m_root then
		return
	end
	local reward_7 = GetElement(self.m_root,"reward_7",WZUIContainer)
	reward_7:setVisible(true)
	local goods_con = GetElement(reward_7,"goods_con",WZUIContainer)
	local imgRewardTitle = GetElement(reward_7, "imgRewardTitle_WndHoraryBigReward", WZUIImage)
	local tbRewardList = GetElement(reward_7, "tbRewardList_WndHoraryBigReward", WZUITableContainer)
	local img9BG = GetElement(reward_7, "img9BG_WndHoraryBigReward", WZUI9Image)
	local imgTitle = GetElement(reward_7, "imgTitle_WndHoraryBigReward", WZUIImage)
	local txtBtnGet = GetElement(reward_7, "txtBtnGet_WndHoraryBigReward", WZUILabelTTF)
	txtBtnGet:setText(LocalStrings.NEWYEAR_TEXT8)
	imgTitle:setFile("")
	if self.m_nBigType == 9 then 
		GetElement(reward_7, "btnClose_WndHoraryBigReward", WZUIButton):setVisible(false)
		GetElement(reward_7, "txtAttText_WndHoraryBigReward", WZUILabelTTF):setText("")
		tbRewardList:setVisible(false)
		goods_con:setVisible(true)
		if self.m_sFishSpine then
			self.m_sFishSpine:removeFromParentAndCleanup(true)
			self.m_sFishSpine = nil
		end
		goods_con:removeAllChildrenWithCleanup(true)
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		local info = self.m_tBigData[1]
		local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
		imgBk:setVisible(true)
		goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.51))
		WZLog("WndHoraryBigReward:setRewardType7", Serialize(info))
		if info then
			tLuaObj:setCellGoodLocalId(info.itemId, info.itemNum, 17, nil, info.playerItemId)
			tLuaObj:setItemClickFun(self,self.onItemClick)

			local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
			if info.type == 2 then 
				imgRewardTitle:setFile("ui/activityWords/text_bzch_pdg.png")
			elseif info.type == 3 then 
				imgRewardTitle:setFile("ui/activityWords/text_bzch_lyc.png")
			elseif info.type == 4 or info.type == 5 then --保龄球大奖  --保龄球特等奖
				goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
				GetElement(reward_7, "imgBkDiWen_WndHoraryBigReward", WZUIImage):setFile("ui/newActivity/common_jl_diwen.png")
				imgBk:setFile("ui/activity/common_jl_ditu.png")
				img9BG:setFile("ui/activity/common_jl_di.png")
				imgRewardTitle:setFile("ui/newActivity/text_hd_tqq_di.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.983))
				local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				if ProjConfig.LANGUAGE == "vn" then
					strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				end
				local strTemp = LocalStrings.BOWLING_TEXT1[7]
				if info.type == 5 then 
					strTemp = LocalStrings.BOWLING_TEXT1[8]
				end
				local strCOntent = string.format(strTitleFormat, LocalStrings.GET, strTemp)
				ftxtTitle:setShowText(strCOntent)
			elseif info.type == 8 then 
				if info.goodsconPt then 
					if type(info.goodsconPt) == "table" then 
				    	goods_con:setRelativePosition(GlobalMethod:ccp(info.goodsconPt[1], info.goodsconPt[2]))
					else
				    	goods_con:setRelativePosition(info.goodsconPt)
				    end
				end
				if info.imgBK then 
					imgBk:setFile(info.imgBK)
					if info.imgBKPt then 
						if type(info.imgBKPt) == "table" then 
					    	imgBk:setRelativePosition(GlobalMethod:ccp(info.imgBKPt[1], info.imgBKPt[2]))
						else
							imgBk:setRelativePosition(info.imgBKPt)
						end
					end
				end
				if info.imgRewardTitle then 
					imgRewardTitle:setFile(info.imgRewardTitle)
				end
				if info.titlePt then 
					if type(info.titlePt) == "table" then 
				    	imgRewardTitle:setRelativePosition(GlobalMethod:ccp(info.titlePt[1], info.titlePt[2]))
					else
						imgRewardTitle:setRelativePosition(info.titlePt)
					end
				end
				if info.strTitle then 
					ftxtTitle:setShowText(info.strTitle)
					if info.txtTitleAPt then 
						if type(info.txtTitleAPt) == "table" then 
					    	ftxtTitle:setAnchorPoint(GlobalMethod:ccp(info.txtTitleAPt[1], info.txtTitleAPt[2]))
						else
							ftxtTitle:setAnchorPoint(info.txtTitleAPt)
						end
					else
					    ftxtTitle:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
					end
					if info.txtTitlePt then 
						if type(info.txtTitlePt) == "table" then 
					    	ftxtTitle:setRelativePosition(GlobalMethod:ccp(info.txtTitlePt[1], info.txtTitlePt[2]))
						else
							ftxtTitle:setRelativePosition(info.txtTitlePt)
						end
					end
				end
				WZLog("WndHoraryBigReward:setRewardType7  jjjj", tostring(info.randomBtnVisible))
				if info.randomBtnVisible ~= nil then 
					tLuaObj:setRandomBtnVisible(info.randomBtnVisible)
				end



				if info.showImgBk ~= nil then
					local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
					imgBk:setVisible(info.showImgBk)
				end
				
				if info.imgBKTouch ~= nil then
					local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
					imgBk:setTouchEnable(info.imgBKTouch)
				end

				if info.btnClose2Pt then
					local btnClose2 = GetElement(reward_7, "btnClose2_WndHoraryBigReward", WZUIButton)
					if type(info.btnClose2Pt) == "table" then 
						btnClose2:setRelativePosition(GlobalMethod:ccp(info.btnClose2Pt[1], info.btnClose2Pt[2]))
					else
						btnClose2:setRelativePosition(info.btnClose2Pt)
					end
				end

				if info.imgClose2Path then
					local imgBtnGet = GetElement(reward_7, "imgBtnGet_WndHoraryBigReward", WZUIImage)
					imgBtnGet:setFile(info.imgClose2Path)
				end

				if info.ftxtTitlePt then
					local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
					if type(info.ftxtTitlePt) == "table" then 
						ftxtTitle:setRelativePosition(GlobalMethod:ccp(info.ftxtTitlePt[1], info.ftxtTitlePt[2]))
					else
						ftxtTitle:setRelativePosition(info.ftxtTitlePt)
					end
				end
				
				if info.strAttText then
					local txtAttText = GetElement(reward_7, "txtAttText_WndHoraryBigReward", WZUILabelTTF)
					txtAttText:setText(strAttText)
				end

				if info.txtBtnWords then
					txtBtnGet:setText(info.txtBtnWords)
				end

			end
		end

		local data = {}
		local _sIndex = "ui_bzch_dj"
		if info.type == 4 then 
			data.path = "activity/ui_dishu_ptj"
			_sIndex = "ui_dishu_ptj"
			data.play = "wait1"
		elseif info.type == 5 then 
			data.path = "activity/ui_dishu_dj"
			_sIndex = "ui_dishu_dj"
			data.play = "wait1"
		elseif info.type == 8 then 
			if info.spineEffect then 
				data = info.spineEffect
				_sIndex = info.spineEffect._sIndex
			end
		else
			data.path = "activity/ui_bzch_dj"
			data.play = "wait1"
		end
		if data.path then 
			local existSpine = CheckEffectFile(data.path)
			if existSpine then 
				self.m_sFishSpine = createEffectSpine(reward_7, data)
				self.m_sFishSpine:setTouchEnable(false)
				if info.spineEffect and info.spineEffect._pos then
					if type(info.spineEffect._pos) == "table" then 
						self.m_sFishSpine:setRelativePosition(GlobalMethod:ccp(info.spineEffect._pos[1], info.spineEffect._pos[2]))
					else
						self.m_sFishSpine:setRelativePosition(info.spineEffect._pos)
					end
				end
			else
		        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
		        if downloadInfo then 
		        	DownloadManager:addDownloadTask(14001,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
		        end
			end
		end

		table.remove(self.m_tBigData, 1)
	else	
		if self.m_sFishSpine then
			self.m_sFishSpine:removeFromParentAndCleanup(true)
			self.m_sFishSpine = nil
		end
		GetElement(reward_7, "txtAttText_WndHoraryBigReward", WZUILabelTTF):setText(LocalStrings.GARDEN_TEXT1[28])
		if self.m_nBigType == 8 then 
			if self.m_tBigData[1].type == 2 then 
				imgRewardTitle:setFile("ui/newActivity/bt_text_ewhd.png")
			elseif self.m_tBigData[1].type == 5 then 
				imgRewardTitle:setFile("ui/newActivity/bt_text_chfj.png")
			elseif self.m_tBigData[1].type == 6 then 
				img9BG:setFile("ui/activity/common_jl_di.png")
				imgRewardTitle:setFile("ui/newActivity/bt_text_gxhd_2.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.982))
			elseif self.m_tBigData[1].type == 7 then 
				img9BG:setFile("ui/activity/common_jl_di.png")
				imgRewardTitle:setFile("ui/newActivity/text_hd_tqq_di.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.982))
				local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
				local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				if ProjConfig.LANGUAGE == "vn" then
					strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				end
				local strTemp = LocalStrings.BOWLING_TEXT1[12]
				local strCOntent = string.format(strTitleFormat, LocalStrings.GET, strTemp)
				ftxtTitle:setShowText(strCOntent)
			elseif self.m_tBigData[1].type == 8 then 
				if self.m_tBigData[1].imgRewardTitle then 
					imgRewardTitle:setFile(self.m_tBigData[1].imgRewardTitle)
				end
				if self.m_tBigData[1].img9BG then 
					img9BG:setFile(self.m_tBigData[1].img9BG)
				end
				if self.m_tBigData[1].titlePt then 
					if type(self.m_tBigData[1].titlePt) == "table" then 
				    	imgRewardTitle:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].titlePt[1], self.m_tBigData[1].titlePt[2]))
					else
						imgRewardTitle:setRelativePosition(self.m_tBigData[1].titlePt)
					end
				end
				if self.m_tBigData[1].strTitle then 
					local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
					ftxtTitle:setShowText(self.m_tBigData[1].strTitle)
					if self.m_tBigData[1].txtTitlePt then 
						if type(self.m_tBigData[1].txtTitlePt) == "table" then 
					    	ftxtTitle:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].txtTitlePt[1], self.m_tBigData[1].txtTitlePt[2]))
						else
							ftxtTitle:setRelativePosition(self.m_tBigData[1].txtTitlePt)
						end
					end
				end
				if self.m_tBigData[1].imgTitle then 
					imgTitle:setFile(self.m_tBigData[1].imgTitle)
				end
				if self.m_tBigData[1].imgTitleWordsPt then 
					if type(self.m_tBigData[1].imgTitleWordsPt) == "table" then 
				    	imgTitle:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].imgTitleWordsPt[1], self.m_tBigData[1].imgTitleWordsPt[2]))
					else
						imgTitle:setRelativePosition(self.m_tBigData[1].imgTitleWordsPt)
					end
				end
				if self.m_tBigData[1].txtBtnWords then 
					txtBtnGet:setText(self.m_tBigData[1].txtBtnWords)
				end


				if self.m_tBigData[1].imgBK then
					local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
					imgBk:setFile(self.m_tBigData[1].imgBK)
					if self.m_tBigData[1].imgBKPt then 
						if type(self.m_tBigData[1].imgBKPt) == "table" then 
					    	imgBk:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].imgBKPt[1], self.m_tBigData[1].imgBKPt[2]))
						else
							imgBk:setRelativePosition(self.m_tBigData[1].imgBKPt)
						end
					end
				end

				if self.m_tBigData[1].showImgBk ~= nil then
					local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
					imgBk:setVisible(self.m_tBigData[1].showImgBk)
				end
				
				if self.m_tBigData[1].imgBKTouch ~= nil then
					local imgBk = GetElement(reward_7, "imgBk_WndHoraryBigReward", WZUIImage)
					imgBk:setTouchEnable(self.m_tBigData[1].imgBKTouch)
				end

				if self.m_tBigData[1].spineEffect then
					local data = self.m_tBigData[1].spineEffect
					local _sIndex = self.m_tBigData[1].spineEffect._sIndex
					local existSpine = CheckEffectFile(data.path)
					if existSpine then 
						self.m_sFishSpine = createEffectSpine(reward_7, data)
						self.m_sFishSpine:setTouchEnable(false)
						if self.m_tBigData[1].spineEffect._pos then
							if type(self.m_tBigData[1].spineEffect._pos) == "table" then 
								self.m_sFishSpine:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].spineEffect._pos[1], self.m_tBigData[1].spineEffect._pos[2]))
							else
								self.m_sFishSpine:setRelativePosition(self.m_tBigData[1].spineEffect._pos)
							end
						end
					else
						local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
						if downloadInfo then 
							DownloadManager:addDownloadTask(14001,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
						end
					end
				end

				if self.m_tBigData[1].btnClose2Pt then
					local btnClose2 = GetElement(reward_7, "btnClose2_WndHoraryBigReward", WZUIButton)
					if type(self.m_tBigData[1].btnClose2Pt) == "table" then 
						btnClose2:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].btnClose2Pt[1], self.m_tBigData[1].btnClose2Pt[2]))
					else
						btnClose2:setRelativePosition(self.m_tBigData[1].btnClose2Pt)
					end
				end

				if self.m_tBigData[1].imgClose2Path then
					local imgBtnGet = GetElement(reward_7, "imgBtnGet_WndHoraryBigReward", WZUIImage)
					imgBtnGet:setFile(self.m_tBigData[1].imgClose2Path)
				end

				if self.m_tBigData[1].ftxtTitlePt then
					local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
					if type(self.m_tBigData[1].ftxtTitlePt) == "table" then 
						ftxtTitle:setRelativePosition(GlobalMethod:ccp(self.m_tBigData[1].ftxtTitlePt[1], self.m_tBigData[1].ftxtTitlePt[2]))
					else
						ftxtTitle:setRelativePosition(self.m_tBigData[1].ftxtTitlePt)
					end
				end
				
				if self.m_tBigData[1].strAttText then
					local txtAttText = GetElement(reward_7, "txtAttText_WndHoraryBigReward", WZUILabelTTF)
					txtAttText:setText(strAttText)
				end

			end
		elseif self.m_nBigType == 10 then 
			if self.m_tBigData[1] and self.m_tBigData[1].type == 3 then 
				imgRewardTitle:setFile("ui/activityWords/bt_text_xnxl.png")
			elseif self.m_tBigData[1] and self.m_tBigData[1].type == 4 then 
				imgRewardTitle:setFile("ui/newActivity/text_hd_xnyy_dl.png")
			else
				imgRewardTitle:setFile("ui/newActivity/text_hd_xnyy_dj.png")
			end
		elseif self.m_nBigType == 11 then --丹道修真
			imgRewardTitle:setFile("ui/newActivity/bt_text_ddxz_jld.png")
			imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.992))
			local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
			local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
			local strTemp = ""
			if self.m_tBigData[1].type == 1 then 
				strTemp = LocalStrings.ALCHEMY_TEXT1[18]
			elseif self.m_tBigData[1].type == 2 then 
				strTemp = LocalStrings.ALCHEMY_TEXT1[19]
			end
			local strCOntent = string.format(strTitleFormat, strTemp, LocalStrings.GET)
			ftxtTitle:setShowText(strCOntent)
		elseif self.m_nBigType == 13 or self.m_nBigType == 15 then --欢乐地鼠/套圈圈
			if self.m_nBigType == 13 then 
				imgRewardTitle:setFile("ui/newActivity/bt_text_gxhd_2.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.992))
			elseif self.m_nBigType == 15 then 
				imgRewardTitle:setFile("ui/newActivity/bt_text_gxhd_2.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.992))
			end
			if #self.m_tBigData > 0 then 
				if self.m_tSpecialReward and #self.m_tSpecialReward > 0 then 
					local conOther = GetElement(reward_7, "conOther_WndHoraryBigReward", WZUIContainer)
					conOther:setVisible(true)
					reward_7:setAbsContentSize(GlobalMethod:CCSize(1130,500))
					reward_7:updateRelativeSize()
					goods_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.76))
					tbRewardList:setRelativePosition(GlobalMethod:ccp(0.5, 0.76))
					local ftxtOtherTitle = GetElement(reward_7, "ftxtOtherTitle_WndHoraryBigReward", WZUIFreeTextBox)
					local strTitleFormat = [[<T C="249,255,0" S="40" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="40" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
					if ProjConfig.LANGUAGE == "vn" then
						strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
					end
					local strTemp = ""
					local strCOntent = nil 
					if self.m_nBigType == 13 then 
						if self.m_tSpecialReward[1].type == 5 then 
							strTemp = LocalStrings.BEATMICE_TEXT1[13]
						elseif self.m_tSpecialReward[1].type == 6 then 
							strTemp = LocalStrings.BEATMICE_TEXT1[14]
						end
						strCOntent = string.format(strTitleFormat, LocalStrings.BEATMICE_TEXT1[12], strTemp)
					elseif self.m_nBigType == 15 then 
						GetElement(reward_7, "imgTitle2_WndHoraryBigReward", WZUIImage):setFile("ui/newActivity/text_hd_tqq_di.png")
						local tTempDollType = {}
						for i = 1, #self.m_tSpecialReward do
							if not utilsValueInTable(self.m_tSpecialReward[i].type, tTempDollType) then 
								table.insert(tTempDollType, self.m_tSpecialReward[i].type)
							end
						end
						for i = 1, #tTempDollType do
							if i > 1 then 
								strTemp = strTemp .. ","
							end
							strTemp = strTemp .. LocalStrings.SETCIRCLE_TEXT1[13 + tTempDollType[i]]
						end
						strCOntent = string.format(strTitleFormat, LocalStrings.SETCIRCLE_TEXT1[13], strTemp)
					end
					ftxtOtherTitle:setShowText(strCOntent)
					local goods_con_other = GetElement(reward_7, "goods_con_other", WZUIContainer)
					goods_con_other:setVisible(true)
					local nGapping = 0.45
					local posXStart = 0.5 - (#self.m_tSpecialReward - 1) * 0.45
					for i = 1, #self.m_tSpecialReward do
						local celElement,tLuaObj = CellGoodItem:createElement()
						celElement:setRelativePosition(GlobalMethod:ccp(posXStart + (i - 1) * nGapping * 2, 0.5))
						goods_con_other:addChild(celElement)
						if self.m_tSpecialReward[i] then
							tLuaObj:setCellGoodLocalId(self.m_tSpecialReward[i].itemId, self.m_tSpecialReward[i].itemNum, 17, nil, self.m_tSpecialReward[i].playerItemId)
							tLuaObj:setItemClickFun(self,self.onItemClick)

							tLuaObj:showConversion(nil, nil, true)
						end
					end
				end
			else
				imgRewardTitle:setFile("ui/newActivity/bt_text_ddxz_jld.png")
				self.m_tBigData = self.m_tSpecialReward
				local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
				local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				if ProjConfig.LANGUAGE == "vn" then
					strTitleFormat = [[<T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
				end
				local strTemp = ""
				local strCOntent = nil 
				if self.m_nBigType == 13 then 
					if self.m_tBigData[1].type == 5 then 
						strTemp = LocalStrings.BEATMICE_TEXT1[13]
					elseif self.m_tBigData[1].type == 6 then 
						strTemp = LocalStrings.BEATMICE_TEXT1[14]
					end
					strCOntent = string.format(strTitleFormat, LocalStrings.BEATMICE_TEXT1[12], strTemp)
				elseif self.m_nBigType == 15 then 
					imgRewardTitle:setFile("ui/newActivity/text_hd_tqq_di.png")
					imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.97))
					local tTempDollType = {}
					for i = 1, #self.m_tBigData do
						if not utilsValueInTable(self.m_tSpecialReward[i].type, tTempDollType) then 
							table.insert(tTempDollType, self.m_tSpecialReward[i].type)
						end
					end
					for i = 1, #tTempDollType do
						if i > 1 then 
							strTemp = strTemp .. ","
						end
						strTemp = strTemp .. LocalStrings.SETCIRCLE_TEXT1[13 + tTempDollType[i]]
					end
					strCOntent = string.format(strTitleFormat, LocalStrings.SETCIRCLE_TEXT1[13], strTemp)
				end
				ftxtTitle:setShowText(strCOntent)
			end
		elseif self.m_nBigType == 16 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_tqq_di.png")
			imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.97))
			local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
			local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
			if ProjConfig.LANGUAGE == "vn" then
				strTitleFormat = [[<T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
			end
			strCOntent = string.format(strTitleFormat, LocalStrings.SETCIRCLE_TEXT1[17], LocalStrings.GET)
			ftxtTitle:setShowText(strCOntent)
		elseif self.m_nBigType == 17 then 
			if self.m_sFishSpine then
				self.m_sFishSpine:removeFromParentAndCleanup(true)
				self.m_sFishSpine = nil
			end
			imgRewardTitle:setFile("ui/newActivity/bt_text_mjct_jld.png")
			local strTitleFormat = [[<T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0"></T>]]
			if ProjConfig.LANGUAGE == "vn" then
				strTitleFormat = [[<T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0"></T>]]
			end
			local ftxtTitle = GetElement(reward_7, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
			if self.m_tBigData[1][1].type == 1 then 
				ftxtTitle:setShowText(strTitleFormat)
				imgTitle:setFile("ui/activity/bt_text_gxhd_1.png")
				GetElement(reward_7, "btnClose_WndHoraryBigReward", WZUIButton):setVisible(true)
			elseif self.m_tBigData[1][1].type == 2 then 
				GetElement(reward_7, "btnClose_WndHoraryBigReward", WZUIButton):setVisible(true)
				ftxtTitle:setShowText(string.format(LocalStrings.SECRETTOWER_TEXT1[25], self.m_tBigData[1][1].floor))
			elseif self.m_tBigData[1][1].type == 3 then 
				GetElement(reward_7, "btnClose_WndHoraryBigReward", WZUIButton):setVisible(false)
				GetElement(reward_7, "txtAttText_WndHoraryBigReward", WZUILabelTTF):setText("")
				ftxtTitle:setShowText(strTitleFormat)
				imgTitle:setFile("ui/activityWords/text_mjct_xj.png")

				local data = {}
				local _sIndex = "hd_pic_mjct_daxiaojinag"
				data.path = "activity/hd_pic_mjct_daxiaojinag"
				
				data.play = "wait_1"
				data.ccp = GlobalMethod:ccp(0.5, 1.1)
				
				local existSpine = CheckEffectFile(data.path)
				if existSpine then 
					self.m_sFishSpine = createEffectSpine(reward_7, data)
					self.m_sFishSpine:setTouchEnable(false)
				else
			        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
			        if downloadInfo then 
			        	DownloadManager:addDownloadTask(14001,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
			        end
				end
			elseif self.m_tBigData[1][1].type == 5 then 
				GetElement(reward_7, "btnClose_WndHoraryBigReward", WZUIButton):setVisible(true)
				ftxtTitle:setShowText(LocalStrings.SECRETTOWER_TEXT1[28])
			end
		elseif self.m_nBigType == 7 then 
			if self.m_tBigData[1].type == 8 then 
				imgRewardTitle:setFile("ui/activityWords/text_hd_twzj_hdjl.png")
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.982))
			elseif self.m_tBigData[1].type == 9 or self.m_tBigData[1].type == 10 then 
				imgRewardTitle:setFile("ui/activity/bt_text_gxhd_1.png")
			end
		end
		local nCount = #self.m_tBigData
		local tTempTable = self.m_tBigData 
		if self.m_nBigType == 17 then 
			tTempTable = self.m_tBigData[1]
			nCount = #tTempTable
		end
		tbRewardList:cleanTable()
		tbRewardList:setVisible(false)
		goods_con:setVisible(false)
		if nCount <= 5 then  
			goods_con:removeAllChildrenWithCleanup(true)
			goods_con:setVisible(true)
			local nGapping = 0.45
			local posXStart = 0.5 - (nCount - 1) * 0.45
			WZLog("WndHoraryBigReward:setRewardType7", Serialize(tTempTable))
			for i = 1, nCount do
				if tTempTable[i].itemId then
					local celElement,tLuaObj = CellGoodItem:createElement()
					celElement:setRelativePosition(GlobalMethod:ccp(posXStart + (i - 1) * nGapping * 2, 0.5))
					goods_con:addChild(celElement)
					if tTempTable[i] then
						tLuaObj:setCellGoodLocalId(tTempTable[i].itemId, tTempTable[i].itemNum, 17, nil, tTempTable[i].playerItemId, tTempTable[i].origin)
						tLuaObj:setItemClickFun(self,self.onItemClick)

						tLuaObj:showConversion(nil, nil, true)
						if tTempTable[i].randomBtnVisible ~= nil then 
							tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
						end
					end
					if tTempTable[i].randomBtnVisible ~= nil then 
						tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
					end
					if tTempTable[i].randomBtnVisible ~= nil then 
						tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
					end
				end
			end
		else
			tbRewardList:setVisible(true)
			for i = 1, nCount do
				if tTempTable[i].itemId then
					local celElement,tLuaObj = CellGoodItem:createElement()
					if tTempTable[i] then
						celElement:setTag(i - 1)
						tLuaObj:setCellGoodLocalId(tTempTable[i].itemId, tTempTable[i].itemNum, 17, nil, tTempTable[i].playerItemId, tTempTable[i].origin)
						tLuaObj:setItemClickFun(self,self.onItemClick)

						tLuaObj:showConversion(nil, nil, true)
						tbRewardList:setCellElement(celElement)
						if tTempTable[i].randomBtnVisible ~= nil then 
							tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
						end
					end
					if tTempTable[i].randomBtnVisible ~= nil then 
						tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
					end
					if tTempTable[i].randomBtnVisible ~= nil then 
						tLuaObj:setRandomBtnVisible(tTempTable[i].randomBtnVisible)
					end
				end
			end
		end

		if self.m_nBigType == 8 then 
			if self.m_tBigData[1].type == 8 then 
				if self.m_tBigData[1].showRewardList ~= nil then
					tbRewardList:setVisible(self.m_tBigData[1].showTbRewardList)
				end

				if self.m_tBigData[1].showGoodsCon ~= nil then
					goods_con:setVisible(self.m_tBigData[1].showGoodsCon)
				end
			end
		end

		if self.m_nBigType == 17 then 
			table.remove(self.m_tBigData, 1)
		end
	end
end

--@brief 	丹道修真奖励   类型8
function WndHoraryBigReward:setRewardType8()
	if not self.m_root then
		return
	end
	local reward_8 = GetElement(self.m_root,"reward_8",WZUIContainer)
	reward_8:setVisible(true)
	local goods_con = GetElement(reward_8,"goods_con",WZUIContainer)
	local ftxtTitle = GetElement(reward_8, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
	local strTitleFormat = [[<T C="255,255,255" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="52" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
	if ProjConfig.LANGUAGE == "vn" then
		strTitleFormat = [[<T C="255,255,255" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T><T C="249,255,0" S="30" P="1" SC="222,78,0" SS="4" SE="0">%s</T>]]
	end
	local tTempData = self.m_tBigData[1]
	WZLog("WndHoraryBigReward:setRewardType8", Serialize(tTempData))
	local strCOntent = ""
	local spineFilePath = "activity/ui_xiuzhen"
	local animationName = "wait"
	local _sIndex = "ui_xiuzhen"
	goods_con:removeAllChildrenWithCleanup(true)
	if self.m_nBigType == 12 then 
		local strTemp = ""
		if tTempData[1].type == 3 then 
			strTemp = LocalStrings.ALCHEMY_TEXT1[16]
			strCOntent = string.format(strTitleFormat, LocalStrings.GET, strTemp)
		elseif tTempData[1].type == 4 then 
			strTemp = LocalStrings.ALCHEMY_TEXT1[17]
			strCOntent = string.format(strTitleFormat, LocalStrings.GET, strTemp)
		elseif tTempData[1].type == 5 then 
			strTemp = LocalStrings.ALCHEMY_TEXT1[22]
			strCOntent = string.format(strTitleFormat, strTemp, LocalStrings.GET)
		elseif tTempData[1].type == 6 then 
			strTemp = LocalStrings.ALCHEMY_TEXT1[23]
			strCOntent = string.format(strTitleFormat, strTemp, LocalStrings.GET)
		end
		ftxtTitle:setShowText(strCOntent)
	elseif self.m_nBigType == 14 then --欢乐地鼠大奖 
		GetElement(reward_8, "imgBk_WndHoraryBigReward", WZUIImage):setFile("ui/newActivity/hd_pic_hlds_03.png")
		GetElement(reward_8, "imgBk_WndHoraryBigReward", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.53, 0.5))
		local imgRewardTitle = GetElement(reward_8, "imgRewardTitle_WndHoraryBigReward", WZUIImage)
		if tTempData[1].type == 3 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_hlds_xydj.png")
			spineFilePath = "activity/ui_dishu_dj"
			animationName = "wait1"
			_sIndex = "ui_dishu_dj"
		elseif tTempData[1].type == 4 then 
			imgRewardTitle:setFile("ui/newActivity/text_hd_hlds_cjdj.png")
			spineFilePath = "activity/ui_dishu_ptj"
			animationName = "wait1"
			_sIndex = "ui_dishu_ptj"
		end
	end

	if self.m_sFishSpine then
		self.m_sFishSpine:removeFromParentAndCleanup(true)
		self.m_sFishSpine = nil
	end
	local nCount = #tTempData
	goods_con:setVisible(true)
	local nGapping = 0.45
	local posXStart = 0.5 - (nCount - 1) * 0.45
	for i = 1, nCount do
		local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setRelativePosition(GlobalMethod:ccp(posXStart + (i - 1) * nGapping * 2, 0.5))
		goods_con:addChild(celElement)
		if tTempData[i] then
			local itemInfo = {lastTime=tTempData[i].itemNum,lastNum=tTempData[i].itemNum,basicInfo=CopyTable(GDatatab_item["id_"..tTempData[i].itemId]),playerItemId=tTempData[i].playerItemId}
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(self,self.onItemClick)

			tLuaObj:showConversion(nil, nil, true)
		end
	end

	local data = {}
	data.path = spineFilePath
	data.ccp = GlobalMethod:ccp(0.5,1.04)
	data.play = animationName
	local existSpine = CheckEffectFile(data.path)
	if existSpine then 
		self.m_sFishSpine = createEffectSpine(reward_8, data)
		self.m_sFishSpine:setTouchEnable(false)
	else
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(14000,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
        end
	end

	table.remove(self.m_tBigData, 1)
end

--@brief 	疯狂扭蛋奖励   类型9
function WndHoraryBigReward:setRewardType9()
	if not self.m_root then
		return
	end
	local reward_9 = GetElement(self.m_root,"reward_9",WZUIContainer)
	reward_9:setVisible(true)

	local txtR9_1 = GetElement(reward_9,"txtR9_1_WndHoraryBigReward",WZUILabelTTF)
	txtR9_1:setText(LocalStrings.CRAZY_GASHAPON_TEXT1[13])

	local tItem = self.m_tBigData
	-- tItem.id
	-- tItem.num
	-- tItem.playerItemId
	for i=1,5 do
		local conR9Item = GetElement(reward_9,"conR9Item"..i.."_WndHoraryBigReward",WZUIContainer)
		conR9Item:setVisible(false)
	end

	local nCount = #tItem.id
	local nGapping = 0.1
	local posXStart = 0.1 + (5 - nCount) * nGapping
	for i = 1, nCount do
		local conR9Item = GetElement(reward_9,"conR9Item"..i.."_WndHoraryBigReward",WZUIContainer)
		conR9Item:setRelativePosition(GlobalMethod:ccp(posXStart + (i-1) * nGapping * 2, 0.5))
		conR9Item:setVisible(true)
		local goods_con = GetElement(conR9Item,"goods_con",WZUIContainer)
		goods_con:removeAllChildrenWithCleanup(true)

		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)


		local itemInfo = {lastTime=tItem.num[i],lastNum=tItem.num[i],basicInfo=CopyTable(GDatatab_item["id_"..tItem.id[i]]),playerItemId=tItem.playerItemId[i]}
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(self,self.onItemClick)
		tLuaObj:showConversion(nil, nil, true)
	end

end

--@brief 	出售鲜花奖励   类型10
function WndHoraryBigReward:setRewardType10()
	if not self.m_root then
		return
	end
	local reward_10 = GetElement(self.m_root,"reward_10",WZUIContainer)
	reward_10:setVisible(true)
	local goods_con = GetElement(reward_10,"goods_con",WZUIContainer)
	local goods_con_other = GetElement(reward_10,"goods_con_other",WZUIContainer)
	local imgRewardTitle = GetElement(reward_10, "imgRewardTitle_WndHoraryBigReward", WZUIImage)
	local img9BG = GetElement(reward_10, "img9BG_WndHoraryBigReward", WZUI9Image)
	local txtBtnGet = GetElement(reward_10, "txtBtnGet_WndHoraryBigReward", WZUILabelTTF)
	GetElement(reward_10, "txtTitle1_WndHoraryBigReward", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[36])
	GetElement(reward_10, "txtTitle2_WndHoraryBigReward", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[37])
	txtBtnGet:setText(LocalStrings.NEWYEAR_TEXT8)
	
	local ftxtTitle = GetElement(reward_10, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
	local strTitleFormat = [[<T C="255,250,236" S="36" P="1" SC="225,90,17" SS="4" SE="1">%s</T>]]
	strCOntent = string.format(strTitleFormat, LocalStrings.HOLIDAYVILLAGE_TEXT3[38])
	ftxtTitle:setShowText(strCOntent)
	
	local nCount = #self.m_tBigData
	local tTempTable = self.m_tBigData 
	--基础收益
	goods_con:removeAllChildrenWithCleanup(true)
	goods_con:setVisible(true)
	local nGapping = 0.45
	local posXStart = 0.5
	WZLog("WndHoraryBigReward:setRewardType7", Serialize(tTempTable))
	local celElement,tLuaObj = CellGoodItem:createElement()
	celElement:setScale(0.8)
	goods_con:addChild(celElement)
	if tTempTable[1] then
		tLuaObj:setCellGoodLocalId(tTempTable[1].itemId, tTempTable[1].itemNum, 17, nil, tTempTable[1].playerItemId)
		tLuaObj:setItemClickFun(self,self.onItemClick)
		tLuaObj:setGoodItemCount(tTempTable[1].itemNum)

		tLuaObj:showConversion(nil, nil, true)
	end

	--加成收益
	goods_con_other:removeAllChildrenWithCleanup(true)
	goods_con_other:setVisible(true)
	nCount = #self.m_tOtherBigReward
	local nGapping = 0.45
	local posXStart = 0.5 - (nCount - 1) * 0.45
	for i = 1, nCount do
		local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setRelativePosition(GlobalMethod:ccp(posXStart + (i - 1) * nGapping * 2, 0.5))
		celElement:setScale(0.8)
		goods_con_other:addChild(celElement)
		if self.m_tOtherBigReward[i] then
			tLuaObj:setCellGoodLocalId(self.m_tOtherBigReward[i].itemId, self.m_tOtherBigReward[i].itemNum, 17, nil, self.m_tOtherBigReward[i].playerItemId)
			tLuaObj:setItemClickFun(self,self.onItemClick)

			tLuaObj:showConversion(nil, nil, true)
		end
	end
end

--@brief 	类型11同时展示两个大奖
function WndHoraryBigReward:setRewardType11()
	if not self.m_root then
		return
	end
	local reward_11 = GetElement(self.m_root,"reward_11",WZUIContainer)
	reward_11:setVisible(true)
	local goods_con = GetElement(reward_11,"goods_con",WZUIContainer)
	goods_con:removeAllChildrenWithCleanup(true)
	
	local info = self.m_tBigData[1]
	local imgRewardTitle = GetElement(reward_11, "imgRewardTitle_WndHoraryBigReward", WZUIImage)
	local imgTitle = GetElement(reward_11, "imgTitle_WndHoraryBigReward", WZUIImage)
	imgTitle:setFile("")
	local imgBk = GetElement(reward_11, "imgBk_WndHoraryBigReward", WZUIImage)
	imgBk:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	local ftxtTitle = GetElement(reward_11, "ftxtTitle_WndHoraryBigReward", WZUIFreeTextBox)
	local conLongBg = GetElement(reward_11, "conLongBg_WndHoraryBigReward", WZUIContainer)
	conLongBg:setVisible(false)
	WZLog("WndHoraryBigReward:setRewardType11", info.type)
	if info.type == 27 then 
		if info.bIsShowLongBg then 
			conLongBg:setVisible(true)
			if info.imgLongBg then 
				GetElement(reward_11, "img9BG_WndHoraryBigReward", WZUI9Image):setFile(info.imgLongBg)
			end
		end
		if info.imgBK then 
			imgBk:setFile(info.imgBK)
			if info.imgBKPt then 
				if type(info.imgBKPt) == "table" then 
					imgBk:setRelativePosition(GlobalMethod:ccp(info.imgBKPt[1], info.imgBKPt[2]))
				else
					imgBk:setRelativePosition(info.imgBKPt)
				end
			end
		end
		if info.imgRewardTitle then 
			imgRewardTitle:setFile(info.imgRewardTitle)
		else
			imgRewardTitle:setFile("")
		end
		if info.titlePt then 
			if type(info.titlePt) == "table" then 
				imgRewardTitle:setRelativePosition(GlobalMethod:ccp(info.titlePt[1], info.titlePt[2]))
			else
				imgRewardTitle:setRelativePosition(info.titlePt)
			end
		end
		if info.strTitle then 
			ftxtTitle:setShowText(info.strTitle)
			if info.txtTitlePt then 
				if type(info.txtTitlePt) == "table" then 
					ftxtTitle:setRelativePosition(GlobalMethod:ccp(info.txtTitlePt[1], info.txtTitlePt[2]))
				else
					ftxtTitle:setRelativePosition(info.txtTitlePt)
				end
			end
		else
			local tempStr = [[<T C="229,105,22" S="22" P="1"></T>]]
			ftxtTitle:setShowText(tempStr)
		end
		if info.imgTitle then 
			imgTitle:setFile(info.imgTitle)
			if info.imgTitlePt then 
				if type(info.imgTitlePt) == "table" then 
					imgTitle:setRelativePosition(GlobalMethod:ccp(info.imgTitlePt[1], info.imgTitlePt[2]))
				else
					imgTitle:setRelativePosition(info.imgTitlePt)
				end
			end
		else
			imgTitle:setFile("")
		end
	end
	for i = 1, #self.m_tBigData do
		local celElement,tLuaObj = CellGoodItem:createElement()
		goods_con:addChild(celElement)
		local infoTemp = self.m_tBigData[i]
		if infoTemp.goodsconPt then 
		    if type(infoTemp.goodsconPt) == "table" then 
		    	celElement:setRelativePosition(GlobalMethod:ccp(infoTemp.goodsconPt[1], infoTemp.goodsconPt[2]))
		    else
		    	celElement:setRelativePosition(infoTemp.goodsconPt)
		    end
		end
		if infoTemp then
			tLuaObj:setCellGoodLocalId(infoTemp.itemId, infoTemp.itemNum, 17, nil, infoTemp.playerItemId)
			tLuaObj:setItemClickFun(self,self.onItemClick)
		end
		if self.m_sFishSpine then
			self.m_sFishSpine:removeFromParentAndCleanup(true)
			self.m_sFishSpine = nil
		end
		local data = {}
		if infoTemp.type == 27 then 
			if infoTemp.spineEffect then 
				data = infoTemp.spineEffect
			end
		end
		
		if data.path then 
			local existSpine = CheckEffectFile(data.path)
			if existSpine then 
				createEffectSpine(reward_11, data)
			end
		end
	end

	if infoTemp and infoTemp.type == 27 then 
		self.m_tBigData = {}
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
