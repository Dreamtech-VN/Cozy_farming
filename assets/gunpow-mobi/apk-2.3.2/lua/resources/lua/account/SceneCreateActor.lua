--SceneCreateActor.lua
--@brief	SceneCreateActor的UI模块
--@date		2015-8-14
--@author	binshao
--@note		角色创建界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCreateActor:onEnter(element)
	self.m_root = element
    WZLog("----------------curDefault Sex-------------",self.defaultSex)
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_CREATE_ACTOR)
    self:_initCheckSex(self.defaultSex)

    self:_setEditBoxPlaceHolder()
    --self:_initBoyAndGirl(self.defaultSex)

    self:_initMovePosition(true)
    if whetherCloseCreateRole() then
        MsgBoxManager:showConfirmBox(LocalStrings.CLOSE_CREATEROLE or "", self, self.onBackToSelectLogin_SceneCreateActor, MSGBOXLEVEL_HIGH, nil,true) 
    end
    --qq大厅会有个倒计时自动创角
    if isChannelPC() and IPDhttpServer.isNewUser == true then
        self.isCallOnBtnEnterGameClicked = false
        local txtTime = GetElement(self.m_root,"txtTime_SceneCreateActor",WZUILabelTTF)
        if txtTime then
            self.preActorName = ""     -- qq大厅自动创角记录角色名是否发生变化，无变化限定时长则开始倒计时
            local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
            if editInputName then
                self.preActorName = editInputName:getText()
            end
            self.autoCreateTime = 30
            self.autoCreateColdTime = 5
            --txtTime:setVisible(true)
            txtTime:setText(""..self.autoCreateTime.."s")
            txtTime:enableSchedule("scheduleAutoCreateActor",1)
        end
    end

    if isYLGYLoginChannel() and IPDhttpServer.isNewUser == true then
        self.isCallOnBtnEnterGameClicked = false
        local txtTime = GetElement(self.m_root,"txtTime_SceneCreateActor",WZUILabelTTF)
        if txtTime then
            txtTime:enableSchedule("scheduleAutoCreateActor2",1)
        end
    end
end

--@brief    自动创角
function SceneCreateActor:scheduleAutoCreateActor2(element,dt)
    if self:_checkName() then
        element:disableSchedule()
        --点击进入游戏
        local btnStartGame = GetElement(self.m_root,"btnStartGame_CreateActor",WZUIButton)
        if btnStartGame then
            self:onBtnEnterGameClicked(btnStartGame)
        end
    else
        self:senderRandomNameProtocol()
    end
end

--@brief    qq大厅自动创角倒计时
function SceneCreateActor:scheduleAutoCreateActor(element,dt)    
    local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
    if editInputName and element then
        if self.preActorName == editInputName:getText() then
            if self.autoCreateColdTime > 0 then
                self.autoCreateColdTime = self.autoCreateColdTime - 1
            end
            if self.autoCreateColdTime <= 0 then
                self.autoCreateTime = self.autoCreateTime - 1
                element:setText(""..self.autoCreateTime.."s")
                element:setVisible(true)
                if self.autoCreateTime < 1 then
                    self.autoCreateTime = 0
                    element:setVisible(false)
                    if self:_checkName() then
                        element:disableSchedule()
                        --点击进入游戏
                        local btnStartGame = GetElement(self.m_root,"btnStartGame_CreateActor",WZUIButton)
                        if btnStartGame then
                            self:onBtnEnterGameClicked(btnStartGame)
                        end
                    else
                        self:senderRandomNameProtocol()
                    end
                end
            end
        else
            self.preActorName = editInputName:getText()
            self.autoCreateColdTime = 5
        end
        WZLog("SceneCreateActor:scheduleAutoCreateActor time === ",self.autoCreateColdTime, self.autoCreateTime)
        WZLog("SceneCreateActor:scheduleAutoCreateActor text === ",self.preActorName, editInputName:getText())
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCreateActor:onExit(element)
	self:_unInit()
end

--@brief    删除多余的资源
function SceneCreateActor:onEnterTransitionDidFinish(element)
      if PassportSdkManager:getLogoutState() then
        PassportSdkManager:setLogoutState(false)
        WndLoginSelect:loginOutGame()
        return
    end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_enterCreateActorUI)
    if PassportSdkManager.postGameInfoBeiMei then
        PassportSdkManager:postGameInfoBeiMei("Register","success")
    end
end

function SceneCreateActor:showSceneUI(defaultSex)
    local sceneCreateActor = SceneCreateActor:createElement()
    replaceScene(sceneCreateActor)
    self.defaultSex = defaultSex
end

-- 返回服务器选择界面
function SceneCreateActor:onBackToSelectLogin_SceneCreateActor()    
    WZLog("SceneSelectActor:onBackToSelectLogin_SceneCreateActor")
    if PassportSdkManager.logout then
        PassportSdkManager:logout()
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneLoginMgr:showScene(2)
end

-- 点击随机名字按键
function SceneCreateActor:onBtnRandomNameClicked(element)
    WZLog("SceneCreateActor:onBtnRandomNameClicked")
    if self.randomTime <= 0 then
        self.randomTime = 0.8
        element:enableSchedule("schduleNameRandom",0.1)
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        self:senderRandomNameProtocol()
    end
end

-- 控制名字随机频率
function SceneCreateActor:schduleNameRandom(element,time)
    self.randomTime = self.randomTime - time
    if self.randomTime <= 0 then
        self.randomTime = 0
        element:disableSchedule()
    end
end

-- 随机名字
function SceneCreateActor:senderRandomNameProtocol()
	WZLog("SceneCreateActor:senderRandomNameProtocol")
	ProtocolProcessorAccount:send_ACCOUNT_GetRandomName(self.defaultSex)
end

-- 进入游戏回调
function SceneCreateActor:onBtnEnterGameClicked(element)
	WZLog("SceneCreateActor:onBtnEnterGameClicked")
    -- 发送账号信息
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.isCallOnBtnEnterGameClicked = true
    local isOKName = self:_checkName()
    if isOKName and tonumber(self.btnTime) <= 0 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickCreateActor)
        self.btnTime = 2
        element:enableSchedule("btnTimeSchedule",0.1)
        self:_playEnterAni()
        --qq大厅新用户撤销计时器
        if (isChannelPC() or isYLGYLoginChannel()) and IPDhttpServer.isNewUser == true then
            local txtTime = GetElement(self.m_root,"txtTime_SceneCreateActor",WZUILabelTTF)
            if txtTime then
                txtTime:disableSchedule()
            end
        end
        if g_nCreateRoleNum == 0 then 
            if PassportSdkManager and PassportSdkManager.postGameInfoVn then
                PassportSdkManager:postGameInfoVn("first_role_created","")--创角
            end
        end
    elseif not isOKName then
        --qq大厅新用户撤销计时器
        if (isChannelPC() or isYLGYLoginChannel()) and IPDhttpServer.isNewUser == true then
            self:senderRandomNameProtocol()
        end
    end
end

-- 进入游戏按键频率控制
function SceneCreateActor:btnTimeSchedule(element,dt)
    self.btnTime = self.btnTime - dt
    if self.btnTime < 0 then
        self.btnTime = 0
        element:disableSchedule()
    end
end


function SceneCreateActor:sendEnterGameMsg()
    local area = WGameCmUtil:getDeviceInfo()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_selectCharaSendCreate)
    ProtocolProcessorAccount:send_ACCOUNT_CreateRoleActor(self.m_actorName, self.defaultSex, area)
    self:startLoading()
end


-- 输入名字开始
function SceneCreateActor:onEditNameBegin()
    WZLog("SceneCreateActor:onEditNameBegin")
    self.autoCreateColdTime = 5
end

-- 输入名字完成,如果未空，这默认
function SceneCreateActor:onEditNameEnd()
	WZLog("SceneCreateActor:onEditNameEnd")
    local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
	if editInputName then
		if editInputName:getText() == "" then self:_setEditBoxPlaceHolder() end
	end
end

-- 设置名字
function SceneCreateActor:setEditInputNameText(text)
	WZLog("SceneCreateActor:setEditInputNameText",text)
    self.m_actorName = text
	local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
	editInputName:setText(text)
    --qq大厅会有个倒计时自动创角
    if (isChannelPC() or isYLGYLoginChannel()) and IPDhttpServer.isNewUser == true then
        if self:_checkName() then
            if self.isCallOnBtnEnterGameClicked == true then
                WZLog("SceneCreateActor:setEditInputNameText enterGame")
                self.isCallOnBtnEnterGameClicked = false
                --点击进入游戏
                local btnStartGame = GetElement(self.m_root,"btnStartGame_CreateActor",WZUIButton)
                if btnStartGame then
                    self:onBtnEnterGameClicked(btnStartGame)
                end
            end
        else
            WZLog("SceneCreateActor:setEditInputNameText reGetRandomName")
            --delayTimer(SceneCreateActor.senderRandomNameProtocol, 5)
            local btnRandomName = GetElement(self.m_root,"btnRandomName_CreateAc",WZUIButton)
            if btnRandomName then
                self.randomTime = 0
                self:onBtnRandomNameClicked(btnRandomName)
                --btnRandomName:enableSchedule("scheduleSenderRandomNameProtocol",1)
            end
        end
    end
end

function SceneCreateActor:scheduleSenderRandomNameProtocol(element,dt)    
    -- if isChannelPC() and IPDhttpServer.isNewUser == true then
    -- end    
    WZLog("SceneCreateActor:scheduleSenderRandomNameProtocol disableSchedule")
    element:disableSchedule()
    self:senderRandomNameProtocol()
end

-- 加载圈
function SceneCreateActor:startLoading()
    if not self.m_nLoadingID then
	    self.m_nLoadingID = MsgBoxManager:showLoadingBox(20,self,self.finishedLoading)
    end
end

-- 关闭加载圈
function SceneCreateActor:finishedLoading()
    if self.m_nLoadingID then
	    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingID)
        self.m_nLoadingID = nil
    end
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 设置默认的提示
function SceneCreateActor:_setEditBoxPlaceHolder()
	local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
	if editInputName then editInputName:setPlaceHolder(LocalStrings.PLEASE_INPUT_ACTORNAME) end
end

-- c1 为字符个数， c2为汉字个数(一个汉字3个字符)
-- x+y = len1 ,x + 3y = len2
function SceneCreateActor:_getNameCnt(txtName)
    local len1 = ChineseStringLen(txtName)
    local len2 = string.len(txtName)

    local c2 = (len2-len1)/2
    local c1 = len1 - c2
    local c = c1 + 2*c2
    WZLog("------------------len-----------------",len1,len2,c1,c2,c)

    return c
end

function SceneCreateActor:_checkName()
    local editInputName = GetElement(self.m_root,"editInputName_CreateActor",WZUIEditBox)
    local txtName = editInputName:getText()

    -- 空或者不是字符串
    if type(txtName) ~= "string" or "" == txtName then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_INPUT_ACTORNAME, nil, nil, nil, nil)
        return false
    end

    -- 不能存在空格，长度不超过6个字符
    local spaceName = string.match(txtName," ")
    local nameLen = self:_getNameCnt(txtName)
    local spaceCnt = 0  -- 空格数量
    if spaceName  then  spaceCnt = ChineseStringLen(spaceName)  end
    if spaceCnt > 0 then
        MsgBoxManager:showTipBox(LocalStrings.ACTOR_NAME_ERROR)
        return false
    elseif nameLen > 12 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.ACTOR_MAX_NAME,12))
        return false
    end
    self.m_actorName = editInputName:getText()
    
    local _, isMingan = CheckYellow(self.m_actorName)
    if isMingan then
        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
        return false
    end

    return true
end


----------------------------------------------------动画----------------------------------------------------------------

---- 动画基本参数
--local MAX_SCALE,MIN_SCALE = 1, 0.3      -- 缩放比
--local MAX_POS_X,MAX_POS_Y = 0.38,0.45   -- 最大的相对位置
--local MIN_POS_X,MIN_POS_Y = 0.8,0.5     -- 最小的相对位置
--local MAX_OPACITY,MIN_OPACITY = 255,150 -- 大小的透明度
--local ANI_TIME = 0.5
--
--local L_POS_X,L_POS_Y = -0.2,0,5        -- 左边位置
--local R_POX_X,R_POX_Y = 0.8,0.5         -- 右边位置
--
---- 控制点击频率，动画完成才能点击
--function SceneCreateActor:_btnTimeOut(element,time)
--    if self.btnTime > 0 then
--        self.btnTime = self.btnTime - time
--        self.btnClick = false
--    else
--        self.btnTime = 0
--        self.btnClick = true
--        self.m_root:disableSchedule()
--        self:aniAndPicChange(true)
--
--        for i = 1, 2 do
--            local check = GetElement(self.m_root, "checkSex"..i.."_SceneCreateActor", WZUICheckBox)
--            check:setTouchEnable(true)
--        end
--    end
--end
--
---- 图片和动画相互切换
--function SceneCreateActor:aniAndPicChange(isEnd)
--    local conBoy = GetElement(self.m_root,"conBoyAni_SceneCreateActor",WZUIContainer)
--    local conGirl = GetElement(self.m_root,"conGirlAni_SceneCreateActor",WZUIContainer)
--
--    if isEnd then
--        if self.defaultSex == 1 then
--            conBoy:setVisible(false)
--            conGirl:setVisible(true)
--        else
--            conBoy:setVisible(true)
--            conGirl:setVisible(false)
--        end
--    else
--        if self.defaultSex == 1 then
--            conBoy:setVisible(true)
--            conGirl:setVisible(true)
--        else
--            conBoy:setVisible(true)
--            conGirl:setVisible(true)
--        end
--    end
--end
--
--
---- 滑动改变角色
--function SceneCreateActor:OnChangeRole(direction)
--    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    if not self.btnClick then return end
--    local conBoy = GetElement(self.m_root,"conBoyAni_SceneCreateActor",WZUIContainer)
--    local spineBoy = GetElement(self.m_root,"aniBoy_SceneCreateActor",WZUISpine)
--    local conGirl = GetElement(self.m_root,"conGirlAni_SceneCreateActor",WZUIContainer)
--    local spineGirl = GetElement(self.m_root,"aniGirlAni_SceneCreateActor",WZUISpine)
--    if self.defaultSex == 0 then
--        if direction == "left" then
--            self:_leftAniAction(conBoy,spineBoy,false)
--            self:_leftAniAction(conGirl,spineGirl,true)
--        elseif direction == "right" then
--            self:_rightAniAction(conBoy,spineBoy,false)
--            self:_rightAniAction(conGirl,spineGirl,true)
--        end
--        conBoy:setZOrder(10)
--        conGirl:setZOrder(200)
--        self.defaultSex = 1
--        --SoundManager:playEffectSound(SoundDefine.E_S_CREATE_NV)
--    else
--        if direction == "left" then
--            self:_leftAniAction(conBoy,spineBoy,true)
--            self:_leftAniAction(conGirl,spineGirl,false)
--        elseif direction == "right" then
--            self:_rightAniAction(conBoy,spineBoy,true)
--            self:_rightAniAction(conGirl,spineGirl,false)
--        end
--        conBoy:setZOrder(200)
--        conGirl:setZOrder(10)
--        self.defaultSex = 0
--        --SoundManager:playEffectSound(SoundDefine.E_S_CREATE_NAN)
--    end
--    self:senderRandomNameProtocol()
--    self.btnTime = ANI_TIME
--    self.m_root:enableSchedule("_btnTimeOut",0)
--    self:aniAndPicChange(false)
--end
--
--
---- 人物滑动动画
---- con 容器
---- spine spine 动画
---- direction 移动方向
---- isBig 变大
--function SceneCreateActor:_leftAniAction(con,spine,isBig)
--    local aniTime = ANI_TIME
--    local addAx,addAy = 0.05,0.3
--    local addBx,addBy = 0.2,0.25
--
--    local curScale = isBig and MAX_SCALE or MIN_SCALE
--    local curFade = isBig and MAX_OPACITY or MIN_OPACITY
--
--    -- 变大的曲线
--    local maxEndPos = GlobalMethod:ccp(MAX_POS_X,MAX_POS_Y)
--    local maxControlA = GlobalMethod:ccp(MIN_POS_X-addAx,MIN_POS_Y-addAy)
--    local maxControlB = GlobalMethod:ccp(MIN_POS_X-addBx,MIN_POS_Y-addBy)
--
--    -- 变小的曲线
--    local minEndPos = GlobalMethod:ccp(MIN_POS_X,MIN_POS_Y)
--    local minControlA = GlobalMethod:ccp(MAX_POS_X+addAx,MAX_POS_Y+addAy)
--    local minControlB = GlobalMethod:ccp(MAX_POS_X+addBx,MAX_POS_Y+addBy)
--
--    local bezierTo =  WZUIActionBezierTo:create()
--    bezierTo:setDuration(aniTime)
--    if isBig then
--        bezierTo:setPositionEnd(maxEndPos)
--        bezierTo:setPositionControlA(maxControlA)
--        bezierTo:setPositionControlB(maxControlB)
--    else
--        bezierTo:setPositionEnd(minEndPos)
--        bezierTo:setPositionControlA(minControlA)
--        bezierTo:setPositionControlB(minControlB)
--    end
--
--    local scaleTo = WZUIActionScaleTo:create()
--    scaleTo:setDuration(aniTime)
--    scaleTo:setScaleX(curScale)
--    scaleTo:setScaleY(curScale)
--
--    local spawn = WZUIActionSpawn:create()
--    spawn:setChildAction(bezierTo)
--    spawn:setChildAction(scaleTo)
--    con:runUIAction(spawn)
--
--    local fadeTo =  WZUIActionFadeTo:create()
--    fadeTo:setOpacity(curFade)
--    fadeTo:setDuration(aniTime)
--    spine:runUIAction(fadeTo)
--end
--
--
---- 人物滑动动画
---- con 容器
---- spine spine 动画
---- direction 移动方向
---- isBig 变大
--function SceneCreateActor:_rightAniAction(con,spine,isBig)
--    local aniTime = ANI_TIME
--    local addAx,addAy = 0.05,0.3
--    local addBx,addBy = 0.2,0.25
--
--    local curScale = isBig and MAX_SCALE or MIN_SCALE
--    local curFade = isBig and MAX_OPACITY or MIN_OPACITY
--
--    -- 变大的曲线
--    local maxEndPos = GlobalMethod:ccp(MAX_POS_X,MAX_POS_Y)
--    local maxControlA = GlobalMethod:ccp(MIN_POS_X-addAx,MIN_POS_Y+addAy)
--    local maxControlB = GlobalMethod:ccp(MIN_POS_X-addBx,MIN_POS_Y+addBy)
--
--    -- 变小的曲线
--    local minEndPos = GlobalMethod:ccp(MIN_POS_X,MIN_POS_Y)
--    local minControlA = GlobalMethod:ccp(MAX_POS_X+addAx,MAX_POS_Y-addAy)
--    local minControlB = GlobalMethod:ccp(MAX_POS_X+addBx,MAX_POS_Y-addBy)
--
--    local bezierTo =  WZUIActionBezierTo:create()
--    bezierTo:setDuration(aniTime)
--    if  isBig then
--        bezierTo:setPositionEnd(maxEndPos)
--        bezierTo:setPositionControlA(maxControlA)
--        bezierTo:setPositionControlB(maxControlB)
--    else
--        bezierTo:setPositionEnd(minEndPos)
--        bezierTo:setPositionControlA(minControlA)
--        bezierTo:setPositionControlB(minControlB)
--    end
--
--    local scaleTo = WZUIActionScaleTo:create()
--    scaleTo:setDuration(aniTime)
--    scaleTo:setScaleX(curScale)
--    scaleTo:setScaleY(curScale)
--
--    local spawn = WZUIActionSpawn:create()
--    spawn:setChildAction(bezierTo)
--    spawn:setChildAction(scaleTo)
--    con:runUIAction(spawn)
--
--    local fadeTo =  WZUIActionFadeTo:create()
--    fadeTo:setOpacity(curFade)
--    fadeTo:setDuration(aniTime)
--    spine:runUIAction(fadeTo)
--end
--
--
---- 根据性别初始化角色
--function SceneCreateActor:_initBoyAndGirl(sex)
--    local conBoy = GetElement(self.m_root,"conBoyAni_SceneCreateActor",WZUIContainer)
--    local spineBoy = GetElement(self.m_root,"aniBoy_SceneCreateActor",WZUISpine)
--    local conGirl = GetElement(self.m_root,"conGirlAni_SceneCreateActor",WZUIContainer)
--    local spineGirl = GetElement(self.m_root,"aniGirlAni_SceneCreateActor",WZUISpine)
--    if sex == 0 then
--        conBoy:setScale(MAX_SCALE)
--        conBoy:setRelativePosition(GlobalMethod:ccp(MAX_POS_X,MAX_POS_Y))
--        conGirl:setScale(MIN_SCALE)
--        conGirl:setRelativePosition(GlobalMethod:ccp(MIN_POS_X,MIN_POS_Y))
--        spineBoy:setOpacity(MAX_OPACITY)
--        spineGirl:setOpacity(MIN_OPACITY)
--        --SoundManager:playEffectSound(SoundDefine.E_S_CREATE_NAN)
--    else
--        conBoy:setScale(MIN_SCALE)
--        conBoy:setRelativePosition(GlobalMethod:ccp(MIN_POS_X,MIN_POS_Y))
--        conGirl:setScale(MAX_SCALE)
--        conGirl:setRelativePosition(GlobalMethod:ccp(MAX_POS_X,MAX_POS_Y))
--        spineBoy:setOpacity(MIN_OPACITY)
--        spineGirl:setOpacity(MAX_OPACITY)
--       -- SoundManager:playEffectSound(SoundDefine.E_S_CREATE_NV)
--    end
--    self:senderRandomNameProtocol()
--    self:aniAndPicChange(true)
--end
--
--
--function SceneCreateActor:OnBegin(element,pt,index)
--    self.actionInfo.startX = pt.x
--    WZLog("------------------index---------------",index)
--end
--
--function SceneCreateActor:OnMove(element,pt,index)
--    self.actionInfo.curX = pt.x
--end
--
--function SceneCreateActor:OnEnd(element,pt,index)
--    WZLog("---------------------index--------------",index)
----    self.actionInfo.endX = pt.x
----    if self.btnClick and index == 0 then
----        if self.actionInfo.endX and self.actionInfo.startX then
----            if self.actionInfo.endX - self.actionInfo.startX > 100 then
----                self:OnChangeRole("right")
----            elseif self.actionInfo.endX - self.actionInfo.startX < -100 then
----                self:OnChangeRole("left")
----            end
----        end
----    end
--end
-------------------------------------私有方法模块End----------------------------------------
function SceneCreateActor:_initCheckSex(defaultSex)
    for i = 1, 2 do
        local check = GetElement(self.m_root, "checkSex"..i.."_SceneCreateActor", WZUICheckBox)
        local index = defaultSex == i-1 and 1 or 0
        check:setCheckIndex(index)
    end
end

function SceneCreateActor:onCheckSex(element)
    local tag = element:getTag()
    if tag == self.defaultSex then return end
    if self.checkTime > 0 then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:_initMovePosition(false)
    self.defaultSex = tag
    self:_moveContainer()
    self.checkTime = 0.5
    self.m_root:enableSchedule("_checkBoxTimeOut",0.1)

    for i = 1, 2 do
        local check = GetElement(self.m_root, "checkSex"..i.."_SceneCreateActor", WZUICheckBox)
        check:setTouchEnable(false)
    end
end


-------------------------------------------------------move ani---------------------------------------------------------
local maxPX,maxPy = 0.4,0.44
local girlMaxPX = 0.52
local LeftPX,LeftPY = -0.62,0.44
local rightPX,rightPY = 2.38,0.44
local PW,PH = 1136,640

-- 初始化容器的位置
function SceneCreateActor:_initMovePosition(playSnd)
    local conBoy = GetElement(self.m_root,"conBoyAni_SceneCreateActor",WZUIContainer)
    local conGirl = GetElement(self.m_root,"conGirlAni_SceneCreateActor",WZUIContainer)
    conBoy:setScale(1)
    conGirl:setScale(1)
    if self.defaultSex == 0 then
        conBoy:setRelativePosition(GlobalMethod:ccp(maxPX,maxPX))
        conGirl:setRelativePosition(GlobalMethod:ccp(LeftPX,LeftPY))
    else
        conBoy:setRelativePosition(GlobalMethod:ccp(LeftPX,LeftPY))
        conGirl:setRelativePosition(GlobalMethod:ccp(maxPX,girlMaxPX))
    end
    if playSnd then
        local snd = {getSoundByType(3),getSoundByType(4) }
        SoundManager:playEffectSound(snd[self.defaultSex+1])
    end
    self:senderRandomNameProtocol()
end

-- 移动人物容器
function SceneCreateActor:_moveContainer()
    local conBoy = GetElement(self.m_root,"conBoyAni_SceneCreateActor",WZUIContainer)
    local conGirl = GetElement(self.m_root,"conGirlAni_SceneCreateActor",WZUIContainer)
    conBoy:setScale(1)
    conGirl:setScale(1)
    if self.defaultSex == 0 then
        local move =  CCMoveTo:create(0.2, GlobalMethod:ccp(PW*maxPX,PH*maxPX))
        conBoy:runAction(move)
        local move =  CCMoveTo:create(0.4, GlobalMethod:ccp(PW*rightPX,PH*rightPY))
        conGirl:runAction(move)
        SoundManager:playEffectSound(getSoundByType(3))
    else
        local move =  CCMoveTo:create(0.2, GlobalMethod:ccp(PW*maxPX,PH*girlMaxPX))
        conGirl:runAction(move)
        local move =  CCMoveTo:create(0.4, GlobalMethod:ccp(PW*rightPX,PH*rightPY))
        conBoy:runAction(move)
        SoundManager:playEffectSound(getSoundByType(4))
    end
    self:senderRandomNameProtocol()
end

-- 控制点击频率，动画完成才能点击
function SceneCreateActor:_checkBoxTimeOut(element,time)
    if self.checkTime > 0 then
        self.checkTime = self.checkTime - time
    else
        self.checkTime = 0
        self.m_root:disableSchedule()
        for i = 1, 2 do
            local check = GetElement(self.m_root, "checkSex"..i.."_SceneCreateActor", WZUICheckBox)
            check:setTouchEnable(true)
        end
    end
end

-- 传送特效
function SceneCreateActor:_playEnterAni()
    local spine = GetElement(self.m_root,"spineEnter_SceneCreateActor",WZUISpine)
    spine:setVisible(true)
    spine:setFileJson("role/login_start.json")
    spine:setFileAtlas("role/login_start.atlas")
    spine:play("animation",false)

    spine:enableSchedule("_roleOpacity",0.15)
end

-- 人物透明度改变
function SceneCreateActor:_roleOpacity()
    local spine = GetElement(self.m_root,"spineEnter_SceneCreateActor",WZUISpine)
    spine:disableSchedule()
    spine:enableSchedule("_aniMissTime",0.1)
    local spineBoy = GetElement(self.m_root,"aniBoy_SceneCreateActor",WZUISpine)
    local spineGirl = GetElement(self.m_root,"aniGirlAni_SceneCreateActor",WZUISpine)
    local spineTab = {spineBoy,spineGirl}
    for i = 1, 2 do
        local fadeTo =  WZUIActionFadeTo:create()
        fadeTo:setOpacity(0)
        fadeTo:setDuration(0.15)
        spineTab[i]:runUIAction(fadeTo)
    end
end

-- 动画消失时间控制
function SceneCreateActor:_aniMissTime(element,dt)
    self.aniMissTime = self.aniMissTime + dt
    if self.aniMissTime >= 1.7 then
        self.aniMissTime = 0
        local spine = GetElement(self.m_root,"spineEnter_SceneCreateActor",WZUISpine)
        spine:disableSchedule()
        self:sendEnterGameMsg()
    end
end

-- 恢复人物透明度
function SceneCreateActor:_roleRecoveryOpacity()
    local spineBoy = GetElement(self.m_root,"aniBoy_SceneCreateActor",WZUISpine)
    local spineGirl = GetElement(self.m_root,"aniGirlAni_SceneCreateActor",WZUISpine)
    local spineTab = {spineBoy,spineGirl}
    for i = 1, 2 do
        spineTab[i]:setOpacity(255)
    end
    self.m_root:disableSchedule()

    local spine = GetElement(self.m_root,"spineEnter_SceneCreateActor",WZUISpine)
    spine:setVisible(false)
end

-- 进入游戏失败
function SceneCreateActor:enterGameFail()
    self:finishedLoading()
    PostPlayerEvent:postEvent(PostPlayerEvent.event_createActorFail)
    self.m_root:enableSchedule("_roleRecoveryOpacity",0.1)
end