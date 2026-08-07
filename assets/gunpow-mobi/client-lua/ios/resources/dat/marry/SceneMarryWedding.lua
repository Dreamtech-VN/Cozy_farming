--SceneMarryWedding.lua
--@brief	SceneMarryWedding的UI模块
--@date		2015/08/12
--@author	qixiang_xie
--@note		夫妻关系界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief  对礼物进行排序
function sortGift(a,b)
    if GDatatab_item["id_" .. a].value > GDatatab_item["id_" .. b].value then
        return true
    end
    return false
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneMarryWedding:onEnter(element)
	self.m_root = element
    
    ChangeChatChannel(Chat_Channel_Marry_Couple)
    -- local conBottom = GetElement(self.m_root,"conBottom_SceneMarryWedding",WZUIContainer)
    -- local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
    -- self.m_tWndBottomBar = wndBottomBar
    -- self.m_root:addChild(wndBottomBar)
    -- wndBottomBarObj:setNeedMoveVerticalBar(true)
    -- wndBottomBarObj:setNeedChat(false)

    self:_addTop()

    self:_showRedTip()
    self:updateInfo()
    self.m_tGiftList = {}
    for k,v in pairs(GDatatab_item) do
        if v.main_type == 12 and v.sub_type == 2 then
            table.insert(self.m_tGiftList,v.id)
        end
    end
    table.sort(self.m_tGiftList,sortGift)
    --延时显示成就特效
    ShowDelayAchie()

    self:checkBackRoomState()
    pushEquipInList()
    g_bIsShowWndDressUp = true
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
    AdaptLanguage(self)
end



--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneMarryWedding:onExit(element)
	self:_unInit()
end

--@brief    觸摸開始
function SceneMarryWedding:onTouchBegin(element, pt)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief  退出夫妻关系系统
function SceneMarryWedding:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	local sceneIsland = SceneIsland:createElement()
	if sceneIsland ~= nil then 
		replaceScene(sceneIsland)
        SceneCity.m_bFromChurch = true
	end 
end


--@brief	点击说明按钮的响应方法
--@param	element:按钮的引用
function SceneMarryWedding:onIntroClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   
    --获得说明文本
	WndSingleMapDesc:showInterface(LocalStrings.CONJUGAL_RELATION_TIP)

end

--@brief 送礼物相关说明
function SceneMarryWedding:showSendExplain()
   WZLog("SceneMarryWedding:onClickExplain")
  
   WndSingleMapDesc:showInterface(LocalStrings.Wedding_Desc)
end

--@brief    确定离婚
function SceneMarryWedding:sureToDivorce()
	WZLog("SceneMarryWedding:sureToDivorce")
    if WndMarryManager:getLoadingTag() ~= -1 and WndMarryManager:getLoadingTag()  ~= nil then
        return
    end
    WndMarryManager:createLoading()
    ProtocolProcessorWndMarry:send_WEDDING_RemoveEngagement(0)
end

--@brief  恩爱日志
function SceneMarryWedding:onClickLoveBlog(element)
	WZLog("SceneMarryWedding:onClickLoveBlog = ")
    if WndMarryManager:getLoadingTag() ~= -1 and WndMarryManager:getLoadingTag()  ~= nil then
        return 
    end
    WndMarryManager:createLoading()
    WZLog("SceneMarryWedding:onClickLoveBlog ======")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorWndMarry:send_WEDDING_GetLoveLog()

    if GlobalGame.g_tRedPointList.marry then
        SceneCity:updateRedDotBuilding("marry", false)
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(89)
        GlobalGame.g_tRedPointList.marry = nil
    end
    GetElement(self.m_root,"imgNewMes_SceneMarryWedding",WZUIImage):setVisible(false)
end

--@brief  送礼物
function SceneMarryWedding:onClickSendGift(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if   self.m_nGiftNum <= 0 then
       MsgBoxManager:showTipBox(LocalStrings.SEND_GIFT_TIP)
       return
    end
    
    local wndMarry = WndMarry:createElement()
    WndMarry:setOperationType(2,self.m_tGiftList)
    WndMarry:setSendOperCallback(self,self.sendGiftCallback)
    WndMarry:setGiftCount(self.m_nGiftNum)
    WindowManager:addWindow(wndMarry,WndMarry,nil,nil,nil,true)
    
end


--@brief 离婚
function SceneMarryWedding:onClickDivorce(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("SceneMarryWedding:onDivorceClick")

    WndMarryManager:createLoading()
    ProtocolProcessorWndMarry:send_WWEDDING_GetRemoveEngageStatus()
end

--@brief    没有孩子的离婚
function SceneMarryWedding:noKidDivorce()
    -- body
    --离婚提示
    local divorcePrice =  CacheCenter:getGameParam().DivorcePrice
    if divorcePrice == nil then
        divorcePrice = 886
    end
    divorcePrice = tonumber(divorcePrice)
    if CacheCenter:getGameParam().isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, divorcePrice, string.format(LocalStrings.DIVORCE_WEDDING_NOT_ENOUGH,divorcePrice), nil, 88, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, divorcePrice, string.format(LocalStrings.DIVORCE_WEDDING_NOT_ENOUGH,divorcePrice), nil, 88, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
    end
    
    self:clickSureMoney()
end

--@brief    点击确定充值回调
function SceneMarryWedding:clickSureMoney()
    local divorcePrice =  CacheCenter:getGameParam().DivorcePrice
    if divorcePrice == nil then
        divorcePrice = 886
    end
    divorcePrice = tonumber(divorcePrice)
    
    MsgBoxManager:showConfirmBox(string.format(LocalStrings.WEDDING_END_REQUEST,divorcePrice),self,self.sureToDivorce)
end

--@brief   赠送按钮回调
function SceneMarryWedding:sendGiftCallback(itemId)
    WZLog("SceneMarryWedding:sendGiftCallback ",itemId)
    if WndMarryManager:getLoadingTag() ~= -1 and WndMarryManager:getLoadingTag()  ~= nil then
        return 
    end

    if self.m_nGiftNum <= 0 then
       MsgBoxManager:showTipBox(LocalStrings.SEND_GIFT_TIP)
       return
    end

    local playerItemIds = CacheCenter:getPlayerItems()
    local playerItemId = nil
    for i,data in pairs(playerItemIds) do
        if data.basicInfo ~= nil then
            if tonumber(data.basicInfo.id) == itemId then
                playerItemId = data.playerItemId
                break
            end
        else
            if tonumber(data.id) == itemId then
                playerItemId = data.playerItemId
                break
            end
        end
    end
    self.m_nSendItemId = itemId
    WndMarryManager:createLoading()
    ProtocolProcessorWndMarry:send_WEDDING_SendGift(playerItemId)
    
end

--@brief  发送礼物结果
function SceneMarryWedding:sendGiftResult()
    WZLog("SceneMarryWedding:sendGiftResult")
    self.m_nGiftNum =  self.m_nGiftNum - 1
    WndMarry:setGiftCount(self.m_nGiftNum)
    if self.m_nSendItemId ~= nil then
        local loveValue = GDatatab_item["id_" .. self.m_nSendItemId].value
        local showText = LocalStrings.COUPLE_LOVE
        createFightingAni(self.m_root,loveValue,GlobalMethod:ccp(0.5,0.5),showText)
    end
    self.m_nSendItemId = nil
    ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
end

--@brief 对夫妻技能进行排序
function sortSkill(a,b)
    if a.id < b.id then
        return true
    else
        return false
    end
end

--@brief  点击夫妻技能响应的方法
function SceneMarryWedding:onClickSkill(element)
    WZLog("SceneMarryWedding:onClickSkill ",element:getParent():getTag(),element:getTag())
    local desc = GDatatab_marry_skill["id_"..element:getTag()].desc
    MsgBoxManager:showTipBox(desc)
end

--@brief   玩家人物
function SceneMarryWedding:showPlayerAnim(sex,head,face,body,wing,conAmin,headColor,bodyColor)
    local nSex = sex--玩家性别 

    local tEquip = nil
    tEquip = { head,face,body,wing}
    local conPlayer = CreatePlayerFigure(nSex,tEquip,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor,false)
    conAmin:removeChildByTag(50,true)
    local animNode = conPlayer:getAnimNode()
    animNode:setTouchEnable(false)
    animNode:setTag(50)
    animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    animNode:setRelativePosition(GlobalMethod:ccp(0.5,-0.02))
    --animNode:setScale(0.8)
    conAmin:addChild(animNode)
    if sex == 0 then
        conPlayer:setFlipX(true)
    end
end

--@brief  更新夫妻关系信息
function SceneMarryWedding:updateInfo()
    local wifeName =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWifeName_SceneMarryWedding"))
    local husbandName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtHusbandName_SceneMarryWedding"))
    wifeName:setText(self.m_sWomanName)
    husbandName:setText(self.m_sManeName)

    local giftCount = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtSendGiftC_SceneMarryWedding"))
    giftCount:setText(LocalStrings.SEND_GIFT.."X"..self.m_nGiftNum)
    
    local petExptV = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtExpV_SceneMarryWedding")) 
    
    local exp = GDatatab_marry_love["id_"..self.m_nLoveLevel].exp
    petExptV:setText(self.m_nLoveExp.."/"..exp)

    local proExp = WZUIProgress:luaTo(self.m_root:getChildElement("proMarryExp_SceneMarryWedding"))
    if loveExp == 0 then
        proExp:setPercentage(0)
    else
        proExp:setPercentage(self.m_nLoveExp/exp*100)
    end
    
    if self.m_nLoveLevel > 0 then
        for i=1,self.m_nLoveLevel do
           local imgLevel = GetElement(self.m_root,"imgLevel"..i.."_SceneMarryWedding",WZUIImage)
           imgLevel:setGrayRender(false)
        end
    end
    
    if not self.m_bLoadFinish then
        local conWifeImage = WZUIContainer:luaTo(self.m_root:getChildElement("conWifeFigure_SceneMarryWedding"))

        local conHusbandImg = WZUIContainer:luaTo(self.m_root:getChildElement("conHusbandFigure_SceneMarryWedding"))
        self:showPlayerAnim(0,self.m_nManHeadId,self.m_nManFaceId,self.m_nManBodyId, self.m_nManWingId,conHusbandImg, self.m_nManHeadColor,self.m_nManBodyColor)
        self:showPlayerAnim(1,self.m_nWomanHeadId,self.m_nWomanFaceId,self.m_nWomanBodyId, self.m_nWomanWingId,conWifeImage,self.m_nWomanHeadColor,self.m_nWomanBodyColor)
    end
    
    self:_showSkillList()
    self.m_bLoadFinish = true

    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    local copyInfo = GDatatab_team_map["id_20101"]
    local costLife = copyInfo.pass_consume + copyInfo.play_consume
    txtCostLife:setText(string.format(LocalStrings.MARRY_COPY_COST_LIFE,costLife))

end

--@brief  查看妻子的信息
function SceneMarryWedding:onClickWife(element)
    WZLog("SceneMarryWedding:onClickWife")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_nWifeId)
end

--@brief  查看丈夫的信息
function SceneMarryWedding:onClickHusband(element)
    WZLog("SceneMarryWedding:onClickHusband")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_nHudandId)
end

--点击了夫妻副本
function SceneMarryWedding:onClickCopy(element)
    WZLog("SceneMarryWedding:onClickCopy")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    local copyInfo = GDatatab_team_map["id_20601"]
    local costLife = copyInfo.pass_consume + copyInfo.play_consume
    if CacheCenter:getPlayerInfo().vigor < costLife then
        judgeNotEnoughJump(self, self.needMoreEnergy)
        return
    end

    if self:judgeCntIsEnough() then
        local mapId = SceneMarryCopy:getCurMarryCopyMapId()
        WZLog("----------------88---------------------",mapId)
        ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(mapId, "")
    end
end

--@brief   是否补充活力值回调
function SceneMarryWedding:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

-- 判断次数是否足够
function SceneMarryWedding:judgeCntIsEnough()
    local copyId = 20601
    local copyInfo = GDatatab_team_map["id_"..copyId]
    local ccData = CacheCenter:getMultiCopyData()
    local leftCnt = copyInfo.challenge_num
    for i,v in ipairs(ccData) do
        if v.mapId == 0 then
            WZLog("----------v.mapId----------",v.mapId,v.passTime)
            leftCnt = copyInfo.challenge_num - v.passTime
        end
    end
    WZLog("------------left cnt--------------",leftCnt)
    if leftCnt <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.CHALLENGE_NOT_ENOUGH)
        return false
    end

    return true
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  如果有相同的技能属性已获得，只显示最高等级那个
function SceneMarryWedding:_canShowSkill(skillList)
    WZLog("SceneMarryWedding:_clearUpSkill")
    local skillLists = {}
    for i,v in ipairs(skillList) do
        local skillInfo = GDatatab_marry_skill["id_"..v]
        local skill = skillLists["" .. skillInfo.property_type]
        if not skill then
            local temp = {}
            table.insert(temp,v)
            skillLists["" .. skillInfo.property_type] = temp
        else
            table.insert(skill,v)
        end
    end

    local temp = {}
    for k,v in pairs(skillLists) do
        temp[k] = {}
    end

    for k,v in pairs(skillLists) do
        for g,h in ipairs(v) do
            local skillInfo = GDatatab_marry_skill["id_"..h]
            if self.m_nLoveLevel >= skillInfo.need_love_level then
                table.insert(temp[k],h)
            end
        end
    end
    
    for k,v in pairs(temp) do
        local count = #v
        if count > 1 then
            for i=1,count-1 do
                table.remove(v,1)
            end
        end
    end
   
    return temp
end


--@brief  显示技能列表信息
function SceneMarryWedding:_showSkillList()
    WZLog("SceneMarryWedding:_showSkillList")
    local conListSkill = WZUITableContainer:luaTo(self.m_root:getChildElement("tabCouple_SceneMarryWedding"))
    conListSkill:cleanTable()
    local index = 0
    local haveSkill = {}
    local isInsert = true 
    local hasSkills = {}
    local isInsert = true
    local canShowSkill = {}
    local skillTempT = {}
    for k,v in pairs(GDatatab_marry_skill) do
        table.insert(skillTempT,v)
    end
    table.sort(skillTempT,sortSkill)
    for k1,v2 in pairs(skillTempT) do
        table.insert(canShowSkill,v2.id)
    end
    local visibleSkills = self:_canShowSkill(canShowSkill)

    local isContainer = false
    for k,v in ipairs(canShowSkill) do
        local skillInfo = GDatatab_marry_skill["id_"..v]

        local conSkillInfo = WZUISystem:getInstance():createElement("CellCoupleSkill")
       
        local skillImage =  WZUIImage:luaTo(GetElement(conSkillInfo,"imgSkillImage_CellCoupleSkill"))
        
        skillImage:setFile(skillInfo.icon)
   
        local imageLock = WZUIImage:luaTo(GetElement(conSkillInfo,"imgSkillLock_CellCoupleSkill"))
        local skillName =  WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkilName_CellCoupleSkill"))
        skillName:setText(skillInfo.name)

        local skillExplain = WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkillDesc_CellCoupleSkill"))
        local skillCond = WZUILabelTTF:luaTo(GetElement(conSkillInfo,"txtSkillCond_CellCoupleSkill"))
        local btnSkill = WZUIButton:luaTo(GetElement(conSkillInfo,"btnSkill_CellCoupleSkill"))
        btnSkill:setTag(skillInfo.id)
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
            skillExplain:setFontSize(16)
            imageLock:setRelativePosition(GlobalMethod:ccp(0.83,0.797657))
        elseif ProjConfig.LANGUAGE == "th" then
            imageLock:setRelativePosition(GlobalMethod:ccp(0.68,0.797657))
        elseif ProjConfig.LANGUAGE == "pt" then
            skillExplain:setFontSize(16)
            skillName:setScale(0.9)
            imageLock:setRelativePosition(GlobalMethod:ccp(0.921876,0.797657))
        elseif ProjConfig.LANGUAGE == "es" then
            skillExplain:setFontSize(16)
            imageLock:setRelativePosition(GlobalMethod:ccp(0.86,0.797657))
        end
        if self.m_nLoveLevel >= skillInfo.need_love_level then
            if visibleSkills["" .. skillInfo.property_type][1] == v then
                conSkillInfo:setTag(index)
                index = index + 1
                imageLock:setVisible(false)
                skillExplain:setText(skillInfo.desc)
                skillCond:setText("")
                conSkillInfo:setVisible(true)
                conListSkill:setCellElement(conSkillInfo)
            end
        else
            conSkillInfo:setTag(index)
            index = index + 1
            imageLock:setVisible(true)
            skillImage:setGrayRender(true)
            skillExplain:setText("")
            skillCond:setText(LocalStrings.LOVING_LEVEL..skillInfo.need_love_level)
            conSkillInfo:setVisible(true)
            conListSkill:setCellElement(conSkillInfo)
        end
    end 
    local haveSkill = nil
    local hasSkills = nil
    local canShowSkill = nil
end
   
--@brief  显示红点图标
function SceneMarryWedding:_showRedTip()
    if GlobalGame.g_tRedPointList.marry then
        GetElement(self.m_root,"imgNewMes_SceneMarryWedding",WZUIImage):setVisible(true)
    else
        GetElement(self.m_root,"imgNewMes_SceneMarryWedding",WZUIImage):setVisible(false)
    end 
end

function SceneMarryWedding:checkBackRoomState()
    if WndMultiCopy.g_nBackRoomState and WndMultiCopy.g_nBackRoomState ~= 0 then
        if WndMultiCopy.g_nBackRoomState == 3 then
            judgeNotEnoughJump(self, self.needMoreEnergy)
        end
        WndMultiCopy.g_nBackRoomState = 0
    end
end

function SceneMarryWedding:_adaptLanguage_th()
    WZLog("SceneMarryWedding:_adaptLanguage_th")
    local conSendPresent = GetElement(self.m_root,"conSendPresent_SceneMarryWedding",WZUIContainer)
    conSendPresent:setAbsContentSize(GlobalMethod:CCSize(200,62))
    conSendPresent:updateRelativeSize()

    local txtSendGiftC = GetElement(conSendPresent,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF)
    txtSendGiftC:setRelativePosition(GlobalMethod:ccp(0.55091,0.5))
    txtSendGiftC:setFontSize(22)

    local txtSpouse = GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF)
    txtSpouse:setFontSize(20)
end

function SceneMarryWedding:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF):setFontSize(24)
    GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF):setFontSize(22)
    
    GetElement(self.m_root,"imgArrow1_SceneMarryWedding",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.2,0.919589))
    GetElement(self.m_root,"imgArrow2_SceneMarryWedding",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.81,0.919416))
end

function SceneMarryWedding:_adaptLanguage_en()
    WZLog("SceneMarryWedding:_adaptLanguage_en")
    local conSendPresent = GetElement(self.m_root,"conSendPresent_SceneMarryWedding",WZUIContainer)
    conSendPresent:setAbsContentSize(GlobalMethod:CCSize(220,62))
    conSendPresent:updateRelativeSize()

    local txtSendGiftC = GetElement(conSendPresent,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF)
    txtSendGiftC:setRelativePosition(GlobalMethod:ccp(0.55091,0.5))
    txtSendGiftC:setFontSize(20)

    local txtSpouse = GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF)
    txtSpouse:setFontSize(20)

    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    txtCostLife:setScale(0.6)
    local imgVigor = GetElement(self.m_root,"imgVigor_SceneMarryWedding",WZUIImage)
    imgVigor:setScale(0.25)
end

function SceneMarryWedding:_adaptLanguage_pt()
    local conSendPresent = GetElement(self.m_root,"conSendPresent_SceneMarryWedding",WZUIContainer)
    conSendPresent:setAbsContentSize(GlobalMethod:CCSize(220,62))
    conSendPresent:updateRelativeSize()

    local txtSendGiftC = GetElement(conSendPresent,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF)
    txtSendGiftC:setRelativePosition(GlobalMethod:ccp(0.55091,0.5))
    txtSendGiftC:setFontSize(18)

    local txtSpouse = GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF)
    txtSpouse:setFontSize(16)
    txtSpouse:setDimensions(GlobalMethod:CCSize(160,0))

    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    txtCostLife:setScale(0.6)
    txtCostLife:setRelativePosition(GlobalMethod:ccp(0.14,0.5))

    local txtLoveLevel = GetElement(self.m_root,"txtLoveLevel_SceneMarryWedding",WZUILabelTTF)
    txtLoveLevel:setFontSize(14)
    txtLoveLevel:setRelativePosition(GlobalMethod:ccp(0.147778,0.804977))

    local txtLoveLog = GetElement(self.m_root,"txtLoveLog_SceneMarryWedding",WZUILabelTTF)
    txtLoveLog:setFontSize(20)
    txtLoveLog:setDimensions(GlobalMethod:CCSize(120))

    local txtLoveLogPress = GetElement(self.m_root,"txtLoveLogPress_SceneMarryWedding",WZUILabelTTF)
    txtLoveLogPress:setFontSize(20)
    txtLoveLogPress:setDimensions(GlobalMethod:CCSize(120))
    
    local txtLoveV = GetElement(self.m_root, "txtLoveV_SceneMarryWedding", WZUILabelTTF)
    txtLoveV:setScale(0.8)
    txtLoveV:setRelativePosition(GlobalMethod:ccp(0.14244,0.346105))
end


function SceneMarryWedding:_adaptLanguage_tr(  )
    local txtLoveLog = GetElement(self.m_root,"txtLoveLog_SceneMarryWedding",WZUILabelTTF)
    txtLoveLog:setDimensions(GlobalMethod:CCSize(120,0))
    txtLoveLog:setScale(0.75)
    local txtLoveLogPress = GetElement(self.m_root,"txtLoveLogPress_SceneMarryWedding",WZUILabelTTF)
    txtLoveLogPress:setDimensions(GlobalMethod:CCSize(120,0))
    txtLoveLogPress:setScale(0.75)

    local txtSendGiftC = GetElement(self.m_root,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF)
    txtSendGiftC:setRelativePosition(GlobalMethod:ccp(0.58303,0.451613))
    txtSendGiftC:setFontSize(20)
    txtSendGiftC:setDimensions(GlobalMethod:CCSize(140,0))

    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    txtCostLife:setScale(0.55)
    txtCostLife:setRelativePosition(GlobalMethod:ccp(0.108333,0.5))

    GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF):setScale(0.8)
end

function SceneMarryWedding:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtLoveLevel_SceneMarryWedding",WZUILabelTTF):setFontSize(16)
    local txtLoveLog = GetElement(self.m_root,"txtLoveLog_SceneMarryWedding",WZUILabelTTF)
    txtLoveLog:setDimensions(GlobalMethod:CCSize(120,0))
    txtLoveLog:setFontSize(20)

    local txtLoveLogPress = GetElement(self.m_root,"txtLoveLogPress_SceneMarryWedding",WZUILabelTTF)
    txtLoveLogPress:setDimensions(GlobalMethod:CCSize(120,0))
    txtLoveLogPress:setFontSize(20)

    local txtSendGiftC = GetElement(self.m_root,"txtSendGiftC_SceneMarryWedding",WZUILabelTTF)
    txtSendGiftC:setRelativePosition(GlobalMethod:ccp(0.58,0.451613))
    txtSendGiftC:setFontSize(18)
    txtSendGiftC:setDimensions(GlobalMethod:CCSize(140,0))

    local txtLoveLogPress = GetElement(self.m_root,"txtSpouse_SceneMarryWedding",WZUILabelTTF)
    txtLoveLogPress:setDimensions(GlobalMethod:CCSize(140,0))
    txtLoveLogPress:setFontSize(20)

    local txtCostLife = GetElement(self.m_root,"txtCostLife_SceneMarryWedding",WZUILabelTTF)
    txtCostLife:setScale(0.5)
    txtCostLife:setRelativePosition(GlobalMethod:ccp(0.1,0.5))

    local imgVigor = GetElement(self.m_root,"imgVigor_SceneMarryWedding",WZUIImage)
    imgVigor:setScale(0.2)
    imgVigor:setRelativePosition(GlobalMethod:ccp(0.759,0.5))

    local txtLoveV = GetElement(self.m_root, "txtLoveV_SceneMarryWedding", WZUILabelTTF)
    txtLoveV:setScale(0.8)
    txtLoveV:setRelativePosition(GlobalMethod:ccp(0.14244,0.346105))
end
-------------------------------------私有方法模块End----------------------------------------
