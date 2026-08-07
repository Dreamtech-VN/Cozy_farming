--TeachIdDefine.lua
--@brief    教学引导相关界面ID和界面元素ID定义
--@date     2014/2/17
--@author   叶威
--@note

TeachIdDefine = {
    ------小岛相关------
    TEACH_ISLAND = 100,					                  --100 *10 + 0 *100 
    ISLAND_TASK = 1,                --进入任务按钮        1001
    ISLAND_HALL = 2,                --进入游戏大厅按钮    1002
    ISLAND_BAG = 3,                 --进入背包按钮        1003
    ISLAND_STRENGTHEN = 4,          --进入强化研究院按钮  1004
    ISLAND_BOSSMAP = 5,             --进入副本按钮        1005
    ISLAND_PET = 6,                 --进入宠物按钮        1006

    ------任务相关------
    TEACH_TASK = 101,               --主ID                
    TASK_ROLL = 1,                  --滚动页面
    TASK_CLOSE = 2,                 --关闭按钮
    TASK_GET_REWARD = 3,            --领取奖励按钮

    ------游戏大厅相关----                                --100 *10 + 2 * 100  
    TEACH_HALL = 102,
    HALL_STARTGAME = 1,             --开始游戏按钮        --1201
    HALL_SPORTS_MODE = 2,           --竞技模式按钮        --1202
    HALL_SPORTS_SURE = 3,           --创建房间的确定按钮  --1203
    HALL_SKILL_TOOL = 4,            --技能道具按钮        --1204
    HALL_SKILL_LIST = 5,            --道具列表            --1205
    HALL_SKILL_CLOSE = 6,           --道具列表关闭按钮    --1206
    HALL_READY_GAME = 7,            --准备游戏按钮        --1207
    HALL_SPORTS_SURE2 = 8,          --创建房间的确定按钮  --1208

    -------背包相关--------
    TEACH_BAG = 103,                                      --100 * 10 + 3 * 100 
    BAG_GOODS_LIST = 1,             --物品列表            --1301
    BAG_CLOSE = 2,                  --关闭按钮            --1304


    -----强化研究院相关------
    TEACH_STRENGTHEN = 104,									--100*10 +4 *100
    STRENGTHEN_FUN_ENTER = 1,       --强化功能窗口进入按钮  --1401
    STRENGTHEN_WEAPON_ITEM = 2,     --强化的武器            --1402
    STRENGTHEN_OTHER = 3,           --其他物品栏按钮        --1403
	STRENGTHEN_OTHER_ITEM = 4,      --其他物品栏物品        --1404
    STRENGTHEN_START = 5,           --强化按钮              --1405
    STRENGTHEN_CLOSE = 6,           --强化关闭按钮          --1406

    -----副本冒险相关--------
    TEACH_BOSSMAP = 105,									--100 * 10 + 5 * 100
    BOSSMAP_CHALLENGE = 1,             --挑战关卡按钮       --1501
    BOSSMAP_SIMPLE = 2,                --简单模式按钮       --1502
    BOSSMAP_SURE = 3,                  --挑战确定按钮       --1503

    -----宠物乐园相关--------
    TEACH_PET = 106,                                        --100 * 10 + 6 * 100
    PET_ENTER_CENTER = 1,           --宠物中心培养按钮      --1601
    PET_TRAIN_IN = 2,           	--宠物培养按钮      	--1602
    PET_TRAIN_WAY = 3,              --宠物培训方式   		--1603
    PET_TRAIN_SURE = 4,             --宠物培养按钮          --1604
    PET_TRAIN_SAVE = 5,             --宠物培养保存按钮      --1605
    PET_CLOSE = 6,                  --宠物关闭按钮          --1606
}

--@brief    根据界面的id获取界面元素
--@param    nMainId,界面主id
--@param    nSubId,界面子id
--@return   界面元素
function GetTeachElementById(nMainId, nSubId)
    WZLog("GetTeachElementById", nMainId, nSubId)
    if nMainId == TeachIdDefine.TEACH_ISLAND then
        return GetIslandElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_TASK then
        return GetTaskElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_HALL then
        return GetHallElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_BAG then
        return GetBagElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_STRENGTHEN then
        return GetStrengthenElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_BOSSMAP then
        return GetBossMapElementBySubId(nSubId)
    elseif nMainId == TeachIdDefine.TEACH_PET then
        return GetPetElementBySubId(nSubId)
    end
end

--@brief    根据小岛界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetIslandElementBySubId(nSubId)
    WZLog("GetIslandElementBySubId",nSubId)
    if nSubId == TeachIdDefine.ISLAND_TASK then
        if WndBottomMenu.m_root ~= nil then
            return GetElementWithoutAssert(WndBottomMenu.m_root, "btnTask_WndBottomMenu", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.ISLAND_HALL then
        if SceneIsland.m_root ~= nil then
            return GetElementWithoutAssert(SceneIsland.m_root, "btnHall_SceneIsland", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.ISLAND_BAG then
        if WndBottomMenu.m_root ~= nil then
            return GetElementWithoutAssert(WndBottomMenu.m_root, "btnPlayer_WndBottomMenu", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.ISLAND_STRENGTHEN then
        if SceneIsland.m_root ~= nil then
            return GetElementWithoutAssert(SceneIsland.m_root, "btnStrengthen_SceneIsland", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.ISLAND_BOSSMAP then
        if SceneIsland.m_root ~= nil then
            return GetElementWithoutAssert(SceneIsland.m_root, "btnBossMap_SceneIsland", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.ISLAND_PET then
        if SceneIsland.m_root ~= nil then
            return GetElementWithoutAssert(SceneIsland.m_root, "btnPet_SceneIsland", WZUIButton)
        end
    end
end

--@brief    根据任务界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetTaskElementBySubId(nSubId)
    WZLog("GetTaskElementBySubId", nSubId)
    if nSubId == TeachIdDefine.TASK_ROLL then
        if WndTaskDetail.m_root ~= nil then
            return GetElementWithoutAssert(WndTaskDetail.m_root, "freeconContent_WndTaskDetail", WZUIFreeListContainer)
        end
    elseif nSubId == TeachIdDefine.TASK_CLOSE then
        if WndTask.m_root ~= nil then
            return GetElementWithoutAssert(WndTask.m_root, "btnClose_WndTask", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.TASK_GET_REWARD then
        if WndTaskDetail.m_root ~= nil then
            return GetElementWithoutAssert(WndTaskDetail.m_root, "btnTask_WndTaskDetail", WZUIButton)
        end
    end
end

--@brief    根据游戏大厅界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetHallElementBySubId(nSubId)
    local element = nil

    if nSubId == TeachIdDefine.HALL_STARTGAME then
        if SceneHall.m_root ~= nil then
            element = GetElementWithoutAssert(SceneHall.m_root, "btnStartGame_SceneHall",WZUIButton)
        end
    elseif nSubId == TeachIdDefine.HALL_SPORTS_MODE then
        if WndCreateRoom.m_root ~= nil then
            element = GetElementWithoutAssert(WndCreateRoom.m_root, "selMode1_WndCreateRoom", WZUICheckBox)
        end
    elseif nSubId == TeachIdDefine.HALL_SPORTS_SURE then
        if WndCreateRoom.m_root ~= nil then
            element = GetElementWithoutAssert(WndCreateRoom.m_root, "btnConfirm_WndCreateRoom", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.HALL_SKILL_TOOL then
        if SceneRoom.m_root ~= nil then
            element = GetElementWithoutAssert(SceneRoom.m_root, "btnSkillProp_SceneRoom", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.HALL_SKILL_LIST then
        if WndSkillProp.m_root ~= nil then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "tbconSkillPropList_WndSkillProp", WZUITableContainer)
        end
    elseif nSubId == TeachIdDefine.HALL_SKILL_CLOSE then
        if WndSkillProp.m_root ~= nil then
            element = GetElementWithoutAssert(WndSkillProp.m_root, "btnClose_WndSkillProp", WZUIButton)
        end
    elseif nSubId == TeachIdDefine.HALL_READY_GAME then
        if SceneRoom.m_root ~= nil then
            element = GetElementWithoutAssert(SceneRoom.m_root, "btnReadyGame_SceneRoom", WZUIButton)
        end
    end

    WZLog("GetHallElementBySubId one", nSubId, tostring(element))
    if element ~= nil then
        WZLog("GetHallElementBySubId two", tostring(element:isVisible()))
    end

    if element ~= nil and element:isVisible() ~= true then
        WZLog("GetHallElementBySubId three", tostring(element:isVisible()))
        return nil
    end

    return element
end

--@brief    根据背包界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetBagElementBySubId(nSubId)
    if nSubId == TeachIdDefine.BAG_GOODS_LIST then
        return WndPlayerGoods:getFirstItemElement()
    elseif nSubId == TeachIdDefine.BAG_CLOSE then
        if WndBag.m_root ~= nil then
            return GetElementWithoutAssert(WndBag.m_root, "btnClose_WndBag", WZUIButton)
        end
    end
end
	
--@brief    根据强化研究院界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetStrengthenElementBySubId(nSubId)
	if SceneStrengthen.m_root == nil then
		return
	elseif nSubId == TeachIdDefine.STRENGTHEN_FUN_ENTER then
		local btnEnter = SceneStrengthen.m_root:getChildElement("btnEnterIntensify_SceneStrengthen")
		btnEnter = WZUIButton:luaTo(btnEnter)
		return btnEnter
	else
		if WndIntensify.m_root == nil then
			return
		elseif nSubId == TeachIdDefine.STRENGTHEN_WEAPON_ITEM then
			local btnForClick = WndIntensify.m_playItemWndLuaObj.m_tWeaponTable[1].m_root:getChildElement("btnForClick_CellItem")
			btnForClick = WZUIButton:luaTo(btnForClick)
			return btnForClick
		elseif nSubId == TeachIdDefine.STRENGTHEN_OTHER then
			local checkOthers = WndIntensify.m_playItemWndLuaObj.m_root:getChildElement("checkOthers_PlayerItem")
			checkOthers = WZUICheckBox:luaTo(checkOthers)
			return checkOthers
		elseif nSubId == TeachIdDefine.STRENGTHEN_OTHER_ITEM then
			local _,_,strengthenStoneIndex = WndIntensify:isItemExist(6, 1)
			local btnForClick = WndIntensify.m_playItemWndLuaObj.m_tOthersTable[strengthenStoneIndex].m_root:getChildElement("btnForClick_CellItem")
			btnForClick = WZUIButton:luaTo(btnForClick)
			return btnForClick
		elseif nSubId == TeachIdDefine.STRENGTHEN_START then
			local btnIntensify = WndIntensify.m_root:getChildElement("btnIntensify_WndIntensify")
			btnIntensify = WZUIButton:luaTo(btnIntensify)
			return btnIntensify
		elseif nSubId == TeachIdDefine.STRENGTHEN_CLOSE then
			local btnClose = WndIntensify.m_root:getChildElement("btnClose_WndIntensify")
			btnClose = WZUIButton:luaTo(btnClose)
			return btnClose
		end
	end
end

--@brief    根据副本大厅界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetBossMapElementBySubId(nSubId)
	if SceneBossMap.m_root == nil then		
		return
	elseif nSubId == TeachIdDefine.BOSSMAP_CHALLENGE then	--挑战关卡按钮 1501	
		local btnChallenge = SceneBossMap.m_root:getChildElement("btnChallengeCheckPoint_SceneBossMap")
		btnChallenge = WZUIButton:luaTo(btnChallenge)
		return btnChallenge
	elseif nSubId == TeachIdDefine.BOSSMAP_SIMPLE then	--简单模式按钮 1502
		local checkBoxSimple = SceneBossMap.m_root:getChildElement("checkBoxSimple_WndChallengeLevel")
		checkBoxSimple = WZUICheckBox:luaTo(checkBoxSimple) 
		return checkBoxSimple
	elseif nSubId == TeachIdDefine.BOSSMAP_SURE then	--挑战确定按钮 1503
		local btnSure = SceneBossMap.m_root:getChildElement("btnSure_WndChallengeLevel")
		btnSure = WZUIButton:luaTo(btnSure) 
		return btnSure
	end
end

--@brief    根据宠物界面的子id获取界面元素
--@param    nSubId,界面子id
--@return   界面元素
function GetPetElementBySubId(nSubId)
	if nSubId == TeachIdDefine.PET_ENTER_CENTER then		--宠物中心培养按钮    --1601
		if ScenePet.m_root then
			local btnEnterCenter = ScenePet.m_root:getChildElement("btnEnterCenter_ScenePet")
			btnEnterCenter = WZUIButton:luaTo(btnEnterCenter)
			return btnEnterCenter
		end
	elseif nSubId == TeachIdDefine.PET_TRAIN_IN then		--宠物培养按钮        --1602
		if WndPetCenter.m_root then
			local btnTrain = WndPetCenter.m_root:getChildElement("btnTrain_WndPetCenter")
			btnTrain = WZUIButton:luaTo(btnTrain)
			return btnTrain
		end
	elseif nSubId == TeachIdDefine.PET_TRAIN_WAY then 	--宠物培训方式        --1603
		if WndPetCenter.m_root then
			local selPay = WndPetCenter.m_root:getChildElement("selPay_WndPetCenter")
			selPay = WZUICheckBox:luaTo(selPay)
			return selPay
		end
	elseif nSubId == TeachIdDefine.PET_TRAIN_SURE then			--宠物培养，培养按钮  --1604
		if WndPetCenter.m_root then
			local btnRaise = WndPetCenter.m_root:getChildElement("btnRaise_WndPetCenter")
			btnRaise = WZUIButton:luaTo(btnRaise)
			return btnRaise	
		end
	elseif nSubId == TeachIdDefine.PET_TRAIN_SAVE then	--宠物培养保持按钮    --1605
		if WndPetCenter.m_root then
			local btnSave = WndPetCenter.m_root:getChildElement("btnSave_WndPetCenter")
			btnSave = WZUIButton:luaTo(btnSave)
			return btnSave
		end
	elseif nSubId == TeachIdDefine.PET_CLOSE then			--宠物关闭按钮        --1606
		if WndPetCenter.m_root then
			local btnClose = WndPetCenter.m_root:getChildElement("btnClose_WndPetCenter") -- tbnClose_ScenePet
			btnClose = WZUIButton:luaTo(btnClose)
			return btnClose
		end
	end
end

