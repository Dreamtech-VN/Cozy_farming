--WndHoraryLevRewardData.lua
--@brief	WndHoraryLevReward的数据模块
--@date		2021/07/19
--@author	hyx
--@note		占卜等级奖励

WndHoraryLevReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHoraryLevReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLevelRewardData = {}
	self.m_tCellLevelItem = {}
	self.m_nRewardType = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHoraryLevReward:_unInit()
	self.m_root = nil
	self.m_tLevelRewardData = {}
	self.m_tCellLevelItem = {}
	self.m_nRewardType = 0
end
function WndHoraryLevReward:setData(_type)
	self.m_nRewardType = _type
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHoraryLevReward:createElement()
	if WndHoraryLevReward.m_root ~= nil then
		WindowManager:removeWindow(WndHoraryLevReward.m_root, WndHoraryLevReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHoraryLevReward")
	assert(element, "WndHoraryLevReward create element failed!")
	self:_init()
	return element
end

function WndHoraryLevReward:setLevelRewardData(data)
	if not data then
		return {}
	end
	local temp_data = {}
	local index = 1
	for i=1,#data.levels do
		local tab = {}
		tab.id = data.rewardId[i]
		tab.lev = data.levels[i]
		tab.progress = data.progress[i]
		tab.exp = data.exps[i]
		tab.status = data.status[i]
		local reward_id = {}
		local reward_num = {}
		for m=1,data.itemCounts[i] do
			table.insert(reward_id, data.itemIds[index])
			table.insert(reward_num, data.itemNums[index])
			index = index + 1
		end
		tab.reward_id = reward_id
		tab.reward_num = reward_num
		temp_data[i] = tab	
	end
	return temp_data
end

--======= 等级奖励 ========
HoraryLevelRewardItem = {}
function HoraryLevelRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nLevelRewardId = nil
	self.m_nRewardLevelType = 0
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function HoraryLevelRewardItem:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = {}
	self.m_nLevelRewardId = nil
	self.m_nRewardLevelType = 0
end

--@brief	创建控件
function HoraryLevelRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(656,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function HoraryLevelRewardItem:setRewardData(index,data,_type)
	self.m_nIndex = index
	self.m_tRewardData = data
	self.m_nRewardLevelType = _type
end

--@brief 	开始加载
function HoraryLevelRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("HoraryLevItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	

	AdaptLanguage(self)
end
function HoraryLevelRewardItem:setData()
	if not self.m_tRewardData then return end

	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setLevelItemMessage(self.m_nIndex, self.m_tRewardData, self.m_nRewardLevelType)
end
function HoraryLevelRewardItem:setLevelItemMessage(index, data, _type)
	--领取状态-1不可领取 0可领取 1已领取
	local btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	btnGet:setVisible(false)
	local imgGet = GetElement(self.m_root,"imgGet",WZUIImage)
	imgGet:setVisible(false)

	if data.status == -1 then
		btnGet:setVisible(true)
		btnGet:setTouchEnable(false)
	elseif data.status == 0 then
		btnGet:setVisible(true)
		btnGet:setTouchEnable(true)
	elseif data.status == 1 then
		btnGet:setVisible(false)
		imgGet:setVisible(true)
	end
	local str_name = LocalStrings.ACTIVITY_TEXT81
	local str_number = LocalStrings.ACTIVITY_TEXT85
	local pos_x = 0.27
	if _type == 1 then
		str_name = LocalStrings.ACTIVITY_TEXT175
		str_number = LocalStrings.ACTIVITY_TEXT207
		pos_x = 0.31
	end
	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(str_name[data.lev+1])
	GetElement(self.m_root,"txtTitleNumber",WZUILabelTTF):setText(str_number)
	GetElement(self.m_root,"txtStarNum",WZUILabelTTF):setText(data.progress.."/"..data.exp)

	self.m_nLevelRewardId = data.id
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	goods_con:setRelativePosition(ccp(pos_x,0.014))
	self:setCommonRewardData(index, 5, data.reward_id, data.reward_num, goods_con, WndHoraryLevReward, self.m_tGoodItemCell)
end
--[[
index:顺序
max_num: 最大奖励个数
ids: 物品的id
nums:物品数量
goods_con: 物品显示的container
tObj:物品tips在哪一个图层
m_tGoodItem:奖励的物品
]]
function HoraryLevelRewardItem:setCommonRewardData(index, max_num, ids, nums, goods_con, tObj, m_tGoodItem)
	if not m_tGoodItem or not goods_con then return end
	tObj = tObj or self

	for i=1, max_num do
		if m_tGoodItem[index] and m_tGoodItem[index][i] and m_tGoodItem[index][i].celElement then
			m_tGoodItem[index][i].celElement:setVisible(false)
		end
	end
	local temp_index = 1
	for i=1, #ids do
		if GDatatab_item["id_"..ids[i]] then
			if m_tGoodItem[index][i] == nil then
				local celElement, tLuaObj = CellGoodItem:createElement()
				goods_con:addChild(celElement)
				celElement:setScale(0.85)
				celElement:setUseAbsCoordinate(true)
				local tab = {}
				tab.celElement = celElement
				tab.tLuaObj = tLuaObj
				m_tGoodItem[index][i] = tab
			end
			if m_tGoodItem[index][i] and m_tGoodItem[index][i].celElement and m_tGoodItem[index][i].tLuaObj then
				local itemInfo = {lastTime=nums[i],lastNum=nums[i],basicInfo=CopyTable(GDatatab_item["id_"..ids[i]])}
				local celElement = m_tGoodItem[index][i].celElement
				local tLuaObj = m_tGoodItem[index][i].tLuaObj
				tLuaObj:setCellGoodItem(itemInfo, 17)
				tLuaObj:setGoodItemCallFunc(function(tCell, tag, tData)
					if tData == nil then
						return
					end
					WndItemInfo:onCloseClick()
					WndItemInfo:showInfo(tCell.m_root,tObj.m_root,1,tData,false,nil,true)
				end)
				local _x = 35 + (temp_index-1) * 85
				celElement:setAbsPosition(GlobalMethod:ccp(_x, 40))
				celElement:setVisible(true)
				temp_index = temp_index + 1
			end
		end
	end
end

function HoraryLevelRewardItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nLevelRewardId then
		if self.m_nRewardLevelType == 1 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.activity7029, self.m_nLevelRewardId)
		else
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.activity7023, self.m_nLevelRewardId)
		end
	end
end
--@return	新建的表实例对象
function HoraryLevelRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function HoraryLevelRewardItem:_adaptLanguage_vn()
	GetElement(self.m_root,"txtName",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTitleNumber",WZUILabelTTF):setScale(0.7)
end

-------------------------------------语言适配End----------------------------------------