--WndDesignationMain.lua
--@brief	WndDesignationMain的UI模块
--@date		2015/03/25
--@author	clc
--@note		成就系统-主界面   Achie为成就     Desi为称号

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDesignationMain:onEnter(element)
	self.m_root = element
   
    self:createLoading()
    CacheCenter:registerUpatemDeShowObservers(self)

    --初始化静态文本
    self:_initStaticUI()
    --语言适配
    AdaptLanguage(self)
    self.m_sLanguage = ProjConfig.LANGUAGE
end

function WndDesignationMain:onEnterTransitionDidFinish(element)
    WZLog("WndDesignationMain:onEnterTransitionDidFinish")
    self:actionCallback()
end

--@brief    开始按下回调函数
function WndDesignationMain:onTouchBegin(element,pt)
    WZLog("WndDesignationMain:onTouchBegin",pt.x,pt.y)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    if bPoint == true then
        WZLog("回调函数:",type(bPoint),bPoint)
    else
        WndItemInfo:onCloseClick()
    end
    if not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end


--@brief    弹窗动画完成后的回调
function WndDesignationMain:actionCallback(element, data)
	WZLog("WndDesignationMain:actionCallback")
	CacheCenter:getAchieList(self.getAchieListCallBack,self)
end


--@brief   获得成就面板数据列表回调
function WndDesignationMain:getAchieListCallBack( achieList )
	-- body
	self.m_tAchieMentList = achieList
	CacheCenter:getDesiList(self.getDesigListCallBack,self)
end

--@brief    获取称号数据列表回调
function WndDesignationMain:getDesigListCallBack( desigList )
	-- body
	self:closeLoading()
    self.m_tDesignationList = {}
    --屏蔽掉结婚和师徒称号
    for i = 1, #desigList do
        if desigList[i].sort == 4 and CheckButtonShow(8) then 
            table.insert(self.m_tDesignationList, desigList[i])
        end
        if desigList[i].sort == 6 and CheckButtonShow(30) then
            table.insert(self.m_tDesignationList, desigList[i])
        end
        if desigList[i].sort ~= 4 and desigList[i].sort ~= 6 then
            if desigList[i].view == 0 then
                table.insert(self.m_tDesignationList, desigList[i])
            end
        end
    end

    WZLog("WndDesignationMain:getDesigListCallBack", Serialize(self.m_tDesignationList))
    --成就选项卡红点
    local bIsShowRedPoint = false
    for i=1,#self.m_tAchieMentList do
        if  self.m_tAchieMentList[i].statusNum > 0 then
            bIsShowRedPoint = true
            g_bHaveRedPointForAchieEntry = true
        end
    end
    
    --计算成就点
    self:_caculateAchiePoints()

	if self.m_nCurrentTypeIndex == 0 then  --成就
		self:_initAchiePanel()
    elseif self.m_nCurrentTypeIndex == 2 then   --徽章
        self:_initBadge()
        self:_initTopInfo()

        self:_switchContainer(false, true)
	end 
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDesignationMain:onExit(element)
	CacheCenter:unregisterUpatemDeShowObservers(self)
	self:_unInit()
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndDesignationMain:onCloseClick()
    WZLog("WndDesignationMain:onCloseClick")
    if WndDesignationMain.m_root == nil then return end 
    --维护称号本地数据表和缓存，清除红点状态
    if self.m_nclickedMainClassicId == 13 then
        self:_updateDesiRed()
    end
end

--@brief    切换成就和徽章按钮回调
function WndDesignationMain:onClickChange(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nCurrentTypeIndex == 2 then
        self:onAchieButtonDone(element)
    elseif self.m_nCurrentTypeIndex == 0 then 
        self:onBadgeButtonDone(element)
    end
end


--@brief	成就按钮点击完成函数回调  显示成就面板
--@param 	element:触发事件的控件引用
function WndDesignationMain:onAchieButtonDone(element)
	WZLog("WndDesignationMain:onAchieButtonDone");
	self.m_nCurrentTypeIndex = 0

    self:_initAchiePanel()
    --维护称号本地数据表和缓存，清除红点状态
    if self.m_nclickedMainClassicId == 13 then
        self:_updateDesiRed()
    end

end

function WndDesignationMain:onBadgeButtonDone(element)
    -- body
    WZLog("WndDesignationMain:onBadgeButtonDone");
    self:_initBadge()
    --维护称号本地数据表和缓存，清除红点状态
    if self.m_nclickedMainClassicId == 13 then
        self:_updateDesiRed()
    end

    self.m_nCurrentTypeIndex = 2

    self:_switchContainer(false, true)
end

--@brief    提示有尚未领取或查看的成就
--@note     有新成就待查看或领取
function WndDesignationMain:showRedPointAchie(bIsShow)
    -- body
    WZLog("************* WndDesignationMain:showRedPointAchie **********", bIsShow)
    GetElement(self.m_root, "imgRedDot_WndDesignationMain", WZUIImage):setVisible(bIsShow)
end

--@brief    提示有新的称号
--@note     有新称号待查看
function WndDesignationMain:showRedPointDesi(bIsShow)
    -- body
    self.m_bHaveNewDesi = bIsShow
    
    local  AchieFreeList =  GetElement(self.m_root, "chengjiu_FreeList_WndDesignationMain", WZUIFreeListContainer)

    for i=1,AchieFreeList:size() do
        local element               
         element =  AchieFreeList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        local cellJobid = tNewObj:getJobId()
        if tNewObj:getCellType() == 1 then
            if cellJobid == 13 then
                tNewObj:showAperture(bIsShow)
                break 
            end
        end
    end
end

--@brief    徽章红点
function WndDesignationMain:showRedPointBadge(bIsShow)
    -- body
    if self.m_root == nil then return end  
    if self.m_nCurrentTypeIndex == 0 then 
        GetElement(self.m_root, "imgRedDot_WndDesignationMain", WZUIImage):setVisible(bIsShow)
    end

    g_bHaveRedPointForAchieEntry = CacheCenter:whetherAchieHaveRedDot() or g_bHaveNewDesi
    WndBagMain:setAchieEntryRedPointVisible()
end
--@brief	称号按钮点击完成函数回调  显示称号面板
--@param 	element:触发事件的控件引用
function WndDesignationMain:onDesiButtonDone(element)
	WZLog("WndDesignationMain:onDesiButtonDone")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_initDesiPanel()

    self.m_nCurrentTypeIndex = 1

    self:_switchContainer(false, true, false)
end

--@brief   创建加载框
function WndDesignationMain:createLoading()
	if self.m_nLoadingId == nil then
		self.m_nLoadingId = MsgBoxManager:showLoadingBox( )
	end
	
end

--@brief   关闭加载框
function WndDesignationMain:closeLoading()
	local nId = self.m_nLoadingId
	if self.m_nLoadingId ~= nil then
	   MsgBoxManager:stopLoadingBoxByMsgId(nId)
       self.m_nLoadingId = nil
	end
end

---------------------------------------成就面板逻辑Begin----------------------------

--@brief    设置相应选项卡的内容的显示和隐藏
function WndDesignationMain:_switchContainer(bAchieVisible, bBadgeVisible)
    -- body
    if bAchieVisible then
        self:_setChangeBtnText(LocalStrings.DOWNLOADREWARD_BADGE)
        --设置徽章红点
        self:showRedPointBadge(GlobalGame.g_tRedPointList.badge)
    end
    if bBadgeVisible then
        self:_setChangeBtnText(LocalStrings.ACHIE_TITLE)
        --设置成就选项卡右上角的红点提示是否可见
        local bIsShowRedPoint = CacheCenter:whetherAchieHaveRedDot()
        self:showRedPointAchie(bIsShowRedPoint)
    end
    GetElement(self.m_root, "chenjiuPanel_BackGround_WndDesignationMain", WZUIContainer):setVisible(bAchieVisible)
    GetElement(self.m_root, "badgePanel_BackGround_WndDesignationMain", WZUIContainer):setVisible(bBadgeVisible)
end

--@brief	初始化成就系统成就系统的面板
function WndDesignationMain:_initAchiePanel()
	WZLog("WndDesignationMain:_initAchiePanel")
    ChangeChatChannel(Chat_Channel_Achievement)
    self:_switchContainer(true, false)
	self:_initFreeListAchiePanel()
    self:_initTopInfo()
end

--@brief	更新成就系统成就界面左边面板
function WndDesignationMain:updateAchieUI( )
	-- body
	if self.m_root == nil  then
		return
	end
    if self.m_tAcSubTable == nil then return end

	self:refreshAllAperture(self.m_tAcSubTable.id)
end  

--@brief	初始化成就系统成就系统的FreeListContainer
function WndDesignationMain:_initFreeListAchiePanel()
    local  bIsShowRedPoint = false  --标记是否显示成就选项右上角的红点
	local  AchieFreeList =  GetElement(self.m_root, "chengjiu_FreeList_WndDesignationMain", WZUIFreeListContainer)
    if AchieFreeList == nil or AchieFreeList:size() > 0 then
        return
    end
    WZLog("WndDesignationMain:_initFreeListAchiePanel  Init One Time")
    for i = 1, #self.m_tAchieMentList do
        local element,tNewObj = CellDesignationOne:createElement()
        element = WZUIContainer:luaTo(element)
        tNewObj:setCellPos(i)
        tNewObj:setJobId(self.m_tAchieMentList[i].id)
        WZLog("i=====",i,self.m_tAchieMentList[i].name,self.m_tAchieMentList[i].complete,self.m_tAchieMentList[i].target)
        local nFinishAchiePoints = self.m_tAchieMentList[i].achiePoints - self.m_tAchieMentList[i].achiePointsNot
        tNewObj:setCellUI(self.m_tAchieMentList[i].name, nFinishAchiePoints, self.m_tAchieMentList[i].achiePoints)
        if self.m_tAchieMentList[i].statusNum > 0 or (self.m_tAchieMentList[i].id == 13 and self.m_bHaveNewDesi) then
            self.m_leftActiveCell = tNewObj
        	tNewObj:showAperture(true)
            bIsShowRedPoint = true
            g_bHaveRedPointForAchieEntry = true
        else
        	tNewObj:showAperture(false)
        end
        AchieFreeList:pushBack(element)
        element:setContentSize(GlobalMethod:CCSize(190,72))
        element:setRelativeSize(GlobalMethod:CCSize(1,72/390))
    end

    AchieFreeList:update()
    AchieFreeList:getMoveElement():setPositionY(AchieFreeList:getMinPosition().y)

    local bNewAchie = false 
    local nMainAchieHavedRedPointIndex = 1 
    --遍历那个子节点有红点
    --设置进成就界面，显示首个可以领取的子节点
    local nJobId
    local nPos 
    for i = 1, #self.m_tAchieMentList do
        if self.m_tAchieMentList[i].statusNum > 0 or (self.m_tAchieMentList[i].id == 13 and self.m_bHaveNewDesi) then
            bNewAchie = true
            nMainAchieHavedRedPointIndex = i
            nJobId = self.m_tAchieMentList[i].id
            nPos = i
            break 
        end 
    end
    local cellHeight = 77
    if nMainAchieHavedRedPointIndex > 5 then
        local nCurPositionY = AchieFreeList:getMinPosition().y + (nMainAchieHavedRedPointIndex - 5) * cellHeight
        if nCurPositionY > AchieFreeList:getMaxPosition().y then 
            nCurPositionY = AchieFreeList:getMaxPosition().y
        end
        AchieFreeList:getMoveElement():setPositionY(nCurPositionY)
    end

    self.m_tAcSubTable = {}
    --如果没有可领取的成就项，默认选中第一个
    if not bNewAchie then
        nJobId = self.m_tAchieMentList[1].id
        nPos = 1
    end
    WZLog("_initFreeListAchiePanel", nJobId)
    --Add End
    self:onClickMainCellForAchie(nJobId, nPos)
end

--@brief   成就系统-成就面板-刷新左边的table的光圈显示
--@param   vid   已查看成就id
function WndDesignationMain:refreshAllAperture( vid )
	-- body
	for i=1,#self.m_tAchieMentList do
		for j=1,#self.m_tAchieMentList[i].childList do
			if self.m_tAchieMentList[i].childList[j].id == vid then
				if self.m_tAchieMentList[i].childList[j].status == 1 then
					self.m_tAchieMentList[i].childList[j].status  = 2       --传人id设置光圈显示状态为2
					if self.m_tAchieMentList[i].statusNum > 0 and self.m_tAchieMentList[i].childList[j].reward == -1 then
						self.m_tAchieMentList[i].statusNum = self.m_tAchieMentList[i].statusNum - 1  --父成就的下子成就已完成未查看减少1
					end
				end                               
				
			end
		end
	end

	local  AchieFreeList =  GetElement(self.m_root, "chengjiu_FreeList_WndDesignationMain", WZUIFreeListContainer)
    local  bIsShowRedPoint = false    --标记是否显示成就选项右上角的红点

	for i=1,AchieFreeList:size() do
		local element               
		 element =  AchieFreeList:getAt(i-1)	
		if element == nil then
			return
		end
		element = WZUIContainer:luaTo(element)
		local tNewObj = element:getLuaObjectIndex()
		local cellJobid = tNewObj:getJobId()
		if tNewObj:getCellType() == 1 then
			for k=1,#self.m_tAchieMentList do
				if cellJobid == self.m_tAchieMentList[k].id then
					if self.m_tAchieMentList[k].statusNum > 0 then
						tNewObj:showAperture(true)
                        bIsShowRedPoint = true 
					else
						tNewObj:showAperture(false)
					end
                    tNewObj:setCellUI(self.m_tAchieMentList[k].name, self.m_tAchieMentList[k].complete, self.m_tAchieMentList[k].target)
				end
			end
		end
	end

    --设置成就选项卡右上角的红点提示是否可见
    g_bHaveRedPointForAchieEntry = bIsShowRedPoint
end

--@brief	成就系统-成就面板-主分类cell调用此函数更新成就面板UI
--@Param    nJobId:用户点击的主分类cell所保存的id  用来判断点击了哪一个
--@Param    nPos:用户点击cell的cell位置数对应数据table里下标数
--@param    tNewObj:选中的cell
function WndDesignationMain:onClickMainCellForAchie( nJobId , nPos, tNewObj)
	-- body
	--table数组的下标从1开始，freelistconter的下标从0开始
    if self.m_nclickedMainClassicId == nJobId then 
        return
    end
    if tNewObj then
        self.m_leftActiveCell = tNewObj 
    end
    self.m_nclickedDesignatin  = -1

    for i=1,#self.m_tAchieMentList do
        if self.m_tAchieMentList[i].id == nJobId then
            local sMainTitle =  "【" .. self.m_tAchieMentList[i].name .. "】" .. LocalStrings.GET_ACHIE_POINTS
            if nJobId == 13 then
                sMainTitle = "【" .. self.m_tAchieMentList[i].name .. "】" .. LocalStrings.DESIGNATION_NO_POINT
                GetElement(self.m_root, "conForSubAchie_WndDesignationMain", WZUIContainer):setVisible(false)
            else
                GetElement(self.m_root, "conForSubAchie_WndDesignationMain", WZUIContainer):setVisible(true)

            end
            GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF):setText(sMainTitle)
            if nJobId ~= 13 then
                local sGetAchiePoints = string.format("%d/%d", self.m_tAchieMentList[i].achiePointsGet, self.m_tAchieMentList[i].achiePoints)
                GetElement(self.m_root, "txtAchiePointNum_WndDesignationMain", WZUILabelTTF):setText(sGetAchiePoints)
                local proMainProgress = GetElement(self.m_root, "proAchiePoint_WndDesignationMain", WZUIProgress)
                local imgProBk_chengjiu = GetElement(self.m_root, "imgProBk_chengjiu", WZUI9Image)
                if self.m_tAchieMentList[i].achiePointsGet == 0 then
                    imgProBk_chengjiu:setOpacity(76)
                else
                    imgProBk_chengjiu:setOpacity(204)
                end
                local nPercent =100 * self.m_tAchieMentList[i].achiePointsGet / self.m_tAchieMentList[i].achiePoints
                proMainProgress:setPercentage(nPercent)
            end
        end
    end

    local mainFreeList = GetElement(self.m_root, "chengjiu_FreeList_WndDesignationMain", WZUIFreeListContainer)
    if mainFreeList == nil then return end
    --设置主成就的选中状态
    for i = 1, mainFreeList:size() do
        local element = mainFreeList:getAt(i - 1)
        if element == nil then return end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        local nObjectId = tNewObj:getJobId()
        if self.m_nclickedMainClassicId ~= -1 and nObjectId == self.m_nclickedMainClassicId then
            tNewObj:setLightVisible(false)
        elseif nObjectId == nJobId then
            tNewObj:setLightVisible(true)
        end
    end

	if self.m_nclickedMainClassicId == nJobId then 
        return
	else
        --更新子成就列表
        local subFreeList = GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)
        if subFreeList == nil then return end
        if subFreeList:size() > 0 then
            subFreeList:removeAll()
        end

        self.m_nclickedMainClassicId = nJobId
        if nJobId ~= 13 then
            self.m_tCurLoadList = self.m_tAchieMentList[nPos].childList
        else
            self.m_tCurLoadList = self.m_tDesignationList
        end
        self:onShowAchie(subFreeList)
        
        subFreeList:UpdateInsidePosition()
	end
end

--@brief    动态加载显示子成就列表
function WndDesignationMain:onShowAchie(element)
    -- body
    if self.m_tCurLoadList == nil or #self.m_tCurLoadList == 0 then
        return
    end

    self.m_nclickedDesignatin = -1
    element = WZUIFreeListContainer:luaTo(element)
    for i = 1, #self.m_tCurLoadList do
        local subTable = self.m_tCurLoadList[i]
        local cellElement,tNewObj = CellDesignationTwo:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)

        if self.m_nclickedMainClassicId == 13 then
            tNewObj:setDesiData(self.m_tCurLoadList[i])
            --称号红点
            if subTable.status == 3 then
                tNewObj:setRedDotVisible(true)
            else
                tNewObj:setRedDotVisible(false)
            end
        else
            local nComplete = subTable.complete
            local nTarget = subTable.target
            if subTable.count == 2 then
                nComplete = nComplete + subTable.complete2
                nTarget = nTarget + subTable.target2
            end
            tNewObj:setCellUI(subTable.name, subTable.desc, subTable.status, subTable.reward, nComplete, nTarget)
        end
        tNewObj:setJobId(subTable.id)
        --设置称号的勾选状态
        local nStatus = CacheCenter:judgeWhetherDesiUsed(subTable.id)
        if nStatus then
            self.m_nclickedDesignatin = i-1
            tNewObj:setClicked(true)
        else
            tNewObj:setClicked(false)
        end

        cellElement:setTag(i - 1)
        cellElement:setContentSize(GlobalMethod:CCSize(590,103))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,103/360))
        
        element:pushBack(cellElement)
    end

    if self.m_nclickedMainClassicId == 13 then 
        local nIndex = self:_getRedDotDesi()
        local nCurPositionY = element:getMinPosition().y + (nIndex - 1) * 103
        if nCurPositionY > element:getMaxPosition().y then
            nCurPositionY = element:getMaxPosition().y
        end
        element:getMoveElement():setPositionY(nCurPositionY)
    else
        element:getMoveElement():setPositionY(element:getMinPosition().y)
    end
end

--@brief    当选中的子成就状态改变时，重新设置显示的子成就信息
--@param    改变的子成就
function WndDesignationMain:resetSubTableInfo(childList)
    -- body
    WZLog("******************WndDesignationMain:resetSubTableInfo**********************")
    if self.m_tAcSubTable == nil or self.m_tAcSubTable.id ~= childList.id then return end

    self.m_tAcSubTable.id = childList.id
    self.m_tAcSubTable.name = childList.name
    self.m_tAcSubTable.desc = childList.desc
    self.m_tAcSubTable.addProperty = childList.addProperty
    self.m_tAcSubTable.reward = childList.reward
    self.m_tAcSubTable.complete = childList.complete
    self.m_tAcSubTable.target = childList.target
    self.m_tAcSubTable.status = childList.status
    --Add By Tianxiang_Xu
    self.m_tAcSubTable.count = childList.count
    if childList.count == 2 then 
        self.m_tAcSubTable.complete2 = childList.complete2
        self.m_tAcSubTable.target2 = childList.target2
    end
end

--@brief 成就系统-成就面板领取奖励按钮调用函数
function WndDesignationMain:acceptPrize(subAchieId)
	-- body
    self.m_tAcSubTable.id = subAchieId
    WZLog("WndDesignationMain:acceptPrize",subAchieId)
	ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementReward(subAchieId)
	self:createLoading()
end

function WndDesignationMain:acceptPrizeSucess(reward, nLeftAchievePoint)
    WZLog("WndDesignationMain:acceptPrizeSucess",reward, nLeftAchievePoint)
	-- body
	self:closeLoading()

	for i=1,#self.m_tAchieMentList do
		for j=1,#self.m_tAchieMentList[i].childList do
			if self.m_tAcSubTable.id == self.m_tAchieMentList[i].childList[j].id then
				self.m_tAchieMentList[i].childList[j].status = 3
        
                if self.m_tAchieMentList[i].statusNum > 0 then
                    self.m_tAchieMentList[i].statusNum = self.m_tAchieMentList[i].statusNum - 1  --父成就的下子成就已完成未查看减少1
                end
                break
			end
		end
	end

    --刷新剩余成就点数
    if nLeftAchievePoint ~= nil then
        --内存更新，界面刷新
        self:_initTopInfo()
    end

    --计算成就点
    self:_caculateAchiePoints()
    local nPos = 1 
    --属性主成就已获得的成就点数据
    for i = 1, #self.m_tAchieMentList do
        if self.m_tAchieMentList[i].id == self.m_nclickedMainClassicId then
            nPos = i
            local sGetAchiePoints = string.format("%d/%d", self.m_tAchieMentList[i].achiePointsGet, self.m_tAchieMentList[i].achiePoints)
            GetElement(self.m_root, "txtAchiePointNum_WndDesignationMain", WZUILabelTTF):setText(sGetAchiePoints)
            local proMainProgress = GetElement(self.m_root, "proAchiePoint_WndDesignationMain", WZUIProgress)
            local imgProBk_chengjiu = GetElement(self.m_root, "imgProBk_chengjiu", WZUI9Image)
            if self.m_tAchieMentList[i].achiePointsGet == 0 then
                imgProBk_chengjiu:setOpacity(76)
            else
                imgProBk_chengjiu:setOpacity(204)
            end
            local nPercent =100 * self.m_tAchieMentList[i].achiePointsGet / self.m_tAchieMentList[i].achiePoints
            proMainProgress:setPercentage(nPercent)
            break
        end
    end

    local  subFreeList =  GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)
    if subFreeList == nil then 
        return
    end

    for i = 1, subFreeList:size() do
        local element               
        element =  subFreeList:getAt(i - 1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        WZLog("*********** WndDesignationMain:acceptPrizeSucess **************", self.m_tAcSubTable.id, tNewObj:getJobId())
        if self.m_tAcSubTable.id == tonumber(tNewObj:getJobId()) then 
            tNewObj:setCellStatus(3)
            break 
        end
    end

    --更新子成就列表
    if subFreeList:size() > 0 then
        subFreeList:removeAll()
    end

    table.sort(self.m_tAchieMentList[nPos].childList, sortSubAchiList)

    self.m_nclickedDesignatin = -1
    for j = 1, #self.m_tAchieMentList[nPos].childList do         --npos对应cell位置和table组的下标
        local subTable = self.m_tAchieMentList[nPos].childList[j]
        local element,tNewObj = CellDesignationTwo:createElement()
        element = WZUIContainer:luaTo(element)
        local nComplete = subTable.complete
        local nTarget = subTable.target
        if subTable.count == 2 then
            nComplete = nComplete + subTable.complete2
            nTarget = nTarget + subTable.target2
        end
        tNewObj:setCellUI(subTable.name, subTable.desc, subTable.status, subTable.reward, nComplete, nTarget)
        tNewObj:setJobId(subTable.id)
        --设置称号的勾选状态
        local nStatus = CacheCenter:judgeWhetherDesiUsed(subTable.id)
        if nStatus then
            self.m_nclickedDesignatin = j-1
            tNewObj:setClicked(true)
        else
            tNewObj:setClicked(false)
        end

        element:setTag(j - 1)
        element:setContentSize(GlobalMethod:CCSize(590,103))
        element:setRelativeSize(GlobalMethod:CCSize(1,103/360))
        
        subFreeList:pushBack(element)
    end 
 
    subFreeList:getMoveElement():setPositionY(subFreeList:getMinPosition().y)
    
    subFreeList:UpdateInsidePosition()

    self:endAcceptToChangeRedPoint()
end

function  sortSubAchiList(a, b)   
    -- body
    local statusA = CacheCenter:resetSortStatus(a)
    local statusB = CacheCenter:resetSortStatus(b)
--    WZLog("--sortSubAchiList--",statusA,statusB)
    if statusA ~= nil and statusB ~= nil then
        if statusA == statusB then
            return a.id < b.id
        else
            return statusA < statusB     --子类正序
        end 
    end
end

--@brief    领取后让右上角的红点消失
function WndDesignationMain:endAcceptToChangeRedPoint()
    -- body
    local  AchieFreeList =  GetElement(self.m_root, "chengjiu_FreeList_WndDesignationMain", WZUIFreeListContainer)
    local  bIsShowRedPoint = false    --标记是否显示成就选项右上角的红点

    for i=1,AchieFreeList:size() do
        local element               
         element =  AchieFreeList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        local cellJobid = tNewObj:getJobId()
        if tNewObj:getCellType() == 1 then
            for k=1,#self.m_tAchieMentList do
                if cellJobid == self.m_tAchieMentList[k].id then
                    if self.m_tAchieMentList[k].statusNum > 0 then
                        tNewObj:showAperture(true)
                        bIsShowRedPoint = true 
                    else
                        tNewObj:showAperture(false)
                    end
                end
            end
        end
    end

    --设置成就选项卡右上角的红点提示是否可见
    g_bHaveRedPointForAchieEntry = bIsShowRedPoint
    WndBagMain:setAchieEntryRedPointVisible()
end

--@brief    计算主成就成就点数
function WndDesignationMain:_caculateAchiePoints()
    -- body
    local nTotalAchiePoints = 0
    local nTotalNotFinishAchiePoints = 0
     for i = 1, #self.m_tAchieMentList do
        local mainAchie = self.m_tAchieMentList[i]
        local nAchiePoint = 0
        local nNotFinishAchiePoints = 0
        local nHaveGetPoints = 0
        for j=1,#self.m_tAchieMentList[i].childList do
            local subTable = self.m_tAchieMentList[i].childList[j]  
            if mainAchie.id == subTable.p_id then
                if subTable.reward ~= -1 and subTable.reward ~= nil then
                    if subTable.reward[2][1] == 19 then
                        nAchiePoint = nAchiePoint + subTable.reward[2][2]
                        if subTable.status ~= nil then
                            if subTable.status <= 0 then
                                nNotFinishAchiePoints = nNotFinishAchiePoints + subTable.reward[2][2]
                            elseif subTable.status == 3 then
                                nHaveGetPoints = nHaveGetPoints + subTable.reward[2][2]
                            end
                        end
                    end
                end
            end
        end
        self.m_tAchieMentList[i].achiePoints = nAchiePoint
        self.m_tAchieMentList[i].achiePointsGet = nHaveGetPoints --已领取
        self.m_tAchieMentList[i].achiePointsNot = nNotFinishAchiePoints
        WZLog("WndDesignationMain:_caculateAchiePoints",nAchiePoint, nHaveGetPoints, nNotFinishAchiePoints)
        nTotalAchiePoints = nTotalAchiePoints + nAchiePoint
        nTotalNotFinishAchiePoints = nTotalNotFinishAchiePoints + nNotFinishAchiePoints
     end

    self.m_nTotalAchiePoints = nTotalAchiePoints  --总成就点
    self.m_nFinishAchiePoints = nTotalAchiePoints - nTotalNotFinishAchiePoints --已完成成就点
end
-----------------------------------------------成就面板逻辑End---------------------------------


-----------------------------------------------称号面板逻辑Begin-------------------------------

--@brief  设置称号成功后更新显示的称号
function WndDesignationMain:updateDesiShow(id)
	-- body
    --更新cell
    WZLog("self.m_nclickedDesignatin===",self.m_nclickedDesignatin, id)
    if self.m_nclickedDesignatin == -1 then return end
    local  subFreeList =  GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)
    local element =  subFreeList:getAt(self.m_nclickedDesignatin)
    element = WZUIContainer:luaTo(element)
    local element_obj = element:getLuaObjectIndex()
    local cellId = element_obj:getJobId( )
    WZLog("self.m_nclickedDesignatin***",cellId)
    if cellId == id then
        local cellStatus = CacheCenter:judgeWhetherDesiUsed(id)
        WZLog("cellStatus===", cellStatus)
        if cellStatus then
            element_obj:setClicked(true)
        else
            element_obj:setClicked(false)
        end
    elseif id == nil then
        element_obj:setClicked(false)
    end

end

--brief     分贞加载称号列表
function WndDesignationMain:onShowDesi(element)
    -- body
    element = WZUIFreeListContainer:luaTo(element)
    WZLog("---onShowDesi--",Serialize(self.m_tDesignationList))
    if self.m_tDesignationList == nil or #self.m_tDesignationList == 0 then
        return 
    end

    for i = 1, #self.m_tDesignationList do
        local cellElement,tNewObj = CellDesignationThree:createElement()
        --称号分类、称号ID、称号名称、称号属性（加成）、剩余天数、称号状态
        WZLog("self.m_tDesignationList====",self.m_nDesiIndex,self.m_tDesignationList[self.m_nDesiIndex].sort , self.m_tDesignationList[self.m_nDesiIndex].id ,
        self.m_tDesignationList[self.m_nDesiIndex].name , 
        self.m_tDesignationList[self.m_nDesiIndex].remain , self.m_tDesignationList[self.m_nDesiIndex].status)

        tNewObj:setCellUI( self.m_tDesignationList[self.m_nDesiIndex].sort , self.m_tDesignationList[self.m_nDesiIndex].id ,
            self.m_tDesignationList[self.m_nDesiIndex].name , 
            self.m_tDesignationList[self.m_nDesiIndex].remain , self.m_tDesignationList[self.m_nDesiIndex].status)
        if self.m_tDesignationList[self.m_nDesiIndex].status == 2 then
            self.m_nclickedDesignatin = self.m_nDesiIndex-1
            WZLog("WndDesignationMain:onShowDesi", self.m_nclickedDesignatin)
            tNewObj:setClicked(true)
        else
            tNewObj:setClicked(false)
        end
        cellElement:setTag(self.m_nDesiIndex-1)
        cellElement = WZUIContainer:luaTo(cellElement)
        element:pushBack(cellElement)
        cellElement:setContentSize(GlobalMethod:CCSize(743,67))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,100/400))  

        self.m_nDesiIndex = self.m_nDesiIndex + 1
    end
    element:getMoveElement():setPositionY(element:getMinPosition().y)
end

--@brief	成就系统成就面板的cell点就回调
function WndDesignationMain:onClickDesignation(npos, id)
	-- body
	WZLog("WndDesignationMain:onClickDesignation",npos)
	local  subFreeList =  GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)
    WZLog("self.m_nclickedDesignatin===",self.m_nclickedDesignatin)
    if self.m_nclickedDesignatin ~= -1 then
        local element =  subFreeList:getAt(self.m_nclickedDesignatin)
        element = WZUIContainer:luaTo(element)
        local element_obj = element:getLuaObjectIndex()
        element_obj:setClicked(false)
    end

    self.m_nclickedDesignatin = npos
    --如果点击的称号有红点，则隐藏掉
    if self.m_nclickedMainClassicId == 13 then 
        self:setRedPointUnVisible(subFreeList, self.m_nclickedDesignatin)
    end

    ProtocolProcessorDesignation:send_TITLE_SetTitle(id)
end

--@brief    点击称号，如果有红点，则隐藏
function WndDesignationMain:setRedPointUnVisible(element, nPos)
    -- body
    local celElement = element:getAt(nPos)
    local imgRedDot = GetElement(celElement, "imgRedDot_CellDesignationTwo", WZUIImage)
    local bIsRedVisible = imgRedDot:isVisible()
    if bIsRedVisible == true then
        imgRedDot:setVisible(false)
    end

    local bIsHaveOtherRedPoint = false 
    for i = 1, element:size() do
        if nPos ~= i - 1 then 
            celElement = element:getAt(i - 1)
            celElement = WZUIContainer:luaTo(celElement)
            local element_obj = celElement:getLuaObjectIndex()

            bIsRedVisible = element_obj:getRedDotState()
            if bIsRedVisible == true then
                bIsHaveOtherRedPoint = true
                g_bHaveNewDesi = true 
                break
            end
        end
    end

    local cellId = self.m_leftActiveCell:getJobId()
    WZLog("WndDesignationMain:setRedPointUnVisible", cellId, bIsHaveOtherRedPoint)
    if cellId == 13 then 
        if bIsHaveOtherRedPoint == false then
            self.m_leftActiveCell:showAperture(false)
            g_bHaveNewDesi = false 

            g_bHaveRedPointForAchieEntry = CacheCenter:whetherAchieHaveRedDot() or g_bHaveNewDesi
            WndBagMain:setAchieEntryRedPointVisible()
        end
    end
end

--@brief  刷新成就系统称号面边的freelist状态
function WndDesignationMain:updateDesilist( )
	-- body
	WZLog("WndDesignationMain:updateDesilist")
	if self.m_root == nil or self.m_tDesignationList == nil then
		return
	end
    if g_bHaveNewDesi == true then
        self:showRedPointDesi(g_bHaveNewDesi)
        WndBagMain:setAchieEntryRedPointVisible(g_bHaveNewDesi)
    end
    if self.m_nclickedMainClassicId ~= 13 then return end 

	local  subFreeList =  GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)

	if subFreeList:size() > 0 then
		subFreeList:removeAll()
	end

    self.m_tDesignationList = {}
    --屏蔽掉结婚和师徒称号
    local desigList = CacheCenter.m_tDesiList
    for i = 1, #desigList do
        if desigList[i].sort == 4 and CheckButtonShow(8) then 
            table.insert(self.m_tDesignationList, desigList[i])
        end
        if desigList[i].sort == 6 and CheckButtonShow(30) then
            table.insert(self.m_tDesignationList, desigList[i])
        end
        if desigList[i].sort ~= 4 and desigList[i].sort ~= 6 then
            if desigList[i].view == 0 then
                table.insert(self.m_tDesignationList, desigList[i])
            end
        end
    end

	for i=1 , #self.m_tDesignationList  do
		local subTable = self.m_tDesignationList[i]
        local cellElement,tNewObj = CellDesignationTwo:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        tNewObj:setDesiData(subTable)

        tNewObj:setJobId(subTable.id)
        --设置称号的勾选状态
        local nStatus = CacheCenter:judgeWhetherDesiUsed(subTable.id)
        if nStatus then
            self.m_nclickedDesignatin = i-1
            tNewObj:setClicked(true)
        else
            tNewObj:setClicked(false)
        end

        if subTable.status == 3 then
            tNewObj:setRedDotVisible(true)
        else
            tNewObj:setRedDotVisible(false)
        end

        cellElement:setTag(i - 1)
        cellElement:setContentSize(GlobalMethod:CCSize(590,103))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,103/360))
        
        subFreeList:pushBack(cellElement)
	end

    subFreeList:update()
    subFreeList:getMoveElement():setPositionY(subFreeList:getMinPosition().y)
end

--brief     刷新称号红点
function WndDesignationMain:_updateDesiRed()
    -- body
    local cellId = self.m_leftActiveCell:getJobId()
    local bIsVisible = GetElement(self.m_leftActiveCell.m_root , "aperture_Image",WZUIImage):isVisible()
    WZLog("WndDesignationMain:_updateDesiRed", bIsVisible)
    if bIsVisible == true and cellId == 13 then
        local  subFreeList =  GetElement(self.m_root, "subFreeList_WndDesignationMain", WZUIFreeListContainer)

        for i = 0, subFreeList:size() - 1 do
            local element = subFreeList:getAt(i)
            element = WZUIContainer:luaTo(element)
            local element_obj = element:getLuaObjectIndex()
            --将红点设为不可见
            local bRedDotVisible = element_obj:getRedDotState()
            if bRedDotVisible then
                element_obj:setRedDotVisible(false)
            end
        end

        CacheCenter:resetDesiList()
        for j = 1, #self.m_tDesignationList do
            if self.m_tDesignationList[j].status == 3 then
                self.m_tDesignationList[j].status = 1
            end
        end

        self.m_leftActiveCell:showAperture(false)
        g_bHaveNewDesi = false
        g_bHaveRedPointForAchieEntry = CacheCenter:whetherAchieHaveRedDot() or g_bHaveNewDesi
        WndBagMain:setAchieEntryRedPointVisible()
        --发送取消红点
        ProtocolProcessorDesignation:send_TITLE_SetTitle(-1)
    end
end
-----------------------------------------------称号面板逻辑End-------------------------------

--------------------------------------------徽章面板逻辑----------------------------------
--@brief    创建徽章界面
function WndDesignationMain:_initBadge()
    -- body
    WZLog("****** WndDesignationMain:_initBadge ******")
    ChangeChatChannel(Chat_Channel_Badge)
    if self.m_tBadgeList == nil then 
        self:createLoading()
        ProtocolProcessorDesignation:send_BADGE_GetBadgeList()
        return 
    end
end

--@brief    徽章升级按钮回调
function WndDesignationMain:onUpgradeCallBack(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local nTag = element:getTag()
    local nType = nTag + 1

    local tTempTable = self:_getLevelTableInfo(nType, self.m_tBadgeList[nType].nLevel)
    if tTempTable == nil then
        return 
    end

    if self.m_nLeftAchiePoints < tTempTable.cost[1][2] then
        MsgBoxManager:showTipBox(LocalStrings.BADGE_UPGRADE_FAILED)
        return 
    end
    --如果还在进行战斗力动画，删除动画和消息队列
    if GlobalGame.g_tWndFightingList ~= nil and #GlobalGame.g_tWndFightingList ~= 0 then
        for i,v in pairs(GlobalGame.g_tWndFightingList) do
            if v and v.m_root then
                WindowManager:removeWindow(v.m_root, v, true)
                GlobalGame.g_tWndFightingList[i] = nil
            end
        end
        MsgBoxManager:_removeMsgByType(MSGBOXTYPE_FIGHTANI)
    end
    
    self:createLoading()
    ProtocolProcessorDesignation:send_BADGE_UpgradeBadge(nType, self.m_tBadgeList[nType].nLevel)
end

--@brief    徽章升级成功
function WndDesignationMain:onBadgeUpgradeOk(achievementPort, genre, level, maxLevel, attribute, itemId, itemNum)
    -- body
    WZLog("********* WndDesignationMain:onBadgeUpgradeOk ********")
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
    --刷新界面的剩余成就点
    self:_initTopInfo()
    --刷新升级的徽章界面的信息
    local badgeFreeList = GetElement(self.m_root, "badge_FreeList_WndDesignationMain", WZUIFreeListContainer)
    if badgeFreeList == nil then
        return
    end
    for i= 1, badgeFreeList:size() do
        local element = badgeFreeList:getAt(i - 1)
        if element == nil then return end
        local nTag = element:getTag()
        WZLog("********* 1234567 ********", genre, nTag)
        if nTag == genre - 1 then
            self.m_tBadgeList[i].nLevel = level
            self.m_tBadgeList[i].nMaxLevel = maxLevel
            self:_setBadgeCell(element, genre, level)
            --升级动画
            local spineUpgrade = GetElement(element, "spineUpgrade_CellBadgePanelItem", WZUISpine)
            spineUpgrade:setVisible(true)
            if genre == 1 then
                spineUpgrade:play("shengming", false)
            elseif genre == 2 then
                spineUpgrade:play("gongji", false)
            elseif genre == 3 then
                spineUpgrade:play("fangyu", false)
            end
        end
    end

    --提示升级成功
    PopupResult("ui/common/common_icon_sjz.png")
    self:closeLoading()
end

--@brief    升级特效播完回调
function WndDesignationMain:onFinishArmatureCallBack(element)
    -- body
    WZLog("WndDesignationMain:onFinishArmatureCallBack")
    element:setVisible(false)
end

--@brief    获取徽章列表数据
--@param    achievementPort 当前剩余成就点
--@param    genre 类型(1生命，2力量，3护甲)
function WndDesignationMain:setBadgeData(achievementPort, genre, level, maxLevel, attribute, itemCount, itemId, itemNum)
    -- body
    self:closeLoading()
    if self.m_tBadgeList == nil then
        self.m_tBadgeList = {}
    end

    for i = 0, genre:size() - 1 do
        local tTempTable = {}
        tTempTable.nType = genre:get(i)
        tTempTable.nLevel = level:get(i)
        tTempTable.nMaxLevel = maxLevel:get(i)
        tTempTable.nAttribute = attribute:get(i)
        if tTempTable.nType == 1 then
            tTempTable.sIconName = "ui/achievement/common_icon_cjsmhz.png"
        elseif tTempTable.nType == 2 then
            tTempTable.sIconName = "ui/achievement/common_icon_cjgjhz.png"
        elseif tTempTable.nType == 3 then
            tTempTable.sIconName = "ui/achievement/common_icon_cjpyhz.png"
        end

        table.insert(self.m_tBadgeList, tTempTable)
    end

    WZLog("*********", Serialize(self.m_tBadgeList))
    self:updateBadgeList()
end

function WndDesignationMain:updateBadgeList()
    -- body
    local badgeFreeList = GetElement(self.m_root, "badge_FreeList_WndDesignationMain", WZUIFreeListContainer)
    if badgeFreeList == nil then
        return
    end
    
    for i= 1, #self.m_tBadgeList do
        local element = WZUISystem:getInstance():createElement("CellBadgePanelItem")
        if element == nil then
            return 
        end
        element = WZUIContainer:luaTo(element)
        element:setVisible(true)
        element:setTag(i - 1)
        badgeFreeList:pushBack(element)
        self:_setBadgeCell(element, self.m_tBadgeList[i].nType, self.m_tBadgeList[i].nLevel)

        local btnUpgrade = GetElement(element, "btnUpgrade_CellBadgePanelItem", WZUIButton)
        btnUpgrade = WZUIButton:luaTo(btnUpgrade)
        btnUpgrade:setTag(i - 1)

        if ProjConfig.LANGUAGE == "es" then
            GetElement(element,"txtFullLevel_CellBadgePanelItem",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(220))
            GetElement(element,"button_nor_Label",WZUILabelTTF):setScale(0.65)
        elseif ProjConfig.LANGUAGE == "pt" then
            GetElement(element,"txtFullLevel_CellBadgePanelItem",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(220))
        end
    end

end
--------------------------------------------徽章面板逻辑END-------------------------------

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化剩余成就点和总进度
function WndDesignationMain:_initTopInfo()
    -- body
    self.m_nLeftAchiePoints = CacheCenter:getPlayerItemCountById(19)
    --当前剩余成就点
    local sCurrentFormat = [[<T C="105,65,46" S="20" P="1">%s</T><I Z="0.5" P="1">%s</I><T C="128,54,13" S="20" P="1">%s</T>]]
    local ftxtLeftAchieNum = GetElement(self.m_root, "ftxtLeftAchieNum_WndDesignationMain", WZUIFreeTextBox)
    ftxtLeftAchieNum:setShowText(string.format(sCurrentFormat, LocalStrings.LEFT_ACHIE_POINTS, GDatatab_item["id_19"].icon, self.m_nLeftAchiePoints))
    --总进度
    local sCurrentFormat2 = [[<T C="105,65,46" S="20" P="1">%s</T><T C="128,54,13" S="20" P="1">%d/%d</T>]]
    local ftxtTotalProgress = GetElement(self.m_root, "ftxtTotalProgress_WndDesignationMain", WZUIFreeTextBox)
    local sTotalPro = string.format(sCurrentFormat2, LocalStrings.TOTAL_PROGRESS, self.m_nFinishAchiePoints, self.m_nTotalAchiePoints)
    ftxtTotalProgress:setShowText(sTotalPro)
end

--@brief    生成徽章界面
function WndDesignationMain:_setBadgeCell(element, nType, nLevel)
    -- body
    if element == nil then return end
    WZLog("********** WndDesignationMain:_setBadgeCell ************")
    local conNotMaxInfo = GetElement(element, "conNotMaxInfo_WndDesignationMain", WZUIContainer)
    local txtCostWord = GetElement(element, "txtCostWord_CellBadgePanelItem", WZUILabelTTF)
    local conCoinsIcon = GetElement(element, "conCoinsIcon_CellBadgePanelItem", WZUIContainer)
    local txtCostNum = GetElement(element, "txtCostNum_CellBadgePanelItem", WZUILabelTTF)

    GetElement(element, "imgIcon_CellBadgePanelItem", WZUIImage):setFile(self.m_tBadgeList[nType].sIconName)
 
    local tCurLevelData = self:_getLevelTableInfo(nType, nLevel)
    if tCurLevelData == nil then return end

    local nMaxLevel = self:_rtnMaxLevelByType(nType)

    
    local sProperty = LocalStrings.HEALTH
    
    if nType == 1 then
        sProperty = LocalStrings.HEALTH
    elseif nType == 2 then
        sProperty = LocalStrings.ATTACK
    elseif nType == 3 then
        sProperty = LocalStrings.DEFENSE
    end
    GetElement(element, "txtLevelNum_CellBadgePanelItem",WZUILabelTTF):setText(sProperty .. ":" .. "+" .. tostring(tCurLevelData.add_attribute))
    local sTitle = sProperty .. LocalStrings.DOWNLOADREWARD_BADGE
    local txtTitle = string.format([[<T S = "22" C = "158,0,0">Lv%d </T><T S = "22" C = "105,65,46">%s</T>]], nLevel, sTitle)
    
    if ProjConfig.LANGUAGE == "vn" then
        sTitle = LocalStrings.DOWNLOADREWARD_BADGE .. " " .. sProperty
        txtTitle = string.format([[<T S = "22" C = "105,65,46">%s</T><T S = "22" C = "158,0,0"> Lv%d </T>]], sTitle,nLevel)
    end
    
    local txtBadgeTitle = GetElement(element, "txtBadgeTitle_CellBadgePanelItem",WZUIFreeTextBox)
    txtBadgeTitle:setShowText(txtTitle)
    GetElement(element, "txtLevelWord_CellBadgePanelItem", WZUILabelTTF):setText(LocalStrings.LEVEL .. ":Lv" .. nLevel)

    if nLevel < nMaxLevel then
        if tCurLevelData ~= nil then
            local iconFile = self:_getIconFile(tCurLevelData.cost[1][1])
            GetElement(element, "imgCostAchiePointsIcon",WZUIImage):setFile(iconFile)
            txtCostNum:setText(tCurLevelData.cost[1][2])
        end
        local tNextLevelData = self:_getLevelTableInfo(nType, nLevel + 1)
        if tNextLevelData ~= nil then
            GetElement(element, "txtPropertyWord_CellBadgePanelItem",WZUILabelTTF):setText("Lv" .. tostring(nLevel + 1))
            GetElement(element, "txtPropertyNum_CellBadgePanelItem",WZUILabelTTF):setText("+" .. tostring(tNextLevelData.add_attribute))
        end
        --计算让花费显示居中
        local celSize = element:getAbsContentSize()
        local costWordSize = txtCostWord:getContentSize()
        local imgSize = conCoinsIcon:getAbsContentSize()
        local costNumSize = txtCostNum:getContentSize()
        WZLog("*********** 12347890 **********", celSize.width, costWordSize.width, imgSize.width, costNumSize.width)
        local costWordPointX = ((celSize.width - (costWordSize.width + imgSize.width + costNumSize.width))/2 + costWordSize.width) / celSize.width
        local imgPointX = ((celSize.width - (costWordSize.width + imgSize.width + costNumSize.width))/2 + costWordSize.width + imgSize.width ) / celSize.width
        local costNumPointX = ((celSize.width - (costWordSize.width + imgSize.width + costNumSize.width))/2 + costWordSize.width + imgSize.width) / celSize.width
        WZLog("*********** 12347890 ********** 11111", costWordPointX, imgPointX, costNumPointX)
        txtCostWord:setRelativePosition(GlobalMethod:ccp(costWordPointX, 0.5))
        conCoinsIcon:setRelativePosition(GlobalMethod:ccp(imgPointX, 0.5))
        txtCostNum:setRelativePosition(GlobalMethod:ccp(costNumPointX, 0.5))
    end
    if nLevel >= nMaxLevel then
        GetElement(element, "btnUpgrade_CellBadgePanelItem", WZUIButton):setVisible(false)
        GetElement(element, "txtFullLevel_CellBadgePanelItem", WZUILabelTTF):setVisible(true)
        conNotMaxInfo:setVisible(false)
        GetElement(element, "txtPropertyWord_CellBadgePanelItem",WZUILabelTTF):setVisible(false)
        GetElement(element, "txtPropertyNum_CellBadgePanelItem",WZUILabelTTF):setVisible(false)
        GetElement(element, "imgArrow_CellBadgePanelItem",WZUIImage):setVisible(false)

        local txtLevelWord = GetElement(element, "txtLevelWord_CellBadgePanelItem", WZUILabelTTF)
        txtLevelWord:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        txtLevelWord:setRelativePosition(GlobalMethod:ccp(0.5, 0.71))

        local txtLevelNum = GetElement(element, "txtLevelNum_CellBadgePanelItem", WZUILabelTTF)
        txtLevelNum:setRelativePosition(GlobalMethod:ccp(0.5, 0.27))
        txtLevelWord:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    end
end

function WndDesignationMain:_rtnMaxLevelByType(nType)
    --body
    if GDatatab_badge_info == nil then return end

    local nMaxLevel = 1
    for key, value in pairs(GDatatab_badge_info) do
        if value.type == nType then
            if value.level > nMaxLevel then
                nMaxLevel = value.level
            end
        end
    end

    return nMaxLevel
end

--@brief    根据等级，类型获取相应的信息
--@param    nType:徽章类型
--@param    nLevel:当前等级
function WndDesignationMain:_getLevelTableInfo(nType, nLevel)
    -- body
    for key, value in pairs(GDatatab_badge_info) do
        if value.type == nType and value.level == nLevel then
            return value
        end
    end

    return nil
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
--@brief	初始化成就系统主界面的静态文本
function WndDesignationMain:_initStaticUI()
	WZLog("WndDesignationMain:_initStaticUI")
    local iconFile = self:_getIconFile(19)
    if iconFile ~= nil then
        GetElement(self.m_root, "imgGetAchiePointsIcon", WZUIImage):setFile(iconFile)
    end
end

--@brief    获取奖励物品的图标
function WndDesignationMain:_getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

function WndDesignationMain:setlingqubtnText( nText )
	-- body
	GetElement(self.m_root,"button_nor_Label",WZUILabelTTF):setText(nText)
	GetElement(self.m_root,"button_sel_Label",WZUILabelTTF):setText(nText)
	GetElement(self.m_root,"button_disable_Label",WZUILabelTTF):setText(nText)
end

--@brief    切换按钮字
function WndDesignationMain:_setChangeBtnText(text)
    -- body
    local txtBtnText = GetElement(self.m_root, "txtBtnText_WndDesignationMain", WZUILabelTTF)
    if txtBtnText then
        txtBtnText:setText(text)
    end
end
--@brief 英文适配函数
--@note  英文适配
function WndDesignationMain:_adaptLanguage_en()
    WZLog("WndDesignationMain:_adaptLanguage_en")

    local txt = GetElement(self.m_root,"txtAchiePointNum_WndDesignationMain",WZUILabelTTF)
    if txt then
        txt:setFontSize(18)
    end

    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setScale(0.8)
        txtMainTitle:setRelativePosition(GlobalMethod:ccp(-0.0095736,0.5))
        txtMainTitle:setDimensions(GlobalMethod:CCSize(260,0))
    end

    GetElement(self.m_root,"ftxtTotalProgress_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.55,0.680555))
    GetElement(self.m_root,"ftxtLeftAchieNum_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.55,0.380555))

    GetElement(self.m_root, "txtBtnText_WndDesignationMain", WZUILabelTTF):setScale(0.75)
end

function WndDesignationMain:_adaptLanguage_pt( )
    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setFontSize(16)
        txtMainTitle:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
        txtMainTitle:setDimensions(GlobalMethod:CCSize(220,0))
    end

    local txt = GetElement(self.m_root,"txtAchiePointNum_WndDesignationMain",WZUILabelTTF)
    if txt then
        txt:setFontSize(18)
    end
end


--@brief    越南语适配
function WndDesignationMain:_adaptLanguage_vn(  )
    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setFontSize(16)
        txtMainTitle:setDimensions(GlobalMethod:CCSize(190,0))
        txtMainTitle:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    end

    local txt = GetElement(self.m_root,"txtAchiePointNum_WndDesignationMain",WZUILabelTTF)
    if txt then
        txt:setFontSize(18)
    end
end

function WndDesignationMain:_adaptLanguage_tr(  )
    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setFontSize(18)
        txtMainTitle:setDimensions(GlobalMethod:CCSize(200,0))
        txtMainTitle:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
    end

    GetElement(self.m_root,"ftxtTotalProgress_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.55,0.680555))
    GetElement(self.m_root,"ftxtLeftAchieNum_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.58,0.380555))
end

function WndDesignationMain:_adaptLanguage_es(  )
    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setFontSize(16)
        --txtMainTitle:setRelativePosition(GlobalMethod:ccp(-0.03,0.5))
        txtMainTitle:setDimensions(GlobalMethod:CCSize(200,0))
    end

    local txt = GetElement(self.m_root,"txtAchiePointNum_WndDesignationMain",WZUILabelTTF)
    if txt then
        txt:setFontSize(18)
    end

    GetElement(self.m_root,"ftxtTotalProgress_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.63,0.680555))
    GetElement(self.m_root,"ftxtLeftAchieNum_WndDesignationMain",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.63,0.380555))
end

function WndDesignationMain:_adaptLanguage_th()
    local txtMainTitle = GetElement(self.m_root, "txtMainTitle_WndDesignationMain", WZUILabelTTF)
    if txtMainTitle then
        txtMainTitle:setFontSize(18)
        txtMainTitle:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    end
end
-------------------------------------语言适配模块End----------------------------------------
