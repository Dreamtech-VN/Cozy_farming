--CellSpaceFlower.lua
--@brief	CellSpaceFlower的UI模块
--@date		2016/01/06
--@author	zsq
--@note		鲜花cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpaceFlower:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpaceFlower:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	赠送鲜花
function CellSpaceFlower:onSend(element)
	WZLog("WndSpaceMain:onMore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not JudgeMoneyIsEnough(self.m_tData.costType, self.m_tData.cost, nil, nil, Chat_Channel_Space_Send_Flower, nil, nil, nil, nil, self, self.clickSureMoney) then
		return 
	end

	self:clickSureMoney()
end

--@brief    购买金币框
function CellSpaceFlower:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief	点击确定充值回调
function CellSpaceFlower:clickSureMoney()
	if self.m_tData.isFlower == true then
		local PlayerId = WndSpaceSendFlower.m_nPlayerId or WndSpaceMain.m_nPlayerId
		
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GiveFlower(PlayerId, self.m_tData.costType, self.m_tData.cost)
	else
		WndSpaceMain.m_nFlowerNum = self.m_tData.data1
		WndSpaceMain.m_nProfit = self.m_tData.data3
		ProtocolProcessorWndSpace:send_SPACE_GiveFlowers(WndSpaceMain.m_nPlayerId , self.m_tData.id )

		local flowerActivityConfig = CacheCenter:getGameParam().flowerActivityConfig
		if not (flowerActivityConfig and tonumber(flowerActivityConfig) ~= 0 and #SplitStringWithSeparator(flowerActivityConfig,",") > 0) then
			--关闭送花窗口
			WindowManager:removeWindow(WndSpaceSendFlower.m_root, WndSpaceSendFlower, true)
			--设置送花按钮不可点击
			GetElement(WndSpaceMain.m_root,"btnSendFlower",WZUIButton):setTouchEnable(false)
		end
	end
end

--@brief	更新界面
function CellSpaceFlower:update(tData)
	if self.m_root == nil then return end
	if tData == nil then return end
	self.m_tData = tData

	if tData.isFlower == true then
		GetElement(self.m_root,"imgCost",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtFlowerList_CellSpaceFlower",WZUILabelTTF):setVisible(true)
		local ttfCost = GetElement(self.m_root,"ttfCost",WZUILabelTTF)
		ttfCost:setText(LocalStrings.GIVE)
		ttfCost:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
		local sCostIconPath = GDatatab_item["id_" .. tData.costType].icon
		local imgItemIcon = GetElement(self.m_root,"imgItemIcon_CellSpaceFlower",WZUIImage)
		imgItemIcon:setFile(sCostIconPath)
		imgItemIcon:setScale(1)
		local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="158,0,0" S="20" P="0">%s</T>]]
		GetElement(self.m_root,"text1_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,GDatatab_item["id_" .. tData.costType].name,"X"..tData.cost))
	else
		local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="158,0,0" S="20" P="0">%s</T>]]
		GetElement(self.m_root,"text1_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE26,"X"..tData.data1))
		local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="0,72,3" S="20" P="0">%s</T>]]
		GetElement(self.m_root,"text2_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE27,"+"..tData.data2))
		local string = [[<T C="62,34,8" S="20" P="0">%s</T><I P="1" Z="0.45">ui/common/common_icon_huoli.png</I><T C="0,72,3" S="20" P="0">%s</T>]]
		GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE28,"+"..tData.data3))
		
		if ProjConfig.LANGUAGE == "vn" then
			local string = [[<T C="62,34,8" S="18" P="0">%s</T><T C="158,0,0" S="18" P="0">%s</T>]]
			GetElement(self.m_root,"text1_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE26,"X"..tData.data1))

			local string = [[<T C="62,34,8" S="18" P="0">%s</T><T C="0,72,3" S="18" P="0">%s</T>]]
			GetElement(self.m_root,"text2_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE27,"+"..tData.data2))

			local string = [[<T C="62,34,8" S="18" P="0">%s</T><T C="0,72,3" S="18" P="0">%s</T>]]
			GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE28,"+"..tData.data3))
		else
			local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="158,0,0" S="20" P="0">%s</T>]]
			GetElement(self.m_root,"text1_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE26,"X"..tData.data1))

			local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="0,72,3" S="20" P="0">%s</T>]]
			GetElement(self.m_root,"text2_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE27,"+"..tData.data2))

			local string = [[<T C="62,34,8" S="20" P="0">%s</T><T C="0,72,3" S="20" P="0">%s</T>]]
			GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE28,"+"..tData.data3))
		end

		--消耗钻石
		GetElement(self.m_root,"ttfCost",WZUILabelTTF):setText(tData.cost)

		local sCostIconPath = GDatatab_item["id_" .. tData.costType].icon
		local imgCost = GetElement(self.m_root,"imgCost",WZUIImage)
		if imgCost then 
			imgCost:setFile(sCostIconPath)
			imgCost:setScale(0.6)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin--------------------------------
function CellSpaceFlower:_adaptLanguage_vn()
    --body
    WZLog("CellSpaceFlower:_adaptLanguage_vn")
    local text3 = GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox)
    text3:setRelativePosition(GlobalMethod:ccp(0.525,0.36))
    text3:setScale(0.8)

    GetElement(self.m_root,"text2_CellSpaceFlower",WZUIFreeTextBox):setScale(0.8)
    GetElement(self.m_root,"txtFlowerList_CellSpaceFlower",WZUILabelTTF):setScale(0.8)
end

function CellSpaceFlower:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtGiven_CellSpaceFlower",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.5,0.36))
end

function CellSpaceFlower:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtGiven_CellSpaceFlower",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.58,0.36))
end

function CellSpaceFlower:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtGiven_CellSpaceFlower",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.5,0.36))
end
-------------------------------------私有方法模块End----------------------------------------

function CellSpaceFlower:_adaptLanguage_es(  )
	local text3 = GetElement(self.m_root,"text3_CellSpaceFlower",WZUIFreeTextBox)
	text3:setRelativePosition(GlobalMethod:ccp(0.58,0.36))
	text3:setScale(0.8)
	GetElement(self.m_root,"text2_CellSpaceFlower",WZUIFreeTextBox):setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------
