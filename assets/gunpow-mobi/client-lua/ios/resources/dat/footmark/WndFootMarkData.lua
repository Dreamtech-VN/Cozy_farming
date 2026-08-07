--WndFootMarkData.lua
--@brief	WndFootMark的数据模块
--@date		2017/11/21
--@author	Tianxiang_Xu
--@note		足迹系统

WndFootMark = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootMark:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFootMarkList = nil 			--足迹列表
	self.m_nCurSelIndex = 1 			--当前选中的足迹
	self.m_tFootCellList = nil 			--足迹列表element和cell表
	self.m_nCurSelFootMarkId = nil 		--当前选中的足迹的ID
	self.m_anim = nil 	
	self.m_tOldFootPos = nil 
	self.mountAni = nil 
	self.m_bIsFirst = true 
	self.m_nMoveMaxDis = nil 
	self.m_tOriginPos = nil 
	self.m_nRunIndex = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootMark:_unInit()
	self.m_root = nil
	self.m_tFootMarkList = nil
	self.m_nCurSelIndex = nil  
	self.m_tFootCellList = nil
	self.m_nCurSelFootMarkId = nil 
	self.m_anim = nil 
	self.m_tOldFootPos = nil 
	self.mountAni = nil 
	self.m_bIsFirst = nil 
	self.m_nMoveMaxDis = nil 
	self.m_tOriginPos = nil 
	self.m_nRunIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootMark:createElement()
	if WndFootMark.m_root ~= nil then
		WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, false)
	end
	local element = WZUISystem:getInstance():createElement("WndFootMark")
	assert(element, "WndFootMark create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFootMark:showInterface()
	-- body
--	if not CheckButtonOpen(141) then return end 

	local wndFoot = WndFootMark:createElement()
	if wndFoot then 
		WindowManager:addWindow(wndFoot, WndFootMark, false)
	end
end

--@brief	获取所有足迹数据列表
function WndFootMark:initAllFootMarkData()
    WZLog("--------------get cacheCenter data--------------------")
    -- 足迹排序方式
    local function sortFoot(a,b)
        local ap = self:_getFootPriority(a)
        local bp = self:_getFootPriority(b)
        if ap == bp then
        	if GDatatab_item["id_" .. a.item_id].quality ~= GDatatab_item["id_" .. b.item_id].quality then
        		return GDatatab_item["id_" .. a.item_id].quality > GDatatab_item["id_" .. b.item_id].quality
        	else
            	return a.id < b.id
            end
        else
            return ap > bp
        end
        return false
    end

    -- 获取足迹信息
	self.m_tFootMarkList = CacheCenter:getFootMarkInfo()
	if type(self.m_tFootMarkList) == "table" then
		table.sort(self.m_tFootMarkList , sortFoot)
		self:_update()
	end
end

--@brief 	切换足迹的使用状态
function WndFootMark:changeFootMark(originFootMarkId, curFootMarkId)
	--doby
	if self.m_root == nil then return end 
	WZLog("WndFootMark:changeFootMark", originFootMarkId, curFootMarkId)
	--改变按钮的状态
	for i = 1, #self.m_tFootCellList do
		local footMarkId = self.m_tFootCellList[i].tcell:getFootMarkId()
		if footMarkId == originFootMarkId or footMarkId == curFootMarkId then 
			self.m_tFootCellList[i].tcell:_initBtnState()
		end
	end	
	--刷新左边区域信息数据

end

--@brief 	足迹体验时间结束，更新数据
function WndFootMark:updateAfterUseTimeEnd(footMarkId)
	-- body
	if self.m_root == nil then return end 

	local nUsingFootMarkId = CacheCenter:getUsingFootMarkId()
	local nIndex 
	for i = 1, #self.m_tFootMarkList do
		if self.m_tFootMarkList[i].id == footMarkId then 
			self.m_tFootMarkList[i].isHave = false
			self.m_tFootMarkList[i].remainTime = 0 
			self.m_tFootMarkList[i].upgradeLevel = 0 
			nIndex = i 
			break
		end
	end

	--如果正在使用的足迹体验时间结束，则发送协议修改使用状态
	if nUsingFootMarkId == footMarkId then 
		ProtocolProcessorFootMark:send_FOOTMARK_ChangeState(nUsingFootMarkId)
	end
	WZLog("WndFootMark:updateAfterUseTimeEnd", self.m_nCurSelIndex, nIndex)
	--更新总战力
	self:_updateFight()
	--更新足迹数量
	self:_updateFootMarkNum()
	if self.m_nCurSelIndex == nIndex then 
		self:updateMountInfo(footMarkId)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	排序优先级 激活 > 拥有（出站>品质）>未获得（品质）
function WndFootMark:_getFootPriority(footMarkData)
    local priority = 0
    local nCurFootMarkId = CacheCenter:getUsingFootMarkId()
    local nCurTime = SystemTime:getServerTime()

    if footMarkData.remainTime == -1 or footMarkData.remainTime > nCurTime then priority = 1 end
    if nCurFootMarkId == footMarkData.id then priority = 2 end
    if footMarkData.remainTime <= nCurTime and footMarkData.remainTime ~= -1 then
    	local costId, costNum = self:getPath(footMarkData)
    	local curCnt = CacheCenter:getPlayerItemCountById(costId)
        if curCnt >= costNum then 
            priority = GDatatab_item["id_" .. footMarkData.item_id].quality + 2
        end
    end

    return priority
end

--@brief 	获取激活条件数据
function WndFootMark:getPath(footMarkData)
	-- body
	local costId, costNum = footMarkData.tItem.way[2][2], footMarkData.tItem.way[3][2]

	return costId, costNum 
end

-- 获得坐骑的属性
function WndFootMark:_getProperty(tProperty)
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

-- 设置当前cell的相关信息
function WndFootMark:setCellData(tag, element, tcell)
    if not self.m_tFootCellList[tag] then  self.m_tFootCellList[tag] = {} end
    self.m_tFootCellList[tag].element = cell
    self.m_tFootCellList[tag].tcell = tcell
end

-- 根据id获取到本地的数据的下标
function WndFootMark:getIndexById(id)
    for i = 1, #self.m_tFootMarkList do
        if self.m_tFootMarkList[i].id == id then
            return i, self.m_tFootMarkList[i]
        end
    end
    return 1
end

-- 根据ID获取到缓存中心数据，更新本地数据
function WndFootMark:updateByCacheCenterById(id)
    local data = CacheCenter:getFootMarkInfo()
    local newData
    for k,v in pairs(data) do
        if v.id == id then newData = v  end
    end

    for i = 1, #self.m_tFootMarkList do
        if self.m_tFootMarkList[i].id == id then
            self.m_tFootMarkList[i] = newData
            if self.m_tFootMarkList[i].isHave then
                local t = self:_getProperty(self.m_tFootMarkList[i].property)
                self.m_tFootMarkList[i].descProperty = t
            end
            break
        end
    end
end

--@brief	计算足迹战斗力
function WndFootMark:getFight(data)
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

function WndFootMark:_getMountMaxLevel(mount)
	local maxLv = tonumber(CacheCenter:getGameParam().gameMaxLevel)
    -- if mount.basicInfo.quality == 4 then
    --     maxLv = maxLv + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
    -- end
    WZLog("----------maxLv----------",maxLv)
    return maxLv
end
-------------------------------------私有方法模块End----------------------------------------
