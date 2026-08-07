--WndSkillProp.lua
--@brief	WndSkillProp的UI模块
--@date		2013/12/27
--@author	李光森
--@note		房间中技能道具窗口

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSkillProp:onEnter(element)
	WZLog("WndSkillProp:onEnter")
	self.m_root = element

	self:initSkills()
	--获取玩家技能
	self.m_bIsVisitNet = true
    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    if isFinish5 ~= true and finishStep5 > 0 and CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_25"].open_level + 1 then
        WindowManager:addTeachShelterLayer( 999999 )
    end
	--多语言版本界面适配
	 AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSkillProp:onExit(element)
	WZLog("WndSkillProp:onExit")
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief	创建窗口动画
function WndSkillProp:onEnterTransitionDidFinish(element)
	WZLog("WndSkillProp:onEnterTransitionDidFinish")
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	GetElement(self.m_root,"topImg1",WZUIImage):setFile(GDatatab_item["id_63"].icon)
	GetElement(self.m_root,"topImg2",WZUIImage):setFile(GDatatab_item["id_63"].icon)
	
	self:actionCallback()

	self.upTip = 0
	self.learnTip = 0

	if WndSkillContainer:getSkillMode() == "edit" then 
		self:onEdit() 
	end
end

function WndSkillProp:event(animation, name, eventName)
	WZLog("WndSkillProp:event", name)
	if name == "end" then
	    self.m_bPlayUpdateAction = false
	    local con = GetElement(self.m_root,"con_WndSkillProp",WZUIContainer)
	    local child = con:getChildByTag(1102)
	    if child then
	   	    child:setVisible(false)
	    end
	elseif name == "complete" then  --播放完动画再刷新数据
		self.m_bClickUpgrade = false
		self:showSkillProps(self.m_vItemIds,self.m_vItemExp)
	end
end

--@brief	窗口动画完成回调
function WndSkillProp:actionCallback(elem,data)
	WZLog("WndSkillProp:actionCallback")
	local playerSkill = CacheCenter:getPlayerSkill()
	local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
	local btnPreviewNew = GetElement(self.m_root,"btnPreviewNew",WZUIButton)
	btnPreviewNew:setVisible(true)
	if self.m_nWinType == 1 then
		local tData = CacheCenter:getSkill()
		if tData then
			playerSkill = {skillId=tData.useSkill,skillExplain=tData.skillExplain}
		end
		txtEquipAtt:setText(LocalStrings.SKILL_TEXT1)
	elseif self.m_nWinType == 2 then
		playerSkill = CacheCenter:getPlayerSkill()
		txtEquipAtt:setText(LocalStrings.SKILL_TEXT2)
	end
	--WZLog("开放限制",Serialize(playerSkill))
	self:receiveGetPlayerSkillOk(playerSkill.skillId,playerSkill.skillExplain)

	self.m_bIsActionEnd = true
    local isHaveSkill = 0
    if CacheCenter.m_tSkill then
	    for k,v in pairs(CacheCenter.m_tSkill.useSkill) do
	    	if v > 0 then
	    		isHaveSkill = isHaveSkill + 1
	    	end
	    end
	end

    local isHaveProp = 0
    for k,v in pairs(CacheCenter:getPlayerSkill().skillId) do
    	if v > 0 then
    		isHaveProp = isHaveProp + 1
    	end
    end
    WZLog("WndSkillProp:showAllSkill2", isHaveSkill, isHaveProp, tostring(self.m_bIsActionEnd))
    self:showSkillInfo()
end

--@brief  窗口背景变暗
function WndSkillProp:disappearOk()
    WZLog("disappearOk", tostring(TeachGroup1.ISTEACH))

    local isFinish4, finishStep4 = TeachGroup1:isTeachFinish(4)
    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    if isFinish4 == true and isFinish5 ~= true and finishStep5 >= 5 then
    	if WndSingleCopy.m_root then 
        	TeachGroup1:startGroup({5,9, WndSingleCopy.m_root})
        end
    end
end


--@brief	关闭按钮点击回调
--@param	element:绑定的UI节点引用
function WndSkillProp:onClickClose(element)
	WZLog("WndSkillProp:onClickClose")
    TeachGroup1:endTeachStep({5,8})
    TeachGroup1:removeTeach()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WndSkillContainer:onClose()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  点击技能道具栏格子回调
function WndSkillProp:onClickOwnS(element)
	WZLog("WndSkillProp:onClickOwnS")

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerSkillInfo.skillId ==nil then
		return
	end
	local parentNode =WZUIContainer:luaTo(element:getParent())
	local tag = element:getTag()
	
	local skillId = self.m_tPlayerSkillInfo.skillId[tag]
   
	if  skillId <=0 then
		local imgRed = GetElement(parentNode,"imgRed_WndSkillProp",WZUIImage)
		if imgRed ~= nil and imgRed:isVisible() then
			local con = GetElement(self.m_root,"con_WndSkillProp",WZUIContainer)
			if self.m_nWinType == 1 then
				WndItemInfo:showInfo(parentNode,con,3,LocalStrings.NEWSKILL18,false)
			elseif self.m_nWinType == 2 then
				WndItemInfo:showInfo(parentNode,con,3,LocalStrings.CAN_EQUIPPED_PROPS,false)
			end
		else
			return
		end
	end

	--不是编辑模式，选中
	if self.mode ~= "edit" then 
		local imgSelectBg = GetElement(parentNode,"imgSelectBg1_WndSkillProp",WZUI9Image)
		if self.m_oCurSelectSkill ~= nil and imgSelectBg ~= self.m_oCurSelectSkill then
			self.m_oCurSelectSkill:setVisible(false)
		end
		imgSelectBg:setVisible(true)
		self.m_oCurSelectSkill = imgSelectBg
		self:showSkillDetailInfo(skillId,true,true)
		return 
	end
	
	if skillId > 0 then  --卸下技能道具
		local skillSeatIndex = nil  --记录当前道具技能在技能栏的第几位
		local skillCount = 0
		for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
			if v == skillId then
				skillSeatIndex = i
			end
			if v ~= 0 and v ~= -1 then
				skillCount = skillCount + 1
			end
		end
		if skillSeatIndex ~= nil then
			--WZLog("卸下技能",Serialize(self.m_tPlayerSkillInfo.skillId),self.m_nCurShowSkillId,skillSeatIndex-1)
			if self.m_nWinType == 1 then
				if skillCount == 1 then
					MsgBoxManager:showTipBox(LocalStrings.NEWSKILL19)
					return
				end
				ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill(0,skillSeatIndex-1)
		    	self.m_bIsVisitNet = true
			elseif self.m_nWinType == 2 then
		    	ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill(0,skillSeatIndex-1)
		    	self.m_bIsVisitNet = true
			end
		end
	end
	--end
end

--@brief    点击确定充值回调
function WndSkillProp:clickSureMoney(nId, nResType)
	WZLog("WndSkillProp:clickSureMoney ",nId,nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
	end
end

--@brief  升级技能道具
function WndSkillProp:onClickUpdateLevel(element)
	WZLog("WndSkillProp:onClickUpdateLevel = ",self.m_bClickUpgrade,self.m_bPlayUpdateAction, self.m_nCurShowSkillId)
	if self.m_bIsVisitNet or self.m_bClickUpgrade or self.m_bPlayUpdateAction then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local knowledge_id = 85
	if ProjConfig.LANGUAGE == "vn" then
		knowledge_id = 86
	end
    local curSkillInfo = GDatatab_skill["id_"..self.m_nCurShowSkillId]
    local upgradeData = curSkillInfo.upgrade
    if type(upgradeData) == "table" then
    	local consumeId = upgradeData[1][1]
    	local consumeCount = upgradeData[1][2]
    	local itemCount = CacheCenter:getPlayerItemCountById(consumeId) 
    	if itemCount < consumeCount then
    		local itemInfo = GDatatab_item["id_" .. consumeId]
    		local temp = string.format(LocalStrings.CARD_COUNT1,itemInfo.name)
    		MsgBoxManager:showTipBox(temp)
    		if consumeId ~= knowledge_id then 
    			self:onClickGet(nil)
    		end
    		return
    	end
    	self.m_nPlayerSkillLoadingId = MsgBoxManager:showLoadingBox()
        self.m_bIsVisitNet = true
		self.m_nUpdateLevelSkillId = curSkillInfo.upgrade_id
		ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill(self.m_nCurShowSkillId,consumeId)
    elseif upgradeData == -1 then
    	local tip = LocalStrings.SKILL_UPGRADE_FULL
    	if tip == nil then
    		MsgBoxManager:showTipBox("已升到最高级")
    	else
    		MsgBoxManager:showTipBox(tip)
    	end
    end
end

--@brief  显示点击的技能道具信息
function WndSkillProp:onClickSkill(element)
	WZLog("WndSkillProp:onClickSkill")
	--刷新界面中返回
	if self.upTip == nil then self.upTip = 0 end
	if self.learnTip == nil then self.learnTip = 0 end
	if self.upTip > 0 or self.learnTip > 0 then return end

    local elementParent = element:getParent()
    elementParent = WZUIContainer:luaTo(elementParent)
	WZLog("WndSkillProp:onClickSkill ",elementParent:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(5)
    if teachStep < 5 then
        TeachGroup1:endTeachStep({5,5})
        PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvClickBomb)
    else
    	TeachGroup1:endTeachStep({5,7})
        PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvClickFire)
    end

	if self.m_bLoadFinish then 
		local tbSkillList = GetElement(self.m_root,"tbSkillList_WndSkillProp",WZUITableContainer)
		local movPx,movPy = tbSkillList:getMoveElement():getPosition()
		self.m_tMoveElementP = {}
		table.insert(self.m_tMoveElementP,movPx)
		table.insert(self.m_tMoveElementP,movPy)
    end

	local tag = elementParent:getTag()
	tag = tag+1
	WZLog("WndSkillProp:onClickSkill1", tag)
	--local skillId = self.m_tAllSkillProps[tag].id
	local skillId =	tonumber(GetElement(elementParent,"gridId",WZUILabelTTF):getText())

	WZLog("WndSkillProp:onClickSkill2", tag, skillId)
	local imgSkillStats = GetElement(elementParent,"imgSkillStats_WndSkillProp",WZUIImage)
	local imgSkillBg   = GetElement(elementParent,"imgSkillBg_WndSkillProp",WZUIImage)
	local bEquipped = false
	local bActive = true
	if imgSkillStats:isVisible() then
		bEquipped = true
	end
	WZLog("WndSkillProp:onClickSkill3", tag, skillId)

	if imgSkillBg:getGrayRender() then
	   bActive = false
	end
	
	local imgSelectBg = GetElement(elementParent,"imgSelectBg_WndSkillProp",WZUI9Image)
	WZLog("WndSkillProp:onClickSkill4", tag, skillId)
	
	if self.m_oCurSelectSkill ~= nil and imgSelectBg ~= self.m_oCurSelectSkill then
		WZLog("WndSkillProp:onClickSkill5", tag, skillId)
		self.m_oCurSelectSkill:setVisible(false)
	end
	imgSelectBg:setVisible(true)
	self.m_oCurSelectSkill = imgSelectBg
	self:showSkillDetailInfo(skillId, bEquipped, bActive)

	WZLog("WndSkillProp:onClickSkill6", tag, skillId)
	--编辑模式
	if self.mode == "edit" and bActive == true then
		local e = GetElement(self.m_root,"btnUse_WndSkillProp",WZUIButton)
		WndSkillProp:onClickSkillUse(e)
		return
	end
end

--@brief  使用道具技能或者卸下道具技能
function WndSkillProp:onClickSkillUse(element)
	WZLog("WndSkillProp:onClickSkillUse ")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_bIsVisitNet or self.m_bClickUpgrade then  --防止多次点击
		return
	end

    local elementParent = WZUIContainer:luaTo(element:getParent())
    local txtSkillStatus = GetElement(elementParent,"txtSkillStatus_WndSkillProp",WZUILabelTTF)
    local txtText = txtSkillStatus:getText()
    if txtText == LocalStrings.USE then  --使用技能
    	local canPutSkillIndex = nil  --存放可以放置技能道具的技能栏格子
		--WZLog("sdflklss",Serialize(self.m_tPlayerSkillInfo))
    	for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
    		--if v == 0 or v == -1 then
    		if v == 0 then
    			canPutSkillIndex = i
    			break
    		end
    	end
    	if canPutSkillIndex == nil then
    		MsgBoxManager:showTipBox(LocalStrings.SKILL_CELL_FULL)
    	else
    		self.m_nPlayerSkillLoadingId = MsgBoxManager:showLoadingBox()
		    self.m_bIsVisitNet = true
			WZLog("使用技能",self.m_nWinType,self.m_nCurShowSkillId,canPutSkillIndex-1)
			if self.m_nWinType == 1 then
				local skillInfo = GDatatab_skill["id_"..self.m_nCurShowSkillId]
				if skillInfo and self.m_tSkillGroup[skillInfo.skill_group] then
					MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT91)
					self.m_bIsVisitNet = false
				else
		    		ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill(self.m_nCurShowSkillId,canPutSkillIndex-1)
		    	end
			elseif self.m_nWinType == 2 then
    			ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill(self.m_nCurShowSkillId,canPutSkillIndex-1)
			end
    	end
    elseif txtText == LocalStrings.UNROYAL then --卸下技能
    	local skillSeatIndex = nil  --记录当前道具技能在技能栏的第几位
		local skillCount = 0
    	for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
    		if v == self.m_nCurShowSkillId then
    			skillSeatIndex = i
    		end
			if v ~= 0 and v ~= -1 then
				skillCount = skillCount + 1
			end
    	end
    	if skillSeatIndex ~= nil then
			WZLog("卸下技能",self.m_nWinType,self.m_nCurShowSkillId,skillSeatIndex-1)
			if self.m_nWinType == 1 then
				if skillCount == 1 then
					MsgBoxManager:showTipBox(LocalStrings.NEWSKILL19)
					return
				end
				ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill(0,skillSeatIndex-1)
		    	self.m_bIsVisitNet = true
			elseif self.m_nWinType == 2 then
		    	ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill(0,skillSeatIndex-1)
		    	self.m_bIsVisitNet = true
			end
    	end
    end
end

--@brief  不够物品进行技能道具升级,跳转到相应场景获取
function WndSkillProp:onClickGet(element)
	WZLog("WndSkillProp:onClickGet")
	if element then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	
	local knowledge_id = 85
	if ProjConfig.LANGUAGE == "vn" then
		knowledge_id = 86
	end
	--MsgBoxManager:showTipBox(LocalStrings.CLOSE_SCRIPT)
	local wndFastGetItems = WndFastGetItems:createElement()
	local skillInfo =  GDatatab_skill["id_" .. self.m_nCurShowSkillId]

	g_fastGetItemId = self.m_nCurShowSkillId
	if type(skillInfo.upgrade) == "number" then return end
	local upgradeInfo = skillInfo.upgrade[1]
	-- if upgradeInfo[1] == knowledge_id then return end 
	
	WndFastGetItems:setGetItemId(upgradeInfo[1])
	local itemCount = CacheCenter:getPlayerItemCountById(upgradeInfo[1]) 
	WndFastGetItems:setItemCount(itemCount,upgradeInfo[2])
    WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
end

function WndSkillProp:onClickGet1(element)
	WZLog("WndSkillProp:onClickGet1")
	if element then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	local wndFastGetItems = WndFastGetItems:createElement()

	local skillInfo =  GDatatab_skill["id_" .. self.m_nCurShowSkillId]
	g_fastGetItemId = self.m_nCurShowSkillId
	local upgradeInfo
	if type(skillInfo.upgrade) == "number" then 
		upgradeInfo = {63,0}
	else
		upgradeInfo = skillInfo.upgrade[1]
	end
	WndFastGetItems:setGetItemId(upgradeInfo[1])
	local itemCount = CacheCenter:getPlayerItemCountById(upgradeInfo[1]) --CacheCenter:getSkill().skillNum

	if upgradeInfo[1] == 85 then 
		itemCount = CacheCenter:getPlayerItemCountById(upgradeInfo[1]) 
	elseif upgradeInfo[1] ~= 63 then 
		itemCount = CacheCenter:getPlayerItemCountById(upgradeInfo[1]) 
	end
	WndFastGetItems:setItemCount(itemCount,upgradeInfo[2])
    WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
end

--@brief  激活道具技能
function WndSkillProp:onClickSkillActivation(element)
	WZLog("WndSkillProp:onClickSkillActivation", self.m_nCurShowSkillId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local skillInfo =  GDatatab_skill["id_" .. self.m_nCurShowSkillId]

	if self.m_nWinType == 1 then
		if self.mode == "edit" then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL26)
			return
		end

		self.m_root:enableSchedule("stopBlock",2)
    	local curSkillInfo = GDatatab_skill["id_"..self.m_nCurShowSkillId]
		if curSkillInfo == nil then return end
    	local upgradeData = curSkillInfo.hdtjcs
    	if type(upgradeData) == "table" then
			local skillNum = CacheCenter:getSkill().skillNum
			if upgradeData[1][1] ~= 63 then 
				skillNum = CacheCenter:getPlayerItemCountById(upgradeData[1][1]) 
			end
			if skillNum >= upgradeData[1][2] then
				self.learnTip = 2
				ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill( tonumber(self.m_nCurShowSkillId) )
			else
				if upgradeData[1][1] == 63 then 
					MsgBoxManager:showTipBox(LocalStrings.NEWSKILL13)
				else
					MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, GDatatab_item["id_" .. upgradeData[1][1]].name))
				end
				local wndFastGetItems = WndFastGetItems:createElement()
				g_fastGetItemId = self.m_nCurShowSkillId
				WndFastGetItems:setGetItemId(upgradeData[1][1])
				WndFastGetItems:setItemCount(skillNum, upgradeData[1][2])
			    WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
			end
		end
		return
	end

	local proSkill = GetElement(self.m_root,"proSkill_WndSkillProp",WZUIProgress)
	local percentage = proSkill:getPercentage()

	local costItemId = nil
	local costItemCount = nil
	if skillInfo.hdtjcs[2] ~= nil then
		costItemId = skillInfo.hdtjcs[2][1]
		costItemCount = skillInfo.hdtjcs[2][2]
	else
		costItemId = skillInfo.hdtjcs[1][1]
		costItemCount = skillInfo.hdtjcs[1][2]
	end
	if percentage >=100 then
		self.m_nPlayerSkillLoadingId = MsgBoxManager:showLoadingBox()
		self.m_bIsVisitNet = true
		ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill(self.m_nCurShowSkillId,costItemId)
	else
		local wndFastGetItems = WndFastGetItems:createElement()
		WndFastGetItems:setGetItemId(costItemId)
		local itemCount = CacheCenter:getPlayerItemCountById(costItemId) 
		WndFastGetItems:setItemCount(itemCount,costItemCount)
		WindowManager:addWindow(wndFastGetItems,WndFastGetItems,nil,nil,nil,true)
	end
end

--@brief	进入编辑模式
function WndSkillProp:onEdit(element) 
	if element then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	self.mode = "edit"
	WndSkillContainer:setSkillMode(self.mode)
	GetElement(self.m_root,"btnEdit",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(true)
	GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF):setVisible(true)
	self:_dealwithSkillAni(true)

    TeachGroup1:endTeachStep({5,4}) 
    if TeachGroup1.GROUP == 5 and TeachGroup1.STEP == 4 then
    	PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvClickEdit)
    	TeachGroup1:startGroup({5,5,WndSkillProp.m_root})
    end
end

--@brief	取消编辑模式
function WndSkillProp:onCancel(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.mode = nil
	WndSkillContainer:setSkillMode(self.mode)
	GetElement(self.m_root,"btnEdit",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnCancel",WZUIButton):setVisible(false)
	GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF):setVisible(false)
	self:_dealwithSkillAni(false)
end

--@brief	预览
function WndSkillProp:onPreview() 
	WZLog("WndSkillProp:onPreview")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"imgPreview",WZUIImage):setVisible(true)
	GetElement(self.m_root,"btnDisPreview",WZUIButton):setVisible(true)
	self.tempTitle = GetElement(self.m_root,"title2",WZUILabelTTF):getText()
	GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.NEWSKILL12)
end

--@brief	退出预览
function WndSkillProp:disPreview() 
	WZLog("WndSkillProp:disPreview")
	GetElement(self.m_root,"imgPreview",WZUIImage):setVisible(false)
	GetElement(self.m_root,"btnDisPreview",WZUIButton):setVisible(false)
	GetElement(self.m_root,"title2",WZUILabelTTF):setText(self.tempTitle)
end

--@brief	显示技能日志
function WndSkillProp:onLog() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conLog",WZUIContainer):setVisible(true)
end

--@brief	关闭技能日志
function WndSkillProp:closeLog() 
	GetElement(self.m_root,"conLog",WZUIContainer):setVisible(false)
end

--@brief	更新技能日志
function WndSkillProp:updateLog() 
	if self.m_root == nil then return end
	--技能红点
	WndSkillContainer:setSkillRed(CacheCenter:getSkillRed()) 

	local freeListContainer = GetElement(self.m_root,"freecon_WndSkillProp",WZUIFreeListContainer)
	freeListContainer:removeAll()

	local tData = CacheCenter:getSkill()
	--self.m_tSkill.logtype = logtype
	--self.m_tSkill.logskillId = logskillId
	--self.m_tSkill.mes = mes
	--没有数据时显示提示
	if tData.logtype == nil or #tData.logtype == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=#tData.logskillId,1,-1 do
--		WZLog("显示日志", i)
    	local freeLabel = WZUIFreeTextBox:create()
    	freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.7))
    	freeLabel:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    	if ProjConfig.LANGAUGE == "vn" then
    		freeLabel:setMaxWidth(320)
    	else
    		freeLabel:setMaxWidth(340)
    	end
	--NEWSKILL7 = [[<T C="255,227,116" S="20" P="0">%s 继承于武器Lv%s %s %s星</T>]],
		local tSkill = GDatatab_skill["id_"..tData.logskillId[i]]
		if tData.logtype[i] == 1 then
			--local level = string.sub(tSkill.lv_icon,-5,-5)
			local tMes = SplitStringWithSeparator(tData.mes[i],"|")
			local tItem = GDatatab_item["id_"..tMes[1]]
    		freeLabel:setShowText(string.format(LocalStrings.NEWSKILL7,tSkill.name,tMes[2],tItem.name,tMes[3]))
		elseif tData.logtype[i] == 2 then
    		freeLabel:setShowText(string.format(LocalStrings.NEWSKILL8,tSkill.name))
		elseif tData.logtype[i] == 3 then
			local point = 100
			if tSkill.upgrade ~= nil and type(tSkill.upgrade) == "table" then
				point = tSkill.upgrade[1][2]
			end
			local tUp = GDatatab_skill["id_"..tSkill.upgrade_id]
			if tUp ~= nil and tUp.name ~= nil then
    			freeLabel:setShowText(string.format(LocalStrings.NEWSKILL9,tUp.name,tostring(point)))
			end
		end
		
		freeListContainer:pushBack(freeLabel)
		freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
	end
end

--@brief	升级技能
function WndSkillProp:upSkill() 
	WZLog("WndSkillProp:upSkill")
	local knowledge_id = 85
	if ProjConfig.LANGUAGE == "vn" then
		knowledge_id = 86
	end
	if self.m_nWinType == 1 then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		if self.mode == "edit" then
			MsgBoxManager:showTipBox(LocalStrings.NEWSKILL27)
			return
		end

		self.m_root:enableSchedule("stopBlock",2)
	 
    	local curSkillInfo = GDatatab_skill["id_"..self.m_nCurShowSkillId]
		if curSkillInfo == nil then return end
    	local upgradeData = curSkillInfo.upgrade
		WZLog("WndSkillProp:upSkill1")
    	if type(upgradeData) == "table" then
			local skillNum = CacheCenter:getSkill().skillNum
			if upgradeData[1][1] == knowledge_id then 
				skillNum = CacheCenter:getPlayerItemCountById(upgradeData[1][1]) 
			elseif upgradeData[1][1] ~= 63 then 
				skillNum = CacheCenter:getPlayerItemCountById(upgradeData[1][1]) 
			end
			WZLog("WndSkillProp:upSkill2",skillNum,upgradeData[1][2])
			if tonumber(skillNum) >= tonumber(upgradeData[1][2]) then
				self.upTip = 2
				self.m_oCurSelectSkill = nil
				ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill( tonumber(self.m_nCurShowSkillId) )
			else
				if upgradeData[1][1] == 63 then 
					MsgBoxManager:showTipBox(LocalStrings.NEWSKILL13)
					self:onClickGet1(nil)
				elseif upgradeData[1][1] == knowledge_id then 
					MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, GDatatab_item["id_" .. upgradeData[1][1]].name))
					self:onClickGet1(nil)
				else
					MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, GDatatab_item["id_" .. upgradeData[1][1]].name))
					self:onClickGet1(nil)
				end
			end
		end
	elseif self.m_nWinType == 2 then
		WndSkillProp:onClickUpdateLevel()
	end
end

--@brief	重置技能
function WndSkillProp:onReset() 
	WZLog("WndSkillProp:onReset")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.mode == "edit" then
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL24)
		return
	end

	local itemNum = CacheCenter:getPlayerItemCount(2, 15)
	if itemNum <= 0 then
		checkIsOnSale(554)
	else
    	MsgBoxManager:showConfirmCancelBox(LocalStrings.NEWSKILL22 or "", self, self.onResetCall, nil)
	end
end

function WndSkillProp:onResetCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndSkillProp.m_oCurSelectSkill = nil
		ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill( )
	end
end

function WndSkillProp:selectFirst() 
	WZLog("WndSkillProp:selectFirst")
	if WndSkillProp.m_root == nil then return end
	if WndSkillProp.m_tAllSkillProps == nil or WndSkillProp.m_tAllSkillProps[1] == nil then return end

	local con = GetElement(WndSkillProp.m_root,"con_WndSkillProp",WZUIContainer)
	con:enableSchedule("selectFirstCall",0.3)
end
 
function WndSkillProp:selectFirstCall() 
	WZLog("WndSkillProp:selectFirstCall")
	local con = GetElement(WndSkillProp.m_root,"con_WndSkillProp",WZUIContainer)
	con:disableSchedule()

   	local skillInfo = self.m_tAllSkillProps[1]
	--WZLog("重置技能后选默认", Serialize(skillInfo))
    self:showSkillDetailInfo(skillInfo.id,bEquipped,true)
end

function WndSkillProp:stopBlock() 
	self.m_root:disableSchedule()
	WndSkillProp.learnTip = 0
	WndSkillProp.upTip = 0
end

--@brief 	设置道具动画
function WndSkillProp:playNodeAni(element, bPlay)
	-- body
	if element == nil then return end 

	if bPlay then
		element:stopAllActions()
		
		local scaleAni1 = CCScaleTo:create(0.4, 1.1)
		local scaleAni2 = CCScaleTo:create(0.4, 1)
		local sequenceAni = CCSequence:createWithTwoActions(scaleAni1, scaleAni2)
		local repeatAni = CCRepeatForever:create(sequenceAni)
		element:runAction(repeatAni)
	else
		element:stopAllActions()
	end
end

--@brief 	播放或停掉装备栏的动画
function WndSkillProp:_dealwithSkillAni(bPlay)
	-- body
	if self.m_tBtnEquipCell then
		for i = 1, #self.m_tBtnEquipCell do
			self:playNodeAni(self.m_tBtnEquipCell[i], bPlay)
		end
	end

	if self.m_tBtnActivitySkillNode then
		for i = 1, #self.m_tBtnActivitySkillNode do
			self:playNodeAni(self.m_tBtnActivitySkillNode[i], bPlay)
		end
	end
end

--@brief 	显示当前拥有的消耗物品
function WndSkillProp:_showOwnCostGood(skillId)
	-- body
	local knowledge_id = 85
	if ProjConfig.LANGUAGE == "vn" then
		knowledge_id = 86
	end
	if self.m_nWinType == 1 then
		local skillInfo = GDatatab_skill["id_" .. skillId]
		if skillInfo == nil then return end 
		if type(skillInfo.upgrade) == "table" then  
			local costId = skillInfo.upgrade[1][1]
			GetElement(self.m_root,"topImg1",WZUIImage):setFile(GDatatab_item["id_" .. costId].icon)
			GetElement(self.m_root,"topImg2",WZUIImage):setFile(GDatatab_item["id_" .. costId].icon)

			if costId == 63 then 
				local tData = CacheCenter:getSkill()
				GetElement(self.m_root,"txtPoint",WZUILabelTTF):setText(tData.skillNum)
			elseif costId == knowledge_id then 
				local nNum = CacheCenter:getPlayerItemCountById(costId)
				GetElement(self.m_root,"txtPoint",WZUILabelTTF):setText(nNum)
			else
				local nNum = CacheCenter:getPlayerItemCountById(costId)
				GetElement(self.m_root,"txtPoint",WZUILabelTTF):setText(nNum)
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配器模块Begin--------------------------------------


function WndSkillProp:_adaptLanguage_th()
    WZLog("WndSkillProp:_adaptLanguage_th ")
    -- local conActionValue3 = GetElement(self.m_root,"conActionValue3_WndSkillProp",WZUIContainer)
    -- conActionValue3:setRelativePosition(GlobalMethod:ccp(0.643894,0.829776))

    GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF):setMaxLength(0)
   
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setMaxLength(0)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(330))
    --txtSkillDescribe2:setRelativePosition(GlobalMethod:ccp(0.055,0.42))
end

function WndSkillProp:_adaptLanguage_en()
    WZLog("WndSkillProp:_adaptLanguage_en ")
    local conTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    conTitle2:setFontSize(12)

    local skillUnlock = GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF)
    skillUnlock:setScale(0.7)

    GetElement(self.m_root,"conCd1",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.48))
    GetElement(self.m_root,"conCd2",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.48))
    GetElement(self.m_root,"conCd3",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.61))
    GetElement(self.m_root,"conCd4",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.61))

    GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF):setMaxLength(0)
   
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setMaxLength(0)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(330))
    --txtSkillDescribe2:setRelativePosition(GlobalMethod:ccp(0.055,0.42))
    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
end

function WndSkillProp:_adaptLanguage_pt(  )
	local conTitle1 = GetElement(self.m_root,"txtConTitle1_WndSkillProp",WZUILabelTTF)
    conTitle1:setFontSize(13)
    conTitle1:setDimensions(GlobalMethod:CCSize(110,0))

	local conTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    conTitle2:setFontSize(12)

    local skillUnlock = GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF)
    skillUnlock:setScale(0.6)

    GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF):setMaxLength(0)
   
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setMaxLength(0)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(330))

    local txtTip2 = GetElement(self.m_root,"tip2",WZUILabelTTF)
    txtTip2:setDimensions(GlobalMethod:CCSize(260,0))

    local txtSkillDescribe1 = GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe1:setScale(0.8)
    txtSkillDescribe1:setDimensions(GlobalMethod:CCSize(300))

    GetElement(self.m_root,"btnLog_WndSkillProp",WZUIButton):setScale(0.8)

    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
    txtEquipAtt:setScale(0.6)
end

function WndSkillProp:_adaptLanguage_vn()
    WZLog("WndSkillProp:_adaptLanguage_vn ")
    GetElement(self.m_root,"txtBuySP_WndSkillProop",WZUILabelTTF):setScale(0.8)
    -- local conTitle1 = GetElement(self.m_root,"txtConTitle1_WndSkillProp",WZUILabelTTF)
    -- conTitle1:setFontSize(13)
    --conTitle1:setDimensions(GlobalMethod:CCSize(100,0))

    local conTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    conTitle2:setFontSize(12)
    --conTitle2:setDimensions(GlobalMethod:CCSize(100,0))

    GetElement(self.m_root,"txtSkillLock_WndSkillProp",WZUILabelTTF):setScale(0.8)
    local skillUnlock = GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF)
    skillUnlock:setScale(0.7)
    skillUnlock:setDimensions(GlobalMethod:CCSize(60,0))

    local txtSkillDescribe1 = GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe1:setScaleX(0.7)
    txtSkillDescribe1:setScaleY(0.7)
    txtSkillDescribe1:setScale(0.7)
    txtSkillDescribe1:setDimensions(GlobalMethod:CCSize(450))
    txtSkillDescribe1:setRelativePosition(GlobalMethod:ccp(0.05,0.21))
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setScaleX(0.7)
    txtSkillDescribe2:setScaleY(0.7)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(450))
    txtSkillDescribe2:setRelativePosition(GlobalMethod:ccp(0.02,0.75))

    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setFontSize(14)
    local skillPreviewLabel = GetElement(self.m_root,"skillPreviewLabel",WZUILabelTTF)
    if skillPreviewLabel then
    	skillPreviewLabel:setScale(0.85)
    end
end

function WndSkillProp:_adaptLanguage_tr(  )
	-- local conTitle1 = GetElement(self.m_root,"txtConTitle1_WndSkillProp",WZUILabelTTF)
 --    conTitle1:setFontSize(13)
 --    conTitle1:setDimensions(GlobalMethod:CCSize(110,0))

	local conTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    conTitle2:setFontSize(12)

    local skillUnlock = GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF)
    skillUnlock:setScale(0.55)

    GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF):setMaxLength(0)
   
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setMaxLength(0)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(330))

    -- local txtTip2 = GetElement(self.m_root,"tip2",WZUILabelTTF)
    -- txtTip2:setDimensions(GlobalMethod:CCSize(260,0))

    local txtSkillDescribe1 = GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe1:setScale(0.8)
    txtSkillDescribe1:setDimensions(GlobalMethod:CCSize(300))

    --GetElement(self.m_root,"txtBuySP_WndSkillProop",WZUILabelTTF):setScale(0.6)

    for i=1,2 do
    	local txtUp = GetElement(self.m_root,"txtUp"..i.."_WndSkillProp",WZUILabelTTF)
    	txtUp:setScale(0.7)
    	txtUp:setDimensions(GlobalMethod:CCSize(110,0))
    	local txtAct = GetElement(self.m_root,"txtAct"..i,WZUILabelTTF)
    	txtAct:setScale(0.7)
    	txtAct:setDimensions(GlobalMethod:CCSize(110,0))
    end

    --GetElement(self.m_root,"txtSkillLock_WndSkillProp",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"txtSkillName_WndSkillProp",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"conCd1",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.41,0.48))
    GetElement(self.m_root,"conCd2",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.41,0.48))
    GetElement(self.m_root,"conCd3",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.61))
    GetElement(self.m_root,"conCd4",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.61))

    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setScale(0.7)
end

function WndSkillProp:_adaptLanguage_es(  )
	local conTitle1 = GetElement(self.m_root,"txtConTitle1_WndSkillProp",WZUILabelTTF)
    conTitle1:setFontSize(13)
    conTitle1:setDimensions(GlobalMethod:CCSize(110,0))

	local conTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    conTitle2:setFontSize(12)

    local skillUnlock = GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF)
    skillUnlock:setScale(0.6)

    GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF):setMaxLength(0)
   
    local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe2:setMaxLength(0)
    txtSkillDescribe2:setScale(0.7)
    txtSkillDescribe2:setDimensions(GlobalMethod:CCSize(330))

    local txtTip2 = GetElement(self.m_root,"tip2",WZUILabelTTF)
    txtTip2:setDimensions(GlobalMethod:CCSize(260,0))

    local txtSkillDescribe1 = GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF)
    txtSkillDescribe1:setScale(0.8)
    txtSkillDescribe1:setDimensions(GlobalMethod:CCSize(300))

    GetElement(self.m_root,"txtBuySP_WndSkillProop",WZUILabelTTF):setScale(0.6)

    for i=1,2 do
    	local txtUp = GetElement(self.m_root,"txtUp"..i.."_WndSkillProp",WZUILabelTTF)
    	txtUp:setScale(0.7)
    	txtUp:setDimensions(GlobalMethod:CCSize(110,0))
    end

    GetElement(self.m_root,"txtSkillLock_WndSkillProp",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"txtSkillName_WndSkillProp",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"conCd1",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.23,0.48))
    GetElement(self.m_root,"conCd2",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.23,0.48))
    GetElement(self.m_root,"conCd3",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.41,0.61))
    GetElement(self.m_root,"conCd4",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.41,0.61))
    
    GetElement(self.m_root,"btnLog_WndSkillProp",WZUIButton):setScale(0.8)

    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
    txtEquipAtt:setScale(0.6)
end

function WndSkillProp:_adaptLanguage_ug(  )
	local freecon = GetElement(self.m_root,"freecon_WndSkillProp",WZUIFreeListContainer)
	freecon:setRelativePosition(GlobalMethod:ccp(0.5,0.42))

	local txtConTitle1 = GetElement(self.m_root,"txtConTitle1_WndSkillProp",WZUILabelTTF)
    txtConTitle1:setScale(0.6)
    txtConTitle1:setDimensions(GlobalMethod:CCSize(110,0))
	local txtConTitle2 = GetElement(self.m_root,"txtConTitle2_WndSkillProp",WZUILabelTTF)
    txtConTitle2:setScale(0.6)
    txtConTitle2:setDimensions(GlobalMethod:CCSize(160,0))
    txtConTitle2:setAlignment(kCCTextAlignmentCenter)

    local txtBuySP = GetElement(self.m_root,"txtBuySP_WndSkillProop",WZUILabelTTF)
    txtBuySP:setScale(0.45)
    txtBuySP:setDimensions(GlobalMethod:CCSize(110))
    GetElement(self.m_root,"txtSkillLock_WndSkillProp",WZUILabelTTF):setScale(0.5)
    GetElement(self.m_root,"txtSkillUnlock_WndSkillProp",WZUILabelTTF):setScale(0.5)

    local txtSkillName = GetElement(self.m_root,"txtSkillName_WndSkillProp",WZUILabelTTF)
    txtSkillName:setScale(0.7)
    txtSkillName:setDimensions(GlobalMethod:CCSize(300))
    GetElement(self.m_root,"title2",WZUILabelTTF):setScale(0.7)

	local txtSkill1 = GetElement(self.m_root,"txtSkill1_WndSkillProp",WZUILabelTTF)
	txtSkill1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtSkill1:setRelativePosition(GlobalMethod:ccp(0.67,0.73))
	local txtSkill2 = GetElement(self.m_root,"txtSkill2_WndSkillProp",WZUILabelTTF)
	txtSkill2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtSkill2:setRelativePosition(GlobalMethod:ccp(0.67,0.6))
	local txtCDT1 = GetElement(self.m_root,"txtCDT1_WndSkillProp",WZUILabelTTF)
	txtCDT1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtCDT1:setRelativePosition(GlobalMethod:ccp(0.67,0.47))
	local txtSkill3 = GetElement(self.m_root,"txtSkill3_WndSkillProp",WZUILabelTTF)
	txtSkill3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtSkill3:setRelativePosition(GlobalMethod:ccp(0.67,0.73))
	local txtSkill4 = GetElement(self.m_root,"txtSkill4_WndSkillProp",WZUILabelTTF)
	txtSkill4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtSkill4:setRelativePosition(GlobalMethod:ccp(0.67,0.6))
	local txtCDT2_WndSkillProp = GetElement(self.m_root,"txtCDT2_WndSkillProp",WZUILabelTTF)
	txtCDT2_WndSkillProp:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtCDT2_WndSkillProp:setRelativePosition(GlobalMethod:ccp(0.67,0.47))

	local txtUp1 = GetElement(self.m_root,"txtUp1_WndSkillProp",WZUILabelTTF)
	txtUp1:setScale(0.7)
	txtUp1:setDimensions(GlobalMethod:CCSize(140))
	local txtUp2 = GetElement(self.m_root,"txtUp2_WndSkillProp",WZUILabelTTF)
	txtUp2:setScale(0.7)
	txtUp2:setDimensions(GlobalMethod:CCSize(140))
	
    local txtEquipAtt = GetElement(self.m_root, "txtEquipAtt_WndSkillProp", WZUILabelTTF)
    txtEquipAtt:setRelativePosition(GlobalMethod:ccp(0.86,0.5))
    txtEquipAtt:setScale(0.6)
    txtEquipAtt:setDimensions(GlobalMethod:CCSize(420))
end
-------------------------------------语言适配器模块End----------------------------------------
