--WndAdvertisingData.lua
--@brief	WndAdvertising的数据模块
--@date		2016/09/12
--@author	zsq
--@note		登录广告

WndAdvertising = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAdvertising:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAdvertising:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAdvertising:createElement()
	local element = WZUISystem:getInstance():createElement("WndAdvertising")
	assert(element, "WndAdvertising create element failed!")
	self:_init()
	return element
end

--@brief	点击4399
function WndAdvertising:show4399()
	ADINDEX = 999999
	local wnd = WndAdvertising:createElement()
    WindowManager:addWindow(wnd, WndAdvertising, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	排序
function _sortAdvertising(a, b)
	WZLog("_sortAdvertising",a.sort,b.sort,type(a.sort),type(b.sort))
	if a.sort ~= b.sort then
		WZLog(a.sort > b.sort)
		return a.sort > b.sort
	else
		return a.params > b.params
	end
end




-------------------------------------私有方法模块End----------------------------------------
