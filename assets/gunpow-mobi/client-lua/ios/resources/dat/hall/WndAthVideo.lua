--WndAthVideo.lua
--@brief	WndAthVideo的UI模块
--@date		2015-6-13
--@author	binshao
--@note		竞技场录像

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthVideo:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndAthVideo:actionCallback(element, data)
    self:_updateCheckBox(1)
    ProtocolProcessorSceneHall:send_ROOM_AllRecord( 1 )
    ProtocolProcessorSceneHall:send_ROOM_AllRecord( 2 )
    ProtocolProcessorSceneHall:send_ROOM_AllRecord( 3 )
    --ProtocolProcessorSceneHall:send_ROOM_AllRecord( 4 )
end

--@brief onEnter函数执行完成回调
function WndAthVideo:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthVideo:onExit(element)
    self:_unInit()
end

--@brief	关闭整个窗口的动画效果
function WndAthVideo:onReturnActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndAthVideo , true)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndAthVideo:onBtnReturn( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end


function WndAthVideo:onCheckBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self:_updateCheckBox(tag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------



-- 切换目标或奖励
function WndAthVideo:_updateCheckBox(tag)
    -- 标题
    local str = {LocalStrings.VIDEO_FIGHT_ONE_LOOK,LocalStrings.VIDEO_FIGHT_TWO_LOOK,LocalStrings.VIDEO_FIGHT_THREE_LOOK,LocalStrings.VIDEO_FIGHT_MY_LOOK}
    local txtTitle = GetElement(self.m_root,"txtTitle_WndAthVideo",WZUILabelTTF)
    txtTitle:setText(str[tag])


    for i = 1, 4 do
        -- 容器可见
        local conCheck = GetElement(self.m_root,"conCheck"..i.."_WndAthVideo",WZUIContainer)
        conCheck:setVisible(i == tag)

        local tab = GetElement(self.m_root,"tab"..i.."_WndAthVideo",WZUITableContainer)
        tab:setVisible(i == tag)
    end
end

function WndAthVideo:updateVideoTab(recordType)
    WZLog("----------recordType----------",recordType)
    local tab = GetElement(self.m_root,"tab"..recordType.."_WndAthVideo",WZUITableContainer)
    local data = {self.videoData1,self.videoData2,self.videoData3,self.videoData4}
    tab:cleanTable()
    local info = data[recordType]
    for k = 1,#info do
        local cell,tcell = CellAthVideo:createElement()
        cell:setTag(k-1)
        tab:setCellElement(cell)
        tcell:setData(info[k])
    end
end
-------------------------------------私有方法模块End--------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function WndAthVideo:_adaptLanguage_en(  )
    GetElement(self.m_root,"txt1_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt2_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt3_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt4_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt5_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt6_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
end

function WndAthVideo:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txt1_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt2_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt3_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt4_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt5_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
    GetElement(self.m_root,"txt6_WndAthVideo",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80,80))
end

function WndAthVideo:_adaptLanguage_tr(  )
    for i = 1, 6 do
        local txtname = string.format("txt%d_WndAthVideo",i)
        local txt = GetElement(self.m_root,txtname,WZUILabelTTF)
        txt:setFontSize(16)
        txt:setDimensions(GlobalMethod:CCSize(80,0))
    end
end

function WndAthVideo:_adaptLanguage_es(  )
    for i=1,6 do
        local txt = GetElement(self.m_root,"txt"..i.."_WndAthVideo",WZUILabelTTF)
        txt:setDimensions(GlobalMethod:CCSize(100,0))
    end
    GetElement(self.m_root,"txt7_WndAthVideo",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txt8_WndAthVideo",WZUILabelTTF):setFontSize(16)
end
-------------------------------------语言适配End----------------------------------------