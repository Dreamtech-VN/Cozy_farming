--WndSummonEntrance.lua
--@brief	WndSummonEntrance的UI模块
--@date		2016/12/26
--@author	Tianxiang_Xu
--@note		爬塔和世界BOSS的入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSummonEntrance:onEnter(element)
	self.m_root = element
    self:controlBtnShow()
    AdaptLanguage(self)
    TeachGroup1:startGroup({41,2,self.m_root},{42,3,self.m_root})
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSummonEntrance:onExit(element)
	self:_unInit()
end

--@brief    弹窗动画完成后的回调
function WndSummonEntrance:actionCallback(element, data)
    WZLog("WndSummonEntrance:actionCallback", tostring(GlobalGame.g_tRedPointList["EquipLove"]), tostring(GlobalGame.g_tRedPointList["btnPet"]), tostring(GlobalGame.g_tRedPointList["RuneDraw"]))
    if GlobalGame.g_tRedPointList["EquipLove"] then
        self:updateRedPoint(true)
    end

    if GlobalGame.g_tRedPointList["btnPet"] then
        self:updateRedPoint(nil, true)
    end

    if GlobalGame.g_tRedPointList["RuneDraw"] then
        self:updateRedPoint(nil, nil, true)
    end

    if GlobalGame.g_tRedPointList["bless"] then
        self:updateRedPoint(nil, nil, nil, true)
    end
end

function WndSummonEntrance:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_zhaohuan.png",WndSummonEntrance,WndSummonEntrance.onClickClose,true,true,false,"WndSummonEntrance")
    self.topCell = {cell = cell, tcell = tcell}
end

function WndSummonEntrance:updateRedPoint(isRedEquip, isRedPet, isRedRune, isRedBless)
    WZLog("WndSummonEntrance:updateRedPoint", tostring(isRedEquip), tostring(isRedPet), tostring(isRedRune), tostring(isRedBless), tostring(self.m_root))
    if self.m_root then
        if isRedEquip ~= nil then
            local btn = GetElement(self.m_root, "btn1_WndSummonEntrance", WZUIButton)
            SceneCity:setRedPoint(btn, isRedEquip, GlobalMethod:ccp(215,480))
        end

        if isRedPet ~= nil then
            local btn = GetElement(self.m_root, "btn2_WndSummonEntrance", WZUIButton)
            SceneCity:setRedPoint(btn, isRedPet, GlobalMethod:ccp(215,480))
        end

        if isRedRune ~= nil then
            local btn = GetElement(self.m_root, "btn4_WndSummonEntrance", WZUIButton)
            SceneCity:setRedPoint(btn, isRedRune, GlobalMethod:ccp(215,480))
        end

        if isRedBless ~= nil then
            local btn = GetElement(self.m_root, "btn3_WndSummonEntrance", WZUIButton)
            SceneCity:setRedPoint(btn, isRedBless, GlobalMethod:ccp(215,480))
        end
    end
end

--@brief onEnter函数执行完成回调
function WndSummonEntrance:onEnterTransitionDidFinish(element)
    self:_addTop()
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    点击图标回调
function WndSummonEntrance:onClickEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 0 then   --幸运召唤
        TeachGroup1:endTeachStep({41,2})
        if CheckButtonOpen(ISLAND_BUILDING_EQUIT_LOTTERY) then
            local wndEquipmentLottery = WndEquipmentLottery:createElement()
            WindowManager:addWindow(wndEquipmentLottery,WndEquipmentLottery)
        end
    elseif nTag == 1 then --砸蛋
        if CheckButtonOpen(ISLAND_RIGHT_PET) then
            local wndPetRaffle = WndPetRaffle:createElement()
            WindowManager:addWindow(wndPetRaffle, WndPetRaffle)
        end
    elseif nTag == 2 then --祈福
        TeachGroup1:endTeachStep({42,3})
        if CheckButtonOpen(ISLAND_UP_BLESS) then
            local wndBless = WndBless:createElement()
            if wndBless ~= nil then
                WindowManager:addWindow(wndBless,WndBless)
                return
            end
        end
    elseif nTag == 3 then --符文
        if CheckButtonOpen(ISLAND_UP_RUNE) then
            SceneRuneLockDraw:show()
        end
    end
end

--@brief    点击关闭按钮回调
function WndSummonEntrance:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    关闭整个窗口的动画效果
function WndSummonEntrance:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--按照功能开放等级进行显示
function WndSummonEntrance:controlBtnShow()
    -- body
    WZLog("WndSummonEntrance:controlBtnShow")
    local GDatatab_button_info = GDatatab_button_info
    local GetElement = GetElement
    local btnList = {27,64,115,11}
    
    local conList = GetElement(self.m_root,"conList_WndSummonEntrance",WZUIContainer)
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i,v in ipairs(btnList) do
        local con = GetElement(conList,"con" .. i .. "_WndSummonEntrance",WZUIContainer)
        local txt = GetElement(conList,"txt" .. i .. "_WndSummonEntrance",WZUILabelTTF)
        if playerLevel >= GDatatab_button_info["id_"..v].open_level  then 
            con:setVisible(false)
            txt:setVisible(true)
        else
            txt:setVisible(false)
            con:setVisible(true)
        end
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSummonEntrance:_adaptLanguage_es(  )
    GetElement(self.m_root,"txt1_WndSummonEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt2_WndSummonEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt3_WndSummonEntrance",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt4_WndSummonEntrance",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------