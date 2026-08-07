--WndWorldTeamBossEndData.lua
--@brief	WndWorldTeamBossEnd的数据模块
--@date		2018/07/19
--@author	Tianxiang_Xu
--@note		世界组队Boss结算界面

WndWorldTeamBossEnd = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldTeamBossEnd:_init()
	self.m_root = nil	 	  			--场景根节点
	self.data = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldTeamBossEnd:_unInit()
	self.m_root = nil
	self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldTeamBossEnd:createElement()
	if WndWorldTeamBossEnd.m_root ~= nil then
		WindowManager:removeWindow(WndWorldTeamBossEnd.m_root, WndWorldTeamBossEnd, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWorldTeamBossEnd")
	assert(element, "WndWorldTeamBossEnd create element failed!")
	self:_init()
	return element
end

function WndWorldTeamBossEnd:showWindow(data)
    local wnd = WndWorldTeamBossEnd:createElement()
    WindowManager:addWindow( wnd ,WndWorldTeamBossEnd,false)

    self.data = data
    WZLog("WndWorldTeamBossEnd:showWnd", Serialize(self.data))
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取玩家结算数据
function WndWorldTeamBossEnd:_getPlayerSettlementData()
    local tMakePairOk = WBattleGlobal:getCurrent().m_tMakePairOk

    for i = 1, #tMakePairOk.playerId do
    	local tData = {}

        tData.id = tMakePairOk.playerId[i]
        tData.name = tMakePairOk.playerName[i]
        tData.sex = tMakePairOk.playerSex[i]
        tData.headId = tMakePairOk.headId[i]
        tData.faceId = tMakePairOk.faceId[i]
        tData.bodyId = tMakePairOk.bodyId[i]
        tData.weaponId = tMakePairOk.weaponId[i]
        tData.wingId = tMakePairOk.wingId[i]
        tData.petId = tMakePairOk.petId[i]
        tData.headColor = tMakePairOk.colour[i]
        tData.bodyColor = tMakePairOk.bodyColour[i]
        WZLog("------------iii-----------",tData.id,tData.headColor,tData.bodyColor)

        local conPlayer = GetElement(self.m_root, "conPlayer" .. i .. "_WndWorldTeamBossEnd", WZUIContainer)
        conPlayer:setVisible(true)
        local tEquip = {tData.faceId, tData.headId, tData.bodyId, tData.wingId, tData.weaponId}
        local aniPlayer = CreatePlayerFigure(tData.sex, tEquip, "win",nil,nil,nil,nil,nil,nil,nil,tData.headColor,tData.bodyColor)
    	aniPlayer:setScale(1)
    	aniPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    	aniPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0.02))
        conPlayer:addChild(aniPlayer:getAnimNode())
        if #tMakePairOk.playerId > 1 then
        	if i == 1 then
        		conPlayer:setRelativePosition(GlobalMethod:ccp(0.37, 0.332812))
        	else
        		conPlayer:setRelativePosition(GlobalMethod:ccp(0.63, 0.332812))
        	end
        end
    end
    
end




-------------------------------------私有方法模块End----------------------------------------
