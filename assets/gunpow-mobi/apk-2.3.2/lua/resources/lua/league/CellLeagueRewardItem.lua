--CellLeagueRewardItem.lua
--@brief	CellLeagueRewardItem的UI模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-奖励列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueRewardItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueRewardItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell数据信息
function CellLeagueRewardItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellLeagueRewardItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief    点击奖励物品回调
function CellLeagueRewardItem:onOthersClick(luaTable,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,SceneLeagueMain.m_root,1,tData,false, nil, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell信息
function CellLeagueRewardItem:_update()
    -- body
    self:_showGoalAndProgress()
    self:_showRewards()
end

--@brief    显示奖励物品
function CellLeagueRewardItem:_showRewards()
    -- body
    local rewardList = self.m_tData.reward
    if rewardList == nil then return end
    for i = 1, #rewardList do
        local key = "id_" .. rewardList[i][1]
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            local conItem = GetElement(self.m_root, string.format("conItem%d_CellLeagueRewardItem", i), WZUIContainer)
            celElement = WZUIContainer:luaTo(celElement)
            WZLog("CellLeagueRewardItem:_showRewards",rewardList[i][1], rewardList[i][2])
            local itemInfo = {id = rewardList[i][1], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=rewardList[i][2],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,16)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            celElement:setScale(0.8)
            conItem:addChild(celElement)
        end
    end
end

--@brief    设置目标和进度
function CellLeagueRewardItem:_showGoalAndProgress()
    --WZLog("CellLeagueRewardItem:_showGoalAndProgress self.m_tData.title = ", self.m_tData.title)
    -- body
    --目标
    local txtGoal = GetElement(self.m_root, "txtGoal_CellLeagueRewardItem", WZUILabelTTF)
    txtGoal:setText(self.m_tData.title)
    --进度
    local txtState = GetElement(self.m_root, "txtState_CellLeagueRewardItem", WZUILabelTTF)
    if self.m_tData.type == 1 then 
        if self.m_tData.state == 0 then
            txtState:setText(self.m_tData.nComplete .. "/" .. self.m_tData.nTarget)
        elseif self.m_tData.state == 1 or self.m_tData.state == 2 then
            txtState:setColor(GlobalMethod:ccc3(138,122,106))
            txtState:setText(LocalStrings.LEAGUE_REWARD_TEXT7)
        end
    elseif self.m_tData.type == 3 or self.m_tData.type == 4 then 
        if self.m_tData.state == 0 then
            txtState:setText(LocalStrings.LEAGUE_REWARD_TEXT6)
        elseif self.m_tData.state == 1 then
            txtState:setColor(GlobalMethod:ccc3(138,122,106))
            txtState:setText(LocalStrings.LEAGUE_NOT_SEND)
        elseif self.m_tData.state == 2 then
            txtState:setColor(GlobalMethod:ccc3(138,122,106))
            txtState:setText(LocalStrings.LEAGUE_REWARD_TEXT7)
        end

        if ProjConfig.LANGUAGE == "vn" then
            txtState:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
            txtState:setFontSize(20)
        end
    end

    --前三是否显示显示图标
    if self.m_tData.type == 2 then
        local imgRank = GetElement(self.m_root, "imgRank_CellLeagueRewardItem", WZUIImage)
        if self.m_tData.rank == 1 then 
            txtGoal:setVisible(false)
            imgRank:setVisible(true)
            imgRank:setFile("ui/common/common_icon_1st_1.png")
        elseif self.m_tData.rank == 2 then
            txtGoal:setVisible(false)
            imgRank:setVisible(true)
            imgRank:setFile("ui/common/common_icon_2nd_1.png")
        elseif self.m_tData.rank == 3 then
            txtGoal:setVisible(false)
            imgRank:setVisible(true)
            imgRank:setFile("ui/common/common_icon_3rd_1.png")
        end
    end

end
-------------------------------------私有方法模块End----------------------------------------
