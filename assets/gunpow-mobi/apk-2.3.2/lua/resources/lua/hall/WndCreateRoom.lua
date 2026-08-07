--WndCreateRoom.lua
--@brief	WndCreateRoom的UI模块
--@date		2015-6-10
--@author	binshao
--@note		创建竞技场房间
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCreateRoom:onEnter(element)
	self.m_root = element
    self:_initMoreLanguage()
end

--@brief onEnter函数执行完成回调
function WndCreateRoom:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndCreateRoom:actionCallback(element, data)
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCreateRoom:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndCreateRoom:onCloseClick(element)
	WZLog("WndCreateRoom:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end


-- 点击创建房间回调
function WndCreateRoom:onCreateRoom(element)
    WZLog("WndCreateRoom:onOkClick one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self.callBack  then  return end
    WZLog("-----------create info-------------------")
    WZLog("-----------room   name--------------------",self:_getRoomName())
    WZLog("-----------room   pw----------------------",self:_getRoomPassword())
    WZLog("-----------game   mode--------------------",self.gameModeTag)
    WZLog("-----------fight  mode--------------------",self.fightModeTag)
    WZLog("-----------person num---------------------",self.personNumTag)

    --竞技 下混战模式的battleMode 和startMode 需进行修改
    if self.gameModeTag==1 then 
        if self.fightModeTag==3 then 
            self.gameModeTag = 3
            self.fightModeTag = 2
        end 
    end 

    self.callBack[2](self.callBack[1],self:_getRoomName(),self.gameModeTag,self.personNumTag,self:_getRoomPassword(),self.fightModeTag)
    WindowManager:removeWindow(self.m_root, self, true)
end

-- 选择游戏模式，竞技或者复活
function WndCreateRoom:onCheckGameMode(element)
    WZLog("WndCreateRoom:onCheckMode",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element:getTag()
    self.gameModeTag = tag
    self:_updateCheckBoxFightMode(tag)
end

-- 选择战斗类型,匹配，自由，混战
function WndCreateRoom:onCheckFightMode(element)
	WZLog("WndCreateRoom:onCheckFightMode")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element:getTag()
    self.fightModeTag = tag
    self:_updateCheckBoxRoomNum(tag)
end

-- 选择对战人数 1v1,2v2,3v3
function WndCreateRoom:onCheckSelPersonNum(element)
    WZLog("WndCreateRoom:onCheckSelPersonNum",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element:getTag()
    self.personNumTag = tag
end

-- 获得当前创建房间名字
function WndCreateRoom:_getRoomName()
	WZLog("WndCreateRoom:_getRoomName")
    local editName = WZUIEditBox:luaTo(GetElement(self.m_root,"editRoomName_WndCreateRoom"))
    local name = editName:getText()
    if name == "" then name = editName:getPlaceHolder() end
    return name
end

--@brief	获得房间密码
--@return   #1:返回房间密码
function WndCreateRoom:_getRoomPassword()
	WZLog("WndCreateRoom:_getRoomPassword")
    local editPW = WZUIEditBox:luaTo(GetElement(self.m_root,"editRoomPassword_WndCreateRoom"))
    local password = editPW:getText()
    if password == "" then password = "-1" end
    return password
end

-- 更新对战模式，复活游戏模式时，混战是不可见的
function WndCreateRoom:_updateCheckBoxFightMode(tag)
    local checkG = GetElement(self.m_root,"checkGroupFightMode_WndCreateRoom",WZUICheckBoxGroup)
    local check = checkG:getChildByTag(3)
    if tag == 2 then
        check:setVisible(false)
        -- 如果处于竞技模式选择了混战，切换到复活模式时修改为模式为随机
        local index = checkG:getCheckIndex()
        if index == 2 then
            checkG:setCheckIndex(0)
            self:_updateCheckBoxRoomNum(1)
        end
    else
        check:setVisible(true)
    end
end

-- 更新选择房间人数，当目前除以混战的战斗类型，那么人数是不可点击的
function WndCreateRoom:_updateCheckBoxRoomNum(tag)
    local checkG = GetElement(self.m_root,"checkGroupRoomNum_WndCreateRoom",WZUICheckBoxGroup)
    if tag == 3 then
        checkG:setTouchEnable(false)
        for i = 1, 3 do
            local check = WZUIElement:luaTo(checkG:getChildByTag(i))
            local check = WZUICheckBox:luaTo(check)
            check:setCheckIndex(0)
        end
    else
        checkG:setTouchEnable(true)
        checkG:setCheckIndex(self.personNumTag-1)
    end
end

-- 初始化多语言版本
function WndCreateRoom:_initMoreLanguage()
--    local txtCreate =  GetElement(self.m_root,"txtCreate_WndCreateRoom",WZUIShadowTTF)
--    txtCreate:setText(LocalStrings.CREATE_ROOM)
    local txtTitle = GetElement(self.m_root,"txtRoomTitle_WndCreateRoom",WZUILabelTTF)
    txtTitle:setText(LocalStrings.CREATE_ROOM)

    local txtRoomName =  GetElement(self.m_root,"txtRoomName_WndCreateRoom",WZUILabelTTF)
    txtRoomName:setText(LocalStrings.ROOM_NAME)

    local txtRoomPW =  GetElement(self.m_root,"txtRoomPassword_WndCreateRoom",WZUILabelTTF)
    txtRoomPW:setText(LocalStrings.ROOM_PASS)

--    local txtFightType =  GetElement(self.m_root,"txtFight_WndCreateRoom",WZUILabelTTF)
--    txtFightType:setText(LocalStrings.MACTH_TYPE)

    local txtMatch =  GetElement(self.m_root,"txtMatch_WndCreateRoom",WZUILabelTTF)
    txtMatch:setText(LocalStrings.ATH_MATCH)

    local txtFree =  GetElement(self.m_root,"txtFree_WndCreateRoom",WZUILabelTTF)
    txtFree:setText(LocalStrings.ATH_FREE)

    local txtMix =  GetElement(self.m_root,"txtMix_WndCreateRoom",WZUILabelTTF)
    txtMix:setText(LocalStrings.ATH_MIX)

--    local txtPerson=  GetElement(self.m_root,"txtPerson_WndCreateRoom",WZUILabelTTF)
--    txtPerson:setText(LocalStrings.ROOM_PEOPLO_NUM)

    -- 房间名字随机出现
    local name = LocalStrings.ROOM_NAME_RANDOM
    local random = math.random(#name)
    local editName = GetElement(self.m_root,"editRoomName_WndCreateRoom",WZUIEditBox)
    editName:setPlaceHolder(name[random])
end