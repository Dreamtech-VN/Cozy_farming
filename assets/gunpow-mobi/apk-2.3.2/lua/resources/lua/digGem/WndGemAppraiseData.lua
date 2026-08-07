--WndGemAppraiseData.lua
--@brief	WndGemAppraise的数据模块
--@date		2017/03/15
--@author	Tianxiang_Xu
--@note		宝物鉴定界面

WndGemAppraise = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGemAppraise:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tAppraiseList = nil          --待鉴定的物品以及数量
    self.m_nTotalCost = 0               --总共的鉴定费用
    self.m_tBagList = nil               --鉴定背包
    self.m_tCellList = nil  
    self.m_nClickItemTag = nil 
    self.m_tTempResult = nil            --保存鉴定完成后的结果
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndGemAppraise:_unInit()
    self.m_root = nil
    self.m_tAppraiseList = nil
    self.m_nTotalCost = nil 
    self.m_tBagList = nil
    self.m_tCellList = nil  
    self.m_nClickItemTag = nil 
    self.m_tTempResult = nil            --保存鉴定完成后的结果
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGemAppraise:createElement()
	local element = WZUISystem:getInstance():createElement("WndGemAppraise")
	assert(element, "WndGemAppraise create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndGemAppraise:showInterface()
    -- body
    local wndTemp = WndGemAppraise:createElement()
    if wndTemp then
        WindowManager:addWindow(wndTemp, WndGemAppraise, nil, nil, nil, true)
    end
end

--@brief    设置数据
function WndGemAppraise:setData(tBagList)
    -- body
    self.m_tAppraiseList = {}
    self.m_tAppraiseList[1] = {}
    self.m_tAppraiseList[2] = {}
    self.m_tAppraiseList[3] = {}
    self.m_tAppraiseList[4] = {}
    self.m_tAppraiseList[5] = {}
    self.m_tAppraiseList[6] = {}

    self.m_tBagList = CopyTable(tBagList)

    self:_update()
end

--@brief    设置特效可见
function WndGemAppraise:setSpineVisible(nIndex)
    -- body
    WZLog("WndGemAppraise:setSpineVisible", nIndex)
    local spine = GetElement(self.m_root, "spine" .. nIndex .. "_WndGemAppraise", WZUISpine)
    if spine then
        spine:setVisible(true)
        spine:play("stand", false)
    end
end

--@brief    设置特效不可见
function WndGemAppraise:setSpineUnVisible(nIndex)
    -- body
    WZLog("WndGemAppraise:setSpineUnVisible", nIndex)
    GetElement(self.m_root, "spine" .. nIndex .. "_WndGemAppraise", WZUISpine):setVisible(false)
end

--@brief    特效播放一半，情掉鉴定格的物品
function WndGemAppraise:_cleanAppgraiseGrid(nIndex)
    -- body
    --移出掉鉴定栏的宝物图标
    local conItem = GetElement(self.m_root, "conItem" .. nIndex .. "_WndGemAppraise", WZUIContainer)
    if conItem:getChildByTag(999) then
        conItem:removeChildByTag(999, true)
    end
    --清楚掉移出鉴定栏的数据
    self.m_tAppraiseList[nIndex] = {}
    self.m_nTotalCost = self:_caculateTotalCost()
    --刷新费用
    self:_updateCostNum()
end

--@brief    播放特效
function WndGemAppraise:displaySuccessSpine()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_KILL_JIANDING)
    
    local nTotalNum = #self.m_tAppraiseList - self:_getLeftGridNum()

    local nTempCaculate = 0 
    for i = 1, #self.m_tAppraiseList do
        local array = CCArray:create()
        if self.m_tAppraiseList[i].id ~= nil then
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineVisible(i)
            end))
            array:addObject(CCDelayTime:create(0.4))
            array:addObject(CCCallFuncN:create(function ()
                self:_cleanAppgraiseGrid(i)
            end))
            array:addObject(CCDelayTime:create(0.7))
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineUnVisible(i)
            end))
            nTempCaculate = nTempCaculate + 1
            if nTempCaculate == nTotalNum then
                array:addObject(CCCallFuncN:create(function ()
                    self:_onFinishActionBack()
                end))
            end
            local action = CCSequence:create(array)

            local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndGemAppraise", WZUIContainer)
            conItem:runAction(action)
        end
    end

    
end

--@brief    动画特效播放完了之后
function WndGemAppraise:_onFinishActionBack()
    -- body
    WZLog("WndGemAppraise:_onFinishActionBack")
    GetElement(self.m_root, "imgLimiteTouch_WndGemAppraise", WZUI9Image):setVisible(false)
    if self.m_tTempResult then
        WndRewardShow:showById(self.m_tTempResult.giveItemId, self.m_tTempResult.giveNum)
        --更新宝物背包数据
        self:_GetAppraiseRewardOk(self.m_tTempResult.item, self.m_tTempResult.num)
    end
end

--@brief    鉴定成功
function WndGemAppraise:appraiseOK(item, num, giveItemId, giveNum)
    -- body
    self.m_tTempResult = {}
    self.m_tTempResult.item = item
    self.m_tTempResult.num = num 
    self.m_tTempResult.giveItemId = giveItemId
    self.m_tTempResult.giveNum = giveNum
    --播放特效的时候，不让触摸
    GetElement(self.m_root, "imgLimiteTouch_WndGemAppraise", WZUI9Image):setVisible(true)

    self:displaySuccessSpine()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    计算鉴定费用
function WndGemAppraise:_caculateTotalCost()
    -- body
    local m_nTotalCost = 0 

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            local nCost = GDatatab_treasure["id_" .. self.m_tAppraiseList[i].id].appraisal_price[1][2]

            m_nTotalCost = m_nTotalCost + (nCost * self.m_tAppraiseList[i].num)
        end
    end

    return m_nTotalCost
end

--@brief    获取剩余的存放鉴定物品的格数
function WndGemAppraise:_getLeftGridNum()
    -- body
    local m_nLeftGridNum = 0 

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id == nil then
            m_nLeftGridNum = m_nLeftGridNum + 1
        end
    end

    return m_nLeftGridNum
end

--@brief    清掉鉴定栏数据
function WndGemAppraise:cleanAppraiseData()
    -- body
    for i = 1, #self.m_tAppraiseList do
        local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndGemAppraise", WZUIContainer)
        if conItem:getChildByTag(999) then
            conItem:removeChildByTag(999, true)
        end
        self.m_tAppraiseList[i] = {}
    end

    self.m_nTotalCost = 0
    --刷新费用
    self:_updateCostNum()
end

--@brief    刷新背包数据
function WndGemAppraise:_GetAppraiseRewardOk(item, num)
    -- body
    self.m_tBagList = {}
    --清除鉴定栏数据
    self:cleanAppraiseData()

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
    end

    table.sort(self.m_tBagList, function (a,b)
        -- body
        if a.id ~= b.id then
            return a.id > b.id
        else
            return a.lastNum > b.lastNum 
        end
    end)
    --
    self:_createBagList()
    --更新挖宝背包数据
    WndDigGem:updateGemBag(item, num)
end
-------------------------------------私有方法模块End----------------------------------------
