--WndReturnActivityMainData.lua
--@brief	WndReturnActivityMain的数据模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动主界面

WndReturnActivityMain = {
	--请不要在这里定义变量
}
WndReturnActivityMain.Panel = {
	[7014] = "CellReturnActivity1", --累登
	[7015] = "CellReturnActivity2", --王者归来
	[7016] = "CellReturnActivity3", --6元特惠
	[7017] = "CellReturnActivity4", --分享好礼
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndReturnActivityMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_isOpenView = {}
	self.m_tReturnActivityData = {}
	self.m_tReturnTitleCellIten = {} --标题
	self.m_sTouchTitleItem = nil
	self.m_tReturnActivityPanel = {}
	self.m_sCurReturnActivityPanel = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndReturnActivityMain:_unInit()
	self.m_root = nil
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_isOpenView = {}
	self.m_tReturnActivityData = {}
	self.m_tReturnTitleCellIten = {}
	self.m_sTouchTitleItem = nil
	self.m_tReturnActivityPanel = {}
	self.m_sCurReturnActivityPanel = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndReturnActivityMain:createElement()
	if WndReturnActivityMain.m_root ~= nil then
		WindowManager:removeWindow(WndReturnActivityMain.m_root, WndReturnActivityMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndReturnActivityMain")
	assert(element, "WndReturnActivityMain create element failed!")
	self:_init()
	return element
end

function WndReturnActivityMain:setReturnActivityData(data)
	self.m_tReturnActivityData[data.typeId] = data
end
--typeId 活动的类型
function WndReturnActivityMain:getReturnActivityData(typeId)
	if typeId then
		return self.m_tReturnActivityData[typeId]
	else
		return self.m_tReturnActivityData
	end
end

--设置红点
function WndReturnActivityMain:setReturnRedPointStatus(id, status)
	if not self.m_tReturnRedPointList then
		self.m_tReturnRedPointList = {}
	end
	local tab = {}
	tab.id = id
	tab.status = status
	self.m_tReturnRedPointList[id] = tab
	self:setReturnHolidayTitleItemRedPoint(id, status)
end
function WndReturnActivityMain:getReturnRedPointStatus()
	local status = false
	if self.m_tReturnRedPointList then
		for i,v in pairs(self.m_tReturnRedPointList) do
			if v.status == true then
				status = true
				break
			end
		end
	end
	return status
end
function WndReturnActivityMain:getHolidayIdRedPointStatus(id)
	if self.m_tReturnRedPointList and self.m_tReturnRedPointList[id] then
		return self.m_tReturnRedPointList[id].status
	end
	return false
end

--************* 选择的标题 ****************
CellReturnActivityTitleItem = {}
function CellReturnActivityTitleItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellReturnActivityTitleItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellReturnActivityTitleItem:createElement(title_index)
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(184,70))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nChooseTitleIndex = title_index or 0
	return element,tNewObj
end
--
function CellReturnActivityTitleItem:setReturnActivityMessage(title_name, activityId, activityType, visible)
	local tabName = {
		[7014] = LocalStrings.ACTIVITY_TEXT26,
		[7015] = LocalStrings.ACTIVITY_TEXT27,
		[7016] = LocalStrings.ACTIVITY_TEXT28,
		[7017] = LocalStrings.ACTIVITY_TEXT29,
	}
	self.m_txtTitmeName = tabName[activityType]
	self.m_nActivityId = activityId
	self.m_nActivityType = activityType
	self.m_sRedPointVisible = visible or false
end
--@brief 	开始加载
function CellReturnActivityTitleItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("titleContainer")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()

	AdaptLanguage(self)
end

function CellReturnActivityTitleItem:setData()
	if not self.m_txtTitmeName then return end
	GetElement(self.m_root,"name",WZUILabelTTF):setText(self.m_txtTitmeName)
	self.m_sSelect = GetElement(self.m_root,"select",WZUIImage)
	self.m_sRedpoint_img = GetElement(self.m_root,"redpoint",WZUIImage)
	if self.m_nChooseTitleIndex == self.m_nActivityType then
		self:setItemSelect()
	else
		self:setItemNormal()
	end
	self.m_sRedpoint_img:setVisible(self.m_sRedPointVisible)
end
function CellReturnActivityTitleItem:setFuncTitleItem(func)
	self.m_sFuncTitle = func
end
function CellReturnActivityTitleItem:onClickTitleItem()
	if self.m_sFuncTitle then
		self.m_sFuncTitle(self.m_nActivityId, self.m_nActivityType)
	end
end

function CellReturnActivityTitleItem:setItemSelect()
	if self.m_sSelect then
		self.m_sSelect:setVisible(true)
	end
end
function CellReturnActivityTitleItem:setItemNormal()
	if self.m_sSelect then
		self.m_sSelect:setVisible(false)
	end
end
function CellReturnActivityTitleItem:setItemRedPoint(visible)
	if self.m_sRedpoint_img then
		self.m_sRedpoint_img:setVisible(visible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function CellReturnActivityTitleItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellReturnActivityTitleItem:_adaptLanguage_vn()
	GetElement(self.m_root,"name",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(170,0))
end
-------------------------------------语言适配模块end--------------------------------------
