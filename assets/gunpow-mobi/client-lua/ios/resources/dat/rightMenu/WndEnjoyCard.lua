--WndEnjoyCard.lua
--@brief	WndEnjoyCard的UI模块
--@date		2017/02/20
--@author	maopeiting
--@note		永久尊享卡福利


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEnjoyCard:onEnter(element)
	self.m_root = element
end

function WndEnjoyCard:onEnterTransitionDidFinish( element )
	WZLog("----WndEnjoyCard:onEnterTransitionDidFinish-----")
    self:_update()
end

function WndEnjoyCard:showWindow( )
	if not WndEnjoyCard.m_root then
		return
	end
	self:_update()
end

function WndEnjoyCard:_update(  )

	WZLog("-----WndEnjoyCard:_update---")
	self:_setRewardsList()

	local status = 0

	--获得玩家拥有的物品
	local tempList = CacheCenter:getPlayerItems()

	--WZLog("---WndEnjoyCard:tempList1----",Serialize(tempList))

	if #tempList > 0 then
		for k,v in pairs(tempList) do
			if v.basicInfo and v.basicInfo.id == 56 then
				GetElement(self.m_root,"txtCost_WndEnjoyCard",WZUILabelTTF):setVisible(false)
            	GetElement(self.m_root,"btn_WndEnjoyCard",WZUIButton):setVisible(false)
            	GetElement(self.m_root,"imgGet_WndEnjoyCard",WZUIImage):setVisible(true)
				status = 1
				WZLog("---WndEnjoyCard:tempList2----",Serialize(v))
			end
		end
	end

    if status == 0 then
    	GetElement(self.m_root,"txtCost_WndEnjoyCard",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"btn_WndEnjoyCard",WZUIButton):setVisible(true)
        GetElement(self.m_root,"imgGet_WndEnjoyCard",WZUIImage):setVisible(false)
        self:_initTxt()
    end
    if ProjConfig.CHANNEL_ID == 8888 or ProjConfig.CHANNEL_ID == 53 or ProjConfig.CHANNEL_ID == 75 or ProjConfig.CHANNEL_ID == 275 or ProjConfig.CHANNEL_ID == 68 or ProjConfig.CHANNEL_ID == 10 then
        GetElement(self.m_root,"btn_WndEnjoyCard",WZUIButton):setVisible(false)
        GetElement(self.m_root,"txtCost_WndEnjoyCard",WZUILabelTTF):setVisible(false)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEnjoyCard:onExit(element)
	self:_unInit()
end

--@brief	购买按钮的回调函数
function WndEnjoyCard:onRecharge(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    WndGameActivity:_createLoading()
    popFastRechargeUI(56)
end

--@brief	初始化界面
function WndEnjoyCard:_initTxt(  )
	WZLog("---WndEnjoyCard:_initTxt-----")
	local price = self:_getPrice(56)
	local txtPrice = GetElement(self.m_root,"txtCost_WndEnjoyCard",WZUILabelTTF)
	txtPrice:setUseSystemFont(true)
	txtPrice:setText(price)
end

--@brief	獲得永久尊享卡的價格
function WndEnjoyCard:_getPrice( itemId )
	WZLog("---WndEnjoyCard:_getPrice-----",itemId)
	local vipList = CacheCenter:getVipList()
	WZLog("WndEnjoyCard:vipList",Serialize(vipList))
	for i=1,#vipList do
		if vipList[i].itemId == itemId then
			WZLog("----WndEnjoyCard:price----",vipList[i].showPrice)
			return vipList[i].showPrice
		end
	end
end

--@brief	展示獎勵
function WndEnjoyCard:_setRewardsList(  )
	WZLog("---WndEnjoyCard:_setRewardsList-----")
	local tab = GetElement(self.m_root,"tab_WndEnjoyCard",WZUITableContainer)
	tab:cleanTable()

	local level = CacheCenter:getPlayerInfo().level

	for k,v in pairs(GDatatab_task) do
		if v.sub_type == 30031 and v.level <= level and v.max_level >= level then
			self.reward = v.reward
		end
	end
	table.sort( self.reward, sortRewards )
	WZLog("---WndEnjoyCard:reward-----",Serialize(self.reward))
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
function WndEnjoyCard:onTips( tCell,tag,tData )
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
