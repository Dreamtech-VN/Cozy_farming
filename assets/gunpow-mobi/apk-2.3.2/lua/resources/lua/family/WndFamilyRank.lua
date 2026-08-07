--WndFamilyRank.lua
--@brief	WndFamilyRank的UI模块
--@date		2017/08/01
--@author	zsq
--@note		家园排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyRank:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief    界面加载完成回调
function WndFamilyRank:onEnterTransitionDidFinish(element)
    -- body
	self.m_nTag = 1
	self:_addTop()
	ProtocolProcessorFamily:send_HOME_GetHomeRankList(1 )
	 
	GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)

	if GlobalMethod:crossServiceOpen() == 0 then
		GetElement(self.m_root,"checkBox2",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"checkBox3",WZUICheckBox):setRelativePosition(ccp(0.215,0.278))
	else
		GetElement(self.m_root,"checkBox2",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"checkBox3",WZUICheckBox):setRelativePosition(ccp(0.356,0.278))
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyRank:onExit(element)
	self:_unInit()
end

function WndFamilyRank:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_family2.png",WndFamilyRank,WndFamilyRank.onClose,true,true,false,"WndFamilyRank", {goldType = 11})
end

function WndFamilyRank:onClose() 
	WZLog("WndFamilyRank:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndFamilyOperate.m_bIsClickFunc = false
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndFamilyRank:onTab(element) 
	WZLog("WndFamilyRank:onTab",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	self.m_nTag = tag
	ProtocolProcessorFamily:send_HOME_GetHomeRankList(tag )
end

--@brief	点击查找公会ID按钮时
function WndFamilyRank:onClickFindCommunityId(element)
	WZLog(" WndFamilyRank:onClickFindCommunityId")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local inputText = nil 
	local editInputId  = self.m_root:getChildElement("editInputId_SceneCommunity")
	if editInputId ~= nil then 
		editInputId = WZUIEditBox:luaTo(editInputId)
		if editInputId ~= nil then 
			inputText = editInputId:getText()
		end 
	end 
	if tonumber(inputText) ~= nil then     --输入全是数字
		--加载圆圈
		--self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
		--获取并显示公会信息
		ProtocolProcessorFamily:send_HOME_Search(tonumber(inputText) )
		--显示取消查找按钮
		GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(true)
	elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
	else  
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
	end 
end 

function WndFamilyRank:onCancelFind(element) 
	WZLog("WndFamilyRank:onCancelFind", tonumber(self.m_nTag))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--隐藏取消查找按钮
	GetElement(self.m_root,"btnCancelFind",WZUIButton):setVisible(false)
	--刷新界面
	ProtocolProcessorFamily:send_HOME_GetHomeRankList(tonumber(self.m_nTag) )
	 
	GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox):setText()
	GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFamilyRank:_update() 
	if self.m_root == nil then return end
	local tbCon = GetElement(self.m_root,"tbcon_WndFamilyRank",WZUITableContainer)
	tbCon:cleanTable()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(tbCon,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(tbCon)
	end

	local index = 0
	for i=1,#self.m_tDataList do
		local showBuild = true
		if showBuild then
			local celElement,tCell = CellFamilyRank:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(self.m_tDataList[i])
				celElement:setTag(index)
				tbCon:setCellElement(celElement)
				tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
				index = index + 1
			end 
		end
	end

	if LocalStrings.FAMILYSHOP19 ~= nil then
	    local ftbMyRank = GetElement(self.m_root,"ftbMyRank_WndFamilyRank",WZUIFreeTextBox)
        if self.playerRank == nil or self.playerRank == 0 or self.playerRank == -1 then
            ftbMyRank:setShowText(LocalStrings.FAMILYSHOP20)
        else
            ftbMyRank:setShowText(string.format(LocalStrings.FAMILYSHOP19,tostring(self.playerRank)))
        end
	end
end





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndFamilyRank:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF):setScale(0.65)
end

function WndFamilyRank:_adaptLanguage_en(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.8)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(120))
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.8)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(120))
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.8)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(120))
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.8)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(120))
	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.8)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(120))
	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.8)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(120))
	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setScale(0.75)
	editInputId:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
end

function WndFamilyRank:_adaptLanguage_vn(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.75)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(130))
	txtIntensify1:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.75)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(130))
	txtIntensify2:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)	
	txtTransfer1:setScale(0.75)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(130))
	txtTransfer1:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)	
	txtTransfer2:setScale(0.75)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(130))
	txtTransfer2:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.75)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(130))
	txtTransferN1:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.75)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(130))
	txtTransferN2:setRelativePosition(GlobalMethod:ccp(0.5,0.43))
	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setRelativeSize(GlobalMethod:CCSize(0.8,1))
	editInputId:setRelativePosition(GlobalMethod:ccp(0.47,0.5))
end

function WndFamilyRank:_adaptLanguage_es(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.8)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(120))

	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.7)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(130))

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.8)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(120))

	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.8)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(120))

	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.8)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(120))

	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.8)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(120))

	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setScale(0.75)
	editInputId:setRelativePosition(GlobalMethod:ccp(0.4,0.5))

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	txtFirst:setScale(0.8)
end

function WndFamilyRank:_adaptLanguage_pt(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.6)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(120))

	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.6)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(120))

	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.6)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(120))

	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.6)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(140))

	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.6)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(120))

	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.6)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(140))

	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setScale(0.75)
	editInputId:setRelativePosition(GlobalMethod:ccp(0.4,0.5))

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	txtFirst:setScale(0.8)
end

function WndFamilyRank:_adaptLanguage_tr(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.6)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(154))
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.6)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(154))
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.6)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(154))
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.6)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(154))
	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.6)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(154))
	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.6)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(154))

	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setScale(0.75)
	editInputId:setRelativePosition(GlobalMethod:ccp(0.4,0.5))

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	txtFirst:setScale(0.8)
end


function WndFamilyRank:_adaptLanguage_ug(  )
	local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
	txtIntensify1:setScale(0.6)
	txtIntensify1:setDimensions(GlobalMethod:CCSize(120))
	local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
	txtIntensify2:setScale(0.6)
	txtIntensify2:setDimensions(GlobalMethod:CCSize(120))
	local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
	txtTransfer1:setScale(0.6)
	txtTransfer1:setDimensions(GlobalMethod:CCSize(120))
	local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
	txtTransfer2:setScale(0.6)
	txtTransfer2:setDimensions(GlobalMethod:CCSize(140))
	local txtTransferN1 = GetElement(self.m_root,"txtTransferN1_WndStrengthen",WZUILabelTTF)
	txtTransferN1:setScale(0.6)
	txtTransferN1:setDimensions(GlobalMethod:CCSize(120))
	local txtTransferN2 = GetElement(self.m_root,"txtTransferN2_WndStrengthen",WZUILabelTTF)
	txtTransferN2:setScale(0.6)
	txtTransferN2:setDimensions(GlobalMethod:CCSize(140))
	
	local editInputId = GetElement(self.m_root,"editInputId_SceneCommunity",WZUIEditBox)
	editInputId:setScale(0.75)
	editInputId:setRelativePosition(GlobalMethod:ccp(0.4,0.5))

	local txtFirst = GetElement(self.m_root,"txtFirst_SceneCommunity",WZUILabelTTF)
	txtFirst:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	txtFirst:setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------