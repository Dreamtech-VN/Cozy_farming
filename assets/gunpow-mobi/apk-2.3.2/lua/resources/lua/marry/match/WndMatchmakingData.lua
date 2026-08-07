--WndMatchmakingData.lua
--@brief	WndMatchmaking的数据模块
--@date		2018/06/20
--@author	Tianxiang_Xu
--@note		征婚中心

WndMatchmaking = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMatchmaking:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurSex = nil 				--当前查看的性别
	self.m_nNextCountTime = 3 			--下一批按钮间隔
	self.m_nRegisterState = 0			--登记状态0:未登记；1：已登记
	self.m_nRecommendState = 0 			--推荐状态0：未推荐；1：已推荐
	self.m_tRecommendCost = nil 		--推荐消耗
	self.m_nLoadingId = nil 
	self.m_tPlayerList = nil 			--玩家列表
	self.m_sHeadPath = nil 
	self.m_nRegisterLeftTime = nil 		--登记剩余时间
	self.m_sLastDeclare = "" 			--宣言
	self.m_tMatchConfig = nil 
	self.m_tShowPlayerCell = nil 		--展示的玩家的cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMatchmaking:_unInit()
	self.m_root = nil
	self.m_nCurSex = nil 				--当前查看的性别
	self.m_nNextCountTime = nil 		--下一批按钮间隔
	self.m_nRegisterState = nil			--登记状态
	self.m_nRecommendState = nil 
	self.m_tRecommendCost = nil 		--推荐消耗
	self.m_nLoadingId = nil 
	self.m_tPlayerList = nil 			--玩家列表
	self.m_sHeadPath = nil 
	self.m_nRegisterLeftTime = nil 		--登记剩余时间
	self.m_sLastDeclare = nil 			--宣言
	self.m_tMatchConfig = nil 
	self.m_tShowPlayerCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMatchmaking:createElement()
	if WndMatchmaking.m_root ~= nil then
		WindowManager:removeWindow(WndMatchmaking.m_root, WndMatchmaking, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMatchmaking")
	assert(element, "WndMatchmaking create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param    征婚系统的外部接口
function WndMatchmaking:showInterface()
    --body
    local wndMatch = WndMatchmaking:createElement()
    if wndMatch then
        WindowManager:addWindow(wndMatch, WndMatchmaking)
    end
end

--@brief	获取交友数据成功
function WndMatchmaking:getDataOk(msg, status, lastTime)
	-- body
	self.m_nRegisterLeftTime = lastTime 		--登记剩余时间
	self.m_sLastDeclare = msg 			--宣言
	WZLog("WndMatchmaking:getDataOk", msg, status, lastTime)
	if status then
		self.m_nRecommendState = 1
	end

	if self.m_nRegisterLeftTime > 0 then
    	self.m_nRegisterState = 1
    	self.m_root:enableSchedule("countTime", 1)
    else
    	self.m_nRegisterState = 0
    end

    self:setRegisterBtn()
end

--@brief 	推荐成功
function WndMatchmaking:recommendSuccess(recommend)
	-- body
	self:_stopLoading()
	if recommend then
		MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT10)
		self.m_nRecommendState = 1
		self:updatePlayerRecommendState(true)
	end
end

--@brief 	获取玩家数据列表成功
function WndMatchmaking:setPlayerListData(id, sex, level, name, vipLevel, headId, faceId, headColor, communityName, fighting, declare, headScul, recommend, serverId)
	-- body
	self.m_tPlayerList = {}

	for i = 1, #id do
		local tItem = {}
		tItem.id = id[i]
		tItem.sex = sex[i]
		tItem.level = level[i]
		tItem.name = name[i]
		tItem.vipLevel = vipLevel[i]
		tItem.headId = headId[i]
		tItem.faceId = faceId[i]
		tItem.headColor = headColor[i]
		tItem.communityName = communityName[i]
		tItem.fighting = fighting[i]
		tItem.declare = declare[i]
		tItem.headScul = headScul[i]
		tItem.recommendState = recommend[i]
		tItem.serverId = serverId[i]

		table.insert(self.m_tPlayerList, tItem)
	end

	self:setBtnVisible()
	
	self:_createPlayerList()
end

--@brief 	登记成功
function WndMatchmaking:registerSuccess(result, lastTime, msg)
	-- body
	self:_stopLoading()
	WZLog("WndMatchmaking:registerSuccess", result, lastTime, msg)
	if result == 1 then
		self.m_sLastDeclare = msg
		if self.m_nRegisterState == 0 then
			MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT17)
		else
			MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT22)
		end
		self.m_nRegisterLeftTime = lastTime
		if self.m_nRegisterLeftTime > 0 then
			self.m_nRegisterState = 1
			self:setRegisterBtn()
			self.m_root:enableSchedule("countTime", 1)
		end
	else
		self:displayResult(result)
	end
end

--@brief 	撤销登记成功
function WndMatchmaking:cancelRegisterSuccess()
	-- body
	self:_stopLoading()
	MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT21)
	self.m_nRegisterLeftTime = 0
	self.m_nRegisterState = 0
	self.m_nRecommendState = 0
	self:updatePlayerRecommendState(false)
	self:setRegisterBtn()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndMatchmaking:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndMatchmaking:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	检测列表中是否有玩家自己，如果有，则改变相应的状态
function WndMatchmaking:updatePlayerRecommendState(bRecommendState)
	-- body
	if self.m_tShowPlayerCell == nil or #self.m_tShowPlayerCell == 0 then return end 

	for i = 1, #self.m_tShowPlayerCell do
		local playerId = self.m_tShowPlayerCell[i]:getPlayerId()
		if playerId == CacheCenter:getPlayerInfo().id then
			self.m_tShowPlayerCell[i]:setRecommendState(bRecommendState)
			break
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
