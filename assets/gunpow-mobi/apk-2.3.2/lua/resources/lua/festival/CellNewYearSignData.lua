--CellNewYearSignData.lua
--@brief	CellNewYearSign的数据模块
--@date		2021/04/29
--@author	hyx
--@note		周年签到

CellNewYearSign = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearSign:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSignData = {}
	self.m_tCellSignItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearSign:_unInit()
	self.m_root = nil
	self.m_tSignData = {}
	self.m_tCellSignItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearSign:createElement()
	if CellNewYearSign.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearSign.m_root, CellNewYearSign, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewYearSign")
	assert(element, "CellNewYearSign create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellNewYearSign:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

function CellNewYearSign:setSignData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts)
	local data = {}
	if rewardId and next(rewardId) then
		local index = 1
		for i=1,#rewardId do
			local tab = {}
			tab.day = rewardId[i]
			tab.status = status[i]
			local reward_id = {}
			local reward_num = {}
			for i=1,rewardCounts[i] do
				table.insert(reward_id,rewardItems[index])
				table.insert(reward_num,rewardItemsParamCount[index])
				index = index + 1
			end
			tab.reward_id = reward_id
			tab.reward_num = reward_num
			data[tab.day] = tab
		end
	end
	return data
end


function CellNewYearSign:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--=========== 签到子项 ===============
CellNewYearSignItem = {}
function CellNewYearSignItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearSignItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellNewYearSignItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(174,188))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellNewYearSignItem:setSignItemData(data, activity)
	self.m_sSignData = data
	self.m_nActivity = activity
end

--@brief 	开始加载
function CellNewYearSignItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("ItemSign")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end

function CellNewYearSignItem:setData()
	if not self.m_sSignData then return end

	local data = self.m_sSignData
	GetElement(self.m_root,"btnGetReward",WZUIButton):setVisible(data.status == 0)
	self:setSignStatus(data.status)
	GetElement(self.m_root,"txtDay",WZUILabelTTF):setText(string.format(LocalStrings.SingInDAYS, tonumber(data.day)))
	for i=1,#data.reward_id do
		if i > 2 then return end
		local goods_con = GetElement(self.m_root,"goods_con"..i,WZUIContainer)
		goods_con:setVisible(true)
		if #data.reward_id == 1 then
			goods_con:setRelativePosition(ccp(0.5,0.4))
		end
		local tabItem = GDatatab_item["id_"..data.reward_id[i]]
		if tabItem then
			local num = data.reward_num[i]
			local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item["id_"..data.reward_id[i]])}
			local celElement,tLuaObj = CellGoodItem:createElement()
			celElement:setScale(0.85)
			goods_con:addChild(celElement)
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(WndNewYearActivityMain,self.onItemClick)

			if data.status == 0 then
				local spine = WZUISpine:create()
			   	spine:setTouchEnable(false)
			   	spine:setFileJson("ui/ui_common_JJLQ.json")
			   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
			   	spine:setUseOriginSize(true)
			   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				spine:play("wait_1",true)
				spine:setScale(0.85)
			   	goods_con:addChild(spine,1, 10+i)
			end
		end
	end
end
--领取的
function CellNewYearSignItem:setSignStatus(status)
	if not self.m_root then return end
	
	local item_bg = GetElement(self.m_root,"item_bg",WZUIImage)
	if status == 0 then
		item_bg:setFile("ui/festival/common_znkh_di_02.png")
	else
		item_bg:setFile("ui/festival/common_znkh_di_01.png")
	end
	GetElement(self.m_root,"get_con",WZUIContainer):setVisible(status == 1)
	for i=1, 2 do
		local goods_con = GetElement(self.m_root,"goods_con"..i,WZUIContainer)
		if goods_con:getChildByTag(10+i) then
	        goods_con:removeChildByTag(10+i, true)
	    end
	end
end
function CellNewYearSignItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndNewYearActivityMain.m_root,1,tData,false,nil,true)
end
function CellNewYearSignItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nActivity and self.m_sSignData and self.m_sSignData.status == 0 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivity, self.m_sSignData.day)
	end
end
--@return	新建的表实例对象
function CellNewYearSignItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
