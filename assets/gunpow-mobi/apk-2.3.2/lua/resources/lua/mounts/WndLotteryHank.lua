--WndLotteryHank.lua
--@brief	WndLotteryHank的UI模块
--@date		2021/04/28
--@author	hyc
--@note		召唤图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLotteryHank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLotteryHank:onExit(element)
	self:_unInit()
end

function WndLotteryHank:onEnterTransitionDidFinish(element)
	-- body
	self:updateUi()
end

function WndLotteryHank:updateUi()
	-- body
	WZLog("传过来的类型",self.m_type)
	local sex = CacheCenter:getPlayerInfo().sex
	self.m_data = {}
	local tempData = {}
	local data = GDatatab_dwar
	local itemData = GDatatab_item
	for i,v in pairs(data) do
		if v.item_type == self.m_type then
			table.insert(tempData,v.dwar)
		end
	end
	WZLog("图鉴id",Serialize(tempData))
	if self.m_type == 3 then
		for i = 1,#tempData do
			local data = GDatatab_item["id_"..tempData[i]]
			if data.basicInfo == nil then
				data.basicInfo = data
			end
			if data.main_type == 20 then
				if data.sex == sex then
					table.insert(self.m_data,data)
				end
			else
				table.insert(self.m_data,data)
			end
		end
		-- --皮肤装备
		-- if self.m_type == 3 then
		-- 	local tempItemList = {}
		-- 	for key,value in pairs(GDatatab_total_draw) do
		-- 		if value.type == 4 then
		-- 			local itemInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 			itemInfo.basicInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 			if itemInfo.main_type == 37 then
		-- 				if not utilsValueInTable(itemInfo, tempItemList) then
		-- 					table.insert(tempItemList,itemInfo)
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- 	table.sort(tempItemList,function(a,b)
		-- 		if a.quality ~= b.quality then
		-- 			return a.quality < b.quality
		-- 		else
		-- 			return a.id < b.id
		-- 		end
		-- 	end)
		-- 	for i=1,#tempItemList do
		-- 		table.insert(self.m_data,tempItemList[i])
		-- 	end
		-- end

		table.sort(self.m_data,function(a,b)
			if a.main_type == 20 and b.main_type ~= 20 then
				return true
			elseif a.main_type ~= 20 and b.main_type == 20 then
				return false
			else
				if a.quality ~= b.quality then
					return a.quality < b.quality
				else
					return a.id < b.id
				end
			end
		end)
	else 
		for i = 1,#tempData do
			local data = GDatatab_item["id_"..tempData[i]]
			if data.basicInfo == nil then
				data.basicInfo = data
			end
			table.insert(self.m_data,data)
		end
		-- --坐骑灵石
		-- if self.m_type == 2 then
		-- 	local tempItemList = {}
		-- 	for key,value in pairs(GDatatab_total_draw) do
		-- 		if value.type == 3 then
		-- 			local itemInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 			itemInfo.basicInfo = GDatatab_item["id_"..value.item_id[1][1]]
		-- 			if itemInfo.main_type == 38 then
		-- 				if not utilsValueInTable(itemInfo, tempItemList) then
		-- 					table.insert(tempItemList,itemInfo)
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- 	table.sort(tempItemList,function(a,b)
		-- 		if a.quality ~= b.quality then
		-- 			return a.quality < b.quality
		-- 		else
		-- 			return a.id < b.id
		-- 		end
		-- 	end)
		-- 	for i=1,#tempItemList do
		-- 		table.insert(self.m_data,tempItemList[i])
		-- 	end
		-- end

		if self.m_type == 2 then
			table.sort(self.m_data,function(a,b)
				if a.main_type ~= 38 and b.main_type == 38 then
					return true
				elseif a.main_type == 38 and b.main_type ~= 38 then
					return false
				else
					if a.quality ~= b.quality then
						return a.quality < b.quality
					else
						return a.id < b.id
					end
				end
			end)
		elseif self.m_type == 4 then
			table.sort(self.m_data,function(a,b)
				if a.main_type == 23 and b.main_type ~= 23 then
					return true
				elseif a.main_type ~= 23 and b.main_type == 23 then
					return false
				else
					if a.quality ~= b.quality then
						return a.quality < b.quality
					else
						return a.id < b.id
					end
				end
			end)
		end
	end

	if self.m_type == 1 then
		self.m_data = {}
		tempData = {}
		data = GDatatab_pet
		for i,v in pairs(data) do
			if v.yc ~= 1 then
				table.insert(tempData,v.item_id)
			end
		end

		for i = 1,#tempData do
			local data = GDatatab_item["id_"..tempData[i]]
			table.insert(self.m_data,data)
		end
	    function petSort(a,b)
	    	if a.sub_type == b.sub_type then
	    		return a.quality < b.quality
	    	else
	    		return a.sub_type > b.sub_type
	    	end
	    end
	    table.sort(self.m_data, petSort)
	end

	WZLog("获得数据",Serialize(self.m_data))
	local txtName = GetElement(self.m_root,"txtTitle_WndLotteryHank",WZUILabelTTF)
	if self.m_type == 2 then
		txtName:setText(LocalStrings.MOUNT_HANK)
	elseif self.m_type == 4 then
		txtName:setText(LocalStrings.FOOT_HANK)
	elseif self.m_type == 3 then
		txtName:setText(LocalStrings.PHANTOM_HANK)
	elseif self.m_type == 1 then
		txtName:setText(LocalStrings.PET_MAJOR)
	end
	local tabList = GetElement(self.m_root,"hankList_WndLotteryHandk",WZUITableContainer)
	tabList:cleanTable()
	for i,data in pairs(self.m_data) do
		local cellElement,tCell = CellGrid:createElement()
		if cellElement and tCell then
			cellElement:setScale(0.86)
			cellElement:setTag(i-1)
			tabList:setCellElement(cellElement)
			tCell:setCellGoodItem(data,2)
			tCell:setItemClickFun(self,self.onItemClick)
			if self.m_tItemChoice == nil then
				self.m_tItemChoice = tCell
				-- if self.m_type == 4 then
					self:onItemClick(nil,0)
				-- end
			end
		end
	end
	self:_createEmptyItem(tabList,#self.m_data)

end

--@param	创建空白Item
function WndLotteryHank:_createEmptyItem(tableConGoods,num)
	local maxCount = 20
	if num > 20 then
		if num % 4 == 0 then
			maxCount = 0
		else
			maxCount = 4 - num %4
		end
	else
		maxCount = 20-num
	end
	if tableConGoods == nil or maxCount == 0 then
		return 
	end
	for i=1,maxCount do
		local celElement,tCell = CellGrid:createElement()
		if celElement and tCell then
			celElement:setScale(0.86)
			celElement:setTag(num+i-1)
			tableConGoods:setCellElement(celElement)
			--tCell:removeAllChild()
			tCell:setItemClickFun(self,self.onItemClick)
		end
	end
end

--@brief 	item点击回调
function WndLotteryHank:onItemClick(element,tag,tData)
	-- body
	tag = tag + 1
	if element ~= nil then
		self.m_tItemChoice:setHighLight(false)
		self.m_tItemChoice = element
	end
	local itemSize = #self.m_data
	if tag > itemSize then return end
	self.m_tItemChoice:setHighLight(true)
	local id = self.m_data[tag].id
	local name = self.m_data[tag].name
	local animation_index_code = self.m_data[tag].animation_index_code
	local quality = self.m_data[tag].quality
	local footData = {}
	local attrPro = {}


	local nameTxt = GetElement(self.m_root,"nameTxt_WndLotteryHank",WZUIFreeTextBox)
  	local txtColor = g_sFtxtQualityColor
    local color = txtColor[quality]	
    local sLevel = string.format([[<T C=%s S="24" P="1" SE="1" SS="4" SC="132,66,29">%s</T>]], color, name)
  	nameTxt:setShowText(sLevel)
  	nameTxt:setVisible(true)
  	local text2 = [[<T C="127,70,26" S="20" >%s:</T><T C="5,180,0" S="20" >%d</T>]]
  	local footAni = self.m_root:getChildElement("conHankImage_WndLotteryHank")
  	footAni:removeAllChildrenWithCleanup(true)
  	local footId = 1
  	--动画
  	if self.m_type == 4 then
		for k,v in pairs(GDatatab_footmark) do
			if v.item_id == id then
				attrPro = v.property
			end
		end
		if self.m_data[tag].main_type == 23 then
			for k,v in pairs(GDatatab_footmark) do
				if v.item_id == id then
					footId = v.id
				end
			end
			self.m_footSpine = FootEffectManager:addEffect1(footAni,footId,{x=0,y=0 },true)
			self.m_footSpine:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
		else
			local imgNode = WZUIImage:create()
			imgNode:setAnchorPoint(ccp(0.5,0.5))
			imgNode:setRelativePosition(ccp(0.5,0.345))
			imgNode:setUseOriginSize(true)
			imgNode:setFile(self.m_data[tag].icon)

			footAni:addChild(imgNode,5)
		end
	  elseif self.m_type == 3 then
	  	self:showPlayer(id)
	  elseif self.m_type == 2 then
	  	attrPro = self.m_data[tag].property
	  	self:_createMountAni(footAni,self.m_data[tag])
	  elseif self.m_type == 1 then
	  	attrPro = self.m_data[tag].property
	  	local animation_index_code = self.m_data[tag].animation_index_code
	  	local petAni = CreatePetAni(footAni, nil, animation_index_code)
	  end
  	for i=1,6 do
  		local attr = GetElement(self.m_root,"attr"..i.."_WndLotteryHank",WZUIFreeTextBox)
  		attr:setShowText("")
  	end
  	for k,v in pairs(attrPro) do
  		WZLog("打印数据",Serialize(v))
  		local attr = GetElement(self.m_root,"attr"..k.."_WndLotteryHank",WZUIFreeTextBox)
  		if v[1] > 0 then
	  		attr:setShowText(string.format(text2,ATTR_TITLE[v[1]],v[2]))
	  	end
  	end
end

-- 坐骑动画
function WndLotteryHank:_createMountAni(con,info)

    local sex = CacheCenter:getPlayerInfo().sex
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end

	local iteminfo = GDatatab_item["id_"..info.id]
	if iteminfo.main_type == 38 then
		local imgNode = WZUIImage:create()
		imgNode:setAnchorPoint(ccp(0.5,0.5))
		imgNode:setRelativePosition(ccp(0.5,0.345))
		imgNode:setUseOriginSize(true)
		imgNode:setFile(iteminfo.icon)
		con:addChild(imgNode,0,99)
		con:setScale(0)
		local scaleTo = CCScaleTo:create(0.5,1,1)

		con:runAction(scaleTo)
	else
		local head,body = CacheCenter:getHeadAndBodyColor()
		local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
		local animation_index_code = GDatatab_item["id_"..info.id].animation_index_code
		ani:setMount(animation_index_code)

		local node = ani:getAnimNode()
		node:setScale(0.4)
		node:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		node:setRelativePosition(GlobalMethod:ccp(0.5,0))
		con:addChild(node,0,99)
		con:setScale(0)
		local scaleTo = CCScaleTo:create(0.5,1,1)

		con:runAction(scaleTo)
	end
end

--@brief 关闭
function WndLotteryHank:onClickClose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)	
end

--皮肤动画
function WndLotteryHank:showPlayer(nId)

	local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conHankImage_WndLotteryHank"))

	local tdata = GDatatab_item["id_"..nId]
	if tdata.main_type == 37 then
		local imgNode = WZUIImage:create()
		imgNode:setAnchorPoint(ccp(0.5,0.5))
		imgNode:setRelativePosition(ccp(0.5,0.345))
		imgNode:setUseOriginSize(true)
		imgNode:setFile(tdata.icon)

		conP:addChild(imgNode,5)
	else
		for i,v in pairs(GDatatab_shape_skins) do
			if v.channel == nId then
				tdata = v
			end
		end
		local tEquip1 = CacheCenter:getPlayerItems()
		if tEquip1 == nil then return end
		local tEquip = {}
		for k,v in pairs(tEquip1) do
			if v.isUse == true then
				table.insert(tEquip, v)
			end
		end
		local playerInfo = CacheCenter:getPlayerInfo()
		local sex = playerInfo.sex
		--local tData = self.m_tSelectedCell.m_tData
		local showId = tdata.id

		local conPlayer
		local isMonster = true
		if isMonster then
	   		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
	    	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
		end
		conPlayer:setScale(0.6)

	    conP:addChild(conPlayer:getAnimNode(),5)
	end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
