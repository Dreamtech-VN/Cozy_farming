--CellWeChat.lua
--@brief	CellWeChat的UI模块
--@date		2017/02/15
--@author	zhangming
--@note		微信分享


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWeChat:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWeChat:onExit(element)
	self:_unInit()
end

function CellWeChat:setPosition(post)
	if post == nil then return end
	
end

function CellWeChat:onShare(element)
	WZLog("CellWeChat:onShare:",self.n_tag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = WZUIContainer:create()
    con:setUseAbsSize(true)
    con:setAbsContentSize(GlobalMethod:CCSize(1136,720))   --Õâ¸öÈÝÆ÷µÄ´óÐ¡ÒªºÍcellµÄ´óÐ¡Ò»ÖÂ
    con:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	con:setRelativePositionLuaTo(0.5,0.5)
	con:setShowAll(true)
	con:setTag(99999)
    WindowManager:getSceneRoot():addChild(con,WindowManager.m_nZOrderOffset+1)
    local date = GDatatab_sociality_share["id_"..self.n_tag]
    local shareConfigImg 
    if date.img ~= "screenshots" then
    	local imgBg = WZUIImage:create()
		imgBg:setFile(date.img)
	--	imgBg:setUseOriginSize(true)
		imgBg:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
		imgBg:setRelativePositionLuaTo(0.5,0.5)
	--	imgBg:setScale(1.5)
		con:addChild(imgBg)
		shareConfigImg = date.img
    end
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."shareImage.png"
	WZDeviceHelper:sharedDeviceHelper():saveScreen(path)
    if tonumber(date.QR_code) == 1 then
		local img = WZUIImage:create()
		local imgPath = "Download_share.png"
		local packName = WGameCmUtil:GetBundleIdentifier()
		local tab = GDatatab_share_binding or {}
	    for k ,v in pairs(tab) do
	        if v.app_name == packName then
	        	WZLog("imgPath:",v.img_QR_code)
	        	if tostring(v.img_QR_code ) ~= "1" then --英雄包的处理
	            	imgPath = v.img_QR_code
	            end
	            break
	        end
	    end
	    WZLog("imgPath:",imgPath)
	    if string.len(imgPath)>2 then
			img:setFile("ui/weChat/"..imgPath)
			img:setUseOriginSize(true)
			img:setAnchorPoint(GlobalMethod:ccp(1,0))
			img:setRelativePositionLuaTo(0.92,0.1)
			img:setScale(0.3)
			con:addChild(img)
		end
	end
	local mSharePath = CCFileUtils:sharedFileUtils():getTmpWritablePath().."shareImage2.png"
	WZDeviceHelper:sharedDeviceHelper():saveScreen(mSharePath)
	 local wndWeChat = WndWeChat:createElement()
    WindowManager:addWindow(wndWeChat, WndWeChat)
    WndWeChat:setInfo({tag = self.n_tag, imgPath = path, sharePath = mSharePath, configImg = shareConfigImg})
    if WindowManager:getSceneRoot():getChildByTag(99999) then
		WindowManager:getSceneRoot():removeChildByTag(99999, true)
	end
  	-- SNSSdkManager:shareWeChatImage(path)
  	-- self.n_time = 0
  	-- self.m_root:enableSchedule("updateWaitTime",0.2)
end

--@brief	更新匹配时间
function CellWeChat:updateWaitTime(element,dt)
	WZLog("CellWeChat:updateWaitTime")
	self.n_time = self.n_time + dt
	if self.n_time > 1 then
		self.m_root:disableSchedule()
		if WindowManager:getSceneRoot():getChildByTag(99999) then
			WindowManager:getSceneRoot():removeChildByTag(99999, true)
			if self.n_tag == 1 then
				ProtocolProcessorPrefetchCache:send_TASK_WeChatShare( )
			end
			WZLog("CellWeChat:updateWaitTimebbbbbbbbb")
		else
			WZLog("CellWeChat:updateWaitTimeggggggggggg")
		end
	end
end  

function CellWeChat:setTag(id)
	self.n_tag = id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
