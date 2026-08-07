--WndKidSchoolApproveData.lua
--@brief	WndKidSchoolApprove的数据模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校会员审批

WndKidSchoolApprove = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolApprove:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolApprove:_unInit()
	self.m_root = nil
	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolApprove:createElement()
	if WndKidSchoolApprove.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolApprove.m_root, WndKidSchoolApprove, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolApprove")
	assert(element, "WndKidSchoolApprove create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolApprove:showInterface()
	local wnd = WndKidSchoolApprove:createElement()
	if wnd ~= nil then
	    WindowManager:addWindow(wnd, WndKidSchoolApprove, nil, false, nil, true)
	end
end

--@brief    设置审批列表数据
function WndKidSchoolApprove:setApplyList(ids, spitCount, applyIds, sexs, headIds, headColors, faceIds, names, childIds, cnames, cfaceIds, cheadIds, csexs, cbodyIds, headEffectId)
	local function sortFunc(a,b)
		if a.sex and b.sex then
			return a.sex < b.sex
		end
	end
	self.m_tData = {}
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
		tempData.headEffectId = headEffectId[i]
		tempData.parents = {}
		for j=1,spitCount[i] do
			local parents = {}
			parents.applyId = applyIds[index]
			parents.sex = sexs[index]
			parents.headId = headIds[index]
			parents.headColor = headColors[index]
			parents.faceId = faceIds[index]
			parents.name = names[index]
			table.insert(tempData.parents,parents)
			index = index + 1
		end
		table.sort(tempData.parents,sortFunc)
		table.insert(self.m_tData,tempData)
	end

	self:updateUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
