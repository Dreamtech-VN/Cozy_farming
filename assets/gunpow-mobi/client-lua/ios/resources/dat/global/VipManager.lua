--VipManager.lua
--@brief	vip特权
--@date		2015/5/5
--@author	xiaoyu_wu


VipManager =
{
    m_tVipRestrictionData = nil     --Vip限购表，由LocalData里的GDatatab_vip_restriction解析出来
}
--vip限购类型定义
VIPRESTRICTIONTYPE_MULTICOPY = 0 --组队副本重置次数
VIPRESTRICTIONTYPE_DAILYCOPY = 1 --日常副本重置次数

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    初始化
function VipManager:init()
    self:_parseVipRestrictionData() --解析vip限购表
end

--@brief    获取组队副本重置消耗
--@param    nResetCount, 已重置次数
--@return   #1,重置消耗表 {货币id,货币数量}, 不可重置时返回nil
function VipManager:getMultiCopyResetCost(nResetCount)
    if self.m_tVipRestrictionData == nil then
        self:_parseVipRestrictionData()
    end
    local tList = self.m_tVipRestrictionData[VIPRESTRICTIONTYPE_MULTICOPY]
    if tList == nil then
        return
    end
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    if tPlayerInfo == nil then
        WZLog("VipManager:getMultiCopyResetCost Player Info is nil !")
        return
    end
    local nVipLevel = tPlayerInfo.vipLevel
    for i,v in pairs(tList) do
        if v.num == nResetCount + 1 then --下一次重置信息
            if v.vip_level <= nVipLevel then --可以重置，返回重置信息
                return v.deduct[1]
            end
            break
        end
    end
    MsgBoxManager:showTipBox(LocalStrings.RESET_NOT_ENOUGH)
end

--@brief    获取组队副本重置消耗
--@param    nMapId, 地图id
--@param    nResetCount, 已重置次数
--@return   #1,重置消耗表 {货币id,货币数量}, 不可重置时返回nil
function VipManager:getDailyCopyResetCost(nMapId, nResetCount)
    if self.m_tVipRestrictionData == nil then
        self:_parseVipRestrictionData()
    end
    local tList = self.m_tVipRestrictionData[VIPRESTRICTIONTYPE_DAILYCOPY]
    if tList == nil then
        return
    end
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    if tPlayerInfo == nil then
        WZLog("VipManager:getDailyCopyResetCost Player Info is nil !")
        return
    end
    local nVipLevel = tPlayerInfo.vipLevel
    WZLog("-------------------------------------",#tList)
    for i,v in pairs(tList) do
        WZLog(v.parameter, v.num, nMapId, nResetCount)
        if v.parameter == nMapId and v.num == nResetCount + 1 then --下一次重置信息
            if v.vip_level <= nVipLevel then --可以重置，返回重置信息
                return v.deduct[1]
            end
            break
        end
    end
    MsgBoxManager:showTipBox(LocalStrings.RESET_NOT_ENOUGH)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    解析vip限购表
--@note     按类型拆分vip限购表
function VipManager:_parseVipRestrictionData()
    self.m_tVipRestrictionData = {}
    for i,v in pairs(GDatatab_vip_restriction) do
        self.m_tVipRestrictionData[v.type] = self.m_tVipRestrictionData[v.type] or {}
        table.insert(self.m_tVipRestrictionData[v.type], v)
    end
end

-------------------------------------私有方法模块End----------------------------------------







