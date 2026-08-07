--WndGenericLog.lua
--@brief	WndGenericLog的UI模块
--@date		2015/05/25
--@author	qixiang_xie
--@note		通用的列表信息显示(例如恩爱日志显示)


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGenericLog:onEnter(element)
	self.m_root = element
	self:_update()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGenericLog:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief  加载日志信息
function WndGenericLog:loadGenericLog()
	WZLog("WndGenericLog:loadGenericLog")
	local ttf = WZUILabelTTF:create()
	ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
	ttf:setFontSize(22)
	ttf:setColor(ccc3(195,171,148))
	ttf:setUseOriginSize(true)

	self.m_freeListObject:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
    self.m_freeListObject:setBottomNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
    self.m_freeListObject:setEnableBottomElement(true)--设置BottomElement是否可用
    self.m_freeListObject:setHideBottomElement(false)--设置bottomElement是否隐藏
    self.m_freeListObject:setBottomElement(ttf)--设置容器的BottomElement对象
    
    self:createGenericLog()

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  显示列表信息
function WndGenericLog:_update()
	if self.m_tListInfo ~= nil and #self.m_tListInfo > 0 and self.m_root ~= nil then
		local tableCon = WZUITableContainer:luaTo(self.m_root:getChildElement("tabListInfo_WndGenericLog"))
		tableCon:cleanTable()
		self.m_freeListObject = tableCon
		self:loadGenericLog()
		--self.m_root:enableSchedule("createGenericLog")
	end
end


--@brief  向下拉加载更多数据
function WndGenericLog:onPageDown(element)
    WZLog("WndGenericLog:onPageDown")
    self.m_freeListObject:setHideBottomElement(true)
    self:createGenericLog()
end

--@brief  分帧加载婚礼日志信息
function WndGenericLog:createGenericLog()
	local count = #self.m_tListInfo
	for i=1,20 do
		if self.m_nCreateCount < count then
			local v = self.m_tListInfo[self.m_nCreateCount+1]
			local conFreeText = WZUISystem:getInstance():createElement("conFreeText_WndGenericLog")
			local freeText =  WZUIFreeTextBox:luaTo(GetElement(conFreeText,"freeText_WndGenericLog"))
			conFreeText:setTag(self.m_nCreateCount)
			freeText:setShowText(v)
			conFreeText:setVisible(true)
			self.m_freeListObject:setCellElement(conFreeText)
			self.m_nCreateCount  = self.m_nCreateCount + 1
		end
	end

	if self.m_nCreateCount >= count then --加载完数据后就不需要显示下拉加载更多的提示
		self.m_freeListObject:setHideBottomElement(true)
		self.m_freeListObject:setEnableBottomElement(false)--设置BottomElement是否可用
	else
		self.m_freeListObject:setHideBottomElement(false)
	end
end

--@brief 关闭按钮响应函数
function WndGenericLog:onCloseClick(element)
	WZLog("WndGenericLog:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root,WndGenericLog,true)
end

-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin--------------------------------------
function WndGenericLog:_adaptLanguage_en(  )
	GetElement(self.m_root,"conFreeText_WndGenericLog",WZUIContainer):setRelativeSize(GlobalMethod:CCSize(1,0.1))
end

function WndGenericLog:_adaptLanguage_pt(  )
	GetElement(self.m_root,"conFreeText_WndGenericLog",WZUIContainer):setRelativeSize(GlobalMethod:CCSize(1,0.1))
end
--------------------------------------语言适配End----------------------------------------