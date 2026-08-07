--WndVipChoose.lua
--@brief	WndVipChoose的UI模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipChoose:onEnter(element)
    WZLog("WndVipChoose:onEnter")

	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipChoose:onExit(element)
    WZLog("WndVipChoose:onExit")
	self:_unInit()
end

--@brief
function WndVipChoose:setData(data)
    WZLog("WndVipChoose:setData")
    self.sdkData = data
end


--@brief
--@param	element:按钮的引用
function WndVipChoose:click(element)
    
    local pmId = ""
    local tag = element:getTag()
    if tag == 1 then
        pmId = "boleto_br"
        --pmId = "alipay_cn"
    elseif tag == 2 then
        pmId = "google"
    elseif tag == 3 then
        pmId = "bancodobrasil_br"
    elseif tag == 4 then
        pmId = "boacompra_br"
    end

    

    local wndVipChooseMail = WndVipChooseMail:createElement()
    WZLog("WndVipChoose:click", tag, pmId, wndVipChooseMail)
    
    if pmId == "google" then
        WndVip:createLoadingUI()
        PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
        for k, v in pairs(self.sdkData) do
            WZLog("-----------sdk vip info------------",k,v)
        end
        PassportSdkManager.s_paymentId = "google"
        PassportSdkManager.s_paymentEmail = ""
        PassportSdkManager:getOrderNum(self.sdkData)
    else
        WindowManager:addWindow(wndVipChooseMail, WndVipChooseMail, false)
        WndVipChooseMail:setData(self.sdkData)
        WndVipChooseMail.pmId = pmId
    end

    -- if self.sdkData then
    --     WndVip:createLoadingUI()
    --     PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    --     for k, v in pairs(self.sdkData) do
    --         WZLog("WndVipChoose:click1 two-----------sdk vip info------------",k,v)
    --     end

    --     PassportSdkManager.s_paymentId = pmId
    --     PassportSdkManager:getOrderNum(self.sdkData)
    -- end

end

--@brief	关闭窗口
function WndVipChoose:clickClose()
    WZLog("WndVipChoose:removeWindow", tostring(self.m_root))
    if self.m_root == nil then
        return
    end
    
    WindowManager:removeWindow(self.m_root, self, true)
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
