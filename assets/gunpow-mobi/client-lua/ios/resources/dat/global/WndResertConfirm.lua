--WndResertConfirm.lua
--@brief	WndResertConfirm的UI模块
--@date		2015/07/31
--@author	qixiang_xie
--@note		重置确认框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndResertConfirm:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief  显示重置确认框
function WndResertConfirm:showConfirmCancelBox(cost,level,tCallbackLuaObj,fCallbackFunc)
	if self.m_root == nil then
		self.m_root = self:createElement()
		--self.m_root = WZUIContainer:luaTo(self.m_root)
	end
    WindowManager:addWindow(self.m_root,self,true,nil,nil,true)

    local costCount = cost[1][2]
	local txtCostCount = GetElement(self.m_root,"txtCostCount_WndResertConfirm",WZUILabelTTF)
	txtCostCount:setText(costCount)
	--
	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndResertConfirm", WZUIImage)
	if imgCostIcon then
		imgCostIcon:setFile(GDatatab_item["id_" .. cost[1][1]].icon)
		imgCostIcon:setScale(0.5)
	end
	 
	if self.m_tMsgData == nil then
		self.m_tMsgData= {}
	end
	self.m_tMsgData.callbackLuaObj = tCallbackLuaObj
	self.m_tMsgData.callbackFunc = fCallbackFunc
	self.m_tMsgData.cost = cost
	local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
	if level == 0 then
		txtResertRemind:setShowText(string.format(LocalStrings.CURRENT_LEVEL2 ,LocalStrings.START_LEVEL))
	else
		txtResertRemind:setShowText(string.format(LocalStrings.CURRENT_LEVEL ,level))
	end
	
end

--@brief  返回
function WndResertConfirm:onReturn(element)
	 SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData.callbackFunc then
		self.m_tMsgData.callbackFunc(self.m_tMsgData.callbackLuaObj,2,self.m_tMsgData.cost)
	end
	WindowManager:removeWindow(self.m_root,self,true)
end

--@brief  确认
function WndResertConfirm:onSure(element)
	 SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData.callbackFunc then
		self.m_tMsgData.callbackFunc(self.m_tMsgData.callbackLuaObj,1,self.m_tMsgData.cost)
	end
	WindowManager:removeWindow(self.m_root,self,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndResertConfirm:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndResertConfirm:_adaptLanguage_th()
    local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(300)

    GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF):setFontSize(18)
end

function WndResertConfirm:_adaptLanguage_vn()
    local txtResert = GetElement(self.m_root,"txtResert_WndResertConfirm",WZUILabelTTF)
    txtResert:setRelativePosition(GlobalMethod:ccp(0.783405,0.7139533))

    local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(600)

    GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF):setScale(0.68)
end

function WndResertConfirm:_adaptLanguage_en()
    local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(300)

    local txtTemp2 = GetElement(self.m_root,"txtTemp2_WndResertConfirm",WZUILabelTTF)
    txtTemp2:setRelativePosition(GlobalMethod:ccp(0.353483,0.713953))
    txtTemp2:setFontSize(18)
    local txtCostCount = GetElement(self.m_root,"txtCostCount_WndResertConfirm",WZUILabelTTF)
    --txtCostCount:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtCostCount:setRelativePosition(GlobalMethod:ccp(0.7747,0.713953))
    txtCostCount:setFontSize(18)
    local imgDiamond = GetElement(self.m_root,"imgCostIcon_WndResertConfirm",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.732432,0.713953))
    imgDiamond:setScale(0.6)
    local txtResert = GetElement(self.m_root,"txtResert_WndResertConfirm",WZUILabelTTF)
    txtResert:setRelativePosition(GlobalMethod:ccp(0.91854,0.713953))
    txtResert:setFontSize(18)    

    GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(340))
end

function WndResertConfirm:_adaptLanguage_pt(  )
    local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(600)

    GetElement(self.m_root,"txtTemp2_WndResertConfirm",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF):setFontSize(18)

    local txtCostCount = GetElement(self.m_root,"txtCostCount_WndResertConfirm",WZUILabelTTF)
    txtCostCount:setRelativePosition(GlobalMethod:ccp(0.5,0.713953))

    local imgDiamond = GetElement(self.m_root,"imgCostIcon_WndResertConfirm",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.7,0.713953))

    local txtResert = GetElement(self.m_root,"txtResert_WndResertConfirm",WZUILabelTTF)
    txtResert:setRelativePosition(GlobalMethod:ccp(0.86,0.713953))
end

function WndResertConfirm:_adaptLanguage_tr(  )
	local txtTemp2 = GetElement(self.m_root,"txtTemp2_WndResertConfirm",WZUILabelTTF)
	txtTemp2:setFontSize(16)
	txtTemp2:setDimensions(GlobalMethod:CCSize(160,0))
	local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(300)

    local txtResetTips2 = GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF)
    txtResetTips2:setFontSize(18)
    txtResetTips2:setDimensions(GlobalMethod:CCSize(330,0))
end

function WndResertConfirm:_adaptLanguage_es(  )
    local txtResertRemind = GetElement(self.m_root,"txtResertRemind_WndResertConfim",WZUIFreeTextBox)
    txtResertRemind:setMaxWidth(600)

    GetElement(self.m_root,"txtTemp2_WndResertConfirm",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF):setFontSize(18)

    local txtCostCount = GetElement(self.m_root,"txtCostCount_WndResertConfirm",WZUILabelTTF)
    txtCostCount:setRelativePosition(GlobalMethod:ccp(0.5,0.713953))

    local imgDiamond = GetElement(self.m_root,"imgCostIcon_WndResertConfirm",WZUIImage)
    imgDiamond:setRelativePosition(GlobalMethod:ccp(0.66,0.713953))

    local txtResert = GetElement(self.m_root,"txtResert_WndResertConfirm",WZUILabelTTF)
    txtResert:setRelativePosition(GlobalMethod:ccp(0.86,0.713953))

    local txtResetTips2 = GetElement(self.m_root,"txtResertTips2_WndResertConfirm",WZUILabelTTF)
    txtResetTips2:setFontSize(18)
    txtResetTips2:setDimensions(GlobalMethod:CCSize(370,0))
end
-------------------------------------私有方法模块End----------------------------------------
