--WndMarry.lua
--@brief	WndMarry的UI模块
--@date		2014/01/07
--@author	叶威
--@note		结婚礼堂模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarry:onEnter(element)
	self.m_root = element

    self:_update()
    --多语言版本界面适配
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(24)
    WZLog("WndMarryHoll:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 21 then
        TeachGroup1:startGroup({24,4,self.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarry:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)--注册物品
	self:_unInit()
end

--@brief	关闭窗口
--@param	element:按钮的引用
function WndMarry:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if element == nil then
		WZLog(" WndMarry:onCloseClick(element) element is nil ")
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  求婚类型点击
function WndMarry:onClickProposeCell(element)
    WZLog("WndMarry:onClickPropose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    GetElement(self.m_root,"imgCell".. self.m_nMarryType .."_WndMarry"):setVisible(false)
    GetElement(self.m_root,"imgCell".. tag .."_WndMarry"):setVisible(true)
    self.m_nMarryType = tag
end

--@brief 点击礼物cell回调
function WndMarry:onClickGiftCell(element)
    WZLog("WndMarry:onClickPropose ---- ")
    local tag = element:getTag()
    tag = tag - 4
    GetElement(self.m_root,"imgGCell".. self.m_nMarryType .."_WndMarry"):setVisible(false)
    GetElement(self.m_root,"imgGCell".. tag .."_WndMarry"):setVisible(true)
    self.m_nMarryType = tag
end

--@brief	点击求婚类型按钮的响应方法
--@param	element:按钮的引用
function WndMarry:onClickPropose(element)
    WZLog("WndMarry:onMarryMothodClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("m_tMarryType:"..self.m_nMarryType)
    
    local proItemCount = self:getProposeItemCount(self.m_nMarryType)
    if proItemCount == 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.MARRY_ITEM_NOT_ENOUGH, self, self.onBuyItemClick, nil, nil)
    else
        local wndMarryLetter = WndMarryLetter:createElement()
        WndMarryLetter:setMarryType(self.m_nMarryType)
        WndMarryLetter:setWindowType(WndMarryLetter.wndType.SEND_LETTER)
        WindowManager:addWindow(wndMarryLetter,WndMarryLetter,nil,nil,nil,true)
    end
end

--@brief  点击赠送礼物
function WndMarry:onClickSendGift(element)
    WZLog("WndMarry:onClickSendGift")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_nSendGiftCount <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.SEND_GIFT_TIP)
        return
    end

    local giftCount = CacheCenter:getPlayerItemCountById(self.m_tGiftData[self.m_nMarryType])
    if giftCount <=0  then
        MsgBoxManager:showConfirmBox(LocalStrings.NO_GIFT,self,self.onBuyGiftClick, nil, nil)
        return
    end

    if self.m_tCallbackF ~= nil then
        local buyId =self.m_tGiftData[self.m_nMarryType]
        self.m_tCallbackF(self.m_tCallbackT,buyId)
    end
end

--@brief 点击购买道具确认按钮的响应函数
--@param  id:消息的id，nType:消息响应类型
function WndMarry:onBuyItemClick(id,nType)
    --确定购买
    if nType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndMarry:onBuyItemClick")
        local buyId = WndMarryManager.itemIds[self.m_nMarryType]
        WndPurchase:showBuyInterface(6,buyId,nil,nil,nil)
    end
end

--@brief 点击购买道具确认按钮的响应函数
--@param  id:消息的id，nType:消息响应类型
function WndMarry:onBuyGiftClick(id,nType)
    --确定购买
    if nType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndMarry:onBuyItemClick")
        local buyId =self.m_tGiftData[self.m_nMarryType]
        WndPurchase:showBuyInterface(6,buyId,nil,nil,nil)
    end
end

--@brief	点击说明按钮的响应方法
--@param	element:按钮的引用
function WndMarry:onIntroClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.Propose_Desc)
    TeachGroup1:endTeachStep({24,4})
end

--@brief  获取求婚道具数量
function WndMarry:getProposeItemCount(itemType)
    local itemCount = nil
    if itemType == WndMarryManager.marryType.DREAM then
       itemCount = CacheCenter:getPlayerItemCountById(152) 
    elseif itemType == WndMarryManager.marryType.ROMAN then
       itemCount = CacheCenter:getPlayerItemCountById(153) 
    elseif itemType == WndMarryManager.marryType.WARM then
       itemCount = CacheCenter:getPlayerItemCountById(151) 
    elseif itemType == WndMarryManager.marryType.SIMPLE then
       itemCount = CacheCenter:getPlayerItemCountById(150) 
    end
    if itemCount == nil then
        itemCount = 0
    end
    return itemCount
end

--@brief  监听玩家数据更改
function WndMarry:updatePlayerItemData()
    WZLog("WndMarry:updatePlayerItemData")
    WndMarry:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMarry:_update()
    if self.m_nOperType == 1 then
        ChangeChatChannel(Chat_Channel_Marry_N)
        for i=1,4 do
            local txtProposeCost = GetElement(self.m_root,"txtProposeCost" .. i .. "_WndMarry",WZUILabelTTF)
            local itemCount = self:getProposeItemCount(i)
            txtProposeCost:setText("X" .. itemCount)
        end
        GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF):setText(LocalStrings.MARRY_PROPOSE)
        GetElement(self.m_root,"txtTitle_WndMarry",WZUILabelTTF):setText(LocalStrings.SELECT_MARRYGIFT_ITEM)
    elseif self.m_nOperType == 2 then
        ChangeChatChannel(Chat_Channel_Marry_Send_Gift)
        for i=1,4 do
            local giftInfo = GDatatab_item["id_"..self.m_tGiftData[i]]
            local icon = giftInfo.icon
            if icon == "shopitems/marry_05.png" then
                icon = "ui/marrige/common_icon_xq.png"
            elseif icon == "shopitems/marry_06.png" then
                icon = "ui/marrige/common_icon_yyh.png"
            elseif icon == "shopitems/marry_07.png" then
                icon = "ui/marrige/common_icon_qkldg.png"
            elseif icon == "shopitems/marry_08.png" then
                icon = "ui/marrige/common_icon_qlgz.png"
            end
            GetElement(self.m_root,"conProp" .. i .."_WndMarry",WZUIContainer):setVisible(false)
            GetElement(self.m_root,"conGift" .. i .."_WndMarry",WZUIContainer):setVisible(true)
            local giftCount = CacheCenter:getPlayerItemCountById(self.m_tGiftData[i])
            GetElement(self.m_root,"txtProposeCost" .. i .. "_WndMarry",WZUILabelTTF):setText("X"..giftCount)
            GetElement(self.m_root,"imgGift" .. i .. "_WndMarry",WZUIImage):setFile(icon)

            GetElement(self.m_root,"txtGift" .. i .. "_WndMarry",WZUILabelTTF):setText(giftInfo.name)
        end
        GetElement(self.m_root,"btnPropose_WndMarry",WZUIButton):setVisible(false)
        GetElement(self.m_root,"txtBtnSendGift_WndMarry",WZUILabelTTF):setText(LocalStrings.GIVE)
        GetElement(self.m_root,"btnSendGift_WndMarry",WZUIButton):setVisible(true)
        GetElement(self.m_root,"txtTitle_WndMarry",WZUILabelTTF):setText(LocalStrings.SELECT_GIFT_TYPE)
        GetElement(self.m_root,"conExplain_WndMarry",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"imgTitle_WndMarry",WZUIImage):setFile("ui/common/common_icon_slw.png")
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

function WndMarry:_adaptLanguage_vn()
    WZLog("WndMarry:_adaptLanguage_vn")
    local txtGift1 = GetElement(self.m_root,"txtGift1_WndMarry",WZUILabelTTF)
    txtGift1:setColor(GlobalMethod:ccc3(255,236,193))
    txtGift1:setFontSize(20)

    local txtGift2 = GetElement(self.m_root,"txtGift2_WndMarry",WZUILabelTTF)
    txtGift2:setColor(GlobalMethod:ccc3(255,236,193))
    txtGift2:setFontSize(20)

    local txtGift3 = GetElement(self.m_root,"txtGift3_WndMarry",WZUILabelTTF)
    txtGift3:setColor(GlobalMethod:ccc3(255,236,193))
    txtGift3:setFontSize(20)
    
    local txtGift4 = GetElement(self.m_root,"txtGift4_WndMarry",WZUILabelTTF)
    txtGift4:setColor(GlobalMethod:ccc3(255,236,193))
    txtGift4:setFontSize(20)
end

function WndMarry:_adaptLanguage_th()
    GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF):setScale(0.65)
end

function WndMarry:_adaptLanguage_en()
    GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF):setScale(0.6)
end

function WndMarry:_adaptLanguage_pt()
   local txtBtnPropose = GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF)
   txtBtnPropose:setScale(0.6)
   txtBtnPropose:setDimensions(GlobalMethod:CCSize(150))
end

function WndMarry:_adaptLanguage_es(  )
    local txtBtnPropose = GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF)
    txtBtnPropose:setScale(0.6)
    txtBtnPropose:setDimensions(GlobalMethod:CCSize(150))

    for i=1,4 do
        local txtGift = GetElement(self.m_root,"txtGift"..i.."_WndMarry",WZUILabelTTF)
        txtGift:setFontSize(16)
        txtGift:setDimensions(GlobalMethod:CCSize(170,0))
    end
end

function WndMarry:_adaptLanguage_tr()
    GetElement(self.m_root,"txtBtnPropose_WndMarry",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配模块End----------------------------------------



