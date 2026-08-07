--CellMounts.lua
--@brief	CellMounts的UI模块
--@date		2015-8-12
--@author	binshao
--@note		坐骑的cell


-------------------------------------公有方法模块Begin--------------------------------------

-- cell入口
function CellMounts:onEnter(element)
	self.m_root = element
end

-- cell出口
function CellMounts:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellMounts:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellMounts")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

-- 选中坐骑
function CellMounts:onSelect()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 0 then 
        WndMounts:updateMountInfo(self.tData.basicInfo.id)
        WndMounts:playRunAni()
    elseif self.m_nType == 3 then 
        WndHVDivineTree:selectCallBack(self)
    else
        WndAssistFigureSetting:selectCallBack(self)
    end
end

-- 点击乘骑按键
function CellMounts:onFighting()
    WZLog("---------------------fighting----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndMounts:send_MOUNTS_ChangeState(self.tData.id)
end

-- 点击取消上阵按键
function CellMounts:onDown()
    WZLog("---------------------onDown----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndMounts:send_MOUNTS_ChangeState(self.tData.id)
end

-- 购买坐骑确认
function CellMounts:buyMountConfirm()
   
    local data = self:getWayResult()
     WZLog("CellMounts:buyMountConfirm ")
    CellMounts.m_currentClick = self
    if JudgeMoneyIsEnough(data.payId, data.payCnt,nil,nil,67, nil, nil, nil, nil, CellMounts.m_currentClick, CellMounts.m_currentClick.sureUseDiamondInstead) then
        CellMounts.m_currentClick:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买坐骑
function CellMounts:sureUseDiamondInstead()
    -- body
    WZLog("----------want buy a mount--------------------",CellMounts.m_currentClick.tData.id,CellMounts.m_currentClick.tData.basicInfo.name)
    ProtocolProcessorWndMounts:send_MOUNTS_Activation(CellMounts.m_currentClick.tData.id)
end

-- 解锁
function CellMounts:onUnlock()

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local data = self:getWayResult()
    if data.type == 3 then
        if data.payId == 1 or data.payId == 2 or data.payId == 70 then
            local str = string.format(LocalStrings.MOUNT_BUY_DESC1,GDatatab_item["id_" .. data.payId].name,data.payCnt)
            MsgBoxManager:showConfirmBox(str, self, self.buyMountConfirm, MSGBOXLEVEL_HIGH, nil)
            local isFinish, finishStep = TeachGroup1:isTeachFinish(19)
            if isFinish ~= true and finishStep >= 0 then
                WindowManager:removeTeachShelterLayer()
                TeachGroup1:setTeachFinish(19,-1)
            end
        else
            local itemInfo = GDatatab_item["id_"..data.payId]
            local str = string.format(LocalStrings.MOUNT_BUY_DESC1,itemInfo.name.."x",data.payCnt)
            MsgBoxManager:showConfirmBox(str, self, self.buyMountConfirm, MSGBOXLEVEL_HIGH, nil)
            local isFinish, finishStep = TeachGroup1:isTeachFinish(19)
            if isFinish ~= true and finishStep >= 0 then
                WindowManager:removeTeachShelterLayer()
                TeachGroup1:setTeachFinish(19,-1)
            end
        end
    else
        if data.isUnlock then
            WZLog("----------want get a mount--------------------",self.tData.id,self.tData.basicInfo.name)
            ProtocolProcessorWndMounts:send_MOUNTS_Activation(self.tData.id)
        else
            if data.type == 2 then MsgBoxManager:showTipBox(data.str) end
        end
    end
end

-- 当前坐骑的获取信息
function CellMounts:getWayResult()
    local tItem,count = self:_getWay() -- count = 1 表示赠送， 2表示等级领取，3 表示购买

    local data = {}
    -- 获取方式和结果
    if count == 1 then
        if self.tData.state == false then
            data = {type = count,isUnlock = true}
        else
            data = {type = count, isUnlock = false, str = LocalStrings.MOUNTS_GM_GET}
        end
    elseif count == 2 then
        data = self:_judgeLvGet(tItem,count)
    elseif count == 3 then
        data = {type = count, isUnlock = false, payType = tItem.s,payId = tItem.t, payCnt = tItem.v}
    end

    return data
end

-- 设置选中状态
function CellMounts:setSelectState(isSel)
    self.selState = isSel
    if self.loadEnd == false then return end
    local img = GetElement(self.m_root,"imgSel_CellMounts",WZUI9Image)
    img:setVisible(self.selState)
end
---------------------------------------公有方法模块End----------------------------------------

---------------------------------------私有方法模块Begin--------------------------------------
function CellMounts:_update()
    --
    self:resetNameContainerSize()
    -- 头像
    self:_createImage()
    -- 信息
    if self.m_nType == 0 or self.m_nType == 1 then 
        self:_initMountInfo()
    elseif self.m_nType == 2 then 
        self:_initKidInfo()
    elseif self.m_nType == 3 then 
        self:_initFruitItemInfo()
    end
    -- 按键状态
    if self.m_nType == 0 then 
        self:_initBtnState()
    end
end

function CellMounts:_initMountInfo()
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF)
    txtLv:setText("Lv"..self.tData.upgradeLevel)
    txtLv:setColor(QUALITYCOLOR[self.tData.basicInfo.quality])
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setText(self.tData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[self.tData.basicInfo.quality])

    local imgRed = GetElement(self.m_root,"imgRed_CellMounts",WZUIImage)

    -- 解锁状态或星级
    if self.tData.isHave then
        -- 星级
        local con = GetElement(self.m_root,"conMountstars_CellMounts",WZUIContainer)
        con:setVisible(true)
        local starCnt = self.tData.advancedLevel
        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_09.png" }
        for i =1, 10 do
            local index = starCnt >= i and 1 or 2
            local star = GetElement(self.m_root,"imgStar"..i.."_CellMounts",WZUIImage)
            star:setFile(imgPath[index])
        end
        imgRed:setVisible(false)
    elseif self:_judgeLockState() then
        local txtLock = GetElement(self.m_root,"txtLock_CellMounts",WZUILabelTTF)
        txtLock:setText(LocalStrings.MOUNT_CAN_LOCK)
        txtLock:setColor(GlobalMethod:ccc3(5,180,0))
        imgRed:setVisible(true)
    else
        local txtLock = GetElement(self.m_root,"txtLock_CellMounts",WZUILabelTTF)
        txtLock:setText(LocalStrings.MOUNT_CANNOT_LOCK)
        txtLock:setColor(GlobalMethod:ccc3(255,89,74))
        imgRed:setVisible(false)
    end

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellMounts",WZUI9Image)
    img:setVisible(self.selState)
end

-- 创建坐骑头像
function CellMounts:_createImage()
    local conImage = GetElement(self.m_root,"conImage_CelllMounts",WZUIContainer)
    local childNode = conImage:getChildByTag(122)
    if not childNode then
        if self.m_nType == 2 then 
            local circleBg = createImage("ui/common/common_icon_txd.png", GlobalMethod:ccp(0.5, 0.5), nil, true, GlobalMethod:ccp(0.5, 0.5))
            conImage:addChild(circleBg)

            local element = CellHead:show(conImage, self.tData.headId, self.tData.faceId, self.tData.sex, nil, nil, nil, nil, nil, nil, nil, true, self.tData.headFrameId)
            element:setScale(1.2)
            element:setTag(122)
        elseif self.m_nType == 3 then 
            local cell,tcell = CellGoodItem:createElement()
            if cell then
                cell = WZUIContainer:luaTo(cell)
                tcell:setCellGoodLocalId(self.tData.itemId, self.tData.num, 17)
                tcell:setBackImgFile2()
                conImage:addChild(cell,0,122)
            end
        else
            local cell,tcell = CellGoodItem:createElement()
            if cell then
                cell = WZUIContainer:luaTo(cell)
                tcell:setCellGoodItem(self.tData,10)
                tcell:setBackImgFile2()
                conImage:addChild(cell,0,122)
            end
        end
    end
end

-- 初始化宠物状态 1出战  2乘骑  3 锁定
function CellMounts:_initBtnState()
    local state = 3
    if self.tData.isHave then state = 2 end
    if self.tData.isPlay then state = 1 end

    for i = 1, 3 do
        local con = GetElement(self.m_root,"conState"..i.."_CellMounts",WZUIContainer)
        con:setVisible(i == state)
    end
end

-- 判断解锁状态
-- self.tData.state = nil 表示没有该坐骑， false表示有该坐骑，但是没有领取， true表示有该坐骑并且领取了
function CellMounts:_judgeLockState()
    local tItem,count = self:_getWay() -- count = 1 表示赠送， 2表示等级领取，3 表示购买
    if count == 1 then
        -- 符合赠送条件，可以解锁
        WZLog("----------lock state1-----------",self.tData.state)
        if self.tData.state == false then return true end
    elseif count == 2 then
        -- 符合等级领取条件可以解锁
        WZLog("----------lock state2-----------",tItem.v,self.tData.state)
        local data = self:_judgeLvGet(tItem,count)
        return data.isUnlock
    elseif count == 3 then
        -- 物品够，提示红点，钻石除外
        local costId,costCnt = tItem.t,tItem.v
        local curCnt = CacheCenter:getPlayerItemCountById(costId)
        WZLog("----------lock state3-----------",costId,costCnt,curCnt)
        if costId == 1 then
            return false
        else
            if curCnt >= costCnt then return true end
            return false
        end
    end
    return false
end


-- 坐骑获取方式
function CellMounts:_getWay()
    local tData = self.tData.tItem.way
    local tItem = {s = 0,t = 0,v = 0}
    local count = #tData
    local type = count
    if count == 1 then
        tItem.s = tData[1][2]      -- 赠送
    elseif count == 2 then
        tItem.s = tData[1][2]      -- 等级(1 玩家等级 5竞技等级 6 恩爱等级 7 公会等级 8排位等级)
        tItem.v = tData[2][2]
    else
        tItem.s = tData[1][2]       -- 购买方式
        tItem.t = tData[2][2]       -- 货币ID
        tItem.v = tData[3][2]       -- 货币的数量
    end
    return tItem,count
end

function CellMounts:_judgeLvGet(tItem,count)
    local lv1 = CacheCenter:getPlayerInfo().level
    local lv5 = CacheCenter:getPlayerInfo().tournamentLevel
    local lv6 = CacheCenter:getPlayerInfo().loveLevel
    local lv7 = CacheCenter:getPlayerInfo().guildLevel
    local lv8 = CacheCenter:getPlayerInfo().segmentLevel
    WZLog("---------------player cur level data-------------------",lv1,lv5,lv6,lv7,lv8)
    local data = {}
    local lvType = tItem.s
    local needLv = tItem.v
    local playerLv = {lv1,nil,nil,nil,lv5,lv6,lv7,lv8 }
    local desc = {LocalStrings.MOUNTS_LEVEL_GET,nil,nil,nil,LocalStrings.MOUNTS_LEVEL_GET5,LocalStrings.MOUNTS_LEVEL_GET6,LocalStrings.MOUNTS_LEVEL_GET7,LocalStrings.MOUNTS_LEVEL_GET8}

    if playerLv[lvType] >= needLv and self.tData.state == nil then
        data = {type = count,isUnlock = true }
    else
        -- 竞技场等级提示额外处理
        if lvType == 5 then needLv = GDatatab_integral["id_"..needLv].dan end
        data = {type = count,isUnlock = false, str = string.format(desc[lvType],needLv)}
    end
    return data
end

--@brief    初始化小孩信息
function CellMounts:_initKidInfo()
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF)
    txtLv:setText("")
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setText(self.tData.name)
    txtName:setColor(QUALITYCOLOR[4])

    local txtLock = GetElement(self.m_root,"txtLock_CellMounts",WZUILabelTTF)
    txtLock:setText(LocalStrings.SPACE55)
    txtLock:setFontSize(20)
    txtLock:setColor(GlobalMethod:ccc3(127,70,26))

    local txtKidAge = GetElement(self.m_root,"txtKidAge_CellMounts",WZUILabelTTF)
    txtKidAge:setText(string.format(LocalStrings.CHECKOTHER_TEXT13, self.tData.level/10))
    txtKidAge:setColor(GlobalMethod:ccc3(229,105,22))

    local imgRed = GetElement(self.m_root,"imgRed_CellMounts",WZUIImage)
    imgRed:setVisible(false)

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellMounts",WZUI9Image)
    img:setVisible(self.selState)
end

--@brief    重新设置名字容器大小
function CellMounts:resetNameContainerSize()
    -- body
    if self.m_nType == 0 then return end 

    GetElement(self.m_root, "conState_CellMounts", WZUIContainer):setVisible(false)
    local conNameBg = GetElement(self.m_root, "conNameBg_CellMounts", WZUIContainer)
    if conNameBg then 
        conNameBg:setRelativeSize(GlobalMethod:CCSize(1.35, 1))
        conNameBg:updateRelativeSize()
    end
end

--@brief    初始化果实道具信息
function CellMounts:_initFruitItemInfo()
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF)
    txtLv:setText("")
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    local basicInfo = GDatatab_item["id_" .. self.tData.itemId]
    txtName:setText(basicInfo.name)
    txtName:setColor(QUALITYCOLOR[basicInfo.quality])

    local txtLock = GetElement(self.m_root,"txtLock_CellMounts",WZUILabelTTF)
    txtLock:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[11] .. ":")
    txtLock:setFontSize(20)
    txtLock:setColor(GlobalMethod:ccc3(127,70,26))

    local strTime = returnToTimeFormat_Day(self.tData.time, true)
    local txtKidAge = GetElement(self.m_root,"txtKidAge_CellMounts",WZUILabelTTF)
    txtKidAge:setText(strTime)
    txtKidAge:setColor(GlobalMethod:ccc3(229,105,22))

    local imgRed = GetElement(self.m_root,"imgRed_CellMounts",WZUIImage)
    imgRed:setVisible(false)

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellMounts",WZUI9Image)
    img:setVisible(false)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellMounts:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtState1_CellMounts",WZUILabelTTF):setFontSize(14)

    GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setFontSize(18)
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setRelativePosition(GlobalMethod:ccp(0.22,0.5))
    txtName:setFontSize(18)

end

function CellMounts:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtState1_CellMounts",WZUILabelTTF):setFontSize(18)
    
    GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF):setFontSize(18)
end

function CellMounts:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtState1_CellMounts",WZUILabelTTF):setFontSize(16)

    GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setFontSize(18)
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setRelativePosition(GlobalMethod:ccp(0.22,0.5))
    txtName:setFontSize(18)
end

function CellMounts:_adaptLanguage_vn(  )
    -- GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtLock_CellMounts",WZUILabelTTF):setScale(0.8)
end

function CellMounts:_adaptLanguage_th(  )
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF)
    txtLv:setScale(0.8)
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setScale(0.8)
    txtName:setRelativePosition(GlobalMethod:ccp(0.24,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(240))
end

function CellMounts:_adaptLanguage_ug(  )
    local txtState1 = GetElement(self.m_root,"txtState1_CellMounts",WZUILabelTTF)
    txtState1:setScale(0.6)
    txtState1:setDimensions(GlobalMethod:CCSize(100))
    local txtState2 = GetElement(self.m_root,"txtState2_CellMounts",WZUILabelTTF)
    txtState2:setScale(0.6)
    txtState2:setDimensions(GlobalMethod:CCSize(100))

    GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF):setScale(0.7)
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    txtName:setScale(0.7)
end

function CellMounts:_adaptLanguage_tr(  )
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts",WZUILabelTTF)
    txtLv:setScale(0.8)
    local txtName = GetElement(self.m_root,"txtName_CellMounts",WZUILabelTTF)
    txtName:setScale(0.8)
    txtName:setRelativePosition(GlobalMethod:ccp(0.24,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(240))
end
------------------------------------语言适配End-------------------------------------------------