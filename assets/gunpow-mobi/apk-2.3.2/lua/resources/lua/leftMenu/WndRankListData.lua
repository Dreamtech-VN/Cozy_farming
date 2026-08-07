--WndRankListData.lua
--@brief	WndRankList的数据模块
--@date		2015/04/22
--@author	hyq
--@note		排行榜

WndRankList = {
	--请不要在这里定义变量
}

FIRAST_LOAD_NUM = 20

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRankList:_init()
	self.m_root = nil	 	  			--1场景根节点
    self.m_nLoadingId = nil             --2加载框ID
    self.m_tRankListInfo = nil          --3排行榜数据
    self.m_nSendRankType = 1            --4发送请求的类型,默认为战力榜
    self.m_bCreateEnabled = true        --5收到数据时是否创建
    self.m_tSendTag = {}                --6已发送请求标志
    self.m_tTempItemTag = {1,56,2,3,12,13}
    self.m_tRankListItemTag = {1,56,2,3,12,13} --8一级标签标志及个数
    self.m_tRankType = {1,56,2,3,12,13} --9排行榜类型
    self.m_tWorshipLogList = nil        --膜拜日志列表

    self.m_tFamousList = nil            --保存前三数据
    self.m_tRoleAniList = nil           --标记选中的名人
    self.m_tWifeAniList    = nil        --名人堂中的妻子
    self.m_nCheckBoxIndex = 1         --标记选中的是1：名人堂，2：排行榜单
    self.m_tLeftList = nil              --用于保存左边列表的表对象
    self.m_tFamousPlayerId = nil        --用于存放名人堂要展示的用户ID
    self.m_tMyRankListInfo = nil        --我自己的排行榜数据
    self.m_nCurRankType = 1           --当前选中的标签
    self.m_nLastTime = nil               --上次获取的时间
    self.m_nCurTime  = nil               --当前系统时间
    self.m_bIsCreate = true          --是否创建排行列表
    self.m_bIsDisplayFamous = false         --名人堂中的人物是否已经显示出来：true:已经画了；false:未画
    self.m_nCanWorship = nil        --用于标记是否可以膜拜
    --动态加载所需变量
    self.m_nFirstLoadNum = FIRAST_LOAD_NUM  --首次加载的数量
    self.m_nCurNeedLoadNum = nil            --当前需要加载的数量
    self.m_nCurLoadIndex = nil              --当前加载的数据下标
    self.m_nCurTag = nil                    --当前加载的Tag
    self.m_nCurPositionY = nil          --列表当前位置
    self.m_nFamousLoadIndex = nil       --名人堂动态加载索引
    self.m_tFamousLoadList = nil        --名人堂动态加载列表

    self.m_sTouchLeftTitle = nil
    --11每个排行榜对应的排行榜信息标签
    self.m_tRankTypeInfoName = {}
    self.m_tRankTypeInfoName[1]  = {1,23,3,4}
    self.m_tRankTypeInfoName[56] = {1,23,32,33}
    self.m_tRankTypeInfoName[2]  = {1,23,5,4}
    self.m_tRankTypeInfoName[3]  = {1,6,7,30}
    self.m_tRankTypeInfoName[12]  = {1,23,24,25}
    self.m_tRankTypeInfoName[13] = {1,23,26,15}
    self.m_tRankTypeInfoName[22] = {1,23,31,28}
    self.m_tRankTypeInfoName[23] = {1,20,21,22}
    self.m_tRankTypeInfoName[8] = {1,23,5,16,17}
    self.m_tRankTypeInfoName[9] = {1,23,18,4}
    self.m_tRankTypeInfoName[10] = {1,23,19,4}
    self.m_tRankTypeInfoName[11] = {1,20,21,22}
    --12排行榜信息标签
    self.m_tInfoItemName = {}
    self.m_tInfoItemName[1]  = LocalStrings.RANK                --排名
    self.m_tInfoItemName[2]  = LocalStrings.QUALIFYING_NAME     --名称
    self.m_tInfoItemName[3]  = LocalStrings.BATTLE              --战力
    self.m_tInfoItemName[4]  = LocalStrings.BELONG_TO_COMMUNITY --所属公会
    self.m_tInfoItemName[5]  = LocalStrings.LEVEL               --等级
    self.m_tInfoItemName[6]  = LocalStrings.CURRENT_PET         --当前宠物
    self.m_tInfoItemName[7]  = LocalStrings.PET_COMBAT          --宠物战力
    self.m_tInfoItemName[8]  = LocalStrings.MOUNT_LEVEL         --坐骑等级
    self.m_tInfoItemName[9]  = LocalStrings.MOUNT_GRADE         --坐骑评分
    self.m_tInfoItemName[10] = LocalStrings.BATTLE_MODEL_RANK   --排位赛
    self.m_tInfoItemName[11] = LocalStrings.KING_COMPETITION    --弹王赛
    self.m_tInfoItemName[12] = LocalStrings.COMPETITION_TIMES   --竞技场次
    self.m_tInfoItemName[13] = LocalStrings.WIN_RATE            --胜率
    self.m_tInfoItemName[14] = LocalStrings.REACH_ACHIEVEMENT   --成就达成
    self.m_tInfoItemName[15] = LocalStrings.DESIGNATION_SHOW    --当前称号
    self.m_tInfoItemName[16] = LocalStrings.COMBAT_IN_ALL       --总战力
    self.m_tInfoItemName[17] = LocalStrings.PRESIDENT           --会长
    self.m_tInfoItemName[18] = LocalStrings.USERRCP             --魅力值
    self.m_tInfoItemName[19] = LocalStrings.DISCIPLE            --出师弟子
    self.m_tInfoItemName[20] = LocalStrings.RANKLIST_LAOGONG    --丈夫
    self.m_tInfoItemName[21] = LocalStrings.RANKLIST_LAOPO      --妻子
    self.m_tInfoItemName[22] = LocalStrings.COUPLE_LOVE         --恩爱值
    self.m_tInfoItemName[23] = LocalStrings.PLAYER              --玩家
    self.m_tInfoItemName[24] = LocalStrings.INTEGRATION        --积分
    self.m_tInfoItemName[25] = LocalStrings.COMPETIVITY_DATA    --竞技数据
    self.m_tInfoItemName[26] = LocalStrings.ACHIE_NUMBER        --成就数量
    self.m_tInfoItemName[27] = LocalStrings.TEACHER_LEVEL       --师德等级
    self.m_tInfoItemName[28] = LocalStrings.TEACHER_PUPIL_NUMBER --出徒数量
    self.m_tInfoItemName[29] = LocalStrings.LOVING_LEVEL     --恩爱等级
    self.m_tInfoItemName[30] = LocalStrings.BELONG_PLAYER       --所属玩家
    self.m_tInfoItemName[31] = LocalStrings.TEACHER_VALUE       --师德值
    self.m_tInfoItemName[32] = LocalStrings.NEWVIP_TEXT16       --勋章等级
    self.m_tInfoItemName[33] = LocalStrings.SCORE_MEDAL       --勋章积分

    self.m_nIsTeach = false     --是否在新手引导中
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRankList:_unInit()
	self.m_root = nil               --1
    self.m_nLoadingId = nil         --2
    self.m_tRankListInfo = nil      --3
    self.m_nSendRankType = nil      --4
    self.m_tSendTag = nil           --5
    self.m_tRankType = nil          --6
    self.m_tWorshipLogList = nil        --膜拜日志列表
    self.m_nCanWorship = nil        --用于标记是否可以膜拜

    self.m_tTempItemTag = nil 
    self.m_tRankListItemTag = nil   --7
    self.m_bCreateEnabled = nil     --8
    self.m_tIsFirstItemOpen = nil   --10
    self.m_tInfoItemName = nil      --12
    self.m_tFamousList = nil 
    self.m_tRoleAniList = nil           --标记选中的名人
    self.m_tWifeAniList    = nil        --名人堂中的妻子
    self.m_nCheckBoxIndex = nil         --标记选中的是名人堂还是排行榜单
    self.m_tLeftList = nil              --用于保存左边列表的表对象
    self.m_tFamousPlayerId = nil        --用于存放名人堂要展示的用户ID
    self.m_tMyRankListInfo = nil        --我自己的排行榜数据
    self.m_nCurRankType = nil           --当前选中的标签

    self.m_nLastTime = nil               --上次获取的时间
    self.m_nCurTime  = nil               --当前系统时间
    self.m_bIsCreate = true          --是否创建排行列表
    self.m_bIsDisplayFamous = 0         --名人堂中的人物是否已经显示出来：true:已经画了；false:未画
    self.m_nFirstLoadNum = nil  --首次加载的数量
    self.m_nCurNeedLoadNum = nil            --当前需要加载的数量
    self.m_nCurLoadIndex = nil              --当前加载的数据下标
    self.m_nCurIndex = nil                    --当前加载的索引
    self.m_nCurPositionY = nil          --列表当前位置
    self.m_nFamousLoadIndex = nil       --名人堂动态加载索引
    self.m_tFamousLoadList = nil        --名人堂动态加载列表

    self.m_sTouchLeftTitle = nil

    -- self.m_nIsTeach = nil     --是否在新手引导中
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRankList:createElement()
	local element = WZUISystem:getInstance():createElement("WndRankList")
	assert(element, "WndRankList create element failed!")
	self:_init()
	return element
end

--@brief    获得名人堂数据
function WndRankList:setFamousListData(playerId, name, level, title, fighting, weaponId, headId, faceId, bodyId, wingId, petMessage, sex, guildName, wrshipNum, headColor, bodyColor)
    self.m_tFamousList = {}
    for i=1,#playerId do
        local tempTable = {}
        tempTable.id = playerId[i]
        tempTable.title = title[i]
        tempTable.level = level[i]
        tempTable.name = name[i]
        tempTable.fighting = fighting[i]
        tempTable.weaponId = weaponId[i]
        tempTable.headId = headId[i]
        tempTable.faceId = faceId[i]
        tempTable.bodyId = bodyId[i]
        tempTable.wingId = wingId[i]
        tempTable.petMessage = petMessage[i]
        tempTable.sex = sex[i]
        tempTable.worshipNum = wrshipNum[i]
        tempTable.headColor = headColor[i]
        tempTable.bodyColor = bodyColor[i]
        table.insert(self.m_tFamousList,tempTable)
        WZLog("WndRankList:setFamousListData::::",playerId[i], name[i], level[i], title[i], fighting[i], weaponId[i], headId[i], faceId[i], bodyId[i], wingId[i], sex[i])
    end
    WZLog("WndRankList:setFamousListData",Serialize(self.m_tFamousList))

    self:_closeLoading()
    --设置名人堂显示的值
    self:_setFamousDisplayValue(self.m_nCurRankType)

    self.m_bIsCreate = true
    self:_createRankInfoCell(self.m_nCurRankType)
end

--@brief    设置膜拜日志数据信息
function WndRankList:getWorshipLogOK(playerName, worshipDate, worshipName)
    -- body
    --关闭加载框
    WZLog("********* WndRankList:getWorshipLogOK *******", #playerName)
    self:_closeLoading()
    self.m_tWorshipLogList = {}

    for i = 1, #playerName do
        local tTempLog = {}
        tTempLog.playerName = playerName[i]
        tTempLog.worshipDate = worshipDate[i]
        tTempLog.worshipName = worshipName[i]

        table.insert(self.m_tWorshipLogList, tTempLog)
    end

    self:_updateWorshipLog()
end

--@brief    用于设置用于名人堂展示的玩家的ID
--@param    tRankList 榜单
function WndRankList:setFamousPlayerId(tRankList, nType)
    -- body
    local tTempTable = tRankList[nType]
    if tTempTable == nil then 
        self.m_bCreateEnabled = true
        ProtocolProcessorWndRankList:send_RANK_GetRankRecord(nType)
        return nil 
    end 

    self.m_tFamousPlayerId = {}

    local num = 0
    for i = 1, #tTempTable do
        if tTempTable[i].ranking <= 3 then
            if nType == 23 then
                table.insert(self.m_tFamousPlayerId, tTempTable[i].playerId)
                table.insert(self.m_tFamousPlayerId, tonumber(tTempTable[i].param1))
                num = num + 1
                if num == 3 then break end
            else
                table.insert(self.m_tFamousPlayerId, tTempTable[i].playerId)
                num = num + 1
                if num == 3 then break end
            end
        end
    end

    local VansPlayerID = WZLuaVector_int_:create()
    for i = 1,#self.m_tFamousPlayerId do
        VansPlayerID:push(self.m_tFamousPlayerId[i])
    end

    return VansPlayerID
end

function WndRankList:_setFamousDisplayValue(_rankType)
    -- body
    if self.m_tFamousList == nil then return end

    if _rankType == 1 or _rankType == 59 or _rankType == 2 or _rankType == 61 then return end

    local tTempList = self.m_tRankListInfo[_rankType]
    local tTempFamousList = self.m_tFamousList
    for i = 1, #self.m_tFamousList do
        for j = 1, #tTempList do
            if self.m_tFamousList[i].id == tTempList[j].playerId then
                if _rankType == 1 or _rankType == 59 then 
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param1)  --战力
                elseif _rankType == 2 or _rankType == 61 then
                    self.m_tFamousList[i].fighting = tTempList[j].level             --人物等级
                elseif _rankType == 3 or _rankType == 60 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param4)  --宠物战力
                elseif _rankType == 12 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param2)  --竞技积分
                    self.m_tFamousList[i].valueLv = tonumber(tTempList[j].param1)   --竞技等级
                elseif _rankType == 13 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param1)  --成就数量
                elseif _rankType == 22 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param2) --师德经验
                    self.m_tFamousList[i].valueLv = tonumber(tTempList[j].param1)  --师德等级
                elseif _rankType == 23 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param7) --恩爱经验
                    self.m_tFamousList[i].wifeId   = tonumber(tTempList[j].param1) --妻子ID
                    self.m_tFamousList[i].valueLv = tonumber(tTempList[j].param6)  --恩爱等级
                elseif _rankType == 56 then
                    self.m_tFamousList[i].fighting = tonumber(tTempList[j].param1) --勋章积分
                end
                break
            end
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    处理是否重新获取各个排行榜单（15分钟重新获取一次）
function WndRankList:_retgetRankList()
    -- body
    self.m_nLastTime = g_nLastGetRankListTime
    self.m_nCurTime = os.time()

    if self.m_nLastTime == nil or self.m_nCurTime - self.m_nLastTime >= 0 * 60 then
        --获取时间
        g_nLastGetRankListTime = os.time()
        CacheCenter:resetRankListInfo()
    end 
end




-------------------------------------私有方法模块End----------------------------------------
