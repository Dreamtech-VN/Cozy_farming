--WndAthShop.lua
--@brief	WndAthShop的UI模块
--@date		2015/04/22
--@author	binshao
--@note		竞技场商店

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthShop:onEnter(element)
	self.m_root = element
    
end


--@brief onEnter函数执行完成回调
function WndAthShop:onEnterTransitionDidFinish(element)
    self:initShow()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthShop:onExit(element)
    self:_unInit()
end

--@brief	关闭整个窗口的动画效果
function WndAthShop:onClickSure(elem)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManager:removeWindow(self.m_root , WndAthShop , true)
end

--@brief    点击物品弹出对应的tips
function WndAthShop:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,WndAthShop.m_root,1,tData,false)
end

--@brief    选择奖励返回
function WndAthShop:chooseReturn(tag, index, status)
    if self.m_root == nil then return end 

    local tTempData = self.m_tRewardIdsData

    tTempData.chooseState[index] = status
    self.m_tClickCell:updateChooseStateData(status)
    if status == 0 then 
        self.m_tClickCell:setItemSelState(false)
    elseif status == 1 then 
        self.m_tClickCell:setItemSelState(true)

        self.m_tSelCell = self.m_tClickCell
    end
end

--@brief    自动取消上次选中的奖励（针对只能选中一个奖励的情况）
function WndAthShop:cancelLastChoose(tag, index, status)
    if self.m_root == nil then return end 

    local tTempData = self.m_tRewardIdsData

    tTempData.chooseState[index] = status
    self.m_tSelCell:updateChooseStateData(status)
    if status == 0 then 
        self.m_tSelCell:setItemSelState(false)
    elseif status == 1 then 
        self.m_tSelCell:setItemSelState(true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------
function WndAthShop:initShow()
    local img9Bg = GetElement(self.m_root,"img9Bg_WndAthShop",WZUI9Image)
    local img9SecBG = GetElement(self.m_root,"img9SecBG_WndAthShop",WZUI9Image)
    local btnSure = GetElement(self.m_root,"btnSure_WndAthShop",WZUIButton)
    local imgBtn = GetElement(self.m_root,"imgBtn_WndAthShop",WZUIImage)
    local txtTitle = GetElement(self.m_root,"txtTitle_WndAthShop",WZUILabelTTF)
    local tabReward = GetElement(self.m_root, "tbRewards_WndAthShop", WZUITableContainer)

    if self.m_tOtherData and self.m_tOtherData.changeRes == 2 then 
        if self.m_tOtherData.img9Bg_UseOriginSize ~= nil then 
            img9Bg:setUseOriginSize(self.m_tOtherData.img9Bg_UseOriginSize)
        end
        if self.m_tOtherData.img9BgPt ~= nil then 
            img9Bg:setRelativePosition(self.m_tOtherData.img9BgPt)
        end
        if self.m_tOtherData.img9Bg then 
            img9Bg:setFile(self.m_tOtherData.img9Bg)
        end
        if self.m_tOtherData.btnClosePt then 
            btnSure:setRelativePosition(self.m_tOtherData.btnClosePt)
        end
        if self.m_tOtherData.imgBtn then 
            imgBtn:setFile(self.m_tOtherData.imgBtn)
        end
        if self.m_tOtherData.titlePt ~= nil then 
            txtTitle:setRelativePosition(self.m_tOtherData.titlePt)
        end
        if self.m_tOtherData.titleStroke ~= nil then 
            txtTitle:setEnableStroke(self.m_tOtherData.titleStroke)
        end
        if self.m_tOtherData.titleColor then 
            txtTitle:setColor(self.m_tOtherData.titleColor)
        end
        if self.m_tOtherData.titleStrokeColor then 
            txtTitle:setStrokeColor(self.m_tOtherData.titleStrokeColor)
        end
        if self.m_tOtherData.tabRewardPt ~= nil then
            tabReward:setRelativePosition(self.m_tOtherData.tabRewardPt)
        end
        if self.m_tOtherData.img9SecBg then 
            img9SecBG:setFile(self.m_tOtherData.img9SecBg)
        end

        if self.m_tOtherData.titleArrowFile then
            local img = WZUIImage:create()
            img:setUseOriginSize(true)
            img:setFile(self.m_tOtherData.titleArrowFile)
            if self.m_tOtherData.titleArrowPt then
                img:setRelativePosition(self.m_tOtherData.titleArrowPt[1])
            end
            if self.m_tOtherData.titleArrowFilpX then
                img:setFlipX(self.m_tOtherData.titleArrowFilpX[1])
            end
            self.m_root:addChild(img)

            local img = WZUIImage:create()
            img:setUseOriginSize(true)
            img:setFile(self.m_tOtherData.titleArrowFile)
            if self.m_tOtherData.titleArrowPt then
                img:setRelativePosition(self.m_tOtherData.titleArrowPt[2])
            end
            if self.m_tOtherData.titleArrowFilpX then
                img:setFlipX(self.m_tOtherData.titleArrowFilpX[2])
            end
            self.m_root:addChild(img)
        end
        
        if self.m_tOtherData.dividerFile then
            local con = WZUIContainer:create()
            con:setUseAbsSize(true)
            if self.m_tOtherData.dividerSize then
                con:setAbsContentSize(self.m_tOtherData.dividerSize)
            end
            if self.m_tOtherData.dividerPt then
                con:setRelativePosition(self.m_tOtherData.dividerPt)
            end
            self.m_root:addChild(con)

            local img = WZUI9Image:create()
            img:setFile(self.m_tOtherData.dividerFile)
            con:addChild(img)
        end
    end
    txtTitle:setText(self.m_sTitleName)

    self:setViewVisible()
end

function WndAthShop:setViewVisible()
    local reward_ids = {}
    local reward_nums = {}
    local tTempData = {}
    WZLog("WndAthShop:setViewVisible")
    reward_ids = self.m_tRewardIdsData.reward_ids1 or {}
    reward_nums = self.m_tRewardIdsData.reward_nums1
    tTempData = self.m_tRewardIdsData

    local tabReward = GetElement(self.m_root, "tbRewards_WndAthShop", WZUITableContainer)
    tabReward:cleanTable()

    if tTempData.cellElementHeight then 
        tabReward:setCellElementHeight(tTempData.cellElementHeight)
    end
    
    for i=1, #reward_ids do
        local tabItem = GDatatab_item["id_".. reward_ids[i]]
        local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
        local bVisibleLimit = false
        local strLimit = "" 
        if tTempData.leftConfig then 
            itemInfo.leftConfig = tTempData.leftConfig[i]
            bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
        end
        if tTempData.chooseState then 
            itemInfo.chooseState = tTempData.chooseState[i]
        end
        if tTempData.pool then 
            itemInfo.pool = tTempData.pool
        end
        if tTempData.origin then 
            itemInfo.origin = tTempData.origin
        end
        local nType = 17 
        if tTempData.type then 
            nType = tTempData.type
            itemInfo.rootNode = self.m_root
        end
        local celElement,tCell = CellGoodItem:createElement()
        if celElement and tCell then
            tCell:setCellGoodItem(itemInfo, nType)
            celElement:setTag(i-1)
            tabReward:setCellElement(celElement)
            if ProjConfig.LANGUAGE == "vn" then
                tTempData.chooseState = nil
            end
            if tTempData.chooseState then 
                tCell:setItemClickFun(WndAthShop, self.onClickItem2)
            else
                tCell:setItemClickFun(WndAthShop, self.onItemClick)
            end
            if bVisibleLimit then 
                tCell:_addNumLimit(strLimit)
            end
            if itemInfo.chooseState and itemInfo.chooseState == 1 then 
                tCell:setItemSelState(true)
                if self.m_tSelCell == nil then 
                    self.m_tSelCell = tCell
                end
            end
        end
    end
end

--@brief    点击奖励回调
function WndAthShop:onClickItem2(tCell, tag, tData)
    WZLog("WndAthShop:onClickItem2 ")
    --每个活动的doType不一定一致，看好协议文档
    if tData.chooseState and tData.chooseState == 0 then 
        local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
        if bIsSoldOut then
            if self.m_tOtherData.chooseInfo then 
                local chooseInfo = self.m_tOtherData.chooseInfo
                if tData.pool then 
                    MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings[chooseInfo.strKey][chooseInfo.wordIndex + tData.pool], tData.basicInfo.name, tData.lastTime))
                else
                    MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], chooseInfo.strKey, tData.basicInfo.name, tData.lastTime))
                end
            else
                MsgBoxManager:showTipBox(LocalStrings.SUMMERSURF_TEXT1[24])
            end
            return
        else
            self.m_tClickCell = tCell 
            local tTempData = {}
            local doType = 3
            if self.m_tOtherData.chooseInfo then 
                local chooseInfo = self.m_tOtherData.chooseInfo
                tTempData.id = tData.index - 1
                if tData.pool then 
                    tTempData.pool = tData.pool
                end
                doType = chooseInfo.doType
            else
                tTempData.index = tData.index - 1
                tTempData.type = 4 - self.m_nCurIndex
            end
            local stringData = json.encode(tTempData)
            ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tOtherData.activityId, doType, stringData)
       end
    elseif tData.chooseState and tData.chooseState == 1 then 
        self.m_tClickCell = tCell 
        local tTempData = {}
        local doType = 3
        if self.m_tOtherData.chooseInfo then 
            local chooseInfo = self.m_tOtherData.chooseInfo
            tTempData.id = tData.index - 1
            if tData.pool then 
                tTempData.pool = tData.pool
            end
            doType = chooseInfo.doType
        else
            tTempData.index = tData.index - 1
            tTempData.type = 4 - self.m_nCurIndex
        end
        local stringData = json.encode(tTempData)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tOtherData.activityId, doType, stringData)
        tCell:setItemSelState(false)
    end
end
-------------------------------------私有方法模块End--------------------------------------