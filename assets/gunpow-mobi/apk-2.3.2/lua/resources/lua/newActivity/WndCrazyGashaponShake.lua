--WndCrazyGashaponShake.lua
--@brief	WndCrazyGashaponShake的UI模块
--@date		2022/06/27
--@author	XTX
--@note		夏日西瓜摇摇乐


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCrazyGashaponShake:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self:_initStaticText()
	self:_setBallAni()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCrazyGashaponShake:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief    关闭窗口
function WndCrazyGashaponShake:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击开启按钮回调
function WndCrazyGashaponShake:onClickShake(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nArrowNum
	local nTimes = nTag
	if nTag == 10 then 
		nTimes = nTempTimes >= self.m_nMaxLimit and self.m_nMaxLimit or nTempTimes > 0 and nTempTimes or self.m_nMaxLimit 
	end
	local nCostNum = nTimes
	if nCostNum > nArrowNum then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
		return 
	end
    local tData = {}
	tData.times = nTimes

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 9, stringData)
end

--@brief    点击奖励回调
function WndCrazyGashaponShake:onClickItem(tCell, tData)
    WZLog("WndCrazyGashaponShake:onClickItem ")
    
    if self.m_tSelItem == nil then self.m_tSelItem = {} end 

    local bIsChoose = false 
    for i = 1, #self.m_tSelItem do
    	if self.m_tSelItem[i] == tData.id then
    		bIsChoose = true 
    		table.remove(self.m_tSelItem, i)
    		break 
    	end
    end

    local nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
    local nCanChooseNum = math.floor(nTotalShakeTimes/self.m_nTransBaseNum)
    if bIsChoose then 
    	tCell:setItemSelState(false)
    else
    	if #self.m_tSelItem >= nCanChooseNum then 
    		MsgBoxManager:showTipBox(LocalStrings.WATERMELON_TEXT1[24])
    		return 
    	end
    	table.insert(self.m_tSelItem, tData.id)
    	tCell:setItemSelState(true)
    end

    self:updateChooseNum()
end

--@brief    点击奖励回调
function WndCrazyGashaponShake:onClickItem2(tCell, nTag, tData)
    WZLog("WndCrazyGashaponShake:onClickItem2 ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false, nil, false)
end

--@brief 	点击领取按钮回调
function WndCrazyGashaponShake:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tSelItem == nil or #self.m_tSelItem == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.FOURYEAR_TEXT12)
		return 
	end

	local tData = {}
	tData.id = CopyTable(self.m_tSelItem)
	tData.num = {}
	for i = 1, #self.m_tSelItem do
		tData.num[i] = 1
	end

	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, strJson)
end




-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndCrazyGashaponShake:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashaponShake", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndCrazyGashaponShake:_setBowlingPlayAni", aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tAniAction[aniIndex], bLoop ~= nil and bLoop or true)
	end
end

--@brief 	设置待机特效
function WndCrazyGashaponShake:_setBallAni()
	local spinePath = "activity/hd_pic_shiguangji"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashaponShake", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_shiguangji"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7057, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCrazyGashaponShake)
        end
	end
end

function WndCrazyGashaponShake:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCrazyGashaponShake:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	显示开启动画
function WndCrazyGashaponShake:showOpenAction(tBigReward)
	self.m_tBigReward = tBigReward

	--创建选中特效
	local spinePath = "activity/hd_pic_shiguangji"
	local existSpine = CheckEffectFile(spinePath)
	if not existSpine then 
		local _sIndex = "hd_pic_shiguangji"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7057, downloadInfo.url, downloadInfo.md5, _sIndex, "DownloadResourceCallback", _G)
        end
	end

	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashaponShake", WZUISpine)
	if spineOpen then 
		if existSpine then 
			self:_setBowlingPlayAni(2, false)
			spineOpen:enableSchedule("showShootReward", 1.2)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励
function WndCrazyGashaponShake:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen_WndCrazyGashaponShake", WZUISpine)
	spineOpen:disableSchedule()
	self:_setBowlingPlayAni(1, true)

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	关闭抽奖奖励展示界面回调
function WndCrazyGashaponShake:_afterCloseReward()
	if self.m_root == nil then return end 

	local tBigReward = self.m_tBigReward
	if tBigReward then 
		WndHoraryBigReward:showInterface(18, tBigReward)
	end
end


--@brief 	刷新
function WndCrazyGashaponShake:_update()
	-- body
	self:_setFreeBtnText()
	self:createRewardList()
	self:updateChooseNum()
	self:_updateLightNum()
end

--@brief 	初始化静态文本
function WndCrazyGashaponShake:_initStaticText()
	GetElement(self.m_root, "txt1_WndCrazyGashaponShake", WZUILabelTTF):setText(LocalStrings.CRAZY_GASHAPON_TEXT1[8])

	self:_setSpineEffect()
end

--@brief 	设置免费丢
function WndCrazyGashaponShake:_setFreeBtnText()
	local btnDraw = GetElement(self.m_root, "btnDraw_WndCrazyGashaponShake", WZUIButton)
	local txtBtnDraw1 = GetElement(self.m_root, "txtBtnDraw1_WndCrazyGashaponShake", WZUILabelTTF)
	local txtBtnDraw2 = GetElement(self.m_root, "txtBtnDraw2_WndCrazyGashaponShake", WZUILabelTTF)
	local txtBtnDraw3 = GetElement(self.m_root, "txtBtnDraw3_WndCrazyGashaponShake", WZUILabelTTF)
	local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = nLightNum
	local nTimes = nTempTimes >= self.m_nMaxLimit and self.m_nMaxLimit or nTempTimes > 0 and nTempTimes or self.m_nMaxLimit 
	
	local bTouch = nTempTimes > 0
	btnDraw:setTouchEnable(bTouch)
	txtBtnDraw1:setText(string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[7], nTimes))
	txtBtnDraw2:setText(string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[7], nTimes))
	txtBtnDraw3:setText(string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[7], nTimes))
end

--@brief 	创建奖励列表
function WndCrazyGashaponShake:createRewardList()
	local tbReward = GetElement(self.m_root, "tbReward_WndCrazyGashaponShake", WZUITableContainer)
	tbReward:cleanTable()
	self.m_tSelItem = nil
	self.m_tCellPool = {}
	local tRewardData = self.m_tRewardPool

	for i = 1, #tRewardData do
		local element, tNewObj = CellGashaponShakeItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setChipShopItemData(tRewardData[i])
			element:setScale(0.95)

			tbReward:setCellElement(element)
			table.insert(self.m_tCellPool, tNewObj)
		end
	end
end

--@brief 	更新选择奖励数量显示
function WndCrazyGashaponShake:updateChooseNum()
	local txt2 = GetElement(self.m_root, "txt2_WndCrazyGashaponShake", WZUILabelTTF)

	local nSelNum = self.m_tSelItem == nil and 0 or #self.m_tSelItem
	local nTotalShakeTimes = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	local nCanChooseNum = math.floor(nTotalShakeTimes/self.m_nTransBaseNum)

	local strContent = string.format(LocalStrings.CRAZY_GASHAPON_TEXT1[9], nTotalShakeTimes, self.m_nTransBaseNum, nSelNum, nCanChooseNum)
	txt2:setText(strContent)

	local btnGet = GetElement(self.m_root, "btnGet_WndCrazyGashaponShake", WZUIButton)
	if nSelNum > 0 then 
		btnGet:setTouchEnable(true)
	else
		btnGet:setTouchEnable(false)
	end
end

--@brief 	更新西瓜块的数量
function WndCrazyGashaponShake:_updateLightNum()
	local txtOwnNum = GetElement(self.m_root, "txtOwnNum_WndCrazyGashaponShake", WZUILabelTTF)
	local imgCoinIcon = GetElement(self.m_root, "imgCoinIcon_WndCrazyGashaponShake", WZUIImage)
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	if txtOwnNum then 
		imgCoinIcon:setFile(basicData.icon)
		local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
		txtOwnNum:setText(nLightNum)
	end
end

--@brief 	设置待机特效
function WndCrazyGashaponShake:_setSpineEffect()
	local spinePath = "activity/ui_xigua_yyl"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineRect = GetElement(self.m_root, "spineRect_WndCrazyGashaponShake", WZUISpine)
		if spineRect then 
			spineRect:setFileJson(spinePath .. ".json")
			spineRect:setFileAtlas(spinePath .. ".atlas")
			spineRect:setAnimationName("wait1")
		end
	else
		local _sIndex = "ui_xigua_yyl"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7051, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndCrazyGashaponShake)
        end
	end
end

function WndCrazyGashaponShake:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndCrazyGashaponShake:downloadEffectCallback",taskId,extraData,failed)
    self:_setSpineEffect()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndCrazyGashaponShake:_adaptLanguage_vn( )
    GetElement(self.m_root, "txtBtnDraw1_WndCrazyGashaponShake", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "txtBtnDraw2_WndCrazyGashaponShake", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "txtBtnDraw3_WndCrazyGashaponShake", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "txt2_WndCrazyGashaponShake", WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配end----------------------------------------

