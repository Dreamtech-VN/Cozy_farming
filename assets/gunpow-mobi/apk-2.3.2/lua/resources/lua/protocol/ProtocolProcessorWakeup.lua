--ProtocolProcessorWakeup.lua
--@brief    觉醒相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     觉醒相关协议


ProtocolProcessorWakeup = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorWakeup:regAll()
    --@brief    获取觉醒信息（AWAKE_GetAwakeInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_GetAwakeInfo, "ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo_ErrorProcess", "is" )
    --@brief    魂晶培养（AWAKE_AwakeSoulTrain = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeSoulTrain, "ProtocolProcessorWakeup:send_AWAKE_AwakeSoulTrain_ErrorProcess", "is" )
    --@brief    觉醒（AWAKE_Awake = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_Awake, "ProtocolProcessorWakeup:send_AWAKE_Awake_ErrorProcess", "is" )
    --@brief    领取觉醒套装（AWAKE_DrawAwakeSuit = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_DrawAwakeSuit, "ProtocolProcessorWakeup:send_AWAKE_DrawAwakeSuit_ErrorProcess", "is" )
    --@brief    获取符文信息（RUNE_GetRuneInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo, "ProtocolProcessorWakeup:send_RUNE_GetRuneInfo_ErrorProcess", "is" )
    --@brief    获取所有宠物列表（PET_GetAllPetList = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetList, "ProtocolProcessorWakeup:send_PET_GetAllPetList_ErrorProcess", "is" )
    --@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, "ProtocolProcessorWakeup:send_PRAY_GetPrayMess_ErrorProcess", "is" )
    --@brief    萃取（AWAKE_Extract = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_Extract, "ProtocolProcessorWakeup:send_AWAKE_Extract_ErrorProcess", "is" )
    --@brief    升级天赋（AWAKE_UpTalent = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_UpTalent, "ProtocolProcessorWakeup:send_AWAKE_UpTalent_ErrorProcess", "is" )
    --@brief    重置天赋点（AWAKE_ResetTalentNum = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_ResetTalentNum, "ProtocolProcessorWakeup:send_AWAKE_ResetTalentNum_ErrorProcess", "is" )
    --@brief    觉醒进化（AWAKE_AwakeEvolve = 15）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeEvolve, "ProtocolProcessorWakeup:send_AWAKE_AwakeEvolve_ErrorProcess", "is" )

    --@brief    获取觉醒信息（AWAKE_GetAwakeInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_GetAwakeInfoOk, "ProtocolProcessorWakeup:parse_AWAKE_GetAwakeInfoOk", "vivsvtviviiitviii")
    --@brief    魂晶培养（AWAKE_AwakeSoulTrainOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeSoulTrainOk, "ProtocolProcessorWakeup:parse_AWAKE_AwakeSoulTrainOk", "iivivivivi")
    --@brief    觉醒（AWAKE_AwakeOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeOk, "ProtocolProcessorWakeup:parse_AWAKE_AwakeOk", "i")
    --@brief    领取（AWAKE_DrawAwakeSuitOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_DrawAwakeSuitOk, "ProtocolProcessorWakeup:parse_AWAKE_DrawAwakeSuitOk", "s")
    --@brief    获取符文信息（RUNE_GetRuneInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfoOk, "ProtocolProcessorWakeup:parse_RUNE_GetRuneInfoOk", "viviviiviviii")
    --@brief    获取所有宠物列表（PET_GetAllPetListOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetListOk, "ProtocolProcessorWakeup:parse_PET_GetAllPetListOk", "vivsvsvsvnvnvsvivivivbvivivivivivsvivs")
    --@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMessOk, "ProtocolProcessorWakeup:parse_PRAY_GetPrayMessOk", "vivivivivivivivii")
    --@brief    萃取（AWAKE_ExtractOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_ExtractOk, "ProtocolProcessorWakeup:parse_AWAKE_ExtractOk", "vivi")
    --@brief    升级天赋成功（AWAKE_UpTalentOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_UpTalentOk, "ProtocolProcessorWakeup:parse_AWAKE_UpTalentOk", "i")
    --@brief    重置天赋点（AWAKE_ResetTalentNumOk = 14）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_ResetTalentNumOk, "ProtocolProcessorWakeup:parse_AWAKE_ResetTalentNumOk", "ivii")
    --@brief    觉醒进化成功（AWAKE_AwakeEvolveOk = 16）
    self:regProtocolCallbackFunction( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeEvolveOk, "ProtocolProcessorWakeup:parse_AWAKE_AwakeEvolveOk", "i")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorWakeup:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取觉醒信息（AWAKE_GetAwakeInfo = 1）
function ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo( )
    WZLog("send_AWAKE_GetAwakeInfo")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_GetAwakeInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    魂晶培养（AWAKE_AwakeSoulTrain = 3）
function ProtocolProcessorWakeup:send_AWAKE_AwakeSoulTrain(costId, num )
    WZLog("send_AWAKE_AwakeSoulTrain")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeSoulTrain )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( costId )   -- 消耗魂晶id
    sender:writeInt( num )  -- 消耗数目
    SendProtocol(sender,false) --true:showLoading
end

--@brief    觉醒（AWAKE_Awake = 5）
function ProtocolProcessorWakeup:send_AWAKE_Awake(awakeId )
    WZLog("send_AWAKE_Awake")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_Awake )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( awakeId )  -- 觉醒id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取觉醒套装（AWAKE_DrawAwakeSuit = 7）
function ProtocolProcessorWakeup:send_AWAKE_DrawAwakeSuit( )
    WZLog("send_AWAKE_DrawAwakeSuit")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_DrawAwakeSuit )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取符文信息（RUNE_GetRuneInfo = 1）
function ProtocolProcessorWakeup:send_RUNE_GetRuneInfo()
    WZLog("send_RUNE_GetRuneInfo")
    local sender = Protocol:getSender(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取所有宠物列表（PET_GetAllPetList = 1）
function ProtocolProcessorWakeup:send_PET_GetAllPetList( )
    WZLog("send_PET_GetAllPetList")
    local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetAllPetList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取祈福信息（PRAY_GetPrayMess = 1）
function ProtocolProcessorWakeup:send_PRAY_GetPrayMess( )
    WZLog("send_PRAY_GetPrayMess")
    local sender = Protocol:getSender( Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    萃取（AWAKE_Extract = 9）
function ProtocolProcessorWakeup:send_AWAKE_Extract(extractType, uniqueId, costNum )
    WZLog("send_AWAKE_Extract")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_Extract )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( extractType ) -- 类型
    sender:writeInts( uniqueId )    -- 唯一id
    sender:writeInts( costNum ) -- 消耗的数目
    SendProtocol(sender,false) --true:showLoading
end

--@brief    升级天赋（AWAKE_UpTalent = 11）
function ProtocolProcessorWakeup:send_AWAKE_UpTalent(talentId )
    WZLog("send_AWAKE_UpTalent")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_UpTalent )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( talentId )  -- 天赋id（升级前）
    SendProtocol(sender,false) --true:showLoading
end

--@brief    重置天赋点（AWAKE_ResetTalentNum = 13）
function ProtocolProcessorWakeup:send_AWAKE_ResetTalentNum( )
    WZLog("send_AWAKE_ResetTalentNum")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_ResetTalentNum)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    觉醒进化（AWAKE_AwakeEvolve = 15）
function ProtocolProcessorWakeup:send_AWAKE_AwakeEvolve()
    WZLog("send_AWAKE_AwakeEvolve")
    local sender = Protocol:getSender( Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeEvolve)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
---------------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    获取觉醒信息（AWAKE_GetAwakeInfoOk = 2）
function ProtocolProcessorWakeup:parse_AWAKE_GetAwakeInfoOk(awakeConfigId, task, status, taskConfigId, progress, soulLevel, soulExp, suitDrawStatus, inbornId, awakeSkillId, evolveLevel)
    -- awakeConfigId : 配置表id
    -- task : 任务id(字符串,以逗号分隔)
    -- status : 状态(0:关闭;1:开放;3:可激活觉醒;2:已觉醒)
    -- taskConfigId : 任务-配置表id
    -- progress : 任务-进度
    -- soulLevel : 魂晶-等级
    -- soulExp : 魂晶-经验
    -- suitDrawStatus : 套装领取状态(0:未领取,1:已领取)
    -- inbornId : 天赋技能Id
    -- awakeSkillId : 觉醒之技Id
    -- evolveLevel : 进化等级
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_GetAwakeInfoOk", awakeSkillId)

    WndWakeup:setData(VectorToTable(awakeConfigId), VectorToTable(task), VectorToTable(status), VectorToTable(taskConfigId), VectorToTable(progress), soulLevel, soulExp, suitDrawStatus, VectorToTable(inbornId), awakeSkillId, evolveLevel)
end

--@brief    魂晶培养（AWAKE_AwakeSoulTrainOk = 4）
function ProtocolProcessorWakeup:parse_AWAKE_AwakeSoulTrainOk(currentLevel, currentExp, baseExp, multiple, preLevel, level)
    -- currentLevel : 当前等级
    -- currentExp : 当前经验
    -- baseExp : 获取基础经验
    -- multiple : 倍数
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_AwakeSoulTrainOk",Serialize(VectorToTable(baseExp)))

    WndWakeup:trainOK(currentLevel, currentExp, VectorToTable(baseExp), VectorToTable(multiple), VectorToTable(preLevel), VectorToTable(level))
end

--@brief    觉醒（AWAKE_AwakeOk = 6）
function ProtocolProcessorWakeup:parse_AWAKE_AwakeOk(awakeId)
    -- awakeId : 觉醒id
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_AwakeOk")

    WndWakeup:awakeOk(awakeId)
end

--@brief    领取（AWAKE_DrawAwakeSuitOk = 8）
function ProtocolProcessorWakeup:parse_AWAKE_DrawAwakeSuitOk(reward)
    -- reward : 奖励
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_DrawAwakeSuitOk")

    WndWakeup:receiveSkinOK()
end

--@brief    获取符文信息（RUNE_GetRuneInfoOk = 2）
function ProtocolProcessorWakeup:parse_RUNE_GetRuneInfoOk(placeIds, placeItemId, rpIds, runeLevel, itemIds, itemNums, resonateBuffState, resonateState)
    -- placeIds : 槽位id
    -- placeItemId : 槽位装备的符文ID（0未装备）
    -- rpIds : 激活的圣痕id
    -- runeLevel : 符文总等级
    -- itemIds : 拥有的符文ID
    -- itemNums : 拥有的符文数量
    WZLog("ProtocolProcessorWakeup:parse_RUNE_GetRuneInfoOk")
    if WndExtraction.m_root then
        WndExtraction:setRuneData(VectorToTable(itemIds),VectorToTable(itemNums))
    end
end

--@brief    获取所有宠物列表（PET_GetAllPetListOk = 2）
function ProtocolProcessorWakeup:parse_PET_GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
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
    WZLog("ProtocolProcessorWakeup:parse_PET_GetAllPetList OK")
    if WndExtraction.m_root then
        WndExtraction:setPetData(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
    end
end

--@brief    获取祈福信息成功（PRAY_GetPrayMessOk = 2）
function ProtocolProcessorWakeup:parse_PRAY_GetPrayMessOk(bagIds, bagExps, bagPrayIds, bagPrayNum, prayNum, equipPrayId, equipId, equipExp, fightNum)
    -- bagIds : 背包祈福唯一id
    -- bagExps : 背包祈福经验
    -- bagPrayIds : 背包祈福id
    -- bagPrayNum : 祈福珠数量
    -- prayNum : 装备祈福配置id
    -- equipPrayId : 装备祈福id
    -- equipId : 装备祈福唯一id
    -- equipExp : 装备祈福经验
    -- fightNum : 祈福战力
    WZLog("ProtocolProcessorWakeup:parse_PRAY_GetPrayMessOk")
    if WndExtraction.m_root then
        WndExtraction:setBlessData(bagIds, bagExps, bagPrayIds, bagPrayNum)
    end
end

--@brief    萃取（AWAKE_ExtractOk = 10）
function ProtocolProcessorWakeup:parse_AWAKE_ExtractOk(rewardId, num)
    -- rewardId : 奖励物品id
    -- num : 数目
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_ExtractOk")

    WndExtraction:extractionOK(VectorToTable(rewardId), VectorToTable(num))
end

--@brief    升级天赋成功（AWAKE_UpTalentOk = 12）
function ProtocolProcessorWakeup:parse_AWAKE_UpTalentOk(talentId)
    -- talentId : 天赋技能Id
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_UpTalentOk")

    WndWakeup:upgradeInbornOK(talentId)
end

--@brief    重置天赋点（AWAKE_ResetTalentNumOk = 14）
function ProtocolProcessorWakeup:parse_AWAKE_ResetTalentNumOk(status, talentId, skillId)
    -- status : 操作状态 1.成功 2.失败
    -- talentId : 天赋技能Id
    -- skillId : 觉醒技能
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_ResetTalentNumOk")

    WndWakeup:resetInbornAndSkillOK(status, VectorToTable(talentId), skillId)
end

--@brief    觉醒进化成功（AWAKE_AwakeEvolveOk = 16）
function ProtocolProcessorWakeup:parse_AWAKE_AwakeEvolveOk(status)
    -- status : 操作状态 0.成功 1,2.失败
    WZLog("ProtocolProcessorWakeup:parse_AWAKE_AwakeEvolveOk")

    WndWakeup:evolveOk(status)
end
---------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取觉醒信息（AWAKE_GetAwakeInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_GetAwakeInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_GetAwakeInfo, nflag, sMessage)
end

--@brief    魂晶培养（AWAKE_AwakeSoulTrain = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_AwakeSoulTrain_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_AwakeSoulTrain_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeSoulTrain, nflag, sMessage)
end

--@brief    觉醒（AWAKE_Awake = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_Awake_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_Awake_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_Awake, nflag, sMessage)
end

--@brief    领取觉醒套装（AWAKE_DrawAwakeSuit = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_DrawAwakeSuit_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_DrawAwakeSuit_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_DrawAwakeSuit, nflag, sMessage)
end

--@brief    获取符文信息（RUNE_GetRuneInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_RUNE_GetRuneInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_RUNE_GetRuneInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_RUNE, Protocol.RUNE_GetRuneInfo, nflag, sMessage)
end

--@brief    获取所有宠物列表（PET_GetAllPetList = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_PET_GetAllPetList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_PET_GetAllPetList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetAllPetList, nflag, sMessage)
end

--@brief    获取祈福信息（PRAY_GetPrayMess = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_PRAY_GetPrayMess_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_PRAY_GetPrayMess_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TRATE, Protocol.PRAY_GetPrayMess, nflag, sMessage)
end

--@brief    萃取（AWAKE_Extract = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_Extract_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_Extract_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_Extract, nflag, sMessage)
    WndExtraction:removeTouchBg()
end

--@brief    升级天赋（AWAKE_UpTalent = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_UpTalent_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_UpTalent_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_UpTalent, nflag, sMessage)
end

--@brief    重置天赋点（AWAKE_ResetTalentNum = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_ResetTalentNum_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_ResetTalentNum_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_ResetTalentNum, nflag, sMessage)
end

--@brief    觉醒进化（AWAKE_AwakeEvolve = 15）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorWakeup:send_AWAKE_AwakeEvolve_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWakeup:send_AWAKE_AwakeEvolve_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_AWAKE, Protocol.AWAKE_AwakeEvolve, nflag, sMessage)
end