--CellRemainsChallenge.lua
--@brief	CellRemainsChallenge的UI模块
--@date		2019/07/12
--@author	yrd
--@note		遗迹之光挑战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRemainsChallenge:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRemainsChallenge:onExit(element)
	self:_unInit()
end

-- nPlayerId
-- nPlayerName
-- nMapTime
-- nMapId
-- nMapNum
-- nBossBloodMax
-- nBossBloodCurrent
-- nMapStatus
function CellRemainsChallenge:_update()
	local tDigMap = GDatatab_dig_map["id_"..self.m_tData.nMapNum]
	local tMonsterInfo = GDatatab_monster["id_"..tDigMap.monster[1][1]]
	local nbossScale = tMonsterInfo.scale
    local monsterSpine = tMonsterInfo.AniFileId

	GetElement(self.m_root,"txtDiscovererName_CellRemainsChallenge",WZUILabelTTF):setText(self.m_tData.nPlayerName)
	GetElement(self.m_root,"txtBossName_CellRemainsChallenge",WZUILabelTTF):setText(tDigMap.map_name)
   	GetElement(self.m_root,"txtBossHP_CellRemainsChallenge",WZUILabelTTF):setText(self.m_tData.nBossBloodCurrent .."/"..self.m_tData.nBossBloodMax)
	GetElement(self.m_root,"proBossHP_CellRemainsChallenge",WZUIProgress):setPercentage(math.ceil(self.m_tData.nBossBloodCurrent/self.m_tData.nBossBloodMax*100))


	local spBoss = GetElement(self.m_root,"spBoss_CellRemainsChallenge",WZUISpine)
    spBoss:setScale(0.5)
    spBoss:setFileAtlas("battle/monster/" .. monsterSpine .. ".atlas")
    spBoss:setFileJson("battle/monster/" .. monsterSpine .. ".json")
    spBoss:setAnimationName("wait")

    local sec = self.m_tData.nMapTime%60
    local min = math.ceil(self.m_tData.nMapTime/60)%60
    local hour = math.floor(math.ceil(self.m_tData.nMapTime/60)/60)
   	GetElement(self.m_root,"txtRemainingTime_CellRemainsChallenge",WZUILabelTTF):setText(string.format("%02d:%02d", hour, min))

end

function CellRemainsChallenge:onClickView(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndRemainsInfo:showInterface(self.m_tData.nMapId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function CellRemainsChallenge:_adaptLanguage_vn()
	GetElement(self.m_root,"txtDiscoverer_CellRemainsChallenge",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.17))
	GetElement(self.m_root,"txtDiscovererName_CellRemainsChallenge",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.17))
end
-------------------------------------语言适配End----------------------------------------
