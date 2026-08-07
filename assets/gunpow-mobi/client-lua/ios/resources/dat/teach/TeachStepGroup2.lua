--TeachStepGroup2.lua
--@brief	TeachStepGroup2的模块
--@date		2014/9/25
--@author	莫剑峰
--@note		教学步骤组

TeachStepGroup2 =
{
    GROUP = 2,

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
function TeachStepGroup2:start( nId , tSteps )
	--WZLog("TeachStepGroup2:start one", nId, tostring(tSteps), tostring(self.INDEX), tostring(self.TOTAL_STEP))
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
        --WZLog("TeachStepGroup2:start four", id , nStep)
        --获取下一步的新手教学的步骤编号
        tSteps = self:getTeachStep( id )
        if tSteps ~= nil then
            for index, nStep in pairs (tSteps) do
                --WZLog("TeachStepGroup2:start five", id , nStep , #tSteps, tostring(#self.INDEX))
                --获取需要新手教学的节点和要提示的文本内容
                local tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon = self:_getTeachUiData( nStep, id, nId )
                --WZLog("TeachStepGroup2:start six", tostring(tCell), nStep , tostring(#self.INDEX))
                if nStep and nStep ~= -1 and tCell ~= nil then
                    if teachType == 0 then
                        self:_createTalk( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon)	--创建剧情对话
                    elseif teachType == 1 then
                        self:_createArrow( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )	--创建箭头
                    elseif teachType == 2 then
                        self:_createOpenModule( nStep, name, sDesc, nStep, isIsland)	--创建模块开启框
                    end
                    self.INDEX[id] = nStep
                    --WZLog("TeachStepGroup2:start seven", self.INDEX[id])
                    break
                end
            end
        end
    end
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStepGroup2:getTeachStep( nStep )

    for i, v in pairs (self.INDEX) do
        --WZLog("TeachStepGroup2:getTeachStep two",i,v)
    end

    if self.INDEX[nStep] <= -1 then
        return
    end

    --WZLog("TeachStepGroup2:getTeachStep three",#self.TOTAL_STEP[nStep])
    return self.TOTAL_STEP[nStep]
end

--@brief 结束步骤
function TeachStepGroup2:finishStep(finishStep)
    --WZLog("TeachStepGroup2:finishStep one", finishStep)

    local isStepCanFinish = false
    if self.TOTAL_STEP == nil or BattleCommon:tableLen(self.TOTAL_STEP) == 0 or self.INDEX == nil or self.INDEX == 0 then
        return
    end

    --WZLog("TeachStepGroup2:finishStep three", finishStep)
    for i, v in pairs(self.INDEX) do
        if finishStep == v then
            isStepCanFinish = true
        end
    end

    if isStepCanFinish == false then
        return
    end

    --WZLog("TeachStepGroup2:finishStep four", finishStep)
    for i,group in pairs(self.TOTAL_STEP) do
        if group ~= nil then
            for id,step in pairs(group) do
                --WZLog("TeachStepGroup2:finishStep five", i, id, step)
                if finishStep == step then
                    --WZLog("TeachStepGroup2:finishStep six", step)
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
function TeachStepGroup2:isTeachSkill()
    --WZLog("TeachStepGroup2:isTeachSkill one")
    local isTeach = false

    if self.INDEX == nil or self.INDEX == 0 then
        return isTeach
    end

    for i, v in pairs(self.INDEX) do
        if v ~= nil and v == self.Step_5_3 then
            isTeach = true
        end
    end

    --WZLog("TeachStepGroup2:isTeachSkill two", isTeach)
    return isTeach
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建箭头
--@param	nId：新手教学的编号
function TeachStepGroup2:_createArrow( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )
    if tCell then
        if isIsland == true then
            tCell:setZOrder(500)
        end

        --弹出教学对话框
        self.DIALOG = Teach:showDialog( tCell , tCell , sDesc , nDirection , dialogPt, self.ZORDER )
        self.DIALOG_PARENT = tCell

        local shine = tCell
        if shineCell ~= nil then
            --WZLog("TeachStepGroup2:_createArrow zero",tostring(shineCell))
            shine = shineCell
        end

        --发光效果
        if shineScale == nil then
            --WZLog("TeachStepGroup2:_createArrow one")
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, nil, nil, self.ZORDER)
            self.SHINE_PARENT = shine
        else
            --WZLog("TeachStepGroup2:_createArrow two", shineScale.width, shineScale.height)
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, shineScale.width, shineScale.height, self.ZORDER)
            self.SHINE_PARENT = shine
        end

        table.insert(Teach.TEACH_DIALOGS, {[1]=self.DIALOG, [2]=self.DIALOG_PARENT, [3]=self.ZORDER, [4]=self.INDEX})
        table.insert(Teach.TEACH_SHINES, {[1]=self.SHINE, [2]=self.SHINE_PARENT, [3]=self.ZORDER, [4]=self.INDEX})

    end
end

--@brief	创建剧情对话
--@param	nId：新手教学的编号
function TeachStepGroup2:_createTalk( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon )
    --WZLog("TeachStepGroup2:_createTalk", tostring(WndTeachTalk.m_root), tostring(nId), tostring(name), tostring(tCell), tostring(sDesc), tostring(nDirection), tostring(isIsland), tostring(dir), tostring(dialogPt), tostring(isImgRight))

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
function TeachStepGroup2:_createOpenModule( nId, sDesc, name, nStep, isIsland)
    --WZLog("TeachStepGroup2:_createOpenModule", tostring(WndTeachOpenModule.m_root),  nId, sDesc, name)

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
function TeachStepGroup2:_getTeachUiData( id, groupId ,uiId )
    --WZLog("TeachStepGroup2:_getTeachUiData one",id)
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

	if id == self.Step_6_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"【强化研究院】"
    elseif id == self.Step_6_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"强化研究院开启了强化功能，强化装备可以提升装备属性噢！"
    elseif id == self.Step_6_3 or id == self.Step_7_3 or id == self.Step_8_3 or id == self.Step_12_3 or id == self.Step_13_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【强化研究院】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.1)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.5
        local height = width * 1.0
        shineScale = GlobalMethod:CCSize(width , height)
        isIsland = true
    elseif id == self.Step_6_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择要强化的装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_5 or id == self.Step_6_6 or id == self.Step_6_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击添加强化石"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击强化按钮，进行强化"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.23 , -0.1)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_11 or id == self.Step_7_8 or id == self.Step_8_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到主界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.3 , 0.)
        shinePt = GlobalMethod:ccp(-0.45 , 0.)
        local width = 1.3
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_10 or id == self.Step_7_9 or id == self.Step_8_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"您有可提交的任务"
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
    elseif id == self.Step_6_11 or id == self.Step_7_10 or id == self.Step_8_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处提交任务获得奖励"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0.3)
        local width = 0.7
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)

    elseif id == self.Step_7_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"强化研究院-升星"
    elseif id == self.Step_7_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"强化研究院开启了升星功能，装备升星可以提升装备的属性噢!"
    elseif id == self.Step_7_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击升星选项卡，切换到升星功能"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.2 , 0.0)
        local width = 1
        local height = width * 2.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_7_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择要升星的装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_7_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击添加升星材料"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0.0)
        local width = 1
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_7_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击升星按钮，进行升星"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.23 , 0.0)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)

    elseif id == self.Step_8_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"强化研究院-转移"
    elseif id == self.Step_8_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], 2, param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"强化研究院开启了转移功能，可以将装备的加强属性转移到另一个装备上！很便捷的功能呢。"
    elseif id == self.Step_8_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击转移选项卡，切换到转移功能"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0.0)
        local width = 1
        local height = width * 2.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择被转移的装备"
        nDirection = CellDialog.DIR_RIGHT

        if data == nil then
            data = 1
        end

        if data == 1 then
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.31 , 0.84)
        elseif data == 2 then
        dialogPt = GlobalMethod:ccp(-0.53 , 0.38)
        shinePt = GlobalMethod:ccp(0.0 , 0.84)
        elseif data == 3 then
        dialogPt = GlobalMethod:ccp(-0.23 , 0.38)
        shinePt = GlobalMethod:ccp(0.31 , 0.84)

        elseif data == 4 then
        dialogPt = GlobalMethod:ccp(-0.83 , 0.08)
        shinePt = GlobalMethod:ccp(-0.31 , 0.57)
        elseif data == 5 then
        dialogPt = GlobalMethod:ccp(-0.53 , 0.08)
        shinePt = GlobalMethod:ccp(0.0 , 0.57)
        elseif data == 6 then
        dialogPt = GlobalMethod:ccp(-0.23 , 0.08)
        shinePt = GlobalMethod:ccp(0.31 , 0.57)

        elseif data == 7 then
        dialogPt = GlobalMethod:ccp(-0.83 , -0.18)
        shinePt = GlobalMethod:ccp(-0.31 , 0.3)
        elseif data == 8 then
        dialogPt = GlobalMethod:ccp(-0.53 , -0.18)
        shinePt = GlobalMethod:ccp(0.0 , 0.3)
        elseif data == 9 then
        dialogPt = GlobalMethod:ccp(-0.23 , -0.18)
        shinePt = GlobalMethod:ccp(0.31 , 0.3)
        end
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择要转移的装备"
        nDirection = CellDialog.DIR_RIGHT

        if data == nil then
            data = 2
        end

        if data == 1 then
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.31 , 0.84)
        elseif data == 2 then
        dialogPt = GlobalMethod:ccp(-0.53 , 0.38)
        shinePt = GlobalMethod:ccp(0.0 , 0.84)
        elseif data == 3 then
        dialogPt = GlobalMethod:ccp(-0.23 , 0.38)
        shinePt = GlobalMethod:ccp(0.31 , 0.84)

        elseif data == 4 then
        dialogPt = GlobalMethod:ccp(-0.83 , 0.08)
        shinePt = GlobalMethod:ccp(-0.31 , 0.57)
        elseif data == 5 then
        dialogPt = GlobalMethod:ccp(-0.53 , 0.08)
        shinePt = GlobalMethod:ccp(0.0 , 0.57)
        elseif data == 6 then
        dialogPt = GlobalMethod:ccp(-0.23 , 0.08)
        shinePt = GlobalMethod:ccp(0.31 , 0.57)

        elseif data == 7 then
        dialogPt = GlobalMethod:ccp(-0.83 , -0.18)
        shinePt = GlobalMethod:ccp(-0.31 , 0.3)
        elseif data == 8 then
        dialogPt = GlobalMethod:ccp(-0.53 , -0.18)
        shinePt = GlobalMethod:ccp(0.0 , 0.3)
        elseif data == 9 then
        dialogPt = GlobalMethod:ccp(-0.23 , -0.18)
        shinePt = GlobalMethod:ccp(0.31 , 0.3)
        end
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击转移按钮，进行转移"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.23 , 0.0)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_12_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"强化研究院-镶嵌"
    elseif id == self.Step_12_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"前往研究院就可以镶嵌宝石了，在装备上镶嵌宝石，可以将宝石的属性附加到装备上噢！"
    elseif id == self.Step_12_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入装备镶嵌"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.1 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 1
        local height = width * 2.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_12_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择镶嵌的装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_12_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处添加宝石"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_12_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确认镶嵌宝石"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.23 , -0.15)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_12_8 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"你已经成功将宝石镶嵌到装备上，镶嵌的宝石属性会附加到装备属性上。宝石有高低级之分，越高级宝石加的属性越多噢！"
    elseif id == self.Step_12_9 or id == self.Step_13_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处关闭强化研究院"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.3 , 0.)
        shinePt = GlobalMethod:ccp(-0.45 , 0.)
        local width = 1.3
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_13_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"强化研究院-重铸"
    elseif id == self.Step_13_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"强化研究院开启了重铸科技，重铸武器可以让武器附加技能效果噢！"
    elseif id == self.Step_13_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入装备重铸"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.2 , 0.0)
        local width = 1
        local height = width * 2.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_13_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入选择要重铸的武器"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_13_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处添加淬焰"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_13_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处确定重铸装备"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.23 , -0.15)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_13_8 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"重铸成功啦！现在武器已经成功激活了一个附加技能，继续重铸可以替换当前技能"
    elseif id == self.Step_8_11 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到主界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.5 , 0.0)
        shinePt = GlobalMethod:ccp(-0.45 , 0.0)
        local width = 1.4
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_12 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"已经拿到奖励了吧，先穿上组织给你的装备吧，好的装备可以让你战力瞬间暴涨噢！"
    elseif id == self.Step_8_13 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_14 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择要穿戴的装备"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.6 , 0.3)
        shinePt = GlobalMethod:ccp(0.0 , -0.12)
        local width = 0.3
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_15 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击装备按钮，穿戴装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.4 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_8_16 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到主界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.15 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 1.0
        local height = width
        shineScale = GlobalMethod:CCSize(width , height)
    end

    --WZLog("TeachStepGroup2:_getTeachUiData two", tostring(tCell), tostring(shineCell))

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
function TeachStepGroup2:_getTeachElementById( id, teachType, groupId, uiId )
    --WZLog("TeachStepGroup2:_getTeachElementById one", id, teachType, GlobalGame.g_nCurrentUIChannelId, tostring(uiId))
    local element, data = nil, nil
    if uiId == nil then
        uiId = -1
    end

    if id == self.Step_6_10 or id == self.Step_7_9 or id == self.Step_8_9 then
        if WndBottomMenu.m_root == nil then
        return
        end
        if WndTask.m_root ~= nil then
        return
        end
        if id == self.Step_6_10 and Teach:getTaskState(10004004) ~= 1 then
        return
        end

        if id == self.Step_7_9 and (Teach:getTaskState(Teach.TASK_ID_UPSTAR) ~= 1 ) then
        return
        end

        if id == self.Step_8_9 and (Teach:getTaskState(13015099) ~= 1 ) then
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
    elseif id == self.Step_6_11 or id == self.Step_7_10 or id == self.Step_8_10 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_CHannel_Task then
        return
        end
        if id == self.Step_6_11 and Teach:getTaskState(10004004) ~= 1 then
        return
        end
        if id == self.Step_7_10 and (Teach:getTaskState(Teach.TASK_ID_UPSTAR) ~= 1) then
        return
        end

        if id == self.Step_8_10 and (Teach:getTaskState(13015099) ~= 1) then
        return
        end
        if WndTask.m_root ~= nil and WndTask.m_tRewardsLuaObj ~= nil and WndTask.m_nCurIndex == 0 then
            element = GetElementWithoutAssert(WndTask.m_tRewardsLuaObj.m_root, "btnTask_CellTaskRewards", WZUIButton)
        end
    elseif id == self.Step_6_3 or id == self.Step_7_3 or id == self.Step_8_3 or id == self.Step_12_3 or id == self.Step_13_3 then

        if WndStrengthen.m_root ~= nil then
            return
        end
        if id == self.Step_6_3 and (Teach:getTaskState(10004004) >= 1 or Teach:getTaskState(-6) == 2) then
        return
        end
        if id == self.Step_7_3 and (Teach:getTaskState(Teach.TASK_ID_UPSTAR) >= 1 or Teach:getTaskState(-7) == 2) then
        return
        end
        if id == self.Step_8_3 and (Teach:getTaskState(13015099) >= 1 or Teach:getTaskState(-8) == 2) then
        return
        end
        if id == self.Step_12_3 and (Teach:getTaskState(Teach.TASK_ID_INLAY) >= 1 or Teach:getTaskState(-12) == 2) then
        return
        end
        if id == self.Step_13_3 and (Teach:getTaskState(13036225) >= 1 or Teach:getTaskState(-13) == 2) then
        return
        end
        if SceneIsland.m_root ~= nil then
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnStrengthen_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_6_4 or id == self.Step_7_5 or id == self.Step_8_5 or id == self.Step_8_6 or id == self.Step_12_5 or id == self.Step_13_5 then

        local w1, w2, wh, whi, wl, wli
        if (id == self.Step_8_5 or id == self.Step_8_6) and WndStrengthen.m_tTransferLuaObj ~= nil and WndStrengthen.m_nCurIndex == 5 then

            for id,item in pairs (WndStrengthen.m_playItemWndLuaObj.m_tEquipTable) do
                if item.m_tItem ~= nil then
                    --WZLog("self.Step_8_5 three-0", id, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))

                    if wh == nil or ((item.m_tItem.maintype == 0 or item.m_tItem.maintype == 1) and item.m_tItem.subtype == 1 and item.m_tItem.extraInfo.strongLevel > wh.m_tItem.extraInfo.strongLevel) then
                        wh = item
                        whi = id
                        item = wh
                        --WZLog("self.Step_8_5 three-1", id, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))
                    end
                end
            end

            for id,item in pairs (WndStrengthen.m_playItemWndLuaObj.m_tEquipTable) do
                if item.m_tItem ~= nil then
                    --WZLog("self.Step_8_5 three-2", id, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))
                    if wh ~= nil and ((item.m_tItem.maintype == 0 or item.m_tItem.maintype == 1) and item.m_tItem.subtype == 1 and item.m_tItem.extraInfo.strongLevel < wh.m_tItem.extraInfo.strongLevel) then
                        if wl == nil or item.m_tItem.extraInfo.strongLevel < wl.m_tItem.extraInfo.strongLevel then
                            wl = item
                            wli = id
                            item = wl
                            --WZLog("self.Step_8_5 three-3", id, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))
                        end
                    end


                end
            end

            local item = WndStrengthen.m_tTransferLuaObj.m_weapon1LuaObj
            if item ~= nil and item.m_tItem ~= nil then
                w1 = item
                --WZLog("self.Step_8_5 four", 0, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))
            end

            item = WndStrengthen.m_tTransferLuaObj.m_weapon2LuaObj
            if item ~= nil and item.m_tItem ~= nil then
                w2 = item
                --WZLog("self.Step_8_5 five", 0, tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel), tostring(item.m_tItem.extraInfo.starLevel), tostring(item.m_tItem.basicInfo.name))
            end


            local isW1Nil, isW2Nil = false, false
            if WndStrengthen.m_tTransferLuaObj.m_root ~= nil and GetElement(WndStrengthen.m_tTransferLuaObj.m_root, "txtWeapon1_WndTransferStrengthen", WZUILabelTTF):isVisible() == true then
                isW1Nil = nil
            end

            if WndStrengthen.m_tTransferLuaObj.m_root ~= nil and GetElement(WndStrengthen.m_tTransferLuaObj.m_root, "txtWeapon2_WndTransferStrengthen", WZUILabelTTF):isVisible() == true then
                isW2Nil = nil
            end

            if id == self.Step_8_5 then
                --WZLog("self.Step_8_5 six", tostring(w1), tostring(isW1Nil), tostring(isW2Nil), tostring(w2), tostring(wh), tostring(whi), tostring(wl), tostring(wli))

                local isReturn = false

                if (w1 == nil or isW1Nil == nil) and (w2 == nil or isW2Nil == nil) then
                    data = whi or 1
                elseif (w1 ~= nil and isW1Nil ~= nil) and (w2 ~= nil and isW2Nil ~= nil) then
                    isReturn = true
                elseif (w1 ~= nil and isW1Nil ~= nil) and (w2 == nil or isW2Nil == nil) then
                    for id,item in pairs (WndStrengthen.m_playItemWndLuaObj.m_tEquipTable) do
                        if item.m_tItem ~= nil then
                            if (item.m_tItem.maintype == w1.m_tItem.maintype or ((w1.m_tItem.maintype == 0 or w1.m_tItem.maintype == 1) and (item.m_tItem.maintype == 0 or item.m_tItem.maintype == 1))) and item.m_tItem.subtype == w1.m_tItem.subtype and item.m_tItem.extraInfo.strongLevel < w1.m_tItem.extraInfo.strongLevel then
                                isReturn = true
                                break
                            end
                        end
                    end
                elseif (w1 == nil or isW1Nil == nil) and (w2 ~= nil and isW2Nil ~= nil) then
                    --WZLog("self.Step_8_5 ten-0", tostring(w2.m_tItem.basicInfo.name), tostring(w2.m_tItem.maintype), tostring(w2.m_tItem.subtype), tostring(w2.m_tItem.extraInfo.strongLevel))
                    for id,item in pairs (WndStrengthen.m_playItemWndLuaObj.m_tEquipTable) do
                        if item.m_tItem ~= nil then
                            if (item.m_tItem.maintype == w2.m_tItem.maintype or ((w2.m_tItem.maintype == 0 or w2.m_tItem.maintype == 1) and (item.m_tItem.maintype == 0 or item.m_tItem.maintype == 1))) and item.m_tItem.subtype == w2.m_tItem.subtype and item.m_tItem.extraInfo.strongLevel > w2.m_tItem.extraInfo.strongLevel then
                                data = id
                                --WZLog("self.Step_8_5 ten-1", tostring(item.m_tItem.basicInfo.name), tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel))
                                break
                            end
                        end
                    end
                    if data == nil then
                        isReturn = true
                    end
                end

                if isReturn == true then
                    return
                else 
                    data = data or whi or 1
                end
            elseif id == self.Step_8_6 then
                --WZLog("self.Step_8_5 seven", tostring(w1), tostring(isW1Nil), tostring(isW2Nil), tostring(w2), tostring(wh), tostring(whi), tostring(wl), tostring(wli))

                local isReturn = false

                if (w1 == nil or isW1Nil == nil) and (w2 == nil or isW2Nil == nil) then
                    isReturn = true
                elseif (w1 ~= nil and isW1Nil ~= nil) and (w2 ~= nil and isW2Nil ~= nil) then
                    isReturn = true
                elseif (w1 ~= nil and isW1Nil ~= nil) and (w2 == nil or isW2Nil == nil) then
                    --WZLog("self.Step_8_5 eight", tostring(w1.m_tItem.basicInfo.name), tostring(w1.m_tItem.maintype), tostring(w1.m_tItem.subtype), tostring(w1.m_tItem.extraInfo.strongLevel))
                    for id,item in pairs (WndStrengthen.m_playItemWndLuaObj.m_tEquipTable) do
                        if item.m_tItem ~= nil then
                            if (item.m_tItem.maintype == w1.m_tItem.maintype or ((w1.m_tItem.maintype == 0 or w1.m_tItem.maintype == 1) and (item.m_tItem.maintype == 0 or item.m_tItem.maintype == 1))) and item.m_tItem.subtype == w1.m_tItem.subtype and item.m_tItem.extraInfo.strongLevel < w1.m_tItem.extraInfo.strongLevel then
                                data = id
                                --WZLog("self.Step_8_5 nine", tostring(item.m_tItem.basicInfo.name), tostring(item.m_tItem.maintype), tostring(item.m_tItem.subtype), tostring(item.m_tItem.extraInfo.strongLevel))
                                break
                            end
                        end
                    end
                    if data == nil then
                        isReturn = true
                    end
                elseif (w1 == nil or isW1Nil == nil) and (w2 ~= nil and isW2Nil ~= nil) then
                    isReturn = true
                end

                if isReturn == true then
                    return
                else 
                    data = data
                end
            end
        end

        if id == self.Step_6_4 and (WndStrengthen.m_nCurIndex ~= 1 or WndStrengthen.m_tIntensifyLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj:isItemNil() ~= true or Teach:getTaskState(-6) == 2)  then
            return element, data
        elseif id == self.Step_7_5 and (WndStrengthen.m_nCurIndex ~= 2 or WndStrengthen.m_tImproveLuaObj == nil or WndStrengthen.m_tImproveLuaObj.m_weaponLuaObj == nil or (WndStrengthen.m_tImproveLuaObj.m_weaponLuaObj:isItemNil() ~= true and GetElement(WndStrengthen.m_tImproveLuaObj.m_root, "imgEquipAdd_WndImproveStrengthen", WZUIImage):isVisible() == false) or Teach:getTaskState(-7) == 2) then
            return element, data
        elseif id == self.Step_8_5 and (WndStrengthen.m_nCurIndex ~= 5 or WndStrengthen.m_tTransferLuaObj == nil or Teach:getTaskState(-8) == 2) then
            return element, data
        elseif id == self.Step_8_6 and (WndStrengthen.m_nCurIndex ~= 5 or WndStrengthen.m_tTransferLuaObj == nil or Teach:getTaskState(-8) == 2) then
            return element, data
        elseif id == self.Step_12_5 and (WndStrengthen.m_nCurIndex ~= 3 or WndStrengthen.m_tGemMountingLuaObj == nil or WndStrengthen.m_tGemMountingLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tGemMountingLuaObj.m_weaponLuaObj:isItemNil() ~= true or Teach:getTaskState(-12) == 2 ) then
            return element, data
        elseif id == self.Step_13_5 and (WndStrengthen.m_nCurIndex ~= 4 or WndStrengthen.m_tReforgeLuaObj == nil or WndStrengthen.m_tReforgeLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tReforgeLuaObj.m_weaponLuaObj:isItemNil() ~= true or Teach:getTaskState(-13) == 2 ) then
            return element, data
        end
    elseif id == self.Step_6_5 or id == self.Step_6_6 or id == self.Step_6_7 or id == self.Step_12_6 or id == self.Step_13_6 then

        if WndStrengthen.m_tIntensifyLuaObj ~= nil then
            --WZLog("self.Step_6_5 ", tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone1LuaObj:isItemNil()), tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone2LuaObj:isItemNil()),tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone3LuaObj:isItemNil()))
        end
        if (id == self.Step_6_5 or id == self.Step_6_6 or id == self.Step_6_7) and (WndStrengthen.m_nCurIndex ~= 1 or WndStrengthen.m_tIntensifyLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj:isItemNil() == true or (WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone1LuaObj:isItemNil() ~= true and WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone2LuaObj:isItemNil() ~= true and WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone3LuaObj:isItemNil() ~= true) or Teach:getTaskState(-6) == 2) then
            return element, data
        elseif id == self.Step_12_6 and (WndStrengthen.m_nCurIndex ~= 3 or WndStrengthen.m_tGemMountingLuaObj == nil or WndStrengthen.m_tGemMountingLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tGemMountingLuaObj.m_weaponLuaObj:isItemNil() == true or GetElementWithoutAssert(WndStrengthen.m_tGemMountingLuaObj.m_root, "btnGemMounting_WndGemMountingStrengthen", WZUIButton):getTouchEnable() == true or Teach:getTaskState(-12) == 2) then
            return element, data
        end

    elseif id == self.Step_6_8 then

        if WndStrengthen.m_tIntensifyLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone1LuaObj:isItemNil() == true or WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone2LuaObj:isItemNil() == true or WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone3LuaObj:isItemNil() == true or Teach:getTaskState(-6) == 2 then
            return
        end
        if WndStrengthen.m_root ~= nil and WndStrengthen.m_tIntensifyLuaObj ~= nil and WndStrengthen.m_tIntensifyLuaObj.m_root ~= nil then
            WndStrengthen.m_root:getChildElement("conRight_WndStrengthen"):setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_tIntensifyLuaObj.m_root, "btnIntensify_WndIntensifyStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_6_11 or id == self.Step_7_8 or id == self.Step_8_8 or id == self.Step_12_9 or id == self.Step_13_9 then
        if id == self.Step_6_11 and (WndStrengthen.m_nCurIndex ~= 1 or Teach:getTaskState(-6) ~= 2) then
            return element, data
        elseif id == self.Step_7_8 and (WndStrengthen.m_nCurIndex ~= 2 or Teach:getTaskState(-7) ~= 2) then
            return element, data
        elseif id == self.Step_8_8 and (WndStrengthen.m_nCurIndex ~= 5 or Teach:getTaskState(-8) ~= 2) then
            return element, data
        elseif id == self.Step_12_9 and (WndStrengthen.m_nCurIndex ~= 3 or Teach:getTaskState(-12) ~= 2) then
            return element, data
        elseif id == self.Step_13_9 and (WndStrengthen.m_nCurIndex ~= 4 or Teach:getTaskState(-13) ~= 2) then
            return element, data
        end
        if WndStrengthen.m_root ~= nil then
            element = GetElementWithoutAssert(WndStrengthen.m_root, "btnClose_WndStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_7_4 then
        if WndStrengthen.m_root ~= nil then

            if WndStrengthen.m_nCurIndex == 2 or Teach:getTaskState(-7) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkGroup_WndStrengthen", WZUICheckBoxGroup)
            element:setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkbox2_WndStrengthen", WZUICheckBox)
            element:setZOrder(500)
        end
    elseif id == self.Step_7_6 then
        if WndStrengthen.m_root ~= nil and WndStrengthen.m_tImproveLuaObj ~= nil and WndStrengthen.m_tImproveLuaObj.m_root ~= nil then

        if WndStrengthen.m_nCurIndex ~= 2 or WndStrengthen.m_tImproveLuaObj.m_weaponLuaObj == nil or (WndStrengthen.m_tImproveLuaObj.m_weaponLuaObj:isItemNil() == true and GetElement(WndStrengthen.m_tImproveLuaObj.m_root, "imgEquipAdd_WndImproveStrengthen", WZUIImage):isVisible() == true) or WndStrengthen.m_tImproveLuaObj.m_bIsExpOk == true or Teach:getTaskState(-7) == 2 then
        return
        end
            WndStrengthen.m_root:getChildElement("conRight_WndStrengthen"):setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_tImproveLuaObj.m_root, "btnOnekey_WndImproveStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_7_7 then
        if Teach:getTaskState(-7) == 2 then
        return
        end

        if WndStrengthen.m_root ~= nil and WndStrengthen.m_tImproveLuaObj ~= nil and WndStrengthen.m_tImproveLuaObj.m_root ~= nil then
            WndStrengthen.m_root:getChildElement("conRight_WndStrengthen"):setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_tImproveLuaObj.m_root, "btnImprove_WndImproveStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_8_4 then
        if WndStrengthen.m_nCurIndex == 5 or Teach:getTaskState(-8) == 2 then
        return
        end
        if WndStrengthen.m_root ~= nil then
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkGroup_WndStrengthen", WZUICheckBoxGroup)
            element:setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkbox5_WndStrengthen", WZUICheckBox)
        end
    elseif id == self.Step_8_7 then
        if WndStrengthen.m_root ~= nil and WndStrengthen.m_tTransferLuaObj ~= nil and WndStrengthen.m_tTransferLuaObj.m_root ~= nil then
            WndStrengthen.m_root:getChildElement("conRight_WndStrengthen"):setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_tTransferLuaObj.m_root, "btnTransfer_WndTransferStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_12_4 then
        if WndStrengthen.m_root ~= nil then

            if WndStrengthen.m_nCurIndex == 3 or Teach:getTaskState(-12) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkGroup_WndStrengthen", WZUICheckBoxGroup)
            element:setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkbox3_WndStrengthen", WZUICheckBox)
        end
    elseif id == self.Step_12_7 then
        if WndStrengthen.m_root ~= nil and WndStrengthen.m_tGemMountingLuaObj ~= nil and WndStrengthen.m_tGemMountingLuaObj.m_root ~= nil then

            if WndStrengthen.m_nCurIndex ~= 3 or Teach:getTaskState(-12) == 2 then
            return
            end

            WndStrengthen.m_root:getChildElement("conRight_WndStrengthen"):setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_tGemMountingLuaObj.m_root, "btnGemMounting_WndGemMountingStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_12_8 then
        if WndStrengthen.m_nCurIndex ~= 3 or Teach:getTaskState(-12) ~= 2 or (Teach.m_isWndTeachTalkExist ~= nil and id == Teach.m_isWndTeachTalkExist) then
            data =  false
        else
            data = nil
        end

    elseif id == self.Step_13_4 then
        if WndStrengthen.m_root ~= nil then

            if WndStrengthen.m_nCurIndex == 4 or Teach:getTaskState(-13) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkGroup_WndStrengthen", WZUICheckBoxGroup)
            element:setZOrder(500)
            element = GetElementWithoutAssert(WndStrengthen.m_root, "checkbox4_WndStrengthen", WZUICheckBox)
        end
    elseif id == self.Step_13_7 then

    elseif id == self.Step_13_8 then
        if WndStrengthen.m_nCurIndex ~= 4 or Teach:getTaskState(-13) ~= 2 or (Teach.m_isWndTeachTalkExist ~= nil and id == Teach.m_isWndTeachTalkExist) then
            data =  false
        else
            data = nil
        end
    elseif id == self.Step_8_11 then
        if WndTask.m_root ~= nil then

            if Teach:getTaskState(13015099) ~= 2 then
            return
            end
            element = GetElementWithoutAssert(WndTask.m_root, "btnClose_WndTask", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_8_12 then
        WZLog("id == self.Step_8_12", Teach:getTaskState(13015099), Teach:getTaskState(-81))
        if SceneIsland.m_root ~= nil and (Teach:getTaskState(13015099) == 2 and Teach:getTaskState(-81) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_8_13 then
        if WndBottomMenu.m_root ~= nil then

            if WndBag.m_root ~= nil then
            return
            end
            if Teach:getTaskState(13015099) ~= 2 or Teach:getTaskState(-81) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnPlayer_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_8_14 then
        if WndEquip.m_nBagIndex ~= 1 or Teach:getTaskState(13015099) ~= 2 or Teach:getTaskState(-81) == 2 then
        return
        end
        if WndItemInfo.m_root ~= nil and GetElementWithoutAssert(WndItemInfo.m_root, "btn2_WndItemInfo", WZUIButton) ~= nil then
        return
        end
        if WndEquip.m_root ~= nil and #CacheCenter:getWeaponList() >= 2 then
        element = GetElementWithoutAssert(WndEquip.m_root, "conGoods_WndEquip", WZUIContainer)
        end
    elseif id == self.Step_8_15 then
        if WndItemInfo.m_root ~= nil then
            if Teach:getTaskState(13015099) ~= 2 or Teach:getTaskState(-81) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndItemInfo.m_root, "btn2_WndItemInfo", WZUIButton)
        end
    elseif id == self.Step_8_16 then
        if WndBag.m_root ~= nil then
            if  Teach:getTaskState(13015099) ~= 2 or Teach:getTaskState(-81) ~= 2 then
            return
            end
            element = GetElementWithoutAssert(WndBag.m_root, "btnClose_WndBag", WZUIButton)
            self.INDEX[8] = -2
            ProtocolProcessorTeach:send_TASK_TiroStep(8, -2)
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

    --WZLog("TeachStepGroup2:_getTeachElementById two", id, tostring(self.INDEX[groupId]), tostring(element), tostring(data))
    return element, data
end

--@brief    获取教学闪光元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup2:_getTeachShineElementById( id )
    --WZLog("TeachStepGroup2:_getTeachShineElementById one", id)
    local element = nil

    if id == 0 then
        if WndBattleHud.m_root ~= nil then
            element =  nil
        end
    end

    --WZLog("TeachStepGroup2:_getTeachShineElementById two", id, tostring(element))
    return element
end


--@brief	初始化的新手教学的步骤编号
--@return	新手教学的步骤编号
function TeachStepGroup2:_initTeachStep()
    --WZLog("TeachStepGroup2:_initTeachStep one")

    self.STEP_GROUP_IDS = {[7]=9,[8]=11,[12]=15,[13]=16}

    if self.TOTAL_STEP == nil then
        self.TOTAL_STEP = {}

        for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
            for stepIndex, data in pairs (Teach.DATA.group[groupIndex]) do
                self["Step_"..i.."_"..stepIndex] = data.id
                --WZLog("TeachStepGroup2:_initTeachStep two", "Step_"..i.."_"..stepIndex, data.id)
            end
        end

        group = {}
        ---[[
        table.insert(group, self.Step_7_1)
        table.insert(group, self.Step_7_2)
        table.insert(group, self.Step_7_3)
        table.insert(group, self.Step_7_4)
        table.insert(group, self.Step_7_5)
        table.insert(group, self.Step_7_6)
        table.insert(group, self.Step_7_7)
        table.insert(group, self.Step_7_8)
        table.insert(group, self.Step_7_9)
        table.insert(group, self.Step_7_10)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[7] = group

        group = {}
        --[[
        table.insert(group, self.Step_8_1)
        table.insert(group, self.Step_8_2)
        table.insert(group, self.Step_8_3)
        table.insert(group, self.Step_8_4)
        table.insert(group, self.Step_8_5)
        table.insert(group, self.Step_8_6)
        table.insert(group, self.Step_8_7)
        table.insert(group, self.Step_8_8)
        table.insert(group, self.Step_8_9)
        table.insert(group, self.Step_8_10)
        table.insert(group, self.Step_8_11)
        table.insert(group, self.Step_8_12)
        table.insert(group, self.Step_8_13)
        table.insert(group, self.Step_8_14)
        table.insert(group, self.Step_8_15)
        table.insert(group, self.Step_8_16)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[8] = group

        group = {}
        ---[[
        table.insert(group, self.Step_12_1)
        table.insert(group, self.Step_12_2)
        table.insert(group, self.Step_12_3)
        table.insert(group, self.Step_12_4)
        table.insert(group, self.Step_12_5)
        table.insert(group, self.Step_12_6)
        table.insert(group, self.Step_12_7)
        table.insert(group, self.Step_12_8)
        table.insert(group, self.Step_12_9)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[12] = group

        group = {}
        --[[
        table.insert(group, self.Step_13_1)
        table.insert(group, self.Step_13_2)
        table.insert(group, self.Step_13_3)
        table.insert(group, self.Step_13_4)
        table.insert(group, self.Step_13_5)
        table.insert(group, self.Step_13_6)
        table.insert(group, self.Step_13_7)
        table.insert(group, self.Step_13_8)
        table.insert(group, self.Step_13_9)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[13] = group



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

    --self.INDEX[7] = 0

    --WZLog("TeachStepGroup2:_initTeachStep three", BattleCommon:tableLen(self.TOTAL_STEP), #self.INDEX)
	return self.INDEX
end

