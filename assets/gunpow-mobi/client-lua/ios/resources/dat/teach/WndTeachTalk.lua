--WndTeachTalk.lua
--@brief	WndTeachTalk的UI模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口

TRIGGER_BATTLE_START = 1
TRIGGER_BATTLE_END = 2
TRIGGER_TASK_GET = 3
TRIGGER_TASK_SUBMIT = 4
TRIGGER_LEVEL_UP = 5
TRIGGER_MONSTER_APPEAR = 6
TRIGGER_MONSTER_DISAPPEAR = 7
TRIGGER_BATTLE_LEAVE = 8
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeachTalk:onEnter(element)
    --WZLog("WndTeachTalk:onEnter")

	self.m_root = element
    self:_moreLanguageForStroke()
    --多语言版本界面适配
    AdaptLanguage(self)
    self:_upDateMoveContainer()
    self:_update()
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeachTalk:onExit(element)
    --WZLog("WndTeachTalk:onExit")
	self:_unInit()
end

--是否存在
function WndTeachTalk:updateOk()
    --WZLog("WndTeachTalk:updateOk")
    self.m_bIsInitOk = true
end

--是否存在
function WndTeachTalk:IsNoExist()
    return not self.m_root
end

--@brief
--@param	element:按钮的引用
function WndTeachTalk:onOkClick(element)
    --WZLog("WndTeachTalk:onOkClick", tostring(self.m_bIsInitOk))
    if self.m_bIsInitOk then
        self:_update()
    end
end

--@brief	关闭窗口
function WndTeachTalk:removeWindow()
    --WZLog("WndTeachTalk:removeWindow", tostring(self.m_root))
    if self.m_root == nil then
        return
    end
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    设置人物icon
--@param    icon名字
function WndTeachTalk:setIcon(icon)
    if type(icon) == "string" then
        self.m_sIcon = "ui/combat/"..icon..".png"
    else
        self.m_sIcon = icon
    end
end

--@brief    设置音效
--@param    
function WndTeachTalk:setSound(soundType)
    -- for i ,v in pairs (GDatatab_story_talk) do
    --     if v.storyId == self.m_nGroupIndex and v.talkId == self.m_nTalkIndex then
    --         type = v.soundIndex
    --     end
    -- end

    soundType = GDatatab_story_talk["id_" .. self.m_nIndex].soundIndex
    WZLog("WndTeachTalk:setSound1", tostring(soundType), self.m_nGroupIndex, self.m_nTalkIndex)
    if soundType == -1 then return end

    if type(soundType) == "table" then
        if CacheCenter:getPlayerInfo().sex == 0 then
            soundType = soundType[1][1]
        else
            soundType = soundType[1][2]
        end
    end

    WZLog("WndTeachTalk:setSound2", soundType)
    self.m_nSound = soundType
end

--@brief    设置人物iconList
--@param    icon名字
function WndTeachTalk:setHeadList(headList)
    WZLog("WndTeachTalk:setHeadList", tostring(headList[1]), tostring(headList[2]))
    
    self.m_tHeadList0 = headList
    self.m_tHeadList = {}
    for i,icon in pairs(headList) do
        self.m_tHeadList[i] = "ui/combat/"..icon..".png"
    end

end

--@brief    设置头像类型
function WndTeachTalk:setHeadType(headTypeList)
    self.m_tHeadTypeList = headTypeList
end

--@brief    设置头像表情
function WndTeachTalk:setHeadFace(headFaceList)
    self.m_tHeadFaceList = headFaceList
end

--@brief    设置头像表情位置
function WndTeachTalk:setHeadFacePos(headFacePosList)
    self.m_tHeadFacePosList = headFacePosList
end

--@brief    设置index
function WndTeachTalk:setIndex(index)
    self.m_nIndex = index
end

--@brief    解锁按钮ID
function WndTeachTalk:setTrailerButtonId(buttonId)
    self.m_nTrailerButtonId = buttonId
end

--@brief    是否JUMP
function WndTeachTalk:setIsJump(isJump)
    self.m_bIsJump = isJump
end

--@brief    是否升级教学
function WndTeachTalk:setUpgradeTeach(isUpgradeTeach)
    self.m_bIsUpgradeTeach = isUpgradeTeach
end

--@brief    是否Replace
function WndTeachTalk:setReplace(isReplace)
    self.m_bIsReplace = isReplace
end

--@brief    是否评论
function WndTeachTalk:setIsComment(isComment)
    self.m_bIsComment = isComment
end

--@brief    设置人物icon偏移
--@param    人物icon偏移
function WndTeachTalk:setIconOffset(offset)
    if offset == nil or (offset.x == 0 and offset.y == 0) then
        return
    end
    self.m_tOffset = offset
end

--@brief    设置是否人物在右边
--@param    是否人物在右边
function WndTeachTalk:setImgRight(isImgRight)
    self.m_bIsImgRight = isImgRight
end

--@brief    设置是否要弹升级框
function WndTeachTalk:setIsUpgrade(isUpgrade)
    --WZLog("WndTeachTalk:setIsUpgrade", tostring(isUpgrade))
    self.m_bIsUpgrade = isUpgrade
end

--@brief    设置是否人物在右边
--@param    是否人物在右边
function WndTeachTalk:setScene(scene)
    self.m_tScene = scene
end

--@brief    设置组Index
--@param    组
function WndTeachTalk:setGroupIndex(groupIndex, talkIndex)
    self.m_nGroupIndex = groupIndex
    self.m_nTalkIndex = talkIndex or 1
end

--@brief    设置是否战斗
--@param    是否战斗
function WndTeachTalk:setBattle(isBattle)
    self.m_bIsBattle = isBattle
end

--@brief    设置名字
--@param    是名字
function WndTeachTalk:setName(name)
    --WZLog("WndTeachTalk:setName", name)
    self.m_sName = name
end

--@brief    设置是否跳转场景
--@param    设置是否跳转
function WndTeachTalk:setReplaceScene(isReplace)
    WZLog("WndTeachTalk:setReplaceScene", isReplace)
    self.m_bIsReplaceScene = isReplace
end

--@brief    设置属于的教学步骤
--@param    是名字
function WndTeachTalk:setTeachStep(group, step)
    --WZLog("WndTeachTalk:setstep", group, step)
    self.m_nGroup = group
    self.m_nStep = step
end

--@brief 设置剧情完成状态
--@param nOpen:是否打开，0:不打开，1：打开
function WndTeachTalk:setStoryFinish(groupIndex)
    --WZLog("WndTeachTalk:setStoryFinish", tostring(groupIndex))
    --更新状态全局数据
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("StoryTalkData", "story_"..groupIndex, tostring(CacheCenter:getPlayerInfo().id or 1))
        data:flush()
    end
end

--@brief 获取剧情完成状态
function WndTeachTalk:isStoryFinish(groupIndex)

    local data = WZDataFile:getInstance():getUserData()
    if nil == data or CacheCenter:getPlayerInfo() == nil then
        return false
    end
    local isStoryFinish = data:getStringValue("StoryTalkData", "story_"..groupIndex)
    --WZLog("WndTeachTalk:isStoryFinish",isStoryFinish, type(isStoryFinish))
    if isStoryFinish == nil or isStoryFinish == "" or isStoryFinish == "0" or tonumber(isStoryFinish) ~= CacheCenter:getPlayerInfo().id then
        isStoryFinish = false
    elseif tonumber(isStoryFinish) == CacheCenter:getPlayerInfo().id then
        isStoryFinish = true
    end
    return isStoryFinish
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新说明
function WndTeachTalk:_update()
    --WZLog("WndTeachTalk:_update one")

    if self.m_tDetail and #self.m_tDetail > 0 then
        self:_setText(self.m_tDetail[1])
        WZLog("WndTeachTalk:_update one-0", tostring(self.m_nSound))
        if self.m_nSound then
            SoundManager:playEffectSound(getSoundByType(self.m_nSound))
        end
        table.remove(self.m_tDetail, 1)
    elseif self.m_tDetail then
        if self.m_nSound then
            SoundManager:stopEffectSound()
        end
        self.m_tDetail = nil
        if element == nil then
            --WZLog(" WndTeachTalk:onCloseClick(element) element is nil ")
        end

        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        local group, step, scene, isUpgrade, isReplaceScene, isUpgradeTeach, headList, isJump, buttonId, headTypeList, headFaceList, headFacePosList, index = 
        self.m_nGroup, self.m_nStep, self.m_tScene, self.m_bIsUpgrade, self.m_bIsReplaceScene, self.m_bIsUpgradeTeach, self.m_tHeadList0, 
        self.m_bIsJump, self.m_nTrailerButtonId, self.m_tHeadTypeList, self.m_tHeadFaceList, self.m_tHeadFacePosList, self.m_nIndex + 1
        WndTeachTalk:removeWindow()
        

        local info, info0
        -- for i ,v in pairs (GDatatab_story_talk) do
        --     if v.storyId == self.m_nGroupIndex and v.talkId == self.m_nTalkIndex + 1 then
        --         info = v
        --     end
        -- end

        info0 = GDatatab_story_talk["id_" .. index]
        if info0 and info0.storyId == self.m_nGroupIndex then
            info = info0
        end

        WZLog("WndTeachTalk:_update one-1", index, tostring(info))
        local isCreate = false
        if info then
            local name,head,objectType
            if info.objectType == 1 then
                name = CacheCenter:getPlayerInfo().name
                objectType = false
                if info.headType == nil or info.headType == 1 then
                    if info.headIndex ~= -1 then
                        if CacheCenter:getPlayerInfo().sex == 0 then
                            head = "common_pic_shuaige1_" .. info.headIndex
                        else
                            head = "common_pic_meinv1_" .. info.headIndex
                        end
                    elseif CacheCenter:getPlayerInfo().sex == 0 then
                        head = "common_pic_shuaige1"
                    else
                        head = "common_pic_meinv1"
                    end
                elseif info.headType == 2 then
                    if CacheCenter:getPlayerInfo().sex == 0 then
                        head = "master"
                    else
                        head = "instructor"
                    end
                end

                if head ~= headList[1] then
                    headList[1] = head
                    headTypeList[1] = info.headType
                    headFaceList[1] = info.face
                    headFacePosList[1] = info.facePos
                    WZLog("WndTeachTalk:_update two-00", headList[2], tostring(headTypeList[2]), tostring(headFaceList[2]), tostring(headFacePosList[2]))
                end
            else
                name = info.objectName
                head = info.headIndex
                objectType = true

                if head ~= headList[2] then
                    headList[2] = head
                    headTypeList[2] = info.headType
                    headFaceList[2] = info.face
                    headFacePosList[2] = info.facePos
                    WZLog("WndTeachTalk:_update two-0", headList[2], tostring(headTypeList[2]), tostring(headFaceList[2]), tostring(headFacePosList[2]))
                end
            end
            isCreate = true
            CreateStoryTalk(name, head, objectType, isReplaceScene, info.text, nil, self.m_nGroupIndex, self.m_nTalkIndex+1,self.m_bIsBattle, group, 
                step, scene, isUpgrade, isReplaceScene, isUpgradeTeach, headList, isJump, buttonId, nil, headTypeList, headFaceList, headFacePosList, index)
        elseif self.m_bIsBattle == true then
            SceneBattle:startSchedule()
        elseif isUpgrade == true then
            --WZLog("WndTeachTalk:_update three")
            GlobalGame:setIfInBattle(false)
        elseif isComment == true then
            WZLog("WndTeachTalk:_update four")
            goGoogleUrl(WndSingleCopy)
        else
            TeachGroup1:finishStep(group, step, scene)
        end

        WZLog("WndTeachTalk:_update two-1", tostring(buttonId), tostring(isReplaceScene), tostring(isCreate))

        -- if isReplaceScene ~= true and isCreate ~= true and CacheCenter:getPlayerInfo().level == 19 then
        --     local isFinish42, finishStep42 = TeachGroup1:isTeachFinish(42)
        --     if SceneCity.m_root and isFinish42 ~= true and finishStep42 >= 0 then
        --         WZLog("WndTeachTalk:_update two-3")
        --         --TeachGroup1:startGroupLevelUp(levelUp, true, nil, {42,2, SceneCity.m_root})
        --         Teach.OPEN_MODULE_MARK = true
        --         if SceneCity.m_root == nil then
        --             replaceScene(SceneCity:createElement())
        --         else
        --             SceneCity.m_bIsNoRelease = true
        --             replaceScene(SceneCity:createElement(true))
        --         end
        --         SceneRoom:exitRoom()
        --         SceneBossRoom:exitRoom()
        --         return
        --     end
        -- end

        if isCreate ~= true then
            if isReplaceScene == true then
                GlobalGame.m_nTrailerId = buttonId
                if SceneCity.m_root == nil then
                    replaceScene(SceneCity:createElement())
                else
                    SceneCity.m_bIsNoRelease = true
                    replaceScene(SceneCity:createElement(true))
                end
                WZLog("WndTeachTalk:_update two-2", isReplaceScene)
                Teach.OPEN_MODULE_MARK = true
                SceneRoom:exitRoom()
                SceneBossRoom:exitRoom()
            elseif buttonId then
                addTrailerAnim(buttonId)
            end

            if isUpgradeTeach and isReplaceScene ~= true and buttonId == nil then
                WndUpgrade:teach()
            end
        end
    end
end

--@brief   设置说明内容
--@paramtxt:说明内容
function WndTeachTalk:_setText(txt)
    local txtDesc = self.m_root:getChildElement("freetxtContent_WndTeachTalk")
    WZUIFreeTextBox:luaTo(txtDesc):setShowText(txt)
end

function WndTeachTalk:onClickSkill()
    WZLog("-------------------------------------------------------WndTeachTalk:onClickSkill")
    self.m_nIndex = 10000
end

--@brief  	更新滚动容器内部布局函数
function WndTeachTalk:_upDateMoveContainer()
	if self.m_root == nil then
		return
	end

    --WZLog("WndTeachTalk:_upDateMoveContainer", self.m_sName)

    if self.m_bIsBattle == true then
        self.m_root:setShowAll(false)
    else
        self.m_root:setShowAll(false)
    end

    local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachTalk"))
    ttf:setText(self.m_sName .. "：")

    if true then
        if self.m_bIsJump == nil or self.m_bIsJump == 0 then
            GetElement(self.m_root,"conTxtTop_WndTeachTalk"):setVisible(false)
            --GetElement(self.m_root,"conBgTop_WndTeachTalk"):setVisible(false)
        end

        if self.m_tHeadList[1] then
            if self.m_tHeadTypeList[1] == nil or self.m_tHeadTypeList[1] == 1 then
                WZLog("WndTeachTalk:_upDateMoveContainer111", self.m_tHeadList[1])
                WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachTalk")):setFile(self.m_tHeadList[1])
                
                local face = WZUI9Image:luaTo(GetElement(self.m_root,"imgFace_WndTeachTalk"))

                local pos = {x=0,y=0}
                local strFacePos = self.m_tHeadFacePosList[1]
                if strFacePos and type(strFacePos) == "table" then
                    pos.x = strFacePos[1][1]
                    pos.y = strFacePos[1][2]
                end
                if CacheCenter:getPlayerInfo().sex == 0 then
                    face:setAbsPosition(GlobalMethod:ccp(163+pos.x,212+pos.y))
                else
                    face:setAbsPosition(GlobalMethod:ccp(153+pos.x,231+pos.y))
                end

                local prefixFace
                if CacheCenter:getPlayerInfo().sex == 0 then
                    prefixFace = "nanzhujue_"
                else
                    prefixFace = "nvzhujue_"
                end

                local strFace = self.m_tHeadFaceList[1]
                if strFace and strFace ~= -1 then
                    face:setFile( "ui/combat/".. prefixFace .. strFace ..".png")
                    face:setVisible(true)
                else
                    face:setVisible(false)
                end

                if self.m_sIcon ~= self.m_tHeadList[1] then
                    WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachTalk")):setColor(ccc3(102,102,102))
                    face:setColor(ccc3(102,102,102))
                end
            else
                local spine = GetElement(self.m_root,"animImg_WndTeachTalk",WZUISpine)
                spine:setFileJson("city/"..self.m_tHeadList0[1]  .. ".json")
                spine:setFileAtlas("city/"..self.m_tHeadList0[1]  .. ".atlas")

                local action = "wait"
                local strFace = self.m_tHeadFaceList[1]
                if strFace and strFace ~= -1 then
                    action = strFace
                end 

                spine:setAnimationName(action)
                spine:setVisible(true)

                if self.m_sIcon ~= self.m_tHeadList[1] then
                    spine:setColor(ccc3(102,102,102))
                end

                WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachTalk")):setVisible(false)
                WZUI9Image:luaTo(GetElement(self.m_root,"imgFace_WndTeachTalk")):setVisible(false)
            end
        else
            WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachTalk")):setVisible(false)
            WZUI9Image:luaTo(GetElement(self.m_root,"imgFace_WndTeachTalk")):setVisible(false)
        end

        if self.m_tHeadList[2] then
            if self.m_tHeadTypeList[2] == nil or self.m_tHeadTypeList[2] == 1 then
                WZUI9Image:luaTo(GetElement(self.m_root,"imgImg1_WndTeachTalk")):setFile(self.m_tHeadList[2])

                local face = WZUI9Image:luaTo(GetElement(self.m_root,"imgFace1_WndTeachTalk"))

                local pos = {x=0,y=0}
                local strFacePos = self.m_tHeadFacePosList[2]
                if strFacePos and type(strFacePos) == "table" then
                    pos.x = strFacePos[1][1]
                    pos.y = strFacePos[1][2]
                end
                face:setAbsPosition(GlobalMethod:ccp(191+pos.x,214+pos.y))

                local strFace = self.m_tHeadFaceList[2]
                if strFace and strFace ~= -1 then
                    face:setFile( "ui/combat/".. strFace ..".png")
                    face:setVisible(true)
                else
                    face:setVisible(false)
                end

                if self.m_sIcon ~= self.m_tHeadList[2] then
                    WZUI9Image:luaTo(GetElement(self.m_root,"imgImg1_WndTeachTalk")):setColor(ccc3(102,102,102))
                    face:setColor(ccc3(102,102,102))
                end

            else
                local spine = GetElement(self.m_root,"animImg1_WndTeachTalk",WZUISpine)
                spine:setFileJson("city/"..self.m_tHeadList0[2]  .. ".json")
                spine:setFileAtlas("city/"..self.m_tHeadList0[2]  .. ".atlas")

                local action = "wait"
                local strFace = self.m_tHeadFaceList[2]
                if strFace and strFace ~= -1 then
                    action = strFace
                end 

                spine:setAnimationName(action)
                spine:setVisible(true)

                if self.m_sIcon ~= self.m_tHeadList[2] then
                    spine:setColor(ccc3(102,102,102))
                end

                WZUI9Image:luaTo(GetElement(self.m_root,"imgImg1_WndTeachTalk")):setVisible(false)
                WZUI9Image:luaTo(GetElement(self.m_root,"imgFace1_WndTeachTalk")):setVisible(false)
            end
        else
            WZUI9Image:luaTo(GetElement(self.m_root,"imgImg1_WndTeachTalk")):setVisible(false)
            WZUI9Image:luaTo(GetElement(self.m_root,"imgFace1_WndTeachTalk")):setVisible(false)
        end

        if self.m_bIsImgRight == true then

            -- GetElement(self.m_root,"imgArrow_WndTeachTalk"):setAnchorPoint(GlobalMethod:ccp(0,0))
            -- GetElement(self.m_root,"imgArrow_WndTeachTalk"):setRelativePosition(GlobalMethod:ccp(0.109007,0.0421502))

            -- GetElement(self.m_root,"conTxt_WndTeachTalk"):setAnchorPoint(GlobalMethod:ccp(0,0))
            -- GetElement(self.m_root,"conTxt_WndTeachTalk"):setRelativePosition(GlobalMethod:ccp(0.0802083,0.0296875))

            -- ttf:setRelativePosition(GlobalMethod:ccp(0.12,0.85))
            -- GetElement(self.m_root,"freetxtContent_WndTeachTalk"):setRelativePosition(GlobalMethod:ccp(0.12,0.6))


            -- GetElement(self.m_root,"conImg_WndTeachTalk"):setAnchorPoint(GlobalMethod:ccp(1,0))
            -- GetElement(self.m_root,"conImg_WndTeachTalk"):setRelativePosition(GlobalMethod:ccp(1,0))

            -- GetElement(self.m_root,"imgImg_WndTeachTalk"):setAnchorPoint(GlobalMethod:ccp(0,0))
            -- GetElement(self.m_root,"imgImg_WndTeachTalk"):setRelativePosition(GlobalMethod:ccp(1,0.0533253))
            -- GetElement(self.m_root,"imgImg_WndTeachTalk"):setScaleX(-1)
        end
    end

    local actionSequence = WZUIActionSequence:create()
    actionSequence:setIsLoop( false )
    local delay = WZUIActionDelayTime:create()
    delay:setDuration(0.3)
    actionSequence:setChildAction(delay)
    actionSequence:setFinishLuaTable(self)
    actionSequence:setFinishLuaFunction("updateOk")
    ttf:runUIAction( actionSequence )

end

--@brief    获取说明文本长度
--@return   #1,length :返回说明文本的高度
function WndTeachTalk:_getTxTLength()
	if self.m_root == nil then
		return
	end
	local txtTTF = self.m_root:getChildElement("txtIntro_WndTeachTalk")
	if txtTTF == nil then
		return
	end
	txtTTF = WZUILabelTTF:luaTo(txtTTF)
	local length = txtTTF:getLabelContentSize()
	return length.height
end

-------------------------------------私有方法模块End----------------------------------------
--描边字设置
function WndTeachTalk:_moreLanguageForStroke()
    --WZLog("WndTeachTalk:_moreLanguageForStroke")
	--确定
end

--@brief    中文适配函数
--@note     中文适配函数
function WndTeachTalk:_adaptLanguage_cn()
    --WZLog("WndTeachTalk:_adaptLanguage_cn")

end

--@brief    中文繁体适配函数
--@note     中文繁体适配函数
function WndTeachTalk:_adaptLanguage_hk()
    --WZLog("WndTeachTalk:_adaptLanguage_hk")

end

--@brief    英文适配函数
--@note     英文适配函数
function WndTeachTalk:_adaptLanguage_en()
    local txtSkill = GetElement(self.m_root,"txtSkill_WndTeachTalk",WZUILabelTTF)
    txtSkill:setRelativePosition(GlobalMethod:ccp(0.801736,0.961603))
    -- txtSkill:setDimensions(GlobalMethod:CCSize(200))
end

--@brief    泰文适配函数
--@note     泰文适配函数
function WndTeachTalk:_adaptLanguage_th()
    --WZLog("WndTeachTalk:_adaptLanguage_th")
    -- local txt = GetElement(self.m_root,"freetxtContent_WndTeachTalk",WZUIFreeTextBox)
    -- txt:setMaxWidth(600)
    -- txt:setScale(0.7)
end

--@brief    越南语适配函数
--@note     越南语适配函数
function WndTeachTalk:_adaptLanguage_vn()
    -- WZLog("WndTeachTalk:_adaptLanguage_vn")
    -- local txt = GetElement(self.m_root,"freetxtContent_WndTeachTalk",WZUIFreeTextBox)
    -- txt:setMaxWidth(600)
    -- txt:setScale(0.73)
end

--@brief    葡语适配函数
--@note     葡语适配函数
function WndTeachTalk:_adaptLanguage_pt()
    local txtSkill = GetElement(self.m_root,"txtSkill_WndTeachTalk",WZUILabelTTF)
    txtSkill:setRelativePosition(GlobalMethod:ccp(0.861736,0.961603))
end

--@brief    土耳其适配函数
--@note     土耳其适配函数
function WndTeachTalk:_adaptLanguage_tr()
    WZLog("WndTeachTalk:_adaptLanguage_pt")
    local txt = GetElement(self.m_root,"txtSkill_WndTeachTalk",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.872153,0.961603))
end

function WndTeachTalk:_adaptLanguage_es()
    local txtSkill = GetElement(self.m_root,"txtSkill_WndTeachTalk",WZUILabelTTF)
    txtSkill:setRelativePosition(GlobalMethod:ccp(0.861736,0.961603))
end