--WndTabooBoxOpenData.lua
--@brief	WndTabooBoxOpen的数据模块
--@date		2017/05/03

WndTabooBoxOpen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTabooBoxOpen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_tLuaObj = nil
	self.m_tCallFunc = nil
	self.m_bIsBoxAction = false
	self.isUseTicket = nil				--是否使用双货币
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTabooBoxOpen:_unInit()
	self.m_root = nil
	self.m_tData = nil
	if self.m_tLuaObj then
		self.m_tCallFunc(self.m_tLuaObj,self.m_bIsBoxAction)
	end
	self.m_bIsBoxAction = false
	self.m_tLuaObj = nil
	self.m_tCallFunc = nil
	self.isUseTicket = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTabooBoxOpen:createElement()
	local element = WZUISystem:getInstance():createElement("WndTabooBoxOpen")
	assert(element, "WndTabooBoxOpen create element failed!")
	self:_init()
	return element
end

--@param    tData,宝箱数据
--@param    type,宝箱类型，1普通宝箱 2额外宝箱 3溢出宝箱
function WndTabooBoxOpen:show(data,type)
	WZLog("WndTabooBoxOpen:show",Serialize(data),type)
	local element = self:createElement()
	self.m_tData = data
	self.m_nBoxType = type
	WindowManager:addWindow(element, self,nil, nil)
end

--@brief 刷新界面
function WndTabooBoxOpen:updateData(data)
	if not self.m_root then
		return
	end
	self.m_tData = data
	self:_updateState()
end

function WndTabooBoxOpen:setCallBack(luaObj,callFunc)
	self.m_tLuaObj = luaObj
	self.m_tCallFunc = callFunc
end

function WndTabooBoxOpen:getBoxIndex()
	if self.m_tData then
		return self.m_tData.boxIndex
	else
		return nil
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
