--WndBravingTowerData.lua
--@brief    WndBravingTower的数据模块
--@date     2025/12/04
--@author   yrd
--@note     勇闯高塔

WndBravingTower = {
    --请不要在这里定义变量
}

--@brief    定义并初始化表的成员变量
--@note     变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBravingTower:_init()
    self.m_root = nil                           --场景根节点
    self.m_tContent = nil
    self.m_nStartTime = nil
    self.m_nEndTime = nil
    self.m_nActivityId = nil
    self.m_nCount = nil                         -- 163112
    self.m_nCoinId = nil
    self.m_nCoinNum = nil
    self.m_nLevelNum = nil                      -- 层数
    self.m_nRoundNum = nil                      -- 轮数
    self.m_tGiftIds = nil                       -- 各层数展示的奖励下标
    self.m_nOldLevelNum = nil                   -- self.m_nLevelNum 的旧数据
    self.m_nOldRoundNum = nil                   -- self.m_nRoundNum 的旧数据
    self.m_tOldGiftIds = nil                    -- self.m_tGiftIds 的旧数据
    self.m_tBigRewardList = {}                  -- self.m_tBigRewardList[i][j] i:0楼层奖池,1轮数奖池
    self.m_tOldBigRewardList = nil              -- self.m_tBigRewardList的旧数据
    self.m_tBigRewardObj = {}                   -- 存放楼层大奖对象
    self.m_tLevelOrdinaryPoolData = {}          -- 楼层普通奖池数据
    self.m_tLevelOrdinaryRewardObj = {}         -- 楼层普通奖励对象
    self.m_bOpenState = false                   -- 是否在抽奖中
    self.m_nDrawNumType = 1                     -- 抽奖数量类型 1,2
    self.m_tDrawNumList = {1,20}                -- 抽奖数量列表
    self.m_tOpenResult = nil                    -- 存放奖励
    self.m_nWinningIndex = nil                  -- 中奖下标
    self.m_tRollReward = nil                    -- 用来转轮的奖励
    self.m_nCheckIndex = 0                      -- 跳过动画索引
    self.m_bCopyRoll = false                    -- spineCopy是否开始动画
    self.m_tItemPosY = {0.184, 0.322, 0.45, 0.581, 0.711, 0.845}                     -- 每层高度
    self.m_tItemQuality = { 
        [0] = "ui/newActivity/common_icon_di_ycgt_bai.png",
        [1] = "ui/newActivity/common_icon_di_ycgt_lv.png",
        [2] = "ui/newActivity/common_icon_di_ycgt_lan.png",
        [3] = "ui/newActivity/common_icon_di_ycgt_zi.png",
        [4] = "ui/newActivity/common_icon_di_ycgt_huang.png",
        [5] = "ui/newActivity/common_icon_di_ycgt_hong.png",
    }
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndBravingTower:_unInit()
    self.m_root = nil                           --场景根节点
    self.m_tContent = nil
    self.m_nStartTime = nil
    self.m_nEndTime = nil
    self.m_nActivityId = nil
    self.m_nCount = nil
    self.m_nCoinId = nil
    self.m_nCoinNum = nil
    self.m_nLevelNum = nil
    self.m_nRoundNum = nil
    self.m_tGiftIds = nil
    self.m_nOldLevelNum = nil
    self.m_nOldRoundNum = nil
    self.m_tOldGiftIds = nil
    self.m_tBigRewardList = nil
    self.m_tOldBigRewardList = nil
    self.m_tBigRewardObj = nil
    self.m_tLevelOrdinaryPoolData = nil
    self.m_tLevelOrdinaryRewardObj = nil
    self.m_bOpenState = nil
    self.m_nDrawNumType = nil
    self.m_tDrawNumList = nil
    self.m_tOpenResult = nil
    self.m_nWinningIndex = nil
    self.m_tRollReward = nil
    self.m_nCheckIndex = nil
    self.m_bCopyRoll = nil
    self.m_tItemPosY = nil
    self.m_tItemQuality = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function WndBravingTower:createElement()
    if WndBravingTower.m_root ~= nil then
        WindowManager:removeWindow(WndBravingTower.m_root, WndBravingTower, true)
    end
    local element = WZUISystem:getInstance():createElement("WndBravingTower")
    assert(element, "WndBravingTower create element failed!")
    self:_init()
    return element
end

--@brief    获取活动详情成功
function WndBravingTower:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
    WZLog("WndBravingTower:GetActivityInfoOK", activityId)
    if g_cityExtenInfo.activity7185 == activityId then 
        self.m_tContent = json.decode(content)
        self.m_nStartTime = startTime 
        self.m_nEndTime = endTime 
        self.m_nActivityId = activityId
        self.m_nCount = count
        WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))

        self.m_tLevelOrdinaryPoolData = {}
        local nSex = CacheCenter:getPlayerInfo().sex
        for i=1, #self.m_tContent.giftRewardStr do
            self.m_tLevelOrdinaryPoolData[i] = {}
            local array = SplitStringWithSeparator(self.m_tContent.giftRewardStr[i], "&")
            for j=1, #array do
                local string = string.sub(array[j], 2, -2) 
                local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
                local num = tonumber(SplitStringWithSeparator(string,",")[3])

                table.insert(self.m_tLevelOrdinaryPoolData[i], {id,num})
            end 
        end

        self.m_nCoinId = self.m_tContent.costConfig[1]
        self.m_nCoinNum = self.m_tContent.costConfig[2]

        self:_initActivityTime()
        self:_updateCoinNum()
        self:_updateDrawBtn()
        self:_showReplaceBtns()
        self:_showRoundText()

    end
end

--@brief    获取其他活动数据
function WndBravingTower:_onGetOtherData(activityId, doType, result, jsonData)
    if self.m_root == nil then return end 

    if doType == 1 then 
        local tResult = json.decode(jsonData)
        WZLog("WndBravingTower:_onGetOtherData", doType, Serialize(tResult))
        self.m_tScoreRewardStatus = tResult.scoreRewardStatus
        self:_updateRoundStatus()

        if self.m_bOpenState == true then
            self.m_nOldLevelNum = tResult.giftTimes
            self.m_nOldRoundNum = tResult.score
            self.m_tOldGiftIds = tResult.giftIds
        else
            self.m_nLevelNum = tResult.giftTimes
            self:_showLevelNum()
            self.m_nRoundNum = tResult.score
            self:_showRoundNum()
            self.m_tGiftIds = tResult.giftIds
            self:_showLevelOrdinaryReward()
        end
    elseif doType == 2 then --获取达人奖、大奖限量数据
        local tResult = json.decode(jsonData)
        WZLog("WndBravingTower:_onGetOtherData", doType, Serialize(tResult))


        local nSex = CacheCenter:getPlayerInfo().sex
        if self.m_bOpenState == true then
            self.m_tOldBigRewardList = CopyTable(self.m_tBigRewardList)

            self.m_tOldBigRewardList[tResult.pool] = self.m_tOldBigRewardList[tResult.pool] or {}
            for k=1,#tResult.optionalList do
                self.m_tOldBigRewardList[tResult.pool][k] = {}

                local strName = ""
                if tResult.pool == 0 then
                    strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[7], k)
                elseif tResult.pool == 1 then
                    strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[6], self.m_tContent.scoreConfig[k])
                end
                -- local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = strName, strAtt = LocalStrings.FLYINGCAR_TEXT1[16], listBgSize = {476,206}, listSize = {460,186}, listPos = {0.5,0.616}, listBgPos = {0.5,0.616}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
                local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = strName, strAtt = LocalStrings.FLYINGCAR_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
                for i = 1, #tResult.globalLimit[k] do
                    local tab = {}
                    tab.id = i - 1
                    tab.limitNum = tResult.playerLimitConfig[k][i]
                    tab.dailyLimit = tResult.globalLimitConfig[k][i]
                    tab.dailyBuyNum = tResult.globalLimit[k][i]
                    tab.soldNum = tResult.playerLimit[k][i]
                    if utilsValueInTable(i - 1, tResult.optionalList[k]) then 
                        tItem.chooseState[i] = 1
                    else
                        tItem.chooseState[i] = 0
                    end
                    
                    tItem.leftConfig[i] = tab
                end

                local array = SplitStringWithSeparator(tResult.rewards[k], "&")
                for i = 1, #array do
                    local string = string.sub(array[i], 2, -2) 
                    local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
                    local num = tonumber(SplitStringWithSeparator(string,",")[3])

                    table.insert(tItem.reward_ids1, id)
                    table.insert(tItem.reward_nums1, num)
                end

                self.m_tOldBigRewardList[tResult.pool][k] = tItem
            end
        else
            self.m_tBigRewardList[tResult.pool] = self.m_tBigRewardList[tResult.pool] or {}
            for k=1,#tResult.optionalList do
                self.m_tBigRewardList[tResult.pool][k] = {}

                local strName = ""
                if tResult.pool == 0 then
                    strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[7], k)
                elseif tResult.pool == 1 then
                    strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[6], self.m_tContent.scoreConfig[k])
                end
                -- local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = strName, strAtt = LocalStrings.FLYINGCAR_TEXT1[16], listBgSize = {476,206}, listSize = {460,186}, listPos = {0.5,0.616}, listBgPos = {0.5,0.616}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
                local tItem = {reward_ids1 = {}, reward_nums1 = {}, name = strName, strAtt = LocalStrings.FLYINGCAR_TEXT1[16], listBgSize = {474,208}, listSize = {474,190}, listPos = {0.5,0.46}, listBgPos = {0.5,0.461}, cellElementHeight = 0.5, chooseState = {}, leftConfig = {}, type = 31, pool = tResult.pool}
                for i = 1, #tResult.globalLimit[k] do
                    local tab = {}
                    tab.id = i - 1
                    tab.limitNum = tResult.playerLimitConfig[k][i]
                    tab.dailyLimit = tResult.globalLimitConfig[k][i]
                    tab.dailyBuyNum = tResult.globalLimit[k][i]
                    tab.soldNum = tResult.playerLimit[k][i]
                    if utilsValueInTable(i - 1, tResult.optionalList[k]) then 
                        tItem.chooseState[i] = 1
                    else
                        tItem.chooseState[i] = 0
                    end
                    
                    tItem.leftConfig[i] = tab
                end

                local array = SplitStringWithSeparator(tResult.rewards[k], "&")
                for i = 1, #array do
                    local string = string.sub(array[i], 2, -2) 
                    local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
                    local num = tonumber(SplitStringWithSeparator(string,",")[3])

                    table.insert(tItem.reward_ids1, id)
                    table.insert(tItem.reward_nums1, num)
                end

                self.m_tBigRewardList[tResult.pool][k] = tItem
            end

            if tResult.pool == 0 then
                self:_showLevelBigReward()
            elseif tResult.pool == 1 then
                self:_showRoundBigReward()
            end
        end
    elseif doType == 3 then --开启结果
        local tResult = json.decode(jsonData)
        WZLog("WndBravingTower:_onGetOtherData", doType, Serialize(tResult))
        self.m_tOpenResult = {}

        self.m_tOpenResult.normalRewards = {} --常规奖
        self.m_tOpenResult.firstRewards = {} --小礼奖
        self.m_tOpenResult.bigRewards = {} --大礼奖
        self.m_tOpenResult.doyensRewards = {} --达人奖

        local rewardType = 8 
        local itemIdIndex = 1
        if tResult.itemIds then 
            for i = 1, #tResult.itemIds do
                local tItem = {}
                tItem.itemId = tResult.itemIds[i]
                tItem.itemNum = tResult.itemNums[i]
                tItem.type = rewardType
                tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
                tItem.titlePt = GlobalMethod:ccp(0.51, 0.982)
                tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
                table.insert(self.m_tOpenResult.normalRewards, tItem)
                itemIdIndex = itemIdIndex + 1
            end
        end

        -- --大奖
        -- local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
        -- local bigRewardType = 26 
        -- if tResult.fItemIds then 
        --     for i = 1, #tResult.fItemIds do
        --         local tItem = {}

        --         tItem.itemId = tResult.fItemIds[i]
        --         tItem.itemNum = tResult.fItemNums[i]
        --         tItem.type = bigRewardType
        --         tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
        --         tItem.imgBK = "ui/specialBg/hd_pic_ty_xj.png"
        --         tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
        --         tItem.strTitle = string.format(strTitleFormat, LocalStrings.BRAVING_TOWER_TEXT1[10])
        --         tItem.txtTitlePt = {0.5,0.885}
        --         tItem.spineEffect = {path = "activity/ui_bengchuang_xj", _sIndex = "ui_bengchuang_xj", play = "wait1"}
        --         table.insert(self.m_tOpenResult.firstRewards, tItem)
        --         itemIdIndex = itemIdIndex + 1
        --     end
        -- end

        --特奖 晋级奖
        local bigRewardType = 26
        local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
        if tResult.sItemIds then 
            for i = 1, #tResult.sItemIds do
                local tItem = {}
                tItem.itemId = tResult.sItemIds[i]
                tItem.itemNum = tResult.sItemNums[i]
                tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
                tItem.type = bigRewardType
                tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
                tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
                tItem.imgBKPt = {0.48,0.5}
                tItem.goodsconPt = {0.5,0.51}
                tItem.strTitle = string.format(strTitleFormat, LocalStrings.BRAVING_TOWER_TEXT1[10])
                tItem.txtTitlePt = {0.5,0.885}
                tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}
                table.insert(self.m_tOpenResult.bigRewards, tItem)
                itemIdIndex = itemIdIndex + 1
            end
        end

        --特奖 顶层奖
        local bigRewardType = 26
        local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
        if tResult.gItemIds then 
            for i = 1, #tResult.gItemIds do
                local tItem = {}
                tItem.itemId = tResult.gItemIds[i]
                tItem.itemNum = tResult.gItemNums[i]
                tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
                tItem.type = bigRewardType
                tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_dxj.png"
                tItem.imgBK = "ui/specialBg/hd_pic_ty_dj.png"
                tItem.imgBKPt = {0.48,0.5}
                tItem.goodsconPt = {0.5,0.51}
                tItem.strTitle = string.format(strTitleFormat, LocalStrings.BRAVING_TOWER_TEXT1[12])
                tItem.txtTitlePt = {0.5,0.885}
                tItem.spineEffect = {path = "activity/ui_bengchuang_drj", _sIndex = "ui_bengchuang_drj", play = "wait1"}
                table.insert(self.m_tOpenResult.bigRewards, tItem)
                itemIdIndex = itemIdIndex + 1
            end
        end

        -- --达人奖
        -- local strTitleFormat = [[<T C="255,255,255" S="46" P="1" SC="222,78,0" SS="4" SE="1">%s</T>]]
        -- if tResult.nItemIds then 
        --     for i = 1, #tResult.nItemIds do
        --         local tItem = {}

        --         tItem.itemId = tResult.nItemIds[i]
        --         tItem.itemNum = tResult.nItemNums[i]
        --         tItem.playerItemId = tResult.playerItemIds[itemIdIndex]
        --         tItem.type = bigRewardType
        --         tItem.imgRewardTitle = "ui/newActivity/bt_text_ty_tj.png"
        --         tItem.imgBK = "ui/specialBg/hd_pic_ty_tj.png"
        --         tItem.titlePt = {0.5,0.97}
        --         tItem.imgBKPt = {0.491,0.499}
        --         tItem.strTitle = string.format(strTitleFormat, LocalStrings.BRAVING_TOWER_TEXT1[10])
        --         tItem.txtTitlePt = {0.5,0.95}
        --         tItem.spineEffect = {path = "activity/ui_bengchuang_mxj", _sIndex = "ui_bengchuang_mxj", play = "wait1"}
        --         table.insert(self.m_tOpenResult.bigRewards, tItem)
        --         itemIdIndex = itemIdIndex + 1
        --     end
        -- end

        if result == 1 then 
            self.m_nCount = tResult.count

            local tReward = {}
            local tItem = {}
            for i=1,#self.m_tBigRewardList[0][self.m_nLevelNum + 1].chooseState do
                if self.m_tBigRewardList[0][self.m_nLevelNum + 1].chooseState[i] == 1 then
                    tItem[1] = self.m_tBigRewardList[0][self.m_nLevelNum + 1].reward_ids1[i]
                    tItem[2] = self.m_tBigRewardList[0][self.m_nLevelNum + 1].reward_nums1[i]
                    break
                end
            end
            table.insert(tReward, tItem)
            if self.m_tGiftIds[self.m_nLevelNum + 1] then
                for i=1,#self.m_tGiftIds[self.m_nLevelNum + 1] do
                    local index = self.m_tGiftIds[self.m_nLevelNum + 1][i] + 1
                    local tItem = self.m_tLevelOrdinaryPoolData[self.m_nLevelNum + 1][index]
                    table.insert(tReward, tItem)
                end
            end

            self.m_nWinningIndex = nil
            for i=1,#tReward do
                for j=1,#tResult.sItemIds do
                    if tReward[i][1] == tResult.sItemIds[j] and tReward[i][2] == tResult.sItemNums[j] then
                        self.m_nWinningIndex = i
                        break
                    end
                end
                if self.m_nWinningIndex then
                    break
                end
            end
            if self.m_nWinningIndex == nil then
                for i=1,#tReward do
                    for j=1,#tResult.itemIds do
                        if tReward[i][1] == tResult.itemIds[j] and tReward[i][2] == tResult.itemNums[j] then
                            self.m_nWinningIndex = i
                            break
                        end
                    end
                    if self.m_nWinningIndex then
                        break
                    end
                end
            end
            self.m_tRollReward = tReward

            self:_startRoll()
            self:_updateDrawBtn()
        else
            self.m_bOpenState = false
        end
    elseif doType == 4 then --选择奖励
        local tResult = json.decode(jsonData)
        WZLog("WndBravingTower:_onGetOtherData", doType, Serialize(tResult))
        if result == 0 then
            local tTempList = self.m_tBigRewardList[tResult.pool][tResult.index+1] 
            local nTag = 3
            for i=1, #tTempList.chooseState do
                if tTempList.chooseState[i] == 1 then
                    tTempList.chooseState[i] = 0
                    WndJoinReward:chooseReturn(nTag, i, 0)
                end
            end
            tTempList.chooseState[tResult.id + 1] = tResult.status
            
            WndJoinReward:chooseReturn(nTag, tResult.id + 1, tResult.status)

            if tResult.pool == 0 then
                self:_showLevelBigReward()
            elseif tResult.pool == 1 then
                self:_showRoundBigReward()
            end
        elseif result == 1 then
            MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
        end
    elseif doType == 5 then --领取奖励
        local tResult = json.decode(jsonData)
        WZLog("WndBravingTower:_onGetOtherData", doType, Serialize(tResult))
        if result == 0 then
            WndRewardShow:showById(tResult.itemIds, tResult.itemNums)
        end
    end
end

--@brief    缓存推送更新物品时调用的函数
function WndBravingTower:updatePlayerItemData()
    WZLog("WndBravingTower:updatePlayerItemData")
    if self.m_root ~= nil then
        self:_updateCoinNum()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
