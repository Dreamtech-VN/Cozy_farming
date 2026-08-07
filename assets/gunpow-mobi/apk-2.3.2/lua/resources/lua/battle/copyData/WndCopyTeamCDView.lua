--WndCopyTeamCDView.lua
--@brief	WndCopyTeamCDView的UI模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyTeamCDView:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self:_initUI()
    self:_initEvent()
    self:_schedule()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyTeamCDView:onExit(element)
    self:_unSchedule()
    self:_removeEvent()
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化ui
function WndCopyTeamCDView:_initUI()
    self.m_tCountDownLab = GetElement(self.m_root, "countDown_WndCopyTeamCDView", WZUILabelTTF)
end


--@brief 启动计时器
function WndCopyTeamCDView:_schedule()
    self.m_root:enableSchedule("_updateCountDown",1)
end

--@brief 关闭计时器
function WndCopyTeamCDView:_unSchedule()
    if self.m_root then
        self.m_root:disableSchedule()
    end
end

function WndCopyTeamCDView:_updateCountDown(element,dt)
    local time = SystemTime:getServerTime()
    if time < self.m_nEndTime then 
        --WZLog("_updateCountDown",self.m_nLeftTime,dt)

        local timeStr = self:_getCountDownStr(time)
        self.m_tCountDownLab:setText(timeStr)
    end
end

function WndCopyTeamCDView:_getCountDownStr(time)
    local leftTime = self.m_nEndTime - time
    local min = math.floor(leftTime / 60)
    local second = math.floor(leftTime - min * 60)

    if min < 10 then  min = "0"..min end
    if second < 10 then second = "0"..second end

    return tostring(min)..":"..tostring(second)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function WndCopyTeamCDView:_adaptLanguage_en(  )
    GetElement(self.m_root,"txt_WndCopyTeamCDView",WZUILabelTTF):setFontSize(22)
end

function WndCopyTeamCDView:_adaptLanguage_es(  )
    GetElement(self.m_root,"txt_WndCopyTeamCDView",WZUILabelTTF):setFontSize(16)
end

function WndCopyTeamCDView:_adaptLanguage_ug(  )
    local txt = GetElement(self.m_root,"txt_WndCopyTeamCDView",WZUILabelTTF)
    txt:setScale(0.8)
    txt:setDimensions(GlobalMethod:CCSize(240))
end
-----------------------------------语言适配End-----------------------------------------------