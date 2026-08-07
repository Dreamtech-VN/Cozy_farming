--WndWorldBossEnd.lua
--@brief	WndWorldBossEnd的UI模块
--@date		2015-10-15
--@author	binshao
--@note		世界boss活动结束界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBossEnd:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBossEnd:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndWorldBossEnd:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,nil,self)
end

--@brief    弹窗动画完成后的回调
function WndWorldBossEnd:actionCallback()
    WZLog("----------------WndWorldBossEnd-----------desc",self.isDesc)
    if self.m_nType == 2 then 
        --世界组队Boss
        WndWorldTeamBossEnd:showWindow(self.data)
    else
        if self.isDesc then
            WndWorldBossEndReward:showWnd(self.data)
        else
            SceneWorldBoss:setResultInfo(self.data)
        end
    end
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief   关闭窗口
function WndWorldBossEnd:OnSureClick( element)
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback",self)
end


-- 对外接口
--hurtValue	int	总伤害输出
--hurtRank	int	输出排名
--hurtPercent	int	伤害所占百分比
--isWin	boolean	是否赢了
--killerId	long	击杀玩家id
--killerName	String	击杀玩家名称
-- bossId = 1
--@param    nType:2->世界组队Boss; 其他世界Boss
function WndWorldBossEnd:showWnd( data, isAni, nType)
	local wndWorldBossEnd = WndWorldBossEnd:createElement()
	WindowManager:addWindow( wndWorldBossEnd , WndWorldBossEnd )

    --local data = {hurtValue = 1502,hurtRank = 5,hurtPercent = 10,isWin = true,killerId = "110",killerName = "OOO",bossId = 1}
    self.data = data
    self.isDesc = isAni
    self.m_nType = nType or 1
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndWorldBossEnd:_update( )
    local data = self.data
    local ftbWin = GetElement(self.m_root,"ftbWinDesc_WndWorldBossEnd",WZUIFreeTextBox)
    local ftbFail = GetElement(self.m_root,"ftbFailDesc_WndWorldBossEnd",WZUIFreeTextBox)
    if self.m_nType == 2 then 
        ftbWin:setVisible(true)
        ftbFail:setVisible(true)
        local sFormat1 = [[<T C="255,236,193" S="22" P="0">%s</T>]]
        local sFormat2 = [[<T C="99,255,95" S="22" P="0">%s</T>]]
        local sFormat3 = [[<T C="255,236,193" S="22" P="0"> & </T>]]
        local sContent  

        if data.bWin then
            if #data.killerName > 1 then
                local sFormat = sFormat1 .. sFormat2 .. sFormat3 .. sFormat2 .. sFormat1
                sContent = string.format(sFormat, LocalStrings.PLAYER, data.killerName[1], data.killerName[2], LocalStrings.TEAMBOSS_TEXT17)
            else
                local sFormat = sFormat1 .. sFormat2 .. sFormat1
                sContent = string.format(sFormat, LocalStrings.PLAYER, data.killerName[1], LocalStrings.TEAMBOSS_TEXT17)
            end
        elseif data.timeOver then
            sContent = string.format(sFormat1, LocalStrings.TEAMBOSS_TEXT20)
        end

        ftbWin:setShowText(sContent)
    else
        local info = GDatatab_world_boss_map["id_"..data.bossId]
        --local time = info.start_time.."-"..info.end_time
        local time = info.start_time
        local bossName = info.boss_name

        ftbWin:setVisible(data.isWin)
        ftbFail:setVisible(not data.isWin)
        ftbWin:setShowText(string.format(LocalStrings.WORLD_BOSS_WIN_DESC,data.killerName,bossName))
        ftbFail:setShowText(string.format(LocalStrings.WORLD_BOSS_FAIL_DESC,bossName))

        local txtDesc = GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF)
        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            txtDesc:setText(string.format(LocalStrings.WORLD_BOSS_TITLE_DEAC,bossName,time))
        else
            txtDesc:setText(string.format(LocalStrings.WORLD_BOSS_TITLE_DEAC,time,bossName))
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------
function WndWorldBossEnd:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF):setFontSize(17)
end

function WndWorldBossEnd:_adaptLanguage_tr(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(280,0))
    txtDesc:setFontSize(18)
end
function WndWorldBossEnd:_adaptLanguage_en(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(360,0))
    txtDesc:setFontSize(18)
    txtDesc:setRelativePosition(GlobalMethod:ccp(0.5,0.62))    
end
function WndWorldBossEnd:_adaptLanguage_pt(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(360,0))
    txtDesc:setFontSize(18)
    txtDesc:setRelativePosition(GlobalMethod:ccp(0.5,0.62))    
end
function WndWorldBossEnd:_adaptLanguage_es(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndWorldBossEnd",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(360,0))
    txtDesc:setFontSize(18)
    txtDesc:setRelativePosition(GlobalMethod:ccp(0.5,0.62)) 
end
--------------------------------------语言适配End-------------------------------------


-------------------------------------私有方法模块End----------------------------------------