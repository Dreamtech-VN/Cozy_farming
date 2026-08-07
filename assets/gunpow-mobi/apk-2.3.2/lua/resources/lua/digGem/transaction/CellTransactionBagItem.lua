--CellTransactionBagItem.lua
--@brief	CellTransactionBagItem的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行商品Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionBagItem:onEnter(element)
	self.m_root = element
end

function CellTransactionBagItem:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.NUM1..":")
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.UNIT_PRICE..":")
	self:update()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionBagItem:onExit(element)
	self:_unInit()
end

function CellTransactionBagItem:onClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndTransaction.m_nRightTag == 2 then
    	self.m_tData.tBtnList = {LocalStrings.TRANSACTION20}
    	WndItemInfo:showInfo(element,WndTransaction.m_root,1,self.m_tData)
    	WndItemInfo:setClickButtonCallback(self,self.onAdd)
	elseif WndTransaction.m_nRightTag == 3 then
		if self.m_tData.isCover == true then
			--取消回收
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
		else
			--回收
			if self.m_tData.lastNum <= 1 then
				if WndTransaction.m_tDataList3 == nil then WndTransaction.m_tDataList3 = {} end
				if #WndTransaction.m_tDataList3 >= 10 then MsgBoxManager:showTipBox(LocalStrings.TRANSACTION52) return end
				local itemIds = self.m_tData.itemIds
				local itemTag = self.m_tData.itemTag
				--回收商品刷新界面
				local tData = CopyTable(self.m_tData)
				tData.quantitys = 1
				table.insert(WndTransaction.m_tDataList3, tData)
				WndTransaction:updateRight3()
				--回收商品显示遮罩
				for i=1,#WndTransaction.m_tDataList do
        			if WndTransaction.m_tDataList[i].itemIds == itemIds 
						and WndTransaction.m_tDataList[i].itemTag == itemTag then
						WndTransaction.m_tDataList[i].isCover = true
					end
				end
				WndTransaction:updateBag()
				return
			end
			self.m_tData.winType = 3
			WndTransactionOperate:show(self.m_tData)
		end
	end
end

function CellTransactionBagItem:onAdd(tag, tData)
	WZLog("CellTransactionBagItem:onAdd")
	tData.winType = 2
	WndTransactionOperate:show(tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellTransactionBagItem:update()
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
            self.m_tData.lastNum =  self.m_tData.num
            self.m_tData.quality = tData.quality
			self.m_tData.basicInfo = CopyTable(tData)
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

	if self.m_tData.isCover == true then
		GetElement(self.m_root,"conSellUp_CellTransactionBagItem",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"conSellUp_CellTransactionBagItem",WZUIContainer):setVisible(false)
	end

	--数量
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.lastNum)
	--单价
	local itemId = self.m_tData.basicInfo.id
	local t = GDatatab_treasure["id_"..itemId]
	if WndTransaction.m_nRightTag == 2 then
		GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(t.sell_price[1][2])
	elseif WndTransaction.m_nRightTag == 3 then
		GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(t.recovery_price[1][2])
	end
end




-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTransactionBagItem:_adaptLanguage_en(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.7)
	txtName:setRelativePosition(GlobalMethod:ccp(0.39,0.747664))
	txtName:setDimensions(GlobalMethod:CCSize(160))

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.566429,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.762041,0.466))
end

function CellTransactionBagItem:_adaptLanguage_th(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.8)

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setScale(0.65)
	txt1:setRelativePosition(GlobalMethod:ccp(0.484796,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setScale(0.65)
	txt3:setRelativePosition(GlobalMethod:ccp(0.593674,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setScale(0.65)
	txt2:setRelativePosition(GlobalMethod:ccp(0.54602,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setScale(0.5)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.766925,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setScale(0.65)
	txt4:setRelativePosition(GlobalMethod:ccp(0.836122,0.230989))
end

function CellTransactionBagItem:_adaptLanguage_vn(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.8)
	
	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.566429,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.762041,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.459286,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setScale(0.5)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.598558,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setRelativePosition(GlobalMethod:ccp(0.662653,0.230989))
end

function CellTransactionBagItem:_adaptLanguage_pt(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.7)
	txtName:setRelativePosition(GlobalMethod:ccp(0.39,0.747664))
	txtName:setDimensions(GlobalMethod:CCSize(160))

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.576633,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.787551,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.505204,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setScale(0.5)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.685293,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setRelativePosition(GlobalMethod:ccp(0.749388,0.230989))
end

function CellTransactionBagItem:_adaptLanguage_es(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.7)
	txtName:setRelativePosition(GlobalMethod:ccp(0.39,0.747664))
	txtName:setDimensions(GlobalMethod:CCSize(160))

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.52,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.680408,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.52,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setScale(0.5)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.736313,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setRelativePosition(GlobalMethod:ccp(0.795306,0.230989))
end

function CellTransactionBagItem:_adaptLanguage_tr(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.7)
	--txtName:setRelativePosition(GlobalMethod:ccp(0.39,0.747664))
	txtName:setDimensions(GlobalMethod:CCSize(160))

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setScale(0.65)
	txt1:setRelativePosition(GlobalMethod:ccp(0.52,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setScale(0.65)
	txt3:setRelativePosition(GlobalMethod:ccp(0.680408,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setScale(0.65)
	txt2:setRelativePosition(GlobalMethod:ccp(0.54602,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setScale(0.4)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.772028,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setScale(0.65)
	txt4:setRelativePosition(GlobalMethod:ccp(0.820817,0.230989))
end

function CellTransactionBagItem:_adaptLanguage_ug(  )
	local txtName = GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF)
	txtName:setScale(0.7)
	txtName:setRelativePosition(GlobalMethod:ccp(0.39,0.747664))
	txtName:setDimensions(GlobalMethod:CCSize(160))
	txtName:setAlignment(kCCTextAlignmentCenter)

	local txt1 = GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF)
	txt1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt1:setRelativePosition(GlobalMethod:ccp(0.96,0.466))
	local txt3 = GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF)
	txt3:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt3:setRelativePosition(GlobalMethod:ccp(0.7,0.466))
	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setScale(0.6)
	txt2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt2:setRelativePosition(GlobalMethod:ccp(0.96,0.232))
	txt2:setDimensions(GlobalMethod:CCSize(80))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionBagItem",WZUIImage)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.65,0.234951))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txt4:setRelativePosition(GlobalMethod:ccp(0.56,0.230989))
end
---------------------------------------语言适配End------------------------------------------