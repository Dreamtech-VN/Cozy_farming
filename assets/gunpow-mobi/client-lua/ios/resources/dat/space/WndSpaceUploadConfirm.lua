--WndSpaceUploadConfirm.lua
--@brief	WndSpaceUploadConfirm的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人上传照片确认


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceUploadConfirm:onEnter(element)
	self.m_root = element
	 --语言适配函数
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceUploadConfirm:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpaceUploadConfirm:onClose(element)
    WZLog("WndSpaceUploadConfirm:onClose")
	if self.m_bUploading == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	查看大图
function WndSpaceUploadConfirm:onView(element)
    WZLog("WndSpaceUploadConfirm:onView")
	if self.m_bUploading == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)

	local img = GetElement(self.m_root,"imgHead1",WZUI9Image)
	GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(img:getFile())
end

--@brief	重新选择
function WndSpaceUploadConfirm:onChoose(element)
    WZLog("WndSpaceUploadConfirm:onChoose")
	if self.m_bUploading == true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 2 then
		if WndCheckOther.m_nUploadType == 0 then
			local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
			deviceHelper:setPickerIndex(0)
			deviceHelper:imageCropper(WndCheckOther.m_tUploadCell.onPhotoBack , WndCheckOther.m_tUploadCell)
		elseif WndCheckOther.m_nUploadType == 1 then
			local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
			deviceHelper:setPickerIndex(1)
			deviceHelper:imageCropper(WndCheckOther.m_tUploadCell.onPhotoBack , WndCheckOther.m_tUploadCell)
		end
	else
		if WndSpacePhoto.m_nUploadType == 0 then
			local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
			deviceHelper:setPickerIndex(0)
			deviceHelper:imageCropper(WndSpacePhoto.m_tUploadCell.onPhotoBack , WndSpacePhoto.m_tUploadCell)
		elseif WndSpacePhoto.m_nUploadType == 1 then
			local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
			deviceHelper:setPickerIndex(1)
			deviceHelper:imageCropper(WndSpacePhoto.m_tUploadCell.onPhotoBack , WndSpacePhoto.m_tUploadCell)
		end
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	确认上传
function WndSpaceUploadConfirm:onUpload(element)
    WZLog("WndSpaceUploadConfirm:onUpload")
	if self.m_bUploading == true then return end

	if self.m_nType == 2 then
	else
		if WndSpacePhoto.m_nPhotoIndex == nil then return end
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox(16)
	self.m_bUploading = true
	self.m_nUploadTime = 0
	self.m_bUploadOutTime = false

	local s = {} 
	if self.m_nType == 2 then
		s.objName = ProjConfig:getChannelId().."_".. CacheCenter:getPlayerInfo().id .."_"..os.time().."_".."photo".. "1" ..".png"
	else
		s.objName = ProjConfig:getChannelId().."_"..WndSpaceMain.m_nPlayerId.."_"..os.time().."_".."photo"..WndSpacePhoto.m_nPhotoIndex..".png"
	end
	s.filePath = GetElement(self.m_root,"imgHead1",WZUI9Image):getFile()
	local sJson =  json.encode(s) 
	DSSdkManager:putFile(sJson,self.onUploadFinish,self)
	WZLog("上传文件名",s.objName)
	self.m_sPhotoName = s.objName
	self.m_root:enableSchedule("onUploadCountdown",1)
end

--@brief	上传计时
function WndSpaceUploadConfirm:onUploadCountdown(element, t)
	self.m_nUploadTime = self.m_nUploadTime + 1
	if self.m_nUploadTime > 15 then
		self.m_bUploadOutTime = true
		self.m_bUploading = false
		--弹出上传失败提示
		MsgBoxManager:showTipBox(LocalStrings.SPACE78)
		element:disableSchedule()
	end
end

--@brief	上传完成回调
function WndSpaceUploadConfirm:onUploadFinish(sjson)
	WZLog("WndSpaceUploadConfirm:onUploadFinish",sjson)
	if self.m_bUploadOutTime == true then return end

	if self.m_nType == 2 then
	else
		if WndSpacePhoto.m_nPhotoIndex == nil then return end
	end
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
	self.m_bUploading = false

	local sJson = json.decode(sjson) 
	if sJson["return"] == "success" then 
		if self.m_nType == 2 then
			ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl(0, self.m_sPhotoName )
		else
			ProtocolProcessorWndSpace:send_SPACE_SetPhotoUrl(WndSpacePhoto.m_nPhotoIndex - 1, self.m_sPhotoName )
		end
		MsgBoxManager:showTipBox(LocalStrings.SPACE50)
		WindowManager:removeWindow(self.m_root, self, true)
	else
		MsgBoxManager:showTipBox(LocalStrings.SPACE51)
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Start----------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndSpaceUploadConfirm:_adaptLanguage_en()
	GetElement(self.m_root,"txtCancel_WndSpaceUploadConfirm",WZUILabelTTF):setFontSize(20)
end

function WndSpaceUploadConfirm:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtCancel_WndSpaceUploadConfirm",WZUILabelTTF):setFontSize(20)
end

function WndSpaceUploadConfirm:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtSure_WndSpaceUploadConfirm",WZUILabelTTF):setFontSize(21)
end

function WndSpaceUploadConfirm:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtCancel_WndSpaceUploadConfirm",WZUILabelTTF):setFontSize(22)
end
-------------------------------------语言适配模块End----------------------------------------
