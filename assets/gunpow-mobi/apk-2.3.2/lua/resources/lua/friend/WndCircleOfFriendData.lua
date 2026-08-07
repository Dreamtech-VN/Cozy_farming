--WndCircleOfFriendData.lua
--@brief	WndCircleOfFriend的数据模块
--@date		2020/07/02
--@author	XTX
--@note		朋友圈界面

WndCircleOfFriend = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCircleOfFriend:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPlayerId = nil 
	self.m_tCircleData = nil 
	self.m_sPlayerName = nil 
	self.m_tExtendCircle = {} 
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_nDefaultShowCommentNum = nil 
	self.m_tCellBeingComment = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCircleOfFriend:_unInit()
	self.m_root = nil
	self.m_nPlayerId = nil 
	self.m_tCircleData = nil 
	self.m_sPlayerName = nil 
	self.m_tExtendCircle = nil 
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_nDefaultShowCommentNum = nil 
	self.m_tCellBeingComment = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCircleOfFriend:createElement()
	if WndCircleOfFriend.m_root ~= nil then
		WindowManager:removeWindow(WndCircleOfFriend.m_root, WndCircleOfFriend, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCircleOfFriend")
	assert(element, "WndCircleOfFriend create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function WndCircleOfFriend:showInterface(playerId)
	-- body
	if not CheckButtonOpen(165) then return end 
	
	local wndCircle = WndCircleOfFriend:createElement()
	if wndCircle then 
		self.m_nPlayerId = playerId or 0 
		WindowManager:addWindow(wndCircle, WndCircleOfFriend, false, nil, nil, true)
	end
end

--@brief 	朋友圈数据
function WndCircleOfFriend:setData(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, spacePhoto, spacePhotoNum, likeTotal, hasLike, likeName, commentTotal, commentId, commentMse, cPlayerId, cPlayerName, bPlayerId, bPlayerName, redDotNum, fPlayerId, fPlayerName, headEffectId, qqHallInfo, setTopMark)
	-- body
	self.m_sPlayerName = fPlayerName
	self.m_tCircleData = {}

	local picIndex = 1 
	local likeIndex = 1
	local commentIndex = 1
	for i = 1, #cId do
		local tCircle = {}
		tCircle.id = cId[i]
		tCircle.playerId = playerId[i]
		tCircle.sex = sex[i]
		tCircle.playerName = playerName[i]
		tCircle.vipLevel = vipLevel[i]
		tCircle.headId = headId[i]
		tCircle.faceId = faceId[i]
		tCircle.headColor = headColor[i]
		tCircle.createTime = time[i]
		tCircle.message = message[i]
		tCircle.picStatus = verify[i]
		tCircle.commentState = comment[i] --陌生人是否可以评论：0开启评论 1关闭评论
		tCircle.picNum = spacePhotoNum[i]
		tCircle.headEffectId = headEffectId and headEffectId[i] or 0
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tCircle.qqHallData = json.decode(qqHallInfo[i])
		end
		tCircle.photoUrl = {}
		tCircle.photoStatus = {}
		for k = 1, spacePhotoNum[i] do
			tCircle.photoUrl[k] = spacePhoto[picIndex]
			if tCircle.picStatus == 1 then 
				tCircle.photoStatus[k] = 4
			else
				tCircle.photoStatus[k] = 3
			end

			picIndex = picIndex + 1
		end
		tCircle.goodNum = likeTotal[i]
		tCircle.commentNum = commentTotal[i]
		tCircle.hasLike = hasLike[i]

		--每条朋友圈的点赞数据
		tCircle.goodData = {}
		local goodNameNum = 5
		if tCircle.goodNum < 5 then 
			goodNameNum = tCircle.goodNum
		end
		local tLikeName = {}
		for j = 1, goodNameNum do
			-- tLikeTemp.playerId = like[likeIndex]
			-- tLikeTemp.playerName = likeName[likeIndex]
			-- tLikeTemp.sex = likeSex[likeIndex]
			-- tLikeTemp.vipLevel = likeVip[likeIndex]
			-- tLikeTemp.headId = likeHeadId[likeIndex]
			-- tLikeTemp.faceId = likeFaceId[likeIndex]
			-- tLikeTemp.headColor = likeHeadColor[likeIndex]
			table.insert(tLikeName, likeName[likeIndex])

			likeIndex = likeIndex + 1
		end
		tCircle.goodNameList = tLikeName
		--每条朋友圈的评论数据
		tCircle.commentData = {}
		for j = 1, tCircle.commentNum do
			local tCommentTemp = {}

			tCommentTemp.commentId = commentId[commentIndex]
			tCommentTemp.commentPlayerId = cPlayerId[commentIndex]
			tCommentTemp.commentPlayerName = cPlayerName[commentIndex]
			tCommentTemp.commentMsg = commentMse[commentIndex]
			tCommentTemp.beCommentedPlayerId = bPlayerId[commentIndex]
			tCommentTemp.beCommentedPlayerName = bPlayerName[commentIndex]
			

			table.insert(tCircle.commentData, tCommentTemp)
			commentIndex = commentIndex + 1
		end
		tCircle.setTopMark = setTopMark and setTopMark[i] or 0

		table.insert(self.m_tCircleData, tCircle)
	end
	WZLog("WndCircleOfFriend:setData", Serialize(self.m_tCircleData))
	self:showWin()
end

--@brief 	指定某条朋友圈数据
function WndCircleOfFriend:setSpecifyData(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, spacePhoto, like, likeName, likeSex, likeVip, likeHeadId, likeFaceId, likeHeadColor, commentId, commentMse, cPlayerId, cPlayerName, bPlayerId, bPlayerName)
	-- body
	if self.m_root == nil then 
		local wndCircle = WndCircleOfFriend:createElement()
		if wndCircle then 
			self.m_nPlayerId = playerId
			WindowManager:addWindow(wndCircle, WndCircleOfFriend, false, nil, nil, true)
		end
	end
	self.m_tExtendCircle = {}
	self.m_sPlayerName = playerName
	self.m_tCircleData = {}

	local picIndex = 1 
	local likeIndex = 1
	local commentIndex = 1

	local tCircle = {}
	tCircle.id = cId
	tCircle.playerId = playerId
	tCircle.sex = sex
	tCircle.playerName = playerName
	tCircle.vipLevel = vipLevel
	tCircle.headId = headId
	tCircle.faceId = faceId
	tCircle.headColor = headColor
	tCircle.createTime = time
	tCircle.message = message
	tCircle.picStatus = verify
	tCircle.commentState = comment --陌生人是否可以评论：0开启评论 1关闭评论
	tCircle.picNum = #spacePhoto
	tCircle.photoUrl = {}
	for k = 1, #spacePhoto do
		tCircle.photoUrl[k] = spacePhoto[k]
	end
	tCircle.goodNum = #like
	tCircle.commentNum = #commentId

	--每条朋友圈的点赞数据
	tCircle.goodData = {}
	local hasLike = 0 
	local tLikeName = {}
	for j = 1, tCircle.goodNum do
		local tLikeTemp = {}

		tLikeTemp.playerId = like[j]
		tLikeTemp.playerName = likeName[j]
		tLikeTemp.sex = likeSex[j]
		tLikeTemp.vipLevel = likeVip[j]
		tLikeTemp.headId = likeHeadId[j]
		tLikeTemp.faceId = likeFaceId[j]
		tLikeTemp.headColor = likeHeadColor[j]
		if like[j] == CacheCenter:getPlayerInfo().id then 
			hasLike = 1
		end
		if j <= 5 then 
			table.insert(tLikeName, likeName[j])
		end
		table.insert(tCircle.goodData, tLikeTemp)
	end
	tCircle.hasLike = hasLike
	tCircle.goodNameList = tLikeName
	--每条朋友圈的评论数据
	tCircle.commentData = {}
	for j = 1, tCircle.commentNum do
		local tCommentTemp = {}

		tCommentTemp.commentId = commentId[j]
		tCommentTemp.commentPlayerId = cPlayerId[j]
		tCommentTemp.commentPlayerName = cPlayerName[j]
		tCommentTemp.commentMsg = commentMse[j]
		tCommentTemp.beCommentedPlayerId = bPlayerId[j]
		tCommentTemp.beCommentedPlayerName = bPlayerName[j]
		

		table.insert(tCircle.commentData, tCommentTemp)
	end

	table.insert(self.m_tCircleData, tCircle)

	WZLog("WndCircleOfFriend:setSpecifyData", Serialize(self.m_tCircleData))
	self.m_tExtendCircle[tostring(cId)] = true
	self:showWin()
end

--@brief 	1删除心情  2.取消点赞  3.删除评论  4.举报 5.设置心情 6.发布成功  相应处理
function WndCircleOfFriend:dealWithResultByType(oType, cId, param)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndCircleOfFriend:dealWithResultByType", oType)
	if oType == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT18)
		self:deleteCircleOK(oType, cId, param)
	elseif oType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT21)
		self:cancelGiveGoodOK(oType, cId, param)
	elseif oType == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT19)
		self:deleteCommentOK(oType, cId, param)
	elseif oType == 4 then 
		WndCircleReport:reportSuccess()
	elseif oType == 5 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT20)
		self:setCommentStateOK(oType, cId, param)
	end
end

--@brief 	点赞成功回调
function WndCircleOfFriend:giveGoodOK(cId, likeTotal, hasLike, likeName)
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT33)
	local tTempList = self.m_tCircleData
    local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		tTempList[i].hasLike = hasLike
    		tTempList[i].goodNameList = likeName
    		tTempList[i].goodNum = likeTotal

    -- 		local bIsExist = false
    -- 		for k = 1, #tTempList[i].goodData do
    -- 			if tTempList[i].goodData[k].playerId == like then 
    -- 				bIsExist = true
    -- 				break 
    -- 			end
    -- 		end
    -- 		if not bIsExist then 

	   --  		local tLikeTemp = {}

				-- tLikeTemp.playerId = like
				-- tLikeTemp.playerName = likeName
				-- tLikeTemp.sex = likeSex
				-- tLikeTemp.vipLevel = likeVip
				-- tLikeTemp.headId = likeHeadId
				-- tLikeTemp.faceId = likeFaceId
				-- tLikeTemp.headColor = likeHeadColor

				-- table.insert(tTempList[i].goodData, tLikeTemp)
	   --  		tTempList[i].goodNum = tTempList[i].goodNum + 1
			    --更新相应的圈的点赞数据
				local tNewObj, pos = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
				end
				--点赞成功，刷新点赞玩家名字数据
				if tTempList[i].goodNum > 1 then 
					local tCell = self:getHeartTotalObjByIdAndType(cId, 1)
					if tCell then 
						tCell:updateData(tTempList[i])
					end
				else
					local celElement, tCell = CellCircleComment:createElement()
	                if celElement and tCell then 
	                    celElement = WZUIContainer:luaTo(celElement)
	                    tCell:setData(tTempList[i], 1)

	                    flTempList:insert(pos, celElement)
	                end
				end

			-- 	break 
			-- end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	取消点赞成功回调
function WndCircleOfFriend:cancelGiveGoodOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList = self.m_tCircleData
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
			if tTempList[i].hasLike then 
				tTempList[i].goodNum = tTempList[i].goodNum - 1
				tTempList[i].hasLike = 0
				--移除玩家的名字
				for k = 1, #tTempList[i].goodNameList do
					if tTempList[i].goodNameList[k] == CacheCenter:getPlayerInfo().name then 
						table.remove(tTempList[i].goodNameList, k)
						break 
					end
				end
				--更新相应的圈的点赞数据
				local tNewObj = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
				end
				--点赞数为0时候，移除点赞玩家Cell
				if tTempList[i].goodNum <= 0 then 
					self:deleteHeartTotalObjByIdAndType(cId, 1)
				else
					local tCell = self:getHeartTotalObjByIdAndType(cId, 1)
					if tCell then 
						tCell:updateData(tTempList[i])
					end
				end
				break 
			end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	评论回复成功回调
function WndCircleOfFriend:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	-- body
	if self.m_root == nil then return end 

	if cId == -1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT24)
		return 
	elseif cId == -2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT25)
		return
	end

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT34)
	local tTempList = self.m_tCircleData
    local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	 
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		local bIsExist = false
    		for k = 1, #tTempList[i].commentData do
    			if tTempList[i].commentData[k].commentId == commentId then 
    				bIsExist = true
    				break 
    			end
    		end
    		if not bIsExist then 
	    		local tCommentTemp = {}

				tCommentTemp.commentId = commentId
				tCommentTemp.commentPlayerId = cPlayerId
				tCommentTemp.commentPlayerName = cPlayerName
				tCommentTemp.commentMsg = commentMse
				tCommentTemp.beCommentedPlayerId = bPlayerId
				tCommentTemp.beCommentedPlayerName = bPlayerName
				

				table.insert(tTempList[i].commentData, tCommentTemp)
				tTempList[i].commentNum = tTempList[i].commentNum + 1
				--更新相应的圈的评论数据
				local tNewObj, pos = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
					--评论成功后，切换回非评论状态，清掉评论框输入
					if bCommentId == 0 then 
						tNewObj:resetCommentInterface()
					else
						local tCellComment = self:getHeartTotalObjByIdAndType(cId, 2, bCommentId)
						if tCellComment then 
							tCellComment:resetCommentInterface()
						end
					end
				end
				--计算新加的评论的位置，加到该心情的最后
				if tTempList[i].goodNum > 0 then 
					pos = pos + 1
				end
				pos = pos + tTempList[i].commentNum - 1
				--重新设置扩展Cell的数据显示
				local tNewObj3, posLast = self:getHeartTotalObjByIdAndType(cId, 3)
				if tNewObj3 then 
					tNewObj3:updateData_type3(tTempList[i])
				end
				if tTempList[i].commentNum <= self.m_nDefaultShowCommentNum then 
					local celElement, tCell = CellCircleComment:createElement()
                    if celElement and tCell then 
                        celElement = WZUIContainer:luaTo(celElement)
                        tCell:setData(tTempList[i], 2, tCommentTemp)
                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                        
                        flTempList:insert(pos, celElement)
                    end
                else
                	--当添加了当前评论，评论数量>配置值 时候，添加查看更多Cell
                	if self.m_tExtendCircle and self.m_tExtendCircle[tostring(cId)] then 
                		local nCurPage, nTotalPage = tNewObj3:getPage()
                		if nCurPage == nTotalPage then 
	                		local celElement, tCell = CellCircleComment:createElement()
		                    if celElement and tCell then 
		                        celElement = WZUIContainer:luaTo(celElement)
		                        tCell:setData(tTempList[i], 2, tCommentTemp)
		                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
		                        
		                        flTempList:insert(posLast - 1, celElement)
		                    end
		                end
                	else
                		--添加可扩展的Cell, 防止重复添加
                		if tTempList[i].commentNum == self.m_nDefaultShowCommentNum + 1 then
                			local conSize = GlobalMethod:CCSize(920, 30)
			                local celElement, tCell = CellCircleComment:createElement(conSize)
			                if celElement and tCell then 
			                    celElement = WZUIContainer:luaTo(celElement)
			                    tCell:setData(tTempList[i], 3)
			                    tCell:setExtendCallBack(self, self.onShowAllComment, self.onShowLess, self.onChangePage)

			                    flTempList:insert(pos, celElement)
			                end
			            end
                	end
				end

				break 
			end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	删除评论成功回调
function WndCircleOfFriend:deleteCommentOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList = self.m_tCircleData
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		for k = 1, #tTempList[i].commentData do
    			if tTempList[i].commentData[k].commentId == param then 
					table.remove(tTempList[i].commentData, k)
    				tTempList[i].commentNum = tTempList[i].commentNum - 1
    				--更新相应的圈的评论数据
    				local tNewObj = self:getCircleObjById(cId)
    				if tNewObj then 
    					tNewObj:updateCommentData(tTempList[i])
    				end
    				--移除相应的评论
    				self:deleteHeartTotalObjByIdAndType(cId, 2, param)
    				if self.m_tExtendCircle and self.m_tExtendCircle[tostring(cId)] then 
    					--重新设置扩展Cell的数据显示
						local tNewObj3, posLast = self:getHeartTotalObjByIdAndType(cId, 3)
						tNewObj3:updateData_type3(tTempList[i])
						local nCurPage, nTotalPage = tNewObj3:getPage()
						if nCurPage == nTotalPage then 
							if nTotalPage == 1 then 
								if tTempList[i].commentNum == self.m_nDefaultShowCommentNum then 
			    					--移除查看更多的Cell
		    						self:deleteHeartTotalObjByIdAndType(cId, 3)
		    					end
							end
						elseif nCurPage > nTotalPage then --已经将最后一页删除完了
							tNewObj3:setCurPage()
							self:onChangePage(tTempList[i], nTotalPage, nil, nTotalPage)
						else
							--将下一页的第一个添加到当前页最后一个
							local nCommentDataIndex = nCurPage * COMMENT_PERPAGE_NUM
							local tCommentTemp = tTempList[i].commentData[nCommentDataIndex]
							local celElement, tCell = CellCircleComment:createElement()
		                    if celElement and tCell then 
		                        celElement = WZUIContainer:luaTo(celElement)
		                        tCell:setData(tTempList[i], 2, tCommentTemp)
		                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
		                        
		                        flTempList:insert(posLast - 1, celElement)
		                    end
						end
    				else
	    				if tTempList[i].commentNum >= self.m_nDefaultShowCommentNum then 
	    					local tCommentTemp = tTempList[i].commentData[self.m_nDefaultShowCommentNum]

	    					if tCommentTemp then 
	    						local _, pos = self:getHeartTotalObjByIdAndType(cId, 3)
		    					local celElement, tCell = CellCircleComment:createElement()
			                    if celElement and tCell then 
			                        celElement = WZUIContainer:luaTo(celElement)
			                        tCell:setData(tTempList[i], 2, tCommentTemp)
			                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
			                        
			                        flTempList:insert(pos - 1, celElement)
			                    end
			                end
			                if tTempList[i].commentNum == self.m_nDefaultShowCommentNum then 
		    					--移除查看更多的Cell
	    						self:deleteHeartTotalObjByIdAndType(cId, 3)
	    					end
	    				end
	    			end
    				break 
    			end
    		end
    	end
    end
    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	删除心情成功
function WndCircleOfFriend:deleteCircleOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList = self.m_tCircleData
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	
    if tTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
			table.remove(tTempList, i)
			local _, pos = self:getCircleObjById(cId)
			--检测心情往下的COMMENT_PERPAGE_NUM + 4条（评论，点赞，分割线），看看是否属于该朋友圈，属于的话就一并删除
			for k = pos, pos + COMMENT_PERPAGE_NUM + 4 do
				local element = flTempList:getAt(pos-1)   
		        if element then
			        element = WZUIContainer:luaTo(element)
			        local tNewObj = element:getLuaObjectIndex()
			        local id = tNewObj:getCircleId()
			        if id == cId then 
			        	flTempList:removeAt(pos - 1)
			        end
				end
			end
			--移除列表中的心情
			-- self:deleteCircleObjById(cId)
			-- self:deleteCircleLineById(cId)
			--如果列表清空了，更新界面的显示状态
			self:updateInterfaceState(tTempList)
			break 
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	根据圈Id获取相应的圈的tCell
function WndCircleOfFriend:getCircleObjById(circleId)
	-- body
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	

    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleOfFriend" then 
	        local id = tNewObj:getCircleId()
	        if id == circleId then 
	        	return tNewObj, i
	        end
	    end
    end

    return nil 
end

--@brief 	根据圈Id和类型获取相应的tCell
--@param 	nType : 1为点赞Cell
--@param 	commentId : 评论Id
function WndCircleOfFriend:getHeartTotalObjByIdAndType(circleId, nType, commentId)
	-- body
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	
	
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if tNewObj.getCircleIdAndCommentId then 
	        local id, comId = tNewObj:getCircleIdAndCommentId()
	        local circleType = tNewObj:getType()
	        if nType == 1 or nType == 3 then --点赞
		        if id == circleId and circleType == nType then 
		        	return tNewObj, i
		        end
		    elseif nType == 2 then --评论
		    	if id == circleId and circleType == nType and commentId == comId then 
		        	return tNewObj, i
		        end
		    end
	    end
    end

    return nil 
end

--@brief 	根据圈Id和类型删除相应的tCell
--@param 	nType : 1为点赞Cell
--@param 	commentId : 评论Id
function WndCircleOfFriend:deleteHeartTotalObjByIdAndType(circleId, nType, commentId)
	-- body
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	
	
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if tNewObj.getCircleIdAndCommentId then 
	        local id, comId = tNewObj:getCircleIdAndCommentId()
	        local circleType = tNewObj:getType()
	        if nType == 1 or nType == 3 then --点赞
		        if id == circleId and circleType == nType then 
		        	flTempList:removeAt(i - 1)
		        	return i
		        end
		    elseif nType == 2 then --评论
		    	if id == circleId and circleType == nType and commentId == comId then 
		        	flTempList:removeAt(i - 1)
		        	return i
		        end
		    end
	    end
    end

    return nil 
end

--@brief 	根据圈Id删除相应的圈
function WndCircleOfFriend:deleteCircleObjById(circleId)
	-- body
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	

    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleOfFriend" then 
	        local id = tNewObj:getCircleId()
			WZLog("WndCircleOfFriend:deleteCircleObjById ttt", id, circleId)
	        if id == circleId then 
	        	flTempList:removeAt(i - 1)
	        	return 
	        end
	    end
    end

    return nil 
end

--@brief 	根据圈Id删除相应的分割线
function WndCircleOfFriend:deleteCircleLineById(circleId)
	-- body
	local flTempList = GetElement(self.m_root, "flCircleFriend_WndCircleOfFriend", WZUIFreeListContainer)	
	
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleBottomLine" then 
	        local id = tNewObj:getCircleId()
			WZLog("WndCircleOfFriend:deleteCircleLineById ttt", id, circleId)
	        if id == circleId then 
	        	flTempList:removeAt(i - 1)
	        	return 
	        end
	    end
    end

    return nil 
end

--@brief 	移除心情后，判断列表是否为空
function WndCircleOfFriend:updateInterfaceState(tTempList)
	-- body
	local conCircle = GetElement(self.m_root, "conCircle_WndCircleOfFriend", WZUIContainer)
	if tTempList == nil or #tTempList == 0 then 
		ShowPanelNullTip2(conCircle, LocalStrings.FRIENDCIRCLE_TEXT4, nil, 0.9, GlobalMethod:ccp(0.3, 0), nil)
        return 
    end
end

--@brief 	设置心情是否不允许非好友评论状态成功回调
function WndCircleOfFriend:setCommentStateOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList = self.m_tCircleData
	
    if tTempList == nil then return end 

    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		if tTempList[i].commentState == 0 then 
    			tTempList[i].commentState = 1
    		else
    			tTempList[i].commentState = 0
    		end
    	end
    end
end	
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	置顶心情回调
function WndCircleOfFriend:_onCircleSetTopResult(cId)
	for i = 1, #self.m_tCircleData do
		if self.m_tCircleData[i].id == cId then 
			self.m_tCircleData[i].setTopMark = 1
		else
			self.m_tCircleData[i].setTopMark = 0
		end
	end
	table.sort(self.m_tCircleData, function (a, b)
		-- body
		if a.setTopMark ~= b.setTopMark then 
			return a.setTopMark > b.setTopMark
		else
			return a.createTime > b.createTime
		end
	end)
	if WndCheckOther.m_root then 
		WndCheckOther:updateMyCircleOfFriend(self.m_tCircleData[1])
	end
	self:_update()
end




-------------------------------------私有方法模块End----------------------------------------
