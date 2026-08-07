--WndFootMarkUpgradeData.lua
--@brief	WndFootMarkUpgrade的数据模块
--@date		2017/11/21
--@author	Tianxiang_Xu
--@note		足迹系统-升级、精炼

WndFootMarkUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootMarkUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil                --当前坐骑
    self.maxUpLevel = 0                 -- 升级最大等级
    self.maxStarLevel = 0               -- 进阶最大等级
    self.flag = 1                       -- 进阶升级标志位
    self.loadingId = nil                -- loadingID
    self.isResult = nil                 -- 进阶升级的结果
    self.isClick = true                 -- 升级和进阶按键是否可点
    self.leftLv = 0                     -- 剩余升级等级
    self.logTime = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootMarkUpgrade:_unInit()
	self.m_root = nil
	self.m_tData = nil
    self.maxUpLevel = nil
    self.maxStarLevel = nil
    self.flag = nil
    self.loadingId = nil
    self.isResult = nil
    self.isClick = nil
    self.leftLv = 0                     -- 剩余升级等级
    self.logTime = 0
    self.starCost = nil
    self.upCost = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootMarkUpgrade:createElement()
	if WndFootMarkUpgrade.m_root ~= nil then
		WndFootMarkUpgrade.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndFootMarkUpgrade")
	assert(element, "WndFootMarkUpgrade create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	flag = 1 表示升级， 2表示进阶
function WndFootMarkUpgrade:showInterface(data, flag)
    local wnd = WndFootMarkUpgrade:createElement()
    self.m_tData =  data
    self.flag = flag
    WindowManager:addWindow(wnd, WndFootMarkUpgrade,true,nil,nil)
    self:initStarAndUpMaxLevel()
end

-- flag = 1 表示升级， 2表示进阶
function WndFootMarkUpgrade:showWndUIAddCon(data,flag,con)
    local wnd = WndFootMarkUpgrade:createElement()
    self.m_tData =  data
    self.flag = flag
    self:initStarAndUpMaxLevel()
    if con then
        con:addChild(wnd)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFootMarkUpgrade:initStarAndUpMaxLevel()
	self.maxUpLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)
    self.maxStarLevel = self:_getMaxStarLevel()
    -- local addLv = CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion
    -- if self.m_tData.basicInfo.quality == 4 then
    --     self.maxUpLevel = self.maxUpLevel + addLv
    -- end
    -- WZLog("----------self.maxUpLevel----------1",addLv)
    -- WZLog("----------self.maxUpLevel----------2",self.m_tData.basicInfo.quality)
    WZLog("----------self.maxUpLevel----------3",self.maxUpLevel)
    WZLog("----------self.maxUpLevel----------4",self.m_tData.basicInfo.id)
end

--@brief 	获取精炼的最大等级
function WndFootMarkUpgrade:_getMaxStarLevel()
	--body
	local nMaxLevel = 0

	for i, value in pairs(GDatatab_footmark_advanced) do
		if value.level > nMaxLevel then 
			nMaxLevel = value.level
		end
	end

	return nMaxLevel
end


-- 获得坐骑的属性
function WndFootMarkUpgrade:_getPropertyValue(tProperty)
    local tData = {hp = 0, attack = 0, defend = 0, crit = 0, reduceCrit = 0}
    local tATTR = {}
    for i,data in pairs(tProperty) do
        local value = data
        if type(data) == "table" then
            i = data[1]
            value = data[2]
        end
        if tonumber(i) == PRO_HP then
            tData.hp = value
            tATTR.hp = tonumber(i)
        elseif tonumber(i) == PRO_ATTACK then
            tData.attack = value
            tATTR.attack = tonumber(i)
        elseif tonumber(i) == PRO_DEFEND then
            tData.defend = value
            tATTR.defend = tonumber(i)
        elseif tonumber(i) == PRO_AGILITY then
            tData.crit = value
            tATTR.crit = tonumber(i)
        elseif tonumber(i) == PRO_LUCK then
            tData.reduceCrit = value
            tATTR.reduceCrit = tonumber(i)
        end
    end
    local sortData = {tData.hp,tData.attack,tData.defend,tData.crit,tData.reduceCrit}
    local tAttrData = {tATTR.hp,tATTR.attack,tATTR.defend,tATTR.crit,tATTR.reduceCrit}
    return tData, sortData, tAttrData
end

-- 获得坐骑的属性
function WndFootMarkUpgrade:_getPropertyRate(tProperty)
    local tData = {hp = 0, attack = 0, defend = 0, crit = 0, reduceCrit = 0}
    local tATTR = {}
    for i,data in pairs(tProperty) do
        local value = data
        if type(data) == "table" then
            i = data[1]
            value = data[2]
        end
        if tonumber(i) == PRO_HP then
            tData.hp = value
            tATTR.hp = tonumber(i)
        elseif tonumber(i) == PRO_ATTACK then
            tData.attack = value
            tATTR.attack = tonumber(i)
        elseif tonumber(i) == PRO_DEFEND then
            tData.defend = value
            tATTR.defend = tonumber(i)
        elseif tonumber(i) == PRO_AGILITY then
            tData.crit = value
            tATTR.crit = tonumber(i)
        elseif tonumber(i) == PRO_LUCK then
            tData.reduceCrit = value
            tATTR.reduceCrit = tonumber(i)
        elseif tonumber(i) == 1403 then --1403:足迹全属性(万分比)
            tData.hp = tData.hp + value
            tATTR.hp = PRO_HP
            tData.attack = tData.attack + value
            tATTR.attack = PRO_ATTACK
            tData.defend = tData.defend + value
            tATTR.defend = PRO_DEFEND
            tData.crit = tData.crit + value
            tATTR.crit = PRO_AGILITY
            tData.reduceCrit = tData.reduceCrit + value
            tATTR.reduceCrit = PRO_LUCK
        end
    end
    local sortData = {tData.hp,tData.attack,tData.defend,tData.crit,tData.reduceCrit}
    local tAttrData = {tATTR.hp,tATTR.attack,tATTR.defend,tATTR.crit,tATTR.reduceCrit}
    return tData, sortData, tAttrData
end

-- 获得足迹升级附加的足迹星辰升级成功率
function WndFootMarkUpgrade:_getAddUpdateRate(tProperty)
    local nRate = 0
    for i,data in pairs(tProperty) do
        if tonumber(i) == 1401 then --1401:足迹升级成功率(万分比)
            nRate = data
        end
    end
    return nRate
end

-- 获得足迹升星附加的足迹星辰升星成功率
function WndFootMarkUpgrade:_getAddStarRate(tProperty)
    local nRate = 0
    for i,data in pairs(tProperty) do
        if tonumber(i) == 1402 then --1402:足迹升星成功率(万分比)
            nRate = data
        end
    end
    return nRate
end


-------------------------------------私有方法模块End----------------------------------------
