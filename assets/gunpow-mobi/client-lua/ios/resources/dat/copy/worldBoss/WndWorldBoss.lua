--WndWorldBoss.lua
--@brief	WndWorldBoss的UI模块
--@date		2015-9-24
--@author	binshao
--@note		世界BOSS窗口模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBoss:onEnter(element)
	self.m_root = element
    --self:createLoading()
    ProtocolProcessorSceneWorldBoss:regAll()
    ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState()
    AdaptLanguage(self)
end

--@brief	打开加载动画
function WndWorldBoss:onEnterTransitionDidFinish(element)
    if self.aniAction then
        WindowManagerAni:createAppearAction(self.m_root,true,nil,self)
    end
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBoss:onExit(element)
    ProtocolProcessorSceneWorldBoss:unregAll()
    self.m_root:disableSchedule()
	self:_unInit()
end

function WndWorldBoss:showWnd(isAction)
    local wnd = WndWorldBoss:createElement()
    WindowManager:addWindow( wnd ,WndWorldBoss,true)
    self.aniAction = isAction
end

-- 关闭按钮回调函数
function WndWorldBoss:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndWorldBoss:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root , self , true)
end

-- 创建加载框
function WndWorldBoss:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(10)
end

-- 关闭加载框
function WndWorldBoss:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

-----------------------------------------------回调start----------------------------------------------------------------
-- 点击说明按键
function WndWorldBoss:onRuleClick( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.WORLD_BOSS_DESC)
end

-- 选择boss1
function WndWorldBoss:onSelBoss1( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndWorldBoss:onSelBoss1")
    local info = self.openInfo[1]
    if not info then return end
    self.selBossId = info.mapId
--    if info.time > 0 then
--        MsgBoxManager:showTipBox(LocalStrings.CLOSE_SCRIPT)
--    else
--        local bossId = GDatatab_world_boss_map["id_"..self.selBossId].id
--        SceneWorldBoss:showInterface(bossId)
--    end


    local bossId = GDatatab_world_boss_map["id_"..self.selBossId].id
    SceneWorldBoss:showInterface(bossId)
end

-- 选择boss2
function WndWorldBoss:onSelBoss2( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndWorldBoss:onSelBoss2")
    local info = self.openInfo[2]
    if not info then return end
    self.selBossId = info.mapId
--    if info.time > 0 then
--        MsgBoxManager:showTipBox(LocalStrings.CLOSE_SCRIPT)
--    else
--        local bossId = GDatatab_world_boss_map["id_"..self.selBossId].id
--        SceneWorldBoss:showInterface(bossId)
--    end
    local bossId = GDatatab_world_boss_map["id_"..self.selBossId].id
    SceneWorldBoss:showInterface(bossId)
end

-----------------------------------------------回调end------------------------------------------------------------------

---------------------------------------------私有方法模块start----------------------------------------------------------

-- 倒计时格式转换
function WndWorldBoss:_timeChangeStyle(time)
    time = math.floor(time)
    local min = math.floor(time/60)
    local sec = math.floor(time-min*60)
    if min < 10 then min = "0"..min end
    if sec < 10 then sec = "0"..sec end
    return min..":"..sec
end

-- 开启倒计时显示
function WndWorldBoss:_timeDownSchedule(element,time)
    local openInfo = self.openInfo
    local isClose = true

    -- 如果当前的都开启，则取消计时器
    for i = 1, #openInfo do
        if openInfo[i].time > 0 then isClose = false end
    end
    if isClose then  self.m_root:disableSchedule() end

    -- 更新倒计时
    for i = 1, #openInfo do
        openInfo[i].time = openInfo[i].time - 1
        WZLog("-----------------------8520-----------------------",openInfo[i].time)
        local txt = GetElement(self.m_root,"txtTimeDown"..i.."_WndWorldBoss",WZUILabelTTF)
        if openInfo[i].time <= 300 and openInfo[i].time > 0 then
            txt:setVisible(true)
            local str = self:_timeChangeStyle(openInfo[i].time)
            txt:setText(LocalStrings.WORLD_BOSS_OPEN_TIME_DOWN..str)
        else
            if openInfo[i].time == 0 then
                --再次获取房间状态
                ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetOpenState()
            end
            txt:setVisible(false)
        end
    end
end

-- 初始化boss主界面
function WndWorldBoss:_initOpenDesc()
    --self:closeLoading()
    local openInfo = self.openInfo
    for i = 1, 2 do
        local btnBoss = GetElement(self.m_root,"btnSelBoss"..i.."_WndWorldBoss",WZUIButton)
        local txt = GetElement(self.m_root,"txtOpen"..i.."_WndWorldBoss",WZUIFreeTextBox)
        if openInfo[i] then
            local data = GDatatab_world_boss_map["id_"..openInfo[i].mapId]
            -- 开启时间
            local start_time,end_time = data.start_time,data.end_time
            txt:setShowText(string.format(LocalStrings.WORLD_BOSS_OPEN_TIME,start_time,end_time))
            --btnBoss:setTouchEnable(openInfo[i].state)

            -- 注册倒计时
            --self.m_root:enableSchedule("_timeDownSchedule",1)
        else
            txt:setShowText(LocalStrings.WORLD_BOSS_NOT_OPEN)
            btnBoss:setTouchEnable(false)
        end
    end
end

---------------------------------------------私有方法模块End------------------------------------------------------------
----------------------------------------------语言适配Begin-----------------------------------------------------------------
function WndWorldBoss:_adaptLanguage_en(  )
    if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 then
        for i=1,2 do
            GetElement(self.m_root,"txtTimeDown"..i.."_WndWorldBoss",WZUILabelTTF):setVisible(false)
            GetElement(self.m_root,"txtOpen"..i.."_WndWorldBoss",WZUIFreeTextBox):setVisible(false)
        end
    end
end

function WndWorldBoss:_adaptLanguage_pt(  )
    if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 then
        for i=1,2 do
            GetElement(self.m_root,"txtTimeDown"..i.."_WndWorldBoss",WZUILabelTTF):setVisible(false)
            GetElement(self.m_root,"txtOpen"..i.."_WndWorldBoss",WZUIFreeTextBox):setVisible(false)
        end
    end
end

function WndWorldBoss:_adaptLanguage_cn(  )
    if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 then
        for i=1,2 do
            GetElement(self.m_root,"txtTimeDown"..i.."_WndWorldBoss",WZUILabelTTF):setVisible(false)
            GetElement(self.m_root,"txtOpen"..i.."_WndWorldBoss",WZUIFreeTextBox):setVisible(false)
        end
    end
end

function WndWorldBoss:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtOpen1_WndWorldBoss",WZUIFreeTextBox):setScale(0.8)
    GetElement(self.m_root,"txtOpen2_WndWorldBoss",WZUIFreeTextBox):setScale(0.8)
end
----------------------------------------------语言适配End----------------------------------------------------