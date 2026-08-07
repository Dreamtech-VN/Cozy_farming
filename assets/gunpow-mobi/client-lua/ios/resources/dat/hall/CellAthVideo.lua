--CellAthVideo.lua
--@brief	CellAthVideo的UI模块
--@date		2016-6-13
--@author	binshao
--@note		竞技场录像cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthVideo:onEnter(element)
	self.m_root = element
    --AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthVideo:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellAthVideo:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellAthVideo")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

function CellAthVideo:onLook()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("--------------onLook-----------",self.data.recordId,self.data.recordType)
    WndAthVideo:createLoadingBox()
    ProtocolProcessorGlobal:send_BATTLE_Record(self.data.recordId,self.data.recordType,0)
end

function CellAthVideo:onCheckPlayerLeft(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    WndCheckOther:show(self.data.pInfo1[tag].playerId)
    WZLog("--------------onCheckPlayerLeft-----------",tag)
end

function CellAthVideo:onCheckPlayerRight(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    WndCheckOther:show(self.data.pInfo2[tag].playerId)
    WZLog("--------------onCheckPlayerRight-----------",tag)
end

function CellAthVideo:_update()
    local pCnt = #self.data.pInfo1
    -- 左边人物头像
    for i = 1, 3 do
        local con = GetElement(self.m_root,"conHeadLeft"..i.."_CellAthVideo",WZUIContainer)
        local info = self.data.pInfo1[i]
        if info then
            con:setVisible(true)
            CellHead:show(con,info.headId,info.faceId,info.sex,nil,nil,nil,info.headColor)
            self:_setConRelativePos(con,i,pCnt)
        else
            con:setVisible(false)
        end
    end

    -- 右边人物头像
    for i = 1, 3 do
        local con = GetElement(self.m_root,"conHeadRight"..i.."_CellAthVideo",WZUIContainer)
        local info = self.data.pInfo2[i]
        if info then
            con:setVisible(true)
            CellHead:show(con,info.headId,info.faceId,info.sex,nil,nil,nil,info.headColor)
            self:_setConRelativePos(con,i,pCnt)
        else
            con:setVisible(false)
            self:_setConRelativePos(con,i,pCnt)
        end
    end

    -- 队伍战力或者个人战力
    local name = {LocalStrings.SINGLE_FIGHT,LocalStrings.TEAM_FIGHT }
    local fight = {self.data.fight1,self.data.fight2}
    for i = 1, 2 do
        local fn = pCnt == 1 and name[1] or name[2]
        local fightName = GetElement(self.m_root,"txtPFlag"..i.."_CellAthVideo",WZUILabelTTF)
        fightName:setText(fn)

        local txtFight = GetElement(self.m_root,"txtFight"..i.."_CellAthVideo",WZUILabelTTF)
        txtFight:setText(fight[i])
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
            txtFight:setRelativePosition(GlobalMethod:ccp(0.67,0.5))
        elseif ProjConfig.LANGUAGE == "vn" then
            if fn == name[1] then
                txtFight:setRelativePosition(GlobalMethod:ccp(0.748829,0.46))
            end
        end
    end
end

function CellAthVideo:_setConRelativePos(con,index,type)
    if type == 1 then
        con:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    elseif type == 2 then
        if index == 1 then
            con:setRelativePosition(GlobalMethod:ccp(0.33,0.5))
        elseif index == 2 then
            con:setRelativePosition(GlobalMethod:ccp(0.67,0.5))
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------
function CellAthVideo:_adaptLanguage_vn(  )
    for i=1,2 do
        GetElement(self.m_root,"txtFight"..i.."_CellAthVideo"):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
    end
end
-------------------------------------语言适配End----------------------------------------