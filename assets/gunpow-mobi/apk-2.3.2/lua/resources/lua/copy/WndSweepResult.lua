--WndSweepResult.lua
--@brief	WndSweepResult的UI模块
--@date		2015/04/15
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		扫荡结果页面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSweepResult:onEnter(element)
	self.m_root = element
end

----@brief onEnter函数执行完成回调
function WndSweepResult:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSweepResult:onExit(element)
    -- self.m_root:disableSchedule()
    -- if self.m_oImage then
    --     self.m_oImage:disableSchedule()
    -- end
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndSweepResult:onClose(element)
    WZLog("WndSweepResult:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --[[if self.m_bSweepFlag == false then
        MsgBoxManager:showTipBox(LocalStrings.TOWER_SWEEPING)
        return
    end]]
    if self.m_tData.flopId then 
        local imgComplete = GetElement(self.m_root, "imgComplete_WndSweepResult")
        self:jumpToFlopCard(imgComplete)
        return 
    end 

    WindowManager:removeWindow(self.m_root, self, true)
    if WndTabooCopyInfo.m_root then 
        WndTabooCopyInfo:closeWindow()
    end
    --弹穿上或打开提示窗口
    pushEquipInList()
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndSweepResult:onTouchBegan(element, pt)
    WZLog("WndSweepResult:onTouchBegan")
    WndItemInfo:onCloseClick()
    if self.m_bSweepFlag then
        --local imgComplete = GetElement(self.m_root, "imgComplete_WndSweepResult")
        --imgComplete:setVisible(false)
    end
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSweepResult:onClickItem(tItem, nTag, tData)
    WZLog("WndSweepResult:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

local tempPt = GlobalMethod:ccp(0,0)


function WndSweepResult:actionPlaying()
    WZLog("WndSweepResult:actionPlayer")
    local dTime = 0
    self.m_nCellPlayAnim  = 0
    for i=1,5 do
        local con = GetElement(self.m_oCurPlayAnim,"con"..i.."_CellSweepResult",WZUIContainer)
        local childCount = con:getChildrenCount()
        if childCount>0 then
            con:enableSchedule("scheduleShowItem",dTime)
            dTime = dTime + 0.1
            self.m_nCellPlayAnim = self.m_nCellPlayAnim + 1
        end
    end
end

--@brief  显示扫荡的物品
--@param  element : 定时器绑定的节点
--@param  interval : 间隔
function WndSweepResult:scheduleShowItem(element,interval)
    WZLog("WndSweepResult:scheduleShowItem ")
    element:disableSchedule()
    local actionArray = CCArray:create()
    local scale = CCScaleTo:create(0.15,1,1)
    actionArray:addObject(scale)
    actionArray:addObject(CCCallFunc:create( function () self.m_nCellPlayAnim = self.m_nCellPlayAnim -1 if self.m_nCellPlayAnim == 0 then self.m_root:enableSchedule("scheduleUpdate",0) end end))
    element:runAction(CCSequence:create(actionArray))

end

--@brief	定时显示扫荡结果
--@param	element:节点绑定的lua表
--@param    delta:时间间隔
function WndSweepResult:scheduleUpdate(element)
    if self.m_root == nil then
        return
    end
    local rewardListCount = #self.m_tRewardList
    if self.m_nCreateCellSweep >= rewardListCount - 1 then
        local tbcon = GetElement(self.m_root, "tbcon_WndSweepResult", WZUITableContainer)
        local cellSweepResult = tbcon:getCellElement(self.m_nCurrendIndex)
        if cellSweepResult then
            local cellSweep = cellSweepResult:getChildElement("CellSweepResult_WndSweepResult")
            cellSweep:setVisible(true)
            tempPt.y = 0
            local pt = tbcon:convertToNodeSpace(cellSweepResult:convertToWorldSpace(tempPt)) --得到当前单元格在表容器里的位置
            self.m_oCurPlayAnim = cellSweepResult
           
            if pt.y < 0 then
                tbcon:slideToPosition(0.15, 0, -pt.y, 1,"actionPlaying")
            else
                self:actionPlaying()
            end
        end
        element:disableSchedule()
    end

    if self.m_nCurrendIndex  >= self.m_nCreateCellSweep then
        element:disableSchedule()
        GetElement(self.m_root, "tbcon_WndSweepResult", WZUITableContainer):setTouchEnable(true)
        DelayCallFunction(function (luaObj,...)
            if luaObj.m_root ~= nil then
                luaObj:_showCompleteAnimation()
            end
        end,self,0.2)
    end
    self.m_nCurrendIndex = self.m_nCurrendIndex + 1
end

--@brief	完成动画播完后的回调
function WndSweepResult:completeAnimationFinished()
    WZLog("WndSweepResult:completeAnimationFinished")
    local imgComplete = GetElement(self.m_root, "imgComplete_WndSweepResult")
    imgComplete:setVisible(false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndSweepResult:_initUI()
    WZLog("WndSweepResult:_initUI")
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    self:_initExp()
    
    local tbcon = GetElement(self.m_root, "tbcon_WndSweepResult", WZUITableContainer)
    tbcon:cleanTable()
    tbcon:setTouchEnable(false)
    for i,v in ipairs(self.m_tRewardList) do
        local cellSweepResult = self:_createCellSweepResult(self.m_nCreateCellSweep)
        tbcon:setCellElement(cellSweepResult)
        self.m_nCreateCellSweep = self.m_nCreateCellSweep + 1
    end
    
    self.m_nCurrendIndex = 0

    if self.m_tData.flopId then
        GetElement(self.m_root,"conClose_WndSweepResult",WZUIContainer):setVisible(false)
    end
    self.m_root:enableSchedule("scheduleUpdate",0)

    local txtWinTitle = GetElement(self.m_root, "txtWinTitle_WndSweepResult", WZUILabelTTF)
    if self.m_nWinType == 1 then 
        txtWinTitle:setTextKey("HEROTOWER_TEXT9")
    elseif self.m_nWinType == 2 then
        txtWinTitle:setTextKey("WIPE_OUT")
    end
end


--@brief    初始化经验值UI
function WndSweepResult:_initExp()
    local tPlayerInfo = CacheCenter:getPlayerInfo()
    
    local txtLevel = GetElement(self.m_root, "txtLevel_WndSweepResult", WZUILabelTTF)
    txtLevel:setText("Lv"..tPlayerInfo.level)
    
    local prgExp = GetElement(self.m_root, "prgExp_WndSweepResult", WZUIProgress)
    prgExp:setPercentage(math.min(100, tPlayerInfo.exp*100/tPlayerInfo.maxExp))
    
    local txtExp = GetElement(self.m_root, "txtExp_WndSweepResult", WZUILabelTTF)
    txtExp:setText(tPlayerInfo.exp.."/"..tPlayerInfo.maxExp)
end

--@brief    创建一行扫荡结果
--@param    nIndex，序号
function WndSweepResult:_createCellSweepResult(nIndex)
    local cellSweepResult = CreateElement("CellSweepResult_WndSweepResult")
    cellSweepResult:setTag(nIndex)
    local sIndex = string.format(LocalStrings.SWEEP_INDEX, nIndex+1)
    if self.m_nWinType == 2 then
        if not self.m_nClearIndexCount then
            self.m_nClearIndexCount = 1
            self.level_index = 1
        end
        sIndex = string.format(LocalStrings.SWEEP_INDEX, self.level_index)

        self.level_index = self.level_index + 1
        if self.m_tData.raidsNum[self.m_nClearIndexCount] then
            if self.level_index > self.m_tData.raidsNum[self.m_nClearIndexCount] then
                self.level_index = 1
                self.m_nClearIndexCount = self.m_nClearIndexCount + 1
            end
        end       
    end
    local txtIndex = GetElement(cellSweepResult, "txtIndex_CellSweepResult", WZUILabelTTF)
    txtIndex:setText(sIndex)

    local tRewardList = self.m_tRewardList[nIndex+1]
    local levelName = GetElement(cellSweepResult, "levelName", WZUIFreeTextBox)
    if self.m_nWinType == 2 then
        txtIndex:setRelativePosition(GlobalMethod:ccp(0.844, 0.825))
        levelName:setRelativePosition(GlobalMethod:ccp(0.02, 1.230))
        if tRewardList and tRewardList.level_id then
            local config = GDatatab_single_map["id_"..tRewardList.level_id]
            local map_name = {LocalStrings.CARD_TEXT23, LocalStrings.CARD_TEXT24, LocalStrings.CARD_TEXT25, LocalStrings.CARD_TEXT37}
            if config then
                local str = string.format([[<T C="158,0,0" S="20" P="0">%s %s %s</T>]],config.section_name, map_name[config.map_type], config.map_name)
                levelName:setShowText(str)
            end
        end
    end

    self.m_nCreateCellItemCount = #tRewardList
    for i,v in ipairs(tRewardList) do
        if i <= 5 then
            local conCell = GetElement(cellSweepResult,"con"..i.."_CellSweepResult",WZUIContainer)
            local eItem, tItem = self:_createCellGoodItem(v.rewardId, v.rewardCount)
            conCell:addChild(eItem)
            conCell:setScale(0)
        end
    end
    
    return cellSweepResult
end

--@brief    创建一个物品格子
--@param    nItemId,物品id
--@param    nCount,数量
function WndSweepResult:_createCellGoodItem(nItemId, nCount)
    WZLog("WndSweepResult:_createCellGoodItem")
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.9)
    tItem:setItemClickFun(self, self.onClickItem)
    local tData = {
        id = nItemId,
        lastNum = nCount,
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(nItemId)
    }
    tItem:setCellGoodItem(tData,4)
    return eItem, tItem
end

--@brief    增加扫荡结果单元格的出现动画
--@param    cell,扫荡结果单元格
function WndSweepResult:_addDisplayAnimation(cell)
    WZLog("WndSweepResult:_addDisplayAnimation")
    if cell == nil then
        return
    end
    cell:setVisible(true)
end

--@brief    显示扫荡完成动画
function WndSweepResult:_showCompleteAnimation()
    WZLog("WndSweepResult:_showCompleteAnimation =",self.m_tData.flopId)
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS2)
    self.m_oImage = GetElement(self.m_root, "imgComplete_WndSweepResult")
    if  self.m_oImage ~= nil then
        self.m_oImage:setVisible(true)
        self.m_oImage:enableSchedule("completeAnimationFinished",1)
        self.m_bSweepFlag = true
    end
    if self.m_tData.flopId then
        self.m_oImage:enableSchedule("jumpToFlopCard",1.2)
    end
end

function WndSweepResult:jumpToFlopCard(element)
    WZLog("WndSweepResult:jumpToFlopCard")
    element:disableSchedule()
    replaceScene(SceneFlopCard:createElement())
    if SceneMarryCopy.m_root then 
        SceneFlopCard.m_bIsMarryCopy = true
        SceneFlopCard.m_tMarryCopyRoomInfo = {}
        local roomId, _ =SceneMarryCopy:getLoveIdAndRoomId()
        SceneFlopCard.m_tMarryCopyRoomInfo.roomId = roomId
        SceneFlopCard.m_tMarryCopyRoomInfo.roomSeat = SceneMarryCopy:_getPlayerSeat()
    end
    SceneFlopCard:setFlopCardItem(self.m_tData.flopId, self.m_tData.flopCount, self.m_tData.sweepTimes, self.m_tData.flopRebate)
end

-------------------------------------私有方法模块End----------------------------------------
