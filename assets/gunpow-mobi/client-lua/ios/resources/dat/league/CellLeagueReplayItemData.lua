--CellLeagueReplayItemData.lua
--@brief	CellLeagueReplayItem的数据模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-回放列表项

CellLeagueReplayItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLeagueReplayItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_bIsLoaded = nil 		--是否已经执行过onLoadData函数
	self.m_tData = nil 
	self.m_nIndex = nil 
	self.m_tCallBack = nil 
	self.b_isClicked = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLeagueReplayItem:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil 
	self.m_tData = nil 
	self.m_nIndex = nil 
	self.m_tCallBack = nil 
	self.b_isClicked = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLeagueReplayItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLeagueReplayItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellLeagueReplayItem")
	element:setAbsContentSize(GlobalMethod:CCSize(673,118))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	设置数据
--@param 	nIndex:1->正在进行；2->精彩回放；3->决赛回放；4->我的回放
function CellLeagueReplayItem:setData(nIndex, tData)
	-- body
	self.m_nIndex = nIndex
	self.m_tData = tData 
end

--@brief 	设置点击回调
function CellLeagueReplayItem:setCallFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLeagueReplayItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
