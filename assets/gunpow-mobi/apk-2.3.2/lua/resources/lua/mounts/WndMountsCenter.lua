--WndMountsCenter.lua
--@brief	WndMountsCenter的UI模块
--@date		2015-12-5
--@author	binshao
--@note		坐骑模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMountsCenter:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)
    
    -- 注册动画回调
    local aniLv = GetElement(self.m_root,"armUpgrade_WndMountsCenter",WZArmature)
    aniLv:setAnimationFinishLuaFunction("armUpdateFinish")
    local aniStar = GetElement(self.m_root,"armAddStar_WndMountsCenter",WZArmature)
    aniStar:setAnimationFinishLuaFunction("armAddStarFinish")

    local conLog = GetElement(self.m_root,"conLog_WndMountsCenter",WZUIContainer)
    conLog:setVisible(false)
	 --语言适配函数
	AdaptLanguage(self)


    --新手定推礼包入口
    local conForMount = GetElement(self.m_root, "conForMount_WndMountsCenter", WZUIContainer)
    CreateLimitPackage(28, conForMount, GlobalMethod:ccp(0.1, 0.93))

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMountsCenter:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 20 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("WndMountsCenter:onEnter2")
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMountsCenter:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief	打开加载动画
function WndMountsCenter:onEnterTransitionDidFinish(element)
    -- WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
    self:actionCallback()
end

--更新商品购买后的界面显示
function WndMountsCenter:updatePlayerItemData()
    self:updatePillCnt()
end

function WndMountsCenter:actionCallback()
    self:_initUI()
end

-- 创建加载框
function WndMountsCenter:createLoading()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoading)
        WZLog("--------------create loading-----------------~",self.loadingId)
    end
end

-- 关闭加载框
function WndMountsCenter:closeLoading()
    WZLog("--------------close loading-----------------",self.loadingId)
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
    self.isClick = true
end

function WndMountsCenter:onTouchBegin()
    if self.logTime == 0 then
        local conLog = GetElement(self.m_root,"conLog_WndMountsCenter",WZUIContainer)
        conLog:setVisible(false)
    end
end

-- 更新坐骑UI信息
function WndMountsCenter:updateMountsUI(data,isResult)
    WZLog("----------------cur update result--------------",isResult)
    if not self.m_root then return end
    -- 先更新本地的数据
    self.m_tMounts =  data
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

function WndMountsCenter:onReturnActionCallback()
    WindowManager:removeWindow(self.m_root, self,true)
end

-- 关闭坐骑信息界面
function WndMountsCenter:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    -- WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
    WndMountsCenter.m_root:removeFromParentAndCleanup(true)
    if WndMounts and WndMounts.showFirstBGUI and WndMounts.m_root then
        WndMounts:showFirstBGUI(true)
    end
end

-- 更新进阶丹数量
function WndMountsCenter:updatePillCnt()
    local myPill = CacheCenter:getPlayerItemCountById(119)
    local txtCnt =  GetElement(self.m_root,"txtPillCnt_WndMountsCenter",WZUILabelTTF)
    txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT,myPill))
end

-- 进阶坐骑回调
function WndMountsCenter:onAddStar()
    WZLog("--------------------player want to addStar--------------",self.isClick)
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大进阶等级，无需进阶
    if self.m_tMounts.advancedLevel >= self.maxStarLevel then
        MsgBoxManager:showTipBox(LocalStrings.MOUNTS_MAX_STAR)
        return
    end

    -- 等级不足
    local nextLevel = self.m_tMounts.advancedLevel + 1
    local nextStartData = GDatatab_mounts_advanced["id_"..nextLevel]
    if self.m_tMounts.upgradeLevel < nextStartData.need_level then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MOUNTS_STAR_NOLEVEL,nextStartData.need_level))
        return
    end

    -- 进阶丹不足
    local myPill = CacheCenter:getPlayerItemCountById(119)
    local costId,costNum = nextStartData.cost[1][1],nextStartData.cost[1][2]
    if myPill < costNum then
        local tItem = GDatatab_item["id_"..tostring(costId)]
        --WndPurchase:showBuyInterface(6, costId,self,self.updatePillCnt)
		WndFastGetItems:show(costId)
        return
    end
    self.isClick = false
    self:createLoading()
    ProtocolProcessorWndMounts:send_MOUNTS_Advanced(self.m_tMounts.id)
end

-- 升级坐骑回调
function WndMountsCenter:onUpgrade()
    WZLog("--------------------player want to upgrade-----------------")
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大等级无需升级
    if self.m_tMounts.upgradeLevel >= self.maxUpLevel then
        MsgBoxManager:showTipBox(LocalStrings.MOUNTS_MAX_UPGRADE)
        return
    end

    local upData
    for k,v in pairs(GDatatab_mounts_upgrade) do
        if v.level == self.m_tMounts.upgradeLevel then  upData = v end
    end
    local needCost = upData.cost[1][2]
    if JudgeMoneyIsEnough(2,needCost,nil,nil,70) then
        self.isClick = false
        self:createLoading()
        ProtocolProcessorWndMounts:send_MOUNTS_Upgrade(self.m_tMounts.id,1)
    end

    TeachGroup1:endTeachStep({19,7})
end

-- 升级坐骑回调
function WndMountsCenter:onUpgrade5()
    WZLog("--------------------player want to upgrade-----------------")
    if not self.isClick then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 最大等级无需升级
    if self.m_tMounts.upgradeLevel >= self.maxUpLevel then
        MsgBoxManager:showTipBox(LocalStrings.MOUNTS_MAX_UPGRADE)
        return
    end

    local needCost = 0
    local mLv = self.m_tMounts.upgradeLevel
    for i = mLv, mLv + self.leftLv do
        local data = GDatatab_mounts_upgrade["id_"..i]
        needCost = needCost + data.cost[1][2]
    end
    WZLog("--------------costCnt-------------!",needCost,self.leftLv)
    if JudgeMoneyIsEnough(2,needCost,nil,nil,70) then
        self.isClick = false
        self:createLoading()
        ProtocolProcessorWndMounts:send_MOUNTS_Upgrade(self.m_tMounts.id,self.leftLv)
    end
end
---------------------------------------私有方法模块End----------------------------------------

-- 坐骑属性转换，按照攻击，防御，血量，暴击，防爆数组排序
function WndMountsCenter:_changeProperty(property)
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
function WndMountsCenter:armAddStarFinish()
    WZLog("-----------------star ani end--------------")
    local ani = GetElement(self.m_root,"armAddStar_WndMountsCenter",WZArmature)
    ani:setVisible(false)
    self.isClick = true
--    local imgPath = self.isResult and "ui/common/common_icon_jjz.png" or "ui/common/common_icon_jjsb.png"
--    PopupResult(imgPath)
end

-- 升级动画播放完毕
function WndMountsCenter:armUpdateFinish()
    WZLog("-----------------up ani end--------------")
    local ani = GetElement(self.m_root,"armUpgrade_WndMountsCenter",WZArmature)
    ani:setVisible(false)
    self.isClick = true
--    local imgPath = self.isResult and "ui/common/common_icon_sjcg.png" or "ui/common/common_icon_sjsb.png"
--    PopupResult(imgPath)
end

-- 播放动画
function WndMountsCenter:_playAddStarAndUpdateAni(isResult)
    local aniUp = GetElement(self.m_root,"armUpgrade_WndMountsCenter",WZArmature)
    local aniStar = GetElement(self.m_root,"armAddStar_WndMountsCenter",WZArmature)
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
        local imgPath = isResult and "ui/common/common_icon_jjz.png" or "ui/common/common_icon_jjsb.png"
        PopupResult(imgPath)
        SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
    end
end

-- -- flag = 1 表示升级， 2表示进阶
-- function WndMountsCenter:showWndUI(data,flag)
--     local wnd = WndMountsCenter:createElement()
--     self.m_tMounts =  data
--     self.flag = flag
--     WindowManager:addWindow(wnd, WndMountsCenter,true,nil,nil)
--     self:initStarAndUpMaxLevel()
-- end

-- flag = 1 表示升级， 2表示进阶
function WndMountsCenter:showWndUIAddCon(data,flag,con)
    local wnd = WndMountsCenter:createElement()
    self.m_tMounts = data
    self.flag = flag
    self:initStarAndUpMaxLevel()
    if con then
        con:addChild(wnd)
    end
end

function WndMountsCenter:onShowAttribute(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    WndMounts:showAttributeTips(element,self.m_root,3)
end
------------------------------------------------------------------------------------------------------------------------

function WndMountsCenter:_initUpLeftLv()
    local pLevel = CacheCenter:getPlayerInfo().level
    local mLevel = self.m_tMounts.upgradeLevel
	if self.m_tMounts.basicInfo.quality == 4 and CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion ~= nil then
		pLevel = pLevel + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
	end
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
function WndMountsCenter:_initUI()
    self:_initStaticText()
    -- 标题
    local title = GetElement(self.m_root,"txtTitle_WndMountsCenter",WZUILabelTTF)
    -- 显示升级或者进阶
    local conLv =  GetElement(self.m_root,"conUp_WndMountsCenter",WZUIContainer)
    local conStar =  GetElement(self.m_root,"conStar_WndMountsCenter",WZUIContainer)
    if self.flag == 1 then
        title:setText(LocalStrings.MOUNTS_TITLE_UPGRAGE)
        conLv:setVisible(true)
        conStar:setVisible(false)
        self:_initUpLvUI()
    else
        title:setText(LocalStrings.MOUNTS_TITLE_STAR)
        conLv:setVisible(false)
        conStar:setVisible(true)
        self:_initAddStarUI()
    end
    self:_initMountInfo(true,true,true)
end

-- 初始化静态文本
function WndMountsCenter:_initStaticText()
    local txtFight = GetElement(self.m_root,"txtFight_WndMountsCenter",WZUILabelTTF)
    if ProjConfig.LANGUAGE == "vn" then
        txtFight:setScale(0.7)
    end
    CCNodePropertySetter:setValue(txtFight, "skewX", 10)
end

-- 根据当前的坐骑等级初始化升级UI
-- state= 1可以升级  2表示达到人物等级上限  3表示坐骑已经最高等级
function WndMountsCenter:_initUpLvUI()
    local state = 1
    local pLevel = CacheCenter:getPlayerInfo().level
    if self.m_tMounts.basicInfo.quality == 4 then
        pLevel = pLevel + tonumber(CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion)
    end
    if self.m_tMounts.upgradeLevel >= self.maxUpLevel then
        state = 3
    elseif self.m_tMounts.upgradeLevel >= pLevel then
        state = 2
    end
    for i = 1, 3 do
        local con = GetElement(self.m_root,"conUp"..i.."_WndMountsCenter",WZUIContainer)
        con:setVisible(i == state)
    end
    if state ~= 1 then
        local conRightPro =  GetElement(self.m_root,"conRightPro_WndMountsCenter",WZUIContainer)
        conRightPro:setVisible(false)
        local conMaxLv =  GetElement(self.m_root,"conMaxLv_WndMountsCenter",WZUIContainer)
        conMaxLv:setVisible(false)
    end
    self:_initLvPro(state)
    self:_initMountInfo(false,true,false)

    -- 初始化按键显示
    self:_initUpLeftLv()
    local leftCnt =  GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    leftCnt:setText(string.format(LocalStrings.MOUNT_UP_FIVE,self.leftLv))

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:_getNewMountAni two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 20 then
        TeachGroup1:endTeachStep({19,6})
        TeachGroup1:startGroup({19,7,self.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
    self:_updateUpLevelLuckyValue()
end

-- 根据当前的坐骑星级初始化进阶UI
function WndMountsCenter:_initAddStarUI()
    local state = 1
    local nextStarLv = self.m_tMounts.advancedLevel + 1
    local nextStartData = GDatatab_mounts_advanced["id_"..nextStarLv]
    if self.m_tMounts.advancedLevel >= self.maxStarLevel then
        state = 2
    elseif self.m_tMounts.upgradeLevel < nextStartData.need_level then
        state = 1
    end
    for i = 1, 2 do
        local con = GetElement(self.m_root,"conStar"..i.."_WndMountsCenter",WZUIContainer)
        con:setVisible(i == state)
    end
    if state ~= 1 then
        local conRightPro =  GetElement(self.m_root,"conRightPro_WndMountsCenter",WZUIContainer)
        conRightPro:setVisible(false)
        local conMaxStar =  GetElement(self.m_root,"conMaxStar_WndMountsCenter",WZUIContainer)
        conMaxStar:setVisible(false)
    end
    self:_initStarPro(state)
    self:_initMountInfo(false,false,true)
end

-- 更新坐骑基本信息， 优化参数： isCreateMount是否需要创建宠物形象，isLv是否需要更新等级，isStar是否需要更新星级
function WndMountsCenter:_initMountInfo(isCreateMount,isLv,isStar)
    -- 名字和等级
    local data = self.m_tMounts

    -- 优化： 只有升级才更新
    if isLv then
        -- local txtName = GetElement(self.m_root,"txtMountName_WndMountsCenter",WZUILabelTTF)
        -- local txtLv = GetElement(self.m_root,"txtMountLv_WndMountsCenter",WZUILabelTTF)
        -- txtName:setText(data.basicInfo.name)
        -- txtLv:setText("Lv"..data.upgradeLevel.."/"..self.maxUpLevel)
        -- txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
        -- txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])

        local txtColor = g_sFtxtQualityColor
        local color = txtColor[data.basicInfo.quality]
        local s1 = data.basicInfo.name .. " Lv"..data.upgradeLevel.."/"..self.maxUpLevel
        local s2 = data.isPlay and "("..LocalStrings.PETATWAR..")" or "("..LocalStrings.PETREST..")"
        local strName = string.format([[<T C=%s S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T><T C="255,89,74" S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T>]],color, s1, s2)
        local ftbMountName = GetElement(self.m_root,"ftbMountName_WndMounts",WZUIFreeTextBox)
        ftbMountName:setShowText(strName)
    end

    -- 优化：只有进阶才更新
    if isStar then
        -- 星级
        local starCnt = data.advancedLevel
        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_09.png","ui/common/common_icon_xingxing2_h.png" }
        for i =1, 20 do
            local starIdx = i
            local index = starCnt >= i and 1 or 2
            if i >= 11 and i <= 20 and index == 1 then
                starIdx = starIdx - 10
                index = 3
            end
            if i >= 11 and i <= 20 and index == 2 then
            else
                local star = GetElement(self.m_root,"imgStar"..starIdx.."_WndMounts",WZUIImage)
                star:setFile(imgPath[index])
            end
        end
    end

    -- 优化：绘制坐骑，只绘制一次
    if isCreateMount then self:_createRoleAndMount(data) end

    -- 初始化战斗力
    self:_initMountFighting()
end

-- 初始化升级属性
function WndMountsCenter:_initLvPro(state)
    -- 基础数据
    local baseData = GDatatab_item["id_"..self.m_tMounts.basicInfo.id]

    -- 当前星级的数据
    local starData
    for k,v in pairs(GDatatab_mounts_advanced) do
        if v.level == self.m_tMounts.advancedLevel then starData = v end
    end

    -- 上一级和当前等级的升级属性
    local curUpData,nextUpData
    for k,v in pairs(GDatatab_mounts_upgrade) do
        if v.level == self.m_tMounts.upgradeLevel  then  curUpData = v end
        if v.level == self.m_tMounts.upgradeLevel+1 then  nextUpData = v end
    end

    -- 属性
    local mountData = {self.m_tMounts.descProperty.hp,self.m_tMounts.descProperty.attack,self.m_tMounts.descProperty.defend,
        self.m_tMounts.descProperty.crit, self.m_tMounts.descProperty.reduceCrit }
    local basePro = self:_changeProperty(baseData.property)
    local nextUpPro
    if nextUpData then nextUpPro = self:_changeProperty(nextUpData.property) end
    local starRate = starData and starData.property_rate or 0
    for i = 1, 5 do
        -- 升级前属性
        local txtP = GetElement(self.m_root,"txtPro"..i.."_WndMountsCenter",WZUILabelTTF)
        txtP:setText(mountData[i])

        -- 升级后属性
        local add =  GetElement(self.m_root,"txtNextPro"..i.."_WndMountsCenter",WZUILabelTTF)
        if nextUpPro then
            local EndPro =   math.ceil((basePro[i]+nextUpPro[i])*(1+starRate/10000))
            add:setText(EndPro)
        end
    end

    -- 等级显示
    local txtLv1 = GetElement(self.m_root,"txtLv1_WndMountsCenter",WZUILabelTTF)
    txtLv1:setText(self.m_tMounts.upgradeLevel)
    if state == 1 then
        -- 下一个等级
        local txtLv2 = GetElement(self.m_root,"txtLv2_WndMountsCenter",WZUILabelTTF)
        txtLv2:setText(self.m_tMounts.upgradeLevel+1)

        -- 成功率
        local txtSuccess = GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF)
        txtSuccess:setText(math.floor(curUpData.probability*100/10000).."%")

        -- 消耗金币
        local txtCost =  GetElement(self.m_root,"txtUpCost_WndMountsCenter",WZUILabelTTF)
        txtCost:setText(curUpData.cost[1][2])
    end
end

-- 初始化进阶属性
function WndMountsCenter:_initStarPro(state)
    -- 基础数据
    local baseData = GDatatab_item["id_"..self.m_tMounts.basicInfo.id]
    local baseData = GDatatab_item["id_"..self.m_tMounts.basicInfo.id]
    
    -- 当前进阶数据和下次进阶数据
    local nextStarData
    for k,v in pairs(GDatatab_mounts_advanced) do
        if v.level == self.m_tMounts.advancedLevel+1 then nextStarData = v end
    end

    -- 升级数据
    local upData
    for k,v in pairs(GDatatab_mounts_upgrade) do
        if v.level == self.m_tMounts.upgradeLevel then  upData = v end
    end

    -- 属性
    local data = {self.m_tMounts.descProperty.hp,self.m_tMounts.descProperty.attack,self.m_tMounts.descProperty.defend,
        self.m_tMounts.descProperty.crit,self.m_tMounts.descProperty.reduceCrit }
    local basePro = self:_changeProperty(baseData.property)
    local upPro = self:_changeProperty(upData.property)
   
    local nextRate = nextStarData and nextStarData.property_rate or 0
    for i = 1, 5 do
        -- 进阶前属性
        local txtP = GetElement(self.m_root,"txtPro"..i.."_WndMountsCenter",WZUILabelTTF)
        txtP:setText(data[i])

        -- 进阶后属性
        local add = GetElement(self.m_root,"txtNextPro"..i.."_WndMountsCenter",WZUILabelTTF)
        if nextStarData then
            local EndPro = math.ceil((basePro[i]+upPro[i])*(1+nextRate/10000))
            add:setText(EndPro)
        end
    end

    -- 当前星级显示
   local txtLv1 = GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF)
   txtLv1:setText(self.m_tMounts.advancedLevel)

    -- local text = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">%d</T><I Z="1">ui/common/common_icon_xingxing2.png</I>]]
    --local text2 = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">%d</T><I Z="1">ui/common/common_icon_xingxing2.png</I>]]
    -- local txtLv1 = GetElement(self.m_root,"ftbStar1_WndMountsCenter",WZUIFreeTextBox)
    -- txtLv1:setShowText(string.format(text,LocalStrings.MOUNT_Star1,self.m_tMounts.advancedLevel))
    if state == 1 then
        -- 下一个星级显示
       local txtLv2 = GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF)
       txtLv2:setText(self.m_tMounts.advancedLevel+1)

        -- local txtLv2 = GetElement(self.m_root,"ftbStar2_WndMountsCenter",WZUIFreeTextBox)
        local nextLv= self.m_tMounts.advancedLevel+1
        -- txtLv2:setShowText(string.format(text,LocalStrings.MOUNT_Star1,nextLv))

        -- 成功率
        local per = 100*(nextStarData.probability/10000)
        WZLog("-------------------per-----------------------",per)
        local txtSuccess =  GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF)
        txtSuccess:setText(per.."%")

        -- 花费进阶丹数量
        local txtCost =  GetElement(self.m_root,"txtStarCost_WndMountsCenter",WZUILabelTTF)
        WZLog("------------------852-------------",nextStarData.cost[1][2])
        txtCost:setText(nextStarData.cost[1][2])

        -- 拥有进阶丹数量
        local myPill = CacheCenter:getPlayerItemCountById(119)
        local txtCnt =  GetElement(self.m_root,"txtPillCnt_WndMountsCenter",WZUILabelTTF)
        txtCnt:setText(string.format(LocalStrings.MOUNT_PILL_CNT,myPill))
    end
    --幸运值
    self:_updateLuckyValue()
end

-- 创建角色和坐骑动画
function WndMountsCenter:_createRoleAndMount(data)
    local conAni = GetElement(self.m_root,"conMountRole_WndMountsCenter",WZUIContainer)
    if conAni:getChildByTag(99) then conAni:removeChildByTag(99,true) end

    local equipList = CacheCenter:getDecorationList()
    local equip = {}
    for k, v in pairs(equipList) do
        if  v.maintype == 5 and v.isUse then table.insert(equip, v.id)  end
    end
    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equip, "wait",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    ani:setMount(data.basicInfo.animation_index_code)
    local node = ani:getAnimNode()
    node:setScale(0.75)
    conAni:addChild(node,0,99)
end

-- 初始化坐骑战斗力
function WndMountsCenter:_initMountFighting()
    local curMountFight = self:_getFighting(self.m_tMounts.property)
    local labFight = GetElement(self.m_root,"labFireCnt_WndMountsCenter",WZUILabelAtlasFont)
    labFight:setText(curMountFight)
end

-- 计算坐骑的战斗力
function WndMountsCenter:_getFighting(data)
    local rate = {1, nil, 4.8, 6, 8, nil, 8,nil, 9.6, 9.6, 9.6, 10, 10, nil,nil,nil,nil,nil,12,12}
    local fight = 0
    for k,v in pairs(data) do
        local index = tonumber(k)
        if rate[index] then
            fight = fight + rate[index]*v
            WZLog("-------------info-----------",index,v,rate[index])
        end
    end
    fight = math.ceil(fight*0.75)
    return fight
end

-- 更新升级日志
function WndMountsCenter:updateUpLog(info)
    local conLog = GetElement(self.m_root,"conLog_WndMountsCenter",WZUIContainer)
    conLog:setVisible(true)
    conLog:setScale(0)

    local disTime = 0.3
    -- 设置日志
    local upCnt = #info.log
    for i = 1, 5 do
        local ftb = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
        if i <= upCnt then
            local data = info.log[i]
            local startLv = data.level - 1
            local endLv = data.level
            WZLog("----------curInfo-----------",i,startLv,endLv,tonumber(data.cost),data.rate.."%")
            if tonumber(data.result) == 1 then
                ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG2,i,startLv,endLv,tonumber(data.cost),data.rate.."%"))
            else
                startLv = data.level
                endLv = data.level + 1
                ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG3,i,startLv,endLv,tonumber(data.cost),data.rate.."%"))
            end
            ftb:setScale(0)
            ftb:setVisible(true)
            local act1 = CCDelayTime:create(0.1+disTime*i)
            local act2
            if ProjConfig.LANGUAGE == "ug" then
                act2 = CCScaleTo:create(0, 0.5)
            else
                act2 = CCScaleTo:create(0, 1)
            end
            local act = CCSequence:createWithTwoActions(act1,act2)
            ftb:runAction(act)
        else
            ftb:setVisible(false)
        end
    end

    -- 总消耗
    local ftb = GetElement(self.m_root,"tfbLog6_WndMountsCenter",WZUIFreeTextBox)
    ftb:setShowText(string.format(LocalStrings.MOUNT_UP_LOG4,upCnt,info.uplevel,info.cost[1].costNum))
    ftb:setScale(0)
    local act1 = CCDelayTime:create(0.1+disTime*(upCnt+1))
    local act2
    if ProjConfig.LANGUAGE == "ug" then
        act2 = CCScaleTo:create(0, 0.5)
    else
        act2 = CCScaleTo:create(0, 1)
    end
    local act = CCSequence:createWithTwoActions(act1,act2)
    ftb:runAction(act)

    local act1 = CCScaleTo:create(0.1,1)
    conLog:runAction(act1)

    self.logTime = disTime*(upCnt+1)+0.1
    conLog:enableSchedule("updateLogTime",self.logTime)
end

function WndMountsCenter:updateLogTime()
    local conLog = GetElement(self.m_root,"conLog_WndMountsCenter",WZUIContainer)
    conLog:disableSchedule()
    self.logTime = 0
end

--@brief    更新幸运值进度
function WndMountsCenter:_updateLuckyValue()
    -- body
    if self.m_root == nil then return end

    local prgLucky = GetElement(self.m_root, "prgLucky_WndMountsCenter", WZUIProgress)
    local nTempBlessValue = self.m_tMounts.blessingValue
    
    if prgLucky then
        if nTempBlessValue < 0 then
            nTempBlessValue = 0 
        elseif nTempBlessValue > 100 then
            nTempBlessValue = 100
        end
        prgLucky:setPercentage(nTempBlessValue)
    end

    local txtLuckyValue = GetElement(self.m_root, "txtLuckyValue_WndMountsCenter", WZUILabelTTF)
    if txtLuckyValue then
        txtLuckyValue:setText(LocalStrings.LUCKVALUE .. ":" .. nTempBlessValue .. "%")
    end
end

--@brief    更新升级幸运值进度
function WndMountsCenter:_updateUpLevelLuckyValue()
    -- body
    WZLog("WndMountsCenter:_updateUpLevelLuckyValue")
    if self.m_root == nil then return end

    local prgLucky = GetElement(self.m_root, "prgUpLucky_WndMountsCenter", WZUIProgress)
    local nTempUpBlessValue = self.m_tMounts.upgradeBless
    WZLog("asdfds =",nTempUpBlessValue)
    if prgLucky then
        if nTempUpBlessValue < 0 then
            nTempUpBlessValue = 0 
        elseif nTempUpBlessValue > 100 then
            nTempUpBlessValue = 100
        end
        prgLucky:setPercentage(nTempUpBlessValue)
    end

    local txtLuckyValue = GetElement(self.m_root, "txtUpLuckyValue_WndMountsCenter", WZUILabelTTF)
    if txtLuckyValue then
        txtLuckyValue:setText(LocalStrings.LUCKVALUE .. ":" .. nTempUpBlessValue .. "%")
    end
end

--@brief  点击限时特惠礼包按钮回调
function WndMountsCenter:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end
-------------------------------------语言适配模块Start----------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndMountsCenter:_adaptLanguage_en()
    WZLog("---_adaptLanguage_en---")
    local txtUp5 = GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    txtUp5:setDimensions(GlobalMethod:CCSize(100,0))
    txtUp5:setScale(0.8)

	GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.67,0.28))
	GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.67,0.28))

    GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.878504))

    GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.5))
    GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.820947,0.5))
    GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.921863,0.5))

    local txtPro1 = GetElement(self.m_root,"txtPro1_WndMountsCenter",WZUILabelTTF)
    txtPro1:setRelativePosition(GlobalMethod:ccp(-0.372208,0.854384))
    local txtPro2 = GetElement(self.m_root,"txtPro2_WndMountsCenter",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(-0.223325,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndMountsCenter",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(-0.210918,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndMountsCenter",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.0248139,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(-0.210918,0.0942922))

    local txtNextPro1 = GetElement(self.m_root,"txtNextPro1_WndMountsCenter",WZUILabelTTF)
    txtNextPro1:setRelativePosition(GlobalMethod:ccp(-0.0977667,0.842968))
    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.0511167,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndMountsCenter",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.0635236,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.302035,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.0635236,0.0942922))

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(360))

    local txtStrengtenTip = GetElement(self.m_root,"txtStrengtenTip_WndMountsCenter",WZUILabelTTF)
    txtStrengtenTip:setScale(0.66)
    txtStrengtenTip:setDimensions(GlobalMethod:CCSize(380))

    local txtUpLucky = GetElement(self.m_root,"txtUpLucky_WndMountsCenter",WZUILabelTTF)
    txtUpLucky:setScale(0.7)
    txtUpLucky:setDimensions(GlobalMethod:CCSize(440,0))

    GetElement(self.m_root,"txtLv1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.265,0.5))
    GetElement(self.m_root,"txtLv2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.765,0.5))
end

function WndMountsCenter:_adaptLanguage_pt(  )
    local txt1 = GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(100,0))
    txt1:setScale(0.9)

    local txtPro1 = GetElement(self.m_root,"txtPro1_WndMountsCenter",WZUILabelTTF)
    txtPro1:setRelativePosition(GlobalMethod:ccp(-0.28536,0.854384))
    local txtPro2 = GetElement(self.m_root,"txtPro2_WndMountsCenter",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(-0.124069,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndMountsCenter",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(-0.111663,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndMountsCenter",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.57072,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(-0.111662,0.0942922))

    local txtNextPro1 = GetElement(self.m_root,"txtNextPro1_WndMountsCenter",WZUILabelTTF)
    txtNextPro1:setRelativePosition(GlobalMethod:ccp(0.00223307,0.842968))
    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.137965,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndMountsCenter",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.150372,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.845161,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.162779,0.0942922))


    GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))
    GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))

    for i=1,5 do
       GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox):setScale(0.7)
    end
    GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.14,0.878504))

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setFontSize(18)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setFontSize(18)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setFontSize(18)
    txt4:setDimensions(GlobalMethod:CCSize(360))

    GetElement(self.m_root,"txtStrengtenTip_WndMountsCenter",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.277032,0.5))
    GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.786208,0.5))
    GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.919381,0.5))

    GetElement(self.m_root,"txtUpLucky_WndMountsCenter",WZUILabelTTF):setFontSize(16)
end

function WndMountsCenter:_adaptLanguage_vn()
	GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.664805,0.28))
	GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.664805,0.28))
    GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.173697,0.0828766))
    GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.212407,0.657215))
    GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.262035,0.282877))

    GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.48536,0.0828767))

    GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtTTT_WndMountsCenter",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF):setFontSize(16)

    GetElement(self.m_root,"txtLv1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18522,0.5))
    GetElement(self.m_root,"txtLv2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.72,0.5))

    -- local txtPro1 = GetElement(self.m_root,"txtPro1_WndMountsCenter",WZUILabelTTF)
    -- txtPro1:setRelativePosition(GlobalMethod:ccp(-0.173697,0.854384))
    -- local txtPro2 = GetElement(self.m_root,"txtPro2_WndMountsCenter",WZUILabelTTF)
    -- txtPro2:setRelativePosition(GlobalMethod:ccp(-0.0124069,0.662923))
    -- local txtPro3 = GetElement(self.m_root,"txtPro3_WndMountsCenter",WZUILabelTTF)
    -- txtPro3:setRelativePosition(GlobalMethod:ccp(-0.186104,0.474338))
    -- local txtPro4 = GetElement(self.m_root,"txtPro4_WndMountsCenter",WZUILabelTTF)
    -- txtPro4:setRelativePosition(GlobalMethod:ccp(-0.0248139,0.288585))
    GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.210918,0.13))

    GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    -- local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndMountsCenter",WZUILabelTTF)
    -- txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.100744,0.485753))
    GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.287))
    GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.13))

    GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.277032,0.5))
    GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.412412,0.5))
    GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
    GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.919381,0.5))

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    txt1:setRelativePosition(GlobalMethod:ccp(0.5,0.27))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setDimensions(GlobalMethod:CCSize(360))
    txt4:setRelativePosition(GlobalMethod:ccp(0.5,0.27))

    for i=1,6 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1200)
    end
end

function WndMountsCenter:_adaptLanguage_th()
    GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.878504))

    GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.284476,0.5))
    GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.414894,0.5))
    GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.793652,0.5))
    GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.926825,0.5))
    for i=1,6 do
        local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
        tfbLog:setMaxWidth(1200)
    end

    for i=1,6 do
        local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
        tfbLog:setMaxWidth(1200)
    end
end

function WndMountsCenter:_adaptLanguage_tr()
    GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.648276,0.28))
    GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.660683,0.28))

    local txtUp5 = GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    txtUp5:setScale(0.8)
    txtUp5:setDimensions(GlobalMethod:CCSize(126,0))


    -- GetElement(self.m_root,"txtLogTitle_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.205387,0.878504))

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setScale(0.8)
    txt1:setDimensions(GlobalMethod:CCSize(450))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setScale(0.8)
    txt2:setDimensions(GlobalMethod:CCSize(450))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setScale(0.8)
    txt3:setDimensions(GlobalMethod:CCSize(450))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setScale(0.8)
    txt4:setDimensions(GlobalMethod:CCSize(450))

    GetElement(self.m_root,"txtLv1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.5))
    GetElement(self.m_root,"txtLv2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82434,0.5))

    GetElement(self.m_root,"txtPro1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.854384))
    GetElement(self.m_root,"txtPro2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.662923))
    GetElement(self.m_root,"txtPro3_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.474338))
    GetElement(self.m_root,"txtPro4_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.288585))
    GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311771,0.0942922))
    GetElement(self.m_root,"txtNextPro1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.842968))
    GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.66863))
    GetElement(self.m_root,"txtNextPro3_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.485753))
    GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.282877))
    GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.597022,0.0942922))

    local txtUpgradeLog = GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF)
    txtUpgradeLog:setRelativePosition(GlobalMethod:ccp(0.18,0.878504))

    local txtStrengtenTip = GetElement(self.m_root,"txtStrengtenTip_WndMountsCenter",WZUILabelTTF)
    txtStrengtenTip:setScale(0.66)
    txtStrengtenTip:setDimensions(GlobalMethod:CCSize(500))

    local txtUpLucky = GetElement(self.m_root,"txtUpLucky_WndMountsCenter",WZUILabelTTF)
    txtUpLucky:setScale(0.7)
    txtUpLucky:setDimensions(GlobalMethod:CCSize(440,0))
end

function WndMountsCenter:_adaptLanguage_es(  )
    local txtUp4 = GetElement(self.m_root,"txtUp4_WndMountsCenter",WZUILabelTTF)
    txtUp4:setDimensions(GlobalMethod:CCSize(140,0))
    txtUp4:setScale(0.7)
    local txtUp5 = GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    txtUp5:setDimensions(GlobalMethod:CCSize(140,0))
    txtUp5:setScale(0.7)

    local txtPro2 = GetElement(self.m_root,"txtPro2_WndMountsCenter",WZUILabelTTF)
    txtPro2:setRelativePosition(GlobalMethod:ccp(0.1,0.662923))
    local txtPro3 = GetElement(self.m_root,"txtPro3_WndMountsCenter",WZUILabelTTF)
    txtPro3:setRelativePosition(GlobalMethod:ccp(0.2,0.474338))
    local txtPro4 = GetElement(self.m_root,"txtPro4_WndMountsCenter",WZUILabelTTF)
    txtPro4:setRelativePosition(GlobalMethod:ccp(0.5,0.288585))
    local txtPro5 = GetElement(self.m_root,"txtPro5_WndMountsCenter",WZUILabelTTF)
    txtPro5:setRelativePosition(GlobalMethod:ccp(0.1,0.0942922))

    local txtNextPro2 = GetElement(self.m_root,"txtNextPro2_WndMountsCenter",WZUILabelTTF)
    txtNextPro2:setRelativePosition(GlobalMethod:ccp(0.3,0.66863))
    local txtNextPro3 = GetElement(self.m_root,"txtNextPro3_WndMountsCenter",WZUILabelTTF)
    txtNextPro3:setRelativePosition(GlobalMethod:ccp(0.5,0.485753))
    local txtNextPro4 = GetElement(self.m_root,"txtNextPro4_WndMountsCenter",WZUILabelTTF)
    txtNextPro4:setRelativePosition(GlobalMethod:ccp(0.68,0.282877))
    local txtNextPro5 = GetElement(self.m_root,"txtNextPro5_WndMountsCenter",WZUILabelTTF)
    txtNextPro5:setRelativePosition(GlobalMethod:ccp(0.3,0.0942922))


    GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))
    GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.28))

    for i=1,6 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1200)
    end

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setFontSize(18)
    txt1:setDimensions(GlobalMethod:CCSize(360))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setFontSize(18)
    txt2:setDimensions(GlobalMethod:CCSize(360))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setFontSize(18)
    txt3:setDimensions(GlobalMethod:CCSize(360))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setFontSize(18)

    GetElement(self.m_root,"txtStrengtenTip_WndMountsCenter",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"txtAthShopCostUp_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.72))
    GetElement(self.m_root,"txtAthShopCost_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.72))

    GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.289439,0.5))
    GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.419857,0.5))
    GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.801096,0.5))
    GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.929307,0.5))
    
    local txtUpgradelog = GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF)
    txtUpgradelog:setRelativePosition(GlobalMethod:ccp(0.2,0.878504))

    local txtUpLucky = GetElement(self.m_root,"txtUpLucky_WndMountsCenter",WZUILabelTTF)
    txtUpLucky:setFontSize(16)
    txtUpLucky:setDimensions(GlobalMethod:CCSize(300,0))
end

function WndMountsCenter:_adaptLanguage_ug(  )
    local txtStarT1 = GetElement(self.m_root,"txtStarT1_WndMountsCenter",WZUILabelTTF)
    txtStarT1:setScale(0.7)
    txtStarT1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtStarT1:setRelativePosition(GlobalMethod:ccp(0.46,0.5))
    local txtStar1 = GetElement(self.m_root,"txtStar1_WndMountsCenter",WZUILabelTTF)
    txtStar1:setScale(0.7)
    txtStar1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtStar1:setRelativePosition(GlobalMethod:ccp(0.16,0.5))
    local imgStar1 = GetElement(self.m_root,"imgStar1_WndMountsCenter",WZUIImage)
    imgStar1:setScale(0.7)
    imgStar1:setRelativePosition(GlobalMethod:ccp(0.08,0.5))
    local txtStarT2 = GetElement(self.m_root,"txtStarT2_WndMountsCenter",WZUILabelTTF)
    txtStarT2:setScale(0.7)
    txtStarT2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtStarT2:setRelativePosition(GlobalMethod:ccp(0.96,0.5))
    local txtStar2 = GetElement(self.m_root,"txtStar2_WndMountsCenter",WZUILabelTTF)
    txtStar2:setScale(0.7)
    txtStar2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtStar2:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
    local imgStar2 = GetElement(self.m_root,"imgStar2_WndMountsCenter",WZUIImage)
    imgStar2:setScale(0.7)
    imgStar2:setRelativePosition(GlobalMethod:ccp(0.58,0.5))

    local txtLvT1 = GetElement(self.m_root,"txtLvT1_WndMountsCenter",WZUILabelTTF)
    txtLvT1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLvT1:setRelativePosition(GlobalMethod:ccp(0.46,0.5))
    local txtLv1 = GetElement(self.m_root,"txtLv1_WndMountsCenter",WZUILabelTTF)
    txtLv1:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLv1:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
    local txtLvT2 = GetElement(self.m_root,"txtLvT2_WndMountsCenter",WZUILabelTTF)
    txtLvT2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLvT2:setRelativePosition(GlobalMethod:ccp(0.96,0.5))
    local txtLv2 = GetElement(self.m_root,"txtLv2_WndMountsCenter",WZUILabelTTF)
    txtLv2:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLv2:setRelativePosition(GlobalMethod:ccp(0.68,0.5))

    for i = 1, 5 do
        local txtProT = GetElement(self.m_root,"txtProT"..i.."_WndMountsCenter",WZUILabelTTF)
        txtProT:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        txtProT:setRelativePosition(GlobalMethod:ccp(1,1.045-i*0.19))
        local txtPro = GetElement(self.m_root,"txtPro"..i.."_WndMountsCenter",WZUILabelTTF)
        txtPro:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        txtPro:setRelativePosition(GlobalMethod:ccp(0.7,1.045-i*0.19))
        local txtNextProT = GetElement(self.m_root,"txtNextProT"..i.."_WndMountsCenter",WZUILabelTTF)
        txtNextProT:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        txtNextProT:setRelativePosition(GlobalMethod:ccp(1,1.045-i*0.19))        
        local txtNextPro = GetElement(self.m_root,"txtNextPro"..i.."_WndMountsCenter",WZUILabelTTF)
        txtNextPro:setAnchorPoint(GlobalMethod:ccp(1,0.5))
        txtNextPro:setRelativePosition(GlobalMethod:ccp(0.7,1.045-i*0.19))
    end
    GetElement(self.m_root,"conProT_WndMountsCenter",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.36,0.5))
    GetElement(self.m_root,"conPro_WndMountsCenter",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.14,0.5))
    GetElement(self.m_root,"conNextProT_WndMountsCenter",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.86,0.5))
    GetElement(self.m_root,"conNextPro_WndMountsCenter",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.64,0.5))

    GetElement(self.m_root,"txtAthShopCostUp_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.72))
    GetElement(self.m_root,"imgAthShopCostUp_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.52,0.72))
    GetElement(self.m_root,"txtUpCost_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.72))
    GetElement(self.m_root,"txtUpCost_WndMountsCenter",WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(1,0.5))
    GetElement(self.m_root,"txtAthShopCost_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.72))
    GetElement(self.m_root,"imgAthShopCost_WndMountsCenter",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.52,0.72))
    GetElement(self.m_root,"txtStarCost_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.72))
    GetElement(self.m_root,"txtStarCost_WndMountsCenter",WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(1,0.5))
    GetElement(self.m_root,"txtPillCnt_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.015,0.72))

    local txtLvSuccessT = GetElement(self.m_root,"txtLvSuccessT_WndMountsCenter",WZUILabelTTF)
    txtLvSuccessT:setScale(0.9)
    txtLvSuccessT:setRelativePosition(GlobalMethod:ccp(0.58,0.28))
    local txtLvSuccess = GetElement(self.m_root,"txtLvSuccess_WndMountsCenter",WZUILabelTTF)
    txtLvSuccess:setScale(0.9)
    txtLvSuccess:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtLvSuccess:setRelativePosition(GlobalMethod:ccp(0.14,0.28))
    local txtStarSuccessT = GetElement(self.m_root,"txtStarSuccessT_WndMountsCenter",WZUILabelTTF)
    txtStarSuccessT:setScale(0.9)
    txtStarSuccessT:setRelativePosition(GlobalMethod:ccp(0.58,0.28))
    local txtStarSuccess = GetElement(self.m_root,"txtStarSuccess_WndMountsCenter",WZUILabelTTF)
    txtStarSuccess:setScale(0.9)
    txtStarSuccess:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtStarSuccess:setRelativePosition(GlobalMethod:ccp(0.14,0.28))

    local txtBtnAdvance = GetElement(self.m_root,"txtBtnAdvance_WndMountsCenter",WZUILabelTTF)
    txtBtnAdvance:setScale(0.7)
    txtBtnAdvance:setDimensions(GlobalMethod:CCSize(180))

    local txt1 = GetElement(self.m_root,"txt1_WndMountsCenter",WZUILabelTTF)
    txt1:setScale(0.65)
    txt1:setDimensions(GlobalMethod:CCSize(600))
    local txt2 = GetElement(self.m_root,"txt2_WndMountsCenter",WZUILabelTTF)
    txt2:setScale(0.65)
    txt2:setDimensions(GlobalMethod:CCSize(600))
    local txt3 = GetElement(self.m_root,"txt3_WndMountsCenter",WZUILabelTTF)
    txt3:setScale(0.65)
    txt3:setDimensions(GlobalMethod:CCSize(600))
    local txt4 = GetElement(self.m_root,"txt4_WndMountsCenter",WZUILabelTTF)
    txt4:setScale(0.65)
    txt4:setDimensions(GlobalMethod:CCSize(600))

    local txtUp4 = GetElement(self.m_root,"txtUp4_WndMountsCenter",WZUILabelTTF)
    txtUp4:setDimensions(GlobalMethod:CCSize(180,0))
    txtUp4:setScale(0.7)
    local txtUp5 = GetElement(self.m_root,"txtUp5_WndMountsCenter",WZUILabelTTF)
    txtUp5:setDimensions(GlobalMethod:CCSize(180,0))
    txtUp5:setScale(0.7)

    local txtStrengtenTip = GetElement(self.m_root,"txtStrengtenTip_WndMountsCenter",WZUILabelTTF)
    txtStrengtenTip:setScale(0.66)
    txtStrengtenTip:setDimensions(GlobalMethod:CCSize(600))
    local txtUpLucky = GetElement(self.m_root,"txtUpLucky_WndMountsCenter",WZUILabelTTF)
    txtUpLucky:setScale(0.66)
    txtUpLucky:setDimensions(GlobalMethod:CCSize(600))

    GetElement(self.m_root,"txtUpgradeLog_WndMountsCenter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.878504))
    for i=1,6 do
       local tfbLog = GetElement(self.m_root,"tfbLog"..i.."_WndMountsCenter",WZUIFreeTextBox)
       tfbLog:setMaxWidth(1100)
       tfbLog:setRelativePosition(GlobalMethod:ccp(0.04,0.82-i*0.12))
    end
end
-------------------------------------语言适配模块End----------------------------------------
