--WndPvpRankUpgradeData.lua
--@brief	WndPvpRankUpgrade的数据模块
--@date		2015/11/16
--@author	zhangming
--@note		排位赛等级提升界面

WndPvpRankUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpRankUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_actionTag = nil 
	self.dtTime = nil
	self.b_isOver = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpRankUpgrade:_unInit()
	self.m_root = nil
	self.t_date = nil
	self.n_actionTag = nil 
	self.dtTime = nil
	self.b_isOver = nil
end

--@brief    打开竞技等级界面
--@param    data 相关数据
function WndPvpRankUpgrade:Show()
	WZLog("WndPvpRankUpgrade:Show:")
	if true then
		return
	end
	local lv = CacheCenter:getPlayerInfo().segmentLevel
    GlobalGame.g_tPlayerInfo.nPvpRankLevel =  GlobalGame.g_tPlayerInfo.nPvpRankLevel == 0 and 1 or GlobalGame.g_tPlayerInfo.nPvpRankLevel
	WZLog("--------LV--------------",lv,GlobalGame.g_tPlayerInfo.nPvpRankLevel)
	if tonumber(lv) <= GlobalGame.g_tPlayerInfo.nPvpRankLevel then
        WZLog("_checkHasUpdateAthLevel:",tonumber(lv), GlobalGame.g_tPlayerInfo.nPvpRankLevel)
		GlobalGame.g_tPlayerInfo.nPvpRankLevel = lv
		return 
	end
	local wndthUpgrade = WndPvpRankUpgrade:createElement()
    if wndthUpgrade ~= nil then
        WindowManager:addWindow(wndthUpgrade, WndPvpRankUpgrade, false, nil, nil, true)
    end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpRankUpgrade:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpRankUpgrade")
	assert(element, "WndPvpRankUpgrade create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
