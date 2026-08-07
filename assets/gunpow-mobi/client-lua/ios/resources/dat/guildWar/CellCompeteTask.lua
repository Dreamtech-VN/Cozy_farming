-- 公会战目标列表内容 UI部分
-- @brief:
-- @date: 2017-02-23 10:44:26
-- @author: zhenwei_jian
-- @note:公会战目标列表内容


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCompeteTask:onEnter(element)
	self.m_root = element
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCompeteTask:onExit(element)
	self:_unInit()
end

--@brief  点击获取奖励
function CellCompeteTask:onClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorCommunityWar:send_GUILDWAR_ObtainGuildWarTask(self.m_tData.id)
end


--@brief    CellCompeteTask
function CellCompeteTask:onOthersClick(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndCompeteTask.m_root, 1, tData, false, nil, true)
end


-------------------------------------公有方法模块End--------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

--@brief 更新显示
function CellCompeteTask:_update() 
	if nil == self.m_root then return end 

    local conPlaying  	= GetElement(self.m_root, "conPlaying", WZUIContainer)    --正在进行任务 容器
    local conFinish    	= GetElement(self.m_root, "conFinish", WZUIContainer)     --已完成 容器

    local lableName     = GetElement(self.m_root, "label_name", WZUILabelTTF)     --任务名字
    local labelParam    = GetElement(self.m_root, "label_param", WZUILabelTTF)    --完成数量

    --已完成数量
    local nFinishNum 	= self.m_tData.finishNum

    --设置任务名字
    local _tNameMap = {
    	[1] = LocalStrings.COMMUNITYWARTASK_TEXT2,
    	[2] = LocalStrings.COMMUNITYWARTASK_TEXT5,
    	[3] = LocalStrings.COMMUNITYWARTASK_TEXT6,
	}
    local sTaskName = _tNameMap[self.m_tData.type] or ""
    lableName:setText(sTaskName)

    
    --已完成任务
    if nFinishNum >= self.m_tData.num then
    	conPlaying:setVisible(false)
    	conFinish:setVisible(true)
    else
    	conPlaying:setVisible(true)
    	conFinish:setVisible(false)

    	--设置任务完成情况
    	labelParam:setText(string.format("%s/%s", nFinishNum, self.m_tData.num))
    end


    -- 奖励
    for i, mData in ipairs(self.m_tData.reward) do
        self:_createGoodsIcon(mData, i)
    end
end

--@brief 创建物品icon
function CellCompeteTask:_createGoodsIcon(tGoodsData, nGoodsIndex)
	local conItem = GetElement(self.m_root, string.format("conItem%d_Cell", nGoodsIndex), WZUIContainer)
	local cell, tCell = CellGoodItem:createElement()
	conItem:addChild(cell)
    tCell:setItemClickFun(self, self.onOthersClick)
	cell:setTag(nGoodsIndex)


    tCell:setCellGoodLocalId(tGoodsData[1], 4)
    tCell:setItemNumber(tGoodsData[2])
end

-------------------------------------私有方法模块End--------------------------------------

