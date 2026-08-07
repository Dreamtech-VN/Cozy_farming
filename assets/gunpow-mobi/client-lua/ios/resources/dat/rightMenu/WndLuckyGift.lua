--WndLuckyGift.lua
--@brief	WndLuckyGift的UI模块
--@date		2017/01/09
--@author	peiting_mao
--@note		幸运礼盒


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLuckyGift:onEnter(element)
	--WZLog("--WndLuckyGift:onEnter--")
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorWndLuckyGift:regAll()
end

function WndLuckyGift:onEnterTransitionDidFinish( element )
	--WZLog("--WndLuckyGift:onEnterTransitionDidFinish--")
	local imgDim = GetElement(self.m_root,"imgDim_WndLuckyGift",WZUIImage)
	if CacheCenter:getGameParam().isUseTicket == "0" then
		imgDim:setFile(GDatatab_item["id_70"].icon)
	else
		imgDim:setFile(GDatatab_item["id_1"].icon)
	end
	imgDim:setScale(0.4)

	ProtocolProcessorWndLuckyGift:send_LUCKYBOX_GetPlayerCardsRecord( ) --发送获取玩家当天翻牌记录协议
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLuckyGift:onExit(element)
	self:_unInit()
	ProtocolProcessorWndLuckyGift:unregAll()
end

--@brief	判断是否是第一次翻牌
function WndLuckyGift:_IsFirstDraw(  )
	if self.index[1] == 0 then
		self:_FirstDraw()
	else
		self:_HasDraw()
	end
end

--@brief 	第一次翻牌的展示所有奖品的界面
function WndLuckyGift:_FirstDraw(  )
	local item 
	local itemInfo
	GetElement(self.m_root,"btn_WndLuckyGift",WZUIButton):setVisible(true)
	GetElement(self.m_root,"txtLucky1",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"conDrawCost_WndLuckyGift",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"txtFinish_WndLuckyGift",WZUILabelTTF):setVisible(false)

	for k,v in pairs(GDatatab_luckybox_reward) do
		if v.id == 14 then
			item = v.store_boy
			break
		end
	end

	for i=1,14 do
		GetElement(self.m_root,"con"..i.."_WndLuckyGift",WZUIContainer):setVisible(false)
		local conSel = GetElement(self.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer)
		conSel:setVisible(true)
	
			local tabItem = GDatatab_item["id_"..item[i][1]]
				--WZLog("WndLuckyGift:_FirstDraw",item[i][1])
				GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setText(tabItem.name)
				GetElement(self.m_root,"txtNum"..i,WZUILabelTTF):setText(item[i][2])
				if ProjConfig.LANGUAGE == "th" then
					GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setScale(0.75)
				elseif ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
					or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
					GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setScale(0.65)
					GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(150))
				end
				if tabItem.id == 203 then
					--tCell:_setItemVisible(false)
					local img = WZUIImage:create()
					img:setFile("ui/common_num/common_num_blk_wen.png")
					img:setRotation(-45)
					img:setRelativePosition(GlobalMethod:ccp(0.54,0.36))
					img:setUseOriginSize(true)
					img:setTag(99)
					conSel:addChild(img)
					itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=item[i][2],quality=tabItem.quality,magnification = -1,basicInfo=CopyTable(tabItem)}
					--self.ratioIndex = i
					local icon = WZUIImage:create()
					icon:setFile("ui/common/common_icon_zhanjb.png")
					icon:setRelativePosition(GlobalMethod:ccp(0.86,0.8))
					icon:setUseOriginSize(true)
					icon:setTag(999)
					conSel:addChild(icon)
					local txt = WZUILabelTTF:create()
					txt:setAnchorPoint(GlobalMethod:ccp(0,0.5))
					txt:setFontSize(16)
					txt:setColor(GlobalMethod:ccc3(255,255,255))
					txt:setEnableStroke(true)
					txt:setStrokeColor(GlobalMethod:ccc3(179,91,13))
					txt:setStrokeSize(4)
					txt:setRotation(45)
					txt:setRelativePosition(GlobalMethod:ccp(0.84,0.94))
					txt:setTag(777)
					txt:setText(LocalStrings.LUCKYGIFT4)
					conSel:addChild(txt)
					if self.ratio < 10 then
						txt:setText(string.format(LocalStrings.LUCKYGIFT3,self.ratio))
						txt:setRelativePosition(GlobalMethod:ccp(0.77,0.94))
						if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
							txt:setText("-"..(100-self.ratio*10).."%")
							txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
						elseif ProjConfig.LANGUAGE == "vn" then
							txt:setText((100-self.ratio).."%")

						end
					else
						txt:setText(string.format(LocalStrings.LUCKYGIFT2,self.ratio/10))
						txt:setRelativePosition(GlobalMethod:ccp(0.715656,0.980658))
						if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
							txt:setText("+"..(self.ratio*10-100).."%")
							txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
						end
					end
					if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "th" then
						txt:setScale(0.65)
						txt:setRelativePosition(GlobalMethod:ccp(0.834583,0.983253))
					end
				else
					itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=item[i][2],quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
				end
				if tabItem.id == 57 then --判断是否为珍品
					GetElement(self.m_root,"img"..i.."_WndLuckyGift",WZUIImage):setVisible(true)
				end

				local celElement,tCell = CellGoodItem:createElement()
				if celElement and tCell ~= nil then
					celElement:setTag(i-1)
					tCell:setCellGoodItem(itemInfo,5)
					tCell:setItemClickFun(self,self.onTips)
					if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
						celElement:setScale(0.9)
					end
                    GetElement(self.m_root,"conGift"..i.."_WndLuckyGift",WZUIContainer):removeAllChildrenWithCleanup(true)
					GetElement(self.m_root,"conGift"..i.."_WndLuckyGift",WZUIContainer):addChild(celElement)
				end
	end
end

--@brief	已经有过翻牌记录
function WndLuckyGift:_HasDraw(  )
	WZLog("--self.ratio--",self.ratio)
	local itemInfo
	GetElement(self.m_root,"btn_WndLuckyGift",WZUIButton):setVisible(false)
	GetElement(self.m_root,"txtLucky1",WZUILabelTTF):setVisible(false)
	local conDrawCost = GetElement(self.m_root,"conDrawCost_WndLuckyGift",WZUIContainer)
	if self.m_TurnedTimes >= 15 then
		conDrawCost:setVisible(false)
		GetElement(self.m_root,"txtFinish_WndLuckyGift",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"conSale_WndLuckyGift",WZUIContainer):setVisible(false)
	else
		conDrawCost:setVisible(true)
		GetElement(self.m_root,"txtFinish_WndLuckyGift",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtHasDrawNum_WndLuckyGift",WZUILabelTTF):setText(string.format(LocalStrings.LUCKYGIFT_HASDRAW,self.m_TurnedTimes))
	end
	
	local imgDim = GetElement(self.m_root,"imgDim_WndLuckyGift",WZUIImage)
	local txtDim = GetElement(self.m_root,"txtDimNum_WndLuckyGift",WZUILabelTTF)
	local txtFree = GetElement(self.m_root,"txtFree_WndLuckyGift",WZUILabelTTF)
	
	imgDim:setVisible(true)
	txtDim:setVisible(true)
	txtFree:setVisible(false)
	txtDim:setText(self.m_CurTurnCost)

	local discount = GetElement(self.m_root,"txt1_WndLuckyGift",WZUILabelTTF)
	local labCnt = GetElement(self.m_root,"labCnt_WndLuckyGift",WZUILabelAtlasFont)
	local imgSale = GetElement(self.m_root,"imgSale_WndLuckyGift",WZUIImage)
	local txtSale = GetElement(self.m_root,"txtSale_WndLuckyGift",WZUILabelTTF)
	local txtOP = GetElement(self.m_root,"txtOP_WndLuckyGift",WZUILabelTTF)
	if self.ratio ~= 10 then
		if self.m_TurnedTimes < 15 then
			GetElement(self.m_root,"conSale_WndLuckyGift",WZUIContainer):setVisible(true)
		end
		GetElement(self.m_root,"imgLine_WndLuckyGift",WZUIImage):setVisible(true)
		GetElement(self.m_root,"txtNum_WndLuckyGift",WZUILabelTTF):setText("["..self.m_CurTurnCost*(self.ratio/10).."]")
		self.m_CurTurnCost = self.m_CurTurnCost * (self.ratio/10)
		if self.ratio < 10 then
			labCnt:setVisible(true)
			labCnt:setText(self.ratio)
			discount:setVisible(true)
			discount:setText(self.ratio..LocalStrings.NEWSHOP12)
			imgSale:setVisible(true)
			txtSale:setVisible(false)
			if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
				labCnt:setText(100-self.ratio*10)
				txtOP:setVisible(true)
				txtOP:setText("-")
			elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
				labCnt:setText(100-self.ratio*10)
				txtOP:setVisible(false)
			elseif ProjConfig.LANGUAGE == "vn" then
				labCnt:setText(100-self.ratio*10)
				discount:setVisible(false)
			end
		else
			txtSale:setVisible(true)
			txtSale:setText(string.format(LocalStrings.LUCKYGIFT2,self.ratio/10))
			discount:setVisible(false)
			labCnt:setVisible(false)
			imgSale:setVisible(false)
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
				txtSale:setVisible(false)
				-- imgSale:setVisible(true)
				labCnt:setVisible(true)
				labCnt:setText(self.ratio*10-100)
				txtOP:setVisible(true)
				txtOP:setText("+")
				txtOP:setZOrder(1)
				txtSale:setText("%")
				txtSale:setVisible(true)
			elseif ProjConfig.LANGUAGE == "tr" then
				txtSale:setScale(0.8)
			end
		end
	end
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
		txtOP:setScale(0.8)
		labCnt:setScale(0.8)
		imgSale:setScale(0.8)
		labCnt:setRelativePosition(GlobalMethod:ccp(0.41753,0.372919))
		-- imgSale:setRelativePosition(GlobalMethod:ccp(0.988888,0.505187))
		txtOP:setRelativePosition(GlobalMethod:ccp(-0.0166673,0.14))
		txtSale:setRelativePosition(GlobalMethod:ccp(0.839724,0.513938))
	elseif ProjConfig.LANGUAGE == "tr" then
		labCnt:setScale(0.6)
		imgSale:setScale(0.6)
		imgSale:setRelativePosition(GlobalMethod:ccp(0.754683,0.533545))
	end
	for i=1,14 do
		GetElement(self.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con"..i.."_WndLuckyGift",WZUIContainer):setVisible(true)
		for j=1,#self.index do
			if i == self.index[j] then
				--WZLog("--self.index--",Serialize(self.index))
				GetElement(self.m_root,"con"..i.."_WndLuckyGift",WZUIContainer):setVisible(false)
				local conSel = GetElement(self.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer)
				conSel:setVisible(true)
			
					local item = GDatatab_item["id_"..self.m_RecordCardId[j]]
						GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setText(item.name)
						GetElement(self.m_root,"txtNum"..i,WZUILabelTTF):setText(self.itemNum[j])
						if ProjConfig.LANGUAGE == "th" then
							GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setScale(0.75)
						elseif ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
							or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
							GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setScale(0.65)
							GetElement(self.m_root,"txtGift"..i.."_WndLuckyGift",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(150))
						end
						if self.m_RecordCardId[j] == 203 then
							local img1 = WZUILabelAtlasFont:create()
							img1:setCharMapFileName("ui/common_num/common_num_blk.png")
							img1:setWidth(14)
							img1:setHeight(18)
							img1:setText(math.floor(self.ratio/10))
							img1:setRelativePosition(GlobalMethod:ccp(0.535,0.34))
							img1:setRotation(-45)
							img1:setUseOriginSize(true)
							local img2 = WZUIImage:create()
							img2:setFile("ui/common_num/common_num_blk_dian.png")
							img2:setRelativePosition(GlobalMethod:ccp(0.6,0.39))
							img2:setUseOriginSize(true)
							local img3 = WZUILabelAtlasFont:create()
							img3:setCharMapFileName("ui/common_num/common_num_blk.png")
							img3:setWidth(14)
							img3:setHeight(18)
							img3:setText(self.ratio%10)
							img3:setRelativePosition(GlobalMethod:ccp(0.62,0.42))
							img3:setRotation(-45)
							img3:setUseOriginSize(true)
							conSel:addChild(img1)
							conSel:addChild(img2)
							conSel:addChild(img3)
							itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=self.itemNum[j],quality=item.quality,magnification = self.ratio,basicInfo=CopyTable(item)}
							
							local icon = WZUIImage:create()
							icon:setFile("ui/common/common_icon_zhanjb.png")
							icon:setRelativePosition(GlobalMethod:ccp(0.86,0.8))
							icon:setUseOriginSize(true)
							conSel:addChild(icon)
							local txt = WZUILabelTTF:create()
							txt:setAnchorPoint(GlobalMethod:ccp(0,0.5))
							txt:setFontSize(16)
							txt:setColor(GlobalMethod:ccc3(255,255,255))
							txt:setEnableStroke(true)
							txt:setStrokeColor(GlobalMethod:ccc3(179,91,13))
							txt:setStrokeSize(4)
							txt:setRotation(45)
							if self.ratio < 10 then
								txt:setText(string.format(LocalStrings.LUCKYGIFT3,self.ratio))
								txt:setRelativePosition(GlobalMethod:ccp(0.84,0.94))
								if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
									txt:setText("-"..(100-self.ratio*10).."%")
									txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
								end
							else
								txt:setText(string.format(LocalStrings.LUCKYGIFT2,self.ratio/10))
								txt:setRelativePosition(GlobalMethod:ccp(0.785656,0.980658))
								if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
									txt:setText("+"..(self.ratio*10-100).."%")
									txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
								end
							end
							if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
								txt:setScale(0.65)
								txt:setRelativePosition(GlobalMethod:ccp(0.834583,0.983253))
							end
							conSel:addChild(txt)
						else
							itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=self.itemNum[j],quality=item.quality,basicInfo=CopyTable(item)}
						end

						if self.m_RecordCardId[j] == 57 then
							GetElement(self.m_root,"img"..i.."_WndLuckyGift",WZUIImage):setVisible(true)
						end

						local celElement,tCell = CellGoodItem:createElement()
						if celElement and tCell ~= nil then
							celElement:setTag(i-1)
							tCell:setCellGoodItem(itemInfo,5)
					        tCell:setItemClickFun(self,self.onTips)
					        if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
								celElement:setScale(0.9)
							end
							GetElement(self.m_root,"conGift"..i.."_WndLuckyGift",WZUIContainer):removeAllChildrenWithCleanup(true)
							GetElement(self.m_root,"conGift"..i.."_WndLuckyGift",WZUIContainer):addChild(celElement)
						end
				break
			end
		end
	end
end

--@brief	顯示tips
function WndLuckyGift:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief 	点击礼盒进行翻牌抽奖点击事件
function WndLuckyGift:onFunctionClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.tag = element:getTag()
	if CacheCenter:getRemainAmount() <= 0 then  --背包已满提示
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return 
    end
    if CacheCenter:getGameParam().isUseTicket == "0" then
		if not JudgeMoneyIsEnough(70, self.m_CurTurnCost, nil, nil, nWindowId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			return 
		end
	else
		if not JudgeMoneyIsEnough(1, self.m_CurTurnCost, nil, nil, nWindowId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			return 
		end
	end

	self:sureUseDiamondInstead()
end

--@brief 	确认用钻石代替礼券翻牌
function WndLuckyGift:sureUseDiamondInstead()
	-- body
	ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard(self.tag,self.flag)
end

function WndLuckyGift:isCastMoney( )
	ProtocolProcessorWndLuckyGift:send_LUCKYBOX_TurnCard(self.tag,self.flag)
end

--@brief 	进行翻牌抽奖
function WndLuckyGift:_starDraw(  )
	WZLog("--WndLuckyGift:_starDraw--")
	local itemInfo
	local aniflip = CCOrbitCamera:create(0.2, 1.0, 0.0, 0.0, -180, 0.0, 0.0)
	local conDrawCost = GetElement(self.m_root,"conDrawCost_WndLuckyGift",WZUIContainer)
	if self.m_TurnedTimes >= 15 then
		conDrawCost:setVisible(false)
		GetElement(self.m_root,"txtFinish_WndLuckyGift",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"conSale_WndLuckyGift",WZUIContainer):setVisible(false)
	else
		conDrawCost:setVisible(true)
		GetElement(self.m_root,"txtFinish_WndLuckyGift",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtHasDrawNum_WndLuckyGift",WZUILabelTTF):setText(string.format(LocalStrings.LUCKYGIFT_HASDRAW,self.m_TurnedTimes))
	end
	GetElement(self.m_root,"btn_WndLuckyGift",WZUIButton):setVisible(false)
	GetElement(self.m_root,"txtLucky1",WZUILabelTTF):setVisible(false)
	local imgDim = GetElement(self.m_root,"imgDim_WndLuckyGift",WZUIImage)
	local txtDim = GetElement(self.m_root,"txtDimNum_WndLuckyGift",WZUILabelTTF)
	local txtFree = GetElement(self.m_root,"txtFree_WndLuckyGift",WZUILabelTTF)
	WZLog("--self.m_CurTurnCost--",self.m_CurTurnCost)
	if self.m_CurTurnCost <= 0 then
		imgDim:setVisible(false)
		txtDim:setVisible(false)
		txtFree:setVisible(true)
	else
		imgDim:setVisible(true)
		txtDim:setVisible(true)
		txtFree:setVisible(false)
		txtDim:setText(self.m_CurTurnCost)
	end

	local discount = GetElement(self.m_root,"txt1_WndLuckyGift",WZUILabelTTF)
	local labCnt = GetElement(self.m_root,"labCnt_WndLuckyGift",WZUILabelAtlasFont)
	local imgSale = GetElement(self.m_root,"imgSale_WndLuckyGift",WZUIImage)
	local txtSale = GetElement(self.m_root,"txtSale_WndLuckyGift",WZUILabelTTF)
	local txtOP = GetElement(self.m_root,"txtOP_WndLuckyGift",WZUILabelTTF)
	if self.ratio ~= 10 then
		if self.m_TurnedTimes < 15 then
			GetElement(self.m_root,"conSale_WndLuckyGift",WZUIContainer):setVisible(true)
		end
		GetElement(self.m_root,"imgLine_WndLuckyGift",WZUIImage):setVisible(true)
		GetElement(self.m_root,"txtNum_WndLuckyGift",WZUILabelTTF):setText("["..self.m_CurTurnCost*(self.ratio/10).."]")
		self.m_CurTurnCost = self.m_CurTurnCost*(self.ratio/10)
		if self.ratio < 10 then
			labCnt:setVisible(true)
			labCnt:setText(self.ratio)
			discount:setVisible(true)
			discount:setText(self.ratio..LocalStrings.NEWSHOP12)
			imgSale:setVisible(true)
			txtSale:setVisible(false)
			if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
				labCnt:setText(100-self.ratio*10)
				txtOP:setVisible(true)
				txtOP:setText("-")
			elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
				labCnt:setText(100-self.ratio*10)
				txtOP:setVisible(false)
			elseif ProjConfig.LANGUAGE == "vn" then
				labCnt:setText(100-self.ratio*10)
				discount:setVisible(false)
			end
		else
			txtSale:setVisible(true)
			txtSale:setText(string.format(LocalStrings.LUCKYGIFT2,self.ratio/10))
			discount:setVisible(false)
			labCnt:setVisible(false)
			imgSale:setVisible(false)
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
				txtSale:setVisible(false)
				-- imgSale:setVisible(true)
				labCnt:setVisible(true)
				labCnt:setText(self.ratio*10-100)
				txtOP:setVisible(true)
				txtOP:setText("+")
				txtOP:setZOrder(1)
				txtSale:setText("%")
				txtSale:setVisible(true)
			elseif ProjConfig.LANGUAGE == "tr" then
				txtSale:setScale(0.8)
			end
		end
	end
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
		txtOP:setScale(0.8)
		labCnt:setScale(0.8)
		imgSale:setScale(0.8)
		labCnt:setRelativePosition(GlobalMethod:ccp(0.41753,0.372919))
		-- imgSale:setRelativePosition(GlobalMethod:ccp(0.988888,0.505187))
		txtOP:setRelativePosition(GlobalMethod:ccp(-0.0166673,0.14))
		txtSale:setRelativePosition(GlobalMethod:ccp(0.839724,0.513938))
	elseif ProjConfig.LANGUAGE == "tr" then
		labCnt:setScale(0.6)
		imgSale:setScale(0.6)
		imgSale:setRelativePosition(GlobalMethod:ccp(0.754683,0.533545))
	end
	local item = GDatatab_item["id_"..self.m_CardId]
	--if v.id == self.m_CardId then
	local con1 = GetElement(self.m_root,"con"..self.tag.."_WndLuckyGift",WZUIContainer)
	--con1:runAction(aniflip)
	con1:setVisible(false)
	local conSel = GetElement(self.m_root,"conSel"..self.tag.."_WndLuckyGift",WZUIContainer)
	conSel:setVisible(true)
	conSel:runAction(aniflip)
	conSel:setScaleX(-1)
	GetElement(self.m_root,"txtGift"..self.tag.."_WndLuckyGift",WZUILabelTTF):setText(item.name)
	GetElement(self.m_root,"txtNum"..self.tag,WZUILabelTTF):setText(self.count)
	if ProjConfig.LANGUAGE == "th" then
		GetElement(self.m_root,"txtGift"..self.tag.."_WndLuckyGift",WZUILabelTTF):setScale(0.75)
	elseif ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
		or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"txtGift"..self.tag.."_WndLuckyGift",WZUILabelTTF):setScale(0.65)
		GetElement(self.m_root,"txtGift"..self.tag.."_WndLuckyGift",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(150))
	end
	if self.m_CardId == 203 then
		--WZLog("--WndLuckyGift--",v.icon,v.name)
		local img1 = WZUILabelAtlasFont:create()
		img1:setCharMapFileName("ui/common_num/common_num_blk.png")
		img1:setWidth(14)
		img1:setHeight(18)
		img1:setText(math.floor(self.ratio/10))
		img1:setRelativePosition(GlobalMethod:ccp(0.535,0.34))
		img1:setRotation(-45)
		img1:setUseOriginSize(true)
		local img2 = WZUIImage:create()
		img2:setFile("ui/common_num/common_num_blk_dian.png")
		img2:setRelativePosition(GlobalMethod:ccp(0.6,0.39))
		img2:setUseOriginSize(true)
		local img3 = WZUILabelAtlasFont:create()
		img3:setCharMapFileName("ui/common_num/common_num_blk.png")
		img3:setWidth(14)
		img3:setHeight(18)
		img3:setText(self.ratio%10)
		img3:setRelativePosition(GlobalMethod:ccp(0.62,0.42))
		img3:setRotation(-45)
		img3:setUseOriginSize(true)
		conSel:addChild(img1)
		conSel:addChild(img2)
		conSel:addChild(img3)
		itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=self.count,quality=item.quality,magnification = self.ratio,basicInfo=CopyTable(item)}
					
		local icon = WZUIImage:create()
		icon:setFile("ui/common/common_icon_zhanjb.png")
		icon:setRelativePosition(GlobalMethod:ccp(0.86,0.8))
		icon:setUseOriginSize(true)
		conSel:addChild(icon)
		local txt = WZUILabelTTF:create()
		txt:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		txt:setFontSize(16)
		txt:setColor(GlobalMethod:ccc3(255,255,255))
		txt:setEnableStroke(true)
		txt:setStrokeColor(GlobalMethod:ccc3(179,91,13))
		txt:setStrokeSize(4)
		txt:setRotation(45)
		if self.ratio < 10 then
			txt:setText(string.format(LocalStrings.LUCKYGIFT3,self.ratio))
			txt:setRelativePosition(GlobalMethod:ccp(0.84,0.94))
			if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
				txt:setText("-"..(100-self.ratio*10).."%")
				txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
			end
		else
			txt:setText(string.format(LocalStrings.LUCKYGIFT2,self.ratio/10))
			txt:setRelativePosition(GlobalMethod:ccp(0.785656,0.980658))
			if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
				txt:setText("+"..(self.ratio*10-100).."%")
				txt:setRelativePosition(GlobalMethod:ccp(0.736666,0.974603))
			end
		end
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
			txt:setScale(0.65)
			txt:setRelativePosition(GlobalMethod:ccp(0.834583,0.983253))
		end
		conSel:addChild(txt)
    else
		itemInfo = {id = item.id, name=item.name,icon=item.icon,lastTime=self.count,quality=item.quality,basicInfo=CopyTable(item)}
	end
	if self.m_CardId == 57 then
		GetElement(self.m_root,"img"..self.tag.."_WndLuckyGift",WZUIImage):setVisible(true)
	end
	local celElement,tCell = CellGoodItem:createElement()
	if celElement and tCell ~= nil then
		celElement:setTag(self.tag-1)
		tCell:setCellGoodItem(itemInfo,5)
		tCell:setItemClickFun(self,self.onTips)
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
			celElement:setScale(0.9)
		end	
		GetElement(self.m_root,"conGift"..self.tag.."_WndLuckyGift",WZUIContainer):removeAllChildrenWithCleanup(true)
		GetElement(self.m_root,"conGift"..self.tag.."_WndLuckyGift",WZUIContainer):removeAllChildrenWithCleanup(true)
		GetElement(self.m_root,"conGift"..self.tag.."_WndLuckyGift",WZUIContainer):addChild(celElement)
	end
end

--@brief  	开始翻牌按钮的点击事件
function WndLuckyGift:doClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	for i=1,14 do
		GetElement(self.m_root,"btn"..i.."_WndLuckyGift",WZUIButton):setTouchEnable(false)
	end

	GetElement(self.m_root,"btn_WndLuckyGift",WZUIButton):setVisible(false)
	GetElement(self.m_root,"txtLucky1",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"conDrawCost_WndLuckyGift",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"txtHasDrawNum_WndLuckyGift",WZUILabelTTF):setText(string.format(LocalStrings.LUCKYGIFT_HASDRAW,self.m_TurnedTimes))
	local imgDim = GetElement(self.m_root,"imgDim_WndLuckyGift",WZUIImage)
	local txtDim = GetElement(self.m_root,"txtDimNum_WndLuckyGift",WZUILabelTTF)
	local txtFree = GetElement(self.m_root,"txtFree_WndLuckyGift",WZUILabelTTF)

	imgDim:setVisible(false)
	txtDim:setVisible(false)
	txtFree:setVisible(true)
	
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(self._center))
	array:addObject(CCDelayTime:create(1))
	array:addObject(CCCallFuncN:create(self._draw))
	array:addObject(CCDelayTime:create(1))
	array:addObject(CCCallFuncN:create(self._rotate))
	array:addObject(CCDelayTime:create(1))
	array:addObject(CCCallFuncN:create(self._recover))
	array:addObject(CCCallFuncN:create(self._isTouch))
	local action = CCSequence:create(array)
	self.m_root:runAction(action)
end

function WndLuckyGift:_center(  )
	for i=1,14 do
		WZLog("--WndLuckyGift:doClick1--")
		local move1 = WZUIActionMoveTo:create()
		move1:setMoveX(0.5)
		move1:setMoveY(0.5)
		move1:setDuration(0.6)
		local move2 = WZUIActionMoveTo:create()
		move2:setMoveX(0.5)
		move2:setMoveY(0.5)
		move2:setDuration(0.6)
		local conSel = GetElement(WndLuckyGift.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer)
		local con = GetElement(WndLuckyGift.m_root,"con"..i.."_WndLuckyGift",WZUIContainer)
		local pos = {}
		table.insert(pos,conSel:getRelativePosition().x)
		table.insert(pos,conSel:getRelativePosition().y)
		table.insert(WndLuckyGift.cardPos,pos)
		con:runUIAction(move1)
		conSel:runUIAction(move2)
	end
end

function WndLuckyGift:_draw(  )
	for i=1,14 do
		--WZLog("--WndLuckyGift:doClick2--")
		local aniflip = CCOrbitCamera:create(0.2, 1.0, 0.0, 0.0, -180, 0.0, 0.0)
    	--WndLuckyGift.m_root:runAction(aniflip)
		local conSel = GetElement(WndLuckyGift.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer)
		conSel:removeChildByTag(99, true)
		conSel:removeChildByTag(999,true)
		conSel:removeChildByTag(777,true)
		conSel:setVisible(false)
		GetElement(WndLuckyGift.m_root,"img"..i.."_WndLuckyGift",WZUIImage):setVisible(false)
		local con = GetElement(WndLuckyGift.m_root,"con"..i.."_WndLuckyGift",WZUIContainer)
		con:setVisible(true)
		con:runAction(aniflip)
	end
end

function WndLuckyGift:_rotate()
	WZLog("--WndLuckyGift:_rotate--")
	for i=1,14 do
		local rotate = WZUIActionRotateTo:create()
		rotate:setAngle(720)
		rotate:setDuration(0.5)
		local con = GetElement(WndLuckyGift.m_root,"con"..i.."_WndLuckyGift",WZUIContainer)
		con:runUIAction(rotate)
	end
end

function WndLuckyGift:_recover(  )
	for i=1,14 do
		--WZLog("--WndLuckyGift:doClick3--")
		--WZLog("--self.cardPos--",Serialize(WndLuckyGift.cardPos[i]))
		local move1 = WZUIActionMoveTo:create()
		move1:setMoveX(WndLuckyGift.cardPos[i][1])
		move1:setMoveY(WndLuckyGift.cardPos[i][2])
		move1:setDuration(0.6)
		local move2 = WZUIActionMoveTo:create()
		move2:setMoveX(WndLuckyGift.cardPos[i][1])
		move2:setMoveY(WndLuckyGift.cardPos[i][2])
		move2:setDuration(0.6)
		local con = GetElement(WndLuckyGift.m_root,"con"..i.."_WndLuckyGift",WZUIContainer)
		con:runUIAction(move1)
		local conSel = GetElement(WndLuckyGift.m_root,"conSel"..i.."_WndLuckyGift",WZUIContainer)
		conSel:runUIAction(move2)
	end
end

function WndLuckyGift:_isTouch(  )
	for i=1,14 do
		GetElement(WndLuckyGift.m_root,"btn"..i.."_WndLuckyGift",WZUIButton):setTouchEnable(true)
	end
end

function WndLuckyGift:onDesc( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WndSingleMapDesc:showInterface(LocalStrings.LUCKYGIFT_DES)
end

--@brief 	点击进入碎片商店按钮点击事件
function WndLuckyGift:onStore( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WndShop:jumpTab(5)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function WndLuckyGift:_adaptLanguage_en(  )
	local txtFinish = GetElement(self.m_root,"txtNextDraw_WndLuckyGift",WZUILabelTTF)
	txtFinish:setScale(0.7)
	local txtSale = GetElement(self.m_root,"txtSale_WndLuckyGift",WZUILabelTTF)
	txtSale:setScale(0.7)
	txtSale:setRelativePosition(GlobalMethod:ccp(0.500864,0.489585))
end

function WndLuckyGift:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtSale_WndLuckyGift",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.500864,0.472919))
end

function WndLuckyGift:_adaptLanguage_pt(  )
	local txtFinish = GetElement(self.m_root,"txtNextDraw_WndLuckyGift",WZUILabelTTF)
	txtFinish:setScale(0.7)
end

function WndLuckyGift:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtBtn1_WndLuckyGift",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBtn2_WndLuckyGift",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBtn3_WndLuckyGift",WZUILabelTTF):setScale(0.6)
	
	local txtFinish = GetElement(self.m_root,"txtNextDraw_WndLuckyGift",WZUILabelTTF)
	txtFinish:setScale(0.6)
end
function WndLuckyGift:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtNextDraw_WndLuckyGift",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtSale_WndLuckyGift",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.500864,0.472919))
end

function WndLuckyGift:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtBtn1_WndLuckyGift",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtn2_WndLuckyGift",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBtn3_WndLuckyGift",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtNextDraw_WndLuckyGift",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"imgDim_WndLuckyGift",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.07,0.55))
	GetElement(self.m_root,"txtDimNum_WndLuckyGift",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.268,0.5))
end
-------------------------------------语言适配End--------------------------------------------