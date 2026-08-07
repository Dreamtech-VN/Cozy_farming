--ProtocolProcessorKid.lua
--@brief	结婚礼堂相关协议
--@date  	2013/1/7
--@author 	叶威
--@note 	结婚礼堂相关协议


ProtocolProcessorKid = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorKid:regAll()
    -- --@brief    获取孩子公寓信息（WEDDING_GetHouseInfoOK = 58）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseInfoOK, "ProtocolProcessorKid:parse_WEDDING_GetHouseInfoOK", "isiiiivivivivivivivsvivivivivivivivivsviviviviviviviviviviiivivsvivivtvsviviviviviviviiivivsvtviviviviviivivi")
	--@brief	获取公寓建筑商店信息（WEDDING_GetHouseBuildingStoreOk = 62）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseBuildingStoreOk, "ProtocolProcessorKid:parse_WEDDING_GetHouseBuildingStoreOk", "vivsvivi")
	--@brief    生育、领养孩子（WEDDING_WEDDING_BearChildOk = 64）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_WEDDING_BearChildOk, "ProtocolProcessorKid:parse_WEDDING_WEDDING_BearChildOk", "iiiit")
    --@brief    决定孩子性别（WWEDDING_DecideChildSexOk = 66）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_DecideChildSexOk, "ProtocolProcessorKid:parse_WWEDDING_DecideChildSexOk", "iii")
    --@brief    雇佣保姆（WEDDING_HireNannyOk = 68）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_HireNannyOk, "ProtocolProcessorKid:parse_WEDDING_HireNannyOk", "iiivivivi")
    --@brief    跟孩子互动（WEDDING_ChildInteractOk = 70）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChildInteractOk, "ProtocolProcessorKid:parse_WEDDING_ChildInteractOk", "iiiiiii")
    --@brief    安抚孩子（WEDDING_AppeaseChildOk = 72）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_AppeaseChildOk, "ProtocolProcessorKid:parse_WEDDING_AppeaseChildOk", "iiii")
    --@brief    获得孩子的关爱buff（WEDDING_GetChildBuffOk = 76）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildBuffOk, "ProtocolProcessorKid:parse_WEDDING_GetChildBuffOk", "iiii")
	--@brief    新建建筑（WEDDING_AddHouseBuildingOk = 78）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_AddHouseBuildingOk, "ProtocolProcessorKid:parse_WEDDING_AddHouseBuildingOk", "iiiit")
    --@brief    移动建筑（WEDDING_MoveHouseBuildingOk = 80）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_MoveHouseBuildingOk, "ProtocolProcessorKid:parse_WEDDING_MoveHouseBuildingOk", "iiiit")
    --@brief    拆除建筑（WEDDING_RemoveHouseBuildingOk = 82）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveHouseBuildingOk, "ProtocolProcessorKid:parse_WEDDING_RemoveHouseBuildingOk", "iii")
    --@brief    获取排行榜（WWEDDING_GetHouseRankInfoOk = 84）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetHouseRankInfoOk, "ProtocolProcessorKid:parse_WWEDDING_GetHouseRankInfoOk", "vivivivivsvivivivtvi")
    --@brief    获取孩子状态（WEDDING_GetChildStatusOk = 86）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildStatusOk, "ProtocolProcessorKid:parse_WEDDING_GetChildStatusOk", "isiiiiiiiiiiisii")
    --@brief    推送公寓信息（WEDDING_GetHouseSummaryOk = 92）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseSummaryOk, "ProtocolProcessorKid:parse_WEDDING_GetHouseSummaryOk", "i")
    --@brief    拜访好友（WEDDING_VisitFriendOk = 109）157+       
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_VisitFriendOk, "ProtocolProcessorKid:parse_WEDDING_VisitFriendOk", "t")


	--@brief	获取孩子公寓信息（WEDDING_GetHouseInfo = 57）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseInfo, "ProtocolProcessorKid:send_WEDDING_GetHouseInfo_ErrorProcess", "is" )
	--@brief	获取公寓建筑商店信息（WEDDING_GetHouseBuildingStore = 61）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseBuildingStore, "ProtocolProcessorKid:send_WEDDING_GetHouseBuildingStore_ErrorProcess", "is" )
	--@brief	生育、领养孩子（WEDDING_WEDDING_BearChild = 63）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_WEDDING_BearChild, "ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild_ErrorProcess", "is" )
	--@brief	决定孩子性别（WWEDDING_DecideChildSex = 65）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_DecideChildSex, "ProtocolProcessorKid:send_WWEDDING_DecideChildSex_ErrorProcess", "is" )
	--@brief	雇佣保姆（WEDDING_HireNanny = 67）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_HireNanny, "ProtocolProcessorKid:send_WEDDING_HireNanny_ErrorProcess", "is" )
	--@brief	跟孩子互动（WEDDING_ChildInteract = 69）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChildInteract, "ProtocolProcessorKid:send_WEDDING_ChildInteract_ErrorProcess", "is" )
	--@brief	安抚孩子（WEDDING_AppeaseChild = 71）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_AppeaseChild, "ProtocolProcessorKid:send_WEDDING_AppeaseChild_ErrorProcess", "is" )
	--@brief    更换孩子时装（WEDDING_ChangeChildFashion = 73）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeChildFashion, "ProtocolProcessorKid:send_WEDDING_ChangeChildFashion_ErrorProcess", "is" )
	--@brief	获得孩子的关爱buff（WEDDING_GetChildBuff = 75）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildBuff, "ProtocolProcessorKid:send_WEDDING_GetChildBuff_ErrorProcess", "is" )
	--@brief    新建建筑（WEDDING_AddHouseBuilding = 77)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_AddHouseBuilding, "ProtocolProcessorKid:send_WEDDING_AddHouseBuilding_ErrorProcess", "is" )
    --@brief    移动建筑（WEDDING_MoveHouseBuilding = 79)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_MoveHouseBuilding, "ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding_ErrorProcess", "is" )
    --@brief    拆除建筑（WEDDING_RemoveHouseBuilding = 81)错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveHouseBuilding, "ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding_ErrorProcess", "is" )
    --@brief    获取排行榜（WWEDDING_GetHouseRankInfo = 83）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetHouseRankInfo, "ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo_ErrorProcess", "is" )
    --@brief    获取孩子状态（WEDDING_GetChildStatus = 85）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildStatus, "ProtocolProcessorKid:send_WEDDING_GetChildStatus_ErrorProcess", "is" )
    --@brief    获取公寓物品（WEDDING_GetHouseItemCache = 87）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseItemCache, "ProtocolProcessorKid:send_WEDDING_GetHouseItemCache_ErrorProcess", "is" )
    --@brief    拜访好友（WEDDING_VisitFriend = 108）157+     错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_VisitFriend, "ProtocolProcessorKid:send_WEDDING_VisitFriend_ErrorProcess", "is" )
    --@brief    决定孩子性别（WWEDDING_ChangeChildSexOk = 120）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildSexOk, "ProtocolProcessorKid:parse_WWEDDING_ChangeChildSexOk", "itt")
    --@brief    更改孩子名字（WWEDDING_ChangeChildNameOk = 122）
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildNameOk, "ProtocolProcessorKid:parse_WWEDDING_ChangeChildNameOk", "ist")
    --@brief    更改孩子名字（WWEDDING_ChangeChildName = 121）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildName, "ProtocolProcessorKid:send_WWEDDING_ChangeChildName_ErrorProcess", "is" )


end

--@brief    决定孩子性别（WWEDDING_ChangeChildSex = 119）
function ProtocolProcessorKid:send_WWEDDING_ChangeChildSex(childId, sex)
    WZLog("send_WWEDDING_ChangeChildSex")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildSex )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( tonumber(childId) )  -- 孩子ID
    sender:writeByte( tonumber(sex) ) -- 性别
    SendProtocol(sender,false) --true:showLoading
end
--@brief    决定孩子性别（WWEDDING_ChangeChildSexOk = 120）
function ProtocolProcessorKid:parse_WWEDDING_ChangeChildSexOk(childId, sex, status)
    -- childId : 孩子ID
    -- sex : 性别
    -- status : 1、邮件未领完 2、变性消耗材料不足
    WZLog("ProtocolProcessorKid:parse_WWEDDING_ChangeChildSexOk")
    GlobalGame:getGameEventDispathcer():Dispatch(KidEvent.KidEvent_ChangeSexResult,childId, sex, status)
end

--@brief    更改孩子名字（WWEDDING_ChangeChildName = 121）
function ProtocolProcessorKid:send_WWEDDING_ChangeChildName(childId, name )
    WZLog("send_WWEDDING_ChangeChildName")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildName )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( tonumber(childId) )  -- 孩子ID
    sender:writeString( tostring(name) )  -- 名字
    SendProtocol(sender,false) --true:showLoading
end
--@brief    更改孩子名字（WWEDDING_ChangeChildNameOk = 122）
function ProtocolProcessorKid:parse_WWEDDING_ChangeChildNameOk(childId, name, status)
    -- childId : 孩子ID
    -- name : 名字
    WZLog("ProtocolProcessorKid:parse_WWEDDING_ChangeChildNameOk", childId, name, status)
    WndKidDress:_onChildChangeNameResult(childId, name, status)
end
--@brief    更改孩子名字（WWEDDING_ChangeChildName = 121）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WWEDDING_ChangeChildName_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WWEDDING_ChangeChildName_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WWEDDING_ChangeChildName, nflag, sMessage)
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorKid:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取孩子公寓信息（WEDDING_GetHouseInfo = 57）
function ProtocolProcessorKid:send_WEDDING_GetHouseInfo(playerId )
	WZLog("send_WEDDING_GetHouseInfo",playerId)
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取公寓建筑商店信息（WEDDING_GetHouseBuildingStore = 61）
function ProtocolProcessorKid:send_WEDDING_GetHouseBuildingStore( )
	WZLog("send_WEDDING_GetHouseBuildingStore")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseBuildingStore )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	生育、领养孩子（WEDDING_WEDDING_BearChild = 63）
function ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild(actionType)
	WZLog("send_WEDDING_WEDDING_BearChild")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_WEDDING_BearChild)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( actionType )	-- 类型 1.生育 2.领养 3.获取状态
	SendProtocol(sender,false) --true:showLoading
end

--@brief    决定孩子性别（WWEDDING_DecideChildSex = 65）
function ProtocolProcessorKid:send_WWEDDING_DecideChildSex(childId, sex, name)
    WZLog("send_WWEDDING_DecideChildSex")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WWEDDING_DecideChildSex )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( childId )  -- 孩子ID
    sender:writeByte( sex )  -- 性别
    sender:writeString( name )  -- 孩子名字
    SendProtocol(sender,false) --true:showLoading
end

--@brief    雇佣保姆（WEDDING_HireNanny = 67）
function ProtocolProcessorKid:send_WEDDING_HireNanny(actionType, nannyId)
    WZLog("send_WEDDING_HireNanny")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_HireNanny )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( actionType )  -- 操作类型 1.雇佣 2.加时长
    sender:writeInt( nannyId )  -- 加時對應的Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    跟孩子互动（WEDDING_ChildInteract = 69）
function ProtocolProcessorKid:send_WEDDING_ChildInteract(kidId, actionType, x, y)
    WZLog("send_WEDDING_ChildInteract")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChildInteract )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( kidId )  -- 小孩Id
    sender:writeInt( actionType )  -- 操作类型 1.抚摸 2.玩摇摆车
    sender:writeInt( x or 0 )  -- 玩摇摆车X索引
    sender:writeInt( y or 0 )  -- 玩摇摆车Y索引
    SendProtocol(sender,false) --true:showLoading
end

--@brief    安抚孩子（WEDDING_AppeaseChild = 71）
function ProtocolProcessorKid:send_WEDDING_AppeaseChild(kidId, actionType, itemId, itemNum)
    WZLog("send_WEDDING_AppeaseChild", kidId, actionType, itemId, itemNum)
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_AppeaseChild )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( kidId )  -- 小孩Id
    sender:writeInt( actionType )  -- 1.哭闹 2.饥饿 3.尿裤子 4.小屋扩建
    sender:writeInt( itemId )  -- 物品Id
    sender:writeInt( itemNum )  -- 物品数量
    SendProtocol(sender,false) --true:showLoading
end

--@brief    更换孩子时装（WEDDING_ChangeChildFashion = 73）
function ProtocolProcessorKid:send_WEDDING_ChangeChildFashion(kidId, playerItemId)
    WZLog("send_WEDDING_ChangeChildFashion")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeChildFashion )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( kidId )  -- 小孩Id
    sender:writeInts( playerItemId )  -- 玩家时装物品Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获得孩子的关爱buff（WEDDING_GetChildBuff = 75）
function ProtocolProcessorKid:send_WEDDING_GetChildBuff(kidId)
    WZLog("send_WEDDING_GetChildBuff")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildBuff )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( kidId )  -- 小孩Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    新建建筑（WEDDING_AddHouseBuilding = 77)
function ProtocolProcessorKid:send_WEDDING_AddHouseBuilding(fromSource, configId, x, y, flipStatus )
    WZLog("send_WEDDING_AddHouseBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_AddHouseBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( fromSource ) -- 操作来源. 1.商店 2.背包 
    sender:writeInt( configId ) -- 建筑id
    sender:writeInt( x )    -- x坐标
    sender:writeInt( y )    -- y坐标
    sender:writeByte( flipStatus )  -- 翻转状态
    SendProtocol(sender,false) --true:showLoading
end

--@brief    移动建筑（WEDDING_MoveHouseBuilding = 79)
function ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding(xOrigin, yOrigin, xTarget, yTarget, flipStatus )
    WZLog("send_WEDDING_MoveHouseBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_MoveHouseBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xOrigin ) -- 起始x坐标
    sender:writeInt( yOrigin ) -- 起始y坐标
    sender:writeInt( xTarget ) -- 目标x坐标
    sender:writeInt( yTarget ) -- 目标y坐标
    sender:writeByte( flipStatus ) -- 翻转状态
    SendProtocol(sender,false) --true:showLoading
end

--@brief    拆除建筑（WEDDING_RemoveHouseBuilding = 81)
function ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding(xTarget, yTarget, itemId)
    WZLog("send_WEDDING_RemoveHouseBuilding")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveHouseBuilding )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( xTarget )  -- x坐标
    sender:writeInt( yTarget )  -- y坐标
    sender:writeInt( itemId )  -- 移除的建筑Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取排行榜（WWEDDING_GetHouseRankInfo = 83）
function ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo(rankType )
    WZLog("send_WWEDDING_GetHouseRankInfo")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetHouseRankInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( rankType )    -- 排行榜类型,1:本服,2:全服,3:好友 
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取孩子状态（WEDDING_GetChildStatus = 85）
function ProtocolProcessorKid:send_WEDDING_GetChildStatus(childId)
    WZLog("send_WEDDING_GetChildStatus")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildStatus )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( childId )  -- 孩子Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取公寓物品（WEDDING_GetHouseItemCache = 87）
function ProtocolProcessorKid:send_WEDDING_GetHouseItemCache()
    WZLog("send_WEDDING_GetHouseItemCache")
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseItemCache )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    拜访好友（WEDDING_VisitFriend = 108）157+     
function ProtocolProcessorKid:send_WEDDING_VisitFriend(friendId )
    WZLog("send_WEDDING_VisitFriend",friendId)
    local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_VisitFriend )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( friendId ) -- 好友id
    SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    获取孩子公寓信息（WEDDING_GetHouseInfoOK = 58）       
function ProtocolProcessorKid:parse_WEDDING_GetHouseInfoOK(playerId, houseName, sheerLuxury, bearLastTime, nannyStatus, nannyLastTime, configId, x, y, flipStatus, decoration, userId, userName, sex, headId, faceId, bodyId, wingId, headColor, bodyColor, childId, childName, childStatus, childSex, childLevel, childHeadId, childFaceId, childBodyId, growthValue, careValue, playCar, nextCheckTime, careBuffToday, bearChildId, childFight, childProp, touch, visitorIds, visitorSexs, visitorNames, visitorFaceIds, visitorHeadIds, visitorHeadColors, visitorBodyIds, visitorBodyColors, visitorWingIds, visitorTimes, visitingId, visitingTime, visitingChildIds, visitingChildNames, visitingChildSexs, visitingChildLevels, visitingChildHeadIds, visitingChildFaceIds, visitingChildBodyIds, visitingChildFight, expansionStatus, childHeadFrameId, visitingChildHeadFrameId)
    -- playerId : 目标玩家ID
    -- houseName : 公寓名称
    -- sheerLuxury : 舒适度
    -- bearLastTime : 剩余生育完成时间
    -- nannyStatus : 是否有保姆（0没有 1有）
    -- nannyLastTime : 剩余保姆照顾时间
    -- configId : 建筑ID
    -- x : x坐标
    -- y : y坐标
    -- flipStatus : 翻转状态
    -- decoration : 使用中的装饰品物品ID
    -- userId : 夫妻双方玩家ID
    -- userName : 玩家名
    -- sex : 性别
    -- headId : 头id
    -- faceId : 脸id
    -- bodyId : 身id
    -- wingId : 翅膀id
    -- headColor : 头颜色
    -- bodyColor : 身颜色
    -- childId : 孩子ID
    -- childName : 孩子名称
    -- childStatus : 孩子事件状态. 与 （1、2、4）分别进行按位与操作，如果不为0，则为对应的(哭闹、饥饿、尿裤子状态)
    -- childSex : 性别
    -- childLevel : 等级（除于10即为年龄）
    -- childHeadId : 孩子头
    -- childFaceId : 孩子脸
    -- childBodyId : 孩子身
    -- growthValue : 成长值
    -- careValue : 关爱值
    -- playCar : 今天是否玩过摇摇车. 0否 1是
    -- nextCheckTime : 距离孩子下次事件校验剩余时间
    -- careBuffToday : 今天是否获取过关爱buff 0否 1是
    -- bearChildId : 生育、领养中的孩子ID
    -- childFight : 孩子战力
    -- childProp : 孩子属性json
    -- touch : 今天是否抚摸过. 0否 1是
    -- visitorIds : 拜访者id  157+
    -- visitorSexs : 拜访者性别157+
    -- visitorNames : 拜访者名称157+
    -- visitorFaceIds : 拜访者形象157+
    -- visitorHeadIds : 拜访者形象157+
    -- visitorHeadColors : 拜访者形象157+
    -- visitorBodyIds : 拜访者形象157+
    -- visitorBodyColors : 拜访者形象157+
    -- visitorWingIds : 拜访者形象157+
    -- visitorTimes : 拜访开始时间 时间戳10位数157+ 
    -- visitingId : 访问中的好友ID157+
    -- visitingTime : 拜访时间157+
    -- visitingChildIds : 老王的孩子id157+
    -- visitingChildNames : 老王的孩子名字157+
    -- visitingChildSexs : 老王的孩子性别157+
    -- visitingChildLevels : 老王的孩子157+
    -- visitingChildHeadIds : 老王的孩子157+
    -- visitingChildFaceIds : 老王的孩子157+
    -- visitingChildBodyIds : 老王的孩子157+
    -- visitingChildFight : 老王的孩子战力157+
    -- expansionStatus : 扩建状态 0为扩建 1扩建到42
    -- childHeadFrameId : 孩子头像框
    -- visitingChildHeadFrameId : 老王孩子的头像框
    WZLog("ProtocolProcessorKid:parse_WEDDING_GetHouseInfoOK",
        "\nplayerId =",Serialize(VectorToTable(playerId)),
        "\nhouseName =",Serialize(VectorToTable(houseName)),
        "\nsheerLuxury =",Serialize(VectorToTable(sheerLuxury)),
        "\nbearLastTime =",Serialize(VectorToTable(bearLastTime)),
        "\nnannyStatus =",Serialize(VectorToTable(nannyStatus)),
        "\nnannyLastTime =",Serialize(VectorToTable(nannyLastTime)),
        "\nconfigId =",Serialize(VectorToTable(configId)),
        "\nx =",Serialize(VectorToTable(x)),
        "\ny =",Serialize(VectorToTable(y)),
        "\nflipStatus =",Serialize(VectorToTable(flipStatus)),
        "\ndecoration =",Serialize(VectorToTable(decoration)),
        "\nuserId =",Serialize(VectorToTable(userId)),
        "\nuserName =",Serialize(VectorToTable(userName)),
        "\nsex =",Serialize(VectorToTable(sex)),
        "\nheadId =",Serialize(VectorToTable(headId)),
        "\nfaceId =",Serialize(VectorToTable(faceId)),
        "\nbodyId =",Serialize(VectorToTable(bodyId)),
        "\nwingId =",Serialize(VectorToTable(wingId)),
        "\nheadColor =",Serialize(VectorToTable(headColor)),
        "\nbodyColor =",Serialize(VectorToTable(bodyColor)),
        "\nchildId =",Serialize(VectorToTable(childId)),
        "\nchildName =",Serialize(VectorToTable(childName)),
        "\nchildStatus =",Serialize(VectorToTable(childStatus)),
        "\nchildSex =",Serialize(VectorToTable(childSex)),
        "\nchildLevel =",Serialize(VectorToTable(childLevel)),
        "\nchildHeadId =",Serialize(VectorToTable(childHeadId)),
        "\nchildFaceId =",Serialize(VectorToTable(childFaceId)),
        "\nchildBodyId =",Serialize(VectorToTable(childBodyId)),
        "\ngrowthValue =",Serialize(VectorToTable(growthValue)),
        "\ncareValue =",Serialize(VectorToTable(careValue)),
        "\nplayCar =",Serialize(VectorToTable(playCar)),
        "\nnextCheckTime =",Serialize(VectorToTable(nextCheckTime)),
        "\ncareBuffToday =",Serialize(VectorToTable(careBuffToday)),
        "\nbearChildId =",Serialize(VectorToTable(bearChildId)),
        "\nchildFight =",Serialize(VectorToTable(childFight)),
        "\nchildProp =",Serialize(VectorToTable(childProp)),
        "\ntouch =",Serialize(VectorToTable(touch)),
        "\nvisitorIds =",Serialize(VectorToTable(visitorIds)),
        "\nvisitorSexs =",Serialize(VectorToTable(visitorSexs)),
        "\nvisitorNames =",Serialize(VectorToTable(visitorNames)),
        "\nvisitorFaceIds =",Serialize(VectorToTable(visitorFaceIds)),
        "\nvisitorHeadIds =",Serialize(VectorToTable(visitorHeadIds)),
        "\nvisitorHeadColors =",Serialize(VectorToTable(visitorHeadColors)),
        "\nvisitorBodyIds =",Serialize(VectorToTable(visitorBodyIds)),
        "\nvisitorBodyColors =",Serialize(VectorToTable(visitorBodyColors)),
        "\nvisitorWingIds =",Serialize(VectorToTable(visitorWingIds)),
        "\nvisitorTimes =",Serialize(VectorToTable(visitorTimes)),
        "\nvisitingId =",Serialize(VectorToTable(visitingId)),
        "\nvisitingTime =",Serialize(VectorToTable(visitingTime)),
        "\nvisitingChildIds =",Serialize(VectorToTable(visitingChildIds)),
        "\nvisitingChildNames =",Serialize(VectorToTable(visitingChildNames)),
        "\nvisitingChildSexs =",Serialize(VectorToTable(visitingChildSexs)),
        "\nvisitingChildLevels =",Serialize(VectorToTable(visitingChildLevels)),
        "\nvisitingChildHeadIds =",Serialize(VectorToTable(visitingChildHeadIds)),
        "\nvisitingChildFaceIds =",Serialize(VectorToTable(visitingChildFaceIds)),
        "\nvisitingChildBodyIds =",Serialize(VectorToTable(visitingChildBodyIds)),
        "\nvisitingChildFight =",Serialize(VectorToTable(visitingChildFight)),
        "\nexpansionStatus = ",expansionStatus)

    SceneKidHome:setData(playerId, houseName, sheerLuxury, bearLastTime, nannyLastTime, nannyStatus, VectorToTable(configId), VectorToTable(flipStatus), VectorToTable(x), VectorToTable(y)
        , VectorToTable(decoration), VectorToTable(userId), VectorToTable(userName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId)
        , VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(childId), VectorToTable(childName), VectorToTable(childStatus), VectorToTable(childSex), VectorToTable(childLevel)
        , VectorToTable(childHeadId), VectorToTable(childFaceId), VectorToTable(childBodyId), VectorToTable(growthValue), VectorToTable(careValue), VectorToTable(playCar), VectorToTable(nextCheckTime)
        , careBuffToday, bearChildId, VectorToTable(childFight), VectorToTable(childProp), VectorToTable(touch)
        , VectorToTable(visitorIds), VectorToTable(visitorSexs), VectorToTable(visitorNames), VectorToTable(visitorFaceIds), VectorToTable(visitorHeadIds), VectorToTable(visitorHeadColors), VectorToTable(visitorBodyIds)
        , VectorToTable(visitorBodyColors), VectorToTable(visitorWingIds), VectorToTable(visitorTimes), visitingId, visitingTime, VectorToTable(visitingChildIds), VectorToTable(visitingChildNames)
        , VectorToTable(visitingChildSexs), VectorToTable(visitingChildLevels), VectorToTable(visitingChildHeadIds), VectorToTable(visitingChildFaceIds), VectorToTable(visitingChildBodyIds), VectorToTable(visitingChildFight)
        , expansionStatus, VectorToTable(childHeadFrameId), VectorToTable(visitingChildHeadFrameId))
end


--@brief	获取公寓建筑商店信息（WEDDING_GetHouseBuildingStoreOk = 62）
function ProtocolProcessorKid:parse_WEDDING_GetHouseBuildingStoreOk(itemId, cost, buyNum, limitNum)
	-- itemId : 物品ID
	-- cost : 购买价格
	-- buyNum : 已购买数量
	-- limitNum : 限购数量
	WZLog("ProtocolProcessorKid:parse_WEDDING_GetHouseBuildingStoreOk")

	SceneKidHome:getBuildingsAndOrnaments(VectorToTable(itemId), VectorToTable(cost), VectorToTable(buyNum), VectorToTable(limitNum))
end

--@brief    生育、领养孩子（WEDDING_WEDDING_BearChildOk = 64）
function ProtocolProcessorKid:parse_WEDDING_WEDDING_BearChildOk(actionType, status, pregantRate, childId, sex)
	-- actionType : 类型 1.生育 2.领养 3.获取
    -- status : 结果. 1.成功 2.失败
    -- pregantRate : 怀孕成功概率
    -- childId : 孩子ID
    -- sex : 默认性别
    WZLog("ProtocolProcessorKid:parse_WEDDING_WEDDING_BearChildOk")
    
    WndKidBorn:getBornInfoOK(actionType, status, pregantRate, childId, sex)
end

--@brief    决定孩子性别（WWEDDING_DecideChildSexOk = 66）
function ProtocolProcessorKid:parse_WWEDDING_DecideChildSexOk(lastTime, kidId, result)
	-- lastTime : 怀孕、领养剩余时间
    -- kidId : 怀孕的孩子Id
    -- result : 结果标识
    WZLog("ProtocolProcessorKid:parse_WWEDDING_DecideChildSexOk")
    
    WndKidBorn:setKidNameAndSexOK(lastTime, kidId, result)
end

--@brief    雇佣保姆（WEDDING_HireNannyOk = 68）
function ProtocolProcessorKid:parse_WEDDING_HireNannyOk(actionType, lastTime, bearLastTime, childId, childStatus, growthValue)
	-- actionType : 操作类型 1.雇佣 2.续时长
	-- lastTime : 保姆剩余时间
	-- bearLastTime : 生育中孩子的剩余时间
	-- childId : 孩子ID
	-- childStatus : 孩子事件状态. 与 （1、2、4）分别进行按位与操作，如果不为0，则为对应的(哭闹、饥饿、尿裤子状态)
	-- growthValue : 孩子成长值
    WZLog("ProtocolProcessorKid:parse_WEDDING_HireNannyOk", actionType, lastTime, bearLastTime)
    
    if actionType == 1 then
    	WndKidServant:servantSuccess(lastTime)
    else
    	WndKidServant:addServantTimeOK(lastTime, bearLastTime, VectorToTable(childId), VectorToTable(childStatus), VectorToTable(growthValue))
    end
end

--@brief    跟孩子互动（WEDDING_ChildInteractOk = 70）
function ProtocolProcessorKid:parse_WEDDING_ChildInteractOk(childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
	-- childId : 孩子ID
	-- actionType : 操作类型 1.抚摸 2.玩摇摆车
	-- careValue : 孩子关爱值
    --nIndexX, nIndexY ：摇摇车的索引
    -- playCar : 是否玩过摇摇车
    -- touch : 是否抚摸过
    WZLog("ProtocolProcessorKid:parse_WEDDING_ChildInteractOk")
    SceneKidHome:stopRoleRun(2, childId)
    if actionType == 1 then
        SceneKidHome:touchKidSuccess(childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
    else
        WndParentsCare:careOrPlayCarSuccess(childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
    end
end

--@brief    安抚孩子（WEDDING_AppeaseChildOk = 72）
function ProtocolProcessorKid:parse_WEDDING_AppeaseChildOk(childId, actionType, childStatus, growthValue)
	-- childId : 孩子ID
	-- actionType : 1.哭闹 2.饥饿 3.尿裤子 4.小屋扩建
	-- childStatus : 孩子事件状态. 与 （1、2、4）分别进行按位与操作，如果不为0，则为对应的(哭闹、饥饿、尿裤子状态)
	-- growthValue : 孩子成长值
    WZLog("ProtocolProcessorKid:parse_WEDDING_AppeaseChildOk", childId, actionType, childStatus, growthValue)
    
    SceneKidHome:kidStateOperateSuccess(childId, actionType, childStatus, growthValue)
end

--@brief    获得孩子的关爱buff（WEDDING_GetChildBuffOk = 76）
function ProtocolProcessorKid:parse_WEDDING_GetChildBuffOk(childId)
	-- childId : 孩子ID
    WZLog("ProtocolProcessorKid:parse_WEDDING_GetChildBuffOk")
    
    WndParentsCare:careBuffSuccess(childId)
end

--@brief    新建建筑（WEDDING_AddHouseBuildingOk = 78）
function ProtocolProcessorKid:parse_WEDDING_AddHouseBuildingOk(fromSource, configId, x, y, flipStatus)
	-- fromSource : 操作来源. 1.商店 2.背包 
    -- configId : 建筑id
    -- x : x坐标
    -- y : y坐标
    -- flipStatus : 翻转状态
    WZLog("ProtocolProcessorKid:parse_WEDDING_AddHouseBuildingOk")
    SceneKidHome:buildNewBuildingOK(configId, x, y, flipStatus, fromSource)
end

--@brief    移动建筑（WEDDING_MoveHouseBuildingOk = 80）
function ProtocolProcessorKid:parse_WEDDING_MoveHouseBuildingOk(xOrigin, yOrigin, xTarget, yTarget, flipStatus)
    -- xOrigin : 起始x坐标
    -- yOrigin : 起始y坐标
    -- xTarget : 目标x坐标
    -- yTarget : 目标y坐标
    -- flipStatus : 翻转状态
    WZLog("ProtocolProcessorKid:parse_WEDDING_MoveHouseBuildingOk")

    SceneKidHome:buildingMoveOK({xOrigin}, {yOrigin}, {xTarget}, {yTarget}, {flipStatus})
end

--@brief    拆除建筑（WEDDING_RemoveHouseBuildingOk = 82）
function ProtocolProcessorKid:parse_WEDDING_RemoveHouseBuildingOk(xTarget, yTarget, itemId)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- itemId : 移除的建筑Id
    WZLog("ProtocolProcessorKid:parse_WEDDING_RemoveHouseBuildingOk")

    SceneKidHome:buildingRemoveOK(xTarget, yTarget, itemId)
end


--@brief    获取排行榜（WWEDDING_GetHouseRankInfoOk = 84）
function ProtocolProcessorKid:parse_WWEDDING_GetHouseRankInfoOk(rank, playerId, serverId, childId, childName, level, headId, faceId, sex, headFrameId)
    -- rank : 排名
    -- playerId : 玩家id
    -- serverId : 区服id
    -- childId :  小孩Id
    -- childName : 小孩名称
    -- level : 小孩等级
    -- headId : 头部id
    -- faceId : 脸部id
    -- sex : 性别
    -- headFrameId : 小孩头像框Id
    WZLog("ProtocolProcessorKid:parse_WWEDDING_GetHouseRankInfoOk")

    if WndKidOperate.m_root then
        WndKidOperate:setData(VectorToTable(rank), VectorToTable(playerId), VectorToTable(serverId), VectorToTable(childId), VectorToTable(childName), VectorToTable(level), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(headFrameId))
    end
end

--@brief    获取孩子状态（WEDDING_GetChildStatusOk = 86）
function ProtocolProcessorKid:parse_WEDDING_GetChildStatusOk(childId, childName, childStatus, childSex, childLevel, childHeadId, childFaceId, childBodyId, growthValue, careValue, playCar, nextCheckTime, childFight, childProp, touch, headEffectId)
    -- xTarget : x坐标
    -- yTarget : y坐标
    -- headEffectId:小孩头像框
    WZLog("ProtocolProcessorKid:parse_WEDDING_GetChildStatusOk")

    SceneKidHome:updateKidData(childId, childName, childStatus, childSex, childLevel, childHeadId, childFaceId, childBodyId, growthValue, careValue, playCar, nextCheckTime, childFight, childProp, touch, headEffectId)
end

--@brief    推送公寓信息（WEDDING_GetHouseSummaryOk = 92）
function ProtocolProcessorKid:parse_WEDDING_GetHouseSummaryOk(comfirtValue)
    -- comfirtValue : 舒适度
    WZLog("ProtocolProcessorKid:parse_WEDDING_GetHouseSummaryOk")

    SceneKidHome:updateComfirtValue(comfirtValue)
end

--@brief    拜访好友（WEDDING_VisitFriendOk = 109）157+       
function ProtocolProcessorKid:parse_WEDDING_VisitFriendOk(result)
    -- result : 1成功 | 2不是好友关系 | 3你已经拜访了其他玩家 | 4过多拜访者了 | 5不能拜访自己的家喔
    WZLog("ProtocolProcessorKid:parse_WEDDING_VisitFriendOk", result)
    WndKidOperate:getVisitFriendOk(result)
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取孩子公寓信息（WEDDING_GetHouseInfo = 57）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_GetHouseInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_GetHouseInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseInfo, nflag, sMessage)
end

--@brief	获取公寓建筑商店信息（WEDDING_GetHouseBuildingStore = 61）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_GetHouseBuildingStore_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_GetHouseBuildingStore_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseBuildingStore, nflag, sMessage)
end

--@brief	生育、领养孩子（WEDDING_WEDDING_BearChild = 63）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_WEDDING_BearChild, nflag, sMessage)
end

--@brief	决定孩子性别（WWEDDING_DecideChildSex = 65）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WWEDDING_DecideChildSex_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WWEDDING_DecideChildSex_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WWEDDING_DecideChildSex, nflag, sMessage)
    WndKidBorn:setTouchLimit(true)
end

--@brief	雇佣保姆（WEDDING_HireNanny = 67）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_HireNanny_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_HireNanny_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_HireNanny, nflag, sMessage)
end

--@brief	跟孩子互动（WEDDING_ChildInteract = 69）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_ChildInteract_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_ChildInteract_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_ChildInteract, nflag, sMessage)
end

--@brief	安抚孩子（WEDDING_AppeaseChild = 71）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_AppeaseChild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_AppeaseChild_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_AppeaseChild, nflag, sMessage)
end

--@brief	更换孩子时装（WEDDING_ChangeChildFashion = 73）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_ChangeChildFashion_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_ChangeChildFashion_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeChildFashion, nflag, sMessage)
end

--@brief	获得孩子的关爱buff（WEDDING_GetChildBuff = 75）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_GetChildBuff_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorKid:send_WEDDING_GetChildBuff_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildBuff, nflag, sMessage)
end

--@brief    新建建筑（WEDDING_AddHouseBuilding = 77)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_AddHouseBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_AddHouseBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_AddHouseBuilding, nflag, sMessage)
end

--@brief    移动建筑（WEDDING_MoveHouseBuilding = 79)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_MoveHouseBuilding, nflag, sMessage)
end

--@brief    拆除建筑（WEDDING_RemoveHouseBuilding = 81)错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveHouseBuilding, nflag, sMessage)
end

--@brief    获取排行榜（WWEDDING_GetHouseRankInfo = 83）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WWEDDING_GetHouseRankInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetHouseRankInfo, nflag, sMessage)
end

--@brief    获取孩子状态（WEDDING_GetChildStatus = 85）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_GetChildStatus_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_GetChildStatus_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetChildStatus, nflag, sMessage)
end

--@brief    获取公寓物品（WEDDING_GetHouseItemCache = 87）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_GetHouseItemCache_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_GetHouseItemCache_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetHouseItemCache, nflag, sMessage)
end

--@brief    拜访好友（WEDDING_VisitFriend = 108）157+     错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKid:send_WEDDING_VisitFriend_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKid:send_WEDDING_VisitFriend_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_VisitFriend, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


