--WndChristmasTreeBagData.lua
--@brief	WndChristmasTreeBag的数据模块
--@date		2017/12/06
--@author	Tianxiang_Xu
--@note		圣诞树活动临时背包

WndChristmasTreeBag = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChristmasTreeBag:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBagList = nil 
	self.m_nBagMaxNum = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChristmasTreeBag:_unInit()
	self.m_root = nil
	self.m_tBagList = nil 
	self.m_nBagMaxNum = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChristmasTreeBag:createElement()
	if WndChristmasTreeBag.m_root ~= nil then
		WindowManager:removeWindow(WndChristmasTreeBag.m_root, WndChristmasTreeBag, true)
	end
	local element = WZUISystem:getInstance():createElement("WndChristmasTreeBag")
	assert(element, "WndChristmasTreeBag create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndChristmasTreeBag:showInterface(tBagList, nBagMaxNum)
	-- body
	local wndbag = WndChristmasTreeBag:createElement()
	if wndbag then 
		self.m_tBagList = tBagList 
		self.m_nBagMaxNum = nBagMaxNum or 200
		WindowManager:addWindow(wndbag, WndChristmasTreeBag, nil, nil, nil, true)
	end
end

--@brief 	设置礼物箱数据
function WndChristmasTreeBag:setBagListData(itemId, itemNum)
	-- body
	if self.m_root == nil then return end 
	
	self.m_tBagList = {}
	for i = 1, #itemId do
		local tItem = {}
		tItem.id = itemId[i]
		tItem.num = itemNum[i]

		table.insert(self.m_tBagList, tItem)
	end
end

--@brief 	一键整理成功
--@param 	nType : 1->整理；2->提取
function WndChristmasTreeBag:operateOK(itemId, itemNum, nType)
	-- body
	if self.m_root == nil then return end 
	
	self:setBagListData(itemId, itemNum)
	WndChristmasTree:setBagListData(itemId, itemNum)

	if nType == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT18)
	elseif nType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT19)
	end
	--刷新背包列表
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
