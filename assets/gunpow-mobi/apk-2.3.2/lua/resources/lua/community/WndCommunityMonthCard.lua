--WndCommunityMonthCard.lua
--@brief	WndCommunityMonthCard的UI模块
--@date		2015/11/04
--@author	zsq
--@note		公会月卡窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityMonthCard:onEnter(element)
	self.m_root = element
	--ProtocolProcessorWndMonthCards:regAll()
	ProtocolProcessorWndMonthCards:send_MONTHCARD_GetOnlineMember()
	local txtTop = GetElement(self.m_root,"txtTop_WndCommunityMonthCard",WZUILabelTTF)
	if ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "hk" then
		local temp = LocalStrings.COMMUNITY .. LocalStrings.REWARD_BTN_ONLINE .. LocalStrings.FRIEND
	    txtTop:setText(temp)
	else
		local temp = LocalStrings.COMMUNITY .. " " .. LocalStrings.REWARD_BTN_ONLINE .. " ".. LocalStrings.FRIEND
	    txtTop:setText(temp)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityMonthCard:onExit(element)
	self:_unInit()
	--ProtocolProcessorWndMonthCards:unregAll()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	关闭按钮
function WndCommunityMonthCard:onClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityMonthCard, true)
	end 
end

--@brief	加载tbconText每个单元格的定时器回调方法
--@note		采用定时器逐帧加载tbconText的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function WndCommunityMonthCard:update()
	local tableCon = GetElement(self.m_root,"tbcon_WndMonthCard",WZUITableContainer)
	tableCon:cleanTable()

	for i=1,#self.m_tData do 
		local celElement,tCell = CellCommunityMonthCard:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(i-1)
			tCell:update(self.m_tData[i])
			tableCon:setCellElement(celElement)
			--if i == 1 then
			--	WZLog("默认选中第一个")
			--	--tCell:onSelCheckBox(GetElement(celElement,"checkBoxSel_CellRecruitList",WZUICheckBox))
			--	self.tag = 1
			--	tCell:setCheckBoxSelState(celElement,1)
			--end
		end 
	end
end 

--@brief	列表被选中回调
function WndCommunityMonthCard:onCellChecked(element)
	WZLog("WndCommunityMonthCard:onCellChecked",element:getTag())
	self.tag = element:getTag()

	--根据在表格中的Tag值取得当前的容器的表对象设置相应的状态   
	local tbconTextMemberList = self.m_root:getChildElement("tbcon_WndMonthCard")
	if tbconTextMemberList ~= nil then 
		tbconTextMemberList = WZUITableContainer:luaTo(tbconTextMemberList)
		for var = 1,#self.m_tData  do 
			local celElement = tbconTextMemberList:getCellElement(var-1)
			local element1 = GetElement(celElement,"CellCommunityMonthCard",WZUIContainer)
	WZLog("比较tag",element1:getLuaObjectIndex().m_tData.id,element:getTag())
			celElement = WZUIContainer:luaTo(celElement)
			if celElement ~= nil and element1:getLuaObjectIndex().m_tData.id ~= element:getTag() then 
				CellCommunityMonthCard:setCheckBoxSelState(celElement,0)	
			end				
		end 
	end 
end

--@brief	点击捐献按钮
function WndCommunityMonthCard:onConfirm(element)
	WZLog("WndCommunityMonthCard:onConfirm")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.tag == nil then 
		MsgBoxManager:showTipBox(LocalStrings.MONTHCARDINFO2)
		return 
	end

    -- 发送穿戴协议
   	local id = WZLuaVector_int_:create()
	id:push(tonumber(self.tag))
	ProtocolProcessorWndMonthCards:send_MONTHCARD_GiveMonthCard(id )

	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityMonthCard, true)
	end 
end




-------------------------------------私有方法模块End----------------------------------------
