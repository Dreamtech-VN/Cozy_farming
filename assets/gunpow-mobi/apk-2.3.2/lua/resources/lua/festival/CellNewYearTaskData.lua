--CellNewYearTaskData.lua
--@brief	CellNewYearTask的数据模块
--@date		2020/12/01
--@author	hyx
--@note		元旦求签任务

CellNewYearTask = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearTask:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCellCurIndex = nil
	self.m_tCellTitleTab = {}
	self.m_tTabChangeContainer = {}
	self.m_sDesContainer = nil
	self.m_sTouchCurWinFace = nil
	self.m_tTaskDayData = {}
	self.m_tTaskGrowupData = {}
	self.m_sImageDayRedPoint = nil
	self.m_sImageGrowupRedPoint = nil
	self.m_nType = 0 					--0：求签任务；1：射箭任务；2：水之国度-天水任务；3：水之国度-天水理财；4：张灯结彩任务；5：年兽任务；6：新年计划；7:暴揍策划；8：丹道修真；9:欢乐地鼠；10套圈圈；11小岛果园；12咖啡大师；13保龄球；14:夏日西瓜；15：秘境闯塔；16：台无止境；17:疯狂扭蛋；18：深夜食堂 19:全垒打 20:修仙传 21：拜財神 22:葫芦娃 23:春游踏青 24：打气球 25:航海之路 26:爬藤比赛 27:夏日冲浪 28:行星探索 29:欢乐蹦床 30:高尔夫赛事 31:许愿瓶 32:贝克侦探所 33:锣鼓喧天 34:黄金矿工 35:深海寻宝 36:奕仙棋 37:热血投篮 38:秋日露营 39:放风筝 40：投壶 41捕鱼大王 42自行车赛 43抽陀螺 44踢毽子 45魔法课堂 46堆雪人 47钢琴演奏家 48陶艺工坊 49举重比赛 50极地探险 51拼装积木 52铸剑神匠 53泛舟游湖 54吹泡泡 60通用任务类型
	self.m_nActivityId = nil 
	self.m_tTaskOtherData = {}
	self.m_tOtherData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTask:_unInit()
	self.m_root = nil
	self.m_nCellCurIndex = nil
	self.m_tCellTitleTab = {}
	self.m_tTabChangeContainer = {}
	self.m_sDesContainer = nil
	self.m_sTouchCurWinFace = nil
	self.m_tTaskDayData = {}
	self.m_tTaskGrowupData = {}
	self.m_sImageDayRedPoint = nil
	self.m_sImageGrowupRedPoint = nil
	self.m_nType = nil
	self.m_nActivityId = nil 
	self.m_tTaskOtherData = nil 
	self.m_tOtherData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearTask:createElement()
	if CellNewYearTask.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearTask.m_root, CellNewYearTask, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearTask")
	assert(element, "CellNewYearTask create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--[[@param 	otherData :{} 一些配置数据
			otherData.taskCount = 2 --几个任务标签
			otherData.tTaskTypeName = {LocalStrings.PICKTEA_TEXT1[10], LocalStrings.PICKTEA_TEXT1[11]} --任务标签名字
			otherData.taskTitle = LocalStrings.PICKTEA_TEXT1[2] --打开界面，界面标题
			otherData.taskType = 2 --任务类型 1：3种任务，需要用group获取；2：2种任务，用type
			otherData.redPoint = {117108, 127108} --红点-》长线；日常；每天  
			otherData.titleStrokeColor = GlobalMethod:ccc3(0,112,202) --标题描边颜色
			otherData.titleColor = GlobalMethod:ccc3(0,112,202) --标题颜色
			otherData.bEnableStroke = --标题是否需要描边
			otherData.bEnableStroke = --标题是否需要描边
			otherData.img9Bg = 任务背景
			otherData.bgScale = 任务背景缩放
			otherData.bgPos = 任务背景位置
			otherData.isBgUseOrigin = 任务背景是否原图
			otherData.imgBtnClose = 关闭按钮图标
			otherData.btnClosePos = 关闭按钮位置
			otherData.typeIndex = 打开界面获取的任务参数
			otherData.titleList = {LocalStrings.PICKTEA_TEXT1[10], LocalStrings.PICKTEA_TEXT1[11]}任务标题--用于切换不同标签显示不同的标题，不传就是固定标题
			otherData.itemImg9Bg = 任务ItemCell背景
			otherData.itemImg9Title =  任务ItemCell标题背景
]]
function CellNewYearTask:showInterface(nType, activityId, otherData)
	-- body
	local cellTask = CellNewYearTask:createElement()
	if cellTask then 
		self.m_nType = nType or 0
		self.m_nActivityId = activityId
		self.m_tOtherData = otherData
    	WindowManager:addWindow(cellTask, CellNewYearTask, nil, false, nil, true)
    end
end

function CellNewYearTask:setTaskTypeData(id, resetType, status, target, progress, rewardNum, itemId, itemNum)
	if id and next(id) then
		local table_insert = table.insert
		local index = 1
		local day_index = 1
		local growup_index = 1
		for i=1,#id do
			local tab = {}
			tab.id = id[i]
			tab.status = status[i]
			local str = LocalStrings["QIUQIAN_TASK"..id[i]+1]
			tab.desc =  ""
			if str then
				local num = progress[i] .."/".. target[i]
				tab.desc = string.format(str,num)
			end			

			local ids = {}
			local nums = {}
			for n=1, rewardNum[i] do
				table_insert(ids, itemId[index])
				table_insert(nums, itemNum[index])
				index = index + 1
			end
			tab.ids = ids
			tab.nums = nums
			if resetType[i] == 0 then
				self.m_tTaskGrowupData[growup_index] = tab
				growup_index = growup_index + 1
			elseif resetType[i] == 1 then
				self.m_tTaskDayData[day_index] = tab
				day_index = day_index + 1
			end
		end
	end
end

--@brief 	获取射箭任务列表
function CellNewYearTask:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = self:setTaskData(id, status, target, progress, activityId)
		WZLog("CellNewYearTask:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		if taskType == 1 then
			self.m_tTaskGrowupData= tab
			self:_showTaskContent(2)
			self.m_nCellCurIndex = 2
		elseif taskType == 2 then
			self.m_tTaskDayData = tab
			self:_showTaskContent(1)
			self.m_nCellCurIndex = 1
		elseif taskType == -1 then
			if self.m_nType == 18 or self.m_nType == 20 or self.m_nType == 21 or self.m_nType == 22 or self.m_nType == 23 or self.m_nType == 24 or self.m_nType == 25 or self.m_nType == 29 or self.m_nType == 30 or self.m_nType == 31 or self.m_nType == 34 or self.m_nType == 36 or self.m_nType == 39 or self.m_nType == 36 or self.m_nType == 46 or self.m_nType == 47 or self.m_nType == 49 or self.m_nType == 53 or self.m_nType == 54 or self.m_nType == 60 then 
				if taskGroup == 2 then
					self.m_tTaskGrowupData= tab
				elseif taskGroup == 1 then
					self.m_tTaskDayData = tab
				elseif taskGroup == 3 then
					self.m_tTaskOtherData= tab
				end
				self:_showTaskContent(taskGroup)
				self.m_nCellCurIndex = taskGroup
			else
				if taskGroup == 2 or taskGroup == 3 then
					self.m_tTaskGrowupData= tab
					self:_showTaskContent(2)
					self.m_nCellCurIndex = 2
				elseif taskGroup == 1 then
					self.m_tTaskDayData = tab
					self:_showTaskContent(1)
					self.m_nCellCurIndex = 1
				end
			end
		elseif taskType == 3 then 
			self.m_tTaskOtherData= tab
			self:_showTaskContent(3)
			self.m_nCellCurIndex = 3
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置任务数据成功
function CellNewYearTask:setTaskData(id, status, target, progress, activityId)
	local data = {}
	if id and next(id) ~= nil then
		for i = 1, #id do
			local tab = {}
			tab.id = id[i]
			tab.status = status[i] + 1
			tab.target = target[i]
			tab.progress = progress[i]
			tab.desc = ""
			tab.reward = {}
			tab.activityId = activityId
			local config = GDatatab_new_activity_task["id_"..id[i]]
			if config then
				tab.desc = string.format(config.desc, tab.progress .. "/" .. tab.target)
				tab.reward = config.reward
				tab.script = config.script
				tab.type = config.type
				tab.param2 = config.param2
				tab.group_by = config.group_by
			end
			tab.ids = {}
			tab.nums = {}
			for i = 1, #tab.reward do
				table.insert(tab.ids, tab.reward[i][1])
				table.insert(tab.nums, tab.reward[i][2])
			end

			data[i] = tab
		end
	end
	return data
end

-------------------------------------私有方法模块End----------------------------------------
