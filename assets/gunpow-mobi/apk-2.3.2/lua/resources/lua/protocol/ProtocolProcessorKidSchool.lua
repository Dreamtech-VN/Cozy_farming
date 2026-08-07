--ProtocolProcessorKidSchool.lua
--@brief	结婚礼堂相关协议
--@date  	2021/5/10
--@author 	叶威
--@note 	结婚礼堂相关协议


ProtocolProcessorKidSchool = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorKidSchool:regAll()
    --@brief    获取学校列表（SCHOOL_GetSchoolList = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolList, "ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList_ErrorProcess", "is")
    --@brief    创建学校（SCHOOL_CreateSchool = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_CreateSchool, "ProtocolProcessorKidSchool:send_SCHOOL_CreateSchool_ErrorProcess", "is")
    --@brief    进入学校（SCHOOL_EntrySchool = 5）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EntrySchool, "ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool_ErrorProcess", "is")
    --@brief    离开学校（SCHOOL_LeaveSchool = 6）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_LeaveSchool, "ProtocolProcessorKidSchool:send_SCHOOL_LeaveSchool_ErrorProcess", "is")
    --@brief    获取学校信息（SCHOOL_GetSchoolInfo = 7）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolInfo, "ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolInfo_ErrorProcess", "is")
    --@brief    申请入学（SCHOOL_ApplySchool = 9）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ApplySchool, "ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool_ErrorProcess", "is")
    --@brief    审批入学学生（SCHOOL_Approve = 11）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_Approve, "ProtocolProcessorKidSchool:send_SCHOOL_Approve_ErrorProcess", "is")
    --@brief    解散学校（SCHOOL_DismissSchool = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DismissSchool, "ProtocolProcessorKidSchool:send_SCHOOL_DismissSchool_ErrorProcess", "is")
    --@brief    转让学校（SCHOOL_ChangeSchoolMaster = 15）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeSchoolMaster, "ProtocolProcessorKidSchool:send_SCHOOL_ChangeSchoolMaster_ErrorProcess", "is")
    --@brief    捐献（SCHOOL_DonateSchool = 17）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DonateSchool, "ProtocolProcessorKidSchool:send_SCHOOL_DonateSchool_ErrorProcess", "is")
    --@brief    编辑学校（SCHOOL_EditSchool = 19）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchool, "ProtocolProcessorKidSchool:send_SCHOOL_EditSchool_ErrorProcess", "is")
    --@brief    领取孩子奖励（SCHOOL_ReceiveReward = 23）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ReceiveReward, "ProtocolProcessorKidSchool:send_SCHOOL_ReceiveReward_ErrorProcess", "is")
    --@brief    获取审批列表(校长用的)（SCHOOL_GetApplyList = 25）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetApplyList, "ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList_ErrorProcess", "is")
    --@brief    切换孩子上学（SCHOOL_ChangeChild = 29）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeChild, "ProtocolProcessorKidSchool:send_SCHOOL_ChangeChild_ErrorProcess", "is")
    --@brief    进入后学校后每5秒发一次心跳（SCHOOL_HeartbeatSchool = 32）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HeartbeatSchool, "ProtocolProcessorKidSchool:send_SCHOOL_HeartbeatSchool_ErrorProcess", "is")
    --@brief    获取家长列表（SCHOOL_GetParentList = 37）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetParentList, "ProtocolProcessorKidSchool:send_SCHOOL_GetParentList_ErrorProcess", "is")
    --@brief    退学（SCHOOL_QuitSchool = 39）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_QuitSchool, "ProtocolProcessorKidSchool:send_SCHOOL_QuitSchool_ErrorProcess", "is")
    --@brief    获取自己学校和学生的状态（SCHOOL_GetState = 45）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetState, "ProtocolProcessorKidSchool:send_SCHOOL_GetState_ErrorProcess", "is")
    --@brief    获取我的学校信息【p】（SCHOOL_GetMySchoolInfo = 46）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetMySchoolInfo, "ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo_ErrorProcess", "is")
    --@brief    获取本校孩子列表（SCHOOL_GetSchoolChildren = 48）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolChildren, "ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren_ErrorProcess", "is")
    --@brief    隐藏学校(列表中不显示)（SCHOOL_HideSchool = 50）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HideSchool, "ProtocolProcessorKidSchool:send_SCHOOL_HideSchool_ErrorProcess", "is")
    --@brief    清退孩子(校长操作孩子退学)（SCHOOL_ClearChild = 43）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ClearChild, "ProtocolProcessorKidSchool:send_SCHOOL_ClearChild_ErrorProcess", "is")
    --@brief    获取孩子信息（SCHOOL_GetChildInfo = 52）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildInfo, "ProtocolProcessorKidSchool:send_SCHOOL_GetChildInfo_ErrorProcess", "is")
    --@brief    获取上学中的孩子技能信息（SCHOOL_GetChildSkillInfo = 54）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildSkillInfo, "ProtocolProcessorKidSchool:send_SCHOOL_GetChildSkillInfo_ErrorProcess", "is")
    --@brief    编辑学校宣言166+（SCHOOL_EditSchoolDeclaration = 60）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchoolDeclaration, "ProtocolProcessorKidSchool:send_SCHOOL_EditSchoolDeclaration_ErrorProcess", "is")


    --@brief    获取学校列表（SCHOOL_GetSchoolListOk = 2）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolListOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolListOk", "vivsvivivivi")
    --@brief    创建学校（SCHOOL_CreateSchoolOk = 4）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_CreateSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_CreateSchoolOk", "i")
    --@brief    进入学校结果（SCHOOL_EntrySchoolOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EntrySchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_EntrySchoolOk", "i")
    --@brief    学校状况【162+】（SCHOOL_SchoolState = 21）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_SchoolState, "ProtocolProcessorKidSchool:parse_SCHOOL_SchoolState", "viviviviiisivssi")
    --@brief    学生情况主动推送（SCHOOL_ChildState = 22）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChildState, "ProtocolProcessorKidSchool:parse_SCHOOL_ChildState", "vivivivivtvivivivivivivivsvi")
    --@brief    获取学校信息（SCHOOL_GetSchoolInfoOk = 8）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolInfoOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolInfoOk", "iisiiiiibsis")
    --@brief    协议号名字（SCHOOL_ApplySchoolOk = 10）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ApplySchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ApplySchoolOk", "i")
    --@brief    审批入学学生（SCHOOL_ApproveOk = 12）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ApproveOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ApproveOk", "i")
    --@brief    解散学校（SCHOOL_DismissSchoolOk = 14）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DismissSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_DismissSchoolOk", "ii")
    --@brief    更换校长（SCHOOL_ChangeSchoolMasterOk = 16）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeSchoolMasterOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ChangeSchoolMasterOk", "i")
    --@brief    捐献（SCHOOL_DonateSchoolOk = 18）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DonateSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_DonateSchoolOk", "i")
    --@brief    编辑学校（SCHOOL_EditSchoolOk = 20）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolOk", "i")
    --@brief    领取孩子奖励（SCHOOL_ReceiveRewardOk = 24）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ReceiveRewardOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ReceiveRewardOk", "vivivi")
    --@brief    获取审批列表（SCHOOL_GetApplyListOk = 26）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetApplyListOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetApplyListOk", "vivivivtvivivivsvivsvivivtvivi")
    --@brief    加入区域（SCHOOL_JoinArea = 27）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_JoinArea, "ProtocolProcessorKidSchool:send_SCHOOL_JoinArea_ErrorProcess", "is")
    --@brief    进入区域结果（SCHOOL_JoinAreaOk = 28）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_JoinAreaOk, "ProtocolProcessorKidSchool:parse_SCHOOL_JoinAreaOk", "i")
    --@brief    切换孩子上学（SCHOOL_ChangeChildOk = 30）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeChildOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ChangeChildOk", "i")
    --@brief    获取家长列表（SCHOOL_GetParentListOk = 38）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetParentListOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetParentListOk", "vivsvivtvivivi")
    --@brief    退学（SCHOOL_QuitSchoolOk = 40）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_QuitSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_QuitSchoolOk", "i")
    --@brief    获取我的学校信息（SCHOOL_GetMySchoolInfoOk = 47）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetMySchoolInfoOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetMySchoolInfoOk", "iisiiiiibsibibis")
    --@brief    获取本校孩子列表（SCHOOL_GetSchoolChildrenOk = 49）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolChildrenOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolChildrenOk", "vivivsvivivtvivivivivivivtvivivivsvi")
    --@brief    隐藏学校(列表中不显示)（SCHOOL_HideSchoolOk = 51）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HideSchoolOk, "ProtocolProcessorKidSchool:parse_SCHOOL_HideSchoolOk", "i")
    --@brief    清退孩子（SCHOOL_ClearChildOk = 44）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ClearChildOk, "ProtocolProcessorKidSchool:parse_SCHOOL_ClearChildOk", "i")
    --@brief    获取孩子信息（SCHOOL_GetChildInfoOk = 53）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildInfoOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetChildInfoOk", "iiiiiiiiiiiiiiiii")
    --@brief    获取孩子技能信息（SCHOOL_GetChildSkillInfoOk = 55）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildSkillInfoOk, "ProtocolProcessorKidSchool:parse_SCHOOL_GetChildSkillInfoOk", "iiiiiiiiivivivi")
    --@brief    编辑学校宣言166+（SCHOOL_EditSchoolDeclarationOk = 61）
    self:regProtocolCallbackFunction( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchoolDeclarationOk, "ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolDeclarationOk", "i")

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorKidSchool:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

--@brief    获取学校列表（SCHOOL_GetSchoolList = 1）
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList()
    WZLog("send_SCHOOL_GetSchoolList")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    创建学校（SCHOOL_CreateSchool = 3）
function ProtocolProcessorKidSchool:send_SCHOOL_CreateSchool(password, name)
    WZLog("send_SCHOOL_CreateSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_CreateSchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString(password)    -- 密码 无密码填空字符串"",限制长度<=6
    sender:writeString(name)    -- 学校名字 ,>=4限制长度<=8
    SendProtocol(sender,false) --true:showLoading
end

--@brief    进入学校（SCHOOL_EntrySchool = 5）
function ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(schoolId)
    WZLog("send_SCHOOL_EntrySchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EntrySchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(schoolId)   -- 自己学校就填0
    SendProtocol(sender,false) --true:showLoading
end

--@brief    离开学校（SCHOOL_LeaveSchool = 6）
function ProtocolProcessorKidSchool:send_SCHOOL_LeaveSchool(schoolId)
    WZLog("send_SCHOOL_LeaveSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_LeaveSchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(schoolId)   -- 自己学校就填0
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取学校信息（SCHOOL_GetSchoolInfo = 7）
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolInfo(schoolId)
    WZLog("send_SCHOOL_GetSchoolInfo", schoolId)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(schoolId)   -- 学校id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    申请入学（SCHOOL_ApplySchool = 9）
function ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool(schoolId, password)
    WZLog("send_SCHOOL_ApplySchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ApplySchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(schoolId)   -- 学校id
    sender:writeString(password)    -- 密码 没有填写传""空字符串length<6
    SendProtocol(sender,false) --true:showLoading
end

--@brief    审批入学学生（SCHOOL_Approve = 11）
function ProtocolProcessorKidSchool:send_SCHOOL_Approve(ids, opType)
    WZLog("send_SCHOOL_Approve")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_Approve )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts(ids)   -- 需要审批的id
    sender:writeInt(opType) -- 操作类型 1同意 | 2不同意
    SendProtocol(sender,false) --true:showLoading
end

--@brief    解散学校（SCHOOL_DismissSchool = 13）
function ProtocolProcessorKidSchool:send_SCHOOL_DismissSchool()
    WZLog("send_SCHOOL_DismissSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DismissSchool )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    转让学校（SCHOOL_ChangeSchoolMaster = 15）
function ProtocolProcessorKidSchool:send_SCHOOL_ChangeSchoolMaster(newMasterId)
    WZLog("send_SCHOOL_ChangeSchoolMaster",newMasterId)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeSchoolMaster )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(newMasterId)    -- 新校长名字
    SendProtocol(sender,false) --true:showLoading
end

--@brief    捐献（SCHOOL_DonateSchool = 17）
function ProtocolProcessorKidSchool:send_SCHOOL_DonateSchool(opType)
    WZLog("send_SCHOOL_DonateSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DonateSchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(opType) -- 操作类型
    SendProtocol(sender,false) --true:showLoading
end

--@brief    编辑学校（SCHOOL_EditSchool = 19）
function ProtocolProcessorKidSchool:send_SCHOOL_EditSchool(password, name)
    WZLog("send_SCHOOL_EditSchool", password, name)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString(password)    -- 不需要修改填-1
    sender:writeString(name)    -- 学校名字 ,>=4限制长度<=8
    SendProtocol(sender,false) --true:showLoading
end

--@brief    领取孩子奖励（SCHOOL_ReceiveReward = 23）
function ProtocolProcessorKidSchool:send_SCHOOL_ReceiveReward()
    WZLog("send_SCHOOL_ReceiveReward")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ReceiveReward )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取审批列表(校长用的)（SCHOOL_GetApplyList = 25）
function ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList()
    WZLog("send_SCHOOL_GetApplyList")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetApplyList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    加入区域（SCHOOL_JoinArea = 27）
function ProtocolProcessorKidSchool:send_SCHOOL_JoinArea(areaType)
    WZLog("send_SCHOOL_JoinArea",areaType)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_JoinArea )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(areaType)   -- 进入区域<br>1学习 2休息 3运动 4科学 0无所事事
    SendProtocol(sender,false) --true:showLoading
end

--@brief    切换孩子上学（SCHOOL_ChangeChild = 29）
function ProtocolProcessorKidSchool:send_SCHOOL_ChangeChild()
    WZLog("send_SCHOOL_ChangeChild")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeChild )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    进入后学校后每5秒发一次心跳（SCHOOL_HeartbeatSchool = 32）
function ProtocolProcessorKidSchool:send_SCHOOL_HeartbeatSchool()
    WZLog("send_SCHOOL_HeartbeatSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HeartbeatSchool )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取家长列表（SCHOOL_GetParentList = 37）
function ProtocolProcessorKidSchool:send_SCHOOL_GetParentList()
    WZLog("send_SCHOOL_GetParentList")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetParentList )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    退学（SCHOOL_QuitSchool = 39）
function ProtocolProcessorKidSchool:send_SCHOOL_QuitSchool()
    WZLog("send_SCHOOL_QuitSchool")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_QuitSchool )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取自己学校和学生的状态（SCHOOL_GetState = 45）
function ProtocolProcessorKidSchool:send_SCHOOL_GetState(schoolId)
    WZLog("send_SCHOOL_GetState", schoolId)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetState )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(schoolId)   -- 自己学校就填0
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取我的学校信息【p】（SCHOOL_GetMySchoolInfo = 46）
function ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
    WZLog("send_SCHOOL_GetMySchoolInfo")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetMySchoolInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取本校孩子列表（SCHOOL_GetSchoolChildren = 48）
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren()
    WZLog("send_SCHOOL_GetSchoolChildren")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolChildren )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    隐藏学校(列表中不显示)（SCHOOL_HideSchool = 50）
function ProtocolProcessorKidSchool:send_SCHOOL_HideSchool(status)
    WZLog("send_SCHOOL_HideSchool", status)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HideSchool )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(status) -- 状态 0开放 1隐藏
    SendProtocol(sender,false) --true:showLoading
end

--@brief    清退孩子(校长操作孩子退学)（SCHOOL_ClearChild = 43）
function ProtocolProcessorKidSchool:send_SCHOOL_ClearChild(childIds)
    WZLog("send_SCHOOL_ClearChild", Serialize(VectorToTable(childIds)))
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ClearChild )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInts(childIds)  -- 需要清退的学生
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取孩子信息（SCHOOL_GetChildInfo = 52）
function ProtocolProcessorKidSchool:send_SCHOOL_GetChildInfo(childId)
    WZLog("send_SCHOOL_GetChildInfo")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildInfo )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt(childId)    -- 孩子id
    SendProtocol(sender,false) --true:showLoading
end

--@brief    获取上学中的孩子技能信息（SCHOOL_GetChildSkillInfo = 54）
function ProtocolProcessorKidSchool:send_SCHOOL_GetChildSkillInfo()
    WZLog("send_SCHOOL_GetChildSkillInfo")
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildSkillInfo )
    if sender==nil then WZLog("sender == nil") return end

    SendProtocol(sender,false) --true:showLoading
end

--@brief    编辑学校宣言166+（SCHOOL_EditSchoolDeclaration = 60）
function ProtocolProcessorKidSchool:send_SCHOOL_EditSchoolDeclaration(declaration)
    WZLog("send_SCHOOL_EditSchoolDeclaration",declaration)
    local sender = Protocol:getSender( Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchoolDeclaration )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString(declaration) -- 宣言
    SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief    获取学校列表（SCHOOL_GetSchoolListOk = 2）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolListOk(schoolIds, schoolNames, schoolLevels, schoolEffectIds, schoolNums, schoolMaxNums)
    -- schoolIds : 学校id
    -- schoolNames : 学校名称
    -- schoolLevels : 学校等级
    -- schoolEffectIds : 学校加成等级Id<br>对应学习表tab_study里面的id
    -- schoolNums : 学校人数
    -- schoolMaxNums : 学校最大人数
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolListOk", 
        "\nschoolIds = ",Serialize(VectorToTable(schoolIds)), 
        "\nschoolNames = ",Serialize(VectorToTable(schoolNames)), 
        "\nschoolLevels = ",Serialize(VectorToTable(schoolLevels)), 
        "\nschoolEffectIds = ",Serialize(VectorToTable(schoolEffectIds)), 
        "\nschoolNums = ",Serialize(VectorToTable(schoolNums)),
        "\nschoolMaxNums = ",Serialize(VectorToTable(schoolMaxNums))
        )

    if WndKidSchoolList.m_root then
        WndKidSchoolList:setSchoolListOk(VectorToTable(schoolIds), VectorToTable(schoolNames), VectorToTable(schoolLevels), VectorToTable(schoolEffectIds), VectorToTable(schoolNums), VectorToTable(schoolMaxNums))
    end
end

--@brief    创建学校（SCHOOL_CreateSchoolOk = 4）
function ProtocolProcessorKidSchool:parse_SCHOOL_CreateSchoolOk(result)
    -- result : 结果 1成功 2失败 3已经创建了 4没有孩子不能创建学校 5名字不合规 6长度不合规 7存在同名学校了 8请等待孩子生出来后在创建 9离婚中不能操作 10请等婚礼举办后再操作 
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_CreateSchoolOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT217)
        WndKidSchoolList:sendCreateSchoolOk()
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT231)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT160)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT161)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT162)
    elseif result == 6 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT163)
    elseif result == 7 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT164)
    elseif result == 8 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT165)
    elseif result == 9 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT211)
    elseif result == 10 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT212)
    end
end

--@brief    进入学校结果（SCHOOL_EntrySchoolOk = 35）
function ProtocolProcessorKidSchool:parse_SCHOOL_EntrySchoolOk(result)
    -- result : 结果 1可进入 2学校已经解散了
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EntrySchoolOk", result)
    if result == 1 then
        SceneKidSchoolHome:showInterface()
    elseif result == 2 then
        WndKidSchoolList:showInterface(2)
    end
end

--@brief    学校状况【162+】（SCHOOL_SchoolState = 21）
function ProtocolProcessorKidSchool:parse_SCHOOL_SchoolState(myChildId, areaType, areaNum, areaMaxNum, level, masterId, masterName, effectId, myChildName, schoolName, schoolEffectId)
    -- myChildId : 我入学的孩子id<br>用数组预留以后两个都可以入学
    -- areaType : 区域类型 下面的数据都对应上去 <br>[0无所事事 1学习 2休息 3运动 4科学 ]
    -- areaNum : 当前每个区域的人数
    -- areaMaxNum : 当前每个区域的最大人数
    -- level : 学校等级
    -- masterId : 校长id
    -- masterName : 校长名字
    -- effectId : 学习效率id
    -- myChildName : 我的孩子名字
    -- schoolName : 学校名字
    -- schoolEffectId : 学校当前学习效率id
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_SchoolState",
        "\nmyChildId = ",Serialize(VectorToTable(myChildId)),
        "\nareaType = ",Serialize(VectorToTable(areaType)),
        "\nareaNum = ",Serialize(VectorToTable(areaNum)),
        "\nareaMaxNum = ",Serialize(VectorToTable(areaMaxNum)),
        "\nlevel = ",level,
        "\nmasterId = ",masterId,
        "\nmasterName = ",masterName,
        "\neffectId = ",effectId,
        "\nmyChildName = ",Serialize(VectorToTable(myChildName)),
        "\nschoolName = ",schoolName,
        "\nschoolEffectId = ",schoolEffectId
        )

    if SceneKidSchoolHome.m_root then
        SceneKidSchoolHome:setSchoolStateData(VectorToTable(myChildId), VectorToTable(areaType), VectorToTable(areaNum), VectorToTable(areaMaxNum), level, masterId, masterName, effectId, VectorToTable(myChildName), schoolName, schoolEffectId)
    end
end

--@brief    学生情况主动推送（SCHOOL_ChildState = 22）
function ProtocolProcessorKidSchool:parse_SCHOOL_ChildState(ids, levels, faceIds, headIds, sexs, bodyIds, areas, areaTime, positions, rewards, learnTimes, status, names, scienceTimes)
    -- ids : 需要更新的孩子id<br>孩子奖励状态|离开进入区域，进入学校，离开学校推送
    -- levels : 孩子等级
    -- faceIds : 孩子脸id
    -- headIds : 孩子头id
    -- sexs : 孩子性别
    -- bodyIds : 孩子身体id
    -- areas : 孩子所在区域<br>1学习 2休息 3运动 4科学 0无所事事
    -- areaTime : 孩子入区时间（时间戳）
    -- positions : 孩子所在座位(值0、1、2...
    -- rewards : 孩子奖励状态<br>0无奖励 奖励类型<br>1学习 2休息 3运动 4科学 0无所事事
    -- learnTimes : 孩子学习区已学习时间 秒 
    -- status : 孩子状态 -1离开学校 0新入学校 1学校中
    -- names : 孩子名字
    -- scienceTimes : 孩子科学已学习时间 秒
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ChildState",
        "\nids = ",Serialize(VectorToTable(ids)),
        "\nlevels = ",Serialize(VectorToTable(levels)),
        "\nfaceIds = ",Serialize(VectorToTable(faceIds)),
        "\nheadIds = ",Serialize(VectorToTable(headIds)),
        "\nsexs = ",Serialize(VectorToTable(sexs)),
        "\nbodyIds = ",Serialize(VectorToTable(bodyIds)),
        "\nareas = ",Serialize(VectorToTable(areas)),
        "\nareaTime = ",Serialize(VectorToTable(areaTime)),
        "\npositions = ",Serialize(VectorToTable(positions)),
        "\nrewards = ",Serialize(VectorToTable(rewards)),
        "\nlearnTimes = ",Serialize(VectorToTable(learnTimes)),
        "\nstatus = ",Serialize(VectorToTable(status)),
        "\nnames = ",Serialize(VectorToTable(names)),
        "\nscienceTimes = ",Serialize(VectorToTable(scienceTimes))
        )


    if SceneKidSchoolHome.m_root then
        SceneKidSchoolHome:setSchoolChildStateData(VectorToTable(ids), VectorToTable(levels), VectorToTable(faceIds), VectorToTable(headIds), VectorToTable(sexs), VectorToTable(bodyIds), VectorToTable(areas), VectorToTable(areaTime), VectorToTable(positions), VectorToTable(rewards), VectorToTable(learnTimes), VectorToTable(status), VectorToTable(names), VectorToTable(scienceTimes))
    end

end

--@brief    获取学校信息（SCHOOL_GetSchoolInfoOk = 8）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolInfoOk(result, schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, declaration)
    -- result : 1正常 2没有这个学校
    -- schoolId : 学校id
    -- schoolName : 学校名字
    -- masterId : 校长
    -- level : 等级
    -- effectId : 学校加成等级Id<br>对应学习表tab_study里面的id
    -- schoolExp : 学校经验
    -- num : 学校人数
    -- needPassword : 是否需要密码
    -- masterName : 校长名字
    -- maxExp : 当前等级最大经验值
    -- declaration : 学校宣言 166+
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolInfoOk", 
        "\nresult = ",Serialize(VectorToTable(result)), 
        "\nschoolId = ",Serialize(VectorToTable(schoolId)), 
        "\nschoolName = ",Serialize(VectorToTable(schoolName)), 
        "\nmasterId = ",Serialize(VectorToTable(masterId)), 
        "\nlevel = ",Serialize(VectorToTable(level)), 
        "\neffectId = ",Serialize(VectorToTable(effectId)), 
        "\nschoolExp = ",Serialize(VectorToTable(schoolExp)), 
        "\nnum = ",Serialize(VectorToTable(num)), 
        "\nneedPassword = ",Serialize(VectorToTable(needPassword)), 
        "\nmasterName = ",Serialize(VectorToTable(masterName)),
        "\nmaxExp = ",Serialize(VectorToTable(maxExp)),
        "\ndeclaration =",Serialize(VectorToTable(declaration))
        )

    if result == 1 then
        WndKidSchoolInfo:showInterface(schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, declaration)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT154)
    end
end


--@brief    申请入学（SCHOOL_ApplySchoolOk = 10）
function ProtocolProcessorKidSchool:parse_SCHOOL_ApplySchoolOk(result)
    -- result : 结果 1成功 2已经进了其他学校 3学校已经解散了 4密码错误 5离婚中不能操作 6没有孩子不能参加 7请等待婚礼举办后再操作
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ApplySchoolOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT218)
        -- ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(0)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT155)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT156)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.PASSWORD_ERROR)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT157)
    elseif result == 6 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT158)
    elseif result == 7 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT210)
    end
end

--@brief    审批入学学生（SCHOOL_ApproveOk = 12）
function ProtocolProcessorKidSchool:parse_SCHOOL_ApproveOk(result)
    -- result : 结果 1成功 2没有操作权限 3超出人数
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ApproveOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT219)
        ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren()
        ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList()
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT179)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT181)
    end
end

--@brief    解散学校（SCHOOL_DismissSchoolOk = 14）
function ProtocolProcessorKidSchool:parse_SCHOOL_DismissSchoolOk(result, schoolId)
    -- result : 结果 1成功 2失败
    -- schoolId : 解散的学校id
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_DismissSchoolOk", result, schoolId)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT220)
        if SceneKidSchoolHome.m_root then
            SceneKidHome:showInterface()
        end
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT232)
    end
end

--@brief    更换校长（SCHOOL_ChangeSchoolMasterOk = 16）
function ProtocolProcessorKidSchool:parse_SCHOOL_ChangeSchoolMasterOk(result)
    -- result : 结果 1成功 2失败
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ChangeSchoolMasterOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT230)
        SceneKidSchoolHome:requestSchoolData()
        ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
        ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren()
        ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList()
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT233)
    end

    if WndKidSchoolTransfer.m_root then
        WndKidSchoolTransfer:onClickClose()
    end
end

--@brief    捐献（SCHOOL_DonateSchoolOk = 18）
function ProtocolProcessorKidSchool:parse_SCHOOL_DonateSchoolOk(result)
    -- result : 结果 1成功 2没有加入任何学校 3异常失败 4今日捐献过了
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_DonateSchoolOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT221)
        ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
        ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren() --刷新捐献状态
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT173)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT234)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT174)
    end
end

--@brief    编辑学校（SCHOOL_EditSchoolOk = 20）
function ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolOk(result)
    -- result : 结果 1成功 2失败  5名字不合规 6长度不合规 7存在同名学校了
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT222)
        ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
    elseif result == 2 or result == 3 or result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT235)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT162)
    elseif result == 6 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT163)
    elseif result == 7 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT164)
    end
end

--@brief    领取孩子奖励（SCHOOL_ReceiveRewardOk = 24）
function ProtocolProcessorKidSchool:parse_SCHOOL_ReceiveRewardOk(rType, rId, rNum)
    -- rType : 奖励类型 1学识|2体力|3鉴赏|4技能
    -- rId : 奖励id 技能类型用的 技能id|其他情况为0
    -- rNum : 奖励数量
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ReceiveRewardOk", 
        "\nrType = ",Serialize(VectorToTable(rType)), 
        "\nrId = ",Serialize(VectorToTable(rId)), 
        "\nrNum = ",Serialize(VectorToTable(rNum)))

    local tType = VectorToTable(rType)
    if tType == nil or #tType == 0 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT236)
    else
        if SceneKidSchoolHome.m_root then
            SceneKidSchoolHome:receiveRewardOk(VectorToTable(rType), VectorToTable(rId), VectorToTable(rNum))
        end
    end
end

--@brief    获取审批列表（SCHOOL_GetApplyListOk = 26）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetApplyListOk(ids, spitCount, applyIds, sexs, headIds, headColors, faceIds, names, childIds, cnames, cfaceIds, cheadIds, csexs, cbodyIds, headEffectId)
    -- ids : 审批id
    -- spitCount : 玩家分割，夫妻spitCount=2，其余为1
    -- applyIds : 玩家id
    -- sexs : 玩家性别
    -- headIds : 玩家头id
    -- headColors : 玩家头颜色
    -- faceIds : 玩家脸id
    -- names : 玩家名字
    -- childIds : 孩子id
    -- cnames : 孩子名字
    -- cfaceIds : 孩子脸id
    -- cheadIds : 孩子头id
    -- csexs : 孩子性别
    -- cbodyIds : 孩子身体id
    -- headEffectId : 孩子头像框id
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetApplyListOk",
        "\nids = ",Serialize(VectorToTable(ids)),
        "\nspitCount = ",Serialize(VectorToTable(spitCount)),
        "\napplyIds = ",Serialize(VectorToTable(applyIds)),
        "\nsexs = ",Serialize(VectorToTable(sexs)),
        "\nheadIds = ",Serialize(VectorToTable(headIds)),
        "\nheadColors = ",Serialize(VectorToTable(headColors)),
        "\nfaceIds = ",Serialize(VectorToTable(faceIds)),
        "\nnames = ",Serialize(VectorToTable(names)),
        "\nchildIds = ",Serialize(VectorToTable(childIds)),
        "\ncnames = ",Serialize(VectorToTable(cnames)),
        "\ncfaceIds = ",Serialize(VectorToTable(cfaceIds)),
        "\ncheadIds = ",Serialize(VectorToTable(cheadIds)),
        "\ncsexs = ",Serialize(VectorToTable(csexs)),
        "\ncbodyIds = ",Serialize(VectorToTable(cbodyIds))
    )

    if WndKidSchoolApprove.m_root then
        WndKidSchoolApprove:setApplyList(VectorToTable(ids), VectorToTable(spitCount), VectorToTable(applyIds), VectorToTable(sexs), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(faceIds), VectorToTable(names), VectorToTable(childIds), VectorToTable(cnames), VectorToTable(cfaceIds), VectorToTable(cheadIds), VectorToTable(csexs), VectorToTable(cbodyIds), VectorToTable(headEffectId))
    end
end

--@brief    进入区域结果（SCHOOL_JoinAreaOk = 28）
function ProtocolProcessorKidSchool:parse_SCHOOL_JoinAreaOk(result)
    -- result : 结果 1成功 2先领取奖励 3学校已经解散了 4超过学习时间了 5技能已满不能进入科学区了 6超出区域人数了
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_JoinAreaOk", result)

    if WndKidSchoolOperate.m_root then
        WndKidSchoolOperate:joinAreaOk(result)
    end

end

--@brief    切换孩子上学（SCHOOL_ChangeChildOk = 30）
function ProtocolProcessorKidSchool:parse_SCHOOL_ChangeChildOk(result)
    -- result : 切换结果 <br>1成功 2被踢出学校了 3学校已经解散了 4孩子只有1个 5请先领取奖励
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ChangeChildOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT225)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT202)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT156)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT203)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT166)
    end
end

--@brief    获取家长列表（SCHOOL_GetParentListOk = 38）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetParentListOk(ids, names, levels, sexs, headIds, headColors, faceIds)
    -- ids : 家长id列表
    -- names : 名字
    -- levels : 等级
    -- sexs : 性别
    -- headIds : 头id
    -- headColors : 头颜色
    -- faceIds : 脸
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetParentListOk", ids, names, levels, sexs, headIds, headColors, faceIds)
end

--@brief    退学（SCHOOL_QuitSchoolOk = 40）
function ProtocolProcessorKidSchool:parse_SCHOOL_QuitSchoolOk(result)
    -- result : 结果 1成功 2失败 3你或者伴侣是校长不能退学 4请先领取奖励
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_QuitSchoolOk", result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT226)
        if SceneKidSchoolHome.m_root then
            SceneKidHome:showInterface()
        end
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT245)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT246)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT166)
    end
end

--@brief    获取我的学校信息（SCHOOL_GetMySchoolInfoOk = 47）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetMySchoolInfoOk(result, schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, hasDonate, donateTime, hasHide, inSchoolNum, declaration)
    -- result : 1正常 2没有这个学校
    -- schoolId : 学校id
    -- schoolName : 学校名字
    -- masterId : 校长
    -- level : 等级
    -- effectId : 学校加成等级Id<br>对应学习表tab_study里面的id
    -- schoolExp : 学校经验
    -- num : 学校人数
    -- needPassword : 是否需要密码
    -- masterName : 校长名字
    -- maxExp : 当前等级最大经验值
    -- hasDonate : 是否捐献了
    -- donateTime : 捐献剩余持续时间(秒)
    -- hasHide : true隐藏 false显示
    -- inSchoolNum : 学校当前人数
    -- declaration : 学校宣言 166+
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetMySchoolInfoOk",
        "\nresult = ",Serialize(VectorToTable(result)),
        "\nschoolId = ",Serialize(VectorToTable(schoolId)),
        "\nschoolName = ",Serialize(VectorToTable(schoolName)),
        "\nmasterId = ",Serialize(VectorToTable(masterId)),
        "\nlevel = ",Serialize(VectorToTable(level)),
        "\neffectId = ",Serialize(VectorToTable(effectId)),
        "\nschoolExp = ",Serialize(VectorToTable(schoolExp)),
        "\nnum = ",Serialize(VectorToTable(num)),
        "\nneedPassword = ",Serialize(VectorToTable(needPassword)),
        "\nmasterName = ",Serialize(VectorToTable(masterName)),
        "\nmaxExp = ",Serialize(VectorToTable(maxExp)),
        "\nhasDonate = ",Serialize(VectorToTable(hasDonate)),
        "\ndonateTime = ",Serialize(VectorToTable(donateTime)),
        "\nhasHide = ",Serialize(VectorToTable(hasHide)),
        "\ninSchoolNum = ",Serialize(VectorToTable(inSchoolNum)),
        "\ndeclaration = ",Serialize(VectorToTable(declaration))
    )


    if WndKidSchoolList.m_root then     

        if result == 2 then
            MsgBoxManager:showTipBox(LocalStrings.KID_TEXT154)
            return
        end
        WndKidSchoolList:setMySchoolInfo(schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, hasDonate, donateTime, hasHide, inSchoolNum, declaration)
    end
end

--@brief    获取本校孩子列表（SCHOOL_GetSchoolChildrenOk = 49）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolChildrenOk(ids, childIds, cnames, cfaceIds, cheadIds, csexs, cbodyIds, status, loginTime, donateTimes, spitCount, pids, sexs, headIds, headColors, faceIds, names, headEffectId)
    -- ids : id
    -- childIds : 孩子id
    -- cnames : 孩子名字
    -- cfaceIds : 孩子脸id
    -- cheadIds : 孩子头id
    -- csexs : 孩子性别
    -- cbodyIds : 孩子身体id
    -- status : 在线状态 1在线 0不在线
    -- loginTime : 上次登录时间
    -- donateTimes : 捐赠次数
    -- spitCount : 父母分割，夫妻spitCount=2，其余为1
    -- pids : 父母id
    -- sexs : 父母性别
    -- headIds : 父母头id
    -- headColors : 父母头颜色
    -- faceIds : 父母脸id
    -- names : 父母名字
    -- headEffectId : 孩子头像框Id
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolChildrenOk",
        "\nids = ",Serialize(VectorToTable(ids)),
        "\nchildIds = ",Serialize(VectorToTable(childIds)),
        "\ncnames = ",Serialize(VectorToTable(cnames)),
        "\ncfaceIds = ",Serialize(VectorToTable(cfaceIds)),
        "\ncheadIds = ",Serialize(VectorToTable(cheadIds)),
        "\ncsexs = ",Serialize(VectorToTable(csexs)),
        "\ncbodyIds = ",Serialize(VectorToTable(cbodyIds)),
        "\nstatus = ",Serialize(VectorToTable(status)),
        "\nloginTime = ",Serialize(VectorToTable(loginTime)),
        "\ndonateTimes = ",Serialize(VectorToTable(donateTimes)),
        "\nspitCount = ",Serialize(VectorToTable(spitCount)),
        "\npids = ",Serialize(VectorToTable(pids)),
        "\nsexs = ",Serialize(VectorToTable(sexs)),
        "\nheadIds = ",Serialize(VectorToTable(headIds)),
        "\nheadColors = ",Serialize(VectorToTable(headColors)),
        "\nfaceIds = ",Serialize(VectorToTable(faceIds)),
        "\nnames = ",Serialize(VectorToTable(names))
        )

    
    if WndKidSchoolList.m_root then
        WndKidSchoolList:setSchoolChildren(VectorToTable(ids), VectorToTable(childIds), VectorToTable(cnames), VectorToTable(cfaceIds), VectorToTable(cheadIds), VectorToTable(csexs), VectorToTable(cbodyIds), VectorToTable(status),
            VectorToTable(loginTime), VectorToTable(donateTimes), VectorToTable(spitCount), VectorToTable(pids), VectorToTable(sexs), VectorToTable(headIds), VectorToTable(headColors), VectorToTable(faceIds), VectorToTable(names), VectorToTable(headEffectId))
    end

end

--@brief    隐藏学校(列表中不显示)（SCHOOL_HideSchoolOk = 51）
function ProtocolProcessorKidSchool:parse_SCHOOL_HideSchoolOk(result)
    -- result : 结果 1成功 2失败|没有操作权限
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_HideSchoolOk",result)

    if WndKidSchoolList.m_root then
        WndKidSchoolList:hideSchoolOk(result)
    end
end

--@brief    清退孩子（SCHOOL_ClearChildOk = 44）
function ProtocolProcessorKidSchool:parse_SCHOOL_ClearChildOk(result)
    -- result : 结果 1成功 2没有权限操作 3操作失败 4超过今日最大操作次数
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ClearChildOk",result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT227)
        ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren()
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT179)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT237)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT244)
    end
end

--@brief    获取孩子信息（SCHOOL_GetChildInfoOk = 53）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetChildInfoOk(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, learnRemainTime, scienceRemainTime, hp, maxHp, attack, maxAttack, def, maxDef)
    -- learnLevel : 智慧等级
    -- learnExp : 智慧经验当前值
    -- learnMaxExp : 智慧经验最大值
    -- restLevel : 精神等级
    -- restExp : 精神经验当前值
    -- restMaxExp : 精神经验最大值
    -- appreciateLevel : 体能等级
    -- appreciateExp : 体能经验当前值
    -- appreciateMaxExp : 体能经验最大值
    -- learnRemainTime : 学习区剩余时间
    -- scienceRemainTime : 科学区剩余时间
    -- hp : 生命
    -- maxHp : 最大生命
    -- attack : 攻击
    -- maxAttack : 最大攻击
    -- def : 防御
    -- maxDef : 最大防御
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetChildInfoOk",
        "\nlearnLevel = ",Serialize(VectorToTable(learnLevel)),
        "\nlearnExp = ",Serialize(VectorToTable(learnExp)),
        "\nlearnMaxExp = ",Serialize(VectorToTable(learnMaxExp)),
        "\nrestLevel = ",Serialize(VectorToTable(restLevel)),
        "\nrestExp = ",Serialize(VectorToTable(restExp)),
        "\nrestMaxExp = ",Serialize(VectorToTable(restMaxExp)),
        "\nappreciateLevel = ",Serialize(VectorToTable(appreciateLevel)),
        "\nappreciateExp = ",Serialize(VectorToTable(appreciateExp)),
        "\nappreciateMaxExp = ",Serialize(VectorToTable(appreciateMaxExp)),
        "\nlearnRemainTime = ",Serialize(VectorToTable(learnRemainTime)),
        "\nscienceRemainTime = ",Serialize(VectorToTable(scienceRemainTime)), 
        "\nhp = ",Serialize(VectorToTable(hp)),
        "\nmaxHp = ",Serialize(VectorToTable(maxHp)),
        "\nattack = ",Serialize(VectorToTable(attack)),
        "\nmaxAttack = ",Serialize(VectorToTable(maxAttack)),
        "\ndef = ",Serialize(VectorToTable(def)),
        "\nmaxDef = ",Serialize(VectorToTable(maxDef))
    )

    if WndKidSchoolKidInfo.m_root then
        WndKidSchoolKidInfo:setChildInfo(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, learnRemainTime, scienceRemainTime, hp, maxHp, attack, maxAttack, def, maxDef)
    end
end

--@brief    获取孩子技能信息（SCHOOL_GetChildSkillInfoOk = 55）
function ProtocolProcessorKidSchool:parse_SCHOOL_GetChildSkillInfoOk(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, useSkill, unlockSkill, unlockSkillNum)
    -- learnLevel : 智慧等级
    -- learnExp : 智慧经验当前值
    -- learnMaxExp : 智慧经验最大值
    -- restLevel : 精神等级
    -- restExp : 精神经验当前值
    -- restMaxExp : 精神经验最大值
    -- appreciateLevel : 体能等级
    -- appreciateExp : 体能经验当前值
    -- appreciateMaxExp : 体能经验最大值
    -- useSkill : 装备中的技能id
    -- unlockSkill : 解锁后的技能id
    -- unlockSkillNum : 解锁后的技能可使用的数量
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetChildSkillInfoOk",
        "\nlearnLevel = ",Serialize(VectorToTable(learnLevel)),
        "\nlearnExp = ",Serialize(VectorToTable(learnExp)),
        "\nlearnMaxExp = ",Serialize(VectorToTable(learnMaxExp)),
        "\nrestLevel = ",Serialize(VectorToTable(restLevel)),
        "\nrestExp = ",Serialize(VectorToTable(restExp)),
        "\nrestMaxExp = ",Serialize(VectorToTable(restMaxExp)),
        "\nappreciateLevel = ",Serialize(VectorToTable(appreciateLevel)),
        "\nappreciateExp = ",Serialize(VectorToTable(appreciateExp)),
        "\nappreciateMaxExp = ",Serialize(VectorToTable(appreciateMaxExp)),
        "\nuseSkill = ",Serialize(VectorToTable(useSkill)),
        "\nunlockSkill = ",Serialize(VectorToTable(unlockSkill)),
        "\nunlockSkillNum = ",Serialize(VectorToTable(unlockSkillNum))
    )

    if WndKidSchoolSkill.m_root then
        WndKidSchoolSkill:setChildSkillInfo(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, VectorToTable(useSkill), VectorToTable(unlockSkill), VectorToTable(unlockSkillNum))
    end
end

--@brief    编辑学校宣言166+（SCHOOL_EditSchoolDeclarationOk = 61）
function ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolDeclarationOk(result)
    -- result : 结果 1成功 2失败  3太长了暂定30个字符?
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolDeclarationOk",result)
    WndKidSchoolList:getSchoolDeclarationResult(result)
end


-------------------------------------协议错误处理方法模块--------------------------------------

--@brief    获取学校列表（SCHOOL_GetSchoolList = 1）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolList, nflag, sMessage)
end

--@brief    创建学校（SCHOOL_CreateSchool = 3）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_CreateSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_CreateSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_CreateSchool, nflag, sMessage)
end

--@brief    进入学校（SCHOOL_EntrySchool = 5）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EntrySchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EntrySchool, nflag, sMessage)
end


--@brief    离开学校（SCHOOL_LeaveSchool = 6）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_LeaveSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_LeaveSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_LeaveSchool, nflag, sMessage)
end

--@brief    获取学校信息（SCHOOL_GetSchoolInfo = 7）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolInfo, nflag, sMessage)
end

--@brief    申请入学（SCHOOL_ApplySchool = 9）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ApplySchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ApplySchool, nflag, sMessage)
end

--@brief    审批入学学生（SCHOOL_Approve = 11）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_Approve_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_Approve_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_Approve, nflag, sMessage)
end

--@brief    解散学校（SCHOOL_DismissSchool = 13）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_DismissSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_DismissSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DismissSchool, nflag, sMessage)
end

--@brief    转让学校（SCHOOL_ChangeSchoolMaster = 15）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_ChangeSchoolMaster_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ChangeSchoolMaster_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeSchoolMaster, nflag, sMessage)
end

--@brief    捐献（SCHOOL_DonateSchool = 17）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_DonateSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_DonateSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_DonateSchool, nflag, sMessage)
end

--@brief    编辑学校（SCHOOL_EditSchool = 19）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_EditSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EditSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchool, nflag, sMessage)
end

--@brief    领取孩子奖励（SCHOOL_ReceiveReward = 23）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_ReceiveReward_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ReceiveReward_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ReceiveReward, nflag, sMessage)
end

--@brief    获取审批列表(校长用的)（SCHOOL_GetApplyList = 25）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetApplyList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetApplyList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetApplyList, nflag, sMessage)
end

--@brief    加入区域（SCHOOL_JoinArea = 27）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_JoinArea_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_JoinArea_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_JoinArea, nflag, sMessage)
end

--@brief    切换孩子上学（SCHOOL_ChangeChild = 29）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_ChangeChild_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ChangeChild_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ChangeChild, nflag, sMessage)
end

--@brief    进入后学校后每5秒发一次心跳（SCHOOL_HeartbeatSchool = 32）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_HeartbeatSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_HeartbeatSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HeartbeatSchool, nflag, sMessage)
end

--@brief    获取家长列表（SCHOOL_GetParentList = 37）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetParentList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetParentList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetParentList, nflag, sMessage)
end

--@brief    退学（SCHOOL_QuitSchool = 39）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_QuitSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_QuitSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_QuitSchool, nflag, sMessage)
end

--@brief    获取自己学校和学生的状态（SCHOOL_GetState = 45）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetState_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetState_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetState, nflag, sMessage)
end

--@brief    获取我的学校信息【p】（SCHOOL_GetMySchoolInfo = 46）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetMySchoolInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetMySchoolInfo, nflag, sMessage)
end

--@brief    获取本校孩子列表（SCHOOL_GetSchoolChildren = 48）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetSchoolChildren_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetSchoolChildren, nflag, sMessage)
end

--@brief    隐藏学校(列表中不显示)（SCHOOL_HideSchool = 50）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_HideSchool_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_HideSchool_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_HideSchool, nflag, sMessage)
end

--@brief    清退孩子(校长操作孩子退学)（SCHOOL_ClearChild = 43）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_ClearChild_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_ClearChild_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_ClearChild, nflag, sMessage)
end

--@brief    获取孩子信息（SCHOOL_GetChildInfo = 52）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetChildInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetChildInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildInfo, nflag, sMessage)
end

--@brief    获取上学中的孩子技能信息（SCHOOL_GetChildSkillInfo = 54）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_GetChildSkillInfo_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_GetChildSkillInfo_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_GetChildSkillInfo, nflag, sMessage)
end

--@brief    编辑学校宣言166+（SCHOOL_EditSchoolDeclaration = 60）错误处理函数(S->C)
--@param    nFlag:标志位
--@param    sMessage:错误信息
--@note 在此对协议错误进行相应处理
function ProtocolProcessorKidSchool:send_SCHOOL_EditSchoolDeclaration_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorKidSchool:parse_SCHOOL_EditSchoolDeclaration_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_SCHOOL, Protocol.SCHOOL_EditSchoolDeclaration, nflag, sMessage)
end

-------------------------------------公有方法模块End----------------------------------------


