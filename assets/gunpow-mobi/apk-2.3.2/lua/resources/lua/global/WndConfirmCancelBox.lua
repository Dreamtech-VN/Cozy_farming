--WndConfirmCancelBox.lua
--@brief	WndConfirmCancelBox的UI模块
--@date		2013/12/19
--@author	xiaoyu_wu
--@note		确认取消框模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndConfirmCancelBox:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    --local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
	--txtConfirm:setText(LocalStrings.CONFIRM)
    --local txtCancel = GetElement(self.m_root, "txtCancel_WndConfirmCancelBox", WZUILabelTTF)
	--txtCancel:setText(LocalStrings.CANCEL)
	
	self:_update()
	--多语言描边字
	self:_moreLanguageForStroke()

    --非审核,形象改变
    if CacheCenter and CacheCenter:getGameParam() and CacheCenter:getGameParam().gameStatus == "1" then
        GetElement(self.m_root, "imgInstructor_WndConfirmCancelBox", WZUIImage):setFile("ui/combat/common_pic_meinv1.png")
    end
    AdaptLanguage(self)
end
--@brief	加载动画
function WndConfirmCancelBox:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true)
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndConfirmCancelBox:onExit(element)
	g_nConfirmCancelBoxId = nil 
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	end
	self:_unInit()
end

--@brief	点击关闭或者取消按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmCancelBox:onCancel(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_CANCEL)
	end
	WindowManager:removeWindow(self.m_root, self)
end

--@brief	点击确认按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmCancelBox:onConfirm(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
	end
	WindowManager:removeWindow(self.m_root, self)
end

--@brief 	点击复选框回调
function WndConfirmCancelBox:onCheckBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		超时后回调，并且移出窗口
function WndConfirmCancelBox:scheduleTimeout(element, delta)
	WZLog("WndConfirmCancelBox:scheduleTimeout")
	element:disableSchedule()
	if self.m_root == nil then
		return
	end
	
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_TIMEOUT)
	end
	WindowManager:removeWindow(self.m_root, self)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		根据消息数据生成确认框
function WndConfirmCancelBox:_update()
	if self.m_root == nil or self.m_tMsgData == nil then
		return
	end
	
	self:_updateContent()
	
	if self.m_tMsgData.tCustomUIConfig ~= nil then
        if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE] ~= nil then
            local txtContent = GetElement(self.m_root, "txtContent_WndConfirmCancelBox", WZUILabelTTF)
			txtContent:setFontSize(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE])
        end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] ~= nil then
			--local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
			--txtConfirm:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM])
		end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CANCEL] ~= nil then
			--local txtCancel = GetElement(self.m_root, "txtCancel_WndConfirmCancelBox", WZUILabelTTF)
			--txtCancel:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CANCEL])
		end

		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_OTHERDATA] ~= nil then 
			if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] ~= nil then
				local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
				txtConfirm:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM])
			end
			self:_showConsumeItems(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_OTHERDATA])
			GetElement(self.m_root, "txtContent_WndConfirmCancelBox", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5, 1))
		end
	end
	if self.m_tMsgData.checkMark then
		GetElement(self.m_root, "conForCheck_WndConfirmCancelBox", WZUIContainer):setVisible(true)
	end 
	
	if self.m_tMsgData.nTimeout and self.m_tMsgData.nTimeout > 0 then
		self.m_root:enableSchedule("scheduleTimeout", self.m_tMsgData.nTimeout)
	end
end

--@brief	更新消息内容
--@note		根据配置判断是普通文本还是使用富文本框
function WndConfirmCancelBox:_updateContent()
    local txtContent = GetElement(self.m_root, "txtContent_WndConfirmCancelBox", WZUILabelTTF)
    local freetxtContent = GetElement(self.m_root, "freetxtContent_WndConfirmCancelBox", WZUIFreeTextBox)
    
    if self.m_tMsgData.tCustomUIConfig ~= nil and self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_USEFREETXT] == true then
        freetxtContent:setVisible(true)
        freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
    else
        txtContent:setText(self.m_tMsgData.sMsgBody)
    end
end

--@brief 	多语言描边字
function WndConfirmCancelBox:_moreLanguageForStroke()
	if self.m_root == nil  then
		return
	end

	--确定按钮
	local txtConfirm = self.m_root:getChildElement("txtConfirm_WndConfirmCancelBox")
	if txtConfirm then
		txtConfirm = WZUILabelTTF:luaTo(txtConfirm)
		txtConfirm:setText(LocalStrings.CONFIRM)
		txtConfirm:setVisible(true)
	end
  --取消按钮
	local txtConfirm = self.m_root:getChildElement("txtConfirm_WndConfirmCancelBox")
	if txtConfirm then
		txtConfirm = WZUILabelTTF:luaTo(txtConfirm)
		txtConfirm:setText(LocalStrings.CANCEL)
		txtConfirm:setVisible(true)
	end
end

--@brief 	显示兑换消耗
function WndConfirmCancelBox:_showConsumeItems(consumeData)
	local tbCostItems = GetElement(self.m_root, "tbCostItems_WndConfirmCancelBox", WZUITableContainer)
	WZLog("WndConfirmCancelBox:_showConsumeItems", tostring(tbCostItems))
	if tbCostItems then 
		tbCostItems:setVisible(true)
		WZLog("WndConfirmCancelBox:_showConsumeItems 11", Serialize(consumeData))
		for i = 1, #consumeData do
            local element, tNewObj = CellGoodItem:createElement()
            local key = "id_" .. consumeData[i].id
            if element and tNewObj then
            	element:setTag(i - 1)
                local itemInfo = {id = consumeData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=consumeData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                if GDatatab_item[key].main_type == 5 then
                    tNewObj:setCellGoodItem(itemInfo,17)
                else
                    tNewObj:setCellGoodItem(itemInfo,17)
                end
                
                tNewObj:setItemClickFun(self,self.onOthersClick)
                element:setScale(0.8)
                tbCostItems:setCellElement(element)
            end
            --数量
            local nTempNum = consumeData[i].num 
            if nTempNum == -1 then
                nTempNum = 1 
            end
            
            local nLastNum = CacheCenter:getPlayerItemCountById(consumeData[i].id)
            if nLastNum == -1 then
                nLastNum = 1
            else
                if GDatatab_item[key].main_type == 5 then
                    if nLastNum > 0 then
                        nLastNum = 0 
                    end
                end
            end

            tNewObj:_setItemCountText(nLastNum, nTempNum)
        end
	end
end

--@brief    点击Item时回调tips
function WndConfirmCancelBox:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end
-------------------------------------私有方法模块End----------------------------------------

function WndConfirmCancelBox:_adaptLanguage_tr(  )
	local txtContent = GetElement(self.m_root, "txtContent_WndConfirmCancelBox", WZUILabelTTF)
	txtContent:setScale(0.8)
	txtContent:setDimensions(GlobalMethod:CCSize(360))
	txtContent:setRelativePosition(GlobalMethod:ccp(0.5,0.62))
end

-------------------------------------语言适配Begin-------------------------------------------
function WndConfirmCancelBox:_adaptLanguage_vn(  )
	local txtContent = GetElement(self.m_root,"txtContent_WndConfirmCancelBox",WZUILabelTTF)
	txtContent:setScale(0.8)
	txtContent:setDimensions(GlobalMethod:CCSize(360,0))
end

function WndConfirmCancelBox:_adaptLanguage_en(  )
	local txtContent = GetElement(self.m_root,"txtContent_WndConfirmCancelBox",WZUILabelTTF)
	txtContent:setScale(0.8)
	txtContent:setDimensions(GlobalMethod:CCSize(360,0))
end

function WndConfirmCancelBox:_adaptLanguage_pt(  )
	local txtContent = GetElement(self.m_root,"txtContent_WndConfirmCancelBox",WZUILabelTTF)
	txtContent:setScale(0.8)
	txtContent:setDimensions(GlobalMethod:CCSize(360,0))
end

function WndConfirmCancelBox:_adaptLanguage_es(  )
	local txtContent = GetElement(self.m_root,"txtContent_WndConfirmCancelBox",WZUILabelTTF)
	txtContent:setScale(0.8)
	txtContent:setDimensions(GlobalMethod:CCSize(360,0))
end

function WndConfirmCancelBox:_adaptLanguage_ug(  )
	local txtCancel = GetElement(self.m_root,"txtCancel_WndConfirmCancelBox",WZUILabelTTF)
	txtCancel:setScale(0.6)
	txtCancel:setDimensions(GlobalMethod:CCSize(18,0))
    local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmCancelBox", WZUILabelTTF)
    txtConfirm:setScale(0.6)
	txtConfirm:setDimensions(GlobalMethod:CCSize(18,0))
	
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNotAtt_WndConfirmCancelBox")):setDimensions(GlobalMethod:CCSize(240))
    GetElement(self.m_root, "txtContent_WndConfirmCancelBox", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.71))
end

-------------------------------------语言适配End--------------------------------------------