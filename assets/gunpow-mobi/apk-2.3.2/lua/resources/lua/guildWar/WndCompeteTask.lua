-- WndCompeteTask
-- @brief: 公会战目标界面模块
-- @date: 2017-02-23 10:54:27
-- @author: zhenwei_jian
-- @note: 目标列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief 显示该界面
function WndCompeteTask:showWnd()
	local wnd = self:createElement()
	WindowManager:addWindow( wnd , WndCompeteTask)
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteTask:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    onenter函数已执行
function WndCompeteTask:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "_ready", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteTask:onExit(element)
	self:_unInit()
end

--@brief 	触摸开始回调
function WndCompeteTask:onTouchBegin(element, pt)
	-- body
	if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief	关闭按钮
function WndCompeteTask:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCompeteTask, true)
	end 
end


-- 获取奖励成功
function WndCompeteTask:getRewardSuccess(typeId, num, taskId,itemId,itemNum)
    WndRewardShow:showById(itemId,itemNum)
--    self:setData(typeId, num, taskId)
end

--@brief    判断是否有可领取的目标
function WndCompeteTask:judgeTaskState(typeId, num, taskId)
    -- body
    local bHaveGetTask = false 

    for j = 1, #taskId do
        for i, value in pairs(GDatatab_guild_war_task) do
            if value.id == taskId[j] then
                for k = 1, #typeId do
                    if typeId[k] == value.type then
                        if value.num <=num[k] then
                            bHaveGetTask = true
                            break 
                        end
                    end
                end
            end
            if bHaveGetTask then 
                break 
            end
        end
        if bHaveGetTask then 
            break 
        end
    end

    return bHaveGetTask 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  onEnterTransitionDidFinish 后调用次函数
function WndCompeteTask:_ready()
	--发送消息 获取 目标 完成数据
    local tTargetData = CacheCenter:getGuildWarTargetData()
    if tTargetData then
        self:setData(tTargetData[1], tTargetData[2], tTargetData[3])
    else
        ProtocolProcessorCommunityWar:send_GUILDWAR_GetGuildWarTask()
    end
end

--@brief	更新界面
function WndCompeteTask:_update()

	local freeListContainer = GetElement(self.m_root,"freelist_Task", WZUIFreeListContainer)
	freeListContainer:removeAll()

    local conForList = GetElement(self.m_root, "conForList_WndCompeteTask", WZUIContainer)
    if self.m_tDataList == nil or #self.m_tDataList == 0 then
        ShowPanelNullTip( conForList, LocalStrings.COMPETE_TASK_NO_DATA )
        return 
    end

    removeShowPanelNullTip(conForList)
	
	for i, mConfig in ipairs(self.m_tDataList) do
		local celElement, tCell = CellCompeteTask:createElement()
		if celElement ~= nil and tCell ~= nil then
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(mConfig)
			freeListContainer:pushBack(celElement)
			table.insert(self.m_tCellList, tCell)
		end
	end




	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

-------------------------------------私有方法模块End--------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndCompeteTask:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtNotice_WndCompeteTask",WZUILabelTTF):setScale(0.88)
end

function WndCompeteTask:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtNotice_WndCompeteTask",WZUILabelTTF):setScale(0.9)
end

function WndCompeteTask:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtNotice_WndCompeteTask",WZUILabelTTF):setScale(0.8)
end

function WndCompeteTask:_adaptLanguage_ug(  )
    local txtNotice = GetElement(self.m_root,"txtNotice_WndCompeteTask",WZUILabelTTF)
    txtNotice:setScale(0.7)
    txtNotice:setDimensions(GlobalMethod:CCSize(700))
    txtNotice:setRelativePosition(GlobalMethod:ccp(0.5,0.94))
end
------------------------------------语言适配End------------------------------------------