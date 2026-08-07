--WndRedEnvelopesRain.lua
--@brief	WndRedEnvelopesRain的UI模块
--@date		2016/01/13
--@author	zsq
--@note		查看大图


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRedEnvelopesRain:onEnter(element)
	self.m_root = element
    if self.m_nType == 3 then 
        GetElement(self.m_root, "imgRedPack_WndRedEnvelopesRain", WZUIImage):setFile("ui/gameActivity/chunjie_hongbao5.png")
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRedEnvelopesRain:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndRedEnvelopesRain:onClose(element)
    WZLog("WndRedEnvelopesRain:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 2 then   --口令红包
        if #g_tRedPackList == 0 then 
			WindowManager:removeWindow(self.m_root, self, true)
			return 
		end
        ProtocolProcessorRedPack:send_ACTIVITY_DrawCommandeRedPacket(g_tRedPackList[1])
    elseif self.m_nType == 3 then   --拜财神-红包雨
        if WORSHIPGOD_ENVELOPES == nil or #WORSHIPGOD_ENVELOPES == 0 then return end
        local tData = {}
        tData.redPacketId = WORSHIPGOD_ENVELOPES[1][2]

        local stringData = json.encode(tData)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(WORSHIPGOD_ENVELOPES[1][1], 11, stringData)
    else
    	if ENVELOPES == nil or #ENVELOPES == 0 then return end
    	ProtocolProcessorRedPack:send_ACTIVITY_DrawScheduledRedPacket(ENVELOPES[1])
    end
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRedEnvelopesRain:show(nType)
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        return
    end
    if self.m_root ~= nil then return end 
    
	local wnd = WndRedEnvelopesRain:createElement()
    if wnd then
        self.m_nType = nType
    	WindowManager:addWindow(wnd, WndRedEnvelopesRain, true, nil, nil, true)
    end
end




-------------------------------------私有方法模块End----------------------------------------
