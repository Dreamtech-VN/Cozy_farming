--CellFireworkContainer.lua
--@brief	CellFireworkContainer的UI模块
--@date		2017/06/14
--@author	qixiang
--@note		播放烟花


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFireworkContainer:onEnter(element)
	self.m_root = element
	self.m_root:enableSchedule("scheduleCountDown",self.m_nFireworkdLiftTIme)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFireworkContainer:onExit(element)
	self:_unInit()
end

function CellFireworkContainer:scheduleCountDown(element)
	WZLog("CellFireworkContainer:scheduleCountDown ")
	element:disableSchedule()
	self.m_root:removeFromParentAndCleanup(true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
