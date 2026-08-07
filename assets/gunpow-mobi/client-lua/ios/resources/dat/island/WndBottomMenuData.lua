--WndBottomMenuData.lua
--@brief	WndBottomMenu的数据模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@note		底部菜单模块

WndBottomMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBottomMenu:_init()
    WZLog("WndBottomMenu:_init")
	self.m_root = nil	 	  			--场景根节点
    self.m_lpWndPlayerCloseCallback = nil --主角界面关闭按钮点击回调
    self.m_tBackSceneLuaObj = nil		--点击返回按钮返回的场景绑定的Lua表引用
	self.m_lpBackButtonCallback = nil 	--返回按钮点击回调（外部用）
	self.m_tCallBackLuaObjMap = {}			--回调方法所属表的映射表，key为回调方法，value为回调方法所属表
    self.m_tTaskDialogLuaObj = nil
    self.m_tBtnsInfo = nil              --按钮信息
    self.m_nMailCount = 0             --未读邮件数量
    self.m_nTaskCount = 0             --未领取任务数量

    --百度多酷SDK专用，用来屏蔽多次点击充值，多次弹出多酷SDK充值界面
    self.m_bCanRechargeDuoku = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBottomMenu:_unInit()
	self.m_root = nil
	self.m_tBackSceneLuaObj = nil
    self.m_lpWndPlayerCloseCallback = nil
	self.m_lpBackButtonCallback = nil
	self.m_tCallBackLuaObjMap = nil
    self.m_tBtnsInfo = nil          
	self.m_tTaskDialogLuaObj = nil
    --百度多酷SDK专用，用来屏蔽多次点击充值，多次弹出多酷SDK充值界面
    self.m_bCanRechargeDuoku = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBottomMenu:createElement()
	WZLog("WndBottomMenu:createElement")
	local element = WZUISystem:getInstance():createElement("WndBottomMenu")
	assert(element, "WndBottomMenu create element failed!")
	self:_init()
	return element
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function WndBottomMenu:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
	if tLuaObj then
		self:setBackButtonEnable(true)
	else
		self:setBackButtonEnable(false)
	end
end

--@brief	设置主角界面关闭按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于主场景主角信息更新
function WndBottomMenu:setWndPlayerCloseCallback(callback, tLuaObj)
    self.m_lpWndPlayerCloseCallback = callback
	self.m_tCallBackLuaObjMap[callback] = tLuaObj
end

--@brief	设置返回按钮点击回调(可置空)
--@param	callback:回调函数引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于退出场景时回调
function WndBottomMenu:setBackButtonCallback(callback, tLuaObj)
    self.m_lpBackButtonCallback = callback
	self.m_tCallBackLuaObjMap[callback] = tLuaObj
end

--@brief	设置底部菜单按钮信息
--@param	tBtnsInfo，按钮信息表
function WndBottomMenu:setBtnsInfo(tBtnsInfo)
    --self.m_tBtnsInfo = tBtnsInfo
	--self:_sortButton()
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置底部菜单按钮信息的默认值
function WndBottomMenu:_setDefaultBtnsInfo()
	WZLog("WndBottomMenu:_setDefaultBtnsInfo")
    self.m_tBtnsInfo = {}
    --local tBtnStatusLevel = {2,2,2,4,4,1,3}
    local tBtnStatusLevel = {1,1,1,1,1,1,1,1}
    for i=ISLAND_BOTTOM_SHOP,ISLAND_BOTTOM_BAG do
        local tBtnInfo = {}
        tBtnInfo.buttonId = i
        tBtnInfo.buttonType = ISLAND_BTNTYPE_BOTTOM
        tBtnInfo.buttonSort = 0
        tBtnInfo.IsHighlight = false
        tBtnInfo.buttonStatus1Level = tBtnStatusLevel[i-ISLAND_BOTTOM_SHOP+1]
        tBtnInfo.buttonStatus2Level = 0
        tBtnInfo.buttonStatus3Level = tBtnStatusLevel[i-ISLAND_BOTTOM_SHOP+1]
        table.insert(self.m_tBtnsInfo, tBtnInfo)
    end
end

--@brief	对按钮按照排序值排序
function WndBottomMenu:_sortButton()
    --if self.m_tBtnsInfo[1].buttonSort == nil then
		--WZLog("self.m_tBtnsInfo[1].buttonSort == nil")
        --return
   -- end
    local sortFunc = function(a, b)
		return a.buttonId > b.buttonId
    end
    table.sort(self.m_tBtnsInfo, sortFunc)
end

--[[@brief	英文包适配函数
function WndBottomMenu:_adaptLanguage_en()
	--商店
	local con2 = self.m_root:getChildElement("con2_WndBottomMenu")
	if con2 then
		con2 = WZUIContainer:luaTo(con2)
		con2:setRelativePosition(ccp(0.132,0.5))
	end
	local con7 = self.m_root:getChildElement("con7_WndBottomMenu")
	if con7 then
		con7 = WZUIContainer:luaTo(con7)
		con7:setRelativePosition(ccp(0.698,0.5))
	end
end]]

--@brief	英文包适配函数1
function WndBottomMenu:_adaptLanguageEn()
	if ProjConfig.LANGUAGE ~= "en" then
		return
	end
	for i=1,3 do
		--充值
		local sName = "imgPay%d_WndBottommenu"
		sName = string.format(sName,i)
		local imgPay = self.m_root:getChildElement(sName)
		if imgPay then
			imgPay = WZUI9Image:luaTo(imgPay)
			imgPay:setScaleX(1.03)
		end
		--[[设置
		sName = "btnSet%d_WndBottomMenu"
		sName = string.format(sName,i)
		local imgSet =  self.m_root:getChildElement(sName)
		if imgSet then
			imgSet = WZUI9Image:luaTo(imgSet)
			imgSet:setScaleX(1.12)
		end]]
		
	end
end

-------------------------------------私有方法模块End----------------------------------------
