--ProtocolProcessorMerge.lua
--@brief	合成相关协议
--@date  	2015/4/14
--@author 	zsq
--@note 	合成相关协议


ProtocolProcessorMerge = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorMerge:regAll()
	--服务器到客户端协议注册
    --@brief	合成道具成功
    self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemOK, "ProtocolProcessorMerge:parse_MERGE_MergeItemOK", "")
	--@brief	装备中的宝石快速升级（MERGE_MergeItemFastOk=4）
	self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemFastOk, "ProtocolProcessorMerge:parse_MERGE_MergeItemFastOk", "i")
	--@brief	宠物装备宝石合成（升级）（MERGE_MergeItemPetEquipStoneOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemPetEquipStoneOK, "ProtocolProcessorMerge:parse_MERGE_MergeItemPetEquipStoneOK", "i")

    --@brief	合成道具错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItem, "ProtocolProcessorMerge:send_MERGE_MergeItem_ErrorProcess", "is" )
	--@brief	装备中的宝石快速升级（MERGE_MergeItemFast=3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemFast, "ProtocolProcessorMerge:send_MERGE_MergeItemFast_ErrorProcess", "is" )
	--@brief	宠物装备宝石合成（升级）（MERGE_MergeItemPetEquipStone = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemPetEquipStone, "ProtocolProcessorMerge:send_MERGE_MergeItemPetEquipStone_ErrorProcess", "is")
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorMerge:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	合成道具
function ProtocolProcessorMerge:send_MERGE_MergeItem(playerItemId, isFast, mergeType, mergeNum )
	WZLog("send_MERGE_MergeItem", playerItemId, isFast)
	local sender = Protocol:getSender( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItem )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品id
	sender:writeBoolean( isFast )	-- 是否快速合成
	sender:writeByte( mergeType )	-- 合成类型0道具，1装备，2时装,4皮肤
	sender:writeInt( mergeNum )	-- 合成数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	装备中的宝石快速升级（MERGE_MergeItemFast=3）
function ProtocolProcessorMerge:send_MERGE_MergeItemFast(equipId, ItemId, stoneIdList )
	WZLog("send_MERGE_MergeItemFast", equipId, ItemId, Serialize(VectorToTable(stoneIdList)))
	local sender = Protocol:getSender( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemFast )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( equipId )	-- 装备id
	sender:writeInt( ItemId )	-- 装备上的宝石id
	sender:writeInts( stoneIdList )	-- 消耗的宝石
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备宝石合成（升级）（MERGE_MergeItemPetEquipStone = 5）
function ProtocolProcessorMerge:send_MERGE_MergeItemPetEquipStone(playerItemId, stoneType, itemId)
	WZLog("send_MERGE_MergeItemPetEquipStone", playerItemId, stoneType, itemId)
	local sender = Protocol:getSender( Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemPetEquipStone )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 宠物装备id
	sender:writeByte(stoneType)	-- 宝石类型
	sender:writeInt(itemId)	-- 消耗物品宝石id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	合成道具成功
function ProtocolProcessorMerge:parse_MERGE_MergeItemOK()
	WZLog("ProtocolProcessorMerge:parse_MERGE_MergeItemOK")
	if WndExtraction.m_root ~= nil then
		WndExtraction:synthesisSuccess()
		return
	end

	WndPhantom:synthesisSuccess()

    WndSynthesisLeft:synthesisSuccess()
	WndSynthesisRight:synthesisSuccess()
end

--@brief	装备中的宝石快速升级（MERGE_MergeItemFastOk=4）
function ProtocolProcessorMerge:parse_MERGE_MergeItemFastOk(success)
	-- success : 1升级成功0升级失败
	WZLog("ProtocolProcessorMerge:parse_MERGE_MergeItemFastOk", success)
	if success == 1 then
		PopupResult("ui/common/common_icon_sjz.png")
		if WndStrengthen.m_root ~= nil then
    		WndStrengthen:_initEquipListByTag(WndStrengthen.m_equipClassifyIndex, true)
		end
	end
end

--@brief	宠物装备宝石合成（升级）（MERGE_MergeItemPetEquipStoneOK = 6）
function ProtocolProcessorMerge:parse_MERGE_MergeItemPetEquipStoneOK(success)
	-- success : 0: 失败 1：成功
	WZLog("ProtocolProcessorMerge:parse_MERGE_MergeItemPetEquipStoneOK", success)
	if success == 1 then
		PopupResult("ui/common/common_icon_sjz.png")
		if WndStrengthen.m_root ~= nil then
    		WndStrengthen:_initEquipListByTag(WndStrengthen.m_equipClassifyIndex, true)
		end
	end
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	合成道具错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMerge:send_MERGE_MergeItem_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMerge:send_MERGE_MergeItem_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MERGE, Protocol.MERGE_MergeItem, nflag, sMessage)
    --WndSynthesis:synthesisFailure(sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	装备中的宝石快速升级（MERGE_MergeItemFast=3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMerge:send_MERGE_MergeItemFast_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMerge:send_MERGE_MergeItemFast_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemFast, nflag, sMessage)
end

--@brief	宠物装备宝石合成（升级）（MERGE_MergeItemPetEquipStone = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorMerge:send_MERGE_MergeItemPetEquipStone_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorMerge:parse_MERGE_MergeItemPetEquipStone_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MERGE, Protocol.MERGE_MergeItemPetEquipStone, nflag, sMessage)
end

-------------------------------------协议错误处理方法模块End--------------------------------------





