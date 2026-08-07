--WndAssistSkillData.lua
--@brief	WndAssistSkill的数据模块
--@date		2021/04/19
--@author	XTX
--@note		孩子坐骑辅助技能界面

WndAssistSkill = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAssistSkill:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSkillList = nil 
	self.m_bLoadFinish = false
	self.m_tKidSkillInfo = nil 
	self.m_tMountSkillInfo = nil 
	self.m_oCurSelectSkill = nil 		--当前高亮的skill
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAssistSkill:_unInit()
	self.m_root = nil
	self.m_tSkillList = nil 
	self.m_bLoadFinish = nil 
	self.m_tKidSkillInfo = nil 
	self.m_tMountSkillInfo = nil 
	self.m_oCurSelectSkill = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAssistSkill:createElement()
	if WndAssistSkill.m_root ~= nil then
		WindowManager:removeWindow(WndAssistSkill.m_root, WndAssistSkill, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAssistSkill")
	assert(element, "WndAssistSkill create element failed!")
	self:_init()
	return element
end

--@brief	玩家技能
--@param	id : 玩家技能id
--@param    skillExplain : 技能描述
function WndAssistSkill:receiveGetKidSkillOk(kidSkill)
    if self.m_root == nil then
        return
    end

    self.m_bLoadFinish = false
	self.m_tKidSkillInfo = kidSkill
	self.m_oCurSelectSkill = nil 

	if self.m_bFristLoadFinish then
		self:showSkillInfo(self.m_tKidSkillInfo, 2)
	end
end

--@brief  显示玩家装备的技能道具信息
function WndAssistSkill:showSkillInfo(skillData, nType)
	WZLog("WndAssistSkill:showSkillInfo")
	if skillData.skillId == nil then
		return
	end

	local tbKidSkill
	if nType == 1 then 
		tbKidSkill = WZUITableContainer:luaTo(self.m_root:getChildElement("tbMountSkill_WndAssistSkill"))
		self:_createMountHead()
	elseif nType == 2 then 
		tbKidSkill = WZUITableContainer:luaTo(self.m_root:getChildElement("tbKidSkill_WndAssistSkill"))
		self:_createKidHead()
	end
	tbKidSkill:cleanTable()

    local bIsLock = false
    WZLog("WndAssistSkill:showSkillInfo1",Serialize(skillData.skillId))
    local nIndex = 0
	--已装备技能
    for i,v in ipairs(skillData.skillId) do
		local conPlayerSkill = WZUISystem:getInstance():createElement("conSkill_WndAssistSkill")
		conPlayerSkill:setTag(nIndex)
		GetElement(conPlayerSkill,"imgSelectBg1_WndAssistSkill",WZUI9Image):setTag(nType)
		local imgSkillP = GetElement(conPlayerSkill,"imgSkillP_WndAssistSkill",WZUIImage)
	    local btnSkillCell = GetElement(conPlayerSkill,"btnSkillCell_WndAssistSkill",WZUIButton)
	    btnSkillCell:setTag(i)
		local imgBg_conSkill = GetElement(conPlayerSkill, "imgBg_conSkill", WZUIImage)
		if nType == 1 then 
			imgBg_conSkill:setFile("ui/common/common_zd_dk_zq.png")
		elseif nType == 2 then 
			imgBg_conSkill:setFile("ui/common/common_zd_dk_ww.png")
		end
    	if v ~= -1 and v > 0 then
		    local conActionValue = GetElement(conPlayerSkill,"conActionValue_WndAssistSkill",WZUIContainer)
		    conActionValue:setVisible(true)
		    local lafActionValue = GetElement(conPlayerSkill,"lafActionValue_WndAssistSkill",WZUILabelTTF)
    		local skillInfo = GDatatab_skill["id_"..v]
    		if skillInfo then
    			imgSkillP:setFile(skillInfo.icon)
    			local lvIcon = skillInfo.lv_icon

    			if lvIcon and type(lvIcon) =="string" then
    				local imgSkillLevelIcon = GetElement(conPlayerSkill,"imgSkillLevelIcon_WndAssistSkill",WZUIImage)
    			    if imgSkillLevelIcon ~= nil then
    			    	imgSkillLevelIcon:setFile(lvIcon)
    			    end
    			end
    		end

		    conPlayerSkill:setVisible(true)
		    tbKidSkill:setCellElement(conPlayerSkill)
		    lafActionValue:setText(math.ceil(skillInfo.consume/1000))
		    nIndex = nIndex + 1
		elseif v ~= -1 and v <=0 then
	    	GetElement(conPlayerSkill,"imgRed_WndAssistSkill",WZUIImage):setVisible(true)
		    conPlayerSkill:setVisible(true)
		    tbKidSkill:setCellElement(conPlayerSkill)
		    nIndex = nIndex + 1
		elseif v == -1 then
		    local txtSkillP = GetElement(conPlayerSkill,"txtSkillP_WndAssistSkill",WZUILabelTTF)
		    imgSkillP:setFile("")
        	txtSkillP:setText(skillData.skillExplain[i])

            conPlayerSkill:setVisible(true)
		    tbKidSkill:setCellElement(conPlayerSkill)
		    nIndex = nIndex + 1

		    if ProjConfig.LANGUAGE == "vn" then
		    	txtSkillP:setFontSize(14)
		    end
    	end
    end

	self:showSkillProps(skillData)
	WndSkillContainer:setAssistSkillRed()
end

--@brief 展示所有的技能道具
function WndAssistSkill:showSkillProps(skillData)
    self.m_bLoadFinish = false
    self:showAllSkill(skillData)
end

--@brief  显示所有可以拥有的技能列表
function WndAssistSkill:showAllSkill(skillData)
	WZLog("WndAssistSkill:showAllSkill")
	local skills = {}
	for i,v in ipairs(skillData.unlockSkill) do
		local skillInfo = GDatatab_skill["id_" .. v]
--		WZLog("显示技能", v)
		local id_group  = skillInfo.id_group
		local skillItem = {id = v,status = 2,exp = skillData.unlockSkillNum[i],group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort, sub_type = skillInfo.sub_type}
		table.insert(skills,skillItem)
	end

	for i,v in ipairs(self.m_tSkillList[skillData.key]) do
		local isExit = false
		local skillInfo  = GDatatab_skill["id_" .. v]
		for j,k in ipairs(skills) do
			if k.id == v or skillInfo.id_group == k.group  then
				isExit = true
			end
		end
		
		if not isExit then
			local id_group = skillInfo.id_group
			if skillInfo.specialAttackParam == 1 then
				local skillItem = {id = v,status = 1 ,exp = 0,group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort, sub_type = skillInfo.sub_type}
		        table.insert(skills,skillItem)
			end
		end
	end

    local equipsSkillCount = 0
	for i,v in ipairs(skills) do
		for i1,v1 in ipairs(skillData.skillId) do
			if v1 > 0 and v1 == v.id then
			   v.equip = 5
			   equipsSkillCount = equipsSkillCount + 1
			end
		end
	end
	
	local tAllSkillProps = self:sortSkill(equipsSkillCount, #skillData.unlockSkill, skills)

	
	local tbSkillList = WZUITableContainer:luaTo(self.m_root:getChildElement("tbSkillList_WndAssistSkill"))
	if skillData.key == "mount" then 
		tbSkillList = WZUITableContainer:luaTo(self.m_root:getChildElement("tbMountSkillList_WndAssistSkill"))
	end
	tbSkillList:cleanTable()
	WZLog("全部技能",Serialize(tAllSkillProps))
	for i,v in ipairs(tAllSkillProps) do
		local conSkillInfo = WZUISystem:getInstance():createElement("conSkillInfo_WndAssistSkill")

		local skillTable = GDatatab_skill["id_" .. v.id]
		local bisLock = v.status
		local path = skillTable.icon
        local skillStats = LocalStrings.UNEQUIPPED
        local levelIcon = skillTable.lv_icon
		local ownNum = self:_getOwnSkillNum(skillData, v.id)
        
		if bisLock == 1 or ownNum == 0 then
			skillStats = LocalStrings.LOCKED
		elseif v.equip == 5 then
			skillStats = LocalStrings.EQUIPPED
		end
        conSkillInfo:setVisible(true)
        conSkillInfo:setTag(i-1)

        GetElement(conSkillInfo,"gridId",WZUILabelTTF):setText(skillTable.id)
        local imgSkill  = GetElement(conSkillInfo,"imgSkill_WndAssistSkill",WZUIImage)
		imgSkill:setFile(path)
        local imgSkillLevel = GetElement(conSkillInfo,"imgSkillLevel_WndAssistSkill",WZUIImage)
		if levelIcon ~= nil and type(levelIcon) == "string" then
			imgSkillLevel:setFile(levelIcon)
		end
		local txtLeftNum = GetElement(conSkillInfo,"txtLeftNum_WndAssistSkill", WZUILabelTTF)
		txtLeftNum:setText(ownNum .. "/" .. skillTable.param3)
		
		local imgSkillBg   = GetElement(conSkillInfo,"imgSkillBg_WndAssistSkill",WZUIImage)
		local imgSkillStats   = GetElement(conSkillInfo,"imgSkillStats_WndAssistSkill",WZUIImage)
		imgSkillStats:setVisible(false)
		local imgSelectBg = GetElement(conSkillInfo,"imgSelectBg_WndAssistSkill",WZUI9Image)
		if skillData.key == "mount" then 
			imgSkillBg:setFile("ui/common/common_zd_dk_zq.png")
			imgSelectBg:setTag(1)
		else
			imgSkillBg:setFile("ui/common/common_zd_dk_ww.png")
			imgSelectBg:setTag(2)
		end
		if skillStats == LocalStrings.LOCKED then
			imgSkillBg:setGrayRender(true)
			imgSkill:setGrayRender(true)
			imgSkillLevel:setGrayRender(true)
		elseif skillStats ==LocalStrings.EQUIPPED then
			imgSkillStats:setVisible(true)
		else
			imgSkillBg:setGrayRender(false)
			imgSkill:setGrayRender(false)
			imgSkillLevel:setGrayRender(false)
		end
	    tbSkillList:setCellElement(conSkillInfo)
	end
    self.m_bLoadFinish = true
    self.m_bFristLoadFinish = true
end

--@brief	坐骑辅助技能
--@param	id : 坐骑辅助技能id
--@param    skillExplain : 技能描述
function WndAssistSkill:receiveGetMountSkillOk(mountSkill)
    if self.m_root == nil then
        return
    end

	self.m_tMountSkillInfo = mountSkill
	self.m_oCurSelectSkill = nil 
	
	if self.m_bFristLoadFinish then
		self:showSkillInfo(self.m_tMountSkillInfo, 1)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  查找所有技能存放到table
function WndAssistSkill:initSkills()
	self.m_tSkillList = {}
	for k,v in pairs(GDatatab_skill) do
		if v.skill_type == 6 then
			if self.m_tSkillList.kid == nil then 
				self.m_tSkillList.kid = {}
			end
			table.insert(self.m_tSkillList.kid, v.id)
		elseif v.skill_type == 7 then
			if self.m_tSkillList.mount == nil then 
				self.m_tSkillList.mount = {}
			end
			table.insert(self.m_tSkillList.mount, v.id)
		end
	end
end

--@brief  对道具技能进行排序
--@param  equipsSkillCount : 已装配的道具数量
--@param  openSkillCount：玩家可以使用的道具数量
--@param  skills : 玩家拥有的道具技能列表
function WndAssistSkill:sortSkill(equipsSkillCount, openSkillCount ,skills)
	table.sort(skills,sortSkill_T)
	table.sort(skills,sortSkill_F)

	local equipsSkills = {}  --存放已装备的技能道具列表
	local openSkillList = {}  --存放已开启的技能道具列表
	local sortSkillList ={}  --存放完成排序的技能道具列表
	for i=1,equipsSkillCount do
		table.insert(equipsSkills,skills[i])
	end
	table.sort(equipsSkills,sortSkill_L)

	for i=1,equipsSkillCount do
		table.remove(skills,1)
	end

	local countOpenSkill = openSkillCount - equipsSkillCount
	if countOpenSkill > 0 then
		table.sort(skills,sortSkill_S)

		for i=1,countOpenSkill do
			table.insert(openSkillList,skills[i])
		end

		if countOpenSkill > 1 then
			table.sort(openSkillList,sortSkill_L)
		end
		
		for i=1,countOpenSkill do
			table.remove(skills,1)
		end
	end

	if #skills > 1 then
		table.sort(skills,sortSkill_G)
	end

	for i,v in ipairs(equipsSkills) do
		table.insert(sortSkillList,v)
	end

	for i,v in ipairs(openSkillList) do
		table.insert(sortSkillList,v)
	end

	for i,v in ipairs(skills) do
		table.insert(sortSkillList,v)
	end
	return sortSkillList
end

--@brief 	获取拥有的技能的数量
function WndAssistSkill:_getOwnSkillNum(skillData, skillId)
	-- body
	local ownNum = 0
	for i, v in pairs(skillData.unlockSkill) do
		if v == skillId then 
			ownNum = skillData.unlockSkillNum[i]
			break 
		end
	end

	return ownNum
end
-------------------------------------私有方法模块End----------------------------------------
