--CopyManagerData.lua
--@brief	CopyManager的数据模块
--@date		2016/01/22
--@author	qixiang_xie
--@note		副本模块管理

CopyManager = {
    --请不要在这里定义变量
}


-------------------------------------公有方法模块Begin--------------------------------------

--@brief  判断是否能跳转到单人副本模块
--@param  copySectionId : 单人副本小关卡ID
--@return true : 可以进行挑战否则不可挑战
function CopyManager:bJumpToSingleCopy(copySectionId)
	WZLog("CopyManager:bJumpToSingleCopy")
	local copyData = GDatatab_single_map["id_" .. copySectionId]
	local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
	local maxSectionId = 0
    if copyData.map_type == 2 then
        if CheckButtonOpen(ELITE_COPY)  then
        	for i,v in ipairs(tSingleCopyData) do
                if v.pointId > 0 then
                    local copyInfo= GDatatab_single_map["id_" .. v.pointId]
                    if copyInfo.section > maxSectionId and copyInfo.map_type == 2 then
                        maxSectionId = copyInfo.section
                    end
                end
        		
        	end
        	maxSectionId = maxSectionId + 1
        	if maxSectionId >= copyData.section then
        		return true
        	end
        	MsgBoxManager:showTipBox(copyData.map_name .. LocalStrings.HURDLES_NOT_OPEN)
            return false
        else
        	return false
        end
    else
    	for i,v in ipairs(tSingleCopyData) do
            if v.pointId > 0 then
                local copyInfo= GDatatab_single_map["id_" .. v.pointId]
                if copyInfo.section > maxSectionId and copyInfo.map_type == 1 then
                    maxSectionId = copyInfo.section
                end
            end
    	end
    	maxSectionId = maxSectionId + 1
    	if maxSectionId >= copyData.section then
    		return true
    	end
    end
    MsgBoxManager:showTipBox(copyData.map_name .. LocalStrings.HURDLES_NOT_OPEN)
    return false
end

--@brief  判断单人副本的某个章节是否已开启显示
--@param  chapter : 单人副本章节ID(不是关卡ID)
--@return true : 已开启
function CopyManager:bJumpToSingleCopyByChapter(chapter)
    -- body
    WZLog("CopyManager:bJumpToSingleCopyBy =",chapter)
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local maxSectionId = 1
    for i,v in ipairs(tSingleCopyData) do
        if v.pointId > 0 then
            local copyInfo= GDatatab_single_map["id_" .. v.pointId]
            if copyInfo.section > maxSectionId and copyInfo.map_type == 1 then
                maxSectionId = copyInfo.section
            end
        end
    end
    if maxSectionId+1 >= chapter then
        return true
    end
    return false
end

--玩家当前等级是否可以挑战最新的单人副本关卡
function CopyManager:curLevelChallengeState()
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    local curPlayerID = 0
    local bIsNull = true
    local nCurCopyIndex = 1
    local m_nCurLevelIndex = 0
    for i,v in ipairs(tSingleCopyData) do
        local tLevelData = GDatatab_single_map["id_"..v.pointId]
        if tLevelData then
            if  tLevelData.map_type == 1 then
                if tLevelData.section*100 + tLevelData.map_num > nCurCopyIndex*100 + m_nCurLevelIndex and v.pointId > 0 then
                    curPlayerID = v.pointId
                    nCurCopyIndex = tLevelData.section
                    m_nCurLevelIndex = tLevelData.map_num
                end
            end
        end
    end
    if curPlayerID > 0 then
        local tLevelData = GDatatab_single_map["id_" .. curPlayerID]
        --如果下一关为下一个副本的时候
        local tNextLevelData = WndSingleCopy:_getNextLevel(curPlayerID)
        if tNextLevelData and tNextLevelData.section == tLevelData.section + 1 then
            curPlayerID = tNextLevelData.id
        else
            curPlayerID = curPlayerID + 1
        end
    end

    if curPlayerID ~= nil and curPlayerID > 0  then
        local copyInfo = GDatatab_single_map["id_"..curPlayerID]
        local playerLevel = CacheCenter:getPlayerInfo().level
        if playerLevel >= copyInfo.level then
            return true
        else
            return false
        end
    else
        return false
    end
end

--@brief  根据关卡ID获取已挑战次数
function CopyManager:findSCopyChallengeN(sCopyHurdleId)
    WZLog("CopyManager:findSCopyChallengeN")
    local nChallengeCount = nil
    local tSingleCopyData = CacheCenter:getSingleCopyData() or {}
    for i,v in ipairs(tSingleCopyData) do
        if sCopyHurdleId == v.pointId then
            nChallengeCount = v.passTime
        end
    end
    return nChallengeCount
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
