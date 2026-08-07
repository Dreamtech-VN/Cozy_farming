--WndBuyData.lua
--@brief	WndBuy的数据模块
--@date		2015/5/26
--@author	binshao
--@note		点击保存形象时购买的物品

WndBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuy:_init()
	self.m_root = nil	 	  		--场景根节点
	self.propData = nil				--保存物品列表
	self.cellData = {} 			    --当前Cell
    self.buyFlag = nil              -- 是否购买的标志位
    self.realBuyItemId = {}         -- 实际购买的物品ID
    self.m_nLoadingId = nil
	self.propPrice = 0
	self.selSex = nil				-- 当前性别
	self.showType = 2				-- 显示类型
	self.m_tMoneyId = nil
	self.m_tNeedMoney = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBuy:_unInit()
	self.m_root = nil
	self.propData = nil
	self.cellData = nil
    self.buyFlag = nil
    self.realBuyItemId = nil
    self.m_nLoadingId = nil
	self.propPrice = 0
	self.selSex = nil
	self.m_tMoneyId = nil
	self.m_tNeedMoney = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuy:createElement()
	local element = WZUISystem:getInstance():createElement("WndBuy")
	assert(element, "WndBuy create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndBuy:AddCurCellData(tag,cell,tcell)
    if not self.cellData[tag] then self.cellData[tag] = {} end
    self.cellData[tag].cell = cell
    self.cellData[tag].tcell = tcell
end
-------------------------------------私有方法模块End----------------------------------------
