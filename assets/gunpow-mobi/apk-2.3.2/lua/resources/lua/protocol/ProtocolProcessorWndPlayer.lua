--ProtocolProcessorWndPlayer.lua
--@brief	主角模块协议
--@date  	2013/12/10
--@author 	李光森
--@note 	主角模块所使用协议


ProtocolProcessorWndPlayer = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndPlayer:regAll()
	--数据表
	self.m_tData = nil
	--返回对方资料
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfoOk, "ProtocolProcessorWndPlayer:parse_FRIEND_CheckFriendInfoOk", "isissiiibivssiiiiiiiiiiibbsvsvsiiiiiiiiiibi")
	--@brief	获取玩家身上装备成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipmentOk, "ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerBodyEquipmentOk", "ivivsvsvsvsvtvtvivivivivivivivivivivivsvivivbvbiivivivivivivivivivivii")
	--添加好友成功
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriendOk, "ProtocolProcessorWndPlayer:parse_FRIEND_AddFriendOk", "")
	--@brief	获取武器强化信息成功
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetStrengthenInfoOk, "ProtocolProcessorWndPlayer:parse_PLAYER_GetStrengthenInfoOk", "s")
    --@brief	更改名字结果
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_RenameOk, "ProtocolProcessorWndPlayer:parse_PLAYER_RenameOk", "s")
    --@brief	清除失败次数成功
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ClearFailNumOk, "ProtocolProcessorWndPlayer:parse_BATTLE_ClearFailNumOk", "")
    --@brief	发送奖励物品列表
    self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_GetGiftOk, "ProtocolProcessorWndPlayer:parse_SPREE_GetGiftOk", "vsvsvi")
	--@brief	玩家好友装备协议(FRIEND_LookEquipmentOk = 26)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_LookEquipmentOk, "ProtocolProcessorWndPlayer:parse_FRIEND_LookEquipmentOk", "vsvsvsvsvsvsvsvsivs")

	--查看对方资料错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo, "ProtocolProcessorWndPlayer:send_FRIEND_CheckFriendInfo_ErrorProcess", "is" )
	--@brief	获取玩家仓库装备列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew, "ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess", "is" )
	--获取玩家身上装备列表错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, "ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess", "is" )
	--@brief	获取武器强化信息错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetStrengthenInfo, "ProtocolProcessorWndPlayer:send_PLAYER_GetStrengthenInfo_ErrorProcess", "is" )
	--添加好友错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriend, "ProtocolProcessorWndPlayer:send_FRIEND_AddFriend_ErrorProcess", "is" )
    --@brief	更改名字错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_Rename, "ProtocolProcessorWndPlayer:send_PLAYER_Rename_ErrorProcess", "is" )
    --@brief	清除失败次数错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BATTLE, Protocol.BATTLE_ClearFailNum, "ProtocolProcessorWndPlayer:send_BATTLE_ClearFailNum_ErrorProcess", "is" )
    --@brief	获得奖励列表错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SPREE, Protocol.SPREE_GetGift, "ProtocolProcessorWndPlayer:send_SPREE_GetGift_ErrorProcess", "is" )
	--@brief	玩家好友装备协议（FRIEND_LookEquipment = 25）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_FRIEND, Protocol.FRIEND_LookEquipment, "ProtocolProcessorWndPlayer:send_FRIEND_LookEquipment_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndPlayer:unregAll()
	self.m_tData = nil
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	查看对方资料
function ProtocolProcessorWndPlayer:send_FRIEND_CheckFriendInfo(playerId )
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 好友Id
	SendProtocol(sender,true) --true:showLoading
end

--@brief	获取玩家仓库装备列表
function ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerStoreEquipmentNew(itemType, pageNumber )
	WZLog("send_PLAYER_GetPlayerStoreEquipmentNew")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemType )	-- 物品类别（1：武器，2：装扮，3：其他）
	sender:writeInt( pageNumber )	-- 所需的页数
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家身上装备列表
function ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerBodyEquipment(playerId )
	WZLog("send_PLAYER_GetPlayerBodyEquipment")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取武器强化信息
function ProtocolProcessorWndPlayer:send_PLAYER_GetStrengthenInfo(weaponId )
	WZLog("send_PLAYER_GetStrengthenInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetStrengthenInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( weaponId )	-- 武器id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	添加好友
function ProtocolProcessorWndPlayer:send_FRIEND_AddFriendNew(playerId )
	WZLog("send_FRIEND_AddFriend")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriendNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 添加的好友Id
	SendProtocol(sender,true) --true:showLoading
end

--@brief	更改名字
function ProtocolProcessorWndPlayer:send_PLAYER_Rename(newName )
	WZLog("send_PLAYER_Rename")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_Rename )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeString( newName )	-- 新名字
	SendProtocol(sender,false) --true:showLoading
end

--@brief	清除失败次数
function ProtocolProcessorWndPlayer:send_BATTLE_ClearFailNum( )
	WZLog("send_BATTLE_ClearFailNum")
	local sender = Protocol:getSender( Protocol.MAIN_BATTLE, Protocol.BATTLE_ClearFailNum )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获得奖励列表
function ProtocolProcessorWndPlayer:send_SPREE_GetGift(itemId )
	WZLog("send_SPREE_GetGift")
	local sender = Protocol:getSender( Protocol.MAIN_SPREE, Protocol.SPREE_GetGift )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( itemId )	-- 物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家好友装备协议（FRIEND_LookEquipment = 25）
function ProtocolProcessorWndPlayer:send_FRIEND_LookEquipment( playerId )
	WZLog("send_FRIEND_LookEquipment")
	local sender = Protocol:getSender( Protocol.MAIN_FRIEND, Protocol.FRIEND_LookEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 好友id
	SendProtocol(sender,false) --true:showLoading
end



-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	返回对方资料
function ProtocolProcessorWndPlayer:parse_FRIEND_CheckFriendInfoOk(playerId, playerName, level, callName, communityName, currentExperience, needExperience, playerRank, vipMark, vipLevel, expDoubleMark, weaponsName, weaponSkillDegree, critRate, playerAttack, attackArea, hp, defend, physical, honor, losing, winNumber, playNumber, hasBeenFriend, beOnline, communityPosition, weiboID, weiboIcon, zsLevel, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, doubleCard, fighting)
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
	-- weiboID : 微博ID//[0]:新浪微博
	-- weiboIcon : 微博头像//[0]:新浪微博
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
	WZLog("ProtocolProcessorWndPlayer:parse_FRIEND_CheckFriendInfoOk")
	--调用主角界面接受函数
	if WindowManager:ifWindowExist(WndPlayer) then
		WndPlayer:receivePlayerInfo(playerId, playerName, level, callName, communityName, currentExperience, needExperience, playerRank, vipMark, vipLevel, VectorToTable(expDoubleMark), weaponsName, weaponSkillDegree, critRate, playerAttack, attackArea, hp, defend, physical, honor, losing, winNumber, playNumber, hasBeenFriend, beOnline, communityPosition, VectorToTable(weiboID), VectorToTable(weiboIcon), zsLevel, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, doubleCard, fighting)
	end
	
	-- if SceneRanking ~= nil and SceneRanking.m_root ~= nil then
	-- 	SceneRanking:receivePlayerInfo(playerId, playerName, level, zsLevel, vipMark, vipLevel, fighting, communityName, losing)
	-- end

	if WndRanking ~= nil and WndRanking.m_root ~= nil then
		WndRanking:receivePlayerInfo(playerId, playerName, level, zsLevel, vipMark, vipLevel, fighting, communityName, losing)
	end
end

--@brief	获取玩家装备列表成功
function ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerStoreEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, useLevel, lastTimeMark, isUse, attribute)
	-- itemCount : 物品类型数量
	-- id : 物品序号
	-- name : 物品名字
	-- icon : relativePath/图标名称.png(资源会放到同一个目录下)
	-- animationIndexCode : 商品在动画资源包的索引串
	-- desc : 物品描述
	-- itemMainType :  0:投掷武器 1:射击武器 2:身躯装扮 3:脸谱 4:头发 5:一般道具（只能在战场上使用的道具）  6:合成类（合成时使用的） 7：镶嵌（镶嵌时使用的）8:其它
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
	-- useLevel : 物品使用等级
	-- lastTimeMark : 剩余天数（-1表示不按天数计算或无限期，10期添加）
    -- isUse : 是否穿在身上
    -- attribute : 物品当前属性文字描述（非数据表里的desc）
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerStoreEquipmentOk")
	WndPlayerGoods:receiveGetPlayerStoreEquipmentOk(VectorToTable(itemCount), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(animationIndexCode), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(sex), VectorToTable(level), VectorToTable(addHP), VectorToTable(addPower), VectorToTable(addAttack), VectorToTable(attackArea), VectorToTable(criticalCoefficient), VectorToTable(addDefend), VectorToTable(addCriticalRate), VectorToTable(useLastTime), VectorToTable(expExtraRate), VectorToTable(p_lastTime), VectorToTable(p_lastNum), VectorToTable(m_proficiency), VectorToTable(hasExpired), VectorToTable(hasShowStrengthenInfo), VectorToTable(pageNumber), VectorToTable(totalNumber), VectorToTable(skillType), VectorToTable(skillLevel), VectorToTable(starLevel), VectorToTable(attackOpen), VectorToTable(defendOpen), VectorToTable(specialOpen), VectorToTable(attackStoneLevel), VectorToTable(defendStoneLevel), VectorToTable(specailStoneLevel), VectorToTable(useLevel), VectorToTable(lastTimeMark), VectorToTable(isUse), VectorToTable(attribute))
end

--@brief	获取玩家身上装备成功
function ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerBodyEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, betterok, petId)
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
    -- betterok : 
	-- petId : 玩家宠物ID（没有宠物ID为-1）
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_GetPlayerBodyEquipmentOk")
	
	if WindowManager:ifWindowExist(WndPlayer) then
		WndPlayer:receivePlayerEquipmentInfo(VectorToTable(itemCount), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(animationIndexCode), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(sex), VectorToTable(level), VectorToTable(addHP), VectorToTable(addPower), VectorToTable(addAttack), VectorToTable(attackArea), VectorToTable(criticalCoefficient), VectorToTable(addDefend), VectorToTable(addCriticalRate), VectorToTable(useLastTime), VectorToTable(expExtraRate), VectorToTable(p_lastTime), VectorToTable(p_lastNum), VectorToTable(m_proficiency), VectorToTable(hasExpired), VectorToTable(hasShowStrengthenInfo), VectorToTable(pageNumber), VectorToTable(totalNumber), VectorToTable(skillType), VectorToTable(skillLevel), VectorToTable(starLevel), VectorToTable(attackOpen), VectorToTable(defendOpen), VectorToTable(specialOpen), VectorToTable(attackStoneLevel), VectorToTable(defendStoneLevel), VectorToTable(specailStoneLevel), VectorToTable(betterok), VectorToTable(petId))
	end
	
	-- if SceneRanking ~= nil and SceneRanking.m_root ~= nil then
	-- 	SceneRanking:receivePlayerBodyEquipInfo(VectorToTable(itemCount), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(animationIndexCode), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(sex), VectorToTable(level), VectorToTable(addHP), VectorToTable(addPower), VectorToTable(addAttack), VectorToTable(attackArea), VectorToTable(criticalCoefficient), VectorToTable(addDefend), VectorToTable(addCriticalRate), VectorToTable(useLastTime), VectorToTable(expExtraRate), VectorToTable(p_lastTime), VectorToTable(p_lastNum), VectorToTable(m_proficiency), VectorToTable(hasExpired), VectorToTable(hasShowStrengthenInfo), VectorToTable(pageNumber), VectorToTable(totalNumber), VectorToTable(skillType), VectorToTable(skillLevel), VectorToTable(starLevel), VectorToTable(attackOpen), VectorToTable(defendOpen), VectorToTable(specialOpen), VectorToTable(attackStoneLevel), VectorToTable(defendStoneLevel), VectorToTable(specailStoneLevel), VectorToTable(betterok), VectorToTable(petId))
	-- end

	if WndRanking ~= nil and WndRanking.m_root ~= nil then
		WndRanking:receivePlayerBodyEquipInfo(VectorToTable(itemCount), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(animationIndexCode), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(sex), VectorToTable(level), VectorToTable(addHP), VectorToTable(addPower), VectorToTable(addAttack), VectorToTable(attackArea), VectorToTable(criticalCoefficient), VectorToTable(addDefend), VectorToTable(addCriticalRate), VectorToTable(useLastTime), VectorToTable(expExtraRate), VectorToTable(p_lastTime), VectorToTable(p_lastNum), VectorToTable(m_proficiency), VectorToTable(hasExpired), VectorToTable(hasShowStrengthenInfo), VectorToTable(pageNumber), VectorToTable(totalNumber), VectorToTable(skillType), VectorToTable(skillLevel), VectorToTable(starLevel), VectorToTable(attackOpen), VectorToTable(defendOpen), VectorToTable(specialOpen), VectorToTable(attackStoneLevel), VectorToTable(defendStoneLevel), VectorToTable(specailStoneLevel), VectorToTable(betterok), VectorToTable(petId))
	end
end

--@brief	装上装备
function ProtocolProcessorWndPlayer:parse_PLAYER_TakeOnEquipmentOk(itemCount, id, name, icon, animationIndexCode, desc, itemMainType, itemSubType, sex, level, addHP, addPower, addAttack, attackArea, criticalCoefficient, addDefend, addCriticalRate, useLastTime, expExtraRate, p_lastTime, p_lastNum, m_proficiency, hasExpired, hasShowStrengthenInfo, pageNumber, totalNumber, skillType, skillLevel, starLevel, attackOpen, defendOpen, specialOpen, attackStoneLevel, defendStoneLevel, specailStoneLevel, betterok, petId)
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
    -- betterok : 
	-- petId : 玩家宠物ID（没有宠物ID为-1）
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_TakeOnEquipmentOk")
	WndPlayerGoods:receiveTakeOnEquipmentOk(VectorToTable(itemCount), VectorToTable(id), VectorToTable(name), VectorToTable(icon), VectorToTable(animationIndexCode), VectorToTable(desc), VectorToTable(itemMainType), VectorToTable(itemSubType), VectorToTable(sex), VectorToTable(level), VectorToTable(addHP), VectorToTable(addPower), VectorToTable(addAttack), VectorToTable(attackArea), VectorToTable(criticalCoefficient), VectorToTable(addDefend), VectorToTable(addCriticalRate), VectorToTable(useLastTime), VectorToTable(expExtraRate), VectorToTable(p_lastTime), VectorToTable(p_lastNum), VectorToTable(m_proficiency), VectorToTable(hasExpired), VectorToTable(hasShowStrengthenInfo), VectorToTable(pageNumber), VectorToTable(totalNumber), VectorToTable(skillType), VectorToTable(skillLevel), VectorToTable(starLevel), VectorToTable(attackOpen), VectorToTable(defendOpen), VectorToTable(specialOpen), VectorToTable(attackStoneLevel), VectorToTable(defendStoneLevel), VectorToTable(specailStoneLevel), VectorToTable(betterok), VectorToTable(petId))
end

--@brief	添加好友成功
function ProtocolProcessorWndPlayer:parse_FRIEND_AddFriendOk()
	WZLog("ProtocolProcessorWndPlayer:parse_FRIEND_AddFriendOk")
end

--@brief	获取武器强化信息成功
function ProtocolProcessorWndPlayer:parse_PLAYER_GetStrengthenInfoOk(detail)
	-- detail : 武器强化信息描述
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_GetStrengthenInfoOk")
    WndPlayerGoods:getStrengthenInfoOk(detail)
end

--@brief	更改名字结果
function ProtocolProcessorWndPlayer:parse_PLAYER_RenameOk(newName)
	-- newName : 新名字
	WZLog("ProtocolProcessorWndPlayer:parse_PLAYER_RenameOk")
    WndPlayerGoods:useItemOK()
end

--@brief	清除失败次数成功
function ProtocolProcessorWndPlayer:parse_BATTLE_ClearFailNumOk()
	WZLog("ProtocolProcessorWndPlayer:parse_BATTLE_ClearFailNumOk")
    WndPlayerGoods:useItemOK()
end

--@brief	发送奖励物品列表
function ProtocolProcessorWndPlayer:parse_SPREE_GetGiftOk(itemName, itemIcon, itemNum)
	-- itemName : 物品名称
	-- itemIcon : 物品图标
	-- itemNum : 物品对应数量
	WZLog("ProtocolProcessorWndPlayer:parse_SPREE_GetGiftOk")
    WndPlayerGoods:useGiftBagOK(itemName, itemIcon, itemNum)
end

--@brief	玩家好友装备协议(FRIEND_LookEquipmentOk = 26)
function ProtocolProcessorWndPlayer:parse_FRIEND_LookEquipmentOk(headMessage, faceMessage, bodyMessage, weapMessage, wingMessage, ringMessage, ring2Message, necklaceMessage, sceneIndex, petMessage)
	-- headMessage : 玩家头部信息
	-- faceMessage : 玩家脸部信息
	-- bodyMessage : 玩家身体信息
	-- weapMessage : 玩家武器信息
	-- wingMessage : 玩家翅膀信息
	-- ringMessage : 玩家戒指信息
	-- ring2Message : 玩家戒指信息
	-- necklaceMessage : 玩家项链信息
	-- sceneIndex : 场景入口判断
    -- petMessage : 玩家宠物信息
	WZLog("ProtocolProcessorWndPlayer:parse_FRIEND_LookEquipmentOk,PlayerEquip")
	WndPlayer:getPlayerEquipOk( headMessage, faceMessage, bodyMessage, weapMessage, wingMessage, ringMessage, ring2Message, necklaceMessage, sceneIndex, petMessage)
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取玩家仓库装备列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerStoreEquipmentNew_ErrorProcess")
    WndPlayerGoods:errorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerStoreEquipmentNew, nflag, sMessage)
end

--@brief	获取玩家身上装备列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_PLAYER_GetPlayerBodyEquipment_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment, nflag, sMessage)
end

--@brief	获取武器强化信息错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_PLAYER_GetStrengthenInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_PLAYER_GetStrengthenInfo_ErrorProcess")
    WndPlayerGoods:errorProcess(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetStrengthenInfo, nflag, sMessage)
end

--@brief	查看对方资料错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_FRIEND_CheckFriendInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_FRIEND_CheckFriendInfo_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_CheckFriendInfo, nflag, sMessage)
end

--@brief	添加好友错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_FRIEND_AddFriend_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_FRIEND_AddFriend_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_AddFriend, nflag, sMessage)
end

--@brief	更改名字错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_PLAYER_Rename_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_PLAYER_Rename_ErrorProcess")
    WndPlayerGoods:useItemError(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_Rename, nflag, sMessage)
end

--@brief	清除失败次数错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_BATTLE_ClearFailNum_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_BATTLE_ClearFailNum_ErrorProcess")
    WndPlayerGoods:useItemError(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_ClearFailNum, nflag, sMessage)
end

--@brief	获得奖励列表错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_SPREE_GetGift_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_SPREE_GetGift_ErrorProcess")
    WndPlayerGoods:useItemError(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SPREE, Protocol.SPREE_GetGift, nflag, sMessage)
end

--@brief	玩家好友装备协议（FRIEND_LookEquipment = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndPlayer:send_FRIEND_LookEquipment_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndPlayer:send_FRIEND_LookEquipment_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_FRIEND, Protocol.FRIEND_LookEquipment, nflag, sMessage)
end







