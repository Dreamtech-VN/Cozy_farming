--TeachStepGroup4.lua
--@brief	TeachStepGroup4的模块
--@date		2014/9/25
--@author	莫剑峰
--@note		教学步骤组

TeachStepGroup4 =
{
    GROUP = 4,

	INDEX = 0,                          --步骤索引
    DIALOG = nil,                       --对话框
    DIALOG_PARENT = nil,                --对话框父节点
    SHINE = nil,                        --闪光框
    SHINE_PARENT = nil,                 --闪光框父节点
    TOTAL_STEP = nil,                   --全部步骤
    GROUP_STEP = nil,                   --分组步骤
    ZORDER = 10003,                     --z轴和tag值
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始新手教学
--@param	nId：新手教学的编号
--@param	nStep：当前新手教学的步骤编号
function TeachStepGroup4:start( nId , tSteps )
	--WZLog("TeachStepGroup4:start one", nId, tostring(tSteps), tostring(self.INDEX), tostring(self.TOTAL_STEP))
    if tSteps == nil then
		return
	end

    if self.TOTAL_STEP == nil then
        tSteps = self:_initTeachStep()
    end

    if type(tSteps) ~= "table" then
        return
    end

    for id, nStep in pairs (tSteps) do
        --WZLog("TeachStepGroup4:start four", id , nStep)
        --获取下一步的新手教学的步骤编号
        tSteps = self:getTeachStep( id )
        if tSteps ~= nil then
            for index, nStep in pairs (tSteps) do
                --WZLog("TeachStepGroup4:start five", id , nStep , #tSteps, tostring(#self.INDEX))
                --获取需要新手教学的节点和要提示的文本内容
                local tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon = self:_getTeachUiData( nStep, id, nId )
                --WZLog("TeachStepGroup4:start six", tostring(tCell), nStep , tostring(#self.INDEX))
                if nStep and nStep ~= -1 and tCell ~= nil then
                    if teachType == 0 then
                        self:_createTalk( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon)	--创建剧情对话
                    elseif teachType == 1 then
                        self:_createArrow( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )	--创建箭头
                    elseif teachType == 2 then
                        self:_createOpenModule( nStep, name, sDesc, nStep, isIsland)	--创建模块开启框
                    end
                    self.INDEX[id] = nStep
                    --WZLog("TeachStepGroup4:start seven", self.INDEX[id])
                    break
                end
            end
        end
    end
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStepGroup4:getTeachStep( nStep )

    for i, v in pairs (self.INDEX) do
        --WZLog("TeachStepGroup4:getTeachStep two",i,v)
    end

    if self.INDEX[nStep] <= -1 then
        return
    end

    --WZLog("TeachStepGroup4:getTeachStep three",#self.TOTAL_STEP[nStep])
    return self.TOTAL_STEP[nStep]
end

--@brief 结束步骤
function TeachStepGroup4:finishStep(finishStep)
    --WZLog("TeachStepGroup4:finishStep one", finishStep)

    local isStepCanFinish = false
    if self.TOTAL_STEP == nil or BattleCommon:tableLen(self.TOTAL_STEP) == 0 or self.INDEX == nil or self.INDEX == 0 then
        return
    end

    --WZLog("TeachStepGroup4:finishStep three", finishStep)
    for i, v in pairs(self.INDEX) do
        if finishStep == v then
            isStepCanFinish = true
        end
    end

    if isStepCanFinish == false then
        return
    end

    --WZLog("TeachStepGroup4:finishStep four", finishStep)
    for i,group in pairs(self.TOTAL_STEP) do
        if group ~= nil then
            for id,step in pairs(group) do
                --WZLog("TeachStepGroup4:finishStep five", i, id, step)
                if finishStep == step then
                    --WZLog("TeachStepGroup4:finishStep six", step)
                    --table.remove(group, id)

                    if #group - id <= 1 then
                        step = -2
                    end

                    self.INDEX[i] = step

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
function TeachStepGroup4:isTeachSkill()
    --WZLog("TeachStepGroup4:isTeachSkill one")
    local isTeach = false

    if self.INDEX == nil or self.INDEX == 0 then
        return isTeach
    end

    for i, v in pairs(self.INDEX) do
        if v ~= nil and v == self.Step_5_3 then
            isTeach = true
        end
    end

    --WZLog("TeachStepGroup4:isTeachSkill two", isTeach)
    return isTeach
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建箭头
--@param	nId：新手教学的编号
function TeachStepGroup4:_createArrow( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )
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
            --WZLog("TeachStepGroup4:_createArrow zero",tostring(shineCell))
            shine = shineCell
        end

        --发光效果
        if shineScale == nil then
            --WZLog("TeachStepGroup4:_createArrow one")
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, nil, nil, self.ZORDER)
            self.SHINE_PARENT = shine
        else
            --WZLog("TeachStepGroup4:_createArrow two", shineScale.width, shineScale.height)
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, shineScale.width, shineScale.height, self.ZORDER)
            self.SHINE_PARENT = shine
        end

        table.insert(Teach.TEACH_DIALOGS, {[1]=self.DIALOG, [2]=self.DIALOG_PARENT, [3]=self.ZORDER, [4]=self.INDEX})
        table.insert(Teach.TEACH_SHINES, {[1]=self.SHINE, [2]=self.SHINE_PARENT, [3]=self.ZORDER, [4]=self.INDEX})

    end
end

--@brief	创建剧情对话
--@param	nId：新手教学的编号
function TeachStepGroup4:_createTalk( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon )
    --WZLog("TeachStepGroup4:_createTalk", tostring(WndTeachTalk.m_root), tostring(nId), tostring(name), tostring(tCell), tostring(sDesc), tostring(nDirection), tostring(isIsland), tostring(dir), tostring(dialogPt), tostring(isImgRight))

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
function TeachStepGroup4:_createOpenModule( nId, sDesc, name, nStep, isIsland)
    --WZLog("TeachStepGroup4:_createOpenModule", tostring(WndTeachOpenModule.m_root),  nId, sDesc, name)

    if sDesc == nil or WndTeachOpenModule.m_root ~= nil then
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
function TeachStepGroup4:_getTeachUiData( id, groupId ,uiId )
    --WZLog("TeachStepGroup4:_getTeachUiData one",id)
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

	if id == self.Step_14_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"结婚系统"
    elseif id == self.Step_14_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"结婚系统已经开启，未婚的状态可以与异性好友进行求婚，求婚成功举行婚礼后则成功结婚"
    elseif id == self.Step_15_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"卡牌系统"
    elseif id == self.Step_15_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"恭喜你！卡牌系统已经开启，收集并且装备激活卡牌，卡牌属性可以加成到角色身上提升战斗力噢！"
    elseif id == self.Step_15_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开卡牌界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.25 , 0)
        local width = 1.0
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开卡牌合成界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.75 , 0.0)
        dialogPt.m = 0.08
        shinePt = GlobalMethod:ccp(-0.035 , -0.3)
        local width = 0.2
        local height = width * 13
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处合成卡牌"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.35 , 0)
        local width = 1.0
        local height = width * 2.0
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确认获得卡牌"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , -0.05)
        shinePt = GlobalMethod:ccp(-0.05 , 0.25)
        local width = 1.0
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处装备卡牌"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.95 , 0.0)
        dialogPt.m = 0.08
        shinePt = GlobalMethod:ccp(-0.215 , -0.3)
        local width = 0.2
        local height = width * 13
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处点击要装备的卡牌"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.35 , 0.33)
        shinePt = GlobalMethod:ccp(-0.28 , 0.32)
        local width = 0.3
        local height = width * 0.85
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处装备卡牌"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.4 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_15_11 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"恭喜你已经成功装备了卡牌，卡牌的属性会添加到角色上，固定组合的卡牌还会激活附加属性噢！"
    elseif id == self.Step_16_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"宠物乐园"
    elseif id == self.Step_16_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"宠物系统已经开启，可以通过宠物乐园进行宠物收集，和养成噢！宠物可以协助战斗，是一大助力噢！"
    elseif id == self.Step_16_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开宠物乐园"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.3 , 0)
        local width = 1.5
        local height = width * 1.2
        shineScale = GlobalMethod:CCSize(width , height)
        isIsland = true
    elseif id == self.Step_16_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开驯服中心"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.02 , 0.35)
        local width = 1.0
        local height = width * 1.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_5 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"这里就是宠物驯服中心拉，在这里你可以看到可以驯服到的各种宠物，当然不同的宠物会有不同的驯服要求，下面尝试一下驯服第一只宠物吧！"
    elseif id == self.Step_16_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择要驯服的宠物"--
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.85 , 0.0)
        dialogPt.m = 0.08
        shinePt = GlobalMethod:ccp(-0.33 , 0.0)
        local width = 0.25
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确认驯服宠物"--
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.35 , 0.4)
        local width = 1.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_8 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"恭喜你咯！成功驯服第一只宠物，接下来去看看宠物如何升级并且作战吧！"
    elseif id == self.Step_16_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处关闭驯服中心"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 1.0
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开培训学院"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.02 , 0)
        local width = 1.0
        local height = width * 1.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_11 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"在这里先将宠物出战吧，出战的宠物将会辅助战斗噢！"
    elseif id == self.Step_16_12 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择宠物"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.85 , 0.17)
        dialogPt.m = 0.05
        shinePt = GlobalMethod:ccp(-0.3 , 0.17)
        local width = 0.1
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_13 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击出战按钮宠物将协助战斗"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.025 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.3)
        local width = 1.0
        local height = width * 1.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_14 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"好了，已经将宠物设置好出战了。接下来先训练宠物吧，训练宠物可以获得宠物经验，进行升级。"
    elseif id == self.Step_16_15 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入宠物训练界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.05 , 0.0)
        shinePt = GlobalMethod:ccp(-0.35 , 0.3)
        local width = 1.0
        local height = width * 1.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_16_16 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确认开始训练"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(-0.01 , 0.0)
        shinePt = GlobalMethod:ccp(-0.07 , 0.45)
        local width = 0.8
        local height = width * 2.7
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_17_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"日常任务"
    elseif id == self.Step_17_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"是不是感觉升级有点吃力了？哈哈！现在你的实力已经可以领取每日任务了，可以获取大量金币和经验呢！快跟我去看看吧~"
    elseif id == self.Step_17_3 then
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

        local width = 0.13
        local height = width * 1.7
        shineScale = GlobalMethod:CCSize(width , height)
        --]]
        dialogPt = GlobalMethod:ccp(0.3, 0)
        shinePt = GlobalMethod:ccp(0, 0)
        local width = 1.2
        local height = width * 1.7
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_17_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开每日任务选项卡"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.1)
        shinePt = GlobalMethod:ccp(0.0 , 0.5)
        local width = 1
        local height = width * 2.0
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_17_5 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"这里就是每日任务列表，每天都会刷新，只要达成条件，还能花钱提升奖励呢！简直就是赚钱和升级的作弊神器噢！千万好好利用~"
    elseif id == self.Step_18_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"修炼"
    elseif id == self.Step_18_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"提升修炼等级可以增加角色属性，修炼等级高了也不比装备作用差呢！"
    elseif id == self.Step_18_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_18_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开修炼界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.0
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_18_5 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"可以看到，一共有5种修炼属性，每种修炼属性对应提升一种属性数值。"
    elseif id == self.Step_18_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择要升级的修炼属性"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.15)
        shinePt = GlobalMethod:ccp(0.4 , -0.35)
        local width = 1.0
        local height = width * 1.0
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_18_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确认修炼"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.25 , 0.5)
        local width = 0.7
        local height = width * 1.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_18_8 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"你刚才修炼的属性升级了，提升了不少属性呢，接下来看你自己的了~"
	elseif id == self.Step_19_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"星魂"
    elseif id == self.Step_19_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"提升星魂可以将星魂之力加成给角色。快去看看吧！"
    elseif id == self.Step_19_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_19_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开星魂界面"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0)
        local width = 1.0
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_19_5 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"可以看到，一共有5种修炼属性，每种修炼属性对应提升一种属性数值。"
    elseif id == self.Step_19_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择要升级的修炼属性"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(1.2 , 0.2)
        shinePt = GlobalMethod:ccp(0.35 , 0.1)
        local width = 2.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_19_7 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"你刚才修炼的属性升级了，提升了不少属性呢，接下来看你自己的了~"
    elseif id == self.Step_23_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"公会"
    elseif id == self.Step_23_2 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = "" --TeachData["id_"..id]["desc"]    --""
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.0 , -0.4)
        shinePt = GlobalMethod:ccp(-0.2 , 0.2)
        local width = 1.5
        local height = width * 0.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_24_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
        isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"支线"
    end

    --WZLog("TeachStepGroup4:_getTeachUiData two", tostring(tCell), tostring(shineCell))

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
function TeachStepGroup4:_getTeachElementById( id, teachType, groupId, uiId )
    --WZLog("TeachStepGroup4:_getTeachElementById one", id)
    local element, data = nil, nil
    if uiId == nil then
    uiId = -1
    end

    if id == self.Step_15_3 or id == self.Step_18_3 or id == self.Step_19_3 then
        if id == self.Step_15_3 and (WndBag.m_root ~= nil or (Teach:getTaskState(-15) == 2 and Teach:getTaskState(-151) == 2)) then
        return
        end
        if id == self.Step_18_3 and (WndBag.m_root ~= nil or (Teach:getTaskState(-18) == 2)) then
        return
        end
        if id == self.Step_19_3 and (WndBag.m_root ~= nil or (Teach:getTaskState(-19) == 2)) then
        return
        end
        if WndBottomMenu.m_root ~= nil then
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnPlayer_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_15_4 then

    elseif id == self.Step_15_5 or id == self.Step_15_8 then
        if WndCard.m_root ~= nil then
            if id == self.Step_15_5 and (WndCard.m_tCurWindowOrder == 2 or Teach:getTaskState(-15) == 2) then
            return
            end
            if id == self.Step_15_8 and (WndCard.m_tCurWindowOrder == 1 or Teach:getTaskState(-15) ~= 2 or Teach:getTaskState(-151) == 2) then
            return
            end

            if WndRewardShow.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndCard.m_root, "ConCheckBox_WndCard", WZUIContainer)
            element:setZOrder(500)
        end
    elseif id == self.Step_15_6 then
        if WndCardSynthesis.m_root ~= nil then
            if Teach:getTaskState(-15) == 2 or WndCard.m_tCurWindowOrder ~= 2 then
            return
            end
            local elementParent = GetElementWithoutAssert(WndCardSynthesis.m_root, "freeconCardSynthesissList_WndCardSynthesis", WZUIFreeListContainer)

            if elementParent ~= nil and elementParent:getHead() ~= nil then
                elementParent = elementParent:getHead():getLuaObjectIndex()
                element = GetElementWithoutAssert(elementParent.m_root, "btnsyn_CellCardSynthesisList", WZUIButton)
                element:setZOrder(500)
                if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
                end
                --WZLog("TeachStepGroup4:_getTeachElementById three", tostring(elementParent), tostring(element))
            end
        end
    elseif id == self.Step_15_7 then
        if WndRewardShow.m_root ~= nil then
            if Teach:getTaskState(-15) ~= 2 or Teach:getTaskState(-151) == 2 then
            return
            end
            if (Teach.REWARD_MARK == nil or Teach.REWARD_MARK ~= 3) then
            return
            end
            element = GetElementWithoutAssert(WndRewardShow.m_root, "btnOK_WndMsgConfirmBox", WZUIContainer)
            element:getParentElement():setZOrder(500)
        end
    elseif id == self.Step_15_9 then
        if WndCardBag.m_root ~= nil then
            if WndCard.m_tCurWindowOrder ~= 1 or Teach:getTaskState(-15) ~= 2 or Teach:getTaskState(-151) == 2 or WndItemInfo.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndCardBag.m_root, "contablebag_WndCardBag", WZUITableContainer):getParentElement()
            --element:setZOrder(500)
        end
    elseif id == self.Step_15_10 then
        if WndItemInfo.m_root ~= nil then
            if WndCard.m_tCurWindowOrder ~= 1 or Teach:getTaskState(-15) ~= 2 or Teach:getTaskState(-151) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndItemInfo.m_root, "btn1_WndItemInfo", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_15_11 then
        if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
        data = false
        end
        if WndCard.m_root ~= nil and WndCard.m_tCurWindowOrder == 1 and (Teach:getTaskState(-151) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_16_3 then
        if SceneIsland.m_root ~= nil then
            if Teach:getTaskState(-16) == 2 and Teach:getTaskState(-161) == 2 and Teach:getTaskState(-162) == 2 then
            return
            end
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnPet_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_4 then
        if ScenePet.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil then
            return
            end
            if Teach:getTaskState(-16) == 2 or WndPetTame.m_root ~= nil then
            return
            end
            local element1, element2, element3
            element1 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterTame1_ScenePet", WZUIButton)
            element2 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterTame2_ScenePet", WZUIButton)
            element3 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterTame3_ScenePet", WZUIButton)

            --WZLog("TeachStepGroup4:_getTeachElementById four", tostring(element1), tostring(element2), tostring(element3))

            element = element2
            element:setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_5 then
        --WZLog("id == self.Step_16_5", tostring(WndPetTame.m_root), tostring(Teach:getTaskState(-16)), tostring(Teach.m_isWndTeachTalkExist))
        if WndPetTame.m_root ~= nil and (Teach:getTaskState(-16) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_16_6 then
        do return end
        if WndPetTame.m_root ~= nil then
            element = GetElementWithoutAssert(WndPetTame.m_root, "tbconPet_WndPetTame", WZUITableContainer)
        end
    elseif id == self.Step_16_7 then
        if WndPetTame.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil then
            return
            end
            if Teach:getTaskState(-16) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndPetTame.m_root, "btnTame_WndPetTame", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_8 then
        if WndPetTame.m_root ~= nil and (Teach:getTaskState(-16) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_16_9 then
        if WndPetTame.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-16) ~= 2 then
            return
            end
            element = GetElementWithoutAssert(WndPetTame.m_root, "btnClose_WndPetTame", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_10 then
        if ScenePet.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or WndPetCenter.m_root ~= nil or (Teach:getTaskState(-161) == 2 and Teach:getTaskState(-162) == 2) then
            return
            end
            --WZLog("TeachStepGroup4:_getTeachElementById three", tostring(self.Step_16_10_action))
            if self.Step_16_10_action == nil then
                self.Step_16_10_action = false
                ScenePet:onMoveCell(5)
            end

            local element1, element2, element3
            element1 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterCenter1_ScenePet", WZUIButton)
            element2 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterCenter2_ScenePet", WZUIButton)
            element3 = GetElementWithoutAssert(ScenePet.m_root, "btnEnterCenter3_ScenePet", WZUIButton)

            --WZLog("TeachStepGroup4:_getTeachElementById five", tostring(element1), tostring(element2), tostring(element3))
            if Teach.PET_TAG ~= nil and Teach.PET_TAG == 3 then
                element = element1
            else
                element = element2
            end
            element:getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_11 then
        --WZLog("id == self.Step_16_11",tostring(WndPetCenter.m_root),tostring(Teach:getTaskState(-161)),tostring(Teach.m_isWndTeachTalkExist))
        if WndPetCenter.m_root ~= nil and (Teach:getTaskState(-161) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_16_12 then
        do return end
        if WndPetCenter.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndPetCenter.m_root, "tbconPetList_WndPetCenter", WZUITableContainer):getParentElement()
            element:setZOrder(500)
        end
    elseif id == self.Step_16_13 then
        if WndPetCenter.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-161) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndPetCenter.m_root, "btnPlay_WndPetCenter", WZUIButton)
            element:getParentElement():setZOrder(501)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_14 then
        if WndPetCenter.m_root ~= nil and (Teach:getTaskState(-161) == 2 and Teach:getTaskState(-162) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_16_15 then
        if WndPetCenter.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-161) ~= 2 or Teach:getTaskState(-162) == 2 or WndPetCenter.m_nWndType ~= 0 then
            return
            end
            element = GetElementWithoutAssert(WndPetCenter.m_root, "btnDrill_WndPetCenter", WZUIButton)
            element:getParentElement():setZOrder(501)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_16_16 then
        if WndPetCenter.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-162) == 2 or WndPetCenter.m_nWndType ~= 2 then
            return
            end
            element = GetElementWithoutAssert(WndPetCenter.m_root, "btnStartTrain_WndPetCenter", WZUIButton)
            element:getParentElement():setZOrder(501)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_17_3 then
        if WndBottomMenu.m_root == nil then
        return
        end
        if WndTask.m_root ~= nil then
        return
        end
        --[[
        if WndRightMenu.m_root ~= nil then
            if WndTask.m_root ~= nil then
            return
            end
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
    elseif id == self.Step_17_4 then
        if WndTask.m_root ~= nil then
            if WndTask.m_nCurIndex == 1 then
            return
            end
            element = GetElementWithoutAssert(WndTask.m_root, "checkBoxDaily_WndTask", WZUICheckBox)
            element:getParentElement():getParentElement():setZOrder(500)
        end
    elseif id == self.Step_17_5 then
        if WndTask.m_root ~= nil and WndTask.m_nCurIndex == 1 and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_18_4 then
        if WndBag.m_root ~= nil then
        end
    elseif id == self.Step_18_5 then
        if WndPractice.m_root ~= nil and (Teach:getTaskState(-18) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_18_6 then
        do return end
        if WndPractice.m_root ~= nil then
        element = GetElementWithoutAssert(WndPractice.m_root, "con01_WndPractice", WZUIContainer)
        element:setZOrder(500)
        end
    elseif id == self.Step_18_7 then
        if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-18) == 2 then
        return
        end
        if WndPractice.m_root ~= nil then
            element = GetElementWithoutAssert(WndPractice.m_root, "btnPractice_WndPractice", WZUIButton)
            element:setZOrder(500)
            element:getParentElement():setZOrder(500)
            --element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_18_8 then
        if WndPractice.m_root ~= nil and (Teach:getTaskState(-18) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_19_4 then

    elseif id == self.Step_19_5 then
        if WndStarSoul.m_root ~= nil and (Teach:getTaskState(-19) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_19_6 then
        if WndStarSoul.m_root ~= nil then
            if WndTeachTalk.m_root ~= nil or Teach:getTaskState(-19) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndStarSoul.m_root, "StarSoulSel_single_1", WZUICheckBox)
            element:setZOrder(500)
        end
    elseif id == self.Step_19_7 then
        if WndStarSoul.m_root ~= nil and (Teach:getTaskState(-19) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_23_2 then
        if (GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island and uiId ~= Chat_Channel_Island) or Teach:getTaskState(-23) == 2 then
        return
        end
        if SceneIsland.m_root ~= nil then
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnCommunity_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif teachType ~= nil and teachType == 0 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id ~= Teach.m_isWndTeachTalkExist)) and id > self.INDEX[groupId] and WndTeachOpenModule.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    elseif teachType ~= nil and teachType == 2 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachOpenModuleExist == nil or (Teach.m_isWndTeachOpenModuleExist ~= nil and id ~= Teach.m_isWndTeachOpenModuleExist)) and id > self.INDEX[groupId]  and WndTeachTalk.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    end

    --WZLog("TeachStepGroup4:_getTeachElementById two", id, tostring(element), tostring(data), tostring(GlobalGame.g_nCurrentUIChannelId))
    return element, data
end

--@brief    获取教学闪光元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup4:_getTeachShineElementById( id )
    --WZLog("TeachStepGroup4:_getTeachShineElementById one", id)
    local element = nil

    if id == 0 then
        if WndBattleHud.m_root ~= nil then
            element =  nil
        end
    end

    --WZLog("TeachStepGroup4:_getTeachShineElementById two", id, tostring(element))
    return element
end


--@brief	初始化的新手教学的步骤编号
--@return	新手教学的步骤编号
function TeachStepGroup4:_initTeachStep()
    --WZLog("TeachStepGroup4:_initTeachStep one")

    self.STEP_GROUP_IDS = {[14]=17,[15]=18,[16]=19,[17]=20,[18]=21,[19]=22,[23]=23,[24]=24}

    if self.TOTAL_STEP == nil then
        self.TOTAL_STEP = {}

        for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
            for stepIndex, data in pairs (Teach.DATA.group[groupIndex]) do
                self["Step_"..i.."_"..stepIndex] = data.id
                --WZLog("TeachStepGroup4:_initTeachStep two", "Step_"..i.."_"..stepIndex, data.id)
            end
        end

        group = {}
        ---[[
        table.insert(group, self.Step_14_1)
        table.insert(group, self.Step_14_2)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[14] = group

        group = {}
        ---[[
        table.insert(group, self.Step_15_1)
        table.insert(group, self.Step_15_2)
        --table.insert(group, self.Step_15_3)
        --table.insert(group, self.Step_15_4)
        --table.insert(group, self.Step_15_5)
        --table.insert(group, self.Step_15_6)
        --table.insert(group, self.Step_15_7)
        --table.insert(group, self.Step_15_8)
        --table.insert(group, self.Step_15_9)
        --table.insert(group, self.Step_15_10)
        --table.insert(group, self.Step_15_11)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[15] = group

        group = {}
        ---[[
        table.insert(group, self.Step_16_1)
        table.insert(group, self.Step_16_2)
        table.insert(group, self.Step_16_3)
        table.insert(group, self.Step_16_4)
        table.insert(group, self.Step_16_5)
        table.insert(group, self.Step_16_6)
        table.insert(group, self.Step_16_7)
        table.insert(group, self.Step_16_8)
        table.insert(group, self.Step_16_9)
        table.insert(group, self.Step_16_10)
        table.insert(group, self.Step_16_11)
        table.insert(group, self.Step_16_12)
        table.insert(group, self.Step_16_13)
        table.insert(group, self.Step_16_14)
        table.insert(group, self.Step_16_15)
        table.insert(group, self.Step_16_16)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[16] = group

        group = {}
        ---[[
        table.insert(group, self.Step_17_1)
        table.insert(group, self.Step_17_2)
        --table.insert(group, self.Step_17_3)
        --table.insert(group, self.Step_17_4)
        --table.insert(group, self.Step_17_5)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[17] = group

        group = {}
        ---[[
        table.insert(group, self.Step_18_1)
        table.insert(group, self.Step_18_2)
        --table.insert(group, self.Step_18_3)
        --table.insert(group, self.Step_18_4)
        --table.insert(group, self.Step_18_5)
        --table.insert(group, self.Step_18_6)
        --table.insert(group, self.Step_18_7)
        --table.insert(group, self.Step_18_8)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[18] = group

        group = {}
        ---[[
        table.insert(group, self.Step_19_1)
        table.insert(group, self.Step_19_2)
        --table.insert(group, self.Step_19_3)
        --table.insert(group, self.Step_19_4)
        --table.insert(group, self.Step_19_5)
        --table.insert(group, self.Step_19_6)
        --table.insert(group, self.Step_19_7)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[19] = group

        group = {}
        ---[[
        table.insert(group, self.Step_23_1)
        table.insert(group, self.Step_23_2)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[23] = group

        group = {}
        ---[[
        table.insert(group, self.Step_24_1)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[24] = group

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

    --table.insert(Teach.DATA.saveTask, {["ids"] = -16, ["step"] = 0})
    --ProtocolProcessorTeach:send_TASK_TiroStep(-16, 0)
    --self.INDEX[24] = 0

    --WZLog("TeachStepGroup4:_initTeachStep three", BattleCommon:tableLen(self.TOTAL_STEP), #self.INDEX)
	return self.INDEX
end

