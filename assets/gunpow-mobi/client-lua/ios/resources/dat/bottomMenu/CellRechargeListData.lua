--CellRechargeListData.lua
--@brief	CellRechargeList的数据模块
--@date		2014/01/20
--@author	林庆凯
--@note		充值产品列表

CellRechargeList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRechargeList:_init()
	self.m_root = nil  			  --Cell的根节点
	self.m_sImgProductPath = nil  --产品图片的相对路径
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRechargeList:_unInit()
	self.m_root = nil
	self.m_sImgProductPath = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRechargeList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRechargeList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellRechargeList")
	assert(element, "CellRechargeList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 设置产品价格、图片、钻石数量的函数
--@param #1 sTxtPrice       产品价格 ￥50
--@param #2 sImgProductPath 产品图片
--@param #3	nDiamondNum		钻石数量
function CellRechargeList:setProductInfo(sTxtPrice,sImgProductPath,nDiamondNum,sDisCountNum)
	self.m_sTxtPrice = sTxtPrice or self.m_sTxtPrice
	self.m_sImgProductPath = sImgProductPath or self.m_sImgProductPath
	self.m_nDiamondNum = nDiamondNum or self.m_nDiamondNum
	self.m_sDisCountNum = sDisCountNum or self.m_sDisCountNum
    WZLog("CellRechargeList:setProductInfo",sTxtPrice,sImgProductPath,tostring(nDiamondNum), tostring(sDisCountNum),self.m_sDisCountNum)
	self:_update()
end 


--@brief	设置产品图片的函数
--@param 产品图片
function CellRechargeList:setImgProduct(sImgProductPath)
	self.m_sImgProductPath = sImgProductPath
	self:_setImgProduct()
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRechargeList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
