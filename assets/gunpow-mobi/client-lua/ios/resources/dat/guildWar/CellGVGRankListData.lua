--CellGVGRankListData.lua
--@brief	CellGVGRankList的数据模块
--@date		2017/02/25
--@author	qixiang
--@note		出线赛与入围赛的cell

CellGVGRankList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGVGRankList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nType = 1            -- 1 (成员) 2 本服（全服）
	self.m_tQualifyingData = nil --成员数据
	self.m_tFinalistComData = nil --本服(全服)数据

end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGVGRankList:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_tQualifyingData = nil --成员数据
	self.m_tFinalistComData = nil --本服(全服)数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGVGRankList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGVGRankList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellGVGRankList")
	assert(element, "CellGVGRankList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--设置成员数据
--rank  排名
--name  名字
--level 等级
--integral 积分
--rate  胜率
function CellGVGRankList:setQualifyingData(rank,playerId,name,level,integral,fightNum,winNum)
	-- body
	WZLog("CellGVGRankList:setQualifyingData")
	self.m_nType = 2
	self.m_tQualifyingData = {}
	self.m_tQualifyingData.name = name
	self.m_tQualifyingData.rank = rank
	self.m_tQualifyingData.level = level
	self.m_tQualifyingData.integral = integral
	self.m_tQualifyingData.fightNum = fightNum
	self.m_tQualifyingData.winNum = winNum
	self.m_tQualifyingData.playerId = playerId
end

--设置全服(本服)数据
--rank 排名
--name 公会名字
--commOrdername 会长名字(服务器名称)
--integral 积分
--rate 胜率
function CellGVGRankList:setFinalistComData(rank,name,commOrdername,integral,fightNum,winNum,commNum)
	-- body
	WZLog("CellGVGRankList:setFinalistComData")
	self.m_nType = 1
	self.m_tFinalistComData = {} --入围赛数据
	self.m_tFinalistComData.name = name
	self.m_tFinalistComData.rank = rank
	self.m_tFinalistComData.commOrdername = commOrdername
	self.m_tFinalistComData.integral = integral
	self.m_tFinalistComData.fightNum = fightNum
	self.m_tFinalistComData.winNum = winNum
	self.m_tFinalistComData.commNum = commNum
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGVGRankList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
