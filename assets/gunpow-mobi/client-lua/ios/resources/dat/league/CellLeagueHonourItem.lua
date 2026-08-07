--CellLeagueHonourItem.lua
--@brief	CellLeagueHonourItem的UI模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-荣誉列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueHonourItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueHonourItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell信息
function CellLeagueHonourItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellLeagueHonourItem")
    self.m_root:addChild(cellElement)

    self:_update()
end

--@brief    点击人物回调
function CellLeagueHonourItem:onCheckRole(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.id)
end

--@brief    切换播放角色动画
function CellLeagueHonourItem:changeRoleAni()
    -- body
    if self.m_tPlayerAni == nil then return end
    self.m_tPlayerAni:play(g_tRoleAnitionName[2],false)
    self.m_root:enableSchedule("updateRole")
end

--@brief    角色relax动画播完的回调
function CellLeagueHonourItem:updateRole(element, delta)
    -- body
    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd then
            self.m_tPlayerAni:play("wait0", true)
            self.m_root:disableSchedule()
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellLeagueHonourItem:_update()
    -- body
    --角色名字，等级，战力、
    self:_showName()
    --角色形象
    self:_setPlayer(self.m_tData)
end

--@brief   玩家人物
--@param   tData玩家数据
--@param    是否显示宠物
--@param    角色的锚点
function CellLeagueHonourItem:_setPlayer(tData, bFlipX, bShowPet, ccpAnchor)
    if self.m_root == nil then return end

    local anchorPoint = ccpAnchor or GlobalMethod:ccp(0.5, 0)
    local bDisplayPet = bShowPet or false
    local nSex = tData.sex or 0
    local bBool = bFlipX or false
    local tEquip = {}
    table.insert(tEquip,tData.headId)
    table.insert(tEquip,tData.faceId)
    table.insert(tEquip,tData.bodyId)
    table.insert(tEquip,tData.wingId)

    local petAni = nil 
    if bDisplayPet then
        if tData.petMessage ~= nil and tData.petMessage ~= "" then
            local petMessage = json.decode(tData.petMessage)
            petAni = petMessage.animation
            if petMessage.petSkinItemId and petMessage.petSkinItemId > 0 then
                local tempAnimation = GetPetAnimation(petMessage.petSkinItemId, petMessage.advancedLevel)
                petAni = tempAnimation
            end
        end
    end

    local conPlayerAni = self.m_root:getChildElement("conRole")

    local conPlayer
    if self.m_tPlayerAni == nil then --"wait0"
        conPlayer = CreatePlayerFigure(nSex, tEquip, "wait0", nil, petAni, ccp(-0.4,1.5))--ccp(-0.1, 0.9)
        conPlayerAni:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(0.7)
        self.m_tPlayerAni = conPlayer
        conPlayer:setFlipX(bBool)
        conPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conPlayer:getAnimNode():setRelativePosition(anchorPoint)
    else
        conPlayer = self.m_tPlayerAni
        conPlayer:setFlipX(bBool)
        conPlayer:getAnimNode():setRelativePosition(anchorPoint)
    end
end

--@brief    角色的名字，战力，等级
function CellLeagueHonourItem:_showName()
    -- body
    --等级,名字
    local sFormat = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Lv%d </T><T C="255,255,255" S="20" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
    local playerName = GetElement(self.m_root, "playerName", WZUIFreeTextBox)
    local txtContent = string.format(sFormat, self.m_tData.level, self.m_tData.name)
    playerName:setShowText(txtContent)
    --是否显示队长标志
    local imgCaptain = GetElement(self.m_root, "imgCaptain_CellLeagueHonourItem", WZUIImage)
    local bCaptain = false
    if self.m_tData.leader == 1 then
        bCaptain = true
    end
    imgCaptain:setVisible(bCaptain)
    --是否显示MVP
    local imgMvp = GetElement(self.m_root, "imgMvp_CellLeagueHonourItem", WZUIImage)
    local bIsMvp = false
    if self.m_tData.mvpMark == 1 then
        bIsMvp = true
    end
    imgMvp:setVisible(bIsMvp)
end
-------------------------------------私有方法模块End----------------------------------------
