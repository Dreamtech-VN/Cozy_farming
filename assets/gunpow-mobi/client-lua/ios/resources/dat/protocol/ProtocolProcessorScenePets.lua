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
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorScenePets:unregAll()
	self:clearReg()
	self.m_tPlayerPetInfoObservers = nil
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
	-- operType : 1(抽奖) 2(宠物升级) 3(宠物进阶) 4(宠物重生) 5(GM工具) 6(任务系统) 7(幻型)
	-- fighting : 玩家宠物战斗力
	-- petSkinItemId : 宠物幻化物品ID，没有幻化时为0
	WZLog("ProtocolProcessorScenePets:parse_PET_PetInfoOK")
	
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
    elseif operType == 7 then
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
-------------------------------------协议错误处理方法模块End--------------------------------------

