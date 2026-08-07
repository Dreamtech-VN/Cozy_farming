--WndDoubleSevenTaskData.lua
--@brief	WndDoubleSevenTask的数据模块
--@date		2020/08/03
--@author	hyx
--@note		告白任务

WndDoubleSevenTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleSevenTask:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleSevenTask:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleSevenTask:createElement()
	if WndDoubleSevenTask.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleSevenTask.m_root, WndDoubleSevenTask, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleSevenTask")
	assert(element, "WndDoubleSevenTask create element failed!")
	self:_init()
	return element
end

--************** 子项 ******************
CellDoubleSevenTaskItem = {}
function CellDoubleSevenTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = nil
	self.m_tGoodItemCell = {}
	self.m_nLevelRewardId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDoubleSevenTaskItem:_unInit()
	self.m_root = nil
	self.m_nIndex = nil
	self.m_tGoodItemCell = {}
	self.m_nLevelRewardId = nil
end

--@brief	创建控件
function CellDoubleSevenTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,132))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellDoubleSevenTaskItem:setTaskMessageInit(index,tDate)
	self.m_nIndex = index
	self.m_sDate = tDate
end
--@brief 	开始加载
function CellDoubleSevenTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("taskItemContainer")
	celElement:setVisible(true)
	element:addChild(celElement)

	self.m_tGoodItemCell[self.m_nIndex] = {}
	self:upTaskDateItem(self.m_nIndex, self.m_sDate)
end

function CellDoubleSevenTaskItem:upTaskDateItem(index, data)
	if not data then return end

	local desc = GetElement(self.m_root, "desc", WZUIFreeTextBox)
	local str_desc = string.format(data.desc, data.progress, data.target)
	desc:setShowText(str_desc)

	local get_img = GetElement(self.m_root,"get_img",WZUIImage)
	self.m_btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	local getLabel = GetElement(self.m_btnGet,"getLabel",WZUILabelTTF)
	getLabel:setText(LocalStrings.ACTIVE_BTN_GET)

	self.m_btnGet:setVisible(data.status == 0 or data.status == 1)
	get_img:setVisible(data.status == 2)
	if data.status == 0 then
		self.m_btnGet:setTouchEnable(false)
		getLabel:setColor(GlobalMethod:ccc3(255,255,255))
		getLabel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	elseif data.status == 1 then
		self.m_btnGet:setTouchEnable(true)
		getLabel:setColor(GlobalMethod:ccc3(255,250,236))
		getLabel:setStrokeColor(GlobalMethod:ccc3(0,108,3))
	end
	
	self.m_nLevelRewardId = data.taskId
	local goodCon = GetElement(self.m_root,"goodCon",WZUIContainer)
	HoraryLevelRewardItem:setCommonRewardData(index, 7, data.item_ids, data.item_nums, goodCon, WndDoubleSevenTask, self.m_tGoodItemCell)
end
function CellDoubleSevenTaskItem:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(tCell.m_root,WndDoubleSevenTask.m_root,1,tData,false)	
end

function CellDoubleSevenTaskItem:setFunCallTaskItem(funcall)
	self.m_sFuncall = funcall
end

function CellDoubleSevenTaskItem:onClickGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nLevelRewardId then
		if self.m_sFuncall then
			self.m_sFuncall(self.m_nLevelRewardId)
		end
	end
end
--@return	新建的表实例对象
function CellDoubleSevenTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
