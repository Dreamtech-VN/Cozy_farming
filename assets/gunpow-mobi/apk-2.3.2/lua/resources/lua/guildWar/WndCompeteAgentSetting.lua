-- WndCompeteAgentSetting UI部分
-- @brief:设置代理人设置界面
-- @date: 2017-03-02 11:17:21
-- @author: zhenwei_jian
-- @note:设置代理人设置界面


-------------------------------------公有方法模块Begin--------------------------------------
--@brief 显示该界面
function WndCompeteAgentSetting:showWnd()
	if self.m_root then
		WindowManager:removeWindow(self.m_root, self, true)
	end

	local wnd = self:createElement()
	WindowManager:addWindow( wnd , WndCompeteAgentSetting)
end

--@brief    onenter函数已执行
function WndCompeteAgentSetting:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "_ready", self)
    AdaptLanguage(self)
end


--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteAgentSetting:onEnter(element)
	self.m_root = element
	self:_bindControls() 
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteAgentSetting:onExit(element)
	--add by wuweidong
	self:_unInit()
end

--@brief	关闭按钮
function WndCompeteAgentSetting:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--进入公会场景
    WindowManager:removeWindow(self.m_root, self, true)
end

--@breif 刷新成员列表
function WndCompeteAgentSetting:refresh()
	self:_update()
end
	
--@brief 	获取代理人Id
function WndCompeteAgentSetting:getAgentData()
	-- body
	return self.m_tData 
end
-------------------------------------公有方法模块End----------------------------------------

function WndCompeteAgentSetting:onSetAgent1()
	self:_showAgentMemberList(1)
end

function WndCompeteAgentSetting:onSetAgent2()
	self:_showAgentMemberList(2)
end

function WndCompeteAgentSetting:onSetAgent3()
	self:_showAgentMemberList(3)
end

function WndCompeteAgentSetting:onSetAgent4()
	self:_showAgentMemberList(4)
end

function WndCompeteAgentSetting:onRuleClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.COMMUNITYWARAGENT_TEXT5)
end
-------------------------------------私有方法模块Begin--------------------------------------

function WndCompeteAgentSetting:_showAgentMemberList(agentIndex)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if nil == self.m_tData then
		return
	end 
	--不允许设置
	if not self:allowSetAgent() then
		local agentId = self.m_tPlayerState[agentIndex] 
		if nil ~= agentId then--有头像
			WndCheckOther:show(agentId)
		end
		return
	end
	WndCompeteAgent:showWnd(agentIndex, self.m_tData.agent)
end

function WndCompeteAgentSetting:_ready()
	ProtocolProcessorCommunityWar:send_GUILDWAR_GetAgent()
end

function WndCompeteAgentSetting:_update()
	local tData = self.m_tData
	if nil == tData then
		return
	end
	WZLog("WndCompeteAgentSetting:_update", Serialize(tData))

	--不能设置代理人的用户，需要隐藏 下方的 提示语  与 + 号按钮
	if not self:allowSetAgent() then
		self.label_bottom_tips:setVisible(false)
		self.sprite_default1:setVisible(false)
		self.sprite_default2:setVisible(false)
		self.sprite_default3:setVisible(false)
		self.sprite_default4:setVisible(false)
	else
		self.label_bottom_tips:setVisible(true)
		self.sprite_default1:setVisible(true)
		self.sprite_default2:setVisible(true)
		self.sprite_default3:setVisible(true)
		self.sprite_default4:setVisible(true)
	end

	for i = 1, 4 do
		local agentId = tData.agent[i]
		if -1 ~= agentId then
			self:_setAgent(i, tData)
			self.m_tPlayerState[i] = agentId
		else 
			self:_setEmpty(i)
			self.m_tPlayerState[i] = nil
		end
	end
end

function WndCompeteAgentSetting:_setAgent(nAgentIndex, tData) 
	local label_name = self[string.format("label_name%s", nAgentIndex)]
	local label_job  = self[string.format("label_job%s"	, nAgentIndex)]
	local label_lv   = self[string.format("label_lv%s"	, nAgentIndex)]
	local label_tip  = self[string.format("label_tip%s"	, nAgentIndex)]
	local sprite_default = self[string.format("sprite_default%s", nAgentIndex)]

	label_name :setVisible(true)
	label_job  :setVisible(true)
	label_lv   :setVisible(true)

	label_tip  :setVisible(false)
	sprite_default:setVisible(false)

	local agentId = tData.agent[nAgentIndex]
	local faceId  = tData.faceId[nAgentIndex]
	local headId  = tData.headId[nAgentIndex]
	local colour  = tData.colour[nAgentIndex]
	local sex 	  = tData.sex[nAgentIndex] 
	local name 	  = tData.name[nAgentIndex]
	local level   = tData.level[nAgentIndex]
	local vipLevel = tData.viplevel[nAgentIndex]
	local post 	  = tData.post[nAgentIndex]

	local sJob = self._mJobNameMap[post] or ""
	label_name:setText(name)
	label_lv:setText(string.format("Lv%s", level))
	label_job:setText(sJob)

	self:_addHead(nAgentIndex, headId, faceId, sex, false, vipLevel, colour)
end

function WndCompeteAgentSetting:_setEmpty(nAgentIndex)
	local label_name = self[string.format("label_name%s", nAgentIndex)]
	local label_job  = self[string.format("label_job%s"	, nAgentIndex)]
	local label_lv   = self[string.format("label_lv%s"	, nAgentIndex)]
	local label_tip  = self[string.format("label_tip%s"	, nAgentIndex)]
	local sprite_default = self[string.format("sprite_default%s", nAgentIndex)]


	label_name :setVisible(false)
	label_job  :setVisible(false)
	label_lv   :setVisible(false)

	label_tip  :setVisible(true)
	sprite_default:setVisible(true)
end

--@brief   玩家人物
function WndCompeteAgentSetting:_addHead(agentIndex, headId, faceId, sex, offLine, vipLevel, headColor)
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

	local conPlayerAni = GetElement(self.m_root, string.format("spriteCell%s", agentIndex), WZUIImage)
	local imgHead, tHead = CellHead:show(conPlayerAni, head, face, nSex, offLine, GlobalMethod:ccp(0.54,0.29), vipLevel, headColor)
	imgHead:setScale(1.1)

	GetElement(self.m_root, "spriteDefault"..agentIndex, WZUIImage):setVisible(false)

	-- local tPack = {}
	-- tPack.onclick = function() 
	-- 	WndCheckOther:show(agentIndex)
	-- end
	-- tHead:setHeadClickFun(tPack, tPack.onclick)
	-- WndCheckOther:show(self.m_tFriend.id)
end

function WndCompeteAgentSetting:_bindControls() 
	self.label_name1 = GetElement(self.m_root, "label_name1", WZUILabelTTF)
	self.label_name2 = GetElement(self.m_root, "label_name2", WZUILabelTTF)
	self.label_name3 = GetElement(self.m_root, "label_name3", WZUILabelTTF)
	self.label_name4 = GetElement(self.m_root, "label_name4", WZUILabelTTF)


	self.label_job1 = GetElement(self.m_root, "label_job1", WZUILabelTTF)
	self.label_job2 = GetElement(self.m_root, "label_job2", WZUILabelTTF)
	self.label_job3 = GetElement(self.m_root, "label_job3", WZUILabelTTF)
	self.label_job4 = GetElement(self.m_root, "label_job4", WZUILabelTTF)

	self.label_lv1  = GetElement(self.m_root, "labelLv1", WZUILabelTTF)
	self.label_lv2  = GetElement(self.m_root, "labelLv2", WZUILabelTTF)
	self.label_lv3  = GetElement(self.m_root, "labelLv3", WZUILabelTTF)
	self.label_lv4  = GetElement(self.m_root, "labelLv4", WZUILabelTTF)

	self.label_tip1 = GetElement(self.m_root, "label_tip1", WZUILabelTTF)
	self.label_tip2 = GetElement(self.m_root, "label_tip2", WZUILabelTTF)
	self.label_tip3 = GetElement(self.m_root, "label_tip3", WZUILabelTTF)
	self.label_tip4 = GetElement(self.m_root, "label_tip4", WZUILabelTTF)

	self.label_bottom_tips = GetElement(self.m_root, "lbl_bottomTips", WZUILabelTTF)

	self.sprite_default1 = GetElement(self.m_root, "spriteDefault1", WZUIImage)
	self.sprite_default2 = GetElement(self.m_root, "spriteDefault2", WZUIImage)
	self.sprite_default3 = GetElement(self.m_root, "spriteDefault3", WZUIImage)
	self.sprite_default4 = GetElement(self.m_root, "spriteDefault4", WZUIImage)

end

-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndCompeteAgentSetting:_adaptLanguage_tr(  )
	local label_job1 = GetElement(self.m_root, "label_job1", WZUILabelTTF)
	label_job1:setScale(0.65)
	local label_job2 = GetElement(self.m_root, "label_job2", WZUILabelTTF)
	label_job2:setScale(0.65)
	local label_job3 = GetElement(self.m_root, "label_job3", WZUILabelTTF)
	label_job3:setScale(0.65)
	local label_job4 = GetElement(self.m_root, "label_job4", WZUILabelTTF)
	label_job4:setScale(0.65)
end

---------------------------------------语言适配End------------------------------------------