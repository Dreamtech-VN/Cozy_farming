--WndVipChooseMail.lua
--@brief	WndVipChooseMail的UI模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipChooseMail:onEnter(element)
    WZLog("WndVipChooseMail:onEnter")

	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipChooseMail:onExit(element)
    WZLog("WndVipChooseMail:onExit")
	self:_unInit()
end

--@brief
function WndVipChooseMail:setData(data)
    WZLog("WndVipChooseMail:setData")
    self.sdkData = data
end


--@brief
--@param	element:按钮的引用
function WndVipChooseMail:click(element)

    local editFind = WZUIEditBox:luaTo(self.m_root:getChildElement("editFind_WndVip"))
    local desc = editFind:getText()
    WZLog("WndVipChooseMail:click", self.pmId, tostring(desc))

    if WndLoginSelect:_checkMail(desc) == false then
        --MsgBoxManager:showTipBox(LocalStrings.PASSWORD_MAIL_ERROR)
        return
    end

    if self.sdkData then
        WndVip:createLoadingUI()
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        for k, v in pairs(self.sdkData) do
            WZLog("WndVipChooseMail:click1 two-----------sdk vip info------------",k,v)
        end

        PassportSdkManager.s_paymentId = self.pmId
        PassportSdkManager.s_paymentEmail = desc
        local channel = nil
        if self.pmId ~= "google" then
            channel = 1047
        end
        PassportSdkManager:getOrderNum(self.sdkData,channel)
    end

    self:clickClose()

end

--@brief	关闭窗口
function WndVipChooseMail:clickClose()
    WZLog("WndVipChooseMail:removeWindow", tostring(self.m_root))
    if self.m_root == nil then
        return
    end
    
    WindowManager:removeWindow(self.m_root, self, true)
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
