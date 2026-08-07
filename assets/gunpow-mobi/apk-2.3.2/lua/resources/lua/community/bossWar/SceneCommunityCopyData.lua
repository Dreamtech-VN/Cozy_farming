--SceneCommunityCopyData.lua
--@brief	SceneCommunityCopy的数据模块
--@date		2017/02/14
--@author	qixiang
--@note		公会副本主界面

SceneCommunityCopy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityCopy:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_tCommunityCopyInfo = nil
	self.m_tBossInfo = nil
	self.m_elementCurSelcetCopy = nil
	self.m_nCurSelectIndex = nil
	self.m_nGetRewardSelectIndex = nil
	self.isUseTicket = nil 
	self.m_nInspireNum = 1 			--鼓舞字数
	self.m_nAddOncePrice = nil 		--鼓舞一次的价格
	self.m_nSectionBossIndex = 1 	--每一章boss的索引
	self.m_nFightCost = nil 		--挑战消耗活力
	self.m_nLeftInspire = nil 		--剩余鼓舞次数
	self.m_tWeekRewardDone = {} 	--可领取的周伤害奖励
	self.m_bInspireClick = nil 
	self.m_btnStatu = nil 			--显示两个鼓舞按钮
	self.btnStatu = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityCopy:_unInit()
	self.m_root = nil
	self.m_tCommunityCopyInfo = nil
	self.m_tBossInfo = nil
	self.m_elementCurSelcetCopy = nil
	self.m_nCurSelectIndex = nil
	self.m_nGetRewardSelectIndex = nil
	self.isUseTicket = nil 
	self.m_nInspireNum = nil 			--鼓舞字数
	self.m_nAddOncePrice = nil 
	self.m_nSectionBossIndex = nil 	--每一章boss的索引
	self.m_nFightCost = nil 
	self.m_nLeftInspire = nil 
	self.m_tWeekRewardDone = {}
	self.m_bInspireClick = nil 
	self.m_btnStatu = nil 			--显示两个鼓舞按钮
	self.btnStatu = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityCopy:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityCopy")
	assert(element, "SceneCommunityCopy create element failed!")
	self:_init()
	return element
end

function SceneCommunityCopy:show()
	WZLog("SceneCommunityCopy:show")
	SceneCommunity:showInterface("copy")
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function SceneCommunityCopy:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end

--@brief 创建界面
--@param tData.copyId 副本id
function SceneCommunityCopy:setInfoViewData(tData)
	self.m_tData = tData
	self:initView()
end

--@brief 刷新界面
function SceneCommunityCopy:updateInfoViewData(data)
	WZLog("SceneCommunityCopy:updateInfoViewData ")
	if not self.m_root  then
		return
	end
	
	self:closeLoading()
	if self.m_tCommunityCopyInfo == nil then
		self.m_tCommunityCopyInfo = data
		self:_updateView(data)
	else
		self.m_tCommunityCopyInfo = data
		local txtGetTotal = GetElement(self.m_root,"txtGetTotal_SceneCommunityCopy",WZUILabelTTF)
        txtGetTotal:setText(self.m_tCommunityCopyInfo.todayGain)
		local txtGetTotal2 = GetElement(self.m_root,"txtGetTotal2_SceneCommunityCopy",WZUILabelTTF)
        txtGetTotal2:setText(self.m_tCommunityCopyInfo.contribution)
        --更新当前boss的伤害加成
        if self.m_tBossInfo[self.m_nCurSelectIndex][1].section == self.m_tCommunityCopyInfo.sectionId then 
        	local bossIndex = 0
        	for i = 1, #self.m_tBossInfo[self.m_nCurSelectIndex] do
        		if self.m_tBossInfo[self.m_nCurSelectIndex][i].id == self.m_tCommunityCopyInfo.bossId then 
        			bossIndex = i
        			break 
        		end
        	end
        	local conBoss = GetElement(self.m_root,"conBoss" .. bossIndex .. "_SceneCommunityCopy",WZUIContainer)
        	if conBoss then
        		local txtHurtBuffer = GetElement(conBoss,"txtHurtBuffer_SceneCommunityCopy",WZUILabelTTF)
        		local tempStr = string.format(LocalStrings.HURT_BUFFER, self.m_tCommunityCopyInfo.hurtAdd)
	            tempStr = tempStr .. "%"
	            txtHurtBuffer:setText(tempStr)
        	end
        end
        --鼓舞刷新
        if self.m_bInspireClick then
        	self.m_btnStatu = true
	        if self.m_btnStatu then
	        	self:updateBtnStatu()
	        end
	        MsgBoxManager:showTipBox(LocalStrings.WORLD_INSPIRE_ADD_SUCCESS)
	        self.m_bInspireClick = nil
	    end
	end
end


--@brief   创建加载框
function SceneCommunityCopy:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneCommunityCopy:closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end

--@brief  添加顶部导航栏
function SceneCommunityCopy:addTop()
	WZLog("SceneCommunityCopy:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/community/common_icon_ghfb.png",SceneCommunityCopy,SceneCommunityCopy.onCloseClick,true,true,false,"SceneCommunityCopy")
end

--获取伤害奖励成功
function SceneCommunityCopy:getRewrdSuccess(itemId, itemNum)
	WZLog("SceneCommunityCopy:getRewrdSuccess")
	if not self.m_root  then return end
	self:closeLoading()
	if self.m_nGetRewardSelectIndex then
		local conRightButtom = GetElement(self.m_root,"conRightButtom_SceneCommunityCopy",WZUIContainer)
		local imgBox = GetElement(conRightButtom,"imgBox" .. self.m_nGetRewardSelectIndex .. "_SceneCommunityCopy",WZUIImage)
	    local imgRedPoint = GetElement(self.m_root,"imgWRReddot_SceneCommunityCopy",WZUIImage)
	    imgRedPoint:setVisible(false)
	    self.m_tWeekRewardDone[self.m_nGetRewardSelectIndex] = false
	    if self.m_nGetRewardSelectIndex == 1 then
        	imgBox:setFile("ui/common/commom_icon_ylq.png")
    	elseif self.m_nGetRewardSelectIndex == 2 then
    		imgBox:setFile("ui/common/commom_icon_ylq.png")
    	elseif self.m_nGetRewardSelectIndex == 3 then
    		imgBox:setFile("ui/common/commom_icon_ylq.png")
    	end

		for i = 1, 3 do
			if self.m_tWeekRewardDone[i] then 
				imgRedPoint:setVisible(true)
				break 
			end
		end
		--更新上限
		local minLimitHurt = self:getCurHurtLimit()
		local weekHurt = tonumber(self.m_tCommunityCopyInfo.weekHurt)
	    local txtHurtTotal = GetElement(self.m_root,"txtHurtTotal_SceneCommunityCopy",WZUILabelTTF)
	    if weekHurt < 0 then
	        txtHurtTotal:setText("4294967296")
	    else
	        txtHurtTotal:setText(weekHurt .. "/" .. minLimitHurt)
	    end
	end
	self.m_nGetRewardSelectIndex = nil
	WndRewardShow:showById(itemId,itemNum)
	ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo()
end

--@brief 	设置鼓舞排行
function SceneCommunityCopy:setInspireData(playerId, rank, name, faceId, headId, headColor, sex, level, vipLevel, cost, totalCost)
	if self.m_root == nil then return end 

	self.m_tInspireList = {}

	for i=1,#playerId do
		local tempList = {}
		tempList.playerId = playerId[i]
		tempList.rank = rank[i]
		tempList.name = name[i]
		tempList.faceId = faceId[i]
		tempList.headId = headId[i]
		tempList.headColor = headColor[i]
		tempList.sex = sex[i]
		tempList.level = level[i]
		tempList.vipLevel = vipLevel[i]
		tempList.cost = cost[i]
		tempList.percent = string.format("%0.2f", cost[i]/totalCost*100)
		table.insert(self.m_tInspireList,tempList)
	end

	function sortData(a, b) 
		return a.rank < b.rank
	end

	table.sort(self.m_tInspireList, sortData)
	
	WZLog("公会副本鼓舞排名",Serialize(self.m_tInspireList))
	self:showInspireList(self.m_tInspireList)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   是否补充活力值回调
function SceneCommunityCopy:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end

--@brief 	获取当前显示的伤害上限
function SceneCommunityCopy:getCurHurtLimit()
	-- body
	local hurt = GDatatab_guild_boss_hurt_reward["id_3"].hurt
	local level = CacheCenter:getPlayerInfo().level
    -- 等级*等级*(等级+系数)
    local minHurt = level*level*(level+hurt)
	local weekHurt = tonumber(self.m_tCommunityCopyInfo.weekHurt)
	local conRight = GetElement(self.m_root,"conRight_SceneCommunityCopy",WZUIContainer)
    local conRightButtom = GetElement(conRight,"conRightButtom_SceneCommunityCopy",WZUIContainer)

	for i = 1, 3 do
		local imgBox = GetElement(conRightButtom,"imgBox" .. i .. "_SceneCommunityCopy",WZUIImage)
		local imgPath = imgBox:getFile()
		WZLog("SceneCommunityCopy:getCurHurtLimit", imgPath, minHurt)
		if imgPath == "ui/common/common_icon_ywc.png" or imgPath == "ui/common/commom_icon_wdc.png" then 
			local nTempHurt = GDatatab_guild_boss_hurt_reward["id_" .. i].hurt
		    -- 等级*等级*(等级+系数)
		    local nHurt = level*level*(level+nTempHurt)
			if minHurt > nHurt then 
				minHurt = nHurt 
			end
		end
	end

	return minHurt 
end


-------------------------------------私有方法模块End----------------------------------------
