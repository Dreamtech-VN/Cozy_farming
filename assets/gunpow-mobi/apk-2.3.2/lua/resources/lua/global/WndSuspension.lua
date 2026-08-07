--WndSuspension.lua
--@brief	WndSuspension的UI模块
--@date		2017/12/26
--@author	qixiang
--@note		禁赛倒计时


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSuspension:onEnter(element)
	self.m_root = element
    self:_setStaticText()
	self:showCountDown()
	self.m_root:enableSchedule("scheduleCountDown",1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSuspension:onExit(element)
	self:_unInit()
end

function WndSuspension:onClickExit(element)
	-- body
	WZLog("WndSuspension:onClickExit")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root , self , true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndSuspension:_setStaticText()
    local txtContent = GetElement(self.m_root,"txtContent_WndSuspension",WZUILabelTTF)
    if self.m_nType == 1 then
        txtContent:setText(LocalStrings.SUSPENSION_TIP)
    elseif self.m_nType == 2 then
        txtContent:setText(LocalStrings.PVP_STRATEGIC_TEXT5)
    end
end

function WndSuspension:scheduleCountDown(element)
	-- body
	WZLog("WndSuspension:scheduleCountDown =",self.m_nTime)
	self.m_nTime = self.m_nTime -1
	if self.m_nTime <= 0 then
		element:disableSchedule()
		WindowManager:removeWindow(self.m_root , self , true)
	end
	self:showCountDown()
end

function WndSuspension:showCountDown()
	-- body
	local txtTimeCountDown = GetElement(self.m_root,"txtTimeCountDown_WndSuspension",WZUILabelTTF)
    local sec = math.floor(self.m_nTime%60)
    local hour = 0
    local min = math.floor(self.m_nTime/60)
    if min > 60 then
    	min = math.floor(math.floor(self.m_nTime / 60) % 60)
    	hour = math.floor(math.floor(self.m_nTime/60) /60)
    end
    local timee = nil
    WZLog("WndTowerScroll:_updateSweepState = ",hour,sec,min)
    local tTimeStr = {}
    if hour <= 0 then
    	table.insert(tTimeStr,"00:")
    elseif hour > 1 and hour < 10 then
    	table.insert(tTimeStr,"0" .. hour .. ":")
    elseif hour > 9 then
    	table.insert(tTimeStr,hour .. ":")
    end

    if min <10 and min > 0 then
        if sec < 10 then
        	table.insert(tTimeStr,"0" .. min .. ":")
        	table.insert(tTimeStr,"0" .. sec)
        else
            table.insert(tTimeStr,"0" .. min .. ":")
            table.insert(tTimeStr,sec)
        end
    elseif min <= 0 then
        if sec < 10 then
        	table.insert(tTimeStr,"00:")
        	table.insert(tTimeStr,"0" .. sec)
        else
        	table.insert(tTimeStr,"00:")
        	table.insert(tTimeStr,sec)
        end
    else
        if sec < 10 then
        	table.insert(tTimeStr,min .. ":")
        	table.insert(tTimeStr,"0" .. sec )
        else
        	table.insert(tTimeStr,min .. ":")
        	table.insert(tTimeStr,sec)
        end
    end
    local timee = table.concat(tTimeStr)
	txtTimeCountDown:setText(timee)
end

-------------------------------------私有方法模块End----------------------------------------
