--CellDailyCopy.lua
--@brief	CellDailyCopy的UI模块
--@date		2015-6-17
--@author	binshao
--@note		日常副本单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDailyCopy:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDailyCopy:onExit(element)
	self:_unInit()
end

-- 点击cell回调，如果未开启，弹TIP
function CellDailyCopy:OnBtnSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if not self.tData.diff[1].isOpen then
        local desc = self.tData.diff[1].localData.map_desc
        local data = "\n"..desc.."\n"
        WZLog("WWWWWWW:",desc,data)
        local leftCon = GetElement(WndDailyCopy.m_root,"conLeft_WndDailyCopy",WZUIContainer)
        --MsgBoxManager:showTipBox(data)
        WndItemInfo:showInfo(element,leftCon,3,data,false,nil,nil)
        return
    end
    self.callback[2](self.callback[1],self.m_root:getTag())
end

-- 设置cell选择状态
function CellDailyCopy:SetSelectState(state)
    local imgSel = GetElement(self.m_root, "imgSel_CellDailyCopy", WZUI9Image)
    imgSel:setVisible(state)
    GetElement(self.m_root, "imgSel2_CellDailyCopy", WZUIImage):setVisible(state)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    更新界面
function CellDailyCopy:_update()
    local localData = self.tData.diff[1].localData
    local imgMap = GetElement(self.m_root, "imgMap_CellDailyCopy", WZUIImage)
    WZLog("CellDailyCopy:_update:",self.tData.section)
    WZLog("ui/dailyCopy/common_icon_copyModle"..self.tData.section..".png")
	local imgFile = {"ui/dailyCopy/common_icon_xdsl.png", "ui/dailyCopy/common_icon_fsem.png","ui/dailyCopy/common_icon_cwdb.png"}
    imgMap:setFile(imgFile[self.tData.section])
    local boolGray = not  self.tData.diff[1].isOpen
    imgMap:setGrayRender(boolGray)
    -- if not  self.tData.diff[1].isOpen then
    --     imgMap:setGra
    -- end
end


-------------------------------------私有方法模块End----------------------------------------
----@brief    获取开放时间的文本
----@return   #1,开放时间的文本
--function CellDailyCopy:_getOpenString()
--    if #self.tData.map_level[1] == 7 then
--        return LocalStrings.OPEN_EVERYDAY
--    end
--    local tWeek = {}
--    for i,v in ipairs(self.tData.map_level[1]) do
--        local nWeek = math.mod(v+1, 7)
--        if nWeek == 0 then
--            nWeek = 7
--        end
--        tWeek[i] = LocalStrings.CALENDAR_WEEK[nWeek]
--    end
--    local sWeek = CombineStringArrayWithSeparator(tWeek, "、")
--    return string.format(LocalStrings.DAILYCOPY_OPEN_DAY, sWeek)
-- end


--@brief	点击挑战按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
--function CellDailyCopy:onChallenge(element)
--    WZLog("CellDailyCopy:onChallenge")
--    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.tData.id, COPYTYPE_DAILY)
--
--    DelayCallFunction(function()
--        ProtocolProcessorSingleMap:send_SINGLEMAP_ChallengeSuccess(self.tData.id, "", COPYTYPE_DAILY)
--    end, nil, 1)
--
--    --ProtocolProcessorSingleMap:parse_SINGLEMAP_ChallengeSuccessOk(self.tData.id, {2,3}, {1000,300}, {2}, {1000}, COPYTYPE_DAILY)
--end

----@brief	点击重置按钮时被调用的函数
----@param	element:按钮绑定的UI节点引用
--function CellDailyCopy:onReset(element)
--    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    WZLog("CellDailyCopy:onReset")
--    local nMapId = self.tData.id
--    local nResetTime = self.tData.userData.resetTimes
--    local tCostInfo = VipManager:getDailyCopyResetCost(nMapId, nResetTime)
--    if tCostInfo then
--        local wndResetCopy = WndResetCopy:createElement()
--        WndResetCopy:setClickResetCallback(function()
--            ProtocolProcessorSingleMap:send_SINGLEMAP_ResetDailyMap(self.tData.id)
--            --ProtocolProcessorSingleMap:parse_SINGLEMAP_ResetDailyMapOk(self.tData.id, 0, true, 1)
--        end)
--        WndResetCopy:setResetCost(tCostInfo[1], tCostInfo[2])
--        WindowManager:addWindow(wndResetCopy, WndResetCopy)
--    end
--end

----@brief	禁用状态按钮时被调用的函数
----@param	element:按钮绑定的UI节点引用
--function CellDailyCopy:onDisable(element)
--    WZLog("CellDailyCopy:onDisable")
--    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--    if self.m_nState == self.STATE_NOTOPEN then --未开启
--        local sOpenString = self:_getOpenString()
--        local sTips = string.format(LocalStrings.DAILYCOPY_NOT_OPEN_TIPS, sOpenString)
--        MsgBoxManager:showTipBox(sTips)
--    elseif self.m_nState == self.STATE_LEVELUNREACHED then -- 等级不足
--        MsgBoxManager:showTipBox(LocalStrings.DAILYCOPY_LOCKED_TIPS)
--    end
--end