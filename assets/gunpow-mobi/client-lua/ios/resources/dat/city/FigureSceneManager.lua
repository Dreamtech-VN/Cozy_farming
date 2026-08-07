--FigureSceneManager.lua
--@brief	FigureSceneManager
--@date		2015/3/27
--@author	莫剑峰
--@note		人物场景管理类

--@brief	人物场景管理类数据表
FigureSceneManager =
{
    m_nReference = 1,			--引用计数
    m_tScene = nil,             --当前场景
    m_tFigureLayer = nil,       --人物层
    m_scheduleId = -1,          --计时器更新
    m_tFigureList = nil,        --人物列表
    m_tPosForFigureLayer = nil,
    m_nMoveElemPosX = 0,
    m_tFigureCreateList = nil,
    m_bIsInitMyself = nil,
    m_bIsStatue = nil,
    m_bCanUpdate = nil,
    m_bIsCreateOther = nil,
    m_bIsCreateOtherFigure = nil,
    m_bIsScore = nil,
}


-------------------------------------公有方法模块Begin--------------------------------------

local g_figureSceneManager = nil

--@brief	获取人物场景管理对象
--@return	FigureSceneManager管理类
function FigureSceneManager:getInstance()
    if not g_figureSceneManager then
        FigureSceneManager:_init()
        CacheCenter:registerUpatePlayerPetInfoObserver(FigureSceneManager)
    end
    return g_figureSceneManager
end

--@brief	释放
function FigureSceneManager:release()
    --WZLog("FigureSceneManager:release one", self.m_nReference)

    self.m_nReference = self.m_nReference - 1
    if self.m_nReference <=0 then
        if self.m_scheduleId ~= -1 then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
            self.m_scheduleId = -1
        end

        if self.m_tFigureList then
            for i , v in pairs (self.m_tFigureList) do
                if self.m_tFigureList[i] then
                    self.m_tFigureList[i]:destroy()
                    self.m_tFigureList[i] = nil
                end
            end
        end

        self.m_bIsCreateOther = nil
        self.m_tFigureCreateList = {}
        self:destroyNpc3()

        self.m_nReference = 0

        self.m_tScene = nil
        self.m_bIsInitMyself = nil
        self.m_bCanUpdate = nil
        self.m_bIsCreateOtherFigure = nil
        --WZLog("FigureSceneManager:release two")
        g_figureSceneManager = nil
    end
end

--@brief	删除其他人物
function FigureSceneManager:deleteOtherFigure()
    if self.m_tFigureList then
        for i , v in pairs (self.m_tFigureList) do
            if self.m_tFigureList[i] and self.m_tFigureList[i].m_nFigureType == FigureType.Other then
                self.m_tFigureList[i]:destroy()
                self.m_tFigureList[i] = nil
            end
        end
    end
    self.m_bIsCreateOther = nil
    self.m_tFigureCreateList = {}
end

--更新自己的信息
function FigureSceneManager:updatePlayerPetInfoData()
    --WZLog("FigureSceneManager:updatePlayerPetInfoData one")
    local figure = FigureSceneManager:getInstance().m_tFigure
    local info = nil
    if figure then
        --figure:setPet()
    end
end

--@brief    创建npc3
function FigureSceneManager:createNpc3(note)
    WZLog("FigureSceneManager:createNpc3", note, tostring(self.m_tNpc3), tostring(self.m_tFigureLayer))
    if self.m_tNpc3 or self.m_tFigureLayer == nil then
        return
    end

    local anim, _x, _y, isMonster = CreatePlayerFigure(0, {[1]=4122,[2]=4322,[3]=4522,[4]=0},nil,nil,nil,nil,nil,nil,nil,nil,0,0)
    self.m_tFigureLayer:addChild(anim:getAnimNode())
    anim:getAnimNode():setTouchEnable(false)
    anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.0))
    anim:getAnimNode():setPosition(280,130)
    anim:getAnimNode():setScale(0.6)
    self.m_tNpc3 = anim
end

--@brief    destroynpc3
function FigureSceneManager:destroyNpc3()
    WZLog("FigureSceneManager:destroyNpc3", tostring(self.m_tNpc3), tostring(self.m_tFigureLayer))
    if self.m_tNpc3 then
        self.m_tNpc3:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tNpc3 = nil
    end
end

--初始化位置
function FigureSceneManager:initPos()
    --WZLog("FigureSceneManager:initPos one",GlobalGame.g_nFigureSceneId, Chat_Channel_Island, tostring(self.m_tFigure), tostring(GlobalGame.g_nMoveEndPointXNowMoveElement))

    --do return end
    if GlobalGame.g_nFigureSceneId == Chat_Channel_Island and self.m_tFigure and GlobalGame.g_nMoveEndPointXNowMoveElement then


        local x = GlobalGame.g_nMoveEndPointXNowMoveElement * -1 + 1200 + FigureSceneManager:getInstance().m_nScreenWidth / 2
        if x <= 300 then
            WZLog("FigureSceneManager:initPos two-0")
            x = 401
        end
        local _,y = self.m_tFigure:getPositionOffset(x)
        WZLog("FigureSceneManager:initPos two-1",GlobalGame.g_nMoveEndPointXNowMoveElement, x, y)

            if TeachGroup1.GROUP ~= 20 or (TeachGroup1.GROUP == 20 and TeachGroup1.STEP ~= 1) then
                self.m_tFigure:setPosition(BattleCommon:getPointTable(x, y))
            end

        GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    end
end

--@brief    初始化人物
function FigureSceneManager:initFigure()
    WZLog("FigureSceneManager:initFigure", tonumber(nPetId))

    local figure = Figure:create(CacheCenter:getEquipmentList(), CacheCenter.m_tPlayerInfo.sex, FigureType.Myself, CacheCenter.m_tPlayerInfo.name, CacheCenter.m_tPlayerInfo.id, true, true, CacheCenter.m_tPlayerInfo.level, CacheCenter.m_tPlayerInfo.title,nil,CacheCenter:getUsingFootMarkId())
    figure:setScene(self.m_tScene)

    self.m_tFigure = figure

    table.insert(self.m_tFigureList, figure)

    if true then
        if GlobalGame.g_nFigureSceneId == Chat_Channel_Guild_Scene then
            self.m_tFigureLayer:addChild(figure.m_tUINode,2)
        else
            self.m_tFigureLayer:addChild(figure.m_tUINode,3)
        end
        figure.m_anim:getAnimNode():setScale(figure.m_nScale)
        if figure.m_bIsMount == true then
            figure.m_tUINode:setContentSize(GlobalMethod:CCSize(150 ,160))
            figure.m_anim:setPosition(Vector2:create(60, -10))
        else
            figure.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
            figure.m_anim:setPosition(Vector2:create(25, -12))
        end

        figure.m_tBornAnim = BattleAnimation:createAnimation("ui_main_teleport",false,"city")
        figure.m_tBornAnim:getAnimNode():setUseAbsCoordinate(true)
        local bornAnimPos = nil
        if figure.m_bIsMount ~= true then
            bornAnimPos = GlobalMethod:ccp(35,330)
        else
            bornAnimPos = GlobalMethod:ccp(70,330)
        end
        figure.m_tBornAnim:getAnimNode():setAbsPosition(bornAnimPos)
        figure.m_tUINode:addChild(figure.m_tBornAnim:getAnimNode())
        figure.m_tBornAnim:play("1",false)
    else
        self.m_tFigureLayer:addChild(figure.m_tNode,3)
    end


    figure.m_anim:getAnimNode():setScale(figure.m_nScale)
    figure:setPet()
    --figure:addEtcAnim(false)
    figure:setPosition(BattleCommon:getPointTable(figure:getPositionOffset(490))) --
    --WZLog("FigureSceneManager:initFigure two")
    figure:createName()
    self:initPos()

    --do return end
    local count = 0
    for i = 1, count do
        local number = 90 + i
        if number == 451 then
            number = 471
        end
        local myId = self.m_tFigure and self.m_tFigure.m_nFigureId
        if number == myId then
            if myId == 1 then
                number = 2
            else
                number = 1
            end
        end
        ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(number)
    end

    --do return end

    --WZLog("FigureSceneManager:initFigure", tostring(CacheCenter:getGameParam().gameStatus))
    if GlobalGame.g_nFigureSceneId == Chat_Channel_Island and  CacheCenter:getGameParam().gameStatus ~= "1" and self.m_bIsInitMyself ~= true then
        for i = 1, 3 do
            if i == 1 and CheckButtonShow(ISLAND_NPC_INSTRUCTOR) or i == 2 and CheckButtonShow(ISLAND_NPC_TEACHER) or i == 3 then

                local name = "NPC"
                local title = ""
                name = LocalStrings["NPC_NAME_"..i] or ""
                title = "" --"LocalStrings["NPC_TITLE_"..i] --"
                local figure = Figure:create(i,1, FigureType.Npc, name, i, true, true,1,title)
                figure:setScene(self.m_tScene)

                if true then
                    self.m_tFigureLayer:addChild(figure.m_tUINode,1)
                    figure.m_anim:getAnimNode():setScale(figure.m_nScale)
                    if i == 1 then
                        figure.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,110))
                        figure.m_anim:setPosition(Vector2:create(25, -4))
                    elseif i == 2 then
                        figure.m_tUINode:setContentSize(GlobalMethod:CCSize(80 ,200))
                        figure.m_anim:setPosition(Vector2:create(20, -2))
                    elseif i == 3 then
                        figure.m_tUINode:setContentSize(GlobalMethod:CCSize(140 ,200))
                        figure.m_anim:setPosition(Vector2:create(20, -2))
                    end
                else
                    self.m_tFigureLayer:addChild(figure.m_tNode,1)
                end

                figure:play(figure:getStandbyAnimName(), true)
                figure:createName()
                --figure:play(figure:getMoveAnimName(), false)

                if i == 1 then
                    figure:setPosition(BattleCommon:getPointTable(801, 225))
                elseif i == 2 then
                    --figure:addEtcAnim(false)
                    figure:setPosition(BattleCommon:getPointTable(1855, 224))
                    figure:setFlipX(false)
                elseif i == 3 then
                    figure:setPosition(BattleCommon:getPointTable(1630, 214))
                elseif i == 4 then
                    figure:setPosition(BattleCommon:getPointTable(1800, 230))
                end
                table.insert(self.m_tFigureList, figure)
            end
        end
    end
end

--@brief    创建其它人物
function FigureSceneManager:saveOtherFigures(sceneFigureInfoList)
    WZLog("FigureSceneManager:saveOtherFigures zero", tostring(self.m_bIsCreateOther))

    if self.m_bIsCreateOther == true and GlobalGame.g_nFigureSceneId == Chat_Channel_Island then
        return
    end
    
    self.m_bIsCreateOtherFigure = true

    --do return end
    if self.m_tFigureCreateList == nil then
        for j, figureNew in pairs (sceneFigureInfoList) do
            --WZLog("FigureSceneManager:saveOtherFigures one-1", tostring(figureNew.sceneId), GlobalGame.g_nFigureSceneId)
            if figureNew.sceneId == nil or figureNew.sceneId == -1 or figureNew.sceneId == GlobalGame.g_nFigureSceneId then
                self.m_tFigureCreateList = sceneFigureInfoList
                self.m_bIsCreateOther = true
            end
        end
    else
        for j, figureNew in pairs (sceneFigureInfoList) do
            local isExist = nil
            --WZLog("FigureSceneManager:saveOtherFigures one-2", tostring(figureNew.sceneId), GlobalGame.g_nFigureSceneId)
            if figureNew.sceneId == nil or figureNew.sceneId == -1 or figureNew.sceneId == GlobalGame.g_nFigureSceneId then
                for i , v in pairs (self.m_tFigureCreateList) do
                    if self.m_tFigureCreateList[i] then
                        local figure = self.m_tFigureCreateList[i]
                        if figure then
                            if figureNew.playerId == figure.playerId then
                                isExist = true
                                WZLog("FigureSceneManager:saveOtherFigures two", j, i, figureNew.playerId, figureNew.playerName)
                                self.m_tFigureCreateList[i] = nil
                            end
                        end
                    end
                end
                if isExist == nil then
                    table.insert(self.m_tFigureCreateList, figureNew)
                    self.m_bIsCreateOther = true
                end
            end
        end
    end
end

--@brief    创建其它人物
function FigureSceneManager:createOtherFigures(sceneFigureInfoList, isStatue)
    WZLog("FigureSceneManager:createOtherFigures zero")

    --do return end
    if self.m_tFigureLayer == nil or sceneFigureInfoList == nil or CacheCenter:getPlayerInfo() == nil then
        return
    end

    for id, info in pairs (sceneFigureInfoList) do
        if isStatue or CacheCenter:getPlayerInfo().id ~= info.playerId then

            local figureIndex = -1
            local figureName

            if isStatue ~= true then
                for index, figure in pairs (self.m_tFigureList) do
                    if figure.m_tPlayerInfo ~= nil and info.playerId == figure.m_tPlayerInfo.id and figure.m_nFigureType ~= FigureType.Statue and figure.m_nFigureType ~= FigureType.Score then
                        figureIndex = index
                        figureName = figure.playerName
                    end
                end
            end

            WZLog("FigureSceneManager:createOtherFigures one", figureIndex, figureName)
            if figureIndex ~= -1 then
                self.m_tFigureList[figureIndex]:destroyAnim()
            else
                --WZLog("FigureSceneManager:createOtherFigures two", tostring(isStatue), info.headId, info.faceId, info.bodyId)
                --info.headId = 4903
                local playerInfo = {}
                local playerEquip = {}
                table.insert(playerEquip, info.headId)
                table.insert(playerEquip, info.faceId)
                table.insert(playerEquip, info.bodyId)
                table.insert(playerEquip, info.wingId)
                if info.mountsId and info.mountsId > 0 and GDatatab_mounts["id_"..info.mountsId] then
                    table.insert(playerEquip, GDatatab_mounts["id_"..info.mountsId].item_id)
                end
                if info.headId ~= 0 and GDatatab_item["id_"..info.headId] ~= nil then
                    playerInfo.head = GDatatab_item["id_"..info.headId].animation_index_code
                else
                    playerInfo.head = nil
                end

                if info.faceId ~= 0 and GDatatab_item["id_"..info.faceId] ~= nil then
                    playerInfo.face = GDatatab_item["id_"..info.faceId].animation_index_code
                else
                    playerInfo.face = nil
                end

                if info.bodyId ~= 0 and GDatatab_item["id_"..info.bodyId] ~= nil then
                    playerInfo.body = GDatatab_item["id_"..info.bodyId].animation_index_code
                else
                    playerInfo.body = nil
                end

                if info.wingId > 0 and GDatatab_item["id_"..info.wingId] ~= nil then
                    playerInfo.wing = GDatatab_item["id_"..info.wingId].animation_index_code
                else
                    playerInfo.wing = nil
                end


                if info.mountsId and info.mountsId > 0 and GDatatab_mounts["id_"..info.mountsId] and GDatatab_item["id_"..GDatatab_mounts["id_"..info.mountsId].item_id] then
                    playerInfo.mountsId =  GDatatab_item["id_"..GDatatab_mounts["id_"..info.mountsId].item_id].animation_index_code
                    playerInfo.mountsType = GDatatab_item["id_"..GDatatab_mounts["id_"..info.mountsId].item_id].sub_type
                else
                    playerInfo.mountsId = 0
                    --WZLog("FigureSceneManager:createOtherFigures ZZ", playerInfo.mountsId)
                end

                playerInfo.colour = info.colour
                playerInfo.bodyColour = info.bodyColour
                playerInfo.id = info.playerId                       --Id
                playerInfo.name = info.playerName                   --名称
                playerInfo.sex = info.playerSex or 1                --性别
                playerInfo.title = info.playerTitle                 --称号
                playerInfo.level = info.playerLevel                 --等级
                playerInfo.petInfo = info.petId ~= "" and {animation=info.petId, advancedLevel=info.petLevel ~="" and tonumber(info.petLevel) or nil, petSkinItemId = info.petSkinItemId} or nil                   --宠物Id
                --playerInfo.petInfo = {animation=GDatatab_item["id_"..info.petId].animation_index_code}                      --宠物Id
                playerInfo.mountsInfo = info.mountsInfo                 --坐骑Id
                playerInfo.isMate = info.isMate                     --是否伴侣
                playerInfo.footId  = info.footmark
                playerInfo.childMes = info.childMes                 --小孩数据json格式
                if isStatue then
                    if self.m_bIsStatue == true and info.statueType == 1 then
                        if self.m_tFigureList then
                            for i , v in pairs (self.m_tFigureList) do
                                if self.m_tFigureList[i] and self.m_tFigureList[i].m_nFigureType == FigureType.Statue then
                                    self.m_tFigureList[i]:destroy()
                                    self.m_tFigureList[i] = nil
                                    break
                                end
                            end
                        end
                    end
                    if self.m_bIsScore == true and info.statueType == 2 then
                        if self.m_tFigureList then
                            for i , v in pairs (self.m_tFigureList) do
                                if self.m_tFigureList[i] and self.m_tFigureList[i].m_nFigureType == FigureType.Score then
                                    self.m_tFigureList[i]:destroy()
                                    self.m_tFigureList[i] = nil
                                    break
                                end
                            end
                        end
                    end

                    local nTempStatue = FigureType.Statue
                    if info.statueType == 1 then
                        self.m_bIsStatue = true
                    elseif info.statueType == 2 then
                        self.m_bIsScore = true
                        nTempStatue = FigureType.Score
                    end

                    local figure = Figure:create(playerInfo, playerInfo.sex, nTempStatue, playerInfo.name, playerInfo.id, true, true, playerInfo.level, playerInfo.title, playerEquip,playerInfo.footId)
                    if figure then
                        figure.m_tPlayerInfo = playerInfo
                        figure:setScene(self.m_tScene)
                        figure:createName()
                        table.insert(self.m_tFigureList, figure)
                        local scene = WZUIContainer:luaTo(SceneCity.m_root:getChildElement("conStatue"))

                        if true then
                            self.m_tFigureLayer:addChild(figure.m_tUINode)
                            figure.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
                            figure.m_anim:setPosition(Vector2:create(25, -12))
                            --figure.m_tBornAnim:getAnimNode():setRelativePositionLuaTo(0.5,1)
                            --figure.m_tBornAnim:play("0",false)

                            figure.m_tBornAnim = BattleAnimation:createAnimation("ui_main_teleport",false,"city")
                            figure.m_tBornAnim:getAnimNode():setUseAbsCoordinate(true)
                            local bornAnimPos = nil
                            if figure.m_bIsMount ~= true then
                                bornAnimPos = GlobalMethod:ccp(35,330)
                            else
                                bornAnimPos = GlobalMethod:ccp(70,330)
                            end
                            figure.m_tBornAnim:getAnimNode():setAbsPosition(bornAnimPos)
                            figure.m_tUINode:addChild(figure.m_tBornAnim:getAnimNode())
                            figure.m_tBornAnim:play("1",false)
                        else
                            scene:addChild(figure.m_tNode)
                        end
                        figure.m_anim:getAnimNode():setScale(figure.m_nScale)
                        local posx, posy = 2352, 262
                        if info.statueType == 2 then
                            figure.m_tUINode:setContentSize(GlobalMethod:CCSize(80, 200))
                            posx, posy = 1350, 268
                        end
                        figure:setPosition(BattleCommon:getPointTable(posx, posy))
                        figure:setVisible(true)
                        figure:setFlipX(false)
                        --figure:setPet()
                        WZLog("FigureSceneManager:createOtherFigures two-1111")

                    end

                else
                    local figure = Figure:create(playerInfo, playerInfo.sex, FigureType.Other, playerInfo.name, playerInfo.id, true, true, playerInfo.level, playerInfo.title, playerEquip,playerInfo.footId)
                    if figure then
                        figure.m_tPlayerInfo = playerInfo
                        figure:setScene(self.m_tScene)
                        table.insert(self.m_tFigureList, figure)
                        figure:createName()
                        if true then
                            self.m_tFigureLayer:addChild(figure.m_tUINode,1)
                            if figure.m_bIsMount == true then
                                figure.m_tUINode:setContentSize(GlobalMethod:CCSize(150 ,160))
                                figure.m_anim:setPosition(Vector2:create(60, -10))
                                --WZLog("FigureSceneManager:createOtherFigures two-5")
                            else
                                figure.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
                                figure.m_anim:setPosition(Vector2:create(25, -12))
                            end
                                --figure.m_tBornAnim:getAnimNode():setRelativePositionLuaTo(0.5,1)
                                --figure.m_tBornAnim:play("0",false)
                                figure.m_tBornAnim = BattleAnimation:createAnimation("ui_main_teleport",false,"city")
                                figure.m_tBornAnim:getAnimNode():setUseAbsCoordinate(true)
                                if figure.m_bIsMount ~= true then
                                    bornAnimPos = GlobalMethod:ccp(35,330)
                                else
                                    bornAnimPos = GlobalMethod:ccp(70,330)
                                end
                                figure.m_tBornAnim:getAnimNode():setAbsPosition(bornAnimPos)
                                figure.m_tUINode:addChild(figure.m_tBornAnim:getAnimNode())
                                figure.m_tBornAnim:play("1",false)
                        else
                            self.m_tFigureLayer:addChild(figure.m_tNode,1)
                        end
                        figure.m_anim:getAnimNode():setScale(figure.m_nScale)
                        --figure:addEtcAnim(false)
                        --figure:play(figure:getStandbyAnimName(), true,"combatboy_hair3")
                        --WZLog("FigureSceneManager:createOtherFigures two-1")
                        local posx = math.random(300,2100)

                        local list = FigureSceneManager:getInstance().m_tFigureList

                        local leftCount, centerCount,rightCount = 0,0,0
                        for i, figure in pairs(list) do
                            if true or (figure.m_nFigureType ~= FigureType.Npc and figure.m_nFigureType ~= FigureType.Statue and figure.m_nFigureId ~= playerInfo.id and figure.m_nFigureType ~= FigureType.Score) then
                                local pos = figure.m_nRandomPos or figure:getPositionX()
                                --WZLog("Figure:randomActionOther s2-1", figure.m_nFigureId, pos)
                                if pos <= 880 then
                                    leftCount = leftCount+1
                                elseif pos < 1270 and pos > 880 then
                                    centerCount = centerCount+1
                                elseif pos >= 1270 then
                                    rightCount = rightCount+1
                                end
                            end
                        end

                        local area = math.min(leftCount , centerCount, rightCount)
                        local dire = math.random(1,100) > 50 and 1 or 2
                        if area == leftCount then
                            if dire == 1 then
                                posx = math.random(310,490)
                            else
                                posx = math.random(610,800)
                            end
                        elseif area == centerCount then
                            if dire == 1 then
                                posx = math.random(1170,1430)
                            else
                                posx = math.random(1170,1430)
                            end
                        elseif area == rightCount then
                            if dire == 1 then
                                posx = math.random(1610,1790)
                            else
                                posx = math.random(1910,2180)
                            end
                        end

                        local posx, posy = figure:getPositionOffset(posx)
                        figure:setPosition(BattleCommon:getPointTable(posx, posy))
                        figure:setPet()
                        figure:setVisible(self.m_nOtherVisible ~= 1)


                        --WZLog("Figure:randomActionOther s2-2", figure.m_nFigureId, figure.m_sName, area, leftCount, centerCount, rightCount, posx)
                    end
                end
                --WZLog("FigureSceneManager:createOtherFigures two-2", id,tostring(playerInfo.head), tostring(playerInfo.face), tostring(playerInfo.body), tostring(playerInfo.wing))
            end
        end
    end
end

--@brief	点击场景
function FigureSceneManager:onClickBg(element,event,x,y)


    if GlobalGame.g_nFigureSceneId ~= Chat_Channel_Island then
        return
    end

    local size = self.m_tScene.m_tSceneLayer:getContentSize();
    local pointMove = GlobalMethod:ccp(size.width,0);
    pointMove = self.m_tScene.m_tSceneLayer:convertToWorldSpace(pointMove);
    pointMove = self.m_tScene.m_tPlayerLayer:convertToNodeSpace(pointMove);
    local point = self.m_tScene.m_tPlayerLayer:convertToNodeSpace(GlobalMethod:ccp(x,y));

    --WZLog("FigureSceneManager:onClickBg zero",event, pointMove.x, self.m_tMoveElement:getRelativePosition().x)

    if event == "TouchEnded" or event == "MoveEnd" then
        --WZLog("FigureSceneManager:onClickBg two-1", pointMove.x, self.m_tMoveElement:getRelativePosition().x)
        self.m_nMoveDt = os.time()

        self.m_nMoveEndPointXNow = pointMove.x

        self.m_nMoveElemPosX = self.m_tMoveElement:getRelativePosition().x
        
    end

    if event == "TouchEnded" or event == "MoveEnd" then
        if self.m_bIsClickOther == false then
            self:onOtherHide()
        end
    end

    if GlobalGame.g_nFigureSceneId == Chat_Channel_Island and event == "TouchEnded" and self.m_tFigure then
        -- local isMove = self.m_tFigure:isMove(point)
        -- WZLog("FigureSceneManager:onClickBg",  point.x, point.y, tostring(isMove))
        -- if isMove then
        --     local w = FigureSceneManager:getInstance().m_nScreenWidth
        --     local y = (1517/w + (1517-w)/w) / (2812-w)
        --     local z = y*((2812-w)-(point.x-w/2)) - (1517-w)/w

        --     if z > 1517/w then
        --         z = 1517/w
        --     elseif z < (w-1517)/w then
        --         z = (w-1517)/w
        --     end

        --     --self.m_tMoveElement:setRelativePositionLuaTo(z, self.m_tMoveElement:getRelativePosition().y)
        --     self.m_nMoveStart = self.m_tMoveElement:getRelativePosition().x
        --     self.m_nMoveEnd = z

        --     self.m_nFigureMoveStart = self.m_tFigure:getPosition()
        --     self.m_nFigureMoveEnd = {x=point.x, y=point.y+ 55}
        -- end
    end

    self.m_bIsClickOther = false
end

--@brief	开始移动
function FigureSceneManager:startMoveCallback(element,node,x,y)
    --WZLog("FigureSceneManager:startMoveCallback",x,y)
    self.m_tFigure:playMove(true)
end

--@brief	移动中
function FigureSceneManager:nextMoveCellCallback(element,node,x,y,index)
    local pointX = node:getPositionX()
    self.m_tFigure:playMove(true)
    --WZLog("FigureSceneManager:nextMoveCellCallback",pointX,x,y,index)
    if pointX > x then
        self.m_tFigure:setFlipX(true)
    else
        self.m_tFigure:setFlipX(false)
    end
end

--@brief	结束移动
function FigureSceneManager:endMoveCallback(element,node)
    --WZLog("FigureSceneManager:endMoveCallback")
    self.m_tFigure:playMove(false)
end

--@brief	定时更新函数
function FigureSceneManager:update(dt0)

    local intervalTime = 0.0333
    if self.m_bCanUpdate then
        if self.m_nReference <= 0 then
            --WZLog("FigureSceneManager_update wrong")
            return
        end
        --do return end
        self.m_nFrame = self.m_nFrame + 1
        local dt = os.time()

        --WZLog("FigureSceneManager_update zero-0", tostring(intervalTime), dt, tostring(self.m_nMoveDt))

        if WindowManagerAni.m_nAppearTimes == 0 then
            ----WZLog("FigureSceneManager:updateControl zero-1")
            if GlobalGame.g_nFigureSceneId == Chat_Channel_Island and self.m_bIsInitMyself == nil then
                self:initFigure()
                self.m_bIsInitMyself = true
            end
            if self.m_tFigureCreateList ~= nil and self.m_nFrame - self.m_nFrameFigureCreate >= 60 and SceneCity.m_currentFullScreenCount <= 0 and self.m_nOtherVisible ~= 1 then
                self.m_nFrameFigureCreate = self.m_nFrame
                for i, v in pairs (self.m_tFigureCreateList) do
                    if v then
                        local figure = {self.m_tFigureCreateList[i]}
                        self:createOtherFigures(figure)
                        self.m_tFigureCreateList[i] = nil
                        break
                    end
                end
            end
        end

        if self.m_tMoveElement ~= nil and GlobalGame.g_nFigureSceneId == Chat_Channel_Island then
            local pos = self.m_tMoveElement:getPositionX()
            GlobalGame.g_nMoveEndPointXNowMoveElement = pos
            if SceneCity.m_tArmatureSunshine then
                local posX = GlobalGame.g_nMoveEndPointXNowMoveElement
                if posX >= 557 then
                    if SceneCity.m_tArmatureSunshine:isVisible() == false then
                        SceneCity.m_tArmatureSunshine:setVisible(true)
                    end
                    posX = posX - 557
                    local name = "step".. math.floor(posX/8)
                    --WZLog("FigureSceneManager:initPos three", GlobalGame.g_nMoveEndPointXNowMoveElement, name, screenLeft, screenRight)
                    SceneCity.m_tArmatureSunshine:setAnimationName(name)
                elseif SceneCity.m_tArmatureSunshine:isVisible() == true then
                    SceneCity.m_tArmatureSunshine:setVisible(false)
                end
            end


        end

        if GlobalGame.g_nMoveEndPointXNowMoveElement == nil then
            return
        end

        local offset = 0
        local screenLeft = (1517 - GlobalGame.g_nMoveEndPointXNowMoveElement) * (2834/3034)
        local screenRight = screenLeft + self.m_nScreenWidth + offset
        screenLeft = screenLeft - offset

        if screenLeft ~= self.m_nScreenLeft and screenRight ~= self.m_nScreenRight then
            --WZLog("FigureSceneManager:updateControl four", GlobalGame.g_nMoveEndPointXNowMoveElement, screenLeft, screenRight)
            --self.m_tFigure:setPosition({x=960, y=220})
        end
        self.m_nScreenLeft = screenLeft
        self.m_nScreenRight = screenRight


        -- if self.m_nMoveStart and self.m_nMoveEnd then
        --     if math.abs(self.m_nMoveStart - self.m_nMoveEnd) > 0.01 then
        --         local speed = 0.2
        --         if self.m_nMoveStart < self.m_nMoveEnd then
        --             speed = 1 * speed
        --         else
        --             speed = -1 * speed
        --         end
        --         self.m_nMoveStart = self.m_nMoveStart + speed/30
        --         self.m_tMoveElement:setRelativePositionLuaTo(self.m_nMoveStart, self.m_tMoveElement:getRelativePosition().y)
        --     else
        --         self.m_nMoveEnd = nil
        --     end
        -- end
        --
        -- if self.m_nFigureMoveStart and self.m_nFigureMoveEnd then
        --     local disx = math.abs(self.m_nFigureMoveStart.x - self.m_nFigureMoveEnd.x)
        --     local disy = math.abs(self.m_nFigureMoveStart.y - self.m_nFigureMoveEnd.y)

        --     --WZLog("FigureSceneManager:update one", self.m_nFigureMoveStart.x, self.m_nFigureMoveEnd.x, self.m_nFigureMoveStart.y, self.m_nFigureMoveEnd.y, disx)
        --     if disx > 10 or disy > 10 then
        --         local speed = 5
        --         if disx > 10 and self.m_nFigureMoveStart.x < self.m_nFigureMoveEnd.x then
        --             speed = 1 * speed
        --             self.m_tFigure:setFlipX(true)
        --         elseif disx > 10 and self.m_nFigureMoveStart.x > self.m_nFigureMoveEnd.x then
        --             speed = -1 * speed
        --             self.m_tFigure:setFlipX(false)
        --         else
        --             speed = 0
        --         end

        --         local speedY = 5
        --         if disy > 10 and self.m_nFigureMoveStart.y < self.m_nFigureMoveEnd.y then
        --             speedY = 1 * speedY
        --         elseif disy > 10 and self.m_nFigureMoveStart.y > self.m_nFigureMoveEnd.y then
        --             speedY = -1 * speedY
        --         else
        --             speedY = 0
        --         end
  
        --         self.m_nFigureMoveStart.x = self.m_nFigureMoveStart.x + speed
        --         self.m_nFigureMoveStart.y = self.m_nFigureMoveStart.y + speedY
        --         --WZLog("FigureSceneManager:update two", self.m_nFigureMoveStart.x)
        --         self.m_tFigure:setPosition(BattleCommon:getPointTable(self.m_nFigureMoveStart.x, self.m_nFigureMoveStart.y))
        --         self.m_tFigure:playMove(true)
        --         self.m_tFigure.m_nDire = 1
        --     else
        --         --WZLog("FigureSceneManager:update three")
        --         self.m_nFigureMoveEnd = nil
        --         self.m_tFigure:playMove(false)
        --         self.m_tFigure.m_nDire = -1
        --     end
        -- end


        if self.m_nMoveDt ~= nil and dt - self.m_nMoveDt >= 1 then
            self.m_nMoveDt = nil

            if self.m_tFigure ~= nil then
                local x = self.m_nMoveEndPointXNow
                local posCur = self.m_tFigure:getPosition()
                local posTaget = {x=posCur.x, y=posCur.y}
                
                local speed = self.m_tFigure.m_nSpeed * 1 
                if self.m_tFigure.m_bIsMount == true then
                    speed = self.m_tFigure.m_nSpeedMount
                end
                local distance = 0
                local movePos,posx,posy = nil
                local curx = posCur.x
                --WZLog("FigureSceneManager:updateControl zero", self.m_nMoveEndPointXNow, self.m_tMoveEndPointX, curx, self.m_nScreenWidth)

                if curx <= self.m_nMoveEndPointXNow - self.m_nScreenWidth or curx >= self.m_nMoveEndPointXNow then
                    if math.abs((x - self.m_nScreenWidth / 2) - posCur.x) > 10 and x > self.m_tMoveEndPointX then
                        if x - posCur.x > self.m_nScreenWidth then
                            posCur.x = x - self.m_nScreenWidth
                            self.m_tFigure.m_nDire = 1

                            --WZLog("FigureSceneManager:updateControl one-1")
                        end
                        self.m_tFigure:setFlipX(true)
                        --WZLog("FigureSceneManager:updateControl one-11", self.m_nMoveEndPointXNow, self.m_tMoveEndPointX, self.m_nMoveElemPosX, curx)
                    elseif math.abs((x - self.m_nScreenWidth / 2) - posCur.x) > 10 then
                        if posCur.x - x > 0 then
                            posCur.x = x + 0
                            self.m_tFigure.m_nDire = 0

                            --WZLog("FigureSceneManager:updateControl one-2")
                        end
                        self.m_tFigure:setFlipX(false)
                        --WZLog("FigureSceneManager:updateControl one-22", self.m_nMoveEndPointXNow, self.m_tMoveEndPointX, self.m_nMoveElemPosX, curx)
                    elseif math.abs((x - self.m_nScreenWidth / 2) - posCur.x) <= 10 then
                        self.m_tFigure.m_nDire = -1
                        --WZLog("FigureSceneManager:updateControl one-3")
                    end
                end

                if true then
                    local posCentre = self.m_nMoveEndPointXNow - self.m_nScreenWidth / 2
                    local dire = math.random(1,2) == 1 and -1 or 1
                    local random = math.random(10,150) * dire
                    self.m_tFigure.m_nRandomPos = posCentre + random
                    if self.m_tFigure.m_nRandomPos <= 300 then
                        self.m_tFigure.m_nRandomPos = 400 + 60 * (math.random(0,10) > 5 and 1 or -1)
                    elseif self.m_tFigure.m_nRandomPos >= 500 and self.m_tFigure.m_nRandomPos <= 600 then
                        self.m_tFigure.m_nRandomPos = 550 + 60 * (math.random(0,10) > 5 and 1 or -1)
                    elseif self.m_tFigure.m_nRandomPos >= 790 and self.m_tFigure.m_nRandomPos <= 1180 then
                        self.m_tFigure.m_nRandomPos = 985 + 205 * (math.random(0,10) > 5 and 1 or -1)
                    elseif self.m_tFigure.m_nRandomPos >= 1420 and self.m_tFigure.m_nRandomPos <= 1820 then
                        self.m_tFigure.m_nRandomPos = 1620 + 210 * (math.random(0,10) > 5 and 1 or -1)
                    elseif self.m_tFigure.m_nRandomPos >= 2000 and self.m_tFigure.m_nRandomPos <= 2160 then
                        self.m_tFigure.m_nRandomPos = 2080 + 90 * (math.random(0,10) > 5 and 1 or -1)
                    end
                    if self.m_tFigure.m_nRandomPos >= self.m_tFigure:getPositionX() then
                        self.m_tFigure.m_nDire = 1
                    else
                        self.m_tFigure.m_nDire = 0
                    end

                    _,self.m_tFigure.m_nRandomPosY = self.m_tFigure:getPositionOffset(self.m_tFigure.m_nRandomPos)
                    --WZLog("FigureSceneManager:updateControl one-4", self.m_tFigure.m_nDire, self.m_tFigure.m_nRandomPos)
                end

                --self.m_tFigure.m_nRandomPos = nil
                posx, posy = self.m_tFigure:getPositionOffset(posCur.x)

                WZLog("FigureSceneManager:updateControl two-2", self.m_nMoveEndPointXNow, curx, x - self.m_nScreenWidth / 2, self.m_nScreenWidth, posCur.x, x, self.m_tMoveEndPointX, posx, posy)

                self.m_tFigure:setPosition(BattleCommon:getPointTable(posx, self.m_tFigure:getPositionY()))
            end
            self.m_tMoveEndPointX = self.m_nMoveEndPointXNow

            if self.m_tFigureList ~= nil then
                local screenFigureCount = 0
                for id, figure in pairs(self.m_tFigureList) do
                    if figure.m_nFigureType == FigureType.Other then

                        local pos = figure.m_nRandomPos or figure:getPositionX()

                        if pos >= screenLeft and pos <= screenRight then
                            screenFigureCount = screenFigureCount + 1
                            if screenFigureCount > 2 then
                                figure:randomActionOther(screenLeft, screenRight)
                            end
                        end
                        --WZLog("FigureSceneManager:updateControl three", figure.m_sName, GlobalGame.g_nMoveEndPointXNowMoveElement, screenLeft, screenRight, pos, screenFigureCount)
                    end
                end
            end
        end

        if self.m_tFigureList ~= nil then
            for id, figure in pairs(self.m_tFigureList) do
                    figure:update(dt, intervalTime, dt0)
            end
        end

    end
end

--@brief    查看玩家信息按钮
function FigureSceneManager:onOtherClick(playerId)
    --WZLog("FigureSceneManager:onOtherClick", playerId)
    WndOwnCity:showOtherHead(playerId)
end

--@brief    查看玩家信息按钮
function FigureSceneManager:onOtherHide()
    --WZLog("FigureSceneManager:onOtherHide")
    WndOwnCity:hideOtherHead()
end

--@brief    设置当前场景
function FigureSceneManager:setCurrentScene(scene, id)
    --WZLog("FigureSceneManager:setCurrentScene", id)
    self.m_tScene = scene
    FigureSceneManager:isOtherVisible()
    --self.m_tFigureCreateList = {}
    if not g_testFigureScene then
        --self:updateControl()
    end
    self.m_bCanUpdate= true
    self.m_nFrame = 0
    self.m_nFrameFigureCreate = 0

    if GlobalGame.g_nFigureSceneId == nil then
        GlobalGame.g_nFigureSceneId = id
        GlobalGame.g_nMoveEndPointXNowMoveElement = 1517
    elseif GlobalGame.g_nFigureSceneId ~= id then
        GlobalGame.g_nFigureSceneId = id
        --GlobalGame.g_nMoveEndPointXNowMoveElement = nil
    end
    self:setMoveElement()
end

--@brief    设置人物所在的层
function FigureSceneManager:setFigureLayer(layer)
    self.m_tFigureLayer = layer
end

--@brief    移动层
function FigureSceneManager:setMoveElement()
    local scene = WZUIScene:luaTo(self.m_tScene.m_root:getChildElement("conBgLayer_SceneCity"))
	if scene == nil then scene = self.m_tScene.m_tSceneLayer end
    local element = scene:getMoveElement()
    self.m_tMoveElement = element
end

--@brief    增加引用计数
function FigureSceneManager:retain()
    self.m_nReference = self.m_nReference + 1
end

--@brief 设置其他人可见状态
--@param nOpen:是否打开，0:不打开，1：打开
function FigureSceneManager:setOtherVisible(nOpen)
    WZLog("FigureSceneManager:setOtherVisible", tostring(nOpen), G_Other_Player)

    do
        if FigureSceneManager:getInstance().m_tScene then
            FigureSceneManager:getInstance().m_nOtherVisible = nOpen
        end
        G_Other_Player = nOpen
        g_isSetOtherPlayerOpen = true
    end
    --更新状态全局数据
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("FigureSceneManagerData", "OtherVisible", tostring(nOpen))
        data:flush()
    end

    if FigureSceneManager:getInstance().m_tScene then
        FigureSceneManager:getInstance().m_nOtherVisible = nOpen
    end
    if FigureSceneManager:getInstance().m_tFigureList then
        for index, figure in pairs (FigureSceneManager:getInstance().m_tFigureList) do
            if figure.m_nFigureType == FigureType.Other then
                figure:setVisible(nOpen ~= 1)
            end
        end
    end
end

--@brief 获取其他人可见状态
function FigureSceneManager:isOtherVisible()

    local openTeach = SceneCity.m_nTeachStep
    if SceneCity.m_nTeachStep == nil then
        openTeach = SceneCity:getTeachStep()
    end
    WZLog("FigureSceneManager:isOtherVisible one", openTeach, FigureSceneManager:getInstance().m_tScene, G_Other_Player)
    if openTeach == 20 then
        --WZLog("FigureSceneManager:isOtherVisible two")
        if GlobalGame.g_tMoveEndPointXNowPlayer and GlobalGame.g_nFigureSceneId then
            GlobalGame.g_tMoveEndPointXNowPlayer[GlobalGame.g_nFigureSceneId] = nil
        end
        if FigureSceneManager:getInstance().m_tScene then
            FigureSceneManager:getInstance().m_nOtherVisible = 1
        end
        return 1
    end

    do

        if g_isSetOtherPlayerOpen == nil and getTotalMemory() < 800 then
            G_Other_Player = 1
        end
        if FigureSceneManager:getInstance().m_tScene then
            FigureSceneManager:getInstance().m_nOtherVisible = G_Other_Player
        end
        return G_Other_Player
    end

    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return 0
    end
    local nOtherVisible = data:getStringValue("FigureSceneManagerData", "OtherVisible")
    --WZLog("FigureSceneManager:isOtherVisible",nOtherVisible, type(nOtherVisible))
    if nOtherVisible == nil or nOtherVisible == "" or nOtherVisible == "0" then
        nOtherVisible = 0
    elseif nOtherVisible == "1" then
        nOtherVisible = 1
    end

    if FigureSceneManager:getInstance().m_tScene then
        FigureSceneManager:getInstance().m_nOtherVisible = nOtherVisible
    end
    return nOtherVisible
end
-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建管理类
function FigureSceneManager:_init()

    g_figureSceneManager = {}
    setmetatable(g_figureSceneManager, {__index = FigureSceneManager})
    g_figureSceneManager.m_tFigureList = {}

    g_figureSceneManager.m_tWinSize = {width= G_WINDOW_SIZE.WIDTH, height= G_WINDOW_SIZE.HEIGHT}
    local scale = math.floor(g_figureSceneManager.m_tWinSize.width / 960)
    scale = scale == 0 and 1 or scale
    g_figureSceneManager.m_tWinSize.width = g_figureSceneManager.m_tWinSize.width / scale
    g_figureSceneManager.m_tWinSize.height = g_figureSceneManager.m_tWinSize.height / scale
    g_figureSceneManager.m_nScreenWidth = g_figureSceneManager.m_tWinSize.width * 640 / g_figureSceneManager.m_tWinSize.height
    g_figureSceneManager.m_tMoveEndPointX = g_figureSceneManager.m_nScreenWidth
    WZLog("FigureSceneManager:_init", g_figureSceneManager.m_tWinSize.width, g_figureSceneManager.m_tWinSize.height, G_WINDOW_SIZE.WIDTH, G_WINDOW_SIZE.HEIGHT, scale, g_figureSceneManager.m_nScreenWidth)

end

-------------------------------------私有方法模块End----------------------------------------
