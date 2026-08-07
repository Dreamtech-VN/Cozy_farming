--WndShopLotteryLottery.lua
--@brief	WndShopLotteryLottery的UI模块
--@date		2017/09/04
--@author	zsq
--@note		商城抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShopLottery:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndShopLottery:onEnterTransitionDidFinish(element)
	if CacheCenter:getGameParam().isUseTicket == "1" then
		if WndShop.m_nTag7 == 2 then
			WndShop.m_nTag7 = 1
		end
	end
	if WndShop.m_nTag7 == 3 then return end
	ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo(WndShop.m_nTag7)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShopLottery:onExit(element)
	if CacheCenter:getGameParam().isUseTicket == "1" then
		if WndShop.m_nTag7 == 1 then
			WndShop.m_nTag7 = 2
		end
	end
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------抽奖模块Start----------------------------------------
function WndShopLottery:setData7(nType, itemId, itemNum, rare, luckValue, drawNum, drawPrice) 
	if self.m_root == nil then return end
	self.m_tDataList7 = {}
	self.m_nLucky = luckValue
	for i=1,#itemId do
		local temp = {}
		temp.itemId = itemId[i]
		temp.itemNum = itemNum[i]
		temp.rare = rare[i]
		table.insert(self.m_tDataList7, temp)
	end

	local _sort = function(a, b)
		return a.rare
	end

	table.sort(self.m_tDataList7, _sort)

	self.m_tDataList7[1].drawNum = drawNum[1]
	self.m_tDataList7[2].drawNum = drawNum[2]
	self.m_tDataList7[1].drawPrice = drawPrice[1]
	self.m_tDataList7[2].drawPrice = drawPrice[2]

	WZLog("WndShopLottery:setData7", Serialize(self.m_tDataList7))

	self:_update7()
end

function WndShopLottery:_update7() 
	local n = math.min(14, #self.m_tDataList7)
	self.m_tCellList7 = {}
	for i=1,n do
	    local celElement,tLuaObj = CellShopLottery:createElement()
		local con = GetElement(self.m_root,"conLottery"..i,WZUIContainer)
        if celElement ~= nil then 
	     	celElement = WZUIContainer:luaTo(celElement)
            celElement:setTag(i)
			tLuaObj:setData(self.m_tDataList7[i])
			self.m_tCellList7[i] = tLuaObj

			con:removeAllChildrenWithCleanup(true)	
			con:addChild(celElement)
        end
	end

	local p1 = GetElement(self.m_root,"conLottery1",WZUIContainer):getRelativePosition()
	GetElement(self.m_root,"conSel_WndShopLottery",WZUIContainer):setRelativePosition(p1)

	--幸运值
	local maxLuckValue = CacheCenter:getGameParam().maxLuckValue
	if maxLuckValue == nil then maxLuckValue = 0 end
	local percent = math.ceil(self.m_nLucky/maxLuckValue*100)
	GetElement(self.m_root,"txtLucky",WZUILabelTTF):setText(self.m_nLucky)
	GetElement(self.m_root,"progress7",WZUIProgress):setPercentage(percent)
	GetElement(self.m_root,"spineFull",WZUISpine):setVisible(false)
	if tonumber(self.m_nLucky) >= tonumber(maxLuckValue) then
		GetElement(self.m_root,"spineFull",WZUISpine):setVisible(true)
	end

	--货币
	if WndShop.m_nTag7 == 1 then
		GetElement(self.m_root,"imgCost71",WZUIImage):setFile("ui/common/common_icon_zuanshi.png")
		GetElement(self.m_root,"imgCost72",WZUIImage):setFile("ui/common/common_icon_zuanshi.png")
	elseif WndShop.m_nTag7 == 2 then
		GetElement(self.m_root,"imgCost71",WZUIImage):setFile("shopitems/lizuan.png")
		GetElement(self.m_root,"imgCost72",WZUIImage):setFile("shopitems/lizuan.png")
	end
	--文字
	local drawNum = tostring(self.m_tDataList7[1].drawNum)
	local drawPrice = self.m_tDataList7[1].drawPrice
	GetElement(self.m_root,"txtTip71",WZUILabelTTF):setText(string.format(LocalStrings.NEWSHOP18, drawNum, drawNum))
	GetElement(self.m_root,"txtTip73",WZUILabelTTF):setText(drawPrice)
	drawNum = tostring(self.m_tDataList7[2].drawNum)
	drawPrice = self.m_tDataList7[2].drawPrice
	GetElement(self.m_root,"txtTip72",WZUILabelTTF):setText(string.format(LocalStrings.NEWSHOP18, drawNum, drawNum))
	GetElement(self.m_root,"txtTip74",WZUILabelTTF):setText(drawPrice)
end

--夺宝一次
function WndShopLottery:onLottery1() 
	WZLog("WndShopLottery:onLottery1")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local moneyId = {1,70}
	--判断材料是否充足
	if not JudgeMoneyIsEnough(moneyId[WndShop.m_nTag7], self.m_tDataList7[1].drawPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onLottery1Call) then 
		return 
	end

	self:onLottery1Call()
end

function WndShopLottery:onLottery1Call() 
	--屏蔽操作
	GetElement(WndShop.m_root,"conCover",WZUIContainer):setVisible(true)
	g_bIsShowWndDressUp = false
	ProtocolProcessorWndShop:send_MALL_LuckDraw(WndShop.m_nTag7, 1 )
	self.m_bRunning7 = true

	--如果协议没返回，5秒后取消屏蔽
	local conSche = GetElement(self.m_root,"conSche",WZUIContainer)
	conSche:enableSchedule("removeCover",5)
end

--夺宝五次
function WndShopLottery:onLottery5() 
	WZLog("WndShopLottery:onLottery5")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local moneyId = {1,70}
	--判断材料是否充足
	if not JudgeMoneyIsEnough(moneyId[WndShop.m_nTag7], self.m_tDataList7[2].drawPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onLottery5Call) then 
		return 
	end

	self:onLottery5Call()
end

function WndShopLottery:onLottery5Call() 
	--屏蔽操作
	GetElement(WndShop.m_root,"conCover",WZUIContainer):setVisible(true)
	g_bIsShowWndDressUp = false
	ProtocolProcessorWndShop:send_MALL_LuckDraw(WndShop.m_nTag7, 5 )
	self.m_bRunning7 = true

	local conSche = GetElement(self.m_root,"conSche",WZUIContainer)
	conSche:enableSchedule("removeCover",5)
end

function WndShopLottery:removeCover() 
	local conSche = GetElement(self.m_root,"conSche",WZUIContainer)
	conSche:disableSchedule()

	--取消屏蔽
	if self.m_bRunning7 == false then	
		GetElement(WndShop.m_root,"conCover",WZUIContainer):setVisible(false)
	end
end

--收到协议，开始抽奖动画
function WndShopLottery:showLotteryResult(nType, itemId, itemNum, luckValue) 
	local con = self.m_root
	self.m_nEndPosition7 = {}
	for i=1,#itemId do
		for k,v in pairs(self.m_tDataList7) do
			if v.itemId == itemId[i] and v.itemNum == itemNum[i] then
				self.m_nEndPosition7[i] = k
				break
			end
		end
	end

	self.m_nPosition7 = 1
	self.m_nRound7 = 1
	self.m_nTime7 = 1
	self.m_tRewardId = itemId
	self.m_tRewardNum = itemNum
	con:enableSchedule("lotteryCall",0.09)

	--幸运值
	self.m_nLucky = luckValue
	 
	local maxLuckValue = CacheCenter:getGameParam().maxLuckValue
	if maxLuckValue == nil then maxLuckValue = 0 end
	local percent = math.ceil(self.m_nLucky/maxLuckValue*100)
	GetElement(self.m_root,"txtLucky",WZUILabelTTF):setText(self.m_nLucky)
	GetElement(self.m_root,"progress7",WZUIProgress):setPercentage(percent)
	GetElement(self.m_root,"spineFull",WZUISpine):setVisible(false)
	if tonumber(self.m_nLucky) >= tonumber(maxLuckValue) then
		GetElement(self.m_root,"spineFull",WZUISpine):setVisible(true)
	end
end

function WndShopLottery:lotteryCall() 
	self.m_tCellList7[self.m_nPosition7]:setHighLight(false)
	self.m_nPosition7 = self.m_nPosition7 + 1
	if self.m_nPosition7 > 14 then
		self.m_nPosition7 = self.m_nPosition7%14
		self.m_nRound7 = self.m_nRound7 - 1
	end
	--self.m_tCellList7[self.m_nPosition7]:setHighLight(true)

	--移动动画
	local light = GetElement(self.m_root,"conSel_WndShopLottery",WZUIContainer)
	light:setVisible(true)
	local endPosition = GetElement(self.m_root,"conLottery"..self.m_nPosition7,WZUIContainer):getRelativePosition()

    local moveTo = WZUIActionMoveTo:create()
    moveTo:setMoveX(endPosition.x)
    moveTo:setMoveY(endPosition.y)
    moveTo:setDuration(0.06)

    local functionAni = WZUIActionCallLuaFunction:create()
    functionAni:setLuaFunction("_setP")

    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(moveTo)
    actionSqu:setChildAction(functionAni)

	--local array = CCArray:create()
	--array:addObject(moveTo)
	--array:addObject(CCCallFuncN:create(self._setP))
	--local action = CCSequence:create(array)

	light:runUIAction(actionSqu)

	--停止条件
	if self.m_nRound7 <= 0 and self.m_nPosition7 == self.m_nEndPosition7[self.m_nTime7] then
		local con = self.m_root
		con:disableSchedule()
		--完成
		if self.m_nTime7 == #self.m_tRewardId then
			con:enableSchedule("lotteryFinish",0.3)
		else
			self.m_nTime7 = self.m_nTime7 + 1
			self.m_tCellList7[self.m_nPosition7]:setHighLightFinal(true)
			con:enableSchedule("lotteryCall1",0.8)
		end
	end
end

function WndShopLottery:_setP() 
	local light = GetElement(self.m_root,"conSel_WndShopLottery",WZUIContainer)
	local endPosition = GetElement(self.m_root,"conLottery"..self.m_nPosition7,WZUIContainer):getRelativePosition()
	light:setRelativePosition(endPosition)
end

function WndShopLottery:lotteryFinish() 
	local con = self.m_root
	con:disableSchedule()

	--屏蔽操作
	GetElement(WndShop.m_root,"conCover",WZUIContainer):setVisible(false)
	pushEquipInList()

	WndRewardShow:showById(self.m_tRewardId, self.m_tRewardNum)
	WndRewardShow:closeCallBack(self,self.clearHighLight)
	self.m_bRunning7 = false
end

function WndShopLottery:lotteryCall1() 
	local con = self.m_root
	con:enableSchedule("lotteryCall",0.09)
end

function WndShopLottery:clearHighLight() 
	if self.m_root == nil then return end
	local p1 = GetElement(self.m_root,"conLottery1",WZUIContainer):getRelativePosition()
	GetElement(self.m_root,"conSel_WndShopLottery",WZUIContainer):setRelativePosition(p1)
	GetElement(self.m_root,"conSel_WndShopLottery",WZUIContainer):setVisible(false)
	if self.m_tCellList7 == nil then return end
	for i=1,#self.m_tCellList7 do
		self.m_tCellList7[i]:setHighLight(false)
		self.m_tCellList7[i]:setHighLightFinal(false)
	end
end

function WndShopLottery:valInTable(val, table) 
	for k,v in pairs(table) do
		if val == v then
			return true
		end
	end
	return false
end
-------------------------------------抽奖模块End----------------------------------------



-------------------------------------语言适配begin----------------------------------------
function WndShopLottery:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTip71",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtTip72",WZUILabelTTF):setScale(0.5)
end

function WndShopLottery:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTip71",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtTip72",WZUILabelTTF):setScale(0.5)
end

function WndShopLottery:_adaptLanguage_en(  )
	local txtLuckyTip = GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF)
	txtLuckyTip:setScale(0.6)
	txtLuckyTip:setDimensions(GlobalMethod:CCSize(400))
	local txtTip71 = GetElement(self.m_root,"txtTip71",WZUILabelTTF)
	txtTip71:setScale(0.6)
	txtTip71:setDimensions(GlobalMethod:CCSize(340))
	local txtTip72 = GetElement(self.m_root,"txtTip72",WZUILabelTTF)
	txtTip72:setScale(0.6)
	txtTip72:setDimensions(GlobalMethod:CCSize(340))

	local txtLuckyN = GetElement(self.m_root,"txtLuckyN_WndShopLottery",WZUILabelTTF)
	txtLuckyN:setScale(0.8)
	txtLuckyN:setRelativePosition(GlobalMethod:ccp(0.585331,0.68))
	local txtLucky = GetElement(self.m_root,"txtLucky",WZUILabelTTF)
	txtLucky:setScale(0.8)
	txtLucky:setRelativePosition(GlobalMethod:ccp(0.691839,0.68))
end

function WndShopLottery:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF):setScale(0.6)
	local txtTip71 = GetElement(self.m_root,"txtTip71",WZUILabelTTF)
	txtTip71:setScale(0.6)
	txtTip71:setDimensions(GlobalMethod:CCSize(360))
	local txtTip72 = GetElement(self.m_root,"txtTip72",WZUILabelTTF)
	txtTip72:setScale(0.6)
	txtTip72:setDimensions(GlobalMethod:CCSize(360))

	local txtLuckyN = GetElement(self.m_root,"txtLuckyN_WndShopLottery",WZUILabelTTF)
	txtLuckyN:setScale(0.8)
	txtLuckyN:setRelativePosition(GlobalMethod:ccp(0.585331,0.68))
	local txtLucky = GetElement(self.m_root,"txtLucky",WZUILabelTTF)
	txtLucky:setScale(0.8)
	txtLucky:setRelativePosition(GlobalMethod:ccp(0.691839,0.68))
	
end

function WndShopLottery:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF):setScale(0.6)
	local txtTip71 = GetElement(self.m_root,"txtTip71",WZUILabelTTF)
	txtTip71:setScale(0.55)
	txtTip71:setDimensions(GlobalMethod:CCSize(360))
	local txtTip72 = GetElement(self.m_root,"txtTip72",WZUILabelTTF)
	txtTip72:setScale(0.55)
	txtTip72:setDimensions(GlobalMethod:CCSize(360))

	local txtLuckyN = GetElement(self.m_root,"txtLuckyN_WndShopLottery",WZUILabelTTF)
	txtLuckyN:setScale(0.8)
	txtLuckyN:setRelativePosition(GlobalMethod:ccp(0.585331,0.68))
	local txtLucky = GetElement(self.m_root,"txtLucky",WZUILabelTTF)
	txtLucky:setScale(0.8)
	txtLucky:setRelativePosition(GlobalMethod:ccp(0.691839,0.68))
	
end

function WndShopLottery:_adaptLanguage_tr(  )
	local txtLuckyTip = GetElement(self.m_root,"txtLuckyTip_WndShopLottery",WZUILabelTTF)
	txtLuckyTip:setScale(0.6)
	txtLuckyTip:setDimensions(GlobalMethod:CCSize(400))
	GetElement(self.m_root,"txtTip71",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtTip72",WZUILabelTTF):setScale(0.5)
end
-------------------------------------语言适配End----------------------------------------