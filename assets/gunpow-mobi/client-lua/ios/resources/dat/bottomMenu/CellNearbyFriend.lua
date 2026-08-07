--CellNearbyFriend.lua
--@brief	CellNearbyFriend的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNearbyFriend:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNearbyFriend:onExit(element)
	WZLog("CellNearbyFriend:onExit:::")
	self:_unInit()
end

--@brief	背景按钮函数
--@param	element:表绑定的UI节点引用
function CellNearbyFriend:onBackClick(element)
	element = WZUIButton:luaTo(element)
	local tag = self.m_root:getTag()
	self.m_tBackFun[2](self.m_tBackFun[1] , element , tag)
end

--@brief	邮件按钮函数
--@param	element:表绑定的UI节点引用
function CellNearbyFriend:onMailBackClick(element)
	element = WZUIButton:luaTo(element)
	local tag = self.m_root:getTag()
	self.m_tBackFun[3](self.m_tBackFun[1] , element , tag)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellNearbyFriend:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end
	--显示玩家头像
	self:_showPlayerPhoto()
	--设置添加好友按钮不可用
	self:_setAddFriendTouch(false)
	--在线背景按钮透明度
	self:_showFriendOnline()
	--显示好友性别
	self:_showFriendSex()
	--设置好友名称
	self:_setFriendName(self.m_tFriend[3])
	--设置好友战斗力
	self:_setFriendFire(self.m_tFriend[4])
	--显示好友距离
	self:_showFriendDistance()
	--好友邮件数量
	self:_showMailCount()
end

--@brief	设置添加好友按钮是否可用函数
function CellNearbyFriend:_setAddFriendTouch(bTouch)
	--添加好友按钮是否可用函数
	WndNearbyFriend:setAddFriendTouchEnable(bTouch)
end

--@brief	在线背景按钮透明度
function CellNearbyFriend:_showFriendOnline()
	WZLog("_showFriendOnline::::::::::::",self.m_tFriend[7])
	if self.m_tFriend then
		if self.m_tFriend[7] == true then
			self:_setBKImageOpacity(255)	--在线背景按钮透明度255
		else
			self:_setBKImageOpacity(128)	--设置背景按钮透明度
		end
	end
end

--@brief	设置背景按钮透明度
--@param	opacity：透明度
function CellNearbyFriend:_setBKImageOpacity(opacity)
	local imgNorBack = self.m_root:getChildElement("imgNorBack_CellNearbyFriend")
	if imgNorBack then
		imgNorBack = WZUIImage:luaTo(imgNorBack)
		imgNorBack:setOpacity(opacity)
	end
end

--@brief	显示好友性别
function CellNearbyFriend:_showFriendSex()
	if self.m_tFriend then
		local icon = "ui/bottomMenu/friend/sex_boy.png"
		if self.m_tFriend[2] == 1 then
			icon = "ui/bottomMenu/friend/sex_girl.png"
		end
		self:_setFriendSex(icon)	--设置好友性别
	end
end

--@brief	设置好友性别
--@param	icon：性别图片路径
function CellNearbyFriend:_setFriendSex(icon)
	local image = self.m_root:getChildElement("imgSex_CellNearbyFriend")
	if image then
		image = WZUIImage:luaTo(image)
		image:setFile(icon)
	end
end

--@brief	设置好友名称
--@param	name：好友名称
function CellNearbyFriend:_setFriendName(name)
	local txtName = self.m_root:getChildElement("txtName_CellNearbyFriend")
	if txtName then
		txtName = WZUILabelTTF:luaTo(txtName)
		txtName:setText(name)
	end
end

--@brief	设置好友战斗力
--@param	name：好友战斗力
function CellNearbyFriend:_setFriendFire(fire)
	local txtFire = self.m_root:getChildElement("txtFire_CellNearbyFriend")
	if txtFire then
		txtFire = WZUILabelTTF:luaTo(txtFire)
		txtFire:setText(fire)
	end
end

--@brief	显示好友距离
function CellNearbyFriend:_showFriendDistance()
	if self.m_tFriend and self.m_tFriend[5] ~= nil then
		local distance = self:_friendDistance(self.m_tFriend[5])
		self:_setFriendDistance(distance)	--好友距离
	end
end

--@brief	设置好友距离
--@param	distance：好友距离
function CellNearbyFriend:_setFriendDistance(distance)
	local txtDistance = self.m_root:getChildElement("txtDistance_CellNearbyFriend")
	if txtDistance then
		txtDistance = WZUILabelTTF:luaTo(txtDistance)
		txtDistance:setText(distance)
	end
end

--@brief	显示邮件数量
function CellNearbyFriend:_showMailCount()
	if self.m_tFriend then
		if self.m_tFriend[6] > 0 then
			self:_setMailCountVisble(true)			--显示邮件数量
			local mailCount = self.m_tFriend[6]
			if mailCount > 30 then
				mailCount = 30 
			end
			self:_setMailCount(mailCount)	--邮件数量
		else
			self:_setMailCountVisble(false)	--不显示邮件数量
		end
	end
end

--@brief	邮件数量
--@param	mail：邮件数量
function CellNearbyFriend:_setMailCount(mail)
	local txtMail = self.m_root:getChildElement("txtMail_CellNearbyFriend")
	if txtMail then
		txtMail = WZUILabelTTF:luaTo(txtMail)
		txtMail:setText(mail)
	end
end

--@brief	是否显示邮件数量
--@param	isShow：true显示邮件数量，false不显示
function CellNearbyFriend:_setMailCountVisble(isShow)
	local conMailCount = self.m_root:getChildElement("conMailCount_CellNearbyFriend")
	if conMailCount then
		conMailCount = WZUIContainer:luaTo(conMailCount)
		conMailCount:setVisible(isShow)
	end
end

--@brief	显示玩家头像
function CellNearbyFriend:_showPlayerPhoto()
	self:_setPlayerIcon()--玩家默认头像
end

--@brief	显示头像
function CellNearbyFriend:_showPhoto()
	local bExist = WZFileUtil:isFileExist(RolePhoto:checkFileName(self.m_tFriend[10]))
	if bExist == true then
		local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. RolePhoto:checkFileName(self.m_tFriend[10])
		WZLog("0::::",fileName)
		self:_setPhoto(fileName)--玩家头像
	else
		WZLog("1::::::::",self.m_tFriend[10])
		--self:_setPlayerIconVisible(true)--玩家默认头像是显示
		--self:downLoadPhoto()--下载图片
	end
end

--@brief	玩家头像
function CellNearbyFriend:_setPhoto(icon)
	local imgPhoto = WZUIImage:luaTo(self.m_root:getChildElement("imgPhoto_CellNearbyFriend"))
	imgPhoto:setUseOriginSize(true)
	imgPhoto:setFile(icon)
	local size = imgPhoto:getContentSize()
	local hh = 110
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.min(x,y))
	WZLog("玩家头像CellNearbyFriend:",size.width,size.height)
end

--@brief	玩家头像是否显示
function CellNearbyFriend:_setPlayerPhotoVisible(bShow)
	local imgPhoto = self.m_root:getChildElement("imgPhoto_CellNearbyFriend")
	if imgPhoto then
		imgPhoto = WZUIImage:luaTo(imgPhoto)
		imgPhoto:setVisible(bShow)
	end
end

--@brief	玩家默认头像
function CellNearbyFriend:_setPlayerIcon()
	local nSex = self.m_tFriend[2]
	if nSex == 1 then
		self:_setDefBoyPhoto(false)--是显示默认男图片
		self:_setDefGirlPhoto(true)--是显示默认女图片
	else
		self:_setDefBoyPhoto(true)--是显示默认男图片
		self:_setDefGirlPhoto(false)--是显示默认女图片
	end
end

--@brief	是显示默认男图片
function CellNearbyFriend:_setDefBoyPhoto(bShow)
	local imgDefPhoto = self.m_root:getChildElement("imgDefBPhoto_WndRole")
	if imgDefPhoto then
		imgDefPhoto = WZUIImage:luaTo(imgDefPhoto)
		imgDefPhoto:setVisible(bShow)
	end
end

--@brief	是显示默认女图片
function CellNearbyFriend:_setDefGirlPhoto(bShow)
	local imgDefPhoto = self.m_root:getChildElement("imgDefGPhoto_WndRole")
	if imgDefPhoto then
		imgDefPhoto = WZUIImage:luaTo(imgDefPhoto)
		imgDefPhoto:setVisible(bShow)
	end
end

--@brief	玩家默认头像是否显示
function CellNearbyFriend:_setPlayerIconVisible(bShow)
	local conPlayerPhoto = self.m_root:getChildElement("conPlayerPhoto_CellNearbyFriend")
	if conPlayerPhoto then
		conPlayerPhoto = WZUIContainer:luaTo(conPlayerPhoto)
		conPlayerPhoto:setVisible(bShow)
	end
end

--@brief	下载图片
function CellNearbyFriend:downLoadPhoto()
	local tag = self.m_root:getTag()
	local photoName = RolePhoto:checkFileName(self.m_tFriend[10])
	local downURL = self.m_tFriend[10]
	downURL = downURL:gsub("\n","")
	downURL = downURL:gsub("\r","")
	local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
	local downloadTask = WZHTTPFileLuaTask:create(tag, downURL, photoName, self.downLoadPhotoBackFun, self)
	multiThread:addDownloadTaskInFront(downloadTask)
end

--@brief 	下载图片回调函数
function CellNearbyFriend:downLoadPhotoBackFun(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("downLoadPhoto:::::::taskId::::::::::",taskId,finish)
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		self:_setPlayerIconVisible(false)--玩家默认头像是不显示
		self:_setPhoto(path)
		if self.m_tDown then
			self.m_tDown[2](self.m_tDown[1],self.m_root:getTag() + 1)
		end
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end

-------------------------------------私有方法模块End----------------------------------------







