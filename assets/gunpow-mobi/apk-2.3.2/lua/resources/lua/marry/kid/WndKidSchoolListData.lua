--WndKidSchoolListData.lua
--@brief	WndKidSchoolList的数据模块
--@date		2021/04/21
--@author	yrd
--@note		孩子学校列表

WndKidSchoolList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = 2 					--界面类型 1有学校 2无学校
	self.m_tSchoolDataList = {} 		--学校数据列表
	self.m_tMySchoolInfo = {} 			--学校信息
	self.m_tSchoolChildren = {} 		--学校学生
	self.sureBtnState = "change" 		--宣言按钮状态
	self.m_strDeclaration = "" 			--临时保存玩家修改的宣言
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolList:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.m_tSchoolDataList = nil
	self.m_tMySchoolInfo = nil
	self.m_tSchoolChildren = nil
	self.sureBtnState = nil
	self.m_strDeclaration = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolList:createElement()
	if WndKidSchoolList.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolList.m_root, WndKidSchoolList, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolList")
	assert(element, "WndKidSchoolList create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolList:showInterface(nType)
	local wnd = WndKidSchoolList:createElement()
	if wnd ~= nil then
		self.m_nType = nType
	    WindowManager:addWindow(wnd, WndKidSchoolList, nil, false, nil, true)
	end
end

--@brief	设置学校列表成功
function WndKidSchoolList:setSchoolListOk(schoolIds, schoolNames, schoolLevels, schoolEffectIds, schoolNums, schoolMaxNums)
	self.m_tSchoolDataList = {}
	for i=1,#schoolIds do
		local schoolInfo = {}
		schoolInfo.schoolId = schoolIds[i]
		schoolInfo.schoolName = schoolNames[i]
		schoolInfo.schoolLevel = schoolLevels[i]
		schoolInfo.schoolEffectId = schoolEffectIds[i]
		schoolInfo.schoolNum = schoolNums[i]
		schoolInfo.schoolMaxNum = schoolMaxNums[i]
		table.insert(self.m_tSchoolDataList,schoolInfo)
	end

	self:updateContent3()
end

function WndKidSchoolList:sendCreateSchoolOk()
	-- body
    ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(0)
	if WndKidSchoolList.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolList.m_root, WndKidSchoolList, true)
	end
end

--@brief	设置学校信息列表
function WndKidSchoolList:setMySchoolInfo(schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, hasDonate, donateTime, hasHide, inSchoolNum, declaration)
	self.m_tMySchoolInfo = {}
	self.m_tMySchoolInfo.schoolId = schoolId
	self.m_tMySchoolInfo.schoolName = schoolName
	self.m_tMySchoolInfo.masterId = masterId
	self.m_tMySchoolInfo.level = level
	self.m_tMySchoolInfo.effectId = effectId
	self.m_tMySchoolInfo.schoolExp = schoolExp
	self.m_tMySchoolInfo.num = num
	self.m_tMySchoolInfo.needPassword = needPassword
	self.m_tMySchoolInfo.masterName = masterName
	self.m_tMySchoolInfo.maxExp = maxExp
	self.m_tMySchoolInfo.hasDonate = hasDonate
	self.m_tMySchoolInfo.donateTime = donateTime
	self.m_tMySchoolInfo.hasHide = hasHide
	self.m_tMySchoolInfo.inSchoolNum = inSchoolNum
	self.m_tMySchoolInfo.declaration = declaration

	self:updateContent1()
end

--@brief	设置学生信息列表
function WndKidSchoolList:setSchoolChildren(ids, childIds, cnames, cfaceIds, cheadIds, csexs, cbodyIds, status, loginTime, donateTimes, spitCount, pids, sexs, headIds, headColors, faceIds, names, headEffectId)
	local function sortFunc(a,b)
		return a.sex < b.sex
	end
	self.m_tSchoolChildren = {}
	local index = 1
	for i=1,#ids do
		local tempData = {}
		tempData.id = ids[i]
		tempData.childId = childIds[i]
		tempData.cname = cnames[i]
		tempData.cfaceId = cfaceIds[i]
		tempData.cheadId = cheadIds[i]
		tempData.csex = csexs[i]
		tempData.cbodyId = cbodyIds[i]
		tempData.status = status[i]
		tempData.loginTime = loginTime[i]
		tempData.donateTime = donateTimes[i]
		tempData.headEffectId = headEffectId[i]
		tempData.parents = {}
		for j=1,spitCount[i] do
			local parents = {}
			parents.pid = pids[index]
			parents.sex = sexs[index]
			parents.headId = headIds[index]
			parents.headColor = headColors[index]
			parents.faceId = faceIds[index]
			parents.name = names[index]
			table.insert(tempData.parents,parents)
			index = index + 1
		end
		table.sort(tempData.parents,sortFunc)
		table.insert(self.m_tSchoolChildren,tempData)
	end

	--用于转让学校界面数据
	self.m_tSchoolParent = {}
	local index = 1
	for i=1,#spitCount do
		for j=1,spitCount[i] do
			local tempData = {}
			tempData.id = ids[i]
			tempData.childId = childIds[i]
			tempData.cname = cnames[i]
			tempData.cfaceId = cfaceIds[i]
			tempData.cheadId = cheadIds[i]
			tempData.csex = csexs[i]
			tempData.cbodyId = cbodyIds[i]
			tempData.status = status[i]
			tempData.loginTime = loginTime[i]
			tempData.donateTime = donateTimes[i]
			tempData.headEffectId = headEffectId[i]

			tempData.pid = pids[index]
			tempData.sex = sexs[index]
			tempData.headId = headIds[index]
			tempData.headColor = headColors[index]
			tempData.faceId = faceIds[index]
			tempData.name = names[index]
			index = index + 1
			if SceneKidSchoolHome:isMyChild(childIds[i]) ~= true then
				table.insert(self.m_tSchoolParent,tempData)
			end
		end
	end

	self:updateContent2()
end

--@brief	列表类型 1表示有学校 2表示没有学校
function WndKidSchoolList:getType()
	return self.m_nType
end

--@brief	隐藏学校协议返回成功
function WndKidSchoolList:hideSchoolOk(result)
    if result == 1 then
    	if self.m_tMySchoolInfo.hasHide == true then
	        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT229)
	    else
	        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT228)
	    end
        ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.FAIL)
    end
end

--@brief	学校宣言协议返回成功
function WndKidSchoolList:getSchoolDeclarationResult(result)
	if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.WNDCHECKOTHER45)
        self.m_tMySchoolInfo.declaration = self.m_strDeclaration
        self:setDeclaration(self.m_tMySchoolInfo.declaration)
	elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.OPERATION_ERROR)
	elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT252)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
