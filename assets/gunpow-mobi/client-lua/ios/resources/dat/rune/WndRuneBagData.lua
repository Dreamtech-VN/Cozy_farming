--WndRuneBagData.lua
--@brief	WndRuneBag的数据模块
--@date		2017/03/21
--@author	qixiang
--@note		符文背包

WndRuneBag = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRuneBag:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRuneList = nil
	self.m_nRuneType = nil
	self.m_nSlotIndex = nil         
	self.m_nRuneId = nil
	self.m_tCallbackLua = nil
	self.m_tCallbackFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRuneBag:_unInit()
	self.m_root = nil
	self.m_tRuneList = nil
	self.m_nRuneType = nil
	self.m_nSlotIndex = nil    
	self.m_nRuneId = nil     
	self.m_tCallbackLua = nil
	self.m_tCallbackFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRuneBag:createElement()
	local element = WZUISystem:getInstance():createElement("WndRuneBag")
	assert(element, "WndRuneBag create element failed!")
	self:_init()
	return element
end

--显示符文背包
function WndRuneBag:show(runeType,slotIndex,parentNode,runeBagList,runeId)
	WZLog("WndRuneBag:show ",runeType)
	if self.m_root == nil then
		local wndElement = self:createElement()
		wndElement:setTag(119)
		self.m_nRuneType = runeType
		self.m_tRuneList = runeBagList
		self.m_nSlotIndex = slotIndex
		self.m_nRuneId = runeId
		parentNode:addChild(wndElement)
	else
		self.m_nRuneType = runeType
		self.m_tRuneList = runeBagList
		self.m_nSlotIndex = slotIndex
		self.m_nRuneId = runeId
		self:showList()
	end
end

function WndRuneBag:setCloseCallback(lua,luaFunction)
	WZLog("WndRuneBag:setCloseCallback ")
	self.m_tCallbackLua = lua
	self.m_tCallbackFun = luaFunction
end

function WndRuneBag:updateRuneBagList(runeBagList)
	WZLog("WndRuneBag:updateRuneBagList")
	self.m_tRuneList = runeBagList
	self:showList()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
