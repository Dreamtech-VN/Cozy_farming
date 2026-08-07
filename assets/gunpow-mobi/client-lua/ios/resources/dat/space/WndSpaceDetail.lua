--WndSpaceDetail.lua
--@brief	WndSpaceDetail的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人资料

local CONSTELLATION = {LocalStrings.SPACE79,LocalStrings.SPACE80,LocalStrings.SPACE81,LocalStrings.SPACE82,
			LocalStrings.SPACE83,LocalStrings.SPACE84,LocalStrings.SPACE85,LocalStrings.SPACE86,
			LocalStrings.SPACE87,LocalStrings.SPACE88,LocalStrings.SPACE89,LocalStrings.SPACE90}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceDetail:onEnter(element)
	self.m_root = element
	self:update()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceDetail:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndSpaceDetail:update()
	if self.m_root == nil then return end
	if WndSpaceMain.m_tData == nil then return end
	if "vn" == language then
		-- GetElement(self.m_root,"label6_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,0.15))
		-- local title6 = GetElement(self.m_root,"ttfTitle6",WZUILabelTTF)
		-- title6:setFontSize(20)
		-- title6:setRelativePosition(GlobalMethod:ccp(0.085,0.85))

		-- local label12 = GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF)
		-- label12:setRelativePosition(GlobalMethod:ccp(0.27,0.26))

		GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.85))
	end
	--性别
	if WndSpaceMain.m_tData.playerSex == 0 then
		GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE34)
		GetElement(self.m_root,"ttfSex",WZUILabelTTF):setText(LocalStrings.SPACE34)
	elseif WndSpaceMain.m_tData.playerSex == 1 then
		GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE35)
		GetElement(self.m_root,"ttfSex",WZUILabelTTF):setText(LocalStrings.SPACE35)
	elseif WndSpaceMain.m_tData.playerSex == 2 then
		GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE36)
		GetElement(self.m_root,"ttfSex",WZUILabelTTF):setText(LocalStrings.SPACE36)
	end
	--年龄
	if WndSpaceMain.m_tData.playerAge == 0 then
		GetElement(self.m_root,"label8_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE36)
		GetElement(self.m_root,"ttfAge",WZUILabelTTF):setText(LocalStrings.SPACE36)
	else
		GetElement(self.m_root,"label8_WndSpaceDetail",WZUILabelTTF):setText(WndSpaceMain.m_tData.playerAge)
		GetElement(self.m_root,"ttfAge",WZUILabelTTF):setText(WndSpaceMain.m_tData.playerAge)
	end
	--星座
	if WndSpaceMain.m_tData.playerCon == 0 then
		GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE36)
		GetElement(self.m_root,"ttfConstellation",WZUILabelTTF):setText(LocalStrings.SPACE36)
	else
		GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF):setText(CONSTELLATION[WndSpaceMain.m_tData.playerCon])
		GetElement(self.m_root,"ttfConstellation",WZUILabelTTF):setText(CONSTELLATION[WndSpaceMain.m_tData.playerCon])
	end
	--地区
	GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	if WndSpaceMain.m_tData.distance == "NP" then
		GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE36)
		GetElement(self.m_root,"txtDistance",WZUILabelTTF):setText(LocalStrings.SPACE36)
	elseif WndSpaceMain.m_tData.distance == "GT" then
		GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setText(LocalStrings.SPACE37)
		GetElement(self.m_root,"txtDistance",WZUILabelTTF):setText(LocalStrings.SPACE37)
	else
		GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setText(WndSpaceMain.m_tData.distance)
		GetElement(self.m_root,"txtDistance",WZUILabelTTF):setText(WndSpaceMain.m_tData.distance)
	end
	--语音
	--GetElement(self.m_root,"label11_WndSpaceDetail",WZUILabelTTF):setText(WndSpaceMain.m_tData.voiceInfo)

	self.m_nSex = WndSpaceMain.m_tData.playerSex

	--根据是否访客显示不同内容
	if WndSpaceMain.m_bIsHost then
		GetElement(self.m_root,"conRight2_WndSpaceDetail",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRight1_WndSpaceDetail",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conRight1_WndSpaceDetail",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRight2_WndSpaceDetail",WZUIContainer):setVisible(false)
	end

	--根据是否有录音显示录音按钮
	WZLog("个人录音",type(WndSpaceMain.m_tData.voiceInfo),WndSpaceMain.m_tData.voiceInfo)
	if WndSpaceMain.m_tData.voiceInfo ~= nil then
		if WndSpaceMain.m_tData.voiceInfo == "" then
			GetElement(self.m_root,"btnTape1",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnTape2",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnTape3",WZUIButton):setVisible(false)
			GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setVisible(true)
		else
			GetElement(self.m_root,"btnTape1",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnTape2",WZUIButton):setVisible(true)
			GetElement(self.m_root,"btnTape3",WZUIButton):setVisible(true)
			GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			--下载录音
			WndSpaceMain:addDownloadFileList(WndSpaceMain.m_tData.voiceInfo)
			local displayTime = string.sub(WndSpaceMain.m_tData.voiceInfo,1,string.find(WndSpaceMain.m_tData.voiceInfo,"_")-1)..[["]]
			GetElement(self.m_root,"label13_WndSpaceDetail",WZUILabelTTF):setText(displayTime)
			GetElement(self.m_root,"label14_WndSpaceDetail",WZUILabelTTF):setText(displayTime)
		end
	end
	
	-- 各种渠道屏蔽语音和位置
	local tabChannel = {1042,1043,1044,1061,1066,1067,1069,1040,1041,1074,1087,1095,1072,1091,1016,1009,1038,1046,1096,1097,1002,1003,1005,1056,1054,1055,1048,1088,1077,1079,1053,1051,1062,1094,1089,1098,1101,1099,1102,1103,1104,1105}
	for _,v in ipairs(tabChannel) do
        if ProjConfig.CHANNEL_ID == v then
        	--屏蔽语音
            GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label11_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label24_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"btnTape1",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnTape2",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnTape3",WZUIButton):setVisible(false)
			--屏蔽位置
			GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label23_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"conLocation_WndSpaceDetail",WZUIContainer):setVisible(false)
        end
    end

    GetElement(self.m_root,"label24_WndSpaceDetail",WZUILabelTTF):setVisible(false)
    GetElement(self.m_root,"btnTape1",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnTape2",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnTape3",WZUIButton):setVisible(false)
	GetElement(self.m_root,"label11_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	
end

--@brief	设置年龄星座
function WndSpaceDetail:onSetAge()
	WZLog("WndSpaceDetail:onSetAge")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceChoose:createElement()
	WindowManager:addWindow(wnd, WndSpaceChoose, true, nil, nil, true)
end

--@brief	设置性别
function WndSpaceDetail:onSet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSex = (self.m_nSex + 1)%3
	local sexList = {LocalStrings.SPACE34,LocalStrings.SPACE35,LocalStrings.SPACE36}
	GetElement(self.m_root,"ttfSex",WZUILabelTTF):setText(sexList[self.m_nSex+1])
	WndSpaceMain.m_tData.playerSex = self.m_nSex
	WndSpaceMain:sendProtocol()
end

--@brief	设置距离
function WndSpaceDetail:onSetDistance(element)
	WZLog("WndSpaceDetail:onSetDistance")
	local result = WZLocation:getInstance():getCurrentCoordinate()
	WZLog("result:",result)
	if result ~=  nil then
		local resultTable = json.decode(result)
		if resultTable.result == true then
			ProtocolProcessorWndSpace:send_SPACE_SetGPSInfo(resultTable.Longitude*100000, resultTable.Latitude*100000 )
		end
	end
end

--@brief	录音
function WndSpaceDetail:onTape(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceTape:createElement()
	WindowManager:addWindow(wnd, WndSpaceTape, true, nil, nil, true)
end

--@brief	播放录音
function WndSpaceDetail:onBroadcast(element)
	if WndSpaceMain.m_tData.voiceInfo ~= nil then
		if WndSpaceMain.m_tData.voiceInfo ~= "" then
			local displayTime = string.sub(WndSpaceMain.m_tData.voiceInfo,1,string.find(WndSpaceMain.m_tData.voiceInfo,"_")-1)..[["]]
			local wnd = WndSpaceTape:createElement()
			WindowManager:addWindow(wnd, WndSpaceTape, true, nil, nil, true)
			WndSpaceTape:setFinish(displayTime)
			local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..WndSpaceMain.m_tData.voiceInfo
			WndSpaceTape.m_sTape = path
		end
	end
end

--@brief	播放录音
function WndSpaceDetail:onBroadcastOther(element)
	if self.m_bPlaying == true then return end
	if WndSpaceMain.m_tData.voiceInfo ~= nil and WndSpaceMain.m_tData.voiceInfo ~= "" then
		--暂停背景音乐
		SoundManager:pauseBackgroundMusic()
		--记住当前是否打开背景音乐
		self.nBgMusicState = SoundManager.nBgMusicState
		self.m_nTime = string.sub(WndSpaceMain.m_tData.voiceInfo,1,string.find(WndSpaceMain.m_tData.voiceInfo,"_")-1)
		self.m_nTime = tonumber(self.m_nTime)
		--打开背景音乐
		SoundManager:setBgMusicMute(1)
		SAVEDBGMUSIC = SoundManager.m_fileKey
		WZLog("录音文件路径",CCFileUtils:sharedFileUtils():getTmpWritablePath()..WndSpaceMain.m_tData.voiceInfo)
		SoundManager:playBgMusic(CCFileUtils:sharedFileUtils():getTmpWritablePath()..WndSpaceMain.m_tData.voiceInfo,false)
		self.m_bPlaying = true
		self.m_root:enableSchedule("scheduleBGM",1)
	end
end

--@brief	录音播放完后恢复背景音乐状态
function WndSpaceDetail:scheduleBGM()
	self.m_nTime = self.m_nTime - 1
	WZLog("录音剩余秒数",self.m_nTime)
	if self.m_nTime <= 0 then
		self:resumeBgMusic()
		self.m_root:disableSchedule()
		self.m_bPlaying = false
	end
end

--@brief	中断录音时的处理
function WndSpaceDetail:resumeBgMusic()
	if self.m_bPlaying == false then return end
	--恢复之前的背景音乐设置
	if self.nBgMusicState ~= nil then
		SoundManager:setBgMusicMute(self.nBgMusicState)
	end
	--播放之前的背景音乐
	if SAVEDBGMUSIC == nil then
   		SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
	else
   		SoundManager:playBgMusic(SAVEDBGMUSIC)
	end
	if self.nBgMusicState == 0 then
		SoundManager:stopBgMusic()
	end
end

--@brief	上传录音回调
function WndSpaceDetail:onUploadFinish(sjson)
	WZLog("WndSpaceDetail:onUploadFinish",sjson)
  
	local sJson = json.decode(sjson) 
	if sJson["return"] == "success" then 
		MsgBoxManager:showTipBox(LocalStrings.SPACE47)
		WndSpaceMain:sendProtocol()
	else
		WndSpaceMain.m_tData.voiceInfo = ""
		MsgBoxManager:showTipBox(LocalStrings.SPACE48)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSpaceDetail:_adaptLanguage_en()
	WZLog("WndSpaceDetail:_adaptLanguage_en")
	
	local label = GetElement(self.m_root,"label30_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.85))

	label = GetElement(self.m_root,"label31_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.6))

	label = GetElement(self.m_root,"label32_WndSpaceDetail",WZUILabelTTF)
	label:setScale(0.8)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.35))

	label = GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.1))

    local label7 = GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF)
	label7:setRelativePosition(GlobalMethod:ccp(0.321902,0.85))
	local label8 = GetElement(self.m_root,"label8_WndSpaceDetail",WZUILabelTTF)
	label8:setRelativePosition(GlobalMethod:ccp(0.216984,0.6))
	
	local label10 = GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF)
	label10:setRelativePosition(GlobalMethod:ccp(0.361246,0.1))

	GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.85))
	GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.35))
	GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.1))

	local label9 = GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF)
    label9:setRelativePosition(GlobalMethod:ccp(0.52,0.57))
    GetElement(self.m_root,"conLocation_WndSpaceDetail",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0,0.1))
	GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.1))
	GetElement(self.m_root,"btnTape1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.69,0.1))
end

function WndSpaceDetail:_adaptLanguage_pt(  )
	local label = GetElement(self.m_root,"label30_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.85))

	label = GetElement(self.m_root,"label31_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.6))

	label = GetElement(self.m_root,"label32_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.35))

	label = GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.1))

	label = GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.1))


	GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.85))
	GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.35))
	GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.1))
end

function WndSpaceDetail:_adaptLanguage_vn(  )
	local label = GetElement(self.m_root,"label30_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.85))
	
	GetElement(self.m_root,"conLocation_WndSpaceDetail",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.1))
	--GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.1))
	GetElement(self.m_root,"btnTape1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.79,0.1))
end

function WndSpaceDetail:_adaptLanguage_th(  )
	GetElement(self.m_root,"conLocation_WndSpaceDetail",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.1))
	GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.1))
	GetElement(self.m_root,"btnTape1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.69,0.1))
end

function WndSpaceDetail:_adaptLanguage_cn(  )
	GetElement(self.m_root,"conLocation_WndSpaceDetail",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.1))
	GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.1))
	GetElement(self.m_root,"btnTape1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.69,0.1))
end

function WndSpaceDetail:_adaptLanguage_tr(  )
	local label = GetElement(self.m_root,"label30_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.85))

	label = GetElement(self.m_root,"label31_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.6))

	label = GetElement(self.m_root,"label32_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.35))
	label:setDimensions(GlobalMethod:CCSize(100,0))
	label:setScale(0.75)

	label = GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.43))

	label = GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.26))

	label = GetElement(self.m_root,"label7_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.35,0.85))

	label = GetElement(self.m_root,"label8_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.22,0.6))

	label = GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.55,0.35))

	label = GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.36,0.1))
end

function WndSpaceDetail:_adaptLanguage_es(  )
	local label = GetElement(self.m_root,"label30_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.85))

	label = GetElement(self.m_root,"label31_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.6))

	label = GetElement(self.m_root,"label32_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(-0.03,0.35))
	label:setScale(0.77)

	label = GetElement(self.m_root,"label33_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.1))

	label = GetElement(self.m_root,"label34_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.0,0.1))

	label = GetElement(self.m_root,"label12_WndSpaceDetail",WZUILabelTTF)
	label:setRelativePosition(GlobalMethod:ccp(0.26,0.1))

	GetElement(self.m_root,"label10_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.1))
	GetElement(self.m_root,"label9_WndSpaceDetail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.35))
end
-------------------------------------语言适配End--------------------------------------------