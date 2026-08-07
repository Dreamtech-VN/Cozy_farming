--SceneCopyData.lua
--@brief	SceneCopy的数据模块
--@date		2015/04/09
--@author	xiaoyu_wu
-- modify   binshao 2015-7-9
--@note		副本UI场景

SceneCopy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCopy:_init()
	self.m_root = nil	 	  		--场景根节点
    self.copyType = 1               --副本序号 1:单人，2:组队，3:日常, 4:爬塔
    --self.showInfo = nil             -- 是否显示当前副本信息，单人副本用
    self.m_fBack = nil              --返回方法
    self.m_tCurCopyWin = nil        --当前副本窗口的UI节点引用
    self.m_nLoadId = nil
    self.m_tWndBottomBarObj=nil
    self.uiAniCallBack = nil        -- 动画回调
    self.m_tReturnCallBack = nil 
    self.m_nChapterID = nil         --章节ID
    self.m_bSet = nil
    self.m_tCellTopHandle = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCopy:_unInit()
	self.m_root = nil
    --self.copyType = nil
    --self.showInfo = nil
    self.m_fBack = nil
    self.m_tCurCopyWin = nil 
    self.m_nLoadId = nil
    self.m_tWndBottomBarObj = nil
    self.uiAniCallBack = nil
    self.m_tReturnCallBack = nil 
    self.m_nChapterID = nil
    self.m_bSet = nil
    self.m_tCellTopHandle = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCopy:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCopy")
	assert(element, "SceneCopy create element failed!")
	self:_init()
	return element
end

--@brief  任务跳转
function SceneCopy:taskJump(showInfo)
    WZLog("SceneCopy:taskJump")
    local sectionCellId = GDatatab_task["id_"..showInfo].target
    if sectionCellId ~= nil then
        local strIndex = string.find(sectionCellId,"*")
        local str2Index = string.find(sectionCellId,"=")
        local isNull = string.find(sectionCellId,"-1")
        if strIndex ~= nil and str2Index ~= nil and isNull == nil then
            sectionCellId = string.sub(sectionCellId,strIndex+1,str2Index-1)
            local sinlgeCopyModel = GDatatab_single_map["id_" .. sectionCellId].map_type
            if WndSingleCopy.m_nCopyType == sinlgeCopyModel then  --同一种单人副本类型则不需要重新加载地图
                WndSingleCopy:setJumpPageIndex(sectionCellId)
                WndSingleCopy:setIsShowCopyLevelInfo(true)
                local sectionId = nil
                sectionId = GDatatab_task["id_"..showInfo].script[1][2]
                WZLog("SceneCopy:showScene sectionId = ",sectionId)
                if sectionId ~= nil and sectionId > 0 then
                    WndSingleCopy:resertCurPage(sectionId-1)
                end
                return false
            end
        end
    end
    return true
end

--@brief  获取物品跳转
function SceneCopy:getItemJump(showInfo)
    WZLog("SceneCopy:getItemJump == ",showInfo)
    local sinlgeCopyInfo = GDatatab_single_map["id_" .. showInfo]
    local sinlgeCopyModel = sinlgeCopyInfo.map_type
    if WndSingleCopy.m_nCopyType == sinlgeCopyModel then  --同一种单人副本类型则不需要重新加载地图
        WndSingleCopy:setJumpPageIndex(showInfo)
        local sectionId = sinlgeCopyInfo.section
        WndSingleCopy:setIsShowCopyLevelInfo(true)
        WZLog("SceneCopy:showScene sectionId = ",sectionId)
        if sectionId ~= nil and sectionId > 0 then
            WndSingleCopy:resertCurPage(sectionId-1)
        end
        return false
    end
    return true
end

--@brief	显示副本场景
--@param	copyType 1:单人，2:组队，3:日常，4:爬塔
--@param    levelId 暂时没用
--@param    showInfo 附带信息
--@param    bTaskJump : 是否任务跳转
--@param    chapter : 章节（例如单人副本有10个章节每个章节有10个关卡。可以指定跳转到那个章节上）
--@note		调用此接口显示副本场景
function SceneCopy:showScene(copyType, levelId, showInfo,bTaskJump,chapter,bSet)
    WZLog("SceneCopy:showScene", copyType)
    if showInfo == 2 and copyType == 1 then
        if not CheckButtonOpen(ELITE_COPY) then
            return
        end
    end
  
    if self.m_root and showInfo~= nil then  
        if WindowManager:getSceneRoot():getLuaObjectName() == self.m_root:getLuaObjectName() then
            local isContinu = nil
            if WndSingleCopy.m_root ~= nil and bTaskJump then  
                isContinu = self:taskJump(showInfo)
            elseif WndSingleCopy.m_root ~= nil and showInfo > 100 then
                isContinu = self:getItemJump(showInfo)
            end
            if isContinu ~= nil and not isContinu then
                return
            end
        end
    end

    if self.m_root and self.copyType == copyType and copyType == 4 and levelId == nil and showInfo == nil and bTaskJump == nil then
        return 
    end

    local sceneCopy = SceneCopy:createElement()
    replaceScene(sceneCopy)
    self.copyType = copyType or 1
    self.m_bSet = bSet
    
    if copyType == 1 then
        self.m_nChapterID = chapter
    end

    self.levelId = levelId
    self.showInfo = showInfo
   
    self.m_bTaskJump = bTaskJump
end

--@brief	设置返回方法
--@param	fBack,返回方法
function SceneCopy:setBackFunction(fBack)
    self.m_fBack = fBack
end

--@brief  返回是否从任务跳转到此UI
function SceneCopy:getBTaskJump()
    return self.m_bTaskJump
end

function SceneCopy:recoveryTaskJump()
    self.m_bTaskJump = false
end

--@brief	设置返回方法
--@param	fBack,返回方法
function SceneCopy:setUiAniCallBack(luaObject,callBack)
    self.uiAniCallBack = {}
    self.uiAniCallBack[1] = luaObject
    self.uiAniCallBack[2] = callBack
end

--@brief 重设单人副本数据
function SceneCopy:resetSingleCopyData()
    WZLog("SceneCopy:resetSingleCopyData")
    GlobalGame.g_nSingleMapPage = nil
    GlobalGame.g_nEliteSingleMapPage = nil
    GlobalGame.g_nSingleCopyType = 1
end

--@brief    设置退出副本的回调方法
function SceneCopy:setCallBackFun(tCell, func)
    -- body
    self.m_tReturnCallBack = {}
    self.m_tReturnCallBack[1] = tCell
    self.m_tReturnCallBack[2] = func
end

--@brief    定向推送活动的数据
function SceneCopy:setSpecifyActivityData(pushInfo, lastNum)
    -- body
    self:closeLoading()
    WZLog("SceneCopy:setSpecifyActivityData", Serialize(pushInfo), Serialize(lastNum))
    g_bIsPushSpecifyActivity = false
    if #lastNum <= 0 then 
        return 
    else
        WndSpecifyActivity:showInterface(pushInfo, lastNum)
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------