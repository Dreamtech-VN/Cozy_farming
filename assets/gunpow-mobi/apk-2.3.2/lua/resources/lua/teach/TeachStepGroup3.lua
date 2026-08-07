--TeachStepGroup3.lua
--@brief	TeachStepGroup3的模块
--@date		2014/9/25
--@author	莫剑峰
--@note		教学步骤组

TeachStepGroup3 =
{
    GROUP = 3,

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
function TeachStepGroup3:start( nId , tSteps )
	--WZLog("TeachStepGroup3:start one", nId, tostring(tSteps), tostring(self.INDEX), tostring(self.TOTAL_STEP))
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
        --WZLog("TeachStepGroup3:start four", id , nStep)
        --获取下一步的新手教学的步骤编号
        tSteps = self:getTeachStep( id )
        if tSteps ~= nil then
            for index, nStep in pairs (tSteps) do
                --WZLog("TeachStepGroup3:start five", id , nStep , #tSteps, tostring(#self.INDEX))
                --获取需要新手教学的节点和要提示的文本内容
                local tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon = self:_getTeachUiData( nStep, id, nId )
                --WZLog("TeachStepGroup3:start six", tostring(tCell), nStep , tostring(#self.INDEX))
                if nStep and nStep ~= -1 and tCell ~= nil then
                    if teachType == 0 then
                        self:_createTalk( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon)	--创建剧情对话
                    elseif teachType == 1 then
                        self:_createArrow( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )	--创建箭头
                    elseif teachType == 2 then
                        self:_createOpenModule( nStep, name, sDesc, nStep, isIsland)	--创建模块开启框
                    end
                    self.INDEX[id] = nStep
                    --WZLog("TeachStepGroup3:start seven", self.INDEX[id])
                    break
                end
            end
        end
    end
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStepGroup3:getTeachStep( nStep )

    for i, v in pairs (self.INDEX) do
        --WZLog("TeachStepGroup3:getTeachStep two",i,v)
    end

    if self.INDEX[nStep] <= -1 then
        return
    end

    --WZLog("TeachStepGroup3:getTeachStep three",#self.TOTAL_STEP[nStep])
    return self.TOTAL_STEP[nStep]
end

--@brief 结束步骤
function TeachStepGroup3:finishStep(finishStep)
    --WZLog("TeachStepGroup3:finishStep one", finishStep)

    local isStepCanFinish = false
    if self.TOTAL_STEP == nil or BattleCommon:tableLen(self.TOTAL_STEP) == 0 or self.INDEX == nil or self.INDEX == 0 then
        return
    end

    --WZLog("TeachStepGroup3:finishStep three", finishStep)
    for i, v in pairs(self.INDEX) do
        if finishStep == v then
            isStepCanFinish = true
        end
    end

    if isStepCanFinish == false then
        return
    end

    --WZLog("TeachStepGroup3:finishStep four", finishStep)
    for i,group in pairs(self.TOTAL_STEP) do
        if group ~= nil then
            for id,step in pairs(group) do
                --WZLog("TeachStepGroup3:finishStep five", i, id, step)
                if finishStep == step then
                    --WZLog("TeachStepGroup3:finishStep six", step)
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
function TeachStepGroup3:isTeachSkill()
    --WZLog("TeachStepGroup3:isTeachSkill one")
    local isTeach = false

    if self.INDEX == nil or self.INDEX == 0 then
        return isTeach
    end

    for i, v in pairs(self.INDEX) do
        if v ~= nil and v == self.Step_5_3 then
            isTeach = true
        end
    end

    --WZLog("TeachStepGroup3:isTeachSkill two", isTeach)
    return isTeach
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建箭头
--@param	nId：新手教学的编号
function TeachStepGroup3:_createArrow( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )
    if tCell then
        if isIsland == true then
            tCell:setZOrder(500)
        end

        --弹出教学对话框
        self.DIALOG = Teach:showDialog( tCell , tCell , sDesc , nDirection , dialogPt, self.ZORDER )
        self.DIALOG_PARENT = tCell

        local shine = tCell
        if shineCell ~= nil then
            --WZLog("TeachStepGroup3:_createArrow zero",tostring(shineCell))
            shine = shineCell
        end

        --发光效果
        if shineScale == nil then
            --WZLog("TeachStepGroup3:_createArrow one")
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, nil, nil, self.ZORDER)
            self.SHINE_PARENT = shine
        else
            --WZLog("TeachStepGroup3:_createArrow two", shineScale.width, shineScale.height)
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, shineScale.width, shineScale.height, self.ZORDER)
            self.SHINE_PARENT = shine
        end

        table.insert(Teach.TEACH_DIALOGS, {[1]=self.DIALOG, [2]=self.DIALOG_PARENT, [3]=self.ZORDER, [4]=self.INDEX})
        table.insert(Teach.TEACH_SHINES, {[1]=self.SHINE, [2]=self.SHINE_PARENT, [3]=self.ZORDER, [4]=self.INDEX})

    end
end

--@brief	创建剧情对话
--@param	nId：新手教学的编号
function TeachStepGroup3:_createTalk( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon )
    --WZLog("TeachStepGroup3:_createTalk", tostring(WndTeachTalk.m_root), tostring(Teach.m_isWndTeachTalkExist), tostring(nStep), tostring(name), tostring(tCell), tostring(sDesc), tostring(nDirection), tostring(isIsland), tostring(dir), tostring(dialogPt), tostring(isImgRight))

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
function TeachStepGroup3:_createOpenModule( nId, sDesc, name, nStep, isIsland)
    --WZLog("TeachStepGroup3:_createOpenModule", tostring(WndTeachOpenModule.m_root),  nId, sDesc, name)

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
function TeachStepGroup3:_getTeachUiData( id, groupId ,uiId )
    --WZLog("TeachStepGroup3:_getTeachUiData one",id, Teach.TASK_TAG)
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

	if id == self.Step_9_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
		sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"游戏大厅"
    elseif id == self.Step_9_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"游戏大厅开放了！在这里你可以与其他玩家进行合作或者竞赛噢！而且有各种比赛模式呢，快去看看吧！"
    elseif id == self.Step_9_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处进入【游戏大厅】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.1)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.1
        local height = width * 1.0
        shineScale = GlobalMethod:CCSize(width , height)
        isIsland = true
    elseif id == self.Step_9_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处【创建房间】"
        nDirection = CellDialog.DIR_LEFT
        shinePt = GlobalMethod:ccp(0 , -50)
    elseif id == self.Step_9_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处继续【创建房间】"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , -0.1)
        local width = 1.4
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_9_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处完成【创建房间】"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , -0.1)
        local width = 1.4
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_9_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处开始战斗"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.0 , -0.3)
        shinePt = GlobalMethod:ccp(13 , 0)
        local width = 1.0
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_10_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"好友"
    elseif id == self.Step_10_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"好友功能开启了，与好友一起切磋，组队，下副本，你不是一个人在战斗噢！"
    elseif id == self.Step_10_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开好友界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_10_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处查看在线玩家"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.1)
        local width = 0.7
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_10_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开查看玩家信息"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.6 , 0.35)
        dialogPt.m = 0.05
        shinePt = GlobalMethod:ccp(0.0 , 0.85)
        local width = 0.2
        local height = width * 2.0
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_10_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处添加好友"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(0.5 , 0)
        local width = 1.0
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_10_7 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"好啦！你已经成功添加一名好友了噢！如果你有想结交的朋友，也可以在玩家列表中搜索玩家ID，找到你想要结交的好友！"
    elseif id == self.Step_11_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"副本-组队副本"
    elseif id == self.Step_11_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"组队副本开启了噢！在这里你可以进行单挑，也可以和其他玩家一起组队下副本，副本有3个难度噢，难度越高奖励越丰厚呢！"
    elseif id == self.Step_11_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开副本界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.0 , -0.4)
        shinePt = GlobalMethod:ccp(-0.2 , 0)
        local width = 1.5
        local height = width * 0.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开组队副本"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.15 , 0.15)
        dialogPt.m = 0.08
        shinePt = GlobalMethod:ccp(0.75 , -0.5)
        local width = 0.3
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择副本"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.25)
        shinePt = GlobalMethod:ccp(0.0 , 0.25)
        local width = 0.5
        local height = width * 0.66
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处挑战副本"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.1 , 0.0)
        shinePt = GlobalMethod:ccp(-0.4 , 0.3)
        local width = 1.0
        local height = width * 2.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处选择副本难度"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.1)
        shinePt = GlobalMethod:ccp(0.4 , 0.0)
        local width = 1
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处准备挑战副本"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 0.9
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_11_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处开始挑战副本"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.0 , -0.1)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 1
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_21_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"爱心许愿"
    elseif id == self.Step_21_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"爱心许愿开启了，只要有爱心，就能够许愿获得各种各样的奖励，还有神秘大奖噢！"
    elseif id == self.Step_21_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【福利】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.1)
        shinePt = GlobalMethod:ccp(-3.0 , 0.1)
        local width = 1.0
        local height = width * 0.3
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_21_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【爱心许愿】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.9 , 0.0)
        shinePt = GlobalMethod:ccp(-2.0 , 0.0)
        local width = 0.2
        local height = width * 4
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_21_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击进行许愿"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0.0)
        local width = 0.7
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_22_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"合成系统"
    elseif id == self.Step_22_2 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"恭喜你开启了合成系统，各种低级材料通过合成可以升级高级材料哦！"
    elseif id == self.Step_22_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【更多】"
        nDirection = CellDialog.DIR_LEFT

        if Teach.MORE_TAG == 4 then     --4
            dialogPt = GlobalMethod:ccp(1.2 , -0.3)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.205 - origin.y)
        elseif Teach.MORE_TAG == 3 then --3
            dialogPt = GlobalMethod:ccp(1.2 , -0.08)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.405 - origin.y)
        elseif Teach.MORE_TAG == 2 then --2
            dialogPt = GlobalMethod:ccp(1.2 , 0.12)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.625 - origin.y)
        elseif Teach.MORE_TAG == 1 then --1
            dialogPt = GlobalMethod:ccp(1.2 , 0.35)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.845 - origin.y)
        end
        local width = 0.13
        local height = width * 1.7
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_22_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【更多-合成】"
        nDirection = CellDialog.DIR_LEFT

        --WZLog("id == self.Step_22_4", Teach.MIXTURE_RIGHT_TAG)
        if Teach.MIXTURE_RIGHT_TAG == 4 then     --4
            dialogPt = GlobalMethod:ccp(1.2 , -0.3)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.205 - origin.y)
        elseif Teach.MIXTURE_RIGHT_TAG == 3 then --3
            dialogPt = GlobalMethod:ccp(1.2 , -0.08)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.405 - origin.y)
        elseif Teach.MIXTURE_RIGHT_TAG == 2 then --2
            dialogPt = GlobalMethod:ccp(1.2 , 0.12)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.625 - origin.y)
        elseif Teach.MIXTURE_RIGHT_TAG == 1 then --1
            dialogPt = GlobalMethod:ccp(1.2 , 0.35)
            shinePt = GlobalMethod:ccp(0.93 - origin.x , 0.845 - origin.y)
        end
        local width = 0.13
        local height = width * 1.7
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_22_5 or id == self.Step_22_6 or id == self.Step_22_7 or id == self.Step_22_8 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处放入材料"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.8 , 0.25)
        shinePt = GlobalMethod:ccp(-0.16 , 0.27)
        local width = 0.3
        local height = width * 0.76
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_22_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击合成按钮进行合成"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.0 , 0.3)
        local width = 0.8
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_1 then
        teachType = 2
        if TeachData["id_"..id]["teach_param"] == -1 then
            isIsland = true
        end
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"新功能开启"
        name = LocalStrings.TEACH_OPEN  --"奖励系统"
    elseif id == self.Step_20_2 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【奖励奖励】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.38)
        shinePt = GlobalMethod:ccp(0.0 , 0.38)
        local width = 0.9
        local height = width * 0.3
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_3 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【签到奖励】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , -0.45)
        local width = 1.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_4 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"每日进行签到，可以领取签到奖励，连续签到次数越高，签到奖励越多。"
    elseif id == self.Step_20_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击【签到】"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.15 , 0.0)
        shinePt = GlobalMethod:ccp(-0.35 , 0.3)
        local width = 1.0
        local height = width * 2.2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_6 or id == self.Step_20_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击确认"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , -0.05)
        shinePt = GlobalMethod:ccp(-0.05 , 0.25)
        local width = 1.0
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_7 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【登陆奖励】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , -0.3)
        local width = 1.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_8 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"每日登陆可以领取登陆奖励，登陆达到一定天数还有丰富的额外奖励噢！"
    elseif id == self.Step_20_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击领取奖励"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(1.05 , 0.3)
        shinePt = GlobalMethod:ccp(0.14 , 0.3)
        local width = 0.2
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_11 then
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        local param = SplitTeachTalkStringWithSeparator(TeachData["id_"..id]["teach_param"])
        icon, name, isImgRight = param[1], param[2], param[3]
        sDesc = TeachData["id_"..id]["desc"]    --"还有等级奖励和在线奖励，只要达到等级，和在线时间足够长，就能获得丰富的奖励噢！自己研究去吧~"
    elseif id == self.Step_20_12 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【等级奖励】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , -0.15)
        local width = 1.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_20_13 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开【在线奖励】"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , -0.0)
        local width = 1.0
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    end

    --WZLog("TeachStepGroup3:_getTeachUiData two", tostring(tCell), tostring(shineCell))

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
function TeachStepGroup3:_getTeachElementById( id, teachType, groupId, uiId )
    --WZLog("TeachStepGroup3:_getTeachElementById one", id)
    local element, data = nil, nil
    if uiId == nil then
    uiId = -1
    end
    
    if id == self.Step_9_3 then
        if SceneIsland.m_root ~= nil then
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnHall_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_9_4 then
        if SceneHall.m_root ~= nil then
            if WndCreateRoom.m_root ~= nil or Teach.CREATE_ROOM_MARK == true then
            return
            end
            element = GetElementWithoutAssert(SceneHall.m_root, "btnStartGame_SceneHall",WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_9_5 or id == self.Step_9_6 then
        if WndCreateRoom.m_root ~= nil then
            if id == self.Step_9_5 and WndCreateRoom.m_bIsEnterName == true then
            return
            end

            if id == self.Step_9_6 and WndCreateRoom.m_bIsEnterName ~= true then
            return
            end
            element = GetElementWithoutAssert(WndCreateRoom.m_root, "btnConfirm_WndCreateRoom", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_9_7 then
        if SceneRoom.m_root ~= nil then
            element = GetElementWithoutAssert(SceneRoom.m_root, "btnReadyGame_SceneRoom", WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_11_3 then
        if SceneIsland.m_root ~= nil then
            if (GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island and uiId ~= Chat_Channel_Island) or Teach:getTaskState(-11) == 2 then
            return
            end
            element = GetElementWithoutAssert(SceneIsland.m_root, "btnBossMap_SceneIsland", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_11_4 then
        
    elseif id == self.Step_11_5 then
        do return end
        if WndMultipleMap.m_root ~= nil then

            GetElementWithoutAssert(WndMultipleMap.m_root, "conBtn_WndMultipleMap", WZUIContainer):setZOrder(501)
            element = GetElementWithoutAssert(WndMultipleMap.m_root, "conMapList_WndMultipleMap", WZUIContainer)
            element:getParentElement():setZOrder(500)
        end
    elseif id == self.Step_11_6 then
        if WndMultipleMap.m_root ~= nil then
        if Teach:getTaskState(-11) == 2 then
            return
        end
        element = GetElementWithoutAssert(WndMultipleMap.m_root, "btnChallengeCheckPoint_WndMultipleMap", WZUIButton)
        end
    elseif id == self.Step_11_7 then
        do return end
    elseif id == self.Step_11_8 then
    elseif id == self.Step_11_9 then
        if SceneBossRoom.m_root ~= nil then
            element = GetElementWithoutAssert(SceneBossRoom.m_root, "btnStartGame_SceneBossRoom", WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_10_3 then
        if WndBottomMenu.m_root ~= nil then
            if WndNearbyFriend.m_root ~= nil or WndPlayerInfo.m_root ~= nil or Teach:getTaskState(-10) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnFriend_WndBottomMenu", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_10_4 then
        if WndNearbyFriend.m_root ~= nil then
            if WndAddFriend.m_root ~= nil or Teach:getTaskState(-10) == 2 then
                return
            end
            element = GetElementWithoutAssert(WndNearbyFriend.m_root, "btnAddFriend_WndNearbyFriend", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_10_5 then
        if WndAddFriend.m_root ~= nil then
            if WndPlayerInfo.m_root ~= nil or Teach:getTaskState(-10) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndAddFriend.m_root, "conFriend_WndAddFriend", WZUIContainer)
        end
    elseif id == self.Step_10_6 then
        if WndPlayerInfo.m_root ~= nil then
            if Teach:getTaskState(-10) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndPlayerInfo.m_root, "btnFriend_WndPlayerInfo", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_10_7 then
        if (Teach:getTaskState(-10) == 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_21_3 then
        if WndLeftMenu.m_root ~= nil then
            if WndLeftBox.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndLeftMenu.m_root, "conBg_WndLeftMenu",WZUIContainer)
        end
    elseif id == self.Step_21_4 then
        if WndLeftBox.m_root ~= nil then
            element = GetElementWithoutAssert(WndLeftBox.m_root, "conBg_WndLeftBox",WZUIContainer)
            element:setZOrder(500)
        end
    elseif id == self.Step_21_5 then
        if SceneLottery.m_root ~= nil then
            element = GetElementWithoutAssert(SceneLottery.m_root, "btnLottery_SceneLottery",WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_22_3  then
        if WndRightMenu.m_root ~= nil then
            if WndRightMoreMenu.m_root ~= nil or WndFurnac.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRightMenu.m_root, "conBg_WndRightMenu",WZUIContainer)
        end
    elseif id == self.Step_22_4 then
        --[[
        if WndRightMoreMenu.m_root ~= nil then
            if WndFurnac.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRightMoreMenu.m_root, "conBg_WndRightMoreMenu",WZUIContainer)
            element:setZOrder(500)
        end
        --]]

        --WZLog("id == self.Step_22_4 two", WndRightMenu.m_root, WndFurnac.m_root)
        if WndRightMenu.m_root ~= nil then
            if WndFurnac.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRightMenu.m_root, "conBg_WndRightMenu",WZUIContainer)
        end
    elseif id == self.Step_22_5 or id == self.Step_22_6 or id == self.Step_22_7 or id == self.Step_22_8 then
        --[[
        if WndMixture.m_root ~= nil then
            if #WndMixture.m_tMixture <= 0 or GetElementWithoutAssert(WndMixture.m_root, "btnMixture_WndMixture", WZUIButton):getTouchEnable() == true then
            return
            end
            element = GetElementWithoutAssert(WndMixture.m_root, "conLeft_WndMixture",WZUIContainer)
            element:setZOrder(500)
        end
        --]]
        
        --WZLog("id == self.Step_22_5", tostring(WndFurnac.m_root), WndFurnac.m_nCurWindow, #WndFurnac.m_tStuffMixture, tostring(self.m_curPropNum))
        if WndFurnac.m_root ~= nil then
            if WndFurnac.m_nCurWindow ~= 0 or #WndFurnac.m_tStuffMixture <= 0 or (WndFurnac.m_curPropNum ~= nil and WndFurnac.m_curPropNum ~= 0 ) then
                return
            end
            element = GetElementWithoutAssert(WndFurnac.m_root, "conPlayerStuff_WndFuranc",WZUIContainer)
            element:setZOrder(500)
        end
    elseif id == self.Step_22_9 then
        --[[
        if WndMixture.m_root ~= nil then
            element = GetElementWithoutAssert(WndMixture.m_root, "btnMixture_WndMixture", WZUIButton)
            element:setZOrder(500)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
        --]]
        if WndFurnac.m_root ~= nil then
            if WndFurnac.m_nCurWindow ~= 0 or (WndFurnac.m_curPropNum == nil or WndFurnac.m_curPropNum == 0 ) then
                return
            end
            element = GetElementWithoutAssert(WndFurnac.m_root, "btnMixture_WndFurnac",WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
        end
    elseif id == self.Step_20_2 then
        if WndLeftMenu.m_root ~= nil then
            if WndRewardSystem.m_root ~= nil or (Teach:getTaskState(-202) == 2 and Teach:getTaskState(-205) == 2 and Teach:getTaskState(-204) == 2 and Teach:getTaskState(-206) == 2) then
            return
            end
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndLeftMenu.m_root, "conBg_WndLeftMenu",WZUIContainer)
        end
    elseif id == self.Step_20_3 then
        if WndRewardSystem.m_root ~= nil then
            if WndRewardSystem.m_nIndex == 1 or Teach:getTaskState(-202) == 2 or (WndRewardSystem.m_nIndex == 2 and Teach:getTaskState(-205) ~= 2 ) or Teach.LOGIN_REWARD_MARK ~= nil then
            return
            end
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRewardSystem.m_root, "BtnQiandao_WndRewardSystem",WZUIContainer)
            element:setZOrder(500)
            element:getParentElement():setZOrder(500)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_20_4 then
    --WZLog("id == self.Step_20_4 one",id, tostring(WndRewardShow.m_root),tostring(Teach:getTaskState(-201)),tostring(Teach.m_isWndTeachTalkExist))
        if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
        data = false
        end
        if WndRewardSystem.m_root ~= nil and WndRewardSystem.m_nIndex == 1 and (Teach:getTaskState(-201) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        --WZLog("id == self.Step_20_4 two")
        data = nil
        else
        data = false
        end
    elseif id == self.Step_20_5 then
        if WndSingInReward.m_root ~= nil then
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil or Teach:getTaskState(-201) ~= 2 or Teach:getTaskState(-202) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndSingInReward.m_root, "btnSignIn_WndSingInReward", WZUIButton)
            if element ~= nil and element:getTouchEnable() == true then
            element:setZOrder(500)
            --element:getParentElement():setZOrder(500)
            element:getParentElement():getParentElement():setZOrder(500)
            elseif element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_20_6 or id == self.Step_20_10 then
    --WZLog("id == self.Step_20_6",id,tostring(Teach.REWARD_MARK))
        if WndRewardShow.m_root ~= nil then
            if id == self.Step_20_6 and (Teach.REWARD_MARK == nil or Teach.REWARD_MARK ~= 1) then
            return
            end
            if id == self.Step_20_10 and (Teach.REWARD_MARK == nil or Teach.REWARD_MARK ~= 2) then
            return
            end
            element = GetElementWithoutAssert(WndRewardShow.m_root, "btnOK_WndMsgConfirmBox", WZUIContainer)
            element:getParentElement():setZOrder(500)
        end
    elseif id == self.Step_20_7 then
        if WndRewardSystem.m_root ~= nil then
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
            return
            end
            if WndRewardSystem.m_nIndex == 2 or Teach:getTaskState(-205) == 2 then
            return
            end
            element = GetElementWithoutAssert(WndRewardSystem.m_root, "BtnLogin_WndRewardSystem",WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_20_8 then
        if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
        data = false
        end
        if WndRewardSystem.m_root ~= nil and WndRewardSystem.m_nIndex == 2 and (Teach:getTaskState(-205) ~= 2) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_20_9 then
        if WndRewardSystem.m_root ~= nil then
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil or Teach:getTaskState(-205) == 2 or WndLoginReward.m_root == nil or WndRewardSystem.m_nIndex ~= 2 or Teach.LOGIN_REWARD_MARK ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRewardSystem.m_root, "conRight_WndLoginRewards",WZUIContainer)
            if element ~= nil then
                element:setZOrder(501)

                local e2 = GetElementWithoutAssert(WndRewardSystem.m_root, "conLeftWin_WndRewardSystem",WZUIContainer)
                e2:setZOrder(499)

                local e1 = GetElementWithoutAssert(WndRewardSystem.m_root, "conRightWin_WndRewardSystem",WZUIContainer)
                e1:setZOrder(500)
            end
        end
    elseif id == self.Step_20_11 then
        if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
        data = false
        end
        if WndRewardSystem.m_root ~= nil and (Teach:getTaskState(-205) == 2 and (Teach:getTaskState(-204) ~= 2 or Teach:getTaskState(-206) ~= 2)) and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id > Teach.m_isWndTeachTalkExist)) then
        data = nil
        else
        data = false
        end
    elseif id == self.Step_20_12 then
        if WndRewardSystem.m_root ~= nil then
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
            return
            end
            if WndRewardSystem.m_nIndex == 3 or Teach:getTaskState(-204) == 2 or Teach.LOGIN_REWARD_MARK ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRewardSystem.m_root, "BtnLevel_WndRewardSystem",WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
            if element ~= nil and element:getTouchEnable() ~= true then
            element = nil
            end
        end
    elseif id == self.Step_20_13 then
        if WndRewardSystem.m_root ~= nil then
            if WndRewardShow.m_root ~= nil or WndTeachTalk.m_root ~= nil then
            return
            end
            if WndRewardSystem.m_nIndex == 4 or Teach:getTaskState(-206) == 2 or Teach.LOGIN_REWARD_MARK ~= nil then
            return
            end
            element = GetElementWithoutAssert(WndRewardSystem.m_root, "BtnOnLine_WndRewardSystem",WZUIButton)
            element:getParentElement():getParentElement():setZOrder(500)
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

    --WZLog("TeachStepGroup3:_getTeachElementById two", id, tostring(element), tostring(data), tostring(SceneIsland.m_root == nil))
    return element, data
end

--@brief    获取教学闪光元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup3:_getTeachShineElementById( id )
    --WZLog("TeachStepGroup3:_getTeachShineElementById one", id)
    local element = nil

    if id == 0 then
        if WndBattleHud.m_root ~= nil then
            element =  nil
        end
    end

    --WZLog("TeachStepGroup3:_getTeachShineElementById two", id, tostring(element))
    return element
end


--@brief	初始化的新手教学的步骤编号
--@return	新手教学的步骤编号
function TeachStepGroup3:_initTeachStep()
    --WZLog("TeachStepGroup3:_initTeachStep one")

    self.STEP_GROUP_IDS = {[9]=12,[10]=13,[11]=14,[20]=7,[21]=8,[22]=10}

    if self.TOTAL_STEP == nil then
        self.TOTAL_STEP = {}

        for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
            for stepIndex, data in pairs (Teach.DATA.group[groupIndex]) do
                self["Step_"..i.."_"..stepIndex] = data.id
                --WZLog("TeachStepGroup3:_initTeachStep two", "Step_"..i.."_"..stepIndex, data.id)
            end
        end

        local group = {}
        ---[[
        table.insert(group, self.Step_9_1)
        table.insert(group, self.Step_9_2)
        table.insert(group, self.Step_9_3)
        table.insert(group, self.Step_9_4)
        table.insert(group, self.Step_9_5)
        table.insert(group, self.Step_9_6)
        table.insert(group, self.Step_9_7)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[9] = group

        group = {}
        ---[[
        table.insert(group, self.Step_10_1)
        table.insert(group, self.Step_10_2)
        --table.insert(group, self.Step_10_3)
        table.insert(group, self.Step_10_4)
        table.insert(group, self.Step_10_5)
        table.insert(group, self.Step_10_6)
        table.insert(group, self.Step_10_7)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[10] = group

        group = {}
        ---[[
        table.insert(group, self.Step_11_1)
        table.insert(group, self.Step_11_2)
        --table.insert(group, self.Step_11_3)
        --table.insert(group, self.Step_11_4)
        --table.insert(group, self.Step_11_5)
        --table.insert(group, self.Step_11_6)
        --table.insert(group, self.Step_11_7)
        --table.insert(group, self.Step_11_8)
        --table.insert(group, self.Step_11_9)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[11] = group

        local group = {}
        ---[[
        table.insert(group, self.Step_20_1)
        table.insert(group, self.Step_20_2)
        --table.insert(group, self.Step_20_3)
        --table.insert(group, self.Step_20_4)
        --table.insert(group, self.Step_20_5)
        --table.insert(group, self.Step_20_6)
        --table.insert(group, self.Step_20_7)
        --table.insert(group, self.Step_20_8)
        --table.insert(group, self.Step_20_9)
        --table.insert(group, self.Step_20_10)
        --table.insert(group, self.Step_20_11)
        table.insert(group, self.Step_20_12)
        --table.insert(group, self.Step_20_13)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[20] = group

        local group = {}
        --[[
        table.insert(group, self.Step_21_1)
        table.insert(group, self.Step_21_2)
        table.insert(group, self.Step_21_3)
        table.insert(group, self.Step_21_4)
        table.insert(group, self.Step_21_5)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[21] = group

        local group = {}
        ---[[
        table.insert(group, self.Step_22_1)
        table.insert(group, self.Step_22_2)
        --table.insert(group, self.Step_22_3)
        table.insert(group, self.Step_22_4)
        table.insert(group, self.Step_22_5)
        table.insert(group, self.Step_22_6)
        table.insert(group, self.Step_22_7)
        table.insert(group, self.Step_22_8)
        table.insert(group, self.Step_22_9)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[22] = group

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

    --table.insert(Teach.DATA.saveTask, {["ids"] = -10, ["step"] = 0})
    --ProtocolProcessorTeach:send_TASK_TiroStep(-10, 0)
    --self.INDEX[22] = 0

    --WZLog("TeachStepGroup3:_initTeachStep three", BattleCommon:tableLen(self.TOTAL_STEP), #self.INDEX)
	return self.INDEX
end


