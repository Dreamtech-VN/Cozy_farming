--CellCharmReward.lua
--@brief	CellCharmReward的UI模块
--@date		2016/08/24
--@author	mpt
--@note		鲜花榜奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCharmReward:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCharmReward:onExit(element)
	self:_unInit()
end

--@brief	展示奖励内容
function CellCharmReward:_update(  )
	if self.onLoad == false then return end
	local imgRank = GetElement(self.m_root,"imgRank_CellCharmReward",WZUI9Image)
	local txtRank = GetElement(self.m_root,"txtRank_CellCharmReward",WZUILabelTTF)

	for k,v in pairs(self.rank) do
		if v[1] == v[2] and v[1] == 1 then
			imgRank:setFile("ui/common/common_icon_1st.png")
		elseif v[1] == v[2] and v[1] == 2 then
			imgRank:setFile("ui/common/common_icon_2nd.png")
		elseif v[1] == v[2] and v[1] == 3 then
			imgRank:setFile("ui/common/common_icon_3rd.png")
		elseif v[1] ~= v[2] and v[2] ~= -1 then
			--imgRank:setVisible(false)
			txtRank:setText(v[1].."-"..v[2])
		elseif v[1] ~= v[2] and v[2] == -1 then
			--imgRank:setVisible(false)
			txtRank:setText(v[1].."+")
		end
	end

	if #self.reward > 0 then
		for i=1,#self.reward do
			local id = "id_"..self.reward[i][1]
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell then
				local itemInfo = {id = GDatatab_item[id].id, name=GDatatab_item[id].name,icon=GDatatab_item[id].icon,lastTime=self.reward[i][2],quality=GDatatab_item[id].quality,basicInfo=CopyTable(GDatatab_item[id])}
           		celElement:setScale(0.8)
           		tCell:setCellGoodItem(itemInfo,4)
            	celElement:setTag(i-1)
           		tCell:setItemClickFun(WndCharmSpace,WndCharmSpace.onOthersClick)
			end
			GetElement(self.m_root,"con"..i.."_CellCharmReward",WZUIContainer):addChild(celElement)
		end
	end

	if self.tag == 1 then
		GetElement(self.m_root,"con7_CellCharmReward",WZUIContainer):setVisible(true)
		-- if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" then
		-- 	GetElement(self.m_root,"txtGuildRw_CellCharmReward",WZUILabelTTF):setText(LocalStrings.COMMUNITYINFO91)
		-- end
	end

end

--@brief	点击公会图标弹出公会奖励内容
function CellCharmReward:onTips( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	--WZLog("---CellCharmReward:onTips--")

	local sex = CacheCenter:getPlayerInfo().sex
	local reward
	local tTableReward = GDatatab_charm_rank_reward
	if WndCharmSpace.m_nInterfaceType == 1 then 
		tTableReward = GDatatab_glamour_fashion
	end
		
	for k,v in pairs(tTableReward) do
		if v.type == 2 then
			if sex == 0 then
				reward = v.reward_boy
				--WZLog("---CellCharmReward:reward1---",Serialize(reward))
			elseif sex == 1 then
				reward = v.reward_girl
				--WZLog("---CellCharmReward:reward2---",Serialize(reward))
			end
			local tData = {icon={},num={}}
			for k,v in pairs(reward) do
				table.insert(tData.icon,GDatatab_item["id_"..v[1]].icon)
				table.insert(tData.num,v[2])
			end
			tData.charm = true
			tData.strartNum = ""
			tData.endNum = ""
			WndTips:show(element,WndCharmSpace.m_root,3,tData,GlobalMethod:ccp(-30,0))
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin--------------------------------------------

-------------------------------------语言适配End-----------------------------------------------