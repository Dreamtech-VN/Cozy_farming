--WndWeChat.lua
--@brief	WndWeChat的UI模块
--@date		2017/06/06
--@author	zhangming
--@note		微信分享界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWeChat:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWeChat:onExit(element)
	self:_unInit()
end

--@brief	设置界面信息
--@param	info:表绑定的UI节点引用
--@note		设置界面信息
function WndWeChat:setInfo(info)
	WZLog("WndWeChat:setInfo:",info.imgPath)
	local imgBg = GetElement(self.m_root,"imgBg_WndWeChat",WZUIImage)
	if info.configImg then 
		imgBg:setUseOriginSize(true)
		imgBg:setFile(info.configImg)
		imgBg:setScale(0.9)
	else
		imgBg:setFile(info.imgPath)
	end
	self.path  = info.imgPath
	self.sharePath = info.sharePath
	if gWeChatShareReward and string.len(gWeChatShareReward) >= 2 then
		GetElement(self.m_root,"conHasReward_WndWeChat",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conNoReward_WndWeChat",WZUIContainer):setVisible(false)
		WZLog("WndWeChat:setInfo222")
		local tabCon = GetElement(self.m_root, "tabReward_WndWeChat", WZUITableContainer)
		tabCon:cleanTable()
		local id,itemNum = SplitItemString(gWeChatShareReward)
		WZLog("WndWeChat:setInfo333:",#id)
		local len = #id
		if tabCon ~= nil then 
			-- tabCon:setAbsContentSize(GlobalMethod:CCSize(100*len,112))
			-- tabCon:setColumnCount(len)
			local posX = {0.86,0.74,0.62,0.5}
			tabCon:setRelativePosition(GlobalMethod:ccp(posX[#id],0.42))
			for i=1,#id do
		    	local key = "id_"..id[i]
		    	WZLog("WndWeChat:setInfo333:",key,itemNum[i])
		    	if GDatatab_item[key] ~= nil then
		    		WZLog("WndWeChat:setInfo444:")
			        local name = GDatatab_item[key].name
			        local path = GDatatab_item[key].icon
			        local num =  itemNum[i]
			        local quality = GDatatab_item[key].quality
			        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
					 WZLog("WndWeChat:setInfo555:",Serialize(itemInfo))
					local cellElement,tCell = CellGoodItem:createElement()
					tCell:setCellGoodItem(itemInfo,16)
					tCell:setItemClickFun(self,self.onClickItem)
					cellElement:setTag(i-1)
					tabCon:setCellElement(cellElement)
		    	end
			end
		end
	else
		GetElement(self.m_root,"conHasReward_WndWeChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conNoReward_WndWeChat",WZUIContainer):setVisible(true)
	end 
end

function WndWeChat:onClickItem(tItem, nTag, tData)
    WZLog("WndWeChat:onClickItem ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end


--@brief  点击分享按钮
function WndWeChat:onShare(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local PlatformId = WZUISystem:getInstance():getPlatformInfo()
	if PlatformId ~= 1 then
		if ProjConfig.SDK_CODE and ProjConfig.SDK_CODE >= 1 then
			SNSSdkManager:shareWeChatImage(self.sharePath)
		else
			MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION, nil, nil, nil, nil)
		end
	else
		WZLog("uuuuuuuuuuuuuuuuuuu")
		ProtocolProcessorPrefetchCache:send_TASK_WeChatShare()
		SNSSdkManager:shareWeChatImage(self.sharePath)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end


--@brief  点击取消按钮
function WndWeChat:onCancel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
