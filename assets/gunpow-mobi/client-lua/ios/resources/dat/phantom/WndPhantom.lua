--WndPhantom.lua
--@brief	WndPhantom的UI模块
--@date		2017/04/25
--@author	zsq
--@note		幻化主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantom:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)

	ProtocolProcessorMerge:regAll()
end

--@brief	加载动画
function WndPhantom:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpateDressSuitObserver(self) --注册多套时装

	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo() 
	--WndPhantom:setData()

	--self:_addTop()
	self:_addDressSuit()
end

function WndPhantom:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_huanhua.png",WndPhantom,WndPhantom.onCloseClick,true,false,false,"WndPhantom",{goldType=9})
end

function WndPhantom:onCloseClick() 
	--SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantom:onExit(element)
	ProtocolProcessorMerge:unregAll()
	CacheCenter:unregisterUpateDressSuitObserver(self)

	self:_unInit()
end


--@brief	背包接口
function WndPhantom:showWin()
	WZLog("WndPhantom:showWin")
	--if self.m_root == nil then  不需要判断，创建时如果之前有背包窗口，会先移除
		local wnd = WndPhantom:createElement()
		WindowManager:addWindow(wnd, WndPhantom, nil, nil, true)
	--end
end

--@brief	打开宝箱界面
function WndPhantom:onChest(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantomChest:show()
end

--@brief	进入皮肤合成
function WndPhantom:onChip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndBag:showBagSynthesis(5)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	获得途径
function WndPhantom:onJump(element) 
	WZLog("WndPhantom:onJump")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tSelectedCell == nil then return end
	WZLog("--&&&&&&&--121",Serialize(self.m_tSelectedCell))
	local channel = self.m_tSelectedCell.m_tData.channel
	--local tChannel = SplitStringWithSeparator(channel, ",")
	--if tonumber(tChannel[2]) ~= nil then
	--	JumpByUIId(tonumber(tChannel[1]), tonumber(tChannel[2]))
	--end

	WndFastGetItems:show(channel)
	--WndFastGetItems:show(20001)
end

--@brief	幻力等级tip
function WndPhantom:onTip(element) 
	WZLog("WndPhantom:onTip")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.shapeLeve ~= nil and self.shapeExp ~= nil then
		local con = GetElement(self.m_root,"conRight_WndPhantom",WZUIContainer)
		local tData = {lv=self.shapeLeve,exp=self.shapeExp}
		WndTips:show(element,con,37,tData,GlobalMethod:ccp(330,60))
	end
end

--@brief	使用皮肤
function WndPhantom:onUse(element) 
	WZLog("WndPhantom:onUse", self.m_tSelectedCell.m_tData.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantom.cancel = false
	WndPhantom.show = 1
	if self.m_nTab == 3 then
		local freeCon = GetElement(self.m_root,"freeCon_WndPhantom",WZUIFreeListContainer)
        self.conPosition3 = freeCon:getMoveElement():getPositionY()
	end
	ProtocolProcessorPhantom:send_SHAPE_UseShape(self.m_tSelectedCell.m_tData.id )
end

--@brief	取消皮肤
function WndPhantom:onCancel(element)
	WZLog("WndPhantom:onUse", self.m_tSelectedCell.m_tData.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantom.cancel = true
	ProtocolProcessorPhantom:send_SHAPE_UseShape(0 )
end

--@brief	使用体验卡
function WndPhantom:onUseCard(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tSelectedCell.m_tData == nil then return end
	--WndPhantomUse:show(self.m_tSelectedCell.m_tData)
	WndPhantom:showUseCard() 
end

--@brief	皮肤技能tip
function WndPhantom:onSkill(element) 
	WZLog("WndPhantom:onSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = GetElement(self.m_root,"conLeft_WndPhantom",WZUIContainer)
	if self.m_tSelectedCell ~= nil and self.m_tSelectedCell.m_tData ~= nil then
		local tData = self.m_tSelectedCell.m_tData
		local p = GetElement(self.m_root,"conRight_WndPhantom",WZUIContainer)
		WndTips:show(element,p,36,tData,GlobalMethod:ccp(410, -22))
	end
end

--@brief	幻化规则
function WndPhantom:onRule(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PHANTOM_DESC)
end

--@brief	设置是否展示皮肤
function WndPhantom:setShow(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local selCheckBox = GetElement(self.m_root,"setShow",WZUICheckBox)
    if selCheckBox:getCheckIndex() == 0 then
		--不是使用中无法展示
		if self.m_tSelectedCell ~= nil and self.m_tSelectedCell.m_tData ~= nil then
			local tData = self.m_tSelectedCell.m_tData
			if tData.use ~= true then
				local con = GetElement(self.m_root,"conLeft_WndPhantom",WZUIContainer)
				con:enableSchedule("setCheck",0)
				MsgBoxManager:showTipBox(LocalStrings.PHANTOM31)
				return
			end
		end
		--展示
		ProtocolProcessorPhantom:send_SHAPE_SetShow(1 )
	elseif selCheckBox:getCheckIndex() == 1 then
		--取消展示
		ProtocolProcessorPhantom:send_SHAPE_SetShow(0 )
    end
end

function WndPhantom:setCheck() 
	local con = GetElement(self.m_root,"conLeft_WndPhantom",WZUIContainer)
	con:disableSchedule()
	local selCheckBox = GetElement(self.m_root,"setShow",WZUICheckBox)
	selCheckBox:setCheckIndex(0)
end

function WndPhantom:onTab(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	WZLog("WndPhantom:onTab", tag)
	self.m_nTab = tag
	self:_update()
end

--合成皮肤
function WndPhantom:onActivate(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = self.m_tSelectedCell.tDebris
	if tData == nil then return end
	WZLog("WndPhantom:onActivate", Serialize(tData))
	local tempData = GDatatab_itemmerge["id_" .. tData.id]
	if not JudgeMoneyIsEnough(tempData.cost[1][1], tempData.cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId)
		then 
		return 
	end
	self.mergeId = self.m_tSelectedCell.m_tData.channel
   	ProtocolProcessorMerge:send_MERGE_MergeItem(tData.playerItemId, false, 4, 1)
end

function WndPhantom:synthesisSuccess()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	table.insert(NOTRECYCLESKINIDS, self.mergeId)
	WndRewardShow:showById({self.mergeId},{1})
	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
end

--皮肤升品
function WndPhantom:onImprove(element) 
	WZLog("WndPhantom:onImprove")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tSelectedCell == nil then return end
	ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo(self.m_tSelectedCell.m_tData.id )	
end

function WndPhantom:_update()
	if self.m_root == nil then return end
	local tag = self.m_nTab
	if tag == 1 then
		self.m_bShowAll = true
		self:update()
	elseif tag == 2 then
		self.m_bShowAll = false
		self:update()
	elseif tag == 3 then
		self:update3()
	end

    if WndPhantom.m_root ~= nil then
        GetElement(WndPhantom.m_root,"checkGroup_WndEquip",WZUICheckBoxGroup):setCheckIndex(tag - 1)
    end
end

--@brief   更新人物标题信息栏和战斗力信息栏
function WndPhantom:_updateFire()
	WZLog("WndPhantom:_updateFire")
	if self.m_root == nil then return end
	local tFire = CacheCenter:getPlayerInfo()
	--设置vip等级
	GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setText(tFire.vipLevel)
	if tonumber(tFire.vipLevel) >= 10 then
		GetElement(self.m_root,"imgVip_WndPlayer",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.33,0.2))
		GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.6,0.2))
	else
		GetElement(self.m_root,"imgVip_WndPlayer",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.42,0.2))
		GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.7,0.2))
	end

	--战斗力
	local fight = GetElement(self.m_root,"fight_WndPlayer",WZUILabelTTF)
	fight:setText(LocalStrings.COMBAT..":"..tFire.fighting)

	--设置等级名字经验进度条
	local nameTemplate = [[<T C="255,255,255" S="20" P="0" SC="79,60,48" SE="1" SS="4">%s</T><T C="128,54,13" S="22" P="0">(ID %s)</T>]]
	local name = GetElement(self.m_root,"name_WndPlayer",WZUIFreeTextBox)
	name:setShowText(string.format(nameTemplate, tFire.name, tostring(tFire.id)))
	local exp = tFire.exp
	local maxExp = tFire.maxExp
	local percent = tonumber(exp)*100/tonumber(maxExp)
	GetElement(self.m_root,"progrExpProgress_WndPlayer",WZUIProgress):setPercentage(percent)
	local txt = tostring(exp).."/"..tostring(maxExp)
	GetElement(self.m_root,"expPer_WndPlayer",WZUILabelTTF):setText(txt)

	--设置等级
	GetElement(self.m_root,"lv_WndPlayer",WZUILabelTTF):setText(LocalStrings.LV..tFire.level)
end

function WndPhantom:onVIP(element)
	WZLog("WndPhantom:onVIP")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = CacheCenter:getPlayerInfo() 
	local vipLevel = tData.vipLevel
	local tData = {vipLevel=vipLevel,other=self.m_bCheckOther,id=tData.id}
	local parent = WZUIContainer:luaTo(self.m_root:getChildElement("conFire_WndPhantom"))
	WndTips:show(GetElement(self.m_root,"conVip",WZUIContainer),self.m_root,20,tData,GlobalMethod:ccp(65,70))
	WndTips.m_root:setShowAll(true)
end

--@brief 	触摸开始回调
function WndPhantom:onTouchBegan(element, pt)
	-- body
	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示人物形象
function WndPhantom:showPlayer()
	if self.m_root == nil then return end
	local tEquip1 = CacheCenter:getPlayerItems()
	if tEquip1 == nil then return end
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end

	local tEquip = {}
	for k,v in pairs(tEquip1) do
		if v.isUse == true then
			table.insert(tEquip, v)
		end
	end
	local playerInfo = CacheCenter:getPlayerInfo()
	local sex = playerInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conRoleEquip_WndPhantom"))
	--local tData = self.m_tSelectedCell.m_tData
	local showId = WndPhantom.showId
    if not self.conPlayer then
		local conPlayer
		local isMonster = true
		if isMonster then
       		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.55,0.285))
		else
       		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, playerInfo.headColor ,playerInfo.bodyColor)
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.55,0.2))
		end

        self.conPlayer = conPlayer
        conP:addChild(conPlayer:getAnimNode(),5)
    end
	self:_updateFire()
end

function WndPhantom:update3() 
	if self.m_root == nil then return end
	local con = GetElement(self.m_root,"tableCon_WndPhantom",WZUITableContainer)
	con:setVisible(false)

	local freeCon = GetElement(self.m_root,"freeCon_WndPhantom",WZUIFreeListContainer)
	freeCon:removeAll()
	freeCon:setVisible(true)

	local tTable = self:sortPhantomData()

	local tDataList = {}
	for i=1,GetTableLen(GDatatab_fetters) do
		local tData = GDatatab_fetters["id_"..i]
		if tData ~= nil then
			local content = tData.content
			if CacheCenter:getPlayerInfo().sex == 1 then
				content = tData.content2
			end
			local temp = {}
			for j=1,#content[1] do
				if j == #content[1] then
					table.insert(temp, content[1][j])
					table.insert(tDataList, {fetter_id = i, fetter_first = (j<=2), content = CopyTable(temp)})
					temp = {}
					break
				else
					table.insert(temp, content[1][j])
				end
			end
		end
	end

	WZLog("WndPhantom:update3", Serialize(tDataList))

	for k=1,#tDataList do
		local active = true
		for i=1,#tDataList[k].content do
			local find = false
			for h,v in pairs(GDatatab_shape_skins) do
				if v.channel == tDataList[k].content[i] then
					--已拥有
					if v.own then
						if v.remainTime ~= -1 then
							active = false
						end
						find = true
						break
					end
				end
			end
			if not find then
				for h,v in pairs(GDatatab_shape_skins) do
					if v.channel == tDataList[k].content[i] then
						--未拥有
						if not v.own then
							if v.initial == 1 then
								active = false
							end
						end
					end
				end
			end
		end
		tDataList[k].active = active
	end

	local sortFetter = function(a, b)
		if a.active ~= b.active then
			return (not a.active)
		else
			return a.fetter_id < b.fetter_id
		end
	end

	table.sort(tDataList, sortFetter)

	for i=1,#tDataList do
		local celElement,tCell
		if #tDataList[i].content > 6 then
			celElement,tCell = CellPhantomList3:createElement()
		elseif #tDataList[i].content > 3 then
			celElement,tCell = CellPhantomList2:createElement()
		else
			celElement,tCell = CellPhantomList:createElement()
		end
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(tDataList[i])
			freeCon:pushBack(celElement)
		end 
	end
	freeCon:getMoveElement():setPositionY(freeCon:getMinPosition().y)
	if self.conPosition3 ~= nil then
        freeCon:getMoveElement():setPositionY(self.conPosition3)
	end
end

function WndPhantom:update() 
	if self.m_root == nil then return end
	--self.useShapeId = useShapeId
	--self.show = show
	--幻化等级
	local shapeLeve = self.shapeLeve or 0
	GetElement(self.m_root,"ttfPhantomLv",WZUILabelTTF):setText(LocalStrings.PHANTOM10.." Lv"..shapeLeve)

	local freeCon = GetElement(self.m_root,"freeCon_WndPhantom",WZUIFreeListContainer)
	freeCon:setVisible(false)

	local con = GetElement(self.m_root,"tableCon_WndPhantom",WZUITableContainer)
	con:cleanTable()
	con:setVisible(true)

	local tTable = self:sortPhantomData()

	local index = 0
	if self.m_bShowAll == true then
		for i=1,#tTable do
			local v = tTable[i]
			local cellElement,tCell
			cellElement,tCell = CellPhantom:createElement()
			cellElement:setTag(index)
			tCell:setData(v)
			tCell:setHighLight(false)
			cellElement:setScale(0.9)
			con:setCellElement(cellElement)
			index = index + 1
			--if index == 1 and v.own == true or v.use == true then
			if index == 1 then
				self.m_tSelectedCell = tCell
                WndPhantom.showId = tCell.m_tData.id
				tCell:setHighLight(true)
				self:onFresh(v)
			end
		end
	else
		for i=1,#tTable do
			local v = tTable[i]
			if v.own == true then

			local cellElement,tCell
			cellElement,tCell = CellPhantom:createElement()
			cellElement:setTag(index)
			tCell:setData(v)
			tCell:setHighLight(false)
			cellElement:setScale(0.9)
			con:setCellElement(cellElement)
			index = index + 1
			--if index == 1 and v.own == true or v.use == true then
			if index == 1 then
				self.m_tSelectedCell = tCell
                WndPhantom.showId = tCell.m_tData.id
				tCell:setHighLight(true)
				self:onFresh(v)
			end

			end
		end
	end
end

function WndPhantom:sortPhantomData()
	local mySex = CacheCenter:getPlayerInfo().sex
	local tTable = {}
	local ownNames = {}
	--先放入已拥有的皮肤
	for k,v in pairs(GDatatab_shape_skins) do
		v.own = false
		v.use = false
	end
	for i=1,#self.m_tDataList do
		local tData1 = GDatatab_shape_skins["id_"..self.m_tDataList[i].shapeId]
		tData1.own = true
		tData1.remainTime = self.m_tDataList[i].remainTime
		if tData1.id == self.useShapeId then
			tData1.use = true
		end
		table.insert(tTable, tData1)
		table.insert(ownNames, tData1.name)
	end

	for k,v in pairs(GDatatab_shape_skins) do
		if (not utilsValueInTable(v.name, ownNames)) and (v.initial==1) and (v.sex == mySex or v.sex == 2) then
			table.insert(tTable, v)
		end
	end
	for i=1,#tTable do
		local v = tTable[i]
		--v.own = false
		--for i=1,#self.m_tDataList do
		--	if v.id == self.m_tDataList[i].shapeId then
		--		v.own = true
		--		v.remainTime = self.m_tDataList[i].remainTime
		--	end
		--end
		--if v.id == self.useShapeId then
		--	v.use = true
		--else
		--	v.use = false
		--end

		--碎片数量
		local itemId = v.channel
		local needNum
		local debrisId 
		for k,v in pairs(GDatatab_itemmerge) do
			if v.id >= 8000 and v.id < 10000 and v.items[1][1] == itemId then
				debrisId = v.id
				needNum = v.scrap[1][2]
			end
		end
		--已拥有，升品数量
		if v.own then
			if v.sp_cost == -1 then
				needNum = 1
			else
				debrisId = v.sp_cost[1][1]
				needNum = v.sp_cost[1][2]
			end
		end
		local tDebris = CacheCenter:getPlayerItemById(debrisId)
		local debrisNum = 0
		if tDebris ~= nil then
			debrisNum = tDebris.lastNum
		else
			debrisNum = 0
		end
		v.enough = (debrisNum>=needNum)
	end
	table.sort(tTable, sortPhantom)

	return tTable
end

--@brief	选中不同皮肤时刷新界面
function WndPhantom:onFresh(tData) 
	WZLog("WndPhantom:onFresh")
	if self.m_root == nil then return end
	local qualityName = {LocalStrings.PHANTOM12, LocalStrings.PHANTOM13, LocalStrings.PHANTOM14, LocalStrings.PHANTOM15}
	--皮肤形象
	self:showPlayer()
	--皮肤名字
	GetElement(self.m_root,"ttfName",WZUILabelTTF):setText("【"..qualityName[tData.quality].."】"..tData.name)
	GetElement(self.m_root,"ttfName",WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
	--幻力值
	GetElement(self.m_root,"ttfMonster",WZUILabelTTF):setText(LocalStrings.PHANTOM8.."+"..tData.shape_exp)
	--被动技能按钮
	local skillId = tData.passive_skill[1][1]
	local tSkill = GDatatab_skill["id_"..skillId]
	GetElement(self.m_root,"imgSkill1",WZUI9Image):setFile(tSkill.icon)
	GetElement(self.m_root,"imgSkillL",WZUIImage):setFile(tSkill.lv_icon)
	--剩余时间
	self:setTimer()

	GetElement(self.m_root,"btnUse",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnUseCard",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnInUse",WZUIButton):setVisible(false)
	--幻化按钮
	if tData.own == false and tData.use == false then
		--皮肤未获得
		GetElement(self.m_root,"btnUse",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnUseCard",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(true)
		GetElement(self.m_root,"setShow",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"ttfSetShow",WZUILabelTTF):setVisible(false)
		GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(false)
		--激活按钮
		if self.m_tSelectedCell.enough then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(true)
		end
		--跳转
		local channel = tData.channel
		local tChannel = SplitStringWithSeparator(channel, ",")
		if tonumber(tChannel[2]) ~= nil then
			GetElement(self.m_root,"btnGet",WZUIButton):setVisible(true)
			GetElement(self.m_root,"ttfGet",WZUILabelTTF):setText("")
		else
			GetElement(self.m_root,"btnGet",WZUIButton):setVisible(true)
			GetElement(self.m_root,"ttfGet",WZUILabelTTF):setText("")
		end

		--GetElement(self.m_root,"btnUseCard",WZUIButton):setTouchEnable(false)
		GetElement(self.m_root,"btnUseCard",WZUIButton):setVisible(false)
		--获得皮肤对应的体验卡id
		local cardIds = {}
		for i=0,999 do
			local tItem = GDatatab_item["id_"..(8000+i)]
			--if tItem == nil then break end
			if tItem ~= nil and tItem.property[1][1] == tData.id then
				table.insert(cardIds, tItem.id)
			end
		end
		WZLog("kljsssssssjjjjjjjj", tData.id, Serialize(cardIds))
		for i=1,#cardIds do
			if CacheCenter:getPlayerItemCountById(cardIds[i]) > 0 then
				GetElement(self.m_root,"btnUseCard",WZUIButton):setTouchEnable(true)
				GetElement(self.m_root,"btnUseCard",WZUIButton):setVisible(true)
				break
			end
		end
	else
		--皮肤已获得
		GetElement(self.m_root,"btnUse",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnUseCard",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"setShow",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"ttfSetShow",WZUILabelTTF):setVisible(true)
		GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"ttfGet",WZUILabelTTF):setText("")
		GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(false)
		--升品按钮
		if self.m_tSelectedCell.enough then
			GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(true)
		end
		--展示设置
		local selCheckBox = GetElement(self.m_root,"setShow",WZUICheckBox)
		selCheckBox:setCheckIndex(0)

		if tData.use == true then
			GetElement(self.m_root,"btnUse",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnInUse",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnInUse",WZUIButton):setVisible(false)
			selCheckBox:setCheckIndex(tonumber(self.show))
		end

		--体验皮肤，隐藏升品按钮
		if tData.remainTime ~= -1 then
			GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(true)
		end
		--激活按钮
		if self.m_tSelectedCell.enough then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(true)
		else
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		end

		--已经有永久
		if tData.remainTime == -1 then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		end

		--已经升品到最高级
		if tData.sp_cost == -1 then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(false)
		end

		--激活按钮
		-- if self.m_tSelectedCell.enough then
		-- 	GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(true)
		-- else
		-- 	GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		-- end

		--已经有永久
		if tData.remainTime == -1 then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
		end

		--已经升品到最高级
		if tData.sp_cost == -1 then
			GetElement(self.m_root,"btnActivate",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnImprove",WZUIButton):setVisible(false)
		end
	end

end

function sortPhantom(a, b)
	if a.use ~= b.use then
		return a.use
	elseif a.enough ~= b.enough then
		return a.enough
		--if a.own ~= b.own then
		--	return not a.own
		--else
		--	return a.enough
		--end
	elseif a.own ~= b.own then
		return a.own 
	elseif a.quality ~= b.quality then
		return a.quality > b.quality
	elseif a.id ~= b.id then
		return a.id > b.id
	end
end

--@brief	角色形象点击响应
function WndPhantom:onClickRole(element)
	WZLog("WndPhantom:onClickRole")
	if self.conPlayer == nil then return end

		local random = os.time()%2 + 1
		if random == 1 then
			self.conPlayer:play("run",false)
		elseif random == 2 then
			self.conPlayer:play("win",false)
		end
   		self.m_root:enableSchedule("updateRole")
end

--@brief	角色形象动画完成回调(无坐骑时)
function WndPhantom:updateRole(element,t)
    WZLog("WndPhantom:updateRole")

    if not self.conPlayer:isPlaying() then
        local isEnd = self.conPlayer:isCurrentAnimationDone()
        if isEnd == true then
			self.conPlayer:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

--@brief 	添加时装套装入口
function WndPhantom:_addDressSuit()
	-- body
	if CheckButtonOpen(144, false) then
		local conForDressSuit = GetElement(self.m_root, "conForDressSuit_WndPhantom", WZUIContainer)
		if conForDressSuit then
			local wndDress, tCell = WndDressSuit:createElement()
			if wndDress and tCell then
				tCell:setType(2)
				self.m_tCellDressSuit = tCell
				conForDressSuit:addChild(wndDress)
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndPhantom:_adaptLanguage_en(  )
	local txtUseCard1 = GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF)
	txtUseCard1:setDimensions(GlobalMethod:CCSize(110,0))
	txtUseCard1:setScale(0.6)
	local txtUseCard2 = GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF)
	txtUseCard2:setDimensions(GlobalMethod:CCSize(110,0))
	txtUseCard2:setScale(0.6)
	local txtNoUse2 = GetElement(self.m_root,"txtNoUse2_WndPhantom",WZUILabelTTF)
	txtNoUse2:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse2:setScale(0.6)

	-- local txtUse1 = GetElement(self.m_root,"txtUse1_WndPhantom",WZUILabelTTF)
	-- txtUse1:setScale(0.8)
	-- local txtUse2 = GetElement(self.m_root,"txtUse2_WndPhantom",WZUILabelTTF)
	-- txtUse2:setScale(0.8)
	local txtNoUse1 = GetElement(self.m_root,"txtNoUse1_WndPhantom",WZUILabelTTF)
	txtNoUse1:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse1:setScale(0.6)

	-- GetElement(self.m_root,"btnInUse1_WndPhantom",WZUILabelTTF):setScale(0.8)
	-- GetElement(self.m_root,"btnInUse2_WndPhantom",WZUILabelTTF):setScale(0.8)

	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)

	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.8)

	-- for i=1,3 do
	-- 	local txtUse = GetElement(self.m_root,"btnInUse"..i.."_WndPhantom",WZUILabelTTF)
	-- 	txtUse:setScale(0.8)
	-- end
	
	local ttfSetShow = GetElement(self.m_root,"ttfSetShow",WZUILabelTTF)
	ttfSetShow:setDimensions(GlobalMethod:CCSize(80))

	GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setScale(0.8)

	local txtGet = GetElement(self.m_root,"txtGet_WndPhantom",WZUILabelTTF)
	txtGet:setScale(0.7)
end

function WndPhantom:_adaptLanguage_th(  )
	GetElement(self.m_root,"ttfPhantomLv",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.825))

	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.9)

	for i=1,2 do
		local txtUse = GetElement(self.m_root,"txtUse"..i.."_WndPhantom",WZUILabelTTF)
		txtUse:setScale(0.7)
	end
end

function WndPhantom:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF):setScale(0.55)
	for i = 1, 4 do
		local cardNum = GetElement(self.m_root,"cardNum"..i,WZUILabelTTF)
		cardNum:setScale(0.9)
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setScale(0.9)
		cardTime:setRelativePosition(GlobalMethod:ccp(0.175,0.5))
	end

	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)
	--ttfName:setRelativePosition(GlobalMethod:ccp(0.51,0.82))

	for i=1,2 do
		local txtNoUse = GetElement(self.m_root,"txtNoUse"..i.."_WndPhantom",WZUILabelTTF)
		txtNoUse:setDimensions(GlobalMethod:CCSize(100,0))
		txtNoUse:setScale(0.7)
	end

	GetElement(self.m_root,"txtCheckInfo0_1_WndPhantom",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtCheckInfo0_2_WndPhantom",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtCheckInfo1_1_WndPhantom",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtCheckInfo1_2_WndPhantom",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtCheckInfo2_1_WndPhantom",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtCheckInfo2_2_WndPhantom",WZUILabelTTF):setScale(0.85)
end

function WndPhantom:_adaptLanguage_pt(  )
	for i=1,2 do
		local txtUseCard = GetElement(self.m_root,"txtUseCard"..i.."_WndPhantom",WZUILabelTTF)
		txtUseCard:setDimensions(GlobalMethod:CCSize(110,0))
		txtUseCard:setScale(0.6)
	end
	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)

	local txtChest = GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF)
	txtChest:setScale(0.8)
	txtChest:setDimensions(GlobalMethod:CCSize(130,0))

	for i = 1, 4 do
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setDimensions(GlobalMethod:CCSize(150))
		cardTime:setRelativePosition(GlobalMethod:ccp(0.155,0.5))
	end

	for i=1,2 do
		local txtNoUse = GetElement(self.m_root,"txtNoUse"..i.."_WndPhantom",WZUILabelTTF)
		txtNoUse:setDimensions(GlobalMethod:CCSize(100,0))
		txtNoUse:setScale(0.7)
	end

	local ttfSetShow = GetElement(self.m_root,"ttfSetShow",WZUILabelTTF)
	ttfSetShow:setDimensions(GlobalMethod:CCSize(80))

	for i=1,3 do
		GetElement(self.m_root,"btnInUse"..i.."_WndPhantom",WZUILabelTTF):setScale(0.6)
	end

	GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setScale(0.8)

	local txtGet = GetElement(self.m_root,"txtGet_WndPhantom",WZUILabelTTF)
	txtGet:setScale(0.7)
	txtGet:setDimensions(GlobalMethod:CCSize(160,0))
end

function WndPhantom:_adaptLanguage_es(  )
	for i=1,2 do
		local txtNoUse = GetElement(self.m_root,"txtNoUse"..i.."_WndPhantom",WZUILabelTTF)
		txtNoUse:setDimensions(GlobalMethod:CCSize(100,0))
		txtNoUse:setScale(0.7)
	end

	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)

	for i=1,2 do
		local txtUseCard = GetElement(self.m_root,"txtUseCard"..i.."_WndPhantom",WZUILabelTTF)
		txtUseCard:setDimensions(GlobalMethod:CCSize(110,0))
		txtUseCard:setScale(0.6)
	end

	for i = 1, 4 do
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setDimensions(GlobalMethod:CCSize(150))
		cardTime:setRelativePosition(GlobalMethod:ccp(0.155,0.5))
	end

	local txtChest = GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF)
	txtChest:setScale(0.8)
	txtChest:setDimensions(GlobalMethod:CCSize(130,0))

	for i=1,2 do
		GetElement(self.m_root,"txtUse"..i.."_WndPhantom",WZUILabelTTF):setScale(0.9)
	end

	for i=1,3 do
		GetElement(self.m_root,"btnInUse"..i.."_WndPhantom",WZUILabelTTF):setScale(0.6)
	end

	local ttfSetShow = GetElement(self.m_root,"ttfSetShow",WZUILabelTTF)
	ttfSetShow:setDimensions(GlobalMethod:CCSize(80))

	GetElement(WndPhantom.m_root,"txtLeftTime",WZUILabelTTF):setScale(0.8)

	local txtUse1 = GetElement(self.m_root,"txtUse1_WndPhantom",WZUILabelTTF)
	txtUse1:setScale(0.45)
	txtUse1:setDimensions(GlobalMethod:CCSize(80,0))
	local txtUse2 = GetElement(self.m_root,"txtUse2_WndPhantom",WZUILabelTTF)
	txtUse2:setScale(0.45)
	txtUse2:setDimensions(GlobalMethod:CCSize(80,0))
	local txtNoUse1 = GetElement(self.m_root,"txtNoUse1_WndPhantom",WZUILabelTTF)
	txtNoUse1:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse1:setScale(0.6)
	
	local txtUseCard1 = GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF)
	txtUseCard1:setDimensions(GlobalMethod:CCSize(120,0))
	txtUseCard1:setScale(0.5)
	local txtUseCard2 = GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF)
	txtUseCard2:setDimensions(GlobalMethod:CCSize(120,0))
	txtUseCard2:setScale(0.5)
	local txtNoUse2 = GetElement(self.m_root,"txtNoUse2_WndPhantom",WZUILabelTTF)
	txtNoUse2:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse2:setScale(0.6)

	local txtImprove = GetElement(self.m_root,"txtImprove_WndPhantom",WZUILabelTTF)
	txtImprove:setDimensions(GlobalMethod:CCSize(160,0))
	txtImprove:setScale(0.7)
	
	local txtGet = GetElement(self.m_root,"txtGet_WndPhantom",WZUILabelTTF)
	txtGet:setScale(0.7)
	txtGet:setDimensions(GlobalMethod:CCSize(160,0))
end

function WndPhantom:_adaptLanguage_tr(  )
	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(18)

	local txtChest = GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF)
	txtChest:setScale(0.8)
	txtChest:setDimensions(GlobalMethod:CCSize(130,0))
	
	GetElement(self.m_root,"ttfPhantomLv",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.825))
	for i = 1, 4 do
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setDimensions(GlobalMethod:CCSize(150))
		cardTime:setRelativePosition(GlobalMethod:ccp(0.155,0.5))
	end
	
	GetElement(self.m_root,"btnInUse1_WndPhantom",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"btnInUse2_WndPhantom",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"btnInUse3_WndPhantom",WZUILabelTTF):setScale(0.5)

	local txtUse1 = GetElement(self.m_root,"txtUse1_WndPhantom",WZUILabelTTF)
	txtUse1:setScale(0.6)
	txtUse1:setDimensions(GlobalMethod:CCSize(80,0))
	local txtUse2 = GetElement(self.m_root,"txtUse2_WndPhantom",WZUILabelTTF)
	txtUse2:setScale(0.6)
	txtUse2:setDimensions(GlobalMethod:CCSize(80,0))
	local txtNoUse1 = GetElement(self.m_root,"txtNoUse1_WndPhantom",WZUILabelTTF)
	txtNoUse1:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse1:setScale(0.6)

	local txtUseCard1 = GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF)
	txtUseCard1:setDimensions(GlobalMethod:CCSize(80,0))
	txtUseCard1:setScale(0.6)
	local txtUseCard2 = GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF)
	txtUseCard2:setDimensions(GlobalMethod:CCSize(80,0))
	txtUseCard2:setScale(0.6)
	local txtNoUse2 = GetElement(self.m_root,"txtNoUse2_WndPhantom",WZUILabelTTF)
	txtNoUse2:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse2:setScale(0.6)

	local txtImprove = GetElement(self.m_root,"txtImprove_WndPhantom",WZUILabelTTF)
	txtImprove:setScale(0.75)
end
-------------------------------------语言适配End--------------------------------------------
