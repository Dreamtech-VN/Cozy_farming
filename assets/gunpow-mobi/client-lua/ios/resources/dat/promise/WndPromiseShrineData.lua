-- 许愿池
-- @brief: 许愿 数据模块
-- @date: 2017-03-13 15:35:02
-- @author: zhenwei_jian
-- @note:许愿池

local WndPromiseShrine = {
	--请不要在这里定义变量
}

WndPromiseShrine._FONT_NORMAL_STYLE = '<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1">%s</T>'
WndPromiseShrine._FONT_BLUE_STYLE = '<T C="93,222,254" SC="79,60,48" SS="4" S="30" P="1" SE="1">%s</T>'

WndPromiseShrine._FONT_SALE_PRICE_TITLE_STYLE = '<T C="255,236,193" SC="79,60,48" SS="4" S="20" P="1" SE="1">%s</T>'
WndPromiseShrine._FONT_SALE_PRICE_STYLE = '<T C="255,236,193" SC="79,60,48" SS="4" S="20" P="1" SE="1">%s</T><T C="255,236,193" SC="79,60,48" SS="4" S="28" P="1" SE="1">%s</T>'

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPromiseShrine:_init()
	self.m_root 				= nil	--场景根节点 
	self.m_nCountdownInterval	= 1 	--倒计时间隔
	self.m_showingEffect 		= false--防止动画重播标志位
	self:_resetConfigCache()

	--以下数据别的模块也用到, 界面删除时候也不要清空
	self.m_tData = nil

end

function WndPromiseShrine:_resetConfigCache()
	self.m_tConfigCache 		= nil 	--配置表内容
	self.m_tRechargeConfigCache = nil 	--充值配置表内容
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPromiseShrine:_unInit()
	self.m_root = nil 
	self:_resetConfigCache()
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPromiseShrine:createElement()
	local element = WZUISystem:getInstance():createElement("WndPromiseShrine")
	assert(element, "WndPromiseShrine create element failed!")
	self:_init()
	return element
end

function WndPromiseShrine:testFunc(status, startTimestamp, endTimestamp, leftWishTimes, rechargeId, leftPurchaseTimes, countDown)
    -- body
    CacheCenter:setPromiseData(status, startTimestamp, endTimestamp, leftWishTimes, rechargeId, leftPurchaseTimes, countDown)
    WndPromiseShrine:flushData()
end

--@brief 收到服务端消息时候会调用此方法
-- status : 状态 2结束  1 进行
-- startTimestamp : 开始时间戳
-- endTimestamp : 结束时间戳
-- leftWishTimes : 剩余许愿次数
-- configId : 充值id,0为无可充值项目,-1为任意充值
-- leftPurchaseTimes : 剩余的购买次数
-- countDown : 倒计时
function WndPromiseShrine:flushData()

	self:_resetConfigCache() 
	self.m_tData = CacheCenter:getPromiseData() 
	self._endTime = SystemTime:getServerTime() + self.m_tData.countDown

	WZLog("test!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", Serialize(self.m_tData))
	
	if nil ~= self.m_root then
		self:_update()
	end
end

--@brief 是否开启任意金额充值buffer
function WndPromiseShrine:isEnabledRechargeBuffer()
	if nil == self.m_tData then
		return false
	end
	if 0 < self.m_tData.leftPurchaseTimes then
		local tActivityConfig = self:_getCurrentActivityConfig()
		if tActivityConfig and 0 > tonumber(tActivityConfig.item_id) then
			return true
		end
	end
	return false
end

--@brief 检测充值物品的充值ID是否带有许愿buffer
function WndPromiseShrine:checkRechargeIdIsValidBuffer(rechargeId)
	if nil == self.m_tData then
		return false
	end
	local rechargeConfig = GDatatab_recharge[string.format("id_%s", rechargeId)]
	local _item_id = tonumber(rechargeConfig.item_id)
	local _price = tonumber(rechargeConfig.price)
	if 0 < self.m_tData.leftPurchaseTimes then
		local tActivityConfig = self:_getCurrentActivityConfig()
		if tActivityConfig and tonumber(tActivityConfig.item_id) == _item_id and tonumber(tActivityConfig.price) == _price then
		--剩余购买次数大于0
			return true
		end
	end
	return false
end

--@brief 许愿成功后回调
function WndPromiseShrine:onRecvWishOk()
	self:_sendFlushData()--直接刷新数据
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 获取格式化的活动时间
function WndPromiseShrine:_getFormatActivityDate()
	if nil == self.m_tData then
		return ""
	end
	
	local nStartTimestamp = SystemTime:convertToLocalTimestamp(self.m_tData.startTimestamp)
	local nEndTimestamp   = SystemTime:convertToLocalTimestamp(self.m_tData.endTimestamp)

	local tStartDate = os.date("*t", nStartTimestamp)
	local tEndDate = os.date("*t", nEndTimestamp)
	local ret = string.format(LocalStrings.ACTIVITY_TIMELINE_KEY, tStartDate.month, tStartDate.day, tEndDate.month, tEndDate.day)
	return ret
end

--@brief 活动是否开启
function WndPromiseShrine:_isOpen()
	if nil == self.m_tData then
		return false
	end
	return self.m_tData.status == 1
end

--发送协议刷新数据
function WndPromiseShrine:_sendFlushData()
	ProtocolProcessorPromiseShrine:send_ACTIVITY_GetWishingWell()
end

--@brief 是否许愿状态
function WndPromiseShrine:_allowWith()
	if nil == self.m_tData then
		return false
	end
	if 0 < self.m_tData.leftWishTimes then--剩余的许愿次数大于1
		return true
	end
	return false
end

--获取礼包物品ID
function WndPromiseShrine:_getCurrentActivityConfig()

	if nil == self.m_tConfigCache then
		local key = string.format("id_%s", self.m_tData.configId)
		WZLog("self.m_tData.configId::::::::::::::", self.m_tData.configId)
		self.m_tConfigCache = GDatatab_wishing_well_config[key]
	end

	return self.m_tConfigCache
end

local __findFunc = function(price, item_id, channelId)
	for k, _rechargeConfig in pairs(GDatatab_recharge) do
		local _price 		= tonumber(_rechargeConfig["price"])
		local _item_id 		= tonumber(_rechargeConfig["item_id"])
		local _channel_id 	= tonumber(_rechargeConfig["channel_id"])
		
		if price == _price and item_id == _item_id and channelId == _channel_id then
			return _rechargeConfig 
		end
	end
end

function WndPromiseShrine:_getRechargeConfig()
	if nil == self.m_tRechargeConfigCache then
		local tConfig = self:_getCurrentActivityConfig()
		local price = tonumber(tConfig.price)
		local item_id = tonumber(tConfig.item_id)
		local channelId = tonumber(ProjConfig:getChannelId())  

		
		self.m_tRechargeConfigCache = __findFunc(price, item_id, channelId)
		if nil == self.m_tRechargeConfigCache then
			self.m_tRechargeConfigCache = __findFunc(price, item_id, 0)
		end
		
		--self.m_tRechargeConfigCache = GDatatab_recharge[string.format("id_%s", tConfig.recharge_id)]
	end

	return self.m_tRechargeConfigCache
end

--@brief 获取优惠百分比
function WndPromiseShrine:_getSalePricePrecent()
	--tData.configId 
	local tRechargeConfig = self:_getRechargeConfig()
	-- tConfig.original_price 原价
	local tConfig = self:_getCurrentActivityConfig()
	local precent = math.floor(tonumber(tConfig.original_price) / tonumber(tRechargeConfig.price) * 100)
	return precent
end

--@brief 是否已经完成购买任务
function WndPromiseShrine:_isFinishTask()
	if 0 >= self.m_tData.leftPurchaseTimes then
		return true
	end
	return false
end

--@brief 根据奖励ID 获取物品内容列表
function WndPromiseShrine:_getGiftItemListById(giftItemID)
	local ret = {}

	local playerInfo = CacheCenter:getPlayerInfo()
	local sItemDataKey = "man_item_id"
	if 1 == tonumber(playerInfo.sex) then--女玩家
		sItemDataKey = "woman_item_id"
	end
	local _tempItemIdMap = {}
	for _, tData in pairs(GDatatab_gifts) do
		if tData.item_id == giftItemID then 
			local tItmeData = GDatatab_item[string.format("id_%s", tData[sItemDataKey])]
			tItmeData = QuickCopyTable(tItmeData) 
			local _target = _tempItemIdMap[tItmeData.id]
			if nil ~= _target then
				_target.num = _target.num + tData.count
			else
				_target = tItmeData
				_target.num = tData.count
				table.insert(ret, _target)
				_tempItemIdMap[_target.id] = _target
			end
		end
	end
	return ret
end

function WndPromiseShrine:_getItemDataById(id)
	local tData = GDatatab_item[string.format("id_%s", id)]
	return tData
end

-- 获取截取字符的偏移量， 如果是unicode返回偏移2-6个char,如果非unicode返回nil
-- local char = string.sub("国", 1, 1)
-- local b = string.byte(char)
function WndPromiseShrine:_charLenUtf8(char)
    local right = 1
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local i   = #arr
    while arr[i] do
        if char >= arr[i] then
            return i
        end
        i = i - 1
    end
end

--@brief 将普通的文本内容转为富文本格式输出: 将内容中的文字用一个样式， 数字用另外一个样式
--作用逐一找到数字用绿色字体显示
function WndPromiseShrine:_formatFreeText(str)
	--本来打算用正则,发现有问题后来发现反而复杂了改用了以下方式。
	if 0 >= #str then
		return ""
	end
	local ret = ""
	local beginChrIdx = 1
	local isNumber = false 
    local i = 1
    local len = #str 
    while true do
        if i > len then
            break
        end
        local preIsNumber = isNumber  
        isNumber = false
        local chr = string.sub(str, i , i)
        local step = self:_charLenUtf8(string.byte(chr))
        if nil == step then
            step = 1
        end
    	if 1 == step and nil ~= tonumber(chr) then
    		isNumber = true
        end

        if not preIsNumber and isNumber then
        	local _tmp = string.sub(str, beginChrIdx, i - 1)
	    	_tmp = string.format(WndPromiseShrine._FONT_NORMAL_STYLE, _tmp)
	    	ret = string.format("%s%s", ret, _tmp)
	    	beginChrIdx = i
	    else

	    	if preIsNumber and not isNumber then
	    		local _tmp = string.sub(str, beginChrIdx, i  - 1)
	    		_tmp = string.format(WndPromiseShrine._FONT_BLUE_STYLE, _tmp)
		    	ret = string.format("%s%s", ret, _tmp)
		    	beginChrIdx = i
	    	end

        end

        i = i + step
    end

    if beginChrIdx <= len then
    	isNumber = false
    	local chr = string.sub(str, beginChrIdx , beginChrIdx)
    	local step = self:_charLenUtf8(string.byte(chr))
        if nil == step then
            step = 1
        end
    	if 1 == step and nil ~= tonumber(chr) then
    		isNumber = true
        end

    	local _tmp = string.sub(str, beginChrIdx, len)
    	if isNumber then
    		_tmp = string.format(WndPromiseShrine._FONT_BLUE_STYLE, _tmp)
    	else
    		_tmp = string.format(WndPromiseShrine._FONT_NORMAL_STYLE, _tmp)
    	end
    	ret = string.format("%s%s", ret, _tmp)
    	beginChrIdx = i
    end

    return ret
end



-------------------------------------私有方法模块End----------------------------------------



--rawset _G 这样设置全局表 好处是:容易定位该全局变量定义的位置
rawset(_G, "WndPromiseShrine", WndPromiseShrine)