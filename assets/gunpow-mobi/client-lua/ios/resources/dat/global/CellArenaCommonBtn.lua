--CellArenaCommonBtn.lua
--@brief	CellArenaCommonBtn的UI模块
--@date		2016-11-24
--@author	binshao
--@note		竞技场底部按钮栏


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellArenaCommonBtn:onEnter(element)
	self.m_root = element
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    if #info.addValue > 0 then
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(true)
        if GlobalGame.g_tRedPointList and GlobalGame.g_tRedPointList.pvpBuff then 
            GetElement(self.m_root, "imgARedDot_CellArenaCommonBtn", WZUIImage):setVisible(true)
        end
    else
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(false)
    end
    self.m_root:enableSchedule("onSchedule",10)

    AdaptLanguage(self)
end

function CellArenaCommonBtn:onSchedule(element,dt)
    if not self.m_root then
        return
    end
    CacheCenter:updateArenaAddInfo()
    local info = CacheCenter:getArenaAddInfo()
    
     if #info.addValue > 0 then
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(true)
    else
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(false)
    end
end

--@brief 按钮刷新
function CellArenaCommonBtn:updateArenaAddBtn()
    WZLog("CellArenaCommonBtn:updateArenaAddBtn",tostring(self.m_root))
    if not self.m_root then
        return
    end
    local info = CacheCenter:getArenaAddInfo()
    if #info.addValue > 0 then
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(true)
    else
        GetElement(self.m_root,"btnArenaAddInfo_CellArenaCommonBtn",WZUIButton):setVisible(false)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellArenaCommonBtn:onExit(element)
    if not self.m_root then
        return
    end
    self.m_root:disableSchedule()
	self:_unInit()
end

-- 新手指导 训练营
function CellArenaCommonBtn:onNewLead()
    WZLog("----------CellArenaCommonBtn:onNewLead------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

-- 观战
function CellArenaCommonBtn:onLookVideo()
    WZLog("----------CellArenaCommonBtn:onLookVideo------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndAthVideo:showWnd()
end

-- 竞技商店
function CellArenaCommonBtn:onArenaShop()
    WZLog("----------CellArenaCommonBtn:onArenaShop------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --WndAthShop:showWnd()
    --WndStore:showStoreByType(1)
	--JumpByUIId(8)
    WndStore:showStoreByType(1,nil,nil)
end

-- 排行榜
function CellArenaCommonBtn:onRank()
    WZLog("----------CellArenaCommonBtn:onRank------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --WndAthRank:showWnd()
	local wnd = WndAthRank:createElement()
    WindowManager:addWindow(wnd, WndAthRank,false,false,nil,true)
end

-- 训练营
function CellArenaCommonBtn:onTrain()
    WZLog("----------CellArenaCommonBtn:onArenaShop------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTrainingCamp:showInterface()
end

-- 练习赛
function CellArenaCommonBtn:onPractice()
    WZLog("----------CellArenaCommonBtn:onPractice------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndTrain:show()
end

-- 加成卡帮助
function CellArenaCommonBtn:onArenaAddHelpClick()
    WZLog("----------CellArenaCommonBtn:onArenaAddHelpClick------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- local sRule = string.gsub(LocalStrings.COMMUNITYWAR_TEXT12, "255,236,193", "127,70,26")
    WndSingleMapDesc:showInterface1(LocalStrings.ARENA_CARD_DES)
end

-- 加成卡信息
function CellArenaCommonBtn:onArenaAddInfoClick()
    WZLog("----------CellArenaCommonBtn:onArenaShop------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if GlobalGame.g_tRedPointList.pvpBuff then 
        GetElement(self.m_root, "imgARedDot_CellArenaCommonBtn", WZUIImage):setVisible(false)
        GlobalGame.g_tRedPointList.pvpBuff = false
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(154)
    end
    
    if ScenePvp.m_root then
        local con = GetElement(self.m_root,"conArenaAddInfo_CellArenaCommonBtn",WZUIContainer)
        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
            WndTips:show(con,ScenePvp.m_root,32,{},GlobalMethod:ccp(-320,20))
        else    
            WndTips:show(con,ScenePvp.m_root,32,{})
        end
    end
    if ScenePvpAmuse.m_root then
        local con = GetElement(self.m_root,"conArenaAddInfo_CellArenaCommonBtn",WZUIContainer)
        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
            WndTips:show(con,ScenePvpAmuse.m_root,32,{},GlobalMethod:ccp(-320,20))
        else 
            WndTips:show(con,ScenePvpAmuse.m_root,32,{})
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellArenaCommonBtn:_adaptLanguage_en( )
    GetElement(self.m_root,"txtBtn1_CellArenaCommonBtn",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtBtn2_CellArenaCommonBtn",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtBtn3_CellArenaCommonBtn",WZUILabelTTF):setScale(0.65)
end

function CellArenaCommonBtn:_adaptLanguage_vn( )
    local txtBtn1 = GetElement(self.m_root,"txtBtn1_CellArenaCommonBtn",WZUILabelTTF)
    txtBtn1:setScale(0.7)
    txtBtn1:setDimensions(GlobalMethod:CCSize(170))
    GetElement(self.m_root,"txtBtn2_CellArenaCommonBtn",WZUILabelTTF):setScale(0.9)

end

function CellArenaCommonBtn:_adaptLanguage_pt( )
    GetElement(self.m_root,"txtBtn1_CellArenaCommonBtn",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtBtn2_CellArenaCommonBtn",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtBtn3_CellArenaCommonBtn",WZUILabelTTF):setScale(0.65)
end

function CellArenaCommonBtn:_adaptLanguage_es(  )
    for i=1,3 do
        local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_CellArenaCommonBtn",WZUILabelTTF)
        txtBtn:setDimensions(GlobalMethod:CCSize(130,0))
        txtBtn:setScale(0.8)
    end
end

function CellArenaCommonBtn:_adaptLanguage_tr( )
    local txtBtn2 = GetElement(self.m_root,"txtBtn1_CellArenaCommonBtn",WZUILabelTTF)
    txtBtn2:setScale(0.8)
    txtBtn2:setDimensions(GlobalMethod:CCSize(160))
    local txtBtn3 = GetElement(self.m_root,"txtBtn2_CellArenaCommonBtn",WZUILabelTTF)
    txtBtn3:setScale(0.8)
    txtBtn3:setDimensions(GlobalMethod:CCSize(160))
end
-------------------------------------语言适配End--------------------------------------------
