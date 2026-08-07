--CellCommunityTaskRelease.lua
--@brief	CellCommunityTaskRelease的UI模块
--@date		2016/06/17
--@author	zsq
--@note		公会发布任务Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityTaskRelease:onEnter(element)
	self.m_root = element
	 AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityTaskRelease:onExit(element)
	self:_unInit()
end

function CellCommunityTaskRelease:onClick(element)
	if WndCommunityTaskRelease.m_tSelectedCell ~= nil and WndCommunityTaskRelease.m_tSelectedCell.m_root ~= nil then
		WZLog("kkggjgjgj",WndCommunityTaskRelease.m_tSelectedCell)
		GetElement(WndCommunityTaskRelease.m_tSelectedCell.m_root,"btnClick_CellCommunityTaskRelease",WZUIButton):setButtonStatus(0)
	end
	WndCommunityTaskRelease.m_tSelectedCell = self
	WndCommunityTaskRelease:updateDetail(self.m_tData,self.m_nCur,self.m_nTotal)
	GetElement(self.m_root,"btnClick_CellCommunityTaskRelease",WZUIButton):setButtonStatus(1)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommunityTaskRelease:setData(tData, cur, total)
	self.m_tData = tData
	self.m_nCur = cur
	self.m_nTotal = total
	--状态
	GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,227,116))
	if WndCommunityTask.m_tData.taskStatus == 0 then
		GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setText("["..LocalStrings.COMMUNITYINFO121.."]")
	else
		if cur == total then
			GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setText("["..LocalStrings.ACTIVE_FINISH.."]")
			GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setColor(GlobalMethod:ccc3(99,255,95))
		else
			GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setText("["..LocalStrings.TASK_DOING.."]")
		end
	end
	--星星
	for i=1,5 do
		GetElement(self.m_root,"star"..i,WZUIImage):setVisible(false)
	end
	for i=1,tData.star do
		GetElement(self.m_root,"star"..i,WZUIImage):setVisible(true)
	end
	--任务名
	GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF):setText(tData.name)
	--任务详情
	GetElement(self.m_root,"txtDetail_CellCommunityTaskRelease",WZUILabelTTF):setText(tData.desc)
	--进度
	GetElement(self.m_root,"txtScore_CellCommunityTaskRelease",WZUILabelTTF):setText(cur.."/"..total)
	if total == 0 then
		GetElement(self.m_root,"progressBar",WZUIProgress):setPercentage(0)
	else
		GetElement(self.m_root,"progressBar",WZUIProgress):setPercentage(math.floor(cur/total*100))
	end
	--锁
	GetElement(self.m_root,"imgSuo_CellCommunityTaskRelease",WZUIImage):setVisible(false)
	self.m_bLocked = false
	if WndCommunityTask.m_tData.taskStatus == 1 then return end
	if WndCommunityTaskRelease.m_tID == nil then WndCommunityTaskRelease.m_tID = {} end
	for i=1,#WndCommunityTaskRelease.m_tID do
		if tData.id == WndCommunityTaskRelease.m_tID[i] then
			GetElement(self.m_root,"imgSuo_CellCommunityTaskRelease",WZUIImage):setVisible(true)
			self.m_bLocked = true
		end
	end
end

function CellCommunityTaskRelease:setLocked(stat)
	self.m_bLocked = stat
	GetElement(self.m_root,"imgSuo_CellCommunityTaskRelease",WZUIImage):setVisible(stat)
	if WndCommunityTaskRelease.m_tID == nil then WndCommunityTaskRelease.m_tID = {} end
	if stat == true then
		table.insert(WndCommunityTaskRelease.m_tID,self.m_tData.id) 
	elseif stat == false then
		for i=1,#WndCommunityTaskRelease.m_tID do
			if WndCommunityTaskRelease.m_tID[i] == self.m_tData.id then
				table.remove(WndCommunityTaskRelease.m_tID,i)
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function CellCommunityTaskRelease:_adaptLanguage_th()
    WZLog("CellCommunityTaskRelease:_adaptLanguage_th")
    GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF):setScale(0.75)
end

function CellCommunityTaskRelease:_adaptLanguage_en()
	GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setScale(0.8)
	local txtName = GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF)
	txtName:setScale(0.75)
	txtName:setRelativePosition(GlobalMethod:ccp(0.34,0.71))
end

function CellCommunityTaskRelease:_adaptLanguage_pt()
	GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF):setScale(0.75)
end

function CellCommunityTaskRelease:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setScale(0.8)
	local txtName = GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF)
	txtName:setScale(0.8)
	txtName:setRelativePosition(GlobalMethod:ccp(0.29,0.71))
end

function CellCommunityTaskRelease:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtState_CellCommunityTaskRelease",WZUILabelTTF):setFontSize(16)
	local txtName = GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF)
	txtName:setFontSize(16)
	--txtName:setRelativePosition(GlobalMethod:ccp(0.33,0.71))
end

function CellCommunityTaskRelease:_adaptLanguage_vn(  )
	local txtName = GetElement(self.m_root,"txtName_CellCommunityTaskRelease",WZUILabelTTF)
	txtName:setFontSize(16)
end
-------------------------------------语言适配模块End----------------------------------------
