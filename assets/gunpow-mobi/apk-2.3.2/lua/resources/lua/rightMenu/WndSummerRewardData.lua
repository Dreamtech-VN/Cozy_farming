--WndSummerRewardData.lua
--@brief	WndSummerReward的数据模块
--@date		2018/01/24
--@author	Tianxiang_Xu
--@note		夏日赏金任务

WndSummerReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSummerReward:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSummerReward:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSummerReward:createElement()
	if WndSummerReward.m_root ~= nil then
		WindowManager:removeWindow(WndSummerReward.m_root, WndSummerReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSummerReward")
	assert(element, "WndSummerReward create element failed!")
	self:_init()
	return element
end

--@brief 	数据
function WndSummerReward:updateMonsterActInfo(configId,killTimes,rewardStatus,score,targetScore,drawStatus,rewardStr)
	-- body
	WZLog("WndSummerReward:updateMonsterActInfo ")
	local GetElement = GetElement
    local conActivityContext3 = GetElement(self.m_root,"conActivity_WndSummerReward",WZUIContainer)
    local txtTotalIntegral = GetElement(conActivityContext3,"txtTotalIntegral_WndSummerReward",WZUILabelTTF)
    txtTotalIntegral:setText(score)

    local tempT = {}
    for i=1,4 do
    	local temp = {}
    	table.insert(temp,configId[i])
    	table.insert(temp,killTimes[i])
    	table.insert(temp,rewardStatus[i])

    	table.insert(tempT,temp)
    end

    table.sort(tempT,function (a,b)
    	-- body
    	local temppA = GDatatab_wanted_monster["id_" .. a[1]]
    	local temppB = GDatatab_wanted_monster["id_" .. b[1]]
    	if temppA.type < temppB.type then
    		return true
    	end
    	return false
    end)

    local tempT2 = {}
    for i=1,3 do
    	local temp = {}
    	table.insert(temp,targetScore[i])
    	table.insert(temp,drawStatus[i])
    	table.insert(temp,rewardStr[i])
    	table.insert(tempT2,temp)
    end

    table.sort(tempT2,function (a,b)
    	-- body
    	if a[1] < b[1] then
    		return true
    	end
    	return false
    end)

    self.m_tSummerMonsterInfo = {}
    self.m_tSummerMonsterInfo.configId = tempT
    self.m_tSummerMonsterInfo.targetScore = tempT2

    local totalScore = tempT2[3][1]
    local pgIntegral = GetElement(conActivityContext3,"pgIntegral_WndSummerReward",WZUIProgress)
    pgIntegral:setPercentage((score/totalScore)*100)
    for i=1,4 do
    	WZLog("WndSummerReward:updateMonsterActInfo iiiii = %d", i)
    	local monsterInfo = tempT[i]
    	local conAct = GetElement(self.m_root,"conAct" .. i .. "_WndSummerReward",WZUIContainer)
    	local txtStats = GetElement(conAct,"txtStats_WndSummerReward",WZUILabelTTF)
    	local imgMonster = GetElement(conAct,"imgMonster_WndSummerReward",WZUIImage)
    	local txtKillCount = GetElement(conAct,"txtKillCount_WndSummerReward",WZUILabelTTF)
    	local txtIntegral = GetElement(conAct,"txtIntegral_WndSummerReward",WZUILabelTTF)
    	local imgPass = GetElement(conAct,"imgPass_WndSummerReward",WZUIImage)
    	imgPass:setVisible(false)
    	local conBtn = GetElement(conAct,"conBtn_WndSummerReward",WZUIContainer)
    	local txtMonsterName = GetElement(conAct,"txtMonsterName_WndSummerReward",WZUILabelTTF)
    	conBtn:setVisible(true)
    	local imgReward1 = GetElement(conAct,"imgReward1_WndSummerReward",WZUIImage)
    	local txtReward1Count = GetElement(conAct,"txtReward1Count_WndSummerReward",WZUILabelTTF)
    	local imgReward2 = GetElement(conAct,"imgReward2_WndSummerReward",WZUIImage)
    	local txtReward2Count = GetElement(conAct,"txtReward2Count_WndSummerReward",WZUILabelTTF)

    	local btnMonsterInfo = GetElement(conAct,"btnMonsterInfo_WndSummerReward",WZUIButton)
    	local imgNormal = GetElement(conBtn,"imgNormal_WndSummerReward",WZUI9Image)
    	local imgSel = GetElement(conBtn,"imgSel_WndSummerReward",WZUI9Image)

    	local dataInfo = GDatatab_wanted_monster["id_" .. monsterInfo[1]]
    	btnMonsterInfo:setTag(dataInfo.id)
    	txtMonsterName:setText(dataInfo.name)

    	local reward = dataInfo.reward
    	local itemInfo1 = GDatatab_item["id_" .. reward[1][1]]
    	local itemInfo2 = GDatatab_item["id_" .. reward[2][1]]

    	imgReward1:setFile(itemInfo1.icon)
    	imgReward2:setFile(itemInfo2.icon)

    	txtReward1Count:setText(reward[1][2])
    	txtReward2Count:setText(reward[2][2])


    	local txt = string.format(LocalStrings.Daily_GOAL1_3,killTimes[i],dataInfo.number)
    	txtKillCount:setText(txt)

    	txtIntegral:setText("(" .. LocalStrings.BOUNTY .. dataInfo.integral .. ")")
    	imgMonster:setFile(dataInfo.image)
    	
    	if monsterInfo[3] == 1 then
    		imgPass:setVisible(false)
    		txtStats:setText(LocalStrings.ACTIVE_BTN_GO)
    		imgNormal:setFile("ui/common/common_btn_anniu3_1.png")
    		imgSel:setFile("ui/common/common_btn_anniu3_1_sel.png")
    		txtStats:setLabelStyleKey("NORMAL_ORANGE_BTN")
    	elseif monsterInfo[3] == 2 then --领取奖励
    		imgPass:setVisible(false)
    		txtStats:setText(LocalStrings.ACTIVE_BTN_GET)
    		imgNormal:setFile("ui/common/common_btn_anniu10_0.png")
    		imgSel:setFile("ui/common/common_btn_anniu10_0_sel.png")
    		txtStats:setLabelStyleKey("NORMAL_GREEN_BTN")
    	else
    		conBtn:setVisible(false)
    		imgPass:setVisible(true)
    	end
    end

    
    self.m_tRewardList = {}
    for i=1,3 do
    	local rewardS = tempT2[i][3]
    	local ids,nums = SplitItemString(rewardS)
    	local rewardList = {}
		rewardList.icon = {}
		rewardList.num = {}
    	for i,v in ipairs(ids) do
    		local itemInfo = GDatatab_item["id_" .. v]
    		table.insert(rewardList.icon,itemInfo.icon)
    		table.insert(rewardList.num,nums[i])
    	end
    	table.insert(self.m_tRewardList,rewardList)
    	local conReward = GetElement(conActivityContext3,"conReward" .. i .. "_WndSummerReward",WZUIContainer)
    	local txtIntegralTarget = GetElement(conReward,"txtIntegralTarget_WndSummerReward",WZUILabelTTF)
    	txtIntegralTarget:setText(tempT2[i][1])

    	conReward:setRelativePosition(GlobalMethod:ccp(tempT2[i][1]/totalScore,-0.2))

    	local armBox = GetElement(conReward,"armBox_WndSummerReward",WZArmature)
    	armBox:setVisible(false)

    	if tempT2[i][2] == 2 and i == 1 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_lan2.png")
    		imgBoxSel:setFile("ui/common/common_icon_lan2.png")
    		armBox:setVisible(true)
    	elseif tempT2[i][2] == 2 and i == 2 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_zi2.png")
    		imgBoxSel:setFile("ui/common/common_icon_zi2.png")
    		armBox:setVisible(true)
    	elseif tempT2[i][2] == 2 and i == 3 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_huang2.png")
    		imgBoxSel:setFile("ui/common/common_icon_huang2.png")
    		armBox:setVisible(true)
    	end

    	if tempT2[i][2] == 3 and i == 1 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_lan3.png")
    		imgBoxSel:setFile("ui/common/common_icon_lan3.png")
    	elseif tempT2[i][2] == 3 and i == 2 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_zi3.png")
    		imgBoxSel:setFile("ui/common/common_icon_zi3.png")
    	elseif tempT2[i][2] == 3 and i == 3 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSummerReward",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSummerReward",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_huang3.png")
    		imgBoxSel:setFile("ui/common/common_icon_huang3.png")
    	end
    end
end

--显示获取到的奖励信息
function WndSummerReward:showGetReward(rewardStr)
	-- body
	WZLog("WndSummerReward:showGetReward ",rewardStr)
	if self.m_root == nil then return end
	if rewardStr ~= "" and rewardStr ~= nil then
		local ids = nil
		local nums = nil
		ids , nums = SplitItemString(rewardStr)
		WndRewardShow:showById(ids,nums)
	end
	if self.m_nGetRewardMonsterId ~= nil or self.m_nGetRewardChestId then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo()
		self.m_nGetRewardChestId = nil
	    self.m_nGetRewardMonsterId = nil
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
