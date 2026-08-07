--WndApartmentActData.lua
--@brief	WndApartmentAct的数据模块
--@date		2017/08/08
--@author	zsq
--@note		公寓活动

WndApartmentAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndApartmentAct:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSoundId = nil
	self.m_nTag = nil
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.endTime = nil
	self.tag3 = nil
	self.data3 = nil
	self.date7 = nil
	self.giftId3 = nil
	self.giftId7 = nil
	self.m_tDataList10 = nil
	self.m_tAllActivityType = nil 	--代言人活动的活动类型
	self.m_nDisappearTime = nil 	--活动不展示的时间
	self.m_nodeElement = nil 
	self.m_tCellElement = nil 
	self.m_nMoveElementPosY = nil 
	self.m_tCurShowActivityId = {} --活动有数据不会进入
	self.m_nCurIndex = nil
	self.m_sComeInFlag = nil
	self.m_tTabTitleName = {}
	self.m_tTabTitleColor = {}
	self.m_sFootSpine = nil
	self.m_sConSkinPlayer = nil
	self.m_sAniMount = nil
	self.m_sWeaponCellItem = nil
	self.m_sRoleConPlayer = nil
	self.m_nChooseActivityIndex = nil
	self.m_CellApartList = {} --限购礼包item列表
	self.m_CellDataList = {}  --限购礼包数据列表
	self.m_ChoseItem = nil 	  --选中的礼包数据
	self.m_nChooseIndex1 = 1 	--3044活动选中礼包索引
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndApartmentAct:_unInit()
	self.m_root = nil
	self.m_nSoundId = nil
	self.m_nTag = nil
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.m_nConListPositionY = nil
	self.endTime = nil
	self.tag3 = nil
	self.data3 = nil
	self.date7 = nil
	self.giftId3 = nil
	self.giftId7 = nil
	self.m_tDataList10 = nil
	self.m_tAllActivityType = nil 	--代言人活动的活动类型
	self.m_nDisappearTime = nil 
	self.m_nodeElement = nil 
	self.m_tCellElement = nil 
	self.m_nMoveElementPosY = nil 
	self.m_tCurShowActivityId = {}
	self.m_nCurIndex = nil
	self.m_sComeInFlag = nil
	self.m_tTabTitleName = {}
	self.m_tTabTitleColor = {}
	self.m_sFootSpine = nil
	self.m_sConSkinPlayer = nil
	self.m_sAniMount = nil
	self.m_sWeaponCellItem = nil
	self.m_sRoleConPlayer = nil
	self.m_nChooseActivityIndex = nil
	self.m_CellApartList = nil
	self.m_CellDataList = nil
	self.m_ChoseItem = nil
	self.m_nChooseIndex1 = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndApartmentAct:createElement(index)
	if WndApartmentAct.m_root ~= nil then
		WindowManager:removeWindow(WndApartmentAct.m_root, WndApartmentAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndApartmentAct")
	assert(element, "WndApartmentAct create element failed!")
	self:_init()
	self.m_nChooseActivityIndex = index
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	活动列表
--@param1 	param1: 活动不展示的时间戳
function WndApartmentAct:GetActivityListInfoOK(activityId, title, startTime, endTime, serverTime , types, type2, param1, param2)
	WZLog("WndApartmentAct:GetActivityListInfoOK")
    if self.m_root == nil then return end
    self.m_tListItem = {}
    local index = 1 
	for i=1,#activityId do
        WZLog("WndApartmentAct:GetActivityListInfoOK111", activityId[i], title[i],type2[i],types[i], param1[i], param2[i])
		if type2[i] == 4 then    --等于4 的才是代言人活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then
    				self.m_tListItem[index] = {}
    				self.m_tListItem[index].activityId = activityId[i]
    				self.m_tListItem[index].title = title[i]
    				self.m_tListItem[index].startTime = startTime[i]
    				self.m_tListItem[index].endTime = endTime[i]
    				self.m_tListItem[index].types = types[i]
    				self.m_tListItem[index].param2 = param2[i]
    				if param1[i] == 0 then 
    					self.m_tListItem[index].disappearTime = endTime[i]
    				else
    					self.m_tListItem[index].disappearTime = param1[i]
    				end
    				index = index + 1
    			end 
    		end 
        end
	end

	WZLog("代言人活动数据", Serialize(self.m_tListItem))
	self:_updateTab()
end

function WndApartmentAct:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	if self.m_root == nil then return end
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief 	设置面板内容
function WndApartmentAct:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndApartmentAct::_updateActivityContext =",activityId, content, Serialize(tips), startTime, endTime, serverTime, Serialize(rewardId), Serialize(status), Serialize(rewardItems), Serialize(rewardItemsParamCount), Serialize(rewardCounts),count,maxCount,Serialize(target))
	self.activityId = activityId
	self.content = content
	self.tips = tips
	self.startTime = startTime
	self.endTime = endTime
	self.serverTime = serverTime
	self.rewardId = rewardId
	self.status = status
	self.rewardItems = rewardItems
	self.rewardItemsParamCount = rewardItemsParamCount
	self.rewardCounts = rewardCounts
	self.count = count
	self.maxCount = maxCount
	self.target = target

	WZLog("WndApartmentAct::_updateActivityContext ==", type(self.m_nTag), self.m_nTag)
	WndApartmentAct["_update"..self.m_nTag](WndApartmentAct)
	WZLog("WndApartmentAct::_updateActivityContext ==?", type(self.m_nTag), self.m_nTag)
end

--@brief  获得充值礼包信息成功
function WndApartmentAct:GetVipRechargeInfoOK(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv, maxTimes)
    if self.m_root == nil then return end 
    WZLog("获得充值礼包信息成功",#ids,self.m_nCurShowActivityId)
    self.m_tCurShowActivityId[self.m_nCurShowActivityId] = true
    
    if self.m_nCurShowActivityId == 3030 then
    	self.m_tPacksFashion7 = {}
    	for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])
		    table.insert(tempTT,maxTimes[i])

		    table.insert(self.m_tPacksFashion7,tempTT)
		end

		WZLog("购买价格",showPrice[1],Serialize(itemId), Serialize(number), Serialize(giftNumber))
		GetElement(self.m_root,"txtPrice",WZUILabelTTF):setText(showPrice[1])
		GetElement(self.m_root,"txtPrice2",WZUILabelTTF):setText("")
		local conBtnBuy = GetElement(self.m_root,"conBtnBuy_WndSumVacAct",WZUIContainer)
		local btnBuy = GetElement(self.m_root,"btnBatch_WndApartmentAct",WZUIButton)
		btnBuy:setVisible(false)
		local imgSoldOut = GetElement(self.m_root,"imgSoldOut",WZUIImage)
		conBtnBuy:setVisible(true)
		imgSoldOut:setVisible(false)
		if leftTimes[1] <= 0 then
			imgSoldOut:setVisible(true)
			conBtnBuy:setVisible(false)
		else
			GetElement(self.m_root,"txtPrice",WZUILabelTTF):setText(showPrice[1])
		end

		for i=1,4 do
			GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer):setVisible(false)
		end
	
		---------  分割线   ---------
		local tDataList = {}
		local sexKey = {"man_item_id", "woman_item_id"}
		local sex = tonumber(CacheCenter:getPlayerInfo().sex)

		for i,v in pairs(GDatatab_gifts) do
            for j,k in ipairs(itemId) do
                if v.item_id == k then
					local tempData = {}
					tempData.itemId = v[sexKey[sex+1]]
					tempData.count = v.count
					table.insert(tDataList, tempData)
                end
            end
		end

		local _sort = function(a, b)
			return a.itemId > b.itemId
		end
		table.sort(tDataList, _sort)

		self.giftId7 = tDataList[1].itemId


		local startT = nil
		local endT = nil
		for i,v in ipairs(self.m_tListItem) do
			if v.types == 3030 then
				startT = v.startTime
				endT = v.endTime
				break
			end
		end
		for i,v in ipairs(tDataList) do
			if v ~= nil then
				local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer)
		        if conItem then
					conItem:setVisible(true)
			        local txtItemName = GetElement(conItem,"txtItemName_WndSumVacAct",WZUILabelTTF)
			        local item = GetElement(conItem,"conItem_WndSumVacAct",WZUIContainer)
			        local eItem, tItem = CellGoodItem:createElement()
			        eItem:setScale(0.86)
			        tItem:setItemClickFun(self, self.onClickListItem)
			        local tData = {
			            id = v.itemId,
			            isUse = false,
			            data = "",
			            playerItemId = -1,
			            lastNum = v.count,
			            lastTime = v.count,
			            basicInfo = GetItemLocalData(v.itemId)
			        }
			        tItem:setCellGoodItem(tData,4)
			        item:addChild(eItem)
			        local itemInfo = GDatatab_item["id_" .. v.itemId]
			        txtItemName:setText(itemInfo.name)
			    end
			end
		end
		local role7_player = GetElement(self.m_root,"role7_player",WZUIContainer)
		self:isUseShowGood(role7_player, tDataList)
		return
	end


    if self.m_nCurShowActivityId == 3031 or self.m_nCurShowActivityId == 3054 or self.m_nCurShowActivityId == 3044 then
    	self.m_tPacksFashion = {}
    	for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])
		    table.insert(tempTT,maxTimes[i])

		    table.insert(self.m_tPacksFashion,tempTT)
		end
		table.sort( self.m_tPacksFashion, 
			function (a,b)
		    	if a[12] < b[12] then
		    	    return true
		    	end
		    	return false
			end 
		)
    	WZLog("WndApartmentAct:GetVipRechargeInfoOK 3", Serialize(self.m_tPacksFashion))
		self:_update3()
	end

    if self.m_nCurShowActivityId == 3043 then
    	self.m_tPacksFashion8 = {}
    	for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])
		    table.insert(tempTT,maxTimes[i])

		    table.insert(self.m_tPacksFashion8,tempTT)
		end

		WZLog("购买价格8",showPrice[1],Serialize(itemId))
		GetElement(self.m_root,"txtPrice_WndApartmentAct",WZUILabelTTF):setText(showPrice[1])
		local conBtnBuy = GetElement(self.m_root,"conBtnBuy_WndApartmentAct",WZUIContainer)
		local imgSoldOut = GetElement(self.m_root,"imgSoldOut_WndApartmentAct",WZUIImage)
		conBtnBuy:setVisible(true)
		imgSoldOut:setVisible(false)
		if leftTimes[1] <= 0 then
			imgSoldOut:setVisible(true)
			conBtnBuy:setVisible(false)
		else
			GetElement(self.m_root,"txtPrice_WndApartmentAct",WZUILabelTTF):setText(showPrice[1])
		end

		for i=1,4 do
			GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer):setVisible(false)
		end

		-------  分割线   -------
		local tDataList = {}
		local sexKey = {"man_item_id", "woman_item_id"}
		local sex = tonumber(CacheCenter:getPlayerInfo().sex)

		for i,v in pairs(GDatatab_gifts) do
            for j,k in ipairs(itemId) do
                if v.item_id == k then
					local tempData = {}
					tempData.itemId = v[sexKey[sex+1]]
					tempData.count = v.count
					table.insert(tDataList, tempData)
                end
            end
		end
		local _sort = function(a, b)
			return a.itemId > b.itemId
		end
		table.sort(tDataList, _sort)

		self.giftId8 = tDataList[1].itemId
		
		local startT = nil
		local endT = nil
		for i,v in ipairs(self.m_tListItem) do
			if v.types == 3043 then
				startT = v.startTime
				endT = v.endTime
				break
			end
		end

		for i,v in ipairs(tDataList) do
			if v ~= nil then
				local conItem = GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer)
		        if conItem then
					conItem:setVisible(true)
			        local txtItemName = GetElement(conItem,"txtItemName_WndApartmentAct",WZUILabelTTF)
			        local item = GetElement(conItem,"conItem_WndApartmentAct",WZUIContainer)
			        local eItem, tItem = CellGoodItem:createElement()
			        eItem:setScale(0.86)
			        tItem:setItemClickFun(self, self.onClickListItem)
			        local tData = {
			            id = v.itemId,
			            isUse = false,
			            data = "",
			            playerItemId = -1,
			            lastNum = v.count,
			            lastTime = v.count,
			            basicInfo = GetItemLocalData(v.itemId)
			        }
			        tItem:setCellGoodItem(tData,4)
			        item:addChild(eItem)
			        local itemInfo = GDatatab_item["id_" .. v.itemId]
			        txtItemName:setText(itemInfo.name)
			    end
			end
		end
		local role8_player = GetElement(self.m_root,"role8_player",WZUIContainer)
		self:isUseShowGood(role8_player, tDataList)
		return
	end

    if self.m_nCurShowActivityId == 3044 then
    	self.m_tPacksFashion9 = {}
    	for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])
		    table.insert(tempTT,maxTimes[i])

		    table.insert(self.m_tPacksFashion9,tempTT)
		end
		table.sort( self.m_tPacksFashion9, 
			function (a,b)
		    	if a[12] < b[12] then
		    	    return true
		    	end
		    	return false
			end 
		)
    	WZLog("WndApartmentAct:GetVipRechargeInfoOK 9", Serialize(self.m_tPacksFashion9))
		self:_update9()
	end
end
--判断礼包里面是否有展示的物品
--[[
时装：一般是用礼包去卖礼包类型3-0    物品类型  5-2    区分男女展示头脸身
坐骑：物品类型 2-11
足迹：物品类型23         
武器：物品类型 4-0/4-1
皮肤：物品类型  20-1
翅膀：物品类型  5-3
]]
function WndApartmentAct:isUseShowGood(container, data)
	if not data then return end
	local item_id
	--如果找到存在以上的信息就返回显示
	local is_gift = false
	for i,v in pairs(data) do
		if v and v.itemId then
			local itemInfo = GDatatab_item["id_" .. v.itemId]
			if itemInfo.main_type == 3 and itemInfo.sub_type == 0 then
				item_id = v.itemId
				is_gift = true
				break
			elseif itemInfo.main_type == 2 and itemInfo.sub_type == 11 then
				item_id = v.itemId
				break
			elseif itemInfo.main_type == 23 then
				item_id = v.itemId
				break
			elseif itemInfo.main_type == 4 then
				if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 then
					item_id = v.itemId
					break
				end
			elseif itemInfo.main_type == 20 and itemInfo.sub_type == 1 then
				item_id = v.itemId
				break
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then
				item_id = v.itemId
				break
			end
		end
	end
	if item_id then
		local nSex = false
		if CacheCenter:getPlayerInfo().sex == 0 then
			nSex = true --男
		end
		local tData = {}
		if is_gift == true then --如果是礼包时候
			for i,v in pairs(GDatatab_gifts) do
				if v.item_id == item_id then
					if nSex == true then
						table.insert(tData, v.man_item_id)
					else
						table.insert(tData, v.woman_item_id)
					end
				end
			end
		else
			table.insert(tData,item_id)
		end
	--	WZLog("WndApartmentAct:isUseShowGood(:::::: ",Serialize(tData))
		self:createRoleShow(container, tData, nSex)
	end
end
--奖励物品展示
function WndApartmentAct:createRoleShow(coninter, data, sex)
	if next(data) == nil then return end
	if not coninter then return end
	sex = sex or false
	local head_index, face_index, body_index, foot_index, mount_index, weapon_index, wing_index, skin_index = nil, nil, nil, nil, nil, nil, nil, nil
	for i, v in pairs(data) do
		local itemInfo = GDatatab_item["id_" .. v]
		if itemInfo.main_type == 5 and itemInfo.sub_type == 0 then --头部
			head_index = v
		elseif itemInfo.main_type == 5 and itemInfo.sub_type == 1 then --脸部
			face_index = v
		elseif itemInfo.main_type == 5 and itemInfo.sub_type == 2 then --衣服
			body_index = v
		elseif itemInfo.main_type == 2 and itemInfo.sub_type == 11 then--坐骑
			mount_index = v
		elseif itemInfo.main_type == 23 then --足迹
			foot_index = v
		elseif itemInfo.main_type == 4 then --武器
			if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 then
				weapon_index = v
			end
		elseif itemInfo.main_type == 20 and itemInfo.sub_type == 1 then --皮肤
			skin_index = v
		elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then --翅膀
			wing_index = v
		end
	end

	if head_index or face_index or body_index or wing_index then
		if not self.m_sRoleConPlayer then
			self.m_sRoleConPlayer = YDPlayerAnimation:createAnimation(sex)
			self.m_sRoleConPlayer:getAnimNode():setTouchEnable(false)
			coninter:addChild(self.m_sRoleConPlayer:getAnimNode())
			self.m_sRoleConPlayer:setFlipX(true)
			if head_index then
				local head = GDatatab_item["id_"..head_index].animation_index_code
				self.m_sRoleConPlayer:setHead(head)
			end
			if face_index then
				local face = GDatatab_item["id_"..face_index].animation_index_code
				self.m_sRoleConPlayer:setFace(face)
			end
			if body_index then
				local body = GDatatab_item["id_"..body_index].animation_index_code
				self.m_sRoleConPlayer:setBody(body)
			end
			if wing_index then
				local wing = GDatatab_item["id_"..wing_index].animation_index_code
				self.m_sRoleConPlayer:setWing(wing)
			end
			self.m_sRoleConPlayer:play("wait0",true)
		end
	end
	--足迹
	if foot_index then
		if not self.m_sFootSpine then
			local foot_info = GDatatab_item["id_"..foot_index]
			local footId = nil
			if foot_info then
				footId = foot_info.property[1][1]
			end
		    self.m_sFootSpine = FootEffectManager:addEffect1(coninter,footId,{x=45,y=50},true)
		end
	end
	--坐骑
	if mount_index then
		if not self.m_sAniMount then
			local head,body = CacheCenter:getHeadAndBodyColor()
			local tEquip = CacheCenter:getEquipmentList()
		    self.m_sAniMount = CreatePlayerFigure(sex, tEquip, "wait",nil,nil,nil,nil,nil,nil,nil,head,body,false)
		    local mount_id = self:getMountId(mount_index)
		    local index_code = GDatatab_item["id_"..mount_id].animation_index_code
		    self.m_sAniMount:setMount(index_code)
		    local node = self.m_sAniMount:getAnimNode()
		    node:setScale(0.75)
		    node:setRelativePosition(GlobalMethod:ccp(0.3,0))
		    node:setTouchEnable(false)
		    coninter:addChild(node)		
		end
	end
	--武器
	if weapon_index then
		local cell,tcell = CellGoodItem:createElement()
		if not self.m_sWeaponCellItem then
			self.m_sWeaponCellItem = cell
		    if cell then
		        cell = WZUIContainer:luaTo(cell)
				local tabItem = GDatatab_item["id_"..weapon_index]
				local cellData = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=1,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
		        tcell:setCellGoodItem(cellData,5)
		        coninter:addChild(cell)
		        cell:setRelativePosition(GlobalMethod:ccp(0.5,0.8))
		    end
		end
	end
	--皮肤
	if skin_index then
		local tabItem = GDatatab_item["id_"..skin_index]
		if tabItem and not self.m_sConSkinPlayer then
			local skin = tabItem.property[1][1]
			self.m_sConSkinPlayer = CreatePlayerFigure(sex, {}, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, skin)
			self.m_sConSkinPlayer:setScale(0.8)
			self.m_sConSkinPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			self.m_sConSkinPlayer:getAnimNode():setTouchEnable(false)
			coninter:addChild(self.m_sConSkinPlayer:getAnimNode())
		end
	end
end
--获取坐骑的数据(需要传进去一个参数值，然后在坐骑表获取到真正的坐骑数据)
function WndApartmentAct:getMountId(id)
	id = tonumber(id)
	local index = 1
	for i,v in pairs(GDatatab_mounts) do
		if type(v.way) == "table" then
			for m=1, #v.way do
				if id == v.way[m][2] then
					return v.item_id
				end
			end
		end
	end
	return index
end
function WndApartmentAct:onClickListItem(tItem, nTag, tData)
	-- body
	WZLog("WndApartmentAct:onClickListItem")
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end

--@brief 获取奖励成功
function WndApartmentAct:GetRewardOk(rewardItems,rewardCount,ntype)
    if self.m_root == nil then return end

	WZLog("WndApartmentAct:GetRewardOk types=")
    if rewardItems ~= nil and #rewardItems > 0 and  rewardItems[1] > 0 then
        WndRewardShow:showById(rewardItems,rewardCount)
    end
	if (self.m_nTag ==1 or self.m_nTag ==2) and self.m_nCurShowActivityType ~= nil and self.m_nCurShowActivityId ~= nil then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nCurShowActivityType ,self.m_nCurShowActivityId)
	end
end

--@brief 	获取活动消失时间
function WndApartmentAct:getActivityDisappearTime(nActivityId)
	-- body
	for i = 1, #self.m_tListItem do
		if self.m_tListItem[i].activityId == nActivityId then 
			return self.m_tListItem[i].disappearTime
		end
	end
end

--@brief 	获取活动数据根据活动id
function WndApartmentAct:getActivityDataByActivityType(nActivityType)
	-- body
	for i = 1, #self.m_tListItem do
		if self.m_tListItem[i].types == nActivityType then 
			return self.m_tListItem[i]
		end
	end
end

--@brief 	获取圣诞树活动数据成功
function WndApartmentAct:getChristmasTreeDataOK(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
	-- body
	WndChristmasTree:setData(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
end

--@brief 	获取活动是否还存在
function WndApartmentAct:_activityIsExit(nActivityType)
	-- body
	if self.m_tListItem == nil or #self.m_tListItem == 0 then return false end
	local serverTime = SystemTime:getServerTime()

	for i,v in ipairs(self.m_tListItem) do
        if v.types == nActivityType then
            local endTime = v.endTime
            if endTime and serverTime >= endTime then
                return false
            end
        end
    end
    
    return true
end

--处理接收嫂烟花排行榜积分
function WndApartmentAct:handleRankInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak,otherServer)
    WZLog("WndApartmentAct:handleRankInfo")
    if self.m_root == nil then return end
    if self.m_nTag == 16 and self.m_nodeElement then
        local cellFireworksAnn = CellFireworksAnn:createElement()
        if cellFireworksAnn == nil then return end
        CellFireworksAnn:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour, score, myRnak, otherServer)
        cellFireworksAnn:setZOrder(10)
        local conForRank = GetElement(self.m_nodeElement, "conForRank_CellFireworks", WZUIContainer)
        local childNode = conForRank:getChildByTag(122)
        if childNode then
            childNode:setVisible(false)
        end
        conForRank:addChild(cellFireworksAnn)
    end
end
-------------------------------------私有方法模块End----------------------------------------


--************** item *******************
CellApartmentItem = {}
function CellApartmentItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellApartmentItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellApartmentItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(174,70))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellApartmentItem:setCellApartmentMessage(sort_index, index, data, nTempTag)
	self.sort_index = sort_index
	self.index = index
	self.m_sApartmentData = data
	self.m_nTempTag = nTempTag
end
function CellApartmentItem:setCellApartmentFunc(call_func)
	self.callApartmentFunc = call_func
end
--@brief 	开始加载
function CellApartmentItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellApartmentItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setApartmentItemData()
end

function CellApartmentItem:setApartmentItemData()
	if not self.m_sApartmentData then return end	
	WZLog("CellApartmentItem:setApartmentItemData self.m_sApartmentData=", Serialize(self.m_sApartmentData))		
	--全民烟花标题使用图片显示
	local isShowImgTitle = false
	-- if self.m_sApartmentData.title_id == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then
	-- 	WZLog("CellApartmentItem:setApartmentItemData self.index=", self.index, "全民烟花")		
    --     local file = "ui/anniversary/7znq_text_bt_qmyh.png"
    --     local bExist = WZFileUtil:isFileExist(file)
    --     if bExist then
    --     	isShowImgTitle = true
	-- 		WZLog("CellApartmentItem:setApartmentItemData =", file, "is exist")		
    --     else
	-- 		WZLog("CellApartmentItem:setApartmentItemData =", file, "is not exist")
    --     end
	-- end
	local txtTitleName = GetElement(self.m_root,"txtTitleName",WZUILabelTTF)
	local imgTitleName = GetElement(self.m_root,"imgTitleName",WZUI9Image)
	if txtTitleName then
		txtTitleName:setText(self.m_sApartmentData.title_name)
		if imgTitleName and isShowImgTitle then
			imgTitleName:setVisible(true)
			txtTitleName:setVisible(false)
		end
	end
	if self.m_nTempTag == self.sort_index then
		self:setSelectTitleColor()
	else
		self:setNormalTitleColor()
	end
end
function CellApartmentItem:setNormalTitleColor()
	if not self.m_root then return end
	GetElement(self.m_root,"titleSelect",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
end
function CellApartmentItem:setSelectTitleColor()
	if not self.m_root then return end
	local titleSelect = GetElement(self.m_root,"titleSelect",WZUI9Image)
	if not titleSelect then return end
	titleSelect:setVisible(true)
	GetElement(self.m_root,"txtTitleName",WZUILabelTTF):setColor(GlobalMethod:ccc3(132,66,29))
end
function CellApartmentItem:onBtnClickApartment()
	if self.callApartmentFunc then
		self.callApartmentFunc(self.sort_index,self.index)
	end
end

--@return	新建的表实例对象
function CellApartmentItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--兑换CellItem
CellAExchangeItem = {}
function CellAExchangeItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.m_tData = nil 
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellAExchangeItem:_unInit()
	self.m_root = nil
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellAExchangeItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(682,102))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellAExchangeItem:onAct2(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WZLog("CellAExchangeItem:onAct2")

	--兑换道具不足
    if self.exchangeTip ~= nil then
        MsgBoxManager:showTipBox(self.exchangeTip)
        return
    end

	--兑换次数不足
    if self.m_tData.rewardCount <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
    end

	WZLog("兑换道具", rewardId)
    local freecon_Act2 = GetElement(WndApartmentAct.m_root, "freecon_Act2", WZUIFreeListContainer)
    WndApartmentAct.m_nConListPositionY = freecon_Act2:getMoveElement():getPositionY()

	local id = self.m_tData.tRewardData[1].id
	local maxNum = math.min(self.exchangeNum, self.m_tData.rewardCount)
	local tItem = {
     	    id = id,
     	    lastNum = self.m_tData.tRewardData[1].num,
     	    lastTime = 1,
			maxNum = maxNum,
			unitNum = self.m_tData.tRewardData[1].num, 
     	    isUse = false,
     	    data = "",
     	    playerItemId = -1,
     	    basicInfo = GetItemLocalData(id),
     	    rewardId = self.m_tData.rewardId
     	}
	local wndOpenChest = WndOpenChest:createElement()
	WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
	WndOpenChest:setExchangeData(tItem)
end

--@brief 	设置数据
function CellAExchangeItem:setExchangeData(tData)
	self.m_tData = tData
end

--@brief 	开始加载
function CellAExchangeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("cellAct2")
	celElement:setVisible(true)
	element:addChild(celElement)

	self.m_bIsLoaded = true 
	self:_update(celElement)
end

--@brief 	刷新
function CellAExchangeItem:_update(cell)
	local tData = self.m_tData 

	local freeText = GetElement(cell,"canExchange",WZUIFreeTextBox)
	local content = tData.content
	WZLog("剩余兑换次数",tData.rewardCount,content)
	freeText:setShowText(string.format(LocalStrings.RESIDUAL_EXCHANGE,tData.rewardCount,content))
	WZLog("兑换需要的道具",i,Serialize(tData))
	for i=1,4 do
		GetElement(cell,"conCellAct2"..i,WZUIContainer):setVisible(false)
	end
	local needItemNum = 0
	for j=1,math.min(tData.count, 4) do
	   local celElement,tLuaObj = CellGoodItem:createElement()
	   local id = tData.tConsumeData[j].id
	   local tItem
       if celElement ~= nil then 
			tItem = {
    		    id = id,
    		    lastNum = tData.tConsumeData[j].num,
    		    lastTime = 1,
    		    isUse = false,
    		    data = "",
    		    playerItemId = -1,
    		    basicInfo = GetItemLocalData(id)
    		}
	    	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(tItem, 4)
            tLuaObj:setItemClickFun(WndApartmentAct, WndApartmentAct.onItem2)
            tLuaObj:_setItemVisible(false)
            celElement:setTag(j)
			celElement:setScale(0.9)
			GetElement(cell,"conCellAct2"..j,WZUIContainer):addChild(celElement)
			GetElement(cell,"conCellAct2"..j,WZUIContainer):setVisible(true)
			needItemNum = needItemNum + 1
       end

        --数量
        local nTempNum = tData.tConsumeData[j].num 
        if nTempNum == -1 then
            nTempNum = 1 
        end
        
        local txtNumber = GetElement(cell, string.format("txtNumber%d_CellExchangeItem", j), WZUILabelTTF)
        local nLastNum = CacheCenter:getPlayerItemCountById(tData.tConsumeData[j].id)
        if nLastNum == -1 then
            nLastNum = 1
        end
        txtNumber:setText(nLastNum .. "/" .. nTempNum)
		if self.exchangeTip == nil and (tonumber(nLastNum) < tonumber(nTempNum)) then
			self.exchangeTip = string.format(LocalStrings.CARD_COUNT1, [["]]..tItem.basicInfo.name..[["]])
		end
		self.exchangeNum = math.floor(tonumber(nLastNum) / tonumber(nTempNum))
	end

	--兑换奖励
   local celElement,tLuaObj = CellGoodItem:createElement()
   local id = tData.tRewardData[1].id
   if celElement ~= nil then 
		tItem = {
		    id = id,
		    lastNum = tData.tRewardData[1].num,
		    lastTime = 1,
		    isUse = false,
		    data = "",
		    playerItemId = -1,
		    basicInfo = GetItemLocalData(id)
		}
    	celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setCellGoodItem(tItem, 4)
        tLuaObj:setItemClickFun(WndApartmentAct, WndApartmentAct.onItem2)
        tLuaObj:_setItemVisible(false)
        celElement:setTag(1)
		celElement:setScale(0.9)
		GetElement(cell,"conCellAct2"..5,WZUIContainer):addChild(celElement)
		GetElement(cell,"txtNumber5_CellExchangeItem",WZUILabelTTF):setText(tData.tRewardData[1].num)
		if tItem.basicInfo.main_type == 5 then
			if tData.tRewardData[1].num == -1 then
				GetElement(cell,"txtNumber5_CellExchangeItem",WZUILabelTTF):setText(LocalStrings.YJ)
			end	
		end
   end

	if needItemNum < 4 then
		GetElement(cell,"imgD",WZUIImage):setRelativePosition(ccp(0.68-0.145*(4-needItemNum),0.51))
		GetElement(cell,"conCellAct2"..5,WZUIContainer):setRelativePosition(ccp(0.825-0.145*(4-needItemNum),0.5))
	end
end

--@return	新建的表实例对象
function CellAExchangeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end