--WndFightTask2Data.lua
--@brief	WndFightTask2的数据模块
--@date		2021/06/21
--@author	hyx
--@note		战力任务

WndFightTask2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFightTask2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil
	self.m_tTaskTitle = {}
	self.m_tTaskTypeView = {}
	self.m_tTaskTypeData = {}
	self.m_tCellFightTaskItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFightTask2:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tTaskTitle = {}
	self.m_tTaskTypeView = {}
	self.m_tTaskTypeData = {}
	self.m_tCellFightTaskItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFightTask2:createElement()
	if WndFightTask2.m_root ~= nil then
		WindowManager:removeWindow(WndFightTask2.m_root, WndFightTask2, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFightTask2")
	assert(element, "WndFightTask2 create element failed!")
	self:_init()
	return element
end


--=========== 战力飞升榜任务子项 ===============
CellFightTaskItem2 = {}
function CellFightTaskItem2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFightTaskItem2:_unInit()
	self.m_root = nil
	self.m_tGoodItemCell = {}
	self.m_nTaskRewardId = nil
end

--@brief	创建控件
function CellFightTaskItem2:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,122))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
function CellFightTaskItem2:setFightTaskData(index, data)
	self.m_nIndex = index
	self.m_tFightTaskData = data
end
--@brief 	开始加载
function CellFightTaskItem2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("fightTaskItemCon")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()

	AdaptLanguage(self)
end

function CellFightTaskItem2:setData()
	if not self.m_tFightTaskData then return end

	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:setFightTaskItemData(self.m_nIndex, self.m_tFightTaskData)

end
function CellFightTaskItem2:setFightTaskItemData(index, data)
	local btnGoto = GetElement(self.m_root,"btnGoto",WZUIButton)
	btnGoto:setVisible(data.status == -1)
	btnGoto:setTouchEnable(false)
	GetElement(self.m_root,"btnGet",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"imgGet",WZUIImage):setVisible(data.status == 1)
	local txtTitleDesc = GetElement(self.m_root,"txtDesc",WZUIFreeTextBox)
	local txt = data.progress.."/"..data.target
	if data.desc ~= "" then
		txtTitleDesc:setShowText(string.format(data.desc,txt))
	end
	for i=1, 8 do --最大8个奖励
		if self.m_tGoodItemCell[index] and self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement then
			self.m_tGoodItemCell[index][i].celElement:setVisible(false)
		end
	end

	self.m_nTaskRewardId = data.id
	for i=1, #data.reward do
		local id = data.reward[i][1]
		local num = data.reward[i][2]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item["id_"..id])}
		if self.m_tGoodItemCell[index][i] == nil then
			local celElement, tLuaObj = CellGoodItem:createElement()
			self.m_root:addChild(celElement)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[index][i] = tab
		end
		if self.m_tGoodItemCell[index][i] and self.m_tGoodItemCell[index][i].celElement and self.m_tGoodItemCell[index][i].tLuaObj then
			local celElement = self.m_tGoodItemCell[index][i].celElement
			local tLuaObj = self.m_tGoodItemCell[index][i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(WndFightTask2,self.onItemClick)
			local _x = 45 + (i-1) * 85
			celElement:setAbsPosition(GlobalMethod:ccp(_x, 45))
			celElement:setVisible(true)
		end
	end
end

function CellFightTaskItem2:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFightTask2.m_root,1,tData,false,nil,true)
end
function CellFightTaskItem2:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nTaskRewardId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(tonumber(g_cityExtenInfo.activity7201), self.m_nTaskRewardId)
	end
end
--@return	新建的表实例对象
function CellFightTaskItem2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellFightTaskItem2:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUIFreeTextBox)
	txtDesc:setMaxWidth(800)
end
-------------------------------------语言适配end----------------------------------------
