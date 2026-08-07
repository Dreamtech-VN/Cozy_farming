--TeachStepGroup1.lua
--@brief	TeachStepGroup1的模块
--@date		2014/9/23
--@author	莫剑峰
--@note		教学步骤组

TeachStepGroup1 =
{
    GROUP = 1,

	INDEX = 0,                          --步骤索引
    DIALOG = nil,                       --对话框
    DIALOG_PARENT = nil,                --对话框父节点
    SHINE = nil,                        --闪光框
    SHINE_PARENT = nil,                 --闪光框父节点
    FINGER = nil,                       --手指动画
    FINGER_PARENT = nil,                --手指动画父节点
    TOTAL_STEP = nil,                   --全部步骤
    GROUP_STEP = nil,                   --分组步骤
    ZORDER = 10003,                     --z轴和tag值
    STEP_GROUP_IDS = nil,               --步骤组索引
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始新手教学
--@param	nId：新手教学的编号
--@param	nStep：当前新手教学的步骤编号
function TeachStepGroup1:start( nId , tSteps )
	--WZLog("TeachStepGroup1:start one", nId, tostring(tSteps), tostring(self.INDEX), tostring(self.TOTAL_STEP))
    if tSteps == nil then
		return
	end

    if self.TOTAL_STEP == nil then
        tSteps = self:_initTeachStep()
    end

    if type(tSteps) ~= "table" then
        return
    end

    if tSteps[2] ~= nil and tSteps[3] == nil then
        tSteps[3] = 0
    end

    if tSteps[2] ~= nil and tSteps[2] ~= -2 then
        tSteps[4] = -2
        tSteps[5] = -2
    end

    if (tSteps[4] ~= nil and tSteps[4] ~= -2) and (tSteps[5] == nil or tSteps[5] == -2) then
        tSteps[5] = 0
    end
    for id, nStep in pairs (tSteps) do
        --WZLog("TeachStepGroup1:start four", id , nStep)
        --获取下一步的新手教学的步骤编号
        tSteps = self:getTeachStep( id )
        if tSteps ~= nil then
            for index, nStep in pairs (tSteps) do
                --WZLog("TeachStepGroup1:start five", id , nStep , #tSteps, tostring(#self.INDEX))
                --获取需要新手教学的节点和要提示的文本内容
                local tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon = self:_getTeachUiData( nStep, id, nId )
                --WZLog("TeachStepGroup1:start six", tostring(tCell), nStep , tostring(#self.INDEX))
                if nStep and nStep ~= -1 and tCell ~= nil then
                    if teachType == 0 then
                        self:_createTalk( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon)	--创建剧情对话
                    elseif teachType == 1 then
                        self:_createArrow( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )	--创建箭头
                    elseif teachType == 2 then
                        self:_createOpenModule( nStep, name, sDesc, nStep, isIsland)	--创建模块开启框
                    end
                    self.INDEX[id] = nStep
                    --WZLog("TeachStepGroup1:start seven", self.INDEX[id])
                    break
                end
            end
        end
    end
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStepGroup1:getTeachStep( nStep )

    for i, v in pairs (self.INDEX) do
        --WZLog("TeachStepGroup1:getTeachStep two",i,v)
    end

    if self.INDEX[nStep] <= -1 then
        return
    end

    --WZLog("TeachStepGroup1:getTeachStep three",#self.TOTAL_STEP[nStep])
    return self.TOTAL_STEP[nStep]
end

--@brief 结束步骤
function TeachStepGroup1:finishStep(finishStep)
    --WZLog("TeachStepGroup1:finishStep one", finishStep)

    local isStepCanFinish = false
    if self.TOTAL_STEP == nil or BattleCommon:tableLen(self.TOTAL_STEP) == 0 or self.INDEX == nil or self.INDEX == 0 then
        return
    end

    --WZLog("TeachStepGroup1:finishStep three", finishStep)
    for i, v in pairs(self.INDEX) do
        if finishStep == v then
            isStepCanFinish = true
        end
    end

    if isStepCanFinish == false then
        return
    end

    --WZLog("TeachStepGroup1:finishStep four", finishStep)
    for i,group in pairs(self.TOTAL_STEP) do
        if group ~= nil then
            for id,step in pairs(group) do
                --WZLog("TeachStepGroup1:finishStep five", i, id, step)
                if finishStep == step then
                    --WZLog("TeachStepGroup1:finishStep six", step)
                    --table.remove(group, id)

                    if #group - id <= 1 then
                        step = -2
                    end

                    self.INDEX[i] = step

                    if finishStep == self.Step_2_5 and self.INDEX[2] == -2 then
                        self.INDEX[3] = 0
                    end

                    if finishStep == self.Step_4_14 and self.INDEX[4] == -2 then
                        self.INDEX[5] = 0
                    end

                    ProtocolProcessorTeach:send_TASK_TiroStep(i, step)

                    isStepCanFinish = nil
                    break
                end
            end
            if isStepCanFinish == nil then
                break
            end
        end
    end

end

--@brief 是否正在进行技能教学
function TeachStepGroup1:isTeachSkill()
    --WZLog("TeachStepGroup1:isTeachSkill one")
    local isTeach = false

    if self.INDEX == nil or self.INDEX == 0 then
        return isTeach
    end

    for i, v in pairs(self.INDEX) do
        if v ~= nil and v == self.Step_5_3 then
            isTeach = true
        end
    end

    --WZLog("TeachStepGroup1:isTeachSkill two", isTeach)
    return isTeach
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建箭头
--@param	nId：新手教学的编号
function TeachStepGroup1:_createArrow( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )
    if tCell then
        if isIsland == true then
            tCell:setZOrder(500)
        end

        if sDesc ~= nil and sDesc ~= "" then
            --弹出教学对话框
            self.DIALOG = Teach:showDialog( tCell , tCell , sDesc , nDirection , dialogPt, self.ZORDER )
            self.DIALOG_PARENT = tCell
        end

        local shine = tCell
        if shineCell ~= nil then
            --WZLog("TeachStepGroup1:_createArrow zero",tostring(shineCell))
            shine = shineCell
        end

        --发光效果
        if shineScale == nil then
            --WZLog("TeachStepGroup1:_createArrow one")
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, nil, nil, self.ZORDER)
            self.SHINE_PARENT = shine
        else
            --WZLog("TeachStepGroup1:_createArrow two", shineScale.width, shineScale.height)
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, shineScale.width, shineScale.height, self.ZORDER)
            self.SHINE_PARENT = shine
        end

        table.insert(Teach.TEACH_DIALOGS, {[1]=self.DIALOG, [2]=self.DIALOG_PARENT, [3]=self.ZORDER, [4]=self.INDEX})
        table.insert(Teach.TEACH_SHINES, {[1]=self.SHINE, [2]=self.SHINE_PARENT, [3]=self.ZORDER, [4]=self.INDEX})

        if nId == self.Step_5_2 or nId == self.Step_5_4 or nId == self.Step_5_6 then
            local enemyPos, heroPos
            for id,hero in pairs (WBattleGlobal:getCurrent():getHeroList()) do
                heroPos = hero:getPosition()
            end
            for id,hero in pairs (WBattleGlobal:getCurrent():getGuaiList()) do
                enemyPos = hero:getPosition()
            end

            if enemyPos == nil then
                return
            end
            local posX,posY = 10, 40
            --WZLog("TeachStepGroup1:_createArrow three", heroPos.x, enemyPos.x)
            --创建手指动画
            local rotation, isRotation = 20, nil
            if heroPos.x >= enemyPos.x then
                rotation = -110
                isRotation = true
                posX,posY = 0, 50
            end
            self.FINGER = TeachBattleCommon:showFingerAnimation(tCell, {x = posX, y = posY}, rotation, self.ZORDER + 1, isRotation)
            self.FINGER_PARENT = tCell
            table.insert(Teach.TEACH_FINGERS, {[1]=self.FINGER, [2]=self.FINGER_PARENT, [3]=self.ZORDER + 1, [4]=self.INDEX})

        end
    end
end

--@brief	创建剧情对话
--@param	nId：新手教学的编号
function TeachStepGroup1:_createTalk( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon )
    --WZLog("TeachStepGroup1:_createTalk", tostring(WndTeachTalk.m_root), tostring(Teach.m_isWndTeachTalkExist), tostring(nStep), tostring(name), tostring(tCell), tostring(sDesc), tostring(nDirection), tostring(isIsland), tostring(dir), tostring(dialogPt), tostring(isImgRight))

    if sDesc == nil or WndTeachTalk.m_root ~= nil then
        return
    end

    if Teach.m_isWndTeachTalkExist == nStep then
        return
    end

    Teach.m_isWndTeachTalkExist = nStep

    local wndTeachTalk = WndTeachTalk:createElement()
    WndTeachTalk:setDetail(sDesc)
    WndTeachTalk:setImgRight(isImgRight)
    WndTeachTalk:setName(name)
    WndTeachTalk:setIcon(icon)
    WndTeachTalk:setReplaceScene(isIsland)
    WndTeachTalk:setTeachStep(nStep)
    WndTeachTalk:setIconOffset(dialogPt)
    WindowManager:addWindow(wndTeachTalk,WndTeachTalk)

end

--@brief	创建模块开启框
--@param	nId：新手教学的编号
function TeachStepGroup1:_createOpenModule( nId, sDesc, name, nStep, isIsland)
    --WZLog("TeachStepGroup1:_createOpenModule", tostring(WndTeachOpenModule.m_root),  nId, sDesc, name)

    if sDesc == nil or WndTeachOpenModule.m_root ~= nil or (WndTeachOpenModule.m_sDetail ~= nil and WndTeachOpenModule.m_sDetail ~= "") then
        return
    end

    if Teach.m_isWndTeachOpenModuleExist == nStep then
        return
    end

    Teach.m_isWndTeachOpenModuleExist = nStep

    local wndTeachOpenModule = WndTeachOpenModule:createElement()
    WndTeachOpenModule:setDetail(sDesc)
    WndTeachOpenModule:setName(name)
    WndTeachOpenModule:setTeachStep(nStep)
    WndTeachOpenModule:setReplaceScene(isIsland)
    WindowManager:addWindow(wndTeachOpenModule,WndTeachOpenModule)

end

--@brief	获取需要新手教学的节点和要提示的文本内容
--@param	nId：新手教学的编号
--@return	tCell：返回要提示新手教学的ui节点
--@return	sDesc：返回提示文本内容
--@return	nDirection：返回对话框方向
--@return	isIsland：是否小岛界面的控件
function TeachStepGroup1:_getTeachUiData( id, groupId ,uiId )
    --WZLog("TeachStepGroup1:_getTeachUiData one",id, Teach.TASK_TAG)
	if id == nil then
		return
	end
	local tCell = nil
	local sDesc = nil
	local nDirection = nil
	local isIsland = false
	local order = nil
	local dir = GlobalMethod:CCSize(9.6 , 9.6)
	local dialogPt = GlobalMethod:ccp(0 , 0)
    local shinePt = GlobalMethod:ccp(0 , 0)
    local shineScale = nil
    local isHud = true
    local shineCell = nil
    local icon = "common/animation/icon_world_boss_light.png"
    local isImgRight = false
    local name = "弹弹岛教官"
    local teachType = 0
    local data = nil
    local origin = GlobalMethod:ccp(0.5,0.5)

--id=引导ID,group_id=分组ID,pre_conditions=前置条件类型,pre_param=前置条件参数,
--action_type=动作类型,action_param=动作参数,teach_type=引导类型,
--graph_id=资源ID,desc=描述,teach_param=引导参数,end_type=结束类型,end_param=结束参数

	if id == self.Step_1_1 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"hello！欢迎来到弹弹岛。我是弹弹岛的教官卡丽娜，终于等到你来了。"
	elseif id == self.Step_1_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"是这样的！我接到组织的命令在此等候击败魔龙的英雄，这是组织给你的奖励。"
	elseif id == self.Step_1_3 or id == self.Step_3_2 or id == self.Step_5_10 then
        teachType = 1
		tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开任务界面"
		nDirection = CellDialog.DIR_UP

        --[[
        if Teach.TASK_TAG == 4 then     --4
            dialogPt = GlobalMethod:ccp(1.2 , -0.3)
            shinePt = GlobalMethod:ccp(0.925 - origin.x , 0.2 - origin.y)
        elseif Teach.TASK_TAG == 3 then --3
            dialogPt = GlobalMethod:ccp(1.2 , -0.08)
            shinePt = GlobalMethod:ccp(0.925 - origin.x , 0.4 - origin.y)
        elseif Teach.TASK_TAG == 2 then --2
            dialogPt = GlobalMethod:ccp(1.2 , 0.12)
            shinePt = GlobalMethod:ccp(0.925 - origin.x , 0.62 - origin.y)
        elseif Teach.TASK_TAG == 1 then --1
            dialogPt = GlobalMethod:ccp(1.2 , 0.35)
            shinePt = GlobalMethod:ccp(0.925 - origin.x , 0.84 - origin.y)
        end
        --]]

        dialogPt = GlobalMethod:ccp(0.3, 0)
        shinePt = GlobalMethod:ccp(0, 0)
        local width = 1.2
        local height = width * 1.7
        shineScale = GlobalMethod:CCSize(width , height)
	elseif id == self.Step_1_4 or id == self.Step_3_3 or id == self.Step_5_11 then
        teachType = 1
		tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"点击此处领取任务奖励"
		nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0.3)
        local width = 0.7
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
	elseif id == self.Step_1_5 or id == self.Step_3_4 then
        teachType = 1
		tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到主界面"
		nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.5 , 0.0)
        shinePt = GlobalMethod:ccp(-0.45 , 0.0)
        local width = 1.4
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_2_1 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"已经拿到奖励了吧，先穿上组织给你的装备吧，好的装备可以让你战力瞬间暴涨噢！"
        isIsland = true
	elseif id == self.Step_2_2 then
        teachType = 1
		tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
		nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_2_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择要穿戴的装备"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.6 , 0.3)
        shinePt = GlobalMethod:ccp(0.0 , -0.12)
        local width = 0.3
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_2_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击装备按钮，穿戴装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.4 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_2_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到主界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.15 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 1.0
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_3_1 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"穿上装备了吧？看起来很是威武呢！不知道威力如何！"
    elseif id == self.Step_4_1 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"情报人员发来新的线报，他们发现了一处试炼之地，只是每个人都只能独自前往试炼，你刚拿了新的武器，就先去试炼之地的外围去探查一下情况吧"
        isIsland = true
    elseif id == self.Step_4_2 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入副本界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.0 , -0.4)
        shinePt = GlobalMethod:ccp(-0.2 , 0)
        local width = 1.5
        local height = width * 0.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择单人副本"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-1.00 , 0.35)
        dialogPt.m = 0.08
        shinePt = GlobalMethod:ccp(-0.4 , -0.15)
        local width = 0.15
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_4 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"打副本，先选择好战斗要用的技能吧，还有带足道具噢，对战斗有很大帮助呢！"
    elseif id == self.Step_4_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开技能道具设置界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.3 , -1.6)
        local width = 1.2
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击打开道具设置界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.25 , 0)
        local width = 0.5
        local height = width * 4
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择任意3个要使用的技能"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(0.15 , 0)
        local width =0.5
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击打开道具设置界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(0.25 , 0)
        local width = 0.5
        local height = width * 4
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择任意3个要使用的道具"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(0.15 , 0)
        local width =0.5
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到副本界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.15 , 0.0)
        shinePt = GlobalMethod:ccp(-0.45 , -0.45)
        local width = 1.0
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_11 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"技能和道具都设置好了，是时候开始打副本咯！"
    elseif id == self.Step_4_12 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择副本"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.1 , 0.25)
        shinePt = GlobalMethod:ccp(0.33 , 0.35)
        local width = 0.5
        local height = width * 0.66
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_13 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择关卡"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.25 , -0.2)
        shinePt = GlobalMethod:ccp(0.4 , 0)
        local width = 1.1
        local height = width * 1.1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_4_14 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击挑战按钮"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.3 , 0)
        local width = 1.0
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_5_1 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"看来情报没错，我只能陪你到这里了，下面的战斗交给你了"
    elseif id == self.Step_5_2 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        shineCell = self:_getTeachShineElementById( id )
        sDesc = TeachData["id_"..id]["desc"]    --"滑动此处拉出抛物线，进行攻击"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(-0.655 , -1.72)
        shinePt = GlobalMethod:ccp(10 , 104)
        shineScale = GlobalMethod:CCSize(1 , 1)
        isHud = false
    elseif id == self.Step_5_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        shineCell = self:_getTeachShineElementById( id )
        sDesc = TeachData["id_"..id]["desc"]    --"点击使用技能"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(-0.175 , 0.1)
        shinePt = GlobalMethod:ccp(-0.1 , -0.35)
        local width = 0.6
        local height = width * 5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_5_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        shineCell = self:_getTeachShineElementById( id )
        sDesc = TeachData["id_"..id]["desc"]    --"滑动此处拉出抛物线，进行技能攻击"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(-0.655 , -1.72)
        shinePt = GlobalMethod:ccp(10 , 104)
        shineScale = GlobalMethod:CCSize(1.0 , 1.0)
        isHud = false
    elseif id == self.Step_5_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击使用必杀技"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.1 , 0)
        shinePt = GlobalMethod:ccp(-54 , 61)
        shineScale = GlobalMethod:CCSize(1.5 , 1.5)
    elseif id == self.Step_5_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        shineCell = self:_getTeachShineElementById( id )
        sDesc = TeachData["id_"..id]["desc"]    --"滑动此处拉出抛物线，进行必杀攻击"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(-0.655 , -1.72)
        shinePt = GlobalMethod:ccp(10 , 104)
        shineScale = GlobalMethod:CCSize(1.0 , 1.0)
        isHud = false
    elseif id == self.Step_5_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"结束副本后，可以获取翻牌奖励，点击其中一张牌，获取副本奖励"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.3 , 0.25)
        shinePt = GlobalMethod:ccp(-0.6 , 0.3)
        local width = 0.25
        local height = width * 1.3
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_5_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处关闭副本界面，返回小岛"
        nDirection = CellDialog.DIR_LEFT
        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
            --dialogPt = GlobalMethod:ccp(0.0 , -0.15)
            --shinePt = GlobalMethod:ccp(0.0 , 0)
        --else
            dialogPt = GlobalMethod:ccp(0.0 , 0.0)
            shinePt = GlobalMethod:ccp(0.0 , 0)
        end

        local width = 0.85
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_5_9 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"经过一轮战斗，想必已经有点熟悉了吧，你完成了任务，先去领奖吧。"
    end

    --WZLog("TeachStepGroup1:_getTeachUiData two", tostring(tCell), tostring(shineCell))

    if (teachType == 0 or teachType == 2) and data == false then
    return nil
    elseif (teachType == 0 or teachType == 2) and data ~= false then
    tCell =  true
    end
	return tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon
end

--@brief    获取教学元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup1:_getTeachElementById( id, teachType, groupId, uiId )
    --WZLog("TeachStepGroup1:_getTeachElementById one", id)
    local element, data = nil, nil
    if uiId == nil then
    uiId = -1
    end

    if id == self.Step_1_3 or id == self.Step_3_2 or id == self.Step_5_10 then
        --WZLog("id == self.Step_1_3", Teach:getTaskState(Teach.TASK_ID_WELCOME), tostring(WndRightMenu.m_root))
        if WndBottomMenu.m_root == nil then
        return
        end
        if WndTask.m_root ~= nil then
        return
        end
        if WndTeachTalk.m_root ~= nil then
        return
        end
        if id == self.Step_1_3 and Teach:getTaskState(Teach.TASK_ID_WELCOME) ~= 1 then
        return
        end
        if id == self.Step_3_2 and Teach:getTaskState(Teach.TASK_ID_WEAPON) ~= 1 then
        return
        end
        if id == self.Step_5_10 and Teach:getTaskState(Teach.TASK_ID_SINGLE) ~= 1 then
        return
        end
        --[[
        if WndRightMenu.m_root ~= nil then
            element = GetElementWithoutAssert(WndRightMenu.m_root, "conBg_WndRightMenu",WZUIContainer)
            local tbcon = GetElement(WndRightMenu.m_root, "tbcon_WndRightMenu", WZUITableContainer)
            data = tbcon:getCellElement(3)
        end
        --]]

        if WndBottomMenu.m_root ~= nil then
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnTask_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_1_4 or id == self.Step_3_3 or id == self.Step_5_11 then
        --WZLog("id == self.Step_1_4", tostring(GlobalGame.g_nCurrentUIChannelId ~= Chat_CHannel_Task), Teach:getTaskState(Teach.TASK_ID_WELCOME))
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_CHannel_Task then
        return
        end
        if WndTeachTalk.m_root ~= nil then
        return
        end
        if id == self.Step_1_4 and Teach:getTaskState(Teach.TASK_ID_WELCOME) ~= 1 then
        return
        end
        if id == self.Step_3_3 and Teach:getTaskState(Teach.TASK_ID_WEAPON) ~= 1 then
        return
        end
        if id == self.Step_5_11 and Teach:getTaskState(Teach.TASK_ID_SINGLE) ~= 1 then
        return
        end
        if WndTask.m_root ~= nil and WndTask.m_tRewardsLuaObj ~= nil and WndTask.m_nCurIndex == 0 then
            element = GetElementWithoutAssert(WndTask.m_tRewardsLuaObj.m_root, "btnTask_CellTaskRewards", WZUIButton)
        end
    elseif id == self.Step_1_5 or id == self.Step_3_4 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_CHannel_Task then
        return
        end
        if id == self.Step_1_5 and Teach:getTaskState(Teach.TASK_ID_WELCOME) ~= 2 then
        return
        end
        if id == self.Step_3_4 and Teach:getTaskState(Teach.TASK_ID_WEAPON) ~= 2 then
        return
        end

        if WndTask.m_root ~= nil then
            element = GetElementWithoutAssert(WndTask.m_root, "btnClose_WndTask", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_2_1 then
        --WZLog("id == self.Step_2_1", tostring(WndRewardShow.m_root), tostring(Teach.m_isWndTeachTalkExist))
        if WndRewardShow.m_root ~= nil then
            data = false
            return element,data
        end
        if (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist) or Teach.m_isWndTeachTalkExist == 1037) then
            data = nil
        else
            data = false
        end
    elseif id == self.Step_2_2 then
        if WndBag.m_root ~= nil then
        return
        end
        if Teach:getTaskState(Teach.TASK_ID_WEAPON) >= 1 or Teach:getTaskState(-2) == 2 then
        return
        end
        if WndBottomMenu.m_root ~= nil then
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnPlayer_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_2_3 then
        if WndEquip.m_nBagIndex ~= 1 or Teach:getTaskState(Teach.TASK_ID_WEAPON) >= 1 or Teach:getTaskState(-2) == 2 then
        return
        end
        if WndItemInfo.m_root ~= nil and GetElementWithoutAssert(WndItemInfo.m_root, "btn3_WndItemInfo", WZUIButton) ~= nil then
        return
        end
        if WndEquip.m_root ~= nil and #CacheCenter:getWeaponList() >= 2 then
            element = GetElementWithoutAssert(WndEquip.m_root, "conGoods_WndEquip", WZUIContainer)
        end
    elseif id == self.Step_2_4 then
        if Teach:getTaskState(Teach.TASK_ID_WEAPON) >= 1 or Teach:getTaskState(-2) == 2 then
        return
        end
        if WndItemInfo.m_root ~= nil then
            element = GetElementWithoutAssert(WndItemInfo.m_root, "btn3_WndItemInfo", WZUIButton)
        end
    elseif id == self.Step_2_5 then
        if Teach:getTaskState(Teach.TASK_ID_WEAPON) < 1 and Teach:getTaskState(-2) ~= 2 then
        return
        end
        if WndRecover.m_root ~= nil then
        return
        end
        if WndBag.m_root ~= nil then
            element = GetElementWithoutAssert(WndBag.m_root, "btnClose_WndBag", WZUIButton)
            if self.INDEX[3] == nil or self.INDEX[3] == -2 then
                self.INDEX[3] = 0
            end
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_3_1 then
        if WndRecover.m_root ~= nil then
        data = false
        return element, data
        end
        if WndBag.m_root == nil and (Teach:getTaskState(-2) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_4_2 then
        if (GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island and uiId ~= Chat_Channel_Island) or Teach:getTaskState(-41) == 2 then
        return
        end
        if SceneIsland.m_root ~= nil then
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnBossMap_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_4_3 then
        if (GlobalGame.g_nCurrentUIChannelId == Chat_Channel_SingleMap or uiId == Chat_Channel_SingleMap) or Teach:getTaskState(-41) == 2 then
        return
        end
       
    elseif id == self.Step_4_4 then
        --WZLog("id == self.Step_4_4", tostring(WndTask.m_root), tostring(WndRewardShow.m_root))
        if WndTask.m_root ~= nil then
            data = false
            return element, data
        end
        if WndRewardShow.m_root ~= nil then
            data = false
            return element, data
        end
        if  (Teach:getTaskState(-42) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_4_5 then
        if WndSkillProp.m_root ~= nil or Teach:getTaskState(-4) == 2 or Teach:getTaskState(-41) == 2 or Teach:getTaskState(-42) == 2 then
            return
        end
        if WndTeachTalk.m_root ~= nil then
            return
        end
        
    elseif id == self.Step_4_7 then
        if WndSkillProp.m_nCurListType ~= nil and WndSkillProp.m_nCurListType == 2 or Teach:getTaskState(-41) == 2  then
            return
        end
        if WndSkillProp.m_root ~= nil and WndSkillProp:getPlayerSkillPropCount(1) < 3 then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "conSkillPropList_WndSkillProp", WZUIContainer)
            if element ~= nil then
            element:setZOrder(500)
            end
        end
    elseif id == self.Step_4_6 or id == self.Step_4_8 then
        if Teach:getTaskState(-41) == 2 then
            return
        end
        if id == self.Step_4_6 and (WndSkillProp.m_nCurListType == 1 or WndSkillProp:getPlayerSkillPropCount(1) >= 3) then
        return
        end
        if id == self.Step_4_8 and (WndSkillProp.m_nCurListType == 2 or WndSkillProp:getPlayerSkillPropCount(2) >= 3)  then
        return
        end
        if WndSkillProp.m_root ~= nil then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "checkSkillProp_WndSkillProp", WZUICheckBoxGroup)
            --element:setZOrder(500)
            element:getParentElement():setZOrder(500)
        end
    elseif id == self.Step_4_9 then
        if WndSkillProp.m_nCurListType ~= nil and WndSkillProp.m_nCurListType == 1  or Teach:getTaskState(-41) == 2 then
        return
        end
        if WndSkillProp.m_root ~= nil and WndSkillProp:getPlayerSkillPropCount(2) < 3 then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "conSkillPropList_WndSkillProp", WZUIContainer)
            if element ~= nil then
                element:setZOrder(500)
            end
        end
    elseif id == self.Step_4_10 then
        if Teach:getTaskState(-41) == 2 then
        return
        end
        if WndSkillProp.m_root ~= nil then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "btnClose_WndSkillProp", WZUIButton)
            table.insert(Teach.DATA.saveTask, {["ids"] = -4, ["step"] = -2})
            ProtocolProcessorTeach:send_TASK_TiroStep(-4, -2)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_4_11 then
        if WndTask.m_root ~= nil then
            data = false
            return element, data
        end
        if WndRewardShow.m_root ~= nil then
            data = false
            return element, data
        end
       
    elseif id == self.Step_4_12 then
        do return end
       
        
    elseif id == self.Step_4_13 then
        do return end
        
    elseif id == self.Step_4_14 then
        if Teach:getTaskState(-41) == 2 or Teach:getTaskState(-4) ~= 2 or WndTeachTalk.m_root ~= nil then
        return
        end
       
    elseif id == self.Step_5_1 then
        if SceneBattle.m_root ~= nil and (Teach:getTaskState(Teach.TASK_ID_SINGLE) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_5_2 or id == self.Step_5_4 or id == self.Step_5_6 then
        --WZLog("TeachStepGroup1:_getTeachElementById five", id, tostring(WBattleGlobal:getCurrent():isMyTurn()), Teach:getTaskState(-51), Teach:getTaskState(-52), Teach:getTaskState(-53), Teach:getTaskState(-5))
        if WndBattleHud.m_root ~= nil and WBattleGlobal:getCurrent():isMyTurn() and   SceneBattle:getBattleLoop():getBattleStatus() == BattleLoop.S_NORMAL then

        if id == self.Step_5_2 and (Teach:getTaskState(-51) == 2 or Teach:getTaskState(-5) == 2 or Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2) then
        return
        end
        if id == self.Step_5_4 and (Teach:getTaskState(-5) ~= 2 or Teach:getTaskState(-52) == 2 or Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2) then
        return
        end
        if id == self.Step_5_6 and (WndBattleHud:getMyHero():getUseBigSkill() ~= true or Teach:getTaskState(-53) == 2 or Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2) then
        return
        end
            element =  WndBattleHud:getMyHero():getPlayerNameIcon().m_tNameLayer
        end
    elseif id == self.Step_5_3 then
        if WndBattleHud.m_root ~= nil and WBattleGlobal:getCurrent():isMyTurn() and WBattleGlobal:getCurrent().m_nTurnTimes > 1 then
        if Teach:getTaskState(-5) == 2 or Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2 then
        return
        end
            element = GetElementWithoutAssert(WndBattleHud.m_root, "conSkill_WndBattleHud", WZUIContainer)
            element:setZOrder(500)
        end
    elseif id == self.Step_5_5 then
        if WndBattleHud:getMyHero() == nil or Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2 then
            return element, data
        end
        local allow = not WBattleGlobal:getCurrent():isGameOver()
        allow = allow and WndBattleHud:getMyHero() ~= nil
        allow = allow and not WndBattleHud:getMyHero():isDead()
        allow = allow and WBattleGlobal:getCurrent():isWaitNextRound() == false
        allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_SHOOT
        allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PLAYER_FLY
        allow = allow and SceneBattle:getBattleLoop():getBattleStatus() ~= BattleLoop.S_PET_SHOOT
        if allow then
            if WndBattleHud.m_root ~= nil and WndBattleHud:getMyHero():getSp() >= 100 and WndBattleHud:getBigSkillBtnContainer():getTouchEnable() and WBattleGlobal:getCurrent():isMyTurn() == true then

                element =  GetElement(WndBattleHud.m_root,"conBigSkill_WndBattleHud",WZUIContainer)
            end
        end
    elseif id == self.Step_5_7 then
        if Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2 then
        return
        end
        if ScenceBattleSettlment.m_root ~= nil and ScenceBattleSettlment.m_nFlipCardCountDown ~= nil and ScenceBattleSettlment.m_nFlipCardCountDown >= 8  then
            element = GetElementWithoutAssert(ScenceBattleSettlment.m_root, "conCard_SceneSingleMapBattleSettlement", WZUIContainer)
            element:setZOrder(500)
        end
    elseif id == self.Step_5_8 then
        if Teach:getTaskState(Teach.TASK_ID_SINGLE) ~= 1 or WndTask.m_root ~= nil then
        return
        end
        if WndBottomMenu.m_root ~= nil then
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnBack_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_5_9 then
        --WZLog("id == self.Step_5_9", Teach:getTaskState(Teach.TASK_ID_SINGLE))
        if Teach:getTaskState(Teach.TASK_ID_SINGLE) == 2 then
            data = false
            return element, data
        end
        if WndBottomMenu.m_root ~= nil and (Teach:getTaskState(Teach.TASK_ID_SINGLE) == 1 or Teach:getTaskState(-54) == 2) and Teach:getTaskState(-55) ~= 2 and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
            data = nil
        else
            data = false
        end
    elseif teachType ~= nil and teachType == 0 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id ~= Teach.m_isWndTeachTalkExist)) and id > self.INDEX[groupId] and WndTeachOpenModule.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    elseif teachType ~= nil and teachType == 2 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachOpenModuleExist == nil or (Teach.m_isWndTeachOpenModuleExist ~= nil and id ~= Teach.m_isWndTeachOpenModuleExist)) and id > self.INDEX[groupId] and WndTeachTalk.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    end

    --WZLog("TeachStepGroup1:_getTeachElementById two", id, tostring(element), tostring(data), tostring(self.INDEX[groupId]))
    return element, data
end

--@brief    获取教学闪光元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup1:_getTeachShineElementById( id )
    --WZLog("TeachStepGroup1:_getTeachShineElementById one", id)
    local element = nil

    if id == self.Step_5_2 or id == self.Step_5_4 or id == self.Step_5_6 then
        if WndBattleHud.m_root ~= nil then
            element =  WBattleGlobal:getCurrent():getMyHero().m_tShine
        end
    end

    --WZLog("TeachStepGroup1:_getTeachShineElementById two", id, tostring(element))
    return element
end


--@brief	初始化的新手教学的步骤编号
--@return	新手教学的步骤编号
function TeachStepGroup1:_initTeachStep()
    --WZLog("TeachStepGroup1:_initTeachStep one")

    self.STEP_GROUP_IDS = {[1]=1,[2]=2,[3]=3,[4]=4,[5]=5}

    if self.TOTAL_STEP == nil then
        self.TOTAL_STEP = {}

        for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
            for stepIndex, data in pairs (Teach.DATA.group[groupIndex]) do
                self["Step_"..i.."_"..stepIndex] = data.id
                --WZLog("TeachStepGroup1:_initTeachStep two", "Step_"..i.."_"..stepIndex, data.id)
            end
        end

        local group = {}
        ---[[
        table.insert(group, self.Step_1_1)
        table.insert(group, self.Step_1_2)
        table.insert(group, self.Step_1_3)
        table.insert(group, self.Step_1_4)
        --table.insert(group, self.Step_1_5)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[1] = group

        group = {}
        ---[[
        table.insert(group, self.Step_2_1)
        table.insert(group, self.Step_2_2)
        table.insert(group, self.Step_2_3)
        table.insert(group, self.Step_2_4)
        table.insert(group, self.Step_2_5)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[2] = group

        group = {}
        ---[[
        table.insert(group, self.Step_3_1)
        table.insert(group, self.Step_3_2)
        table.insert(group, self.Step_3_3)
        --table.insert(group, self.Step_3_4)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[3] = group

        group = {}
        ---[[
        table.insert(group, self.Step_4_1)
        table.insert(group, self.Step_4_2)
        table.insert(group, self.Step_4_3)
        table.insert(group, self.Step_4_4)
        table.insert(group, self.Step_4_5)
        table.insert(group, self.Step_4_6)
        table.insert(group, self.Step_4_7)
        table.insert(group, self.Step_4_8)
        table.insert(group, self.Step_4_9)
        table.insert(group, self.Step_4_10)
        table.insert(group, self.Step_4_11)
        table.insert(group, self.Step_4_12)
        table.insert(group, self.Step_4_13)
        table.insert(group, self.Step_4_14)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[4] = group

        group = {}
        ---[[
        table.insert(group, self.Step_5_1)
        table.insert(group, self.Step_5_2)
        table.insert(group, self.Step_5_3)
        table.insert(group, self.Step_5_4)
        table.insert(group, self.Step_5_5)
        table.insert(group, self.Step_5_6)
        table.insert(group, self.Step_5_7)
        --table.insert(group, self.Step_5_8)
        table.insert(group, self.Step_5_9)
        table.insert(group, self.Step_5_10)
        table.insert(group, self.Step_5_11)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[5] = group

        table.insert(self.TOTAL_STEP, nil)
    end

    self.INDEX = {}

    for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
        for id, data in pairs (Teach.DATA.saveStep) do
            if data.ids == i then
                self.INDEX[i] = data.step
            end
        end
    end

    --self.INDEX[2] = 0

    --WZLog("TeachStepGroup1:_initTeachStep four", #self.TOTAL_STEP, #self.INDEX)
	return self.INDEX
end

