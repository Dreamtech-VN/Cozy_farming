--WndSummerReward.lua
--@brief	WndSummerReward的UI模块
--@date		2018/01/24
--@author	Tianxiang_Xu
--@note		夏日赏金任务


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSummerReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSummerReward:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndSummerReward:onEnterTransitionDidFinish(element)
	-- body
	self:_activityTime()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo()
end

--领取夏日赏金宝箱
function WndSummerReward:onClickByIntegral(element)
	-- body
	WZLog("WndSummerReward:onClickByIntegral")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	-- if GlobalGame.g_autoSummerActivity == 1 then
 --    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
 --    	return
 --    end
	local tag = element:getTag()
	local targetScoreInfo = self.m_tSummerMonsterInfo.targetScore[tag]
	if targetScoreInfo[2]  == 2 then --可以领取奖励
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward(2,targetScoreInfo[1])
		self.m_nGetRewardChestId = true
	else
		local score =  self.m_tSummerMonsterInfo.targetScore[tag][1]
		local itemList = self.m_tRewardList[tag]
		itemList.singleCopy = false
		local desc = string.format(LocalStrings.KILL_REWARD_TIP,score)
		itemList.desc = desc
		itemList.charm = true
		local offset = {x=0,y=-90}
		WndTips:show(element,self.m_root,3,itemList,offset)
	end
end

--夏日赏金
function WndSummerReward:onClickDo(element)
	-- body
	WZLog("WndSummerReward:onClickDo")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	-- if GlobalGame.g_autoSummerActivity == 1 then
 --    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
 --    	return
 --    end
	local tag = element:getTag()
	local parent = element:getParent()
	parent = WZUIContainer:luaTo(parent)
	local txtStats = GetElement(parent,"txtStats_WndSummerReward",WZUILabelTTF)
	local txt = txtStats:getText()
	local monsterId = self.m_tSummerMonsterInfo.configId[tag][1]
	local rewardInfo = GDatatab_wanted_monster["id_" .. monsterId]
	if txt == LocalStrings.ACTIVE_BTN_GO then
		local script = rewardInfo.script
		JumpByUIId(script[1][1] , script[1][2])
	elseif txt == LocalStrings.ACTIVE_BTN_GET then --可领取
		self.m_nGetRewardMonsterId = monsterId
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward(1,monsterId)
	else

	end
end

--查看夏日赏金怪物信息
function WndSummerReward:onClickLook(element)
	-- body
	WZLog("WndSummerReward:onClickLook")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local tag = element:getTag()
	local monsterInfo = GDatatab_wanted_monster["id_" .. tag]
	WndItemInfo:showInfo(element,self.m_root,3,monsterInfo.describe,false,{x=30,y=30})
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	活动时间
function WndSummerReward:_activityTime()
	-- body
	local txtWord = GetElement(self.m_root, "txtWord_WndSummerReward", WZUILabelTTF)
	if txtWord then 
		local activityData = WndApartmentAct:getActivityDataByActivityType(g_tGameActivityTypes.ACTIVITY_SUMMER_REWARD)
		local sStartDate = os.date("*t", activityData.startTime)
        local sEndDate = os.date("*t", activityData.endTime)
        local sTime = string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min)

		txtWord:setText(LocalStrings.ACTIVE_TIME .. ":" .. sTime)
	end
end




-------------------------------------私有方法模块End----------------------------------------
