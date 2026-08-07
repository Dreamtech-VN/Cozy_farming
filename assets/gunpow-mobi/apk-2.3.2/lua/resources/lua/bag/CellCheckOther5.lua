--CellCheckOther5.lua
--@brief	CellCheckOther5的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏2


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther5:onEnter(element)
	self.m_root = element
	self.m_nType = nil					--1:坐骑栏,2:星魂栏,3:祈福
	self.m_tDataList = nil
	self.m_nBtnTag = nil
	self.sureBtnState = "change"
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther5:onExit(element)
	self:_unInit()
	self.m_nType = nil
	self.m_tDataList = nil
	self.m_nBtnTag = nil
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击图标
function CellCheckOther5:onClick(element)
	WZLog("CellCheckOther5:onClick",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = element:getTag()
	if self.m_nType == 1 or self.m_nType == 5 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,14,self.m_tDataList[element:getTag()], nil, true)
	elseif self.m_nType == 2 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,19,self.m_tDataList[element:getTag()], nil, true)
	elseif self.m_nType == 3 then
		if self.m_tDataList[element:getTag()] == nil then return end
		local tPray = GDatatab_pray["id_"..self.m_tDataList[element:getTag()].prayId]
		local tItem = GDatatab_item["id_"..tPray.item_id]
		local tData = {level=tPray.level,name=tPray.name,userType=5,property=tPray.property,basicInfo=tItem,highLightObj=self.m_tDataList[element:getTag()].highLightObj}
		if element:getTag() == 5 then
			WndTips:show(GetElement(self.m_root,"btn4",WZUIButton),WndCheckOther.m_root,25,tData,ccp(0,-500), true)
		elseif element:getTag() == 6 then
			WndTips:show(GetElement(self.m_root,"btn4",WZUIButton),WndCheckOther.m_root,25,tData,ccp(0,-500), true)
		else
			WndTips:show(element,WndCheckOther.m_root,25,tData,ccp(0,-500), true)
		end
	elseif self.m_nType == 4 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,28,self.m_tDataList[element:getTag()],ccp(-160,35), true)
	end
end

--@brief	设置高亮
function CellCheckOther5:setHighLight(bool)
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	更新标题
function CellCheckOther5:update(i)
	if self.m_root == nil then return end
	local title = {LocalStrings.EQUIPMENT,LocalStrings.DRESS,LocalStrings.CHECKOTHER1,LocalStrings.CHECKOTHER4,LocalStrings.CHECKOTHER4,LocalStrings.CHECKOTHER3,LocalStrings.CHECKOTHER11}
	GetElement(self.m_root,"txtTitle_CellCheckOther5",WZUILabelTTF):setText(title[i])

	--GetElement(self.m_root,"conSave",WZUIContainer):setVisible(false)
	--if i == 4 then
	--	GetElement(self.m_root,"conSave",WZUIContainer):setVisible(true)
	--	if WndCheckOther.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then
	--		GetElement(self.m_root,"btnSave_CellCheckOther5",WZUIButton):setVisible(true)
	--	else
	--		GetElement(self.m_root,"btnSave_CellCheckOther5",WZUIButton):setVisible(false)
	--	end
	--end
end

--@brief	设置标题
function CellCheckOther5:setTitle(title)
	GetElement(self.m_root,"txtTitle_CellCheckOther5",WZUILabelTTF):setText(title)
end

--@brief	设置签名
function CellCheckOther5:setSignature(signature)
	GetElement(self.m_root,"editSign_CellCheckOther5",WZUIEditBox):setText(signature)
	if signature == LocalStrings.NONE or signature == "" then
		GetElement(self.m_root,"editSign_CellCheckOther5",WZUIEditBox):setText(LocalStrings.BAGTIP1)
	end 
	GetElement(self.m_root,"conIcon_CellCheckOther5",WZUIContainer):setVisible(false)
end

--@brief	显示坐骑
function CellCheckOther5:showMounts(tData)
	--WZLog("CellCheckOther5:showMounts",Serialize(tData))
	self.m_nType = 1
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
	local num = 0
	--全部设置不可点击
	for i=1,12 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"spine"..i,WZUISpine):setVisible(false)
	end
	self.m_tDataList = {}
	for i=1,#tData do
		if num < 12 then
			local tempTable = {}
			local idTable = {}
			local tMount = json.decode(tData[i])
			local mountsId = tMount.mountsId
			local attrNum = 1
			local attrIndex = 1
			if mountsId == nil or GDatatab_mounts["id_"..mountsId] == nil then break end
			local tData = GDatatab_item["id_"..GDatatab_mounts["id_"..mountsId].item_id]
			tempTable.icon = tData.icon
			tempTable.title1 = tData.name
			tempTable.name = tData.name
			tempTable.title2 = ""
			tempTable.quality = tData.quality
			tempTable.fighting = tMount.fighting
			tempTable.upgradeLevel = tMount.upgradeLevel
			tempTable.advancedLevel = tMount.advancedLevel
			tempTable.highLightObj = self
			for k,v in pairs(tMount) do
				if tonumber(k) ~= nil and v ~= 0 then
					table.insert(idTable,k)
				end
			end
			table.sort(idTable)
			for _,v in pairs(idTable) do
				if attrNum <= 5 then
					tempTable["attr"..attrIndex] = ATTR_TITLE[tonumber(v)]
					tempTable["attrVal"..attrIndex] = tMount[tostring(v)]
					attrIndex = attrIndex + 1
					--WZLog("属性的key是",ATTR_TITLE[tonumber(v)],v,tMount[tostring(v)])
					attrNum = attrNum + 1
				end
			end
			table.insert(self.m_tDataList,tempTable)
		end
		num = num + 1
	end
	table.sort(self.m_tDataList,sortQuality)
	for i=1,#self.m_tDataList do
		GetElement(self.m_root,"black"..i,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		GetElement(self.m_root,"quality"..i,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
		GetElement(self.m_root,"icon"..i,WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setTouchEnable(true)
		if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
	
		if self.m_tDataList[i].quality == 4 then
			local spine = WZUISpine:create()
   			spine:setTouchEnable(false)
   			spine:setFileJson("ui/ui_icon_effect.json")
   			spine:setFileAtlas("ui/ui_icon_effect.atlas")
			spine:play("zuoqi_cheng", true)	
   			spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			--spine:setScale(0.8)
			btn:addChild(spine, 421, 421)
		end
	end
	--设置底图
	for i=1,12 do
		local emptyIcon = GetElement(self.m_root,"iconBg"..i,WZUIImage)
		emptyIcon:setVisible(false)
	end
end

--@brief	显示足迹
function CellCheckOther5:showFootMark(tData)
	WZLog("CellCheckOther5:showFootMark",Serialize(tData))
	self.m_nType = 5
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
	local num = 0
	--全部设置不可点击
	for i=1,12 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"spine"..i,WZUISpine):setVisible(false)
	end
	self.m_tDataList = {}
	for i=1,#tData do
		if num < 12 then
			local tempTable = {}
			local idTable = {}
			local tMount = json.decode(tData[i])
			local footmarkId = tMount.footmarkId
			local attrNum = 1
			local attrIndex = 1
			if footmarkId == nil or GDatatab_footmark["id_"..footmarkId] == nil then break end
			local tData = GDatatab_item["id_"..GDatatab_footmark["id_"..footmarkId].item_id]
			tempTable.icon = tData.icon
			tempTable.title1 = tData.name
			tempTable.name = tData.name
			tempTable.title2 = ""
			tempTable.quality = tData.quality
			tempTable.fighting = tMount.fighting
			tempTable.upgradeLevel = tMount.upgradeLevel
			tempTable.advancedLevel = tMount.advancedLevel
			tempTable.highLightObj = self
			for k,v in pairs(tMount) do
				if tonumber(k) ~= nil and v ~= 0 then
					table.insert(idTable,k)
				end
			end
			table.sort(idTable)
			for _,v in pairs(idTable) do
				if attrNum <= 5 then
					tempTable["attr"..attrIndex] = ATTR_TITLE[tonumber(v)]
					tempTable["attrVal"..attrIndex] = tMount[tostring(v)]
					attrIndex = attrIndex + 1
					--WZLog("属性的key是",ATTR_TITLE[tonumber(v)],v,tMount[tostring(v)])
					attrNum = attrNum + 1
				end
			end
			table.insert(self.m_tDataList,tempTable)
		end
		num = num + 1
	end
	table.sort(self.m_tDataList,sortQuality)
	for i=1,#self.m_tDataList do
		GetElement(self.m_root,"black"..i,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		GetElement(self.m_root,"quality"..i,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
		GetElement(self.m_root,"icon"..i,WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i,WZUIImage):setScale(1)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setScale(1)
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setTouchEnable(true)
		if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
	
		if self.m_tDataList[i].quality == 4 then
			local spine = WZUISpine:create()
   			spine:setTouchEnable(false)
   			spine:setFileJson("ui/ui_icon_effect.json")
   			spine:setFileAtlas("ui/ui_icon_effect.atlas")
			spine:play("zuoqi_cheng", true)	
   			spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			--spine:setScale(0.8)
			btn:addChild(spine, 421, 421)
		end
	end
	--设置底图
	for i=1,12 do
		local emptyIcon = GetElement(self.m_root,"iconBg"..i,WZUIImage)
		emptyIcon:setVisible(false)
	end
end

--@brief  坐骑按品质排序
function sortQuality(a,b)
	return a.quality > b.quality
end

--@brief	显示星魂
--@param	tData:要显示的星魂id数组
function CellCheckOther5:showStarSoul(tData)
	self.m_nType = 2
	local num = 0
	self.m_tDataList = {}
	for i=1,#tData do
		if tData[i] == nil or GDatatab_starsoul["id_"..tData[i]] == nil then break end
		local tStarsoul = GDatatab_starsoul["id_"..tData[i]]
		local tStarsoulNext = GDatatab_starsoul["id_"..(tData[i]+1)] 
		if (tStarsoulNext == nil or tStarsoul.star ~= tStarsoulNext.star) and num < 5 then
			num = num + 1
			local spine = GetElement(self.m_root,"spine"..num,WZUISpine)
			spine:setVisible(true)
			spine:play(tStarsoul.star_icon,true)	
			local tempTable = {}
			GetElement(self.m_root,"quality"..num,WZUI9Image):setVisible(false)
			GetElement(self.m_root,"icon"..num,WZUIImage):setVisible(false)
			GetElement(self.m_root,"icon"..num.."Sel",WZUIImage):setVisible(false)
			tempTable.starID = tData[i]
			tempTable.highLightObj = self
			self.m_tDataList[num] = tempTable
		end
	end
end

--@brief	显示祈福
--@param	tData:要显示的祈福id数组
function CellCheckOther5:showPrays(tData)
	self.m_nType = 3
	local num = 0
	self.m_tDataList = {}
	for i=1,6 do
		GetElement(self.m_root,"spine"..i,WZUISpine):setVisible(false)
		GetElement(self.m_root,"iconBg"..i,WZUIImage):setVisible(false)
		GetElement(self.m_root,"icon"..i,WZUIImage):setVisible(false)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setVisible(false)
		GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setVisible(false)
	end
	for i=1,#tData do
		if tData[i] == nil or GDatatab_pray["id_"..tData[i]] == nil then break end
		WZLog("祈福id",tData[i])
		local tPray = GDatatab_pray["id_"..tData[i]]
		if tPray ~= nil and num < 6 then
			num = num + 1
			local spine = GetElement(self.m_root,"spine"..num,WZUISpine)
    		spine:setFileJson("ui/ui_qifu.json")
    		spine:setFileAtlas("ui/ui_qifu.atlas")
			spine:play(GDatatab_item["id_"..tPray.item_id].icon, true)	
			spine:setVisible(true)

			local tempTable = {}
			GetElement(self.m_root,"quality"..num,WZUI9Image):setVisible(false)
			GetElement(self.m_root,"icon"..num,WZUIImage):setVisible(false)
			GetElement(self.m_root,"icon"..num.."Sel",WZUIImage):setVisible(false)
			tempTable.prayId = tData[i]
			tempTable.highLightObj = self
			self.m_tDataList[num] = tempTable
			local item_id = tPray.item_id
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setText("Lv"..tPray.level..GDatatab_item["id_"..item_id].name)
			local item_id = tPray.item_id
			local showName = GDatatab_item["id_"..item_id].name
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setText("Lv"..tPray.level..showName)
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setColor(QUALITYCOLOR[tPray.quality])
		end
	end
end

--@brief	显示修炼
function CellCheckOther5:showPractice(tData, tData1)
	self.m_nType = 4

	--全部设置不可点击
	for i=1,6 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"spine"..i,WZUISpine):setVisible(false)
	end
	self.m_tDataList = {}
	for i=1,#tData do
		local tempTable = {}
		local tPractice = GDatatab_upgrade_attr["id_"..tData[i]]
		if tPractice.level ~= 0 then
		tempTable.icon = "ui/practice/"..tPractice.icon
		tempTable.level = tPractice.level
		tempTable.name = ATTR_TITLE[tPractice.attr[1][1]]
		tempTable.exp = tData1[i]
		tempTable.totalExp = tPractice.lv_exp
		tempTable.attrId = tPractice.attr[1][1]
		tempTable.attrValue = tPractice.attr[1][2]
		tempTable.highLightObj = self
		tempTable.quality = 1 
		if tPractice.level <= 20 then 
			tempTable.quality = 1 
		elseif tPractice.level <= 40 then
			tempTable.quality = 2 
		elseif tPractice.level <= 60 then
			tempTable.quality = 3 
		end
		table.insert(self.m_tDataList,tempTable)
		end
	end
	table.sort(self.m_tDataList,_sortPractice)
	WZLog("修炼数据",Serialize(self.m_tDataList))
	for i=1,#self.m_tDataList do
		local data = self.m_tDataList[i]
		GetElement(self.m_root,"black"..i,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		--GetElement(self.m_root,"quality"..i,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
		GetElement(self.m_root,"icon"..i,WZUIImage):setFile(data.icon)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setFile(data.icon)
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(true)
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setText(LocalStrings.LV..data.level..ATTR_TITLE[data.attrId])
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setScale(0.9)
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setColor(QUALITYCOLOR[data.quality])
	end
	--设置底图
	for i=1,6 do
		local emptyIcon = GetElement(self.m_root,"iconBg"..i,WZUIImage)
		emptyIcon:setVisible(false)
	end
end

--@brief  修炼按属性排序
function _sortPractice(a,b)
	return a.attrId < b.attrId
end

--@brief	保存按钮是否可触摸
function CellCheckOther5:_sureBtnTouch(bTouch)
	GetElement(self.m_root,"btnSave_CellCheckOther5",WZUIButton):setTouchEnable(bTouch)
end

--@brief	设置保存按钮上的文字
function CellCheckOther5:setSaveBtnText(txt)
	for i=1,3 do
		local img = GetElement(self.m_root,"imgSave"..i.."_CellCheckOther5",WZUI9Image)
		if txt == LocalStrings.SAVE then
			img:setFile("ui/bag/common_icon_bcz.png")
		else
			img:setFile("ui/bag/common_icon_xf.png")
		end
	end
end

--@brief	保存按钮回调函数
function CellCheckOther5:onSaveClick()
	WZLog("CellCheckOther5保存按钮回调函数")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--按钮是保存状态时的功能
	if self.sureBtnState == "save" then
		--获取签名
		local signature = tostring(GetElement(self.m_root,"editSign_CellCheckOther5",WZUIEditBox):getText())
		self:_sureBtnTouch(true)
		self.sureBtnState = "change"
		self:setSaveBtnText(LocalStrings.CHANGE)
		local playerInfo = CacheCenter:getPlayerInfo()
		playerInfo.signature = signature

		ProtocolProcessorWndBag:send_PLAYER_UpdateContext(signature )
	else
	--按钮是修改状态时的功能
		local editBox = GetElement(self.m_root,"editSign_CellCheckOther5",WZUIEditBox)
		editBox:openInputKeyBoard()
		self.sureBtnState = "save"
		self:setSaveBtnText(LocalStrings.SAVE)
	end
end
-------------------------------------私有方法模块End----------------------------------------
