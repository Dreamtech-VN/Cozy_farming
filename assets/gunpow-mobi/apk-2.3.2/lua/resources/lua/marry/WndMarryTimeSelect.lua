--WndMarryTimeSelect.lua
--@brief	WndMarryTimeSelect的UI模块
--@date		2015/05/21
--@author	qixiang_xie
--@note		选择举办婚礼时间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryTimeSelect:onEnter(element)
	self.m_root = element
	self:update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryTimeSelect:onExit(element)
	self:_unInit()
end

--@brief    加载动画
function WndMarryTimeSelect:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
end

function WndMarryTimeSelect:onActionFinish()
    -- body
end

--@brief  关闭按钮响应函数
function WndMarryTimeSelect:onCloseClick(element)
	WZLog("WndMarryTimeSelect:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if element == nil then
		WZLog("WndMarryBetrothed:onCloseClick(element) element is nil ")
	end
	WindowManager:removeWindow(self.m_root, self, true)

end

--@brief  确定发送结婚信按钮响应函数
function WndMarryTimeSelect:onSureClick(element)
	WZLog("WndMarryTimeSelect:onSureClick ")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local coupleId = WndMarryManager:getMarryStatusTable().coupleId
    ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter(coupleId,2,self.m_nWeddingType,self.m_nTimeId )
    WndMarryManager.holdWeddingType = self.m_nWeddingType
    WindowManager:removeWindow(self.m_root, self, true)
   
    --WndMarryManager:removeAllWindow()
end

function WndMarryTimeSelect:update()
	--@brief	获得可举办婚礼时间（WEDDING_GetCanWedTime = 20）
	local marryTime = CacheCenter:getGameParam()
	local webTime = marryTime.wedTime
    WZLog("webTime = ",webTime)
    
    local times = SplitStringWithSeparator(webTime,"|")
    local time = nil
    local time1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWeddingTime1_WndMarryWedding"))
    local time2 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWeddingTime2_WndMarryWedding"))
    local time3 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWeddingTime3_WndMarryWedding"))

    for i,v in ipairs(times) do
    	if i == 1 then
    		time = SplitStringWithSeparator(v,"#")
            local timeStr = time[2]
            timeStr = SplitStringWithSeparator(timeStr,"-")
           
            local tFormat1 = string.sub(timeStr[1],1,5)
            local tFormat2 = string.sub(timeStr[2],1,5)
    		time1:setText(tFormat1 .. "-" .. tFormat2 )
    	elseif i ==2 then
    		time = SplitStringWithSeparator(v,"#")
            local timeStr = time[2]
            timeStr = SplitStringWithSeparator(timeStr,"-")
            
            local tFormat1 = string.sub(timeStr[1],1,5)
            local tFormat2 = string.sub(timeStr[2],1,5)
            time2:setText(tFormat1 .. "-" .. tFormat2 )
    	elseif i ==3 then
    		time = SplitStringWithSeparator(v,"#")
            local timeStr = time[2]
            timeStr = SplitStringWithSeparator(timeStr,"-")
            
            local tFormat1 = string.sub(timeStr[1],1,5)
            local tFormat2 = string.sub(timeStr[2],1,5)
            time3:setText(tFormat1 .. "-" .. tFormat2 )
    	end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  选择举办婚礼时间1
function WndMarryTimeSelect:checkTime1(element)
	WZLog("WndMarryTimeSelect:checkTime1")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nTimeId = 1
end

--@brief  选择举办婚礼时间2
function WndMarryTimeSelect:checkTime2(element)
	WZLog("WndMarryTimeSelect:checkTime2")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nTimeId = 2
end

--@brief  选择举办婚礼时间3
function WndMarryTimeSelect:checkTime3(element)
	WZLog("WndMarryTimeSelect:checkTime3")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nTimeId = 3
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndMarryTimeSelect:_adaptLanguage_pt(  )
    WZLog("WndMarryTimeSelect:_adaptLanguage_pt")
    GetElement(self.m_root,"txtWeddingExplain_WndMarryWedding",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtBtnSure_WndMarryTimeSelect",WZUILabelTTF):setFontSize(22)
end

function WndMarryTimeSelect:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtBtnSure_WndMarryTimeSelect",WZUILabelTTF):setFontSize(22)
end

function WndMarryTimeSelect:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtBtnSure_WndMarryTimeSelect",WZUILabelTTF):setScale(0.55)
    GetElement(self.m_root,"txtWeddingExplain_WndMarryWedding",WZUILabelTTF):setScale(0.75)
end
-------------------------------------语言适配End--------------------------------------------