-- BattleEffectManager.lua
--@brief    t特效管理
--@date     2015/5/29

BattleEffectManager = {}

local g_tBattaleEffectManager = nil

--@brief    获得当前的特效管理器
--@return   #1, 返回当前的动作管理器
function BattleEffectManager:getInstance()
    if g_tBattaleEffectManager == nil then
        g_tBattaleEffectManager = {}
        setmetatable(g_tBattaleEffectManager,{__index = BattleEffectManager})
        g_tBattaleEffectManager.m_tEffectList = {}
        g_tBattaleEffectManager.m_tBulletEffectList = {}
    end
    return g_tBattaleEffectManager
end

--@brief    做时间滴答调用
--@param    nDt 上一桢到当前桢过去的时间
function BattleEffectManager:update(nDt)
    if #g_tBattaleEffectManager.m_tEffectList > 0 then
        for i = #g_tBattaleEffectManager.m_tEffectList, 1, -1 do
            local effect = g_tBattaleEffectManager.m_tEffectList[i]
            if effect and effect:isRunning() then
                -- effect:doneEffect()
                if effect:isCurrentAnimationDone() and not effect:continue() then
                    self:removeEffect(effect)
                    table.remove(g_tBattaleEffectManager.m_tEffectList,i)
                end
            else
                WZLog("BattleEffectManager:removeEffect",effect:isRunning() , effect:isCurrentAnimationDone())
                table.remove(g_tBattaleEffectManager.m_tEffectList,i)
            end
        end
    end

    if #g_tBattaleEffectManager.m_tBulletEffectList > 0 then
        for i = #g_tBattaleEffectManager.m_tBulletEffectList, 1, -1 do
            local effect = g_tBattaleEffectManager.m_tBulletEffectList[i]
            if effect then 
                if effect:explodeIsEnd() then
                    self:removeBulletEffect(effect)
                    table.remove(g_tBattaleEffectManager.m_tBulletEffectList,i)
                end
            else
                table.remove(g_tBattaleEffectManager.m_tBulletEffectList,i)
            end
        end
    end
end

--@brief    添加特效
--@param    effect 特效
function BattleEffectManager:addEffect(effect)
    if effect.m_bIsProgram then
        return
    end
    WZLog("BattleEffectManager:addEffect",effect.m_effectId)
    table.insert(g_tBattaleEffectManager.m_tEffectList,effect)
end

--@brief    删除特效
function BattleEffectManager:removeEffect(effect)
   if effect and effect:getAnimNode() and effect:getAnimNode():getParent() then
        WZLog("BattleEffectManager:removeEffect")
        effect:getAnimNode():removeFromParentAndCleanup(true)
    end
end

--@brief    添加子弹特效
--@param    effect 特效
function BattleEffectManager:addBulletEffect(effect)
    WZLog("BattleEffectManager:addBulletEffect")
    table.insert(g_tBattaleEffectManager.m_tBulletEffectList,effect)
end

--@brief    删除子弹特效
function BattleEffectManager:removeBulletEffect(effect)
   if effect  then
        WZLog("BattleEffectManager:removeBulletEffect")
        effect:removeElement()
    end
end

--@brief    删除特效
function BattleEffectManager:destroy()

   if #g_tBattaleEffectManager.m_tEffectList > 0 then
        for i = #g_tBattaleEffectManager.m_tEffectList, 1, -1 do
            local effect = g_tBattaleEffectManager.m_tEffectList[i]
            if effect and effect:isRunning() then
                self:removeEffect(effect)
            end
        end
    end
    g_tBattaleEffectManager.m_tEffectList = nil

    if #g_tBattaleEffectManager.m_tBulletEffectList > 0 then
        for i = #g_tBattaleEffectManager.m_tBulletEffectList, 1, -1 do
            local effect = g_tBattaleEffectManager.m_tBulletEffectList[i]
            if effect then
                self:removeBulletEffect(effect)
            end
        end
    end
    g_tBattaleEffectManager.m_tBulletEffectList = nil

    g_tBattaleEffectManager = nil
end