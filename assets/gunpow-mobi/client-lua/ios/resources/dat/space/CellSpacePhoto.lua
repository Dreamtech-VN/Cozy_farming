--CellSpacePhoto.lua
--@brief	CellSpacePhoto的UI模块
--@date		2016/01/06
--@author	zsq
--@note		照片cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpacePhoto:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpacePhoto:onExit(element)
	self:_unInit()
end



--@brief	点击上传照片
function CellSpacePhoto:onUpload(element)
	WZLog("CellSpacePhoto:onCheckType4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local uploadStatus = CacheCenter:getGameParam().uploadStatus
	--uploadStatus = 1
	if uploadStatus ~= nil and tonumber(uploadStatus) ~= nil and tonumber(uploadStatus) == 1 then
		MsgBoxManager:showTipBox(LocalStrings.NO_UPLOAD_PHOTOS)
		return
	end

	if not WndSpaceMain.m_bIsHost then return end

	local conForPopMenu = GetElement(WndSpaceMain.m_root, "conSubWnd_WndSpaceMain", WZUIContainer)
	local sizeCon = conForPopMenu:getAbsContentSize()
	
	local popupMenu = WndPopupMenu:createElement()
	conForPopMenu:addChild(popupMenu)	
	popupMenu:setVisible(true)

	WndPopupMenu:disappear()

	local menuList = self:setUploadMenuItems()
	WndPopupMenu:setPopupMenuItem(menuList,nil)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

	if self.m_root ~= nil then
		local offset = 0
		if (self.m_nIndex-1)%4 == 3 then offset = -50 end
		WndPopupMenu:popUpAtPoint(conForPopMenu, ccp((sizeCon.width - 190)/2-140+(self.m_nIndex-1)%4*140 + offset, 320 - math.floor((self.m_nIndex-1)/4)*320))
	end 

	WndSpacePhoto.m_nPhotoIndex = self.m_nIndex
end

--@brief	点击未开启图片
function CellSpacePhoto:onOpen(element)
	WZLog("CellSpacePhoto:onCheckType4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not WndSpaceMain.m_bIsHost then return end
	local index = self.m_nIndex
	local tips = string.format(LocalStrings.SPACE44,8)
	if index == 5 then
		tips = string.format(LocalStrings.SPACE44,8)
	elseif index == 6 then
		tips = string.format(LocalStrings.SPACE44,10)
	elseif index == 7 then
		tips = string.format(LocalStrings.SPACE44,12)
	elseif index == 8 then
		tips = string.format(LocalStrings.SPACE44,14)
	end
    MsgBoxManager:showConfirmBox(tips, self, self.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil,true)
end

--@brief	点击审核中的图片
function CellSpacePhoto:onCheckType3(element)
	WZLog("CellSpacePhoto:onCheckType4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--还有图片在下载，返回
	if WndSpaceMain.m_tDownloadFileList ~= nil and #WndSpaceMain.m_tDownloadFileList > 0 then return end

	local conForPopMenu = GetElement(WndSpaceMain.m_root, "conSubWnd_WndSpaceMain", WZUIContainer)
	local sizeCon = conForPopMenu:getAbsContentSize()
	
	local popupMenu = WndPopupMenu:createElement()
	conForPopMenu:addChild(popupMenu)	
	popupMenu:setVisible(true)

	WndPopupMenu:disappear()

	local menuList = self:setMenuItems()
	WndPopupMenu:setPopupMenuItem(menuList,nil)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

	if self.m_root ~= nil then
		local offset = 0
		if (self.m_nIndex-1)%4 == 3 then offset = -115 end
		WndPopupMenu:popUpAtPoint(conForPopMenu, ccp((sizeCon.width - 190)/2-105+(self.m_nIndex-1)%4*150 + offset, 320 - math.floor((self.m_nIndex-1)/4)*320))
	end 
end

--@brief	点击已上传的图片
function CellSpacePhoto:onCheckType4(element)
	WZLog("CellSpacePhoto:onCheckType4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--还有图片在下载，返回
	if WndSpaceMain.m_tDownloadFileList ~= nil and #WndSpaceMain.m_tDownloadFileList > 0 then return end

	if WndSpaceMain.m_bIsHost then
		local conForPopMenu = GetElement(WndSpaceMain.m_root, "conSubWnd_WndSpaceMain", WZUIContainer)
		local sizeCon = conForPopMenu:getAbsContentSize()
		
		local popupMenu = WndPopupMenu:createElement()
		conForPopMenu:addChild(popupMenu)	
		popupMenu:setVisible(true)
		WZLog("self.m_root",self.m_root,popupMenu:getPositionX(),popupMenu:getPositionY(),popupMenu:isVisible())

		WndPopupMenu:disappear()

		local menuList = self:setMenuItems()
		WndPopupMenu:setPopupMenuItem(menuList,nil)
		WndPopupMenu:setCallBackFunc(self, self.onClickPopup)

		if self.m_root ~= nil then
			local offset = 0
			if (self.m_nIndex-1)%4 == 3 then offset = -115 end
			WndPopupMenu:popUpAtPoint(conForPopMenu, ccp((sizeCon.width - 190)/2-105+(self.m_nIndex-1)%4*150 + offset, 320 - math.floor((self.m_nIndex-1)/4)*320))
		end 
	else
		self:onView()
	end
end

--@brief	已上传菜单
function CellSpacePhoto:setMenuItems()
	local tPopupMenuItems = {}

	--显示查看大图按钮
	table.insert(tPopupMenuItems,POPUPMENU_SPACE1)

	--是否显示设置头像按钮
	if WndSpaceMain.m_bIsHost then
		table.insert(tPopupMenuItems,POPUPMENU_SPACE2)
	end

	--是否显示删除按钮
	if WndSpaceMain.m_bIsHost then
		table.insert(tPopupMenuItems,POPUPMENU_SPACE3)
	end

	return tPopupMenuItems
end

--@brief	上传菜单
function CellSpacePhoto:setUploadMenuItems()
	local tPopupMenuItems = {}

	--显示拍照上传按钮
    if getTotalMemory() > 900 then
		table.insert(tPopupMenuItems,POPUPMENU_SPACE4)
	end

	--显示本地上传按钮
	table.insert(tPopupMenuItems,POPUPMENU_SPACE5)

	return tPopupMenuItems
end

--@brief  按钮回调函数
function CellSpacePhoto:onClickPopup(element,nId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPopupMenu:disappear()
	if nId == POPUPMENU_SPACE1 then 	
		self:onView()
	elseif nId == POPUPMENU_SPACE2 then   
		self:setHead()
	elseif nId == POPUPMENU_SPACE3 then
		self:onDelete()
	elseif nId == POPUPMENU_SPACE4 then
		self:onUpload1()
	elseif nId == POPUPMENU_SPACE5 then
		self:onUpload2()
	end
end

--@brief	查看大图
function CellSpacePhoto:onView(element)
    WZLog("CellSpacePhoto:onView")
	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)

	--如果已经下载头像
	if self.m_sPath ~= nil and self.m_sPath ~= "" then
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..self.m_sPath
		--如果文件存在，不下载，直接使用
		local bExist = WZFileUtil:isFileExist(path)
		if bExist then
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(path)
		else
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
		end
	else
		GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
	end
end

--@brief	设置头像
function CellSpacePhoto:setHead(element)
    WZLog("CellSpacePhoto:setHead")
	ProtocolProcessorWndSpace:send_SPACE_UpdateHeadScul(self.m_nIndex - 1)
end

--@brief	删除图片
function CellSpacePhoto:onDelete(element)
    WZLog("CellSpacePhoto:onDelete")
    MsgBoxManager:showConfirmBox(LocalStrings.SPACE52, self, self.onDeleteCall, MSGBOXLEVEL_HIGH)
end

--@brief	删除图片回调
function CellSpacePhoto:onDeleteCall(element)
	ProtocolProcessorWndSpace:send_SPACE_DelPhoto(self.m_nIndex - 1)
	MsgBoxManager:showTipBox(LocalStrings.SPACE45)
end

--@brief	拍照上传
function CellSpacePhoto:onUpload1(element)
    WZLog("CellSpacePhoto:onBtn1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--上传照片等级限制
	if CheckButtonOpen(63) ~= true then return end

	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	deviceHelper:setPickerIndex(0)
	deviceHelper:imageCropper(CellSpacePhoto.onPhotoBack , CellSpacePhoto)

	WndSpacePhoto.m_nUploadType = 0
	WndSpacePhoto.m_tUploadCell = self
end

--@brief	本地上传
function CellSpacePhoto:onUpload2(element)
    WZLog("CellSpacePhoto:onBtn2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--上传照片等级限制
	if CheckButtonOpen(63) ~= true then return end
	--if WndSpaceMain.m_tData.playerLevel < 25 then
	--	MsgBoxManager:showTipBox("25"..LocalStrings.LEVEL_OPEN_THIS_FUNCTION)
	--	return
	--end

	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	deviceHelper:setPickerIndex(1)
	deviceHelper:imageCropper(CellSpacePhoto.onPhotoBack , CellSpacePhoto)

	WndSpacePhoto.m_nUploadType = 1
	WndSpacePhoto.m_tUploadCell = self
end

--@brief	打开图片回调函数
function CellSpacePhoto:onPhotoBack(file)
    local tCell = self
	WZLog("file::::::::",file,WZFileUtil:getFileSize(file),math.floor(WZFileUtil:getFileSize(file)/1000000) )
	--文件路径
	if WZFileUtil:isFullPathExist(file) == false then
        CCLuaLog("------upload file not exist!")
        return
    end
	if math.floor(WZFileUtil:getFileSize(file)/1000000) > 5 then
		WZLog("文件大于1M:::")
		return
	end

	local wnd = WndSpaceUploadConfirm:showInterface(1)

	local imgPhoto = GetElement(wnd,"imgHead1",WZUI9Image)
	imgPhoto:setUseOriginSize(true)
	imgPhoto:setFile(file)
	local size = imgPhoto:getContentSize()
	local hh = 100
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.min(x,y))
	local imgPhoto1 = GetElement(wnd,"imgHead2",WZUI9Image)
	imgPhoto1:setUseOriginSize(true)
	imgPhoto1:setFile(file)
	imgPhoto1:setScale(math.min(x,y))
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellSpacePhoto:update(tData,index)
	if self.m_root == nil then return end
	if tData.photoStatus[index] == nil then return end
	for i=1,5 do
		GetElement(self.m_root,"conType"..i.."_CellSpacePhoto",WZUIContainer):setVisible(false)
	end
	if tData.photoStatus[index] == 1 then
		--未开启
		GetElement(self.m_root,"conType1_CellSpacePhoto",WZUIContainer):setVisible(true)
		if index == 5 then
			GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setText("VIP8"..LocalStrings.MAP_EVENT_ON)		
		elseif index == 6 then
			GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setText("VIP10"..LocalStrings.MAP_EVENT_ON)		
		elseif index == 7 then
			GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setText("VIP12"..LocalStrings.MAP_EVENT_ON)		
		elseif index == 8 then
			GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setText("VIP14"..LocalStrings.MAP_EVENT_ON)		
		end
	elseif tData.photoStatus[index] == 2 then
		--未上传
		if WndSpaceMain.m_bIsHost == true then
			GetElement(self.m_root,"conType2_CellSpacePhoto",WZUIContainer):setVisible(true)
		else
			GetElement(self.m_root,"conType5_CellSpacePhoto",WZUIContainer):setVisible(true)
		end
	elseif tData.photoStatus[index] == 3 then
		local con = GetElement(self.m_root,"conHeadType3",WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		if WndSpaceMain.m_bIsHost == true then
			--未审核
			GetElement(self.m_root,"conType3_CellSpacePhoto",WZUIContainer):setVisible(true)
			self:setLodingPhoto(true)
			--下载头像
			--添加下载图片Cell
			local celElement,tCell = CellDownloadImg:createElement()
			con:addChild(celElement)

			WndSpaceMain:addDownloadFileList(tData.photoUrl[index], tCell, nil,120,self)
			self.m_sPath = tData.photoUrl[index]
		else
			GetElement(self.m_root,"conType5_CellSpacePhoto",WZUIContainer):setVisible(true)
		end
	elseif tData.photoStatus[index] == 4 then
		--已审核
		GetElement(self.m_root,"conType4_CellSpacePhoto",WZUIContainer):setVisible(true)
		self:setLodingPhoto(true)
		--下载头像
		--添加下载图片Cell
		local con = GetElement(self.m_root,"conHeadType4",WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		WndSpaceMain:addDownloadFileList(tData.photoUrl[index], tCell, nil,120,self)
		self.m_sPath = tData.photoUrl[index]
	end
end

--@brief	设置是否在加载照片
function CellSpacePhoto:setLodingPhoto(bool)
	WZLog("CellSpacePhoto:setLodingPhoto",self.m_nIndex,bool)
	if self.m_root == nil then return end
	GetElement(self.m_root,"imgLoding",WZUIImage):setVisible(bool)
end

--@brief	设置无效图片
function CellSpacePhoto:setInvalidPhoto()
	WZLog("CellSpacePhoto:setInvalidPhoto")
	if self.m_root == nil then return end
	GetElement(self.m_root,"conType2_CellSpacePhoto",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conType5_CellSpacePhoto",WZUIContainer):setVisible(true)
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin------------------------------------------
function CellSpacePhoto:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttf2_CellSpacePhoto",WZUILabelTTF):setFontSize(16)
end

function CellSpacePhoto:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setScale(0.9)
end


function CellSpacePhoto:_adaptLanguage_pt(  )
	GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setScale(0.6)
end

function CellSpacePhoto:_adaptLanguage_es(  )
	local ttf1 = GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF)
	--ttf1:setDimensions(GlobalMethod:CCSize(60,0))
	ttf1:setScale(0.6)
	local ttf2 = GetElement(self.m_root,"ttf2_CellSpacePhoto",WZUILabelTTF)
	ttf2:setScale(0.8)
	local ttf3 = GetElement(self.m_root,"ttf3_CellSpacePhoto",WZUILabelTTF)
	ttf3:setDimensions(GlobalMethod:CCSize(100,0))
end

function CellSpacePhoto:_adaptLanguage_tr(  )
	GetElement(self.m_root,"ttf2_CellSpacePhoto",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"ttf1_CellSpacePhoto",WZUILabelTTF):setScale(0.78)
end
--------------------------------------语言适配End--------------------------------------------
