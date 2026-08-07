--WndTowerPreview.lua
--@brief	WndTowerPreview的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@note		爬塔副本奖励预览窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerPreview:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndTowerPreview:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:actionCallback()
end

----@brief    弹窗动画完成后的回调
function WndTowerPreview:actionCallback(element, data)
	--初始化界面
    local txtAwardDesc = GetElement(self.m_root,"txtAwardDesc_WndTowerPreview",WZUIFreeTextBox)
    if self.m_nTowerType == 2 then 
        txtAwardDesc:setShowText(string.format(LocalStrings.DOUBLETOWER_TEXT8, "00:00"))
    elseif self.m_nTowerType == 3 then
        txtAwardDesc:setShowText(LocalStrings.TEAM_WORLD_BOSS_SEND_DESC)
    elseif self.m_nTowerType == 4 then
        txtAwardDesc:setShowText(LocalStrings.SINGLE_WORLD_BOSS_SEND_DESC)
    elseif self.m_nTowerType == 5 then
        txtAwardDesc:setShowText(LocalStrings.COUPLE_HEGEMONY_TEXT2)
    else
        txtAwardDesc:setShowText(string.format(LocalStrings.TOWER_SEND_DESC,"00:00"))
    end
	self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerPreview:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerPreview:onClose(element)
    WZLog("WndTowerPreview:onClose")
   SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief  查看爬塔排行榜
function WndTowerPreview:onTowerRankClick()
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root:isVisible() then
        self.m_root:setVisible(false)
        WndTowerRank:showWindow(self.m_nTowerType)
        WindowManager:removeWindow(self.m_root,self,true)
        --WndTowerRank:getRoot():setVisible(true)
    end
end

--@brief 查看每日奖励
function WndTowerPreview:onDailyReward()
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if not self.m_root:isVisible() then
        --self.m_root:setVisible(true)
        --WndTowerRank:getRoot():setVisible(false)
    end
end

--@brief	动画播完后的回调
function WndTowerPreview:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
    if WndTowerRank:getRoot() then
        WindowManager:removeWindow(WndTowerRank:getRoot(), WndTowerRank, true)
    end
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndTowerPreview:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndTowerPreview:onClickItem(tItem, nTag, tData)
    WZLog("WndTowerPreview:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndTowerPreview:_initUI()
    if self.m_root == nil then
        return
    end
    self.m_tData = {}
    local playerSex = CacheCenter:getPlayerInfo().sex

    if self.m_nTowerType == 3 then
        local mapId = SceneWorldTeamBossRoom.bossRoomInfo.mapId

        local tTeamWorldBossInfo = GDatatab_team_world_boss_map["id_"..mapId]
        local reward = {}
        reward.rank = -1
        reward.id = 0
        reward.reward_gift = self:getFilterReward(tTeamWorldBossInfo.kill_reward)
        table.insert(self.m_tData,reward) --击杀奖励

        for k,v in pairs(GDatatab_team_world_boss_reward) do
            if v.map_id == mapId then
                local reward = {}
                reward.rank = v.rank
                reward.id = v.id
                reward.reward_gift = self:getFilterReward(v.reward)
                table.insert(self.m_tData,reward) --排名奖励
            end
        end
    elseif self.m_nTowerType == 4 then
        local mapId = 1
        for k,v in pairs(GDatatab_world_boss_reward) do
            if v.map_id == mapId then
                local reward = {}
                reward.rank = v.rank
                reward.id = v.id
                reward.reward_gift = self:getFilterReward(v.reward)
                
                table.insert(self.m_tData,reward)
            end
        end
    elseif self.m_nTowerType == 5 then
        local mapId = SceneCoupleHegemonyRoom.bossRoomInfo.mapId

        local tTeamWorldBossInfo = GDatatab_couple_fight_boss_map["id_"..mapId]
        local reward = {}
        reward.rank = -1
        reward.id = 0
        reward.reward_gift = self:getFilterReward(tTeamWorldBossInfo.kill_reward)
        table.insert(self.m_tData,reward) --击杀奖励

        for k,v in pairs(GDatatab_couple_fight_boss_reward) do
            local reward = {}
            reward.rank = v.rank
            reward.id = v.id
            reward.reward_gift = self:getFilterReward(v.reward)
            table.insert(self.m_tData,reward) --排名奖励
        end
    else
        local tRewarTable = {}
        tRewarTable = GDatatab_tower_rank_reward
        if self.m_nTowerType == 2 then 
            tRewarTable = GDatatab_grouptower_rank_reward
        end
        for k,v in pairs(tRewarTable) do
            local reward = {}
            reward.rank = v.rank
            reward.id = v.id
            if playerSex == 1 then
                reward.reward_gift = v.reward_girl
            else
                reward.reward_gift = v.reward_boy
            end
            
            table.insert(self.m_tData,reward)
        end
    end

    table.sort(self.m_tData,function (a,b)
        if a.id < b.id then
            return true
        else
            return false
        end
    end)
    self:_updateItemList()
end

--@brief    根据性别过滤奖励
function WndTowerPreview:getFilterReward(reward)
    local playerSex = CacheCenter:getPlayerInfo().sex
    local reward_gift = {}
    for i=1,#reward do
        local itemInfo = GDatatab_item["id_"..reward[i][1]]
        if itemInfo.sex == 2 or itemInfo.sex == playerSex then
            table.insert(reward_gift,reward[i])
        end
    end
    return reward_gift
end

function WndTowerPreview:onGet()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)

    WZLog("------------send get tower reward------------------")
end

--@brief	更新奖励列表
function WndTowerPreview:_updateItemList()
    local tbconList = GetElement(self.m_root, "tbconList_WndTowerPreview", WZUITableContainer)
    tbconList:cleanTable()
    tbconList:enableSchedule("_loadItemList")
    self.m_tbconList = tbconList
end


--@brief  分帧加载数据
function WndTowerPreview:_loadItemList(element)
    WZLog("WndTowerPreview:_loadItemList", type(self.m_nLoadCount), type(self.m_tData))
    if self.m_nLoadCount <= #self.m_tData then
        local cell,tcell = CellTowerPreview:createElement()
        cell:setTag(self.m_nLoadCount-1)
        self.m_tbconList:setCellElement(cell)
        tcell:setData(self.m_tData[self.m_nLoadCount])
    else
        self.m_nLoadCount = 1
        element:disableSchedule()
    end
    self.m_nLoadCount = self.m_nLoadCount + 1
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndTowerPreview:_adaptLanguage_en()
	
end

function WndTowerPreview:_adaptLanguage_pt(  )
end

function WndTowerPreview:_adaptLanguage_vn()
end

function WndTowerPreview:_adaptLanguage_tr(  )
end

function WndTowerPreview:_adaptLanguage_es(  )
end

function WndTowerPreview:_adaptLanguage_ug(  )
    local txtArms2 = GetElement(self.m_root,"txtArms2_WndTowerPreview",WZUILabelTTF)
    txtArms2:setScale(0.7)
    txtArms2:setDimensions(GlobalMethod:CCSize(110))
    local txtArms = GetElement(self.m_root,"txtArms_WndTowerPreview",WZUILabelTTF)
    txtArms:setScale(0.7)
    txtArms:setDimensions(GlobalMethod:CCSize(110))
end
-------------------------------------语言适配模块End--------------------------------------
