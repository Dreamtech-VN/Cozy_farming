--CellCharmRankData.lua
--@brief	CellCharmRank的数据模块
--@date		2016/08/24
--@author	mpt
--@note		鲜花榜排名

CellCharmRank = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCharmRank:_init()
	self.m_root = nil  			--Cell的根节点
	self.tData = nil		--玩家信息
	self.rank = nil			--玩家名次
	self.flowerNum = nil	--玩家鲜花数
	self.tag = nil 	
	self.onLoad = false		
	self.m_tOtherInfo = nil 
	self.m_nRankType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCharmRank:_unInit()
	self.m_root = nil
	self.tData = nil
	self.rank = nil
	self.flowerNum = nil
	self.tag = nil
	self.onLoad = nil
	self.m_tOtherInfo = nil 
	self.m_nRankType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCharmRank:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCharmRank table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellCharmRank element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(575,62))
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellCharmRank:onLoadData( element )
	local cellElement = WZUISystem:getInstance():createElement("CellCharmRank")
	self.m_root:addChild(cellElement)
	self.onLoad = true
	self:_update()
end

--@brief	获得数据
function CellCharmRank:setData( tag,rank,playerId,photoUrl,playerName,sex,level,cross,partner,server,community,flowerNum )
	if self.tData == nil then
		self.tData = {}
	end
	self.tData.playerId = playerId
	self.tData.playerName = playerName
	self.tData.level = level
	self.tData.photoUrl = photoUrl
	self.tData.sex = sex
	self.tData.cross = cross
	self.tData.server = server
	self.tData.community = community
	self.tData.partner = partner

	self.rank = rank
	self.flowerNum = flowerNum
	self.tag = tag

	--WZLog("---CellCharmRank:setdata---",Serialize(self.tData),self.rank,self.flowerNum)
end

--@brief 	设置玩家形象数据
function CellCharmRank:setRoleInfo(tData)
	-- body
	self.m_tOtherInfo = tData
end

--@brief 	设置榜单类型
function CellCharmRank:setRankType(nType)
	-- body
	self.m_nRankType = nType
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCharmRank:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
