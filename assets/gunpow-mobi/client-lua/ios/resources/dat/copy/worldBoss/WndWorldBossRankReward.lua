--WndWorldBossRankReward.lua
--@brief	WndWorldBossRankReward的UI模块
--@date		2015/03/28
--@author	weidong_wu
--@note		世界boss排名奖励界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBossRankReward:onEnter(element)
	self.m_root = element

	ProtocolProcessorSceneWorldBoss:send_WORLDBOSSHALL_GetRewardList()

	self:_createLoading()
	self:_setStaticTxt()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBossRankReward:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndWorldBossRankReward:onEnterTransitionDidFinish(element)
	--弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndWorldBossRankReward:actionCallback(element, data)
    --self.m_root:enableSchedule("scheduleLoadUI", 0)
end

--@brief    弹窗动画完成后的回调
function WndWorldBossRankReward:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , WndWorldBossRankReward , true)
end

--@brief   关闭窗口
function WndWorldBossRankReward:onCloseClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManagerAni:createCloseAction(self.m_root,"actionCallback_close",self)
end

--@breif   对外显示接口
function WndWorldBossRankReward:showInterface()
	local wndRankReward = WndWorldBossRankReward:createElement()
	if wndRankReward ~= nil then 
		WindowManager:addWindow( wndRankReward,WndWorldBossRankReward)
	end 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndWorldBossRankReward:_update(  )
	local flRankRewardList_WndRankReward = GetElement(self.m_root,"flRankRewardList_WndRankReward",WZUIFreeListContainer)
	local listCount = #self.RewardItems
	for i=1,listCount do
		local m_nstartRank = self.startRank[i]
		local endPos = 1
		if self.endRank[1] == -1 then 
			endPos = i + 1
			if i == listCount then 
				endPos = 1
			end 
		end 
		local m_nendRank = self.endRank[endPos]
		local RankNumberString = ""
		if m_nstartRank == m_nendRank then
			RankNumberString = string.format(LocalStrings.RANK_TIPS_1,m_nstartRank)
		elseif not (m_nstartRank == m_nendRank) and m_nendRank == -1 then 
			RankNumberString = string.format(LocalStrings.RANK_TIPS_2,m_nstartRank)
		else
			RankNumberString = string.format(LocalStrings.RANK_TIPS_3,m_nstartRank,m_nendRank)
		end
		WZLog("WndWorldBossRankReward:_update:"..RankNumberString)
		local m_tItemRewardId,m_tItemRewardNum = SplitItemString(self.RewardItems[i].item[1]) 
		for i=1,#m_tItemRewardId do
			print(m_tItemRewardId[i])
		end
		for i=1,#m_tItemRewardNum do
			print(m_tItemRewardNum[i])
		end
		local element,NewObjLua = CellWorldBossRankRewardItem:createElement()
		flRankRewardList_WndRankReward:pushBack(WZUIContainer:luaTo(element))
		NewObjLua:setMessage(RankNumberString,m_tItemRewardId,m_tItemRewardNum)
		element:setContentSize(GlobalMethod:CCSize(630,130))
		element:setRelativeSize(GlobalMethod:CCSize(1,130/420))
	end
	flRankRewardList_WndRankReward:update()
    flRankRewardList_WndRankReward:getMoveElement():setPositionY(flRankRewardList_WndRankReward:getMinPosition().y)
end

--@brief   创建加载框
function WndWorldBossRankReward:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndWorldBossRankReward:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

function WndWorldBossRankReward:_setStaticTxt(  )
	local txtTips_1_WndWorldBossRankReward = GetElement(self.m_root,"txtTips_1_WndWorldBossRankReward",WZUILabelTTF)
	txtTips_1_WndWorldBossRankReward:setText("世界Boss有丰富的奖励噢!每天19:00不容错过.")
end
-------------------------------------私有方法模块End----------------------------------------
