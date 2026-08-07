--SceneWeddingDailyData.lua
--@brief	SceneWeddingDaily的数据模块
--@date		2014/4/10
--@author	LQK
--@note		每日婚礼模块

SceneWeddingDaily = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneWeddingDaily:_init()
	self.m_root = nil	 	  		  --场景根节点
	self.m_sBridgeGroomName = nil     --新郎名字
	self.m_sBrigeName = nil           --新娘名字
	self.m_nWeddingStartTime = nil    --婚礼时间
	self.m_tData = {} 
	self.m_nWeddingCount = 0          --婚礼列表总算
	self.m_nCurrendLoadCell = 0       --正在加载的婚礼列表
	self.m_nCurrentCellIndex = -1
	self.m_sPlayerName = nil
	self.m_sManName = nil
	self.m_otbconWeddingList = nil
	self.m_fTableCurMaxPsY = nil
	self.m_nLoadListIndex = 0           --当前加载的页数
	self.m_nMarryListCount = nil          --婚礼列表总数
	self.m_nTotalPage = nil
	self.m_nDivorceTime = nil 			--离婚冷却时间戳
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneWeddingDaily:_unInit()
	self.m_root = nil
	self.m_sBridgeGroomName = nil     --新郎名字
	self.m_sBrigeName = nil           --新娘名字
	self.m_nWeddingStartTime = nil    --婚礼时间
	self.m_tData = nil 
	self.m_nWeddingCount = nil
	self.m_nCurrendLoadCell = nil    
	self.m_nCurrentCellIndex = nil
	self.m_sPlayerName = nil
	self.m_sManName = nil
	self.m_otbconWeddingList = nil
	self.m_fTableCurMaxPsY = nil
	self.m_nLoadListIndex = nil
	self.m_nMarryListCount = nil
	self.m_nTotalPage = nil
	self.m_nDivorceTime = nil 			--离婚冷却时间戳
end


--@brief   创建加载框
function SceneWeddingDaily:createLoading()
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneWeddingDaily:closeLoading()
	local nId = self.m_nLoadingCircleId
	if nId ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(nId)
		self.m_nLoadingCircleId = nil 
	end
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneWeddingDaily:createElement()
	local element = WZUISystem:getInstance():createElement("SceneWeddingDaily")
	assert(element, "SceneWeddingDaily create element failed!")
	self:_init()
	return element
end


--@brief	设置新郎，新娘，婚礼时间文本
--@param #1 sBridgeGroom : 新郎名字
--@param #2 sBrige : 新娘名字
--@param #3 nWeddingStartTime : 婚礼时间
function SceneWeddingDaily:setRightUiText(sBridgeGroomName, sBrigeName, nWeddingStartTime)
	self.m_sBridgeGroomName = sBridgeGroomName
	self.m_sBrigeName = sBrigeName
	self.m_nWeddingStartTime = nWeddingStartTime
end

--@brief  婚礼列表排序
function sortWebbingList(a,b)
	if a[3] < b[3] then
		return true
	elseif a[3] == b[3] and a[4] < b[4] then
		return true
	else
		return false
	end
end

-- 婚礼时间>婚礼等级>新婚2人在场>新婚不在场
function sortWebbingByRandom(a,b)
	if a[3] ~= b[3] then
		return a[3] < b[3]
	else
		if a[6] ~= b[6] then
			return a[6] < b[6]
		else
			if a[7] ~= b[7] then
				if a[7] == 2 and b[7] ~= 2 then
					return true
				elseif a[7] ~= 2 and b[7] == 2 then
					return false
				elseif a[7] == 1 and b[7] ~= 1 then
					return true
				elseif a[7] ~= 1 and b[7] == 1 then
					return false
				end
			else

			end
		end
	end
	return false
end

--@brief  婚礼列表排序
function sortWebbingList2(a,b)
	if a[4] < b[4] then
		return true
	else
		return false
	end
end


--@brief	返回婚礼列表（WEDDING_SendWedList = 17）(服务器返回)
function SceneWeddingDaily:SendWedList(weddingHallId, wedStatus, marryType, manName, womanName, startDate, endDate, usePassword, manFaceId, womanFaceId, manId, womanId, womanColour, manColour, womanbodyColour, manbodyColour, womanbodyS, manbodyS, womanHeadS, manHeadS, manServerId, womanServerId, progress, host, guest, divorceTime)
	WZLog("SceneWeddingDaily:SendWedList ")
	self.m_nCurrendLoadCell = 0 
	--取消圆圈的转动效果
	-- self:closeLoading()
	if self:_ifWeddingNumisZeroUi(weddingHallId:size()) then 
		return 
	end
	self.m_sPlayerName = CacheCenter:getPlayerInfo().name
	self.m_nWeddingCount = weddingHallId:size()
	WZLog("m_nWeddingCount = ",self.m_nWeddingCount)
	self.m_nDivorceTime = divorceTime 
	
	self.m_tData = {}
	local tempTList = {}
	local tData = {}
	local tSortIds = {}
	WZLog("weddingHallId:size() = ",weddingHallId:size())
	local outFit = CacheCenter:getGameParam().wedFullDress
	--WZLog("outFit = ",Serialize(outFit))
	outFit = SplitStringWithSeparator(outFit,"#")
	local luxurious = outFit[1]
	local luxury = outFit[2]
	local romantic = outFit[3]

	luxurious,_= SplitItemString(luxurious)
    luxury,_ = SplitItemString(luxury)
    romantic,_= SplitItemString(romantic)
    
    local manBody = nil
    local manHead = nil
    
    local womanBody = nil
    local womanHead = nil

	for var = 0 ,weddingHallId:size()-1 do 
		if marryType:get(var) ==1 then
			for i,v in ipairs(luxurious) do
				local itemInfo = GDatatab_item["id_"..v]
				local sex = itemInfo.sex
				local subType = itemInfo.sub_type
				if subType == 0 then  --头部
					if sex ==0 then --男
						manHead = v
					else
						womanHead = v
					end
				elseif subType==2 then --身部
					if sex ==0 then --男
						manBody=v
					else
						womanBody=v
					end
				end
			end
		elseif marryType:get(var) ==2 then
			for i,v in ipairs(luxury) do
				local itemInfo = GDatatab_item["id_"..v]
				local sex = itemInfo.sex
				local subType = itemInfo.sub_type
				if subType == 0 then  --头部
					if sex ==0 then --男
						manHead = v
					else
						womanHead = v
					end
				elseif subType==2 then --身部
					if sex ==0 then --男
						manBody=v
					else
						womanBody=v
					end
				end
			end
		elseif marryType:get(var) ==3 then
			for i,v in ipairs(romantic) do
				local itemInfo = GDatatab_item["id_"..v]
				local sex = itemInfo.sex
				local subType = itemInfo.sub_type
				if subType == 0 then  --头部
					if sex ==0 then --男
						manHead = v
					else
						womanHead = v
					end
				elseif subType==2 then --身部
					if sex ==0 then --男
						manBody=v
					else
						womanBody=v
					end
				end
			end
		end

		local manFace = manFaceId:get(var)
		local womanFace  = womanFaceId:get(var)

		local wedId =  weddingHallId:get(var)
		local wedStatus = wedStatus:get(var)
		local marryType = marryType:get(var)
		local manName = manName:get(var)
		local womanName = womanName:get(var)
		local startTime = startDate:get(var)
		local endTime = endDate:get(var)
		local usePassword = usePassword:get(var)
		local tempManId = manId:get(var)
		local tempWomanId = womanId:get(var)
		local manHead2 = tonumber(manHead)
		local manBody2 = tonumber(manBody)
		local womanHead2 = tonumber(womanHead)
		local womanBody2 = tonumber(womanBody)
		local manHeadColor = 0
		local womanHeadColor = 0
		local manBodyColor = 0
		local womanBodyColor = 0
		local manServerId = manServerId:get(var)
		local womanServerId = womanServerId:get(var)

		local progress = progress:get(var)
		local host = host:get(var)
		local guest = guest:get(var)

		local mandddd = manHeadS:get(var)
		local womanddd = womanHeadS:get(var)

		local manbodydddd = manbodyS:get(var)
		local womanBodydddd = womanbodyS:get(var)

		if manHead2 == mandddd then
			manHeadColor = manColour:get(var)
		end

		if womanHead2 == womanddd then
			womanHeadColor = womanColour:get(var)
		end

		if manBody2 == manbodydddd then
			manBodyColor = manbodyColour:get(var)
		end

		if womanBody2 == womanBodydddd then
			womanBodyColor = womanbodyColour:get(var)
		end


		if manHead2 ~= nil and manBody2 ~= nil and  womanHead2 ~= nil and womanBody2 ~= nil then
			local webInfo = {wedId =wedId,wedStatus =wedStatus ,marryType = marryType,manName = manName,womanName=womanName,startTime=startTime,endTime=endTime,usePassword=usePassword,manFace=manFace,manHead=manHead2,manBody=manBody2,womanFace =womanFace,womanHead=womanHead2,womanBody=womanBody2,manPlayerId=tempManId,womanPlayerId=tempWomanId,manHeadColor = manHeadColor,womanHeadColor = womanHeadColor,manBodyColor = manBodyColor,womanBodyColor=womanBodyColor, manServerId = manServerId, womanServerId = womanServerId, progress = progress, host = host, guest = guest}
            local webIn = {manName,womanName,startTime,wedId}
            table.insert(tData,webInfo)
            if wedStatus == 1 then --婚礼已开始的，排序为乱序
            	local random = math.random()
            	local temp = {manName,womanName,startTime,wedId,random,marryType,progress,guest}
            	table.insert(tempTList,temp)
            else
            	table.insert(tSortIds,webIn)
            end
		end
	end

    table.sort(tSortIds,sortWebbingList2)
	table.sort(tSortIds,sortWebbingList)
	table.sort(tempTList,sortWebbingByRandom)

	--把人满项的放在后面
	local wedHallPlayerLimit = tonumber(CacheCenter:getGameParam()["wedHallPlayerLimit"])
	local tFullList = {}
	for i=#tempTList,1,-1 do
		if tempTList[i][8] >= wedHallPlayerLimit then
			table.insert(tFullList,1,tempTList[i])
			table.remove(tempTList,i)
		end
	end
	for i=1,#tFullList do
		table.insert(tempTList,tFullList[i])
	end

	for i=#tempTList,1,-1 do
		table.insert(tSortIds,1,tempTList[i])
	end
	
    for i,v1 in ipairs(tSortIds) do
    	for i,v2 in ipairs(tData) do
    		if v2.manName == v1[1] then
    			if v2.manName == self.m_sPlayerName or v2.womanName == self.m_sPlayerName then
    				table.insert(self.m_tData,1,v2)
    			else
    				table.insert(self.m_tData,v2)
    			end
    		end
    	end
    end

    self.m_nLoadListIndex = 0
	self.m_nMarryListCount = #self.m_tData
	self.m_nTotalPage = math.ceil(self.m_nMarryListCount/10)
	self:closeLoading()
end 

--@brief	婚礼数量是0和不是0时的UI界面
function SceneWeddingDaily:_ifWeddingNumisZeroUi(nWedNum)
	WZLog("nWedNum = ",nWedNum)
	--婚礼为0且当前窗口是结婚窗口
	-- if  nWedNum == 0 and WndMarryHoll.m_root ~= nil then 
	-- 	-- MsgBoxManager:showTipBox(LocalStrings.NOT_WEDDING_LIST)
	-- 	return true 
	-- --婚礼为0且当前窗口是本场景
	-- elseif nWedNum == 0  then 
	-- 	local sceneCity = SceneCity:createElement()
	-- 	if sceneCity ~= nil then 
	-- 		replaceScene(sceneCity)
	-- 	end 
	-- 	SceneCity.m_bFromChurch = true
	-- 	--MsgBoxManager:showTipBox(LocalStrings.NOT_WEDDING_LIST)
	-- 	return true 
	-- end 

	-- --其它情况刷新列表
	-- if  nWedNum  ~= 0 then 
		if self.m_root == nil  then 
		    local sceneWeddingDaily = SceneWeddingDaily:createElement()
			if sceneWeddingDaily ~= nil then 
				replaceScene(sceneWeddingDaily)
			end 
		end 
		if self.m_root  ~= nil then 
			GetElement(self.m_root,"btnJoin_SceneWeddingDaily",WZUIButton):setTouchEnable(true)
		end 
		return false 
	-- end 

	-- return false 
end 



--@brief	参加婚礼（WEDDING_JoinWedding = 22）错误处理函数(S->C)(服务器返回)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function SceneWeddingDaily:JoinWeddingErrorProcess(nFlag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end 

--@brieF  参加婚礼错误
--@param result : 1密码错误 2礼堂爆满
function SceneWeddingDaily:JonWeddingError(result)
	if self.m_root ~= nil then
		if result ==1 then
			MsgBoxManager:showTipBox(LocalStrings.PASSWORD_NOT_MATCH)
		elseif result ==2 then
			MsgBoxManager:showTipBox(LocalStrings.WEDDING_FILLED)
		end
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneWeddingDaily:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_mrhl.png",SceneWeddingDaily,SceneWeddingDaily.onCloseClick,true,true,true,"SceneWeddingDaily")
end

-------------------------------------私有方法模块End----------------------------------------
