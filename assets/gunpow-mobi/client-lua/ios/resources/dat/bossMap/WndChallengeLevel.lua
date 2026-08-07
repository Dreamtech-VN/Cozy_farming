--WndChallengeLevel.lua
--@brief	WndChallengeLevel的UI模块
--@date		2014/01/15
--@author	林庆凯
--@note		挑战关卡窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChallengeLevel:onEnter(element)
	self.m_root = element
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_FuChoice)
	--初始化UI静态文本
	self:_initStaticUiText()
	self:_setCheckBoxIndexText()
	--注册副本相关协议
	--ProtocolProcessorBossMap:regAll()

	--多语言版本界面适配
	AdaptLanguage(self)
    
    Teach:isStartTeach("WndChallengeLevel:onEnter")
end
--@brief onEnter函数执行完成回调
function WndChallengeLevel:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndChallengeLevel:actionCallback(element, data)
    self.m_root:enableSchedule("scheduleLoadUI", 0)
end

--@brief    加载界面元素定时器
function WndChallengeLevel:scheduleLoadUI()
    self.m_root:disableSchedule()
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChallengeLevel:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndChallengeLevel:onExit")
end



--@brief	关闭按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	退出场景时被调用的函数
function WndChallengeLevel:onCloseActionCallback(elem,data)
    WZLog("WndChallengeLevel:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
    
end
--@brief	设置确认按钮的回调函数
--@param	fun:函数的变量,obj:表对象
function WndChallengeLevel:setSureBtnCallBackFun(fun,obj)
    self.m_sureBtnCallBackFun = fun
    self.m_tCallBackLuaObject = obj
end


--@brief	确定按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onSureBtn(element)
	WZLog("WndChallengeLevel:onSureBtn(element)")
	--音效
	WZLog("self.m_sureBtnCallBackFun = ",self.m_sureBtnCallBackFun)

	if self.m_sureBtnCallBackFun ~= nil and self.m_nRemainTime <= 0 then
        self:startPairTimer()
        self.m_sureBtnCallBackFun(self.m_tCallBackLuaObject,self.m_nRoomId,self.m_nSelModel)

	end

end


--@brief	简单模式复选框选中后被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onSelSimpleModelCheckBox(element)
	if self.m_nSelModel == 1 then 
		WZLog("WndChallengeLevel:onSelSimpleModelCheckBox(element) twice")
		return 
	end
    self.m_nRemainTime = 0
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:_setModelExplain(LocalStrings.SIMPLE_MODEL_EXPLAIN)
	self.m_nSelModel = 1
	
end 


--@brief	困难模式复选框选中后被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onSelDifficultyModelCheckBox(element)
	if self.m_nSelModel == 2 then 
		WZLog("WndChallengeLevel:onSelDifficultyModelCheckBox(element) Twice")
		return 
	end
    self.m_nRemainTime = 0
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:_setModelExplain(LocalStrings.DIFFICULTY_MODEL_EXPLAIN)
	self.m_nSelModel = 2
end 

--@brief	地狱模式复选框选中后被调用的函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:onSelHellModelCheckBox(element)
	if self.m_nSelModel == 3 then 
		WZLog("WndChallengeLevel:onSelHellModelCheckBox(element) Twice")
		return 
	end
    self.m_nRemainTime = 0
	--音效
    
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:_setModelExplain(LocalStrings.HELL_MODEL_EXPLAIN)
	self.m_nSelModel = 3
end 	


--@brief	提供给外部调用的接口函数
--@param	element:表绑定的UI节点引用
function WndChallengeLevel:supplyForOutSideImple()

end 

--@brief	开始建房计时器
function WndChallengeLevel:startPairTimer()
	WZLog("WndChallengeLevel:startPairTimer")
	self.m_nRemainTime = 1
	--WZUIButton:luaTo(GetElement(self.m_root,"btnSure_WndChallengeLevel")):enableSchedule("schedulePairTimer",0)
end

--@brief	关闭建房计时器
function WndChallengeLevel:endPairTimer()
	WZLog("WndChallengeLevel:endPairTimer")
	WZUIButton:luaTo(GetElement(self.m_root,"btnSure_WndChallengeLevel")):disableSchedule()
end

--@brief	建房计时器
--@param	element:表绑定的UI节点引用
--@param	delta:时间分量
function WndChallengeLevel:schedulePairTimer(element, delta)
    WZLog("WndChallengeLevel:schedulePairTimer", delta)
	if self.m_nRemainTime > 0 then
		self.m_nRemainTime = self.m_nRemainTime - delta
    else
        self:endPairTimer()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化UI静态文本
function WndChallengeLevel:_initStaticUiText(element)
	if self.m_root == nil then 
		WZLog("WndChallengeLevel:_initStaticUiText(element) self.m_root is nil ")
		return 
	end 

	--描边字
	local txtOk = self.m_root:getChildElement("txtOk_WndChallengeLevel")
	if txtOk ~= nil then 
		WZUILabelTTF:luaTo(txtOk):setText(LocalStrings.CONFIRM)
	end 
end 


--@brief 取得当前复选框组选中的是那个复选框的函数
--@param 返回当前选中复选框在复选框组的索引
function WndChallengeLevel:_checkBoxIndex()
	if self.m_root == nil then 
		WZLog("WndChallengeLevel:_checkBoxIndex() self.m_root is nil ")
		return 
	end 
	
	local checkBoxGroup = self.m_root:getChildElement("checkBoxGroup_WndChallengeLevel")
	if checkBoxGroup ~= nil then 
		checkBoxGroup = WZUICheckBoxGroup:luaTo(checkBoxGroup)
		if checkBoxGroup ~= nil then 
			return checkBoxGroup:getCheckIndex()
		end 
	end 
end 


--@brief 设置当前复选框选中后要显示的文字的函数
function WndChallengeLevel:_setCheckBoxIndexText()
	if self.m_root == nil then 
		WZLog("WndChallengeLevel:_setCheckBoxIndexText() self.m_root is nil ")
		return 
	end 
	
	local indexCheckBox = self:_checkBoxIndex()
	WZLog("indexCheckBox = ",indexCheckBox)
	if indexCheckBox == 0 then 			--简单模式
		self:_setModelExplain(LocalStrings.SIMPLE_MODEL_EXPLAIN)
	elseif indexCheckBox == 1 then 		--困难模式
		self:_setModelExplain(LocalStrings.DIFFICULTY_MODEL_EXPLAIN)
	elseif indexCheckBox == 2 then 		--地狱模式
		self:_setModelExplain(LocalStrings.HELL_MODEL_EXPLAIN)
	end 
end 


--@brief 设置模式说明文字的函数
--@param  sTxt 说明文字
function WndChallengeLevel:_setModelExplain(sTxt)
	if self.m_root == nil then 
		WZLog("WndChallengeLevel:_setModelExplain(sTxt) self.m_root is nil ")
		return 
	end 

	local txtModelExplain = self.m_root:getChildElement("txtModelExplain_WndChallengeLevel")
	if txtModelExplain ~= nil then 
		txtModelExplain = WZUILabelTTF:luaTo(txtModelExplain)
		if txtModelExplain ~= nil then 
			txtModelExplain:setText(sTxt)
		end 
	end 
end 


--@brief	设置奖励物品图标的函数
function WndChallengeLevel:_setRewardPath(rewardList)
	if self.m_root == nil then 
		WZLog("WndChallengeLevel:_setRewardPath() self.m_root is nil ")
		return 
	end
    self.m_rewardId = rewardList
	if self.m_rewardId == nil then
       return
    end
	self.m_nIdCount  = #self.m_rewardId
    
    local con = WZUITableContainer:luaTo(self.m_root:getChildElement("tabconReward_WndChallengeLevel"))
    con:cleanTable()

	for i = 1, self.m_nIdCount do
        local tData = {}
        local rewardId = "id_" .. self.m_rewardId[i]
        local id = self.m_rewardId[i]
        tData = ShopItems[rewardId]
        local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setTag(i-1)
            con:setCellElement(celElement)
			tCell:setCellGoodItem(tData,5)
            tCell:setItemClickFun(self,self.onOthersClick)
		end
        
	end
    
	
end
--@brief	开始按下回调函数
function WndChallengeLevel:onCloseTips(element,pt)
    WZLog("WndMultipleMap:onCloseTips")
    WndItemInfo:onCloseClick()
end
--@brief	其它Item点击回调
function WndChallengeLevel:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local con = WZUIContainer:luaTo(self.m_root:getChildElement("ContainerAward"))
    WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(luaTable.m_root,con,1,tData,false)

end
--@brief	设置顶部房间标题的函数
function WndChallengeLevel:_setTopTitle()
	if self.m_root == nil then 
		
	end 
	
	local imgRoomName = self.m_root:getChildElement("imgRoomName_WndChallengeLevel")
	if imgRoomName ~= nil then 
		imgRoomName = WZUIImage:luaTo(imgRoomName)
		if imgRoomName ~= nil then 
			imgRoomName:setFile(self.m_sImgRoomName)
		end 		
	end 

 
end 

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------
--@brief	英文适配函数
--@note		英文适配函数
function WndChallengeLevel:_adaptLanguage_en()
	local txtModelExplain = self.m_root:getChildElement("txtModelExplain_WndChallengeLevel") 
	if txtModelExplain ~= nil then 
		WZUILabelTTF:luaTo(txtModelExplain):setFontSize(27)
	end
end 

--@brief	葡语适配函数
--@note		葡语适配函数
function WndChallengeLevel:_adaptLanguage_pt()
	local txtModelExplain = self.m_root:getChildElement("txtOk_WndChallengeLevel") 
	if txtModelExplain ~= nil then 
		WZUILabelTTF:luaTo(txtModelExplain):setFontSize(24)
	end

		local txtModelExplain = self.m_root:getChildElement("txtModelExplain_WndChallengeLevel") 
	if txtModelExplain ~= nil then 
		WZUILabelTTF:luaTo(txtModelExplain):setFontSize(27)
	end
end 

--@brief  越南语适配函数
--@return 无
--@note   备注
function WndChallengeLevel:_adaptLanguage_vn()
	--简单模式解释说明
	local txtModelExplain = self.m_root:getChildElement("txtModelExplain_WndChallengeLevel") 
	if txtModelExplain ~= nil then 
		WZUILabelTTF:luaTo(txtModelExplain):setFontSize(27)
	end
end
-------------------------------------语言适配器模块End----------------------------------------
