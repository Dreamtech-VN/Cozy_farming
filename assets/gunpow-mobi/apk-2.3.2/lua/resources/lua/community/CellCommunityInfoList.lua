--CellCommunityInfoList.lua
--@brief	CellCommunityInfoList的UI模块
--@date		2013/12/25
--@author	林庆凯
--@note		创建公会信息的列表,公会日志列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityInfoList:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityInfoList:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellCommunityInfoList:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellCommunityInfoList")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true 
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新图片，文字的函数
function CellCommunityInfoList:_update()
	if self.m_root == nil then 
		WZLog("CellCommunityInfoList:_update() self.m_root is nil ")
		return 
	end 

	self:showLog(self.m_sLog, self.m_nTime, self.m_nLastTime)
end 


--@brief	设置Cell显示公会log
function CellCommunityInfoList:setLogType()
	if self.m_bIsLoaded == false then return end 
	
	GetElement(self.m_root,"conCommunityLog",WZUIContainer):setVisible(true)
end

--@brief	设置Cell显示公会log
function CellCommunityInfoList:showLog(log, time, lastTime)
	GetElement(self.m_root,"conCommunityLog",WZUIContainer):setVisible(true)
	local logDetail = GetElement(self.m_root,"logDetail_Cell",WZUIFreeTextBox)
	logDetail:setShowText(log)

	local txtTime1, txtTime2 = string.match(time, "(%d+-%d+) (%d+:%d+)")
	if not txtTime1 and not txtTime2 then
		txtTime1 = os.date("%m-%d", tonumber(time))
		txtTime2 = os.date("%H:%M", tonumber(time))
	end
	GetElement(self.m_root,"txtTime",WZUILabelTTF):setText(txtTime1)
	GetElement(self.m_root,"txtTime1",WZUILabelTTF):setText(txtTime2)

	if lastTime == nil then return end
	local txtLastTime = os.date("%m-%d", tonumber(lastTime))
	if txtLastTime == txtTime then
		GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtTime",WZUILabelTTF):setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellCommunityInfoList:_adaptLanguage_vn()
	
end

-------------------------------------语言适配End----------------------------------------