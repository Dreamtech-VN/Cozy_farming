--WndSeckill.lua
--@brief	WndSeckill的UI模块
--@date		2017/12/11
--@author	zsq
--@note		秒杀


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSeckill:onEnter(element)
	self.m_root = element
end

--@brief    界面加载完成回调
function WndSeckill:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"conText",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conMain",WZUIContainer):setVisible(false)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSeckill:onExit(element)
	self:_unInit()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OutActivitiesShop( )
end

function WndSeckill:setData(id, item, price, normalPrice, killPrice, startTime, endTime, killStartTime, killEndTime, limitNum, buyNum, timeStr, maxNum)
	WZLog("WndSeckill:setData", id, item, price, normalPrice, killPrice, startTime, endTime, killStartTime, killEndTime, limitNum, buyNum, timeStr, maxNum)
	self.id = id
	self.item = item
	self.price = price
	self.normalPrice = normalPrice
	self.killPrice = killPrice
	self.startTime = startTime
	self.endTime = endTime
	self.killStartTime = killStartTime
	self.killEndTime = killEndTime
	self.limitNum = limitNum
	self.buyNum = buyNum
	self.timeStr = timeStr
	self.maxNum = maxNum

	self:update()
end

--购买后返回
function WndSeckill:updateNum1(limitNum, buyNum)
	WZLog("WndSeckill:updateNum1", limitNum, buyNum)
	local ids,nums = SplitItemString(self.item)
	WndRewardShow:showById(ids, nums)

	self.limitNum = limitNum
	self.buyNum = buyNum

	self:update()
end

function WndSeckill:updateNum2(id, limitNum)
	self.id = id
	self.limitNum = limitNum

	self:update()
end

function WndSeckill:countDown()
	if self.killStartTime > -1 then
		self.killStartTime = self.killStartTime - 1
		--最后35秒，每10秒更新时间，防止误差
		if (self.killStartTime <= 200 and self.killStartTime%15 == 0) or self.killStartTime%1800 == 0 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
		end
		if self.killStartTime == -1 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
		end
	end
	if self.killEndTime > -1 then
		self.killEndTime = self.killEndTime - 1
		--最后35秒，每10秒更新时间，防止误差
		if (self.killEndTime <= 200 and self.killEndTime%15 == 0) or self.killEndTime%1800 == 0 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
		end
		if self.killEndTime == -1 then
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivitiesShopInfo( )
		end
	end

	if self.killStartTime < -1 then self.killStartTime = -1 end
	if self.killEndTime < -1 then self.killEndTime = -1 end

	self:countDown_1()
end

function WndSeckill:countDown_1()
	--秒杀前，显示距开始：
	if self.killStartTime >= 0 then
		WZLog("WndSeckill:countDown1")
		GetElement(self.m_root,"txt1",WZUILabelTTF):setText(LocalStrings.SECKILL5..utilsFormatTime(self.killStartTime))
		GetElement(self.m_root,"txt1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgTitleBg",WZUIImage):setVisible(true)
	--秒杀中，显示距结束：
	elseif self.killStartTime == -1 and self.killEndTime ~= -1 then
		WZLog("WndSeckill:countDown3")
		GetElement(self.m_root,"txt1",WZUILabelTTF):setText(LocalStrings.SECKILL6..utilsFormatTime(self.killEndTime))
		GetElement(self.m_root,"txt1",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgTitleBg",WZUIImage):setVisible(true)
	--已结束
	elseif self.killEndTime == -1 then
		WZLog("WndSeckill:countDown5")
		GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgTitleBg",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txt1",WZUILabelTTF):setVisible(false)
	else
		WZLog("WndSeckill:countDown4")
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndSeckill:update()
	if self.m_root == nil then return end
	self:countDown_1()
	self.m_root:enableSchedule("countDown", 0.96)

	GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(true)
	GetElement(self.m_root,"imgTitleBg",WZUIImage):setVisible(true)

	local ids,nums = SplitItemString(self.item)
	local itemId = ids[1]
	--itemId = 4129
	local leftNum = self.limitNum
	local originPrice = self.price
	local price = self.normalPrice

	local conBtn = GetElement(self.m_root,"conBtn_WndSeckill",WZUIContainer)
	local imgSoldOut = GetElement(self.m_root,"imgSoldOut_WndSeckill",WZUIImage)
	local conItemInfo = GetElement(self.m_root,"conItemInfo_WndSeckill",WZUIContainer)
	conItemInfo:removeAllChildrenWithCleanup(true)

	local  itemInfo =	GDatatab_item["id_"..itemId]
	imgSoldOut:setVisible(false)
	conBtn:setVisible(true)

	local inSeckill = false

	--活动时间
	local date = string.sub(self.startTime,6,7).."."..string.sub(self.startTime,9,10).."-"..string.sub(self.endTime,6,7).."."..string.sub(self.endTime,9,10)
	GetElement(self.m_root,"time1",WZUILabelTTF):setText(date)

	--商品名字
	GetElement(self.m_root,"txtName_WndSeckill",WZUILabelTTF):setText(itemInfo.name)
	GetElement(self.m_root,"txtName_WndSeckill",WZUILabelTTF):setColor(QUALITYCOLOR[itemInfo.quality])
	GetElement(self.m_root,"txtNum_WndSeckill",WZUILabelTTF):setText(nums[1])
	--显示原价
	local priceId1, price1 = SplitItemString(self.price)
	GetElement(self.m_root,"imgPrice1",WZUIImage):setFile(GDatatab_item["id_"..priceId1[1]].icon)
	GetElement(self.m_root,"price1",WZUILabelTTF):setText(price1[1])
	--显示现价
	local priceId2, price2 = SplitItemString(self.normalPrice)
	if self.killStartTime == -1 and self.killEndTime ~= -1 then
		inSeckill = true
		--秒杀中
		priceId2, price2 = SplitItemString(self.killPrice)
		GetElement(self.m_root,"imgKill",WZUIImage):setVisible(true)
		--GetElement(self.m_root,"leftNum",WZUILabelTTF):setText(string.format(LocalStrings.SHOP_LIMIT, leftNum))
		GetElement(self.m_root,"leftNum",WZUILabelTTF):setText(string.format(LocalStrings.SECKILL8, leftNum))
		GetElement(self.m_root,"imgTitle",WZUIImage):setFile("ui/gameActivity/christmas/merrychristmas_icon_kaiqi.png")
	else
		inSeckill = false
		--普通折扣
		priceId2, price2 = SplitItemString(self.normalPrice)
		GetElement(self.m_root,"imgKill",WZUIImage):setVisible(false)
		GetElement(self.m_root,"leftNum",WZUILabelTTF):setText("")
		GetElement(self.m_root,"imgTitle",WZUIImage):setFile("ui/gameActivity/christmas/merrychristmas_icon_daojishi.png")
	end
	self.inSeckill = inSeckill

	GetElement(self.m_root,"imgPrice2",WZUIImage):setFile(GDatatab_item["id_"..priceId2[1]].icon)
	GetElement(self.m_root,"price2",WZUILabelTTF):setText(price2[1])
	--折扣
	local discount = math.floor((price2[1]/price1[1])*100)/10
	GetElement(self.m_root,"discount",WZUILabelTTF):setText(discount..LocalStrings.NEWSHOP12)

	--抢购时间
	local priceId20, price20 = SplitItemString(self.killPrice)
	local discount1 = math.floor((price20[1]/price1[1])*100)/10
	GetElement(self.m_root,"time2",WZUILabelTTF):setText("("..string.format(LocalStrings.SECKILL1, tostring(discount1))..":"..self.timeStr..")")

	if leftNum == 0 then
		imgSoldOut:setFile("ui/common/common_icon_shouxing.png")
	elseif self.buyNum == 0 then
		imgSoldOut:setFile("ui/common/commom_icon_ygm.png")
	end

	if inSeckill and (leftNum <= 0 or self.buyNum <= 0) then
		imgSoldOut:setVisible(true)
		GetElement(self.m_root,"btnBuy",WZUIButton):setTouchEnable(false)

		GetElement(self.m_root,"imgPrice2",WZUIImage):setGrayRender(true)
		GetElement(self.m_root,"price2",WZUILabelTTF):setGrayRender(true)
	else
		imgSoldOut:setVisible(false)
		GetElement(self.m_root,"btnBuy",WZUIButton):setTouchEnable(true)

		GetElement(self.m_root,"imgPrice2",WZUIImage):setGrayRender(false)
		GetElement(self.m_root,"price2",WZUILabelTTF):setGrayRender(false)
	end
	local eItem, tItem = CellGoodItem:createElement()
	eItem:setScale(1.1)
	tItem:setItemClickFun(self, self.onItem)

	local tData = {
	    id = itemId,
	    isUse = false,
	    data = "",
	    playerItemId = -1,
	    lastNum = tonumber(nums[1]),
		lastTime = tonumber(nums[1])*86400,
	    basicInfo = itemInfo
	}
	tItem:setCellGoodItem(tData, 5)
	conItemInfo:addChild(eItem)
    if tItem.m_imgItem ~= nil then
        tItem.m_imgItem:setScale(0.85)
    end
	if itemInfo.main_type == 5 then
		GetElement(self.m_root,"txtNum_WndSeckill",WZUILabelTTF):setText("")
		tItem:_addSidebarTime(nil, ccp(-0.32,1.24))
		GetElement(self.m_root,"imgKill",WZUIImage):setVisible(false)
	end

	GetElement(self.m_root,"conText",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conMain",WZUIContainer):setVisible(true)

	--活动描述
	GetElement(self.m_root,"txtDesc",WZUILabelTTF):setText(string.format(LocalStrings.SECKILL3, tData.basicInfo.name, tostring(self.maxNum)))
end

function WndSeckill:onItem(tItem, nTag, tData)
	-- body
	WZLog("WndSeckill:onItem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndItemInfo:showInfo(tItem.m_root,WndApartmentAct.m_root,1,tData,false)
end

function WndSeckill:onClickBuy(element)
	WZLog("WndSeckill:onClickBuy")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.inSeckill == true and (self.buyNum <= 0 or self.limitNum <= 0) then
		MsgBoxManager:showTipBox(LocalStrings.SECKILL7)
		return
	end

	if self.killStartTime == -1 and self.killEndTime ~= -1 then
		--秒杀中
		local ids,nums = SplitItemString(self.killPrice)
		if not JudgeMoneyIsEnough(tonumber(ids[1]), tonumber(nums[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClickBuyCall) then 
			return 
		end
		self:onClickBuyCall()
	else
		--普通折扣
		local ids,nums = SplitItemString(self.normalPrice)
		if not JudgeMoneyIsEnough(tonumber(ids[1]), tonumber(nums[1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClickBuyCall) then 
			return 
		end
		self:onClickBuyCall()
	end
end

function WndSeckill:onClickBuyCall()
	WZLog("WndSeckill:onClickBuyCall")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_BuyActivitiesShop( )
end

-------------------------------------私有方法模块End----------------------------------------
