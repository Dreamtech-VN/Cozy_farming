--WndAthVideoData.lua
--@brief	WndAthVideo的数据模块
--@date		2015-6-13
--@author	binshao
--@note		竞技场录像

WndAthVideo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthVideo:_init()
	self.m_root = nil	 	    -- 场景根节点
	self.data = {}
	self.videoData1 = {}	-- 单打录像
	self.videoData2 = {}	-- 双打录像
	self.videoData3 = {}	-- 三打录像
	self.videoData4 = {}	-- 我的录像
	self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthVideo:_unInit()
	self.m_root = nil
	self.data = nil
	self.videoData1 = nil
	self.videoData2 = nil
	self.videoData3 = nil
	self.videoData4 = nil
	self.loadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthVideo:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthVideo")
	assert(element, "WndAthVideo create element failed!")
	self:_init()
	return element
end

--recordType 记录类型1、1v1，2、2v2，3、3v3，4、个人
function WndAthVideo:setVideoData(playerId, playerName, level, headId, faceId, fight, sex, recordId,recordType,num,headColor)
	local playerId = VectorToTable(playerId)
	local playerName = VectorToTable(playerName)
	local level = VectorToTable(level)
	local headId = VectorToTable(headId)
	local faceId = VectorToTable(faceId)
	local fight = VectorToTable(fight)
	local sex = VectorToTable(sex)
	local recordId = VectorToTable(recordId)
	local recordType = recordType
	local num = VectorToTable(num)
	local headColor = VectorToTable(headColor)
	WZLog("-------------data len------------",#playerId,#sex,#recordId,#num)

	for k, v in pairs(recordId) do
		WZLog("-------------recordId------------",k,v)
	end


	local dataTab = {self.videoData1,self.videoData2,self.videoData3,self.videoData4}
	local teamCnt = #playerId/(recordType*2)
	if recordType == 4 then
		teamCnt = #num
	end

	WZLog("-----------teamCnt----------",teamCnt,recordType)
	for i = 1, teamCnt do
		local data = {}
		data.recordId = recordId[i]
		data.recordType = recordType + 1
		data.fight1 = 0
		data.fight2 = 0
		data.pInfo1 = {}
		data.pInfo2 = {}
		local indexS,indexE = self:getIndexByType(i,recordType,num)
		local mid = (indexE-indexS)/2
		for k = indexS, indexE do
			local info = {}
			info.playerId = playerId[k]
			info.playerName = playerName[k]
			info.level = level[k]
			info.headId = headId[k]
			info.faceId = faceId[k]
			info.headColor = headColor[k]
			info.sex = sex[k]
			if k < mid + indexS then	-- 左边队伍
				data.fight1 = data.fight1 + fight[k]
				table.insert(data.pInfo1,info)
			else	-- 右边队伍
				data.fight2 = data.fight2 + fight[k]
				table.insert(data.pInfo2,info)
			end
		end
		table.insert(dataTab[recordType],data)
	end
	for i = 1, #dataTab do
		WZLog("----------video cnt-----------",#dataTab[i])
	end

	self:updateVideoTab(recordType)
end

-- 根据类型，获取对于的开始和结束的index
function WndAthVideo:getIndexByType(index,recordType,num)
	WZLog("----------getIndexByType1----------",index,recordType)
	local indexS,indexE = 0,0
--	if recordType <= 3 then
--		indexS = (index-1)*recordType*2 + 1
--		indexE = index*recordType*2
--	else
--		local addIndex = 1
--		for i = 1, index-1 do
--			addIndex = addIndex + num[i]
--			WZLog("----------getIndexByType2----------",index-1,num[i])
--		end
--		indexS = addIndex
--		indexE = addIndex + num[index] - 1
--		WZLog("----------getIndexByType3----------",num[index])
--	end

	local addIndex = 1
	for i = 1, index-1 do
		addIndex = addIndex + num[i]
	end
	indexS = addIndex
	indexE = addIndex + num[index] - 1
	WZLog("----------getIndexByType3----------",num[index])


	WZLog("---------get Index----------","indexS = ", indexS,"indexE = ",indexE)
	return indexS,indexE
end


function WndAthVideo:createLoadingBox()
	if not self.loadingId then
		self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
		WZLog("WndAthVideo--------createloadingID",self.loadingId)
	end
end

function WndAthVideo:closeLoadingBox()
	MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
	WZLog("WndAthVideo--------closeloadingID",self.loadingId)
	self.loadingId = nil
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------