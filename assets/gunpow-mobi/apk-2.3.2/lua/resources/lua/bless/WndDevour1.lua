--WndDevour1.lua
--@brief	WndDevour1的UI模块
--@date		2021/04/21
--@author	hyc
--@note		祈福吞噬


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDevour1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDevour1:onExit(element)
	self:_unInit()
end

function WndDevour1:_update(prayId)
	-- body
	local tabBless = GetElement(self.m_root,"tabBless_WndDevour1",WZUITableContainer)
	tabBless:cleanTable()
	self.m_tBlessList = {}
	for i = 1,#self.m_tDevourList do
		local cellElement,cellObj = CellBlessItem:createElement()
		if cellElement and cellObj then
			cellObj:setData(self.m_tDevourList[i],6)
			cellElement:setTag(i -1)
			cellObj:setDevourCallBackFun(self, self.onClickBlessItem)
			table.insert( self.m_tBlessList, cellObj )
			tabBless:setCellElement(cellElement)
		end
	end
	self:updateExpTxt(prayId)

end

--@brief 更新可获得经验
function WndDevour1:updateExpTxt(prayId)
	-- body
    local nMaxLevel = self:_getMaxLevel(self.m_tData.item_id)
    local nCurExp = self.m_tData.curExp
    if self.m_tData.level == nMaxLevel then
        nCurExp = self.m_tData.total_exp
    end
    --经验
    local isMaxLv = false
    local showExp = 0

    if prayId then
        local updateLv = GDatatab_pray["id_"..prayId].level
        
        if updateLv == nMaxLevel then
            isMaxLv = true
            showExp = GDatatab_pray["id_"..(prayId-1)].total_exp
        end
    end
    local txtExp = GetElement(self.m_root, "txtExp_WndDevour1", WZUILabelTTF)
    if isMaxLv then
        txtExp:setText(showExp .. "/" .. showExp)
    else 
        txtExp:setText(nCurExp .. "/" .. self.m_tData.total_exp)
    end
    --经验条
    local progExp = GetElement(self.m_root, "proExp_WndDevour1", WZUIProgress)
    local nPercent = math.floor(100 * nCurExp/self.m_tData.total_exp)
    progExp:setPercentage(nPercent)

    local expTxt = GetElement(self.m_root,"txtAvailableExp_WndDevour1",WZUILabelTTF)
    expTxt:setText(string.format(LocalStrings.BLESS_UPGRADE,self.m_nTotalExp))
end

--@brief 点击祈福珠回调
function WndDevour1:onClickBlessItem(tData,tCell)
	-- body
    if tData.bIsChoose == true then
        local nPreLevel = self.m_tData.level + self:_caculateUpgradeLv(self.m_nTotalExp)
        if nPreLevel >= self:_getMaxLevel(self.m_tData.item_id) then
            tCell:setConGouVisible(false) 
            MsgBoxManager:showTipBox(LocalStrings.ENOUGH_TO_DEVOUR)
        else
            tCell:setConGouVisible(tData.bIsChoose) 
            table.insert(self.m_tChooseList, tData)
            self.m_nTotalExp = self.m_nTotalExp + self:_getUseExp(tData)
            self:updateExpTxt()
        end
    elseif tData.bIsChoose == false then
        for i = 1, #self.m_tChooseList do
            if self.m_tChooseList[i].blessId == tData.blessId then
                tCell:setConGouVisible(tData.bIsChoose) 
                self.m_nTotalExp = self.m_nTotalExp - self:_getUseExp(self.m_tChooseList[i])
                table.remove(self.m_tChooseList, i)
                self:updateExpTxt()
                break
            end
        end
    end
end

--@brief    获取当前类型的祝福最高等级
function WndDevour1:_getMaxLevel(itemId)
    -- body
    local nLevel = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level > nLevel then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief    根据总可用经验，计算可以提升的等级
--@param    可用于升级的经验
function WndDevour1:_caculateUpgradeLv(nCanUseExp)
    -- body
    local tData = self.m_tData
    local nRiseLevel = 0 
    local nTotalExp = nCanUseExp + tData.curExp
    --获取下一等级的数据
    local tDataNext = self:_getNextData(tData, 1)
    -- WZLog("WndDevour:_caculateUpgradeLv", nCanUseExp, tData.curExp, Serialize(tDataNext))
    if tDataNext == nil then return end

    local nNeedExp = tData.total_exp

    while nTotalExp >= nNeedExp do
        nRiseLevel = nRiseLevel + 1
        nTotalExp = nTotalExp - nNeedExp

        nNeedExp = tDataNext.total_exp
        tDataNext = self:_getNextData(tDataNext, 1)
        if tDataNext == nil then 
            break 
        end
    end

    return nRiseLevel
end

--@brief    获取同一类型的祝福下一等级的数据
--@param    tData: 当前等级数据
--@param    nRiseLevel : 当前等级+nRiseLevel
function WndDevour1:_getNextData(tData, nRiseLevel)
    -- body
    if tData.level >= self:_getMaxLevel(tData.item_id) then
        return nil
    end

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == tData.item_id and value.level == tData.level + nRiseLevel then
            return value
        end
    end

    return nil
end

--@brief 快速选择
function WndDevour1:onClickQuickChoose(element)
	-- body

    local tData = self.m_tData
    local tDevourList = self:_generalDevourList()
	if self.m_tChooseList == {} then
		self.m_nTotalExp = 0
	end
    --没有可吞噬的祝福
    if #tDevourList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TO_DEVOUR)
        return
    end
    --已经是最高级，不能再吞噬了
    if tData.level >= self:_getMaxLevel(tData.item_id) then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_LEVEL_MAX)
        return
    end
    for i = 1, #tDevourList do
        --屏蔽掉那些已经选择的
        if tDevourList[i].bIsChoose == false and (tDevourList[i].basicInfo.sub_type == 32 or (tDevourList[i].basicInfo.sub_type ~= 32 and tDevourList[i].basicInfo.quality < 3)) then
            local nPreLevel = tData.level + self:_caculateUpgradeLv(self.m_nTotalExp)
            if nPreLevel >= self:_getMaxLevel(tData.item_id) then
                break
            else
                self.m_tDevourList[i].bIsChoose = true
                tDevourList[i].bIsChoose = true
                table.insert(self.m_tChooseList, tDevourList[i])
                self.m_nTotalExp = self.m_nTotalExp + self:_getUseExp(tDevourList[i])
                self:updateExpTxt()
            end
        end
    end
    for k = 1, #self.m_tChooseList do
        for j = 1, #self.m_tBlessList do
            local tCellData = self.m_tBlessList[j]:getData()
            if tCellData then
                if self.m_tChooseList[k].blessId == tCellData.blessId then
                    self.m_tBlessList[j]:setConGouVisible(self.m_tChooseList[k].bIsChoose)
                    break
                end
            end
        end
    end    
end

--@brief    获取某个祝福可用于吞噬的经验
function WndDevour1:_getUseExp(tData)
    -- body
    local nTempExp = 0 
    local tTempList = {}
    for i, value in pairs(GDatatab_pray) do
        if value.item_id == tData.item_id then
            table.insert(tTempList, value)
        end
    end

    table.sort(tTempList, function (a, b) return a.level < b.level end )

    for i = 1, #tTempList do
        if tTempList[i].level < tData.level then
            nTempExp = nTempExp + tTempList[i].total_exp
        elseif tTempList[i].level == tData.level then
            nTempExp = nTempExp + tTempList[i].exp + tData.curExp
        else
            break
        end
    end

    return nTempExp
end

--@brief     二次筛选可用于吞噬掉的祝福
function WndDevour1:_generalDevourList()
    -- body
    local tData = self.m_tData

    local tTemp = {}
    for i = 1, #self.m_tDevourList do
        if self.m_tDevourList[i].basicInfo.sub_type == 32 or tData.quality >= self.m_tDevourList[i].quality then
            table.insert(tTemp, self.m_tDevourList[i])
        end
    end

    return tTemp
end

--@brief 关闭
function WndDevour1:onClickClose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 吞噬
function WndDevour1:onClickUpgrade(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_tChooseList == {} or #self.m_tChooseList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_CHOOSE_NIL)
        return
    end
    -- WZLog("WndDevour:onClickSureChoose 11111", #self.m_tChooseList)
    --发送吞噬协议吞噬选中的祝福
    local vBeDevourId = WZLuaVector_int_:create()
    for i = 1, #self.m_tChooseList do
        vBeDevourId:push(self.m_tChooseList[i].blessId)
    end
    -- WZLog("WndDevour:onClickSureChoose 22222")
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Devour(self.m_tData.userType, self.m_tData.blessId, vBeDevourId)
end

--@brief    数据加载动画
function WndDevour1:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    加载动画停止
function WndDevour1:_stopLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end

--@brief    吞噬成功后的处理
function WndDevour1:onceDevourOk(devourId, exp, prayId, ids, fighting)
    --body
    --清理掉已经被吞噬掉的祝福（包括当前界面和来源界面（祈福屋或背包））
    WZLog("WndDevour:onceDevourOk")
    self.m_tChooseList = {}
    self.m_nTotalExp = 0
    --清掉被吞噬的祝福
    self:_cleanBeDevourBless(ids)
    --更新吞噬的祝福的信息数据（包括当前和来源）
    self:_updateTheBlessItemInfo(devourId, exp, prayId)
    --如果操作的是装备栏的祝福    
    self:_stopLoading()
end

--@brief    清除掉被吞噬的祝福
--param     tBeDevourBless: 被吞噬掉的祝福的Id
function WndDevour1:_cleanBeDevourBless(tBeDevourIds)
    -- body
    --移除可吞噬列表中已经被吞噬的祝福
    for i = 1, #tBeDevourIds do
        for j = 1, #self.m_tDevourList do
            if self.m_tDevourList[j].blessId == tBeDevourIds[i] then
                table.remove(self.m_tDevourList, j)
                break
            end
        end
    end
    --移除来源处的相应祝福
    WndBlessBag:cleanBeDevourBless(tBeDevourIds)
end

--@brief    更新吞噬后，节点的数据更新显示
function WndDevour1:_updateTheBlessItemInfo(devourId, exp, prayId)
    -- body
    if self.m_tData.blessId == devourId then
        local tData =  CopyTable(GDatatab_pray["id_"..prayId])
        tData.basicInfo = self.m_tData.basicInfo
        tData.userType = self.m_tData.userType
        tData.blessId = self.m_tData.blessId
        tData.curExp = exp
		tData.name = tData.basicInfo.name

        self.m_tData = tData
        local nMaxLevel = self:_getMaxLevel(tData.item_id)
        local nCurExp = tData.curExp
        local nTotalExp = tData.total_exp
        if tData.level == nMaxLevel then
            local nTempId = self:_getSecondMaxLevel(nMaxLevel, tData.item_id)
            local tTempData = GDatatab_pray["id_"..nTempId]
            nCurExp = tTempData.total_exp
            nTotalExp = tTempData.total_exp
        end
        -- --经验
        -- local txtExp = GetElement(self.m_root, "txtExp_WndDevour1", WZUILabelTTF)
        -- txtExp:setText(nCurExp .. "/" .. nTotalExp)
        -- --经验条
        -- local progExp = GetElement(self.m_root, "proExp_WndDevour1", WZUIProgress)
        -- local nPercent = math.floor(100 * nCurExp/nTotalExp)
        -- progExp:setPercentage(nPercent)
        self:_update(prayId)
        --更新来源处的相应祝福
        WndBlessBag:updateTheBlessItemInfo(tData)
    end

end

--@brief    获取当前类型的祝福的第二高等级的id
function WndDevour1:_getSecondMaxLevel(nMaxLevel, itemId)
    -- body
    local id = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level == nMaxLevel - 1 then
            id = value.id
        end
    end

    return id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
