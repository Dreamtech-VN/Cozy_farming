--WndFootMark.lua
--@brief    WndFootMark的UI模块
--@date     2017/11/21
--@author   Tianxiang_Xu
--@note     足迹系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndFootMark:onEnter(element)
    self.m_root = element
    ProtocolProcessorFootMark:regAll()

    self:updatePartner()
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndFootMark:onExit(element)
    --足迹
    FootEffectManager:getInstance():destroy()
    SceneCity:initFootLayer()
    local conForMount = GetElement(self.m_root, "conForMount_WndFootMark", WZUIContainer)
    conForMount:disableSchedule()

    self:_unInit()
end

function WndFootMark:onEnterTransitionDidFinish(element)
    --body 
    ChangeChatChannel(Chat_Channel_FootMark)
    ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark( )
    self:initFootLayer()
    self:_addTop()
    AdaptLanguage(self)

    local isEndTeach19, teachStep19 = TeachGroup1:isTeachFinish(19)
    if isEndTeach19 ~= true and teachStep19 > 1 and CacheCenter:getPlayerInfo().level == 26 then
        TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {19,3,WndPets.m_root})
    end
end

--@brief  更新伙伴
function WndFootMark:updatePartner()
  local check1 = GetElement(self.m_root,"checkbox1_WndPartner",WZUICheckBox)
  local check2 = GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox)
  local check3 = GetElement(self.m_root,"checkbox3_WndPartner",WZUICheckBox)

  SceneCity:setRedPoint(check1, CacheCenter:getRedState("btnPet"), GlobalMethod:ccp(115,55))
  SceneCity:setRedPoint(check2, CacheCenter:getRedState("btnMount"), GlobalMethod:ccp(115,55))
end

--@brief  宠物被选中时调用的函数
function WndFootMark:onPetSelect(element)
  if WndPets.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndPets = WndPets:createElement()
    if wndPets ~= nil then
        WindowManager:addWindow(wndPets, WndPets, false)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
  
end

--@brief  坐骑被选中时调用的函数
function WndFootMark:onMountSelect(element)
  if WndMounts.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndMounts = WndMounts:createElement()
    if wndMounts ~= nil then
        WindowManager:addWindow(wndMounts, WndMounts, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
end

--@brief  足迹被选中时调用的函数
function WndFootMark:onFootSelect(element)
  if WndFootMark.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndFootMark = WndFootMark:createElement()
    if wndFootMark ~= nil then
        WindowManager:addWindow(wndFootMark, WndFootMark, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
  end
end

function WndFootMark:initFootLayer()
    if not self.m_root then
        return
    end
    local conMountRole = GetElement(self.m_root, "conMountRole_WndFootMark", WZUIContainer)
    FootEffectManager:getInstance():setFootLayer(conMountRole)
end

--@brief    点击关闭按钮回调
function WndFootMark:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击右边足迹列表回调
function WndFootMark:onClickFootMark(footMarkId)
    -- body
    if self.m_nCurSelFootMarkId == footMarkId then return end

    self:updateMountInfo(footMarkId)
end

--@brief    点击解锁或获得按钮回调
function WndFootMark:onUnlock()
    WZLog("---------------onUnlock------------", self.m_nCurSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local curTcell = self.m_tFootCellList[self.m_nCurSelIndex].tcell
    curTcell:onUnlock()
    self:updateMountInfo()
end

--@brief    点击升级按钮回调
function WndFootMark:onUpLevel(element)
    WZLog("WndFootMark:onAddStar ",self.m_nCurSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData =  self.m_tFootMarkList[self.m_nCurSelIndex]
    if tData.remainTime ~= -1 then
        MsgBoxManager:showTipBox(LocalStrings.FOOTMARK_TEXT6)
    else
        WndFootMarkUpgrade:showInterface(self.m_tFootMarkList[self.m_nCurSelIndex], 1)
    end
end

--@brief    点击精炼按钮回调
function WndFootMark:onAddStar(element)
    WZLog("WndFootMark:onAddStar ",self.m_nCurSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tData =  self.m_tFootMarkList[self.m_nCurSelIndex]
    if tData.remainTime ~= -1 then
        MsgBoxManager:showTipBox(LocalStrings.FOOTMARK_TEXT7)
    else
        WndFootMarkUpgrade:showInterface(self.m_tFootMarkList[self.m_nCurSelIndex], 2)
    end
end

--@brief    点击查看总战斗力
function WndFootMark:onClickTotalFighting(element)
    WZLog("WndFootMark:onClickTotalFighting")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local parent = GetElement(self.m_root,"conMountsFight_WndFootMark",WZUIContainer)
    local tData = {attack=0,defend=0,hp=0,critRate=0,reduceCrit=0 }

    local nCurTime = SystemTime:getServerTime()
    for k,v in pairs(self.m_tFootMarkList) do
        -- 对属性数据进行修改
        if v.remainTime == -1 or v.remainTime > nCurTime then
            local t = self:_getProperty(v.property)
            tData.attack = tData.attack + t.attack
            tData.defend = tData.defend + t.defend
            tData.hp = tData.hp + t.hp
            tData.critRate = tData.critRate + t.crit
            tData.reduceCrit = tData.reduceCrit + t.reduceCrit
        end
    end
    WndTips:show(element,parent,46,tData,GlobalMethod:ccp(110,120))
end

--@brief    点击角色回调
function WndFootMark:onClickRole(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:showRunAni()
end

--@brief    展示跑动效果
function WndFootMark:showRunAni()
    -- body
    if not self.m_bIsFirst then return end 
    self.m_nRunIndex = 1 
    self.m_tOldFootPos = nil 
    local conForMount = GetElement(self.m_root, "conForMount_WndFootMark", WZUIContainer)
    conForMount:enableSchedule("_updateFootMarkPosition")
end

--@brief    更新足迹信息，包括（激活、升级、精炼）
function WndFootMark:updateNewFootMarkData(id, originType, result)
    -- 当不在界面收到激活消息不处理
    if not self.m_root then 
        return 
    end

    local isResult = false
    if result == 1 then 
        isResult = true
    end
    if originType == 1 then
        WZLog("---------------new FootMark add----------------")
        self:initAllFootMarkData()
        WndFootMarkActive:showInterface(id)
    else
        -- 更新数据，更新cell
        WZLog("---------------FootMark update----------------")
        self:_updateSingleCell(id)
        self:_updateFightingAndLvAndStar()
        -- 假如是精炼或者升级，更新当前界面
        local index, newData = self:getIndexById(id)
        WndFootMarkUpgrade:updateMountsUI(newData,isResult)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    金币钻石栏
function WndFootMark:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/pet/commom_icon_hb3.png",WndFootMark,WndFootMark.onClickClose,true,false,false,"WndFootMark")
end

--@brief    初始化文本
function WndFootMark:_initStaticText()
    -- body
    --提示语
    local txtTipsAtt = GetElement(self.m_root, "txtTipsAtt_WndFootMark", WZUILabelTTF)
    if txtTipsAtt then 
        txtTipsAtt:setText(LocalStrings.FOOTMARK_TEXT5)
    end
end

--@brief    更新
function WndFootMark:_update()
    -- body
    self:_initStaticText()
    self:_createMountsList()
    self:_updateFight()
end

--@brief    显示足迹的属性和战力
function WndFootMark:_initFightTips()
    local _, tProperty, tAttr = self:_getProperty(self.m_tFootMarkList[self.m_nCurSelIndex].property)

    for i = 1, #tProperty do
        local text = [[<T C="105,65,46" S="22" >%s</T><T C="128,54,13" S="22" >%d</T>]]
        local txtPro = GetElement(self.m_root, "ftbPro"..i.."_WndFootMark", WZUIFreeTextBox)
        txtPro:setShowText(string.format(text, ATTR_TITLE[tAttr[i]], tProperty[i]))
    end

    local fight = self:getFight(self.m_tFootMarkList[self.m_nCurSelIndex].property)
    local ftbFight = GetElement(self.m_root, "ftbFight_WndFootMark", WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FOOTMARK_TEXT1, fight))
end

--@brief    一次性创建足迹列表
function WndFootMark:createMountsListOnce()
    local tab = GetElement(self.m_root,"tabList_WndFootMark",WZUITableContainer)
    tab:cleanTable()
    local nCurTime = SystemTime:getServerTime()

    for i = 1, #self.m_tFootMarkList do
        local data = self.m_tFootMarkList[i]
        if data then
            local element, tcell = CellFootMark:createElement()
            element:setTag(i-1)
            tab:setCellElement(element)
            -- 对属性数据进行修改
            if data.remainTime == -1 or data.remainTime > nCurTime then
                local t = self:_getProperty(data.property)
                data.descProperty = t
            end
            tcell:setCellAllElement(data)
            self:setCellData(i, element, tcell)
        end
    end
    self:updateMountInfo()
end

--@brief    创建足迹列表
function WndFootMark:_createMountsList()
    local tab = GetElement(self.m_root,"tabList_WndFootMark",WZUITableContainer)
    tab:cleanTable()


    self.m_tFootCellList = {}
    self:_updateFootMarkNum()

    self:createMountsListOnce()
end

--@brief    足迹数量
function WndFootMark:_updateFootMarkNum()
    -- body
    local nCurTime = SystemTime:getServerTime()
    local haveCnt = 0

    for i = 1, #self.m_tFootMarkList do
        if self.m_tFootMarkList[i].remainTime == -1 or self.m_tFootMarkList[i].remainTime > nCurTime then
            haveCnt = haveCnt + 1
        end
    end

    -- 显示当前足迹的数量
    local txtCnt = GetElement(self.m_root,"txtMountCnt_WndFootMark",WZUILabelTTF)
    txtCnt:setText(haveCnt.."/".. #self.m_tFootMarkList)
end

--@brief    更新战斗力
function WndFootMark:_updateFight()
    local fight = 0
    local nCurTime = SystemTime:getServerTime()

    for k,v in pairs(self.m_tFootMarkList) do
        if v.remainTime == -1 or v.remainTime > nCurTime then
            fight = fight + self:getFight(v.property)
            WZLog("------------------_updateFight---------------",fight)
        end
    end
    local labFight = GetElement(self.m_root,"labFireCnt_WndFootMark",WZUILabelAtlasFont)
    labFight:setText(fight)
end

--@brief    创建角色和坐骑、足迹动画
function WndFootMark:_createRoleAndMount(data)
    local conAni = GetElement(self.m_root, "conMountRole_WndFootMark", WZUIContainer)
    if conAni:getChildByTag(99) then return end

    local equipList = CacheCenter:getEquipedDecorationList()
    local head, body = CacheCenter:getHeadAndBodyColor()
    if CacheCenter:getPlayerInfo().mountsId then 
        self.mountAni = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait", nil, nil, nil, nil, nil, nil, nil, head, body, false)
        self.mountAni:setMount(CacheCenter:getPlayerInfo().mountsId)
    else
        self.mountAni = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait0", nil, nil, nil, nil, nil, nil, nil, head, body, false)
    end
    local node = self.mountAni:getAnimNode()
    node:setScale(0.75)
    conAni:addChild(node, 0, 99)
    self.firstPost = self.mountAni:getPosition()
    WZLog("WndFootMark:_createRoleAndMount:",self.firstPost.x)
end

--@brief    更新cell的选中状态
function WndFootMark:_updateCellSel()
    WZLog("--------------update sel----------------",self.m_nCurSelIndex)
    for i = 1, #self.m_tFootCellList do
        local tcell = self.m_tFootCellList[i].tcell
        tcell:setSelectState(self.m_nCurSelIndex == i)
    end

    -- 足迹特效
    local spine = GetElement(self.m_root,"spineDress_WndFootMark",WZUISpine)
    spine:play("2",false)
end

--@brief    更新足迹信息
--@param    footMarkId:足迹Id
function WndFootMark:updateMountInfo(footMarkId)
    if footMarkId then
        self.m_nCurSelFootMarkId = footMarkId
    else
        if self.m_nCurSelFootMarkId == nil then
            self.m_nCurSelFootMarkId = self.m_tFootMarkList[1].id
            self.m_nCurSelIndex = 1
        end
    end

    local data = nil
    WZLog("WndFootMark:updateMountInfo ", self.m_nCurSelFootMarkId)
    for i, v in ipairs(self.m_tFootMarkList) do
        if self.m_nCurSelFootMarkId == v.id then
            local nCurTime = SystemTime:getServerTime()
            if v.remainTime == -1 or v.remainTime > nCurTime then
                v.isHave = true
            else
                v.isHave = false
            end
            data = v
            self.m_nCurSelIndex = i 
            break
        end
    end

    self:_updateCellSel()
    
    local state = {data.isHave, not data.isHave}
    WZLog("WndFootMark:updateMountInfo ", state[1], state[2])
    for i = 1, 2 do
        local conInfo = GetElement(self.m_root, "conInfo" .. i .. "_WndFootMark", WZUIContainer)
        local conBtn = GetElement(self.m_root, "conBtn" .. i .. "_WndFootMark", WZUIContainer)
        conInfo:setVisible(state[i])
        conBtn:setVisible(state[i])
    end

    if data.isHave then
        -- 名字和等级
        local txtName = GetElement(self.m_root,"txtMountName_WndFootMark",WZUILabelTTF)
        local txtLv = GetElement(self.m_root,"txtMountLv_WndFootMark",WZUILabelTTF)
        local maxLv = self:_getMountMaxLevel(data)
        txtName:setText(data.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
        txtLv:setText("Lv"..data.upgradeLevel.."/"..maxLv)
        txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])

        -- 星级
        local starCnt = data.advancedLevel
        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
        for i =1, 10 do
            local index = starCnt >= i and 1 or 2
            local star = GetElement(self.m_root,"imgStar"..i.."_WndFootMark",WZUIImage)
            star:setFile(imgPath[index])
        end
    else
        local txtName = GetElement(self.m_root,"txtMountName2_WndFootMark",WZUILabelTTF)
        txtName:setText(data.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])

        local data = self.m_tFootCellList[self.m_nCurSelIndex].tcell:getWayResult()
        WZLog("WndFootMark:updateMountInfo 22222", Serialize(data))
        if not data.isUnlock then
            local visible = data.type == 3 and true or false
            local conBuy = GetElement(self.m_root,"conBuy_WndFootMark",WZUIContainer)
            local conNotBuy = GetElement(self.m_root,"conNotBuy_WndFootMark",WZUIContainer)
            conBuy:setVisible(visible)
            conNotBuy:setVisible(not visible)
            if data.type == 3 then
                local itemInfo = GDatatab_item["id_" .. data.payId]
                local ftb = GetElement(self.m_root,"ftbBuy_WndFootMark",WZUIFreeTextBox)
                if data.payId == 1 or data.payId == 2 or data.payId == 70 then
                    ftb:setShowText(string.format(LocalStrings.FOOTMARK_TEXT16,data.payCnt,itemInfo.icon))
                else
                    local lolStr = string.format(LocalStrings.FOOTMARK_TEXT17,itemInfo.icon,itemInfo.name,data.payCnt) 
                    if self.m_tFootCellList[self.m_nCurSelIndex].tcell:_judgeLockState() then
                        lolStr = string.format(LocalStrings.FOOTMARK_TEXT24,itemInfo.icon,itemInfo.name,data.payCnt) 
                    end
                    WZLog("WndFootMark:updateMountInfo =",lolStr)
                    ftb:setShowText(lolStr)
                end
                if ProjConfig.LANGUAGE == "pt" then
                    ftb:setScale(0.8)
                end
            else
                local txtLock = GetElement(self.m_root,"txtLockDesc_WndFootMark",WZUILabelTTF)
                txtLock:setText(data.str)
            end
        else
            local conBuy = GetElement(self.m_root,"conBuy_WndFootMark",WZUIContainer)
            local conNotBuy = GetElement(self.m_root,"conNotBuy_WndFootMark",WZUIContainer)
            conBuy:setVisible(false)
            conNotBuy:setVisible(false)
        end
    end
    self:_createRoleAndMount(data)
    self:_initFightTips()
end

--@brief    优化更新，更新足迹列表的单个cell，isModifyInfo 是否改变左边的足迹信息
function WndFootMark:_updateSingleCell(id, isModifyInfo)
    local tab = GetElement(self.m_root,"tabList_WndFootMark",WZUITableContainer)
    self:updateByCacheCenterById(id)
    local index, newData = self:getIndexById(id)
    WZLog("--------------------cell Index----------------",index,newData.basicInfo.name)

    local tcell = self.m_tFootCellList[index].tcell
    tcell:updateData(newData)
    self:_updateFight()

    -- 出站坐骑需要更新
    local nCurFootMarkId = CacheCenter:getUsingFootMarkId()
    if nCurFootMarkId == newData.id and isModifyInfo then
        self:updateMountInfo(newData)
    end
end

function WndFootMark:_updateFightingAndLvAndStar()
    self:_initFightTips()
    self:_updateFight()


    local data = self.m_tFootMarkList[self.m_nCurSelIndex]

    -- 更新cell的信息
    local tcell = self.m_tFootCellList[self.m_nCurSelIndex].tcell
    local index,newData = self:getIndexById(data.id)
    tcell:updateData(newData)

    -- 名字和等级
    local txtName = GetElement(self.m_root,"txtMountName_WndFootMark",WZUILabelTTF)
    local txtLv = GetElement(self.m_root,"txtMountLv_WndFootMark",WZUILabelTTF)
    local maxLv = self:_getMountMaxLevel(data)
    txtName:setText(data.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
    txtLv:setText("Lv"..data.upgradeLevel.."/"..maxLv)
    txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])

    -- 星级
    local starCnt = data.advancedLevel
    local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
    for i =1, 10 do
        local index = starCnt >= i and 1 or 2
        local star = GetElement(self.m_root,"imgStar"..i.."_WndFootMark",WZUIImage)
        star:setFile(imgPath[index])
    end
end

--@brief 足迹刷新
function WndFootMark:updateFootEffect()
    local pos = self.mountAni:getPosition()
    if not self.m_tOldFootPos then
        self.m_tOldFootPos = pos
        self.m_tOriginPos = pos 
    end
    local footId = self.m_nCurSelFootMarkId
    local distance = GDatatab_footmark["id_" .. footId] and GDatatab_footmark["id_" .. footId].distance or 40
    if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
        self.m_tOldFootPos = pos
        FootEffectManager:getInstance():addEffect(footId, pos, 45, self.mountAni:getAnimNode():getScaleX(),self.mountAni:getAnimNode():getScaleY())
    end
end

--@brief    刷新角色位置
function WndFootMark:_updateFootMarkPosition(element)
    -- body
    if self.mountAni == nil then return end 

    local pos = self.mountAni:getPosition()
    pos.x = pos.x + 10
    if self.m_bIsFirst then 
        self.m_nMoveMaxDis = 300 
        --self.mountAni:setFlipX(true)
        self.m_bIsFirst = false 
        if CacheCenter:getPlayerInfo().mountsId ~= nil then
            local name
            if CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 1 then
                name = "wait"
            elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 2 then
                name = "walk2"
            elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 3 then
                name = "walk3"
            elseif CacheCenter:getPlayerInfo().mountsType and CacheCenter:getPlayerInfo().mountsType == 4 then
                name = "walk4"
            else
                name = "walk"
            end
            self.mountAni:play(name, true)
        else
            self.mountAni:play(g_tRoleAnitionName[3], true)
        end
    end
    self.mountAni:setPosition(pos)
    self:updateFootEffect()

    if self.m_nMoveMaxDis > 0 then 
        self.m_nMoveMaxDis = self.m_nMoveMaxDis - 10
    else
        if self.m_nRunIndex == 1 then 
            self.m_nRunIndex = 2
            self.m_nMoveMaxDis = 300 
            pos.x = pos.x - 600
            self.mountAni:setPosition(pos)
        elseif self.m_nRunIndex == 2 then 
            if CacheCenter:getPlayerInfo().mountsId ~= nil then
                self.mountAni:play("wait", true)
            else
                self.mountAni:play("wait0", true)
            end
            self.mountAni:setFlipX(false)
            self.mountAni:setPosition(self.firstPost)
            element:disableSchedule()
            self.m_bIsFirst = true
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------------
function WndFootMark:_adaptLanguage_es( )
    local txtTipsAtt = GetElement(self.m_root,"txtTipsAtt_WndFootMark",WZUILabelTTF)
    txtTipsAtt:setScale(0.7)
    txtTipsAtt:setDimensions(GlobalMethod:CCSize(350,0))

    GetElement(self.m_root,"txtLockDesc_WndFootMark",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"ftbBuy_WndFootMark",WZUIFreeTextBox):setScale(0.7)
end

function WndFootMark:_adaptLanguage_en(  )
    -- GetElement(self.m_root,"imgBtn2_1_WndFootMark",WZUIImage):setScale(0.8)
    -- GetElement(self.m_root,"imgBtn2_2_WndFootMark",WZUIImage):setScale(0.8)
    -- GetElement(self.m_root,"imgBtn2_3_WndFootMark",WZUIImage):setScale(0.8)
    
end

function WndFootMark:_adaptLanguage_tr(  )
    local txtTipsAtt = GetElement(self.m_root,"txtTipsAtt_WndFootMark",WZUILabelTTF)
    txtTipsAtt:setScale(0.7)
    txtTipsAtt:setDimensions(GlobalMethod:CCSize(350,0))

    -- GetElement(self.m_root,"imgBtn2_1_WndFootMark",WZUIImage):setScale(0.7)
    -- GetElement(self.m_root,"imgBtn2_2_WndFootMark",WZUIImage):setScale(0.7)
    -- GetElement(self.m_root,"imgBtn2_3_WndFootMark",WZUIImage):setScale(0.7)

    local ftbFight = GetElement(self.m_root, "ftbFight_WndFootMark", WZUIFreeTextBox)
    ftbFight:setScale(0.8)
    
end

function WndFootMark:_adaptLanguage_pt()
    GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer5_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer6_WndStrengthen",WZUILabelTTF):setScale(0.75)
end

function WndFootMark:_adaptLanguage_vn(  )
    GetElement(self.m_root,"btnjl1_WndFootMark",WZUIImage):setScale(0.8)
    GetElement(self.m_root,"btnjl2_WndFootMark",WZUIImage):setScale(0.8)
    GetElement(self.m_root,"imgBtn2_3_WndFootMark",WZUIImage):setScale(0.8)
end
-------------------------------------语言适配End------------------------------------------------