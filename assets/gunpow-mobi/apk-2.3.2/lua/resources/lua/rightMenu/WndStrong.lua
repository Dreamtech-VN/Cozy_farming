--WndStrong.lua
--@brief	WndStrong的UI模块
--@date		2014/09/10
--@author	zyx
--@note		我i要变强功能模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndStrong:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_BecomeStronger)
	self:register()
	--静态文本显示
	self:getStrongList()
	self:showTitle()
	AdaptLanguage(self)
end
function WndStrong:register()
	GlobalGame:getBattleEventDispatcher():Add("STRONG_NOVICE_ANSWER",self._onNoviceAnswerResult,self)
	GlobalGame:getBattleEventDispatcher():Add("STRONG_SBUMIT_ANSWER",self._onAnswerSubmitResult,self)
end
function WndStrong:unregister()
	GlobalGame:getBattleEventDispatcher():Remove("STRONG_NOVICE_ANSWER",self._onNoviceAnswerResult,self)
	GlobalGame:getBattleEventDispatcher():Remove("STRONG_SBUMIT_ANSWER",self._onAnswerSubmitResult,self)
end

--@brief onEnter函数执行完成回调
function WndStrong:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, false, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndStrong:actionCallback(element, data)
	self.m_root:enableSchedule("scheduleLoadUI", 0)
	AdaptLanguage(self)
end

--@brief    加载界面元素定时器
function WndStrong:scheduleLoadUI()
	self.m_root:disableSchedule()
	self:_updateWindow()--初始化UI界面
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndStrong:onExit(element)
	self:unregister()
	self:_unInit()
	CellStrongTitle:_unInit()
	CellStrongAnswerItem:_unInit()
end

--checkBox 标题栏
function WndStrong:showTitle()
	
	local tTitleNum = {#self.m_tBeStrong,#self.m_tToGetGold,#self.m_tToGetEquie,#self.m_tBeUpgrade,#self.m_tToGetDiamond,#self.m_tPetBeStrong,#self.m_tToEat,1,#self.m_tOpenForecast}
	local tTitleIndex = {}
	for i=1,#tTitleNum do
		if tTitleNum[i] > 0 then
			if i == 9 then
				table.insert(tTitleIndex,1,i)
			else
				table.insert(tTitleIndex,i)
			end
		end
	end

	local titleList = GetElement(self.m_root,"titleScrollview",WZUIFreeListContainer)
    self.t_tLuaObj = {}
	for i = 1, #tTitleIndex do
        local element, tLuaObj = CellStrongTitle:createElement()
        titleList:pushBack(WZUIContainer:luaTo(element))
        tLuaObj:setInitTitleMessage(tTitleIndex[i], self.m_nTitleCurIndex)
        tLuaObj:titleCallBackFunc(function(index) 
        	self:onCellTouched(index) 
        end)
        self.t_tLuaObj[tTitleIndex[i]] = tLuaObj
    end
    titleList:getMoveElement():setPositionY(titleList:getMinPosition().y)
end

function WndStrong:onCellTouched(index)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	index = tonumber(index)
	if index == self.m_nCurIndex then return end

	if self.t_tLuaObj[self.m_nCurIndex] ~= nil then
		self.t_tLuaObj[self.m_nCurIndex]:_titleNormal()
	end
	if self.t_tLuaObj[index] ~= nil then
		self.t_tLuaObj[index]:_titleSelect()
	end

	self.m_nCurIndex = index
	self:_updateWindow()
end

--@brief	外部接口调用
function WndStrong:showInterface(nIndex)
	if self.m_root == nil then
		local strong = WndStrong:createElement()
		self.m_nTempIndex = nIndex
		WindowManager:addWindow(strong, WndStrong, false)
	end
end

--@brief	关闭按钮被按下时调用的函数
--@param	element:关闭按钮的UI节点引用
--@note		在这里做关闭按钮被按下时的响应操作
function WndStrong:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then 
		WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	关闭整个窗口的动画效果
function WndStrong:onCloseActionCallback(elem,data)
	if self.m_nMainUIId == 75 then
		JumpByUIId(self.m_nMainUIId, 0)
	end
    WindowManager:removeWindow(self.m_root , WndStrong , true)
end

--@brief	点击前往按钮回调响应
function WndStrong:onGotoClick(element)
	local tag = element:getTag() + 1
	local MainUIId = 0 
	if self.m_nCurIndex == 1 then 
		MainUIId = self.m_tBeStrong[tag].link
	elseif self.m_nCurIndex == 2 then 
		MainUIId = self.m_tToGetGold[tag].link
	elseif self.m_nCurIndex == 3 then 
		MainUIId = self.m_tToGetEquie[tag].link
	elseif self.m_nCurIndex == 4 then 
		MainUIId = self.m_tBeUpgrade[tag].link
	elseif self.m_nCurIndex == 5 then 
		MainUIId = self.m_tToGetDiamond[tag].link
	elseif self.m_nCurIndex == 6 then 
		MainUIId = self.m_tPetBeStrong[tag].link
	elseif self.m_nCurIndex == 7 then 
		MainUIId = self.m_tToEat[tag].link
	elseif self.m_nCurIndex == 9 then 
		MainUIId = self.m_tOpenForecast[tag].link
	end
	self.m_nMainUIId = MainUIId 
	WZLog("*********** WndStrong:onGotoClick ********", self.m_nCurIndex, self.m_nMainUIId, tag)
	WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
	--Modify By Tianxiang_Xu
	if MainUIId ~= 72 and MainUIId ~= 73 then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	--End Modify
	if self.m_nMainUIId ~= 75 then
		JumpByUIId(self.m_nMainUIId, 0)
	end
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief  更新界面，跳转到不同的界面
function WndStrong:_updateWindow()
	if self.m_nConStrongNoviceAnswer then
		self.m_nConStrongNoviceAnswer:setVisible(false)
	end
	if self.m_nCurIndex == 1 then
		self:_createStrongTable(self.m_tBeStrong)
	elseif self.m_nCurIndex == 2 then 
		self:_createStrongTable(self.m_tToGetGold)
	elseif self.m_nCurIndex == 3 then
		self:_createStrongTable(self.m_tToGetEquie)
	elseif self.m_nCurIndex == 4 then 
		self:_createStrongTable(self.m_tBeUpgrade)
	elseif self.m_nCurIndex == 5 then 
		self:_createStrongTable(self.m_tToGetDiamond)
	elseif self.m_nCurIndex == 6 then 
		self:_createStrongTable(self.m_tPetBeStrong)
	elseif self.m_nCurIndex == 7 then 
		self:_createStrongTable(self.m_tToEat)
	elseif self.m_nCurIndex == 8 then --新手答题
		local titlePageContainer = GetElement(self.m_root,"titlePageContainer",WZUIContainer)
		if not self.m_sPageItemContainer then
			ProtocolProcessorSceneCity:send_PLAYER_GetPlayerAnswerInfo( )
			self.m_sPageItemContainer = true
		end
		if not self.m_nConStrongNoviceAnswer then
			self.m_nConStrongNoviceAnswer = GetElement(self.m_root,"conNoviceAnswer",WZUIContainer)
			self.m_nConStrongNoviceAnswer:setVisible(true)
			self:_initAnswer()
		else
			if self.m_nConStrongNoviceAnswer then
				self.m_nConStrongNoviceAnswer:setVisible(true)
			end
		end
		local tableStrong = titlePageContainer:getChildElement("tableStrong_WndStrong")
		tableStrong = WZUITableContainer:luaTo(tableStrong)
		if tableStrong ~= nil then 
			tableStrong:setVisible(false)
		end
	elseif self.m_nCurIndex == 9 then 
		self:_createStrongTable(self.m_tOpenForecast)
	end
end

--@brief  创建我要变强界面
function WndStrong:_createStrongTable(temp)
	if self.m_root == nil then 
		return
	end

	local tableStrong = self.m_root:getChildElement("tableStrong_WndStrong")
	if tableStrong == nil then 
		WZLog("tableStrong == nil")
		return 
	end
	tableStrong:setVisible(true)
	tableStrong = WZUITableContainer:luaTo(tableStrong)
	tableStrong:cleanTable()
	--创建列表
	local idx = 0
	for i,data in ipairs(temp) do
		if data.level <= CacheCenter.m_tPlayerInfo.level or data.modular == 9 then 
			local element, tNewObj = CellStrongItem:createElement()
			if element == nil or tNewObj == nil then 
				return 
			end
			element = WZUIContainer:luaTo(element)
			element:setTag(idx)
			tNewObj:setData(data.level, data.content, data.explain, data.star, data.iocn, i - 1)
			tableStrong:setCellElement(element)
		
			idx = idx + 1
		end 
	end
	tableStrong:getMoveElement():setPositionY(tableStrong:getMinPosition().y)
end

--======= 新手答题界面 start ===========
function WndStrong:_initAnswer()
	self.answerItemList = GetElement(self.m_nConStrongNoviceAnswer,"answerList",WZUIFreeListContainer)
	self.m_tAnswerItemList = {}
	--获取题目
	local table_insert = table.insert
	local table_sort = table.sort
	for i,v in pairs(GDatatab_answer) do
		if not self.m_tGetTopicList[v.type] then
			self.m_tGetTopicList[v.type] = {}
		end
		if v.type == 1 then
			table_insert(self.m_tGetTopicList[1],v)
		elseif v.type == 2 then
			table_insert(self.m_tGetTopicList[2],v)
		elseif v.type == 3 then
			table_insert(self.m_tGetTopicList[3],v)
		end
	end
	table_sort( self.m_tGetTopicList[1], function(a,b) return a.turn < b.turn end )
	table_sort( self.m_tGetTopicList[2], function(a,b) return a.turn < b.turn end )
	table_sort( self.m_tGetTopicList[3], function(a,b) return a.turn < b.turn end )
	for i=1,3 do
		local tab = {}
		tab.normal = GetElement(self.m_nConStrongNoviceAnswer, "normal_"..i, WZUI9Image)
		tab.select = GetElement(self.m_nConStrongNoviceAnswer, "select_"..i, WZUI9Image)
		tab.select:setVisible(false)
		tab.name = GetElement(self.m_nConStrongNoviceAnswer,"name_"..i,WZUILabelTTF)
		tab.name:setText(LocalStrings.TITLE_SUBJECT_TYPE[i])
		tab.name:setColor(GlobalMethod:ccc3(84,57,44))
		local level = self.m_tGetTopicList[i][1].lv
		if level > CacheCenter:getPlayerInfo().level then
			tab.normal:setGrayRender(true) --置灰
			tab.select:setGrayRender(true)
			tab.name:setColor(GlobalMethod:ccc3(81,81,81))
			tab.normal:setFile("ui/common/common_btn_dt_03.png")
		end
		
		self.m_tTabAnswer[i] = tab
	end
	self.m_nAnswerType = 1
	self.m_tTabAnswer[self.m_nAnswerType].select:setVisible(true)
	self.m_tTabAnswer[self.m_nAnswerType].name:setColor(GlobalMethod:ccc3(144,68,14))
	self.m_tTabAnswer[self.m_nAnswerType].normal:setVisible(false)
	--提交按钮
	self.m_sBtnSubmit = GetElement(self.m_nConStrongNoviceAnswer,"btnSubmit",WZUIButton)
	self.m_sBtnSubmit:setVisible(false)
	self.submitLabel = GetElement(self.m_sBtnSubmit,"submitLabel",WZUILabelTTF)
	self.submitLabel:setEnableStroke(true)
	self.submitLabel:setStrokeSize(4)
end
--拆分奖励
function WndStrong:StrongSplitItemString(s)
	if s == nil then
		return
	end
	local array = SplitStringWithSeparator(s,"|")
	local ids = {}
	local nums = {}
	for i=1,#array do
		ids[i] = {}
		nums[i] = {}
		local array_item = SplitStringWithSeparator(array[i],"&")
		for m=1,#array_item do
			local _string = string.sub(array_item[m],2,-2)
			local id = SplitStringWithSeparator(_string,",")[1]
			local num = SplitStringWithSeparator(_string,",")[2]
			table.insert(ids[i],id)
			table.insert(nums[i],num)
		end
	end
	return ids,nums
end
--初始化item界面
function WndStrong:initCellItemAnswer(tag)
	if not self.m_sAnswerChooseList[tag] then
		self.m_sAnswerChooseList[tag] = {} 
	end

	self:_setAnswerReward(tag)

	self.answerItemList:removeAll()
	self.AnswerItemObj = {}
	for i, v in ipairs(self.m_tGetTopicList[tag]) do
    	local answerElement, tLuaObj = CellStrongAnswerItem:createElement()
        self.answerItemList:pushBack(WZUIContainer:luaTo(answerElement))
        self.answerItemList:getMoveElement():setPositionY(self.answerItemList:getMinPosition().y)

        local tHasStart = {}
        tHasStart.has_start = nil
        tHasStart.has_start_pos = nil
        if self.m_sAnswerChooseList[tag] and self.m_sAnswerChooseList[tag][i] then
        	tHasStart.has_start = true
        	tHasStart.has_start_pos = self.m_sAnswerChooseList[tag][i]
        end
        self.AnswerItemObj[i] = tLuaObj
        tLuaObj:initAbswerItemMessage(i, v, tHasStart)
        tLuaObj:setCallBackFuncAnswer(function(titleindex, titlechoose)
        	self:_onCellTouchAnswerTitleChoose(titleindex, titlechoose)
        end)
    end

    --没有答题或者未答完提交按钮置灰
    if next(self.m_sAnswerChooseList[tag]) == nil then
		self.m_sBtnSubmit:setTouchEnable(false)
		self.submitLabel:setColor(GlobalMethod:ccc3(255,255,255))
		self.submitLabel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	else		
		self:setSubmitStatus(tag)
    end
end
--答题奖励显示
function WndStrong:_setAnswerReward(_type)
	local answer = CacheCenter:getGameParam().answer
	local ids, nums = self:StrongSplitItemString(answer)
	for i,v in pairs(self.m_tRewardItem) do
		if v and v.item then
			v.item:setVisible(false)
		end
	end
	if ids then
		for i=1,#ids[_type] do
			if not self.m_tRewardItem[i] then
				local celElement,tCell = CellGoodItem:createElement()
				self.m_nConStrongNoviceAnswer:addChild(celElement)
				celElement:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
				celElement:setUseAbsCoordinate(true)
				celElement:setScale(0.7)
				celElement:setVisible(false)
				local tab = {}
				tab.item = celElement
				tab.obj = tCell
				self.m_tRewardItem[i] = tab
			end
			if self.m_tBtnSunmitStatus[_type] == 0 then
				self.m_tRewardItem[i].item:setVisible(true)
			end
			self.m_tRewardItem[i].item:setAbsPosition(GlobalMethod:ccp(50+((i-1)*(85*0.8)),33))
			
			local itemInfo = {}
			itemInfo.lastNum = nums[_type][i]
			itemInfo.basicInfo = CopyTable(GDatatab_item["id_"..ids[_type][i]])
			self.m_tRewardItem[i].obj:setCellGoodItem(itemInfo, 2)
			self.m_tRewardItem[i].obj:setItemClickFun(self,self.onItemClick)
		end
	end
end
--@brief	点击物品弹出对应的tips
function WndStrong:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndStrong.m_root,1,tData,false)
end
--获取答案
--titleindex:题目  
--titlechoose:题目选择的位置
function WndStrong:_onCellTouchAnswerTitleChoose(titleindex, titlechoose)
	if not self.AnswerItemObj[titleindex] then return end
	
	if self.m_sAnswerChooseList[self.m_nAnswerType][titleindex] then
		return
	end
	--跳题答的时候
	if titleindex - 1 > 0 then
		if not self.m_sAnswerChooseList[self.m_nAnswerType][titleindex-1] then
			MsgBoxManager:showTipBox(LocalStrings.TITLE_ANSWER_TEXT3)
			return	
		end
	end
	local status = self.AnswerItemObj[titleindex]:chooseItemError(titlechoose)
	if status then return end

	self.AnswerItemObj[titleindex]:answerItemSelect(titlechoose)
	self.m_sAnswerChooseList[self.m_nAnswerType][titleindex] = titlechoose
	self:setSubmitStatus(self.m_nAnswerType)
end
--如果存在已提交过在答题的时候
function WndStrong:setSubmitStatus(tag)
	if #self.m_sAnswerChooseList[tag] >= #self.m_tGetTopicList[tag] and self.m_tBtnSunmitStatus[tag] == 0 then
		self.m_sBtnSubmit:setTouchEnable(true)
		self.submitLabel:setColor(GlobalMethod:ccc3(255,236,193))
		self.submitLabel:setStrokeColor(GlobalMethod:ccc3(0,108,3))
	else	
		self.m_sBtnSubmit:setTouchEnable(false)
		self.submitLabel:setColor(GlobalMethod:ccc3(255,255,255))
		self.submitLabel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	end
end

function WndStrong:onTabBtnClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if self.m_nAnswerType == tag then return end

	local level = self.m_tGetTopicList[tag][1].lv
	if CacheCenter:getPlayerInfo().level < level then
		MsgBoxManager:showTipBox(string.format(LocalStrings.TITLE_ANSWER_TEXT2,level,LocalStrings.TITLE_SUBJECT_TYPE[tag]))
		return
	end

	self:initCellItemAnswer(tag)
	if self.m_tTabAnswer[self.m_nAnswerType] ~= nil then
		self.m_tTabAnswer[self.m_nAnswerType].normal:setVisible(true)
		self.m_tTabAnswer[self.m_nAnswerType].select:setVisible(false)
		self.m_tTabAnswer[self.m_nAnswerType].name:setColor(GlobalMethod:ccc3(84,57,44))
	end
	if self.m_tTabAnswer[tag] ~= nil then
		self.m_tTabAnswer[tag].normal:setVisible(false)
		self.m_tTabAnswer[tag].select:setVisible(true)
		self.m_tTabAnswer[tag].name:setColor(GlobalMethod:ccc3(144,68,14))
	end
	
	if CacheCenter:getPlayerInfo().level < level then
		MsgBoxManager:showTipBox(string.format(LocalStrings.TITLE_ANSWER_TEXT2,level,level))
		self.m_tTabAnswer[tag].normal:setGrayRender(true)
		self.m_tTabAnswer[tag].normal:setVisible(true)
		self.m_tTabAnswer[tag].select:setVisible(false)
		self.m_tTabAnswer[tag].normal:setFile("ui/common/common_btn_dt_03.png")
		self.m_tTabAnswer[tag].name:setColor(GlobalMethod:ccc3(81,81,81))
	end
	self.m_nAnswerType = tag
end
--提交
function WndStrong:onSubmitAnswerClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--没有答题完整的时候
	if not self.m_tGetTopicList[self.m_nAnswerType] or not self.m_sAnswerChooseList[self.m_nAnswerType] then return end

	if #self.m_sAnswerChooseList[self.m_nAnswerType] < #self.m_tGetTopicList[self.m_nAnswerType] then
		MsgBoxManager:showTipBox(LocalStrings.TITLE_ANSWER_TEXT3)
		return
	end
	--答题有误的时候
	local status = nil
	for i,v in ipairs(self.m_tGetTopicList[self.m_nAnswerType]) do
		if v.correct ~= self.m_sAnswerChooseList[self.m_nAnswerType][i] then
			status = true
			break
		end
	end
	if status then
		MsgBoxManager:showTipBox(LocalStrings.TITLE_ANSWER_TEXT3)
		return
	end
	ProtocolProcessorSceneCity:send_PLAYER_SubmitPlayerAnswer(self.m_nAnswerType, TableToVector(self.m_sAnswerChooseList[self.m_nAnswerType], WZLuaVector_int_))
end
--获取提交按钮状态
function WndStrong:_onNoviceAnswerResult(status)
	self.m_sBtnSubmit:setVisible(true)
	self.m_tBtnSunmitStatus = {}
	for i,v in ipairs(status) do
		self.m_tBtnSunmitStatus[i] = v
	end
	self:initCellItemAnswer(1)
end
--提交之后的奖励显示
function WndStrong:_onAnswerSubmitResult(rewardId, rewardCount, answer_type)
	WndRewardShow:showById(rewardId,rewardCount)
	self.m_tBtnSunmitStatus[answer_type] = 1

	self:_setAnswerReward(answer_type)
	local status = self.m_tBtnSunmitStatus[answer_type] or 1
	if self.m_sBtnSubmit then
		self.m_sBtnSubmit:setTouchEnable(status == 0)
		self.submitLabel:setColor(GlobalMethod:ccc3(255,255,255))
		self.submitLabel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	end
end
--================ end =================
--@brief	是否可以前往(可以进入功能模块)
--@param    nId, 按钮id
--@return   #1, 是否开放
function WndStrong:_ifGoForId(nId)
    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    for i,v in ipairs(GlobalGame.g_tButtonInfo.buttonId) do
        if v == nId then
            if GlobalGame.g_tPlayerInfo.nLevel and GlobalGame.g_tButtonInfo.buttonStatus3Level[i] and
                GlobalGame.g_tPlayerInfo.nLevel < GlobalGame.g_tButtonInfo.buttonStatus3Level[i] then
				MsgBoxManager:showTipBox(string.format(LocalStrings.ACTIVE_NOLEVEL,GlobalGame.g_tButtonInfo.buttonStatus3Level[i]))
                return false
            else
                return true
            end
        end
    end 
end

--@brief	设置Item内容与图片
--@param	sTaskName:功能名称
function WndStrong:_setIconAndTaskName(tCell, nLevel, sTaskName, sTaskRemark, nStarNum, tIcon, nTag)
	local nPlayerLevel = CacheCenter:getPlayerInfo().level 
	--跳转按钮
	local btnGoto = GetElement(tCell, "btnGoto_WndStrong", WZUIButton)  --设置跳转按钮
	btnGoto:setTag(nTag)
	if nPlayerLevel >= nLevel then
		btnGoto:setTouchEnable(true)
	else
		btnGoto:setTouchEnable(false)
	end
	--功能名称
   	local txtTaskName = tCell:getChildElement("txtTaskName_WndStrong")
	txtTaskName = WZUILabelTTF:luaTo(txtTaskName)
	txtTaskName:setText(sTaskName)
	if tIcon ~= nil then 
    	local imgIcon = tCell:getChildElement("imgTaskIcon_WndStrong")
		imgIcon = WZUIImage:luaTo(imgIcon)
		imgIcon:setFile("ui/"..tIcon)  
	end 

	--功能描述
	local txtRemark = tCell:getChildElement("txtRemark_WndStrong")
	txtRemark = WZUILabelTTF:luaTo(txtRemark)
	txtRemark:setText(sTaskRemark)

	--按钮文字
	for i=1,3,1 do 
		local txtGoFor = tCell:getChildElement(string.format("txtGoFor%i_WndStrong",i))
		if txtGoFor ~= nil then 
			WZUILabelTTF:luaTo(txtGoFor):setText(LocalStrings.ACTIVE_BTN_GO)
		end
	end

	for i=1,nStarNum do
		local conStar_WndStrong = GetElement(tCell,"conStar_"..i.."_WndStrong")
		conStar_WndStrong:setVisible(true)
	end

	local txtTaskLevel = GetElement(tCell,"txtTaskLevel_WndStrong",WZUILabelTTF)
	txtTaskLevel:setText("")
	if self.m_nCurIndex == 9 then
		txtTaskLevel:setText(string.format(LocalStrings.UPGRADE_LEVEL_UNREACHED,nLevel))
	end
end

-------------------------------------私有方法模块End----------------------------------------

-- function WndStrong:_IsOpenTabButton(  )
-- 	WZLog("WndStrong:_IsOpenTabButton(::::: ",#self.m_tBeStrong,#self.m_tToGetGold,#self.m_tToGetEquie,#self.m_tBeUpgrade,#self.m_tToGetDiamond,#self.m_tPetBeStrong,#self.m_tToEat)
-- 	local num = 0
-- 	if #self.m_tBeStrong >0 then 
-- 		num = num + 1
-- 	end 

-- 	if #self.m_tToGetGold >0 then  
-- 		num = num + 1
-- 	end

-- 	if #self.m_tToGetEquie >0 then 
-- 		num = num + 1
-- 	end

-- 	if #self.m_tBeUpgrade >0 then 
-- 		num = num + 1
-- 	end

-- 	if #self.m_tToGetDiamond >0 then 
-- 		num = num + 1
-- 	end

-- 	if #self.m_tPetBeStrong >0 then 
-- 		num = num + 1
-- 	end

-- 	if #self.m_tToEat >0 then 
-- 		num = num + 1
-- 	end
-- 	num = num + 1 --新手答题
-- 	num = num + 1 --功能预告
-- 	return num
-- end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin-------------------------------------------

------------------------------------语言适配End---------------------------------------------
