-- 许愿池
-- @brief:许愿池 UI 界面模块
-- @date: 2017-03-13 15:32:26
-- @author: zhenwei_jian
-- @note:许愿池


-------------------------------------公有方法模块Begin--------------------------------------

--@brief 显示该界面
function WndPromiseShrine:showWnd()
	local wnd = self:createElement()
	WindowManager:addWindow( wnd , WndPromiseShrine)
	AdaptLanguage(self)
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPromiseShrine:onEnter(element)
	self.m_root = element

	self.m_labelOpenDate 	= GetElement(self.m_root, "labelOpenDate", WZUILabelTTF)
	self.m_conGiftItem 		= GetElement(self.m_root, "conGiftItem", WZUIContainer)
	self.m_labelGiftName 	= GetElement(self.m_root, "labelGiftName", WZUIFreeTextBox)
	self.m_labelDesc 		= GetElement(self.m_root, "labelDesc", WZUIFreeTextBox)
	self.m_labelCountdown 	= GetElement(self.m_root, "labelCountdown", WZUILabelTTF)

	self.m_conStep1			= GetElement(self.m_root, "conStep1", WZUIContainer)
	self.m_conStep2			= GetElement(self.m_root, "conStep2", WZUIContainer)
	self.m_conStep1Content 	= GetElement(self.m_root, "conStep1Content", WZUIContainer)

	self.m_conGift			= GetElement(self.m_root, "conGift", WZUIContainer)
	self.m_labelCountdownTitle = GetElement(self.m_root, "labelCountdownTitle", WZUILabelTTF)
	self.m_spriteFinish 	= GetElement(self.m_root, "spriteFinish", WZUIImage)
	self.m_labelSale 		= GetElement(self.m_root, "labelSale", WZUIFreeTextBox)
	self.m_labelBuyBtn 		= GetElement(self.m_root, "labelBuyBtn", WZUILabelTTF)
	self.m_btnBegin 		= GetElement(self.m_root, "btnBegin", WZUIButton)
	self.m_btnBuy			= GetElement(self.m_root, "btnBuy", WZUIButton)

	self.m_conPrice1 		= GetElement(self.m_root, "conPrice1", WZUIContainer)
	self.m_conPrice2 		= GetElement(self.m_root, "conPrice2", WZUIContainer)
	self.m_conPrice3 		= GetElement(self.m_root, "conPrice3", WZUIContainer)
	self.m_conPrice4 		= GetElement(self.m_root, "conPrice4", WZUIContainer)

	self.m_label_price1		= GetElement(self.m_root, "label_price1", WZUILabelTTF)
	self.m_label_price2		= GetElement(self.m_root, "label_price2", WZUILabelTTF)
	self.m_label_price3		= GetElement(self.m_root, "label_price3", WZUILabelTTF)
	self.m_label_price4		= GetElement(self.m_root, "label_price4", WZUILabelTTF)

	self.m_label_plush3 	= GetElement(self.m_root, "label_plush3", WZUILabelTTF)

	self.m_spineEffect01 	= GetElement(self.m_root, "spineEffect01", WZUISpine)
	self.m_spineEffect02 	= GetElement(self.m_root, "spineEffect02", WZUISpine)
	self.m_img_Tips 		= GetElement(self.m_root, "img_Tips", WZUIImage)
 
	
	self.m_labelOpenDate:setVisible(false) 
	self.m_labelCountdown:setVisible(false)

	self:_initControls()
end

--@brief    onenter函数已执行
function WndPromiseShrine:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "_requestData", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPromiseShrine:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	关闭按钮
function WndPromiseShrine:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if nil ~= self.m_root then 
		WindowManager:removeWindow(self.m_root, WndPromiseShrine, true)
	end 
end

--@brief 开始许愿
function WndPromiseShrine:onBegin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_KILL_TOUZHI)
	if self.m_showingEffect then
		return
	end

	if not self:_allowWith() then--已经没有许愿次数
		return
	end
	-- do 
	-- 	self:testFunc(1, 1496937600, 1497456000, 0, 15, 1, 46465)
	-- 	return 
	-- end
	self:_showEffect()
end

--@brief 购买
function WndPromiseShrine:onBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if nil == self.m_tData then
		return
	end
	if self:_isFinishTask() then--已经完成目标
		return
	end
	local tConfig = self:_getCurrentActivityConfig()
	if 0 > tonumber(tConfig.item_id) then 
		WndVip:showWndUI(0)
		WindowManager:removeWindow(self.m_root, WndPromiseShrine, true)
		return
	end

	local tRechargeConfig = self:_getRechargeConfig()

	popFastRechargeUI(tRechargeConfig.item_id, tRechargeConfig.price)
	WndVip:createLoadingUI()
end

function WndPromiseShrine:onRuleClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PROMISE_SHRINE_TEXT8)
end

-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndPromiseShrine:createLoadingUI()
    if not self.loadingId then 
    	self.loadingId = MsgBoxManager:showLoadingBox(20, self, self.closeLoadingUI) 
    	WZLog("self.loadingId:::", self.loadingId)
    end
end

function WndPromiseShrine:closeLoadingUI()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
    WndVip:closeLoadingUI()
end


--@brief 初始化控件
function WndPromiseShrine:_initControls()
	self:closeLoadingUI()
	self.m_labelOpenDate 		:setVisible(true)
	self.m_conGiftItem 			:setVisible(true)
	self.m_labelGiftName 		:setVisible(true)
	self.m_labelDesc 			:setVisible(true) 
	self.m_labelCountdown 		:setVisible(true)
	self.m_conStep1Content		:setVisible(true)
	self.m_conGift				:setVisible(true)
	self.m_labelCountdownTitle 	:setVisible(true)
	self.m_spriteFinish 		:setVisible(true)
	self.m_btnBegin 			:setVisible(true)

	self.m_conPrice1			:setVisible(true)
	self.m_conPrice2			:setVisible(true)
	self.m_conPrice3			:setVisible(true)
	self.m_conPrice4			:setVisible(true)

	self.m_label_plush3 		:setVisible(true)
	self.m_conStep2 			:setVisible(false)
	self.m_spineEffect01 		:setVisible(false)
	self.m_spineEffect02 		:setVisible(false)
 	self.m_conStep1Content 		:setVisible(false)
 	self.m_img_Tips 			:setVisible(false)

	self.m_btnBuy 				:setTouchEnable(true)
	self.m_btnBegin 			:setButtonStatus(0) 

	self.m_cellGiftItem = nil
	self.m_conGiftItem:removeAllChildrenWithCleanup(true)
end

--播放许愿特效
function WndPromiseShrine:_showEffect()
 	self.m_showingEffect = true--防止动画重播标志位

    self.m_spineEffect01:setVisible(true)
    self.m_spineEffect01:play("stand",false)

    self.m_spineEffect01:enableSchedule("_sendPromiseMsg", 2.00)
end

function WndPromiseShrine:_showTest()
	self.m_spineEffect02:setVisible(false)
	self.m_cellGiftItem:setVisible(false)
	self.m_spineEffect01:setVisible(true)
    self.m_spineEffect01:play("stand",false)
    self.m_conStep2:setVisible(false)
	self.m_conStep1Content:setVisible(true)


    self.m_spineEffect01:enableSchedule("_test", 2.00)
end

function WndPromiseShrine:_test()
	self.m_spineEffect01:disableSchedule()
	self:_showGiftEffect()
end

--许愿后获得物品特效
function WndPromiseShrine:_showGiftEffect() 
 	WZLog("WndPromiseShrine:_showGiftEffect", type(self.m_cellGiftItem))
	if nil ~= self.m_cellGiftItem then 
		self.m_conStep1Content:setVisible(true)
		self.m_conStep2:setVisible(false)

		self.m_cellGiftItem:setVisible(true)
		self.m_spineEffect02:setVisible(false)
		local currentPos = CCPoint(self.m_cellGiftItem:getPosition())
		self.m_cellGiftItem:setPositionY(-100)

		local move = CCMoveTo:create(0.3, currentPos)
		local call1 = CCCallFunc:create(function() 
				self.m_spineEffect02:setVisible(true)
 				self.m_spineEffect02:play("stand", true) 
			end)

		local call2 = CCCallFunc:create(function() 
				self.m_showingEffect = false
				self:_showGiftNormalEffect()
			end)

		local array = CCArray:create()
		array:addObject(move)
		array:addObject(call1)
		array:addObject(CCDelayTime:create(1.0))
		array:addObject(call2)
		self.m_cellGiftItem:runAction(CCSequence:create(array)) 
	end
end

--许愿后物品特效
function WndPromiseShrine:_showGiftNormalEffect() 
	WZLog("WndPromiseShrine:_showGiftNormalEffect")
	self.m_conStep1Content:setVisible(false)
	self.m_conStep2:setVisible(true)
end

--发送许愿消息
function WndPromiseShrine:_sendPromiseMsg()
	self.m_spineEffect01:disableSchedule()

	--一个标志位
	ProtocolProcessorPromiseShrine:send_ACTIVITY_MakeWish()
	WndPromiseShrine:createLoadingUI()
end

--@brief 向服务端请求数据
function WndPromiseShrine:_requestData()
	self:_sendFlushData()
end

--@brief	更新界面
function WndPromiseShrine:_update()
	self:_initControls()

	if not self:_isOpen() then--活动没有开启
		WindowManager:removeWindow(self.m_root, WndPromiseShrine, true)--关闭界面
		return
	end

	local bIsWish = self:_allowWith()
	WZLog("WndPromiseShrine:_update", bIsWish)
	if bIsWish then--许愿状态
		self:_showAllowWithState()
	else 
		self:_showGiftState()
	end 

	--显示活动时间
	local sActivityTime = self:_getFormatActivityDate()
	self.m_labelOpenDate:setText(sActivityTime)
end

--@brief 显示许愿后的奖励状态
function WndPromiseShrine:_showGiftState()
	WZLog("WndPromiseShrine:_showGiftState")
	self:_enableCountdown()--开启倒计时
	self.m_conGift:setVisible(true) 

	self.m_btnBegin:setVisible(false)

  	local tConfig = self:_getCurrentActivityConfig()
	
	if self:_isFinishTask() then--已经完成购买任务
		self:_showCountdownNextAction()
		self.m_spriteFinish:setVisible(true)--显示已购买图片
		self.m_btnBuy:setTouchEnable(false)
	else
		self:_showCountdownTask()
		self.m_spriteFinish:setVisible(false)--隐藏已购买图片
	end
	--提示语句
	-- 若许愿的结束时间距离今日大于一天则提示“今日许愿次数已用完”
	-- 若许愿的结束时间等于今日，则提示“许愿活动已结束”
	local nCurrentTimestamp = SystemTime:getServerTime()
	local tCurrentDate 	= SystemTime:getTimeTabelByServerTimestamp(nCurrentTimestamp)
	local tEndDate 		= SystemTime:getTimeTabelByServerTimestamp(self.m_tData.endTimestamp) 

	--礼包ID
	local giftItemId,cellGiftItem,tGiftConfig
	if type(tConfig.reward) == "table" then
		giftItemId = tConfig.reward[1][1]
		cellGiftItem = CellPromiseShrineGiftItem:createElement(giftItemId, 1 == tonumber(tConfig.good))
		self.m_cellGiftItem = cellGiftItem
		self.m_conGiftItem:addChild(cellGiftItem)

		tGiftConfig = self:_getItemDataById(giftItemId)--获取礼包配置
		self.m_labelGiftName:setShowText(self:_formatFreeText(tGiftConfig.name))--设置奖励物品的名字
		self.m_labelDesc:setShowText(self:_formatFreeText(tGiftConfig.desc))--设置奖励物品的说明
	else
		giftItemId = tConfig.reward
		self.m_labelDesc:setShowText(string.format(LocalStrings.Promise1,giftItemId))--设置奖励物品的说明
	end



 	--0 > tConfig.item_id 表示任意充值金额
	if 0 > tonumber(tConfig.item_id) then 
		--设置超值改为提示文字
		self.m_labelBuyBtn:setText(LocalStrings.PROMISE_SHRINE_TEXT6)

		self.m_conPrice1:setVisible(false)
		self.m_conPrice2:setVisible(false)
		self.m_conPrice3:setVisible(false)
		self.m_conPrice4:setVisible(false)
 		self.m_img_Tips:setVisible(true)
	else 
		local tRechargeConfig = self:_getRechargeConfig()
		self.m_labelBuyBtn:setText(tRechargeConfig.unit) --

		local isShowDouble = false
		local vipList = CacheCenter:getVipList()
		for i, vipInfo in ipairs(vipList) do
			if vipInfo.ids == tRechargeConfig.id then
				if 2 == vipInfo.flag or 3 == vipInfo.flag then
					isShowDouble = true
				end
				break
			end
		end

		--显示奖励物品
		WZLog("skdfjl",type(tConfig.reward),giftItemId )
		if type(tConfig.reward) ~= "table" then 
			return 
		end
		
		local tItemList = self:_getGiftItemListById(giftItemId)
		WZLog(Serialize(tItemList))
		local firstItem = tItemList[1] 
		local total = tonumber(tRechargeConfig.count) + tonumber(firstItem.num)
		if isShowDouble then
			total = total + tonumber(tRechargeConfig.first_gift_count)
		end

		self.m_label_price1:setText(tRechargeConfig.count)

		--有首充双倍奖励
		if isShowDouble then
			self.m_conPrice2:setVisible(true)
			self.m_label_price2:setText(tRechargeConfig.first_gift_count)

			self.m_conPrice3:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
			self.m_conPrice4:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
		else
			--没有奖励
			self.m_conPrice2:setVisible(false)

			self.m_conPrice3:setRelativePosition(GlobalMethod:ccp(0.32, 0.5))
			self.m_conPrice4:setRelativePosition(GlobalMethod:ccp(0.32, 0.5))

		end

		self.m_label_price3:setText(firstItem.num)
		self.m_label_price4:setText(total)
	end
 
	--如果是许愿完后刷新界面则播放获得礼包特效
	if self.m_cellGiftItem then
		self:_showGiftEffect()
	else
		self:_showGiftNormalEffect()
	end
end

--@brief 显示允许许愿状态
function WndPromiseShrine:_showAllowWithState() 
	self.m_conStep1Content:setVisible(true) 
	self.m_conStep2:setVisible(false)
end

--@brief 显示倒计时下次许愿倒计时
function WndPromiseShrine:_showCountdownNextAction()
	-- self.m_labelCountdownTitle:setText(LocalStrings.PROMISE_SHRINE_TEXT2)
	self.m_labelCountdownTitle:setVisible(false)
	self.m_labelCountdown:setVisible(false)
end

--@brief 显示倒计时任务结束
function WndPromiseShrine:_showCountdownTask()
	self.m_labelCountdownTitle:setText(LocalStrings.PROMISE_SHRINE_TEXT3)
	self.m_labelCountdownTitle:setVisible(true)
	self.m_labelCountdown:setVisible(true)
end

--@brief 开启倒计时
function WndPromiseShrine:_enableCountdown()
	self.m_root:disableSchedule()
	self:_countdown()
	self.m_root:enableSchedule("_countdown", self.m_nCountdownInterval)
end

--@biref 如果开启了倒计时, 每1秒调用
function WndPromiseShrine:_countdown()
	local diffSec = self._endTime - SystemTime:getServerTime()
	if 0 >= diffSec then
		self.m_root:disableSchedule()
		self:_sendFlushData()
		return
	end

	local minSec = math.floor(diffSec / 60)

	local hour = math.floor(minSec / 60)
	local min = minSec % 60
	local sec = diffSec % 60
	local strTime = string.format("%02d:%02d:%02d", hour, min, sec)
	self.m_labelCountdown:setText(strTime)
end


--@brief    点击奖励物品回调
function WndPromiseShrine:onOthersClick(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndPromiseShrine.m_root, 1, tData, false, nil, true)
end


-------------------------------------私有方法模块End--------------------------------------

--------------------------------------语言适配Begin---------------------------------------
function WndPromiseShrine:_adaptLanguage_vn(  )
	GetElement(self.m_root,"labelBuyButton",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtOpenDate_WndPromiseShrine", labelOpenDate):setRelativePosition(GlobalMethod:ccp(0.2,0.5))
	GetElement(self.m_root, "labelOpenDate", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.21,0.5))

	GetElement(self.m_root, "txtPrice1_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice2_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice3_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice4_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	local labelGiftName = GetElement(self.m_root,"labelGiftName",WZUIFreeTextBox)
	labelGiftName:setScale(0.8)
	labelGiftName:setMaxWidth(350)
	local labelDesc = GetElement(self.m_root, "labelDesc", WZUIFreeTextBox)
	labelDesc:setScale(0.8)
	labelDesc:setMaxWidth(800)
end

function WndPromiseShrine:_adaptLanguage_en(  )
	GetElement(self.m_root, "txtOpenDate_WndPromiseShrine", labelOpenDate):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
	GetElement(self.m_root, "labelOpenDate", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.225,0.5))

	GetElement(self.m_root, "txtPrice1_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	local txtPrice2 = GetElement(self.m_root, "txtPrice2_WndPromiseShrine", WZUILabelTTF)
	txtPrice2:setScale(0.65)
	txtPrice2:setDimensions(GlobalMethod:CCSize(140))
	GetElement(self.m_root, "txtPrice3_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice4_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	local labelGiftName = GetElement(self.m_root,"labelGiftName",WZUIFreeTextBox)
	labelGiftName:setScale(0.7)
	labelGiftName:setMaxWidth(800)
	local labelDesc = GetElement(self.m_root, "labelDesc", WZUIFreeTextBox)
	labelDesc:setScale(0.7)
	labelDesc:setMaxWidth(800)
end

function WndPromiseShrine:_adaptLanguage_pt(  )
	GetElement(self.m_root, "txtOpenDate_WndPromiseShrine", labelOpenDate):setRelativePosition(GlobalMethod:ccp(0.24141,0.5))
	GetElement(self.m_root, "labelOpenDate", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.238355,0.5))

	GetElement(self.m_root, "txtPrice1_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice2_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice3_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice4_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	local labelGiftName = GetElement(self.m_root,"labelGiftName",WZUIFreeTextBox)
	labelGiftName:setScale(0.7)
	labelGiftName:setMaxWidth(800)
	labelGiftName:setRelativePosition(GlobalMethod:ccp(0.19,0.881582))
	local labelDesc = GetElement(self.m_root, "labelDesc", WZUIFreeTextBox)
	labelDesc:setScale(0.7)
	labelDesc:setMaxWidth(800)
	labelDesc:setRelativePosition(GlobalMethod:ccp(0.19,0.748))

	GetElement(self.m_root, "labelBuyBtn", WZUILabelTTF):setScale(0.8)
end

function WndPromiseShrine:_adaptLanguage_es(  )
	GetElement(self.m_root, "txtOpenDate_WndPromiseShrine", labelOpenDate):setRelativePosition(GlobalMethod:ccp(0.274047,0.5))
	GetElement(self.m_root, "labelOpenDate", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27752,0.5))

	GetElement(self.m_root, "txtPrice1_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice2_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice3_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtPrice4_WndPromiseShrine", WZUILabelTTF):setScale(0.65)
	local labelGiftName = GetElement(self.m_root,"labelGiftName",WZUIFreeTextBox)
	labelGiftName:setScale(0.7)
	labelGiftName:setMaxWidth(800)
	local labelDesc = GetElement(self.m_root, "labelDesc", WZUIFreeTextBox)
	labelDesc:setScale(0.7)
	labelDesc:setMaxWidth(800)
	
	GetElement(self.m_root, "labelBuyBtn", WZUILabelTTF):setScale(0.8)
end
---------------------------------------语言适配End----------------------------------------