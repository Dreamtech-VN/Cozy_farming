--WndActivityIntegrate.lua
--@brief	WndActivityIntegrate的UI模块
--@date		2020/07/16
--@author	hyx
--@note		活动整合模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivityIntegrate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivityIntegrate:onExit(element)
	if self.integerInterfacePanel and next(self.integerInterfacePanel) ~= nil then
		for i,v in pairs(self.integerInterfacePanel) do
			if v then
				v:removeFromParentAndCleanup(true)
			end
		end
	end	 
	self:_unInit()
	LoadNewActivityRes(false)
end

function WndActivityIntegrate:btnCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
	if GlobalGame.g_autoReturnActivity then
        MsgBoxManager:showReturnActivity()
    end 
end
--@brief 	关闭活动界面
function WndActivityIntegrate:closeActivity()
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end
--@brief    onenter函数已执行
function WndActivityIntegrate:onEnterTransitionDidFinish(element)
	self:initUI()
	self:changeTanTitle(self.m_nFirstCurIndex)
end
function WndActivityIntegrate:initUI()
	if not self.m_root then return end
	self.secondTitleContainer = GetElement(self.m_root, "secondTitleContainer", WZUIContainer)
	local name = {LocalStrings.WELFARE_NEWTEXT1, LocalStrings.GAMEACTIVITY_NEWTEXT1, LocalStrings.LOURAACT6, LocalStrings.PROMISE_SHRINE_TEXT10, LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_AMBERPLAYER}
	local fristTitleContainer = GetElement(self.m_root, "fristTitleContainer", WZUIContainer)
	self.m_tFirstTitle = {}
	--针对许愿池是否开放的
	local open_level = CacheCenter:getPlayerInfo().level
	local open_wish = GDatatab_button_info["id_113"].show_level
	local status = false
	for i=1, #name do
		local tab = {}
		local tabTitleBtn = GetElement(fristTitleContainer, "tabTitleBtn_"..i, WZUIButton)
		if i == 4 then
			if open_level >= open_wish then
			else
				status = true
				tabTitleBtn:setVisible(false)
			end
		end
		if i == 5 then
			if status== true then
				tabTitleBtn:setRelativePosition(GlobalMethod:ccp(0.093,0.511))
			end
		end
		tab.select = GetElement(tabTitleBtn, "select_"..i, WZUIImage)
		tab.select:setVisible(false)
		tab.name = GetElement(tabTitleBtn, "name_"..i, WZUILabelTTF)
		tab.name:setText(name[i])
		if ProjConfig.LANGUAGE == "vn" then
			tab.name:setScale(0.7)
		end
		tab.name:setEnableStroke(true)
		tab.name:setColor(GlobalMethod:ccc3(255,236,193))
		tab.name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
		tab.name:setStrokeSize(4)
		self.m_tFirstTitle[i] = tab
	end
	self:updateUI()
	self:setRedDot()
end
--@brief	外部接口调用
--nIndex : 界面类型：1->福利；2\活动 3\精彩推荐 4\许愿 5\琥珀大玩家
--@param    ui_id: 活动类型，值从m_tListItem列表中的ui_id取
function WndActivityIntegrate:showInterface(nIndex, ui_id, tMsg)
	if self.m_root == nil then
		LoadNewActivityRes(true)
		local activity = WndActivityIntegrate:createElement()
		self.m_nFirstCurIndex = nIndex or 1
		if nIndex == 1 then
			self.m_sWelfarwMsg = tMsg or nil
		elseif nIndex == 2 then
			self.m_sMathMsg = tMsg or nil
		end
		self.m_nUI_ID = ui_id
		WindowManager:addWindow(activity, WndActivityIntegrate, false)
	end
end

--@brief	由于存在显示界面时协议不一定及时下发，g_cityExtenInfo为空，故在协议收到时更新界面-oppo琥珀大玩家
function WndActivityIntegrate:updateUI()
	WZLog("WndActivityIntegrate:updateUI")
	local packageName = WGameCmUtil:GetBundleIdentifier()
	local tabTitleBtn_5 = GetElement(self.m_root, "tabTitleBtn_5", WZUIButton)
	if tabTitleBtn_5 then
		if GlobalMethod:getIsShowOVAmberPlayer() then
			WZLog("WndActivityIntegrate:updateUI", "显示琥珀大玩家")
			tabTitleBtn_5:setVisible(true)
		else
			WZLog("WndActivityIntegrate:updateUI", "隐藏琥珀大玩家")
			tabTitleBtn_5:setVisible(false)
		end
	end
end

function WndActivityIntegrate:onTabTitleClick(element)
	local tag = element:getTag()

	if tag == self.m_nFirstCurIndex then return end

	self:changeTanTitle(tag)
end

function WndActivityIntegrate:changeTanTitle(tag)
	if not self.m_tFirstTitle or next(self.m_tFirstTitle) == nil then return end

	if self.m_tFirstTitle[self.m_nFirstCurIndex] ~= nil then
		self.m_tFirstTitle[self.m_nFirstCurIndex].select:setVisible(false)
		self.m_tFirstTitle[self.m_nFirstCurIndex].name:setEnableStroke(true)
		self.m_tFirstTitle[self.m_nFirstCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tFirstTitle[self.m_nFirstCurIndex].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
	end
	if self.m_tFirstTitle[tag] ~= nil then
		self.m_tFirstTitle[tag].select:setVisible(true)
		self.m_tFirstTitle[tag].name:setEnableStroke(false)
		self.m_tFirstTitle[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
	end
	if self.m_sTouchCurrentFace ~= nil then
		if self.m_sTouchCurrentFace.setVisibleStatus then
			self.m_sTouchCurrentFace:setVisibleStatus(false)
		else
			self.m_sTouchCurrentFace:setVisible(false)
		end
		self.m_sTouchCurrentFace = nil
	end
	if tag == 1 or tag == 3 then
		if self.integerInterfacePanel[tag] then
			self.integerInterfacePanel[tag]:removeFromParentAndCleanup(true)
			self.integerInterfacePanel[tag] = nil
		end
	end
	if self.integerInterfacePanel[tag] == nil then
		local panel = nil
		if tag == 1 then --福利
			panel = WndWelfare:createElement(1, self.m_nUI_ID, self.m_sWelfarwMsg)
		elseif tag == 2 then --活动
			panel = WndGameActivity:createElement(self.m_nUI_ID)
		elseif tag == 3 then	--比赛
			panel = WndWelfare:createElement(20, self.m_nUI_ID, self.m_sMathMsg)
		elseif tag == 4 then --许愿
			panel = WndPromiseShrine:createElement()
		elseif tag == 5 then --OPPO琥珀大玩家
			panel = WndAmberPlayer:createElement()
		end
		if panel then
			self.secondTitleContainer:addChild(panel)
			self.integerInterfacePanel[tag] = panel
		end
	end

	if self.m_root then
		self:btnShowRule(tag)
    end
	self.m_sTouchCurrentFace = self.integerInterfacePanel[tag]
	if self.m_sTouchCurrentFace then
		if self.m_sTouchCurrentFace.setVisibleStatus then
			self.m_sTouchCurrentFace.setVisibleStatus(true)
		else
			self.m_sTouchCurrentFace:setVisible(true)
		end
	end

	self.m_nFirstCurIndex = tag
end

--规则按钮
function WndActivityIntegrate:btnShowRule(tag)
	if tag ~= 4 then
		if self.m_btnRule then
			self.m_btnRule:setVisible(false)
		end
		return 
	end
	if not self.m_root then return end
	if not self.m_btnRule then
	    self.m_btnRule = WZUIButton:create()
	    self.m_btnRule:setUseAbsSize(true)
	    self.m_btnRule:setRelativePosition(GlobalMethod:ccp(0.97, 0.05))

	    local imgNor = WZUIImage:create()
	    imgNor:setUseOriginSize(true)
	    imgNor:setFile("ui/common/common_icon_bz.png")
	    local imgSel = WZUIImage:create()
	    imgSel:setUseOriginSize(true)
	    imgSel:setFile("ui/common/common_icon_bz.png")
	    imgSel:setScale(1.1)
	    self.m_btnRule:setNormalElement(imgNor)
	    self.m_btnRule:setSelectElement(imgSel)
	    self.m_btnRule:setShowAll(true)
	    self.m_btnRule:setLuaDoneFunctionName("onClickRule")
	    self.m_root:addChild(self.m_btnRule)
	else
		self.m_btnRule:setVisible(true)
	end
end
function WndActivityIntegrate:onClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PROMISE_SHRINE_TEXT8)
end

--@brief 	设置红点
function WndActivityIntegrate:setRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgRedDot1 = GetElement(self.m_root, "imgRedDot1_WndActivityIntegrate", WZUIImage)
	local imgRedDot2 = GetElement(self.m_root, "imgRedDot2_WndActivityIntegrate", WZUIImage)
	local imgRedDot3 = GetElement(self.m_root, "imgRedDot3_WndActivityIntegrate", WZUIImage)
	local imgRedDot5 = GetElement(self.m_root, "imgRedDot5_WndActivityIntegrate", WZUIImage)
	--福利红点
	if CacheCenter.m_tWelfareItemRedDotList and #CacheCenter.m_tWelfareItemRedDotList > 0 then 
		imgRedDot1:setVisible(true)
	else
		imgRedDot1:setVisible(false)
	end
	--活动红点
	if CacheCenter.m_tActivityItemRedDotList and #CacheCenter.m_tActivityItemRedDotList > 0 then 
		imgRedDot2:setVisible(true)
	else
		imgRedDot2:setVisible(false)
	end
	--精彩推荐红点
	if CacheCenter.m_tWonderfulRedDotList and #CacheCenter.m_tWonderfulRedDotList > 0 then 
		imgRedDot3:setVisible(true)
	else
		imgRedDot3:setVisible(false)
	end

	local m_bIsShowRedDot5 = false  
	local m_bIsShowRedDot2 = false  
	if CacheCenter.m_tActivityItemRedDotList and #CacheCenter.m_tActivityItemRedDotList > 0 then
    	for idx=1,#CacheCenter.m_tActivityItemRedDotList do
    		-- WZLog("WndActivityIntegrate:setRedDot=============get RedDot List============="..idx..CacheCenter.m_tActivityItemRedDotList[idx])
    		local redDot = CacheCenter.m_tActivityItemRedDotList[idx]
            if redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE or redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN or redDot == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE then 
                m_bIsShowRedDot5 = true
            else
            	m_bIsShowRedDot2 = true
            end 
        end
    end
    if m_bIsShowRedDot5 == true then
    	imgRedDot5:setVisible(true)
    else
    	imgRedDot5:setVisible(false)
    end
    if m_bIsShowRedDot2 == true then
    	imgRedDot2:setVisible(true)
    else
    	imgRedDot2:setVisible(false)
    end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
