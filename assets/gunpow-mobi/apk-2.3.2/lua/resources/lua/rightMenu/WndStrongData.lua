--WndStrongData.lua
--@brief	WndStrong的数据模块
--@date		2014/09/10
--@author	zyx
--@note		我i要变强功能模块

WndStrong = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndStrong:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil 				--复选框节点
	self.m_tStrong = nil 				--我要变强数据列表
	self.m_tUpgrade = nil 				--我要升级数据列表	
	self.m_tMoney = nil 				--我要赚钱数据列表
	self.m_backFun = nil 
	self.m_nMainUIId = nil 
	-- self.m_nTitleOpenNum = nil --标题开启的个数
	self.m_sPageItemContainer = nil
	self.m_nConStrongNoviceAnswer = nil --新手答题界面
	self.m_tTabAnswer = {} --新手答题低、中、高
	self.m_nAnswerType = nil --点击答题的类型
	self.m_sAnswerChooseList = {} --答题选择的位置
	self.m_tGetTopicList = {} --获取题目的内容信息
	self.m_tRewardItem = {} --答题奖励的内容
	self.m_tBtnSunmitStatus = nil

	self.m_tBeStrong = {} 
	self.m_tToGetGold = {} 
	self.m_tToGetEquie = {} 
	self.m_tBeUpgrade = {} 
	self.m_tToGetDiamond = {} 
	self.m_tPetBeStrong = {} 
	self.m_tToEat = {} 
	self.m_tOpenForecast = {}
	
	self.m_nTempIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndStrong:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tStrong = nil
	self.m_tUpgrade = nil 
	self.m_tMoney = nil 
	self.m_backFun = nil 
	self.m_nMainUIId = nil 
	-- self.m_nTitleOpenNum = nil
	self.m_sPageItemContainer = nil
	self.m_nConStrongNoviceAnswer = nil
	self.m_tTabAnswer = {}
	self.m_nAnswerType = nil
	self.m_sAnswerChooseList = {}
	self.m_tGetTopicList = {}
	self.m_tRewardItem = {}
	self.m_tBtnSunmitStatus = nil

	self.m_tBeStrong = nil 
	self.m_tToGetGold = nil 
	self.m_tToGetEquie = nil 
	self.m_tBeUpgrade = nil 
	self.m_tToGetDiamond = nil 
	self.m_tPetBeStrong = nil 
	self.m_tToEat = nil
	self.m_tOpenForecast = nil

	self.m_nTempIndex = nil
end

CellStrongItem = {}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndStrong:createElement()
	local element = WZUISystem:getInstance():createElement("WndStrong")
	assert(element, "WndStrong create element failed!")
	self:_init()
	return element
end

--@brief	获取本地数据
function WndStrong:getStrongList()
	local nPlayerLevel = CacheCenter:getPlayerInfo().level 
	for i,v in pairs (GDatatab_button_info) do
		if v.modular ~= 0 then
			local nModularNum = #v.modular[1]
			local tModular = v.modular[1]
			for j = 1, nModularNum do
				local tData = {}
				tData.level = v.open_level
				tData.content = v.name
				tData.link = v.link
				if j == 1 then
					tData.explain = v.explain1
				elseif j == 2 then
					tData.explain = v.explain2
				elseif j == 3 then
					tData.explain = v.explain3
				elseif j == 4 then
					tData.explain = v.explain4
				end
				tData.modular = tModular[j]
				tData.star = type(v.star) == "table" and v.star[1][j] or 0
				local tIcon = SplitStringWithSeparator(v.iocn,",")
				tData.iocn = tIcon[j]

				if (nPlayerLevel >= v.open_level or tData.modular == 9) and v.open_level ~= 999 then 
					if tData.modular == 1 then 
						table.insert(self.m_tBeStrong,tData)
					elseif tData.modular == 2 then 
						table.insert(self.m_tToGetGold,tData)
					elseif tData.modular == 3 then 
						table.insert(self.m_tToGetEquie,tData)
					elseif tData.modular == 4 then 
						table.insert(self.m_tBeUpgrade,tData)
					elseif tData.modular == 5 then
						table.insert(self.m_tToGetDiamond,tData)
					elseif tData.modular == 6 then 
						table.insert(self.m_tPetBeStrong,tData)
					elseif tData.modular == 7 then 
						table.insert(self.m_tToEat,tData)
					elseif tData.modular == 9 then 
						table.insert(self.m_tOpenForecast,tData)
					end 
				end
			end
		end
	end

	table.sort(self.m_tOpenForecast,function(a,b)
		local nPlayerLevel = CacheCenter:getPlayerInfo().level
		if nPlayerLevel >= a.level and nPlayerLevel < b.level  then
			return false
		elseif nPlayerLevel < a.level and nPlayerLevel >= b.level  then
			return true
		else
			return a.level < b.level
		end
	end)

	self.m_nCurIndex = self.m_nTempIndex or (#self.m_tOpenForecast > 0 and 9 or 1)	--9为"功能预告",如果有"功能预告"就默认选中,否者默认选中"要变强"
	self.m_nTitleCurIndex = self.m_nCurIndex

	-- self.m_nCurIndex = 1
	--self:_updateWindow()
	-- self.m_nTitleOpenNum = self:_IsOpenTabButton()
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellStrongItem:createElement()
	local tNewObj = self:_new()

	local element = WZUIContainer:create()
	element:setName("__CellStrongItem")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(740,118))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	开始加载
function CellStrongItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellStrongItem_WndStrong")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:_update(celElement)
end

--@brief 	设置数据
function CellStrongItem:setData(nLevel, sTaskName, sTaskRemark, nStarNum, tIcon, nTag)
	-- body
	self.nLevel = nLevel
	self.sTaskName = sTaskName
	self.sTaskRemark = sTaskRemark 
	self.nStarNum = nStarNum
	self.tIcon = tIcon 
	self.nTag = nTag 
end

function CellStrongItem:onGotoClick(element)
	--body
	WndStrong:onGotoClick(element)
end

function CellStrongItem:_update(celElement)
	-- body
	WZLog("CellStrongItem:_update", self.nTag)
	WndStrong:_setIconAndTaskName(celElement, self.nLevel, self.sTaskName, self.sTaskRemark, self.nStarNum, self.tIcon, self.nTag)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellStrongItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

CellStrongTitle = {}
function CellStrongTitle:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTitleIndex = 1 ----顺序数(也可以是点击位置回调)
	self.m_nTitleCurIndex = 1 --初始化会用到
	self.m_sTitleName = "" --标题名字
	self.m_sNameLabel = nil
	self.m_sTitleNormal = nil
	self.m_sTitleSelect = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellStrongTitle:_unInit()
	self.m_root = nil
	self.m_nTitleIndex = 1 
	self.m_nTitleCurIndex = 1 
	self.m_sTitleName = ""
	self.m_sNameLabel = nil
	self.m_sTitleNormal = nil
	self.m_sTitleSelect = nil
end
--@brief	创建控件
function CellStrongTitle:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(190,56))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
--@brief 	开始加载
function CellStrongTitle:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellStrongTitle")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:_titleUpdate()
end
--
function CellStrongTitle:setInitTitleMessage(index, curindex)
	self.m_nTitleIndex = index or 1
	self.m_nTitleCurIndex = curindex or 1
	self.m_sTitleName = LocalStrings.BeStrongBtnNameArrays[index] or ""
end

--回调函数
function CellStrongTitle:titleCallBackFunc(callback)
	self.callback = callback
end
function CellStrongTitle:onTitleTouchClick()
    if self.callback then
        self.callback(self.m_nTitleIndex)
    end
end
--======= 私有函数 ===============
--@return	新建的表实例对象
function CellStrongTitle:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--更新
function CellStrongTitle:_titleUpdate()
	self.m_sNameLabel = GetElement(self.m_root,"title_name",WZUILabelTTF)
	self.m_sNameLabel:setText(self.m_sTitleName)
	if  ProjConfig.LANGUAGE == "vn" then
		self.m_sNameLabel:setScale(0.8)
		self.m_sNameLabel:setDimensions(GlobalMethod:CCSize(100))
	end
	self.m_sTitleNormal = GetElement(self.m_root,"title_normal",WZUIContainer)
	self.m_sTitleSelect = GetElement(self.m_root,"title_select",WZUIContainer)
	self.m_sTitleSelect:setVisible(false)

	self:_touchTabTitle()
end

function CellStrongTitle:_touchTabTitle()
	if self.m_nTitleCurIndex == self.m_nTitleIndex then
		self:_titleSelect()
	else
		self:_titleNormal()
	end
end


function CellStrongTitle:_titleNormal()
	if not self.m_sNameLabel then return end
	self.m_sTitleNormal:setVisible(true)
	self.m_sTitleSelect:setVisible(false)
	self.m_root:setTouchEnable(true)
	self.m_sNameLabel:setColor(GlobalMethod:ccc3(127,70,26))
	self.m_sNameLabel:setEnableStroke(false)
end
function CellStrongTitle:_titleSelect()
	if not self.m_sNameLabel then return end
	self.m_sTitleNormal:setVisible(false)
	self.m_sTitleSelect:setVisible(true)
	self.m_root:setTouchEnable(false)
	self.m_sNameLabel:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_sNameLabel:setEnableStroke(true)
	self.m_sNameLabel:setStrokeSize(4.0)
	self.m_sNameLabel:setStrokeColor(GlobalMethod:ccc3(127,70,26))
end

--==================== 新手答题 start ======================
CellStrongAnswerItem = {}
function CellStrongAnswerItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.titleIndex = nil
	self.m_sAnswerTitle = nil
	self.m_tAnswerOption = nil
	self.m_tAnswerChooseList = {} --答案选择
	self.imgRightIcon = nil
	self.imgErrorIcon = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellStrongAnswerItem:_unInit()
	self.m_root = nil
	self.titleIndex = nil
	self.m_sAnswerTitle = nil
	self.m_tAnswerOption = nil
	self.m_tAnswerChooseList = {}
	self.imgRightIcon = nil
	self.imgErrorIcon = nil
end
--@brief	创建控件
function CellStrongAnswerItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(700,170))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
--@brief 	开始加载
function CellStrongAnswerItem:onLoadData(element)
	self.cellElementItem = WZUISystem:getInstance():createElement("CellAnswerItem")
	self:setVisible(true)
	element:addChild(self.cellElementItem)

	self:_updataAnswerOption()
end
function CellStrongAnswerItem:setVisible(visible)
	if self.cellElementItem then
		self.cellElementItem:setVisible(visible)
	end
end

function CellStrongAnswerItem:initAbswerItemMessage(index, message, thas)
	self.titleIndex = index
 	self.isHasStart = thas.has_start --是否有答过
 	self.isHasStartPos = thas.has_start_pos --答过的位置，为nil是代表没有答过
 	self.itemMessage = message --每一个答题栏的信息
 	self.m_tAnswerChooseList[self.titleIndex] = self.isHasStartPos
end

function CellStrongAnswerItem:_updataAnswerOption()
	if not self.itemMessage then return end
	self.m_sAnswerTitle = GetElement(self.m_root,"AnswerTitle",WZUILabelTTF)
	local str = string.format("%s %d: %s",LocalStrings.TITLE_SUBJECT,self.titleIndex, self.itemMessage.question)
	self.m_sAnswerTitle:setText(str)
	self.m_tAnswerOption = {}
	local tab = {}
	for i=1,4 do
		local temp_tab = {}
		temp_tab.normal = GetElement(self.m_root,"keyNormal_"..i,WZUI9Image)
		temp_tab.normal:setVisible(false)
		temp_tab.select = GetElement(self.m_root,"keySelect_"..i,WZUI9Image)
		temp_tab.select:setVisible(false)
		temp_tab.label = GetElement(self.m_root,"answerLabel_"..i,WZUILabelTTF)
		temp_tab.label:setVisible(false)
		tab[i] = temp_tab
	end
	self.m_tAnswerOption[self.titleIndex] = tab
	local str = self.itemMessage.answer
	local array = SplitStringWithSeparator(str,"|")
	local str_char = {"A","B","C","D"}
	for i,v in ipairs(array) do
		--答过的位置
		if self.isHasStartPos and self.isHasStartPos == i then
			self.m_tAnswerOption[self.titleIndex][i].select:setVisible(true)
		else
			self.m_tAnswerOption[self.titleIndex][i].normal:setVisible(true)
		end
		--判断是否答题的位置正确
		if self.isHasStartPos then
			if self.isHasStartPos == self.itemMessage.correct then
				-- self:_onAnswerRight(self.isHasStartPos)
			end
		end

		self.m_tAnswerOption[self.titleIndex][i].label:setText(str_char[i]..":"..v)
		self.m_tAnswerOption[self.titleIndex][i].label:setVisible(true)
	end
end

function CellStrongAnswerItem:setCallBackFuncAnswer(callback)
	self.callbackAnswer = callback
end
function CellStrongAnswerItem:onTouchAnswerClick(element)
	--少于四个的时候处理
	if not self.m_tAnswerOption[self.titleIndex][element:getTag()].normal:isVisible() then
		return
	end
	--选择错误答案的时候
	local index = tonumber(element:getTag())
	if self.callbackAnswer then
        self.callbackAnswer(self.titleIndex, index)
    end
end
function CellStrongAnswerItem:answerItemSelect(index)
	if self.m_tAnswerOption[self.titleIndex] and self.m_tAnswerOption[self.titleIndex][index]  then
		self.m_tAnswerOption[self.titleIndex][index].normal:setVisible(false)
		self.m_tAnswerOption[self.titleIndex][index].select:setVisible(true)
		-- self:_onAnswerRight(index)
	end
end
function CellStrongAnswerItem:chooseItemError(index)
	if not self.itemMessage then return end
	if index ~= self.itemMessage.correct then
		MsgBoxManager:showTipBox(self.itemMessage.tips)
		return true
	end
	return false
end
--正确的时候
function CellStrongAnswerItem:_onAnswerRight(index)
	if not index then return end
	local imgRightIcon = WZUIImage:create()
	imgRightIcon:setFile("ui/common/common_icon_gou.png")
	imgRightIcon:setAnchorPoint(GlobalMethod:ccp(1,0))
	imgRightIcon:setRelativePosition(GlobalMethod:ccp(1,0))
	imgRightIcon:setUseOriginSize(true)
	self.m_tAnswerOption[self.titleIndex][index].select:addChild(imgRightIcon)
end
--@return	新建的表实例对象
function CellStrongAnswerItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--==================== 新手答题 end ======================