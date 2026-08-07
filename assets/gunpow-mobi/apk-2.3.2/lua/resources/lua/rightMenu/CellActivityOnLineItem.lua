--CellActivityOnLineItem.lua
--@brief	CellActivityOnLineItem的UI模块
--@date		2014/11/27
--@author	weidong_wu
--@note		列表选项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityOnLineItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityOnLineItem:onExit(element)
	self:_unInit()
end

--@brief    选项高亮
function CellActivityOnLineItem:isItemHighLighted(bState)
    self.m_bIsHighLight = bState
    if self.m_bIsLoad == false then return end

    local btnLeft = GetElement(self.m_root,"btnLeft_CellActivityOnlineItem",WZUIButton)
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    txt_subItemName:setFontSize(22)
    local img_normal = GetElement(self.m_root, "normal", WZUI9Image)
    local img_select = GetElement(self.m_root, "select", WZUI9Image)
    if bState then 
        self:setColorSelect(txt_subItemName, img_normal, img_select)
    else
        self:setColorNormal(txt_subItemName, img_normal, img_select)
    end 
end
function CellActivityOnLineItem:setColorSelect(node, n_nor, n_sel)
    if not node then return end
    node:setColor(GlobalMethod:ccc3(255,236,193))
    node:setEnableStroke(true)
    node:setStrokeColor(GlobalMethod:ccc3(128,54,33))
    node:setStrokeSize(4)
    n_nor:setVisible(false)
    n_sel:setVisible(true)
end
function CellActivityOnLineItem:setColorNormal(node, n_nor, n_sel)
    if not node then return end
    node:setColor(GlobalMethod:ccc3(127,70,26))
    node:setEnableStroke(false)
    n_nor:setVisible(true)
    n_sel:setVisible(false)
end

--@brief    点击回调事件
function CellActivityOnLineItem:onClickCellItem(  )
    WZLog("CellActivityOnLineItem:onClickCellItem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if (not self.b_isClicked)   then
        self.b_isClicked = true
        self:addCellItemId(self.n_CellItemId)
        self:ItemStateByImage()
    end
    local nTag = self.m_root:getTag()
    if WndGameActivity.m_root and WndGameActivity.m_root:isVisible() == true then
        WndGameActivity:updataParentByCellItem(nTag)
    elseif WndAmberPlayer.m_root and WndAmberPlayer.m_root:isVisible() == true then
        WndAmberPlayer:updataParentByCellItem(nTag)
    end
end

--@brief    选择项状态标签显示情况
--@parmas   nSubIndex sub类id
--@parmas   nTypeIdx 选择项类型
--@parmas   nTypeState  1 new,2 hot ,3 normal
function CellActivityOnLineItem:ItemStateByImage()
    if self.m_bIsLoad == false then return end
    local img_itemState = self.m_root:getChildElement("img_itemState")
    if img_itemState ~= nil then
        img_itemState = WZUIImage:luaTo(img_itemState)
    end
    local txt_itemState = GetElement(self.m_root,"txt_itemState",WZUILabelTTF)

    local imgStr = ""

    local bIsTimeLimitActivity = wetherTimeLimitActivity(self.n_CellType)
    if bIsTimeLimitActivity then
        imgStr = "ui/newvip/common_bq_hs.png"
        img_itemState:setFile(imgStr)
        txt_itemState:setText(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[12])
        return
    end

    local bIsNewServerActivity = wetherNewServerActivity(self.n_CellType)
    if bIsNewServerActivity then 
        imgStr = "ui/gameActivity/common_icon_xfzs.png"
        -- if self.n_CellType == g_tGameActivityTypes.ACTIVITY_CHARGE30_REBATE then 
        --     imgStr = "ui/gameActivity/common_bq_1111.png"
        -- end
        img_itemState:setFile(imgStr)
        return 
    end

    if self.b_isClicked then
        imgStr = img_itemState:getFile()
        if imgStr == "ui/common/common_icon_hot_1.png" then 
            img_itemState:setVisible(false)
        end
    else 
        if self.m_bIsHotActivity then 
            imgStr = "ui/common/common_icon_hot_1.png"
            img_itemState:setFile(imgStr)
        else
            self.b_isClicked = true 
            img_itemState:setVisible(false)
        end
    end
end

--@breif    判断是否点击过
function CellActivityOnLineItem:CheckItemIsClick()
    local cellId_stringArray = ""
    local data = WZDataFile:getInstance():getUserData()
    local nCurTime = SystemTime:getServerTime()
    local sCurDate = os.date("*t", nCurTime)
    local sKeyFormat = string.format("ACTIVITY%04d%02d%02d_%s", sCurDate.year, sCurDate.month, sCurDate.day, tostring(CacheCenter:getPlayerInfo().id))
    cellId_stringArray = data:getStringValue("ACTIVITY_CELLITEM_ID", sKeyFormat)
    local bRet = false
--    WZLog("CellActivityOnLineItem:CheckItemIsClick ", cellId_stringArray)
    self:getHotState()
    if cellId_stringArray == nil or cellId_stringArray == "" then
        return bRet
    end
--    WZLog("CellActivityOnLineItem:CheckItemIsClick 1111111111", cellId_stringArray)
    local IdMap = WndTask:Split(cellId_stringArray,"-")
    
    for i = 1, #IdMap do
        if self.n_CellItemId == tonumber(IdMap[i]) then
            self.b_isClicked = true 
            self.m_bIsHotActivity = false
            bRet = true
            break
        end
    end

    return bRet
end

--@brief    设置选项卡名字
function CellActivityOnLineItem:setItemName( txtName )
    --WZLog("CellActivityOnLineItem:setItemName",txtName)
    self.m_sName = txtName 
    if self.m_bIsLoad == false then return end
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName ~= nil then 
        txt_subItemName:setText(txtName)
        if txtName == LocalStrings.GAMEACTIVITY_COST_ONLYDIAMOND and ProjConfig.LANGUAGE == "en" then
            txt_subItemName:setScale(0.6)
            txt_subItemName:setDimensions(GlobalMethod:CCSize(320))
        end
    end 
    local imgName = WZUIImage:luaTo(self.m_root:getChildElement("img_subItemName"))
    if g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_CHRISTMAS_CARNIVAL then
        imgName:setFile("ui/newActivity/text_hd_bt_ssy.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_EXCHANGE then
        imgName:setFile("ui/newActivity/tdht_dhgas_3011.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_EXCHANGE_ONE then
        imgName:setFile("ui/newActivity/tdsk_dhgas2_3100.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_EXCHANGE_TWO then
        imgName:setFile("ui/newActivity/tdba_dhgas3_3101.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_EXCHANGE_THREE then
        imgName:setFile("ui/newActivity/tddb_dhgas4_3102.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_EXCHANGE_FOUR then
        imgName:setFile("ui/newActivity/lrtt_dhgas5_3103.png")
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    elseif g_tGameActivityTypes and (self:getCellType() == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST or self:getCellType() == g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO) then
        if imgName then
            imgName:setFile("ui/gameActivity/text_hd_bt_lzxf.png")
            imgName:setVisible(true)
        end
    elseif g_tGameActivityTypes and self:getCellType() == g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 then
        imgName:setFile("ui/newActivity/e_6122_66_vn.png")
    --    imgName:setScale(0.5)
        imgName:setVisible(true)
        txt_subItemName:setVisible(false)
    end
end

--@brief    设置选项Id
function CellActivityOnLineItem:setCellId(tItemData)
    self.n_CellItemId = tItemData.activityId
    self.m_tItemData = tItemData
end

--@brief    获得选项Id
function CellActivityOnLineItem:getCellItem(  )
    return  self.n_CellItemId
end

--@brief    设置选项类型
function CellActivityOnLineItem:setCellType( nType )
    --WZLog("CellActivityOnLineItem:setCellType",nType)
    self.n_CellType = nType
end

--@brief    获得选项类型
function CellActivityOnLineItem:getCellType(  )
    return self.n_CellType
end

function CellActivityOnLineItem:setIsClickEnable( bEnable)
    self.b_isClicked = bEnable
end

--@brief    添加点击事件的id
function CellActivityOnLineItem:addCellItemId( nCellId )
    WZLog("CellActivityOnLineItem:addCellItemId|nCellId="..nCellId)
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    local nCurTime = SystemTime:getServerTime()
    local sCurDate = os.date("*t", nCurTime)
    local sKeyFormat = string.format("ACTIVITY%04d%02d%02d_%s", sCurDate.year, sCurDate.month, sCurDate.day, tostring(CacheCenter:getPlayerInfo().id))
    _KeyString = sKeyFormat
    local cellId_stringArray =  data:getStringValue("ACTIVITY_CELLITEM_ID",_KeyString)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        local idString = string.format("%d-",nCellId)
        data:setStringValue("ACTIVITY_CELLITEM_ID", _KeyString,idString)
        data:flush()
    else 
        local idString = string.format("%s%d-",cellId_stringArray,nCellId)
        data:setStringValue("ACTIVITY_CELLITEM_ID", _KeyString, idString)
        data:flush()
    end
end

--@breif 添加红点
function CellActivityOnLineItem:AddRedDot(bRedDot)
    WZLog("CellActivityOnLineItem:AddRedDot=====添加小红点=====")
    self.m_bIsNeedAddRedDot = bRedDot
    if self.m_bIsLoad == false then return end 

    if self.m_bIsNeedAddRedDot == true then 
        if not  self.m_root:getChildByTag(99) then 
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            spr_redPoint:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr_redPoint:setPosition(215, 65)
            self.m_root:addChild(spr_redPoint,5,99)
        end 
    end
end

--@brief 移除红点
function CellActivityOnLineItem:removeRedDot()
    if self.m_root == nil then 
        return
    end
    if self.m_root:getChildByTag(99) then 
        self.m_root:removeChildByTag(99, true)
        self.m_bIsNeedAddRedDot = false
    end 
end

--@brief    加载cell数据信息
function CellActivityOnLineItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellActivityOnLineItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    self:_update()
end

function CellActivityOnLineItem:setFyberTime()
    if NeedFyber(1) then
        self.n_fyberTime = GetFyberTime(1)
        WZLog("CellActivityOnLineItem:setFyberTime:", self.n_fyberTime)
        local conFyber = self.m_root:getChildElement("conTop_CellActivityOnLineItem")
        conFyber:setVisible(true)
        if self.n_fyberTime > 0 then
            GetElement(self.m_root,"btnLeft_CellActivityOnlineItem",WZUIButton):setTouchEnable(false)
            conFyber:enableSchedule("updateFyberTime",0.2)
        else
            GetElement(self.m_root,"btnLeft_CellActivityOnlineItem",WZUIButton):setTouchEnable(true)
            GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
        end
    end 
end

--@brief    更新匹配时间
function CellActivityOnLineItem:updateFyberTime(element,dt)
    self.n_fyberTime = self.n_fyberTime - dt
    WZLog("CellActivityOnLineItem:updateFyberTime:", self.n_fyberTime)  
    local timeTtf = GetElement(self.m_root,"txt_subItemName",WZUILabelTTF)
    if self.n_fyberTime > 0 then
        local hour,min,sec = WndPetRaffle:numToTime(self.n_fyberTime)
        timeTtf:setText(string.format("cd %0.2d:%0.2d",min,sec))
    else
        timeTtf:setText(LocalStrings.ATH_REWARD_CHECK)
        GetElement(self.m_root,"btnLeft_CellActivityOnlineItem",WZUIButton):setTouchEnable(true)
        local conFyber = self.m_root:getChildElement("conTop_CellActivityOnLineItem")
        conFyber:disableSchedule()
    end
end

--@brief    设置火爆角标状态
function CellActivityOnLineItem:getHotState()
    -- body
    local nCurTime = SystemTime:getServerTime()
    if self.m_tItemData.startTime then 
        local passSeconds = nCurTime - self.m_tItemData.startTime
        if passSeconds > 3 * 24 * 3600 then 
            self.m_bIsHotActivity = false 
            self.b_isClicked = true 
        else
            self.m_bIsHotActivity = true 
        end
    else
        self.m_bIsHotActivity = false 
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新显示
function CellActivityOnLineItem:_update()
    -- body
    --语言适配
    AdaptLanguage(self)
    --活动名称
    self:setItemName(self.m_sName)
    --红点
    self:AddRedDot(self.m_bIsNeedAddRedDot)
    --高亮、
    self:isItemHighLighted(self.m_bIsHighLight)
    --
    self:ItemStateByImage()
    if self.n_CellType == g_tGameActivityTypes.ACTIVITY_FREEREWARD then
        self:setFyberTime()
    end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start----------------------------------------
--@brief    英语适配
function CellActivityOnLineItem:_adaptLanguage_en()
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setScale(0.77)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(255))
    end
end

function CellActivityOnLineItem:_adaptLanguage_th()
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setScale(0.8)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(240))
    end
end

function CellActivityOnLineItem:_adaptLanguage_pt(  )
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setFontSize(20)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(200,70))
    end
end

function CellActivityOnLineItem:_adaptLanguage_vn(  )
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setFontSize(20)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(220,70))
    end
end

function CellActivityOnLineItem:_adaptLanguage_tr(  )
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setFontSize(20)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(200,70))
    end
end

function CellActivityOnLineItem:_adaptLanguage_es(  )
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setFontSize(20)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(200,70))
    end
end

function CellActivityOnLineItem:_adaptLanguage_ug(  )
    local txt_subItemName = GetElement(self.m_root, "txt_subItemName", WZUILabelTTF)
    if txt_subItemName then
        txt_subItemName:setScale(0.8)
        txt_subItemName:setDimensions(GlobalMethod:CCSize(240))
    end
end
-------------------------------------语言适配模块End----------------------------------------
