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
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityInfoList:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新图片，文字的函数
function CellCommunityInfoList:_update()
	if self.m_root == nil then 
		WZLog("CellCommunityInfoList:_update() self.m_root is nil ")
		return 
	end 
	
	--左边图片
	local txtName = self.m_root:getChildElement("txtName_CellCommunityInfoList")
	if txtName ~=nil and  self.m_sTxtName ~= nil  then 
		txtName = WZUILabelTTF:luaTo(txtName):setText(self.m_sTxtName)
	end 
	
	--右边内容
	local txtContent = self.m_root:getChildElement("txtContent_CellCommunityInfoList")
	if txtContent ~=nil and self.m_sTxtContent ~= nil  then 
		WZUILabelTTF:luaTo(txtContent):setText(self.m_sTxtContent)
	end 

	--设置背景图颜色
	if self.m_root:getTag() % 2 == 0 then
		GetElement(self.m_root, "imgBtn_CellCommunityInfoList", WZUI9Image):setFile("ui/common/common_scale9_di4.png")
	else
		GetElement(self.m_root, "imgBtn_CellCommunityInfoList", WZUI9Image):setFile("ui/common/common_scale9_di10.png")
	end
end 


--@brief	设置Cell显示公会log
function CellCommunityInfoList:setLogType()
	GetElement(self.m_root,"conCommunityInfo",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCommunityLog",WZUIContainer):setVisible(true)
end

--@brief	设置Cell显示公会log
function CellCommunityInfoList:setLog(log,time, lastTime)
	GetElement(self.m_root,"conCommunityInfo",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCommunityLog",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"logDetail_Cell",WZUIFreeTextBox):setShowText(log)
	local txtTime = os.date("%m-%d", tonumber(time))
	local txtTime1 = os.date("%H:%M", tonumber(time))
	GetElement(self.m_root,"txtTime",WZUILabelTTF):setText(txtTime)
	GetElement(self.m_root,"txtTime1",WZUILabelTTF):setText(txtTime1)

	--设置背景图颜色
	if self.m_root:getTag() % 2 == 0 then
		GetElement(self.m_root, "imgBtn_CellCommunityInfoList", WZUI9Image):setFile("ui/common/common_scale9_di4.png")
	else
		GetElement(self.m_root, "imgBtn_CellCommunityInfoList", WZUI9Image):setFile("ui/common/common_scale9_di10.png")
	end

	GetElement(self.m_root,"conCommunityLog",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.52,0.5))
	if ProjConfig.LANGUAGE == "tr" then
		GetElement(self.m_root,"txtName_CellCommunityInfoList",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"txtContent_CellCommunityInfoList",WZUILabelTTF):setScale(0.8)
	end

	if lastTime == nil then return end
	local txtLastTime = os.date("%m-%d", tonumber(lastTime))
	if txtLastTime == txtTime then
		GetElement(self.m_root,"imgTitle",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtTime",WZUILabelTTF):setVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------
