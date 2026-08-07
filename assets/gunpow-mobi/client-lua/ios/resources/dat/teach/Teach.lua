--Teach.lua
--@brief	Teach的模块
--@date		2011/2/19
--@author	liangguang_long
--@note		教学

Teach =
{
	SCHEDULETIME = 5,					--定时器时间
    

	TEACH_ENFORCE = -1,					--强制教学-1
	TEACH_STRENG = 200 ,				--开始强化教学200
	TEACH_PET = 201 , 					--进入宠物按钮201
	TEACH_BOSSMAP = 202,				--进入副本按钮202
	TEACH_STRINGSTART = false,			--是否进入过强化研究院
	TEACH_PETENTER = false,				--是否进入过宠物
	TEACH_BOSSMAPENTER = false,			--是否进入过副本
	TEACH_DIALOG = nil ,

	CONFLARE = nil ,
	TEACHDATA = nil,
	STRINGIDS = nil,
	PETIDS = nil,
	BOSSMAPIDS = nil,

	INTERFACE = nil ,
	STEP = nil,
	TEACHOVER = false,
    
    --2.2教学
    TEACH_DIALOGS = nil,                --保存教学对话框
    TEACH_SHINES = nil,                 --保存教学闪光
    TEACH_FINGERS = nil,                --保存教学手指动画

    TASK_TAG = 0,                       --任务按钮的Tag
    MORE_TAG = 0,                       --更多按钮的Tag
    MIXTURE_TAG = 0,                    --合成按钮的Tag
    MIXTURE_RIGHT_TAG = 0,              --合成按钮(右边栏)的Tag
    MORE_COUNT = 0,                     --更多窗口的数量
    PET_TAG = 0,                        --宠物的Tag
    OPEN_MODULE_MARK = nil,             --开启模块时的标志
    CREATE_ROOM_MARK = nil,             --创建房间标志
    REWARD_MARK = nil,                  --奖励标志
    LOGIN_REWARD_MARK = nil,            --奖励标志

    m_isWndTeachTalkExist = nil,        --剧情对话
    m_isWndTeachOpenModuleExist = nil,  --开启模块框

    IDS = 1 ,

    TYPE_LEVEL = 1,                     --开放类型_等级
    TYPE_TASK_GET = 2,                  --开放类型_获得任务
    TYPE_TASK_SUBMIT_CAN = 3,           --开放类型_可以提交任务
    TYPE_TASK_SUBMIT_END = 4,           --开放类型_提交了任务
    TYPE_PRE_TEACH_END = 5,             --开放类型_结束了其他教学

    OPEN_MODULE_FINISH_STEP = -1,       --开启模块框结束步骤

    PreUIChannelId = -1,                --前一个UI渠道Id

    TASK_ID_WELCOME = 10001000,         --来到弹弹岛
    TASK_ID_SINGLE = 10001001,          --单人副本
    TASK_ID_WEAPON = 10002002,          --装备武器
    TASK_ID_INTENSIFY = 10005006,       --强化
    TASK_ID_HALL = 10006008,            --大厅
    TASK_ID_REWARD = 10006011,          --奖励
    TASK_ID_COMPOUND = 10007010,        --合成
    TASK_ID_UPSTAR = 10009018,          --升星
    TASK_ID_INLAY = 10020037,           --镶嵌
}

--教学步骤组表
TeachIDToTable = [[TeachIDToTable = {
    [1] = "TeachStepGroup1",
    [2] = "TeachStepGroup2",
    [3] = "TeachStepGroup3",
    [4] = "TeachStepGroup4",
    [5] = "TeachStepGroup5",
}]]
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	教学数据列表
--@param	ids：教学的编号
--@param	step：教学的步骤
function Teach:getAllData(ids, step)
    --WZLog("Teach:getAllData one")
    do return end

    LoadConfigByString(TeachIDToTable)

    if true then
        Teach.m_isWndTeachTalkExist = nil
        Teach.m_isWndTeachOpenModuleExist = nil
        Teach.PET_TAG = 0
        Teach.OPEN_MODULE_MARK = nil
        Teach.CREATE_ROOM_MARK = nil
        Teach.REWARD_MARK = nil
        Teach.LOGIN_REWARD_MARK = nil
        Teach.TEACH_DIALOGS = {}
        Teach.TEACH_SHINES = {}
        Teach.TEACH_FINGERS = {}

        Teach.DATA = {}
        Teach.DATA.group = {}
        Teach.DATA.saveStep = {}
        Teach.DATA.saveTask = {}

        for id, data in pairs (TeachData) do
            if Teach.DATA.group[data.group_id] == nil then
                Teach.DATA.group[data.group_id] = {}
            end

            table.insert( Teach.DATA.group[data.group_id] , data)
        end

        for groupIndex, groupData in pairs (Teach.DATA.group) do
            Teach:bubbleSort(groupData, "id")
            for stepIndex, step in pairs (groupData) do
                --WZLog("Teach:getAllData two", "group = "..groupIndex, "step = "..stepIndex, "id = "..step.id)
            end
        end

    end

    local saveSteps = {}

    if ids:size() ~= 0 and step:size() ~= 0 then
        for i = 0 , step:size() - 1 do
            --WZLog("Teach:getAllData three", i + 1, ids:get(i), step:get(i))
            if ids:get(i) > 0 and ids:get(i) < 1000 then
                table.insert(saveSteps, {["ids"] = ids:get(i), ["step"] = step:get(i)})
            else
                table.insert(Teach.DATA.saveTask, {["ids"] = ids:get(i), ["step"] = step:get(i)})
            end
        end
        --Teach:bubbleSort(saveSteps, "ids")
        if Teach.DATA ~= nil and Teach.DATA.saveStep ~= nil and #saveSteps > 0 and saveSteps[#saveSteps] ~= nil and saveSteps[#saveSteps].ids ~= nil then
            table.insert(Teach.DATA.saveStep, {["ids"] = saveSteps[#saveSteps].ids, ["step"] = saveSteps[#saveSteps].step})
        end
    elseif CacheCenter:getPlayerInfo().level <= 1 and CacheCenter:getPlayerInfo().zsLevel <= 0 then
        table.insert(Teach.DATA.saveStep, {["ids"] = 1, ["step"] = 0})
    end

    for id, data in pairs (saveSteps) do
        --WZLog("Teach:getAllData four-0", data.ids, data.step)
    end

    for id, data in pairs (Teach.DATA.saveStep) do
        --WZLog("Teach:getAllData four-1", data.ids, data.step)
    end

    if type(TeachIDToTable) ~= "table" then
        return
    end

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        --WZLog("Teach:getAllData five", tostring(teachTable), tostring(teachObj))
        if teachObj ~= nil and teachObj.INDEX ~= nil then
            --WZLog("Teach:getAllData six",finishStep , tostring(teachObj.INDEX))
            teachObj.TOTAL_STEP = nil
        end
    end

    Teach:addTextureCache()
end

--@brief	获取任务状态
--@note		获取任务状态:  -1:没获得该任务,0:获得该任务,1:已完成该任务,2:已提交该任务
--@note     当id为负数,表示为相应的正数的教学组ID所属的任务标识
function Teach:getTaskState(id)
    --WZLog("Teach:getTaskState zero-0",tostring(id))

    if Teach.DATA == nil then
        return -1
    end

    if id == nil then
        id = -1
    end

    local taskState = -1
    for index, task in pairs (Teach.DATA.saveTask) do
        --WZLog("Teach:getTaskState zero-1",tostring(id), task.ids, task.step)
        if id == task.ids and task.step == -2 then
            --WZLog("Teach:getTaskState five", id, 2)
            taskState = 2
            break
        elseif id == task.ids and task.step == -1 then
            --WZLog("Teach:getTaskState six", id, 1)
            if taskState == -1 then
                taskState = 1
            end
        elseif id == task.ids and task.step >= 0 then
            --WZLog("Teach:getTaskState seven", id, 0)
            taskState = task.step
        end
    end

    if taskState ~= -1 then
        return taskState
    end

    if PrefetchCache:hasTaskList() ~= true then
        return -1
    end
    self.m_tTaskList = PrefetchCache:getTaskList()

    --WZLog("Teach:getTaskState one-01", self.m_tTaskList)
    --WZLog("Teach:getTaskState one-02", self.m_tTaskList.tMainTask)
    --WZLog("Teach:getTaskState one-03", #self.m_tTaskList.tMainTask)
    if self.m_tTaskList == nil or self.m_tTaskList.tMainTask == nil or #self.m_tTaskList.tMainTask == 0 then
        --WZLog("Teach:getTaskState one-04", id)
        return -1
    end

    for i=1,#self.m_tTaskList.tMainTask do
        if  self.m_tTaskList.tMainTask[i].nId == id then
            self.m_tTaskList.tMainTask.nId = self.m_tTaskList.tMainTask[i].nId
            self.m_tTaskList.tMainTask.nIndex = i
        end
    end

    if self.m_tTaskList.tMainTask.nId == nil then
        --WZLog("Teach:getTaskState one-05", id)
        return -1
    end

    local tTaskData = self:getTaskData(self.m_tTaskList.tMainTask.nId, 0)
    if tTaskData == nil or id ~= self.m_tTaskList.tMainTask.nId then
        --WZLog("Teach:getTaskState one", id, self.m_tTaskList.tMainTask.nId)
        return -1
    end

    local tasksTatus = 1
    --WZLog("Teach:getTaskState two", self.m_tTaskList.tMainTask.nId)

    for i,v in pairs(self.m_tTaskList.tMainTask[self.m_tTaskList.tMainTask.nIndex].nTargetStatus) do
        if self.m_tTaskList.tMainTask[self.m_tTaskList.tMainTask.nIndex].nTargetValue[i] ~= v then
            --WZLog("Teach:getTaskState three", i, v, self.m_tTaskList.tMainTask[self.m_tTaskList.tMainTask.nIndex].nTargetValue[i])
            tasksTatus = 0
            break
        end
    end

    --WZLog("Teach:getTaskState four", tasksTatus, self.m_tTaskList.tMainTask.nId, id)
    return tasksTatus
end

--@brief 	获取任务数据
--@param 	nTaskID:任务ID
--@param 	nTaskType:任务类型（0:主线任务，2:日常任务）
--@note 	根据任务ID从LocalData.lua中获取任务数据
function Teach:getTaskData(nTaskID, nTaskType)
	local tTaskData = {}
	
    if nTaskID == nil then
        return
    end

	if 0 == nTaskType then
		tTaskData = MainTask["id_"..nTaskID]
	elseif 2 == nTaskType then
		tTaskData = DailyTask["id_"..nTaskID]
	end

	return tTaskData
end

--@brief	缓存纹理
--@note		缓存纹理,减少纹理加载操作
function Teach:addTextureCache()
    --WZLog("Teach:addTextureCache", tostring(self.m_tTextureCache))
    if self.m_tTextureCache ~= nil then
        return
    end

    self.m_tTextureCache = {}
    local textureCacheElement = nil
    local path = nil

    local sprites = {}
    path = "common/teach/"
    local sprites = {}
    table.insert(sprites, path.."teach_01_1.png")
    table.insert(sprites, path.."teach_01.png")
    table.insert(sprites, path.."teach_08.png")
    table.insert(sprites, path.."teach_07.png")

    table.insert(sprites, "common/animation/icon_world_boss_light.png")
    --table.insert(sprites, "ui/island/island_01.png")
    --table.insert(sprites, "ui/island/island_02.png")

    for i,path in pairs(sprites) do
        Teach:createTextureCache(path)
    end

end

--@brief	缓存纹理
--@note		缓存纹理,减少纹理加载操作
function Teach:createTextureCache(path)
    local textureCacheElement = CCSprite:create(path)
    if textureCacheElement ~= nil then
        textureCacheElement:retain()
        table.insert(self.m_tTextureCache, textureCacheElement)
    end
end

--@brief	任务开启教学
function Teach:openTeachByTask(taskId, taskType, status,targetStatus)
    --WZLog("Teach:openTeachByTask one", taskId, taskType, status,targetStatus, type(TeachStepGroup5.INDEX), TeachStepGroup5.INDEX[6])
    if Teach.DATA == nil then
        return -1
    end

    for index, task in pairs (Teach.DATA.saveTask) do
        --WZLog("Teach:openTeachByTask one-1",tostring(taskId), task.ids, task.step)
        if taskId == task.ids and task.step == -4 then
            return
        end
    end

    local isOpen = false
    local teachId = 0
    if taskId == Teach.TASK_ID_INTENSIFY and status == 1 and type(TeachStepGroup5.INDEX) == "table" and (TeachStepGroup5.INDEX[6] == nil or TeachStepGroup5.INDEX[6] == -2) then
        --WZLog("Teach:openTeachByTask two1")
        TeachStepGroup5.INDEX[6] = 0
        isOpen = true
        teachId = 6
    elseif taskId == Teach.TASK_ID_UPSTAR and status == 1 and type(TeachStepGroup2.INDEX) == "table" and (TeachStepGroup2.INDEX[7] == nil or TeachStepGroup2.INDEX[7] == -2) then
        --WZLog("Teach:openTeachByTask two2")
        TeachStepGroup2.INDEX[7] = 0
        isOpen = true
        teachId = 7
    elseif taskId == Teach.TASK_ID_INLAY and status == 1 and type(TeachStepGroup2.INDEX) == "table" and (TeachStepGroup2.INDEX[12] == nil or TeachStepGroup2.INDEX[12] == -2) then
        --WZLog("Teach:openTeachByTask two3")
        TeachStepGroup2.INDEX[12] = 0
        isOpen = true
        teachId = 12
    elseif taskId == Teach.TASK_ID_REWARD and status == 1 and type(TeachStepGroup3.INDEX) == "table" and (TeachStepGroup3.INDEX[20] == nil or TeachStepGroup3.INDEX[20] == -2) then
        --WZLog("Teach:openTeachByTask two4")
        TeachStepGroup3.INDEX[20] = 0
        isOpen = true
        teachId = 20
    elseif taskId == Teach.TASK_ID_WEAPON and status == 1 and Teach.DATA ~= nil and type(TeachStepGroup1.INDEX) == "table" and (TeachStepGroup1.INDEX[2] == nil or TeachStepGroup1.INDEX[2] == -2) then
        --WZLog("Teach:openTeachByTask two4")
        TeachStepGroup1.INDEX[2] = 0
        isOpen = true
        teachId = 2
    elseif taskId == Teach.TASK_ID_HALL and status == 1 and type(TeachStepGroup3.INDEX) == "table" and (TeachStepGroup3.INDEX[9] == nil or TeachStepGroup3.INDEX[9] == -2) then
        --WZLog("Teach:openTeachByTask two4")
        TeachStepGroup3.INDEX[9] = 0
        isOpen = true
        teachId = 9
    elseif taskId == Teach.TASK_ID_COMPOUND and status == 1 and type(TeachStepGroup3.INDEX) == "table" and (TeachStepGroup3.INDEX[22] == nil or TeachStepGroup3.INDEX[22] == -2) then
        --WZLog("Teach:openTeachByTask two4")
        TeachStepGroup3.INDEX[22] = 0
        isOpen = true
        teachId = 22
    end

    --WZLog("Teach:openTeachByTask three",tostring(isOpen), type(TeachIDToTable))
    if isOpen == false or type(TeachIDToTable) ~= "table" then
        return
    end
    ProtocolProcessorTeach:send_TASK_TiroStep(teachId, 0)

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        if teachObj ~= nil and type(teachObj.INDEX) ~= "table" then
            teachObj:_initTeachStep()
        end
    end

    table.insert(Teach.DATA.saveTask, {["ids"] = taskId, ["step"] = -4})
    ProtocolProcessorTeach:send_TASK_TiroStep(taskId, -4)

    if WndTeachOpenModule.m_root ~= nil then
        WndTeachOpenModule:removeWindow()
    end
    Teach:isStartTeach("Teach:openTeachByTask", taskId, taskType, status,targetStatus)
end

--@brief    开启教学
--@param    level：等级
function Teach:OpenTeachStep(openType, param)
    --WZLog("Teach:OpenTeachStep zero0", openType, param, tostring(CacheCenter:getPlayerInfo().zsLevel), tostring(Teach.DATA))

    if Teach.DATA == nil then
        Teach:isStartTeach("Teach:OpenTeachStep : 1")
        return 
    end

    if CacheCenter:getPlayerInfo().zsLevel ~= 0 then
        Teach:isStartTeach("Teach:OpenTeachStep : 2")
        return
    end

    if self.STEP_GROUP_IDS == nil then
        self.STEP_GROUP_IDS = {[1]=1,[2]=2,[3]=3,[4]=4,[5]=5,[6]=6,[7]=9,[8]=11,[12]=15,[13]=16,[9]=12,[10]=13,[11]=14,[20]=7,[21]=8,[22]=10,[14]=17,[15]=18,[16]=19,[17]=20,[18]=21,[19]=22}
    end

    local isOpen = false
    local isSingleMapOpen = false
    if openType == Teach.TYPE_LEVEL then
        for groupIndex, groupData in pairs (Teach.DATA.group) do
            for stepIndex, step in pairs (groupData) do
                if openType == step.pre_conditions and param == step.pre_param then
                    Teach.IDS = step.group_id
                    for i, v in pairs (self.STEP_GROUP_IDS) do
                        --WZLog("Teach:OpenTeachStep zero2", step.group_id, i ,v)
                        if step.group_id == v then
                            Teach.IDS = i
                            break
                        end
                    end
                    isOpen = true
                    --WZLog("Teach:OpenTeachStep zero1", "id = "..step.id, "desc = "..step.desc, "group_id = "..step.group_id )
                end
            end
        end

        if SceneIsland.m_root ~= nil then
            local btn = GetElement(SceneIsland.m_root, "btnBossMap_SceneIsland")
            if btn ~= nil and btn:getTouchEnable() == true then
                isSingleMapOpen = true
            end
        end

    elseif openType == Teach.TYPE_TASK_GET then

    elseif openType == Teach.TYPE_TASK_SUBMIT_CAN then

    elseif openType == Teach.TYPE_TASK_SUBMIT_END then

    elseif openType == Teach.TYPE_PRE_TEACH_END then

    end

    if isOpen == false or type(TeachIDToTable) ~= "table" then
        Teach:isStartTeach("Teach:OpenTeachStep : 3")
        return
    end

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        if teachObj ~= nil and type(teachObj.INDEX) ~= "table" then
            teachObj:_initTeachStep()
        end
    end

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        --WZLog("Teach:OpenTeachStep one", tostring(teachTable), tostring(teachObj), Teach.IDS)
        if teachObj ~= nil and teachObj.INDEX ~= nil then
            --WZLog("Teach:OpenTeachStep two", Teach.IDS)
            for i, v in pairs (teachObj.STEP_GROUP_IDS) do
                if i == Teach.IDS then
                    teachObj.INDEX[i] = 0
                    ProtocolProcessorTeach:send_TASK_TiroStep(i, 0)
                    --WZLog("Teach:OpenTeachStep three", id, v, Teach.IDS, isSingleMapOpen, tostring(SceneIsland.m_root))
                elseif i ~= Teach.IDS then
                    teachObj.INDEX[i] = -2
                    --ProtocolProcessorTeach:send_TASK_TiroStep(v, -2)
                    --WZLog("Teach:OpenTeachStep four", id, v, Teach.IDS)
                end
            end
        end
    end

    if WndTeachOpenModule.m_root ~= nil then
        WndTeachOpenModule:removeWindow()
    end
    Teach:isStartTeach("Teach:OpenTeachStep : "..openType.." - "..param, Teach.TYPE_LEVEL)
end

--@brief	判断是否开始新手教学
function Teach:isStartTeach(note, param)
    --WZLog("Teach:isStartTeach", tostring(note))

    if Teach.DATA == nil or Teach.DATA.saveStep == nil then
        return
    end
    Teach:removeTeachElement(note)

    if Teach.OPEN_MODULE_MARK == nil then
        Teach:beganNextStep(param)
    end
end

--@brief 结束步骤组
function Teach:finishStep(step1, step2, step3, step4, step5, step6, step7, step8, step9, step10, step11, step12, step13, step14, step15, step16, step17, step18, step19, step20,isStartTeach)
    --WZLog("Teach:finishStep", tostring(step1), tostring(step2), tostring(step3), tostring(step4), tostring(step5), tostring(step6), tostring(step7), tostring(step8), tostring(step9), tostring(step10), tostring(step11), tostring(step12), tostring(step13), tostring(step14), tostring(step15), tostring(step16), tostring(step17), tostring(step18), tostring(step19), tostring(step20))

    if Teach.DATA == nil then
        return
    end

    local finishStep = {}
    table.insert(finishStep, step1)
    table.insert(finishStep, step2)
    table.insert(finishStep, step3)
    table.insert(finishStep, step4)
    table.insert(finishStep, step5)
    table.insert(finishStep, step6)
    table.insert(finishStep, step7)
    table.insert(finishStep, step8)
    table.insert(finishStep, step9)
    table.insert(finishStep, step10)
    
    table.insert(finishStep, step11)
    table.insert(finishStep, step12)
    table.insert(finishStep, step13)
    table.insert(finishStep, step14)
    table.insert(finishStep, step15)
    table.insert(finishStep, step16)
    table.insert(finishStep, step17)
    table.insert(finishStep, step18)
    table.insert(finishStep, step19)
    table.insert(finishStep, step20)

    for i,step in pairs (finishStep) do
        Teach:finishStepPer(step, false)
    end

    if isStartTeach == nil or isStartTeach == true then
        Teach:isStartTeach("Steps Count = "..#finishStep)
    end
end

--@brief 结束一个步骤
function Teach:finishStepPer(finishStep, isStartTeach, note)
    --WZLog("Teach:finishStepPer zero",finishStep, tostring(isStartTeach), tostring(note), #TeachIDToTable)

    if Teach.DATA == nil then
        return
    end

    if type(TeachIDToTable) ~= "table" then
        return
    end
    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        --WZLog("Teach:finishStepPer one", tostring(teachTable), tostring(teachObj))
        if teachObj ~= nil and teachObj.INDEX ~= nil then
            --WZLog("Teach:finishStepPer two",finishStep , tostring(teachObj.INDEX))
            teachObj:finishStep(finishStep)
        end
    end

    if isStartTeach == nil or isStartTeach == true then
        Teach:isStartTeach(note)
    end
end

--@brief    开始教学
--@param    nId：教学的编号（用于发协议）
--@param    nStep：教学的步骤
function Teach:beganNextStep(param)
    --WZLog("Teach:beganNextStep",Teach.STEP, Teach.INTERFACE)

    if type(TeachIDToTable) ~= "table" then
        return
    end

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        if teachObj ~= nil and type(teachObj.INDEX) ~= "table" then
            teachObj:_initTeachStep()
        end
    end

    for id, teachTable in pairs (TeachIDToTable) do
        local teachObj = _G[teachTable] or nil
        --WZLog("Teach:beganNextStep one", tostring(teachTable), tostring(teachObj))
        if teachObj ~= nil and teachObj.INDEX ~= nil then
            --WZLog("Teach:beganNextStep two" , tostring(teachObj.INDEX))
            teachObj:start(param, teachObj.INDEX)
        end
    end

end


function Teach:removeTeachElement(note)
    --WZLog("Teach:removeTeachElement one",tostring(note))

    WZUIButton:setGlobalInterval(50)
    if Teach.DATA == nil then
        return
    end

    GlobalGame.g_bIfInTeaching = false
    --@brief    移除发光
    Teach:removeShine()
    --@brief    移除场景里教学用的遮挡层
    Teach:removeShelter()

    if Teach.TEACH_DIALOGS == nil then
        Teach.TEACH_DIALOGS = {}
        Teach.TEACH_SHINES = {}
        Teach.TEACH_FINGERS = {}
    end

    for id = #Teach.TEACH_DIALOGS, 1, -1 do
        local dialogInfo = Teach.TEACH_DIALOGS[id]

        --WZLog("Teach:removeTeachElement two", #Teach.TEACH_DIALOGS, tostring(dialogInfo[3]), tostring(dialogInfo[4]), tostring(dialogInfo[1]), tostring(dialogInfo[2]))
        if dialogInfo[1] ~= nil and dialogInfo[2] ~= nil and dialogInfo[3] ~= nil then
            dialogInfo[2]:removeChildByTag(dialogInfo[3],true)
            dialogInfo[1] = nil
            dialogInfo[2] = nil
            table.remove(Teach.TEACH_DIALOGS, id)
        end
    end

    for id = #Teach.TEACH_SHINES, 1, -1 do
        local dialogInfo = Teach.TEACH_SHINES[id]

        --WZLog("Teach:removeTeachElement three", tostring(dialogInfo[3]), tostring(dialogInfo[4]), tostring(dialogInfo[1]), tostring(dialogInfo[2]))
        if dialogInfo[1] ~= nil and dialogInfo[2] ~= nil and dialogInfo[3] ~= nil then
            dialogInfo[2]:removeChildByTag(dialogInfo[3],true)
            dialogInfo[1] = nil
            dialogInfo[2] = nil
            table.remove(Teach.TEACH_SHINES, id)
        end
    end

    for id = #Teach.TEACH_FINGERS, 1, -1 do
        local dialogInfo = Teach.TEACH_FINGERS[id]

        --WZLog("Teach:removeTeachElement four", tostring(dialogInfo[3]), tostring(dialogInfo[4]), tostring(dialogInfo[1]), tostring(dialogInfo[2]))
        if dialogInfo[1] ~= nil and dialogInfo[2] ~= nil and dialogInfo[3] ~= nil then
            dialogInfo[2]:removeChildByTag(dialogInfo[3],true)
            dialogInfo[1] = nil
            dialogInfo[2] = nil
            table.remove(Teach.TEACH_FINGERS, id)
        end
    end
end

--@brief    设置可见性
function Teach:setVisible(visible, note)
    --WZLog("Teach:setVisible", tostring(visible), tostring(note), tostring(self.DIALOG), tostring(self.SHINE))

    if Teach.DATA == nil then
        return
    end
    
    self.ISVISIBLE = visible
    
    if Teach.TEACH_DIALOGS ~= nil then
        for id, dialogInfo in pairs(Teach.TEACH_DIALOGS) do
            --WZLog("Teach:setVisible one", tostring(dialogInfo[3]), tostring(dialogInfo[1]), tostring(dialogInfo[1]))
            if dialogInfo[1] ~= nil then
                dialogInfo[1]:setVisible(visible)
            end
        end
    end

    if Teach.TEACH_SHINES ~= nil then
        for id, dialogInfo in pairs(Teach.TEACH_SHINES) do
            --WZLog("Teach:setVisible two", tostring(dialogInfo[3]), tostring(dialogInfo[1]), tostring(dialogInfo[1]))
            if dialogInfo[1] ~= nil then
                dialogInfo[1]:setVisible(visible)
            end
        end
    end

    if Teach.TEACH_FINGERS ~= nil then
        for id, dialogInfo in pairs(Teach.TEACH_FINGERS) do
            --WZLog("Teach:setVisible three", tostring(dialogInfo[3]), tostring(dialogInfo[1]), tostring(dialogInfo[1]))
            if dialogInfo[1] ~= nil then
                dialogInfo[1]:setVisible(visible)
            end
        end
    end

end

--@brief    冒泡排序教学数据
function Teach:bubbleSort(array, compValue)
    --WZLog("Teach:bubbleSort")

    local n = #array

    for i = 1, n, 1 do
        for j = 1, n-i, 1 do
            if array[j][compValue] > array[j+1][compValue] then
                array[j], array[j+1] = array[j+1], array[j]
            end
        end
    end

end

--@brief    检查节点是否存在
--@param    obj：lua对象
--@param    cell：节点
function Teach:checktCell(obj, cell)
    --WZLog("Teach:checktCell one", tostring(self), tostring(obj), tostring(cell))
    if cell == nil then
        --WZLog("Teach:checktCell two")
        Teach:removeTeachElement()
        obj.INDEX = nil
    end
end

--@brief    教学按钮发光效果
--@param    tCell：发光节点
--@param    icon：图片路径
function Teach:showShineAction( tCell , icon , dir , pt, w, h, tag)
    if tCell == nil or icon == nil then
        return
    end
    dir = dir or GlobalMethod:CCSize( 10 , 10 )
    local order = tCell:getZOrder() + 1
    local size = tCell:getContentSize()
    local reSize = tCell:getRelativeSize()
    local pos = tCell:getRelativePosition()
    if  w == nil then
        w = reSize.width + dir.width / size.width
        h = reSize.height + dir.height / size.height
    else
        h = w * (size.width / size.height)
    end
    if pt then
        if math.abs(pt.x) < 10 and math.abs(pt.y) < 10 then
            pos = GlobalMethod:ccp( pos.x + pt.x , pos.y + pt.y )
        else
            pos = GlobalMethod:ccp( pos.x + pt.x / size.width , pos.y + pt.y / size.height )
        end
    end
    --WZLog("Teach:showShineAction one", tostring(tag), tostring(tCell) , icon , tostring(dir) , tostring(pt))
    --WZLog("Teach:showShineAction two", tostring(w), tostring(h), size.width, size.height, reSize.width, reSize.height)
    --创建发光图片
    local con = WZUIContainer:create()
    con:setRelativePosition( pos )

    --WZLog("Teach:showShineAction three", reSize.width, reSize.height, size.width, size.height, w,h)
    con:setRelativeSize( GlobalMethod:CCSize( w , h ) )
    con:setZOrder( order )
    --tCell:getParentElement():addChild( con )
    tCell:addChild( con, order, tag )
    local img = WZUIImage:create()
    img:setFile( icon )
    con:addChild( img )
    con:setTouchEnable(false)
    img:setTouchEnable(false)
    Teach.CONFLARE = con
    --创建发光
    self:_createShineAction( img )


    return con , img
end

--@brief    移除发光
function Teach:removeShine()
    --WZLog("Teach:removeShine one")
    do return end
    if Teach.CONFLARE ~= nil and (Teach.CONFLARE.getParent ~= nil) then
        --WZLog("Teach:removeShine three", Teach.CONFLARE.getParent)
        --WZLog("Teach:removeShine four", Teach.CONFLARE:getParent())
    end

    if Teach.CONFLARE ~= nil and (Teach.CONFLARE.getParent ~= nil and Teach.CONFLARE:getParent() ~= nil) then
        --WZLog("Teach:removeShine two" , Teach.CONFLARE)
        Teach.CONFLARE:removeFromParentAndCleanup( true )
        Teach.CONFLARE = nil
    end
end

--@brief    移除场景里教学用的遮挡层
function Teach:removeShelter()
    --WZLog("Teach:removeShelter one")
    do return end
    --移除场景里教学用的遮挡层
    WindowManager:removeTeachShelterLayer()
    WindowManager:removeTeachTouchLayer()
    if Teach.CONFLARE  and (Teach.CONFLARE.getParent ~= nil and Teach.CONFLARE:getParent() ~= nil) then
        --WZLog("Teach:removeShelter two")
        --删除对话框
        Teach.CONFLARE:removeFromParentAndCleanup( true )
        Teach.CONFLARE = nil
    end
end

--@brief    弹出教学对话框
--@param    element：遮罩层控件的节点
--@param    tCell：显示控件的节点
--@param    sDesc：文本提示内容
--@param    nDirection：对话框的方向
--@param    dirPt：对话框的偏移位置
--@param    t：对话框存在的时间
function Teach:showDialog( element , tCell , sDesc , nDirection , dirPt, zOrder , textLength, isNeedClick, isOriScale)
    --WZLog("Teach:showDialog", tostring(element), tostring(tCell))
    if tCell == nil or sDesc == nil then
        return
    end

    if zOrder == nil then
        zOrder = 0
    end

    local x = 0
    local y = 0
    --偏移位置
    if dirPt then
        x = dirPt.x
        y = dirPt.y
        --WZLog("Teach:showDialog",x,y,sDesc,nDirection)
    end

    local dialog, dialogObj = CellTeachDialog:addDialog( element, tCell , sDesc , nDirection , -1 , nil , nil , x , y, nil, nil, nil, nil, nil, nil, zOrder, zOrder, textLength, isNeedClick, isOriScale )

    --self:_createDialogAction(dialog, nDirection, dirPt)

    Teach.TEACH_DIALOG = dialog
    return dialog, dialogObj
end

--@brief    获取教学节点控件在遮罩层的位置
--@param    element：遮罩层的节点
--@param    tCell：教学节点
--@param    point：按下的位置
function Teach:getUiRect( element , tCell , point )
    if element == nil or tCell == nil then
        return
    end
    local winSize = element:getContentSize()        --获取遮罩层大小
    local size = tCell:getContentSize()             --获取节点打下
    local nDir = 1                                  --节点大小倍数
    local x = tCell:getPositionX()
    local y = tCell:getPositionY()
    local pt = tCell:getParentElement():convertToWorldSpace(CCPoint(x, y))
    pt = element:convertToNodeSpace( pt )
    --WZLog("pt:::::" , pt.x , pt.y )
    --WZLog("size:::::" , size.width , size.height )
    local maxX = pt.x + size.width / 2 * nDir
    local minX = pt.x - size.width / 2 * nDir
    local maxY = pt.y + size.height / 2 * nDir
    local minY = pt.y - size.height / 2 * nDir
    --判断按下的点是否在节点控件内，如果在，返回true，如果不在，返回false
    if point.x < minX or point.x > maxX then
        return false
    elseif point.y < minY or point.y > maxY then
        return false
    else
        return true
    end
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	教学按钮发光效果动画
--@param	img：图片节点
function Teach:_createShineAction( img )
	local t = 0.6
	--创建序列动作
    local actSpawn = WZUIActionSpawn:create()
    actSpawn:setIsLoop( true )
	local actionSequence = WZUIActionSequence:create()
	actionSequence:setIsLoop( true )
	--创建透明动作
	local actionFadeTo1 = WZUIActionFadeTo:create()
	actionFadeTo1:setDuration( t )
	actionFadeTo1:setOpacity( 50 )
	local actionFadeTo2 = WZUIActionFadeTo:create()
	actionFadeTo2:setDuration( t )
	actionFadeTo2:setOpacity( 255 )
	actionSequence:setChildAction( actionFadeTo1 )
	actionSequence:setChildAction( actionFadeTo2 )
    --创建旋转动作
    local actionRotateBy = WZUIActionRotateBy:create()
    actionRotateBy:setDuration(t * 2)
    actionRotateBy:setAngle(-360)
    actSpawn:setChildAction(actionRotateBy)
    actSpawn:setChildAction(actionSequence)

	img:runUIAction( actSpawn )
	return img
end

--@brief	教学按钮指引效果动画
--@param	img：图片节点
function Teach:_createDialogAction( img, direction, offset )

    if offset == nil then
        offset = {["x"] = 0, ["y"] = 0, ["m"] = 0}
    end

    if offset.m == nil then
        offset.m = 0
    end
    --WZLog("Teach:_createDialogAction", offset.x, offset.y, offset.m)

    local x,y,x1,y1
    local spacing = 0.1 - offset.m
    if math.abs(offset.x) > 1 or math.abs(offset.y) > 1 then
        spacing = 0.05
    end

    if direction == CellTeachDialog.DIR_RIGHT then
        x,y,x1,y1 = 1.2 + offset.x, 0.5 + offset.y, spacing, 0
    elseif direction == CellTeachDialog.DIR_LEFT then
        x,y,x1,y1 = -0.4 + offset.x, 0.5 + offset.y, 0 - spacing, 0
    elseif direction == CellTeachDialog.DIR_UP then
        x,y,x1,y1 = 0.7 + offset.x, 2 + offset.y, 0.0, spacing
    elseif direction == CellTeachDialog.DIR_DOWN then
        x,y,x1,y1 = 0.7 + offset.x, -0.4 + offset.y, 0.0, 0 - spacing
    end

    local t = 0.7
    --创建序列动作
    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( true )
    --创建移动动作
    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(t)
    actMoveTo:setMoveX(x + x1)
    actMoveTo:setMoveY(y + y1)
    local actMoveTo2 = WZUIActionMoveTo:create()
    actMoveTo2:setDuration(t)
    actMoveTo2:setMoveX(x)
    actMoveTo2:setMoveY(y)
    local actMoveTo3 = WZUIActionMoveTo:create()
    actMoveTo3:setDuration(0)
    actMoveTo3:setMoveX(x)
    actMoveTo3:setMoveY(y)
    actionSequence:setChildAction( actMoveTo3 )
    actionSequence:setChildAction( actMoveTo )
    actionSequence:setChildAction( actMoveTo2 )

    img:runUIAction( actionSequence )
    return img
end

-------------------------------------私有方法模块End----------------------------------------







