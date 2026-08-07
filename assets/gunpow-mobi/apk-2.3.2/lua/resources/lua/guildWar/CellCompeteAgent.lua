-- CellCompeteAgent (公会设置代理人模块)
-- @brief: 公会会员列表成员 UI部分
-- @date: 2017-02-24 11:11:44
-- @author: zhenwei_jian
-- @note: 公会设置代理人模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCompeteAgent:onEnter(element)
	self.m_root = element
 
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCompeteAgent:onExit(element)
	self:_unInit()
end

--@brief	更新公会成员列表的函数(排名,玩家等级图片,玩家等级数量,玩家姓名,职位,贡献度,状态 )
function CellCompeteAgent:onLoadData(element)
	local elementAgentCell = WZUISystem:getInstance():createElement("CellCompeteAgent") 
	self.m_root:addChild(elementAgentCell) 
	self._imgSel = GetElement(self.m_root, "imgSel", WZUI9Image) 
	self:_update()
end


function CellCompeteAgent:onClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if nil ~= WndCompeteAgent.PreSelCell then
		WndCompeteAgent.PreSelCell:setChoiceState(false)
	end
	self:setChoiceState(true)
	WndCompeteAgent.PreSelCell = self

	if self.m_tCallBack then
		self.m_tCallBack[2](self.m_tCallBack[1], self["m_nPlayerId"])
	end
end

-------------------------------------公有方法模块End--------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

--@brief 设置是否选中状态
function CellCompeteAgent:setChoiceState(val)
	self._imgSel:setVisible(val)
end

--@brief 更新显示
function CellCompeteAgent:_update() 
	local img9BK = GetElement(self.m_root, "img9BK_CellCompeteAgent", WZUI9Image)
	if img9BK then
		WZLog("CellCompeteAgent:_update", self.agentMark)
		if self.agentMark == 1 then
			img9BK:setFile("ui/common/frame_lieb_01.png")
		end
	end
	--头像
	if self.m_sState == 1 then
		self:_addHead(self.m_nHeadId, self.m_nFaceId, self.m_nSex)
	else
		self:_addHead(self.m_nHeadId, self.m_nFaceId, self.m_nSex, true)
	end
	
	--职位  
	local txtJob = GetElement(self.m_root, "txtJob", WZUILabelTTF) 
	if self.m_nJob ~= nil then
		local sTxt = self._mJobNameMap[self.m_nJob] or ""
		txtJob:setText(sTxt)
	end 
	 

	--贡献 
	local txtContribution = GetElement(self.m_root, "txtContribution", WZUILabelTTF)  
	if txtContribution ~= nil and  self.m_nPlayerContr ~= nil  then 
		txtContribution:setText(self.m_nPlayerContr)
	end  
	
	--玩家名字
	local txtName = GetElement(self.m_root, "txtName", WZUILabelTTF)  
	if nil ~= txtName and nil ~= self.m_nLevelNum  and nil ~= self.m_sPlayerName  then
		local sName = string.format("lv%s %s", self.m_nLevelNum, self.m_sPlayerName) 
		txtName:setText(sName)
	end  

end


--@brief   玩家人物
function CellCompeteAgent:_addHead(headId,faceId,sex,online)
	local head, face, sex1 

	if headId == 0 then
		head = 2
	else 
		head = headId
		local key = string.format("id_%s", headId)
		if GDatatab_item[key].sex ~= nil then
			sex1 = GDatatab_item[key].sex
		end
	end

	if faceId == 0 then
		face = 2
	else
		--face = GDatatab_item["id_"..faceId].animation_index_code
		face = faceId
		local key = string.format("id_%s", faceId)
		if GDatatab_item[key].sex ~= nil then
			sex1 = GDatatab_item[key].sex
		end
	end

	if sex1 ~= nil then
		nSex = sex1
	else
		nSex = 0
	end

	if sex ~= nil then
		nSex = sex
	end

	local aniSex = true
	local relativePosition = GlobalMethod:ccp(0.32, 0.16)
	if nSex == 0 then
		aniSex = true
		relativePosition = GlobalMethod:ccp(0.28, 0.24)
	else
		aniSex = false
	end

	local conPlayerAni = GetElement(self.m_root, "conHead_Cell", WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni, head, face, nSex, online, GlobalMethod:ccp(0.54,0.29), self.vipLevel, self.headColor)
	imgHead:setScale(1.25)
end
 
-------------------------------------私有方法模块End--------------------------------------



