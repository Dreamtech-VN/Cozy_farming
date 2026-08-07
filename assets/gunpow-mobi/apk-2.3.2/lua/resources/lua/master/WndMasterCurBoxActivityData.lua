--WndMasterCurBoxActivityData.lua
--@brief	WndMasterCurBoxActivity的数据模块
--@date		2021/08/17
--@author	hyx
--@note		师门宝箱当前活跃度

WndMasterCurBoxActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterCurBoxActivity:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterCurBoxActivity:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterCurBoxActivity:createElement()
	if WndMasterCurBoxActivity.m_root ~= nil then
		WindowManager:removeWindow(WndMasterCurBoxActivity.m_root, WndMasterCurBoxActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMasterCurBoxActivity")
	assert(element, "WndMasterCurBoxActivity create element failed!")
	self:_init()
	return element
end

function WndMasterCurBoxActivity:setData(playerid)
	self.m_nPlayerId = playerid
end
--获取奖励数据
function WndMasterCurBoxActivity:setRewardData(_type,id_myself)
	id_myself = id_myself or nil
	local data = {}
	for _,v in pairs(GDatatab_bag_reward) do	
		if v.bag_type == _type then
			local info = GDatatab_bag_reward["id_"..v.id]
			local tab = {}
			tab.id = info.id
			tab.demand = info.demand
			if id_myself then
				tab.reward = info.master_reward
			else
				tab.reward = info.disciple_reward
			end
			table.insert(data, tab)
		end
	end
	table.sort( data, function(a,b) 
		return a.id < b.id
	end)
	return data
end

--======= 徒弟当前活跃任务 ========
BoxCurActivityTaskItem = {}
function BoxCurActivityTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCurActivityData = nil
end
function BoxCurActivityTaskItem:_unInit()
	self.m_root = nil
	self.m_tCurActivityData = nil
end
--@brief	创建控件
function BoxCurActivityTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(408,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function BoxCurActivityTaskItem:setCurActivityData(data)
	self.m_tCurActivityData = data
end
--@brief 	开始加载
function BoxCurActivityTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CurTaskItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function BoxCurActivityTaskItem:setData()
	if not self.m_tCurActivityData then return end

	local data = self.m_tCurActivityData
	GetElement(self.m_root,"curNum",WZUILabelTTF):setText(data.demand)
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	for i = 1, #data.reward do
		local tabItem = GDatatab_item["id_"..data.reward[i][1]]
		if tabItem then
			local itemInfo = {lastTime=data.reward[i][2],lastNum=data.reward[i][2],basicInfo=CopyTable(tabItem)}
			local celElement,tLuaObj = CellGoodItem:createElement()
			goods_con:addChild(celElement)
			tLuaObj:setCellGoodItem(itemInfo, 17)
			celElement:setScale(0.8)
			tLuaObj:setItemClickFun(WndMasterCurBoxActivity,self.onItemClick)
			celElement:setUseAbsCoordinate(true)
			local _x = 260 - (i-1) * 70
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
		end
	end
end
function BoxCurActivityTaskItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndMasterCurBoxActivity.m_root,1,tData,false,nil,true)
end
--@return	新建的表实例对象
function BoxCurActivityTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
