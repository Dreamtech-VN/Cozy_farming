--WndStarSoul.lua
--@brief	WndStarSoul的UI模块
--@date		2015/12/16
--@author	Tianxiang_Xu
--@note		星魂系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndStarSoul:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_StarSoul)
    ProtocolProcessorWndStarSoul:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndStarSoul:onExit(element)
    ProtocolProcessorWndStarSoul:unregAll()
	self:_unInit()
end

function WndStarSoul:onEnterTransitionDidFinish(element)
    -- body
    --添加屏幕底部项
    self:_addTop()
    local pageCon = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    pageCon:setMoveActionFinishCallback("onPageChanged")
    self:_createLoading()
    ProtocolProcessorWndStarSoul:send_STARSOUL_GetStarList()
end

--@brief    退出回调
function WndStarSoul:onCloseWnd()
    -- body
    WZLog("******* WndStarSoul:onCloseWnd ********")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , WndStarSoul , true)
end

--@brief    上一个星系
function WndStarSoul:onClickPrevious(element)
    -- body
    WZLog("******* WndStarSoul:onClickPrevious ********")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex > 0 then
        if self.m_bLoadFinish then
            self:_pageTurning(self.m_nCurPageIndex-1)
        end
    else
        self:checkPageIndex(-1)
    end
end

--@brief    下一个星系
function WndStarSoul:onClickNext(element)
    -- body
    WZLog("WndStarSoul:onClickNext ",self.m_nCurPageIndex,self.m_nCurStarIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurPageIndex < self.m_nCurStarIndex then
        if self.m_bLoadFinish  then
            self:_pageTurning(self.m_nCurPageIndex+1)
        end
    else
        self:checkPageIndex(1)
    end
end

--@brief    检查滑动的页数
--@param    nPageOffset,要滑动的页数,例如1表示要滑到下一个关卡，-1表示滑到上一个关卡
function WndStarSoul:checkPageIndex(nPageOffset)
    --还未开放
    MsgBoxManager:showTipBox(LocalStrings.STARSOUL_LOCKED_TIPS)
end

--@brief    翻页时被调用的函数
--@param    nIndex:当前序号
function WndStarSoul:onPageChanged(nIndex)
    WZLog("WndStarSoul:onPageChanged ")
    if nIndex == nil then
        local pageCon = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
        nIndex = pageCon:getCurrentPageIndex()
    end
    if  self.m_nCurPageIndex == nIndex then
        return
    end
    self:_setCurrentPageIndex(nIndex)
end


--@brief    触摸开始回调
function WndStarSoul:onTouchBegan(element, pt)
    -- body
    WZLog("******** WndStarSoul:onTouchBegan **********")
    local conInformation = GetElement(self.m_root, "conInformation_WndStarSoul", WZUIContainer)
    if conInformation == nil then return end
    
    if conInformation:getChildByTag(888) then
        conInformation:removeChildByTag(888, true)
    end

--    local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
--    local cellStarSoul = pgconCopy:getPageElement(self.m_nCurPageIndex)
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)
    if conCnt:getChildByTag(888) then
        conCnt:removeChildByTag(888, true)
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief    顶部触摸回调
function WndStarSoul:onShowTopTips()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then return end

    local conInformation = GetElement(self.m_root, "conInformation_WndStarSoul", WZUIContainer)
    if conInformation == nil then return end

    local celElement = WZUISystem:getInstance():createElement("CellTopTips_WndStarSoul")
    if celElement == nil then return end
    GetElement(celElement, "txtCoinsTips_CellTopTips", WZUILabelTTF):setText(LocalStrings.WHERE_GET_COPY)
    celElement:setRelativePosition(GlobalMethod:ccp(0.6, 0.75))
    celElement:setVisible(true)
    conInformation:addChild(celElement, 6, 888)
end

--@brief    点击星系图标回调
function WndStarSoul:onShowGalaxyTips()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then return end

    local celElement = WZUISystem:getInstance():createElement("CellGalaxyTips_WndStarSoul")
    if celElement == nil then return end

    local conInformation = GetElement(self.m_root, "conInformation_WndStarSoul", WZUIContainer)
    if conInformation == nil then return end

    local starProperty = self.m_tStarProperty[self.m_nCurPageIndex + 1]
    if starProperty == nil then return end
    for i = 1, #self.m_tStarProperty[self.m_nCurPageIndex + 1] do

        local txtPropertyValue = string.format("txtPropertyValue%d_CellGalaxyTips", i)
        
        local txtPropertyName = string.format("txtPropertyName%d_CellGalaxyTips", i)
        GetElement(celElement, txtPropertyName, WZUILabelTTF):setText(ATTR_TITLE[starProperty[i][1]] .. ":")
        GetElement(celElement, txtPropertyValue, WZUILabelTTF):setText("+" .. tostring(starProperty[i][2]))
    end

    local txtStarName = GetElement(celElement, "txtStarName_CellGalaxyTips", WZUILabelTTF):setText(self.m_tStarSoulList[self.m_nCurPageIndex + 1][1].name .. LocalStrings.STAR_PROPERTY_ADD)
    local spineStarIcon = GetElement(celElement, "spineStarIcon_CellGalaxyTips", WZUISpine)
    spineStarIcon:play(self.m_tStarSoulList[self.m_nCurPageIndex + 1][1].star_icon, true)

    celElement:setRelativePosition(GlobalMethod:ccp(0.2, 0.58))

    celElement:setVisible(true)
    conInformation:addChild(celElement, 6, 888)
end

--@brief    点击总战力图标回调
function WndStarSoul:onShowTotalFightingTips()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_root == nil then return end

    local celElement = WZUISystem:getInstance():createElement("CellTotalFightingTips_WndStarSoul")
    if celElement == nil then return end

    local conInformation = GetElement(self.m_root, "conInformation_WndStarSoul", WZUIContainer)
    if conInformation == nil then return end

    for i = 1, #self.m_tTotalProperty do
        local txtPropertyValue = string.format("txtPropertyValue%d_CellTotalFightingTips", i)
        
        local txtPropertyName = string.format("txtPropertyName%d_CellTotalFightingTips", i)
        GetElement(celElement, txtPropertyName, WZUILabelTTF):setText(ATTR_TITLE[self.m_tTotalProperty[i][1]] .. ":")
        GetElement(celElement, txtPropertyValue, WZUILabelTTF):setText("+" .. tostring(self.m_tTotalProperty[i][2]))
    end

    local txtStarName = GetElement(celElement, "txtStarName_CellTotalFightingTips", WZUILabelTTF):setText(LocalStrings.TOTAL_FIGHTING_ADD)

    celElement:setRelativePosition(GlobalMethod:ccp(0.2, 0.3))
    
    celElement:setVisible(true)
    conInformation:addChild(celElement, 6, 888)
end

--@brief    点击星系中的某一个星回调
--@param    element 点击的节点
--@param    star:点击节点的星座Id
--@param    star_soul:点击节点的星魂Id
--@param    status:点击节点的状态0：未激活；1：待激活；2：已激活
--@param    absPosition :星魂的绝对位置
function WndStarSoul:onClickStarCallBack(element, id, star, star_soul, status, cost, absPosition)
    -- body
    WZLog("***** WndStarSoul:onClickStarCallBack ********", id, star, star_soul, status)
    if status == 0 then   
        self:onUnActivityStarTips(element, id, star, star_soul, absPosition)
    elseif status == 1 then
        if cost[1][1] == 20 and self.m_nSimStarNum < cost[1][2] then
            --提示跳单人副本
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVE_BTN_GO}
            MsgBoxManager:showConfirmBox(LocalStrings.STAR_NOT_ENOUGH1, self, self.needMoreSimStar, nil, tCustomUIConfig)
            return
        end 
        if cost[1][1] == 21 and self.m_nMulStarNum < cost[1][2] then
            --提示跳组队副本
            local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.ACTIVE_BTN_GO}
            MsgBoxManager:showConfirmBox(LocalStrings.STAR_NOT_ENOUGH2, self, self.needMoreMulStar, nil, tCustomUIConfig)
            return
        end 
        self:onActivityStar(element, id, star, star_soul)
    elseif status == 2 then
        self:onActivityStarTips(element, id, star, star_soul, absPosition)
    end
end

function WndStarSoul:needMoreSimStar()
    -- body
    JumpByUIId(12)
end

function WndStarSoul:needMoreMulStar()
    -- body
    JumpByUIId(15)
end

--@biref    已激活星弹的Tips
function WndStarSoul:onActivityStarTips(element, id, star, star_soul, absPosition)
    -- body
    if self.m_root == nil then return end

    local celElement = WZUISystem:getInstance():createElement("CellActivityTips_WndStarSoul")
    if celElement == nil then return end

    local tData = self:_getStarInfoById(star, star_soul)
    if tData == nil then return end

    GetElement(celElement, "txtStarName_CellActivityTips", WZUILabelTTF):setText(tData.star_name)
    GetElement(celElement, "txtStatus_CellActivityTips", WZUILabelTTF):setText(LocalStrings.STAR_SOUL_HAVED_ACTIVE)
    GetElement(celElement, "txtPropertyName_CellActivityTips", WZUILabelTTF):setText(ATTR_TITLE[tData.property[1][1]])
    GetElement(celElement, "txtPropertyValue_CellActivityTips", WZUILabelTTF):setText("+" .. tostring(tData.property[1][2]))

--    local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
--    local cellStarSoul = pgconCopy:getPageElement(self.m_nCurPageIndex)
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)

    celElement:setUseAbsCoordinate(true)
    celElement:setAbsPosition(absPosition)
    celElement:setVisible(true)
    conCnt:addChild(celElement, 26, 888)

end

--@biref    未激活星弹的Tips
function WndStarSoul:onUnActivityStarTips(element, id, star, star_soul, absPosition)
    -- body
    if self.m_root == nil then return end
    local celElement = WZUISystem:getInstance():createElement("CellUnActivityTips_WndStarSoul")
    if celElement == nil then return end

    local tData = self:_getStarInfoById(star, star_soul)
    if tData == nil then return end

    WZLog("******** WndStarSoul:onUnActivityStarTips ******", Serialize(tData))

    GetElement(celElement, "txtStarName_CellUnActivityTips", WZUILabelTTF):setText(tData.star_name)
    GetElement(celElement, "txtStatus_CellUnActivityTips", WZUILabelTTF):setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
    GetElement(celElement, "txtPropertyName_CellUnActivityTips", WZUILabelTTF):setText(ATTR_TITLE[tData.property[1][1]])
    GetElement(celElement, "txtPropertyValue_CellUnActivityTips", WZUILabelTTF):setText("+" .. tostring(tData.property[1][2]))
    --消耗
    local sCostName = LocalStrings.NEED_STAR

    local sIconFile = self:_getIconFile(tData.cost[1][1])
    GetElement(celElement, "imgCoins_CellUnActivityTips", WZUIImage):setFile(sIconFile)
    GetElement(celElement, "txtCostName_CellUnActivityTips", WZUILabelTTF):setText(sCostName)
    GetElement(celElement, "txtCostValue_CellUnActivityTips", WZUILabelTTF):setText(tData.cost[1][2])

    -- local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    -- local cellStarSoul = pgconCopy:getPageElement(self.m_nCurPageIndex)
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)

    celElement:setUseAbsCoordinate(true)
    celElement:setAbsPosition(absPosition)
    celElement:setVisible(true)
    conCnt:addChild(celElement, 26, 888)
end

--@brief    发送激活请求
function WndStarSoul:onActivityStar(element, id, star, star_soul)
    -- body
    local bIsActiving = self:_isActivityOkSpineExist()
    if bIsActiving == true then
        --如果正在激活星魂，不能激活下一个
        return
    end
    self:_createLoading()
    ProtocolProcessorWndStarSoul:send_STARSOUL_ActivityStar(id)
end

--@brief    显示激活成功动画
function WndStarSoul:activityOKSpine()
    -- body
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)

    if conCnt == nil then return end
    if conCnt:getChildByTag(999) then 
        conCnt:removeChildByTag(999, true)
    end

    local spineOk = WZUISpine:create()
    if spineOk == nil then return end

    spineOk:setFileAtlas("ui/ui_xinghun_jhcg.atlas")
    spineOk:setFileJson("ui/ui_xinghun_jhcg.json")
    spineOk:setAnimationName("effect")
    spineOk:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    spineOk:setRelativePosition(GlobalMethod:ccp(0.5,0.6))

    conCnt:addChild(spineOk, 2, 999)
    spineOk:play("effect", false)

    conCnt:enableSchedule("removeActivityOkSpine", 2)
end

--@brief    动画播放完后，移除
function WndStarSoul:removeActivityOkSpine(element)
    -- body
    element:disableSchedule()
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)
    if conCnt == nil then return end
    if conCnt:getChildByTag(999) then 
        conCnt:removeChildByTag(999, true)
    end
end

--@brief    更新界面显示信息
function WndStarSoul:_updateInfo()
    -- body
    GetElement(self.m_root, "txtSimStarNum_WndStarSoul", WZUILabelTTF):setText(tostring(self.m_nSimStarNum))
    GetElement(self.m_root, "txtMulStarNum_WndStarSoul", WZUILabelTTF):setText(tostring(self.m_nMulStarNum))
    --星星图标
    local sCoinIconFile = self:_getIconFile(20)
    GetElement(self.m_root, "imgIcon1_WndStarSoul", WZUIImage):setFile(sCoinIconFile)
    sCoinIconFile = self:_getIconFile(21)
    GetElement(self.m_root, "imgIcon2_WndStarSoul", WZUIImage):setFile(sCoinIconFile)
    --总战力加成
    GetElement(self.m_root, "txtFightTotalAdd_WndStarSoul", WZUILabelAtlasFont):setText(tostring(self.m_nTotalFighting))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    判断激活成功动画是否存在
function WndStarSoul:_isActivityOkSpineExist()
    -- body
    local conCnt = GetElement(self.m_root, "conCnt_WndStarSoul", WZUIContainer)
    if conCnt == nil then return end
    if conCnt:getChildByTag(999) then 
        return true
    end
    return false
end
--@brief    屏幕顶部项
function WndStarSoul:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/bag_icon_xinghun.png", WndStarSoul, WndStarSoul.onCloseWnd, true, true, false, "WndStarSoul")
    self.m_root:addChild(celElement)
end

--@brief    获取奖励物品的图标
function WndStarSoul:_getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

--@brief    根据id获取对应的数据信息
--@param    star:星座id
--@param    star_soul:星魂id
function WndStarSoul:_getStarInfoById(star, star_soul)
    -- body
    for i = 1, #self.m_tStarSoulList[star] do
        WZLog("****** WndStarSoul:_getStarInfoById 111*******", self.m_tStarSoulList[star][i].star_soul, star_soul)
        if self.m_tStarSoulList[star][i].star_soul == star_soul then
            return self.m_tStarSoulList[star][i]
        end
    end

    return nil
end

--@brief    load菊花
function WndStarSoul:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    关闭菊花
function WndStarSoul:_closeLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end

--@brief    设置当前页数
--@param    nIndex:页数
function WndStarSoul:_setCurrentPageIndex(nIndex)
    WZLog("WndStarSoul:_setCurrentPageIndex = ",nIndex)
    if self.m_root == nil then
        return
    end

    self.m_nCurPageIndex = nIndex
    
    self:_updatePageButton(self.m_nCurPageIndex) --更新翻页按钮
    
end

--@brief    更新翻页按钮
--@param    nCurPageIndex:当前页数
function WndStarSoul:_updatePageButton(nCurPageIndex)
    WZLog("WndStarSoul:_updatePageButton =",nCurPageIndex)
    local btnNext = GetElement(self.m_root, "btnNext_WndStarSoul", WZUIButton)
    local btnPrevious = GetElement(self.m_root, "btnPrevious_WndStarSoul", WZUIButton)
    
    if nCurPageIndex == 0 then
        btnNext:setVisible(true)
        btnPrevious:setVisible(false)
    elseif nCurPageIndex+1 == #self.m_tStarSoulList then
        btnNext:setVisible(false)
        btnPrevious:setVisible(true)
    else
        btnNext:setVisible(true)
        btnPrevious:setVisible(true)
    end
end

function WndStarSoul:_loadAllPage(element,delay)
    -- body
    if self.m_root == nil then return end

    local pageCon = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    pageCon:setTouchEnable(true)
    --pageCon:setMoveActionFinishCallback("onPageChanged")

    local nLoadPageNum = self.m_nCurStarIndex + 1
    if nLoadPageNum > #self.m_tStarSoulList then
        nLoadPageNum = #self.m_tStarSoulList
    end
    --先加载当前星魂
    local cellStarSoul = self:_createCellStarSoul(self.m_tStarSoulList[self.m_nCurStarIndex][1].star)
    pageCon:setPageElement(self.m_nCurStarIndex - 1,cellStarSoul)


    self.m_nLoadNum = nLoadPageNum
    pageCon:enableSchedule("onLoadEachPage")
end

--@brief    分贞加载各星座
function WndStarSoul:onLoadEachPage(element)
    -- body
    element = WZUIPageContainer:luaTo(element)
    if self.m_tStarSoulList == nil or #self.m_tStarSoulList == 0 then
        element:disableSchedule()
        return
    end

    if self.m_nLoadIndex > self.m_nLoadNum then
        self.m_nCurPageIndex = self.m_nCurStarIndex - 1
        self:_updatePageButton(self.m_nCurPageIndex)
        element:disableSchedule()
        return
    end

    if self.m_nLoadIndex == self.m_nCurStarIndex then
        self.m_nLoadIndex = self.m_nLoadIndex + 1
        return
    end


    local cellStarSoul = self:_createCellStarSoul(self.m_tStarSoulList[self.m_nLoadIndex][1].star)
    element:setPageElement(self.m_nLoadIndex - 1,cellStarSoul)

    element:setDefaultCenterPage(self.m_nCurStarIndex - 1)
    self.m_nLoadIndex = self.m_nLoadIndex + 1
end

--@brief    创建星系页
--@param    nTag,序号
--@return   #1,星系页UI节点
function WndStarSoul:_createCellStarSoul(nTag)
    -- body
    WZLog("WndStarSoul:_createCellStarSoul ",nTag)
    local cellStarSoul = CreateElement("CellStarSoul_WndStarSoul")
    assert(cellStarSoul, "WndStarSoul create CellStarSoul_WndStarSoul failure!")
    cellStarSoul:setVisible(true)

    --线
    for i = 1, #self.m_tStarSoulList[nTag] do
        if i > 1 then 
            local point1 = self.m_tStarSoulList[nTag][i - 1].absPosition
            local point2 = self.m_tStarSoulList[nTag][i].absPosition
            self:_createLineByTwoPoints(cellStarSoul, point1, point2)
        end
    end
    --星魂
    if self.m_tStarObjList[nTag] == nil then
        self.m_tStarObjList[nTag] = {}
    end

    local bIsFogVisible = true

    for i = 1, #self.m_tStarSoulList[nTag] do
        local  celElement, tNewObj = CellStarSoul:createElement()
        self.m_tStarObjList[nTag][i] = tNewObj
        WZLog("_createCellStarSoul 00000", self.m_tStarObjList[nTag][i])
        celElement:setUseAbsCoordinate(true)
        celElement:setAbsPosition(self.m_tStarSoulList[nTag][i].absPosition)
        tNewObj:setData(self.m_tStarSoulList[nTag][i])
        tNewObj:setOnClickCellCallback(self,self.onClickStarCallBack)
        celElement:setTag(i)
        cellStarSoul:addChild(celElement)
        if self.m_tStarSoulList[nTag][i].status ~= 2 then
            bIsFogVisible = false
        end
    end

    --雾气粒子效果是否显示
    GetElement(cellStarSoul, "particleAllActivity_WndStarSoul", WZUIParticle):setVisible(bIsFogVisible)
    
    --水印图片
    local sFile = self:_getWaterMarkFile(self.m_tStarSoulList[nTag][1].star)
    GetElement(cellStarSoul, "imgStarIcon1_CellStarSoul", WZUIImage):setFile(sFile) 

    GetElement(cellStarSoul, "txtStarTitle_CellStarSoul", WZUILabelTTF):setText(self.m_tStarSoulList[nTag][1].name)

    return cellStarSoul
end

--@brief    星与星之间的连线
--@param    point1,point2:线的两点
function WndStarSoul:_createLineByTwoPoints(element, point1, point2)
    -- body
    -- local conForLine = WZUIContainer:create()
    -- conForLine:setUseAbsCoordinate(true)
    -- conForLine:setUseAbsSize(true)

    
--    imgForLine:setUseOriginSize(true)

--    conForLine:addChild(imgForLine)

    local conWidth = math.floor(math.sqrt(math.pow(point1.x - point2.x, 2) + math.pow(point1.y - point2.y, 2)))
    local conAngle = math.deg(math.asin(((point1.y - point2.y)/conWidth)))
    if point1.x > point2.x then 
        conAngle = (-1) * conAngle
    end

    WZLog("******** WndStarSoul:_createLineByTwoPoints ******* 000", conAngle)

    -- conForLine:setAbsContentSize(GlobalMethod:CCSize(conWidth, 12))
    -- conForLine:setRotation(conAngle)
    local imgForLine = CCSprite:create("ui/starsoul/common_scale9_xinghgx.png", CCRect(0, 0, conWidth, 18))
--    imgForLine:setFile("")
    imgForLine:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
--    imgForLine:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
--    imgForLine:setUseAbsCoordinate(true)
--    imgForLine:setContentSize(GlobalMethod:CCSize(conWidth, 18))
    imgForLine:setRotation(conAngle)

    local conX = point1.x + math.floor((point2.x - point1.x) / 2)
    local conY = point1.y + math.floor((point2.y - point1.y) / 2)
    imgForLine:setPosition(GlobalMethod:ccp(conX, conY))

    element:addChild(imgForLine)
end

--@brief    返回星座地图水印图片
--@param    starId星系id
function WndStarSoul:_getWaterMarkFile(starId)
    -- body
    local sFile = ""
    if starId == 1 then
        sFile = "ui/starsoul/common_pic_shuiping1.png"
    elseif starId == 2 then
        sFile = "ui/starsoul/common_pic_shuangyuzuo.png"
    elseif starId == 3 then
        sFile = "ui/starsoul/common_pic_baiyangzuo.png"
    elseif starId == 4 then
        sFile = "ui/starsoul/common_pic_jinniuzuo.png"
    elseif starId == 5 then
        sFile = "ui/starsoul/common_pic_shuangzizuo.png"
    elseif starId == 6 then
        sFile = "ui/starsoul/common_pic_juxiezuo.png"
    elseif starId == 7 then
        sFile = "ui/starsoul/common_pic_shizizuo.png"
    elseif starId == 8 then
        sFile = "ui/starsoul/common_pic_chunvzuo.png"
    elseif starId == 9 then
        sFile = "ui/starsoul/common_pic_tianchengzuo.png"
    elseif starId == 10 then
        sFile = "ui/starsoul/common_pic_sheshouzuo.png"
    elseif starId == 11 then
        sFile = "ui/starsoul/common_pic_tianxiezuo.png"
    elseif starId == 12 then
        sFile = "ui/starsoul/common_pic_mojiezuo.png"
    end

    return sFile
end

--@brief    翻页
--@param    nToIndex:要翻到的页数
function WndStarSoul:_pageTurning(nToIndex)
    WZLog("WndStarSoul:_pageTurning .... = ",nToIndex)
    local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    pgconCopy:setTouchEnable(false)
    DelayCallFunction(self._setCurrentPageIndex, self, 0.15, nToIndex) --为了更好的操作体验，提前设置了当前页
    
    local cell = pgconCopy:getPageElement(nToIndex)
    local movePsx , movePsy = pgconCopy:getMoveElement():getPosition()
    cell = WZUIContainer:luaTo(cell)
    if cell == nil then
        return
    end

    pgconCopy:UpdateInsidePosition()
    local minX = pgconCopy:getMinPosition().x
    local maxX = pgconCopy:getMaxPosition().x
    local psX,psY = cell:getPosition()
    local moX = maxX - nToIndex*934
    self.m_bLoadFinish = false
    local actionTemp = CCEaseOut:create(CCMoveTo:create(0.6, GlobalMethod:ccp(moX,psY)),1)
    local arrayAction = CCArray:create()
    arrayAction:addObject(actionTemp)
    arrayAction:addObject(CCCallFunc:create(function () 
        self.m_bLoadFinish = true 
        if self.m_root ~= nil then
            local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
            pgconCopy:setTouchEnable(true)
        end
     end 
     ))
    pgconCopy:getMoveElement():runAction(CCSequence:create(arrayAction))

end

--@brief    激活某个星魂后刷新激活星魂的图标和下个待激活星魂的显示
function WndStarSoul:_updateCurAndNextStar()
    -- body
    WZLog("******** WndStarSoul:_updateCurAndNextStar *********")
    local tTemp = self.m_tStarSoulList[self.m_nCurPageIndex + 1]
    local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    local cellStarSoul = pgconCopy:getPageElement(self.m_nCurPageIndex)
    if cellStarSoul == nil then
        WZLog("********* cellStarSoul is nilnil *********")
    end
    local nTag = self.m_nCurPageIndex + 1

    local bToNextPage = false

    for i = 1, #tTemp do
        if tTemp[i].status == 1 then 
            local tNewObj = self.m_tStarObjList[nTag][i]
            self.m_tStarSoulList[self.m_nCurPageIndex + 1][i].status = 2
            tTemp[i].status = 2
            WZLog("******** WndStarSoul:_updateCurAndNextStar 666 *********",Serialize(tTemp[i]))
            tNewObj:setData(tTemp[i])
            --下一个待激活的星魂
            if i >= #tTemp then
                bToNextPage = true
            else
                local tNextNewObj = self.m_tStarObjList[nTag][i + 1]
                self.m_tStarSoulList[self.m_nCurPageIndex + 1][i + 1].status = 1
                tTemp[i + 1].status = 1
                tNextNewObj:setData(tTemp[i + 1])
            end
            break
        end
    end
    self.m_bToNextPage = bToNextPage
    local conPage = GetElement(self.m_root, "conPage_WndStarSoul", WZUIContainer)
    conPage:enableSchedule("_autoJumpNextPage", 2)
end

function WndStarSoul:_autoJumpNextPage(element)
    -- body
    element:disableSchedule()
    local bToNextPage = self.m_bToNextPage 
    local pgconCopy = GetElement(self.m_root, "pgconStarSoul_WndStarSoul", WZUIPageContainer)
    --判断是否是尾页
    WZLog("******** WndStarSoul:_autoJumpNextPage 000********", bToNextPage)
    if self.m_nCurPageIndex + 1 < #self.m_tStarSoulList then
        if bToNextPage == true then
            WZLog("******** WndStarSoul:_autoJumpNextPage 111*********")
            --当前星座星魂全部激活，则显示雾气粒子效果
            local curCellStarSoul = pgconCopy:getPageElement(self.m_nCurPageIndex)
            if curCellStarSoul then
                GetElement(curCellStarSoul, "particleAllActivity_WndStarSoul", WZUIParticle):setVisible(true)
            end
            --清掉当前窗口的tips
            self:onTouchBegan()
            
            self.m_nCurPageIndex = self.m_nCurPageIndex + 1
            
            self.m_tStarSoulList[self.m_nCurPageIndex + 1][1].status = 1
            local tNewObj = self.m_tStarObjList[self.m_nCurPageIndex + 1][1]
            tNewObj:setData(self.m_tStarSoulList[self.m_nCurPageIndex + 1][1])

            local nLoadPageNum = self.m_nCurPageIndex + 1
             WZLog("******** WndStarSoul:_autoJumpNextPage 222*********", nLoadPageNum, self.m_nCurPageIndex)
            if nLoadPageNum <= #self.m_tStarSoulList - 1 then
                local cellStarSoul = self:_createCellStarSoul(self.m_tStarSoulList[nLoadPageNum + 1][1].star)
                pgconCopy:setPageElement(nLoadPageNum,cellStarSoul)
            end
            self:_updatePageButton(self.m_nCurPageIndex) --更新翻页按钮
            pgconCopy:setDefaultCenterPage(self.m_nCurPageIndex)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
