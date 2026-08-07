--WndGangsterInn.lua
--@brief	WndGangsterInn的UI模块
--@date		2016/10/11
--@author	zsq
--@note		黑店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGangsterInn:onEnter(element)
	self.m_root = element
	WZLog("WndGangsterInn:onEnter")
	AdaptLanguage(self)
end

function WndGangsterInn:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
	if WndDressUp.m_root ~= nil and WndDressUp.m_tMsgData ~= nil then
        WndDressUp.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		WindowManagerAni:createDisappearAction(WndDressUp.m_root,nil,WndDressUp, true)
	end
end

--@brief    弹窗动画完成后的回调
function WndGangsterInn:actionCallback(element, data)
	WZLog("WndGangsterInn:actionCallback")
	ProtocolProcessorWndShop:send_MALL_GetBlackMarketInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGangsterInn:onExit(element)
	self:_unInit()
end

function WndGangsterInn:onTouchBegan(element, pt)
	local bPoint = WndItemInfo:checkPoint(pt,GlobalMethod:ccp(0,0))
	if bPoint == false then
		WndItemInfo:onCloseClick()
	end
end

--@brief	关闭窗口
function WndGangsterInn:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	关闭黑店
function WndGangsterInn:onCloseInn()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showConfirmBox(LocalStrings.INN10, self, self.onCloseInnCall, MSGBOXLEVEL_HIGH, nil)
end

function WndGangsterInn:onCloseInnCall()
	ProtocolProcessorWndShop:send_MALL_CloseBlackMarket()
	self.m_bOpen = false
	WindowManager:removeWindow(self.m_root, self, true)
	if WndWelfare.m_root ~= nil then
		WndWelfare:_update()
	end
end

--@brief	弹出黑店界面
function WndGangsterInn:show()
	if self.m_bFirstOpen == true then
		self.m_bFirstOpen = false
		local wnd = WndGangsterInnOwner:createElement()
    	WindowManager:addWindow(wnd, WndGangsterInnOwner, false)
	end
end

--@brief	说明
function WndGangsterInn:onInfo()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.INN11)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGangsterInn:update()
	WZLog("WndGangsterInn:update")
	if self.m_root == nil then return end 
	local tbCon = GetElement(self.m_root,"tabCon_WndGangsterInn",WZUITableContainer)
	tbCon:cleanTable()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		do return end
		ShowPanelNullTip(tbCon,nil,GlobalMethod:ccc3(255,236,193))
		WndLeagueTeamDetail.m_bNeedRecruit = false
		GetElement(WndLeagueTeamDetail.m_root,"imgRed",WZUIImage):setVisible(false)
	else
		--removeShowPanelNullTip(tbCon)
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellGangsterInn:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			celElement:setTag(i-1)
			celElement:setScale(1)
			tbCon:setCellElement(celElement)
		end 
	end

	--self.m_nLeftSecond = 30
end

function WndGangsterInn:updateTime()
	local self = WndGangsterInn
	self.m_nLeftSecond = self.m_nLeftSecond - 1
	local time = self.m_nLeftSecond
	local min = math.floor(time / 60)
	local sec = time % 60
	if min < 10 then min = "0"..min end
	if sec < 10 then sec = "0"..sec end
	if self.m_root ~= nil then
		GetElement(self.m_root,"txtTime",WZUIFreeTextBox):setShowText(string.format(LocalStrings.INN8,min..":"..sec))
	end

	if self.m_nLeftSecond <= 0 then
		WZLog("黑市商人离开")
		self.m_bOpen = false
		ProtocolProcessorWndShop:send_MALL_CloseBlackMarket()
    	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nScheduleId)
		if WndWelfare.m_root ~= nil then
			WndWelfare:_update()
		end

		--战斗中延迟提示离开
		if GlobalGame.g_bIfInBattle == true then 
			self.m_bShouldClose = true
			return 
		end
		if SceneLeagueMain.m_root ~= nil or SceneRoom.m_root ~= nil or SceneBossRoom.m_root ~= nil or SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil then 
			self.m_bShouldClose = true
			return 
		end

		MsgBoxManager:showTipBox(LocalStrings.INN12)

		if self.m_root ~= nil then
			WindowManager:removeWindow(self.m_root, self, true)
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndGangsterInn:_adaptLanguage_en(  )
	local txtAskToLeave = GetElement(self.m_root,"txtAskToLeave_WndGangsterInn",WZUILabelTTF)
	txtAskToLeave:setFontSize(20)
	local txtTime = GetElement(self.m_root,"txtTime",WZUIFreeTextBox)
	txtTime:setScale(0.8)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
end

function WndGangsterInn:_adaptLanguage_tr(  )
	local txtTime = GetElement(self.m_root,"txtTime",WZUIFreeTextBox)
	txtTime:setScale(0.7)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
end
-------------------------------------语言适配End--------------------------------------------