--WndBagMain.lua
--@brief	WndBagMain的UI模块
--@date		2017/07/06
--@author	zsq
--@note		玩家角色主面板


local subWinList = {WndBag,Wndwardrobe,WndBlessBag,SceneRune,WndDesignationMain,WndPractice,WndBagRole,WndServersSure}
local subWinFunId = {24,79,64,116,31,72,24,218}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBagMain:onEnter(element)
	self.m_root = element
    ProtocolProcessorFamily:regAll1_1()
    self:controlBtnShow()

    TeachGroup1:endTeachStep({43,2})
    TeachGroup1:startGroup({43,3,self.m_root})
    AdaptLanguage(self)
end

--@brief	加载完成
function WndBagMain:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	self:_addTop()
	self.m_nSubWin = 7
	self:_onSubWin(7)
	--衣橱过期红点
	if CacheCenter:hasExpiredDress() and GlobalGame.g_ClickedDress ~= true then
		GetElement(self.m_root,"red1_WndDressList",WZUIImage):setVisible(true)
		local checkbox = GetElement(self.m_root,"checkbox2_WndBagMain",WZUICheckBox)
		if self.jumpTag == nil and checkbox:isVisible() then
			self.jumpTag = "Dress"
		end
	else
		GetElement(self.m_root,"red1_WndDressList",WZUIImage):setVisible(false)
	end
    --成就红点
    self:setAchieEntryRedPointVisible()
	--修炼红点
	WZLog("修炼红点",CacheCenter:getRedState("btnPractice_ExtendUp"))
	self:setXiuLIanRed(CacheCenter:getRedState("btnPractice_ExtendUp"))
	local checkbox6 = GetElement(self.m_root,"checkbox6_WndBagMain",WZUICheckBox)
	if CacheCenter:getRedState("btnPractice_ExtendUp") and self.jumpTag == nil and checkbox6:isVisible() then
		self.jumpTag = "xiuLian"
	end
	--符文红点
	WZLog("符文红点", CacheCenter:getRedState( "btnRune" ))
	if CacheCenter:getRedState( "btnRune" ) then
		GetElement(self.m_root,"red2_WndDressList",WZUIImage):setVisible(true)
		local checkbox = GetElement(self.m_root,"checkbox4_WndBagMain",WZUICheckBox)
		if self.jumpTag == nil and checkbox:isVisible() then
			self.jumpTag = "Rune"
		end
	else
		GetElement(self.m_root,"red2_WndDressList",WZUIImage):setVisible(false)
	end
    --祈福背包红点
    self:setBlessBagRed(CacheCenter:getRedState("btnBlessBag"))
    local checkbox3 = GetElement(self.m_root,"checkbox3_WndBagMain",WZUICheckBox)
    if CacheCenter:getRedState("btnBlessBag") and self.jumpTag == nil and checkbox3:isVisible() then
        self.jumpTag = "BlessBag"
    end

	if self.jumpTag == "Dress" then
		self.jumpTag = nil
		self.m_nSubWin = 2
		self:_onSubWin(2)
    	GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(1)
		if WndDressList.m_root ~= nil then
			GetElement(WndDressList.m_root,"btnExpired_WndDressList",WZUIButton):setVisible(false)
			GetElement(WndDressList.m_root,"btnBag_WndDressList",WZUIButton):setVisible(true)
		end
    elseif self.jumpTag == "BlessBag" then
        self.jumpTag = nil
        self.m_nSubWin = 3
        self:_onSubWin(3)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(2)
    elseif self.jumpTag == "Rune" then
        self.jumpTag = nil
        self.m_nSubWin = 4
        self:_onSubWin(4)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(3)
    elseif self.jumpTag == "Designation" then
        self.jumpTag = nil
        self.m_nSubWin = 5
        self:_onSubWin(5)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(4)
    elseif self.jumpTag == "xiuLian" then
        self.jumpTag = nil
        self.m_nSubWin = 6
        self:_onSubWin(6)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(5)
    elseif self.jumpTag == "beibao" then
        self.jumpTag = nil
        self.m_nSubWin = 7
        self:_onSubWin(7)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(6)
    elseif self.jumpTag == "tupo" then
        self.jumpTag = nil
        self.m_nSubWin = 8
        self:_onSubWin(8)
        GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(7)
	else
		-- self.m_nSubWin = 7
		-- self:_onSubWin(7)
	end

    self:showrightConItemBG( self.m_nSubWin )
    
end

--@brief    物品列表背景
function WndBagMain:showrightConItemBG( tag )
    local rightConItemBG = GetElement(self.m_root,"rightConItemBG",WZUIContainer)
    rightConItemBG:setVisible(tag ~= 5 and tag ~= 7)
    if tag == 3 then
        rightConItemBG:setAbsContentSize(GlobalMethod:CCSize(472,485))
    else
        rightConItemBG:setAbsContentSize(GlobalMethod:CCSize(472,438))
    end
    rightConItemBG:updateRelativeSize()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBagMain:onExit(element)
    local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)   
    WZLog("WndBagMain:onExit", isEndTeach8, step8)
    if isEndTeach8 ~= true and step8 >= 5 then 
        if WndSingleCopy.m_root then 
            if step8 == 5 then 
                TeachGroup1:startGroup({8, 6, WndSingleCopy.m_root})
            end
        else
            SceneCopy:showScene(1)
        end
    end
    ProtocolProcessorFamily:unregAll1_1()
	self:_unInit()
end

function WndBagMain:_addTop()
    local cellTopHand = GetElement(self.m_root,"cellTopHand_WndBagMain",WZUIContainer)
    local cell,tcell = CellTopHandle:createElement()
    cellTopHand:addChild(cell)
    tcell:setTopData("ui/common/bag_icon_juese.png",WndBagMain,WndBagMain.onCloseClick,true,false,false,"WndBagMain")
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndBagMain:onCloseClick(element)
    WZLog("WndBagMain:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
    if isEndTeach8 ~= true and step8 > 0 then
        PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvClickBack)
        TeachGroup1:endTeachStep({8,5})
    end

    CacheCenter:setRedState("btnBag",CacheCenter:isEquipedDecorationRedPoint())
    GlobalGame:getBtnRedPointEvent():dispatcher()

    --成就红点
    WndDesignationMain:onCloseClick()
	
	if WndDressList.m_root ~= nil and WndDressList.m_tTryWearList ~= nil 
			and GetTableLen(WndDressList.m_tTryWearList) > 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.BAGTIP22, Wndwardrobe, Wndwardrobe.onBatch, nil, {MSGBOXUICFG_CANCEL=LocalStrings.CANCEL}, nil, nil, nil, Wndwardrobe.onCancelBatch)
		return
	end

    --判断圣光-时装进阶界面是否打开，打开就刷新界面数据
    WndAscending:setDressData()
    self:_cleanSubWin()
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndBagMain:closeWin()
    WindowManager:removeWindow(WndBagMain.m_root, WndBagMain, true)
end

--@brief	背包接口
function WndBagMain:showBag()
	WZLog("WndBagMain:showBag")
    if self.m_root == nil then
        local wndBagElement = WndBagMain:createElement()
        WndBagMain.jumpTag = "Bag"
        WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
    end
end

function WndBagMain:onSubWin(element) 
    WZLog("WndBagMain:onSubWin")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if WndDressList.m_root ~= nil and WndDressList.m_tTryWearList ~= nil 
            and GetTableLen(WndDressList.m_tTryWearList) > 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.BAGTIP22, Wndwardrobe, Wndwardrobe.onBatch, nil, {MSGBOXUICFG_CANCEL=LocalStrings.CANCEL}, nil, nil, nil, Wndwardrobe.onCancelBatch)
        self.m_root:enableSchedule("groupCall",0)
        return
    end

    local tag = tonumber(element:getTag())
    if tag == self.m_nSubWin then return end

    local RightSecondBG = GetElement(self.m_root,"RightSecondBG",WZUIContainer)
    RightSecondBG:setVisible(false)
    RightSecondBG:setVisible(tag ~= 4)


    self:showrightConItemBG( tag )

    if not CheckButtonOpen(subWinFunId[tag]) then
        return 
    end
    --成就红点,切换标签时候，如果上一个界面处于成就界面
    if self.m_nSubWin == 3 then 
        WndDesignationMain:onCloseClick()
    end
	--符文红点
	WZLog("符文红点1", CacheCenter:getRedState( "btnRune" ))
	if CacheCenter:getRedState( "btnRune" ) then
		GetElement(self.m_root,"red2_WndDressList",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"red2_WndDressList",WZUIImage):setVisible(false)
	end

    self.m_nSubWin = tag
	self:_onSubWin(tag)
end

function WndBagMain:groupCall() 
	self.m_root:disableSchedule()
    GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(1)
end

function WndBagMain:setOriginGroupCall() 
    if self.m_root == nil then return end 
    GetElement(self.m_root, "group_WndBagMain", WZUICheckBoxGroup):setCheckIndex(self.m_nSubWin - 1)
end

function WndBagMain:_onSubWin(tag) 
	WZLog("WndBagMain:_onSubWin", tag)

    local btnTotalAttrTip = GetElement(self.m_root,"btnTotalAttrTip_WndBagMain",WZUIButton)
    local bShowTipBtn = tag == 1 or tag == 2 or tag == 7
    btnTotalAttrTip:setVisible(tag == 1 or tag == 2 or tag == 7)

	self:_cleanSubWin()
	--显示选中窗口
	local addWin = subWinList[tag]
	if addWin and addWin.showWin then
		addWin:showWin(self.m_nDesignationIndex)
	end
end

function WndBagMain:_cleanSubWin() 
	--关闭所有子窗口
	for i=1,8 do
		local subWin = subWinList[i]
		if subWin ~= nil and subWin.m_root ~= nil and subWin.onCloseClick then
			subWin:onCloseClick()
		end
	end
	
    --通用容器
	local con = GetElement(self.m_root,"conSubWin",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)

    --修炼符文等使用的容器(全屏背景)
    local con_1 = GetElement(self.m_root,"conSubWin_1",WZUIContainer)
    if con_1 then
        con_1:removeAllChildrenWithCleanup(true)
    end
end

--@brief	汇总属性tip
function WndBagMain:onTotalAttrTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	WndPropertyInfo:show(CacheCenter:getPlayerInfo())
end

--@brief    触摸开始回调
function WndBagMain:onTouchBegin(element, pt)
    -- body
    if self.m_nSubWin == 2 then
        if Wndwardrobe.m_tCellDressSuit and not Wndwardrobe.m_tCellDressSuit:checkPointInBtn(pt) then
            Wndwardrobe.m_tCellDressSuit:hideSuitList()
        end
    elseif self.m_nSubWin == 3 then
        if WndBlessBag.m_tCellDressSuit and not WndBlessBag.m_tCellDressSuit:checkPointInBtn(pt) then
            WndBlessBag.m_tCellDressSuit:hideSuitList()
        end
    elseif self.m_nSubWin == 4 then
        if SceneRune.m_tCellDressSuit and not SceneRune.m_tCellDressSuit:checkPointInBtn(pt) then
            SceneRune.m_tCellDressSuit:hideSuitList()
        end
    end
    
    self:setOriginGroupCall() 
end

--@brief    触摸结束回调
function WndBagMain:onTouchEnd(element)
    -- body
    self:setOriginGroupCall() 
end

--@brief    设置成就标签红点是否可见
function WndBagMain:setAchieEntryRedPointVisible(bVisible)
    -- body
    if self.m_root == nil then return end 

    local bBool = g_bHaveRedPointForAchieEntry
    if bVisible ~= nil then
        bBool = bVisible
    end

    bBool = bBool or GlobalGame.g_tRedPointList.badge
    local group = GetElement(self.m_root,"group_WndBagMain",WZUICheckBoxGroup)
    local checkbox6 = GetElement(group,"checkbox5_WndBagMain",WZUICheckBox)
    local imgAchieRed = GetElement(checkbox6,"imgAchieRed_WndBagMain",WZUIImage)
    WZLog("****************** WndBag:setAchieEntryRedPointVisible ***************", g_bHaveRedPointForAchieEntry)
    imgAchieRed:setVisible(bBool)

	local checkbox = GetElement(self.m_root,"checkbox5_WndBagMain",WZUICheckBox)
	if bBool and self.jumpTag == nil and checkbox:isVisible() then
		self.jumpTag = "Designation"
	end
end

--@brief	设置修炼红点
function WndBagMain:setXiuLIanRed(bool) 
	if self.m_root == nil then return end
	GetElement(self.m_root,"imgXiulianRed_WndBagMain",WZUIImage):setVisible(bool)
end

--@brief    祈福背包红点
function WndBagMain:setBlessBagRed(bool)
    if WndBagMain.m_root then
        GetElement(self.m_root,"imgBlessBagRed_WndBagMain",WZUIImage):setVisible(bool)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--按照功能开放等级进行显示
function WndBagMain:controlBtnShow()
    -- body
    WZLog("WndBagMain:controlBtnShow")
    local GDatatab_button_info = GDatatab_button_info
    local GetElement = GetElement
    local btnList = {72,64,116,218}
    local elementNames = {"checkbox6_WndBagMain","checkbox3_WndBagMain","checkbox4_WndBagMain", "checkbox8_WndBagMain"}
    local psList = {{0,0.49},{0,0.358},{0,0.226},{0,0.094}}
    local tBtnList = {}
    for i,v in ipairs(btnList) do
        local temp = {}
        table.insert(temp,v)
        table.insert(temp,elementNames[i])

        table.insert(tBtnList,temp)
    end

    table.sort(tBtnList,function (a,b)
        -- body
        local btnInfoA = GDatatab_button_info["id_" .. a[1]]
        local btnInfoB = GDatatab_button_info["id_" .. b[1]]
        if btnInfoA.open_level < btnInfoB.open_level then
            return true
        end
        return false
    end)
    local conBg = GetElement(self.m_root,"conBg",WZUIContainer)
    local group = GetElement(conBg,"group_WndBagMain",WZUICheckBoxGroup)
    local playerLevel = CacheCenter:getPlayerInfo().level
    for i,v in ipairs(tBtnList) do
        local element = GetElement(group,v[2],WZUICheckBox)
        if playerLevel >= GDatatab_button_info["id_"..v[1]].open_level  then 
            element:setVisible(true)
            element:setRelativePosition(GlobalMethod:ccp(psList[i][1],psList[i][2]))
        else
            element:setVisible(false)
        end
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndBagMain:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtLLLusion1_WndBagMain",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtLLLusion2_WndBagMain",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtCloset1_WndBagMain",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtCloset2_WndBagMain",WZUILabelTTF):setFontSize(22)
end

function WndBagMain:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCloset1_WndBagMain",WZUILabelTTF):setFontSize(24)
    GetElement(self.m_root,"txtCloset2_WndBagMain",WZUILabelTTF):setFontSize(24)

    GetElement(self.m_root,"btnTotalAttrTip_WndBagMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.27,0.951))
end

function WndBagMain:_adaptLanguage_es(  )    
    GetElement(self.m_root,"btnTotalAttrTip_WndBagMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.27,0.951))
    self:_adaptLanguage_en()
    GetElement(self.m_root,"txtLLLusion1_WndBagMain",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtLLLusion2_WndBagMain",WZUILabelTTF):setScale(0.6)
end

function WndBagMain:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtEquipment1_WndBagMain",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtEquipment2_WndBagMain",WZUILabelTTF):setScale(0.8)
    
    GetElement(self.m_root,"txtExtraction1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtExtraction2_WndBagMain",WZUILabelTTF):setScale(0.7)
   
    GetElement(self.m_root,"btnTotalAttrTip_WndBagMain",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.225,0.951))
    GetElement(self.m_root,"txtPractice1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtPractice2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtLLLusion1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtLLLusion2_WndBagMain",WZUILabelTTF):setScale(0.7)
end

function WndBagMain:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtEquipment1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtEquipment2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtLLLusion1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtLLLusion2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCloset1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtCloset2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtAscending1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtAscending2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtExtraction1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtExtraction2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtDesignation1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtDesignation2_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtPractice1_WndBagMain",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtPractice2_WndBagMain",WZUILabelTTF):setScale(0.7)
end

function WndBagMain:_adaptLanguage_ug(  )
    local txtEquipment1 = GetElement(self.m_root,"txtEquipment1_WndBagMain",WZUILabelTTF)
    txtEquipment1:setScale(0.7)
    txtEquipment1:setDimensions(GlobalMethod:CCSize(120))
    local txtEquipment2 = GetElement(self.m_root,"txtEquipment2_WndBagMain",WZUILabelTTF)
    txtEquipment2:setScale(0.7)
    txtEquipment2:setDimensions(GlobalMethod:CCSize(120))
    local txtLLLusion1 = GetElement(self.m_root,"txtLLLusion1_WndBagMain",WZUILabelTTF)
    txtLLLusion1:setScale(0.7)
    txtLLLusion1:setDimensions(GlobalMethod:CCSize(120))
    local txtLLLusion2 = GetElement(self.m_root,"txtLLLusion2_WndBagMain",WZUILabelTTF)
    txtLLLusion2:setScale(0.7)
    txtLLLusion2:setDimensions(GlobalMethod:CCSize(120))
    local txtCloset1 = GetElement(self.m_root,"txtCloset1_WndBagMain",WZUILabelTTF)
    txtCloset1:setScale(0.7)
    txtCloset1:setDimensions(GlobalMethod:CCSize(120))
    local txtCloset2 = GetElement(self.m_root,"txtCloset2_WndBagMain",WZUILabelTTF)
    txtCloset2:setScale(0.7)
    txtCloset2:setDimensions(GlobalMethod:CCSize(120))
    local txtAscending1 = GetElement(self.m_root,"txtAscending1_WndBagMain",WZUILabelTTF)
    txtAscending1:setScale(0.7)
    txtAscending1:setDimensions(GlobalMethod:CCSize(120))
    local txtAscending2 = GetElement(self.m_root,"txtAscending2_WndBagMain",WZUILabelTTF)
    txtAscending2:setScale(0.7)
    txtAscending2:setDimensions(GlobalMethod:CCSize(120))
    local txtExtraction1 = GetElement(self.m_root,"txtExtraction1_WndBagMain",WZUILabelTTF)
    txtExtraction1:setScale(0.7)
    txtExtraction1:setDimensions(GlobalMethod:CCSize(120))
    local txtExtraction2 = GetElement(self.m_root,"txtExtraction2_WndBagMain",WZUILabelTTF)
    txtExtraction2:setScale(0.7)
    txtExtraction2:setDimensions(GlobalMethod:CCSize(120))
    local txtDesignation1 = GetElement(self.m_root,"txtDesignation1_WndBagMain",WZUILabelTTF)
    txtDesignation1:setScale(0.7)
    txtDesignation1:setDimensions(GlobalMethod:CCSize(120))
    local txtDesignation2 = GetElement(self.m_root,"txtDesignation2_WndBagMain",WZUILabelTTF)
    txtDesignation2:setScale(0.7)
    txtDesignation2:setDimensions(GlobalMethod:CCSize(120))
    local txtPractice1 = GetElement(self.m_root,"txtPractice1_WndBagMain",WZUILabelTTF)
    txtPractice1:setScale(0.7)
    txtPractice1:setDimensions(GlobalMethod:CCSize(120))
    local txtPractice2 = GetElement(self.m_root,"txtPractice2_WndBagMain",WZUILabelTTF)
    txtPractice2:setScale(0.7)
    txtPractice2:setDimensions(GlobalMethod:CCSize(120))
end
-------------------------------------语言适配End------------------------------------------