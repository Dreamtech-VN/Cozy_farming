--WndFourStarChooseRewardData.lua
--@brief	WndFourStarChooseReward的数据模块
--@date		2021/02/23
--@author	hyx
--@note		奖励选择模块

WndFourStarChooseReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFourStarChooseReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tAReward = {} --A奖池
	self.m_tASelectReward = {} --选中的
	self.m_tSReward = {} --A奖池
	self.m_tSSelectReward = {} --选中的
	self.m_tSelectChooseItem = {} --选项
	self.m_tASelectChooseIndex = {} --A奖池选择
	self.m_tSSelectChooseIndex = {} --S奖池选择
	self.m_nVersion = nil
	self.m_nRefreshItem = 1
	self.m_nRefreshCount = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFourStarChooseReward:_unInit()
	self.m_root = nil
	self.m_tAReward = {}
	self.m_tASelectReward = {}
	self.m_tSReward = {}
	self.m_tSSelectReward = {}
	self.m_tSelectChooseItem = {}
	self.m_tASelectChooseIndex = {}
	self.m_tSSelectChooseIndex = {}
	self.m_nVersion = nil
	self.m_nRefreshItem = 1
	self.m_nRefreshCount = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFourStarChooseReward:createElement()
	if WndFourStarChooseReward.m_root ~= nil then
		WindowManager:removeWindow(WndFourStarChooseReward.m_root, WndFourStarChooseReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFourStarChooseReward")
	assert(element, "WndFourStarChooseReward create element failed!")
	self:_init()
	return element
end
-- 奖励的数据
function WndFourStarChooseReward:setASRewardData(data)
	self:setData(data.itemIdAs, data.itemNumAs, data.itemIndexAs, data.selectAs, self.m_tAReward, self.m_tASelectReward)
	self:setData(data.itemIdSs, data.itemNumSs, data.itemIndexSs, data.selectSs, self.m_tSReward, self.m_tSSelectReward)
end
function WndFourStarChooseReward:setData(itemId, itemNum, itemIndex, selectIndex, m_tReward, m_tSelectReward)
	if not itemId then return end
	local table_sort = table.sort
	for i,v in pairs(itemId) do
		local tab = {}
		tab.id = itemId[i]
		tab.num = itemNum[i]
		tab.index = itemIndex[i]
		m_tReward[i] = tab
	end
	table_sort(m_tReward, function(a,b) return a.index < b.index end)
	for i,v in pairs(selectIndex) do
		m_tSelectReward[i] = selectIndex[i]
	end
end
function WndFourStarChooseReward:showChooseReward(node, data, select_data, tag_index, selectIndex)
	if not node then return end
	for i=1, #data do
		if i > 8 then return end
		local key = "id_"..data[i].id
		local num = data[i].num
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item[key])}

		local celElement,tLuaObj = CellGoodItem:createElement()
		node:addChild(celElement)
		self.m_tSelectChooseItem[tag_index+i] = celElement

		if celElement and tLuaObj then
			celElement:setVisible(true)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			tLuaObj:setCellGoodItem(itemInfo, 17)
			celElement:setTag(tag_index+i)
			
			for m=1,#select_data do
				if select_data[m] ~= -1 and data[i].index == select_data[m] then
					selectIndex[tag_index+i] = true		
					tLuaObj:setChooseSelect()
				end
			end
			tLuaObj:setItemClickFun(WndFourStarChooseReward,self.onItemClick)
			local _x = 45 + (i-1) * 80
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 50))
		end
	end
end
function WndFourStarChooseReward:onItemClick(tCell,tag,tData)
    if tData == nil or tCell == nil then
       return
    end
    --A奖池
    if tag < 10 then
	    if self.m_tASelectChooseIndex[tag] == nil then
	    	if getnTableCount(self.m_tASelectChooseIndex) >= 2 then
		    	MsgBoxManager:showTipBox(LocalStrings.FOURSTAR_TEXT12)
		    	return
		    end
	    	self.m_tASelectChooseIndex[tag] = true
		    tCell:setChooseSelect()
	    else
	    	self.m_tASelectChooseIndex[tag] = nil
		    tCell:setChooseNormal()
	    end
	else
	    --S奖池
	    if self.m_tSSelectChooseIndex[tag] == nil then
	    	if getnTableCount(self.m_tSSelectChooseIndex) >= 2 then
		    	MsgBoxManager:showTipBox(LocalStrings.FOURSTAR_TEXT12)
		    	return
		    end
	    	self.m_tSSelectChooseIndex[tag] = true
		    tCell:setChooseSelect()
	    else
	    	self.m_tSSelectChooseIndex[tag] = nil
		    tCell:setChooseNormal()
	    end
	end
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndFourStarChooseReward.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
