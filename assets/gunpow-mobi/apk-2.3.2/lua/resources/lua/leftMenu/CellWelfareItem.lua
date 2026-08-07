--CellWelfareItem.lua
--@brief	CellWelfareItem的UI模块
--@date		2016/05/12
--@author	Tianxiang_Xu
--@note		福利或比赛子分类


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWelfareItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWelfareItem:onExit(element)
	self:_unInit()
end

--@brief    设置是否高亮显示
function CellWelfareItem:setLightVisible(bVisible)
    -- body
    self.m_bIsHighLight = bVisible
    if self.m_bIsLoad == false then return end
    -- GetElement(self.m_root, "img_itemState", WZUI9Image):setVisible(bVisible)
    GetElement(self.m_root, "select", WZUI9Image):setVisible(bVisible)
end
function CellWelfareItem:setColorSelect()
    if not self.m_sTxtItemName_CellWelfareItem then return end
    self.m_sTxtItemName_CellWelfareItem:setColor(GlobalMethod:ccc3(255,236,193))
    self.m_sTxtItemName_CellWelfareItem:setEnableStroke(true)
    self.m_sTxtItemName_CellWelfareItem:setStrokeColor(GlobalMethod:ccc3(128,54,33))
    self.m_sTxtItemName_CellWelfareItem:setStrokeSize(4)
    if self.m_sImgNormal and self.m_sImgSelect then
        self.m_sImgNormal:setVisible(false)
        self.m_sImgSelect:setVisible(true)
    end
end
function CellWelfareItem:setColorNormal()
    if not self.m_sTxtItemName_CellWelfareItem then return end
    self.m_sTxtItemName_CellWelfareItem:setColor(GlobalMethod:ccc3(127,70,26))
    self.m_sTxtItemName_CellWelfareItem:setEnableStroke(false)
    if self.m_sImgNormal and self.m_sImgSelect then
        self.m_sImgNormal:setVisible(true)
        self.m_sImgSelect:setVisible(false)
    end
end

--@brief    加载时才显示cell信息
function CellWelfareItem:onLoadData(element)
    WZLog("CellWelfareItem:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellWelfareItem")
    self.m_root:addChild(cellElement)

    self.m_sTxtItemName_CellWelfareItem = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    self.m_sTxtItemName_CellWelfareItem:setFontSize(22)
    self:setColorNormal()
    GetElement(self.m_root, "img_itemState", WZUI9Image):setVisible(false)

    self.m_sImgNormal = GetElement(self.m_root, "normal", WZUI9Image)
    self.m_sImgSelect = GetElement(self.m_root, "select", WZUI9Image)
    self.m_sImgSelect:setVisible(false)
    self.m_bIsLoad = true
    self:_update()
end

--@brief    获取itemId
function CellWelfareItem:getItemId()
    -- body
    return self.m_nItemId
end

--@brief    点击回调
function CellWelfareItem:onClickCellItem(element)
    -- body
    -- local bVisible = GetElement(self.m_root, "img_itemState", WZUI9Image):isVisible()
    -- if bVisible and self.m_nItemId ~= 999998 then --不知道为啥原因要return，，很不理解
    --     return 
    -- end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1],self.m_nItemId)
    end

    if (not self.b_isClicked)   then
        self.b_isClicked = true
        self:addCellItemId(self.m_nItemId)
        self:setCorner()
    end
end

--@brief    设置红点是否可见
function CellWelfareItem:setRedDotVisible(bVisible)
    -- body
    self.m_bIsHaveRedDot = bVisible
    if self.m_bIsLoad == false then return end
    if self.m_bIsHaveRedDot == true then
        if not  self.m_root:getChildByTag(99) then 
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            spr_redPoint:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr_redPoint:setPosition(212, 65)
            self.m_root:addChild(spr_redPoint,5,99)
        end
    end
end

--@brief    移除红点
function CellWelfareItem:removeRedDot()
    -- body
    if self.m_root:getChildByTag(99) then 
        self.m_root:removeChildByTag(99, true)
        self.m_bIsHaveRedDot = false
    end
end


function CellWelfareItem:setFyberTime()
    if NeedFyber(2) then
        local conFyber = self.m_root:getChildElement("conTop_CellWelfareItem")
        conFyber:setVisible(true)
        GetElement(self.m_root,"txtItemName_CellWelfareItem",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

--@brief    设置活动角标
function CellWelfareItem:setCorner()
    -- body
    local imgCorner = GetElement(self.m_root, "imgCorner_CellWelfareItem", WZUIImage)
    if self.m_nType == 1 then  --福利
        local bIsNewServerActivity = wetherNewServerActivity(self.m_nItemId)
        if bIsNewServerActivity then 
            imgCorner:setVisible(true)
            imgCorner:setFile("ui/gameActivity/common_icon_xfzs.png")
            return 
        end
        if self.m_bIsFreeCardDiscount then 
            imgCorner:setVisible(true)
            imgCorner:setFile("ui/gameActivity/common_icon_dazhe.png")
            return 
        else
            imgCorner:setVisible(false)
        end
        if self.m_bIsHotActivity then 
            imgCorner:setVisible(true)
            local imgStr = "ui/common/common_icon_hot_1.png"
            imgCorner:setFile(imgStr)
        end
        if self.b_isClicked then
            local imgStr = imgCorner:getFile()
            if imgStr == "ui/common/common_icon_hot_1.png" then 
                imgCorner:setVisible(false)
            end
        else
            self.b_isClicked = true 
            imgCorner:setVisible(false)
        end
    elseif self.m_nType == 20 then  --精彩推荐
        local bIsNewServerActivity = wetherNewServerActivity(self.m_nItemId)
        if bIsNewServerActivity then 
            imgCorner:setVisible(true)
            imgCorner:setFile("ui/gameActivity/common_icon_xfzs.png")
            return 
        end
        local tCompeteList = {110,118,156,181}
        if utilsValueInTable(self.m_nItemId, tCompeteList) then 
            imgCorner:setVisible(true)
            imgCorner:setFile("ui/gameActivity/common_icon_bs_1.png")
            return 
        end

        if self.m_bIsHotActivity then 
            local imgStr = "ui/common/common_icon_hot_1.png"
            imgCorner:setFile(imgStr)
        else
            self.b_isClicked = true 
            imgCorner:setVisible(false)
        end
    end
end

--@breif    判断是否点击过
function CellWelfareItem:CheckItemIsClick()
    local cellId_stringArray = ""
    local data = WZDataFile:getInstance():getUserData()
    local nCurTime = SystemTime:getServerTime()
    local sCurDate = os.date("*t", nCurTime)
    local sKeyFormat = string.format("ACTIVITY%04d%02d%02d_%s", sCurDate.year, sCurDate.month, sCurDate.day, tostring(CacheCenter:getPlayerInfo().id))
    cellId_stringArray = data:getStringValue("ACTIVITY_CELLITEM_ID", sKeyFormat)
    local bRet = false
    self:getHotState()
    if cellId_stringArray == nil or cellId_stringArray == "" then
        return bRet
    end

    local IdMap = WndTask:Split(cellId_stringArray,"-")
    for i=1,#IdMap do
        if self.m_nItemId == tonumber(IdMap[i]) then
            self.b_isClicked = true 
            self.m_bIsHotActivity = false
            bRet = true
            break
        end
    end

    return bRet
end


--@brief    添加点击事件的id
function CellWelfareItem:addCellItemId( nCellId )
    WZLog("CellWelfareItem:addCellItemId|nCellId="..nCellId)
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

--@brief    设置火爆角标状态
function CellWelfareItem:getHotState()
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
--@brief    信息刷新
function CellWelfareItem:_update()
    -- body
    --语言适配
    AdaptLanguage(self)

    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if self.m_sItemName then
        txtItemName:setText(self.m_sItemName)
    end
    --设置高亮
    if self.m_bIsHighLight ~= nil then
        self:setLightVisible(self.m_bIsHighLight)
    end
    if self.m_bIsHighLight == true then
        self:setColorSelect()
    end
    if self.m_bIsHaveRedDot ~= nil then
        self:setRedDotVisible(self.m_bIsHaveRedDot)
    end

    if self.m_nItemId == 999998 then
        self:setFyberTime()
    end

    self:setCorner()
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start----------------------------------------
--@brief    英语适配
function CellWelfareItem:_adaptLanguage_en()
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(22)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_th()
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setScale(0.8)
        txtItemName:setDimensions(GlobalMethod:CCSize(240))
    end
end

function CellWelfareItem:_adaptLanguage_pt( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_vn( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_tr( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_es( )
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setFontSize(20)
        txtItemName:setDimensions((GlobalMethod:CCSize(200,0)))
    end
end

function CellWelfareItem:_adaptLanguage_ug()
    local txtItemName = GetElement(self.m_root, "txtItemName_CellWelfareItem", WZUILabelTTF)
    if txtItemName then
        txtItemName:setScale(0.8)
        txtItemName:setDimensions(GlobalMethod:CCSize(240))
    end
end
-------------------------------------语言适配模块End----------------------------------------