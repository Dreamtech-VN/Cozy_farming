--ProtocolProcessorWndUpgrade.lua
--@brief	人物升级相关协议
--@date  	2014/01/13
--@author 	xiaoyu_wu
--@note 	人物升级相关协议


ProtocolProcessorWndUpgrade = ProtocolProcessorBase:new()


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndUpgrade:regAll()
    WZLog("ProtocolProcessorWndUpgrade:regAll")
	--服务器到客户端协议注册
	--@brief	获取玩家属性成功
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetAttributeOk, "ProtocolProcessorWndUpgrade:parse_PLAYER_GetAttributeOk", "iiiis")
	--@brief	发送好友列表（FRIEND_SendFriendList = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_SendFriendList, "ProtocolProcessorWndUpgrade:parse_FRIEND_SendFriendList", "vivsvivbvbii")
	--角色信息获取成功(S->C)
	
	--协议错误处理	
	--@brief	获取玩家属性错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetAttribute, "ProtocolProcessorWndUpgrade:send_PLAYER_GetAttribute_ErrorProcess", "is" )
	--@brief	获取好友列表（FRIEND_GetFriendListNew = 19）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendListNew, "ProtocolProcessorWndUpgrade:send_FRIEND_GetFriendListNew_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndUpgrade:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	获取玩家属性
function ProtocolProcessorWndUpgrade:send_PLAYER_GetAttribute( )
	WZLog("send_PLAYER_GetAttribute")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetAttribute )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取好友列表（FRIEND_GetFriendListNew = 19）
function ProtocolProcessorWndUpgrade:send_FRIEND_GetFriendListNew(pageNumber, sex )
	WZLog("send_FRIEND_GetFriendListNew")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendListNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageNumber )	-- 第几页
	sender:writeInt( sex )	-- 0：男性好友，1：女性好友，-1：所有好友
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取角色信息
function ProtocolProcessorWndUpgrade:send_PLAYER_GetPlayerInfo(noviceTutorials )
	WZLog("ProtocolProcessorWndUpgrade:send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end 

	sender:writeInt( noviceTutorials ) -- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	获取玩家属性成功
function ProtocolProcessorWndUpgrade:parse_PLAYER_GetAttributeOk(level, hp, attack, defend, attributeInfo)
	-- level : 玩家的等级
    -- hp : 玩家的血量
    -- attack : 玩家的攻击力
    -- defend : 玩家的防御力
    -- attributeInfo : 玩家升级开发功能描述
	WZLog("ProtocolProcessorWndUpgrade:parse_PLAYER_GetAttributeOk")
    WndUpgrade:setAttributeInfo(level, hp, attack, defend, attributeInfo)
end

--@brief	发送好友列表（FRIEND_SendFriendList = 2）
function ProtocolProcessorWndUpgrade:parse_FRIEND_SendFriendList(playerId, playerName, level, sex, online, pageNumber, totalPage)
	-- playerId : 好友Id
	-- playerName : 好友名称
	-- level : 好友等级
	-- sex : 好友性别，false是男，true是女
	-- online : 好友是否在线
	-- pageNumber : 当前第几页
	-- totalPage : 总页数
	WZLog("ProtocolProcessorWndUpgrade:parse_FRIEND_SendFriendList:::::::::::::::")
	WndUpgrade:getFriendData(playerName)
end

--@brief	角色信息获取成功
function ProtocolProcessorWndUpgrade:parse_PLAYER_GetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
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
	WZLog("ProtocolProcessorWndUpgrade:parse_PLAYER_GetPlayerInfoOk one", playerId, playerName, level, exp)

    WndUpgrade:addPlayerAnimation()
end

-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------
--@brief	获取玩家属性错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndUpgrade:send_PLAYER_GetAttribute_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndUpgrade:send_PLAYER_GetAttribute_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetAttribute, nflag, sMessage)
end

--@brief	获取好友列表（FRIEND_GetFriendListNew = 19）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndUpgrade:send_FRIEND_GetFriendListNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndUpgrade:send_FRIEND_GetFriendListNew_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_GetFriendListNew, nFlag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------





