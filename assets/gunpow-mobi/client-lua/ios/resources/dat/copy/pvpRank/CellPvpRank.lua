--CellPvpRank.lua
--@brief	CellPvpRank的UI模块
--@date		2015-12-9
--@author	binshao
--@note		排位赛主界面排行榜单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRank:onExit(element)
	self:_unInit()
end

function CellPvpRank:onCheckInfo()
    WZLog("CellPvpRank:onCheckInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新人物头像
--playerId	int[]	玩家id
--playerName	String[]	玩家名称
--playerSex	byte[]	玩家性别
--playerHeadId	int[]	玩家头
--playerFaceId	int[]	玩家脸
--playerLevel	short[]	玩家等级
--segmentLevel	int[]	玩家段位id
--score	int[]	玩家积分
--battleTimes	int[]	本周战斗次数
--winTimes	int[]	本周胜利次数
--winStreak	int[]	本周最高连胜次数
function CellPvpRank:_update()
    local data = self.data

    -- 排名
    local imgPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png" }
    if data.rank < 4 then
        local img = GetElement(self.m_root,"imgRank_CellPvpRank",WZUIImage)
        img:setFile(imgPath[data.rank])
    else
        local txt = GetElement(self.m_root,"txtRank_CellPvpRank",WZUILabelTTF)
        txt:setText(data.rank)
    end

    -- 头像
    local con = GetElement(self.m_root,"conHead_CellPvpRank",WZUIContainer)
    CellHead:show(con,data.playerHeadId,data.playerFaceId,data.playerSex,nil,nil,nil,data.headColour)

    -- 等级，名字
    local serverId = IPDhttpServer:getCurServerId()
    local kfFlag = tonumber(serverId) ~= tonumber(data.serverId)
    WZLog("-------------CellPvpRank--------------",serverId,data.serverId,kfFlag)
    local imgKF = GetElement(self.m_root,"imgKF_CellPvpRank",WZUIImage)
    imgKF:setVisible(kfFlag)

    local txtLv = GetElement(self.m_root,"txtLv_CellPvpRank",WZUILabelTTF)
    txtLv:setText("Lv"..data.playerLevel)
    local txtName = GetElement(self.m_root,"txtName_CellPvpRank",WZUILabelTTF)
    txtName:setText(data.playerName)
    -- 自己名字需要修改颜色
    if data.playerName == CacheCenter:getPlayerInfo().name then
        txtName:setColor(GlobalMethod:ccc3(99,255,95))
    end

    -- 分数
    WZLog("-------------playrPvp lv and score",data.segmentLevel,data.score)
    local score = pvpGetCurAllScore(data.segmentLevel,data.score)
    local txtScore = GetElement(self.m_root,"txtScore_CellPvpRank",WZUILabelTTF)
    txtScore:setText(score)


--    -- 排位等级
--    WZLog("----------------------888---------------",data.segmentLevel)
--    local tabInfo = GDatatab_rank_segment["id_"..data.segmentLevel]
--    local imgDi = GetElement(self.m_root,"imgLvDi_CellPvpRank",WZUIImage)
--    imgDi:setFile("ui/common/"..tabInfo.iocn..".png")
--    local lafLv = GetElement(self.m_root,"lafLv_CellPvpRank",WZUILabelAtlasFont)
--    lafLv:setText(tabInfo.iocn_level)
end

-------------------------------------私有方法模块End----------------------------------------