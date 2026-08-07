--WndRemainsChallenge.lua
--@brief	WndRemainsChallenge的UI模块
--@date		2019/07/11
--@author	yrd
--@note		遗迹之光挑战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRemainsChallenge:onEnter(element)
	self.m_root = element

	ProtocolProcessorDigGem:regAll()
    ProtocolProcessorDigGem:send_MINING_GetRelicList( )
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRemainsChallenge:onExit(element)
	self:_unInit()
end

function WndRemainsChallenge:_update()
	
	local digdungeontimes = CacheCenter:getGameParam().digdungeontimes
	local txtLeftTime = GetElement(self.m_root,"txtLeftTime_WndRemainsChallenge",WZUILabelTTF)
    txtLeftTime:setText(self.m_sChallengeTime.."/"..digdungeontimes)
    txtLeftTime:disableSchedule()
    if self.m_nTime > 0 then
        txtLeftTime:enableSchedule("_updateCountDown",1)
    end

    local flconChallenge = GetElement(self.m_root,"flconChallenge_WndRemainsChallenge",WZUIFreeListContainer)
    if flconChallenge:size() > 0 then
        flconChallenge:removeAll()
    end
	for i=1,#self.m_tRemainsList do
    	local celElement,tCell = CellRemainsChallenge:createElement()
    	celElement:setTag(i-1)
    	celElement = WZUIContainer:luaTo(celElement)
    	tCell:setData(self.m_tRemainsList[i])
    	flconChallenge:pushBack(celElement)
    end
    flconChallenge:getMoveElement():setPositionY(flconChallenge:getMinPosition().y)
end

--@brief  剩余次数倒计时
function WndRemainsChallenge:_updateCountDown(element)
    self.m_nTime = self.m_nTime - 1
    if self.m_nTime <= 0 then
        element:disableSchedule()
        ProtocolProcessorDigGem:send_MINING_GetRelicList( )
    end
end

function WndRemainsChallenge:onCloseWindowBtn()
	if self.m_root ~= nil then
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	退出场景时被调用的函数
function WndRemainsChallenge:onCloseActionCallback(elem,data)
    WZLog("WndRemainsChallenge:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
