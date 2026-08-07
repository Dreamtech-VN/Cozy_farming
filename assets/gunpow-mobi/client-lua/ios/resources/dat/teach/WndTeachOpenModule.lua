--WndTeachOpenModule.lua
--@brief	WndTeachOpenModule的UI模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeachOpenModule:onEnter(element)
    WZLog("WndTeachOpenModule:onEnter")
	self.m_root = element
    self:_moreLanguageForStroke()
    self:_update()
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeachOpenModule:onExit(element)
    WZLog("WndTeachOpenModule:onExit")
    if self.m_anim ~= nil and self.m_anim:getAnimNode() ~= nil and self.m_anim:getAnimNode().removeFromParentAndCleanup ~= nil   and self.m_anim:getAnimNode():getParent() ~= nil then

        self.m_anim:getAnimNode():release()
        self.m_anim:getAnimNode():removeFromParentAndCleanup(false)
    end
	self:_unInit()
end


--@brief	关闭窗口
--@param	element:按钮的引用
function WndTeachOpenModule:onOkClick()
    WZLog("WndTeachOpenModule:onOkClick", self.m_nStep)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local step = self.m_nStep
    local isReplaceScene = self.m_bIsReplaceScene
    WndTeachOpenModule:removeWindow()
    
    if WndTeachTalk.m_root ~= nil then
        WndTeachTalk:removeWindow()
    end

    WZLog("WndTeachOpenModule:onOkClick one",tostring(isReplaceScene))
    if isReplaceScene == true then
        WZLog("WndTeachOpenModule:onOkClick two")
        local sceneIsland = SceneIsland:createElement()
        if sceneIsland ~= nil then
            Teach.OPEN_MODULE_MARK = true
            replaceScene(sceneIsland)
            SceneRoom:onBackSceneCallback(true)
            SceneBossRoom:onBackScene(true)
        end
    end

    Teach:finishStep(step)
    --Teach.OPEN_MODULE_FINISH_STEP = step
    --Teach:finishStepPer(step, false)
end

--@brief	关闭窗口
function WndTeachOpenModule:removeWindow()
    WZLog("WndTeachOpenModule:removeWindow", tostring(self.m_root))
    if self.m_root == nil then
        return
    end

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	触摸面板Began回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function WndTeachOpenModule:onTouchBegan(element, point,nIdx)
    WZLog("WndTeachOpenModule:onTouchBegan", tostring(element), tostring(point.x), tostring(point.y), tostring(nIdx))
    return true
end

--@brief	触摸面板Moved回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function WndTeachOpenModule:onTouchMoved(element, point,nIdx)
    WZLog("WndTeachOpenModule:onTouchMoved")
    return true
end

--@brief	触摸面板End回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function WndTeachOpenModule:onTouchEnd(element, point,nIdx)
    WZLog("WndTeachOpenModule:onTouchEnd", tostring(element), tostring(point.x), tostring(point.y), tostring(nIdx))
    --self:onOkClick()
    return true
end

--@brief    设置名字
--@param    模块名字
function WndTeachOpenModule:setName(name)
WZLog("WndTeachOpenModule:setName", name)
    self.m_sName = name
end

--@brief    设置是否跳转场景
--@param    设置是否跳转
function WndTeachOpenModule:setReplaceScene(isReplace)
    WZLog("WndTeachOpenModule:setReplaceScene", isReplace)
    self.m_bIsReplaceScene = isReplace
end

--@brief 设置说明文本
--@param txt:说明文本
function WndTeachOpenModule:setDetail(txt)
    self.m_sDetail = txt
end

--@brief    设置属于的教学步骤
--@param    是名字
function WndTeachOpenModule:setTeachStep(step)
    WZLog("WndTeachOpenModule:setstep", step)
    self.m_nStep = step
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新说明
function WndTeachOpenModule:_update()
    self:_upDateMoveContainer()
end

--@brief  	更新滚动容器内部布局函数
function WndTeachOpenModule:_upDateMoveContainer()
	if self.m_root == nil then
		return
	end

    WZLog("WndTeachOpenModule:_upDateMoveContainer one", self.m_sName, self.m_sDetail)

    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtOpen_WndTeachOpenModule")):setText(self.m_sDetail)
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachOpenModule")):setText(self.m_sName)

    WZUI9Image:luaTo(GetElement(self.m_root,"imgTouch_WndTeachOpenModule")):setOpacity(200)
        WZUI9Image:luaTo(GetElement(self.m_root,"imgTouch_WndTeachOpenModule")):setScale(1.5)



    self.m_anim = BattleAnimation:createAnimation("xinshouyindao", true)
    self.m_anim:getAnimNode():retain()
    GetElement(self.m_root,"conName_WndTeachOpenModule"):addChild(self.m_anim:getAnimNode())
    self.m_anim:getAnimNode():setPosition(GlobalMethod:ccp(170,-120))
    self.m_anim:setScale(3.7)
    self.m_anim:play("0",true)

    --[[
    local armatureName = "teach004"
    local armatureManager = CCArmatureDataManager:sharedArmatureDataManager()
    if armatureManager:getTextureData(armatureName) == nil then
        armatureManager:addArmatureFileInfo("teach.png", "teach.plist", "teach.xml")
    end

    local fingerArmature = WZArmature:create()
    if fingerArmature ~= nil then
        fingerArmature:setArmatureName(armatureName)
        fingerArmature:setRelativePosition( GlobalMethod:ccp(self.m_mFingerX,0.45))
        fingerArmature:setUseOriginSize(true)
        GetElement(self.m_root,"conButton_WndTeachOpenModule"):addChild(fingerArmature , 1 )
        fingerArmature:play(0)
        self.m_fingerAni = fingerArmature
    end
    --]]
    WZLog("WndTeachOpenModule:_upDateMoveContainer two", tostring(self.m_anim))

end

-------------------------------------私有方法模块End----------------------------------------
--描边字设置
function WndTeachOpenModule:_moreLanguageForStroke()
    WZLog("WndTeachOpenModule:_moreLanguageForStroke")
    --确定
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtOk_WndTeachOpenModule")):setText(LocalStrings.TEACH_CHICK)
end

--@brief    中文适配函数
--@note     中文适配函数
function WndTeachOpenModule:_adaptLanguage_cn()
    WZLog("WndTeachOpenModule:_adaptLanguage_cn")

    local conButton = WZUIContainer:luaTo(GetElement(self.m_root,"conButton_WndTeachOpenModule"))
    conButton:setRelativePosition(GlobalMethod:ccp(0.5,0.45))

    WZUI9Image:luaTo(GetElement(self.m_root,"imgButton_WndTeachOpenModule")):setScaleX(0.72)
    WZUI9Image:luaTo(GetElement(self.m_root,"imgButton_WndTeachOpenModule")):setScaleY(1.1)

    self.m_mFingerX = 0.8
end

--@brief    中文繁体适配函数
--@note     中文繁体适配函数
function WndTeachOpenModule:_adaptLanguage_hk()
    WZLog("WndTeachOpenModule:_adaptLanguage_hk")

    local conButton = WZUIContainer:luaTo(GetElement(self.m_root,"conButton_WndTeachOpenModule"))
    conButton:setRelativePosition(GlobalMethod:ccp(0.5,0.45))

    WZUI9Image:luaTo(GetElement(self.m_root,"imgButton_WndTeachOpenModule")):setScaleX(0.72)
    WZUI9Image:luaTo(GetElement(self.m_root,"imgButton_WndTeachOpenModule")):setScaleY(1.1)

    self.m_mFingerX = 0.8
end

--@brief    英文适配函数
--@note     英文适配函数
function WndTeachOpenModule:_adaptLanguage_en()
    WZLog("WndTeachOpenModule:_adaptLanguage_en")

    WZUI9Image:luaTo(GetElement(self.m_root,"imgOpen_WndTeachOpenModule")):setScaleX(1.3)
    
    local conButton = WZUIContainer:luaTo(GetElement(self.m_root,"conButton_WndTeachOpenModule"))
    conButton:setRelativePosition(GlobalMethod:ccp(0.5,0.45))
    
    local btnButton = WZUIButton:luaTo(GetElement(self.m_root,"btnOk_WndTeachOpenModule"))
    btnButton:setScaleX(1.4)
    btnButton:setScaleY(0.9)
    btnButton:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtOk_WndTeachOpenModule")):setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    self.m_mFingerX = 0.95
end

--@brief    越南语适配函数
--@note     越南语适配函数
function WndTeachOpenModule:_adaptLanguage_vn()
    WZLog("WndTeachOpenModule:_adaptLanguage_vn")

    WZUI9Image:luaTo(GetElement(self.m_root,"imgOpen_WndTeachOpenModule")):setScaleX(1.3)
    
    local conButton = WZUIContainer:luaTo(GetElement(self.m_root,"conButton_WndTeachOpenModule"))
    conButton:setRelativePosition(GlobalMethod:ccp(0.5,0.45))
    
    local btnButton = WZUIButton:luaTo(GetElement(self.m_root,"btnOk_WndTeachOpenModule"))
    btnButton:setScaleX(1.4)
    btnButton:setScaleY(0.9)
    btnButton:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtOk_WndTeachOpenModule")):setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    self.m_mFingerX = 0.95
end

--@brief    葡语适配函数
--@note     葡语适配函数
function WndTeachOpenModule:_adaptLanguage_pt()
    WZLog("WndTeachOpenModule:_adaptLanguage_pt")

    WZUI9Image:luaTo(GetElement(self.m_root,"imgOpen_WndTeachOpenModule")):setScaleX(1.4)
    
    local conButton = WZUIContainer:luaTo(GetElement(self.m_root,"conButton_WndTeachOpenModule"))
    conButton:setRelativePosition(GlobalMethod:ccp(0.5,0.45))
    
    local btnButton = WZUIButton:luaTo(GetElement(self.m_root,"btnOk_WndTeachOpenModule"))
    btnButton:setScaleX(1.4)
    btnButton:setScaleY(0.9)
    btnButton:setRelativePosition(GlobalMethod:ccp(0.5,0.49))
    
    WZUI9Image:luaTo(GetElement(self.m_root,"imgButton_WndTeachOpenModule")):setScaleX(1.3)
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtOk_WndTeachOpenModule")):setRelativePosition(GlobalMethod:ccp(0.5,0.49))

    WZUI9Image:luaTo(GetElement(self.m_root,"imgName_WndTeachOpenModule")):setScaleX(1.2)

    self.m_mFingerX = 0.95
end