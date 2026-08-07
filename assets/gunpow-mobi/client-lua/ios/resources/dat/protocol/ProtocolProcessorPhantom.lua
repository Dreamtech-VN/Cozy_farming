--ProtocolProcessorFund.lua
--@brief	幻化相关协议
--@date  	2017/4/26
--@author 	zsq
--@note 	幻化相关协议


ProtocolProcessorPhantom = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorPhantom:regAll()
--@brief	获取皮肤信息（SHAPE_GetShapeInfo = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeInfo, "ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo_ErrorProcess", "is" )
--@brief	开幻化宝箱（SHAPE_OpenBox = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_OpenBox, "ProtocolProcessorPhantom:send_SHAPE_OpenBox_ErrorProcess", "is" )
--@brief	激活皮肤（SHAPE_UseItem = 5）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseItem, "ProtocolProcessorPhantom:send_SHAPE_UseItem_ErrorProcess", "is" )
--@brief	使用皮肤（SHAPE_UseShape = 7）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseShape, "ProtocolProcessorPhantom:send_SHAPE_UseShape_ErrorProcess", "is" )
--@brief	展示皮肤（SHAPE_SetShow = 9）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_SetShow, "ProtocolProcessorPhantom:send_SHAPE_SetShow_ErrorProcess", "is" )
--@brief	升品皮肤（SHAPE_UpShapeInfo = 11）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UpShapeInfo, "ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo_ErrorProcess", "is" )


--@brief	获取皮肤信息（SHAPE_GetShapeInfoOk = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeInfoOk, "ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk", "viviiiii")
--@brief	开幻化宝箱（SHAPE_OpenBoxOk = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_OpenBoxOk, "ProtocolProcessorPhantom:parse_SHAPE_OpenBoxOk", "iiivivi")
--@brief	激活皮肤（SHAPE_UseItemOk = 6）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseItemOk, "ProtocolProcessorPhantom:parse_SHAPE_UseItemOk", "iivivi")
--@brief	使用皮肤（SHAPE_UseShapOk = 8）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseShapOk, "ProtocolProcessorPhantom:parse_SHAPE_UseShapOk", "i")
--@brief	展示皮肤（SHAPE_SetShowOk = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_SetShowOk, "ProtocolProcessorPhantom:parse_SHAPE_SetShowOk", "ii")
--@brief	升品皮肤（SHAPE_UpShapeInfoOk = 12）
self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UpShapeInfoOk, "ProtocolProcessorPhantom:parse_SHAPE_UpShapeInfoOk", "")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorPhantom:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取皮肤信息（SHAPE_GetShapeInfo = 1）
function ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
	WZLog("send_SHAPE_GetShapeInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	开幻化宝箱（SHAPE_OpenBox = 3）
function ProtocolProcessorPhantom:send_SHAPE_OpenBox(boxtype )
	WZLog("send_SHAPE_OpenBox")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_OpenBox )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( boxtype )	-- 宝箱类型
	SendProtocol(sender,false) --true:showLoading
end

--@brief	激活皮肤（SHAPE_UseItem = 5）
function ProtocolProcessorPhantom:send_SHAPE_UseItem(playerItemId )
	WZLog("send_SHAPE_UseItem")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品唯一标示
	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用皮肤（SHAPE_UseShape = 7）
function ProtocolProcessorPhantom:send_SHAPE_UseShape(shapeId )
	WZLog("send_SHAPE_UseShape")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseShape )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 皮肤Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	展示皮肤（SHAPE_SetShow = 9）
function ProtocolProcessorPhantom:send_SHAPE_SetShow(show )
	WZLog("send_SHAPE_SetShow")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_SetShow )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( show )	-- 是否展示（1为展示，0为不展示）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	升品皮肤（SHAPE_UpShapeInfo = 11）
function ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo(shapeId )
	WZLog("send_SHAPE_UpShapeInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_UpShapeInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 需要升品的皮肤Id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取皮肤信息（SHAPE_GetShapeInfoOk = 2）
function ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk(shapeId, remainTime, useShapeId, show, shapeLeve, shapeExp)
	-- shapeId : 皮肤Id
	-- remainTime : 过期倒计时（秒）（-1为永久）
	-- useShapeId : 使用中的皮肤（0为没有使用）
	-- show : 是否展示
	-- shapeLeve : 幻化等级
	-- shapeExp : 幻化经验
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk",useShapeId)
	WndPhantom:setData(VectorToTable(shapeId), VectorToTable(remainTime), useShapeId, show, shapeLeve, shapeExp)
	CacheCenter:getPlayerInfo().shapeId = useShapeId
	if WndPlayer.m_root ~= nil then
		WndPlayer:refreshRole()
	end

	WndSkinSkill:update()
end

--@brief	开幻化宝箱（SHAPE_OpenBoxOk = 4）
function ProtocolProcessorPhantom:parse_SHAPE_OpenBoxOk(itemId, num, exp, changeItemId, changeNum)
	-- itemId : 物品Id
	-- num : 数量
	-- exp : 获得永久皮肤时的经验值
	-- changeItemId : 拥有永久该皮肤是转换的物品Id
	-- changeNum : 拥有永久该皮肤是转换的物品数量
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_OpenBoxOk",itemId,num,Serialize(VectorToTable(changeItemId)),Serialize(VectorToTable(changeNum)))
	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
	local tData = GDatatab_item["id_"..itemId]
	if itemId == nil or tData == nil then return end
	--if #VectorToTable(changeItemId) > 0 then
	--	WndRewardShow:showById(VectorToTable(changeItemId),VectorToTable(changeNum))
	--	return
	--end
	if tData.main_type == 20 then
		local t = {}
		t.shapeId = tData.property[1][1]
		t.remainTime = tData.property[1][2] * 60
		t.changeItemId = VectorToTable(changeItemId)
		t.changeNum = VectorToTable(changeNum)
		if tData.property[1][2] == -1 then
			t.remainTime = -1
			WndPhantom.show = 1
		end
		WndPhantomChest:getSkin(t)
	else
		WndRewardShow:showById({itemId},{num})
	end
end

--@brief	激活皮肤（SHAPE_UseItemOk = 6）
function ProtocolProcessorPhantom:parse_SHAPE_UseItemOk(shapeId, remainTime, changeItemId, changeNum)
	-- itemId : 物品Id
	-- num : 数量
	-- changeItemId : 拥有永久该皮肤是转换的物品Id
	-- changeNum : 拥有永久该皮肤是转换的物品数量
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_UseItemOk",shapeId,remainTime,Serialize(VectorToTable(changeItemId)),Serialize(VectorToTable(changeNum)))
	if remainTime == -1 then
		local t = {}
		t.shapeId = shapeId
		t.remainTime = remainTime
		t.changeItemId = VectorToTable(changeItemId)
		t.changeNum = VectorToTable(changeNum)
		t.equipData = g_UsingPhantomData
		--WndPhantomChest:getSkin(t)
		WndPhantomShow:show(t)
		g_UsingPhantomData = nil 
	else
		g_UsingPhantomData = nil 
		MsgBoxManager:showTipBox(LocalStrings.STARSOUL_ACTIVITY_SUCCESS)
	end
	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
end

--@brief	使用皮肤（SHAPE_UseShapOk = 8）
function ProtocolProcessorPhantom:parse_SHAPE_UseShapOk(show)
	-- show : 是否展示
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_UseShapOk")
	if WndPhantom.cancel == true then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM28)
	else
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM17)
	end
	if WndPhantom.m_root ~= nil then
		GetElement(WndPhantom.m_root,"btnUse",WZUIButton):setVisible(false)
		--展示设置
		local selCheckBox = GetElement(WndPhantom.m_root,"setShow",WZUICheckBox)
		selCheckBox:setCheckIndex(1)
	end
	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
end

--@brief	展示皮肤（SHAPE_SetShowOk = 10）
function ProtocolProcessorPhantom:parse_SHAPE_SetShowOk(show, useShapeId)
	-- show : 是否展示（1为展示，0为不展示）
	--ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
	WndPhantom.show = show
	CacheCenter:getPlayerInfo().shapeId = useShapeId
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_SetShowOk")
	if show == 0 then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM28)
	else
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM17)
	end
	if WndPlayer.m_root ~= nil then
		WndPlayer:refreshRole()
	end
end

--@brief	升品皮肤（SHAPE_UpShapeInfoOk = 12）
function ProtocolProcessorPhantom:parse_SHAPE_UpShapeInfoOk()
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_UpShapeInfoOk")
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	获取皮肤信息（SHAPE_GetShapeInfo = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeInfo, nflag, sMessage)
end

--@brief	开幻化宝箱（SHAPE_OpenBox = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_OpenBox_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_OpenBox_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_OpenBox, nflag, sMessage)
end

--@brief	激活皮肤（SHAPE_UseItem = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_UseItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_UseItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_UseItem, nflag, sMessage)
end

--@brief	使用皮肤（SHAPE_UseShape = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_UseShape_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_UseShape_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_UseShape, nflag, sMessage)
end

--@brief	展示皮肤（SHAPE_SetShow = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_SetShow_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_SetShow_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_SetShow, nflag, sMessage)
end

--@brief	升品皮肤（SHAPE_UpShapeInfo = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_UpShapeInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_UpShapeInfo, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





