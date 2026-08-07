--WndMasterMember.lua
--@brief	WndMasterMember的UI模块
--@date		2015/05/27
--@author	zsq
--@note		师徒成员


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterMember:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndMasterMember:onEnterTransitionDidFinish(element)
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterMember:onExit(element)
	self:_unInit()
end

--@brief	清除人物选中状态
function WndMasterMember:clearChecked()
	if self.m_tRoleAniList == nil then return end
	for i=1,#self.m_tRoleAniList do
		self.m_tRoleAniList[i]:setChecked(false)
	end
end

--@brief	师徒授业
function WndMasterMember:onImpart(element)
	WZLog("WndMasterMember:onImpart")
	WndMasterImpart:show()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新我的徒弟界面
function WndMasterMember:update()
	WZLog("WndMasterHall:update",Serialize(self.m_tMyPupils))
	local tableContainer = GetElement(self.m_root,"tbConRole",WZUITableContainer)
	tableContainer:cleanTable()
	tableContainer:setEnableGlScissor(false)
	self.m_tRoleAniList = {}
	
	local onlineNum = 0
	for i = 1,#self.m_tMyPupils do 
		local celElement,tCell = CellMasterSeat:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(i-1)    --从0开始设置Tag值
			tableContainer:setCellElement(celElement)
			local tData = self.m_tMyPupils[i]
			if tData.isOnline == true then onlineNum = onlineNum + 1 end
			tCell:setMasterSeat(tData,2,i)
			tCell.m_tParentWnd = self
			table.insert(self.m_tRoleAniList,tCell)
		end 
	end 
	self.m_nOnlineNum = onlineNum

	GetElement(self.m_root,"conDisciple",WZUIContainer):setVisible(true)
	tableContainer:setVisible(true)
	GetElement(self.m_root,"conDepartment",WZUIContainer):setVisible(false)

	local masterInfo = CacheCenter:getMasterInfo()
	--徒弟消耗的活力
	local showText = LocalStrings.MASTERINFO37
	GetElement(self.m_root,"info1_WndMasterMember",WZUIFreeTextBox):setShowText(string.format(showText,masterInfo.addVigor*10))
	--累计获得活力奖励
	local showText1 = LocalStrings.MASTERINFO38
	GetElement(self.m_root,"info2_WndMasterMember",WZUIFreeTextBox):setShowText(string.format(showText1,masterInfo.addVigor))
	--收徒人数
	local showText2 = LocalStrings.MASTERINFO39
	local moralityLevel = masterInfo.moralityLevel
	if moralityLevel == 0 then moralityLevel = 1 end
	local max_pupil = GDatatab_morality["id_"..moralityLevel].max_pupil
	GetElement(self.m_root,"info3_WndMasterMember",WZUIFreeTextBox):setShowText(string.format(showText2,#self.m_tMyPupils.."/"..max_pupil))
end

--@brief	刷新师门界面
function WndMasterMember:updateDepartment()
	WZLog("WndMasterMember:updateDepartment",Serialize(self.m_tMyMaster))
	if self.m_tMyMaster == nil or #self.m_tMyMaster < 1 then return end
	self.m_tRoleAniList = {}
	local tData = self.m_tMyMaster[1]

	local conMaster = GetElement(self.m_root,"conMaster",WZUIContainer)
	if conMaster:getChildByTag(66) then
		conMaster:removeChildByTag(66,true)
	end
	local celElement1,tCell1 = CellMasterSeat:createElement()
	conMaster:addChild(celElement1,66,66)
	tCell1:setMasterSeat(tData,5)
	tCell1.m_tParentWnd = self
	table.insert(self.m_tRoleAniList,tCell1)
	self.m_tMasterElement = celElement1

	for i=2,#self.m_tMyMaster do 
		if tonumber(self.m_tMyMaster[i].weaponId) ~= 0 then
		local con = GetElement(self.m_root,"conDisciple"..(i-1),WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local celElement,tCell = CellMasterSeat:createElement()
		if celElement ~= nil and tCell ~= nil then 
			con:addChild(celElement)
			tData = self.m_tMyMaster[i]
			tCell:setMasterSeat(tData,3)
			tCell1.m_tParentWnd = self
		end 
		end
	end 

	GetElement(self.m_root,"conDisciple",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"tbConRole",WZUITableContainer):setVisible(false)
	GetElement(self.m_root,"conDepartment",WZUIContainer):setVisible(true)
	--设置师门BUFF
	local tData = GDatatab_morality["id_"..self.m_tMyMaster[1].moralityLevel]
	local txt4 = LocalStrings.MASTERINFO40
	local buffInfo = string.format(txt4,tData.pupil_buff[1][2],tData.pupil_buff[2][2],tData.pupil_buff[3][2])
	GetElement(self.m_root,"buff_WndMasterMember",WZUIFreeTextBox):setShowText(buffInfo)
end


-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin----------------------------------------
function WndMasterMember:_adaptLanguage_vn(  )
	for i=1,3 do
		GetElement(self.m_root,"btnRefresh"..i.."_WndMasterHall",WZUILabelTTF):setFontSize(20)
	end
end

function WndMasterMember:_adaptLanguage_en(  )
	GetElement(self.m_root,"info2_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.3,0.048))
	GetElement(self.m_root,"info3_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.8,0.048))
end

function WndMasterMember:_adaptLanguage_pt(  )
	GetElement(self.m_root,"info2_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.3,0.048))
	GetElement(self.m_root,"info3_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.8,0.048))
end

function WndMasterMember:_adaptLanguage_es(  )
	GetElement(self.m_root,"info2_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.3,0.048))
	GetElement(self.m_root,"info3_WndMasterMember",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.8,0.048))
end
--------------------------------------语言适配End------------------------------------------