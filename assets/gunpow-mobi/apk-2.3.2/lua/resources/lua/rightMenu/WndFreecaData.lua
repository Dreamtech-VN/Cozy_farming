--WndFreecaData.lua
--@brief	WndFreeca的数据模块
--@date		2016/02/24
--@author	maopeiting
--@note		福利卡界面

WndFreeca = {
	--请不要在这里定义变量
	
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFreeca:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = {}  				--列表数据表
	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil   
    self.m_nSelectedActivityId = nil    
    self.m_nLoadingId = nil 

    if ProjConfig.CHANNEL_ID == 1016 or ProjConfig.CHANNEL_ID == 1009 or ProjConfig.CHANNEL_ID == 1038 or ProjConfig.CHANNEL_ID == 1046 or 
    	ProjConfig.CHANNEL_ID == 1063 then
    	self.m_localActivityItem = {
    		{title = LocalStrings.WEEK_CARD, activityId = 555555, types = g_tGameActivityTypes.ACTIVITY_WEEKCARD, button_id = 110, sort = 4},
			{title = LocalStrings.MONTH_CARDS, activityId = 0, types = g_tGameActivityTypes.ACTIVITY_MONTHCARD, button_id = 66, sort = 3},
    		{title = LocalStrings.FOREVER_WELFARE_CARD, activityId = 77777, types = g_tGameActivityTypes.ACTIVITY_FOREVERWELFARECARD, button_id = 75, sort = 2},
    		{title = LocalStrings.ENJOY_CARD, activityId = 666666, types = g_tGameActivityTypes.ACTIVITY_ENJOYCARD, button_id = 111, sort = 1},
		}
	else
		self.m_localActivityItem = {
    		{title = LocalStrings.ACTIVITY_TEXT_DESC_25, activityId = 888888, types = g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD, button_id = 174, sort = 3},
    		-- {title = LocalStrings.WEEK_CARD, activityId = 555555, types = g_tGameActivityTypes.ACTIVITY_WEEKCARD, button_id = 110, sort = 2},
			{title = LocalStrings.MONTH_CARDS, activityId = 0, types = g_tGameActivityTypes.ACTIVITY_MONTHCARD, button_id = 66, sort = 1},
    		--{title = LocalStrings.FOREVER_WELFARE_CARD, activityId = 77777, types = g_tGameActivityTypes.ACTIVITY_FOREVERWELFARECARD, button_id = 75},
    		--{title = LocalStrings.ENJOY_CARD, activityId = 666666, types = g_tGameActivityTypes.ACTIVITY_ENJOYCARD, button_id = 111},
		}
	end
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFreeca:_unInit()
	self.m_root = nil
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = nil  				--列表数据表
	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil 
    self.m_localActivityItem = nil 
    self.m_nSelectedActivityId = nil    
    self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFreeca:createElement(types)
	local element = WZUISystem:getInstance():createElement("WndFreeca")
	assert(element, "WndFreeca create element failed!")
	self:_init()
	return element
end

function WndFreeca:_initItem(  )
	for idx, value in pairs(self.m_localActivityItem) do
        if CheckButtonShow(value.button_id) then
        	if value.button_id == 174 then
        		if WndFreeca.g_bIsMondayPlanCard == true then
        			table.insert(self.m_tListItem, value)
        		end
	        else
	        	if ProjConfig.LANGUAGE == "cn" then 
		        	if WndWelfare.m_tFreeCardActivity and #WndWelfare.m_tFreeCardActivity > 0 then 
		        		for i = 1, #WndWelfare.m_tFreeCardActivity do
		        			if (WndWelfare.m_tFreeCardActivity[i].type == g_tGameActivityTypes.ACIVIITY_WEEKCARD_DISCOUNT and value.types == g_tGameActivityTypes.ACTIVITY_WEEKCARD) or (WndWelfare.m_tFreeCardActivity[i].type == g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT and value.types == g_tGameActivityTypes.ACTIVITY_MONTHCARD) then 
		        				value.sort = value.sort + 3
		        				break 
		        			end
		        		end
		        	end
	        	end
	            table.insert(self.m_tListItem, value)
	        end
        end
    end

    table.sort(self.m_tListItem, function (a,b)
    	-- body
    	return a.sort > b.sort
    end)
    WZLog("WndFreeca:_initItem", Serialize(self.m_tListItem))
end

--@brief	外部接口
function WndFreeca:showInterface(types)
	if self.m_root == nil then
		local wndFreeca = WndFreeca:createElement()
		WindowManager:addWindow(wndFreeca,WndFreeca,false)
	end
	self:updataParentByCellItem(types)
end

--@brief 	获得列表成功
function WndFreeca:GetCardActivityInfoOK(progress, num, endTime, rewardStatus, itemId, itemNum, activityId)
	--body
    if self.m_root == nil then return end
	self:_closeLoading()
    WndFreeca:_updateRightContent(progress, num, endTime, rewardStatus, itemId, itemNum, activityId)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
