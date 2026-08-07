--SceneRuneData.lua
--@brief	SceneRune的数据模块
--@date		2017/03/14
--@author	qixiang_xie
--@note		符文系统

SceneRune = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneRune:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSelSlotIndex = nil         --需要更换符文的槽位
	self.loadingId = nil
	self.m_tRuneSlotInfo = {}          --存放符文槽位信息
	self.m_tStigmataInfo = {}          --圣痕槽位信息
	self.m_nRuneTotalLevel = nil       --符文总等级
	self.m_tRuneList = {}              --可装备的符文列表
	self.m_bEnterBegin = true          
	self.m_tLocalSlotInfo = nil
	self.m_nShowLevelOpenSlot = nil      --显示等级开放的符文槽位
	self.m_nCurSelSlotIndex = nil
	self.m_rootPreviousSel = nil
	self.m_nLoadIndex = 1
	self.m_nOpenSlotIndex = nil  --开启槽位id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneRune:_unInit()
	self.m_root = nil
	self.m_tSelSlotIndex = nil
	self.loadingId = nil
	self.m_tRuneSlotInfo = nil
	self.m_tStigmataInfo = nil
	self.m_nRuneTotalLevel = nil    
	self.m_tRuneList = nil
	self.m_bEnterBegin = nil    
	self.m_tLocalSlotInfo = nil    
	self.m_nShowLevelOpenSlot = nil  
	self.m_nCurSelSlotIndex = nil
	self.m_rootPreviousSel = nil
	self.m_nLoadIndex = nil
	self.m_nOpenSlotIndex = nil  --开启槽位id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneRune:createElement()
	WZLog("SceneRune:createElement")
	local element = WZUISystem:getInstance():createElement("SceneRune")
	assert(element, "SceneRune create element failed!")
	self:_init()
	return element
end

function SceneRune:show()
	WZLog("SceneRune:show")
	local sceneRune = self:createElement()

	WindowManager:addWindow(sceneRune,self,nil,nil,nil,false)

    --replaceScene(self:createElement())
end

function SceneRune:showWin() 
	--self:show()
	if WndBagMain.m_root == nil then return end
	local sceneRune = self:createElement()
	GetElement(WndBagMain.m_root,"conSubWin",WZUIContainer):addChild(sceneRune)
end

function SceneRune:onCloseClick() 
	WZLog("SceneRune:onCloseClick")
end

--初始化符文槽信息
function SceneRune:initRuneSlotInfo()
	WZLog("SceneRune:initRuneSlotInfo")
	self.m_tLocalSlotInfo = {}
	for k,v in pairs(GDatatab_rune_grid) do
		table.insert(self.m_tLocalSlotInfo,v)
	end
	table.sort(self.m_tLocalSlotInfo,function (a,b)
		if a.id < b.id then
			return true
		end
		return false
	end)
end

-- --@brief  添加顶部导航栏
-- function SceneRune:addTop()
-- 	WZLog("SceneRune:addTop")
-- 	local cell,tcell = CellTopHandle:createElement()
--     self.m_root:addChild(cell)
--     self.m_tTopHangle = tcell
--     self.m_oTopObject = cell
--     tcell:setTopData("ui/common/common_icon_fuwen.png",SceneRune,SceneRune.onCloseClick,true,false,false,"SceneRune",{goldType=8})
-- end


function SceneRune:createLoadingBox()
    if not self.loadingId then
        self.loadingId = self.m_tMsgBoxManager:showLoadingBox()
    end
end

function SceneRune:closeLoadingBox()
    if self.loadingId and self.m_root then
        self.m_tMsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

--设置符文信息
function SceneRune:setRuneInfo(placeIds,placeItemId,rpIds,runeLevel,itemIds,itemNums)
	WZLog("SceneRune:setRuneInfo ")
	if self.m_root == nil then return end
	self.m_tStigmataInfo = {}
	for i,v in ipairs(rpIds) do
		table.insert(self.m_tStigmataInfo,v)
	end
	self.m_tRuneSlotInfo = {}
	for i,v in ipairs(placeIds) do
		local temp = {}
		table.insert(temp,v)
		table.insert(temp,placeItemId[i])
		table.insert(self.m_tRuneSlotInfo,temp)
	end
	
	self.m_nRuneTotalLevel = runeLevel
	self.m_tRuneList = {}
	for i,v in ipairs(itemIds) do
		local temp = {}
		table.insert(temp,v)
		table.insert(temp,itemNums[i])
		table.insert(self.m_tRuneList,temp)
	end
	
	self:updateBigRune()
	if self.m_bEnterBegin then
		self:showRuneSlot()
		local conCon = GetElement(self.m_root,"conCon_SceneRune",WZUIContainer)
		conCon:setTouchEnable(false)
		conCon:disableSchedule()
		self.m_nLoadIndex = 1
		conCon:enableSchedule("showRuneOnSlot")
		self.m_bEnterBegin = false
	elseif WndRuneBook and WndRuneBook.m_root ~= nil then --在符文背包里进行了符文出售操作
		local conCon = GetElement(self.m_root,"conCon_SceneRune",WZUIContainer)
		conCon:setTouchEnable(false)
		conCon:disableSchedule()
		self.m_nLoadIndex = 1
		conCon:enableSchedule("showRuneOnSlot")
		self:showRuneAttributeInfo()
	else
		self:showRuneAttributeInfo()
		if WndRuneBag and WndRuneBag.m_root then
			WndRuneBag:updateRuneBagList(self.m_tRuneList)
		end
	end
end

--在符文槽上显示符文信息
function SceneRune:showRuneOnSlot(element)
	if self.m_nLoadIndex > #self.m_tRuneSlotInfo then
		element = WZUIContainer:luaTo(element)
		element:setTouchEnable(true)
		element:disableSchedule()
		return
	end
	local runeInfo = self.m_tRuneSlotInfo[self.m_nLoadIndex]
	local slotId = runeInfo[1]
	local runeId = runeInfo[2]
	local temp = GDatatab_rune_grid["id_" .. slotId]
	local slotIndex = nil
	local getElement = GetElement
	local parent = nil
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
	if temp.type == 1 then
		slotIndex = temp.sequence
		parent = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
	elseif temp.type == 2 then
		slotIndex = temp.sequence
		parent = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
	elseif temp.type == 3 then
		slotIndex = temp.sequence
		parent = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
	end

	local conRun = getElement(parent,"conRun" .. slotIndex .. "_SceneRune",WZUIContainer)
	local imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
 	local imgLock = getElement(conRun,"imgLock_SceneRune",WZUIImage)
 	imgLock:setFile("")
 	local txtOpenLevel = getElement(conRun,"txtOpenLevel_SceneRune",WZUILabelTTF)
 	txtOpenLevel:setText("")
 	local imgRed = getElement(conRun,"imgRed_SceneRune",WZUIImage)
 	imgRed:setVisible(false)
 	if runeId > 0 then
 		local itemInfo = GDatatab_item["id_" ..runeId]
 		imgBg:setFile(itemInfo.icon)
 	else
 		local bRed = self:bShowRed(slotId)
 		imgRed:setVisible(bRed)
 		
 		if temp.type == 1 then
			imgBg:setFile("ui/rune/common_scale9_fuwenhongdi01.png")
		elseif temp.type == 2 then
			imgBg:setFile("ui/rune/common_scale9_fuwenlvdi01.png")
		elseif temp.type == 3 then
			imgBg:setFile("ui/rune/common_scale9_fuwenhuangdi01.png")
		end
 	end
 	self.m_nLoadIndex = self.m_nLoadIndex + 1
end

--根据id获取符文槽位是否已开启
--槽位所在配置表的id
--return : true 已开启 false 未开启
function SceneRune:findSlotState(slotId)
	for i,v in ipairs(self.m_tRuneSlotInfo) do
		if v[1] == slotId then
			return true
		end
	end
	return false
end

--设置槽位背景图
--state 1 ：已开启 2：等级开放背景 3：钻石开放背景 4:锁背景
--slotType槽位类型
function SceneRune:setSlotBg(state,slotType,txt,imgbg,imglock,openLevel)
	if state == 2 then
		txt:setText("Lv" .. openLevel .. LocalStrings.MAP_EVENT_ON)
		if slotType == 1 then
			txt:setLabelStyleKey("C16_F20")
			imgbg:setFile("ui/rune/common_scale9_fuwenhongdi02.png")
		elseif slotType == 2 then
			txt:setLabelStyleKey("C15_F20")
			imgbg:setFile("ui/rune/common_scale9_fuwenlvdi02.png")
		elseif slotType == 3 then
			txt:setLabelStyleKey("C11_F20")
			imgbg:setFile("ui/rune/common_scale9_fuwenhuangdi02.png")
		end
	elseif state == 1 then
		if slotType == 1 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhongdi01.png")
		elseif slotType == 2 then
			imgbg:setFile("ui/rune/common_scale9_fuwenlvdi01.png")
		elseif slotType == 3 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhuangdi01.png")
		end
	elseif state == 4 then
		if slotType == 1 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhongdi03.png")
			imglock:setFile("ui/rune/common_icon_suo6.png")
		elseif slotType == 2 then
			imgbg:setFile("ui/rune/common_scale9_fuwenlvdi03.png")
			imglock:setFile("ui/rune/common_icon_suo4.png")
		elseif slotType == 3 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhuangdi03.png")
			imglock:setFile("ui/rune/common_icon_suo5.png")
		end
	elseif state == 3 then
		if slotType == 1 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhongdi02.png")
			imglock:setFile("ui/rune/common_icon_hongzuan.png")
		elseif slotType == 2 then
			imgbg:setFile("ui/rune/common_scale9_fuwenlvdi02.png")
			imglock:setFile("ui/rune/common_icon_lvzuan.png")
		elseif slotType == 3 then
			imgbg:setFile("ui/rune/common_scale9_fuwenhuangdi02.png")
			imglock:setFile("ui/rune/common_icon_huangzuan.png")
		end
	end
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" then
		txt:setScale(0.6)
	elseif ProjConfig.LANGUAGE == "pt" then
		txt:setScale(0.4)
	end
end

--在符文槽上的装载与拆卸的状态
function SceneRune:updateSlotRuneStatus(status,placeId,itemId)
	WZLog("SceneRune:updateSlotRuneStatus =",status)
	if self.m_root == nil then return end
	if status ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
	else
		if placeId > 0 and itemId > 0 then --执行了装载单个符文操作
			for i,v in ipairs(self.m_tRuneSlotInfo) do --更新符文槽位信息
				if v[1] == placeId then
					v[2] = itemId
					break
				end
			end
		elseif placeId > 0 and itemId == 0 then --拆卸单个符文
			for i,v in ipairs(self.m_tRuneSlotInfo) do --更新符文槽位信息
				if v[1] == placeId then
					v[2] = 0
					break
				end
			end
		elseif placeId == -1 and itemId == 0 then --卸载所有符文
			self:showRuneSlot()
		end
		if WndRuneBag and WndRuneBag.m_root and placeId ~= -1 then 
			if self.m_nCurSelSlotIndex == nil then
				self:showSlotRuneInfoById(placeId)
			    return 
		    end
			if self.m_nCurSelSlotIndex then
		     	self:showSlotRuneInfoById(self.m_nCurSelSlotIndex)
			end
			tempSlotIndex = self:findNextSlotByCurElSlot(nil) 
			if tempSlotIndex == self.m_nCurSelSlotIndex then --当前类型的符文槽没有找到下个空槽位
				for i=1,3 do
					tempSlotIndex = self:findNextSlotByCurElSlot(i)
				    if tempSlotIndex ~= self.m_nCurSelSlotIndex then
				    	break
				    end
			    end
			end

			if tempSlotIndex == self.m_nCurSelSlotIndex then --没有空的槽位可以装载符文
				local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
				local childNode = conRight:getChildByTag(119)
				if childNode then
					childNode:removeFromParentAndCleanup(true)
				end
				self.m_nCurSelSlotIndex = nil
				self:showRuneTotalInfo()
				if self.m_rootPreviousSel then
					self.m_rootPreviousSel:setVisible(false)
					self.m_rootPreviousSel = nil
	            end
			end
		elseif WndRuneInfo and WndRuneInfo.m_root and placeId > 0 and itemId == 0 then --拆卸单个符文
			if self.m_nCurSelSlotIndex then
		     	self:showSlotRuneInfoById(self.m_nCurSelSlotIndex)
			end
			local runeSlotInfo = GDatatab_rune_grid["id_" .. self.m_nCurSelSlotIndex]
			local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
			local childNode = conRight:getChildByTag(220)
			if childNode then
				childNode:removeFromParentAndCleanup(true)
			end
			local conRuneTotalInfo = GetElement(conRight,"conRuneTotalInfo_SceneRune",WZUIContainer)
			conRuneTotalInfo:setVisible(false)
			WndRuneBag:show(runeSlotInfo.type,self.m_nCurSelSlotIndex,conRight,self.m_tRuneList)
			WndRuneBag:setCloseCallback(self,self.closeRuneBag)
		end
	end
end

--钻石开启槽位回调
function SceneRune:openSlotCallback(status, placeId)
	WZLog("SceneRune:openSlotCallback =",placeId)
	if self.m_root == nil then return end
	if status ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.DIAMONDS_OPEN_SLOT_ERROR_TIP)
	else
		local tempT = {}
		table.insert(tempT,placeId)
		table.insert(tempT,0)
		table.insert(self.m_tRuneSlotInfo,tempT)
		local slotInfo = GDatatab_rune_grid["id_" ..placeId]
		local temp = nil
		local getElement = GetElement
		local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
		local runeParent = nil
		if slotInfo.type == 1 then
			temp = slotInfo.sequence
			runeParent = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
		elseif slotInfo.type == 2 then
			temp = slotInfo.sequence
			runeParent = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
		elseif slotInfo.type == 3 then
			temp = slotInfo.sequence
			runeParent = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
		end
		local conRun = getElement(runeParent,"conRun" .. temp .. "_SceneRune",WZUIContainer)
	    local imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
	    local imgLock = getElement(conRun,"imgLock_SceneRune",WZUIImage)
	    local txtOpenLevel = getElement(conRun,"txtOpenLevel_SceneRune",WZUILabelTTF)
	    local imgRed = getElement(conRun,"imgRed_SceneRune",WZUIImage)
	    imgLock:setFile("")
	    imgBg:setFile("")
	    txtOpenLevel:setText("")
	    local bRed = self:bShowRed(placeId)
	    imgRed:setVisible(bRed)
	    self:setSlotBg(1,slotInfo.type,nil,imgBg)
	    self:updateSlotBg()
	end
end

--钻石开启槽位后需要更新槽位背景
function SceneRune:updateSlotBg()
	WZLog("SceneRune:updateSlotBg")
	local bShowLevelOpen = false
	local conRun = nil
	local imgBg = nil
	local imgLock = nil
	local txtOpenLevel = nil
	local openLevel = nil
	local previousSlotIndex = nil
	local slotState = nil
	local getElement = GetElement
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
	for i,v in ipairs(self.m_tLocalSlotInfo) do
		local runeParent = nil
		if v.type == 1 then
			temp = v.sequence
			runeParent = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
		elseif v.type == 2 then
			temp = v.sequence
			runeParent = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
		elseif v.type == 3 then
			temp = v.sequence
			runeParent = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
		end
		conRun = getElement(runeParent,"conRun" .. temp .. "_SceneRune",WZUIContainer)
	    imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
	    imgLock = getElement(conRun,"imgLock_SceneRune",WZUIImage)
	    txtOpenLevel = getElement(conRun,"txtOpenLevel_SceneRune",WZUILabelTTF)
	    openLevel = v.open_level
		slotState = self:findSlotState(v.id)
		if not slotState then --槽位未开启
			previousSlotIndex = v.parent
			if previousSlotIndex == 0 then
				if not bShowLevelOpen then
					bShowLevelOpen = true
					txtOpenLevel:setText("")
				    imgLock:setFile("")
				    imgBg:setFile("")
					self:setSlotBg(2,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
				else
					txtOpenLevel:setText("")
				    imgLock:setFile("")
				    imgBg:setFile("")
					self:setSlotBg(3,v.type,nil,imgBg,imgLock)
				end
			else
				slotState = self:findSlotState(previousSlotIndex)
				if slotState then
					if not bShowLevelOpen then
						bShowLevelOpen = true
						txtOpenLevel:setText("")
					    imgLock:setFile("")
					    imgBg:setFile("")
						self:setSlotBg(2,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
					else
						txtOpenLevel:setText("")
					    imgLock:setFile("")
					    imgBg:setFile("")
						self:setSlotBg(3,v.type,nil,imgBg,imgLock,nil)
					end
				end
			end
		end
	end
end

--查找当前查看的槽位的下一个槽位
function SceneRune:findNextSlotByCurElSlot(slotT)
	WZLog("SceneRune:findNextSlotByCurElSlot =",self.m_nCurSelSlotIndex)
	if self.m_nCurSelSlotIndex then
		local tempIndex = self.m_nCurSelSlotIndex
		local gridInfo = GDatatab_rune_grid["id_" .. self.m_nCurSelSlotIndex]
		local slotType = slotT
		if slotT == nil then
			slotType = gridInfo.type
		end
		local getElement = GetElement
		local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
		local conRunParent = nil
		local conRight = getElement(self.m_root,"conRight_SceneRune",WZUIContainer)
		local conRun = nil
		local nodeTag = nil
		local imgBg = nil
		local strFile = nil
		if slotType == 1 then
			local conRuneType1 = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
			conRunParent = conRuneType1
		elseif slotType == 2 then
			local conRuneType2 = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
			conRunParent = conRuneType2
		elseif slotType == 3 then
			local conRuneType3 = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
			conRunParent = conRuneType3
		end
		for i=1,10 do
			conRun = getElement(conRunParent,"conRun" .. i .. "_SceneRune",WZUIContainer)
			nodeTag = conRun:getTag()
			if nodeTag ~= self.m_nCurSelSlotIndex then
				imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
				strFile = imgBg:getFile()
				if strFile == "ui/rune/common_scale9_fuwenhongdi01.png" or strFile == "ui/rune/common_scale9_fuwenlvdi01.png" or strFile == "ui/rune/common_scale9_fuwenhuangdi01.png" then
					self.m_nCurSelSlotIndex = nodeTag
					if self.m_rootPreviousSel then
						self.m_rootPreviousSel:setVisible(false)
					end
					local imgLight = getElement(conRun,"imgLight_SceneRune",WZUIImage)
					imgLight:setVisible(true)
					self.m_rootPreviousSel = imgLight
					WndRuneBag:show(slotType,nodeTag,conRight,self.m_tRuneList)
					break
				end
			end
		end
		return tempIndex
	end
end

--根据符文类型查找可以装载的槽位ID
function SceneRune:findSlotBySlotType(slotType)
	WZLog("SceneRune:findNextSlotByCurElSlot =",slotType)
	local getElement = GetElement
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
	local conRunParent = nil
	local conRight = getElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	if slotType == 1 then
		local conRuneType1 = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
		conRunParent = conRuneType1
	elseif slotType == 2 then
		local conRuneType2 = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
		conRunParent = conRuneType2
	elseif slotType == 3 then
		local conRuneType3 = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
		conRunParent = conRuneType3
	end
	local conRun = nil
	local imgBg = nil
	local nodeTag = nil --槽位ID
	local strFile = nil
	for i=1,10 do
		conRun = getElement(conRunParent,"conRun" .. i .. "_SceneRune",WZUIContainer)
		imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
		strFile = imgBg:getFile()
		nodeTag = conRun:getTag()
		if strFile == "ui/rune/common_scale9_fuwenhongdi01.png" or strFile == "ui/rune/common_scale9_fuwenlvdi01.png" or strFile == "ui/rune/common_scale9_fuwenhuangdi01.png" then
			return nodeTag
		end
	end
	return nil
end

--显示圣痕
function SceneRune:updateBigRune()
	WZLog("SceneRune:updateBigRune")
	local getElement = GetElement
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)

	local conRuneType1 = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
	local conRun11 = getElement(conRuneType1,"conRun11_SceneRune",WZUIContainer)
	local imgBg1 = getElement(conRun11,"imgBg_SceneRune",WZUIImage)
	local txtOpenLevel1 = getElement(conRun11,"txtOpenLevel_SceneRune",WZUILabelTTF)
	imgBg1:setFile("ui/rune/common_scale9_fuwenzidi03.png")
	txtOpenLevel1:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
	local runeSp1 = getElement(conRun11,"runeSp_SceneRune",WZUISpine)
	runeSp1:setFileAtlas("")
	runeSp1:setFileJson("")
	runeSp1:setAnimationName("")

	local conRuneType2 = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
	local conRun112 = getElement(conRuneType2,"conRun11_SceneRune",WZUIContainer)
	local imgBg2 = getElement(conRun112,"imgBg_SceneRune",WZUIImage)
	imgBg2:setFile("ui/rune/common_scale9_fuwenzidi03.png")
	local txtOpenLevel2 = getElement(conRun112,"txtOpenLevel_SceneRune",WZUILabelTTF)
	txtOpenLevel2:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
	local runeSp2 = getElement(conRun112,"runeSp_SceneRune",WZUISpine)
	runeSp2:setFileAtlas("")
	runeSp2:setFileJson("")
	runeSp2:setAnimationName("")

	local conRuneType3 = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
	local conRun113 = getElement(conRuneType3,"conRun11_SceneRune",WZUIContainer)
	local imgBg3 = getElement(conRun113,"imgBg_SceneRune",WZUIImage)
	imgBg3:setFile("ui/rune/common_scale9_fuwenzidi03.png")
	local txtOpenLevel3 = getElement(conRun113,"txtOpenLevel_SceneRune",WZUILabelTTF)
	txtOpenLevel3:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
	local runeSp3 = getElement(conRun113,"runeSp_SceneRune",WZUISpine)
	runeSp3:setFileAtlas("")
	runeSp3:setFileJson("")
	runeSp3:setAnimationName("")

	local conRun114 = getElement(conRuneType3,"conRun12_SceneRune",WZUIContainer)
	local imgBg4 = getElement(conRun114,"imgBg_SceneRune",WZUIImage)
	imgBg4:setFile("ui/rune/common_scale9_fuwendashenghendi03.png")
	local txtOpenLevel4 = getElement(conRun114,"txtOpenLevel_SceneRune",WZUILabelTTF)
	txtOpenLevel4:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
	local runeSp4 = getElement(conRun114,"runeSp_SceneRune",WZUISpine)
	runeSp4:setFileAtlas("")
	runeSp4:setFileJson("")
	runeSp4:setAnimationName("")


	local bigRuneT = GDatatab_rune_level
	local spineJson = ""
	local spineAtlas = ""
	local spAnimationName = ""
	for i,v in ipairs(self.m_tStigmataInfo) do
		local bigRuneInfo = bigRuneT["id_"..v]
		spineJson = ""
		if bigRuneInfo.type == 1 then
			imgBg1:setFile(bigRuneInfo.img)
			imgBg1:setTag(v)
			txtOpenLevel1:setText("")
			spineJson = "ui/rune_draw_10" .. bigRuneInfo.level .. ".json"
			spineAtlas = "ui/rune_draw_10" .. bigRuneInfo.level .. ".atlas"
			spAnimationName = "rune_draw_10" .. bigRuneInfo.level
			runeSp1:setFileAtlas(spineAtlas)
			runeSp1:setFileJson(spineJson)
			runeSp1:setAnimationName(spAnimationName)
		elseif bigRuneInfo.type == 2 then
			imgBg2:setFile(bigRuneInfo.img)
			imgBg2:setTag(v)
			txtOpenLevel2:setText("")
			spineJson = "ui/rune_draw_20" .. bigRuneInfo.level .. ".json"
			spineAtlas = "ui/rune_draw_20" .. bigRuneInfo.level .. ".atlas"
			spAnimationName = "rune_draw_20" .. bigRuneInfo.level
			runeSp2:setFileAtlas(spineAtlas)
			runeSp2:setFileJson(spineJson)
			runeSp2:setAnimationName(spAnimationName)
		elseif bigRuneInfo.type == 3 then
			imgBg3:setFile(bigRuneInfo.img)
			imgBg3:setTag(v)
			txtOpenLevel3:setText("")
			spineJson = "ui/rune_draw_30" .. bigRuneInfo.level .. ".json"
			spineAtlas = "ui/rune_draw_30" .. bigRuneInfo.level .. ".atlas"
			spAnimationName = "rune_draw_30" .. bigRuneInfo.level
			runeSp3:setFileAtlas(spineAtlas)
			runeSp3:setFileJson(spineJson)
			runeSp3:setAnimationName(spAnimationName)
		elseif bigRuneInfo.type == -1 then
			imgBg4:setFile(bigRuneInfo.img)
			imgBg4:setTag(v)
			txtOpenLevel4:setText("")
			spineJson = "ui/rune_draw_00" .. bigRuneInfo.level .. ".json"
			spineAtlas = "ui/rune_draw_00" .. bigRuneInfo.level .. ".atlas"
			spAnimationName = "rune_draw_00" .. bigRuneInfo.level
			runeSp4:setFileAtlas(spineAtlas)
			runeSp4:setFileJson(spineJson)
			runeSp4:setAnimationName(spAnimationName)
		end
	end
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
		txtOpenLevel1:setScale(0.7)
		txtOpenLevel2:setScale(0.7)
		txtOpenLevel3:setScale(0.7)
		txtOpenLevel4:setScale(0.7)
	elseif ProjConfig.LANGUAGE == "es" then
		txtOpenLevel1:setScale(0.8)
		txtOpenLevel2:setScale(0.8)
		txtOpenLevel3:setScale(0.8)
		txtOpenLevel4:setScale(0.8)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function SceneRune:bShowRed(slotId)
	-- body
	WZLog("SceneRune:bShowRed")
	local bShowRed = false
	if slotId then
		local temp = GDatatab_rune_grid["id_" .. slotId]

		if temp then
			if self.m_tRuneList and #self.m_tRuneList > 0 then
				for i,v in ipairs(self.m_tRuneList) do
				    local subType = GDatatab_item["id_" .. v[1]].sub_type
				    if subType == temp.type then
				    	bShowRed = true
				    	break
				    end
			    end
 		    end
		end
	end
	return bShowRed
end



-------------------------------------私有方法模块End----------------------------------------
