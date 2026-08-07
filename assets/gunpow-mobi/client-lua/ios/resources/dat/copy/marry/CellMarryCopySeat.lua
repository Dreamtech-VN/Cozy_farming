--CellMarryCopySeat.lua
--@brief	CellMarryCopySeat的UI模块
--@date		2016-7-26
--@author	binshao
--@note		夫妻副本房间玩家座位


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryCopySeat:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryCopySeat:onExit(element)
	self:_unInit()
end

-- 查看玩家信息
function CellMarryCopySeat:onCheckPlayer(element)
    WZLog("-----------onCheckPlayer-------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.playerId)
end

-- 查看宠物
function CellMarryCopySeat:onPet()
    WZLog("-----------onPet-------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local data = self.data
    if not data.pet or not next(data.pet) then return end
    local conPet= GetElement(self.m_root,"conPet_CellMarryCopySeat",WZUIContainer)
    local conTips = SceneMarryCopy:getConTips()
    local pos = GlobalMethod:ccp(500,-30)
    WndTips:show(conPet,conTips,13,data.pet,pos)
end

-- 查看装备
function CellMarryCopySeat:onEquip()
    WZLog("-------------onEquip--------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local data = self.data
    if not data.extranInfo or not next(data.extranInfo) then return end
    local conEquip= GetElement(self.m_root,"conEquip_CellMarryCopySeat",WZUIContainer)
    local weaponInfo = {}
    weaponInfo.id = data.playerEquipment[4]
    weaponInfo.basicInfo = GDatatab_item["id_"..data.playerEquipment[4]]
    weaponInfo.extraInfo = data.extranInfo
    weaponInfo.maintype = weaponInfo.basicInfo.main_type
    weaponInfo.subtype = weaponInfo.basicInfo.sub_type
    weaponInfo.isUse = true
    local conTips = SceneMarryCopy:getConTips()
    WndItemInfo:showInfo(conEquip,conTips,1,weaponInfo,false,nil,false)
end

-- 邀请玩家
function CellMarryCopySeat:onInvPlayer(element)
    WZLog("-------------onInvPlayer--------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local roomId,loveId = SceneMarryCopy:getLoveIdAndRoomId()
    WZLog("-----------------roomId and loveId-----------",roomId,loveId)
    ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(roomId, loveId)
    MsgBoxManager:showTipBox(LocalStrings.INVITATION_HAS_BEEN_SENT)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新函数
--@note 	实际上的初始化函数
function CellMarryCopySeat:_update()
    if self.m_root == nil then return end

    local data = self.data
    local conNoHave = GetElement(self.m_root, "conNoHave_SceneMarryCopy",WZUIContainer)
    local conHave = GetElement(self.m_root, "conHave_SceneMarryCopy",WZUIContainer)
    if data == nil then
        conNoHave:setVisible(true)
        conHave:setVisible(false)
        return
    else
        conNoHave:setVisible(false)
        conHave:setVisible(true)
    end

    -- 性别标识
    local imgPath = {"ui/common/common_icon_lgz.png","ui/common/common_icon_lpz.png"}
    local imgSex = GetElement(self.m_root,"imgSex_CellMarryCopySeat",WZUIImage)
    imgSex:setFile(imgPath[data.playerSex+1])

    -- 玩家名字
    local txtName = GetElement(self.m_root,"txtName_CellMarryCopySeat",WZUILabelTTF)
    txtName:setText(data.playerName)

    -- 玩家的状态，房主，准备，未准备
    local imgState = GetElement(self.m_root,"imgState_CellMarryCopySeat",WZUIImage)
    WZLog("-----------p pid------------",data.wnersId )
    WZLog("-----------p pid------------",data.playerId )
    if data.wnersId == data.playerId then
        imgState:setFile("ui/common/common_icon_fangzhu.png")
    else
        if data.playerReady then
            imgState:setFile("ui/common/common_icon_zhunbei4.png")
        else
            imgState:setVisible(false)
        end
    end

    -- 玩家形象
    local conP = GetElement(self.m_root,"conPlayer_CellMarryCopySeat",WZUIContainer)
    local pAni = CreatePlayerFigure(data.playerSex,data.playerEquipment,nil,nil,nil,nil,nil,nil,nil,nil,data.headColor,data.bodyColor)
    local pNode = pAni:getAnimNode()
    conP:addChild(pNode)

    -- 宠物
    local conPetAni= GetElement(self.m_root,"conPetAni_CellMarryCopySeat",WZUIContainer)
    local petAni,petNode
    local petInfo = data.pet
    if petInfo then
        if petInfo.itemId and petInfo.animation then
            petAni =  CreatePetAni(conPetAni,petInfo.itemId,petInfo.animation,petInfo.advancedLevel, petInfo.petSkinItemId)
            petNode = petAni:getAnimNode()
            petAni:setScale(0.7)
            petNode:setTouchEnable(false)
        end
    end

    -- 武器图片
    local imgEquip = GetElement(self.m_root,"imgEquip_CellMarryCopySeat",WZUIImage)
    local equipInfo = GDatatab_item["id_"..data.playerEquipment[4]]
    local icon = equipInfo.icon
    imgEquip:setFile(icon)

    -- 武器特效
    local spine = GetElement(self.m_root,"spineEquip_CellMarryCopySeat",WZUISpine)
    local aniName = self:_getAniName()
    WZLog("--------------equip star level----------------",data.extranInfo.starLevel,aniName)
    if aniName then
        spine:play(tostring(aniName),true)
        spine:setVisible(true)
    else
        spine:setVisible(false)
    end


    -- 右边玩家需要特殊处理
    if data.pos == 2 then
        -- 人物朝向改变
        pAni:setFlipX(true)

        --宠物位置调整,宠物反向
        local conPet= GetElement(self.m_root,"conPet_CellMarryCopySeat",WZUIContainer)
        conPet:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        conPet:setRelativePosition(GlobalMethod:ccp(1.2,0.68))
        if petAni and petNode then petNode:setFlipX(true) end


--        --装备位置调整
--        local conEquip = GetElement(self.m_root,"conEquip_CellMarryCopySeat",WZUIContainer)
--        conEquip:setAnchorPoint(GlobalMethod:ccp(1,0.5))
--        conEquip:setRelativePosition(GlobalMethod:ccp(1,0.22))
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------回调方法模块Begin----------------------------------------


-------------------------------------回调方法模块End----------------------------------------
-- 创建有玩家的座位
function CellMarryCopySeat:_createHavePlayerSeat()
    local con = GetElement(self.m_root, "conHavePlayer_CellMarryCopySeat",WZUIContainer)
    con:setVisible(true)
    local con1 = GetElement(self.m_root, "conNotPlayer_CellMarryCopySeat",WZUIContainer)
    con1:setVisible(false)

    -- 玩家名字
    local txtPlayerName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPlayerName_CellMarryCopySeat"))
    txtPlayerName:setText(self.m_tData.playerName)

    -- 玩家等级
    local txtPlayerLevel = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPlayerLevel_CellMarryCopySeat"))
    txtPlayerLevel:setText("Lv"..self.m_tData.playerLevel)

    -- 玩家战斗力
    local txtFight = GetElement(self.m_root, "labFireCnt_CellMarryCopySeat", WZUILabelAtlasFont)
    txtFight:setText(self.m_tData.playerFighting)

    -- 玩家的状态，房主，准备，未准备
    local imgPlayerType = GetElement(self.m_root,"imgPlayerType_CellMarryCopySeat",WZUIImage)
    if self.m_tData.wnersId == self.m_tData.playerId then
        imgPlayerType:setFile("ui/common/common_icon_fangzhu.png")
    else
        if self.m_tData.playerReady then
            imgPlayerType:setFile("ui/common/common_icon_zhunbei4.png")
        else
            imgPlayerType:setVisible(false)
        end
    end

    -- 创建玩家形象和宠物
    local conP = GetElement(self.m_root,"conPlayer_CellMarryCopySeat",WZUIContainer)
    self.m_player = CreatePlayerFigure(self.m_tData.playerSex,self.m_tData.playerEquipment,nil,nil,nil,nil,nil,nil,nil,nil,self.m_tData.headColor,self.m_tData.bodyColor)
    local pNode = self.m_player:getAnimNode()
    pNode:setScale(0.6)
    conP:addChild(pNode)

    if self.m_tData.pet then
        if self.m_tData.pet.itemId and self.m_tData.pet.animation then
            local conPet= GetElement(self.m_root,"conPet_CellMarryCopySeat",WZUIContainer)
            local ani,par =  CreatePetAni(conPet,self.m_tData.pet.itemId,self.m_tData.pet.animation,self.m_tData.pet.advancedLevel, self.m_tData.pet.petSkinItemId)
            ani:setScale(0.48)
            if par then par:setScale(0.48) end
            ani:getAnimNode():setTouchEnable(false)
        end
    end

    -- 武器图片
    local imgEquip = GetElement(self.m_root,"imgEquip_CellMarryCopySeat",WZUIImage)
    local equipInfo = GDatatab_item["id_"..self.m_tData.playerEquipment[4]]
    local icon = equipInfo.icon
    imgEquip:setFile(icon)

    -- 特效

    local spine = GetElement(self.m_root,"spineEquip_CellMarryCopySeat",WZUISpine)
    local aniName = self:_getAniName()
    WZLog("--------------equip star level----------------",self.m_tData.extranInfo.starLevel,aniName)
    if aniName then
        spine:play(tostring(aniName),true)
        spine:setVisible(true)
    else
        spine:setVisible(false)
    end
end



function CellMarryCopySeat:onCheckEquip(element)
    if not self.m_tData.extranInfo or not next(self.m_tData.extranInfo) then return end
    local conEquip= GetElement(self.m_root,"conEquip_CellMarryCopySeat",WZUIContainer)



    WZLog("-------------410---------------",conEquip)
    local weaponInfo = {}
    weaponInfo.id = self.m_tData.playerEquipment[4]
    weaponInfo.basicInfo = GDatatab_item["id_"..self.m_tData.playerEquipment[4]]
    weaponInfo.extraInfo = self.m_tData.extranInfo
    weaponInfo.maintype = weaponInfo.basicInfo.main_type
    weaponInfo.subtype = weaponInfo.basicInfo.sub_type
    weaponInfo.isUse = true

    if self.equipCallBackFunc then
        self.equipCallBackFunc(self.equipCallBackTab,conEquip,weaponInfo)
    end
end

function CellMarryCopySeat:_getAniName()
    local starLevel = self.data.extranInfo.starLevel
    local star = {12,10,8,5}
    for i = 1, #star do
        if starLevel >= star[i] then return star[i] end
    end
    return nil
end