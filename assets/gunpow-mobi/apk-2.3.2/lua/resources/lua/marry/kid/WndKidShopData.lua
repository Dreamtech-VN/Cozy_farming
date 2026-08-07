--WndKidShopData.lua
--@brief	WndKidShop的数据模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小家商店

WndKidShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 					--类型 1->家具;2->装饰;5->食物;7->背包
	self.m_tDataList = nil 				--数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidShop:_unInit()
	self.m_root = nil
	self.m_nType = nil 					--类型
	self.m_tDataList = nil 				--数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidShop:createElement()
	if WndKidShop.m_root ~= nil then
		WindowManager:removeWindow(WndKidShop.m_root, WndKidShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidShop")
	assert(element, "WndKidShop create element failed!")
	self:_init()
	return element
end

--@brief	设置类型
function WndKidShop:setType(nType)
	-- body
	self.m_nType = nType
end

--@brief	设置数据
function WndKidShop:setDataByType(nType)
	-- body
	self.m_tDataList = {}
	if nType == 1 then
		SceneKidHome:getBuildingAndOrnamentsData(self, self.getShopData, nType)
	elseif nType == 2 then
		SceneKidHome:getBuildingAndOrnamentsData(self, self.getShopData, nType)
	elseif nType == 5 then
		--获取缓存的商品
    	CacheCenter:getShopItems(self.getShopItemsListCallBack, self)
	elseif nType == 7 then
		self.m_tDataList = CacheCenter:getHomeBagData()

		self:_update()
	end
end

--@brief	背包物品数量变化后，刷新数量
function WndKidShop:updatePlayerHomeItemData()
	--body
	WZLog("WndKidShop:updatePlayerHomeItemData", self.m_nType)
	if self.m_root == nil then return end 
	if self.m_nType ~= 7 then return end 
	
	--重新刷新列表
	self:setDataByType(self.m_nType)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 获得商城的所有商品列表
function WndKidShop:getShopItemsListCallBack(shopItemList)
	WZLog("WndKidShop:getShopItemsListCallBack---------", #shopItemList)
    self:initFoodShopList(shopItemList)

    self:_update()
end

function WndKidShop:initFoodShopList(list)
	-- body
	local tTempList = {}
	for i = 1, #list do
        if list[i].isOnSale then
            local curType = json.decode(list[i].mainType)
            for k,v in pairs(curType) do
                local mainType = tonumber(k)
                local subType = tonumber(v)
                local newData = {}
                newData.initData = list[i]
                newData.mainType = mainType
                newData.subType = subType

                -- 主类型为7的才是本模块相关的
				if mainType == 7 and subType == 4 then
                	table.insert(tTempList, newData)
				end
            end
        end
    end

    self.m_tDataList = tTempList
end


-------------------------------------私有方法模块End----------------------------------------
