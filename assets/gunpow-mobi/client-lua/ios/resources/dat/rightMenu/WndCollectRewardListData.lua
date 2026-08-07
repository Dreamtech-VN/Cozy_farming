--WndCollectRewardListData.lua
--@brief	WndCollectRewardList的数据模块
--@date		2017/09/27
--@author	Tianxiang_Xu
--@note		众筹获奖名单

WndCollectRewardList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCollectRewardList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLogList = nil 
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCollectRewardList:_unInit()
	self.m_root = nil
	self.m_tLogList = nil 
	self.m_nLoadingId = nil 
end

CellCollectRewardLog = {}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCollectRewardList:createElement()
	if WndCollectRewardList.m_root ~= nil then
		WindowManager:removeWindow(WndCollectRewardList.m_root, WndCollectRewardList, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCollectRewardList")
	assert(element, "WndCollectRewardList create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCollectRewardList:showInterface()
	-- body
	local wnd = WndCollectRewardList:createElement()
	if wnd then 
		WindowManager:addWindow(wnd, WndCollectRewardList, nil, nil, nil, true)
	end
end

--@brief 	创建日志节点
function CellCollectRewardLog:createLogElement()
	-- body
	local tNewObj = self:_new()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellCollectRewardLog")
    element:setAbsContentSize(GlobalMethod:CCSize(700,50))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCollectRewardLog:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief 	设置数据
function WndCollectRewardList:setLogData(playerName, timestamp)
	-- body
	self:_closeLoading()
	WZLog("WndCollectRewardList:setLogData")
	self.m_tLogList = {}
	for i = 1, #playerName do
		local tItem = {}
		tItem.name = playerName[i]
		tItem.time = timestamp[i]
		local sDate = os.date("*t", tItem.time)
		tItem.date = sDate.year .. LocalStrings.SPACE30 .. sDate.month .. LocalStrings.SPACE31 .. sDate.day .. LocalStrings.SPACE32 .. sDate.hour .. LocalStrings.HOUR .. sDate.min .. LocalStrings.MINUTE

		table.insert(self.m_tLogList, tItem)
	end

	self:_createLogList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndCollectRewardList:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndCollectRewardList:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end




-------------------------------------私有方法模块End----------------------------------------
