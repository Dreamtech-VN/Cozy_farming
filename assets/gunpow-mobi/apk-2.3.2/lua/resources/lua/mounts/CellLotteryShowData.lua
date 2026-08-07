--CellLotteryShowData.lua
--@brief	CellLotteryShow的数据模块
--@date		2021/05/25
--@author	hyc
--@note		抽奖展示cell

CellLotteryShow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellLotteryShow:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_data = nil
	self.n_type = nil
	self.n_natural = nil				--宠物资质			
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLotteryShow:_unInit()
	self.m_root = nil
	self.n_data = nil
	self.n_type = nil
	self.n_natural = nil				--宠物资质
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellLotteryShow:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellLotteryShow table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellLotteryShow")
	assert(element, "CellLotteryShow element create failed")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj

end

function CellLotteryShow:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

function CellLotteryShow:setData(nType,data)
	-- body
	WZLog("抽奖xinxi",nType,Serialize(data))
	self.n_type = nType
	self.n_data = data
end

function CellLotteryShow:setNatural(natural)
	WZLog("宠物资质",natural)
	-- body
	self.n_natural = natural
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
