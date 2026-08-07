--WndKidDress.lua
--@brief	WndKidDress的UI模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小孩时装界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidDress:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	CacheCenter:registerUpatePlayerHomeItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidDress:onExit(element)
	CacheCenter:unregisterUpatePlayerHomeItemObserver(self)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidDress:onEnterTransitionDidFinish(element)
    -- body
    self.m_nCurrentIndex = 1
    self:setTabText()
    self:initDressGrid()
    self:setGridTypeImg()

    self:updateDress()
	self:_update()
end

--@brief 	触摸开始回调
function WndKidDress:onTouchBegan(element, pt)
	-- body
	if self.m_root and not self:checkPointInBtn(pt) then
        self:hideSuitList()
    end
end

--@brief	点击头部标签
function WndKidDress:onTab1()
	WZLog("WndKidDress:onTab1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 1 then return end
	self.m_nCurrentIndex = 1
	self:updateDress()
end

--@brief	点击表情标签
function WndKidDress:onTab2()
	WZLog("WndKidDress:onTab2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 2 then return end
	self.m_nCurrentIndex = 2
	self:updateDress()
end

--@brief	点击身体标签
function WndKidDress:onTab3()
	WZLog("WndKidDress:onTab3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 3 then return end
	self.m_nCurrentIndex = 3
	self:updateDress()
end

--@brief 	点击当前孩子按钮回调
--@note 	收起或展示孩子列表
function WndKidDress:onClickShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_bIsOpenList = not self.m_bIsOpenList
	
	self:setArrowAndListState()
end

--@brief 	点击切换孩子回调
function WndKidDress:onClickChange(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--如果点击的是正在使用的，则不处理
	if nTag == self.m_nKidIndex then
		return 
	end

	self.m_nKidIndex = nTag

	local nGapY = 1/(2 * 2)
	self.m_nodeKidSel:setRelativePosition(GlobalMethod:ccp(0.5, (1 - nGapY) - (self.m_nKidIndex - 1) * nGapY * 2))

	self:hideSuitList()
	
	self:updateDress()
	self:_update()
end

--@brief 	
function WndKidDress:checkPointInBtn(pt)
	-- body
	local btn
	btn = GetElement(self.m_root, "conForChooseBaby_WndKidDress", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end
	btn = GetElement(self.m_root, "conOther_WndKidDress", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end

	return false 
end

--@brief	续费按钮点击
function WndKidDress:onRenew(data)
	WZLog("WndKidDress:onRenew",data.basicInfo.name)
   	WndPurchase:showBuyInterface(data.maintype,data,self,self.onRenewCallBack)
end

function WndKidDress:onRenewCallBack()
	WZLog("WndKidDress:onRenewCallBack")
	self:updateDressAttr()
end

--@brief	穿戴按钮点击
function WndKidDress:onDress(tData)
	WZLog("WndKidDress:onDress",tData.basicInfo.name)
	if WndItemInfo.m_root ~= nil then return end

	WndBag:onItemClick(2,tData)

	self:updateDress()
end

--@brief	卸下时装回调
function WndKidDress:onUnderRoyal(wndItemInfo, tData)
	WZLog("WndKidDress:onUnderRoyal", Serialize(tData))
   	local id = WZLuaVector_int_:create()
	id:push(tData.playerItemId)

	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	ProtocolProcessorKid:send_WEDDING_ChangeChildFashion(tCurKidData.id, id)
end

--@brief    规则按钮回调
function WndKidDress:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT109)
end

--@brief 	购买试穿小孩时装
function WndKidDress:buyTryClothes()
	-- body
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	WZLog("WndKidDress:buyTryClothes", Serialize(self.m_tTryClothesData))
	local tempList = {}
	for i, v in pairs(self.m_tTryClothesData) do
		local newData = {}
        newData.subType = v.basicInfo.sub_type
        newData.mainType = v.basicInfo.mainType
        newData.initData = CopyTable(v)
		table.insert(tempList,newData)
	end
	WndBuy:showBuyInterface(tempList, tCurKidData.sex, 2) 
end

--@brief 	关闭界面
function WndKidDress:closeWnd()
	-- body
	WndKidManager:closeWindow()
end

--@brief 	批量购买成功后，清掉试穿状态标记
function WndKidDress:cleanTryState()
	-- body
	if self.m_root == nil then return end 
	if self.m_tTryClothesData == nil then return end 
	
	for i, v in pairs(self.m_tTryClothesData) do
		WndKidDress:cancelWear(0, v)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndKidDress:_update()
	-- body
	self:showFighting()
	self:_createSuitList()
	self:showKidAni()
	self:updateDressGrid()
end

--@brief 	设置战力
function WndKidDress:showFighting()
	-- body
	local ftxtFighting = GetElement(self.m_root, "ftxtFighting_WndKidDress", WZUIFreeTextBox)
	if ftxtFighting then
		local sFormat = [[<T C="255,236,193" S="24" P="1" SC="127,70,26" SS="4" SE="1">%s:</T><T C="255,236,193" S="24" P="1" SC="127,70,26" SS="4" SE="1">%d</T>]]
		local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
		ftxtFighting:setShowText(string.format(sFormat, LocalStrings.BATTLE, tCurKidData.fighting))
	end
end

--@brief	初始化4个时装格子
function WndKidDress:initDressGrid()
	WZLog("WndKidDress:initDressGrid")
	if self.m_root == nil then return end
	self.m_tDressGrid = {}
	for i = 1, 3 do
		local con = self.m_root:getChildElement("conGrid"..i.."_WndKidDress")
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(WndKidDress, WndKidDress.onDressClicked)
				con:addChild(celElement)
            	celElement:setTag(i)
            	celElement:setScale(0.8)
				table.insert(self.m_tDressGrid,tLuaObj)
			end
		end
	end
end

--@brief	时装格子被点击函数
function WndKidDress:onDressClicked(tLuaObj,tag,tData)
	WZLog("WndKidDress:onDressClicked",tag)
	if WndKidDress.m_root ~= nil then
		WndKidDress["onTab"..(tag)](WndKidDress)
	end

	if tData ~= nil and tData.basicInfo ~= nil then
		local tOther = {interface = 1}
		local conCouple = GetElement(self.m_root,"conCouple_WndKidDress",WZUIContainer)
    	WndItemInfo:showInfo(tLuaObj.m_root, self.m_root, 1, tData, true, nil, nil, tOther)
		if tData.tBtnList ~= nil then
    		WndItemInfo:setClickButtonCallback(self,self.cancelWear)
		end
	else
		local showWord = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES}
		local conCouple = GetElement(self.m_root,"conCouple_WndKidDress",WZUIContainer)
		WndItemInfo:showInfo(tLuaObj.m_root,conCouple,3,showWord[tag],false)
	end
end

--@brief	取消
function WndKidDress:cancelWear(tag, tData)
	WZLog("WndKidDress:cancelWear",tData.basicInfo.name,tData.basicInfo.sub_type)
	WndItemInfo:onCloseClick()
	if tag == 1 then
		WndPurchase:showBuyInterface(tData.basicInfo.sub_type, tData.shopItemId)
		return
	end
	local color = 0
	if self.m_tTryWearGrid then
		if self.m_tTryWearGrid.gridLuaObj then
			self.m_tTryWearGrid.gridLuaObj:_removeTryWear()
		end 
	end

	--获得当前拥有的时装
	local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
	local equipmentList = CacheCenter:getKidEquipmentDressList(tCurKidData.sex, tCurKidData.id)
	local animation_index_code

	--取消格子
	if WndKidDress.m_root == nil then return end
	local sub_type = tData.basicInfo.sub_type
	local i = sub_type
	local set = false
	local txt = GetElement(WndKidDress.m_root, "dressTxt" .. i .. "_WndKidDress", WZUIImage)
	for j = 1, #equipmentList do
		if equipmentList[j].maintype == 31 and equipmentList[j].subtype == sub_type then
			WndKidDress.m_tDressGrid[i]:setCellGoodItem(equipmentList[j], 18)
			animation_index_code = equipmentList[j].basicInfo.animation_index_code
			color = equipmentList[j].color
			txt:setVisible(false)
			set = true
		end
	end
	if set == false then
		WndKidDress.m_tDressGrid[i]:removeAllChild()
		--WndKidDress.m_tDressGrid[i]:setSZBg()
		txt:setVisible(true)
		--设置默认显示
		local gameParam = CacheCenter:getGameParam()
		if CacheCenter:getPlayerInfo().sex == 0 then
			if sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleHeadId].animation_index_code
			elseif sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleFaceId].animation_index_code
			elseif sub_type == 3 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultmaleBodyId].animation_index_code
			end
		else
			if sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			elseif sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			elseif sub_type == 3 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultfemaleHeadId].animation_index_code
			end
		end
	end

	--取消人物
	local conPlayer = WndKidDress.conPlayer
	if sub_type == 1 then
		conPlayer:setHead(animation_index_code)
	elseif sub_type == 2 then
		conPlayer:setFace(animation_index_code)
	elseif sub_type == 3 then
		conPlayer:setBody(animation_index_code)
	end
	conPlayer:play("wait",true)
	--取消记录试穿的时装itemId
	if WndKidDress.m_tTryWearList == nil then WndKidDress.m_tTryWearList = {} end
	if self.m_tTryClothesData == nil then self.m_tTryClothesData = {} end
	WndKidDress.m_tTryWearList[sub_type] = nil
	self.m_tTryClothesData[sub_type] = nil 
end

--@brief 	设置格子底图
function WndKidDress:setGridTypeImg()
	-- body
	local dressTxt1 = GetElement(self.m_root, "dressTxt1_WndKidDress", WZUIImage)
	local dressTxt2 = GetElement(self.m_root, "dressTxt2_WndKidDress", WZUIImage)
	local dressTxt3 = GetElement(self.m_root, "dressTxt3_WndKidDress", WZUIImage)

	if self.m_tCurKidData then
		if self.m_tCurKidData.sex == 0 then
			dressTxt1:setFile("ui/bag/common_icon_toubu2.png")
			dressTxt2:setFile("ui/bag/common_icon_biaoqing2.png")
			dressTxt3:setFile("ui/bag/common_icon_fuzhaung2.png")
		else
			dressTxt1:setFile("ui/bag/common_icon_toubu.png")
			dressTxt2:setFile("ui/bag/common_icon_biaoqing.png")
			dressTxt3:setFile("ui/bag/common_icon_fuzhaung.png")
		end
	end
end

--@brief 	设置标签文字
function WndKidDress:setTabText()
	-- body
	if SceneKidHome.m_tKidData and #SceneKidHome.m_tKidData == 2 then
		--显示孩子选择按钮
		GetElement(self.m_root, "conForChooseBaby_WndKidDress", WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "conForChooseBaby_WndKidDress", WZUIContainer):setVisible(false)
	end

	local txtTab1 = GetElement(self.m_root, "txtTab1_WndKidDress", WZUILabelTTF)
	local txtTab2 = GetElement(self.m_root, "txtTab2_WndKidDress", WZUILabelTTF)
	local txtTab3 = GetElement(self.m_root, "txtTab3_WndKidDress", WZUILabelTTF)

	txtTab1:setText(LocalStrings.HEAD)
	txtTab2:setText(LocalStrings.FACE)
	txtTab3:setText(LocalStrings.BODY)
end

--@brief	更新时装栏
function WndKidDress:updateDress()
	--body
	--当前部位数量
	local s = {LocalStrings.BAGTIP31,LocalStrings.BAGTIP32,LocalStrings.BAGTIP33}
	GetElement(self.m_root,"ttf1_WndKidDress",WZUILabelTTF):setText(s[self.m_nCurrentIndex])
	local num = 0
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	--获取当前性别的孩子拥有的时装数据
	local tempList = CacheCenter:getKidDecorationListBySex(tCurKidData.sex)
	for k,v in pairs(tempList) do
		if v.subtype == self.m_nCurrentIndex and v.lastTime ~= 0 then
			num = num + 1
		end
	end
	GetElement(self.m_root,"ttf2_WndKidDress",WZUILabelTTF):setText(num)
	--当前部位附加属性
	-- GetElement(self.m_root,"ttf4_WndKidDress",WZUILabelTTF):setText("0")
	-- for k,v in pairs(GDatatab_shizhuang) do
	-- 	if (v.buwei + 1) == self.m_nCurrentIndex then
	-- 		GetElement(self.m_root,"ttf3_WndKidDress",WZUILabelTTF):setText(ATTR_TITLE[v.shuxing[1][1]]..":")
	-- 		if num == v.number then
	-- 			GetElement(self.m_root,"ttf4_WndKidDress",WZUILabelTTF):setText(v.shuxing[1][2])
	-- 		end
	-- 	end
	-- end
	
	--设置标签字体颜色
    GetElement(self.m_root, "checkBox_WndKidDress", WZUICheckBoxGroup):setCheckIndex(self.m_nCurrentIndex - 1)
	for i=1,3 do
		GetElement(self.m_root,"imgTab"..i.."_WndKidDress",WZUI9Image):setVisible(false)
	end
	GetElement(self.m_root,"imgTab"..self.m_nCurrentIndex.."_WndKidDress",WZUI9Image):setVisible(true)

	for i = 1, 3 do
		GetElement(self.m_root,"txtTab"..i.."_WndKidDress",WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(105,65,46))
		GetElement(self.m_root,"txtTab"..i.."_WndKidDress",WZUILabelTTF):setColor(GlobalMethod:ccc3(195,171,148))
	end
	GetElement(self.m_root,"txtTab"..self.m_nCurrentIndex.."_WndKidDress",WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(127,70,26))
	GetElement(self.m_root,"txtTab"..self.m_nCurrentIndex.."_WndKidDress",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))

	--时装列表及背景图大小
	local tableCon = GetElement(self.m_root,"tableCon_WndKidDress",WZUITableContainer)
	tableCon:setLoadCountPerFrame(4)

	self:updateDress2()
end


--@brief	更新时装栏
function WndKidDress:updateDress2()
	self.m_nMaxFight = nil

	if self.m_root == nil then return end
	local tempList = {}
	self.m_tTempList = tempList
	local dressType = {[1]=1, [2]=2, [3]=3}
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	local equipmentList = CacheCenter:getKidDecorationListBySex(tCurKidData.sex)
	
	self.m_nMaxFight = 0
	--时装格子索引
	local ownDressIdList = {}

	for i = 1, #equipmentList do
		if equipmentList[i].subtype == dressType[self.m_nCurrentIndex] and equipmentList[i].lastTime ~= 0 then
			ownDressIdList[equipmentList[i].basicInfo.id] = true
			if equipmentList[i].childId == 0 or (equipmentList[i].isUse and equipmentList[i].childId == tCurKidData.id) then
				equipmentList[i].showType = 1
				table.insert(tempList, equipmentList[i])
			end
		end
	end

	table.sort(tempList, sortDressList)
	WZLog("WndKidDress:updateDress2", Serialize(tempList))

	--头部、表情、服装显示商城时装
    WZLog("WndKidDress:updateDress two")
	CacheCenter:getShopItems(function(t,shopItemList) 
		local dataList = shopItemList

		if dataList ~= nil then
			for i = 1, #dataList do
				if dataList[i].basicInfo.main_type == 31 and dataList[i].isOnSale == true 
					and dataList[i].mainType ~= [[{"5":"1"}]]
					and dataList[i].basicInfo.sub_type == dressType[self.m_nCurrentIndex] 
					and (dataList[i].basicInfo.sex == tCurKidData.sex or dataList[i].basicInfo.sex == 2)  
					and ownDressIdList[dataList[i].basicInfo.id] ~= true then
					dataList[i].showType = 2
					table.insert(tempList,dataList[i])
				end
			end
		end
	end)

	self:_addDressCell()
end


--@brief    创建按钮
function WndKidDress:_createBtn(btnText, fontSize, FontColor)
    -- body
    local btnSuit = WZUIButton:create()
    btnSuit:setUseAbsSize(true)
    btnSuit:setAbsContentSize(GlobalMethod:CCSize(118, 34))
    local imgNor = WZUIImage:create()
    imgNor:setFile("ui/common/common_scale9_fengexian2.png")
    imgNor:setUseOriginSize(true)
    imgNor:setScaleX(0.17)
    imgNor:setScaleY(0.3)
    imgNor:setRelativePosition(GlobalMethod:ccp(0.6,0.07))
    if btnText ~= "+" then
    	btnSuit:addChild(imgNor)
    end

    local txtBtn = WZUILabelTTF:create()
    if fontSize then 
    	txtBtn:setFontSize(fontSize)
    else
    	txtBtn:setFontSize(20)
    end
    if FontColor then
    	txtBtn:setColor(FontColor)
    else
    	txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
    end
    txtBtn:setEnableStroke(false)
    txtBtn:setStrokeSize(4)
    txtBtn:setStrokeColor(GlobalMethod:ccc3(127,70,26))
    txtBtn:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtBtn:setRelativePosition(GlobalMethod:ccp(0.2,0.45))
    txtBtn:setText(btnText)
    txtBtn:setTag(44)
    btnSuit:addChild(txtBtn)
    btnSuit:setLuaDoneFunctionName("onClickChange")

    return btnSuit
end

--@brief 	设置箭头和列表的状态
function WndKidDress:setArrowAndListState()
	-- body
	local imgArrow = GetElement(self.m_root, "imgArrow_WndKidDress", WZUIImage)
	if imgArrow then
		imgArrow:setFlipY(self.m_bIsOpenList)
	end
	GetElement(self.m_root, "conOther_WndKidDress", WZUIContainer):setVisible(self.m_bIsOpenList)
end

--@brief 	隐藏套装列表
function WndKidDress:hideSuitList()
	-- body
	if self.m_root == nil then return end 
	if self.m_bIsOpenList == false then return end 

	self.m_bIsOpenList = not self.m_bIsOpenList
	self:setArrowAndListState()
end

--@brief 	创建选中当前选中的套装
function WndKidDress:_createRectSel()
	-- body
	if self.m_nodeKidSel == nil then
		self.m_nodeKidSel = WZUIContainer:create()
		self.m_nodeKidSel:setAbsContentSize(GlobalMethod:CCSize(116,30))
		self.m_nodeKidSel:setUseAbsSize(true)

		local img9 = WZUI9Image:create()
		img9:setFile("ui/common/common_scale9_wbbsxz.png")

		self.m_nodeKidSel:addChild(img9)

		local conKidList = GetElement(self.m_root, "conKidList_WndKidDress", WZUIContainer)
		conKidList:addChild(self.m_nodeKidSel)
	end
end

--@brief 	创建套装列表
function WndKidDress:_createSuitList()
	-- body
	if SceneKidHome.m_tKidData and #SceneKidHome.m_tKidData == 2 then
		local conOther = GetElement(self.m_root, "conOther_WndKidDress", WZUIContainer)
		local conKidList = GetElement(self.m_root, "conKidList_WndKidDress", WZUIContainer)
		self.m_nodeKidSel = nil 
		conKidList:removeAllChildrenWithCleanup(true)

		local nTotalNum = 2
		local nNum = nTotalNum

		conOther:setAbsContentSize(GlobalMethod:CCSize(122, nNum * 34))
		conOther:updateRelativeSize()
		local nGapY = 1/(nNum * 2)
		for i = 1, nTotalNum do
			local btnSuit = self:_createBtn(SceneKidHome.m_tKidData[i].name)
	    	btnSuit:setRelativePosition(GlobalMethod:ccp(0.38, (1 - nGapY) - (i - 1) * nGapY * 2))
	    	btnSuit:setTag(i)

	    	conKidList:addChild(btnSuit)

    		if i == self.m_nKidIndex then
				self:_createRectSel()
				self.m_nodeKidSel:setRelativePosition(GlobalMethod:ccp(0.5, (1 - nGapY) - (i - 1) * nGapY * 2))
			end
		end
	end
end

--@brief 	展示小孩形象
function WndKidDress:showKidAni()
	-- body
	local tData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	GetElement(self.m_root, "txtCurBabyName_WndKidDress", WZUILabelTTF):setText(tData.name)

	local tEquip = {}
	-- if tData.sex == 1 then
 --        tData.faceId = 51301
 --    end
	table.insert(tEquip,tData.headId)
    table.insert(tEquip,tData.faceId)
    table.insert(tEquip,tData.bodyId)
    local conForAni = GetElement(self.m_root, "conForAni_WndKidDress", WZUIContainer)
    if conForAni:getChildByTag(99) then
    	conForAni:removeChildByTag(99, true)
    end

	local conKid = CreatePlayerBabyFigure(tData.sex, tEquip, "wait")
	conForAni:addChild(conKid:getAnimNode(), 0, 99)
    conKid:getAnimNode():setScale(1)

    self.conPlayer = conKid
end

--@brief	每帧加载时装Cell
function WndKidDress:_addDressCell()
	WZLog("WndKidDress:_addDressCell")

	local con = GetElement(self.m_root,"tableCon_WndKidDress",WZUITableContainer)
	con:cleanTable()
	self.m_tDressList = {}
	local conDressR = GetElement(self.m_root, "conDressR_WndKidDress", WZUIContainer)
	if self.m_tTempList == nil or #self.m_tTempList == 0 then
		ShowPanelNullTip(conDressR, LocalStrings.KID_TEXT76)
		return 
	end
	removeShowPanelNullTip(conDressR)

	for i = 1, #self.m_tTempList do
		local cellElement,tCell
		
		cellElement,tCell = CellDress:createElement()
		cellElement:setTag(i-1)
		con:setCellElement(cellElement)
		tCell:update(self.m_tTempList[i], self.m_tTempList[i].showType)
		tCell:onRenewCallBack(self,self.onRenew)
		tCell:onDressCallBack(self,self.onDress)
		self.m_tDressList[i] = tCell
		self.m_tDressList[i]:setFight(false)

		--记录试穿格子
		if self.m_tTryWearList ~= nil then 
			for k, v in pairs(self.m_tTryWearList) do
				if self.m_tTempList[i].basicInfo.id == v then
	   				self.m_tTryWearGrid = tCell
				end
			end
		end
	end
end

--@brief	更新3个时装格子
function WndKidDress:updateDressGrid()
	WZLog("WndKidDress:updateDressGrid",Serialize(WndKidDress.m_tTryWearList))
	if self.m_root == nil then return end
	if self.m_tDressGrid == nil then return end
	if CacheCenter:getPlayerInfo() == nil then return end
	local dressType = {[1]=1,[2]=2,[3]=3}
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	local equipmentList = CacheCenter:getKidEquipmentDressList(tCurKidData.sex, tCurKidData.id)
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png"}
	if tCurKidData.sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png"}
	end	

	for i = 1, 3 do
		if WndKidDress.m_tTryWearList == nil or WndKidDress.m_tTryWearList[dressType[i]] == nil then
			local set = false
	    	local txt = GetElement(self.m_root, "dressTxt"..i .. "_WndKidDress", WZUIImage)
			for j = 1, #equipmentList do
				if equipmentList[j].maintype == 31 and equipmentList[j].subtype == dressType[i] then
	   				self.m_tDressGrid[i]:setCellGoodItem(equipmentList[j], 18)
	    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
					txt:setVisible(false)
					set = true
				end
			end
			if set == false then
				self.m_tDressGrid[i]:removeAllChild()
				txt:setVisible(true)
				txt:setFile(imgList[i])
				txt:setTouchEnable(false)
	    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
	    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
	    		GetElement(self.m_tDressGrid[i].m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
	    		GetElement(self.m_tDressGrid[i].m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
			end
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndKidDress:_adaptLanguage_vn( )
	GetElement(self.m_root,"ttf1_WndKidDress",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.950909))
	GetElement(self.m_root,"ttf2_WndKidDress",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.375,0.948517))

	local txtTips = GetElement(self.m_root,"txtTips_WndKidDress",WZUILabelTTF)
	txtTips:setScale(0.9)
	txtTips:setRelativePosition(GlobalMethod:ccp(0.54,0.04))
end

function WndKidDress:_adaptLanguage_th( )
	GetElement(self.m_root,"ttf1_WndKidDress",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.950909))
	GetElement(self.m_root,"ttf2_WndKidDress",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.375,0.948517))

	local txtTips = GetElement(self.m_root,"txtTips_WndKidDress",WZUILabelTTF)
	txtTips:setScale(0.85)
	txtTips:setRelativePosition(GlobalMethod:ccp(0.54,0.04))
end

function WndKidDress:_adaptLanguage_pt( )
	local txtTips = GetElement(self.m_root,"txtTips_WndKidDress",WZUILabelTTF)
	txtTips:setScale(0.9)
	txtTips:setRelativePosition(GlobalMethod:ccp(0.541379,0.0519048))

	GetElement(self.m_root, "ftxtFighting_WndKidDress", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.5,0.137))
end

function WndKidDress:_adaptLanguage_es( )
	local txtTab1 = GetElement(self.m_root, "txtTab1_WndKidDress", WZUILabelTTF)
	txtTab1:setScale(0.7)
	txtTab1:setDimensions(GlobalMethod:CCSize(110))
	local txtTab2 = GetElement(self.m_root, "txtTab2_WndKidDress", WZUILabelTTF)
	txtTab2:setScale(0.7)
	txtTab2:setDimensions(GlobalMethod:CCSize(110))
	local txtTab3 = GetElement(self.m_root, "txtTab3_WndKidDress", WZUILabelTTF)
	txtTab3:setScale(0.7)
	txtTab3:setDimensions(GlobalMethod:CCSize(110))

	local txtTips = GetElement(self.m_root,"txtTips_WndKidDress",WZUILabelTTF)
	txtTips:setScale(0.9)
	txtTips:setRelativePosition(GlobalMethod:ccp(0.541379,0.0519048))
	
	GetElement(self.m_root, "ftxtFighting_WndKidDress", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.5,0.137))
end
-------------------------------------语言适配End----------------------------------------