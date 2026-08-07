-- CellCompeteAgent (公会设置代理人模块)
-- @brief: 公会会员列表成员 数据部分
-- @date: 2017-02-24 11:09:20
-- @author: zhenwei_jian
-- @note: 公会设置代理人模块

local CellCompeteAgent = {}

--@param #1 headId 头像ID
--@param #2 faceId 
--@param #3 nTxtRanking 排名
--@param #4 nLevelNum 玩家等级数量
--@param #5 sPlayerName 玩家姓名
--@param #6 nJob 职位 
--@param #7 playerContribution  玩家贡献度
--@param #8 todayContribution   玩家当天贡献度
--@param #9 sState 状态
local mParamsList = {									
	"m_nHeadId" 	 	,
	"m_nFaceId"  		,
	"m_nTxtRanking" 	,
	"m_nLevelNum" 		,
	"m_sPlayerName"  	,
	"m_nJob"		 	,
	"m_nPlayerContr"  	,
	"m_nTodayContri" 	,
	"m_sState" 			,
	"m_nTime" 			,
	"m_nSex"  			,
	"vipLevel"  		,
	"headColor"  		,
	"m_nPlayerId"		,
	"agentMark"		,
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellCompeteAgent:_init()
	self.m_root = nil	 	  				--根节点

	--公会职称 Map 表
	self._mJobNameMap = {
		[COMMUNITY_PRESIDENT 		] = LocalStrings.PRESIDENT,						--会长
		[COMMUNITY_VICE_PRESIDENT 	] = LocalStrings.VICE_PRESIDENT,				--副会长
		[COMMUNITY_ELDER 			] = LocalStrings.ELDERS,						--长老
		[COMMUNITY_ELITE 			] = LocalStrings.PICK,							--精英
		[COMMUNITY_MEMBER 			] = LocalStrings.NORMAL_COMMUNITY_MEMBER,		--普通会员
	}
	self.m_tCallBack = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCompeteAgent:_unInit()
	self.m_root 		= nil
	self._mJobNameMap 	= nil
	self.m_tCallBack = nil 

	for i, k in ipairs(mParamsList) do
		self[k] = nil
	end
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellCompeteAgent:createElement()
	local tInstance = self:_new()
	tInstance:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(736, 102))   --这个容器的大小要和cell的大小一致 
	element:setLuaObjectIndex(tInstance)

	-- local element = WZUISystem:getInstance():createElement("CellCompeteAgent")
	-- element:setLuaObjectIndex(tInstance)
	return element, tInstance
end

--@brief	设置公会成员列表的函数(排名,玩家等级图片,玩家等级数量,玩家姓名,职位,贡献度,状态 )
--@param #1 headId 头像ID
--@param #2 faceId 
--@param #3 nTxtRanking 排名
--@param #4 nLevelNum 玩家等级数量
--@param #5 sPlayerName 玩家姓名
--@param #6 nJob 职位 
--@param #7 playerContribution  玩家贡献度
--@param #8 todayContribution   玩家当天贡献度
--@param #9 sState 状态
function CellCompeteAgent:setData(tData) 
	
	self[ "m_nHeadId" 	 	] = tData.headId
	self[ "m_nFaceId"  		] = tData.faceId
	self[ "m_nTxtRanking" 	] = tData.rank
	self[ "m_nLevelNum" 	] = tData.playerLevel
	self[ "m_sPlayerName"  	] = tData.playerName
	self[ "m_nJob"		 	] = tData.position
	self[ "m_nPlayerContr"  ] = tostring(tData.playerContribution)
	self[ "m_nTodayContri" 	] = tostring(tData.todayContribution)
	self[ "m_sState" 		] = tData.onLineState
	self[ "m_nTime" 		] = tData.onLine
	self[ "m_nSex"  		] = tData.sex
	self[ "vipLevel"  		] = tData.vipLevel
	self[ "headColor"  		] = tData.headColor
	self[ "m_nPlayerId"	 	] = tData.playerId
	self[ "agentMark"	 	] = tData.agentMark

end

--@brief 	点击回调
function CellCompeteAgent:setCallBackFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCompeteAgent:_new( )
	local tInstance = {}
	setmetatable(tInstance, {__index = CellCompeteAgent})
	return tInstance
end

--@brief 获取玩家ID
function CellCompeteAgent:getPlayerId()
	return self.m_nPlayerId
end

-------------------------------------私有方法模块End----------------------------------------


rawset(_G, "CellCompeteAgent", CellCompeteAgent)

