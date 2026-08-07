--WndRuneInfoData.lua
--@brief	WndRuneInfo的数据模块
--@date		2017/03/21
--@author	qixiang
--@note		符文信息

WndRuneInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRuneInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRuneId = nil
	self.m_nSlotIndex = nil
	self.m_tLuaFun = nil
	self.m_tLuaFun2 = nil
	self.m_tCloseCallbackLua = nil
	self.m_tCloseCallbackFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRuneInfo:_unInit()
	self.m_root = nil
	self.m_nRuneId = nil
	self.m_nSlotIndex = nil
	self.m_tLuaFun = nil
	self.m_tLuaFun2 = nil
	self.m_tCloseCallbackLua = nil
	self.m_tCloseCallbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRuneInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndRuneInfo")
	assert(element, "WndRuneInfo create element failed!")
	self:_init()
	return element
end

--显示符文信息
function WndRuneInfo:show(runeId,slotIndex,parentNode)
	-- body
	WZLog("WndRuneInfo:show")
	if self.m_root == nil then
		local node = self:createElement()
		node:setTag(220)
		self.m_nRuneId = runeId
	    self.m_nSlotIndex = slotIndex
		parentNode:addChild(node)
	else
		self.m_nRuneId = runeId
	    self.m_nSlotIndex = slotIndex
		self:showRuneInfo()
	end
	
end

--点击更换的回调
function WndRuneInfo:setChangeRune(funLua,func)
	WZLog("WndRuneInfo:setChangeRune")
	self.m_tLuaFun = funLua
	self.m_tLuaFun2 = func
end

--点击关闭的回调
function WndRuneInfo:setCloseRuneInfoCallbcak(funLua,func)
	WZLog("WndRuneInfo:setChangeRune")
	self.m_tCloseCallbackLua = funLua
	self.m_tCloseCallbackFun = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
