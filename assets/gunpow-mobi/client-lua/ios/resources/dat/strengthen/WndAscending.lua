--WndAscending.lua
--@brief	WndAscending的UI模块
--@date		2016/09/13
--@author	zsq
--@note		升阶系统

local blueprintIDList = {DRAWINGPURPLEWEAPON,DRAWINGPURPLEWEAPON,DRAWINGPURPLERING,DRAWINGPURPLENECKLACE,DRAWINGPURPLEWRISTER,DRAWINGPURPLETREASURE,DRAWINGPURPLEBADGE}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAscending:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_WndAscending_Tab1)

    self:controlBtnShow()
end

----@brief onEnter函数执行完成回调
function WndAscending:onEnterTransitionDidFinish(element)
	--设置界面ID	
	--ChangeChatChannel(Chat_CHannel_Strengthen)
	ProtocolProcessorScenePets:regAll()
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	CacheCenter:registerUpatePlayerPetInfoObserver(self)
	self.evoOrangePetNeedPetLevel = CacheCenter:getGameParam().evoOrangePetNeedPetLevel or 0
	self.evoOrangePetNeedAdLevel = CacheCenter:getGameParam().evoOrangePetNeedAdLevel or 0
	WZLog("宠物进化",self.evoOrangePetNeedAdLevel,self.evoOrangePetNeedPetLevel)
	--self.evoOrangePetNeedPetLevel = 7
	--self.evoOrangePetNeedAdLevel = 0

	--添加顶部栏
	self:_addTop()
	GetElement(self.m_root,"nullTip1",WZUILabelTTF):setText(string.format(LocalStrings.ASCENDING17,LANASCENDINGSTRONG,LANASCENDINGSTAR))
	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setText(string.format(LocalStrings.ASCENDING18,ZIASCENDINGSTRONG,ZIASCENDINGSTAR))
	self:AdaptResolution()
	AdaptLanguage(self)
	WZLog("self.m_nTempCurTab=",self.m_nTempCurTab)
	if self.m_nTempCurTab ~= nil and self.m_nTempCurTab ~= 1 then
		GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(self.m_nTempCurTab-1)
		self["onTab"..self.m_nTempCurTab](self)
		self.m_nTempCurTab = nil 
		return 
	end
	if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn"
		or ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")
	end

	self.m_nCurTab = 1
	self.m_nRightTab = 1
	self.m_bChecked = false
	GetElement(self.m_root,"retention",WZUICheckBox):setCheckIndex(0)
	GetElement(self.m_root,"conRetention",WZUIContainer):setVisible(false)

	self:_setCheckBoxLabelText(self.m_nCurTab)

	self:_initEquipListByTag()
	self:cleanWnd()

	self:updateMNum()
	self:AdaptResolution()
	AdaptLanguage(self)
end

function WndAscending:jumpTo(index)
	if self.m_root then
		WindowManager:removeWindow(self.m_root, self, true)
	end

    local wnd = WndAscending:createElement()
    self.m_nTempCurTab = index
    WindowManager:addWindow(wnd, WndAscending, false)
end

--@brief	系统说明
function WndAscending:onInfo()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurTab == 1 or self.m_nCurTab == 2 then
	    WndSingleMapDesc:showInterface(LocalStrings.ASCENDINGEXPLAIN)
	elseif self.m_nCurTab == 3 then
	    WndSingleMapDesc:showInterface(LocalStrings.ASCENDINGEXPLAIN2)
	elseif self.m_nCurTab == 4 then
	    WndSingleMapDesc:showInterface(LocalStrings.ASCENDINGEXPLAIN3)
	elseif self.m_nCurTab == 5 then
	    WndSingleMapDesc:showInterface(LocalStrings.ASCENDINGEXPLAIN5)
	end
end

function WndAscending:updatePlayerItemData()
	WZLog("WndAscending:updatePlayerItemData")
	self:updateMNum()
	if self.m_nCurTab == 3 then

	elseif self.m_nCurTab == 2 then
		--拥有图纸数量
		if self.m_tEquipBefore ~= nil then
			local blueprintID = blueprintIDList[self.m_tEquipBefore.basicInfo.sub_type+1]
			GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
			self.m_nOwnM = CacheCenter:getPlayerItemCountById(blueprintID)
		end
	elseif self.m_nCurTab == 4 then
		WndAscending:setPetCost()
	elseif self.m_nCurTab == 5 then
		self:showMountM()
	else
		self:_initEquipListByTag()

		if self.m_nCurTab == 1 then
			self:showM()
		end
	end
end

function WndAscending:updateMNum()
		if self.m_nCurTab == 1 then return end
		if self.m_nCurTab == 3 then
			self:_updateFuseCostNum(self.m_tSelectedData)
			return 
		end
		--显示调品箱图片
		GetElement(self.m_root,"imgAdd4",WZUIImage):setFile(GDatatab_item["id_"..ORANGECHANGEGRADEMATERIAL].icon)
		--拥有调品箱数量
		local num1 = CacheCenter:getPlayerItemCountById(ORANGECHANGEGRADEMATERIAL)
		--设置调品箱数量
		GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setText(num1.."/1")
		if num1 < 1 then
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,89,74))
		else
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		end
		WZLog("--self.m_tEquipBefore--",self.m_tEquipBefore)
		if self.m_tEquipBefore == nil then return end
		--显示品级
		local items = CacheCenter:getPlayerItems()
		local tEquip
		for i=1,#items do
			if items[i].playerItemId == self.m_tEquipBefore.playerItemId then
				tEquip = items[i]
				break
			end
		end
		if tEquip.extraInfo.orangeEquiGrade == nil then
			GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_1"].name)
		end
		local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade, "|")
		GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_"..grade[1]].name)
		if tonumber(grade[1]) == 5 then
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
		else
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
		end
		--显示消耗材料
		GetElement(self.m_root,"cost",WZUILabelTTF):setText(1)
		local blueprintID = blueprintIDList[self.m_tEquipBefore.basicInfo.sub_type+1]
		GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..blueprintID].icon)
		--拥有图纸数量
		GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
		WZLog("--has--",CacheCenter:getPlayerItemCountById(blueprintID))
		self.m_nOwnM = CacheCenter:getPlayerItemCountById(blueprintID)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAscending:onExit(element)
	self:_unInit()
	--ProtocolProcessorScenePets:unregAll()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpatePlayerPetInfoObserver(tObserver)
end

function WndAscending:onTouchBegan(element,pt)
	local bPoint = WndItemInfo:checkPoint(pt,dir)
	if bPoint == false then
		WndItemInfo:onCloseClick()
	end

	if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end

--@brief	外部跳转进入
function WndAscending:jumpToAddEquip(tEquip, index)
    local wnd = WndAscending:createElement()
    WindowManager:addWindow(wnd, WndAscending, false)
	self["onTab"..index](self)
	GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(index-1)

	--判断装备是否满足放置的条件
	--蓝装可以升阶
	if tEquip ~= nil and tEquip.basicInfo ~= nil and tEquip.extraInfo ~= nil and tEquip.basicInfo.quality == 2 and tEquip.extraInfo.strongLevel ~= nil and tEquip.extraInfo.strongLevel >= LANASCENDINGSTRONG and tEquip.extraInfo.starLevel ~= nil and tEquip.extraInfo.starLevel >= LANASCENDINGSTAR then
		self:_addEquipToCell(tEquip)
	end
	--紫装可以升阶
	if tEquip ~= nil and tEquip.basicInfo ~= nil and tEquip.extraInfo ~= nil and tEquip.basicInfo.quality == 3 and tEquip.extraInfo.strongLevel ~= nil and tEquip.extraInfo.strongLevel >= ZIASCENDINGSTRONG and tEquip.extraInfo.starLevel ~= nil and tEquip.extraInfo.starLevel >= ZIASCENDINGSTAR then
		self:_addEquipToCell(tEquip)
	end
	--橙装可以调品
	if tEquip ~= nil and tEquip.basicInfo ~= nil and tEquip.basicInfo.quality == 4 then
		self:_addEquipToCell2(tEquip)
	end
end

function WndAscending:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_sgxt.png",WndAscending,WndAscending.onClose,true,false,false,"WndAscending",{goldType=1})
end

--@brief	关闭按钮回调函数
function WndAscending:onClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_bRunning == true then return end
	WindowManager:removeWindow(self.m_root, self, true)
    ChangeChatChannel(Chat_Channel_Island)
end

--@brief	切换右侧装备栏
function WndAscending:onSelectEquip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_bRunning == true then return end
	self.m_nRightTab = element:getTag()
	self:switchStat(element:getTag())
end

--@brief 	点击融合右边栏回调
function WndAscending:onCellClicked(tData, tCell)
	-- body
	for i = 1, #self.m_tFuseCellList do
		self.m_tFuseCellList[i]:setHightLightVisible(false)
	end
	tCell:setHightLightVisible(true)
	--清除原来的内容
	self:_cleanFuseGrid()

	self.m_tSelectedData = tData 
	if self.m_nRightTab == 1 then
		self:_setBottomInfo(true)
	else
		self:_setBottomInfo(false)
	end
	--装备新的祝福
	self:_takeonBless(tData)
end

function WndAscending:switchStat(index)
	if self.m_nCurTab == 3 then
		--清除原来的内容
		self:_cleanFuseGrid()
	end
	self:_initEquipListByTag()
	for i=1,4 do
		GetElement(self.m_root,"conCheck"..i,WZUIContainer):setVisible(false)
	end
	GetElement(self.m_root,"conCheck"..index,WZUIContainer):setVisible(true)
end

function WndAscending:onTab1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_bRunning == true then return end
	if self.m_nCurTab == 1 then return end
	self.m_nCurTab = 1
	self:cleanWnd()
	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setText(string.format(LocalStrings.ASCENDING25,
		self.evoOrangePetNeedAdLevel,self.evoOrangePetNeedPetLevel))
	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab5",WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conTopCheck3_Sel_WndAscending", WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCheckBox1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgRightBg",WZUI9Image):setVisible(true)
	self:_setCheckBoxLabelText(self.m_nCurTab)
	self:_initEquipListByTag()
    ChangeChatChannel(Chat_Channel_WndAscending_Tab1)

	GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer):setContentSize(GlobalMethod:CCSize(320,440))
end

function WndAscending:onTab2()
	if self.m_bRunning == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nCurTab == 2 then return end
	self.m_nCurTab = 2
	self:cleanWnd()
	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab5",WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conTopCheck3_Sel_WndAscending", WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgRightBg",WZUI9Image):setVisible(true)
	self:_setCheckBoxLabelText(self.m_nCurTab)
	self:_initEquipListByTag()
    ChangeChatChannel(Chat_Channel_WndAscending_Tab2)

	GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer):setContentSize(GlobalMethod:CCSize(320,440))
end

--@brief 	点击融合标签回调
function WndAscending:onTab3()
	if self.m_bRunning == true then return end

	if self.m_nTempCurTab == 3 then
		self.m_nTempCurTab = nil
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	else
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	end

	if CheckButtonOpen(82) ~= true then 
		GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(self.m_nCurTab - 1)
		return 
	end

	if self.m_nCurTab == 3 then return end
	self.m_nCurTab = 3
	self:cleanWnd()
	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTab4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab5",WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conTopCheck3_Sel_WndAscending", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCheckBox1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgRightBg",WZUI9Image):setVisible(true)
	self:_setCheckBoxLabelText(self.m_nCurTab)

	self:_createLoading()
	ProtocolProcessorWndAscending:send_PRAY_GetPrayMess( )

    ChangeChatChannel(Chat_Channel_WndAscending_Tab3)

	GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer):setContentSize(GlobalMethod:CCSize(320,440))
end

--@brief 	点击进化标签回调
function WndAscending:onTab4()
	if self.m_bRunning == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if CheckButtonOpen(86) ~= true then 
		GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(self.m_nCurTab - 1)
		return 
	end

	if self.m_nCurTab == 4 then return end
	self.m_nCurTab = 4
	self:cleanWnd()
	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab4",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTab5",WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conTopCheck3_Sel_WndAscending", WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull2",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgRightBg",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer):setContentSize(GlobalMethod:CCSize(320,362))
	self:_setCheckBoxLabelText(self.m_nCurTab)

    --ChangeChatChannel(Chat_Channel_WndAscending_Tab3)
	--刷新宠物列表
	if CacheCenter:getPlayerPetInfo() ~= nil and #CacheCenter:getPlayerPetInfo() > 0 then
		self:updatePetList()
	else
  		WndPets.m_nLoadingId = MsgBoxManager:showLoadingBox()
		ProtocolProcessorScenePets:send_PET_GetAllPetList()
	end
	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setText(string.format(LocalStrings.ASCENDING25,
		self.evoOrangePetNeedAdLevel,self.evoOrangePetNeedPetLevel))
end

function WndAscending:onTab5()
	WZLog("WndAscending:onTab5")
	if self.m_bRunning == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if CheckButtonOpen(91) ~= true then 
		GetElement(self.m_root, "checkGroup", WZUICheckBoxGroup):setCheckIndex(self.m_nCurTab - 1)
		return 
	end

	if self.m_nCurTab == 5 then return end
	self.m_nCurTab = 5
	self:cleanWnd()
	GetElement(self.m_root,"conTab1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab3",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTab5",WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conTopCheck3_Sel_WndAscending", WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conCheckBox1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(true)
	GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull2",WZUIContainer):setVisible(false)
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgRightBg",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer):setContentSize(GlobalMethod:CCSize(320,362))
	self:_setCheckBoxLabelText(self.m_nCurTab)

	--刷新坐骑列表
	self:updateMountList()
end

--@brief	是否保留强化升星信息
function WndAscending:retention()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkBox = GetElement(self.m_root,"retention",WZUICheckBox)
	if checkBox:getCheckIndex() == 1 then
		self.m_bChecked = false
	else
		self.m_bChecked = true
	end
	local tAfter = self:getAfterData(self.m_tEquipBefore)
	self:showEquipAfterAscending(tAfter)
end

--@brief    装备栏中装备cell被点击时调用
function WndAscending:equipListCellClicked(tEquip, tCell)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--设置选中标志
	if self.m_tSelectedCell ~= nil then
		self.m_tSelectedCell:setHighLight(false)
	end
	self.m_tSelectedCell = tCell
	tCell:setHighLight(true)
    --添加或替换装备
	if self.m_nCurTab == 1 then
    	self:_addEquipToCell(tEquip)
	elseif self.m_nCurTab == 2 then
    	self:_addEquipToCell2(tEquip)
	end
end

--@brief	获得升阶后的装备数据表
function WndAscending:getAfterData(tEquip)
	local tAfter = CopyTable(tEquip)
	tAfter.basicInfo = CopyTable(GDatatab_item["id_"..self.m_tAscending.items[1][1]])
	--if tAfter.extraInfo ~= nil then
	--	tAfter.extraInfo.hpStone = 0
	--	tAfter.extraInfo.attackStone = 0
	--	tAfter.extraInfo.defendStone = 0
	--end
	--是否保留强化等级
	local cost = 0
	local costId = 70
	if self.m_bChecked == true then
		for k,v in pairs(GDatatab_item_advanced_keep_level) do
			if v.type == 1 and v.pinzhi == 2 and v.old_level == tEquip.extraInfo.strongLevel then
				tAfter.extraInfo.strongLevel = tEquip.extraInfo.strongLevel
				cost = cost + v.cost[1][2] 
				costId = v.cost[1][1]
			end
			if v.type == 2 and v.pinzhi == 2 and v.old_level == tEquip.extraInfo.starLevel then
				tAfter.extraInfo.starLevel = tEquip.extraInfo.starLevel
				cost = cost + v.cost[1][2]
				costId = v.cost[1][1]
			end
		end
	else
		if tEquip.basicInfo.quality == 2 then
			tAfter.extraInfo.strongLevel = 0
			tAfter.extraInfo.starLevel = 0
			for k,v in pairs(GDatatab_item_advanced_keep_level) do
				if v.type == 1 and v.pinzhi == 2 and v.old_level == tEquip.extraInfo.strongLevel then
					tAfter.extraInfo.strongLevel = v.new_level
					cost = cost + v.cost[1][2]
					costId = v.cost[1][1]
				end
				if v.type == 2 and v.pinzhi == 2 and v.old_level == tEquip.extraInfo.starLevel then
					tAfter.extraInfo.starLevel = v.new_level
					cost = cost + v.cost[1][2]
					costId = v.cost[1][1]
				end
			end
		elseif tEquip.basicInfo.quality == 3 then
			for k,v in pairs(GDatatab_item_advanced_keep_level) do
				if v.type == 1 and v.pinzhi == 3 and v.old_level == tEquip.extraInfo.strongLevel then
					tAfter.extraInfo.strongLevel = v.new_level
				end
				if v.type == 2 and v.pinzhi == 3 and v.old_level == tEquip.extraInfo.starLevel then
					tAfter.extraInfo.starLevel = v.new_level
				end
			end
		end
	end
	self.m_nCostId = costId
	local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndAscending", WZUIImage)
	if imgCostIcon1 then
		imgCostIcon1:setFile(GDatatab_item["id_" .. costId].icon)
		imgCostIcon1:setScale(0.5)
	end
	GetElement(self.m_root,"txtCost",WZUILabelTTF):setText(cost)
	return tAfter
end

--@brief    升阶:添加装备到cell
function WndAscending:_addEquipToCell(tEquip)
    if self.m_root == nil then return end

    --添加装备到cell
    if tEquip ~= nil then
		self.m_tEquipBefore = tEquip
		WZLog("--------****888888----",Serialize(tEquip))
		for k,v in pairs(GDatatab_item_advanced) do
			if v.scrap[1][1] == self.m_tEquipBefore.basicInfo.id then
				self.m_tAscending = v
			end
		end

		self:showEquipBeforeAscending(tEquip)
		local tAfter = self:getAfterData(tEquip)
		self:showEquipAfterAscending(tAfter)
		self:showM()
		if tEquip.basicInfo.quality == 2 then
			GetElement(self.m_root,"conRetention",WZUIContainer):setVisible(true)
		elseif tEquip.basicInfo.quality == 3 then
			GetElement(self.m_root,"conRetention",WZUIContainer):setVisible(false)
		end
		self.m_bChecked = false
		GetElement(self.m_root,"retention",WZUICheckBox):setCheckIndex(0)
    else
		self:cleanWnd()
    end
end

--@brief    调品:添加装备到cell
function WndAscending:_addEquipToCell2(tEquip)
    if self.m_root == nil then return end

    --添加装备到cell
    if tEquip ~= nil then
		self.m_tEquipBefore = tEquip
	    --创建装备cell
    	local conEquip = GetElement(self.m_root,"conEquipIcon3_WndAscending",WZUIContainer)
		if conEquip:getChildByTag(100) then conEquip:removeChildByTag(100,true) end
    	local cellElement, tLua = CellGoodItem:createElement()
    	tLua:setItemClickFun(self,self.onEquipClicked)
		tLua:setCellGoodItem(tEquip, 19)
    	if cellElement ~= nil and tLua ~= nil then
    	    conEquip:addChild(cellElement, 100, 100)
    	    cellElement:setScale(0.9)
    	end

		--显示调品箱图片
		GetElement(self.m_root,"imgAdd4",WZUIImage):setFile(GDatatab_item["id_"..ORANGECHANGEGRADEMATERIAL].icon)
		--拥有调品箱数量
		local num1 = CacheCenter:getPlayerItemCountById(ORANGECHANGEGRADEMATERIAL)
		--设置调品箱数量
		GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setText(num1.."/1")
		if num1 < 1 then
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,89,74))
		else
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		end
		--显示消耗材料
		GetElement(self.m_root,"cost",WZUILabelTTF):setText(1)
		local blueprintID = blueprintIDList[self.m_tEquipBefore.basicInfo.sub_type+1]
		GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..blueprintID].icon)
		--拥有图纸数量
		GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
		self.m_nOwnM = CacheCenter:getPlayerItemCountById(blueprintID)
		--显示品级
		if tEquip.extraInfo.orangeEquiGrade ~= nil and tEquip.extraInfo.orangeEquiGrade ~= "" then
			local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade, "|")
			GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_"..grade[1]].name)
			if tonumber(grade[1]) == 5 then
				GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
			else
				GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
			end
		else
			GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_1"].name)
		end
    else
		self:cleanWnd()
    end

end

--@brief	清空界面信息
function WndAscending:cleanWnd()
	if self.m_nCurTab == 1 then
		self:removeEquipBeforeAscending()
		self:removeEquipAfterAscending()
		self:removeM()
	elseif self.m_nCurTab == 2 then
    	local con = GetElement(self.m_root,"conEquipIcon3_WndAscending",WZUIContainer)
		if con:getChildByTag(100) then con:removeChildByTag(100,true) end
		GetElement(self.m_root,"cost",WZUILabelTTF):setText(0)
	elseif self.m_nCurTab == 3 then
		self:_cleanFuseGrid()
	elseif self.m_nCurTab == 4 then
		self.m_tPet = nil
		GetElement(WndAscending.m_root,"conPet1_WndAscending",WZUIContainer):setVisible(false)
		GetElement(WndAscending.m_root,"conPet2_WndAscending",WZUIContainer):setVisible(false)
		GetElement(WndAscending.m_root,"conNoConfig",WZUIContainer):setVisible(false)
		GetElement(WndAscending.m_root,"arrowTab4",WZUIImage):setVisible(false)
		for i=1,4 do
			WndAscending:setChoosePet(i, false, "")
		end
		self:setPetCost()
	elseif self.m_nCurTab == 5 then
		self.m_tMount = nil
		self:removeLeftMount()
		self:removeRightMount()
		self:removeMountM()
	end

	local conMidRight = GetElement(self.m_root, "conMidRight_WndAscending", WZUIContainer)
	if conMidRight then
		removeShowPanelNullTip(conMidRight)
	end

	self.m_tEquipBefore = nil
	if self.m_tSelectedCell ~= nil then self.m_tSelectedCell:setHighLight(false) end
	self.m_bChecked = false
	GetElement(self.m_root,"retention",WZUICheckBox):setCheckIndex(0)
	GetElement(self.m_root,"conRetention",WZUIContainer):setVisible(false)
end

--@brief	显示制作前装备信息
function WndAscending:showEquipBeforeAscending(tEquip)
	if tEquip == nil then return end
	--强化等级
	GetElement(self.m_root,"txtStrongLv1",WZUILabelTTF):setText(LocalStrings.LV..tEquip.extraInfo.strongLevel)
	--升星等级
	GetElement(self.m_root,"txtStarLv1",WZUILabelTTF):setText(tEquip.extraInfo.starLevel)
	GetElement(self.m_root,"star1_WndAscending",WZUIImage):setVisible(true)
	--属性
    local property = tEquip.basicInfo.property
    if property[1] ~= nil then
		local curAttr = tEquip.extraInfo[tostring(property[1][1])]
		GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF):setText(ATTR_TITLE[property[1][1]])
		GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF):setText("+"..curAttr)
	end
	--武器显示范围大招
	if tEquip.basicInfo.sub_type == 0 or tEquip.basicInfo.sub_type == 1 then
		GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF):setText(LocalStrings.RANGE)
		GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF):setText(LocalStrings.SKAT)
		GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setText(property[2][2])
		local value = tEquip.basicInfo.value
		local skillInfo = GDatatab_skill["id_"..value]
		GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF):setText(skillInfo.name)
	else
		GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF):setText("")
	end
	
    --创建装备cell
    local conEquip = GetElement(self.m_root,"conEquipIcon1_WndAscending",WZUIContainer)
	if conEquip:getChildByTag(100) then conEquip:removeChildByTag(100,true) end
    local cellElement, tLua = CellGoodItem:createElement()
    tLua:setItemClickFun(self,self.onEquipClicked)
	tLua:setCellGoodItem(tEquip, 19)
    if cellElement ~= nil and tLua ~= nil then
        conEquip:addChild(cellElement, 100, 100)
        cellElement:setScale(0.9)
    end
end

--@brief	移除制作前装备信息
function WndAscending:removeEquipBeforeAscending()
    local con = GetElement(self.m_root,"conEquipIcon1_WndAscending",WZUIContainer)
	if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	GetElement(self.m_root,"txtStrongLv1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtStarLv1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"star1_WndAscending",WZUIImage):setVisible(false)
	GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF):setText("")
end

--@brief	显示制作后装备信息
function WndAscending:showEquipAfterAscending(tEquip)
	if tEquip == nil then return end
	--强化等级
	GetElement(self.m_root,"txtStrongLv2",WZUILabelTTF):setText(LocalStrings.LV..tEquip.extraInfo.strongLevel)
	--升星等级
	GetElement(self.m_root,"txtStarLv2",WZUILabelTTF):setText(tEquip.extraInfo.starLevel)
	GetElement(self.m_root,"star2_WndAscending",WZUIImage):setVisible(true)
	--属性
    local property = tEquip.basicInfo.property
   	local equality = tEquip.basicInfo.quality
	local strongLevel = tEquip.extraInfo.strongLevel 
    local starLevel = tEquip.extraInfo.starLevel
	local starAddAttr = 0
	local baseAttr = property[1][2] + WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[1][1]).attrAdd
	if tonumber(starLevel) ~= 0 then
    	starAddAttr = math.ceil(baseAttr * (WndImproveStrengthen:getStarsUpTable(starLevel, equality).property_rate/10000))
	end
    if property[1] ~= nil then
		GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF):setText(ATTR_TITLE[property[1][1]])
		GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF):setText("+"..(baseAttr+starAddAttr))
	end
	tEquip.extraInfo[tostring(property[1][1])] = baseAttr+starAddAttr
	--武器显示范围大招
	if tEquip.basicInfo.sub_type == 0 or tEquip.basicInfo.sub_type == 1 then
		GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF):setText(LocalStrings.RANGE)
		GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF):setText(LocalStrings.SKAT)
		GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setText(property[2][2])
		local value = tEquip.basicInfo.value
		local skillInfo = GDatatab_skill["id_"..value]
		GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF):setText(skillInfo.name)
	else
		GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF):setText("")
	end
	
    --创建装备cell
    local conEquip = GetElement(self.m_root,"conEquipIcon2_WndAscending",WZUIContainer)
	if conEquip:getChildByTag(100) then conEquip:removeChildByTag(100,true) end
    local cellElement, tLua = CellGoodItem:createElement()
	tLua:setCellGoodItem(tEquip, 19)
   	tLua:setItemClickFun(self,self.onEquipClicked)
    if cellElement ~= nil and tLua ~= nil then
        conEquip:addChild(cellElement, 100, 100)
        cellElement:setScale(0.9)
    end
end

--@brief	移除制作后装备信息
function WndAscending:removeEquipAfterAscending()
    local con = GetElement(self.m_root,"conEquipIcon2_WndAscending",WZUIContainer)
	if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	GetElement(self.m_root,"txtStrongLv2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtStarLv2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"star2_WndAscending",WZUIImage):setVisible(false)
	GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF):setText("")
end

--@brief	显示材料
function WndAscending:showM()
	if self.m_tAscending == nil then return end
	self.m_tNeedM = {}
	self.m_tOwnM = {}
	self.m_tMId = {}
	local tData = self.m_tAscending
	local scrap = tData.scrap
	local id = {scrap[2][1],scrap[3][1],scrap[4][1],scrap[5][1]}
	local vnNum = {}
	for i=1,4 do
		self.m_tNeedM[i] = scrap[i+1][2]
		self.m_tOwnM[i] = CacheCenter:getPlayerItemCountById(scrap[i+1][1])
		self.m_tMId[i] = id[i]
		vnNum[i] = tostring(self.m_tOwnM[i]).."/"..self.m_tNeedM[i]
	end
	for i=1,4 do
		local tData = GDatatab_item["id_"..id[i]]
        local name = tData.name
        local path = tData.icon
        local num =  vnNum[i]
        local quality = tData.quality
        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}
    	local con = GetElement(self.m_root,"conM"..i,WZUIContainer)
		if con:getChildByTag(100) then con:removeChildByTag(100,true) end
    	local cellElement, tLua = CellGoodItem:createElement()
		tLua:setCellGoodItem(itemInfo, 4)
    	tLua:setItemClickFun(self,self.onMClicked)
		if tonumber(self.m_tOwnM[i]) < tonumber(self.m_tNeedM[i]) then
		tLua:setNumColor(GlobalMethod:ccc3(255,89,74),	GlobalMethod:ccc3(158,0,0))
		end
    	if cellElement ~= nil and tLua ~= nil then
    	    con:addChild(cellElement, 100, 100)
    	    cellElement:setScale(1)
    	end
	end
end

--@brief	移除材料
function WndAscending:removeM()
	WZLog("WndAscending:removeM")
	for i=1,4 do
    	local con = GetElement(self.m_root,"conM"..i,WZUIContainer)
		if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	end
end

--@brief	点击装备
function WndAscending:onEquipClicked(tLua, tag, tData)
	WZLog("WndAscending:onEquipClicked")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(tLua.m_root, GetElement(self.m_root,"conMid",WZUIContainer), 1, tData, false)
end

--@brief	点击材料
function WndAscending:onMClicked(tLua, tag, tData)
	WZLog("WndAscending:onMClicked")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	tData.tBtnList = {LocalStrings.GET}
    WndItemInfo:showInfo(tLua.m_root, GetElement(self.m_root,"conMid",WZUIContainer), 1, tData, true)
	WndItemInfo:setClickButtonCallback(self,self.getM)
    ChangeChatChannel(Chat_Channel_WndAscending_Tab1)
end

--@brief	获得材料
function WndAscending:getM(tag, tData)
	WZLog("WndAscending:getM")
	WndFastGetItems:show(tData.basicInfo.id)
end

--@brief	点击调品箱
function WndAscending:onTip1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local node = GetElement(self.m_root,"imgAdd4",WZUIImage)
	local tData = GDatatab_item["id_"..ORANGECHANGEGRADEMATERIAL]
    local name = tData.name
    local path = tData.icon
    local quality = tData.quality
    local itemInfo = {name=name,icon=path,quality=quality,basicInfo=CopyTable(tData)}
	itemInfo.tBtnList = {LocalStrings.GET}
    WndItemInfo:showInfo(node, GetElement(self.m_root,"conMid",WZUIContainer), 1, itemInfo, false)
	WndItemInfo:setClickButtonCallback(self,self.getM)
    ChangeChatChannel(Chat_Channel_WndAscending_Tab2)
end

--@brief 	点击祝福弹的tips按钮回调
function WndAscending:onClickBless()
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndBless:showInterface()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化装备列表
--@param    checkBoxTag:装备分类标签:1全部，2蓝装，3紫装
--@param    bDontReet:默认为false,重新刷新列表位置，true:列表保持当前的位置不变
--@param 	nFuseIndex:针对融合界面，为1时候，根据列表内容判断是显示未融合还是以融合标签
--@note     显示强化升星等级满足要求的装备
function WndAscending:_initEquipListByTag(bDontReset, nFuseIndex)
	if self.m_root == nil then return end
    self.m_bDontResetListY = bDontReset or false
    local checkBoxTag = self.m_nRightTab or 1 --装备分类标志

    if self.m_nCurTab == 3 then --融合
    	local tTempList = {}
    	tTempList.tNotFusedList = {}
    	tTempList.tHavedFusedList = {}
    	for i, value in pairs(GDatatab_itemmerge) do
    		if value.merge_type == 3 then
    			local bHavedFused, level = self:_checkBlessExist(value.items[1][1])
    			local tItem = {}
    			tItem.mergeInfo = CopyTable(value)
    			tItem.prayInfo = self:_getPrayInfo(value.items[1][1], level)
    			tItem.basicInfo = CopyTable(GDatatab_item["id_" .. value.items[1][1]])
    			tItem.nHavedNum = self:_getCanFuseNum(value.scrap)
    			tItem.nNeededNum = #value.scrap
				if not bHavedFused then
					table.insert(tTempList.tNotFusedList, tItem)
				else
					table.insert(tTempList.tHavedFusedList, tItem)
				end
    		end
    	end

    	if nFuseIndex == 1 then
    		if #tTempList.tNotFusedList > 0 then
    			checkBoxTag = 1 
    			self.m_nRightTab = checkBoxTag 
    		else
    			checkBoxTag = 2 
    			self.m_nRightTab = checkBoxTag 
    		end
    		GetElement(self.m_root,"checkGruopEquipClassify_WndStrengthen", WZUICheckBoxGroup):setCheckIndex(checkBoxTag - 1)
    		for i=1,3 do
				GetElement(self.m_root,"conCheck"..i,WZUIContainer):setVisible(false)
			end
			GetElement(self.m_root,"conCheck"..self.m_nRightTab,WZUIContainer):setVisible(true)
    	end
    	if nFuseIndex ~= 2 then
    		self:_setBottomInfo(false)
    	end

    	GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conNull2",WZUIContainer):setVisible(false)

		if checkBoxTag == 1 then
	    	table.sort(tTempList.tNotFusedList, sortFuseBless)
	    	self:_loadFuseList(tTempList.tNotFusedList)
	    else
	    	table.sort(tTempList.tHavedFusedList, sortFuseBless)
	    	self:_loadFuseList(tTempList.tHavedFusedList)
	    end
	elseif self.m_nCurTab == 5 then
		self:updateMountList()
    else
	    if CacheCenter:hasPlayerItems() then
	        --local tEquipItems = CopyTable(CacheCenter:getEquipList())
	        local tEquipItems = CacheCenter:getEquipList()
	        --遍历装备table找出与equipType对应的装备
	        local t = {}
	        for i,v in pairs(tEquipItems) do
				v.hightlight = false

				local notTimeLimit = (v.basicInfo.time_limit == -1)

				if notTimeLimit then

				if self.m_nCurTab == 1 then
					local condition1 = v.extraInfo.strongLevel ~= nil and v.extraInfo.strongLevel >= LANASCENDINGSTRONG and v.extraInfo.starLevel ~= nil and v.extraInfo.starLevel >= LANASCENDINGSTAR and v.basicInfo.quality == 2
					local condition2 = v.extraInfo.strongLevel ~= nil and v.extraInfo.strongLevel >= ZIASCENDINGSTRONG and v.extraInfo.starLevel ~= nil and v.extraInfo.starLevel >= ZIASCENDINGSTAR and v.basicInfo.quality == 3
					if checkBoxTag == 1 and (condition1 or condition2) then
	            	    table.insert(t,v)
					elseif checkBoxTag == 2 and condition1 then
	            	    table.insert(t,v)
					elseif checkBoxTag == 3 and condition2 then
	            	    table.insert(t,v)
					end
				elseif self.m_nCurTab == 2 then
					if v.basicInfo.quality == 4 then
	            	    table.insert(t,v)
					end
				end

				end
	        end
	        table.sort(t, _sortAscendingEquip)
	        --获取table节点
	        local tbconEquip = GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer)
	        self.m_nConListPositionY = tbconEquip:getMoveElement():getPositionY()
			tbconEquip:removeAll()
			GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conNull2",WZUIContainer):setVisible(false)
	        if tbconEquip == nil then return end
	        self.m_nCurLoadEquipIndex = 1
	        self.m_tEquipList = t
	        tbconEquip:enableSchedule("_loadEquip")
	    end
	end
end


--
function WndAscending:rtnSortNum(a)
	-- body
	if a.nHavedNum >= a.nNeededNum then
		return 2
	else
		return 1
	end
end

--@brief 	对橙色祝福排序
function sortFuseBless(a, b)
	-- body
	local nSortNumA = WndAscending:rtnSortNum(a)
	local nSortNumB = WndAscending:rtnSortNum(b)
	if nSortNumA ~= nSortNumB then
		return nSortNumA > nSortNumB 
	else
		return a.mergeInfo.id < b.mergeInfo.id
	end
end

--@brief    加载装备
function WndAscending:_loadEquip(element, delta)
    local element = GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer)
    if self.m_tEquipList == nil then
        element:disableSchedule()
        return 
    end
    --加载完成
    if self.m_nCurLoadEquipIndex > #self.m_tEquipList then
        WZLog("******* WndAscending:_loadEquip *******", self.m_bDontResetListY, self.m_nConListPositionY)
        if self.m_bDontResetListY then
            element:getMoveElement():setPositionY(self.m_nConListPositionY)
        else
            element:getMoveElement():setPositionY(element:getMinPosition().y)
        end
        element:disableSchedule()

		if self.m_nCurLoadEquipIndex == 1 then
			if self.m_nCurTab == 1 then
				GetElement(self.m_root,"conNull",WZUIContainer):setVisible(true)
			elseif self.m_nCurTab == 2 then
				GetElement(self.m_root,"conNull2",WZUIContainer):setVisible(true)
			end
		end
        return
    end

    local cellElement,cellObj = CellStrengthenEquip:createElement()
    cellElement:setTag(self.m_nCurLoadEquipIndex-1)
    cellElement = WZUIContainer:luaTo(cellElement)
    element:pushBack(cellElement)
    element:setContentSize(GlobalMethod:CCSize(311,98))
    element:setRelativeSize(GlobalMethod:CCSize(1,98/440))
    cellObj:initCellData(self.m_tEquipList[self.m_nCurLoadEquipIndex])
	GetElement(cellElement,"btn_CellStrengthenEquip",WZUIButton):setLuaDoneFunctionName("onCellClickedAscending")

    element:getMoveElement():setPositionY(element:getMinPosition().y)

    self.m_nCurLoadEquipIndex = self.m_nCurLoadEquipIndex + 1
end

--@brief 	加载融合列表
function WndAscending:_loadFuseList(tFuseList)
	-- body
	local flEquipList = GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer)
	flEquipList:removeAll()

	local conMidRight = GetElement(self.m_root, "conMidRight_WndAscending", WZUIContainer)
	if tFuseList == nil or #tFuseList == 0 then 
		if conMidRight then
			removeShowPanelNullTip(conMidRight)
			if self.m_nRightTab == 1 then
				if ProjConfig.LANGUAGE == "tr" then
					ShowPanelNullTip( conMidRight, LocalStrings.ASCENDING_FUSE8,nil,nil,nil,nil,2)
				else
					ShowPanelNullTip( conMidRight, LocalStrings.ASCENDING_FUSE8)
				end
			else
				if ProjConfig.LANGUAGE == "tr" then
					ShowPanelNullTip( conMidRight, LocalStrings.ASCENDING_FUSE9,nil,nil,nil,nil,2)
				else
					ShowPanelNullTip( conMidRight, LocalStrings.ASCENDING_FUSE9)
				end
			end
		end
		return 
	end

	removeShowPanelNullTip(conMidRight)

	self.m_tFuseCellList = {}
	WZLog("WndAscending:_loadFuseList", #tFuseList)
	for i = 1, #tFuseList do
		local cellElement,cellObj = CellFuseBlessList:createElement()
	    cellElement:setTag(i - 1)
	    cellElement = WZUIContainer:luaTo(cellElement)
	    cellObj:setData(tFuseList[i], self.m_nRightTab)
	    cellObj:setCallBackFunc(self, self.onCellClicked)

	    flEquipList:pushBack(cellElement)

	    table.insert(self.m_tFuseCellList, cellObj)
	end

	flEquipList:getMoveElement():setPositionY(flEquipList:getMinPosition().y)
end

--@brief 	设置右边标签栏标签的显示内容
--@param 	nIndex:1->制作；2->调品；3->融合
function WndAscending:_setCheckBoxLabelText(nIndex)
	-- body
	WZLog("WndAscending:_setCheckBoxLabelText", nIndex)
	local txtCheckBox1 = GetElement(self.m_root, "txtCheckBox1_WndAscending", WZUILabelTTF)
	local txtCheckBox2 = GetElement(self.m_root, "txtCheckBox2_WndAscending", WZUILabelTTF)
	local txtCheckBox3 = GetElement(self.m_root, "txtCheckBox3_WndAscending", WZUILabelTTF)
	local txtCheckBox4 = GetElement(self.m_root, "txtCheckBox4_WndAscending", WZUILabelTTF)

	local txtCheckBoxSel1 = GetElement(self.m_root, "txtCheckBoxSel1_WndAscending", WZUILabelTTF)
	local txtCheckBoxSel2 = GetElement(self.m_root, "txtCheckBoxSel2_WndAscending", WZUILabelTTF)
	local txtCheckBoxSel3 = GetElement(self.m_root, "txtCheckBoxSel3_WndAscending", WZUILabelTTF)
	local txtCheckBoxSel4 = GetElement(self.m_root, "txtCheckBoxSel4_WndAscending", WZUILabelTTF)

	local checkTreasure = GetElement(self.m_root, "checkTreasure_WndStrengthen", WZUICheckBox)
	local txtMyEquipWord = GetElement(self.m_root, "txtMyEquipWord_WndAscending", WZUILabelTTF)
	local txtFeed = GetElement(self.m_root,"txtFeed",WZUILabelTTF)
	if nIndex == 1 then --制作
		txtCheckBox1:setText(LocalStrings.CHAT_ALL)
		txtCheckBox2:setText(LocalStrings.ASCENDING7)
		txtCheckBox3:setText(LocalStrings.PURPLE)

		txtCheckBoxSel1:setText(LocalStrings.CHAT_ALL)
		txtCheckBoxSel2:setText(LocalStrings.ASCENDING7)
		txtCheckBoxSel3:setText(LocalStrings.PURPLE)

		if ProjConfig.LANGUAGE == "en" then
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)

			txtCheckBoxSel2:setScale(0.6)
			txtCheckBox2:setScale(0.6)
		elseif ProjConfig.LANGUAGE == "tr" then
			txtCheckBox1:setScale(0.7)
			txtCheckBoxSel1:setScale(0.7)
			txtCheckBoxSel2:setScale(0.7)
			txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBox2:setScale(0.7)
			txtCheckBox2:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBox3:setScale(0.7)
			txtCheckBoxSel3:setScale(0.7)
		elseif ProjConfig.LANGUAGE == "vn" then
			txtCheckBox1:setScale(0.9)
			txtCheckBoxSel1:setScale(0.9)
			txtCheckBox2:setScale(0.9)
			txtCheckBoxSel2:setScale(0.9)
			txtCheckBox3:setScale(0.9)
			txtCheckBoxSel3:setScale(0.9)
		elseif ProjConfig.LANGUAGE == "pt" then
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
		elseif ProjConfig.LANGUAGE == "es" then
			txtCheckBoxSel2:setScale(0.6)
			txtCheckBox2:setScale(0.6)
		end
	--	GetElement(self.m_root, "checkGruopEquipClassify_WndStrengthen", WZUICheckBoxGroup):setCheckIndex(self.m_nRightTab - 1)
		checkTreasure:setVisible(true)
		GetElement(self.m_root,"check4_WndStrengthen",WZUICheckBox):setVisible(false)
		txtMyEquipWord:setText(LocalStrings.EQUIPMENT)
	elseif nIndex == 2 then --调品
		txtMyEquipWord:setText(LocalStrings.EQUIPMENT)
	elseif nIndex == 3 then --融合
		txtCheckBox1:setText(LocalStrings.ASCENDING_FUSE3)
		txtCheckBox2:setText(LocalStrings.ASCENDING_FUSE4)

		txtCheckBoxSel1:setText(LocalStrings.ASCENDING_FUSE3)
		txtCheckBoxSel2:setText(LocalStrings.ASCENDING_FUSE4)

		if ProjConfig.LANGUAGE == "en" then
			txtCheckBox1:setScale(0.56)
			txtCheckBoxSel1:setScale(0.6)

			txtCheckBoxSel2:setScale(0.6)
			txtCheckBox2:setScale(0.6)
		elseif ProjConfig.LANGUAGE == "th" then
			txtCheckBox1:setScale(0.8)
			txtCheckBoxSel1:setScale(0.8)
			txtCheckBoxSel2:setScale(1)
			txtCheckBox2:setScale(1)
		elseif ProjConfig.LANGUAGE == "pt" then
			txtCheckBox1:setScale(0.7)
			txtCheckBox1:setDimensions(GlobalMethod:CCSize(80,0))

			txtCheckBoxSel1:setScale(0.7)
			txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(80,0))

			txtCheckBoxSel2:setScale(0.65)
			txtCheckBox2:setScale(0.65)
		elseif ProjConfig.LANGUAGE == "vn" then
			txtCheckBox1:setScale(0.7)
			txtCheckBoxSel1:setScale(0.7)
			txtCheckBox2:setScale(0.8)
			txtCheckBoxSel2:setScale(0.8)
		elseif ProjConfig.LANGUAGE =="es" then
			txtCheckBox1:setScale(0.65)
			txtCheckBox1:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBoxSel1:setScale(0.65)
			txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBox2:setScale(0.62)
			txtCheckBoxSel2:setScale(0.62)
		elseif ProjConfig.LANGUAGE =="tr" then
			txtCheckBox1:setScale(0.55)
			txtCheckBox1:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBoxSel1:setScale(0.55)
			txtCheckBoxSel1:setDimensions(GlobalMethod:CCSize(80,0))
			txtCheckBox2:setScale(0.6)
			txtCheckBoxSel2:setScale(0.6)
		end

		checkTreasure:setVisible(false)
		txtMyEquipWord:setText(LocalStrings.ASCENDING_FUSE6)
	elseif nIndex == 4 then
		txtMyEquipWord:setText(LocalStrings.MY_PETS)
		txtFeed:setText(LocalStrings.ASCENDING31)
		if ProjConfig.LANGUAGE == "en" then
			txtFeed:setDimensions(GlobalMethod:CCSize(100,0))
			txtFeed:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "vn" then
			txtFeed:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "pt" then
			txtFeed:setDimensions(GlobalMethod:CCSize(0,0))
			txtFeed:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "es" then
			txtFeed:setDimensions(GlobalMethod:CCSize(130,0))
			txtFeed:setScale(0.7)
		elseif ProjConfig.LANGUAGE == "tr" then
			txtFeed:setScale(0.7)
		end
	elseif nIndex == 5 then
		txtMyEquipWord:setText(LocalStrings.ASCENDING45)
		checkTreasure:setVisible(true)

		txtCheckBox1:setText(LocalStrings.CHAT_ALL)
		txtCheckBox2:setText(LocalStrings.ASCENDING38)
		txtCheckBox3:setText(LocalStrings.ASCENDING39)
		txtCheckBox4:setText(LocalStrings.ASCENDING40)

		txtCheckBoxSel1:setText(LocalStrings.CHAT_ALL)
		txtCheckBoxSel2:setText(LocalStrings.ASCENDING38)
		txtCheckBoxSel3:setText(LocalStrings.ASCENDING39)
		txtCheckBoxSel4:setText(LocalStrings.ASCENDING40)

	    self.m_nRightTab = 1
		GetElement(self.m_root, "checkGruopEquipClassify_WndStrengthen", WZUICheckBoxGroup):setCheckIndex(0)
		GetElement(self.m_root,"conCheck1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conCheck2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conCheck3",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conCheck4",WZUIContainer):setVisible(false)
		txtFeed:setText(LocalStrings.ASCENDING46)
		if ProjConfig.LANGUAGE == "en" then
			txtFeed:setDimensions(GlobalMethod:CCSize(100,0))
			txtFeed:setScale(0.8)
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
		elseif ProjConfig.LANGUAGE == "th" then
			txtFeed:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "vn" then
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
			txtFeed:setScale(0.8)
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
		elseif ProjConfig.LANGUAGE == "pt" then
			txtFeed:setDimensions(GlobalMethod:CCSize(100,0))
			txtFeed:setScale(0.8)
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
		elseif ProjConfig.LANGUAGE == "es" then
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
			txtFeed:setDimensions(GlobalMethod:CCSize(100,0))
			txtFeed:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "tr" then
			txtCheckBox1:setScale(1)
			txtCheckBoxSel1:setScale(1)
			txtCheckBox2:setScale(1)
			txtCheckBoxSel2:setScale(1)
			txtCheckBox3:setScale(1)
			txtCheckBoxSel3:setScale(1)
			txtCheckBox4:setScale(1)
			txtCheckBoxSel4:setScale(1)
			txtFeed:setScale(0.7)
		end
	end
end

--@brief 	清理融合格子内容
function WndAscending:_cleanFuseGrid()
	-- body
	self.m_tSelectedData = nil 
	
	local conLeftBless = GetElement(self.m_root, "conLeftBless_WndAscending", WZUIContainer)
	if conLeftBless then
		conLeftBless:removeAllChildrenWithCleanup(true)
	end
	local conRightBless = GetElement(self.m_root, "conRightBless_WndAscending", WZUIContainer)
	if conRightBless then
		conRightBless:removeAllChildrenWithCleanup(true)
	end
	local conFuseBless = GetElement(self.m_root, "conFuseBless_WndAscending", WZUIContainer)
	if conFuseBless then
		conFuseBless:removeAllChildrenWithCleanup(true)
	end
end

--@brief 	给融合格子装备祝福
function WndAscending:_takeonBless(tData)
	-- body
	self.m_tBeFusedId = {}
	local tMergeInfo = tData.mergeInfo
	local conMid = GetElement(self.m_root, "conMid", WZUIContainer)
	local conLeftBless = GetElement(self.m_root, "conLeftBless_WndAscending", WZUIContainer)
	if conLeftBless then
		conLeftBless:removeAllChildrenWithCleanup(true)
		local cellElement, tNewObj = CellBlessItem:createElement()
	    if cellElement and tNewObj then
	        conLeftBless:addChild(cellElement)
	        tNewObj:setCallBackFun(self, self.onClickBless)
	        local nType, tTempData = self:_getFuseBlessData(tMergeInfo.scrap[1][1])
	        table.insert(self.m_tBeFusedId, tTempData.blessId)
	        if nType == 1 then
	        	tTempData.bHaveBtn = false
	        else
	        	tTempData.bHaveBtn = true
	        end
	        tNewObj:setData(tTempData, 9, conMid)
	        cellElement:setScale(0.75)
	        if self.m_nRightTab == 1 then
	        	self:_createAttLabel(nType, conLeftBless, nil, self:_getMaxLevel(tTempData.item_id))
	        end
	    end
	end

	local conRightBless = GetElement(self.m_root, "conRightBless_WndAscending", WZUIContainer)
	if conRightBless then
		conRightBless:removeAllChildrenWithCleanup(true)
		local cellElement, tNewObj = CellBlessItem:createElement()
	    if cellElement and tNewObj then
	        conRightBless:addChild(cellElement)
	        tNewObj:setCallBackFun(self, self.onClickBless)
	        local nType, tTempData = self:_getFuseBlessData(tMergeInfo.scrap[2][1])
	        table.insert(self.m_tBeFusedId, tTempData.blessId)
	        if nType == 1 then
	        	tTempData.bHaveBtn = false
	        else
	        	tTempData.bHaveBtn = true
	        end
	        tNewObj:setData(tTempData, 9, conMid)
	        cellElement:setScale(0.75)
	        if self.m_nRightTab == 1 then
	        	self:_createAttLabel(nType, conRightBless, nil, self:_getMaxLevel(tTempData.item_id))
	        end
	    end
	end

	local conFuseBless = GetElement(self.m_root, "conFuseBless_WndAscending", WZUIContainer)
	if conFuseBless then
		conFuseBless:removeAllChildrenWithCleanup(true)
		local cellElement, tNewObj = CellBlessItem:createElement()
	    if cellElement and tNewObj then
	        conFuseBless:addChild(cellElement)
	        tNewObj:setCallBackFun(self, self.onClickBless)
	        local nType, tTempData = self:_getFuseBlessData(tMergeInfo.items[1][1], 1)
	        tTempData.bHaveBtn = false
	        tNewObj:setData(tTempData, 10, conMid)

	        self:_createAttLabel(4, conFuseBless, tTempData.property)
	    end
	end

	--消耗
	self:_updateFuseCostNum(tData)
end

--@brief 	刷新消耗
function WndAscending:_updateFuseCostNum(tData)
	-- body
	if tData == nil then return end 

	local ftxtCost = GetElement(self.m_root, "ftxtCost_ConTab3", WZUIFreeTextBox)
	local tCost = tData.mergeInfo.cost
	if ftxtCost then
		ftxtCost:setVisible(true)
		if self.m_nRightTab == 1 then
			local sContent = string.format(LocalStrings.ASCENDING_FUSE13, LocalStrings.CONSUME, GDatatab_item["id_" .. tCost[1][1]].icon, tCost[1][2], CacheCenter:getPlayerItemCountById(tCost[1][1]), GDatatab_item["id_" .. tCost[2][1]].icon, tCost[2][2], CacheCenter:getPlayerItemCountById(tCost[2][1]))
			ftxtCost:setShowText(sContent)
		else
			ftxtCost:setShowText(LocalStrings.ASCENDING_FUSE7)
		end
	end
end

--@brief 	设置按钮和底部的提示语
function WndAscending:_setBottomInfo(isBtnVisible)
	-- body
	local btnFuse = GetElement(self.m_root, "btnFuse_WndAscending", WZUIButton)
	if btnFuse then
		btnFuse:setVisible(isBtnVisible)
	end

	local ftxtCost = GetElement(self.m_root, "ftxtCost_ConTab3", WZUIFreeTextBox)
	if ftxtCost then
		if isBtnVisible then
			ftxtCost:setVisible(true)
			ftxtCost:setRelativePosition(GlobalMethod:ccp(0.5, 0.73))
		else
			ftxtCost:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
			if self.m_tSelectedData == nil then 
				self:_cleanFuseGrid()
				if self.m_nRightTab == 1 then
					ftxtCost:setVisible(true)
					ftxtCost:setShowText(LocalStrings.ASCENDING_FUSE2)
				else
					ftxtCost:setVisible(false)
					ftxtCost:setShowText(LocalStrings.ASCENDING_FUSE7)
				end
			else
				if self.m_nRightTab == 1 then
					ftxtCost:setVisible(true)
				else
					self:_cleanFuseGrid()
					ftxtCost:setVisible(false)
					ftxtCost:setShowText(LocalStrings.ASCENDING_FUSE7)
				end
			end 
		end
	end
end

--@brief 	创建祝福是否满足条件提示
function WndAscending:_createAttLabel(nType, parentNode, tProperty, maxLevel)
	-- body
	if nType == 4 then
		local sFormat = [[<T C="255,227,116" S="18" P="1" SE="1" SC="79,60,48" SS="4">%s</T><T C="99,255,95" S="18" P="1" SE="1" SC="79,60,48" SS="4">+%d</T>]]
		local ftTempLabel = WZUIFreeTextBox:create()
		ftTempLabel:setUseAbsSize(true)
		ftTempLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		ftTempLabel:setRelativePosition(GlobalMethod:ccp(0.1, -0.41))
		ftTempLabel:setMaxWidth(200)
		ftTempLabel:setShowText(string.format(sFormat, ATTR_TITLE[tProperty[1][1]], tProperty[1][2]))
		parentNode:addChild(ftTempLabel)

		local ftTempLabel2 = WZUIFreeTextBox:create()
		ftTempLabel2:setUseAbsSize(true)
		ftTempLabel2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		ftTempLabel2:setRelativePosition(GlobalMethod:ccp(0.1, -0.66))
		ftTempLabel2:setMaxWidth(200)
		ftTempLabel2:setShowText(string.format(sFormat, ATTR_TITLE[tProperty[2][1]], tProperty[2][2]))
		parentNode:addChild(ftTempLabel2)

		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
			ftTempLabel:setScale(0.8)
			ftTempLabel2:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "es" then
			ftTempLabel:setScale(0.66)
			ftTempLabel:setMaxWidth(300)
			ftTempLabel2:setScale(0.66)
			ftTempLabel2:setMaxWidth(300)
		end
	else
		local tempLabel = WZUILabelTTF:create()
		tempLabel:setFontSize(18)

		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			tempLabel:setFontSize(16)
		end
		
		tempLabel:setEnableStroke(true)
		tempLabel:setStrokeSize(4)
		tempLabel:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		tempLabel:setRelativePosition(GlobalMethod:ccp(0.5,-0.52))
		local sContent 
		if nType == 1 then
			tempLabel:setColor(GlobalMethod:ccc3(99,255,95))
			sContent = LocalStrings.ASCENDING_FUSE12
		elseif nType == 2 then
			tempLabel:setColor(GlobalMethod:ccc3(255,89,74))
			sContent = string.format(LocalStrings.ASCENDING_FUSE10, maxLevel)
		elseif nType == 3 then
			tempLabel:setColor(GlobalMethod:ccc3(255,89,74))
			sContent = LocalStrings.ASCENDING_FUSE11
		end
		tempLabel:setText(sContent)

		parentNode:addChild(tempLabel)

	end
end

-------------------------------------宠物进化模块Start----------------------------------------
function WndAscending:updatePetList()
	if self.m_root == nil then return end
	local tbconEquip = GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer)
	--self.m_nConListPositionY = tbconEquip:getMoveElement():getPositionY()
	tbconEquip:removeAll()
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)

	local tDataList = CacheCenter:getPlayerPetInfo()
	local count = 0
	WZLog("宠物列表",Serialize(CacheCenter:getPlayerPetInfo()))
	for i=1,#tDataList do
		if tonumber(tDataList[i].advancedLevel) >= tonumber(self.evoOrangePetNeedAdLevel) 
			and tonumber(tDataList[i].upgradeLevel) >= tonumber(self.evoOrangePetNeedPetLevel) 
			and GDatatab_item["id_"..tDataList[i].itemId].quality == 3 then
    		local cellElement,cellObj = CellPetEvolution:createElement()
    		cellElement = WZUIContainer:luaTo(cellElement)
    		tbconEquip:pushBack(cellElement)
			cellObj:setData(tDataList[i])
			count = count + 1
		end
	end

	if count == 0 then
   		GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(true)
	end
 	local moveElement = tbconEquip:getMoveElement()
 	moveElement:setPositionY(tbconEquip:getMinPosition().y)
end

function WndAscending:updatePlayerPetInfoData()
	self:updatePetList()
end

function WndAscending:updateLeftPet(tData)
	self.m_tPet = tData
	local con = GetElement(self.m_root,"conPetLeft",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	local ani, ani1 = CreatePetAni(con, nil, tData.animation, tData.advancedLevel)
	ani:getAnimNode():setTouchEnable(false)
    ani:getAnimNode():setScale(0.8)

	local stage = {LocalStrings.ASCENDING26,LocalStrings.ASCENDING26,LocalStrings.ASCENDING27,
		LocalStrings.ASCENDING27,LocalStrings.ASCENDING28,LocalStrings.ASCENDING28,
		LocalStrings.ASCENDING29,LocalStrings.ASCENDING29}
	local text = [[<T C="198,130,255" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T><BR>5</BR>
		<T C="198,130,255" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T>
		<T C="99,255,95" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T>]]
	GetElement(self.m_root,"txtLeftPet",WZUIFreeTextBox):setShowText(string.format(text,
		LocalStrings.LV..tData.upgradeLevel.."("..stage[tData.advancedLevel+1]..")",
		tData.name,"+"..tData.advancedLevel))
	GetElement(self.m_root,"leftPetFight",WZUILabelAtlasFont):setText(tData.fighting)
end

function WndAscending:updateRightPet(tData)
	local upgradeLevel = tData.upgradeLevel
	local petExp = tData.petExp
	local totalExp = petExp
	local reduceExp = 0
	local evoOrangePetLostLevel = CacheCenter:getGameParam().evoOrangePetLostLevel or 40
	WZLog("减去经验等级",evoOrangePetLostLevel)
	WZLog("减去经验等级",CacheCenter:getGameParam().evoOrangePetLostLevel)
	for k,v in pairs(GDatatab_pet_upgrade) do
		if v.level == (evoOrangePetLostLevel - 1) and v.quality == 3 then
			reduceExp = tonumber(v.total_exp)
		end
		if v.level == (upgradeLevel - 1) and v.quality == 3 then
			totalExp = totalExp + tonumber(v.total_exp)
			break
		end
	end
	local totalExpAfter = totalExp - reduceExp
	local upgradeLevelAfter = 0
	local advancedLevelAfter = tData.advancedLevel
	local upgradeProperty 
	WZLog("进化后经验值"..totalExpAfter)
	for k,v in pairs(GDatatab_pet_upgrade) do
		if v.quality == 4 and totalExpAfter > tonumber(v.total_exp) and v.level > upgradeLevelAfter then
			upgradeLevelAfter = v.level
		end
	end
	upgradeLevelAfter = upgradeLevelAfter + 1
	if upgradeLevelAfter > CacheCenter:getPlayerInfo().level then
		upgradeLevelAfter = CacheCenter:getPlayerInfo().level
	end

	local idAfter = tData.itemId
	self.m_bPetInConfig = false
	for k,v in pairs(GDatatab_pet_advance_evo) do
		if v.id1 == tData.itemId then
			idAfter = v.id
			self.m_bPetInConfig = true
			break
		end
	end
	WZLog("配置了宠物进化",self.m_bPetInConfig)
	if self.m_bPetInConfig == false then
		GetElement(WndAscending.m_root,"conPet2_WndAscending",WZUIContainer):setVisible(false)
		GetElement(WndAscending.m_root,"conNoConfig",WZUIContainer):setVisible(true)
		return
	else
		GetElement(WndAscending.m_root,"conNoConfig",WZUIContainer):setVisible(false)
	end
	self.m_tGetPetID = idAfter

	local tDataAfter = GDatatab_item["id_"..idAfter]
	local property = tDataAfter.property
	for k,v in pairs(GDatatab_pet) do
		if v.item_id == idAfter then
			upgradeProperty = v.property
		end
	end
	local property_rate = 0
	for k,v in pairs(GDatatab_pet_advanced) do
		if v.item_id == tData.itemId and v.level == advancedLevelAfter then
			property_rate = v.property_rate
		end
	end
	--(基础属性+升级属性)*(1+进阶百分比)*资质/100
	local hp = math.floor(property[1][2]+upgradeProperty[1][2]*upgradeLevelAfter/100)
	hp = hp + math.ceil(hp*property_rate/10000)
	local attack = math.floor(property[2][2]+upgradeProperty[2][2]*upgradeLevelAfter/100)
	attack = attack + math.ceil(attack*property_rate/10000)
	local defend = math.floor(property[3][2]+upgradeProperty[3][2]*upgradeLevelAfter/100)
	defend = defend + math.ceil(defend*property_rate/10000)
	local zizhi = tData.giftSkill/10000
	local petHP2 = math.ceil(hp*zizhi)
	local petAttack2 = math.ceil(attack*zizhi)
	local petDefense2 = math.ceil(defend*zizhi)
	WZLog("攻击:"..attack, petAttack2)
	WZLog("防御:"..defend, petDefense2)
	WZLog("生命:"..hp, petHP2)
	WZLog("资质:"..zizhi)
	--local fighting = math.ceil(0.75*(hp+4.8*attack+6*defend)*zizhi/100*1.0001) 
	local fighting = math.floor((petHP2+4.8*petAttack2+6*petDefense2)*0.75)
	WZLog("战斗力:"..fighting)

	--显示进化后的宠物
	local con = GetElement(self.m_root,"conPetRight",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	local ani, ani1 = CreatePetAni(con, nil, tDataAfter.animation_index_code, advancedLevelAfter)
	ani:getAnimNode():setTouchEnable(false)
    ani:getAnimNode():setScale(0.8)

	local stage = {LocalStrings.ASCENDING26,LocalStrings.ASCENDING26,LocalStrings.ASCENDING27,
		LocalStrings.ASCENDING27,LocalStrings.ASCENDING28,LocalStrings.ASCENDING28,
		LocalStrings.ASCENDING29,LocalStrings.ASCENDING29}
	local text = [[<T C="233,166,62" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T><BR>5</BR>
		<T C="233,166,62" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T>
		<T C="99,255,95" S="18" SE="TRUE" SS="4" SC="79,60,48">%s</T>]]
	GetElement(self.m_root,"txtRightPet",WZUIFreeTextBox):setShowText(string.format(text,
		LocalStrings.LV..upgradeLevelAfter.."("..stage[advancedLevelAfter+1]..")",
		tDataAfter.name,"+"..advancedLevelAfter))
	GetElement(self.m_root,"rightPetFight",WZUILabelAtlasFont):setText(fighting)
end

function WndAscending:refreshSelectedPet()
	if self.m_tPet == nil then return end
	local tData = GDatatab_item["id_"..self.m_tPet.itemId]
	for i=1,4 do
		self:setChoosePet(i, false, tData.icon)
	end
	for i=1,4 do
		if self["m_tPet"..i] ~= nil then
			self:setChoosePet(i, true, tData.icon)
		end
	end
end

function WndAscending:setChoosePet(index, selected, path)
	if GetElement(self.m_root,"petBg"..index,WZUIImage) == nil then return end
	GetElement(self.m_root,"petBg"..index,WZUIImage):setGrayRender(not selected)
	GetElement(self.m_root,"petGrid"..index,WZUIImage):setGrayRender(not selected)
	GetElement(self.m_root,"imgAddPet"..index,WZUIImage):setVisible(not selected)
	WZLog("WndAscending:setChoosePet",index,selected)
	GetElement(self.m_root,"pet"..index,WZUIImage):setFile(path)
	GetElement(self.m_root,"pet"..index,WZUIImage):setGrayRender(not selected)
end

function WndAscending:onChoosePet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPet == nil then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING34)
		return 
	end
    local wnd = WndChoosePet:createElement()
	for i=1,4 do
		WndChoosePet["m_tPet"..i] = self["m_tPet"..i]
	end
    WindowManager:addWindow(wnd, WndChoosePet, false)
end

function WndAscending:onEvolution()
	WZLog("WndAscending:onEvolution")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--是否已经选择宠物
	if self.m_tPet == nil then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING34)
		return 
	end
	--是否配置可进化
	if self.m_bPetInConfig == false then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING32..","..LocalStrings.ASCENDING33)
		return 
	end
	--宠物是否足够
	if self["m_tPet1"] == nil or self["m_tPet2"] == nil or 
			self["m_tPet3"] == nil or self["m_tPet4"] == nil then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING35)
		return
	end
	--材料是否足够
	local needM
	for k,v in pairs(GDatatab_pet_advance_evo) do
		if v.id1 == self.m_tPet.itemId then
			needM = v.scrap
		end
	end
	for k,v in pairs(needM) do
		local ownNum = CacheCenter:getPlayerItemCountById(v[1])
		if ownNum < v[2] then
			if v[1] == 2 then
        		MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
			else
				--checkIsOnSale(v[1])
				WndFastGetItems:show(v[1])
			end
			return
		end
	end

    local bHavePhantomPet = false 

	for i=1,4 do
		if self["m_tPet"..i] ~= nil then
			if self["m_tPet"..i].petSkinItemId and self["m_tPet"..i].petSkinItemId > 0 then
				bHavePhantomPet = true
				break 
			end 
		end
	end
	if bHavePhantomPet then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBox(LocalStrings.PET_TEXT10, self, self.continueToExtranction, nil, tCustomUIConfig)
        return 
    end

	self:continueToExtranction()
end

function WndAscending:continueToExtranction()
	--body
	local cPlayerPetIdArr = WZLuaVector_int_:create()
    local cNum = WZLuaVector_int_:create()

	for i=1,4 do
		if self["m_tPet"..i] ~= nil then
			cPlayerPetIdArr:push(self["m_tPet"..i].playerPetId)
			cNum:push(1)
		end
	end
	
	ProtocolProcessorWndAscending:send_ADVANCED_EvoOrangePet(self.m_tPet.playerPetId, cPlayerPetIdArr, cNum )
end

function WndAscending:setPetCost()
	if self.m_tPet == nil then 
		GetElement(WndAscending.m_root,"txtCostTab4",WZUIFreeTextBox):setShowText("")
		return 
	end
	local needM
	for k,v in pairs(GDatatab_pet_advance_evo) do
		if v.id1 == self.m_tPet.itemId then
			needM = v.scrap
		end
	end
	local text = [[<T C="255,227,116" S="20" P="1">%s  </T>
		<I Z="0.5">%s</I><T C="255,227,116" S="20" P="1">%s</T><T C="195,171,148" S="20" P="1">%s  </T>
		<I Z="0.5">%s</I><T C="255,227,116" S="20" P="1">%s</T><T C="195,171,148" S="20" P="1">%s</T>]]
	GetElement(WndAscending.m_root,"txtCostTab4",WZUIFreeTextBox):setShowText(string.format(text,LocalStrings.CONSUME,
		GDatatab_item["id_"..needM[1][1]].icon,tostring(needM[1][2]),"("..LocalStrings.OWN..CacheCenter:getPlayerItemCountById(needM[1][1])..")",
		GDatatab_item["id_"..needM[2][1]].icon,tostring(needM[2][2]),"("..LocalStrings.OWN..CacheCenter:getPlayerItemCountById(needM[2][1])..")"))
end

function WndAscending:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

function WndAscending:onJumpPet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurTab == 4 then
		JumpByUIId(59)
	elseif self.m_nCurTab == 5 then
		JumpByUIId(67)
	end
end

-------------------------------------宠物进化模块End----------------------------------------

-------------------------------------坐骑升品模块Start----------------------------------------
function WndAscending:updateMountList()
	WZLog("WndAscending:updateMountList")
	for i=1,3 do
		WZLog("坐骑升品等级限制",CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv"..i],
			CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv"..i])
	end
	if self.m_root == nil then return end
	local tbconEquip = GetElement(self.m_root,"tbEquipList_WndAscending",WZUIFreeListContainer)
	tbconEquip:removeAll()
   	GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(false)

	local index = self.m_nRightTab
	minQuality = {1,3,2,1}
	maxQuality = {3,3,2,1}
	local tDataList = CacheCenter:getPlayerInfo().allMountsMessage
	local count = 0
	WZLog("坐骑列表",Serialize(tDataList))
	for i=1,#tDataList do
		local tData = json.decode(tDataList[i])
		WZLog("坐骑信息",Serialize(tData))
		local itemData = GDatatab_item["id_"..GDatatab_mounts["id_"..tData.mountsId].item_id]
		tData.basicInfo = itemData
		if --tonumber(tData.advancedLevel) >= tonumber(self.m_nMountNeedAdvanceLv) 
			--and tonumber(tData.upgradeLevel) >= tonumber(self.m_nMountNeedUpgradeLv) and
			itemData.quality >= minQuality[index] and 
			itemData.quality <= maxQuality[index] then
			if tonumber(tData.advancedLevel) >= tonumber(CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv"..itemData.quality]) and
				tonumber(tData.upgradeLevel) >= tonumber(CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv"..itemData.quality]) then
    		local cellElement,cellObj = CellMountEvolution:createElement()
    		cellElement = WZUIContainer:luaTo(cellElement)
    		tbconEquip:pushBack(cellElement)
			cellObj:setData(tData)
			count = count + 1
			end
		end
	end

	if count == 0 then
   		GetElement(self.m_root,"conNull4",WZUIContainer):setVisible(true)
		local tip = ""
		if self.m_nRightTab == 1 then
			tip = string.format(LocalStrings.ASCENDING48, 
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv1"]),
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv1"]))
		elseif self.m_nRightTab == 2 then
			tip = string.format(LocalStrings.ASCENDING50, 
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv3"]),
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv3"]))
		elseif self.m_nRightTab == 3 then
			tip = string.format(LocalStrings.ASCENDING49, 
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv2"]),
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv2"]))
		elseif self.m_nRightTab == 4 then
			tip = string.format(LocalStrings.ASCENDING48, 
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedAdvanceLv1"]),
			tonumber(CacheCenter:getGameParam()["upMountQualityNeedUpgradeLv1"]))
		end
		GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setText(tip)
	end
 	local moveElement = tbconEquip:getMoveElement()
 	moveElement:setPositionY(tbconEquip:getMinPosition().y)
end

--@brief	显示升品前坐骑信息
function WndAscending:showLeftMount(tData)
	if tData == nil then return end
	self.m_tMount = tData
	--强化等级
	GetElement(self.m_root,"txtMountStrongLv1",WZUILabelTTF):setText(LocalStrings.LV..tData.upgradeLevel)
	--升星等级
	GetElement(self.m_root,"txtMountStarLv1",WZUILabelTTF):setText(tData.advancedLevel)
	GetElement(self.m_root,"starMount1_WndAscending",WZUIImage):setVisible(true)
	--属性
	local attrID = {1,3,4,12,13}
	for i=1,5 do
		GetElement(self.m_root,"txtLeftMountAttrTitle"..i,WZUILabelTTF):setText(ATTR_TITLE[attrID[i]])
		GetElement(self.m_root,"txtLeftMountAttr"..i,WZUILabelTTF):setText(tData[tostring(attrID[i])])
	end
	
    --创建装备cell
    local conEquip = GetElement(self.m_root,"conMountIcon1_WndAscending",WZUIContainer)
	if conEquip:getChildByTag(100) then conEquip:removeChildByTag(100,true) end
    local cellElement, tLua = CellGoodItem:createElement()
    tLua:setItemClickFun(self,self.onMountClicked)
	tLua:setCellGoodItem(tData, 19)
    if cellElement ~= nil and tLua ~= nil then
        conEquip:addChild(cellElement, 100, 100)
        cellElement:setScale(0.9)
    end
end

--@brief	移除升品前坐骑信息
function WndAscending:removeLeftMount()
    local con = GetElement(self.m_root,"conMountIcon1_WndAscending",WZUIContainer)
	if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	GetElement(self.m_root,"txtMountStrongLv1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtMountStarLv1",WZUILabelTTF):setText("")
	GetElement(self.m_root,"starMount1_WndAscending",WZUIImage):setVisible(false)
	for i=1,5 do
		GetElement(self.m_root,"txtLeftMountAttrTitle"..i,WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtLeftMountAttr"..i,WZUILabelTTF):setText("")
	end
end

--@brief	显示升品后坐骑信息
function WndAscending:showRightMount(tData)
	if tData == nil then return end
	local upData = CopyTable(tData)
	local upID = GDatatab_mounts_quality_upgrade["id_"..upData.basicInfo.id].id1
	upData.basicInfo = GDatatab_item["id_"..upID]
	self.m_tGetMountID = upID
	--强化等级
	GetElement(self.m_root,"txtMountStrongLv2",WZUILabelTTF):setText(LocalStrings.LV..upData.upgradeLevel)
	--升星等级
	GetElement(self.m_root,"txtMountStarLv2",WZUILabelTTF):setText(upData.advancedLevel)
	GetElement(self.m_root,"starMount2_WndAscending",WZUIImage):setVisible(true)
	--计算升品后属性
	local attrID = {1,3,4,12,13}
	for i=1,5 do
		local basePro = upData.basicInfo.property[i][2]
		local upPro = GDatatab_mounts_upgrade["id_"..upData.upgradeLevel].property[i][2]
		local property_rate = 0
		if upData.advancedLevel > 0 then
			property_rate = GDatatab_mounts_advanced["id_"..upData.advancedLevel].property_rate
		end
		local property = math.ceil((basePro + upPro)*(1 + property_rate / 10000))
		GetElement(self.m_root,"txtRightMountAttrTitle"..i,WZUILabelTTF):setText(ATTR_TITLE[attrID[i]])
		GetElement(self.m_root,"txtRightMountAttr"..i,WZUILabelTTF):setText(property)
	end
	
    --创建装备cell
    local conEquip = GetElement(self.m_root,"conMountIcon2_WndAscending",WZUIContainer)
	if conEquip:getChildByTag(100) then conEquip:removeChildByTag(100,true) end
    local cellElement, tLua = CellGoodItem:createElement()
	tLua:setCellGoodItem(upData, 19)
   	tLua:setItemClickFun(self,self.onMountClicked)
    if cellElement ~= nil and tLua ~= nil then
        conEquip:addChild(cellElement, 100, 100)
        cellElement:setScale(0.9)
    end
end

--@brief	移除升品后坐骑信息
function WndAscending:removeRightMount()
    local con = GetElement(self.m_root,"conMountIcon2_WndAscending",WZUIContainer)
	if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	GetElement(self.m_root,"txtMountStrongLv2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtMountStarLv2",WZUILabelTTF):setText("")
	GetElement(self.m_root,"starMount2_WndAscending",WZUIImage):setVisible(false)
	for i=1,5 do
		GetElement(self.m_root,"txtRightMountAttrTitle"..i,WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtRightMountAttr"..i,WZUILabelTTF):setText("")
	end
end

--@brief	显示材料
function WndAscending:showMountM()
	if self.m_tMount == nil then return end
	self.m_tNeedM = {}
	self.m_tOwnM = {}
	self.m_tMId = {}
	local tData = self.m_tMount
	local scrap = GDatatab_mounts_quality_upgrade["id_"..tData.basicInfo.id].scrap
	local id = {}
	local vnNum = {}
	for i=1,#scrap do
		self.m_tNeedM[i] = scrap[i][2]
		self.m_tOwnM[i] = CacheCenter:getPlayerItemCountById(scrap[i][1])
		self.m_tMId[i] = scrap[i][1]
		id[i] = scrap[i][1]
		vnNum[i] = tostring(self.m_tOwnM[i]).."/"..self.m_tNeedM[i]
	end
	for i=1,#scrap do
		local tData = GDatatab_item["id_"..id[i]]
        local name = tData.name
        local path = tData.icon
        local num =  vnNum[i]
        local quality = tData.quality
        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}
    	local con = GetElement(self.m_root,"conMountM"..i,WZUIContainer)
		if con:getChildByTag(100) then con:removeChildByTag(100,true) end
    	local cellElement, tLua = CellGoodItem:createElement()
		tLua:setCellGoodItem(itemInfo, 4)
    	tLua:setItemClickFun(self,self.onMClicked)
		if tonumber(self.m_tOwnM[i]) < tonumber(self.m_tNeedM[i]) then
		tLua:setNumColor(GlobalMethod:ccc3(255,89,74),	GlobalMethod:ccc3(158,0,0))
		end
    	if cellElement ~= nil and tLua ~= nil then
    	    con:addChild(cellElement, 100, 100)
    	    cellElement:setScale(1)
    	end
	end
end

--@brief	移除材料
function WndAscending:removeMountM()
	WZLog("WndAscending:removeMountM")
	for i=1,3 do
    	local con = GetElement(self.m_root,"conMountM"..i,WZUIContainer)
		if con:getChildByTag(100) then con:removeChildByTag(100,true) end
	end
end

--@brief	点击升品
function WndAscending:onMount()
	WZLog("WndAscending:onMount")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--是否已经选择宠物
	if self.m_tMount == nil then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING47)
		return 
	end
	WZLog("WndAscending:onMount", self.m_tMount.mountsId)
	--材料是否足够
	local needM
	for k,v in pairs(GDatatab_mounts_quality_upgrade) do
		if v.id == self.m_tMount.basicInfo.id then
			needM = v.scrap
		end
	end
	for k,v in pairs(needM) do
		local ownNum = CacheCenter:getPlayerItemCountById(v[1])
		if ownNum < v[2] then
			if v[1] == 2 then
        		MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
			else
				--checkIsOnSale(v[1])
				WndFastGetItems:show(v[1])
			end
			return
		end
	end

	GetElement(self.m_root,"ani5",WZUISpine):setVisible(true)
	GetElement(self.m_root,"ani5",WZUISpine):play("4", false)
	self.m_root:enableSchedule("sendProtocol5", 2)
end

--@brief	发送协议
function WndAscending:sendProtocol5()
	self.m_root:disableSchedule()
	GetElement(self.m_root,"ani5",WZUISpine):setVisible(false)
	ProtocolProcessorWndAscending:send_ADVANCED_UpgradeMountQuality(self.m_tMount.mountsId )
end

--按照功能开放等级进行显示
function WndAscending:controlBtnShow()
    -- body
    WZLog("WndAscending:controlBtnShow")
    local GDatatab_button_info = GDatatab_button_info
    local GetElement = GetElement
    local btnList = {82,86,91}
    local elementNames = {"checkbox3_WndAscending","checkbox4_WndAscending","checkbox5_WndAscending"}
    local psList = {{0.31,0.278},{0.5,0.278},{0.691,0.278}}
    local tBtnList = {}
    for i,v in ipairs(btnList) do
        local temp = {}
        table.insert(temp,v)
        table.insert(temp,elementNames[i])

        table.insert(tBtnList,temp)
    end

    table.sort(tBtnList,function (a,b)
        -- body
        local btnInfoA = GDatatab_button_info["id_" .. a[1]]
        local btnInfoB = GDatatab_button_info["id_" .. b[1]]
        if btnInfoA.open_level < btnInfoB.open_level then
            return true
        end
        return false
    end)

    local conMidLeft = GetElement(self.m_root,"conMidLeft_WndStrengthen",WZUIContainer)
    local checkGroup = GetElement(conMidLeft,"checkGroup",WZUICheckBoxGroup)
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i,v in ipairs(tBtnList) do
    	local element = GetElement(checkGroup,v[2],WZUICheckBox)
        if playerLevel >= GDatatab_button_info["id_"..v[1]].open_level  then 
            element:setVisible(true)
            element:setRelativePosition(GlobalMethod:ccp(psList[i][1],psList[i][2]))
        else
        	element:setVisible(false)
        end
    end
end
-------------------------------------坐骑升品模块end----------------------------------------

-------------------------------------私有方法模块End----------------------------------------
--@brief	适配分辨率
function WndAscending:AdaptResolution()
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("WndAscending:AdaptResolution",directorSize.height)
	--ipad适配
	if directorSize.width == 1024 and directorSize.height == 768 then
		GetElement(self.m_root,"conMid",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.05))
	end
	if directorSize.width == 2048 and directorSize.height == 1536 then
		GetElement(self.m_root,"conMid",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.05))
	end
end

------------------------------语言适配Begin--------------------------------------------------
function WndAscending:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtM1_WndAscending",WZUILabelTTF):setScale(0.8)
	
	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.6))

	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.6))
	GetElement(self.m_root,"txtNull2_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txtCost1_WndAscending",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtGrade",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")
	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setScale(0.88)
	GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF):setFontSize(16)
	
	local txtLeftAttrTitle1 = GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF)
	txtLeftAttrTitle1:setFontSize(14)
	txtLeftAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtLeftAttr1 = GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF)
	txtLeftAttr1:setFontSize(14)
	
	local txtRightAttrTitle1 = GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF)
	txtRightAttrTitle1:setFontSize(14)
	txtRightAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtRightAttr1 = GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF)
	txtRightAttr1:setFontSize(14)

	local txtLeftAttrTitle2 = GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF)
	txtLeftAttrTitle2:setFontSize(14)
	txtLeftAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtLeftAttr2 = GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF)
	txtLeftAttr2:setFontSize(14)
	txtLeftAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))
	
	local txtRightAttrTitle2 = GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF)
	txtRightAttrTitle2:setFontSize(14)
	txtRightAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtRightAttr2 = GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF)
	txtRightAttr2:setFontSize(14)
	txtRightAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))

	local txtLeftAttrTitle3 = GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF)
	txtLeftAttrTitle3:setFontSize(12)
	txtLeftAttrTitle3:setRelativePosition(GlobalMethod:ccp(-0.02,0.3))
	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(12)
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.225,0.211111))
	txtLeftAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtLeftAttr3:setDimensions(GlobalMethod:CCSize(150))

	local txtRightAttrTitle3 = GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF)
	txtRightAttrTitle3:setFontSize(12)
	txtRightAttrTitle3:setRelativePosition(GlobalMethod:ccp(-0.02,0.3))
	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(12)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.225,0.211111))
	txtRightAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtRightAttr3:setDimensions(GlobalMethod:CCSize(150))

	
	local txtM2 = GetElement(self.m_root,"txtM2_WndAscending",WZUILabelTTF)
	txtM2:setDimensions(GlobalMethod:CCSize(100,0))
	for i=1,2 do
		local nullTip = GetElement(self.m_root,"nullTip"..i,WZUILabelTTF)
		nullTip:setDimensions(GlobalMethod:CCSize(300,0))
		if i == 1 then
			nullTip:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		else
			nullTip:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	end
	GetElement(self.m_root,"txtTopCheck3_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTopCheckSel3_WndAscending",WZUILabelTTF):setFontSize(18)

	local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF)
	txtCheck5:setFontSize(18)
	--txtCheck5:setDimensions(GlobalMethod:CCSize(60,0))
	
	local txtCheckSel5 = GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF)
	txtCheckSel5:setFontSize(18)
	--txtCheckSel5:setDimensions(GlobalMethod:CCSize(60,0))

	for i=1,3 do
		local txtMountM = GetElement(self.m_root,"txtMountM"..i.."_WndAscending",WZUILabelTTF)
		txtMountM:setScale(0.8)
		txtMountM:setDimensions(GlobalMethod:CCSize(80,0))
	end

	local txtCheckBox2 = GetElement(self.m_root, "txtCheckBox2_WndAscending", WZUILabelTTF)
	txtCheckBox2:setScale(0.6)
	txtCheckBox2:setDimensions(GlobalMethod:CCSize(120))
	local txtCheckBoxSel2 = GetElement(self.m_root, "txtCheckBoxSel2_WndAscending", WZUILabelTTF)
	txtCheckBoxSel2:setScale(0.6)
	txtCheckBoxSel2:setDimensions(GlobalMethod:CCSize(120))
end

function WndAscending:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.425,0.6))
	GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.425,0.6))
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setFontSize(22)
	for i=1,2 do
		GetElement(self.m_root,"nullTip"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	end
	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.6))
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")
	local txtMountM3 = GetElement(self.m_root,"txtMountM3_WndAscending",WZUILabelTTF)
	txtMountM3:setScale(0.8)
	local txtMountM2 = GetElement(self.m_root,"txtMountM2_WndAscending",WZUILabelTTF)
	txtMountM2:setScale(0.8)

	GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF):setScale(0.8)

	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(14)
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.4,0.25))

	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(14)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.4,0.25))

end

function WndAscending:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtM1_WndAscending",WZUILabelTTF):setScale(0.8)
	for i=1,2 do
		GetElement(self.m_root,"nullTip"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	end
	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.6))

	GetElement(self.m_root,"txtNull2_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))

	local txtLeftAttrTitle1 = GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF)
	txtLeftAttrTitle1:setFontSize(14)
	txtLeftAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtLeftAttr1 = GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF)
	txtLeftAttr1:setFontSize(14)
	
	local txtRightAttrTitle1 = GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF)
	txtRightAttrTitle1:setFontSize(14)
	txtRightAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtRightAttr1 = GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF)
	txtRightAttr1:setFontSize(14)

	local txtLeftAttrTitle2 = GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF)
	txtLeftAttrTitle2:setFontSize(14)
	txtLeftAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtLeftAttr2 = GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF)
	txtLeftAttr2:setFontSize(14)
	txtLeftAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))
	
	local txtRightAttrTitle2 = GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF)
	txtRightAttrTitle2:setFontSize(14)
	txtRightAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtRightAttr2 = GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF)
	txtRightAttr2:setFontSize(14)
	txtRightAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))

	local txtLeftAttrTitle3 = GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF)
	txtLeftAttrTitle3:setFontSize(14)
	txtLeftAttrTitle3:setRelativePosition(GlobalMethod:ccp(0.012,0.3))
	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(14)
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.28,0.211111))
	txtLeftAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtLeftAttr3:setDimensions(GlobalMethod:CCSize(150))

	local txtRightAttrTitle3 = GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF)
	txtRightAttrTitle3:setFontSize(14)
	txtRightAttrTitle3:setRelativePosition(GlobalMethod:ccp(0.012,0.3))
	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(14)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.28,0.211111))
	txtRightAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtRightAttr3:setDimensions(GlobalMethod:CCSize(150))

	GetElement(self.m_root,"txtCost1_WndAscending",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtGrade",WZUILabelTTF):setScale(0.6)

	local conEquipIcon3 = GetElement(self.m_root,"conEquipIcon3_WndAscending",WZUIContainer)
	GetElement(conEquipIcon3,"txtEquipWord1_WndAscending",WZUILabelTTF):setFontSize(12)

	local ftxtCost = GetElement(self.m_root,"ftxtCost_ConTab3",WZUIFreeTextBox)
	ftxtCost:setMaxWidth(660)
	ftxtCost:setScale(0.8)

	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")

	GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTopCheck3_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTopCheckSel3_WndAscending",WZUILabelTTF):setFontSize(18)

	local txtMountM1 = GetElement(self.m_root,"txtMountM1_WndAscending",WZUILabelTTF)
	txtMountM1:setDimensions(GlobalMethod:CCSize(100,0))
	txtMountM1:setScale(0.8)
	local txtMountM3 = GetElement(self.m_root,"txtMountM3_WndAscending",WZUILabelTTF)
	txtMountM3:setDimensions(GlobalMethod:CCSize(100,0))
	txtMountM3:setScale(0.8)
	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF):setFontSize(22)

	GetElement(self.m_root,"txtLeftPet",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.1,0.92))
	GetElement(self.m_root,"txtRightPet",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.1,0.92))

	GetElement(self.m_root,"txtLeftMountAttr4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.606842,0.37))
	GetElement(self.m_root,"txtRightMountAttr4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.606842,0.37))
end

function WndAscending:_adaptLanguage_vn(  )
	for i=1,2 do
		GetElement(self.m_root,"nullTip"..i,WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	end
	GetElement(self.m_root,"nullTip2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.56))
	GetElement(self.m_root,"txtNull2_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtM1_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(90,0))
	GetElement(self.m_root,"txtM2_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(90,0))
	GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.6))
	GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.51,0.9))
	GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.51,0.9))
	GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.6))
	GetElement(self.m_root,"retention",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.01,0.205))
	GetElement(self.m_root,"txtCost1_WndAscending",WZUILabelTTF):setScale(0.85)

	local txtCost = GetElement(self.m_root,"txtCost2_WndAscending",WZUILabelTTF)
	txtCost:setScale(0.85)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.64,0.152))

	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(12)
	txtLeftAttr3:setDimensions(GlobalMethod:CCSize(130,0))
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.3,0.3))

	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(12)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.3,0.3))
	txtRightAttr3:setDimensions(GlobalMethod:CCSize(130,0))

	GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txtMountBefore_WndAscending",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtMountAfter_WndAscending",WZUILabelTTF):setScale(0.6)
	for i=1,3 do
		local txtMountM = GetElement(self.m_root,"txtMountM"..i.."_WndAscending",WZUILabelTTF)
		txtMountM:setScale(0.8)
		txtMountM:setDimensions(GlobalMethod:CCSize(100,0))
	end
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")
	GetElement(self.m_root,"txtLeftMountAttr1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,1))
	GetElement(self.m_root,"txtLeftMountAttr5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.16))
	GetElement(self.m_root,"txtRightMountAttr1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,1))
	GetElement(self.m_root,"txtRightMountAttr5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.16))

	GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setFontSize(18)
end

function WndAscending:_adaptLanguage_es(  )
	local txtM1 = GetElement(self.m_root,"txtM1_WndAscending",WZUILabelTTF)
	txtM1:setScale(0.7)
	txtM1:setDimensions(GlobalMethod:CCSize(100,0))
	GetElement(self.m_root,"txtM2_WndAscending",WZUILabelTTF):setScale(0.8)
	
	local nullTip1 = GetElement(self.m_root,"nullTip1",WZUILabelTTF)
	nullTip1:setDimensions(GlobalMethod:CCSize(300,0))
	nullTip1:setRelativePosition(GlobalMethod:ccp(0.5,0.68))
	
	local nullTip2 = GetElement(self.m_root,"nullTip2",WZUILabelTTF)
	nullTip2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	nullTip2:setDimensions(GlobalMethod:CCSize(300,0))

	local txtNull2 = GetElement(self.m_root,"txtNull2_WndAscending",WZUILabelTTF)
	txtNull2:setDimensions(GlobalMethod:CCSize(300,0))

	local txtLeftAttrTitle1 = GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF)
	txtLeftAttrTitle1:setFontSize(14)
	txtLeftAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtLeftAttr1 = GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF)
	txtLeftAttr1:setFontSize(14)
	
	local txtRightAttrTitle1 = GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF)
	txtRightAttrTitle1:setFontSize(14)
	txtRightAttrTitle1:setRelativePosition(GlobalMethod:ccp(0.012,0.9))
	local txtRightAttr1 = GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF)
	txtRightAttr1:setFontSize(14)

	local txtLeftAttrTitle2 = GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF)
	txtLeftAttrTitle2:setFontSize(14)
	txtLeftAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtLeftAttr2 = GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF)
	txtLeftAttr2:setFontSize(14)
	txtLeftAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))
	
	local txtRightAttrTitle2 = GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF)
	txtRightAttrTitle2:setFontSize(14)
	txtRightAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.012,0.6))
	local txtRightAttr2 = GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF)
	txtRightAttr2:setFontSize(14)
	txtRightAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))

	local txtLeftAttrTitle3 = GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF)
	txtLeftAttrTitle3:setFontSize(12)
	txtLeftAttrTitle3:setRelativePosition(GlobalMethod:ccp(-0.01,0.3))
	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(12)
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.1,0.211111))
	txtLeftAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtLeftAttr3:setDimensions(GlobalMethod:CCSize(172))

	GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF):setScale(0.7)
	local txtRightAttrTitle2 = GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF)
	txtRightAttrTitle2:setScale(0.7)
	txtRightAttrTitle2:setRelativePosition(GlobalMethod:ccp(0.07,0.633333))
	local txtRightAttr2 = GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF)
	txtRightAttr2:setScale(0.7)
	txtRightAttr2:setRelativePosition(GlobalMethod:ccp(0.37,0.633333))
	local txtRightAttrTitle3 = GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF)
	txtRightAttrTitle3:setFontSize(12)
	txtRightAttrTitle3:setRelativePosition(GlobalMethod:ccp(-0.01,0.3))
	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(12)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.1,0.211111))
	txtRightAttr3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtRightAttr3:setDimensions(GlobalMethod:CCSize(172))

	local txtCost1 = GetElement(self.m_root,"txtCost1_WndAscending",WZUILabelTTF)
	txtCost1:setScale(0.55)
	txtCost1:setRelativePosition(GlobalMethod:ccp(0.392005,0.152))

	local txtCost2 = GetElement(self.m_root,"txtCost2_WndAscending",WZUILabelTTF)
	txtCost2:setScale(0.55)
	txtCost2:setRelativePosition(GlobalMethod:ccp(0.720722,0.152))

	local txtCost = GetElement(self.m_root,"txtCost",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.838969,0.152))

	local txtGrade = GetElement(self.m_root,"txtGrade",WZUILabelTTF)
	txtGrade:setScale(0.8)
	txtGrade:setDimensions(GlobalMethod:CCSize(60,0))

	local conEquipIcon3 = GetElement(self.m_root,"conEquipIcon3_WndAscending",WZUIContainer)
	GetElement(conEquipIcon3,"txtEquipWord1_WndAscending",WZUILabelTTF):setFontSize(12)

	local ftxtCost = GetElement(self.m_root,"ftxtCost_ConTab3",WZUIFreeTextBox)
	ftxtCost:setMaxWidth(660)
	ftxtCost:setScale(0.8)

	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":".."0)")

	GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF):setFontSize(18)
	
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setFontSize(16)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(100,0))
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setFontSize(16)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(100,0))
	GetElement(self.m_root,"txtTopCheck3_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTopCheckSel3_WndAscending",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtTopCheck4_WndAscending",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtTopCheckSel4_WndAscending",WZUILabelTTF):setFontSize(14)
	local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF)
	txtCheck5:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck5:setFontSize(16)
	local txtCheckSel5 = GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF)
	txtCheckSel5:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel5:setFontSize(16)

	local txtMountM1 = GetElement(self.m_root,"txtMountM1_WndAscending",WZUILabelTTF)
	txtMountM1:setDimensions(GlobalMethod:CCSize(100,0))
	txtMountM1:setScale(0.8)
	local txtMountM3 = GetElement(self.m_root,"txtMountM3_WndAscending",WZUILabelTTF)
	txtMountM3:setDimensions(GlobalMethod:CCSize(100,0))
	txtMountM3:setScale(0.8)

	local txtMountM2 = GetElement(self.m_root,"txtMountM2_WndAscending",WZUILabelTTF)
	txtMountM2:setDimensions(GlobalMethod:CCSize(100,0))
	txtMountM2:setScale(0.8)

	local txtConNull4 = GetElement(self.m_root,"txtConNull4",WZUILabelTTF)
	txtConNull4:setDimensions(GlobalMethod:CCSize(300,0))
	txtConNull4:setRelativePosition(GlobalMethod:ccp(0.5,0.66))

	GetElement(self.m_root,"txtLeftPet",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.1,0.92))
	GetElement(self.m_root,"txtRightPet",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.1,0.92))

	local retention = GetElement(self.m_root,"retention",WZUICheckBox)
	retention:setRelativePosition(GlobalMethod:ccp(-0.02,0.205))

	for i=1,3 do
		local txtSure = GetElement(self.m_root,"txtSure"..i.."_WndAscending",WZUILabelTTF)
		txtSure:setDimensions(GlobalMethod:CCSize(110,0))
		txtSure:setScale(0.6)
	end

	GetElement(self.m_root,"txtPet_WndAscending",WZUILabelTTF):setScale(0.8)
	local txtMount = GetElement(self.m_root,"txtMount_WndAscending",WZUILabelTTF)
	txtMount:setScale(0.6)
	txtMount:setDimensions(GlobalMethod:CCSize(110,0))

	local txtEquipDesc2 = GetElement(self.m_root,"txtEquipDesc2_WndAscending",WZUILabelTTF)
	txtEquipDesc2:setScale(0.66)
	txtEquipDesc2:setDimensions(GlobalMethod:CCSize(170))
	local txtCost = GetElement(self.m_root,"txtCost_WndAscending",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.16,0.78))

	GetElement(self.m_root,"txtLeftPet",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"txtRightPet",WZUIFreeTextBox):setScale(0.7)

	GetElement(self.m_root,"txtLeftMountAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.79))
	GetElement(self.m_root,"txtLeftMountAttr3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.58))
	GetElement(self.m_root,"txtLeftMountAttr4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.37))
	GetElement(self.m_root,"txtLeftMountAttr5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.16))
	GetElement(self.m_root,"txtRightMountAttr2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.79))
	GetElement(self.m_root,"txtRightMountAttr3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.58))
	GetElement(self.m_root,"txtRightMountAttr4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.37))
	GetElement(self.m_root,"txtRightMountAttr5",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.16))
end

function WndAscending:_adaptLanguage_tr(  )
	-- GetElement(self.m_root,"txtM1_WndAscending",WZUILabelTTF):setScale(0.8)
	-- local txtM2 = GetElement(self.m_root,"txtM2_WndAscending",WZUILabelTTF)
	-- txtM2:setDimensions(GlobalMethod:CCSize(100,0))

	for i=1,4 do
		local txtM_WndAscending = GetElement(self.m_root,"txtM"..i.."_WndAscending",WZUILabelTTF)
		if txtM_WndAscending then
			txtM_WndAscending:setScale(0.85)
		end
	end

	for i=1,4 do
		local txtCheckBox = GetElement(self.m_root,"txtCheckBox"..i.."_WndAscending",WZUILabelTTF)
		if txtM_WndAscending then
			txtM_WndAscending:setScale(0.5)
		end
	end

	for i=1,4 do
		local txtCheckBoxSel = GetElement(self.m_root,"txtCheckBoxSel"..i.."_WndAscending",WZUILabelTTF)
		if txtM_WndAscending then
			txtM_WndAscending:setScale(0.5)
		end
	end

	for i=1,2 do
		local nullTip = GetElement(self.m_root,"nullTip"..i,WZUILabelTTF)
		nullTip:setDimensions(GlobalMethod:CCSize(300,0))
		if i == 1 then
			nullTip:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		else
			nullTip:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
	end
	
	GetElement(self.m_root,"txtNull2_WndAscending",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))

	GetElement(self.m_root,"txtLeftAttrTitle1",WZUILabelTTF):setFontSize(16)
	local txtLeftAttr1 = GetElement(self.m_root,"txtLeftAttr1",WZUILabelTTF)
	txtLeftAttr1:setFontSize(14)
	
	GetElement(self.m_root,"txtRightAttrTitle1",WZUILabelTTF):setFontSize(16)
	local txtRightAttr1 = GetElement(self.m_root,"txtRightAttr1",WZUILabelTTF)
	txtRightAttr1:setFontSize(14)

	GetElement(self.m_root,"txtLeftAttrTitle2",WZUILabelTTF):setFontSize(16)
	local txtLeftAttr2 = GetElement(self.m_root,"txtLeftAttr2",WZUILabelTTF)
	txtLeftAttr2:setFontSize(14)
	txtLeftAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))
	
	GetElement(self.m_root,"txtRightAttrTitle2",WZUILabelTTF):setFontSize(16)
	local txtRightAttr2 = GetElement(self.m_root,"txtRightAttr2",WZUILabelTTF)
	txtRightAttr2:setFontSize(14)
	txtRightAttr2:setRelativePosition(GlobalMethod:ccp(0.44,0.6))

	GetElement(self.m_root,"txtLeftAttrTitle3",WZUILabelTTF):setFontSize(16)
	local txtLeftAttr3 = GetElement(self.m_root,"txtLeftAttr3",WZUILabelTTF)
	txtLeftAttr3:setFontSize(14)
	txtLeftAttr3:setRelativePosition(GlobalMethod:ccp(0.385789,0.3))

	GetElement(self.m_root,"txtRightAttrTitle3",WZUILabelTTF):setFontSize(16)
	local txtRightAttr3 = GetElement(self.m_root,"txtRightAttr3",WZUILabelTTF)
	txtRightAttr3:setFontSize(14)
	txtRightAttr3:setRelativePosition(GlobalMethod:ccp(0.385789,0.3))


	local txtCost1 = GetElement(self.m_root,"txtCost1_WndAscending",WZUILabelTTF)
	txtCost1:setScale(0.55)
	txtCost1:setRelativePosition(GlobalMethod:ccp(0.396129,0.152))

	local txtGrade = GetElement(self.m_root,"txtGrade",WZUILabelTTF)
	txtGrade:setScale(0.7)
	txtGrade:setDimensions(GlobalMethod:CCSize(120))

	local conEquipIcon1 = GetElement(self.m_root,"conEquipIcon1_WndAscending",WZUIContainer)
	GetElement(conEquipIcon1,"txtEquipWord1_WndAscending",WZUILabelTTF):setFontSize(12)

	local conEquipIcon2 = GetElement(self.m_root,"conEquipIcon2_WndAscending",WZUIContainer)
	GetElement(conEquipIcon2,"txtEquipWord1_WndAscending",WZUILabelTTF):setFontSize(12)

	local conEquipIcon3 = GetElement(self.m_root,"conEquipIcon3_WndAscending",WZUIContainer)
	GetElement(conEquipIcon3,"txtEquipWord1_WndAscending",WZUILabelTTF):setFontSize(12)

	local imgCost = GetElement(self.m_root,"imgCost",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.43,0.78))
	GetElement(self.m_root,"txtCost2_WndAscending",WZUILabelTTF):setScale(0.6)

	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.7)
	-- txtIntensify1:setFontSize(16)
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.7)
	-- txtIntensify2:setFontSize(16)

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.7)
	-- txtTransfer1:setFontSize(16)
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.7)
	-- txtTransfer2:setFontSize(16)

	local txtTopCheck3 = GetElement(self.m_root,"txtTopCheck3_WndAscending",WZUILabelTTF)
	txtTopCheck3:setScale(0.7)
	-- txtTopCheck3:setFontSize(16)
	local txtTopCheckSel3 = GetElement(self.m_root,"txtTopCheckSel3_WndAscending",WZUILabelTTF)
	txtTopCheckSel3:setScale(0.7)
	-- txtTopCheckSel3:setFontSize(16)

	local txtTopCheck4 = GetElement(self.m_root,"txtTopCheck4_WndAscending",WZUILabelTTF)
	txtTopCheck4:setScale(0.7)
	-- txtTopCheck4:setFontSize(16)
	txtTopCheck4:setDimensions(GlobalMethod:CCSize(50))
	local txtTopCheckSel4 = GetElement(self.m_root,"txtTopCheckSel4_WndAscending",WZUILabelTTF)
	txtTopCheckSel4:setScale(0.7)
	-- txtTopCheckSel4:setFontSize(16)
	txtTopCheckSel4:setDimensions(GlobalMethod:CCSize(50))

	local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF)
	-- txtCheck5:setFontSize(16)
	txtCheck5:setScale(0.7)
	txtCheck5:setDimensions(GlobalMethod:CCSize(60,0))
	local txtCheckSel5 = GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF)
	txtCheckSel5:setScale(0.7)
	-- txtCheckSel5:setFontSize(16)
	txtCheckSel5:setDimensions(GlobalMethod:CCSize(60,0))

	GetElement(self.m_root,"txtPet_WndAscending",WZUILabelTTF):setScale(0.8)

	local txtMount = GetElement(self.m_root,"txtMount_WndAscending",WZUILabelTTF)
	txtMount:setScale(0.8)
	txtMount:setDimensions(GlobalMethod:CCSize(110,0))

	-- GetElement(self.m_root,"txtCheck4_WndAscending",WZUILabelTTF):setFontSize(18)
	-- GetElement(self.m_root,"txtCheckSel4_WndAscending",WZUILabelTTF):setFontSize(18)
	-- local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndAscending",WZUILabelTTF)
	-- txtCheck5:setFontSize(18)
	-- txtCheck5:setDimensions(GlobalMethod:CCSize(60,0))
	-- local txtCheckSel5 = GetElement(self.m_root,"txtCheckSel5_WndAscending",WZUILabelTTF)
	-- txtCheckSel5:setFontSize(18)
	-- txtCheckSel5:setDimensions(GlobalMethod:CCSize(60,0))

	local txtUpMount = GetElement(self.m_root,"txtUpMount_WndAscending",WZUILabelTTF)
	if txtUpMount then
		txtUpMount:setScale(0.8)
	end

	for i=1,3 do
		local txtMountM = GetElement(self.m_root,"txtMountM"..i.."_WndAscending",WZUILabelTTF)
		txtMountM:setScale(0.8)
		txtMountM:setDimensions(GlobalMethod:CCSize(80,0))
	end

	GetElement(self.m_root,"txtConNull4",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
	
	GetElement(WndAscending.m_root,"txtCostTab4",WZUIFreeTextBox):setScale(0.8)

	GetElement(self.m_root,"txtNoConfig1_WndAscending",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.45))
	GetElement(self.m_root,"txtNoConfig2_WndAscending",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.24))
end

------------------------------语言适配End----------------------------------------------------
