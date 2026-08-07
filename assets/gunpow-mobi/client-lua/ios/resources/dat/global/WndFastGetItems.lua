--WndFastGetItems.lua
--@brief	WndFastGetItems的UI模块
--@date		2016/01/21
--@author	qixiang_xie
--@note		快速跳转到相应场景获取相应物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFastGetItems:onEnter(element)
	self.m_root = element
	self:initUI()
	self:showItemInfo()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFastGetItems:onExit(element)
	self:_unInit()
end

--@brief  关闭当前窗口
function WndFastGetItems:onClikClose(element)
	WZLog("WndFastGetItems:onClikClose")
	g_fastGetItemId = nil
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  显示物品名字
function WndFastGetItems:showItemName(element)
	element:setText(self.m_itemInfo.name)
end

--@brief  显示物品图片
function WndFastGetItems:showItemIcon(element)
	element:setFile(self.m_itemInfo.icon)
end

--@brief  显示拥有的数量
function WndFastGetItems:showPossessCount(element)
	element:setText(self.m_nPossessCount .. "/" .. self.m_nNeedCount)
end

--@brief  显示物品信息
function WndFastGetItems:showItemInfo()
	WZLog("WndFastGetItems:showItemInfo")
	if self.m_itemInfo then
		local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
	    self:showItemName(txtItemName)

		local imgItemIcon = GetElement(self.m_root,"imgItemIcon_WndFastGetItems",WZUIImage)
		self:showItemIcon(imgItemIcon)

        local tableHurdlesList = GetElement(self.m_root,"tableHurdlesList_WndFastGetItems",WZUIFreeListContainer)
	    tableHurdlesList:removeAll()
		self:showGetItemHurdles(tableHurdlesList)
	end

	GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF):setText("")
	if self.m_itemInfo.id >= 7800 and self.m_itemInfo.id <= 7807 then
		GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF):setText(LocalStrings["EQUIPTYPETIP"..(self.m_itemInfo.sub_type)])
	end
end

--@brief  展示可以获取到物品的关卡信息
function WndFastGetItems:showGetItemHurdles(tableElement)
	WZLog("WndFastGetItems:showGetItemHurdle=",self.m_itemInfo.channel)
	local channel = self.m_itemInfo.channel
	
	local temp = WndLibrary:exchangeToTable(channel)
	
	self.m_tTempTable = {}
	
	if temp ~= nil and  #temp > 0 then
		tableElement:setVisible(true)
	    for i,v in ipairs(temp) do
	    	if v[1] == 1 then  --单人副本
	            local nChallengeCount = CopyManager:findSCopyChallengeN(v[2])
	            if nChallengeCount == nil then nChallengeCount = 0 end
	    		table.insert(v,nChallengeCount)
	    	else
	    		table.insert(v,0)
	    	end
	    	table.insert(self.m_tTempTable,v)
	    end
	    
	    table.sort(self.m_tTempTable,function (a,b)
	    	if a[3] < 3 and b[3] == 3 then
	    		return true
	    	end
	    	return false
	    end)


	    table.sort(self.m_tTempTable,function (a,b)
	    	if a[3] == 3 and b[3] == 3 then
	    		if type(a[2]) ~= "string" and type(b[2]) ~= "string" and  a[2] < b[2] then
	    			return true
	    		end
	    	elseif a[3] ~= 3 and b[3] ~=  3 then
	    		if type(a[2]) ~= "string" and type(b[2]) ~= "string" then
	    			if a[2] < b[2]  then
	    				return true
	    			end
	    		end
	    	end
	    	return false
	    end)
	    WZLog("WndFastGetItems:showGetItemHurdle = ",Serialize(self.m_tTempTable))
	    for i,v in ipairs(self.m_tTempTable) do
	    	local cellFastJump =WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump"))
	    	cellFastJump:setVisible(true)
	    	cellFastJump:setTag(i-1)
	    	
	    	cellFastJump:setRelativeSize(GlobalMethod:CCSize(1,90/274))
	    	local txtChaptersName = GetElement(cellFastJump,"txtChaptersName_WndFastGetItems",WZUILabelTTF)
	    	local txtChaptersDesc = GetElement(cellFastJump,"txtChaptersDesc_WndFastGetItems",WZUILabelTTF)
	    	local txtInterfaceName = GetElement(cellFastJump,"txtInterfaceName_WndFastGetItems",WZUILabelTTF)
	    	local imgTag = GetElement(cellFastJump,"imgTag_WndFastGetItem",WZUIImage)
	    	if ProjConfig.LANGUAGE == "en" then
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersName:setScale(0.7)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.7)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(340))
	    	elseif ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersName:setScale(0.75)
	    		txtChaptersDesc:setScale(0.75)
	    		txtInterfaceName:setScale(0.75)
	    	elseif ProjConfig.LANGUAGE == "pt" then
	    		txtChaptersName:setScale(0.68)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.68)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(340))
	    	elseif ProjConfig.LANGUAGE == "es" then
	    		txtChaptersName:setScale(0.6)
	    		txtChaptersName:setDimensions(GlobalMethod:CCSize(400))
	    		txtChaptersDesc:setScale(0.6)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.6)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(400))
	    	elseif ProjConfig.LANGUAGE == "tr" then	    		
	    		txtInterfaceName:setScale(0.6)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(320))
	    		txtChaptersName:setScale(0.7)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    	elseif ProjConfig.LANGUAGE == "hk" then
	    		txtChaptersName:setRelativePosition(GlobalMethod:ccp(0.03,0.763043))
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setScale(0.7)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtChaptersDesc:setRelativePosition(GlobalMethod:ccp(0.02,0.33))
	    		imgTag:setRelativePosition(GlobalMethod:ccp(0.9,0.5))
	    	end
	    	local itemInfo = nil
	    	imgTag:setFile("")
	    	if v[1] ~= 4 then
	    		imgTag:setFile("ui/common/common_icon_go.png")
	    	end
	    	if v[1] == 1 then  --单人副本
	    		itemInfo = GDatatab_single_map["id_"..v[2]]
	    		local section_name = itemInfo.section_name
	            if itemInfo.map_type == 1 then
	            	section_name = section_name  .. " " .. LocalStrings.NORMAL
	            elseif itemInfo.map_type == 2 then
	            	section_name = section_name  .. " " .. LocalStrings.PICK 
	            end

	            local nChallengeCount = v[3]
	            local nEnabledChallengeCount = itemInfo.pass_times

                if nChallengeCount == nil then nChallengeCount = 0 end
                nChallengeCount = nEnabledChallengeCount - nChallengeCount
                section_name = section_name .. "(" .. nChallengeCount .. "/" .. nEnabledChallengeCount .. ")"
	    		txtChaptersName:setText(section_name)
	    		txtChaptersDesc:setText(itemInfo.map_name)
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 2 then  --组队副本
	    		itemInfo = GDatatab_team_map["id_"..v[2]]
	    		txtChaptersName:setText(itemInfo.map_name)
	    		txtChaptersDesc:setText(itemInfo.map_desc)
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 3 then
	    		local interfaceNaem = GDatatab_interface["id_" .. v[2] ]
	    		txtInterfaceName:setText(interfaceNaem.name)
	    		if tonumber(v[2]) == 200 then
	    			txtInterfaceName:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	    			txtInterfaceName:setRelativePosition(GlobalMethod:ccp(0.5, 0.7))
	    			txtChaptersName:setText(string.format(LocalStrings.SECTION_WORD, v[3]))
	    			txtChaptersName:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	    			txtChaptersName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
	    		end
	    		if interfaceNaem.id == 182 or interfaceNaem.id == 183 or interfaceNaem.id == 184 or interfaceNaem.id == 43 then
	    			imgTag:setFile("ui/common/common_icon_buy.png") --商城购买
	    		end
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 4 then
	    		local cellFastJump2 = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2"))
		    	cellFastJump2:setVisible(true)
		    	cellFastJump2:setTag(i-1)
		    	cellFastJump2:setRelativeSize(GlobalMethod:CCSize(1,90/274))
		    	local txtInterfaceName = GetElement(cellFastJump2,"txtInterfaceName_WndFastGetItems",WZUILabelTTF)
				txtInterfaceName:setText(v[2])

				tableElement:pushBack(cellFastJump2)
			elseif v[1] == 5 then
				tableElement:pushBack(cellFastJump)
				local itemInfo = GDatatab_item["id_" .. v[2]]
			    temp = LocalStrings.USE .. itemInfo.name
			    txtInterfaceName:setText(temp)
	    	end
	    end
	else
		tableElement:setVisible(false)
		if channel ~= nil and type(channel) == "string" then
			local txtGetItemDescribe = GetElement(self.m_root,"txtGetItemDescribe_WndFastGetItems",WZUILabelTTF)
		    txtGetItemDescribe:setText(channel)
		end
	end

	
	local minPs= tableElement:getMinPosition()
	tableElement:getMoveElement():setPositionY(minPs.y)
end

function WndFastGetItems:initUI()
	local itemType = self.m_itemInfo.main_type
	local property =self.m_itemInfo.property
	if itemType ~= 4 then
		local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
        txtItemCountS:setText(LocalStrings.NUM1 .. ":")

        local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
		self:showPossessCount(txtItemCountN)
	else
		local propertyName =ATTR_TITLE[property[1][1]]
		local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
        txtItemCountS:setText(propertyName .. ":")

        local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
        txtItemCountN:setText(property[1][2])
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  跳转到相应场景
function WndFastGetItems:onClickJump(element)
	WZLog("WndFastGetItems:onClickJump")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local parentNode = element:getParent()
	parentNode = WZUIContainer:luaTo(parentNode)
	local tag = parentNode:getTag()
	local channel = self.m_itemInfo.channel
	local temp = self.m_tTempTable
	local hurdlesInfo = temp[tag+1]
	local hurdlesType = hurdlesInfo[1]
	local hurdlesId = hurdlesInfo[2]
	local hurdlesId3 = hurdlesInfo[3]
	local bCanJump= false
	WZLog("hurdlesId = ",hurdlesType,hurdlesId,hurdlesId3)
	
	if hurdlesType == 1 then -- 单人副本
		if CopyManager:bJumpToSingleCopy(hurdlesId) then
			bCanJump = true
			if SceneRoom.m_root ~= nil then
    		    SceneRoom:exitRoom()
    	    end
			SceneCopy:showScene(1, nil, hurdlesId,false)
		end
	elseif hurdlesType == 2 then --组队副本
		if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
			bCanJump = true
			if SceneRoom.m_root ~= nil then
    		    SceneRoom:exitRoom()
    	    end
			SceneCopy:showScene(2, nil, nil,nil)
		end
	elseif hurdlesType == 5 then
		local tempKey = "id_" .. hurdlesId
		local itemInfo = GDatatab_item[tempKey]
		
		if itemInfo ~= nil then
			local itemCount = CacheCenter:getPlayerItemCountById(hurdlesId) 
			if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 or itemInfo.main_type == 2 then
				if itemCount <= 0 then
					MsgBoxManager:showTipBox(LocalStrings.NOT_GOODS_TIP)
					return
				end
		    end
            local name = itemInfo.name
            local path = itemInfo.icon
            local num =  itemCount
            local quality = itemInfo.quality
            local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(itemInfo)}
            
            local wndOpenChest = WndOpenChest:createElement()
		    WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
            WndOpenChest:setData(itemInfo)
            bCanJump = true
        end
        
	elseif hurdlesType == 4 then

	else
	   	if hurdlesId == 182 or hurdlesId == 183 or hurdlesId == 184 or hurdlesId == 186 or hurdlesId == 43 
	   	or hurdlesId == 213 or hurdlesId == 214 or hurdlesId == 215 or hurdlesId == 216 or hurdlesId == 217 
	   	or hurdlesId == 223 or hurdlesId == 224 or hurdlesId == 225 or hurdlesId == 226 then
			WndFastGetItems.m_nShopTipItemId = WndFastGetItems.m_itemInfo.id
			--如果是技能点，换成中级技能书
			if WndFastGetItems.m_nShopTipItemId == 63 then
				WndFastGetItems.m_nShopTipItemId = 551
			end
		end
		JumpByUIId(hurdlesId,hurdlesId3)
		bCanJump = true
	end
    if bCanJump then
    	WindowManager:removeWindow(self.m_root,WndFastGetItems,true)
		if WndSkillContainer and WndSkillContainer.m_root then
			WindowManager:removeWindow(WndSkillContainer.m_root,WndSkillContainer,true)
		end
    end
end

function WndFastGetItems:_adaptLanguage_vn()
    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(20)
    local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
    txtItemCountS:setFontSize(19)
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setFontSize(19)
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.510583,0.366667))
end

function WndFastGetItems:_adaptLanguage_th()
    WZLog("WndFastGetItems:_adaptLanguage_th ")
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.555291,0.366667))
    local txtItem = GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF)
    txtItem:setFontSize(16)
end

function WndFastGetItems:_adaptLanguage_en()
    WZLog("WndFastGetItems:_adaptLanguage_en")
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.55,0.356667))
    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))

    local txtItem = GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF)
    txtItem:setDimensions(GlobalMethod:CCSize(240,0))
end

function WndFastGetItems:_adaptLanguage_pt(  )
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setFontSize(16)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setFontSize(16)
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.497355,0.366667))
	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))
end

function WndFastGetItems:_adaptLanguage_tr(  )
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.6,0.366667))

	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(22)
end

function WndFastGetItems:_adaptLanguage_es()
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setFontSize(16)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setFontSize(16)
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.497355,0.366667))

    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))

    GetElement(self.m_root,"txtGetItemDescribe_WndFastGetItems",WZUILabelTTF):setFontSize(18)
end
-------------------------------------私有方法模块End----------------------------------------
