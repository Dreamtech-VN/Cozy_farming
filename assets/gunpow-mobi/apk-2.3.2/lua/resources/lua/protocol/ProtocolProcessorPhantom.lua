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
	--@brief	皮肤炼化（SHAPE_Refine = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_Refine, "ProtocolProcessorPhantom:send_SHAPE_Refine_ErrorProcess", "is" )
	--@brief	皮肤各种操作（SHAPE_Operate = 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_Operate, "ProtocolProcessorPhantom:send_SHAPE_Operate_ErrorProcess", "is" )
	--@brief	炼化开关（SHAPE_ChangeRefineStatus = 17）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_ChangeRefineStatus, "ProtocolProcessorPhantom:send_SHAPE_ChangeRefineStatus_ErrorProcess", "is" )
	--@brief	获得皮肤装备信息（SHAPE_SendEquipInfo = 19）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_SendEquipInfo, "ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo_ErrorProcess", "is" )
	--@brief	使用装备（SHAPE_UseEquip = 21）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseEquip, "ProtocolProcessorPhantom:send_SHAPE_UseEquip_ErrorProcess", "is" )
	--@brief	合成皮肤装备（SHAPE_MergeEquip = 22）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_MergeEquip, "ProtocolProcessorPhantom:send_SHAPE_MergeEquip_ErrorProcess", "is" )
	--@brief	重铸皮肤装备（SHAPE_AgainEquip = 23）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_AgainEquip, "ProtocolProcessorPhantom:send_SHAPE_AgainEquip_ErrorProcess", "is" )
	--@brief	领取皮肤装备图鉴奖励（SHAPE_GetShapeEquipReward = 25）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeEquipReward, "ProtocolProcessorPhantom:send_SHAPE_GetShapeEquipReward_ErrorProcess", "is" )
	--@brief	获取皮肤组合列表（SHAPE_GetShapeGroupList = 27）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeGroupList, "ProtocolProcessorPhantom:send_SHAPE_GetShapeGroupList_ErrorProcess", "is")
	--@brief	激活皮肤组合共生技能（SHAPE_ActiveShapeGroup = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_ActiveShapeGroup, "ProtocolProcessorPhantom:send_SHAPE_ActiveShapeGroup_ErrorProcess", "is")
	--@brief	皮肤组合进阶（SHAPE_AdvanceShapeGroup = 31）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_AdvanceShapeGroup, "ProtocolProcessorPhantom:send_SHAPE_AdvanceShapeGroup_ErrorProcess", "is")


	--@brief	获取皮肤信息（SHAPE_GetShapeInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeInfoOk, "ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk", "vivivbvsvsvsvsviviviiiiivi")
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
	--@brief	炼化结果（SHAPE_RefineOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_RefineOk, "ProtocolProcessorPhantom:parse_SHAPE_RefineOk", "iivsvti")
	--@brief	皮肤操作结果 结果（SHAPE_ActiveRefineOk = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_ActiveRefineOk, "ProtocolProcessorPhantom:parse_SHAPE_ActiveRefineOk", "itinnssi")
	--@brief	炼化开关（SHAPE_ChangeRefineStatusOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_ChangeRefineStatusOk, "ProtocolProcessorPhantom:parse_SHAPE_ChangeRefineStatusOk", "iii")
	--@brief	成功获得皮肤装备信息（SHAPE_SendEquipInfoOk = 20）		
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_SendEquipInfoOk, "ProtocolProcessorPhantom:parse_SHAPE_SendEquipInfoOk", "iviviviviviivi")
	--@brief	更新皮肤装备信息（SHAPE_UpdateEquipInfo = 24）		
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_UpdateEquipInfo, "ProtocolProcessorPhantom:parse_SHAPE_UpdateEquipInfo", "ivivi")
	--@brief	成功获得皮肤装备信息（SHAPE_GetShapeEquipRewardOk = 26）		
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeEquipRewardOk, "ProtocolProcessorPhantom:parse_SHAPE_GetShapeEquipRewardOk", "ivivi")
	--@brief	获取皮肤组合列表OK（SHAPE_GetShapeGroupListOk = 28）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeGroupListOk, "ProtocolProcessorPhantom:parse_SHAPE_GetShapeGroupListOk", "viviviviisi")
	--@brief	激活皮肤组合共生技能OK（SHAPE_ActiveShapeGroupOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_ActiveShapeGroupOk, "ProtocolProcessorPhantom:parse_SHAPE_ActiveShapeGroupOk", "iiiii")
	--@brief	皮肤组合进阶OK（SHAPE_AdvanceShapeGroupOk = 32）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_AdvanceShapeGroupOk, "ProtocolProcessorPhantom:parse_SHAPE_AdvanceShapeGroupOk", "iiiisi")
	--@brief	移除皮肤装备OK（SHAPE_RemoveShapeEquipInfoOK = 33）
	self:regProtocolCallbackFunction( Protocol.MAIN_SHAPE, Protocol.SHAPE_RemoveShapeEquipInfoOK, "ProtocolProcessorPhantom:parse_SHAPE_RemoveShapeEquipInfoOK", "vi")

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
function ProtocolProcessorPhantom:send_SHAPE_UseItem(playerItemId, number )
	WZLog("send_SHAPE_UseItem")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseItem )
	if sender==nil then WZLog("sender == nil") return end

	number = number or 1
	sender:writeInt( playerItemId )	-- 玩家物品唯一标示
	sender:writeInt( number )	-- 数量
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

--@brief	皮肤炼化（SHAPE_Refine = 13）
function ProtocolProcessorPhantom:send_SHAPE_Refine(shapeId, refineType, refineNum)
	WZLog("send_SHAPE_Refine")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_Refine )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 需要升品的皮肤Id
	sender:writeByte( refineType )	-- 炼化方式【2=普通炼化 |3=钻石炼化】
	sender:writeInt( refineNum )	-- 炼化次数【1|5】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	皮肤各种操作（SHAPE_Operate = 15）
function ProtocolProcessorPhantom:send_SHAPE_Operate(shapeId, operateType)
	WZLog("send_SHAPE_Operate", operateType)
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_Operate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 需要升品的皮肤Id
	sender:writeByte( operateType )	-- 操作类型【1=激活炼化|2=保存炼化|3=取消炼化|4=进阶】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	炼化开关（SHAPE_ChangeRefineStatus = 17）
function ProtocolProcessorPhantom:send_SHAPE_ChangeRefineStatus(shapeId, property)
	WZLog("send_SHAPE_ChangeRefineStatus")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_ChangeRefineStatus)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( shapeId )	-- 需要升品的皮肤Id
	sender:writeInt( property )	-- 属性【1=生命|3=攻击|4=防御|12=敏捷、速度|13=幸运 】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得皮肤装备信息（SHAPE_SendEquipInfo = 19）		
function ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo( )
	WZLog("send_SHAPE_SendEquipInfo")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_SendEquipInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	使用装备（SHAPE_UseEquip = 21）		
function ProtocolProcessorPhantom:send_SHAPE_UseEquip(uId )
	WZLog("send_SHAPE_UseEquip",Serialize(VectorToTable(uId)))
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_UseEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( uId )	-- 装备唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	合成皮肤装备（SHAPE_MergeEquip = 22）		
function ProtocolProcessorPhantom:send_SHAPE_MergeEquip(uId )
	WZLog("send_SHAPE_MergeEquip",Serialize(VectorToTable(uId)))
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_MergeEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( uId )	-- 装备唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重铸皮肤装备（SHAPE_AgainEquip = 23）		
function ProtocolProcessorPhantom:send_SHAPE_AgainEquip(uId )
	WZLog("send_SHAPE_AgainEquip",Serialize(VectorToTable(uId)))
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_AgainEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( uId )	-- 装备唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取皮肤装备图鉴奖励（SHAPE_GetShapeEquipReward = 25）		
function ProtocolProcessorPhantom:send_SHAPE_GetShapeEquipReward(gId )
	WZLog("send_SHAPE_GetShapeEquipReward",gId)
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeEquipReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( gId )	-- 图鉴奖励id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取皮肤组合列表（SHAPE_GetShapeGroupList = 27）
function ProtocolProcessorPhantom:send_SHAPE_GetShapeGroupList()
	WZLog("send_SHAPE_GetShapeGroupList")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeGroupList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	激活皮肤组合共生技能（SHAPE_ActiveShapeGroup = 29）
function ProtocolProcessorPhantom:send_SHAPE_ActiveShapeGroup(shapeGroupId)
	WZLog("send_SHAPE_ActiveShapeGroup")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_ActiveShapeGroup )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(shapeGroupId)	-- 皮肤组合id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	皮肤组合进阶（SHAPE_AdvanceShapeGroup = 31）
function ProtocolProcessorPhantom:send_SHAPE_AdvanceShapeGroup(shapeGroupId)
	WZLog("send_SHAPE_AdvanceShapeGroup")
	local sender = Protocol:getSender( Protocol.MAIN_SHAPE, Protocol.SHAPE_AdvanceShapeGroup )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(shapeGroupId)	-- 皮肤组合id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取皮肤信息（SHAPE_GetShapeInfoOk = 2）
function ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk(shapeId, remainTime, activeRefineStatus, refineStatus, property, refinePropertySum, refineProperty, advanceLevel, blessingValue, fighting, useShapeId, show, shapeLeve, shapeExp, collectStatus)
	-- shapeId : 皮肤Id
	-- remainTime : 过期倒计时（秒）（-1为永久）
	-- useShapeId : 使用中的皮肤（0为没有使用）
	-- show : 是否展示
	-- shapeLeve : 幻化等级
	-- shapeExp : 幻化经验
	-- WZLog("获取皮肤协议",Serialize(VectorToTable(collectStatus)))
--[[	WZLog("ProtocolProcessorPhantom:parse_SHAPE_GetShapeInfoOk", 
		"\nshapeId =",Serialize(VectorToTable(shapeId)), 
		"\nremainTime =",Serialize(VectorToTable(remainTime)), 
		"\nactiveRefineStatus =",Serialize(VectorToTable(activeRefineStatus)), 
		"\nrefineStatus =",Serialize(VectorToTable(refineStatus)), 
		"\nproperty =",Serialize(VectorToTable(property)), 
		"\nrefinePropertySum =",Serialize(VectorToTable(refinePropertySum)), 
		"\nrefineProperty =",Serialize(VectorToTable(refineProperty)), 
		"\nadvanceLevel =",Serialize(VectorToTable(advanceLevel)), 
		"\nblessingValue =",Serialize(VectorToTable(blessingValue)), 
		"\nfighting =",Serialize(VectorToTable(fighting)), 
		"\nuseShapeId =",Serialize(VectorToTable(useShapeId)), 
		"\nshow =",Serialize(VectorToTable(show)), 
		"\nshapeLeve =",Serialize(VectorToTable(shapeLeve)), 
		"\nshapeExp =",Serialize(VectorToTable(shapeExp)), 
		"\ncollectStatus =",Serialize(VectorToTable(collectStatus)))]]
	WndPhantom:setData(VectorToTable(shapeId), VectorToTable(remainTime), useShapeId, show, shapeLeve, shapeExp, VectorToTable(activeRefineStatus), VectorToTable(refineStatus), VectorToTable(property), VectorToTable(refinePropertySum), VectorToTable(refineProperty), VectorToTable(advanceLevel), VectorToTable(blessingValue), VectorToTable(fighting))
	CacheCenter:getPlayerInfo().shapeId = useShapeId
	if WndPlayer.m_root ~= nil then
		WndPlayer:refreshRole()
	end

	CacheCenter:setSkinStatus(VectorToTable(shapeId),VectorToTable(collectStatus))

	WndSkinSkill:update()
	WndAscending:cleanWnd()
	WndAscending:updatePhantomData()
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
		WndPhantomChest:updateCoin()
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
		if WndPhantom then
			WndPhantom:shwoFightBtn(true)
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM17)
		if WndPhantom then
			WndPhantom:shwoFightBtn(false)
		end
	end
	
	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
end

--@brief	展示皮肤（SHAPE_SetShowOk = 10）
function ProtocolProcessorPhantom:parse_SHAPE_SetShowOk(show, useShapeId)
	-- show : 是否展示（1为展示，0为不展示）
	--ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo( )
	WndPhantom.show = 1--show
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

--@brief	炼化结果（SHAPE_RefineOk = 14）
function ProtocolProcessorPhantom:parse_SHAPE_RefineOk(result, shapeId, refineProperty, saveStatus, fighting)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_RefineOk")
	-- result :结果.0=成功 | 非0=失败
	-- shapeId :id【注意，升品返回的shapeId不是传上来的shapeId】
	-- refineProperty : 本次炼化属性增量，json格式{"1":200, "3":500}
	-- saveStatus : 每次炼化的结果是否自动保存生效【0=未保存 | 1=已保存】
	-- fighting : 皮肤战力（多次炼化才使用）

	WndPhantom:refineSuccess(result, shapeId, VectorToTable(refineProperty), VectorToTable(saveStatus), fighting)
end

--@brief	皮肤操作结果 结果（SHAPE_ActiveRefineOk = 16）
function ProtocolProcessorPhantom:parse_SHAPE_ActiveRefineOk(result, operateType, shapeId, advancedLevel, blessingValue, property, refinePropertySum, fighting)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_ActiveRefineOk")
	-- result : 结果.0=成功 | 非0=失败
	-- operateType : 操作类型【1=激活炼化|2=保存炼化|3=进阶】
	-- shapeId : id【注意，契约返回的shapeId不是传上来的shapeId】
	-- advancedLevel : 进阶等级
	-- blessingValue : 幸运值
	-- property : 属性，json格式{"1":200, "3":500}
	-- refinePropertySum : 属性累计炼化,json格式{"1":200, "3":500}。
	-- fighting : 战斗力

	WndPhantom:skinOperateResult(result, operateType, shapeId, advancedLevel, blessingValue, property, refinePropertySum, fighting)
end

--@brief	炼化开关（SHAPE_ChangeRefineStatusOk = 18）
function ProtocolProcessorPhantom:parse_SHAPE_ChangeRefineStatusOk(shapeId, property, status)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_ChangeRefineStatusOk")
	-- shapeId :皮肤ID
	-- property : 属性，json格式{"1":200, "3":500}
	-- status : 属性炼化状态【-1=属性未解锁 | 0=锁定属性不进行炼化 | 1=参与炼化 】

	WndPhantom:refineLockResult(shapeId, property, status)
end

--@brief	成功获得皮肤装备信息（SHAPE_SendEquipInfoOk = 20）		
function ProtocolProcessorPhantom:parse_SHAPE_SendEquipInfoOk(shapeId, eId, bId, bItemId, gId, status, quality, pastEquip)
	-- shapeId : 皮肤ID
	-- eId : 装备唯一id 1武器，2副手，3帽子，4上衣，5裤子，6鞋子，7结晶
	-- bId : 背包唯一id
	-- bItemId : 背包itemid
	-- gId : 图鉴奖励id
	-- status : 0不可领取 1可领取 2已领取
	-- quality : 开放品质
	-- pastEquip : 获得过的皮肤装备的itemId,用于图鉴界面
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_SendEquipInfoOk")
	-- WZLog("ProtocolProcessorPhantom:parse_SHAPE_SendEquipInfoOk",
	-- 	"\nshapeId =",Serialize(VectorToTable(shapeId)),
	-- 	"\neId =",Serialize(VectorToTable(eId)),
	-- 	"\nbId =",Serialize(VectorToTable(bId)),
	-- 	"\nbItemId =",Serialize(VectorToTable(bItemId)),
	-- 	"\ngId =",Serialize(VectorToTable(gId)),
	-- 	"\nstatus =",Serialize(VectorToTable(status)),
	-- 	"\nquality =",Serialize(VectorToTable(quality)),
	-- 	"\npastEquip =",Serialize(VectorToTable(pastEquip))
	-- 	)


	if WndPhantomEquipment.m_root then
		WndPhantomEquipment:setEquipInfoData(shapeId, VectorToTable(eId), VectorToTable(bId), VectorToTable(bItemId), VectorToTable(gId), VectorToTable(status), quality, VectorToTable(pastEquip))
	end

	if WndSell.m_root then
		WndSell:setEquipInfoData(shapeId, VectorToTable(eId), VectorToTable(bId), VectorToTable(bItemId), VectorToTable(gId), VectorToTable(status), quality, VectorToTable(pastEquip))
	end

	if CellExchangePanel.m_current and CellExchangePanel.m_current.m_root then
		CellExchangePanel.m_current:GetEquipInfoOk(shapeId, VectorToTable(eId), VectorToTable(bId), VectorToTable(bItemId), VectorToTable(gId), VectorToTable(status), quality, VectorToTable(pastEquip))
	end
end

--@brief	更新皮肤装备信息（SHAPE_UpdateEquipInfo = 24）		
function ProtocolProcessorPhantom:parse_SHAPE_UpdateEquipInfo(oType, itemIds, nums)
	-- oType : 1使用装备 2合成 3重铸 
	-- itemIds : 2合成或3重铸成功显示物品
	-- nums : 2合成或3重铸成功显示物品
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_UpdateEquipInfo",oType)

	if WndPhantomEquipment.m_root then
		WndPhantomEquipment:sendEquipInfoProtocol()
	end
	if WndSell.m_root then
		WndSell:sendEquipInfoProtocol()
	end
	if oType == 2 or oType == 3 then
		WndRewardShow:showById(VectorToTable(itemIds), VectorToTable(nums))
	end
end

--@brief	成功获得皮肤装备信息（SHAPE_GetShapeEquipRewardOk = 26）		
function ProtocolProcessorPhantom:parse_SHAPE_GetShapeEquipRewardOk(gId, itemId, num)
	-- gId : 图鉴奖励id
	-- itemId : 物品id
	-- num : 数量
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_GetShapeEquipRewardOk", gId, Serialize(VectorToTable(itemId)), Serialize(VectorToTable(num)))
	if WndPhantomEquAlbum.m_root then
		WndPhantomEquAlbum:getShapeEquipRewardOk(gId, VectorToTable(itemId), VectorToTable(num))
	end

	if WndPhantomEquipment.m_root then
		WndPhantomEquipment:sendEquipInfoProtocol()
	end

end

--@brief	获取皮肤组合列表OK（SHAPE_GetShapeGroupListOk = 28）
function ProtocolProcessorPhantom:parse_SHAPE_GetShapeGroupListOk(shapeGroupId, status, advanceLevel, advanceBlessingValue, useShapeGroupId, property, fighting)
	-- shapeGroupId : 皮肤组合id
	-- status : 皮肤组合状态【0=不可激活|1=可激活|2=已激活】
	-- advanceLevel : 皮肤组合进阶等级【0=未激活|1-30=玩家当前此组合的升级等级】
	-- advanceBlessingValue : 皮肤组合进阶幸运值
	-- useShapeGroupId : 当前使用中的皮肤组合ID【0=没有使用中的】
	-- property : 所有组合皮肤总属性增益，json格式{"1":200, "3":500}【169+】
	-- fighting : 所有组合皮肤总战力增益【169+】
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_GetShapeGroupListOk", 
		"\nshapeGroupId =",Serialize(VectorToTable(shapeGroupId)), 
		"\nstatus =",Serialize(VectorToTable(status)), 
		"\nadvanceLevel =",Serialize(VectorToTable(advanceLevel)), 
		"\nadvanceBlessingValue =",Serialize(VectorToTable(advanceBlessingValue)), 
		"\nuseShapeGroupId =",Serialize(VectorToTable(useShapeGroupId)),
		"\nproperty =",Serialize(VectorToTable(property)), 
		"\nfighting =",Serialize(VectorToTable(fighting))
		)

	WndPhantomGroup:getShapeGroupListOk(VectorToTable(shapeGroupId), VectorToTable(status), VectorToTable(advanceLevel), VectorToTable(advanceBlessingValue), useShapeGroupId, property, fighting)
end

--@brief	激活皮肤组合共生技能OK（SHAPE_ActiveShapeGroupOk = 30）
function ProtocolProcessorPhantom:parse_SHAPE_ActiveShapeGroupOk(result, shapeGroupId, status, advanceLevel, advanceBlessingValue)
	-- result : 激活结果【0=成功|1=失败-不满足激活条件】
	-- shapeGroupId : 皮肤组合id【请求激活时前端传递上来的值】
	-- status : 皮肤组合状态【0=不可激活|1=可激活|2=已激活】
	-- advanceLevel : 皮肤组合进阶等级【0=未激活|1-30=玩家当前此组合的进阶等级】
	-- advanceBlessingValue : 皮肤组合进阶幸运值
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_ActiveShapeGroupOk", result, shapeGroupId, status, advanceLevel, advanceBlessingValue)
	WndPhantomGroup:getActiveShapeGroupOk(result, shapeGroupId, status, advanceLevel, advanceBlessingValue)
end

--@brief	皮肤组合进阶OK（SHAPE_AdvanceShapeGroupOk = 32）
function ProtocolProcessorPhantom:parse_SHAPE_AdvanceShapeGroupOk(result, shapeGroupId, advanceLevel, advanceBlessingValue, property, fighting)
	-- result : 进阶结果【0=成功进阶|1=进阶概率失败】
	-- shapeGroupId : 皮肤组合id【请求进阶时前端传递上来的值】
	-- advanceLevel : 皮肤组合进阶等级
	-- advanceBlessingValue : 皮肤组合进阶幸运值
	-- property : 所有组合皮肤总属性增益，json格式{"1":200, "3":500}【169+】
	-- fighting : 所有组合皮肤总战力增益【169+】
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_AdvanceShapeGroupOk", result, shapeGroupId, advanceLevel, advanceBlessingValue, property, fighting)
	WndPhantomGroup:getAdvanceShapeGroupOk(result, shapeGroupId, advanceLevel, advanceBlessingValue, property, fighting)
end

--@brief	移除皮肤装备OK (SHAPE_RemoveShapeEquipInfoOK = 33)
function ProtocolProcessorPhantom:parse_SHAPE_RemoveShapeEquipInfoOK(ids)
	-- ids : 皮肤装备唯一id 
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_RemoveShapeEquipInfoOK", Serialize(VectorToTable(ids)))
	if CellExchangePanel.m_current and CellExchangePanel.m_current.m_root then
		CellExchangePanel.m_current:RemoveShapeEquipInfoOK(VectorToTable(ids))
	end
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

--@brief	皮肤炼化（SHAPE_Refine = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_Refine_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_Refine_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_Refine, nflag, sMessage)
	WndPhantom:setRefineCtr(true)
end

--@brief	皮肤各种操作（SHAPE_Operate = 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_Operate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_Operate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_Operate, nflag, sMessage)
end

--@brief	炼化开关（SHAPE_ChangeRefineStatus = 17）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_ChangeRefineStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_ChangeRefineStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_ChangeRefineStatus, nflag, sMessage)
end

--@brief	获得皮肤装备信息（SHAPE_SendEquipInfo = 19）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_SendEquipInfo, nflag, sMessage)
end

--@brief	使用装备（SHAPE_UseEquip = 21）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_UseEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_UseEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_UseEquip, nflag, sMessage)
end

--@brief	合成皮肤装备（SHAPE_MergeEquip = 22）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_MergeEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_MergeEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_MergeEquip, nflag, sMessage)
end

--@brief	重铸皮肤装备（SHAPE_AgainEquip = 23）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_AgainEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_AgainEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_AgainEquip, nflag, sMessage)
end

--@brief	领取皮肤装备图鉴奖励（SHAPE_GetShapeEquipReward = 25）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_GetShapeEquipReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:send_SHAPE_GetShapeEquipReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeEquipReward, nflag, sMessage)
end

--@brief	获取皮肤组合列表（SHAPE_GetShapeGroupList = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_GetShapeGroupList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_GetShapeGroupList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_GetShapeGroupList, nflag, sMessage)
end

--@brief	激活皮肤组合共生技能（SHAPE_ActiveShapeGroup = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_ActiveShapeGroup_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_ActiveShapeGroup_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_ActiveShapeGroup, nflag, sMessage)
end

--@brief	皮肤组合进阶（SHAPE_AdvanceShapeGroup = 31）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorPhantom:send_SHAPE_AdvanceShapeGroup_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorPhantom:parse_SHAPE_AdvanceShapeGroup_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SHAPE, Protocol.SHAPE_AdvanceShapeGroup, nflag, sMessage)
end

-------------------------------------协议错误处理方法模块End--------------------------------------





