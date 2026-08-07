--ProtocolProcessorWndBag.lua
--@brief	背包模块协议
--@date  	2014/02/18
--@author 	xiaoyu_wu
--@note 	背包模块所使用协议


ProtocolProcessorWndBag = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndBag:regAll()
	WZLog("ProtocolProcessorWndBag:regAll")
	--@brief	获取角色信息（PLAYER_GetPlayerInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfoOk, "ProtocolProcessorWndBag:parse_PLAYER_GetPlayerInfoOk", "isisssiiiiissbvivssiiisvsiiinsisiissviiiissiisitiviviviiiviiiiiiiiiiivsisviviisiisssiis")
	--@brief	更新个人签名成功（PLAYER_UpdateContextOK = 61）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdateContextOK, "ProtocolProcessorWndBag:parse_PLAYER_UpdateContextOK", "")
	--@brief	物品染色（PLAYER_ChangeColour = 82）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeColour, "ProtocolProcessorWndBag:send_PLAYER_ChangeColour_ErrorProcess", "is" )

	--@brief	获取角色信息（PLAYER_GetPlayerInfo = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, "ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo_ErrorProcess", "is" )
	--@brief	更新个人签名（PLAYER_UpdateContext = 60）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdateContext, "ProtocolProcessorWndBag:send_PLAYER_UpdateContext_ErrorProcess", "is" )
	--@brief	物品染色（PLAYER_ChangeColourOK = 83）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeColourOK, "ProtocolProcessorWndBag:parse_PLAYER_ChangeColourOK", "vivi")
	--@brief	目标服务器状态（PLAYER_ServerError = 85）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ServerError, "ProtocolProcessorWndBag:parse_PLAYER_ServerError", "is")

	--@brief	设置资料卡背景显示（PLAYER_SetBackgroundShow = 109）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SetBackgroundShow, "ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow_ErrorProcess", "is" )
	--@brief	设置资料卡背景显示（PLAYER_SetBackgroundShowOk = 110）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_SetBackgroundShowOk, "ProtocolProcessorWndBag:parse_PLAYER_SetBackgroundShowOk", "")
	--@brief	够吗资料卡（PLAYER_BuyBackgroundShow = 111）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyBackgroundShow, "ProtocolProcessorWndBag:send_PLAYER_BuyBackgroundShow_ErrorProcess", "is" )
	--@brief	购买资料卡背景（PLAYER_BuyBackgroundShowOk = 112）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyBackgroundShowOk, "ProtocolProcessorWndBag:parse_PLAYER_BuyBackgroundShowOk", "")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndBag:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取角色信息（PLAYER_GetPlayerInfo = 1）
function ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(playerId )
	WZLog("send_PLAYER_GetPlayerInfo",Protocol.MAIN_PLAYER,Protocol.PLAYER_GetPlayerInfo)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	更新个人签名（PLAYER_UpdateContext = 60）
function ProtocolProcessorWndBag:send_PLAYER_UpdateContext(context )
	WZLog("send_PLAYER_UpdateContext")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdateContext )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( context )	-- 个人签名
	SendProtocol(sender,false) --true:showLoading
end

--@brief	物品染色（PLAYER_ChangeColour = 82）
function ProtocolProcessorWndBag:send_PLAYER_ChangeColour(itemId, colour )
	WZLog("send_PLAYER_ChangeColour")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeColour )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts( itemId )	-- 物品Id
	sender:writeInts( colour )	-- 颜色
	SendProtocol(sender,false) --true:showLoading
end

--@brief	设置资料卡背景显示（PLAYER_SetBackgroundShow = 109）
function ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, bgId)
	WZLog("send_PLAYER_SetBackgroundShow")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_SetBackgroundShow )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( showMes )	-- 显示内容
	sender:writeInt( bgId )	-- 背景Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	够吗资料卡（PLAYER_BuyBackgroundShow = 111）
function ProtocolProcessorWndBag:send_PLAYER_BuyBackgroundShow(itemId)
	WZLog("send_PLAYER_BuyBackgroundShow")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyBackgroundShow )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品Id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取角色信息（PLAYER_GetPlayerInfoOk = 2）
function ProtocolProcessorWndBag:parse_PLAYER_GetPlayerInfoOk(id, name, sex, title, guildName, position, level, vipLevel, winNum, playNum, fighting, mateName, signature, isFriend, itemId, extranInfo, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, tournamentLevel, segmentId, totemLevel, loveLevel, loveSkill, moralityLevel, masterName, itemSuitId, itemSuitNum, snsValue, rankMatchMessage, starsoulId, guildLevel, spaceSex, giftNum, distance, headScul, mentoring, couple, useMountsMessage, tournamentIntegral, marryFlag, serverId, prayId, xlId, xlExp, headColor, bodyColor, isUse, chum, shapeId, shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, runeItemId, runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, thumbUpNum, badgeInfo)
	-- id : Id
	-- name : 名称
	-- sex : 性别
	-- title : 称号
	-- guildName : 公会名称
	-- position : 公会职务0,普通会员 1,精英 2,长老 3,副会长 4,会长
	-- level : 等级
	-- vipLevel : vip等级0表示非VIP
	-- winNum : 胜利次数
	-- playNum : 游戏次数
	-- fighting : 战斗力
	-- mateName : 伴侣名称
	-- signature : 个性签名
	-- isFriend : 是否为好友
	-- itemId : 玩家身上物品ID(物品表)
	-- extranInfo : 见：武器扩展字段
	-- property : 属性，json格式
	-- strongSuitId : 强化套装id
	-- starSuitId : 升星套装id
	-- mosaicSuitId : 镶嵌套装id
	-- petMessage : 宠物信息
	-- mountsMessage : 坐骑信息
	-- tournamentLevel : 竞技等级
	-- segmentId : 排位赛等级id    tab_rank_segment
	-- totemLevel : 公会图腾等级
	-- loveLevel : 恩爱等级     tab_marry_skill
	-- loveSkill : 夫妻技能json字符串｛技能类型：技能id｝
	-- moralityLevel : 师德等级
	-- masterName : 师傅名称
	-- itemSuitId : 套装id
	-- itemSuitNum : n件套
	-- awakeSkillId : 觉醒之技子技能Id
	-- obtainNum : 获得排位印记的次数
	-- cardMessage : 玩家卡牌信息
	-- bgId : 使用中的背景Id
	-- showMes : 标志->二进制第四位(0000)由低到高分别代表(翅膀、伴侣、宠物、孩子)0不显示，1显示
	-- coupleMes : 伴侣信息（空字符串没有伴侣）（faceId|headId|headcolour|bodyId|bodycolour|wingId|id）
	-- childMes : 小孩数据json格式
	-- careBuffProp : 孩子关爱属性
	-- careToday : 是否关爱过
	-- thumbUpNum : 被点赞的次数
	-- badgeInfo : 成就徽章数据
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_GetPlayerInfoOk", awakeSoulLevel, awakeStep)

    if WndCheckOther.m_root then
        WndCheckOther:setPlayerInfo(id, name, sex, title, guildName, position, level, vipLevel, winNum, playNum, fighting, mateName, signature, isFriend, itemId, extranInfo, property, strongSuitId, starSuitId, mosaicSuitId, petMessage, mountsMessage, tournamentLevel, segmentId, totemLevel, loveLevel, loveSkill,moralityLevel,masterName, itemSuitId, itemSuitNum, snsValue, rankMatchMessage, starsoulId, guildLevel, spaceSex, giftNum, distance, headScul, mentoring, couple, useMountsMessage, tournamentIntegral, marryFlag, serverId, prayId, xlId, xlExp, headColor, bodyColor, isUse, chum, shapeId, shapeLevel, showShape, awakeSoulLevel, awakeStep, itemSuitId2, itemSuitNum2, homeLevel, sheerLuxury, footMark, shapeSkillId, awakeSkillId, runeItemId, runeItemNum, obtainNum, cardMessage, bgId, showMes, coupleMes, childMes, careBuffProp, careToday, thumbUpNum, badgeInfo)
    end
end

--@brief	更新个人签名成功（PLAYER_UpdateContextOK = 61）
function ProtocolProcessorWndBag:parse_PLAYER_UpdateContextOK()
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_UpdateContextOK")
	MsgBoxManager:showTipBox(LocalStrings.SAVE..LocalStrings.SUCCESS)
	if WndPlayerInfo.m_root ~= nil then
	CacheCenter:getPlayerInfo().signature = WndPlayerInfo:_getSignature()
	WndPlayerInfo:closeLoading()
	end
end

--@brief	物品染色（PLAYER_ChangeColourOK = 83）
function ProtocolProcessorWndBag:parse_PLAYER_ChangeColourOK(itemId, colour)
	-- itemId : 物品Id
	-- colour : 颜色
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_ChangeColourOK",Serialize(VectorToTable(colour)))
	if #VectorToTable(itemId) == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FAIL)
		return
	end
	MsgBoxManager:showTipBox(LocalStrings.BAGTIP40)
	--更新缓存
	local dressList = CacheCenter:getDecorationList()
	local itemId = VectorToTable(itemId)
	local colour = VectorToTable(colour)
	for i=1,#dressList do
		for j=1,#itemId do
			if dressList[i].playerItemId == itemId[j] then
				dressList[i].color = colour[j]
				if dressList[i].isUse ~= true then
				WZLog("染色后穿上装备",dressList[i].basicInfo.name)
				local id = WZLuaVector_int_:create()
				id:push(dressList[i].playerItemId)
				ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
				end
			end
		end
	end
	if Wnddyeing.m_root ~= nil then 
		Wnddyeing:updateCost()
		Wnddyeing:onFinish()
	end
	CacheCenter:_updateDecorationData()
	--去掉试穿的时装
	if Wndwardrobe.m_root ~= nil then
		Wndwardrobe:onCancelBatch()
	end
end

--@brief	目标服务器状态（PLAYER_ServerError = 85）
function ProtocolProcessorWndBag:parse_PLAYER_ServerError(status, tip)
	-- status : 0服务器未开启
	-- tip : 提示语
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_ServerError", status)
	MsgBoxManager:showTipBox(tip)
	if WndCheckOther.m_root ~= nil then
		WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
	end
	if WndSpaceMain.m_root ~= nil then
		WindowManager:removeWindow(WndSpaceMain.m_root, WndSpaceMain, true)
	end
end

--@brief	设置资料卡背景显示（PLAYER_SetBackgroundShowOk = 110）
function ProtocolProcessorWndBag:parse_PLAYER_SetBackgroundShowOk()
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_SetBackgroundShowOk")
	
	WndCheckOther:setBgOrOtherOK()
end

--@brief	购买资料卡背景（PLAYER_BuyBackgroundShowOk = 112）
function ProtocolProcessorWndBag:parse_PLAYER_BuyBackgroundShowOk()
	WZLog("ProtocolProcessorWndBag:parse_PLAYER_BuyBackgroundShowOk")
	
	WndCheckOther:setBuyBgOK()
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取角色信息（PLAYER_GetPlayerInfo = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, nflag, sMessage)
	if WndCheckOther.m_root ~= nil then
		WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
	end
end

--@brief	更新个人签名（PLAYER_UpdateContext = 60）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBag:send_PLAYER_UpdateContext_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBag:send_PLAYER_UpdateContext_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_UpdateContext, nflag, sMessage)
end

--@brief	物品染色（PLAYER_ChangeColour = 82）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBag:send_PLAYER_ChangeColour_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBag:send_PLAYER_ChangeColour_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeColour, nflag, sMessage)
end

--@brief	设置资料卡背景显示（PLAYER_SetBackgroundShow = 109）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_SetBackgroundShow, nflag, sMessage)
end

--@brief	够吗资料卡（PLAYER_BuyBackgroundShow = 111）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndBag:send_PLAYER_BuyBackgroundShow_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndBag:send_PLAYER_BuyBackgroundShow_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_BuyBackgroundShow, nflag, sMessage)
end
