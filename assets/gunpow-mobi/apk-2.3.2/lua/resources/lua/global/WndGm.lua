--WndGm.lua
--@brief	WndGm的UI模块
--@date		2021/01/15
--@author	hyx
--@note		GM界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGm:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGm:onExit(element)
	self:_unInit()
end

function WndGm:showInter(frame)
	local wndGm = WndGm:createElement()
    if wndGm then
    	-- local zOrder = 10000
    	-- if LOG_MYSELF then
    	-- 	zOrder = 99999999
    	-- end
        frame:addChild(wndGm,99999999)
    end
end

function WndGm:onEnterTransitionDidFinish(element)
	self.m_sMoreListContainer = GetElement(self.m_root,"moreListContainer_WndGm",WZUIContainer)
end

--@brief    创建按钮
function WndGm:_createBtn(btnText, func)
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(104,44))

	local btn = WZUIButton:create()
	local imgNor = WZUI9Image:create()
	imgNor:setFile("ui/common/common_btn_05.png")
	local imgSel = WZUI9Image:create()
	imgSel:setFile("ui/common/common_btn_05.png")
	btn:setNormalElement(imgNor)
	btn:setSelectElement(imgSel)
	btn:setLuaDoneFunctionName(func)
	con:addChild(btn)
	local txt = WZUILabelTTF:create()
	txt:setFontSize(18)
	txt:setColor(GlobalMethod:ccc3(127,70,26))
	txt:setTouchEnable(false)
	txt:setText(btnText)
	txt:setTag(888)
	btn:addChild(txt)
	return con
end

function WndGm:onBtnRule()
	WndSingleMapDesc:showInterface(LocalStrings.GM_EXPLAIN)
end
function WndGm:onBtnGmList()
    if next(self.m_tGmData) == nil then
	   ProtocolProcessorWndTask:send_PLAYER_TrainerList()
	end
	if self.m_sMoreListContainer then
		if self.m_sMoreListContainer:isVisible() == true then
			self.m_sMoreListContainer:setVisible(false)
		else
			self.m_sMoreListContainer:setVisible(true)
		end
	end
end

function WndGm:setGmView()
	local moreList_WndGm = GetElement(self.m_root,"moreList_WndGm",WZUITableContainer)
	moreList_WndGm:cleanTable()
	for i = 1, #self.m_tGmData do
		local element, tLuaObj = CellGMItem:createElement()
		element:setTag(i - 1)
        moreList_WndGm:setCellElement(element)
        tLuaObj:setCellGMMessage(self.m_tGmData[i],function(title,text)
        	self:setCellItemText(title,text)
    	end)
    end
end
function WndGm:setButtonGmView()
	local quickTable = GetElement(self.m_root,"quickTable",WZUITableContainer)
	quickTable:cleanTable()
	local tab_list = {"quickSendType"}
	for i = 1, #self.m_tButtonGmData do
        local con = self:_createBtn(self.m_tButtonGmData[i], tab_list[1])
        if con then
            con:setTag(i - 1)
            quickTable:setCellElement(con)
        end
    end

end
function WndGm:setCellItemText(title,text)
	if text ~= "" then
		ProtocolProcessorWndTask:send_PLAYER_Trainer(title..","..text)
	end
end
function WndGm:onEditReceivEndGm()
	local gm_edit = GetElement(self.m_root,"editGm_WndGm",WZUIEditBox)
	local text = gm_edit:getText()
	if text ~= "" then
		if string.find( text, "#" ) ~= nil then
			local str = string.sub(text, 2, string.len(text))
			CCDirector:sharedDirector():getScheduler():setTimeScale(tonumber(str))
		elseif text == "fps" then
			if not temp_CC_SHOW_FPS then
				temp_CC_SHOW_FPS = true
				CC_SHOW_FPS = true
			end
            CC_SHOW_FPS = not CC_SHOW_FPS
            CCDirector:sharedDirector():setDisplayStats(CC_SHOW_FPS)
        elseif text == "断网" then
        	-- NetManager:pcb_Disconnect()
        	SceneLogin:LinkokToLoginokTimerCall()
		else
			ProtocolProcessorWndTask:send_PLAYER_Trainer(text)
		end
	end
end

--快捷模式
function WndGm:quickSendType(element)
	local str = WZUILabelTTF:luaTo(element:getChildByTag(888)):getText()
	if str == "隐藏按钮" then
		local btnGM = GetElement(self.m_root,"btnGM",WZUIButton)
		if btnGM then
			btnGM:setVisible(false)
			self.m_sMoreListContainer:setVisible(false)
			GetElement(self.m_root,"editContainer",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"btnStoreRating", WZUIButton):setVisible(false)
		end
	elseif str == "跳过新手" then
		ProtocolProcessorWndTask:send_PLAYER_Trainer("新手,0,-1")
		g_bIsFirstBattleEnd = true
	    TeachGroup1:setTeachFinish(0,-1)
	    TeachGroup1.ISNOTEACH = true
	    TeachGroup1:endFirstBattleTeach()
	elseif str == "设等级" then
		ProtocolProcessorWndTask:send_PLAYER_Trainer("等级,50")
	else
		ProtocolProcessorWndTask:send_PLAYER_Trainer(tostring(str))
	end
end

--@brief 	越南商店评分
function WndGm:onBtnRating(element)
	ShowStoreRating()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
