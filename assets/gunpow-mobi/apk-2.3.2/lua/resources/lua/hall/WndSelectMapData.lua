--WndSelectMapData.lua
--@brief	WndSelectMap的数据模块
--@date		2013/12/27
--@author	李光森
--@note		房间中选择地图窗口

WndSelectMap = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSelectMap:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--Wnd的UI数据
	self.m_nCurChannel = nil			--当前的频道
	self.m_nLoadingId = nil				--转菊花id
	self.m_lpClickCallback = nil		--点击回调函数
	self.m_tCallbackTable = nil			--回调表
	self.m_tData = nil                  --存放地图信息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSelectMap:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nCurChannel = nil
	self.m_nLoadingId = nil
	self.m_lpClickCallback = nil
	self.m_tCallbackTable = nil
	self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSelectMap:createElement()
	local element = WZUISystem:getInstance():createElement("WndSelectMap")
	assert(element, "WndSelectMap create element failed!")
	self:_init()
	return element
end

--@brief	设置当前频道
--@param	channel:频道
function WndSelectMap:setChannel(channel)
	self.m_nCurChannel = channel
	WZLog("WndSelectMap:setChannel channel = ",self.m_nCurChannel)
	self:_update()
end

--@brief	设置点击回调函数
--@note		当cell被点击时回调
function WndSelectMap:setCallback(callback, tLuaObj)
	self.m_lpClickCallback = callback
	self.m_tCallbackTable = tLuaObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
