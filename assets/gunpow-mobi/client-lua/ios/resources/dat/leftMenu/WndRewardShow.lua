--WndRewardShow.lua
--@brief	WndRewardShow的UI模块
--@date		2014/09/01
--@author	zsq
--@note		显示获得的奖励物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRewardShow:onEnter(element)
    GlobalGame.g_bIsRewardShow = true
	self.m_root = element
	self:_setInfo()
    
	--多语言版本界面适配
	AdaptLanguage(self)

	--WindowManagerAni:createAction(element,false,nil,nil)
    Teach:isStartTeach("WndRewardShow:onEnter")
    WindowManager:removeTeachShelterLayer()
end

--@brief onEnter函数执行完成回调
function WndRewardShow:onEnterTransitionDidFinish(element)
    --播放效果音效
    SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)

	GetElement(self.m_root,"ttf2_WndRewardShow",WZUILabelTTF):setText(LocalStrings.CLICKCONTINUE)
    
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndRewardShow:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRewardShow:onExit(element)
	NOTRECYCLEIDS = {}
    local taskId = self.m_nTaskId
    local isTeach = self.m_bIsTeach
	self:_unInit()

    GlobalGame.g_bIsRewardShow = nil
    if isTeach == nil then
        if GDatatab_story_talk and WndTeachTalk:IsNoExist() then
            for i ,v in pairs (GDatatab_story_talk) do
                if type(v.triggerWay) == "table" then
                    WZLog("WndRewardShow:onExit one",i,v.triggerWay[1][1],v.triggerWay[1][2],self.m_nTaskId)
                    if v.triggerWay[1][1] == TRIGGER_TASK_SUBMIT and v.triggerWay[1][2] == self.m_nTaskId then
                        WZLog("WndRewardShow:onExit two")
                        CreateStoryTalkGroup(v.storyId)
                        break
                    end
                end
            end
        end

        WZLog("WndRewardShow:onExit three", tostring(WndTask.m_root), tostring(WndSingleCopy.m_root))
        if WndTask.m_root then
            WndTask:teach()
        end

        if WndSingleCopy.m_root then
            local isEndTeach, teachStep = TeachGroup1:isTeachFinish(7)
            if isEndTeach ~= true and teachStep > 0 then
                TeachGroup1:startGroup({7,3,GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root})
            end
        end

        if taskId == TeachGroup1.TASK_ID_7 then
            if SceneCity.m_root == nil then
                replaceScene(SceneCity:createElement())
            else
                WZLog("WndRewardShow:onExit four")
                SceneCity.m_bIsNoRelease = true
                replaceScene(SceneCity:createElement(true))
            end
        end

        if taskId == -3 then
            TeachGroup1.WEAPONGET = true
        end
    end
end

--@brief	单击关闭按钮时被调用的函数
--@param   element:关闭按钮的节点
--@note		关闭后返回主界面
function WndRewardShow:onClose(element)
--	WZLog("WndRewardShow:onClose", debug.traceback())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
    if self.m_bIsClickClose then return end 
	--调用设置的回调函数
	if self.backFunc then
		self.backFunc[2](self.backFunc[1],self)
        if self.backFunc[3] and self.backFunc[4] then
            self.backFunc[4](self.backFunc[3])
        end
	end
    self.m_bIsClickClose = true
    if self.m_nodeMoveTo then 
        self.m_nAniIndex = 1
        self:_setNodeVisible()
        self.m_root:enableSchedule("createItemIconFlyAni", 0.03)
        return 
    end
    --活动中快捷卡开宝箱中还有宝箱没弹的情况
    pushEquipInList()
    -----------------------------------------
	self:onCloseCallback()
end

--@brief    创建飘飞动画
function WndRewardShow:createItemIconFlyAni()
    -- body
    WZLog("WndRewardShow:createItemIconFlyAni", self.m_nAniIndex, #self.m_tGoodElementList)
    local pt = self.m_nodeMoveTo:convertToWorldSpace(GlobalMethod:ccp(0,0))
    local actTime = 0.32
    if self.m_nAniIndex > #self.m_tGoodElementList then 
        self.m_root:disableSchedule()
        return 
    end
    local scaleAction = CCScaleTo:create(actTime, 0.05, 0.05)

    local ptRelative = self.m_tGoodElementList[self.m_nAniIndex]:convertToNodeSpace(pt)
    WZLog("WndRewardShow:onClose", pt.x, pt.y, ptRelative.x, ptRelative.y)
    ptRelative.x = ptRelative.x + 60
    ptRelative.y = ptRelative.y + 55
    local moveAction = CCMoveTo:create(actTime, ptRelative)
    local spawn = CCSpawn:createWithTwoActions(scaleAction, moveAction)
    local call
    if self.m_nAniIndex == #self.m_tGoodElementList then 
        call = CCCallFunc:create(function() 
                WndRewardShow:onCloseCallback()
            end)
    else
        call = CCCallFunc:create(function() 
                if WndRewardShow.m_tGoodElementList[self.m_nAniIndex] then 
                    WndRewardShow.m_tGoodElementList[self.m_nAniIndex]:setVisible(false)
                end
            end)
    end

    local actions = CCArray:create()
    actions:addObject(spawn)
    actions:addObject(call)
    local actionSequence = CCSequence:create(actions)
    self.m_tGoodElementList[self.m_nAniIndex]:runAction(actionSequence)
    self.m_nAniIndex = self.m_nAniIndex + 1
end

--@brief	关闭的回调函数
function WndRewardShow:onCloseCallback()
	WZLog("WndRewardShow:onCloseCallback")
	--关闭称号窗口
	WindowManagerAni:createDisappearAction(self.m_root,nil,self,true)
end

--@brief	设置窗口显示的奖励内容
--@param    vsName:物品名称数组
--@param    vsPath:物品图片路径数组
--@param    vnNum:物品数量数组
--@note		设置窗口显示的奖励内容
function WndRewardShow:getInfo( vsName,vsPath,vnNum )
	for i=1,#vsName do
		--WZLog("WndRewardShow:getInfo",vsName[i],vsPath[i],vnNum[i])
	    --print(vsName:get(i))
	    local name = vsName[i] --vsName:get(i)
	    local path = vsPath[i] --vsPath:get(i)
	    local num =  vnNum[i] --vnNum:get(i)
	    local itemInfo = {vsName=name,vsPath=path,vnNum=num} 
        table.insert(self.info,itemInfo)
	end
end

--@brief	窗口显示奖励内容
--@param    vsName:物品名称数组
--@param    vsPath:物品图片路径数组
--@param    vnNum:物品数量数组  传入数量为0或者nil则不显示
function WndRewardShow:showInterface(vsName,vsPath,vnNum)
    --如果已经打开，先关闭
    --Add By Tianxiang_Xu
    --主要是当连续获取两个及以上的礼包时，打开，除了第一个，后面的礼包物品不能展示的问题
    if self.m_root ~= nil then 
        WZLog("WndRewardShow:showInterface")
        --调用设置的回调函数
        if self.backFunc then
            self.backFunc[2](self.backFunc[1],self)
        end

        self:onCloseCallback()
    end
    --End Add

	if self.m_root == nil then
        WZLog("WndRewardShow:showInterface 00000 ")
		local Wnd = WndRewardShow:createElement()
			for i=1,#vsName do
				WZLog("WndRewardShow:getInfo",vsName[i],vsPath[i],vnNum[i])
			    local name = vsName[i] 
			    local path = vsPath[i] 
			    local num =  vnNum[i] 
			    local itemInfo = {name=name,icon=path,lastTime=num} 
		        table.insert(self.info,itemInfo)
			end
	    WindowManager:addWindow(Wnd , WndRewardShow ,nil ,nil ,nil, false)
	end
end

--@brief	窗口显示奖励内容
--@param    vnId:物品id数组
--@param    vnNum:物品数量数组  传入数量为0或者nil则不显示
--@param    nDisplayType:物品显示类型，不赋值时默认为16
--@param    bIsShowExchange : 足迹是否显示转化文字提示
--@param    fashionCount : 时装转化个数
--@param    nodeMoveTo: 用于将奖励物品图标动画飘到的节点
--@param    bIsPvpRankDrop: 是否排位掉落，true：显示：当前掉落次数/当天上限
function WndRewardShow:showById(vnId,vnNum,nDisplayType,taskId, bIsShowExchange, fashionCount, nodeMoveTo, bIsPvpRankDrop)
    if taskId == TeachGroup1.TASK_ID_3 or taskId == TeachGroup1.TASK_ID_7 then
        TeachGroup1:taskTeach(taskId)
    end
    --Add By Tianxiang_Xu
    --主要是当连续获取两个及以上的礼包时，打开，除了第一个，后面的礼包物品不能展示的问题
    if self.m_root ~= nil then 
        WZLog("WndRewardShow:showById")
        --调用设置的回调函数
        if self.backFunc then
            self.backFunc[2](self.backFunc[1],self)
        end

        self:onCloseCallback()
    end
    --End Add

	if self.m_root == nil then
		local Wnd = WndRewardShow:createElement()
        for i=1,#vnId do
            local key = "id_"..vnId[i]
            if GDatatab_item[key] ~= nil then
                local name = GDatatab_item[key].name
                local path = GDatatab_item[key].icon
                local num =  tonumber(vnNum[i])
                local quality = GDatatab_item[key].quality
                local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
                if WndSynthesisLeft and WndSynthesisLeft.m_tItemIdNum and vnId[i] == WndSynthesisLeft.m_tItemIdNum.id then
                    itemInfo.beforeUse = nil
                    itemInfo.beforeUse = WndSynthesisLeft.m_tItemIdNum.num
                end
                table.insert(self.info,itemInfo)
            else
                WZLog(key.."不在GDatatab_item")
            end
        end
        self.m_bIsShowExchangeText = bIsShowExchange
        self.m_nDisplayType = nDisplayType or 16
		self.fashionCount = fashionCount
        self:_updateTableContainerColumn(Wnd) --修改栏数一定要在onEnter之前调用才有用
        self.m_nTaskId = taskId
        self.m_nodeMoveTo = nodeMoveTo
        self.m_bIsPvpRankDrop = bIsPvpRankDrop
	    WindowManager:addWindow(Wnd , WndRewardShow ,nil ,nil ,nil, false)
	end
end

--@brief	设置窗口标题图片
--@param    sImage:图片路径
function WndRewardShow:setTitleImage(sImage)
    if self.m_root == nil then
        WZLog(debug.traceback())
        return
    end
    local imgTitle = GetElement(self.m_root, "imgTitle_WndRewardShow", WZUIImage)
    imgTitle:setScale(1)
    imgTitle:setFile(sImage)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------回调方法模块Begin----------------------------------------
--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndRewardShow:onClickItem(tItem, nTag, tData)
    WZLog("WndRewardShow:onClickItem ")
	if WndAscending.m_root ~= nil then return end
    local itemInfo = tData.basicInfo
    local itemId = itemInfo.id
    self.m_nSelectItemId = itemId
    if self.m_bIsShowBySendGift then
       tItem:setHightLightVisible(true)
       self.m_tSelectCell:setHightLightVisible(false)
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
    self.m_tSelectCell = tItem
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndRewardShow:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

--@brief    展示额外的提示文字
function WndRewardShow:showExtendWord(text)
    -- body
    if self.m_root == nil then return end 

    local txtPvpDrop = WZUILabelTTF:create()
    txtPvpDrop:setFontSize(20)
    txtPvpDrop:setColor(GlobalMethod:ccc3(229,105,22))
    txtPvpDrop:setText(text)
    txtPvpDrop:setRelativePosition(GlobalMethod:ccp(0.5, 0.46))
    self.m_root:addChild(txtPvpDrop)
end
-------------------------------------回调方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief设置列表内容的函数
function WndRewardShow:_setInfo()
	WZLog(" WndRewardShow:_setInfo()")
	if self.m_root == nil then 
		WZLog(" WndRewardShow:setInfo() self.m_root is nil ")
	end 
		
	local tabCon = GetElement(self.m_root, "tbconRewardList_WndRewardShow", WZUITableContainer)
	tabCon:setEnableGlScissor(false)
	tabCon:setRelativePosition(ccp(0.5,0.88))
	local conversion = false
    self.m_tGoodElementList = {}
	if tabCon ~= nil then 
		for i=0,#self.info-1 do
		   local celElement,tLuaObj = CellGoodItem:createElement()
           if celElement ~= nil then 
		    	celElement = WZUIContainer:luaTo(celElement)
                --tLuaObj:setCellGoodItem(self.info[i+1], self.m_nDisplayType or 4)
                tLuaObj:setCellGoodItem(self.info[i+1], self.m_nDisplayType or 16)
                tLuaObj:setItemClickFun(self, self.onClickItem)
                --tLuaObj:setItemCount(self.info[i+1].lastNum)
                if self.m_bIsShowBySendGift == true then
                   tLuaObj:_hightlight()
                   tLuaObj:setHightLightVisible(false)
                   if i == 0 then
                       	tLuaObj:setHightLightVisible(true)
                       	self.m_tSelectCell = tLuaObj
                       	self.m_nSelectItemId = self.info[i+1].basicInfo.id
                   end
                end
                celElement:setTag(i)
				local showConversion = tLuaObj:showConversion(self.m_bIsShowExchangeText, self.fashionCount)
				conversion = conversion or showConversion
                tabCon:setCellElement(celElement)
                table.insert(self.m_tGoodElementList, celElement)
           end
		end 
	end 
	
	self.conversion = conversion
	if self.conversion then
		GetElement(self.m_root,"bg2",WZUI9Image):setScaleY(1.21)
		tabCon:setRelativePosition(ccp(0.5,0.92))
	end

    if self.m_bIsPvpRankDrop then
        local tempData = CacheCenter:getGameParam().trioRankMatchRewardConfig
        local tTempInfo = json.decode(tempData)
        WZLog("DDDDDDDDDDDDDDDDDDD", tempData)
        local txtPvpDrop = WZUILabelTTF:create()
        txtPvpDrop:setFontSize(20)
        txtPvpDrop:setColor(GlobalMethod:ccc3(229,105,22))
        txtPvpDrop:setText(string.format(LocalStrings.PVPNEW_TEXT3, RANK_OVER_REWARD_COUNT, tTempInfo.limit))
        txtPvpDrop:setRelativePosition(GlobalMethod:ccp(0.5, 0.46))
        self.m_root:addChild(txtPvpDrop)
    end
end

--@brief 更新列表栏数
function WndRewardShow:_updateTableContainerColumn(root)
    local tabCon = GetElement(root, "tbconRewardList_WndRewardShow", WZUITableContainer)

	local length = #self.info
    if length > 5 then 
        length = 5
		GetElement(root,"bg1",WZUI9Image):setVisible(true)
		GetElement(root,"bg2",WZUI9Image):setVisible(false)
		GetElement(root,"spine",WZUISpine):setRelativePosition(GlobalMethod:ccp(0.5,2))
		GetElement(root,"spine",WZUISpine):setScale(1.45)
		GetElement(root,"ttf2_WndRewardShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,-0.27))
		tabCon:setCellElementHeight(0.5)
    	tabCon:setAbsContentSize(GlobalMethod:CCSize(100*length,200))
	else
		GetElement(root,"bg1",WZUI9Image):setVisible(false)
		GetElement(root,"bg2",WZUI9Image):setVisible(true)
		GetElement(root,"bg2",WZUI9Image):setScaleY(1)
		GetElement(root,"spine",WZUISpine):setRelativePosition(GlobalMethod:ccp(0.5,1.8))
		GetElement(root,"spine",WZUISpine):setScale(1.1)
		GetElement(root,"ttf2_WndRewardShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.15))
		tabCon:setCellElementHeight(1)
    	tabCon:setAbsContentSize(GlobalMethod:CCSize(100*length,112))
    end

    --Add By Tianxiang_Xu
    --local conList = root:getChildElement("conList_WndRewardShow")
    --WZUIContainer:luaTo(conList):setAbsContentSize(GlobalMethod:CCSize(100*length + 30, 200))

    tabCon:setColumnCount(length)
    tabCon:setEnableMoveVertical(true)
end

--@brief    设置节点不可见
function WndRewardShow:_setNodeVisible()
    -- body
    GetElement(self.m_root, "spine", WZUISpine):setVisible(false)
    GetElement(self.m_root, "conBg_WndRewardShow", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "btnOK_WndRewardShow", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "ttf2_WndRewardShow", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "imgTitle_WndRewardShow", WZUIImage):setVisible(false)
end
-------------------------------------私有方法模块End----------------------------------------
