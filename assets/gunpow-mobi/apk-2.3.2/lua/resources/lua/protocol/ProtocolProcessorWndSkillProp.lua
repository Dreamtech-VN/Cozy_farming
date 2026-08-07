--ProtocolProcessorWndSkillProp.lua
--@brief	技能道具协议
--@date  	2013/12/10
--@author 	xiezemin
--@note 	技能道具协议


ProtocolProcessorWndSkillProp = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndSkillProp:regAll()
	--获取角色技能列表成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk", "vivs")
	--@brief	获取技能列表 PLAYER_GetSkillListOk = 74
	self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk", "vivi")
	--@brief	获取技能列表 PLAYER_GetWeaponSkillListOk = 95
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk", "viivivivivivsi")
	--@brief	重置武器技能 （PLAYER_ResetWeaponSkillOk = 99）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk", "")


	--@brief	获取玩家技能错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess", "is" )
	--@brief	选择技能错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess", "is" )
    --@brief	获取技能列表（PLAYER_GetSkillList = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList , "ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList _ErrorProcess", "is" )
    --@brief	升级技能（PLAYER_UpgradeSkill = 75）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill , "ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess", "is" )
    --@brief	购买技能栏（PLAYER_BuySkillBox = 79）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox , "ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox_ErrorProcess", "is" )

	--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList, "ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess", "is" )
	--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill , "ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess", "is" )
	--@brief	技能更换（PLAYER_changeWeaponSkill = 97）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess", "is" )
	--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess", "is" )
		
	--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList, "ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess", "is" )
	--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess", "is" )
	--@brief	获取幻化技能列表 （PLAYER_GetShapeSkillListOk = 101）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk", "isvivi")
	--@brief	获取技能列表 PLAYER_UpAwakeSkillOk = 103
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpAwakeSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk", "i")

	--@brief    获取玩家辅助技能（PLAYER2_GetPlayerAssist = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetPlayerAssist, "ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist_ErrorProcess", "is" )
    --@brief    获取技能列表 PLAYER2_GetPlayerAssistSkillOk = 14
    --@brief	助战道具信息（PLAYER2_GetPlayerAssistSkillOk = 14）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetPlayerAssistSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistSkillOk", "istiiiivivsvivii")
    --@brief    获取道具列表 PLAYER2_GetPlayerAssistPropOk = 15
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetPlayerAssistPropOk, "ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistPropOk", "ivivsvivi")
    --@brief    选择孩子坐骑（PLAYER2_ChangePlayerAssistInfo = 16）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistInfo, "ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistInfo_ErrorProcess", "is" )
    --@brief    选择玩家辅助技能（PLAYER2_ChangePlayerAssistChildSkill = 18）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistChildSkill, "ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistChildSkill_ErrorProcess", "is" )
    --@brief    获取道具列表 PLAYER2_ChangeOpResultOk = 17
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangeOpResultOk, "ProtocolProcessorWndSkillProp:parse_PLAYER2_ChangeOpResultOk", "t")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndSkillProp:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取技能列表（PLAYER_GetSkillList = 73）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList()
	WZLog("send_PLAYER_GetSkillList ")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList  )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	升级技能（PLAYER_UpgradeSkill = 75）
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill(skillId,consumeId)
	WZLog("send_PLAYER_UpgradeSkill ")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill  )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(skillId)	-- 技能ID
	sender:writeInt(consumeId)  --消耗物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家技能
function ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill()
	WZLog("send_PLAYER_GetPlayerSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择技能
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill(itemId,index )
	WZLog("send_PLAYER_ChangeSkill", itemId, skillType ,index)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( itemId )	-- 技能ID,如果为0，则删除索引的技能
	sender:writeInt( index )	-- 玩家技能索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买技能栏（PLAYER_BuySkillBox = 79）
function ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox(index )
	WZLog("send_PLAYER_BuySkillBox")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index )	-- 购买的栏位索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList( )
	WZLog("send_PLAYER_GetWeaponSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill(skillId )
	WZLog("send_PLAYER_UpgradeWeaponSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	技能更换（PLAYER_changeWeaponSkill = 97）
function ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill(skillId, index )
	WZLog("send_PLAYER_changeWeaponSkill",skillId, index)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID,如果为0，则删除索引的技能
	sender:writeInt( index )	-- 玩家技能索引（下标冲0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）
function ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill( )
	WZLog("send_PLAYER_ResetWeaponSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList(skillType)
	WZLog("send_PLAYER_GetShapeSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillType )	-- 技能类型【1=被动技能 | 2=主动技能】
	SendProtocol(sender,false) --true:showLoading
end

--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill(skillId, skillType, shapeId)
	WZLog("send_PLAYER_ChangeShapeSkill", skillId, skillType, shapeId)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID
	sender:writeInt( skillType )	-- 技能类型【1=被动技能 | 2=主动技能】
	sender:writeInt( shapeId )	-- 技能所属皮肤ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家辅助技能（PLAYER2_GetPlayerAssist = 13）
function ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist()
	WZLog("send_PLAYER2_GetPlayerAssist")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetPlayerAssist )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择孩子（PLAYER2_ChangePlayerAssistInfo = 16）
function ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistInfo(opType, opId)
	WZLog("send_PLAYER2_ChangePlayerAssistInfo")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( opType )	-- 1 坐骑 2孩子
	sender:writeInt( opId )	-- 孩子id、坐骑id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择玩家辅助技能（PLAYER2_ChangePlayerAssistChildSkill = 18）
function ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistChildSkill(opType, opId, index)
	WZLog("send_PLAYER2_ChangePlayerAssistChildSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistChildSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( opType )	-- 1 技能 2道具
	sender:writeInt( opId )	-- 技能/道具id 0代表卸下
	sender:writeInt( index )	-- 槽位 0,1，2
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取技能列表 PLAYER_GetSkillListOk = 74
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk(itemId, unlock)
	-- itemId : 技能id
	-- unlock : 是否已解锁
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk", Serialize(VectorToTable(itemId)), Serialize(VectorToTable(unlock)))
	CacheCenter:updateSkillList(VectorToTable(itemId),VectorToTable(unlock))
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
		WndSkillProp:showSkillProps(VectorToTable(itemId),VectorToTable(unlock))
	end
	CacheCenter:setPropsRed()
	--更新红点
	WndSkillContainer:_bShowRed()
	CacheCenter:updateRedPoint("right", SceneCity.m_tWndBottomBar, nil)
end

--@brief	获取角色技能列表成功
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk(itemId,skillExplain)
	-- count : 数量
	-- id : 道具序号
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk ", Serialize(VectorToTable(itemId)), Serialize(VectorToTable(skillExplain)))
	CacheCenter:updatePlayerSkill(VectorToTable(itemId),VectorToTable(skillExplain))
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
		WndSkillProp:receiveGetPlayerSkillOk(VectorToTable(itemId),VectorToTable(skillExplain))
	end
end

--@brief	获取技能列表 PLAYER_GetWeaponSkillListOk = 95
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk(unlockSkill, skillNum, useSkill, openLevel, logtype, logskillId, mes, mentorSkill)
	-- unlockSkill : 获得技能id
	-- skillNum : 技能点
	-- useSkill : 使用中技能id
	-- openLevel : 开启技能孔等级
	-- mentorSkill : 领取了的师门技能，没有则为0
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk", 
		"\n unlockSkill = ",Serialize(VectorToTable(unlockSkill)), 
		"\n skillNum = ",Serialize(VectorToTable(skillNum)), 
		"\n useSkill = ",Serialize(VectorToTable(useSkill)), 
		"\n openLevel = ",Serialize(VectorToTable(openLevel)), 
		"\n logtype = ",Serialize(VectorToTable(logtype)), 
		"\n logskillId = ",Serialize(VectorToTable(logskillId)), 
		"\n mes = ",Serialize(VectorToTable(mes)), 
		"\n mentorSkill = ",Serialize(VectorToTable(mentorSkill)))
	--用技能书
	if USESKILLBOOK then
		WZLog("用技能书")
		USESKILLBOOK = false
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL25)
	end
	CacheCenter:setSkill(VectorToTable(unlockSkill), skillNum, VectorToTable(useSkill), VectorToTable(openLevel), VectorToTable(logtype), 
						 VectorToTable(logskillId), VectorToTable(mes), mentorSkill)
	GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief	重置武器技能 （PLAYER_ResetWeaponSkillOk = 99）
function ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk()
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk")
	MsgBoxManager:showTipBox(LocalStrings.NEWSKILL21)
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 1 then
		WndSkillProp:selectFirst()
	end
end

--@brief	获取幻化技能列表 （PLAYER_GetShapeSkillListOk = 101）
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk(skillType, useSkill, skillList, shapeList)
	-- useSkill : 技能类型【1=被动技能 | 2=主动技能】
	-- useSkill : 使用中技能id
	-- skillList : 拥有的所有技能
	-- shapeList : 拥有的所有技能所属皮肤ID
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk", 
		"\nskillType",Serialize(VectorToTable(skillType)),
		"\nuseSkill",Serialize(VectorToTable(useSkill)),
		"\nskillList",Serialize(VectorToTable(skillList)),
		"\nshapeList",Serialize(VectorToTable(shapeList))
	)
	WndSkinSkill:setData(useSkill, skillList, skillType, shapeList)

	CacheCenter:setSkinBigSkillData(skillType, useSkill, VectorToTable(skillList), VectorToTable(shapeList))
end

--@brief	升级觉醒技能 （PLAYER_UpAwakeSkillOk = 103）
function ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk(awakeSkillId)
	-- awakeSkillId : 升级后的觉醒技能id
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk", awakeSkillId)
	CellWakeupDetail:upgradeSubSkillOK(awakeSkillId)
end

--@brief	获取技能列表 PLAYER2_GetPlayerAssistSkillOk = 14
function ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistSkillOk(childId, childName, childSex, childLevel, childHeadId, childFaceId, childBodyId, useSkill, unlockRemark, unlockSkill, unlockSkillNum, headEffectId)
	-- childId: 选中的孩子id  0未选中
	-- childName: 孩子名字
	-- childSex: 孩子性别
	-- childLevel: 孩子等级
	-- childHeadId: 孩子头
	-- childFaceId: 孩子脸
	-- childBodyId: 孩子身
	-- useSkill: 孩子装备的技能id  -1未解锁
	-- unlockRemark: 槽位解锁说明
	-- unlockSkill: 解锁后的技能id
	-- unlockSkillNum: 解锁后的技能可使用的数量
	-- headEffectId: 小孩头像框

	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistSkillOk")
	
	CacheCenter:setKidAssistSkillData(childId, childName, childSex, childLevel, childHeadId, childFaceId, childBodyId, VectorToTable(useSkill), VectorToTable(unlockRemark), VectorToTable(unlockSkill), VectorToTable(unlockSkillNum), headEffectId)
end

--@brief	获取道具列表 PLAYER2_GetPlayerAssistPropOk = 15
function ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistPropOk(mountsId, useProp, unlockRemark, unlockSkill, unlockSkillNum)
	-- mountsId: 乘坐的坐骑id 0没有乘坐
	-- useProp: 装备的道具id  -1未解锁
	-- unlockRemark: 槽位解锁说明
	-- unlockSkill: 解锁后的技能id
	-- unlockSkillNum: 解锁后的技能可使用的数量

	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER2_GetPlayerAssistPropOk")
	CacheCenter:setMountAssistSkillData(mountsId, VectorToTable(useProp), VectorToTable(unlockRemark), VectorToTable(unlockSkill), VectorToTable(unlockSkillNum))
end

--@brief	获取道具列表 PLAYER2_ChangeOpResultOk = 17
function ProtocolProcessorWndSkillProp:parse_PLAYER2_ChangeOpResultOk(result)
	-- result: 1成功 2失败 对应推送上面的协议

	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER2_ChangeOpResultOk", result)
	if result == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.ASSIST_SKILL12)
	end
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	购买技能栏（PLAYER_BuySkillBox = 79）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox , nflag, sMessage)
end


--@brief	获取玩家技能错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill, nflag, sMessage)
end

--@brief	选择技能错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess")
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
	WndSkillProp:changeSkillError(nFlag,sMessage)
	end
	--ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill, nflag, sMessage)
end

--@brief	获取技能列表（PLAYER_GetSkillList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList , nflag, sMessage)
end

--@brief	升级技能（PLAYER_BuySkill = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess")
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
	WndSkillProp:resertCurSelectId()
		WndSkillProp.m_bClickUpgrade = false
        WndSkillProp.m_bIsVisitNet = false
	end
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill , nflag, sMessage)
end

--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList, nflag, sMessage)
end

--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill , nflag, sMessage)
end

--@brief	技能更换（PLAYER_changeWeaponSkill = 97）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill, nflag, sMessage)
end

--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill, nflag, sMessage)
end

--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList, nflag, sMessage)
end

--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill, nflag, sMessage)
end

--@brief	获取玩家辅助技能（PLAYER2_GetPlayerAssist = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER2_GetPlayerAssist_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_GetPlayerAssist, nflag, sMessage)
end

--@brief	选择孩子（PLAYER2_ChangePlayerAssistInfo = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistInfo, nflag, sMessage)
end

--@brief	选择玩家辅助技能（PLAYER2_ChangePlayerAssistChildSkill = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistChildSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER2_ChangePlayerAssistChildSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER2, Protocol.PLAYER2_ChangePlayerAssistChildSkill, nflag, sMessage)
end

