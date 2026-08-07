--ProtocolProcessorWndReincarnation.lua
--@brief	转生相关协议
--@date  	2013/12/12
--@author 	liangguang_long
--@note 	转生相关协议


ProtocolProcessorWndReincarnation = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorWndReincarnation:regAll()
	--@brief	获取玩家的转生信息（REBIRTH_GetRebirthInfoOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_GetRebirthInfoOk, "ProtocolProcessorWndReincarnation:parse_REBIRTH_GetRebirthInfoOk", "iiiisii")
	--@brief	玩家转生结果（REBIRTH_RebirthResult = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_RebirthResult, "ProtocolProcessorWndReincarnation:parse_REBIRTH_RebirthResult", "is")
	--角色信息获取成功(S->C)
	--@brief	获取玩家装备列表成功
	--self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentOk, "ProtocolProcessorWndReincarnation:parse_PLAYER_GetPlayerStoreEquipmentOk", "ivivsvsvsvsvtvtvivivivivivivivivivivivsvivivbvbiivivivivivivivivivivivivivs")
	--@brief	获取玩家身上装备成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipmentOk, "ProtocolProcessorWndReincarnation:parse_PLAYER_GetPlayerBodyEquipmentOk", "ivivsvsvsvsvtvtvivivivivivivivivivivivsvivivbvbiivivivivivivivivivivii")
	--@brief	返回对方资料（FRIEND_CheckFriendInfoOk = 12）
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfoOk, "ProtocolProcessorWndReincarnation:parse_FRIEND_CheckFriendInfoOk", "isissiiibivssiiiiiiiiiiibbsvsvsiiiiiiiiiibi")
	
	--协议错误处理	
	--@brief	获取玩家的转生信息失败
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.REBIRTH_GetRebirthInfo, "ProtocolProcessorWndReincarnation:parse_REBIRTH_GetRebirthErrorMessage", "is")
	--@brief	玩家转生失败
	self:regProtocolCallbackFunction( Protocol.MAIN_MAIL, Protocol.REBIRTH_Rebirth , "ProtocolProcessorWndReincarnation:parse_REBIRTH_RebirthErrorMessage", "is")
	--@brief	获取角色信息（PLAYER_GetPlayerInfo = 32）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, "ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerInfo_ErrorProcess", "is" )
	--@brief	获取玩家身上装备列表（PLAYER_GetPlayerBodyEquipment = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, "ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess", "is" )
	--@brief	查看对方资料（FRIEND_CheckFriendInfo = 11）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo, "ProtocolProcessorWndReincarnation:send_FRIEND_CheckFriendInfo_ErrorProcess", "is" )
	
end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorWndReincarnation:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取玩家的转生信息（REBIRTH_GetRebirthInfo = 1）
function ProtocolProcessorWndReincarnation:send_REBIRTH_GetRebirthInfo( )
	WZLog("send_REBIRTH_GetRebirthInfo")
	local sender = Protocol:getSender( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_GetRebirthInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家转生（REBIRTH_Rebirth = 3）
function ProtocolProcessorWndReincarnation:send_REBIRTH_Rebirth(rebirthType )
	WZLog("send_REBIRTH_Rebirth")
	local sender = Protocol:getSender( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_Rebirth )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( rebirthType )	-- 转生类型0普通转生，1完美转生
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取角色信息
function ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerInfo( noviceTutorials )
	WZLog("send_PLAYER_GetPlayerInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( noviceTutorials )	-- 是否新手教程0不是1是
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家身上装备列表（PLAYER_GetPlayerBodyEquipment = 5）
function ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerBodyEquipment(playerId )
	WZLog("send_PLAYER_GetPlayerBodyEquipment")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) 	--true:showLoading
end

--@brief	查看对方资料（FRIEND_CheckFriendInfo = 11）
function ProtocolProcessorWndReincarnation:send_FRIEND_CheckFriendInfo( playerId )
	WZLog("send_FRIEND_CheckFriendInfo")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 添加的好友Id
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	获取玩家的转生信息（REBIRTH_GetRebirthInfoOk = 2）
function ProtocolProcessorWndReincarnation:parse_REBIRTH_GetRebirthInfoOk(rebirthLevel, rebirthTopLevel, rebirthNum, rebirthNeedNum, rebirthRemark, diamonds, rebirthDiamonds)
	-- rebirthLevel : 玩家当前转生等级
	-- rebirthTopLevel : 最高可转生等级（玩家转生等级不能超过最高等级）
	-- rebirthNum : 玩家拥有的转生石数量
	-- rebirthNeedNum : 转生所需转生石数量
	-- rebirthRemark : 转生说明
	-- diamonds : 玩家拥有的钻石数量
	-- rebirthDiamonds : 完美转生所需的钻石数
	WZLog("ProtocolProcessorWndReincarnation:parse_REBIRTH_GetRebirthInfoOk")
	WndReincarnation:setReincList( rebirthLevel , rebirthTopLevel , rebirthNum , rebirthNeedNum , rebirthRemark , diamonds , rebirthDiamonds )
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
end


--@brief	玩家转生结果（REBIRTH_RebirthResult = 4）
function ProtocolProcessorWndReincarnation:parse_REBIRTH_RebirthResult(status, message)
	-- status : 0转生成功，其他则转生失败
	-- message : 提示信息
	WZLog("ProtocolProcessorWndReincarnation:parse_REBIRTH_RebirthResult  ok:::ok" , status , KLuaSocket:utfToGBK(message))
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
	--转生成功
	if status == 0 then
		--@brief	获取角色信息
		self:send_PLAYER_GetPlayerInfo( 0 )
		--@brief	获取玩家的转生信息（REBIRTH_GetRebirthInfo = 1）
		self:send_REBIRTH_GetRebirthInfo( )
		--@brief	转生成功回调函数(开始动画)
		WndReincarnation:reincSuccess()
	end
	
end

--@brief	角色信息获取成功
function ProtocolProcessorWndReincarnation:parse_PLAYER_GetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
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
	WZLog("ProtocolProcessorWndReincarnation:parse_PLAYER_GetPlayerInfoOk:::kkkkkkkkk",tickets)
	--获取玩家的转生所需要的基本信息
	WndReincarnation:getPlayerInfo( playerId , playerName , playerSex  , level , exp , upgradeexp , suit_head , suit_face , 
	suit_body , suit_wing , suit_weapon , weapon_type , weaponLevel , proficiency , vipLevel , playerHonor )
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
end

--@brief	获取玩家身上装备成功
function ProtocolProcessorWndReincarnation:parse_PLAYER_GetPlayerBodyEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, betterok , petId)
	-- itemCount : 物品类型数量
	-- id : 物品序号
	-- name : 物品名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- animationIndexCode : 商品在动画资源包的索引串
	-- desc : 物品描述
	-- itemMainType :  0:投掷武器 1:射击武器 2:身躯装扮 3:脸谱 4:头发 5:一般道具（只能在战场上使用的道具） 6:合成类（合成时使用的） 7：镶嵌（镶嵌时使用的）8:其它
	-- itemSubType : 主类型是其它类型可以使用这个再分类
	-- sex : 0：女 1：男 2：不限
	-- level : 物品等级，人物低于这个等级是不能使用的
	-- addHP : 生命增加
	-- addPower : 体力增加
	-- addAttack : 攻击力增加
	-- attackArea : 攻击范围
	-- criticalCoefficient : 暴击换算系数
	-- addDefend : 防御增加
	-- addCriticalRate : 万份比数值(放大一万陪) 增加暴击率
	-- useLastTime : 使用后持续多少时间有这个效果（如多常时间内会提高获得经验比例）
	-- expExtraRate : 经验获得百分比加成(在一定时间内获得时间的加成）
	-- p_lastTime : 剩余的天数，如果是-1，就是不限时间使用
	-- p_lastNum : 剩余数量，如果是-1，就是不限数量使用
	-- m_proficiency : 物品熟练度
	-- hasExpired : 是否过期
	-- hasShowStrengthenInfo : 是否显示强化信息（即是否被强化或洗炼过）
	-- pageNumber : 当前页数
	-- totalNumber : 总页数
	-- skillType : 当前装备的武器的技能类型
	-- skillLevel : 当前装备的武器的技能等级
	-- starLevel : 装备星级
	-- attackOpen : 镶嵌的攻击宝石id。没有则为-1
	-- defendOpen : 镶嵌的防御宝石id。没有则为-1
	-- specialOpen : 镶嵌的特殊宝石id。没有则为-1
	-- attackStoneLevel : 攻击宝石等级（未镶嵌或未打孔等级为0）
	-- defendStoneLevel : 防御宝石等级（未镶嵌或未打孔等级为0）
	-- specailStoneLevel : 特殊宝石等级（未镶嵌或未打孔等级为0）
	-- betterok : 推荐位最高战斗力物品
	-- petId : 玩家宠物ID（没有宠物ID为-1）
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerBodyEquipmentOk11999999999999" )	
	WndReincarnation:getPlayerEquipInfo( skillType , skillLevel , petId )
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
end

--@brief	返回对方资料（FRIEND_CheckFriendInfoOk = 12）
function ProtocolProcessorWndReincarnation:parse_FRIEND_CheckFriendInfoOk(playerId, playerName, level, callName, communityName, currentExperience, needExperience, playerRank, vipMark, vipLevel, expDoubleMark, weaponsName, weaponSkillDegree, critRate, playerAttack, attackArea, hp, defend, physical, honor, losing, winNumber, playNumber, hasBeenFriend, beOnline, communityPosition, weiboID, weiboIcon, zsLevel, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, doubleCard, fighting)
	-- playerId : 玩家Id
	-- playerName : 玩家名称
	-- level : 玩家等级
	-- callName : 玩家称号（暂时为空）
	-- communityName : 玩家公会名称
	-- currentExperience : 玩家当前经验
	-- needExperience : 玩家该等级升级所需经验
	-- playerRank : 玩家军衔（暂时没有）
	-- vipMark : vip标识
	-- vipLevel : vip等级
	-- expDoubleMark : buff状态标识
	-- weaponsName : 玩家武器名称
	-- weaponSkillDegree : 武器熟练度
	-- critRate : 玩家暴击率
	-- playerAttack : 玩家攻击力
	-- attackArea : 武器攻击范围
	-- hp : 生命值
	-- defend : 防御值
	-- physical : 体力值
	-- honor : 荣誉值
	-- losing : 胜率
	-- winNumber : 胜利次数
	-- playNumber : 游戏次数
	-- hasBeenFriend : 是否是好友
	-- beOnline : 是否在线
	-- communityPosition : 公会职位
	-- weiboID : 微博新浪微博
	-- weiboIcon : 微博头像新浪微博
	-- zsLevel : 玩家的转生等级
	-- injuryFree : 免伤
	-- wreckDefense : 破防
	-- reduceCrit : 免暴
	-- reduceBury : 免坑
	-- force : 力量
	-- armor : 护甲
	-- agility : 敏捷
	-- physique : 体质
	-- luck : 幸运
	-- doubleCard : 是否有双倍经验卡（true表示有）
	-- fighting : 战斗力
	WZLog("ProtocolProcessorWndReincarnation:parse_FRIEND_CheckFriendInfoOk::::" , doubleCard ,playerRank )
	--@brief	获取玩家双倍经验军衔等级信息
	WndReincarnation:getPlayerOtherInfo( doubleCard , playerRank )
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取玩家的转生信息失败
function ProtocolProcessorWndReincarnation:parse_REBIRTH_GetRebirthErrorMessage(isexit,message)
	WZLog( "GetRebirthErrorMessage::1 ",KLuaSocket:utfToGBK(message) )
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
	ProtocolErrorProcessor:errorProcess( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_GetRebirthInfo , nFlag, sMessage)
end

--@brief	玩家转生失败
function ProtocolProcessorWndReincarnation:parse_REBIRTH_RebirthErrorMessage(isexit,message)
	WZLog( "RebirthErrorMessage::2 ",KLuaSocket:utfToGBK(message) )
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
	ProtocolErrorProcessor:errorProcess( Protocol.MAIN_REBIRTH, Protocol.REBIRTH_Rebirth, nFlag, sMessage)
end

--@brief	获取角色信息（PLAYER_GetPlayerInfo = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerInfo_ErrorProcess")
	--@brief   关闭加载框
	WndReincarnation:closeLoading()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerInfo, nFlag, sMessage)
end

--@brief	获取玩家身上装备列表（PLAYER_GetPlayerBodyEquipment = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndReincarnation:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, nFlag, sMessage)
end

--@brief	查看对方资料（FRIEND_CheckFriendInfo = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndReincarnation:send_FRIEND_CheckFriendInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndReincarnation:send_FRIEND_CheckFriendInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo, nFlag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


