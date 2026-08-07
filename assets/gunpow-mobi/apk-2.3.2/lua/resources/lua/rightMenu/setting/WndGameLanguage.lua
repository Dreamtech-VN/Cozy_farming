--WndGameLanguage.lua
--@brief	WndGameLanguage的UI模块
--@date		2016/06/20
--@author	zhangming
--@note		语言切换界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameLanguage:onEnter(element)
	WZLog("WndGameLanguage:onEnter")
	self.m_root = element
	self:setLanguage()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameLanguage:onExit(element)
	self:_unInit()
end


--@brief 根据所需语言来设置界面UI
function WndGameLanguage:setLanguage()
	local language = ProjConfig:getLanguageOpen()
	local post = {{0.26,0.764},{0.74,0.764},{0.26,0.596},{0.74,0.596}}
	WZLog("")
	for i= 1,#language do
		local element = nil
		if language[i] == "en" then
			element = GetElement(self.m_root,"conEn_WndGameLanguage",WZUIContainer)
		elseif language[i] == "th" then
			element = GetElement(self.m_root,"conTh_WndGameLanguage",WZUIContainer)
		elseif language[i] == "zh" then
			element = GetElement(self.m_root,"conZh_WndGameLanguage",WZUIContainer)
		elseif language[i] == "pt" then
			element = GetElement(self.m_root,"conPt_WndGameLanguage",WZUIContainer)
		elseif language[i] == "tr" then
			element = GetElement(self.m_root,"conTr_WndGameLanguage",WZUIContainer)
		elseif language[i] == "es" then
			element = GetElement(self.m_root,"conEs_WndGameLanguage",WZUIContainer)
		elseif language[i] == "hk" then
			element = GetElement(self.m_root,"conHk_WndGameLanguage",WZUIContainer)
		end
		if element ~= nil then
			element:setVisible(true)
			WZLog("WndGameLanguage:setLanguage:",i,post[i][1],post[i][2] )
			element:setRelativePosition(GlobalMethod:ccp(post[i][1],post[i][2]))
		end
	end
end

--@brief 选择语言的判断
function WndGameLanguage:onChoiceLan(element)
	WZLog("WndGameLanguage:onChoiceLan",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local lan = {"cn", "en", "th","pt","tr","es","hk"}
	self.m_curLanguage = lan[tag]
	local filePath = "ui/setting/commom_icon_"..self.m_curLanguage..".png"
	GetElement(self.m_root,"imgLan_WndGameLanguage",WZUIImage):setFile(filePath)
	local con = GetElement(self.m_root,"conChange_WndGameLanguage",WZUIContainer)
	con:setVisible(true)
	 WindowManagerAni:createAction(con,true)
end

--@brief 关闭
function WndGameLanguage:onBtnClose(element)
	WZLog("WndGameLanguage:onBtnClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 确定选择语言
function WndGameLanguage:onBtnConfirm(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if ProjConfig.LANGUAGE ~= self.m_curLanguage then
		local data = WZDataFile:getInstance():getUserData()
		if data then		
			data:setStringValue("LanguageData", "language", self.m_curLanguage)
			data:flush()
			KEngineReloadAll()
			return
		end
	end
	local con = GetElement(self.m_root,"conChange_WndGameLanguage",WZUIContainer)
	local blackImg = WZUIImage:luaTo(con:getChildByTag(9876))
	blackImg:removeFromParentAndCleanup(true)
	con:setVisible(false)
end

--@brief 取消选择语言
function WndGameLanguage:onBtnBack(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = GetElement(self.m_root,"conChange_WndGameLanguage",WZUIContainer)
	local blackImg = WZUIImage:luaTo(con:getChildByTag(9876))
	blackImg:removeFromParentAndCleanup(true)
	con:setVisible(false)
	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndGameLanguage:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtChange_WndGameLanguage",WZUILabelTTF):setScale(0.6)
end

function WndGameLanguage:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtChange_WndGameLanguage",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(380,0))
end

function WndGameLanguage:_adaptLanguage_en(  )
	local txtChange = GetElement(self.m_root,"txtChange_WndGameLanguage",WZUILabelTTF)
	txtChange:setDimensions(GlobalMethod:CCSize(380,0))
end

function WndGameLanguage:_adaptLanguage_es(  )
	local txtChange = GetElement(self.m_root,"txtChange_WndGameLanguage",WZUILabelTTF)
	txtChange:setDimensions(GlobalMethod:CCSize(300,0))
end
-------------------------------------语言适配End----------------------------------------