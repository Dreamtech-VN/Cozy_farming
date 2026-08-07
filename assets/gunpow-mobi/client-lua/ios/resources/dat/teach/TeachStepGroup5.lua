--TeachStepGroup5.lua
--@brief	TeachStepGroup5的模块
--@date		2014/9/25
--@author	莫剑峰
--@note		教学步骤组

TeachStepGroup5 =
{
    GROUP = 5,

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
function TeachStepGroup5:start( nId , tSteps )
	--WZLog("TeachStepGroup5:start one", nId, tostring(tSteps), tostring(self.INDEX), tostring(self.TOTAL_STEP))
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
        --WZLog("TeachStepGroup5:start four", id , nStep)
        --获取下一步的新手教学的步骤编号
        tSteps = self:getTeachStep( id )
        if tSteps ~= nil then
            for index, nStep in pairs (tSteps) do
                --WZLog("TeachStepGroup5:start five", id , nStep , #tSteps, tostring(#self.INDEX))
                --获取需要新手教学的节点和要提示的文本内容
                local tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, isImgRight, name, shineCell, teachType, icon = self:_getTeachUiData( nStep, id, nId )
                --WZLog("TeachStepGroup5:start six", tostring(tCell), nStep , tostring(#self.INDEX))
                if nStep and nStep ~= -1 and tCell ~= nil then
                    if teachType == 0 then
                        self:_createTalk( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon)	--创建剧情对话
                    elseif teachType == 1 then
                        self:_createArrow( nStep, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )	--创建箭头
                    elseif teachType == 2 then
                        self:_createOpenModule( nStep, name, sDesc, nStep, isIsland)	--创建模块开启框
                    end
                    self.INDEX[id] = nStep
                    --WZLog("TeachStepGroup5:start seven", self.INDEX[id])
                    break
                end
            end
        end
    end
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStepGroup5:getTeachStep( nStep )

    for i, v in pairs (self.INDEX) do
        --WZLog("TeachStepGroup5:getTeachStep two",i,v)
    end

    if self.INDEX[nStep] <= -1 then
        return
    end

    local group = {}
    if nStep == 6 and Teach:getTaskState(Teach.TASK_ID_INTENSIFY) == 1 then
        table.insert(group, self.Step_6_12)
        table.insert(group, self.Step_6_13)
        table.insert(group, self.Step_6_14)
        table.insert(group, -1)
        self.TOTAL_STEP[nStep] = group
    elseif nStep == 7 and Teach:getTaskState(1001000) == 1 then
        table.insert(group, self.Step_7_9)
        table.insert(group, self.Step_7_10)
        table.insert(group, -1)
        self.TOTAL_STEP[nStep] = group
    elseif nStep == 8 and Teach:getTaskState(1001300) == 1 then
        table.insert(group, self.Step_8_9)
        table.insert(group, self.Step_8_10)
        table.insert(group, self.Step_8_11)
        table.insert(group, self.Step_8_12)
        table.insert(group, self.Step_8_13)
        table.insert(group, self.Step_8_14)
        table.insert(group, self.Step_8_15)
        table.insert(group, self.Step_8_16)
        table.insert(group, -1)
        self.TOTAL_STEP[nStep] = group
    end
    --WZLog("TeachStepGroup5:getTeachStep three",#self.TOTAL_STEP[nStep])
    return self.TOTAL_STEP[nStep]
end

--@brief 结束步骤
function TeachStepGroup5:finishStep(finishStep)
    --WZLog("TeachStepGroup5:finishStep one", finishStep)

    local isStepCanFinish = false
    if self.TOTAL_STEP == nil or BattleCommon:tableLen(self.TOTAL_STEP) == 0 or self.INDEX == nil or self.INDEX == 0 then
        return
    end

    --WZLog("TeachStepGroup5:finishStep three", finishStep)
    for i, v in pairs(self.INDEX) do
        if finishStep == v then
            isStepCanFinish = true
        end
    end

    if isStepCanFinish == false then
        return
    end

    --WZLog("TeachStepGroup5:finishStep four", finishStep)
    for i,group in pairs(self.TOTAL_STEP) do
        if group ~= nil then
            for id,step in pairs(group) do
                --WZLog("TeachStepGroup5:finishStep five", i, id, step)
                if finishStep == step then
                    --WZLog("TeachStepGroup5:finishStep six", step)
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
function TeachStepGroup5:isTeachSkill()
    --WZLog("TeachStepGroup5:isTeachSkill one")
    local isTeach = false

    if self.INDEX == nil or self.INDEX == 0 then
        return isTeach
    end

    for i, v in pairs(self.INDEX) do
        if v ~= nil and v == self.Step_5_3 then
            isTeach = true
        end
    end

    --WZLog("TeachStepGroup5:isTeachSkill two", isTeach)
    return isTeach
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建箭头
--@param	nId：新手教学的编号
function TeachStepGroup5:_createArrow( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, shinePt, shineScale, isHud, shineCell, icon )
    if tCell then
        if isIsland == true then
            tCell:setZOrder(500)
        end

        --弹出教学对话框
        self.DIALOG = Teach:showDialog( tCell , tCell , sDesc , nDirection , dialogPt, self.ZORDER )
        self.DIALOG_PARENT = tCell

        local shine = tCell
        if shineCell ~= nil then
            --WZLog("TeachStepGroup5:_createArrow zero",tostring(shineCell))
            shine = shineCell
        end

        --发光效果
        if shineScale == nil then
            --WZLog("TeachStepGroup5:_createArrow one")
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, nil, nil, self.ZORDER)
            self.SHINE_PARENT = shine
        else
            --WZLog("TeachStepGroup5:_createArrow two", shineScale.width, shineScale.height)
            self.SHINE = Teach:showShineAction(shine, icon, dir, shinePt, shineScale.width, shineScale.height, self.ZORDER)
            self.SHINE_PARENT = shine
        end

        table.insert(Teach.TEACH_DIALOGS, {[1]=self.DIALOG, [2]=self.DIALOG_PARENT, [3]=self.ZORDER, [4]=self.INDEX})
        table.insert(Teach.TEACH_SHINES, {[1]=self.SHINE, [2]=self.SHINE_PARENT, [3]=self.ZORDER, [4]=self.INDEX})

    end
end

--@brief	创建剧情对话
--@param	nId：新手教学的编号
function TeachStepGroup5:_createTalk( nId, tCell , sDesc , nDirection , isIsland , dir , dialogPt, isImgRight, name, nStep, icon )
    --WZLog("TeachStepGroup5:_createTalk", tostring(WndTeachTalk.m_root), tostring(nId), tostring(name), tostring(tCell), tostring(sDesc), tostring(nDirection), tostring(isIsland), tostring(dir), tostring(dialogPt), tostring(isImgRight))

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
function TeachStepGroup5:_createOpenModule( nId, sDesc, name, nStep, isIsland)
    --WZLog("TeachStepGroup5:_createOpenModule", tostring(WndTeachOpenModule.m_root),  nId, sDesc, name)

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
function TeachStepGroup5:_getTeachUiData( id, groupId ,uiId )
    --WZLog("TeachStepGroup5:_getTeachUiData one",id)
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
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处打开背包界面"
        nDirection = CellDialog.DIR_UP
        dialogPt = GlobalMethod:ccp(0.3 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.2
        local height = width * 1.5
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_4 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择要强化的装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , -0.5)
        local width = 1
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_5 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击强化按钮"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(0.0 , 0)
        local width = 1.0
        local height = width * 1.0
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_6 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击选择要强化的装备"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_7 or id == self.Step_6_8 or id == self.Step_6_9 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击添加强化石"
        nDirection = CellDialog.DIR_RIGHT
        dialogPt = GlobalMethod:ccp(-0.83 , 0.38)
        shinePt = GlobalMethod:ccp(-0.3 , 0.83)
        local width = 0.3
        local height = width * 0.9
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_10 then
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
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到背包"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.3 , 0.)
        shinePt = GlobalMethod:ccp(-0.45 , 0.)
        local width = 1.3
        local height = width * 1
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_12 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击关闭按钮，回到原界面"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(0.0 , 0.0)
        shinePt = GlobalMethod:ccp(-0.0 , -0.0)
        local width = 1
        local height = width * 2
        shineScale = GlobalMethod:CCSize(width , height)
    elseif id == self.Step_6_13 or id == self.Step_7_9 or id == self.Step_8_9 then
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
    elseif id == self.Step_6_14 or id == self.Step_7_10 or id == self.Step_8_10 then
        teachType = 1
        tCell, data = self:_getTeachElementById( id, teachType, groupId, uiId )
        sDesc = TeachData["id_"..id]["desc"]    --"点击此处提交任务获得奖励"
        nDirection = CellDialog.DIR_LEFT
        dialogPt = GlobalMethod:ccp(-0.2 , 0.0)
        shinePt = GlobalMethod:ccp(-0.5 , 0.3)
        local width = 0.7
        local height = width * 1.8
        shineScale = GlobalMethod:CCSize(width , height)

    end

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
function TeachStepGroup5:_getTeachElementById( id, teachType, groupId, uiId )
    --WZLog("TeachStepGroup5:_getTeachElementById one", id, teachType, GlobalGame.g_nCurrentUIChannelId, tostring(uiId))
    local element, data = nil, nil
    if uiId == nil then
        uiId = -1
    end

    if id == self.Step_6_13 or id == self.Step_7_9 or id == self.Step_8_9 then
        --WZLog("id == self.Step_6_13", GlobalGame.g_nCurrentUIChannelId,uiId, Teach:getTaskState(Teach.TASK_ID_INTENSIFY))
        if WndBottomMenu.m_root == nil then
        return
        end
        if WndTask.m_root ~= nil then
        return
        end
        if id == self.Step_6_13 and Teach:getTaskState(Teach.TASK_ID_INTENSIFY) ~= 1 then
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
    elseif id == self.Step_6_14 or id == self.Step_7_10 or id == self.Step_8_10 then
        if GlobalGame.g_nCurrentUIChannelId ~= Chat_CHannel_Task then
        return
        end
        if id == self.Step_6_14 and Teach:getTaskState(Teach.TASK_ID_INTENSIFY) ~= 1 then
        return
        end
        if WndTask.m_root ~= nil and WndTask.m_tRewardsLuaObj ~= nil and WndTask.m_nCurIndex == 0 then
            element = GetElementWithoutAssert(WndTask.m_tRewardsLuaObj.m_root, "btnTask_CellTaskRewards", WZUIButton)
        end
    elseif id == self.Step_6_3 or id == self.Step_7_3 or id == self.Step_8_3 or id == self.Step_12_3 or id == self.Step_13_3 then


        if id == self.Step_6_3 and (Teach:getTaskState(Teach.TASK_ID_INTENSIFY) >= 1 or Teach:getTaskState(-6) == 2) then
        return
        end
        if WndBag.m_root ~= nil then
        return
        end

        if WndTask.m_root ~= nil then
        return
        end
        if WndStrengthen.m_root ~= nil then
        return
        end

        if WndBottomMenu.m_root ~= nil then
        element = GetElementWithoutAssert(WndBottomMenu.m_root, "btnPlayer_WndBottomMenu", WZUIButton)
        if element ~= nil and element:getTouchEnable() ~= true then
        element = nil
        end
        end
    elseif id == self.Step_6_4 then
        --WZLog("id == self.Step_6_4", Teach:getTaskState(Teach.TASK_ID_INTENSIFY), Teach:getTaskState(-6), tostring(WndBag.m_root), tostring(WndPlayer.m_root))
        if  (Teach:getTaskState(Teach.TASK_ID_INTENSIFY) >= 1 or Teach:getTaskState(-6) == 2) then
        return
        end
        if WndBag.m_root == nil then
        return
        end
        if WndItemInfo.m_root ~= nil then
        return
        end
        if WndStrengthen.m_root ~= nil then
        return
        end
        if WndPlayer.m_root ~= nil then
        element = GetElementWithoutAssert(WndPlayer.m_root, "conEquip1_WndPlayer", WZUIContainer)
        end

    elseif id == self.Step_6_5 then
        --WZLog("id == self.Step_6_5", Teach:getTaskState(Teach.TASK_ID_INTENSIFY), Teach:getTaskState(-6), tostring(WndBag.m_root), tostring(WndItemInfo.m_root))
        if  (Teach:getTaskState(Teach.TASK_ID_INTENSIFY) >= 1 or Teach:getTaskState(-6) == 2) then
        return
        end
        if WndBag.m_root == nil then
        return
        end
        if WndStrengthen.m_root ~= nil then
            return
        end
        if WndItemInfo.m_root ~= nil then
        element = GetElementWithoutAssert(WndItemInfo.m_root, "btn1_WndItemInfo", WZUIButton)
        element:getParentElement():setZOrder(500)
        end

    elseif id == self.Step_6_6 or id == self.Step_7_5 or id == self.Step_8_5 or id == self.Step_8_6 or id == self.Step_12_5 or id == self.Step_13_5 then

        if id == self.Step_6_6 and (WndStrengthen.m_nCurIndex ~= 1 or WndStrengthen.m_tIntensifyLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj:isItemNil() ~= true or Teach:getTaskState(-6) == 2)  then
            return element, data
        elseif id == self.Step_7_5 and WndStrengthen.m_nCurIndex ~= 2 then
            return element, data
        elseif id == self.Step_8_5 and WndStrengthen.m_nCurIndex ~= 5 then
            return element, data
        elseif id == self.Step_8_6 and WndStrengthen.m_nCurIndex ~= 5 then
            return element, data
        elseif id == self.Step_12_5 and WndStrengthen.m_nCurIndex ~= 3 then
            return element, data
        elseif id == self.Step_13_5 and WndStrengthen.m_nCurIndex ~= 4 then
            return element, data
        end

    elseif id == self.Step_6_7 or id == self.Step_6_8 or id == self.Step_6_9 or id == self.Step_12_6 or id == self.Step_13_6 then

        if WndStrengthen.m_tIntensifyLuaObj ~= nil then
            --WZLog("self.Step_6_7 ", tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone1LuaObj:isItemNil()), tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone2LuaObj:isItemNil()),tostring(WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone3LuaObj:isItemNil()))
        end
        if (id == self.Step_6_7 or id == self.Step_6_8 or id == self.Step_6_9) and (WndStrengthen.m_nCurIndex ~= 1 or WndStrengthen.m_tIntensifyLuaObj == nil or WndStrengthen.m_tIntensifyLuaObj:_getSuccessRate() >= 100 or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj == nil  or WndStrengthen.m_tIntensifyLuaObj.m_weaponLuaObj:isItemNil() == true or (WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone1LuaObj:isItemNil() ~= true and WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone2LuaObj:isItemNil() ~= true and WndStrengthen.m_tIntensifyLuaObj.m_strengthenStone3LuaObj:isItemNil() ~= true) or Teach:getTaskState(-6) == 2) then
            return element, data
        elseif id == self.Step_7_6 and WndStrengthen.m_nCurIndex ~= 2 then
            return element, data
        elseif id == self.Step_12_6 and WndStrengthen.m_nCurIndex ~= 3 then
            return element, data
        elseif id == self.Step_13_6 and WndStrengthen.m_nCurIndex ~= 4 then
            return element, data
        end
    elseif id == self.Step_6_10 then

        if WndStrengthen.m_tIntensifyLuaObj == nil or (WndStrengthen.m_tIntensifyLuaObj:_getSuccessRate() < 100) or Teach:getTaskState(-6) == 2 then
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
        if id == self.Step_6_11 and (WndStrengthen.m_nCurIndex ~= 1 or Teach:getTaskState(-6) ~= 2 or Teach:getTaskState(-61) == 2) then
            return element, data
        elseif id == self.Step_7_8 and WndStrengthen.m_nCurIndex ~= 2 then
            return element, data
        elseif id == self.Step_8_8 and WndStrengthen.m_nCurIndex ~= 5 then
            return element, data
        elseif id == self.Step_12_9 and WndStrengthen.m_nCurIndex ~= 3 then
            return element, data
        elseif id == self.Step_13_9 and WndStrengthen.m_nCurIndex ~= 4 then
            return element, data
        end
        if WndStrengthen.m_root ~= nil then
            element = GetElementWithoutAssert(WndStrengthen.m_root, "btnClose_WndStrengthen", WZUIButton)
            if element ~= nil and element:getTouchEnable() ~= true then
                element = nil
            end
        end
    elseif id == self.Step_6_12 then
        --WZLog("id == self.Step_6_12", Teach:getTaskState(Teach.TASK_ID_INTENSIFY), WndBag.m_root)
        if Teach:getTaskState(Teach.TASK_ID_INTENSIFY) ~= 1 then
        return
        end
        if WndBag.m_root ~= nil then
        element = GetElementWithoutAssert(WndBag.m_root, "btnClose_WndBag", WZUIButton)
        if element ~= nil and element:getTouchEnable() ~= true then
        element = nil
        end
        end
    elseif teachType ~= nil and teachType == 0 then
        --WZLog("teachType == 0",tostring(Teach.m_isWndTeachTalkExist),tostring(id),tostring(GlobalGame.g_nCurrentUIChannelId))

        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachTalkExist == nil or (Teach.m_isWndTeachTalkExist ~= nil and id ~= Teach.m_isWndTeachTalkExist)) and id > self.INDEX[groupId] and WndTeachOpenModule.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    elseif teachType ~= nil and teachType == 2 then
        --WZLog("teachType == 2",tostring(Teach.m_isWndTeachOpenModuleExist),tostring(id),tostring(GlobalGame.g_nCurrentUIChannelId))

        if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Loadding and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fighting and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_GameOver and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Fan and GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_WorldBoss and (Teach.m_isWndTeachOpenModuleExist == nil or (Teach.m_isWndTeachOpenModuleExist ~= nil and id ~= Teach.m_isWndTeachOpenModuleExist)) and id > self.INDEX[groupId]  and WndTeachTalk.m_root == nil and WndRewardShow.m_root == nil then
            data = nil
        else
            data =  false
        end
    end

    --WZLog("TeachStepGroup5:_getTeachElementById two", id, tostring(self.INDEX[groupId]), tostring(element), tostring(data))
    return element, data
end

--@brief    获取教学闪光元素
--@param	教学元素ID
--@return	教学元素
function TeachStepGroup5:_getTeachShineElementById( id )
    --WZLog("TeachStepGroup5:_getTeachShineElementById one", id)
    local element = nil

    if id == 0 then
        if WndBattleHud.m_root ~= nil then
            element =  nil
        end
    end

    --WZLog("TeachStepGroup5:_getTeachShineElementById two", id, tostring(element))
    return element
end


--@brief	初始化的新手教学的步骤编号
--@return	新手教学的步骤编号
function TeachStepGroup5:_initTeachStep()
    --WZLog("TeachStepGroup5:_initTeachStep one")

    self.STEP_GROUP_IDS = {[6]=6}

    if self.TOTAL_STEP == nil then
        self.TOTAL_STEP = {}

        for i, groupIndex in pairs (self.STEP_GROUP_IDS) do
            for stepIndex, data in pairs (Teach.DATA.group[groupIndex]) do
                self["Step_"..i.."_"..stepIndex] = data.id
                --WZLog("TeachStepGroup5:_initTeachStep two", "Step_"..i.."_"..stepIndex, data.id)
            end
        end

        local group = {}
        ---[[
        table.insert(group, self.Step_6_1)
        table.insert(group, self.Step_6_2)
        table.insert(group, self.Step_6_3)

        table.insert(group, self.Step_6_4)
        table.insert(group, self.Step_6_5)
        table.insert(group, self.Step_6_6)
        table.insert(group, self.Step_6_7)
        table.insert(group, self.Step_6_8)
        table.insert(group, self.Step_6_9)

        table.insert(group, self.Step_6_10)
        table.insert(group, self.Step_6_11)
        table.insert(group, self.Step_6_12)
        table.insert(group, self.Step_6_13)
        table.insert(group, self.Step_6_14)
        --]]
        table.insert(group, -1)
        self.TOTAL_STEP[6] = group

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

    --self.INDEX[6] = 0

    --WZLog("TeachStepGroup5:_initTeachStep three", BattleCommon:tableLen(self.TOTAL_STEP), #self.INDEX)
	return self.INDEX
end

