--WndDevourData.lua
--@brief	WndDevour的数据模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		吞噬

WndDevour = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndDevour:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 			--祝福数据
	self.m_nInterfaceIndex = 1 	--进入默认1:吞噬界面，2：吞噬选择界面
	self.m_nUpgradeLevel = 0 	--当前选择吞噬的祝福可提升的等级
	self.m_tCellGrids = nil 	--空格子
	self.m_tDevourList = nil 	--可用于被吞噬的祝福
	self.m_nMaxGrids = 20 		--最大的格子数
	self.m_tChooseList = {} 	--已经选择的祝福
	self.m_nGridsIndex = 1 	--加载格子索引
	self.m_tSureDevourList = nil 	--确定可用于吞噬的祝福
	self.m_nTotalExp = 0 		--可获得的总经验
	self.m_nTotalMaxNum = 8 	--一次可以选的最大数量
	self.m_nType = 1 			--1:吞噬界面，2:装备祝福选择界面
	self.m_tLastEquipCell = nil --上一个选中的待装备的祝福表结构
	self.m_tEquipItem = nil 	--选择装备的祝福
	self.m_tCallBack = nil 
	self.m_nEquipRectIndex = nil 	--装备到的装备栏的索引
	self.m_nLoadingId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDevour:_unInit()
	self.m_root = nil
	self.m_tData = nil 			--祝福数据
	self.m_nInterfaceIndex = nil 	--进入默认吞噬界面，2：吞噬选择界面
	self.m_nUpgradeLevel = nil  	--当前选择吞噬的祝福可提升的等级
	self.m_tCellGrids = nil 	--空格子
	self.m_tDevourList = nil 	--可用于被吞噬的祝福
	self.m_nMaxGrids = nil 		--最大的格子数
	self.m_tChooseList = nil 	--已经选择的祝福
	self.m_nGridsIndex = nil 	--加载格子索引
	self.m_tSureDevourList = nil 	--确定可用于吞噬的祝福
	self.m_nTotalExp = nil 		--可获得的总经验
	self.m_nTotalMaxNum = nil 	--一次可以选的最大数量
	self.m_nType = nil 			--1:吞噬界面，2:装备祝福选择界面
	self.m_tLastEquipCell = nil --上一个选中的待装备的祝福表
	self.m_tEquipItem = nil 	--选择装备的祝福 
	self.m_tCallBack = nil 
	self.m_nEquipRectIndex = nil 	--装备到的装备栏的索引
	self.m_nLoadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndDevour:createElement()
	local element = WZUISystem:getInstance():createElement("WndDevour")
	assert(element, "WndDevour element create failed!")
	self:_init()
	return element
end

--@brief 	设置吞噬的祝福的数据
--@param 	tData : 祝福数据
--@param 	tDevourList : 有可能用于被吞噬的祝福
function WndDevour:setData(tData, tDevourList)
	--body
	if self.m_nType == 1 then
		if tData == nil then return end
		self.m_tData = tData
	end

	self.m_tDevourList = tDevourList
	if self.m_nType == 1 then
		table.sort(self.m_tDevourList, sortDevourList)
	elseif self.m_nType == 2 then
		table.sort(self.m_tDevourList, sortDevourListDesc)
	end

	self:_update()
end

--@brief 	排序方法
--@note 	由低到高
function sortDevourList(a, b)
	-- body
	local value1 = WndDevour:checkSortExp(a)
	local value2 = WndDevour:checkSortExp(b)
	if value1 ~= value2 then
		return value1 > value2 
	elseif a.quality ~= b.quality then
		return a.quality < b.quality 
	elseif a.level ~= b.level then
		return a.level < b.level
	else
		return a.id < b.id
	end
end

--@brief 	检查是否经验祝福
function WndDevour:checkSortExp(a)
	-- body
	if a.basicInfo.sub_type == 32 then
		return 2
	else
		return 1
	end
end

--@brief 	排序方法
--@note 	由高到低
function sortDevourListDesc(a, b)
	-- body
	if a.quality ~= b.quality then
		return a.quality > b.quality 
	elseif a.level ~= b.level then
		return a.level > b.level
	else
		return a.id < b.id
	end
end

--@brief 	吞噬界面外部接口
--@param 	nType:1->吞噬界面；2->装备祝福选择界面
--@param 	tDataList:列表数据
--@param 	tCell:回调函数所在的表
--@param 	func:回调函数
--@param 	nEquipRectIndex:装备到的装备栏的索引
function WndDevour:show(nType, tDataList, tCell, func, nEquipRectIndex)
	-- body
	if WndDevour.m_root then return end

	local wndDevour = WndDevour:createElement()
    if wndDevour then
    	self.m_nType = nType 
    	self.m_nEquipRectIndex = nEquipRectIndex
        WindowManager:addWindow(wndDevour, WndDevour)
        local tDevourList = tDataList
        self:setCallBack(tCell, func)
        WndDevour:setData(tData, tDevourList, true)
    end
end

function WndDevour:setCallBack(tCell, func)
	-- body
	WZLog("WndDevour:setCallBack")
	self.m_tCallBack = {}
	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
