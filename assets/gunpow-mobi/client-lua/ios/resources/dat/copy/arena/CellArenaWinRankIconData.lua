--CellArenaWinRankIconData.lua
--@brief	CellArenaWinRankIcon的数据模块
--@date		2016-6-29
--@author	binshao
--@note		竞技场战斗结算玩家信息

CellArenaWinRankIcon = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellArenaWinRankIcon:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nRankLv = nil	--当前等级
	self.m_nNextRankLv = nil	--当前下一等级
    self.m_bActionDone = nil          --动画完成
    self.m_nCurDanLv = nil
    self.m_nTargetDanLv = nil
    self.m_tPostListT = {BattleCommon:getPointTable(0.23,0.78),BattleCommon:getPointTable(0.5,0.9),BattleCommon:getPointTable(0.77,0.78)}
    self.m_tPostListF = {BattleCommon:getPointTable(0.23,0.78),BattleCommon:getPointTable(0.4,0.87),BattleCommon:getPointTable(0.6,0.87),BattleCommon:getPointTable(0.77,0.78)}
    self.m_tPostListFi = {BattleCommon:getPointTable(0.2,0.7),BattleCommon:getPointTable(0.325,0.85),BattleCommon:getPointTable(0.5,0.9),BattleCommon:getPointTable(0.675,0.85),BattleCommon:getPointTable(0.8,0.7)}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellArenaWinRankIcon:_unInit()
	self.m_root = nil
    self.m_nRankLv = nil
    self.m_nNextRankLv = nil
    self.m_bActionDone = nil
    self.m_nCurDanLv = nil
    self.m_nTargetDanLv = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellArenaWinRankIcon:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellArenaWinRankIcon table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellArenaWinRankIcon")
	assert(element, "CellArenaWinRankIcon element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据表
--@param    tData, 数据表
function CellArenaWinRankIcon:setData(rankLv,isSimple,isHideBg)
    self.m_nRankLv = rankLv
    self.m_nNextRankLv = rankLv
    self.m_bIsSimple = isSimple
    self.m_bIsHidebg = isHideBg
    self.m_bActionDone = true
    local template = GDatatab_trio_rank_match_config["id_999"]
    self.m_nMaxRankLv = template.level3
    self:_update()
end

--@brief	设置数据表
--@param    tData, 数据表
function CellArenaWinRankIcon:setNextData(nextRankLv)
	WZLog("CellArenaWinRankIcon:setNextData",nextRankLv)
	if self.m_nNextRankLv == nextRankLv then
		return
	end
	local nextTemp = self:getRankTemplateByLv(self.m_nNextRankLv)
    if not nextTemp then
        return
    end
    self.m_nNextRankLv = nextRankLv
	self:_updateNextLv()
end

--@brief	动画完成
function CellArenaWinRankIcon:getActionDone()
	return self.m_bActionDone
end

--@brief 获取配置表
function CellArenaWinRankIcon:getRankTemplateByLv(level)
    for i, value in pairs(GDatatab_trio_rank_match_config) do
        if value.level3 == level then
            return value
        end
    end
    local template = GDatatab_trio_rank_match_config["id_999"]

    if level >= template.level3 then
        return template
    end
    return nil
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellArenaWinRankIcon:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
