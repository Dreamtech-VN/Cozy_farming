--WndSpaceDynamicData.lua
--@brief	WndSpaceDynamic的数据模块
--@date		2020/07/02
--@author	XTX
--@note		玩家信息界面-心情动态

WndSpaceDynamic = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceDynamic:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsStartComment = false 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceDynamic:_unInit()
	self.m_root = nil
	self.m_bIsStartComment = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceDynamic:createElement()
	if WndSpaceDynamic.m_root ~= nil then
		WindowManager:removeWindow(WndSpaceDynamic.m_root, WndSpaceDynamic, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSpaceDynamic")
	assert(element, "WndSpaceDynamic create element failed!")
	self:_init()
	return element
end

--@brief	保存照片数据
function WndSpaceDynamic:setData(tData)
	if self.m_root == nil then return end 

	self.m_tData = {}
	self.m_tData.circleId = tData.circleId
	self.m_tData.message = tData.message
	self.m_tData.goodNum = tData.goodNum
	self.m_tData.commentNum = tData.commentNum
	self.m_tData.time = tData.time
	self.m_tData.giveGoodMark = tData.giveGoodMark
	self.m_tData.commentState = tData.commentState
	self.m_tData.photoStatus = {}
	self.m_tData.photoUrl = tData.photoUrl
	for i = 1, #tData.photoUrl do
		if tData.verify == 1 then 
			self.m_tData.photoStatus[i] = 4
		else
			self.m_tData.photoStatus[i] = 3
		end
	end
	WZLog("WndSpaceDynamic:setData", Serialize(self.m_tData))
	self:update()
end

--@brief 	评论回复成功回调
function WndSpaceDynamic:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	-- body
	if self.m_root == nil then return end 

	if cId == self.m_tData.circleId then 
		self.m_tData.commentNum = self.m_tData.commentNum + 1
	end

	self:resetCommentInterface()
	self:updateInfo()
end

--@brief 	点赞成功回调
function WndSpaceDynamic:giveGoodOK(cId, likeTotal, hasLike, likeName)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndSpaceDynamic:giveGoodOK", like, CacheCenter:getPlayerInfo().id)
	if cId == self.m_tData.circleId then 
		self.m_tData.goodNum = likeTotal
		self.m_tData.giveGoodMark = hasLike
	end

	self:updateInfo()
end

--@brief 	取消点赞成功回调
function WndSpaceDynamic:cancelGiveGoodOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	if cId == self.m_tData.circleId then 
		self.m_tData.goodNum = self.m_tData.goodNum - 1
		if self.m_tData.goodNum < 0 then 
			self.m_tData.goodNum = 0
		end
		self.m_tData.giveGoodMark = 0
	end

	self:updateInfo()
end

--@brief 	删除评论成功回调
function WndSpaceDynamic:deleteCommentOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	if cId == self.m_tData.circleId then 
		self.m_tData.commentNum = self.m_tData.commentNum - 1
		if self.m_tData.commentNum < 0 then 
			self.m_tData.commentNum = 0
		end
	end

	self:updateInfo()
end

--@brief 	删除心情成功
function WndSpaceDynamic:deleteCircleOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	if cId == self.m_tData.circleId then 
	--	ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(WndCheckOther.m_nPlayerId)
	end
end

--@brief 	设置心情是否不允许非好友评论状态成功回调
function WndSpaceDynamic:setCommentStateOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	if self.m_tData.circleId == cId then 
		if self.m_tData.commentState == 0 then 
			self.m_tData.commentState = 1
		else
			self.m_tData.commentState = 0
		end
	end
end	
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
