--WndGuildGroupTeamData.lua
--@brief	WndGuildGroupTeam的数据模块
--@date		2017/03/01
--@author	Tianxiang_Xu
--@note		淘汰赛小组战队信息界面

WndGuildGroupTeam = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGuildGroupTeam:_init()
	self.m_root = nil	 	  			--场景根节点
    self.videoData = nil
    self.m_nCheckGuildId = nil          --要查看的公会的录像
    self.m_tFindData = nil 
    self.m_nLoadingId = nil 
    self.m_nRaceMark = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGuildGroupTeam:_unInit()
	self.m_root = nil
    self.videoData = nil
    self.m_nCheckGuildId = nil          --要查看的公会的录像
    self.m_tFindData = nil 
    self.m_nLoadingId = nil 
    self.m_nRaceMark = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGuildGroupTeam:createElement()
	local element = WZUISystem:getInstance():createElement("WndGuildGroupTeam")
	assert(element, "WndGuildGroupTeam create element failed!")
	self:_init()
	return element
end


--@brief    外部接口
--@param    guileId : 公会Id
--@param    nRaceMark : 比赛的阶段
function WndGuildGroupTeam:showInterface(guileId, nRaceMark)
    -- body
    if self.m_root then return end

    local wndTeam = WndGuildGroupTeam:createElement()
    if wndTeam then
        self.m_nCheckGuildId = guileId
        self.m_nRaceMark = nRaceMark
        WZLog("WndGuildGroupTeam:showInterface")
        WindowManager:addWindow(wndTeam, WndGuildGroupTeam, true)
    end
end

-- 获取录像数据
function WndGuildGroupTeam:setData(version, size, guildId, guildName, playerId, faceId, headId, colour, sex, vip, camp, win, index, num, recordId, vision, ids)
    WZLog("WndGuildGroupTeam:setData", Serialize(num), Serialize(guildId), Serialize(index))
    local videoData = {}
    videoData.version = version
    videoData.video = {}
    local startIndex = 0
    local endIndex = 0
    for i = 1, #size do
        local video = {}
        local vSize = size[i]
        WZLog("-------------vSize--------------",vSize)
        local sIndex = startIndex + 1
        local eIndex = startIndex + vSize
        local guildData = self:parseGuildData(guildId, guildName, playerId, faceId, headId, colour, sex, vip, camp,win[i],sIndex,eIndex)
        video.guildData = guildData
        video.win = win[i]
        video.index = index[i]
        video.num = num[i]
        video.recordId = recordId[i]
        video.vision = vision[i]
        video.ids = ids[i]
        table.insert(videoData.video,video)

        startIndex = startIndex + vSize
    end

    self.videoData = videoData

    WZLog("WndGuildGroupTeam:setData", Serialize(self.videoData))
    self:_stopLoading()
    self:displayRecord()
end

-- 解析录像数据
function WndGuildGroupTeam:parseGuildData(guildId, guildName, playerId, faceId, headId, colour, sex, vip, camp,winId,startIndex,endIndex)
    local gData = {}
    local gInfoL
    local gInfoR
    local pInfoL = {}   -- 左边玩家信息
    local pInfoR = {}   -- 右边玩家信息
    for i = startIndex, endIndex do
        local pInfo = {}
        pInfo.playerId = playerId[i]
        pInfo.faceId = faceId[i]
        pInfo.headId = headId[i]
        pInfo.colour = colour[i]
        pInfo.sex = sex[i]
        pInfo.vip = vip[i]
        pInfo.camp = camp[i]
        if camp[i] == 0 then
            table.insert(pInfoL,pInfo)
            if gInfoL == nil then
                gInfoL = {}
                gInfoL.guildId = guildId[i]
                gInfoL.guildName = guildName[i]
                if guildId[i] == winId then
                    gInfoL.winState = true
                else
                    gInfoL.winState = false
                end
            end
        elseif camp[i] == 1 then
            table.insert(pInfoR,pInfo)
            if gInfoR == nil then
                gInfoR = {}
                gInfoR.guildId = guildId[i]
                gInfoR.guildName = guildName[i]
                if guildId[i] == winId then
                    gInfoR.winState = true
                else
                    gInfoR.winState = false
                end
            end
        end
    end

    gData.gInfo = {gInfoL,gInfoR}
    gData.pInfo = {pInfoL,pInfoR}
    if gInfoL.guildId > gInfoR.guildId then
        gData.gInfo = {gInfoR,gInfoL}
        gData.pInfo = {pInfoR,pInfoL}
    end

    return gData
end

-- 寻找录像
function WndGuildGroupTeam:findVideo(num,guildId)
    local video = self.videoData.video
    local findVideo = {}
    for i = 1, #video do
        if video[i].num == num then
            local guildData = video[i].guildData
            local flag = false
            for k = 1, 2 do
                if guildData.gInfo[k].guildId == guildId then
                    flag = true
                    break
                end
            end
            if flag then
                table.insert(findVideo,video[i])
            end
        end
    end
    WZLog("--------findVideo------------",#findVideo)

    for i = 1, #findVideo do
        WZLog("--------video info----**-",i,findVideo[i].guildData.gInfo[1].guildName)
        WZLog("--------video info----**-",i,findVideo[i].guildData.gInfo[2].guildName)
        WZLog("--------video info----**-",i,findVideo[i].guildData.gInfo[1].guildId)
        WZLog("--------video info----**-",i,findVideo[i].guildData.gInfo[2].guildId)
        WZLog("--------video info----**-",i,findVideo[i].num,findVideo[i].index)
        WZLog("-------------end---------------------------")
    end
    return findVideo
end

-- 模拟数据
-- 对战方式 2-1，1-2，2-2 2-2，1-2，2-1
function WndGuildGroupTeam:_initData()
    local size = {3,3,4,4,3,3 }
    local guildId = {101,101,201,101,201,201,101,101,201,201,301,301,401,401,301,401,401,301,301,401 }
    local guildName = {"A1","A1","B1","A1","B1","B1","A1","A1","B1","B1","C1","C1","D1","D1","C1","D1","D1","C1","C1","D1" }
    local playerId = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 }
    local faceId = {4300,4301,4302,4303,4304,4305,4306,4307,4308,4309,4300,4301,4302,4303,4304,4305,4306,4307,4308,4309}
    local headId = {4100,4101,4102,4103,4104,4105,4106,4107,4108,4109,4100,4101,4102,4103,4104,4105,4106,4107,4108,4109 }
    local colour = {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1 }
    local sex = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
    local vip = {1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10 }
    local camp = {0,0,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1 }
    local win = {101,201,101,301,401,301 }
    local index = {0,1,2,0,1,2 }
    local num = {1,1,1,1,1,1 }
    local recordId = {1001,1002,1003,1004,1005,1006 }
    local vision = {0,1,0,1,0,1 }
    local ids = {1,2,3,4,5,6}
    local version = 1

    self:setData(version, size, guildId, guildName, playerId, faceId, headId, colour, sex, vip, camp,win, index, num, recordId, vision, ids)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndGuildGroupTeam:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndGuildGroupTeam:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
