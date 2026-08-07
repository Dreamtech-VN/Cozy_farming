--WndFootMarkUpgrade.lua
--@brief	WndFootMarkUpgrade的UI模块
--@date		2017/11/21
--@author	Tianxiang_Xu
--@note		足迹系统-升级、精炼


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootMarkUpgrade:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)
    -- 注册动画回调
    local aniLv = GetElement(self.m_root,"armUpgrade_WndFootMarkUpgrade",WZArmature)
    aniLv:setAnimationFinishLuaFunction("armUpdateFinish")
    local aniStar = GetElement(self.m_root,"armAddStar_WndFootMarkUpgrade",WZArmature)
    aniStar:setAnimationFinishLuaFunction("armAddStarFinish")

    local conLog = GetElement(self.m_root,"conLog_WndFootMarkUpgrade",WZUIContainer)
    conLog:setVisible(false)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootMarkUpgrade:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end


--@brief	打开加载动画
function WndFootMarkUpgrade:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

function WndFootMarkUpgrade:actionCallback()
    self:_initUI()
end

-- 创建加载框
function WndFootMarkUpgrade:createLoading()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoading)
        WZLog("--------------create loading-----------------~",self.loadingId)
    end
end

-- 关闭加载框
function WndFootMarkUpgrade:closeLoading()
    WZLog("--------------close loading-----------------",self.loadingId)
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
    self.isClick = true
end

function WndFootMarkUpgrade:onTouchBegin()
    if self.logTime == 0 then
        local conLog = GetElement(self.m_root,"conLog_WndFootMarkUpgrade",WZUIContainer)
        conLog:setVisible(false)
    end
end

-- 更新坐骑UI信息
function WndFootMarkUpgrade:updateMountsUI(data,isResult)
    WZLog("----------------cur update result--------------",isResult)
    if not self.m_root then return end
    -- 先更新本地的数据
    self.m_tData =  data
    self.isResult = isResult
    self:closeLoading()

    if self.flag == 1 then
        WZLog("---------------player up ani----------------")
        self:_playAddStarAndUpdateAni(isResult)
        self:_initUpLvUI()
    else
        WZLog("---------------player star ani----------------")
        self:_playAddStarAndUpdateAni(isResult)
        self:_initAddStarUI()
    end
end

function WndFootMarkUpgrade:onReturnActionCallback()
    WindowManager:removeWindow(self.m_root, self,true)
end

--@brief	关闭足迹信息界面
function WndFootMarkUpgrade:onClose()
   SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end

-- 更新进阶丹数量
function WndFootMarkUpgrade:updatePillCnt()
	local tTempData = GDatatab_footmark_advanced["id_" .. self.m_tData.advancedLevel]
	if tTempData == nil then return end 
    local myPill = CacheCenter:getPlayerItemCountById(tTempData.xost[1][1])
    local txtCnt =  GetElement(self.m_root,"txtPillCnt_WndFootMarkUpgrade",WZUILabelTTF)
    txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT,myPill))
end

--@brief	精炼足迹调
function WndFootMarkUpgrade:onAddStar()
    WZLog("--------------------player want to addStar--------------",self.isClick)
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大进阶等级，无需进阶
    if self.m_tData.advancedLevel >= self.maxStarLevel then
        MsgBoxManager:showTipBox(LocalStrings.FOOTMARK_TEXT14)
        return
    end

    -- 等级不足
    local nextLevel = self.m_tData.advancedLevel + 1
    local nextStartData = GDatatab_footmark_advanced["id_" .. nextLevel]
    if self.m_tData.upgradeLevel < nextStartData.need_level then
        MsgBoxManager:showTipBox(string.format(LocalStrings.FOOTMARK_TEXT15, nextStartData.need_level))
        return
    end

    -- 进阶丹不足
    local costId, costNum = nextStartData.cost[1][1], nextStartData.cost[1][2]
    local myPill = CacheCenter:getPlayerItemCountById(costId)
    if JudgeMoneyIsEnough(costId, costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
        self.isClick = false
        self:createLoading()
        ProtocolProcessorFootMark:send_FOOTMARK_AdvancedFootmark(self.m_tData.id)
    end
end

-- 升级坐骑回调
function WndFootMarkUpgrade:onUpgrade()
    WZLog("--------------------player want to upgrade-----------------")
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大等级无需升级
    if self.m_tData.upgradeLevel >= self.maxUpLevel then
        MsgBoxManager:showTipBox(LocalStrings.FOOTMARK_TEXT13)
        return
    end

    local upData
    for k,v in pairs(GDatatab_footmark_upgrade) do
        if v.level == self.m_tData.upgradeLevel then  upData = v end
    end
    local needCost = upData.cost[1][2]
    if JudgeMoneyIsEnough(upData.cost[1][1], needCost, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
        self.isClick = false
        self:createLoading()
        ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark(self.m_tData.id, 1)
    end
end

-- 升级坐骑回调
function WndFootMarkUpgrade:onUpgrade5()
    WZLog("--------------------player want to upgrade-----------------")
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大等级无需升级
    if self.m_tData.upgradeLevel >= self.maxUpLevel then
        MsgBoxManager:showTipBox(LocalStrings.FOOTMARK_TEXT13)
        return
    end

    local needCost = {}
    local mLv = self.m_tData.upgradeLevel
    for i = mLv, mLv + self.leftLv do
        local data = GDatatab_footmark_upgrade["id_" .. i]
        if needCost[1] == nil then 
            needCost[1] = {}
            needCost[1].costId = data.cost[1][1]
            needCost[1].costNum = data.cost[1][2]
        else
            if needCost[1].costId == data.cost[1][1] then 
                needCost[1].costNum = needCost[1].costNum + data.cost[1][2]
            else
                if needCost[2] == nil then 
                    needCost[2] = {}
                    needCost[2].costId = data.cost[1][1]
                    needCost[2].costNum = data.cost[1][2]
                else
                    if needCost[2].costId == data.cost[1][1] then 
                        needCost[2].costNum = needCost[2].costNum + data.cost[1][2]
                    end
                end
            end
        end
    end
    WZLog("--------------costCnt-------------!", Serialize(needCost), self.leftLv)
    local nTrueNum = 0 
    for i = 1, #needCost do
        if needCost[i] and JudgeMoneyIsEnough(needCost[i].costId, needCost[i].costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
            nTrueNum = nTrueNum + 1
        end
    end
    if nTrueNum == #needCost then 
        self.isClick = false
        self:createLoading()
        ProtocolProcessorFootMark:send_FOOTMARK_UpgradeFootmark(self.m_tData.id, self.leftLv)
    end
end
---------------------------------------私有方法模块End----------------------------------------

-- 坐骑属性转换，按照攻击，防御，血量，暴击，防爆数组排序
function WndFootMarkUpgrade:_changeProperty(property)
    local data = {hp = 0, attack = 0, defend = 0, crit = 0, reduceCrit = 0 }
    if property then
        for k,v in pairs(property) do
            if v[1] == PRO_HP then
                data.hp = v[2]
            elseif v[1] == PRO_ATTACK then
                data.attack = v[2]
            elseif v[1] == PRO_DEFEND then
                data.defend = v[2]
            elseif v[1] == PRO_AGILITY then
                data.crit = v[2]
            elseif v[1] == PRO_LUCK then
                data.reduceCrit = v[2]
            end
        end
    end
    local sortData = {data.hp,data.attack,data.defend,data.crit,data.reduceCrit}
    return sortData
end

-- 进阶动画播放完毕
function WndFootMarkUpgrade:armAddStarFinish()
    WZLog("-----------------star ani end--------------")
    local ani = GetElement(self.m_root,"armAddStar_WndFootMarkUpgrade",WZArmature)
    ani:setVisible(false)
    self.isClick = true
--    local imgPath = self.isResult and "ui/common/common_icon_jjz.png" or "ui/common/common_icon_jjsb.png"
--    PopupResult(imgPath)
end

-- 升级动画播放完毕
function WndFootMarkUpgrade:armUpdateFinish()
    WZLog("-----------------up ani end--------------")
    local ani = GetElement(self.m_root,"armUpgrade_WndFootMarkUpgrade",WZArmature)
    ani:setVisible(false)
    self.isClick = true
--    local imgPath = self.isResult and "ui/common/common_icon_sjcg.png" or "ui/common/common_icon_sjsb.png"
--    PopupResult(imgPath)
end

-- 播放动画
function WndFootMarkUpgrade:_playAddStarAndUpdateAni(isResult)
    local aniUp = GetElement(self.m_root,"armUpgrade_WndFootMarkUpgrade",WZArmature)
    local aniStar = GetElement(self.m_root,"armAddStar_WndFootMarkUpgrade",WZArmature)
    local ani = self.flag == 1 and aniUp or aniStar
    local state = self.flag == 1 and true or false
    aniUp:setVisible(state)
    aniStar:setVisible(not state)
    local armature = ani:getArmature()
    local index = isResult and 0 or 1
    armature:getAnimation():playByIndex(index,-1,-1,0)


    if self.flag == 1 then
        local imgPath = isResult and "ui/common/common_icon_sjz.png" or "ui/common/common_icon_sjsb.png"
        PopupResult(imgPath)
        SoundManager:playEffectSound(SoundDefine.E_MUSIC_ISUPGRADE)
    elseif self.flag == 2 then
        local imgPath = isResult and "ui/common/common_icon_jlcg.png" or "ui/common/common_icon_jlsb.png"
        PopupResult(imgPath)
        SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
    end
end

--更新商品购买后的界面显示
function WndFootMarkUpgrade:updatePlayerItemData()
   WZLog("WndFootMarkUpgrade:updatePlayerItemData")
   if self.upCost then
    local myPill = CacheCenter:getPlayerItemCountById(self.upCost)
    local txtCnt =  GetElement(self.m_root, "txtUpCnt_WndFootMarkUpgrade", WZUILabelTTF)
    txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT, myPill))
   end
   if self.starCost then
     -- 当前进阶数据和下次进阶数据
        myPill = CacheCenter:getPlayerItemCountById(self.starCost)
        txtCnt =  GetElement(self.m_root, "txtPillCnt_WndFootMarkUpgrade", WZUILabelTTF)
        txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT, myPill))
    end
end
------------------------------------------------------------------------------------------------------------------------

function WndFootMarkUpgrade:_initUpLeftLv()
    local pLevel = CacheCenter:getPlayerInfo().level
    local mLevel = self.m_tData.upgradeLevel
	-- if self.m_tData.basicInfo.quality == 4 and CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion ~= nil then
	-- 	pLevel = pLevel + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
	-- end
    local lv = pLevel - mLevel
    WZLog("-----------initUpLeftLv------------",pLevel,mLevel,lv)
    self.leftLv = 1
    if lv > 0 and lv < 5 then
        self.leftLv = lv
    elseif lv >= 5 then
        self.leftLv = 5
    end
    if mLevel >= self.maxUpLevel then self.leftLv = 0 end
end

-- 初始化坐骑UI
function WndFootMarkUpgrade:_initUI()
    -- 标题
    local title = GetElement(self.m_root,"txtTitle_WndFootMarkUpgrade",WZUILabelTTF)
    -- 显示升级或者进阶
    local conLv =  GetElement(self.m_root,"conUp_WndFootMarkUpgrade",WZUIContainer)
    local conStar =  GetElement(self.m_root,"conStar_WndFootMarkUpgrade",WZUIContainer)
    if self.flag == 1 then
        title:setText(LocalStrings.FOOTMARK_TEXT9)
        conLv:setVisible(true)
        conStar:setVisible(false)
        self:_initUpLvUI()
    else
        title:setText(LocalStrings.FOOTMARK_TEXT8)
        conLv:setVisible(false)
        conStar:setVisible(true)
        self:_initAddStarUI()
    end
    self:_initMountInfo(true,true,true)
end

-- 根据当前的坐骑等级初始化升级UI
-- state= 1可以升级  2表示达到人物等级上限  3表示坐骑已经最高等级
function WndFootMarkUpgrade:_initUpLvUI()
    local state = 1
    local pLevel = CacheCenter:getPlayerInfo().level
    -- if self.m_tData.basicInfo.quality == 4 then
    --     pLevel = pLevel + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
    -- end
    if self.m_tData.upgradeLevel >= self.maxUpLevel then
        state = 3
    elseif self.m_tData.upgradeLevel >= pLevel then
        state = 2
    end
    for i = 1, 3 do
        local con = GetElement(self.m_root,"conUp"..i.."_WndFootMarkUpgrade",WZUIContainer)
        con:setVisible(i == state)
    end
    if state ~= 1 then
        local conRightPro =  GetElement(self.m_root,"conRightPro_WndFootMarkUpgrade",WZUIContainer)
        conRightPro:setVisible(false)
        local conMaxLv =  GetElement(self.m_root,"conMaxLv_WndFootMarkUpgrade",WZUIContainer)
        conMaxLv:setVisible(false)
    end
    self:_initLvPro(state)
    self:_initMountInfo(false,true,false)

    -- 初始化按键显示
    self:_initUpLeftLv()
    local leftCnt =  GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF)
    leftCnt:setText(string.format(LocalStrings.MOUNT_UP_FIVE, self.leftLv))

    self:_updateUpLevelLuckyValue()
end

-- 根据当前的坐骑星级初始化进阶UI
function WndFootMarkUpgrade:_initAddStarUI()
    local state = 1
    local nextStarLv = self.m_tData.advancedLevel + 1
    local nextStartData = GDatatab_footmark_advanced["id_"..nextStarLv]
    if self.m_tData.advancedLevel >= self.maxStarLevel then
        state = 2
    elseif self.m_tData.upgradeLevel < nextStartData.need_level then
        state = 1
    end
    for i = 1, 2 do
        local con = GetElement(self.m_root,"conStar"..i.."_WndFootMarkUpgrade",WZUIContainer)
        con:setVisible(i == state)
    end
    if state ~= 1 then
        local conRightPro =  GetElement(self.m_root,"conRightPro_WndFootMarkUpgrade",WZUIContainer)
        conRightPro:setVisible(false)
        local conMaxStar =  GetElement(self.m_root,"conMaxStar_WndFootMarkUpgrade",WZUIContainer)
        conMaxStar:setVisible(false)
    end
    self:_initStarPro(state)
    self:_initMountInfo(false,false,true)
end

--@brief 	更新足迹基本信息， 优化参数： isCreateMount是否需要创建宠物形象，isLv是否需要更新等级，isStar是否需要更新星级
function WndFootMarkUpgrade:_initMountInfo(isCreateMount,isLv,isStar)
    -- 名字和等级
    local data = self.m_tData

    -- 优化： 只有升级才更新
    if isLv then
        local txtName = GetElement(self.m_root,"txtMountName_WndFootMarkUpgrade",WZUILabelTTF)
        local txtLv = GetElement(self.m_root,"txtMountLv_WndFootMarkUpgrade",WZUILabelTTF)
        txtName:setText(data.basicInfo.name)
        txtLv:setText("Lv"..data.upgradeLevel.."/"..self.maxUpLevel)
        txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
        txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])
    end

    -- 优化：只有精炼才更新
    if isStar then
        -- 星级
        local starCnt = data.advancedLevel
        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
        for i =1, 10 do
            local index = starCnt >= i and 1 or 2
            local star = GetElement(self.m_root, "imgStar" .. i .. "_WndFootMarkUpgrade", WZUIImage)
            star:setFile(imgPath[index])
        end
    end

    -- 优化：绘制足迹，只绘制一次
    if isCreateMount then self:_createRoleAndMount(data) end

    -- 初始化战斗力
    self:_initMountFighting()
end

--@brief	初始化升级属性
function WndFootMarkUpgrade:_initLvPro(state)
    -- 基础数据
    local baseData = self.m_tData.tItem

    -- 当前星级的数据
    local starData
    for k,v in pairs(GDatatab_footmark_advanced) do
        if v.level == self.m_tData.advancedLevel then starData = v end
    end

    -- 上一级和当前等级的升级属性
    local curUpData,nextUpData
    for k,v in pairs(GDatatab_footmark_upgrade) do
        if v.level == self.m_tData.upgradeLevel  then  curUpData = v end
        if v.level == self.m_tData.upgradeLevel + 1 then  nextUpData = v end
    end

    -- 属性
    local mountData = {self.m_tData.descProperty.hp,self.m_tData.descProperty.attack,self.m_tData.descProperty.defend,
        self.m_tData.descProperty.crit, self.m_tData.descProperty.reduceCrit }
    local basePro = self:_changeProperty(baseData.property)
    local nextUpPro
    if nextUpData then nextUpPro = self:_changeProperty(nextUpData.property) end
    local starRate = starData and starData.property_rate or 0
    for i = 1, 5 do
        -- 升级前属性
        local txtP = GetElement(self.m_root,"txtPro"..i.."_WndFootMarkUpgrade",WZUILabelTTF)
        txtP:setText(mountData[i])

        -- 升级后属性
        local add =  GetElement(self.m_root,"txtNextPro"..i.."_WndFootMarkUpgrade",WZUILabelTTF)
        if nextUpPro then
            local EndPro =   math.ceil((basePro[i] + nextUpPro[i]) * (1 + starRate/10000))
            add:setText(EndPro)
        end
    end

    -- 等级显示
    local txtLv1 = GetElement(self.m_root,"txtLv1_WndFootMarkUpgrade",WZUILabelTTF)
    txtLv1:setText(self.m_tData.upgradeLevel)
    if state == 1 then
        -- 下一个等级
        local txtLv2 = GetElement(self.m_root,"txtLv2_WndFootMarkUpgrade",WZUILabelTTF)
        txtLv2:setText(self.m_tData.upgradeLevel+1)

        -- 成功率
        local txtSuccess = GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF)
        txtSuccess:setText(math.floor(curUpData.probability * 100/10000).."%")

        -- 消耗金币
        local txtCost =  GetElement(self.m_root,"txtUpCost_WndFootMarkUpgrade",WZUILabelTTF)
        txtCost:setText(curUpData.cost[1][2])

        --消耗图标
        local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndFootMarkUpgrade", WZUIImage)
        if imgCostIcon then 
            imgCostIcon:setFile(GDatatab_item["id_" .. curUpData.cost[1][1]].icon)
            imgCostIcon:setScale(0.5)
        end
        self.upCost = curUpData.cost[1][1]
        local myPill = CacheCenter:getPlayerItemCountById(curUpData.cost[1][1])
        local txtCnt =  GetElement(self.m_root, "txtUpCnt_WndFootMarkUpgrade", WZUILabelTTF)
        txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT, myPill))
    end
end

-- 初始化进阶属性
function WndFootMarkUpgrade:_initStarPro(state)
    -- 基础数据
    local baseData = self.m_tData.tItem
    
    -- 当前进阶数据和下次进阶数据
    local nextStarData
    for k,v in pairs(GDatatab_footmark_advanced) do
        if v.level == self.m_tData.advancedLevel+1 then nextStarData = v end
    end

    -- 升级数据
    local upData
    for k,v in pairs(GDatatab_footmark_upgrade) do
        if v.level == self.m_tData.upgradeLevel then  upData = v end
    end

    -- 属性
    local data = {self.m_tData.descProperty.hp,self.m_tData.descProperty.attack,self.m_tData.descProperty.defend,
        self.m_tData.descProperty.crit,self.m_tData.descProperty.reduceCrit }
    local basePro = self:_changeProperty(baseData.property)
    local upPro = self:_changeProperty(upData.property)
   
    local nextRate = nextStarData and nextStarData.property_rate or 0
    for i = 1, 5 do
        -- 进阶前属性
        local txtP = GetElement(self.m_root,"txtPro"..i.."_WndFootMarkUpgrade",WZUILabelTTF)
        txtP:setText(data[i])

        -- 进阶后属性
        local add = GetElement(self.m_root,"txtNextPro"..i.."_WndFootMarkUpgrade",WZUILabelTTF)
        if nextStarData then
            local EndPro = math.ceil((basePro[i] + upPro[i]) * (1 + nextRate/10000))
            add:setText(EndPro)
        end
    end

    -- 当前星级显示
    local txtLv1 = GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF)
    txtLv1:setText(self.m_tData.advancedLevel)

    if state == 1 then
        -- 下一个星级显示
        local txtLv2 = GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF)
        txtLv2:setText(self.m_tData.advancedLevel+1)

        local nextLv= self.m_tData.advancedLevel+1

        -- 成功率
        local per = math.ceil(100*(nextStarData.probability/10000))
        WZLog("-------------------per-----------------------",per)
        local txtSuccess =  GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF)
        txtSuccess:setText(per.."%")

        -- 花费进阶丹数量
        local txtCost =  GetElement(self.m_root,"txtStarCost_WndFootMarkUpgrade",WZUILabelTTF)
        WZLog("------------------852-------------",nextStarData.cost[1][2])
        txtCost:setText(nextStarData.cost[1][2])
        --消耗物品的图标
        local imgStarUpCost = GetElement(self.m_root, "imgStarUpCost_WndFootMarkUpgrade", WZUIImage)
        if imgStarUpCost then
            imgStarUpCost:setFile(GDatatab_item["id_" .. nextStarData.cost[1][1]].icon)
            imgStarUpCost:setScale(0.5)
        end
        -- 拥有进阶丹数量
        self.starCost = nextStarData.cost[1][1]
        local myPill = CacheCenter:getPlayerItemCountById(nextStarData.cost[1][1])
        local txtCnt =  GetElement(self.m_root, "txtPillCnt_WndFootMarkUpgrade", WZUILabelTTF)
        txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT, myPill))
    end
    --幸运值
    self:_updateLuckyValue()
end

--@brief	创建角色和足迹动画
function WndFootMarkUpgrade:_createRoleAndMount(data)
    local conIcon = GetElement(self.m_root,"conIcon_WndFootMarkUpgrade",WZUIContainer)
    if conIcon:getChildByTag(99) then conIcon:removeChildByTag(99,true) end
    local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(self.m_tData,10)
        conIcon:addChild(cell,0,99)
    end

    local conAni = GetElement(self.m_root,"conMountRole_WndFootMarkUpgrade",WZUIContainer)
    if conAni:getChildByTag(99) then conAni:removeChildByTag(99,true) end

    local equipList = CacheCenter:getDecorationList()
    local equip = {}
    for k, v in pairs(equipList) do
        if  v.maintype == 5 and v.isUse then table.insert(equip, v.id)  end
    end
    local head, body = CacheCenter:getHeadAndBodyColor()
    local ani 
    if CacheCenter:getPlayerInfo().mountsId then 
        ani = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equip, "wait", nil, nil, nil, nil, nil, nil, nil, head, body, false)
        ani:setMount(CacheCenter:getPlayerInfo().mountsId)
    else
        ani = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait0", nil, nil, nil, nil, nil, nil, nil, head, body, false)
    end
    local node = ani:getAnimNode()
    node:setScale(0.75)
    conAni:addChild(node,0,99)
end

--@brief	初始化足迹战斗力
function WndFootMarkUpgrade:_initMountFighting()
    local curMountFight = self:_getFighting(self.m_tData.property)
    local labFight = GetElement(self.m_root, "labFireCnt_WndFootMarkUpgrade", WZUILabelAtlasFont)
    labFight:setText(curMountFight)
end

--@brief	计算足迹的战斗力
function WndFootMarkUpgrade:_getFighting(data)
	WZLog("WndFootMarkUpgrade:_getFighting", Serialize(data))
    local rate = {1, nil, 4.8, 6, 8, nil, 8,nil, 9.6, 9.6, 9.6, 10, 10, nil,nil,nil,nil,nil,12,12}
    local fight = 0
    for k, v in pairs(data) do
        if type(v) == "table" then  -- 未获取足迹
            k = v[1]
            v = v[2]
        end
        local index = tonumber(k)
        if rate[index] then
            fight = fight + rate[index] * v
            WZLog("-------------info-----------", index, v, rate[index])
        end
    end
    fight = math.ceil(fight * 0.75)
    return fight
end

--@brief	更新升级日志
function WndFootMarkUpgrade:updateUpLog(info)
    local conLog = GetElement(self.m_root, "conLog_WndFootMarkUpgrade", WZUIContainer)
    conLog:setVisible(true)
    conLog:setScale(0)

    local disTime = 0.3
    -- 设置日志
    local costBasicData = GDatatab_item["id_" .. info.cost[1].costId]
    local upCnt = #info.log
    for i = 1, 5 do
        local ftb = GetElement(self.m_root, "tfbLog" .. i .. "_WndFootMarkUpgrade", WZUIFreeTextBox)
        if i <= upCnt then
            local data = info.log[i]
            local startLv = data.level
            local endLv = startLv + 1
            WZLog("----------curInfo-----------",i,startLv,endLv,tonumber(data.cost),data.rate.."%")
            if tonumber(data.result) == 1 then
                ftb:setShowText(string.format(LocalStrings.FOOTMARK_TEXT20, i, startLv, endLv, tonumber(data.cost), costBasicData.name, data.rate .. "%"))
            else
                ftb:setShowText(string.format(LocalStrings.FOOTMARK_TEXT21, i, startLv, endLv, tonumber(data.cost), costBasicData.name, data.rate .. "%"))
            end 
            ftb:setScale(0)
            ftb:setVisible(true)
            local act1 = CCDelayTime:create(0.1 + disTime*i)
            local act2 = CCScaleTo:create(0, 1)
            local act = CCSequence:createWithTwoActions(act1, act2)
            ftb:runAction(act)
        else
            ftb:setVisible(false)
        end
    end

    -- 总消耗
    local ftb = GetElement(self.m_root, "tfbLog6_WndFootMarkUpgrade", WZUIFreeTextBox)
    ftb:setShowText(string.format(LocalStrings.FOOTMARK_TEXT19, upCnt, info.uplevel, info.cost[1].costNum, costBasicData.name))
    ftb:setScale(0)
    local act1 = CCDelayTime:create(0.1 + disTime*(upCnt+1))
    local act2 = CCScaleTo:create(0, 1)
    local act = CCSequence:createWithTwoActions(act1, act2)
    ftb:runAction(act)

    local act1 = CCScaleTo:create(0.1, 1)
    conLog:runAction(act1)

    self.logTime = disTime * (upCnt+1) + 0.1
    conLog:enableSchedule("updateLogTime",self.logTime)
end

function WndFootMarkUpgrade:updateLogTime()
    local conLog = GetElement(self.m_root, "conLog_WndFootMarkUpgrade", WZUIContainer)
    conLog:disableSchedule()
    self.logTime = 0
end

--@brief    更新幸运值进度
function WndFootMarkUpgrade:_updateLuckyValue()
    -- body
    if self.m_root == nil then return end

    local prgLucky = GetElement(self.m_root, "prgLucky_WndFootMarkUpgrade", WZUIProgress)
    local nTempBlessValue = self.m_tData.blessingValue
    
    if prgLucky then
        if nTempBlessValue == nil or nTempBlessValue < 0 then
            nTempBlessValue = 0 
        elseif nTempBlessValue > 100 then
            nTempBlessValue = 100
        end
        prgLucky:setPercentage(nTempBlessValue)
    end

    local txtLuckyValue = GetElement(self.m_root, "txtLuckyValue_WndFootMarkUpgrade", WZUILabelTTF)
    if txtLuckyValue then
        txtLuckyValue:setText(LocalStrings.LUCKVALUE .. ":" .. nTempBlessValue .. "%")
    end
end

--@brief    更新升级幸运值进度
function WndFootMarkUpgrade:_updateUpLevelLuckyValue()
    -- body
    WZLog("WndFootMarkUpgrade:_updateUpLevelLuckyValue")
    if self.m_root == nil then return end

    local prgLucky = GetElement(self.m_root, "prgUpLucky_WndFootMarkUpgrade", WZUIProgress)
    local nTempUpBlessValue = self.m_tData.upgradeBless

    if prgLucky then
        if nTempUpBlessValue == nil or nTempUpBlessValue < 0 then
            nTempUpBlessValue = 0 
        elseif nTempUpBlessValue > 100 then
            nTempUpBlessValue = 100
        end
        prgLucky:setPercentage(nTempUpBlessValue)
    end

    local txtLuckyValue = GetElement(self.m_root, "txtUpLuckyValue_WndFootMarkUpgrade", WZUILabelTTF)
    if txtLuckyValue then
        txtLuckyValue:setText(LocalStrings.LUCKVALUE .. ":" .. nTempUpBlessValue .. "%")
    end
end

-------------------------------------语言适配模块Start----------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndFootMarkUpgrade:_adaptLanguage_en()
    WZLog("---_adaptLanguage_en---")
    local txtUp5 = GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF)
    txtUp5:setDimensions(GlobalMethod:CCSize(100,0))
    txtUp5:setScale(0.8)

	GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.67,0.28))
	GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.67,0.28))

    GetElement(self.m_root,"txtUpgradeLog_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.878504))

    GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.5))
    GetElement(self.m_root,"imgStar11_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.820947,0.5))
    GetElement(self.m_root,"imgStar12_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.921863,0.5))

    local txtPro1 = GetElement(self.m_root,"txtPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro1:setRelativePosition(GlobalMethod:ccp(-0.372208,0.854384))
    local txtPro2 = GetElement(self.m_root,"txtPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(-0.223325,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(-0.210918,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.0248139,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(-0.210918,0.0942922))

    local txtNextPro1 = GetElement(self.m_root,"txtNextPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro1:setRelativePosition(GlobalMethod:ccp(-0.0977667,0.842968))
    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.0511167,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.0635236,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.302035,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.0635236,0.0942922))

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(360))

    for i=1,5 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndFootMarkUpgrade",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1000)
    end

    GetElement(self.m_root, "labFireCnt_WndFootMarkUpgrade", WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.594054,0.5))

    local txtStrengtenTip1 = GetElement(self.m_root,"txtStrengtenTip1_WndFootMarkUpgrade",WZUILabelTTF)
    txtStrengtenTip1:setScale(0.65)
    txtStrengtenTip1:setDimensions(GlobalMethod:CCSize(440))
    local txtStrengtenTip = GetElement(self.m_root,"txtStrengtenTip_WndFootMarkUpgrade",WZUILabelTTF)
    txtStrengtenTip:setScale(0.65)
    txtStrengtenTip:setDimensions(GlobalMethod:CCSize(440))

    GetElement(self.m_root,"txtAthShopCost1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root,"txtAthShopCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root, "imgStarUpCost_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root, "imgCostIcon_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root,"txtStarCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtUpCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtPillCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
    GetElement(self.m_root,"txtUpCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
end

function WndFootMarkUpgrade:_adaptLanguage_pt(  )
    local txt1 = GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(100,0))
    txt1:setScale(0.9)

    local txtPro1 = GetElement(self.m_root,"txtPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro1:setRelativePosition(GlobalMethod:ccp(-0.28536,0.854384))
    local txtPro2 = GetElement(self.m_root,"txtPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(-0.124069,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(-0.111663,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.57072,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(-0.111662,0.0942922))

    local txtNextPro1 = GetElement(self.m_root,"txtNextPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro1:setRelativePosition(GlobalMethod:ccp(0.00223307,0.842968))
    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.137965,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.150372,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.845161,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.162779,0.0942922))


    GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))
    GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))

    for i=1,5 do
        local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndFootMarkUpgrade",WZUIFreeTextBox)
        tfbLog:setMaxWidth(1000)
    end
    GetElement(self.m_root,"txtUpgradeLog_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.14,0.878504))

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setFontSize(18)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setFontSize(18)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setFontSize(18)
    txt4:setDimensions(GlobalMethod:CCSize(360))

    GetElement(self.m_root,"txtStrengtenTip1_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtStrengtenTip_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.277032,0.5))
    GetElement(self.m_root,"imgStar11_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.786208,0.5))
    GetElement(self.m_root,"imgStar12_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.919381,0.5))

    GetElement(self.m_root,"txtAthShopCost1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root,"txtAthShopCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root, "imgStarUpCost_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root, "imgCostIcon_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root,"txtStarCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtUpCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtPillCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
    GetElement(self.m_root,"txtUpCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
end

function WndFootMarkUpgrade:_adaptLanguage_vn()
	GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.664805,0.28))
	GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.664805,0.28))
    --GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.173697,0.0828766))
    --GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.212407,0.657215))
    --GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.262035,0.282877))

    --GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.48536,0.0828767))

    GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtTTT_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF):setFontSize(16)

    GetElement(self.m_root,"txtLv1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18522,0.5))
    GetElement(self.m_root,"txtLv2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.695308,0.5))

    local txtPro1 = GetElement(self.m_root,"txtPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro1:setRelativePosition(GlobalMethod:ccp(-0.173697,0.854384))
    local txtPro2 = GetElement(self.m_root,"txtPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(-0.0124069,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(-0.186104,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(-0.0248139,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(0.210918,0.0942922))

    local txtNextPro1 = GetElement(self.m_root,"txtNextPro1_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro1:setRelativePosition(GlobalMethod:ccp(0.113151,0.842968))
    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.262035,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.100744,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.249628,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.497767,0.0942922))

    GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.277032,0.5))
    GetElement(self.m_root,"imgStar11_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.786208,0.5))
    GetElement(self.m_root,"imgStar12_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.919381,0.5))

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(360))

    GetElement(self.m_root,"labFireCnt_WndFootMarkUpgrade",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.64,0.5))

    for i=1,5 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndFootMarkUpgrade",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1000)
    end
end

function WndFootMarkUpgrade:_adaptLanguage_th()
    GetElement(self.m_root,"txtUpgradeLog_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.878504))

    GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.284476,0.5))
    GetElement(self.m_root,"imgStar11_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.414894,0.5))
    GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.793652,0.5))
    GetElement(self.m_root,"imgStar12_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.926825,0.5))
    
    GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.9)

    GetElement(self.m_root, "labFireCnt_WndFootMarkUpgrade", WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.59,0.5))

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(360))
end

function WndFootMarkUpgrade:_adaptLanguage_tr()
    GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.648276,0.28))

    local txtUp5 = GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF)
    txtUp5:setScale(0.8)
    txtUp5:setDimensions(GlobalMethod:CCSize(126,0))

    GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.660683,0.28))

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setScale(0.8)
    txt1:setDimensions(GlobalMethod:CCSize(450))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setScale(0.8)
    txt2:setDimensions(GlobalMethod:CCSize(450))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setScale(0.8)
    txt3:setDimensions(GlobalMethod:CCSize(450))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setScale(0.8)
    txt4:setDimensions(GlobalMethod:CCSize(450))

    GetElement(self.m_root,"txtLv1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.5))
    GetElement(self.m_root,"txtLv2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82434,0.5))

    GetElement(self.m_root,"txtPro1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.854384))
    GetElement(self.m_root,"txtPro2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.662923))
    GetElement(self.m_root,"txtPro3_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.474338))
    GetElement(self.m_root,"txtPro4_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.288585))
    GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.0942922))
    GetElement(self.m_root,"txtNextPro1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.842968))
    GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.66863))
    GetElement(self.m_root,"txtNextPro3_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.485753))
    GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.282877))
    GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.0942922))

    local txtStrengtenTip1 = GetElement(self.m_root,"txtStrengtenTip1_WndFootMarkUpgrade",WZUILabelTTF)
    txtStrengtenTip1:setScale(0.65)
    txtStrengtenTip1:setDimensions(GlobalMethod:CCSize(440))
    local txtStrengtenTip = GetElement(self.m_root,"txtStrengtenTip_WndFootMarkUpgrade",WZUILabelTTF)
    txtStrengtenTip:setScale(0.65)
    txtStrengtenTip:setDimensions(GlobalMethod:CCSize(440))

    GetElement(self.m_root,"txtUpgradeLog_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.878504))
    for i=1,6 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndFootMarkUpgrade",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1200)
    end
    GetElement(self.m_root,"txtAthShopCost1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root,"txtAthShopCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.24,0.72))
    GetElement(self.m_root, "imgStarUpCost_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root, "imgCostIcon_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root,"txtStarCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtUpCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtPillCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
    GetElement(self.m_root,"txtUpCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
end

function WndFootMarkUpgrade:_adaptLanguage_es(  )
    local txtUp4 = GetElement(self.m_root,"txtUp4_WndFootMarkUpgrade",WZUILabelTTF)
    txtUp4:setDimensions(GlobalMethod:CCSize(140,0))
    txtUp4:setScale(0.7)
    local txtUp5 = GetElement(self.m_root,"txtUp5_WndFootMarkUpgrade",WZUILabelTTF)
    txtUp5:setDimensions(GlobalMethod:CCSize(140,0))
    txtUp5:setScale(0.7)

    local txtPro2 = GetElement(self.m_root,"txtPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(0.1,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(0.2,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.5,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(0.1,0.0942922))

    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.3,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.5,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.68,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndFootMarkUpgrade",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.3,0.0942922))


    GetElement(self.m_root,"txtStarSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))
    GetElement(self.m_root,"txtLvSuccess_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))

    for i=1,6 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndFootMarkUpgrade",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1200)
    end

    local txt1 = GetElement(self.m_root,"txt1_WndFootMarkUpgrade",WZUILabelTTF)
    txt1:setFontSize(18)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndFootMarkUpgrade",WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndFootMarkUpgrade",WZUILabelTTF)
    txt3:setFontSize(18)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndFootMarkUpgrade",WZUILabelTTF)
    txt4:setFontSize(18)

    GetElement(self.m_root,"txtStrengtenTip1_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtStrengtenTip_WndFootMarkUpgrade",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"txtAthShopCost1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.72))
    GetElement(self.m_root,"txtAthShopCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.72))
    GetElement(self.m_root, "imgStarUpCost_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root, "imgCostIcon_WndFootMarkUpgrade", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.38,0.72))
    GetElement(self.m_root,"txtStarCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtUpCost_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.44,0.72))
    GetElement(self.m_root,"txtPillCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))
    GetElement(self.m_root,"txtUpCnt_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.635,0.72))

    GetElement(self.m_root,"txtStar1_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.289439,0.5))
    GetElement(self.m_root,"imgStar11_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.419857,0.5))
    GetElement(self.m_root,"txtStar2_WndFootMarkUpgrade",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.801096,0.5))
    GetElement(self.m_root,"imgStar12_WndFootMarkUpgrade",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.929307,0.5))

    local txtUpgradelog = GetElement(self.m_root,"txtUpgradeLog_WndFootMarkUpgrade",WZUILabelTTF)
    txtUpgradelog:setRelativePosition(GlobalMethod:ccp(0.2,0.878504))
end
-------------------------------------私有方法模块End----------------------------------------
