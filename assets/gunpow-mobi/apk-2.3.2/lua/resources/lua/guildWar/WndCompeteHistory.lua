-- WndCompeteHistory
-- @brief: 公会战历届  UI模块
-- @date: 2017-02-23 14:33:21
-- @author: zhenwei_jian
-- @note: 公会战历届


-------------------------------------公有方法模块Begin--------------------------------------

--@brief 显示该界面
function WndCompeteHistory:showWnd()
	local wnd = self:createElement()
	WindowManager:addWindow( wnd , WndCompeteHistory)
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteHistory:onEnter(element)
	self.m_root = element
	self:_findComponent()
	self:_initControls()
	ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes(-1)
	self:createLoading()
	AdaptLanguage(self)
end

--@brief    onenter函数已执行
function WndCompeteHistory:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "_update", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteHistory:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCompeteHistory:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if nil ~= self.m_root then 
		WindowManager:removeWindow(self.m_root, WndCompeteHistory, true)
	end 
end

--@brief 点击了翻页(←)
function WndCompeteHistory:onPageLeft(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if 1 < self.m_nPageNum then
		self.m_nPageNum = self.m_nPageNum - 1
	end

	ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes(self.m_nPageNum)
	self:createLoading()
end

--@brief 点击了翻页(→)
function WndCompeteHistory:onPageRight(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nPageNum < self.m_nMaxPage then
		self.m_nPageNum = self.m_nPageNum + 1
	end

	ProtocolProcessorCommunityWar:send_GUILDWAR_OldGuildWarMes(self.m_nPageNum)
	self:createLoading()
end

function WndCompeteHistory:onClickNum1()  
	SceneCommunityWar:onCheckCommunityInfo(self.guildId[1] or -1)
end

function WndCompeteHistory:onClickNum2() 
	SceneCommunityWar:onCheckCommunityInfo(self.guildId[2] or -1)
end

function WndCompeteHistory:onClickNum3() 
	SceneCommunityWar:onCheckCommunityInfo(self.guildId[3] or -1)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化空间
function WndCompeteHistory:_initControls()
	self.m_label_community_1:setVisible(false)
	self.m_label_community_2:setVisible(false)
	self.m_label_community_3:setVisible(false)

	self.m_label_name_1:setVisible(false)
	self.m_label_name_2:setVisible(false)	
	self.m_label_name_3:setVisible(false)

	-- self.m_sprite_num1:setVisible(false)
	-- self.m_sprite_num2:setVisible(false)
	-- self.m_sprite_num3:setVisible(false)

	self.m_label_default1:setVisible(true) 
	self.m_label_default2:setVisible(true) 
	self.m_label_default3:setVisible(true) 

	self.m_btn_left  :setVisible(false)
	self.m_btn_right :setVisible(false)
	
	self.m_label_page:setText(string.format(LocalStrings.COMMUNITYWARHISTORY_TEXT3, 1))
end

--@brief	更新界面
function WndCompeteHistory:_update()
	self:_initControls()
	local tData = self.m_tData
	if nil == tData then
		return
	end

	--设置获奖玩家
	for i = 1, 3 do
		if nil == tData.name[i] then
			break
		end
		self:_setShowTarget(i)
	end

	--设置 翻页按钮
	if self.m_nMaxPage == self.m_nPageNum then
		self.m_btn_right:setVisible(false)
	else
		self.m_btn_right:setVisible(true)
	end

	if 1 >= self.m_nPageNum then
		self.m_btn_left:setVisible(false)
	else
		self.m_btn_left:setVisible(true)
	end

	--设置届数
	--local numStr = LocalStrings.COMMUNITYWARHISTORY_NUMBER[tData.version] or LocalStrings.COMMUNITYWARHISTORY_NUMBER[1]
	self.m_label_page:setText(string.format(LocalStrings.COMMUNITYWARHISTORY_TEXT3, tData.version))

end

--@brief   获取控件
function WndCompeteHistory:_findComponent()
	--公会名字 与 玩家名字
	self.m_label_community_1 	= GetElement(self.m_root, "label_community_1", WZUILabelTTF)
	self.m_label_name_1 		= GetElement(self.m_root, "label_name_1", WZUILabelTTF)

	self.m_label_community_2 	= GetElement(self.m_root, "label_community_2", WZUILabelTTF)
	self.m_label_name_2 		= GetElement(self.m_root, "label_name_2", WZUILabelTTF)

	self.m_label_community_3 	= GetElement(self.m_root, "label_community_3", WZUILabelTTF)
	self.m_label_name_3 		= GetElement(self.m_root, "label_name_3", WZUILabelTTF)

	--冠亚季奖杯的图片
	self.m_btn_num1 			= GetElement(self.m_root, "btn_num1", WZUIButton)
	self.m_btn_num2 			= GetElement(self.m_root, "btn_num2", WZUIButton)
	self.m_btn_num3 			= GetElement(self.m_root, "btn_num3", WZUIButton)

	--当前第几届
	self.m_label_page 			= GetElement(self.m_root, "label_page", WZUILabelTTF)

	--默认未产生  文字
	self.m_label_default1 		= GetElement(self.m_root, "label_default1", WZUILabelTTF)
	self.m_label_default2 		= GetElement(self.m_root, "label_default2", WZUILabelTTF)
	self.m_label_default3 		= GetElement(self.m_root, "label_default3", WZUILabelTTF)

	--按钮 
	self.m_btn_left 			= GetElement(self.m_root, "btn_left", WZUIButton)
	self.m_btn_right 			= GetElement(self.m_root, "btn_right", WZUIButton)
end


--@brief  显示获奖玩家
--@param num:1, 2, 3 冠亚季
function WndCompeteHistory:_setShowTarget(num)
	WZLog("WndCompeteHistory:_setShowTarget", num, Serialize(self.m_tData))

	local label_community 	= self[string.format("m_label_community_%s", num)]
	local label_name 		= self[string.format("m_label_name_%s", num)]
	local btn_num 			= self[string.format("m_btn_num%s", num)]
	local label_default 	= self[string.format("m_label_default%s", num)]

	label_community :setVisible(true)
	label_name 		:setVisible(true)
	btn_num 		:setVisible(true)

	label_default  	:setVisible(false)

	local tData 	= self.m_tData

	local sServerName = CacheCenter:getServerNameByServerId(tData.serverId[num])
	label_community :setText(sServerName)
	label_name 		:setText(string.format("Lv%s %s", tData.level[num], tData.name[num]))
end

-------------------------------------私有方法模块End--------------------------------------


--------------------------------------语言适配Begin---------------------------------------
function WndCompeteHistory:_adaptLanguage_pt(  )
	GetElement(self.m_root, "label_page", WZUILabelTTF):setScale(0.6)
end

function WndCompeteHistory:_adaptLanguage_es(  )
	GetElement(self.m_root, "label_page", WZUILabelTTF):setScale(0.7)
end

function WndCompeteHistory:_adaptLanguage_ug(  )
	GetElement(self.m_root, "label_page", WZUILabelTTF):setScale(0.7)
end
---------------------------------------语言适配End----------------------------------------