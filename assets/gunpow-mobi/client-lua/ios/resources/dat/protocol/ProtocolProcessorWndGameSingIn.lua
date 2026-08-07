--ProtocolProcessorWndGameSingIn.lua
--@brief	签到相关协议
--@date  	2015/05/20
--@author 	weidong_wu
--@note 	


ProtocolProcessorWndGameSingIn = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndGameSingIn:regAll()

	--@brief	获取签到状态错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetSignStatus, "ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus_ErrorProcess", "is" )

	--@brief	获取签到状态OK
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_GetSignStatusOk, "ProtocolProcessorWndGameSingIn:parse_TASK_GetSignStatusOk", "ibblbii")

	--@brief	签到错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_Sign, "ProtocolProcessorWndGameSingIn:send_TASK_Sign_ErrorProcess", "is" )	
 
	--@brief	签到OK
	self:regProtocolCallbackFunction( Protocol.MAIN_TASK, Protocol.TASK_SignOk, "ProtocolProcessorWndGameSingIn:parse_TASK_SignOk", "i")

end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndGameSingIn:unregAll()
	self:clearReg()
end


--@brief	获取签到状态
function ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus( )
	WZLog("send_TASK_GetSignStatus")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_GetSignStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	签到
function ProtocolProcessorWndGameSingIn:send_TASK_Sign(signType )
	WZLog("send_TASK_Sign")
	local sender = Protocol:getSender( Protocol.MAIN_TASK, Protocol.TASK_Sign )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( signType )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	签到OK
function ProtocolProcessorWndGameSingIn:parse_TASK_SignOk(days)
	-- days : 累计签到天数
	WZLog("ProtocolProcessorWndGameSingIn:parse_TASK_SignOk")
	if WndGameSingIn.m_nSignType == 2 or WndGameSingIn.m_nSignType == 3 then
		WndGameSingIn:GameSignOk(days)
	else
		CellGameSingInItem:GameSignOk(days)
		ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus( )
	end
end

--@brief	获取签到状态OK
function ProtocolProcessorWndGameSingIn:parse_TASK_GetSignStatusOk(days, sign, vipSign, nCurrentTime, monthReward, reissueTimes, todaySignNum)
	-- days : 累计签到天数
	-- sign : true今天签过了，false今天没签过
	-- vipSign : ture今天VIP签过了false今天VIP还未签过
	WZLog("ProtocolProcessorWndGameSingIn:parse_TASK_GetSignStatusOk")
	if WndGameSingIn.m_root ~= nil then 
		WndGameSingIn:GetSingInDataOK( days, sign ,vipSign , nCurrentTime, monthReward, reissueTimes, todaySignNum)
	else 
		ProtocolProcessorWndGameSingIn:unregAll()
		CacheCenter:initSignCacheData()
		local t = os.date("*t", SystemTime:getServerTime())
  		local m_currentDay = t.yday
  		local leapYear={31,29,31,30,31,30,31,31,30,31,30,31}
		local commonYear={31,28,31,30,31,30,31,31,30,31,30,31}
		local m_currentYear = t.year
		local templateYear
		if (m_currentYear%4==0 and not (m_currentYear%100==0)) or (m_currentYear%400==0) then 
			templateYear=leapYear
		else 
			templateYear=commonYear
		end
		local m_tTab =  GDatatab_sign_reward["id_"..m_currentDay]
		local m_currentMonth = m_tTab.month
		local startDay = 1
		for i=1,m_currentMonth-1 do
			startDay = templateYear[i]+startDay
		end
		local isVip = false 
        if sign then 
            WZLog("============================true")
            days = days - 1
        else 
            WZLog("============================false")
        end 
		local index = startDay + days 
        WZLog("********************11111111", startDay, days, index,m_currentYear,m_currentMonth,m_currentDay)
        local m_tData = GDatatab_sign_reward["id_"..index]
        if  m_tData.vip_level<1 then 
			isVip = false
		else 
			isVip = true 
		end 
		
        --Add By Tianxiang_Xu  
        --用于玩家VIP等级达到可以签到的vip等级时，显示主城界面签到按钮的红点
        if g_tTempSignData == nil then
            g_tTempSignData = {}
        end
        g_tTempSignData.vip_level = m_tData.vip_level
        g_tTempSignData.isVip = isVip 
        g_tTempSignData.sign = sign
        g_tTempSignData.vipSign = vipSign
        --End Add
        WZLog("******** WndGameSingIn ******** EEEEE", sign ,vipSign, isVip, m_tData.vip_level, CacheCenter:getPlayerInfo().vipLevel)
		if sign == false then 
			WndGameSingIn.m_bNeedSendProtocol = false
        	-- CacheCenter:setRedState("btnSign",true) 
        	-- GlobalGame:getBtnRedPointEvent():dispatcher("Sign",true)
        elseif sign==true and vipSign == false and isVip then 
  			if m_tData.vip_level > CacheCenter:getPlayerInfo().vipLevel then 
  				-- CacheCenter:setRedState("btnSign",false) 
      --   		GlobalGame:getBtnRedPointEvent():dispatcher("Sign",false)
        		CacheCenter:setSignCacheData(index,true)
  			else 
        		-- CacheCenter:setRedState("btnSign",true) 
        		-- GlobalGame:getBtnRedPointEvent():dispatcher("Sign",true)
        	end 
        else 
        	-- CacheCenter:setRedState("btnSign",false)
        	-- GlobalGame:getBtnRedPointEvent():dispatcher("Sign",false)
        end

	end 
end

--@brief	获取签到状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_GetSignStatus, nflag, sMessage)
end


--@brief	签到错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndGameSingIn:send_TASK_Sign_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndGameSingIn:send_TASK_Sign_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TASK, Protocol.TASK_Sign, nflag, sMessage)
end
