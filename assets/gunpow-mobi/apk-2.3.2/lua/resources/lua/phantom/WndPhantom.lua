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
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self:_getMaxStarLevel()

	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo() 
	--WndPhantom:setData()

	--self:_addTop()
	self:_addDressSuit()

    --跑步入场
    self.firstEntry = true
    WndPhantom:showRunAni()
end

--@brief    展示跑动效果
function WndPhantom:showRunAni()
    -- body
    if not self.m_bIsFirst then return end 
    self.m_nRunIndex = 1 
    self.m_tOldFootPos = nil 
    local conRoleEquip = GetElement(self.m_root, "conRoleEquip_WndPhantom", WZUIContainer)
    conRoleEquip:enableSchedule("_updateFootMarkPosition")
end

--@brief    刷新角色位置
function WndPhantom:_updateFootMarkPosition(element)
    -- body
    if self.conPlayer == nil then return end 

    if self.firstEntry == true then
        self.firstEntry = false
        self.m_nRunIndex = 2
        local pos = self.conPlayer:getPosition()
        pos.x = pos.x - 300
        self.conPlayer:setPosition(pos)
    end

    local pos = self.conPlayer:getPosition()
    pos.x = pos.x + 10
    if self.m_bIsFirst then 
        self.m_nMoveMaxDis = 300 
        --self.conPlayer:setFlipX(true)
        self.m_bIsFirst = false 
        self.conPlayer:play(g_tRoleAnitionName[3], true)
    end
    self.conPlayer:setPosition(pos)

    if self.m_nMoveMaxDis > 0 then 
        self.m_nMoveMaxDis = self.m_nMoveMaxDis - 10
    else
        if self.m_nRunIndex == 1 then 
            self.m_nRunIndex = 2
            self.m_nMoveMaxDis = 300 
            pos.x = pos.x - 600
            self.conPlayer:setPosition(pos)
        elseif self.m_nRunIndex == 2 then 
            self.conPlayer:play("wait0", true)
            self.conPlayer:setFlipX(false)
            self.conPlayer:setPosition(self.firstPost)
            element:disableSchedule()
            self.m_bIsFirst = true
        end
    end
end


--@brief    播放攻击动画
function WndPhantom:playAttackAni()
	--关闭跑步入场动画
	local conRoleEquip = GetElement(self.m_root, "conRoleEquip_WndPhantom", WZUIContainer)
    conRoleEquip:disableSchedule()
    -- self.m_nMoveMaxDis = 0

	self.nAttackStep = 1
	conRoleEquip:enableSchedule("_updateAttack")
end

--@brief    播放攻击动画
function WndPhantom:_updateAttack(element)	
	-- id = 4,set = 1,human_act = "attackstart1-s",monster_act = "shoot_1"
	-- id = 5,set = 1,human_act = "attackstart1-s2",monster_act = "shoot_2"
	-- id = 1,set = 1,human_act = "attack1-s",monster_act = "shoot_3"
	if self.nAttackStep == 1 then
		self.nAttackStep = self.nAttackStep + 1
		self.conPlayer:play("attackstart1-s",false)
	end
	local isEnd = self.conPlayer:isCurrentAnimationDone()
	if isEnd == true then
		if self.nAttackStep == 1 then

		elseif self.nAttackStep == 2 then
			self.nAttackStep = self.nAttackStep + 1
			self.conPlayer:play("attackstart1-s2",false)
		elseif self.nAttackStep == 3 then
			self.nAttackStep = self.nAttackStep + 1
			self.conPlayer:play("attack1-s",false)
		else
			local conRoleEquip = GetElement(self.m_root, "conRoleEquip_WndPhantom", WZUIContainer)
			conRoleEquip:disableSchedule()
			self.conPlayer:play("wait0",true)
		end
	end
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
	-- ProtocolProcessorMerge:unregAll()
	CacheCenter:unregisterUpateDressSuitObserver(self)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

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
	local channel 
	if self.m_tSelectedCell.m_tData == nil then
		channel = self.RefineData.channel
	else 
		channel = self.m_tSelectedCell.m_tData.channel
	end

	WndFastGetItems:show(channel)
end

--@brief	幻力等级tip
function WndPhantom:onTip(element) 
	WZLog("WndPhantom:onTip")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.shapeLeve ~= nil and self.shapeExp ~= nil then
		local con = GetElement(self.m_root,"conPlayer_WndPhantom",WZUIContainer)
		local tData = {lv=self.shapeLeve, exp=self.shapeExp}
		WndTips:show(element, WndPets.m_root,37,tData,GlobalMethod:ccp(-90,150), true)
	end
end

--@brief	使用皮肤
function WndPhantom:onUse(element, tData) 
	WZLog("WndPhantom:onUse")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantom.cancel = false
	WndPhantom.show = 1
	if self.m_nTab == 3 then
		local freeCon = GetElement(self.m_root,"freeCon_WndPhantom",WZUIFreeListContainer)
        self.conPosition3 = freeCon:getMoveElement():getPositionY()
	end
	ProtocolProcessorPhantom:send_SHAPE_UseShape(tData.id)
end

function WndPhantom:shwoFightBtn(statu)
	-- body
	if statu then
		GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(false)
	else 
		GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(true)	
	end
end
--@brief	取消皮肤
function WndPhantom:onCancel(element, tData)
	WZLog("WndPhantom:onCancel")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantom.cancel = true
	ProtocolProcessorPhantom:send_SHAPE_UseShape(0)
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
	local nTag = element:getTag()

	local con = GetElement(self.m_root,"conLeft_WndPhantom",WZUIContainer)
	if self.m_tSelectedCell ~= nil and self.m_tSelectedCell.m_tData ~= nil then
		local tData = self.m_tSelectedCell.m_tData
		local p = GetElement(self.m_root,"conRight_WndPhantom",WZUIContainer)
		if nTag == 1 then 
			WndTips:show(element,p,36,tData,GlobalMethod:ccp(410, -22))
		else
			local tempData = CopyTable(tData)
			if tempData.active_skill == -1 then 
				local tLastData = self:_getMaxQualityConfig(tData)
				if tLastData and tLastData.active_skill ~= -1 then 
					tempData.passive_skill = tLastData.active_skill
					tempData.addAtt = true
				end
			else
				tempData.passive_skill = tData.active_skill
			end
			WndTips:show(element, p, 36, tempData, GlobalMethod:ccp(410, -22))
		end
	end
end

--@brief	点击攻击类型tips
function WndPhantom:onClickAttackTypeTips(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = GetElement(self.m_root,"conPlayer_WndPhantom",WZUIContainer)
	local tData = {}
	tData.desc = LocalStrings.PHANTOM34
	tData.size = GlobalMethod:CCSize(275,100)
    WndTips:show(element, con, 73, tData, GlobalMethod:ccp(400, -40))
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
end

function WndPhantom:onFighting()
	-- body
	if self.m_phantomList == {} or self.m_phantomList == nil then return end
	for i = 1,#self.m_phantomList do
		if WndPhantom.showId == self.m_phantomList[i].m_tData.id then
			self.m_phantomList[i]:onFighting()
		end
	end 
	-- self.m_tSelectedCell:onFighting()
end

function WndPhantom:onTab(element) 
 	--body
	local tag = tonumber(element:getTag())
	if tag == 2 then 
    	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    	if self.m_tSelectedCell.m_tData == nil then
    		tData = self.m_tSelectedCell.m_tData
    	else 
    		tData = self.RefineData
    		if tData == nil or next(tData) == nil then
	    		local tTable = self:sortPhantomData()
	    		tData = tTable[1]
	    	end
    	end

	    if tData.advancedLevel >= self.maxStarLevel then
	        MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT5)
	        return
	    end
	    if not tData.activeRefineStatus then 
	    	MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT12)
	    	return 
	    end
    	if self.m_nTab == tag then return end 
    	self.m_nTab = tag
		self:_showAdvancedContent()
		return 
	elseif tag == 4 then 
		self:onImprove(element)
		return 
	elseif tag == 5 then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    	
    	local tData = self.m_tSelectedCell.m_tData
		if tData.remainTime ~= -1 then
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT42)
			return 
		end

    	if self.m_nTab == tag then return end 
    	self.m_nTab = tag
		self:_showRefineContent()
		return 
	end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndPhantom:onTab", tag)
	self.m_nTab = tag
	if tag == 3 then 
		self:setBtnState()
		local tData = {}
		if self.m_tSelectedCell.m_tData == nil then
    		tData = self.RefineData
    	else 
    		tData = self.m_tSelectedCell.m_tData
    	end
		self:onFresh(tData) 
	end
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
	WndPets:updatePartner()

	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
end

--皮肤升品
function WndPhantom:onImprove(element) 
	WZLog("WndPhantom:onImprove")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tSelectedCell == nil then return end
	local tData = {}
	if self.m_tSelectedCell.m_tData == nil then
		tData = self.RefineData
	else 
		tData = self.m_tSelectedCell.m_tData
	end
	if tData.own == false and tData.use == false then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT2)
		return
	else
		if tData.remainTime ~= -1 then
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT3)
			return 
		end
		if tData.sp_cost == -1 then
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT4)
			return 
		else
			if tData.quality == 4 then 
				-- MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT17)
				JumpByUIId(269)
				return 
			end
		end
		if self.m_tSelectedCell.enough then
			self.m_nNextShapeId = tData.next_shape
			ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo(tData.id)	
		else
			local channel = tData.channel
			WndFastGetItems:show(channel)
		end
	end
end

--@brief 	点击进阶按钮回调
function WndPhantom:onClickAdvanced(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大进阶等级，无需进阶
    -- local tData = self.m_tSelectedCell.m_tData
    local tData = {}
    if self.m_tSelectedCell.m_tData == nil then
    	tData = self.RefineData
    else 
    	tData = self.m_tSelectedCell.m_tData
    end
    if tData.advancedLevel >= self.maxStarLevel then
        MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT5)
        return
    end

    -- 等级不足
    local nextLevel = tData.advancedLevel + 1
    local nextStartData = GDatatab_shape_advanced["id_"..nextLevel]
    if tData.quality < nextStartData.need_quality then
        MsgBoxManager:showTipBox(string.format(LocalStrings.PHANTOM_NEWTEXT6, LocalStrings.PHANTOM_NEWTEXT7[nextStartData.need_quality]))
        return
    end

    -- 进阶丹不足
    local myPill = CacheCenter:getPlayerItemCountById(nextStartData.cost[1][1])
    local costId, costNum = nextStartData.cost[1][1], nextStartData.cost[1][2]
    if myPill < costNum then
        local tItem = GDatatab_item["id_"..tostring(costId)]
		WndFastGetItems:show(costId)
        return
    end
    self.isClick = false
    
    ProtocolProcessorPhantom:send_SHAPE_Operate(tData.id, 4)
end

--@brief 	點擊返回按钮回调
function WndPhantom:onClickBack(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_nTab == 2 then 
		GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conForList_WndPhantom", WZUIContainer):setVisible(true)

		GetElement(self.m_root, "conCurStars_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conForAdvance_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(false)

		self.m_nTab = 1
		self:setBtnState()
	elseif self.m_nTab == 3 then 
		GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conForList_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "tableCon_WndPhantom", WZUITableContainer):setVisible(true)

		GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conForFetter_WndPhantom", WZUIContainer):setVisible(false)

		self.m_nTab = 1
		self:setBtnState()
		local tData = self.m_tSelectedCell.m_tData
		self:onFresh(tData) 
	elseif self.m_nTab == 5 then 
		GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conForList_WndPhantom", WZUIContainer):setVisible(true)

		GetElement(self.m_root, "conForRefine_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(false)
		
		self.m_nTab = 1
		self:setBtnState()
	end
end

--@brief 	點擊激活炼化按钮回调
function WndPhantom:onClickActiveRefine(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local tData = self.m_tSelectedCell.m_tData

	local cost = self:_getRefineCost(tData, 1)
	if not JudgeMoneyIsEnough(cost[1][1], cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiaToActiveRefine) then
		return 
	end

	self:sureUseDiaToActiveRefine()
end

--@brief 	确定激活炼化
function WndPhantom:sureUseDiaToActiveRefine()
	--body
	local tData = self.m_tSelectedCell.m_tData

	ProtocolProcessorPhantom:send_SHAPE_Operate(tData.id, 1)
end

--@brief 	點擊炼化按钮回调
function WndPhantom:onClickRefine(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = self.m_tSelectedCell.m_tData
	local refineProNum = self:getRefinePropertyNum(tData)
	if not self.m_bCanStartRefine then return end 
	if refineProNum == 0 then return end 
	
	self.m_nRefineTag = element:getTag()

	local nIndex = self:getWhetherNeedRefine(tData)
	if nIndex == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT32)
		return 
	elseif nIndex == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_NEWTEXT33)
		return 
	end

	local cost
	if self.m_bIsUseDiamondRefine then 
		cost = self:_getRefineCost(tData, 3)
	else
		cost = self:_getRefineCost(tData, 2)
	end

	if not JudgeMoneyIsEnough(cost[refineProNum][1], cost[refineProNum][2] * self.m_nRefineTag, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiaToRefine) then
		return 
	end

	self:sureUseDiaToRefine()
end

--@brief 	确定炼化
function WndPhantom:sureUseDiaToRefine()
	-- body
	local tData = self.m_tSelectedCell.m_tData
	local refineType = 2 
	if self.m_bIsUseDiamondRefine then 
		refineType = 3
	end
	WZLog("WndPhantom:sureUseDiaToRefine", tData.id, refineType, self.m_nRefineTag)
	self:setRefineCtr(false)
	ProtocolProcessorPhantom:send_SHAPE_Refine(tData.id, refineType, self.m_nRefineTag)
end

--@brief 	點擊保存按钮回调
function WndPhantom:onClickSaveRefine(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTag = element:getTag()
	local tData = self.m_tSelectedCell.m_tData

	if nTag == 1 then 			--取消保存
		ProtocolProcessorPhantom:send_SHAPE_Operate(tData.id, 3)
	elseif nTag == 2 then 		--保存
		ProtocolProcessorPhantom:send_SHAPE_Operate(tData.id, 2)
	end
end

--@brief 	點擊使用钻石炼化按钮回调
function WndPhantom:onClickUseDia(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	
	self.m_bIsUseDiamondRefine = not self.m_bIsUseDiamondRefine 
	self:_refineCost()
end

--@brief 	点击已拥有的属性锁定回调
function WndPhantom:onClickLockPro(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    local tData = self.m_tSelectedCell.m_tData
    if tData.quality == 5 and nTag == 6 then 
    else
    	if nTag > tData.quality then return end 
    end

    local nProperty = tData.property[nTag][1]
    ProtocolProcessorPhantom:send_SHAPE_ChangeRefineStatus(tData.id, nProperty)
end

--@brief 	点击查看属性
function WndPhantom:onClickProperty(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local parentElement = GetElement(self.m_root, "conPlayer_WndPhantom", WZUIContainer)

	local nNowOwnNum = #self.m_tDataList
	local tData={}
    tData.showType = 5

    tData.curData = self.m_tSelectedCell.m_tData
    tData.totalPro = self:getTotalProperty()
    tData.fighting = WndCard:_caculateFighting(tData.totalPro)
    tData.ownNum = nNowOwnNum .. "/" .. self.m_nTotalSkinNum

    WndTips:show(element, parentElement, 63, tData, GlobalMethod:ccp(100,300))
end

function WndPhantom:_update()
	if self.m_root == nil then return end
	local tag = self.m_nTab
	if tag == 1 then
		self.m_bShowAll = true
		self:update()
		-- self:setBtnState()
	elseif tag == 2 then
		self.m_bShowAll = false
		self:update()
	elseif tag == 3 then
		self:update3()
	end
end

--@brief   更新人物标题信息栏和战斗力信息栏
--@param 	tData : 当前选中的皮肤的数据
function WndPhantom:_updateFire(tData)
	WZLog("WndPhantom:_updateFire")
	if self.m_root == nil then return end

	--战斗力
	local txtFightWord = GetElement(self.m_root, "txtFightWord_WndPhantom", WZUILabelTTF)
	if txtFightWord then 
		txtFightWord:setText(LocalStrings.COMBAT)
		CCNodePropertySetter:setValue(txtFightWord, "skewX", 10)
	end
	local fight = GetElement(self.m_root, "fight_WndPlayer", WZUILabelAtlasFont)
	if tData.fighting then 
		fight:setText(tData.fighting)
	else
		local property = {}
		for i = 1, tData.quality do
			table.insert(property, tData.property[i])
		end
		local fighting = WndCard:_caculateFighting(property)
		fight:setText(fighting)
	end

	--碎片数量
	local itemId = tData.channel
	local needNum = 1
	local debrisId 
	for k,v in pairs(GDatatab_itemmerge) do
		if ((v.id >= 8000 and v.id < 10000) or (v.id >= 161000 and v.id < 163000) or (v.id >= 157000 and v.id < 160000)) and v.items[1][1] == itemId then
			debrisId = v.id
			needNum = v.scrap[1][2]
		end
	end
	--已拥有，升品数量
	if tData.own then
		if tData.remainTime and tData.remainTime == -1 then 
			if tData.sp_cost == -1 then
				needNum = 1
			else
				debrisId = tData.sp_cost[1][1]
				needNum = tData.sp_cost[1][2]
			end
		end
	end
	local tDebris = CacheCenter:getPlayerItemById(debrisId)
	local debrisNum = 0
	if tDebris ~= nil then
		debrisNum = tDebris.lastNum
	else
		debrisNum = 0
	end
	if needNum then
		GetElement(self.m_root, "expPer_WndPlayer", WZUILabelTTF):setText(debrisNum.."/"..needNum)
	end

	if needNum ~= nil and needNum ~= 0 then
		GetElement(self.m_root,"progrExpProgress_WndPlayer",WZUIProgress):setPercentage(debrisNum/needNum*100)
	end
end

--@brief 	触摸开始回调
function WndPhantom:onTouchBegan(element, pt)
	-- body
	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
    self:hideRefineRecord()
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
		local conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
   		if conPlayer and conPlayer:getAnimNode() then
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.32))

			conPlayer:setScale(0.8)
	        self.conPlayer = conPlayer
	        conP:addChild(conPlayer:getAnimNode(),5)
		    self.firstPost = self.conPlayer:getPosition()
		end
    end
end

function WndPhantom:update3() 
	if self.m_root == nil then return end
	local con = GetElement(self.m_root,"tableCon_WndPhantom",WZUITableContainer)
	con:setVisible(false)

	GetElement(self.m_root, "conForFetter_WndPhantom", WZUIContainer):setVisible(true)
	local freeCon = GetElement(self.m_root,"freeCon_WndPhantom",WZUIFreeListContainer)
	freeCon:removeAll()

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
	--幻化等级
	local shapeLeve = self.shapeLeve or 0

	GetElement(self.m_root, "conForFetter_WndPhantom", WZUIContainer):setVisible(false)

	local con = GetElement(self.m_root,"tableCon_WndPhantom",WZUITableContainer)
	con:cleanTable()
	con:setVisible(true)

	local tTable = self:sortPhantomData()
	self.m_nTotalSkinNum = #tTable

	local index = 0
	local nSelIndex = 0
	self.m_phantomList = {} 
	self.m_phantomList = {}
	if self.m_bShowAll == true then
		for i=1,#tTable do
			local v = tTable[i]
			local cellElement,tCell
			cellElement,tCell = CellPhantomItem1:createElement()
			if v.use then
				GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(false)
				GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(true)
			else
				GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(true)
				GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(false)
			end
			cellElement:setTag(index)
			tCell:setData(v)
			tCell:setHighLight(false)
			con:setCellElement(cellElement)
			index = index + 1
			if self.m_nSelectedShapeId then
				local tempShapeInfo = GDatatab_shape_skins["id_"..self.m_nSelectedShapeId]
				if tempShapeInfo and (v.id == tempShapeInfo.id or v.id == tempShapeInfo.next_shape) then
					self.m_nSelectedShapeId = nil
					nSelIndex = index
					self.m_tSelectedCell = tCell
					WndPhantom.showId = tCell.m_tData.id
					tCell:setHighLight(true)
				end
			elseif self.m_nNextShapeId then 
				if v.id == self.m_nNextShapeId then 
					self.m_nNextShapeId = nil 
					nSelIndex = index
					self.m_tSelectedCell = tCell
	                WndPhantom.showId = tCell.m_tData.id
					tCell:setHighLight(true)
				end
			else
				if index == 1 then
					nSelIndex = index
					self.m_tSelectedCell = tCell
	                WndPhantom.showId = tCell.m_tData.id
					tCell:setHighLight(true)
				end
			end
			table.insert(self.m_phantomList,tCell)
		end
	else
		for i=1,#tTable do
			local v = tTable[i]
			if v.own == true then
				local cellElement,tCell
				cellElement,tCell = CellPhantomItem1:createElement()
				if v.use then
					GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(false)
					GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(true)
				else
					GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(true)
					GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(true)
				end
				cellElement:setTag(index)
				tCell:setData(v)
				tCell:setHighLight(false)
				con:setCellElement(cellElement)
				index = index + 1
				if index == 1 then
					nSelIndex = index
					self.m_tSelectedCell = tCell
	                WndPhantom.showId = tCell.m_tData.id
					tCell:setHighLight(true)
				end
			end
			table.insert(self.m_phantomList,tCell)
		end
	end

	self:onFresh(self.m_tSelectedCell.m_tData)
	if nSelIndex and nSelIndex > 5 then 
		local minPosY = con:getMinPosition().y
		local maxPosY = con:getMaxPosition().y
		local nCurPosY = minPosY + (nSelIndex - 5) * 98
		if nCurPosY > maxPosY then 
			nCurPosY = maxPosY
		end
		con:getMoveElement():setPositionY(nCurPosY)
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
		v.remainTime = nil
		v.curProperty = nil
		v.advancedLevel = nil
		v.blessingValue = nil
		v.fighting = nil
		v.activeRefineStatus = nil
		v.refineStatus = nil
		v.refineProperty = nil
		v.refinePropertySum = nil
	end
	for i=1,#self.m_tDataList do
		local tData1 = GDatatab_shape_skins["id_"..self.m_tDataList[i].shapeId]
		tData1.own = true
		tData1.remainTime = self.m_tDataList[i].remainTime
		tData1.curProperty = self.m_tDataList[i].curProperty
		tData1.advancedLevel = self.m_tDataList[i].advancedLevel
		tData1.blessingValue = self.m_tDataList[i].blessingValue
		tData1.fighting = self.m_tDataList[i].fighting
		tData1.activeRefineStatus = self.m_tDataList[i].activeRefineStatus
		tData1.refineStatus = self.m_tDataList[i].refineStatus
		tData1.refineProperty = self.m_tDataList[i].refineProperty
		tData1.refinePropertySum = self.m_tDataList[i].refinePropertySum
		if tData1.id == self.useShapeId then
			tData1.use = true
		end
		table.insert(tTable, tData1)
		table.insert(ownNames, tData1.name)
	end

	for k,v in pairs(GDatatab_shape_skins) do
		if (not utilsValueInTable(v.name, ownNames)) and (v.initial==1) and (v.sex == mySex or v.sex == 2) and v.quality <= 4 then
			local tData1 = CopyTable(v)
			local property = {}
			for i = 1, tData1.quality do
				table.insert(property, tData1.property[i])
			end
			tData1.fighting = WndCard:_caculateFighting(property)
			table.insert(tTable, tData1)
		end
	end
	for i=1,#tTable do
		local v = tTable[i]

		--碎片数量
		local itemId = v.channel
		local needNum = 1
		local debrisId 
		for k,v in pairs(GDatatab_itemmerge) do
			if ((v.id >= 8000 and v.id < 10000) or (v.id >= 161000 and v.id < 163000) or (v.id >= 157000 and v.id < 160000)) and v.items[1][1] == itemId then
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
		if needNum then
			v.enough = (debrisNum>=needNum)
		end
	end
	table.sort(tTable, sortPhantom)

	return tTable
end

--@brief	选中不同皮肤时刷新界面
function WndPhantom:onFresh(tData) 
	WZLog("WndPhantom:onFresh")
	if self.m_root == nil then return end
	if tData == nil then
		tData = self.RefineData
	end
	self:setBtnState()
	if tData.use then
		GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btnFight_WndPhanton",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnCancel_WndPhanton",WZUIButton):setVisible(false)
	end
	local qualityName = {LocalStrings.PHANTOM12, LocalStrings.PHANTOM13, LocalStrings.PHANTOM14, LocalStrings.PHANTOM15, LocalStrings.PHANTOM_NEWTEXT8}
	--皮肤形象
	self:showPlayer()
	self:_updateFire(tData)
	--皮肤名字
	GetElement(self.m_root,"ttfName",WZUILabelTTF):setText("【"..qualityName[tData.quality].."】"..tData.name)
	GetElement(self.m_root,"ttfName",WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
	--被动技能按钮
	local skillId = tData.passive_skill[1][1]
	local tSkill = GDatatab_skill["id_"..skillId]
	GetElement(self.m_root,"imgSkill1",WZUIImage):setFile(tSkill.icon)
	GetElement(self.m_root,"imgSkillL",WZUIImage):setFile(tSkill.lv_icon)
	--主动技能
	local tLastData = self:_getMaxQualityConfig(tData)
	if tLastData and tLastData.active_skill and tLastData.active_skill ~= -1 then 
		GetElement(self.m_root, "conSkillTip_Active", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "btnSkillTip_Active", WZUIButton):setVisible(true)

		local tSkill2 = GDatatab_skill["id_".. tLastData.active_skill[1][1]]
		GetElement(self.m_root,"imgSkill2",WZUIImage):setFile(tSkill2.icon)
		GetElement(self.m_root,"imgSkillL2",WZUIImage):setFile(tSkill2.lv_icon)
		if tLastData.quality == tData.quality then 
			GetElement(self.m_root,"imgSkill2",WZUIImage):setGrayRender(false)
		else
			GetElement(self.m_root,"imgSkill2",WZUIImage):setGrayRender(true)
		end
	else
		GetElement(self.m_root, "conSkillTip_Active", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "btnSkillTip_Active", WZUIButton):setVisible(false)
	end
	--剩余时间
	self:setTimer()

	--幻化按钮
	WZLog("WndPhantom:onFresh ggg", tData.own, tData.use)
	if tData.own == false and tData.use == false then
		--皮肤未获得
		GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(true)
		GetElement(WndPhantom.m_root,"conTryTime_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(false)
		GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnImprove_WndPhantom",WZUIButton):setVisible(false)
		--跳转
		local channel = tData.channel
		local tChannel = SplitStringWithSeparator(channel, ",")
		if tonumber(tChannel[2]) ~= nil then
			GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(true)
		else
			GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(true)
		end
		--激活按钮
		if self.m_tSelectedCell.enough then
			GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(false)
		end
		GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setTouchEnable(false)
		--获得皮肤对应的体验卡id
		local cardIds = {}
		for k,v in pairs(GDatatab_item) do
			if v.main_type == 20 and v.property[1][1] == tData.id then
				table.insert(cardIds, v.id)
			end
		end
		WZLog("kljsssssssjjjjjjjj", tData.id, Serialize(cardIds))
		for i=1,#cardIds do
			if CacheCenter:getPlayerItemCountById(cardIds[i]) > 0 then
				GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setTouchEnable(true)
				break
			end
		end
		--羁绊左边按钮单独设置
		if self.m_nTab == 3 then 
			GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setVisible(false)

			GetElement(self.m_root,"btnReturn_WndPhantom",WZUIButton):setVisible(true)
		end
	else
		--皮肤已获得
		GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(false)
		GetElement(WndPhantom.m_root,"conTryTime_WndPhantom",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(false)

		--体验皮肤，隐藏升品按钮
		if tData.remainTime == nil or tData.remainTime == 0 then
			GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(false)

			GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(true)
			GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setTouchEnable(false)
			--获得皮肤对应的体验卡id
			local cardIds = {}
			for k,v in pairs(GDatatab_item) do
				if v.main_type == 20 and v.property[1][1] == tData.id then
					table.insert(cardIds, v.id)
				end
			end
			WZLog("kljsssssssggggg", tData.id, Serialize(cardIds))
			for i=1,#cardIds do
				if CacheCenter:getPlayerItemCountById(cardIds[i]) > 0 then
					GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setTouchEnable(true)
					break
				end
			end
		else
			GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(true)
		end
		--激活按钮
		if self.m_tSelectedCell.enough then
			if tData.remainTime == -1 then 
				GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(false)
				GetElement(self.m_root,"btnImprove_WndPhantom",WZUIButton):setVisible(true)
				GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(false)
			else
				GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(true)
				GetElement(self.m_root,"btnImprove_WndPhantom",WZUIButton):setVisible(false)
			end
		else
			GetElement(self.m_root,"btnGet_WndPhantom",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnImprove_WndPhantom",WZUIButton):setVisible(false)
		end

		--已经有永久
		if tData.remainTime == -1 then
			GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(false)
		end

		--已经升品到最高级
		if tData.sp_cost == -1 then
			GetElement(self.m_root,"btnActivate_WndPhantom",WZUIButton):setVisible(false)
		end
		--羁绊左边按钮单独设置
		if self.m_nTab == 3 then 
			GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(true)

			GetElement(self.m_root,"btnUseCard_WndPhantom",WZUIButton):setVisible(false)

			GetElement(self.m_root,"btnReturn_WndPhantom",WZUIButton):setVisible(true)
		end
	end

	self:_showStar(tData)

	--攻击类型tips按钮
	local btnAttackTypeTips = GetElement(self.m_root,"btnAttackTypeTips_WndPhantom",WZUIButton)
	btnAttackTypeTips:setVisible(false)
	if tData.quality == 5 and tData.action == 1 then
		btnAttackTypeTips:setVisible(true)
	end
	
end

function sortPhantom(a, b)
	local function returnSortValue(temp)
		-- body
		if temp.own == false and temp.enough then 
			return 3
		elseif temp.use then 
			return 2
		elseif temp.own then 
			return 1
		else
			return 0
		end
	end
	local valueA = returnSortValue(a)
	local valueB = returnSortValue(b)
	if valueA ~= valueB then 
		return valueA > valueB
	else
		if a.quality ~= b.quality then 
			return a.quality > b.quality
		else
			return a.id > b.id
		end
	end
	-- if a.use ~= b.use then
	-- 	return a.use
	-- elseif a.enough ~= b.enough then
	-- 	return a.enough
	-- elseif a.own ~= b.own then
	-- 	return a.own 
	-- elseif a.quality ~= b.quality then
	-- 	return a.quality > b.quality
	-- elseif a.id ~= b.id then
	-- 	return a.id > b.id
	-- end
end

--@brief	角色形象点击响应
function WndPhantom:onClickRole(element)
	WZLog("WndPhantom:onClickRole")
	if self.conPlayer == nil then return end
	
	--正在跑步入场时 点击不响应
	if self.conPlayer:getPosition().x ~= self.firstPost.x then return end
	--conRoleEquip计时器包含跑步入场(_updateFootMarkPosition)和攻击动画(_updateAttack)
	local conRoleEquip = GetElement(self.m_root, "conRoleEquip_WndPhantom", WZUIContainer)
    conRoleEquip:disableSchedule()

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

--@brief 点击收集按钮切换到坐骑收集界面
function WndPhantom:onClickBook(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    WndHandBook:showInterface(118)  
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

--@brief 	显示星级
function WndPhantom:_showStar(tData)
	-- body
	local advancedLevel = tData.advancedLevel or 0
	local conCurStars = GetElement(self.m_root, "conCurStars_WndPhantom", WZUIContainer)
	conCurStars:removeAllChildrenWithCleanup(true)
	if advancedLevel == 0 then return end 


	local nStarLength = math.min(advancedLevel,10)
	local nGapping = 0.06
	local nStartPtx = 0.5 - (nStarLength - 1)*nGapping/2
    local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing2_h.png" }
	for i = 1, nStarLength do
		local index = 1
		if advancedLevel > nStarLength and advancedLevel - nStarLength >= i then
			index = 2
		end
		local imgStar = WZUI9Image:create()
		imgStar:setUseOriginSize(true)
		imgStar:setScale(0.75)
		imgStar:setFile(imgPath[index])
		imgStar:setRelativePosition(GlobalMethod:ccp(nStartPtx + (i - 1) * nGapping, 0.5))
		conCurStars:addChild(imgStar)
	end
end

--@brief 	显示进阶界面内容
function WndPhantom:_showAdvancedContent()
	-- body
	GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conForList_WndPhantom", WZUIContainer):setVisible(false)

	GetElement(self.m_root, "conCurStars_WndPhantom", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conForAdvance_WndPhantom", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(true)
	self:setBtnState()

	local tData = self.m_tSelectedCell.m_tData
	--属性
	local curPro = tData.curProperty
	-- 当前进阶数据和下次进阶数据
    local nextStarData
    local curStarData 
    for k,v in pairs(GDatatab_shape_advanced) do
    	if v.level == tData.advancedLevel then curStarData = v end 
        if v.level == tData.advancedLevel + 1 then nextStarData = v end
    end

    local basePro = self:getBasicPro(tData)
    --星级
    GetElement(self.m_root, "txtCurStar_WndPhantom", WZUILabelTTF):setText(tData.advancedLevel)
    if nextStarData then 
    	GetElement(self.m_root, "txtNextStar_WndPhantom", WZUILabelTTF):setText(nextStarData.level)
    else
    	GetElement(self.m_root, "txtNextStar_WndPhantom", WZUILabelTTF):setText("MAX")
    end

    if ProjConfig.LANGUAGE == "vn" then
	 --    local star1 = GetElement(self.m_root,"star1_WndPhantom",WZUIImage)
		-- if star1 then
		-- 	star1:setRelativePosition(GlobalMethod:ccp(0.4,0.5)))
		-- end
		-- local star2 = GetElement(self.m_root,"star2_WndPhantom",WZUIImage)
		-- if star2 then
		-- 	star2:setRelativePosition(GlobalMethod:ccp(0.89,0.5)))
		-- end
	end

    for i = 1, 6 do
    	local conProperty = GetElement(self.m_root, "conProperty" .. i .. "_WndPhantom", WZUIContainer)
    	conProperty:setVisible(false)
    end

    for i = 1, #basePro do
    	local conProperty = GetElement(self.m_root, "conProperty" .. i .. "_WndPhantom", WZUIContainer)
    	conProperty:setVisible(true)

    	local txtProName = GetElement(conProperty, "txtProName_WndPhantom", WZUILabelTTF)
    	local txtCurProValue = GetElement(conProperty, "txtCurProValue_WndPhantom", WZUILabelTTF)
    	txtProName:setText(ATTR_TITLE[basePro[i][1]])

    	local txtNextProName = GetElement(conProperty, "txtNextProName_WndPhantom", WZUILabelTTF)
    	txtNextProName:setText(ATTR_TITLE[basePro[i][1]])
    	local txtNextProValue = GetElement(conProperty, "txtNextProValue_WndPhantom", WZUILabelTTF)
    	for k = 1, #curPro do
    		if curPro[k][1] == basePro[i][1] then 
		    	txtCurProValue:setText(curPro[k][2])
		    	if nextStarData then
		            local EndPro = math.ceil(basePro[i][2] * (1 + nextStarData.property_rate/10000))
		            txtNextProValue:setText(EndPro)
		        else
		        	txtNextProValue:setText("MAX")
		        end
		        break 
		    end
    	end
    end
	--幸运值
	self:_updateLuckyValue()
	--消耗和成功率
	-- 成功率
    local per
    if nextStarData then 
    	per = math.ceil(100*(nextStarData.probability/10000))
    else
    	per = math.ceil(100*(curStarData.probability/10000))
    end
    local ftxtSuccessPercent =  GetElement(self.m_root, "ftxtSuccessPercent_WndPhantom", WZUIFreeTextBox)
    if ftxtSuccessPercent then 
    	local sFormat = [[<T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%s</T>]]
    	local sPercent = LocalStrings.MOUNTS_SUCCESS1 .. per .. "%"
    	ftxtSuccessPercent:setShowText(string.format(sFormat, sPercent))
    end

    self:_showAdvancedCost()
    self:_showStar(tData)
end

--@brief 	显示进化消耗
function WndPhantom:_showAdvancedCost()
	-- body
	local tData = self.m_tSelectedCell.m_tData

	-- 当前进阶数据和下次进阶数据
    local nextStarData
    local curStarData 
    for k,v in pairs(GDatatab_shape_advanced) do
    	if v.level == tData.advancedLevel then curStarData = v end 
        if v.level == tData.advancedLevel + 1 then nextStarData = v end
    end

    local ftxtAdvanceCost = GetElement(self.m_root, "ftxtAdvanceCost_WndPhantom", WZUIFreeTextBox)
    if ftxtAdvanceCost then 
    	local sFormat = [[<T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%s：</T><I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T><T C="255,236,193" S="20" P="1">%s</T>]]
    	local contentCost
    	if nextStarData then 
    		local nCount = CacheCenter:getPlayerItemCountById(nextStarData.cost[1][1])
    		local haveString = string.format(LocalStrings.MOUNT_PILL_CNT, nCount)
    		contentCost = string.format(sFormat, LocalStrings.ATH_SHOP_COST, GDatatab_item["id_" .. nextStarData.cost[1][1]].icon, nextStarData.cost[1][2], haveString)
    	else
    		local nCount = CacheCenter:getPlayerItemCountById(curStarData.cost[1][1])
    		local haveString = string.format(LocalStrings.MOUNT_PILL_CNT, nCount)
    		contentCost = string.format(sFormat, LocalStrings.ATH_SHOP_COST, GDatatab_item["id_" .. curStarData.cost[1][1]].icon, curStarData.cost[1][2], haveString)
    	end
    	ftxtAdvanceCost:setShowText(contentCost)
    end
end

--@brief    更新幸运值进度
function WndPhantom:_updateLuckyValue()
    -- body
    if self.m_root == nil then return end
    if self.m_tSelectedCell == nil then return end 

    local prgLucky = GetElement(self.m_root, "prgLucky_WndPhantom", WZUIProgress)
    local nTempBlessValue = self.m_tSelectedCell.m_tData.blessingValue
    
    if prgLucky then
        if nTempBlessValue < 0 then
            nTempBlessValue = 0 
        elseif nTempBlessValue > 100 then
            nTempBlessValue = 100
        end
        prgLucky:setPercentage(nTempBlessValue)
    end

    local txtLuckyValue = GetElement(self.m_root, "txtLuckyValue_WndPhantom", WZUILabelTTF)
    if txtLuckyValue then
        txtLuckyValue:setText(LocalStrings.LUCKVALUE .. ":" .. nTempBlessValue .. "%")
    end
end

--@brief 	设置按钮的状态
function WndPhantom:setBtnState()
	--body
	GetElement(self.m_root, "btnActivate_WndPhantom", WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnImprove_WndPhantom",WZUIButton):setVisible(false)
	GetElement(self.m_root, "btnGet_WndPhantom", WZUIButton):setVisible(false)
	GetElement(self.m_root, "btnUseCard_WndPhantom", WZUIButton):setVisible(false)
	local btnReturn = GetElement(self.m_root, "btnReturn_WndPhantom", WZUIButton)
	btnReturn:setVisible(false)
	btnReturn:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	GetElement(self.m_root, "conExp_WndPhantom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conCurStars_WndPhantom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "btnPhantomBox_WndPhantom", WZUIButton):setVisible(true)
	if self.m_nTab == 2 then 
		btnReturn:setVisible(true)
		GetElement(self.m_root, "conCurStars_WndPhantom", WZUIContainer):setVisible(true)

		GetElement(self.m_root, "btnPhantomBox_WndPhantom", WZUIButton):setVisible(false)
	elseif self.m_nTab == 3 then 
		btnReturn:setVisible(true)
		btnReturn:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
		GetElement(self.m_root, "conExp_WndPhantom", WZUIContainer):setVisible(true)

		GetElement(self.m_root, "btnPhantomBox_WndPhantom", WZUIButton):setVisible(false)
	elseif self.m_nTab == 5 then 
		btnReturn:setVisible(true)

		GetElement(self.m_root, "btnPhantomBox_WndPhantom", WZUIButton):setVisible(false)
	else
		GetElement(self.m_root, "conExp_WndPhantom", WZUIContainer):setVisible(true)
	end
	local tData = self.m_tSelectedCell.m_tData
	if tData == nil then return end 
	local nMaxQuality = self:_getMaxQuality(tData)
	if tData.remainTime == -1 and (tData.quality >= 4 or tData.quality == nMaxQuality) then 
		GetElement(self.m_root, "conExp_WndPhantom", WZUIContainer):setVisible(false)
	end
end

--@brief 	显示炼化内容
function WndPhantom:_showRefineContent(bIsShowRefineBtn)
	-- body
	GetElement(self.m_root, "conBtnNormal_WndPhantom", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conForList_WndPhantom", WZUIContainer):setVisible(false)

	GetElement(self.m_root, "conForRefine_WndPhantom", WZUIContainer):setVisible(true)
	GetElement(self.m_root, "conBtnActive_WndPhantom", WZUIContainer):setVisible(true)
	self:setBtnState()

	local tData = self.m_tSelectedCell.m_tData
	--炼化属性
	self:_refineProperty()
	local ftxtSuccessAtt = GetElement(self.m_root, "ftxtSuccessAtt_WndPhantom", WZUIFreeTextBox)
	local ftxtRefineCostAtt = GetElement(self.m_root, "ftxtRefineCostAtt_WndPhantom", WZUIFreeTextBox)
	self:_refineCost()
	if tData.activeRefineStatus then 
		GetElement(self.m_root, "conRefineCost_WndPhantom", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "btnActiveRefine_WndPhantom", WZUIButton):setVisible(false)
		
		local cost = self:_getRefineCost(tData, 3)
		WZLog("WndPhantom:_showRefineContent", cost[1][1], cost[1][2])
		local contentSucAtt = string.format(LocalStrings.PHANTOM_NEWTEXT9, GDatatab_item["id_" .. cost[1][1]].icon)
		local contentCostAtt = string.format(LocalStrings.PHANTOM_NEWTEXT13, GDatatab_item["id_" .. cost[1][1]].icon)
		ftxtSuccessAtt:setMaxWidth(350)
		ftxtSuccessAtt:setShowText(contentSucAtt)
		ftxtRefineCostAtt:setShowText(contentCostAtt)
		if tData.refineProperty and (tData.refineProperty == "" or tData.refineProperty == "{}") or bIsShowRefineBtn then 
			GetElement(self.m_root, "btnRefine_WndPhantom", WZUIButton):setVisible(true)
			GetElement(self.m_root, "btnMultiRefine_WndPhantom", WZUIButton):setVisible(true)
			GetElement(self.m_root, "conSave_WndPhantom", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "ftxtRefineCost_WndPhantom", WZUIFreeTextBox):setVisible(true)
			GetElement(self.m_root, "ftxtRefineCostMulti_WndPhantom", WZUIFreeTextBox):setVisible(true)
		else
			GetElement(self.m_root, "btnRefine_WndPhantom", WZUIButton):setVisible(false)
			GetElement(self.m_root, "btnMultiRefine_WndPhantom", WZUIButton):setVisible(false)
			GetElement(self.m_root, "ftxtRefineCost_WndPhantom", WZUIFreeTextBox):setVisible(false)
			GetElement(self.m_root, "ftxtRefineCostMulti_WndPhantom", WZUIFreeTextBox):setVisible(false)
			GetElement(self.m_root, "conSave_WndPhantom", WZUIContainer):setVisible(true)
		end
	else
		GetElement(self.m_root, "conRefineCost_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSave_WndPhantom", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "btnRefine_WndPhantom", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnMultiRefine_WndPhantom", WZUIButton):setVisible(false)
		
		GetElement(self.m_root, "ftxtRefineCost_WndPhantom", WZUIFreeTextBox):setVisible(true)
		GetElement(self.m_root, "btnActiveRefine_WndPhantom", WZUIButton):setVisible(true)
	end
end

--@brief 	炼化消耗
function WndPhantom:_refineCost()
	-- body
	local tData = self.m_tSelectedCell.m_tData

	local sFormatCost = [[<T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%s</T><I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T><T C="255,236,193" S="20" P="1">%s</T>]]
	local ftxtRefineCost = GetElement(self.m_root, "ftxtRefineCost_WndPhantom", WZUIFreeTextBox)
	local ftxtRefineCostMulti = GetElement(self.m_root, "ftxtRefineCostMulti_WndPhantom", WZUIFreeTextBox)
	GetElement(self.m_root, "conRefineBtnAndCost_WndPhantom", WZUIContainer):setVisible(true)
	if tData.activeRefineStatus then 
		if ftxtRefineCost then 
			ftxtRefineCost:setRelativePosition(GlobalMethod:ccp(0.23, 0.19))
			local cost
			local refineProNum = self:getRefinePropertyNum(tData)
			if self.m_bIsUseDiamondRefine then 
				cost = self:_getRefineCost(tData, 3)
			else
				cost = self:_getRefineCost(tData, 2)
			end
			if refineProNum == 0 then 
				GetElement(self.m_root, "conRefineBtnAndCost_WndPhantom", WZUIContainer):setVisible(false)
			else
				local nCount = CacheCenter:getPlayerItemCountById(cost[1][1])
	    		local haveString = string.format(LocalStrings.MOUNT_PILL_CNT, nCount)
				ftxtRefineCost:setShowText(string.format(sFormatCost, LocalStrings.COST, GDatatab_item["id_" .. cost[refineProNum][1]].icon, cost[refineProNum][2], ""))
				ftxtRefineCostMulti:setShowText(string.format(sFormatCost, LocalStrings.COST, GDatatab_item["id_" .. cost[refineProNum][1]].icon, cost[refineProNum][2] * 5, ""))
			end
		end
		ftxtRefineCostMulti:setVisible(true)
	else
		if ftxtRefineCost then 
			ftxtRefineCost:setRelativePosition(GlobalMethod:ccp(0.5, 0.19))
			local cost = self:_getRefineCost(tData, 1)
			if cost then
				local nCount = CacheCenter:getPlayerItemCountById(cost[1][1])
	    		local haveString = string.format(LocalStrings.MOUNT_PILL_CNT, nCount)
				local content = string.format(sFormatCost, LocalStrings.COST, GDatatab_item["id_" .. cost[1][1]].icon, cost[1][2], haveString)
				WZLog("WndPhantom:_refineCost", cost[1][1], cost[1][2], content)
				ftxtRefineCost:setShowText(content)
			end
		end
		ftxtRefineCostMulti:setVisible(false)
	end
end

--@brief 	显示炼化属性
function WndPhantom:_refineProperty()
	-- body
	local tData = self.m_tSelectedCell.m_tData
	local tBasicPro = tData.property
	local maxQuality = self:_getMaxQuality(tData)
	WZLog("WndPhantom:_refineProperty", Serialize(tData.refinePropertySum))
	local _, refineConfig = self:_getRefineCost(tData, 2)
	if self.m_bIsUseDiamondRefine then 
		_, refineConfig = self:_getRefineCost(tData, 3)
	end
	if not refineConfig then return end
	for i = 1, 6 do
		GetElement(self.m_root, "conRefineProperty" .. i .. "_WndPhantom", WZUIContainer):setVisible(false)
	end
	local tMaxRefinePro = refineConfig.property_limit
	local sProFormat1 = [[<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat2 = [[<T C="93,222,254" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat3 = [[<T C="198,130,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat4 = [[<T C="233,166,62" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat5 = [[<T C="255,89,74" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat6 = [[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local sProFormat7 = [[<T C="99,255,95" S="18" P="1" SC="132,66,29" SS="4" SE="0">%s</T>]]
	local sProFormat8 = [[<T C="255,89,74" S="18" P="1" SC="132,66,29" SS="4" SE="0">%s</T>]]
	for i = 1, #tBasicPro do
		local conRefineProperty = GetElement(self.m_root, "conRefineProperty" .. i .. "_WndPhantom", WZUIContainer)
		if i <= maxQuality then 
			conRefineProperty:setVisible(true)
		elseif i == 6 and maxQuality == 5 then 
			conRefineProperty:setVisible(true)
		end

		local txtProName = GetElement(conRefineProperty, "txtProName_WndPhantom", WZUILabelTTF)
		if txtProName then 
			txtProName:setText(ATTR_TITLE[tBasicPro[i][1]] .. ":")
		end
		local ftxtCurProValue = GetElement(conRefineProperty, "ftxtCurProValue_WndPhantom", WZUIFreeTextBox)
		local prgCurRefine = GetElement(conRefineProperty, "prgCurRefine_WndPhantom", WZUIProgress)
		local prgNextRefine = GetElement(conRefineProperty, "prgNextRefine_WndPhantom", WZUIProgress)
		prgNextRefine:setPercentage(0)
		prgCurRefine:setPercentage(0)
		local proContent = ""
		if tData.activeRefineStatus then 
			if i <= tData.quality or (i == 6 and tData.quality == 5) then 
				local refineProSum = 0
				for j = 1, #tData.refinePropertySum do
					if tData.refinePropertySum[j][1] == tBasicPro[i][1] and tData.refinePropertySum[j][2] then 
						refineProSum = tData.refinePropertySum[j][2]
						break 
					end
				end

				local nMaxRefinePro = 1
				for k, value in pairs(tMaxRefinePro) do
					if value[1] == tBasicPro[i][1] then 
						nMaxRefinePro = value[2]
						break 
					end
				end
				
				prgCurRefine:setPercentage(math.floor(refineProSum/nMaxRefinePro*100))
				for j = 1, #tData.curProperty do
					if tData.curProperty[j][1] == tBasicPro[i][1] then 
						proContent = string.format(sProFormat6, tData.curProperty[j][2])
						break 
					end
				end
				if tData.refineProperty ~= nil and tData.refineProperty ~= "" and tData.refineProperty ~= "{}" 
					and tData.saveShowProp ~= nil and tData.saveShowProp ~= "" and tData.saveShowProp ~= "{}" then 
					for k = 1, #tData.saveShowProp do
						local addProContent = ""
						if tData.saveShowProp[k][1] == tBasicPro[i][1] then 
							local nNextValue = refineProSum + tData.saveShowProp[k][2]
							prgNextRefine:setPercentage(math.floor(nNextValue/nMaxRefinePro*100))
							if tData.saveShowProp[k][2] >= 0 then 
								prgNextRefine:setZOrder(0)

								addProContent = string.format(sProFormat7, "+" .. tData.saveShowProp[k][2])
							else
								prgNextRefine:setZOrder(2)

								addProContent = string.format(sProFormat7, tostring(tData.saveShowProp[k][2]))
							end
							proContent = proContent .. addProContent
							break 
						end
					end
				end
			elseif i > tData.quality and i <= maxQuality then 
				if i == 2 then 
					proContent = string.format(sProFormat2, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 3 then 
					proContent = string.format(sProFormat3, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 4 then 
					proContent = string.format(sProFormat4, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 5 then 
					proContent = string.format(sProFormat5, LocalStrings.PHANTOM_NEWTEXT14[i])
				end
			elseif i == 6 then 
				proContent = string.format(sProFormat5, LocalStrings.PHANTOM_NEWTEXT14[i])
			else
				proContent = string.format(sProFormat6, LocalStrings.PHANTOM_NEWTEXT16)
			end
		else
			if i <= tData.quality then 
				proContent = string.format(sProFormat6, LocalStrings.PHANTOM_NEWTEXT15)
			elseif i > tData.quality and i <= maxQuality then 
				if i == 1 then 
					proContent = string.format(sProFormat1, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 2 then 
					proContent = string.format(sProFormat2, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 3 then 
					proContent = string.format(sProFormat3, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 4 then 
					proContent = string.format(sProFormat4, LocalStrings.PHANTOM_NEWTEXT14[i])
				elseif i == 5 then 
					proContent = string.format(sProFormat5, LocalStrings.PHANTOM_NEWTEXT14[i])
				end
			elseif i == 6 then 
				proContent = string.format(sProFormat5, LocalStrings.PHANTOM_NEWTEXT14[i])
			else
				proContent = string.format(sProFormat6, LocalStrings.PHANTOM_NEWTEXT16)
			end
		end

		ftxtCurProValue:setShowText(proContent)
	end

	--属性锁定情况
	self:_showPropertyLockState()
end

--@brief 	显示属性炼化锁定情况
function WndPhantom:_showPropertyLockState()
	-- body
	local tData = self.m_tSelectedCell.m_tData

	for i = 1, #tData.property do
		local conRefineProperty = GetElement(self.m_root, "conRefineProperty" .. i .. "_WndPhantom", WZUIContainer)
		
		local imgLock = GetElement(conRefineProperty, "imgLock_WndPhantom", WZUIImage)
		local bVisible = false 
		for k = 1, #tData.refineStatus do
			if tData.refineStatus[k][1] == tData.property[i][1] then 
				if tData.refineStatus[k] and tData.refineStatus[k][2] == 0 then 
					bVisible = true
					break 
				else
					bVisible = false 
					break 
				end
			end
		end
		imgLock:setVisible(bVisible)
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

	local txtNoUse1 = GetElement(self.m_root,"txtNoUse1_WndPhantom",WZUILabelTTF)
	txtNoUse1:setDimensions(GlobalMethod:CCSize(80,0))
	txtNoUse1:setScale(0.6)

	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)

	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.8)


	GetElement(WndPhantom.m_root,"txtLeftTime_WndPhantom", WZUIFreeTextBox):setScale(0.8)

	local txtGet = GetElement(self.m_root,"txtGet_WndPhantom",WZUILabelTTF)
	txtGet:setScale(0.7)
end

function WndPhantom:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.9)
end

function WndPhantom:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF):setScale(0.7)

	local txtUseCard1 = GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF)
	if txtUseCard1 then
		txtUseCard1:setScale(0.55)
		GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF):setScale(0.55)
	end
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
		if txtNoUse then
			txtNoUse:setDimensions(GlobalMethod:CCSize(100,0))
			txtNoUse:setScale(0.7)
		end
	end
	GetElement(self.m_root, "txtFightWord_WndPhantom", WZUILabelTTF):setScale(0.85)

	GetElement(self.m_root, "txtImprove_WndPhantom", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtImprove_WndPhantom", WZUILabelTTF):setScale(0.85)
	
	GetElement(self.m_root, "txtImprove1_WndPhantom", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtImprove1_WndPhantom", WZUILabelTTF):setScale(0.85)
	
	GetElement(self.m_root, "txtImprove2_WndPhantom", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtImprove2_WndPhantom", WZUILabelTTF):setScale(0.85)

	GetElement(self.m_root, "txtImprove4_WndPhantom", WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root, "txtImprove4_WndPhantom", WZUILabelTTF):setScale(0.85)

	local btnActiveRefineLabel = GetElement(self.m_root,"btnActiveRefineLabel_WndPhantom",WZUILabelTTF)
	if btnActiveRefineLabel then
		btnActiveRefineLabel:setFontSize(22)
		btnActiveRefineLabel:setScale(0.85)
	end	
	local star1 = GetElement(self.m_root,"star1_WndPhantom",WZUIImage)
	if star1 then
		star1:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	end
	local star2 = GetElement(self.m_root,"star2_WndPhantom",WZUIImage)
	if star2 then
		star2:setRelativePosition(GlobalMethod:ccp(0.94,0.5))
	end

	GetElement(self.m_root, "txtMultiRefine_WndPhantom", WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtUpgradeLog_WndPhantom",WZUILabelTTF):setFontSize(16)

	local conSuccessAtt = GetElement(self.m_root, "conSuccessAtt_WndPhantom", WZUIContainer)
	conSuccessAtt:setAbsContentSize(GlobalMethod:CCSize(240,44))
	conSuccessAtt:updateRelativeSize()
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

	GetElement(WndPhantom.m_root,"txtLeftTime_WndPhantom", WZUIFreeTextBox):setScale(0.8)

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

	GetElement(WndPhantom.m_root,"txtLeftTime_WndPhantom", WZUIFreeTextBox):setScale(0.8)

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
	
	for i = 1, 4 do
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setDimensions(GlobalMethod:CCSize(150))
		cardTime:setRelativePosition(GlobalMethod:ccp(0.155,0.5))
	end

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

	GetElement(self.m_root,"conSkillTip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.2,0.812))
	GetElement(self.m_root,"btnSkillTip",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.2,0.812))
	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setRelativePosition(GlobalMethod:ccp(0.25,0.825))
	GetElement(self.m_root,"ttfMonster",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.79))
end

function WndPhantom:_adaptLanguage_ug(  )
	local txtChest = GetElement(self.m_root,"txtChest_WndPhantom",WZUILabelTTF)
	txtChest:setScale(0.55)
	txtChest:setDimensions(GlobalMethod:CCSize(220))
	local txtGet = GetElement(self.m_root,"txtGet_WndPhantom",WZUILabelTTF)
	txtGet:setScale(0.7)
	local txtUse1 = GetElement(self.m_root,"txtUse1_WndPhantom",WZUILabelTTF)
	txtUse1:setScale(0.9)
	local txtUse2 = GetElement(self.m_root,"txtUse2_WndPhantom",WZUILabelTTF)
	txtUse2:setScale(0.9)
	local txtNoUse1 = GetElement(self.m_root,"txtNoUse1_WndPhantom",WZUILabelTTF)
	txtNoUse1:setScale(0.8)
	local txtImprove = GetElement(self.m_root,"txtImprove_WndPhantom",WZUILabelTTF)
	txtImprove:setScale(0.7)
	txtImprove:setDimensions(GlobalMethod:CCSize(180))
	local txtSetShow2 = GetElement(self.m_root,"txtSetShow2_WndPhantom",WZUILabelTTF)
	txtSetShow2:setScale(0.7)
	txtSetShow2:setDimensions(GlobalMethod:CCSize(180))

	GetElement(self.m_root,"txtUseCard1_WndPhantom",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtUseCard2_WndPhantom",WZUILabelTTF):setScale(0.6)
	for i = 1, 4 do
		local cardNum = GetElement(self.m_root,"cardNum"..i,WZUILabelTTF)
		cardNum:setScale(0.7)
		cardNum:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
		local cardTime = GetElement(self.m_root,"cardTime"..i,WZUILabelTTF)
		cardTime:setScale(0.7)
		cardTime:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
		cardTime:setDimensions(GlobalMethod:CCSize(140))
	end

	local ttfName = GetElement(self.m_root,"ttfName",WZUILabelTTF)
	ttfName:setFontSize(16)
end

-------------------------------------语言适配End--------------------------------------------
