--CellTransactionItem.lua
--@brief	CellTransactionItem的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行商品Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionItem:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function CellTransactionItem:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.NUM1..":")
	--GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.TRANSACTION56..":")
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setText(LocalStrings.UNIT_PRICE..":")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionItem:onExit(element)
	self:_unInit()
end

function CellTransactionItem:onClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_tData.tBtnList = {LocalStrings.BUY}
    WndItemInfo:showInfo(element,WndTransaction.m_root,1,self.m_tData)
    WndItemInfo:setClickButtonCallback(self,self.onBuy)
end

function CellTransactionItem:onBuy(tag, tData)
	WZLog("CellTransactionItem:onBuy")
	tData.winType = 1
	WndTransactionOperate:show(tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTransactionItem:update()
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
	--GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.prices*self.m_tData.lastNum)
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setText(self.m_tData.prices)
	if self.m_tData.lastNum <= 0 then
		GetElement(self.m_root,"conSellUp_CellTransactionItem",WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root,"conSellUp_CellTransactionItem",WZUIContainer):setVisible(false)
	end
end




-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTransactionItem:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472143,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.639796,0.466))
end

function CellTransactionItem:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.427245,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.533673,0.466))
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.496633,0.232))
	GetElement(self.m_root,"imgGem_CellTransactionItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.722344,0.236047))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.770612,0.24))
end

function CellTransactionItem:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.468061,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.627551,0.466))
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.382347,0.232))
	GetElement(self.m_root,"imgGem_CellTransactionItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.493772,0.236047))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.546122,0.24))
end

function CellTransactionItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"conIcon_CellTransactionItem",WZUIContainer):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.472143,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.639796,0.466))
	
end

function CellTransactionItem:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.8)
	
	GetElement(self.m_root,"conIcon_CellTransactionItem",WZUIContainer):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.586735,0.466))
	GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.232))
	GetElement(self.m_root,"imgGem_CellTransactionItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.63663,0.236047))
	GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.693061,0.24))
	
end

function CellTransactionItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtName_CellTransactionItem",WZUILabelTTF):setScale(0.8)
	
	GetElement(self.m_root,"conIcon_CellTransactionItem",WZUIContainer):setScale(0.75)

	GetElement(self.m_root,"txt1_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.466))
	GetElement(self.m_root,"txt3_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.586735,0.466))
	-- GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.232))
	-- GetElement(self.m_root,"imgGem_CellTransactionItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.63663,0.236047))
	-- GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.693061,0.24))

	local txt2 = GetElement(self.m_root,"txt2_CellTransactionItem",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.508878,0.232))
	local imgGem = GetElement(self.m_root,"imgGem_CellTransactionItem",WZUIImage)
	imgGem:setScale(0.5)
	imgGem:setRelativePosition(GlobalMethod:ccp(0.750916,0.236047))
	local txt4 = GetElement(self.m_root,"txt4_CellTransactionItem",WZUILabelTTF)
	txt4:setRelativePosition(GlobalMethod:ccp(0.795102,0.24))
	
end
---------------------------------------语言适配End------------------------------------------