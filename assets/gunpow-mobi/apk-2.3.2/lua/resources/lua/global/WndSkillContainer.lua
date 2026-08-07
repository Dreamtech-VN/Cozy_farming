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
	local isFinish43, finishStep43 = TeachGroup1:isTeachFinish(43)
	if isFinish43 ~= true and finishStep43 > 0 and CacheCenter:getPlayerInfo().level == 23 then
        WindowManager:addTeachShelterLayer( 999999 )
    end
    self:_addTop()
end
function WndSkillContainer:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/bag_icon_jn.png", WndSkillContainer, WndSkillContainer.onCloseClick, false, false, false,nil,nil,true)
    self.m_root:addChild(celElement)

    self.m_tTopElement = celElement
    tNewObj:setTopType()
end
--@brief	关闭按钮回调事件
function WndSkillContainer:onCloseClick(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	TeachGroup1:endTeachStep({5,8})
	if CacheCenter:getPlayerInfo().level == 3 then 
		PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvClickBack)
	end

    self.m_root.m_sName = "WndSkillContainer"
    WindowManagerAni:createDisappearAction(self.m_root,"onDisappearActionCallback",self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSkillContainer:onExit(element)
	if self.skillInterfacePanel and next(self.skillInterfacePanel) ~= nil then
		for i,v in pairs(self.skillInterfacePanel) do
			if v then
				v:removeFromParentAndCleanup(true)
			end
		end
	end	 
	self:_unInit()
end

--@brief	创建窗口动画
function WndSkillContainer:onEnterTransitionDidFinish(element)
	WZLog("WndSkillContainer:onEnterTransitionDidFinish")
    WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end

--@brief	窗口动画完成回调
function WndSkillContainer:actionCallback(elem,data)
	self:_addDressSuit()
end

--@brief 	触摸开始回调
function WndSkillContainer:onTouchBegin(element, pt)
	-- body
	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
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
    local isEndTeach5, step5 = TeachGroup1:isTeachFinish(5)
	WZLog("WndSkillContainer:onDisappearActionCallback hhh", isEndTeach5, step5)	
    if isEndTeach5 ~= true and step5 >= 8 then 
    	if WndSingleCopy.m_root then 
    		if step5 == 8 then 
                TeachGroup1:startGroup({5, 9, WndSingleCopy.m_root})
            else
                TeachGroup1:startGroup({5, 10, WndSingleCopy.m_root})
            end
    	else
    		SceneCopy:showScene(1)
    	end
    end
end

--显示技能
function WndSkillContainer:onCheckSkill(element)
	WZLog("WndSkillContainer:onCheckSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self:_dealwithClickTab(nTag)
end

--显示道具
function WndSkillContainer:onCheckWeapon(element)
	WZLog("WndSkillContainer:onCheckWeapon")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self:_dealwithClickTab(nTag)

	TeachGroup1:endTeachStep({5,6})
	local isEndTeach5, step5 = TeachGroup1:isTeachFinish(5)
	WZLog("WndSkillContainer:onCheckWeapon", isEndTeach5, step5)
	if isEndTeach5 ~= true and step5 >= 6 then 
		WndSkillProp:onEdit() 
		PostPlayerEvent:postEvent(PostPlayerEvent.event_threeLvClickPropTab)
    	TeachGroup1:startGroup({5,7,WndSkillProp.m_root})
    end
end

--显示皮肤技能
function WndSkillContainer:onCheckSkin(element)
	WZLog("WndSkillContainer:onCheckSkin")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self:_dealwithClickTab(nTag)
end

--@brief 	点击辅助技能标签回调
function WndSkillContainer:onCheckAssist(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self:_dealwithClickTab(nTag)
end

--@brief 	点击"攻击特效"标签回调
function WndSkillContainer:onCheckExplosion(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	self:_dealwithClickTab(nTag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndSkillContainer:_initUI()
	WZLog("WndSkillContainer:_initUI=",self.m_nCheckIndex)
	local GetElement = GetElement
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
	local conWinSkillContainer = GetElement(self.m_root,"conWinSkillContainer",WZUIContainer)
	concbg:setCheckIndex(self.m_nCheckIndex-1)
	local child = nil
	local tag = 1

	if self.m_nLastTouchIndex and self.skillInterfacePanel[self.m_nLastTouchIndex] ~= nil then
		self.skillInterfacePanel[self.m_nLastTouchIndex]:removeFromParentAndCleanup(true)
		self.skillInterfacePanel[self.m_nLastTouchIndex] = nil
	end

	if self.skillInterfacePanel[self.m_nCheckIndex] == nil then
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
			WndSkinSkill:setType(1)
			tag = 3
		elseif self.m_nCheckIndex == 4 then
			child = WndSkinSkill:createElement()
			WndSkinSkill:setType(2)
			tag = 4
		elseif self.m_nCheckIndex == 5 then 
			child = WndAssistSkill:createElement()
			tag = 5
		elseif self.m_nCheckIndex == 6 then 
			child = WndSkillExplosion:createElement()
			tag = 6
		end
		if child then
			conWinSkillContainer:addChild(child,tag,tag)
			self.skillInterfacePanel[self.m_nCheckIndex] = child
		end
	end
	self.m_nLastTouchIndex = self.m_nCheckIndex


	local checkbox2 = GetElement(concbg,"checkbox2_WndSkillContainer",WZUICheckBox)
	local checkbox3 = GetElement(concbg,"checkbox3_WndSkillContainer",WZUICheckBox)
	local checkbox4 = GetElement(concbg,"checkbox4_WndSkillContainer",WZUICheckBox)
	local checkbox1 = GetElement(concbg,"checkbox1_WndSkillContainer",WZUICheckBox)
	local checkbox5 = GetElement(concbg,"checkbox5_WndSkillContainer",WZUICheckBox)
	local checkbox6 = GetElement(concbg,"checkbox6_WndSkillContainer",WZUICheckBox)

	local bSkinShow = true
	if CheckButtonShow(118) then
		checkbox3:setVisible(true)
		checkbox4:setVisible(true)
	else
		checkbox3:setVisible(false)
		checkbox4:setVisible(false)
		bSkinShow = false 
	end

	local bAssistShow = true
	if CheckButtonShow(ISLAND_ASSISTSKILL) then
		checkbox5:setVisible(true)
		if bSkinShow then 
			checkbox5:setRelativePosition(GlobalMethod:ccp(0.026,-0.08))
		else
			checkbox5:setRelativePosition(GlobalMethod:ccp(0.026,0.4))
		end
	else
		checkbox5:setVisible(false)
		bAssistShow = false
	end

	if CheckButtonShow(220) then
		checkbox6:setVisible(true)
		local tempPosY = -0.32
		if bSkinShow == false then
			tempPosY = tempPosY + 0.24 * 2
		end
		if bAssistShow == false then
			tempPosY = tempPosY + 0.24
		end
		checkbox6:setRelativePosition(GlobalMethod:ccp(0.026,tempPosY))
	else
		checkbox6:setVisible(false)
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

	local bShowRed = CacheCenter:getRedState("btnItem") or CacheCenter:getPropsRed()
	if bShowRed then
		imgRed2:setVisible(true)
	else
		imgRed2:setVisible(false)
	end

	self:setAssistSkillRed()
end

function WndSkillContainer:setSkillRed(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"imgRed1_WndSkillContainer",WZUIImage):setVisible(bool)
end

function WndSkillContainer:setPropsRed(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"imgRed2_WndSkillContainer",WZUIImage):setVisible(bool)
end

--@brief    添加时装套装入口
function WndSkillContainer:_addDressSuit()
    -- body
    if CheckButtonOpen(172, false) then
        local conForDressSuit = GetElement(self.m_root, "conForDressSuit_WndSkillContainer", WZUIContainer)
        if conForDressSuit then
            local wndDress, tCell = WndDressSuit:createElement()
            if wndDress and tCell then
                tCell:setType(8)
                self.m_tCellDressSuit = tCell
                conForDressSuit:addChild(wndDress)
            end
        end
    end
end

--@brief 	设置辅助技能标签红点
function WndSkillContainer:setAssistSkillRed()
	-- body
	if self.m_root == nil then return end
	local imgRed5 = GetElement(self.m_root, "imgRed5_WndSkillContainer", WZUIImage)
	local bAssistRed = CacheCenter:getAssistSkillRed()
	if bAssistRed then 
		imgRed5:setVisible(true)
	else
		imgRed5:setVisible(false)
	end
end

--@brief 	点击标签统一处理
function WndSkillContainer:_dealwithClickTab(nTag)
	-- body
	if not self:_bShow(nTag) then
		local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
		local concbg = GetElement(conWindow,"concbg_WndSkillContainer",WZUICheckBoxGroup)
		concbg:setCheckIndex(self.m_nCheckIndex-1)
    	return
    end
	self.m_nCheckIndex = nTag
	local conWindow = GetElement(self.m_root,"conWindow_WndSkillContainer",WZUIContainer)
	for i = 1, 6 do
		local childNode = conWindow:getChildByTag(i)
		if i == 3 and nTag == 4 then 
			if childNode then 
				childNode:removeFromParentAndCleanup(true)
			end
		elseif i == 4 and nTag == 3 then 
			if childNode then 
				childNode:removeFromParentAndCleanup(true)
			end
		end
		if nTag == i then
			if childNode then 
				if nTag == 1 or nTag == 2 then 
					childNode:removeFromParentAndCleanup(true)
					self:_initUI()
				else
					childNode:setVisible(true)
				end
			else
				self:_initUI()
			end
		else
			if childNode then 
				childNode:setVisible(false)
			end
		end 
	end

	if nTag == 3 or nTag == 4 or nTag == 5 or nTag == 6 then 
		GetElement(self.m_root, "conForDressSuit_WndSkillContainer", WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root, "conForDressSuit_WndSkillContainer", WZUIContainer):setVisible(true)
	end

	self:_bShowRed()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSkillContainer:_adaptLanguage_vn(  )
	for i=1,6 do
		local txtCheck = GetElement(self.m_root,"txtCheck"..i.."_WndSkillContainer",WZUILabelTTF)
		txtCheck:setScale(0.8)
		local txtCheckSel = GetElement(self.m_root,"txtCheckSel"..i.."_WndSkillContainer",WZUILabelTTF)
		txtCheckSel:setScale(0.8)
	end

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

function WndSkillContainer:_adaptLanguage_ug(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndSkillContainer",WZUILabelTTF)
	txtCheck1:setScale(0.7)
	txtCheck1:setDimensions(GlobalMethod:CCSize(120))
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndSkillContainer",WZUILabelTTF)
	txtCheckSel1:setScale(0.7)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(120))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndSkillContainer",WZUILabelTTF)
	txtCheck2:setScale(0.7)
	txtCheck2:setDimensions(GlobalMethod:CCSize(120))
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndSkillContainer",WZUILabelTTF)
	txtCheckSel2:setScale(0.7)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(120))
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndSkillContainer",WZUILabelTTF)
	txtCheck3:setScale(0.7)
	txtCheck3:setDimensions(GlobalMethod:CCSize(120))
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndSkillContainer",WZUILabelTTF)
	txtCheckSel3:setScale(0.7)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(120))
end
-------------------------------------语言适配End--------------------------------------------