 --WndSkillPropData.lua
--@brief	WndSkillProp的数据模块
--@date		2013/12/27
--@author	李光森
--@note		房间中技能道具窗口

WndSkillProp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSkillProp:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tPlayerSkillInfo = {}        --存放玩家拥有的技能数据
	self.m_nPlayerSkillLoadingId = nil
	self.m_tAllSkillProps = {}          --所有的技能道具   
	self.m_nBuySkillId = nil            --需要购买的技能id
	self.m_bIsVisitNet = false          --是否正在访问网络
	self.m_bLoadFinish = false
	self.m_tMoveElementP = nil          --记录滑动屏幕的位置
	self.m_nCurShowSkillId = nil        --当前显示的技能ID
	self.m_oCurSelectSkill = nil        --记录当前显示的技能对象
	self.m_nUpdateLevelSkillId = nil    --当前技能升级后的技能ID
	self.m_tSkillList = {}
	self.m_bClickUpgrade = false        --是否点击了技能升级按钮
	self.m_vItemIds = nil
	self.m_vItemExp = nil
	self.m_bFristLoadFinish = false
	self.m_bPlayUpdateAction = false       --是否正在播放升级动画
	self.mode = nil
	self.upTip = 0
	self.learnTip = nil 
	self.m_tBtnEquipCell = nil 			--装备列表中的Cell的按钮节点
	self.m_tBtnActivitySkillNode = nil 			--激活的技能列表中的Cell的按钮节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkillProp:_unInit()
	self.m_root = nil
	self.m_tPlayerSkillInfo = nil
	self.m_tAllSkillProps = nil
	self.m_nPlayerSkillLoadingId = nil
	self.m_nBuySkillId = nil
	self.m_bIsVisitNet = nil
	self.m_tMoveElementP = nil
	self.m_bLoadFinish = nil
	self.m_tSkillList = nil
	self.m_nUpdateLevelSkillId = nil
	self.m_oCurSelectSkill = nil
	self.m_nCurShowSkillId = nil
	self.m_bClickUpgrade = nil
	self.m_vItemIds = nil
	self.m_vItemExp = nil
	self.m_bFristLoadFinish = nil
	self.m_bPlayUpdateAction = nil
	self.mode = nil
	self.m_nWinType = nil 					--窗口类型1:技能,2:道具
	self.upTip = 0
	self.learnTip = nil 
	self.m_tBtnEquipCell = nil 			--装备列表中的Cell的按钮节点
	self.m_tBtnActivitySkillNode = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSkillProp:createElement()
	local element = WZUISystem:getInstance():createElement("WndSkillProp")
	assert(element, "WndSkillProp create element failed!")
	self:_init()
	return element
end

--@brief	玩家技能
--@param	id : 玩家技能id
--@param    skillExplain : 技能描述
function WndSkillProp:receiveGetPlayerSkillOk(id,skillExplain)
    if self.m_root == nil then
        return
    end
    if self.m_nPlayerSkillLoadingId ~= nil then
    	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nPlayerSkillLoadingId)
    	self.m_nPlayerSkillLoadingId = nil
    end
    self.m_bLoadFinish = false
--	WZLog("WndSkillProp:receiveGetPlayerSkillOk ", debug.traceback())
    local conMiddle = GetElement(self.m_root,"conMiddle_WndSkillProp",WZUIContainer)
    conMiddle:setTouchEnable(false)
    conMiddle:setVisible(true)
	self.m_tPlayerSkillInfo = {skillId = id ,skillExplain = skillExplain}
	
	if self.m_bFristLoadFinish then
		self:showSkillInfo()
	end
end

--@brief  显示玩家装备的技能道具信息
function WndSkillProp:showSkillInfo()
	WZLog("WndSkillProp:showSkillInfo")
	if self.m_tPlayerSkillInfo.skillId == nil  then
		return
	end
	--self.m_root:disableSchedule()
	local tbPlayerSkills = WZUITableContainer:luaTo(self.m_root:getChildElement("tabPlayerSkills_WndSkillProp"))
	tbPlayerSkills:cleanTable()

    local bIsLock = false
    WZLog("WndSkillProp:showSkillInfo1",Serialize(self.m_tPlayerSkillInfo.skillId))
    local nIndex = 0
    self.m_tBtnEquipCell = {}
	--已装备技能
    for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
    	if v ~= -1 and v > 0 then
    		local conPlayerSkill = WZUISystem:getInstance():createElement("conSkill_WndSkillProp")
			conPlayerSkill:setTag(nIndex)
			conPlayerSkill:setScale(0.84)
		    local imgSkillP = GetElement(conPlayerSkill,"imgSkillP_WndSkillProp",WZUIImage)
		    
		    local btnSkillCell = GetElement(conPlayerSkill,"btnSkillCell_WndSkillProp",WZUIButton)
		    local conActionValue = GetElement(conPlayerSkill,"conActionValue_WndSkillProp",WZUIContainer)
		    conActionValue:setVisible(true)
		    local lafActionValue = GetElement(conPlayerSkill,"lafActionValue_WndSkillProp",WZUILabelAtlasFont)
		    btnSkillCell:setTag(i)
    		local skillInfo = GDatatab_skill["id_"..v]
    		if skillInfo then
    			imgSkillP:setFile(skillInfo.icon)
    			local lvIcon = skillInfo.lv_icon

    			if lvIcon and type(lvIcon) =="string" then
    				local imgSkillLevelIcon = GetElement(conPlayerSkill,"imgSkillLevelIcon_WndSkillProp",WZUIImage)
    			    if imgSkillLevelIcon ~= nil then
    			    	imgSkillLevelIcon:setFile(lvIcon)
    			    end
    			end
    		end
		   
	        if i == 1 and v > 0  then
	            self.m_biSkillEquip = true
	        elseif i == 1 and v <= 0  then
	            self.m_biSkillEquip = nil
	        end
		    conPlayerSkill:setVisible(true)
		    tbPlayerSkills:setCellElement(conPlayerSkill)
		    lafActionValue:setText(math.ceil(skillInfo.consume/1000))
		    nIndex = nIndex + 1

		    table.insert(self.m_tBtnEquipCell, btnSkillCell)
    	end
    end

	--空技能
    for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
    	if v ~= -1 and v <=0 then
    		local conPlayerSkill = WZUISystem:getInstance():createElement("conSkill_WndSkillProp")
			conPlayerSkill:setTag(nIndex)
			conPlayerSkill:setScale(0.84)
		    local imgSkillP = GetElement(conPlayerSkill,"imgSkillP_WndSkillProp",WZUIImage)
		    
		    local btnSkillCell = GetElement(conPlayerSkill,"btnSkillCell_WndSkillProp",WZUIButton)
		    btnSkillCell:setTag(i)
		    
	    	GetElement(conPlayerSkill,"imgRed_WndSkillProp",WZUIImage):setVisible(true)
	        if i == 1 and v > 0  then
	            self.m_biSkillEquip = true
	        elseif i == 1 and v <= 0  then
	            self.m_biSkillEquip = nil
	        end
		    conPlayerSkill:setVisible(true)
		    tbPlayerSkills:setCellElement(conPlayerSkill)
		    nIndex = nIndex + 1

		    table.insert(self.m_tBtnEquipCell, btnSkillCell)
    	end
    end

	--未开放技能
	for i,v in ipairs(self.m_tPlayerSkillInfo.skillId) do
		if v == -1 then
			local conPlayerSkill = WZUISystem:getInstance():createElement("conSkill_WndSkillProp")
			conPlayerSkill:setTag(nIndex)
			conPlayerSkill:setScale(0.84)
		    local imgSkillP = GetElement(conPlayerSkill,"imgSkillP_WndSkillProp",WZUIImage)
		    local txtSkillP = GetElement(conPlayerSkill,"txtSkillP_WndSkillProp",WZUILabelTTF)
		    local btnSkillCell = GetElement(conPlayerSkill,"btnSkillCell_WndSkillProp",WZUIButton)
		    btnSkillCell:setTag(i)
		    imgSkillP:setFile("")
        	txtSkillP:setText(self.m_tPlayerSkillInfo.skillExplain[i])

        	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or 
        		ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "pt" then
        		txtSkillP:setFontSize(18)
        	elseif ProjConfig.LANGUAGE == "vn" then
                txtSkillP:setFontSize(23)
            elseif ProjConfig.LANGUAGE == "th" then
            	txtSkillP:setFontSize(20)
        	end

            conPlayerSkill:setVisible(true)
		    tbPlayerSkills:setCellElement(conPlayerSkill)
		    nIndex = nIndex + 1

		    table.insert(self.m_tBtnEquipCell, btnSkillCell)
		end
	end

	local skillList = CacheCenter:getSkillList()
	if self.m_nWinType == 1 then
		local tData = CacheCenter:getSkill()
		skillList = {itemId=tData.unlockSkill,expv=tData.expv}
		GetElement(self.m_root,"txtPoint",WZUILabelTTF):setText(tData.skillNum)
	elseif self.m_nWinType == 2 then
		skillList = CacheCenter:getSkillList()
	end
	if skillList ~= nil then
		self:showSkillProps(skillList.itemId,skillList.expv)
	end

	self:updateLog()
end

--@brief  是否有空的技能栏
function WndSkillProp:hasNullCell()
	WZLog("WndSkillProp:hasNullCell")
	local playerSkill = CacheCenter:getPlayerSkill()
	for i,v in ipairs(playerSkill.skillId) do
		if v == 0 then
		    return true
	    end
	end
	return false
end

function sortSkill_T(a,b)
	if GDatatab_skill["id_" .. a.id].sort < GDatatab_skill["id_" .. b.id].sort then
		return true
	else
		return false
	end
end

--根据道具技能是否已装备
function sortSkill_F(a,b)
	if a.equip > b.equip then
	    return true
    end

    return false
end

--根据已装备的道具技能进行排序
function sortSkill_L(a,b)
	if a.level > b.level then
		return true
	end
	return false
end

--根据道具技能是否已开启进行排序
function sortSkill_S(a,b)
	if a.status > b.status then
		return true
	end
	return false
end

--如果道具没有装配和开启则按照等级开放排序
function sortSkill_G(a,b)
	if a.sort < b.sort then
		return true
	else
		return false
	end
	-- if a.hdtj == 1 and b.hdtj == 1 then
	-- 	if a.hdtjcs < b.hdtjcs then
	-- 	    return true
	-- 	else
	-- 		return false
	-- 	end
	-- end

	-- if type(a.hdtjcs) == "number" and type(b.hdtjcs) =="table"  then
	-- 	return true
	-- end
end

--@brief  查找所有技能存放到table
function WndSkillProp:initSkills()
	local skill_type = 1
	if self.m_nWinType == 1 then
		skill_type = 0
	elseif self.m_nWinType == 2 then
		skill_type = 1
	end

	self:setDisplay()

	self.m_tSkillList = {}
	for k,v in pairs(GDatatab_skill) do
		if v.skill_type == skill_type then
			if self.m_nWinType == 1 and v.id_group ~= 108 and v.id_group ~= 109 and v.target_type ~= -1 then
				table.insert(self.m_tSkillList,v.id)
			elseif self.m_nWinType == 2 then
				table.insert(self.m_tSkillList,v.id)
			end
		end
	end
end


--@brief 重置当前选中的ID
function WndSkillProp:resertCurSelectId()
	self.m_nUpdateLevelSkillId = nil
end

--@brief  对道具技能进行排序
--@param  equipsSkillCount : 已装配的道具数量
--@param  openSkillCount：玩家可以使用的道具数量
--@param  skills : 玩家拥有的道具技能列表
function WndSkillProp:sortSkill(equipsSkillCount,openSkillCount ,skills)
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


--@brief 展示所有的技能道具
function WndSkillProp:showSkillProps(itemId,expv)
    --WZLog("WndSkillProp:showSkillProps = ",Serialize(itemId))
    if self.m_nPlayerSkillLoadingId ~= nil then
    	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nPlayerSkillLoadingId)
    	self.m_nPlayerSkillLoadingId = nil
    end
    self.m_bLoadFinish = false
    self.m_tTempSaveAllSkill = {itemId = itemId,expv = expv}
    GetElement(self.m_root,"conMiddle_WndSkillProp",WZUIContainer):setTouchEnable(false)
    self:showAllSkill()
end

--@brief  显示所有可以拥有的技能列表
function WndSkillProp:showAllSkill()
	WZLog("WndSkillProp:showAllSkill",type(self.mode),self.mode )
	 if self.m_bClickUpgrade then
    	self.m_vItemIds = self.m_tTempSaveAllSkill.itemId
	    self.m_vItemExp = self.m_tTempSaveAllSkill.expv
    	local con = GetElement(self.m_root,"con_WndSkillProp",WZUIContainer)
    	local child = con:getChildByTag(1102)
    	if child ~= nil then
    		con:removeChildByTag(1102,true)
    	end
    	local skillUpgrade = WZUISpine:create()
    	skillUpgrade:setTouchEnable(false)
    	skillUpgrade:setFileJson("ui/skill_daojushenji.json")
    	skillUpgrade:setFileAtlas("ui/skill_daojushenji.atlas")
    	skillUpgrade:setAnimationName("effect")
    	skillUpgrade:setLuaSpineEventFunc("event")
    	skillUpgrade:setUseOriginSize(true)
    	skillUpgrade:setRelativePosition(GlobalMethod:ccp(0.492268,0.659259))
    	skillUpgrade:setTag(1102)
    	con:addChild(skillUpgrade)
    	self.m_bPlayUpdateAction = true
    	SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
    	return 
    end

    if self.m_nUpdateLevelSkillId ~= nil then
    	self.m_nCurShowSkillId = self.m_nUpdateLevelSkillId
    	self.m_nUpdateLevelSkillId = nil
    end
	local skills = {}
	for i,v in ipairs(self.m_tTempSaveAllSkill.itemId) do
		local skillInfo = GDatatab_skill["id_" .. v]
		WZLog("显示技能", v)
		local id_group  = skillInfo.id_group
		local skillItem = {id = v,status = 2,exp = self.m_tTempSaveAllSkill.expv[i],group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort}
		table.insert(skills,skillItem)
	end

	for i,v in ipairs(self.m_tSkillList) do
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
				local skillItem = {id = v,status = 1 ,exp = 0,group = id_group,equip=4,hdtj=skillInfo.hdtj,hdtjcs=skillInfo.hdtjcs,level=skillInfo.specialAttackParam,sort=skillInfo.sort}
		        table.insert(skills,skillItem)
			end
		end
	end

    local equipsSkillCount = 0
	for i,v in ipairs(skills) do
		for i1,v1 in ipairs(self.m_tPlayerSkillInfo.skillId) do
			if v1==v.id then
			   v.equip = 5
			   equipsSkillCount = equipsSkillCount + 1
			end
		end
	end
	
	self.m_tAllSkillProps = self:sortSkill(equipsSkillCount,#self.m_tTempSaveAllSkill.itemId,skills)

	
    local bEquipped = false
	local tbSkillList = WZUITableContainer:luaTo(self.m_root:getChildElement("tbSkillList_WndSkillProp"))
	self.m_tBtnActivitySkillNode = {}
	if self.mode ~= "edit" then 
		tbSkillList:cleanTable()
	end
	--WZLog("全部技能",Serialize(self.m_tAllSkillProps))
	for i,v in ipairs(self.m_tAllSkillProps) do
		local conSkillInfo

		if self.mode ~= "edit" then
			conSkillInfo = WZUISystem:getInstance():createElement("conSkillInfo_WndSkillProp")
			conSkillInfo:setScale(0.84)
		else
			local gridId 
			for j=0,30 do
				conSkillInfo = tbSkillList:getCellElement(j)
        		conSkillInfo = WZUIContainer:luaTo(conSkillInfo)
				conSkillInfo:setScale(1)
				if conSkillInfo ~= nil then
					gridId = GetElement(conSkillInfo,"gridId",WZUILabelTTF):getText()
					if tonumber(gridId) == v.id or (GDatatab_skill["id_"..gridId].upgrade_id == v.id) then
						break
					end
				end
			end
		end

		local skillTable = GDatatab_skill["id_" .. v.id]
		local bisLock = v.status
		local path = skillTable.icon
		
        local name = skillTable.name
        local explain = skillTable.tool_desc
        local skillStats = LocalStrings.UNEQUIPPED
        local openTip = skillTable.tj_desc
        local openType  = skillTable.hdtj
        local vipLevel = skillTable.hdtjcs
        local levelIcon = skillTable.lv_icon
        
		GetElement(conSkillInfo,"gridId",WZUILabelTTF):setText(skillTable.id)
		if bisLock == 1 then
			skillStats = LocalStrings.LOCKED
		elseif v.equip == 5 then
			skillStats = LocalStrings.EQUIPPED
		end
        conSkillInfo:setVisible(true)
		if self.mode ~= "edit" then
        	conSkillInfo:setTag(i-1)
		end
        local imgSkill  = GetElement(conSkillInfo,"imgSkill_WndSkillProp",WZUIImage)
		imgSkill:setFile(path)
        local imgSkillLevel = GetElement(conSkillInfo,"imgSkillLevel_WndSkillProp",WZUIImage)
		if levelIcon ~= nil and type(levelIcon) == "string" then
			imgSkillLevel:setFile(levelIcon)
		end
		
		local imgSkillBg   = GetElement(conSkillInfo,"imgSkillBg_WndSkillProp",WZUIImage)
		local imgSkillStats   = GetElement(conSkillInfo,"imgSkillStats_WndSkillProp",WZUIImage)
		imgSkillStats:setVisible(false)
		local imgSelectBg = GetElement(conSkillInfo,"imgSelectBg_WndSkillProp",WZUI9Image)
		if skillStats == LocalStrings.LOCKED then
			imgSkillBg:setGrayRender(true)
			imgSkill:setGrayRender(true)
			imgSkillLevel:setGrayRender(true)
		elseif skillStats ==LocalStrings.EQUIPPED then
			imgSkillStats:setVisible(true)
			if i == 1 and self.m_nCurShowSkillId == nil then
				bEquipped = true
			elseif v.id == self.m_nCurShowSkillId then
				bEquipped = true
			end
		else
			imgSkillBg:setGrayRender(false)
			imgSkill:setGrayRender(false)
			imgSkillLevel:setGrayRender(false)
		end
		if skillStats ~= LocalStrings.LOCKED then
			local btnSkillInfo = GetElement(conSkillInfo, "btnSkillInfo_WndSkillProp", WZUIButton)
			table.insert(self.m_tBtnActivitySkillNode, btnSkillInfo)
		end
		if self.mode ~= "edit" then
	    	tbSkillList:setCellElement(conSkillInfo)
		end 
	    if self.m_nCurShowSkillId == nil and i == 1 then
	    	imgSelectBg:setVisible(true)
	    	self.m_oCurSelectSkill = imgSelectBg
	    elseif self.m_nCurShowSkillId ~= nil and (v.id == self.m_nCurShowSkillId or v.id == GDatatab_skill["id_"..self.m_nCurShowSkillId].upgrade_id) then
	    	imgSelectBg:setVisible(true)
	    	self.m_oCurSelectSkill = imgSelectBg
	    end
	    local imgRed   = GetElement(conSkillInfo,"imgRed_conSkillInfo",WZUIImage)
	    imgRed:setVisible(false)
	    if CacheCenter:bContinue() then
	    	if self:skillCanActivation(v.id) then
			    imgRed:setVisible(true)
			elseif self:skillCanUpdate(v.id) then
			    imgRed:setVisible(true)
				--技能可升级不显示红点
				if self.m_nWinType == 1 then
			    	imgRed:setVisible(false)
				end
		    end
	    end
	end
    self.m_bLoadFinish = true
    self.m_bFristLoadFinish = true
	if self.m_tMoveElementP ~= nil and #self.m_tMoveElementP > 0 then
	   local tbSkillList = GetElement(self.m_root,"tbSkillList_WndSkillProp",WZUITableContainer)
	   tbSkillList:getMoveElement():setPosition(GlobalMethod:ccp(self.m_tMoveElementP[1],self.m_tMoveElementP[2]))
	end
    
    if self.m_nCurShowSkillId == nil then
    	local skillInfo = self.m_tAllSkillProps[1]
	    self:showSkillDetailInfo(skillInfo.id,bEquipped,true)
	else
		local bActive = false
		for i,v in ipairs(self.m_tTempSaveAllSkill.itemId) do
			if v == self.m_nCurShowSkillId then
				bActive = true
			end
		end
		self:showSkillDetailInfo(self.m_nCurShowSkillId,bEquipped,bActive)
    end
	
	GetElement(self.m_root,"conMiddle_WndSkillProp",WZUIContainer):setTouchEnable(true)
    self.m_bIsVisitNet = false
    self.m_tTempSaveAllSkill.itemId = {}

    
    local isHaveSkill = 0
    for k,v in pairs(CacheCenter.m_tSkill.useSkill) do
    	if v > 0 then
    		isHaveSkill = isHaveSkill + 1
    	end
    end

    local isHaveProp = 0
    for k,v in pairs(CacheCenter:getPlayerSkill().skillId) do
    	if v > 0 then
    		isHaveProp = isHaveProp + 1
    	end
    end

    if self.mode == "edit" then
    	self:_dealwithSkillAni(true)
	end 

    WZLog("WndSkillProp:showAllSkill2", isHaveSkill, isHaveProp, tostring(self.m_bIsActionEnd))

    if isHaveSkill <= 3 and self.m_bIsActionEnd == true then
    	TeachGroup1:startGroup({5,4,WndSkillProp.m_root})
    elseif isHaveProp <= 0 and self.m_bIsActionEnd == true then
        TeachGroup1:startGroup({5,6,WndSkillContainer.m_root})
    else
        TeachGroup1:startGroup({5,9,WndSkillProp.m_root})
    end

end

--@brief	选择道具失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndSkillProp:changePropError(nFlag,sMessage)
	self.m_bIsVisitNet = false
	if self.m_nPlayerSkillLoadingId ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nPlayerPropLoadingId)
		self.m_nPlayerSkillLoadingId = nil
	end
	MsgBoxManager:showTipBox(sMessage)
end

--@brief	选择技能失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndSkillProp:changeSkillError(nFlag,sMessage)
	if self.m_nPlayerSkillLoadingId ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nPlayerSkillLoadingId)
		self.m_nPlayerSkillLoadingId = nil
	end
	MsgBoxManager:showTipBox(sMessage)
	self.m_bIsVisitNet = false
end

--@brief  显示技能道具详细信息
--@param skillId : 技能ID
--@param bEquipped : 是否已装备
--@param bActive : 是否已激活
function WndSkillProp:showSkillDetailInfo(skillId,bEquipped,bActive)
	WZLog("WndSkillProp:showSkillDetailInfo = ",skillId,bEquipped,bActive)
	if skillId  then
		self.m_nCurShowSkillId = skillId
		local skillInfo = GDatatab_skill["id_" .. skillId]
		if skillInfo then
			local imageIcon = GetElement(self.m_root,"imgSkillPg_WndSkillProp",WZUIImage)

			--消耗道具
			if skillInfo.upgrade ~= nil and type(skillInfo.upgrade) == "table" then
				GetElement(self.m_root,"imgSP",WZUIImage):setFile(GDatatab_item["id_"..skillInfo.upgrade[1][1]].icon)
			end
			
			--预览图片
			if skillInfo.image ~= -1 then
				GetElement(self.m_root,"imgPreview",WZUIImage):setFile("ui/skill/"..skillInfo.image)
			end

			local txtSkillName = GetElement(self.m_root,"txtSkillName_WndSkillProp",WZUILabelTTF)
			local lafActionValue3 = GetElement(self.m_root,"lafActionValue3_WndSkillProp",WZUILabelAtlasFont)
			local lafActionValue6 = GetElement(self.m_root,"lafActionValue6_WndSkillProp",WZUILabelAtlasFont)
			local txtCTV1 = GetElement(self.m_root,"txtCTV1_WndSkillProp",WZUILabelAtlasFont)
			local txtCTV2 = GetElement(self.m_root,"txtCTV2_WndSkillProp",WZUILabelAtlasFont)
			local txtSkillDescribe1 = GetElement(self.m_root,"txtSkillDescribe1_WndSkillProp",WZUILabelTTF)
			local txtSkillDescribe2 = GetElement(self.m_root,"txtSkillDescribe2_WndSkillProp",WZUILabelTTF)
		    local txtCDT1 = GetElement(self.m_root,"txtCDT1_WndSkillProp",WZUILabelTTF)
		    local txtCDT2 = GetElement(self.m_root,"txtCDT2_WndSkillProp",WZUILabelTTF)
		    local txtSkillStatus = GetElement(self.m_root,"txtSkillStatus_WndSkillProp",WZUILabelTTF)
		    local txtSkillStatusSel = GetElement(self.m_root,"txtSkillStatusSel_WndSkillProp",WZUILabelTTF)

		    local conGet = GetElement(self.m_root,"conGet_WndSkillProp",WZUIContainer)
		    local conUpdateLevel = GetElement(self.m_root,"conUpdateLevel_WndSkillProp",WZUIContainer)
		    local conSkillUse = GetElement(self.m_root,"conSkillUse_WndSkillProp",WZUIContainer)
		    local conSkillActivation = GetElement(self.m_root,"conSkillActivation_WndSkillProp",WZUIContainer)
		    --conSkillUse:setRelativePosition(GlobalMethod:ccp(0.741935,0.5))

            local conBtnList = GetElement(self.m_root,"conBtnList_WndSkillProp",WZUIContainer)
            local proSkill =GetElement(self.m_root,"proSkill_WndSkillProp",WZUIProgress)
            local imgItemBg = GetElement(self.m_root,"imgItemBg_WndSkillProp",WZUIImage)
            local txtNumber = GetElement(self.m_root,"txtNumber_WndSkillProp",WZUILabelTTF)
            txtNumber:setText("")

		    imageIcon:setFile(skillInfo.icon)
		    local lvIcon = skillInfo.lv_icon
		    local imgSkillL = GetElement(self.m_root,"imgSkillL_WndSkillProp",WZUIImage)
		    if lvIcon ~= nil and type(lvIcon) == "string" then
				imgSkillL:setFile(lvIcon)
				--技能等级
				GetElement(self.m_root,"value1_WndSkillProp",WZUILabelTTF):setText(string.sub(lvIcon,-5,-5))
				GetElement(self.m_root,"value4_WndSkillProp",WZUILabelTTF):setText(string.sub(lvIcon,-5,-5)+1)
			else
				imgSkillL:setFile("")
		    end
		    txtSkillName:setText(skillInfo.name)
		    lafActionValue3:setText(math.ceil(skillInfo.consume/1000))
		    txtSkillDescribe1:setText(LocalStrings.NEWSKILL4..skillInfo.tool_desc)
		    local startTime = skillInfo.cooling_time
		    if startTime >=1000 then
		    	txtCDT1:setVisible(true)
		    	txtCDT2:setVisible(true)
		    	local startTime = startTime / 1000
		    	txtCTV1:setText( startTime )
		    	txtCTV2:setText( startTime )
				GetElement(self.m_root,"conCd1",WZUIContainer):setVisible(true)
				GetElement(self.m_root,"conCd2",WZUIContainer):setVisible(true)
		    else
		    	txtCDT1:setVisible(false)
		    	txtCDT2:setVisible(false)
		    	txtCTV1:setText("")
		    	txtCTV2:setText("")
				GetElement(self.m_root,"conCd1",WZUIContainer):setVisible(false)
				GetElement(self.m_root,"conCd2",WZUIContainer):setVisible(false)
		    end

		    if bEquipped then
		    	txtSkillStatus:setText(LocalStrings.UNROYAL)
		    	txtSkillStatusSel:setText(LocalStrings.UNROYAL)
		    elseif bActive then
		    	txtSkillStatus:setText(LocalStrings.USE)
		    	txtSkillStatusSel:setText(LocalStrings.USE)
		    end

		    if bEquipped or bActive then  
		    	conBtnList:setVisible(true)
		    	conSkillActivation:setVisible(false)
		    	conSkillUse:setVisible(true)
		    	if type(skillInfo.upgrade) == "table" then
		    		imgItemBg:setFile(GDatatab_item["id_" .. (skillInfo.upgrade[1][1])].icon)
		    	end
		    	
		    	local upgrade = skillInfo.upgrade --是否可以升级
		    	for i,v in ipairs(self.m_tAllSkillProps) do
		    		if v.id == skillId then
		    			if skillInfo.upgrade_id > 0 and type(upgrade) == "table" then
							self:setSkillState(2)
		    				txtNumber:setText( v.exp .. "/" .. upgrade[1][2]) --展示升级所需物品数量
							GetElement(self.m_root,"cost1_WndSkillProp",WZUILabelTTF):setText(upgrade[1][2])
			    			if v.exp >= upgrade[1][2] then
			    				proSkill:setPercentage(100)
			    				conUpdateLevel:setVisible(true)
			    				conGet:setVisible(false)
			    			else
			    				local per = v.exp / upgrade[1][2]
			    				proSkill:setPercentage(per*100)
			    				conUpdateLevel:setVisible(false)
			    				conGet:setVisible(true)
			    			end
							--下一级信息
							local nextSkillId = skillInfo.upgrade_id
							local skillInfo2 = GDatatab_skill["id_"..nextSkillId]
		    				local startTime = skillInfo2.cooling_time
		    				if startTime >=1000 then
		    					txtCDT2:setVisible(true)
		    					local startTime = startTime / 1000
		    					txtCTV2:setText( startTime )
								GetElement(self.m_root,"conCd2",WZUIContainer):setVisible(true)
		    				else
		    					txtCDT2:setVisible(false)
		    					txtCTV2:setText("")
								GetElement(self.m_root,"conCd2",WZUIContainer):setVisible(false)
		    				end
		    				txtSkillDescribe2:setText(LocalStrings.NEWSKILL4..skillInfo2.tool_desc)
		    				lafActionValue6:setText(math.ceil(skillInfo2.consume/1000))
			    		--elseif skillInfo.hdtjcs == 0 and skillInfo.upgrade == -1 then
			    		elseif skillInfo.upgrade == -1 then
							self:setSkillState(3)
			    			txtNumber:setText("") 
			    			proSkill:setPercentage(100)
			    			conUpdateLevel:setVisible(true)
			    			conGet:setVisible(false)
			    			local preSkillID =skillId -1
			    			local preSkillInfo = GDatatab_skill["id_" .. preSkillID ]
							if preSkillInfo ~= nil then
			    				imgItemBg:setFile(GDatatab_item["id_" .. (preSkillInfo.upgrade[1][1])].icon)
							end
		    			end
		    		end
		    	end
		    end

		    if not bActive then  --未激活 
		    	local openType  = skillInfo.hdtj  --根据激活类型显示不同的按钮
		    	if openType == 1 then  --到等级自动激活道具
					self:setSkillState(0)
					GetElement(self.m_root,"tip2",WZUILabelTTF):setText(skillInfo.tj_desc)
		    		conBtnList:setVisible(false)
		    	elseif openType == 2 then
					self:setSkillState(1)
		    		local hdtjcs = skillInfo.hdtjcs
		    		local bFPoss = false
		    		local bSPoss = false
		    		for i,v in ipairs(hdtjcs) do
		    			local itemCount = CacheCenter:getPlayerItemCountById(v[1]) 
		    			if itemCount >= v[2] and i == 1 then
		    				bFPoss = true
		    			end
		    			if itemCount >= v[2] and i == 2 then
		    				bSPoss = true
		    			end
		    		end
		    		local itemCount = nil
		    		if bSPoss then
		    			itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[2][1])
                        imgItemBg:setFile(GDatatab_item["id_"..hdtjcs[2][1]].icon)
                        proSkill:setPercentage(100)
                        txtNumber:setText(itemCount .. "/" ..hdtjcs[2][2])
						GetElement(self.m_root,"cost1_WndSkillProp",WZUILabelTTF):setText(hdtjcs[2][2])
                    elseif bFPoss then
                    	itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[1][1])
                    	imgItemBg:setFile(GDatatab_item["id_"..hdtjcs[1][1]].icon)
                        proSkill:setPercentage(100)
                        txtNumber:setText(itemCount .. "/" ..hdtjcs[1][2])
						GetElement(self.m_root,"cost1_WndSkillProp",WZUILabelTTF):setText(hdtjcs[1][2])
                    else
                    	local hSecondItem = false  --优先消耗第二个物品
                    	if hdtjcs[2] ~= nil then
                    		hSecondItem = true
                    	end

                    	if hSecondItem then
                    		imgItemBg:setFile(GDatatab_item["id_"..hdtjcs[2][1]].icon)
		                    itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[2][1]) 
		                    local pro = itemCount / hdtjcs[2][2]
		                    proSkill:setPercentage(pro*100)
		                    txtNumber:setText(itemCount .. "/" ..hdtjcs[2][2])
							GetElement(self.m_root,"cost1_WndSkillProp",WZUILabelTTF):setText(hdtjcs[2][2])
                    	else
                    		imgItemBg:setFile(GDatatab_item["id_"..hdtjcs[1][1]].icon)
		                    itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[1][1]) 
		                    local pro = itemCount / hdtjcs[1][2]
		                    proSkill:setPercentage(pro*100)
		                    txtNumber:setText(itemCount .. "/" ..hdtjcs[1][2])
							GetElement(self.m_root,"cost1_WndSkillProp",WZUILabelTTF):setText(hdtjcs[1][2])
                    	end
		    		end
		    		
		    		conGet:setVisible(false)
		    		conUpdateLevel:setVisible(false)
		    		conSkillUse:setVisible(false)
		    		conSkillActivation:setVisible(true)
		    		conBtnList:setVisible(true)
		    	end
		    end
		    
		    if skillId == 61 then  --飞行道具特殊处理
		    	GetElement(self.m_root,"conExp_WndSkillProp",WZUIContainer):setVisible(false)
	    		conGet:setVisible(false)
	    		conUpdateLevel:setVisible(false)
	    		conSkillActivation:setVisible(false)
	    		conSkillUse:setVisible(true)
	    		conSkillUse:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		    end
		    local imgMaxLevel = GetElement(self.m_root,"imgMaxLevel_WndSkillProp",WZUIImage)
		    if skillInfo.upgrade_id == -1 and (bEquipped or bActive) and skillInfo.id ~= 61 then
		    	
		    	imgMaxLevel:setVisible(false)
		    else
		    	imgMaxLevel:setVisible(false)
		    end

			conSkillUse:setVisible(false)
		end
	end
end

--@brief 获取技能是否可以进行升级
--@param skillId:技能ID
function WndSkillProp:skillCanUpdate(skillId, skillProps)
	if skillId then
		if self.m_nWinType == 1 then
        	skillProps = skillProps == nil and self.m_tAllSkillProps or skillProps
			local skillInfo = GDatatab_skill["id_" .. skillId]
			local skillNum = CacheCenter:getSkill().skillNum
			local needNum = GDatatab_skill["id_" .. skillId].upgrade

			for i,v in ipairs(skillProps) do
    			if v.id == skillId then
					if v.status == 2 and skillInfo.upgrade_id > 0 and type(needNum) == "table" and skillNum >= needNum[1][2] then
	    				return true
	    			else
	    				return false
    				end
    			end
			end
			return false
		end

        skillProps = skillProps == nil and self.m_tAllSkillProps or skillProps
		local skillInfo = GDatatab_skill["id_" .. skillId]
		local upgrade = skillInfo.upgrade --是否可以升级
		for i,v in ipairs(skillProps) do
    		if v.id == skillId then
    			if skillInfo.upgrade_id > 0 and type(upgrade) == "table" then
	    			if v.exp >= upgrade[1][2] then
	    				return true
	    			end
	    		else
	    			return false
    			end
    		end
		end
	end
end

--@brief  技能是否已激活
function WndSkillProp:skillHadActivation(skillId, skillProps)
    skillProps = skillProps == nil and self.m_tAllSkillProps or skillProps
	for i,v in ipairs(skillProps) do
		if skillId == v.id then
			if v.status == 1 then
				return false
			else
				return true
			end
		end
	end
end

--@brief 判断技能道具是否可激活
--@param skillId:技能ID
--@param bActive:是否已激活
function WndSkillProp:skillCanActivation(skillId, skillProps)
	if skillId then
		if self.m_nWinType == 1 then
        	skillProps = skillProps == nil and self.m_tAllSkillProps or skillProps
			local skillInfo = GDatatab_skill["id_" .. skillId]
			local skillNum = CacheCenter:getSkill().skillNum
			local needNum = GDatatab_skill["id_" .. skillId].hdtjcs

			for i,v in ipairs(skillProps) do
    			if v.id == skillId then
					if v.status == 1 and type(needNum) == "table" and skillNum >= needNum[1][2] then
	    				return true
	    			else
	    				return false
    				end
    			end
			end
			return false
		end

		if self:skillHadActivation(skillId, skillProps) then
			return false
		end
		local skillInfo = GDatatab_skill["id_" .. skillId]
		local openType  = skillInfo.hdtj  
		if openType == 2 then
			local hdtjcs = skillInfo.hdtjcs
    		local bFPoss = false
    		local bSPoss = false
    		for i,v in ipairs(hdtjcs) do
    			local itemCount = CacheCenter:getPlayerItemCountById(v[1]) 
    			if itemCount >= v[2] and i == 1 then
    				bFPoss = true
    			end
    			if itemCount >= v[2] and i == 2 then
    				bSPoss = true
    			end
    		end
    		local itemCount = nil
    		if bSPoss or bFPoss then
    			return true
            else
            	local hSecondItem = false  --优先消耗第二个物品
            	if hdtjcs[2] ~= nil then
            		hSecondItem = true
            	end

            	if hSecondItem then
                    itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[2][1]) 
                    local pro = itemCount / hdtjcs[2][2]
                    if pro>=100 then
                    	return true
                    end
            	else
                    itemCount = CacheCenter:getPlayerItemCountById(hdtjcs[1][1]) 
                    local pro = itemCount / hdtjcs[1][2]
                    if  pro>=100 then
                    	return true
                    end
            	end
    		end
		end
	end
	return false
end

--@brief	设置回调函数数据
--@param	element:表名
--@param	tCallBackFun:回调函数名
function WndSkillProp:setBackFun( element , tCallBackFun )
	self.m_tCell = element 
	self.m_tCallBackFun = tCallBackFun
end

--@brief  确定购买的回调
function WndSkillProp:sureBuyCaleBack()
	WZLog("WndSkillProp:sureBuyCaleBack")
	self.m_bIsVisitNet = true
	self.m_nPlayerSkillLoadingId = MsgBoxManager:showLoadingBox()
	ProtocolProcessorWndSkillProp:send_PLAYER_BuySkill(self.m_nBuySkillId)
end

--@brief  购买道具栏
function WndSkillProp:sureBuyCell(tag,result)
	WZLog("WndSkillProp:sureBuyCell = ",result)
	if result==MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox(4)
	end
end

--@brief	设置技能道具显示内容
function WndSkillProp:setDisplay() 
	if WndSkillProp.mode == "edit" then return end
	if self.m_nWinType == 1 then
		GetElement(self.m_root,"txtModelTitle_WndSkillProp",WZUILabelTTF):setText(LocalStrings.SKILL_TXT)
		GetElement(self.m_root,"txtAct1",WZUILabelTTF):setText(LocalStrings.NEWSKILL17)
		GetElement(self.m_root,"txtAct2",WZUILabelTTF):setText(LocalStrings.NEWSKILL17)
		GetElement(self.m_root,"conSkill",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conExp2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conIcon",WZUIContainer):setRelativePosition(ccp(0.5,0.5))
		local tbCon = GetElement(self.m_root,"tbSkillList_WndSkillProp",WZUITableContainer)
		tbCon:setAbsContentSize(GlobalMethod:CCSize(440,230))
		tbCon:setCellElementHeight(0.382)
		tbCon:updateRelativeSize()
	elseif self.m_nWinType == 2 then
		GetElement(self.m_root,"txtModelTitle_WndSkillProp",WZUILabelTTF):setText(LocalStrings.PROP)
		GetElement(self.m_root,"txtAct1",WZUILabelTTF):setText(LocalStrings.ACTIVATION)
		GetElement(self.m_root,"txtAct2",WZUILabelTTF):setText(LocalStrings.ACTIVATION)
		GetElement(self.m_root,"conSkill",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conExp2",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conIcon",WZUIContainer):setRelativePosition(ccp(0.5,0.58))
		local tbCon = GetElement(self.m_root,"tbSkillList_WndSkillProp",WZUITableContainer)
		tbCon:setAbsContentSize(GlobalMethod:CCSize(440,260))
		tbCon:setCellElementHeight(0.3385)
		tbCon:updateRelativeSize()
	end
end

--@brief	设置右侧面板状态
--@param	state   0:不可激活,1:可激活,2:可升级,3:已满级
function WndSkillProp:setSkillState(state, tip) 
	GetElement(self.m_root,"btnUp",WZUIButton):setVisible(false)
	if state == 0 then
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.NO_GET_WORDS)
		GetElement(self.m_root,"conText2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conBtnList_WndSkillProp",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conExp_WndSkillProp",WZUIContainer):setVisible(true)
	elseif state == 1 then
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.NO_GET_WORDS)
		GetElement(self.m_root,"tip2",WZUILabelTTF):setText(LocalStrings.NEWSKILL10)
		GetElement(self.m_root,"conText2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conBtnList_WndSkillProp",WZUIContainer):setVisible(true)
		if self.m_nWinType == 1 then
			GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(true)
		end
		if self.m_nWinType == 2 then
			GetElement(self.m_root,"tip2",WZUILabelTTF):setText(LocalStrings.NEWSKILL20)
		end
		GetElement(self.m_root,"conExp_WndSkillProp",WZUIContainer):setVisible(true)
	elseif state == 2 then
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.NEWSKILL5)
		GetElement(self.m_root,"tip2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"conText2",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conBtnList_WndSkillProp",WZUIContainer):setVisible(true)
		if self.m_nWinType == 1 then
			GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(true)
		end
		GetElement(self.m_root,"btnUp",WZUIButton):setVisible(true)

		GetElement(self.m_root,"conExp_WndSkillProp",WZUIContainer):setVisible(true)
	elseif state == 3 then
		GetElement(self.m_root,"title2",WZUILabelTTF):setText(LocalStrings.NEWSKILL5)
		GetElement(self.m_root,"tip2",WZUILabelTTF):setText(LocalStrings.NEWSKILL11)
		GetElement(self.m_root,"conText2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conExp1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conBtnList_WndSkillProp",WZUIContainer):setVisible(false)

		GetElement(self.m_root,"conExp_WndSkillProp",WZUIContainer):setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
