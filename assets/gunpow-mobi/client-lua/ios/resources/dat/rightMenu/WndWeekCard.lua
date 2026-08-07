--WndWeekCard.lua
--@brief	WndWeekCard的UI模块
--@date		2017/02/20
--@author	maopeiting
--@note		周卡福利


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWeekCard:onEnter(element)
	self.m_root = element
end

function WndWeekCard:onEnterTransitionDidFinish( element )
	WZLog("----WndWeekCard:onEnterTransitionDidFinish-----")
	if ProjConfig.CHANNEL_ID == 8888 or ProjConfig.CHANNEL_ID == 53 or ProjConfig.CHANNEL_ID == 75 or ProjConfig.CHANNEL_ID == 275 or ProjConfig.CHANNEL_ID == 68 or ProjConfig.CHANNEL_ID == 10 then
        WZLog("----WndWeekCard:onEnterTransitionDidFinish-----1")
        GetElement(self.m_root,"btn_WndWeekCard",WZUIButton):setVisible(false)
        GetElement(self.m_root,"txtCost_WndWeekCard",WZUILabelTTF):setVisible(false)
    end
    AdaptLanguage(self)
end

function WndWeekCard:showWindow()
    WZLog("WndWeekCard:showWindow 000000")
    if not WndWeekCard.m_root then
        return
    end
    WZLog("WndWeekCard:showWindow")
    if self.m_nCardActivityState == 0 then 
        self.m_root:enableSchedule("_caculateTime", 1)
    end
	self:_update()
end

function WndWeekCard:_update(  )

	WZLog("-----WndWeekCard:_update---")

	local nLastDay = self:_getWeekCardTime()
    local bIsGet = self:_isWeekCardRewardGet()
    -- if bIsGet then
    --     nLastDay = nLastDay - 1
    -- end
    local conLeftTime = GetElement(self.m_root, "conLeftTime_WndWeekCard", WZUIContainer)
    if nLastDay > 0 then
        conLeftTime:setVisible(true)
    else
        conLeftTime:setVisible(false)
    end
    --周卡剩余时间
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndWeekCard", WZUILabelTTF)
    txtTimeValue:setText(string.format(LocalStrings.SHOP_DAY, nLastDay))

	self:_setRewardsList()

	self:_initTxt()
    --活动折扣提示语
    if self.m_root:getChildByTag(999) then 
        self.m_root:removeChildByTag(999, true)
    end
    if self.m_nCardActivityState == 0 then 
        local textContent1
        local textContent2 
        if self.m_nBuyCardTimes <= 0 then 
            textContent1 = LocalStrings.CARD_ACTIVITY_TEXT3
            textContent2 = LocalStrings.CARD_ACTIVITY_TEXT2
        else
            textContent1 = LocalStrings.CARD_ACTIVITY_TEXT5 
            textContent2 = LocalStrings.CARD_ACTIVITY_TEXT4
        end
        local conTips = self:_createActivityTips(textContent1, textContent2)
        conTips:setRelativePosition(GlobalMethod:ccp(0.8, 0.35))
        self.m_root:addChild(conTips, 0, 999)
    end
	--local status = 0

	--获得玩家拥有的物品
	--local tempList = CacheCenter:getPlayerItems()

	--WZLog("---WndWeekCard:tempList1----",Serialize(tempList))

	-- if #tempList > 0 then
	-- 	for k,v in pairs(tempList) do
	-- 		if v.basicInfo and v.basicInfo.id == 55 then
	-- 			GetElement(self.m_root,"txtCost_WndWeekCard",WZUILabelTTF):setVisible(false)
 --            	GetElement(self.m_root,"btn_WndWeekCard",WZUIButton):setVisible(false)
 --            	GetElement(self.m_root,"imgGet_WndWeekCard",WZUIImage):setVisible(true)
	-- 			status = 1
	-- 			WZLog("---WndWeekCard:tempList2----",Serialize(v))
	-- 		end
	-- 	end
	-- end

 --    if status == 0 then
 --    	GetElement(self.m_root,"txtCost_WndWeekCard",WZUILabelTTF):setVisible(true)
 --        GetElement(self.m_root,"btn_WndWeekCard",WZUIButton):setVisible(true)
 --        GetElement(self.m_root,"imgGet_WndWeekCard",WZUIImage):setVisible(false)
 --        self:_initTxt()
 --    end
end

--@brief    获取周卡时间剩余天数
function WndWeekCard:_getWeekCardTime()
    --body
    local tPlayerItemsList = CacheCenter:getPlayerItems()
    if tPlayerItemsList == nil or tPlayerItemsList == {} then return end
    local nLastTime = 0
    for i = 1, #tPlayerItemsList do
        if tPlayerItemsList[i].id == 55 then
            nLastTime = nLastTime + tPlayerItemsList[i].lastTime
        end
    end

    WZLog("********* WndWeekCard:_getWeekCardTime *********", nLastTime)

    local nLastDays = (nLastTime - (os.time() - SETITEMSTIME)) / (24 * 3600)

    return math.ceil(nLastDays)
end

--@brief 	判断周卡是否被领取过
function WndWeekCard:_isWeekCardRewardGet()
    -- body
    self.m_tDailyTaskCompleted = PrefetchCache:getTaskList().tDailyTask.tCompleted

    if self.m_tDailyTaskCompleted == nil then
        return false
    end

    for i = 1, #self.m_tDailyTaskCompleted do
        local nTask_sub_type = GDatatab_task["id_"..self.m_tDailyTaskCompleted[i].nId].sub_type 
        if nTask_sub_type == 30030 and self.m_tDailyTaskCompleted[i].nTaskStatus >= TASKSTATUS_COMPLETED then 
            return true
        end
    end
    return false
end

--@brief    刷新剩余时间
function WndWeekCard:updateLeftDay()
    -- body
    if self.m_root == nil then return end
    WZLog("WndWeekCard:updateLeftDay")
    local nLastDay = self:_getWeekCardTime()
    local bIsGet = self:_isWeekCardRewardGet()
    -- if bIsGet then
    --     nLastDay = nLastDay - 1
    -- end
    local conLeftTime = GetElement(self.m_root, "conLeftTime_WndWeekCard", WZUIContainer)
    if nLastDay > 0 then
        conLeftTime:setVisible(true)
    else
        conLeftTime:setVisible(false)
    end
    --周卡剩余时间
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndWeekCard", WZUILabelTTF)
    txtTimeValue:setText(string.format(LocalStrings.SHOP_DAY, nLastDay))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWeekCard:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	购买按钮的回调函数
function WndWeekCard:onRecharge(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    -- WndGameActivity:_createLoading()
    -- popFastRechargeUI(55)

    local nLimiteDays = tonumber(CacheCenter:getGameParam().limitWeeklyCardDay)
    WZLog("--WndWeekCard:onRecharge--",nLimiteDays)
    if self:_getWeekCardTime() >= nLimiteDays then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MAX_Week_CARD, nLimiteDays))
    else
        WndGameActivity:_createLoading()
        popFastRechargeUI(55)
    end
end

--@brief	初始化界面
function WndWeekCard:_initTxt(  )
	WZLog("---WndWeekCard:_initTxt-----")
	local price = self:_getPrice(55)
	local txtPrice = GetElement(self.m_root,"txtCost_WndWeekCard",WZUILabelTTF)
	txtPrice:setUseSystemFont(true)
	txtPrice:setText(price)
end

--@brief	獲得周卡的價格
function WndWeekCard:_getPrice( itemId )
	WZLog("---WndWeekCard:_getPrice-----",itemId)
	local vipList = CacheCenter:getVipList()
	WZLog("WndWeekCard:vipList",Serialize(vipList))
	for i=1,#vipList do
		if vipList[i].itemId == itemId then
			WZLog("----WndWeekCard:price----",vipList[i].showPrice)
			return vipList[i].showPrice
		end
	end
end

--@brief	展示獎勵
function WndWeekCard:_setRewardsList(  )
	WZLog("---WndWeekCard:_setRewardsList-----")
	local tab = GetElement(self.m_root,"tab_WndWeekCard",WZUITableContainer)
	tab:cleanTable()

	local level = CacheCenter:getPlayerInfo().level

	for k,v in pairs(GDatatab_task) do
		if v.sub_type == 30030 and v.level <= level and v.max_level >= level then
			self.reward = v.reward
		end
	end
    table.sort( self.reward, sortRewards )
    --奖励大于3个时把金币放最后面
    if #self.reward > 3 then
        for k, v in pairs(self.reward) do
            if v[1] == 2 then
                table.insert(self.reward, v)
                table.remove(self.reward, k)
            end
        end
    end
	WZLog("---WndWeekCard:reward-----",Serialize(self.reward))
	for i=1,#self.reward do
		local id = string.format("id_".."%d",self.reward[i][1])
		local num = self.reward[i][2]
		local itemInfo = {id = GDatatab_item[id].id, name=GDatatab_item[id].name,icon=GDatatab_item[id].icon,lastTime=num,quality=GDatatab_item[id].quality,basicInfo=CopyTable(GDatatab_item[id])}
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell ~= nil then
			celElement:setTag(i-1)
			tCell:setCellGoodItem(itemInfo,4)
			tCell:setItemClickFun(self,self.onTips)
			tab:setCellElement(celElement)
		end
	end

end

--@brief	顯示tips
function WndWeekCard:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief    创建活动提示语
function WndWeekCard:_createActivityTips(text1, text2)
    -- body
    local conOutSide = WZUIContainer:create()
    conOutSide:setName("conOutSide" .. "_WndWeekCard")
    conOutSide:setUseAbsSize(true)
    conOutSide:setAbsContentSize(GlobalMethod:CCSize(200,60))

    --底1
    local img9BK1 = WZUI9Image:create()
    img9BK1:setFile("ui/common/common_scale9_di24.png")
    conOutSide:addChild(img9BK1)

    --数量
    if text1 then
        local ftxtText1 = WZUIFreeTextBox:create()
        ftxtText1:setMaxWidth(200)
        ftxtText1:setName("ftxtText1_WndWeekCard")
        if text2 then 
            ftxtText1:setRelativePosition(GlobalMethod:ccp(0.5,0.67))
        else
            ftxtText1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        end
        ftxtText1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        ftxtText1:setShowText(text1)
        conOutSide:addChild(ftxtText1)
    end
    if text2 then 
        local ftxtText2 = WZUIFreeTextBox:create()
        ftxtText2:setMaxWidth(200)
        ftxtText2:setName("ftxtText2_WndWeekCard")

         ftxtText2:setRelativePosition(GlobalMethod:ccp(0.5,0.33))
        ftxtText2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        ftxtText2:setShowText(text2)
        conOutSide:addChild(ftxtText2)
    end

    return conOutSide
end

--计算时间
function WndWeekCard:_caculateTime()
    -- body
    local nCurTime = SystemTime:getServerTime()

    if self.m_nCardActivityEndTime and nCurTime >= self.m_nCardActivityEndTime then 
        self.m_root:disableSchedule()
        WZLog("WndWeekCard:_caculateTime")
        WndFreeca:refreshActivityContext(g_tGameActivityTypes.ACTIVITY_WEEKCARD)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndWeekCard:_adaptLanguage_es()
    local txtBuy = GetElement(self.m_root,"txtBuy_WndWeekCard",WZUILabelTTF)
    txtBuy:setFontSize(18)
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_WndWeekCard",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
end

function WndWeekCard:_adaptLanguage_en()
    local txtBuy = GetElement(self.m_root,"txtBuy_WndWeekCard",WZUILabelTTF)
    txtBuy:setFontSize(18)
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_WndWeekCard",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.553068,0.5))
end

function WndWeekCard:_adaptLanguage_pt()
    local txtBuy = GetElement(self.m_root,"txtBuy_WndWeekCard",WZUILabelTTF)
    txtBuy:setFontSize(18)
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_WndWeekCard",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.709562,0.5))
end
-------------------------------------私有方法模块End----------------------------------------
