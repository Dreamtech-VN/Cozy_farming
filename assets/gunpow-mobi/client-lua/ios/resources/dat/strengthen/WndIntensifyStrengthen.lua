--WndIntensifyStrengthen.lua
--@brief	WndIntensifyStrengthen的UI模块
--@date		2014/8/16
--@author	zsq
--@note		强化窗口

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndIntensifyStrengthen:onEnter(element)
	self.m_root = element
    if ProjConfig.CHANNEl_ID == 1048 or ProjConfig.CHANNEl_ID == 1051 
        or ProjConfig.CHANNEL_ID == 1053 then
        GetElement(self.m_root,"btnIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(false)
        GetElement(self.m_root,"btnOneKeyIntensify_WndIntensifyStrengthen",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.5,0.06))
    end
	
	--初始化强化信息
	self:_updateIntensifyInfo()
	
	--切换聊天频道
	ChangeChatChannel(Chat_Channel_Forged_Strengthen)

	--多语言版本界面适配
	AdaptLanguage(self)

	self.m_nMaxStrongLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)

	WZLog("WndIntensifyStrengthen:onEnter",self.m_nMaxStrongLevel)

    Teach:isStartTeach("WndIntensifyStrengthen:onEnter")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndIntensifyStrengthen:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndIntensifyStrengthen:onExit")
end

--@brief	强化按钮被按下时调用的函数
--@param	element:强化按钮的UI节点引用
--@note		在这里做强化按钮被按下时的响应操作
function WndIntensifyStrengthen:onIntensify(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local isFinish9, finishStep9 = TeachGroup1:isTeachFinish(9)
    if isFinish9 ~= true and finishStep9 > 0 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
        --TeachGroup1:endTeachStep({9,5})
        --TeachGroup1:startGroup({9,6, WndStrengthen.m_root})
    end

	--测试在队列中按顺序弹出提示
	--PopupResult("ui/common/common_icon_qhz.png")
	--upPlayerFightingAni()
	--popupAchie("测试成就")
	--do return end

	--正在强化直接返回
	if self.m_bIsIntensifing == true then 
		local con = GetElement(self.m_root,"conMid_WndIntensifyStrengthen",WZUIContainer)
		con:enableSchedule("enableIntensify",0.35)
		return 
	end

    --判断是否添加装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
    --判断当前强化等级是否达到最高等级
	local strongLevel = self.m_tCurSelectedEquip.extraInfo.strongLevel
	local levelLimit = CacheCenter:getPlayerInfo().level
	local maxLevel = self.m_nMaxStrongLevel
	if self.m_tCurSelectedEquip.basicInfo.quality == 4 then
		maxLevel = self.m_nMaxStrongLevel * 2
		if maxLevel > 200 then maxLevel = 200 end
		levelLimit = CacheCenter:getPlayerInfo().level * 2
	end
    if strongLevel >= maxLevel then
        MsgBoxManager:showTipBox(LocalStrings.REACH_TOP_STRENGTHENLEVEL)
        return
    end
    if strongLevel >= levelLimit then
        MsgBoxManager:showTipBox(LocalStrings.STRENGTHEN2)
        return
    end
    --判断金币是否足够
    local playerGold = CacheCenter:getMoneyList().gold
	WZLog("强化需要金币",self.m_nNeedGold)
	WZLog("身上金币    ",playerGold)
    if tonumber(self.m_nNeedGold) > tonumber(playerGold) then
        MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
        return
    end

	self.m_bIsIntensifing = true

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
	
	local img = GetElement(WndStrengthen.m_root,"InBg1_WndStrengthen",WZUIImage)
	--img:stopAllActions()
	local actionRotateBy = CCRotateBy:create(1,540)
    img:runAction(actionRotateBy)

	local stoneId = WZLuaVector_int_:create()
	ProtocolProcessorStrengthen:send_FORGING_MergeNew(self.m_tCurSelectedEquip.playerItemId, 1 )
    self:_createLoading()
	
	--播放特效后隐藏特效
	self.m_bShowAni = true
	self.m_root:enableSchedule("onAni1",0.1)

	WndStrengthen:setHasStringthen(3)
end

--@brief	一键强化
function WndIntensifyStrengthen:onOneKeyIntensify(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --判断是否添加装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
	--判断vip等级
    if CacheCenter:getPlayerInfo().vipLevel < 1 then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 1)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		return
	end
    --判断当前强化等级是否达到最高等级
	local strongLevel = self.m_tCurSelectedEquip.extraInfo.strongLevel
	local levelLimit = CacheCenter:getPlayerInfo().level
	local maxLevel = self.m_nMaxStrongLevel
	if self.m_tCurSelectedEquip.basicInfo.quality == 4 then
		maxLevel = self.m_nMaxStrongLevel * 2
		if maxLevel > 200 then maxLevel = 200 end
		levelLimit = CacheCenter:getPlayerInfo().level * 2
	end
    if strongLevel >= maxLevel then
        MsgBoxManager:showTipBox(LocalStrings.REACH_TOP_STRENGTHENLEVEL)
        return
    end
    if strongLevel >= levelLimit then
        MsgBoxManager:showTipBox(LocalStrings.STRENGTHEN2)
        return
    end

    --判断金币是否足够
    local playerGold = CacheCenter:getMoneyList().gold
    if self.m_nNeedGold > playerGold then
        MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
        return
    end

	--正在强化直接返回
	if self.m_bIsIntensifing == true then 
		local con = GetElement(self.m_root,"conMid_WndIntensifyStrengthen",WZUIContainer)
		con:enableSchedule("enableIntensify",0.35)
		return 
	end
	self.m_bIsIntensifing = true

	local img = GetElement(WndStrengthen.m_root,"InBg1_WndStrengthen",WZUIImage)
	local actionRotateBy = CCRotateBy:create(1,540)
    img:runAction(actionRotateBy)

	local stoneId = WZLuaVector_int_:create()
	ProtocolProcessorStrengthen:send_FORGING_MergeNew(self.m_tCurSelectedEquip.playerItemId, 2 )
    self:_createLoading()
	
	--播放特效后隐藏特效
	self.m_bShowAni = true
	self.m_root:enableSchedule("onAni1",0.1)

	WndStrengthen:setHasStringthen(3)
end

function WndIntensifyStrengthen:enableIntensify()
	WZLog("WndIntensifyStrengthen:enableIntensify")
	local con = GetElement(self.m_root,"conMid_WndIntensifyStrengthen",WZUIContainer)
	con:disableSchedule()
	self.m_bIsIntensifing = false
end

--@brief	提示框的回调
function WndIntensifyStrengthen:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief	Bag动画加载完成回调
function WndIntensifyStrengthen:onAni1(element,t)
	element:disableSchedule()

	--隐藏特效
	local armature_WndImproveStrengthen = GetElement(self.m_root,"armature_WndIntensifyStrengthen",WZArmature)
	armature_WndImproveStrengthen:setVisible(false)

    --显示强化结果
	if self.m_bShowAni == true then
		armature_WndImproveStrengthen:setVisible(true)
		armature_WndImproveStrengthen:play("5")
		self.m_bShowAni = false

		--播放特效后隐藏特效
		self.m_root:enableSchedule("onAni1",0.95)
	end
end


--@brief    购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function WndIntensifyStrengthen:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief    添加或取消装备时调用
--@author   zsq
function WndIntensifyStrengthen:addEquipToCell(tEquip)
    self.m_tCurSelectedEquip = tEquip

	if tEquip == nil then
    	GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"conIntensifyInfo_WndIntensifyStrengthen",WZUIContainer):setVisible(false)
	else
    	GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"conIntensifyInfo_WndIntensifyStrengthen",WZUIContainer):setVisible(true)
	end

    --更新数据
    self:_updateIntensifyInfo()
end

--@brief	强化结果回调
function WndIntensifyStrengthen:onIntensifyResult()
	self.m_bIsIntensifing = false
    self:_closeLoading()
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)

    --显示强化结果
	PopupResult("ui/common/common_icon_qhz.png")

	WndStrengthen:checkIntensifyLevel()
end

--@brief	设置最高级状态
--@param	state:"normal","userLevel","topLevel"
function WndIntensifyStrengthen:setDisplayState(state)
	if state == "normal" then
		GetElement(self.m_root,"conCost",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"btnIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnOneKeyIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(true)
		GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"conLeftAttr",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0,0.5))
		GetElement(self.m_root,"conRightAttr",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txtLevel_WndIntensifyStrengthen",WZUILabelTTF):setVisible(true)
	elseif state == "userLevel" then
		GetElement(self.m_root,"conCost",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnOneKeyIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(false)
		GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"conLeftAttr",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.28,0.5))
		GetElement(self.m_root,"conRightAttr",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtLevel_WndIntensifyStrengthen",WZUILabelTTF):setVisible(false)
	elseif state == "topLevel" then
		GetElement(self.m_root,"conCost",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"btnIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnOneKeyIntensify_WndIntensifyStrengthen",WZUIButton):setVisible(false)
		GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"conLeftAttr",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.28,0.5))
		GetElement(self.m_root,"conRightAttr",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtLevel_WndIntensifyStrengthen",WZUILabelTTF):setVisible(false)
	end
	if self.m_tCurSelectedEquip == nil then
		GetElement(self.m_root,"imgArrow",WZUI9Image):setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新强化信息
--@brief	更新强化信息
function WndIntensifyStrengthen:_updateIntensifyInfo()
    local dataTable = self:_getStrengthEquipData()

    local equipCurLv = dataTable.eCurLevel --1装备当前强化等级
    local equipNextLv = dataTable.eNextLevel--2装备下一级强化等级
    local equipCurAttr = dataTable.eCurAttrAdd --3装备当前强化属性加成
    local equipNextAttr = dataTable.eNextAttrAdd--4装备下一级强化属性加成
    local goldCostNum = dataTable.eCostGold --10消耗金币

    self.m_nNeedGold = goldCostNum

    --装备当前等级
	local txtLevel = GetElement(self.m_root, "txtLevel_WndIntensifyStrengthen", WZUILabelTTF)
	txtLevel:setText(equipCurLv)
	--装备提升等级
	local txtLevelUp = GetElement(self.m_root, "txtLevelUp_WndIntensifyStrengthen", WZUILabelTTF)
	txtLevelUp:setText(equipNextLv)
	--装备当前属性加成  改为固定第一条属性
	local txtHP = GetElement(self.m_root, "txtHP_WndIntensifyStrengthen", WZUIFreeTextBox)
	txtHP:setShowText(equipCurAttr)
	--装备强化后属性加成
	local txtHPUp = GetElement(self.m_root, "txtHPUp_WndIntensifyStrengthen", WZUIFreeTextBox)
	txtHPUp:setShowText(equipNextAttr)

    --消耗金币
    local txtCost = GetElement(self.m_root, "txtCost_WndIntensifyStrengthen", WZUILabelTTF)
    txtCost:setText(goldCostNum)

end

--@brief    获取强化的装备的数据
--@author   zsq
function WndIntensifyStrengthen:_getStrengthEquipData()
    local tEquipInfo = {}
    tEquipInfo.eCurLevel = ""   --当前强化等级
    tEquipInfo.eNextLevel = ""  --下一强化等级
    tEquipInfo.eCurAttrAdd = "" --当前属性加成
    tEquipInfo.eNextAttrAdd = ""--下一级属性加成
    tEquipInfo.eCostGold = 0    --消耗金币数量

    if  self.m_tCurSelectedEquip == nil then return tEquipInfo end
    --强化等级
    local curLv = self.m_tCurSelectedEquip.extraInfo.strongLevel
    tEquipInfo.eCurLevel = string.format(LocalStrings.LV.."%d",curLv)
	local maxLevel = self.m_nMaxStrongLevel
	if self.m_tCurSelectedEquip.basicInfo.quality == 4 then
		maxLevel = self.m_nMaxStrongLevel * 2
		if maxLevel > 200 then maxLevel = 200 end
	end
    if curLv < maxLevel then
        tEquipInfo.eNextLevel = string.format(LocalStrings.LV.."%d",curLv+1)
    end
    --属性加成
    local property = self.m_tCurSelectedEquip.basicInfo.property
    local equality = self.m_tCurSelectedEquip.basicInfo.quality

    if property[1] ~= nil then
        local attrType = property[1][1]
        local curAttrAdd,nextAttrAdd
		--计算基础属性
		local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
		local equality = self.m_tCurSelectedEquip.basicInfo.quality
		local strongLevel = self.m_tCurSelectedEquip.extraInfo.strongLevel 
		local baseAttr = property[1][2] + WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[1][1]).attrAdd
		--镶嵌属性
		local gemAttr = 0

		if starLevel == 0 then
			starRate = 0
		else
			starRate = GDatatab_stars_up["id_"..starLevel].property_rate/10000
		end

        --if curLv == 0 then
        if false then
            --local tInfo = self:getStrengthenTableInfo(equality,1,attrType)
            --curAttrAdd = self.m_tCurSelectedEquip.extraInfo[tostring(property[1][1])]
            --nextAttrAdd = curAttrAdd + tInfo.attrAdd
        elseif curLv == maxLevel then
            curAttrAdd = self.m_tCurSelectedEquip.extraInfo[tostring(property[1][1])]
            nextAttrAdd = 0
        else
            local tStrongInfo1 = self:getStrengthenTableInfo(equality,curLv,attrType)
            local tStrongInfo2 = self:getStrengthenTableInfo(equality,curLv+1,attrType)
            curAttrAdd = self.m_tCurSelectedEquip.extraInfo[tostring(property[1][1])]
            --nextAttrAdd = curAttrAdd - tStarInfo1.attrAdd + tStarInfo2.attrAdd
			nextAttrAdd = curAttrAdd + math.ceil((property[1][2] + tStrongInfo2.attrAdd)*(1+starRate)) 
				- math.ceil((property[1][2] + tStrongInfo1.attrAdd)*(1+starRate))
			--nextAttrAdd = curAttrAdd + ( tStrongInfo2.attrAdd - tStrongInfo1.attrAdd)*(1+starRate)
        end
        local attrName = ATTR_TITLE[property[1][1]]
		local eCurAttrAdd = [[<T C="233,166,62" S="20" P="0">%s</T><T C="255,236,193" S="20" P="0"> +%d</T>]]
        tEquipInfo.eCurAttrAdd = string.format(eCurAttrAdd, attrName,curAttrAdd)
        if curLv < maxLevel then
			local eNextAttrAdd = [[<T C="233,166,62" S="20" P="0">%s</T><T C="99,255,95" S="20" P="0"> +%d</T>]]
            tEquipInfo.eNextAttrAdd = string.format(eNextAttrAdd,attrName,nextAttrAdd)
        end
    end

    --消耗金币
    if curLv < maxLevel then
        local tInfo = self:getStrengthenTableInfo(equality,curLv+1,attrType)
        local nStarCost = tInfo.cost
        tEquipInfo.eCostGold = nStarCost
    end

    return tEquipInfo
end

--@brief    获取升星信息表数据
--@param    装备品质、升星等级、属性类别
function WndIntensifyStrengthen:getStrengthenTableInfo(eQuality, eStarLevel, eAttrType)
    WZLog("WndIntensifyStrengthen:getStrengthenTableInfo(eQuality , eStarLevel)",eQuality,eStarLevel,eAttrType)
	if eStarLevel == 0 then t = {attrAdd = 0} return t end
    local t = nil
    for i,v in pairs(GDatatab_strengthen_up) do
        if v.quality == eQuality and v.level == eStarLevel then
            t = {}
            t.cost = v.cost[1][2] --花费
            if eAttrType == nil then break end
            for j,vj in pairs (v.property) do
                if vj[1] == eAttrType then
                    t.attrAdd = vj[2] --属性加成
                    break
                end
            end
            break
        end
    end
    return t
end


function WndIntensifyStrengthen:_adaptLanguage_vn()
    WZLog("WndIntensifyStrengthen:_adaptLanguage_vn ")
    local btnIntensify = GetElement(self.m_root,"btnIntensify_WndIntensifyStrengthen",WZUIButton)
    btnIntensify:setAbsContentSize(GlobalMethod:CCSize(160,60))
    btnIntensify:updateRelativeSize()

    for i=1,3 do
        local txtIntensify = GetElement(btnIntensify,"txtIntensify"..i.."_WndIntensifyStrengthen",WZUILabelTTF)
        txtIntensify:setScale(0.7)
    end
end

--@brief    英文包适配函数
function WndIntensifyStrengthen:_adaptLanguage_en()
    if self.m_root == nil then
        return
    end
    GetElement(self.m_root,"txtIntensify1_WndIntensifyStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtIntensify2_WndIntensifyStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtIntensify3_WndIntensifyStrengthen",WZUILabelTTF):setScale(0.8)

    local txtHP = GetElement(self.m_root,"txtHP_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHP:setMaxWidth(180)
    txtHP:setScale(0.8)
    local txtHPUp = GetElement(self.m_root,"txtHPUp_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHPUp:setMaxWidth(180)
    txtHPUp:setScale(0.8)
end

function WndIntensifyStrengthen:_adaptLanguage_pt(  )
    if self.m_root == nil then
        return
    end
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(120))
    txtIntensify1:setAlignment(kCCTextAlignmentCenter)
    txtIntensify1:setScale(0.8)
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(120))
    txtIntensify2:setAlignment(kCCTextAlignmentCenter)
    txtIntensify2:setScale(0.8)
    local txtIntensify3 = GetElement(self.m_root,"txtIntensify3_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify3:setDimensions(GlobalMethod:CCSize(120))
    txtIntensify3:setAlignment(kCCTextAlignmentCenter)
    txtIntensify3:setScale(0.8)

    local txtHP = GetElement(self.m_root,"txtHP_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHP:setMaxWidth(180)
    txtHP:setScale(0.8)
    local txtHPUp = GetElement(self.m_root,"txtHPUp_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHPUp:setMaxWidth(180)
    txtHPUp:setScale(0.8)
end

function WndIntensifyStrengthen:_adaptLanguage_tr()
    local txtIntensify1 = GetElement(self.m_root,"txtIntensify1_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify1:setDimensions(GlobalMethod:CCSize(120,0))
    txtIntensify1:setAlignment(kCCTextAlignmentCenter)
    txtIntensify1:setScale(0.75)
    local txtIntensify2 = GetElement(self.m_root,"txtIntensify2_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify2:setDimensions(GlobalMethod:CCSize(120,0))
    txtIntensify2:setAlignment(kCCTextAlignmentCenter)
    txtIntensify2:setScale(0.75)
    local txtIntensify3 = GetElement(self.m_root,"txtIntensify3_WndIntensifyStrengthen",WZUILabelTTF)
    txtIntensify3:setDimensions(GlobalMethod:CCSize(120,0))
    txtIntensify3:setAlignment(kCCTextAlignmentCenter)
    txtIntensify3:setScale(0.75)
end

function WndIntensifyStrengthen:_adaptLanguage_es(  )
    for i=1,3 do
        local txtIntensify = GetElement(self.m_root,"txtIntensify"..i.."_WndIntensifyStrengthen",WZUILabelTTF)
        txtIntensify:setScale(0.8)
        txtIntensify:setDimensions(GlobalMethod:CCSize(120,0))
    end
    local txtCost1 = GetElement(self.m_root,"txtCost1_WndIntensifyStrengthen",WZUILabelTTF)
    txtCost1:setFontSize(18)
    txtCost1:setRelativePosition(GlobalMethod:ccp(0.05,0.5))

    local txtHP = GetElement(self.m_root,"txtHP_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHP:setMaxWidth(180)
    txtHP:setScale(0.8)
    local txtHPUp = GetElement(self.m_root,"txtHPUp_WndIntensifyStrengthen",WZUIFreeTextBox)
    txtHPUp:setMaxWidth(180)
    txtHPUp:setScale(0.8)
end
-------------------------------------私有方法模块End----------------------------------------
