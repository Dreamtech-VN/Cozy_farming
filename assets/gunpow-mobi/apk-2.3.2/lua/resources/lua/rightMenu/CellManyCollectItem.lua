--CellManyCollectItem.lua
--@brief	CellManyCollectItem的UI模块
--@date		2017/09/26
--@author	Tianxiang_Xu
--@note		全民众筹活动——各众筹


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellManyCollectItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellManyCollectItem:onExit(element)
	self:_unInit()
end

--@brief    其它Item点击回调
function CellManyCollectItem:onItemClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellManyCollectPanel.m_current.m_root,1,tData,false)
end

--@brief    点击入股按钮回调
function CellManyCollectItem:onClickJoin(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_tData.joinType == 0 and self.m_tData.buyNum > 0 then 
        MsgBoxManager:showTipBox(LocalStrings.MANYCOLLECT_TEXT14)
        return 
    end
    WndChooseStockNum:showInterface(self.m_tData)
end

--@brief    开始加载
function CellManyCollectItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellManyCollectItem")
    self.m_root:addChild(celElement)

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellManyCollectItem:_update()
    -- body
    self:_showPriceAndReward()
    self:_showCollectProgress()
end

--@brief    显示股价、奖励
function CellManyCollectItem:_showPriceAndReward()
    -- body
    --股价
    local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellManyCollectItem", WZUIFreeTextBox)
    if ftxtPrice then 
        local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%d</T><I Z="0.35" P="1">%s</I>]]
        local tBasicData = GDatatab_item["id_" .. self.m_tData.priceId]
        ftxtPrice:setShowText(string.format(sFormat, LocalStrings.MANYCOLLECT_TEXT7, self.m_tData.price, tBasicData.icon))
    end
    --入股奖励
    local con1 = GetElement(self.m_root, "con1_CellManyCollectItem", WZUIContainer)
    if con1 then 
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(self.m_tData.itemId1, self.m_tData.num1, 17)
            tNewObj:setItemClickFun(self, self.onItemClick)
            tNewObj:clearItemQualityPic(true)
            element:setScale(0.90)
            con1:addChild(element)
        end 
    end
    --众筹大奖
    local con2 = GetElement(self.m_root, "con2_CellManyCollectItem", WZUIContainer)
    if con2 then 
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(self.m_tData.itemId2, self.m_tData.num2, 17)
            tNewObj:setItemClickFun(self, self.onItemClick)
            tNewObj:setBackImgFile("ui/common/common_icon_di.png")
            element:setScale(0.90)
            con2:addChild(element)
        end 
    end

    AdaptLanguage(self)
end

--@brief    众筹进度
function CellManyCollectItem:_showCollectProgress()
    -- body
    local prgCollect = GetElement(self.m_root, "prgCollect_CellManyCollectItem", WZUIProgress)
    if prgCollect then 
        prgCollect:setPercentage(math.floor(100 * self.m_tData.curNum / self.m_tData.totalNum))
    end

    local txtNum = GetElement(self.m_root, "txtNum_CellManyCollectItem", WZUILabelTTF)
    if txtNum then 
        txtNum:setText(tostring(self.m_tData.curNum) .. "/" .. tostring(self.m_tData.totalNum))
    end
end


-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配Begin----------------------------------------
function CellManyCollectItem:_adaptLanguage_vn(  )
    local txtMsgInfoName = GetElement(self.m_root,"txtMsgInfoName_CellManyCollectItem",WZUILabelTTF)
    txtMsgInfoName:setScale(0.8)
    txtMsgInfoName:setRelativePosition(GlobalMethod:ccp(0.025,0.5))
    GetElement(self.m_root, "ftxtPrice_CellManyCollectItem", WZUIFreeTextBox):setScale(0.8)
    local manyProgress = GetElement(self.m_root,"manyProgress",WZUIContainer)
    if manyProgress then
        manyProgress:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    end
end

function CellManyCollectItem:_adaptLanguage_pt(  )
    local txtMsgInfoName = GetElement(self.m_root,"txtMsgInfoName_CellManyCollectItem",WZUILabelTTF)
    txtMsgInfoName:setScale(0.7)
    txtMsgInfoName:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txtMsgInfoName:setDimensions(GlobalMethod:CCSize(160))    
    GetElement(self.m_root, "ftxtPrice_CellManyCollectItem", WZUIFreeTextBox):setScale(0.7)
    local txt1 = GetElement(self.m_root,"txt1_CellManyCollectItem",WZUILabelTTF)
    txt1:setScale(0.7)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt1:setDimensions(GlobalMethod:CCSize(150))
    local txt2 = GetElement(self.m_root,"txt2_CellManyCollectItem",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt2:setDimensions(GlobalMethod:CCSize(150))

    local txtBtn = GetElement(self.m_root, "txtBtn_CellManyCollectItem", WZUILabelTTF)
    txtBtn:setScale(0.7)
    txtBtn:setDimensions(GlobalMethod:CCSize(150))
end

function CellManyCollectItem:_adaptLanguage_es(  )
    local txtMsgInfoName = GetElement(self.m_root,"txtMsgInfoName_CellManyCollectItem",WZUILabelTTF)
    txtMsgInfoName:setScale(0.7)
    txtMsgInfoName:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txtMsgInfoName:setDimensions(GlobalMethod:CCSize(160))    
    GetElement(self.m_root, "ftxtPrice_CellManyCollectItem", WZUIFreeTextBox):setScale(0.7)
    local txt1 = GetElement(self.m_root,"txt1_CellManyCollectItem",WZUILabelTTF)
    txt1:setScale(0.7)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt1:setDimensions(GlobalMethod:CCSize(150))
    local txt2 = GetElement(self.m_root,"txt2_CellManyCollectItem",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt2:setDimensions(GlobalMethod:CCSize(150))

    local txtBtn = GetElement(self.m_root, "txtBtn_CellManyCollectItem", WZUILabelTTF)
    txtBtn:setScale(0.7)
    txtBtn:setDimensions(GlobalMethod:CCSize(150))
end

function CellManyCollectItem:_adaptLanguage_en(  )
    local txtMsgInfoName = GetElement(self.m_root,"txtMsgInfoName_CellManyCollectItem",WZUILabelTTF)
    txtMsgInfoName:setScale(0.7)
    txtMsgInfoName:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txtMsgInfoName:setDimensions(GlobalMethod:CCSize(160))    
    GetElement(self.m_root, "ftxtPrice_CellManyCollectItem", WZUIFreeTextBox):setScale(0.7)
    local txt1 = GetElement(self.m_root,"txt1_CellManyCollectItem",WZUILabelTTF)
    txt1:setScale(0.7)
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt1:setDimensions(GlobalMethod:CCSize(150))
    local txt2 = GetElement(self.m_root,"txt2_CellManyCollectItem",WZUILabelTTF)
    txt2:setScale(0.7)
    txt2:setRelativePosition(GlobalMethod:ccp(0.5,0.0125))
    txt2:setDimensions(GlobalMethod:CCSize(150))

    local txtBtn = GetElement(self.m_root, "txtBtn_CellManyCollectItem", WZUILabelTTF)
    txtBtn:setScale(0.7)
    txtBtn:setDimensions(GlobalMethod:CCSize(150))
end

function CellManyCollectItem:_adaptLanguage_th(  )
    local txtMsgInfoName = GetElement(self.m_root,"txtMsgInfoName_CellManyCollectItem",WZUILabelTTF)
    txtMsgInfoName:setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------