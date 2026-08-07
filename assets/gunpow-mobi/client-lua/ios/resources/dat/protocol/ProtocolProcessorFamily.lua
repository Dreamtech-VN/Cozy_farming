--ProtocolProcessorFamily.lua
--@brief    成长基金相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     成长基金相关协议


ProtocolProcessorFamily = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorFamily:regAll()
    --@brief    获取玩家家园信息（HOME_GetPlayerHomeInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetPlayerHomeInfo, "ProtocolProcessorFamily:send_HOME_GetPlayerHomeInfo_ErrorProcess", "is" )
    --@brief    新建建筑（HOME_AddBuilding = 5)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_AddBuilding, "ProtocolProcessorFamily:send_HOME_AddBuilding_ErrorProcess", "is" )
    --@brief    移动建筑（HOME_MoveBuilding = 7)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_MoveBuilding, "ProtocolProcessorFamily:send_HOME_MoveBuilding_ErrorProcess", "is" )
    --@brief    拆除建筑（HOME_RemoveBuilding = 9)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_RemoveBuilding, "ProtocolProcessorFamily:send_HOME_RemoveBuilding_ErrorProcess", "is" )
    --@brief    获取排行榜信息（HOME_GetHomeRankList = 11)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetHomeRankList, "ProtocolProcessorFamily:send_HOME_GetHomeRankList_ErrorProcess", "is" )
    --@brief    收集（HOME_Collect = 13)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_Collect, "ProtocolProcessorFamily:send_HOME_Collect_ErrorProcess", "is" )
    --@brief    升级（HOME_LevelUp = 15)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_LevelUp, "ProtocolProcessorFamily:send_HOME_LevelUp_ErrorProcess", "is" )
    --@brief    加速（HOME_SpeedUp = 17）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_SpeedUp, "ProtocolProcessorFamily:send_HOME_SpeedUp_ErrorProcess", "is" )
    --@brief    获取地图刷新（HOME_GetMapUpdate = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetMapUpdate, "ProtocolProcessorFamily:send_HOME_GetMapUpdate_ErrorProcess", "is" )
    --@brief    获取商店（HOME_GetStore = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetStore, "ProtocolProcessorFamily:send_HOME_GetStore_ErrorProcess", "is" )
    --@brief    创建家园（HOME_CreateHome = 21）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_CreateHome, "ProtocolProcessorFamily:send_HOME_CreateHome_ErrorProcess", "is" )
    --@brief    取消（HOME_Cancel = 23）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_Cancel, "ProtocolProcessorFamily:send_HOME_Cancel_ErrorProcess", "is" )
    --@brief    快速购买（HOME_Purchase = 25）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_Purchase, "ProtocolProcessorFamily:send_HOME_Purchase_ErrorProcess", "is" )
	--@brief	搜索玩家（HOME_Search = 28）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_Search, "ProtocolProcessorFamily:send_HOME_Search_ErrorProcess", "is" )
    --@brief    获取建筑信息（HOME_GetBuildingInfo = 33）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetBuildingInfo, "ProtocolProcessorFamily:send_HOME_GetBuildingInfo_ErrorProcess", "is" )
    --@brief    开始生产（HOME_StartProduct = 35）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StartProduct, "ProtocolProcessorFamily:send_HOME_StartProduct_ErrorProcess", "is" )
    --@brief    加速生产（HOME_SpeedUpProduct = 37）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_SpeedUpProduct, "ProtocolProcessorFamily:send_HOME_SpeedUpProduct_ErrorProcess", "is" )
    --@brief    领取产物（HOME_DrawReward = 39）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_DrawReward, "ProtocolProcessorFamily:send_HOME_DrawReward_ErrorProcess", "is" )
    --@brief    获取所有宠物列表（PET_GetAllPetList = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetList, "ProtocolProcessorFamily:send_PET_GetAllPetList_ErrorProcess", "is" )
    --@brief    增加打工宠物数上限（HOME_AddServant = 41）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_AddServant, "ProtocolProcessorFamily:send_HOME_AddServant_ErrorProcess", "is" )
    --@brief    雇佣宠物打工（HOME_EmployServant = 43）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_EmployServant, "ProtocolProcessorFamily:send_HOME_EmployServant_ErrorProcess", "is" )
    --@brief    获取打工效率信息（HOME_GetServrantEfficiency = 44）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetServrantEfficiency, "ProtocolProcessorFamily:send_HOME_GetServrantEfficiency_ErrorProcess", "is" )
    --@brief    刷新打工效率（HOME_RefreshServrantEfficiency = 46）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_RefreshServrantEfficiency, "ProtocolProcessorFamily:send_HOME_RefreshServrantEfficiency_ErrorProcess", "is" )
    --@brief    收获打工奖励（HOME_ReceieveWorkReward = 47）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_ReceieveWorkReward, "ProtocolProcessorFamily:send_HOME_ReceieveWorkReward_ErrorProcess", "is" )
    --@brief    喂食守卫兽（HOME_FeedGuardromon = 49）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_FeedGuardromon, "ProtocolProcessorFamily:send_HOME_FeedGuardromon_ErrorProcess", "is" )
    --@brief    守卫兽开始守护（HOME_StartGuard = 51）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StartGuard, "ProtocolProcessorFamily:send_HOME_StartGuard_ErrorProcess", "is" )
    --@brief    偷取资源（HOME_StealWorkReward = 53）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StealWorkReward, "ProtocolProcessorFamily:send_HOME_StealWorkReward_ErrorProcess", "is" )
    --@brief    偷盗日志（HOME_GetStealLog = 55）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetStealLog, "ProtocolProcessorFamily:send_HOME_GetStealLog_ErrorProcess", "is" )
    --@brief    治疗伤口（HOME_Cure = 57）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_Cure, "ProtocolProcessorFamily:send_HOME_Cure_ErrorProcess", "is" )


    --@brief    获取玩家家园信息（HOME_GetPlayerHomeInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetPlayerHomeInfoOk, "ProtocolProcessorFamily:parse_HOME_GetPlayerHomeInfoOk", "isiiivivivivtvtviviviiiviviviviiviiiivsvsvi")
    --@brief    获取商店（HOME_GetStoreOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetStoreOk, "ProtocolProcessorFamily:parse_HOME_GetStoreOk", "vivivivi")
    --@brief    新建建筑（HOME_AddBuildingOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_AddBuildingOk, "ProtocolProcessorFamily:parse_HOME_AddBuildingOk", "iiit")
    --@brief    移动建筑（HOME_MoveBuildingOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_MoveBuildingOk, "ProtocolProcessorFamily:parse_HOME_MoveBuildingOk", "vivivivivt")
    --@brief    拆除建筑（HOME_RemoveBuildingOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_RemoveBuildingOk, "ProtocolProcessorFamily:parse_HOME_RemoveBuildingOk", "iii")
    --@brief    获取排行榜信息（HOME_GetHomeRankListOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetHomeRankListOk, "ProtocolProcessorFamily:parse_HOME_GetHomeRankListOk", "vivivsvivivivivtviviviviviivi")
    --@brief    收集（HOME_CollectOk = 14）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_CollectOk, "ProtocolProcessorFamily:parse_HOME_CollectOk", "vivivi")
    --@brief    升级（HOME_LevelUpOk = 16）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_LevelUpOk, "ProtocolProcessorFamily:parse_HOME_LevelUpOk", "iii")
    --@brief    加速（HOME_SpeedUpOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_SpeedUpOk, "ProtocolProcessorFamily:parse_HOME_SpeedUpOk", "iit")
    --@brief    获取地图刷新（HOME_GetMapUpdateOk = 20）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetMapUpdateOk, "ProtocolProcessorFamily:parse_HOME_GetMapUpdateOk", "iiivivivivtvtvivivi")
    --@brief    创建家园（HOME_CreateHomeOk = 22）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_CreateHomeOk, "ProtocolProcessorFamily:parse_HOME_CreateHomeOk", "")
    --@brief    取消（HOME_CancelOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_CancelOk, "ProtocolProcessorFamily:parse_HOME_CancelOk", "iitt")
    --@brief    快速购买（HOME_PurchaseOk = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_PurchaseOk, "ProtocolProcessorFamily:parse_HOME_PurchaseOk", "")
    --@brief    搜索玩家（HOME_SearchOk = 27）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_SearchOk, "ProtocolProcessorFamily:parse_HOME_SearchOk", "iisiiitiiiiii")
    --@brief    获取建筑信息（HOME_GetBuildingInfoOk = 34）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetBuildingInfoOk, "ProtocolProcessorFamily:parse_HOME_GetBuildingInfoOk", "iis")
    --@brief    开始生产（HOME_StartProductOk = 36）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StartProductOk, "ProtocolProcessorFamily:parse_HOME_StartProductOk", "")
    --@brief    加速生产（HOME_SpeedUpProductOk = 38）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_SpeedUpProductOk, "ProtocolProcessorFamily:parse_HOME_SpeedUpProductOk", "")
    --@brief    领取产物（HOME_DrawRewardOk = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_DrawRewardOk, "ProtocolProcessorFamily:parse_HOME_DrawRewardOk", "vivi")
    --@brief    获取所有宠物列表（PET_GetAllPetListOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_PET, Protocol.PET_GetAllPetListOk, "ProtocolProcessorFamily:parse_PET_GetAllPetListOk", "vivsvsvsvnvnvsvivivivbvivivivivivsvivs")
    --@brief    增加打工宠物数上限（HOME_AddServantOk = 42）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_AddServantOk, "ProtocolProcessorFamily:parse_HOME_AddServantOk", "i")
    --@brief    获取打工效率（HOME_GetServrantEfficiencyOk = 45）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetServrantEfficiencyOk, "ProtocolProcessorFamily:parse_HOME_GetServrantEfficiencyOk", "iiii")
    --@brief    收获打工奖励（HOME_ReceieveWorkRewardOk = 48）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_ReceieveWorkRewardOk, "ProtocolProcessorFamily:parse_HOME_ReceieveWorkRewardOk", "viviii")
    --@brief    喂食守卫兽（HOME_FeedGuardromonOk = 50）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_FeedGuardromonOk, "ProtocolProcessorFamily:parse_HOME_FeedGuardromonOk", "i")
    --@brief    守卫兽开始守护（HOME_StartGuardOk = 52）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StartGuardOk, "ProtocolProcessorFamily:parse_HOME_StartGuardOk", "i")
    --@brief    偷取资源（HOME_StealWorkRewardOk = 54）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_StealWorkRewardOk, "ProtocolProcessorFamily:parse_HOME_StealWorkRewardOk", "viviiii")
    --@brief    偷盗日志（HOME_GetStealLogOk = 56）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_GetStealLogOk, "ProtocolProcessorFamily:parse_HOME_GetStealLogOk", "vivivivsvsvivivi")
    --@brief    治疗伤口（HOME_CureOk = 58）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_CureOk, "ProtocolProcessorFamily:parse_HOME_CureOk", "")
    --@brief    雇佣宠物打工成功（HOME_EmployServantOk = 59）
    self:regProtocolCallbackFunction( Protocol.MAIN_HOME, Protocol.HOME_EmployServantOk, "ProtocolProcessorFamily:parse_HOME_EmployServantOk", "iiiissi")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorFamily:unregAll()
    self:clearReg()
end


---------------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取玩家家园信息（HOME_GetPlayerHomeInfo = 1）
function ProtocolProcessorFamily:send_HOME_GetPlayerHomeInfo(targetPlayerId )
    WZLog("send_HOME_GetPlayerHomeInfo")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetPlayerHomeInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( targetPlayerId )   -- 目标玩家id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取商店（HOME_GetStore = 3）
function ProtocolProcessorFamily:send_HOME_GetStore( )
    WZLog("send_HOME_GetStore")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetStore )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    新建建筑（HOME_AddBuilding = 5)
function ProtocolProcessorFamily:send_HOME_AddBuilding(configId, x, y, flipStatus )
    WZLog("send_HOME_AddBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_AddBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( configId ) -- 建筑id
    sender:writeInt( x )    -- x坐标
    sender:writeInt( y )    -- y坐标
    sender:writeByte( flipStatus )  -- 翻转状态
    SendProtocol(sender,false) --true:showLoading
end

--@brief    移动建筑（HOME_MoveBuilding = 7)
function ProtocolProcessorFamily:send_HOME_MoveBuilding(xOrigin, yOrigin, xTarget, yTarget, flipStatus )
    WZLog("send_HOME_MoveBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_MoveBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts( xOrigin ) -- 起始x坐标
    sender:writeInts( yOrigin ) -- 起始y坐标
    sender:writeInts( xTarget ) -- 目标x坐标
    sender:writeInts( yTarget ) -- 目标y坐标
    sender:writeBytes( flipStatus ) -- 翻转状态
    SendProtocol(sender,false) --true:showLoading
end

--@brief    拆除建筑（HOME_RemoveBuilding = 9)
function ProtocolProcessorFamily:send_HOME_RemoveBuilding(xTarget, yTarget )
    WZLog("send_HOME_RemoveBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_RemoveBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取排行榜信息（HOME_GetHomeRankList = 11)
function ProtocolProcessorFamily:send_HOME_GetHomeRankList(rankType )
    WZLog("send_HOME_GetHomeRankList")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetHomeRankList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型,1:本服,2:区服
    SendProtocol(sender,false) --true:showLoading
end

--@brief    收集（HOME_Collect = 13)
function ProtocolProcessorFamily:send_HOME_Collect(xTarget, yTarget )
    WZLog("send_HOME_Collect")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_Collect )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    SendProtocol(sender,false) --true:showLoading
end

--@brief    升级（HOME_LevelUp = 15)
function ProtocolProcessorFamily:send_HOME_LevelUp(xTarget, yTarget )
    WZLog("send_HOME_LevelUp")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_LevelUp )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    SendProtocol(sender,false) --true:showLoading
end

--@brief    加速（HOME_SpeedUp = 17）
function ProtocolProcessorFamily:send_HOME_SpeedUp(xTarget, yTarget, speedType )
    WZLog("send_HOME_SpeedUp")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_SpeedUp )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    sender:writeByte( speedType )   -- 加速类型,1:建造;2:升级;3:拆除
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取地图刷新（HOME_GetMapUpdate = 19）
function ProtocolProcessorFamily:send_HOME_GetMapUpdate( )
    WZLog("send_HOME_GetMapUpdate")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetMapUpdate )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    创建家园（HOME_CreateHome = 21）
function ProtocolProcessorFamily:send_HOME_CreateHome( )
    WZLog("send_HOME_CreateHome")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_CreateHome )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    取消（HOME_Cancel = 23）
function ProtocolProcessorFamily:send_HOME_Cancel(xTarget, yTarget, cancelType )
    WZLog("send_HOME_Cancel")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_Cancel )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    sender:writeByte( cancelType )  -- 取消类型(1:建造;2:升级;3:拆除)
    SendProtocol(sender,false) --true:showLoading
end

--@brief    快速购买（HOME_Purchase = 25）
function ProtocolProcessorFamily:send_HOME_Purchase(buyType, buyTimes )
    WZLog("send_HOME_Purchase")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_Purchase )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( buyType ) -- 购买类型(1:圣水;2:奇石)
    sender:writeInt( buyTimes ) -- 购买次数
    SendProtocol(sender,false) --true:showLoading
end

--@brief	搜索玩家（HOME_Search = 27）
function ProtocolProcessorFamily:send_HOME_Search(playerId )
	WZLog("send_HOME_Search")
	local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_Search )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief    获取建筑信息（HOME_GetBuildingInfo = 33）
function ProtocolProcessorFamily:send_HOME_GetBuildingInfo(x, y)
    WZLog("send_HOME_GetBuildingInfo")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetBuildingInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( x )    -- 
    sender:writeInt( y )    -- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    开始生产（HOME_StartProduct = 35）
function ProtocolProcessorFamily:send_HOME_StartProduct(x, y)
    WZLog("send_HOME_StartProduct")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_StartProduct )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( x )    -- 
    sender:writeInt( y )    -- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    加速生产（HOME_SpeedUpProduct = 37）
function ProtocolProcessorFamily:send_HOME_SpeedUpProduct(x, y)
    WZLog("send_HOME_SpeedUpProduct")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_SpeedUpProduct )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( x )    -- 
    sender:writeInt( y )    -- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取产物（HOME_DrawReward = 39）
function ProtocolProcessorFamily:send_HOME_DrawReward(x, y)
    WZLog("send_HOME_DrawReward")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_DrawReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( x )    -- 
    sender:writeInt( y )    -- 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取所有宠物列表（PET_GetAllPetList = 1）
function ProtocolProcessorFamily:send_PET_GetAllPetList( )
    WZLog("send_PET_GetAllPetList")
    local sender = Protocol:getSender( Protocol.MAIN_PET, Protocol.PET_GetAllPetList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    增加打工宠物数上限（HOME_AddServant = 41）
function ProtocolProcessorFamily:send_HOME_AddServant( )
    WZLog("send_HOME_AddServant")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_AddServant )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    雇佣宠物打工（HOME_EmployServant = 43）
function ProtocolProcessorFamily:send_HOME_EmployServant(petId )
    WZLog("send_HOME_EmployServant")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_EmployServant)
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( petId )    -- 玩家宠物ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取打工效率信息（HOME_GetServrantEfficiency = 44）
function ProtocolProcessorFamily:send_HOME_GetServrantEfficiency( )
    WZLog("send_HOME_GetServrantEfficiency")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetServrantEfficiency)
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    刷新打工效率（HOME_RefreshServrantEfficiency = 46）
function ProtocolProcessorFamily:send_HOME_RefreshServrantEfficiency( )
    WZLog("send_HOME_RefreshServrantEfficiency")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_RefreshServrantEfficiency )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    收获打工奖励（HOME_ReceieveWorkReward = 47）
function ProtocolProcessorFamily:send_HOME_ReceieveWorkReward(id )
    WZLog("send_HOME_ReceieveWorkReward")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_ReceieveWorkReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 佣人ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    喂食守卫兽（HOME_FeedGuardromon = 49）
function ProtocolProcessorFamily:send_HOME_FeedGuardromon(itemId, num)
    WZLog("send_HOME_FeedGuardromon")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_FeedGuardromon )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( itemId )   -- 物品ID
    sender:writeInt( num )  -- 数量
    SendProtocol(sender,false) --true:showLoading
end

--@brief    守卫兽开始守护（HOME_StartGuard = 51）
function ProtocolProcessorFamily:send_HOME_StartGuard(id)
    WZLog("send_HOME_StartGuard")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_StartGuard )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 守卫兽ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    偷取资源（HOME_StealWorkReward = 53）
function ProtocolProcessorFamily:send_HOME_StealWorkReward(id, targetPlayerId )
    WZLog("send_HOME_StealWorkReward")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_StealWorkReward )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( id )   -- 佣人ID
    sender:writeInt( targetPlayerId )   -- 目标玩家ID
    SendProtocol(sender,false) --true:showLoading
end

--@brief    偷盗日志（HOME_GetStealLog = 55）
function ProtocolProcessorFamily:send_HOME_GetStealLog( )
    WZLog("send_HOME_GetStealLog")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_GetStealLog )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    治疗伤口（HOME_Cure = 57）
function ProtocolProcessorFamily:send_HOME_Cure( )
    WZLog("send_HOME_Cure")
    local sender = Protocol:getSender( Protocol.MAIN_HOME, Protocol.HOME_Cure )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

---------------------------------服务器到客户端协议回调方法模块----------------------------------

--@brief    获取所有宠物列表（PET_GetAllPetList = 1）
function ProtocolProcessorFamily:parse_PET_GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
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
    WZLog("ProtocolProcessorFamily:parse_PET_GetAllPetListOK")
    if WndFamilyProduce.m_root then
        WndFamilyProduce:GetAllPetListOk(VectorToTable(itemId),VectorToTable(name),VectorToTable(icon),VectorToTable(animation),VectorToTable(advancedLevel),VectorToTable(upgradeLevel),VectorToTable(property),VectorToTable(giftSkill),VectorToTable(commonSkill1),VectorToTable(commonSkill2),VectorToTable(isInUsed),VectorToTable(playerPetId),VectorToTable(num),VectorToTable(petExp),VectorToTable(fighting),VectorToTable(birthSkill),VectorToTable(skill), VectorToTable(petSkinItemId), VectorToTable(fetterStatus))
    end
end

--@brief    获取玩家家园信息（HOME_GetPlayerHomeInfoOk = 2）
function ProtocolProcessorFamily:parse_HOME_GetPlayerHomeInfoOk(hostPlayerId, name, level, exp, sheerLuxury, x, y, configId, flipStatus, buildingStatus, countdown, productItemId, currentNum, buyWaterTimes, buyStoneTimes, servrantId, servrantItemId, servrantEfficient, servrantEndTime, maxServrantNum, canSteal, hurtEndTime, guardromonId, guardEndTime, icon, animation, advancedLevel)
    -- hostPlayerId : 主人id
    -- name : 名称
    -- level : 等级
    -- exp : 经验
    -- sheerLuxury : 豪华度
    -- x : x坐标
    -- y : y坐标
    -- configId : 配置表id
    -- flipStatus : 翻转状态(0:正常;1:翻转)
    -- buildingStatus : 建筑状态(0:无；1:建造中；2:升级中；3:拆除中)
    -- countdown : 倒计时
    -- productItemId : 产物id
    -- currentNum : 当前产物数目
    -- buyWaterTimes : 当日已购买圣水的次数
    -- buyStoneTimes : 当日已购买奇石的次数
    -- servrantId : 打工宠物ID（玩家宠物ID）
    -- servrantItemId : 打工宠物形象ID
    -- servrantEfficient : 打工效率(type字段)
    -- servrantEndTime : 打工剩余时间（秒）
    -- maxServrantNum : 玩家当前可拥有最大打工宠物数量
    -- canSteal : 该打工宠物是否还能被偷（0 不能 1可以）
    -- hurtEndTime : 受伤倒计时
    -- guardromonId : 守卫兽ID
    -- guardEndTime : 守卫剩余时间（秒）
    -- icon : 打工头像
    -- animation : 形象
    -- advancedLevel : 进阶等级
    WZLog("ProtocolProcessorFamily:parse_HOME_GetPlayerHomeInfoOk")
    SceneFamily:setData(hostPlayerId, name, level, exp, sheerLuxury, VectorToTable(configId), VectorToTable(buildingStatus), VectorToTable(countdown), VectorToTable(productItemId), VectorToTable(flipStatus), VectorToTable(x), VectorToTable(y), VectorToTable(currentNum), buyWaterTimes, buyStoneTimes, VectorToTable(servrantId), VectorToTable(servrantItemId), VectorToTable(servrantEfficient), VectorToTable(servrantEndTime), maxServrantNum, VectorToTable(canSteal), hurtEndTime, guardromonId, guardEndTime, VectorToTable(icon), VectorToTable(animation), VectorToTable(advancedLevel))
end

--@brief    获取商店（HOME_GetStoreOk = 4）
function ProtocolProcessorFamily:parse_HOME_GetStoreOk(configId, freeTimes, currentNum, numLimit)
    -- configId : 建筑id
    -- freeTimes : 免费次数
    -- currentNum : 当前数目
    -- numLimit : 数目限制
    WZLog("ProtocolProcessorFamily:parse_HOME_GetStoreOk")
	WndFamilyShop:setData( VectorToTable(configId), VectorToTable(freeTimes), VectorToTable(currentNum), VectorToTable(numLimit))
end

--@brief    新建建筑（HOME_AddBuildingOk = 6）
function ProtocolProcessorFamily:parse_HOME_AddBuildingOk(configId, x, y, flipStatus)
    -- configId : 建筑id
    -- x : x坐标
    -- y : y坐标
    -- flipStatus : 翻转状态
    WZLog("ProtocolProcessorFamily:parse_HOME_AddBuildingOk")
    SceneFamily:buildNewBuildingOK(configId, x, y, flipStatus)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    if isEndTeach ~= true then
        local buildingCK = SceneFamily:getBuildingCellById(40300)
        local buildingSS = SceneFamily:getBuildingCellById(40100)
        WZLog("ProtocolProcessorFamily:parse_HOME_AddBuildingOk two", tostring(buildingCK), tostring(buildingSS))
        if buildingCK and buildingSS == nil then
            TeachGroup1:endTeachStep({45,3})
            TeachGroup1:startGroup({45,4,WndFamilyOperate.m_root})
        elseif buildingCK and buildingSS then
            TeachGroup1:endTeachStep({45,6})
            TeachGroup1:startGroup({45,7,buildingSS.m_root})
        else
            TeachGroup1:removeTeach()
        end
    end
    -- if isEndTeach ~= true and finishStep < 3 then
    --     TeachGroup1:endTeachStep({45,3})
    --     TeachGroup1:startGroup({45,4,WndFamilyOperate.m_root})
    -- elseif isEndTeach ~= true and finishStep >= 3 then
    --     TeachGroup1:endTeachStep({45,6})
    --     local buildingSS = SceneFamily:getBuildingCellById(40100)
    --     WZLog("ProtocolProcessorFamily:parse_HOME_AddBuildingOk two", tostring(buildingSS))
    --     TeachGroup1:startGroup({45,7,buildingSS.m_root})
    -- end
end

--@brief    移动建筑（HOME_MoveBuildingOk = 8）
function ProtocolProcessorFamily:parse_HOME_MoveBuildingOk(xOrigin, yOrigin, xTarget, yTarget, flipStatus)
    -- xOrigin : 起始x坐标
    -- yOrigin : 起始y坐标
    -- xTarget : 目标x坐标
    -- yTarget : 目标y坐标
    -- flipStatus : 翻转状态
    WZLog("ProtocolProcessorFamily:parse_HOME_MoveBuildingOk")

    SceneFamily:buildingMoveOK(VectorToTable(xOrigin), VectorToTable(yOrigin), VectorToTable(xTarget), VectorToTable(yTarget), VectorToTable(flipStatus))
end

--@brief    拆除建筑（HOME_RemoveBuildingOk = 10）
function ProtocolProcessorFamily:parse_HOME_RemoveBuildingOk(xTarget, yTarget, countDown)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- countDown : 拆除倒计时
    WZLog("ProtocolProcessorFamily:parse_HOME_RemoveBuildingOk")

    SceneFamily:buildingRemoveOK(xTarget, yTarget, countDown)
end

--@brief    获取排行榜信息（HOME_GetHomeRankListOk = 12）
function ProtocolProcessorFamily:parse_HOME_GetHomeRankListOk(playerId, serverId, name, rank, faceId, headColor, headId, sex, level, vipLevel, homeLevel, homeExp, sheerLuxury, playerRank, canSteal)
    -- playerId : 玩家id
    -- serverId : 区服id
    -- name : 名称
    -- rank : 排名
    -- faceId : 脸部id
    -- onlineStatus : 0:不在线;1:不在线
    -- headColor : 头部颜色
    -- headId : 头部id
    -- sex : 性别
    -- level : 等级
    -- vipLevel : vip等级
    -- homeLevel : 家园等级
    -- homeExp : 家园经验
    -- sheerLuxury : 豪华度
    -- canSteal : 0->不能偷;2->可以偷
    WZLog("ProtocolProcessorFamily:parse_HOME_GetHomeRankListOk")

    if WndFamilyOperate.m_root then
        WndFamilyOperate:setData(VectorToTable(playerId), VectorToTable(serverId), VectorToTable(name), VectorToTable(rank), VectorToTable(faceId), VectorToTable(headColor), VectorToTable(headId), VectorToTable(sex), VectorToTable(level), VectorToTable(vipLevel), VectorToTable(homeLevel), VectorToTable(homeExp), VectorToTable(sheerLuxury), playerRank, VectorToTable(canSteal))
    end
end

--@brief    收集（HOME_CollectOk = 14）
function ProtocolProcessorFamily:parse_HOME_CollectOk(x, y, num)
    -- x : x坐标
    -- y : y坐标
    -- num : 可收集的数量
    WZLog("ProtocolProcessorFamily:parse_HOME_CollectOk")
    SceneFamily:collectWaterOrStoneOK(VectorToTable(x), VectorToTable(y), VectorToTable(num))
end

--@brief    升级（HOME_LevelUpOk = 16）
function ProtocolProcessorFamily:parse_HOME_LevelUpOk(xTarget, yTarget, countDown)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- countDown : 升级倒计时
    WZLog("ProtocolProcessorFamily:parse_HOME_LevelUpOk")
    SceneFamily:buildingUpgradeOK(xTarget, yTarget, countDown)
end

--@brief    加速（HOME_SpeedUpOk = 18）
function ProtocolProcessorFamily:parse_HOME_SpeedUpOk(xTarget, yTarget, speedType)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- speedType : 加速类型,1:建造;2:升级;3:拆除
    WZLog("ProtocolProcessorFamily:parse_HOME_SpeedUpOk")

    SceneFamily:buildingSpeedUpOK(xTarget, yTarget, speedType)
end

--@brief    获取地图刷新（HOME_GetMapUpdateOk = 20）
function ProtocolProcessorFamily:parse_HOME_GetMapUpdateOk(currentLevel, currentExp, currentSheerLuxury, x, y, configId, flipStatus, buildingStatus, countdown, productItemId, currentNum)
    -- sheerLuxury : 等级
    -- preLevel : 经验
    -- preExp : 豪华度
    -- currentLevel : 等级
    -- currentExp : 经验
    -- currentSheerLuxury : 豪华度
    -- x : 更新的x坐标
    -- y : 更新的y坐标
    -- configId : 配置表id
    -- flipStatus : 翻转状态(0:正常;1:翻转)
    -- buildingStatus : 建筑状态
    -- countdown : 倒计时
    -- productItemId : 产物id
    -- currentNum : 当前产物数目
    WZLog("ProtocolProcessorFamily:parse_HOME_GetMapUpdateOk")
    SceneFamily:updateHomeData(currentLevel, currentExp, currentSheerLuxury, VectorToTable(x), VectorToTable(y), VectorToTable(configId), VectorToTable(flipStatus), VectorToTable(buildingStatus), VectorToTable(countdown), VectorToTable(productItemId), VectorToTable(currentNum))
end

--@brief    创建家园（HOME_CreateHomeOk = 22）
function ProtocolProcessorFamily:parse_HOME_CreateHomeOk()
    WZLog("ProtocolProcessorFamily:parse_HOME_CreateHomeOk")

    WndCreateFamily:createFamilyOK()
end

--@brief    取消（HOME_CancelOk = 24）
function ProtocolProcessorFamily:parse_HOME_CancelOk(xTarget, yTarget, cancelType, result)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- cancelType : 加速类型,1:建造;2:升级;3:拆除
    -- result : 0:成功;1:失败
    WZLog("ProtocolProcessorFamily:parse_HOME_CancelOk")
    SceneFamily:cancelOperateOK(xTarget, yTarget, cancelType, result)
end

--@brief    快速购买（HOME_PurchaseOk = 26）
function ProtocolProcessorFamily:parse_HOME_PurchaseOk()
    WZLog("ProtocolProcessorFamily:parse_HOME_PurchaseOk")
    SceneFamily:buyWaterAndStoneOK()
end

--@brief	搜索玩家（HOME_SearchOk = 28）
function ProtocolProcessorFamily:parse_HOME_SearchOk(playerId, serverId, name, faceId, headColor, headId, sex, level, vipLevel, homeLevel, homeExp, sheerLuxury, canSteal)
	-- playerId : 玩家id
	-- serverId : 区服id
	-- name : 名称
	-- faceId : 脸部id
	-- headColor : 头部颜色
	-- headId : 头部id
	-- sex : 性别
	-- level : 等级
	-- vipLevel : vip等级
	-- homeLevel : 家园等级
	-- homeExp : 家园经验
	-- sheerLuxury : 豪华度
	WZLog("ProtocolProcessorFamily:parse_HOME_SearchOk")
    if WndFamilyOperate.m_root then
        WndFamilyOperate:setData({playerId}, {serverId}, {name}, {-1}, {faceId}, {headColor}, {headId}, {sex}, {level}, {vipLevel}, {homeLevel}, {homeExp}, {sheerLuxury}, nil, {canSteal})
    end
end

--@brief    获取建筑信息（HOME_GetBuildingInfoOk = 34）
function ProtocolProcessorFamily:parse_HOME_GetBuildingInfoOk(x, y, info)
    -- x : 
    -- y :
    -- info : 
    WZLog("ProtocolProcessorFamily:parse_HOME_GetBuildingInfoOk")
    
    WndFamilyTrain:setTrainData(x, y, info)
end

--@brief    开始生产（HOME_StartProductOk = 36）
function ProtocolProcessorFamily:parse_HOME_StartProductOk()
    WZLog("ProtocolProcessorFamily:parse_HOME_StartProductOk")

    WndFamilyTrain:startToFeedOrSearchOK()
end

--@brief    加速生产（HOME_SpeedUpProductOk = 38）
function ProtocolProcessorFamily:parse_HOME_SpeedUpProductOk()
    WZLog("ProtocolProcessorFamily:parse_HOME_SpeedUpProductOk")

    WndFamilyTrain:speedupFeedOK()
end

--@brief    领取产物（HOME_DrawRewardOk = 40）
function ProtocolProcessorFamily:parse_HOME_DrawRewardOk(itemId, num)
    -- itemId : 奖励物品id
    -- num : 奖励物品数量
    WZLog("ProtocolProcessorFamily:parse_HOME_DrawRewardOk")

    WndFamilyTrain:reveiveRewardOK(VectorToTable(itemId), VectorToTable(num))
end

--@brief    增加打工宠物数上限（HOME_AddServantOk = 42）
function ProtocolProcessorFamily:parse_HOME_AddServantOk(num)
    -- time : 剩余守卫时间（秒）
    WZLog("ProtocolProcessorFamily:parse_HOME_AddServantOk")

    WndFamilyProduce:addMaxPetNumOK(num)
end

--@brief    获取打工效率（HOME_GetServrantEfficiencyOk = 45）
function ProtocolProcessorFamily:parse_HOME_GetServrantEfficiencyOk(status, efficiency, bless, refreshTime)
    -- status : 结果: 1.成功 2.失败 3.查询
    -- efficiency : 当前打工效率
    -- bless : 当前祝福值
    -- refreshTime : 当前刷新次数
    WZLog("ProtocolProcessorFamily:parse_HOME_GetServrantEfficiencyOk")

    WndFamilyProduce:getWorkDataOK(status, efficiency, bless, refreshTime)
end

--@brief    收获打工奖励（HOME_ReceieveWorkRewardOk = 48）
function ProtocolProcessorFamily:parse_HOME_ReceieveWorkRewardOk(itemId, num, stealTimes, id)
    -- itemId : 物品ID
    -- num : 数量
    -- stealTimes : 已被偷取次数
    -- id : 被操作的打工玩家宠物id
    WZLog("ProtocolProcessorFamily:parse_HOME_ReceieveWorkRewardOk")
    SceneFamily:receiveResult(VectorToTable(itemId), VectorToTable(num), stealTimes, id)
end

--@brief    喂食守卫兽（HOME_FeedGuardromonOk = 50）
function ProtocolProcessorFamily:parse_HOME_FeedGuardromonOk(time)
    -- time : 剩余守卫时间（秒）
    WZLog("ProtocolProcessorFamily:parse_HOME_FeedGuardromonOk")

    SceneFamily:feedProtectRoleOK(time)
end

--@brief    守卫兽开始守护（HOME_StartGuardOk = 52）
function ProtocolProcessorFamily:parse_HOME_StartGuardOk(id)
    WZLog("ProtocolProcessorFamily:parse_HOME_StartGuardOk ")

    SceneFamily:startToProtectOk(id)
end

--@brief    偷取资源（HOME_StealWorkRewardOk = 54）
function ProtocolProcessorFamily:parse_HOME_StealWorkRewardOk(itemId, num, status, time, id)
    -- itemId : 物品ID
    -- num : 数量
    -- status : 偷资源状态. 1.成功 2.已经偷过了 3.已达最大小偷数 4.被守卫兽发现 5.已被收取
    -- time : 受伤持续时间（秒）
    -- id : 被偷取的打工玩家宠物id
    WZLog("ProtocolProcessorFamily:parse_HOME_StealWorkRewardOk")

    SceneFamily:stealResult(VectorToTable(itemId), VectorToTable(num), status, time, id)
end

--@brief    偷盗日志（HOME_GetStealLogOk = 56）
function ProtocolProcessorFamily:parse_HOME_GetStealLogOk(logType, time, playerId, playerName, petName, guardromonId, hurt, defend)
    -- logType : 类型 1.偷 2.被偷
    -- time : 偷盗时间
    -- playerId : 玩家ID
    -- playerName : 玩家昵称
    -- petName : 佣人物品ID
    -- guardromonId : 守卫兽ID
    -- hurt : 是否被抓伤 0.否 1.是
    -- defend : 是否防卫成功 0.否 1.是
    WZLog("ProtocolProcessorFamily:parse_HOME_GetStealLogOk")

    WndFamilyProtectLog:setLogData(VectorToTable(logType), VectorToTable(time), VectorToTable(playerId), VectorToTable(playerName), VectorToTable(petName), VectorToTable(guardromonId), VectorToTable(hurt), VectorToTable(defend))
end

--@brief    治疗伤口（HOME_CureOk = 58）
function ProtocolProcessorFamily:parse_HOME_CureOk()
    WZLog("ProtocolProcessorFamily:parse_HOME_CureOk")
    WndFamilyOperate:speedToRecoverOK()
end

--@brief    雇佣宠物打工成功（HOME_EmployServantOk = 59）
function ProtocolProcessorFamily:parse_HOME_EmployServantOk(servrantId, servrantItemId, servrantEfficient, servrantEndTime, icon, animation, advancedLevel)
    -- servrantId : 打工宠物ID（玩家宠物ID）
    -- servrantItemId : 打工宠物形象ID
    -- servrantEfficient : 打工效率(type字段)
    -- servrantEndTime : 打工剩余时间（秒）
    -- icon : 打工剩余时间（秒）
    -- animation : 打工剩余时间（秒）
    -- advancedLevel : 打工剩余时间（秒）

    WZLog("ProtocolProcessorFamily:parse_HOME_EmployServantOk")

    SceneFamily:startToWorkOk(servrantId, servrantItemId, servrantEfficient, servrantEndTime, icon, animation, advancedLevel)
end

---------------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取玩家家园信息（HOME_GetPlayerHomeInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetPlayerHomeInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetPlayerHomeInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetPlayerHomeInfo, nflag, sMessage)
end

--@brief    获取商店（HOME_GetStore = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetStore_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetStore_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetStore, nflag, sMessage)
end

--@brief    新建建筑（HOME_AddBuilding = 5)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_AddBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_AddBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_AddBuilding, nflag, sMessage)
end

--@brief    移动建筑（HOME_MoveBuilding = 7)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_MoveBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_MoveBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_MoveBuilding, nflag, sMessage)
end

--@brief    拆除建筑（HOME_RemoveBuilding = 9)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_RemoveBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_RemoveBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_RemoveBuilding, nflag, sMessage)
end

--@brief    获取排行榜信息（HOME_GetHomeRankList = 11)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetHomeRankList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetHomeRankList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetHomeRankList, nflag, sMessage)
end

--@brief    收集（HOME_Collect = 13)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_Collect_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_Collect_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_Collect, nflag, sMessage)
end

--@brief    升级（HOME_LevelUp = 15)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_LevelUp_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_LevelUp_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_LevelUp, nflag, sMessage)
end

--@brief    加速（HOME_SpeedUp = 17）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_SpeedUp_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_SpeedUp_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_SpeedUp, nflag, sMessage)
end

--@brief    获取地图刷新（HOME_GetMapUpdate = 19）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetMapUpdate_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetMapUpdate_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetMapUpdate, nflag, sMessage)
end

--@brief    创建家园（HOME_CreateHome = 21）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_CreateHome_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_CreateHome_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_CreateHome, nflag, sMessage)
end

--@brief    取消（HOME_Cancel = 23）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_Cancel_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_Cancel_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_Cancel, nflag, sMessage)
end

--@brief    快速购买（HOME_Purchase = 25）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_Purchase_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_Purchase_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_Purchase, nflag, sMessage)
end

--@brief	搜索玩家（HOME_Search = 27）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_Search_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorFamily:send_HOME_Search_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_Search, nflag, sMessage)
end

--@brief    获取建筑信息（HOME_GetBuildingInfo = 33）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetBuildingInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetBuildingInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetBuildingInfo, nflag, sMessage)
end

--@brief    开始生产（HOME_StartProduct = 35）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_StartProduct_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_StartProduct_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_StartProduct, nflag, sMessage)
end

--@brief    加速生产（HOME_SpeedUpProduct = 37）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_SpeedUpProduct_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_SpeedUpProduct_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_SpeedUpProduct, nflag, sMessage)
end


--@brief    领取产物（HOME_DrawReward = 39）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_DrawReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_DrawReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_DrawReward, nflag, sMessage)
end

--@brief    获取所有宠物列表（PET_GetAllPetList = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_PET_GetAllPetList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_PET_GetAllPetList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PET, Protocol.PET_GetAllPetList, nflag, sMessage)
end

--@brief    增加打工宠物数上限（HOME_AddServant = 41）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_AddServant_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_AddServant_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_AddServant, nflag, sMessage)
end

--@brief    雇佣宠物打工（HOME_EmployServant = 43）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_EmployServant_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_EmployServant_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_EmployServant, nflag, sMessage)
end

--@brief    获取打工效率信息（HOME_GetServrantEfficiency = 44）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetServrantEfficiency_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetServrantEfficiency_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetServrantEfficiency, nflag, sMessage)
end

--@brief    刷新打工效率（HOME_RefreshServrantEfficiency = 46）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_RefreshServrantEfficiency_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_RefreshServrantEfficiency_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_RefreshServrantEfficiency, nflag, sMessage)
end

--@brief    收获打工奖励（HOME_ReceieveWorkReward = 47）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_ReceieveWorkReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_ReceieveWorkReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_ReceieveWorkReward, nflag, sMessage)
end

--@brief    喂食守卫兽（HOME_FeedGuardromon = 49）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_FeedGuardromon_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_FeedGuardromon_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_FeedGuardromon, nflag, sMessage)
end

--@brief    守卫兽开始守护（HOME_StartGuard = 51）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_StartGuard_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_StartGuard_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_StartGuard, nflag, sMessage)
end

--@brief    偷取资源（HOME_StealWorkReward = 53）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_StealWorkReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_StealWorkReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_StealWorkReward, nflag, sMessage)
end

--@brief    偷盗日志（HOME_GetStealLog = 55）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_GetStealLog_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_GetStealLog_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_GetStealLog, nflag, sMessage)
end

--@brief    治疗伤口（HOME_Cure = 57）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorFamily:send_HOME_Cure_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorFamily:send_HOME_Cure_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_HOME, Protocol.HOME_Cure, nflag, sMessage)
end