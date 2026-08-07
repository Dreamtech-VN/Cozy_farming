--WndStrong.lua
--@brief	WndStrong的UI模块
--@date		2014/09/10
--@author	zyx
--@note		我i要变强功能模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndStrong:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_BecomeStronger)
	--静态文本显示
	self:_setText()
	self:_checkBoxColor(1)
	self:getStrongList()
	AdaptLanguage(self)
end

--@brief onEnter函数执行完成回调
function WndStrong:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndStrong:actionCallback(element, data)
	self.m_root:enableSchedule("scheduleLoadUI", 0)
	AdaptLanguage(self)
end

--@brief    加载界面元素定时器
function WndStrong:scheduleLoadUI()
	self.m_root:disableSchedule()
	self:_updateWindow()--初始化UI界面
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndStrong:onExit(element)
	self:_unInit()
end

--@brief	外部接口调用
function WndStrong:showInterface(nIndex)
	if self.m_root == nil then
		local strong = WndStrong:createElement()
		if nIndex == nil then 
			nIndex = 1 
		end
		self.m_nCurIndex = nIndex 			--复选框节点
		WindowManager:addWindow(strong, WndStrong, false)
	end
end

--@brief	关闭按钮被按下时调用的函数
--@param	element:关闭按钮的UI节点引用
--@note		在这里做关闭按钮被按下时的响应操作
function WndStrong:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then 
		WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	关闭整个窗口的动画效果
function WndStrong:onCloseActionCallback(elem,data)
	if self.m_nMainUIId == 75 then
		JumpByUIId(self.m_nMainUIId, 0)
	end
    WindowManager:removeWindow(self.m_root , WndStrong , true)
end

--@brief	我要变强复选框被选中时调用的函数
--@param	element:我要变强复选框的UI节点引用
--@note		在这里做我要变强复选框被选中时的响应操作
function WndStrong:onStrongSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--更新界面
	self.m_nCurIndex = 1
	self:_checkBoxColor(self.m_nCurIndex)
	self:_updateWindow()
end

--@brief	我要变强复选框被选中时调用的函数
--@param	element:我要变强复选框的UI节点引用
--@note		在这里做我要变强复选框被选中时的响应操作
function WndStrong:onUpgradeSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--更新界面
	self.m_nCurIndex = 2
	self:_checkBoxColor(self.m_nCurIndex)
	self:_updateWindow()
end

--@brief	我要变强复选框被选中时调用的函数
--@param	element:我要变强复选框的UI节点引用
--@note		在这里做我要变强复选框被选中时的响应操作
function WndStrong:onMoneySelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--更新界面
	self.m_nCurIndex = 3
	self:_checkBoxColor(self.m_nCurIndex)
	self:_updateWindow()
end

function WndStrong:OnSelectEvent( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--更新界面
	self.m_nCurIndex = element:getTag()
	self:_checkBoxColor(self.m_nCurIndex)
	self:_updateWindow()
end

--@brief	点击前往按钮回调响应
function WndStrong:onGotoClick(element)
	local tag = element:getTag() + 1
	local MainUIId = 0 
	if self.m_nCurIndex == 1 then 
		MainUIId = self.m_tBeStrong[tag].link
	elseif self.m_nCurIndex == 2 then 
		MainUIId = self.m_tToGetGold[tag].link
	elseif self.m_nCurIndex == 3 then 
		MainUIId = self.m_tToGetEquie[tag].link
	elseif self.m_nCurIndex == 4 then 
		MainUIId = self.m_tBeUpgrade[tag].link
	elseif self.m_nCurIndex == 5 then 
		MainUIId = self.m_tToGetDiamond[tag].link
	elseif self.m_nCurIndex == 6 then 
		MainUIId = self.m_tPetBeStrong[tag].link
	elseif self.m_nCurIndex == 7 then 
		MainUIId = self.m_tToEat[tag].link
	end
	self.m_nMainUIId = MainUIId 
	WZLog("*********** WndStrong:onGotoClick ********", self.m_nCurIndex, self.m_nMainUIId, tag)
	WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
	--Modify By Tianxiang_Xu
	if MainUIId ~= 72 and MainUIId ~= 73 then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
	--End Modify
	if self.m_nMainUIId ~= 75 then
		JumpByUIId(self.m_nMainUIId, 0)
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  更新界面，跳转到不同的界面
function WndStrong:_updateWindow()
	if self.m_nCurIndex == 1 then
		self:_createStrongTable(self.m_tBeStrong)
	elseif self.m_nCurIndex == 2 then 
		self:_createStrongTable(self.m_tToGetGold)
	elseif self.m_nCurIndex == 3 then
		self:_createStrongTable(self.m_tToGetEquie)
	elseif self.m_nCurIndex == 4 then 
		self:_createStrongTable(self.m_tBeUpgrade)
	elseif self.m_nCurIndex == 5 then 
		self:_createStrongTable(self.m_tToGetDiamond)
	elseif self.m_nCurIndex == 6 then 
		self:_createStrongTable(self.m_tPetBeStrong)
	elseif self.m_nCurIndex == 7 then 
		self:_createStrongTable(self.m_tToEat)
	end
end

--@brief  创建我要变强界面
function WndStrong:_createStrongTable(temp)
	if self.m_root == nil then 
		return
	end

	local tableStrong = self.m_root:getChildElement("tableStrong_WndStrong")
	if tableStrong == nil then 
		WZLog("tableStrong == nil")
		return 
	end
	tableStrong = WZUITableContainer:luaTo(tableStrong)
	tableStrong:cleanTable()
	--创建列表
	local idx = 0
	for i,data in ipairs(temp) do
		if data.level <= CacheCenter.m_tPlayerInfo.level then 
			local element, tNewObj = CellStrongItem:createElement()
			if element == nil or tNewObj == nil then 
				return 
			end
			element = WZUIContainer:luaTo(element)
			element:setTag(idx)
			tNewObj:setData(data.content, data.explain, data.star, data.iocn, i - 1)
			tableStrong:setCellElement(element)
		
			idx = idx + 1

			if ProjConfig.LANGUAGE == "es" then
				GetElement(CellStrongItem,"conStar_WndStrong",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.505189,0.676949))
			end
		end 
	end
	tableStrong:getMoveElement():setPositionY(tableStrong:getMinPosition().y)
end

--@brief	是否可以前往(可以进入功能模块)
--@param    nId, 按钮id
--@return   #1, 是否开放
function WndStrong:_ifGoForId(nId)
    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    for i,v in ipairs(GlobalGame.g_tButtonInfo.buttonId) do
        if v == nId then
            if GlobalGame.g_tPlayerInfo.nLevel and GlobalGame.g_tButtonInfo.buttonStatus3Level[i] and
                GlobalGame.g_tPlayerInfo.nLevel < GlobalGame.g_tButtonInfo.buttonStatus3Level[i] then
				MsgBoxManager:showTipBox(string.format(LocalStrings.ACTIVE_NOLEVEL,GlobalGame.g_tButtonInfo.buttonStatus3Level[i]))
                return false
            else
                return true
            end
        end
    end 
end

--@brief	设置Item内容与图片
--@param	sTaskName:功能名称
function WndStrong:_setIconAndTaskName(tCell, sTaskName, sTaskRemark, nStarNum, tIcon, nTag)
	local btnGoto = GetElement(tCell, "btnGoto_WndStrong", WZUIButton)  --设置跳转按钮
	btnGoto:setTag(nTag)
	--功能名称
   	local txtTaskName = tCell:getChildElement("txtTaskName_WndStrong")
	txtTaskName = WZUILabelTTF:luaTo(txtTaskName)
	txtTaskName:setText(sTaskName)
	if tIcon ~= nil then 
    	local imgIcon = tCell:getChildElement("imgTaskIcon_WndStrong")
		imgIcon = WZUI9Image:luaTo(imgIcon)
		imgIcon:setFile("ui/"..tIcon)  
	end 

	--功能描述
	local txtRemark = tCell:getChildElement("txtRemark_WndStrong")
	txtRemark = WZUILabelTTF:luaTo(txtRemark)
	txtRemark:setText(sTaskRemark)
		if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
			if txtRemark then
				txtRemark:setDimensions(GlobalMethod:CCSize(450,0))
			end
		elseif ProjConfig.LANGUAGE == "en" then
			txtRemark:setScale(0.8)
			txtRemark:setDimensions(GlobalMethod:CCSize(450,0))
		elseif ProjConfig.LANGUAGE == "pt" then
			txtRemark:setDimensions(GlobalMethod:CCSize(450))
		elseif ProjConfig.LANGUAGE == "tr" then
			txtRemark:setScale(0.75)
		elseif ProjConfig.LANGUAGE == "es" then
			txtTaskName:setFontSize(16)
			txtRemark:setScale(0.8)
			txtRemark:setDimensions(GlobalMethod:CCSize(450,0))
		end
		if ProjConfig.LANGUAGE == "es" then
			txtRemark:setDimensions(GlobalMethod:CCSize(450))
		end
		if ProjConfig.LANGUAGE == "es" then
			txtTaskName:setScale(0.8)
			txtRemark:setDimensions(GlobalMethod:CCSize(450,0))
		end

	--按钮文字
	for i=1,3,1 do 
		local txtGoFor = tCell:getChildElement(string.format("txtGoFor%i_WndStrong",i))
		if txtGoFor ~= nil then 
			WZUILabelTTF:luaTo(txtGoFor):setText(LocalStrings.ACTIVE_BTN_GO)
		end
	end

	for i=1,nStarNum do
		local conStar_WndStrong = GetElement(tCell,"conStar_"..i.."_WndStrong")
		conStar_WndStrong:setVisible(true)
	end
end

function WndStrong:_checkBoxColor(tag)
	for i=1,7 do 
		local sName = "txtStrong%d_WndStrong"
		sName = string.format(sName,i)
		local tCell = WZUILabelTTF:luaTo(self.m_root:getChildElement(sName))
		if tag == i then
			tCell:setColor(GlobalMethod:ccc3(79,60,48))
			tCell:setEnableStroke(false)
		else
			tCell:setColor(GlobalMethod:ccc3(255,236,193))
			tCell:setEnableStroke(true)
			tCell:setStrokeSize(2.0)
			tCell:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		end
	end
end

--@brief	静态文本显示
function WndStrong:_setText()
	self:setTextPro(self.m_root:getChildElement("txtWndTitleName_WndStrong"),LocalStrings.BESTRONG_NAME)
	self:setTextPro(self.m_root:getChildElement("txtStrong1_WndStrong"),LocalStrings.BeStrongBtnNameArrays[1])--我要变强
	self:setTextPro(self.m_root:getChildElement("txtStrong2_WndStrong"),LocalStrings.BeStrongBtnNameArrays[2])--我要金币
	self:setTextPro(self.m_root:getChildElement("txtStrong3_WndStrong"),LocalStrings.BeStrongBtnNameArrays[3])--我要装备
	self:setTextPro(self.m_root:getChildElement("txtStrong4_WndStrong"),LocalStrings.BeStrongBtnNameArrays[4])--我要升级
	self:setTextPro(self.m_root:getChildElement("txtStrong5_WndStrong"),LocalStrings.BeStrongBtnNameArrays[5])--我要宝石
	self:setTextPro(self.m_root:getChildElement("txtStrong6_WndStrong"),LocalStrings.BeStrongBtnNameArrays[6])--宠物变强
	self:setTextPro(self.m_root:getChildElement("txtStrong7_WndStrong"),LocalStrings.BeStrongBtnNameArrays[7])--我要吃肉
end

function WndStrong:setTextPro(tCell,desc)
	if tCell == nil then 
		return
	end
	desc = desc or ""
	tCell = WZUILabelTTF:luaTo(tCell)
	tCell:setText(desc)
end

function WndStrong:_IsOpenTabButton(  )

	if #self.m_tBeStrong >0 then 
	else
		self:_CloseTabButton("btnCheckBox_1_WndStrong","txtStrong1_WndStrong")
	end 

	if #self.m_tToGetGold >0 then  
	else
		self:_CloseTabButton("btnCheckBox_2_WndStrong","txtStrong2_WndStrong")
	end

	if #self.m_tToGetEquie >0 then 
	else
		self:_CloseTabButton("btnCheckBox_3_WndStrong","txtStrong3_WndStrong")
	end
end
function WndStrong:_adaptLanguage_es()
	for i = 1,7 do
		local sName = string.format("txtStrong%d_WndStrong",i)
		local txtStrong = self.m_root:getChildElement(sName)
		if txtStrong then
			txtStrong = WZUILabelTTF:luaTo(txtStrong)
			txtStrong:setScale(0.65)
			txtStrong:setDimensions(GlobalMethod:CCSize(140))
		end
	end
end

--@brief	泰文包适配函数
function WndStrong:_adaptLanguage_th()

	if #self.m_tBeUpgrade >0 then 
	else
		self:_CloseTabButton("btnCheckBox_4_WndStrong","txtStrong4_WndStrong")
	end

	if #self.m_tToGetDiamond >0 then 
	else
		self:_CloseTabButton("btnCheckBox_5_WndStrong","txtStrong5_WndStrong")
	end

	if #self.m_tPetBeStrong >0 then 
	else
		self:_CloseTabButton("btnCheckBox_6_WndStrong","txtStrong6_WndStrong")
	end

	if #self.m_tToEat >0 then 
	else
		self:_CloseTabButton("btnCheckBox_7_WndStrong","txtStrong7_WndStrong")
	end

end


function WndStrong:_CloseTabButton( btnTxt,descTxt )
	local btnCheckBox_WndStrong = GetElement(self.m_root,btnTxt,WZUICheckBox)
	btnCheckBox_WndStrong:setVisible(false)
	local txtCheckBox_WndStrong = GetElement(self.m_root,descTxt ,WZUILabelTTF)
	txtCheckBox_WndStrong:setVisible(false)
end

-------------------------------------私有方法模块End----------------------------------------

function WndStrong:_IsOpenTabButton(  )

	if #self.m_tBeStrong >0 then 
	else
		self:_CloseTabButton("btnCheckBox_1_WndStrong","txtStrong1_WndStrong")
	end 

	if #self.m_tToGetGold >0 then  
	else
		self:_CloseTabButton("btnCheckBox_2_WndStrong","txtStrong2_WndStrong")
	end

	if #self.m_tToGetEquie >0 then 
	else
		self:_CloseTabButton("btnCheckBox_3_WndStrong","txtStrong3_WndStrong")
	end

	if #self.m_tBeUpgrade >0 then 
	else
		self:_CloseTabButton("btnCheckBox_4_WndStrong","txtStrong4_WndStrong")
	end

	if #self.m_tToGetDiamond >0 then 
	else
		self:_CloseTabButton("btnCheckBox_5_WndStrong","txtStrong5_WndStrong")
	end

	if #self.m_tPetBeStrong >0 then 
	else
		self:_CloseTabButton("btnCheckBox_6_WndStrong","txtStrong6_WndStrong")
	end

	if #self.m_tToEat >0 then 
	else
		self:_CloseTabButton("btnCheckBox_7_WndStrong","txtStrong7_WndStrong")
	end

end


function WndStrong:_CloseTabButton( btnTxt,descTxt )
	local btnCheckBox_WndStrong = GetElement(self.m_root,btnTxt,WZUICheckBox)
	btnCheckBox_WndStrong:setVisible(false)
	local txtCheckBox_WndStrong = GetElement(self.m_root,descTxt ,WZUILabelTTF)
	txtCheckBox_WndStrong:setVisible(false)
end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin-------------------------------------------
--@brief	英文包适配函数
function WndStrong:_adaptLanguage_en()
	for i = 1,3 do
		local sName = string.format("txtStrong%d_WndStrong",i)
		local txtStrong = self.m_root:getChildElement(sName)
		if txtStrong then
			txtStrong = WZUILabelTTF:luaTo(txtStrong)
			txtStrong:setFontSize(20)
		end
	end
end

--@brief	泰文包适配函数
function WndStrong:_adaptLanguage_th()
	
end

--@brief	越南语包适配函数
function WndStrong:_adaptLanguage_vn()
	for i = 1,3 do
		local sName = string.format("txtStrong%d_WndStrong",i)
		local txtStrong = self.m_root:getChildElement(sName)
		if txtStrong then
			txtStrong = WZUILabelTTF:luaTo(txtStrong)
			txtStrong:setFontSize(22)
			txtStrong:setDimensions(GlobalMethod:CCSize(100,60))
		end
	end
end

--@brief	葡语包适配函数
function WndStrong:_adaptLanguage_pt()
	--标题栏
	local txtStrong1 = GetElement(self.m_root, "txtStrong1_WndStrong", WZUILabelTTF)
    txtStrong1:setFontSize(23)
	txtStrong1:setDimensions(GlobalMethod:CCSize(150,60))
	local txtStrong2 = GetElement(self.m_root, "txtStrong2_WndStrong", WZUILabelTTF)
    txtStrong2:setFontSize(23)
	local txtStrong3 = GetElement(self.m_root, "txtStrong3_WndStrong", WZUILabelTTF)
    txtStrong3:setFontSize(23)
	txtStrong3:setDimensions(GlobalMethod:CCSize(150,60))	
end

function WndStrong:_adaptLanguage_tr(  )
	local txtStrong1 = GetElement(self.m_root, "txtStrong1_WndStrong", WZUILabelTTF)
    txtStrong1:setFontSize(20)
	txtStrong1:setDimensions(GlobalMethod:CCSize(100,60))
end

function WndStrong:_adaptLanguage_es()
	local txtStrong1 = GetElement(self.m_root, "txtStrong1_WndStrong", WZUILabelTTF)
    txtStrong1:setScale(0.65)
	txtStrong1:setDimensions(GlobalMethod:CCSize(140))
	local txtStrong2 = GetElement(self.m_root, "txtStrong2_WndStrong", WZUILabelTTF)
    txtStrong2:setScale(0.65)
	txtStrong2:setDimensions(GlobalMethod:CCSize(140))
	local txtStrong3 = GetElement(self.m_root, "txtStrong3_WndStrong", WZUILabelTTF)
    txtStrong3:setScale(0.65)
	txtStrong3:setDimensions(GlobalMethod:CCSize(140))
	local txtStrong4 = GetElement(self.m_root, "txtStrong4_WndStrong", WZUILabelTTF)
    txtStrong4:setScale(0.65)
	txtStrong4:setDimensions(GlobalMethod:CCSize(140))
	local txtStrong5 = GetElement(self.m_root, "txtStrong5_WndStrong", WZUILabelTTF)
    txtStrong5:setScale(0.65)
	txtStrong5:setDimensions(GlobalMethod:CCSize(140))
	local txtStrong6 = GetElement(self.m_root, "txtStrong6_WndStrong", WZUILabelTTF)
    txtStrong6:setScale(0.65)
	txtStrong6:setDimensions(GlobalMethod:CCSize(140))
end
------------------------------------语言适配End---------------------------------------------
