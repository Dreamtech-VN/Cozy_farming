--WndHeroCDView.lua
--@brief	WndHeroCDView的UI模块
--@date     2016/07/10
--@author   莫剑峰
--@note     英雄联赛


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHeroCDView:onEnter(element)
	self.m_root = element
    self:_initUI()
    self:_initEvent()
    self:_schedule()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHeroCDView:onExit(element)
    self:_unSchedule()
    self:_removeEvent()
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化ui
function WndHeroCDView:_initUI()
    self.m_tCountDownLab = GetElement(self.m_root, "countDown_WndHeroCDView", WZUILabelTTF)
end


--@brief 启动计时器
function WndHeroCDView:_schedule()
    self.m_root:enableSchedule("_updateCountDown",1)
end

--@brief 关闭计时器
function WndHeroCDView:_unSchedule()
    if self.m_root then
        self.m_root:disableSchedule()
    end
end

function WndHeroCDView:_updateCountDown(element,dt)
    local time = SystemTime:getServerTime()
    if time < self.m_nEndTime then 
        --WZLog("_updateCountDown",self.m_nLeftTime,dt)

        local timeStr = self:_getCountDownStr(time)
        self.m_tCountDownLab:setText(timeStr)
    end
end

function WndHeroCDView:_getCountDownStr(time)
    local leftTime = self.m_nEndTime - time
    local min = math.floor(leftTime / 60)
    local second = math.floor(leftTime - min * 60)

    if min < 10 then  min = "0"..min end
    if second < 10 then second = "0"..second end

    return tostring(min)..":"..tostring(second)
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function WndHeroCDView:_adaptLanguage_pt(  )
    GetElement(self.m_root, "conHeroCDView_WndHeroCDView", WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.29,0.68))
    
    local txtCountDown = GetElement(self.m_root, "txtCountDown_WndHeroCDView", WZUILabelTTF)
    txtCountDown:setScale(0.9)
    txtCountDown:setRelativePosition(GlobalMethod:ccp(0.370371,0.5))
    local countDown = GetElement(self.m_root, "countDown_WndHeroCDView", WZUILabelTTF)
    countDown:setScale(0.9)
    countDown:setRelativePosition(GlobalMethod:ccp(0.854444,0.5))
end

function WndHeroCDView:_adaptLanguage_es(  )
    local txtCountDown = GetElement(self.m_root, "txtCountDown_WndHeroCDView", WZUILabelTTF)
    txtCountDown:setFontSize(12)
    txtCountDown:setRelativePosition(GlobalMethod:ccp(0.33,0.5))

    local countDown = GetElement(self.m_root, "countDown_WndHeroCDView", WZUILabelTTF)
    countDown:setFontSize(18)
    countDown:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
end

function WndHeroCDView:_adaptLanguage_en(  )
    local txtCountDown = GetElement(self.m_root, "txtCountDown_WndHeroCDView", WZUILabelTTF)
    txtCountDown:setScale(0.75)
    local countDown = GetElement(self.m_root, "countDown_WndHeroCDView", WZUILabelTTF)
    countDown:setScale(0.75)
end

function WndHeroCDView:_adaptLanguage_tr(  )
    local txtCountDown = GetElement(self.m_root, "txtCountDown_WndHeroCDView", WZUILabelTTF)
    txtCountDown:setScale(0.75)
    local countDown = GetElement(self.m_root, "countDown_WndHeroCDView", WZUILabelTTF)
    countDown:setScale(0.75)
end

-------------------------------------语言适配End--------------------------------------------