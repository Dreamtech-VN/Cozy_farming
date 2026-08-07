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
	if self.m_nType == 13 then
		if self.m_tData.tBtnList then
			btn = GetElement(self.m_root,"btnExtraction_WndTips",WZUIButton)
		end
	elseif self.m_nType == 18 then
		btn = GetElement(self.m_root,"btnType16_WndTips",WZUIButton)
	elseif self.m_nType == 20 then
		btn = GetElement(self.m_root,"btn1Type18_WndTips",WZUIButton)
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
	--如果格子有高亮方法，设置格子高亮
	local tObj = self.m_tHighLightObj
	if tObj and tObj.setHighLight then
		tObj:setHighLight(false)
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
function WndTips:show(element,parentElement,nType,tData,offset,bShowAll)
	--WZLog("WndTips:show",nType,type(WndTips),self.m_bIsVisible,Serialize(tData))
	if element == nil or parentElement == nil then return end
	if self.m_root ~= nil then return end
	self.m_bIsVisible = false
	if self.m_bIsVisible == nil then self.m_bIsVisible = false end
	if self.m_bIsVisible == false then

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
		self:setWindowPosition(element,parentElement,nType,offset)
		self["_update"..self.m_nType](self)

		--如果格子有高亮方法，设置格子高亮
		if tData ~= nil then
			self.m_tHighLightObj = tData.highLightObj
			local tObj = tData.highLightObj
		end
		if tObj and tObj.setHighLight then
			tObj:setHighLight(true)
		end
		AdaptLanguage(self)
	elseif self.m_bIsVisible == true then
		self:_onCloseClick()
	end
end

--@brief	创建按钮
function WndTips:_createBtn()
	if self.m_root:getChildByTag(0) then
		self.m_root:removeChildByTag(0, true)
	end

	local btn = WZUIImage:create()
	btn:setLuaTouchEndedFunction("_onCloseClick")
    --btn:setLuaDoneFunctionName("_onCloseClick")
	btn:setAnchorPoint(ccp(0.5,0.5))
	btn:setRelativePosition(ccp(0.5,0.5))
	btn:setTouchSwallow(false)
	--btn:setUseAbsSize(true)
	btn:setScale(66)
	btn:setFile("ui/common/common_black_bg.png")
	btn:setOpacity(0)
	self.m_root:addChild(btn,-10,0)
end

--@brief	设置窗口位置
function WndTips:setWindowPosition(element,parentElement,nType,offset)
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
	if con ~= nil then
		local screenSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
		local size = con:getAbsContentSize()
		WZLog("check_up_side", screenSize.width, screenSize.height, worldPosition.x, worldPosition.y, size.width, size.height, worldPosition.y+size.height/2)
		local maxHeight = worldPosition.y+size.height/2
		WZLog("check_up_side_0", nType, maxHeight + 50, screenSize.height)
		if maxHeight + 50 > screenSize.height then
			local down = (maxHeight - screenSize.height + 100)
			WZLog("check_up_side_1", nType, down)
			pt.y = pt.y - down
		end
		self.m_root:setPosition(pt)
	else
		
	end

	--检查下超框
	if nType == 13 or nType == 14 or nType == 19 or nType == 26 then
		if worldPosition.y < 120 then
			local offsetH = 120 - worldPosition.y
			pt.y = pt.y + offsetH + 5
			self.m_root:setPosition(pt)
		end
	elseif nType == 25 then
		--祝福tip
		local positionX = element:getPositionX()
		local positionY = element:getPositionY()
		local newPt = element:convertToWorldSpace(GlobalMethod:ccp(positionX, positionY))
		WZLog("HHHHHHHHHHHHHH", newPt.x, newPt.y)
		local conOuside = GetElement(self.m_root, "conOuside_WndTips", WZUIContainer)
		local conSize = conOuside:getAbsContentSize()
		local screenSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
		WZLog("KKKKKKKKKKKKKKKK", conSize.width, conSize.height, screenSize.width, screenSize.height)

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
	GetElement(self.m_root,"conType1_WndTips",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"img_WndTips",WZUIImage):setFile(tData.icon)
	WZLog("---**********---111",tData.icon,tData.scale,tData.title)
	if tData.scale ~= nil then
		GetElement(self.m_root,"img_WndTips",WZUIImage):setScale(tData.scale)
	end
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
		GetElement(self.m_root,"img_WndTips",WZUIImage):setVisible(false)
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
	if ProjConfig.LANGUAGE == "en" then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setRelativePosition(GlobalMethod:ccp(0.35,0.5))
		title:setScale(0.8)
		title:setMaxWidth(220)
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" 
		or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
		local title = GetElement(self.m_root,"title",WZUIFreeTextBox)
		title:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
		title:setScale(0.65)
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
		
		for i=1,4 do
			if tData.icon[i] ~= nil then
				GetElement(self.m_root,"img"..i.."Type3_WndTips",WZUIImage):setFile(tData.icon[i])
				GetElement(self.m_root,"img"..i.."Type3_WndTips",WZUIImage):setScale(0.5)
				GetElement(self.m_root,"label"..i.."Type3_WndTips",WZUILabelTTF):setText(tData.num[i])
			else
				GetElement(self.m_root,"img"..i.."Type3_WndTips",WZUIImage):setVisible(false)
				GetElement(self.m_root,"img"..i.."Type3_WndTips",WZUIImage):setVisible(false)
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
			local sFotmat = [[<T C="255,227,116" S="18" P="1">%s:</T><T C="255,89,74" S="18" P="1">%d/%d</T>]]
			if self.m_tData.curNum >= self.m_tData.targetNum then 
			    sFotmat = [[<T C="255,227,116" S="18" P="1">%s:</T><T C="5,180,0" S="18" P="1">%d/%d</T>]]
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
		else
			GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.CHAT_CURRENT)
			GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setText(tData.strartNum.."/"..tData.endNum)
			if tData.charm == true then
				GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setVisible(false)
				GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO138)
				GetElement(self.m_root,"img5Type3_WndTips",WZUIImage):setVisible(false)
				if ProjConfig.LANGUAGE == "en" then
					local ttf2Type3 = GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF)
					ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
					-- ttf2Type3:setRelativePosition(GlobalMethod:ccp(0.05,0.84))
				end
				if ProjConfig.LANGUAGE == "vn" then
					GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.84))
				end
				if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
					local ttf2Type3 = GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF)
					ttf2Type3:setDimensions(GlobalMethod:CCSize(250,0))
					-- ttf2Type3:setRelativePosition(GlobalMethod:ccp(0.05,0.84))

				end
			else
				if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" then
					GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
					GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.5))
				elseif ProjConfig.LANGUAGE == "es" then
					local ttf1 = GetElement(self.m_root,"ttf1Type3_WndTips",WZUILabelTTF)
					ttf1:setFontSize(18)
					ttf1:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
					local ttf2 = GetElement(self.m_root,"ttf2Type3_WndTips",WZUILabelTTF)
					ttf2:setFontSize(16)
					ttf2:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
				end
			end
		end
end

--@brief	更新类型4	tips
function WndTips:_update4()
	WZLog("WndTips:_update4")
	if self.m_tData == nil then return end
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
		GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF):setText(string.format(LocalStrings.COMMUNITYINFO67,
			playerInfo.playNum,playerInfo.winNum))
		GetElement(self.m_root,"ttf5Type4_WndTips",WZUILabelTTF):setText(winRate.."%")
		GetElement(self.m_root,"label1Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[1][1]])
		GetElement(self.m_root,"label2Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[1][2])
		GetElement(self.m_root,"label3Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[2][1]])
		GetElement(self.m_root,"label4Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[2][2])
		GetElement(self.m_root,"label5Type4_WndTips",WZUILabelTTF):setText(ATTR_TITLE[hallInfo.add_property[3][1]])
		GetElement(self.m_root,"label6Type4_WndTips",WZUILabelTTF):setText("+"..hallInfo.add_property[3][2])
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language then
		local ttf2Type4 = GetElement(self.m_root,"ttf2Type4_WndTips",WZUILabelTTF)
		-- ttf2Type4:setText(string.format(LocalStrings.COMMUNITYINFO67,playerInfo.winNum,playerInfo.playNum))
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
		ttf2Type4:setText(string.format(LocalStrings.COMMUNITYINFO67,playerInfo.winNum,playerInfo.playNum))
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
		-- ttf2Type4:setText(string.format(LocalStrings.COMMUNITYINFO67,playerInfo.winNum,playerInfo.playNum))
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
end

--@brief	更新类型5	tips
function WndTips:_update5()
	WZLog("WndTips:_update5")
	local tData = self.m_tData
		GetElement(self.m_root,"conType5_WndTips",WZUIContainer):setVisible(true)
		--local text1 = [[<T C="255,227,112" S="20" >%s:  </T><T C="255,255,255" S="20" >%d</T>]]

		--local text2 = [[<T C="255,227,112" S="20" >%s:  </T><T C="255,255,255" S="20" >%s</T>]]

		--GetElement(self.m_root,"txt1Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.PET_1,tData.value))
		local text = string.format(LocalStrings.PET_4,math.floor(tData.value)/1,"%")
		--GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,LocalStrings.PET_2,text))
		local text1 = string.format(LocalStrings.PET_5,math.floor(tData.value)/1,"%")
		--GetElement(self.m_root,"txt3Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(text2,LocalStrings.PET_3,text1))
		
		local showText = [[<T C="255,227,112" S="20" >%s:  </T><T C="255,255,255" S="20" >%d</T><BR></BR>
		<T C="255,227,112" S="20" >%s:  </T><T C="255,255,255" S="20" >%s</T><BR></BR>
		<T C="255,227,112" S="20" >%s:  </T><T C="255,255,255" S="20" >%s</T>]]
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

--@brief	更新类型6	tips
function WndTips:_update6()
	WZLog("WndTips:_update6")
	local tData = self.m_tData
	GetElement(self.m_root,"conType6_WndTips",WZUIContainer):setVisible(true)
	local text1 = [[<T C="255,227,116" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
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
	local text = tData.text or [[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">    %d</T>]]
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

		local text1 = [[<T C="255,227,116" S="20" >%s</T><T C="255,236,193" S="20" >    +%d</T>]]

		local text2 = [[<T C="158,139,121" S="20" >%s</T><T C="158,139,121" S="20" >    +%d</T>]]

		-- if ProjConfig.LANGUAGE == "vn" then
		-- 	text1 = [[<T C="255,227,116" S="16" >%s</T><T C="255,236,193" S="18" >    +%d</T>]]
		-- 	text2 = [[<T C="158,139,121" S="16" >%s</T><T C="158,139,121" S="18" >    +%d</T>]]
		-- end

		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" 
			or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
			text1 = [[<T C="255,227,116" S="16" >%s</T><T C="255,236,193" S="18" >    +%d</T>]]
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
	end
end

--@brief	更新类型10	tips
function WndTips:_update10()
	WZLog("WndTips:_update10")
	local tData = self.m_tData
		GetElement(self.m_root,"conType9_WndTips",WZUIContainer):setVisible(true)
		local widthList = {80,160,240,320,400,480}
		local relativePosition = {-0.2,-0.305,-0.23,-0.15,-0.075,0}
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
		local text1 = [[<T C="255,227,116" S="20" >%s</T><T C="255,236,193" S="20" >    +%d</T>]]
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
    	imgStar:setRelativePosition(GlobalMethod:ccp(0.02+0.075*i,0.69))
		imgStar:setRotation(10)
    	imgStar:setScale(0.9)
		imgStar:setUseOriginSize(true)
    	conItem:addChild(imgStar)
	end
	--显示属性
	local text = [[<T C="255,227,116" S="20" >%s:</T><T C="255,236,193" S="20" >  %d</T>]]
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
	local text1 = [[<T C="255,227,116" S="20" >%s:</T><T C="255,236,193" S="20" > %s</T><T C="255,236,193" S="20" >(%d-%d)</T>]]
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
			local text = [[<I Z="0.4">%s</I><T C="255,236,193" S="18" P="0"> %s</T>]]
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
		GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleX(0.71)
		GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleY(0.69)
		GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setScaleX(1.25)
		GetElement(WndTips.m_root,"line1Type23_WndTips",WZUIImage):setRelativePosition(ccp(0.35,0.62))
		GetElement(WndTips.m_root,"line2Type23_WndTips",WZUIImage):setVisible(false)
	end

	if tData.tBtnList then
		if tData.skill ~= nil and tData.skill ~= "" then
			--进阶过的宠物不用处理
		else
			GetElement(WndTips.m_root,"bgType23_WndTips",WZUI9Image):setScaleY(0.9)
			GetElement(WndTips.m_root,"line3Type23_WndTips",WZUIImage):setScaleX(1.25)
			GetElement(WndTips.m_root,"line3Type23_WndTips",WZUIImage):setRelativePosition(ccp(0.35,0.328))
			GetElement(self.m_root, "btnExtraction_WndTips", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.35, 0.21))
		end
		GetElement(WndTips.m_root, "txtExtractionType24_WndTips", WZUILabelTTF):setText(tData.tBtnList[1])
		GetElement(WndTips.m_root, "conForBtnType23_WndTips", WZUIContainer):setVisible(true)
	end
end

--@brief	更新类型14	tips
function WndTips:_update14()
	WZLog("WndTips:_update14")
	local tData = self.m_tData
		GetElement(self.m_root,"conType12_WndTips",WZUIContainer):setVisible(true)
		local quality = tData.quality or 0
		local fighting = tData.fighting or 0
		local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
		--显示头像
		GetElement(self.m_root,"img2Type12_WndTips",WZUIImage):setFile(tData.icon)
		--显示头像品质框
		GetElement(self.m_root,"img1Type12_WndTips",WZUI9Image):setFile(qualityPic[tonumber(quality)])
		--不显示宠物类型图标
		GetElement(self.m_root,"img3Type12_WndTips",WZUIImage):setVisible(false)
		--设置等级和等级颜色
		GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setText(LocalStrings.LV..tData.upgradeLevel)
		GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.41,0.87))
   		GetElement(self.m_root,"title1Type12_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
		--设置名字和名字颜色
		GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF):setText(tData.name)
   		GetElement(self.m_root,"title2Type12_WndTips",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
		--设置战斗力
   		GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF):setText(LocalStrings.BATTLE..":"..fighting)
   		GetElement(self.m_root,"title3Type12_WndTips",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,89,74))
		local conItem = GetElement(self.m_root,"conType12_WndTips",WZUIContainer)
		--显示星星
		for i=1,tonumber(tData.advancedLevel) do
        	local imgStar = WZUIImage:create()
        	imgStar:setFile("ui/common/common_icon_xingxing2.png")
        	imgStar:setRelativePosition(GlobalMethod:ccp(0.01+0.09*i,0.51))
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
		local text = [[<T C="255,227,116" S="20" >%s:</T><T C="255,236,193" S="20" >  %d</T>]]
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
            local head = CellHead:show(GetElement(self.m_root,"conType13",WZUIContainer),tData.head,tData.face,tData.sex)
			head:setScale(1.3)
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
	GetElement(self.m_root,"conType15_WndTips",WZUIContainer):setVisible(true)

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

    for i = 1, #tProperty do
        local proName = GetElement(self.m_root,"label"..(2*i-1).."Type15_WndTips",WZUILabelTTF)
        local proValue =  GetElement(self.m_root,"label"..2*i.."Type15_WndTips",WZUILabelTTF)
        proName:setText(ATTR_TITLE[tProperty[i][1]])
        proValue:setText("+"..tProperty[i][2])
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
		local text = [[<T C="255,236,193" S="22">瞬间恢复</T><T C="99,255,95" S="20">10%+100</T><T C="255,236,193" S="22">点生命值</T>]]
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
	local text = [[<T C="255,227,116" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
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
end

--@brief	更新类型21	公会tips
function WndTips:_update21()
	WZLog("WndTips:_update21")
	local tData = self.m_tData
	--图腾图片
	GetElement(self.m_root,"imgHeadType19_WndTips",WZUIImage):setFile(tData.icon)
	--公会图腾等级
	GetElement(self.m_root,"ttf1Type19_WndTips",WZUILabelTTF):setText(tData.title1)
	--公会名
	GetElement(self.m_root,"ttf2Type19_WndTips",WZUILabelTTF):setText(tData.guildName)
	--公会职位
	GetElement(self.m_root,"ttf5Type19_WndTips",WZUILabelTTF):setText(tData.position)
	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips19", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
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
	GetElement(self.m_root,"imgHeadType20_WndTips",WZUIImage):setFile(tData.icon)
	if tData.scale ~= nil then
	GetElement(self.m_root,"imgHeadType20_WndTips",WZUIImage):setScale(tData.scale)
	end
	--恩爱等级
	GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF):setText(tData.title1)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ttf3Type20_WndTips",WZUILabelTTF):setFontSize(17)
	end
	if tonumber(tData.level) ~= nil then
		GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setVisible(true)
		GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setText(tData.level)
	end
	GetElement(self.m_root,"txtRankLvType20_WndTips",WZUILabelAtlasFont):setVisible(false)
	--伴侣
	GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF):setText(tData.mateName)
	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips20", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
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
	if ProjConfig.LANGUAGE == "pt" then
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setFontSize(16) 
	elseif ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.83))
		GetElement(self.m_root,"txtFight_WndTips20",WZUILabelTTF):setScale(0.7)
	elseif ProjConfig.LANGUAGE == "en" then
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setRelativePosition(GlobalMethod:ccp(0.37,0.588))
	end
	if ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		local ttf1 = GetElement(self.m_root,"ttf1Type20_WndTips",WZUILabelTTF)
		ttf1:setDimensions(GlobalMethod:CCSize(140,0))
		local ttf2 = GetElement(self.m_root,"ttf2Type20_WndTips",WZUILabelTTF)
		ttf2:setFontSize(16)
	end
end

--@brief	更新类型23	师徒tips
function WndTips:_update23()
	WZLog("WndTips:_update23")
	local tData = self.m_tData

	--图片
	GetElement(self.m_root,"imgHeadType21_WndTips",WZUIImage):setFile(tData.icon)
	if tData.scale ~= nil then
	GetElement(self.m_root,"imgHeadType21_WndTips",WZUIImage):setScale(tData.scale)
	end
	--师德等级
	GetElement(self.m_root,"ttf1Type21_WndTips",WZUILabelTTF):setText(tData.title1)
	if tData.level == nil then tData.level = 0 end
	if tData.level > 0 then
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setText(tData.level)
	else
		GetElement(self.m_root,"txtRankLvType21_WndTips",WZUILabelAtlasFont):setVisible(false)
	end
	--师傅or徒弟
	GetElement(self.m_root,"ttf2Type21_WndTips",WZUILabelTTF):setText(tData.title)
	--师徒名字
	for i=1,#tData.title2 do
		GetElement(self.m_root,"ttf"..(2+i).."Type21_WndTips",WZUILabelTTF):setText(tData.title2[i])
	end
	--加成战力
	local nFighting = WndCard:_caculateFighting(tData.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips21", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	--属性加成
	GetElement(self.m_root,"label1Type21_WndTips",WZUILabelTTF):setText(tData.attr1)
	GetElement(self.m_root,"label2Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal1)
	GetElement(self.m_root,"label3Type21_WndTips",WZUILabelTTF):setText(tData.attr2)
	GetElement(self.m_root,"label4Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal2)
	GetElement(self.m_root,"label5Type21_WndTips",WZUILabelTTF):setText(tData.attr3)
	GetElement(self.m_root,"label6Type21_WndTips",WZUILabelTTF):setText("+"..tData.attrVal3)

	--有多个徒弟时，拉长底图，属性往下移
	if tData.title2 ~= nil and #tData.title2 > 1 then
		GetElement(self.m_root,"bgType21_WndTips",WZUI9Image):setScaleY(1+0.08*(#tData.title2-1))
		GetElement(self.m_root,"conAttrType21_WndTips",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5-0.08*(#tData.title2-1)))
	end

	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or 
		ProjConfig.LANGUAGE == "es" then
		local ttf1Type21 = GetElement(self.m_root,"ttf1Type21_WndTips",WZUILabelTTF)
		ttf1Type21:setFontSize(16)
		ttf1Type21:setDimensions(GlobalMethod:CCSize(120,0))
	elseif ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtFight_WndTips21",WZUILabelTTF):setScale(0.7)
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
	local QUALITY_COLOR = {GlobalMethod:ccc3(255,255,255), GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(233,166,62)}
	local QUALITY_RECT_TIPS = {"ui/common/common_scale9_wuse.png","ui/common/frame_green.png", "ui/common/frame_bule.png", "ui/common/frame_violet.png", "ui/common/frame_orange.png"}

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
		--imgHead:setScale(1)	
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

	GetElement(self.m_root,"title1",WZUILabelTTF):setText(LocalStrings.RANK_FIGHT_PRO)
	GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.RANK_FIGHT_PRO_DESC)
	if attrType == 1 then
		GetElement(self.m_root,"title1",WZUILabelTTF):setText(LocalStrings.RANK_FIGHT_PRO)
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.RANK_FIGHT_PRO_DESC)
	elseif attrType == 3 then
		GetElement(self.m_root,"title1",WZUILabelTTF):setText(LocalStrings.JUEDITIPS1)
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.JUEDITIPS2)
	end

	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	GetElement(self.m_root,"conType26_WndTips",WZUIContainer):setVisible(true)
	local proStr = {
		LocalStrings.HEALTH,LocalStrings.ATTACK,LocalStrings.DEFENSE,LocalStrings.CRIT, LocalStrings.FREESTORM,
		LocalStrings.TIZHI,LocalStrings.POWER,LocalStrings.PRACTICE_ARMOR, LocalStrings.AGILITY,
		LocalStrings.LUCKY,LocalStrings.ANTIBREAKING,LocalStrings.AVOIDINJURY,LocalStrings.RANGE }
	local pro = {
		playerInfo.hp,playerInfo.attack,playerInfo.defend,playerInfo.critRate,playerInfo.reduceCrit,
		playerInfo.physique,playerInfo.force,playerInfo.armor,playerInfo.agility,
		playerInfo.luck,playerInfo.wreckDefense,playerInfo.injuryFree,playerInfo.range}

	for i = 1, 13 do
		local text = [[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]]
		local str
		if i <= 12 then
			local tTable = GDatatab_battle_attribute["id_"..(i+(attrType-1)*12)]
			local basePro = pro[i]*tTable.zs_property/100
			local addPro = tTable.property[1][2]
			local allPro = basePro + addPro
			str = string.format(text,proStr[i],allPro)
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
        name:setColor(ccc3(255,227,116))
        name:setFontSize(22)
        name:setAlignment(kCCTextAlignmentLeft)
        con:addChild(name,100)

		local value = WZUILabelTTF:create()
		value:setText(self.m_tData[2][i])
        value:setAnchorPoint(ccp(0,0.5))
        value:setRelativePosition(ccp(0.01,1.3-i))
        value:setColor(ccc3(255,255,255))
        value:setFontSize(22)
        value:setAlignment(kCCTextAlignmentLeft)
        con:addChild(value,100)

        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			name:setFontSize(18)
			value:setFontSize(18)
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
        value:setColor(ccc3(255,255,255))
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
        leftVal:setColor(ccc3(255,255,255))
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
	GetElement(self.m_root,"txtTitle_WndTips36",WZUILabelTTF):setText(tSkill.name)
	GetElement(self.m_root,"txt1Type35_WndTips",WZUILabelTTF):setText(tSkill.tool_desc)
	GetElement(self.m_root,"imgSkillPg_WndTips36",WZUIImage):setFile(tSkill.icon)
	GetElement(self.m_root,"imgSkillL_WndTips36",WZUIImage):setFile(tSkill.lv_icon)
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

--@brief	幻力等级tip
function WndTips:_update37()
	WZLog("WndTips:_update37")
	local tData = self.m_tData
	if tData == nil then return end 

	local tPro = GDatatab_shape_level["id_"..tData.lv]
	if tPro == nil then return end
	GetElement(self.m_root,"ttf1Type37_WndTips",WZUILabelTTF):setText(LocalStrings.PHANTOM3.." Lv"..tData.lv)
	GetElement(self.m_root,"proTips37_WndTips",WZUIProgress):setPercentage(math.ceil(tData.exp/tPro.exp*100))
	GetElement(self.m_root,"txtTips37Exp_WndTips",WZUILabelTTF):setText(tData.exp.."/"..tPro.exp)
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

	local tPro = GDatatab_shape_level["id_"..tData.lv]
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
	elseif ProjConfig.LANGUAGE == "en" then
		local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
		noUse:setDimensions(GlobalMethod:CCSize(60))
		noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))		
		GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
		local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
		txtSkill:setFontSize(18)
		txtSkill:setScale(0.65)
		txtSkill:setDimensions(GlobalMethod:CCSize(230))		
		GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setScale(0.8)
	end
	if tPro == nil or tShape == nil then return end
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
	-- if ProjConfig.LANGUAGE == "vn" then
	-- 	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
	-- 	local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
	-- 	txtSkill:setScale(0.6)
	-- 	txtSkill:setDimensions(GlobalMethod:CCSize(250))
	-- 	txtSkill:setRelativePosition(GlobalMethod:ccp(0.44,0.63))
	-- elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
	-- 	local noUse = GetElement(self.m_root,"noUse",WZUILabelTTF)
	-- 	noUse:setDimensions(GlobalMethod:CCSize(60))
	-- 	noUse:setRelativePosition(GlobalMethod:ccp(0.175,0.5))		
	-- 	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.8)
	-- 	local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
	-- 	txtSkill:setScale(0.8)
	-- 	txtSkill:setDimensions(GlobalMethod:CCSize(180))
	-- elseif ProjConfig.LANGUAGE == "th" then
	-- 	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.9)
	-- 	local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
	-- 	txtSkill:setScale(0.8)
	-- 	txtSkill:setDimensions(GlobalMethod:CCSize(180))
	-- elseif ProjConfig.LANGUAGE == "en" then	
	-- 	local txtSkill = GetElement(self.m_root,"txtSkill",WZUILabelTTF)
	-- 	txtSkill:setScale(0.7)
	-- 	txtSkill:setDimensions(GlobalMethod:CCSize(210))
	-- end
	if tShape.head ~= nil then
		GetElement(self.m_root,"noUse",WZUILabelTTF):setVisible(false)
	end
end

--@brief	幻力等级tip
function WndTips:_update39()
	WZLog("WndTips:_update39", Serialize(self.m_tData))
	local tData = self.m_tData
	if tData == nil then return end 

	local tPro = GDatatab_shape_level["id_"..tData.lv]
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
		GetElement(self.m_root,"txtSkillName",WZUILabelTTF):setScale(0.65)
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
	--显示觉醒之技信息
	if tData.awakeStep == 4 then 
		local nTotalLevel = 1 
	    local nCtbValue = 0
	    local tAwakeSkillId = SplitStringWithSeparator(tData.awakeSkillId, "|", nil, true)
	    local sCostFormat = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SE="0" SS="4">%s</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="0" SS="4">%.1f</T>]]
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

	local text1 = [[<T C="255,236,193" S="22" P="1">%s</T><BR></BR><T C="255,236,193" S="22" P="1">%s</T>]]

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
	conTips28:setAbsContentSize(GlobalMethod:CCSize(300, 278))
	conTips28:updateRelativeSize()

	local txtTitle = WZUILabelTTF:create()
	txtTitle:setText(LocalStrings.BLESS_AAT_TITLE)
	txtTitle:setColor(GlobalMethod:ccc3(255,227,116))
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

	local text1 = [[<T C="255,236,193" S="22" >%s</T><T C="255,236,193" S="22" >%d</T>]]
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


	local text2 = [[<T C="255,227,116" S="20" >%s:</T><T C="99,255,95" S="20" >%d</T>]]
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
	local label21Tyep43 = GetElement(self.m_root,"label21Type43_WndTips",WZUILabelTTF)
	label21Tyep43:setText(GlobalMethod:getCombatEffect(attrList))
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
		label21Tyep43:setRelativePosition(GlobalMethod:ccp(0.68,0.51))
		GetElement(self.m_root,"label20Type43_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.51))
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
		txtMaxLevel:setColor(GlobalMethod:ccc3(255,227,116))
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
	local text1 = [[<T C="255,227,116" S="20" >%s</T><T C="99,255,95" S="20" >  +%d</T>]]
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
end

--@brief	家园tip
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
	WZLog("WndTips:_update47_1", Serialize(extraInfo))
	GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setText(caculateClothesFighting(extraInfo))

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.78))
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
		GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.645,0.78))
	elseif ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"ttf4Type47_WndTips",WZUILabelTTF):setScale(0.8)
		local ttf5Type47 = GetElement(self.m_root,"ttf5Type47_WndTips",WZUILabelTTF)
		ttf5Type47:setScale(0.8)
		ttf5Type47:setRelativePosition(GlobalMethod:ccp(0.79,0.78))
		for i=1,3 do
			GetElement(self.m_root,"label"..(i*2-1).."Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.56-(0.1*i)))
			GetElement(self.m_root,"label"..(i*2).."Type47_WndTips",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.56-(0.1*i)))
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

	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"ttf3Type48_WndTips",WZUILabelTTF):setScale(0.8)
		local ttf1 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
		ttf1:setScale(0.7)
		ttf1:setDimensions(GlobalMethod:CCSize(160,0))
		GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF):setScale(0.7)
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
	end
	
	if playerInfo.level == 0 then
		GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer):setVisible(false)
		local conType48 = GetElement(self.m_root, "conType48_WndTips", WZUIContainer)
		conType48:setAbsContentSize(GlobalMethod:CCSize(262,170))
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
			conType48:setAbsContentSize(GlobalMethod:CCSize(262,190))
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
	--卡牌徽章图标
	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setFile("ui/bag/common_icon_kapai2.png")
	GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage):setScale(0.6)
	--总等级
	local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
	ttf6Type48:setText(LocalStrings.CARD_TEXT35 .. cardInfo.level)
	ttf6Type48:setFontSize(22)
	ttf6Type48:setColor(GlobalMethod:ccc3(255,227,116))
	--已收集的卡牌数量
	local ttf1Type48 = GetElement(self.m_root,"ttf1Type48_WndTips",WZUILabelTTF)
	ttf1Type48:setText(string.format(LocalStrings.CARD_TEXT1, cardInfo.collectNum))
	ttf1Type48:setColor(GlobalMethod:ccc3(195,171,148))
	ttf1Type48:setFontSize(18)

	if cardInfo.collectNum == 0 then
		GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer):setVisible(false)
		return
	end
	local conDesc = GetElement(self.m_root, "conDesc_WndTips48", WZUIContainer)
	conDesc:setAbsContentSize(GlobalMethod:CCSize(262,120))
	conDesc:updateRelativeSize()


	local sFormat = [[<T C="255,227,116" S="18" P="1">%s</T><T C="255,227,116" S="18" P="1"> %d</T>]]
	for i = 1, 4 do
		local txt = string.format(sFormat, LocalStrings.CARD_TEXT36[i], cardInfo.cardNum[i][2])
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
	txtTotalPro:setColor(GlobalMethod:ccc3(255,227,116))

	sFormat = [[<T C="255,227,116" S="18" P="1">%s</T><T C="99,255,95" S="18" P="1"> %d</T>]]
	WZLog("WndTips:_update49 HHHHHH", Serialize(cardInfo.property))
	--战力加成
	local nFighting = WndCard:_caculateFighting(cardInfo.property)
	local txtFighting = GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(true)
		txtFighting:setText("+" .. nFighting .. LocalStrings.BATTLE)
	end
	for i = 1, #cardInfo.property do
		local txt = string.format(sFormat, ATTR_TITLE[cardInfo.property[i][1]], cardInfo.property[i][2])
		self:_createFtext(conProperty, txt, GlobalMethod:ccp(0.1, 0.85 - (i - 1) * 0.09))
	end
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
		GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF):setScale(0.7)
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
			txtKidName:setText(tData.kidData[i].name .. string.format(LocalStrings.CHECKOTHER_TEXT13, tData.kidData[i].level/10))
		end
	end
	local txtNotCare = GetElement(self.m_root, "txtNotCare_WndTips49", WZUILabelTTF)
	if tData.careToday == 0 then
		txtNotCare:setVisible(true)
		return 
	else
		txtNotCare:setVisible(false)
	end

	local sFormat = [[<T C="255,227,116" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T>]]
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
		lafCoolValue:setText(math.floor(tData.cooling_time/1000))
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
	elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		local label1Type = GetElement(self.m_root, "label1Type50_WndTips", WZUILabelTTF)
		label1Type:setScale(0.8)
		label1Type:setDimensions(GlobalMethod:CCSize(240))
		local txtDrop = GetElement(self.m_root, "txtDrop_WndTips50", WZUILabelTTF)
		txtDrop:setScale(0.8)
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
		label2Type50:setRelativePosition(GlobalMethod:ccp(0.532857,0.477368))
		local imgCostValue = GetElement(self.m_root, "imgCostValue_WndSkillProp", WZUIImage)
		imgCostValue:setScale(0.8)
		imgCostValue:setRelativePosition(GlobalMethod:ccp(0.64,0.289473))
		local imgCoolValue = GetElement(self.m_root, "imgCoolValue_WndSkillProp", WZUIImage)
		imgCoolValue:setScale(0.8)
		imgCoolValue:setRelativePosition(GlobalMethod:ccp(0.51,0.0473681))
		local label4Type = GetElement(self.m_root, "label4Type50_WndTips", WZUILabelTTF)
		label4Type:setScale(0.7)
		label4Type:setDimensions(GlobalMethod:CCSize(420))
	end

end

--@brief	点赞数量tips
function WndTips:_update52()
	WZLog("WndTips:_update52")
	local tData = self.m_tData
	local conType5 = GetElement(self.m_root,"conType5_WndTips",WZUIContainer)
	conType5:setVisible(true)
	conType5:setAbsContentSize(GlobalMethod:CCSize(275,100))
	conType5:updateRelativeSize()

	GetElement(self.m_root,"txt2Type5_WndTips",WZUIFreeTextBox):setShowText(string.format(LocalStrings.PVPGOOD_TEXT3, tData.zanNum))
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
	GetElement(self.m_root, "txtFighting_WndTips48", WZUILabelTTF):setVisible(true)

	GetElement(self.m_root, "conProperty_WndTips48", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"label1Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[1][1]])
	GetElement(self.m_root,"label2Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[1][2])
	GetElement(self.m_root,"label3Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[2][1]])
	GetElement(self.m_root,"label4Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[2][2])
	GetElement(self.m_root,"label5Type48_WndTips",WZUILabelTTF):setText(ATTR_TITLE[tData.property[3][1]])
	GetElement(self.m_root,"label6Type48_WndTips",WZUILabelTTF):setText("+"..tData.property[3][2])
	if ProjConfig.LANGUAGE == "vn" then
		GetElement(self.m_root,"txtTotalPro_WndTips48",WZUILabelTTF):setScale(0.7)
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
		local sFormat = [[<T S="20" C="255,236,193">%s</T><I Z="0.5">%s</I><T S="20" C="255,236,193">%d</T>]]
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
	--buff图标
	local imgHeadType48 = GetElement(self.m_root,"imgHeadType48_WndTips",WZUIImage)
	imgHeadType48:setScale(0.7)
	imgHeadType48:setRelativePosition(GlobalMethod:ccp(0.15, 0.75))
	imgHeadType48:setFile(buffData.buff2icon)
	--buff名字
	local ttf6Type48 = GetElement(self.m_root,"ttf6Type48_WndTips",WZUILabelTTF)
	ttf6Type48:setRelativePosition(GlobalMethod:ccp(0.28, 0.73))
	ttf6Type48:setFontSize(22)
	ttf6Type48:setColor(GlobalMethod:ccc3(255,227,116))
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
	local QUALITY_RECT_TIPS = {"ui/common/frame_green.png", "ui/common/frame_bule.png", "ui/common/frame_violet.png", "ui/common/frame_orange.png"}

	GetElement(self.m_root, "img9Quality_WndTips13", WZUI9Image):setFile(QUALITY_RECT_TIPS[tData.quality])
	--设置名字描述
	local titleType13 = GetElement(self.m_root,"titleType13_WndTips",WZUI9Label)
	titleType13:setText(tData.name)
	titleType13:setColor(GlobalMethod:ccc3(255,227,116))
	local descType13 = GetElement(self.m_root,"descType13_WndTips",WZUI9Label)
	descType13:setText(LocalStrings.LV .. tData.curLevel .. "/" .. LocalStrings.LV .. tData.targetLevel)
	descType13:setColor(GlobalMethod:ccc3(99,255,95))
	descType13:setDimensions(GlobalMethod:CCSize(0, 0))
	local txtStarNum13 = GetElement(self.m_root,"txtStarNum13_WndTips",WZUI9Label)
	txtStarNum13:setText(tData.curStar .. LocalStrings.COMMUNITYINFO224 .. "/" .. tData.targetStar .. LocalStrings.COMMUNITYINFO224)

	--设置怪物头像
	if tData.icon ~= nil then
		WZLog("显示怪物头像图片")
		GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setFile(tData.icon)
		GetElement(self.m_root,"imgType13_WndTips",WZUIImage):setVisible(true)
	end
end

--@brief    创建前往按钮
function WndTips:_createNormalBtn(txtBtnText)
    -- body
    local btnGoto = WZUIButton:create()
    btnGoto:setUseAbsSize(true)
    btnGoto:setAbsContentSize(GlobalMethod:CCSize(116,56))
    btnGoto:setRelativePosition(GlobalMethod:ccp(0.5,0.206))
    local imgNor = WZUIImage:create()
    imgNor:setFile("ui/common/common_btn_anniu4.png")
    local imgSel = WZUIImage:create()
    imgSel:setFile("ui/common/common_btn_anniu4_sel.png")
    btnGoto:setNormalElement(imgNor)
    btnGoto:setSelectElement(imgSel)
    btnGoto:setLuaDoneFunctionName("onCheckType45")

    local txtBtn = WZUILabelTTF:create()
    txtBtn:setText(txtBtnText)
    txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
    txtBtn:setStrokeColor(GlobalMethod:ccc3(79,60,48))
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
    ftxtPro:setShowText(txt)
    parentNode:addChild(ftxtPro)
    if ProjConfig.LANGUAGE == "en" then
        ftxtPro:setMaxWidth(600)
        ftxtPro:setScale(0.8)
    elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
        ftxtPro:setMaxWidth(320)
        ftxtPro:setScale(0.8)
    end
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
-------------------------------------语言适配模块End--------------------------------------
