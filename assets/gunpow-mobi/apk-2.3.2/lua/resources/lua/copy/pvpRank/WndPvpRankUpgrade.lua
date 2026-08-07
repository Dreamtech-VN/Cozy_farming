--WndPvpRankUpgrade.lua
--@brief	WndPvpRankUpgrade的UI模块
--@date		2015/11/16
--@author	zhangming
--@note		排位赛等级提升界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpRankUpgrade:onEnter(element)
	self.m_root = element
	self.dtTime = 0
	self:_updatePlayerPro()
	self.m_root:enableSchedule("onSchedule",0.25)
	SoundManager:playEffectSound(SoundDefine.E_MUSIC_ISUPGRADE)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpRankUpgrade:onExit(element)
	self:_unInit()
end

--@brief	加载动画_scaleValueImg
function WndPvpRankUpgrade:onEnterTransitionDidFinish(element)
	upPlayerFightingAni(GlobalGame.g_tInfo.nFighting)
	WindowManagerAni:createAction(element,true)
end

function WndPvpRankUpgrade:onSchedule(element, dt)
	self.dtTime = self.dtTime + 0.95
	if self.dtTime > 0.75 then
		WZLog("WndPvpRankUpgrade:onSchedule" )
		local spine = GetElement(self.m_root, "spine1_WndPvpRankUpgrade", WZUISpine)
		spine:play("paiwei", false)
		spine:setVisible(true)
		spine:enableSchedule("_onUpEnd")
		GetElement(self.m_root,"conValue0_WndPvpRankUpgrade",WZUIContainer):setVisible(true)
		local actionArray = CCArray:create()
     	actionArray:addObject(CCScaleTo:create(0.15,1,1))
     	actionArray:addObject(CCCallFuncN:create(WndPvpRankUpgrade._scaleValueImg))
     	local repH = CCSequence:create(actionArray)
     	local curTenImg = GetElement(self.m_root,"conValue0_WndPvpRankUpgrade",WZUIContainer)
	 	curTenImg:runAction(repH)
		element:disableSchedule()
	end
end

--@brief	更新玩家属性
function WndPvpRankUpgrade:_updatePlayerPro()
	WZLog("WndPvpRankUpgrade:_updatePlayerPro" )
	--更新属性列表
	local lv = CacheCenter:getPlayerInfo().segmentLevel
	WZLog("WndPvpRankUpgrade:_updatePlayerPro:",lv)
	local lv2 = GlobalGame.g_tPlayerInfo.nPvpRankLevel
	GlobalGame.g_tPlayerInfo.nPvpRankLevel = lv
	WZLog("WndPvpRankUpgrade:_updatePlayerPro:",lv2, self.t_date)
	local tab = GDatatab_rank_segment["id_"..lv2]
	local tab2 = GDatatab_rank_segment["id_"..lv]
	GetElement(self.m_root,"txtLv1_WndPvpRankUpgrade",WZUILabelAtlasFont):setText(tab.iocn_level)
	GetElement(self.m_root,"txtLv2_WndPvpRankUpgrade",WZUILabelAtlasFont):setText(tab2.iocn_level)
	GetElement(self.m_root,"imgLv1_WndPvpRankUpgrade",WZUIImage):setFile("ui/common/"..tab.iocn..".png")
	GetElement(self.m_root,"imgLv2_WndPvpRankUpgrade",WZUIImage):setFile("ui/common/"..tab2.iocn..".png")
	GetElement(self.m_root,"txtName1_WndPvpRankUpgrade",WZUILabelTTF):setText(tab.name)
	GetElement(self.m_root,"txtName2_WndPvpRankUpgrade",WZUILabelTTF):setText(tab2.name)
	local curData2 = self:_getProData(tab.property)
	local curData = self:_getProData(tab2.property)
	curData.hp = curData.hp - curData2.hp
	curData.attack = curData.attack - curData2.attack
	curData.defend = curData.defend - curData2.defend
	local s1 = {LocalStrings.SHOP_LIFT,LocalStrings.SHOP_GONGJI,LocalStrings.SHOP_DEFEND}
	local s2 = {"+"..curData.hp, "+"..curData.attack, "+"..curData.defend}
	local sLevel = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[1], s2[1])
	local text1 = GetElement(self.m_root,"textValue0_WndPvpRankUpgrade",WZUIFreeTextBox)
	text1:setShowText(sLevel)
	local sHp = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[2], s2[2])
	local text2 = GetElement(self.m_root,"textValue1_WndPvpRankUpgrade",WZUIFreeTextBox)
	text2:setShowText(sHp)
	local sAttack = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[3], s2[3])
	local text3 = GetElement(self.m_root,"textValue2_WndPvpRankUpgrade",WZUIFreeTextBox)
	text3:setShowText(sAttack)
	-- local sDefend = string.format([[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T><T C="0,255,0" S="22" P="0">%s</T>]],s1[4], s2[4], s3[4])
	-- local text4 = GetElement(self.m_root,"textValue3_WndPvpRankUpgrade",WZUIFreeTextBox)
	-- text4:setShowText(sDefend)
	-- text4:setScale(0)
	--初始化新功能并设置为不可见
	GetElement(self.m_root,"txtNext_WndPvpRankUpgrade",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"conIcon_WndPvpRankUpgrade",WZUIContainer):setScale(0)
	for i=0, 2 do
		WZLog("WWW:",i)
		local element = GetElement(self.m_root,"conValue"..i.."_WndPvpRankUpgrade",WZUIContainer)
		element:setScale(0)
		element:setVisible(true)
	end
	self.n_actionTag = 0
end


--@brief	点击继续游戏按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpRankUpgrade:onContinue(element)
    WZLog("WndPvpRankUpgrade:onContinue")
    if self.b_isOver then
    	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end
end

function WndPvpRankUpgrade:onCloseActionCallback(element,data) 
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif 清除数据
function WndPvpRankUpgrade:_onUpEnd(element)
	WZLog("WndPvpRankUpgrade:onUpEnd:", element, event)
	local spine = WZUISpine:luaTo(element)
	if spine:isCurrentAnimationDone() then
		element:disableSchedule()
		spine:play("paiwei_chixu", true)
	end	
end


function WndPvpRankUpgrade:_scaleValueImg()
	local num = WndPvpRankUpgrade.n_actionTag
	local time = 0.15
    local curTenImg = ""
     WndPvpRankUpgrade.n_actionTag = WndPvpRankUpgrade.n_actionTag + 1
     if WndPvpRankUpgrade.n_actionTag > 3 then
     	time = 0.4
     	curTenImg = GetElement(WndPvpRankUpgrade.m_root,"conIcon_WndPvpRankUpgrade",WZUIContainer)
     else
     	curTenImg = GetElement(WndPvpRankUpgrade.m_root,"conValue"..num.."_WndPvpRankUpgrade",WZUIContainer)
     end
     if WndPvpRankUpgrade.n_actionTag > 4 then
     	WndPvpRankUpgrade:_setBackState()
     	return
     end
     local actionArray = CCArray:create()
     actionArray:addObject(CCScaleTo:create(time,1.0,1.0))
     actionArray:addObject(CCCallFuncN:create(WndPvpRankUpgrade._scaleValueImg))
     local repH = CCSequence:create(actionArray)
	 curTenImg:runAction(repH)
end

function WndPvpRankUpgrade:_getProData(tProperty)
	local tData = {}
	tData.hp = 0
	tData.attack = 0
	tData.defend = 0
	for i,data in pairs(tProperty) do 
		local value = data
		local value2 = 0
		if type(data) == "table" then
			value = data[2]
			value2 = data[1]
		end
		if tonumber(value2) == tonumber(PRO_HP) then
			tData.hp = value
		elseif tonumber(value2) == tonumber(PRO_ATTACK) then
			tData.attack = value
		elseif tonumber(value2) == tonumber(PRO_DEFEND) then
			tData.defend = value
		end
	end	
	return tData
end


function WndPvpRankUpgrade:_setBackState()
	self.b_isOver = true
	GetElement(self.m_root,"txtNext_WndPvpRankUpgrade",WZUILabelTTF):setVisible(true)
end



-------------------------------------私有方法模块End----------------------------------------


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
