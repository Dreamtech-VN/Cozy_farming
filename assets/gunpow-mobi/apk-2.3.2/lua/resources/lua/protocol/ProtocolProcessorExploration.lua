--ProtocolProcessorExploration.lua
--@brief	秘境探险协议
--@date  	2013/1/6
--@author 	林庆凯
--@note 	秘境探险协议相关协议


ProtocolProcessorExploration = ProtocolProcessorBase:new()


-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorExploration:regAll()
	WZLog("ProtocolProcessorExploration:regAll()")
	
	--@brief	获得抽奖类型协议成功（DRAW_SendDrawTypeList = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_SendDrawTypeList, "ProtocolProcessorExploration:parse_DRAW_SendDrawTypeList", "vivsvsvss")

	--@brief	获得抽奖类型协议（DRAW_GetDrawTypeList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_GetDrawTypeList, "ProtocolProcessorExploration:send_DRAW_GetDrawTypeList_ErrorProcess", "is" )

	--@brief	发送抽奖物品列表（DRAW_SendItemList = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_SendItemList, "ProtocolProcessorExploration:parse_DRAW_SendItemList", "iiiivivisi")

	--@brief	获得抽奖物品列表（DRAW_GetItemList = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_GetItemList, "ProtocolProcessorExploration:send_DRAW_GetItemList_ErrorProcess", "is" )
	
	--@brief	抽奖刷新（DRAW_DrawRefresh = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_DrawRefresh, "ProtocolProcessorExploration:send_DRAW_DrawRefresh_ErrorProcess", "is" )

	--@brief	抽奖结果（DRAW_DrawOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_DrawOk, "ProtocolProcessorExploration:parse_DRAW_DrawOk", "iis")

	
	--@brief	抽奖（DRAW_Draw = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_Draw, "ProtocolProcessorExploration:send_DRAW_Draw_ErrorProcess", "is" )

	
	--@brief	领奖（DRAW_GetReward = 6）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_DRAW, Protocol.DRAW_GetReward, "ProtocolProcessorExploration:send_DRAW_GetReward_ErrorProcess", "is" )

	
	--角色信息获取成功(S->C)
end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorExploration:unregAll()
	self:clearReg()
end



-------------------------------------客户端到服务器协议发送方法模块--------------------------------------


--@brief	获得抽奖类型协议（DRAW_GetDrawTypeList = 1）
function ProtocolProcessorExploration:send_DRAW_GetDrawTypeList( )
	WZLog("send_DRAW_GetDrawTypeList")
	local sender = Protocol:getSender( Protocol.MAIN_DRAW, Protocol.DRAW_GetDrawTypeList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end



--@brief	获得抽奖物品列表（DRAW_GetItemList = 3）
function ProtocolProcessorExploration:send_DRAW_GetItemList(typeId )
	WZLog("send_DRAW_GetItemList",typeId)
	local sender = Protocol:getSender( Protocol.MAIN_DRAW, Protocol.DRAW_GetItemList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeId )	-- 玩家选择的抽奖类型的物品ID
	SendProtocol(sender,false) --true:showLoading
end



--@brief	抽奖刷新（DRAW_DrawRefresh = 5）
function ProtocolProcessorExploration:send_DRAW_DrawRefresh(typeId )
	WZLog("send_DRAW_DrawRefresh")
	local sender = Protocol:getSender( Protocol.MAIN_DRAW, Protocol.DRAW_DrawRefresh )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeId )	-- 玩家选择的抽奖类型的物品ID
	SendProtocol(sender,false) --true:showLoading
end



--@brief	抽奖（DRAW_Draw = 7）
function ProtocolProcessorExploration:send_DRAW_Draw(typeId )
	WZLog("send_DRAW_Draw")
	local sender = Protocol:getSender( Protocol.MAIN_DRAW, Protocol.DRAW_Draw )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( typeId )	-- 玩家选择的抽奖类型的物品ID
	SendProtocol(sender,false) --true:showLoading
end


--@brief	领奖（DRAW_GetReward = 6）
function ProtocolProcessorExploration:send_DRAW_GetReward(starNum, typeId )
	WZLog("send_DRAW_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_DRAW, Protocol.DRAW_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( starNum )	-- 领取奖励的星数
	sender:writeInt( typeId )	-- 玩家选择的抽奖类型的物品ID
	SendProtocol(sender,false) --true:showLoading
end




--@brief	获取角色信息
function ProtocolProcessorExploration:send_PLAYER_GetPlayerInfo( noviceTutorials )
	WZLog("send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( noviceTutorials )	-- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end




-------------------------------------服务器到客户端协议回调方法模块--------------------------------------



--@brief	获得抽奖类型协议成功（DRAW_SendDrawTypeList = 2）
function ProtocolProcessorExploration:parse_DRAW_SendDrawTypeList(id, icon, name, miniIcon, detail)
	-- id : 物品ID
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- name : 物品名称
	-- miniIcon : 小图标ICON
	-- detail : 说明
	WZLog("ProtocolProcessorExploration:parse_DRAW_SendDrawTypeList")
	SceneExploration:getDrawTypeList(id, icon, name, miniIcon, detail)
end

--@brief	发送抽奖物品列表（DRAW_SendItemList = 4）
function ProtocolProcessorExploration:parse_DRAW_SendItemList(price, starNum, freeNum, refreshCost, itemId, itemNum, miniIcon, totalNum)
	-- price : 抽奖单价
	-- starNum : 玩家已经获得的星星数
	-- freeNum : 玩家免费刷新的剩余次数
	-- refreshCost : 玩家刷新的钻石数
	-- itemId : 物品ID
	-- itemNum : 物品数量
	-- miniIcon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- totalNum : 代币消耗总数
	WZLog("ProtocolProcessorExploration:parse_DRAW_SendItemList")
	WndExploration:getItemList(price, starNum, freeNum, refreshCost, itemId, itemNum, miniIcon, totalNum)
end

--@brief	抽奖结果（DRAW_DrawOk = 8）
function ProtocolProcessorExploration:parse_DRAW_DrawOk(price, starNum, otherReward)
	-- price : 抽奖单价
	-- starNum : 玩家已经获得的星星数
	-- otherReward : 8星额外奖励
	WZLog("ProtocolProcessorExploration:parse_DRAW_DrawOk")
	WndExploration:drawOk(price, starNum, otherReward)
end

--@brief	角色信息获取成功
function ProtocolProcessorExploration:parse_PLAYER_GetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
	-- playerId : 角色id
	-- playerName : 角色名称
	-- tickets : 点卷数量
	-- maxLevel : 最高等级
	-- playerHp : HP
	-- playerDefend : 防御
	-- playerPhysical : 体力
	-- playerDefense : 暴击
	-- playerGold : 金币
	-- playerHonor : 荣誉
	-- playerSex : 性别
	-- level : 角色等级
	-- attack : 攻击力
	-- exp : 角色当前经验
	-- guildName : 公会名称
	-- medalNum : 勋章数量
	-- critRate : 暴击率
	-- explodeRadius : 爆破范围
	-- proficiency : 武器熟练度
	-- suit_head : 着装串头
	-- suit_face : 着装串脸
	-- suit_body : 着装串身
	-- suit_weapon : 着装串武器
	-- weapon_type : 武器类型0:投掷类1:射击类
	-- upgradeexp : 角色当前升级所需经验
	-- vipLevel : vip等级，非vip返回0
	-- suit_wing : 着装翅膀
	-- player_title : 称号
	-- weaponLevel : 玩家装备的武器的等级
	-- wbUserId : 玩家绑定的微博id
	-- zsleve : 玩家的转生等级
	-- injuryFree : 免伤
	-- wreckDefense : 破防
	-- reduceCrit : 免暴
	-- reduceBury : 免坑
	-- force : 力量
	-- armor : 护甲
	-- agility : 敏捷
	-- physique : 体质
	-- luck : 幸运
	-- fighting : 战斗力
	-- vipMark : 是不是vip
	-- vipLastDay : vip剩余天数
	WZLog("ProtocolProcessorExploration:parse_PLAYER_GetPlayerInfoOk")

	GlobalGame.g_tPlayerInfo.nPlayerId = playerId
	GlobalGame.g_tPlayerInfo.sPlayerName = playerName
	GlobalGame.g_tPlayerInfo.nTickets = tickets
	GlobalGame.g_tPlayerInfo.nMaxLevel = maxLevel
	GlobalGame.g_tPlayerInfo.nPlayerHp = playerHp
	GlobalGame.g_tPlayerInfo.nPlayerDefend = playerDefend
	GlobalGame.g_tPlayerInfo.nPlayerPhysical = playerPhysical
	GlobalGame.g_tPlayerInfo.nPlayerDefense = playerDefense
	GlobalGame.g_tPlayerInfo.nPlayerGold = playerGold
	GlobalGame.g_tPlayerInfo.nPlayerHonor = playerHonor 
	GlobalGame.g_tPlayerInfo.nPlayerSex = playerSex
	GlobalGame.g_tPlayerInfo.nLevel = level
	GlobalGame.g_tPlayerInfo.nAattack = attack
	GlobalGame.g_tPlayerInfo.nExp = exp 
	GlobalGame.g_tPlayerInfo.sGuildName = guildName
	GlobalGame.g_tPlayerInfo.nMedalNum = medalNum
	GlobalGame.g_tPlayerInfo.nCritRate = critRate 
	GlobalGame.g_tPlayerInfo.nExplodeRadius = explodeRadius 
	GlobalGame.g_tPlayerInfo.nProficiency = proficiency 
	GlobalGame.g_tPlayerInfo.sSuit_head = suit_head
	GlobalGame.g_tPlayerInfo.sSuit_face = suit_face
	GlobalGame.g_tPlayerInfo.sSuit_body = suit_body
	GlobalGame.g_tPlayerInfo.sSuit_weapon = suit_weapon
	GlobalGame.g_tPlayerInfo.nWeapon_type = weapon_type
	GlobalGame.g_tPlayerInfo.nUpgradeexp = upgradeexp
	GlobalGame.g_tPlayerInfo.nVipLevel = vipLevel
	GlobalGame.g_tPlayerInfo.sSuit_wing = suit_wing
	GlobalGame.g_tPlayerInfo.sPlayer_title = player_title
	GlobalGame.g_tPlayerInfo.nWeaponLevel = weaponLevel
	GlobalGame.g_tPlayerInfo.vsWbUserId = wbUserId
	GlobalGame.g_tPlayerInfo.nZsleve = zsleve
	GlobalGame.g_tPlayerInfo.nInjuryFree = injuryFree
	GlobalGame.g_tPlayerInfo.nWreckDefense = wreckDefense 
	GlobalGame.g_tPlayerInfo.nReduceCrit = reduceCrit 
	GlobalGame.g_tPlayerInfo.nReduceBury = reduceBury 
	GlobalGame.g_tPlayerInfo.nforce = force 
	GlobalGame.g_tPlayerInfo.nArmor = armor 
	GlobalGame.g_tPlayerInfo.nAgility = agility 
	GlobalGame.g_tPlayerInfo.nPhysique = physique 
	GlobalGame.g_tPlayerInfo.nLuck = luck 
	GlobalGame.g_tPlayerInfo.nQualifyingLevel = qualifyingLevel 
	GlobalGame.g_tPlayerInfo.bDoubleCard = doubleCard 
	GlobalGame.g_tPlayerInfo.nFighting = fighting 
	GlobalGame.g_tPlayerInfo.nVipMark = vipMark 
	GlobalGame.g_tPlayerInfo.nVipLastDay = vipLastDay 
	WndExploration:getPlayerInfoOk()
end




-------------------------------------协议错误处理方法模块--------------------------------------


--@brief	获得抽奖类型协议（DRAW_GetDrawTypeList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorExploration:send_DRAW_GetDrawTypeList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorExploration:send_DRAW_GetDrawTypeList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_DRAW, Protocol.DRAW_GetDrawTypeList, nflag, sMessage)
end



--@brief	获得抽奖物品列表（DRAW_GetItemList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorExploration:send_DRAW_GetItemList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorExploration:send_DRAW_GetItemList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_DRAW, Protocol.DRAW_GetItemList, nflag, sMessage)
end




--@brief	抽奖刷新（DRAW_DrawRefresh = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorExploration:send_DRAW_DrawRefresh_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorExploration:send_DRAW_DrawRefresh_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_DRAW, Protocol.DRAW_DrawRefresh, nflag, sMessage)
	WndExploration:drawRefreshErrorProcess(nFlag, sMessage)
	WZLog("sMessage = ",sMessage)
end



--@brief	抽奖（DRAW_Draw = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorExploration:send_DRAW_Draw_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorExploration:send_DRAW_Draw_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_DRAW, Protocol.DRAW_Draw, nflag, sMessage)
end





--@brief	领奖（DRAW_GetReward = 6）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorExploration:send_DRAW_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorExploration:send_DRAW_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_DRAW, Protocol.DRAW_GetReward, nflag, sMessage)
	WndExplorationPop:getRewardErrorProcess(nFlag, sMessage)
end








