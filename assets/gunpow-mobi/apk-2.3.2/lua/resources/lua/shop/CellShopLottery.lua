--CellShopLottery.lua
--@brief	CellShopLottery的UI模块
--@date		2017/08/28
--@author	zsq
--@note		商城抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopLottery:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopLottery:onExit(element)
	self:_unInit()
end

function CellShopLottery:setHighLight(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"conSel_CellShopLottery",WZUIContainer):setVisible(bool)
end

function CellShopLottery:setHighLightFinal(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"conSelFinal_CellShopLottery",WZUIContainer):setVisible(bool)
end

function CellShopLottery:setData(tData) 
	self.m_tData = tData
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellShopLottery:_update() 
	if self.m_root == nil then return end
	local tData = self.m_tData
	local basicInfo = GDatatab_item["id_"..tData.itemId]
    local name = basicInfo.name
    local path = basicInfo.icon
    local num =  tData.itemNum
    local quality = basicInfo.quality
    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=basicInfo}
	--稀有
	if tData.rare == 1 then
		GetElement(self.m_root,"imgRare",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgRare1",WZUIImage):setVisible(true)
		GetElement(self.m_root, "imgRare2_CellShopLottery", WZUIImage):setVisible(false)
	elseif tData.rare == 2 then
		GetElement(self.m_root,"imgRare",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgRare1",WZUIImage):setVisible(true)
		GetElement(self.m_root, "imgRare2_CellShopLottery", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgRare",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgRare1",WZUIImage):setVisible(false)
		GetElement(self.m_root, "imgRare2_CellShopLottery", WZUIImage):setVisible(false)
	end

	--名字
	local name = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	name:setText(basicInfo.name)
	-- name:setColor(QUALITYCOLOR[basicInfo.quality])

    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItem_CellShopLottery", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(itemInfo,17)
        cell:setScale(0.8)
        conItemIcon:addChild(cell)
    end

	--数量
	GetElement(self.m_root,"txtNum",WZUILabelTTF):setText("")--tData.itemNum)
end

function CellShopLottery:onClick(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = self.m_tData
	local basicInfo = GDatatab_item["id_"..tData.itemId]
                local name = basicInfo.name
                local path = basicInfo.icon
                local num =  tData.itemNum
                local quality = basicInfo.quality
                local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=basicInfo}
    	local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    	WndItemInfo:showInfo(element,con,1,itemInfo,false,nil,nil,nil)
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellShopLottery:_adaptLanguage_vn(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.8)
	txtDescript:setDimensions(GlobalMethod:CCSize(210))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.5,0.0377714))
end

function CellShopLottery:_adaptLanguage_th(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.8)
	txtDescript:setDimensions(GlobalMethod:CCSize(210))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.5,0.0377714))
end

function CellShopLottery:_adaptLanguage_en(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.8)
	txtDescript:setDimensions(GlobalMethod:CCSize(210))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.5,0.0377714))
end

function CellShopLottery:_adaptLanguage_pt(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setDimensions(GlobalMethod:CCSize(240))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.501443,0.0199147))
end

function CellShopLottery:_adaptLanguage_es(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setDimensions(GlobalMethod:CCSize(240))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.501443,0.0199147))
end

function CellShopLottery:_adaptLanguage_tr(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setDimensions(GlobalMethod:CCSize(240))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.501443,0.0199147))

	GetElement(self.m_root,"imgRare",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.16484,0.736709))
end

function CellShopLottery:_adaptLanguage_ug(  )
	local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
	txtDescript:setScale(0.6)
	txtDescript:setDimensions(GlobalMethod:CCSize(240))
	txtDescript:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	txtDescript:setRelativePosition(GlobalMethod:ccp(0.501443,0.0199147))
end
-------------------------------------语言适配End----------------------------------------