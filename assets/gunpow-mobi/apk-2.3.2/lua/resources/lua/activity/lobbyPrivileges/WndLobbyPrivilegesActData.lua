--WndLobbyPrivilegesActData.lua
--@brief	WndLobbyPrivilegesAct的数据模块
--@date		2022/03/21
--@author	yrd
--@note		大厅特权活动

WndLobbyPrivilegesAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLobbyPrivilegesAct:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTitleListData = {} 				--活动标题数据
	self.m_tTitleListObj = {} 				--活动标题对象
	self.m_nCurActivityType = nil 			--当前界面显示的活动类型
	self.m_nLoadingId = nil 				--协议等待时用到
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLobbyPrivilegesAct:_unInit()
	self.m_root = nil
	self.m_tTitleListData = nil
	self.m_tTitleListObj = nil
	self.m_nCurActivityType = nil
	self.m_nLoadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLobbyPrivilegesAct:createElement()
	if WndLobbyPrivilegesAct.m_root ~= nil then
		WindowManager:removeWindow(WndLobbyPrivilegesAct.m_root, WndLobbyPrivilegesAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndLobbyPrivilegesAct")
	assert(element, "WndLobbyPrivilegesAct create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndLobbyPrivilegesAct:showInterface()
    local wndReturneeActivity = WndLobbyPrivilegesAct:createElement()
    WindowManager:addWindow(wndReturneeActivity,WndLobbyPrivilegesAct)
end

--@brief 	获得活动列表成功
function WndLobbyPrivilegesAct:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("WndLobbyPrivilegesAct:GetActivityListInfoOK")
	self:_closeLoading()
    if self.m_root == nil then return end
    self.m_tTitleListData = {}
    local index = 1 
	for i=1,#activityId do
        WZLog("--*****WndLobbyPrivilegesAct****--111", activityId[i], title[i],type2[i],types[i])
		if type2[i] == 22 then    --等于22的才是大厅特权活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then
    				self.m_tTitleListData[index] = {}
    				self.m_tTitleListData[index].activityId = activityId[i]
    				self.m_tTitleListData[index].title = g_tGameActivityTitle[types[i]]
    				self.m_tTitleListData[index].startTime = startTime[i]
    				self.m_tTitleListData[index].endTime = endTime[i]
    				self.m_tTitleListData[index].types = types[i]
    				index = index + 1
    			end 
    		end 
        end
	end

	--默认显示第一个活动
	if self.m_nCurActivityType == nil and self.m_tTitleListData[1] then
		self.m_nCurActivityType = self.m_tTitleListData[1].types
	end

	self:updateUI()
end

--@brief 	获取活动详细内容成功
function WndLobbyPrivilegesAct:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,finishCondition)
	self:_closeLoading()
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,finishCondition)
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------活动标题Begin----------------------------------------
--@brief	CellLobbyPrivilegesActTitle的数据模块
CellLobbyPrivilegesActTitle = {}
function CellLobbyPrivilegesActTitle:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tItemData = nil 				--数据
	self.m_tClickBackFun = nil 			--回调函数
	self.m_tClickBackLua = nil 			--回调对象
	self.m_bIsLoaded = nil 				--是否加载完成
	self.m_bSelectedStates = false 		--按钮选中状态
	self.m_bIsNeedAddRedDot = false 	--红点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLobbyPrivilegesActTitle:_unInit()
	self.m_root = nil
	self.m_tItemData = nil
	self.m_tClickBackFun = nil
	self.m_tClickBackLua = nil
	self.m_bIsLoaded = nil
	self.m_bSelectedStates = nil
	self.m_bIsNeedAddRedDot = nil 	--红点
end

--@return	新建的表实例对象
function CellLobbyPrivilegesActTitle:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	创建控件
function CellLobbyPrivilegesActTitle:createElement(title_index)
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(174,60))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nChooseTitleIndex = title_index
	return element,tNewObj
end

--@brief 	设置数据
function CellLobbyPrivilegesActTitle:setData(tData)
	self.m_tItemData = tData
	if self.m_bIsLoaded then
		self:updateUI()
	end
end

--@brief 	获取数据
function CellLobbyPrivilegesActTitle:getData()
	return self.m_tItemData
end

--@brief 	开始加载
function CellLobbyPrivilegesActTitle:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellLobbyPrivilegesActTitle")
	celElement:setVisible(true)
	element:addChild(celElement)

	self.m_bIsLoaded = true
	self:updateUI()
end


function CellLobbyPrivilegesActTitle:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	local txtTitleNameNor = GetElement(self.m_root,"txtTitleNameNor",WZUILabelTTF)
	local txtTitleNameSel = GetElement(self.m_root,"txtTitleNameSel",WZUILabelTTF)
	txtTitleNameNor:setText(self.m_tItemData.title)
	txtTitleNameSel:setText(self.m_tItemData.title)

	GetElement(self.m_root,"conTitleNameSel",WZUIContainer):setVisible(self.m_bSelectedStates)
end

--@brief 	设置回调方法
function CellLobbyPrivilegesActTitle:setClickCallBack(callbackFun,callbackLua)
	self.m_tClickBackFun = callbackFun
	self.m_tClickBackLua = callbackLua
end

--@brief	点击标题按钮
function CellLobbyPrivilegesActTitle:onClickTitle(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_tClickBackFun(self.m_tClickBackLua,self)
end

--@brief	设置标题按钮选状态
function CellLobbyPrivilegesActTitle:setSelectedStates(bSelected)
	self.m_bSelectedStates = bSelected
	if self.m_bIsLoaded then
		GetElement(self.m_root,"conTitleNameSel",WZUIContainer):setVisible(self.m_bSelectedStates)
	end
end

--@breif 添加红点
function CellLobbyPrivilegesActTitle:AddRedDot(bRedDot)
    WZLog("CellLobbyPrivilegesActTitle:AddRedDot=====添加小红点=====")
    self.m_bIsNeedAddRedDot = bRedDot
    if self.m_bIsLoad == false then return end 

    if self.m_bIsNeedAddRedDot == true then 
        if not  self.m_root:getChildByTag(99) then 
            local spr_redPoint =  CCSprite:create("ui/common/common_icon_xiaodianzhui.png")
            spr_redPoint:setAnchorPoint(GlobalMethod:ccp(1,1))
            spr_redPoint:setPosition(166, 60)
            spr_redPoint:setScale(0.8)
            self.m_root:addChild(spr_redPoint,5,99)
        end 
    end
end

--@brief 移除红点
function CellLobbyPrivilegesActTitle:removeRedDot()
    if self.m_root == nil then 
        return
    end
    if self.m_root:getChildByTag(99) then 
        self.m_root:removeChildByTag(99, true)
        self.m_bIsNeedAddRedDot = false
    end 
end


-- --data 目前直传标题名字
-- function CellLobbyPrivilegesActTitle:setNewYearActivityMessage(data, activityId, activityType, visible)
-- 	self.m_tNewYearData = data
-- 	self.m_nActivityId = activityId
-- 	self.m_nActivityType = activityType
-- 	self.m_sRedPointVisible = visible
-- end

-- function CellLobbyPrivilegesActTitle:cellNewYearDateItem()
-- 	if not self.m_tNewYearData then return end
-- 	self.m_sTitleName = GetElement(self.m_root,"title_name",WZUILabelTTF)
-- 	self.m_sTitleName:setText(self.m_tNewYearData)
-- 	self.m_sNormal = GetElement(self.m_root,"normal_img",WZUI9Image)
-- 	self.m_sRedpoint_img = GetElement(self.m_root,"redpoint_img",WZUIImage)
-- 	if self.m_nChooseTitleIndex == self.m_nActivityType then
-- 		self:setItemSelect()
-- 	else
-- 		self:setItemNormal()
-- 	end
-- 	self.m_sRedpoint_img:setVisible(self.m_sRedPointVisible)
-- end
-- function CellLobbyPrivilegesActTitle:setFuncTitleItem(func)
-- 	self.m_sFuncTitle = func
-- end
-- function CellLobbyPrivilegesActTitle:onClickTitleItem()
-- 	if self.m_sFuncTitle then
-- 		self.m_sFuncTitle(self.m_nActivityId, self.m_nActivityType)
-- 	end
-- end

-- function CellLobbyPrivilegesActTitle:setItemSelect()
-- 	if self.m_sNormal and self.m_sTitleName then
-- 		self.m_sNormal:setVisible(true)
		
-- 		self.m_sTitleName:setColor(GlobalMethod:ccc3(127,70,26))
-- 	end
-- end
-- function CellLobbyPrivilegesActTitle:setItemNormal()
-- 	if self.m_sNormal then
-- 		self.m_sNormal:setVisible(false)
-- 		self.m_sTitleName:setColor(GlobalMethod:ccc3(255,236,193))
-- 	end
-- end
-- function CellLobbyPrivilegesActTitle:setItemRedPoint(visible)
-- 	if self.m_sRedpoint_img then
-- 		self.m_sRedpoint_img:setVisible(visible)
-- 	end
-- end

-------------------------------------活动标题End--------------------------------------