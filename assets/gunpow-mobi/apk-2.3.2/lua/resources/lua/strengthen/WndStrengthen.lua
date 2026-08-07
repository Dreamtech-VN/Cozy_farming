--WndStrengthen.lua
--@brief	WndStrengthen的UI模块
--@date		2014/8/15
--@author	zsq
--@note		强化研究院窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndStrengthen:onEnter(element)
	self.m_root = element

	    --语言适配函数
	AdaptLanguage(self)
end

-- --@brief	旋转锻造图片
-- function WndStrengthen:rotatePic()
-- 	local img = GetElement(self.m_root,"InBg1_WndStrengthen",WZUIImage)
-- 	local actionRotateBy = CCRotateBy:create(10,360)
--     local action =  CCRepeatForever:create(actionRotateBy)
--     img:runAction(action)
-- end

function WndStrengthen:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_dz.png",WndStrengthen,WndStrengthen.onClose,true,false,false,"WndStrengthen",{goldType=1})
end

----@brief onEnter函数执行完成回调
function WndStrengthen:onEnterTransitionDidFinish(element)
    --初始化窗口标志
    self.m_nCurIndex = self.m_nOpenLayerIndex or 1

	self:createTitleBtn()

	--注册强化研究院相关协议
	ProtocolProcessorStrengthen:regAll()
	ProtocolProcessorMerge:regAll()
    ProtocolProcessorScenePets:regAll2()

	--注册缓存中心数据监听
	CacheCenter:registerUpatePlayerItemObserver(self)
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
	
	--设置界面ID	
	ChangeChatChannel(Chat_CHannel_Strengthen)

	--多语言版本界面适配
	AdaptLanguage(self)

	--添加顶部栏
	self:_addTop()

	--分辨率适配
	self:AdaptResolution()

	-- self:rotatePic()

    --左右容器移动动画
    local leftCon = GetElement(self.m_root,"conMidLeft_WndStrengthen",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,false)

    local rightCon = GetElement(self.m_root,"conMidRight_WndStrengthen",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(rightCon,1,false)

	--延迟一帧初始化强化研究院界面
	self.m_root:enableSchedule("_delayAdd1",0)

	
end

----@brief    弹窗动画完成后的回调
function WndStrengthen:_delayAdd1(element, dt)
	WZLog("WndStrengthen:_delayAdd1")
	self.m_root:disableSchedule()

	--初始化强化研究院界面
	self:_initStrengthenUI()

    --跳转标签
	self:jumpTab()
end

--@brief 	跳转标签
function WndStrengthen:jumpTab()
	if 1 == self.m_nCurIndex then
		self.m_nCurIndex = 0
		self:onIntensifySelect()
	elseif 2 == self.m_nCurIndex then
		self.m_nCurIndex = 0
		self:onImproveSelect()
	elseif 3 == self.m_nCurIndex then
		self.m_nCurIndex = 0
		self:onGemmountingSelect()
	elseif 4 == self.m_nCurIndex then
        self.m_nCurIndex = 0
        self:onGradeSelect()
    elseif 5 == self.m_nCurIndex then
        self.m_nCurIndex = 0
        self:onTransferSelect()
	end
end

----@brief    加载界面元素定时器
function WndStrengthen:scheduleLoadUI()
    --初始化强化研究院界面
	self:_changeWndowByCurIndex()
	self:_closeLoading()
    self.m_root:disableSchedule()
end

function WndStrengthen:scheduleLoadMaterial()
   	self.m_root:disableSchedule()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndStrengthen:onExit(element)
	ProtocolProcessorStrengthen:unregAll()
	ProtocolProcessorMerge:unregAll()
    ProtocolProcessorScenePets:unregAll2()

	--反注册缓存中心数据监听
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
    WndCurrentChat:showButtomChat()
	self:_unInit()
end

--@brief	关闭按钮回调函数
function WndStrengthen:onClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    TeachGroup1:endTeachStep({9,4})

	if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[2] then
		self.m_tBackFun[2](self.m_tBackFun[1],self.m_bStrengThen)
		self.m_bStrengThen = nil 
	end

	if WndBag then WndBag.m_bOpenStrengthen = false end

	--延迟刷新背包
	DelayCallFunction(CacheCenter._updatePlayerItemData,CacheCenter,0.1)
	DelayCallFunction(CacheCenter._updatePlayerInfoData,CacheCenter,0.05)

	--左右容器移动动画
	local leftCon = GetElement(self.m_root,"conMidLeft_WndStrengthen",WZUIContainer)
	WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.onActionCallBack,true)
end

function WndStrengthen:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
	local isEndTeach9, step9 = TeachGroup1:isTeachFinish(9)   
    WZLog("WndStrengthen:onActionCallBack", isEndTeach9, step9)
    if isEndTeach9 ~= true and step9 >= 4 then 
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvClickBack2)    
        if WndSingleCopy.m_root then 
            if step9 == 4 then 
                TeachGroup1:startGroup({9, 5, WndSingleCopy.m_root})
            else
                TeachGroup1:startGroup({9, 6, WndSingleCopy.m_root})
            end
        else
            SceneCopy:showScene(1)
        end
    end
end

function WndStrengthen:onTouchBegan(element,pt)
	WZLog("WndStrengthen:onTouchBegan",self.m_nCurIndex)
	if WndItemInfo.m_root ~= nil and not WndItemInfo:checkPoint(pt) then
		WndItemInfo:onCloseClick()
	end
    if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end

function WndStrengthen:onTouchEnd()
end

--@brief	强化复选框被选中时调用的函数
--@param	element:强化复选框的UI节点引用
--@note		在这里做强化复选框被选中时的响应操作
function WndStrengthen:onIntensifySelect(element)
	if self.m_nCurIndex ~= 0 then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	end
	if CheckButtonOpen(40) ~= true then return end
	if 1 == self.m_nCurIndex then
		return
	end
    --如果前一状态为洗练
    if self.m_nCurIndex == 4 then
		self.m_nCurIndex = 1
		--刷新右侧标签
    	self:_initEquipListByTag(self.m_nSaveRightIndex, false)
        self:setOnlyWeaponCanUse(2, true, 255)
    end
	self.m_nCurIndex = 1
    --显示/隐藏界面
    self:createTheInterface(true, false, false, false, false)
	--设置UI元素显示
	self:setUIDisplay(self.m_nCurIndex)
	--检查强化满级
	self:checkIntensifyLevel()

    --放入第一件装备
	self:addFirstWeapon()

    --装备列表红点
    self:showEquipsListRed()
end

--@brief	升星复选框被选中时调用的函数
--@param	element:升星复选框的UI节点引用
--@note		在这里做升星复选框被选中时的响应操作
function WndStrengthen:onImproveSelect(element)
    if self.m_nCurIndex ~= 0 then
	   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    end

    if CheckButtonOpen(41) ~= true then return end

	if 2 == self.m_nCurIndex then
		return
	end
    --如果前一状态为洗练
    if self.m_nCurIndex == 4 then
		self.m_nCurIndex = 2
		--刷新右侧标签
    	self:_initEquipListByTag(self.m_nSaveRightIndex)
        self:setOnlyWeaponCanUse(2, true, 255)
    end
	self.m_nCurIndex = 2
    --显示/隐藏界面
    self:createTheInterface(false, true, false, false, false)
	--设置UI元素显示
	self:setUIDisplay(self.m_nCurIndex)

	--检查强化满级
	self:checkIntensifyLevel()

    --放入第一件装备
	self:addFirstWeapon()

    --装备列表红点
    self:showEquipsListRed()

    local isEndTeach, step = TeachGroup1:isTeachFinish(10)
    if isEndTeach ~= true and step > 0 then
        TeachGroup1:endTeachStep({10,3})
        TeachGroup1:startGroup({10,4,WndImproveStrengthen.m_root})
    end
end

--@brief	镶嵌复选框被选中时调用的函数
--@param	element:镶嵌复选框的UI节点引用
--@note		在这里做镶嵌复选框被选中时的响应操作
function WndStrengthen:onGemmountingSelect(element)
    if self.m_nCurIndex ~= 0 then
	   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    end

    local isEndTeach, step = TeachGroup1:isTeachFinish(11)
    if isEndTeach ~= true and step > 0 then
        TeachGroup1:endTeachStep({11,3})
        TeachGroup1:startGroup({11,4,self.m_root})
	elseif CheckButtonOpen(43) ~= true then return end

	if 3 == self.m_nCurIndex then
		return
	end
    --如果前一状态为洗练
    if self.m_nCurIndex == 4 then
		self.m_nCurIndex = 3
		--刷新右侧标签
    	self:_initEquipListByTag(self.m_nSaveRightIndex)
        self:setOnlyWeaponCanUse(3, true, 255)
    end
	self.m_nCurIndex = 3
    --显示/隐藏界面
    self:createTheInterface(false, false, true, false, false)
	--设置UI元素显示
	self:setUIDisplay(self.m_nCurIndex)

	--检查强化满级
	self:checkIntensifyLevel()

    --放入第一件装备
	self:addFirstWeapon()

    --装备列表红点
    self:showEquipsListRed()
end

--@brief	转移复选框被选中时调用的函数
--@param	element:转移复选框的UI节点引用
--@note		在这里做转移复选框被选中时的响应操作
function WndStrengthen:onTransferSelect(element)
    if self.m_nCurIndex ~= 0 then
	   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    end

	if CheckButtonOpen(42) ~= true then return end

	if 5 == self.m_nCurIndex then
		return
	end
    --如果前一状态为洗练
    if self.m_nCurIndex == 4 then
		self.m_nCurIndex = 5
		--刷新右侧标签
    	self:_initEquipListByTag(self.m_nSaveRightIndex)
        self:setOnlyWeaponCanUse(5, true, 255)
    end
	self.m_nCurIndex = 5
    --显示/隐藏界面
    self:createTheInterface(false, false, false, false, true)
	--设置UI元素显示
	self:setUIDisplay(self.m_nCurIndex)

	--检查强化满级
	self:checkIntensifyLevel()

    --放入第一件装备
	self:addFirstWeapon()

    --装备列表红点
    self:showEquipsListRed()
end

--@brief	升品复选框被选中时调用的函数
function WndStrengthen:onGradeSelect(element)
    if self.m_nCurIndex ~= 0 then
	   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    end

	if CheckButtonOpen(119) ~= true then return end

	if 4 == self.m_nCurIndex then
		return
	end
	self.m_nCurIndex = 4

    --显示/隐藏界面
    self:createTheInterface(false, false, false, true, false)
	--设置UI元素显示
	self:setUIDisplay(self.m_nCurIndex)
	--刷新右侧标签
   	self:_initEquipListByTag(self.m_nSaveRightIndex, false)

	--检查强化满级
	self:checkIntensifyLevel()

	local tEquip = self.m_tCurSelectedEquip
	if tEquip ~= nil then
        if tEquip.basicInfo.main_type ~= 6 and tEquip.basicInfo.quality ~= 4 then
            self:_addWeaponToCell(nil,nil,true)
			WndGradeStrengthen:cleanWnd()
        end
    else
        self:_addWeaponToCell(nil,nil,true)
		WndGradeStrengthen:cleanWnd()
    end
    
    --放入第一件装备
	self:addFirstWeapon()

    --装备列表红点
    self:showEquipsListRed()
end

function WndStrengthen:jumpOrange()
	WZLog("WndStrengthen:jumpOrange")
	if WndStrengthen.m_nCurIndex == 4 and WndGradeStrengthen.m_bRunning == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	JumpByUIId(177)
end

--@brief    设置右边选框只有武器栏高亮，其他栏不可点
function WndStrengthen:setOnlyWeaponCanUse(nCurIndex, bCanTouch, nOpacity)
    -- body
end

--@brief    当点击相应项的时候，才创建相应的界面
--@param    bIntensify:强化界面是否可见：true->可见；false->隐藏
--@param    bImprove:升星界面是否可见：true->可见；false->隐藏
--@param    bGemMount:镶嵌界面是否可见：true->可见；false->隐藏
--@param    bSophistic:洗练界面是否可见：true->可见；false->隐藏
--@param    bTransfer:继承界面是否可见：true->可见；false->隐藏
function WndStrengthen:createTheInterface(bIntensify, bImprove, bGemMount, bSophistic, bTransfer)
    -- body
    local conCurWindow = GetElement(self.m_root,"conCurWindow_WndStrengthen",WZUIContainer)
    if conCurWindow == nil then return end

    self:setEquipVisible(not bGemMount)

    if self.m_tIntensifyElement then
        self.m_tIntensifyElement:setVisible(bIntensify)
    elseif not self.m_tIntensifyElement and bIntensify then
        --创建强化界面
        self.m_tIntensifyElement = WndIntensifyStrengthen:createElement()
        self.m_tIntensifyLuaObj = WndIntensifyStrengthen
        conCurWindow:addChild(self.m_tIntensifyElement)
        self.m_tIntensifyElement:setVisible(bIntensify)
        WndIntensifyStrengthen:addEquipToCell(self.m_tCurSelectedEquip)
    end
    if self.m_tImproveElement then
        self.m_tImproveElement:setVisible(bImprove)
    elseif not self.m_tImproveElement and bImprove then
        --创建升星界面
        self.m_tImproveElement = WndImproveStrengthen:createElement()
        self.m_tImproveLuaObj = WndImproveStrengthen
        conCurWindow:addChild(self.m_tImproveElement)
        self.m_tImproveElement:setVisible(bImprove)
        WndImproveStrengthen:addEquipToCell(self.m_tCurSelectedEquip)
    end
    if self.m_tGemMountingElement then
        self.m_tGemMountingElement:setVisible(bGemMount)
    elseif not self.m_tGemMountingElement and bGemMount then
        --创建镶嵌界面
        self.m_tGemMountingElement = WndGemMountingStrengthen:createElement()
        self.m_tGemMountingLuaObj = WndGemMountingStrengthen
        conCurWindow:addChild(self.m_tGemMountingElement)
        self.m_tGemMountingElement:setVisible(bGemMount)
        WndGemMountingStrengthen:addEquipToCell(self.m_tCurSelectedEquip)
    end
    if self.m_tSophisticElement then
        self.m_tSophisticElement:setVisible(bSophistic)
    elseif not self.m_tSophisticElement and bSophistic then
        --创建洗练界面
        self.m_tSophisticElement = WndGradeStrengthen:createElement()
        self.m_tSophisticLuaObj = WndGradeStrengthen
        conCurWindow:addChild(self.m_tSophisticElement)
        self.m_tSophisticElement:setVisible(bSophistic)
        WndGradeStrengthen:addEquipToCell(self.m_tCurSelectedEquip)
    end
    if self.m_tTransferElement then
        self.m_tTransferElement:setVisible(bTransfer)
    elseif not self.m_tTransferElement and bTransfer then
        --创建转移界面
        self.m_tTransferElement = WndTransferStrengthen:createElement()
        self.m_tTransferLuaObj = WndTransferStrengthen
        conCurWindow:addChild(self.m_tTransferElement)
        self.m_tTransferElement:setVisible(bTransfer)
        WndTransferStrengthen:addEquipToCell(self.m_tCurSelectedEquip, self.m_nEquipTag)
    end
end

--@brief	设置UI元素显示
function WndStrengthen:setUIDisplay(index)
    local txtEquipLevel = GetElement(self.m_root,"txtEquipLevel_WndStrengthen",WZUILabelTTF)
	if self.m_tCurSelectedEquip ~= nil then
		self:setTxtEquipLevel(index, self.m_tCurSelectedEquip, txtEquipLevel)
	end
	GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
	local conEquipIcon = GetElement(self.m_root, "conEquipIcon_WndStrengthen", WZUIContainer)
	if index == 1 then
		GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(true)
		conEquipIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		conEquipIcon:setVisible(true)
    	GetElement(self.m_root, "conEquipLevel_WndStrengthen", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.18))
		GetElement(self.m_root, "conArmature_WndStrengthen", WZUIContainer):setVisible(true)
	elseif index == 2 then
		GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
		conEquipIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		conEquipIcon:setVisible(true)
    	GetElement(self.m_root, "conEquipLevel_WndStrengthen", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.18))
		GetElement(self.m_root, "conArmature_WndStrengthen", WZUIContainer):setVisible(true)
	elseif index == 3 then
		GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
		conEquipIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
		conEquipIcon:setVisible(true)
    	GetElement(self.m_root, "conEquipLevel_WndStrengthen", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conMidBg", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.8))
		GetElement(self.m_root, "conArmature_WndStrengthen", WZUIContainer):setVisible(true)
	elseif index == 4 then
		GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(true)
        conEquipIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.66))
        conEquipIcon:setVisible(true)
        GetElement(self.m_root, "conEquipLevel_WndStrengthen", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMidBg", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMidBg", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.18))
		GetElement(self.m_root, "conArmature_WndStrengthen", WZUIContainer):setVisible(true)
    elseif index == 5 then
        conEquipIcon:setVisible(false)
        GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "conEquipLevel_WndStrengthen", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMidBg", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conArmature_WndStrengthen", WZUIContainer):setVisible(false)
	end

    --光圈
   	self:setAperture()
    --加号
    self:setPlusShow()
end

--@brief 	设置"+"加号图标显示
function WndStrengthen:setPlusShow()
    local imgAddIcon = GetElement(self.m_root, "imgAddIcon_WndStrengthen", WZUIImage)
    if self.m_nCurIndex == 4 then
    	imgAddIcon:setVisible(false)
    else
	    if self.m_weaponLuaObj.m_tItem == nil then
	   		imgAddIcon:setVisible(true)
	    else
	   		imgAddIcon:setVisible(false)
	    end
	end
end

--@brief 	强化研究院跳转接口
--@brief 	nIndex:界面索引（1-5：强化、升星、镶嵌、洗练、转移）
function WndStrengthen:jumpTo(nIndex)
    if self.m_root ~= nil then
        return
    end
    WZLog("WndStrengthen:jumpTo", nIndex)
	local wndStrengthenElement = WndStrengthen:createElement()
    self.m_nOpenLayerIndex = nIndex or 1
	WindowManager:addWindow(wndStrengthenElement, WndStrengthen)
end

--@brief 	装备跳转
--@param 	nIndex:界面索引（1-5：强化、升星、镶嵌、洗练、转移）
--@param 	playerItemId:装备playerItemId
--@param 	lua:回调的表名
--@param 	backFun:回调方法名
function WndStrengthen:jumpToAddEquip(nIndex, playerItemId,lua,backFun)
    --添加装备到cell
    local tempEquip = nil
    local tEquipItems = CacheCenter:getPlayerAndPetEquipList()
    for i,v in pairs(tEquipItems) do
        if playerItemId == v.playerItemId then
            tempEquip = v
            break
        end
    end
    local wndStrengthenElement = WndStrengthen:createElement()
    self.m_nOpenLayerIndex = nIndex or 1
    self.m_tOpenLayerEquip = tempEquip
    WindowManager:addWindow(wndStrengthenElement, WndStrengthen)
end

-- --@brief    装备跳转
-- --@param    nIndex:界面索引（1-5：强化、升星、镶嵌、洗练、转移）
-- --@param    playerItemId:装备playerItemId
-- --@param    lua:回调的表名
-- --@param    backFun:回调方法名
-- function WndStrengthen:jumpToAddPetEquip(nIndex, playerItemId,lua,backFun)
--     --添加装备到cell
--     local tempEquip = nil
--     local tEquipItems = CacheCenter:getPetsEquipmentList()
--     for i,v in pairs(tEquipItems) do
--         if playerItemId == v.playerItemId then
--             tempEquip = v
--             break
--         end
--     end
--     local wndStrengthenElement = WndStrengthen:createElement()
--     self.m_nOpenLayerIndex = nIndex or 1
--     self.m_tOpenLayerEquip = tempEquip
--     WindowManager:addWindow(wndStrengthenElement, WndStrengthen)
-- end

--@brief	收到缓存推送后更新装备信息
function WndStrengthen:updatePlayerItemData()
	if self.m_nCurIndex == 1 then
		if WndIntensifyStrengthen.m_tCurSelectedEquip == nil then return end
		--锻造界面
		--找到更新后的被强化装备
		local tEquip
		local equipList = CacheCenter:getPlayerAndPetEquipList()
		for k,v in pairs(equipList) do
			if v.playerItemId == WndIntensifyStrengthen.m_tCurSelectedEquip.playerItemId then
				tEquip = v
				break 
			end
		end
        self.m_bReloadEquipList = false
    	self:_addWeaponToCell(tEquip)
	elseif self.m_nCurIndex == 2 then
		if WndImproveStrengthen.m_tCurSelectedEquip == nil then return end
		--升星界面
		--找到更新后的被升星装备
		-- local tEquip
		-- local equipList = CacheCenter:getPlayerAndPetEquipList()
		-- for k,v in pairs(equipList) do
		-- 	if v.playerItemId == WndImproveStrengthen.m_tCurSelectedEquip.playerItemId then
		-- 		tEquip = v
		-- 	end
		-- end
  --       self.m_bReloadEquipList = false
  --   	self:_addWeaponToCell(tEquip)
	elseif self.m_nCurIndex == 3 then
		--更新宝石信息
		if WndGemMountingStrengthen.m_nUpgradeGemId == nil then return end
		local gemData = GDatatab_item["id_"..WndGemMountingStrengthen.m_nUpgradeGemId]
    	local subtype = gemData.sub_type
    	local stoneid = gemData.id
    	if subtype == 0 then
    	    WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo.hpStone = stoneid
    	elseif subtype == 1 then
    	    WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo.attackStone = stoneid
    	elseif subtype == 2 then
    	    WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo.defendStone = stoneid
    	elseif subtype == 5 then
    	    WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo.gongmingStone = stoneid
    	end
    	WndStrengthen:updateCellEquip(self.m_tCurSelectedEquip)
		WndGemMountingStrengthen.m_nUpgradeGemId = nil
    elseif self.m_nCurIndex == 4 then
        if WndGradeStrengthen.m_root then
            WndGradeStrengthen:updateMNum()
        end
		--找到更新后的被升星装备
		if WndGradeStrengthen.m_tEquipBefore ~= nil then
			local tEquip
			local equipList = CacheCenter:getPlayerAndPetEquipList()
			for k,v in pairs(equipList) do
				if v.playerItemId == WndGradeStrengthen.m_tEquipBefore.playerItemId then
					tEquip = v
					break 
				end
			end
        	self.m_bReloadEquipList = false
    		self:_addWeaponToCell(tEquip)
		end
    	self:_initEquipListByTag(self.m_equipClassifyIndex)
	end
end

--@brief    锻造装备后更新装备信息
--@param    tNewEquip:锻造后的装备
--@author   hyq
function WndStrengthen:updateCellEquip(tNewEquip,tag)
    local tag = tag or 0
    self.m_bReloadEquipList = false
    self:_addWeaponToCell(tNewEquip,tag)
end

--@brief	显示装备等级
function WndStrengthen:setTxtEquipLevel(index, tEquip, element)
	if index == 1 then
        local equipType = tEquip.basicInfo.main_type == 43 and 2 or 1
        local nTabMaxLv = WndIntensifyStrengthen:getMaxStrengthLvByQuality(tEquip.basicInfo.quality,equipType)
		if tEquip.basicInfo.quality == 4 then
			local showMaxLevel = tonumber(CacheCenter:getPlayerInfo().level*2)
			local nTempMaxLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel) * 2
			if showMaxLevel > nTempMaxLevel then showMaxLevel = nTempMaxLevel end
            showMaxLevel = math.min(showMaxLevel,nTabMaxLv)
			element:setText(LocalStrings.LV..tEquip.extraInfo.strongLevel.."/"..(showMaxLevel))
		else
            local showMaxLevel = CacheCenter:getPlayerInfo().level
            showMaxLevel = math.min(showMaxLevel,nTabMaxLv)
			element:setText(LocalStrings.LV..tEquip.extraInfo.strongLevel.."/"..showMaxLevel)
		end
	elseif index == 2 then
		element:setText(LocalStrings.LV..tEquip.extraInfo.starLevel.."/"..WndImproveStrengthen.m_nMaxStarLevel)
	end
end

--@brief    添加装备到cell
--@param    tEquip：装备table
--@param    tag：装备tag
--@param    是否从背包跳转进入：jumpIn
function WndStrengthen:_addWeaponToCell(tEquip,tag,jumpIn, isUpdata)
    if self.m_root == nil then
        return
    end
    isUpdata = isUpdata or nil
    local tag = tag or 0
    self.m_nEquipTag = tag
    self.m_tCurSelectedEquip = tEquip

    --装备名
    local txtEquipName = GetElement(self.m_root,"txtEquipName_WndStrengthen",WZUILabelTTF)
    local txtEquipLevel = GetElement(self.m_root,"txtEquipLevel_WndStrengthen",WZUILabelTTF)
    --添加装备到cell
    if tEquip ~= nil then
        self.m_weaponLuaObj:setCellGoodItem(tEquip,15) --添加到cell
        txtEquipName:setText(tEquip.basicInfo.name)
        txtEquipName:setColor(QUALITYCOLOR[tEquip.basicInfo.quality])
		self:setTxtEquipLevel(self.m_nCurIndex, tEquip, txtEquipLevel)
        --“装备“ 文字
        -- GetElement(self.m_root,"txtEquipWord_WndStrengthen",WZUILabelTTF):setVisible(false)
		txtEquipLevel:setVisible(true)
   		-- GetElement(self.m_weaponElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)

    else
        self.m_weaponLuaObj:removeAllChild()--清空cell
   		-- GetElement(self.m_weaponElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
        txtEquipName:setText("")
		txtEquipLevel:setText("")
        -- GetElement(self.m_root,"txtEquipWord_WndStrengthen",WZUILabelTTF):setVisible(true)

    end
    --重新创建装备列表
	if jumpIn then
        WZLog("1111111111111111111111111111111111111111")
    	self:_initEquipListByTag(self.m_equipClassifyIndex)
	else
        WZLog("2222222222222222222222222222222222222222")
    	self:_initEquipListByTag(self.m_equipClassifyIndex, true)
	end

    --初始化强化界面
    if WndIntensifyStrengthen.m_root then
        WndIntensifyStrengthen:addEquipToCell(tEquip)
    end
    --初始化升星界面
    if WndImproveStrengthen.m_root then
        WndImproveStrengthen:addEquipToCell(tEquip, isUpdata)
    end
    --初始化镶嵌界面
    if WndGemMountingStrengthen.m_root then
        WndGemMountingStrengthen:addEquipToCell(tEquip)
    end
    --初始化洗练界面
    if WndGradeStrengthen.m_root then
        WndGradeStrengthen:addEquipToCell(tEquip)
    end
    --初始化转移界面
    if WndTransferStrengthen.m_root then
        WndTransferStrengthen:addEquipToCell(tEquip,tag)
    end

    --光圈
   	self:setAperture()
    --加号
    self:setPlusShow()

	self:checkIntensifyLevel()

    -- --红点
    -- CacheCenter:updateStrengthenRed()
    --标题红点
    self:setRedDot()
end
--@brief    获取当前选择的装备table
--@author   hyq
function WndStrengthen:getCurSelectedEqiup()
    return  self.m_tCurSelectedEquip
end
--@brief    装备cell被点击时调用
--@author   zsq
function WndStrengthen:onWeaponClicked()
    local tEquip = nil
    --装备cell是否为空
    if self.m_weaponLuaObj.m_tItem == nil then
        --添加推荐装备
        tEquip = self:getRecommendEquip() --获取推荐装备
    end
    --添加装备
	if self.m_nCurIndex == 4 then
		if tEquip ~= nil and tEquip.basicInfo.quality == 4 then
    		self.m_bReloadEquipList = false
    		self:_addWeaponToCell(tEquip)
		else
			MsgBoxManager:showTipBox(LocalStrings.NOORANGE1)
		end
	else
    	self.m_bReloadEquipList = false
    	self:_addWeaponToCell(tEquip)
	end
end

--@brief    放入当前列表第一件装备
function WndStrengthen:addFirstWeapon()
    --装备cell是否为空
    if self.m_weaponLuaObj.m_tItem == nil then
    	if self.m_tEquipList and self.m_tEquipList[1] then
	    	local tEquip = self.m_tEquipList[1]
		    --添加装备
			if self.m_nCurIndex == 4 then
				if tEquip.basicInfo.main_type == 6 and tEquip.basicInfo.quality == 4 then
		    		self.m_bReloadEquipList = false
		    		self:_addWeaponToCell(tEquip,nil,true)
				end
			else
		    	self.m_bReloadEquipList = false
		    	self:_addWeaponToCell(tEquip,nil,true)
			end
		end
    end
end

--@brief    装备栏中装备cell被点击时调用
--@author   hyq
function WndStrengthen:equipListCellClicked(tEquip)
    --添加或替换装备
    self.m_bReloadEquipList = false
    self:_addWeaponToCell(tEquip)
	WndGradeStrengthen:updateLucky(tEquip)
end

--@brief    获取武器列表
function WndStrengthen:getWeaponList()
    --body
    local t = {}
    local tEquipItems = CacheCenter:getPlayerAndPetEquipList()
    for i,v in pairs(tEquipItems) do
        if v.subtype == 0 or v.subtype == 1 then --武器
            table.insert(t,v)
        end
    end
    
    return t
end
--@brief	获取推荐装备
--@param 	装备推荐优先级（1-8：武器、服装、发型、表情、翅膀、项链、戒指1、戒指2）
--@author	hyq
function WndStrengthen:getRecommendEquip()
    local tEquip = nil
    local tEquipItems = CacheCenter:getPlayerAndPetEquipList()
    if tEquipItems ~= nil then
        if self.m_nCurIndex == 4 then
            tEquipItems = self:getWeaponList()
            if tEquipItems then
				for k,v in pairs(tEquipItems) do
					v.sortType = 1
				end
                table.sort(tEquipItems, _sortEquip)
            end
        else
			for k,v in pairs(tEquipItems) do
				v.sortType = 1
			end
            table.sort(tEquipItems, _sortEquip)
        end
        tEquip = tEquipItems[1]
    end
    --强化界面：品质高，强化等级小于最高等级
    --升星界面：品质高，升星等级小于最高等级
    --镶嵌界面：品质高，未镶嵌
    --转移界面：品质高
    return tEquip
end

--@brief    获取推荐装备2
function WndStrengthen:getRecommendEquip2()
    local tEquip = nil
    local tEquipItems = CacheCenter:getPlayerAndPetEquipList()
    if tEquipItems ~= nil then
        for k,v in pairs(tEquipItems) do
            v.sortType = 1
        end
        table.sort(tEquipItems, _sortEquip)

        tEquip = tEquipItems
    end
    --强化界面：品质高，强化等级小于最高等级
    --升星界面：品质高，升星等级小于最高等级
    --镶嵌界面：品质高，未镶嵌
    --转移界面：品质高
    return tEquip
end

--@brief    装备分类 身上标签被点击
--@author   hyq
function WndStrengthen:onCheckBodySelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 1
	self.m_nSaveRightIndex = 1
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    装备分类 武器标签被点击
--@author   hyq
function WndStrengthen:onCheckWeaponSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 2
	self.m_nSaveRightIndex = 2
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    装备分类 宝物标签被点击
--@author   hyq
function WndStrengthen:onCheckTreasureSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 3
	self.m_nSaveRightIndex = 3
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end

--@brief    装备分类 勋章标签被点击
--@author   hyq
function WndStrengthen:onCheckMedalSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 4
	self.m_nSaveRightIndex = 4
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    装备分类 戒指标签被点击
--@author   hyq
function WndStrengthen:onCheckRingSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 5
	self.m_nSaveRightIndex = 5
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    装备分类 项链标签被点击
--@author   hyq
function WndStrengthen:onCheckNeckLaceSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 6
	self.m_nSaveRightIndex = 6
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    装备分类 手镯标签被点击
--@author   hyq
function WndStrengthen:onCheckBraceletSelected()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_equipClassifyIndex = 7
	self.m_nSaveRightIndex = 7
    self:_initEquipListByTag(self.m_equipClassifyIndex)
end
--@brief    选择装备后更新装备列表
function WndStrengthen:updateEquipList(tEquip)
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nCurIndex ~= 5 then return end
    self.m_tCurSelectedEquip2 = tEquip
    self.m_bReloadEquipList = false
    self:_initEquipListByTag(self.m_equipClassifyIndex, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化强化研究院界面
--@note		初始化强化研究院界面
function WndStrengthen:_initStrengthenUI()
    --获取各界面的节点
    local conCurWindow = GetElement(self.m_root,"conCurWindow_WndStrengthen",WZUIContainer)
    if conCurWindow == nil then return end
    --创建装备cell
    local conEquip = GetElement(self.m_root,"conEquipIcon_WndStrengthen",WZUIContainer)
    self.m_weaponElement, self.m_weaponLuaObj = CellGoodItem:createElement()
    self.m_weaponLuaObj:setItemClickFun(self,self.onWeaponClicked)
    if self.m_weaponElement ~= nil and self.m_weaponLuaObj ~= nil then
        conEquip:addChild(self.m_weaponElement)
        --self.m_weaponElement:setScale(0.9)
   		GetElement(self.m_weaponElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
   		GetElement(self.m_weaponElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   		GetElement(self.m_weaponElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
   		GetElement(self.m_weaponElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
    end
    --创建强化界面
    if self.m_nCurIndex == 1 then
        self.m_tIntensifyElement = WndIntensifyStrengthen:createElement()
        self.m_tIntensifyLuaObj = WndIntensifyStrengthen
        conCurWindow:addChild(self.m_tIntensifyElement)
        self.m_tIntensifyElement:setVisible(true)
    end
    --创建升星界面
    if self.m_nCurIndex == 2 then
        self.m_tImproveElement = WndImproveStrengthen:createElement()
        self.m_tImproveLuaObj = WndImproveStrengthen
        conCurWindow:addChild(self.m_tImproveElement)
        self.m_tImproveElement:setVisible(true)
    end
    --创建镶嵌界面
    if self.m_nCurIndex == 3 then
        self.m_tGemMountingElement = WndGemMountingStrengthen:createElement()
        self.m_tGemMountingLuaObj = WndGemMountingStrengthen
        conCurWindow:addChild(self.m_tGemMountingElement)
        self.m_tGemMountingElement:setVisible(true)
    end
    --创建洗练界面
    if self.m_nCurIndex == 4 then
        self.m_tSophisticElement = WndGradeStrengthen:createElement()
        self.m_tSophisticLuaObj = WndGradeStrengthen
        conCurWindow:addChild(self.m_tSophisticElement)
        self.m_tSophisticElement:setVisible(true)
    end
    --创建转移界面
    if self.m_nCurIndex == 5 then
        self.m_tTransferElement = WndTransferStrengthen:createElement()
        self.m_tTransferLuaObj = WndTransferStrengthen
        conCurWindow:addChild(self.m_tTransferElement)
        self.m_tTransferElement:setVisible(true)
    end

    --是否是从背包进入
    if self.m_tOpenLayerEquip ~= nil then
        self:_addWeaponToCell(self.m_tOpenLayerEquip,nil,true)
    else
        --初始化装备栏
        self:_initEquipListByTag(self.m_equipClassifyIndex)
    end

    --放入第一件装备
	self:addFirstWeapon()

end

--@brief    设置光圈
function WndStrengthen:setAperture()
	local colorIndex = 1
	if self.m_weaponLuaObj.m_tItem ~= nil then
		colorIndex = self.m_weaponLuaObj.m_tItem.basicInfo.quality
	end

	--洗练界面显示橙色光圈
	if self.m_nCurIndex == 4 then
		colorIndex = 4
	end

	for i=1,4 do
		local armature = GetElement(self.m_root,"armature"..i.."_WndStrengthen",WZArmature)
		armature:setVisible(i==colorIndex)
	end
end

--@brief    初始化装备列表
--@param    checkBoxTag:装备分类标签:1身上，2武器，3宝物，4勋章，5戒指，6项链，7手镯
--@param    bDontReet:默认为false,重新刷新列表位置，true:列表保持当前的位置不变
--@note     身上：玩家正在穿戴的装备，武器：背包中的所有武器
--author    hyq
function WndStrengthen:_initEquipListByTag(_checkBoxTag, bDontReset)
	WZLog("WndStrengthen:_initEquipListByTag", bDontReset)
    self.m_bDontResetListY = bDontReset or false
    local checkBoxTag = _checkBoxTag or 1 --装备分类标志
    if CacheCenter:hasPlayerItems() then
        local tEquipItems = CopyTable(CacheCenter:getEquipList(true))
        --local tEquipItems = CacheCenter:getEquipList()
        --1身上：tEquipItems[i].isUse == true
        --2武器：subtype == 0(投掷武器) or 1(射击武器)
        --3宝物：subtype == 5
        --4勋章：subtype == 6
        --5戒指：subtype == 2
        --6项链：subtype == 3
        --7手镯：subtype == 4
        --遍历装备table找出与equipType对应的装备
        local t = {}
        for i,v in pairs(tEquipItems) do
			local needOrange = false
			if self.m_nCurIndex == 4 then
				needOrange = true
				if v.basicInfo.quality == 4 then
					needOrange = false
				end
			end
            local isInsertData = true
            if self.m_tCurSelectedEquip2 ~= nil and v.playerItemId == self.m_tCurSelectedEquip2.playerItemId then
                isInsertData = false
            end
            if isInsertData and (self.m_tCurSelectedEquip ~= nil and self.m_tCurSelectedEquip.playerItemId == v.playerItemId) then
				v.hightlight = true
			else
				v.hightlight = false
			end

			local notTimeLimit = (v.basicInfo.time_limit == -1)

                if checkBoxTag == 1 and v.isUse and (not needOrange) and notTimeLimit then --身上：使用中
					if v.subtype == 0 or v.subtype == 1 then v.sortType = 1 end
					if v.subtype == 4 then v.sortType = 2 end
					if v.subtype == 3 then v.sortType = 3 end
					if v.subtype == 5 then v.sortType = 4 end
					if v.subtype == 2 then v.sortType = 5 end
					if v.subtype == 6 then v.sortType = 6 end
					if v.subtype == 7 then v.sortType = 7 end
					if v.subtype == 8 then v.sortType = 8 end
                    table.insert(t,v)
                elseif checkBoxTag == 2 and (v.subtype == 0 or v.subtype == 1) and (not needOrange) and notTimeLimit then --武器
					v.sortType = 1
                    table.insert(t,v)
                elseif checkBoxTag == 3 and (v.subtype ~= 0 and v.subtype ~= 1) and (not needOrange) and notTimeLimit then --宝物
					v.sortType = 1
					if v.subtype == 4 then v.sortType = 2 end
					if v.subtype == 3 then v.sortType = 3 end
					if v.subtype == 5 then v.sortType = 4 end
					if v.subtype == 2 then v.sortType = 5 end
					if v.subtype == 6 then v.sortType = 6 end
					if v.subtype == 7 then v.sortType = 7 end
					if v.subtype == 8 then v.sortType = 8 end
                    table.insert(t,v)
                end
        end
        table.sort(t, _sortEquip)

        --宠物装备
        local t2 = {}
        local tPetsEquipment = CopyTable(CacheCenter:getPetsEquipmentList())
        for i,v in pairs(tPetsEquipment) do
            local needOrange = false
            if self.m_nCurIndex == 4 then
                needOrange = true
                -- if v.basicInfo.quality == 4 then
                --     needOrange = false
                -- end
            end
            local isInsertData = true
            if self.m_tCurSelectedEquip2 ~= nil and v.playerItemId == self.m_tCurSelectedEquip2.playerItemId then
                isInsertData = false
            end
            if isInsertData and (self.m_tCurSelectedEquip ~= nil and self.m_tCurSelectedEquip.playerItemId == v.playerItemId) then
                v.hightlight = true
            else
                v.hightlight = false
            end

            local notTimeLimit = (v.basicInfo.time_limit == -1)

            if v.isUse and (not needOrange) and notTimeLimit then --身上：使用中
                table.insert(t,v)
            end
        end
        table.sort(t2, function (a,b)
            if a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel ~= b.extraInfo.strongLevel then
                return a.extraInfo.strongLevel > b.extraInfo.strongLevel
            else
                if a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel ~= b.extraInfo.starLevel then
                    return a.extraInfo.starLevel > b.extraInfo.starLevel
                else
                    --装备部位
                    if a.subtype == b.subtype then
                        --1使用中
                        if a.isUse == b.isUse then
                            --2品质从高到低
                            if a.basicInfo.quality == b.basicInfo.quality then
                                --3战斗力
                                if a.extraInfo.fight == b.extraInfo.fight then
                                    --装备ID从低到高
                                    return a.id < b.id
                                else
                                    return a.extraInfo.fight > b.extraInfo.fight
                                end
                            else
                                return a.basicInfo.quality > b.basicInfo.quality
                            end
                        else
                            if a.isUse then
                                return true
                            else
                                return false
                            end
                        end
                    else
                       return a.subtype < b.subtype
                    end
                end
            end
        end)


        --获取table节点
        local tbconEquip = GetElement(self.m_root,"tbMyEquipList_WndStrengthen", WZUITableContainer)
        self.m_nConListPositionY = tbconEquip:getMoveElement():getPositionY()
        if tbconEquip == nil then return end
        if self.m_bReloadEquipList then
            tbconEquip:cleanTable()
        end
        self.m_nCurLoadEquipIndex = 1
        self.m_tEquipList = t
        tbconEquip:enableSchedule("_loadEquip")
   --      tbconEquip:removeAll()
   --      doStopAllActions(tbconEquip)
   --      for i=1, #self.m_tEquipList do
	  --       delayRun(tbconEquip, i / DEFAULT_FPS, function()
	  --       	local cellElement,cellObj = CellStrengthenEquip:createElement()
			--     cellElement:setTag(i-1)
			--     cellElement = WZUIContainer:luaTo(cellElement)
			--     tbconEquip:pushBack(cellElement)
			--     tbconEquip:setContentSize(GlobalMethod:CCSize(311,98))
			--     tbconEquip:setRelativeSize(GlobalMethod:CCSize(1,98/440))
			--     cellObj:initCellData(self.m_tEquipList[i])
			-- --    tbconEquip:getMoveElement():setPositionY(tbconEquip:getMinPosition().y)
	  --   	end)
	  --   end

	  --   tbconEquip:getMoveElement():setPositionY(self.m_nConListPositionY)

		GetElement(self.m_root,"conNull",WZUIContainer):setVisible(false)
		if self.m_nCurIndex == 4 and #t == 0 then
			GetElement(self.m_root,"conNull",WZUIContainer):setVisible(true)
            tbconEquip:cleanTable()
		end

        local isEndTeach10, step10 = TeachGroup1:isTeachFinish(10)
        local isEndTeach11, step11 = TeachGroup1:isTeachFinish(11)
        local isEndTeach38, step38 = TeachGroup1:isTeachFinish(38)

        self.m_tbconEquip = tbconEquip
        if isEndTeach11 ~= true and step11 > 0 and checkBoxTag == 1 and #t == 0 then
            self.m_equipClassifyIndex = 1
        	self.m_nSaveRightIndex = 1
            self:_initEquipListByTag(self.m_nSaveRightIndex)
        elseif isEndTeach11 ~= true and step11 > 0 and (checkBoxTag == 1 and #t > 0 or checkBoxTag == 2) then
            TeachGroup1:startGroup({11,3, WndStrengthen.m_root})
        elseif isEndTeach10 ~= true and step10 > 0 and checkBoxTag == 1 and #t == 0 then
        	self.m_equipClassifyIndex = 1
        	self.m_nSaveRightIndex = 1
            self:_initEquipListByTag(self.m_nSaveRightIndex)
        elseif isEndTeach10 ~= true and step10 > 0 and (checkBoxTag == 1 and #t > 0 or checkBoxTag == 2) then
            TeachGroup1:startGroup({10,3, WndStrengthen.m_root})
        elseif TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 and isEndTeach38 ~= true then
            TeachGroup1:startGroup({38,1, WndStrengthen.m_root})
        end
    end
end

--@brief    加载装备
function WndStrengthen:_loadEquip(element, delta)
	WZLog("WndStrengthen:_loadEquip", self.m_bDontResetListY)
    -- body
    if self.m_root == nil or self.m_tEquipList == nil then
        self.m_bReloadEquipList = true
        element:disableSchedule()
        return 
    end
    --加载完成
    if self.m_nCurLoadEquipIndex > #self.m_tEquipList then
        WZLog("******* WndStrengthen:_loadEquip *******", self.m_bDontResetListY, self.m_nConListPositionY)
        if self.m_bDontResetListY then
			WZLog("保持原来位置")
            element:getMoveElement():setPositionY(self.m_nConListPositionY)
        else
			WZLog("回到起始位置")
            element:getMoveElement():setPositionY(element:getMinPosition().y)
        end
        self.m_bReloadEquipList = true
        element:disableSchedule()

        --装备列表红点
        self:showEquipsListRed()
        return
    end
    element = WZUITableContainer:luaTo(element)

    local nTag = 0 

    local celTemp = element:getCellElement(nTag)
    while celTemp do
        celTemp = WZUIContainer:luaTo(celTemp)
    	local cellItem = celTemp:getChildElement("__CellStrengthenEquip")
        if cellItem then
            local tNewObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
            if tNewObj then
		        local nPlayerItemId = tNewObj:getPlayerItemId()
		        if nPlayerItemId == self.m_tEquipList[self.m_nCurLoadEquipIndex].playerItemId then
		        --    celTemp:setTag(self.m_nCurLoadEquipIndex-1)
		            --更新显示信息
		            tNewObj:resetCellData(self.m_tEquipList[self.m_nCurLoadEquipIndex])
		            self.m_nCurLoadEquipIndex = self.m_nCurLoadEquipIndex + 1
		            return 
		        end
		    end
	    end

        nTag = nTag + 1
        celTemp = element:getCellElement(nTag)
    end

    local cellElement,cellObj = CellStrengthenEquip:createElement()
    cellElement:setScale(0.9)
    cellElement:setTag(self.m_nCurLoadEquipIndex-1)
    cellElement = WZUIContainer:luaTo(cellElement)
    element:setCellElement(cellElement)
    cellObj:initCellData(self.m_tEquipList[self.m_nCurLoadEquipIndex])

    element:getMoveElement():setPositionY(element:getMinPosition().y)

    self.m_nCurLoadEquipIndex = self.m_nCurLoadEquipIndex + 1
end

--@brief    显示装备列表中装备红点
function WndStrengthen:showEquipsListRed()
    if self.m_root == nil or self.m_tEquipList == nil then
        return 
    end

    local tbconEquip = GetElement(self.m_root,"tbMyEquipList_WndStrengthen", WZUITableContainer)

    local nTag = 0 
    local celTemp = tbconEquip:getCellElement(nTag)
    while celTemp do
        celTemp = WZUIContainer:luaTo(celTemp)
        local cellItem = celTemp:getChildElement("__CellStrengthenEquip")
        if cellItem then
            local tNewObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
            if tNewObj then
		        local nPlayerItemId = tNewObj:getPlayerItemId()
		        local bIsRed = false
		        local tempEquip = tNewObj:getEquipItem()
		        if self.m_nCurIndex == 3 then
		            if CheckButtonOpen(43,1) and tempEquip.extraInfo and (tempEquip.extraInfo.hpStone == nil or tempEquip.extraInfo.attackStone == nil or tempEquip.extraInfo.defendStone == nil or (tempEquip.extraInfo.gongmingStone == nil and CheckButtonOpen(195,true))
		                    or tempEquip.extraInfo.hpStone == 0 or tempEquip.extraInfo.attackStone == 0 or tempEquip.extraInfo.defendStone == 0 or (tempEquip.extraInfo.gongmingStone == 0 and CheckButtonOpen(195,true)) ) then
		                bIsRed = true
		            end
		        end
		        tNewObj:setRedDot(bIsRed)
		    end
		end

        nTag = nTag + 1
        celTemp = tbconEquip:getCellElement(nTag)
    end
end

function WndStrengthen:buyCallBack()
    if self.m_root == nil then
        return
    end
	self.m_root:enableSchedule("refreshBag", 0.5)
end

function WndStrengthen:refreshBag()
    if WndImproveStrengthen.m_root then 
        WndImproveStrengthen:buyCallBack()
    end
    if WndTransferStrengthen.m_root then  
        WndTransferStrengthen:buyCallBack()
    end
	if self.m_nCurIndex == 3 then
        if WndSelectTipsStrengthen.m_root then
            WndSelectTipsStrengthen:_initStoneTips()
        end
	end

    self.m_root:disableSchedule()
end

--@brief 	装备排序函数
function _sortEquip(a, b)
	if a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel ~= b.extraInfo.strongLevel then
		return a.extraInfo.strongLevel > b.extraInfo.strongLevel
	else
	if a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel ~= b.extraInfo.starLevel then
		return a.extraInfo.starLevel > b.extraInfo.starLevel
	else
    --4装备部位：武器、衣服、发型、脸谱、翅膀、戒指1、戒指2、项链
    if a.sortType == b.sortType then
    	--1使用中
		if a.isUse == b.isUse then
			--2品质从高到低
			if a.basicInfo.quality == b.basicInfo.quality then
    	        --3战斗力
    	        if a.extraInfo.fight == b.extraInfo.fight then
   	                --装备ID从低到高
   	                return a.id < b.id
    	        else
    	            return a.extraInfo.fight > b.extraInfo.fight
    	        end
			else
				return a.basicInfo.quality > b.basicInfo.quality
			end
		else
			if a.isUse then
				return true
			else
				return false
			end
		end
   else
       return a.sortType < b.sortType
   end
   end
   end
end

--@brief	检查强化满级  升星满级
function WndStrengthen:checkIntensifyLevel()
	local maxStrongLevel = CacheCenter:getGameParam().gameMaxLevel
	local maxStarLevel = CacheCenter:getGameParam().maxStarLevel
	local level = CacheCenter:getPlayerInfo().level
	local ttfIntensifyTop = GetElement(self.m_root,"ttfIntensifyTop",WZUILabelTTF)
	ttfIntensifyTop:setVisible(false)
   	if self.m_nCurIndex == 1 then
    	if self.m_weaponLuaObj.m_tItem ~= nil then
    		--判断当前强化等级是否达到最高等级
			local levelLimit = level
            local equipType = self.m_weaponLuaObj.m_tItem.basicInfo.main_type == 43 and 2 or 1
            local nTabMaxLv = WndIntensifyStrengthen:getMaxStrengthLvByQuality(self.m_weaponLuaObj.m_tItem.basicInfo.quality,equipType)
			if self.m_weaponLuaObj.m_tItem.basicInfo.quality == 4 then
				maxStrongLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel) * 2
				WZLog("强化最高等级",maxStrongLevel)
				levelLimit = level * 2
				if levelLimit > maxStrongLevel then levelLimit = maxStrongLevel end
			end
            maxStrongLevel = math.min(maxStrongLevel,nTabMaxLv)
    		if tonumber(self.m_weaponLuaObj.m_tItem.extraInfo.strongLevel) >= tonumber(maxStrongLevel) then
				WndIntensifyStrengthen:setDisplayState("topLevel")
				GetElement(self.m_root,"conMidBg",WZUIContainer):setVisible(true)
				ttfIntensifyTop:setVisible(true)
				GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(true)
				ttfIntensifyTop:setText(LocalStrings.STRENGTHEN_TOP)
				GetElement(self.m_root,"topInfo",WZUILabelTTF):setText(LocalStrings.STRENGTHEN4)
			--判断强化等级是否达到人物等级
			elseif tonumber(self.m_weaponLuaObj.m_tItem.extraInfo.strongLevel) >= tonumber(levelLimit) then
				WndIntensifyStrengthen:setDisplayState("userLevel")
				GetElement(self.m_root,"conMidBg",WZUIContainer):setVisible(true)
				ttfIntensifyTop:setVisible(true)
				GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(true)
				ttfIntensifyTop:setText(LocalStrings.STRENGTHEN5)
				GetElement(self.m_root,"topInfo",WZUILabelTTF):setText(LocalStrings.STRENGTHEN3)
			else
				WndIntensifyStrengthen:setDisplayState("normal")
				GetElement(self.m_root,"conMidBg",WZUIContainer):setVisible(false)
				ttfIntensifyTop:setVisible(false)
				GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
			end
		else
			WndIntensifyStrengthen:setDisplayState("normal")
			GetElement(self.m_root,"conMidBg",WZUIContainer):setVisible(false)
			ttfIntensifyTop:setVisible(false)
			GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
		end
   	end
   	if self.m_nCurIndex == 2 then
   		--橙色的时候 宠物装备最大12星
   		if self.m_weaponLuaObj.m_tItem and (self.m_weaponLuaObj.m_tItem.basicInfo.quality ~= 4 or self.m_weaponLuaObj.m_tItem.basicInfo.main_type == 43) then
   			maxStarLevel = 12
   		else
   			if not CheckButtonShow(215) then
	   			maxStarLevel = 12
	   		end
   		end
   		
    	if self.m_weaponLuaObj.m_tItem ~= nil then
    		--判断当前升星等级是否达到最高等级
    		if tonumber(self.m_weaponLuaObj.m_tItem.extraInfo.starLevel) >= tonumber(maxStarLevel) then
				WndImproveStrengthen:setDisplayState("topLevel")
				ttfIntensifyTop:setVisible(true)
				ttfIntensifyTop:setText(LocalStrings.IMPROVE_TOP)
			else
				WndImproveStrengthen:setDisplayState("normal")
				ttfIntensifyTop:setVisible(false)
			end
		else
			WndImproveStrengthen:setDisplayState("normal")
			ttfIntensifyTop:setVisible(false)
		end
   	end
    if self.m_nCurIndex == 4 then
        GetElement(self.m_root,"topInfo",WZUILabelTTF):setVisible(false)
    end
end

function WndStrengthen:onRuleClick() 
	WZLog("WndStrengthen:onRuleClick", self.m_nCurIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local msg = LocalStrings["STRENGTHEN_RULE"..self.m_nCurIndex]
	if 1 == self.m_nCurIndex then
		msg = LocalStrings.STRENGTHEN_RULE1
	elseif 2 == self.m_nCurIndex then
		msg = LocalStrings.STRENGTHEN_RULE3
	elseif 3 == self.m_nCurIndex then
		msg = LocalStrings.STRENGTHEN_RULE4
	elseif 4 == self.m_nCurIndex then
		msg = LocalStrings.STRENGTHEN_RULE5
    elseif 5 == self.m_nCurIndex then
		msg = LocalStrings.STRENGTHEN_RULE2
	end
   	WndSingleMapDesc:showInterface(msg)
end


--@brief	创建左边大标题按钮
function WndStrengthen:createTitleBtn()
	
	local tTitleBtn = {}
    tTitleBtn.tabBtnId = {26,80} --功能开放表id
    tTitleBtn.tabBtnTitle = {LocalStrings.ITEM8,LocalStrings.ASCENDING9}
    tTitleBtn.tabBtnSubId = {{40,41,43,119},{80,82,86,91,175}} --功能开放表id
    tTitleBtn.tabBtnSubTitle = {{LocalStrings.STRENGTEN,LocalStrings.IMPROVE,LocalStrings.GEMMOUNTING,LocalStrings.ASCENDING2},
    						{LocalStrings.ASCENDING1,LocalStrings.ASCENDING_FUSE1,LocalStrings.EVOLUTION,LocalStrings.ASCENDING37,LocalStrings.PHANTOM_NEWTEXT20}}

	local playerLevel = CacheCenter:getPlayerInfo().level
	for i=#tTitleBtn.tabBtnId,1,-1 do
		if playerLevel < GDatatab_button_info["id_"..tTitleBtn.tabBtnId[i]].open_level then
			table.remove(tTitleBtn.tabBtnId,i)
			table.remove(tTitleBtn.tabBtnTitle,i)
			table.remove(tTitleBtn.tabBtnSubId,i)
			table.remove(tTitleBtn.tabBtnSubTitle,i)
		else
			for j=#tTitleBtn.tabBtnSubId[i],1,-1 do
				if playerLevel < GDatatab_button_info["id_"..tTitleBtn.tabBtnSubId[i][j]].open_level then	
					table.remove(tTitleBtn.tabBtnSubId[i],j)
					table.remove(tTitleBtn.tabBtnSubTitle[i],j)
				end
			end

		end
	end

    self.m_tTitleBtn = tTitleBtn

	--设置小标题id
	if self.m_nCurIndex then
	    local tOldOpenId = {40,41,43,119} --原checkbox的id顺序

	    local tempMainId = 1
	    for i=1,#tTitleBtn.tabBtnId do
	    	if tTitleBtn.tabBtnId[i] == self.m_nCurUIId then
	    		tempMainId = i
	    	end
	    end
	    local tempTabSubId = tTitleBtn.tabBtnSubId[tempMainId]
	    for i=1,#tempTabSubId do
	    	if tOldOpenId[self.m_nCurIndex] == tempTabSubId[i] then
	    		self.m_nSubIndex = i
	    	end
	    end
	end

	--创建大小标题id
	local flconTitlItem = GetElement(self.m_root,"flconTitlItem_WndStrengthen",WZUIFreeListContainer)
	flconTitlItem:removeAll()

	local index = 0
	for i=1,#tTitleBtn.tabBtnId do
		local conTitleItem1 = CreateElement("conTitleItem1_WndStrengthen")
		conTitleItem1 = WZUIContainer:luaTo(conTitleItem1)
		conTitleItem1:setTag(index)
        conTitleItem1:setName("one"..tTitleBtn.tabBtnId[i])
		index = index + 1

		flconTitlItem:pushBack(conTitleItem1)

		local txtTitleName1 = GetElement(conTitleItem1,"txtTitleName1_WndStrengthen",WZUILabelTTF)
		local txtTitleName2 = GetElement(conTitleItem1,"txtTitleName2_WndStrengthen",WZUILabelTTF)
		local txtTitleName3 = GetElement(conTitleItem1,"txtTitleName3_WndStrengthen",WZUILabelTTF)
		txtTitleName1:setText(tTitleBtn.tabBtnTitle[i])
		txtTitleName2:setText(tTitleBtn.tabBtnTitle[i])
		txtTitleName3:setText(tTitleBtn.tabBtnTitle[i])

		if tTitleBtn.tabBtnId[i] == self.m_nCurUIId then
			self.m_nMainIndex = i

			local btnTitle = GetElement(conTitleItem1,"btnTitle_WndStrengthen",WZUIButton)
			btnTitle:setTouchEnable(false)
			btnTitle:setTag(i)

			for j=1,#tTitleBtn.tabBtnSubId[i] do

				local conTitleItem2 = CreateElement("conTitleItem2_WndStrengthen")
				conTitleItem2 = WZUIContainer:luaTo(conTitleItem2)
				conTitleItem2:setTag(index)
                conTitleItem2:setName("two"..tTitleBtn.tabBtnSubId[i][j])
				index = index + 1

				flconTitlItem:pushBack(conTitleItem2)

				local txtTitleName1 = GetElement(conTitleItem2,"txtTitleName1_WndStrengthen",WZUILabelTTF)
				local txtTitleName2 = GetElement(conTitleItem2,"txtTitleName2_WndStrengthen",WZUILabelTTF)
				local txtTitleName3 = GetElement(conTitleItem2,"txtTitleName3_WndStrengthen",WZUILabelTTF)
				txtTitleName1:setText(tTitleBtn.tabBtnSubTitle[i][j])
				txtTitleName2:setText(tTitleBtn.tabBtnSubTitle[i][j])
				txtTitleName3:setText(tTitleBtn.tabBtnSubTitle[i][j])

				if j == self.m_nSubIndex then
					local btnTitle = GetElement(conTitleItem2,"btnTitle_WndStrengthen",WZUIButton)
					btnTitle:setTouchEnable(false)
					btnTitle:setTag(j)
				else
					local btnTitle = GetElement(conTitleItem2,"btnTitle_WndStrengthen",WZUIButton)
					btnTitle:setTouchEnable(true)
					btnTitle:setTag(j)

				end

			end
		else

			local btnTitle = GetElement(conTitleItem1,"btnTitle_WndStrengthen",WZUIButton)
			btnTitle:setTouchEnable(true)
			btnTitle:setTag(i)
		
		end

	end

    --标题红点
    self:setRedDot()
end

-- 设置红点
function WndStrengthen:setRedDot()
    local flconTitlItem = GetElement(self.m_root,"flconTitlItem_WndStrengthen",WZUIFreeListContainer)
    --一级标题红点
    for k=1,flconTitlItem:size() do
        local element = flconTitlItem:getAt(k-1)
        if element:getName() == "one"..26 then
            local state = CacheCenter:getRedState("gemMounting_btnStrong") and CheckButtonOpen(43,1)
            GetElement(element,"imgRed_Title1_WndStrengthen",WZUIImage):setVisible(state)
        end
    end
    --二级标题红点
    for k=1,flconTitlItem:size() do
        local element = flconTitlItem:getAt(k-1)
        if element:getName() == "two"..43 then
            local state = CacheCenter:getRedState("gemMounting_btnStrong") and CheckButtonOpen(43,1)
            GetElement(element,"imgRed_Title2_WndStrengthen",WZUIImage):setVisible(state)
        end
    end
end

--大标题点击回调 tabBtnId
function WndStrengthen:onClickGoto(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()

	if self.m_tTitleBtn.tabBtnId[tag] == 26 then
		local wnd = WndStrengthen:createElement()
		WindowManager:addWindow(wnd, WndStrengthen, false)
	elseif self.m_tTitleBtn.tabBtnId[tag] == 80 then
		local wnd = WndAscending:createElement()
		WindowManager:addWindow(wnd, WndAscending, false)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--小标题点击回调 tabBtnSubId
function WndStrengthen:onClickBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local subId = self.m_tTitleBtn.tabBtnSubId[self.m_nMainIndex][tag]
	if subId == 40 then
		self:onIntensifySelect()
	elseif subId == 42 then
		self:onTransferSelect()
	elseif subId == 41 then
		self:onImproveSelect()
	elseif subId == 43 then
		self:onGemmountingSelect()
	elseif subId == 119 then
		self:onGradeSelect()
	end


	self.m_nSubIndex = tag
	self:createTitleBtn()
end

--@brief 	设置装备和装备名字不可见
function WndStrengthen:setEquipVisible(bVisible)
	GetElement(self.m_root, "conEquipName_WndStrengthen", WZUIContainer):setVisible(bVisible)
	GetElement(self.m_root, "conEquipNameAndIcon_WndStrengthen", WZUIContainer):setVisible(bVisible)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------
--@brief	适配分辨率
function WndStrengthen:AdaptResolution()
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	WZLog("WndStrengthen:AdaptResolution",directorSize.height)
	--iphone5适配
	if directorSize.width > 1136 then
	end
	--ipad适配
	if directorSize.width == 1024 and directorSize.height == 768 then
		GetElement(self.m_root,"conMid_WndStrengthen",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.493,0.058))
	end
	if directorSize.width == 2048 and directorSize.height == 1536 then
		GetElement(self.m_root,"conMid_WndStrengthen",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.493,0.058))
	end
end

--@brief 英文适配函数
--@note  英文适配
function WndStrengthen:_adaptLanguage_en()
    --body
	WZLog("WndStrengthen:_adaptLanguage_en")
    GetElement(self.m_root,"txtEquipWord_WndStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtConNull_WndStrengthen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(300,0))
end

function WndStrengthen:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtEquipWord_WndStrengthen",WZUILabelTTF):setScale(0.5)
    GetElement(self.m_root,"txtConNull_WndStrengthen",WZUILabelTTF):setScale(0.8)
end


--@brief 越南语适配
function WndStrengthen:_adaptLanguage_vn()
    WZLog("WndStrengthen:_adaptLanguage_vn")
end

function WndStrengthen:_adaptLanguage_tr()
    GetElement(self.m_root,"topInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtEquipWord_WndStrengthen",WZUILabelTTF):setFontSize(20)
end

function WndStrengthen:_adaptLanguage_es(  )
    local topInfo = GetElement(self.m_root,"topInfo",WZUILabelTTF)
    topInfo:setFontSize(14)
    topInfo:setRelativePosition(GlobalMethod:ccp(0.535051,0.08))
end

function WndStrengthen:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtConNull_WndStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndStrengthen:_adaptLanguage_ug(  )
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndStrengthen",WZUILabelTTF)
    txtIntensify1:setScale(0.7)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(120))
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndStrengthen",WZUILabelTTF)
    txtIntensify2:setScale(0.7)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(120))
    local txtImprove1 = GetElement(self.m_root,"txtImprove1_WndStrengthen",WZUILabelTTF)
    txtImprove1:setScale(0.7)
    txtImprove1:setDimensions(GlobalMethod:CCSize(120))
    local txtImprove2 = GetElement(self.m_root,"txtImprove2_WndStrengthen",WZUILabelTTF)
    txtImprove2:setScale(0.7)
    txtImprove2:setDimensions(GlobalMethod:CCSize(120))
    local txtGemmounting1 = GetElement(self.m_root,"txtGemmounting1_WndStrengthen",WZUILabelTTF)
    txtGemmounting1:setScale(0.7)
    txtGemmounting1:setDimensions(GlobalMethod:CCSize(120))
    local txtGemmounting2 = GetElement(self.m_root,"txtGemmounting2_WndStrengthen",WZUILabelTTF)
    txtGemmounting2:setScale(0.7)
    txtGemmounting2:setDimensions(GlobalMethod:CCSize(120))
    local txtSophistic1 = GetElement(self.m_root,"txtSophistic1_WndStrengthen",WZUILabelTTF)
    txtSophistic1:setScale(0.7)
    txtSophistic1:setDimensions(GlobalMethod:CCSize(120))
    local txtSophistic2 = GetElement(self.m_root,"txtSophistic2_WndStrengthen",WZUILabelTTF)
    txtSophistic2:setScale(0.7)
    txtSophistic2:setDimensions(GlobalMethod:CCSize(120))
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF)
    txtTransfer1:setScale(0.7)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(120))
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF)
    txtTransfer2:setScale(0.7)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtConNull_WndStrengthen",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtCheckBox1_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel1_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox2_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel2_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox3_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel3_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox6_WndStrengthen",WZUILabelTTF):setScale(0.)
    GetElement(self.m_root,"txtCheckBoxSel6_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox7_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel7_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox5_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel5_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBox4_WndStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCheckBoxSel4_WndStrengthen",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"ttfIntensifyTop",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"topInfo",WZUILabelTTF):setScale(0.6)

end
-------------------------------------语言适配模块End----------------------------------------

