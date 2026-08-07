--BattleCtbManager.lua
--@date		2015/04/17
--@author	Zjh

BattleCtbManager =
{
	--root
	m_tWndBattleHud = nil,

	--tabContainer
	m_tabBattleCtb = nil,
    m_tabBattleCtb2 = nil,
	m_tabBigBattleCtb = nil,

	--tab的cell数量
	m_nTabCtbNumber = nil,
	m_nBigTabCtbNumber = nil,

	--cellBattleCtb_luaTable
	m_tCellBattleCtb = nil,
	m_tBigCellBattleCtb = nil,

	m_tLastNowCtb = nil,
	m_tLastNewCtb = nil,
	m_tLastPlayerId = nil,

	m_bIsShowCtb = true,

	--Action CTB
	PASS_CTB = 2000,
	SHOOT_CTB = 2000,
	BIGSKILL_CTB = 3000,
	--CTB
	MAX_CTB = 10000,
	SECOND_PER_CTB = 5000,
	--回合CTB增长值
	m_nUpdateCTB_time = 0,
    m_nTotalCTB_time = 0,

	UNUSE_HERO_ID = 0,
    m_tBg = nil,
    m_bIsVisble = true,

}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始CTB管理
function BattleCtbManager:startBattleCtb(tWndBattleHud)

	-- self:_init()

	self.m_tWndBattleHud = tWndBattleHud

	self.m_tabBattleCtb = GetElement(self.m_tWndBattleHud,"tabBattleCtb_WndBattleHud",WZUITableContainer)
	self.m_tabBattleCtb:setEnableMoveVertical(true)
	self.m_tabBattleCtb2 = GetElement(self.m_tWndBattleHud,"tabBattleCtb2_WndBattleHud",WZUITableContainer)
	self.m_tabBattleCtb2:setEnableMoveVertical(true)

	self:createBigCtb()

    local guildName,guildName2,teamId,teamId2 = "","","",""
	local heroIdListSort = {}
	local myId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
	table.insert(heroIdListSort,myId)
	for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
		local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
		if playerId ~= myId and WBattleGlobal:getCurrent():isMyTeam(playerId) then
			table.insert(heroIdListSort,playerId)
        elseif playerId == myId then
            guildName = WBattleGlobal:getCurrent().m_tMakePairOk.playerCommunity[i]
            teamId = WBattleGlobal:getCurrent().m_tMakePairOk.teamId and WBattleGlobal:getCurrent().m_tMakePairOk.teamId[i] + 1 or ""
		end
	end


	--table.insert(heroIdListSort,BattleCtbManager.UNUSE_HERO_ID)
	for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
		local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
		if not WBattleGlobal:getCurrent():isMyTeam(playerId) then
			table.insert(heroIdListSort,playerId)
            local guild = WBattleGlobal:getCurrent().m_tMakePairOk.playerCommunity[i]
            if guild ~= "" then
                guildName2 = guild
                teamId2 = WBattleGlobal:getCurrent().m_tMakePairOk.teamId and WBattleGlobal:getCurrent().m_tMakePairOk.teamId[i] + 1 or ""
            end
		end
	end

	if self:_isGuildBattle() then
		self.m_tGuildIcon = self:_createGuildIcon(false,guildName,guildName2,teamId,teamId2)
	    self.m_tGuildIcon2 = self:_createGuildIcon(true,guildName,guildName2,teamId,teamId2)
	end

    if false and WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ then
        GetElement(self.m_tWndBattleHud,"conNameCtb_WndBattleHud",WZUIContainer):setVisible(true)
        GetElement(self.m_tWndBattleHud,"conNameCtb2_WndBattleHud",WZUIContainer):setVisible(true)
        GetElement(self.m_tWndBattleHud,"txtNameCtb_WndBattleHud",WZUILabelTTF):setText(guildName)
        GetElement(self.m_tWndBattleHud,"txtNameCtb2_WndBattleHud",WZUILabelTTF):setText(guildName2)
    end

	local guaiList = WBattleGlobal:getCurrent():getBossList()
	for id,guai in pairs(guaiList) do
		if guai.isNormalAct and not guai:isNormalAct() then
			
		else
			table.insert(heroIdListSort,id)
		end
	end
	for i=1,#heroIdListSort do
		self:addCellBattleCtb(heroIdListSort[i])
	end
	self.m_tabBattleCtb:setVisible(self.m_bIsVisble)
    self.m_tabBattleCtb2:setVisible(self.m_bIsVisble)
end

--@brief	增加角色到ctb列表
--@param	角色BattleId
function BattleCtbManager:addCellBattleCtb(nHeroId)
	WZLog("BattleCtbManager:addCellBattleCtb 0",nHeroId)
	if self.m_tabBattleCtb and self.m_tCellBattleCtb[nHeroId] == nil then
		if nHeroId ~= BattleCtbManager.UNUSE_HERO_ID then
			local tHero = WBattleGlobal:getCurrent():getHeroWithId(nHeroId) or WBattleGlobal:getCurrent():getGuaiWithId(nHeroId)
			WZLog("BattleCtbManager:addCellBattleCtb 3", tostring(tHero))
			if tHero == nil then
				return
			end
			self:_setCtbNumber(self.m_nTabCtbNumber + 1,true,nHeroId)

			local cell,tab = CellBattleCtb:createElement()

			if WBattleGlobal:getCurrent():isMyTeam(nHeroId) then
                cell:setTag(self.m_nTabCtbNumber1 - 1)
				self.m_tabBattleCtb:setCellElement(cell)
                WZLog("BattleCtbManager:addCellBattleCtb 1")
			else
				if WBattleGlobal:getCurrent():isFlyCopy() then
					cell:setVisible(false)
				end
                cell:setTag(self.m_nTabCtbNumber2 - 1)
				self.m_tabBattleCtb2:setCellElement(cell)
                WZLog("BattleCtbManager:addCellBattleCtb 2")
			end
			tab:setCharacter(tHero)
            tHero:setCtb(tab)

			self.m_tCellBattleCtb[nHeroId] = tab
		end

		self.m_tabBattleCtb:getMoveElement():setPosition(self.m_tabBattleCtb:getMinPosition())
        self.m_tabBattleCtb2:getMoveElement():setPosition(self.m_tabBattleCtb2:getMinPosition())
	end
end

--@brief	打乱头像顺序
function BattleCtbManager:randomTag()
	local height = self.m_tabBattleCtb2:getCellElementHeight()
	WZLog("头像框高度",height)

	--删除所有怪物头像
	local monsterID = {}
	for k,v in pairs(self.m_tCellBattleCtb) do
		WZLog(k,v)
		local tHero = WBattleGlobal:getCurrent():getHeroWithId(k) or WBattleGlobal:getCurrent():getGuaiWithId(k)
		if tHero:getType() == 1 then
			self:setDead(k,true)
			table.insert(monsterID,k)
		end
	end
	--随机加入怪物头像
	local monster1 = math.random(3)
	self:addCellBattleCtb(monsterID[monster1])
	table.remove(monsterID,monster1)
	local monster2 = math.random(2)
	self:addCellBattleCtb(monsterID[monster2])
	table.remove(monsterID,monster2)
	self:addCellBattleCtb(monsterID[1])
end

function BattleCtbManager:createBigCtb()
	if self.m_tabBigBattleCtb == nil then
		self.m_tabBigBattleCtb = GetElement(self.m_tWndBattleHud,"tabBigBattleCtb_WndBattleHud",WZUITableContainer)

		local heroIdListSort = {}
		local myId = WBattleGlobal:getCurrent():getMyHero():getBattleId()
		table.insert(heroIdListSort,myId)
		for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
			local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
			if playerId ~= myId and WBattleGlobal:getCurrent():isMyTeam(playerId) then
				table.insert(heroIdListSort,playerId)
			end
		end
		for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
			local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
			if not WBattleGlobal:getCurrent():isMyTeam(playerId) then
				table.insert(heroIdListSort,playerId)
			end
		end
		self.m_nBigTabCtbNumber = #heroIdListSort

		self:_adjustBigTab()

		for i=1,#heroIdListSort do
			if heroIdListSort[i] ~= BattleCtbManager.UNUSE_HERO_ID then
				local hero = WBattleGlobal:getCurrent():getHeroWithId(heroIdListSort[i])
				local cell,tab = CellBigBattleCtb:createElement()
				cell:setTag(i - 1)
				self.m_tabBigBattleCtb:setCellElement(cell)
				tab:setCharacter(hero)
                hero:setBigCtb(tab)

				self.m_tBigCellBattleCtb[hero:getBattleId()] = tab

				if i==1 then
					tab:showTopLine(false)
				end
			else
				local cell = WZUIContainer:create()
				cell:setTag(i - 1)
				self.m_tabBigBattleCtb:setCellElement(cell)
			end

			self.m_tabBigBattleCtb:getMoveElement():setPosition(self.m_tabBigBattleCtb:getMinPosition())
		end
	end
end

--@brief	是否显示BigCTB
function BattleCtbManager:showBigCtb(bShow)
	if bShow == nil then
		bShow = true
	end
    WZLog("BattleCtbManager:showBigCtb", tostring(bShow))
	GetElement(self.m_tWndBattleHud,"conBigBattleCtb_WndBattleHud"):setVisible(bShow)
	GetElement(self.m_tWndBattleHud,"conBattleCtb_WndBattleHud"):setVisible(not bShow)
end

--@brief	增加角色的CTB值
--@param	nCharactorId，角色BattleId
--@param	nAddCtb，CTB值
function BattleCtbManager:addCtb(nCharactorId,nAddCtb)
   
    
    WZLog("BattleCtbManager:addCtb", nCharactorId, nAddCtb)
	if self.m_tCellBattleCtb[nCharactorId] then
		self.m_tCellBattleCtb[nCharactorId]:addCtb(nAddCtb)
	end
end

--@brief	设置角色的CTB值
--@param	nCharactorId，角色BattleId
--@param	nowCtb，CTB值
--@note		无动画过度
function BattleCtbManager:setCtb(nCharactorId,nowCtb,isReset)
	if self.m_tCellBattleCtb[nCharactorId] then
		self.m_tCellBattleCtb[nCharactorId]:setCtb(nowCtb,isReset)
	end
end

--@brief	更新角色的CTB值
--@param	nCharactorId，角色BattleId
--@param	nowCtb，CTB值
--@note		有动画过度
function BattleCtbManager:updateCtb(nCharactorId,nowCtb)
	if self.m_tCellBattleCtb[nCharactorId] then
		self.m_tCellBattleCtb[nCharactorId]:updateCtb(nowCtb)
	end
end

--@brief	回合更新CTB
function BattleCtbManager:updateByTurn()
	for i,v in pairs(self.m_tCellBattleCtb) do
		v:updateByTurn()
	end
end

--@brief	设置角色死亡
--@param	nCharactorId，角色BattleId
--@param	isDead，是否死亡
function BattleCtbManager:setDead(nCharactorId,isDead)
	local tab = self.m_tCellBattleCtb[nCharactorId]
    WZLog("BattleCtbManager:setDead", nCharactorId, isDead)
	if tab then
		if tab:getCharacterType() == CharacterType.TYPE_HERO or WBattleGlobal:getCurrent():isSingleStage() then
			tab:setDead(isDead)
		elseif isDead then
            self:_setCtbNumber(self.m_nTabCtbNumber - 1,false,nCharactorId)
            
            
            if WBattleGlobal:getCurrent():isMyTeam(nCharactorId) then

				self.m_tabBattleCtb:removeCellElementByReset(tab:getRoot():getTag())
                self.m_tabBattleCtb:UpdateInsidePosition()
                self.m_tabBattleCtb:getMoveElement():setPosition(self.m_tabBattleCtb:getMinPosition())
			else

				self.m_tabBattleCtb2:removeCellElementByReset(tab:getRoot():getTag())
                self.m_tabBattleCtb2:UpdateInsidePosition()
                self.m_tabBattleCtb2:getMoveElement():setPosition(self.m_tabBattleCtb2:getMinPosition())
			end
            self:_adjustTab()
            self:_adjustTab2()

			self.m_tCellBattleCtb[nCharactorId] = nil

		end
	end
end

--@param	isDead，是否死亡
function BattleCtbManager:setExit(nCharactorId,isExit, isQuit)
    local tab = self.m_tCellBattleCtb[nCharactorId]
    WZLog("BattleCtbManager:setExit", nCharactorId, isExit, isQuit)
    if tab then
        tab:setExit(isExit, isQuit)
    end
end

--@brief	是否存在进度条动画显示
function BattleCtbManager:checkHasProgAction()
	local hasAction = false
	for i,v in pairs(self.m_tCellBattleCtb) do
		if v:hasProgAction() then
			hasAction = true
		end
	end

	return hasAction
end

--@brief	更新CTB数值到数据表
function BattleCtbManager:refreshLastCtb(tPlayerId,tLastNowCtb,tLastNewCtb,updateCTB_time)
	WZLog("refreshLastCtb",updateCTB_time)
	if tPlayerId then
		self.m_tLastPlayerId = {}
		self.m_tLastNowCtb = {}
		self.m_tLastNewCtb = {}
		self.m_tUpdateCtbValue = {}
		for i=1,#tPlayerId do
			WZLog(tPlayerId[i],tLastNowCtb[i],tLastNewCtb[i])
			self.m_tLastPlayerId[i] = tPlayerId[i]
			self.m_tLastNowCtb[i] = tLastNowCtb[i]
			self.m_tLastNewCtb[i] = tLastNewCtb[i]
			local hero = WBattleGlobal:getCurrent():getCharacterWithId(tPlayerId[i])
			self.m_tUpdateCtbValue[tPlayerId[i]] = hero and math.ceil(updateCTB_time * hero:getCTBSpeed() / 1000) or 0
			WZLog("refreshLastCtb-two",tPlayerId[i],self.m_tUpdateCtbValue[tPlayerId[i]])
		end
		self.m_nUpdateCTB_time = updateCTB_time
	end
    if updateCTB_time then
        self.m_nTotalCTB_time = self.m_nTotalCTB_time + updateCTB_time
    end
    WZLog("refreshLastCtb II",self.m_nTotalCTB_time,Serialize(self.m_tUpdateCtbValue),Serialize(BattleCtbManager.m_tUpdateCtbValue))
end

--@brief	显示最新的CTB变化（从数据表读）
function BattleCtbManager:showCtbTime()
	if self.m_tLastPlayerId == nil then
		self.m_tLastPlayerId = {}
		self.m_tLastNowCtb = {}
		self.m_tLastNewCtb = {}
		--[[local heroList = WBattleGlobal:getCurrent():getHeroList()
		for i=1,WBattleGlobal:getCurrent().m_tMakePairOk.playerCount do
			local playerId = WBattleGlobal:getCurrent().m_tMakePairOk.playerId[i]
			self.m_tLastPlayerId[i] = playerId
			self.m_tLastNewCtb[i] = 10000
			self.m_tLastNowCtb[i] = 5000
		end]]
	end

	for i=1,#self.m_tLastPlayerId do
		self:setCtb(self.m_tLastPlayerId[i],self.m_tLastNowCtb[i])
		self:updateCtb(self.m_tLastPlayerId[i],self.m_tLastNewCtb[i])
	end

    if not WBattleGlobal:getCurrent():isAudience() then
        WndBattleHud:updateMySkillCtb()
        WndBattleHud:updateMyItemCtb()
    end
end

function BattleCtbManager:initCTB()
	WZLog("BattleCtbManager:initCTB")
	local list = WBattleGlobal:getCurrent():getCharacterList()
	local cNum = #list

    local isTeach = WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 10101 or WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 10102 or WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 10103 or WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 10104
    local isFirstTeach = WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999
	for id, combat in pairs (list) do
        local min = 0.5 * combat.m_nLucky / (combat.m_nLucky + 2000) * 10000
        local max = combat.m_nLucky / (combat.m_nLucky + 2000) * 10000
		local ctb = math.random(min, max)
        if isTeach == true then
            ctb = min
        end
        if isFirstTeach then
            --ctb = max
            if combat:getBattleId() == -2 then
            	ctb = 2566.6666666667
            else
            	ctb = 99.009900990099
            end
        end
        combat.m_nNowCTB = ctb
        WZLog("BattleCtbManager:initCTB one", id, ctb, combat.m_nLucky, combat.m_nNowCTB, cNum, min, max)
	end

end

function BattleCtbManager:sortCTB()
	WZLog("BattleCtbManager:sortCTB")
	local charaList = {}
	local list = WBattleGlobal:getCurrent():getCharacterList()
	if WBattleGlobal:getCurrent():isFlyCopy() then
		list = WBattleGlobal:getCurrent():getHeroList()
	end
	local minCTBTime = 999999999
	for id, combat in pairs (list) do
		if combat.m_bIsInCtb then
			table.insert(charaList, combat)
			local nowCtb = combat.m_nNowCTB > 10000 and 10000 or combat.m_nNowCTB

			local time = ((10000 - nowCtb) / combat:getCTBSpeed()) * 1000
	        time = time + combat:getFreezeCTB()
	        local mimTime = math.ceil(time)
            if not combat:isDead() and combat.m_bLoseNet ~= true and mimTime < minCTBTime then
	        	minCTBTime = mimTime
	        	WZLog("BattleCtbManager:sortCTB one", combat:getBattleId(), combat:getHp(), nowCtb, minCTBTime, combat:getCTBSpeed())
	        end
    	end
	end

	BattleCtbManager.m_nMinCTBTime = minCTBTime
	local mimCTB = minCTBTime

	for id, combat in pairs (charaList) do
        if combat.m_bIsInCtb then
            local nowCtb = combat.m_nNowCTB
            combat.m_nOldCTB = nowCtb
            combat.revertBuffTime = mimCTB
            if combat:getFreezeCTB() >= mimCTB then
                combat.m_nFreezeCTB = combat:getFreezeCTB() - mimCTB
                WZLog("BattleCtbManager:sortCTB two")
            else
                local mimTime = minCTBTime - math.ceil(combat:getFreezeCTB())
                local addCTB = (mimTime * combat:getCTBSpeed()) / 1000
                combat.m_nNowCTB = nowCtb + addCTB
                combat.m_nFreezeCTB = 0
                WZLog("BattleCtbManager:sortCTB three", combat:getBattleId(), combat:getHp(), combat.m_nNowCTB, combat:getBattleId(), mimTime, addCTB, combat:getCTBSpeed())
            end
        end
	end

	self:_updateCopyCtb()

	Teach:bubbleSort(charaList, "m_nNowCTB")

	BattleCtbManager.m_tCharaList = {}
	BattleCtbManager.m_tCharaCtbOldList = {}
	BattleCtbManager.m_tCharaCtbNewList = {}

	for id, combat in pairs (list) do
		if not combat.m_bIsInCtb then
			table.insert(charaList, combat)
			combat.m_nOldCTB = 0
			combat.m_nNowCTB = 0
		end
	end

	for id, combat in ipairs (charaList) do
		table.insert(BattleCtbManager.m_tCharaList, combat:getBattleId())
		table.insert(BattleCtbManager.m_tCharaCtbOldList, combat.m_nOldCTB)
		table.insert(BattleCtbManager.m_tCharaCtbNewList, combat.m_nNowCTB)
	end
	WZLog("BattleCtbManager:sortCTB four",Serialize(BattleCtbManager.m_tCharaList),Serialize(BattleCtbManager.m_tCharaCtbOldList),Serialize(BattleCtbManager.m_tCharaCtbNewList))
end

--@brief	转换CTB值为秒数（目前用于冷却时间显示）
function BattleCtbManager:convertCtbToTime(nCtb)
    local time = nCtb
    --WZLog("BattleCtbManager:convertCtbToTime",time)
	return time
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化Manager
function BattleCtbManager:_init()
	WZLog("BattleCtbManager:_init")
	self.m_tWndBattleHud = nil

	self.m_tabBattleCtb = nil
    self.m_tabBattleCtb2 = nil

	self.m_tabBigBattleCtb = nil

	self.m_nTabCtbNumber = 0
	self.m_nTabCtbNumber1 = 0
	self.m_nTabCtbNumber2 = 0

	self.m_nBigTabCtbNumber = 0

	self.m_tCellBattleCtb = {}

	self.m_tBigCellBattleCtb = {}

	self.m_tUpdateCtbValue = {}

	self.m_bIsShowCtb = true

    self.m_tBg = nil

    self.SHOOT_CTB = GDatatab_skill["id_"..1001].consume
    self.PASS_CTB = GDatatab_skill["id_"..1002].consume
end


--@brief	设置当前CTB的Cell数量
function BattleCtbManager:_setCtbNumber(nNum,addOrReduce,playerId)


	self.m_nTabCtbNumber = nNum
	if WBattleGlobal:getCurrent():isMyTeam(playerId) then
        WZLog("BattleCtbManager:_setCtbNumber 1")
		if addOrReduce == true then
			self.m_nTabCtbNumber1 = self.m_nTabCtbNumber1 + 1
		else
			self.m_nTabCtbNumber1 = self.m_nTabCtbNumber1 - 1
		end

	else
        WZLog("BattleCtbManager:_setCtbNumber 2")
		if addOrReduce == true then
			self.m_nTabCtbNumber2 = self.m_nTabCtbNumber2 + 1
		else
			self.m_nTabCtbNumber2 = self.m_nTabCtbNumber2 - 1
		end

	end
    self:_adjustTab()
    self:_adjustTab2()

end

--@brief 特殊副本ctb处理
function BattleCtbManager:_updateCopyCtb()
	--[[
	if WBattleGlobal:getCurrent():isExpCopy() then
		if self.m_bIsHeroRoundNext then
			self.m_bIsHeroRoundNext = false
			for id, combat in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
		        if id == 1 then
		        	combat.m_nOldCTB = 9000
		        	combat.m_nNowCTB = 10000
		        else
		        	combat.m_nOldCTB = 8000
		        	combat.m_nNowCTB = 9000
		        end
			end
			WZLog("BattleCtbManager:_updateCopyCtb hero")
		else
			self.m_bIsHeroRoundNext = true
			for id, combat in pairs (WBattleGlobal:getCurrent():getCharacterList()) do
		        if id == 1 then
		        	combat.m_nOldCTB = 8000
		        	combat.m_nNowCTB = 9000
		        else
		        	combat.m_nOldCTB = 9000
		        	combat.m_nNowCTB = 10000
		        end
			end
			WZLog("BattleCtbManager:_updateCopyCtb boss")
		end
	end
	--]]
end

--@brief	调整CTB的TableContainer的大小(cell数量改变后要调用)
function BattleCtbManager:_adjustTab()
    if self.m_nTabCtbNumber1 <= 0 then
        return
    end

	local parent = GetElement(self.m_tWndBattleHud , "conUIBattleCtb_WndBattleHud" , WZUIContainer)
	local CELL_WIDTH = 238
	local CELL_HEIGHT = 46
	local CELL_DIS = 0
	local WIDTH_DIS = 0
    local HEIGHT_DIS = 12

    if self.m_nTabCtbNumber1 >= 6 then
        CELL_HEIGHT = 47
    elseif self.m_nTabCtbNumber1 >= 4 then
        CELL_HEIGHT = 44
    else
        CELL_HEIGHT = 40
    end

	local WIDTH , HEIGHT = 960,640
	parent:setRelativeSizeLuaTo((CELL_WIDTH + 2 * WIDTH_DIS ) / WIDTH , 1 )

	local oneTabNum = self.m_nTabCtbNumber1
	oneTabNum = oneTabNum < 15 and oneTabNum or 15

	local tabWidth = CELL_WIDTH
	local tabHeight = CELL_HEIGHT * oneTabNum + CELL_DIS * (oneTabNum - 1)

	self.m_tabBattleCtb:setRelativeSizeLuaTo( CELL_WIDTH / (CELL_WIDTH + 2 * WIDTH_DIS ) , tabHeight / HEIGHT )
	self.m_tabBattleCtb:setCellElementHeight( CELL_HEIGHT / tabHeight)
	self.m_tabBattleCtb:setVerticalInterval(CELL_DIS / tabHeight)
	self.m_tabBattleCtb:setRelativePositionLuaTo(WIDTH_DIS / (CELL_WIDTH + 2 * WIDTH_DIS ) -0.12, 0.98 )

    local img = self.m_tWndBattleHud:getChildElement("imgBattleCtbBg_WndBattleHud")
    img:setAnchorPointLuaTo(0,1)
    img:setRelativeSizeLuaTo( (CELL_WIDTH + 2 * WIDTH_DIS ) / WIDTH , (tabHeight + 2 * HEIGHT_DIS) / HEIGHT )
    img:setRelativePositionLuaTo( 0 , 1 )
    img:setVisible(self.m_bIsVisble)
    self:_updateTabPosInGuildBattle(parent,1,false)
    WZLog("BattleCtbManager:_adjustTab one", self.m_nTabCtbNumber1, CELL_HEIGHT, tabHeight / HEIGHT, CELL_HEIGHT / tabHeight)
end

--@brief	调整CTB的TableContainer的大小(cell数量改变后要调用)
function BattleCtbManager:_adjustTab2()
    if self.m_nTabCtbNumber2 <= 0 then
        return
    end

	local parent = GetElement(self.m_tWndBattleHud , "conUIBattleCtb2_WndBattleHud" , WZUIContainer)
	local CELL_WIDTH = 238
	local CELL_HEIGHT = 46
	local CELL_DIS = 0
	local WIDTH_DIS = 0
    local HEIGHT_DIS = 12

    if self.m_nTabCtbNumber2 >= 6 then
        CELL_HEIGHT = 47
    elseif self.m_nTabCtbNumber2 >= 4 then
        CELL_HEIGHT = 44
    else
        CELL_HEIGHT = 40
    end

	local WIDTH , HEIGHT = 960,640
    local heightOffset = self.m_nTabCtbNumber1 * 0.065 + 0.015
	parent:setRelativeSizeLuaTo((CELL_WIDTH + 2 * WIDTH_DIS ) / WIDTH , 1)
    parent:setRelativePositionLuaTo( 0 , 1.015 - heightOffset )

	local oneTabNum = self.m_nTabCtbNumber2
	oneTabNum = oneTabNum < 15 and oneTabNum or 15

	local tabWidth = CELL_WIDTH
	local tabHeight = CELL_HEIGHT * oneTabNum + CELL_DIS * (oneTabNum - 1)

	self.m_tabBattleCtb2:setRelativeSizeLuaTo( CELL_WIDTH / (CELL_WIDTH + 2 * WIDTH_DIS ) , tabHeight / HEIGHT )
	self.m_tabBattleCtb2:setCellElementHeight( CELL_HEIGHT / tabHeight)
	self.m_tabBattleCtb2:setVerticalInterval(CELL_DIS / tabHeight)
	self.m_tabBattleCtb2:setRelativePositionLuaTo(WIDTH_DIS / (CELL_WIDTH + 2 * WIDTH_DIS ) -0.12 , 0.98 )

    local img = self.m_tWndBattleHud:getChildElement("imgBattleCtbBg2_WndBattleHud")
    img:setAnchorPointLuaTo(0,1)
    img:setRelativeSizeLuaTo( (CELL_WIDTH + 2 * WIDTH_DIS ) / WIDTH , (tabHeight + 2 * HEIGHT_DIS) / HEIGHT )
    img:setRelativePositionLuaTo( 0 , 1 - heightOffset )
    img:setVisible(self.m_bIsVisble)

    self:_updateTabPosInGuildBattle(parent,1 - heightOffset,true)

    WZLog("BattleCtbManager:_adjustTab2 one", self.m_nTabCtbNumber2, CELL_HEIGHT, tabHeight / HEIGHT, CELL_HEIGHT / tabHeight)

end

function BattleCtbManager:_isGuildBattle()
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if  WBattleGlobal:getCurrent():isGuildWarStage() then
            return true
        end
    end
    return false
end

function BattleCtbManager:_isGuildTTBatle()
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if  WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_GZ and WBattleGlobal:getCurrent().m_tMakePairOk.schedule == GlobalGame.g_tSchedule.SCHEDULE_GW_3 then
            return true
        end
    end
    return false
end

function BattleCtbManager:_updateTabPosInGuildBattle(parent,startY,isSecondTeam)
	if not self:_isGuildBattle() then
		return
	end
	if not isSecondTeam then
		self.m_tGuildIcon:setRelativePositionLuaTo(0, startY)
		parent:setRelativePositionLuaTo( 0 , startY - 0.035)
	else
		self.m_tGuildIcon2:setRelativePositionLuaTo(0, startY - 0.035)
		parent:setRelativePositionLuaTo( 0 , startY - 0.07)
	end
end

--@brief	调整BigCTB的TableContainer的大小(cell数量改变后要调用)
function BattleCtbManager:_adjustBigTab()
    WZLog("BattleCtbManager:_adjustBigTab")
	local WIDTH , HEIGHT = 960,640
	local CELL_WIDTH = 220
	local CELL_HEIGHT = 58
	local CELL_DIS = 0
	local yScale = 1
	local WIDTH_DIS = 0
	local HEIGHT_DIS = 8

	local parent = GetElement(self.m_tWndBattleHud , "conUIBigBattleCtb_WndBattleHud" , WZUIContainer)
	parent:setRelativeSizeLuaTo((CELL_WIDTH + 2 * WIDTH_DIS ) / WIDTH , 1 )

	local oneTabNum = self.m_nBigTabCtbNumber

	local tabWidth = CELL_WIDTH
	local tabHeight = CELL_HEIGHT * yScale * oneTabNum + CELL_DIS * (oneTabNum - 1)

	self.m_tabBigBattleCtb:setRelativeSizeLuaTo( CELL_WIDTH / (CELL_WIDTH + 2 * WIDTH_DIS ) , tabHeight / HEIGHT )
	self.m_tabBigBattleCtb:setCellElementHeight( CELL_HEIGHT * yScale / tabHeight)
	self.m_tabBigBattleCtb:setVerticalInterval(CELL_DIS / tabHeight)
	self.m_tabBigBattleCtb:setRelativePositionLuaTo(WIDTH_DIS / (CELL_WIDTH + 2 * WIDTH_DIS ) , 0.99 )

	local img = parent:getChildElement("imgBigBattleCtbBg_WndBattleHud")
	if img == nil then
		img = WZUI9Image:create()
		img:setAnchorPointLuaTo(0,1)
		parent:addChild(img,-1)
	end
	img:setRelativeSizeLuaTo( 1 , (tabHeight + 2 * HEIGHT_DIS) / HEIGHT )
	img:setRelativePositionLuaTo( 0 , 1 )
	img:setFile("ui/city/newUI/common_scale9_bg.png")
    img:setVisible(self.m_bIsVisble)
end

function BattleCtbManager:_createGuildIcon(isSecondTeam,guildName,guildName2,teamId,teamId2)
	local parent = GetElement(self.m_tWndBattleHud , "conBattleCtb_WndBattleHud" , WZUIContainer)
	local bgPath = "ui/hero/hero_scale9_zdhongdi.png"
	local iconPath = "ui/community/common_icon_ghzhd.png"
	local color = GlobalMethod:ccc3(255, 255, 255)
	local guildNameTxt = guildName
	local teamIdTxt = teamId
	local bIsShowIcon = self:_isGuildTTBatle()
	if isSecondTeam then
		bgPath = "ui/hero/hero_scale9_zdlandi.png"
		iconPath = "ui/community/common_icon_ghzld.png"
		tabCtb = self.m_tabBattleCtb2
		guildNameTxt = guildName2
		teamIdTxt = teamId2
	end

	local container = WZUIContainer:create()
	container:setShowAll(true)
    container:setUseAbsSize(true)
    container:setAnchorPoint(GlobalMethod:ccp(0,1))
    container:setAbsContentSize(GlobalMethod:CCSize(200,40))
    container:setRelativePosition(GlobalMethod:ccp(0,0.95))
    parent:addChild(container)

	local imgBg = WZUIImage:create()
	imgBg:setUseOriginSize(true)
	imgBg:setScale(0.8)
	imgBg:setAnchorPointLuaTo(1,0.5)
	imgBg:setRelativePositionLuaTo(1,0.5)
	if isSecondTeam then
		imgBg:setFlipX(true)
	end
	imgBg:setFile(bgPath)
	container:addChild(imgBg)

	local icon = WZUIImage:create()
	icon:setUseOriginSize(true)
	icon:setFile(iconPath)
	icon:setScale(0.8)
	icon:setAnchorPointLuaTo(1,0.5)
	icon:setRelativePositionLuaTo(1,0.5)
	container:addChild(icon)
	icon:setVisible(bIsShowIcon)



	local name = WZUILabelTTF:create()
    name:setColor(color)
    name:setFontSize(18)
    name:setText(guildNameTxt)
    name:setBoldFont(true)
    name:setTouchEnable(false)
    name:setEnableStroke(true)
    name:setStrokeSize(4)
    name:setStrokeColor(GlobalMethod:ccc3(62, 34, 8))
    -- name:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    name:setAlignment(kCCTextAlignmentCenter)
    name:setRelativePositionLuaTo(0.4,0.45)
    container:addChild(name)

	local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/common_num_ghdj.png")
    txtAtlasFont:setHeight(24)
    txtAtlasFont:setWidth(16)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPointLuaTo(1, 0.5)
    txtAtlasFont:setRelativePositionLuaTo(0.91,0.5)
    txtAtlasFont:setText(teamIdTxt)
    txtAtlasFont:setScale(0.8)
    container:addChild(txtAtlasFont)
    txtAtlasFont:setVisible(bIsShowIcon)

    return container
end

--@brief	獲取角色的CTB值
--@param	nCharactorId，角色BattleId
--@param	nowCtb，CTB值
--@note		无动画过度
function BattleCtbManager:getCtb(nCharactorId)
	if self.m_tCellBattleCtb[nCharactorId] then
		return self.m_tCellBattleCtb[nCharactorId]:getCtb()
	end
end
-------------------------------------私有方法模块End----------------------------------------
