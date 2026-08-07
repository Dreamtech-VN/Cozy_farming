--CellUnionMemberListData.lua
--@brief	CellUnionMemberList的数据模块
--@date		2024/01/10
--@author	XTX
--@note		联盟成员列表Item界面

CellUnionMemberList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellUnionMemberList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nTxtRanking = nil          --排名
	self.m_nLevelNum = nil            -- 玩家等级数量
	self.m_sPlayerName = nil         --玩家姓名
	self.m_nJob = nil          		  --职位 
	self.m_nPlayerContribution = nil  -- 玩家贡献度
	self.m_nTodayContribution = nil   -- 玩家当天贡献度
	self.m_sState = nil               --状态
	self.m_nPlayerId = nil            --玩家ID
	self.m_nHeadId = nil
	self.m_nFaceId = nil
	self.m_nSex = nil
	self.vipLevel = nil
	self.m_nHeadEffectId = nil
	self.m_nFight = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellUnionMemberList:_unInit()
	self.m_root = nil
	self.m_nTxtRanking = nil 
	self.m_nLevelNum = nil 
	self.m_sPlayerName = nil
	self.m_nJob = nil
	self.m_nPlayerContribution = nil
	self.m_nTodayContribution = nil
	self.m_sState = nil 
	self.m_nPlayerId = nil   
	self.m_nHeadId = nil
	self.m_nFaceId = nil
	self.m_nSex = nil
	self.vipLevel = nil
	self.m_nHeadEffectId = nil
	self.m_nFight = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellUnionMemberList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellUnionMemberList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellUnionMemberList")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(880,80))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	设置玩家ID的函数
--@param    玩家ID
function CellUnionMemberList:setPlayerId(nPlayerId)
	self.m_nPlayerId = nPlayerId
end 

--@brief	取得玩家ID的函数
--@return    玩家ID
function CellUnionMemberList:getPlayerId()
	return self.m_nPlayerId
end 

--@brief	设置公会成员列表的函数(排名,玩家等级图片,玩家等级数量,玩家姓名,职位,贡献度,状态 )
--@param #1 nTxtRanking 排名
--@param #2 nLevelNum 玩家等级数量
--@param #3 sPlayerName 玩家姓名
--@param #4 nJob 职位 
--@param #5 playerContribution  玩家贡献度
--@param #6 todayContribution   玩家当天贡献度
--@param #7 sState 状态
function CellUnionMemberList:setData(headId,faceId,nTxtRanking,nLevelNum,sPlayerName,nJob,nPlayerContribution,nTodayContribution,sState,nTime,sex,vipLevel,headColor, headEffectId, fight)										
	self.m_nHeadId = headId
	self.m_nFaceId = faceId
	self.m_nTxtRanking = nTxtRanking
	self.m_nLevelNum = nLevelNum
	self.m_sPlayerName = sPlayerName
	self.m_nJob = nJob
	self.m_nPlayerContribution = nPlayerContribution
	self.m_nTodayContribution = nTodayContribution
	self.m_sState = sState
	self.m_nTime = nTime
	self.m_nSex = sex
	self.vipLevel = vipLevel
	self.headColor = headColor
	self.m_nHeadEffectId = headEffectId
	self.m_nFight = fight
end 


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellUnionMemberList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
