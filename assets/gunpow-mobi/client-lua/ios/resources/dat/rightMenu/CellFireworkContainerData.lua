--CellFireworkContainerData.lua
--@brief	CellFireworkContainer的数据模块
--@date		2017/06/14
--@author	qixiang
--@note		播放烟花

CellFireworkContainer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFireworkContainer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFireworkdType = nil
	self.m_nFireworkdLiftTIme = 1.5
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFireworkContainer:_unInit()
	self.m_root = nil
	self.m_nFireworkdType = nil
	self.m_nFireworkdLiftTIme = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFireworkContainer:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFireworkContainer table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellFireworkContainer")
	assert(element, "CellFireworkContainer element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellFireworkContainer:setFireworkInfo(fireworkType)
	WZLog("CellFireworkContainer:setFireworkInfo ",fireworkType)
	if fireworkType == 1 then
		self.m_nFireworkdLiftTIme = 1.5
	elseif fireworkType == 2 then
		self.m_nFireworkdLiftTIme = 1.5
	elseif fireworkType == 3 then
		self.m_nFireworkdLiftTIme = 1.5
	end          
end

function CellFireworkContainer:setFlowerTime(time)
	self.m_nFireworkdLiftTIme = tonumber(time) or 3         
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function CellFireworkContainer:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
