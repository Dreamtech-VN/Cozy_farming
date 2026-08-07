--CellPvpRankKingLog.lua
--@brief	CellPvpRankKingLog的UI模块
--@date		2015-11-13
--@author	binshao
--@note		竞技之王日志


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankKingLog:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankKingLog:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellPvpRankKingLog:_update()
    local time = self:_timeChange()
    WZLog("-------------------kingLog-----------------",self.data.playerName,time)

    local serverId = IPDhttpServer:getCurServerId()
    local kfFlag = tonumber(serverId) ~= tonumber(self.data.serverId)
    local format1 = [[<T C="255,236,193" S="20" P="0">%s </T><T C="254,167,48" S="20" P="0">%s%s </T><T C="255,236,193" S="20" P="0">%s</T>]]
    local format2 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I>]]
    WZLog("-------------CellPvpRankKingLog--------------",serverId,self.data.serverId,kfFlag)
    local ftbLog =  GetElement(self.m_root,"ftbLog_CellPvpRankKingLog",WZUIFreeTextBox)
    if kfFlag then
        ftbLog:setShowText(string.format(format2 .. format1, self.data.playerName, time, LocalStrings.XX_WORSHIP_XX, self.data.beWorshipName))
    else
        ftbLog:setShowText(string.format(format1, self.data.playerName, time, LocalStrings.XX_WORSHIP_XX, self.data.beWorshipName))
    end

end

function CellPvpRankKingLog:_timeChange()
    WZLog("-----------------cur time--------------",os.time() , self.data.worshipDate)
    --local curTime = (os.time() - self.data.worshipDate) > 0 and os.time() - self.data.worshipDate or 1
    local curTime = self.data.worshipDate
    local min = 60
    local hour = 60*min
    local day = 24*hour

    local str
    if curTime >= day then
        local d = math.floor(curTime/day)
        str = string.format(LocalStrings.DAY_BEFORE, d)
    elseif curTime >= hour then
        local h = math.floor(curTime/hour)
        str = string.format(LocalStrings.HOUR_BEFORE, h)
    else
        local m = math.ceil(curTime/min)
        if m <= 0 then
            str = LocalStrings.JUST_NOW
        else
            str = string.format(LocalStrings.MINUTE_BEFORE, m)
        end
    end
    return str
end
-------------------------------------私有方法模块End----------------------------------------