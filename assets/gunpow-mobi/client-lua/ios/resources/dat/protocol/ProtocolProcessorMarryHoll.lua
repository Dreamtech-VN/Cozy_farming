--ProtocolProcessorMarryHoll.lua
--@brief	结婚大厅相关协议
--@date  	2013/4/21
--@author 	林庆凯	
--@note 	结婚礼堂相关协议

ProtocolProcessorMarryHoll = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorMarryHoll:regAll()
	
	--@brief	返回婚礼列表（WEDDING_GetWedListOK = 17）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetWedListOK, "ProtocolProcessorMarryHoll:parse_WEDDING_GetWedListOK", "vivtvtvsvsvivivbvivivivivivivivivivivivi")

    --@brief	获得婚礼列表（WEDDING_GetWedList = 16）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetWedList, "ProtocolProcessorMarryHoll:send_WEDDING_GetWedList_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorMarryHoll:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------


--@brief	获得婚礼列表（WEDDING_GetWedList = 16）
function ProtocolProcessorMarryHoll:send_WEDDING_GetWedList( )
	WZLog("send_WEDDING_GetWedList")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetWedList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	返回婚礼列表（WEDDING_GetWedListOK = 17）
function ProtocolProcessorMarryHoll:parse_WEDDING_GetWedListOK(weddingHallId, wedStatus, marryType, manName, womanName, startDate, endDate, usePassword, manFaceId, womanFaceId, manId, womanId, womanColour, manColour, womanbodyColour, manbodyColour, womanbody, manbody, womanhead, manhead)
	-- weddingHallId : 婚礼id
	-- wedStatus : 婚礼状态(0未开始，1进行中，2结束)
	-- marryType : 婚礼类型
	-- manName : 新郎名称
	-- womanName : 新娘名称
	-- startDate : 开始时间（秒）
	-- endDate : 结束时间（秒）
	-- usePassword : 是否使用密码（true是设置密码，false是不设置密码）
	-- manFaceId : 新郎的脸
	-- womanFaceId : 新娘的脸
	-- manId : 新郎id
	-- womanId : 新娘id
	-- womanColour : 新娘头部颜色
	-- manColour : 新郎头部颜色
	-- womanbodyColour : 新娘身颜色
	-- manbodyColour : 新郎身颜色
	-- womanbody :  新娘身
	-- manbody : 新郎身
	-- womanhead : 新娘头
	-- manhead : 新郎头
	WZLog("ProtocolProcessorMarryHoll:parse_WEDDING_GetWedListOKaaa =",Serialize(VectorToTable(manhead)))
	WndMarryManager:closeLoading()
	if SceneWeddingChurch.m_root then
	    SceneWeddingChurch.m_bBacking = false
	end
	SceneWeddingDaily:SendWedList(weddingHallId, wedStatus, marryType, manName, womanName, startDate, endDate, usePassword, manFaceId, womanFaceId, manId, womanId, womanColour, manColour, womanbodyColour, manbodyColour, womanbody, manbody, womanhead, manhead)
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获得婚礼列表（WEDDING_GetWedList = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMarryHoll:send_WEDDING_GetWedList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMarryHoll:send_WEDDING_GetWedList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetWedList, nflag, sMessage)
    if SceneWeddingChurch.m_root then
	    SceneWeddingChurch.m_bBacking = false
	end
end



-------------------------------------公有方法模块End----------------------------------------


