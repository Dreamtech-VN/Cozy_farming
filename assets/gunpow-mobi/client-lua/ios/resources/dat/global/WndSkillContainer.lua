--WndSkillContainer.lua
--@brief	WndSkillContainer的UI模块
--@date		2017/05/15
--@author	 
--@note		技能容器


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSkillContainer:onEnter(element)
	self.m_root = element
	self:_initUI()
	AdaptLanguage(self)

	local isFinish37, finishStep37 = TeachGroup1:isTeachFinish(37)
	local isFinish43, finishStep43 = TeachGroup1:isTeachFinish(43)
	if isFinish37 ~= true and finishStep37 > 0 and CacheCenter:getPlayerInfo().level == 12 or 
		isFinish43 ~= true and finishStep43 > 0 and CacheCenter:getPlayerInfo().level == 24 then
        WindowManager:addTeachShelterLayer( 999999 )
    end

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSkillContainer:onExit(element)
	self:_unInit()
end

--@brief	创建窗口动画
function WndSkillContainer:onEnterTransitionDidFinish(element)
	WZLog("WndSkillContainer:onEnterTransitionDidFinish")
    WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end

--@brief	窗口动画完成回调
function WndSkillContainer:actionCallback(elem,data)
	TeachGroup1:startGroup({37,3,WndSkillContainer.m_root})
	--TeachGroup1:startGroup({43,3,WndSkillContainer.m_root})
end

--@brief	关闭回调
function WndSkillContainer:onClose()
	WZLog("WndSkillContainer:onClose")
	self.m_root.m_sName = "WndSkillContainer"
    WindowManagerAni:createDisappearAction(self.m_root,"onDisappearActionCallback",self)
end

--@brief	窗口动画关闭完成回调
function WndSkillContainer:onDisappearActionCallback(elem,data)
	WZLog("WndSkillContainer:onDisappearActionCallback")	
    WindowManager:removeWindow(self.m_root , WndSkillContainer , true)
end

--显示技能
function WndSkillContainer:onCheckSkill(element)
	WZLog("WndSkillContainer:onCheckSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	self.m_nCheckIndex = 1
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local childNode1 = conWindow:getChildByTag(1)
	local childNode2 = conWindow:getChildByTag(2)
	local childNode3 = conWindow:getChildByTag(3)
	if childNode1 then
		childNode1:removeFromParentAndCleanup(true)
		self:_initUI()
	else
		self:_initUI()
	end

	if childNode2 then
		childNode2:setVisible(false)
	end

	if childNode3 then
		childNode3:setVisible(false)
	end
	self:_bShowRed()
end

--显示道具
function WndSkillContainer:onCheckWeapon(element)
	WZLog("WndSkillContainer:onCheckWeapon")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if not self:_bShow(2) then
    	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
		local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
		concbg:setCheckIndex(self.m_nCheckIndex-1)
    	return
    end

	self.m_nCheckIndex = 2
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local childNode1 = conWindow:getChildByTag(1)
	local childNode2 = conWindow:getChildByTag(2)
	local childNode3 = conWindow:getChildByTag(3)
	if childNode1 then
		childNode1:setVisible(false)
	end
	if childNode2 then
		childNode2:removeFromParentAndCleanup(true)
		self:_initUI()
    else
		self:_initUI()
	end
	if childNode3 then
		childNode3:setVisible(false)
	end
	self:_bShowRed()
	TeachGroup1:endTeachStep({5,6},{37,3})
	TeachGroup1:startGroup({37,4,WndSophistic.m_root})
    TeachGroup1:startGroup({5,7,WndSkillProp.m_root})

end

--显示皮肤技能
function WndSkillContainer:onCheckSkin(element)
	WZLog("WndSkillContainer:onCheckSkin")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if not self:_bShow(3) then
		local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
		local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
		concbg:setCheckIndex(self.m_nCheckIndex-1)
    	return
    end
	self.m_nCheckIndex = 3
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local childNode1 = conWindow:getChildByTag(1)
	local childNode2 = conWindow:getChildByTag(2)
	local childNode3 = conWindow:getChildByTag(3)
	if childNode1 then
		childNode1:setVisible(false)
	end
	if childNode2 then
		childNode2:setVisible(false)
	end

	if childNode3 then
		childNode3:setVisible(true)
	else
		self:_initUI()
	end
	self:_bShowRed()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndSkillContainer:_initUI()
	WZLog("WndSkillContainer:_initUI=",self.m_nCheckIndex)
	local GetElement = GetElement
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
	concbg:setCheckIndex(self.m_nCheckIndex-1)
	local child = nil
	local tag = 1
	if self.m_nCheckIndex == 1 then
		child = WndSkillProp:createElement()
		WndSkillProp.m_nWinType = 1
		tag = 1
	elseif self.m_nCheckIndex == 2 then
		child = WndSkillProp:createElement()
		WndSkillProp.m_nWinType = 2
		tag = 2
	elseif self.m_nCheckIndex == 3 then
		child = WndSkinSkill:createElement()
		tag = 3
	end
	if child then
		conWindow:addChild(child,tag,tag)
	end

	local checkbox2 = GetElement(concbg,"checkbox2_WndSkillContainer",WZUICheckBox)
	local checkbox3 = GetElement(concbg,"checkbox3_WndSkillContainer",WZUICheckBox)
	local checkbox1 = GetElement(concbg,"checkbox1_WndSkillContainer",WZUICheckBox)

	if CheckButtonShow(118) then
		checkbox3:setVisible(true)
	else
		checkbox3:setVisible(false)
	end

	self:_bShowRed()
end

--是否显示红点
function WndSkillContainer:_bShowRed()
	if self.m_root == nil then return end
	WZLog("WndSkillContainer:_bShowRed")
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
	local checkbox3 = GetElement(concbg,"checkbox3_WndSkillContainer",WZUICheckBox)
	local checkbox1 = GetElement(concbg,"checkbox1_WndSkillContainer",WZUICheckBox)
	local checkbox2 = GetElement(concbg,"checkbox2_WndSkillContainer",WZUICheckBox)
	local imgRed3 = GetElement(checkbox3,"imgRed_WndSkillContainer",WZUIImage)
	local imgRed2 = GetElement(checkbox2,"imgRed2_WndSkillContainer",WZUIImage)
	if self.m_nCheckIndex ~= 3 then
		local bShowRed = CacheCenter:getRedState("btnPractice_ExtendUp")
		if bShowRed then
			imgRed3:setVisible(true)
		else
			imgRed3:setVisible(false)
		end
		imgRed3:setVisible(false)
	else
		imgRed3:setVisible(false)
	end

	local bShowRed = CacheCenter:getRedState("btnItem")
	if bShowRed then
		imgRed2:setVisible(true)
	else
		imgRed2:setVisible(false)
	end
end

function WndSkillContainer:setSkillRed(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"imgRed1_WndSkillContainer",WZUIImage):setVisible(bool)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSkillContainer:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF):setFontSize(20)
end

function WndSkillContainer:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF):setFontSize(17)
	GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF):setFontSize(17)

	GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF):setFontSize(20)
end

function WndSkillContainer:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF):setFontSize(20)
end

function WndSkillContainer:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF):setFontSize(20)
end

function WndSkillContainer:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF):setFontSize(16)
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF)
	txtCheck3:setScale(0.6)
	txtCheck3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF)
	txtCheckSel3:setScale(0.6)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(140))
end

function WndSkillContainer:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF):setFontSize(20)	
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF)
	txtCheck3:setScale(0.6)
	txtCheck3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF)
	txtCheckSel3:setScale(0.6)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(140))
end

function WndSkillContainer:_adaptLanguage_tr(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF)
	txtCheck1:setFontSize(18)
	txtCheck1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF)
	txtCheckSel1:setFontSize(18)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF)
	txtCheck2:setFontSize(18)
	txtCheck2:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF)
	txtCheckSel2:setFontSize(18)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(90))
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF)
	txtCheck3:setFontSize(18)
	txtCheck3:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF)
	txtCheckSel3:setFontSize(18)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(90))
end

function WndSkillContainer:_adaptLanguage_th(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF)
	txtCheck1:setFontSize(18)
	txtCheck1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF)
	txtCheckSel1:setFontSize(18)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF)
	txtCheck2:setFontSize(18)
	txtCheck2:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF)
	txtCheckSel2:setFontSize(18)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(90))
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF)
	txtCheck3:setFontSize(18)
	txtCheck3:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF)
	txtCheckSel3:setFontSize(18)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(90))
end
-------------------------------------语言适配End--------------------------------------------