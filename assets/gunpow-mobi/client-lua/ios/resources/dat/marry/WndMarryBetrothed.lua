--WndMarryBetrothed.lua
--@brief	WndMarryBetrothed的UI模块
--@date		2014/01/15
--@author	叶威
--@note		已订婚界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryBetrothed:onEnter(element)
	WZLog("WndMarryBetrothed:onEnter(element)")
	self.m_root = element
    self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryBetrothed:onExit(element)
	self:_unInit()
end

--@brief	关闭窗口
--@param	element:按钮的引用
function WndMarryBetrothed:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if element == nil then
		WZLog("WndMarryBetrothed:onCloseClick(element) element is nil ")
	end
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击说明按钮的响应方法
--@param	element:按钮的引用
function WndMarryBetrothed:onIntroClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --获得说明文本
    WndSingleMapDesc:showInterface(LocalStrings.Engagement_Desc)
end

--@brief	点击解除关系按钮的响应方法
--@param	element:按钮的引用
function WndMarryBetrothed:onCancelShip(element)
    WZLog("WndMarryBetrothed:onCancelShip")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local farewellPrice =  CacheCenter:getGameParam().FarewellPrice
    if farewellPrice == nil then
        farewellPrice = 333
    end
    farewellPrice = tonumber(farewellPrice)
    if CacheCenter:getGameParam().isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70,farewellPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,210, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1,farewellPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,210, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
    end
    
    self:clickSureMoney()
end

--@brief    点击确定充值回调
function WndMarryBetrothed:clickSureMoney()
    --弹出提示
    local farewellPrice =  CacheCenter:getGameParam().FarewellPrice
    if farewellPrice == nil then
        farewellPrice = 333
    end
    farewellPrice = tonumber(farewellPrice)

    MsgBoxManager:showConfirmBox(string.format(LocalStrings.MARRY_END_TIPS,farewellPrice),self,self.sureEndShip)
end

--@brief 确认解除关系
function WndMarryBetrothed:sureEndShip(element)
   WZLog("WndMarryBetrothed:sureEndShip")
   ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement(0)
   WindowManager:removeWindow(self.m_root,self,true)
   WndMarryManager:removeAllWindow()
end

--@brief  选择不同的婚礼邀请请柬响应函数
function WndMarryBetrothed:onClickIn(element)
    WZLog("WndMarryBetrothed:onClickIn ")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    GetElement(self.m_root,"imgInCell" .. self.m_nInType  .. "_WndMarryBetrothed",WZUI9Image):setVisible(false)
    GetElement(self.m_root,"imgInCell" .. tag  .. "_WndMarryBetrothed",WZUI9Image):setVisible(true)
    self.m_nInType = tag 
end

--@brief  发送结婚请柬
function WndMarryBetrothed:onSendInClick(element)
   WZLog("WndMarryBetrothed:onSendInClick")
   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   WndFriendList:showInterface(1,WndMarryBetrothed,self.sendInvitation)
end

--@brief 举办婚礼
function WndMarryBetrothed:onWeddingClick(element)
    WZLog("WndMarryBetrothed:onWeddingClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local outFit = CacheCenter:getGameParam().wedMarryItem
    if outFit then
        local ids,items = SplitItemString(outFit)
        
        monery = tonumber(items[self.m_nWeddingType])

        if JudgeMarryDiscountExist() then --婚礼打折
            if self.m_nWeddingType == 1 then
                monery = math.ceil(monery * 0.5)
            elseif self.m_nWeddingType == 2 then
                monery = math.ceil(monery * 0.7)
            elseif self.m_nWeddingType == 3 then
                monery = math.ceil(monery * 0.9)
            end
        end
        if not JudgeMoneyIsEnough(tonumber(ids[self.m_nWeddingType]), monery, nil, nil,83, nil, nil, nil, nil, self, self.sureUseDiamondInsteadMarry) then
            return
        end
    else
        local monery = 0
        if self.m_nWeddingType == 1 then
            monery = 2999
        elseif self.m_nWeddingType == 2 then
            monery = 1999
        elseif self.m_nWeddingType == 3 then
            monery = 999
        end
        if CacheCenter:getGameParam().isUseTicket == "0" then
            if not JudgeMoneyIsEnough(70, monery,nil, nil, 83, nil, nil, nil, nil, self, self.sureUseDiamondInsteadMarry) then
                return
            end
        else
            if not JudgeMoneyIsEnough(1, monery,nil, nil, 83, nil, nil, nil, nil, self, self.sureUseDiamondInsteadMarry) then
                return
            end
        end
    end
   
    self:sureUseDiamondInsteadMarry()
end

--@brief    确认用钻石代替礼券结婚
function WndMarryBetrothed:sureUseDiamondInsteadMarry()
    -- body
    local wndMarrySelectTime = WndMarryTimeSelect:createElement()
    WndMarryTimeSelect:setWeddingType(self.m_nWeddingType)
    WindowManager:addWindow(wndMarrySelectTime, WndMarryTimeSelect)
end

--@brief	点击婚礼方式按钮的响应方法
--@param	element:按钮的引用
function WndMarryBetrothed:onWeddingMothodClick(element)
    WZLog("WndMarryBetrothed:onWeddingMothodClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag= element:getTag()
    GetElement(self.m_root,"imgWedCell" .. self.m_nWeddingType .. "_WndMarryBetrothed",WZUI9Image):setVisible(false)
    GetElement(self.m_root,"imgWedCell" .. tag .. "_WndMarryBetrothed",WZUI9Image):setVisible(true)

    GetElement(self.m_root,"particle" .. self.m_nWeddingType .. "_WndMarryBetrothed",WZUIParticle):setVisible(false)
    GetElement(self.m_root,"particle" .. tag .. "_WndMarryBetrothed",WZUIParticle):setVisible(true)
    
    self.m_nWeddingType = tag
    
end

--@brief  更新界面按钮
function WndMarryBetrothed:updateBtnStats(weddingType)
    WZLog("WndMarryBetrothed:updateBtnStats =",weddingType)
    for i=1,3 do
        if weddingType == i then
            WZLog("wedTime...............")
            GetElement(self.m_root,"imgWedCell" .. weddingType .. "_WndMarryBetrothed",WZUI9Image):setVisible(true)
            GetElement(self.m_root,"particle" .. weddingType .. "_WndMarryBetrothed",WZUIParticle):setVisible(true)
        else
            GetElement(self.m_root,"imgWedCell" .. i .. "_WndMarryBetrothed",WZUI9Image):setVisible(false)
            GetElement(self.m_root,"particle" .. i .. "_WndMarryBetrothed",WZUIParticle):setVisible(false)
        end
    end
end

--@brief  查看婚礼详细信息
function WndMarryBetrothed:onClickLookDetails(element)
    WZLog("WndMarryBetrothed:onClickLookDetails =",self.m_nWeddingType)
    local tag = element:getTag()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root,self,true)
  
    local element = WndWeddingDetails:createElement()
    WndWeddingDetails:setShowWeddingIndex(tag)
    WindowManager:addWindow(element, WndWeddingDetails,nil,nil,true)
end

--@brief 如果双方已结婚没举办婚礼则显示婚礼请柬界面，否则显示举行婚礼界面  
function WndMarryBetrothed:controlWeddingShow()
    WZLog("WndMarryBetrothed:controlWeddingShow")
    local Luxury = WZUIContainer:luaTo(self.m_root:getChildElement("conLuxury_WndMarryBetrothed"))
    local Rich = WZUIContainer:luaTo(self.m_root:getChildElement("conRich_WndMarryBetrothed"))
    local Roman = WZUIContainer:luaTo(self.m_root:getChildElement("conRoman_WndMarryBetrothed"))

    local InRich = WZUIContainer:luaTo(self.m_root:getChildElement("conInRich_WndMarryBetrothed"))
    local InPretty = WZUIContainer:luaTo(self.m_root:getChildElement("conInPretty_WndMarryBetrothed")) 
    local InOrdinary = WZUIContainer:luaTo(self.m_root:getChildElement("conInOrdinary_WndMarryBetrothed")) 
    local conSendIn = WZUIContainer:luaTo(self.m_root:getChildElement("conSendIn_WndMarryBetrothed"))
    local conCancel = GetElement(self.m_root,"conCancel_WndMarryBetrothed",WZUIContainer)

    local weddingStats = WndMarryManager:getMarryStatusTable()

    local txtInviCard1 = GetElement(self.m_root,"txtInviCard1_WndMarryBetrothed",WZUILabelTTF)
    local txtInviCard2 = GetElement(self.m_root,"txtInviCard2_WndMarryBetrothed",WZUILabelTTF)
    local txtInviCard3 = GetElement(self.m_root,"txtInviCard3_WndMarryBetrothed",WZUILabelTTF)

    local imgSendIcon1 = GetElement(self.m_root,"imgSendIcon1_WndMarryBetrothed",WZUIImage)
    local imgSendIcon2 = GetElement(self.m_root,"imgSendIcon2_WndMarryBetrothed",WZUIImage)
    local imgSendIcon3 = GetElement(self.m_root,"imgSendIcon3_WndMarryBetrothed",WZUIImage)

    local txtWeddingP1 = GetElement(self.m_root,"txtWeddingP1_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP2 = GetElement(self.m_root,"txtWeddingP2_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP3 = GetElement(self.m_root,"txtWeddingP3_WndMarryBetrothed",WZUILabelTTF)
    local imgWedIcon1 = GetElement(self.m_root,"imgWedIcon1_WndMarryBetrothed",WZUIImage)
    local imgWedIcon2 = GetElement(self.m_root,"imgWedIcon2_WndMarryBetrothed",WZUIImage)
    local imgWedIcon3 = GetElement(self.m_root,"imgWedIcon3_WndMarryBetrothed",WZUIImage)

    local conWedding= WZUIContainer:luaTo(self.m_root:getChildElement("conWedding_WndMarryBetrothed"))

    local txtWeddingP1_discount = GetElement(self.m_root,"txtWeddingP1_discount_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP2_discount = GetElement(self.m_root,"txtWeddingP2_discount_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP3_discount = GetElement(self.m_root,"txtWeddingP3_discount_WndMarryBetrothed",WZUILabelTTF)

    local txtWeddingP1_line = GetElement(self.m_root,"txtWeddingP1_line_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP2_line = GetElement(self.m_root,"txtWeddingP2_line_WndMarryBetrothed",WZUILabelTTF)
    local txtWeddingP3_line = GetElement(self.m_root,"txtWeddingP3_line_WndMarryBetrothed",WZUILabelTTF)

    local weddingP = CacheCenter:getGameParam().wedMarryItem
    
    local ids,nums = SplitItemString(weddingP)
    nums1 = tonumber(nums[1])
    nums2 = tonumber(nums[2])
    nums3 = tonumber(nums[3])

    imgWedIcon1:setFile(GDatatab_item["id_" .. ids[1]].icon)
    imgWedIcon1:setScale(0.5)
    imgWedIcon2:setFile(GDatatab_item["id_" .. ids[2]].icon)
    imgWedIcon2:setScale(0.5)
    imgWedIcon3:setFile(GDatatab_item["id_" .. ids[3]].icon)
    imgWedIcon3:setScale(0.5)

    if JudgeMarryDiscountExist() then
        txtWeddingP1_line:setVisible(true)
        txtWeddingP2_line:setVisible(true)
        txtWeddingP3_line:setVisible(true)

        txtWeddingP1_discount:setVisible(true)
        txtWeddingP2_discount:setVisible(true)
        txtWeddingP3_discount:setVisible(true)

        txtWeddingP1_discount:setText(nums1)
        txtWeddingP2_discount:setText(nums2)
        txtWeddingP3_discount:setText(nums3)

        nums1 = math.ceil(nums1 * 0.5)
        nums2 = math.ceil(nums2 * 0.7)
        nums3 = math.ceil(nums3 * 0.9)

        txtWeddingP1:setText(nums1)
        txtWeddingP2:setText(nums2)
        txtWeddingP3:setText(nums3)
    else
        txtWeddingP1:setText(nums1)
        txtWeddingP2:setText(nums2)
        txtWeddingP3:setText(nums3)
    end
    
    local cardP = CacheCenter:getGameParam().wedCardItem
    
    ids,nums = SplitItemString(cardP)
    txtInviCard1:setText(nums[1])
    txtInviCard2:setText(nums[2])
    txtInviCard3:setText(nums[3])

    imgSendIcon1:setFile(GDatatab_item["id_" .. ids[1]].icon)
    imgSendIcon1:setScale(0.5)
    imgSendIcon2:setFile(GDatatab_item["id_" .. ids[2]].icon)
    imgSendIcon2:setScale(0.5)
    imgSendIcon3:setFile(GDatatab_item["id_" .. ids[3]].icon)
    imgSendIcon3:setScale(0.5)

    local txtTitle = GetElement(self.m_root,"txtTitle_WndMarryBetrothed",WZUILabelTTF)
    if weddingStats.marryStatus == 1 and weddingStats.wedTime == -1 then
        ChangeChatChannel(Chat_Channel_Wedding)
        conWedding:setVisible(true)
        conSendIn:setVisible(false)
        InRich:setVisible(false)
        
        InPretty:setVisible(false)
        InOrdinary:setVisible(false)
        Luxury:setVisible(true)
        Rich:setVisible(true)
        Roman:setVisible(true)
        txtTitle:setText(LocalStrings.SELECT_WEDDING_TYPE)
        self:updateBtnStats(self.m_nWeddingType)
    elseif weddingStats.marryStatus == 2 and weddingStats.wedTime ~=-1 then
        ChangeChatChannel(Chat_Channel_Wedding_Invitation)
        conSendIn:setVisible(true)
        conWedding:setVisible(false)
        InRich:setVisible(true)
       
        InPretty:setVisible(true)
        InOrdinary:setVisible(true)
        Luxury:setVisible(false)
        Rich:setVisible(false)
        Roman:setVisible(false)
        conCancel:setVisible(false)
        GetElement(self.m_root,"imgTitle_WndMarryBetrothed",WZUIImage):setFile("ui/common/commom_icon_qj.png")
        txtTitle:setText(LocalStrings.SELECT_WEDDING_INV)

        local wedTime = weddingStats.wedTime
        if wedTime <=0 then  --已过婚礼时间或者正在举行婚礼则邀请按钮屏蔽
            GetElement(self.m_root,"btnSendInv_WndMarryBetrothed",WZUIButton):setTouchEnable(false)
            local txtWedding = GetElement(self.m_root,"txtWeddingIn_WndMarryBetrothed",WZUILabelTTF)
            txtWedding:setColor(GlobalMethod:ccc3(96,96,96))
            txtWedding:setEnableStroke(false)
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------回调方法模块Begin--------------------------------------
--@brief  选择好友发送请柬
function WndMarryBetrothed:sendInvitation(tData,index)
    WZLog("WndMarryBetrothed:sendInvitation " ,#tData,index)

    self.m_tInviteFriendData = tData

    local friendCount = 0
    for i,v in ipairs(tData) do
      friendCount = friendCount + 1
    end

    local costCount = 0
    local cardP = CacheCenter:getGameParam().wedCardItem
    local ids,nums = SplitItemString(cardP)
    costCount = tonumber(nums[self.m_nInType]) * friendCount
    if not JudgeMoneyIsEnough(tonumber(ids[self.m_nInType]), costCount, nil, nil, 97, nil, nil, nil, nil, self, self.sureUseDiamondInsteadInvite) then
        return
    end

    self:sureUseDiamondInsteadInvite()
end

--@brief    确认用钻石代替礼券发送请柬
function WndMarryBetrothed:sureUseDiamondInsteadInvite()
    -- body
    local tData = self.m_tInviteFriendData

    local VansFriendsId = WZLuaVector_int_:create()
    for i,v in ipairs(tData) do
      VansFriendsId:push(v.id)
    end

    ProtocolProcessorWndMarry:send_WEDDING_SendCard(VansFriendsId,self.m_nInType,3)
end
-------------------------------------回调方法模块end----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief  更新界面
function WndMarryBetrothed:_update()
    self:_initButtontag()
end


--@brief	初始化求婚礼方式按钮的tag值
function WndMarryBetrothed:_initButtontag()
    WZUIButton:luaTo(GetElement(self.m_root,"btnLuxury_WndMarryBetrothed")):setTag(WndMarryManager.weddingType.LUXURY)
    WZUIButton:luaTo(GetElement(self.m_root,"btnRich_WndMarryBetrothed")):setTag(WndMarryManager.weddingType.RICH)
    WZUIButton:luaTo(GetElement(self.m_root,"btnRoman_WndMarryBetrothed")):setTag(WndMarryManager.weddingType.ROMAN)

    self:controlWeddingShow()
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------


function WndMarryBetrothed:_adaptLanguage_en()
    WZLog("WndMarryBetrothed:_adaptLanguage_en")
    local txtWedding = GetElement(self.m_root,"txtWedding_WndMarryBetrothed",WZUILabelTTF)
    txtWedding:setFontSize(20)
    local txtWedding = GetElement(self.m_root,"txtWeddingIn_WndMarryBetrothed",WZUILabelTTF)
    txtWedding:setFontSize(22)
end

function WndMarryBetrothed:_adaptLanguage_pt(  )
    local txtWedding = GetElement(self.m_root,"txtWedding_WndMarryBetrothed",WZUILabelTTF)
    txtWedding:setFontSize(20)

    GetElement(self.m_root,"txtWeddingIn_WndMarryBetrothed",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root,"txtTemp1_WndMarryBetrothed",WZUILabelTTF):setScale(0.82)
    GetElement(self.m_root,"txtTemp2_WndMarryBetrothed",WZUILabelTTF):setScale(0.82)
    GetElement(self.m_root,"txtTemp3_WndMarryBetrothed",WZUILabelTTF):setScale(0.82)

    for i = 1,3 do
        local txtMarryTypeName = string.format("txtMarryType%d_WndMarryBetrothed",i)
        GetElement(self.m_root,txtMarryTypeName,WZUILabelTTF):setFontSize(18)
    end
end

function WndMarryBetrothed:_adaptLanguage_vn()
    GetElement(self.m_root,"txtWedding_WndMarryBetrothed",WZUILabelTTF):setFontSize(20)
end

function WndMarryBetrothed:_adaptLanguage_tr()
    GetElement(self.m_root,"txtWedding_WndMarryBetrothed",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtWeddingIn_WndMarryBetrothed",WZUILabelTTF):setScale(0.7)
end

function WndMarryBetrothed:_adaptLanguage_es(  )
    for i=1,3 do
        GetElement(self.m_root,"txtTemp"..i.."_WndMarryBetrothed",WZUILabelTTF):setScale(0.8)
    end
    local txtWedding = GetElement(self.m_root,"txtWedding_WndMarryBetrothed",WZUILabelTTF)
    txtWedding:setDimensions(GlobalMethod:CCSize(130,0))
    txtWedding:setFontSize(20)
    
    local txtWeddingIn = GetElement(self.m_root,"txtWeddingIn_WndMarryBetrothed",WZUILabelTTF)
    txtWeddingIn:setDimensions(GlobalMethod:CCSize(130,0))
    txtWeddingIn:setFontSize(20)
end
-------------------------------------语言适配模模块End----------------------------------------

