--CellMounts1.lua
--@brief	CellMounts1的UI模块
--@date		2021/03/03
--@author	hyc
--@note		坐骑cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMounts1:onEnter(element)
	self.m_root = element
end

-- cell出口
function CellMounts1:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellMounts1:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellMounts1")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()

    AdaptLanguage(self)
end

-- 选中坐骑
function CellMounts1:onSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bIsMount then
        if self.m_nRewardStatus == 0 then
            WndItemInfo:showInfo(self.m_root,WndLibrary.m_root,1,self.tData,false,nil,true)
            -- WndItemInfo:showInfo(self.m_root,WndLibrary.m_root,1,self.tData, false)
        elseif self.m_nRewardStatus == 1 then
            ProtocolProcessorRecycling:send_PLAYERITEM_ReceivePokedexReward(self.tData.id)
        end
    else
        WndMounts:updateMountInfo(self.tData.basicInfo.id)
        WndMounts:playRunAni()
    end
end

-- 点击乘骑按键
function CellMounts1:onFighting()
    WZLog("---------------------fighting----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndMounts:send_MOUNTS_ChangeState(self.tData.id)
end

-- 点击取消上阵按键
function CellMounts1:onDown()
    WZLog("---------------------onDown----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndMounts:send_MOUNTS_ChangeState(self.tData.id)
end

-- 购买坐骑确认
function CellMounts1:buyMountConfirm()
   
    local data = self:getWayResult()
     WZLog("CellMounts:buyMountConfirm ")
    CellMounts1.m_currentClick = self
    if JudgeMoneyIsEnough(data.payId, data.payCnt,nil,nil,67, nil, nil, nil, nil, CellMounts1.m_currentClick, CellMounts1.m_currentClick.sureUseDiamondInstead) then
        CellMounts1.m_currentClick:sureUseDiamondInstead()
    end
end

--@brief    确认用钻石代替礼券购买坐骑
function CellMounts1:sureUseDiamondInstead()
    -- body
    WZLog("----------want buy a mount--------------------",CellMounts1.m_currentClick.tData.id,CellMounts1.m_currentClick.tData.basicInfo.name)
    ProtocolProcessorWndMounts:send_MOUNTS_Activation(CellMounts1.m_currentClick.tData.id)
end

-- 解锁
function CellMounts1:onUnlock()

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
function CellMounts1:getWayResult()
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
function CellMounts1:setSelectState(isSel)
    self.selState = isSel
    if self.loadEnd == false then return end
    local img = GetElement(self.m_root,"img9Choose_CellMounts1",WZUI9Image)
    img:setVisible(self.selState)
end
---------------------------------------公有方法模块End----------------------------------------

---------------------------------------私有方法模块Begin--------------------------------------
function CellMounts1:_update()
    if self.m_bIsMount then
        self:setLibraryData()
    else
        self:_initMountInfo()
    end
end

--图鉴的时候
function CellMounts1:setLibraryData()
    if not self.tData then return end

    GetElement(self.m_root,"conXing_CellMounts1",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"txtLv_CellMounts1",WZUILabelTTF):setVisible(false)
    GetElement(self.m_root,"imgFight_CellMounts1",WZUIImage):setVisible(false)
    GetElement(self.m_root,"conNot_CellMounts1",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"txtName_CellMounts1",WZUILabelTTF):setText(self.tData.name)

    if self.tData.quality then
        GetElement(self.m_root,"imgBg_CellMounts1",WZUIImage):setFile(g_tQualityBG[self.tData.quality])
    end
    local imgIcon = GetElement(self.m_root,"imgIcon_CellMounts1",WZUIImage)
    local m_icon
    if self.m_nCurIndex == 5 then
        m_icon = string.gsub(self.tData.icon,".png","_1.png")
    elseif self.m_nCurIndex == 6 then
        m_icon = string.gsub(self.tData.icon,".png","_1.png")
    elseif self.m_nCurIndex == 7 then
        if self.tData.property and GDatatab_shape_skins["id_"..self.tData.property[1][1]] then
            m_icon = GDatatab_shape_skins["id_"..self.tData.property[1][1]].bust
        end
        imgIcon:setScale(1.05)
        imgIcon:setRelativePosition(ccp(0.5,0.6))
    end
    if m_icon then
        imgIcon:setFile(m_icon)
    end

    local txtRewardRich = GetElement(self.m_root,"txtRewardRich",WZUIFreeTextBox)
    local id,num
    if self.m_nCurIndex and self.m_nCurIndex >= 5 and self.m_nCurIndex <= 7 then
        id = self.tData.pokedex[1][1]
        num = self.tData.pokedex[1][2]
    else
        id = self.tData.pokedex[1][4]
        num = self.tData.pokedex[1][5]
    end
    if id and num then
        local itemInfo = GDatatab_item["id_" ..id]
        txtRewardRich:setVisible(true)
        txtRewardRich:setShowText(string.format([[<I Z="0.35">%s</I><T C="127,70,26" S="18" P="1">%d</T>]],itemInfo.icon,num))
    end
    local imgHasReward = GetElement(self.m_root,"imgHasReward",WZUIImage)
    if self.tData.owned then
        imgHasReward:setVisible(true)
        txtRewardRich:setVisible(false)
    end
    GetElement(self.m_root,"btnSelect",WZUIButton):setVisible(true)
    local imgGetReward = GetElement(self.m_root,"imgGetReward",WZUIImage)
    if self.m_nRewardStatus == 1 then
        imgGetReward:setVisible(true)
    end
end
--可领取
function CellMounts1:setGetReward()
    if not self.m_root then return end
    GetElement(self.m_root,"imgGetReward",WZUIImage):setVisible(false)
    GetElement(self.m_root,"btnSelect",WZUIButton):setVisible(false)
    GetElement(self.m_root,"imgHasReward",WZUIImage):setVisible(true)
    GetElement(self.m_root,"txtRewardRich",WZUIFreeTextBox):setVisible(false)
end

function CellMounts1:_initMountInfo()
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellMounts1",WZUILabelTTF)
    txtLv:setText("Lv"..self.tData.upgradeLevel)

    GetElement(self.m_root,"imgBg_CellMounts1",WZUIImage):setFile(g_tQualityBG[self.tData.basicInfo.quality])
    GetElement(self.m_root,"imgTxtBg_CellMounts1",WZUIImage):setFile(g_tQualityNameBG[self.tData.basicInfo.quality])
    GetElement(self.m_root,"txtXing_CellMounts1",WZUILabelTTF):setText(self.tData.advancedLevel)
    if self.tData.isHave then
    	GetElement(self.m_root,"conNot_CellMounts1",WZUIContainer):setVisible(false)
    else 
        GetElement(self.m_root,"txtLv_CellMounts1",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"conXing_CellMounts1",WZUIContainer):setVisible(false)
    end
    local mountIcon = string.gsub(self.tData.basicInfo.icon,".png","_1.png")
    GetElement(self.m_root,"imgIcon_CellMounts1",WZUIImage):setFile(mountIcon)
    GetElement(self.m_root,"imgFight_CellMounts1",WZUIImage):setVisible(false)
    if self.tData.isPlay then
    	GetElement(self.m_root,"imgFight_CellMounts1",WZUIImage):setVisible(true)
    else 
    	GetElement(self.m_root,"imgFight_CellMounts1",WZUIImage):setVisible(false)
    end
    GetElement(self.m_root,"txtName_CellMounts1",WZUILabelTTF):setText(self.tData.basicInfo.name)

    --红点
    local imgRed = GetElement(self.m_root,"imgRed_CellMounts1",WZUIImage)
    if self:_judgeLockState() then
        imgRed:setVisible(true)
    else
        imgRed:setVisible(false)
    end

    -- -- 是否选中
    local img = GetElement(self.m_root,"img9Choose_CellMounts1",WZUI9Image)
    img:setVisible(self.selState)
end


-- 初始化宠物状态 1出战  2乘骑  3 锁定
function CellMounts1:_initBtnState()
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
function CellMounts1:_judgeLockState()
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
        -- 物品够，提示红点，钻石或礼钻除外
        if self.tData.state == true then return false end
        local costId,costCnt = tItem.t,tItem.v
        local basicInfo = GDatatab_item["id_" .. costId]
        local curCnt = 0
        if basicInfo and basicInfo.main_type == 2 and basicInfo.sub_type == 11 then 
            curCnt = CacheCenter:getPlayerMountItemCountById(costId)
        else
            curCnt = CacheCenter:getPlayerItemCountById(costId)
        end
        WZLog("----------lock state3-----------",costId,costCnt,curCnt)
        if costId == 1 or costId == 70 then
            return false
        else
            if curCnt >= costCnt then return true end
            return false
        end
    end
    return false
end


-- 坐骑获取方式
function CellMounts1:_getWay()
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

function CellMounts1:_judgeLvGet(tItem,count)
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

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellMounts1:_adaptLanguage_vn()
    local txtName = GetElement(self.m_root,"txtName_CellMounts1",WZUILabelTTF)
    txtName:setScale(0.5)
    txtName:setDimensions(GlobalMethod:CCSize(220,0))
    txtName:setRelativePosition(GlobalMethod:ccp(0.5,0.08))
end
-------------------------------------语言适配End----------------------------------------
