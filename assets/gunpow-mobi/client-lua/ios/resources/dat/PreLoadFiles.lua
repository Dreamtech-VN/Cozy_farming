--PreLoadFile.lua
--@brief	预载文件列表
--@date		2014/3/8
--@author	叶威
--@note		加载部分lua文件列表，给文件加载提供进度，解决在闪屏卡很久的问题

local LOADINGSTATE_INIT = 0
local LOADINGSTATE_DOING = 1
local LOADINGSTATE_SUSPEND = 2
local LOADINGSTATE_FINISH = 3

--小岛所需lua文件数量
local LUAFILE_NUM_FOR_ISLAND = 116

PreLoadFile = {
    m_tCallBack = nil,                              --回调的表
    m_funCallBack = nil,                            --回调的方法
    m_countOneFrame = 5,                            --每帧加载的文件数量
    m_currentIndex = 1,                             --当前加载索引
    m_scheduleId = -1,                              --定时器id

    m_scheduleLoadRestLuaId = -1,                   --后台加载剩余所有lua文件的定时器ID
    m_bLoadFrameCount = 1,                          --加载lua文件帧间隔计数器
    FRAME_GAP = 2,                                  --加载lua文件帧间隔（每FRAME_GAP帧加载一个lua文件）
    m_nRestCurIndex = LUAFILE_NUM_FOR_ISLAND + 1,   --除小岛外剩余lua文件当前加载索引
    
    m_nLoadingState = LOADINGSTATE_INIT,            --加载状态，0:初始 1:加载中 2:挂起 3:完成
}

-------------------------------------公有方法模块Begin--------------------------------------
--@breif  加载文件列表
--@param  countOneFrame:每帧加载的数量,默认为5
--@param  tCallBack：回调的表对象
--@param  funCallBack:回调的表方法，格式为funCallBack（percent）,其中percent为当前半分比范围（0-1）
function PreLoadFile:startLoadFiles(tCallBack,funCallBack,countOneFrame)
    WZResourceManager:getInstance():executeLuaFile("LuaFilesList.lua")
    if LuaFilesList == nil or #LuaFilesList == 0 then
            CCLuaLog("PreLoadFile:startLoadFiles,LuaFilesList == nil or #LuaFilesList == 0")
            return
    end
    self.m_currentIndex = 1
    self.m_tCallBack = tCallBack
    self.m_funCallBack = funCallBack
    self.m_countOneFrame = (countOneFrame or self.m_countOneFrame)
    self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self._loadFileSchedule, 0, false)

    self.m_nLoadingState = LOADINGSTATE_DOING
end

--@breif  继续加载lua文件
function PreLoadFile:continueLoading()
    if self.m_nLoadingState == LOADINGSTATE_SUSPEND then 
        self.m_nLoadingState = LOADINGSTATE_DOING
    end
end

--@breif  挂起加载lua文件
function PreLoadFile:suspendLoading()
    if self.m_nLoadingState == LOADINGSTATE_DOING then
        self.m_nLoadingState = LOADINGSTATE_SUSPEND
    end
end

--@breif  加载lua文件是否完成
--@return #1,是否完成
function PreLoadFile:ifLoadingFinish()
    if self.m_nLoadingState == LOADINGSTATE_FINISH then
        return true
    end
    return false
end

--@brief    加载小岛界面需要的lua文件
--@param    tCallBack：回调的表对象
--@param    fnCallBack:回调的表方法，格式为fnCallBack（percent）,其中percent为当前半分比范围（0-1）
--@param    countOneFrame:每帧加载的数量,默认为5
function PreLoadFile:loadLuaFilesForIsland(tCallBack, fnCallBack, countOneFrame)
    WZResourceManager:getInstance():executeLuaFile("LuaFilesList.lua")

    if LuaFilesList == nil or #LuaFilesList == 0 then
        CCLuaLog("PreLoadFile:loadLuaFilesForIsland,LuaFilesList == nil or #LuaFilesList == 0")
        return
    end

    --重新加载lua文件资源时，重置lua文件资源加载完成标识g_bLuaFilesAllLoaded
    g_bLuaFilesAllLoaded = false

    if self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_scheduleId = -1
    end

    self.m_currentIndex = 1
    self.m_tCallBack = tCallBack
    self.m_funCallBack = fnCallBack
    self.m_countOneFrame = (countOneFrame or self.m_countOneFrame)
    self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self._loadLuaFilesForIslandSchedule, 0, false)

    self.m_nLoadingState = LOADINGSTATE_DOING
end

--@brief    加载剩余的所有lua文件
function PreLoadFile:loadRestAllLuaFiles()
    if LuaFilesList == nil or #LuaFilesList == 0 then
        CCLuaLog("PreLoadFile:loadRestAllLuaFiles,LuaFilesList == nil or #LuaFilesList == 0")
        return
    end

    if self.m_scheduleLoadRestLuaId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleLoadRestLuaId)
        self.m_scheduleLoadRestLuaId = -1
    end

    self.m_nRestCurIndex = LUAFILE_NUM_FOR_ISLAND + 1
    self.m_scheduleLoadRestLuaId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self._loadRestLuaFilesSchedule, 0, false)
end


-------------------------------------公有方法模块End--------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@breif  根据索引加载文件
--@param  index:索引
function PreLoadFile:_loadFileByIndex( index )
    if LuaFilesList == nil or #LuaFilesList == 0 or index > #LuaFilesList then
            CCLuaLog("PreLoadFile:_loadFileByIndex,LuaFilesList == nil or #LuaFilesList == 0 or index > #LuaFilesList")
            return
    end
    local fileName = LuaFilesList[index]
    WZResourceManager:getInstance():executeLuaFile(fileName)
--  CCLuaLog("fileName = "..fileName)
end

--@breif  每帧加载指定数量的文件
function PreLoadFile :_loadFileSchedule()
    local self = PreLoadFile
    if LuaFilesList == nil or #LuaFilesList == 0 then
        CCLuaLog("PreLoadFile:_loadFileSchedule,LuaFilesList == nil or #LuaFilesList == 0")
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        return
    end
    
    if self.m_nLoadingState == LOADINGSTATE_SUSPEND then
        return
    end
    
    local count = math.min(self.m_currentIndex+self.m_countOneFrame-1,#LuaFilesList)
    for i=self.m_currentIndex,count do
        self:_loadFileByIndex(i)
        self.m_currentIndex = self.m_currentIndex + 1
    end
    CCLuaLog("self.m_currentIndex = "..self.m_currentIndex)
    
    local percent = (self.m_currentIndex-1)/#LuaFilesList
    if self.m_tCallBack == nil or self.m_funCallBack == nil then
        CCLuaLog("PreLoadFile:_loadFileSchedule,self.m_tCallBack == nil or self.m_funCallBack == nil")
        return
    end
    if percent >= 1 and self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_nLoadingState = LOADINGSTATE_FINISH
    end
    
    self.m_funCallBack(self.m_tCallBack,percent)
end

--@breif  每帧加载指定数量的小岛界面所需的lua文件
function PreLoadFile :_loadLuaFilesForIslandSchedule()
    local self = PreLoadFile
    
    if self.m_nLoadingState == LOADINGSTATE_SUSPEND then
        return
    end
    
    local count = math.min(self.m_currentIndex+self.m_countOneFrame-1, LUAFILE_NUM_FOR_ISLAND)
    for i=self.m_currentIndex,count do
        WZResourceManager:getInstance():executeLuaFile(LuaFilesList[i].pathName)
        self.m_currentIndex = self.m_currentIndex + 1
    end
    CCLuaLog("self.m_currentIndex = "..self.m_currentIndex)
    
    local percent = (self.m_currentIndex-1) / LUAFILE_NUM_FOR_ISLAND
    if self.m_tCallBack == nil or self.m_funCallBack == nil then
        CCLuaLog("PreLoadFile:_loadFileSchedule,self.m_tCallBack == nil or self.m_funCallBack == nil")
        return
    end
    if percent >= 1 and self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_scheduleId = -1
        self.m_nLoadingState = LOADINGSTATE_FINISH
    end
    
    self.m_funCallBack(self.m_tCallBack,percent)
end

--@breif  加载剩余所有的lua文件
function PreLoadFile:_loadRestLuaFilesSchedule()
    local self = PreLoadFile

    --每self.FRAME_GAP帧加载一个lua文件
    if self.m_bLoadFrameCount == self.FRAME_GAP then
        self.m_bLoadFrameCount = 1
    else
        self.m_bLoadFrameCount = self.m_bLoadFrameCount + 1
        return
    end

    if LuaFilesList[self.m_nRestCurIndex].loadFlag ~= LUALOAD_LOADED then
        --加载lua文件
        WZResourceManager:getInstance():executeLuaFile(LuaFilesList[self.m_nRestCurIndex].pathName)
        --将已加载的lua文件的标志位置为LUALOAD_LOADED（已经加载）
        LuaFilesList[self.m_nRestCurIndex].loadFlag = LUALOAD_LOADED
    end

    self.m_nRestCurIndex = self.m_nRestCurIndex + 1

    --lua资源全部加载完成，关闭定时器
    if self.m_nRestCurIndex > #LuaFilesList then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleLoadRestLuaId)
        self.m_scheduleLoadRestLuaId = -1
        g_bLuaFilesAllLoaded = true
        WZLog("Lua Files All Loaded!")
    end
end

-------------------------------------私有方法模块End--------------------------------------

