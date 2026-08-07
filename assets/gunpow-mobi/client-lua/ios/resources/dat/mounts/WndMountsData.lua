--WndMountsData.lua
--@brief	WndMounts的数据模块
--@date		2015-8-12
--@author	binshao
--@note		坐骑模块

WndMounts = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMounts:_init()
	WZLog("WndMounts:_init")
	self.m_root = nil	 	  			--场景根节点
	self.m_tHorses = {}                 --所拥有的坐骑
	self.m_MountsList = {}              --战马的列表
    self.curSelIndex = 1
    self.m_curSelMountId = nil
    self.createIndex = 1
    self.mountAni = nil
	self.walking = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMounts:_unInit()
	WZLog("WndMounts:_unInit")
	self.m_root = nil
	self.m_tHorses = nil
	self.m_MountsList = nil
    self.curSelIndex = nil
    self.createIndex = nil
    self.m_curSelMountId = nil
    self.mountAni = nil
	self.walking = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMounts:createElement()
	WZLog("WndMounts:createElement")
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndMounts")
	assert(element, "WndMounts create element failed!")
	self:_init()
	return element
end

-- 坐骑获取方式
function WndMounts:_getMountWay(mount)
    local tData = mount.tItem.way
    local tItem = {s = 0,t = 0,v = 0}
    local count = #tData
    local type = count
    if count == 1 then
        tItem.s = tData[1][2]      -- 赠送
    elseif count == 2 then
        tItem.s = tData[1][2]      -- 等级(1 玩家等级 5竞技等级 6 恩爱等级 7 公会等级 8排位等级)
        tItem.v = tData[2][2]
    else
        tItem.s = tData[1][2]       -- 购买方式
        tItem.t = tData[2][2]       -- 货币ID
        tItem.v = tData[3][2]       -- 货币的数量
    end
    return tItem,count
end

-- 排序优先级 激活 > 拥有（出站>品质）>未获得（品质）
function WndMounts:_getMountsPriority(mounts)
    local priority = 0
    if mounts.isHave then --已拥有
        priority = 2 
    end
    if mounts.isPlay then --已乘骑
        priority = 9 
    end
    if priority == 0 then --未拥有
        local bGet = WndMounts:_judgeLockState(mounts)
        if bGet then
            if mounts.basicInfo.id == 10000 then
                priority = 11
            else
                priority = 10
            end
        else
            priority = 1
        end
    end
    return priority
end

-- 判断解锁状态
-- self.tData.state = nil 表示没有该坐骑， false表示有该坐骑，但是没有领取， true表示有该坐骑并且领取了
function WndMounts:_judgeLockState(mounts)
    local tItem,count = WndMounts:_getMountWay(mounts) -- count = 1 表示赠送， 2表示等级领取，3 表示购买
    if count == 1 then
        -- 符合赠送条件，可以解锁
        if mounts.state == false then return true end
    elseif count == 2 then
        local data = WndMounts:_judgeLvGet(tItem,count,mounts)
        return data.isUnlock
    elseif count == 3 then
        -- 物品够，提示红点，钻石除外
        local costId,costCnt = tItem.t,tItem.v
        local curCnt = CacheCenter:getPlayerItemCountById(costId)
        if costId == 1 then
            return false
        else
            if curCnt >= costCnt then return true end
            return false
        end
    end
    return false
end

function WndMounts:_judgeLvGet(tItem,count,mount)
    local playerInfo = CacheCenter:getPlayerInfo()
    local lv1 = playerInfo.level
    local lv5 = playerInfo.tournamentLevel
    local lv6 = playerInfo.loveLevel
    local lv7 = playerInfo.guildLevel
    local lv8 = playerInfo.segmentLevel
    local data = {}
    local lvType = tItem.s
    local needLv = tItem.v
    local playerLv = {lv1,nil,nil,nil,lv5,lv6,lv7,lv8 }
    local desc = {LocalStrings.MOUNTS_LEVEL_GET,nil,nil,nil,LocalStrings.MOUNTS_LEVEL_GET5,LocalStrings.MOUNTS_LEVEL_GET6,LocalStrings.MOUNTS_LEVEL_GET7,LocalStrings.MOUNTS_LEVEL_GET8}
    if playerLv[lvType] >= needLv and mount.state == nil then
        data = {type = count,isUnlock = true }
    else
        -- 竞技场等级提示额外处理
        if lvType == 5 then needLv = GDatatab_integral["id_"..needLv].dan end
        data = {type = count,isUnlock = false, str = string.format(desc[lvType],needLv)}
    end
    return data
end
--@brief	获取所有战马数据列表
function WndMounts:initAllMountsData()
    WZLog("--------------get cacheCenter data--------------------")
    -- 坐骑排序方式
    local function sortMounts(a,b)
        local ap = self:_getMountsPriority(a)
        local bp = self:_getMountsPriority(b)
        if ap == bp then
            if a.basicInfo.quality > b.basicInfo.quality then  return true end
            if a.basicInfo.quality == b.basicInfo.quality then
                return  a.basicInfo.id > b.basicInfo.id
            end
        else
            return ap > bp
        end
        return false
    end

    -- 获取坐骑信息
	self.m_tHorses = CacheCenter:getMountInfo()
    if self.m_tHorses == false then  return end
	table.sort(self.m_tHorses , sortMounts)
	self:_update()
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 获得坐骑的属性
function WndMounts:_getProperty(tProperty)
	local tData = {hp = 0, attack = 0, defend = 0, crit = 0, reduceCrit = 0}
	for i,data in pairs(tProperty) do
		local value = data
		if type(data) == "table" then
            i = data[1]
            value = data[2]
        end
		if tonumber(i) == PRO_HP then
			tData.hp = value
		elseif tonumber(i) == PRO_ATTACK then
			tData.attack = value
		elseif tonumber(i) == PRO_DEFEND then
			tData.defend = value
		elseif tonumber(i) == PRO_AGILITY then
			tData.crit = value
		elseif tonumber(i) == PRO_LUCK then
			tData.reduceCrit = value
        end
    end
    local sortData = {tData.hp,tData.attack,tData.defend,tData.crit,tData.reduceCrit}
	return tData,sortData
end

-- 设置当前cell的相关信息
function WndMounts:setCellData(tag,cell,tcell)
    if not self.m_MountsList[tag] then  self.m_MountsList[tag] = {} end
    self.m_MountsList[tag].cell = cell
    self.m_MountsList[tag].tcell = tcell
end

-- 根据id获取到本地的数据的下标
function WndMounts:getIndexById(id)
    for i = 1, #self.m_tHorses do
        if self.m_tHorses[i].id == id then
            return i,self.m_tHorses[i]
        end
    end
    return 1
end

-- 根据ID获取到缓存中心数据，更新本地数据
function WndMounts:updateByCacheCenterById(id)
    local data = CacheCenter:getMountInfo()
    local newData
    for k,v in pairs(data) do
        if v.id == id then  newData = v  end
    end

    for i = 1, #self.m_tHorses do
        if self.m_tHorses[i].id == id then
            self.m_tHorses[i] = newData
            if self.m_tHorses[i].isHave then
                local t = self:_getProperty(self.m_tHorses[i].property)
                self.m_tHorses[i].descProperty = t
            end
            break
        end
    end
end

-- 计算坐骑战斗力
function WndMounts:getFight(data)
    --新战斗力=(10*敏捷+10*幸运+9.6*(力量+护甲+体质)+1*(生命+4.8*攻击+6*防御+8*暴击+8*免爆+12*破防+12*免伤）)*0.75
    --        PRO_HP = 1--生命
    --        PRO_MAXHP = 2 --当前等级最大生命
    --        PRO_ATTACK = 3--攻击
    --        PRO_DEFEND = 4--防御
    --        PRO_CRIT = 5--暴击
    --        PRO_CRITRATE = 6--暴击率
    --        PRO_REDUCECRIT = 7--免爆
    --        PRO_REDUCECRITRATE = 8--免爆率
    --        PRO_PHYSIQUE = 9--体质
    --        PRO_FORCE = 10--力量
    --        PRO_ARMOR = 11--护甲
    --        PRO_AGILITY = 12--敏捷
    --        PRO_LUCK = 13--幸运
    --        PRO_PHYSICAL = 14--体力
    --        PRO_MAXPHYSICAL = 15--体力上限
    --        PRO_ANGER = 16--怒气
    --        PRO_MAXANGER = 17--怒气上限
    --        PRO_RANGE = 18 -- 范围
    --        PRO_WRECKDEFENSE = 19 --破防
    --        PRO_INJURYFREE = 20 --免伤
    local rate = {1, nil, 4.8, 6, 8, nil, 8,nil, 9.6, 9.6, 9.6, 10, 10, nil,nil,nil,nil,nil,12,12}
    local fight = 0
    for k,v in pairs(data) do
        if type(v) == "table" then  -- 未获取坐骑
            k = v[1]
            v = v[2]
        end
        local index = tonumber(k)
        if rate[index] then
            fight = fight + rate[index]*v
        end
    end
    fight = math.ceil(fight*0.75)
    return fight
end

function WndMounts:_getMountMaxLevel(mount)
    --local maxLv = tonumber(CacheCenter:getGameParam().maxMountsUpgradeLevel)
	local maxLv = tonumber(CacheCenter:getGameParam().gameMaxLevel)
    if mount.basicInfo.quality == 4 then
        maxLv = maxLv + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
    end
    WZLog("----------maxLv----------",maxLv)
    return maxLv
end
-------------------------------------私有方法模块End----------------------------------------
