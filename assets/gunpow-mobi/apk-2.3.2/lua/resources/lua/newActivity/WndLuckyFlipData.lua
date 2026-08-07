--WndLuckyFlipData.lua
--@brief    WndLuckyFlip的数据模块
--@date     2025/11/26
--@author   yrd
--@note     幸运翻牌

WndLuckyFlip = {
    --请不要在这里定义变量
}

--@brief    定义并初始化表的成员变量
--@note     变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLuckyFlip:_init()
    self.m_root = nil                   --场景根节点
    self.m_nCoinId = 163105             --货币
    self.m_nDrawToolType = 0            --抽奖工具类型 0,1
    self.m_tDrawNumList = {1,20}        --抽奖数量列表
    self.m_nDrawNumType = 1             --抽奖数量类型 1,2
    self.m_nCount = 0                   --免费次数
    self.m_tShowPoolStr = nil
    self.m_nGiftReward = nil
    self.m_bOpenState = nil             --抽奖按钮开放状态
    self.m_tBigRewardList = nil         --收集奖
    self.m_tFiveKeyReward = nil         --豪华大奖
    self.m_tCellCircleRewards = nil     --跑圈奖励cell
    self.m_nCheckIndex = 0
    self.m_tItemObjs = {}               --存放物品对象
    self.m_tSpine2List = {}             --特效2列表
    self.m_tSpine3List = {}             --特效3列表
    self.m_tSpine4 = nil                --特效4
    self.m_tSpine5 = nil                --特效5列表
    self.m_tSpine6List = {}             --特效6列表
    self.m_strSpinePath = "activity/hd_pic_xyfp"
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndLuckyFlip:_unInit()
    self.m_root = nil
    self.m_nCoinId = nil
    self.m_nDrawToolType = nil
    self.m_tDrawNumList = nil
    self.m_nDrawNumType = nil
    self.m_nCount = nil
    self.m_tShowPoolStr = nil
    self.m_nGiftReward = nil
    self.m_bOpenState = nil
    self.m_tBigRewardList = nil
    self.m_tFiveKeyReward = nil
    self.m_tCellCircleRewards = nil
    self.m_nCheckIndex = nil
    self.m_tItemObjs = nil
    self.m_tSpine2List = nil
    self.m_tSpine3List = nil
    self.m_tSpine4 = nil
    self.m_tSpine5 = nil
    self.m_tSpine6List = nil
    self.m_strSpinePath = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function WndLuckyFlip:createElement()
    if WndLuckyFlip.m_root ~= nil then
        WindowManager:removeWindow(WndLuckyFlip.m_root, WndLuckyFlip, true)
    end
    local element = WZUISystem:getInstance():createElement("WndLuckyFlip")
    assert(element, "WndLuckyFlip create element failed!")
    self:_init()
    return element
end

--@brief    缓存推送更新物品时调用的函数
function WndLuckyFlip:updatePlayerItemData()
    WZLog("WndLuckyFlip:updatePlayerItemData")
    if self.m_root ~= nil then
        self:_updateCoinNum()
    end
end

--@brief    获取活动详情成功
function WndLuckyFlip:GetActivityInfoOK(activityId, maxCount, count, status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
    if g_cityExtenInfo.activity7183 == activityId then
        self.m_nActivityId = activityId
        -- self.m_nMaxCount = maxCount
        self.m_nCount = count
        -- self.m_nStatus = status
        -- self.m_nRewardCounts = rewardCounts
        -- self.m_nRewardItems = rewardItems
        -- self.m_nRewardItemsParamCount = rewardItemsParamCount
        self.m_nStartTime = startTime
        self.m_nEndTime = endTime
        self.m_tContent = json.decode(content)
        -- self.m_nRewardId = rewardId
        -- self.m_nFinishCondition = finishCondition
        -- self.m_nTips = tips

        self.m_tCostByType = {finishCondition[1]}

        self.m_tShowPoolStr = {}
        local array = SplitStringWithSeparator(self.m_tContent.showPoolStr, "&")
        for i=1,#array do
            local str1 = string.sub(array[i],2,-2)
            local arr1 = SplitStringWithSeparator(str1, ",", nil, true)
            table.insert(self.m_tShowPoolStr,arr1)
        end

        self:_initActivityTime()

        self:_showWheelItems()
    end
end

--@brief    获取其他活动数据
function WndLuckyFlip:_onGetOtherData(activityId, doType, result, jsonData)
    if self.m_root == nil then return end 

    if doType == 1 then --获取达人奖、大奖限量数据
        local tResult = json.decode(jsonData)
        WZLog("WndLuckyFlip:_onGetOtherData", doType, Serialize(tResult))
        self.m_nGiftReward = tResult.giftReward
        self:updateBigRewardCount()

        self.m_nRefreshTimes = tResult.refreshTimes
        self.m_nCollectIds = tResult.collectIds
        self.m_nCollectRewardStatus = tResult.collectRewardStatus
        self.m_nShowIds = tResult.showIds
        self.m_nShowRewardIds = tResult.showRewardIds
        if self.m_bOpenState ~= true then
            self:updateLeftUI()
            self:updateRefreshBtn()
        end
        
        self:updateWishingBtn()
    elseif doType == 2 then --获取达人奖、大奖限量数据
        local tResult = json.decode(jsonData)
        WZLog("WndLuckyFlip:_onGetOtherData", doType, Serialize(tResult))
        local nSex = CacheCenter:getPlayerInfo().sex
        local sBigReward = tResult.rewards
        local array = SplitStringWithSeparator(sBigReward, "&")
        if tResult.pool == 0 then 
            local tItem = {reward_ids = {}, reward_nums = {}, name = LocalStrings.LUCKY_FLIP_TEXT1[5], listBgSize = {476,346}, listBgPos = {0.5,0.445}, listSize = {460,330}, listPos = {0.5,0.445}, cellElementHeight = 0.27}
            for i = 1, #array do
                local string = string.sub(array[i], 2, -2) 
                local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
                local num = tonumber(SplitStringWithSeparator(string,",")[3])

                table.insert(tItem.reward_ids, id)
                table.insert(tItem.reward_nums, num)
            end

            self.m_tBigRewardList = tItem
        elseif tResult.pool == 1 then 
            local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = LocalStrings.LUCKY_FLIP_TEXT1[6], strAtt = LocalStrings.PLANETSEARCH_TEXT1[4], listBgSize = {476,206}, listSize = {460,186}, listPos = {0.5,0.616}, listBgPos = {0.5,0.616}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
            for i = 1, #array do
                local string = string.sub(array[i], 2, -2) 
                local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
                local num = tonumber(SplitStringWithSeparator(string,",")[3])

                table.insert(tItem.reward_ids1, id)
                table.insert(tItem.reward_nums1, num)
            end

            for i = 1, #tResult.globalLimit do
                local tab = {}
                tab.id = i - 1
                tab.limitNum = tResult.playerLimitConfig[i]
                tab.dailyLimit = tResult.globalLimitConfig[i]
                tab.dailyBuyNum = tResult.globalLimit[i]
                tab.soldNum = tResult.playerLimit[i]
                if utilsValueInTable(i - 1, tResult.optionalList) then 
                    tItem.chooseState[i] = 1
                else
                    tItem.chooseState[i] = 0
                end
                
                tItem.leftConfig[i] = tab
            end

            self.m_tFiveKeyReward = tItem
            self:_showFiveKeyReward()
        end
    elseif doType == 3 then --抽奖
        local tResult = json.decode(jsonData)
        WZLog("WndGuardCastle:_onGetOtherData", doType, Serialize(tResult))

        if result == 1 then
            self.m_nCount = tResult.count
            self.m_tBlessItemIds = tResult.itemIds
            self.m_tBlessItemNums = tResult.itemNums
            self.m_nShowId = tResult.showIds[#tResult.showIds]
            self:_startRoll()
        end
    elseif doType == 4 then --选择奖励
        local tResult = json.decode(jsonData)
        WZLog("WndLuckyFlip:_onGetOtherData", doType, Serialize(tResult))
        if result == 0 then 
            local tTempList = nil 
            local nTag = 0
            if tResult.pool == 1 then
                tTempList = self.m_tFiveKeyReward
            end
            tTempList.chooseState[tResult.id + 1] = tResult.status
            if tResult.pool == 1 then 
                self:chooseReturn(nTag, tResult.id + 1, tResult.status)
                if tResult.status == 1 then 
                    WndAthShop:chooseReturn(nTag, tResult.id + 1, tResult.status)
                end
            end
        elseif result == 1 then
            MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
        end
    elseif doType == 5 then
        if result == 2 then
            MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
        elseif result == 3 then
            MsgBoxManager:showTipBox(LocalStrings.NETWORK_BUSY)
        elseif result == 4 then
            MsgBoxManager:showTipBox(LocalStrings.HEROTOWER_TEXT16)
        elseif result == 5 then
            MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[10])
        end
    elseif doType == 6 then
        local tResult = json.decode(jsonData)
        WZLog("WndLuckyFlip:_onGetOtherData", doType, Serialize(tResult))

        if result == 1 then
            local tReward = {}
            local itemIdIndex = 1
            for i = 1, #tResult.itemIds do
                local tItem = {}
                tItem.itemId = tResult.itemIds[i]
                tItem.itemNum = tResult.itemNums[i]
                tItem.type = 8
                tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
                tItem.titlePt = GlobalMethod:ccp(0.51, 0.982)
                tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
                table.insert(tReward, tItem)
                itemIdIndex = itemIdIndex + 1
            end
            WndHoraryBigReward:showInterface(8, tReward)

            self.m_nCollectRewardStatus[tResult.id+1] = 1
            self:updateLeftUI()
        end
    elseif doType == 7 then
        local tResult = json.decode(jsonData)
        WZLog("WndLuckyFlip:_onGetOtherData", doType, Serialize(tResult))

        if result == 1 then
            self.m_nGiftReward = math.max(0, self.m_nGiftReward - 1)
            self:updateBigRewardCount()

            local tReward = {}
            local itemIdIndex = 1
            local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
            for i = 1, #tResult.itemIds do
                local tItem = {}
                tItem.itemId = tResult.itemIds[i]
                tItem.itemNum = tResult.itemNums[i]
                tItem.playerItemId = tResult.playerItemId[itemIdIndex]
                tItem.type = 8
                tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
                tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
                tItem.titlePt = {0.5,0.97}
                tItem.imgBKPt = {0.5,0.5}
                tItem.strTitle = string.format(strTitleFormat, LocalStrings.LUCKY_FLIP_TEXT1[6])
                tItem.txtTitlePt = {0.5,0.95}
                tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}
                table.insert(tReward, tItem)
                itemIdIndex = itemIdIndex + 1
            end
            WndHoraryBigReward:showInterface(8, tReward)

            local tData2 = {pool = 1}
            local strJson2 = json.encode(tData2)
            ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7183, 2, strJson2)
        end
    end
end

--@brief    设置射箭的状态
function WndLuckyFlip:setOpenState(state)
    if self.m_root == nil then return end 
    self.m_bOpenState = state
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
