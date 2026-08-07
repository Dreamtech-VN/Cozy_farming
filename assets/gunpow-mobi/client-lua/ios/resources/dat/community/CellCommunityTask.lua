--CellCommunityTask.lua
--@brief	CellCommunityTask的UI模块
--@date		2016/06/17
--@author	zsq
--@note		公会任务Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityTask:onEnter(element)
	self.m_root = element
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityTask:onExit(element)
	self:_unInit()
end

function CellCommunityTask:setData(tData)
	self:update(tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommunityTask:update(tData)
	if tData == nil then return end
	WZLog("CellCommunityTask:update",Serialize(tData))
	local onLine = false
	if tData.online == 1 then onLine = false else onLine = true end
	--头像
	local conPlayerAni = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni,tData.headId,tData.faceId,tData.sex,onLine,GlobalMethod:ccp(0.54,0.29),tData.vipLevel,tData.headColor)
	imgHead:setScale(1.05)
	--等级
	GetElement(self.m_root,"txtLv",WZUILabelAtlasFont):setText(tData.level)
	--名字
	local str = [[<T C="255,227,116" S="22" P="0">%s</T><T C="138,122,106" S="22" P="0">(%s)</T>]]
	GetElement(self.m_root,"txtName1",WZUIFreeTextBox):setShowText(string.format(str,tData.name,COMMUNITY_POSITION[tData.job+1]))
	--消息
	GetElement(self.m_root,"txtMessage",WZUILabelTTF):setText(tData.msgList)
	--发送时间
	GetElement(self.m_root,"txtTime",WZUILabelTTF):setText(os.date("%X", tData.itime))
end




-------------------------------------私有方法模块End----------------------------------------
