--WndAscendingTip.lua
--@brief	WndAscendingTip的UI模块
--@date		2016/09/14
--@author	zsq
--@note		调品确认框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAscendingTip:onEnter(element)
	self.m_root = element
end

--@brief	加载动画
function WndAscendingTip:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"cost",WZUILabelTTF):setText(CacheCenter:getGameParam().keepOldGradeCostDiamond)
    AdaptLanguage(self)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	加载动画完
function WndAscendingTip:actionCallback()
	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndAscenddingTip", WZUIImage)
	if imgCostIcon then
		if CacheCenter:getGameParam().isUseTicket == "0" then
			imgCostIcon:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon:setScale(0.45)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAscendingTip:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndAscendingTip:onCancel()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndGradeStrengthen:updateLucky(WndGradeStrengthen.m_tEquipBefore)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndAscendingTip:onConfirm()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndGradeStrengthen.m_bUpdateLucky = true
	local cost = tonumber(CacheCenter:getGameParam().keepOldGradeCostDiamond)
	if CacheCenter:getGameParam().isUseTicket == "0" then
		if not JudgeMoneyIsEnough(70, cost, nil, nil, Chat_Channel_WndAscending_Tab2, nil, nil, nil, nil, self, self.clickSureMoney) then
			return 
		end
	else
		if not JudgeMoneyIsEnough(1, cost, nil, nil, Chat_Channel_WndAscending_Tab2, nil, nil, nil, nil, self, self.clickSureMoney) then
			return 
		end
	end

	self:clickSureMoney()
end

--@brief	确定用钻石代替礼券保持原品质
function WndAscendingTip:clickSureMoney()
	if WndAscending.m_root ~= nil then
		ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade(WndAscending.m_tEquipBefore.playerItemId, true )
	elseif WndGradeStrengthen.m_root ~= nil then
		ProtocolProcessorWndAscending:send_ADVANCED_KeepOldGrade(WndGradeStrengthen.m_tEquipBefore.playerItemId, true )
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin---------------------------------------
function WndAscendingTip:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtCancel_WndConfirmBox",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtConfirm_WndConfirmBox",WZUILabelTTF):setScale(0.8)
end

function WndAscendingTip:_adaptLanguage_tr(  )
	local txtCost = GetElement(self.m_root,"txtCost_WndAscendingTip",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.19,0.5))
end

function WndAscendingTip:_adaptLanguage_es(  )
	local txtCancel = GetElement(self.m_root,"txtCancel_WndConfirmBox",WZUILabelTTF)
	txtCancel:setDimensions(GlobalMethod:CCSize(130,0))
	txtCancel:setScale(0.7)

	local txtConfirm = GetElement(self.m_root,"txtConfirm_WndConfirmBox",WZUILabelTTF)
	txtConfirm:setDimensions(GlobalMethod:CCSize(150,0))
	txtConfirm:setScale(0.7)

	local txtCost = GetElement(self.m_root,"txtCost_WndAscendingTip",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
end
------------------------------------语言适配End----------------------------------------