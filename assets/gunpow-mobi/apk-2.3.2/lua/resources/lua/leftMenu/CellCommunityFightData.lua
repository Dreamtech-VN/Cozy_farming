--CellCommunityFightData.lua
--@brief	CellCommunityFight的数据模块
--@date		2016/09/21
--@author	Tianxiang_Xu
--@note		公会战入口

CellCommunityFight = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityFight:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nLeftSeconds = 0 
    self.m_nCurDaySeconds = nil 	--当天的秒数
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityFight:_unInit()
	self.m_root = nil
	self.m_nCommunityState = nil 
    self.m_sCommunityTime = nil 
    self.m_nNextStartTime = nil
    self.m_nLeftSeconds = nil 
    self.m_nCurDaySeconds = nil 	--当天的秒数
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityFight:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityFight table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommunityFight")
	assert(element, "CellCommunityFight element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellCommunityFight:setMessage(nowtime, startime, open)
	-- body
	self.m_nCommunityState = open 
    self.m_sCommunityTime = nowtime 
    self.m_nNextStartTime = startime

    --如果跨天，重新获取数据
    local curDate = SplitStringWithSeparator(self.m_sCommunityTime," ")
    self.m_nCurDaySeconds = TimeToSeconds(curDate[2])
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityFight:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
