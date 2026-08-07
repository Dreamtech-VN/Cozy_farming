--CellGuildWarInvite.lua
--@brief	CellGuildWarInvite的UI模块
--@date		2017/2/25
--@note		邀请


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuildWarInvite:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuildWarInvite:onExit(element)
	self:_unInit()
end


--@brief	cell点击回调
--@param	element:触发事件的控件引用
function CellGuildWarInvite:onInviteClick(element)
    WZLog("CellGuildWarInvite:onInviteClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_lpClickCallback ~= nil then
        self.m_lpClickCallback(self.m_luaTable,self.m_tData.id)
    end
    GetElement(self.m_root,"btnInvite_CellGuildWarInvite",WZUIButton):setTouchEnable(false)
    AdaptLanguage(self)
    self.m_root:enableSchedule("_updateBtnInvite",5)
end

function CellGuildWarInvite:onCheckClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellGuildWarInvite:_updateBtnInvite(element,dt)
    self.m_root:disableSchedule()
    GetElement(self.m_root,"btnInvite_CellGuildWarInvite",WZUIButton):setTouchEnable(true)
end
--@brief	cell更新函数
--@note     实际上的初始化函数
function CellGuildWarInvite:_update()
    local data = self.m_tData
    local conHead = GetElement(self.m_root, "conHead_CellGuildWarInvite", WZUIContainer)
    local cell,tcell = CellHead:show(conHead,data.headItemId,data.faceItemId,data.sex,nil,nil,data.vipLevel,data.headColor)

    GetElement(self.m_root,"labLv_CellGuildWarInvite",WZUILabelTTF):setText("Lv"..data.level)
    GetElement(self.m_root,"labName_CellGuildWarInvite",WZUILabelTTF):setText(data.name)
    GetElement(self.m_root,"labFight_CellGuildWarInvite",WZUILabelTTF):setText(LocalStrings.BATTLE.." "..data.fighting)
    GetElement(self.m_root,"labState_CellGuildWarInvite",WZUILabelTTF):setText(LocalStrings.REWARD_BTN_ONLINE)

    if data.inviteTime and SystemTime:getServerTime() - data.inviteTime < 5 then
        local time = SystemTime:getServerTime() - data.inviteTime
        time = 5 - time
        time = time > 5 and 5 or time
        GetElement(self.m_root,"btnInvite_CellGuildWarInvite",WZUIButton):setTouchEnable(false)
        self.m_root:enableSchedule("_updateBtnInvite",time)
    end


end
-------------------------------------私有方法模块End---------------------------------------


-------------------------------------语言适配Begin---------------------------------------
function CellGuildWarInvite:_adaptLanguage_pt( ... )
    GetElement(self.m_root,"txtInvite_CellGuildWarInvite",WZUILabelTTF):setScale(0.7)
end

--------------------------------------语言适配End----------------------------------------