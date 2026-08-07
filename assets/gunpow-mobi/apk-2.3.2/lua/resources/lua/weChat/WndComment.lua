--WndComment.lua
--@brief	WndComment的UI模块
--@date		2017/04/26
--@author	zhangming
--@note		评论UI界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndComment:onEnter(element)
	self.m_root = element	
	self:setInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndComment:onExit(element)
	self:_unInit()
end

--@brief 显示评论界面
function WndComment:show(id)
    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        return
    end
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	local packageName = WGameCmUtil:GetBundleIdentifier()
	if platForm == 1 and packageName == "com.wyd.dandandao.hero" then
		DelayCallFunction(function() 
			local element = WndComment:createElement()
     	WindowManager:addWindow(element, WndComment) 
     	self.m_nId = id
     	end,nil,5)	
    end
end

--@brief	设置界面信息
function WndComment:setInfo()
	WZLog("WndComment:setInfo()",gAppStoreCommentStatus)
	if tonumber(gAppStoreCommentStatus) == 0 then
		GetElement(self.m_root,"conAll_WndComment",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(420,440))
		GetElement(self.m_root,"con1_WndComment",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"con2_WndComment",WZUIContainer):setVisible(false)
		local tabCon = GetElement(self.m_root, "tabReward_WndComment", WZUITableContainer)
		tabCon:cleanTable()
		local data = CacheCenter:getGameParam()["appStoreCommentReward"]
		WZLog(" WndComment:setInfo:",data)
		local id,itemNum = SplitItemString("[70,50]")
		local len = #id
		if tabCon ~= nil then 		
			-- tabCon:setColumnCount(len)
			-- GetElement(self.m_root,"conTab_WndComment",WZUIContainer):setContentSize(GlobalMethod:CCSize(300,100))	
			--tabCon:setContentSize(GlobalMethod:CCSize(200,100))
			local posX = {0.86,0.74,0.62,0.5}
			tabCon:setRelativePosition(GlobalMethod:ccp(posX[#id],0.38))
			--tabCon:setContentSize(GlobalMethod:CCSize(200,100))	
			for i=1,#id do
		    	local key = "id_"..id[i]
		    	WZLog("WndComment:setInfo333:",key,itemNum[i])
		    	if GDatatab_item[key] ~= nil then
		    		WZLog("WndComment:setInfo444:")
			        local name = GDatatab_item[key].name
			        local path = GDatatab_item[key].icon
			        local num =  itemNum[i]
			        local quality = GDatatab_item[key].quality
			        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
					 WZLog("WndComment:setInfo555:",Serialize(itemInfo))
					local cellElement,tCell = CellGoodItem:createElement()
					tCell:setCellGoodItem(itemInfo,16)
					tCell:setItemClickFun(self,self.onClickItem)
					cellElement:setTag(i-1)
					tabCon:setCellElement(cellElement)
		    	end
			end
		end
	else
		GetElement(self.m_root,"conAll_WndComment",WZUIContainer):setRelativeSize(GlobalMethod:CCSize(1,0.8))
		GetElement(self.m_root,"con1_WndComment",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con2_WndComment",WZUIContainer):setVisible(true)
	end
end

function WndComment:onClickItem(tItem, nTag, tData)
    WZLog("WndComment:onClickItem ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief	点击按钮回调
function WndComment:onClick(element)
	local tag = element:getTag()
	if tag == 1 then --前往评论
		WZLog("self.m_nId:",self.m_nId)
		local url = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1093063463&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
		WZPush:openURL(url)
		-- local version = WZDeviceInfo:systemVersion()
		-- if version >= "10.3" and ProjConfig.INSTALLVERSION > "1.5.5" then
		-- 	local t_utilsAdapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("DandandaoUtils")
  --           t_utilsAdapter:callMethodByName("requestReview",nil,"")
  --           WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(t_utilsAdapter:getId())
  --       else
  --       	WZLog("sWndComment:onClick:",version,ProjConfig.INSTALLVERSION)
  --           local url = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1093063463&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
		-- 	WZPush:openURL(url)
		-- 	-- WndActivities:showView()
  --  --      	WndActivities:_setActivityUrl(url)
  --       end
		--
		ProtocolProcessorGlobal:send_PLAYER_FinishComment(self.m_nId,3,"5")
	elseif tag == 2 then --以后再说
		ProtocolProcessorGlobal:send_PLAYER_FinishComment(self.m_nId,1,"")
	elseif tag == 3 then --拒绝
		ProtocolProcessorGlobal:send_PLAYER_FinishComment(self.m_nId,2,"")
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
