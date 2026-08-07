--CellGuestNumListData.lua
--@brief	CellGuestNumList的数据模块
--@date		2013/12/03
--@author	林庆凯
--@note		婚礼宾客列表是否重生的数据模块，以方便让其它容器动态创建多个Cell

CellGuestNumList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGuestNumList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sLevel =  nil      	--等级的大小
	self.m_sImgSex = nil   		--性别
    self.m_sName = nil   		--姓名
    self.m_nHeadId = nil
    self.m_nFaceId = nil
	self.m_bFlagOnLine = nil    --是否在线的标志
	self.m_nPlayerId = nil      --玩家ID
	self.m_nZsleve = nil        --玩家转生等级
	self.m_nHeadColor = nil
	self.m_cellRoot = nil
	self.m_nServerId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGuestNumList:_unInit()
	self.m_root = nil
	self.m_sLevel =  nil
	self.m_sImgSex = nil  
	self.m_sName = nil   
	self.m_nHeadId = nil
    self.m_nFaceId = nil
	self.m_bFlagOnLine = nil   
	self.m_nPlayerId = nil 
	self.m_nZsleve = nil        --玩家转生等级
	self.m_cellRoot = nil
	self.m_nHeadColor = nil
	self.m_nServerId = nil 
end


-------------------------------------公有方法模块--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGuestNumList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGuestNumList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(440,75)) 
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 设置容器中的相应的内容
--@param #1	m_sLevel    等级的大小
--@param #2 m_sImgSex    性别
--@param #3 m_sName   姓名
function CellGuestNumList:setCellContent(sLevel,sImgSex,sName,headId,faceId,vipLevel,headColor, serverId)
	self.m_sLevel = sLevel
	self.m_sImgSex = sImgSex
	self.m_sName = sName
	self.m_nHeadId = headId
	self.m_nFaceId = faceId
	self.m_nHeadColor = headColor
	self.m_nVipLevel = vipLevel
	self.m_nServerId = serverId
	--self:_update()
end 


--@brief 设置是否在线
--@param #1	bFlagOnLine    是否在线的标志
function CellGuestNumList:setFlagOnLine(bFlagOnLine)
	self.m_bFlagOnLine = bFlagOnLine
end 



--@brief 设置玩家ID的函数
--@param nPlayerId  玩家ID
function CellGuestNumList:setPlayerId(nPlayerId)
	self.m_nPlayerId = nPlayerId
end 


--@brief 设置玩家转生等级的函数
--@param zsleve  玩家转生等级
function CellGuestNumList:setPlayerZsleve(zsleve)
	self.m_nZsleve = zsleve
end 



-------------------------------------私有方法模块--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGuestNumList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
