--WndBag.lua
--@brief	WndBag的UI模块
--@date		2014/02/17
--@author	zsq
--@note		背包模块
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBag:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	--self.startTime = WZThread:getUTickCount()

    local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
    local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    WZLog("WndBag:onEnter",step8, step26, isEndTeach26, tostring(TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7)) )
    if isEndTeach8 ~= true and step8 < 5 and step8 ~= 0 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end

end

function WndBag:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/bag/bag_icon_beibao.png",WndBag,WndBag.onCloseClick,true,false,false,"WndBag")
end

--@brief	加载动画
function WndBag:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
    self:AdaptResolution()
	--self:_addTop()

	self.m_nVigor = CacheCenter:getPlayerInfo().vigor
	self:onEnterFinish()
end

--@brief	初始化背包
function WndBag:onEnterFinish(element, t)
	--element:disableSchedule()
    ChangeChatChannel(Chat_CHannel_PlayerItem)

    AdaptLanguage(self)--多语言版本界面适配
	self:setDressRedPointVisble()	--设置时装按钮上的红点显示

	--默认打开背包面板
	self.m_bFrameIndex = 1
	GetElement(self.m_root,"btnBag_WndBag",WZUIButton):setButtonStatus(1)
	self:switchTab(1)
    self:setExchangeExp()
	--显示人物形象
    self:_addPlayer()

	if self.jumpTag == "Dress" then
		self:onDressClick()
	elseif self.jumpTag == "Recycle" then
		self:_addSell()
	end
end

--@brief	背包接口
function WndBag:showBag()
	WZLog("WndBag:showBag")
	if WndBagMain.m_root == nil then return end
	--if self.m_root == nil then  不需要判断，创建时如果之前有背包窗口，会先移除
		local wnd = WndBag:createElement()
		WindowManager:addWindow(wnd, WndBag, nil, nil, true)
		WndBag:regAllBag()
	--end
end

function WndBag:showWin()
	WZLog("WndBag:showWin")
	self:showBag()
end

--@brief	进入背包合成
--@brief	tabIndex进入标签
function WndBag:showBagSynthesis(tabIndex, synId)
	WZLog("WndBag:showBagSynthesis",tabIndex)
	if WndItemInfo.m_root ~= nil then return end
	if self.m_root == nil then
		local wndBagElement = WndBag:createElement()
		WindowManager:addWindow(wndBagElement, WndBag, nil, nil, true)
		WndBag:regAllBag()
    	--左右容器移动动画
    	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
    	local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
		leftCon:setVisible(false)
		rightCon:setVisible(false)

		if tabIndex == nil then tabIndex = 1 end
		self.synthesisIndex = tabIndex
		self.synId = synId
		leftCon:enableSchedule("showBagSynthesisCall",0.1)
	else
    	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
    	local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
		leftCon:setVisible(false)
		rightCon:setVisible(false)

		if tabIndex == nil then tabIndex = 1 end
		self.synthesisIndex = tabIndex
		self.synId = synId
		leftCon:enableSchedule("showBagSynthesisCall",0.1)
	end
end

--@brief	延时进入合成
function WndBag:showBagSynthesisCall()
	WZLog("WndBag:showBagSynthesisCall")
	if WndItemInfo.m_root ~= nil then return end
   	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
	leftCon:disableSchedule()
	self:onSynthesis()

	WndSynthesisRight:_updateWithIndex(self.synthesisIndex)
	leftCon:enableSchedule("showBagSynthesisCall1",0.3)
end

function WndBag:showBagSynthesisCall1()
   	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
	leftCon:disableSchedule()

	WndSynthesisRight:autoPutItem()
end

--@brief	进入背包时装
function WndBag:showBagDress()
	WZLog("WndBag:showBagDress")
	if self.m_root == nil then
		local wndBagElement = WndBag:createElement()
		WndBag.jumpTag = "Dress"
		WindowManager:addWindow(wndBagElement, WndBag, nil, nil, true)
		WndBag:regAllBag()
	end
end

--@brief	进入背包回收
function WndBag:showBagRecycle()
	WZLog("WndBag:showBagRecycle")
	if WndItemInfo.m_root ~= nil then return end
	if self.m_root == nil then
		local wndBagElement = WndBag:createElement()
		WndBag.jumpTag = "Recycle"
		WindowManager:addWindow(wndBagElement, WndBag, nil, nil, true)
		WndBag:regAllBag()
	end
end

--@brief	注册bag
function WndBag:regAllBag()
	ProtocolProcessorWndBag:regAll()
	ProtocolProcessorWndMonthCards:regAll()
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief	反注册
function WndBag:unregAllBag()
	ProtocolProcessorWndBag:unregAll()
	ProtocolProcessorWndMonthCards:unregAll()
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndBag:onCloseClick(element)
    WZLog("WndBag:onCloseClick")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
    local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    if isEndTeach8 ~= true and step8 > 0 then
        TeachGroup1:endTeachStep({8,6})
    end

	if type(element) == "number" and element == 1 then --如果是私聊，就关闭窗口，不弹动画
		WndPlayerInfo:onClose()
		WindowManager:removeWindow(self.m_root, self, true)
	else
		--WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
		--出售移出
		WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conSellList_WndBag",WZUIContainer),0,true,nil,nil,nil,true)
		WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conSell_WndBag",WZUIContainer),1,true,nil,nil,nil,true)
		--合成移出
		WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conSynthesisList_WndBag",WZUIContainer),0,true,nil,nil,nil,true)
		WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conSynthesis_WndBag",WZUIContainer),1,true,nil,nil,nil,true)

		--左右容器移动动画
		local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
		WindowManagerAni:createSwitchTabAction(rightCon,1,true,nil,nil,nil,true)

		local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
		WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.onCloseActionCallback,true)
	end
end

function WndBag:onCloseActionCallback(elem,data)
	WZLog("WndBag:onCloseActionCallback")
	self:unregAllBag()
	WndPlayerInfo:onClose()

    WindowManager:removeWindow(self.m_root , self , true)
    --WindowManagerAni:createDisappearAction(self.m_root,"onDisappearActionCallback",self)
end

--@brief	窗口动画关闭完成回调
function WndBag:onDisappearActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBag:onExit(element)
    WZLog("WndBag:onExit")
    g_bIsShowWndDressUp = true
    WndCurrentChat:showButtomChat()
	self:_unInit()
    ChangeChatChannel(Teach.PreUIChannelId)
    ProtocolProcessorWndBag:unregAll()
	WndBag:unregAllBag()
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
    TeachGroup1:startGroup({8,7,GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root})
end

--@brief	开始按下回调函数
function WndBag:onTouchBegin(element,pt)
	WZLog("WndBag:onTouchBegin",pt.x,pt.y)
	local point = self.m_root:getParentElement():convertToNodeSpace(pt)
	local bPoint = WndItemInfo:checkPoint(pt,dir)
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 5
	if bPoint == true then
		WZLog("回调函数:",type(bPoint),bPoint)
	elseif isTeach ~= true then
		WndItemInfo:onCloseClick()
	end
	--if not WndTips:checkPointInBtn(pt) and isTeach ~= true then
	--	WndTips:onCloseClick()
	--end
	self:updateBtnStatus()
end

--@brief	按下移动回调函数
function WndBag:onTouchMove(element,pt)

end

--@brief	按下结束回调函数
function WndBag:onTouchEnd(element,pt)
	WZLog("WndBag:onTouchEnd",self.m_bFrameIndex)

	self:updateBtnStatus()
end

--@brief	更新属性，背包，时装按钮状态
function WndBag:updateBtnStatus()
	if self.m_bFrameIndex == 3 then
		GetElement(self.m_root,"btnPro_WndBag",WZUIButton):setButtonStatus(1)
		GetElement(self.m_root,"btnBag_WndBag",WZUIButton):setButtonStatus(0)
		GetElement(self.m_root,"btnDress_WndBag",WZUIButton):setButtonStatus(0)
	elseif self.m_bFrameIndex == 1 then
		GetElement(self.m_root,"btnPro_WndBag",WZUIButton):setButtonStatus(0)
		GetElement(self.m_root,"btnBag_WndBag",WZUIButton):setButtonStatus(1)
		GetElement(self.m_root,"btnDress_WndBag",WZUIButton):setButtonStatus(0)
	elseif self.m_bFrameIndex == 2 then
		--GetElement(self.m_root,"btnPro_WndBag",WZUIButton):setButtonStatus(0)
		--GetElement(self.m_root,"btnBag_WndBag",WZUIButton):setButtonStatus(0)
		--GetElement(self.m_root,"btnDress_WndBag",WZUIButton):setButtonStatus(1)
	end
end

--@brief	背包标签：一键装备
--@brief	时装标签：时装属性
function WndBag:onSwitchBtn()
	WZLog("WndBag:onSwitchBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if 	self.m_bFrameIndex == 2 then
		--时装属性
		local wnd = WndDressAttr:createElement()
		WindowManager:addWindow(wnd, WndDressAttr, true)
	else
		--一键换装
		local equipList = CacheCenter:getEquipList()
    	local id = WZLuaVector_int_:create()
		local sell = false
		for k,v in pairs(equipList) do
    		if v.recommended == true then
            	id:push(v.playerItemId)
				sell = true
			end
		end
		WZLog("要换上的装备是",Serialize(VectorToTable(id)))
		if sell == true then
			ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
		end
	end
end

--@brief    转化
function WndBag:onClickExchange(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndExchangeExp:showInterface()
end

--@brief	玩家穿上物品点击回调
function WndBag:onWearItemClick(index,tData)
	WZLog("玩家穿上物品点击回调",index,tData)

	if index == 3 then--过期按回调
    	local id = WZLuaVector_int_:create()
		id:push(tData.playerItemId)
		ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
	end
end

--@brief	物品点击回调
function WndBag:onItemClick(index,tData)
	WZLog("WndBag:onItemClick物品点击回调",index,type(tData))

	if index == 1 then--过期按回调
		
	elseif index == 2 then--穿上回调
    	local id = WZLuaVector_int_:create()
		id:push(tData.playerItemId)
		ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
	elseif index == 3 then--御下回调
    	local id = WZLuaVector_int_:create()
		id:push(tData.playerItemId)
		ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
	elseif index == 4 then--回调
		self:onItemApply(tData)
	elseif index == 5 then--强化回调

	end
end

--@brief	物品点击回调（包括左右物品）
function WndBag:onItem(index)
	self:_setLeftOrder(600+1-index)--左边人物层次
	self:_setRightOrder(600+index)--右边人物层次
end

--@brief	穿上回调
function WndBag:onItemWear(luaTable,tData)
	WZLog("WndBag:onItemWear穿上回调",luaTable,tData)
	self.m_tFailData = tData
	if tData.maintype < 2 then--穿上武器		
		--self:replaceArms()
	else--穿上装扮
		self:replaceDress()--更换装扮
 	end
	ProtocolProcessorWndBag:send_PLAYER_TakeOnEquipment(tData.maintype,tData.id)
end

--@brief	卸下回调
function WndBag:onItemRoyal(luaTable,tData)
	WZLog("卸下回调",luaTable)
	self:royalDress(luaTable,tData)
end

--@brief 	返回相应的物品的playerItemId
function WndBag:returnPlayerItemId(itemId)
	local tPlayerItemList = CacheCenter:getPlayerItems()
	for i = 1, #tPlayerItemList do
		if tPlayerItemList[i].id == itemId then
			return tPlayerItemList[i].playerItemId
		end
	end
end

--@brief	使用回调
function WndBag:onItemApply(tData)
	WZLog("**************** WndBag:onItemApply **************", tData.main_type, tData.sub_type)
	if tData.main_type == 10 and (tData.sub_type == 12 or tData.sub_type == 13) then
		ProtocolProcessorWndBag:send_SPREE_GetGift(tData.id)
		return --如果是礼包就发协议
	elseif tData.main_type == 8 and tData.sub_type == 6 then
		ProtocolProcessorWndBag:send_BATTLE_ClearFailNum()
		return --如果是失败清零券就发协议
	elseif tData.main_type == 2 and tData.sub_type == 14 then
		local nPlayerItemId = self:returnPlayerItemId(tData.id)
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, "" )
		return --技能书
	elseif tData.main_type == 2 and tData.sub_type == 15 then
		if tData.id == 809 then
    		MsgBoxManager:showConfirmCancelBox(LocalStrings.WAKEUP_TEXT44 or "", self, self.onResetInborn, nil)
		else
    		MsgBoxManager:showConfirmCancelBox(LocalStrings.NEWSKILL22 or "", self, self.onResetCall, nil)
    	end
		return --技能遗忘药水
	elseif tData.main_type == 8 and tData.sub_type == 25 then

		return 
	elseif (tData.main_type == 2 and tData.sub_type == 2) then 
		local nPlayerItemId = self:returnPlayerItemId(tData.id)
		--self.m_nUseType = 3    --标记是甜甜圈
		--WZLog("************** WndBag:onItemApply*********** 鸡腿", nPlayerItemId)
		--ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, "" )

		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		WndOpenChest:setData(tData)

		return--如果是甜甜圈，就发送甜甜圈协议、
	elseif (tData.main_type == 2 and tData.sub_type == 1) then 
		WZLog("************************* 77777 ******************* ", type(CacheCenter:getPlayerInfo().position))
		if tonumber(CacheCenter:getPlayerInfo().position) ~= 4 then --公会改名必须是会长
			local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONFIRM}
			MsgBoxManager:showConfirmBox(LocalStrings.YOU_CANT_CHANGE_NAME, self,self.clickSureBack, nil, tCustomUIConfig, true)
			return 
		end
	elseif (tData.main_type == 20) then 
		MsgBoxManager:showTipBox("皮肤体验卡")
		ProtocolProcessorPhantom:send_SHAPE_UseItem(self:returnPlayerItemId(tData.id) )
	elseif tData.main_type == 23 then 
		WZLog("WndBag:onItemApply 足迹体验卡", tData.id)
		g_nUseFootMarkId = tData.id
		ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(tData.id)
	end
	local element = WndEditBox:createElement()
	WndEditBox:setOkCallBack(self.onApplyRename, self)
	WndEditBox:setOtherData(tData)
	WndEditBox:setData(LocalStrings.INPUT_NEW_NAME, LocalStrings.CLICK_TO_INPUT_NAME)
	WindowManager:addWindow(element, WndEditBox)
end

function WndBag:onResetCall(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill( )
	end
end

--@brief 	重置
function WndBag:onResetInborn(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local nPlayerItemId = self:returnPlayerItemId(809)
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, "" )
	end
end

function WndBag:clickSureBack()
	-- body
--	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function WndBag:displayResult(result)
    WZLog("************** WndBag:displayResult **************** ", result,self.m_nUseType)

    if result == 1 then
    	if self.m_nUseType == 1 then    --改名成功
	        MsgBoxManager:showTipBox(LocalStrings.PLAYER_RENAME)
	    elseif self.m_nUseType == 2 then --改公会名成功
	    	MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_RENAME)
			if SceneMemberList.m_root ~= nil then
				--获取公会大厅
				ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
			end
	    elseif self.m_nUseType == 3 then --甜甜圈成功
	    --	MsgBoxManager:showTipBox(LocalStrings.PLAYER_RENAME)
		else
			
	    end
    elseif result == 2 then
    	if self.m_nUseType == 1 then 
        	MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
        elseif self.m_nUseType == 2 then
        	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO4)
        end
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then
    	if self.m_nUseType == 1 then
        	MsgBoxManager:showTipBox(string.format(LocalStrings.ACTOR_MAX_NAME,6))
        elseif self.m_nUseType == 2 then 
        	MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
        end
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    elseif result == 8 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
    end
end

function WndBag:_checkInputTxtLen(inputTxt)
	-- body
	local sTxt = inputTxt
	local nInputTxtLen = 0

	WZLog("******** WndBag:_checkInputTxtLen ******", inputTxt)

	local _,count = string.gsub(sTxt, "%w", "A") --统计字母数字的数量
	nInputTxtLen = nInputTxtLen + count 

	sTxt= inputTxt
	local _,count1 = string.gsub(sTxt, "%p", "A") 	--统计符号的数量
	nInputTxtLen = nInputTxtLen + count1 

	sTxt= inputTxt
	local _,count2 = string.gsub(sTxt,"%s", "A")		--统计空格的数量
	nInputTxtLen = nInputTxtLen + count2

	local nLen = string.len(inputTxt)
	nInputTxtLen = nInputTxtLen + 2 * math.floor((nLen - count - count1 - count2) / 3)

	return nInputTxtLen, count2
end

--@brief	续费回调
function WndBag:onRenewalFun()
	WZLog("WndBag:onRenewalFun:续费回调")
end

--@brief	开宝箱回调
function WndBag:onChestBackFun()
	WZLog("WndBag:onChestBackFun:开宝箱回调")
end

--@brief	改名笔回调
function WndBag:onApplyRename(txt,lua,tData)
	WZLog("改名笔回调:",tData,tData.main_type,tData.sub_type,txt)
	local main_type = tData.basicInfo.main_type
	local sub_type = tData.basicInfo.sub_type
	if main_type == 2 and sub_type == 0 then--使名笔
		local nPlayerItemId = self:returnPlayerItemId(tData.id)
		self.m_nUseType = 1   --标记为改名笔
		result = JudgeResultInClientForInputText(self.m_nUseType, txt)
		if result == 0 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, txt )
		else
			self:displayResult(result)
		end
	elseif main_type == 2 and sub_type == 1 then--公会
		local nPlayerItemId = self:returnPlayerItemId(tData.id)
		self.m_nUseType = 2 	--标记为公会改名笔
		result = JudgeResultInClientForInputText(self.m_nUseType, txt)
        WZLog("公会改名笔 ***** ：", result)
		if result == 0 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, txt )
		else
			self:displayResult(result)
		end
	elseif main_type == 8 and sub_type == 6 then--清零道具
		ProtocolProcessorWndBag:send_BATTLE_ClearFailNum()
	else--礼包
		ProtocolProcessorWndBag:send_SPREE_GetGift(tData.id)
	end
end

--@brief	改名笔失败回调
function WndBag:onRenameFaile(sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	切换标签动画
function WndBag:switchAni(fCallback)
	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
	WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,nil,nil)

	local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
	WindowManagerAni:createSwitchTabAction(rightCon,1,true,nil,self,fCallback)
end

--@brief	点击属性回调
function WndBag:onPropertyClick(element)
	WZLog("WndBag:onPropertyClick")

    local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    WZLog("WndBag:onPropertyClick",isEndTeach26,step26 )
    if isEndTeach26 ~= true and (step26 > 0 or TeachGroup1.ISTEACHMODE) and CacheCenter:getPlayerInfo().level == 10 then
        return
    end

	if self.m_bAniRunning == true then return end
	if self.m_bFrameIndex == 3 then return end
	--调用动画
	self.m_bAniRunning = true
	self:switchAni(self.onPropertyClickCall)
end

--@brief	点击属性回调
function WndBag:onPropertyClickCall(element)
	WZLog("WndBag:onPropertyClickCall")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if CheckButtonOpen(ISLAND_RIGHT_PHANTOM) then
        WndPhantom:showWin()
    end
	--右侧切换到属性
	--self:switchTab(2)
	--self.m_bFrameIndex = 3
	--更新按钮状态
	--self:updateBtnStatus()
	self.m_bAniRunning = false
end

--@brief	点击背包回调
function WndBag:onBagClick(element)
	WZLog("WndBag:onBagClick",self.m_bAniRunning,self.m_bFrameIndex)
	if self.m_bAniRunning == true then return end
	if self.m_bFrameIndex == 1 then return end
	--调用动画
	self.m_bAniRunning = true
	self:switchAni(self.onBagClickCall)
end

--@brief	点击背包回调
function WndBag:onBagClickCall(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--右侧切换到属性
	self:switchTab(1)
	self.m_bFrameIndex = 1
	--更新按钮状态
	self:updateBtnStatus()
	self.m_bAniRunning = false
end

--@brief	点击时装回调
function WndBag:onDressClick(element)
	WZLog("WndBag:onDressClick")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--打开衣橱
	Wndwardrobe:show()
	--把红点设置为不可见
	GetElement(self.m_root,"red1_WndBag",WZUIImage):setVisible(false)
end

--@brief	点击出售回调
function WndBag:onSaleClick(element)
	WZLog("WndBag:onSaleClick")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:_addSell()
end

--@brief	点击合成回调
function WndBag:onSynthesis(element)
	WZLog("WndBag:onSynthesis")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	JumpByUIId(151)
	do return end
	if CheckButtonOpen(32) ~= true then return end
	--创建合成窗口
	if self.m_tWndSynthesis == nil then
		local conSell = GetElement(self.m_root,"conSynthesis_WndBag",WZUIContainer)
		local celElement = WndSynthesisRight:createElement()
		conSell:addChild(celElement)
		self.m_tWndSynthesis = celElement:getLuaObjectIndex()
		self.m_tWndSynthesis.m_root:setVisible(false)
	end
	WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conRight_WndBag",WZUIContainer),1,true,self.m_tWndSynthesis.m_root)

	--创建合成物品列表窗口
	if self.m_tWndSynthesisList == nil then
		local conSellList = GetElement(self.m_root,"conSynthesisList_WndBag",WZUIContainer)
		local celElement = WndSynthesisLeft:createElement()
		conSellList:addChild(celElement)
		self.m_tWndSynthesisList = celElement:getLuaObjectIndex()
		self.m_tWndSynthesisList.m_root:setVisible(false)
	end
	WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conLeft_WndBag",WZUIContainer),0,true,self.m_tWndSynthesisList.m_root)
end

--@brief	点击成就按钮
function WndBag:onAchievement()
	WZLog("WndBag:onAchievement")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local wndDesignationElement = WndDesignationMain:createElement()
	if wndDesignationElement == nil then 
		return
	end
	WindowManager:addWindow(wndDesignationElement , WndDesignationMain)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   左边人物层次
function WndBag:_setLeftOrder(order)
	local conLeft = self.m_root:getChildElement("conLeftA_WndBag")
	conLeft = WZUIContainer:luaTo(conLeft)
	conLeft:setZOrder(order)
end

--@brief   右边人物层次
function WndBag:_setRightOrder(order)
	local conRight = self.m_root:getChildElement("conRightB_WndBag")
	conRight = WZUIContainer:luaTo(conRight)
	conRight:setZOrder(order)
end

-------------------------------------私有方法模块End----------------------------------------
--@brief   添加人物形象和装备栏
function WndBag:_addPlayer()
	local conPlayer = self.m_root:getChildElement("conRoleEquip_WndBag")
	if conPlayer:getChildByTag(20) then
		conPlayer:removeChildByTag(20,true)
	end
	local celElement = WndPlayer:createElement()
	celElement:setTag(20)
	conPlayer:addChild(celElement)
	WndPlayer:setItemBackFun(self,self.onWearItemClick,self.onItem)
	WndPlayer.m_bCheckOther = false
end

--@brief   添加右侧背包栏
function WndBag:_addEquip()
	local conPlayer = self.m_root:getChildElement("conRight_WndBag")
	local celElement = WndEquip:createElement()
	if conPlayer:getChildByTag(1) then
		conPlayer:removeChildByTag(1,true)
	end
	celElement:setTag(1)
	WndEquip:setItemBackFun(self,self.onItemClick,self.onItem)
	conPlayer:addChild(celElement)
end

--@brief   添加右侧玩家个人面板
function WndBag:_addPlayerInfo()
	WZLog("WndBag:_addPlayerInfo")
	local conPlayer = WZUIContainer:luaTo(self.m_root:getChildElement("conRight_WndBag"))
	if WndPlayerInfo.m_root == nil then
		if conPlayer:getChildByTag(2) then
			conPlayer:removeChildByTag(2,true)
		end
		local player = WndPlayerInfo:createElement()
		player:setTag(2)
		conPlayer:addChild(player)
		player:setRelativePosition(GlobalMethod:ccp(0.358,0.457))
		player:setVisible(false)
	end
end

--@brief	添加右侧回收背包栏
function WndBag:_addSell()
    if CheckButtonOpen(ISLAND_RIGHT_STRENGTHEN) then
        local wndStrengthen = WndStrengthen:createElement()
        if wndStrengthen ~= nil then
            WindowManager:addWindow(wndStrengthen, WndStrengthen, false)
        end
	end
	do return end
	
	--创建出售窗口
	if self.m_tWndSell == nil then
		local conSell = GetElement(self.m_root,"conSell_WndBag",WZUIContainer)
		local celElement = WndSell:createElement()
		conSell:addChild(celElement)
		self.m_tWndSell = celElement:getLuaObjectIndex()
		self.m_tWndSell.m_root:setVisible(false)
	end
	WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conRight_WndBag",WZUIContainer),1,true,self.m_tWndSell.m_root)

	--创建出售物品列表窗口
	if self.m_tWndSellList == nil then
		local conSellList = GetElement(self.m_root,"conSellList_WndBag",WZUIContainer)
		local celElement = WndSellList:createElement()
		conSellList:addChild(celElement)
		self.m_tWndSellList = celElement:getLuaObjectIndex()
		self.m_tWndSellList.m_root:setVisible(false)
	end
	WindowManagerAni:createSwitchTabAction(GetElement(self.m_root,"conLeft_WndBag",WZUIContainer),0,true,self.m_tWndSellList.m_root)
end

--@brief	设置时装按钮红点是否可见
function WndBag:setDressRedPointVisble()
	local num = {0,0,0,0}
	local hasDress = {false,false,false,false}
	local displayRed = false
	local tempList = CacheCenter:getDecorationList()
	for k,v in pairs(tempList) do
		for i=1,4 do
			if v.subtype == (i-1) and v.lastTime ~= 0 then
				num[i] = num[i] + 1
			end
			if v.subtype == (i-1) and v.lastTime ~= 0 and v.isUse == true then
				hasDress[i] = true
			end
		end
	end
	--for i=1,4 do
	--	if hasDress[i] == false and num[i] > 0 then
	--		displayRed = true
	--	end
	--end
	if CacheCenter:hasExpiredDress() and GlobalGame.g_ClickedDress ~= true then
		displayRed = true
	end
	--设置红点
	GetElement(self.m_root,"red1_WndBag",WZUIImage):setVisible(displayRed)
end

--@brief   玩家个人信息和装备物品界面转换
function WndBag:switchTab(index)
	local conRight = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
	local methodList = {"_addEquip","_addPlayerInfo"}
	--已经添加，设置为不可见
	for i=1,2 do
		if conRight:getChildByTag(i) then
			conRight:getChildByTag(i):setVisible(false)
		end
	end
	--未添加则添加
	if conRight:getChildByTag(index) then
		conRight:getChildByTag(index):setVisible(true)
	else
		self[methodList[index]](self)
		if index == 2 then
			WndPlayerInfo:setPlayerData(CacheCenter:getPlayerInfo())
		end
		conRight:getChildByTag(index):setVisible(true)
	end
end

-------------------------------------语言适配模块Begin----------------------------------------

--@brief	适配分辨率
function WndBag:AdaptResolution()
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("WndBag:AdaptResolution",directorSize.height)
	--iphone5适配
	if directorSize.width > 960 then
	end
	--ipad适配
	if directorSize.width == 1024 and directorSize.height == 768 then
		--GetElement(self.m_root,"conPlayer_WndBag",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.487,0.058))
	end
	if directorSize.width == 2048 and directorSize.height == 1536 then
		--GetElement(self.m_root,"conPlayer_WndBag",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.487,0.058))
	end
end

function WndBag:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtExchageExp_WndBag",WZUILabelTTF):setFontSize(12)
	
	GetElement(self.m_root,"txtEquipAll_WndBag",WZUILabelTTF):setScale(0.6)
end

function WndBag:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtExchageExp_WndBag",WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root,"txtEquipAll_WndBag",WZUILabelTTF):setScale(0.6)
end

function WndBag:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtExchageExp_WndBag",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtEquipAll_WndBag",WZUILabelTTF):setScale(0.6)
end

function WndBag:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtEquipAll_WndBag",WZUILabelTTF):setScale(0.7)
end

function WndBag:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtExchageExp_WndBag",WZUILabelTTF):setScale(0.6)
end

function WndBag:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtExchageExp_WndBag",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtEquipAll_WndBag",WZUILabelTTF):setScale(0.6)
end
-------------------------------------语言适配模块End----------------------------------------
