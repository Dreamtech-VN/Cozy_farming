--ProtocolProcessorFund.lua
--@brief	成长基金相关协议
--@date  	2013/12/18
--@author 	zsq
--@note 	成长基金相关协议


ProtocolProcessorFund = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorFund:regAll()
--@brief	获取成长基金等信息（FUNDGROW_GetFundInfo  = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundInfo, "ProtocolProcessorFund:send_FUNDGROW_GetFundInfo_ErrorProcess", "is" )
--@brief	购买成长基金（FUNDGROW_BuyFundgrow = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_BuyFundgrow, "ProtocolProcessorFund:send_FUNDGROW_BuyFundgrow_ErrorProcess", "is" )
--@brief	领取奖励操作（FUNDGROW_GetFundAward = 5）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundAward, "ProtocolProcessorFund:send_FUNDGROW_GetFundAward_ErrorProcess", "is" )

--@brief	获取成长基金等信息成功（FUNDGROW_GetFundInfoOk = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundInfoOk, "ProtocolProcessorFund:parse_FUNDGROW_GetFundInfoOk", "bvivii")
--@brief	购买成长基金成功（FUNDGROW_BuyFundgrowOk  = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_BuyFundgrowOk, "ProtocolProcessorFund:parse_FUNDGROW_BuyFundgrowOk", "i")
--@brief	领取基金奖励成功（FUNDGROW_GetFundAwardOk= 6）
self:regProtocolCallbackFunction( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundAwardOk, "ProtocolProcessorFund:parse_FUNDGROW_GetFundAwardOk", "ii")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorFund:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取成长基金等信息（FUNDGROW_GetFundInfo  = 1）
function ProtocolProcessorFund:send_FUNDGROW_GetFundInfo( )
	WZLog("send_FUNDGROW_GetFundInfo")
	local sender = Protocol:getSender( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买成长基金（FUNDGROW_BuyFundgrow = 3）
function ProtocolProcessorFund:send_FUNDGROW_BuyFundgrow( )
	WZLog("send_FUNDGROW_BuyFundgrow")
	local sender = Protocol:getSender( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_BuyFundgrow )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取奖励操作（FUNDGROW_GetFundAward = 5）
function ProtocolProcessorFund:send_FUNDGROW_GetFundAward(level )
	WZLog("send_FUNDGROW_GetFundAward")
	local sender = Protocol:getSender( Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundAward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( level )	-- 基础表中的等级
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取成长基金等信息成功（FUNDGROW_GetFundInfoOk = 2）
function ProtocolProcessorFund:parse_FUNDGROW_GetFundInfoOk(buy, levellist, receivelist, totalreceive)
	-- buy : 是否购买了基金
	-- levellist : 配置表中等级列表
	-- receivelist : 是否领取过 0:没领取   1:领取
	-- totalreceive : 累计获得基金数
	WZLog("ProtocolProcessorFund:parse_FUNDGROW_GetFundInfoOk",buy,Serialize(VectorToTable(levellist)),Serialize(VectorToTable(receivelist)),totalreceive)

	local receive = VectorToTable(receivelist)
	local finish = true
	for i=1,#receive do
		if receive[i] == 0 then
			finish = false
		end
	end
	if buy and finish then
		CacheCenter:setFundFinish(true)
	else
		CacheCenter:setFundFinish(false)
	end

    if WndFund.m_root then
        WndFund:setData(buy, VectorToTable(levellist), VectorToTable(receivelist), totalreceive)
    end

    WndOwnCity:GetFundInfoOk(buy, VectorToTable(levellist), VectorToTable(receivelist))
end

--@brief	购买成长基金成功（FUNDGROW_BuyFundgrowOk  = 4）
function ProtocolProcessorFund:parse_FUNDGROW_BuyFundgrowOk(status)
	-- status : 购买基金处理结果 0:失败,1:成功
	WZLog("ProtocolProcessorFund:parse_FUNDGROW_BuyFundgrowOk",status)
	if status == 0 then
		--失败

	elseif status == 1 then
		--成功
		ProtocolProcessorFund:send_FUNDGROW_GetFundInfo( )
    	MsgBoxManager:showTipBox(LocalStrings.BUY_FUND..LocalStrings.SUCCESS)
	end
end

--@brief	领取基金奖励成功（FUNDGROW_GetFundAwardOk= 6）
function ProtocolProcessorFund:parse_FUNDGROW_GetFundAwardOk(level, status)
	-- level : 配置表中等级
	-- status : 领取处理结果 0:失败,1:成功
	WZLog("ProtocolProcessorFund:parse_FUNDGROW_GetFundAwardOk",level,status)
	if status == 0 then
		--失败

	elseif status == 1 then
		--成功
		ProtocolProcessorFund:send_FUNDGROW_GetFundInfo( )
    	--MsgBoxManager:showTipBox(LocalStrings.FUNDINFO5)
		local tInfo 
		for k,v in pairs(GDatatab_fund_grow) do
			if v.level == level then
				tInfo = v
			end
		end
		WndRewardShow:showById({tInfo.diamond[1][1]},{tInfo.diamond[1][2]})
	end
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	获取成长基金等信息（FUNDGROW_GetFundInfo  = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFund:send_FUNDGROW_GetFundInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFund:send_FUNDGROW_GetFundInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundInfo, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	购买成长基金（FUNDGROW_BuyFundgrow = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFund:send_FUNDGROW_BuyFundgrow_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFund:send_FUNDGROW_BuyFundgrow_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_BuyFundgrow, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	领取奖励操作（FUNDGROW_GetFundAward = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFund:send_FUNDGROW_GetFundAward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFund:send_FUNDGROW_GetFundAward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FUNDGROW, Protocol.FUNDGROW_GetFundAward, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





