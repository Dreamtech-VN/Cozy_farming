--WndIntoMerryData.lua
--@brief	WndIntoMerry的数据模块
--@date		2014/08/16
--@author	fanchao
--@note		GetIntoMerry

WndIntoMerry = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndIntoMerry:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_lpOkCallBack = nil   		--创建房间回调
	self.m_tCallbackTable = nil			--回调表
	self.m_sHallPass = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndIntoMerry:_unInit()
	self.m_root = nil
	self.m_lpOkCallBack = nil
	self.m_tCallbackTable = nil
	self.m_sHallPass = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndIntoMerry:createElement()
	local element = WZUISystem:getInstance():createElement("WndIntoMerry")
	assert(element, "WndIntoMerry create element failed!")
	self:_init()
	return element
end


--@brief	设置完成回调函数
--@para		callback:回调函数的引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于外部回调之用
function WndIntoMerry:setOkCallBack(callback,tLuaObj)
	self.m_lpOkCallBack = callback
	self.m_tCallbackTable = tLuaObj
end

--@brief  是结婚主人才需要
function WndIntoMerry:setPass(pass)
	WZLog("WndIntoMerry:setPass ------- = ",pass)
	self.m_sHallPass = pass
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
