--WndDigGemData.lua
--@brief	WndDigGem的数据模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统界面

WndDigGem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDigGem:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nTabIndex = 0
    self.m_tBagList = nil               --背包中宝物
    self.m_tLogList = nil               --日志
    self.m_nMaxNum = 15                 --背包最大容量
    self.m_bIsStart = false             --是否开始挖宝
    self.m_nMyLevel = nil               --当前熟练等级
    self.m_nCurExp = nil                --当前经验
    self.m_nCurMaxExp = nil             --当前升级经验
    self.m_tCellGridList = nil              --背包格子
    self.m_nLoadingId = nil 
    self.m_nToolLeftTime = nil          --所使用的工具剩余的时间
    self.m_nTempSeconds = 0            
    self.m_tUseToolData = nil           --选择的工具数据 
    self.m_nUseToolIndex = 0            --使用的工具索引
    self.m_nOperateType = nil           --操作类型：1->进界面获取数据；2->停止挖宝；3->开始挖宝；4->购买工具；5->挖到宝物；6->工具使用时间用完；7->从交易行返回后，刷新背包
    self.m_tToolList = nil              --工具数据
    self.m_nNextStartTime = nil         --下次挖到宝石的时间
    self.m_tTempBagData = nil           --保存挖到宝物前的数据
    self.m_nBuyGemCoinTimes = nil       --当天已购买矿晶次数
    self.m_tClickGemInfo = nil          --背包中点击的宝物的信息
    self.m_tOriginPosition = nil        --挖到的粒子的位置
    self.m_tTargetPosition = nil        --挖到的粒子飞到的位置
    self.m_nDigGemGoodId = nil          --挖到的宝物的Id
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndDigGem:_unInit()
    self.m_root = nil
    self.m_nTabIndex = nil 
    self.m_tBagList = nil
    self.m_tLogList = nil               
    self.m_nMaxNum = nil 
    self.m_bIsStart = nil
    self.m_nMyLevel = nil               --当前熟练等级
    self.m_nCurExp = nil                --当前经验 
    self.m_nCurMaxExp = nil             --当前升级经验
    self.m_tCellGridList = nil              --背包格子
    self.m_nLoadingId = nil 
    self.m_nToolLeftTime = nil
    self.m_nTempSeconds = nil 
    self.m_tUseToolData = nil 
    self.m_nUseToolIndex = nil            --使用的工具索引
    self.m_nOperateType = nil
    self.m_tToolList = nil              --工具数据
    self.m_nNextStartTime = nil 
    self.m_tTempBagData = nil
    self.m_nBuyGemCoinTimes = nil
    self.m_tClickGemInfo = nil          --背包中点击的宝物的信息
    self.m_tOriginPosition = nil
    self.m_tTargetPosition = nil        --挖到的粒子飞到的位置
    self.m_nDigGemGoodId = nil          --挖到的宝物的Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDigGem:createElement()
	local element = WZUISystem:getInstance():createElement("WndDigGem")
	assert(element, "WndDigGem create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndDigGem:showInterface()
    -- body
    if CheckButtonOpen(114) then
        local wndDigGem = WndDigGem:createElement()
        if wndDigGem then
            WindowManager:addWindow(wndDigGem, WndDigGem, nil, nil, nil, true)
        end
    end
end

--@brief    鉴定外部接口
function WndDigGem:showAppraiseInterface()
    -- body
    if CheckButtonOpen(114) then
        if WndDigGem.m_root == nil then
            local wndDigGem = WndDigGem:createElement()
            if wndDigGem then
                WindowManager:addWindow(wndDigGem, WndDigGem, nil, nil, nil, true)
            end
        end

        WndGemAppraise:showInterface()
    end
end

--@brief    交易行外部接口
function WndDigGem:showTransactionInterface()
    -- body
    if CheckButtonOpen(114) then
        if WndDigGem.m_root == nil then
            local wndDigGem = WndDigGem:createElement()
            if wndDigGem then
                WindowManager:addWindow(wndDigGem, WndDigGem, nil, nil, nil, true)
            end
        end

        WndTransaction:show()
    end
end

--@brief    设置数据
function WndDigGem:setData(useTool, remainTime, level, exp, toolId, remainToolTime, item, num, toolTime, buyGemCoinTimes)
    -- body
    WZLog("WndDigGem:setData", remainTime, useTool, toolTime, buyGemCoinTimes)
    self:_stopLoading()
    if self.m_nOperateType == 7 then
        --回收，上架，下架成功后刷新背包数据
        self:updateGemBag(VectorToTable(item), VectorToTable(num))
        self.m_nOperateType = nil 
        return 
    end
    --工具数据
    self:setToolData(toolId, remainToolTime)

    if useTool ~= 0 then
        self.m_bIsStart = true 
        self:_showBtnText(LocalStrings.DIGGEM_TEXT5)
        self.m_nUseToolIndex = useTool
        --挂机重新进来的时候，self.m_tUseToolData数据为空
        if self.m_tUseToolData == nil then
            self.m_tUseToolData = self.m_tToolList[useTool]
        end
    else
        self.m_bIsStart = false 
        self:_showBtnText(LocalStrings.DIGGEM_TEXT4)
        self.m_nUseToolIndex = 0
    end
    --计算变化的物品
    local tDigGemData 
    if self.m_nOperateType == 5 then
        tDigGemData = self:_getDigGemData(level, item, num)
    end

    self:resetBagData(item, num)
    if self.m_nOperateType == 5 and #self.m_tBagList == self.m_nMaxNum then
        self:_stopDigDemToDealWith(3)
    end
    self.m_nMyLevel = level               
    self.m_nCurExp = exp                
    self.m_nCurMaxExp = self:_getCurLevelMaxExp(self.m_nMyLevel)
    self.m_nToolLeftTime = toolTime
    self.m_nNextStartTime = remainTime
    self.m_nBuyGemCoinTimes = buyGemCoinTimes
    
    if self.m_nOperateType == 2 then        --停止挖宝
        self:_stopDigDemToDealWith(2)
    elseif self.m_nOperateType == 3 then    --使用工具，开始挖宝
        if WndGemTool.m_root then
            WindowManager:removeWindow(WndGemTool.m_root, WndGemTool, true)
        end
        self:startToDigGem(self.m_nToolLeftTime, self.m_nUseToolIndex)
    elseif self.m_nOperateType == 4 then    --购买工具
        MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
		SoundManager:playEffectSound(SoundDefine.E_S_KILL_GOUMAICHENGGONG)
        if WndGemTool.m_root then
            WndGemTool:setData(self.m_tToolList)
        end
    elseif self.m_nOperateType == 5 then    --挖到宝物
        --弹挖到物品tips
        WZLog("WndDigGem:setData *******", Serialize(tDigGemData))
        self.m_nDigGemGoodId = nil 
        if tDigGemData then
            --熟练度升级了
            if tDigGemData.curLevel ~= nil then
                --播放熟练度升级特效
                MsgBoxManager:showTipBox(string.format(LocalStrings.DIGGEM_TEXT13, tDigGemData.curLevel))
            end
            if tDigGemData.id ~= nil then
                self.m_nDigGemGoodId = tDigGemData.id
                --弹挖到宝物提示
                local basicInfo = GDatatab_item["id_" .. tDigGemData.id]
                local sTipsForhead = {LocalStrings.DIGGEM_TEXT25, LocalStrings.DIGGEM_TEXT26, LocalStrings.DIGGEM_TEXT28, LocalStrings.DIGGEM_TEXT29}
                MsgBoxManager:showTipBox(string.format(sTipsForhead[basicInfo.quality] .. LocalStrings.DIGGEM_TEXT30, basicInfo.name, tDigGemData.addExp))
            end
        end
        --播放特效
        self:_displayDigGemParticle()
    elseif self.m_nOperateType == 6 then

    else
        self:_setStaticText()
        self:_updateRightContent()
        self:_showDigGemAni(self.m_nUseToolIndex)
    end

    self.m_nOperateType = nil 
end

--@brief    设置日志数据
function WndDigGem:setLogData(logtype, time, itemId, miningExp, miningLevel)
    -- body
    self.m_tLogList = {}
    self:_stopLoading()
    WZLog("WndDigGem:setLogData", #logtype, Serialize(itemId))
    for i = 1, #logtype do
        local tItem = {}
        local sTempDay = os.date("*t",tonumber(time[i]))
        tItem.time = string.format("%d-%02d-%02d %02d:%02d:%02d", tonumber(sTempDay.year), tonumber(sTempDay.month), tonumber(sTempDay.day), tonumber(sTempDay.hour), tonumber(sTempDay.min), tonumber(sTempDay.sec)) 
        tItem.type = logtype[i]
        if logtype[i] == 1 then
            local toolInfo = GDatatab_tool["id_" .. itemId[i]]
            tItem.name = toolInfo.tool_name
        elseif logtype[i] == 5 then
            local gemInfo = GDatatab_item["id_" .. itemId[i]]
            tItem.name = gemInfo.name
        else
            tItem.name = ""
        end
        tItem.addExp = miningExp[i] 
        tItem.level = miningLevel[i] 
        tItem.seconds = tonumber(time[i])

        table.insert(self.m_tLogList, tItem)
    end
    table.sort(self.m_tLogList, function (a,b)
        -- body
        return a.seconds > b.seconds
    end)
    if self.m_nTabIndex ~= 1 then return end

    self:_updateRightContent()
end

--@brief    刷新背包数据
function WndDigGem:resetBagData(item, num)
    -- body
    self.m_tBagList = {}
    self.m_tTempBagData = {}
    for i = 1, #item do
        local nTemuNum = num[i]
        local basicInfo = GDatatab_item["id_" .. item[i]]
        while nTemuNum > 0 do
            local tItem = {}
            tItem.name = basicInfo.name 
            tItem.icon = basicInfo.icon
            tItem.id = item[i]
            if nTemuNum > basicInfo.stack then
                tItem.lastNum = basicInfo.stack
                tItem.lastTime = basicInfo.stack

                nTemuNum = nTemuNum - basicInfo.stack
            else
                tItem.lastNum = nTemuNum
                tItem.lastTime = nTemuNum

                nTemuNum = 0
            end
            tItem.quality = basicInfo.quality
            tItem.basicInfo = CopyTable(basicInfo)
            
            table.insert(self.m_tBagList, tItem)
        end
        --
        local tempItem = {}
        tempItem.id = item[i]
        tempItem.lastNum = num[i]
        table.insert(self.m_tTempBagData, tempItem)
    end

    table.sort(self.m_tBagList, function (a,b)
        -- body
        if a.id ~= b.id then
            return a.id > b.id
        else
            return a.lastNum > b.lastNum 
        end
    end)
end

--@brief    开始挖宝
--@param    leftTime：该工具的剩余时间
--@param    nIndex: 动画索引
function WndDigGem:startToDigGem(leftTime, nIndex)
    -- body
    self.m_bIsStart = true
    --弹开始挖宝tips
    if self.m_tUseToolData then
        MsgBoxManager:showTipBox(string.format(LocalStrings.DIGGEM_TEXT9, self.m_tUseToolData.tool_name))
    end
    -- 改变按钮字
    self:_showBtnText(LocalStrings.DIGGEM_TEXT5)
    --显示挖宝剩余时间
    self.m_nToolLeftTime = leftTime
    self:_setStaticText()
    --显示挖宝动画
    self:_showDigGemAni(nIndex)
end

--@brief    购买矿晶成功
function WndDigGem:buyGemCoinOK(buyGemCoinTimes)
    -- body
    self.m_nBuyGemCoinTimes = buyGemCoinTimes
    WndBuyActivity:setBuyResultData(TableToVector(WndBuyActivity.m_tResultAddNum,WZLuaVector_int_), TableToVector({1,1,1,1,1},WZLuaVector_int_), 13, nil, buyGemCoinTimes)
end

--@brief    设置工具数据
function WndDigGem:setToolData(toolId, remainToolTime)
    -- body
    self.m_tToolList = {}
    for j, value in pairs(GDatatab_tool) do
        local tItem = {}
        tItem.id = value.id
        tItem.tool_name = value.tool_name
        tItem.tool_icon = value.tool_icon
        tItem.buy_price = value.buy_price
        tItem.time = value.time
        tItem.efficiency = value.efficiency
        tItem.add_proficiency = value.add_proficiency
        local bHaveLeftTime = false 
        for k = 1, #toolId do
            if toolId[k] == value.id then
                tItem.leftTime = remainToolTime[k]
                bHaveLeftTime = true
                break 
            end
        end
        if not bHaveLeftTime then
            tItem.leftTime = 0
        end
        table.insert(self.m_tToolList, tItem)
    end

    table.sort(self.m_tToolList, function (a,b)
        -- body
        return a.id < b.id
    end)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndDigGem:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndDigGem:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief    找出挖宝成功后增加的数据
function WndDigGem:_getDigGemData(level, item, num)
    -- body
    local tTempItem = {}

    for i = 1, #item do
        local bFound = false 
        for j = 1, #self.m_tTempBagData do
            if self.m_tTempBagData[j].id == item[i] then
                if self.m_tTempBagData[j].lastNum < num[i] then
                    bFound = true
                    tTempItem.id = item[i]
                    tTempItem.addNum = num[i] - self.m_tTempBagData[j].lastNum
                    break 
                end
            end
        end
        if bFound then
            break 
        else
            if #self.m_tTempBagData == 0 then
                tTempItem.id = item[i]
                tTempItem.addNum = num[i]
                break 
            end
        end
    end
    
    if self.m_nOperateType ~= nil and self.m_nOperateType == 5 then
        if self.m_tUseToolData then
            tTempItem.addExp = self.m_tUseToolData.add_proficiency
        else
            tTempItem.addExp = GDatatab_tool["id_" .. self.m_nUseToolIndex].add_proficiency
        end
    end
    if self.m_nMyLevel ~= nil and self.m_nMyLevel < level then
        tTempItem.curLevel = level 
    end

    return tTempItem
end

--@brief    获取当前可购买的最大次数
function WndDigGem:getBuyData(nType)
    -- body
    local nMaxCount = 0
    local tMaxIndex = nil
    local tCurIndex = nil 
    local nVipLevel = CacheCenter:getPlayerInfo().vipLevel

    for k, v in pairs(GDatatab_vip_restriction) do 
        if v.type == nType and v.vip_level <= nVipLevel then 
            if v.count > nMaxCount and (tMaxIndex == nil or tMaxIndex.vip_level <= v.vip_level) then
                nMaxCount = v.count 
                tMaxIndex = { id = v.id, ntype = v.type, parameter = v.parameter, vip_level = v.vip_level, count = v.count, cost = v.cost,result = v.result}
            end
        end
        if v.type == nType and v.count - 1 == self.m_nBuyGemCoinTimes then 
            tCurIndex = { id = v.id, ntype = v.type, parameter = v.parameter, vip_level = v.vip_level, count = v.count, cost = v.cost,result = v.result}
        end
    end

    if self.m_nBuyGemCoinTimes == nMaxCount then
        tCurIndex = tMaxIndex
    end

    return nMaxCount, tCurIndex
end

--@brief    获取熟练度升级所需经验
function WndDigGem:_getCurLevelMaxExp(nLevel)
    -- body
    local nCurMaxExp = 0
    for i, value in pairs(GDatatab_proficiency) do
        if value.level == nLevel + 1 then
            nCurMaxExp = value.proficiency
            return nCurMaxExp
        end
    end

    for i, value in pairs(GDatatab_proficiency) do
        if value.level == nLevel then
            nCurMaxExp = value.proficiency
            break 
        end
    end

    return nCurMaxExp
end

--@brief    挖到宝物的特效
function WndDigGem:_displayDigGemParticle()
    -- body
    WZLog("WndDigGem:_displayDigGemParticle")
    local particleGetGem = GetElement(self.m_root, "particleGetGem_WndDigGem", WZUIParticle)
    if particleGetGem then
        particleGetGem:setVisible(true)

        local sequence = WZUIActionSequence:create()

        local delayAni = WZUIActionDelayTime:create()
        delayAni:setDuration(0.5)
        --显示获得的物品图标
        local functionAni1 = WZUIActionCallLuaFunction:create()
        functionAni1:setLuaFunction("_createGemItem")
        --
        local delayAni2 = WZUIActionDelayTime:create()
        delayAni2:setDuration(0.8)
        --移除物品图标
        local functionAni2 = WZUIActionCallLuaFunction:create()
        functionAni2:setLuaFunction("_createGemItem")
        --
        local delayAni3 = WZUIActionDelayTime:create()
        delayAni3:setDuration(0.5)

        local moveTo = WZUIActionMoveTo:create()
        moveTo:setMoveX(self.m_tTargetPosition.x)
        moveTo:setMoveY(self.m_tTargetPosition.y)
        moveTo:setDuration(0.5)

        local functionAni = WZUIActionCallLuaFunction:create()
        functionAni:setLuaFunction("_afterParticle")

        sequence:setChildAction(delayAni)
        sequence:setChildAction(functionAni1)
        sequence:setChildAction(delayAni2)
        sequence:setChildAction(functionAni2)
        sequence:setChildAction(delayAni3)
        sequence:setChildAction(moveTo)
        sequence:setChildAction(functionAni)

        particleGetGem:runUIAction(sequence)
    end
end

--@brief    特效不放完成后的回调
function WndDigGem:_afterParticle()
    -- body
    --熟练度
    self:_showExp()
    self:_updateRightContent()
    self:_resetParticleState()
end

--@brief    粒子效果播放完成以后，回复原来状态
function WndDigGem:_resetParticleState()
    -- body
    local particleGetGem = GetElement(self.m_root, "particleGetGem_WndDigGem", WZUIParticle)
    if particleGetGem then
        particleGetGem:setVisible(false)
        particleGetGem:setRelativePosition(self.m_tOriginPosition)
    end
end

--@brief    创建获得的宝物
function WndDigGem:_createGemItem()
    -- body
    local conOutside = GetElement(self.m_root, "conOutside_WndDigGem", WZUIContainer)
    if conOutside then
        if self.m_nDigGemGoodId then
            local celElement, tNewObj = CellGoodItem:createElement()
            if celElement and tNewObj then
                tNewObj:setCellGoodLocalId(self.m_nDigGemGoodId, 0, 4)
                conOutside:addChild(celElement, 2, 299)
                celElement:setRelativePosition(self.m_tOriginPosition)
            end

            self.m_nDigGemGoodId = nil 
            return 
        end

        if conOutside:getChildByTag(299) then
            conOutside:removeChildByTag(299, true)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
