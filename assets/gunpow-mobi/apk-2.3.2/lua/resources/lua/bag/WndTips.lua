--WndTips.lua
--@brief	WndTips的UI模块
--@date		2015/07/13
--@author	zsq
--@note		点击弹出的Tips窗口

--主流程
--外部调用入口				WndTips:show(）
--更新界面					WndTips:_update()


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTips:onEnter(element)
	self.m_root = element
	WZLog("WndTips:onEnter")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTips:onExit(element)
	self:_unInit()
end

--@brief	触摸事件
function WndTips:onTouchBegan(element, pt)
	WZLog("WndTips:onTouchBegan")
	if self.m_nType == 90 or self.m_nType == 3 then  
		if WndItemInfo.m_root then 
			return 
		end
	end
	
	if not WndTips:checkPointInBtn(pt) then
		WndTips:_onCloseClick()
	end
end

--@brief	检查坐标点是否在VIP按钮范围内
--@param	pt:鼠标点击的世界坐标
--@return	在按钮范围内返回true,否则返回false
function WndTips:checkPointInBtn(pt)
	WZLog("WndTips:checkPoint")
	if self.m_root == nil then return end
	local btn
	if self.m_nType == 3 then
		btn = GetElement(self.m_root, "conType3_WndTips", WZUIContainer)
	elseif self.m_nType == 13 then
		-- if self.m_tData.tBtnList then
		-- 	btn = GetElement(self.m_root,"btnExtraction_WndTips",WZUIButton)
		-- end
		btn = GetElement(self.m_root, "conType23_WndTips", WZUIContainer)
	elseif self.m_nType == 18 then
		btn = GetElement(self.m_root,"btnType16_WndTips",WZUIButton)
	elseif self.m_nType == 20 then
		btn = GetElement(self.m_root,"btn1Type18_WndTips",WZUIButton)
	elseif self.m_nType == 21 then
		btn = GetElement(self.m_root, "conType19_WndTips", WZUIContainer)
	elseif self.m_nType == 22 then
		btn = GetElement(self.m_root, "conType20_WndTips", WZUIContainer)
	elseif self.m_nType == 23 then
		btn = GetElement(self.m_root, "conType21_WndTips", WZUIContainer)
	elseif self.m_nType == 24 then
		btn = GetElement(self.m_root,"btnType22_WndTips",WZUIButton)
	elseif self.m_nType == 25 then
		btn = GetElement(self.m_root,"btnOperate1_WndTips",WZUIButton)
		btn2 = GetElement(self.m_root,"btnOperate2_WndTips",WZUIButton)
		local btnSize2 = btn2:getContentSize()
		local ptB = btn2:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
			return true
		end
	elseif self.m_nType == 26 then
		return self:checkInBtnType26(pt)
	elseif self.m_nType == 30 then --公会战队伍tips
		btn = GetElement(self.m_root,"btnOperate2_WndTips29",WZUIButton)
		btn2 = GetElement(self.m_root,"btnOperate1_WndTips29",WZUIButton)
		if btn2:isVisible() then
			local btnSize2 = btn2:getContentSize()
			local ptB = btn2:convertToWorldSpace(GlobalMethod:ccp(0,0))
			if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
				return true
			end
		end
	elseif self.m_nType == 35 then
		btn = GetElement(self.m_root,"btnType35_WndTips",WZUIButton)
	elseif self.m_nType == 45 then 
		btn = GetElement(self.m_root,"btnType45_WndTips",WZUIButton)
	elseif self.m_nType == 51 then 
		btn = GetElement(self.m_root,"btnDrop_WndTips50",WZUIButton)
	elseif self.m_nType == 54 then 
		btn = GetElement(self.m_root,"btnChallenge_WndTips51",WZUIButton)
		conHead = GetElement(self.m_root, "conHead_WndTips51", WZUIContainer)
		local btnSize2 = conHead:getContentSize()
		local ptB = conHead:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
			return true
		end

		btnRefresh = GetElement(self.m_root, "btnRefresh_WndTips51", WZUIButton)
		btnSize2 = btnRefresh:getContentSize()
		ptB = btnRefresh:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
			return true
		end
	elseif self.m_nType == 58 then 
		btn = GetElement(self.m_root, "conType49_WndTips", WZUIContainer)
	elseif self.m_nType == 70 then 
		btn = GetElement(self.m_root, "btnEquip_WndAssistSkill", WZUIButton)
	elseif self.m_nType == 75 then 
		btn = GetElement(self.m_root, "conChooseOut_WndTips30", WZUIContainer)
	elseif self.m_nType == 76 then 
		btn = GetElement(self.m_root, "conCircleReward_WndTips30", WZUIContainer)
	elseif self.m_nType == 77 then 
		btn = GetElement(self.m_root, "cellChooseBlessCard_WndTips30", WZUIContainer)
	elseif self.m_nType == 10 then 
		btn = GetElement(self.m_root, "conType9_WndTips", WZUIContainer)
	elseif self.m_nType == 83 then 
		btn = GetElement(self.m_root, "conType10_1_WndTips", WZUIContainer)
	elseif self.m_nType == 90 then 
		btn = GetElement(self.m_root, "conHVFlowerpot_WndTips30", WZUIContainer)
	end
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("获得btn 世界坐标",ptA.x,ptA.y)
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		return true
	else
		return false
	end 

end

function WndTips:checkInBtnType26(pt)
	WZLog("WndTips:checkInBtnType26")
	for i=1,4 do
		local btn = GetElement(self.m_root, "btnHead"..i.."Type25_WndTips", WZUIButton)
		if btn == nil then return false end
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		WZLog("获得btn 世界坐标",ptA.x,ptA.y)
		WZLog("按钮大小",btnSize.width,btnSize.height)
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end
	return false
end

--@brief	充值VIP
function WndTips:onVIP1(element)
	WZLog("WndTips:onVIP1")
	PassportSdkManager:gotoPaymentPage(0)
	self:_onCloseClick()
end

--@brief	查看特权
function WndTips:onVIP2(element)
	WZLog("WndTips:onVIP2")
	PassportSdkManager:gotoPaymentPage(1)
	self:_onCloseClick()
end

--@brief	点击技能TIps按钮
function WndTips:onClick16()
	WZLog("WndTips:onClick16")
	local tData = self.m_tData
	--按钮状态
	-- if tData.state == 1 then
	-- 	WndSkillProp:onClickUsed(tData.tag)
	-- elseif tData.state == 2 then
	-- elseif tData.state == 3 then
	-- elseif tData.state == 4 then
	-- 	WndSkillProp:onClickUnlocked(tData.tag)
	-- elseif tData.state == 5 then
	-- 	WndSkillProp:onClickTakeOff(tData.tag)
	-- end
	self:_onCloseClick()
end

--@brief	点击技能TIps按钮
function WndTips:onClick22()
	WZLog("WndTips:onClick22")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = self.m_tData
	if tData.btnType and tData.btnType == 1 then
		WndPetsSkill:doLock(tData)
	else
		--按钮状态
		--WndSophisticStrengthen:onClickLockCallBack(tData)
		WndSophistic:onClickLockCallBack(tData)
	end
	
	self:_onCloseClick()
end

--@brief 	点击祝福Tips按钮
function WndTips:onClick25_Left()
	-- body
	WZLog("WndTips:onClick25_Left")
	local tData = self.m_tData
	local tCallBack = tData.tCallBack
	if tCallBack == nil then return end

	if tData.basicInfo.sub_type == 31 then 
		tCallBack[4](tCallBack[1], tData)
	else 
		tCallBack[2](tCallBack[1], tData)
	end

	self:_onCloseClick()
end

--@brief 	点击祝福Tips按钮
function WndTips:onClick25_Right()
	-- body
	WZLog("WndTips:onClick25_Right")
	local tData = self.m_tData

	local tCallBack = tData.tCallBack
	if tCallBack == nil then return end

	if tData.userType == 1 then -- 拾取
		tCallBack[3](tCallBack[1], tData)
	elseif tData.userType == 2 then --装备
		tCallBack[3](tCallBack[1], tData)
	elseif tData.userType == 3 then --卸下
		tCallBack[4](tCallBack[1], tData)
	elseif tData.userType == 4 then -- 購買
		tCallBack[2](tCallBack[1], tData)
	elseif tData.userType == 6 then --前往祈福
		tCallBack[2](tCallBack[1], tData)
	elseif tData.userType == 7 then --萃取
		tCallBack[2](tCallBack[1], nil, tData)
	end

	self:_onCloseClick()
end

function WndTips:onClickExtraction(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tCallBack then
		self.m_tCallBack[2](self.m_tCallBack[1], nil, self.m_tData)
	end

	self:_onCloseClick()
end
--@brief 	点击公会战队伍tips取消参战按钮回调
function WndTips:onClick30_Up()
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCompeteMember:onClickTeamBtn(self.m_tData.teamId, self.m_tData.id, WndCompeteMember.m_tClickCell)

	self:_onCloseClick()
end

--@brief 	点击公会战队伍tips查看信息按钮回调
function WndTips:onClick30_Down()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    WndCheckOther:show(self.m_tData.id)
	self:_onCloseClick()
end

--@brief	点击购买符文
function WndTips:onClick35()
	WZLog("WndTips:onClick35")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.callbackLua and self.m_tData.callbackLuaFun then
		self.m_tData.callbackLuaFun(self.m_tData.callbackLua)
	end
	self:_onCloseClick()
end

--@brief	点击战队头像
function WndTips:onCheckType26(element)
	WZLog("WndTips:onCheckType26",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId[element:getTag()])

	self:_onCloseClick()
end

--@brief	点击觉醒之力tips升级或激活按钮
function WndTips:onCheckType45(element)
	WZLog("WndTips:onCheckType45",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellWakeupDetail:onClickPowerUpgrade(self.m_tData)

	self:_onCloseClick()
end

--@brief 	点击幽灵技能丢弃按钮回调
function WndTips:onClickDrop(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndBattleHud:onClickDrop(self.m_tData)

	self:_onCloseClick()
end

--@brief 	点击英雄塔tips头像回调
function WndTips:onCheckInfo(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tData.playerInfo.playerId)
	self:_onCloseClick()
end

--@brief 	点击英雄塔tips挑战按钮回调
function WndTips:onClickChallenge(element)
	--body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndTowerScroll:onChallengeCallBack()

	self:_onCloseClick()
end

--@brief 	点击英雄塔tips刷新按钮回调
function WndTips:onClickRefresh(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndTowerScroll:callRefreshEnemy(self.m_tData)
end

--@brief 	鲜花羁绊和踩一踩羁绊
function WndTips:onClickHead52(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WndCheckOther:show(self.m_tData[nTag].playerId)
	self:_onCloseClick()
end

--@brief 	辅助技能点击装备卸下按钮回调
function WndTips:onClickEquip(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndAssistSkill:tipsBtnCallBack(self.m_tData)
	self:_onCloseClick()
end

--@brief 	点击头像回调
function WndTips:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 21 then --公会
		WndCheckOther:show(tonumber(self.m_tData.guildInfo[1].playerId))
	elseif self.m_nType == 22 then --恩爱
		WndCheckOther:show(self.m_tData.playerId)
	elseif self.m_nType == 23 then --师德
		local nTag = element:getTag()
		WndCheckOther:show(nTag)
	end
	self:_onCloseClick()
end

--@brief 	点击选择出生年月日，选择城市
function WndTips:onClickTab30(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local value = nTag
	if self.m_tData.type == 1 then --年 
		value = nTag
	elseif self.m_tData.type == 2 then --月
		value = nTag
	elseif self.m_tData.type == 3 then --日
		value = nTag
	elseif self.m_tData.type == 4 then --省份
		value = nTag
	elseif self.m_tData.type == 5 then --市
		value = nTag
	elseif self.m_tData.type == 10 then --祝福语
		WndChallengeLevel:exchangeBlessWordOK(nTag)
		self:_onCloseClick()
		return 
	elseif self.m_tData.type == 11 then --调研-选择省份
		self.m_tData.tCell:chooseAnswerCallBack(nTag)
		self:_onCloseClick()
		return
	end
	WndCheckOther:updateSetShow(self.m_tData.type, value)
	self:_onCloseClick()
end

--@brief 	点击选中祝福卡
function WndTips:onClickCard(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()

	local tItemIds = self.m_tData.itemIds
	if nTag == 1 then 
		if self.m_tData.num1 <= 0 then  
			local basicInfo = GDatatab_item["id_" .. tItemIds[nTag]]
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicInfo.name))
			return
		end
	elseif nTag == 2 then 
		if self.m_tData.num2 <= 0 then 
			local basicInfo = GDatatab_item["id_" .. tItemIds[nTag]]
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicInfo.name))
			return
		end
	end
	WndHouseInvite:chooseCardCallBack(self.m_tData, nTag)
	self:_onCloseClick()
end

--@brief 	点击度假村土坑按钮回调
function WndTips:onClickHVBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WndHVOperate:onClickOperateCallBack(nTag, element)
	self:_onCloseClick()
end

--@brief 	点击按钮触发回调方法
function WndTips:onClickTipsBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tag = element:getTag()

	if self.m_tCallBack then
		self.m_tCallBack[2](self.m_tCallBack[1], tag, self.m_tData)
	end

	self:_onCloseClick()
end

--@brief	关闭回调函数
function WndTips:onCloseClick()

end

--@brief	关闭回调函数
function WndTips:_onCloseClick()
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 5 and TeachGroup1.STEP == 5
	WZLog("WndTips:_onCloseClick",type(self.m_root), tostring(isTeach))
	if self.m_root == nil or isTeach then
		return
	end
	if self.m_bLongPressTouch then
		return
	end
	--如果格子有高亮方法，设置格子高亮
	local tObj = self.m_tHighLightObj
	if tObj and tObj.setHighLight then
		tObj:setHighLight(false)
	end
	if self.m_nType == 75 and self.m_tData.type == 11 then 
		if self.m_tData.tCell then 
			self.m_tData.tCell:chooseAnswerCallBack()
		end
	elseif self.m_nType == 83 then 
		local clickInfo = SceneHolidayVillage:getClickFieldData()
		if clickInfo and clickInfo.tCell then
	        clickInfo.tCell:setArrowVisible(false)
	    end
	end
	self.m_bIsVisible = false
	self.m_root:removeFromParentAndCleanup(true)
end

--@brief	显示Tips
--@param	element:表绑定的UI节点引用
--@param	parentElement:表绑定的UI的父类节点引用
--@param	nType:tip信息的类型:1通用,2背包属性,3单人副本宝箱,4竞技属性,5宠物,6坐骑总属性,7师德属性,8通用显示图片标题属性9锻造套装10活跃度物品11装备套装12解锁功能
--@param	nType:tip信息的类型:13宠物属性14单个坐骑tip15怪物头像16宝箱17竞技18道具19星魂20VIP21公会26战队27排位赛属性28修炼31密友
--@param	tData:tip信息的数据列表
--@param	pt:窗口位置偏移
--@param	bShowAll:是否适配
-- nCount : 显示的个数
-- bAuto : 自动对位置
-- bShowBtn : 是否显示底部按钮
-- tOther : 扩展参数
function WndTips:show(element,parentElement,nType,tData,offset,bShowAll,bAuto,bShowBtn, tOther)
	--WZLog("WndTips:show",nType,type(WndTips),self.m_bIsVisible,Serialize(tData))
	if element == nil or parentElement == nil then return end
	if self.m_root ~= nil then return end
	bAuto = bAuto or nil
	self.m_bShowBtn = bShowBtn or nil
	self.m_bLongPressTouch = nil --坐骑灵石强化的长按处理
	self.m_bTouchSwallow = false
	self.m_bSpaceMountStone = nil --空间坐骑灵石
	self.m_tOtherData = tOther
	if tOther then
		if tOther.bLongTouch == true then
			self.m_bLongPressTouch = true
		end
		if tOther.touchSwallow == true then
			self.m_bTouchSwallow = true
		end
		if tOther.spaceStone == true then
			self.m_bSpaceMountStone = true
		end
	end
	WZTempLog("nType....: ", nType)
	self.m_bIsVisible = false
	if self.m_bIsVisible == nil then self.m_bIsVisible = false end
	if self.m_bIsVisible == false then
		self.nCount = tData and tData.count or 4 --默认4个
		self.m_nType = nType
		self.m_tData = tData
		self.m_bIsVisible = true

		local wndTips = WndTips:createElement()
		if bShowAll then
			wndTips:setShowAll(bShowAll)
		end
		self.m_root:setTouchSwallow(true)
		parentElement:setTouchSwallow(true)
		parentElement:addChild(wndTips,1999,999)
		self:_createBtn()
		self:setWindowPosition(element,parentElement,nType,offset, bAuto)
		self["_update"..self.m_nType](self)

		--如果格子有高亮方法，设置格子高亮
		local tObj = nil
		if tData ~= nil then
			self.m_tHighLightObj = tData.highLightObj
			tObj = tData.highLightObj
		end
		if tObj and tObj.setHighLight then
			tObj:setHighLight(true)
		end
		AdaptLanguage(self)
	elseif self.m_bIsVisible == true then
		self:_onCloseClick()
	end
	self.m_bLongPressTouch = nil
end
--@brief	创建按钮
function WndTips:_createBtn()
	if self.m_root:getChildByTag(0) then
		self.m_root:removeChildByTag(0, true)
	end

	local btn = WZUIImage:create()
	btn:setLuaTouchEndedFunction("_onCloseClick")
	btn:setAnchorPoint(ccp(0.5,0.5))
	btn:setRelativePosition(ccp(0.5,0.5))
	btn:setTouchSwallow(self.m_bTouchSwallow)
	btn:setScale(66)
	btn:setFile("ui/common/common_black_bg.png")
	btn:setOpacity(0)
	self.m_root:addChild(btn,-10,0)
end

--@brief	设置窗口位置
function WndTips:setWindowPosition(element,parentElement,nType,offset, bAuto)
	-- 获得element的世界坐标  
	-- 以element坐标系为起点，向根节点(世界坐标)变换，坐标必须为(0,0)  
	local ptA = element:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("获得element 世界坐标方法1",ptA.x,ptA.y)

	-- 获得element在parentElement坐标系中的坐标  
	local pt = parentElement:convertToNodeSpace(ptA)
	WZLog("获得element 在parentElement中的坐标",pt.x,pt.y,nType)

	if nType == 8 then
		if pt.x < 155 then
			pt.x = 155
		end
		if pt.x > 790 then
			pt.x = 790
		end
	end

	if offset ~= nil then
		pt.x = pt.x + offset.x
		pt.y = pt.y + offset.y
	end

	self.m_root:setPosition(pt)

	--获得窗口的世界坐标
	local worldPosition = self.m_root:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("窗口世界坐标",worldPosition.x,worldPosition.y)
	--检查上超框
	local con = GetElement(self.m_root,"conType"..string.sub(self.xmlName, 8).."_WndTips",WZUIContainer)
	local screenSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
	if con ~= nil then
		local size = con:getAbsContentSize()
		if bAuto == true then
			self.m_root:setAnchorPoint(GlobalMethod:ccp(0,1))
			self.m_root:setPosition(pt)
		else
			WZLog("check_up_side", screenSize.width, screenSize.height, worldPosition.x, worldPosition.y, size.width, size.height, worldPosition.y+size.height/2)
			local maxHeight = worldPosition.y+size.height/2
			WZLog("check_up_side_0", nType, maxHeight + 50, screenSize.height)
			if maxHeight + 50 > screenSize.height then
				local down = (maxHeight - screenSize.height + 100)
				WZLog("check_up_side_1", nType, down)
				pt.y = pt.y - down
			end
			self.m_root:setPosition(pt)
		end
	else
		
	end

	--检查下超框
	if nType == 13 or nType == 14 or nType == 19 or nType == 26 or nType == 70 then
		if worldPosition.y < 120 then
			local offsetH = 120 - worldPosition.y
			pt.y = pt.y + offsetH + 5
			self.m_root:setPosition(pt)
		end
	elseif nType == 23 then 
		local size = con:getAbsContentSize()
		if worldPosition.y > screenSize.height/2 then
			pt.y = screenSize.height/2
			self.m_root:setPosition(pt)
		elseif worldPosition.y - size.height/2 < 0 then 
			pt.y = screenSize.height/2
			self.m_root:setPosition(pt)
		end
	elseif nType == 25 then
		--祝福tip
		local positionX = element:getPositionX()
		local positionY = element:getPositionY()
		local newPt = element:convertToWorldSpace(GlobalMethod:ccp(positionX, positionY))
		local conOuside = GetElement(self.m_root, "conOuside_WndTips", WZUIContainer)
		local conSize = conOuside:getAbsContentSize()

		local tipPt = GlobalMethod:ccp(newPt.x + conSize.width/2, newPt.y)
		if tipPt.y + conSize.height/2 >= screenSize.height then 
			tipPt.y = tipPt.y - (tipPt.y + conSize.height/2 - screenSize.height + 20)
		end

		if tipPt.y - conSize.height/2 < 0 then 
			tipPt.y = conSize.height/2 + 20
		end

		if tipPt.x + conSize.width >= screenSize.width then
			tipPt.x = tipPt.x - conSize.width/3*4
		end

		if tipPt.x - conSize.width/2 <= 0 then
			tipPt.x = tipPt.x + conSize.width/2
		end

		self.m_root:setPosition(tipPt)
	end
end

--@brief	更新类型1	tips
function WndTips:_update1()
	WZLog("WndTips:_update1")
	local tData = self.m_tData
	local conType1 = GetElement(self.m_root,"conType1_WndTips",WZUIContainer)
	conType1:setVisible(true)

	if tData.showType == 2 then
		local imgTemp = GetElement(self.m_root,"img_WndTips",WZUIImage)
		imgTemp:setFile("")
		
		local conIcon = GetElement(self.m_root, "conIcon_WndTips1", WZUIContainer)
		local existSpine = CheckEffectFile(self.m_tData.animation)
    	if existSpine then 
			local spine = WZUISpine:create()
			spine:setTouchEnable(false)
			spine:setFileJson(self.m_tData.animation..".json")
			spine:setFileAtlas(self.m_tData.animation..".atlas")
			spine:setUseOriginSize(true)
			spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			spine:play(self.m_tData.action,true)
			spine:setScale(0.4)
			conIcon:addChild(spine)
		elseif tData.icon then 
			imgTemp:setFile(tData.icon)
			imgTemp:setScale(0.25)
		end

		GetElement(self.m_root,"title",WZUIFreeTextBox):setShowText(self.m_tData.title)
	else
		local btnDisplceMaster = GetElement(conType1,"btnDisplceMaster",WZUIButton)
		if self.m_tOtherData and self.m_tOtherData.isSelf == true then
			btnDisplceMaster:setVisible(true)
			conType1:setAbsContentSize(GlobalMethod:CCSize(236,154))
			conType1:updateRelativeSize()
			GetElement(conType1,"type1_con",WZUIContainer):setRelativePosition(ccp(0.5,0.65))
			local temp_str = {LocalStrings.MASTERINFO18, LocalStrings.MASTERINFO19}
			GetElement(btnDisplceMaster,"txtBtnDisplceMaster",WZUILabelTTF):setText(temp_str[self.m_tOtherData.state])
			local btnDisplceMaster = WZUIButton:create()
		    btnDisplceMaster:setUseAbsSize(true)
		    btnDisplceMaster:setRelativePosition(GlobalMethod:ccp(0.97, 0.0))
		end
		tData.scale = tData.scale or 1
		local img_WndTips = GetElement(self.m_root,"img_WndTips",WZUIImage)
		img_WndTips:setFile(tData.icon)
		img_WndTips:setScale(tData.scale)

		GetElement(self.m_root,"title",WZUIFreeTextBox):setShowText(tData.title)
		--等级不为nil显示数字
		local px = tData.px or 0.25
		local py = tData.py or 0.445
		if tData.level ~= nil then
			GetElement(self.m_root,"numType1_WndTips",WZUILabelAtlasFont):setVisible(true)
			GetElement(self.m_root,"numType1_WndTips",WZUILabelAtlasFont):setText(tData.level)
			if tData.px ~= nil then
				GetElement(self.m_root,"numType1_WndTips",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(px,py))
			end
		else
			GetElement(self.m_root,"numType1_WndTips",WZUILabelAtlasFont):setVisible(false)
		end
		if tData.pvprankMark ~= nil and tData.pvprankMark == 1 then
			img_WndTips:setVisible(false)
			GetElement(self.m_root,"numType1_WndTips",WZUILabelAtlasFont):setVisible(false)
			local conIcon = GetElement(self.m_root, "conIcon_WndTips1", WZUIContainer)
			if conIcon then
				local celElement, tNewObj = CellPvpLevelIcon:createElement()
		        if celElement and tNewObj then
		        	local tTempData = GetPvpDataByLevel(tData.level)
		            tNewObj:setData(tTempData, false, 0.4, false)
		            celElement:setScale(0.4)
		            conIcon:addChild(celElement)
		        end
			end
		end
	end

	if ProjConfig.LANGUAGE == "en" then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
		title:setScale(0.8)
		title:setMaxWidth(220)
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
		title:setScale(0.65)
	elseif ProjConfig.LANGUAGE == "vn" then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setMaxWidth(140)
	elseif "ug" == ProjConfig.LANGUAGE then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setScale(0.7)
		title:setMaxWidth(200)
	end
end
function WndTips:onBtnDisplceMaster()
	local otherInfo = WndCheckOther.m_tPlayerInfo
	local str = LocalStrings.MASTERINFO10
	local _type = 1
	if self.m_tOtherData.state == 2 then
		str = LocalStrings.MASTERINFO12
		_type = 2
	end
	local chatMsg = g_MasterMessage_Mark .. str
	local special_str = g_MasterMsgPrivate .. _type

	local playerInfo = CacheCenter:getPlayerInfo()
	local textTable = {lv="Lv"..playerInfo.level,name=playerInfo.name,info=chatMsg,date=os.date("%m-%d %H:%M",os.time())}
	local text = json.encode(textTable)
	if _type == 1 then
		ProtocolProcessorWndMaster:send_MENTORING_Baishi(otherInfo.id, text)
	elseif _type == 2 then
		ProtocolProcessorWndMaster:send_MENTORING_Shoutu(otherInfo.id, text)
	end

	WndChat:sendChat(CHANNEL_WHISPER,chatMsg..special_str, otherInfo.id, otherInfo.name, otherInfo.sex, otherInfo.level,otherInfo.vipLevel, 
					 otherInfo.headId, otherInfo.faceId, otherInfo.headColor, otherInfo.headEffectId)
	if self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	end
end
--@brief	更新类型2	tips
function WndTips:_update2()
	WZLog("WndTips:_update2")
	local tData = self.m_tData
	GetElement(self.m_root,"conType2_WndTips",WZUIContainer):setVisible(true)
	for i=1,13 do
		GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setShowText(tData["attrInfo"..i])
	end

	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language or "pt" == language or "tr" == language then
		GetElement(self.m_root,"attrInfo6",WZUIFreeTextBox):setScale(0.85)
	elseif "th" == language then
		GetElement(self.m_root,"attrInfo6",WZUIFreeTextBox):setScale(0.85)
	elseif "es" == language then
		for i=1,13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setMaxWidth(400)
		end
	end
end

--@brief	更新类型3	tips
function WndTips:_update3()
	local tData = self.m_tData
	local conType3 = GetElement(self.m_root,"conType3_WndTips",WZUIContainer)
	conType3:setVisible(true)
	if self.nCount > 4 then 
		self.nCount = 8
		conType3:setAbsContentSize(GlobalMethod:CCSize(280,255))
		conType3:updateRelativeSize()
		GetElement(self.m_root,"Type3Message2_WndTips",WZUIContainer):setVisible(true)
	end
	for i = 1, self.nCount do
		local conItem = GetElement(self.m_root,"conItem"..i,WZUIContainer)
		if tData.icon[i] ~= nil then
			local celElement, tNewObj = CellGoodItem:createElement()
			if celElement and tNewObj then
				celElement:setScale(0.4)
				tNewObj:setCellGoodLocalId(tData.id[i], tData.num[i], 17)
				tNewObj:setItemClickFun(self, self.onEquipBackFun)
				tNewObj:setQualityFrameVisible(false)
				tNewObj:_setBgImgVisible(false)
				tNewObj:_setItemVisible(false)
				conItem:addChild(celElement)
			end

			-- GetElement(self.m_root,"img"..i.."_Type3_WndTips",WZUIImage):setFile(tData.icon[i])
			GetElement(self.m_root,"label"..i.."Type3_WndTips",WZUILabelTTF):setText(tData.num[i])
		else
			
			-- GetElement(self.m_root,"img"..i.."_Type3_WndTips",WZUIImage):setVisible(false)
			GetElement(self.m_root,"label"..i.."Type3_WndTips",WZUILabelTTF):setVisible(false)
		end
	end
	local conTop1 = GetElement(conType3,"conTop1_WndTip3",WZUIContainer)
	local conTop2 = GetElement(conType3,"conTop2_WndTip3",WZUIContainer)
	if self.m_tData.singleCopy ~= nil and self.m_tData.singleCopy == false  then
		conTop1:setVisible(false)
		conTop2:setVisible(true)
		local txtTipTip = GetElement(conTop2,"txtTipTip_WndTips3",WZUILabelTTF)
		txtTipTip:setText(self.m_tData.desc)
		if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
			txtTipTip:setScale(0.8)
			txtTipTip:setDimensions(GlobalMethod:CCSize(360))
		end
	elseif self.m_tData.nType ~= nil and self.m_tData.nType == 3 then
		GetElement(conType3,"img5Type3_WndTips",WZUIImage):setVisible(false)
		GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
	elseif self.m_tData.nType ~= nil and self.m_tData.nType == 4 then
		GetElement(conType3,"img5Type3_WndTips",WZUIImage):setVisible(false)
		GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum .. "%" .."/".. tData.endNum .. "%")
		GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		if tData.strartNum >= tData.endNum then
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setLabelStyleKey("C6_F20")
		else
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setLabelStyleKey("C16_F20")
		end

		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.TEAMBOSS_TEXT23)
		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.06,0.7))

		local ftxtOtherInfo = GetElement(self.m_root, "ftxtOtherInfo_WndTips3", WZUIFreeTextBox)
		local sFotmat = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="255,89,74" S="18" P="1">%d/%d</T>]]
		if self.m_tData.curNum >= self.m_tData.targetNum then 
		    sFotmat = [[<T C="127,70,26" S="18" P="1">%s:</T><T C="5,180,0" S="18" P="1">%d/%d</T>]]
		end
		ftxtOtherInfo:setShowText(string.format(sFotmat, LocalStrings.TEAMBOSS_TEXT8, self.m_tData.curNum, self.m_tData.targetNum))
		ftxtOtherInfo:setVisible(true)
		ftxtOtherInfo:setRelativePosition(GlobalMethod:ccp(0.06,0.25))
		if ProjConfig.LANGUAGE == "vn" then
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.7))
		elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.72,0.7))
		end
	elseif self.m_tData.nType ~= nil and self.m_tData.nType == 5 then
		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
		GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
		local basicInfo = GDatatab_item["id_" .. self.m_tData.coinId]
		GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setFile(basicInfo.icon)
		GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setScale(0.5)
	elseif self.m_tData.nType ~= nil and self.m_tData.nType == 6 then
		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
		GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
		GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
	else
		GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
		if tData.strartNum and tData.endNum then
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
		end
		if tData.txtTitle then
			GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(tData.txtTitle)
			GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
		end
		if tData.charm == true then
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO138)
			GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
			if ProjConfig.LANGUAGE == "en" then
				local ttf2Type3 = GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF)
				ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
			end
			
			if ProjConfig.LANGUAGE == "tr" then
				GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.84))
			end
			
		elseif self.m_tData.nType ~= nil and self.m_tData.nType == 5 then
			GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
			local basicInfo = GDatatab_item["id_" .. self.m_tData.coinId]
			GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setFile(basicInfo.icon)
			GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setScale(0.5)
		else
			local ttf2Type3 = GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF)
			ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
			if tData.txtTitle then
				ttf2Type3:setText(tData.txtTitle)
				GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
			else
				ttf2Type3:setText(LocalStrings.CHAT_CURRENT)
				if tData.strartNum and tData.endNum then
					GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
				end
				if tData.charm == true then
					GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setVisible(false)
					ttf2Type3:setText(LocalStrings.COMMUNITYINFO138)
					GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
					if ProjConfig.LANGUAGE == "en" then
						ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
					end
					if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "ug" then
						ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
					end
				else
					if ProjConfig.LANGUAGE == "en" then
						GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
					elseif ProjConfig.LANGUAGE == "es" then
						local ttf1 = GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF)
						ttf1:setFontSize(18)
						ttf1:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
						ttf2Type3:setFontSize(16)
						ttf2Type3:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
					end
				end
			end
		end
	end
end

--@brief	更新类型4	tips
function WndTips:_update4()
	WZLog("WndTips:_update4")
	if self.m_tData == nil then return end
	if self.m_tData.winType == nil or self.m_tData.winType == 1 then 
		local playerInfo = self.m_tData
		local displayLv = playerInfo.tournamentLevel%10
		if displayLv == 0 then displayLv = 10 end
    	local hallInfo = GDatatab_integral["id_"..playerInfo.tournamentLevel]
		GetElement(self.m_root,"conType4_WndTips",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"lvType4_WndTips",WZUILabelAtlasFont):setText(displayLv)
		--GetElement(self.m_root,"lvType4_WndTips",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.165,0.8))
		GetElement(self.m_root,"imgHeadType4_WndTips",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
		--段位
		GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF):setText(hallInfo.dan)
		--积分
		local integral = playerInfo.tournamentIntegral
		if integral == nil then integral = 0 end
		for i=1,playerInfo.tournamentLevel-1 do
			integral = integral + GDatatab_integral["id_"..i].upgrade_integral
		end
		GetElement(self.m_root,"ttf6Type4_WndTips",WZUILabelTTF):setText(LocalStrings.INTEGRATION..":"..integral)
		--胜率
		local winRate = playerInfo.playNum == 0 and 0 or math.ceil((string.format("%.2f", playerInfo.winNum/playerInfo.playNum))*100)
		local nFighting = WndCard:_caculateFighting(hallInfo.add_property)
		local txtFighting = GetElement(self.m_root, "txtFighting_WndTips4", WZUILabelTTF)
		if txtFighting then 
			txtFighting:setVisible(true)
			txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
		end
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
			local txtFightingT = GetElement(self.m_root,"label0Type4_WndTips",WZUILabelTTF)
			txtFightingT:setScale(0.7)
			txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.39))
		end
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,
			playerInfo.playNum,playerInfo.winNum))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setText(winRate.."%")
		GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[1][1]])
		GetElement(self.m_root,"label2Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[1][2])
		GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[2][1]])
		GetElement(self.m_root,"label4Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[2][2])
		GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[3][1]])
		GetElement(self.m_root,"label6Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[3][2])
	elseif self.m_tData.winType == 2 then 
		local playerInfo = self.m_tData
		local fightInfo = playerInfo
		local displayLv = fightInfo.level
    	local hallInfo = GDatatab_entertainment_level["id_"..displayLv]
		GetElement(self.m_root,"conType4_WndTips",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"lvType4_WndTips",WZUILabelAtlasFont):setText(displayLv)

		GetElement(self.m_root,"imgHeadType4_WndTips",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
		--段位
		GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF):setText(hallInfo.dan)
		--积分
		local integral = fightInfo.exp
		if integral == nil then integral = 0 end
		for i=1, displayLv-1 do
			integral = integral + GDatatab_entertainment_level["id_"..i].upgrade_integral
		end
		GetElement(self.m_root,"ttf6Type4_WndTips",WZUILabelTTF):setText(LocalStrings.INTEGRATION..":"..integral)
		--胜率
		local winRate = fightInfo.joinTimes == 0 and 0 or math.ceil((string.format("%.2f", fightInfo.winTimes/fightInfo.joinTimes))*100)
		local nFighting = WndCard:_caculateFighting(hallInfo.add_property)
		local txtFighting = GetElement(self.m_root, "txtFighting_WndTips4", WZUILabelTTF)
		if txtFighting then 
			txtFighting:setVisible(true)
			txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
		end
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,
			fightInfo.joinTimes,fightInfo.winTimes))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setText(winRate.."%")
		GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[1][1]])
		GetElement(self.m_root,"label2Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[1][2])
		GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[2][1]])
		GetElement(self.m_root,"label4Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[2][2])
		GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[3][1]])
		GetElement(self.m_root,"label6Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[3][2])
	end
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language then
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		ttf2Type4:setScale(0.68)
		ttf2Type4:setRelativePosition(ccp(0.33,0.64))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setRelativePosition(ccp(0.39,0.55))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF):setScale(0.8)
	end
	if "th" == language then
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setRelativePosition(ccp(0.4,0.64))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setRelativePosition(ccp(0.4,0.55))
	end
	if "vn" == language then
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setRelativePosition(ccp(0.384351,0.64))
		GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setRelativePosition(ccp(0.30,0.55))
		GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF):setFontSize(18)
		GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF):setFontSize(18)
		GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF):setFontSize(18)
		for i=0, 6 do
			GetElement(self.m_root,"label"..i.."Type4_WndTips",WZUILabelTTF):setScale(0.8)
		end
		GetElement(self.m_root,"label0Type4_WndTips",WZUILabelTTF):setScale(0.7)
	end
	if "pt" == language then
		GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.101963,0.64))
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		ttf2Type4:setScale(0.8)
		ttf2Type4:setRelativePosition(ccp(0.406116,0.64))
		ttf2Type4:setDimensions(GlobalMethod:CCSize(180,0))

		GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.10313,0.55))
		local ttf5 = GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF)
		ttf5:setRelativePosition(GlobalMethod:ccp(0.623073,0.55))

		local ttf6 = GetElement(self.m_root,"ttf6Type4_WndTips",WZUILabelTTF)
		ttf6:setRelativePosition(GlobalMethod:ccp(0.33,0.805))
		GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.88))
	end
	if "tr" == language then
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		ttf2Type4:setScale(0.8)
		ttf2Type4:setRelativePosition(GlobalMethod:ccp(0.292748,0.64))
		local ttf5Type4 = GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF)
		ttf5Type4:setRelativePosition(GlobalMethod:ccp(0.6,0.55))
		ttf5Type4:setScale(0.8)
		GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF):setScale(0.8)
	end

	if ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.101963,0.64))
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		ttf2Type4:setScale(0.8)
		ttf2Type4:setRelativePosition(ccp(0.406116,0.64))
		ttf2Type4:setDimensions(GlobalMethod:CCSize(140,0))

		GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.10313,0.55))
		local ttf5 = GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF)
		ttf5:setRelativePosition(GlobalMethod:ccp(0.65,0.55))

		local ttf6 = GetElement(self.m_root,"ttf6Type4_WndTips",WZUILabelTTF)
		ttf6:setRelativePosition(GlobalMethod:ccp(0.33,0.805))
		GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.88))
	end
	if ProjConfig.LANGUAGE == "ug" then
		local ttf1Type4 = GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF)
		ttf1Type4:setScale(0.8)
		local ttf6Type4 = GetElement(self.m_root,"ttf6Type4_WndTips",WZUILabelTTF)
		ttf6Type4:setScale(0.8)

		local ttf3Type4 = GetElement(self.m_root,"ttf3Type4_WndTips",WZUILabelTTF)
		ttf3Type4:setScale(0.8)
		ttf3Type4:setRelativePosition(GlobalMethod:ccp(0.545114,0.64))
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		ttf2Type4:setScale(0.7)
		ttf2Type4:setRelativePosition(ccp(0.533206,0.64))
		ttf2Type4:setDimensions(GlobalMethod:CCSize(180,0))
		ttf2Type4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        ttf2Type4:setAlignment(kCCTextAlignmentRight)
		local ttf4Type4 = GetElement(self.m_root,"ttf4Type4_WndTips",WZUILabelTTF)
		ttf4Type4:setScale(0.8)
		ttf4Type4:setRelativePosition(GlobalMethod:ccp(0.293205,0.55))
		local ttf5Type4 = GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF)
		ttf5Type4:setScale(0.7)
		ttf5Type4:setRelativePosition(ccp(0.285114,0.55))
		ttf5Type4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        ttf5Type4:setAlignment(kCCTextAlignmentRight)
	
		local label1Type4 = GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF)
		label1Type4:setRelativePosition(GlobalMethod:ccp(0.77,0.29))
		local label3Type4 = GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF)
		label3Type4:setRelativePosition(GlobalMethod:ccp(0.77,0.2))
		local label5Type4 = GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF)
		label5Type4:setRelativePosition(GlobalMethod:ccp(0.77,0.11))
		local label2Type4 = GetElement(self.m_root,"label2Type4_WndTips",WZUILabelTTF)
		label2Type4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		label2Type4:setAlignment(kCCTextAlignmentRight)
		local label4Type4 = GetElement(self.m_root,"label4Type4_WndTips",WZUILabelTTF)
		label4Type4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		label4Type4:setAlignment(kCCTextAlignmentRight)
		local label6Type4 = GetElement(self.m_root,"label6Type4_WndTips",WZUILabelTTF)
		label6Type4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		label6Type4:setAlignment(kCCTextAlignmentRight)

	end
end

--@brief	更新类型5	tips
function WndTips:_update5()
	WZLog("WndTips:_update5")
	local tData = self.m_tData
	local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
	conType5:setVisible(true)
	if tData.tipsType and tData.tipsType == 1 then 
		GetElement(self.m_root,"bgType5_WndTips",WZUI9Image):setVisible(false)
		local configData = GDatatab_footmark_city["id_" .. tData.id]
		local bgType5 = GetElement(self.m_root, "imgFootBeatBk_WndTips5", WZUIImage)
		bgType5:setFile("ui/footmark/" .. configData.picture .. "_1.png")
		conType5:setAbsContentSize(GlobalMethod:CCSize(183,244))
		conType5:updateRelativeSize()
		local doDate = os.date("*t", tData.time)
		local showText2 = [[<T C="255,236,193" S="10" P="1" SC="132,66,29" SS="4" SE="1">%02d%s%02d%s</T><T C="255,236,193" S="10" P="1" SC="132,66,29" SS="4" SE="1">%s</T><I Z="0.4" P="1">ui/common/common_gx.png</I>]]
		local txt3Type5 = GetElement(self.m_root,"txt3Type5_WndTips",WZUIFreeTextBox)
		txt3Type5:setRelativePosition(GlobalMethod:ccp(0.5,0.08))
		txt3Type5:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		txt3Type5:setShowText(string.format(showText2, doDate.month, LocalStrings.SPACE31, doDate.day, LocalStrings.SPACE32, LocalStrings.FOOTMARK_TEXT29))
	else
		local text = string.format(LocalStrings.PET_4,math.floor(tData.value)/1,"%")
		local text1 = string.format(LocalStrings.PET_5,math.floor(tData.value)/1,"%")
		
		local showText = [[<T C="255,227,112" S="20" >%s:  </T><T C="127,70,26" S="20" >%d</T><BR></BR>
		<T C="255,227,112" S="20" >%s:  </T><T C="127,70,26" S="20" >%s</T><BR></BR>
		<T C="255,227,112" S="20" >%s:  </T><T C="127,70,26" S="20" >%s</T>]]
		GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(showText,LocalStrings.PET_1,tData.value,
		LocalStrings.PET_2,text,LocalStrings.PET_3,text1))
		--语言适配
		local language = ProjConfig.LANGUAGE
		if "en" == language or "pt" == language or "tr" == language then
			GetElement(self.m_root,"bgType5_WndTips",WZUI9Image):setScaleY(1.25)
			local txt1Type5 = GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox)
			txt1Type5:setScale(0.8)
			txt1Type5:setMaxWidth(300)
		end
		if "vn" == language then
			GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox):setMaxWidth(250)
		end
		if "th" == language then
			GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox):setMaxWidth(228)
		end
		if "cn" == language then
			GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox):setMaxWidth(230)
		end
	end
end

--@brief	更新类型6	tips
function WndTips:_update6()
	WZLog("WndTips:_update6")
	local tData = self.m_tData
	GetElement(self.m_root,"conType6_WndTips",WZUIContainer):setVisible(true)
	local text1 = [[<T C="127,70,26" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
	local txtTitle = GetElement(self.m_root, "txtTitle_WndTips6", WZUILabelTTF)
	local txtDesc = GetElement(self.m_root, "txtDesc_WndTips6", WZUILabelTTF)
	if txtTitle then 
		txtTitle:setText(LocalStrings.MOUNTS_PRE_ADD)
	end
	if txtDesc then 
		txtDesc:setText(LocalStrings.MOUNT_ALL_ADD)
	end

    GetElement(self.m_root,"txt1Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.HEALTH,tData.hp))
	GetElement(self.m_root,"txt2Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.ATTACK,tData.attack))
	GetElement(self.m_root,"txt3Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.DEFENSE,tData.defend))
	GetElement(self.m_root,"txt4Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.AGILITY,tData.critRate))
	GetElement(self.m_root,"txt5Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.LUCKY,tData.reduceCrit))
	
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"txtTitle_WndTips6",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.9)
		txtDesc:setDimensions(GlobalMethod:CCSize(255))
	elseif ProjConfig.LANGUAGE == "vn" then
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(290))
	elseif ProjConfig.LANGUAGE == "en" then
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(270))
	elseif ProjConfig.LANGUAGE == "es" then
		local txtType6 = GetElement(self.m_root,"txtTitle_WndTips6",WZUILabelTTF)
		txtType6:setScale(0.9)
		txtType6:setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(255))
	elseif ProjConfig.LANGUAGE == "ug" then
		local txtType6 = GetElement(self.m_root,"txtTitle_WndTips6",WZUILabelTTF)
		txtType6:setScale(0.7)
		txtType6:setDimensions(GlobalMethod:CCSize(360))
		txtType6:setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		GetElement(self.m_root,"txt1Type6_WndTips",WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root,"txt2Type6_WndTips",WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root,"txt3Type6_WndTips",WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root,"txt4Type6_WndTips",WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root,"txt5Type6_WndTips",WZUIFreeTextBox):setScale(0.7)
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.6)
		txtDesc:setDimensions(GlobalMethod:CCSize(380))
	end
	if ProjConfig.LANGUAGE == "vn" then
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(290))
	end 
	if ProjConfig.LANGUAGE == "en" then
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(270))
	end
	if ProjConfig.LANGUAGE == "es" then
		local txtType6 = GetElement(self.m_root,"txtTitle_WndTips6",WZUILabelTTF)
		txtType6:setScale(0.9)
		txtType6:setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		local txtDesc = GetElement(self.m_root,"txtDesc_WndTips6",WZUILabelTTF)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(255))
	end
end

--@brief	更新类型7	tips
function WndTips:_update7()
	WZLog("WndTips:_update7")
	local tData = self.m_tData
		local moralityLevel = CacheCenter:getMasterInfo().moralityLevel
		--设置说明
		local tData = GDatatab_morality["id_"..moralityLevel]
		GetElement(self.m_root,"conType4_WndTips",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"lvType4_WndTips",WZUILabelAtlasFont):setText(moralityLevel)
		--GetElement(self.m_root,"imgHeadType4_WndTips",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
		GetElement(self.m_root,"ttf1Type4_WndTips",WZUILabelTTF):setText(tData.title)
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setText("")
		GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.buff[1][1]])
		GetElement(self.m_root,"label2Type4_WndTips",WZUILabelTTF):setText("+"..tData.buff[1][2])
		GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.buff[2][1]])
		GetElement(self.m_root,"label4Type4_WndTips",WZUILabelTTF):setText("+"..tData.buff[2][2])
		GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.buff[3][1]])
		GetElement(self.m_root,"label6Type4_WndTips",WZUILabelTTF):setText("+"..tData.buff[3][2])
end

--@brief	更新类型8	tips
function WndTips:_update8()
	WZLog("WndTips:_update8")
	local tData = self.m_tData
	if tData.quality == nil then tData.quality = 1 end
	local qualityPic = {"ui/common/common_scale9_lv.png",
				"ui/common/common_scale9_lan.png",
				"ui/common/common_scale9_zi.png",
				"ui/common/common_scale9_cheng.png",
				"ui/common/common_scale9_lv.png"}
	GetElement(self.m_root,"conType8_WndTips",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"iconType8_WndTips",WZUIImage):setFile(tData.icon)
	--GetElement(self.m_root,"iconType8_WndTips",WZUIImage):setScale(0.6)
	GetElement(self.m_root,"title1Type8_WndTips",WZUILabelTTF):setText(tData.title1)
	--品质-1不显示品质框
	if tData.quality == -1 then
		GetElement(self.m_root,"bgType8_WndTips",WZUI9Image):setVisible(false)
	else
			GetElement(self.m_root,"title1Type8_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
		GetElement(self.m_root,"bgType8_WndTips",WZUI9Image):setFile(qualityPic[tData.quality])
	end
	--等级不为nil显示数字
	if tData.level ~= nil then
		GetElement(self.m_root,"numType8_WndTips",WZUILabelAtlasFont):setVisible(true)
		GetElement(self.m_root,"numType8_WndTips",WZUILabelAtlasFont):setText(tData.level)
		if tData.px ~= nil then
			GetElement(self.m_root,"numType8_WndTips",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(tData.px,0.7))
		end
		local px = GetElement(self.m_root,"numType8_WndTips",WZUILabelAtlasFont):getRelativePosition().x
		if tData.py ~= nil then
			GetElement(self.m_root,"numType8_WndTips",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(px,tData.py))
		end
	end
	local text = tData.text or [[<T C="127,70,26" S="22" P="0">%s</T><T C="127,70,26" S="22" P="0">    %d</T>]]
	if tData.title2 ~= nil then
		GetElement(self.m_root,"title2Type8_WndTips",WZUIFreeTextBox):setShowText(tData.title2)
	end
	if tData.attr1 ~= nil and tData.attrVal1 ~= nil then
		GetElement(self.m_root,"txt1Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tData.attr1,tData.attrVal1))
	end
	if tData.attr2 ~= nil and tData.attrVal2 ~= nil then
		GetElement(self.m_root,"txt2Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tData.attr2,tData.attrVal2))
	end
	if tData.attr3 ~= nil and tData.attrVal3 ~= nil then
		GetElement(self.m_root,"txt3Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tData.attr3,tData.attrVal3))
	end
	if tData.attr4 ~= nil and tData.attrVal4 ~= nil then
		GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tData.attr4,tData.attrVal4))
	end
	if tData.attr5 ~= nil and tData.attrVal5 ~= nil then
		GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tData.attr5,tData.attrVal5))
	end

	local language = ProjConfig.LANGUAGE	
end

--@brief	更新类型9	tips
function WndTips:_update9()
	WZLog("WndTips:_update9")
	local tData = self.m_tData
		GetElement(self.m_root,"conType7_WndTips",WZUIContainer):setVisible(true)
		--设置套装属性
		local suitId = tData.id
		local attr,attrNext,title1,title2,table,tableNext

		local text1 = [[<T C="127,70,26" S="20" >%s</T><T C="127,70,26" S="20" >    +%d</T>]]

		local text2 = [[<T C="158,139,121" S="20" >%s</T><T C="158,139,121" S="20" >    +%d</T>]]

		-- if ProjConfig.LANGUAGE == "vn" then
		-- 	text1 = [[<T C="127,70,26" S="16" >%s</T><T C="127,70,26" S="18" >    +%d</T>]]
		-- 	text2 = [[<T C="158,139,121" S="16" >%s</T><T C="158,139,121" S="18" >    +%d</T>]]
		-- end

		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" 
			or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
			text1 = [[<T C="127,70,26" S="16" >%s</T><T C="127,70,26" S="18" >    +%d</T>]]
			text2 = [[<T C="158,139,121" S="16" >%s</T><T C="158,139,121" S="18" >    +%d</T>]]
		end

		local typeWord = {LocalStrings.STRENGTEN,LocalStrings.IMPROVE,LocalStrings.GEMMOUNTING}
		if tonumber(suitId) == -1 then
			attr = GDatatab_suit["id_1"].property 
			table = GDatatab_suit["id_1"]
			title1 = string.format(LocalStrings.STRENGTHENTIP,typeWord[table.suit_type],table.target)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setText(title1)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
			GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setText("")
			GetElement(self.m_root,"txt1Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[1][1]],attr[1][2]))
			GetElement(self.m_root,"txt2Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[2][1]],attr[2][2]))
			GetElement(self.m_root,"txt3Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[3][1]],attr[3][2]))
		elseif tonumber(suitId) == -2 then
			attr = GDatatab_suit["id_9"].property 
			table = GDatatab_suit["id_9"]
			title1 = string.format(LocalStrings.STRENGTHENTIP,typeWord[table.suit_type],table.target)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setText(title1)
			GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setText("")
			GetElement(self.m_root,"txt1Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[1][1]],attr[1][2]))
			GetElement(self.m_root,"txt2Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[2][1]],attr[2][2]))
			GetElement(self.m_root,"txt3Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[3][1]],attr[3][2]))
		elseif tonumber(suitId) == -3 then
			attr = GDatatab_suit["id_14"].property 
			table = GDatatab_suit["id_14"]
			title1 = string.format(LocalStrings.STRENGTHENTIP,typeWord[table.suit_type],table.target)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setText(title1)
			GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setText("")
			GetElement(self.m_root,"txt1Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[1][1]],attr[1][2]))
			GetElement(self.m_root,"txt2Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[2][1]],attr[2][2]))
			GetElement(self.m_root,"txt3Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[3][1]],attr[3][2]))
		else 
			--tData.title1 = "全套装备%s+%d"..GDatatab_suit["id_"..id].target
			attr = GDatatab_suit["id_"..suitId].property
			table = GDatatab_suit["id_"..suitId]
			tableNext = GDatatab_suit["id_"..(tonumber(suitId)+1)]
			title1 = string.format(LocalStrings.STRENGTHENTIP,typeWord[table.suit_type],table.target)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setText(title1)
			GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(233,166,62))
			GetElement(self.m_root,"txt1Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,ATTR_TITLE[attr[1][1]],attr[1][2]))
			GetElement(self.m_root,"txt2Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,ATTR_TITLE[attr[2][1]],attr[2][2]))
			GetElement(self.m_root,"txt3Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,ATTR_TITLE[attr[3][1]],attr[3][2]))
			if tableNext ~= nil then
				attrNext = GDatatab_suit["id_"..(tonumber(suitId)+1)].property 
				title2 = string.format(LocalStrings.STRENGTHENTIP,typeWord[tableNext.suit_type],tableNext.target)
				GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setText(title2)
				GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(158,139,121))
				GetElement(self.m_root,"txt4Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attrNext[1][1]],attrNext[1][2]))
				GetElement(self.m_root,"txt5Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attrNext[2][1]],attrNext[2][2]))
				GetElement(self.m_root,"txt6Type7_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attrNext[3][1]],attrNext[3][2]))
				
				--和下一套套装属性类型不同时隐藏下一套属性
				if table.suit_type ~= tableNext.suit_type then
					GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setVisible(false)
					GetElement(self.m_root,"txt4Type7_WndTips",WZUIFreeTextBox):setVisible(false)
					GetElement(self.m_root,"txt5Type7_WndTips",WZUIFreeTextBox):setVisible(false)
					GetElement(self.m_root,"txt6Type7_WndTips",WZUIFreeTextBox):setVisible(false)
				else
					GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setVisible(true)
					GetElement(self.m_root,"txt4Type7_WndTips",WZUIFreeTextBox):setVisible(true)
					GetElement(self.m_root,"txt5Type7_WndTips",WZUIFreeTextBox):setVisible(true)
					GetElement(self.m_root,"txt6Type7_WndTips",WZUIFreeTextBox):setVisible(true)
				end
			else
				GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setVisible(false)
				GetElement(self.m_root,"txt4Type7_WndTips",WZUIFreeTextBox):setVisible(false)
				GetElement(self.m_root,"txt5Type7_WndTips",WZUIFreeTextBox):setVisible(false)
				GetElement(self.m_root,"txt6Type7_WndTips",WZUIFreeTextBox):setVisible(false)
			end
		end

	local language = ProjConfig.LANGUAGE
	if "en" == language then
		GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setFontSize(18)
		local title2 = GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF)
		title2:setFontSize(18)
		title2:setDimensions(GlobalMethod:CCSize(180,0))
	end

	if "th" == language then
		GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setFontSize(18)
	end

	if "vn" == language then
		GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setFontSize(18)
		GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setFontSize(18)
	end

	if "pt" == language or "tr" == language then
		GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setFontSize(16)
		local title = GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF)
		title:setFontSize(16)
		title:setDimensions(GlobalMethod:CCSize(180,0))
	elseif "es" == language then
		GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(184))
	elseif "ug" == ProjConfig.LANGUAGE then
		local title1Type7 = GetElement(self.m_root,"title1Type7_WndTips",WZUILabelTTF)
		title1Type7:setScale(0.8)
		title1Type7:setDimensions(GlobalMethod:CCSize(220))
		local title2Type7 = GetElement(self.m_root,"title2Type7_WndTips",WZUILabelTTF)
		title2Type7:setScale(0.8)
		title2Type7:setDimensions(GlobalMethod:CCSize(220))
		GetElement(self.m_root,"txt1Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
		GetElement(self.m_root,"txt2Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
		GetElement(self.m_root,"txt3Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
		GetElement(self.m_root,"txt4Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
		GetElement(self.m_root,"txt5Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
		GetElement(self.m_root,"txt6Type7_WndTips",WZUIFreeTextBox):setScale(0.8)
	end
end

--@brief	更新类型10	tips
function WndTips:_update10()
	WZLog("WndTips:_update10")
	local tData = self.m_tData
	GetElement(self.m_root,"conType9_WndTips",WZUIContainer):setVisible(true)
	local widthList = {80,160,240,320,400,480}
	local relativePosition = {-0.377,-0.305,-0.23,-0.15,-0.075,0}
    for i=1,#tData.ids do
        local key = "id_"..tData.ids[i]
		GetElement(self.m_root,"bgType9_WndTips",WZUI9Image):setContentSize(GlobalMethod:CCSize(widthList[i],100))
		GetElement(self.m_root,"bgType9_WndTips",WZUI9Image):setRelativePosition(GlobalMethod:ccp(relativePosition[i],0.5))
        if GDatatab_item[key] ~= nil then
            local name = GDatatab_item[key].name
            local path = GDatatab_item[key].icon
            local num =  tData.nums[i]
            local quality = GDatatab_item[key].quality
            local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
	   		local celElement,tLuaObj = CellGoodItem:createElement()
       		if celElement ~= nil then 
	   		 	celElement = WZUIContainer:luaTo(celElement)
       		    tLuaObj:setCellGoodItem(itemInfo,  4)
       		    tLuaObj:setItemClickFun(WndTips,self.onRewardItemClick)
				celElement:setScale(0.85)
				local con = GetElement(self.m_root,"con"..i.."Type9_WndTips",WZUIContainer)
				con:removeAllChildrenWithCleanup(true)
				con:addChild(celElement)
       		end
        end
    end
end

--@brief	更新类型11	tips
function WndTips:_update11()
	WZLog("WndTips:_update11")
	local tData = self.m_tData
		GetElement(self.m_root,"conType10_WndTips",WZUIContainer):setVisible(true)
		--设置套装属性
		local suitId = tData.id
		local suitNum = tData.suitNum
		local attr,attrNext,title1,title2,table,tableNext
		local text1 = [[<T C="127,70,26" S="20" >%s</T><T C="127,70,26" S="20" >    +%d</T>]]
		local text2 = [[<T C="158,139,121" S="20" >%s</T><T C="158,139,121" S="20" >    +%d</T>]]
		local title1 = [[<T C="233,166,62" S="22" >%s</T><T C="233,166,62" S="22" >%s</T>]]
		if tonumber(suitId) == 0 or suitId == nil then
			GetElement(self.m_root,"title1Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(title1,LocalStrings.STRENGTHENTIP1,""))
			return
		end
		attr = GDatatab_item_suit["id_"..suitId].six 
		GetElement(self.m_root,"title1Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(title1,GDatatab_item_suit["id_"..suitId].name,"("..suitNum.."/6)"))
		GetElement(self.m_root,"txt1Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[1][1]],attr[1][2]))
		GetElement(self.m_root,"txt2Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[2][1]],attr[2][2]))
		GetElement(self.m_root,"txt3Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[3][1]],attr[3][2]))
		GetElement(self.m_root,"txt4Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[4][1]],attr[4][2]))
		GetElement(self.m_root,"txt5Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,ATTR_TITLE[attr[5][1]],attr[5][2]))
		if tonumber(suitNum) >= 4 and tonumber(suitNum) < 6 then
			for i=1,3 do
				GetElement(self.m_root,"txt"..i.."Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,ATTR_TITLE[attr[i][1]],attr[i][2]))
			end
		end 
		if tonumber(suitNum) == 6 then
			for i=1,5 do
				GetElement(self.m_root,"txt"..i.."Type10_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,ATTR_TITLE[attr[i][1]],attr[i][2]))
			end
		end 
end

--@brief	更新类型12	tips
function WndTips:_update12()
	WZLog("WndTips:_update12")
	local tData = self.m_tData
		GetElement(self.m_root,"conType11_WndTips",WZUIContainer):setVisible(true)
		local text1 = string.format(LocalStrings.PET_MSG1,tData.level)
		local text2 = tData.desc
		local icon = tData.icon
		GetElement(self.m_root,"txt1Type11_WndTips",WZUILabelTTF):setText(text1)
		GetElement(self.m_root,"txt2Type11_WndTips",WZUILabelTTF):setText(text2)
		GetElement(self.m_root,"imgType11_WndTips",WZUIImage):setFile(icon)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" or 
		ProjConfig.LANGUAGE == "es" then
		local txt = GetElement(self.m_root,"txt1Type11_WndTips",WZUILabelTTF)
		txt:setRelativePosition(GlobalMethod:ccp(0.03,0.76))
		txt:setDimensions(GlobalMethod:CCSize(160,0))
		txt:setFontSize(18)
		GetElement(self.m_root,"txt2Type11_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.04,0.34))
	elseif ProjConfig.LANGUAGE == "pt" then
		local txt1 = GetElement(self.m_root,"txt1Type11_WndTips",WZUILabelTTF)
		txt1:setRelativePosition(GlobalMethod:ccp(0.03,0.76))
		txt1:setDimensions(GlobalMethod:CCSize(160,0))
		txt1:setFontSize(16)
		local txt2 = GetElement(self.m_root,"txt2Type11_WndTips",WZUILabelTTF)
		txt2:setFontSize(16)
	end
end

--@brief	更新类型13	tips
function WndTips:_update13()
	WZLog("WndTips:_update13",Serialize(self.m_tData))
	local tData = self.m_tData
	GetElement(self.m_root,"conType23_WndTips",WZUIContainer):setVisible(true)
	local quality = tData.quality or 0
	local fighting = tData.fighting or 0
	local qualityPic = {"ui/common/common_scale9_lv.png",
				"ui/common/common_scale9_lan.png",
				"ui/common/common_scale9_zi.png",
				"ui/common/common_scale9_cheng.png",
				"ui/common/common_scale9_lv.png"}
	--显示头像
	GetElement(self.m_root,"img2Type23_WndTips",WZUIImage):setFile(tData.icon)
	--显示头像品质框
	GetElement(self.m_root,"img1Type23_WndTips",WZUI9Image):setFile(qualityPic[tonumber(quality)])
	--宠物类型图标
	GetElement(self.m_root,"img3Type23_WndTips",WZUIImage):setFile(WndPets:getTypeById(tData.itemId))
	--设置等级和等级颜色
	GetElement(self.m_root,"title1Type23_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.upgradeLevel)
   	GetElement(self.m_root,"title1Type23_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
	--设置名字和名字颜色
	if tData.advancedLevel ~= "0" and tData.advancedLevel ~= 0 then
		local petName = GDatatab_item["id_"..tData.itemId].name
		for k,v in pairs(GDatatab_pet_advanced) do
			if v.item_id == tData.itemId and v.level == tData.advancedLevel then
				petName = v.evo_name 
			end
		end
		GetElement(self.m_root,"title2Type23_WndTips",WZUILabelTTF):setText(petName.."  +"..tData.advancedLevel)
	else
		GetElement(self.m_root,"title2Type23_WndTips",WZUILabelTTF):setText(GDatatab_item["id_"..tData.itemId].name)
	end
   	GetElement(self.m_root,"title2Type23_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
	--设置战斗力
   	GetElement(self.m_root,"title3Type23_WndTips",WZUILabelTTF):setText(LocalStrings.BATTLE..":"..fighting)
   	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or 
   		ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
   		GetElement(self.m_root,"title2Type23_WndTips",WZUILabelTTF):setScale(0.7)
   		GetElement(self.m_root,"title3Type23_WndTips",WZUILabelTTF):setScale(0.7)
   	end
   	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or 
   		ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
   		GetElement(self.m_root,"title3Type23_WndTips",WZUILabelTTF):setScale(0.7)
   	end
   	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or 
   		ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
   		GetElement(self.m_root,"title3Type23_WndTips",WZUILabelTTF):setScale(0.7)
   	end
	local conItem = GetElement(self.m_root,"conType23_WndTips",WZUIContainer)
	--显示星星
	local starNum = 0
  	local tab = GDatatab_petStar
	if tData.gift ~= nil then
		starNum = WndPets:getAptitude(tData.gift)
	end
	--for i=1,(tonumber(quality) + 1) do
	for i=1,starNum do
    	local imgStar = WZUIImage:create()
    	imgStar:setFile("ui/common/common_icon_xingxing2.png")
    	imgStar:setRelativePosition(GlobalMethod:ccp(0.02+0.075*i,0.77))
		imgStar:setRotation(10)
    	imgStar:setScale(0.9)
		imgStar:setUseOriginSize(true)
    	conItem:addChild(imgStar)
	end
	--显示属性
	local text = [[<T C="127,70,26" S="20" >%s:</T><T C="127,70,26" S="20" >  %d</T>]]
	local attrNum = 1
	for i=1,20 do
		if tData[tostring(i)] ~= nil and tData[tostring(i)] ~= 0 and attrNum <= 3 then
			GetElement(self.m_root,"txt"..attrNum.."Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text,ATTR_TITLE[i],tData[tostring(i)]))
			attrNum = attrNum + 1
		end
	end
	--显示资质
	local minGift,maxGift
  	for k,v in pairs(GDatatab_pet) do

    	if v.item_id == tData.itemId then
       	 	minGift = v.gift[1][1]
        	maxGift = v.gift[1][2]
        	break
    	end
  	end
	local text1 = [[<T C="127,70,26" S="20" >%s:</T><T C="127,70,26" S="20" > %s</T><T C="127,70,26" S="20" >(%d-%d)</T>]]
	GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setMaxWidth(350)
	if tData.gift ~= nil then
		GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.PET_1,tostring(math.ceil(tonumber(tData.gift)/100)),minGift,maxGift))
	else
		GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.PET_1,"",minGift,maxGift))
	end
	--显示宠物技能
	--tData.skill = "1|7|12|25"
	--tData.skill = "1|7"
	if tData.skill ~= nil and tData.skill ~= "" then
		GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScale(1)
		GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setScaleX(1.9)
		GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setRelativePosition(ccp(0.5,0.62))
		GetElement(WndTips.m_root,"line2Type23_WndTips",WZUIImage):setVisible(true)

		local skills = SplitStringWithSeparator(tData.skill,"|")
		if skills == nil or type(skills) == "number" then return end
		local index = 7
		local skillsPositionY = 0.28
		for k,v in pairs(skills) do 
			--local skill_id = GDatatab_pet_skill_new["id_"..v].skill_id
			local skill_id = tonumber(v)
			WZLog("宠物技能id",v)
			local tSkill = GDatatab_skill["id_"..skill_id]
			local text = [[<I Z="0.4">%s</I><T C="127,70,26" S="18" P="0"> %s</T>]]
			GetElement(self.m_root,"txt"..index.."Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text,tSkill.icon,tSkill.tool_desc))
			GetElement(WndTips.m_root,"img"..index.."Type23_WndTips",WZUIImage):setFile(tSkill.lv_icon)
			
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or 
				ProjConfig.LANGUAGE == "es" then
				local txt = GetElement(self.m_root,"txt"..index.."Type23_WndTips",WZUIFreeTextBox)
				txt:setScale(0.6)
				txt:setMaxWidth(800)
				--txt:setRelativePosition(GlobalMethod:ccp(0.08,skillsPositionY))
			end

			if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" then
				local txt = GetElement(self.m_root,"txt"..index.."Type23_WndTips",WZUIFreeTextBox)
				txt:setScale(0.6)
				txt:setMaxWidth(800)
			end

			if ProjConfig.LANGUAGE == "vn" then
				local txt = GetElement(self.m_root,"txt"..index.."Type23_WndTips",WZUIFreeTextBox)
				txt:setScale(0.6)
				txt:setMaxWidth(800)
				txt:setRelativePosition(GlobalMethod:ccp(0.08,skillsPositionY))
			end
			skillsPositionY = skillsPositionY - 0.07
			index = index + 1
		end
	else
		-- GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleX(0.71)
		GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleY(0.69)
		-- GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setScaleX(1.25)
		-- GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setRelativePosition(ccp(0.35,0.62))
		GetElement(WndTips.m_root,"line2Type23_WndTips",WZUIImage):setVisible(false)
	end

	if tData.tBtnList then
		if tData.skill ~= nil and tData.skill ~= "" then
			--进阶过的宠物不用处理
		else
			GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleY(0.9)
			-- GetElement(WndTips.m_root,"line3Type23_WndTips",WZUIImage):setScaleX(1.25)
			-- GetElement(WndTips.m_root,"line3Type23_WndTips",WZUIImage):setRelativePosition(ccp(0.35,0.328))
			GetElement(self.m_root, "btnExtraction_WndTips", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.35, 0.21))
		end
		GetElement(WndTips.m_root, "txtExtractionType24_WndTips", WZUILabelTTF):setText(tData.tBtnList[1])
		GetElement(WndTips.m_root, "conForBtnType23_WndTips", WZUIContainer):setVisible(true)
	end

	--宠物装备
	if tData.tEquip and #tData.tEquip > 0 then 
		local tSubTypeToTag = {[0]=1,2,3,4,5,6}
		for i=1,6 do
			local conEquip = GetElement(WndTips.m_root, "conEquip"..i.."Type23_WndTips", WZUIContainer)
			if conEquip:getChildByTag(80) then
				conEquip:removeChildByTag(80)
			end
		end
		for i=1,6 do
			if tData.tEquip and tData.tEquip[i] then
				local tempPetEquip = {}
				tempPetEquip.extraInfo = json.decode(tData.tEquip[i])
				tempPetEquip.extraInfo.randAttr = json.decode(tempPetEquip.extraInfo.randAttr)
				tempPetEquip.id = tempPetEquip.extraInfo.itemId
				tempPetEquip.basicInfo = GDatatab_item["id_"..tempPetEquip.id]
				if tempPetEquip.basicInfo then
					local conEquip = GetElement(WndTips.m_root, "conEquip"..tSubTypeToTag[tempPetEquip.basicInfo.sub_type].."Type23_WndTips", WZUIContainer)
		            local cellElement,tLuaObj = CellGoodItem:createElement()
		            tLuaObj:setCellGoodItem(tempPetEquip,1)
		            tLuaObj:setItemClickFun(WndTips,self.onEquipBackFun)
		            cellElement:setTag(80)
		            cellElement:setScale(0.75)
		            conEquip:addChild(cellElement)
				end
			end
		end
	else
		GetElement(self.m_root, "conEquipList_WndTips", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSkill_WndTips", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.55))
		GetElement(self.m_root, "conForBtnType23_WndTips", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
	end
	if ProjConfig.LANGUAGE == "ug" then
		local txtExtractionType24 = GetElement(WndTips.m_root, "txtExtractionType24_WndTips", WZUILabelTTF)
		txtExtractionType24:setScale(0.7)
		txtExtractionType24:setDimensions(GlobalMethod:CCSize(150))
		txtExtractionType24:setAlignment(kCCTextAlignmentCenter)
	end

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setScale(0.8)
	end
end

--@brief	点击宠物装备回调
function WndTips:onEquipBackFun(tCell,tag,tData)
    if tData == nil then
		return
    end
    WZLog("点击物品弹出对应的tips")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,WndTips.m_root,1,tData,false,nil,true)
end

--@brief	更新类型14	tips
function WndTips:_update14()
	WZLog("WndTips:_update14")
	local tData = self.m_tData
		GetElement(self.m_root,"conType12_WndTips",WZUIContainer):setVisible(true)
		local quality = tData.quality or 0
		local fighting = tData.fighting or 0
		local qualityPic = g_tQualityRect
		--显示头像
		GetElement(self.m_root,"img2Type12_WndTips",WZUIImage):setFile(tData.icon)
		--显示头像品质框
		GetElement(self.m_root,"img1Type12_WndTips",WZUI9Image):setFile(qualityPic[tonumber(quality)])
		--不显示宠物类型图标
		GetElement(self.m_root,"img3Type12_WndTips",WZUIImage):setVisible(false)
		if tData.upgradeLevel == 0 then
			GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setVisible(false)
		else 
			--设置等级和等级颜色
			GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.upgradeLevel)
			GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.41,0.87))
	   		GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
	   	end
		--设置名字和名字颜色
		GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF):setText(tData.name)
   		GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
		--设置战斗力
   		GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF):setText(LocalStrings.BATTLE..":"..fighting)
   		GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,89,74))
		local conItem = GetElement(self.m_root,"conType12_WndTips",WZUIContainer)
		--显示星星
		for i=1,tonumber(tData.advancedLevel) do
			local imgStarPath = "ui/common/common_icon_xingxing2.png"
			local ptIndex = i
			if i >= 11 and i <= 20 then
				imgStarPath = "ui/common/common_icon_xingxing2_h.png"
				ptIndex = ptIndex - 10
			end
        	local imgStar = WZUIImage:create()
        	imgStar:setFile(imgStarPath)
        	imgStar:setRelativePosition(GlobalMethod:ccp(0.01+0.09*ptIndex,0.51))
        	imgStar:setScale(0.5)
			imgStar:setUseOriginSize(true)
        	conItem:addChild(imgStar)
		end
		--没有星星就把下面的属性上移
		if tData.advancedLevel < 1 then
			GetElement(self.m_root,"conBtm_WndTips",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.6))
		else
			GetElement(self.m_root,"conBtm_WndTips",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		end
		--显示属性
		local text = [[<T C="127,70,26" S="20" >%s:</T><T C="127,70,26" S="20" >  %d</T>]]
		local attrNum = 1
		--for i=1,20 do
		--	if tData[tostring(i)] ~= nil and tData[tostring(i)] ~= 0 and attrNum <= 5 then
		--		GetElement(self.m_root,"txt"..attrNum.."Type12_WndTips",WZUIFreeTextBox):setShowText(string.format(text,ATTR_TITLE[i],tData[tostring(i)]))
		--		attrNum = attrNum + 1
		--	end
		--end
		for i=1,5 do
			local tempT = GetElement(self.m_root,"txt"..i.."Type12_WndTips",WZUIFreeTextBox)
			tempT:setShowText(string.format(text,tData["attr"..i],tData["attrVal"..i]))
			tempT:setScale(0.8)
		end

		if 	ProjConfig.LANGUAGE == "tr" then
			-- if tData.advancedLevel >= 1 then
			GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF):setFontSize(16)
			-- end
			GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF):setFontSize(16)
		elseif ProjConfig.LANGUAGE == "vn" then
			local title2Type12 = GetElement(self.m_root,"title2Type12_WndTips",WZUI9Label)
			title2Type12:setFontSize(16)
			title2Type12:setDimensions(GlobalMethod:CCSize(150,0))
		elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
			local title1Type12 = GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF)
			title1Type12:setScale(0.65)
			title1Type12:setDimensions(GlobalMethod:CCSize(240))
			local title2Type12 = GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF)
			title2Type12:setScale(0.65)
			title2Type12:setDimensions(GlobalMethod:CCSize(240))
			local title3Type12 = GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF)
			title3Type12:setScale(0.65)
			title3Type12:setDimensions(GlobalMethod:CCSize(240))
		end
end

--@brief	更新类型15	tips
function WndTips:_update15()
	WZLog("WndTips:_update15")
	local tData = self.m_tData
		GetElement(self.m_root,"conType13_WndTips",WZUIContainer):setVisible(true)
		--设置名字描述
		GetElement(self.m_root,"titleType13_WndTips",WZUILabelTTF):setText(tData.name)
		GetElement(self.m_root,"descType13_WndTips",WZUILabelTTF):setText(tData.desc)

		local language = ProjConfig.LANGUAGE
		if language == "en" then
			GetElement(self.m_root,"titleType13_WndTips",WZUILabelTTF):setScale(0.6)
		    GetElement(self.m_root,"descType13_WndTips",WZUILabelTTF):setFontSize(20)
		end
		if language == "pt" then
			GetElement(self.m_root,"descType13_WndTips",WZUILabelTTF):setFontSize(17)
		end
		if language == "tr" then
			GetElement(self.m_root,"titleType13_WndTips",WZUILabelTTF):setScale(0.6)
		    GetElement(self.m_root,"descType13_WndTips",WZUILabelTTF):setFontSize(17)
		end

		if language == "vn" or language == "es" then
			GetElement(self.m_root,"descType13_WndTips",WZUILabelTTF):setFontSize(17)
			local titleType13 = GetElement(self.m_root,"titleType13_WndTips",WZUILabelTTF)
			titleType13:setFontSize(16)
			titleType13:setDimensions(GlobalMethod:CCSize(180,0))
		end

		--设置怪物头像
		if tData.icon ~= nil then
			WZLog("显示怪物头像图片")
			GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setFile(tData.icon)
			GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setVisible(true)
		else
            local head, tCell = CellHead:show(GetElement(self.m_root,"conType13",WZUIContainer),tData.head,tData.face,tData.sex)
			head:setScale(1.2)
			tCell:setHideBg()
			GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setVisible(false)
		end
end

--@brief	更新类型16	tips
function WndTips:_update16()
	WZLog("WndTips:_update16")
	local tData = self.m_tData
		GetElement(self.m_root,"conType14_WndTips",WZUIContainer):setVisible(true)
		for i=1,4 do
			if tData.id[i] ~= nil then
			GetElement(self.m_root,"img"..i.."Type14_WndTips",WZUIImage):setFile(GDatatab_item["id_"..tData.id[i]].icon)
			GetElement(self.m_root,"img"..i.."Type14_WndTips",WZUIImage):setScale(0.5)
			GetElement(self.m_root,"label"..i.."Type14_WndTips",WZUILabelTTF):setText(tData.num[i])
			else
			GetElement(self.m_root,"img"..i.."Type14_WndTips",WZUIImage):setVisible(false)
			GetElement(self.m_root,"label"..i.."Type14_WndTips",WZUILabelTTF):setVisible(false)
			end
		end
end

--@brief	更新类型17	排位赛tips
function WndTips:_update17()
	WZLog("WndTips:_update17")
	local tData = self.m_tData
    local lv = CacheCenter:getPlayerInfo().segmentLevel
	if tData.level ~= nil then lv = tData.level end
    local info = GetPvpDataByLevel(lv)
    WZLog("WndTips:_update17", lv)
	local conType15 = GetElement(self.m_root,"conType15_WndTips",WZUIContainer)
	conType15:setVisible(true)

    -- 等级图标
	local conIcon = GetElement(self.m_root, "conIcon_WndTips15", WZUIContainer)
	if conIcon then
		local celElement, tNewObj = CellPvpLevelIcon:createElement()
        if celElement and tNewObj then
            tNewObj:setData(info, false, 0.4, false)
            celElement:setScale(0.4)
            conIcon:addChild(celElement)
        end
	end
	--段位
	GetElement(self.m_root,"ttf1Type15_WndTips",WZUILabelTTF):setText(info.dan .. info.level2)
	--积分
	local integral = tData.exp 
	
	GetElement(self.m_root,"ttf8Type15_WndTips",WZUILabelTTF):setText(LocalStrings.INTEGRATION..":"..integral)
	--x战x胜
	GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,tData.total,tData.winNum))
	--胜率
	local winRate = tData.total == 0 and 0 or math.ceil((string.format("%.2f", tData.winNum/tData.total))*100)
	GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF):setText(winRate.."%")
	--最高连胜
	GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF):setText(tData.maxWinNum)

	local tProperty 
	if info.add_property == -1 then
		tProperty = CopyTable(GDatatab_trio_rank_match_config["id_2"].add_property)
		for i = 1, #tProperty do
			tProperty[i][2] = 0
		end
	else
		tProperty = info.add_property
	end
	--加成战力
	local nFighting = WndCard:_caculateFighting(tProperty)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips15", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"label7Type15_WndTips",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.366608))
	end

    for i = 1, #tProperty do
        local proName = GetElement(self.m_root,"label"..(2*i-1).."Type15_WndTips",WZUILabelTTF)
        local proValue =  GetElement(self.m_root,"label"..2*i.."Type15_WndTips",WZUILabelTTF)
        proName:setText(ATTR_TITLE[tProperty[i][1]])
        proValue:setText("+"..tProperty[i][2])
    end

    -- 历史最高等级图标
    if tData.maxLevel then 
    	GetElement(self.m_root, "conHistory_WndTips15", WZUIContainer):setVisible(true)
    	conType15:setAbsContentSize(GlobalMethod:CCSize(242,432))
    	conType15:updateRelativeSize()

		local conIconMax = GetElement(self.m_root, "conIconMax_WndTips15", WZUIContainer)
		local historyInfo = GetPvpDataByLevel(tData.maxLevel)
		if conIconMax then
			local celElement, tNewObj = CellPvpLevelIcon:createElement()
	        if celElement and tNewObj then
	            tNewObj:setData(historyInfo, false, 0.4, false)
	            celElement:setScale(0.4)
	            conIconMax:addChild(celElement)
	        end
		end
		if tData.maxLevel <= 0 then 
			GetElement(self.m_root,"txtHistoryName_WndTips",WZUILabelTTF):setText(historyInfo.dan)
		else
			GetElement(self.m_root,"txtHistoryName_WndTips",WZUILabelTTF):setText(historyInfo.dan .. historyInfo.level2)
		end
	end

    if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,tData.winNum,tData.total))
    	
    	local txt1 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	txt1:setScale(0.7)
		local txt3 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	txt3:setRelativePosition(GlobalMethod:ccp(0.51719,0.675088))
    	txt3:setScale(0.7)
    	txt3:setDimensions(GlobalMethod:CCSize(140,0))

    	local ttf4Type15 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	ttf4Type15:setRelativePosition(GlobalMethod:ccp(0.185207,0.585088))
    	ttf4Type15:setScale(0.7)
    	local ttf6 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
    	ttf6:setRelativePosition(GlobalMethod:ccp(0.333223,0.585088))
    	ttf6:setScale(0.7)

    	local ttf5 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	ttf5:setScale(0.7)
    	local ttf7 = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	ttf7:setScale(0.7)
    	ttf7:setRelativePosition(GlobalMethod:ccp(0.714215,0.495848))    	
    end
    if ProjConfig.LANGUAGE == "pt" then
    	GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,tData.winNum,tData.total))
    	
    	local txt5 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	txt5:setRelativePosition(GlobalMethod:ccp(0.0876033,0.675088))
    	txt5:setScale(0.8)
    	txt5:setDimensions(GlobalMethod:CCSize(120))
    	local txt7 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	txt7:setRelativePosition(GlobalMethod:ccp(0.48,0.675088))
    	txt7:setScale(0.8)
    	txt7:setDimensions(GlobalMethod:CCSize(140,0))

    	local txt10 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	txt10:setRelativePosition(GlobalMethod:ccp(0.305042,0.585088))
    	txt10:setScale(0.8)
    	local txt9 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
    	txt9:setRelativePosition(GlobalMethod:ccp(0.539835,0.585088))
    	txt9:setScale(0.8)

    	local txt6 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	txt6:setRelativePosition(GlobalMethod:ccp(0.0917355,0.495848))
    	txt6:setScale(0.8)
    	-- txt6:setDimensions(GlobalMethod:CCSize(170,0))
    	local txt8 = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	txt8:setRelativePosition(GlobalMethod:ccp(0.565455,0.495848))
    	txt8:setScale(0.8)

    	GetElement(self.m_root,"ttf1Type15_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.89462))
    	local ttf11 = GetElement(self.m_root,"ttf8Type15_WndTips",WZUILabelTTF)
    	ttf11:setRelativePosition(GlobalMethod:ccp(0.33,0.828392))
    	ttf11:setFontSize(16)
    end
    if ProjConfig.LANGUAGE == "es" then
    	local txt5 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	txt5:setRelativePosition(GlobalMethod:ccp(0.06281,0.675088))
    	txt5:setScale(0.8)
    	txt5:setDimensions(GlobalMethod:CCSize(130))
    	local txt7 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	txt7:setRelativePosition(GlobalMethod:ccp(0.496528,0.675088))
    	txt7:setScale(0.8)
    	txt7:setDimensions(GlobalMethod:CCSize(140,0))

    	local txt10 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	txt10:setRelativePosition(GlobalMethod:ccp(0.3,0.585088))
    	txt10:setScale(0.8)
    	local txt9 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
    	txt9:setRelativePosition(GlobalMethod:ccp(0.556364,0.585088))
    	txt9:setScale(0.8)

    	local txt6 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	txt6:setRelativePosition(GlobalMethod:ccp(0.0710744,0.495848))
    	txt6:setScale(0.8)
    	txt6:setDimensions(GlobalMethod:CCSize(170,0))
    	local txt8 = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	txt8:setRelativePosition(GlobalMethod:ccp(0.672893,0.495848))
    	txt8:setScale(0.8)

    	GetElement(self.m_root,"ttf1Type15_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.89462))
    	local ttf11 = GetElement(self.m_root,"ttf8Type15_WndTips",WZUILabelTTF)
    	ttf11:setRelativePosition(GlobalMethod:ccp(0.33,0.828392))
    	ttf11:setFontSize(16)

    elseif ProjConfig.LANGUAGE == "vn" then
    	local ttf3Type15 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	ttf3Type15:setScale(0.7)
    	local ttf2Type15 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	ttf2Type15:setRelativePosition(GlobalMethod:ccp(0.55438,0.675088))
    	ttf2Type15:setScale(0.7)
    	local ttf4Type15 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	ttf4Type15:setRelativePosition(GlobalMethod:ccp(0.176942,0.585088))
    	ttf4Type15:setScale(0.7)
    	local ttf6Type15 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
    	ttf6Type15:setRelativePosition(GlobalMethod:ccp(0.267107,0.585088))
    	ttf6Type15:setScale(0.7)
    	local ttf5Type15 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	ttf5Type15:setScale(0.7)
		local ttf7Type15 = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	ttf7Type15:setRelativePosition(GlobalMethod:ccp(0.55719,0.495848))
    	ttf7Type15:setScale(0.7)
    	GetElement(self.m_root,"label7Type15_WndTips",WZUILabelTTF):setScale(0.7)
    end
    if ProjConfig.LANGUAGE == "tr" then
    	local ttf3Type15 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	ttf3Type15:setRelativePosition(GlobalMethod:ccp(0.1,0.675088))
    	ttf3Type15:setScale(0.7)    	
    	local ttf2Type15 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	ttf2Type15:setRelativePosition(GlobalMethod:ccp(0.44281,0.675088))
    	ttf2Type15:setScale(0.7)
    	ttf2Type15:setDimensions(GlobalMethod:CCSize(180))

    	local ttf4Type15 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	ttf4Type15:setRelativePosition(GlobalMethod:ccp(0.305041,0.585088))
    	ttf4Type15:setScale(0.7)
    	local ttf6Type15 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
    	ttf6Type15:setRelativePosition(GlobalMethod:ccp(0.515041,0.585088))
    	ttf6Type15:setScale(0.7)

    	local ttf5Type15 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	ttf5Type15:setRelativePosition(GlobalMethod:ccp(0.1,0.495848))
    	ttf5Type15:setScale(0.7)
    	local ttf7Type15_ = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	ttf7Type15_:setRelativePosition(GlobalMethod:ccp(0.714215,0.495848))
    	ttf7Type15_:setScale(0.7)

    	GetElement(self.m_root,"ttf1Type15_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.89462))
    	local ttf11 = GetElement(self.m_root,"ttf8Type15_WndTips",WZUILabelTTF)
    	ttf11:setRelativePosition(GlobalMethod:ccp(0.33,0.828392))
    	ttf11:setFontSize(16)
    end
    if ProjConfig.LANGUAGE == "th" then
    	GetElement(self.m_root,"ttf1Type15_WndTips",WZUILabelTTF):setScale(0.8)
    	GetElement(self.m_root,"ttf8Type15_WndTips",WZUILabelTTF):setScale(0.8)

    	local ttf3Type15 = GetElement(self.m_root,"ttf3Type15_WndTips",WZUILabelTTF)
    	ttf3Type15:setScale(0.75)
    	ttf3Type15:setRelativePosition(GlobalMethod:ccp(0.0669421,0.675088))
		local ttf2Type15 = GetElement(self.m_root,"ttf2Type15_WndTips",WZUILabelTTF)
    	ttf2Type15:setRelativePosition(GlobalMethod:ccp(0.51719,0.675088))
    	ttf2Type15:setScale(0.75)

    	local ttf4Type15 = GetElement(self.m_root,"ttf4Type15_WndTips",WZUILabelTTF)
    	ttf4Type15:setRelativePosition(GlobalMethod:ccp(0.131488,0.585088))
    	ttf4Type15:setScale(0.75)
    	local ttf6Type15 = GetElement(self.m_root,"ttf6Type15_WndTips",WZUILabelTTF)
        ttf6Type15:setScale(0.75)
    	ttf6Type15:setRelativePosition(GlobalMethod:ccp(0.205124,0.585088))

    	local ttf5Type15 = GetElement(self.m_root,"ttf5Type15_WndTips",WZUILabelTTF)
    	ttf5Type15:setRelativePosition(GlobalMethod:ccp(0.0710744,0.495848))
    	ttf5Type15:setScale(0.75)
    	local ttf7Type15 = GetElement(self.m_root,"ttf7Type15_WndTips",WZUILabelTTF)
    	ttf7Type15:setRelativePosition(GlobalMethod:ccp(0.424959,0.495848))
    	ttf7Type15:setScale(0.75)
    end
end

--@brief	更新类型18	tips
function WndTips:_update18()
	WZLog("WndTips:_update18")
	local tData = self.m_tData
		GetElement(self.m_root,"conType16_WndTips",WZUIContainer):setVisible(true)
		self.m_tData = tData

		--技能图片
		GetElement(self.m_root,"imgType16_WndTips",WZUIImage):setFile(tData.icon)
		--技能名称
		GetElement(self.m_root,"label1Type16_WndTips",WZUILabelTTF):setText(tData.name1)

		--技能状态
		local label3Type16 = GetElement(self.m_root,"label3Type16_WndTips",WZUILabelTTF)
		label3Type16:setText(tData.stateDesc)
		if tData.state == 1 or tData.state == 5 then
			label3Type16:setColor(GlobalMethod:ccc3(99,255,95))
		end
		--行动值
		local label7 = GetElement(self.m_root,"label7Type16_WndTips",WZUILabelTTF)
		label7:setText(tData.cost)
		--初始CD
		local label8 = GetElement(self.m_root,"label8Type16_WndTips",WZUILabelTTF)
		label8:setText(tData.cd)
		--技能描述
		local text = [[<T C="127,70,26" S="22">瞬间恢复</T><T C="99,255,95" S="20">10%+100</T><T C="127,70,26" S="22">点生命值</T>]]
		local label9 = GetElement(self.m_root,"label9Type16_WndTips",WZUIFreeTextBox)
		label9:setShowText(tData.desc)

		--按钮状态
		if tData.state == 1 then
			GetElement(self.m_root,"btnType16_WndTips",WZUIButton):setVisible(true)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label10Type16_WndTips",WZUILabelTTF):setText(LocalStrings.USE)
			GetElement(self.m_root,"label3Type16_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(99,255,95))

                TeachGroup1:startGroup({5,5,self.m_root})
		elseif tData.state == 2 then
			GetElement(self.m_root,"btnType16_WndTips",WZUIButton):setVisible(false)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.TIPSWORD4,tData.vipLevel))
		elseif tData.state == 3 then
			GetElement(self.m_root,"btnType16_WndTips",WZUIButton):setVisible(false)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.TIPSWORD5,tData.level))
		elseif tData.state == 4 then
			GetElement(self.m_root,"btnType16_WndTips",WZUIButton):setVisible(true)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label10Type16_WndTips",WZUILabelTTF):setText(LocalStrings.TIPSWORD6)
			GetElement(self.m_root, "txtDiamondNum_conType16", WZUILabelTTF):setText(tData.costCount)
			GetElement(self.m_root, "conDiamond_conType16", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "imgSecondLine_conType16", WZUIImage):setVisible(true)
			GetElement(self.m_root, "imgThirdLine_conType16", WZUIImage):setVisible(false)
		elseif tData.state == 5 then
			GetElement(self.m_root,"btnType16_WndTips",WZUIButton):setVisible(true)
			GetElement(self.m_root,"label12Type16_WndTips",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label10Type16_WndTips",WZUILabelTTF):setText(LocalStrings.UNROYAL)
		end
	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"label3Type16_WndTips",WZUILabelTTF):setFontSize(18)
	elseif ProjConfig.LANGUAGE == "es" then
		local label = GetElement(self.m_root,"label7Type16_WndTips",WZUILabelTTF)
		label:setRelativePosition(GlobalMethod:ccp(0.43,0.86))
		label = GetElement(self.m_root,"label8Type16_WndTips",WZUILabelTTF)
		label:setRelativePosition(GlobalMethod:ccp(0.38,0.67))
	end
	if ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"label4Type16_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"label5Type16_WndTips",WZUILabelTTF):setFontSize(16)
		label7:setRelativePosition(GlobalMethod:ccp(0.4,0.86))
		label8:setRelativePosition(GlobalMethod:ccp(0.4,0.67))
		label9:setRelativePosition(GlobalMethod:ccp(0.33,0.53))
	end
end

--@brief	更新类型19	tips
function WndTips:_update19()
	WZLog("WndTips:_update19")
	local tAttr = {}
	local tStarsoul = GDatatab_starsoul["id_"..self.m_tData.starID]
	--计算属性
	for i=0,6 do
		local tStarsoulx = GDatatab_starsoul["id_"..(self.m_tData.starID-i)]
		if tStarsoulx ~= nil and tStarsoulx.star == tStarsoul.star then
			local attrID = tStarsoulx.property[1][1]
			local attrValue = tStarsoulx.property[1][2]
			if tAttr[attrID] == nil then
				tAttr[attrID] = attrValue
			else
				tAttr[attrID] = tAttr[attrID] + attrValue
			end
		end
	end
	local text = [[<T C="127,70,26" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
	local index = 1
	--设置属性
	for k,v in pairs(tAttr) do
		GetElement(self.m_root,"txt"..index.."Type17_WndTips",WZUIFreeTextBox):setShowText(string.format(text,ATTR_TITLE[k],v))
		index = index + 1
	end
	--设置动画
	GetElement(self.m_root,"img_WndTips",WZUISpine):play(tStarsoul.star_icon,true)
	GetElement(self.m_root,"img_WndTips",WZUISpine):setScale(0.9)
	--设置标题
	GetElement(self.m_root,"title1Type17_WndTips",WZUILabelTTF):setText(tStarsoul.name..LocalStrings.STAR_PROPERTY_ADD)
end

--@brief	更新类型20 tips
function WndTips:_update20()
	WZLog("WndTips:_update20")
	GetElement(self.m_root,"label1Type18_WndTips",WZUILabelTTF):setText("VIP "..self.m_tData.vipLevel)
	if self.m_tData.other and self.m_tData.id ~= CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"btn1Type18_WndTips",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btn2Type18_WndTips",WZUIButton):setVisible(false)
		GetElement(self.m_root,"con1Type18_WndTips",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"bgType18_WndTips",WZUI9Image):setVisible(false)
	else
		GetElement(self.m_root,"con1Type18_WndTips",WZUIContainer):setVisible(false)
		if self.m_tData.vipLevel == 0 then
			GetElement(self.m_root,"btn1Type18_WndTips",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btn2Type18_WndTips",WZUIButton):setVisible(false)
		else
			GetElement(self.m_root,"btn1Type18_WndTips",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btn2Type18_WndTips",WZUIButton):setVisible(true)
		end
	end
	local language = ProjConfig.LANGUAGE
	if language == "en" then
		GetElement(self.m_root,"ttf1Type18_WndTips",WZUILabelTTF):setScale(0.55)
		GetElement(self.m_root,"ttf2Type18_WndTips",WZUILabelTTF):setScale(0.75)
	end
	if language == "pt" or language == "es" then
		local ttf1 = GetElement(self.m_root,"ttf1Type18_WndTips",WZUILabelTTF)
		ttf1:setScale(0.5)
		ttf1:setDimensions(GlobalMethod:CCSize(116,0))
		GetElement(self.m_root,"ttf2Type18_WndTips",WZUILabelTTF):setScale(0.7)
	end
	if language == "tr" then
		local ttf1Type18 = GetElement(self.m_root,"ttf1Type18_WndTips",WZUILabelTTF)
		ttf1Type18:setScale(0.55)
		ttf1Type18:setDimensions(GlobalMethod:CCSize(110,0))
		GetElement(self.m_root,"ttf2Type18_WndTips",WZUILabelTTF):setScale(0.8)
	end
	if language == "ug" then
		local ttf1Type18 = GetElement(self.m_root,"ttf1Type18_WndTips",WZUILabelTTF)
		ttf1Type18:setScale(0.6)
		ttf1Type18:setDimensions(GlobalMethod:CCSize(140,0))
		local ttf2Type18 = GetElement(self.m_root,"ttf2Type18_WndTips",WZUILabelTTF)
		ttf2Type18:setScale(0.45)
		ttf1Type18:setDimensions(GlobalMethod:CCSize(210,0))
	end
end

--@brief	更新类型21	公会tips
function WndTips:_update21()
	WZLog("WndTips:_update21")
	local tData = self.m_tData
	local guildInfo = tData.guildInfo[1]
	--图腾图片
	GetElement(self.m_root,"imgHeadType19_WndTips",WZUIImage):setFile(tData.icon)
	--公会图腾等级
	GetElement(self.m_root,"ttf1Type19_WndTips",WZUILabelTTF):setText(tData.title1)
	--公会名
	GetElement(self.m_root,"ttf2Type19_WndTips",WZUILabelTTF):setText(tData.guildName)
	--会长战力
	GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF):setText(guildInfo.fight)
	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips19", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	--会长名字
	GetElement(self.m_root, "ttf8Type19_WndTips", WZUILabelTTF):setText(guildInfo.captainName)
	--会长等级
	GetElement(self.m_root, "ttf6Type19_WndTips", WZUILabelTTF):setText(guildInfo.lv)
	--会长头像
	local conHead = GetElement(self.m_root, "conHead_WndTips19", WZUIContainer)
	local cellElement =  CellHead:show(conHead, tonumber(guildInfo.headId), tonumber(guildInfo.faceId), tonumber(guildInfo.sex), nil, nil, tonumber(guildInfo.vip), tonumber(guildInfo.headcolour))
	cellElement:setScale(1.13)
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtFight_WndTips19",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.39))
	end
	--属性加成
	GetElement(self.m_root,"label1Type19_WndTips",WZUILabelTTF):setText(tData.attr1)
	GetElement(self.m_root,"label2Type19_WndTips",WZUILabelTTF):setText("+"..tData.attrVal1)
	GetElement(self.m_root,"label3Type19_WndTips",WZUILabelTTF):setText(tData.attr2)
	GetElement(self.m_root,"label4Type19_WndTips",WZUILabelTTF):setText("+"..tData.attrVal2)
	GetElement(self.m_root,"label5Type19_WndTips",WZUILabelTTF):setText(tData.attr3)
	GetElement(self.m_root,"label6Type19_WndTips",WZUILabelTTF):setText("+"..tData.attrVal3)
	if tData.level ~= nil then
		GetElement(self.m_root,"txtLvType19_WndTips",WZUILabelAtlasFont):setText(tData.level)
		GetElement(self.m_root,"txtLvType19_WndTips",WZUILabelAtlasFont):setVisible(false)
	else
		GetElement(self.m_root,"txtLvType19_WndTips",WZUILabelAtlasFont):setVisible(false)
	end
	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"ttf1Type19_WndTips",WZUILabelTTF):setFontSize(16)
		local ttf5 = GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF)
		ttf5:setRelativePosition(GlobalMethod:ccp(0.38,0.55))
		ttf5:setFontSize(16)
	end
	if ProjConfig.LANGUAGE == "th" then
		GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.55))
	end
	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf3Type19_WndTips",WZUILabelTTF):setFontSize(18)
		GetElement(self.m_root,"txtFight_WndTips19",WZUILabelTTF):setScale(0.7)
	end
    if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
        GetElement(self.m_root,"ttf1Type19_WndTips",WZUILabelTTF):setFontSize(16)
        local ttf5Type19 = GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF)
        ttf5Type19:setRelativePosition(GlobalMethod:ccp(0.37,0.55))
        ttf5Type19:setDimensions(GlobalMethod:CCSize(120,0))
    end
	if ProjConfig.LANGUAGE == "tr" then
		local ttf = GetElement(self.m_root,"ttf1Type19_WndTips",WZUILabelTTF)
		ttf:setDimensions(GlobalMethod:CCSize(140,0))
		ttf:setFontSize(16)
		ttf = GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF)
		ttf:setRelativePosition(GlobalMethod:ccp(0.39,0.55))
		ttf:setFontSize(16)
	end
end

--@brief	更新类型22	恩爱tips
function WndTips:_update22()
	WZLog("WndTips:_update22")
	if self.m_tData == nil then return end
	local tData = self.m_tData
	--图片
	local imgHeadType20 = GetElement(self.m_root,"imgHeadType20_WndTips",WZUIImage)
	imgHeadType20:setFile(tData.icon)
	imgHeadType20:setRelativePosition(GlobalMethod:ccp(0.217,0.865))
	if tData.scale ~= nil then
		imgHeadType20:setScale(tData.scale)
	end
	GetElement(self.m_root, "conMate_WndTips20", WZUIContainer):setVisible(true)
	--恩爱等级
	local ttf1Type20 = GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF)
	ttf1Type20:setText(tData.title1)
	ttf1Type20:setRelativePosition(GlobalMethod:ccp(0.4,0.9))
	local tTempData = CellRelation:getRelationName(1, tData.level or 1)
	local title = tTempData.title
	if ProjConfig.LANGUAGE == "cn" then
		title = string.gsub(title, "的", "")
	end
	GetElement(self.m_root,"ttf4Type20_WndTips",WZUILabelTTF):setText(title)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		ttf1Type20:setScale(0.8)
		GetElement(self.m_root,"ttf3Type20_WndTips",WZUILabelTTF):setFontSize(17)
	end
	if tonumber(tData.level) ~= nil then
		GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setVisible(true)
		GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setText(tData.level)
	end
	GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setVisible(false)
	--伴侣
	local conHead = GetElement(self.m_root, "conHead_WndTips20", WZUIContainer)
	local cellElement =  CellHead:show(conHead, tData.mateInfo.headId, tData.mateInfo.faceId, tData.mateInfo.sex, nil, nil, tData.mateInfo.vipLevel, tData.mateInfo.headColour)
	cellElement:setScale(1.13)
	GetElement(self.m_root,"ttf8Type20_WndTips",WZUILabelTTF):setText(tData.mateName)
	GetElement(self.m_root,"ttf7Type20_WndTips",WZUILabelTTF):setText(tData.mateInfo.lv)
	GetElement(self.m_root,"ttf10Type20_WndTips",WZUILabelTTF):setText(tData.mateInfo.fight)
	--加成战力
	-- local nFighting = WndCard:_caculateFighting(tData.property)
	-- local txtFighting = GetElement(self.m_root, "txtFighting_WndTips20", WZUILabelTTF)
	-- if txtFighting then 
	-- 	txtFighting:setVisible(true)
	-- 	txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	-- end
	--属性加成
	GetElement(self.m_root,"label1Type20_WndTips",WZUILabelTTF):setText(tData.attr1)
	GetElement(self.m_root,"label2Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal1)
	if tData.attr2 ~= nil then
		GetElement(self.m_root,"label3Type20_WndTips",WZUILabelTTF):setText(tData.attr2)
		GetElement(self.m_root,"label4Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal2)
	else
		GetElement(self.m_root,"label3Type20_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label4Type20_WndTips",WZUILabelTTF):setVisible(false)
	end
	if tData.attr3 ~= nil then
		GetElement(self.m_root,"label5Type20_WndTips",WZUILabelTTF):setText(tData.attr3)
		GetElement(self.m_root,"label6Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal3)
	else
		GetElement(self.m_root,"label5Type20_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label6Type20_WndTips",WZUILabelTTF):setVisible(false)
	end
	if ProjConfig.LANGUAGE == "pt" then
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setFontSize(16) 
	elseif ProjConfig.LANGUAGE == "vn" then
		ttf1Type20:setFontSize(16)
		GetElement(self.m_root,"ttf4Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf5Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf6Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf7Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf8Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf9Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"ttf10Type20_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"txtFight_WndTips20",WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "en" then
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setRelativePosition(GlobalMethod:ccp(0.37,0.588))
	end
	if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setFontSize(16)
	end
end

--@brief	更新类型23	师徒tips
function WndTips:_update23()
	WZLog("WndTips:_update23")
	local tData = self.m_tData

	--图片
	tData.scale = tData.scale or 1
	local imgHeadType = GetElement(self.m_root,"imgHeadType21_WndTips",WZUIImage)
	imgHeadType:setFile(tData.icon)
	imgHeadType:setScale(tData.scale)
	--师德等级
	local str_title = tData.title1 or ""
	local ttf1Type21 = GetElement(self.m_root,"ttf1Type21_WndTips",WZUILabelTTF)
	ttf1Type21:setText(tData.title1)
	--师傅or徒弟
	if string.len(tData.title3) > 0 then 
		ttf1Type21:setRelativePosition(GlobalMethod:ccp(0.37, 0.88))
	end

	if tData.level == nil then tData.level = 0 end
	if tData.level > 0 then
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setText(tData.level)
	else
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setVisible(false)
	end
	GetElement(self.m_root,"ttf3Type21_WndTips",WZUILabelTTF):setText(tData.title3)
	--师徒列表
	local conList = GetElement(self.m_root, "conList_WndTips21", WZUIContainer)
	local conType21 = GetElement(self.m_root, "conType21_WndTips", WZUIContainer)
	conList:removeAllChildrenWithCleanup(true)
	--有多个徒弟时，拉长底图，属性往下移
	--计算是否超过5个徒弟，超过则需要分页
	local maxCount = 5
	local nPages = (tData.title2 ~= nil and #tData.title2 > 1) and math.ceil(#tData.title2 / maxCount) or 1
	WZLog("WndTips:_update23 nPages=", nPages)
	if tData.title2 ~= nil and #tData.title2 > 1 then
		local nCount = (#tData.title2 > maxCount) and maxCount or #tData.title2
		conList:setAbsContentSize(GlobalMethod:CCSize(260 * nPages, 80 * nCount))
		conList:updateRelativeSize()
		conType21:setAbsContentSize(GlobalMethod:CCSize(260 * nPages, 312 + 80 * (nCount - 1)))
		conType21:updateRelativeSize()

		--设置两条分割线的缩放
		local fengexian01 = GetElement(self.m_root, "fengexian01_WndTips21", WZUIImage)
		if fengexian01 then
			fengexian01:setScaleX(1.25 * nPages)
		end
		local fengexian02 = GetElement(self.m_root, "fengexian02_WndTips21", WZUIImage)
		if fengexian02 then
			fengexian02:setScaleX(1.25 * nPages)
		end
	end

	for i=1, #tData.title2 do
		local tempCount = (#tData.title2 > maxCount) and maxCount or #tData.title2
		local tempPos = {130 + math.floor((i - 1) / maxCount) * 260, 40 + ((tempCount - 1) - ((i - 1) % maxCount)) * 80}
		WZLog("WndTips:_update23 tempPos=", Serialize(tempPos))

		local tempInfo = tData.title2[i]
		local element = WZUISystem:getInstance():createElement("conHeadCell_WndTips21")
		element:setVisible(true)
		local conHead = GetElement(element, "conHead_WndTips21", WZUIContainer)
		local cellElement = CellHead:show(conHead, tonumber(tempInfo.headId), tonumber(tempInfo.faceId), tonumber(tempInfo.sex), nil, nil, tonumber(tempInfo.vip), tonumber(tempInfo.headcolour))
		cellElement:setScale(1.13)

		GetElement(element, "btnHead_WndTips21", WZUIButton):setTag(tonumber(tempInfo.playerId))

		GetElement(element,"ttf5Type21_WndTips",WZUILabelTTF):setText(tData.title)
		GetElement(element,"ttf7Type21_WndTips",WZUILabelTTF):setText(tempInfo.lv)
		GetElement(element,"ttf8Type21_WndTips",WZUILabelTTF):setText(tempInfo.name)
		GetElement(element,"ttf10Type21_WndTips",WZUILabelTTF):setText(tempInfo.fight)
		
		element:setUseAbsCoordinate(true)
		element:setAbsPosition(GlobalMethod:ccp(tempPos[1], tempPos[2]))
		conList:addChild(element)
	end
	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips21", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtFight_WndTips21",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.39))
	end
	--属性加成
	GetElement(self.m_root,"label1Type21_WndTips",WZUILabelTTF):setText(tData.attr1)
	GetElement(self.m_root,"label2Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal1)
	GetElement(self.m_root,"label3Type21_WndTips",WZUILabelTTF):setText(tData.attr2)
	GetElement(self.m_root,"label4Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal2)
	GetElement(self.m_root,"label5Type21_WndTips",WZUILabelTTF):setText(tData.attr3)
	GetElement(self.m_root,"label6Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal3)


	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		local ttf1Type21 = GetElement(self.m_root,"ttf1Type21_WndTips",WZUILabelTTF)
		ttf1Type21:setFontSize(16)
		ttf1Type21:setDimensions(GlobalMethod:CCSize(120,0))
	elseif ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtFight_WndTips21",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"ttf3Type21_WndTips",WZUILabelTTF):setScale(0.7)
	end
end

--@brief 	更新类型  武器技能Tips
function WndTips:_update24() 
	-- body
	WZLog("WndTips:_update24")
	local tData = self.m_tData
	--技能图标
	GetElement(self.m_root,"imgSkillP_WndTips22",WZUIImage):setFile(tData.icon)
	--技能等级
	GetElement(self.m_root,"imgSkillLv_WndTips22",WZUIImage):setFile(tData.lv_icon)
	--技能名字
	GetElement(self.m_root,"label1Type22_WndTips",WZUILabelTTF):setText(tData.name)
	--技能描述
	GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF):setText(tData.tool_desc)
	--行动属性值
	local nConsume = math.ceil(tData.consume/1000)
	GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setText(nConsume)
    WZLog("WndTips:_update24 mm:", tData.btnType)
	if tData.btnType and tData.btnType == 1 then
		GetElement(self.m_root,"label4Type22_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setVisible(false)
	end
	--按钮字
	if tData.status == 0 then
		GetElement(self.m_root,"label10Type22_WndTips",WZUILabelTTF):setText(LocalStrings.WORD_LOCK)
	else
		local label10Type22 = GetElement(self.m_root,"label10Type22_WndTips",WZUILabelTTF)
		label10Type22:setText(LocalStrings.TIPSWORD6)
		if ProjConfig.LANGUAGE == "es" then
			label10Type22:setScale(0.78)
		end
	end

	local language = ProjConfig.LANGUAGE
	if language == "th" then
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	elseif language == "vn" then
		GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF):setFontSize(16)
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	elseif language == "en" then
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.525714,0.5))
		GetElement(self.m_root,"label1Type22_WndTips",WZUILabelTTF):setScale(0.7)
		local label3Type22 = GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF)
		label3Type22:setScale(0.7)
		label3Type22:setDimensions(GlobalMethod:CCSize(270))
	elseif language == "pt" then
		GetElement(self.m_root,"label10Type22_WndTips",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
		
		GetElement(self.m_root,"label1Type22_WndTips",WZUILabelTTF):setScale(0.8)
		local label3Type22 = GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF)
		label3Type22:setScale(0.7)
		label3Type22:setDimensions(GlobalMethod:CCSize(270))
	elseif language == "tr" then
		GetElement(self.m_root,"label1Type22_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))
		local label3Type22 = GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF)
		label3Type22:setScale(0.7)
		label3Type22:setDimensions(GlobalMethod:CCSize(270))
	elseif ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"label7Type22_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		GetElement(self.m_root,"label1Type22_WndTips",WZUILabelTTF):setScale(0.7)
		local label3Type22 = GetElement(self.m_root,"label3Type22_WndTips",WZUILabelTTF)
		label3Type22:setScale(0.7)
		label3Type22:setDimensions(GlobalMethod:CCSize(270))
	end
end

--@brief 	更新类型 	祝福Tips
function WndTips:_update25()
	-- body
	if self.m_tData == nil then return end
	WZLog("WndTips:_update25", self.m_tData.basicInfo.sub_type)
	WndTips.m_root:setShowAll(true)
	GetElement(self.m_root,"bgType24",WZUI9Image):setScaleY(1)
	local QUALITY_COLOR = {GlobalMethod:ccc3(127,70,26), GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(233,166,62)}
	local QUALITY_RECT_TIPS = {"ui/common/common_scale9_wuse.png","ui/common/common_scale9_lv.png","ui/common/common_scale9_lan.png","ui/common/common_scale9_zi.png","ui/common/common_scale9_cheng.png"}

	local tData = self.m_tData
	local conExp_conType24 = GetElement(self.m_root, "conExp_conType24", WZUIContainer)
	local label5Type24 = GetElement(self.m_root, "label5Type24_WndTips", WZUILabelTTF)
	local label6Type24 = GetElement(self.m_root, "label6Type24_WndTips", WZUILabelTTF)
	local label8Type24 = GetElement(self.m_root, "label8Type24_WndTips", WZUILabelTTF)
	local label9Type24 = GetElement(self.m_root, "label9Type24_WndTips", WZUILabelTTF)
	local btnOperate1 = GetElement(self.m_root, "btnOperate1_WndTips", WZUIButton)
	local btnOperate2 = GetElement(self.m_root, "btnOperate2_WndTips", WZUIButton)
	local txtOperate1Type24 = GetElement(self.m_root, "txtOperate1Type24_WndTips", WZUILabelTTF)
	local txtOperate2Type24 = GetElement(self.m_root, "txtOperate2Type24_WndTips", WZUILabelTTF)
	local label1Type24 = GetElement(self.m_root, "label1Type24_WndTips", WZUILabelTTF)
	local label3Type24 = GetElement(self.m_root, "label3Type24_WndTips", WZUILabelTTF)
	local spineItem = GetElement(self.m_root, "spineItem_WndTips24", WZUISpine)
	local txtExpNum = GetElement(self.m_root, "txtExpNum_conType24", WZUILabelTTF)
	local progExp = GetElement(self.m_root, "progExp_WndTips24", WZUIProgress)
	local imgQualityRect = GetElement(self.m_root, "imgQualityRect_WndTips24", WZUIImage)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "es" then
		label3Type24:setFontSize(18)
	end
	--名字
	label1Type24:setText("Lv"..tData.level .. tData.basicInfo.name)
	label1Type24:setColor(QUALITY_COLOR[tData.basicInfo.quality + 1])
	--图标
	spineItem:setAnimationName(tData.basicInfo.icon)
	--描述desc
	label3Type24:setText(tData.basicInfo.desc)
	--品质框
	imgQualityRect:setFile(QUALITY_RECT_TIPS[tData.basicInfo.quality + 1])
	--经验
	if tData.basicInfo.sub_type ~= 32 and tData.basicInfo.sub_type ~= 31 and tData.userType ~= 5 and tData.userType ~= 6 then 	--经验祝福不显示经验条
		local nMaxLevel = self:_getMaxLevel25(tData.item_id)
	    local nCurExp = tData.curExp
	    local nTotalExp = tData.total_exp
	    if tData.level == nMaxLevel then
	    	local nTempId = self:_getSecondMaxLevel25(nMaxLevel, tData.item_id)
	    	local tTempData = GDatatab_pray["id_"..nTempId]
	        nCurExp = tTempData.total_exp
	        nTotalExp = tTempData.total_exp
	    end
		--经验
		txtExpNum:setText(nCurExp .. "/"..nTotalExp)
		local nPercent = math.floor(100 * nCurExp/nTotalExp)
		progExp:setPercentage(nPercent)
	end
	--属性数量
	if tData.property ~= 0 then
		local nPropertyType = #tData.property
		if nPropertyType == 1 and tData.basicInfo.sub_type ~= 31 then
			label6Type24:setVisible(false)
			label9Type24:setVisible(false)
			label5Type24:setText(ATTR_TITLE[tData.property[1][1]])
			label8Type24:setText("+"..tData.property[1][2])
		elseif nPropertyType == 2 and tData.basicInfo.sub_type ~= 31 then
			label5Type24:setText(ATTR_TITLE[tData.property[1][1]])
			label8Type24:setText("+"..tData.property[1][2])
			label6Type24:setText(ATTR_TITLE[tData.property[2][1]])
			label9Type24:setText("+"..tData.property[2][2])
		end
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or 
			ProjConfig.LANGUAGE == "pt" then
			label8Type24:setRelativePosition(GlobalMethod:ccp(0.43,0.63))
			label9Type24:setRelativePosition(GlobalMethod:ccp(0.45,0.4))
		end
		if ProjConfig.LANGUAGE == "vn" then
			label8Type24:setRelativePosition(GlobalMethod:ccp(0.43,0.63))
			label3Type24:setDimensions(GlobalMethod:CCSize(0,0))
			label3Type24:setFontSize(16)
			label9Type24:setRelativePosition(GlobalMethod:ccp(0.45,0.4))
		end
		if ProjConfig.LANGUAGE == "tr" then
			label8Type24:setRelativePosition(GlobalMethod:ccp(0.56,0.63))
			label9Type24:setRelativePosition(GlobalMethod:ccp(0.45,0.4))
		end
		if ProjConfig.LANGUAGE == "es" then
			label8Type24:setRelativePosition(GlobalMethod:ccp(0.6,0.63))
			label8Type24:setFontSize(18)
			label9Type24:setRelativePosition(GlobalMethod:ccp(0.5,0.4))
			label5Type24:setFontSize(16)
		end
	end

	if tData.basicInfo.sub_type == 31 then 				--只能用于出售的祝福（垃圾祝福）
		GetElement(self.m_root, "conProperty_WndTips24", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "imgThirdLine_conType24", WZUIImage):setVisible(false)
		local conType24_WndTips = GetElement(self.m_root, "conType24_WndTips", WZUIContainer)
		conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,200))
		conType24_WndTips:setRelativeSize(GlobalMethod:CCSize(1,0.5))
		conType24_WndTips:updateRelativeSize()

		conExp_conType24:setVisible(false)
		btnOperate1:setVisible(true)
		btnOperate1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		txtOperate1Type24:setText(LocalStrings.SELL)
	elseif tData.basicInfo.sub_type == 32 then 				--（经验祝福）
		GetElement(self.m_root, "conProperty_WndTips24", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "imgThirdLine_conType24", WZUIImage):setVisible(false)
		local conType24_WndTips = GetElement(self.m_root, "conType24_WndTips", WZUIContainer)
		if tData.userType == 2 then
			GetElement(self.m_root, "imgFirstLine_conType24", WZUIImage):setVisible(false)
			conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,100))
			btnOperate2:setVisible(false)
		elseif tData.userType == 4 then
			conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,200))
			btnOperate2:setVisible(true)
			txtOperate2Type24:setText(LocalStrings.BUY)
		else
			conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,200))
			btnOperate2:setVisible(true)
			txtOperate2Type24:setText(LocalStrings.BLESS_PICK)
		end
		
		conType24_WndTips:setRelativeSize(GlobalMethod:CCSize(1,0.5))
		conType24_WndTips:updateRelativeSize()
		
		conExp_conType24:setVisible(false)
		btnOperate1:setVisible(false)
		btnOperate2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		if tData.userType == 7 then 	--萃取
			txtOperate2Type24:setText(LocalStrings.EXTRACTION_TEXT1)
		end
	elseif tData.userType == 1 then		--祈福屋中的祈福
		btnOperate1:setVisible(true)
		btnOperate2:setVisible(true)
		txtOperate1Type24:setText(LocalStrings.DEVOUR_WORDS)
		txtOperate2Type24:setText(LocalStrings.BLESS_PICK)
	elseif tData.userType == 2 then 		--背包中的祈福
		btnOperate1:setVisible(true)
		btnOperate2:setVisible(true)
		txtOperate1Type24:setText(LocalStrings.DEVOUR_WORDS)
		txtOperate2Type24:setText(LocalStrings.EQUIPMENT)
	elseif tData.userType == 3 then 		-- 装备栏的祈福		
		btnOperate1:setVisible(true)
		btnOperate2:setVisible(true)	
		txtOperate1Type24:setText(LocalStrings.DEVOUR_WORDS)
		txtOperate2Type24:setText(LocalStrings.UNROYAL)
	elseif tData.userType == 4 then		--商店中的祈福
		btnOperate1:setVisible(false)
		btnOperate2:setVisible(true)
		btnOperate2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		txtOperate2Type24:setText(LocalStrings.BUY)
	elseif tData.userType == 5 then		--个人信息
		btnOperate1:setVisible(false)
		btnOperate2:setVisible(false)
		GetElement(self.m_root,"conOuside_WndTips",WZUIContainer):setShowAll(false)
		WndTips.m_root:setShowAll(false)
		GetElement(self.m_root,"imgThirdLine_conType24",WZUIImage):setVisible(false)
		conExp_conType24:setVisible(false)
		GetElement(self.m_root,"bgType24",WZUI9Image):setScaleY(0.6)
	elseif tData.userType == 6 then 	--融合界面
		btnOperate1:setVisible(false)
		local conType24_WndTips = GetElement(self.m_root, "conType24_WndTips", WZUIContainer)
		
		if not tData.bHaveBtn then
			conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,200))
			btnOperate2:setVisible(false)
			GetElement(self.m_root,"imgThirdLine_conType24",WZUIImage):setVisible(false)
			GetElement(self.m_root, "conProperty_WndTips24", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.19))
		else
			conType24_WndTips:setAbsContentSize(GlobalMethod:CCSize(320,300))
			btnOperate2:setVisible(true)
			btnOperate2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			txtOperate2Type24:setText(LocalStrings.GOTO_BLESS)
			GetElement(self.m_root,"imgThirdLine_conType24",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5, 0.3))
			GetElement(self.m_root, "conProperty_WndTips24", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.44))
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
				ProjConfig.LANGUAGE == "es" then
				txtOperate2Type24:setScale(0.8)
			elseif ProjConfig.LANGUAGE == "tr" then
				txtOperate2Type24:setScale(0.8)
				txtOperate2Type24:setDimensions(GlobalMethod:CCSize(110,0))
			end
		end
		conType24_WndTips:setRelativeSize(GlobalMethod:CCSize(1,0.5))
		conType24_WndTips:updateRelativeSize()
		
		conExp_conType24:setVisible(false)
	elseif tData.userType == 7 then 	--萃取
		btnOperate1:setVisible(false)
		btnOperate2:setVisible(true)
		btnOperate2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		txtOperate2Type24:setText(LocalStrings.EXTRACTION_TEXT1)
	end

    TeachGroup1:endTeachStep({42,7})

    if CacheCenter:getPlayerInfo().level == 24 then
        TeachGroup1:startGroup({42,8,self.m_root})
    end

end

--@brief 	战队Tips
function WndTips:_update26()
	--WZLog("WndTips:_update26",Serialize(self.m_tData))
	local tData = self.m_tData
	GetElement(self.m_root, "imgMvpType25" , WZUIImage):setVisible(false)
	--服务器名
	GetElement(self.m_root, "label4Type25_WndTips", WZUILabelTTF):setText(CacheCenter:getServerNameByServerId(tData.serviceName))
	--战队id
	local label5Type25 = GetElement(self.m_root, "label5Type25_WndTips", WZUILabelTTF)
	label5Type25:setText(tData.teamId)

	--战队名
	GetElement(self.m_root, "label3Type25_WndTips", WZUILabelTTF):setText(tData.teamName)
	--宣言
	GetElement(self.m_root, "label6Type25_WndTips", WZUILabelTTF):setText(tData.declaration)
	--头像
	for i=1,#tData.playerId do
		GetElement(self.m_root, "btnHead"..i.."Type25_WndTips", WZUIButton):setVisible(true)
		local conHead = GetElement(self.m_root,"conHead"..i.."Type25_WndTips",WZUIContainer)
		local imgHead = CellHead:show(conHead,tData.headId[i],tData.faceId[i],tData.sex[i],false,GlobalMethod:ccp(0.5,0.29),nil,tData.headColor[i])
		imgHead:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		imgHead:setScale(1.1)	
		--mvp
		if tData.playerId[i] == tData.mvp then
			GetElement(self.m_root, "imgMvpType25" , WZUIImage):setVisible(true)
			GetElement(self.m_root, "imgMvpType25" , WZUIImage):setRelativePosition(GlobalMethod:ccp(0.22+(i-1)*0.23,0.26))
		end
	end
	--战队图标
	local con = GetElement(self.m_root,"conHeadType25",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if self.m_tData.photoURL ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(self.m_tData.photoURL, tCell, nil, 52)
	end
	if ProjConfig.LANGUAGE == "vn" then
		label5Type25:setRelativePosition(GlobalMethod:ccp(0.56,0.41))
	elseif ProjConfig.LANGUAGE == "es" then
		label5Type25:setRelativePosition(GlobalMethod:ccp(0.7,0.41))
	end
end

--@brief 	排位赛属性
function WndTips:_update27()
	local tData = self.m_tData
	WZLog("WndTips:_update27", Serialize(self.m_tData))
	local attrType = 1
	if self.m_tData ~= nil and self.m_tData.attrType ~= nil then
		attrType = self.m_tData.attrType
	end

	local tProTitle = {LocalStrings.RANK_FIGHT_PRO, LocalStrings.JUEDITIPS9, LocalStrings.JUEDITIPS1, LocalStrings.JUEDITIPS5, "", LocalStrings.JUEDITIPS15, LocalStrings.JUEDITIPS13, LocalStrings.JUEDITIPS3, LocalStrings.JUEDITIPS11, LocalStrings.JUEDITIPS7}
	local tProDesc = {LocalStrings.RANK_FIGHT_PRO_DESC, LocalStrings.JUEDITIPS10, LocalStrings.JUEDITIPS2, LocalStrings.JUEDITIPS6, "", LocalStrings.JUEDITIPS16, LocalStrings.JUEDITIPS14, LocalStrings.JUEDITIPS4, LocalStrings.JUEDITIPS12, LocalStrings.JUEDITIPS8}
	GetElement(self.m_root,"title1",WZUILabelTTF):setText(tProTitle[attrType])
	GetElement(self.m_root,"title2",WZUILabelTTF):setText(tProDesc[attrType])

	local playerInfo = CacheCenter:getPlayerInfo()
	--职业的天赋属性加成
	local professionInfo = CacheCenter:getProfessionData()
	local professionAddHp = 0
	local professionAddAttack = 0
	if professionInfo ~= nil and professionInfo["talentSkill"] ~= nil and professionInfo["professionId"] ~= nil then
		local professionId = professionInfo["professionId"]
		--节点为3的职业技能为基本属性
		local talentSkill = professionInfo["talentSkill"]
		if talentSkill[3] ~= nil then
			for k, value in pairs(GDatatab_mage_Skill) do
				if talentSkill[3] == value.id then
					if professionId == 1 then
						professionAddHp = tonumber(value.attribute[1][2])
					elseif professionId == 2 then
						professionAddAttack = tonumber(value.attribute[1][2])
					elseif professionId == 3 then
						professionAddHp = tonumber(value.attribute[1][2])
						professionAddAttack = tonumber(value.attribute[2][2])
					end
					break 
				end
			end
		end
		--二转
		local secondRoleTalentSkill = professionInfo["secondRoleTalentSkill"]
		if secondRoleTalentSkill[1] ~= nil then
			for k, value in pairs(GDatatab_mage_Skill) do
				if secondRoleTalentSkill[1] == value.id then
					if professionId == 1 then
						professionAddHp = professionAddHp + tonumber(value.attribute[1][2])
					elseif professionId == 2 then
						professionAddAttack = professionAddAttack + tonumber(value.attribute[1][2])
					elseif professionId == 3 then
						professionAddHp = professionAddHp + tonumber(value.attribute[1][2])
						professionAddAttack = professionAddAttack + tonumber(value.attribute[2][2])
					end
					break 
				end
			end
		end
	end
	
	if playerInfo == nil then return end
	GetElement(self.m_root,"conType26_WndTips",WZUIContainer):setVisible(true)
	local proStr = {
		LocalStrings.HEALTH,LocalStrings.ATTACK,LocalStrings.DEFENSE,LocalStrings.CRIT, LocalStrings.FREESTORM,
		LocalStrings.TIZHI,LocalStrings.POWER,LocalStrings.PRACTICE_ARMOR, LocalStrings.AGILITY,
		LocalStrings.LUCKY,LocalStrings.ANTIBREAKING,LocalStrings.AVOIDINJURY,LocalStrings.RANGE }
	local pro = {
		playerInfo.hp - professionAddHp, playerInfo.attack - professionAddAttack,playerInfo.defend,playerInfo.critRate,playerInfo.reduceCrit,
		playerInfo.physique,playerInfo.force,playerInfo.armor,playerInfo.agility,
		playerInfo.luck,playerInfo.wreckDefense,playerInfo.injuryFree,playerInfo.range}

	for i = 1, 13 do
		local text = [[<T C="127,70,26" S="22" P="0">%s:</T><T C="127,70,26" S="22" P="0">%d</T>]]
		local str
		if i <= 12 then
			local tTable = GDatatab_battle_attribute["id_"..(i+(attrType-1)*12)]
			local basePro = pro[i]*tTable.zs_property/100
			local addPro = tTable.property[1][2]
			local allPro = basePro + addPro
			if i == 1 then
				allPro = allPro + professionAddHp
			elseif i == 2 then
				allPro = allPro + professionAddAttack
			end
			str = string.format(text,proStr[i], allPro)
		else
			str = string.format(text,proStr[i],pro[i])
		end
		local ftb = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
		ftb:setShowText(str)
	end
	if ProjConfig.LANGUAGE == "pt" then
		for i = 1, 13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.8)
		end
		GetElement(self.m_root,"title1",WZUILabelTTF):setScale(0.65)
		local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
		title2:setScale(0.7)
		title2:setDimensions(GlobalMethod:CCSize(400,0))
	elseif ProjConfig.LANGUAGE == "vn" then
		for i = 1, 13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.8)
		end
		local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
		title2:setScale(0.7)
		title2:setDimensions(GlobalMethod:CCSize(400,0))
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" then
		--GetElement(self.m_root,"txt1_WndTips26",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.966589))
		for i = 1, 13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.7)
		end
		GetElement(self.m_root,"title1",WZUILabelTTF):setScale(0.65)
		local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
		title2:setScale(0.7)
		title2:setDimensions(GlobalMethod:CCSize(370,0))
	elseif ProjConfig.LANGUAGE == "es" then
		for i = 1, 13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.7)
		end
		GetElement(self.m_root,"title1",WZUILabelTTF):setScale(0.65)
		local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
		title2:setScale(0.7)
		title2:setDimensions(GlobalMethod:CCSize(400,0))
	elseif ProjConfig.LANGUAGE == "tr" then
		for i = 1, 13 do
			GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.7)
		end
	elseif ProjConfig.LANGUAGE == "ug" then
		for i = 1, 13 do
			local attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
			attrInfo:setScale(0.65)
			attrInfo:setMaxWidth(220)

			local text = [[<T C="255,236,193" S="22" P="0">%d</T><T C="255,227,116" S="22" P="0">%s:</T>]]
			local str
			if i <= 12 then
				local tTable = GDatatab_battle_attribute["id_"..(i+(attrType-1)*12)]
				local basePro = pro[i]*tTable.zs_property/100
				local addPro = tTable.property[1][2]
				local allPro = basePro + addPro
				str = string.format(text,allPro,proStr[i])
			else
				str = string.format(text,pro[i],proStr[i])
			end
			attrInfo:setShowText(str)
		end
		GetElement(self.m_root,"attrInfo1",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.85))
		GetElement(self.m_root,"attrInfo2",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.75))
		GetElement(self.m_root,"attrInfo3",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.65))
		GetElement(self.m_root,"attrInfo4",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.55))
		GetElement(self.m_root,"attrInfo5",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.45))
		GetElement(self.m_root,"attrInfo6",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.35))
		GetElement(self.m_root,"attrInfo7",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03,0.25))
		GetElement(self.m_root,"attrInfo8",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.85))
		GetElement(self.m_root,"attrInfo9",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.75))
		GetElement(self.m_root,"attrInfo10",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.65))
		GetElement(self.m_root,"attrInfo11",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.55))
		GetElement(self.m_root,"attrInfo12",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.45))
		GetElement(self.m_root,"attrInfo13",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.53,0.35))

		local title1 = GetElement(self.m_root,"title1",WZUILabelTTF)
		title1:setScale(0.7)
		title1:setRelativePosition(GlobalMethod:ccp(0.07,0.966589))
		title1:setDimensions(GlobalMethod:CCSize(400))
		local title2 = GetElement(self.m_root,"title2",WZUILabelTTF)
		title2:setScale(0.6)
		title2:setRelativePosition(GlobalMethod:ccp(0.1,0.18))
		title2:setDimensions(GlobalMethod:CCSize(440))
	end
end

--@brief 	修炼tips
function WndTips:_update28()
	WZLog("WndTips:_update28")
	local tData = self.m_tData
	if tData == nil then return end

	--图标
	GetElement(self.m_root,"imgTips27Icon_WndTips",WZUIImage):setFile(tData.icon)
	--等级
	GetElement(self.m_root,"txtTips27Lv_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.level.." "..tData.name)
	--属性名
	GetElement(self.m_root,"txtTips27Desc2_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.attrId])
	--属性值
	GetElement(self.m_root,"txtTips27Desc3_WndTips",WZUILabelTTF):setText(tData.attrValue)
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"txtTips27Desc3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	elseif ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"txtTips27Desc3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.5))
	end
	if ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"txtTips27Desc3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.31,0.5))
	end
	--经验条
	GetElement(self.m_root,"proTips27_WndTips",WZUIProgress):setPercentage(tData.exp/tData.totalExp*100)
	GetElement(self.m_root,"txtTips27Exp_WndTips",WZUILabelTTF):setText(tData.exp.."/"..tData.totalExp)
end

--@brief 	竞技场积分说明tips
function WndTips:_update29()
	WZLog("WndTips:_update29")
	local tData = self.m_tData
	if tData == nil then return end

end

--@brief 	公会战已加入战队成员tips
function WndTips:_update30()
	-- body
	WZLog("WndTips:_update30")
	local tData = self.m_tData
	if tData == nil then return end 

	--等级
	local txtLevel = GetElement(self.m_root, "txtLevel_WndTips29", WZUILabelTTF)
	if txtLevel then
		txtLevel:setText("Lv " .. tData.level)
	end
	--名字
	local txtName = GetElement(self.m_root, "txtName_WndTips29", WZUILabelTTF)
	if txtName then
		txtName:setText(tData.name)
	end
	--战斗力
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips29", WZUILabelAtlasFont)
	if txtFighting then
		txtFighting:setText(tData.fighting)
	end
	--头像
	local conHead = GetElement(self.m_root, "conHead_WndTips29", WZUIContainer)
	if conHead then
		local element = CellHead:show(conHead,tData.headId, tData.faceId, tData.sex, nil, nil, tData.vipLevel, tData.headColor)
		element:setScale(1.18)
	end
	--所在队伍id
	local txtTeamId = GetElement(self.m_root, "txtTeamId_WndTips29", WZUILabelAtlasFont)
	if txtTeamId and tData.teamId ~= 0 then
		txtTeamId:setText(tData.teamId)
	end
	--取消参战
	local txtOperate1Type29 = GetElement(self.m_root, "txtOperate1Type29_WndTips", WZUILabelTTF)
	if txtOperate1Type29 then
		txtOperate1Type29:setText(LocalStrings.COMMYNITY_COMPETE_TEXT35)
	end
	--查看信息
	local txtOperate2Type29 = GetElement(self.m_root, "txtOperate2Type29_WndTips", WZUILabelTTF)
	if txtOperate2Type29 then
		txtOperate2Type29:setText(LocalStrings.COMMUNITY_COMPETE_TEXT30)
	end
	if ProjConfig.LANGUAGE == "vn" then
		txtOperate1Type29:setScale(0.8)
		txtOperate2Type29:setScale(0.8)
	end
	--按钮
	local btnOperate1 = GetElement(self.m_root, "btnOperate1_WndTips29", WZUIButton)
	local btnOperate2 = GetElement(self.m_root, "btnOperate2_WndTips29", WZUIButton)
	if tData.teamId ~= 0 then
		if tonumber(CacheCenter:getPlayerInfo().position) == COMMUNITY_PRESIDENT or CacheCenter:getPlayerInfo().id == SceneCommunityKnockout.m_nAdmin then
			btnOperate1:setVisible(true)
			btnOperate2:setVisible(true)
		else
			btnOperate1:setVisible(false)
			btnOperate2:setVisible(true)
			btnOperate2:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			local conType29 = GetElement(self.m_root, "conType29_WndTips", WZUIContainer)
			if conType29 then
				conType29:setAbsContentSize(GlobalMethod:CCSize(277,200))
				conType29:updateRelativeSize()
			end
			local conBottom = GetElement(self.m_root, "conBottom_WndTips29", WZUIContainer)
			if conBottom then
				conBottom:setAbsContentSize(GlobalMethod:CCSize(277,95))
				conBottom:updateRelativeSize()
			end
		end
	end
end

function WndTips:_update31()
	WZLog("WndTips:_update31")
	local tData = self.m_tData
	if tData == nil then return end 
	local con = GetElement(self.m_root,"conType30_WndTips",WZUIContainer)
	local count = #self.m_tData[1]

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAnchorPoint(ccp(0.5,1))
    element:setRelativePosition(ccp(0.5,1))
	element:setAbsContentSize(GlobalMethod:CCSize(290,80*count))
	con:addChild(element)

	local imgNor = WZUI9Image:create()
	imgNor:setFile("ui/common/common_scale9_di24.png")
	element:addChild(imgNor)

	for i=1,count do
		local name = WZUILabelTTF:create()
		name:setText(self.m_tData[1][i])
        name:setAnchorPoint(ccp(0,0.5))
        name:setRelativePosition(ccp(0.01,1.7-i))
        name:setColor(ccc3(127,70,26))
        name:setFontSize(22)
        name:setAlignment(kCCTextAlignmentLeft)
        con:addChild(name,100)

		local value = WZUILabelTTF:create()
		value:setText(self.m_tData[2][i])
        value:setAnchorPoint(ccp(0,0.5))
        value:setRelativePosition(ccp(0.01,1.3-i))
        value:setColor(ccc3(127,70,26))
        value:setFontSize(22)
        value:setAlignment(kCCTextAlignmentLeft)
        con:addChild(value,100)

        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "vn" then
			name:setFontSize(16)
			value:setFontSize(16)
		end
	end
end
--@brief 竞技卡加成
function WndTips:_update32()
	WZLog("WndTips:_update32")
	local conView = GetElement(self.m_root,"conViewType32_WndTips",WZUIContainer)
	local data = CacheCenter:getArenaAddInfo()
	local labStartY = 0
	local maxWidth = 0
	local strConfig = CacheCenter:getGameParam().integralreward
	local tCount, tValue = SplitItemString(strConfig)
	local nMaxCount = 0
	for i = 1, #tCount do
		if tonumber(tCount[i]) > nMaxCount then 
			nMaxCount = tonumber(tCount[i])
		end
	end
	for i=1,#data.addValue do
		local addType = data.timeType[i]
		local nameStr,leftStr,addStr = "","",""
		if addType == 0 then
			nameStr = LocalStrings.ARENA_CARD_TIME_TITLE
			leftStr = string.format(LocalStrings.ARENA_CARD_TIME_LEFT,data.timeValue[i])
			addStr = string.format(LocalStrings.ARENA_CARD_ADD_PREC,data.addValue[i])
		elseif addType == 2 then
			nameStr = LocalStrings.PVP_CARD_TIME_TITLE
			leftStr = string.format(LocalStrings.ARENA_CARD_TIME_LEFT,data.timeValue[i]) .. "/" .. tostring(nMaxCount)
			addStr = string.format(LocalStrings.PVP_CARD_ADD_PREC,data.addValue[i])
		elseif addType == 3 then
			nameStr = LocalStrings.RETURNEE_TEXT15
			addStr = string.format(LocalStrings.RETURNEE_TEXT30,data.addValue[i])
			local time = data.timeValue[i]
			if time > 1440 then
				local day = math.floor(time/1440)
				local hour = math.floor((time - 1440*day)/60)
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT,day,hour)
			elseif time > 60 then
				local hour = math.floor(time/60)
				local min = time - 60*hour
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT2,hour,min)
			else
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT3,time)
			end
		elseif addType == 4 then
			nameStr = LocalStrings.ARENA_CARD_ADD
			addStr = string.format(LocalStrings.RETURNEE_TEXT31,data.addValue[i])
			local time = data.timeValue[i]
			if time > 1440 then
				local day = math.floor(time/1440)
				local hour = math.floor((time - 1440*day)/60)
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT,day,hour)
			elseif time > 60 then
				local hour = math.floor(time/60)
				local min = time - 60*hour
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT2,hour,min)
			else
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT3,time)
			end
		else
			local time = data.timeValue[i]
			if time > 1440 then
				local day = math.floor(time/1440)
				local hour = math.floor((time - 1440*day)/60)
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT,day,hour)
			elseif time > 60 then
				local hour = math.floor(time/60)
				local min = time - 60*hour
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT2,hour,min)
			else
				leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT3,time)
			end
			nameStr = LocalStrings.ARENA_CARD_DAY_TITLE
			-- leftStr = string.format(LocalStrings.ARENA_CARD_DAY_LEFT,math.ceil(data.timeValue[i]/1440))
			addStr = string.format(LocalStrings.ARENA_CARD_ADD_PREC,data.addValue[i])
		end

		local value = WZUILabelTTF:create()
		value:setText(addStr)
		value:setUseAbsCoordinate(true)
        value:setAnchorPoint(ccp(0,0.5))
        value:setColor(ccc3(127,70,26))
        value:setFontSize(22)
        value:setAlignment(kCCTextAlignmentLeft)
        conView:addChild(value,100)
        
        local size = value:getLabelContentSize()
        labStartY = labStartY + 20 + size.height
        if maxWidth < size.width then
        	maxWidth = size.width 
        end
        value:setAbsPosition(ccp(20,labStartY))

        local leftVal = WZUILabelTTF:create()
		leftVal:setText(leftStr)
		leftVal:setUseAbsCoordinate(true)
        leftVal:setAnchorPoint(ccp(0,0.5))
        leftVal:setColor(ccc3(127,70,26))
        leftVal:setFontSize(22)
        leftVal:setAlignment(kCCTextAlignmentLeft)
        conView:addChild(leftVal,100)
        local size = leftVal:getLabelContentSize()
        labStartY = labStartY + 5 + size.height
        if maxWidth < size.width then
        	maxWidth = size.width 
        end
        leftVal:setAbsPosition(ccp(20,labStartY))

        local name = WZUILabelTTF:create()
		name:setText(nameStr)
		name:setUseAbsCoordinate(true)
        name:setAnchorPoint(ccp(0,0.5))
        name:setColor(ccc3(99,255,95))
        name:setFontSize(22)
        name:setEnableStroke(true)
		name:setStrokeColor(ccc3(132,66,29))
		name:setStrokeSize(4)
        name:setAlignment(kCCTextAlignmentLeft)
        conView:addChild(name,100)

        local size = name:getLabelContentSize()
        labStartY = labStartY + 5 + size.height
        if maxWidth < size.width then
        	maxWidth = size.width 
        end
        name:setAbsPosition(ccp(20,labStartY))
	end

	labStartY = labStartY + 40
	maxWidth = maxWidth + 40
	local imgBg = WZUI9Image:create()
	imgBg:setFile("ui/common/common_scale9_di24.png")
	local con = WZUIContainer:create()
	con:setUseAbsCoordinate(true)
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(maxWidth,labStartY))
	con:addChild(imgBg)
	con:setAbsPosition(ccp(maxWidth/2,labStartY/2))
	GetElement(self.m_root,"conBgType32_WndTips",WZUIContainer):addChild(con)
	if ProjConfig.LANGUAGE == "es" then
		conView:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
		conView:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
	end
end

--@brief 铭文tip
function WndTips:_update33()
	WZLog("WndTips:_update33")
	local tData = self.m_tData
	if tData == nil then return end 
	local getElement = GetElement
	--铭文图片
	getElement(self.m_root,"imgType33_WndTips",WZUIImage):setFile(tData["img"])
	--名字等级
	getElement(self.m_root,"txtTitle_WndTips33",WZUILabelTTF):setText(tData["title"])
	--说明
	getElement(self.m_root,"txt_WndTips33",WZUILabelTTF):setText(tData["text"])
	--属性名
	for i=1,6 do
		getElement(self.m_root,"txt".. i .."Type33_WndTips",WZUILabelTTF):setText(tData["attrTitle"..i])
		getElement(self.m_root,"txt".. (i+6) .."Type33_WndTips",WZUILabelTTF):setText(tData["attrVal"..i])
	end
end

--@brief 铭文tip
function WndTips:_update34()
	WZLog("WndTips:_update34")
	local tData = self.m_tData
	if tData == nil then return end 
	local getElement = GetElement
	--铭文图片
	getElement(self.m_root,"imgType34_WndTips",WZUIImage):setFile(tData["img"])
	--名字等级
	getElement(self.m_root,"txtTitle_WndTips34",WZUILabelTTF):setText(tData["title"])
	--说明
	getElement(self.m_root,"txt_WndTips34",WZUILabelTTF):setText(tData["text"])
	getElement(self.m_root,"txt_WndTips34",WZUILabelTTF):setColor(tData.txtColor)
	if tData.status <= 0 then
		getElement(self.m_root,"txtNotOpen_WndTips34",WZUILabelTTF):setVisible(true)
	else
		getElement(self.m_root,"txtNotOpen_WndTips34",WZUILabelTTF):setVisible(false)
	end
	--属性名
	for i=1,3 do
		getElement(self.m_root,"txt"..i.."Type34_WndTips",WZUILabelTTF):setText(tData["attrTitle"..i])
		getElement(self.m_root,"txt"..(i+3).."Type34_WndTips",WZUILabelTTF):setText(tData["attrVal"..i])
	end
	if ProjConfig.LANGUAGE == "es" then
		local txtNotOpen = GetElement(self.m_root,"txtNotOpen_WndTips34",WZUILabelTTF)
		txtNotOpen:setScale(0.8)
		txtNotOpen:setDimensions(GlobalMethod:CCSize(80))
		GetElement(self.m_root,"txt_WndTips34",WZUILabelTTF):setScale(0.8)
	end
	if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		local txtNotOpen = GetElement(self.m_root,"txtNotOpen_WndTips34",WZUILabelTTF)
		txtNotOpen:setScale(0.8)
		txtNotOpen:setDimensions(GlobalMethod:CCSize(80))
		GetElement(self.m_root,"txt_WndTips34",WZUILabelTTF):setScale(0.8)
	end
end

--@brief 购买铭文tip
function WndTips:_update35()
	WZLog("WndTips:_update35")
	local tData = self.m_tData
	if tData == nil then return end 
	--铭文图片
	GetElement(self.m_root,"imgType35_WndTips",WZUIImage):setFile(tData["img"])
	--名字等级
	GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF):setText(tData["title"])
	GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF):setColor(tData.txtColor)
	--数量
	GetElement(self.m_root,"txtNumType35_WndTips",WZUILabelTTF):setText("X "..tData.num)
	--属性名
	for i=1,3 do
		GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF):setText(tData["attrTitle"..i])
		if tData["attrVal"..i] ~= "" then
			GetElement(self.m_root,"txt"..(i+3).."Type35_WndTips",WZUILabelTTF):setText("+"..tData["attrVal"..i])
		end
	end
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF):setScale(0.8)
		for i=1,3 do
			local txt = GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF)
			txt:setRelativePosition(GlobalMethod:ccp(0.41,0.74-i*0.12))
			txt:setScale(0.8)	
		end
		for i=4,6 do
			local txt = GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF)
			txt:setRelativePosition(GlobalMethod:ccp(0.745,0.74-(i-3)*0.12))
			txt:setScale(0.8)	
		end	
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
		for i=1,3 do
			local txt = GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF)
			txt:setRelativePosition(GlobalMethod:ccp(0.42,0.74-i*0.12))
			txt:setScale(0.7)	
		end
	elseif ProjConfig.LANGUAGE == "es" then
		local txtTitle  = GetElement(self.m_root,"txtTitle_WndTips35",WZUILabelTTF)
		txtTitle:setScale(0.8)
		txtTitle:setDimensions(GlobalMethod:CCSize(200,0))
		for i=1,3 do
			local txt = GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF)
			txt:setRelativePosition(GlobalMethod:ccp(0.41,0.74-i*0.12))
			txt:setScale(0.7)	
		end
		for i=4,6 do
			local txt = GetElement(self.m_root,"txt"..i.."Type35_WndTips",WZUILabelTTF)
			txt:setRelativePosition(GlobalMethod:ccp(0.795,0.74-(i-3)*0.12))
			txt:setScale(0.7)	
		end	
	end
end

--@brief	皮肤技能tip
function WndTips:_update36()
	WZLog("WndTips:_update36")
	local tData = self.m_tData
	if tData == nil then return end 

	--被动技能按钮
	local skillId = tData.passive_skill[1][1]
	local tSkill = GDatatab_skill["id_"..skillId]
	
	if tSkill then
		GetElement(self.m_root,"txtTitle_WndTips36",WZUILabelTTF):setText(tSkill.name)
		GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF):setText(tSkill.tool_desc)
		GetElement(self.m_root,"imgSkillPg_WndTips36",WZUIImage):setFile(tSkill.icon)
		GetElement(self.m_root,"imgSkillL_WndTips36",WZUIImage):setFile(tSkill.lv_icon)
	end
	if tData.addAtt then 
		local txtAtt = createLabel(LocalStrings.MULCOPY_TEXT5,GlobalMethod:ccp(0.64,-0.22),GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(158,0,0))
		self.m_root:addChild(txtAtt)
	end

	if ProjConfig.LANGUAGE == "vn" then
		local conType36 = GetElement(self.m_root,"conType36_WndTips",WZUIContainer)
		conType36:setAbsContentSize(GlobalMethod:CCSize(430,260))
		conType36:updateRelativeSize()

		local conSkillBK = GetElement(self.m_root,"conSkillBK_WndTips36",WZUIContainer)
		conSkillBK:setRelativePosition(GlobalMethod:ccp(0.138,0.76))

		local txtTitle = GetElement(self.m_root,"txtTitle_WndTips36",WZUILabelTTF)
		txtTitle:setFontSize(16)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.24,0.89))
		local txt1Type35 = GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF)
		txt1Type35:setFontSize(16)
		txt1Type35:setDimensions(GlobalMethod:CCSize(310,0))
		txt1Type35:setRelativePosition(GlobalMethod:ccp(0.24,0.84))
	end
end

--@brief	幻力等级tip
function WndTips:_update37()
	WZLog("WndTips:_update37")
	local tData = self.m_tData
	if tData == nil then return end 

	local maxLevel = getMaxPhantomLevel()
	local nTempLevel = tData.lv
	if nTempLevel > maxLevel then 
		nTempLevel = maxLevel
	end
	local tPro = GDatatab_shape_level["id_"..nTempLevel]
	if tPro == nil then return end
	GetElement(self.m_root,"ttf1Type37_WndTips",WZUILabelTTF):setText(LocalStrings.PHANTOM3.." Lv"..tData.lv)
	if tPro.exp ~= -1 then 
		GetElement(self.m_root,"proTips37_WndTips",WZUIProgress):setPercentage(math.ceil(tData.exp/tPro.exp*100))
		GetElement(self.m_root,"txtTips37Exp_WndTips",WZUILabelTTF):setText(tData.exp.."/"..tPro.exp)
	else
		GetElement(self.m_root,"proTips37_WndTips",WZUIProgress):setPercentage(100)
		GetElement(self.m_root,"txtTips37Exp_WndTips",WZUILabelTTF):setText(LocalStrings.PROFESSION_TEXT15)
	end
	local tFight = {}
	for i=1,5 do
		if tPro.property[i] ~= nil then
			GetElement(self.m_root,"label"..(i*2-1).."Type37_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tPro.property[i][1]])
			GetElement(self.m_root,"label"..(i*2).."Type37_WndTips",WZUILabelTTF):setText("+"..tPro.property[i][2])
			tFight[tostring(tPro.property[i][1])] = tPro.property[i][2]
		end
	end
	local fightV = GlobalMethod:getCombatEffect(tFight)
	GetElement(self.m_root,"label12Type37_WndTips",WZUILabelTTF):setText(fightV)
	if ProjConfig.LANGUAGE == "th" then
		local txtTips37N = GetElement(self.m_root,"txtTips37N_WndTips",WZUILabelTTF)
		txtTips37N:setScale(0.7)
		txtTips37N:setRelativePosition(GlobalMethod:ccp(0.162143,0.46))
	elseif ProjConfig.LANGUAGE == "pt" then
		local txtTips37N = GetElement(self.m_root,"txtTips37N_WndTips",WZUILabelTTF)
		txtTips37N:setScale(0.8)
		txtTips37N:setDimensions(GlobalMethod:CCSize(80,0))
		txtTips37N:setRelativePosition(GlobalMethod:ccp(0.16,0.46))
	elseif ProjConfig.LANGUAGE == "es" then
		local txtTips37N = GetElement(self.m_root,"txtTips37N_WndTips",WZUILabelTTF)
		txtTips37N:setScale(0.7)
		txtTips37N:setDimensions(GlobalMethod:CCSize(100,0))
	elseif ProjConfig.LANGUAGE == "en" then
		local txtTips37N = GetElement(self.m_root,"txtTips37N_WndTips",WZUILabelTTF)
		txtTips37N:setScale(0.8)
		txtTips37N:setDimensions(GlobalMethod:CCSize(80,0))
		txtTips37N:setRelativePosition(GlobalMethod:ccp(0.16,0.46))
	elseif ProjConfig.LANGUAGE == "tr" then
		local txtTips37N = GetElement(self.m_root,"txtTips37N_WndTips",WZUILabelTTF)
		txtTips37N:setScale(0.7)
		txtTips37N:setDimensions(GlobalMethod:CCSize(110,0))
		txtTips37N:setRelativePosition(GlobalMethod:ccp(0.16,0.46))
	end
end

--@brief	幻力等级tip
function WndTips:_update38()
	WZLog("WndTips:_update38", Serialize(self.m_tData))
	local tData = self.m_tData
	if tData == nil then return end 

	local maxLevel = getMaxPhantomLevel()
	local nTempLevel = tData.lv
	if nTempLevel > maxLevel then 
		nTempLevel = maxLevel
	end
	local tPro = GDatatab_shape_level["id_"..nTempLevel]
	local tShape = GDatatab_shape_skins["id_"..tData.id]
	if ProjConfig.LANGUAGE == "vn" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setAlignment(kCCTextAlignmentCenter)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setScale(0.7)
		txtSkill:setDimensions(GlobalMethod:CCSize(210))
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.8)
		local txtSkillName = GetElement(self.m_root,"txtSkillName",WZUILabelTTF)
		txtSkillName:setScale(0.8)
		txtSkillName:setDimensions(GlobalMethod:CCSize(180,0))
		GetElement(self.m_root, "txtFight_WndTips38", WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))		
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setFontSize(18)
		txtSkill:setScale(0.65)
		txtSkill:setDimensions(GlobalMethod:CCSize(230))
		GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setScale(0.65)
		GetElement(self.m_root, "txtFight_WndTips38", WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "en" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))		
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setFontSize(18)
		txtSkill:setScale(0.65)
		txtSkill:setDimensions(GlobalMethod:CCSize(230))		
		
		GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root, "txtFight_WndTips38", WZUILabelTTF):setScale(0.7)
	end
	if tPro == nil then return end
	GetElement(self.m_root,"ttf1Type38_WndTips",WZUILabelTTF):setText(LocalStrings.PHANTOM3.." Lv"..tData.lv)
	--GetElement(self.m_root,"proTips37_WndTips",WZUIProgress):setPercentage(math.ceil(tData.exp/tPro.exp*100))
	--GetElement(self.m_root,"txtTips37Exp_WndTips",WZUILabelTTF):setText(tData.exp.."/"..tPro.exp)
	--加成战力
	local nFighting = WndCard:_caculateFighting(tPro.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips38", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	for i=1,5 do
		GetElement(self.m_root,"label"..(i*2-1).."Type38_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label"..(i*2).."Type38_WndTips",WZUILabelTTF):setVisible(false)
		if tPro.property[i] ~= nil then
			GetElement(self.m_root,"label"..(i*2-1).."Type38_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tPro.property[i][1]])
			GetElement(self.m_root,"label"..(i*2).."Type38_WndTips",WZUILabelTTF):setText("+"..tPro.property[i][2])
			GetElement(self.m_root,"label"..(i*2-1).."Type38_WndTips",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"label"..(i*2).."Type38_WndTips",WZUILabelTTF):setVisible(true)
		end
	end

	if tShape ~= nil then 
		--头像
		GetElement(self.m_root,"imgHead",WZUIImage):setFile("battle/head/"..tShape.head..".png")
		--皮肤名
		GetElement(self.m_root,"txtName",WZUILabelTTF):setText(tShape.name)
		GetElement(self.m_root,"txtName",WZUILabelTTF):setColor(QUALITYCOLOR[tShape.quality])
		if tShape.head ~= nil then
			GetElement(self.m_root,"noUse",WZUILabelTTF):setVisible(false)
		end
	end
	--皮肤技能
	--local skillId = tShape.passive_skill[1][1]
	local skillId = tData.shapeSkillId
	local tSkill = GDatatab_skill["id_"..skillId]
	if tSkill then 
		GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setText(tSkill.name)
		GetElement(self.m_root,"txtSkill",WZUILabelTTF):setText(tSkill.tool_desc)
	end
	
end

--@brief	幻力等级tip
function WndTips:_update39()
	WZLog("WndTips:_update39", Serialize(self.m_tData))
	local tData = self.m_tData
	if tData == nil then return end 

	local maxLevel = getMaxPhantomLevel()
	local nTempLevel = tData.lv
	if nTempLevel > maxLevel then 
		nTempLevel = maxLevel
	end
	local tPro = GDatatab_shape_level["id_"..nTempLevel]
	local tShape = GDatatab_shape_skins["id_"..tData.id]
	if ProjConfig.LANGUAGE == "vn" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setAlignment(kCCTextAlignmentCenter)
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setScale(0.6)
		txtSkill:setDimensions(GlobalMethod:CCSize(250))
		txtSkill:setRelativePosition(GlobalMethod:ccp(0.44,0.63))
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setFontSize(18)
		txtSkill:setScale(0.65)
		txtSkill:setDimensions(GlobalMethod:CCSize(230))
		
		-- GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setScale(0.65)
	elseif ProjConfig.LANGUAGE == "th" then
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.9)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setScale(0.8)
		txtSkill:setDimensions(GlobalMethod:CCSize(180))
	elseif ProjConfig.LANGUAGE == "en" then	
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))		
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setFontSize(18)
		txtSkill:setScale(0.65)
		txtSkill:setDimensions(GlobalMethod:CCSize(230))
	elseif  ProjConfig.LANGUAGE == "tr" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setScale(0.6)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))
	elseif  ProjConfig.LANGUAGE == "ug" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setScale(0.55)
		noUse:setRelativePosition(GlobalMethod:ccp(0.0875,0.5))
		GetElement(self.m_root,"label11Type38_WndTips",WZUILabelTTF):setScale(0.8)
	end
	if tPro == nil then return end
	GetElement(self.m_root,"ttf1Type38_WndTips",WZUILabelTTF):setText(LocalStrings.PHANTOM3.." Lv"..tData.lv)
	if tPro == nil or tShape == nil then return end

	--头像
	GetElement(self.m_root,"imgHead",WZUIImage):setFile("battle/head/"..tShape.head..".png")
	--皮肤名
	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(tShape.name)
	GetElement(self.m_root,"txtName",WZUILabelTTF):setColor(QUALITYCOLOR[tShape.quality])
	--皮肤技能
	--local skillId = tShape.passive_skill[1][1]
	local skillId = tData.shapeSkillId
	local tSkill = GDatatab_skill["id_"..skillId]
	GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setText(tSkill.name)
	GetElement(self.m_root,"txtSkill",WZUILabelTTF):setText(tSkill.tool_desc)
	if tShape.head ~= nil then
		GetElement(self.m_root,"noUse",WZUILabelTTF):setVisible(false)
	end
end

--@brief	觉醒tip
function WndTips:_update40()
	WZLog("WndTips:_update40")
	local tData = self.m_tData
	if tData == nil then return end 
	--tData.awakeSoulLevel = 0
	GetElement(self.m_root,"ttf2Type40_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.TIPS12,tData.awakeStep))
	GetElement(self.m_root,"ttf5Type40_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.awakeSoulLevel)

	for i=1,16 do
		GetElement(self.m_root,"label"..i.."Type40_WndTips",WZUILabelTTF):setText("")
	end

	if tData.awakeSoulLevel == 0 then
		GetElement(self.m_root,"bgType40",WZUI9Image):setScaleY(0.85)
		--阶数属性
		local tBase = GDatatab_awake_base["id_"..tData.awakeStep]
		--加成战力
		local nFighting = WndCard:_caculateFighting(tBase.property)
		local txtFighting = GetElement(self.m_root, "txtFighting_WndTips40", WZUILabelTTF)
		if txtFighting then 
			txtFighting:setVisible(true)
			txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
		end
		for i=1,3 do
			GetElement(self.m_root,"label"..(i*2-1).."Type40_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tBase.property[i][1]])
			GetElement(self.m_root,"label"..(i*2).."Type40_WndTips",WZUILabelTTF):setText(tBase.property[i][2])
		end
	else
		GetElement(self.m_root,"bgType40",WZUI9Image):setScaleY(1.35)
		local tBase = GDatatab_awake_base["id_"..tData.awakeStep]
		for i=1,3 do
			GetElement(self.m_root,"label"..(i*2-1).."Type40_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tBase.property[i][1]])
			GetElement(self.m_root,"label"..(i*2).."Type40_WndTips",WZUILabelTTF):setText(tBase.property[i][2])
		end
		--等级属性
		local tCrystal = GDatatab_awake_crystal["id_"..tData.awakeSoulLevel]
		--加成战力
		local nFighting = WndCard:_caculateFighting(tCrystal.add_property)
		local txtFighting = GetElement(self.m_root, "txtFighting_WndTips40", WZUILabelTTF)
		if txtFighting then 
			txtFighting:setVisible(true)
			txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
		end
		for i=1,5 do
			GetElement(self.m_root,"label"..(6+i*2-1).."Type40_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tCrystal.add_property[i][1]])
			GetElement(self.m_root,"label"..(6+i*2).."Type40_WndTips",WZUILabelTTF):setText(tCrystal.add_property[i][2])
		end
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtFight_WndTips40",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.58))
	end
	--显示觉醒之技信息
	if tData.awakeStep == 4 then 
		local nTotalLevel = 1 
	    local nCtbValue = 0
	    local tAwakeSkillId = SplitStringWithSeparator(tData.awakeSkillId, "|", nil, true)
	    local sCostFormat = [[<T C="127,70,26" S="18" P="1" SC="79,60,48" SE="0" SS="4">%s</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="0" SS="4">%.1f</T>]]
	    local tBasicData = CellWakeupDetail:getSubSkillData(tAwakeSkillId[1])
	    local tEffectData = GDatatab_effect["id_" .. tBasicData.effect_id[1][1]]
	    
        local txtSubSkill1 = GetElement(self.m_root, "txtSubSkill1_WndTips40", WZUIFreeTextBox)
        local txtSubSkill2 = GetElement(self.m_root, "txtSubSkill2_WndTips40", WZUIFreeTextBox)
        local txtSubSkill3 = GetElement(self.m_root, "txtSubSkill3_WndTips40", WZUIFreeTextBox)

        local sFormatValue = LocalStrings.WAKEUP_TEXT42[1] .. ":"
        txtSubSkill1:setShowText(string.format(sCostFormat, sFormatValue, tBasicData.start_time/1000))
        sFormatValue = LocalStrings.WAKEUP_TEXT42[2] .. ":"
        txtSubSkill2:setShowText(string.format(sCostFormat, sFormatValue, tBasicData.cooling_time/1000))
        sFormatValue = LocalStrings.WAKEUP_TEXT42[3] .. ":"
        txtSubSkill3:setShowText(string.format(sCostFormat, sFormatValue, tEffectData.effect[1][5]/1000))

	    local txtSkillName = GetElement(self.m_root, "txtSkillName_WndTips40", WZUILabelTTF)
	    txtSkillName:setText(LocalStrings.WAKEUP_TEXT39 .. "Lv." .. tBasicData.specialAttackParam)
	    local txtCtbTips = GetElement(self.m_root, "txtCtbTips_WndTips40", WZUILabelTTF)
	    txtCtbTips:setText(string.format(LocalStrings.WAKEUP_TEXT40, tEffectData.effect[1][5]/1000))

	    local conForSkillInfo = GetElement(self.m_root, "conForSkillInfo_WndTips40", WZUIContainer)
	    conForSkillInfo:setVisible(true)
	    if tData.awakeSoulLevel == 0 then 
	    	GetElement(self.m_root,"bgType40",WZUI9Image):setScaleY(1.5)
	    	conForSkillInfo:setRelativePosition(GlobalMethod:ccp(0.5,0.15))
	    else
	    	GetElement(self.m_root,"bgType40",WZUI9Image):setScaleY(2)
	    	conForSkillInfo:setRelativePosition(GlobalMethod:ccp(0.5,-0.35))
	    end
	end

	if ProjConfig.LANGUAGE == "en" then
		local ttf3Type40 = GetElement(self.m_root,"ttf3Type40_WndTips",WZUILabelTTF)
		ttf3Type40:setScale(0.7)
		ttf3Type40:setRelativePosition(GlobalMethod:ccp(0.5566,0.89))
		local ttf2Type40 = GetElement(self.m_root,"ttf2Type40_WndTips",WZUILabelTTF)
		ttf2Type40:setScale(0.7)
		ttf2Type40:setRelativePosition(GlobalMethod:ccp(0.805472,0.89))
		local ttf4Type40 = GetElement(self.m_root,"ttf4Type40_WndTips",WZUILabelTTF)
		ttf4Type40:setScale(0.7)
		ttf4Type40:setRelativePosition(GlobalMethod:ccp(0.507547,0.78))
		local ttf5Type40 = GetElement(self.m_root,"ttf5Type40_WndTips",WZUILabelTTF)
		ttf5Type40:setScale(0.7)
		ttf5Type40:setRelativePosition(GlobalMethod:ccp(0.711132,0.78))
		for i=2,16,2 do
			GetElement(self.m_root,"label"..i.."Type40_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.42,0.56-i*0.05))
		end
		GetElement(self.m_root, "txtSubSkill1_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtSubSkill2_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtSubSkill3_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtCtbTips_WndTips40", WZUILabelTTF):setScale(0.8)
	elseif ProjConfig.LANGUAGE == "vn" then
		local ttf3Type40 = GetElement(self.m_root,"ttf3Type40_WndTips",WZUILabelTTF)
		ttf3Type40:setScale(0.7)
		GetElement(self.m_root,"txtFight_WndTips40",WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "hk" then
		GetElement(self.m_root, "txtCtbTips_WndTips40", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(250))
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		local ttf3Type40 = GetElement(self.m_root,"ttf3Type40_WndTips",WZUILabelTTF)
		ttf3Type40:setScale(0.6)
		ttf3Type40:setRelativePosition(GlobalMethod:ccp(0.526415,0.89))
		local ttf2Type40 = GetElement(self.m_root,"ttf2Type40_WndTips",WZUILabelTTF)
		ttf2Type40:setScale(0.6)
		ttf2Type40:setRelativePosition(GlobalMethod:ccp(0.756416,0.89))
		local ttf4Type40 = GetElement(self.m_root,"ttf4Type40_WndTips",WZUILabelTTF)
		ttf4Type40:setScale(0.6)
		ttf4Type40:setRelativePosition(GlobalMethod:ccp(0.503774,0.78))
		local ttf5Type40 = GetElement(self.m_root,"ttf5Type40_WndTips",WZUILabelTTF)
		ttf5Type40:setScale(0.6)
		ttf5Type40:setRelativePosition(GlobalMethod:ccp(0.703585,0.78))
		for i=2,16,2 do
			GetElement(self.m_root,"label"..i.."Type40_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.42,0.56-i*0.05))
		end
		local txtSubSkill1 = GetElement(self.m_root, "txtSubSkill1_WndTips40", WZUIFreeTextBox)
		local txtSubSkill2 = GetElement(self.m_root, "txtSubSkill2_WndTips40", WZUIFreeTextBox)
		local txtSubSkill3 = GetElement(self.m_root, "txtSubSkill3_WndTips40", WZUIFreeTextBox)
		txtSubSkill1:setScale(0.7)
		txtSubSkill1:setMaxWidth(220)
		txtSubSkill1:setRelativePosition(GlobalMethod:ccp(0.4,0.8))
		txtSubSkill2:setScale(0.7)
		txtSubSkill2:setMaxWidth(220)
		txtSubSkill2:setRelativePosition(GlobalMethod:ccp(0.4,0.68))
		txtSubSkill3:setScale(0.7)
		txtSubSkill3:setMaxWidth(220)
		txtSubSkill3:setRelativePosition(GlobalMethod:ccp(0.4,0.56))
		local txtCtbTips = GetElement(self.m_root, "txtCtbTips_WndTips40", WZUILabelTTF)
		txtCtbTips:setScale(0.7)
		txtCtbTips:setDimensions(GlobalMethod:CCSize(340))
	elseif ProjConfig.LANGUAGE == "tr" then
		local ttf3Type40 = GetElement(self.m_root,"ttf3Type40_WndTips",WZUILabelTTF)
		ttf3Type40:setScale(0.6)
		ttf3Type40:setDimensions(GlobalMethod:CCSize(180))
		ttf3Type40:setRelativePosition(GlobalMethod:ccp(0.526415,0.89))
		local ttf2Type40 = GetElement(self.m_root,"ttf2Type40_WndTips",WZUILabelTTF)
		ttf2Type40:setScale(0.6)
		ttf2Type40:setRelativePosition(GlobalMethod:ccp(0.756416,0.89))
		local ttf4Type40 = GetElement(self.m_root,"ttf4Type40_WndTips",WZUILabelTTF)
		ttf4Type40:setScale(0.6)
		ttf4Type40:setDimensions(GlobalMethod:CCSize(180))
		ttf4Type40:setRelativePosition(GlobalMethod:ccp(0.503774,0.78))
		local ttf5Type40 = GetElement(self.m_root,"ttf5Type40_WndTips",WZUILabelTTF)
		ttf5Type40:setScale(0.6)
		ttf5Type40:setRelativePosition(GlobalMethod:ccp(0.703585,0.78))
		for i=1,16,2 do
			GetElement(self.m_root,"label"..i.."Type40_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.56-(i+1)*0.05))
		end
		for i=2,16,2 do
			GetElement(self.m_root,"label"..i.."Type40_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.56-i*0.05))
		end
		GetElement(self.m_root, "txtSubSkill1_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtSubSkill2_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtSubSkill3_WndTips40", WZUIFreeTextBox):setScale(0.7)
		GetElement(self.m_root, "txtSubSkill3_WndTips40", WZUIFreeTextBox):setScale(0.7)
	end
end

--@brief	货币栏的tips
function WndTips:_update41()
	WZLog("WndTips:_update41")
	local tData = self.m_tData
	local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
	conType5:setVisible(true)
	conType5:setAbsContentSize(GlobalMethod:CCSize(275, 100))
	conType5:updateRelativeSize()

	local text1 = [[<T C="127,70,26" S="22" P="1">%s</T><BR></BR><T C="127,70,26" S="22" P="1">%s</T>]]

	local txt1Type5 = GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox)
	txt1Type5:setShowText(string.format(text1,tData.name, tData.desc))
	txt1Type5:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	txt1Type5:setRelativePosition(GlobalMethod:ccp(0.06, 0.5))
	
	GetElement(self.m_root,"txt3Type5_WndTips",WZUIFreeTextBox):setVisible(false)
end

--@brief	祈福总属性tips
function WndTips:_update42()
	WZLog("WndTips:_update42")
	local tData = self.m_tData
	local conTips28 = GetElement(self.m_root,"conTips28_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(340, 278))
	conTips28:updateRelativeSize()

	local txtTitle = WZUILabelTTF:create()
	txtTitle:setText(LocalStrings.BLESS_AAT_TITLE)
	txtTitle:setColor(GlobalMethod:ccc3(127,70,26))
	txtTitle:setFontSize(24)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.91))
	conTips28:addChild(txtTitle)

	--分割线
	local imgLine1 = WZUIImage:create()
	imgLine1:setFile("ui/common/common_scale9_fengexian.png")
	imgLine1:setUseOriginSize(true)
	imgLine1:setScaleX(1.5)
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
	conTips28:addChild(imgLine1)

	local text1 = [[<T C="127,70,26" S="22" >%s</T><T C="127,70,26" S="22" >%d</T>]]
	local ftxtFighting = WZUIFreeTextBox:create()
	ftxtFighting:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))
	ftxtFighting:setMaxWidth(500)
	ftxtFighting:setShowText(string.format(text1,LocalStrings.BLESS_FIGHTING, tData.fighting))
	conTips28:addChild(ftxtFighting)

	--分割线2
	local imgLine2 = WZUIImage:create()
	imgLine2:setFile("ui/common/common_scale9_fengexian.png")
	imgLine2:setUseOriginSize(true)
	imgLine2:setScaleX(1.5)
	imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.18))
	conTips28:addChild(imgLine2)


	local text2 = [[<T C="127,70,26" S="20" >%s:</T><T C="5,180,0" S="20" >%d</T>]]
	local pointX = 0.06
	local pointY = 0.78
	for i = 1, #tData.property/2 do
		local nIndex = (i - 1) * 2 + 1 
		local ftxtProperty1 = WZUIFreeTextBox:create()
		ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
		ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.108))
		ftxtProperty1:setMaxWidth(500)
		ftxtProperty1:setShowText(string.format(text2,ATTR_TITLE[tData.property[nIndex][1]], tData.property[nIndex][2]))
		conTips28:addChild(ftxtProperty1)

		local ftxtProperty2 = WZUIFreeTextBox:create()
		ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
		ftxtProperty2:setRelativePosition(GlobalMethod:ccp(pointX + 0.5, pointY - (i - 1) * 0.108))
		ftxtProperty2:setMaxWidth(500)
		ftxtProperty2:setShowText(string.format(text2,ATTR_TITLE[tData.property[nIndex + 1][1]], tData.property[nIndex + 1][2]))
		conTips28:addChild(ftxtProperty2)

		if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
			ftxtProperty1:setScale(0.7)
			ftxtProperty2:setScale(0.7)
		end
	end

end

--@brief	装备属性tips
function WndTips:_update43()
	WZLog("WndTips:_update43")
	local tData = self.m_tData
	if tData == nil then return end 

	local attrList = {}
	for i=1,20 do
		attrList[tostring(i)] = 0
	end
	--加上套装属性
	local itemSuitId = CacheCenter:getPlayerInfo().itemSuitId
	local itemSuitNum = CacheCenter:getPlayerInfo().itemSuitNum
	local itemSuitId2 = CacheCenter:getPlayerInfo().itemSuitId2
	local itemSuitNum2 = CacheCenter:getPlayerInfo().itemSuitNum2
	WZLog("WndTips:_update43?",itemSuitId,itemSuitNum,itemSuitId2,itemSuitNum2)
	if GDatatab_item_suit["id_"..itemSuitId] ~= nil and GDatatab_item_suit["id_"..itemSuitId]["suit_"..itemSuitNum] ~= nil then
		local suitAttr1 = GDatatab_item_suit["id_"..itemSuitId]["suit_"..itemSuitNum]
		for j=1,#suitAttr1 do
			if suitAttr1[j][2] ~= nil and suitAttr1[j][2] ~= 0 then
				WZLog("套装1属性",suitAttr1[j][1],suitAttr1[j][2])
				attrList[tostring(suitAttr1[j][1])] = attrList[tostring(suitAttr1[j][1])] + suitAttr1[j][2]
			end
		end
	end
	if GDatatab_item_suit["id_"..itemSuitId2] ~= nil and GDatatab_item_suit["id_"..itemSuitId2]["suit_"..itemSuitNum2] ~= nil then
		local suitAttr2 = GDatatab_item_suit["id_"..itemSuitId2]["suit_"..itemSuitNum2]
		for j=1,#suitAttr2 do
			if suitAttr2[j][2] ~= nil and suitAttr2[j][2] ~= 0 then
				WZLog("套装2属性",suitAttr2[j][1],suitAttr2[j][2])
				attrList[tostring(suitAttr2[j][1])] = attrList[tostring(suitAttr2[j][1])] + suitAttr2[j][2]
			end
		end
	end
	--加上装备属性
	local tEquipmentList = CacheCenter:getEquipedList()
	for j=1,#tEquipmentList do
		local extraInfo = tEquipmentList[j].extraInfo
		for i=1,20 do
			if extraInfo[tostring(i)] ~= nil and extraInfo[tostring(i)] ~= 0 then
				attrList[tostring(i)] = attrList[tostring(i)] + extraInfo[tostring(i)]
			end
		end
	end
	if attrList["2"] ~= 0 then
		attrList["1"] = attrList["1"] + attrList["2"]
		attrList["2"] = 0
	end

	local attrNum = 1
	for i=1,18 do
		GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setText("")
	end
	for i=1,20 do
		if attrList[tostring(i)] ~= nil and attrList[tostring(i)] ~= 0 then
				WZLog("sss",attrNum,ATTR_TITLE[i])
			GetElement(self.m_root,"label"..(attrNum*2-1).."Type43_WndTips",WZUILabelTTF):setText(ATTR_TITLE[i])
			GetElement(self.m_root,"label"..(attrNum*2).."Type43_WndTips",WZUILabelTTF):setText(attrList[tostring(i)])
			attrNum = attrNum + 1
			if attrNum > 9 then break end
		end
	end
	if ProjConfig.LANGUAGE == "es" then
		for i=1,18 do
			GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setScale(0.8)
		end
		for i = 1, 18, 2 do
			local label = GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF)
			label:setRelativePosition(GlobalMethod:ccp(0.3,0.83-i*0.05))
		end
	end
	local Y = (130 + (attrNum - 2)*30)
	local scaleY = Y/300
	--GetElement(self.m_root,"di",WZUI9Image):setScaleY(scaleY)
	local conTip = GetElement(self.m_root,"conType43_WndTips",WZUIContainer)
	conTip:setAbsContentSize(GlobalMethod:CCSize(240,Y))
	conTip:updateRelativeSize()
	WZLog("背景缩放",scaleY,Y)
	local labelFight2Type43 = GetElement(self.m_root,"labelFight2Type43_WndTips",WZUILabelTTF)
	labelFight2Type43:setText(GlobalMethod:getCombatEffect(attrList))
	
	if ProjConfig.LANGUAGE == "vn" then
		local labelFight1Type43 = GetElement(self.m_root,"labelFight1Type43_WndTips",WZUILabelTTF)
		labelFight1Type43:setRelativePosition(GlobalMethod:ccp(0.1,0.51))
		labelFight1Type43:setScale(0.8)
		local labelFight2Type43 = GetElement(self.m_root,"labelFight2Type43_WndTips",WZUILabelTTF)
		labelFight2Type43:setRelativePosition(GlobalMethod:ccp(0.65,0.51))
		labelFight2Type43:setScale(0.8)
	end
end

--@brief	家园tip
function WndTips:_update44()
	WZLog("WndTips:_update44")
	local tData = self.m_tData
	if tData == nil then return end 
	
	GetElement(self.m_root,"ttf3Type44_WndTips",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP8..":")
	GetElement(self.m_root,"ttf2Type44_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.homeLevel)
	GetElement(self.m_root,"ttf4Type44_WndTips",WZUILabelTTF):setText(LocalStrings.FAMILY_TEXT3..":")
	GetElement(self.m_root,"ttf5Type44_WndTips",WZUILabelTTF):setText(tData.sheerLuxury)

	for i=1,6 do
		GetElement(self.m_root,"label"..i.."Type44_WndTips",WZUILabelTTF):setText("")
	end

	local tBase = GDatatab_home_level_up["id_"..tData.homeLevel]
	--战力加成
	local nFighting = WndCard:_caculateFighting(tBase.attribute)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips44", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtFight_WndTips44",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.58))
	end
	for i=1,3 do
		GetElement(self.m_root,"label"..(i*2-1).."Type44_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tBase.attribute[i][1]])
		GetElement(self.m_root,"label"..(i*2).."Type44_WndTips",WZUILabelTTF):setText(tBase.attribute[i][2])
	end
	local tBase = GDatatab_home_level_up["id_"..tData.homeLevel]
	for i=1,3 do
		GetElement(self.m_root,"label"..(i*2-1).."Type44_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tBase.attribute[i][1]])
		GetElement(self.m_root,"label"..(i*2).."Type44_WndTips",WZUILabelTTF):setText(tBase.attribute[i][2])
	end

	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		local ttf3Type44 = GetElement(self.m_root,"ttf3Type44_WndTips",WZUILabelTTF)
		ttf3Type44:setScale(0.8)
		ttf3Type44:setRelativePosition(GlobalMethod:ccp(0.5,0.89))
		local ttf2Type44 = GetElement(self.m_root,"ttf2Type44_WndTips",WZUILabelTTF)
		ttf2Type44:setScale(0.8)
		ttf2Type44:setRelativePosition(GlobalMethod:ccp(0.7,0.89))
		local ttf4Type44 = GetElement(self.m_root,"ttf4Type44_WndTips",WZUILabelTTF)
		ttf4Type44:setScale(0.8)
		ttf4Type44:setRelativePosition(GlobalMethod:ccp(0.5,0.78))
		local ttf5Type44 = GetElement(self.m_root,"ttf5Type44_WndTips",WZUILabelTTF)
		ttf5Type44:setScale(0.8)
		ttf5Type44:setRelativePosition(GlobalMethod:ccp(0.7,0.78))
	elseif ProjConfig.LANGUAGE == "tr" then
		local ttf3Type44 = GetElement(self.m_root,"ttf3Type44_WndTips",WZUILabelTTF)
		ttf3Type44:setScale(0.7)
		ttf3Type44:setRelativePosition(GlobalMethod:ccp(0.51,0.89))
		local ttf2Type44 = GetElement(self.m_root,"ttf2Type44_WndTips",WZUILabelTTF)
		ttf2Type44:setScale(0.7)
		ttf2Type44:setRelativePosition(GlobalMethod:ccp(0.76,0.89))
		local ttf4Type44 = GetElement(self.m_root,"ttf4Type44_WndTips",WZUILabelTTF)
		ttf4Type44:setScale(0.7)
		ttf4Type44:setRelativePosition(GlobalMethod:ccp(0.42,0.78))
		local ttf5Type44 = GetElement(self.m_root,"ttf5Type44_WndTips",WZUILabelTTF)
		ttf5Type44:setScale(0.7)
		ttf5Type44:setRelativePosition(GlobalMethod:ccp(0.53,0.78))
	elseif ProjConfig.LANGUAGE == "en" then
		local ttf3Type44 = GetElement(self.m_root,"ttf3Type44_WndTips",WZUILabelTTF)
		ttf3Type44:setScale(0.8)
		ttf3Type44:setRelativePosition(GlobalMethod:ccp(0.5,0.89))
		local ttf2Type44 = GetElement(self.m_root,"ttf2Type44_WndTips",WZUILabelTTF)
		ttf2Type44:setScale(0.8)
		ttf2Type44:setRelativePosition(GlobalMethod:ccp(0.673396,0.89))
		local ttf4Type44 = GetElement(self.m_root,"ttf4Type44_WndTips",WZUILabelTTF)
		ttf4Type44:setScale(0.8)
		ttf4Type44:setRelativePosition(GlobalMethod:ccp(0.51,0.78))
		local ttf5Type44 = GetElement(self.m_root,"ttf5Type44_WndTips",WZUILabelTTF)
		ttf5Type44:setScale(0.8)
		ttf5Type44:setRelativePosition(GlobalMethod:ccp(0.69,0.78))
	elseif ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtFight_WndTips44",WZUILabelTTF):setScale(0.7)
	end
end

--@brief	觉醒之力天赋tips
function WndTips:_update45()
	--body
	WZLog("WndTips:_update45")
	local tData = GDatatab_talent_Skill["id_" .. self.m_tData.id]
	local conTips28 = GetElement(self.m_root,"conType10_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(320, 240))
	conTips28:updateRelativeSize()

	--
	local conTop = WZUIContainer:create()
	conTop:setUseAbsSize(true)
	conTop:setAbsContentSize(GlobalMethod:CCSize(280,95))
	conTop:setRelativePosition(GlobalMethod:ccp(0.5,1.08))
	self.m_root:addChild(conTop)

	--图标容器
	local conForIcon = WZUIContainer:create()
	conForIcon:setUseAbsSize(true)
	conForIcon:setAbsContentSize(GlobalMethod:CCSize(76,76))
	conForIcon:setRelativePosition(GlobalMethod:ccp(0.165,0.5))
	conTop:addChild(conForIcon)
	--图标框
	local imgRect = WZUIImage:create()
	imgRect:setFile("ui/common/common_icon_jinengkuang.png")
	conForIcon:addChild(imgRect)
	imgRect = WZUIImage:create()
	imgRect:setFile("ui/combat/common_icon_kdi.png")
	imgRect:setScale(0.85)
	conForIcon:addChild(imgRect)
	--图标
	imgRect = WZUIImage:create()
	imgRect:setUseOriginSize(true)
	imgRect:setFile(tData.icon)
	conForIcon:addChild(imgRect)
	--等级
	imgRect = WZUIImage:create()
	imgRect:setUseOriginSize(true)
	if tData.level == 0 then 
		imgRect:setFile("battleitems/battle_icon_jnl1.png")
	else
		imgRect:setFile("battleitems/battle_icon_jnl" .. tData.level .. ".png")
	end
	imgRect:setAnchorPoint(GlobalMethod:ccp(1, 0))
	imgRect:setRelativePosition(GlobalMethod:ccp(0.95, 0.1))
	conForIcon:addChild(imgRect)
	--名字
	local txtName = WZUILabelTTF:create()
	txtName:setText(tData.name)
	txtName:setColor(GlobalMethod:ccc3(93,222,254))
	txtName:setFontSize(20)
	txtName:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtName:setRelativePosition(GlobalMethod:ccp(0.34,0.83))
	conTop:addChild(txtName)
	--描述
	local txtDesc = WZUILabelTTF:create()
	txtDesc:setText(tData.test)
	txtDesc:setColor(GlobalMethod:ccc3(195,171,148))
	txtDesc:setFontSize(18)
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDesc:setAlignment(kCCTextAlignmentLeft)
	txtDesc:setDimensions(GlobalMethod:CCSize(190,0))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.34,0.66))
	conTop:addChild(txtDesc)
	--分割线
	local imgLine1 = WZUIImage:create()
	imgLine1:setFile("ui/common/common_scale9_fengexian.png")
	imgLine1:setUseOriginSize(true)
	imgLine1:setScaleX(1.4)
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
	conTips28:addChild(imgLine1)

	--按钮
	if tData.consume == -1 then --最大等级提示语
		local txtMaxLevel = WZUILabelTTF:create()
		txtMaxLevel:setText(LocalStrings.COMMUNITYINFO42)
		txtMaxLevel:setColor(GlobalMethod:ccc3(127,70,26))
		txtMaxLevel:setFontSize(22)
		txtMaxLevel:setRelativePosition(GlobalMethod:ccp(0.5,0.27))
		conTips28:addChild(txtMaxLevel)
	else
		--消耗
		local text1 = [[<T C="195,171,148" S="20">%s:</T><T C="195,171,148" S="20">%d%s</T><T C="195,171,148" S="20">(%s%d)</T>]]
		local nInbornValue = CacheCenter:getPlayerItemCountById(62)
		local ftxtCost = WZUIFreeTextBox:create()
		ftxtCost:setRelativePosition(GlobalMethod:ccp(0.5,0.398))
		ftxtCost:setMaxWidth(320)
		ftxtCost:setShowText(string.format(text1, LocalStrings.PETUSE, tData.consume[1][2], GDatatab_item["id_" .. tData.consume[1][1]].name, LocalStrings.OWN, nInbornValue))
		conTips28:addChild(ftxtCost)
		--激活或升级按钮
		local txtBtn = LocalStrings.STAR_SOUL_BUTTON_UPDATE
		if tData.level == 0 then 
			txtBtn = LocalStrings.ACTIVATION
		end
		local btnUpgrade = self:_createNormalBtn(txtBtn)
		btnUpgrade:setName("btnType45_WndTips")
		conTips28:addChild(btnUpgrade)
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
			ftxtCost:setScale(0.8)
		end
	end

	if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		txtDesc:setScale(0.75)
		txtDesc:setDimensions(GlobalMethod:CCSize(230,0))
	end
end

--@brief	更新类型46	tips
function WndTips:_update46()
	WZLog("WndTips:_update46")
	local tData = self.m_tData
	GetElement(self.m_root,"conType6_WndTips",WZUIContainer):setVisible(true)
	local text1 = [[<T C="127,70,26" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
	local txtTitle = GetElement(self.m_root, "txtTitle_WndTips6", WZUILabelTTF)
	local txtDesc = GetElement(self.m_root, "txtDesc_WndTips6", WZUILabelTTF)
	if txtTitle then 
		txtTitle:setText(LocalStrings.FOOTMARK_TEXT10)
	end
	if txtDesc then 
		txtDesc:setText(LocalStrings.FOOTMARK_TEXT11)
	end

    GetElement(self.m_root,"txt1Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.HEALTH,tData.hp))
	GetElement(self.m_root,"txt2Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.ATTACK,tData.attack))
	GetElement(self.m_root,"txt3Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.DEFENSE,tData.defend))
	GetElement(self.m_root,"txt4Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.AGILITY,tData.critRate))
	GetElement(self.m_root,"txt5Type6_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.LUCKY,tData.reduceCrit))

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		txtTitle:setScale(0.7)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(290))
	end
	if ProjConfig.LANGUAGE == "vn" then
		txtTitle:setScale(0.8)
		txtDesc:setScale(0.8)
		txtDesc:setDimensions(GlobalMethod:CCSize(290))
	end 
	if ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"txtType6_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		local txt6Type6 = GetElement(self.m_root,"txt6Type6_WndTips",WZUILabelTTF)
		txt6Type6:setScale(0.9)
		txt6Type6:setDimensions(GlobalMethod:CCSize(255))
	end
	if ProjConfig.LANGUAGE == "ug" then
		txtTitle:setScale(0.6)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.62,0.86))
		txtDesc:setScale(0.6)
		txtDesc:setDimensions(GlobalMethod:CCSize(380))
	end
end

--@brief	元魂tip
function WndTips:_update47()
	WZLog("WndTips:_update47")
	local tData = self.m_tData
	if tData == nil then return end 

	GetElement(self.m_root,"imgHeadType47_WndTips",WZUIImage):setFile(tData.icon)
	
	GetElement(self.m_root,"ttf3Type47_WndTips",WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root,"ttf4Type47_WndTips",WZUILabelTTF):setText(LocalStrings.BATTLE..":")

	for i=1,6 do
		GetElement(self.m_root,"label"..i.."Type47_WndTips",WZUILabelTTF):setText("")
	end

	local extraInfo = {}
	for i=1,3 do
		if tData["attr"..i] ~= nil then
			extraInfo[tostring(tData["attr"..i])] = tonumber(tData["attrVal"..i])
			GetElement(self.m_root,"label"..(i*2-1).."Type47_WndTips",WZUILabelTTF):setText(tData["attrTitle"..i])
			GetElement(self.m_root,"label"..(i*2).."Type47_WndTips",WZUILabelTTF):setText("+"..tData["attrVal"..i])
		end
	end
	if tData.winType and tData.winType == 1 then --共鸣元魂
		local label1Type47 = GetElement(self.m_root, "label1Type47_WndTips", WZUILabelTTF)
		label1Type47:setText(LocalStrings.CASTSOUL_TEXT24 .. ":")
		local label2Type47 = GetElement(self.m_root, "label2Type47_WndTips", WZUILabelTTF)
		label2Type47:setRelativePosition(GlobalMethod:ccp(0.6,0.46))
		local percentage = tData.property * 100 / 10000
		label2Type47:setText(string.format("%0.2f%%", percentage))
	end
	GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setText(caculateClothesFighting(extraInfo))

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf2Type47_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf3Type47_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf4Type47_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.66,0.78))
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
		GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.645,0.78))
	elseif ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"ttf3Type47_WndTips",WZUILabelTTF):setScale(0.8)
		local ttf2Type47 = GetElement(self.m_root,"ttf2Type47_WndTips",WZUILabelTTF)
		ttf2Type47:setScale(0.8)
		ttf2Type47:setRelativePosition(GlobalMethod:ccp(0.54,0.89))
		GetElement(self.m_root,"ttf4Type47_WndTips",WZUILabelTTF):setScale(0.8)
		local ttf5Type47 = GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF)
		ttf5Type47:setScale(0.8)
		ttf5Type47:setRelativePosition(GlobalMethod:ccp(0.79,0.78))
		for i=1,3 do
			
			local label1 = GetElement(self.m_root,"label"..(i*2-1).."Type47_WndTips",WZUILabelTTF)
			label1:setRelativePosition(GlobalMethod:ccp(0.3,0.56-(0.1*i)))
			label1:setScale(0.8)
			local label2 = GetElement(self.m_root,"label"..(i*2).."Type47_WndTips",WZUILabelTTF)
			label2:setRelativePosition(GlobalMethod:ccp(0.5,0.56-(0.1*i)))
			label2:setScale(0.8)
		end
	end
end

--@brief	更新类型48	tips
function WndTips:_update48()
	WZLog("WndTips:_update48")
	if self.m_tData == nil then return end
	local playerInfo = self.m_tData
	GetElement(self.m_root,"conType48_WndTips",WZUIContainer):setVisible(true)
	if playerInfo.level > 0 then
		GetElement(self.m_root,"lvType48_WndTips",WZUILabelAtlasFont):setVisible(true)
		GetElement(self.m_root, "imgAsk_WndTips48", WZUIImage):setVisible(false)
		GetElement(self.m_root,"lvType48_WndTips",WZUILabelAtlasFont):setText(playerInfo.level)
	else
		GetElement(self.m_root,"lvType48_WndTips",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root, "imgAsk_WndTips48", WZUIImage):setVisible(true)
	end

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/pvp/common_icon_ry.png")
	--段位
	if playerInfo.level == 0 then
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(LocalStrings.NO_GET_WORDS)
	else
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(playerInfo.name .. "X" .. playerInfo.level)
	end
	--积分
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setText(LocalStrings.PVPNEW_TEXT2)
	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setText(LocalStrings.PVPNEW_TEXT1)
	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	local m_height = 180
	if playerInfo.name == LocalStrings.PVPNEW_TEXT4 then
		m_height = 300
	end
	conBg:setAbsContentSize(GlobalMethod:CCSize(280,m_height))
	conBg:updateRelativeSize()

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setScale(0.8)
		local ttf1 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1:setScale(0.7)
		ttf1:setDimensions(GlobalMethod:CCSize(160,0))
		
	elseif ProjConfig.LANGUAGE == "th" then
		GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setScale(0.8)
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
		local ttf6Type48_WndTips = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
		ttf6Type48_WndTips:setScale(0.8)
		ttf6Type48_WndTips:setRelativePosition(GlobalMethod:ccp(0.35,0.693888))
		local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1Type48:setScale(0.8)
		ttf1Type48:setDimensions(GlobalMethod:CCSize(200,0))
		ttf1Type48:setRelativePosition(GlobalMethod:ccp(0.35,0.302222))
		local ttf3Type48 = GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF)
		ttf3Type48:setDimensions(GlobalMethod:CCSize(300,0))
			
		ttf3Type48:setScale(0.8)	
	elseif ProjConfig.LANGUAGE == "ug" then
		local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
		ttf6Type48:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		ttf6Type48:setAlignment(kCCTextAlignmentRight)
		ttf6Type48:setScale(0.7)
		ttf6Type48:setRelativePosition(GlobalMethod:ccp(0.94,0.72))
		ttf6Type48:setDimensions(GlobalMethod:CCSize(220))
		local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1Type48:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		ttf1Type48:setAlignment(kCCTextAlignmentRight)
		ttf1Type48:setScale(0.7)
		ttf1Type48:setRelativePosition(GlobalMethod:ccp(0.94,0.32))
		ttf1Type48:setDimensions(GlobalMethod:CCSize(220))
		local ttf3Type48 = GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF)
		ttf3Type48:setRelativePosition(GlobalMethod:ccp(0.0218321,0.86))
		ttf3Type48:setAlignment(kCCTextAlignmentRight)
	end
	
	if playerInfo.level == 0 then
		GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer):setVisible(false)
		local conType48 = GetElement(self.m_root, "conType48_WndTips", WZUIContainer)
		conType48:setAbsContentSize(GlobalMethod:CCSize(262,170))
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			conType48:setAbsContentSize(GlobalMethod:CCSize(262,190))
		elseif ProjConfig.LANGUAGE == "ug" then
			conType48:setAbsContentSize(GlobalMethod:CCSize(262,300))
		end
		conType48:updateRelativeSize()
		return 
	end
	--战力加成
	local nFighting = WndCard:_caculateFighting(playerInfo.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.836666))
	end
	GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"label1Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[playerInfo.property[1][1]])
	GetElement(self.m_root,"label2Type48_WndTips",WZUILabelTTF):setText("+"..playerInfo.property[1][2])
	GetElement(self.m_root,"label3Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[playerInfo.property[2][1]])
	GetElement(self.m_root,"label4Type48_WndTips",WZUILabelTTF):setText("+"..playerInfo.property[2][2])
	GetElement(self.m_root,"label5Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[playerInfo.property[3][1]])
	GetElement(self.m_root,"label6Type48_WndTips",WZUILabelTTF):setText("+"..playerInfo.property[3][2])
end

--@brief	更新类型49	tips
--@note 	卡牌徽章tips
function WndTips:_update49()
	WZLog("WndTips:_update49")
	if self.m_tData == nil then return end
	local cardInfo = self.m_tData

	local conType48 = GetElement(self.m_root, "conType48_WndTips", WZUIContainer)
	if cardInfo.collectNum == 0 then
		conType48:setAbsContentSize(GlobalMethod:CCSize(262,90))
	else
		conType48:setAbsContentSize(GlobalMethod:CCSize(262,440))
	end
	conType48:updateRelativeSize()
	
	GetElement(self.m_root, "imgAsk_WndTips48", WZUIImage):setVisible(false)
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setVisible(false)
	--总等级
	local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
	ttf6Type48:setFontSize(22)
	ttf6Type48:setColor(GlobalMethod:ccc3(127,70,26))
	--已收集的卡牌数量
	local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
	local imgHeadType48 = GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage)
	if cardInfo.dataType == 1 then 
		--卡牌徽章图标
		ttf6Type48:setText(LocalStrings.CARD_TEXT35 .. cardInfo.level)
		imgHeadType48:setFile("ui/bag/common_icon_kapai2.png")
		imgHeadType48:setScale(0.6)
		ttf1Type48:setText(string.format(LocalStrings.CARD_TEXT1, cardInfo.collectNum))
		ttf1Type48:setColor(GlobalMethod:ccc3(195,171,148))
		ttf1Type48:setFontSize(18)
	elseif cardInfo.dataType == 2 then 
		--卡牌徽章图标
		ttf6Type48:setText(LocalStrings.PRAYMEDAL_TEXT1 .. cardInfo.level)
		imgHeadType48:setFile("ui/common/common_icon_qfxz.png")
		ttf1Type48:setText("")
	end

	if cardInfo.collectNum == 0 then
		GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer):setVisible(false)
		return
	end
	local conDesc = GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer)
	conDesc:setAbsContentSize(GlobalMethod:CCSize(262,120))
	conDesc:updateRelativeSize()


	local sFormat = [[<T C="127,70,26" S="18" P="1">%s</T><T C="127,70,26" S="18" P="1"> %d</T>]]
	for i = 1, 4 do
		local txt = string.format(sFormat, LocalStrings.CARD_TEXT36[i], cardInfo.cardNum[i][2])
		if cardInfo.dataType == 2 then 
			txt = string.format(sFormat, LocalStrings.PRAYMEDAL_TEXT2[i], cardInfo.cardNum[i][2])
		end
		self:_createFtext(conDesc, txt, GlobalMethod:ccp(0.1, 0.85 - (i - 1) * 0.24))
	end

	for i = 1, 6 do
		GetElement(self.m_root, "label" .. i .. "Type48_WndTips", WZUILabelTTF):setVisible(false)
	end

	local conProperty = GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer)
	conProperty:setAbsContentSize(GlobalMethod:CCSize(262,300))
	conProperty:updateRelativeSize()
	conProperty:setVisible(true)

	local txtTotalPro = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
	txtTotalPro:setRelativePosition(GlobalMethod:ccp(0.1,0.94))
	txtTotalPro:setColor(GlobalMethod:ccc3(127,70,26))

	sFormat = [[<T C="127,70,26" S="18" P="1">%s</T><T C="5,180,0" S="18" P="1"> %d</T>]]
	WZLog("WndTips:_update49 HHHHHH", Serialize(cardInfo.property))
	--战力加成
	local nFighting = WndCard:_caculateFighting(cardInfo.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.94))
	end
	local height = 27
	for i = 1, #cardInfo.property do
		local txt = string.format(sFormat, ATTR_TITLE[cardInfo.property[i][1]], cardInfo.property[i][2])
		self:_createFtext(conProperty, txt, GlobalMethod:ccp(0.1, 0.85 - (i - 1) * 0.09))
		height = height + 27
	end
	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	conBg:setAbsContentSize(GlobalMethod:CCSize(262,240+height))
	conBg:updateRelativeSize()

	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setScale(0.8)
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
		ttf6Type48:setScale(0.7)
		ttf6Type48:setDimensions(GlobalMethod:CCSize(220))
		local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1Type48:setScale(0.7)
		ttf1Type48:setDimensions(GlobalMethod:CCSize(220))
	elseif ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "tr" then
		local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
		ttf6Type48:setScale(0.7)
		ttf6Type48:setRelativePosition(GlobalMethod:ccp(0.35,0.693888))
		local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1Type48:setScale(0.7)
		ttf1Type48:setRelativePosition(GlobalMethod:ccp(0.35,0.302222))
	end
end

--@brief 	小孩徽章
function WndTips:_update50()
	-- body
	if self.m_tData == nil then return end
	local tData = self.m_tData
	for i = 1, #tData.kidData do
		local conHead = GetElement(self.m_root, "conHead" .. i .. "_WndTips49", WZUIContainer)
		conHead:setVisible(true)
		local txtKidName = GetElement(self.m_root, "txtKidName" .. i .. "_WndTips49", WZUILabelTTF)
		local kidHead = CellHead:show(conHead, tData.kidData[i].headId, tData.kidData[i].faceId, tData.kidData[i].sex, nil, nil, nil, nil, nil, nil, nil, true)
		if txtKidName then
			local name = ""
			if tData.kidData[i].name then
				name = tData.kidData[i].name
			end
			txtKidName:setText(name .. string.format(LocalStrings.CHECKOTHER_TEXT13, tData.kidData[i].level/10))
		end
		if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
			txtKidName:setScale(0.7)
			txtKidName:setDimensions(GlobalMethod:CCSize(180))
		end
	end
	local txtNotCare = GetElement(self.m_root, "txtNotCare_WndTips49", WZUILabelTTF)
	if tData.careToday == 0 then
		txtNotCare:setVisible(true)
		return 
	else
		txtNotCare:setVisible(false)
	end

	local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T>]]
	local conProperty = GetElement(self.m_root, "conProperty_WndTips49", WZUIContainer)
	local tProperty = {}
	for i, v in pairs(tData.property) do
		local tItem = {}
		if v > 0 then
			tItem[1] = tonumber(i)
			tItem[2] = v
			table.insert(tProperty, tItem)
		end

	end
	table.sort(tProperty, function (a,b)
		-- body
		return a[1] < b[1]
	end)
	--战力加成
	local nFighting = WndCard:_caculateFighting(tProperty)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips49", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips49",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.836666))
	end
	for i = 1, #tProperty do
		local txt = string.format(sFormat, ATTR_TITLE[tProperty[i][1]], tProperty[i][2])
		self:_createFtext(conProperty, txt, GlobalMethod:ccp(0.1, 0.65 - (i - 1) * 0.175))
	end

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtTotalPro_WndTips49",WZUILabelTTF):setScale(0.7)
	end
end

--@brief 	战斗中技能道具的tips
function WndTips:_update51()
	-- body
	if self.m_tData == nil then return end
	local tData = self.m_tData
	--技能道具图标
	local imgSkillP = GetElement(self.m_root, "imgSkillP_WndTips50", WZUIImage)
	if imgSkillP then
		imgSkillP:setFile(tData.icon)
	end
	--名字
	local label1Type = GetElement(self.m_root, "label1Type50_WndTips", WZUILabelTTF)
	if label1Type then
		label1Type:setText(tData.name)
	end
	--等级
	local label2Type = GetElement(self.m_root, "label2Type50_WndTips", WZUILabelTTF)
	if label2Type then
		label2Type:setText(tData.specialAttackParam)
	end
	--消耗
	local lafCostValue = GetElement(self.m_root, "lafCostValue_WndSkillProp", WZUILabelAtlasFont)
	if lafCostValue then
		lafCostValue:setText(math.floor(tData.consume/1000))
	end
	--冷却
	local lafCoolValue = GetElement(self.m_root, "lafCoolValue_WndSkillProp", WZUILabelAtlasFont)
	if lafCoolValue then
		if WndBattleHud.m_root and tData.id == 62 and WBattleGlobal:getCurrent():isDigGappingFighting() then 
			lafCoolValue:setText(math.floor((tData.cooling_time + g_nAdditionCoolTime)/1000))
		else
			lafCoolValue:setText(math.floor(tData.cooling_time/1000))
		end
	end
	--描述
	local label4Type = GetElement(self.m_root, "label4Type50_WndTips", WZUILabelTTF)
	if label4Type then
		label4Type:setText(tData.tool_desc)
	end

	--按钮
	if tData.skill_type == 9 then
		GetElement(self.m_root, "btnDrop_WndTips50", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root, "btnDrop_WndTips50", WZUIButton):setVisible(false)
	end

	--大招不显示等级和冷却
	if tData.skill_type == 2 then
		 GetElement(self.m_root, "txt1_WndTips50", WZUILabelTTF):setVisible(false)
		 GetElement(self.m_root, "label2Type50_WndTips", WZUILabelTTF):setVisible(false)
		 GetElement(self.m_root, "txt3_WndTips50", WZUILabelTTF):setVisible(false)
		 GetElement(self.m_root, "imgCoolValue_WndSkillProp", WZUIImage):setVisible(false)
	end

	if ProjConfig.LANGUAGE == "th" then
		local txtDrop = GetElement(self.m_root, "txtDrop_WndTips50", WZUILabelTTF)
		txtDrop:setScale(0.5)
		txtDrop:setDimensions(GlobalMethod:CCSize(200))
		local label4Type = GetElement(self.m_root, "label4Type50_WndTips", WZUILabelTTF)
		label4Type:setScale(0.8)
		label4Type:setDimensions(GlobalMethod:CCSize(360))
	elseif ProjConfig.LANGUAGE == "en" then
		local txtDrop = GetElement(self.m_root, "txtDrop_WndTips50", WZUILabelTTF)
		txtDrop:setScale(0.5)
		txtDrop:setDimensions(GlobalMethod:CCSize(200))
		GetElement(self.m_root, "label2Type50_WndTips", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.532857,0.531579))
		GetElement(self.m_root, "imgCostValue_WndSkillProp", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.607143,0.310526))
		GetElement(self.m_root, "imgCoolValue_WndSkillProp", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.721428,0.0578944))
		local label4Type = GetElement(self.m_root, "label4Type50_WndTips", WZUILabelTTF)
		label4Type:setScale(0.8)
		label4Type:setDimensions(GlobalMethod:CCSize(360))
	
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		local label1Type = GetElement(self.m_root, "label1Type50_WndTips", WZUILabelTTF)
		label1Type:setScale(0.8)
		label1Type:setDimensions(GlobalMethod:CCSize(240))
		local txtDrop = GetElement(self.m_root, "txtDrop_WndTips50", WZUILabelTTF)
		
		txtDrop:setScale(0.6)
		txtDrop:setDimensions(GlobalMethod:CCSize(180))
		local txt1 = GetElement(self.m_root, "txt1_WndTips50", WZUILabelTTF)
		txt1:setScale(0.8)
		txt1:setRelativePosition(GlobalMethod:ccp(0.34,0.56))
		local txt2 = GetElement(self.m_root, "txt2_WndTips50", WZUILabelTTF)
		txt2:setScale(0.8)
		txt2:setRelativePosition(GlobalMethod:ccp(0.34,0.34))
		local txt3 = GetElement(self.m_root, "txt3_WndTips50", WZUILabelTTF)
		txt3:setScale(0.8)
		txt3:setRelativePosition(GlobalMethod:ccp(0.34,0.12))
		local label2Type50 = GetElement(self.m_root, "label2Type50_WndTips", WZUILabelTTF)
		label2Type50:setScale(0.8)
		
		label2Type50:setRelativePosition(GlobalMethod:ccp(0.64,0.477368))
		local imgCostValue = GetElement(self.m_root, "imgCostValue_WndSkillProp", WZUIImage)
		imgCostValue:setScale(0.8)
		imgCostValue:setRelativePosition(GlobalMethod:ccp(0.64,0.289473))
		local imgCoolValue = GetElement(self.m_root, "imgCoolValue_WndSkillProp", WZUIImage)
		imgCoolValue:setScale(0.8)
		
		imgCoolValue:setRelativePosition(GlobalMethod:ccp(0.64,0.0473681))
		local label4Type = GetElement(self.m_root, "label4Type50_WndTips", WZUILabelTTF)
		label4Type:setScale(0.7)
		label4Type:setDimensions(GlobalMethod:CCSize(420))
	elseif ProjConfig.LANGUAGE == "vn" then
		if tData.skill_type == 2 then
			GetElement(self.m_root,"imgDividingLine",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.5,0.6))
			GetElement(self.m_root,"con4Type50_WndTips",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			GetElement(self.m_root,"label4Type50_WndTips",WZUILabelTTF):setFontSize(16)
		end
	end

end

--@brief	点赞数量tips
function WndTips:_update52()
	WZLog("WndTips:_update52")
	local tData = self.m_tData
	local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
	conType5:setVisible(true)
	if tData.nType and tData.nType == 2 then 
		if tData.property then 
			local nAddH = math.ceil(#tData.property / 2) * 30
			conType5:setAbsContentSize(GlobalMethod:CCSize(310,75 + nAddH))
		else
			conType5:setAbsContentSize(GlobalMethod:CCSize(310,75))
		end
	else
		conType5:setAbsContentSize(GlobalMethod:CCSize(275,100))
	end
	conType5:updateRelativeSize()

	if tData.nType and tData.nType == 2 then 
		local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
		local txt2Type5 = GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox)
		txt2Type5:setMaxWidth(286)
		txt2Type5:setShowText(string.format(sFormat, tData.txtTitle))
		if tData.property then  
			txt2Type5:setRelativePosition(GlobalMethod:ccp(0.06,0.86))
			--创建分割线
			local imgLine = createImage("ui/common/frame_fengexian_01.png",GlobalMethod:ccp(0.5, 0.75), nil, true, GlobalMethod:ccp(0.5, 0.5))
			imgLine:setScaleX(9)
			conType5:addChild(imgLine)
			--显示属性值
			local proFormat = [[<T C="127,70,26" S="20" P="1">%s:</T><T C="229,105,22" S="20" P="1">%d</T>]]
			local startY = 0.6
			local gapping = 0.18
			for i = 1, #tData.property do
				local desc = string.format(proFormat, ATTR_TITLE[tData.property[i][1]], tData.property[i][2])
				local nRow = math.floor((i - 1)/2)
				local nStartX = 0.06
				if math.fmod(i, 2) == 0 then 
					nStartX = 0.5
				end
				local ftxtPro = createFreeTextBox(desc, GlobalMethod:ccp(nStartX, startY - nRow * gapping), GlobalMethod:ccp(0, 0.5), 300)
				conType5:addChild(ftxtPro)
			end
		end
	else
		GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(LocalStrings.PVPGOOD_TEXT3, tData.zanNum))
	end

	if ProjConfig.LANGUAGE == "vn" then
		if tData.nType and tData.nType == 2 then
			local txt2Type5 = GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox)
			txt2Type5:setScale(0.7)
			txt2Type5:setMaxWidth(410)
		else
			local txt2Type5 = GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox)
			txt2Type5:setScale(0.9)
			txt2Type5:setRelativePosition(GlobalMethod:ccp(0.06,0.56))
		end
	end
end

--@brief 	成就徽章数据
function WndTips:_update53()
	WZLog("WndTips:_update53")
	if self.m_tData == nil then return end
	local tData = self.m_tData
	
	local conType48 = GetElement(self.m_root,"conType48_WndTips",WZUIContainer)
	conType48:setVisible(true)
 	conType48:setAbsContentSize(GlobalMethod:CCSize(262,240))
	conType48:updateRelativeSize()

	GetElement(self.m_root,"lvType48_WndTips",WZUILabelAtlasFont):setVisible(false)
	GetElement(self.m_root, "imgAsk_WndTips48", WZUIImage):setVisible(false)

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/achievement/common_icon_cjsmhz.png")
	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setScale(0.42)
	GetElement(self.m_root,"imgLine_WndTips48",WZUIImage):setVisible(false)
	--等级
	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35, 0.5))
	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(LocalStrings.BADGELEVEL .. tData.level)

	local conDesc = GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer)
	conDesc:setAbsContentSize(GlobalMethod:CCSize(262,2))
	conDesc:updateRelativeSize()
	--属性
	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setVisible(false)
	local nFighting = WndCard:_caculateFighting(tData.property)
	GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF):setText("+" .. nFighting .. LocalStrings.BATTLE)
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.836666))
	elseif ProjConfig.LANGUAGE == "vn" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
		txtFightingT:setScale(0.8)
	end
	GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF):setVisible(true)

	GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"label1Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[1][1]])
	GetElement(self.m_root,"label2Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[1][2])
	GetElement(self.m_root,"label3Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[2][1]])
	GetElement(self.m_root,"label4Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[2][2])
	GetElement(self.m_root,"label5Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[3][1]])
	GetElement(self.m_root,"label6Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[3][2])


	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setScale(0.8)
	end
end

--@brief 	英雄塔角色tips
function WndTips:_update54()
	WZLog("WndTips:_update54")
	if self.m_tData == nil then return end
	local tData = self.m_tData.playerInfo
	--头像
	local conHead = GetElement(self.m_root, "conHead_WndTips51", WZUIContainer)
	local cellElement =  CellHead:show(conHead, tData.headId, tData.faceId, tData.sex, false, nil, tData.vipLevel, tData.headColor)
	--名字
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_WndTips51", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(tData.name)
	end
	--服务器
	local txtServerName = GetElement(self.m_root, "txtServerName_WndTips51", WZUILabelTTF)
	if txtServerName then 
		txtServerName:setText(CacheCenter:getServerNameByServerId(tData.serverId))
	end
	--战斗力
	local txtFight = GetElement(self.m_root, "txtFight_WndTips51", WZUILabelAtlasFont)
	if txtFight then 
		txtFight:setText(tData.fight)
	end
	--消耗
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndTips51", WZUIFreeTextBox)
	local tVipData = WndTowerScroll:_getVipLimitData(self.m_tData)
	if ftxtCost then 
		local sFormat = [[<T S="20" C="127,70,26">%s</T><I Z="0.5">%s</I><T S="20" C="127,70,26">%d</T>]]
		if tVipData then 
			ftxtCost:setShowText(string.format(sFormat, LocalStrings.PETUSE, GDatatab_item["id_" .. tVipData.cost[1][1]].icon, tVipData.cost[1][2]))
		end
	end
	--刷新按钮的状态
	local btnRefresh = GetElement(self.m_root, "btnRefresh_WndTips51", WZUIButton)
	if btnRefresh then 
		if not tVipData then 
			btnRefresh:setTouchEnable(false)
			GetElement(self.m_root, "txtRefresh_WndTips51", WZUILabelTTF):setLabelStyleKey("SMALL_GRAY_BTN")
		else
			btnRefresh:setTouchEnable(true)
			GetElement(self.m_root, "txtRefresh_WndTips51", WZUILabelTTF):setLabelStyleKey("SMALL_GREEN_BTN")
		end
	end

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root, "txtChallenge_WndTips51", WZUILabelTTF):setScale(0.9)		
	end
end

--@brief 	更新tips数据
function WndTips:resetData(tData)
	-- body
	if self.m_root == nil then return end 
	self.m_tData = tData

	self["_update"..self.m_nType](self)
end

--@brief 	战斗buff tips
function WndTips:_update55()
	WZLog("WndTips:_update55")
	local tData = self.m_tData

	GetElement(self.m_root,"conType48_WndTips",WZUIContainer):setVisible(true)
	GetElement(self.m_root, "imgAsk_WndTips48", WZUIImage):setVisible(false)
	GetElement(self.m_root,"lvType48_WndTips",WZUILabelAtlasFont):setVisible(false)
	GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer):setVisible(false)

	local buffData = GDatatab_herotower_map["id_" .. tData.buffId]
	if buffData == nil then return end 
	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	conBg:setAbsContentSize(GlobalMethod:CCSize(280,100))
	conBg:updateRelativeSize()
	--buff图标
	local imgHeadType48 = GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage)
	imgHeadType48:setScale(0.7)
	imgHeadType48:setRelativePosition(GlobalMethod:ccp(0.15, 0.75))
	imgHeadType48:setFile(buffData.buff2icon)
	--buff名字
	local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
	ttf6Type48:setRelativePosition(GlobalMethod:ccp(0.28, 0.73))
	ttf6Type48:setFontSize(22)
	ttf6Type48:setColor(GlobalMethod:ccc3(127,70,26))
	ttf6Type48:setText(buffData.name2)

	--描述
	local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
	ttf1Type48:setVisible(true)
	ttf1Type48:setText(buffData.describe)
	ttf1Type48:setColor(GlobalMethod:ccc3(138,122,106))
	ttf1Type48:setAnchorPoint(GlobalMethod:ccp(0, 1))
	ttf1Type48:setRelativePosition(GlobalMethod:ccp(0.06, 0.5))
	ttf1Type48:setDimensions(GlobalMethod:CCSize(250, 0))

	local conIcon = GetElement(self.m_root, "conIcon_WndTips48", WZUIContainer)
	conIcon:setAbsContentSize(GlobalMethod:CCSize(290, 120))
	conIcon:updateRelativeSize()

	local conType48 = GetElement(self.m_root, "conType48_WndTips", WZUIContainer)
	conType48:setAbsContentSize(GlobalMethod:CCSize(290, 120))
	conType48:updateRelativeSize()
end

--@brief	更新类型15	tips
function WndTips:_update56()
	WZLog("WndTips:_update56")
	local tData = self.m_tData
	GetElement(self.m_root,"conType13_WndTips",WZUIContainer):setVisible(true)
	local QUALITY_RECT_TIPS = {"ui/common/common_scale9_lv.png","ui/common/common_scale9_lan.png","ui/common/common_scale9_zi.png","ui/common/common_scale9_cheng.png"}

	GetElement(self.m_root, "img9Quality_WndTips13", WZUI9Image):setFile(QUALITY_RECT_TIPS[tData.quality])
	--设置名字描述
	local titleType13 = GetElement(self.m_root,"titleType13_WndTips",WZUI9Label)
	titleType13:setText(tData.name)
	titleType13:setColor(GlobalMethod:ccc3(127,70,26))
	local descType13 = GetElement(self.m_root,"descType13_WndTips",WZUI9Label)
	descType13:setText(LocalStrings.LV .. tData.curLevel .. "/" .. LocalStrings.LV .. tData.targetLevel)
	descType13:setColor(GlobalMethod:ccc3(99,255,95))
	descType13:setDimensions(GlobalMethod:CCSize(0, 0))
	local txtStarNum13 = GetElement(self.m_root,"txtStarNum13_WndTips",WZUI9Label)
	txtStarNum13:setText(tData.curStar .. LocalStrings.COMMUNITYINFO224 .. "/" .. tData.targetStar .. LocalStrings.COMMUNITYINFO224)
	local txtAdvanceLv = GetElement(self.m_root,"txtAdvanceLv13_WndTips",WZUI9Label)
	if tData.targetAdvanceLevel > 0 then 
		titleType13:setRelativePosition(GlobalMethod:ccp(0.38,0.84))
		descType13:setRelativePosition(GlobalMethod:ccp(0.38,0.72))
		txtStarNum13:setRelativePosition(GlobalMethod:ccp(0.38,0.5))
		txtAdvanceLv:setText(string.format(LocalStrings.TIPS12 .. "/" .. LocalStrings.TIPS12, tData.curAdvanceLevel, tData.targetAdvanceLevel))
	end

	--设置怪物头像
	if tData.icon ~= nil then
		WZLog("显示怪物头像图片")
		GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setFile(tData.icon)
		GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setVisible(true)
	end
end

--@brief	更新类型57	助战tips
function WndTips:_update57()
	WZLog("WndTips:_update57")
	local tData = self.m_tData
	
	local conType8 = GetElement(self.m_root,"conType8_WndTips",WZUIContainer)
	conType8:setVisible(true)
	conType8:setAbsContentSize(GlobalMethod:CCSize(386,220))
	conType8:updateRelativeSize()

	--麻蛋
	if ProjConfig.LANGUAGE == "vn" then
		conType8:setAbsContentSize(GlobalMethod:CCSize(386,320))
		conType8:updateRelativeSize()
	end

	GetElement(self.m_root,"conHead_WndTips8",WZUIContainer):setVisible(false)
	GetElement(self.m_root, "title2Type8_WndTips", WZUIFreeTextBox):setVisible(false)

	local title1Type8 = GetElement(self.m_root, "title1Type8_WndTips", WZUILabelTTF)
	title1Type8:setFontSize(20)
	title1Type8:setRelativePosition(GlobalMethod:ccp(0.4, 0.88))
	title1Type8:setText(LocalStrings.BATTLE_HELP_TEXT1)
	
	
	local imgLine_WndTips8 = GetElement(self.m_root, "imgLine_WndTips8", WZUIImage)
	imgLine_WndTips8:setRelativePosition(GlobalMethod:ccp(0.5, 0.8))
	imgLine_WndTips8:setScaleX(1.8)
	--等级不为nil显示数字
	local text = [[<T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1">%d/%d</T>]]
	GetElement(self.m_root,"txt1Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT2, tData.leftNum1, tData.totalNum1))
	GetElement(self.m_root,"txt1Type8_WndTips",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03, 0.69))
	GetElement(self.m_root,"txt2Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT3, tData.leftNum2, tData.totalNum2))
	GetElement(self.m_root,"txt2Type8_WndTips",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03, 0.56))
	GetElement(self.m_root,"txt3Type8_WndTips",WZUIFreeTextBox):setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT8, tData.leftNum3, tData.totalNum3))
	GetElement(self.m_root,"txt3Type8_WndTips",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03, 0.43))
	GetElement(self.m_root,"txt3Type8_WndTips",WZUIFreeTextBox):setMaxWidth(370)
	GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox):setAnchorPoint(GlobalMethod:ccp(0, 1))
	GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox):setMaxWidth(370)
	GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03, 0.34))
	GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox):setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]], LocalStrings.BATTLE_HELP_TEXT13))
	GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox):setAnchorPoint(GlobalMethod:ccp(0, 1))
	GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.03, 0.23))
	GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox):setMaxWidth(370)
	GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox):setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]], LocalStrings.BATTLE_HELP_TEXT14))

	local txt1Type8_WndTips = GetElement(self.m_root,"txt1Type8_WndTips",WZUIFreeTextBox)
	txt1Type8_WndTips:setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT2, tData.leftNum1, tData.totalNum1))
	txt1Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.69))

	local txt2Type8_WndTips = GetElement(self.m_root,"txt2Type8_WndTips",WZUIFreeTextBox)
	txt2Type8_WndTips:setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT3, tData.leftNum2, tData.totalNum2))
	txt2Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.56))

	local txt3Type8_WndTips = GetElement(self.m_root,"txt3Type8_WndTips",WZUIFreeTextBox)
	txt3Type8_WndTips:setShowText(string.format(text, LocalStrings.BATTLE_HELP_TEXT8, tData.leftNum3, tData.totalNum3))
	txt3Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.43))

	local txt4Type8_WndTips = GetElement(self.m_root,"txt4Type8_WndTips",WZUIFreeTextBox)
	txt4Type8_WndTips:setAnchorPoint(GlobalMethod:ccp(0, 1))
	txt4Type8_WndTips:setMaxWidth(370)
	txt4Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.34))
	txt4Type8_WndTips:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]], LocalStrings.BATTLE_HELP_TEXT13))

	local txt5Type8_WndTips = GetElement(self.m_root,"txt5Type8_WndTips",WZUIFreeTextBox)
	txt5Type8_WndTips:setAnchorPoint(GlobalMethod:ccp(0, 1))
	txt5Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.23))
	txt5Type8_WndTips:setMaxWidth(370)
	txt5Type8_WndTips:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]], LocalStrings.BATTLE_HELP_TEXT14))

	GetElement(self.m_root,"numType8_WndTips", WZUILabelAtlasFont):setVisible(false)

	if ProjConfig.LANGUAGE == "vn" then
		title1Type8:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		title1Type8:setRelativePosition(GlobalMethod:ccp(0.5,0.91))
		imgLine_WndTips8:setRelativePosition(GlobalMethod:ccp(0.5, 0.86))

		txt1Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.8))
		txt2Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.68))
		txt3Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.56))
		txt4Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.51))
		txt5Type8_WndTips:setRelativePosition(GlobalMethod:ccp(0.03, 0.34))

		txt1Type8_WndTips:setMaxWidth(400)
		txt2Type8_WndTips:setMaxWidth(400)
		txt3Type8_WndTips:setMaxWidth(400)
		txt4Type8_WndTips:setMaxWidth(400)
		txt5Type8_WndTips:setMaxWidth(400)
	end
end

--@brief	更新类型57	助战tips
function WndTips:_update58()
	WZLog("WndTips:_update58")
	local tData = self.m_tData
	
	for i = 1, #tData do
		GetElement(self.m_root, "conContent" .. i .. "_WndTips52", WZUIContainer):setVisible(true)
		local conHead = GetElement(self.m_root, "conHead" .. i .. "_WndTips52", WZUIContainer)
		CellHead:show(conHead, tData[i].headId, tData[i].faceId, tData[i].sex, false, nil, tData[i].vipLevel, tData[i].headColor)
		--玩家名字
		local txtName = GetElement(self.m_root, "txtName" .. i .. "_WndTips52", WZUILabelTTF)
		if txtName then 
			txtName:setText(tData[i].playerName)
		end
		--玩家等级
		local txtLevel = GetElement(self.m_root, "txtLevel" .. i .. "_WndTips52", WZUILabelTTF)
		if txtLevel then 
			txtLevel:setText(LocalStrings.LV .. ":" .. tData[i].level)
		end
		--玩家头衔
		local txtTitle = GetElement(self.m_root, "txtTitle" .. i .. "_WndTips52", WZUILabelTTF)
		if txtTitle then 
			txtTitle:setText(tData[i].title)
		end
		--互动数量
		local txtNum = GetElement(self.m_root, "txtNum" .. i .. "_WndTips52", WZUILabelTTF)
		if txtNum then 
			if tData[i].type == 1 then 
				txtNum:setText(string.format(LocalStrings.CHECKOTHER_TEXT20, tData[i].footNum))
			elseif tData[i].type == 2 then 
				txtNum:setText(string.format(LocalStrings.CHECKOTHER_TEXT21, tData[i].flowerNum))
			elseif tData[i].type == 3 then 
				txtNum:setText(LocalStrings.FRIENDLINESS .. tData[i].friendliness)
			end
		end

		GetElement(self.m_root, "txtNoWords" .. i .. "_WndTips52", WZUILabelTTF):setVisible(false)
		
		if ProjConfig.LANGUAGE == "vn" then
			txtNum:setAnchorPoint(GlobalMethod:ccp(0.5,1))
			txtNum:setRelativePosition(GlobalMethod:ccp(0.5,0.34))
			txtNum:setDimensions(GlobalMethod:CCSize(138))
		end
	end
end

--@brief	宠物技能tip
function WndTips:_update59()
	WZLog("WndTips:_update59")
	local tData = self.m_tData
	if tData == nil then return end 

	--被动技能按钮
	local txtTitle = GetElement(self.m_root,"txtTitle_WndTips36",WZUILabelTTF)
	if txtTitle then 
		txtTitle:setText(tData.name)
		txtTitle:setColor(GlobalMethod:ccc3(233,166,62))
		txtTitle:setEnableStroke(false)
		-- txtTitle:setRelativePosition(GlobalMethod:ccp(0.31,0.67))
	end
	GetElement(self.m_root, "imgSkillBKTwo_WndTips36", WZUIImage):setVisible(false)
	GetElement(self.m_root, "imgSkillBK_WndTips36", WZUIImage):setFile("ui/common/common_scale9_beibaodi.png")
	local txt1Type35 = GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF)
	txt1Type35:setText(tData.tool_desc)
	-- txt1Type35:setRelativePosition(GlobalMethod:ccp(0.31,0.53))

	local imgSkillPg = GetElement(self.m_root,"imgSkillPg_WndTips36",WZUIImage)
	imgSkillPg:setFile(tData.icon)
	imgSkillPg:setScale(1.1)

	local imgSkillL = GetElement(self.m_root,"imgSkillL_WndTips36",WZUIImage)
	imgSkillL:setVisible(true)
	imgSkillL:setFile(tData.lv_icon)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF):setFontSize(14)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF):setFontSize(15)
	end
	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF):setFontSize(11)
	end
end

--@brief	更新类型61	tips
function WndTips:_update61()
	WZLog("WndTips:_update61")

	local tData = self.m_tData
	local txtGetReward = GetElement(self.m_root,"txtGetReward_WndTips61",WZUILabelTTF)
	if txtGetReward then
		txtGetReward:setText(LocalStrings.GET_AWARD..":")
	end
    local digdungeontask = json.decode(CacheCenter:getGameParam().digdungeontask)
	local txtTaskDetails = GetElement(self.m_root,"txtTaskDetails_WndTips61",WZUILabelTTF)
	local strDesc = "%s(%d/%d)" 
	txtTaskDetails:setText(string.format(strDesc,digdungeontask.describe,tData.complete,digdungeontask.times))

	local id,num = SplitItemString(digdungeontask.reward)
	for i=1,math.min(#id, 2) do
		local conTaskReward = GetElement(self.m_root, "conTaskReward"..i.."_WndTips61", WZUIContainer)
		local celElement,tCell = CellGoodItem:createElement()
    	celElement:setTag(i-1)
    	celElement = WZUIContainer:luaTo(celElement)
    	tCell:setCellGoodLocalId(id[i], num[i] , 4)
		conTaskReward:addChild(celElement)
		celElement:setScale(0.825)
	end
end

--@brief	套装注魂属性tips
function WndTips:_update62()
	WZLog("WndTips:_update62")
	local tData = self.m_tData
	local conTips28 = GetElement(self.m_root,"conTips28_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(300, 278))
	conTips28:updateRelativeSize()

	local txtTitle = WZUILabelTTF:create()
	if tData.tabIndex == 1 then 
		txtTitle:setText(LocalStrings.CASTSOUL_TEXT15)
	elseif tData.tabIndex == 2 then 
		txtTitle:setText(LocalStrings.CASTSOUL_TEXT18)
	elseif tData.tabIndex == 3 then 
		txtTitle:setText(LocalStrings.OTHER_TEXT1[3])
	end
	txtTitle:setColor(GlobalMethod:ccc3(127,70,26))
	txtTitle:setFontSize(24)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.91))
	conTips28:addChild(txtTitle)

	--分割线
	local imgLine1 = WZUIImage:create()
	imgLine1:setFile("ui/common/common_scale9_fengexian.png")
	imgLine1:setUseOriginSize(true)
	imgLine1:setScaleX(1.5)
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
	conTips28:addChild(imgLine1)

	--属性
	local text2 = [[<T C="127,70,26" S="20" >%s:</T><T C="5,180,0" S="20" > +%d</T>]]
	local pointX = 0.06
	local pointY = 0.78
	for i = 1, #tData.property do
		local ftxtProperty1 = WZUIFreeTextBox:create()
		ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
		ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.108))
		ftxtProperty1:setMaxWidth(500)
		ftxtProperty1:setShowText(string.format(text2,ATTR_TITLE[tData.property[i][1]], tData.property[i][2]))
		conTips28:addChild(ftxtProperty1)
	end
	--分割线2
	local imgLine2 = WZUIImage:create()
	imgLine2:setFile("ui/common/common_scale9_fengexian.png")
	imgLine2:setUseOriginSize(true)
	imgLine2:setScaleX(1.5)
	imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.3))
	conTips28:addChild(imgLine2)

	--收集的套数
	local text1 = [[<T C="127,70,26" S="22" >%s</T><T C="127,70,26" S="22" >%s</T>]]
	local ftxtFighting = WZUIFreeTextBox:create()
	ftxtFighting:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtFighting:setRelativePosition(GlobalMethod:ccp(pointX, 0.2))
	ftxtFighting:setMaxWidth(500)
	if tData.tabIndex == 1 then 
		local sSuitNum = string.format(LocalStrings.CASTSOUL_TEXT4, tData.suitNum)
		ftxtFighting:setShowText(string.format(text1, LocalStrings.CASTSOUL_TEXT16, sSuitNum))
	elseif tData.tabIndex == 2 then 
		local sSuitNum = string.format(LocalStrings.CASTSOUL_TEXT4, tData.suitNum)
		ftxtFighting:setShowText(string.format(text1, LocalStrings.CASTSOUL_TEXT17, sSuitNum))
	elseif tData.tabIndex == 3 then 
		local sSuitNum = tData.suitNum .. LocalStrings.SHOP_IND
		ftxtFighting:setShowText(string.format(text1, LocalStrings.OTHER_TEXT1[4], sSuitNum))
	end
	conTips28:addChild(ftxtFighting)

	--战力加成
	local text1 = [[<T C="127,70,26" S="22" >%s</T><T C="5,180,0" S="22" > +%d</T>]]
	local ftxtFighting = WZUIFreeTextBox:create()
	ftxtFighting:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtFighting:setRelativePosition(GlobalMethod:ccp(pointX, 0.1))
	ftxtFighting:setMaxWidth(500)
	ftxtFighting:setShowText(string.format(text1,LocalStrings.BATTLE .. ":", tData.fighting))
	conTips28:addChild(ftxtFighting)
end

--@brief	宠物属性tips
function WndTips:_update63()
	WZLog("WndTips:_update63")
	local tData = self.m_tData

	if tData.showType == 1 then
		local conPet = GetElement(self.m_root,"conPet_WndTips62",WZUIContainer)
		conPet:setVisible(true)
		local conBG = GetElement(self.m_root,"conBG_WndTips62",WZUIContainer)
		conBG:setAbsContentSize(GlobalMethod:CCSize(242,280))
		conBG:updateRelativeSize()

		local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndTips62",WZUILabelTTF)
		local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndTips62",WZUILabelTTF)
		local txtPetHPD = GetElement(self.m_root,"txtPetHPD_WndTips62",WZUILabelTTF)
		local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndTips62",WZUILabelTTF)
		txtPetAPD:setText(tData.petAP)
		txtPetDPD:setText(tData.petDP)
		txtPetHPD:setText(tData.petHP)
		txtPetSPD:setText(tData.petSP)

		local txtQualification1 = GetElement(self.m_root,"txtQualification1_WndTips62",WZUILabelTTF)
		local txtQualification2 = GetElement(self.m_root,"txtQualification2_WndTips62",WZUILabelTTF)
		txtQualification1:setText(tData.qualification1)
		txtQualification2:setText(tData.qualification2)

		local txtPetNum = GetElement(self.m_root,"txtPetNum_WndTips62",WZUILabelTTF)
		txtPetNum:setText(tData.petNum)
		
		if ProjConfig.LANGUAGE == "vn" then
			txtQualification1:setFontSize(16)
			txtQualification2:setFontSize(16)
		end
	elseif tData.showType == 2 then
		local conPet = GetElement(self.m_root,"conPet_WndTips62",WZUIContainer)
		conPet:setVisible(true)
		local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndTips62",WZUILabelTTF)
		local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndTips62",WZUILabelTTF)
		local txtPetHPD = GetElement(self.m_root,"txtPetHPD_WndTips62",WZUILabelTTF)
		local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndTips62",WZUILabelTTF)
		txtPetAPD:setText(tData.petAP)
		txtPetDPD:setText(tData.petDP)
		txtPetHPD:setText(tData.petHP)
		txtPetSPD:setText(tData.petSP)

		local txtQualification1 = GetElement(self.m_root,"txtQualification1_WndTips62",WZUILabelTTF)
		local txtQualification2 = GetElement(self.m_root,"txtQualification2_WndTips62",WZUILabelTTF)
		txtQualification1:setText(tData.qualification1)
		txtQualification2:setText(tData.qualification2)

		local txtPetNum = GetElement(self.m_root,"txtPetNum_WndTips62",WZUILabelTTF)
		txtPetNum:setText(tData.petNum)

		local conBG = GetElement(self.m_root,"conBG_WndTips62",WZUIContainer)
		conBG:setAbsContentSize(GlobalMethod:CCSize(242,390))
		conBG:updateRelativeSize()
		local conDesc1 = GetElement(self.m_root,"conDesc1_WndTips62",WZUIContainer)
		conDesc1:setVisible(true)
		local txtDesc1 = GetElement(self.m_root,"txtDesc1_WndTips62",WZUILabelTTF)
		txtDesc1:setText(string.format(LocalStrings.PET_FETTER2, GDatatab_button_info["id_150"].open_level))
	elseif tData.showType == 3 then
		local conMount = GetElement(self.m_root,"conMount_WndTips62",WZUIContainer)
		conMount:setVisible(true)
		local conBG = GetElement(self.m_root,"conBG_WndTips62",WZUIContainer)
		local conHeight = 480
		
		local txtMountName = GetElement(self.m_root,"txtMountName_WndTips62",WZUILabelTTF)
		local lv = tData.tMountData[tData.curSelIndex].upgradeLevel and "Lv"..tData.tMountData[tData.curSelIndex].upgradeLevel or ""
		local name = tData.tMountData[tData.curSelIndex].basicInfo.name
		txtMountName:setText(lv.." "..name)
		txtMountName:setColor(QUALITYCOLOR[tData.tMountData[tData.curSelIndex].basicInfo.quality])
		
		local _,pro = WndMounts:_getProperty(tData.tMountData[tData.curSelIndex].property)
	    local str = {LocalStrings.PETHEALTH,LocalStrings.PETATTACK,LocalStrings.PETDEFENSE,LocalStrings.MOUNT_SPEED,LocalStrings.MOUNT_LUCKY}
	    for i = 1, 5 do
	        local txtMountName = GetElement(self.m_root,"txtMountName"..i.."_WndTips62",WZUILabelTTF)
	        txtMountName:setText(str[i])
	        local txtMountNum = GetElement(self.m_root,"txtMountNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountNum:setText(pro[i])
	    end
		local txtMountAttr = GetElement(self.m_root,"txtMountAttr_WndTips62",WZUILabelTTF)
		txtMountAttr:setText(LocalStrings.MOUNTS_PRE_ADD)
	    
    	local attrs = {hp=0,attack=0,defend=0,critRate=0,reduceCrit=0}
    	local fight = 0
    	local haveCnt = 0
		for k,v in pairs(tData.tMountData) do
	        -- 对属性数据进行修改
	        if v.isHave then
	            local t = WndMounts:_getProperty(v.property)
	            attrs.hp = attrs.hp + t.hp
	            attrs.attack = attrs.attack + t.attack
	            attrs.defend = attrs.defend + t.defend
	            attrs.critRate = attrs.critRate + t.crit
	            attrs.reduceCrit = attrs.reduceCrit + t.reduceCrit
	        	fight = fight + WndMounts:getFight(v.property)
	        	haveCnt = haveCnt + 1
	        end
	    end
	    for i = 1, 5 do
	        local txtMountTotal = GetElement(self.m_root,"txtMountTotal"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotal:setText(str[i])
	        local tempAttr = {attrs.hp,attrs.attack,attrs.defend,attrs.critRate,attrs.reduceCrit}
	        local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotalNum:setText(tempAttr[i])
	    end
		local txtMountFightName = GetElement(self.m_root,"txtMountFightName_WndTips62",WZUILabelTTF)
	    txtMountFightName:setText(LocalStrings.PET_TEXT17)
		local txtMountFightNum = GetElement(self.m_root,"txtMountFightNum_WndTips62",WZUILabelTTF)
	    txtMountFightNum:setText(fight)
		local txtMountDesc = GetElement(self.m_root,"txtMountDesc_WndTips62",WZUILabelTTF)
		txtMountDesc:setText(LocalStrings.MOUNT_ALL_ADD)

		local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum_WndTips62",WZUILabelTTF)
		txtMountTotalNum:setText(LocalStrings.PET_TEXT18)
		local txtMountNum = GetElement(self.m_root,"txtMountNum_WndTips62",WZUILabelTTF)
		txtMountNum:setText(haveCnt.."/"..#tData.tMountData)
		--灵石特殊效果附件属性
		if tData.tStoneSpecialPro and #tData.tStoneSpecialPro > 0 then
			local conLine = GetElement(self.m_root, "conLine_WndTips62", WZUIContainer)
			conLine:setVisible(true)
			local conExtPro = GetElement(self.m_root, "conExtPro_WndTips62", WZUIContainer)
			local rawNum = math.ceil(#tData.tStoneSpecialPro/2)
			conExtPro:setAbsContentSize(GlobalMethod:CCSize(300, 35*(rawNum + 1)))
			conExtPro:updateRelativeSize()
			conHeight = conHeight + 35 * (rawNum * 1)
			local text2 = [[<T C="127,70,26" S="20" >%s:</T><T C="229,105,22" S="20" >%d</T>]]
			local pointX = 0.075
			local nPadding = 1/((rawNum + 1) * 2)
			local pointY = 1 - nPadding
			local tempTitle = createLabel(LocalStrings.MOUNTS_STONE_ADD, GlobalMethod:ccp(pointX, pointY), GlobalMethod:ccp(0, 0.5), 22, GlobalMethod:ccc3(127,70,26))
			conExtPro:addChild(tempTitle)
			
			pointY = 1 - nPadding - nPadding * 1.8
			for i = 1, rawNum do
				local nIndex = (i - 1) * 2 + 1 
				local ftxtProperty1 = WZUIFreeTextBox:create()
				ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * nPadding * 1.8))
				ftxtProperty1:setMaxWidth(500)
				ftxtProperty1:setShowText(string.format(text2,ATTR_TITLE[tData.tStoneSpecialPro[nIndex][1]], tData.tStoneSpecialPro[nIndex][2]))
				conExtPro:addChild(ftxtProperty1)

				if tData.tStoneSpecialPro[nIndex + 1] then 
					local ftxtProperty2 = WZUIFreeTextBox:create()
					ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
					ftxtProperty2:setRelativePosition(GlobalMethod:ccp(pointX + 0.46, pointY - (i - 1) * nPadding * 1.8))
					ftxtProperty2:setMaxWidth(500)
					ftxtProperty2:setShowText(string.format(text2,ATTR_TITLE[tData.tStoneSpecialPro[nIndex + 1][1]], tData.tStoneSpecialPro[nIndex + 1][2]))
					conExtPro:addChild(ftxtProperty2)
				end
			end
		end
		conBG:setAbsContentSize(GlobalMethod:CCSize(300, conHeight))
		conBG:updateRelativeSize()

		if ProjConfig.LANGUAGE == "vn" then
			txtMountDesc:setFontSize(16)
		end
	elseif tData.showType == 4 then --足迹
		local conMount = GetElement(self.m_root,"conMount_WndTips62",WZUIContainer)
		conMount:setVisible(true)
		local conBG = GetElement(self.m_root,"conBG_WndTips62",WZUIContainer)
		conBG:setAbsContentSize(GlobalMethod:CCSize(300,480))
		conBG:updateRelativeSize()
		
		local txtMountName = GetElement(self.m_root,"txtMountName_WndTips62",WZUILabelTTF)
		local lv = tData.tMountData[tData.curSelIndex].upgradeLevel and "Lv"..tData.tMountData[tData.curSelIndex].upgradeLevel or ""
		local name = tData.tMountData[tData.curSelIndex].basicInfo.name
		txtMountName:setText(lv.." "..name)
		txtMountName:setColor(QUALITYCOLOR[tData.tMountData[tData.curSelIndex].basicInfo.quality])
		
		local _, tProperty, tAttr = WndFootMark:_getProperty(tData.tMountData[tData.curSelIndex].property)
	    local str = {LocalStrings.PETHEALTH,LocalStrings.PETATTACK,LocalStrings.PETDEFENSE,LocalStrings.MOUNT_SPEED,LocalStrings.MOUNT_LUCKY}
	    for i = 1, 5 do
	        local txtMountName = GetElement(self.m_root,"txtMountName"..i.."_WndTips62",WZUILabelTTF)
	        txtMountName:setText(ATTR_TITLE[tAttr[i]])
	        local txtMountNum = GetElement(self.m_root,"txtMountNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountNum:setText(tProperty[i])
	    end
		local txtMountAttr = GetElement(self.m_root,"txtMountAttr_WndTips62",WZUILabelTTF)
		txtMountAttr:setText(LocalStrings.FOOTMARK_TEXT10)
	    
    	local attrs = {hp=0,attack=0,defend=0,critRate=0,reduceCrit=0}
    	local fight = 0
    	local haveCnt = 0
		for k,v in pairs(tData.tMountData) do
	        -- 对属性数据进行修改
	        if v.isHave then
	            local t = WndFootMark:_getProperty(v.property)
	            attrs.hp = attrs.hp + t.hp
	            attrs.attack = attrs.attack + t.attack
	            attrs.defend = attrs.defend + t.defend
	            attrs.critRate = attrs.critRate + t.crit
	            attrs.reduceCrit = attrs.reduceCrit + t.reduceCrit
	        	fight = fight + WndFootMark:getFight(v.property)
	        	haveCnt = haveCnt + 1
	        end
	    end
	    for i = 1, 5 do
	        local txtMountTotal = GetElement(self.m_root,"txtMountTotal"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotal:setText(str[i])
	        local tempAttr = {attrs.hp,attrs.attack,attrs.defend,attrs.critRate,attrs.reduceCrit}
	        local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotalNum:setText(tempAttr[i])
	    end
		local txtMountFightName = GetElement(self.m_root,"txtMountFightName_WndTips62",WZUILabelTTF)
	    txtMountFightName:setText(LocalStrings.PET_TEXT17)
		local txtMountFightNum = GetElement(self.m_root,"txtMountFightNum_WndTips62",WZUILabelTTF)
	    txtMountFightNum:setText(fight)
		local txtMountDesc = GetElement(self.m_root,"txtMountDesc_WndTips62",WZUILabelTTF)
		txtMountDesc:setText(LocalStrings.FOOTMARK_TEXT11)

		local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum_WndTips62",WZUILabelTTF)
		txtMountTotalNum:setText(LocalStrings.PET_TEXT20)
		local txtMountNum = GetElement(self.m_root,"txtMountNum_WndTips62",WZUILabelTTF)
		txtMountNum:setText(haveCnt.."/"..#tData.tMountData)

		if ProjConfig.LANGUAGE == "vn" then
			txtMountDesc:setFontSize(16)
		end
	elseif tData.showType == 5 then --皮肤
		local conMount = GetElement(self.m_root,"conMount_WndTips62",WZUIContainer)
		conMount:setVisible(true)
		local conBG = GetElement(self.m_root,"conBG_WndTips62",WZUIContainer)
		local nProCount = math.ceil(#tData.totalPro/2)
		if nProCount > 4 then 
			local nRealH = 480 + 30 * (nProCount - 4)
			conBG:setAbsContentSize(GlobalMethod:CCSize(300,nRealH))
			conMount:setAbsContentSize(GlobalMethod:CCSize(300,nRealH-50))
			conMount:updateRelativeSize()
		else
			conBG:setAbsContentSize(GlobalMethod:CCSize(300,480))
			conMount:setAbsContentSize(GlobalMethod:CCSize(300,480 - 50))
			conMount:updateRelativeSize()
		end
		conBG:updateRelativeSize()
		
		local txtMountName = GetElement(self.m_root,"txtMountName_WndTips62",WZUILabelTTF)
		local name = tData.curData.name
		txtMountName:setText(name)
		txtMountName:setColor(QUALITYCOLOR[tData.curData.quality])
		
		local tProperty = tData.curData.curProperty
		if tProperty == nil then 
			tProperty = tData.curData.property
		end
		WZLog("KKKKKKKKKKKKKKKKKKK", #tProperty, Serialize(tProperty))
		--当前属性
		for i = 1, 6 do
	        local txtMountName = GetElement(self.m_root,"txtMountName"..i.."_WndTips62",WZUILabelTTF)
	        txtMountName:setText("")
	        local txtMountNum = GetElement(self.m_root,"txtMountNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountNum:setText("")
	    end

	    for i = 1, #tProperty do
	        local txtMountName = GetElement(self.m_root,"txtMountName"..i.."_WndTips62",WZUILabelTTF)
	        if txtMountName then 
	        	txtMountName:setText(ATTR_TITLE[tProperty[i][1]])
	        end
	        local txtMountNum = GetElement(self.m_root,"txtMountNum"..i.."_WndTips62",WZUILabelTTF)
	        if txtMountNum then 
	        	txtMountNum:setText(tProperty[i][2])
	        end
	    end
		local txtMountAttr = GetElement(self.m_root,"txtMountAttr_WndTips62",WZUILabelTTF)
		txtMountAttr:setText(LocalStrings.MULCOPY_TEXT7)
	    
    	--总属性
    	for i = 1, 12 do
	        local txtMountTotal = GetElement(self.m_root,"txtMountTotal"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotal:setText("")
	        local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotalNum:setText("")
	    end
	    for i = 1, #tData.totalPro do
	        local txtMountTotal = GetElement(self.m_root,"txtMountTotal"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotal:setText(ATTR_TITLE[tData.totalPro[i][1]])
	        local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum"..i.."_WndTips62",WZUILabelTTF)
	        txtMountTotalNum:setText(tData.totalPro[i][2])
	    end

		local txtMountFightName = GetElement(self.m_root,"txtMountFightName_WndTips62",WZUILabelTTF)
	    txtMountFightName:setText(LocalStrings.PET_TEXT17)
		local txtMountFightNum = GetElement(self.m_root,"txtMountFightNum_WndTips62",WZUILabelTTF)
	    txtMountFightNum:setText(tData.fighting)
		local txtMountDesc = GetElement(self.m_root,"txtMountDesc_WndTips62",WZUILabelTTF)
		txtMountDesc:setText(LocalStrings.MULCOPY_TEXT6)

		local txtMountTotalNum = GetElement(self.m_root,"txtMountTotalNum_WndTips62",WZUILabelTTF)
		txtMountTotalNum:setText(LocalStrings.MULCOPY_TEXT8)
		local txtMountNum = GetElement(self.m_root,"txtMountNum_WndTips62",WZUILabelTTF)
		txtMountNum:setText(tData.ownNum)

		if ProjConfig.LANGUAGE == "vn" then
			txtMountDesc:setFontSize(16)
		end
	end
end

--@brief	翻倍活动的tips
function WndTips:_update64()
	WZLog("WndTips:_update64")
	local tData = self.m_tData

	local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
	conType5:setVisible(true)

	local bgType5 = GetElement(self.m_root,"bgType5_WndTips",WZUI9Image)
	bgType5:setFile("ui/common/frame_tips_di.png")


	if tData and tData.type == 1 then
		
		local txt1Type5 = GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox)
		txt1Type5:setShowText(LocalStrings.AUCTION_HOUSE_TEXT33)
		txt1Type5:setMaxWidth(270)
		conType5:setAbsContentSize(GlobalMethod:CCSize(300,txt1Type5:getContentSize().height))
		txt1Type5:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		txt1Type5:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	else
		local txt2Type5 = GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox)
		txt2Type5:setShowText(LocalStrings.CRAZY_DOUBLING_TEXT1)
		txt2Type5:setMaxWidth(260)
		conType5:setAbsContentSize(GlobalMethod:CCSize(275,txt2Type5:getContentSize().height))
		txt2Type5:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
	end

	conType5:updateRelativeSize()
end

--@brief 试练塔奖励预览
function WndTips:_update65()
	WZLog("WndTips:_update65")
	local tData = self.m_tData
	local conType65 = GetElement(self.m_root,"conType65_WndTips",WZUIContainer)
	conType65:setVisible(true)
	local txt1 = GetElement(self.m_root,"txtWhile_WndTips65",WZUILabelTTF)
	local txt2 = GetElement(self.m_root,"txtCan_WndTips65",WZUILabelTTF)
	txt2:setText(string.format(LocalStrings.SWEPT_TEXT2,1,tData.topFloor))
	local reward_container = GetElement(self.m_root,"conReward2_WndTips65",WZUIContainer)
	local while_reward = GetElement(self.m_root,"conReward1_WndTips65",WZUIContainer)
	local expTxt = GetElement(self.m_root,"expTxt_WndTips65",WZUILabelTTF)
	local goldTxt = GetElement(self.m_root,"goldTxt_WndTips65",WZUILabelTTF)

	local mapInfo = {}
	local rewardInfo = {}
	local whileReward = {}
	local floor_reward = {}
	local num1 = 0
	local num2 = 0
	local itemIndex = 1
	rewardInfo[itemIndex] = {id=0,num=0}
	if tData.topFloor < 1 then 
		GetElement(self.m_root, "conSweepTitle1_WndTips65", WZUIContainer):setVisible(false)
		conType65:setAbsContentSize(GlobalMethod:CCSize(470,140))
		conType65:updateRelativeSize()
	end
	if tData.topFloor >= 200 then 
		GetElement(self.m_root, "conSweepTitle2_WndTips65", WZUIContainer):setVisible(false)
		conType65:setAbsContentSize(GlobalMethod:CCSize(470,140))
		conType65:updateRelativeSize()
	end

	for i = 1,tData.topFloor do
		if i < 10 then
			mapInfo = GDatatab_tower_map["id_4000"..i] or GDatatab_tower_map["id_40001"]
		elseif i>=10 and i < 100 then 
			mapInfo = GDatatab_tower_map["id_400"..i] or GDatatab_tower_map["id_40001"]
		else 
			mapInfo = GDatatab_tower_map["id_40"..i] or GDatatab_tower_map["id_40001"]
		end
		for k = 1, #mapInfo.fixed_reward do
			if mapInfo.fixed_reward[k][1] == 2 then 
				num1 = num1 + mapInfo.fixed_reward[k][2]
			elseif mapInfo.fixed_reward[k][1] == 3 then 
				num2 = num2 + mapInfo.fixed_reward[k][2]
			end
		end
		if mapInfo.floor_reward == -1 then 

		else 
			for j = 1,#mapInfo.floor_reward do
				floor_reward[itemIndex] = {item_id = mapInfo.floor_reward[j][1],item_num=mapInfo.floor_reward[j][2]}
				itemIndex = itemIndex + 1
			end
		end
	end
	rewardInfo = self:syntheticItemData(floor_reward)

	expTxt:setText(num2)
	goldTxt:setText(num1)
	for x,v in ipairs(rewardInfo) do
		local key = "id_"..v.item_id
		if GDatatab_item[key] then
			local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = v.item_num
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 17)
		    celElement:setScale(0.8)
			reward_container:addChild(celElement)
			tLuaObj:setItemClickFun(WndTips,self.onRewardItemClick)
			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp((x+1)*70-105,32))
		end
	end

	for y = tData.topFloor + 1,200 do
		if y < 10 then
			whileReward = GDatatab_tower_map["id_4000"..y] or GDatatab_tower_map["id_40001"]
		elseif y>=10 and y < 100 then 
			whileReward = GDatatab_tower_map["id_400"..y] or GDatatab_tower_map["id_40001"]
		else 
			whileReward = GDatatab_tower_map["id_40"..y] or GDatatab_tower_map["id_40001"]
		end
		if whileReward.one_reward ~= -1 then
			txt1:setText(string.format(LocalStrings.SWEPT_TEXT1,y))
			for z,v in ipairs(whileReward.one_reward) do
				local key = "id_"..v[1]
				if GDatatab_item[key] then
					local name = GDatatab_item[key].name
				    local path = GDatatab_item[key].icon
				    local quality = GDatatab_item[key].quality
				    local num = v[2]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
				    local celElement,tLuaObj = CellGoodItem:createElement()
				    tLuaObj:setCellGoodItem(itemInfo, 17)
				    celElement:setScale(0.8)
					while_reward:addChild(celElement)
					tLuaObj:setItemClickFun(WndTips,self.onRewardItemClick)
					celElement:setUseAbsCoordinate(true)
					celElement:setAbsPosition(GlobalMethod:ccp((z+1)*70-105,32))
				end
			end
			return
		end
	end
end

function WndTips:syntheticItemData(itemData)
    local item2 = {}
    for i=1,#itemData do
        local bIsExist = false
        local index = 0
        for j=1,#item2 do
            if itemData[i].item_id == item2[j].item_id then
                bIsExist = true
                index = j
            end
        end
        if bIsExist == false then
            local temp = {}
            temp.item_id = itemData[i].item_id
            temp.item_num = itemData[i].item_num
            table.insert(item2,temp)
        else
            item2[index].item_num = item2[index].item_num + itemData[i].item_num
        end
    end
    return item2
end

--@brief	婚礼buff的tips
function WndTips:_update66()
	WZLog("WndTips:_update66")
	if self.m_tData == nil then return end
	local tData = self.m_tData

	local conType20 = GetElement(self.m_root,"conType20_WndTips",WZUIContainer)
	conType20:setAbsContentSize(GlobalMethod:CCSize(242,340))
	conType20:updateRelativeSize()
	local imgHeadType20 = GetElement(self.m_root,"imgHeadType20_WndTips",WZUIImage)
	imgHeadType20:setFile("ui/common/common_icon_hunyan.png")
	imgHeadType20:setScale(0.65)
	imgHeadType20:setRelativePosition(GlobalMethod:ccp(0.217,0.85))
	local ttf1Type20 = GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF)
	ttf1Type20:setRelativePosition(GlobalMethod:ccp(0.4,0.85))
	ttf1Type20:setText(LocalStrings.LV..tData.wedBufLevel..LocalStrings.MARRY_DESC_30)

	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips20", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end

	local ttf2Type20 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
	ttf2Type20:setVisible(false)
	local txtRankLvType20 = GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont)
	txtRankLvType20:setVisible(false)
	local ttf3Type20 = GetElement(self.m_root,"ttf3Type20_WndTips",WZUILabelTTF)
	ttf3Type20:setTextKey("")
	ttf3Type20:setVisible(true)
	ttf3Type20:setText(LocalStrings.MARRY_DESC_29)
	ttf3Type20:setRelativePosition(GlobalMethod:ccp(0.5,0.64))
	ttf3Type20:setDimensions(GlobalMethod:CCSize(220,0))
	
	local conAttr = GetElement(self.m_root,"conAttr_WndTips20",WZUIContainer)
	conAttr:setRelativePosition(GlobalMethod:ccp(0.5,0.59))
	local txtFight = GetElement(self.m_root,"txtFight_WndTips20",WZUILabelTTF)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.1,0.4))

	local imgLine1 = GetElement(self.m_root,"imgLine1_WndTips20",WZUIImage)
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5,0.72))
	local imgLine2 = GetElement(self.m_root,"imgLine2_WndTips20",WZUIImage)
	imgLine2:setRelativePosition(GlobalMethod:ccp(0.5,0.56))
	local imgLine3 = GetElement(self.m_root,"imgLine3_WndTips20",WZUIImage)
	imgLine3:setRelativePosition(GlobalMethod:ccp(0.5,0.14))
	imgLine3:setVisible(true)

	--剩余时间
	local txtTimeType20 = GetElement(self.m_root,"txtTimeType20_WndTips",WZUILabelTTF)
	txtTimeType20:setVisible(true)
	local nTime = tData.wedBufTime - SystemTime:getServerTime()
	if nTime > 0 then
		local s = nTime % 60
		local m = math.floor(nTime / 60 % 60)
		local h = math.floor(nTime / 3600)
		local sFormat = LocalStrings.REMAIN_TIME.."%02d:%02d:%02d"
		txtTimeType20:setText(string.format(sFormat,h,m,s))
		txtTimeType20:enableSchedule("_update66Schedule",1)
	else
		txtTimeType20:setText(LocalStrings.MONTH_CARDS_TIP6)
	end

	--属性加成
	GetElement(self.m_root,"label1Type20_WndTips",WZUILabelTTF):setText(tData.attr1)
	GetElement(self.m_root,"label2Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal1)
	if tData.attr2 ~= nil then
		GetElement(self.m_root,"label3Type20_WndTips",WZUILabelTTF):setText(tData.attr2)
		GetElement(self.m_root,"label4Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal2)
	else
		GetElement(self.m_root,"label3Type20_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label4Type20_WndTips",WZUILabelTTF):setVisible(false)
	end
	if tData.attr3 ~= nil then
		GetElement(self.m_root,"label5Type20_WndTips",WZUILabelTTF):setText(tData.attr3)
		GetElement(self.m_root,"label6Type20_WndTips",WZUILabelTTF):setText("+"..tData.attrVal3)
	else
		GetElement(self.m_root,"label5Type20_WndTips",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"label6Type20_WndTips",WZUILabelTTF):setVisible(false)
	end

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF):setScale(0.7)
		GetElement(self.m_root,"txtFight_WndTips20",WZUILabelTTF):setScale(0.7)
	end
end

--@brief    计算buff剩余时间
function WndTips:_update66Schedule(element)
	local txtTimeType20 = GetElement(self.m_root,"txtTimeType20_WndTips",WZUILabelTTF)
	local nTime = self.m_tData.wedBufTime - SystemTime:getServerTime()
	if nTime > 0 then
		local s = nTime % 60
		local m = math.floor(nTime / 60 % 60)
		local h = math.floor(nTime / 3600)
		local sFormat = LocalStrings.REMAIN_TIME.."%02d:%02d:%02d"
		txtTimeType20:setText(string.format(sFormat,h,m,s))
	else
		txtTimeType20:setText(LocalStrings.MONTH_CARDS_TIP6)
		txtTimeType20:disableSchedule()
	end
end

--@ 空间修炼属性总览 
--@note 	id : 76皮肤装备
function WndTips:_update67()
	-- body
	WZLog("WndTips:_update67")
	local tData = self.m_tData
	if tData == nil then
		return
	end

	local tEquipData = nil
	local tEquipData1 = nil

	WZLog("空间修炼属性总览",tData.id)
	local attrList = {}
	local attrList1 = {}
	local conTips28 = GetElement(self.m_root,"conTips28_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(340, 278))
	conTips28:updateRelativeSize()

	local txtTitle = WZUILabelTTF:create()
	txtTitle:setColor(GlobalMethod:ccc3(127,70,26))
	txtTitle:setFontSize(24)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.91))
	conTips28:addChild(txtTitle)

	--分割线
	local imgLine1 = WZUIImage:create()
	imgLine1:setFile("ui/common/common_scale9_fengexian.png")
	imgLine1:setUseOriginSize(true)
	imgLine1:setScaleX(1.5)
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
	conTips28:addChild(imgLine1)

	--分割线2
	local imgLine2 = WZUIImage:create()
	imgLine2:setFile("ui/common/common_scale9_fengexian.png")
	imgLine2:setUseOriginSize(true)
	imgLine2:setScaleX(1.5)
	imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.18))
	if tData.id == 71 or tData.id == 72 or tData.id == 73 then
		imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.28))
	end 	
	if tData.id == 75 or tData.id == 76 then
		imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.30))
	end	
	conTips28:addChild(imgLine2)
	for i=1,21 do
		attrList[tostring(i)] = 0
		attrList1[tostring(i)] = 0
	end

	local text2 = [[<T C="127,70,26" S="20" >%s:</T><T C="5,180,0" S="20" >%d</T>]]
	local text21 = [[<T C="127,70,26" S="20" >%s:</T><T C="5,180,0" S="20" >%d(%d)</T><I Z="0.5" P="1" >%s</I>]]
	local text3 = [[<T C="127,70,26" S="20" >%s</T><T C="5,180,0" S="20" >%d</T>]]

	local fighting = 0
	local fighting1 = 0
	if tData.id == 67 then
		local xlId = CacheCenter:getPlayerInfo().xlId
		local xlId1 = WndCheckOther.m_tPlayerInfo.xlId

		for i = 1,#xlId do
			local property = GDatatab_upgrade_attr["id_"..xlId[i]].attr
			for j = 1,#property do
				attrList[tostring(property[j][1])] = attrList[tostring(property[j][1])] + property[j][2]
			end
		end
 		for i = 1,#xlId1 do 
 			local property1 = GDatatab_upgrade_attr["id_"..xlId1[i]].attr
			for j = 1,#property1 do
				attrList1[tostring(property1[j][1])] = attrList1[tostring(property1[j][1])] + property1[j][2]
			end
		end
	elseif tData.id == 68 then
		local sSoul = CacheCenter.m_tPlayerInfo.soulInfoJson
		local sSoul1 = WndCheckOther.m_tPlayerInfo.soulInfoJson

		if sSoul ~= "" then 
			local tempSoulInfo = json.decode(sSoul)
			local tempStr = string.gsub(tempSoulInfo.property, " ", "")
			local str1 = string.sub(tempStr, 2, -2) 
			local tempArray = SplitStringWithSeparator(str1, ",")
			for i = 1, #tempArray do
				local index = SplitStringWithSeparator(tempArray[i], "=")[1]
				attrList[index] = SplitStringWithSeparator(tempArray[i], "=")[2]
			end
		end
		
		if sSoul1 ~= "" then 
			local tempSoulInfo = json.decode(sSoul1)
			local tempStr = string.gsub(tempSoulInfo.property, " ", "")
			local str1 = string.sub(tempStr, 2, -2) 
			local tempArray = SplitStringWithSeparator(str1, ",")
			for i = 1, #tempArray do
				local index = SplitStringWithSeparator(tempArray[i], "=")[1]
				attrList1[index] = SplitStringWithSeparator(tempArray[i], "=")[2]
			end
		end
	elseif tData.id == 69 then
		local runeId = CacheCenter:getPlayerInfo().runeItemId
		local runeId1 = WndCheckOther.m_tPlayerInfo.runeItemId
		local rpIds = CacheCenter:getPlayerInfo().rpIds
		local rpIds1 = WndCheckOther.m_tPlayerInfo.rpIds
		local data = {}
		local data1 = {}
		if runeId and next(runeId) then
			for i = 1,#runeId do
				table.insert(data, {item_id = runeId[i], item_num = CacheCenter:getPlayerInfo().runeItemNum[i]})
			end
		end
		if runeId1 and next(runeId1) then
			for i = 1,#runeId1 do
				table.insert(data1, {item_id = runeId1[i], item_num = WndCheckOther.m_tPlayerInfo.runeItemNum[i]})
			end
		end
		if data and next(data) then
			for i = 1,#data do
				local num = data[i]["item_num"]
				local property = GDatatab_item["id_"..data[i]["item_id"]].property
				-- WZLog("打印符文的属性",Serialize(property))
				for j = 1,#property do
					attrList[tostring(property[j][1])] = attrList[tostring(property[j][1])] + property[j][2] * num
				end
			end
		end
		if rpIds and next(rpIds) then
			for i = 1,#rpIds do
				local property = GDatatab_rune_level["id_"..rpIds[i]].property
				for j = 1,#property do
					attrList[tostring(property[j][1])] = attrList[tostring(property[j][1])] + property[j][2]
				end
			end	
		end
		if data1 and next(data1) then
			for i = 1,#data1 do
				local num = data1[i]["item_num"]
				local property = GDatatab_item["id_"..data1[i]["item_id"]].property
				-- WZLog("打印符文的属性",Serialize(property))
				for j = 1,#property do
					attrList1[tostring(property[j][1])] = attrList1[tostring(property[j][1])] + property[j][2] * num
				end
			end
		end
		if rpIds1 and next(rpIds1) then
			for i = 1,#rpIds1 do
				local property = GDatatab_rune_level["id_"..rpIds1[i]].property
				for j = 1,#property do
					attrList1[tostring(property[j][1])] = attrList1[tostring(property[j][1])] + property[j][2]
				end
			end	
		end
	elseif tData.id == 71 then
		local allMount = CacheCenter:getPlayerInfo().allMountsMessage
		if allMount and next(allMount) then
			for i =1,#allMount do
				local mount = json.decode(allMount[i])
				fighting = fighting + mount["fighting"]
				attrList["1"] = attrList["1"] + mount["1"]
				attrList["3"] = attrList["3"] + mount["3"]
				attrList["4"] = attrList["4"] + mount["4"]
				attrList["12"] = attrList["12"] + mount["12"]
				attrList["13"] = attrList["13"] + mount["13"]
			end
		end
		local ftxtProperty1 = WZUIFreeTextBox:create()
		ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
		ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.5, 0.2))
		ftxtProperty1:setMaxWidth(500)
		ftxtProperty1:setShowText(string.format(text2,LocalStrings.MOUNT_NUM, #allMount))
		conTips28:addChild(ftxtProperty1)	
			
		local allMount1 = WndCheckOther.m_tPlayerInfo.mountsMessage
		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			if allMount1 and next(allMount1) then
				for i =1,#allMount1 do
					local mount = json.decode(allMount1[i])
					fighting1 = fighting1 + mount["fighting"]
					attrList1["1"] = attrList1["1"] + mount["1"]
					attrList1["3"] = attrList1["3"] + mount["3"]
					attrList1["4"] = attrList1["4"] + mount["4"]
					attrList1["12"] = attrList1["12"] + mount["12"]
					attrList1["13"] = attrList1["13"] + mount["13"]
				end
			end
			ftxtProperty1:setShowText(string.format(text2,LocalStrings.MOUNT_NUM, #allMount1))
		end
	elseif tData.id == 72 then
		local footMark = CacheCenter:getPlayerInfo().footMark
		local footMark1 = WndCheckOther.m_tPlayerInfo.footMark
		if footMark and next(footMark) then
			for i =1,#footMark do
				local foot = json.decode(footMark[i])
				fighting = fighting + foot["fighting"]
				attrList["1"] = attrList["1"] + foot["1"]
				attrList["3"] = attrList["3"] + foot["3"]
				attrList["4"] = attrList["4"] + foot["4"]
				attrList["12"] = attrList["12"] + foot["12"]
				attrList["13"] = attrList["13"] + foot["13"]
			end
		end
		local ftxtProperty1 = WZUIFreeTextBox:create()
		ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
		ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.5, 0.2))
		ftxtProperty1:setMaxWidth(500)
		ftxtProperty1:setShowText(string.format(text2,LocalStrings.FOOTMARK_NUM, #footMark))
		conTips28:addChild(ftxtProperty1)
		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			if footMark1 and next(footMark1) then
				for i =1,#footMark1 do
					if footMark1 and next(footMark1) then
						local foot = json.decode(footMark1[i])
						fighting1 = fighting1 + foot["fighting"]
						attrList1["1"] = attrList1["1"] + foot["1"]
						attrList1["3"] = attrList1["3"] + foot["3"]
						attrList1["4"] = attrList1["4"] + foot["4"]
						attrList1["12"] = attrList1["12"] + foot["12"]
						attrList1["13"] = attrList1["13"] + foot["13"]
					end
				end
			end
			ftxtProperty1:setShowText(string.format(text2,LocalStrings.FOOTMARK_NUM, #footMark1))
		end
	elseif tData.id == 73 then
		local shape = CacheCenter:getPlayerInfo().shape
		local shape1 = WndCheckOther.m_tPlayerInfo.shape

		if shape and shape ~= "" then
			for i = 1,#shape do
				local skin = json.decode(shape[i])
				local property = GDatatab_shape_skins["id_"..tonumber(skin["shapeId"])].property
				if skin["refineProperties"] ~= "{}" then
					local refineProperties = json.decode(skin["refineProperties"])
					local nFight = caculateClothesFighting(refineProperties)
					for j =1,20 do
						attrList[tostring(j)] = attrList[tostring(j)] + refineProperties[tostring(j)]
					end
				end
				for j = 1,#property do
					attrList[tostring(property[j][1])] = attrList[tostring(property[j][1])] + property[j][2]
				end
			end	
		end
		local ftxtProperty1 = WZUIFreeTextBox:create()
		ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
		ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.5, 0.2))
		ftxtProperty1:setMaxWidth(500)
		ftxtProperty1:setShowText(string.format(text2,LocalStrings.SKIN_NUM, #shape))
		conTips28:addChild(ftxtProperty1)
		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			if shape1 and next(shape1) then
				for i = 1,#shape1 do
					local skin = json.decode(shape1[i])
					local property = GDatatab_shape_skins["id_"..tonumber(skin["shapeId"])].property
					if skin["refineProperties"] ~= "{}" then
						local refineProperties = json.decode(skin["refineProperties"])
						local nFight = caculateClothesFighting(refineProperties)
						for j =1,20 do
							attrList1[tostring(j)] = attrList1[tostring(j)] + refineProperties[tostring(j)]
						end
					end
					for j = 1,#property do
						attrList1[tostring(property[j][1])] = attrList1[tostring(property[j][1])] + property[j][2]
					end
				end
			end	
			ftxtProperty1:setShowText(string.format(text2,LocalStrings.SKIN_NUM, #shape1))
		end
	elseif tData.id == 74 then
		local itemSuitId = CacheCenter:getPlayerInfo().itemSuitId
		local itemSuitNum = CacheCenter:getPlayerInfo().itemSuitNum
		local itemSuitId2 = CacheCenter:getPlayerInfo().itemSuitId2
		local itemSuitNum2 = CacheCenter:getPlayerInfo().itemSuitNum2

		if GDatatab_item_suit["id_"..itemSuitId] ~= nil and GDatatab_item_suit["id_"..itemSuitId]["suit_"..itemSuitNum] ~= nil then
			local suitAttr1 = GDatatab_item_suit["id_"..itemSuitId]["suit_"..itemSuitNum]
			for j=1,#suitAttr1 do
				if suitAttr1[j][2] ~= nil and suitAttr1[j][2] ~= 0 then
					attrList[tostring(suitAttr1[j][1])] = attrList[tostring(suitAttr1[j][1])] + suitAttr1[j][2]
				end
			end
		end
		if GDatatab_item_suit["id_"..itemSuitId2] ~= nil and GDatatab_item_suit["id_"..itemSuitId2]["suit_"..itemSuitNum2] ~= nil then
			local suitAttr2 = GDatatab_item_suit["id_"..itemSuitId2]["suit_"..itemSuitNum2]
			for j=1,#suitAttr2 do
				if suitAttr2[j][2] ~= nil and suitAttr2[j][2] ~= 0 then
					attrList[tostring(suitAttr2[j][1])] = attrList[tostring(suitAttr2[j][1])] + suitAttr2[j][2]
				end
			end
		end
		--加上装备属性
		local tEquipmentList = CacheCenter:getEquipedList()
		for j=1,#tEquipmentList do
			local extraInfo = tEquipmentList[j].extraInfo
			for i=1,20 do
				if extraInfo[tostring(i)] ~= nil and extraInfo[tostring(i)] ~= 0 then
					attrList[tostring(i)] = attrList[tostring(i)] + extraInfo[tostring(i)]
				end
			end
		end
		-- if attrList["2"] ~= 0 then
		-- 	attrList["1"] = attrList["1"] + attrList["2"]
		-- 	attrList["2"] = 0
		-- end	

		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			local itemSuitId1 = WndCheckOther.m_tPlayerInfo.itemSuitId
			local itemSuitNum1 = WndCheckOther.m_tPlayerInfo.itemSuitNum
			local itemSuitId21 = WndCheckOther.m_tPlayerInfo.itemSuitId2
			local itemSuitNum21 = WndCheckOther.m_tPlayerInfo.itemSuitNum2
			-- WZLog("好友的套裝id和件數",itemSuitId1,itemSuitNum1,itemSuitId21,itemSuitNum21)
			if GDatatab_item_suit["id_"..itemSuitId1] ~= nil and GDatatab_item_suit["id_"..itemSuitId1]["suit_"..itemSuitNum1] ~= nil then
				local suitAttr1 = GDatatab_item_suit["id_"..itemSuitId1]["suit_"..itemSuitNum1]
				for j=1,#suitAttr1 do
					if suitAttr1[j][2] ~= nil and suitAttr1[j][2] ~= 0 then
						attrList1[tostring(suitAttr1[j][1])] = attrList1[tostring(suitAttr1[j][1])] + suitAttr1[j][2]
					end
				end
			end
			if GDatatab_item_suit["id_"..itemSuitId21] ~= nil and GDatatab_item_suit["id_"..itemSuitId21]["suit_"..itemSuitNum21] ~= nil then
				local suitAttr2 = GDatatab_item_suit["id_"..itemSuitId21]["suit_"..itemSuitNum21]
				for j=1,#suitAttr2 do
					if suitAttr2[j][2] ~= nil and suitAttr2[j][2] ~= 0 then
						attrList1[tostring(suitAttr2[j][1])] = attrList1[tostring(suitAttr2[j][1])] + suitAttr2[j][2]
					end
				end
			end
			local tEquip = WndCheckOther.m_tPlayerInfo.item
			local m_tDataList = {}
			for i=1,#tEquip do
				for j=1,8 do
					if j == 1 then
						if tEquip[i].basicInfo.main_type == 4 and (tEquip[i].basicInfo.sub_type == 0 or tEquip[i].basicInfo.sub_type == 1) 
							and tEquip[i].isUse == true then
							m_tDataList[j] = tEquip[i]
						end
					else
						if tEquip[i].basicInfo.main_type == 4 and tEquip[i].basicInfo.sub_type == j and tEquip[i].isUse == true then
							m_tDataList[j] = tEquip[i]
						end
					end
				end
			end
			for k,v in pairs(m_tDataList) do
				local extraInfo1 = v.extraInfo
				for i=1,20 do
					if extraInfo1[tostring(i)] ~= nil and extraInfo1[tostring(i)] ~= 0 then
						attrList1[tostring(i)] = attrList1[tostring(i)] + extraInfo1[tostring(i)]
					end
				end
			end
		end
	elseif tData.id == 75 then
		local equipmentList = CacheCenter:getPlayerItems()
		local suit = {}
		local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
		local TypeNum = {[1]=0,[2]=0,[3]=0,[4]=0}
		local set = false
		for i=1,4 do
			local fight = 0
			if equipmentList and next(equipmentList) then
				for j=1,#equipmentList do
					if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] and tonumber(equipmentList[j].extraInfo.fighting) >= fight then
						-- if equipmentList[j].lastTime == -1 or equipmentList[j].lastTime > 0 then
							suit[i] = equipmentList[j]
							fight = equipmentList[j].extraInfo.fighting
							set = true
						-- end
					end
					if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
						if equipmentList[j].lastTime == -1 or equipmentList[j].lastTime > 0 then
							TypeNum[i] = TypeNum[i] + 1
						end
					end
				end
			end
		end
		if set then
			for k,v in pairs(suit) do
				local property = GDatatab_item["id_"..v.id].property
				for i =1,#property do
					attrList[tostring(property[i][1])] = attrList[tostring(property[i][1])] + property[i][2]
				end
			end
		end
		if TypeNum[1] > 0 then
			attrList[tostring(10)] = attrList[tostring(10)] + TypeNum[1] * 10
		end
		if TypeNum[2] > 0 then
			attrList[tostring(11)] = attrList[tostring(11)] + TypeNum[2] * 10
		end
		if TypeNum[3] > 0 then
			attrList[tostring(9)] = attrList[tostring(9)] + TypeNum[3] * 10
		end
		if TypeNum[4] > 0 then
			attrList[tostring(19)] = attrList[tostring(19)] + TypeNum[4] * 10
		end



		local pointX = 0.04
		local pointY = 0.25
		local textDes = ""

		local txt1 = WZUIFreeTextBox:create()
		txt1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txt1:setMaxWidth(500)
		txt1:setRelativePosition(GlobalMethod:ccp(pointX,pointY))
		txt1:setShowText(string.format(text3,LocalStrings.BAGTIP31,TypeNum[1]))
		conTips28:addChild(txt1)
		local txt2 = WZUIFreeTextBox:create()
		txt2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txt2:setMaxWidth(500)
		txt2:setRelativePosition(GlobalMethod:ccp(pointX+0.5,pointY))
		txt2:setShowText(string.format(text3,LocalStrings.BAGTIP32,TypeNum[2]))
		conTips28:addChild(txt2)
		local txt3 = WZUIFreeTextBox:create()
		txt3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txt3:setMaxWidth(500)
		txt3:setRelativePosition(GlobalMethod:ccp(pointX,pointY-0.1))
		txt3:setShowText(string.format(text3,LocalStrings.BAGTIP33,TypeNum[3]))
		conTips28:addChild(txt3)
		local txt4 = WZUIFreeTextBox:create()
		txt4:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txt4:setMaxWidth(500)
		txt4:setRelativePosition(GlobalMethod:ccp(pointX+0.5,pointY-0.1))
		txt4:setShowText(string.format(text3,LocalStrings.BAGTIP34,TypeNum[4]))
		conTips28:addChild(txt4)

		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			local equipmentList1 = WndCheckOther.m_tPlayerInfo.item
			local suit1 = {}
			local set1 = false
			local TypeNum1 = {[1]=0,[2]=0,[3]=0,[4]=0}
			for i=1,4 do
				local fight = 0
				if equipmentList1 and next(equipmentList1) then
					for j=1,#equipmentList1 do
						if equipmentList1[j].maintype == 5 and equipmentList1[j].subtype == dressType[i] and tonumber(equipmentList1[j].extraInfo.fighting) >= fight then
							-- if equipmentList1[j].lastTime == -1 or equipmentList1[j].lastTime > 0 then
								suit1[i] = equipmentList1[j]
								fight = equipmentList1[j].extraInfo.fighting
								set1 = true
								
							-- end
						end
						if equipmentList1[j].maintype == 5 and equipmentList1[j].subtype == dressType[i] then
							-- if equipmentList1[j].time_limit == -1 or equipmentList1[j].time_limit > 0 then
								TypeNum1[i] = TypeNum1[i] + 1
							-- end
						end
					end
				end
			end
			if set1 then
				for k,v in pairs(suit1) do
					local property = GDatatab_item["id_"..v.id].property
					for i =1,#property do
						attrList1[tostring(property[i][1])] = attrList1[tostring(property[i][1])] + property[i][2]
					end
				end
			end
			if TypeNum1[1] > 0 then
				attrList1[tostring(10)] = attrList1[tostring(10)] + TypeNum1[1] * 10
			end
			if TypeNum1[2] > 0 then
				attrList1[tostring(11)] = attrList1[tostring(11)] + TypeNum1[2] * 10
			end
			if TypeNum1[3] > 0 then
				attrList1[tostring(9)] = attrList1[tostring(9)] + TypeNum1[3] * 10
			end
			if TypeNum1[4] > 0 then
				attrList1[tostring(19)] = attrList1[tostring(19)] + TypeNum1[4] * 10
			end
			txt1:setShowText(string.format(text3,LocalStrings.BAGTIP31,TypeNum1[1]))
			txt2:setShowText(string.format(text3,LocalStrings.BAGTIP32,TypeNum1[2]))
			txt3:setShowText(string.format(text3,LocalStrings.BAGTIP33,TypeNum1[3]))
			txt4:setShowText(string.format(text3,LocalStrings.BAGTIP34,TypeNum1[4]))
		end
	elseif tData.id == 76 then --皮肤装备
		--加上装备属性
		tEquipData = {["equip"]={0,0,0,0,0,0,},["property"]={},["fight"]=0,}	
		if CacheCenter:getPlayerInfo().phantomEquipment then
			tEquipData = json.decode(CacheCenter:getPlayerInfo().phantomEquipment)
		end
		for i=1,20 do
			if tEquipData.property[tostring(i)] ~= nil and tEquipData.property[tostring(i)] ~= 0 then
				attrList[tostring(i)] = attrList[tostring(i)] + tEquipData.property[tostring(i)]
			end
		end
		fighting = math.ceil(tEquipData.fight)

		if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
			tEquipData1 = {["equip"]={0,0,0,0,0,0,},["property"]={},["fight"]=0,}
			if WndCheckOther.m_tPlayerInfo.phantomEquipment then
				tEquipData1 = json.decode(WndCheckOther.m_tPlayerInfo.phantomEquipment)
			end
			for i=1,20 do
				if tEquipData1.property[tostring(i)] ~= nil and tEquipData1.property[tostring(i)] ~= 0 then
					attrList1[tostring(i)] = attrList1[tostring(i)] + tEquipData1.property[tostring(i)]
				end
			end
			fighting1 = math.ceil(tEquipData1.fight)
		end

	end 

	local allTab = {}

	for i = 1,20 do
		-- if attrList[tostring(i)] ~= 0 or attrList1[tostring(i)] ~= 0 then
			allTab[tostring(i)] = {[1] = attrList[tostring(i)],[2] = attrList1[tostring(i)]}
		-- end
	end

	local notZero = {}
	local y = 1
	for i = 1,20 do
		if allTab[tostring(i)] ~= nil and (allTab[tostring(i)][1] ~= 0 or allTab[tostring(i)][2] ~= 0) then
			notZero[y] = {i,allTab[tostring(i)]}
			y = y + 1
		end
	end

	local iconPath = "ui/common/common_btn_jiant_05.png"
	local text1 = [[<T C="127,70,26" S="22" >%s</T><T C="127,70,26" S="22" >%d</T>]]
	local text11 = [[<T C="127,70,26" S="22" >%s</T><T C="127,70,26" S="22" >%d(%d)</T><I Z="0.5" P="1" >%s</I>]]
	local ftxtFighting = WZUIFreeTextBox:create()
	ftxtFighting:setRelativePosition(GlobalMethod:ccp(0.5, 0.05))
	ftxtFighting:setMaxWidth(500)
	if CacheCenter:getPlayerInfo().id == WndCheckOther.m_tPlayerInfo.id then
		if tData.id == 67 then
			txtTitle:setText(LocalStrings.PRACTICE_ATTRIBUTE_NAME)
			ftxtFighting:setShowText(string.format(text1,LocalStrings.PRACTICE_FIGHT, GlobalMethod:getCombatEffect(attrList)))
		elseif tData.id == 68 then
			txtTitle:setText(LocalStrings.SPIRIT_ATTR)
			ftxtFighting:setShowText(string.format(text1,LocalStrings.SPIRIT_FIGHT, GlobalMethod:getCombatEffect(attrList)))
		elseif tData.id == 69 then
			txtTitle:setText(LocalStrings.RUNE_ATTR)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.RUNE_FIGHT, GlobalMethod:getCombatEffect(attrList)))
		elseif tData.id == 70 then
			txtTitle:setText(LocalStrings.BLESS_AAT_TITLE)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.BLESS_FIGHTING, GlobalMethod:getCombatEffect(attrList)))			
		elseif tData.id == 71 then
			txtTitle:setText(LocalStrings.MOUNT_ATTR)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.MOUNT_FIGHT,fighting))	
		elseif tData.id == 72 then
			txtTitle:setText(LocalStrings.FOOTMARK_ATTR)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.PET_TEXT19,fighting))
		elseif tData.id == 73 then
			txtTitle:setText(LocalStrings.SHAPE_ATTR)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.NEWBAG4,GlobalMethod:getCombatEffect(attrList)))	
		elseif tData.id == 74 then
			txtTitle:setText(LocalStrings.NEWBAG6)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.NEWBAG7,GlobalMethod:getCombatEffect(attrList)))		
		elseif tData.id == 75 then
			txtTitle:setText(LocalStrings.BAG13)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.BAG16,GlobalMethod:getCombatEffect(attrList)))						
		elseif tData.id == 76 then
			txtTitle:setText(LocalStrings.PHANTOM_EQUIPMENT21)	
			ftxtFighting:setShowText(string.format(text1,LocalStrings.PHANTOM_EQUIPMENT20,fighting))						
		end
	else 
		if GlobalMethod:getCombatEffect(attrList1) > GlobalMethod:getCombatEffect(attrList) then
			iconPath = "ui/common/common_btn_jiant_05_1.png"
		end
		if GlobalMethod:getCombatEffect(attrList1) == GlobalMethod:getCombatEffect(attrList) then
			iconPath = ""
		end

		if tData.id == 67 then
			txtTitle:setText(LocalStrings.PRACTICE_ATTRIBUTE_NAME)
			ftxtFighting:setShowText(string.format(text11,LocalStrings.PRACTICE_FIGHT, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))
		elseif tData.id == 68 then
			txtTitle:setText(LocalStrings.SPIRIT_ATTR)
			ftxtFighting:setShowText(string.format(text11,LocalStrings.SPIRIT_FIGHT, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))
		elseif tData.id == 69 then
			txtTitle:setText(LocalStrings.RUNE_ATTR)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.RUNE_FIGHT, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))
		elseif tData.id == 70 then
			txtTitle:setText(LocalStrings.BLESS_AAT_TITLE)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.BLESS_FIGHTING, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))		
		elseif tData.id == 71 then
			txtTitle:setText(LocalStrings.MOUNT_ATTR)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.MOUNT_FIGHT, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))
		elseif tData.id == 72 then
			txtTitle:setText(LocalStrings.FOOTMARK_ATTR)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.PET_TEXT19, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))
		elseif tData.id == 73 then
			txtTitle:setText(LocalStrings.SHAPE_ATTR)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.NEWBAG4, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))	
		elseif tData.id == 74 then
			txtTitle:setText(LocalStrings.NEWBAG6)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.NEWBAG7, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))	
		elseif tData.id == 75 then
			txtTitle:setText(LocalStrings.BAG13)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.BAG16, GlobalMethod:getCombatEffect(attrList1),GlobalMethod:getCombatEffect(attrList),iconPath))						
		elseif tData.id == 76 then
			txtTitle:setText(LocalStrings.PHANTOM_EQUIPMENT21)	
			ftxtFighting:setShowText(string.format(text11,LocalStrings.PHANTOM_EQUIPMENT20,fighting1,fighting,iconPath))	
		end
	end
	conTips28:addChild(ftxtFighting)
	if tData.id == 76 then
		--战力文字调整位置
		ftxtFighting:setRelativePosition(GlobalMethod:ccp(0.5, 0.15))
	end
	-- WZLog("打印修炼的属性",Serialize(attrList))
	local pointX = 0.02
	local pointY = 0.78
	
	local tProperty = {}
	local tProperty1 = {}
	local index = 1
	local index1 = 1
	for i=1,20 do
		if attrList[tostring(i)] ~= nil and attrList[tostring(i)] ~= 0 then
			tProperty[index] = {i,attrList[tostring(i)]}
			index = index + 1
		end
	end
	for i=1,20 do
		if attrList1[tostring(i)] ~= nil and attrList1[tostring(i)] ~= 0 then
			tProperty1[index1] = {i,attrList1[tostring(i)]}
			index1 = index1 + 1
		end
	end

	if CacheCenter:getPlayerInfo().id == WndCheckOther.m_tPlayerInfo.id then
		for i=1,math.ceil(#tProperty/2) do
			local nIndex = (i - 1) * 2 + 1 
			if tProperty[nIndex][2] ~= 0 then
				local ftxtProperty1 = WZUIFreeTextBox:create()
				ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.108))
				ftxtProperty1:setMaxWidth(500)
				ftxtProperty1:setShowText(string.format(text2,ATTR_TITLE[tProperty[nIndex][1]], tProperty[nIndex][2]))
				conTips28:addChild(ftxtProperty1)
			end
			if (nIndex+1) <= #tProperty and tProperty[nIndex + 1][2] ~= 0 then
				local ftxtProperty2 = WZUIFreeTextBox:create()
				ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				ftxtProperty2:setRelativePosition(GlobalMethod:ccp(pointX + 0.5, pointY - (i - 1) * 0.108))
				ftxtProperty2:setMaxWidth(500)		
				ftxtProperty2:setShowText(string.format(text2,ATTR_TITLE[tProperty[nIndex + 1][1]], tProperty[nIndex + 1][2]))
				conTips28:addChild(ftxtProperty2)
			end
		end
	else 
		for i =1,math.ceil(#notZero/2) do
			local nIndex = (i - 1) * 2 + 1
			if notZero[nIndex][2] ~= nil then
				if notZero[nIndex][2][2] > notZero[nIndex][2][1] then
					iconPath = "ui/common/common_btn_jiant_05_1.png"
				elseif notZero[nIndex][2][2] < notZero[nIndex][2][1] then
					iconPath = "ui/common/common_btn_jiant_05.png"
				else 
					iconPath = ""
				end
				local ftxtProperty1 = WZUIFreeTextBox:create()
				ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.108))
				ftxtProperty1:setMaxWidth(500)
				ftxtProperty1:setShowText(string.format(text21,ATTR_TITLE[notZero[nIndex][1]], notZero[nIndex][2][2],notZero[nIndex][2][1],iconPath))
				conTips28:addChild(ftxtProperty1)
			end
			if (nIndex+1) <= #notZero and notZero[nIndex+1][2] ~= nil then
				if notZero[nIndex + 1][2][2] > notZero[nIndex + 1][2][1] then
					iconPath = "ui/common/common_btn_jiant_05_1.png"
				elseif notZero[nIndex + 1][2][2] < notZero[nIndex + 1][2][1] then
					iconPath = "ui/common/common_btn_jiant_05.png"
				else 
					iconPath = ""
				end
				local ftxtProperty2 = WZUIFreeTextBox:create()
				ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
				ftxtProperty2:setRelativePosition(GlobalMethod:ccp(pointX + 0.5, pointY - (i - 1) * 0.108))
				ftxtProperty2:setMaxWidth(500)		
				ftxtProperty2:setShowText(string.format(text21,ATTR_TITLE[notZero[nIndex + 1][1]], notZero[nIndex + 1][2][2],notZero[nIndex + 1][2][1],iconPath))
				conTips28:addChild(ftxtProperty2)				
			end
		end
	end
end

--@brief 职业勋章
function WndTips:_update68()
	-- body
	WZLog("WndTips:_update68")
	if self.m_tData == nil then return end
	local professionId
	local att1 = {}
	local att2 = {}

	local attrList = {}
	for i=1,21 do
		attrList[tostring(i)] = 0
	end 

	if CacheCenter:getPlayerInfo().id ~= WndCheckOther.m_tPlayerInfo.id then
		professionId = WndCheckOther.m_tPlayerInfo.professionId
		WZLog("WndTips:_update681",(WndCheckOther.m_tPlayerInfo.professionAttr1))
		WZLog("WndTips:_update682",(WndCheckOther.m_tPlayerInfo.professionAttr2))
		att1 = json.decode(WndCheckOther.m_tPlayerInfo.professionAttr1)
		if WndCheckOther.m_tPlayerInfo.professionAttr2 ~= "" then 
			att2 = json.decode(WndCheckOther.m_tPlayerInfo.professionAttr2)
		end
	else 
		professionId = CacheCenter:getPlayerInfo().professionId
		att1 = json.decode(CacheCenter:getPlayerInfo().professionAttr1)
		if CacheCenter:getPlayerInfo().professionAttr2 ~= "" then 
			att2 = json.decode(CacheCenter:getPlayerInfo().professionAttr2)
		end
	end

	WZLog("WndTips:_update680",professionId)
	for i, v in pairs(att1) do
		if tonumber(i) ~= nil and att1[tostring(i)] then
			attrList[tostring(i)] = attrList[tostring(i)] + att1[tostring(i)]
		end
	end
	for i, v in pairs(att2) do
		if tonumber(i) ~= nil and att2[tostring(i)] then
			attrList[tostring(i)] = attrList[tostring(i)] + att2[tostring(i)]
		end
	end

	local notZero = {}
	local y = 1
	for i = 1,20 do
		if attrList[tostring(i)] ~= nil and attrList[tostring(i)] ~= 0 then
			notZero[y] = {i,attrList[tostring(i)]}
			y = y + 1
		end
	end

	local conTips28 = GetElement(self.m_root,"conTips28_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(262, 260))
	local x = 0
	local icon1 = WZUIImage:create()
	-- if att2 == {} then
	-- 	x = 1
	-- 	icon1:setFile(g_professionIcon[professionId])
	-- else 
	-- 	x = 2
	-- 	conTips28:setAbsContentSize(GlobalMethod:CCSize(262, 354))
	-- 	conTips28:updateRelativeSize()
	-- 	icon1:setFile(g_professionIcon2[professionId])
	-- end
	if att2 and next(att2) then
		x = 2
		conTips28:setAbsContentSize(GlobalMethod:CCSize(262, 380))
		icon1:setFile(g_professionIcon2[professionId])
	else 
		x = 1
		icon1:setFile(g_professionIcon[professionId])
	end
	conTips28:updateRelativeSize()
	icon1:setRelativePosition(GlobalMethod:ccp(0.15,0.88))
	icon1:setUseOriginSize(true)
	icon1:setScale(0.5)
	icon1:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	conTips28:addChild(icon1)

	local txtTitle = WZUILabelTTF:create()
	txtTitle:setColor(GlobalMethod:ccc3(127,70,26))
	txtTitle:setFontSize(20)
	txtTitle:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	txtTitle:setText(LocalStrings.PROFESSION_NAME[professionId][x])
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.55, 0.88))
	conTips28:addChild(txtTitle)

	--分割线
	local imgLine1 = WZUIImage:create()
	imgLine1:setFile("ui/common/common_scale9_fengexian.png")
	imgLine1:setUseOriginSize(true)
	imgLine1:setScaleX(1.2)
	imgLine1:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
	imgLine1:setRelativePosition(GlobalMethod:ccp(0.5, 0.78))
	conTips28:addChild(imgLine1)



	local text1 = [[<T C="127,70,26" S="20" >%s</T><T C="5,180,0" S="20" >           %d</T>]]

	local ftxtProperty2 = WZUIFreeTextBox:create()
	ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtProperty2:setRelativePosition(GlobalMethod:ccp(0.08,0.73))
	ftxtProperty2:setMaxWidth(262)		
	ftxtProperty2:setShowText(string.format(LocalStrings.ATTR_FIGHT,GlobalMethod:getCombatEffect(attrList)))
	conTips28:addChild(ftxtProperty2)	

	if x == 2 and (att2.professionRoleSkill ~= nil or att2.professionPetSkill ~= nil) then
		local pointX = 0.08
		local pointY = 0.66
		for i = 1,#notZero do
			local ftxtProperty1 = WZUIFreeTextBox:create()
			ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
			ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.07))
			ftxtProperty1:setMaxWidth(300)
			ftxtProperty1:setShowText(string.format(text1,ATTR_TITLE[notZero[i][1]], notZero[i][2]))
			conTips28:addChild(ftxtProperty1)		
		end
		--分割线2
		local imgLine2 = WZUIImage:create()
		imgLine2:setFile("ui/common/common_scale9_fengexian.png")
		imgLine2:setUseOriginSize(true)
		imgLine2:setScaleX(1.2)
		imgLine2:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
		imgLine2:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
		conTips28:addChild(imgLine2)

		local bgPath = "ui/common/common_jn_dk.png"
		if att2.professionRoleSkill ~= nil then	
			local bg1 = WZUIImage:create()
			bg1:setFile(bgPath)
			bg1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			bg1:setUseOriginSize(true)
			bg1:setRelativePosition(GlobalMethod:ccp(0.04,0.26))
			bg1:setUseOriginSize(true)
			bg1:setScale(0.85)
			conTips28:addChild(bg1)

			local iconPath1 = GDatatab_mage_Skill["id_"..att2.professionRoleSkill].icon
			local skill1 = WZUIImage:create()
			skill1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			skill1:setUseOriginSize(true)
			skill1:setRelativePosition(GlobalMethod:ccp(0.03,0.26))
			skill1:setFile(iconPath1)
			skill1:setScale(0.8)
			conTips28:addChild(skill1)

			local name1 = GDatatab_mage_Skill["id_"..att2.professionRoleSkill].name
			local skillName1 = WZUILabelTTF:create()
			skillName1:setText(name1)
			skillName1:setColor(GlobalMethod:ccc3(127,70,24))
			skillName1:setFontSize(20)
			skillName1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			skillName1:setRelativePosition(GlobalMethod:ccp(0.28,0.26))
			conTips28:addChild(skillName1)

			if ProjConfig.LANGUAGE == "vn" then
				skillName1:setScale(0.7)
			end
		end

		if att2.professionPetSkill ~= nil then
			local bg2 = WZUIImage:create()
			bg2:setFile(bgPath)
			bg2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			bg2:setUseOriginSize(true)
			bg2:setRelativePosition(GlobalMethod:ccp(0.04,0.1))
			bg2:setUseOriginSize(true)
			bg2:setScale(0.85)
			conTips28:addChild(bg2)

			local iconPath2 = GDatatab_mage_Skill["id_"..att2.professionPetSkill].icon
			local skill2 = WZUIImage:create()
			skill2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			skill2:setUseOriginSize(true)
			skill2:setRelativePosition(GlobalMethod:ccp(0.03,0.1))
			skill2:setFile(iconPath2)
			skill2:setScale(0.8)
			conTips28:addChild(skill2)

			local name2 = GDatatab_mage_Skill["id_"..att2.professionPetSkill].name
			local skillName2 = WZUILabelTTF:create()
			skillName2:setText(name2)
			skillName2:setColor(GlobalMethod:ccc3(127,70,26))
			skillName2:setFontSize(20)
			skillName2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			skillName2:setRelativePosition(GlobalMethod:ccp(0.28,0.1))
			conTips28:addChild(skillName2)

			if ProjConfig.LANGUAGE == "vn" then
				skillName2:setScale(0.7)
			end
		end
	else 
		icon1:setRelativePosition(GlobalMethod:ccp(0.15,0.80))
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.55,0.80))
		imgLine1:setRelativePosition(GlobalMethod:ccp(0.5,0.63))
		ftxtProperty2:setRelativePosition(GlobalMethod:ccp(0.08,0.55))
		local pointX = 0.08
		local pointY = 0.46
		for i = 1,#notZero do
			local ftxtProperty1 = WZUIFreeTextBox:create()
			ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
			ftxtProperty1:setRelativePosition(GlobalMethod:ccp(pointX, pointY - (i - 1) * 0.1))
			ftxtProperty1:setMaxWidth(300)
			ftxtProperty1:setShowText(string.format(text1,ATTR_TITLE[notZero[i][1]], notZero[i][2]))
			conTips28:addChild(ftxtProperty1)		
		end
	end
end

--@brief Vip勋章
function WndTips:_update69()
	WZLog("WndTips:_update69")
	if self.m_tData == nil then return end
	local conType = GetElement(self.m_root,"conType66_WndTips",WZUIContainer)
	local imgCurLevel = GetElement(conType,"imgCurLevel",WZUIImage)
	if GDatatab_vip_medal_stage then
		local info = GDatatab_vip_medal_stage["id_"..self.m_tData[2]]
		if info then
			GetElement(conType,"imgCurLevel",WZUIImage):setFile(info.icon)
			local spineIcon = GetElement(self.m_root, "spineIcon_WndTips66", WZUISpine)
			if info.path ~= 0 then 
				local existSpine = CheckEffectFile("ui/otherUI/" .. info.path)
				if existSpine then 
					spineIcon:setVisible(true)
					spineIcon:setFileAtlas("ui/otherUI/" .. info.path .. ".atlas")
					spineIcon:setFileJson("ui/otherUI/" .. info.path .. ".json")
					if info.type >= 7 then 
						spineIcon:setRelativePosition(GlobalMethod:ccp(0.182485,0.731571))
					end
					spineIcon:setAnimationName(info.animation)
				else
					local _sIndex = info.path
			        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
			        if downloadInfo then 
			        	DownloadManager:addDownloadTask(14021 + info.id,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
			        end
				end
			end
			GetElement(conType,"txtMedalTitle",WZUILabelTTF):setText(info.title)
			GetElement(conType,"txtMedalSubtitle",WZUILabelTTF):setText(info.subtitle)
			for i=1, info.stage do
				GetElement(conType,"img_start"..i,WZUIImage):setVisible(true)
			end
		end
	end
end

--@brief 辅助技能tips
function WndTips:_update70()
	if self.m_tData == nil then return end
	GetElement(self.m_root,"conType28_WndTips",WZUIContainer):setVisible(false)
	local conType = GetElement(self.m_root,"conSkillTips",WZUIContainer)
	conType:setVisible(true)

	local txtSkillName = GetElement(conType,"txtSkillName_WndAssistSkill", WZUILabelTTF)
	local txtColdTime = GetElement(conType,"txtColdTime_WndAssistSkill", WZUILabelTTF)
	local txtReadyTime = GetElement(conType,"txtReadyTime_WndAssistSkill", WZUILabelTTF)
	local txtDesc1 = GetElement(conType,"txtDesc1_WndAssistSkill", WZUILabelTTF)
	
	local txtColdTime2 = GetElement(conType,"txtColdTime2_WndAssistSkill", WZUILabelTTF)
	local txtReadyTime2 = GetElement(conType,"txtReadyTime2_WndAssistSkill", WZUILabelTTF)
	local txtDesc2 = GetElement(conType,"txtDesc2_WndAssistSkill", WZUILabelTTF)
	local txtBtnName = GetElement(conType, "txtBtnName_WndAssistSkill", WZUILabelTTF)
	local btnEquip = GetElement(conType, "btnEquip_WndAssistSkill", WZUIButton)

	local skillData = GDatatab_skill["id_" .. self.m_tData.id]
	if skillData then 
		txtSkillName:setText(skillData.name)
		txtColdTime:setText(skillData.consume/1000)
		txtReadyTime:setText(skillData.cooling_time/1000)
		txtDesc1:setText(skillData.tool_desc)
	end
	if skillData.upgrade_id ~= -1 then 
		local nextData = GDatatab_skill["id_" .. skillData.upgrade_id]
		if nextData then 
			txtColdTime2:setText(nextData.consume/1000)
			txtReadyTime2:setText(nextData.cooling_time/1000)
			txtDesc2:setText(nextData.tool_desc)
		end
	else
		GetElement(conType, "conNext_WndTips28", WZUIContainer):setVisible(false)
		GetElement(conType, "txtMaxAtt_WndTips28", WZUILabelTTF):setVisible(true)
	end

	if self.m_tData.bActive then 
		btnEquip:setVisible(true)
		if self.m_tData.bEquipped then 
			txtBtnName:setText(LocalStrings.UNROYAL)
		else
			txtBtnName:setText(LocalStrings.EQUIPMENT)
		end
	else
		btnEquip:setVisible(false)
	end

	if ProjConfig.LANGUAGE == "vn" then
		txtDesc1:setFontSize(16)
		txtDesc2:setFontSize(16)
	end
end

--@brief	幻化装备属性tips
function WndTips:_update71()
	WZLog("WndTips:_update71")
	local tData = self.m_tData
	if tData == nil then return end 
	if tData.mountStone and tData.mountStone == 1 then --灵石属性的时候
		self:setMountStoneTips()
	else
		local attrList = {}
		for i=1,20 do
			attrList[tostring(i)] = 0
		end

		--加上装备属性
		local tEquipmentList = WndPhantomEquipment:getEquipmentList()
		for j=1,#tEquipmentList do
			if tEquipmentList[j].id ~= 0 then
				local property = tEquipmentList[j].basicInfo.property
				for j=1,#property do
					attrList[tostring(property[j][1])] = attrList[tostring(property[j][1])] + property[j][2]
				end
			end
		end
		if attrList["2"] ~= 0 then
			attrList["1"] = attrList["1"] + attrList["2"]
			attrList["2"] = 0
		end

		--套装属性
		local nSuitQuality = -1 --满足套装最高的品质
		local nSuitValue = -1 --满足套装的类型
		local nWornCount = 0 --已穿戴数量
		--找出满足品质的套装id
		for i=1,#tEquipmentList do
			if tEquipmentList[i].id ~= 0 then
				nWornCount = nWornCount + 1
				if nSuitQuality == -1 or tEquipmentList[i].basicInfo.quality < nSuitQuality then
					nSuitQuality = tEquipmentList[i].basicInfo.quality
				end
			end
		end
		--找出满足类型的套装id
		local nTempSuitValue = -1
		local nSameValueCount = 0 --记录出现同类型的次数 少于6表示不符合类型套装条件
		for i=1,#tEquipmentList do
			if tEquipmentList[i].id ~= 0 then
				if nTempSuitValue == -1 or tEquipmentList[i].basicInfo.value == nTempSuitValue then
					nTempSuitValue = tEquipmentList[i].basicInfo.value
					nSameValueCount = nSameValueCount + 1
				end
			end
		end
		if nSameValueCount == 6 then
			nSuitValue = nTempSuitValue
		end
		local tSuitIds = {} --加入满足条件的套装id
		local tSuit = GDatatab_skinequip_suit
		if nWornCount == 6 then --满装备
			for i=1,GetTableLen(tSuit) do
				if tSuit["id_"..i].type == 0 and nSuitQuality ~= -1 and tSuit["id_"..i].quality == nSuitQuality then
					table.insert(tSuitIds,i)
				end
				if tSuit["id_"..i].type == 1 and nSuitValue ~= -1 and tSuit["id_"..i].quality == nSuitValue then
					table.insert(tSuitIds,i)
				end
			end
		end
		local tAddList = CopyTable(attrList) --装备基础属性
		for k=1,#tSuitIds do
			local tProperty2 = tSuit["id_"..tSuitIds[k]].property
			for j=1,#tProperty2 do
				if tProperty2[j][1] == 0 then --套装固定加成
					if tProperty2[j][2] == -1 then --套装全属性固定加成
						for i=1,20 do
							attrList[tostring(i)] = attrList[tostring(i)] + tProperty2[j][3]
						end
					else --套装指定属性固定加成
						attrList[tostring(tProperty2[j][2])] = attrList[tostring(tProperty2[j][2])] + tProperty2[j][3]
					end
				elseif tProperty2[j][1] == 1 then --套装百分比加成
					if tProperty2[j][2] == -1 then --套装全属性百分比加成
						for i=1,20 do
							local add = math.ceil(tAddList[tostring(i)] * tProperty2[j][3] / 100)
							attrList[tostring(i)] = attrList[tostring(i)] + add
						end
					else --套装指定属性百分比加成
						local add = math.ceil(tAddList[tostring(tProperty2[j][2])] * tProperty2[j][3] / 100)
						attrList[tostring(tProperty2[j][2])] = attrList[tostring(tProperty2[j][2])] + add
					end
				end
			end
		end

		local fighting = GlobalMethod:getCombatEffect(attrList)

		local attrNum = 1
		for i=1,20 do
			GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setText("")
		end
		for i=1,20 do
			if attrList[tostring(i)] ~= nil and attrList[tostring(i)] ~= 0 then
				WZLog("sss",attrNum,ATTR_TITLE[i])
				-- GetElement(self.m_root,"label"..(attrNum*2-1).."Type43_WndTips",WZUILabelTTF):setText(ATTR_TITLE[i])
				-- GetElement(self.m_root,"label"..(attrNum*2).."Type43_WndTips",WZUILabelTTF):setText(attrList[tostring(i)])
				local conLabelType43 = GetElement(self.m_root,"conLabelType43_WndTips",WZUIContainer)
			    local txtAttrKey = WZUILabelTTF:create()
			    txtAttrKey:setText(ATTR_TITLE[i])
			    txtAttrKey:setColor(GlobalMethod:ccc3(127,70,26))
			    txtAttrKey:setFontSize(20)
			    txtAttrKey:setRelativePosition(GlobalMethod:ccp(0.28,0.88-(0.1*attrNum)))
			    txtAttrKey:setName("txtAttr1_"..attrNum)
			    conLabelType43:addChild(txtAttrKey)
			    local txtAttrValue = WZUILabelTTF:create()
			    txtAttrValue:setText(attrList[tostring(i)])
			    txtAttrValue:setColor(GlobalMethod:ccc3(99,255,95))
			    txtAttrValue:setFontSize(20)
			    txtAttrValue:setRelativePosition(GlobalMethod:ccp(0.8,0.88-(0.1*attrNum)))
			    txtAttrValue:setName("txtAttr2_"..attrNum)
			    conLabelType43:addChild(txtAttrValue)

				attrNum = attrNum + 1
				-- if attrNum > 10 then break end
			end
		end

		local Y = (130 + (attrNum - 2)*30)
		local scaleY = Y/300
		--GetElement(self.m_root,"di",WZUI9Image):setScaleY(scaleY)
		local conTip = GetElement(self.m_root,"conType43_WndTips",WZUIContainer)
		if fighting == 0 then
			Y = 130
			scaleY = Y/300
			ShowPanelNullTip( conTip, LocalStrings.NO_ATTR_ADD, GlobalMethod:ccc3(195,171,148), nil ,20)
		end
		conTip:setAbsContentSize(GlobalMethod:CCSize(240,Y))
		conTip:updateRelativeSize()
		WZLog("背景缩放",scaleY,Y)
		local labelFight2Type43 = GetElement(self.m_root,"labelFight2Type43_WndTips",WZUILabelTTF)
		labelFight2Type43:setText(fighting)
	end
		
	if ProjConfig.LANGUAGE == "vn" then
		local labelFight1Type43 = GetElement(self.m_root,"labelFight1Type43_WndTips",WZUILabelTTF)
		labelFight1Type43:setRelativePosition(GlobalMethod:ccp(0.1,0.51))
		labelFight1Type43:setScale(0.8)
		local labelFight2Type43 = GetElement(self.m_root,"labelFight2Type43_WndTips",WZUILabelTTF)
		labelFight2Type43:setRelativePosition(GlobalMethod:ccp(0.72,0.51))
		labelFight2Type43:setScale(0.8)
	end
end
--灵石属性
function WndTips:setMountStoneTips()
	GetElement(self.m_root,"ttf1Type43_WndTips",WZUILabelTTF):setTextKey("MOUNTSTONE_TEXT31")
	local data = WndMountStone:getUpMountStone()
	local stoneData = CacheCenter:getMountStoneList()
	local source_data = CacheCenter:getMountStoneSourceList()
	local temp_value = {}
	for i=1,#data do
		local lev = 0
		local stoneEffect = 0
		if data[i].playerItemId ~= 0 then
			for k,v in pairs(stoneData) do
				if data[i].playerItemId == v.playerItemId then
					lev = v.extraInfo.strongLevel
					if v.extraInfo.spriteStoneEffect then
						stoneEffect = v.extraInfo.spriteStoneEffect
					end
				end
			end

			local extra_add = -1 --额外增加
			local info = GDatatab_sprite_stone_effect["id_"..stoneEffect]
			if stoneEffect and stoneEffect ~= 0 then
				if info then
					if info.value[1][1] ~= 0 and info.type == 1 then
						extra_add = info.value[1][1]
					end
				end
			end
			for _mm = 1, #data[i].ass_message do
				local source_id = nil
				local attr_id = nil
				local temp_playerItemId = data[i].ass_message[_mm].playerItemId
				if data[i].ass_message[_mm].itemId ~= 0 then
					for _i1, _v1 in pairs(source_data) do
						if _v1.playerItemId == temp_playerItemId then
							source_id = _v1.extraInfo.spriteStoneConfigId
							for _i_, _v_ in pairs(_v1.extraInfo) do
								if type(tonumber(_i_)) == "number" and tonumber(_i_) ~= 0 then
									attr_id = tonumber(_i_)
									break
								end
							end
						end
					end
				end
				if source_id then
					local source_info = GDatatab_sprite_stone_source["id_"..source_id]
					local num = source_info.attribute_initial + source_info.attribute_grow * lev
					local add_num = 0
					if extra_add == tonumber(data[i].ass_message[_mm].propertyType) then
						add_num = math.ceil(info.value[1][2]/100*num)
					end
					if temp_value[attr_id] then
						temp_value[attr_id] = temp_value[attr_id] + num + add_num
					else
						temp_value[attr_id] = num + add_num
					end
				end
			end
		end
	end
	local index, fighting = 1,0
	for i=1,20 do
		GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setText("")
	end
	for i,v in pairs(temp_value) do
		local label1 = GetElement(self.m_root,"label"..(index*2-1).."Type43_WndTips",WZUILabelTTF)
		if label1 then
			label1:setText(ATTR_TITLE[i])
		end
		local label2 = GetElement(self.m_root,"label"..(index*2).."Type43_WndTips",WZUILabelTTF)
		if label2 then
			label2:setText(v)
		end
		index = index + 1
	end
	GetElement(self.m_root,"labelFight1Type43_WndTips",WZUILabelTTF):setTextKey("MOUNTSTONE_TEXT32")

	local Y = (130 + (index - 2)*30)
	local conTip = GetElement(self.m_root,"conType43_WndTips",WZUIContainer)
	conTip:setAbsContentSize(GlobalMethod:CCSize(240,Y))
	conTip:updateRelativeSize()
	fighting = caculateClothesFighting(temp_value, true)
	GetElement(self.m_root,"labelFight2Type43_WndTips",WZUILabelTTF):setText(fighting)
end
--@brief	坐骑灵石tips
function WndTips:_update72()
	WZLog("WndTips:_update72")
	local tData = self.m_tData
	if tData == nil then return end

	local conType = GetElement(self.m_root,"conType67_WndTips",WZUIContainer)
	if self.m_bShowBtn == true then
		GetElement(conType,"btnEquip",WZUIButton):setVisible(false)
	end
	GetElement(conType,"txtDesc",WZUILabelTTF):setText(tData.basicInfo.desc)
	local txtName = GetElement(conType,"txtName",WZUILabelTTF)
	txtName:setText(tData.basicInfo.name)
	txtName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
	local img_quality = {"ui/common/common_scale9_lv.png","ui/common/common_scale9_lan.png", "ui/common/common_scale9_zi.png", "ui/common/common_scale9_cheng.png"}
	GetElement(conType,"imgQulity",WZUIImage):setFile(img_quality[tData.basicInfo.quality])
	local imgIcon = GetElement(conType,"imgIcon",WZUIImage)
	imgIcon:setFile(tData.basicInfo.icon)
	imgIcon:setScale(0.56)

	local txtLevel = ""
	local spriteStoneEffect = 0
	if self.m_bSpaceMountStone and self.m_bSpaceMountStone == true then
		local temp_data = {}
		if self.m_tOtherData and self.m_tOtherData.otherData then
			temp_data = self.m_tOtherData.otherData
		end
		if next(temp_data) ~= nil then
			txtLevel = temp_data.lv
			spriteStoneEffect = temp_data.effect
			local tAttrData = self:getAttrData(temp_data.attr)
			self:setShowAttr(tAttrData, temp_data.effect)
		end
	else
		local tAttrData = self:getAttrData(tData.extraInfo)
		if tData.isUse == true then
			self:setShowAttr(tAttrData, tData.extraInfo.spriteStoneEffect)
		else
			for i=1,#tAttrData do
				if i <= 5 then
					if tAttrData[i].attr_id then
						local img_attr = GetElement(conType,"img"..i.."_con",WZUIContainer)
						img_attr:setVisible(true)
						local txtAttr = GetElement(img_attr,"txtAttr",WZUILabelTTF)
						if tAttrData[i].attr_id == 0 then
							txtAttr:setText(LocalStrings.MOUNTSTONE_TEXT27)
						else
							txtAttr:setText(ATTR_TITLE[tAttrData[i].attr_id])
						end
					end
				end
			end
		end
		if tData.extraInfo and tData.extraInfo.spriteStoneEffect then
			if tData.extraInfo.spriteStoneEffect == 0 then
				spriteStoneEffect = 0
			else
				spriteStoneEffect = tData.extraInfo.spriteStoneEffect
			end
		end
		if tData.extraInfo and tData.extraInfo.strongLevel then
			txtLevel = tData.extraInfo.strongLevel
		end
	end

	local txtSpecial = GetElement(conType,"txtSpecial",WZUILabelTTF)
	if spriteStoneEffect == 0 then
		txtSpecial:setText(LocalStrings.MOUNTSTONE_TEXT10)
	else
		local info = GDatatab_sprite_stone_effect["id_"..spriteStoneEffect]
		if info then
			txtSpecial:setText(info.des)
		end
	end		
	GetElement(conType,"txtLv",WZUILabelTTF):setText("Lv."..txtLevel)

	if ProjConfig.LANGUAGE == "vn" then
		self.m_root:setRelativePosition(GlobalMethod:ccp(0.5,0.1))
		local conType67 = GetElement(self.m_root,"conType67_WndTips",WZUIContainer)
		conType67:setAbsContentSize(GlobalMethod:CCSize(324,500))
		conType67:updateRelativeSize()
		local conSplitLine = GetElement(self.m_root,"conSplitLine",WZUIContainer)
		if conSplitLine then 
			conSplitLine:setRelativePosition(GlobalMethod:ccp(0.5,0.736))
		end
		local txtName = GetElement(self.m_root,"txtName",WZUILabelTTF)
		txtName:setRelativePosition(GlobalMethod:ccp(0.346,0.96))
		txtName:setScale(0.75)
		local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
		txtDesc:setRelativePosition(GlobalMethod:ccp(0.337,0.92))
		txtDesc:setScale(0.75)
		txtDesc:setDimensions(GlobalMethod:CCSize(260))
		local txtSpecial = GetElement(self.m_root,"txtSpecial",WZUILabelTTF)
		txtSpecial:setRelativePosition(GlobalMethod:ccp(0.026,0.658))
		txtSpecial:setScale(0.75)
		txtSpecial:setDimensions(GlobalMethod:CCSize(400))
		for i=1,5 do
			local img_con = GetElement(self.m_root,"img"..i.."_con",WZUIContainer)
			img_con:setRelativePosition(GlobalMethod:ccp(0.5,0.55-(i-1)*0.09))
			local txtAttr = GetElement(self.m_root,"txtAttr"..i,WZUIFreeTextBox)
			txtAttr:setRelativePosition(GlobalMethod:ccp(0.085,0.55-(i-1)*0.09))
		end
		local btnEquip = GetElement(self.m_root,"btnEquip",WZUIButton)
		btnEquip:setRelativePosition(GlobalMethod:ccp(0.5,0.08))
	end
end
--个人空间的灵石tips
function WndTips:setSpaceTips(data)
	local conType = GetElement(self.m_root,"conType67_WndTips",WZUIContainer)
	local txtSpecial = GetElement(conType,"txtSpecial",WZUILabelTTF)
	if data.effect == 0 then
		txtSpecial:setText(LocalStrings.MOUNTSTONE_TEXT10)
	else
		local info = GDatatab_sprite_stone_effect["id_"..data.effect]
		if info then
			txtSpecial:setText(info.des)
		end
	end
	GetElement(conType,"txtLv",WZUILabelTTF):setText("Lv."..data.lv)

end
--获取属性的数据
function WndTips:getAttrData(data)
	local tAttrData = {}
	local nIndex = 1
	for i,v in pairs(data) do
		if type(tonumber(i)) == "number" then
			local tab = {}
			tab.attr_id = tonumber(i)
			tab.attr_num = tonumber(v)
			tAttrData[nIndex] = tab
			nIndex = nIndex + 1
		end
	end
	table.sort( tAttrData, function(a,b) return a.attr_id < b.attr_id end)
	return tAttrData
end
--显示属性
function WndTips:setShowAttr(tAttrData,effect)
	local conType = GetElement(self.m_root,"conType67_WndTips",WZUIContainer)
	-- 资源，这个要固定写死的,按顺序是攻击、防御、生命、速度、幸运
	local sttr_str = {
		[3] = "shopitems/zq_lszy_05.png",
		[4] = "shopitems/zq_lszy_03.png",
		[1] = "shopitems/zq_lszy_01.png",
		[12] = "shopitems/zq_lszy_02.png",
		[13] = "shopitems/zq_lszy_04.png"
		}
	local extra_add = -1 --额外增加
	local effect_info = nil
	if effect then
		effect_info = GDatatab_sprite_stone_effect["id_"..effect]
		if effect_info and effect_info.value[1][1] ~= 0 then
			extra_add = effect_info.value[1][1]
		end
	end
	local stone_tips = WndMountStone:getMountStoneTips()
	for i=1,#tAttrData do
		if i <= 5 then
			local str_attr = ""
			local temp_attr_id = tAttrData[i].attr_id
			if temp_attr_id == 0 then
				str_attr = LocalStrings.MOUNTSTONE_TEXT27
				if stone_tips and stone_tips.ass_message and stone_tips.ass_message[i] then
					if stone_tips.ass_message[i].itemId ~= 0 then
						local info = GDatatab_item["id_"..stone_tips.ass_message[i].itemId]
						if info and info.property[1] then
							str_attr = ATTR_TITLE[tonumber(info.property[1][1])]
							temp_attr_id = tonumber(info.property[1][1])
						end
					end
				end
			else
				str_attr = ATTR_TITLE[temp_attr_id]
			end 
			if tAttrData[i].attr_num == 0 then
				local img_attr = GetElement(conType,"img"..i.."_con",WZUIContainer)
				img_attr:setVisible(true)
				local txtAttr = GetElement(img_attr,"txtAttr",WZUILabelTTF)
				txtAttr:setText(str_attr)
			else
				local _txtAttr = GetElement(conType,"txtAttr"..i,WZUIFreeTextBox)
				local extra_str = ""
				if effect_info and extra_add == temp_attr_id then
					extra_str = string.format([[<T C="229,105,22" S="20" P="1"> (+%d)</T>]], math.ceil(effect_info.value[1][2]/100*tAttrData[i].attr_num))
				end
				local str = string.format([[<I Z="0.5">%s</I><T C="127,70,26" S="20" P="1">%s:</T> <T C="229,105,22" S="20" P="1"> +%d%s</T>]], sttr_str[temp_attr_id], str_attr, tAttrData[i].attr_num, tostring(extra_str))
				_txtAttr:setShowText(str)
			end
		end
	end
end
--@brief	一段tips
--@note 	size:背景大小
--@note 	desc:内容
function WndTips:_update73()
	WZLog("WndTips:_update73")
	local tData = self.m_tData
	if tData == nil then return end

	if tData.size then
		local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
		conType5:setAbsContentSize(tData.size)
		conType5:updateRelativeSize()
	end

	if tData.desc then
		local txt1Type5 = GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox)
		txt1Type5:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		txt1Type5:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		if string.find(tData.desc,"<T") == nil then
			local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T>]]
			txt1Type5:setShowText(string.format(strFormat,tData.desc))
		else
			txt1Type5:setShowText(tData.desc)
		end
	end

end
--tData 本人的灵石数据
function WndTips:_update74()
	WZLog("WndTips:_update74")
	local tData = self.m_tData
	if tData == nil then return end

	local conTips28 = GetElement(self.m_root,"conTips28_WndTips",WZUIContainer)
	conTips28:setAbsContentSize(GlobalMethod:CCSize(350, 208))
	conTips28:updateRelativeSize()

	local txtTitle = createLabel(LocalStrings.MOUNTSTONE_TEXT31,ccp(0.5, 0.91),ccp(0.5,0.5),20,ccc3(127,70,26))
	conTips28:addChild(txtTitle)
	local fight = tData.fight
	local img_fight = ""
	if self.m_tOtherData and self.m_tOtherData.isMyStone == false then
		fight = WndCheckOther.m_tPlayerInfo.spriteStoneFp
		local str_img = ""
		if fight > tData.fight then
			str_img = "ui/common/common_btn_jiant_05_1.png"
		else
			str_img = "ui/common/common_btn_jiant_05.png"
		end
		img_fight = string.format([[<T C="229,105,22" S="20" P="0">(%d)</T><I Z="0.8">%s</I>]],tData.fight, str_img)
	end
	local desc = string.format([[<T C="127,70,26" S="20" P="1">%s%d</T>%s]],LocalStrings.MOUNTSTONE_TEXT32, fight, img_fight)
	local txtFight = createFreeTextBox(desc, ccp(0.5, 0.08), ccp(0.5,0.5), 300)
	conTips28:addChild(txtFight)
	--分割线
	local imgLine1 = createImage("ui/common/common_scale9_fengexian.png",ccp(0.5, 0.85),CCSize(1.5,1),true, ccp(0.5, 0.5))
	conTips28:addChild(imgLine1)
	--分割线2
	local imgLine2 = createImage("ui/common/common_scale9_fengexian.png",ccp(0.5, 0.15),CCSize(1.5,1),true, ccp(0.5, 0.5))
	conTips28:addChild(imgLine2)
	local temp_attr = {}
	if self.m_tOtherData then
		if self.m_tOtherData.isMyStone == true then
			temp_attr = tData.attr
		else
			local stone_info = self.m_tOtherData.spaceMountStone
			for i,v in pairs(stone_info) do
				for k,m in pairs(v.attr) do
					if temp_attr[tonumber(k)] then
						temp_attr[tonumber(k)] = temp_attr[tonumber(k)] + m
					else
						temp_attr[tonumber(k)] = m
					end
				end
			end
		end
	end
	local index = 1
	for i, v in pairs(temp_attr) do
		local img_fight = ""
		local my_fight = 0
		if self.m_tOtherData and self.m_tOtherData.isMyStone == false then --进入他人的时候需要跟本人的进行判断
			for k,m in pairs(tData.attr) do
				if i == k then
					my_fight = m
					break
				end
			end
			local str_img = ""
			if v > my_fight then
				str_img = "ui/common/common_btn_jiant_05_1.png"
			else
				str_img = "ui/common/common_btn_jiant_05.png"
			end
			img_fight = string.format([[<T C="229,105,22" S="20" P="0">(%d)</T><I Z="0.8">%s</I>]],my_fight, str_img)
		end
		local is_show = nil
		if self.m_tOtherData then
			if self.m_tOtherData.isMyStone == false and v == 0 and my_fight == 0 then
				is_show = true
			else
				if v == 0 then
					is_show = true
				end
			end
		end
		if not is_show then
			local txtRich = WZUIFreeTextBox:create()
			txtRich:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
			txtRich:setUseAbsCoordinate(true)
			txtRich:setMaxWidth(200)
			txtRich:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s: </T><T C="229,105,22" S="20" P="1">%d</T>%s]],ATTR_TITLE[i], v, img_fight))
			conTips28:addChild(txtRich)
			local _x = 15 + ((index-1)%2)*165
			local _y = 158 - (math.floor((index-1)/2)*30)
			txtRich:setAbsPosition(GlobalMethod:ccp(_x,_y))
			index = index + 1
		end
	end
end

--@brief 	选择出生年月日和所在城市
function WndTips:_update75()
	WZLog("WndTips:_update75")
	local tData = self.m_tData
	if tData == nil then return end 
	local con = GetElement(self.m_root,"conType30_WndTips",WZUIContainer)
	con:setVisible(false)

	GetElement(self.m_root, "conChooseOut_WndTips30", WZUIContainer):setVisible(true)
	local conChoose = GetElement(self.m_root, "conChoose_WndTips30", WZUIContainer)
	conChoose:setVisible(true)
	local nCount = 12 
	if tData.type == 4 then 
		conChoose:setAbsContentSize(GlobalMethod:CCSize(90,315))
		conChoose:updateRelativeSize()
	elseif tData.type == 5 then 
		conChoose:setAbsContentSize(GlobalMethod:CCSize(100,315))
		conChoose:updateRelativeSize()
	elseif tData.type == 10 then 
		conChoose:setAbsContentSize(GlobalMethod:CCSize(190,315))
		conChoose:updateRelativeSize()
	elseif tData.type == 11 then 
		conChoose:setAbsContentSize(GlobalMethod:CCSize(190,315))
		conChoose:updateRelativeSize()
	end
	if ProjConfig.LANGUAGE == "vn" then
		if tData.type == 1 or tData.type == 2 or tData.type == 3 then 
			conChoose:setAbsContentSize(GlobalMethod:CCSize(100,315))
			conChoose:updateRelativeSize()
		elseif tData.type == 4 then
			conChoose:setAbsContentSize(GlobalMethod:CCSize(190,315))
			conChoose:updateRelativeSize()
		end
	end
	
	local tbList = GetElement(self.m_root, "tbList_WndTips30", WZUITableContainer)
	tbList:cleanTable()
	if tData.type == 1 then 
		for i = 1,101 do 
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText((os.date("%Y")-101+i)..LocalStrings.SPACE30)
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(os.date("%Y")-101+i)
			if tData.playerAge and tData.playerAge > 0 and (101-i == tData.playerAge) then 
				GetElement(celElement, "img9Sel_cellChooseItem", WZUI9Image):setVisible(true)
			end

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)

			if ProjConfig.LANGUAGE == "vn" then
				local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
				conContent:setRelativeSize(GlobalMethod:CCSize(1.6,1))
				conContent:updateRelativeSize()
			end	
		end
		--停留到上次设置的年龄
		local nMaxPosY = tbList:getMaxPosition().y
		if tData.playerAge == 0 or tData.playerAge <= 12 then
			tbList:getMoveElement():setPositionY(nMaxPosY)
		else
			local nCurPosY = nMaxPosY - 24*(tData.playerAge - 12)
			if nCurPosY < tbList:getMinPosition().y then 
				nCurPosY = tbList:getMinPosition().y
			end
			tbList:getMoveElement():setPositionY(nCurPosY)
		end
	elseif tData.type == 2 then 
		for i = 1,12 do 
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText(i..LocalStrings.SPACE31)
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(i)
			if tData.month and tData.month > 0 and i == tData.month then 
				GetElement(celElement, "img9Sel_cellChooseItem", WZUI9Image):setVisible(true)
			end

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)

			if ProjConfig.LANGUAGE == "vn" then
				local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
				conContent:setRelativeSize(GlobalMethod:CCSize(1.6,1))
				conContent:updateRelativeSize()
			end
		end
	elseif tData.type == 3 then 
		local nIndex = 0
		for i = 1, 31 do 
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText(i..LocalStrings.SPACE32)
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(i)
			if tData.day and tData.day > 0 and i == tData.day then 
				GetElement(celElement, "img9Sel_cellChooseItem", WZUI9Image):setVisible(true)
				nIndex = i 
			end

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)

			if ProjConfig.LANGUAGE == "vn" then
				local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
				conContent:setRelativeSize(GlobalMethod:CCSize(1.6,1))
				conContent:updateRelativeSize()
			end
		end
		--停留到上次设置的日期
		local nMinPosY = tbList:getMinPosition().y
		if nIndex == 0 or nIndex <= 12 then
			tbList:getMoveElement():setPositionY(nMinPosY)
		else
			local nCurPosY = nMinPosY + 24*(nIndex - 12)
			if nCurPosY < tbList:getMinPosition().y then 
				nCurPosY = tbList:getMinPosition().y
			end
			tbList:getMoveElement():setPositionY(nCurPosY)
		end
	elseif tData.type == 4 then 
		local nIndex = 0 
		for i, value in pairs(GDatatab_city) do
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
			conContent:setRelativeSize(GlobalMethod:CCSize(1.3, 1))
			conContent:updateRelativeSize()
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText(value.province)
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(value.id)
			if tData.province and tData.province > 0 and value.id == tData.province then 
				GetElement(celElement, "img9Sel_cellChooseItem", WZUI9Image):setVisible(true)
				nIndex = value.id 
			end

			celElement:setTag(value.id-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)

			if ProjConfig.LANGUAGE == "vn" then
				txtLabel:setRelativePosition(GlobalMethod:ccp(0.02,0.5))
				conContent:setRelativeSize(GlobalMethod:CCSize(3,1))
				conContent:updateRelativeSize()
			end	
		end
		--停留到上次设置的日期
		local nMinPosY = tbList:getMinPosition().y
		if nIndex == 0 or nIndex <= 12 then
			tbList:getMoveElement():setPositionY(nMinPosY)
		else
			local nCurPosY = nMinPosY + 24*(nIndex - 12)
			if nCurPosY < tbList:getMinPosition().y then 
				nCurPosY = tbList:getMinPosition().y
			end
			tbList:getMoveElement():setPositionY(nCurPosY)
		end
	elseif tData.type == 5 then 
		local configData = GDatatab_city["id_" .. tData.province]
		local cityList = SplitStringWithSeparator(configData.city, "|")
		local nIndex = 0 
		for i = 1, #cityList do
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
			conContent:setRelativeSize(GlobalMethod:CCSize(1.7, 1))
			conContent:updateRelativeSize()
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText(cityList[i])
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(i)
			if tData.city and tData.city > 0 and i == tData.city then 
				GetElement(celElement, "img9Sel_cellChooseItem", WZUI9Image):setVisible(true)
				nIndex = i
			end

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)
		end
		--停留到上次设置的日期
		local nMinPosY = tbList:getMinPosition().y
		if nIndex == 0 or nIndex <= 12 then
			tbList:getMoveElement():setPositionY(nMinPosY)
		else
			local nCurPosY = nMinPosY + 24*(nIndex - 12)
			if nCurPosY < tbList:getMinPosition().y then 
				nCurPosY = tbList:getMinPosition().y
			end
			tbList:getMoveElement():setPositionY(nCurPosY)
		end
	elseif tData.type == 10 then 
		for i = 1, #tData.blessList do 
			local celElement = WZUISystem:getInstance():createElement("cellBlessWordItem")
			celElement:setVisible(true)
			local txtLabel = GetElement(celElement, "txtLabel_cellBlessWordItem", WZUILabelTTF)
			txtLabel:setText(tData.blessList[i])
			GetElement(celElement, "btnTab_cellBlessWordItem", WZUIButton):setTag(i)
			if tData.selIndex and tData.selIndex > 0 and i == tData.selIndex then 
				GetElement(celElement, "img9Sel_cellBlessWordItem", WZUI9Image):setVisible(true)
			end

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)

			if ProjConfig.LANGUAGE == "vn" then
				txtLabel:setScale(0.7)
			end
		end
	elseif tData.type == 11 then --调研选择省份
		local nIndex = 0 
		for i, value in pairs(tData.answer) do
			local celElement = WZUISystem:getInstance():createElement("cellChooseItem")
			celElement:setVisible(true)
			local conContent = GetElement(celElement, "conContent_WndTips30", WZUIContainer)
			conContent:setRelativeSize(GlobalMethod:CCSize(3, 1))
			conContent:updateRelativeSize()
			local txtLabel = GetElement(celElement, "txtLabel_cellChooseItem", WZUILabelTTF)
			txtLabel:setText(value)
			GetElement(celElement, "btnTab_cellChooseItem", WZUIButton):setTag(i)

			celElement:setTag(i-1)    --从0开始设置Tag值
			tbList:setCellElement(celElement)
		end
	end
end

--@brief 	禁忌之地圈数奖励
function WndTips:_update76()
	WZLog("WndTips:_update76")
	local tData = self.m_tData
	if tData == nil then return end 
	local con = GetElement(self.m_root,"conType30_WndTips",WZUIContainer)
	con:setVisible(false)

	GetElement(self.m_root, "conCircleReward_WndTips30", WZUIContainer):setVisible(true)
	local tbCircleReward = GetElement(self.m_root, "tbCircleReward_WndTips30", WZUITableContainer)
	tbCircleReward:cleanTable()

	local forbiddenTaskReward = CacheCenter:getGameParam().forbiddenTaskReward
	local rewardConfig = json.decode(forbiddenTaskReward)
	WZLog("WndTips:_update76", Serialize(rewardConfig))
	for i = 1, #tData.taskStatus do
		local element = WZUISystem:getInstance():createElement("cellCircleReward")
		if element then 
			element:setVisible(true)
			local txtTarget = GetElement(element, "txtTarget_cellCircleReward", WZUILabelTTF)
			txtTarget:setText(tData.circleNum .. "/" .. tData.taskTarget[i])
			local imgStatus = GetElement(element, "imgStatus_cellCircleReward", WZUIImage)
			if tData.taskStatus[i] == 2 then 
				imgStatus:setFile("ui/common/commom_icon_ylq.png")
			elseif tData.taskStatus[i] == 1 then 
				imgStatus:setFile("ui/common/common_icon_ywc.png")
			end

			local ids, nums = SplitItemString(rewardConfig[i].reward, CacheCenter:getPlayerInfo().sex)
			for j = 1, #ids do
				local conReward = GetElement(element, "conReward" .. j .. "_cellCircleReward", WZUIContainer)
				local celElement, tNewObj = CellGoodItem:createElement()
				if celElement and tNewObj then 
					tNewObj:setCellGoodLocalId(ids[j], nums[j], 17)
					tNewObj:setItemClickFun(self, self.onRewardItemClick)
					celElement:setScale(0.8)
					conReward:addChild(celElement)
				end
			end
			element:setTag(i - 1)
			tbCircleReward:setCellElement(element)
		end
	end
end

--@brief 	选择祝福贺卡
function WndTips:_update77()
	WZLog("WndTips:_update77")
	local tData = self.m_tData
	if tData == nil then return end 
	local con = GetElement(self.m_root,"conType30_WndTips",WZUIContainer)
	con:setVisible(false)

	GetElement(self.m_root, "cellChooseBlessCard_WndTips30", WZUIContainer):setVisible(true)
	
	local txtSmallLeft1 = GetElement(self.m_root, "txtSmallLeft1_WndTips30", WZUILabelTTF)
	local txtSmallLeft2 = GetElement(self.m_root, "txtSmallLeft2_WndTips30", WZUILabelTTF)

	txtSmallLeft1:setText(tData.num1)
	txtSmallLeft2:setText(tData.num2)
	if tData.nTag == 4 then 
		GetElement(self.m_root, "conCard2_WndTips30", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conCard1_WndTips30", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.58))
	end
end

--@brief 	突破星星
function WndTips:_update78()
	WZLog("WndTips:_update78")
	local tData = self.m_tData
	if tData == nil then return end 
	local imgIcon = GetElement(self.m_root, "img_WndTips", WZUIImage)
	imgIcon:setScale(0.5)
	if tData.star == 6 then 
		imgIcon:setFile("ui/bag/common_icon_xx_02.png")
	else
		imgIcon:setFile("ui/bag/common_icon_xx_01.png")
	end
	GetElement(self.m_root, "numType1_WndTips", WZUILabelAtlasFont):setVisible(false)
	
	local title = GetElement(self.m_root, "title", WZUIFreeTextBox)
	local sFormat1 = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">+%d</T>]]
	local sFormat2 = [[<BR>10</BR>]]
	local sFormat3 = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">+%.2f%%</T>]]
	local strContent = ""
	for i = 1, #tData.value do
		local strWord 
		local strTemp 
		if tData.value[i][1] == -1 then 
			strWord = LocalStrings.BREAK_TEXT1[3] .. ":"
			strTemp = string.format(sFormat1, strWord, tData.value[i][2])
		elseif tData.value[i][1] == -2 or tData.value[i][1] == -3 then 
			strWord = ATTR_TITLE[tData.value[i][1]]
			strTemp = string.format(sFormat3, strWord, (100 * tData.value[i][2]/10000))
		else
			strWord = ATTR_TITLE[tData.value[i][1]]
			strTemp = string.format(sFormat1, strWord, tData.value[i][2])
		end
		if i > 1 then 
			strContent = strContent .. sFormat2
		end
		strContent = strContent .. strTemp 
	end

	title:setShowText(strContent)
end

--@brief	活动勋章	tips
function WndTips:_update79()
	WZLog("WndTips:_update79")
	if self.m_tData == nil then return end
	local playerInfo = self.m_tData
	GetElement(self.m_root,"conType48_WndTips",WZUIContainer):setVisible(true)

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile(playerInfo.icon)
	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setScale(0.7)
	--名字
	if playerInfo.itemId and playerInfo.itemId == 161078 then 
		local strName = string.format(LocalStrings.SEAFARROAD_TEXT1[19], playerInfo.level)
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(strName .. " " .. playerInfo.name)
	else
		GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(playerInfo.name)
	end
	--等级
	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setText(LocalStrings.LV .. playerInfo.level)
	--描述
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setText(playerInfo.desc)
	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	local m_height = 300
	if playerInfo.property and #playerInfo.property > 3 then
		m_height = m_height + 40 * (#playerInfo.property - 3)
	end
	conBg:setAbsContentSize(GlobalMethod:CCSize(280, m_height))
	conBg:updateRelativeSize()
	
	--战力加成
	local nFighting = WndCard:_caculateFighting(playerInfo.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	if ProjConfig.LANGUAGE == "vn" then
		local txtFightingT = GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF)
		txtFightingT:setScale(0.7)
		txtFightingT:setRelativePosition(GlobalMethod:ccp(0.05,0.836666))
		GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setFontSize(16)
		local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
		ttf6Type48:setFontSize(16)
		ttf6Type48:setDimensions(GlobalMethod:CCSize(160,0))
		local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1Type48:setFontSize(16)
		ttf1Type48:setRelativePosition(GlobalMethod:ccp(0.35,0.3))
	end

	local conProperty = GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer)
	conProperty:setVisible(true)
	if playerInfo.property and #playerInfo.property > 0 then 
		for i = 1, #playerInfo.property do
			if playerInfo.property[i] then 
				local txtAllAttrValue1 = WZUILabelTTF:create()
				txtAllAttrValue1:setFontSize(20)
				txtAllAttrValue1:setColor(ccc3(127,70,26))
				txtAllAttrValue1:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue1:setRelativePosition(ccp(0.1,0.82-i*0.18))
				txtAllAttrValue1:setText(ATTR_TITLE[playerInfo.property[i][1]]..":")
				conProperty:addChild(txtAllAttrValue1)

				local txtAllAttrValue2 = WZUILabelTTF:create()
				txtAllAttrValue2:setFontSize(20)
				txtAllAttrValue2:setColor(ccc3(5,180,0))
				txtAllAttrValue2:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue2:setRelativePosition(ccp(1,0.5))
				txtAllAttrValue2:setText(playerInfo.property[i][2])
				txtAllAttrValue1:addChild(txtAllAttrValue2)
			end
		end
	end
end

--@brief 	共生录属性
function WndTips:_update80()
	WZLog("WndTips:_update80")
	local tData = self.m_tData
	if tData == nil then return end

	-- tData = {level=1,property={["4"]=3000,["1"]=6000,["3"]=1500},fighting=90000}

	local nPrevLevel, nNextLevel = 0, 0
	for i=1, GetTableLen(GDatatab_shape_group_advance) do
		local tShapeGroupAdvance = GDatatab_shape_group_advance["id_"..i]
		if tShapeGroupAdvance.property ~= -1 then
			if i <= tData.level then
				nPrevLevel = i
			end
			if i > tData.level then
				nNextLevel = i
				break
			end
		end
	end
	local tPrevAdvance = GDatatab_shape_group_advance["id_"..nPrevLevel]
	local tNextAdvance = GDatatab_shape_group_advance["id_"..nNextLevel]

	local conContent = GetElement(self.m_root,"conContent_WndTips",WZUIContainer)
	local nMaxWeight, nMaxHeight = 300, 400
	local nCurHeight = nMaxHeight

	-- 已激活加成属性
	if tPrevAdvance then
		nCurHeight = nCurHeight - 30
		local txtAttrName1 = WZUILabelTTF:create()
		txtAttrName1:setFontSize(22)
		txtAttrName1:setColor(ccc3(99,255,95))
		txtAttrName1:setUseAbsCoordinate(true)
		txtAttrName1:setAnchorPoint(ccp(0,0.5))
		txtAttrName1:setAbsPosition(ccp(25,nCurHeight))
		txtAttrName1:setText(string.format(LocalStrings.PHANTOM_COMBINATION_9,tPrevAdvance.level).."("..LocalStrings.STAR_SOUL_HAVED_ACTIVE..")")
		conContent:addChild(txtAttrName1)

		nCurHeight = nCurHeight - 2
		local props = CopyTable(tPrevAdvance.property)
		table.sort( props, function(a,b)
			return a[1] < b[1]
		end )
	    for i=1,#props do
	    	local txtPosX = 0
	    	if i % 2 == 1 then
				nCurHeight = nCurHeight - 25
				txtPosX = 30
			else
				txtPosX = nMaxWeight/2
	    	end
			local txtAttrValue1 = WZUILabelTTF:create()
		    txtAttrValue1:setFontSize(20)
		    txtAttrValue1:setColor(ccc3(127,70,26))
			txtAttrValue1:setUseAbsCoordinate(true)
		    txtAttrValue1:setAnchorPoint(ccp(0,0.5))
		    txtAttrValue1:setAbsPosition(ccp(txtPosX,nCurHeight))
			txtAttrValue1:setText(ATTR_TITLE[props[i][1]]..":")
		    conContent:addChild(txtAttrValue1)

			local txtAttrValue2 = WZUILabelTTF:create()
		    txtAttrValue2:setFontSize(20)
		    txtAttrValue2:setColor(ccc3(229,105,22))
		    txtAttrValue2:setAnchorPoint(ccp(0,0.5))
		    txtAttrValue2:setRelativePosition(ccp(1,0.5))
			txtAttrValue2:setText(props[i][2])
		    txtAttrValue1:addChild(txtAttrValue2)
	    end
	end

	-- 未激活加成属性
	if tNextAdvance then
		nCurHeight = nCurHeight - 35
		local txtAttrName1 = WZUILabelTTF:create()
		txtAttrName1:setFontSize(20)
		txtAttrName1:setColor(ccc3(255,89,74))
		txtAttrName1:setUseAbsCoordinate(true)
		txtAttrName1:setAnchorPoint(ccp(0,0.5))
		txtAttrName1:setAbsPosition(ccp(25,nCurHeight))
		txtAttrName1:setText(string.format(LocalStrings.PHANTOM_COMBINATION_9,tNextAdvance.level).."("..LocalStrings.STAR_SOUL_NOT_ACTIVE..")")
		conContent:addChild(txtAttrName1)

		nCurHeight = nCurHeight - 2
		local props = CopyTable(tNextAdvance.property)
		table.sort( props, function(a,b)
			return a[1] < b[1]
		end )
	    for i=1,#props do
	    	local txtPosX = 0
	    	if i % 2 == 1 then
				nCurHeight = nCurHeight - 25
				txtPosX = 30
			else
				txtPosX = nMaxWeight/2
	    	end
			local txtAttrValue1 = WZUILabelTTF:create()
		    txtAttrValue1:setFontSize(20)
		    txtAttrValue1:setColor(ccc3(127,70,26))
			txtAttrValue1:setUseAbsCoordinate(true)
		    txtAttrValue1:setAnchorPoint(ccp(0,0.5))
		    txtAttrValue1:setAbsPosition(ccp(txtPosX,nCurHeight))
			txtAttrValue1:setText(ATTR_TITLE[props[i][1]]..":")
		    conContent:addChild(txtAttrValue1)

			local txtAttrValue2 = WZUILabelTTF:create()
		    txtAttrValue2:setFontSize(20)
		    txtAttrValue2:setColor(ccc3(229,105,22))
		    txtAttrValue2:setAnchorPoint(ccp(0,0.5))
		    txtAttrValue2:setRelativePosition(ccp(1,0.5))
			txtAttrValue2:setText(props[i][2])
		    txtAttrValue1:addChild(txtAttrValue2)
	    end
	end


	-- 皮肤总加成属性
	if tData.property and GetTableLen(tData.property) > 0 then
		-- 分割线
		nCurHeight = nCurHeight - 30
		local conDividingLine1 = WZUIContainer:create()
		conDividingLine1:setUseAbsSize(true)
		conDividingLine1:setAbsContentSize(GlobalMethod:CCSize(250,3))
		conDividingLine1:setUseAbsCoordinate(true)
		conDividingLine1:setAnchorPoint(ccp(0.5,0.5))
	    conDividingLine1:setAbsPosition(ccp(nMaxWeight/2,nCurHeight))
		conContent:addChild(conDividingLine1)
		local imgDividingLine1 = WZUI9Image:create()
		imgDividingLine1:setFile("ui/common/frame_fengexian_01.png")
		conDividingLine1:addChild(imgDividingLine1)

		nCurHeight = nCurHeight - 30
		local txtAllAttrName = WZUILabelTTF:create()
		txtAllAttrName:setFontSize(18)
		txtAllAttrName:setColor(ccc3(127,70,26))
		txtAllAttrName:setUseAbsCoordinate(true)
		txtAllAttrName:setAnchorPoint(ccp(0,0.5))
		txtAllAttrName:setAbsPosition(ccp(25,nCurHeight))
		txtAllAttrName:setText(LocalStrings.PHANTOM_COMBINATION_10)
		conContent:addChild(txtAllAttrName)

		nCurHeight = nCurHeight - 2
		local props = {}
		for k,v in pairs(tData.property) do
			table.insert(props, {[1]=tonumber(k), [2]=v})
		end
		table.sort( props, function(a,b)
			return a[1] < b[1]
		end )
	    for i=1,#props do
	    	local txtPosX = 0
	    	if i % 2 == 1 then
				nCurHeight = nCurHeight - 25
				txtPosX = 30
			else
				txtPosX = nMaxWeight/2
	    	end
			local txtAllAttrValue1 = WZUILabelTTF:create()
		    txtAllAttrValue1:setFontSize(20)
		    txtAllAttrValue1:setColor(ccc3(127,70,26))
			txtAllAttrValue1:setUseAbsCoordinate(true)
		    txtAllAttrValue1:setAnchorPoint(ccp(0,0.5))
		    txtAllAttrValue1:setAbsPosition(ccp(txtPosX,nCurHeight))
			txtAllAttrValue1:setText(ATTR_TITLE[props[i][1]]..":")
		    conContent:addChild(txtAllAttrValue1)

			local txtAllAttrValue2 = WZUILabelTTF:create()
		    txtAllAttrValue2:setFontSize(20)
		    txtAllAttrValue2:setColor(ccc3(229,105,22))
		    txtAllAttrValue2:setAnchorPoint(ccp(0,0.5))
		    txtAllAttrValue2:setRelativePosition(ccp(1,0.5))
			txtAllAttrValue2:setText(props[i][2])
		    txtAllAttrValue1:addChild(txtAllAttrValue2)
	    end
	end

	-- 分割线
	nCurHeight = nCurHeight - 30
	local conDividingLine2 = WZUIContainer:create()
	conDividingLine2:setUseAbsSize(true)
	conDividingLine2:setAbsContentSize(GlobalMethod:CCSize(250,3))
	conDividingLine2:setUseAbsCoordinate(true)
	conDividingLine2:setAnchorPoint(ccp(0.5,0.5))
    conDividingLine2:setAbsPosition(ccp(nMaxWeight/2,nCurHeight))
	conContent:addChild(conDividingLine2)
	local imgDividingLine2 = WZUI9Image:create()
	imgDividingLine2:setFile("ui/common/frame_fengexian_01.png")
	conDividingLine2:addChild(imgDividingLine2)

	-- 战力
	nCurHeight = nCurHeight - 30
	local txtFightValue1 = WZUILabelTTF:create()
    txtFightValue1:setFontSize(22)
    txtFightValue1:setColor(ccc3(127,70,26))
	txtFightValue1:setUseAbsCoordinate(true)
    txtFightValue1:setAnchorPoint(ccp(0,0.5))
    txtFightValue1:setAbsPosition(ccp(25,nCurHeight))
	txtFightValue1:setText(LocalStrings.PET_TEXT17..":")
    conContent:addChild(txtFightValue1)

	local txtFightValue2 = WZUILabelTTF:create()
    txtFightValue2:setFontSize(22)
    txtFightValue2:setColor(ccc3(229,105,22))
    txtFightValue2:setAnchorPoint(ccp(0,0.5))
    txtFightValue2:setRelativePosition(ccp(1,0.5))
	txtFightValue2:setText(tData.fighting)
    txtFightValue1:addChild(txtFightValue2)


	-- 分割线
	nCurHeight = nCurHeight - 30
	local conDividingLine3 = WZUIContainer:create()
	conDividingLine3:setUseAbsSize(true)
	conDividingLine3:setAbsContentSize(GlobalMethod:CCSize(250,3))
	conDividingLine3:setUseAbsCoordinate(true)
	conDividingLine3:setAnchorPoint(ccp(0.5,0.5))
    conDividingLine3:setAbsPosition(ccp(nMaxWeight/2,nCurHeight))
	conContent:addChild(conDividingLine3)
	local imgDividingLine3 = WZUI9Image:create()
	imgDividingLine3:setFile("ui/common/frame_fengexian_01.png")
	conDividingLine3:addChild(imgDividingLine3)

	-- 说明
	nCurHeight = nCurHeight - 20
	local txtDescription = WZUILabelTTF:create()
	txtDescription:setFontSize(20)
	txtDescription:setColor(ccc3(127,70,26))
	txtDescription:setUseAbsCoordinate(true)
	txtDescription:setAnchorPoint(ccp(0.5,1))
	txtDescription:setAbsPosition(ccp(nMaxWeight/2,nCurHeight))
	txtDescription:setText(LocalStrings.PHANTOM_COMBINATION_11)
	txtDescription:setDimensions(GlobalMethod:CCSize(250,0))
	txtDescription:setAlignment(kCCTextAlignmentLeft)
	conContent:addChild(txtDescription)

	-- 结尾
	local txtDescH = txtDescription:getLabelContentSize().height
	nCurHeight = nCurHeight - txtDescH - 20
	
	-- 设置背景大小
	local conBG = GetElement(self.m_root,"conBG_WndTips",WZUIContainer)
	conBG:setAbsContentSize(GlobalMethod:CCSize(nMaxWeight, nMaxHeight - nCurHeight))
	conBG:updateRelativeSize()

end

--@brief 	特权蓝钻提示
function WndTips:_update81()
	WZLog("WndTips:_update81")
	local conView = GetElement(self.m_root,"conViewType32_WndTips",WZUIContainer)
	local labStartY = 0
	local maxWidth = 0
	local nMaxCount = 0
	
	local addStr = self.m_tData.attDesc

	local value = WZUILabelTTF:create()
	value:setText(addStr)
	value:setUseAbsCoordinate(true)
	value:setDimensions(GlobalMethod:CCSize(400,0))
    value:setAnchorPoint(ccp(0,0.5))
    value:setColor(ccc3(127,70,26))
    value:setFontSize(22)
    value:setAlignment(kCCTextAlignmentLeft)
    conView:addChild(value,100)
    
    local size = value:getLabelContentSize()
    labStartY = labStartY + 20 + size.height
    if maxWidth < size.width then
    	maxWidth = size.width 
    end
    value:setAbsPosition(ccp(20,labStartY))

	labStartY = labStartY + 40
	maxWidth = maxWidth + 40
	local imgBg = WZUI9Image:create()
	imgBg:setFile("ui/common/common_scale9_di24.png")
	local con = WZUIContainer:create()
	con:setUseAbsCoordinate(true)
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(maxWidth,labStartY))
	con:addChild(imgBg)
	con:setAbsPosition(ccp(maxWidth/2,labStartY/2))
	GetElement(self.m_root,"conBgType32_WndTips",WZUIContainer):addChild(con)
end

--@brief 	度假村镶嵌加成提示
function WndTips:_update82()
	local tData = self.m_tData 
	WZLog("WndTips:_update82", Serialize(tData))
	for i=1,20 do
		GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setText("")
	end

	local ttf1Type43 = GetElement(self.m_root, "ttf1Type43_WndTips", WZUILabelTTF)
	ttf1Type43:setTextKey("")

	local nCount = #tData.property
	local conType43 = GetElement(self.m_root, "conType43_WndTips", WZUIContainer)
	local nCountPlayer = 0
	if tData.winType == 1 then 
		nCountPlayer = #tData.propertyPlayer
		conType43:setAbsContentSize(GlobalMethod:CCSize(240, 60 + nCount * 30 + nCountPlayer * 30))
	elseif tData.winType == 2 then 
		conType43:setAbsContentSize(GlobalMethod:CCSize(240, 95 + nCount * 30))
	end
	conType43:updateRelativeSize()

	if tData.winType == 1 then --土坑镶嵌和等级属性
		GetElement(self.m_root, "conFighting_WndTips43", WZUIContainer):setVisible(false)
		ttf1Type43:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[29])
		for i = 1, nCount do
			local nIndex = 2*i - 1
			local label1Type43 = GetElement(self.m_root,"label"..nIndex.."Type43_WndTips",WZUILabelTTF)
			local label2Type43 = GetElement(self.m_root,"label"..(nIndex + 1).."Type43_WndTips",WZUILabelTTF)

			label1Type43:setText(HVATTR_TITLE[tData.property[i][1]] .. ":")
			local addPro = (tData.property[i][2] * 100 / 10000).."%"
			label2Type43:setText("+" .. addPro)
		end
		--人物属性
		for i = 1, nCountPlayer do
			local nIndex = 2*i - 1 + nCount * 2
			local label1Type43 = GetElement(self.m_root,"label"..nIndex.."Type43_WndTips",WZUILabelTTF)
			local label2Type43 = GetElement(self.m_root,"label"..(nIndex + 1).."Type43_WndTips",WZUILabelTTF)

			label1Type43:setText(ATTR_TITLE[tData.propertyPlayer[i][1]] .. ":")
			local addPro = tData.propertyPlayer[i][2]
			label2Type43:setText("+" .. addPro)
		end

		if ProjConfig.LANGUAGE == "vn" then
			for i=1,20 do
				GetElement(self.m_root,"label"..i.."Type43_WndTips",WZUILabelTTF):setFontSize(18)
			end
		end
	elseif tData.winType == 2 then --度假村成就属性加成
		ttf1Type43:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[39])
		for i = 1, nCount do
			local nIndex = 2*i - 1
			local label1Type43 = GetElement(self.m_root,"label"..nIndex.."Type43_WndTips",WZUILabelTTF)
			local label2Type43 = GetElement(self.m_root,"label"..(nIndex + 1).."Type43_WndTips",WZUILabelTTF)

			label1Type43:setText(ATTR_TITLE[tData.property[i][1]] .. ":")
			local addPro = tData.property[i][2]
			label2Type43:setText("+" .. addPro)
		end

		local labelFight1Type43 = GetElement(self.m_root, "labelFight1Type43_WndTips", WZUILabelTTF)
		labelFight1Type43:setTextKey("")
		labelFight1Type43:setText(LocalStrings.BATTLE .. ":")
		GetElement(self.m_root, "labelFight2Type43_WndTips", WZUILabelTTF):setText(tData.fighting)
	end
end

--@brief 	度假村土坑操作按钮
function WndTips:_update83()
	local tData = self.m_tData 
	WZLog("WndTips:_update83", Serialize(tData))
	GetElement(self.m_root, "conType10_WndTips", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conType10_1_WndTips", WZUIContainer):setVisible(true)
	
	for i = 1, #tData.tBtnIndex do
		local btnHV = GetElement(self.m_root, "btnHV" .. i .. "_WndTips10", WZUIButton)
		btnHV:setTag(tData.tBtnIndex[i])
		btnHV:setVisible(true)
		GetElement(self.m_root, "txtBtn" .. i .. "_WndTips10", WZUILabelTTF):setText(tData.tBtnName[i])
	end
end

--@brief 	符文共振
function WndTips:_update84()
	local tData = self.m_tData 
	WZLog("WndTips:_update84", Serialize(tData))

	local tempProperty = json.decode(tData.value)
	local property = {}
	for k,v in pairs(tempProperty) do
		if v > 0 and k ~= "fighting" then
			local tempPro = {}
			tempPro[1] = tonumber(k)
			tempPro[2] = v
			table.insert(property,tempPro)
		end
	end
	table.sort(property,function (a,b)
		return a[1]<b[1]
	end)

	local conIcon = GetElement(self.m_root,"conIcon_WndTips48",WZUIContainer)

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/common/xz_icon_fuwen.png")

	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setColor(ccc3(127,70,26))
	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(LocalStrings.RUNE_OPTIMIZE)

	local nAddValue = CacheCenter:getGameParam().runeResonateBuffAdd / 100
	local strFormat = [[<T C="127,70,26" S="20" P="1">%s: </T><T C="255,89,74" S="20" P="1">+%s%%</T>]]
	local ftxtProperty1 = WZUIFreeTextBox:create()
	ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.35,0.357))
	ftxtProperty1:setMaxWidth(400)
	ftxtProperty1:setShowText(string.format(strFormat,LocalStrings.CHARACTER_ATTRIBUTES,nAddValue))
	conIcon:addChild(ftxtProperty1)

	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setText("")
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setText("")

	
	--战力加成
	local nFighting = tempProperty["fighting"]
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	local conProperty = GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer)
	conProperty:setVisible(true)
	conProperty:setRelativePosition(GlobalMethod:ccp(0.5,1.028))
	if property and #property > 0 then 
		for i = 1, #property do
			if property[i] then 
				local txtAllAttrValue1 = WZUILabelTTF:create()
				txtAllAttrValue1:setFontSize(20)
				txtAllAttrValue1:setColor(ccc3(127,70,26))
				txtAllAttrValue1:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue1:setRelativePosition(ccp(0.1+(math.floor((i+1)%2)*0.45),0.82-(math.floor((i+1)/2)*0.18)))
				local tempIndex = i%2 == 1 and math.ceil(i/2) or math.ceil(#property/2) + math.ceil(i/2)
				txtAllAttrValue1:setText(ATTR_TITLE[property[tempIndex][1]]..":")
				conProperty:addChild(txtAllAttrValue1)

				local txtAllAttrValue2 = WZUILabelTTF:create()
				txtAllAttrValue2:setFontSize(20)
				txtAllAttrValue2:setColor(ccc3(5,180,0))
				txtAllAttrValue2:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue2:setRelativePosition(ccp(1,0.5))
				txtAllAttrValue2:setText(property[tempIndex][2])
				txtAllAttrValue1:addChild(txtAllAttrValue2)
			end
		end
	end

	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	local m_height = 135
	m_height = m_height + 28 * math.ceil(#property/2)
	conBg:setAbsContentSize(GlobalMethod:CCSize(280, m_height))
	conBg:updateRelativeSize()

	if ProjConfig.LANGUAGE == "vn" then
		ftxtProperty1:setScale(0.7)
		txtFighting:setScale(0.7)
	end
end

--@brief 	卡魂瞻仰
function WndTips:_update85()
	local tData = self.m_tData 
	WZLog("WndTips:_update85", Serialize(tData))

	local tempProperty = json.decode(tData.value)
	local property = {}
	for k,v in pairs(tempProperty) do
		if v > 0 and k ~= "fighting" then
			local tempPro = {}
			tempPro[1] = tonumber(k)
			tempPro[2] = v
			table.insert(property,tempPro)
		end
	end
	table.sort(property,function (a,b)
		return a[1]<b[1]
	end)

	local conIcon = GetElement(self.m_root,"conIcon_WndTips48",WZUIContainer)

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/common/xz_icon_kh.png")

	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setColor(ccc3(127,70,26))
	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText(LocalStrings.CARD_TEXT43)

	local nAddValue = CacheCenter:getGameParam().cardSoulBuffAdd / 100
	local strFormat = [[<T C="127,70,26" S="20" P="1">%s: </T><T C="255,89,74" S="20" P="1">+%s%%</T>]]
	local ftxtProperty1 = WZUIFreeTextBox:create()
	ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.35,0.357))
	ftxtProperty1:setMaxWidth(400)
	ftxtProperty1:setShowText(string.format(strFormat,LocalStrings.CHARACTER_ATTRIBUTES,nAddValue))
	conIcon:addChild(ftxtProperty1)

	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setText("")
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setText("")

	--战力加成
	local nFighting = tempProperty["fighting"]
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	local conProperty = GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer)
	conProperty:setVisible(true)
	conProperty:setRelativePosition(GlobalMethod:ccp(0.5,1.028))
	if property and #property > 0 then 
		for i = 1, #property do
			if property[i] then 
				local txtAllAttrValue1 = WZUILabelTTF:create()
				txtAllAttrValue1:setFontSize(20)
				txtAllAttrValue1:setColor(ccc3(127,70,26))
				txtAllAttrValue1:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue1:setRelativePosition(ccp(0.1+(math.floor((i+1)%2)*0.45),0.82-(math.floor((i+1)/2)*0.18)))
				local tempIndex = i%2 == 1 and math.ceil(i/2) or math.ceil(#property/2) + math.ceil(i/2)
				txtAllAttrValue1:setText(ATTR_TITLE[property[tempIndex][1]]..":")
				conProperty:addChild(txtAllAttrValue1)

				local txtAllAttrValue2 = WZUILabelTTF:create()
				txtAllAttrValue2:setFontSize(20)
				txtAllAttrValue2:setColor(ccc3(5,180,0))
				txtAllAttrValue2:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue2:setRelativePosition(ccp(1.2,0.5))
				txtAllAttrValue2:setText(property[tempIndex][2])
				txtAllAttrValue1:addChild(txtAllAttrValue2)
			end
		end
	end

	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	local m_height = 135
	m_height = m_height + 28 * math.ceil(#property/2)
	conBg:setAbsContentSize(GlobalMethod:CCSize(280, m_height))
	conBg:updateRelativeSize()

	if ProjConfig.LANGUAGE == "vn" then
		ftxtProperty1:setScale(0.7)
		txtFighting:setScale(0.7)
	end
end

--@brief 	图腾洗礼
function WndTips:_update86()
	local tData = self.m_tData 
	WZLog("WndTips:_update86", Serialize(tData))	

	local tTotemInfo = GDatatab_guild_totem["id_"..tData.level]

	local tempProperty = json.decode(tData.value)
	local property = {}
	for k,v in pairs(tempProperty) do
		if v > 0 and k ~= "fighting" then
			local tempPro = {}
			tempPro[1] = tonumber(k)
			tempPro[2] = v
			table.insert(property,tempPro)
		end
	end
	table.sort(property,function (a,b)
		return a[1]<b[1]
	end)

	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/common/xz_icon_ttxl.png")

	GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF):setText("")
	GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF):setText("")
	GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setText("")

	local conIcon = GetElement(self.m_root,"conIcon_WndTips48",WZUIContainer)

	local strFormat1 = [[<T C="127,70,26" S="20" P="1">%s: </T><T C="255,89,74" S="20" P="1">%s</T>]]
	local ftxtProperty1 = WZUIFreeTextBox:create()
	ftxtProperty1:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtProperty1:setRelativePosition(GlobalMethod:ccp(0.35,0.649))
	ftxtProperty1:setMaxWidth(400)
	ftxtProperty1:setShowText(string.format(strFormat1,LocalStrings.COMMUNITYINFO241,LocalStrings.LV .. tData.level))
	conIcon:addChild(ftxtProperty1)

	local nAddValue = CacheCenter:getGameParam().cardSoulBuffAdd / 100
	local strFormat2 = [[<T C="127,70,26" S="20" P="1">%s: </T><T C="255,89,74" S="20" P="1">+%s%%</T>]]
	local ftxtProperty2 = WZUIFreeTextBox:create()
	ftxtProperty2:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	ftxtProperty2:setRelativePosition(GlobalMethod:ccp(0.35,0.357))
	ftxtProperty2:setMaxWidth(400)
	ftxtProperty2:setShowText(string.format(strFormat2,ATTR_TITLE[tTotemInfo.baptism_addition[1][1]],tTotemInfo.baptism_addition[1][2]/100))
	conIcon:addChild(ftxtProperty2)

	--战力加成
	local nFighting = tempProperty["fighting"]
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	local conProperty = GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer)
	conProperty:setVisible(true)
	conProperty:setRelativePosition(GlobalMethod:ccp(0.5,1.028))
	if property and #property > 0 then 
		for i = 1, #property do
			if property[i] then 
				local txtAllAttrValue1 = WZUILabelTTF:create()
				txtAllAttrValue1:setFontSize(20)
				txtAllAttrValue1:setColor(ccc3(127,70,26))
				txtAllAttrValue1:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue1:setRelativePosition(ccp(0.1+(math.floor((i+1)%2)*0.45),0.82-(math.floor((i+1)/2)*0.18)))
				local tempIndex = i%2 == 1 and math.ceil(i/2) or math.ceil(#property/2) + math.ceil(i/2)
				txtAllAttrValue1:setText(ATTR_TITLE[property[tempIndex][1]]..":")
				conProperty:addChild(txtAllAttrValue1)

				local txtAllAttrValue2 = WZUILabelTTF:create()
				txtAllAttrValue2:setFontSize(20)
				txtAllAttrValue2:setColor(ccc3(5,180,0))
				txtAllAttrValue2:setAnchorPoint(ccp(0,0.5))
				txtAllAttrValue2:setRelativePosition(ccp(1.2,0.5))
				txtAllAttrValue2:setText(property[tempIndex][2])
				txtAllAttrValue1:addChild(txtAllAttrValue2)
			end
		end
	end

	local conBg = GetElement(self.m_root,"conBg_WndTips48",WZUIContainer)
	local m_height = 135
	m_height = m_height + 28 * math.ceil(#property/2)
	conBg:setAbsContentSize(GlobalMethod:CCSize(280, m_height))
	conBg:updateRelativeSize()

	if ProjConfig.LANGUAGE == "vn" then
		ftxtProperty1:setScale(0.7)
		txtFighting:setScale(0.7)
	end
end

--@brief 	足迹星辰tips
function WndTips:_update87()
	local tData = self.m_tData
	WZLog("WndTips:_update87", Serialize(tData))
	local nMaxWeight, nMaxHeight = 270,280
	local nCurHeight = nMaxHeight

	local conContent = GetElement(self.m_root,"conContent_WndTips69",WZUIContainer)

	--名字
	local txtName = GetElement(self.m_root,"txtName_WndTips69",WZUILabelTTF)
	txtName:setText(tData.basicInfo.name)
	txtName:setColor(QUALITYCOLOR[tData.basicInfo.quality])

	--属性
	local nCurPropsHeight = 190 --第一个属性位文字置
	local nOffsetY = 40 --每个属性间隔40
	local tProperty = tData.basicInfo.property
	local strFormat = [[<T C="127,70,26" S="20" P="1">%s: </T><T C="5,180,0" S="20" P="1">+%s</T>]]
	for i = 1, #tProperty do
		local txtAttrValue1 = WZUILabelTTF:create()
		txtAttrValue1:setFontSize(20)
		txtAttrValue1:setColor(ccc3(127,70,26))
		txtAttrValue1:setUseAbsCoordinate(true)
		txtAttrValue1:setAnchorPoint(ccp(1,0.5))
		txtAttrValue1:setAbsPosition(ccp(nMaxWeight/2,nCurPropsHeight-(i-1)*nOffsetY))
		txtAttrValue1:setText(ATTR_TITLE[tProperty[i][1]]..":")
		conContent:addChild(txtAttrValue1)

		local txtAttrValue2 = WZUILabelTTF:create()
		txtAttrValue2:setFontSize(20)
		txtAttrValue2:setColor(ccc3(5,180,0))
		txtAttrValue2:setAnchorPoint(ccp(0,0.5))
		txtAttrValue2:setRelativePosition(ccp(1,0.5))
		txtAttrValue2:setText(" +"..tProperty[i][2])
		txtAttrValue1:addChild(txtAttrValue2)
	end

	--拆卸消耗
    local starmapstonedown = CacheCenter:getGameParam().starmapstonedown
    local ids,nums = SplitItemString(starmapstonedown)
	local imgCost = GetElement(self.m_root,"imgCost_WndTips69",WZUIImage)
	local txtCost = GetElement(self.m_root,"txtCost_WndTips69",WZUILabelTTF)
	local costItemInfo = GDatatab_item["id_"..ids[tData.basicInfo.quality]]
	imgCost:setFile(costItemInfo.icon)
	txtCost:setText(nums[tData.basicInfo.quality])

	--按钮状态 btnType字段 0[] 1[拆卸,合成] 2[镶嵌,合成] 3[合成]
	for i=1,3 do
		local conBtns = GetElement(self.m_root,"conBtns"..i.."_WndTips69",WZUIContainer)
		conBtns:setVisible(tData.btnType == i)
	end

	--合成按钮是否置灰
	local conBtns1Hc = GetElement(self.m_root,"conBtns1Hc_WndTips69",WZUIContainer)
	local conBtns2Hc = GetElement(self.m_root,"conBtns2Hc_WndTips69",WZUIContainer)
	local conBtns3Hc = GetElement(self.m_root,"conBtns3Hc_WndTips69",WZUIContainer)
	conBtns1Hc:setTouchEnable(false)
	conBtns2Hc:setTouchEnable(false)
	conBtns3Hc:setTouchEnable(false)
	if tData.btnSynthesis == true then
		conBtns1Hc:setTouchEnable(true)
		conBtns2Hc:setTouchEnable(true)
		conBtns3Hc:setTouchEnable(true)
	end

	--调整背景大小 按钮偏移
	if #tProperty > 2 then
		local conBG = GetElement(self.m_root,"conBG_WndTips69",WZUIContainer)
		conBG:setAbsContentSize(GlobalMethod:CCSize(nMaxWeight, nMaxHeight + (#tProperty - 2) * nOffsetY))
		conBG:updateRelativeSize()

		conBtns1:setAbsPosition(ccp(nMaxWeight / 2, - (#tProperty - 2) * nOffsetY))
		conBtns2:setAbsPosition(ccp(nMaxWeight / 2, - (#tProperty - 2) * nOffsetY))
		conBtns3:setAbsPosition(ccp(nMaxWeight / 2, - (#tProperty - 2) * nOffsetY))
	end

end
--@brief 	排位赛属性
function WndTips:_update88()
	local tData = self.m_tData
	WZLog("WndTips:_update88", Serialize(self.m_tData))
	local attrType = 12
	if self.m_tData ~= nil and self.m_tData.attrType ~= nil then
		attrType = self.m_tData.attrType
	end

	local tProTitle = {}
	local tProDesc = {}
	tProTitle[12]=LocalStrings.PVP_STRATEGIC_TEXT1[7]
	tProDesc[12]=LocalStrings.PVP_STRATEGIC_TEXT1[8]
	GetElement(self.m_root,"title1",WZUILabelTTF):setText(tProTitle[attrType])
	GetElement(self.m_root,"title2",WZUILabelTTF):setText(tProDesc[attrType])
	
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	local proStr = {
		LocalStrings.HEALTH,LocalStrings.ATTACK,LocalStrings.DEFENSE,LocalStrings.CRIT, LocalStrings.FREESTORM,
		LocalStrings.TIZHI,LocalStrings.POWER,LocalStrings.PRACTICE_ARMOR, LocalStrings.AGILITY,
		LocalStrings.LUCKY,LocalStrings.ANTIBREAKING,LocalStrings.AVOIDINJURY,LocalStrings.RANGE }
	local pro = {
		playerInfo.hp,playerInfo.attack,playerInfo.defend,playerInfo.critRate,playerInfo.reduceCrit,
		playerInfo.physique,playerInfo.force,playerInfo.armor,playerInfo.agility,
		playerInfo.luck,playerInfo.wreckDefense,playerInfo.injuryFree,playerInfo.range}

	for i = 1, 13 do
		local text = [[<T C="127,70,26" S="20" P="0">%s    </T><T C="5,180,0" S="20" P="0">%s</T>]]
		local str
		if i <= 12 then
			local tTable = GDatatab_battle_attribute["id_"..(i+(attrType-1)*12)]
			local basePro = pro[i]*tTable.zs_property/100
			local addPro = tTable.property[1][2]
			local allPro = basePro + addPro
			str = string.format(text,proStr[i], allPro)
		else
			str = string.format(text,proStr[i],pro[i])
		end
		local ftb = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
		ftb:setShowText(str)
	end
end

--@brief 	战略赛属性
function WndTips:_update89()
	WZLog("WndTips:_update89", Serialize(self.m_tData))

	local pvpmode = self.m_tData.pvpmode
	local winNum = self.m_tData.winNum
	local joinNum = self.m_tData.joinNum
	local score = self.m_tData.score
	local level = self.m_tData.level

	local title1 = GetElement(self.m_root,"title1_WndTips71",WZUILabelTTF)
	title1:setText(LocalStrings.PVP_STRATEGIC_TEXT1[1]..pvpmode.."V"..pvpmode)


    local info = GetZlsPvpDataByLevel(level)
    --图标
    local spinePath = "ui/otherUI/" .. info.animation
    local existSpine = CheckEffectFile(spinePath)
    if existSpine then 
	    local spineIcon1 = GetElement(self.m_root,"spineIcon1_WndTips71",WZUISpine)
		spineIcon1:setFileJson(spinePath .. ".json")
		spineIcon1:setFileAtlas(spinePath .. ".atlas")
		spineIcon1:play(info.action,true)
	else
		GetElement(self.m_root, "imgIcon_WndTips71", WZUIImage):setFile("ui/common/"..info.icon..".png")
	end
	--段位
	local strLevel = info.name
	if info.id == 999 then
		strLevel = strLevel .. info.star
	end
	GetElement(self.m_root,"txt1_1_WndTips71",WZUILabelTTF):setText(strLevel)
	--积分
	local strExp = LocalStrings.INTEGRATION..":"..score
	GetElement(self.m_root,"txt1_2_WndTips71",WZUILabelTTF):setText(strExp)
	--x战x胜
	GetElement(self.m_root,"txt1_5_WndTips71",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,joinNum,winNum))
	--胜率
	local winRate = joinNum == 0 and 0 or math.ceil((string.format("%.2f", winNum/joinNum))*100)
	GetElement(self.m_root,"txt1_6_WndTips71",WZUILabelTTF):setText(winRate.."%")
end

--@brief 	度假村花盆
function WndTips:_update90()
	WZLog("WndTips:_update90", Serialize(self.m_tData))

	local con = GetElement(self.m_root,"conType30_WndTips",WZUIContainer)
	con:setVisible(false)

	GetElement(self.m_root, "conHVFlowerpot_WndTips30", WZUIContainer):setVisible(true)
	local tbFlowerpot = GetElement(self.m_root, "tbFlowerpot_WndTips30", WZUITableContainer)
	tbFlowerpot:cleanTable()
	for i = 1, #self.m_tData.flowerpots do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setCellGoodLocalId(self.m_tData.flowerpots[i].id, self.m_tData.flowerpots[i].lastNum, 17, true)
			tNewObj:setItemClickFun(self, self.onRewardItemClick)
			if self.m_tData.flowerpots[i].lastNum == 0 then 
				tNewObj:setGrayRender(true)
			end
			tbFlowerpot:setCellElement(element)
		end
	end
end

--@brief 	宠物装备随机属性查看tips
function WndTips:_update91()
	local tData = self.m_tData
	WZLog("WndTips:_update91", Serialize(tData))
	local nMaxWeight, nMaxHeight = 270,280
	local nCurHeight = nMaxHeight

	local conContent = GetElement(self.m_root,"conContent_WndTips69",WZUIContainer)
	local conBG = GetElement(self.m_root,"conBG_WndTips69",WZUIContainer)
	conBG:setAbsContentSize(GlobalMethod:CCSize(320, 280))
	conBG:updateRelativeSize()

	--名字
	local txtName = GetElement(self.m_root,"txtName_WndTips69",WZUILabelTTF)
	txtName:setText(LocalStrings.PET_EQUIPMENT_8)
	txtName:setColor(GlobalMethod:ccc3(255,236,193))

	--属性
	local nCurPropsHeight = 210 --第一个属性位文字置
	local nOffsetY = 30 --每个属性间隔40
	local tProperty = GetPetEquipRamPro(tData.quality, tData.subType, tData.origin)
	table.sort( tProperty, function (a,b) if a.proType == b.proType then return a.min < b.min else return a.proType < b.proType end  end)
	for i = 1, #tProperty do
		local txtAttrValue1 = WZUILabelTTF:create()
		txtAttrValue1:setFontSize(20)
		txtAttrValue1:setColor(ccc3(127,70,26))
		txtAttrValue1:setUseAbsCoordinate(true)
		txtAttrValue1:setAnchorPoint(ccp(0,0.5))
		txtAttrValue1:setAbsPosition(ccp(10,nCurPropsHeight-(i-1)*nOffsetY))

		local nValue1 = tProperty[i].min
		local nValue2 = tProperty[i].max
		if tProperty[i].proType == 106 or tProperty[i].proType == 105 or tProperty[i].proType == 104 or (tProperty[i].proType >= 110 and tProperty[i].proType <= 148 and tonumber(k) ~= 118) or tProperty[i].proType == 1001 or tProperty[i].proType == 1003 or tProperty[i].proType == 1004 then
			nValue1 = nValue1 / 100
			nValue2 = nValue2 / 100
		end
		if tProperty[i].name == -1 then 
			if tProperty[i].proType >= 1 and tProperty[i].proType <= 20 or tProperty[i].proType == 106 then 
				txtAttrValue1:setText(string.format(tProperty[i].desc, nValue1 .. " — +" .. nValue2))
			else
				txtAttrValue1:setText(string.format(tProperty[i].desc, nValue1 .. "%" .. " — +" .. nValue2))
			end
		else
			if tProperty[i].proType == 103 then 
				txtAttrValue1:setText(tProperty[i].name .. nValue1 .. " — " .. nValue2)
			else
				txtAttrValue1:setText(tProperty[i].name .. nValue1 .. "%" .. " — " .. nValue2 .. "%" )
			end
		end
		conContent:addChild(txtAttrValue1)
	end
end

--@brief    植树造林奖励预览
function WndTips:_update92()
	WZLog("WndTips:_update92")
	local sex = CacheCenter:getPlayerInfo().sex
	local title = self.m_tData.title
	local rewards = self.m_tData.rewards

	local conType65 = GetElement(self.m_root,"conType65_WndTips",WZUIContainer)
	conType65:setVisible(true)
	local conSweepTitle1 = GetElement(self.m_root,"conSweepTitle1_WndTips65",WZUIContainer)
	conSweepTitle1:setVisible(false)
	local conSweepTitle2 = GetElement(self.m_root,"conSweepTitle2_WndTips65",WZUIContainer)
	conSweepTitle2:setVisible(false)

	local tSweepTitle2Size = conSweepTitle2:getContentSize()
	local tempHeight = #title == 1 and 10 or 0
	local nBGHeight = tSweepTitle2Size.height * #title + tempHeight
	conType65:setAbsContentSize(GlobalMethod:CCSize(conType65:getContentSize().width, nBGHeight))
	conType65:updateRelativeSize()

	local conList = GetElement(self.m_root,"conList_WndTips65",WZUIContainer)
	for i=1,#title do
		local cellSweepTitle2 = WZUISystem:getInstance():createElement("conSweepTitle2_WndTips65")
		local txtWhile = GetElement(cellSweepTitle2,"txtWhile_WndTips65",WZUILabelTTF)
		txtWhile:setText(title[i])
		local conReward1 = GetElement(cellSweepTitle2,"conReward1_WndTips65",WZUIContainer)
		for j=1,#rewards[i] do
			local itemId = rewards[i][j][1]
			local itemNum = rewards[i][j][2]
			if #rewards[i][j] == 3 then
				itemId = rewards[i][j][sex+1]
				itemNum = rewards[i][j][3]
			end
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodLocalId(itemId, itemNum, 17)
			tLuaObj:setItemClickFun(WndTips,self.onRewardItemClick)
		    celElement:setScale(0.8)
			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp(j*70-35,31))
			conReward1:addChild(celElement)
		end
		cellSweepTitle2:setRelativePosition(GlobalMethod:ccp(0.5, ((#title-i+1)/#title)+0.01))
		cellSweepTitle2:setVisible(true)
		conList:addChild(cellSweepTitle2)

		if ProjConfig.LANGUAGE == "vn" then
			txtWhile:setScale(0.6)
		end
	end
end

--镶嵌
function WndTips:onBtnPutOn()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_StonePutonResult,1,self.m_tData)
    self:_onCloseClick()
end

function WndTips:onRewardItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WZLog("onRewardItemClick", Serialize(tData))
    WndItemInfo:onCloseClick()
    local bShowBtn = false 
    if self.m_nType == 90 then 
    	if self.m_tData.usingFlowerpot and tData.basicInfo.id == self.m_tData.usingFlowerpot then 
    		tData.tBtnList = {LocalStrings.UNROYAL}
    	elseif tData.lastNum > 0 then 
    		tData.tBtnList = {LocalStrings.FAMILYSHOP2}
    	else
    		tData.tBtnList = {LocalStrings.SKINSKILL4}
    	end
    	bShowBtn = true
    end
    WndItemInfo:showInfo(tCell.m_root,WndTips.m_root,1,tData,bShowBtn,nil,true)
    if self.m_nType == 90 then 
    	if self.m_tData.usingFlowerpot and tData.basicInfo.id == self.m_tData.usingFlowerpot then 
    		WndItemInfo:setClickButtonCallback(self,self.cancelFlowerpotWear)
    	elseif tData.lastNum > 0 then 
    		WndItemInfo:setClickButtonCallback(self,self.wearFlowerpot)
    	else
    		WndItemInfo:setClickButtonCallback(self,self.getFlowerpot)
    	end
    	bShowBtn = true
    end
end

--@brief 	卸下花盆按钮回调
function WndTips:cancelFlowerpotWear(nTag, tData)
	WZLog("")
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(CacheCenter:getPlayerInfo().id, 10, self.m_tData.fieldId - 1, -1)
	self:_onCloseClick()
end
--@brief 	装饰花盆按钮回调
function WndTips:wearFlowerpot(nTag, tData)
	WZLog("WndTips:wearFlowerpot", Serialize(tData))
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(CacheCenter:getPlayerInfo().id, 10, self.m_tData.fieldId - 1, tData.basicInfo.id)
	self:_onCloseClick()
end

function WndTips:getFlowerpot(nTag, tData)
	WndFastGetItems:show(tData.basicInfo.id, 1)
	self:_onCloseClick()
end

--@brief    创建前往按钮
function WndTips:_createNormalBtn(txtBtnText)
    -- body
    local btnGoto = WZUIButton:create()
    btnGoto:setUseAbsSize(true)
    btnGoto:setAbsContentSize(GlobalMethod:CCSize(116,56))
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.5,0.206))
    local imgNor = WZUIImage:create()
    imgNor:setFile("ui/common/common_btn_06.png")
    local imgSel = WZUIImage:create()
    imgSel:setFile("ui/common/common_btn_06.png")
    btnGoto:setNormalElement(imgNor)
    btnGoto:setSelectElement(imgSel)
    btnGoto:setLuaDoneFunctionName("onCheckType45")

    local txtBtn = WZUILabelTTF:create()
    txtBtn:setText(txtBtnText)
    txtBtn:setColor(GlobalMethod:ccc3(255,255,255))
    txtBtn:setStrokeColor(GlobalMethod:ccc3(0,108,3))
    txtBtn:setFontSize(24)
    txtBtn:setEnableStroke(true)
    txtBtn:setStrokeSize(4)
    btnGoto:addChild(txtBtn)

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		txtBtn:setScale(0.7)
		txtBtn:setDimensions(GlobalMethod:CCSize(140))
	end

    return btnGoto
end

--@brief 	创建富文本
function WndTips:_createFtext(parentNode, txt, rpt)
	-- body
	local ftxtPro = WZUIFreeTextBox:create()
	ftxtPro:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    ftxtPro:setRelativePosition(rpt)
    ftxtPro:setMaxWidth(240)
    
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
        ftxtPro:setMaxWidth(600)
        ftxtPro:setScale(0.8)
    elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
        ftxtPro:setMaxWidth(320)
        ftxtPro:setScale(0.8)
    elseif ProjConfig.LANGUAGE == "vn" then
        ftxtPro:setMaxWidth(400)
        ftxtPro:setScale(0.7)
    end
    ftxtPro:setShowText(txt)
    parentNode:addChild(ftxtPro)
end

--@brief    获取当前类型的祝福最高等级
function WndTips:_getMaxLevel25(itemId)
    -- body
    local nLevel = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level > nLevel then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief 	获取当前类型的祝福的第二高等级的id
function WndTips:_getSecondMaxLevel25(nMaxLevel, itemId)
    -- body
    local id = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level == nMaxLevel - 1 then
            id = value.id
        end
    end

    return id
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 	英语适配模块
function WndTips:_adaptLanguage_en()
	-- body
	WZLog("WndTips:_adaptLanguage_en", self.m_nType)
	if self.m_nType == 24 then
		local label3Type22 = GetElement(self.m_root, "label3Type22_WndTips", WZUILabelTTF)
		if label3Type22 then
			label3Type22:setFontSize(18)
		end
	end
end

function WndTips:_adaptLanguage_pt(  )
	if self.m_nType == 24 then
		local label3Type22 = GetElement(self.m_root, "label3Type22_WndTips", WZUILabelTTF)
		if label3Type22 then
			label3Type22:setFontSize(20)
		end
	end
end

function WndTips:_adaptLanguage_tr(  )
	if self.m_nType == 24 then
		local label3Type22 = GetElement(self.m_root, "label3Type22_WndTips", WZUILabelTTF)
		if label3Type22 then
			label3Type22:setFontSize(18)
		end
	end
end

--@brief 	泰语适配模块
function WndTips:_adaptLanguage_th()
	-- body
	WZLog("WndTips:_adaptLanguage_th", self.m_nType)
	if self.m_nType == 24 then
		local label3Type22 = GetElement(self.m_root, "label3Type22_WndTips", WZUILabelTTF)
		if label3Type22 then
			label3Type22:setFontSize(20)
		end
	end
end

function WndTips:_adaptLanguage_vn(  )
	if self.m_nType == 69 then
		local txtMedalTitle = GetElement(self.m_root, "txtMedalTitle", WZUILabelTTF)
		if txtMedalTitle then
			txtMedalTitle:setRelativePosition(GlobalMethod:ccp(0.34,0.87))
		end
		local txtMedalSubtitle = GetElement(self.m_root, "txtMedalSubtitle", WZUILabelTTF)
		if txtMedalSubtitle then
			txtMedalSubtitle:setRelativePosition(GlobalMethod:ccp(0.34,0.79))
		end
	elseif self.m_nType == 88 then
		GetElement(self.m_root,"title1",WZUILabelTTF):setFontSize(14)
		GetElement(self.m_root,"title2",WZUILabelTTF):setFontSize(14)
	end
end
-------------------------------------语言适配模块End--------------------------------------
