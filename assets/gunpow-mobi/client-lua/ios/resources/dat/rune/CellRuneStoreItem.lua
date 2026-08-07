--CellRuneStoreItem.lua
--@brief	CellRuneStoreItem的UI模块
--@date		2017/03/22
--@author	qixiang
--@note		符文商店item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRuneStoreItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRuneStoreItem:onExit(element)
	self:_unInit()
end


function CellRuneStoreItem:onLoadData(element)
	WZLog("CellRuneStoreItem:onLoadData")
	self:init()
    AdaptLanguage(self)
end

function CellRuneStoreItem:init()
	WZLog("CellRuneStoreItem:init")
	-- body
	-- 商品图标
    local qualityPic5 = {"ui/common/common_icon_lg.png",
                    "ui/common/common_icon_ng.png",
                    "ui/common/common_icon_zg.png",
                    "ui/common/common_icon_hg.png"}

    local playerInfo = CacheCenter:getPlayerInfo()
    local shopId = self.tData[1]
    local getElement = GetElement
    local txtName = getElement(self.m_root,"txtPropName_CellRuneStoreItem",WZUILabelTTF)

    local itemInfo = nil
    local itemPri = nil
    local playerInfo = CacheCenter:getPlayerInfo()
    for k,v in pairs(GDatatab_rune_shop) do
    	if v.id == shopId then
    		itemPri = v.price
    		if playerInfo.sex == 0 then
    			itemInfo = v.item_boy
    			break
    		elseif playerInfo.sex == 1 then
    			itemInfo = v.item_girl
    			break
    		end
    	end
    end
    
    local gDatatab_item = GDatatab_item
    local itemBaiceInfo = gDatatab_item["id_" ..itemInfo[1][1]]
    txtName:setText(itemBaiceInfo.name)
    txtName:setColor(QUALITYCOLOR[itemBaiceInfo.quality])

    self.m_tShopItem = itemInfo
	self.m_nQuality = itemBaiceInfo.quality
	self.m_nItemCount = itemInfo[1][2]
	self.m_tItemProperty = itemBaiceInfo.property
	self.m_sItemName = itemBaiceInfo.name
	self.m_sItemImage = itemBaiceInfo.icon

    local imgBg = getElement(self.m_root,"imgBg_CellRuneStoreItem",WZUIImage)
    imgBg:setFile(qualityPic5[itemBaiceInfo.quality])
    local imgRune =  getElement(self.m_root,"imgRune_CellRuneStoreItem",WZUIImage)
    imgRune:setFile(itemBaiceInfo.icon)

    local imgCost = getElement(self.m_root,"imgCost_CellRuneStoreItem",WZUIImage)
    local txtCost = getElement(self.m_root,"txtCost_CellRuneStoreItem",WZUILabelTTF)
    imgCost:setFile(gDatatab_item["id_" .. itemPri[1][1]].icon)
    txtCost:setText(itemPri[1][2])
    self.m_nCostId = itemPri[1][1]
	self.m_nCostNum = itemPri[1][2]
    if self.tData[2] <= 0 then
    	local conSell = getElement(self.m_root,"conSell_CellRuneStoreItem",WZUIContainer)
    	conSell:setVisible(true)
    end
    if self.tData[2] <= 0 then
        local conS = GetElement(self.m_root,"conSell_CellRuneStoreItem",WZUIContainer)
        conS:setVisible(true)
    end
end

--购买
function CellRuneStoreItem:onClickBuy(element)
	WZLog("CellRuneStoreItem:onClickBuy")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local itemBaiceInfo = GDatatab_item["id_" .. self.m_tShopItem[1][1]]
	self.m_tItemProperty = itemBaiceInfo.property
	local title1 = ""
	local title2 = ""
	local title3 = ""

	local valve1 = ""
	local valve2 = ""
	local valve3 = ""
    
	if #self.m_tItemProperty == 1 then
		title1 = ATTR_TITLE[self.m_tItemProperty[1][1]]
		valve1 = self.m_tItemProperty[1][2]
	elseif  #self.m_tItemProperty == 2 then
		title1 = ATTR_TITLE[self.m_tItemProperty[1][1]]
		valve1 = self.m_tItemProperty[1][2]

		title2 = ATTR_TITLE[self.m_tItemProperty[2][1]]
		valve2 = self.m_tItemProperty[2][2]
	elseif #self.m_tItemProperty == 3 then
		title1 = ATTR_TITLE[self.m_tItemProperty[1][1]]
		valve1 = self.m_tItemProperty[1][2]

		title2 = ATTR_TITLE[self.m_tItemProperty[2][1]]
		valve2 = self.m_tItemProperty[2][2]

		title3 = ATTR_TITLE[self.m_tItemProperty[3][1]]
		valve3 = self.m_tItemProperty[3][2]
	end

	local tData = {["img"]=self.m_sItemImage,["title"]=self.m_sItemName,["txtColor"]=QUALITYCOLOR[itemBaiceInfo.quality],["num"]=self.m_nItemCount,
		["attrTitle1"]=title1,["attrTitle2"]=title2,["attrTitle3"]=title3,["attrVal1"]=valve1,["attrVal2"]=valve2,["attrVal3"]=valve3,["callbackLua"]=self,["callbackLuaFun"]=self.clickBuyCallBack}	
	WndTips:show(element,WndStore.m_root,35,tData,GlobalMethod:ccp(80,0))

end

function CellRuneStoreItem:clickBuyCallBack()
	WZLog("CellRuneStoreItem:clickBuyCallBack")
	if JudgeMoneyIsEnough(self.m_nCostId,self.m_nCostNum,nil,nil,198) then
        WndStore:setItemTag(self.m_root:getTag())
        ProtocolProcessorStore:send_RUNE_BuyCommodity(self.tData[1])
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellRuneStoreItem:_adaptLanguage_pt(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellRuneStoreItem",WZUILabelTTF)
    txtPropName:setScale(0.75)
    txtPropName:setDimensions(GlobalMethod:CCSize(200))
end

function CellRuneStoreItem:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtPropName_CellRuneStoreItem",WZUILabelTTF):setFontSize(15)
end

function CellRuneStoreItem:_adaptLanguage_es(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellRuneStoreItem",WZUILabelTTF)
    txtPropName:setScale(0.7)
    txtPropName:setDimensions(GlobalMethod:CCSize(200))
end

function CellRuneStoreItem:_adaptLanguage_tr(  )
    local txtPropName = GetElement(self.m_root,"txtPropName_CellRuneStoreItem",WZUILabelTTF)
    txtPropName:setScale(0.7)
    txtPropName:setDimensions(GlobalMethod:CCSize(200))
end
-------------------------------------语言适配End--------------------------------------------