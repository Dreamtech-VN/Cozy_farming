--WndNewYearActivityMainData.lua
--@brief	WndNewYearActivityMain的数据模块
--@date		2020/12/24
--@author	hyx
--@note		2021新年活动

WndNewYearActivityMain = {
	--请不要在这里定义变量
}

WndNewYearActivityMain.WndNewYearActivityPanel = {
	[1] = "CellNewYearChange", --新年充返
	[2] = "CellNewYearBless", --新年祈福
	[3] = "CellNewYearRedBag", --新年红包
	[4] = "CellNewYearShop", --新年商城
	[5] = "CellNewYearSign", --签到
}

function WndNewYearActivityMain:setNewYearActivityData(data)
	--WZLog("WndNewYearActivityMain:setNewYearActivityData", Serialize(data))
	if not self.m_tNewYearData then
		self.m_tNewYearData = {}
	end
	self.m_tNewYearData[data.typeId] = data
end
--typeId 活动的类型
function WndNewYearActivityMain:getNewYearActivityData(typeId)
	if typeId then
		return self.m_tNewYearData[typeId]
	else
		return self.m_tNewYearData
	end
end
--设置红点
function WndNewYearActivityMain:setRedPointStatus(id, status)
	if not self.m_tRedPointList then
		self.m_tRedPointList = {}
	end
	local tab = {}
	tab.id = id
	tab.status = status
	self.m_tRedPointList[id] = tab
	self:setHolidayTitleItemRedPoint(id, status)
end
function WndNewYearActivityMain:getRedPointStatus()
	local status = false
	if self.m_tRedPointList then
		for i,v in pairs(self.m_tRedPointList) do
			if v.status == true then
				status = true
				break
			end
		end
	end
	return status
end
function WndNewYearActivityMain:getHolidayIdRedPointStatus(id)
	if self.m_tRedPointList and self.m_tRedPointList[id] then
		return self.m_tRedPointList[id].status
	end
	return false
end
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewYearActivityMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTitleCellIten = {} --标题
	self.m_nCurIndex = nil
	self.m_sTouchTitleItem = nil
	self.m_tActivityPanel = {}
	self.m_sCurNewYearActivityPanel = nil
	self.m_nTurnActivityTypeID = nil
	self.m_tNewYearData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewYearActivityMain:_unInit()
	self.m_root = nil
	self.m_tTitleCellIten = {}
	self.m_nCurIndex = nil
	self.m_sTouchTitleItem = nil
	self.m_tActivityPanel = {}
	self.m_sCurNewYearActivityPanel = nil
	self.m_nTurnActivityTypeID = nil
	self.m_tNewYearData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewYearActivityMain:createElement(typeId)
	if WndNewYearActivityMain.m_root ~= nil then
		WindowManager:removeWindow(WndNewYearActivityMain.m_root, WndNewYearActivityMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewYearActivityMain")
	assert(element, "WndNewYearActivityMain create element failed!")
	self:_init()
	self.m_nTurnActivityTypeID = typeId
	return element
end


--************* 选择的标题 ****************
CellNewYearTitleItem = {}
function CellNewYearTitleItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTitleItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellNewYearTitleItem:createElement(title_index)
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(75,87))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nChooseTitleIndex = title_index
	return element,tNewObj
end
--data 目前直传标题名字
function CellNewYearTitleItem:setNewYearActivityMessage(data, activityId, activityType, visible)
	self.m_tNewYearData = data
	self.m_nActivityId = activityId
	self.m_nActivityType = activityType
	self.m_sRedPointVisible = visible
end
--@brief 	开始加载
function CellNewYearTitleItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("titleContainer")
	celElement:setVisible(true)
	element:addChild(celElement)

	AdaptLanguage(self)

	self:cellNewYearDateItem()
end

function CellNewYearTitleItem:cellNewYearDateItem()
	if not self.m_tNewYearData then return end
	self.m_sTitleName = GetElement(self.m_root,"title_name",WZUILabelTTF)
	self.m_sTitleName:setText(self.m_tNewYearData)
	self.m_sNormal = GetElement(self.m_root,"normal_img",WZUI9Image)
	self.m_sRedpoint_img = GetElement(self.m_root,"redpoint_img",WZUIImage)
	if self.m_nChooseTitleIndex == self.m_nActivityType then
		self:setItemSelect()
	else
		self:setItemNormal()
	end
	self.m_sRedpoint_img:setVisible(self.m_sRedPointVisible)
end
function CellNewYearTitleItem:setFuncTitleItem(func)
	self.m_sFuncTitle = func
end
function CellNewYearTitleItem:onClickTitleItem()
	if self.m_sFuncTitle then
		self.m_sFuncTitle(self.m_nActivityId, self.m_nActivityType)
	end
end

function CellNewYearTitleItem:setItemSelect()
	if self.m_sNormal and self.m_sTitleName then
		self.m_sNormal:setFile("ui/newActivity/common_btn_bcs_03.png")
		
		--self.m_sTitleName:setColor(GlobalMethod:ccc3(127,70,26))
		-- self.m_sTitleName:setColor(GlobalMethod:ccc3(255,236,193))
		-- self.m_sTitleName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
		-- self.m_sTitleName:setStrokeSize(4)
		-- self.m_sTitleName:setEnableStroke(true)
	end
end
function CellNewYearTitleItem:setItemNormal()
	if self.m_sNormal then
		self.m_sNormal:setFile("ui/newActivity/common_btn_bcs_04.png")
		--self.m_sTitleName:setColor(GlobalMethod:ccc3(255,236,193))
		-- self.m_sTitleName:setColor(GlobalMethod:ccc3(138,43,19))
		-- self.m_sTitleName:setEnableStroke(false)
	end
end
function CellNewYearTitleItem:setItemRedPoint(visible)
	if self.m_sRedpoint_img then
		self.m_sRedpoint_img:setVisible(visible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@return	新建的表实例对象
function CellNewYearTitleItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
