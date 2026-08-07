--ProtocolProcessorPets.lua
--@brief	宠物系统
--@date  	2015/4/13
--@author 	qixiang_xie
--@note 	宠物系统相关协议

ProtocolProcessorScenePets = ProtocolProcessorBase:new()
--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorScenePets:regAll()
	--@brief	获取所有宠物列表（PET_GetAllPetListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetListOk, "ProtocolProcessorScenePets:parse_PET_GetAllPetListOk", "vivsvsvsvnvnvsvivivivbvivivivivivsvivs")

	--@brief	获取所有宠物列表（PET_GetAllPetList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetList, "ProtocolProcessorScenePets:send_PET_GetAllPetList_ErrorProcess", "is" )

	--@brief	宠物出战（PET_ChangeStateOK = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_ChangeStateOK, "ProtocolProcessorScenePets:parse_PET_ChangeStateOK", "vivb")

	--@brief	宠物成功信息（PET_PetInfoOK = 4）			
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetInfoOK, "ProtocolProcessorScenePets:parse_PET_PetInfoOK", "vivsvsvsvnvnvsvivivivbvivtvivitvivivsvivs")

	--@brief	宠物抽奖（PET_Lottery = 3）		错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_Lottery, "ProtocolProcessorScenePets:send_PET_Lottery_ErrorProcess", "is" )

	--@brief	宠物升级（PET_Upgrade = 7）				错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_Upgrade, "ProtocolProcessorScenePets:send_PET_Upgrade_ErrorProcess", "is" )

	--@brief	宠物进阶（PET_Advanced = 8）						错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_Advanced, "ProtocolProcessorScenePets:send_PET_Advanced_ErrorProcess", "is" )

	--@brief	宠物重生（PET_Rebirth = 9）								错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_Rebirth, "ProtocolProcessorScenePets:send_PET_Rebirth_ErrorProcess", "is" )

    --@brief	宠物洗炼（PET_ResetSkill = 10）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_ResetSkill, "ProtocolProcessorScenePets:send_PET_ResetSkill_ErrorProcess", "is" )

    --@brief	洗炼成功（PET_ResetSkillOK = 11）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_ResetSkillOK, "ProtocolProcessorScenePets:parse_PET_ResetSkillOK", "bis")

    --@brief	删除宠物（PET_DeletePet = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_DeletePet, "ProtocolProcessorScenePets:parse_PET_DeletePet", "vi")

     --@brief	宠物抽奖成功（PET_DeletePet = 13）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_LotteryOK, "ProtocolProcessorScenePets:parse_PET_LotteryOK", "vivi")

    --@brief	宠物免费抽取（PET_Rebirth = 14）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetFreeTime, "ProtocolProcessorScenePets:send_PET_GetFreeTime", "is" )

     --@brief	宠物免费抽取成功（PET_DeletePet = 15）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetFreeTimeOK, "ProtocolProcessorScenePets:parse_PET_GetFreeTimeOK", "vtvi")
    
    --@brief	刷新宠物列表（PET_RefreshStore = 22）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_RefreshStore, "ProtocolProcessorScenePets:send_PET_RefreshStore_ErrorProcess", "is" )

    --@brief	洗练宠物资质（WashPetGift = 24）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.WashPetGift, "ProtocolProcessorScenePets:send_WashPetGift_ErrorProcess", "is" )

    --@brief	洗练宠物资质成功（PET_WashPetGiftOk = 25）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_WashPetGiftOk, "ProtocolProcessorScenePets:parse_PET_WashPetGiftOk", "ii")

    --@brief	宠物回收（PET_RecyclePet = 26）								
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_RecyclePet, "ProtocolProcessorScenePets:send_PET_RecyclePet_ErrorProcess", "is" )
    --@brief	宠物回收成功（PET_RecyclePetOk = 27）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_RecyclePetOk, "ProtocolProcessorScenePets:parse_PET_RecyclePetOk", "vivi")

    --@brief	宠物幻化（PET_ChangePetSkin = 28）							
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_ChangePetSkin, "ProtocolProcessorScenePets:send_PET_ChangePetSkin_ErrorProcess", "is" )
    --@brief	宠物幻化（PET_ChangePetSkinOk = 29）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_ChangePetSkinOk, "ProtocolProcessorScenePets:parse_PET_ChangePetSkinOk", "ii")

    --@brief	获取宠物能幻化的物品列表（PET_GetPetSkinList = 30）						
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetPetSkinList, "ProtocolProcessorScenePets:send_PET_GetPetSkinList_ErrorProcess", "is" )
    --@brief	宠物幻化（PET_GetPetSkinListOk = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetPetSkinListOk, "ProtocolProcessorScenePets:parse_PET_GetPetSkinListOk", "vi")

    --@brief	宠物技能转移（PET_PetSkillChange = 32）						
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetSkillChange, "ProtocolProcessorScenePets:send_PET_PetSkillChange_ErrorProcess", "is" )


	-- --@brief	获取宠物装备信息（PET_PetGetEquipInfo = 33）错误处理(S->C)
	-- self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetGetEquipInfo, "ProtocolProcessorScenePets:send_PET_PetGetEquipInfo_ErrorProcess", "is")
	--@brief	穿戴或卸下宠物装备（PET_PetWearORUnEquip = 35）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetWearORUnEquip, "ProtocolProcessorScenePets:send_PET_PetWearORUnEquip_ErrorProcess", "is")
	--@brief	宠物装备提升（等级、升星、升品）（PET_PetUpEquip = 37）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquip, "ProtocolProcessorScenePets:send_PET_PetUpEquip_ErrorProcess", "is")
	--@brief	宠物装备回收（PET_PetEquipRecycle = 41）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipRecycle, "ProtocolProcessorScenePets:send_PET_PetEquipRecycle_ErrorProcess", "is")
	--@brief	宠物装备镶嵌宝石（PET_PetEquipMosaic = 43）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipMosaic, "ProtocolProcessorScenePets:send_PET_PetEquipMosaic_ErrorProcess", "is")
	--@brief	宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaic = 45）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaic, "ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic_ErrorProcess", "is")
	--@brief	宠物装备继承（PET_PetEquipExtends = 47）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipExtends, "ProtocolProcessorScenePets:send_PET_PetEquipExtends_ErrorProcess", "is")


	-- --@brief	获取宠物装备信息（PET_PetGetEquipInfoOK = 34）
	-- self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetGetEquipInfoOK, "ProtocolProcessorScenePets:parse_PET_PetGetEquipInfoOK", "itvivivsvivivsvtvi")
	--@brief	穿戴或卸下宠物装备（PET_PetWearORUnEquipOK = 36）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetWearORUnEquipOK, "ProtocolProcessorScenePets:parse_PET_PetWearORUnEquipOK", "itb")
	--@brief	宠物装备提升（升级）（PET_PetUpEquipLvOK = 38）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipLvOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipLvOK", "ii")
	--@brief	宠物装备提升(星级)（PET_PetUpEquipStarOK = 39）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipStarOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipStarOK", "iiib")
	--@brief	宠物装备提升（升品/圣光）（PET_PetUpEquipHolyLightOK = 40）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipHolyLightOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipHolyLightOK", "iiii")
	--@brief	宠物装备回收（PET_PetEquipRecycleOk = 42）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipRecycleOk, "ProtocolProcessorScenePets:parse_PET_PetEquipRecycleOk", "")
	--@brief	宠物装备镶嵌宝石（PET_PetEquipMosaicOK = 44）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipMosaicOK, "ProtocolProcessorScenePets:parse_PET_PetEquipMosaicOK", "ii")
	--@brief	宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaicOK = 46）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaicOK, "ProtocolProcessorScenePets:parse_PET_PetEquipUnMosaicOK", "ii")
	--@brief	宠物装备继承（PET_PetEquipExtendsOK = 48）
	self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipExtendsOK, "ProtocolProcessorScenePets:parse_PET_PetEquipExtendsOK", "ii")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorScenePets:unregAll()
	self:clearReg()
	self.m_tPlayerPetInfoObservers = nil
end


function ProtocolProcessorScenePets:regAll2()
    --@brief    宠物装备提升（等级、升星、升品）（PET_PetUpEquip = 37）错误处理(S->C)
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquip, "ProtocolProcessorScenePets:send_PET_PetUpEquip_ErrorProcess", "is")
    --@brief    宠物装备镶嵌宝石（PET_PetEquipMosaic = 43）错误处理(S->C)
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipMosaic, "ProtocolProcessorScenePets:send_PET_PetEquipMosaic_ErrorProcess", "is")
    --@brief    宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaic = 45）错误处理(S->C)
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaic, "ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic_ErrorProcess", "is")
    --@brief    宠物装备提升（升级）（PET_PetUpEquipLvOK = 38）
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipLvOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipLvOK", "ii")
    --@brief    宠物装备提升(星级)（PET_PetUpEquipStarOK = 39）
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipStarOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipStarOK", "iiib")
    --@brief    宠物装备提升（升品/圣光）（PET_PetUpEquipHolyLightOK = 40）
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetUpEquipHolyLightOK, "ProtocolProcessorScenePets:parse_PET_PetUpEquipHolyLightOK", "iiii")
    --@brief    宠物装备镶嵌宝石（PET_PetEquipMosaicOK = 44）
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipMosaicOK, "ProtocolProcessorScenePets:parse_PET_PetEquipMosaicOK", "ii")
    --@brief    宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaicOK = 46）
    ProtocolProcessorScenePets:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaicOK, "ProtocolProcessorScenePets:parse_PET_PetEquipUnMosaicOK", "ii")
end

function ProtocolProcessorScenePets:unregAll2()

end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------

--@brief	获取所有宠物列表（PET_GetAllPetList = 1）
function ProtocolProcessorScenePets:send_PET_GetAllPetList( )
	WZLog("send_PET_GetAllPetList")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetAllPetList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物免费抽取（PET_Rebirth = 14）
function ProtocolProcessorScenePets:send_PET_GetFreeTime( )
	WZLog("send_PET_GetFreeTime")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetFreeTime)
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物出战（PET_ChangeState = 5）		
function ProtocolProcessorScenePets:send_PET_ChangeState(playerPetId )
	WZLog("send_PET_ChangeState")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_ChangeState )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 宠物id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物抽奖（PET_Lottery = 3）		
function ProtocolProcessorScenePets:send_PET_Lottery(lotteryType )
	WZLog("send_PET_Lottery")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_Lottery )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( lotteryType )	-- "1、宠物碎片。
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物升级（PET_Upgrade = 7）				
--@param    playerPetId : 需要升级的宠物id
--@param    playerPetIdArr : 升级时吃掉的宠物
--@param    num : 每个宠物数量(经验可以叠加)
function ProtocolProcessorScenePets:send_PET_Upgrade(playerPetId,playerPetIdArr,num )
	WZLog("send_PET_Upgrade ",playerPetId,playerPetIdArr) 
	local sender = Protocol:getSender(Protocol.MAIN_PET,Protocol.PET_Upgrade)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 宠物id
	sender:writeInts( playerPetIdArr )	-- 吸收玩家宠物
	sender:writeInts( num )	-- 数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物进阶（PET_Advanced = 8）						
function ProtocolProcessorScenePets:send_PET_Advanced(playerPetId,playerPetIdArr )
	WZLog("send_PET_Advanced = ",playerPetId)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_Advanced )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 宠物id
	sender:writeInts( playerPetIdArr )	-- 吸收玩家宠物
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物重生（PET_Rebirth = 9）								
function ProtocolProcessorScenePets:send_PET_Rebirth(playerPetId )
	WZLog("send_PET_Rebirth = ",playerPetId)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_Rebirth )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 宠物id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物洗炼（PET_ResetSkill = 10）
function ProtocolProcessorScenePets:send_PET_ResetSkill(playerPetId, lock ,washLevelGrid)
	WZLog("send_PET_ResetSkill = ",lock)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_ResetSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 玩家宠物id
	sender:writeInts( lock )	-- 锁定宠物技能id
	sender:writeInts( washLevelGrid )	-- 锁定宠物技能id
	SendProtocol(sender,false) --true:showLoading
end



--@brief	洗练宠物资质（WashPetGift = 24）
function ProtocolProcessorScenePets:send_WashPetGift(petId)
	WZLog("ProtocolProcessorScenePets:send_WashPetGift")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.WashPetGift)
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( petId )	-- 玩家宠物id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物回收（PET_RecyclePet = 26）
function ProtocolProcessorScenePets:send_PET_RecyclePet(itemId, itemNum )
	WZLog("send_PET_RecyclePet")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_RecyclePet )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( itemId )	-- 回收物品ID
	sender:writeInts( itemNum )	-- 物品数量
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物幻化（PET_ChangePetSkin = 28）
function ProtocolProcessorScenePets:send_PET_ChangePetSkin(playerPetId, targetItemId)
	WZLog("send_PET_ChangePetSkin")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_ChangePetSkin)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 玩家宠物唯一id
	sender:writeInt( targetItemId )	-- 幻型目标物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取宠物能幻化的物品列表（PET_GetPetSkinList = 30）
function ProtocolProcessorScenePets:send_PET_GetPetSkinList(playerPetId)
	WZLog("send_PET_GetPetSkinList")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetPetSkinList)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 玩家宠物唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物技能转移（PET_PetSkillChange = 32）
function ProtocolProcessorScenePets:send_PET_PetSkillChange(playerPetId, targetPetId)
	WZLog("send_PET_PetSkillChange")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetSkillChange)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerPetId )	-- 玩家宠物唯一id
	sender:writeInt( targetPetId )	-- 玩家宠物唯一id
	SendProtocol(sender,false) --true:showLoading
end


-- --@brief	获取宠物装备信息（PET_PetGetEquipInfo = 33）
-- function ProtocolProcessorScenePets:send_PET_PetGetEquipInfo()
-- 	WZLog("send_PET_PetGetEquipInfo")
-- 	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetGetEquipInfo )
-- 	if sender==nil then WZLog("sender == nil") return end

-- 	SendProtocol(sender,false) --true:showLoading
-- end

--@brief	穿戴或卸下宠物装备（PET_PetWearORUnEquip = 35）
function ProtocolProcessorScenePets:send_PET_PetWearORUnEquip(playerItemId, schemeId)
	WZLog("send_PET_PetWearORUnEquip",playerItemId, schemeId)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetWearORUnEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 宠物装备唯一id
	sender:writeByte( schemeId )	-- 宠物装备方案id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备提升（等级、升星、升品）（PET_PetUpEquip = 37）
function ProtocolProcessorScenePets:send_PET_PetUpEquip(uId, upType, consume, num, costPlayerItemId)
	costPlayerItemId = costPlayerItemId or {}
	WZLog("send_PET_PetUpEquip", uId, upType, tostring(consume), num, Serialize(costPlayerItemId))

	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetUpEquip )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(uId)	-- 宠物装备唯一id
	sender:writeByte(upType)	-- 升级类型 1: 升等级,2：升星,3：升品
	sender:writeBoolean(consume)	-- 是否自选消耗物品
	sender:writeInt(num)	-- 强化次数
	sender:writeInts( TableToIntVector(costPlayerItemId) )	-- 额外自选消耗-玩家物品唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备回收（PET_PetEquipRecycle = 41）
function ProtocolProcessorScenePets:send_PET_PetEquipRecycle(playerItemId)
	WZLog("send_PET_PetEquipRecycle")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetEquipRecycle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(playerItemId)	-- 宠物装备唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备镶嵌宝石（PET_PetEquipMosaic = 43）
function ProtocolProcessorScenePets:send_PET_PetEquipMosaic(playerItemId, itemStoneId)
	WZLog("send_PET_PetEquipMosaic")
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetEquipMosaic )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 宠物装备唯一id
	sender:writeInt(itemStoneId)	-- 宝石唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaic = 45）
function ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic(playerItemId, itemStoneId)
	WZLog("send_PET_PetEquipUnMosaic", playerItemId, itemStoneId)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaic )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 宠物装备唯一id
	sender:writeInt(itemStoneId)	-- 宝石唯一id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	宠物装备继承（PET_PetEquipExtends = 47）
function ProtocolProcessorScenePets:send_PET_PetEquipExtends(playerItemId, targetItem)
	WZLog("send_PET_PetEquipExtends", playerItemId, targetItem)
	local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_PetEquipExtends )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 被继承：宠物装备唯一id
	sender:writeInt(targetItem)	-- 继承：宠物装备唯一id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取所有宠物列表（PET_GetAllPetListOk = 2）
function ProtocolProcessorScenePets:parse_PET_GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	-- itemId : 宠物itemID
	-- name : 名称
	-- icon : 宠物图标
	-- animation : 宠物动画
	-- advancedLevel : 进阶级别
	-- upgradeLevel : 级别
	-- property : 宠物属性,json格式{"1":200, "2":500}
	-- giftSkill : 天赋技能id
	-- commonSkill1 : 1阶技能id
	-- commonSkill2 : 2阶技能id
	-- isInUsed : 是否出战
	-- playerPetId : 玩家宠物id
	-- num :宠物数量
	-- petExp : 宠物经验
	-- fighting : 宠物战斗力
	-- petSkinItemId : 宠物幻化物品ID，没有幻化时为0
	-- fetterStatus : 0|0|0|0  单个宠物用|分割(羁绊状态)
	WZLog("ProtocolProcessorScenePets:parse_PET_GetAllPetList OK")
	if WndPets.m_root then
		WndPets:GetAllPetListOk(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
	end

	if WndAscending.m_root then
		WndAscending:GetAllPetListOk(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
	end

	if CellExchangePanel.m_current and CellExchangePanel.m_current.m_root then
		CellExchangePanel.m_current:GetAllPetListOk(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
	end
end

--@brief	宠物出战（PET_ChangeState = 5）		
function ProtocolProcessorScenePets:parse_PET_ChangeStateOK(playerPetId, isInUsed)
	-- playerPetId : 玩家宠物id
	-- isInUsed : 宠物状态
    WZLog("ProtocolProcessorScenePets:parse_PET_ChangeStateOK:",playerPetId,isInUsed)
    local t_petId = VectorToTable(playerPetId)
    local t_InUsed = VectorToTable(isInUsed)
    WndPets:setWarState(t_petId, t_InUsed)
	CacheCenter:updatePlayerPetInfo(t_petId,"isInUsed",t_InUsed)
end

--@brief	宠物免费抽取成功（PET_DeletePet = 15）
function ProtocolProcessorScenePets:parse_PET_GetFreeTimeOK(type, time)
	-- type : 抽奖类型
	-- time : 抽奖时间
	WZLog("ProtocolProcessorScenePets:parse_PET_GetFreeTimeOK")
    WndPets:getTime(VectorToTable(type), VectorToTable(time))
	WndPetRaffle:getTime(VectorToTable(type), VectorToTable(time))
end


--@brief	宠物成功信息（PET_PetInfoOK = 4）			
function ProtocolProcessorScenePets:parse_PET_PetInfoOK(itemId, name, icon,animation,advancedLevel,upgradeLevel, property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId, originType,num,petExp,operType,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	-- itemId : 宠物itemID
	-- name : 名称
	-- icon : 宠物图标
	-- animation : 宠物动画,json格式{"1":200, "2":500}
	-- petLevel : 级别
	-- property : 宠物属性
	-- giftSkill : 天赋技能id
	-- commonSkill1 : 1阶技能id
	-- commonSkill2 : 2阶技能id
	-- isInUsed : 是否出战
	-- playerPetId : 玩家宠物id
	-- originType : 1、更新。2、新增
	-- num :宠物数量
	-- petExp : 宠物经验
	-- operType : 1(抽奖) 2(宠物升级) 3(宠物进阶) 4(宠物重生) 5(GM工具) 6(任务系统) 7(幻型) 8(转移) 8(宠物装备变化)
	-- fighting : 玩家宠物战斗力
	-- petSkinItemId : 宠物幻化物品ID，没有幻化时为0
	WZLog("ProtocolProcessorScenePets:parse_PET_PetInfoOK")
	-- WZLog("ProtocolProcessorScenePets:parse_PET_PetInfoOK",
	-- 	"\n itemId = ",Serialize(VectorToTable(itemId)),
	-- 	"\n name = ",Serialize(VectorToTable(name)),
	-- 	"\n icon = ",Serialize(VectorToTable(icon)),
	-- 	"\n animation = ",Serialize(VectorToTable(animation)),
	-- 	"\n advancedLevel = ",Serialize(VectorToTable(advancedLevel)),
	-- 	"\n upgradeLevel = ",Serialize(VectorToTable(upgradeLevel)),
	-- 	"\n property = ",Serialize(VectorToTable(property)),
	-- 	"\n giftSkill = ",Serialize(VectorToTable(giftSkill)),
	-- 	"\n commonSkill1 = ",Serialize(VectorToTable(commonSkill1)),
	-- 	"\n commonSkill2 = ",Serialize(VectorToTable(commonSkill2)),
	-- 	"\n isInUsed = ",Serialize(VectorToTable(isInUsed)),
	-- 	"\n playerPetId = ",Serialize(VectorToTable(playerPetId)),
	-- 	"\n originType = ",Serialize(VectorToTable(originType)),
	-- 	"\n num = ",Serialize(VectorToTable(num)),
	-- 	"\n petExp = ",Serialize(VectorToTable(petExp)),
	-- 	"\n operType = ",Serialize(VectorToTable(operType)),
	-- 	"\n fighting = ",Serialize(VectorToTable(fighting)),
	-- 	"\n birthSkill = ",Serialize(VectorToTable(birthSkill)),
	-- 	"\n skill = ",Serialize(VectorToTable(skill)),
	-- 	"\n petSkinItemId = ",Serialize(VectorToTable(petSkinItemId)),
	-- 	"\n fetterStatus = ",Serialize(VectorToTable(fetterStatus))
	-- 	)
	
    if operType == 1 then
    	local tabOriginTypes = VectorToTable(originType)
    	itemId = VectorToTable(itemId)
    	name = VectorToTable(name)
    	icon = VectorToTable(icon)
    	animation = VectorToTable(animation)
    	advancedLevel = VectorToTable(advancedLevel)
    	upgradeLevel = VectorToTable(upgradeLevel)
    	property = VectorToTable(property)
    	giftSkill = VectorToTable(giftSkill)
    	commonSkill1 = VectorToTable(commonSkill1)
    	commonskill2 = VectorToTable(commonSkill2)
    	isInUsed = VectorToTable(isInUsed)
    	playerPetId =VectorToTable(playerPetId)
    	num = VectorToTable(num)
    	petExp = VectorToTable(petExp)
    	fighting = VectorToTable(fighting)
    	birthSkill = VectorToTable(birthSkill)
    	skill = VectorToTable(skill)
    	petSkinItemId = VectorToTable(petSkinItemId)
    	fetterStatus = VectorToTable(fetterStatus)
    	for i=1,#tabOriginTypes do
            if tabOriginTypes[i] == 2 then
                CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill, petSkinItemId[i], fetterStatus[i])
            else
                CacheCenter:setPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill, petSkinItemId[i], fetterStatus[i])
        end
    end
    elseif operType == 2 then
    	CacheCenter:updatePlayerPetInfoAll(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
        CacheCenter:_updatePlayerPetInfoData()
    elseif operType ==3  then
        CacheCenter:updatePlayerPetInfoAll(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
        CacheCenter:_updatePlayerPetInfoData()
    elseif operType ==4 or operType == 5 then	
    	local tabOriginTypes = VectorToTable(originType)
    	itemId = VectorToTable(itemId)
    	name = VectorToTable(name)
    	icon = VectorToTable(icon)
    	animation = VectorToTable(animation)
    	advancedLevel = VectorToTable(advancedLevel)
    	upgradeLevel = VectorToTable(upgradeLevel)
    	property = VectorToTable(property)
    	giftSkill = VectorToTable(giftSkill)
    	commonSkill1 = VectorToTable(commonSkill1)
    	commonskill2 = VectorToTable(commonSkill2)
    	isInUsed = VectorToTable(isInUsed)
    	playerPetId =VectorToTable(playerPetId)
    	num = VectorToTable(num)
    	petExp = VectorToTable(petExp)
    	fighting = VectorToTable(fighting)
    	birthSkill = VectorToTable(birthSkill)
    	skill = VectorToTable(skill)
    	petSkinItemId = VectorToTable(petSkinItemId)
    	fetterStatus = VectorToTable(fetterStatus)
    	for i=1,#tabOriginTypes do
            if tabOriginTypes[i] == 2 then
            	WZLog("ssssss:CacheCenter:addPlayerPetInfo")
                CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
            else
            	WZLog("ssssss:CacheCenter:setPlayerPetInfo")
                CacheCenter:setPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
        	end
    	end
    	CacheCenter:_updatePlayerPetInfoData()
    elseif operType ==6 then
    elseif operType == 7 or operType == 8 or operType == 9 then
    	local tabOriginTypes = VectorToTable(originType)
    	itemId = VectorToTable(itemId)
    	name = VectorToTable(name)
    	icon = VectorToTable(icon)
    	animation = VectorToTable(animation)
    	advancedLevel = VectorToTable(advancedLevel)
    	upgradeLevel = VectorToTable(upgradeLevel)
    	property = VectorToTable(property)
    	giftSkill = VectorToTable(giftSkill)
    	commonSkill1 = VectorToTable(commonSkill1)
    	commonskill2 = VectorToTable(commonSkill2)
    	isInUsed = VectorToTable(isInUsed)
    	playerPetId =VectorToTable(playerPetId)
    	num = VectorToTable(num)
    	petExp = VectorToTable(petExp)
    	fighting = VectorToTable(fighting)
    	birthSkill = VectorToTable(birthSkill)
    	skill = VectorToTable(skill)
    	petSkinItemId = VectorToTable(petSkinItemId)
    	fetterStatus = VectorToTable(fetterStatus)
    	for i=1,#tabOriginTypes do
            if tabOriginTypes[i] == 1 then
                CacheCenter:setPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
        	end
    	end
    	CacheCenter:_updatePlayerPetInfoData()
    	if operType == 8 then 
    		WndPetSkillTransfer:transferSuccess()
    	end
    end
end

--@brief	洗炼成功（PET_ResetSkillOK = 11）
function ProtocolProcessorScenePets:parse_PET_ResetSkillOK(result,playerPetId, skill)
	-- playerPetId : 玩家宠物itemID
	-- commonSkill1 : 第一个技能id, 如果上锁 返回0
	-- commonskill2 : 第二个技能id, 如果上锁 返回0
	WZLog("ProtocolProcessorScenePets:parse_PET_ResetSkillOK")
	CacheCenter:setPlayerPetInfoBySkillId(playerPetId,skill)
  	CacheCenter:_updatePlayerPetInfoData()
    WndPetsSkill.m_bISAlter = false
    --WndPetsSkill:_changeSkillOk(playerPetId,commonSkill1,commonskill2)
end


--@brief	删除宠物（PET_DeletePet = 12）
function ProtocolProcessorScenePets:parse_PET_DeletePet(playerPetId)
	-- playerPetId : 玩家宠物id
	WZLog("ProtocolProcessorScenePets:parse_PET_DeletePet")
	CacheCenter:removePets(VectorToTable(playerPetId))
	--CacheCenter:_updatePlayerPetInfoData()
end

--@brief	宠物抽奖成功（PET_LotteryOK = 13）			
function ProtocolProcessorScenePets:parse_PET_LotteryOK(itemId,giftSkill)
	-- itemId : 宠物itemID
	WZLog("ProtocolProcessorScenePets:parse_PET_LotteryOK")
    WindowManager:removeTeachShelterLayer()
    WndPetRaffle:rafflePetsData(VectorToTable(itemId),VectorToTable(giftSkill))
end

--@brief	洗练宠物资质成功（PET_WashPetGiftOk = 25）		
function ProtocolProcessorScenePets:parse_PET_WashPetGiftOk(petId,giftSkill)
	-- itemId : 宠物itemID
	WZLog("ProtocolProcessorScenePets:parse_PET_WashPetGiftOk",petId,giftSkill)
	CacheCenter:updatePlayerPetInfo({petId},"giftSkill",{giftSkill})
	WndPets:washGiftOk(giftSkill)
    WndPetGift:washGiftOk(giftSkill)
end

--@brief	宠物回收成功（PET_RecyclePetOk = 27）		
function ProtocolProcessorScenePets:parse_PET_RecyclePetOk(items,nums)
	-- itemId : 宠物itemID
	WZLog("ProtocolProcessorScenePets:parse_PET_RecyclePetOk",items,nums)
	if type(VectorToTable(items)) == "table" and #VectorToTable(items) > 0 then
		WndRewardShow:showById(VectorToTable(items),VectorToTable(nums))
	end
	if WndPetRecover.m_root ~= nil then
		WndPetRecover:recycleSucc()
	end
end

--@brief	宠物幻化（PET_ChangePetSkinOk = 29）	
function ProtocolProcessorScenePets:parse_PET_ChangePetSkinOk(playerPetId, targetItemId)
	-- playerPetId : 玩家宠物唯一id
	-- targetItemId : 宠物itemID
	WZLog("ProtocolProcessorScenePets:parse_PET_ChangePetSkinOk", playerPetId, targetItemId)
	
	WndPetPhantom:phantomSuccess(playerPetId, targetItemId)
end

--@brief	获取宠物能幻化的物品列表（PET_GetPetSkinListOk = 31）	
function ProtocolProcessorScenePets:parse_PET_GetPetSkinListOk(petItemId)
	-- petItemId : 宠物itemID
	WZLog("ProtocolProcessorScenePets:parse_PET_GetPetSkinListOk")
	
	WndPetPhantom:setPetsData(VectorToTable(petItemId))
end


-- --@brief	获取宠物装备信息（PET_PetGetEquipInfoOK = 34）
-- function ProtocolProcessorScenePets:parse_PET_PetGetEquipInfoOK(petId, useScheme, itemId, uId, randAttr, strongLevel, starLevel, stone, isWear, starExp)
-- 	-- petId : 上阵的宠物
-- 	-- useScheme : 正在穿戴方案
-- 	-- itemId : 物品道具id
-- 	-- uId : 宠物装备唯一id
-- 	-- randAttr : 随机属性 格式：{属性id,属性值}
-- 	-- strongLevel : 宠物装备等级
-- 	-- starLevel : 宠物装备星级
-- 	-- stone : 镶嵌的宝石 格式：{共鸣宝石：物品唯一id,共鸣宝石经验：经验值,...} {gongmingStone:1,gongmingGemExp:0,...}
-- 	-- isWear : 是否已穿戴 0: 未穿戴 1：已穿戴
-- 	-- starExp : 升星保底次数
-- 	WZLog("ProtocolProcessorScenePets:parse_PET_PetGetEquipInfoOK", 
-- 		"\npetId =",Serialize(VectorToTable(petId)), 
-- 		"\nuseScheme =",Serialize(VectorToTable(useScheme)), 
-- 		"\nitemId =",Serialize(VectorToTable(itemId)), 
-- 		"\nuId =",Serialize(VectorToTable(uId)), 
-- 		"\nrandAttr =",Serialize(VectorToTable(randAttr)), 
-- 		"\nstrongLevel =",Serialize(VectorToTable(strongLevel)), 
-- 		"\nstarLevel =",Serialize(VectorToTable(starLevel)), 
-- 		"\nstone =",Serialize(VectorToTable(stone)), 
-- 		"\nisWear =",Serialize(VectorToTable(isWear)), 
-- 		"\nstarExp =",Serialize(VectorToTable(starExp)))
-- end

--@brief	穿戴或卸下宠物装备（PET_PetWearORUnEquipOK = 36）
function ProtocolProcessorScenePets:parse_PET_PetWearORUnEquipOK(playerItemId, schemeId, isUp)
	-- playerItemId : 宠物装备唯一id
	-- schemeId : 宠物装备方案id
	-- isUp : 穿戴操作：true: 穿戴 ： false: 卸下
	WZLog("ProtocolProcessorScenePets:parse_PET_PetWearORUnEquipOK", playerItemId, schemeId, isUp)
	MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55)
end

--@brief	宠物装备提升（升级）（PET_PetUpEquipLvOK = 38）
function ProtocolProcessorScenePets:parse_PET_PetUpEquipLvOK(playerItemId, strongLevel)
	-- playerItemId : 宠物装备唯一id
	-- strongLevel : 等级
	WZLog("ProtocolProcessorScenePets:parse_PET_PetUpEquipLvOK", playerItemId, strongLevel)
	WndIntensifyStrengthen:onIntensifyResult()
end

--@brief	宠物装备提升(星级)（PET_PetUpEquipStarOK = 39）
function ProtocolProcessorScenePets:parse_PET_PetUpEquipStarOK(playerItemId, starLevel, starExp, status)
	-- playerItemId : 宠物装备唯一id
	-- starLevel : 星级
	-- starExp : 星级保底次数
	-- status : 升星状态：true: 成功 false: 失败
	WZLog("ProtocolProcessorScenePets:parse_PET_PetUpEquipStarOK", playerItemId, starLevel, starExp, status)
	WndImproveStrengthen:onImproveSuccess2(playerItemId, starLevel, starExp, status)
end

--@brief	宠物装备提升（升品/圣光）（PET_PetUpEquipHolyLightOK = 40）
function ProtocolProcessorScenePets:parse_PET_PetUpEquipHolyLightOK(playerItemId, itemId, strongLevel, starLevel)
	-- playerItemId : 宠物装备唯一id
	-- itemId : 物品id
	-- strongLevel : 等级
	-- starLevel : 星级
	WZLog("ProtocolProcessorScenePets:parse_PET_PetUpEquipHolyLightOK")
	WndAscending:onAscendFinish()
end

--@brief	宠物装备回收（PET_PetEquipRecycleOk = 42）
function ProtocolProcessorScenePets:parse_PET_PetEquipRecycleOk()
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipRecycleOk")
	if WndPetRecover.m_root ~= nil then
		WndPetRecover:recycleSucc()
	end
end

--@brief	宠物装备镶嵌宝石（PET_PetEquipMosaicOK = 44）
function ProtocolProcessorScenePets:parse_PET_PetEquipMosaicOK(playerItemId, itemStoneId)
	-- playerItemId : 宠物装备唯一id
	-- itemStoneId : 宝石唯一id
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipMosaicOK")
	WndGemMountingStrengthen:onGemMountingSuccess()
end

--@brief	宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaicOK = 46）
function ProtocolProcessorScenePets:parse_PET_PetEquipUnMosaicOK(playerItemId, itemStoneId)
	-- playerItemId : 宠物装备唯一id
	-- itemStoneId : 宝石唯一id
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipUnMosaicOK", playerItemId, itemStoneId)
	WndGemMountingStrengthen:onRemoveSuccess()
end

--@brief	宠物装备继承（PET_PetEquipExtendsOK = 48）
function ProtocolProcessorScenePets:parse_PET_PetEquipExtendsOK(playerItem, targetPlayerItem)
	-- playerItem : 继承装备id
	-- targetPlayerItem : 继承目标装备id
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipExtendsOK",playerItem, targetPlayerItem)

	WndPetsEquipment:getPetEquipExtendsOK()
end


-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	获取所有宠物列表（PET_GetAllPetList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_GetAllPetList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_GetAllPetList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetAllPetList, nflag, sMessage)
end

--@brief	宠物出战（PET_ChangeState = 5）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_ChangeState_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_ChangeState_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_ChangeState, nflag, sMessage)
	WndPetsProperty:changePetStatsError()
end

--@brief	宠物抽奖（PET_Lottery = 3）		错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_Lottery_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_Lottery_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_Lottery, nflag, sMessage)
	WndPetRaffle:raffleError()
	WndPetRaffle:onReturnClick()
end

--@brief	宠物升级（PET_Upgrade = 7）				错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_Upgrade_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_Upgrade_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_Upgrade, nflag, sMessage)
	WndPetsUpgrade:updateError()
end


--@brief	宠物进阶（PET_Advanced = 8）						错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_Advanced_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_Advanced_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_Advanced, nflag, sMessage)
	WndPetsEvolution:advancedError(sMessage)
end

--@brief	获取宠物商店（PET_Rebirth								错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_Rebirth_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_Rebirth_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_Rebirth, nflag, sMessage)
	WndPetsRebirth:rebornError()
end

--@brief	宠物洗炼（PET_ResetSkill = 10）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_ResetSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_ResetSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_ResetSkill, nflag, sMessage)
	WndPetsSkill:changeSkillError()
end

--@brief	获取宠物商店（PET_GetPetStore = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_GetPetStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_GetPetStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetPetStore, nflag, sMessage)
	WndPetExchange:closeLoadingBox()
end

--@brief	购买宠物（PET_PurchasePet = 20））错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PurchasePet_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_PurchasePet_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PurchasePet, nflag, sMessage)
	WndPetExchange:closeLoadingBox()
end

--@brief	刷新宠物列表（PET_RefreshStore = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_RefreshStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_RefreshStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_RefreshStore, nflag, sMessage)
	WndPetExchange:closeLoadingBox()
end

--@brief	洗练宠物资质（WashPetGift = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_WashPetGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_WashPetGift_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.WashPetGift, nflag, sMessage)
	WndPetGift:closeLoadingBox()
end

--@brief	宠物回收（PET_RecyclePet = 26）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_RecyclePet_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_RecyclePet_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_RecyclePet, nflag, sMessage)
	WndPetRecover:closeLoadingBox()
end

--@brief	获取宠物能幻化的物品列表（PET_GetPetSkinList = 30）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_GetPetSkinList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_GetPetSkinList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetPetSkinList, nflag, sMessage)
end

--@brief	宠物技能转移（PET_PetSkillChange = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetSkillChange_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:send_PET_PetSkillChange_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetSkillChange, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------

--坐骑灵石协议
function ProtocolProcessorScenePets:regAll1()
	--@brief	获取灵石信息（MOUNTS_GetSpriteStoneDataOK = 11）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetSpriteStoneDataOK, "ProtocolProcessorScenePets:parse_MOUNTS_GetSpriteStoneDataOK", "vivivs")
	--@brief	装备主石（MOUNTS_EquipMasterStoneOK = 13）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipMasterStoneOK, "ProtocolProcessorScenePets:parse_MOUNTS_EquipMasterStoneOK", "iivivivit")
	--@brief	装备副石（MOUNTS_EquipSlaveStoneOK = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipSlaveStoneOK, "ProtocolProcessorScenePets:parse_MOUNTS_EquipSlaveStoneOK", "iiii")
	--@brief	灵石升级（MOUNTS_StoneUpgradeOK = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_StoneUpgradeOK, "ProtocolProcessorScenePets:parse_MOUNTS_StoneUpgradeOK", "iiivivii")
	--@brief	装备主石（MOUNTS_EquipMasterStone = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipMasterStone, "ProtocolProcessorScenePets:send_MOUNTS_EquipMasterStone_ErrorProcess", "is")
	--@brief	装备副石（MOUNTS_EquipSlaveStone = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipSlaveStone, "ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone_ErrorProcess", "is")
end
--@brief	获取灵石信息（MOUNTS_GetSpriteStoneData = 10）
function ProtocolProcessorScenePets:send_MOUNTS_GetSpriteStoneData()
	WZLog("send_MOUNTS_GetSpriteStoneData")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_GetSpriteStoneData )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取灵石信息（MOUNTS_GetSpriteStoneDataOK = 11）
function ProtocolProcessorScenePets:parse_MOUNTS_GetSpriteStoneDataOK(masterSlot, masterItemId, slaveStoneData)
	-- masterSlot : 
	-- masterItemId : 
	-- slaveStoneData : [{"slot":1, "playerItemId":1,"itemId":111}]
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_GetSpriteStoneDataOK")
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_EquipSlaveStoneInfo,VectorToTable(masterSlot),VectorToTable(masterItemId),VectorToTable(slaveStoneData))
end
--@brief	装备主石（MOUNTS_EquipMasterStone = 12）
function ProtocolProcessorScenePets:send_MOUNTS_EquipMasterStone(playerItemId, slot, onOff)
	WZLog("send_MOUNTS_EquipMasterStone")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipMasterStone )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 主石物品id
	sender:writeInt(slot)	-- 主石槽位
	sender:writeByte(onOff)	-- 1、镶嵌，2、拆卸
	SendProtocol(sender,false) --true:showLoading
end
--@brief	装备主石（MOUNTS_EquipMasterStoneOK = 13）
function ProtocolProcessorScenePets:parse_MOUNTS_EquipMasterStoneOK(playerItemId, slot, slaveSlot, slaveItemId, propertyType, onOff)
	-- playerItemId : 主石物品id
	-- slot : 主石槽位
	-- slaveSlot : 副石槽位
	-- slaveItemId : 副石id
	-- propertyType : 属性类型
	-- onOff : 1、镶嵌，2、拆卸
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_EquipMasterStoneOK")
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_EquipMasterStoneResult, playerItemId, slot, VectorToTable(slaveSlot),
		VectorToTable(slaveItemId),VectorToTable(propertyType), onOff)
end

--@brief	装备副石（MOUNTS_EquipSlaveStone = 14）
function ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone(slaveItemId, slaveSlot, masterSlot, onOff)
	WZLog("send_MOUNTS_EquipSlaveStone")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipSlaveStone )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(slaveItemId)	-- 副石物品id
	sender:writeInt(slaveSlot)	-- 副石槽位
	sender:writeInt(masterSlot)	-- 主石槽位
	sender:writeInt(onOff)	-- 1、镶嵌，2、卸载
	SendProtocol(sender,false) --true:showLoading
end
--@brief	装备副石（MOUNTS_EquipSlaveStoneOK = 15）
function ProtocolProcessorScenePets:parse_MOUNTS_EquipSlaveStoneOK(slaveItemId, slaveSlot, masterItemId, onOff)
	-- slaveItemId : 副石物品id
	-- slaveSlot : 副石槽位
	-- masterItemId : 主石物品id
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_EquipSlaveStoneOK")
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_StoneSourceAssResult, slaveItemId, slaveSlot, masterItemId, onOff)
end
--@brief	灵石升级（MOUNTS_StoneUpgrade = 16）
function ProtocolProcessorScenePets:send_MOUNTS_StoneUpgrade(playerItemId, consumeItemId, consumeNum)
	WZLog("send_MOUNTS_StoneUpgrade")
	local sender = Protocol:getSender( Protocol.MAIN_MOUNTS, Protocol.MOUNTS_StoneUpgrade )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerItemId)	-- 灵石物品id
	sender:writeInts(consumeItemId)	-- 吞噬物品id
	sender:writeInts(consumeNum)	-- 吞噬物品数量
	SendProtocol(sender,false) --true:showLoading
end
--@brief	灵石升级（MOUNTS_StoneUpgradeOK = 17）
function ProtocolProcessorScenePets:parse_MOUNTS_StoneUpgradeOK(playerItemId, lv, exp, consumeItemId, consumeNum, effectConfig)
	-- playerItemId : 灵石物品id
	-- lv : 灵石等级，大于0表示升级了
	-- exp : 当前经验
	-- consumeItemId : 吞噬物品id
	-- consumeNum : 吞噬物品数量
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_StoneUpgradeOK")
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_StoneUpgradeResult, playerItemId, lv, exp, 
		VectorToTable(consumeItemId), VectorToTable(consumeNum),effectConfig)
end

--@brief	装备主石（MOUNTS_EquipMasterStone = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_MOUNTS_EquipMasterStone_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_EquipMasterStone_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipMasterStone, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end
--@brief	装备副石（MOUNTS_EquipSlaveStone = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_MOUNTS_EquipSlaveStone_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_MOUNTS_EquipSlaveStone_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MOUNTS, Protocol.MOUNTS_EquipSlaveStone, nflag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end

-- --@brief	获取宠物装备信息（PET_PetGetEquipInfo = 33）错误处理函数(S->C)
-- --@param	nFlag:标志位
-- --@param	sMessage:错误信息
-- --@note	在此对协议错误进行相应处理
-- function ProtocolProcessorScenePets:send_PET_PetGetEquipInfo_ErrorProcess(nFlag, sMessage)
-- 	WZLog("ProtocolProcessorScenePets:parse_PET_PetGetEquipInfo_ErrorProcess")
-- 	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetGetEquipInfo, nflag, sMessage)
-- end

--@brief	穿戴或卸下宠物装备（PET_PetWearORUnEquip = 35）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetWearORUnEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetWearORUnEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetWearORUnEquip, nflag, sMessage)
end

--@brief	宠物装备提升（等级、升星、升品）（PET_PetUpEquip = 37）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetUpEquip_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetUpEquip_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetUpEquip, nflag, sMessage)
end

--@brief	宠物装备回收（PET_PetEquipRecycle = 41）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetEquipRecycle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipRecycle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetEquipRecycle, nflag, sMessage)
end

--@brief	宠物装备镶嵌宝石（PET_PetEquipMosaic = 43）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetEquipMosaic_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipMosaic_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetEquipMosaic, nflag, sMessage)
end

--@brief	宠物装备卸下镶嵌宝石（PET_PetEquipUnMosaic = 45）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipUnMosaic_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetEquipUnMosaic, nflag, sMessage)
end

--@brief	宠物装备继承（PET_PetEquipExtends = 47）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorScenePets:send_PET_PetEquipExtends_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorScenePets:parse_PET_PetEquipExtends_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_PetEquipExtends, nflag, sMessage)
end
