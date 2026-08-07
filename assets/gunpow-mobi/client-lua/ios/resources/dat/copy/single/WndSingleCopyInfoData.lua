--WndSingleCopyInfoData.lua
--@brief	WndSingleCopyInfo的数据模块
--@date		2015/04/10
--@author	xiaoyu_wu
--@note		单人副本关卡信息

WndSingleCopyInfo = {
	--请不要在这里定义变量
    NOTPASSED = -999
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopyInfo:_init()
	self.m_root = nil	 	  			--场景根节点
    self.singleCopyVipData = nil
    self.m_tLevelData = nil             --关卡数据表
    self.m_nChallengeCount = self.NOTPASSED       --已挑战次数，默认值为未通关
    self.m_nSweepCount = 0              --扫荡次数
    self.m_bSweepFinish = true           --记录是否已成功接收扫荡成功协议，防止多次点击扫荡按钮
    self.m_nSweepType = 1
    self.m_nLoadingTag = nil
    self.m_nCopyType = nil
    self.m_nCostCount = nil
    self.m_nCurLevelID = nil               --当前挑战的关卡
    self.m_tIslandHostData = nil            --岛主数据
    self.m_tNextHostList = nil            --候选列表
    self.m_tMyIslandId = nil               --我占领的岛Id
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopyInfo:_unInit()
    self.m_root = nil
    self.singleCopyVipData = nil
    self.m_tLevelData = nil
    self.m_nChallengeCount = nil
    self.m_nSweepCount = nil
    self.m_bSweepFinish = nil
    self.m_nSweepType = nil
    self.m_nLoadingTag = nil
    self.m_nCopyType = nil
    self.m_nCostCount = nil
    self.m_nCurLevelID = nil   
    self.m_tIslandHostData = nil            --岛主数据
    self.m_tNextHostList = nil            --候选列表
    self.m_tMyIslandId = nil               --我占领的岛Id
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopyInfo:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndSingleCopyInfo")
	assert(element, "WndSingleCopyInfo create element failed!")
	self:_init()
	return element
end

--@brief	显示窗口
--@note		调用此接口显示单人副本关卡信息窗口
function WndSingleCopyInfo:showWindow(tLevelData,copyType)
    local wndSingleCopyInfo = self:createElement()
    self.m_tLevelData = tLevelData
    self.m_nCopyType = copyType
    self:_getChallengeCount()
    WindowManager:addWindow(wndSingleCopyInfo, self,nil, true)
end

--@brief	获取关卡数据表
--@return   #1,数据表
function WndSingleCopyInfo:getLevelData()
    return self.m_tLevelData
end

--@brief	数据更新
function WndSingleCopyInfo:updateData()
    WZLog("WndSingleCopyInfo:updateData")
    if self:getLoadingTag()~=nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self:getLoadingTag())
    end
    self:_getChallengeCount()
    self:_updateSweepInfo()
    self:_initLevelInfo()
    self:resetLoadingTag()
end

--@brief 显示扫荡结果
function WndSingleCopyInfo:showSweepResult(pointId, rewardNum, rewardId, rewardCount)
    WZLog("WndSingleCopyInfo:showSweepResult")
    if self.m_root == nil then return end
    self.m_bSweepFinish = true
    WndSweepResult:showWindow({
        pointId = pointId,
        rewardNum = VectorToTable(rewardNum),
        rewardId = VectorToTable(rewardId),
        rewardCount = VectorToTable(rewardCount),
    },self.m_nSweepType)
    
end

--@brief  返回loadingTag
function WndSingleCopyInfo:getLoadingTag()
    return self.m_nLoadingTag
end

--@brief  返回loadingTag
function WndSingleCopyInfo:resetLoadingTag()
    if self.m_nLoadingTag then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
    end
    self.m_nLoadingTag = nil
end

--@brief 获取对应VIP的爬塔信息
function WndSingleCopyInfo:getVipSingleCopy()
    local playerInfo = CacheCenter:getPlayerInfo() or {}
    local vipLevel = playerInfo.vipLevel
    local vipData = nil
    local count = 0
    for k,v in pairs(self.singleCopyVipData) do
        if vipLevel >= v.vip_level  then
            if v.count > count then
                count = v.count
                vipData = v
            end
        end
    end
    return vipData
end

--@brief  获取当前VIP下一等级VIP的数据
function WndSingleCopyInfo:getNextVipData()
    WZLog("WndSingleCopyInfo:getNextVipData")
    local playerInfo = CacheCenter:getPlayerInfo()
    local vipLevel = playerInfo.vipLevel
    local curVipData = self:getVipSingleCopy()
    local nextCount = curVipData.count + 1
    for i,v in ipairs(self.singleCopyVipData) do
        if v.count == nextCount then
            return v
        end
    end
    return nil
end

--@brief  获取单人副本重置花费
--@param  resertCount : 重置次数
function WndSingleCopyInfo:getVipSingleCopyCost(resertCount)
    for k,v in pairs(self.singleCopyVipData) do
        if v.count  == resertCount then
            return v.cost[1][2]
        end
    end
end

--@brief  获取当前关卡重置次数
function WndSingleCopyInfo:getResertTime(mapId)
    local singleCopyInfo = CacheCenter:getSingleCopyData()
    for i,v in ipairs(singleCopyInfo) do
        if v.pointId == mapId then
            return v.restTimes
        end
    end
    return 0
end

--@brief  判断是否可以进行重置，可以则弹出相关提示
function WndSingleCopyInfo:canResert()
    local reserTimes = self:getResertTime(self.m_tLevelData.id)
    reserTimes = reserTimes + 1
    if self.m_nCopyType ~= 2 or self.m_nCopyType == 3 then
        return false ,reserTimes
    end
    local vipData = self:getVipSingleCopy()
    local totalCount = vipData.count
    if reserTimes > totalCount then
        return false ,reserTimes
    end
    return true ,reserTimes 
end


--单人副本关卡录像信息
function WndSingleCopyInfo:setVideoInfo(id,faceId,headId,name,level,playerId,sex,headColor)
    WZLog("WndSingleCopyInfo:setVideoInfo = ",#id)
    if id ~= nil and faceId ~= nil and headId ~= nil and name ~= nil and level ~= nil and self.m_root ~= nil then
        self.m_tVideoList = {id=id,faceId=faceId,headId=headId,name=name,level=level,playerId=playerId,sex=sex,headColor=headColor}
        if self.m_tVideoList ~= nil and (#self.m_tVideoList.id) > 0 then
            WZLog("WndSingleCopyInfo:enterSetVideoInfo....")
            local txtNullMsgTip = GetElement(self.m_root,"txtNullMsgTip_WndSingleCopyInfo",WZUILabelTTF)
            txtNullMsgTip:setVisible(false)
            self:showVideoList()
        end
    end
end

--显示录像列表信息
function WndSingleCopyInfo:showVideoList()
    WZLog("WndSingleCopyInfo:showVideoList")
    local tblVideoList = GetElement(self.m_root,"tblVideoList_WndSingCopyInfo",WZUITableContainer)
    tblVideoList:cleanTable()
    for i,v in ipairs(self.m_tVideoList.id) do
       
        local cellVideoInfo= CreateElement("CellVideoInfo_WndSingleCopyInfo")
        cellVideoInfo:setTag(i-1)
        cellVideoInfo:setVisible(true)

        local conPlayerHead = GetElement(cellVideoInfo,"conPlayerHead_CellVideoInfo",WZUIContainer)
        local cellHeadObject = CellHead:show(conPlayerHead,self.m_tVideoList.headId[i],self.m_tVideoList.faceId[i],self.m_tVideoList.sex[i],nil,nil,nil,self.m_tVideoList.headColor[i])
        cellHeadObject:setScale(0.9)
        conPlayerHead:setTag(self.m_tVideoList.playerId[i])

--        local btnHead = GetElement(cellVideoInfo,"btnHead_CellVideoInfo",WZUIButton)
--        btnHead:setTag(self.m_tVideoList.playerId[i])

        local txtPlayerLevel = GetElement(cellVideoInfo,"txtPlayerLevel_CellVideoInfo",WZUILabelTTF)
        txtPlayerLevel:setText( "Lv" ..self.m_tVideoList.level[i])

        local txtPlayerName = GetElement(cellVideoInfo,"txtPlayerName_CellVideoInfo",WZUILabelTTF)
        txtPlayerName:setText(self.m_tVideoList.name[i])
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
            txtPlayerName:setScale(0.8)
        end

        local btnPlayVideo = GetElement(cellVideoInfo,"btnPlayVideo_CellVideoInfo",WZUIButton)
        btnPlayVideo:setTag(v)
        tblVideoList:setCellElement(cellVideoInfo)
        if ProjConfig.LANGUAGE == "tr" then
            txtPlayerName:setScale(0.8)
        end
    end
end

--@brief    设置岛主信息数据
function WndSingleCopyInfo:setIslangHostInfo(landlordId, landlordName, landlordSex, landlordVipLevel, landlordHeadId, landlordHeadColor, landlordFaceId, landlordScore, playerId, playerName, vipLevel, sex, headId, headColor, faceId, score, seizeMapId)
    --body
    self.m_tMyIslandId = seizeMapId
    self.m_tIslandHostData = {id = landlordId, name = landlordName, sex = landlordSex, vipLevel = landlordVipLevel, headId = landlordHeadId, faceId = landlordFaceId, headColor = landlordHeadColor, score = landlordScore}            --岛主数据
    self.m_tNextHostList = {}            --候选列表
    for i = 1, #playerId do
        local tItem = {}
        tItem.id = playerId[i]
        tItem.name = playerName[i]
        tItem.vipLevel = vipLevel[i]
        tItem.sex = sex[i]
        tItem.headId = headId[i]
        tItem.headColor = headColor[i]
        tItem.faceId = faceId[i]
        tItem.score = score[i]

        table.insert(self.m_tNextHostList, tItem)
    end
    
    --岛主信息
    self:_showIslandHostHead()
    self:_showIslandHostInfo()

    self:showHostRankist()
end

--@brief    显示挑战排名
function WndSingleCopyInfo:showHostRankist()
    WZLog("WndSingleCopyInfo:showHostRankist", Serialize(self.m_tNextHostList))
    local conHostRankList = GetElement(self.m_root, "conHostRankList_WndSingleCopyInfo",WZUIContainer)
    local txtCantAtt = GetElement(self.m_root, "txtCantAtt_WndSingleCopyInfo", WZUILabelTTF)
    local bIsCanIn = self:_judgeCanInList()
    txtCantAtt:setVisible(not bIsCanIn)

    if self.m_tNextHostList == nil or #self.m_tNextHostList == 0 then
        ShowPanelNullTip(conHostRankList)
        return 
    end
    removeShowPanelNullTip(conHostRankList)
    
    local tRankImg = {"ui/common/common_icon_1st.png", "ui/common/common_icon_2nd.png", "ui/common/common_icon_3rd.png"}

    for i = 1, #self.m_tNextHostList do
        local cellHostRank = CreateElement("CellHostRank_WndSingleCopyInfo")
        cellHostRank:setTag(i-1)
        cellHostRank:setVisible(true)

        local conPlayerHead = GetElement(cellHostRank,"conPlayerHead_CellHostRank",WZUIContainer)
        local cellHeadObject = CellHead:show(conPlayerHead, self.m_tNextHostList[i].headId,self.m_tNextHostList[i].faceId,self.m_tNextHostList[i].sex,nil,nil,nil,self.m_tNextHostList[i].headColor)
        cellHeadObject:setScale(0.9)
        conPlayerHead:setTag(self.m_tNextHostList[i].id)

        local imgRank = GetElement(cellHostRank, "imgRank_CellHostRank", WZUIImage)
        if imgRank then
            imgRank:setFile(tRankImg[i])
        end

        local txtHostScore = GetElement(cellHostRank, "txtHostScore_CellHostRank", WZUILabelTTF)
        txtHostScore:setText( LocalStrings.SINGLECOPY_TEXT6 ..self.m_tNextHostList[i].score)

        local txtPlayerName = GetElement(cellHostRank,"txtPlayerName_CellHostRank",WZUILabelTTF)
        txtPlayerName:setText(self.m_tNextHostList[i].name)

        local conHostRank = GetElement(self.m_root, "conHostRank" .. i .. "_WndSingleCopyInfo", WZUIContainer)
        if conHostRank then
            conHostRank:removeAllChildrenWithCleanup(true)
            conHostRank:setVisible(true)
            conHostRank:addChild(cellHostRank)
        end

        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            txtHostScore:setScale(0.55)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取挑战次数
function WndSingleCopyInfo:_getChallengeCount()
    WZLog("WndSingleCopyInfo:_getChallengeCount")
    self.m_nChallengeCount = 0
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local tempCopyLevelInfo = GDatatab_single_map["id_" .. self.m_tLevelData.id]
    for i,v in ipairs(tSingleCopyData) do
        if self.m_nCopyType == 3 and v.pointId > 0 then
            local tempCopyInfo = GDatatab_single_map["id_" .. v.pointId]
            WZLog("tempCopyInfo =",v.pointId)
            if tempCopyInfo and tempCopyInfo.map_type == tempCopyLevelInfo.map_type and tempCopyInfo.section == tempCopyLevelInfo.section and tempCopyInfo.idgroup == tempCopyLevelInfo.idgroup then
                self.m_nChallengeCount = self.m_nChallengeCount + v.passTime
            end
        else
            if self.m_tLevelData.id == v.pointId then
               self.m_nChallengeCount = v.passTime
            end
        end
    end
end

--@brief	获取扫荡券数量
--@return   #1,扫荡券数量
function WndSingleCopyInfo:_getSweepCouponCount()
    if self.m_nCopyType == 3 then
        return CacheCenter:getPlayerItemCountById(201)
    else
        return CacheCenter:getPlayerItemCountById(106)
    end
    
end


function WndSingleCopyInfo:_initTowerVipData()
    self.singleCopyVipData = {}
    for k ,v in pairs(GDatatab_vip_restriction) do
        if v.type == 6 then
           table.insert(self.singleCopyVipData,v)
        end
    end
end

--@brief    获取玩家是否可以占领该岛
function WndSingleCopyInfo:_judgeCanInList()
    -- body
    local bIsCanIn = true
    local bIsExist = false 
    local bLargerThan = false 

    for i = 1, #self.m_tMyIslandId do
        if self.m_tMyIslandId[i] <= self.m_tLevelData.id then
            bIsExist = true
            break
        end
    end

    if not bIsExist and #self.m_tMyIslandId >= 3 then
        bIsCanIn = false
    end

    return bIsCanIn
end

--@brief    获取噩梦副本对应的三星的副本id
function WndSingleCopyInfo:getHostCopyId(id)
    -- body
    local level1 = GDatatab_single_map["id_" .. id]
    local level2 = GDatatab_single_map["id_" .. (id + 1)]
    local level3 = GDatatab_single_map["id_" .. (id + 2)]
    if level1.map_type == 3 then 
        if level1.map_num == 3 then
            return id
        elseif level2 and level2.idgroup == level1.idgroup and level2.map_num == 3 then
            return id + 1
        elseif level3 and level3.idgroup == level1.idgroup and level3.map_num == 3 then
            return id + 2
        end
    else
        return id
    end
end
-------------------------------------私有方法模块End----------------------------------------
