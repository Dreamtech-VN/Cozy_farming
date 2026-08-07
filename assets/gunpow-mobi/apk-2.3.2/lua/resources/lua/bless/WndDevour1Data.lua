--WndDevour1Data.lua
--@brief	WndDevour1的数据模块
--@date		2021/04/21
--@author	hyc
--@note		祈福吞噬

WndDevour1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDevour1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil					--祝福数据
	self.m_tDevourList = nil			--可用于被吞噬的数据
	self.m_tBlessList = nil 			--祈福珠列表
	self.m_tChooseList = {}			--选择被吞噬的列表
	self.m_nTotalExp = 0 				--可获得总经验
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDevour1:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tDevourList = nil
	self.m_tBlessList = nil
	self.m_tChooseList = nil
	self.m_nTotalExp = nil
	self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDevour1:createElement()
	-- if WndDevour1.m_root ~= nil then
	-- 	WindowManager:removeWindow(WndDevour1.m_root, WndDevour1, true)
	-- end
	local element = WZUISystem:getInstance():createElement("WndDevour1")
	assert(element, "WndDevour1 create element failed!")
	self:_init()
	return element
end

--@brief 	设置吞噬的祝福的数据
--@param 	tData : 祝福数据
--@param 	tDevourList : 有可能用于被吞噬的祝福
function WndDevour1:setData(tData, tDevourList)
	--body
	-- WZLog("吞噬数据1",Serialize(tData))
	-- WZLog("吞噬数据2",Serialize(tDevourList))
	self.m_tData = tData
	self.m_tDevourList = tDevourList
	table.sort(self.m_tDevourList, sortDevourList)
	self:_update()
end

--@brief 	排序方法
--@note 	由低到高
function sortDevourList(a, b)
	-- body
	local value1 = WndDevour1:checkSortExp(a)
	local value2 = WndDevour1:checkSortExp(b)
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
function WndDevour1:checkSortExp(a)
	-- body
	if a.basicInfo.sub_type == 32 then
		return 2
	else
		return 1
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
