--CellFootballGuessShopData.lua
--@brief	CellFootballGuessShop的数据模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩商店列表

CellFootballGuessShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFootballGuessShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.m_bIsLoad = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFootballGuessShop:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoad = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFootballGuessShop:createElement()
	local obj = {}
    setmetatable(obj, {__index = CellFootballGuessShop})
    obj:_init()

    local element = WZUIContainer:create()
    element:setName("__CellFootballGuessShop")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(186,200))
    element:setLuaObjectIndex(obj)

    return element,obj
end

--@brief 	 设置数据
function CellFootballGuessShop:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief    购买成功，更新剩余次数
function CellFootballGuessShop:updateLeftTimes(id, leftNum)
    -- body
    if CellFootballGuessShop.m_current.m_tData.id == id then 
        CellFootballGuessShop.m_current:setLeftTimes(leftNum)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellFootballGuessShop:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
