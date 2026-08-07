--CellTotalRechargeItem.lua
--@brief	CellTotalRechargeItem的UI模块
--@date		2014/12/02
--@author	wuweidong
--@note		活动_累计充值子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTotalRechargeItem:onEnter(element)
	self.m_root = element
    CellTotalRechargeItem.m_click_current = self
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTotalRechargeItem:onExit(element)
	self:_unInit()
end
--@brief    加载item
function CellTotalRechargeItem:ShowCellItem(  )
    -- 适配回归活动界面
    if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE then
        GetElement(self.m_root,"imgBg_CellTotalRechargeItem",WZUI9Image):setFile("ui/gameActivity/returnee/daozhu_di1.png")
        local conBg = GetElement(self.m_root,"conBg_CellTotalRechargeItem",WZUIContainer)
        conBg:setAbsContentSize(GlobalMethod:CCSize(600,96))
        conBg:updateRelativeSize()
        for i=1,4 do
            local img_con = GetElement(self.m_root,"img_con_"..i.."_Item",WZUIContainer)
            img_con:setRelativePosition(GlobalMethod:ccp(0.103+(i-1)*0.141,0.67))
        end
        GetElement(self.m_root,"conBtn_CellTotalRechargeItem",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.776,0.467))
        local descFreeText = GetElement(self.m_root,"descFreeText",WZUIFreeTextBox)
        descFreeText:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        descFreeText:setRelativePosition(GlobalMethod:ccp(0.776,-0.146))
        GetElement(self.m_root,"img9MsgBg_CellTotalRechargeItem",WZUI9Image):setVisible(false)
    end

    AdaptLanguage(self)
    self:_initItemMsg()
    self:_setRewardList()
end

--@brief    获取奖励按钮回调
function CellTotalRechargeItem:event_getReward( )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY and -1 == tonumber(self.status) then 
        local nCurNum = tonumber(self.m_nCurTarget)
        WndGameActivity:closeGameActivity()
        JumpByUIId(nCurNum)
        return 
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        local sdkData = {}
        local vipData = GDatatab_recharge["id_" .. self.m_nCurTarget]
        sdkData.id = self.m_nCurTarget
        sdkData.price = vipData.price
        sdkData.productName = vipData.name
        sdkData.payCode = GetPayCodeIdByChannelId(vipData)
        sdkData.quantifier = LocalStrings.SHOP_IND
        sdkData.number = "1"
        sdkData.giftNumber = "0"
        sdkData.productDesc = vipData.name

        PassportSdkManager:getOrderNum(sdkData)
        return 
    end
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
	NOTRECYCLESKINIDS = {}
	COPYSKINDATA = CopyTable(WndPhantom.m_tDataList)

    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    CellTotalRechargeItem.m_current_click = self
    if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST then 
        CellTotalRechargetPanel.m_current:setItemCell(self)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.typeIndex, self.rewardId)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        CellTotalRechargetPanel.m_current:setItemCell(self)
        local tData = {}
        tData.id = self.rewardId
        local strData = json.encode(tData)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.typeIndex, 2, strData)
    else
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.typeIndex,self.rewardId)
    end
end

--设置是什么类型的奖励项
function CellTotalRechargeItem:setIndex( index,target, nCurTarget)
    self.Parameters3 = index 
    self.Parameters2 = target 
    self.m_nCurTarget = nCurTarget
end

function CellTotalRechargeItem:setGradeIndex(GradeIndex)
    self.GradeIndex = GradeIndex 
    WZLog("=========wwd=========="..self.GradeIndex)
end

function CellTotalRechargeItem:setRechargeDay(nRechargeDay)
    self.m_nRechargeDays = nRechargeDay 
end

--@brief    加载cell数据信息
function CellTotalRechargeItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellTotalRechargeItem")
    self.m_root:addChild(cellElement)

    self:ShowCellItem()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif    设置Item显示的信息
function CellTotalRechargeItem:_initItemMsg(  )
    --WZLog("---*************---1111",self.status)
    self:_crateLableTTF( self.Parameters3 )
-- self.status = 1 --已领取
-- self.status = -1 --不可领取
-- self.status = 2 --可领取
    local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    txt_button_item:setText(LocalStrings.ACTIVE_BTN_GET)

    local btn_getReward_item = GetElement(self.m_root,"btn_getReward_item",WZUIButton)
    if btn_getReward_item == nil then
        return
    end
    if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
        txt_button_item:setUseSystemFont(true)
        if tonumber(self.status) == 0 then 
            btn_getReward_item:setTouchEnable(false)
            txt_button_item:setText(LocalStrings.BOUGHT)

            txt_button_item:setEnableStroke(true)
            txt_button_item:setStrokeSize(4)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
        else
            btn_getReward_item:setTouchEnable(true)
            txt_button_item:setText(self.Parameters2 .. LocalStrings.BUY)
        end
    else
        if -1 == tonumber(self.status) or tonumber(self.status) == 1 then
            if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY and -1 == tonumber(self.status) then 
                btn_getReward_item:setTouchEnable(true)
                txt_button_item:setText(LocalStrings.ACTIVE_BTN_GO)
            else
                btn_getReward_item:setTouchEnable(false)
                if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
                else
                    if tonumber(self.status)==1 then 
                        txt_button_item:setVisible(false)
                        btn_getReward_item:setVisible(false)
                        --已领取
                        self:_ShowGetRewarded()
                    end
                end
                txt_button_item:setEnableStroke(true)
                txt_button_item:setStrokeSize(4)
                txt_button_item:setStrokeColor(GlobalMethod:ccc3(80,61,50))
                txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
            end
        elseif tonumber(self.status) == 2 then 
            if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
                btn_getReward_item:setTouchEnable(false)

                txt_button_item:setText(LocalStrings.MONTH_CARDS_TIP6)
                txt_button_item:setEnableStroke(true)
                txt_button_item:setStrokeSize(4)
                txt_button_item:setStrokeColor(GlobalMethod:ccc3(0,108,3))
                txt_button_item:setColor(GlobalMethod:ccc3(255,250,236))
            end
        elseif tonumber(self.status) == 0 then
            btn_getReward_item:setTouchEnable(true)
        end
    end
end

--@brief    奖励获取成功回调  
function CellTotalRechargeItem:_GetRewardOk(  )
    WZLog("CellTotalRechargeItem:_GetRewardOk")
    local btn_getReward_item = GetElement(self.m_root,"btn_getReward_item",WZUIButton)
    if btn_getReward_item == nil then
        WZLog("btn_getReward_item is nil")
        return
    end
    --btn_getReward_item:setTouchEnable(false)
    local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    --txt_button_item:setText(LocalStrings.ACTIVE_GET)
    txt_button_item:setVisible(false)
    btn_getReward_item:setVisible(false)
    self:_ShowGetRewarded()

    if self.m_FuncCallback ~= nil then 
        local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
        self.m_FuncCallback(tluaObj,self.rewardId)
    end
end


--@brief    显示奖励图标
function CellTotalRechargeItem:_setRewardList()
    local ItemCount = #self.m_tData
    local nIndex = 1 
    WZLog("CellTotalRechargeItem:_setRewardList",ItemCount, Serialize(self.m_tData))
    for i = 1, ItemCount do
        WZLog("CellTotalRechargeItem:_setRewardList", i, self.m_tData[i].id)
        if self.m_tData[i].id ~= -1 then
            local img_con_Item = GetElement(self.m_root,"img_con_"..nIndex.."_Item",WZUIContainer)
            local key = "id_"..self.m_tData[i].id
            local basicInfo = GDatatab_item[key]
            local celElement,tLuaObj = CellGoodItem:createElement()
            if img_con_Item ~= nil and celElement ~= nil and GDatatab_item[key] ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                local itemInfo = {id = self.m_tData[i].id, name = GDatatab_item[key].name, icon = basicInfo.icon, lastTime = self.m_tData[i].num, lastNum = self.m_tData[i].num, quality = basicInfo.quality, basicInfo = CopyTable(basicInfo)}
                tLuaObj:setCellGoodItem(itemInfo,17)
                -- tLuaObj:clearItemQualityPic()
                celElement:setScale(0.90)
                --end
                celElement:setTag(nIndex-1)
                tLuaObj:setItemClickFun(self,self.onOthersClick)
                img_con_Item:addChild(celElement)
            end
            nIndex = nIndex + 1
        end
    end
end

--@brief    其它Item点击回调
function CellTotalRechargeItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndActivityIntegrate.m_root,1,tData,false, nil, true)
end


function CellTotalRechargeItem:_crateLableTTF( target )
    local conMsgInfo = GetElement(self.m_root,"conMsgInfo_CellTotalRechargeItem",WZUIContainer)
    local descFreeText = GetElement(self.m_root,"descFreeText",WZUIFreeTextBox)
    local str_info = ""
    if self.Parameters3 == 6 or self.Parameters3 == 4 or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE 
    or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE 
    or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND 
    or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIF2 
    or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then 
        if self.Parameters3 == 6 or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO then
            str_info = LocalStrings.ACTIVITY_COST_KEY
        elseif self.Parameters3 == 4 or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2
            or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE  then
            str_info = LocalStrings.ACTIVITY_TOTAL_RECHARGE
        end
        if self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET then
            str_info = string.format([[<T C="127,70,26" S="22" P="1">%s</T><T C="229,105,22" S="22" P="1">  %s  </T><I Z="0.5" P="1">shopitems/lizuan.png</I>]],str_info, self.Parameters2)
        else
            str_info = string.format([[<T C="127,70,26" S="22" P="1">%s</T><T C="229,105,22" S="22" P="1">  %s  </T><I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>]],str_info, self.Parameters2)
        end
        descFreeText:setShowText(str_info)
    elseif self.Parameters3 == 18 then 
        str_info = string.format(LocalStrings.NEW_ACTIVITY_TEXT_6,self.Parameters2, self.GradeIndex)
        descFreeText:setShowText(str_info)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE then
        local nDayTemp = self.m_nRechargeDays
        if nDayTemp > tonumber(self.Parameters1) then
            nDayTemp = tonumber(self.Parameters1)
        end
        str_info = string.format(LocalStrings.NEW_ACTIVITY_TEXT_7,tonumber(self.Parameters1), nDayTemp, tonumber(self.Parameters1))
        descFreeText:setShowText(str_info)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY then
        local title_info_1 = self:createTTF(LocalStrings.NEWACTIVITY_TEXT11,GlobalMethod:ccp(0.025,0.5),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
        local wordCount = title_info_1:getWordCount()
        local txtSize = title_info_1:getContentSize()
        conMsgInfo:addChild(title_info_1, 0, 88)
        local pos = wordCount*22 + 24
        if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
            pos = wordCount*11 + 24
        end 
        local nCurNum = tonumber(self.m_nCurTarget)
        if nCurNum > tonumber(self.Parameters2) then 
            nCurNum = tonumber(self.Parameters2)
        end
        local title_info_2 = self:createTTF("(" .. tostring(nCurNum) .. "/" .. tostring(self.Parameters2) .. ")",GlobalMethod:ccp(pos/486,0.5),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(93,222,254),GlobalMethod:ccc3(105,65,46))
        local wordCount_1 = title_info_2:getWordCount()
        conMsgInfo:addChild(title_info_2,0,89)
        
        local imgStar = WZUIImage:create()
        imgStar = WZUIImage:luaTo(imgStar)
        imgStar:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        imgStar:setFile("ui/common/common_icon_xingxing2.png")
        imgStar:setScale(0.8)

        local pos_1 = pos +10+ wordCount_1/2*22
        imgStar:setRelativePosition(GlobalMethod:ccp(pos_1/486,0.5))
        imgStar:setUseOriginSize(true)
        conMsgInfo:addChild(imgStar, 0, 90)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_EQUIP_STAR then 
        local nCurNum = tonumber(self.m_nCurTarget)
        str_info = string.format(LocalStrings.GAMEACTIVITY_TIPTEXT1, nCurNum, self.Parameters2)
        local ftxtTip = self:createFreeText(str_info, GlobalMethod:ccp(0.025,0.5), GlobalMethod:ccp(0,0.5))
        conMsgInfo:addChild(ftxtTip, 0, 88)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY then 
        local sFormat = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1">%s</T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">(%d/%d)</T>]]
        if ProjConfig.LANGUAGE == "es" then
            sFormat = [[<T C="255,236,193" S="17" P="1" SC="105,60,46" SS="4" SE="1">%s</T><T C="255,227,116" S="17" P="1" SC="105,60,46" SS="4" SE="1">(%d/%d)</T>]]
        end
        local nCurNum = tonumber(self.m_nCurTarget)
        local tipContent = self:_getTipWordByUIId(nCurNum)
        local nCurTimes = tonumber(self.GradeIndex)
        if nCurTimes > tonumber(self.Parameters2) then 
            nCurTimes = self.Parameters2
        end
        str_info = string.format(sFormat, tipContent, nCurTimes, self.Parameters2)
        local ftxtTip = self:createFreeText(str_info, GlobalMethod:ccp(0.025,0.5), GlobalMethod:ccp(0,0.5))
        conMsgInfo:addChild(ftxtTip, 0, 88)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND then 
        str_info = string.format(LocalStrings.NEW_ACTIVITY_TEXT_9,self.Parameters1, LocalStrings.COMMUNITYWARHISTORY_NUMBER[self.rewardId + 1])
        descFreeText:setShowText(str_info)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then 
         local title_info_1 = self:createTTF(LocalStrings.GAMEACTIVITY_TIPTEXT5, GlobalMethod:ccp(0.025,0.5), GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
        local wordCount = title_info_1:getWordCount()
        local txtSize = title_info_1:getContentSize()
        conMsgInfo:addChild(title_info_1, 0, 88)
        local pos = wordCount*22 + 18
        local title_info_2 = self:createTTF(self.Parameters2, GlobalMethod:ccp(pos/486,0.5), GlobalMethod:ccp(0,0.5), 22, nil, GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(0,72,3))
        title_info_2:setUseSystemFont(true)
        local wordCount_1 = title_info_2:getWordCount()
        conMsgInfo:addChild(title_info_2,0,89)
        local pos_1 = wordCount_1*20 + pos - 20
        local title_info_3 = self:createTTF(LocalStrings.MOUNT_CAN_LOCK, GlobalMethod:ccp(pos_1/486,0.5), GlobalMethod:ccp(0,0.5), 22, nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
        conMsgInfo:addChild(title_info_3, 0, 90)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND then 
        local sFormat = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1">%s</T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">%d</T><I Z="0.75" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1">%s</T>]]
        str_info = string.format(sFormat, LocalStrings.GAMEACTIVITY_NEWRECHARGEBACK3, self.Parameters2, "ui/common/common_icon_zuanshi.png", string.format(LocalStrings.GAMEACTIVITY_TIPTEXT3, LocalStrings.COMMUNITYWARHISTORY_NUMBER[self.rewardId + 1]))
        local ftxtTip = self:createFreeText(str_info, GlobalMethod:ccp(0.025,0.5), GlobalMethod:ccp(0,0.5))
        conMsgInfo:addChild(ftxtTip, 0, 88)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL3 then
        local dthtxt = string.match(self.Parameters1,"%d+")
        local Parameters1 = string.gsub(self.Parameters1,dthtxt,dthtxt.." ")
        str_info = string.format(LocalStrings.NEW_ACTIVITY_TEXT_8,tostring(Parameters1))
        descFreeText:setShowText(str_info)
    elseif self.Parameters3 == g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY or 
           self.Parameters3 == g_tGameActivityTypes.ACTIVITY_PET_UPGRADE or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE or 
           self.Parameters3 == g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_PET_QUAIL or 
           self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN or self.Parameters3 == g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE then
        local title_info_1 = self:createTTF(self.Parameters1,GlobalMethod:ccp(0.025,0.5),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
        conMsgInfo:addChild(title_info_1,0,93)
    end 
end

function CellTotalRechargeItem:createTTF(desc,pt,anchor,font,Align,color,sclolor)
    desc = desc or ""
    font = font or 22
    color = color or GlobalMethod:ccc3(105,65,46)
    sclolor = sclolor or GlobalMethod:ccc3(105,65,46)
    Align = Align or kCCTextAlignmentLeft
    anchor = anchor or GlobalMethod:ccp(0,0.5)
    pt = pt or GlobalMethod:ccp(0,0.5)
    local txt = WZUILabelTTF:create()
    txt:setFontSize(font)
    txt:setColor(color)
    txt:setText(desc)
    txt:setBoldFont(false)
    txt:setEnableStroke(true)
    txt:setStrokeColor(sclolor)
    txt:setStrokeSize(4)
    txt:setTouchEnable(false)
    txt:setAlignment(Align)
    txt:setAnchorPoint(anchor)
    txt:setRelativePosition(pt)
    if ProjConfig.LANGUAGE == "ug" then
        if self.Parameters3 == 18 then
            txt:setFontSize(13)
            txt:setStrokeSize(2)
        end
    end
    return txt
end

--@brief    创建富文本
function CellTotalRechargeItem:createFreeText(desc, pt, anchor)
    -- body
    anchor = anchor or GlobalMethod:ccp(0,0.5)
    pt = pt or GlobalMethod:ccp(0,0.5)
    local ftxt = WZUIFreeTextBox:create()
    ftxt:setMaxWidth(400)
    if ProjConfig.LANGUAGE == "th" then
        ftxt:setMaxWidth(800)
    end
    ftxt:setShowText(desc)
    ftxt:setTouchEnable(false)
    ftxt:setAnchorPoint(anchor)
    ftxt:setRelativePosition(pt)
    return ftxt
end

function CellTotalRechargeItem:_ShowGetRewarded(  )
    local img_GetReward = WZUIImage:create()
    img_GetReward = WZUIImage:luaTo(img_GetReward)
    img_GetReward:setFile("ui/common/commom_icon_ylq.png")
    img_GetReward:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    img_GetReward:setUseOriginSize(true)
    img_GetReward:setRotation(28)
    local conBtn_CellTotalRechargeItem = GetElement(self.m_root,"conBtn_CellTotalRechargeItem",WZUIContainer)
    conBtn_CellTotalRechargeItem:addChild(img_GetReward, 0, 888)
end
-------------------------------------私有方法模块End----------------------------------------


function CellTotalRechargeItem:_adaptLanguage_pt(  )
    local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    txt_button_item:setScale(0.8)
end

function CellTotalRechargeItem:_adaptLanguage_vn(  )
    
end

function CellTotalRechargeItem:_adaptLanguage_th(  )
    
end

function CellTotalRechargeItem:_adaptLanguage_en(  )
    
end
