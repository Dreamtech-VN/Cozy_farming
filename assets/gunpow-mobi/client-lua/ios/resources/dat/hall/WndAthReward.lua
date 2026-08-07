--WndAthReward.lua
--@brief	WndAthReward的UI模块
--@date		2015-6-6
--@author	binshao
--@note		竞技场奖励

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthReward:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    SceneHall:goalRedPointUpdate()
    self:_updateCheckBox(1)
    self:_updateReward()
end

--@brief    弹窗动画完成后的回调
function WndAthReward:actionCallback(element, data)
--    ProtocolProcessorSceneHall:send_ROOM_GetTournamentAim(0)
end

--@brief onEnter函数执行完成回调
function WndAthReward:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthReward:onExit(element)
    self:_unInit()
end

--@brief	关闭整个窗口的动画效果
function WndAthReward:onReturnActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndAthReward , true)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndAthReward:onBtnReturn( element )
	WZLog("sun---WndAthReward:onBtnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end

function WndAthReward:onCheckBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_updateCheckBox(tag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------

-- 更新段位奖励
function WndAthReward:_updateReward()
    self:createReward()
    self:_initRewardData()
end

-- 更新每日目标
function WndAthReward:_updateGoal()
    self:createGoal()
    self:_initGoalData()
end

-- 切换目标或奖励
function WndAthReward:_updateCheckBox(tag)
    local tabR = GetElement(self.m_root,"tabReward_WndAthReward",WZUITableContainer)
    local tabG = GetElement(self.m_root,"tabGoal_WndAthReward",WZUITableContainer)
    local tab = {tabG,tabR}
    for i = 1, 2 do
        -- 容器可见
        local conCheck = GetElement(self.m_root,"conCheck"..i.."_WndAthReward",WZUIContainer)
        conCheck:setVisible(i == tag)

        -- tab可见
        tab[i]:setVisible(i == tag)

        -- 底部说明
        local conDi = GetElement(self.m_root,"conDi"..i.."_WndAthReward",WZUIContainer)
        conDi:setVisible(i == tag)
    end

    -- 标题
    local str = {LocalStrings.ATH_GOAL,LocalStrings.ATH_DAILY_REWARD}
    local txtTitle = GetElement(self.m_root,"txtTitle_WndAthReward",WZUILabelTTF)
    txtTitle:setText(str[tag])
end

-- 创建段位奖励列表
function WndAthReward:createReward()
    local tabR = GetElement(self.m_root,"tabReward_WndAthReward",WZUITableContainer)
    tabR:cleanTable()

    -- 本地默认最大为100,奖励为-1的不显示
    local index = 0
    for i = 1, 100 do
        local data = GDatatab_integral["id_"..i]
        if data then
            if data.reward ~= -1 then
                local cell,tcell = CellAthReward:createElement()
                cell:setTag(index)
                tabR:setCellElement(cell)
                tcell:SetData(data)
                index = index + 1
            end
        else
            break
        end
    end
end

-- 奖励底部描述
function WndAthReward:_initRewardData()
    local txtSend = GetElement(self.m_root,"txtRewardSend_WndAthReward",WZUIFreeTextBox)
    txtSend:setShowText(string.format(LocalStrings.ATH_REWARD_SEND," 21:00 "))
end

-- 创建每日目标列表
function WndAthReward:createGoal()
    if not self.goalData.info then return end
    local tabR = GetElement(self.m_root,"tabGoal_WndAthReward",WZUITableContainer)
    tabR:cleanTable()

    for i = 1, #self.goalData.info do
        if self.goalData.info[i] then
            local cell,tcell = CellAthGoal:createElement()
            cell:setTag(i-1)
            tabR:setCellElement(cell)
            tcell:setData(self.goalData.info[i])
            self:setGoalCell(i,cell,tcell)
        end
    end
end

-- 初始化个人数据
function WndAthReward:_initGoalData()
    local fight = GetElement(self.m_root,"txtFight_WndAthReward",WZUILabelTTF)
    fight:setText(string.format(LocalStrings.QUALIFYING_DAILY,self.goalData.fightNum,self.goalData.winNum))
	if ProjConfig.LANGUAGE == "en" then
		fight:setText(string.format(LocalStrings.QUALIFYING_DAILY,self.goalData.winNum,self.goalData.fightNum))
	end

    local send = GetElement(self.m_root,"txtSend_WndAthReward",WZUIFreeTextBox)
    send:setShowText(LocalStrings.ATH_DESC_11)
end

-- 更新领取奖励
function WndAthReward:updateCellList(rewardId,reward)
    WZLog("----------------get reward----------------",rewardId)
    local index = self:findIndex(rewardId)
    local tcell = self.goalCell[index].tcell
    tcell:rewardGet()

    local id,cnt = SplitItemString(reward)
    WndRewardShow:showById(id,cnt)

    SceneHall:goalRedPointUpdate()
end
-------------------------------------私有方法模块End--------------------------------------

-------------------------------------------语言适配Begin-------------------------------------------
function WndAthReward:_adaptLanguage_en()
    local txt1 = GetElement(self.m_root,"txt1_WndAthReward",WZUILabelTTF)
    txt1:setScale(0.9)
    txt1:setDimensions(GlobalMethod:CCSize(80,80))
    local txt3 = GetElement(self.m_root,"txt3_WndAthReward",WZUILabelTTF)
    txt3:setScale(0.9)
    txt3:setDimensions(GlobalMethod:CCSize(80,80))
    local txt2 = GetElement(self.m_root,"txt2_WndAthReward",WZUILabelTTF)
    txt2:setScale(0.9)
    txt2:setDimensions(GlobalMethod:CCSize(80,80))
    local txt4 = GetElement(self.m_root,"txt4_WndAthReward",WZUILabelTTF)
    txt4:setScale(0.9)
    txt4:setDimensions(GlobalMethod:CCSize(80,80))
    
    GetElement(self.m_root,"txtSend_WndAthReward",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.65,0.5))
end

function WndAthReward:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txt1_WndAthReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt3_WndAthReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt2_WndAthReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt4_WndAthReward",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    
    local txtSend = GetElement(self.m_root,"txtSend_WndAthReward",WZUIFreeTextBox)
    txtSend:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
    GetElement(self.m_root,"txtRewardSend_WndAthReward",WZUIFreeTextBox):setScale(0.8)
    GetElement(self.m_root,"txtFight_WndAthReward",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.5))
end

function WndAthReward:_adaptLanguage_th()
    GetElement(self.m_root,"txt1_WndAthReward",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txt3_WndAthReward",WZUILabelTTF):setFontSize(16)
end

function WndAthReward:_adaptLanguage_vn()
    WZLog("WndAthReward:_adaptLanguage_vn")
    for i=1,6 do
        local txt = GetElement(self.m_root,"txt" .. i ..  "_WndAthReward",WZUILabelTTF)
        txt:setFontSize(16)
        if i == 3 or i == 1 then
            txt:setDimensions(GlobalMethod:CCSize(90,0))
        end
    end

    GetElement(self.m_root,"txtFight_WndAthReward",WZUILabelTTF):setFontSize(18)
    
end

function WndAthReward:_adaptLanguage_tr(  )
    local txtFight = GetElement(self.m_root,"txtFight_WndAthReward",WZUILabelTTF)
    txtFight:setRelativePosition(GlobalMethod:ccp(0.03,0.5))

    local txtSend = GetElement(self.m_root,"txtSend_WndAthReward",WZUIFreeTextBox)
    txtSend:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    txtSend:setScale(0.9)

    local txt1 = GetElement(self.m_root,"txt1_WndAthReward",WZUILabelTTF)
    txt1:setScale(0.8)
    txt1:setDimensions(GlobalMethod:CCSize(80))
    local txt3 = GetElement(self.m_root,"txt3_WndAthReward",WZUILabelTTF)
    txt3:setScale(0.8)
    txt3:setDimensions(GlobalMethod:CCSize(80))
    local txt2 = GetElement(self.m_root,"txt2_WndAthReward",WZUILabelTTF)
    txt2:setScale(0.8)
    txt2:setDimensions(GlobalMethod:CCSize(80))
    local txt4 = GetElement(self.m_root,"txt4_WndAthReward",WZUILabelTTF)
    txt4:setScale(0.8)
    txt4:setDimensions(GlobalMethod:CCSize(80))
end

function WndAthReward:_adaptLanguage_es(  )
    for i=1,6 do
        local txt = GetElement(self.m_root,"txt"..i.."_WndAthReward",WZUILabelTTF)
        txt:setDimensions(GlobalMethod:CCSize(100,0))
        txt:setFontSize(16)
    end
end
-------------------------------------------语言适配End---------------------------------------------