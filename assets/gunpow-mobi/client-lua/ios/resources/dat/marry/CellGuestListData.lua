--CellGuestListData.lua
--@brief	CellGuestList的数据模块
--@date		2014/04/15
--@author	林庆凯
--@note		宾客列表

CellGuestList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGuestList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nCurDir = 0			--宾客当前朝向			
	self.m_nWalkLen = 0			--宾客已经移动的距离，单位为像素
	self.m_nPlayerId = 0		--宾客ID
	self.m_sPlayerName = nil    --宾客名字
	self.m_nSex = nil
	self.m_tEquipment = {}      --存放玩家装备
	self.m_tPlayerAni = nil
	self.m_nRandomIndex = 1     --玩家随机位置
	self.m_nStopSecond = 3      --玩家停留多少秒后移动
	self.m_nSchedulCount = 0
	self.m_tConPlayer = nil
	self.m_oConBlessing = nil
	self.m_tOldFootPos = nil
	self.m_nFootId = nil
	self.m_tMoveDest = {}
    
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGuestList:_unInit()
	self.m_root = nil
	self.m_nCurDir = nil				
	self.m_nWalkLen = nil
	self.m_nPlayerId = nil
	self.m_tEquipment = nil
	self.m_nSex = nil
	self.m_sPlayerName = nil    --宾客名字
	self.m_tPlayerAni = nil
	self.m_nRandomIndex = nil
	self.m_nStopSecond = nil
	self.m_nSchedulCount = nil
	self.m_tMoveDest = nil
	self.m_tConPlayer = nil
	self.m_oConBlessing = nil
	self.m_tOldFootPos = nil
	self.m_nFootId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGuestList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGuestList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellGuestList")
	assert(element, "CellGuestList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


--@brief	获得宾客当前朝向
--@param	#:宾客朝向
function CellGuestList:getCurDir()
	return self.m_nCurDir
end

--@brief	设置宾客移动的距离
--@param	nWalkLen:宾客移动的距离
function CellGuestList:setWalkLen(nWalkLen)
	self.m_nWalkLen = nWalkLen
end

--@brief	获得宾客移动的距离
--@param	#1:宾客移动的距离
function CellGuestList:getWalkLen()
	return self.m_nWalkLen
end

--@brief	设置宾客ID
--@param	nId:宾客ID
function CellGuestList:setPlayerId(nId)
	self.m_nPlayerId = nId
end


--@brief	设置宾客名字
--@param	sName:宾客名字
function CellGuestList:setPlayerName(sName)
	self.m_sPlayerName = sName
end 

function CellGuestList:setFootId(id)
	self.m_nFootId = id
end

--@brief   设置玩家装备
function CellGuestList:setEquipment(bSexFlag,sFaceImg,sHeadImg,nRandomClothes,headColor,bodyColor)
	self.m_nSex = bSexFlag 
	table.insert(self.m_tEquipment,sFaceImg)
	table.insert(self.m_tEquipment,sHeadImg)
	table.insert(self.m_tEquipment,nRandomClothes)
	table.insert(self.m_tEquipment,headColor)
	table.insert(self.m_tEquipment,bodyColor)
end


--@brief	定时器显示玩家
--@param	element:容器引用对象
--@param	delta:偏移秒数
function CellGuestList:ScheduleShowPlayer(element,delta)
	element:disableSchedule()
	GetElement(self.m_root, "conShow_CellGuestList", WZUIContainer):setVisible(true)
end 



--@brief	获得宾客ID
--@param	#1:宾客ID
function CellGuestList:getPlayerId()
	return self.m_nPlayerId
end

--@brief	获得宾客名字
--@param	#1:宾客ID
function CellGuestList:getPlayerName()
	return self.m_sPlayerName
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGuestList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
