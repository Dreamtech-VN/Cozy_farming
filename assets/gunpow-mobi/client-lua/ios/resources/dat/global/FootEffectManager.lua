-- FootEffectManager.lua
--@brief    t特效管理
--@date     2015/5/29

FootEffectManager = {}

local g_tFootEffectManager = nil

--@brief    获得当前的特效管理器
--@return   #1, 返回当前的动作管理器
function FootEffectManager:getInstance()
    if g_tFootEffectManager == nil then
        g_tFootEffectManager = {}
        setmetatable(g_tFootEffectManager,{__index = FootEffectManager})
        g_tFootEffectManager.m_tEffectList = {}
        g_tFootEffectManager.m_tLayer = nil
        g_tFootEffectManager.m_bIsCityLayer = nil
        g_tFootEffectManager.g_nTickId = nil
    end
    return g_tFootEffectManager
end

--@brief 设置足迹
function FootEffectManager:setFootLayer(layer,isCity)
    WZLog("FootEffectManager:setFootLayer")
    if FootEffectManager:getInstance().m_tLayer then
        FootEffectManager:getInstance():destroy()
    end

    FootEffectManager:getInstance().m_tLayer = layer
    FootEffectManager:getInstance().m_bIsCityLayer = isCity
        
    FootEffectManager:getInstance().g_nTickId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(FootEffectManager.update, 1, false)
end

--@brief    做时间滴答调用
--@param    nDt 上一桢到当前桢过去的时间
function FootEffectManager:update(nDt)
    if not g_tFootEffectManager then
        return
    end
    if #g_tFootEffectManager.m_tEffectList > 0 then
        for i = #g_tFootEffectManager.m_tEffectList, 1, -1 do
            local effect = g_tFootEffectManager.m_tEffectList[i]
            if effect then
                -- effect:doneEffect()
                if effect:isCurrentAnimationDone() then
                    g_tFootEffectManager:removeEffect(effect)
                    table.remove(g_tFootEffectManager.m_tEffectList,i)
                end
            else
                WZLog("FootEffectManager:removeEffect-1")
                table.remove(g_tFootEffectManager.m_tEffectList,i)
            end
        end
    end
end

--@brief    添加特效
--@param    effect 特效
function FootEffectManager:addEffect(footId,pos,offsetY,scaleX,scaleY)
    if not FootEffectManager:getInstance().m_tLayer or footId <= 0 then
        return
    end
    WZLog("FootEffectManager:addEffect",footId)
    local effectName = GDatatab_footmark["id_" .. footId] and GDatatab_footmark["id_" .. footId].animation or "city_footprints_0"
    local effectPath = "armatures/footprint/"..effectName
    local spine = WZUISpine:create()
    FootEffectManager:getInstance().m_tLayer:addChild(spine,-1)

    spine:setTouchEnable(false)
    spine:setFileJson(effectPath..".json")
    spine:setFileAtlas(effectPath..".atlas")
    spine:play("wait", false)
    spine:setUseOriginSize(true)
    spine:setPosition(GlobalMethod:ccp(pos.x,pos.y + offsetY))
    spine:setScaleX(scaleX)
    spine:setScaleY(scaleY)

    table.insert(g_tFootEffectManager.m_tEffectList,spine)
end

--@brief    删除特效
function FootEffectManager:removeEffect(effect)
   if effect and effect:getParent() then
        WZLog("FootEffectManager:removeEffect")
        effect:removeFromParentAndCleanup(true)
    end
end

--@brief    删除特效
function FootEffectManager:destroy()
    WZLog("FootEffectManager:destroy")
    if g_tFootEffectManager and g_tFootEffectManager.g_nTickId then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_tFootEffectManager.g_nTickId)
        g_tFootEffectManager.g_nTickId = nil
    end
   if #g_tFootEffectManager.m_tEffectList > 0 then
        for i = #g_tFootEffectManager.m_tEffectList, 1, -1 do
            local effect = g_tFootEffectManager.m_tEffectList[i]
            self:removeEffect(effect)
        end
    end
    g_tFootEffectManager.m_tEffectList = nil
    g_tFootEffectManager.m_tLayer = nil
    g_tFootEffectManager.m_bIsCityLayer = nil
    g_tFootEffectManager = nil
end