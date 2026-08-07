--WndSuspensionData.lua
--@brief	WndSuspension的数据模块
--@date		2017/12/26
--@author	qixiang
--@note		禁赛倒计时

WndSuspension = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSuspension:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSuspension:_unInit()
	self.m_root = nil
	self.m_nTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSuspension:createElement()
	if WndSuspension.m_root ~= nil then
		WindowManager:removeWindow(WndSuspension.m_root, WndSuspension, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSuspension")
	assert(element, "WndSuspension create element failed!")
	self:_init()
	return element
end

function WndSuspension:showByTime(time)
	-- body
	WZLog("WndSuspension:showByTime ",time)
	if time == nil or time <= 0 then return end
	local element = self:createElement()
	self.m_nTime = time
	WindowManager:addWindow(element,WndSuspension,nil,nil,nil,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
