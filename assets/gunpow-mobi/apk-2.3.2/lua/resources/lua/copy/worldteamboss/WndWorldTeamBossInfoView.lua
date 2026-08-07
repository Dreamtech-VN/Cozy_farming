--WndWorldTeamBossInfoView.lua
--@brief	WndWorldTeamBossInfoView的UI模块
--@date		2018/07/20
--@author	Tianxiang_Xu
--@note		世界组队boss战斗信息展示界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldTeamBossInfoView:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldTeamBossInfoView:onExit(element)
	self:_unInit()
end

--@brief 	界面加载回调
function WndWorldTeamBossInfoView:onEnterTransitionDidFinish(element)
	-- body
	local tConfig = CacheCenter:getGameParam().teamWorldBossConfig
	self.m_tSysConfig = json.decode(tConfig)

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndWorldTeamBossInfoView:_update()
	-- body
	self:_setStaticText()
	self:_setHurtValue()
end

--@brief 	设置静态文本
function WndWorldTeamBossInfoView:_setStaticText()
	-- body
	local txtTeam = GetElement(self.m_root, "txtTeam_WndWorldTeamBossInfoView", WZUILabelTTF)
	if txtTeam then
		txtTeam:setText(LocalStrings.TEAMBOSS_TEXT8 .. ":")
	end
	local txtMy = GetElement(self.m_root, "txtMy_WndWorldTeamBossInfoView", WZUILabelTTF)
	if txtMy then
		txtMy:setText(LocalStrings.TEAMBOSS_TEXT9 .. ":")
	end
	local txtRoundWord = GetElement(self.m_root, "txtRoundWord_WndWorldTeamBossInfoView", WZUILabelTTF)
	if txtRoundWord then
		txtRoundWord:setText(LocalStrings.TEAMBOSS_TEXT24)
	end
end

--@brief	设置伤害值
function WndWorldTeamBossInfoView:_setHurtValue()
	-- body
	--队伍伤害
	local txtTeamHurt = GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	local nMaxBlood = WBattleGlobal:getCurrent().m_tMakePairOk.guaiMaxHP[1]
	WZLog("WndWorldTeamBossInfoView:_setHurtValue", self.m_nTeamHurt, nMaxBlood)
	if txtTeamHurt then
		local teamPercent = string.format("%0.2f", (self.m_nTeamHurt/nMaxBlood*100))
    	teamPercent = "(" .. teamPercent .. "%" .. ")"
		txtTeamHurt:setText(self.m_nTeamHurt .. teamPercent)
	end
	--我的伤害
	local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	if txtMyHurt then
		if self.m_nTeamHurt > 0 then 
			local myPercent = string.format("%0.2f", (self.m_nMyHurt/self.m_nTeamHurt*100))
	    	myPercent = "(" .. myPercent .. "%" .. ")"
			txtMyHurt:setText(self.m_nMyHurt .. myPercent)
		else
			local myPercent = "(" .. 0 .. "%" .. ")"
			txtMyHurt:setText(self.m_nMyHurt .. myPercent)
		end
	end
	--剩余回合数
	self:setRoundNum(self.m_nCurRound)
end

--@brief	
function WndWorldTeamBossInfoView:setRoundNum(curRound)
	-- body
	if self.m_root == nil then return end 
	self.m_nCurRound = curRound
	--剩余回合数
	local txtRoundNum = GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF)
	if txtRoundNum then
		txtRoundNum:setText((self.m_tSysConfig.maxRound-curRound) .. "/" .. self.m_tSysConfig.maxRound)
	end
end

--@brief 	适配iphoneX
function WndWorldTeamBossInfoView:_adaptIphoneX()
	if IsIphoneX() then 
		GetElement(self.m_root, "conTop_WndWorldTeamBossInfoView", WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.15, 0.5))
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndWorldTeamBossInfoView:_adaptLanguage_vn(  )
	GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.52,0.82))
	GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.56))
	GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.3))
end

function WndWorldTeamBossInfoView:_adaptLanguage_en(  )
	local txtTeam = GetElement(self.m_root, "txtTeam_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setRelativePosition(GlobalMethod:ccp(0.05,0.82))
	local txtTeamHurt = GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeamHurt:setScale(0.8)
	txtTeamHurt:setRelativePosition(GlobalMethod:ccp(0.48,0.82))
	local txtMy = GetElement(self.m_root, "txtMy_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMy:setScale(0.8)
	txtMy:setRelativePosition(GlobalMethod:ccp(0.05,0.56))
	local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMyHurt:setScale(0.8)
	txtMyHurt:setRelativePosition(GlobalMethod:ccp(0.48,0.56))
	local txtRoundWord = GetElement(self.m_root, "txtRoundWord_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundWord:setScale(0.8)
	txtRoundWord:setRelativePosition(GlobalMethod:ccp(0.05,0.3))
	local txtRoundNum = GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundNum:setScale(0.8)
	txtRoundNum:setRelativePosition(GlobalMethod:ccp(0.48,0.3))
end

function WndWorldTeamBossInfoView:_adaptLanguage_pt(  )
	local txtTeam = GetElement(self.m_root, "txtTeam_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setRelativePosition(GlobalMethod:ccp(0.05,0.82))
	local txtTeamHurt = GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeamHurt:setScale(0.8)
	txtTeamHurt:setRelativePosition(GlobalMethod:ccp(0.459259,0.82))
	local txtMy = GetElement(self.m_root, "txtMy_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMy:setScale(0.8)
	txtMy:setRelativePosition(GlobalMethod:ccp(0.05,0.56))
	local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMyHurt:setScale(0.8)
	txtMyHurt:setRelativePosition(GlobalMethod:ccp(0.340741,0.56))
	local txtRoundWord = GetElement(self.m_root, "txtRoundWord_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundWord:setScale(0.8)
	txtRoundWord:setRelativePosition(GlobalMethod:ccp(0.05,0.3))
	local txtRoundNum = GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundNum:setScale(0.8)
	txtRoundNum:setRelativePosition(GlobalMethod:ccp(0.531852,0.3))
end

function WndWorldTeamBossInfoView:_adaptLanguage_es(  )
	local txtTeam = GetElement(self.m_root, "txtTeam_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setRelativePosition(GlobalMethod:ccp(0.05,0.82))
	local txtTeamHurt = GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeamHurt:setScale(0.8)
	txtTeamHurt:setRelativePosition(GlobalMethod:ccp(0.474074,0.82))
	local txtMy = GetElement(self.m_root, "txtMy_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMy:setScale(0.8)
	txtMy:setRelativePosition(GlobalMethod:ccp(0.05,0.56))
	local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMyHurt:setScale(0.8)
	txtMyHurt:setRelativePosition(GlobalMethod:ccp(0.292593,0.56))
	local txtRoundWord = GetElement(self.m_root, "txtRoundWord_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundWord:setScale(0.8)
	txtRoundWord:setRelativePosition(GlobalMethod:ccp(0.05,0.3))
	local txtRoundNum = GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundNum:setScale(0.8)
	txtRoundNum:setRelativePosition(GlobalMethod:ccp(0.531852,0.3))
end

function WndWorldTeamBossInfoView:_adaptLanguage_tr(  )
	local txtTeam = GetElement(self.m_root, "txtTeam_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeam:setRelativePosition(GlobalMethod:ccp(0.05,0.82))
	local txtTeamHurt = GetElement(self.m_root, "txtTeamHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtTeamHurt:setRelativePosition(GlobalMethod:ccp(0.5,0.82))
	local txtMy = GetElement(self.m_root, "txtMy_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMy:setRelativePosition(GlobalMethod:ccp(0.05,0.56))
	local txtMyHurt = GetElement(self.m_root, "txtMyHurt_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtMyHurt:setRelativePosition(GlobalMethod:ccp(0.36,0.56))
	local txtRoundWord = GetElement(self.m_root, "txtRoundWord_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundWord:setRelativePosition(GlobalMethod:ccp(0.05,0.3))
	local txtRoundNum = GetElement(self.m_root, "txtRoundNum_WndWorldTeamBossInfoView", WZUILabelTTF)
	txtRoundNum:setRelativePosition(GlobalMethod:ccp(0.37,0.3))
end
-------------------------------------语言适配End----------------------------------------
