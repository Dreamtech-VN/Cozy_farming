--ProtocolProcessorProfession.lua
--@brief    卡牌系统相关协议
--@date     2016/4/14
--@author   Tianxiang_Xu
--@note     卡牌系统相关协议


ProtocolProcessorProfession = ProtocolProcessorBase:new()


--@brief    注册协议组所有协议
--@note     注册协议组所有协议
function ProtocolProcessorProfession:regAll()
    --@brief    获取信息返回（PROFESSION_GetInfoOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_GetInfoOk, "ProtocolProcessorProfession:parse_PROFESSION_GetInfoOk", "iiiiviviiviviviviiivivi")
    --@brief    技能升级返回（PROFESSION_UpSKillOk = 6）
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpSKillOk, "ProtocolProcessorProfession:parse_PROFESSION_UpSKillOk", "t")

    --@brief    获取信息（PROFESSION_GetInfo = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_GetInfo, "ProtocolProcessorProfession:send_PROFESSION_GetInfo_ErrorProcess", "is" )
    --@brief    选择职业或者转职（PROFESSION_Choose = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_Choose, "ProtocolProcessorProfession:send_PROFESSION_Choose_ErrorProcess", "is" )
    --@brief    重置天赋技能（PROFESSION_ResetTalent = 4）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_ResetTalent, "ProtocolProcessorProfession:send_PROFESSION_ResetTalent_ErrorProcess", "is" )
    --@brief    技能升级（PROFESSION_UpSKill = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpSKill, "ProtocolProcessorProfession:send_PROFESSION_UpSKill_ErrorProcess", "is" )
    --@brief    升级职业进阶技 165+（PROFESSION_UpAdvSkill = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpAdvSkill, "ProtocolProcessorProfession:send_PROFESSION_UpAdvSkill_ErrorProcess", "is")
    --@brief    升级职业进阶技165+（PROFESSION_UpAdvSkillOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpAdvSkillOk, "ProtocolProcessorProfession:parse_PROFESSION_UpAdvSkillOk", "iiivivi")
end



--@brief    反注册协议组所有协议
--@note     反注册协议组所有协议
function ProtocolProcessorProfession:unregAll()
    self:clearReg()
end


--------------------------客户端到服务器协议发送方法模块----------------------------------
--@brief    获取信息（PROFESSION_GetInfo = 1）
function ProtocolProcessorProfession:send_PROFESSION_GetInfo()
    WZLog("send_PROFESSION_GetInfo")
    local sender = Protocol:getSender( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_GetInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    选择职业或者转职（PROFESSION_Choose = 3）
function ProtocolProcessorProfession:send_PROFESSION_Choose(profession)
    WZLog("send_PROFESSION_Choose")
    local sender = Protocol:getSender( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_Choose )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( profession )   -- 职业Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    重置天赋技能（PROFESSION_ResetTalent = 4）
function ProtocolProcessorProfession:send_PROFESSION_ResetTalent(operateType)
    WZLog("send_PROFESSION_ResetTalent")
    local sender = Protocol:getSender( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_ResetTalent )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( operateType or 0 )   -- 操作类型【0=重置一转|1=重置二转】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    技能升级（PROFESSION_UpSKill = 5）
function ProtocolProcessorProfession:send_PROFESSION_UpSKill(node, treeType, operateType)
    WZLog("send_PROFESSION_UpSKill")
    local sender = Protocol:getSender( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpSKill )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( node )   -- 节点
    sender:writeByte( treeType or 0 )   -- 树类型【0=一转天赋树 | 1=二转角色天赋树 | 2=二转宠物天赋树】
    sender:writeByte( operateType or 0 )   -- 操作类型【0=节点升级|1=水晶节点变色】
    SendProtocol(sender,false) --true:showLoading
end

--@brief    升级职业进阶技 165+（PROFESSION_UpAdvSkill = 7）
function ProtocolProcessorProfession:send_PROFESSION_UpAdvSkill()
    WZLog("send_PROFESSION_UpAdvSkill")
    local sender = Protocol:getSender( Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpAdvSkill )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end
--------------------------服务器到客户端协议回调方法模块----------------------------------
--@brief    获取信息返回（PROFESSION_GetInfoOk = 2）
function ProtocolProcessorProfession:parse_PROFESSION_GetInfoOk(status, profession, professionChangeCount, talentResetCount, node, talentSkill, talentResetCount2, roleNode, roleTalentSkill, petNode, petTalentSkill, advLv, advGrade, attrType, attrValue)
    -- status : 0 未完成前置任务 1：已经完成前置任务, 2=可开启2转【注：为2必然可以开启二转，为1需要前端额外进行判断是否可开启二转】
    -- profession : 职业
    -- professionChangeCount : 转职次数
    -- talentResetCount : 天赋重置次数
    -- node : 节点
    -- talentSkill : 天赋Id
    -- talentResetCount2 : 二转天赋重置次数
    -- roleNode : 二转角色天赋树已激活节点编号
    -- roleTalentSkill : 二转角色天赋树已激活职业技能ID
    -- petNode : 二转宠物天赋树已激活节点编号
    -- petTalentSkill : 二转宠物天赋树已激活职业技能ID
    WZLog("ProtocolProcessorProfession:parse_PROFESSION_GetInfoOk")
    CacheCenter:setProfessionData(status, profession, VectorToTable(node), VectorToTable(talentSkill), VectorToTable(roleNode), VectorToTable(roleTalentSkill), VectorToTable(petNode), VectorToTable(petTalentSkill))
    if WndProfession.m_root then 
        WndProfession:setData(status, profession, professionChangeCount, talentResetCount, VectorToTable(node), VectorToTable(talentSkill), talentResetCount2, VectorToTable(roleNode), VectorToTable(roleTalentSkill), VectorToTable(petNode), VectorToTable(petTalentSkill), advLv, advGrade, VectorToTable(attrType), VectorToTable(attrValue))
    end
end

--@brief    技能升级返回（PROFESSION_UpSKillOk = 6）
function ProtocolProcessorProfession:parse_PROFESSION_UpSKillOk(treeType)
    WZLog("ProtocolProcessorProfession:parse_PROFESSION_UpSKillOk", treeType)

    WndProfession:upgradeSuccess(treeType)
end

--@brief    升级职业进阶技165+（PROFESSION_UpAdvSkillOk = 8）
function ProtocolProcessorProfession:parse_PROFESSION_UpAdvSkillOk(result, advLv, advGrade, attrType, attrValue)
    -- result : 返回结果 1成功 2已经满级了 3物品不足 4失败
    -- advLv : 进阶等级
    -- advGrade : 层数
    -- attrType : 属性类型
    -- attrValue : 属性值
    WZLog("ProtocolProcessorProfession:parse_PROFESSION_UpAdvSkillOk")

    WndProfession:setAdvanceSkillData(advLv, advGrade, VectorToTable(attrType), VectorToTable(attrValue), result)
end
--------------------------------协议错误处理方法模块--------------------------------------
--@brief    获取信息（PROFESSION_GetInfo = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorProfession:send_PROFESSION_GetInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorProfession:send_PROFESSION_GetInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PROFESSION, Protocol.PROFESSION_GetInfo, nflag, sMessage)
end

--@brief    选择职业或者转职（PROFESSION_Choose = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorProfession:send_PROFESSION_Choose_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorProfession:send_PROFESSION_Choose_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PROFESSION, Protocol.PROFESSION_Choose, nflag, sMessage)
end

--@brief    重置天赋技能（PROFESSION_ResetTalent = 4）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorProfession:send_PROFESSION_ResetTalent_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorProfession:send_PROFESSION_ResetTalent_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PROFESSION, Protocol.PROFESSION_ResetTalent, nflag, sMessage)
end

--@brief    技能升级（PROFESSION_UpSKill = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorProfession:send_PROFESSION_UpSKill_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorProfession:send_PROFESSION_UpSKill_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpSKill, nflag, sMessage)
end

--@brief    升级职业进阶技 165+（PROFESSION_UpAdvSkill = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorProfession:send_PROFESSION_UpAdvSkill_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorProfession:parse_PROFESSION_UpAdvSkill_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PROFESSION, Protocol.PROFESSION_UpAdvSkill, nflag, sMessage)
end