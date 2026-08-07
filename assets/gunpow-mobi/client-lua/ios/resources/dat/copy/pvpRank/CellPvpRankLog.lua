--CellPvpRankLog.lua
--@brief	CellPvpRankLog的UI模块
--@date		2015-11-11
--@author	binshao
--@note		排位赛战绩日志


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankLog:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankLog:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellPvpRankLog:_update()
    local data = self.data
    local tabInfo = GDatatab_rank_segment["id_"..data.segmentLevel]

    local state = (data.logType == 1 or data.logType == 2) and true or false
    local con1 = GetElement(self.m_root, "con1_CellPvpRankLog",WZUIContainer)
    local con2 = GetElement(self.m_root, "con2_CellPvpRankLog",WZUIContainer)
    con1:setVisible(state)
    con2:setVisible(not state)

    local imgF1 = GetElement(self.m_root,"imgFlag1_CellPvpRankLog",WZUIImage)
    local imgF2 = GetElement(self.m_root,"imgFlag2_CellPvpRankLog",WZUIImage)
    local txtD1 = GetElement(self.m_root,"txtDesc1_CellPvpRankLog",WZUILabelTTF)
    local txtD2 = GetElement(self.m_root,"txtDesc2_CellPvpRankLog",WZUILabelTTF)
    local lvD1 = GetElement(self.m_root,"imgLvDi1_CellPvpRankLog",WZUIImage)
    local lvD2 = GetElement(self.m_root,"imgLvDi2_CellPvpRankLog",WZUIImage)
    local lafLv1 = GetElement(self.m_root,"lafLv1_CellPvpRankLog",WZUILabelAtlasFont)
    local lafLv2 = GetElement(self.m_root,"lafLv2_CellPvpRankLog",WZUILabelAtlasFont)
    local ftbD1 =  GetElement(self.m_root,"ftbDesc1_CellPvpRankLog",WZUIFreeTextBox)

    if data.logType == 1 or data.logType == 2 then
        local time = self:_timeChange()
        local score = data.score == 0 and LocalStrings.NO_CHANGE or data.score
        if data.logType == 1 then
            imgF1:setFile("ui/common/battle_icon_shangsheng.png")
            txtD1:setText(string.format(LocalStrings.RANK_LOG_WIN, time))
        else
            imgF1:setFile("ui/common/battle_icon_xiajiang.png")
            txtD1:setText(string.format(LocalStrings.RANK_LOG_FAIL, time))
        end
        ftbD1:setShowText(string.format(LocalStrings.RANK_LOG_DESC1, data.opponentName, score))
        lvD1:setFile("ui/common/"..tabInfo.iocn..".png")
        lafLv1:setText(tabInfo.iocn_level)
    elseif data.logType == 3 or data.logType == 4 then
        if data.logType == 3 then
            imgF2:setFile("ui/common/battle_icon_shangsheng.png")
            txtD2:setText(LocalStrings.RANK_LOG_LV_UP)
        else
            imgF2:setFile("ui/common/battle_icon_xiajiang.png")
            txtD2:setText(LocalStrings.RANK_LOG_LV_Down)
        end
        lvD2:setFile("ui/common/"..tabInfo.iocn..".png")
        lafLv2:setText(tabInfo.iocn_level)
    end
end

function CellPvpRankLog:_timeChange()
    --local curTime = os.time() - self.data.createDate
    local curTime = self.data.createDate
    local min = 60
    local hour = 60*min
    local day = 24*hour

    local str
    if curTime >= day then
        local d = math.floor(curTime/day)
        str = d..LocalStrings.DAY
    elseif curTime >= hour then
        local h = math.floor(curTime/hour)
        str = h..LocalStrings.HOUR1
    else
        local m = math.ceil(curTime/min)
        str = m..LocalStrings.MINUTE1
    end
    return str
end
-------------------------------------私有方法模块End----------------------------------------