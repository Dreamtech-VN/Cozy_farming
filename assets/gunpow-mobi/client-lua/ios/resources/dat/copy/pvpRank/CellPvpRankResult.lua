--CellPvpRankResult.lua
--@brief	CellPvpRankResult的UI模块
--@date		2015-12-10
--@author	binshao
--@note		排位赛结算cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankResult:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankResult:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPvpRankResult:_update()
    local data = self.data
    self:_initTitile()
    self:_initPlayerData()
    self:_initRole()
    self.m_root:enableSchedule("_expAni", 0.1)
end

-- 初始化胜负标题
function CellPvpRankResult:_initTitile()
    local imgTitileDi = GetElement(self.m_root,"imgTitleDi_CellPvpRankResult",WZUIImage)
    local imgTitile = GetElement(self.m_root,"imgTitle_CellPvpRankResult",WZUIImage)

    for i = 1, 2 do
        local imgTitileDi = GetElement(self.m_root,"imgTitleDi"..i.."_CellPvpRankResult",WZUIImage)
        if self.data.result == 1 then
            imgTitileDi:setFile("ui/common/common_pic_chouzibg.png")
        else
            imgTitileDi:setFile("ui/common/common_pic_chouzibgsb.png")
        end
    end

    if self.data.result == 1 then
        imgTitile:setFile("ui/common/common_icon_pswsl.png")
    else
        imgTitile:setFile("ui/common/common_icon_pswsb.png")
    end
end

-- 初始化玩家信息
function CellPvpRankResult:_initPlayerData()
    local data = self.data
    -- 等级，名字
    local serverId = IPDhttpServer:getCurServerId()
    local kfFlag = tonumber(serverId) ~= tonumber(data.serverId)
    local ftbNameLv = GetElement(self.m_root,"ftbNameLv_CellPvpRankResult",WZUIFreeTextBox)
    if kfFlag then
        ftbNameLv:setShowText(string.format(LocalStrings.RANK_RESULT_KF1,"Lv"..data.playerLevel.." "..data.playerName))
    else
        if data.playerId == CacheCenter:getPlayerInfo().id then
            ftbNameLv:setShowText(string.format(LocalStrings.RANK_RESULT_NOKF,"Lv"..data.playerLevel.." "..data.playerName))
        else
            ftbNameLv:setShowText(string.format(LocalStrings.RANK_RESULT_NOKF1,"Lv"..data.playerLevel.." "..data.playerName))
        end
    end

    --今日战绩
    local txtDay = GetElement(self.m_root,"txtDay_CellPvpRankResult",WZUILabelTTF)
    txtDay:setText(string.format(LocalStrings.COMMUNITYINFO67,data.dayBattleTimes,data.dayWinTimes))
	-- if ProjConfig.LANGUAGE == "en" then
	-- 	txtDay:setText(string.format(LocalStrings.COMMUNITYINFO67,data.dayWinTimes,data.dayBattleTimes))
	-- end

    -- 当前连胜
    local txtWin = GetElement(self.m_root,"txtWin_CellPvpRankResult",WZUILabelTTF)
    txtWin:setText(data.dayWinStreak)

    -- 获得积分
    local txtScore = GetElement(self.m_root,"txtScore_CellPvpRankResult",WZUILabelTTF)
    txtScore:setText(data.score)

    -- 阻击连胜
    if data.isCheck == 1 then
        local txtKillWin = GetElement(self.m_root,"txtKillWin_CellPvpRankResult",WZUILabelTTF)
        txtKillWin:setVisible(true)
    end

    -- 排位等级
    self:_updateSegmentInfo(data.segmentLevel,data.segmentExp)
    self.curLv = data.segmentLevel
    self.curExp = data.segmentExp
    self.leftExp = data.score
    WZLog("---------------cur info--------------",self.curLv,self.curExp,self.leftExp)
end

-- 创建玩家形象
function CellPvpRankResult:_initRole()
    local info = self.data.role
    local conPlayer = CreatePlayerFigure(info.playerSex, info.equip,nil,nil,nil,nil,nil,nil,false,nil,info.colour,info.bodyColour)
    local con = GetElement(self.m_root,"conPlayer_CellPvpRankResult",WZUIContainer)
    local node = conPlayer:getAnimNode()
    con:addChild(node)
    if self.data.result == 1 then
        conPlayer:play("win",true)
    else
        conPlayer:play("failure",true)
    end

    local state =  self.data.playerId == CacheCenter:getPlayerInfo().id
    local arm = GetElement(self.m_root,"armDi_CellPvpRankResult",WZArmature)
    arm:setVisible(state)

    if self.changeDir then
        conPlayer:setFlipX(self.changeDir)
    end
end

-- 更新排位赛相关等级
function CellPvpRankResult:_updateSegmentInfo(segmentLevel,segmentExp)
    -- 排位等级
    local tabInfo = GDatatab_rank_segment["id_"..segmentLevel]
    local imgDi = GetElement(self.m_root,"imgLvDi_CellPvpRankResult",WZUIImage)
    imgDi:setFile("ui/common/"..tabInfo.iocn..".png")
    local lafLv = GetElement(self.m_root,"lafLv_CellPvpRankResult",WZUILabelAtlasFont)
    lafLv:setText(tabInfo.iocn_level)

    -- 排位赛经验
    local pro = GetElement(self.m_root,"proExp_CellPvpRankResult",WZUIProgress)
    pro:setPercentage(math.floor(segmentExp*100/tabInfo.score))
    local txtExp = GetElement(self.m_root,"txtExp_CellPvpRankResult",WZUILabelTTF)
    txtExp:setText(segmentExp.."/"..tabInfo.score)
end

function CellPvpRankResult:_expAni()
    if self.data.score < 0 then
        self:_noExpAni()
        self.m_root:disableSchedule()
        return
    end

    local exp = math.max(math.floor(self.data.score/20),1)
    local tabInfo = GDatatab_rank_segment["id_"..self.curLv]
    local maxScore = tabInfo.score
    if self.leftExp == 0 then
        self.m_root:disableSchedule()
        return
    end

    local addExp = (self.leftExp > exp ) and exp or self.leftExp
    self.leftExp = self.leftExp - addExp
    self.curExp = self.curExp + addExp
    if self.curExp >= maxScore then
        self.curExp = self.curExp - maxScore
        self.curLv = self.curLv + 1
    end
    self:_updateSegmentInfo(self.curLv,self.curExp)
    WZLog("----------------expAni-------------------",exp,addExp,self.leftExp,self.curExp,self.curLv,maxScore)
end

-- 降级时不做动画
function CellPvpRankResult:_noExpAni()
    if self.curExp + self.leftExp < 0 then
        -- 降级
        local curLv = self.curLv - 1
        if curLv <= 1 then curLv = 1 end
        local tabInfo = GDatatab_rank_segment["id_"..curLv]
        local curExp = tabInfo.score + self.curExp + self.leftExp
        self:_updateSegmentInfo(curLv,curExp)
    else
        -- 扣分
        self:_updateSegmentInfo(self.curLv,self.curExp + self.leftExp)
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function CellPvpRankResult:_adaptLanguage_pt()
    local txtDayName = GetElement(self.m_root,"txtDayName_CellPvpRankResult",WZUILabelTTF)
    txtDayName:setFontSize(17)
    txtDayName:setRelativePosition(GlobalMethod:ccp(0.210125,0.65))

    local txtWinName = GetElement(self.m_root,"txtWinName_CellPvpRankResult",WZUILabelTTF)
    txtWinName:setFontSize(17)
    txtWinName:setRelativePosition(GlobalMethod:ccp(0.235,0.395833))

    local txtScoreName = GetElement(self.m_root,"txtScoreName_CellPvpRankResult",WZUILabelTTF)
    txtScoreName:setFontSize(19)

    local txtDay = GetElement(self.m_root,"txtDay_CellPvpRankResult",WZUILabelTTF)
    txtDay:setFontSize(17)
    txtDay:setRelativePosition(GlobalMethod:ccp(0.403125,0.652244))

    local txtWin = GetElement(self.m_root,"txtWin_CellPvpRankResult",WZUILabelTTF)
    txtWin:setFontSize(17)
    txtWin:setRelativePosition(GlobalMethod:ccp(0.5,0.395834))

    local txtScore = GetElement(self.m_root,"txtScore_CellPvpRankResult",WZUILabelTTF)
    txtScore:setFontSize(17)
    txtScore:setRelativePosition(GlobalMethod:ccp(0.60625,0.147436))

    local txtKillWin = GetElement(self.m_root,"txtKillWin_CellPvpRankResult",WZUILabelTTF)
    txtKillWin:setRelativePosition(GlobalMethod:ccp(0.753125,0.395833))
    txtKillWin:setFontSize(17)
end

function CellPvpRankResult:_adaptLanguage_en(  )
    local txtDayName = GetElement(self.m_root,"txtDayName_CellPvpRankResult",WZUILabelTTF)
    txtDayName:setScale(0.7)
    txtDayName:setRelativePosition(GlobalMethod:ccp(0.216375,0.650934))
    local txtDay = GetElement(self.m_root,"txtDay_CellPvpRankResult",WZUILabelTTF)
    txtDay:setScale(0.7)
    txtDay:setRelativePosition(GlobalMethod:ccp(0.4,0.652244))

    local txtWinName = GetElement(self.m_root,"txtWinName_CellPvpRankResult",WZUILabelTTF)
    txtWinName:setScale(0.7)
    txtWinName:setRelativePosition(GlobalMethod:ccp(0.28825,0.395833))
    local txtWin = GetElement(self.m_root,"txtWin_CellPvpRankResult",WZUILabelTTF)
    txtWin:setScale(0.7)
    txtWin:setRelativePosition(GlobalMethod:ccp(0.54375,0.395834))
    local txtKillWin = GetElement(self.m_root,"txtKillWin_CellPvpRankResult",WZUILabelTTF)
    txtKillWin:setScale(0.6)
    txtKillWin:setRelativePosition(GlobalMethod:ccp(0.753125,0.395833))
end

function CellPvpRankResult:_adaptLanguage_vn(  )
    local txtDayName = GetElement(self.m_root,"txtDayName_CellPvpRankResult",WZUILabelTTF)
    --txtDayName:setFontSize(17)
    txtDayName:setRelativePosition(GlobalMethod:ccp(0.210125,0.65))

    local txtWinName = GetElement(self.m_root,"txtWinName_CellPvpRankResult",WZUILabelTTF)
    --txtWinName:setFontSize(16)
    txtWinName:setRelativePosition(GlobalMethod:ccp(0.210125,0.395833))

    local txtScoreName = GetElement(self.m_root,"txtScoreName_CellPvpRankResult",WZUILabelTTF)
    --txtScoreName:setFontSize(19)
    txtWinName:setRelativePosition(GlobalMethod:ccp(0.210125,0.147436))

    local txtDay = GetElement(self.m_root,"txtDay_CellPvpRankResult",WZUILabelTTF)
    -- txtDay:setFontSize(17)
    txtDay:setRelativePosition(GlobalMethod:ccp(0.403125,0.652244))

    local txtWin = GetElement(self.m_root,"txtWin_CellPvpRankResult",WZUILabelTTF)
    txtWin:setFontSize(17)
    txtWin:setRelativePosition(GlobalMethod:ccp(0.5,0.395834))

    local txtScore = GetElement(self.m_root,"txtScore_CellPvpRankResult",WZUILabelTTF)
    txtScore:setFontSize(17)
    txtScore:setRelativePosition(GlobalMethod:ccp(0.60625,0.147436))

    local txtKillWin = GetElement(self.m_root,"txtKillWin_CellPvpRankResult",WZUILabelTTF)
    txtKillWin:setRelativePosition(GlobalMethod:ccp(0.753125,0.395833))
    txtKillWin:setFontSize(17)
end

function CellPvpRankResult:_adaptLanguage_tr(  )
    local txtDayName = GetElement(self.m_root,"txtDayName_CellPvpRankResult",WZUILabelTTF)
    txtDayName:setScale(0.7)
    txtDayName:setRelativePosition(GlobalMethod:ccp(0.23825,0.650934))
    local txtDay = GetElement(self.m_root,"txtDay_CellPvpRankResult",WZUILabelTTF)
    txtDay:setScale(0.7)
    txtDay:setRelativePosition(GlobalMethod:ccp(0.44375,0.652244))

    local txtWinName = GetElement(self.m_root,"txtWinName_CellPvpRankResult",WZUILabelTTF)
    txtWinName:setScale(0.7)
    txtWinName:setRelativePosition(GlobalMethod:ccp(0.30075,0.395833))
    local txtWin = GetElement(self.m_root,"txtWin_CellPvpRankResult",WZUILabelTTF)
    txtWin:setScale(0.7)
    txtWin:setRelativePosition(GlobalMethod:ccp(0.56875,0.395834))
    local txtKillWin = GetElement(self.m_root,"txtKillWin_CellPvpRankResult",WZUILabelTTF)
    txtKillWin:setScale(0.6)
    txtKillWin:setRelativePosition(GlobalMethod:ccp(0.753125,0.395833))
end

-------------------------------------语言适配End--------------------------------------------