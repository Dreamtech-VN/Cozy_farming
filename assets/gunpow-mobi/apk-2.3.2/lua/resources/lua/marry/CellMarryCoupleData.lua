--CellMarryCoupleData.lua
--@brief	CellMarryCouple的数据模块
--@date		2021/02/23
--@author	yrd
--@note		夫妻人物形象

CellMarryCouple = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMarryCouple:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nCurDir = 0			--宾客当前朝向			
	self.m_nWalkLen = 0			--宾客已经移动的距离，单位为像素
	self.m_nPlayerId = 0		--宾客ID
	self.m_sPlayerName = nil    --宾客名字
	self.m_nSex = nil
	self.m_tEquipment = {}      --存放玩家装备
	self.m_tPlayerAni = nil
	self.m_nMoveIndex = 1     --玩家移动位置下标
	self.m_nStopSecond = 3      --玩家停留多少秒后移动
	self.m_nSchedulCount = 0
	self.m_tConPlayer = nil
	self.m_oConBlessing = nil
	self.m_tOldFootPos = nil
	self.m_nFootId = nil
	self.m_tMoveDest = {}
    self.m_nServerId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMarryCouple:_unInit()
	self.m_root = nil
	self.m_nCurDir = nil				
	self.m_nWalkLen = nil
	self.m_nPlayerId = nil
	self.m_tEquipment = nil
	self.m_nSex = nil
	self.m_sPlayerName = nil
	self.m_tPlayerAni = nil
	self.m_nMoveIndex = nil
	self.m_nStopSecond = nil
	self.m_nSchedulCount = nil
	self.m_tMoveDest = nil
	self.m_tConPlayer = nil
	self.m_oConBlessing = nil
	self.m_tOldFootPos = nil
	self.m_nFootId = nil
    self.m_nServerId = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMarryCouple:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMarryCouple table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMarryCouple")
	assert(element, "CellMarryCouple element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


--@brief	获得宾客当前朝向
--@param	#:宾客朝向
function CellMarryCouple:getCurDir()
	return self.m_nCurDir
end

--@brief	设置宾客移动的距离
--@param	nWalkLen:宾客移动的距离
function CellMarryCouple:setWalkLen(nWalkLen)
	self.m_nWalkLen = nWalkLen
end

--@brief	获得宾客移动的距离
--@param	#1:宾客移动的距离
function CellMarryCouple:getWalkLen()
	return self.m_nWalkLen
end

--@brief	设置宾客ID
--@param	nId:宾客ID
function CellMarryCouple:setPlayerId(nId)
	self.m_nPlayerId = nId
end


--@brief	设置宾客名字
--@param	sName:宾客名字
function CellMarryCouple:setPlayerName(sName, serverId)
	self.m_sPlayerName = sName
	self.m_nServerId = serverId
end 

function CellMarryCouple:setFootId(id)
	self.m_nFootId = id
end

--@brief   设置玩家装备
function CellMarryCouple:setEquipment(bSexFlag,sFaceImg,sHeadImg,nRandomClothes,headColor,bodyColor,weddingType)
	self.m_nSex = bSexFlag 
	table.insert(self.m_tEquipment,sFaceImg)
	table.insert(self.m_tEquipment,sHeadImg)
	table.insert(self.m_tEquipment,nRandomClothes)
	table.insert(self.m_tEquipment,headColor)
	table.insert(self.m_tEquipment,bodyColor)
	self.m_nWeddingType = weddingType
end


--@brief	定时器显示玩家
--@param	element:容器引用对象
--@param	delta:偏移秒数
function CellMarryCouple:ScheduleShowPlayer(element,delta)
	element:disableSchedule()
	GetElement(self.m_root, "conShow_CellMarryCouple", WZUIContainer):setVisible(true)
end 



--@brief	获得宾客ID
--@param	#1:宾客ID
function CellMarryCouple:getPlayerId()
	return self.m_nPlayerId
end

--@brief	获得宾客名字
--@param	#1:宾客ID
function CellMarryCouple:getPlayerName()
	return self.m_sPlayerName
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMarryCouple:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
