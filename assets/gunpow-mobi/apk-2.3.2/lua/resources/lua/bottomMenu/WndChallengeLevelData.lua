--WndChallengeLevelData.lua
--@brief	WndChallengeLevel的数据模块
--@date		2014/01/15
--@author	林庆凯
--@note		挑战关卡窗口

WndChallengeLevel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChallengeLevel:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_nSelModel = 2                 --选择货币类型
	self.m_tCoinType = {2, 1}
	self.m_nTotalNum = 0 				 --发红包的金额
	self.m_nRedPackNum = 0 				 --发红包个数
	self.m_nBlessWordIndex = 1 			--默认祝福语索引
	self.m_nLeftTimes = 0    			--
	self.m_tRedPackNumLimit = nil 		--红包数量配置
	self.m_tDiaTotalNumLimit = nil 		--红包数量配置
	self.m_tGoldTotalNumLimit = nil 		--红包数量配置
	self.m_nWinType = 1   				--1:发红包；2：抢红包；3：拜财神-红包雨；4：抢到红包雨红包
	self.m_nStatus = nil 				--0:成功；1:失败；2:抢过了
	self.m_tResultData = nil 			--红包发送者数据/发红包红包雨红包数据配置
	self.m_nUsingSkinId = 0 			--正在使用的红包皮肤Id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChallengeLevel:_unInit()
	self.m_root = nil
	self.m_nSelModel = nil
	self.m_tCoinType = nil 
	self.m_nTotalNum = nil 				 --发红包的金额
	self.m_nRedPackNum = nil 				 --发红包个数
	self.m_nBlessWordIndex = nil 			--默认祝福语索引
	self.m_nLeftTimes = nil 
	self.m_tRedPackNumLimit = nil 		--红包数量配置
	self.m_tDiaTotalNumLimit = nil 		--红包数量配置
	self.m_tGoldTotalNumLimit = nil 		--红包数量配置
	self.m_nWinType = nil 
	self.m_nStatus = nil
	self.m_tResultData = nil 			--红包发送者数据
	self.m_nUsingSkinId = nil 			--正在使用的红包皮肤Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChallengeLevel:createElement()
	local element = WZUISystem:getInstance():createElement("WndChallengeLevel")
	assert(element, "WndChallengeLevel create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndChallengeLevel:showInterface(nType, leftTimes, nStatus, resultData, channelId)
	--检测是否有权限
	WZLog("WndChallengeLevel:showInterface")
	if nType == nil then 

		if channelId == 1 and checkInCommunity() == false then
			MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
			return 
		end

		local nTimes, openVipLevel = WndChallengeLevel:getSendRedPackTimes(channelId)
		if nTimes <= 0 then 
			MsgBoxManager:showConfirmBox(string.format(LocalStrings.MULTI_SWEEP_TIP, openVipLevel), self, self.needHigherVipCallBack)
			return 
		end

		ProtocolProcessorGlobal:send_CHAT_GetRedEnvelopeInfo(channelId)
		return 
	end
	local wndLevel = WndChallengeLevel:createElement()
	if wndLevel then 
		self.m_nWinType = nType or 1
		self.m_nLeftTimes = leftTimes or 0
		self.m_nStatus = nStatus or 0
		self.m_tResultData = resultData
		self.m_nChannelId = channelId or 0
		WindowManager:addWindow(wndLevel, WndChallengeLevel, false, nil, nil, true)
	end
end

--@brief 	切换祝福语
function WndChallengeLevel:exchangeBlessWordOK(nIndex)
	if self.m_root == nil then return end 

	self.m_nBlessWordIndex = nIndex
	local txtBlessWords = GetElement(self.m_root, "txtBlessWords_WndChallengeLevel", WZUILabelTTF)
	txtBlessWords:setText(LocalStrings.RED_PACK1[self.m_nBlessWordIndex])
end

function WndChallengeLevel:needHigherVipCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief 	获取红包数据
function WndChallengeLevel:getRadPackData(opType, nLeftTimes, status, resultData, channelId)
	--发红包
	if opType == 1 then 
		self.m_nLeftTimes = nLeftTimes
		if nLeftTimes <= 0 then 
			MsgBoxManager:showTipBox(LocalStrings.RED_PACK8)
		else
			WndChallengeLevel:showInterface(1, nLeftTimes, 0, nil, channelId)
		end
	else
		if status == 0 then 
			WndChallengeLevel:showInterface(2, nLeftTimes, status, resultData, channelId)
		elseif status == 1 then 
			WndChallengeLevel:showInterface(2, nLeftTimes, status, resultData, channelId)
		elseif status == 2 then 
			MsgBoxManager:showTipBox(LocalStrings.RED_PACK7)
		end
	end
end

--@brief 	获取使用中的皮肤数据
function WndChallengeLevel:getUsingSkinId()
	return self.m_nUsingSkinId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取发送红包的上限
function WndChallengeLevel:getSendRedPackTimes(channelId)
	local nType = 33
	if channelId == 0 then
		nType = 33
	elseif channelId == 1 then
		nType = 36
	end
	local nTimes = 0 
	local openVipLevel = 99 
	local vipLevel = CacheCenter:getPlayerInfo().vipLevel
	for i, value in pairs(GDatatab_vip_restriction) do
		if value.type == nType and vipLevel >= value.vip_level and value.count > nTimes then 
			nTimes = value.count
		end
		if value.type == nType and openVipLevel > value.vip_level and value.count > 0 then 
			openVipLevel = value.vip_level
		end
	end

	return nTimes, openVipLevel
end




-------------------------------------私有方法模块End----------------------------------------
