--WndHVOperateData.lua
--@brief	WndHVOperate的数据模块
--@date		2022/05/16
--@author	XTX
--@note		度假村操作界面

WndHVOperate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVOperate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil 				--好友度假村/访客操作日志数据
	self.m_nTag = nil 
	self.m_nRankState = 0   			--好友度假村状态：0=收起；1=展开
	self.m_tOperateData = nil 			--操作的土坑的数据
	self.m_topCellLua = nil 
	self.m_tLuaTable = nil
	self.m_nTabIndex = 1 				--1=小屋、2=水车
	self.m_tCellUsing = nil 			--当前使用中的
	self.m_tCellOperate = nil 			--当前操作中的
	self.m_nWinType = nil 
	self.m_tLuaTable = nil 
	self.m_tWishConfig = nil 			--许愿配置
	self.m_nLastWishTime = nil 			--上一次许愿时间戳
	self.m_nUseWishTimes = 0 			--今天已经许愿次数
	self.m_tWishReward = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVOperate:_unInit()
	self.m_root = nil
	self.m_tDataList = nil 
	self.m_nTag = nil 
	self.m_nRankState = nil 
	self.m_tOperateData = nil 			--操作的土坑的数据
	self.m_topCellLua = nil 
	self.m_tLuaTable = nil
	self.m_nTabIndex = nil 
	self.m_tCellUsing = nil 			--当前使用中的
	self.m_tCellOperate = nil 			--当前操作中的
	self.m_nWinType = nil 
	self.m_tLuaTable = nil 
	self.m_tWishConfig = nil 			--许愿配置
	self.m_nLastWishTime = nil 			--上一次许愿时间戳
	self.m_nUseWishTimes = nil  
	self.m_tWishReward = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVOperate:createElement()
	if WndHVOperate.m_root ~= nil then
		WndHVOperate.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVOperate")
	assert(element, "WndHVOperate create element failed!")
	self:_init()
	return element
end

--@brief 	设置类型：0度假村；1神树森林
function WndHVOperate:setWinType(nType)
	self.m_nWinType = nType
    if self.m_nWinType == 0 then 
        self.m_tLuaTable = SceneHolidayVillage
    elseif self.m_nWinType == 1 then 
        self.m_tLuaTable = SceneHVTree
    end
end

--@brief 	设置好友度假村数据
function WndHVOperate:setData(synType, playerId, serverId, playerName, playerLevel, headId, faceId, sex, headColor, headEffectId, vipLevel, goodNums, achieId, holidayVillageLvls, canSteal)
	if self.m_root == nil then return end 
	if synType == 0 then 
		self.m_tDataList = {}
		for i=1, #playerId do
			local temp = {}
			temp.rank = i
			temp.playerId = playerId[i]
			temp.serverId = serverId[i]
			temp.name = playerName[i]
			temp.faceId = faceId[i]
			temp.headId = headId[i]
			temp.sex = sex[i]
			temp.level = playerLevel[i]
			temp.headColor = headColor[i]
			temp.headEffectId = headEffectId[i]
			temp.vipLevel = vipLevel[i]
			temp.goodNums = goodNums[i]
			temp.achieId = achieId[i]
			temp.stealState = canSteal[i]

			table.insert(self.m_tDataList, temp)
		end

	--	WZLog("WndHVOperate:setData", Serialize(self.m_tDataList))

		self:showRank() 
	end
end

--@brief 	好友拜访操作日志
--@param 	opType:操作的类型1=偷盗；2=杀虫；
function WndHVOperate:setLogData(time, playerId, serverId, playerName, opType, itemId, itemNum)
	self.m_tDataList = {}
	for i=1, #playerId do
		local temp = {}

		temp.time = time[i]
		temp.playerId = playerId[i]
		temp.serverId = serverId[i]
		temp.name = playerName[i]
		temp.opType = opType[i]
		temp.itemId = itemId[i]
		temp.itemNum = itemNum[i]

		table.insert(self.m_tDataList, temp)
	end

	WZLog("WndHVOperate:setLogData", Serialize(self.m_tDataList))

	self:showRank(4) 
end

--@brief 	根据等级获取升级经验和能量值上限
function WndHVOperate:getMaxExpAndEnergy(level, hvExp)
	local bIsMaxLevel = false 
	local tempData = nil 

	for i, value in pairs(GDatatab_holiday_lvl) do
		if value.level == level then 
			tempData = value 
		end
		if value.level > level and hvExp >= value.exp then 
			bIsMaxLevel = true 
		end
	end

	return tempData, bIsMaxLevel
end

--@brief 	获取鲜花订单
function WndHVOperate:setFlowerOrderList(synType, orderIds, processes, seedNums, status, season)
	if synType == 0 then 
		if orderIds and #orderIds > 0 then 
			local bIsRedDot = false 
			for i = 1, #status do
				if status[i] == 2 then 
					bIsRedDot = true
					break 
				end
			end
			self:_setFlowerOrderBtnVisible(true, bIsRedDot)
		end
	end
end

--@brief 	切换装饰物结果
function WndHVOperate:operateDecorationResult(opType, updateId)
	WZLog("WndHVOperate:operateDecorationResult", opType, updateId)
	if updateId == 0 then 
		if self.m_tCellUsing then 
			self.m_tCellUsing:setWear(false)
		end
	else
		if self.m_tCellUsing then 
			self.m_tCellUsing:setWear(false)
		end
		if self.m_tCellOperate then 
			self.m_tCellOperate:setWear(true)
		end
	end

	SceneHolidayVillage:operateDecorationResult(opType, updateId)

	self:showFrame()
end

--@brief 	显示许愿结果
--@brief 	许愿结果
function WndHVOperate:wishResult(itemId, itemNum, wishingTimes)
	if self.m_root == nil then return end 

	local data = {}
	data.path = "ui/holidayVillage/hd_pic_djcxuyan"
	data.play = "wait"
	data.ccp = GlobalMethod:ccp(0.5, 0.1)
	local spineWish = createEffectSpine(WndHVOperate.m_root, data)
	spineWish:setShowAll(true)
	spineWish:enableSchedule("showWishResult", 1.8)
	self.m_tWishReward = {id = itemId, num = itemNum}
	self:_setWishBtnState(0, wishingTimes[1], wishingTimes[2])
end

function WndHVOperate:showWishResult(element)
	element:disableSchedule()
	element:removeFromParentAndCleanup(true)

	WndRewardShow:showById({self.m_tWishReward.id}, {self.m_tWishReward.num})
	self.m_tWishReward = nil 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
