--WndCopyEntry.lua
--@brief	WndCopyEntry的UI模块
--@date		2016/12/26
--@author	peiting_mao
--@note		副本入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyEntry:onEnter(element)
	self.m_root = element
	self:_addTop()
	self:_initText()
	AdaptLanguage(self)
    TeachGroup1:startGroup({1,3,self.m_root},{15,2,self.m_root},{29,2,self.m_root},{13,2,self.m_root}, {49,2,self.m_root})
    self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyEntry:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndCopyEntry:register()
    GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end
function WndCopyEntry:unregister()
    GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndCopyEntryInfoData,self)
end

--@brief    触摸开始回调
function WndCopyEntry:onTouchBegin(element, pt)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

function WndCopyEntry:showScene(  )
    -- if self.m_root == nil then
    --     local wndCopyEntry = WndCopyEntry:createElement()
    --     WindowManager:addWindow(wndCopyEntry,WndCopyEntry)
    -- end
end

function WndCopyEntry:_onWndCopyEntryInfoData(honourPoint, restoreTime, serverTime)
	local _, score = GlobalMethod:HonorPointStatus(5)
	if tonumber(honourPoint) >= score then
        if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
			SceneCopy:showScene(2, nil, nil,true)
			WindowManager:removeWindow(self.m_root, self, true)
		end
    else
        local status, score = GlobalMethod:HonorPointStatus(5)
        if status == false then
            WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
        end
    end
end

--外部跳转到组队副本
function WndCopyEntry:onJumpTo()
	-- body
    if self.m_root == nil then
        local wndCopyEntry = WndCopyEntry:createElement()
        WindowManager:addWindow(wndCopyEntry,WndCopyEntry)
    end
	ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
end
--@brief 	按钮点击事件
function WndCopyEntry:onFunctionClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	WZLog("--WndCopyEntry:tag--",tag)
	if tag == 2 then
	    ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
	    return
	end

	if tag == 1 then
		if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP) then
            TeachGroup1:endTeachStep({1,3},{29,2})
            PostPlayerEvent:postEvent(PostPlayerEvent.event_oneLvClickSingleCopy)
            GlobalGame.g_nSingleMapPage = nil
			SceneCopy:showScene(tag, nil, nil,nil,nil,false)
			WindowManager:removeWindow(self.m_root, self, true)
		end
	elseif tag == 2 then
		-- if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
		-- 	SceneCopy:showScene(tag, nil, nil,true)
		-- 	WindowManager:removeWindow(self.m_root, self, true)
		-- end
	elseif tag == 3 then
		if CheckButtonOpen(ISLAND_BUILDING_DAILYMAP) then
			TeachGroup1:endTeachStep({13,2})
			SceneCopy:showScene(tag, nil, nil,true)
			WindowManager:removeWindow(self.m_root, self, true)
		end
	elseif tag == 4 then
        if CheckButtonOpen(TABOO_BATTLE) then
			TeachGroup1:endTeachStep({49,2})
            SceneTabooMap:show()
            SceneTabooMap:setCallBackFun(WndCopyEntry, self.showScene)
        end
	end
end

--@brief 	初始化文本
function WndCopyEntry:_initText(  )
	if CheckButtonOpen(ISLAND_BUILDING_DAILYMAP,false) then
		GetElement(self.m_root,"imgSuo3_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack3_WndCopyEntry",WZUIImage):setVisible(false)
	end
	if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP,false) then
		GetElement(self.m_root,"imgSuo1_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack1_WndCopyEntry",WZUIImage):setVisible(false)
	end
	if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP,false) then
		GetElement(self.m_root,"imgSuo2_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack2_WndCopyEntry",WZUIImage):setVisible(false)
	end
	if CheckButtonOpen(TABOO_BATTLE,false) then
		GetElement(self.m_root,"imgSuo4_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack4_WndCopyEntry",WZUIImage):setVisible(false)
	end

	local sex = CacheCenter:getPlayerInfo().sex --玩家性别
	local equip = CacheCenter:getPlayerItems() --玩家拥有的武器
	local tEquip = {}
	for k,v in pairs(equip) do
		if v.isUse == true then
			table.insert(tEquip, v)
		end
	end
	local headColor, bodyColor = CacheCenter:getHeadAndBodyColor() --玩家头部和身体颜色
	local conPlayer = GetElement(self.m_root,"conRole_WndCopyEntry",WZUIContainer)
	local player = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, headColor ,bodyColor)
	local pNode = player:getAnimNode()
	pNode:setTouchEnable(false)
	conPlayer:addChild(pNode)

	local pet = CacheCenter:getPlayerInfo().petInfo
	if pet then
		local conPet = GetElement(self.m_root,"conPet_WndCopyEntry",WZUIContainer)
		local ani,par =  CreatePetAni(conPet,pet.itemId,pet.animation,pet.advancedLevel, pet.petSkinItemId)
    end

    --判断是否显示小红点
    WndSingleCopy:_initData()
    local single = false
    for i = 0, WndSingleCopy.m_nCurCopyIndex do
        if WndSingleCopy:_getSectionRewardStateByIndex(1,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(1,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,2) == 2 then
            single = true
            break
        end
    end
    WZLog("--WndCopyEntry:RedDot--",single)
  	GetElement(self.m_root,"imgRed_WndCopyEntry",WZUIImage):setVisible(single)
  	if GlobalGame.g_tRedPointList.taboo then 
  		GetElement(self.m_root,"imgRed4_WndCopyEntry",WZUIImage):setVisible(true)
  	else
  		GetElement(self.m_root,"imgRed4_WndCopyEntry",WZUIImage):setVisible(false)
  	end
end

function WndCopyEntry:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_mx.png",WndCopyEntry,WndCopyEntry.onCloseClick,true,true,false,false)
    tcell:setTopType()
end

function WndCopyEntry:onCloseClick(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
	if SceneCity.m_root then
		SceneCity:checkWelfare()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndCopyEntry:_adaptLanguage_th(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCopyEntry:_adaptLanguage_pt(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(300))
end

function WndCopyEntry:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtSingle_WndCopyEntry",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtMult_WndCopyEntry",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtDaily_WndCopyEntry",WZUILabelTTF):setFontSize(18)
end

function WndCopyEntry:_adaptLanguage_tr(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txt:setDimensions(GlobalMethod:CCSize(380))
end

function WndCopyEntry:_adaptLanguage_ug(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(400))
	txt:setRelativePosition(GlobalMethod:ccp(0.53,0.5))

	local txtSingle = GetElement(self.m_root,"txtSingle_WndCopyEntry",WZUILabelTTF)
	txtSingle:setScale(0.7)
	txtSingle:setDimensions(GlobalMethod:CCSize(240))
	local txtMult = GetElement(self.m_root,"txtMult_WndCopyEntry",WZUILabelTTF)
	txtMult:setScale(0.7)
	txtMult:setDimensions(GlobalMethod:CCSize(240))
	local txtDaily = GetElement(self.m_root,"txtDaily_WndCopyEntry",WZUILabelTTF)
	txtDaily:setScale(0.7)
	txtDaily:setDimensions(GlobalMethod:CCSize(240))
end
--------------------------------------语言适配End-------------------------------------------