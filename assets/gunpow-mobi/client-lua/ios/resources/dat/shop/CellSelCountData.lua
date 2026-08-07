--CellSelCountData.lua
--@brief	CellSelCount的数据模块
--@date		2015-5-26
--@author	binshao
--@note		商城道具类型选择模块

CellSelCount = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSelCount:_init()
	self.m_root = nil  			    --Cell的根节点
	self.curData = nil 			--道具数据
    self.m_tCallBackFunc = nil      -- 回调函数
    self.m_nCurPrice = nil          -- 当前选中商品的价格
    self.curInfo = {}            -- 商品的当前信息,存放当前商品的id，服务器发过来的index
    self.showDay = nil
    self.maxTag = 0               -- 用于记录当前的选择数量的最大tag，主要是用来表示限购商品，保证限购商品的最后一项的index = -1
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSelCount:_unInit()
	self.m_root = nil
	self.curData = nil
    self.m_tCallBackFunc = nil
    self.m_tPrice = nil
    self.curInfo = nil
    self.showDay = nil
    self.maxTag = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSelCount:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSelCount table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSelCount")
	assert(element, "CellSelCount element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 设置当前商品的数据
function CellSelCount:SetCellPriceData(tData)
    self.curData = {}
    self.curInfo = {}
    self.curData = tData
    self.showDay = tData.initData.basicInfo.use_type == 1 and true or false
    -- 记录购买物品的商城ID
    self.curInfo.id = tData.initData.id
    self.curInfo.index = 0
    self.curInfo.tag = 1
    self.curInfo.moneyId = tData.initData.moneyId

    --更新函数
    self:_update()
end

-- 设置回调
function CellSelCount:SetCallBackFunc(element,backFunc)
    self.m_tCallBackFunc = {}
    self.m_tCallBackFunc[1] = element
    self.m_tCallBackFunc[2] = backFunc
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSelCount:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- 设置折扣价格
function CellSelCount:_initDownPrice()
    local curData = self.curInfo.data

    -- 打折比例
    local offPrice = self.curData.initData.discount/10000

    -- 原始价格 = 底价/第一个商品的个数
    local initPrice =  curData[1].price/curData[1].num

    -- 计算折扣信息
    local down = {}
    for i = 1, #curData do
        local curPrice = curData[i].price/curData[i].num
        local dis = curPrice*offPrice/initPrice*10
        table.insert(down,dis)
        -- 同时改变显示的价格，打折后的价格
		local price = curData[i].price
        curData[i].price = math.ceil(curData[i].price*offPrice)
		if curData[i].price == price and offPrice < 1 then
			curData[i].price = curData[i].price - 1
		end
    end
    self.curInfo.down = down
end
-------------------------------------私有方法模块End----------------------------------------
