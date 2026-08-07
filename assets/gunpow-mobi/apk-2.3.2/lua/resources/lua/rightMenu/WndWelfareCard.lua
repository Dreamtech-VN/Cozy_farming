--WndWelfareCard.lua
--@brief	WndWelfareCard的UI模块
--@date		2016/07/30
--@author	maopeiting
--@note		永久福利卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWelfareCard:onEnter(element)
	self.m_root = element
end

function WndWelfareCard:onEnterTransitionDidFinish( element )
	WZLog("----WndWelfareCard:onEnterTransitionDidFinish-----")
    self:_update()
    AdaptLanguage(self)
end

function WndWelfareCard:showWindow( )
	if not WndWelfareCard.m_root then
		return
	end
	self:_update()
end

function WndWelfareCard:_update(  )

	WZLog("-----WndWelfareCard:_update---")
	self:_setRewardsList()

	local status = 0

	--获得玩家拥有的物品
	local tempList = CacheCenter:getPlayerItems()

	--WZLog("---WndWelfareCard:tempList1----",Serialize(tempList))

	if #tempList > 0 then
		for k,v in pairs(tempList) do
			if v.basicInfo and v.basicInfo.id == 52 then
				GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF):setVisible(false)
            	GetElement(self.m_root,"btn_WndWelfareCard",WZUIButton):setVisible(false)
            	GetElement(self.m_root,"imgGet_WndWelfareCard",WZUIImage):setVisible(true)
				status = 1
				WZLog("---WndWelfareCard:tempList2----",Serialize(v))
			end
		end
	end

	-- local taskSub = PrefetchCache:getTaskList().tDailyTask.tToSubmit

	-- local taskComp = PrefetchCache:getTaskList().tDailyTask.tCompleted

	-- WZLog("----WndWelfareCard:taskSub-----",Serialize(taskSub))
	-- WZLog("----WndWelfareCard:taskComp-----",Serialize(taskComp))

 --    if #taskSub > 0 then
 --    	for i = 1, #taskSub do
 --    		WZLog("--WndWelfareCard1----")
 --        	local nTask_sub_type = GDatatab_task["id_"..taskSub[i].nId].sub_type 
 --        	WZLog("--WndWelfareCard2:nTask_sub_type----",nTask_sub_type)
 --       		if nTask_sub_type == 30018 and taskSub[i].nTaskStatus >= TASKSTATUS_TOSUBMIT then 
 --        		GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF):setVisible(false)
 --            	GetElement(self.m_root,"btn_WndWelfareCard",WZUIButton):setVisible(false)
 --            	GetElement(self.m_root,"imgGet_WndWelfareCard",WZUIImage):setVisible(true)
 --            	status = 1
 --        	end
 --    	end
 --    end

 --    if #taskComp > 0 then
 --    	for i = 1, #taskComp do
 --    		WZLog("--WndWelfareCard3----")
 --        	local nTask_sub_type = GDatatab_task["id_"..taskComp[i].nId].sub_type 
 --        	WZLog("--WndWelfareCard4:nTask_sub_type----",nTask_sub_type)
 --       		if nTask_sub_type == 30018 and taskComp[i].nTaskStatus >= TASKSTATUS_COMPLETED then 
 --        		GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF):setVisible(false)
 --            	GetElement(self.m_root,"btn_WndWelfareCard",WZUIButton):setVisible(false)
 --            	GetElement(self.m_root,"imgGet_WndWelfareCard",WZUIImage):setVisible(true)
 --            	status = 1
 --        	end
 --    	end
 --    end

    if status == 0 then
    	GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"btn_WndWelfareCard",WZUIButton):setVisible(true)
        GetElement(self.m_root,"imgGet_WndWelfareCard",WZUIImage):setVisible(false)
        self:_initTxt()
    end
    if whetherCloseRecharge() then
        GetElement(self.m_root,"btn_WndWelfareCard",WZUIButton):setVisible(false)
        GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF):setVisible(false)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWelfareCard:onExit(element)
	self:_unInit()
end

--@brief	购买按钮的回调函数
function WndWelfareCard:onRecharge(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--PassportSdkManager:gotoPaymentPage()
    --WindowManager:removeWindow(WndGameActivity.m_root,WndGameActivity,true)
    WndGameActivity:_createLoading()
    popFastRechargeUI(52)
    
end

--@brief	初始化界面
function WndWelfareCard:_initTxt(  )
	WZLog("---WndWelfareCard:_initTxt-----")
	local price = self:_getPrice(52)
	local txtPrice = GetElement(self.m_root,"txtCost_WndWelfareCard",WZUILabelTTF)
	txtPrice:setUseSystemFont(true)
	txtPrice:setText(price)
end

--@brief	獲得永久福利卡的價格
function WndWelfareCard:_getPrice( itemId )
	WZLog("---WndWelfareCard:_getPrice-----",itemId)
	local vipList = CacheCenter:getVipList()
	WZLog("WndWelfareCard:vipList",Serialize(vipList))
	for i=1,#vipList do
		if vipList[i].itemId == itemId then
			WZLog("----WndWelfareCard:price----",vipList[i].showPrice)
			return vipList[i].showPrice
		end
	end
end

--@brief	展示獎勵
function WndWelfareCard:_setRewardsList(  )
	WZLog("---WndWelfareCard:_setRewardsList-----")
	local tab = GetElement(self.m_root,"tab_WndWelfareCard",WZUITableContainer)
	tab:cleanTable()

	local level = CacheCenter:getPlayerInfo().level

	for k,v in pairs(GDatatab_task) do
		if v.sub_type == 30018 and v.level <= level and v.max_level >= level then
			self.reward = v.reward
		end
	end
	table.sort( self.reward, sortRewards )
	WZLog("---WndWelfareCard:reward-----",Serialize(self.reward))
	for i=1,#self.reward do
		local id = string.format("id_".."%d",self.reward[i][1])
		local num = self.reward[i][2]
		local itemInfo = {id = GDatatab_item[id].id, name=GDatatab_item[id].name,icon=GDatatab_item[id].icon,lastTime=num,quality=GDatatab_item[id].quality,basicInfo=CopyTable(GDatatab_item[id])}
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell ~= nil then
			celElement:setTag(i-1)
			tCell:setCellGoodItem(itemInfo,4)
			tCell:setItemClickFun(self,self.onTips)
			tab:setCellElement(celElement)
		end
	end

end

--@brief	顯示tips
function WndWelfareCard:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end





-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function WndWelfareCard:_adaptLanguage_tr()
	GetElement(self.m_root,"txtBuy_WndWelfareCard",WZUILabelTTF):setFontSize(18)
end
-------------------------------------语言适配End--------------------------------------------