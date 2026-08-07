--WndwardrobeData.lua
--@brief	Wndwardrobe的数据模块
--@date		2016/08/17
--@author	zsq
--@note		衣橱

Wndwardrobe = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function Wndwardrobe:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDressGrid = nil
	self.conPlayer = nil
	self.m_tIDList = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
	self.m_tSuitList = nil				--时装套装
	self.btnTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function Wndwardrobe:_unInit()
	self.m_root = nil
	self.m_tDressGrid = nil
	self.conPlayer = nil
	self.m_tIDList = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
	self.m_tSuitList = nil
	self.btnTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function Wndwardrobe:createElement()
	local element = WZUISystem:getInstance():createElement("Wndwardrobe")
	assert(element, "Wndwardrobe create element failed!")
	self:_init()
	return element
end

--@brief 	更新多套时装数据
function Wndwardrobe:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
    	self.m_tCellDressSuit:changeDressSuitOK()
    else
    	self.m_tCellDressSuit:setSuitData()
    end
end

--@brief 	获取时装套装数据
function Wndwardrobe:setSuitAndWingData()
	-- body
	self.m_tSuitList = {}
	local sex = CacheCenter:getPlayerInfo().sex

	for i, v in pairs(GDatatab_enchanting) do
		local tItem = {}

		if v.display ~= -1 then 
			local tSuit 
			if sex == 0 then 
				tSuit = v.item_id1[1]
			else
				tSuit = v.item_id2[1]
			end
			local nCount = 0 
			local tLastTime = {0, 0, 0}
			local tColor = {0,0,0}
			for j = 1, #tSuit do
				local lastTime = CacheCenter:getPlayerItemCountById(tSuit[j])
				if lastTime == -1 or lastTime > 0 then 
					nCount = nCount + 1
					tLastTime[j] = lastTime
					tColor[j] = CacheCenter:getColorById(tSuit[j])
				end
			end

			tItem.suitId = tSuit
			tItem.lastTime = tLastTime
			tItem.id = v.id
			tItem.display = v.display
			tItem.suit = v.suit 
			tItem.count = nCount
			tItem.color = tColor	

			if nCount >= 3 then  
				table.insert(self.m_tSuitList, tItem)
			end
		end
	end
end

--@brief 	获取收集的套数
function Wndwardrobe:getCollectSuitNum()
	-- body
	local num = 0
	for i = 1, #self.m_tSuitList do
		if self.m_tSuitList[i].count >= 3 then 
			num = num + 1 
		end
	end
	return num 
end

--@brief 	获取玩家所拥有时装id
function Wndwardrobe:getAllSuit()
	-- body
	local equipmentList = CacheCenter:getPlayerItems()
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local isUseId = {[1]=0,[2]=0,[3]=0,[4]=0}
	local tab1 = {}
	local tab2 = {}
	local tab3 = {}
	local tab4 = {}
	for i=1,4 do
		local set = false
		local fight = 0
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
				if equipmentList[j].lastTime == -1 or equipmentList[j].lastTime > 0 then
					if i == 1 then
						WZLog("玩家的时装",Serialize(equipmentList[j]))
						table.insert(tab1,equipmentList[j].playerItemId)
						if equipmentList[j].isUse then
							isUseId[i] = equipmentList[j].playerItemId
						end
					elseif i == 2 then
						table.insert(tab2,equipmentList[j].playerItemId)
						if equipmentList[j].isUse then
							isUseId[i] = equipmentList[j].playerItemId
						end
					elseif i == 3 then
						table.insert(tab3,equipmentList[j].playerItemId)
						if equipmentList[j].isUse then
							isUseId[i] = equipmentList[j].playerItemId
						end
					elseif i == 4 then
						table.insert(tab4,equipmentList[j].playerItemId)
						if equipmentList[j].isUse then
							isUseId[i] = equipmentList[j].playerItemId
						end
					end
				end
			end
		end
	end
	return tab1,tab2,tab3,tab4,isUseId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	缓存推送更新物品时调用的函数
function Wndwardrobe:updatePlayerItemData()
	WZLog("Wndwardrobe:updatePlayerItemData")
	if self.m_root == nil then return end
	self:update()
end

--@brief   添加人物形象和装备栏
function Wndwardrobe:_addPlayer()
	local conPlayer = self.m_root:getChildElement("conRole_Wndwardrobe")
	if conPlayer:getChildByTag(20) then
		conPlayer:removeChildByTag(20,true)
	end
	local celElement = WndPlayer:createElement()
	celElement:setTag(20)
	conPlayer:addChild(celElement)
	WndPlayer:btnGoodsFullShow(false)
end

function Wndwardrobe:onVIP(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	local tData = CacheCenter:getPlayerInfo()
	local vipLevel = tData.vipLevel
	local tData = {vipLevel=vipLevel,other=self.m_bCheckOther,id=tData.id}
	WndTips:show(element,self.m_root,20,tData,GlobalMethod:ccp(65,70))
	WndTips.m_root:setShowAll(true)
end

-------------------------------------私有方法模块End----------------------------------------
