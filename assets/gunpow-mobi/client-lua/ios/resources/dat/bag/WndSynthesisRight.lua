--WndSynthesisRight.lua
--@brief	WndSynthesisRight的UI模块
--@date		2015/07/17
--@author	zsq
--@note		合成系统右侧窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSynthesisRight:onEnter(element)
	self.m_root = element
    self:_moreLanguage()
	 --语言适配函数
	AdaptLanguage(self)
end

function WndSynthesisRight:onEnterTransitionDidFinish(element)
    --注册缓存中心数据监听
	CacheCenter:registerUpatePlayerItemObserver(self)
    
    ProtocolProcessorMerge:regAll()

    self:_updateWithIndex(self.m_nInitIndex)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSynthesisRight:onExit(element)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    ProtocolProcessorMerge:unregAll()
	self:_unInit()
end

function WndSynthesisRight:onSaleClick() 
	WndEquipNew:onSaleClick()
end

function WndSynthesisRight:onSynthesis() 
	WndEquipNew:onSynthesis()
end

function WndSynthesisRight:onCloseClick() 
	if self.m_root == nil then return end
	WndBagRole:onCloseClick()
end

--@brief	点击装备按钮后的回调
--@param	element:按钮绑定的UI节点引用
function WndSynthesisRight:onTab1(element)
    WZLog("WndSynthesisRight:onTab1")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_updateWithIndex(1)

    local tableConRight = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
	tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
end

--@brief	点击时装按钮后的回调
--@param	element:按钮绑定的UI节点引用
function WndSynthesisRight:onTab2(element)
    WZLog("WndSynthesisRight:onTab2")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_updateWithIndex(2)

    local tableConRight = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
	tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
end

--@brief	点击道具按钮后的回调
--@param	element:按钮绑定的UI节点引用
function WndSynthesisRight:onTab3(element)
    WZLog("WndSynthesisRight:onTab3")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_updateWithIndex(3)

    local tableConRight = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
	tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
end

--@brief	点击宝石按钮后的回调
function WndSynthesisRight:onTab4(element)
    WZLog("WndSynthesisRight:onTab4")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_updateWithIndex(4)

    local tableConRight = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
	tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
end

--@brief	点击皮肤按钮后的回调
function WndSynthesisRight:onTab5(element)
    WZLog("WndSynthesisRight:onTab5")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:_updateWithIndex(5)

    local tableConRight = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
	tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSynthesisRight:onClickListItem(tItem, nTag, tData)
    WZLog("WndSynthesisRight:onClickListItem")
    WndItemInfo:onCloseClick()
    if self.m_tPutItem and self.m_tPutItem:getFromTag() == nTag then
        --点击的材料已经放上去时显示卸下tip窗口
        self:_showDisboardItemTipWindow(tItem, nTag, tData)
    else
        self:_showMergeItemTipWindow(tItem, nTag, tData)
    end
end

--@brief    显示带合成按钮的物品tip窗口
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSynthesisRight:_showMergeItemTipWindow(tItem, nTag, tData)
    tData.tBtnList = {LocalStrings.SYNTHESIS}
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,nil,nil,nil,nil,nTag)
    WndItemInfo:setClickButtonCallback(self,self.btnMergeCallback)
	self.m_nTag = nTag
	self.m_tData = tData
end

--@brief	点击合成按钮回调
function WndSynthesisRight:btnMergeCallback()
	WZLog("WndSynthesisRight:btnMergeCallback",self.m_nTag)
	WndSynthesisLeft.m_nMergeNum = nil
    WndSynthesisLeft:_putItem(self.m_nTag,self.m_tData)
    --重置快速合成
	--WndSynthesisLeft.m_bQuick = false
    --local selQuick = GetElement(WndSynthesisLeft.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
    --selQuick:setCheckIndex(0)

    WndItemInfo:onCloseClick()
end

--@brief    显示带卸下按钮的物品tip窗口
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndSynthesisRight:_showDisboardItemTipWindow(tItem, nTag, tData)
    tData.tBtnList = {LocalStrings.UNROYAL}
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData)
    WndItemInfo:setClickButtonCallback(self,self.btnDisboardCallback)
end

--@brief	点击卸下按钮回调
function WndSynthesisRight:btnDisboardCallback()
	WZLog("WndSynthesisRight:btnDisboardCallback",self.m_nTag)
	WndSynthesisLeft.m_nMergeNum = nil
	GetElement(WndSynthesisLeft.m_root,"useNum_WndSynthesisLeft",WZUILabelTTF):setText(1)
    WndSynthesisLeft:_clearPutItem()
    --重置快速合成
	--WndSynthesisLeft.m_bQuick = false
    --local selQuick = GetElement(WndSynthesisLeft.m_root, "selCheckBox_WndSynthesis", WZUICheckBox)
    --selQuick:setCheckIndex(0)

    WndItemInfo:onCloseClick()
end

function WndSynthesisRight:onSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndSynthesisLeft.m_tPutItem ~= nil then return end
    local tListArray = {self.m_tEquipDataList, self.m_tDressDataList, self.m_tGemDataList, self.m_tItemDataList, self.m_tSkinDataList}
    local tDataList = tListArray[self.m_nSelectedIndex]
	for i=1,#tDataList do
		--选一个够合成数量的放到左边
		local itemId = tDataList[i].basicInfo.id
		local itemNum = tDataList[i].lastNum
		local tMerge = GDatatab_itemmerge["id_"..itemId]
		if itemNum >= tMerge.scrap[1][2] then
			self.m_nTag = i-1
			self.m_tData = tDataList[i]
            WndSynthesisLeft.m_nMergeNum = nil 
			WndSynthesisLeft:_putItem(i-1,tDataList[i])
			return
		end
	end

	MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT3)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    通过当前选中的序号更新界面
--@param    nIndex,当前序号，1：道具；2：时装；3：宝石；4：材料；5：皮肤
function WndSynthesisRight:_updateWithIndex(nIndex)
	WZLog("WndSynthesisRight:_updateWithIndex",nIndex)
    if self.m_root == nil then return end
    if self.m_nSelectedIndex == nIndex then return end
    WndSynthesisLeft:_clearPutItem()

    self.m_nSelectedIndex = nIndex
    self:updateRightList()
	self:_setTextColorByTag(nIndex)
	GetElement(self.m_root, "checkBox_WndRight", WZUICheckBoxGroup):setCheckIndex(self.m_nSelectedIndex-1)
end

--@brief   设置复选框文本颜色
function WndSynthesisRight:_setTextColorByTag(tag)
	WZLog("WndSynthesisRight:_setTextColorByTag",tag)
	for i=1,5 do
		self:_setTextColor(self.m_root:getChildElement("txtTab"..i.."_WndSynthesisRight"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
    	GetElement(self.m_root, "imgTab"..i.."_WndSynthesisRight", WZUI9Image):setVisible(false)
	end
	self:_setTextColor(self.m_root:getChildElement("txtTab"..tag.."_WndSynthesisRight"))
   	GetElement(self.m_root, "imgTab"..tag.."_WndSynthesisRight", WZUI9Image):setVisible(true)
end

--@brief   文本颜色和描边颜色
function WndSynthesisRight:_setTextColor(txt,color,strcolor)
	WZLog("WndRecover:_setTextColor")
	if self.m_root == nil or txt == nil then
		return
	end
	local color = color or GlobalMethod:ccc3(255,236,193)
	local strcolor = strcolor or GlobalMethod:ccc3(128,54,13)
	txt = WZUILabelTTF:luaTo(txt)
	txt:setColor(color)
	txt:setStrokeColor(strcolor)
end

--@brief    显示合成成功动画
function WndSynthesisRight:_showSuccessAnimation()
    if self.m_root == nil then
        return
    end
    --MsgBoxManager:showTipBox(LocalStrings.SYNTHESIS..LocalStrings.SUCCESS)
	self.m_root:enableSchedule("successAnimationFinished",0.7)
end

--@brief	合成成功动画完成后的回调
function WndSynthesisRight:successAnimationFinished(element,t)
	element:disableSchedule()
	GetElement(WndSynthesisLeft.m_root,"armature1_WndSynthesisLeft",WZArmature):setVisible(false)
	--PopupResult("ui/common/common_icon_hcz.png")
end

function WndSynthesisRight:_moreLanguage(  )
    GetElement(self.m_root,"ttfBagTitle_WndSynthesisRight",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO5)
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start----------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndSynthesisRight:_adaptLanguage_en()
	GetElement(self.m_root,"txtTab2_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtTab3_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"ttfBagTitle_WndSynthesisRight",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO5)
    GetElement(self.m_root,"txtTab4_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab5_WndSynthesisRight",WZUILabelTTF):setScale(0.55)

    local txtSys_WndEquipNew = GetElement(self.m_root,"txtSys_WndEquipNew",WZUILabelTTF)
    txtSys_WndEquipNew:setScale(0.8)
end

function WndSynthesisRight:_adaptLanguage_th(   )
    GetElement(self.m_root,"ttfBagTitle_WndSynthesisRight",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO5)
end

function WndSynthesisRight:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTab2_WndSynthesisRight",WZUILabelTTF):setFontSize(19)
    GetElement(self.m_root,"txtTab5_WndSynthesisRight",WZUILabelTTF):setFontSize(17)
end

function WndSynthesisRight:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtTab1_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab2_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab3_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab4_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab5_WndSynthesisRight",WZUILabelTTF):setFontSize(22)

    GetElement(self.m_root,"imgArrow1_WndSynthesisRight",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.23,0.945))
    GetElement(self.m_root,"imgArrow2_WndSynthesisRight",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.77,0.945))

    local txtSys_WndEquipNew = GetElement(self.m_root,"txtSys_WndEquipNew",WZUILabelTTF)
    txtSys_WndEquipNew:setScale(0.7)
    txtSys_WndEquipNew:setDimensions(GlobalMethod:CCSize(160))

end


function WndSynthesisRight:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtTab3_WndSynthesisRight",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtTab4_WndSynthesisRight",WZUILabelTTF):setFontSize(20) 
    GetElement(self.m_root,"txtTab1_WndSynthesisRight",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.7)
end

function WndSynthesisRight:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtTab3_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab1_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab4_WndSynthesisRight",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtTab5_WndSynthesisRight",WZUILabelTTF):setFontSize(16)

    local txtSys_WndEquipNew = GetElement(self.m_root,"txtSys_WndEquipNew",WZUILabelTTF)
    txtSys_WndEquipNew:setScale(0.7)
    txtSys_WndEquipNew:setDimensions(GlobalMethod:CCSize(160))
end
-------------------------------------语言适配模块End----------------------------------------
