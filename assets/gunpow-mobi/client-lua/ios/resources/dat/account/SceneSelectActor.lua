--SceneSelectActor.lua
--@brief	SceneSelectActor的UI模块
--@date		2016-10-20
--@author	binshao
--@note		角色选择界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneSelectActor:onEnter(element)
	self.m_root = element
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_CREATE_ACTOR)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneSelectActor:onExit(element)
	self:_unInit()
end

--@brief    删除多余的资源
function SceneSelectActor:onEnterTransitionDidFinish(element)
    self:_update()
end

function SceneSelectActor:showSceneUI()
    local SceneSelectActor = SceneSelectActor:createElement()
    replaceScene(SceneSelectActor)
end

-- 返回服务器选择界面
function SceneSelectActor:onBackToSelectLogin()
    WZLog("SceneSelectActor:onBackToSelectLogin")
    if PassportSdkManager.logout then
        PassportSdkManager:logout()
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneLoginMgr:showScene(2)
end


-- 进入游戏回调
function SceneSelectActor:onEnterGame(element)
	WZLog("SceneSelectActor:onEnterGame",self.data[self.index].name)
    --将当前登陆的玩家id保存到本地
    self:addCellItemId(self.data[self.index].playerId)
    -- 发送账号信息
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorAccount:send_ACCOUNT_RoleActorLogin(self.data[self.index].name)
end

-- 进入游戏按键频率控制
function SceneSelectActor:btnTimeSchedule(element,dt)
    self.btnTime = self.btnTime - dt
    if self.btnTime < 0 then
        self.btnTime = 0
        element:disableSchedule()
    end
end




-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function SceneSelectActor:_update()
    self:_createActorList()
    self:_createRole(self.index)
    self:_createRoleInfo(self.index)
    self:_createPet(self.index)
    self:_createWeapon(self.index)
end

function SceneSelectActor:updateRoleInfo(index)
    if index == self.index then return end
    self.index = index
    self:_createRole(index)
    self:_createRoleInfo(index)
    self:_createPet(index)
    self:_createWeapon(index)
    self:_playShanGuang()
    self:setSelectState()
end

-- 创建角色选择列表
function SceneSelectActor:_createActorList()
    local tab = GetElement(self.m_root, "tabActor_SceneSelectActot", WZUITableContainer)
    tab:cleanTable()
    --如果上次有保存，则默认选中上次的角色
    local nLastPlayerId = self:CheckItemIsClick()
    local bFound = false 
    local nTempLevel = 0 
    local nTempIndex = 1
    for i = 1, #self.data do
        local cell,tcell = CellActorInfo:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.data[i])
        self:saveCellInfo(i,cell,tcell)
        --找出上次登陆的角色的索引
        if nLastPlayerId then
            if self.data[i].playerId == nLastPlayerId then
                self.index = i 
                bFound = true
            end
        end
        --找出等级最大的角色索引
        if not bFound then 
            if self.data[i].level > nTempLevel then 
                nTempLevel = self.data[i].level
                nTempIndex = i
            end
        end
    end
    --如果上次登陆的玩家记录没找到，则选中等级最大的角色
    if not bFound then 
        self.index = nTempIndex 
    end

    if self.index > 3 then 
        local nTempPositionY = tab:getMinPosition().y + (self.index - 3) * 108
        if nTempPositionY > tab:getMaxPosition().y then
            nTempPositionY = tab:getMaxPosition().y
        end
        tab:getMoveElement():setPositionY(nTempPositionY)
    end

    self:setSelectState()
end

-- 创建玩家角色
function SceneSelectActor:_createRole(index)
    if index == nil then index = 1 end
    local info = self.data[index]

    local conP = GetElement(self.m_root, "conPlayer_SceneSelectActor", WZUIContainer)
    if conP:getChildByTag(99) then
        conP:removeChildByTag(99,true)
    end

    local equip = {info.headId,info.bodyId,info.faceId,info.wingId}
    local conPlayer = CreatePlayerFigure(info.sex, equip, nil, nil, nil, nil,nil,nil,nil, nil, info.colour, info.bodycolour)
    conPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0))
    conP:addChild(conPlayer:getAnimNode(),10,99)
end

-- 创建玩家信息
function SceneSelectActor:_createRoleInfo(index)
    if index == nil then index = 1 end
    local info = self.data[index]

    -- 称号
    local conTitle = GetElement(self.m_root, "conTitle_SceneSelectActor", WZUIContainer)
    local txtTitle = GetElement(self.m_root, "txtPlayerTitle_SceneSelectActor", WZUILabelTTF)
    local tempPoint = GlobalMethod:ccp(0.5,2.18498)
    CreateDesiSpine(conTitle, txtTitle, info.title, tempPoint, true)

    -- 名字和等级
    local ftbNameLv = GetElement(self.m_root, "txtPlayerLevel_SceneSelectActor", WZUIFreeTextBox)
    ftbNameLv:setShowText(string.format(LocalStrings.SHOP_NAME_AND_LEVEL1,info.level,info.name))

    -- 战斗力
    local ftbFight = GetElement(self.m_root,"ftbFight_SceneSelectActor",WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER,info.fighting))
end

-- 创建宠物
function SceneSelectActor:_createPet(index)
    if index == nil then index = 1 end
    local info = self.data[index].petMessage
    WZLog("------------pet info--------------",info)
    -- 宠物
    local conPet = GetElement(self.m_root,"conPet_SceneSelectActor",WZUIContainer)
    if info then
        local aniPet,par =  CreatePetAni(conPet,info.itemId,info.animation,info.advancedLevel, info.petSkinItemId)
        aniPet:getAnimNode():setScale(0.8)
        if par then par:setScale(0.8) end
    else
        conPet:removeAllChildrenWithCleanup(true)
    end
end

-- 创建武器
function SceneSelectActor:_createWeapon(index)
    if index == nil then index = 1 end
    local info = self.data[index]
    local extraInfo = self.data[index].weaponInfo

    WZLog("-----------858---------",Serialize(extraInfo))

    local imgWeapon = GetElement(self.m_root,"imgWeapon_SceneSelectActor", WZUIImage)
    local spineWeapon = GetElement(self.m_root,"spineWeapon_SceneSelectActor", WZUISpine)

    -- 武器图片
    local equipInfo = GDatatab_item["id_"..info.weaponId]
    imgWeapon:setFile(equipInfo.icon)

    -- 特效
    local function getAniName()
        local starLevel = extraInfo.starLevel
        local star = {12,10,8,5}
        for i = 1, #star do
            if starLevel >= star[i] then return star[i] end
        end
        return nil
    end

    local aniName = getAniName()
    WZLog("--------------my weapon info----------------",extraInfo.starLevel,aniName)
    if aniName then
        spineWeapon:play(tostring(aniName),true)
        spineWeapon:setVisible(true)
    else
        spineWeapon:setVisible(false)
    end
end

function SceneSelectActor:_playShanGuang()
    local spine = GetElement(self.m_root,"spineDress_SceneSelectActor",WZUISpine)
    spine:play("2",false)
end

function SceneSelectActor:setSelectState()
    local index = self.index
    WZLog("-------------index-------------",index)
    for i = 1, #self.cellInfo do
        local info = self.cellInfo[i]
        if info then
            local tcell = self.cellInfo[i].tcell
            tcell:setSelect(i == index)
        end
    end
end

--@brief    添加点击事件的id
function SceneSelectActor:addCellItemId(playerId)
    WZLog("SceneSelectActor:addCellItemId")
    local _KeyString = ""
    local data = WZDataFile:getInstance():getUserData()
    _KeyString = "LASTACTOR_ID"
    local cellId_stringArray =  data:getStringValue("SELECTACTOR", _KeyString)
    if cellId_stringArray == nil or tonumber(cellId_stringArray) ~= playerId then
        local idString = tostring(playerId)
        data:setStringValue("SELECTACTOR", _KeyString, idString)
        data:flush()
    end
end

--@breif    判断是否点击过
function SceneSelectActor:CheckItemIsClick()
    local data = WZDataFile:getInstance():getUserData()
    local cellId_stringArray = data:getStringValue("SELECTACTOR", "LASTACTOR_ID")

    WZLog("SceneSelectActor:CheckItemIsClick ", cellId_stringArray)
    if cellId_stringArray == nil or cellId_stringArray == "" then
        return nil
    end

    return tonumber(cellId_stringArray)
end
-------------------------------------私有方法模块End----------------------------------------


