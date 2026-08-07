--CellCheckOther10.lua
--@brief	CellCheckOther10的UI模块
--@date		2018/05/11
--@author	Tianxiang_Xu
--@note		个人信息祈福、修炼展示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther10:onEnter(element)
	self.m_root = element
	self.m_nType = nil					--1:坐骑栏,2:星魂栏,3:祈福
	self.m_tDataList = nil
	self.m_nBtnTag = nil
	self.sureBtnState = "change"
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther10:onExit(element)
	self.m_nType = nil
	self.m_tDataList = nil
	self.m_nBtnTag = nil
	self:_unInit()
end
--@brief	点击图标
function CellCheckOther10:onClick(element)
	WZLog("CellCheckOther10:onClick",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = element:getTag()
	if self.m_nType == 1 or self.m_nType == 5 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,14,self.m_tDataList[element:getTag()])
	elseif self.m_nType == 2 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,19,self.m_tDataList[element:getTag()])
	elseif self.m_nType == 3 then
		if self.m_tDataList[element:getTag()] == nil then return end
		local tPray = GDatatab_pray["id_"..self.m_tDataList[element:getTag()].prayId]
		local tItem = GDatatab_item["id_"..tPray.item_id]
		local tData = {level=tPray.level,name=tPray.name,userType=5,property=tPray.property,basicInfo=tItem,highLightObj=self.m_tDataList[element:getTag()].highLightObj}
		if element:getTag() == 5 then
			WndTips:show(GetElement(self.m_root,"btn4",WZUIButton),WndCheckOther.m_root,25,tData,ccp(0,-500))
		elseif element:getTag() == 6 then
			WndTips:show(GetElement(self.m_root,"btn4",WZUIButton),WndCheckOther.m_root,25,tData,ccp(0,-500))
		else
			WndTips:show(element,WndCheckOther.m_root,25,tData,ccp(0,-500))
		end
	elseif self.m_nType == 4 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,28,self.m_tDataList[element:getTag()],ccp(-160,35))
	end
end

--@brief 	开始加载
function CellCheckOther10:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCheckOther10")

	self.m_root:addChild(celElement)

	if self.m_nType == 2 then   --星魂
		self:showStarSoul(self.m_tTempData)
	elseif self.m_nType == 3 then --祈福
		self:showPrays(self.m_tTempData)
	elseif self.m_nType == 4 then -- 修炼
		self:showPractice(self.m_tTempData, self.m_tTempData2)
	end
end

--@brief	设置高亮
function CellCheckOther10:setHighLight(bool)
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	显示星魂
--@param	tData:要显示的星魂id数组
function CellCheckOther10:showStarSoul(tData)
	self.m_nType = 2
	local num = 0
	self.m_tDataList = {}
	for i=1,#tData do
		if tData[i] == nil or GDatatab_starsoul["id_"..tData[i]] == nil then break end
		local tStarsoul = GDatatab_starsoul["id_"..tData[i]]
		local tStarsoulNext = GDatatab_starsoul["id_"..(tData[i]+1)] 
		if (tStarsoulNext == nil or tStarsoul.star ~= tStarsoulNext.star) and num < 6 then
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
function CellCheckOther10:showPrays(tData)
	WZLog("CellCheckOther10:showPrays")
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
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setColor(QUALITYCOLOR[tPray.quality])
			local prayName = GetElement(self.m_root,"prayName"..i,WZUILabelTTF)
			if ProjConfig.LANGUAGE == "vn" then
				prayName:setFontSize(16)
			end
			prayName:setVisible(true)
			prayName:setText("Lv"..tPray.level..GDatatab_item["id_"..item_id].name)
			prayName:setColor(QUALITYCOLOR[tPray.quality])
			
			if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
				local prayName = GetElement(self.m_root,"prayName"..i,WZUILabelTTF)
				prayName:setFontSize(13)
				prayName:setDimensions(GlobalMethod:CCSize(74))
				prayName:setRelativePosition(GlobalMethod:ccp(0.5,0.212632))				
			end
		end
	end
end

--@brief	显示修炼
function CellCheckOther10:showPractice(tData, tData1)
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
		elseif tPractice.level <= 160 then
			tempTable.quality = 3 
		end
		table.insert(self.m_tDataList,tempTable)
		end
	end
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

		if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			GetElement(self.m_root,"prayName"..i,WZUILabelTTF):setFontSize(13)
		end
		local prayName = GetElement(self.m_root,"prayName"..i,WZUILabelTTF)
		if ProjConfig.LANGUAGE == "vn" then
			prayName:setFontSize(18)
		end
		prayName:setVisible(true)
		prayName:setText(LocalStrings.LV..data.level..ATTR_TITLE[data.attrId])
		prayName:setScale(0.9)
		prayName:setColor(QUALITYCOLOR[data.quality])
	end
	--设置底图
	for i=1, 6 do
		local emptyIcon = GetElement(self.m_root,"iconBg"..i,WZUIImage)
		emptyIcon:setVisible(false)
	end
end

--@brief  修炼按属性排序
function _sortPractice(a,b)
	return a.attrId < b.attrId
end
-------------------------------------私有方法模块End----------------------------------------
