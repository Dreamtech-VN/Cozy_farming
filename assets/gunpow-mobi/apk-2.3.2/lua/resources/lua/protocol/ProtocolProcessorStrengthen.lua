--ProtocolProcessorStrengthen.lua
--@brief	强化研究院相关协议
--@date  	2013/12/31
--@author 	SuYuan
--@note 	强化研究院相关协议


ProtocolProcessorStrengthen = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorStrengthen:regAll()
	--服务器到客户端协议注册
	--@brief	强化结果（ FORGING_MergeOK = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MergeOK, "ProtocolProcessorStrengthen:parse_FORGING_MergeOK", "b")
	
	--@brief	升星结果（ FORGING_UpStarOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_UpStarOK, "ProtocolProcessorStrengthen:parse_FORGING_UpStarOK", "")
	
	--@brief	镶嵌结果（ FORGING_MosaicOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MosaicOK, "ProtocolProcessorStrengthen:parse_FORGING_MosaicOK", "")
	
	--@brief	拆卸结果（ FORGING_DismantleOK = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_DismantleOK, "ProtocolProcessorStrengthen:parse_FORGING_DismantleOK", "")
	
	--@brief	转移结果（ FORGING_MoveAttributeOK = 10）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MoveAttributeOK, "ProtocolProcessorStrengthen:parse_FORGING_MoveAttributeOK", "")

	--@brief	强化结果（ FORGING_MergeNewOK = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MergeNewOK, "ProtocolProcessorStrengthen:parse_FORGING_MergeNewOK", "")

	--@brief	升星结果（ FORGING_UpStarNewOK = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_UpStarNewOK, "ProtocolProcessorStrengthen:parse_FORGING_UpStarNewOK", "b")

	--@brief	洗练结果（ FORGING_WeaponWashingOK = 16）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_WeaponWashingOK, "ProtocolProcessorStrengthen:parse_FORGING_WeaponWashingOK", "b")

	--@brief	宝石操作结果（ FORGING_GemOperateOk = 18）
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_GemOperateOk, "ProtocolProcessorStrengthen:parse_FORGING_GemOperateOk", "bi")
	
	
	--协议错误处理
	--@brief	强化（ FORGING_Merge= 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_Merge, "ProtocolProcessorStrengthen:send_FORGING_Merge_ErrorProcess", "is" )

	--@brief	升星（ FORGING_UpStar= 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_UpStar, "ProtocolProcessorStrengthen:send_FORGING_UpStar_ErrorProcess", "is" )
	
	--@brief	镶嵌（ FORGING_Mosaic= 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_Mosaic, "ProtocolProcessorStrengthen:send_FORGING_Mosaic_ErrorProcess", "is" )
	
	--@brief	拆卸（ FORGING_Dismantle= 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_Dismantle, "ProtocolProcessorStrengthen:send_FORGING_Dismantle_ErrorProcess", "is" )
	
	--@brief	转移（ FORGING_MoveAttribute= 9）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MoveAttribute, "ProtocolProcessorStrengthen:send_FORGING_MoveAttribute_ErrorProcess", "is" )

	--@brief	强化（ FORGING_MergeNew= 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_MergeNew, "ProtocolProcessorStrengthen:send_FORGING_MergeNew_ErrorProcess", "is" )

	--@brief	升星（ FORGING_UpStarNew= 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_UpStarNew, "ProtocolProcessorStrengthen:send_FORGING_UpStarNew_ErrorProcess", "is" )

	--@brief	洗练武器技能（ FORGING_WeaponWashing= 15）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_WeaponWashing, "ProtocolProcessorStrengthen:send_FORGING_WeaponWashing_ErrorProcess", "is" )

	--@brief	宝石操作（ FORGING_GemOperate = 17）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FORGING, Protocol.FORGING_GemOperate, "ProtocolProcessorStrengthen:send_FORGING_GemOperate_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorStrengthen:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	强化（ FORGING_Merge= 1）
function ProtocolProcessorStrengthen:send_FORGING_Merge(playerItemId, stoneId )
	WZLog("send_FORGING_Merge")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_Merge )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 强化装备的playerItemId
	sender:writeInts( stoneId )	-- 石头的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	升星（ FORGING_UpStar= 3）
function ProtocolProcessorStrengthen:send_FORGING_UpStar(playerItemId, stoneId )
	WZLog("send_FORGING_UpStar")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_UpStar )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 升星装备的playerItemId
	sender:writeInts( stoneId )	-- 升星石的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	镶嵌（ FORGING_Mosaic= 5）
function ProtocolProcessorStrengthen:send_FORGING_Mosaic(playerItemId, stoneId )
	WZLog("send_FORGING_Mosaic")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_Mosaic )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 镶嵌装备的playerItemId
	sender:writeInts( stoneId )	-- 宝石的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	拆卸（ FORGING_Dismantle= 7）
function ProtocolProcessorStrengthen:send_FORGING_Dismantle(playerItemId, stoneType )
	WZLog("send_FORGING_Dismantle")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_Dismantle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 装备的playerItemId
	sender:writeByte( stoneType )	-- 石头类型（1：攻击，2防御，3特殊）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	转移（ FORGING_MoveAttribute= 9）
function ProtocolProcessorStrengthen:send_FORGING_MoveAttribute(sourceplayerItemId, targetplayerItemId )
	WZLog("send_FORGING_MoveAttribute")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_MoveAttribute )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( sourceplayerItemId )	-- 源装备的playerItemId
	sender:writeInt( targetplayerItemId )	-- 目标装备的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	强化（ FORGING_MergeNew= 11）
function ProtocolProcessorStrengthen:send_FORGING_MergeNew(playerItemId, mergeType )
	WZLog("send_FORGING_MergeNew")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_MergeNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 强化装备的playerItemId
	sender:writeByte( mergeType )	-- 1、普通强化，2、一键强化
	SendProtocol(sender,false) --true:showLoading
end

--@brief	升星（ FORGING_UpStarNew= 13）
function ProtocolProcessorStrengthen:send_FORGING_UpStarNew(playerItemId, stoneId, equidId)
	WZLog("send_FORGING_UpStarNew")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_UpStarNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 升星装备的playerItemId
	sender:writeInts( stoneId )	-- 石头的playerItemId
	sender:writeInts( equidId )	-- 装备的playerItemId
	SendProtocol(sender,false) --true:showLoading
end

--@brief	洗练武器技能（ FORGING_WeaponWashing= 15）
function ProtocolProcessorStrengthen:send_FORGING_WeaponWashing(playerItemId, lockGrid )
	WZLog("send_FORGING_WeaponWashing")
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_WeaponWashing )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 洗练装备的playerItemId
	sender:writeInts( lockGrid )	-- 锁定的格子id 值为1-5
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宝石操作（ FORGING_GemOperate = 17）		
function ProtocolProcessorStrengthen:send_FORGING_GemOperate(operateType, playerItemId, stoneType, pItemId, pNum )
	WZLog("send_FORGING_GemOperate", operateType, playerItemId, stoneType, Serialize(VectorToTable(pItemId)), Serialize(VectorToTable(pNum)))
	local sender = Protocol:getSender( Protocol.MAIN_FORGING, Protocol.FORGING_GemOperate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( operateType )	-- 1融合 2升级 3进阶
	sender:writeInt( playerItemId )	-- 装备的playerItemId
	sender:writeByte( stoneType )	-- 石头类型（1：攻击，2防御，3生命, 4共鸣宝石）
	sender:writeInts( pItemId )	-- 升级吞噬playeritemId
	sender:writeInts( pNum )	-- 升级吞噬数量
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	强化结果（ FORGING_MergeOK = 2）
function ProtocolProcessorStrengthen:parse_FORGING_MergeOK(result)
	-- result : 合成结果
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_MergeOK")
	WndIntensifyStrengthen:onIntensifyResult(result)

	local isEndTeach, step = TeachGroup1:isTeachFinish(9)
    if isEndTeach ~= true and step > 0 then
	    TeachGroup1:endTeachStep({9,3})
	    WindowManager:addTeachShelterLayer( 999999, 0 )
	end
    --TeachGroup1:startGroup({9,4, WndStrengthen.m_root})
end

--@brief	升星结果（ FORGING_UpStarOK = 4）
function ProtocolProcessorStrengthen:parse_FORGING_UpStarOK()
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_UpStarOK")
	WndImproveStrengthen:onImproveSuccess()
end

--@brief	镶嵌结果（ FORGING_MosaicOK = 6）
function ProtocolProcessorStrengthen:parse_FORGING_MosaicOK()
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_MosaicOK")
	WndGemMountingStrengthen:onGemMountingSuccess()
end

--@brief	拆卸结果（ FORGING_DismantleOK = 8）
function ProtocolProcessorStrengthen:parse_FORGING_DismantleOK()
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_DismantleOK")
	WndGemMountingStrengthen:onRemoveSuccess()
end

--@brief	转移结果（ FORGING_MoveAttributeOK = 10）
function ProtocolProcessorStrengthen:parse_FORGING_MoveAttributeOK()
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_MoveAttributeOK")
	WndTransferStrengthen:onTransferSuccess()
end

--@brief	强化结果（ FORGING_MergeNewOK = 12）
function ProtocolProcessorStrengthen:parse_FORGING_MergeNewOK()
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_MergeNewOK")
	WndIntensifyStrengthen:onIntensifyResult()
end

--@brief	升星结果（ FORGING_UpStarNewOK = 14）
function ProtocolProcessorStrengthen:parse_FORGING_UpStarNewOK(result)
	-- result : 升星结果,true,成果
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_UpStarNewOK")
	WndImproveStrengthen:onImproveSuccess(result)
end

--@brief	洗练结果（ FORGING_WeaponWashingOK = 16）
function ProtocolProcessorStrengthen:parse_FORGING_WeaponWashingOK(result)
	-- result : 洗练结果,true,成功
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_WeaponWashingOK")
	--WndSophisticStrengthen:sophisticOk(result)
	WndSophistic:sophisticOk(result)
end

--@brief	宝石操作结果（ FORGING_GemOperateOk = 18）		
function ProtocolProcessorStrengthen:parse_FORGING_GemOperateOk(result,operateType)
	-- result : 操作结果,true,成功
	WZLog("ProtocolProcessorStrengthen:parse_FORGING_GemOperateOk",result,operateType)
	if operateType == 1 then
		WndGemHandle:getGemOperateOk(result,operateType)
	elseif operateType == 2 then
		WndMagicGemUpgrade:getGemOperateOk(result,operateType)
	elseif operateType == 3 then
		WndGemHandle:getGemOperateOk(result,operateType)
	end

end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	强化（ FORGING_Merge= 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_Merge_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_Merge_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_Merge, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
	WndIntensifyStrengthen.m_bIsIntensifing = false
end

--@brief	升星（ FORGING_UpStar= 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_UpStar_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_UpStar_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_UpStar, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
	WndImproveStrengthen.m_bIsImproving = false
end

--@brief	镶嵌（ FORGING_Mosaic= 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_Mosaic_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_Mosaic_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_Mosaic, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	拆卸（ FORGING_Dismantle= 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_Dismantle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_Dismantle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_Dismantle, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	转移（ FORGING_MoveAttribute= 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_MoveAttribute_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_MoveAttribute_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_MoveAttribute, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	强化（ FORGING_MergeNew= 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_MergeNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_MergeNew_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_MergeNew, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
	WndIntensifyStrengthen.m_bIsIntensifing = false
    --关闭加载框
    WndIntensifyStrengthen:_closeLoading()
end

--@brief	升星（ FORGING_UpStarNew= 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_UpStarNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_UpStarNew_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_UpStarNew, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
	WndIntensifyStrengthen.m_bIsImproving = false
    --关闭加载框
    WndImproveStrengthen:_closeLoading()
end

--@brief	洗练武器技能（ FORGING_WeaponWashing= 15）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_WeaponWashing_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_WeaponWashing_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_WeaponWashing, nflag, sMessage)
end

--@brief	宝石操作（ FORGING_GemOperate = 17）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorStrengthen:send_FORGING_GemOperate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorStrengthen:send_FORGING_GemOperate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FORGING, Protocol.FORGING_GemOperate, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------
