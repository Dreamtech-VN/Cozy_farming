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
	--@brief 	使用每日礼包（S->C）
    self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_GetGiftOk, 
    	"ProtocolProcessorWndVip:parse_SPREE_GetGiftOk", "vsvsvi")
	--@brief	获取特权礼包信息结果（VIP_GetVipPrivilegeGiftOk = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipPrivilegeGiftOk, "ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk", "vivsvsivi")

	--@brief	获取充值返利信息结果（VIP_GetVipRebateInfoOk = 12）
	WZLog("注册VIP协议")
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetVipRebateInfoOk, "ProtocolProcessorWndVip:parse_VIP_GetVipRebateInfoOk", "vivivsvti")

	--@brief	领取充值返利结果（VIP_DrawVipRebateOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_DrawVipRebateOk, "ProtocolProcessorWndVip:parse_VIP_DrawVipRebateOk", "")

	--@brief	获取网页充值信息成功（VIP_GetWebInfoOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_VIP, Protocol.VIP_GetWebInfoOk, "ProtocolProcessorWndVip:parse_VIP_GetWebInfoOk", "bi")


	--协议错误注册
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
	-- WndVip:showWndUIRecharge()
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
function ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk(vipLevel, gift, limitGood, currentVipLevel,status)
	-- gift : 等级礼包
	-- limitGood : 限购物品
	-- currentVipLevel : 当前vip等级
	-- status : 领取状态
	WZLog("ProtocolProcessorWndVip:parse_VIP_GetVipPrivilegeGiftOk")
	WndVip:setData(vipLevel, gift, limitGood, currentVipLevel,status)
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
    GlobalGame:getGameEventDispathcer():Dispatch(NewVipEvent.NewVipEvent_WelfareCardResult, progress, num, endTime)
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
    if WndVip.m_root or WndNewVip.m_root then
    	WndVip:setWeekPackageList(VectorToTable(giftId), VectorToTable(item), VectorToTable(buyNum), VectorToTable(needVip), VectorToTable(price), VectorToTable(nowprice), VectorToTable(buytype), VectorToTable(num))
    end
end

--@brief    购买vip礼包（MALL_BuyVipGiftOk = 48）
function ProtocolProcessorWndVip:parse_MALL_BuyVipGiftOk(giftId)
    -- progress : 活动是否在进行. 0-进行中 1-已结束
    -- num : 购买次数
    -- endTime : 活动结束时间. 秒.
    WZLog("ProtocolProcessorWndVip:parse_MALL_BuyVipGiftOk")
    if WndVip.m_root or WndNewVip.m_root then
    	WndVip:buyWeekPackageOK(giftId)
    end
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获得奖励列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndVip:send_SPREE_GetGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndVip:send_SPREE_GetGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPREE, Protocol.SPREE_GetGift, nflag, sMessage)
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


