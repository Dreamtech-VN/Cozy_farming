--SceneTabooMap.lua
--@brief	SceneTabooMap的UI模块
--@date		2017/04/21
--@note		禁忌之地地图


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneTabooMap:onEnter(element)
   
	self.m_root = element
    self:_addTop()

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(49)
    WZLog("SceneTabooMap:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 27 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("SceneTabooMap:onEnter2")
    end
    self:_initMapView()
    ProtocolProcessorTaboo:regAll()
    ProtocolProcessorTaboo:send_ZONE_GetDiceStatus()
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)


end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneTabooMap:onExit(element)
    --add by wuweidong
   ProtocolProcessorTaboo:unregAll()

    local conMove = GetElement(self.m_root,"conMove_SceneTabooMap",WZUIMoveContainer)
    local moveElement = conMove:getMoveElement()
    SceneTabooMap.g_nScrollX = moveElement:getPositionX()

	self:_unInit()
end

-- 游戏顶部
function SceneTabooMap:_addTop(imgPath,chatFlag)
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_jjzd.png",SceneTabooMap,SceneTabooMap.onReturn,true,true,false,"SceneTabooMap",{goldType = 10})
end

function SceneTabooMap:onTouchBegan(element,pt)
	WZLog("SceneTabooMap:onTouchBegan")
	
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function SceneTabooMap:onReturn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("---------------close end start-----------------",self.m_fBack)
    local sceneCity = SceneCity:createElement()
    replaceScene(sceneCity)

    if self.m_tReturnCallBack then
        self.m_tReturnCallBack[2](self.m_tReturnCallBack[1])
    end
end

--@brief    点击关闭按钮时被调用的函数
--@param    element:按钮绑定的UI节点引用
function SceneTabooMap:onBtnClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneTabooBattle:show(-1)
end

--@brief    点击幻化宝箱回调
function SceneTabooMap:onBtnPhantomBox(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPhantomChest:show()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 地图初始化
function SceneTabooMap:_initMapView()
    WZLog("SceneTabooMap:_initMapView")
    local btnCon = GetElement(self.m_root,"conBtn_SceneTabooMap",WZUIContainer)

    -- local defPos = GetElement(self.m_root,"conBtnPos_SceneTabooMap",WZUIContainer):getRelativePosition()
    -- local defSecPos = GetElement(self.m_root,"conBtnSecPos_SceneTabooMap",WZUIContainer):getRelativePosition()
    local isView = false
    for i = 1,GetTableLen(GDatatab_forbidden_chapter) do
        local template = GDatatab_forbidden_chapter["id_"..i]
        if template then
            local celElement,tCell =  CellTabooMapBtn:createElement()
            tCell:setData({id=template.id})


            --只显示第一个等级不到的地图
            if not isView and template.level > CacheCenter:getPlayerInfo().level then
                isView = true
                tCell:setOpenLvView(true)
            else
                tCell:setOpenLvView(false) 
            end

            local conPos = GetElement(self.m_root,string.format("conBtnPos%d_SceneTabooMap",i),WZUIContainer)
            local conSecPos = GetElement(self.m_root,string.format("conBtnSecPos%d_SceneTabooMap",i),WZUIContainer)
            if conPos then
                celElement:setRelativePosition(conPos:getRelativePosition())
                tCell:setBtnRelativePosition(conSecPos:getRelativePosition())
                btnCon:addChild(celElement)
            -- else
            --     celElement:setRelativePosition(defPos)
            --     tCell:setBtnRelativePosition(defSecPos)
            end
        end
    end
    --红点显示
    GetElement(self.m_root,"conRedBtn_SceneTabooMap",WZUIContainer):setVisible(GlobalGame.g_tRedPointList.taboo)

    local conMove = GetElement(self.m_root,"conMove_SceneTabooMap",WZUIMoveContainer)
    local moveElement = conMove:getMoveElement()
    if SceneTabooMap.g_nScrollX then
        moveElement:setPositionX(SceneTabooMap.g_nScrollX)
    else
        moveElement:setPositionX(moveElement:getContentSize().width/2)
    end
    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(49)
    WZLog("WndMounts:onReturnClick two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 28 then
        TeachGroup1:endTeachStep({49,2})
        TeachGroup1:startGroup({49,3,self.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
end

-------------------------------------私有方法模块End----------------------------------------
