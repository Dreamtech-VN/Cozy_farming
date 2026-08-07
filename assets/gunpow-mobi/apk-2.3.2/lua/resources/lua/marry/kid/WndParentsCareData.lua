--WndParentsCareData.lua
--@brief	WndParentsCare的数据模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		关爱界面

WndParentsCare = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndParentsCare:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_careCost = nil 				--关爱消耗
	self.m_tKidCellList = nil 				--孩子列表
	self.m_nIndexSel = 1 				--选中的孩子所引
	self.m_nType = nil 					--1：关爱;2：骑马;3：离婚；4：收到伴侣离婚消息; 5:离婚结果
	self.m_tCareConfig = nil 			--关爱配置
	self.m_tPlayCarConfig = nil 			--骑马配置
	self.m_nMateSelKidId = 0 			--伴侣选择抚养的孩子Id

	self.m_tData = nil 
	self.m_nNeedPay = 1 				--离婚是否需要付费0不需要 1需要支付
	self.m_nDivorceCDTime = nil 		--离婚后需要等待多少时间才能再次结婚
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndParentsCare:_unInit()
	self.m_root = nil
	self.m_careCost = nil 				--关爱消耗
	self.m_tKidCellList = nil 				--孩子列表
	self.m_nIndexSel = nil 
	self.m_nType = nil 					--1：关爱;2：骑马
	self.m_tCareConfig = nil 			--关爱配置
	self.m_tPlayCarConfig = nil 			--骑马配置
	self.m_nMateSelKidId = nil 			

	self.m_tData = nil 
	self.m_nNeedPay = nil 
	self.m_nDivorceCDTime = nil 		--离婚后需要等待多少时间才能再次结婚
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndParentsCare:createElement()
	if WndParentsCare.m_root ~= nil then
		WindowManager:removeWindow(WndParentsCare.m_root, WndParentsCare, true)
	end
	local element = WZUISystem:getInstance():createElement("WndParentsCare")
	assert(element, "WndParentsCare create element failed!")
	self:_init()
	return element
end

--@brief 	外部调用接口
function WndParentsCare:showInterface(nType, needPay)
	-- body
	local wndCare = WndParentsCare:createElement()
	self.m_nType = nType
	self.m_nNeedPay = needPay or 1
	WindowManager:addWindow(wndCare, WndParentsCare, nil, nil, nil, true)
end

--@brief 	抚摸或骑马成功后回调
function WndParentsCare:careOrPlayCarSuccess(childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
	-- body
	SceneKidHome:_stopLoading()
	WZLog("WndParentsCare:careOrPlayCarSuccess", childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
	if actionType == 2 then --摇摇车成功
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT70)
		self:closeWindow()
		SceneKidHome:updateKidData(childId, nil, nil, nil, nil, nil, nil, nil, nil, careValue, playCar, nil, nil, nil, touch)
		SceneKidHome:playKidMount(childId, actionType, careValue, nIndexX + 1, nIndexY + 1)
	end
end

--@brief 	获取关爱buff
function WndParentsCare:careBuffSuccess(childId)
	--body
	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT69)
	SceneKidHome.m_nCareBuffToday = 1
	--取消红点
	ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(240)
end

--@brief 	孩子数据变化，同步刷新
function WndParentsCare:updateKidInfoShow(tData, nIndex)
	-- body
	if self.m_root == nil then return end 

	if self.m_tKidCellList[nIndex] then
		self.m_tKidCellList[nIndex]:setData(tData, 2)
	end
end

--@brief 	设置数据
function WndParentsCare:setData(tData, nMateSelKidId, divorceCDTime)
	-- body
	self.m_tData = tData 
	self.m_nMateSelKidId = nMateSelKidId 
	self.m_nDivorceCDTime = divorceCDTime

	self.m_nIndexSel = self:getAutoIndex()
	self:_update()
end

--@brief 	设置骑马扯的数据
function WndParentsCare:setPlayCarData(tData)
	-- body
	self.m_tData = CopyTable(tData)
end

--@brief    收到被离婚数据
function WndParentsCare:receiveDivorceData(fatherDevote, motherDevote, ownerId, childId, sex, childName, headId, faceId, level, otherSelectChildId, childFight, childProp, headEffectId)
    -- body

    local tKidData = {}
    for i = 1, #childId do
        local tItem = {}

        tItem.id = childId[i]
        tItem.name = childName[i]
        tItem.headId = headId[i]
        tItem.faceId = faceId[i]
        tItem.sex = sex[i]
        tItem.level = level[i]
        tItem.fatherDevote = fatherDevote
        tItem.motherDevote = motherDevote
        tItem.ownerId = ownerId[i]
        tItem.fighting = childFight[i]
        tItem.property = childProp[i]
        tItem.headEffectId = headEffectId[i]

        table.insert(tKidData, tItem)
    end
    WZLog("WndParentsCare:receiveDivorceData", Serialize(tKidData))

    WndParentsCare:showInterface(4)
    WndParentsCare:setData(tKidData, otherSelectChildId)
end

--@brief    收到被离婚成功，孩子分配结果
function WndParentsCare:receiveDivorceResult(playerId, playerName, childId, childName, sex, headId, faceId, level, childFight, childProp, headEffectId)
    -- body
    WZLog("WndParentsCare:receiveDivorceResult")
    local tKidData = {}
    for i = 1, #playerId do
        local tItem = {}
        tItem.id = childId[i]
        tItem.name = childName[i]
        tItem.headId = headId[i]
        tItem.faceId = faceId[i]
        tItem.sex = sex[i]
        tItem.level = level[i]
        tItem.playerId = playerId[i]
        tItem.playerName = playerName[i]
        tItem.fighting = childFight[i]
        tItem.property = childProp[i]
        tItem.headEffectId = headEffectId[i]

        if childId[i] > 0 then
        	table.insert(tKidData, tItem)
        end
    end

    WndParentsCare:showInterface(5)
    WndParentsCare:setData(tKidData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@breif 	获取进入界面默认选择
function WndParentsCare:getAutoIndex()
	-- body
	if self.m_nType == 5 then return end 

	if #self.m_tData == 1 then
		if self.m_tData[1].ownerId == CacheCenter:getPlayerInfo().id or self.m_tData[1].ownerId == 0 then
			return 1
		else
			return 3
		end
	else
		if self.m_tData[1].ownerId == CacheCenter:getPlayerInfo().id then
			return 1
		elseif self.m_tData[2].ownerId == CacheCenter:getPlayerInfo().id then
			return 2
		else
			return 1
		end
	end
end

--@brief 	
function WndParentsCare:havedChildAlready()
	-- body
	local bHaved = false 
	for i = 1, #self.m_tData do
		if self.m_tData[i].ownerId == CacheCenter:getPlayerInfo().id then
			bHaved = true
			break 
		end
	end

	return bHaved
end

--@brief 	根据Id获取孩子的数据
function WndParentsCare:getKidDataById()
	-- body
	for i = 1, #self.m_tData do
		if self.m_tData[i].id == self.m_nMateSelKidId then
			return self.m_tData[i]
		end
	end
	return nil 
end
-------------------------------------私有方法模块End----------------------------------------
