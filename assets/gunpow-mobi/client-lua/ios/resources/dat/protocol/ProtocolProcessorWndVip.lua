--ProtocolProcessorWndVip.lua
--@brief	VIP相关协议
--@date  	2013/12/25
--@author 	liangguang_long
--@note 	VIP相关协议


ProtocolProcessorWndVip = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndVip:regAll()
	WZLog("注册VIP协议0")
	--@brief	领取每日礼包成功（VIP_ReceiveGiftBagOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_ReceiveGiftBagOk, 
		"ProtocolProcessorWndVip:parse_VIP_ReceiveGiftBagOk", "vivi")
	-- --@brief	获取vip信息成功（VIP_GetVipInfoOk = 4）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipInfoOk, 
	-- 	"ProtocolProcessorWndVip:parse_VIP_GetVipInfoOk", "iiib")
	-- --@brief	获取奖励列表成功（VIP_GetVipRewardsInfoOk = 6）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipRewardsInfoOk, 
	-- 	"ProtocolProcessorWndVip:parse_VIP_GetVipRewardsInfoOk", "viviviviivi")
	--@brief	领取等级礼包成功（VIP_GetVipLevelAwardOK = 10）
	--self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipLevelAwardOK, 
	--	"ProtocolProcessorWndVip:parse_VIP_GetVipLevelAwardOK", "vivi")
	--@brief 	使用每日礼包（S->C）
    self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_GetGiftOk, 
    	"ProtocolProcessorWndVip:parse_SPREE_GetGiftOk", "vsvsvi")
	--@brief	获取特权礼包信息结果（VIP_GetVipPrivilegeGiftOk = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipPrivilegeGiftOk, "ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk", "vivsvsi")

	--@brief	获取充值返利信息结果（VIP_GetVipRebateInfoOk = 12）
	WZLog("注册VIP协议")
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipRebateInfoOk, "ProtocolProcessorWndVip:parse_VIP_GetVipRebateInfoOk", "vivivsvti")

	--@brief	领取充值返利结果（VIP_DrawVipRebateOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_DrawVipRebateOk, "ProtocolProcessorWndVip:parse_VIP_DrawVipRebateOk", "")

	--@brief	获取网页充值信息成功（VIP_GetWebInfoOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetWebInfoOk, "ProtocolProcessorWndVip:parse_VIP_GetWebInfoOk", "bi")


	--协议错误注册
	--领取每日礼包（VIP_ReceiveGiftBag = 1）失败
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_ReceiveGiftBag , 
		"ProtocolProcessorWndVip:parse_VIP_RecvBagErrorMessage", "is" )
	--领取等级礼包（VIP_GetVipLevelAward = 5）失败
	--self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipLevelAward , 
	--	"ProtocolProcessorWndVip:parse_VIP_RecvBagErrorMessage", "is" )
	--获取vip信息（VIP_GetVipInfo = 3）失败
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipInfo , 
		"ProtocolProcessorWndVip:parse_VIP_InfoErrorMessage", "is" )
	--获取每日、等级礼包奖励信息（VIP_GetVipRewardsInfo = 5）失败
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipRewardsInfo , 
		"ProtocolProcessorWndVip:parse_VIP_GetVipRewardsInfoErrorMessage", "is" )
	--@brief	使用每日礼包错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_GetGift, 
    	"ProtocolProcessorWndVip:send_SPREE_GetGift_ErrorProcess", "is" )
	--@brief	获取特权礼包信息（VIP_GetVipPrivilegeGift = 9）错误处理(S->C)
 	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipPrivilegeGift, "ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift_ErrorProcess", "is" )

	--@brief	获取充值返利信息（VIP_GetVipRebateInfo = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipRebateInfo, "ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo_ErrorProcess", "is" )

	--@brief	领取充值返利（VIP_DrawVipRebate = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_DrawVipRebate, "ProtocolProcessorWndVip:send_VIP_DrawVipRebate_ErrorProcess", "is" )

	--@brief	获取网页充值信息（VIP_GetWebInfo = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetWebInfo, "ProtocolProcessorWndVip:send_VIP_GetWebInfo_ErrorProcess", "is" )
	--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo, "ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess", "is" )
    --@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfoOk = 63）
    self:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfoOk, "ProtocolProcessorWndVip:parse_ACTIVITY_GetWelfareCardActivityInfoOk", "iii")
    --@brief    vip礼包信息（MALL_GetVipGift = 45）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetVipGift, "ProtocolProcessorWndVip:send_MALL_GetVipGift_ErrorProcess", "is" )
    --@brief    购买vip礼包（MALL_BuyVipGift = 47）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyVipGift, "ProtocolProcessorWndVip:send_MALL_BuyVipGift_ErrorProcess", "is" )
    --@brief    vip礼包信息（MALL_GetVipGiftOk = 46）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_GetVipGiftOk, "ProtocolProcessorWndVip:parse_MALL_GetVipGiftOk", "vivivsvsvsvivivi")
    --@brief    购买vip礼包（MALL_BuyVipGiftOk = 48）
    self:regProtocolCallbackFunction( Protocol.MAIN_MALL, Protocol.MALL_BuyVipGiftOk, "ProtocolProcessorWndVip:parse_MALL_BuyVipGiftOk", "i")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndVip:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取网页充值信息（VIP_GetWebInfo = 15）
function ProtocolProcessorWndVip:send_VIP_GetWebInfo( )
	WZLog("send_VIP_GetWebInfo")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetWebInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取每日礼包（VIP_ReceiveGiftBag = 1）
function ProtocolProcessorWndVip:send_VIP_ReceiveGiftBag( )
	WZLog("send_VIP_ReceiveGiftBag")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_ReceiveGiftBag )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取vip信息（VIP_GetVipInfo = 3）
function ProtocolProcessorWndVip:send_VIP_GetVipInfo( )
	WZLog("send_VIP_GetVipInfo")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetVipInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
	
end

--@brief	获取vip奖励列表（VIP_GetVipRewardsInfo = 5）
function ProtocolProcessorWndVip:send_VIP_GetVipRewardsInfo( typeID )
	WZLog("send_VIP_GetVipRewardsInfo")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetVipRewardsInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeID )	-- 类型ID
	SendProtocol(sender,false) --true:showLoading
	
end


--@brief	领取等级礼包（VIP_GetVipLevelAward = 10）
function ProtocolProcessorWndVip:send_VIP_GetVipLevelAward( ele, vipLv )
	WZLog("send_VIP_GetVipLevelAward")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetVipLevelAward )
	if sender==nil then WZLog("sender == nil") return end
	if ele then 
		self.fromElement = ele 
		self.vipLv = vipLv
	end 
	sender:writeInt( vipLv )	-- 类型ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用会员每日礼包/等级礼包
function ProtocolProcessorWndVip:send_SPREE_GetGift(itemId )
	WZLog("send_SPREE_GetGift")
	local sender = Protocol:getSender( Protocol.MAIN_SPREE, Protocol.SPREE_GetGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取特权礼包信息（VIP_GetVipPrivilegeGift = 9）
--@author	zsq
function ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift( )
	WZLog("send_VIP_GetVipPrivilegeGift")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetVipPrivilegeGift )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取充值返利信息（VIP_GetVipRebateInfo = 11）
function ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo( )
	WZLog("send_VIP_GetVipRebateInfo")
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_GetVipRebateInfo )
	if sender==nil then WZLog("sender == nil") return end


	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取充值返利（VIP_DrawVipRebate = 13）
function ProtocolProcessorWndVip:send_VIP_DrawVipRebate(rebateId )
	WZLog("send_VIP_DrawVipRebate", rebateId)
	local sender = Protocol:getSender( Protocol.MAIN_VIP, Protocol.VIP_DrawVipRebate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rebateId )
	SendProtocol(sender,false) --true:showLoading
	WndVip:createLoadingUI()
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）
function ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo(activityType)
    WZLog("send_ACTIVITY_GetWelfareCardActivityInfo")
    local sender = Protocol:getSender( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( activityType ) -- 活动类型
    SendProtocol(sender,false) --true:showLoading
end

--@brief    vip礼包信息（MALL_GetVipGift = 45）
function ProtocolProcessorWndVip:send_MALL_GetVipGift()
    WZLog("send_MALL_GetVipGift")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_GetVipGift )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    购买vip礼包（MALL_BuyVipGift = 47）
function ProtocolProcessorWndVip:send_MALL_BuyVipGift(giftId)
    WZLog("send_MALL_BuyVipGift")
    local sender = Protocol:getSender( Protocol.MAIN_MALL, Protocol.MALL_BuyVipGift )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( giftId ) -- 礼包Id
    SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取网页充值信息成功（VIP_GetWebInfoOk = 16）
function ProtocolProcessorWndVip:parse_VIP_GetWebInfoOk(open, count)
	-- open : 是否开启网页充值
	-- count : 今天已经网页充值的次数
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetWebInfoOk", open, count)
	WndVip:setWebState(open, count)
end

--@brief	获取充值返利信息结果（VIP_GetVipRebateInfoOk = 12）
function ProtocolProcessorWndVip:parse_VIP_GetVipRebateInfoOk(rebateId, rechargeNum, reward, status, rechargeProgress)
	-- rebateId : 返利配置id
	-- rechargeNum : 充值额度
	-- reward : 奖励
	-- status : 状态,0:未激活,1:可领取,2:已领取
	-- rechargeProgress : 充值进度
	-- totalProgress : 总充值进度
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetVipRebateInfoOk")
	WndVip:setRebateList(VectorToTable(rebateId),VectorToTable(rechargeNum),VectorToTable(reward),VectorToTable(status),VectorToTable(rechargeProgress),VectorToTable(rechargeNum))
	WndVip:showWndUIRecharge()
end

--@brief	领取充值返利结果（VIP_DrawVipRebateOk = 14）
function ProtocolProcessorWndVip:parse_VIP_DrawVipRebateOk()
	WZLog("ProtocolProcessorWndVip:parse_VIP_DrawVipRebateOk")
	ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo( )
	if WndVip.m_tGiftNum then
		WndRewardShow:showById(WndVip.m_tGiftId,WndVip.m_tGiftNum)
		WndVip.m_tGiftId = nil
		WndVip.m_tGiftNum = nil

	end
end

--@brief	领取每日礼包成功（VIP_ReceiveGiftBagOk = 2）
function ProtocolProcessorWndVip:parse_VIP_ReceiveGiftBagOk(itemId,itenCount)
	--dayGiftBagID	:	每日礼包ID
	WZLog("ProtocolProcessorWndVip:parse_VIP_ReceiveGiftBagOk", dayGiftBagID)
	--刷新VIP信息
	--self:send_VIP_GetVipInfo( )	
	--领取成功
	WndVip:setBtnGiftBagTouch(false)
	GlobalGame.g_nVipPrivilege = 0
	GlobalGame.g_nVipGiftBagNum = GlobalGame.g_nVipGiftBagNum - 1
	WndRewardShow:showById(VectorToTable(itemId),VectorToTable(itenCount))
	--MsgBoxManager:showTipBox( LocalStrings.VIP_RECVSUCCESS )
	--WndVip:useGiftBag(dayGiftBagID, true)--不需要再发领取礼包的协议
	WndLeftMenu:setVipCount(true)
end

--@brief	领取等级礼包成功（VIP_GetVipLevelAwardOK = 11）
function ProtocolProcessorWndVip:parse_VIP_GetVipLevelAwardOK(itemId,itenCount)
	--vipBagID	:	等级礼包ID
	WZLog("ProtocolProcessorWndVip:VIP_GetVipLevelAwardOK", vipBagID)
   -- MsgBoxManager:showTipBox( LocalStrings.VIP_RECVSUCCESS )
	if self.fromElement and self.vipLv then 
		self.fromElement:setTouchEnable(false) 
		if PrefetchCache:has("m_tVipLevelGiftList") then 
			PrefetchCache.m_tVipLevelGiftList[6][self.vipLv] = 1 --已领取
		end 
	end 
	GlobalGame.g_nVipGiftBagNum = GlobalGame.g_nVipGiftBagNum - 1
	WndRewardShow:showById(VectorToTable(itemId),VectorToTable(itenCount))
	--WndVip:useGiftBag(vipBagID)  --不需要再发送领取礼包协议
	WndLeftMenu:setVipCount(true)
end


--@brief	获取vip信息成功（VIP_GetVipInfoOk = 4）
function ProtocolProcessorWndVip:parse_VIP_GetVipInfoOk(vipExp, vipLv, nextLvExp, isReceiveDayPack)
	-- vipExp	vip经验
	-- vipLv	vip等级
	-- nextLvExp	升级到下个等级需要经验
	-- isReceiveDayPack	是否领取了vip每日礼包
	-- isReceiveLvPack	是否领取了vip等级礼包信息 1 为以领取(一共10级)
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetVipInfoOk2")
	WndVip:setVipList( vipExp, vipLv, nextLvExp, isReceiveDayPack)
end

--@brief	获取奖励列表成功（VIP_GetVipRewardsInfoOk = 6）
function ProtocolProcessorWndVip:parse_VIP_GetVipRewardsInfoOk(vipLevel, itemId, itemName, itemIcon, count, days, typeReturn, isReceiveLvPack)
	-- vipLevel	会员等级
	-- itemId	物品id
	-- itemName	物品名称
	-- itemIcon	物品图标
	-- count	物品数量
	-- days	int[]	有效天数
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetVipRewardsInfoOk")
	WndVip:getVipRewardsOK(VectorToTable(vipLevel),VectorToTable(itemId),VectorToTable(itemName),
		VectorToTable(itemIcon),VectorToTable(count),VectorToTable(days),typeReturn, VectorToTable(isReceiveLvPack))
end

--@brief	使用每日礼包成功
--@return	无
--@note		备注
function ProtocolProcessorWndVip:parse_SPREE_GetGiftOk(itemName, itemIcon, itemNum)
	-- itemName : 物品名称
	-- itemIcon : 物品图标
	-- itemNum : 物品对应数量
	WZLog("ProtocolProcessorWndVip:parse_SPREE_GetGiftOk")
    WndVip:useGiftBagOK(itemName, itemIcon, itemNum)
end

--@brief	获取特权礼包信息结果（VIP_GetVipPrivilegeGiftOk = 10）
--@author	zsq
function ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk(vipLevel, gift, limitGood, currentVipLevel)
	-- gift : 等级礼包
	-- limitGood : 限购物品
	-- currentVipLevel : 当前vip等级
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk")
	WndVip:setData(vipLevel, gift, limitGood, currentVipLevel)
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfoOk = 63）
function ProtocolProcessorWndVip:parse_ACTIVITY_GetWelfareCardActivityInfoOk(progress, num, endTime)
    -- progress : 活动是否在进行. 0-进行中 1-已结束
    -- num : 购买次数
    -- endTime : 活动结束时间. 秒.
    WZLog("ProtocolProcessorWndVip:parse_ACTIVITY_GetWelfareCardActivityInfoOk")
    if WndVip.m_root then 
        WndVip:GetCardActivityInfoOK(progress, num, endTime)
    end
end

--@brief    vip礼包信息（MALL_GetVipGiftOk = 46）
function ProtocolProcessorWndVip:parse_MALL_GetVipGiftOk(giftId, needVip, item, price, nowprice, buytype, num, buyNum)
    -- giftId : 礼包Id
	-- needVip : 需要vip等级
	-- item : 物品
	-- price : 原价
	-- nowprice : 现价
	-- buytype : 购买类型（现在只有周限购），1为周限购
	-- num : 可购买数量
	-- buyNum : 已购买数量

    WZLog("ProtocolProcessorWndVip:parse_MALL_GetVipGiftOk")
    if WndVip.m_root then
    	WndVip:setWeekPackageList(VectorToTable(giftId), VectorToTable(item), VectorToTable(buyNum), VectorToTable(needVip), VectorToTable(price), VectorToTable(nowprice), VectorToTable(buytype), VectorToTable(num))
    end
end

--@brief    购买vip礼包（MALL_BuyVipGiftOk = 48）
function ProtocolProcessorWndVip:parse_MALL_BuyVipGiftOk(giftId)
    -- progress : 活动是否在进行. 0-进行中 1-已结束
    -- num : 购买次数
    -- endTime : 活动结束时间. 秒.
    WZLog("ProtocolProcessorWndVip:parse_MALL_BuyVipGiftOk")
    if WndVip.m_root then
    	WndVip:buyWeekPackageOK(giftId)
    end
end
-------------------------------------协议错误处理方法模块--------------------------------------

--领取每日礼包（VIP_ReceiveGiftBag = 1）失败
function ProtocolProcessorWndVip:parse_VIP_RecvBagErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::55552 ",KLuaSocket:utfToGBK(message) )
	--如果领取礼包，跳出 "当日已领取" 提示
	MsgBoxManager:showTipBox( LocalStrings.VIP_CURDAYRECV )
	-- 领取礼包失败
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_ReceiveGiftBag, isexit, message)
end

--获取vip信息（VIP_GetVipInfo = 3）失败
function ProtocolProcessorWndVip:parse_VIP_InfoErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--获取vip信息失败
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_GetVipInfo, isexit, message)
end

--@brief	获得奖励列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_SPREE_GetGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_SPREE_GetGift_ErrorProcess")
    WndVip:useItemError(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPREE, Protocol.SPREE_GetGift, nflag, sMessage)
end

--获取vip信息（VIP_GetVipRewardsInfo = 5）失败
function ProtocolProcessorWndVip:parse_VIP_GetVipRewardsInfoErrorMessage(isexit , message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--获取vip信息失败
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_GetVipRewardsInfo, isexit, message)
end

--@brief	获取特权礼包信息（VIP_GetVipPrivilegeGift = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_VIP_GetVipPrivilegeGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_GetVipPrivilegeGift, nflag, sMessage)
end

--@brief	获取充值返利信息（VIP_GetVipRebateInfo = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_VIP_GetVipRebateInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_GetVipRebateInfo, nflag, sMessage)
end

--@brief	领取充值返利（VIP_DrawVipRebate = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_VIP_DrawVipRebate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_VIP_DrawVipRebate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_DrawVipRebate, nflag, sMessage)
end


--@brief	获取网页充值信息（VIP_GetWebInfo = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_VIP_GetWebInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_VIP_GetWebInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_VIP, Protocol.VIP_GetWebInfo, nflag, sMessage)
end

--@brief    福利卡活动信息（ACTIVITY_GetWelfareCardActivityInfo = 62）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetWelfareCardActivityInfo, nflag, sMessage)
end

--@brief    vip礼包信息（MALL_GetVipGift = 45）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_MALL_GetVipGift_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndVip:send_MALL_GetVipGift_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_GetVipGift, nflag, sMessage)
end

--@brief    购买vip礼包（MALL_BuyVipGift = 47）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_MALL_BuyVipGift_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndVip:send_MALL_BuyVipGift_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MALL, Protocol.MALL_BuyVipGift, nflag, sMessage)
end
-------------------------------------公有方法模块End----------------------------------------


