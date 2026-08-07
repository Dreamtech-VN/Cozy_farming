--ProtocolProcessorSceneTeachBattleLoading.lua
--@brief	新手教学载入界面协议
--@date  	2014/2/11
--@author 	李光森
--@note 	


ProtocolProcessorSceneTeachBattleLoading = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorSceneTeachBattleLoading:regAll()
    WZLog("ProtocolProcessorSceneTeachBattleLoading:regAll")
	--@brief	角色信息获取成功(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfoNoviceOk, "ProtocolProcessorSceneTeachBattleLoading:parse_PLAYER_GetPlayerInfoOk", "isiiiiiiiiiiiisiiiissssiiissisiiiiiiiiiiiii")
	--@brief	获得提示语成功
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTipsOk, "ProtocolProcessorSceneTeachBattleLoading:parse_BATTLE_GetTipsOk", "vs")

	--@brief	获取角色信息（PLAYER_GetPlayerInfo = 32）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfoNovice, "ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo_ErrorProcess", "is" )
	--@brief	获得提示语错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips, "ProtocolProcessorSceneTeachBattleLoading:send_BATTLE_GetTips_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorSceneTeachBattleLoading:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取角色信息
function ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo( noviceTutorials )
	WZLog("send_PLAYER_GetPlayerInfo", noviceTutorials)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfoNovice )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( noviceTutorials )	-- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得提示语
function ProtocolProcessorSceneTeachBattleLoading:send_BATTLE_GetTips( )
	WZLog("send_BATTLE_GetTips")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_GetTips )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块------------------------------
--@brief	角色信息获取成功
function ProtocolProcessorSceneTeachBattleLoading:parse_PLAYER_GetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
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
	
	WZLog("ProtocolProcessorSceneTeachBattleLoading:parse_PLAYER_GetPlayerInfoOkattack")

    if TeachBattle.TEACH_TYPE == 1 then
        SceneTeachBattleLoading:receiveGetPlayerInfoOk(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(tickets), VectorToTable(maxLevel), VectorToTable(playerHp), VectorToTable(playerDefend), VectorToTable(playerPhysical), VectorToTable(playerDefense), VectorToTable(playerGold), VectorToTable(playerHonor), VectorToTable(playerSex), VectorToTable(level), VectorToTable(attack), VectorToTable(exp), VectorToTable(guildName), VectorToTable(medalNum), VectorToTable(critRate), VectorToTable(explodeRadius), VectorToTable(proficiency), VectorToTable(suit_head), VectorToTable(suit_face), VectorToTable(suit_body), VectorToTable(suit_weapon), VectorToTable(weapon_type), VectorToTable(upgradeexp), VectorToTable(vipLevel), VectorToTable(suit_wing), VectorToTable(player_title), VectorToTable(weaponLevel), VectorToTable(wbUserId), VectorToTable(zsleve), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(reduceBury), VectorToTable(force), VectorToTable(armor), VectorToTable(agility), VectorToTable(physique), VectorToTable(luck), VectorToTable(fighting), VectorToTable(vipMark), VectorToTable(vipLastDay))
    elseif TeachBattle.TEACH_TYPE == 2 then
        TeachFollowingFiveLevel:receiveGetPlayerInfoOk(VectorToTable(playerId), VectorToTable(playerName), VectorToTable(tickets), VectorToTable(maxLevel), VectorToTable(playerHp), VectorToTable(playerDefend), VectorToTable(playerPhysical), VectorToTable(playerDefense), VectorToTable(playerGold), VectorToTable(playerHonor), VectorToTable(playerSex), VectorToTable(level), VectorToTable(attack), VectorToTable(exp), VectorToTable(guildName), VectorToTable(medalNum), VectorToTable(critRate), VectorToTable(explodeRadius), VectorToTable(proficiency), VectorToTable(suit_head), VectorToTable(suit_face), VectorToTable(suit_body), VectorToTable(suit_weapon), VectorToTable(weapon_type), VectorToTable(upgradeexp), VectorToTable(vipLevel), VectorToTable(suit_wing), VectorToTable(player_title), VectorToTable(weaponLevel), VectorToTable(wbUserId), VectorToTable(zsleve), VectorToTable(injuryFree), VectorToTable(wreckDefense), VectorToTable(reduceCrit), VectorToTable(reduceBury), VectorToTable(force), VectorToTable(armor), VectorToTable(agility), VectorToTable(physique), VectorToTable(luck), VectorToTable(fighting), VectorToTable(vipMark), VectorToTable(vipLastDay))
    end
end

--@brief	获得提示语成功
function ProtocolProcessorSceneTeachBattleLoading:parse_BATTLE_GetTipsOk(tips)
	-- tips : 提示语
	WZLog("ProtocolProcessorSceneTeachBattleLoading:parse_BATTLE_GetTipsOk")
	SceneTeachBattleLoading:receiveTips(VectorToTable(tips))
end

-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取角色信息（PLAYER_GetPlayerInfo = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note		在此对协议错误进行相应处理
function ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, nFlag, sMessage)
end

	
	