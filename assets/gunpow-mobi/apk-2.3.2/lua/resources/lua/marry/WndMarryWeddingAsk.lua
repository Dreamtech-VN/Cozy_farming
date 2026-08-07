--WndMarryWeddingAsk.lua
--@brief	WndMarryWeddingAsk的UI模块
--@date		2014/01/17
--@author	叶威
--@note		请求举行婚礼的窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryWeddingAsk:onEnter(element)
	self.m_root = element
    self:_update()
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryWeddingAsk:onExit(element)
	self:_unInit()
end

--@brief	再考虑一下按钮响应函数
--@param	element:按钮的引用
function WndMarryWeddingAsk:onThinkingClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("self.m_nTimeId = ",self.m_nTimeId )
	if self.m_nTimeId  ~= nil then 
		ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus(false,self.m_nMarryRecordId,self.m_nTimeId )
	end 
    WndMarryManager:removeAllWindow()
end


--@brief	愿意按钮响应函数
--@param	element:按钮的引用
function WndMarryWeddingAsk:onAgreeClick(element)
	WZLog("WndMarryWeddingAsk:onAgreeClick(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("self.m_nCoupleId = ",self.m_nCoupleId)
	WZLog("WndMarryWeddingAsk self.m_nTimeId = ",self.m_nTimeId)
	if self.m_nTimeId ~= nil then 
		ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus(true, self.m_nMarryRecordId,self.m_nTimeId)
	end 
    WndMarryManager:removeAllWindow()
end

--@brief 确认举行婚礼按钮响应函数
function WndMarryWeddingAsk:onSureClick()
	WZLog(" WndMarryWeddingAsk:onSureClick()")
	if self.m_nWndType == WndMarryWeddingAsk.wndType.INVITE then
		if self.m_callBackLuaObj ~= nil and self.m_callBackLuaFun ~= nil then
		    self.m_callBackLuaFun(self.m_callBackLuaObj)
		end
	else
		local coupleId = WndMarryManager:getMarryStatusTable().coupleId
		local coupleName =  WndMarryManager:getMarryStatusTable().coupleName
		WZLog("coupleId = ",coupleId)
		WZLog("coupleName = ",coupleName)
		WZLog("self.m_nWeddingType = ",self.m_nWeddingType)
		WZLog("self.m_nTimeId = ",self.m_nTimeId)
		if self.m_nTimeId  ~= nil then 
			ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter(coupleId, coupleName,self.m_nWeddingType,self.m_nTimeId )
		end 
	end
    WndMarryManager:removeAllWindow()
end

--@brief 设置婚礼说明静态文本框函数
function WndMarryWeddingAsk:setWeddingShow(sTxt)
	if self.m_root == nil then 
		WZLog(" WndMarryWeddingAsk:setWeddingShow(sTxt) self.m_root is nil")
		return 
	end 
	
	 WZUILabelTTF:luaTo(GetElement(self.m_root,"txtWeddingShow_WndMarryWeddingAsk")):setText(sTxt)
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMarryWeddingAsk:_update()
    self:_updateContent()
end

--@brief 更新内容
function WndMarryWeddingAsk:_updateContent()
    -- local imgTitle = WZUIImage:luaTo(GetElement(self.m_root,"imgTitle_WndMarryWeddingAsk"))
    local txt = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTips_WndMarryWeddingAsk"))
    -- if self.m_sTitleImgPath ~= nil then
    --     imgTitle:setFile(self.m_sTitleImgPath)
    -- end
    if txt ~= nil then
        txt:setText(self.m_sText)
    end

	WZUIContainer:luaTo(GetElement(self.m_root,"conThinking_WndMarryWeddingAsk")):setVisible(true)
	WZUIContainer:luaTo(GetElement(self.m_root,"conAgree_WndMarryWeddingAsk")):setVisible(true)

end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------


function WndMarryWeddingAsk:_adaptLanguage_en()
    WZLog("WndMarryWeddingAsk:_adaptLanguage_en")
    local txtLeft = GetElement(self.m_root,"txtLeft_WndMarryWeddingAsk",WZUILabelTTF)
    txtLeft:setFontSize(20)

    local txtRight = GetElement(self.m_root,"txtRight_WndMarryWeddingAsk",WZUILabelTTF)
    txtRight:setFontSize(20)

    local imgLeft1 = GetElement(self.m_root,"imgLeft1_WndMarryWeddingAsk",WZUI9Image)
    local imgLeft2 = GetElement(self.m_root,"imgLeft2_WndMarryWeddingAsk",WZUI9Image)

    local imgRight1 = GetElement(self.m_root,"imgRight1_WndMarryWeddingAsk",WZUI9Image)
    local imgRight2 = GetElement(self.m_root,"imgRight2_WndMarryWeddingAsk",WZUI9Image)

    imgLeft1:setUseOriginSize(false)
    imgLeft2:setUseOriginSize(false)
    imgRight1:setUseOriginSize(false)
    imgRight2:setUseOriginSize(false)
end

function WndMarryWeddingAsk:_adaptLanguage_pt(  )
	local txtLeft = GetElement(self.m_root,"txtLeft_WndMarryWeddingAsk",WZUILabelTTF)
    txtLeft:setFontSize(16)

    local txtRight = GetElement(self.m_root,"txtRight_WndMarryWeddingAsk",WZUILabelTTF)
    txtRight:setFontSize(20)

    local imgLeft1 = GetElement(self.m_root,"imgLeft1_WndMarryWeddingAsk",WZUI9Image)
    local imgLeft2 = GetElement(self.m_root,"imgLeft2_WndMarryWeddingAsk",WZUI9Image)

    local imgRight1 = GetElement(self.m_root,"imgRight1_WndMarryWeddingAsk",WZUI9Image)
    local imgRight2 = GetElement(self.m_root,"imgRight2_WndMarryWeddingAsk",WZUI9Image)

    imgLeft1:setUseOriginSize(false)
    imgLeft2:setUseOriginSize(false)
    imgRight1:setUseOriginSize(false)
    imgRight2:setUseOriginSize(false)
end

function WndMarryWeddingAsk:_adaptLanguage_tr()
    local txtLeft = GetElement(self.m_root,"txtLeft_WndMarryWeddingAsk",WZUILabelTTF)
    txtLeft:setFontSize(18)
end

function WndMarryWeddingAsk:_adaptLanguage_es()
    local txtLeft = GetElement(self.m_root,"txtLeft_WndMarryWeddingAsk",WZUILabelTTF)
    txtLeft:setFontSize(20)
    txtLeft:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndMarryWeddingAsk:_adaptLanguage_ug()
    local txtLeft = GetElement(self.m_root,"txtLeft_WndMarryWeddingAsk",WZUILabelTTF)
    txtLeft:setFontSize(20)
    txtLeft:setDimensions(GlobalMethod:CCSize(100,0))
end
-------------------------------------语言适配模模块End----------------------------------------