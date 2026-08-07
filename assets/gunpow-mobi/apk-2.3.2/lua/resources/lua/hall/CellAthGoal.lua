--CellAthGoal.lua
--@brief	CellAthGoal的UI模块
--@date		2016-1-22
--@author	binshao
--@note		竞技场每日目标cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthGoal:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthGoal:onExit(element)
    WZLog("-------------CellAthGoal:onExit--------------")
	self:_unInit()
end

-- 加载数据
function CellAthGoal:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellAthGoal")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief 点击物品图标弹出信息框
function CellAthGoal:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndAthReward.m_root,1,self.data.reward[tag],false,nil,nil,other)
end

function CellAthGoal:onGet()
    WZLog("---------------get---------------",self.data)
    WZLog("---------------get---------------",self.data.rewardId)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    ProtocolProcessorSceneHall:send_ROOM_ReceiveTournamentAim(self.data.rewardId )
end

-- 设置玩家信息
function CellAthGoal:_update()
    local data = self.data
    local rewardId = data.rewardId
    local state = data.state

    local rewardData = GDatatab_rank_sports["id_"..rewardId]

    -- 目标
    local joinStr = {LocalStrings.RANK_BOX_DESC1,LocalStrings.ATH_GOAL_DESC1,LocalStrings.ATH_GOAL_DESC3,LocalStrings.ATH_GOAL_DESC5}
    local WinStr = {LocalStrings.RANK_BOX_DESC2,LocalStrings.ATH_GOAL_DESC2,LocalStrings.ATH_GOAL_DESC4,LocalStrings.ATH_GOAL_DESC6}
    local txtGoal =  GetElement(self.m_root,"txtGoal_CellAthGoal",WZUILabelTTF)
    if rewardData.sub_type == 0 then
        if rewardData.type == 1 then
            txtGoal:setText(string.format(joinStr[rewardData.type],rewardData.win_num))
        else
            txtGoal:setText(string.format(joinStr[rewardData.type]))
        end
    else
        if rewardData.type == 1 then
            txtGoal:setText(string.format(WinStr[rewardData.type],rewardData.win_num))
        else
            txtGoal:setText(string.format(WinStr[rewardData.type]))
        end
    end

    -- 奖励
    local reward = rewardData.reward
    self.data.reward = reward
    local cnt = #reward > 5 and 5 or #reward
    for i = 1, cnt do
        local conR = GetElement(self.m_root,"conItem"..i.."_CellAthGoal",WZUIContainer)

        -- 为了显示物品，构造部分道具的数据
        local key = "id_"..reward[i][1]
        reward[i].basicInfo = GDatatab_item[key]
        local count = reward[i][2]
        reward[i].lastNum = count

        local cell,tcell = CellGoodItem:createElement()
        conR:addChild(cell)
        cell:setTag(i)
        tcell:setCellGoodItem(reward[i],2)
        tcell:setItemClickFun(self,self.onIconClick)
    end

    -- 领取状态
    local conGet = GetElement(self.m_root,"conGet_CellAthGoal",WZUIContainer)
    local conNot = GetElement(self.m_root,"conNotGet_CellAthGoal",WZUIContainer)
    local txtState = GetElement(self.m_root,"txtState_CellAthGoal",WZUILabelTTF)

    local fightCnt = {data.fightNum,data.mfightNum,data.gfightNum,data.ffightNum}
    local winCnt = {data.winNum,data.mwinNum,data.gwinNum,data.fwinNum}
    if state == -1 then
        -- 不能领取，根据配置来显示，如果是战斗次数的显示战斗次数进程，否则显示胜利次数进程
        if rewardData.sub_type == 0 then
            txtState:setText(fightCnt[rewardData.type].."/"..rewardData.win_num)
        elseif rewardData.sub_type == 1 then
            txtState:setText(winCnt[rewardData.type].."/"..rewardData.win_num)
        end
        conGet:setVisible(false)
        conNot:setVisible(true)
    elseif state == 0 then
        -- 可领取,但是未领取，显示按键
        conGet:setVisible(true)
        conNot:setVisible(false)
    elseif state == 1 then
        -- 已经领取，显示已经领取
        txtState:setText(LocalStrings.ACTIVE_GET)
        txtState:setColor(GlobalMethod:ccc3(79,60,48))
        conGet:setVisible(false)
        conNot:setVisible(true)
    end
end

-- 领取成功后改变状态
function CellAthGoal:rewardGet()
    -- 领取状态
    local conGet = GetElement(self.m_root,"conGet_CellAthGoal",WZUIContainer)
    local conNot = GetElement(self.m_root,"conNotGet_CellAthGoal",WZUIContainer)
    conGet:setVisible(false)
    conNot:setVisible(true)

    local txtState = GetElement(self.m_root,"txtState_CellAthGoal",WZUILabelTTF)
    txtState:setText(LocalStrings.ACTIVE_GET)
    txtState:setColor(GlobalMethod:ccc3(79,60,48))
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------

---------------------------------语言适配Begin----------------------------------------------
function CellAthGoal:_adaptLanguage_en(  )
    local txtGoal = GetElement(self.m_root,"txtGoal_CellAthGoal",WZUILabelTTF)
    txtGoal:setDimensions(GlobalMethod:CCSize(150))
end

function CellAthGoal:_adaptLanguage_vn(  )
    local txtGoal = GetElement(self.m_root,"txtGoal_CellAthGoal",WZUILabelTTF)
    txtGoal:setDimensions(GlobalMethod:CCSize(150))
end

function CellAthGoal:_adaptLanguage_pt(  )
    local txtGoal = GetElement(self.m_root,"txtGoal_CellAthGoal",WZUILabelTTF)
    txtGoal:setDimensions(GlobalMethod:CCSize(150))
end

function CellAthGoal:_adaptLanguage_tr(  )
    local txtGoal = GetElement(self.m_root,"txtGoal_CellAthGoal",WZUILabelTTF)
    txtGoal:setDimensions(GlobalMethod:CCSize(150))
end
---------------------------------语言适配End------------------------------------------------