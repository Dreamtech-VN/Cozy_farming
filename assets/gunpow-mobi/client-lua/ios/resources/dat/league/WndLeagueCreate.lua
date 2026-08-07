--WndLeagueCreate.lua
--@brief	WndLeagueCreate的UI模块
--@date		2016/06/12
--@author	zsq
--@note		创建战队


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueCreate:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndLeagueCreate:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
	WZLog("创建战队消耗",Serialize(CacheCenter:getGameParam().heroTeamCost))
	local string = string.sub(CacheCenter:getGameParam().heroTeamCost,2,-2) 
	self.m_nCost = tonumber(SplitStringWithSeparator(string,",")[2])
	self.m_nCostId = tonumber(SplitStringWithSeparator(string,",")[1])

	GetElement(self.m_root,"txtCost",WZUILabelTTF):setText(self.m_nCost)
	local imgCostIcon = GetElement(self.m_root,"imgCostIcon_WndLeagueCreate",WZUIImage)
	if imgCostIcon then
		imgCostIcon:setFile(GDatatab_item["id_" .. self.m_nCostId].icon)
		imgCostIcon:setScale(0.5)
	end
	GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):setPlaceHolder(LocalStrings.LEAGUE91)
end

--@brief    弹窗动画完成后的回调
function WndLeagueCreate:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueCreate:onExit(element)
	self:_unInit()
end

function WndLeagueCreate:onClose()
	WZLog("WndLeagueCreate:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	显示接口
function WndLeagueCreate:show()
	WZLog("WndLeagueCreate:show")
	if self.m_root == nil then 
		local wnd = WndLeagueCreate:createElement()
		WindowManager:addWindow(wnd, WndLeagueCreate, nil, nil, true)
	end
	GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(LocalStrings.LEAGUE30)
	GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):setTouchEnable(true)
	GetElement(self.m_root,"inputPassword_WndLeagueCreate",WZUIEditBox):setTouchEnable(true)
	GetElement(self.m_root,"conGold",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"imgNameBg",WZUI9Image):setVisible(true)
	GetElement(self.m_root,"txtCheck",WZUILabelTTF):setVisible(false)
	self.m_nType = 1
end

--@brief	设置功能接口
function WndLeagueCreate:showSetting(name,declaration,url)
	if self.m_root == nil then 
		local wnd = WndLeagueCreate:createElement()
		WindowManager:addWindow(wnd, WndLeagueCreate, nil, nil, true)
	end
	GetElement(self.m_root,"txtTitle",WZUILabelTTF):setText(LocalStrings.LEAGUE31)
	GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):setText(name)
	GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):setTouchEnable(false)
	GetElement(self.m_root,"inputPassword_WndLeagueCreate",WZUIEditBox):setText(declaration)
	GetElement(self.m_root,"conGold",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"imgNameBg",WZUI9Image):setVisible(false)
	self.m_nType = 2
	if url == nil or url == "" then return end
	
	--战队图标
	local size = 120
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..url
	local imgPhoto = GetElement(self.m_root,"imgTeamIcon",WZUI9Image)
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		WZLog("文件存在")
		imgPhoto:setFile(path) 
		local imgSize = imgPhoto:getContentSize()
		local x = size/imgSize.width 
		local y = size/imgSize.height
		WZLog("缩放比例",size,imgSize.width,imgSize.height,math.max(x,y))
		imgPhoto:setScale(math.max(x,y))
	end
	--审核状态
	if WndLeagueTeamDetail.m_tData ~= nil and WndLeagueTeamDetail.m_tData.picStatus == 3 then
		GetElement(self.m_root,"txtCheck",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"txtCheck",WZUILabelTTF):setVisible(false)
	end
end

--@brief	选择战队图标
function WndLeagueCreate:onSelect()
	WZLog("WndLeagueCreate:onSelect")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local uploadStatus = CacheCenter:getGameParam().uploadStatus
	--uploadStatus = 1
	if uploadStatus ~= nil and tonumber(uploadStatus) ~= nil and tonumber(uploadStatus) == 1 then
		MsgBoxManager:showTipBox(LocalStrings.NO_UPLOAD_PHOTOS)
		return
	end

	local deviceHelper = WZDeviceHelper:sharedDeviceHelper()
	deviceHelper:setPickerIndex(1)
	deviceHelper:imageCropper(WndLeagueCreate.onPhotoBack , WndLeagueCreate)
end

--@brief	打开图片回调函数
function WndLeagueCreate:onPhotoBack(file)
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

	local imgPhoto = GetElement(self.m_root,"imgTeamIcon",WZUI9Image)
	imgPhoto:setFile(file)
	local size = imgPhoto:getContentSize()
	local hh = 120
	local x = hh/size.width 
	local y = hh/size.height
	imgPhoto:setScale(math.min(x,y))
end

--@brief	确认上传
function WndLeagueCreate:onUpload()
    WZLog("WndLeagueCreate:onUpload")
	if self.m_bUploading == true then return end
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox(16)
	self.m_bUploading = true
	self.m_nUploadTime = 0
	self.m_bUploadOutTime = false

	local s = {} 
	s.objName = ProjConfig:getChannelId().."_"..CacheCenter:getPlayerInfo().id.."_"..os.time().."_".."teamIcon"..".png"
	s.filePath = GetElement(self.m_root,"imgTeamIcon",WZUI9Image):getFile()
	local sJson =  json.encode(s) 
	DSSdkManager:putFile(sJson,self.onUploadFinish,self)
	WZLog("上传文件名",s.objName)
	self.m_sPhotoName = s.objName
	self.m_root:enableSchedule("onUploadCountdown",1)
end

--@brief	上传计时
function WndLeagueCreate:onUploadCountdown(element, t)
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
function WndLeagueCreate:onUploadFinish(sjson)
	WZLog("WndLeagueCreate:onUploadFinish",sjson)
	if self.m_bUploadOutTime == true then return end
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
	self.m_bUploading = false

	local sJson = json.decode(sjson) 
	if sJson["return"] == "success" then 
		local name = GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):getText()
		local declaration = GetElement(self.m_root,"inputPassword_WndLeagueCreate",WZUIEditBox):getText()
		local decNum, blankCount = CheckInputTxtLen(declaration)
		if decNum > 75 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE36)
			return
		end
		if self.m_nType == 1 then
			ProtocolProcessorWndLeague:send_HERO_CreateTeam(name, declaration, self.m_sPhotoName )
		elseif self.m_nType == 2 then
			ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec(declaration, self.m_sPhotoName )	
		end
		WindowManager:removeWindow(self.m_root, self, true)
	else
		MsgBoxManager:showTipBox(LocalStrings.SPACE51)
	end
end

--@brief	创建战队
function WndLeagueCreate:onCreate()
	WZLog("WndLeagueCreate:onCreate",GetElement(self.m_root,"imgTeamIcon",WZUI9Image):getFile())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local name = GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):getText()
	local declaration = GetElement(self.m_root,"inputPassword_WndLeagueCreate",WZUIEditBox):getText()

	if name ~= "" and name ~= nil and string.find(name,"%s") ~= nil then 
		--有空白符
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE61) 
		return 
	end 

	if name == "" or name == nil or Regexp:isAllBlankChar(name) == true then 
		--请输入公会名字
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE27) 
		return 
	end 

	local strLen = ChineseStringLen(name)
	--检测公会名字合法性
	result = JudgeResultInClientForInputText(3, name)
	if result ~= 0 then 
		DisplayResult(result)
		return
	end

	--是否包含特殊符号
	if string.find(name, "%p") then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE42)
		return
	end

	--检测战队图标
	--if GetElement(self.m_root,"imgTeamIcon",WZUI9Image):getFile() == "ui/hero/hero_icon_yxlsdb.png" then
	--	--请选择战队图标
	--	MsgBoxManager:showTipBox(LocalStrings.LEAGUE29) 
	--	return 
	--end

	if self.m_nType == 1 then
		--钻石不足
		if not JudgeMoneyIsEnough(self.m_nCostId, self.m_nCost, nil, nil, Chat_Channel_League_TEAM, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
			return 
		end
	end
 
 	self:sureUseDiamondInstead()
end

--@brief	点击确定充值回调
function WndLeagueCreate:sureUseDiamondInstead()
	--创建战队
	if GetElement(self.m_root,"imgTeamIcon",WZUI9Image):getFile() == "ui/hero/hero_icon_yxlsdb.png" then
		local name = GetElement(self.m_root,"inputName_WndLeagueCreate",WZUIEditBox):getText()
		local declaration = GetElement(self.m_root,"inputPassword_WndLeagueCreate",WZUIEditBox):getText()
		local decNum, blankCount = CheckInputTxtLen(declaration)
		if decNum > 75 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE36)
			return
		end
		if self.m_nType == 1 then
			ProtocolProcessorWndLeague:send_HERO_CreateTeam(name, declaration, "" )
		elseif self.m_nType == 2 then
			ProtocolProcessorWndLeague:send_HERO_NewPhotoAndDec(declaration, "" )	
		end
    	WindowManager:removeWindow(self.m_root, self, true)
	else
		self:onUpload()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin----------------------------------------
function WndLeagueCreate:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtPassword_WndLeagueCreate",WZUILabelTTF):setScale(0.8)
end
---------------------------------------语言适配End------------------------------------------
