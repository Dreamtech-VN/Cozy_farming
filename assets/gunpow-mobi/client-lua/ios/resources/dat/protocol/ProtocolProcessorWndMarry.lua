--ProtocolProcessorWndMarry.lua
--@brief	结婚礼堂相关协议
--@date  	2013/1/7
--@author 	叶威
--@note 	结婚礼堂相关协议


ProtocolProcessorWndMarry = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndMarry:regAll()
	--@brief	获取婚姻状况成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMaritalStatusOK, "ProtocolProcessorWndMarry:parse_WEDDING_GetMaritalStatusOK", "tisti")

	--@brief	获取求婚信
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryRecordList, "ProtocolProcessorWndMarry:parse_WEDDING_GetMarryRecordList", "vivsvtvivivivivivi")

	--@brief	发送求婚信成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendLoveLetterOK, "ProtocolProcessorWndMarry:parse_WEDDING_SendLoveLetterOK", "t")

	--@brief	更改婚姻状态成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeMarryStatusOK, "ProtocolProcessorWndMarry:parse_WEDDING_ChangeMarryStatusOK", "bst")

	--@brief	解除婚姻关系成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveEngagementOK , "ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementOK", "")


	--@brief	赠送钻石成功
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GiveDiamondOK, "ProtocolProcessorWndMarry:parse_WEDDING_GiveDiamondOK", "isi")

	--@brief	获取婚姻状况错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMaritalStatus, "ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus_ErrorProcess", "is" )

	--@brief	发送求婚信/结婚函错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendLoveLetter, "ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter_ErrorProcess", "is" )

	--@brief	获取求婚信内容错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLetterInfo, "ProtocolProcessorWndMarry:send_WEDDING_GetLoveLetterInfo_ErrorProcess", "is" )

	--@brief	更改婚姻状态错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeMarryStatus, "ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus_ErrorProcess", "is" )

	--@brief	解除关系（用于离婚和解除订婚）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveEngagement, "ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement_ErrorProcess", "is" )

	--@brief	赠送钻石错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GiveDiamond, "ProtocolProcessorWndMarry:send_WEDDING_GiveDiamond_ErrorProcess", "is" )

	--@brief	获得异性发来的求婚信/结婚函给
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendLoveLetterToCouple, "ProtocolProcessorWndMarry:parse_WEDDING_SendLoveLetterToCouple", "stttiiiii")
	--@brief	收到婚姻状态更改的消息
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendMarryStatusToCouple, "ProtocolProcessorWndMarry:parse_WEDDING_SendMarryStatusToCouple", "bst")
	--@brief	收到婚姻关系解除消息
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveEngagementToCouple, "ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementToCouple", "si")

	--@brief	返回可举办婚礼时间（WEDDING_SendCanWedTime = 21)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCanWedTime, "ProtocolProcessorWndMarry:parse_WEDDING_SendCanWedTime", "vivsvs")

	--@brief	发送请柬（WEDDING_SendCard =18）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCard, "ProtocolProcessorWndMarry:send_WEDDING_SendCard_ErrorProcess", "is" )

	--@brief	发送请柬结果（WEDDING_SendCardOK =19）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCardOK, "ProtocolProcessorWndMarry:parse_WEDDING_SendCardOK", "")

	--@brief	发送请柬给朋友（WEDDING_SendCardToFriend =20）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCardToFriend, "ProtocolProcessorWndMarry:parse_WEDDING_SendCardToFriend", "vsvsvivtvt")


	--@brief	夫妻关系（WEDDING_GetMarryInfo = 44）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryInfo, "ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo_ErrorProcess", "is" )

	--@brief	夫妻关系结果（WEDDING_GetMarryInfoOK = 45）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryInfoOK, "ProtocolProcessorWndMarry:parse_WEDDING_GetMarryInfoOK", "ssiniiiiiiiiiiiiii")

	--@brief	恩爱等级升级（WEDDING_UpLoveLevel= 46）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_UpLoveLevel, "ProtocolProcessorWndMarry:parse_WEDDING_UpLoveLevel", "sn")

	--@brief	恩爱日志（WEDDING_GetLoveLog = 47）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLog, "ProtocolProcessorWndMarry:send_WEDDING_GetLoveLog_ErrorProcess", "is" )

	--@brief	恩爱日志结果（WEDDING_GetLoveLogOK = 48）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLogOK, "ProtocolProcessorWndMarry:parse_WEDDING_GetLoveLogOK", "vtvivsvsvsvi")

	--@brief	发送礼物（WEDDING_SendGift = 49）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendGift , "ProtocolProcessorWndMarry:send_WEDDING_SendGift _ErrorProcess", "is" )

	--@brief	发送礼物结果（WEDDING_SendGiftOK = 50）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendGiftOK, "ProtocolProcessorWndMarry:parse_WEDDING_SendGiftOK", "")

	--@brief	获取离婚信息（WWEDDING_GetRemoveEngageStatus = 93）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetRemoveEngageStatus , "ProtocolProcessorWndMarry:send_WWEDDING_GetRemoveEngageStatus _ErrorProcess", "is" )
	--@brief	获取离婚信息（WWEDDING_GetRemoveEngageStatusOk = 94）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetRemoveEngageStatusOk, "ProtocolProcessorWndMarry:parse_WWEDDING_GetRemoveEngageStatusOk", "iivivivtvsvivivivivs")

	--@brief	离婚孩子分配结果（WEDDING_GetDivorceResultOk = 95）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetDivorceResultOk, "ProtocolProcessorWndMarry:parse_WEDDING_GetDivorceResultOk", "vivsvivsvtvivivivivs")
	--@brief	获取孩子分配信息（WEDDING_GetAllotChildInfoOk = 96）
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetAllotChildInfoOk, "ProtocolProcessorWndMarry:parse_WEDDING_GetAllotChildInfoOk", "iiivivtvsvivivivivivs")
	--@brief	选择孩子（WEDDING_SelectChild = 97）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_WEDDING, Protocol.WEDDING_SelectChild, "ProtocolProcessorWndMarry:send_WEDDING_SelectChild_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndMarry:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取婚姻状况
function ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus()
	WZLog("send_WEDDING_GetMaritalStatus")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMaritalStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
	WZLog("WndMarryManager.m_nLoadingId = ",WndMarryManager.m_nLoadingId)
end

--@brief	发送求婚信/结婚函
function ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter(playerId, marryMark,marryType,timeIndex)
	WZLog("send_WEDDING_SendLoveLetter  ")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendLoveLetter )
	if sender==nil then WZLog("sender == nil") return end
	
	sender:writeInt( playerId )	-- 收件人Id
	sender:writeByte( marryMark )	-- 婚姻标识：1、订婚，2、结婚
	sender:writeByte( marryType )	-- 【订婚：1鲜花，2戒指，3银行卡，4金钥匙】【结婚：1代表奢华，2:豪华，3:浪漫，4：普通】
	sender:writeByte( timeIndex )   -- 婚礼开始时间（订婚：-1，结婚是相应的编号）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取求婚信内容
function ProtocolProcessorWndMarry:send_WEDDING_GetLoveLetterInfo(marryRecordId )
	WZLog("send_WEDDING_GetLoveLetterInfo")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLetterInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( marryRecordId )	-- 要获取的求婚信Id
	SendProtocol(sender,false) --true:showLoading
    WndMarryManager:createLoading()
end

--@brief	发送请柬（WEDDING_SendCard =18）
function ProtocolProcessorWndMarry:send_WEDDING_SendCard(playerId,cardType,playerType)
	WZLog("send_WEDDING_SendCard")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCard )
	if sender==nil then WZLog("sender == nil") return end
    sender:writeInts(playerId)
	sender:writeByte( cardType )	-- 请柬类型1、土豪，2、精美，3、普通
	sender:writeByte(playerType)
	SendProtocol(sender,false) --true:showLoading

end

--@brief	发送请柬结果（WEDDING_SendCardOK =19）
function ProtocolProcessorWndMarry:parse_WEDDING_SendCardOK()
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendCardOK")
	MsgBoxManager:showTipBox(LocalStrings.SEND_WEDDING_CARD_TIP)
	WndMarryManager:closeLoading()
end

--@brief	发送请柬给朋友（WEDDING_SendCardToFriend =20）
function ProtocolProcessorWndMarry:parse_WEDDING_SendCardToFriend(manName, womanName, startDate, cardType ,marryType)
	-- manName : 男方姓名
	-- womanName : 女方姓名
	-- startDate : 婚礼开始时间
	-- cardType : 请柬类型
	-- marryType : 婚礼类型
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendCardToFriend ",tostring(marryType))

    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
	WndMarryParty:getInCard(VectorToTable(manName), VectorToTable(womanName), VectorToTable(startDate), VectorToTable(cardType),VectorToTable(marryType))
end

--@brief	更改婚姻状态（WEDDING_ChangeMarryStatus = 8）
function ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus(isAgree, marryRecordId,timeIndex)
	WZLog("send_WEDDING_ChangeMarryStatus")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeMarryStatus)
	if sender==nil then WZLog("sender == nil") return end

	sender:writeBoolean( isAgree )	-- 是否同意
	sender:writeInt(marryRecordId)  --结婚记录
	sender:writeByte( timeIndex )	--婚礼开始时间（订婚：-1，结婚是相应的ID）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	解除关系（用于离婚和解除订婚）
function ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement(childId)
	WZLog("send_WEDDING_RemoveEngagement")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveEngagement )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(childId)	-- 离婚选择的小孩Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	赠送钻石
function ProtocolProcessorWndMarry:send_WEDDING_GiveDiamond(coupleId, diamondCountGive )
	WZLog("send_WEDDING_GiveDiamond")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GiveDiamond )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( coupleId )	-- 伴侣Id
	sender:writeInt( diamondCountGive )	-- 所需要的钻石数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取角色信息
function ProtocolProcessorWndMarry:send_PLAYER_GetPlayerInfo( noviceTutorials )
	WZLog("send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( noviceTutorials )	-- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end

--@brief	夫妻关系（WEDDING_GetMarryInfo = 44）
function ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
	WZLog("send_WEDDING_GetMarryInfo")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	恩爱日志（WEDDING_GetLoveLog = 47）
function ProtocolProcessorWndMarry:send_WEDDING_GetLoveLog( )
	WZLog("send_WEDDING_GetLoveLog")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLog )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	发送礼物（WEDDING_SendGift = 49）
function ProtocolProcessorWndMarry:send_WEDDING_SendGift (playerItemId )
	WZLog("send_WEDDING_SendGift ")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_SendGift  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerItemId )	-- 玩家物品id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取离婚信息（WWEDDING_GetRemoveEngageStatus = 93）
function ProtocolProcessorWndMarry:send_WWEDDING_GetRemoveEngageStatus()
	WZLog("send_WWEDDING_GetRemoveEngageStatus")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetRemoveEngageStatus )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择孩子（WEDDING_SelectChild = 97）
function ProtocolProcessorWndMarry:send_WEDDING_SelectChild(childId)
	WZLog("send_WEDDING_SelectChild")
	local sender = Protocol:getSender( Protocol.MAIN_WEDDING, Protocol.WEDDING_SelectChild )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(childId)	-- 离婚选择的小孩Id
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取婚姻状况成功
function ProtocolProcessorWndMarry:parse_WEDDING_GetMaritalStatusOK(marryStatus, coupleId, coupleName, weddingType,wedTime)
	-- marryStatus : 婚姻状态（0：表示未婚，1：表示已订婚，2：表示已婚未放动画，3：已婚）
	-- coupleId : 伴侣的Id
	-- coupleName : 伴侣名称
	-- weddingType : 婚礼类型（0：无，1：奢华，2：豪华，3：浪漫，4：普通）
	-- wedTime : 距离结婚时间的秒数（只有等待结婚的人才有，订婚或已经结过婚的为-1，正在进行中是0）
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetMaritalStatusOK")

	 --关闭加载框
	WZLog("WndMarryManager.m_nLoadingId = ",WndMarryManager.m_nLoadingId)
	WndMarryManager:closeLoading()
	WndMarryManager:getMarryStatusOK(marryStatus, coupleId, coupleName, weddingType, wedTime)
end

--@brief 获得异性发送的求婚信/结婚函
--@brief sendName : 发送人名称
--@brief marryType : 【订婚：1鲜花，2戒指，3银行卡，4金钥匙】 【结婚：1奢华，2:豪华，3:浪漫，4：普通】
--@brief marryMark : 婚姻状况标识(0是订婚，1是结婚)
--@brief timeIndex	:婚礼开始时间（订婚：-1，结婚是相应的ID）
--@brief marryRecordId : 结婚记录Id
function ProtocolProcessorWndMarry:parse_WEDDING_SendLoveLetterToCouple(sendName, marryType, marryMark,timeIndex,marryRecordId,sendFaceId,sendHeadId,playerId,headColor)
    WndMarryManager:closeLoading()
    WndMarryManager:getMarryLetterFromOther(sendName, marryType, marryMark,timeIndex,marryRecordId,sendFaceId,sendHeadId,playerId,headColor)
end

--@brief	收到婚姻状态更改消息
function ProtocolProcessorWndMarry:parse_WEDDING_SendMarryStatusToCouple(isAgree, coupleName, marryMark)
	-- boolIsWillingPropose : 是否同意
	-- coupleName : 伴侣名称
	-- marryMark : 婚姻状况标识(0是订婚，1是结婚)
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendMarryStatusToCouple")
	WndMarryManager:closeLoading()
    WndMarryManager:changeMarryStatusToCoupleOK(isAgree, coupleName, marryMark)
end

--@brief	收到解除婚姻关系的消息
function ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementToCouple(coupleName, marryMark)
	-- coupleName : 伴侣名称
	-- marryMark : 婚姻状况标识(1是订婚，2是结婚)
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementToCouple")
	WndMarryManager:closeLoading()
    WndMarryManager:getRemoveEngagementToCouple(coupleName, marryMark)
end

--@brief	获取求婚信
function ProtocolProcessorWndMarry:parse_WEDDING_GetMarryRecordList(marryRecordId, sendPlayerName, marryType,sendTime,headIds,faceIds,levels,playerId,headColors)
	-- marryMailId : 求婚信的Id
	-- sendPlayerName : 求婚人名称
	-- marryType : 类型【1鲜花，2戒指，3银行，4钥匙】
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetMarryRecordList")
    WndMarryManager:closeLoading()
    WndMarryManager:getMarryLetterOK(marryRecordId, sendPlayerName, marryType,sendTime,headIds,faceIds,levels,playerId,headColors)

end

--@brief	发送求婚信成功
function ProtocolProcessorWndMarry:parse_WEDDING_SendLoveLetterOK(result)
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendLoveLetterOK ",result)
	WndMarryManager:closeLoading()
	WndMarryManager:_showMarryLetterTips(result)
end


--@brief	更改婚姻状态成功
function ProtocolProcessorWndMarry:parse_WEDDING_ChangeMarryStatusOK(isAgree, coupleName, marryMark)
	-- boolIsWillingPropose : 是否同意
	-- coupleName : 伴侣名称
	-- marryMark : 婚姻状况标识(0是订婚，1是结婚)
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_ChangeMarryStatusOK")
	WndMarryManager:closeLoading()
    WndMarryManager:changeMarryStatusOK(isAgree, coupleName, marryMark)
end

--@brief	解除婚姻关系成功
function ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementOK()
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_RemoveEngagementOK")
	WndMarryManager:closeLoading()
	WndMarryManager:getRemoveEngagementToCouple(nil,nil)
end


--@brief	赠送钻石成功
function ProtocolProcessorWndMarry:parse_WEDDING_GiveDiamondOK(diamondCountGive, coupleName, giveId)
	-- diamondCountGive : 所赠送的钻石数
	-- coupleName : 伴侣名称
	-- giveId : 赠送人Id
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GiveDiamondOK")
	WndMarryManager:closeLoading()
    WndMarryManager:getGiveDiamondOK(diamondCountGive, coupleName, giveId)
end

--@brief	返回可举办婚礼时间（WEDDING_SendCanWedTime = 21)
function ProtocolProcessorWndMarry:parse_WEDDING_SendCanWedTime(timeId, startTime, endTime)
	-- timeId : 时间ID
	-- startTime : 开始时间
	-- endTime : 结束时间
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendCanWedTime")
	WndMarryManager:closeLoading()
	WndMarryHoll:getCanWedTime(timeId, startTime, endTime)
end

--@brief	夫妻关系结果（WEDDING_GetMarryInfoOK = 45）
function ProtocolProcessorWndMarry:parse_WEDDING_GetMarryInfoOK(manName, womanName, loveExp, loveLevel, giftNum, manHeadId, manFaceId, manBodyId, manWingId, womanHeadId, womanFaceId, womanBodyId, womanWingId,partnerId,manHeadColor,manBodyColor,womanHeadColor,womanBodyColor)
	-- manName : 男方名称
	-- womanName : 女方名称
	-- loveExp : 恩爱经验
	-- loveLevel : 恩爱等级
	-- giftNum : 礼物剩余次数
	-- manHeadId : 头
	-- manFaceId : 脸
	-- manBodyId : 身
	-- manWingId : 翅膀
	-- womanHeadId : 头id
	-- womanFaceId : 脸id
	-- womanBodyId : 身id
	-- womanWingId : 翅膀id
	-- partnerId：伴侣ID
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetMarryInfoOK =",giftNum)
	WndMarryManager:closeLoading()
	SceneMarryWedding:receivePropInfo(manName,womanName,loveExp,loveLevel,giftNum,manHeadId, manFaceId, manBodyId, manWingId, womanHeadId, womanFaceId, womanBodyId, womanWingId,partnerId,manHeadColor,manBodyColor,womanHeadColor,womanBodyColor)
end

--@brief	恩爱等级升级（WEDDING_UpLoveLevel= 46）
function ProtocolProcessorWndMarry:parse_WEDDING_UpLoveLevel(coupleName, loveLevel)
	-- coupleName : 对方名称
	-- loveLevel : 恩爱等级
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_UpLoveLevel")
	WndMarryManager:closeLoading()
	WndLovingLevelUpgrade:showLovingUpgrade(loveLevel)
end

--@brief	恩爱日志结果（WEDDING_GetLoveLogOK = 48）
function ProtocolProcessorWndMarry:parse_WEDDING_GetLoveLogOK(logType, createDate, leftPlayerName, rightPlayerName, itemName, loveExp)
	-- logType : 日志类型
	-- createDate : 创建时间（秒）
	-- leftPlayerName : 左边名称 
	-- rightPlayerName : 右边名称 
	-- itemName : 物品名称
	-- loveExp : 恩爱值
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetLoveLogOK")
	WndMarryManager:closeLoading()
	SceneMarryWedding:getLovingDaily(VectorToTable(logType),VectorToTable(createDate),VectorToTable(leftPlayerName),VectorToTable(rightPlayerName),VectorToTable(itemName),VectorToTable(loveExp))
end

--@brief	发送礼物结果（WEDDING_SendGiftOK = 50）
function ProtocolProcessorWndMarry:parse_WEDDING_SendGiftOK()
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_SendGiftOK")
	WndMarryManager:closeLoading()
	SceneMarryWedding:sendGiftResult()
end

--@brief	获取离婚信息（WWEDDING_GetRemoveEngageStatusOk = 94）
function ProtocolProcessorWndMarry:parse_WWEDDING_GetRemoveEngageStatusOk(fatherDevote, motherDevote, ownerId, childId, sex, childName, headId, faceId, level, childFight, childProp)
	-- fatherDevote : 父亲贡献度
	-- motherDevote : 母亲贡献度
	-- ownerId : 孩子所属玩家Id
	-- childId : 小孩Id
	-- sex : 小孩性别
	-- childName : 小孩名字
	-- headId : 小孩头Id
	-- faceId : 小孩脸Id
	-- level : 小孩等级
	-- childFight : 小孩战力
	-- childProp : 小孩属性
	WZLog("ProtocolProcessorWndMarry:parse_WWEDDING_GetRemoveEngageStatusOk")
	WndMarryManager:closeLoading()
	SceneMarryWedding:getKidDataOK(fatherDevote, motherDevote, VectorToTable(ownerId), VectorToTable(childId), VectorToTable(sex), VectorToTable(childName), VectorToTable(headId), VectorToTable(faceId), VectorToTable(level), VectorToTable(childFight), VectorToTable(childProp))
end

--@brief	离婚孩子分配结果（WEDDING_GetDivorceResultOk = 95）
function ProtocolProcessorWndMarry:parse_WEDDING_GetDivorceResultOk(playerId, playerName, childId, childName, sex, headId, faceId, level, childFight, childProp)
	-- playerId : 玩家Id
	-- playerName : 玩家名字
	-- childId : 小孩Id
	-- sex : 小孩性别
	-- childName : 小孩名字
	-- headId : 小孩头Id
	-- faceId : 小孩脸Id
	-- level : 小孩等级
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetDivorceResultOk")
	
	WndParentsCare:receiveDivorceResult(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(childId), VectorToTable(childName), VectorToTable(sex), VectorToTable(headId), VectorToTable(faceId), VectorToTable(level), VectorToTable(childFight), VectorToTable(childProp))
end

--@brief	获取孩子分配信息（WEDDING_GetAllotChildInfoOk = 96）
function ProtocolProcessorWndMarry:parse_WEDDING_GetAllotChildInfoOk(fatherDevote, motherDevote, otherSelectChildId, childId, sex, childName, headId, faceId, level, ownerId, childFight, childProp)
	-- fatherDevote : 父亲贡献度
	-- motherDevote : 母亲贡献度
	-- ownerId : 孩子所属玩家Id 
	-- otherSelectChildId : 别人选择的孩子ID
	-- childId : 小孩Id
	-- sex : 小孩性别
	-- childName : 小孩名字
	-- headId : 小孩头Id
	-- faceId : 小孩脸Id
	-- level : 小孩等级
	WZLog("ProtocolProcessorWndMarry:parse_WEDDING_GetAllotChildInfoOk")
	
	WndParentsCare:receiveDivorceData(fatherDevote, motherDevote, VectorToTable(ownerId), VectorToTable(childId), VectorToTable(sex), VectorToTable(childName), VectorToTable(headId), VectorToTable(faceId), VectorToTable(level), VectorToTable(otherSelectChildId), VectorToTable(childFight), VectorToTable(childProp))
end
-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	夫妻关系（WEDDING_GetMarryInfo = 44）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMarryInfo, nflag, sMessage)
	WndMarryManager:closeLoading()
end

--@brief	获取婚姻状况错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetMaritalStatus, nflag, sMessage)
    WndMarryManager:closeLoading()
    ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus( )
end

--@brief	发送求婚信/结婚函错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_SendLoveLetter, nflag, sMessage)
    WndMarryManager:closeLoading()
end

--@brief	获取求婚信内容错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_GetLoveLetterInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_GetLoveLetterInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLetterInfo, nflag, sMessage)
    WndMarryManager:closeLoading()
end


--@brief	更改婚姻状态错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_ChangeMarryStatus, nflag, sMessage)
    WndMarryManager:closeLoading()
end

--@brief	解除关系（用于离婚和解除订婚）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_RemoveEngagement, nflag, sMessage)
    WndMarryManager:closeLoading()
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	赠送钻石错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_GiveDiamond_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_GiveDiamond_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GiveDiamond, nflag, sMessage)
    WndMarryManager:closeLoading()
end

--@brief	发送请柬（WEDDING_SendCard =18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_SendCard_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_SendCard_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_SendCard, nflag, sMessage)
	WndMarryManager:closeLoading()
end

--@brief	恩爱日志（WEDDING_GetLoveLog = 47）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_GetLoveLog_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_GetLoveLog_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_GetLoveLog, nflag, sMessage)
	WndMarryManager:closeLoading()
end

--@brief	发送礼物（WEDDING_SendGift = 49）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_SendGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_SendGift _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_SendGift , nflag, sMessage)
	WndMarryManager:closeLoading()
end

--@brief	获取离婚信息（WWEDDING_GetRemoveEngageStatus = 93）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WWEDDING_GetRemoveEngageStatus_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WWEDDING_GetRemoveEngageStatus _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WWEDDING_GetRemoveEngageStatus , nflag, sMessage)
	WndMarryManager:closeLoading()
end

--@brief	选择孩子（WEDDING_SelectChild = 97）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMarry:send_WEDDING_SelectChild_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMarry:send_WEDDING_SelectChild _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_WEDDING, Protocol.WEDDING_SelectChild , nflag, sMessage)
	WndMarryManager:closeLoading()
end
-------------------------------------公有方法模块End----------------------------------------


