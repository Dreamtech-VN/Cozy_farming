--WndDailyCopySettlement.lua
--@brief	WndDailyCopySettlement的UI模块
--@date		2015-6-19
--@author	binshao
--@note		日常副本结算窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDailyCopySettlement:onEnter(element)
	self.m_root = element
    self.descTime = 0
    WindowManager:getSceneRoot():removeChildByTag(78945, true)

    AdaptLanguage(self)
    if AutoRunBattleConst.AUTO_RUN_BATTLE then
        WindowManager:removeWindow(self.m_root, self, true)
        SceneCopy:showScene(3)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDailyCopySettlement:onExit(element)
	self:_unInit()
end

-- 点击屏幕关闭
function WndDailyCopySettlement:onClickContinue()
    WZLog("--------------onClickContinue------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local pro = GetElement(self.m_root,"proLv_WndDailyCopySettlement", WZUIProgress)
    pro:disableSchedule()

    WindowManager:removeWindow(self.m_root, self, true)
    SceneCopy:showScene(3)
    return
end

function WndDailyCopySettlement:onFail(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("--------------onFail------------------")
    local tag = element:getTag()
    local ui = self.failUiData[tag].Link
    self:onClickContinue()
    DelayCallFunction(function()
        JumpByUIId(ui)
    end, nil, 0)
end

--@brief    战斗成功分享到FaceBook点击事件
function WndDailyCopySettlement:onFBShare( element )
    SetFBShareByPackage(1)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新
function WndDailyCopySettlement:_update()
    self:_createMyPlayer()
    self:_updateUI()
end

-- 创建玩家形象
function WndDailyCopySettlement:_createMyPlayer()
    local conPWin = GetElement(self.m_root, "conPlayer_WndDailyCopySettlement")
    local conPLose = GetElement(self.m_root, "conPlayerFail_WndDailyCopySettlement")
    local conPlayer = self.tData.isWin and conPWin or conPLose
    local aniName = self.tData.isWin and "win" or "failure"
    local aniPlayer = CreateSelfAni()

    local tmpCon = WZUIContainer:create()
    tmpCon:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
    tmpCon:setUseAbsSize(true)
    tmpCon:setAbsContentSize(GlobalMethod:CCSize(150,150))
    tmpCon:addChild(aniPlayer:getAnimNode())

    conPlayer:addChild(tmpCon)
    aniPlayer:play(aniName, true)
end

-- 2s 后播放粒子效果
function WndDailyCopySettlement:OnPlayerParCallBack()
    local parPath = {
        {"ui_jiesuan_fashelihua_01.plist", "ui_jiesuan_fashelihua_02.plist", "ui_jiesuan_fashelihua_03.plist","ui_jiesuan_fashelihua_04.plist" },
        {"ui_jiesuan_lihua_01.plist", "ui_jiesuan_lihua_02.plist", "ui_jiesuan_lihua_03.plist","ui_jiesuan_lihua_04.plist"}
        }
    local con = {"conPar1_WndDailyCopySettlement","conPar2_WndDailyCopySettlement" }
    for i = 1, 2 do
        local con = GetElement(self.m_root, con[i], WZUIContainer)
        for k = 1, 4 do
            local backFire = CCParticleSystemQuad:create("particle/"..parPath[i][k])
            backFire:setAutoRemoveOnFinish(true)
            con:addChild(backFire)
        end
    end
end

-- 动画完成后回调(赢)
function WndDailyCopySettlement:OnAniFinishCallBack()
    if self.tData.isWin then
        local con = GetElement(self.m_root,"conBtnContinue_WndDailyCopySettlement",WZUIContainer)
        con:setVisible(true)
    end
end

-- 动画完成后回调（输）
function WndDailyCopySettlement:OnAniFinishCallBack1()
    if not self.tData.isWin then
        local txtContinue =  GetElement(self.m_root,"txtClickContinue_WndDailyCopySettlement",WZUILabelTTF)
        txtContinue:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
        local con = GetElement(self.m_root,"conBtnContinue_WndDailyCopySettlement",WZUIContainer)
        con:setVisible(true)
    end
end

-- 经验动画,胜利才有
function WndDailyCopySettlement:OnExpAni()
    if self.tData.fightId == 2 and  self.tData.isWin then
        local maxExp =GDatatab_player_upgrade["id_"..self.curLv].exp
        if self.curLv == GetPlayerMaxLevel() and self.curExp >= maxExp then return end
        local expP = GetElement(self.m_root,"proLv_WndDailyCopySettlement", WZUIProgress)
        expP:enableSchedule("_expAni",0.1)
        SoundManager:playEffectSound(SoundDefine.E_S_SETTLEMENT)
    end
end

-- 更新UI
function WndDailyCopySettlement:_updateUI()
    local data = self.tData
    local conWin = GetElement(self.m_root,"conWin_WndDailyCopySettlement",WZUIContainer)
    local conLose = GetElement(self.m_root,"conLose_WndDailyCopySettlement",WZUIContainer)
    local conLoseGo = GetElement(self.m_root,"conLoseGoTo_WndDailyCopySettlement",WZUIContainer)
    if data.isWin then
         SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN)
        -- if WBattleGlobal:getCurrent():getMyHero().m_nBoyOrGirl == 0 then
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_BOY,false,true)
        -- else
        --     SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_WIN_GIRL,false,true)
        -- end
        if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
            or ProjConfig.CHANNEL_ID == 1053 then
            GetElement(self.m_root,"btnFBShare_WndDailyCopySettlement",WZUIButton):setVisible(true)
        end
        conWin:setVisible(true)
        conLose:setVisible(false)
        conLoseGo:setVisible(false)
        self:_updateWinUI()

        GetElement(self.m_root, "spineWin_WndDailyCopySettlement", WZUISpine):play("win",false)
        GetElement(self.m_root,"conSpineWin_WndDailyCopySettlement",WZUIContainer):enableSchedule("_updateSpine")
    else
        SoundManager:playEffectSound(SoundDefine.E_S_BATTLE_LOSE)
        conWin:setVisible(false)
        conLose:setVisible(true)
        conLoseGo:setVisible(true)
        self:_updateLoseUI()
    end
end

--@brief 胜利动画
function WndDailyCopySettlement:_updateSpine(element,dt)
    if  GetElement(self.m_root, "spineWin_WndDailyCopySettlement", WZUISpine):isCurrentAnimationDone() then
        element:disableSchedule()
        GetElement(self.m_root, "spineWin_WndDailyCopySettlement", WZUISpine):play("win_wait",true)
    end
    
end

-- 更新胜利的UI
function WndDailyCopySettlement:_updateWinUI()
    local data = self.tData
    if data.fightId == 1 then
        local con =  GetElement(self.m_root,"conGold_WndDailyCopySettlement",WZUIContainer)
        con:setVisible(true)
        -- 分别对应 伤害值，大金币个数，小金币个数，金币总数
        for i = 1, 4 do
            local txtDesc = GetElement(con,"txtGoldDesc"..i.."_WndDailyCopySettlement",WZUILabelTTF)
            txtDesc:setText(data.fightData[i])
        end
        WZLog("22222233333 = ",Serialize(data.fightData))

        -- boss是否死亡，是否完成
        local imgPath = {"ui/common/common_icon_weida.png","ui/common/common_icon_dacheng.png" }
        local imgFinish = GetElement(self.m_root,"imgFinish_WndDialyCopySettlement",WZUIImage)
        if data.fightData[5] ~= 0 then
            imgFinish:setFile(imgPath[2])
            imgFinish:setVisible(true)
        else
            imgFinish:setFile(imgPath[1])
            imgFinish:setVisible(true)
        end
    elseif data.fightId == 2 then

        local con =  GetElement(self.m_root,"conExp_WndDailyCopySettlement",WZUIContainer)
        con:setVisible(true)
        self:_initExpFrame()

        -- 分别对应击杀小怪，击杀精英怪，击杀boss，获取的经验
        for i = 1, 4 do
            local txtDesc = GetElement(self.m_root,"txtExpDesc"..i.."_WndDailyCopySettlement",WZUILabelTTF)
            txtDesc:setText(data.fightData[i])
        end

        -- 玩家等级
        local txtLv = GetElement(self.m_root,"txtExpLv_WndDailyCopySettlement",WZUILabelTTF)
        txtLv:setText("Lv"..self.curLv)
    elseif  data.fightId == 3 then
        -- 当fightId = 3 时， 胜利：fightData = {击蛋分，出手次数，是否击杀boss(1击杀boss,0没有打死boss)，自己打了多少伤害}
        -- {mapId = 1000, fightId = 1, fightData = {2,5,6,100,0},isWin = false,expInfo = {expLv = 5, exp = 5000}}
        local con =  GetElement(self.m_root,"conPet_WndDailyCopySettlement",WZUIContainer)
        con:setVisible(true)
        local txtAttachCount = GetElement(con,"txtAttachCount_WndDailyCopySettlement",WZUILabelTTF)
        txtAttachCount:setText(LocalStrings.SETTLMENT_DAMAGE .. LocalStrings.PRACTICE_BLOOD .. "：")
        local mapId = self.tData.mapId
        local mapData = GDatatab_daily_map["id_" .. mapId]

        for i=1,3 do
            local txtGoldDesc = GetElement(con,"txtGoldDesc" .. i .. "_WndDailyCopySettlement",WZUILabelTTF)
            if i == 1 then
                txtGoldDesc:setText(data.fightData[4] .. "/" .. (100 - mapData.parameter3))
            elseif i == 2 then
                txtGoldDesc:setText(data.fightData[2] .. "/" .. mapData.parameter5)
            elseif i == 3 then
                txtGoldDesc:setText(data.fightData[1])
            end
        end

        -- boss是否死亡，是否完成
        local imgPath = {"ui/common/common_icon_weida.png","ui/common/common_icon_dacheng.png" }
        local imgFinish = GetElement(con,"imgFinish_WndDialyCopySettlement",WZUIImage)
        if data.fightData[3] ~= 0 then
            imgFinish:setFile(imgPath[2])
            imgFinish:setVisible(true)
        else
            imgFinish:setFile(imgPath[1])
            imgFinish:setVisible(true)
        end
        local rewardC = #data.rewardId
        if rewardC == 1 then
            local rewardId = data.rewardId[1]
            local rewardCount = data.rewardCount[1]
            local imgReward2 = GetElement(con,"imgReward2_WndDailyCopySettlement",WZUIImage)
            local icon = GDatatab_item["id_" .. rewardId].icon
            imgReward2:setFile(icon)
            imgReward2:setVisible(true)

            local txtGoldDesc2  =  GetElement(con,"txtGoldDesc5_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc2:setText(rewardCount)
            txtGoldDesc2:setVisible(true)
        elseif rewardC == 2 then
           
            local rewardId = data.rewardId[1]
            local rewardCount = data.rewardCount[1]
            local imgReward1 = GetElement(con,"imgReward1_WndDailyCopySettlement",WZUIImage)
            local icon = GDatatab_item["id_" .. rewardId].icon
            imgReward1:setFile(icon)
            imgReward1:setVisible(true)

            local txtGoldDesc1  =  GetElement(con,"txtGoldDesc4_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc1:setText(rewardCount)
            txtGoldDesc1:setVisible(true)

            rewardId = data.rewardId[2]
            rewardCount = data.rewardCount[2]
            
            local imgReward3 = GetElement(con,"imgReward3_WndDailyCopySettlement",WZUIImage)
            imgReward3:setVisible(true)
            icon = GDatatab_item["id_" .. rewardId].icon
            imgReward3:setFile(icon)
            local txtGoldDesc3  =  GetElement(con,"txtGoldDesc6_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc3:setText(rewardCount)
            txtGoldDesc3:setVisible(true)

        elseif rewardC == 3 then
            local rewardId = data.rewardId[1]
            local rewardCount = data.rewardCount[1]
            local imgReward1 = GetElement(con,"imgReward1_WndDailyCopySettlement",WZUIImage)
            local icon = GDatatab_item["id_" .. rewardId].icon
            imgReward1:setFile(icon)
            imgReward1:setVisible(true)

            local txtGoldDesc1  =  GetElement(con,"txtGoldDesc4_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc1:setText(rewardCount)
            txtGoldDesc1:setVisible(true)

            rewardId = data.rewardId[2]
            rewardCount = data.rewardCount[2]
            local imgReward2 = GetElement(con,"imgReward2_WndDailyCopySettlement",WZUIImage)
            icon = GDatatab_item["id_" .. rewardId].icon
            imgReward2:setFile(icon)
            imgReward2:setVisible(true)
            local txtGoldDesc2  =  GetElement(con,"txtGoldDesc5_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc2:setText(rewardCount)
            txtGoldDesc2:setVisible(true)

            rewardId = data.rewardId[3]
            rewardCount = data.rewardCount[3]
            local imgReward3 = GetElement(con,"imgReward3_WndDailyCopySettlement",WZUIImage)
            icon = GDatatab_item["id_" .. rewardId].icon
            imgReward3:setFile(icon)
            imgReward3:setVisible(true)
            local txtGoldDesc3  =  GetElement(con,"txtGoldDesc6_WndDailyCopySettlement",WZUILabelTTF)
            txtGoldDesc3:setText(rewardCount)
            txtGoldDesc3:setVisible(true)
        end
    end
end

-- 更新失败UI
function WndDailyCopySettlement:_updateLoseUI()
    local data = self.tData
    local dailyData = GDatatab_daily_map["id_"..data.mapId]
    local txtLose = GetElement(self.m_root,"txtLoseTips_WndDailyCopySettlement",WZUIFreeTextBox)
    local con1 = GetElement(self.m_root,"conFail1_WndDailyCopySettlement",WZUIContainer)
    local con2 = GetElement(self.m_root,"conFail2_WndDailyCopySettlement",WZUIContainer)
    if data.fightId == 1 then
        local str = self.tData.fightData[1].."/"..self.tData.fightData[5]*dailyData.parameter6/100
        txtLose:setShowText(string.format(LocalStrings.DAILY_LOSE_DESC1,str))
        con1:setVisible(true)
    elseif data.fightId == 2 then
        if self.tData.fightData[4] < dailyData.parameter6 then
            con2:setVisible(true)
        else
            local str = self.tData.fightData[4].."/"..dailyData.parameter6
            txtLose:setShowText(string.format(LocalStrings.DAILY_LOSE_DESC2,str))
            con1:setVisible(true)
        end
    elseif data.fightId == 3 then
        con2:setVisible(true)
        con1:setVisible(false)
    end

    self.failUiData = GetFailCopyUi()
    for i =1, #self.failUiData do
        local icon = GetElement(self.m_root, "imgBtnIcon"..i.."_WndDailyCopySettlement", WZUIImage)
        icon:setFile(self.failUiData[i].icon)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-- 初始化玩家信息
function WndDailyCopySettlement:_initExpFrame()
    -- 玩家等级
    local txtLv = GetElement(self.m_root,"txtExpLv_WndDailyCopySettlement",WZUILabelTTF)
    txtLv:setText("Lv"..self.curLv)

    local pro = GetElement(self.m_root,"proLv_WndDailyCopySettlement", WZUIProgress)
    local txtExp = GetElement(self.m_root,"txtExp_WndDailyCopySettlement",WZUILabelTTF)
    local maxExp =  GDatatab_player_upgrade["id_"..self.curLv].exp
    pro:setPercentage(math.floor(self.curExp/maxExp*100))
    txtExp:setText(self.curExp.."/"..maxExp)
end

-- 经验条动画
function WndDailyCopySettlement:_expAni(element,dt)
    -- 升级标记
    local imgUp = GetElement(self.m_root,"imgUp_WndDailyCopySettlement",WZUIImage)
    -- 进度条
    local pro = GetElement(self.m_root,"proLv_WndDailyCopySettlement", WZUIProgress)

    local exp = math.max(math.floor(self.needAddExp/20),1)
    local maxExp = GetMaxExpByLevel(self.curLv)
    local maxLv = GetPlayerMaxLevel()
    if self.leftExp == 0 then
        pro:disableSchedule()
        return
    end
    local addExp = (self.leftExp > exp ) and exp or self.leftExp
    self.leftExp = self.leftExp - addExp
    self.curExp = self.curExp + addExp
    if self.curExp > maxExp then
        if self.curLv == maxLv then
            self.curExp = maxExp
            pro:disableSchedule()
        else
            self.curExp = self.curExp - maxExp
            self.curLv = self.curLv + 1
            imgUp:setVisible(true)
        end
    end
    self:_updateExpProgress()
end

--@brief	更新经验值进度条
function WndDailyCopySettlement:_updateExpProgress()
    local nMaxExp = GetMaxExpByLevel(self.curLv)
    local pro = GetElement(self.m_root,"proLv_WndDailyCopySettlement", WZUIProgress)
    pro:setPercentage(math.min(self.curExp*100/nMaxExp, 100))

    local txtExp = GetElement(self.m_root,"txtExp_WndDailyCopySettlement",WZUILabelTTF)
    txtExp:setText(self.curExp.."/"..nMaxExp)

    local txtLv = GetElement(self.m_root,"txtExpLv_WndDailyCopySettlement",WZUILabelTTF)
    txtLv:setText("Lv"..self.curLv)
end

-----------------------------------------语言适配模块Begin------------------------------------
function WndDailyCopySettlement:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtGold4_WndDailyCopySettlement",WZUILabelTTF):setFontSize(18)
    local conPet = GetElement(self.m_root,"conPet_WndDailyCopySettlement",WZUIContainer)
    local txtGoldDesc3 = GetElement(conPet,"txtGoldDesc3_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc3:setRelativePosition(GlobalMethod:ccp(0.76,0.539312))
end

function WndDailyCopySettlement:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtGold4_WndDailyCopySettlement",WZUILabelTTF):setFontSize(18)
    local txtGoldDesc5 = GetElement(self.m_root,"txtGoldDesc5_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc5:setFontSize(16)
    txtGoldDesc5:setRelativePosition(GlobalMethod:ccp(0.69,0.37333))
    GetElement(self.m_root,"txtExp1_WndDailyCopySettlement",WZUILabelTTF):setFontSize(18)
end
function WndDailyCopySettlement:_adaptLanguage_tr(  )
    local conGold = GetElement(self.m_root,"conGold_WndDailyCopySettlement",WZUIContainer)
    local txtGold4 = GetElement(conGold,"txtGold4_WndDailyCopySettlement",WZUILabelTTF)
    txtGold4:setScale(0.85)
    txtGold4:setDimensions(GlobalMethod:CCSize(200))
    txtGold4:setRelativePosition(GlobalMethod:ccp(0.12,0.372154))
    local txtGoldDesc4 = GetElement(conGold,"txtGoldDesc4_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc4:setScale(0.85)
    txtGoldDesc4:setRelativePosition(GlobalMethod:ccp(0.574454,0.37333))

    local conPet = GetElement(self.m_root,"conPet_WndDailyCopySettlement",WZUIContainer)
    local txtGoldDesc4 = GetElement(conPet,"txtGoldDesc4_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc4:setRelativePosition(GlobalMethod:ccp(0.55,0.37333))

    local imgFinish = GetElement(self.m_root,"imgFinish_WndDialyCopySettlement",WZUIImage)
    imgFinish:setRelativePosition(GlobalMethod:ccp(0.9,0.369189))
    local txtGoldDesc4 = GetElement(self.m_root,"txtGoldDesc5_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc4:setFontSize(20)
end

function WndDailyCopySettlement:_adaptLanguage_en(  )
    local conGold = GetElement(self.m_root,"conGold_WndDailyCopySettlement",WZUIContainer)
    local txtGoldDesc4 = GetElement(conGold,"txtGoldDesc4_WndDailyCopySettlement",WZUILabelTTF)
    txtGoldDesc4:setRelativePosition(GlobalMethod:ccp(0.65,0.37333))
end

-----------------------------------------语言适配模块End--------------------------------------