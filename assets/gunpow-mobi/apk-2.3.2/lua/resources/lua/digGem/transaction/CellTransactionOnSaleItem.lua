--CellTransactionOnSaleItem.lua
--@brief	CellTransactionOnSaleItem的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行商品Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionOnSaleItem:onEnter(element)
	self.m_root = element
end

function CellTransactionOnSaleItem:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.NUM1..":")
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.UNIT_PRICE..":")
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionOnSaleItem:onExit(element)
	self:_unInit()
end

function CellTransactionOnSaleItem:onClick(element)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndTransaction.m_nRightTag == 2 then
		--下架
    	self.m_tData.tBtnList = {LocalStrings.TRANSACTION25}
    	WndItemInfo:showInfo(element,WndTransaction.m_root,1,self.m_tData)
    	WndItemInfo:setClickButtonCallback(self,self.onOff)
	elseif WndTransaction.m_nRightTag == 3 then
		local itemIds = self.m_tData.itemIds
		local itemTag = self.m_tData.itemTag
		--取消回收商品遮罩
		for i=1,#WndTransaction.m_tDataList do
        	if WndTransaction.m_tDataList[i].itemIds == itemIds 
				and WndTransaction.m_tDataList[i].itemTag == itemTag then
				WndTransaction.m_tDataList[i].isCover = false
			end
		end
		WndTransaction:updateBag()
		--取消回收
		for i=1,#WndTransaction.m_tDataList3 do
        	if WndTransaction.m_tDataList3[i].itemIds == itemIds 
				and WndTransaction.m_tDataList3[i].itemTag == itemTag then
				table.remove(WndTransaction.m_tDataList3, i)
				break
			end
		end
		WndTransaction:updateRight3()
	end
end

function CellTransactionOnSaleItem:onOff(tag, tData)
	WZLog("CellTransactionItem:onOff", tData.commodityIds)
	local function off()
		--下架
		ProtocolProcessorTransaction:send_TRANSACTION_UnSales(tData.commodityIds )
	end
    MsgBoxManager:showConfirmBox(string.format(LocalStrings.TRANSACTION54, tData.basicInfo.name.."*"..tData.lastNum), nil,off) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTransactionOnSaleItem:update()
    local conImage = GetElement(self.m_root,"conIcon_CellTransactionItem",WZUIContainer)
    local key = "id_"..self.m_tData.itemIds
	local tData = GDatatab_item[key]
    local cell,tcell = CellGoodItem:createElement()
	cell:setScale(0.8)
    if cell then
        cell = WZUIContainer:luaTo(cell)
        if tData ~= nil then
            self.m_tData.name = tData.name
            self.m_tData.path = tData.icon
            self.m_tData.lastNum =  self.m_tData.quantitys
            self.m_tData.quality = tData.quality
			self.m_tData.basicInfo = CopyTable(tData)
			if WndTransaction.m_nRightTag == 2 then
				self.m_tData.lastNum = self.m_tData.quantitys - self.m_tData.saleNums
			end
        	tcell:setCellGoodItem(self.m_tData,10)

			--物品名字
			GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.name)
			--名字颜色
			local quality = self.m_tData.basicInfo.quality
			if quality == 0 then quality = 1 end
			GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
        else
            WZLog(key.."不在GDatatab_item")
        end
        conImage:addChild(cell)
    end

	--数量
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.lastNum)
	--单价
	local itemId = self.m_tData.basicInfo.id
	local t = GDatatab_treasure["id_"..itemId]
	if WndTransaction.m_nRightTag == 2 then
		GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(t.sell_price[1][2])
		GetElement(self.m_root,"txt5_CellTransactionItem",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"conRecycle",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txt5_CellTransactionItem",WZUILabelTTF):setText(string.format(LocalStrings.TRANSACTION53, self.m_tData.saleNums))
		if self.m_tData.saleTime >= 1440 then
			local day = math.floor(self.m_tData.saleTime / 1440)
			local hour = math.floor(self.m_tData.saleTime / 60) % 24
			GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setText(day..LocalStrings.DAY..hour..LocalStrings.HOUR1)
		elseif self.m_tData.saleTime >=60 then
			local hour = math.floor(self.m_tData.saleTime / 60)
			GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setText(hour..LocalStrings.HOUR1)
		else
			GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.saleTime..LocalStrings.MINUTE1)
		end
		--GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.lastNum-self.m_tData.saleNums)

	elseif WndTransaction.m_nRightTag == 3 then
		GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(t.recovery_price[1][2])
		GetElement(self.m_root,"txt5_CellTransactionItem",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"conRecycle",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.TRANSACTION29..":")
		GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.lastNum*t.recovery_price[1][2])
	end
end





-------------------------------------私有方法模块End----------------------------------------

function CellTransactionOnSaleItem:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472143,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.639796,0.575))
end

function CellTransactionOnSaleItem:_adaptLanguage_th(  )
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43949,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.554082,0.575))

	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.512959,0.41))
	GetElement(self.m_root,"imgGem_CellTransactionOnSaleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.742753,0.401317))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.79102,0.4))
end

function CellTransactionOnSaleItem:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472143,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.639796,0.575))

	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.386429,0.41))
	GetElement(self.m_root,"imgGem_CellTransactionOnSaleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.497855,0.401317))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.550204,0.4))

	GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.126939,0.18))
	GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.661837,0.18))

end

function CellTransactionOnSaleItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472143,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.639796,0.575))

	local txt7 = GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF)
	txt7:setScale(0.7)
	txt7:setRelativePosition(GlobalMethod:ccp(0.065,0.18))
	local imgGem2 = GetElement(self.m_root,"imgGem2_CellTransactionOnSaleItem",WZUIImage)
	imgGem2:setScale(0.5)
	imgGem2:setRelativePosition(GlobalMethod:ccp(0.69,0.191624))
	local txt8 = GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF)
	txt8:setScale(0.7)
	txt8:setRelativePosition(GlobalMethod:ccp(0.75,0.18))
end

function CellTransactionOnSaleItem:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.586735,0.575))
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.41))
	GetElement(self.m_root,"imgGem_CellTransactionOnSaleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.63663,0.401317))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.693061,0.4))

	local txt7 = GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF)
	txt7:setScale(0.7)
	txt7:setRelativePosition(GlobalMethod:ccp(0.065,0.18))
	local imgGem2 = GetElement(self.m_root,"imgGem2_CellTransactionOnSaleItem",WZUIImage)
	imgGem2:setScale(0.5)
	imgGem2:setRelativePosition(GlobalMethod:ccp(0.69,0.191624))
	local txt8 = GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF)
	txt8:setScale(0.7)
	txt8:setRelativePosition(GlobalMethod:ccp(0.75,0.18))
end

function CellTransactionOnSaleItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.58))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.586735,0.575))
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.508878,0.41))
	GetElement(self.m_root,"imgGem_CellTransactionOnSaleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.75,0.401317))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.4))

	local txt7 = GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF)
	txt7:setScale(0.6)
	txt7:setRelativePosition(GlobalMethod:ccp(0.058,0.18))
	local imgGem2 = GetElement(self.m_root,"imgGem2_CellTransactionOnSaleItem",WZUIImage)
	imgGem2:setScale(0.5)
	imgGem2:setRelativePosition(GlobalMethod:ccp(0.72,0.191624))
	local txt8 = GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF)
	txt8:setScale(0.7)
	txt8:setRelativePosition(GlobalMethod:ccp(0.78,0.18))

	-- GetElement(self.m_root,"txtC4T3_WndTransaction",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75,0.475))
	-- GetElement(self.m_root,"txtCon4_WndTransaction",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(260,0))
end

function CellTransactionOnSaleItem:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.75)

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setScale(0.75)
	txt1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt1:setRelativePosition(GlobalMethod:ccp(0.97,0.58))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setScale(0.75)
	txt3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt3:setRelativePosition(GlobalMethod:ccp(0.8,0.575))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setScale(0.75)
	txt2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt2:setRelativePosition(GlobalMethod:ccp(0.97,0.41))
	GetElement(self.m_root,"imgGem_CellTransactionOnSaleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.49,0.401317))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setScale(0.75)
	txt4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt4:setRelativePosition(GlobalMethod:ccp(0.44,0.4))

	GetElement(self.m_root,"txt5_CellTransactionItem",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txt6_CellTransactionItem",WZUILabelTTF):setScale(0.6)

	local txt7 = GetElement(self.m_root,"txt7_CellTransactionItem",WZUILabelTTF)
	txt7:setScale(0.6)
	txt7:setRelativePosition(GlobalMethod:ccp(0.25,0.18))
	local imgGem2 = GetElement(self.m_root,"imgGem2_CellTransactionOnSaleItem",WZUIImage)
	imgGem2:setScale(0.4)
	imgGem2:setRelativePosition(GlobalMethod:ccp(0.21,0.191624))
	local txt8 = GetElement(self.m_root,"txt8_CellTransactionItem",WZUILabelTTF)
	txt8:setScale(0.6)
	txt8:setRelativePosition(GlobalMethod:ccp(0.165,0.18))
	txt8:setAnchorPoint(GlobalMethod:ccp(1,0.5))
end
------------------------------------------------语言适配End-----------------------------------------------------------