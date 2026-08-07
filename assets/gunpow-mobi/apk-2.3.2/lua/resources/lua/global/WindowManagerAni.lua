--WindowManagerAni.lua
--@brief	窗口动画效果
--@date  	2014/6/18
--@author 	liangguang_long
--@note 	窗口动画效果

WindowManagerAni = 
{
	tWinAni = nil,
	id = nil,
	createAppearActionTimes = 0,
    m_nAppearTimes = 0,
    m_bIsMoveCity = nil,

    m_nFirstEnlarge = 0.1,
    m_nSceondEnlarge = 0.1,

    m_nFirstReduce = 0.15,
    m_nSceondReduce = 0.1,
    m_nThirdReduce = 0.1,

    m_nFirstEnlargeScale = 1.05,

    m_nFirstReduceScale = 1.05,
    m_nSceondReduceScale = 0.8,
}

-------------------------------------公有方法模块--------------------------------------

--@brief  窗口动画效果  
--@param  duration:持续时间
--@param  easerate:缓和率
--@param  runtimes:运行次数
--@param  scaleX:X轴缩放比例
--@param  scaleY:Y轴缩放比例
function  WindowManagerAni:createWindowAnimation(bShowAll,finisFun,scaleB,scaleC,tB,tC)
	--创建序列动画
	scaleB = scaleB or 1.1
	scaleC = scaleC or 1
	tB = tB or 0.05
	tC = tC or 0.12
	local actionSequence = WZUIActionSequence:create()
	--local view = CCEGLView:sharedOpenGLView()
	--local x = view:getScaleX()
	--local y = view:getScaleY()
	WZLog("WindowManagerAni:createWindowAnimation",x,y)
	--local minScale = math.min(x,y)
	--x = minScale/x
	--y = minScale/y
    local x = element:getScaleX()
    local y = element:getScaleY()
	
	--创建动画,用于缩放
    local scale1 = WZUIActionScaleTo:create()
    scale1:setDuration(0.01)
    scale1:setScaleX(1.2*x)
	scale1:setScaleY(1.2*y)
    local scale2 = WZUIActionScaleTo:create()
    scale2:setDuration(0.1)
    scale2:setScaleX(1.0*x)
	scale2:setScaleY(1.0*y)
    local subSequence = WZUIActionSequence:create()
    subSequence:setChildAction( scale1 )
    subSequence:setChildAction( scale2 )
    
    local fade = WZUIActionContainerFadeFromTo:create()
    fade:setOpacityFrom(120)
    fade:setOpacityTo(255)
    fade:setDuration(0.11)
    
    local spawn = WZUIActionSpawn:create()
    spawn:setChildAction( subSequence )
    spawn:setChildAction( fade )

	return spawn
end


--@brief  窗口弹出动画效果
--@param  element:要弹出的窗口
--@param  bBlackBg:是否要添加灰色背景
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
function WindowManagerAni:createAction(element,bBlackBg,func,tTable)
    if element == nil then
        return
    end
	return  WindowManagerAni:createAppearAction(element,bBlackBg,func,tTable, false)
    -- if bBlackBg == true and not WindowManager:hasMoreWindows() then
        -- --添加背景
        -- --local blackImg = CCSprite:create("ui/common/bg.png")
        -- --blackImg:setZOrder(-110)
		-- --blackImg:setAnchorPoint(ccp(0.1,0))
        -- --blackImg:setScale(2)
        -- --blackImg:setScaleX(2.3)
        -- --element:addChild(blackImg)
        -- --添加灰色背景
        -- local blackImg = CCSprite:create("ui/common/common_black_bg.png")
        -- blackImg:setZOrder(-100)
        -- blackImg:setOpacity(150)
        -- blackImg:setScale(10000)
        -- element:addChild(blackImg,-100,9876)
    -- end

    -- -- 计算放大缩小的比例
    -- local view = CCEGLView:sharedOpenGLView()
	-- local x = element:getScaleX()
	-- local y = element:getScaleY()
	-- WZLog("WindowManagerAni:createAction",x,y)
	-- --local minScale = math.min(x,y)
	-- --x = minScale/x
	-- --y = minScale/y
    
    -- --设置初始的放大
    -- --element:setScaleX(1.05*x)
    -- --element:setScaleY(1.05*y)

    -- -- 创建动画效果
    -- --self.m_tElement = element
    -- --self.m_bBlackBg = bBlackBg
    -- --self.m_tFunc = func
    -- --self.m_tTable = tTable

    -- --WZLog("WindowManagerAni:createAppearAction")
    -- local scaleStart = 0.01
    -- element:setScale(scaleStart)

    -- local duration = 0.1

    -- local scaleAction = WZUIActionScaleTo:create()
    -- scaleAction:setDuration(duration)
    -- scaleAction:setScaleX(x)
    -- scaleAction:setScaleY(y)

    -- local actionSequence = WZUIActionSequence:create()
    -- actionSequence:setIsLoop(false)
    -- --actionSequence:setFinishLuaTable(self)
    -- --actionSequence:setFinishLuaFunction("blackToBright")
    -- actionSequence:setChildAction(scaleAction)
    -- element:runUIAction(actionSequence)
    
    -- -- 设置回调
    -- if func ~= nil then
        -- actionSequence:setFinishLuaFunction(func)
    -- end
    
    -- if tTable ~= nil then 
        -- actionSequence:setFinishLuaTable(tTable)
    -- end
    
    -- element:runUIAction(actionSequence)
end


--@brief  窗口出现动画效果
--@param  element:要弹出的窗口
--@param  bBlackBg:是否要添加灰色背景
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
function WindowManagerAni:createAppearAction(element,bBlackBg,func,tTable,isMoveElement)
    if element == nil then
        return
    end
	self.createAppearActionTimes = self.createAppearActionTimes + 1

    self.m_nAppearTimes = self.m_nAppearTimes + 1

    element.m_tElementAppear= element
    element.m_bBlackBgAppear= false
    element.m_tFuncAppear= func
    element.m_tTableAppear= tTable

    local time = 0 --WindowManagerAni.m_nFirstEnlarge
    local x = element:getScaleX()
    local y = element:getScaleY()
    element.m_nRootScaleXAppear = x
    element.m_nRootScaleYAppear = y

    if bBlackBg == true then
        --添加灰色背景
        local blackImg = WZUIImage:create()
        blackImg:setUseOriginSize(true)
        blackImg:setFile("ui/common/common_black_bg.png")
        blackImg:setOpacity(160)
        blackImg:setScaleX(15)
        blackImg:setScaleY(30)
        blackImg:setName("wnd_black_bg___")
        element:addChild(blackImg,-100,9876)
        --设置下面半透明背景不可见
        WindowManager:disappearWndBlackImg(element)
    end
    
    WZLog("WindowManagerAni:createAppearAction", self.m_nAppearTimes)

    local scaleStart = 0.01
    element:setScaleX(x)
    element:setScaleY(y)

    local scaleAction = WZUIActionScaleTo:create()
    scaleAction:setDuration(time)
    scaleAction:setScaleX(x)
    scaleAction:setScaleY(y)

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop(false)
    actionSequence:setFinishLuaTable(self)
    if false and isMoveElement ~= false then
        actionSequence:setFinishLuaFunction("blackToBright")
    else
        actionSequence:setFinishLuaFunction("blackToBright2")
    end
    actionSequence:setChildAction(scaleAction)
    element:runUIAction(actionSequence)


end

--@brief  窗口背景变亮
function WindowManagerAni:blackToBright(element)
    WZLog("WindowManagerAni:blackToBright", tostring(element), getRunningFrame():getName(), tostring(element.m_tElementAppear), tostring(element.m_tFuncAppear), tostring(element.m_tTableAppear))
    if element.m_tElementAppear == nil then
        return
    end
    element = element.m_tElementAppear
    local time = 0 --0.15

    local scene = getRunningFrame()
    if scene:getName() == "SceneCity" then
        local con = GetElement(WndOwnCity.m_root, "conUp_WndOwnCity", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(-1.3)
        actMoveTo:setMoveY(2.3)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)
        con:runUIAction(actionSequence)

        -- local con = GetElement(WndOwnCity.m_root, "conBtns_WndOwnCity", WZUIContainer)

        -- local actMoveTo = WZUIActionMoveTo:create()
        -- actMoveTo:setDuration(time)
        -- actMoveTo:setMoveX(1.575)
        -- actMoveTo:setMoveY(2)

        -- local actionSequence = WZUIActionSequence:create()
        -- actionSequence:setIsLoop(false)
        -- actionSequence:setChildAction(actMoveTo)
        -- con:runUIAction(actionSequence)

        local con = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "conLeft_WndBottomBar", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(-0.041)
        actMoveTo:setMoveY(0.037)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)
        con:runUIAction(actionSequence)

        local con = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "conRight_WndBottomBar", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(1.62)
        actMoveTo:setMoveY(1.66)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)
        con:runUIAction(actionSequence)
    end

    local scaleAction = WZUIActionScaleTo:create()
    scaleAction:setDuration(time)
    
    if element.m_nRootScaleXAppear ~= nil and element.m_nRootScaleYAppear ~= nil then
        scaleAction:setScaleX(1*element.m_nRootScaleXAppear)
        scaleAction:setScaleY(1*element.m_nRootScaleYAppear)
    else
        scaleAction:setScaleX(1)
        scaleAction:setScaleY(1)
    end
    scaleAction:setFinishLuaTable(self)
    scaleAction:setFinishLuaFunction("actionEnd")
    self.m_nAppearTimes = self.m_nAppearTimes - 1

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop(false)
    actionSequence:setChildAction(scaleAction)
    --if element.m_bBlackBgAppear ~= true then
    if element.m_tFuncAppear ~= nil then
        actionSequence:setFinishLuaFunction(element.m_tFuncAppear)
    end

    if element.m_tTableAppear ~= nil then
        actionSequence:setFinishLuaTable(element.m_tTableAppear)
    end
    --end
    element:runUIAction(actionSequence)

    if element.m_bBlackBgAppear == true then
        --添加灰色背景
        local blackImg = WZUIImage:create()
        blackImg:setUseOriginSize(true)
        blackImg:setFile("ui/common/common_black_bg.png")
        blackImg:setOpacity(0)
        blackImg:setScaleX(15)
        blackImg:setScaleY(30)
        blackImg:setName("wnd_black_bg___")
        element:addChild(blackImg,-100,9876)
        --设置下面半透明背景不可见
        WindowManager:disappearWndBlackImg(element)
    end

    element.m_tElementAppear= nil
    element.m_bBlackBgAppear= nil
    element.m_tFuncAppear= nil
    element.m_tTableAppear= nil
    element.m_nRootScaleXAppear = nil
    element.m_nRootScaleYAppear = nil

end

--@brief  窗口背景变亮
function WindowManagerAni:blackToBright2(element)
    WZLog("WindowManagerAni:blackToBright2", getRunningFrame() and getRunningFrame():getName(), tostring(element.m_tElementAppear), tostring(element.m_tFuncAppear), tostring(element.m_tTableAppear))
    if element.m_tElementAppear == nil then
        return
    end
    element = element.m_tElementAppear
    local time = 0 --WindowManagerAni.m_nSceondEnlarge

    local scene = getRunningFrame()

    local scaleAction = WZUIActionScaleTo:create()
    scaleAction:setDuration(time)
    
    if element.m_nRootScaleXAppear ~= nil and element.m_nRootScaleYAppear ~= nil then
        scaleAction:setScaleX(1*element.m_nRootScaleXAppear)
        scaleAction:setScaleY(1*element.m_nRootScaleYAppear)
    else
        scaleAction:setScaleX(1)
        scaleAction:setScaleY(1)
    end
    scaleAction:setFinishLuaTable(self)
    scaleAction:setFinishLuaFunction("actionEnd")
    self.m_nAppearTimes = self.m_nAppearTimes - 1

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop(false)
    actionSequence:setChildAction(scaleAction)
    --if element.m_bBlackBgAppear ~= true then
    if element.m_tFuncAppear ~= nil then
        actionSequence:setFinishLuaFunction(element.m_tFuncAppear)
    end

    if element.m_tTableAppear ~= nil then
        actionSequence:setFinishLuaTable(element.m_tTableAppear)
    end
    --end
    element:runUIAction(actionSequence)

    if element.m_bBlackBgAppear == true then
        --添加灰色背景
        local blackImg = WZUIImage:create()
        blackImg:setUseOriginSize(true)
        blackImg:setFile("ui/common/common_black_bg.png")
        blackImg:setOpacity(150)
        blackImg:setScaleX(15)
        blackImg:setScaleY(30)
        blackImg:setName("wnd_black_bg___")
        element:addChild(blackImg,-100,9876)
        --设置下面半透明背景不可见
        WindowManager:disappearWndBlackImg(element)        
    end

    element.m_tElementAppear= nil
    element.m_bBlackBgAppear= nil
    element.m_tFuncAppear= nil
    element.m_tTableAppear= nil
    element.m_nRootScaleXAppear = nil
    element.m_nRootScaleYAppear = nil
end

function WindowManagerAni:actionEnd()

    if TeachGroup1 then
        --self.m_nAppearTimes = self.m_nAppearTimes - 1

        local isFinish26, finishStep26 = TeachGroup1:isTeachFinish(26)

        WZLog("WindowManagerAni:actionEnd", self.m_nAppearTimes, tostring(isFinish26), finishStep26)
        if WndPurchase.m_root and isFinish26 ~= true and finishStep26 >= 5 then
            TeachGroup1:endTeachStep({26,6})
            PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickBuy)
            TeachGroup1:startGroup({26,7,WndPurchase.m_root})
        end
    end
end

--@brief  窗口消失动画效果
--@param  element:要弹出的窗口
--@param  bBlackBg:是否要添加灰色背景
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
--@param  isNoAction:是否不做动作,直接消失
function WindowManagerAni:createDisappearAction(element,func,tTable,isNoAction)
    WZLog("WindowManagerAni:createDisappearAction", self.createAppearActionTimes)
    if element == nil then
        return
    end

	self.createAppearActionTimes = self.createAppearActionTimes - 1

    if isNoAction then
        WindowManager:removeWindow(element , tTable , true)
        return
    end

    --self.m_tElementDisappear = element
    --self.m_tFuncDisappear = func
    --self.m_tTableDisappear = tTable

    local x = element:getScaleX()
    local y = element:getScaleY()
    --element.m_nRootScaleXAppear = x
    --element.m_nRootScaleYAppear = y
    local time = 0 --WindowManagerAni.m_nSceondReduce
    --WZLog("WindowManagerAni:createDisappearAction", element.m_nRootScaleXAppear, element.m_nRootScaleYAppear)

    --添加灰色背景
    local blackImg = WZUIImage:luaTo(element:getChildByTag(9876))
    if false and blackImg then
        blackImg:setName("")
        --显示下面的半透明黑色背景
        if WindowManager:appearWndBlackImg() == true then
            blackImg:removeFromParentAndCleanup(true)
        else 
            local actionSequence = WZUIActionSequence:create()
            actionSequence:setIsLoop( false )
            local actionFadeTo2 = WZUIActionFadeTo:create()
            actionFadeTo2:setDuration(0)
            actionFadeTo2:setOpacity( 0 )
            actionSequence:setChildAction( actionFadeTo2 )
            blackImg:runUIAction( actionSequence )
        end
    end

    local scaleStart = 1
    element:setScaleX(x)
    element:setScaleY(y)

    local scaleAction = WZUIActionScaleTo:create()
    scaleAction:setDuration(time)
    scaleAction:setScaleX(x)
    scaleAction:setScaleY(y)

    time = WindowManagerAni.m_nFirstReduce

    local scaleAction2 = WZUIActionScaleTo:create()
    scaleAction2:setDuration(time)
    scaleAction2:setScaleX(x)
    scaleAction2:setScaleY(y)

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop(false)
    --actionSequence:setFinishLuaTable(self)
    --actionSequence:setFinishLuaFunction("brightToBlack")
    --actionSequence:setChildAction(scaleAction2)
    actionSequence:setChildAction(scaleAction)
    if tTable ~= nil then 
        actionSequence:setFinishLuaTable(tTable)
    end
    if func ~= nil then 
       actionSequence:setFinishLuaFunction(func)
    end

    if element.m_sName ~= nil and (element.m_sName == "WndSkillContainer" or element.m_sName == "WndTask") then
        self:disappearOk()
    end
    element:runUIAction(actionSequence)

end

--@brief  窗口消失动画效果
--@param  element:要弹出的窗口
--@param  bBlackBg:是否要添加灰色背景
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
--@param  isNoAction:是否不做动作,直接消失
function WindowManagerAni:createDisappearAction2(element,func,tTable,isNoAction, nodeMoveTo)
    WZLog("WindowManagerAni:createDisappearAction2", self.createAppearActionTimes, WindowManagerAni.m_nSceondReduce)
    if element == nil or nodeMoveTo == nil then
        return
    end

    self.createAppearActionTimes = self.createAppearActionTimes - 1

    if isNoAction then
        WindowManager:removeWindow(element , tTable , true)
        return
    end

    self.m_tElementDisappear = element
    self.m_tFuncDisappear = func
    self.m_tTableDisappear = tTable

    local x = element:getScaleX()
    local y = element:getScaleY()
    element.m_nRootScaleXAppear = x
    element.m_nRootScaleYAppear = y
    local time = 0.8--WindowManagerAni.m_nSceondReduce
    --WZLog("WindowManagerAni:createDisappearAction", element.m_nRootScaleXAppear, element.m_nRootScaleYAppear)

    --添加灰色背景
    local blackImg = WZUIImage:luaTo(element:getChildByTag(9876))
    if blackImg then
        blackImg:setOpacity(0)
    end

    local scaleStart = 1
    element:setScaleX(x)
    element:setScaleY(y)

    local scaleAction = CCScaleTo:create(time, 0.05, 0.05)

    local pt = nodeMoveTo:convertToWorldSpace(GlobalMethod:ccp(0,0))
    local ptRelative = element:convertToNodeSpace(pt)
    WZLog("HHHHHHHHHHHHHHHHH", pt.x, pt.y, ptRelative.x, ptRelative.y)
    pt.x = pt.x + 50
    pt.y = pt.y + 40
    local moveAction = CCMoveTo:create(time, pt)
    local spawn = CCSpawn:createWithTwoActions(scaleAction, moveAction)

    time = WindowManagerAni.m_nFirstReduce

    local scaleAction2 = WZUIActionScaleTo:create()
    scaleAction2:setDuration(time)
    scaleAction2:setScaleX(x)
    scaleAction2:setScaleY(y)

    local call=CCCallFunc:create(function() 
                        self.m_tFuncDisappear(self.m_tTableDisappear)
                    end)
    local actions = CCArray:create()
    actions:addObject(spawn)
    actions:addObject(call)
    local actionSequence = CCSequence:create(actions)

    element:runAction(actionSequence)
end

--@brief  窗口背景变暗
function WindowManagerAni:brightToBlack()
    WZLog("WindowManagerAni:brightToBlack",self.createAppearActionTimes)
    if self.m_tElementDisappear == nil then
        return
    end
    element = self.m_tElementDisappear
    local time = 0 --WindowManagerAni.m_nThirdReduce

    local scene = getRunningFrame()
    --if scene:getName() == "SceneCity" and self.createAppearActionTimes == 0 then
    if false and scene:getName() == "SceneCity" and self.m_bIsMoveCity == nil then
        self.m_bIsMoveCity = true
        local con = GetElement(WndOwnCity.m_root, "conUp_WndOwnCity", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(0)
        actMoveTo:setMoveY(1)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)
        con:runUIAction(actionSequence)

        -- local con = GetElement(WndOwnCity.m_root, "conBtns_WndOwnCity", WZUIContainer)

        -- local actMoveTo = WZUIActionMoveTo:create()
        -- actMoveTo:setDuration(time)
        -- actMoveTo:setMoveX(0.0658441)
        -- actMoveTo:setMoveY(0.0117924)

        -- local actionSequence = WZUIActionSequence:create()
        -- actionSequence:setIsLoop(false)
        -- actionSequence:setChildAction(actMoveTo)
        -- con:runUIAction(actionSequence)

        local con = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "conLeft_WndBottomBar", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(0.003)
        actMoveTo:setMoveY(0.17)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)
        actionSequence:setFinishLuaTable(self)
        actionSequence:setFinishLuaFunction("cityDisappearOk")
        con:runUIAction(actionSequence)

        local con = GetElement(SceneCity.m_tWndBottomBarObj.m_root, "conRight_WndBottomBar", WZUIContainer)

        local actMoveTo = WZUIActionMoveTo:create()
        actMoveTo:setDuration(time)
        actMoveTo:setMoveX(1)
        actMoveTo:setMoveY(1)

        local actionSequence = WZUIActionSequence:create()
        actionSequence:setIsLoop(false)
        actionSequence:setChildAction(actMoveTo)

        WZLog("WindowManagerAni:brightToBlack two", tostring(element.m_sName))
        if element.m_sName ~= nil and (element.m_sName == "WndSkillContainer" or element.m_sName == "WndTask") then
            actionSequence:setFinishLuaTable(self)
            actionSequence:setFinishLuaFunction("disappearOk")
        end


        con:runUIAction(actionSequence)
    elseif element.m_sName ~= nil and (element.m_sName == "WndSkillContainer" or element.m_sName == "WndTask") then
        self:disappearOk()
    end

    local scaleAction = WZUIActionScaleTo:create()
    scaleAction:setDuration(time)
    scaleAction:setScaleX(element.m_nRootScaleXAppear)
    scaleAction:setScaleY(element.m_nRootScaleYAppear)

    local fadeTo =  WZUIActionFadeTo:create()
    fadeTo:setOpacity(0)
    fadeTo:setDuration(0)

    local delayTime = WZUIActionDelayTime:create()
    delayTime:setDuration(0)

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop(false)
    actionSequence:setChildAction(scaleAction)
    --actionSequence:setChildAction(fadeTo)
    actionSequence:setChildAction(delayTime)

    if self.m_tFuncDisappear ~= nil then
        actionSequence:setFinishLuaFunction(self.m_tFuncDisappear)
    end

    if self.m_tTableDisappear ~= nil then
        actionSequence:setFinishLuaTable(self.m_tTableDisappear)
    end
    element:runUIAction(actionSequence)
end

--@brief  窗口背景变暗
function WindowManagerAni:cityDisappearOk(ele)
    WZLog("WindowManagerAni:cityDisappearOk")
    self.m_bIsMoveCity = nil
end

--@brief  窗口背景变暗
function WindowManagerAni:disappearOk(ele)
    WZLog("disappearOk")

    local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    if isFinish5 ~= true and finishStep5 >= 5 then
        if WndSingleCopy.m_root then 
            TeachGroup1:startGroup({5,10, WndSingleCopy.m_root})
        end
    end

    local isEndTeach8, teachStep8 = TeachGroup1:isTeachFinish(8)
    local isEndTeach20, teachStep20 = TeachGroup1:isTeachFinish(20)
    local isEndTask = TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_3)
    WZLog("disappearOk two", tostring(isEndTeach8), tostring(GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection))
    if isEndTask == true and isEndTeach8 ~= true and teachStep8 < 5 then
        TeachGroup1:endTeachStep({8,1})
        if GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 1 then
            TeachGroup1:startGroup({8,2,GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root})
        elseif GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 0 then
            TeachGroup1:startGroup({8,3,GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root})
        end
    elseif isEndTeach20 ~= true and teachStep20 >= 5 then
        TeachGroup1:startGroup({20,7,GlobalGame.g_tWndBottomBarObj.m_root})
    end
end



--@brief  关闭窗口动画效果
--@param  element:要弹出的窗口
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
function WindowManagerAni:createCloseAction(element,func,tTable)
    if element == nil then
        return
    end
	
	return WindowManagerAni:createDisappearAction(element,func,tTable)
    -- 计算放大缩小的比例
    -- local view = CCEGLView:sharedOpenGLView()
	-- local x = view:getScaleX()
	-- local y = view:getScaleY()
	-- WZLog("view = CCEGLView:sharedOpenGLView():",x,y)
	-- local minScale = math.min(x,y)
	-- x = minScale/x
	-- y = minScale/y
    
    -- -- 创建动画效果
    -- local scale1 = WZUIActionScaleTo:create()
    -- scale1:setDuration(0.01)
    -- scale1:setScaleX(1.2*x)
	-- scale1:setScaleY(1.2*y)
    -- local scale2 = WZUIActionScaleTo:create()
    -- scale2:setDuration(0.1)
    -- scale2:setScaleX(1.05*x)
	-- scale2:setScaleY(1.05*y)
    -- --local subSequence = WZUIActionSequence:create()
    -- --subSequence:setChildAction( scale1 )
    -- --subSequence:setChildAction( scale2 )
    
    -- --local fade = WZUIActionContainerFadeFromTo:create()
    -- --fade:setOpacityFrom(255)
    -- --fade:setOpacityTo(0)
    -- --fade:setDuration(0.3)
    
    -- --local spawn = WZUIActionSpawn:create()
    -- --spawn:setChildAction( subSequence )
    -- --spawn:setChildAction( fade )
    
    
    -- local subSequence = WZUIActionSequence:create()
    -- subSequence:setChildAction( scale2 )
    -- --subSequence:setChildAction( fade )

    -- -- 设置回调
    -- if func ~= nil then
        -- subSequence:setFinishLuaFunction(func)
    -- end
    
    -- if tTable ~= nil then
        -- subSequence:setFinishLuaTable(tTable)
    -- end
    
    -- element:runUIAction(subSequence)
end

--@brief  关闭窗口动画效果
--@param  element:要弹出的窗口
--@param  func:窗口弹出结束后的回调
--@param  tTable:弹出窗口回调对应的table
function WindowManagerAni:createCloseAction2(element,func,tTable)
    if element == nil then
        return
    end
    -- 计算放大缩小的比例
    
    -- 创建动画效果
    local scale1 = WZUIActionScaleTo:create()
    scale1:setDuration(0.15)
    scale1:setScaleX(0.2)
    scale1:setScaleY(0.2)

    -- 设置回调
    if func ~= nil then
        scale1:setFinishLuaFunction(func)
    end
    
    if tTable ~= nil then
        scale1:setFinishLuaTable(tTable)
    end
    
    element:runUIAction(scale1)
end

--@brief  窗口动画效果  
--@param  duration:持续时间
--@param  easerate:缓和率
--@param  runtimes:运行次数
--@param  scaleX:X轴缩放比例
--@param  scaleY:Y轴缩放比例
function  WindowManagerAni:closeWindowAnimation(finisFun,scaleB,scaleC,tB,tC)
	--创建序列动画
	scaleB = scaleB or 1.1
	scaleC = scaleC or 1
	tB = tB or 0.05
	tC = tC or 0.12
	local view = CCEGLView:sharedOpenGLView()
	local x = view:getScaleX()
	local y = view:getScaleY()
	WZLog("view = CCEGLView:sharedOpenGLView():",x,y)
	local minScale = math.min(x,y)
	x = minScale/x
	y = minScale/y
	local scale1 = CCScaleTo:create(tB,scaleB)
	local scale2 = CCScaleTo:create(tC,scaleC)
	local sequence = CCSequence:createWithTwoActions(scale1,scale2)
	return sequence
end

--@brief  关闭窗口动画效果 
function WindowManagerAni:closeWindowsAni(tData)
	tData[2].m_root:runUIAction(WindowManagerAni:createWindowAnimation(nil,nil,1.2,1,0.05,0.1))
	WindowManagerAni.tWinAni = {}
	WindowManagerAni.tWinAni = tData
	if WindowManagerAni.id == nil then
		WindowManagerAni.id = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WindowManagerAni.onFinishWindows,0.18, false)
	else
		WindowManagerAni.tWinAni[5](WindowManagerAni.tWinAni[4],WindowManagerAni.tWinAni[1],WindowManagerAni.tWinAni[2],WindowManagerAni.tWinAni[3])
	end
end

--@brief  关闭窗口动画定时器
function WindowManagerAni.onFinishWindows(t)
	if WindowManagerAni.id then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WindowManagerAni.id)
		WindowManagerAni.tWinAni[5](WindowManagerAni.tWinAni[4],WindowManagerAni.tWinAni[1],WindowManagerAni.tWinAni[2],WindowManagerAni.tWinAni[3])
		WindowManagerAni.id = nil 
	end
end

--@brief	弹出说明动画效果
function WindowManagerAni:popUpAni(element,callback)
	local actionScaleTo1 = WZUIActionScaleTo:create()
    actionScaleTo1:setDuration(0.1)
    actionScaleTo1:setScaleY(1.1)
    actionScaleTo1:setScaleX(1.1)
    local actionScaleTo2 = WZUIActionScaleTo:create()
    actionScaleTo2:setDuration(0.1)
    actionScaleTo2:setScaleY(0.9)
    actionScaleTo2:setScaleX(0.9)
    local actionScaleTo3 = WZUIActionScaleTo:create()
    actionScaleTo3:setDuration(0.2)
    actionScaleTo3:setScaleY(1)
    actionScaleTo3:setScaleX(1)
    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(actionScaleTo1)
    actionSqu:setChildAction(actionScaleTo2)
    actionSqu:setChildAction(actionScaleTo3)


    local action = WZUIActionSpawn:create()

    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(0.3)
    actMoveTo:setMoveX(1.0)
    actMoveTo:setMoveY(0.6)

    local actFadeTo = WZUIActionContainerFadeFromTo:create()
    actFadeTo:setDuration(1.0)
    actFadeTo:setOpacityFrom(255)
    actFadeTo:setOpacityTo(0)
    actFadeTo:setFinishLuaFunction(callback)

    action:setChildAction(actFadeTo)
    action:setChildAction(actMoveTo)

    actionSqu:setChildAction(action)

    element:runUIAction(actionSqu)
end

function WindowManagerAni:createTopAction(element,direction,tCall,fCallback)
	if tCall ~= nil and fCallback ~= nil then
		fCallback(tCall)
	end	
end

--@brief  顶部子窗口移动动画
--@param  element:要移动的容器
--@param  direction:方向0向下，1向上
function WindowManagerAni:createTopAction1(element,direction,tCall,fCallback)
	if tCall ~= nil and fCallback ~= nil then
		fCallback(tCall)
	end	
	if element == nil then return end
	WZLog("WindowManagerAni:createTopAction",direction)
	local positionX = element:getPositionX()
	local positionY = element:getPositionY()
    local height = element:getContentSize().height 
	local array
	if direction == 0 then
		element:setPositionY(positionY + height + 200)

		array = CCArray:create()
		local move = CCMoveTo:create(0.4, ccp(positionX,positionY))
		local ccEaseIn = CCEaseOut:create(move,3)
		array:addObject(ccEaseIn)
	else
		array = CCArray:create()
		local move = CCMoveTo:create(1.0, ccp(positionX,positionY + height + 200))
		local ccEaseIn = CCEaseIn:create(move,3)
		array:addObject(move)
	end

	if tCall ~= nil and fCallback ~= nil then
		array:addObject(CCCallFunc:create(function() fCallback(tCall) end))
	end

	element:runAction(CCSequence:create(array))
end

function WindowManagerAni:createSwitchTabAction(element1,direction,moveOut,element2,tCall,fCallback,delay)
	if tCall ~= nil and fCallback ~= nil then
		fCallback(tCall)
	end	
	if moveOut == true then
		if element2 ~= nil then
			element2:setVisible(true)
			element1:setVisible(false)
		end
	end
end

--@brief  左右子窗口移动动画
--@param  element1:要移动的容器
--@param  direction:移动方向,0:左  1:右
--@param  moveOut:是否需要先移出屏幕
--@param  element2:从屏幕外移动进入的容器
--@param  tCall:回调对象
--@param  fCallback:回调函数
function WindowManagerAni:createSwitchTabAction1(element1,direction,moveOut,element2,tCall,fCallback,delay)
	if tCall ~= nil and fCallback ~= nil then
		fCallback(tCall)
	end	
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	local positionX = element1:getPositionX()
	local positionY = element1:getPositionY()
    local offset = element1:getContentSize().width + positionX + 100
    if direction == 0 then
		offset = 0 - element1:getContentSize().width - 100
	else
		offset = directorSize.width + 300
	end

	if moveOut == true then
		if element2 == nil then
			local array = CCArray:create()
			local move1
			if delay then
				--退出时的动画设置
				move1 = CCMoveTo:create(0.4, ccp(offset,positionY))
			else
				--切换标签时的动画设置
				move1 = CCMoveTo:create(0.3, ccp(offset,positionY))
			end
			local ccEase1 = CCEaseIn:create(move1,2)
			array:addObject(ccEase1)
			if delay then
				--容器移除后延迟关闭时间
        		array:addObject(CCDelayTime:create(0.05))
			end

			if tCall ~= nil and fCallback ~= nil then
				array:addObject(CCCallFunc:create(function() fCallback(tCall) end))
			end

			local move2 = CCMoveTo:create(0.3, ccp(positionX,positionY))
			local ccEase2 = CCEaseOut:create(move2,2)
			array:addObject(ccEase2)

			element1:runAction(CCSequence:create(array))
		else
			--容器1移出，然后设置回原位，设为不可见
			local array = CCArray:create()
			local move1 = CCMoveTo:create(0.3, ccp(offset,positionY))
			local ccEase1 = CCEaseIn:create(move1,2)
			array:addObject(ccEase1)

			--if tCall ~= nil and fCallback ~= nil then
				array:addObject(CCCallFunc:create(function()
					local px2 = element2:getPositionX()
					element2:setPositionX(offset)
					local array = CCArray:create()
					local move = CCMoveTo:create(0.3, ccp(px2,element2:getPositionY()))
					local ccEaseIn = CCEaseOut:create(move,2)
			  	element2:setVisible(true)
					element2:runAction(ccEaseIn)

			  	element1:setVisible(false)
					element1:setPositionX(positionX)
				end))
			--end

			element1:runAction(CCSequence:create(array))
		end
	else
		element1:setPositionX(offset)

		local array = CCArray:create()
		local move = CCMoveTo:create(0.4, ccp(positionX,positionY))
		local ccEaseIn = CCEaseOut:create(move,2)
		array:addObject(ccEaseIn)

		if tCall ~= nil and fCallback ~= nil then
			array:addObject(CCCallFunc:create(function() fCallback(tCall) end))
		end

		element1:runAction(CCSequence:create(array))
	end
end

--@brief  左右子窗口移动动画
--@param  element1:要移动的容器
--@param  direction:移动方向,0:左  1:右
--@param  moveOut:是否需要先移出屏幕
--@param  element2:从屏幕外移动进入的容器
--@param  tCall:回调对象
--@param  fCallback:回调函数
function WindowManagerAni:createSwitchEquip(element1,direction,moveOut,element2,tCall,fCallback,delay)
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	local positionX = element1:getPositionX()
	local positionY = element1:getPositionY()
    local offset = element1:getContentSize().width + positionX + 100
    if direction == 0 then
		offset = 0 - element1:getContentSize().width - 100
	else
		offset = directorSize.width + 300
	end
	WZLog("WindowManagerAni:createSwitchEquip", positionX)

	local startPosition = -100
	if direction == 1 then
		startPosition = -100
	else
		startPosition = 700
	end

			--容器1移出，然后设置回原位，设为不可见
			local array = CCArray:create()
			local move1 = CCMoveTo:create(0.3, ccp(offset,positionY))
			local ccEase1 = CCEaseIn:create(move1,2)
			--array:addObject(ccEase1)

			--if tCall ~= nil and fCallback ~= nil then
				array:addObject(CCCallFunc:create(function()
					local px2 = element2:getPositionX()
					element2:setPositionX(startPosition)
					local array = CCArray:create()
					local move = CCMoveTo:create(0.3, ccp(px2,element2:getPositionY()))
					local ccEaseIn = CCEaseOut:create(move,2)
			  	element2:setVisible(true)
					element2:runAction(ccEaseIn)

			  	element1:setVisible(false)
					element1:setPositionX(positionX)
				end))
			--end

			element1:runAction(CCSequence:create(array))
end

--@brief  左右子窗口移动动画
--@param  element1:要移动的容器
--@param  direction:左右容器,0:左  1:右
--@param  moveOut:是否需要先移出屏幕
--@param  element2:从屏幕外移动进入的容器
--@param  tCall:回调对象
--@param  fCallback:回调函数
function WindowManagerAni:createMoveOut(element1,direction,moveOut,element2,tCall,fCallback,delay)
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	local positionX = element1:getPositionX()
	local positionY = element1:getPositionY()
    local offset = element1:getContentSize().width + positionX + 100
    if direction == 0 then
		offset = 0 - element1:getContentSize().width - 100
	else
		offset = directorSize.width + 300
	end
	WZLog("WindowManagerAni:createSwitchEquip", positionX)

	local startPosition = -100
	if direction == 1 then
		startPosition = 900
	else
		startPosition = 800
	end

			--容器1移出，然后设置回原位，设为不可见
			local array = CCArray:create()
			local move1 = CCMoveTo:create(0.3, ccp(offset,positionY))
			local ccEase1 = CCEaseIn:create(move1,2)
			--array:addObject(ccEase1)

			--if tCall ~= nil and fCallback ~= nil then
				array:addObject(CCCallFunc:create(function()
					local px2 = element2:getPositionX()
					element2:setPositionX(startPosition)
					local array = CCArray:create()
					local move = CCMoveTo:create(0.3, ccp(px2,element2:getPositionY()))
					local ccEaseIn = CCEaseOut:create(move,2)
			  	element2:setVisible(true)
					element2:runAction(ccEaseIn)

			  	element1:setVisible(false)
					element1:setPositionX(positionX)
				end))
			--end

			element1:runAction(CCSequence:create(array))
end
-------------------------------------私有方法模块--------------------------------------


