--WndConfirmBoxWithOtherWidgetWithOtherWidget.lua
--@brief	WndConfirmBoxWithOtherWidgetWithOtherWidget的UI模块
--@date		2021/11/29
--@author	nijinlin
--@note		一个弹框提示，可以添加其他控件


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndConfirmBoxWithOtherWidget:onEnter(element)
	self.m_root = element
    
    local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
	txtConfirm:setText(LocalStrings.CONFIRM)
	
	self:_update()

    WZLog("WndConfirmBoxWithOtherWidget:onEnter")

    if TeachGroup1 and TeachGroup1.SCHEDULE then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
    end
    WindowManager:removeTeachShelterLayer()
    if TeachGroup1 then
    	TeachGroup1:removeTeachAnim()
	end

    if WndTeachTalk then
        WndTeachTalk:removeWindow()
    end
	
	AdaptLanguage(self)

	--显示倒计时

	local conCountdown = GetElement(self.m_root, "conCountdown_WndConfirmBoxWithOtherWidget", WZUIContainer)
	local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
	if self.m_tMsgData ~= nil then
		WZLog("WndConfirmBoxWithOtherWidget:onEnter self.m_tMsgData.nTime = ", self.m_tMsgData.nTime)
		if  self.m_tMsgData.nTime and  self.m_tMsgData.nTime > 0 then
			-- nTime > 0，注销状态，需要倒计时，这时将确认按钮显示为撤销删除LocalStrings.DELETEROLE_TEXT5
			if conCountdown then 
				conCountdown:setVisible(true)
			end
			if txtConfirm and LocalStrings and LocalStrings.DELETEROLE_TEXT5 then
				txtConfirm:setText(LocalStrings.DELETEROLE_TEXT5)
			end
		end
		-- status : 角色状态,0、禁言,1、正常,2、注销
		if self.m_tMsgData.nPlayerStatus and self.m_tMsgData.nPlayerStatus == 2 then
			txtConfirm:setText(LocalStrings.DELETEROLE_TEXT5)
		end
	end
	
	--设置角色信息
	self:initPlayerInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndConfirmBoxWithOtherWidget:onExit(element)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	end
	self:_unInit()
end

--@brief	加载动画
function WndConfirmBoxWithOtherWidget:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true)
end

--@brief	关闭整个窗口的动画效果
function WndConfirmBoxWithOtherWidget:onCloseActionCallback(elem,data)
    if self.m_action == MSGBOXRESTYPE_CONFIRM and self.m_tMsgData ~= nil then 
        self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
    end
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	点击关闭按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmBoxWithOtherWidget:onCancel(element)
	WZLog("WndConfirmBoxWithOtherWidget:onCancel")
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		--self:_msgCallBack(MSGBOXRESTYPE_CANCEL)
        self.m_action = MSGBOXRESTYPE_CANCEL
		WZLog("WndConfirmBoxWithOtherWidget:onCancel1",type(self.m_tMsgData.tCallbackLuaObj),type(self.m_tMsgData.fCallbackCancel))
        if self.m_tMsgData.tCallbackLuaObj and self.m_tMsgData.fCallbackCancel then
		  self.m_tMsgData.fCallbackCancel(self.m_tMsgData.tCallbackLuaObj)
        end
	end
	self:onBtnDelRoleClickCancel()
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

--@brief	点击确认按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmBoxWithOtherWidget:onConfirm(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		--self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
        self.m_action = MSGBOXRESTYPE_CONFIRM
	end
	self:onBtnDelRoleConfirmResult()
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

--@brief	删除角色btn的点击回调-确认
--@param	element:表绑定的UI节点引用 第一个参数为消息id，第二个参数为响应类型(超时，确定，取消)
function WndConfirmBoxWithOtherWidget:onBtnDelRoleConfirmResult()
	WZLog("sun---WndConfirmBoxWithOtherWidget:onBtnDelRoleConfirmResult")
	--发送删除角色协议
	local id = CacheCenter:getPlayerInfo().id -- 角色id
	local optType = 0-- 0、注销，1、取消注销
	if GlobalGame.g_tPlayerInfo.nPlayerStatus and GlobalGame.g_tPlayerInfo.nPlayerStatus == 2 then
		optType = 1
	end
	ProtocolProcessorAccount:send_ACCOUNT_Unregister(id, optType)
end

--@brief	删除角色btn的点击回调-返回或取消
--@param	element:表绑定的UI节点引用
function WndConfirmBoxWithOtherWidget:onBtnDelRoleClickCancel()
	WZLog("sun---WndConfirmBoxWithOtherWidget:onBtnDelRoleClickCancel")
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		超时后回调，并且移出窗口
function WndConfirmBoxWithOtherWidget:scheduleTimeout(element, delta)
	WZLog("WndConfirmBoxWithOtherWidget:scheduleTimeout")
	element:disableSchedule()
	if self.m_root == nil then
		return
	end
	
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_TIMEOUT)
	end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

--@note     检查中文
function WndConfirmBoxWithOtherWidget:checkChinese(str)
    local isChinese = false
    for ch in string.gmatch(str, "[\\0-\127\194-\244][\128-\191]*") do
        isChinese = #ch~=1
    end
    WZLog("WndConfirmBoxWithOtherWidget:checkChinese", str , isChinese)
    return isChinese
end

--@brief	初始化
--@note		界面前的所有初始化
function WndConfirmBoxWithOtherWidget:initPlayerInfo()
    WZLog("WndConfirmBoxWithOtherWidget:initPlayerInfo one", CacheCenter:getPlayerInfo().level, g_CityTopBtnState)

 --    conUp_WndConfirmBoxWithOtherWidget
	-- conBtnFigure_WndConfirmBoxWithOtherWidget
	-- btnFigure_WndConfirmBoxWithOtherWidget		onClickFigure
	-- conExp_WndConfirmBoxWithOtherWidget
	-- progressExp_WndConfirmBoxWithOtherWidget
	-- txtExp_WndConfirmBoxWithOtherWidget
	-- conHead_WndConfirmBoxWithOtherWidget
	-- imgFightFlag_WndConfirmBoxWithOtherWidget
	-- imgFight_WndConfirmBoxWithOtherWidget
	-- txtName_WndConfirmBoxWithOtherWidget
	-- txtFight_WndConfirmBoxWithOtherWidget
	-- txtLv_WndConfirmBoxWithOtherWidget
	-- imgVip0_WndConfirmBoxWithOtherWidget
	-- imgVip1_WndConfirmBoxWithOtherWidget
	-- txtVip_WndConfirmBoxWithOtherWidget
	-- imgProfessionIcon_WndConfirmBoxWithOtherWidget


    local playerInfo = CacheCenter:getPlayerInfo()
    if playerInfo == nil then
    	return
    end

    local txtName = GetElement(self.m_root, "txtName_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
    txtName:setText(playerInfo.name)
    local isChinese = self:checkChinese(playerInfo.name)
    if isChinese and txtName:getWordCount() >= 7 then
       txtName:setMaxLength(5)
    elseif not isChinese then
        if txtName:getWordCount() >= 13 then
            txtName:setMaxLength(10)
            WZLog("WndConfirmBoxWithOtherWidget:initPlayerInfo four1")
        else
            txtName:setMaxLength(12)
            WZLog("WndConfirmBoxWithOtherWidget:initPlayerInfo four2")
        end
    end
    txtName:setText(playerInfo.name)

    local txtLv = GetElement(self.m_root, "txtLv_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
    txtLv:setText(playerInfo.level)

    local txtFight = GetElement(self.m_root, "txtFight_WndConfirmBoxWithOtherWidget", WZUILabelAtlasFont)
    txtFight:setText(playerInfo.fighting)

	--人物经验条
	local exp = playerInfo.exp
	local maxExp = playerInfo.maxExp
	local percent = math.floor(tonumber(exp)*100/tonumber(maxExp))
	WZLog("经验条",percent, exp, maxExp)
	GetElement(self.m_root,"progressExp_WndConfirmBoxWithOtherWidget",WZUIProgress):setPercentage(percent)
    local txtExp = GetElement(self.m_root, "txtExp_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
    txtExp:setText("" ..percent .. "%")

    --职业图标
    if playerInfo.professionId and playerInfo.professionId > 0 then 
        if CacheCenter:getPlayerInfo().professionAttr2 == "{}" then
            GetElement(self.m_root, "imgProfessionIcon_WndConfirmBoxWithOtherWidget", WZUIImage):setFile(g_professionIcon[playerInfo.professionId])
        else 
            GetElement(self.m_root, "imgProfessionIcon_WndConfirmBoxWithOtherWidget", WZUIImage):setFile(g_professionIcon2[playerInfo.professionId])
        end
        txtName:setRelativePosition(GlobalMethod:ccp(1.449, 0.75))
    else
        GetElement(self.m_root, "imgProfessionIcon_WndConfirmBoxWithOtherWidget", WZUIImage):setFile("")
        txtName:setRelativePosition(GlobalMethod:ccp(1.2,0.759))
    end

    local imgVip0 = GetElement(self.m_root, "imgVip0_WndConfirmBoxWithOtherWidget", WZUIImage)
    if tonumber(playerInfo.vipLevel) > 0 then
        local txtVip = GetElement(self.m_root, "txtVip_WndConfirmBoxWithOtherWidget", WZUILabelAtlasFont)
        txtVip:setText(playerInfo.vipLevel)
        txtVip:setVisible(true)

        imgVip0:setVisible(true)
        setVipIconByVipLevel(imgVip0, tonumber(playerInfo.vipLevel))
        GetElement(self.m_root, "imgVip1_WndConfirmBoxWithOtherWidget", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "txtVip_WndConfirmBoxWithOtherWidget", WZUILabelAtlasFont):setVisible(false)
        imgVip0:setVisible(false)
        GetElement(self.m_root, "imgVip1_WndConfirmBoxWithOtherWidget", WZUIImage):setVisible(false)
    end

    --local isUpdate = true
    --if isUpdate == nil then
        local conPlayerAni = self.m_root:getChildElement("conHead_WndConfirmBoxWithOtherWidget")
        local tEquip = CacheCenter:getEquipmentList()
        local head = nil
        local face = nil

        if tEquip and next(tEquip) then
            for i = 1, #tEquip do
                local nEquipId = tEquip[i]
                if nEquipId ~= nil then
                    if type(nEquipId) == "table" then nEquipId = nEquipId.id end
                    local tEquipData = GetItemLocalData(nEquipId)

                    if tEquipData then
                        local maintype = tEquipData.main_type
                        local subtype = tEquipData.sub_type
--                        WZLog("WndConfirmBoxWithOtherWidget:init two", i, maintype, subtype, Serialize(tEquipData))
                        if maintype == 5 and subtype == 1 then --物品是否是脸谱
                            face = (tEquipData.id)
                        elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
                            head = (tEquipData.id)
                        end
                    end
                end
            end
        end

        --设置默认显示
        local gameParam = CacheCenter:getGameParam()
        if bIsBoy == true then
            if head == nil then head = gameParam.defaultManHeadId or 4903 end
            if face == nil then face = gameParam.defaultManFaceId or 4902 end
        else
            if head == nil then head = gameParam.defaultWomanHeadId or 4906 end
            if face == nil then face = gameParam.defaultWomanFaceId or 4905 end
            --head = 6004
        end
        local color, bcolor = CacheCenter:getHeadAndBodyColor()
        local headEffectId = CacheCenter:getPlayerHeadEffectItemId()
        local headAnim, headObj = CellHead:show(conPlayerAni,head,face,playerInfo.sex,false,{x=0.52, y=0.28},nil,color,"ui/city/beta/common_scale9_zhezhaoheidifx02.png", 1, nil, nil, headEffectId)
        headAnim:setScale(0.9)
        self.m_tHeadAnim = headObj
        self.m_tHeadAnim:setHeadEffectScale(1.2)
    --end

end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		根据消息数据生成确认框
function WndConfirmBoxWithOtherWidget:_update()
	if self.m_root == nil or self.m_tMsgData == nil then
		return
	end
	WZLog("self.m_tMsgData.tCustomUIConfig: ", self.m_tMsgData.tCustomUIConfig, Serialize(self.m_tMsgData.tCustomUIConfig))
	GetElement(self.m_root, "txtCancel_WndConfirmBoxWithOtherWidget", WZUILabelTTF):setText(LocalStrings.BACK)
    self:_updateContent()
	
	if self.m_tMsgData.tCustomUIConfig ~= nil then
   --      if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE] ~= nil then
   --          local txtContent = GetElement(self.m_root, "txtContent_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
			-- txtContent:setFontSize(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE])
   --      end
		if self.m_tMsgData.tCustomUIConfig["MSGBOXUICFG_CANCEL"] ~= nil then
			local txt = GetElement(self.m_root, "txtCancel_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
			txt:setText(self.m_tMsgData.tCustomUIConfig["MSGBOXUICFG_CANCEL"])
		end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] ~= nil then
			local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
			txtConfirm:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM])
			if ProjConfig.LANGUAGE == "tr" then
				local txt = GetElement(self.m_root, "txtCancel_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
				txt:setDimensions(GlobalMethod:CCSize(140,0))
				txt:setScale(0.7)
				txtConfirm:setDimensions(GlobalMethod:CCSize(140,0))
				txtConfirm:setScale(0.7)
			end
		end

	end

	local txtCountdown = GetElement(self.m_root, "txtCountdown_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
	if self.m_tMsgData.nTime and self.m_tMsgData.nTime > 0 then
		txtCountdown:setText(returnToTimeFormat(self.m_tMsgData.nTime))
		self.m_root:enableSchedule("scheduleConfirm", 1)
	end
	
	if self.m_tMsgData.nTimeout > 0 then
		self.m_root:enableSchedule("scheduleTimeout", self.m_tMsgData.nTimeout)
	end
end

function WndConfirmBoxWithOtherWidget:scheduleConfirm(element)
	local txtCountdown = GetElement(self.m_root, "txtCountdown_WndConfirmBoxWithOtherWidget", WZUILabelTTF)

	self.m_tMsgData.nTime = self.m_tMsgData.nTime - 1
	if self.m_tMsgData.nTime > 0 then
		--WZLog("WndConfirmBoxWithOtherWidget:scheduleConfirm: ", returnToTimeFormat(self.m_tMsgData.nTime))
		txtCountdown:setText(returnToTimeFormat(self.m_tMsgData.nTime))
	else
		self.m_root:disableSchedule()
	end
end

--@brief	更新消息内容
--@note		根据配置判断是普通文本还是使用富文本框
function WndConfirmBoxWithOtherWidget:_updateContent()
--    local txtContent = GetElement(self.m_root, "txtContent_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
    -- local freetxtContent = GetElement(self.m_root, "txtFreeBox_WndConfirmBoxWithOtherWidget", WZUIFreeTextBox)
    -- freetxtContent = WZUIFreeTextBox:luaTo(freetxtContent)
    
    -- if self.m_tMsgData.tCustomUIConfig ~= nil and self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_USEFREETXT] == true then
    --     WZLog("************* WndConfirmBoxWithOtherWidget:_updateContent 111111********** ", self.m_tMsgData.sMsgBody)
    --     freetxtContent:setVisible(true)
    --     freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
    -- else
    --     WZLog("************* WndConfirmBoxWithOtherWidget:_updateContent 222222********** ", self.m_tMsgData.sMsgBody)
    --     freetxtContent:setVisible(true)
    --     freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
    -- --    txtContent:setText(self.m_tMsgData.sMsgBody)
    -- end
    local txtContext= GetElement(self.m_root, "txtContext_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
    if txtContext then
    	txtContext:setText("")
    end

    local txtFreeBox  = GetElement(self.m_root, "txtFreeBox_WndConfirmBoxWithOtherWidget", WZUIFreeTextBox)
    if txtFreeBox then
    	txtFreeBox:setShowText("")
    end

    local findIndex = string.find(self.m_tMsgData.sMsgBody,"<T")
    if findIndex == nil  then
    	txtContext:setText(self.m_tMsgData.sMsgBody)
    else
    	--local strContent = string.format([[<T S="24" C="62,34,8" P="0">%s</T>]], self.m_tMsgData.sMsgBody)
        txtFreeBox:setShowText(self.m_tMsgData.sMsgBody)
    end
    

    if self.m_tMsgData.bIsOnlyOneButton == true then
        GetElement(self.m_root, "btnCancel_WndConfirmBoxWithOtherWidget", WZUIButton):setVisible(false)
        GetElement(self.m_root, "btnConfirm_WndConfirmBoxWithOtherWidget", WZUIButton):setRelativePosition(ccp(0.5,0.17))
    end

	--离线重连不显示返回按钮
	if self.m_tMsgData.sMsgBody == LocalStrings.NETWORK_UNAVAILABLE then
		GetElement(self.m_root, "btnCancel_WndConfirmBoxWithOtherWidget", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnConfirm_WndConfirmBoxWithOtherWidget", WZUIButton):setRelativePosition(ccp(0.5,0.17))
	end

    --红色提示语
    if self.m_tMsgData.RedAttText then
        txtFreeBox:setRelativePosition(ccp(0.5, 0.63))
        txtContext:setRelativePosition(ccp(0.5, 0.63))
        local txtRedAtt = GetElement(self.m_root, "txtRedAtt_WndConfirmBoxWithOtherWidget", WZUILabelTTF)
        txtRedAtt:setVisible(true)
        txtRedAtt:setText(self.m_tMsgData.RedAttText)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndConfirmBoxWithOtherWidget:_adaptLanguage_en()
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF)
	txtContext:setFontSize(20)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	--txt:setDimensions(GlobalMethod:CCSize(280,0))
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(420)
end

function WndConfirmBoxWithOtherWidget:_adaptLanguage_pt(  )
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF)
	txtContext:setFontSize(20)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	local txtFree = GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox)
	txtFree:setMaxWidth(500)
	txtFree:setAbsContentSize(GlobalMethod:CCSize(330,100))
	txtFree:setUseAbsSize(true)
	txtFree:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtFree:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
	txtFree:setScale(0.8)
end

function WndConfirmBoxWithOtherWidget:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF):setFontSize(20)
	
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(800)
	txtFreeBox:setScale(0.8)
	if WndPetExchange == self.m_tMsgData.tCallbackLuaObj then
		txtFreeBox:setRelativePosition(GlobalMethod:ccp(1.15,0.5))
	end
end

function WndConfirmBoxWithOtherWidget:_adaptLanguage_vn()
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(400)
	txtFreeBox:setScale(0.8)

	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF)
	txtContext:setFontSize(20)
	txtContext:setRelativePosition(GlobalMethod:ccp(0.5,0.7))
end

function WndConfirmBoxWithOtherWidget:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox):setMaxWidth(380)
end

function WndConfirmBoxWithOtherWidget:_adaptLanguage_es()
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBoxWithOtherWidget",WZUILabelTTF)
	txtContext:setFontSize(18)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBoxWithOtherWidget",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(400)
	txtFreeBox:setScale(0.8)
end

-------------------------------------语言适配模块End--------------------------------------
