--WndRiseRewardData.lua
--@brief	WndRiseReward的数据模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路选择道具奖励

WndRiseReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRiseReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurItemIndex = nil
	self.m_tChooseItem = {}
	self.m_sTouchItemCell = nil
	self.m_tTouchChooseItem = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRiseReward:_unInit()
	self.m_root = nil
	self.m_nCurItemIndex = nil
	self.m_tChooseItem = {}
	self.m_sTouchItemCell = nil
	self.m_tTouchChooseItem = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRiseReward:createElement()
	if WndRiseReward.m_root ~= nil then
		WindowManager:removeWindow(WndRiseReward.m_root, WndRiseReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRiseReward")
	assert(element, "WndRiseReward create element failed!")
	self:_init()
	return element
end

--=======================================
RiseRewardItem = {}
function RiseRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function RiseRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function RiseRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(85,120))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function RiseRewardItem:setRewardRemainData(index, id, num, count)
	self.m_nCurIndex = index
	self.m_tRemainId = id
	self.m_tRemainNum = num
	self.m_tRemainCount = count
end
--@brief 	开始加载
function RiseRewardItem:onLoadData(element)
	local celElement,tLuaObj = CellGoodItem:createElement()
	celElement:setScale(0.95)
	celElement:setTag(self.m_nCurIndex)
	self.m_root:addChild(celElement)
	celElement:setRelativePosition(ccp(0.5, 0.62))
	local itemInfo = {lastTime=self.m_tRemainNum,lastNum=self.m_tRemainNum,basicInfo=CopyTable(GDatatab_item["id_"..self.m_tRemainId])}
	tLuaObj:setCellGoodItem(itemInfo, 17)
	tLuaObj:setGoodItemCallFunc(function(tCell, tag, itenData)
		if self.m_sTouchItemFunc then
			self.m_sTouchItemFunc(tCell,tag,itenData, self.m_tRemainCount)
		end
	end)
	if self.m_tRemainCount == -1 then
	else
		if self.m_tRemainCount <= 0 then
			tLuaObj:setGrayRender(true)
		else
			tLuaObj:setGrayRender(false)
			tLuaObj:showGoodsRemainNum(LocalStrings.ACTIVITY_TEXT59..self.m_tRemainCount)
		end
	end
end
function RiseRewardItem:setFunc(func)
	self.m_sTouchItemFunc = func
end
--@return	新建的表实例对象
function RiseRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
