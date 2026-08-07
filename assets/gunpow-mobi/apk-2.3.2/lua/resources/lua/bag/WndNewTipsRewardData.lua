--WndNewTipsRewardData.lua
--@brief	WndNewTipsReward的数据模块
--@date		2021/01/08
--@author	hyx
--@note		tips奖励物品

WndNewTipsReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewTipsReward:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewTipsReward:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewTipsReward:createElement()
	if WndNewTipsReward.m_root ~= nil then
		WindowManager:removeWindow(WndNewTipsReward.m_root, WndNewTipsReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewTipsReward")
	assert(element, "WndNewTipsReward create element failed!")
	self:_init()
	return element
end



CellTipsRewardItem = {}
function CellTipsRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTipsRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellTipsRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(100,30))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellTipsRewardItem:setRewardMessage(id, num)
	self.m_sRewardId = id
	self.m_sRewardNum = num
end

--@brief 	开始加载
function CellTipsRewardItem:onLoadData(element)
	self:setRewardDataItem()
end

function CellTipsRewardItem:setRewardDataItem()
	local key = "id_".. self.m_sRewardId
	local tabItem = GDatatab_item[key]
	local nTempNum = self.m_sRewardNum
	if tabItem then
		local icon = WZUIImage:create()
		icon:setFile(tabItem.icon)
		icon:setUseOriginSize(true)
		icon:setScale(0.5)
		if tabItem.main_type == 38 then 
			icon:setScale(0.3)
		end
		icon:setRelativePosition(GlobalMethod:ccp(0.2, 0.5))
		self.m_root:addChild(icon)

		if tabItem.main_type == 5 or tabItem.main_type == 31 then 
			if nTempNum == -1 then 
				nTempNum = LocalStrings.YJ
			elseif nTempNum > 0 then 
				nTempNum = nTempNum .. LocalStrings.DAY
			end
		end
	end
	local txtTitle = WZUILabelTTF:create()
	txtTitle:setText(nTempNum)
	txtTitle:setColor(GlobalMethod:ccc3(229,105,22))
	txtTitle:setFontSize(20)
	txtTitle:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.4, 0.5))
	self.m_root:addChild(txtTitle)

	local btnItem = WZUIButton:create()
	btnItem:setLuaDoneFunctionName("onItemClick")
	self.m_root:addChild(btnItem)
end

--@return	点击物品回调
function CellTipsRewardItem:onItemClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tabItem = GDatatab_item["id_".. self.m_sRewardId]
	local itemInfo = {basicInfo=CopyTable(tabItem)}
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(self.m_root,WndNewTipsReward.m_root,1,itemInfo,false,nil,true)
end

--@return	新建的表实例对象
function CellTipsRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
