--WndCircleReport.lua
--@brief	WndCircleReport的UI模块
--@date		2020/07/07
--@author	XTX
--@note		好友圈举报界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCircleReport:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCircleReport:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndCircleReport:onEnterTransitionDidFinish(element)
	self:_update()
end

--@brief 	点击关闭按钮回调
function WndCircleReport:onCloseClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击提交按钮回调
function WndCircleReport:onClickSubmit(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tReason == nil or #self.m_tReason == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT9)
		return 
	end

	ProtocolProcessorWndFriends:send_FRIENTD_ReportFriendCircle(self.m_nCircleId, TableToIntVector(self.m_tReason), "")
end

--@brief 	点击复选框回调
function WndCircleReport:onCheckBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	local bIsExist = false 
	for i = 1, #self.m_tReason do
		if self.m_tReason[i] == nTag then 
			bIsExist = true
			table.remove(self.m_tReason, i)
			break 
		end
	end

	if not bIsExist then 
		table.insert(self.m_tReason, nTag)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndCircleReport:_update()
	-- body
	self.m_tReason = {1}

	local tReason = LocalStrings.FRIENDCIRCLE_TEXT8
	for i = 1, #tReason do
		GetElement(self.m_root, "checkBox" .. i .. "_WndCircleReport"):setVisible(true)

		GetElement(self.m_root, "txtCheck" .. i .."_WndCircleReport", WZUILabelTTF):setText(tReason[i])
		GetElement(self.m_root, "txtCheckSel" .. i .."_WndCircleReport", WZUILabelTTF):setText(tReason[i])
	end
end




-------------------------------------私有方法模块End----------------------------------------
