--WndHandBook.lua
--@brief	WndHandBook的UI模块
--@date		2021/01/04
--@author	hyc
--@note		收集图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHandBook:onEnter(element)
	self.m_root = element
	self:_addTop()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHandBook:onExit(element)
	self:_unInit()
end

function WndHandBook:onEnterTransitionDidFinish(element)
	self:_initUI()
	self:updateBtn()
end

--@brief 创建大标题
function WndHandBook:updateBtn()
	self.m_tHorses = CacheCenter:getMountInfo()
	self.m_tFoot = CacheCenter:getFootMarkInfo()
	self.m_tSkin = CacheCenter:getSkinStatus()
    
    local tTitleBtn = self.m_tTitleBtn

    local tempTabSubId = self.m_tTitleBtn.tabBtnSubId[self.m_nBigIndex]

	for i = 1,4 do
		local smallBtn = GetElement(self.m_root,"smallItem"..i.."_WndHandBook",WZUICheckBox)
		smallBtn:setVisible(false)
		local redDot1 = GetElement(smallBtn,"bookRedDot"..i.."_WndHandBook",WZUIImage)
		redDot1:setVisible(false)
	end

	for i=1,#tempTabSubId do
		local smallBtn = GetElement(self.m_root,"smallItem"..i.."_WndHandBook",WZUICheckBox)
		local redDot1 = GetElement(smallBtn,"bookRedDot"..i.."_WndHandBook",WZUIImage)
		smallBtn:setVisible(true)
		for j=1,2 do
			local smallTxt = GetElement(smallBtn,"txtTitle"..j.."_WndHandBook",WZUILabelTTF)
			smallTxt:setText(tTitleBtn.tabBtnSubTitle[self.m_nBigIndex][i])
		end
	end

	self:updateSmallItemReddot()

	self:showBookitem(self.m_nBigIndex,self.m_nCurIndex)

end

function WndHandBook:updateRedStatus(index)
	-- body

end

--@brief  添加金币图标动画
function WndHandBook:_addTop()
  local cell, tcell = CellTopHandle:createElement()
  self.m_root:addChild(cell)
  tcell:setTopData("ui/common/common_icon_hb.png", WndHandBook, self.onReturn,true,nil,nil,nil)
  tcell:setTopType()    
end

--@brief 返回
function WndHandBook:onReturn(element)
    WZLog("点击返回按钮")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 显示item param bigindex:第几个大标题，smallindex:第几个小标题
function WndHandBook:showBookitem(bigindex,smallindex)
	local tdata = {}
	if bigindex == 1 then
	 -- 获取坐骑信息
		for i ,v in pairs(GDatatab_mounts) do
		 	if v.type == smallindex and v.reward ~= -1 then
		 		table.insert(tdata,v)
		 	end
		end
		-- WZLog("坐骑的数据",tdata)

	elseif bigindex == 2 then
		local playerSex = CacheCenter:getPlayerInfo().sex
		for i,v in pairs(GDatatab_shape_skins) do
			local skinType = v.type
			local skinSex = v.sex
			-- WZLog("设置皮肤item进来了",v.name)
			if skinType == smallindex and (playerSex == skinSex or skinSex == 2) and v.quality <= 4 and v.reward ~= -1 then
				table.insert(tdata,CopyTable(v))
			end
		end
		-- WZLog("皮肤的个数",x)
	elseif bigindex == 3 then
		for i ,v in pairs(GDatatab_footmark) do
			if v.type == smallindex and v.reward ~= -1 then
				table.insert(tdata,v)
			end
		end
	end
	local sortdata = self:sortTable(tdata)
	WZLog("排序后的坐骑列表",Serialize(sortdata))
	table.sort( sortdata, sortStatus)
	self:showItem(sortdata,bigindex)

end

function sortStatus(a,b)
	local x1 = a.collectStatus == 1 and -1 or a.collectStatus
 	local x2 = b.collectStatus == 1 and -1 or b.collectStatus
 	if x1 == x2 then
  		return a.id < b.id
 	else
  		return x1 < x2
 	end
end

function WndHandBook:sortTable(tdata)
	--body
	self.m_tdata = {}
	if self.m_nBigIndex == 1 then
		for k,v in pairs(tdata) do
			local sorttable = {}

			sorttable.id = v.id
			sorttable.way = v.way
			sorttable.item_id = v.item_id
			sorttable.reward = v.reward
			sorttable.type = v.type
			sorttable.position = v.position
			sorttable.quality = GDatatab_item["id_"..v.item_id].quality
			sorttable.collectStatus = 0
			for i = 1,#self.m_tHorses do
				local originItemId = CacheCenter:getOriginalMount(self.m_tHorses[i].id)
				if v.id == self.m_tHorses[i].id or v.item_id == originItemId then
					sorttable.id = self.m_tHorses[i].id
					if v.item_id == originItemId then 
						sorttable.quality = self.m_tHorses[i].basicInfo.quality
					end
					sorttable.collectStatus = self.m_tHorses[i].collectStatus or 0
					break 
				end
			end
			table.insert(self.m_tdata,sorttable)
		end
	elseif self.m_nBigIndex == 2 then
		for k ,v in pairs(tdata) do
			local sorttable = {}
			sorttable.id = v.id 
			sorttable.name = v.name
			sorttable.channel = v.channel
			sorttable.reward = v.reward
			sorttable.type = v.type
			sorttable.quality = v.quality
			sorttable.position = v.position
			sorttable.collectStatus = 0
			for i = 1,#self.m_tSkin do
				local nameCur = GDatatab_shape_skins["id_" .. self.m_tSkin[i].id].name
				local nameCompare = GDatatab_shape_skins["id_" .. v.id].name
				if v.id == self.m_tSkin[i].id or nameCompare == nameCur then
					sorttable.id = self.m_tSkin[i].id
					sorttable.quality = GDatatab_shape_skins["id_" .. self.m_tSkin[i].id].quality
					sorttable.collectStatus = self.m_tSkin[i].status or 0
					break 
				end
			end
			table.insert(self.m_tdata,sorttable)
		end
	elseif self.m_nBigIndex == 3 then
		for k,v in pairs(tdata) do
			local sorttable = {}
			sorttable.id = v.id
			sorttable.name = v.name
			sorttable.way = v.way
			sorttable.reward = v.reward
			sorttable.type = v.type
			sorttable.position = v.position
			sorttable.item_id = v.item_id
			sorttable.collectStatus = 0
			for i = 1,#self.m_tFoot do
				if v.id == self.m_tFoot[i].id then
					sorttable.collectStatus = self.m_tFoot[i].collectStatus or 0
					break 
				end
			end
			table.insert(self.m_tdata,sorttable)
		end
	end
	return self.m_tdata
end

function WndHandBook:showItem(data,index)
	-- body
	-- WZLog("显示item",Serialize(data))
	local conItem = GetElement(self.m_root,"conItem_WndHandBook",WZUIFreeListContainer)
	element = WZUIFreeListContainer:luaTo(conItem)
	conItem:removeAll()
	-- local tdata = data
    local nListNum = math.ceil(#data/4)

    for i = 1,nListNum do
    	local celElement, tNewObj = CellBookListItem:createElement()
        local tData = {}
        for j = 1, 4 do
            if data[(i - 1)*4 + j] then
                table.insert(tData, data[(i - 1)*4 + j])
            else
                break
            end
        end
        tNewObj:setCallBackFunc(self, self.onClickBook, self.addBookCell)
        tNewObj:setData(tData,index)
        celElement:setTag(self.m_nListTag)
        celElement = WZUIContainer:luaTo(celElement)
        celElement:setContentSize(GlobalMethod:CCSize(1044,260))
        celElement:setRelativeSize(GlobalMethod:CCSize(1,160/460))
        element:pushBack(celElement)

        self.m_nListTag = self.m_nListTag + 1
        element:getMoveElement():setPositionY(element:getMinPosition().y)
		conItem:pushBack(itemList)
	end

end

--@brief    将创建的卡牌的表添加到一个表中统一管理
function WndHandBook:addBookCell(tNewObj)
    -- body
    if self.m_tAllCardCell == nil then
        self.m_tAllCardCell = {}
    end


    table.insert(self.m_tAllCardCell, tNewObj)
end

--@brief    设置点中的卡牌高亮
function WndHandBook:setCardSel(tData)
    -- body
    WZLog("WndCard:setCardSel", type(self.m_tAllCardCell))
    if self.m_tAllCardCell == nil then return end

    for i = 1, #self.m_tAllCardCell do
        local tempData = self.m_tAllCardCell[i]:getData()
        -- WZLog("传回来得数据",Serialize(tempData),Serialize(tData))
        -- WZLog("WndCard:setCardSel", tempData.basicInfo.id, tData.basicInfo.id)
        if self.m_nBigIndex == 3 then
	        if tempData.id == tData.id then
	            self.m_tAllCardCell[i]:setHighLightVisible(true)
	            -- local channel = tData.basicInfo.channel
  	 			WndFastGetItems:show(tData.item_id)
	        else
	            self.m_tAllCardCell[i]:setHighLightVisible(false)
	        end
	    elseif self.m_nBigIndex == 2 then 
	    	if tempData.id == tData.id then
	            self.m_tAllCardCell[i]:setHighLightVisible(true)
	            -- local channel = tData.channel
	 			WndFastGetItems:show(tData.channel)
	        else
	            self.m_tAllCardCell[i]:setHighLightVisible(false)
	        end
	    elseif self.m_nBigIndex == 1 then
	    		if tempData.id == tData.id then
	            self.m_tAllCardCell[i]:setHighLightVisible(true)

	 			self:showMountsGet(tData)
	        else
	            self.m_tAllCardCell[i]:setHighLightVisible(false)
	        end
	    end
    end
end

--@brief 点击坐骑图鉴回调
function WndHandBook:showMountsGet(tData)
	-- body
	local data = self:getWayResult(tData)
	CellMounts.m_currentClick = self
	JudgeMoneyIsEnough(data.payId, data.payCnt,nil,nil,67, nil, nil, nil, nil, CellMounts.m_currentClick, CellMounts.m_currentClick.sureUseDiamondInstead)

end

--@brief    确认用钻石代替礼券购买坐骑
function WndHandBook:sureUseDiamondInstead()

end

-- 当前坐骑的获取信息
function WndHandBook:getWayResult(tData)
    local tItem,count = self:_getWay(tData) -- count = 1 表示赠送， 2表示等级领取，3 表示购买

    local data = {}
    -- 获取方式和结果
    if count == 1 then
        if tData.state == false then
            data = {type = count,isUnlock = true}
        else
            data = {type = count, isUnlock = false, str = LocalStrings.MOUNTS_GM_GET}
        end
    elseif count == 2 then
        data = self:_judgeLvGet(tItem,count,tData)
    elseif count == 3 then
        data = {type = count, isUnlock = false, payType = tItem.s,payId = tItem.t, payCnt = tItem.v}
    end

    return data
end

-- 坐骑获取方式
function WndHandBook:_getWay(tData)
    local tData = tData.way
    local tItem = {s = 0,t = 0,v = 0}
    local count = #tData
    local type = count
    if count == 1 then
        tItem.s = tData[1][2]      -- 赠送
    elseif count == 2 then
        tItem.s = tData[1][2]      -- 等级(1 玩家等级 5竞技等级 6 恩爱等级 7 公会等级 8排位等级)
        tItem.v = tData[2][2]
    else
        tItem.s = tData[1][2]       -- 购买方式
        tItem.t = tData[2][2]       -- 货币ID
        tItem.v = tData[3][2]       -- 货币的数量
    end
    return tItem,count
end

function WndHandBook:_judgeLvGet(tItem,count,tData)
    local lv1 = CacheCenter:getPlayerInfo().level
    local lv5 = CacheCenter:getPlayerInfo().tournamentLevel
    local lv6 = CacheCenter:getPlayerInfo().loveLevel
    local lv7 = CacheCenter:getPlayerInfo().guildLevel
    local lv8 = CacheCenter:getPlayerInfo().segmentLevel
    WZLog("---------------player cur level data-------------------",lv1,lv5,lv6,lv7,lv8)
    local data = {}
    local lvType = tItem.s
    local needLv = tItem.v
    local playerLv = {lv1,nil,nil,nil,lv5,lv6,lv7,lv8 }
    local desc = {LocalStrings.MOUNTS_LEVEL_GET,nil,nil,nil,LocalStrings.MOUNTS_LEVEL_GET5,LocalStrings.MOUNTS_LEVEL_GET6,LocalStrings.MOUNTS_LEVEL_GET7,LocalStrings.MOUNTS_LEVEL_GET8}

    if playerLv[lvType] >= needLv and tData.state == nil then
        data = {type = count,isUnlock = true }
    else
        -- 竞技场等级提示额外处理
        if lvType == 5 then needLv = GDatatab_integral["id_"..needLv].dan end
        data = {type = count,isUnlock = false, str = string.format(desc[lvType],needLv)}
    end
    return data
end

--@brief    点击卡牌回调
--@param    tCardData:卡牌的数据
function WndHandBook:onClickBook(tCell, tCardData)
    -- body
    --不用加声音，已经在cell中的点击函数中加了
    --设置卡牌的选中状态
    self:onContinue(tCell, tCardData)
end

function WndHandBook:onContinue(tCell, tCardData)
    local isGet = 0
	if self.m_nBigIndex == 1 then
    	for k,v in pairs(self.m_tHorses) do
    		local originItemId = CacheCenter:getOriginalMount(v.id)
    		if (tCardData.id == v.id or originItemId == tCardData.item_id) and v.collectStatus ~= nil then
    			isGet = v.collectStatus
    			break 
    		end
    	end
    elseif self.m_nBigIndex == 2 then
    	for k,v in pairs(self.m_tSkin) do
    		local nameCur = GDatatab_shape_skins["id_" .. tCardData.id].name
			local nameCompare = GDatatab_shape_skins["id_" .. v.id].name
    		if (tCardData.id == v.id or nameCur == nameCompare) and v.status ~= nil then
    			isGet = v.status
    			break 
    		end
    	end
    elseif self.m_nBigIndex == 3 then
    	for k,v in pairs(self.m_tFoot) do
    		if tCardData.id == v.id and v.collectStatus ~= nil then
    			isGet = v.collectStatus
    			break 
    		end
    	end
    end
	if isGet == 1 then
		WZLog("点击足迹发送的数据",self.m_nBigIndex,tCardData.id)
		ProtocolProcessorWndMounts:send_PLAYER_ReceiveCollectReward(self.m_nBigIndex,tCardData.id)
	else 
		self:setCardSel(tCardData)
	end
end

function WndHandBook:setBtnStatus(rtype,id)
	-- body
    for i = 1, #self.m_tAllCardCell do
	    local tempData = self.m_tAllCardCell[i]:getData()
	    if tempData.id == id then
	    	self.m_tAllCardCell[i]:updateStatus(rtype)
	    end
	end
end
--@brief 点击的大tab
function WndHandBook:onClickSmall(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	WZLog("WndHandBook:onClickSmall", tag, self.m_nCurIndex)
	if self.m_nCurIndex == tag then return end 
	self.m_nCurIndex = tag
	self.m_tAllCardCell = nil
	self:updateBtn()

end

--@brief 点击的小tab
function WndHandBook:onClickBig(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	WZLog("WndHandBook:onClickBig", tag, self.m_nBigIndex)
	if self.m_nBigIndex == tag then return end 

	self.m_nCurUIId = self.m_tTitleBtn.tabBtnId[tag]
	self.m_nBigIndex = tag
	self.m_nCurIndex = 1
	GetElement(self.m_root, "smallTitleItem_WndHandBook", WZUICheckBoxGroup):setCheckIndex(self.m_nCurIndex - 1)
	self.m_tAllCardCell = nil
	self:updateBtn()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndHandBook:setData(id)
	self.m_nCurUIId = id
	self:updateBtn()
end

--@brief 	初始化界面数据
function WndHandBook:_initUI()
	-- body
	local tTitleBtn = {}
	local tPosList = {{0.82,0.5},{0.5,0.5},{0.12,0.5}}
	tTitleBtn.tabBtnId = {28,118,141} --功能开放表id
    tTitleBtn.tabBtnSubId = {{1,2,3},{1,2,3,4},{1,2,3}} 
    tTitleBtn.tabBtnTitle = {LocalStrings.ASCENDING45,LocalStrings.PHANTOM_NEWTEXT22,LocalStrings.PARTNER_2}
    tTitleBtn.tabBtnSubTitle = {{LocalStrings.HANKBOOK1,LocalStrings.HANKBOOK2,LocalStrings.HANKBOOK3},
    						{LocalStrings.HANKBOOK1,LocalStrings.HANKBOOK7,LocalStrings.HANKBOOK2,LocalStrings.HANKBOOK3},
    						{LocalStrings.HANKBOOK4,LocalStrings.HANKBOOK5,LocalStrings.HANKBOOK6}}

	self.m_tTitleBtn = tTitleBtn

    local tempTabSubId = {}
    --设置小标题id
	if self.m_nCurUIId then
	    for i=1,#tTitleBtn.tabBtnId do
	    	if tTitleBtn.tabBtnId[i] == self.m_nCurUIId then
	    		self.m_nBigIndex = i
	    	end
	    end
	else
		self.m_nBigIndex = 1
	end
	GetElement(self.m_root, "bigTitleItem1_WndHandBook", WZUICheckBoxGroup):setCheckIndex(self.m_nBigIndex - 1)

	local tTempPos = {}
	local posIndex = 1
	for i = 1, #tTitleBtn.tabBtnId do
		local bigBtn = GetElement(self.m_root,"bigItem"..i.."_WndHandBook", WZUICheckBox)
		for j = 1, 2 do
			local txtTitle = GetElement(bigBtn,"txtTitle"..j.."_WndHandBook",WZUILabelTTF)
			txtTitle:setText(tTitleBtn.tabBtnTitle[i])
		end
		if CheckButtonOpen(tTitleBtn.tabBtnId[i], false) then 
			bigBtn:setVisible(true)
			table.insert(tTempPos, tPosList[posIndex])
			posIndex = posIndex + 1
		else
			bigBtn:setVisible(false)
		end
	end

	local posIndex = 1
	for i = #tTitleBtn.tabBtnId, 1 do
		local bigBtn = GetElement(self.m_root,"bigItem"..i.."_WndHandBook", WZUICheckBox)
		if CheckButtonOpen(tTitleBtn.tabBtnId[i], flase) then 
			bigBtn:setRelativePosition(GlobalMethod:ccp(tTempPos[posIndex][1], tTempPos[posIndex][2]))
			posIndex = posIndex + 1
		end
	end
end

--@brief 	更新图鉴小类型的红点
function WndHandBook:updateSmallItemReddot()
	-- body
	local tempTabSubId = self.m_tTitleBtn.tabBtnSubId[self.m_nBigIndex]
	local reddotState = {false, false, false, false}
	if self.m_nBigIndex == 1 then 
		reddotState = self:checkMountReddot()
	elseif self.m_nBigIndex == 2 then 
		reddotState = self:checkSkinReddot()
	elseif self.m_nBigIndex == 3 then 
		reddotState = self:checkFootReddot()
	end

	for i=1,#tempTabSubId do
		local smallBtn = GetElement(self.m_root,"smallItem"..i.."_WndHandBook",WZUICheckBox)
		local redDot1 = GetElement(smallBtn,"bookRedDot"..i.."_WndHandBook",WZUIImage)
		redDot1:setVisible(reddotState[i])
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------

function WndHandBook:_adaptLanguage_vn(  )
	for i = 1, 3 do
		local bigBtn = GetElement(self.m_root,"bigItem"..i.."_WndHandBook", WZUICheckBox)
		for j = 1, 2 do
			local txtTitle = GetElement(bigBtn,"txtTitle"..j.."_WndHandBook",WZUILabelTTF)
			txtTitle:setFontSize(18)
		end
	end
	for i=1,4 do
		local smallBtn = GetElement(self.m_root,"smallItem"..i.."_WndHandBook",WZUICheckBox)
		for j=1,2 do
			local smallTxt = GetElement(smallBtn,"txtTitle"..j.."_WndHandBook",WZUILabelTTF)
			smallTxt:setFontSize(18)
		end
	end
end

-------------------------------------语言适配End----------------------------------------