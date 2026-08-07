--WndLibrary.lua
--@brief	WndLibrary的UI模块
--@date		2016/05/06
--@author	maopeiting
--@note		图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLibrary:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_Library)
end

function WndLibrary:onEnterTransitionDidFinish(element)
    self:actionCallback()
    AdaptLanguage(self)
end

--@brief  窗口动画完成回调
function WndLibrary:actionCallback()
    -- 初始化物品
   	self:initGoods()
   	self.m_nodeCurType = 1  
	self.m_nodeCurTypeByName = 1  
	self:showTypeList(1)
	self:showRightItemList()
	self:_updateQuaityTxt()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLibrary:onExit(element)
	self:_unInit()
end

--@brief window的点击事件
function WndLibrary:onTouchBegan(element,pt)
	WndItemInfo:onCloseClick()
	local conQualityList = GetElement(self.m_root,"conQualityList_WndLibrary",WZUIContainer)
	local ps = conQualityList:convertToNodeSpace(pt)
	local conQualityListSize = conQualityList:getAbsContentSize()
	if ps.x < 1 or ps.y < 1 or ps.x > conQualityListSize.width or ps.y > conQualityListSize.height+40  then
		conQualityList:setVisible(false)
		GetElement(self.m_root,"imgArrowRight_WndLibrary",WZUIImage):setFlipY(true)
	end
end

function WndLibrary:onClickSelQuality(element)
	-- body
	WZLog("WndLibrary:onClickSelQuality")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local conRightTop = GetElement(self.m_root,"conRightTop_WndLibrary",WZUIContainer)
	local conQualityList = GetElement(conRightTop,"conQualityList_WndLibrary",WZUIContainer)
	local isVisible = conQualityList:isVisible()
	if not isVisible then
		conQualityList:setVisible(true)
		GetElement(conRightTop,"imgArrowRight_WndLibrary",WZUIImage):setFlipY(false)
		for i=1,5 do
			local txtCurSelTag = GetElement(conQualityList,"txtCurSelTag" .. i .. "_WndLibrary",WZUILabelTTF)
			txtCurSelTag:setText("")
			if self.m_nQuality  == i then
				txtCurSelTag:setText(LocalStrings.CURRENT_TYPE)
			end
	    end
	else
		GetElement(conRightTop,"imgArrowRight_WndLibrary",WZUIImage):setFlipY(true)
		conQualityList:setVisible(false)
		
	end
end

function WndLibrary:showItemlist(tabDataList)
	WZLog("WndLibrary:showItemlist")
	local tabItemList = GetElement(self.m_root,"tabItemList_WndLibrary",WZUITableContainer)
	tabItemList:cleanTable()
	local conTable = GetElement(self.m_root,"conTable_WndLibrary",WZUIContainer)
	if tabDataList ~= nil and #tabDataList > 0 then
		removeShowPanelNullTip(conTable)
		for i,v in ipairs(tabDataList) do
			local cellElement,tCell = CellItem:createElement()
			tCell:setData(v)
			cellElement:setTag(i-1)

			tabItemList:setCellElement(cellElement)
	    end
	else
		ShowPanelNullTip(conTable)
	end
end

function WndLibrary:showRightItemList()
	WZLog("WndLibrary:showRightItemList")
	-- --判断是否是时装标签
	-- if id == 4 then
	-- 	tCell:setCellGoodItem(cellData,13)
	-- else
	-- 	tCell:setCellGoodItem(cellData,4)
	-- 	if cellData.gray ~= true then
	-- 		tCell:_addSidebarOwn()
	-- 	end
	-- end
	local tabDataList = nil
	tabDataList = self:_findItemListByType()
	self.m_tCurData = tabDataList
	
	self:showItemlist(tabDataList)
end

-- @brief   点击复选框时被回调的方法
-- @param   element:表绑定的UI节点引用
function WndLibrary:onCheckBox(element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	WZLog("-------tag------",tag)
	--self:updateConSel(tag)
end

function WndLibrary:onEditChange(element)
	WZLog("WndLibrary:onEditEnd")
	local txtSearchTip = GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF)
	local eb = GetElement(self.m_root,"eb_WndLibrary",WZUIEditBox)
	local txt = eb:getText()
	if txt == " " or string.len(txt) <= 0 then
		txtSearchTip:setVisible(true)
	end
end


function WndLibrary:onClickType(element)
	-- body
	WZLog("WndLibrary:onClickType")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local itemTypeList = GetElement(self.m_root,"itemTypeList_WndLibrary",WZUIFreeListContainer)
	local moveElement = itemTypeList:getMoveElement()
	local psx,psy = moveElement:getPosition()
	local ps = GlobalMethod:ccp(psx,psy)
	self.m_movePs = ps
	self.m_nodeCurType = element:getTag()
	self.m_nodeCurTypeByName = 1  
	self.m_nQuality = 1
	self:showTypeList(self.m_nodeCurType)
	self:showRightItemList()
	self:updateQualityInfo()
	self:_updateQuaityTxt()
end

function WndLibrary:onclickSend(element)
	-- body
	WZLog("WndLibrary:onclickSend")
	local txtSearchTip = GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF)
	txtSearchTip:setVisible(false)

	GetElement(self.m_root,"conBtn_WndLibrary",WZUIContainer):setVisible(true)
end

function WndLibrary:onclickResetEd(element)
	-- body
	WZLog("WndLibrary:onclickResetEd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	GetElement(self.m_root,"conBtn_WndLibrary",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"eb_WndLibrary",WZUIEditBox):setText("")
	GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF):setVisible(true)

	self:updateQualityInfo()
	self:showTypeList(self.m_nodeCurType)
	self:showItemlist(self.m_tCurData)
end

function WndLibrary:onClickTypeItem(element)
	-- body
	WZLog("WndLibrary:onClickTypeItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	element = WZUIButton:luaTo(element)
	element:setTouchEnable(false)
	if self.m_node then
		self.m_node:setTouchEnable(true)
	end
	self.m_nodeCurTypeByName = element:getTag()  
	self.m_node = element
	self.m_nQuality = 1
	local tData = self:_findItemListByType()
	self:showRightItemList()
	self:updateQualityInfo()
	self:_updateQuaityTxt()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出工作
function WndLibrary:onBtnClose( element )
	WZLog("Window has been removed!!!")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--根据品质筛选物品
function WndLibrary:onFindItemByQuality(element)
	WZLog("WndLibrary:onFindItemByQuality")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	self.m_nQuality = tag
	self:updateQualityInfo()
	self:_updateQuaityTxt()
	local quality = nil
	
	if tag == 1 then
		self:showItemlist(self.m_tCurData)
	else
		if tag == 2 then
			quality = 4
		elseif  tag == 3 then
			quality = 3
		elseif tag == 4 then
			quality = 2
		else
			quality = 1
		end
		local tTemp = self:_findItemByQuality(quality,self.m_tCurData)
		self:showItemlist(tTemp)
	end
end

--模糊查找
function WndLibrary:onClickSearch(element)
	-- body
	WZLog("WndLibrary:onClickSearch")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local eb = GetElement(self.m_root,"eb_WndLibrary",WZUIEditBox)
	local tempText = eb:getText()
	tempText = string.gsub(tempText," ","")

	if tempText == "" then
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY) 
	else
		self.m_nQuality = 1
		self:updateQualityInfo()
		self.m_nodeCurType = nil
		self:showTypeList(nil)
		local tempT = self:_findByName(tempText) --查找结果
		self:showItemlist(tempT)
		self.m_tCurData = tempT
		self:_updateQuaityTxt()
	end
end


function WndLibrary:updateQualityInfo()
	WZLog("WndLibrary:updateQualityInfo")
	local conQualityList = GetElement(self.m_root,"conQualityList_WndLibrary",WZUIContainer)
	for i=1,5 do
		local txtCurSelTag = GetElement(conQualityList,"txtCurSelTag" .. i .. "_WndLibrary",WZUILabelTTF)
		txtCurSelTag:setText("")
		if self.m_nQuality  == i then
			txtCurSelTag:setText(LocalStrings.CURRENT_TYPE)
		end
	end
end

--@brief 	将字符串转化为表
function WndLibrary:exchangeToTable(channel)
	-- body
	local sTarget = SplitStringWithSeparator(channel,"&")
	--local sTarget = string.gsub(channel, "&", ",")
	local nStart, nEnd = string.find(channel, ",")
	local tTempChannel = {}
	
	if #sTarget == 1 and nStart == nil  then
		local tItem = {}
		tItem[1] = 4
		tItem[2] = sTarget[1]
		table.insert(tTempChannel, tItem)
	else
		for i,v in ipairs(sTarget) do
			local tTempItem = SplitStringWithSeparator(v, ",")
			if #tTempItem == 2 then
				local tItem = {}
				tItem[1] = tonumber(tTempItem[1])
				tItem[2] = tonumber(tTempItem[2]) or tTempItem[2]
				table.insert(tTempChannel, tItem)
			elseif #tTempItem == 3 then
				local tItem = {}
				tItem[1] = tonumber(tTempItem[1])
				tItem[2] = tonumber(tTempItem[2]) or tTempItem[2]
				tItem[3] = tonumber(tTempItem[3]) or tTempItem[3]
				table.insert(tTempChannel, tItem)
			end
		end
	end

	return tTempChannel
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   	点击标签栏时该标签栏高亮
--@param	tag:表点击的复选框
function  WndLibrary:updateConSel(tag)
	
end

--@brief	显示tips
function WndLibrary:onTips(tCell,tag,tData)
	WZLog("WndLibrary:onTips")
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

function WndLibrary:_updateQuaityTxt()
	-- body
	WZLog("WndLibrary:_updateQuaityTxt ",self.m_nQuality)
	local tempT = {LocalStrings.CHAT_ALL,LocalStrings.ORANGE_COLOR,LocalStrings.PURPLE_COLOR,LocalStrings.BLUE_COLOR,LocalStrings.GREEN_COLOR}
	local conRightTop = GetElement(self.m_root,"conRightTop_WndLibrary",WZUIContainer)
	local txtQuality = GetElement(conRightTop,"txtQuality_WndLibrary",WZUILabelTTF)
	txtQuality:setText(tempT[self.m_nQuality])
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Began----------------------------------------
-- function WndLibrary:_adaptLanguage_en()
--  	GetElement(self.m_root,"ttf3_WndLibrary",WZUILabelTTF):setScale(0.8)
--  	GetElement(self.m_root,"ttf4_WndLibrary",WZUILabelTTF):setScale(0.8)
--  	GetElement(self.m_root,"ttf7_WndLibrary",WZUILabelTTF):setScale(0.8)
--  	GetElement(self.m_root,"ttf8_WndLibrary",WZUILabelTTF):setScale(0.8)

	-- local name = GetElement(self.m_root,"ttfName_WndLibrary",WZUILabelTTF)
	-- name:setScale(0.8)
	-- name:setDimensions(GlobalMethod:CCSize(300,0))
-- end

-- function WndLibrary:_adaptLanguage_vn(  )
-- 	GetElement(self.m_root,"ttf4_WndLibrary",WZUILabelTTF):setScale(0.8)
-- 	GetElement(self.m_root,"ttf8_WndLibrary",WZUILabelTTF):setScale(0.8)
-- 	local name = GetElement(self.m_root,"ttfName_WndLibrary",WZUILabelTTF)
-- 	name:setScale(0.8)
-- 	name:setDimensions(GlobalMethod:CCSize(300,0))
-- end

function WndLibrary:_adaptLanguage_pt(  )
	local txtSearchTip = GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF)
	txtSearchTip:setScale(0.7)
	txtSearchTip:setDimensions(GlobalMethod:CCSize(230,0))
	GetElement(self.m_root,"txtItemList_WndLibrary",WZUILabelTTF):setScale(0.7)
end

-- function WndLibrary:_adaptLanguage_tr(  )
-- 	GetElement(self.m_root,"ttf3_WndLibrary",WZUILabelTTF):setScale(0.8)
-- 	GetElement(self.m_root,"ttf7_WndLibrary",WZUILabelTTF):setScale(0.8)
-- 	GetElement(self.m_root,"ttfName_WndLibrary",WZUILabelTTF):setScale(0.75)
-- 	GetElement(self.m_root,"txtcheckBox1_WndLibrary",WZUILabelTTF):setScale(0.8)
-- 	GetElement(self.m_root,"txtSel1_WndLibrary",WZUILabelTTF):setScale(0.8)
	
-- 	local name = GetElement(self.m_root,"ttfName_WndLibrary",WZUILabelTTF)
-- 	name:setScale(0.8)
-- 	name:setDimensions(GlobalMethod:CCSize(300,0))
-- end
function WndLibrary:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF):setScale(0.8)
end

function WndLibrary:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtItemList_WndLibrary",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtCurSelTag1_WndLibrary",WZUILabelTTF):setScale(0.7)
end

function WndLibrary:_adaptLanguage_es(  )
	local txtSearchTip = GetElement(self.m_root,"txtSearchTip_WndLibrary",WZUILabelTTF)
	txtSearchTip:setScale(0.7)
	txtSearchTip:setDimensions(GlobalMethod:CCSize(230,0))
	GetElement(self.m_root,"txtItemList_WndLibrary",WZUILabelTTF):setScale(0.65)
end
-------------------------------------语言适配End----------------------------------------
