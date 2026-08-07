--CellRelation.lua
--@brief	CellRelation的UI模块
--@date		2016/11/16
--@author	Tianxiang_Xu
--@note		关系子节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRelation:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRelation:onExit(element)
	self:_unInit()
end

--@brief    点击图标回调
function CellRelation:onClickIcon(element)
    --body
    WZLog("CellRelation:onClickIcon")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = {}
    tData[1] = {}
    tData[2] = {}

    if self.m_nType == 1 then
        CellRelation.m_CurClick = self
        CellRelation.m_CurClick.m_Element = element
        ProtocolProcessorWndFriends:send_FRIEND_CoupleNum()
        return 
    else
        local nValue
        if self.m_nType == 2 then
            nValue = self.m_tData.friendliness
        elseif self.m_nType == 3 then
            nValue = self.m_tData.moralityLevel
        elseif self.m_nType == 4 then
            nValue = 0
        end
        local tTempInfo = self:getRelationName(self.m_nType, nValue)
        tData[1][1] = self.m_tPlayerInfo.name .. tTempInfo.title
        tData[2][1] = LocalStrings.FRIENDLINESS .. self.m_tData.friendliness
        if ProjConfig.LANGUAGE == "vn" then
            tData[1][1] = tTempInfo.title .. self.m_tPlayerInfo.name  
        end
    end
    WndTips:show(element,self.m_parentNode,31,tData, GlobalMethod:ccp(150,30), not self.m_parentNode:getShowAll())
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新显示
function CellRelation:_update()
    -- body
    local imgRelativeIcon = GetElement(self.m_root, "imgRelativeIcon_CellRelation", WZUIImage)

    local nValue
    if self.m_nType == 2 then
        nValue = self.m_tData.friendliness
    elseif self.m_nType == 1 then
        nValue = CacheCenter:getPlayerInfo().loveLevel
    elseif self.m_nType == 3 then
        nValue = CacheCenter:getPlayerInfo().moralityLevel
    elseif self.m_nType == 4 then
        nValue = 0
    end
    local tTempInfo = self:getRelationName(self.m_nType, nValue)

    if imgRelativeIcon then
        imgRelativeIcon:setFile(tTempInfo.icon)
    end
end

--@brief    根据类型和值，获取相应的名称
function CellRelation:getRelationName(nType, nValue)
    -- body
    local tTempList = {}
    for i, value in pairs(GDatatab_relationship) do
        if value.type == nType then
            local tItem = {}
            tItem.id = value.id 
            tItem.type = value.type 
            tItem.icon = value.icon
            tItem.degree = value.degree
            if nType == 2 then
                local tTitle = SplitStringWithSeparator(value.title, "&")
                if self.m_tData.sex ~= self.m_tPlayerInfo.sex then
                    tItem.title = tTitle[2]
                elseif self.m_tData.sex == self.m_tPlayerInfo.sex and self.m_tData.sex == 0 then
                    tItem.title = tTitle[1]
                elseif self.m_tData.sex == self.m_tPlayerInfo.sex and self.m_tData.sex == 1 then
                    tItem.title = tTitle[3]
                end
            elseif nType == 1 then
                tItem.title = value.title
            elseif nType == 3 then
                tItem.title = value.title
            elseif nType == 4 then
                tItem.title = value.title
            end
            table.insert(tTempList, tItem)
        end
    end

    table.sort(tTempList, function (a, b)
        -- body
        return a.degree < b.degree
    end)

    for k = 1, #tTempList do
        if tTempList[k].degree < nValue then
            if k + 1 <= #tTempList then 
            else 
                return tTempList[k]
            end
        elseif tTempList[k].degree == nValue then
            return tTempList[k]
        elseif tTempList[k].degree > nValue then
            if k - 1 > 0 then
                return tTempList[k - 1]
            end
        end
    end

    return nil 
end


-------------------------------------私有方法模块End----------------------------------------
