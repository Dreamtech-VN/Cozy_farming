--WndGiveGoodPlayer.lua
--@brief	WndGiveGoodPlayer的UI模块
--@date		2020/07/02
--@author	XTX
--@note		点赞玩家界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGiveGoodPlayer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGiveGoodPlayer:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function WndGiveGoodPlayer:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndFriends:send_FRIEND_GetFriendCircleLikes(self.m_nCircleId)
end

--@brief 	点击关闭按钮回调
function WndGiveGoodPlayer:onCloseClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndGiveGoodPlayer:_update()
	-- body
	local tbPlayerList = GetElement(self.m_root, "tbPlayerList_WndGiveGoodPlayer", WZUITableContainer)
	tbPlayerList:cleanTable()

	local nCount = #self.m_tData
	for i = 1, nCount do
		local element, tNewObj = CellGiveGoodPlayer:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tData[i])

			tbPlayerList:setCellElement(element)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
