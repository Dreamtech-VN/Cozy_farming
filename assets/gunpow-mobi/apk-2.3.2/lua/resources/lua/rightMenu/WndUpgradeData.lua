--WndUpgradeData.lua
--@brief	WndUpgrade的数据模块
--@date		2014/01/10
--@author	xiaoyu_wu
--@note		人物升级模块

WndUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tFriend = nil 				--好友列表
    self.m_fireworksAni = nil           --烟花动画的引用
	self.m_tPlayer = nil 
	self.m_tEquip = nil 
	self.m_tPro = nil 
	self.m_nIndex = nil
	self.n_actionTag = nil 
	self.dtTime = nil
	self.t_levelInfo = {}               --等级信息
	self.bShowInfo = 0					--0,升级界面，1显示功能，2调到主城
    self.m_bIsExit = nil
    self.m_bIsReplace = nil
    self.m_nButtonId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUpgrade:_unInit()
	self.m_root = nil
    self.m_fireworksAni = nil
	self.m_tFriend = nil
	self.m_tPlayer = nil 
	self.m_tEquip = nil 
	self.m_tPro = nil 
	self.m_nIndex = nil 
	self.n_actionTag = nil
	self.dtTime = nil
	self.t_levelInfo = nil
	self.bShowInfo = nil
    self.m_bIsExit = true
    self.m_bIsReplace = nil
    self.m_nButtonId = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUpgrade:createElement()
    WZLog("GlobalGame.g_bIfLevelUp == true 0")
	local element = WZUISystem:getInstance():createElement("WndUpgrade")
	assert(element, "WndUpgrade create element failed!")
	self:_init()
	return element
end

function WndUpgrade:_getProData(tProperty)
	local tData = {}
	tData.hp = 0
	tData.attack = 0
	tData.defend = 0
	for i,data in pairs(tProperty) do 
		local value = data
		local value2 = 0
		if type(data) == "table" then
			value = data[2]
			value2 = data[1]
		end
		if tonumber(value2) == tonumber(PRO_HP) then
			tData.hp = value
		elseif tonumber(value2) == tonumber(PRO_ATTACK) then
			tData.attack = value
		elseif tonumber(value2) == tonumber(PRO_DEFEND) then
			tData.defend = value
		end
	end	
	WZLog("rrrrrrr:",PRO_DEFEND, tData.defend)
	return tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
