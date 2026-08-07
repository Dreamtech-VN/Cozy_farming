--cellApartmentAct3Data.lua
--@brief	cellApartmentAct3的数据模块
--@date		2021/09/29
--@author	hyc
--@note		小推车活动cell

cellApartmentAct3 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function cellApartmentAct3:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_bChoose = false 				--选中状态
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function cellApartmentAct3:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bChoose = nil 				--选中状态
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
-- function cellApartmentAct3:createElement()
-- 	if cellApartmentAct3.m_root ~= nil then
-- 		WindowManager:removeWindow(cellApartmentAct3.m_root, cellApartmentAct3, true)
-- 	end
-- 	local element = WZUISystem:getInstance():createElement("cellApartmentAct3")
-- 	assert(element, "cellApartmentAct3 create element failed!")
-- 	self:_init()
-- 	return element
-- end

function cellApartmentAct3:setData(tdata)
	-- body
	WZLog("cellApartmentAct3:setData",Serialize(tdata))
	self.m_tData = tdata
end


function cellApartmentAct3:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDress table create failed!")
	tNewObj:_init()
	--local element = WZUISystem:getInstance():createElement("CellDress")
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
	-- element:setName("__CellDress")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(150,200)) 
	assert(element, "CellDress element create failed!")
	element:setLuaObjectIndex(tNewObj)
	-- tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function cellApartmentAct3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
