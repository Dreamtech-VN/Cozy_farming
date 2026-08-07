--WndCommunityBossEnd.lua
--@brief	WndCommunityBossEnd的UI模块
--@date		2017-01-19
--@note		公会boss活动结束界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityBossEnd:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityBossEnd:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndCommunityBossEnd:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,nil,self)
end


--@brief   关闭窗口
function WndCommunityBossEnd:OnSureClick( element)
    WZLog("WndCommunityBossEnd:OnSureClick")
    WndCommunityBossWin:showWindow(self.m_tData)
    
    WindowManager:removeWindow(self.m_root , self , true)
end


-- 对外接口
--hurtValue	int	总伤害输出
--hurtRank	int	输出排名
--hurtPercent	int	伤害所占百分比
--isWin	boolean	是否赢了
--killerId	long	击杀玩家id
--killerName	String	击杀玩家名称
-- bossId = 1
function WndCommunityBossEnd:showWnd( data )
    self.m_tData = data
    if self.m_tData.isWin then 
        if self.m_tData.killerId == WBattleGlobal:getCurrent():getMyBattleId() then
            self:OnSureClick()
        else
            local wndCommunityBossEnd = WndCommunityBossEnd:createElement()
            WindowManager:addWindow( wndCommunityBossEnd , WndCommunityBossEnd )
            self:_update()
        end
    else
        self:OnSureClick()
        return
    end    
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndCommunityBossEnd:_update( )
    WZLog("WndCommunityBossEnd:_update")
    local data = self.m_tData
    local mapInfo = GDatatab_guild_boss_map["id_"..data.mapId]
    if not mapInfo then
        return
    end
    local monsterId = mapInfo.monster[1][1]
    local monsterTmp = GDatatab_monster["id_"..monsterId]

    local ftbWin = GetElement(self.m_root,"ftbWinDesc_WndCommunityBossEnd",WZUIFreeTextBox)
    ftbWin:setShowText(string.format(LocalStrings.GUILD_BOSS_WIN_DESC,data.killerName,monsterTmp.name))
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndCommunityBossEnd:_adaptLanguage_es(  )
    local txtGet = GetElement(self.m_root,"txtGet_WndCommunityBossInspire",WZUILabelTTF)
    txtGet:setRelativePosition(GlobalMethod:ccp(0.17,0.534468))
    local txtGetNum = GetElement(self.m_root,"txtGetNum_WndCommunityBossInspire",WZUILabelTTF)
    txtGetNum:setRelativePosition(GlobalMethod:ccp(0.62,0.534468))
    local txtGetDia = GetElement(self.m_root,"txtGetDia_WndCommunityBossEnd",WZUILabelTTF)
    txtGetDia:setRelativePosition(GlobalMethod:ccp(0.173,0.431064))
    local txtGetDiaN = GetElement(self.m_root,"txtGetDiaN_WndCommunityBossEnd",WZUILabelTTF)
    txtGetDiaN:setRelativePosition(GlobalMethod:ccp(0.62,0.431064))
    GetElement(self.m_root,"txtNotice_WndCommunityBossEnd",WZUILabelTTF):setScale(0.75)
end
-------------------------------------语言适配End--------------------------------------------