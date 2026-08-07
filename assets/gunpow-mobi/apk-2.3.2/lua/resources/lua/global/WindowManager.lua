--WindowManager.lua
--@brief	窗口统一管理表对象
--@date  	2013/12/18
--@author 	xiaoyu_wu
--@note 	统一管理窗口的弹出与移出

WindowManager = {
	m_sceneRoot = nil,	--当前场景的根节点
	m_tWndLuaObjStack = {},	--存储当前所有弹出的窗口绑定的Lua表对象，是一个先进先出的堆栈，第一个为当前显示的窗口
    m_nZOrderOffset = 10000, --起始zorder偏移，所有加入到场景的窗口都会加上这个偏移
    m_chat =  nil,
}

-------------------------------------公有方法模块--------------------------------------
--@brief	设置场景根节点
--@param	sceneRoot，场景根节点的引用
--@note		在replaceScene的时候自动调用，无需各个模块自己调用
function WindowManager:setSceneRoot(sceneRoot)
    sceneRoot:retain()
    if self.m_sceneRoot then
        self.m_sceneRoot:release()
    end
	self.m_sceneRoot = sceneRoot
	self.m_tWndLuaObjStack = {}
end

--@brief	获取场景根节点
--@return	#1,场景根节点
function WindowManager:getSceneRoot()
	return self.m_sceneRoot
end

--@brief	判断窗口是否为活动窗口(第一窗口)
--@param	tWndLuaObj,要判断的窗口绑定的lua表对象
--@return	#1,是否处于活动状态
function WindowManager:ifActiveWindow(tWndLuaObj)
	if tWndLuaObj == self.m_tWndLuaObjStack[1] then
		return true
	else
		return false
	end
end

--@brief    获取(第一窗口)
--@param    tWndLuaObj,要判断的窗口绑定的lua表对象
--@return   #1,获取第一窗口
function WindowManager:getActiveWindow()
    if self.m_tWndLuaObjStack[1] == nil then
        return nil 
    end

    return self.m_tWndLuaObjStack[1]
end

--@brief	判断当前场景是否处于活动状态
--@return	#1,是否处于活动状态
function WindowManager:ifSceneActive()
	if #self.m_tWndLuaObjStack == 0 then
		return true
	else
		return false
	end
end

--@brief	判断窗口是否存在在当前场景中
--@param	tWndLuaObj,要判断的窗口绑定的lua表对象
--@return	#1,窗口是否存在在当前场景中
function WindowManager:ifWindowExist(tWndLuaObj)
	if self.m_tWndLuaObjStack == nil or self.m_sceneRoot == nil then
		return false
	end
	
	for i,v in ipairs(self.m_tWndLuaObjStack) do
		if v == tWndLuaObj then
			return true
		end
	end
	return false
end

--@brief	检查窗口是否加载弹跳动画
function WindowManager:checkWindow(bAction,wndElement)
	local absSize = WZUIElementContainer:luaTo(wndElement):getAbsContentSize()
	--如果机器分辨率小于等于1136*640就不弹动画
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("directorSize::",directorSize.width,directorSize.height)
	if directorSize and directorSize.width<= 1136 and directorSize.height<=640 then
		return false
	end
	--如果 窗口满屏或是提示框或是聊天框就不弹动画
	if absSize == nil or absSize.width >= 1136 or absSize.height >= 640 or absSize.width == 0 then
		return false
	elseif wndElement:getName() == "WndLoadingBox" then
		return false
	elseif  wndElement:getName() == "WndChat" then
		return false
	elseif bAction == false then
		return false
	else
		return false
	end
end

--@brief	添加窗口到场景
--@param	wndElement，窗口的节点引用
--@param	wndLuaObj，窗口绑定的Lua表对象
--@param    bShowAll，是否showAll
--@note		添加一个窗口到场景
function WindowManager:addWindow(wndElement,wndLuaObj,bShowAll,bAction,bNoShelter,bBlackBg)
    WZLog("WindowManager:addWindow",wndElement:getName(),tostring(wndElement),tostring(wndLuaObj),tostring(bShowAll))
	if self.m_sceneRoot == nil or wndElement == nil or wndLuaObj == nil then
		return
	end
	WZTempLog("打开的界面....: ",wndElement:getName())
    local nZOrder = wndElement:getZOrder() + self.m_nZOrderOffset
    wndElement:setZOrder(nZOrder)
    local nIndex = self:_getStackIndexByZorder(nZOrder)
	if wndLuaObj ~= nil and wndLuaObj ~= WndChat and wndLuaObj ~= WndCurrentChat and bNoShelter ~= true then
		WindowManager:_addShelterImgOnWnd(wndElement)
	end
	local needAdd = true
	if bBlackBg == true and needAdd then
		local blackImg = WZUIImage:create() --CCSprite:create("common/Jigsaw/black_bg.png")
        blackImg:setFile("ui/common/common_black_bg.png")
		blackImg:setZOrder(-100)
        blackImg:setOpacity(150)
        blackImg:setScaleX(15)
        blackImg:setScaleY(30)
		blackImg:setName("wnd_black_bg___")
        wndLuaObj.m_has_wnd_black_bg = true
		wndElement:addChild(blackImg)
	end
	wndLuaObj.___setVisible = false
    if self:isFullWindow(wndLuaObj) then 
        for i,v in ipairs(self.m_tWndLuaObjStack) do
            if v.m_root ~= nil and v.m_root:isVisible() == true then
                v.m_root:setVisible(false)
                v.___setVisible = true
            end
        end
    end
    table.insert(self.m_tWndLuaObjStack, nIndex, wndLuaObj)
	
    local sceneLuaObj = self.m_sceneRoot:getLuaObjectIndex()
    if bShowAll ~= nil then
        wndElement:setShowAll(bShowAll)
        self.m_sceneRoot:addChild(wndElement)
        --针对特殊分辨率屏幕将界面拉伸
		--ScaleToAdjustSpecialScreen(wndElement)
    else
        if sceneLuaObj ~= nil and sceneLuaObj.m_root ~= nil and sceneLuaObj.addChild ~= nil then 
			--如果场景本身提供了添加子元素的方法则使用场景自己的添加方法
            --WZLog("WindowManager:addWindow44")
            sceneLuaObj:addChild(wndElement)
            if wndLuaObj ~= nil and wndLuaObj.getRootPanel and bAction and type(bAction) == "table" then
                local _type = bAction.type
                local main_panel = wndLuaObj:getRootPanel()
                main_panel:setUseAbsCoordinate(true)
                if _type == 1 then --从左到右
                    main_panel:setAbsPosition(ccp(-568,320))
                    local array = CCArray:create()
                    array:addObject(CCMoveTo:create(0.15, ccp(568,320)))
                    array:addObject(CCFadeIn:create(0.15))
                    main_panel:runAction(CCSpawn:create(array))
                elseif _type == 2 then

                end
            end
        else
        	WZLog("WindowManager:addWindow55")
            self.m_sceneRoot:addChild(wndElement)
        end
    end
    if bBlackBg == true then 
        WindowManager:disappearWndBlackImg(wndElement)
    end
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1,#self.m_tWndLuaObjStack do
            local obj = self.m_tWndLuaObjStack[i]
            if obj.m_root ~= nil and obj.___setVisible == true then 
                obj.m_root:setVisible(true)
                obj.___setVisible = false
            end
            if obj.m_root ~= nil and self:isFullWindow(obj) and obj.m_root:isVisible() == true then 
                break
            end
        end
    end
    local hasFullScreenWnd = false
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1,#self.m_tWndLuaObjStack do
            local obj = self.m_tWndLuaObjStack[i]
            if obj.m_root ~= nil and self:isFullWindow(obj) then 
                hasFullScreenWnd = true
            end
        end
    end
    if  SceneCity ~= nil then
        if hasFullScreenWnd == true then 
            SceneCity:unsivibleWithFullScreenWnd()
        else
            SceneCity:visibleWithoutFullScreenWnd()
        end
    end
end

--@brief	从场景中移出窗口
--@param	wndElement，窗口的节点引用
--@param	wndLuaObj，窗口绑定的Lua表对象
--@param	bIfCleanup，是否清除动作及回调函数
--@note		从场景中移出窗口
function WindowManager:removeWindow(wndElement,wndLuaObj,bIfCleanup,bAction)
	if self.m_sceneRoot == nil or wndElement == nil or wndLuaObj == nil then
		return
	end
    if bIfCleanup == nil then
        bIfCleanup = true
    end
	self:_closeWindows(wndElement, wndLuaObj, bIfCleanup)
	--WZLog("WindowManager,REMOVE",debug.traceback())
	 WZLog("WindowManager:childnum123",self.m_sceneRoot:getChildrenCount())
	 WZLog("WindowManager:childnum12345",self.m_sceneRoot:getChildByTag(32),self.m_sceneRoot:getChildByTag(5147))
	 WZLog("ischatfirst123",self:ifActiveWindow(WndChat),self:ifWindowExist(WndChat))
end

--@brief	移除所有窗口
function WindowManager:removeAllWindow()
    if self.m_sceneRoot == nil then
        return
    end
    for i,v in ipairs(self.m_tWndLuaObjStack) do
        if v.m_root then
            v.m_root:setZOrder(v.m_root:getZOrder() - self.m_nZOrderOffset)
            v.m_root:removeFromParentAndCleanup(true)
        end
    end
     WZLog("ischatfirst1234",self:ifActiveWindow(WndChat),self:ifWindowExist(WndChat))
    self:_removeShelterImgFromScene()
    self.m_tWndLuaObjStack = {}

end

--@brief	关闭窗口动画完成回调函数
function WindowManager:closeBackFun(wndElement, wndLuaObj, bIfCleanup)
	WZLog("关闭窗口动画完成回调函数:::")
	self:_closeWindows(wndElement, wndLuaObj, bIfCleanup)
end

--@brief	为场景添加教学用的遮挡层
--@param    nZOrder,遮挡层的层次
function WindowManager:addTeachShelterLayer(nZOrder, opacity)
    --opacity = 255
    WZLog("WindowManager:addTeachShelterLayer one", self.m_sceneRoot, opacity)
    if self.m_sceneRoot == nil then
		return
	end

    local shelterLayer = WZUISystem:getInstance():createElement("TeachShelterLayer")
    if shelterLayer == nil then
        WZLog("create TeachShelterLayer from xml fail!")
        return
    end
    if opacity then
        GetElement(shelterLayer, "imgBlack_TeachShelterLayer", WZUIImage):setOpacity(opacity)
    end
    shelterLayer:setZOrder(nZOrder)
    self.m_sceneRoot:addChild(shelterLayer)
    WZLog("WindowManager:addTeachShelterLayer two")
    return shelterLayer
end

--@brief	移除场景里教学用的遮挡层
function WindowManager:removeTeachShelterLayer()
	WZLog("WindowManager:removeTeachShelterLayer one", tostring(self.m_sceneRoot))

    if self.m_sceneRoot == nil then
		return
	end
	local shelterLayer = self.m_sceneRoot:getChildElement("TeachShelterLayer")
	WZLog("WindowManager:removeTeachShelterLayer two", tostring(self.m_sceneRoot), tostring(shelterLayer))
	if shelterLayer == nil then
		return
	end
	shelterLayer:removeFromParentAndCleanup(true)
end

--@brief	场景里教学用的遮挡层
function WindowManager:getTeachShelterLayer()
	WZLog("WindowManager:getTeachShelterLayer one", tostring(self.m_sceneRoot))
    if self.m_sceneRoot == nil then
		return
	end
	local shelterLayer = self.m_sceneRoot:getChildElement("TeachShelterLayer")
	WZLog("WindowManager:getTeachShelterLayer two", tostring(self.m_sceneRoot), tostring(shelterLayer))
	if shelterLayer == nil then
		return
	end
	return shelterLayer
end

--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachTouchLayerForElement(element, touchSize)
    WZLog("WindowManager:addTeachTouchLayerForElement one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
    if renderCon == nil then
		return
	end

    local scale = 1
    local pos = GlobalMethod:ccp(element:getPositionX(), element:getPositionY())
    pos = element:getParentElement():convertToWorldSpace(pos)
	--创建裁剪图片
    local imgTeachClip = WZUISystem:getInstance():createElement("ImgTeachClip")
    local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize = element:getContentSize()
    imgTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.height*scale/sceneSize.height))
    renderCon:addChild(imgTeachClip)
    local anchorPt = element:getAnchorPoint()
    pos.x = pos.x + (0.5 - anchorPt.x)*elementSize.width
    pos.y = pos.y + (0.5 - anchorPt.y)*elementSize.height
    imgTeachClip:setPosition(pos)

    WZLog("WindowManager:addTeachTouchLayerForElement touchSize:",touchSize.width, touchSize.height, " anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, " elementSize:", elementSize.width, elementSize.height, " sceneSize:", sceneSize.width, sceneSize.height, " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y, " element:getPosition:", element:getPositionX(), element:getPositionY())

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    wndTeachTouch:setAbsContentSize(touchSize)
    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)
end

--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachTouchLayerForBuilding(element, contentSize, touchSize, isVisible, offset)
    WZLog("WindowManager:addTeachTouchLayerForBuilding one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	if renderCon == nil then
		return
	end
	local textCon = GetElement(self.m_sceneRoot, "conText_TeachShelterLayer" , WZUIContainer)
	

	if isVisible == nil then
		isVisible = true
	end
	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(isVisible)

	local sceneSize = self.m_sceneRoot:getContentSize()
	local elementSize = contentSize or element:getAbsContentSize()
	local anchorPt = element:getAnchorPoint()

	offset = offset or GlobalMethod:ccp(0,0)
	WZLog("WindowManager:addTeachTouchLayerForBuilding one", tostring(isVisible),offset.x,offset.y)

    local scale = 1
    local touchScale = 1.2
    local pos = GlobalMethod:ccp(element:getPositionX(), element:getPositionY())
    local posImage
    local posOri = element:getParentElement():convertToWorldSpace(pos)

    --创建裁剪图片
    local imgTeachClip = WZUISystem:getInstance():createElement("ImgTeachClip")
    imgTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.height*scale/sceneSize.height))
    renderCon:addChild(imgTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    imgTeachClip:setPosition(pos)
    WZLog("WindowManager:addTeachTouchLayerForBuilding four")

    ---[[
    local armaTeachClip = WZUISystem:getInstance():createElement("armaBtn_TeachShelterLayer")
    local size = armaTeachClip:getRelativeSize()
    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.height*scale/sceneSize.height))
    textCon:addChild(armaTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armaTeachClip:setPosition(pos)
    --]]

    WZLog("WindowManager:addTeachTouchLayerForBuilding three",element:getPositionX(), element:getPositionY(),posOri.x,posOri.y,anchorPt.x,anchorPt.y,elementSize.width,elementSize.height,offset.x,offset.y)

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    if isVisible == true then
    	touchSize = touchSize and GlobalMethod:CCSize(touchSize.width * touchScale, touchSize.height * touchScale) or GlobalMethod:CCSize(armaTeachClip:getContentSize().width * touchScale,armaTeachClip:getContentSize().width * touchScale)
    	wndTeachTouch:setAbsContentSize(touchSize)
    else
    	wndTeachTouch:setAbsContentSize(GlobalMethod:CCSize(1136,640))
    	wndTeachTouch:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    	pos = GlobalMethod:ccp(480,320)
    end
    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)
    WZLog("WindowManager:addTeachTouchLayerForBuilding two anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, " elementSize:", elementSize.width, elementSize.height, " sceneSize:", sceneSize.width, sceneSize.height, " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y, " element:getPosition:", element:getPositionX(), element:getPositionY(), " touchSize:", touchSize.width, touchSize.height, " isVisible:", isVisible)

    return armaTeachClip
end


--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachTouchLayerForButton(element, contentSize, touchSize, offset, screen)
    WZLog("WindowManager:addTeachTouchLayerForButton one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	
	if renderCon == nil then
		return
	end

	local textCon = GetElement(self.m_sceneRoot, "conText_TeachShelterLayer" , WZUIContainer)
	offset = offset or GlobalMethod:ccp(0,0)

	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(true)
	local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize
    if contentSize ~= nil then
        elementSize = contentSize
    elseif element.getAbsContentSize ~= nil then
        elementSize = element:getAbsContentSize()
    else
        elementSize = element:getContentSize()
    end
	local anchorPt = element:getAnchorPoint()

    local scale = 1
    local touchScale = 1.5
    local pos = GlobalMethod:ccp(screen and (element:getPositionX() / FigureSceneManager:getInstance().m_nScreenWidth * 1136) or element:getPositionX(), element:getPositionY())
    local posOri = element:getParentElement():convertToWorldSpace(pos)

	--创建裁剪图片
    local imgTeachClip = WZUISystem:getInstance():createElement("ImgTeachClip")
    imgTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width * 0.95, elementSize.width*scale/sceneSize.width * 0.95))
    renderCon:addChild(imgTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    imgTeachClip:setPosition(pos)

    -- --创建裁剪图片
    -- local imgTeachClip2 = WZUISystem:getInstance():createElement("ImgTeachClip")
    -- imgTeachClip2:setRelativeSize(GlobalMethod:CCSize(0.2, 0.2))
    -- renderCon:addChild(imgTeachClip2)
    -- pos.x = 480
    -- pos.y = 320
    -- imgTeachClip2:setPosition(pos)

    ---[[
    local armaTeachClip = WZUISystem:getInstance():createElement("armaBtn_TeachShelterLayer")
    local size = armaTeachClip:getRelativeSize()
    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.width*scale/sceneSize.width))
    textCon:addChild(armaTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armaTeachClip:setPosition(pos)
    --]]

    --[[
    local anim = BattleAnimation:createAnimation("finger1", false, "teach")
    local armature = anim.m_node
	armature:setUseOriginSize(true)
	armature:setAnchorPoint(GlobalMethod:ccp(-0.2,1))
	armature:setTouchEnable(false)
	renderCon:addChild(armature,0,5)
	pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armature:setPosition(pos)
    --armature:setScale(0.2)
    anim:play("click",true)
	--]]

    WZLog("WindowManager:addTeachTouchLayerForButton anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, 
        " imgTeachClip:getContentSize:", imgTeachClip:getContentSize().width, imgTeachClip:getContentSize().height,
        " imgTeachClip:getRelativeSize:", imgTeachClip:getRelativeSize().width, imgTeachClip:getRelativeSize().height,
        " elementSize:", elementSize.width, elementSize.height, " sceneSize:", sceneSize.width, sceneSize.height, 
        " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y,
         " element:getPosition:", element:getPositionX(), element:getPositionY(), 
         " armaTeachClip:getContentSize:", armaTeachClip:getContentSize().width, armaTeachClip:getContentSize().height, 
         " offset:", offset.x, offset.y, " touchSize:", touchSize and touchSize.width, touchSize and touchSize.height)

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    
    touchSize = touchSize and GlobalMethod:CCSize(touchSize.width * touchScale, touchSize.height * touchScale) or GlobalMethod:CCSize(armaTeachClip:getContentSize().width * touchScale,armaTeachClip:getContentSize().width * touchScale)
    wndTeachTouch:setAbsContentSize(touchSize)
    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)

    return armaTeachClip, textCon
end

--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachTouchLayerForArea(element, contentSize, touchSize, offset, bgSize, bgOffset, screen)
    WZLog("WindowManager:addTeachTouchLayerForArea one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	
	if renderCon == nil then
		return
	end

	local textCon = GetElement(self.m_sceneRoot, "conText_TeachShelterLayer" , WZUIContainer)
	offset = offset or GlobalMethod:ccp(0,0)

	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(true)
	local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize
    if contentSize ~= nil then
        elementSize = contentSize
    elseif element.getAbsContentSize ~= nil then
        elementSize = element:getAbsContentSize()
    else
        elementSize = element:getContentSize()
    end
	local anchorPt = element:getAnchorPoint()

    local scale = 1
    local touchScale = 1.5
    local pos = GlobalMethod:ccp(screen and (element:getPositionX() / FigureSceneManager:getInstance().m_nScreenWidth * 1136) or element:getPositionX(), element:getPositionY())
    local posOri = element:getParentElement():convertToWorldSpace(pos)

	--创建裁剪图片
    local imgTeachClip = WZUISystem:getInstance():createElement("ImgTeachClip")
    imgTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width * 1.1, elementSize.width*scale/sceneSize.width * 1.1))
    renderCon:addChild(imgTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    imgTeachClip:setPosition(pos)

    ---[[
    local armaTeachClip = WZUISystem:getInstance():createElement("armaBtnSqure_TeachShelterLayer")
    local size = armaTeachClip:getRelativeSize()
    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.width*scale/sceneSize.width))
    textCon:addChild(armaTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armaTeachClip:setPosition(pos)
    --]]

    --[[
    local anim = BattleAnimation:createAnimation("finger1", false, "teach")
    local armature = anim.m_node
	armature:setUseOriginSize(true)
	armature:setAnchorPoint(GlobalMethod:ccp(-0.2,1))
	armature:setTouchEnable(false)
	renderCon:addChild(armature,0,5)
	pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armature:setPosition(pos)
    --armature:setScale(0.2)
    anim:play("click",true)
	--]]

    WZLog("WindowManager:addTeachTouchLayerForButton anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, " elementSize:", elementSize.width, elementSize.height, " sceneSize:", sceneSize.width, sceneSize.height, " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y, " element:getPosition:", element:getPositionX(), element:getPositionY(), " armaTeachClip:getContentSize:", armaTeachClip:getContentSize().width, armaTeachClip:getContentSize().height, " offset:", offset.x, offset.y, " touchSize:", touchSize and touchSize.width, touchSize and touchSize.height)

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    
    touchSize = touchSize and GlobalMethod:CCSize(touchSize.width * touchScale, touchSize.height * touchScale) or GlobalMethod:CCSize(armaTeachClip:getContentSize().width * touchScale,armaTeachClip:getContentSize().width * touchScale)
    wndTeachTouch:setAbsContentSize(touchSize)
    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)

    return armaTeachClip, textCon
end

--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachTouchLayerForArea0(element, contentSize, touchSize, offset, bgSize, bgOffset)
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	if renderCon == nil then
		return
	end

	local textCon = GetElement(self.m_sceneRoot, "conText_TeachShelterLayer" , WZUIContainer)
	offset = offset or GlobalMethod:ccp(0,0)
	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(false)

	local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize
    if contentSize ~= nil then
        elementSize = contentSize
    end
	local anchorPt = element:getAnchorPoint()

    local scale = 1
    local touchScale = 1.5
    local pos = GlobalMethod:ccp(element:getPositionX(), element:getPositionY())
    local posOri = element:getParentElement():convertToWorldSpace(pos)

    WZLog("WindowManager:addTeachTouchLayerForArea", tostring(contentSize))
    local imgTeachClip
    local armaTeachClip
    local size
    if contentSize ~= nil then
    	--[[
		--创建裁剪图片
	    imgTeachClip = WZUIImage:luaTo(WZUISystem:getInstance():createElement("ImgTeachClip"))
	    imgTeachClip:setUseOriginSizeProportion(false)
	    imgTeachClip:setFile("ui/common/024.png")
	    local bgRelativeSize = GlobalMethod:CCSize(bgSize.width*scale/sceneSize.width * 0.8, bgSize.height*scale/sceneSize.width * 0.8)
	    imgTeachClip:setRelativeSize(bgRelativeSize)
	    renderCon:addChild(imgTeachClip)
	    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + bgOffset.x
	    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + bgOffset.y
	    imgTeachClip:setPosition(pos)
		--]]

	    ---[[
	    armaTeachClip = WZUISystem:getInstance():createElement("armaArea_TeachShelterLayer")
	    local size = armaTeachClip:getRelativeSize()
	    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.width*scale/sceneSize.width))
	    textCon:addChild(armaTeachClip)
	    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
	    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
	    armaTeachClip:setPosition(pos)
	    --]]

	    --[[
	    armaTeachClip = WZUISystem:getInstance():createElement("conImg9_TeachShelterLayer")
	    size = armaTeachClip:getRelativeSize()
	    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.height*scale/sceneSize.width))
	    renderCon:addChild(armaTeachClip)
	    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
	    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
	    armaTeachClip:setPosition(pos)
		--]]

	    --WZLog("WindowManager:addTeachTouchLayerForArea anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, " bgSize:", bgSize.width, bgSize.height, " elementSize:", elementSize.width, elementSize.height, " sceneSize:", sceneSize.width, sceneSize.height, " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y, " element:getPosition:", element:getPositionX(), element:getPositionY(), " armaTeachClip:getContentSize:", armaTeachClip:getContentSize().width, armaTeachClip:getContentSize().height, " offset:", offset.x, offset.y, " touchSize:", touchSize and touchSize.width, touchSize and touchSize.height)
	end

	
    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    
    wndTeachTouch:setAbsContentSize(GlobalMethod:CCSize(1136,640))
	wndTeachTouch:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	pos = GlobalMethod:ccp(480,320)

    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)

    return armaTeachClip
end

--@brief	教学演示
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTeachShow(element, aniName, isArmature, actionName, teachGroupId, teachStepId, isBattle, text, offset, mainId)
    WZLog("WindowManager:addTeachShow one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	local ttfCon = self.m_sceneRoot:getChildElement("conShow_TeachShelterLayer")
	
	if renderCon == nil then
		return
	end
	offset = offset or GlobalMethod:ccp(0,0)

	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setOpacity(150)
	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(true)
	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setTouchEnable(true)
	GetElement(renderCon, "conShow_TeachShelterLayer" , WZUIContainer):setVisible(true)
	GetElement(renderCon, "txtDesc_TeachShelterLayer" , WZUILabelTTF):setText(text)
	GetElement(renderCon, "txtContinue_TeachShelterLayer" , WZUILabelTTF):setText(TeachGroup1:getTeachText(106))
	local sceneSize = self.m_sceneRoot:getContentSize()

	local anchorPt = element:getAnchorPoint()

    local scale = 1
    local touchScale = 1.5
    

    --[[
    local armaTeachClip = WZUISystem:getInstance():createElement("armaBtn_TeachShelterLayer")
    local size = armaTeachClip:getRelativeSize()
    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.width*scale/sceneSize.width))
    renderCon:addChild(armaTeachClip)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armaTeachClip:setPosition(pos)
    --]]

    local folder = "teach"

    local armaTeachClipList = {}
    for i,name in ipairs (aniName) do
    	local folderPath = folder
    	local scale = 1
    	if name == "skill_power_qiangpao" then
    		folderPath = "battle/skill"
    		scale = 0.3
    	end

    	local pos = GlobalMethod:ccp(568+offset[i][1],400+offset[i][2])
    	local armaTeachClip = BattleAnimation:createAnimation(name,isArmature,folderPath,TeachGroup1)
	    armaTeachClip:getAnimNode():setUseAbsCoordinate(true)
	    armaTeachClip:getAnimNode():setUseOriginSizeProportion(true)
	    armaTeachClip:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	    armaTeachClip:getAnimNode():setScale(scale)
	    armaTeachClip:getAnimNode():setAbsPosition(pos)
	    armaTeachClip:getAnimNode():setTouchEnable(false)
	    WZLog("WindowManager:addTeachShow 0", i, tostring(mainId), tostring(armaTeachClip:getAnimNode().setLuaSpineEventFunc))
	    ttfCon:addChild(armaTeachClip:getAnimNode())
	    armaTeachClip:play(isArmature and "0" or (actionName[i] or "animation"), false)
	    table.insert(armaTeachClipList,armaTeachClip)
	    WZLog("WindowManager:addTeachShow 1", i, armaTeachClip, name, actionName[i], tostring(isArmature), offset[i][1], offset[i][2])
	    
	end

    --WZLog("WindowManager:addTeachShow anchorPt:", anchorPt.x, anchorPt.y, " pos:", pos.x, pos.y, " sceneSize:", sceneSize.width, sceneSize.height, " element:getRelativePosition:", element:getRelativePosition().x, element:getRelativePosition().y, " element:getPosition:", element:getPositionX(), element:getPositionY(), " armaTeachClip:getContentSize:", armaTeachClip:getContentSize().width, armaTeachClip:getContentSize().height, " offset:", offset.x, offset.y, " touchSize:", touchSize and touchSize.width, touchSize and touchSize.height)

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    
    wndTeachTouch:setAbsContentSize(GlobalMethod:CCSize(1136,960))
	wndTeachTouch:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	local pos = GlobalMethod:ccp(480,320)

    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)

    return armaTeachClipList, ttfCon
end

--@brief	为节点元素添加提示
--@param    element,节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTipForButton(element, contentSize, offset, text, dire, textOffset, textLength, elementText, animName, isOriScale)
	WZLog("WindowManager:addTipForButton one", tostring(self.m_sceneRoot), tostring(element))
    if element == nil then
		return
	end
	offset = offset or GlobalMethod:ccp(0,0)
	local pos = GlobalMethod:ccp(0,0)

	local armaTeachClip = BattleAnimation:createAnimation("zhiyin_dianji_anniu_01",true, "teach")
    armaTeachClip:getAnimNode():setScale(contentSize)
    element:addChild(armaTeachClip:getAnimNode(),99)
    armaTeachClip:getAnimNode():setTouchEnable(false)
    armaTeachClip:play(animName or "0",true)
    pos.x = offset.x
    pos.y = offset.y
    armaTeachClip:getAnimNode():setPosition(pos)

    element = elementText or element
    local dialog = Teach:showDialog( element , element , TeachGroup1:getTeachText(text) , dire , textOffset, 1, textLength,nil , isOriScale )
    return armaTeachClip:getAnimNode(), dialog
end

--@brief	为教学节点元素添加可触摸层
--@param    element,教学节点元素
--@param    touchSize,可触摸范围
function WindowManager:addTipForBattle(element, contentSize, offset, text, dire, textOffset, textLength, elementText)
	WZLog("WindowManager:addTipForBattle")
    if self.m_sceneRoot == nil or element == nil then
		return
	end
	local renderCon = self.m_sceneRoot:getChildElement("RenderCon_TeachShelterLayer")
	if renderCon == nil then
		return
	end
	offset = offset or GlobalMethod:ccp(0,0)

	GetElement(renderCon, "imgBlack_TeachShelterLayer" , WZUIImage):setVisible(false)
	local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize
    if contentSize ~= nil then
        elementSize = contentSize
    elseif element.getAbsContentSize ~= nil then
        elementSize = element:getAbsContentSize()
    else
        elementSize = element:getContentSize()
    end
	local anchorPt = element:getAnchorPoint()

    local scale = 1
    local touchScale = 1.5
    local pos = GlobalMethod:ccp(element:getPositionX(), element:getPositionY())
    local posOri = element:getParentElement():convertToWorldSpace(pos)

    ---[[
    local armaTeachClip = WZUISystem:getInstance():createElement("armaBtn_TeachShelterLayer")
    local size = armaTeachClip:getRelativeSize()
    armaTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.width*scale/sceneSize.width))
    renderCon:addChild(armaTeachClip)
    armaTeachClip:setTouchEnable(false)
    pos.x = posOri.x + (0.5 - anchorPt.x)*elementSize.width + offset.x
    pos.y = posOri.y + (0.5 - anchorPt.y)*elementSize.height + offset.y
    armaTeachClip:setPosition(pos)
    --]]

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_TeachShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    
    wndTeachTouch:setAbsContentSize(GlobalMethod:CCSize(1136,960))
	wndTeachTouch:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	pos = GlobalMethod:ccp(480,320)

    clipCon:addChild(wndTeachTouch)
    wndTeachTouch:setPosition(pos)

    element = elementText or element
    local dialog = Teach:showDialog( armaTeachClip , armaTeachClip , TeachGroup1:getTeachText(text) , dire , textOffset, 1, textLength )

    return armaTeachClip, dialog
end

--@brief	移除教学遮挡层中的触摸层
function WindowManager:removeTeachTouchLayer()
    if self.m_sceneRoot == nil then
		return
	end
    
	local imgTeachClip = self.m_sceneRoot:getChildElement("ImgTeachClip")
	if imgTeachClip ~= nil then
		imgTeachClip:removeFromParentAndCleanup(true)
	end
    
    local wndTeachTouch = self.m_sceneRoot:getChildElement("WndTeachTouch")
	if wndTeachTouch ~= nil then
		wndTeachTouch:removeFromParentAndCleanup(true)
	end
end

--@brief	是否存在教学遮挡层中的触摸层
function WindowManager:isHaveTeachTouchLayer()
    if self.m_sceneRoot == nil then
		return false
	end
    
    local wndTeachTouch = self.m_sceneRoot:getChildElement("WndTeachTouch")
	if wndTeachTouch ~= nil then
		return true
	end
end

--@brief	设置教学遮挡层中的触摸层的触摸响应方法
--@param    tLuaObj, 响应方法所在的lua表
--@param    sTouchBeganFunc, 触摸开始时的响应方法
--@param    sTouchMovedFunc, 触摸移动时的响应方法
--@param    sTouchEndedFunc, 触摸结束时的响应方法
function WindowManager:setTeachTouchCallBack(tLuaObj, sTouchBeganFunc, sTouchMovedFunc, sTouchEndedFunc, sTouchMovedoutFunc, sWndName, sImgName)
	sWndName = sWndName or "WndTeachTouch"
	sImgName = sImgName or "imgTeachTouch"
    local wndTeachTouch = self.m_sceneRoot:getChildElement(sWndName)
	if wndTeachTouch == nil then
		return
	end
    wndTeachTouch:setLuaObjectIndex(tLuaObj)
    local imgTeachTouch = GetElement(wndTeachTouch, sImgName, WZUIImage)
    imgTeachTouch:setLuaTouchBeganFunction(sTouchBeganFunc)
    imgTeachTouch:setLuaTouchMovedFunction(sTouchMovedFunc)
    imgTeachTouch:setLuaTouchEndedFunction(sTouchEndedFunc)
    imgTeachTouch:setLuaTouchMoveoutFunction(sTouchMovedoutFunc)
end

-------------------------------------私有方法模块--------------------------------------
--@brief	在主场景上增加透明的遮挡图片
--@note		在主场景上增加透明的遮挡图片用于遮挡触摸事件，在主场景上第一次弹出窗口的时候调用
function WindowManager:_addShelterImgOnScene()
	if self.m_sceneRoot == nil then
		return
	end
	
	local imgShelter = WZUIImage:create()
	imgShelter:setFile("ui/common/transparent_bg.png")
	imgShelter:setName("imgShelter_WindowManager")
    imgShelter:setZOrder(self.m_nZOrderOffset)
	self.m_sceneRoot:addChild(imgShelter)
	
	local sceneLuaObj = self.m_sceneRoot:getLuaObjectIndex()
	if sceneLuaObj and sceneLuaObj.activeStateDidChanged then
		sceneLuaObj:activeStateDidChanged(false)
	end
end

--@brief	在窗口下面添加遮挡图层
--@note		在窗口下面增加透明的遮挡图片用于遮挡触摸事件，在窗口下面第一次弹出窗口的时候调用
function WindowManager:_addShelterImgOnWnd(wndElement)
	if wndElement == nil then
		return
	end
	WZLog("WindowManager:_addShelterImgOnWnd",wndElement)
	local imgShelter = WZUIImage:create()
	imgShelter:setFile("ui/common/transparent_bg.png")
	--imgShelter:setFile("common/Jigsaw/0.png")
	imgShelter:setName("imgShelter_WindowManager")
    imgShelter:setZOrder(-1000)
	imgShelter:setRelativeSize(CCSizeMake(100,100))
	imgShelter:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	wndElement:addChild(imgShelter)
end

--@brief	移除主场景上的透明遮挡图片
--@note		移除主场景上的透明遮挡图片，在主场景中最后一个窗口被移出时调用
function WindowManager:_removeShelterImgFromScene()
	WZLog("WindowManager:_removeShelterImgFromScene")
	if self.m_sceneRoot == nil then
		return
	end
	local imgShelter = self.m_sceneRoot:getChildElement("imgShelter_WindowManager")
	if imgShelter == nil then
		return
	end
	imgShelter:removeFromParentAndCleanup(true)
	
	local sceneLuaObj = self.m_sceneRoot:getLuaObjectIndex()
	if sceneLuaObj and sceneLuaObj.activeStateDidChanged then
		sceneLuaObj:activeStateDidChanged(true)
	end
end

--@brief	根据ZOrder获取在窗口栈里面的位置
--@param	nZOrder，层次
--@note		在窗口栈里面的位置
function WindowManager:_getStackIndexByZorder(nZOrder)
    for i,v in ipairs(self.m_tWndLuaObjStack) do
        if v.m_root ~= nil then
            local nCurZOrder = v.m_root:getZOrder()
            if nZOrder >= nCurZOrder then
                return i
            end
        end
    end
    return #self.m_tWndLuaObjStack + 1
end

--@brief	设置第一个窗口是否接受触摸事件
--@param	bFlag，是否可触摸
--@note		设置第一个窗口是否接受触摸事件
function WindowManager:_setFirstWindowTouchEnable(bFlag)
	if self.m_sceneRoot == nil or self.m_tWndLuaObjStack[1] == nil then
		return
	end
	
	local wndLuaObj = self.m_tWndLuaObjStack[1]
	local wndElement = wndLuaObj.m_root
	if wndElement == nil then
		return
	end
	if wndLuaObj == WndChat  then
		WZLog("WindowManager:_setFirstWindowTouchEnable ",wndLuaObj,WndChat)
		WndChat:setConetextCon(bFlag)
	else
	    wndElement:setTouchEnable(bFlag)
	end



	if wndLuaObj.activeStateDidChanged ~= nil then
		wndLuaObj:activeStateDidChanged(bFlag)
	end
end

--@brief	关闭窗口
function WindowManager:_closeWindows(wndElement, wndLuaObj, bIfCleanup)
    
    local hasRemoveWindow = false
    local hasBackImg = false 
	if self.m_tWndLuaObjStack[1] == wndLuaObj then
        wndElement:setZOrder(wndElement:getZOrder() - self.m_nZOrderOffset)
		wndElement:removeFromParentAndCleanup(bIfCleanup)
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
		table.remove(self.m_tWndLuaObjStack, 1)
		hasRemoveWindow = true
		local firstWndLuaObj = self.m_tWndLuaObjStack[1]
		if firstWndLuaObj == nil then --没有窗口时
			self:_removeShelterImgFromScene()
		elseif firstWndLuaObj.m_root ~= nil then  --有窗口时
			self:_setFirstWindowTouchEnable(true)
		else --特殊情况处理
			table.remove(self.m_tWndLuaObjStack, 1)
		end
	else
		for i,v in ipairs(self.m_tWndLuaObjStack) do
			if v == wndLuaObj then
                wndElement:setZOrder(wndElement:getZOrder() - self.m_nZOrderOffset)
				wndElement:removeFromParentAndCleanup(bIfCleanup)
                CCTextureCache:sharedTextureCache():removeUnusedTextures()
				table.remove(self.m_tWndLuaObjStack, i)
                hasRemoveWindow = true
				break
			end
		end
	end
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1,#self.m_tWndLuaObjStack do
            local obj = self.m_tWndLuaObjStack[i]
            if obj.m_root ~= nil and obj.___setVisible == true then 
                obj.m_root:setVisible(true)
                obj.___setVisible = false
            end
            if obj.m_root ~= nil and self:isFullWindow(obj) and obj.m_root:isVisible() == true then 
                break
            end
        end
    end
    WindowManager:appearWndBlackImg()
    local hasFullScreenWnd = false
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1,#self.m_tWndLuaObjStack do
            local obj = self.m_tWndLuaObjStack[i]
            if obj.m_root ~= nil and self:isFullWindow(obj) then 
                hasFullScreenWnd = true
            end
        end
    end
    if  SceneCity ~= nil then
        if hasFullScreenWnd == true then 
            SceneCity:unsivibleWithFullScreenWnd()
        else
            SceneCity:visibleWithoutFullScreenWnd()
        end
    end
end

function WindowManager:hasMoreWindows()
	WZLog("WindowManager:hasMoreWindows",#self.m_tWndLuaObjStack)
	return #self.m_tWndLuaObjStack > 1
end

--@brief  判断一个窗口时否是全屏窗口
function WindowManager:isFullWindow(WndObj)
    if WndObj == nil then return false end
    if WndObj == WndChessActivities then return true end

    local tTempTable = {WndShop, WndBagMain, WndBless, WndFriends, WndRankList, WndStarSoul, WndMounts, WndPets, WndShop, WndStrengthen, WndPetRaffle, WndEquipmentLottery, WndCard, WndWakeup, WndDigGem, SceneRuneLockDraw, WndCopyEntry, WndRuneBook, WndChallengeEntrance, SceneCommunity, SceneCommunityTotem, SceneMemberList, WndMaster, WndAscending, WndFootMark, WndEquipmentLottery, WndMatchmaking, WndCheckOther, WndProfession, WndDressCastSoul, WndActivityIntegrate, WndCharmSpace, WndMagicStone, WndOneRechargeActivity, WndPeopleShop, WndNewYearActivityMain, WndFourStar, WndBlind, WndLibrary, WndRiseMainActivity, WndFishMain, WndPelletMain, WndShootArrow, WndTask, WndNewVip, WndSkillContainer, WndSetting, WndMail, WndTeachJumpTalk, WndMainHorary, WndNationalAnswer, WndNewYearMain, WndNationalFestival, WndDoubleSeven, WndTreasure, WndApartmentAct, WndWaterCountry, WndDecoration, WndHouseMain, CellPastureAnimal, WndNewYearWish, WndYearMonster, WndBeatEngineer, WndBeatMice, WndSetCircle, WndBluePrivilege, WndLobbyPrivilegesAct, WndGarden, WndWatermelon, WndSecretTower, WndMoneyTree, WndBilliardBall, WndDressGive, WndMidnightDiner, WndNewCuteList, WndGopherBall, WndBeingImmortal, WndCalabash, WndSpringOuting, WndBeatBalloon, WndDazzleRank, WndTeamConsume, WndSeafarRoad, WndPlanetSearch, WndZongZi, WndTrampoline, WndGolfball, WndWishingBottle, WndDetective, WndGongAndDrum, WndGoldMiner, WndDeepSea, WndAutumnCamp, WndHotBasketball, WndCatHouse, WndJewelry, WndEightYear}
    if utilsValueInTable(WndObj, tTempTable) then return true end

    return false
end

--@brief 窗口下面的半透明黑色背景不显示
function WindowManager:disappearWndBlackImg(element) 
    if element == nil then return end
    local findWnd = false
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1, #self.m_tWndLuaObjStack do 
            local luaObj = self.m_tWndLuaObjStack[i]
            if luaObj.m_root == element then 
                findWnd = true 
            elseif findWnd == true then 
                local elem = luaObj.m_root:getChildElement("wnd_black_bg___")
                if elem ~= nil then 
                    elem:setVisible(false)
                end
            end
        end
    end
end

--@brief 显示窗口下面的半透明黑色背景
function WindowManager:appearWndBlackImg()
    if #self.m_tWndLuaObjStack > 0 then 
        for i = 1, #self.m_tWndLuaObjStack do 
            local luaObj = self.m_tWndLuaObjStack[i]
            if luaObj.m_root ~= nil then 
                local elem = luaObj.m_root:getChildElement("wnd_black_bg___")
                if elem ~= nil then 
                    elem:setVisible(true)
                    return true
                end
            end
        end
    end
    return false
end

--@brief    截屏
function WindowManager:SaveScreenShot()
    --获取屏幕尺寸  
    local size = CCDirector:sharedDirector():getWinSize()
    --使用屏幕尺寸初始化一个空的渲染纹理对象  
    local texture = CCRenderTexture:create(size.width, size.height)
    --设置位置      
    texture:setPosition(GlobalMethod:ccp(size.width/2, size.height/2))
    --开始获取      
    texture:begin()
    --遍历场景节点对象，填充纹理到texure中  
    CCDirector:sharedDirector():getRunningScene():visit()
    --结束获取  
    texture:endToLua()
    --保存为PNG图，Win32/Debug目录下  
    texture:saveToFile("screenshot.png", kCCImageFormatPNG)
end


-------------------------------------使用特定皮肤大招时的阴影begin--------------------------------------

--@brief    为场景添加教学用的阴影
function WindowManager:addBigSkillShelterLayer(nZOrder, opacity)
    WZLog("WindowManager:addBigSkillShelterLayer one", self.m_sceneRoot, opacity)
    if self.m_sceneRoot == nil then
        return
    end

    local shelterLayer = WZUISystem:getInstance():createElement("BigSkillShelterLayer")
    if shelterLayer == nil then
        WZLog("create BigSkillShelterLayer from xml fail!")
        return
    end
    if opacity then
        GetElement(shelterLayer, "imgBlack_BigSkillShelterLayer", WZUIImage):setOpacity(opacity)
    end
    shelterLayer:setTouchSwallow(false)
    shelterLayer:setZOrder(nZOrder)
    self.m_sceneRoot:addChild(shelterLayer)
    WZLog("WindowManager:addBigSkillShelterLayer two")
    return shelterLayer
end

--@brief    移除场景里皮肤大招用的阴影
function WindowManager:removeBigSkillShelterLayer()
    WZLog("WindowManager:removeBigSkillShelterLayer one", tostring(self.m_sceneRoot))

    if self.m_sceneRoot == nil then
        return
    end
    local shelterLayer = self.m_sceneRoot:getChildElement("BigSkillShelterLayer")
    WZLog("WindowManager:removeBigSkillShelterLayer two", tostring(self.m_sceneRoot), tostring(shelterLayer))
    if shelterLayer == nil then
        return
    end
    shelterLayer:removeFromParentAndCleanup(true)
end

--@brief    场景里皮肤大招用的阴影
function WindowManager:getBigSkillShelterLayer()
    WZLog("WindowManager:getBigSkillShelterLayer one", tostring(self.m_sceneRoot))
    if self.m_sceneRoot == nil then
        return
    end
    local shelterLayer = self.m_sceneRoot:getChildElement("BigSkillShelterLayer")
    WZLog("WindowManager:getBigSkillShelterLayer two", tostring(self.m_sceneRoot), tostring(shelterLayer))
    if shelterLayer == nil then
        return
    end
    return shelterLayer
end

--@brief    添加皮肤大招阴影层上高亮元素
--@param    element:敌人元素
--@return   imgTeachClip:模板,没有阴影的部分
function WindowManager:addBigSkillShelterLight(element)
    WZLog("WindowManager:addBigSkillShelterTemplate one", tostring(self.m_sceneRoot), tostring(element))
    if self.m_sceneRoot == nil or element == nil then
        return
    end
    local renderCon = self.m_sceneRoot:getChildElement("RenderCon_BigSkillShelterLayer")
    if renderCon == nil then
        return
    end

    local scale = 1
    local pos = GlobalMethod:ccp(element:getPositionX(), element:getPositionY())
    pos = element:getParentElement():convertToWorldSpace(pos)
    --创建裁剪图片
    local imgTeachClip = WZUISystem:getInstance():createElement("ImgTeachClip")
    local sceneSize = self.m_sceneRoot:getContentSize()
    local elementSize = element:getContentSize()
    imgTeachClip:setRelativeSize(GlobalMethod:CCSize(elementSize.width*scale/sceneSize.width, elementSize.height*scale/sceneSize.height))
    renderCon:addChild(imgTeachClip)
    local anchorPt = element:getAnchorPoint()
    pos.x = pos.x + (0.5 - anchorPt.x)*elementSize.width
    pos.y = pos.y + (0.5 - anchorPt.y)*elementSize.height
    imgTeachClip:setPosition(pos)

    --创建触摸容器
    local clipCon = GetElement(renderCon, "clipCon_BigSkillShelterLayer")
    local wndTeachTouch = WZUISystem:getInstance():createElement("WndTeachTouch")
    wndTeachTouch = WZUIWindow:luaTo(wndTeachTouch)
    wndTeachTouch:setAbsContentSize(CCSize(1400,700))
    clipCon:addChild(wndTeachTouch)

    return imgTeachClip
end

-------------------------------------使用特定皮肤大招时的阴影end--------------------------------------


--@brief    为场景添加教学用的遮挡层
--@param    nZOrder,遮挡层的层次
function WindowManager:addBackgroundImg(nZOrder, opacity, fileName, isCreate)
    WZLog("WindowManager:addOneBackgroundImg one", self.m_sceneRoot, opacity)
    if self.m_sceneRoot == nil then
        return
    end
    local rootBgImg = self.m_sceneRoot:getChildElement("_rootBgImg")
    local m_isCreate = false
    if isCreate then
        m_isCreate = isCreate
    end
    if not rootBgImg then
        WZLog("WindowManager:addOneBackgroundImg create rootBgImg")
        rootBgImg = WZUI9Image:create()
        m_isCreate = true
    end
    if m_isCreate ~= true then
        return rootBgImg
    end
    WZLog("WindowManager:addOneBackgroundImg rootBgImg 1")
    --ui/common/frame_zhezhao_02.png
    rootBgImg:setTouchEnable(false)
    --mask:setUseOriginSize(true)
    --mask:setUseAbsCoordinate(true)
    --mask:setAnchorPoint(GlobalMethod:ccp(0,1))
    local m_fileName = "ui/common/frame_zhezhao_01.png"
    if fileName then
        m_fileName = fileName
    end
    rootBgImg:setFile(m_fileName)
    rootBgImg:setName("_rootBgImg")
    local m_opacity = 50
    if opacity then
        m_opacity = opacity
    end
    rootBgImg:setOpacity(m_opacity)
    local m_zOrder = 99999
    if nZOrder then
        m_zOrder = nZOrder
    end
    rootBgImg:setZOrder(m_zOrder)
    self.m_sceneRoot:addChild(rootBgImg)
    WZLog("WindowManager:addOneBackgroundImg two")
    return rootBgImg
end

--@brief    移除场景里教学用的遮挡层
function WindowManager:removeBackgroundImg()
    WZLog("WindowManager:removeBackgroundImg one", tostring(self.m_sceneRoot))

    if self.m_sceneRoot == nil then
        return
    end
    local rootBgImg = self.m_sceneRoot:getChildElement("_rootBgImg")
    WZLog("WindowManager:removeBackgroundImg two", tostring(self.m_sceneRoot), tostring(rootBgImg))
    if rootBgImg == nil then
        return
    end
    WZLog("WindowManager:removeBackgroundImg three", tostring(self.m_sceneRoot), tostring(rootBgImg))
    rootBgImg:removeFromParentAndCleanup(true)
end