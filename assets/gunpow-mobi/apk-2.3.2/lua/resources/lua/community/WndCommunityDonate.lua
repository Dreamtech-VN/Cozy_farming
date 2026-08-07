--WndCommunityDonate.lua
--@brief	WndCommunityDonate的UI模块
--@date		2015/04/22
--@author	zsq
--@note		公会捐献


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityDonate:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief    onenter函数已执行
function WndCommunityDonate:onEnterTransitionDidFinish(element)
    --弹窗动画
    self:addCell()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityDonate:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityDonate:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityDonate, true)
	end 
end

--@brief	加载tbconText每个单元格的定时器回调方法
--@note		采用定时器逐帧加载tbconText的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function WndCommunityDonate:addCell()
	local tableCon = GetElement(self.m_root,"tbcon_WndDonate",WZUITableContainer)
	local cellNum = 0
	--加载表格元素
	for k,v in pairs(GDatatab_guild_donate) do
		cellNum = cellNum + 1
	end
	for i=1,cellNum do 
		local v = GDatatab_guild_donate["id_"..i]
		local celElement,tCell = CellCommunityDonate:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(i-1)
			tCell:setPlayerId(v.id)
			tableCon:setCellElement(celElement)
			--cell文字
    		local text = LocalStrings.COMMUNITYINFO60
    		local sIconPath = GDatatab_item["id_" .. v.cost[1][1]].icon
			tCell:setCommunityDonate(string.format(text, sIconPath, v.cost[1][2],v.reward[1][2],v.reward[2][2]))
			
			if i == 2 then
				WZLog("默认选中第2个")
				self.tag = 2
				tCell:setCheckBoxSelState(celElement,1)
			end
		end 
	end
end 

--@brief	列表被选中回调
function WndCommunityDonate:onCellChecked(element)
	WZLog("WndCommunityDonate:onCellChecked",element:getTag())
	self.tag = element:getTag()

	local num = 0

	for k,v in pairs(GDatatab_guild_donate) do
		num = num + 1
	end

	--根据在表格中的Tag值取得当前的容器的表对象设置相应的状态   
	local tbconTextMemberList = self.m_root:getChildElement("tbcon_WndDonate")
	if tbconTextMemberList ~= nil then 
		tbconTextMemberList = WZUITableContainer:luaTo(tbconTextMemberList)
		for var = 1,num  do 
			local celElement = tbconTextMemberList:getCellElement(var-1)
			celElement = WZUIContainer:luaTo(celElement)
			if celElement ~= nil then 
				CellCommunityDonate:setCheckBoxSelState(celElement,0)	
			end				
		end 
	end 
end


--@brief	点击捐献按钮
function WndCommunityDonate:onDonate(element)
	WZLog("WndCommunityDonate:onDonate")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.tag == nil then return end
	local moneyInfo = CacheCenter:getMoneyList()
	local key = "id_"..self.tag
	local info = GDatatab_guild_donate[key]
	local moneyEnough = false

	local tCustomUIConfig
	if CacheCenter:getGuildInfo() == nil then return end
	if CacheCenter:getGuildInfo().buyDonate ~= "0" and CacheCenter:getGuildInfo().buyDonate ~= 0 then
		if LocalStrings.FIRST_DAY_CAN_NOT_DONATE and tonumber(CacheCenter:getGuildInfo().buyDonate) == 2 then
			MsgBoxManager:showTipBox(LocalStrings.FIRST_DAY_CAN_NOT_DONATE)
		else
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO103)
		end
		return 
	end

	if info.cost[1][1] == 1 or info.cost[1][1] == 70 then
		tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
	end
	if not JudgeMoneyIsEnough(info.cost[1][1], info.cost[1][2], nil, nil, Chat_Channel_Guild_Donate, nil, nil, tCustomUIConfig, nil, self, self.clickSureMoney) then
		return 
	end

	self:clickSureMoney()
end

--@brief	点击确定用钻石代替礼券捐献回调
function WndCommunityDonate:clickSureMoney()
	ProtocolProcessorSceneCommunity:send_GUILD_GuildDonate(self.tag)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityDonate, true)
	end 
end

--@brief	快速购买金币框
function WndCommunityDonate:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndCommunityDonate:_adaptLanguage_ug()
	GetElement(self.m_root,"txtDonate",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------
