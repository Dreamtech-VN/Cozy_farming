--WndShop.lua
--@brief    WndShop的UI模块
--@date     2016-12-3
--@author   binshao
--@note     商城

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndShop:onEnter(element)
    self.startTime = WZThread:getUTickCount()
    --WZLog("进入商城消耗时间0", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
    self.leftIndex = 1
    g_tTempItemForLaterShow = {}
    
    self.m_root = element
    
    self:_addTop()
    ChangeChatChannel(Chat_Channel_Shop)
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    CacheCenter:registerUpdateDecorationObserver(self)
    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
	WZLog("WndShop:onEnter", WndFastGetItems.m_nShopTipItemId)
    if isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        TeachGroup1:startGroup({26,3,self.m_root})
    end

    -- 初始化性别
    self.selSex = CacheCenter:getPlayerInfo().sex
    --WZLog("进入商城消耗时间1", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
end

--@brief    打开加载动画
function WndShop:onEnterTransitionDidFinish(element)
    --WZLog("进入商城消耗时间2", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
    -- 延迟创建人物角色动画
    DelayCallFunction(self._createRole, self, 0)

    -- 播放闪光动画
    self:playRoleAni()

    -- 初始化性别check
    self:initSexCheckBox()

    -- 身上的时装
    self.tryDress = self:getMyDress()

    --获取缓存的商品
    CacheCenter:getShopItems(self.getShopItemsListCallBack,self)

    -- 获取限购信息
    ProtocolProcessorWndShop:send_MALL_RequestUpdateMall( )
    --WZLog("进入商城消耗时间3", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")

	--配置是否显示赠送栏
	GetElement(self.m_root,"check6_WndShop",WZUICheckBox):setVisible(false)
	if CheckButtonShow(108) then 
		GetElement(self.m_root,"check6_WndShop",WZUICheckBox):setVisible(true)
	end

	--每日限购倒计时
	GetElement(self.m_root,"conLeft4_WndShop",WZUIContainer):enableSchedule("_countDown4",1)
    AdaptLanguage(self)
end

function WndShop:_jumpTab()
    local con = GetElement(self.m_root,"conRight_WndShop",WZUIContainer)
    con:disableSchedule()
    self:jumpTab1(self.jumpMain, self.jumpSub)
    self.jumpMain = nil
    self.jumpSub = nil
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndShop:onExit(element)
    g_bIsShowWndDressUp = true
    local pageOld = GetElement(self.m_root,"pageConOld_WndShop",WZUIPageContainer)
    pageOld:disableSchedule()

    CacheCenter:unregisterUpateDecorationObserver(self)
    GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndShop")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndShop")
    WndCurrentChat:showButtomChat()
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    self:_unInit()
end

function WndShop:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    --tcell:setTopData("ui/common/common_icon_sc.png",WndShop,WndShop.onTempClose,true,true,false,"WndShop",{goldType=6})
    tcell:setTopData("ui/common/common_icon_sc.png",WndShop,WndShop.onTempClose,true,true,false,"WndShop")
    self.m_tTop = tcell
end

-- 获得商城的所有商品列表
function WndShop:getShopItemsListCallBack(shopItemList)
    WZLog("WndShop:getShopItemsListCallBack---------",self.leftIndex,#shopItemList)
    self.propData = shopItemList
    self:InitShopList(shopItemList)
    -- 获取热销信息
    if self.jumpMain ~= nil and self.jumpSub ~= nil then
        local con = GetElement(self.m_root,"conRight_WndShop",WZUIContainer)
        con:enableSchedule("_jumpTab",0)
    else
        ProtocolProcessorWndShop:send_MALL_GetHotMallList( )
    end
end

-- 返回
function WndShop:onTempClose()
    WZLog("----------WndShop:onTempClose------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , self , true)
end

--弹框TIPS
function WndShop:onTouch(element,pt)
      local point = self.m_root:getParentElement():convertToNodeSpace(pt)
      local bPoint = WndItemInfo:checkPoint(pt)
      if not bPoint then  WndItemInfo:onCloseClick() end

	if self.m_tTop ~= nil then
		self.m_tTop.goldCellInfo.tcell:removeCreateTips()
	end
    -- if self.m_tTop ~= nil then
    --     self.m_tTop.goldCellInfo.tcell:removeCurrency57()
    -- end
end

-- 播放角色动画
function WndShop:playRoleAni()
    local conPlayer = self:_getConPlayer()
    if conPlayer and conPlayer:isCurrentAnimationDone() then
        conPlayer:play("wait0", true)
    end
end

-- 点击角色
function WndShop:onClickRole()
    local conPlayer = self:_getConPlayer()
    if conPlayer then conPlayer:play(g_tRoleAnitionName[2], false) end
    self.m_root:enableSchedule("judgeAniFinish",0)
end

-- 判断动画是否完成
function WndShop:judgeAniFinish()
    local conPlayer = self:_getConPlayer()
    if conPlayer then
        local isEnd = conPlayer:isCurrentAnimationDone()
        if isEnd == true then
            conPlayer:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

function WndShop:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
        WZLog("WndShop--------createloadingID",self.loadingId)
    end
end

function WndShop:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        WZLog("WndShop--------closeloadingID",self.loadingId)
        self.loadingId = nil
    end
end

---------------------------------------------------------------------------------------------

-- 点击购买弹框
--@param specialOffer是否是特价限购
function WndShop:showShopInterfaceByTag(itemId,buyType,shopId, specialOffer)
	WZLog("WndShop:showShopInterfaceByTag",shopId)
	if self.leftIndex == 6 then
    	WndPurchase:showBuyInterface(self.leftIndex,itemId,self,self.buyGoodsBackOK,nil,nil,self.propData,buyType,true,shopId)
	elseif specialOffer then
    	WndPurchase:showBuyInterface(self.leftIndex,itemId,self,self.buyGoodsBackOK,nil,nil,self.propData,buyType,nil,shopId, true)
	else
    	WndPurchase:showBuyInterface(self.leftIndex,itemId,self,self.buyGoodsBackOK,nil,nil,self.propData,buyType,nil,shopId)
	end
end

-- 更新玩家时装
function WndShop:UpdatePlayerDress(data)
    local conPlayer = self:_getConPlayer()
    if not conPlayer then return end

    local itemId = data.initData.shopItemId
    local subType = data.initData.basicInfo.sub_type + 1
    WZLog("-----------select shop------------",itemId,subType)
    local equipData = GetItemLocalData(itemId)
    -- 给玩家模型穿上对应的装备
    if subType == 1 then
        conPlayer:setHead(equipData.animation_index_code)
    elseif subType == 2 then
        conPlayer:setFace(equipData.animation_index_code)
    elseif subType == 3 then
        conPlayer:setBody(equipData.animation_index_code)
        conPlayer:setBodyRanSe(0)
    elseif subType == 4 then
        conPlayer:setWing(equipData.animation_index_code)
    end
	if self.leftIndex == 6 then
		if self.sendDress[subType] == nil then
    		self.sendDress[subType] = CopyTable(data)
		else
			if self.sendDress[subType].initData.shopItemId == itemId then
    			self.sendDress[subType] = nil
			else
    			self.sendDress[subType] = CopyTable(data)
			end
		end
	else
		if self.selectDress[subType] == nil then
    		self.selectDress[subType] = CopyTable(data)
		else
			if self.selectDress[subType].initData.shopItemId == itemId then
    			self.selectDress[subType] = nil
			else
    			self.selectDress[subType] = CopyTable(data)
			end
		end
	end
    conPlayer:play("wait0",true)
    self:_updatePropSelState()
	self:showTryWear()
	self:showSendWear()

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 获取玩家的节点
function WndShop:_getConPlayer()
	if self.m_root == nil then return end
    local conP = GetElement(self.m_root,"conRole_WndShop",WZUIContainer)
    local node = conP:getChildByTag(188)
    WZLog("----------get role node---------------",node)
    if node then
        local con = WZUIElement:luaTo(node)
        local conPlayer = con:getLuaObjectIndex()
        WZLog("----------get role obj---------------",conPlayer)
        return conPlayer
    end
    return nil
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------------------------------------------------------------

-- 推荐按键
function WndShop:onRandom()
    WZLog("--------------------recommend--------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.leftIndex == 5 then
        MsgBoxManager:showTipBox(LocalStrings.NOTRECOMMOEND)
        return
    end
    -- 获取玩家身上时装
    local tDress = CacheCenter:getDecorationList()
    local dressTab = {}

    -- 获取商品列表里面上架的商品分类处理
    for i = 1, 4 do
        local data = self.propDescData[2][i+1]
        for k,v in pairs(data) do
            if v.initData.isOnSale then
                local temp = CopyTable(v)
                local mainType ,subType = temp.mainType, temp.subType
                if dressTab[subType] == nil then dressTab[subType] = {} end
                table.insert(dressTab[subType],temp)
            end
        end
    end

    -- 每一种位置时装随机一件
    for i = 1, #dressTab do
        local index = math.random(#dressTab[i])
        self.selectDress[i] = CopyTable(dressTab[i][index])
    end
    self:_playerDressEquip()
    self:_updatePropSelState()
    self:playDressAni()
end

-- 保存形象按键
function WndShop:onSave(element)
    WZLog("--------------------save--------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local dressList = self.selectDress
	if self.leftIndex == 6 then
		dressList = self.sendDress
	end

	--没有试穿时装,提示返回
    if dressList ~= nil and dressList[1] == nil and dressList[2] == nil and dressList[3] == nil and dressList[4] == nil then
        if LocalStrings.SHOP_DRESS_NULL ~= nil then
            MsgBoxManager:showTipBox(LocalStrings.SHOP_DRESS_NULL)
        end
        return
    end

    -- 已经有的装备不放到购买表中
    local tDress = CacheCenter:getDecorationList()      --获取玩家装备列表
    local temp = {}
    for i=1,4 do
        if dressList[i] then
            local isAdd = true
            if self.selSex == CacheCenter:getPlayerInfo().sex then
                for j,k in ipairs(tDress) do
                    if dressList[i].initData.shopItemId == k.id then
                        isAdd = false
                        break
                    end
                end
            end
            -- 自己没有的时装假如购买列表
            if isAdd then
                table.insert(temp,dressList[i])
            end
        end
    end

    -- 拥有当前套装，如果列表为0，那么时装满了或者没有选择时装
    if #tDress > 0 and #temp == 0 then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DRESS_FULL)
        return
    end
    -- 存在购买时装，弹出购买窗口
    if #temp > 0 then 
		if self.leftIndex ~= 6 then
			WndBuy:showBuyInterface(temp,self.selSex,self.leftIndex) 
		else
			WndBuy:showBuyInterface(temp,self.selSex,tonumber(element:getTag())) 
		end
	end
end

--赠送
function WndShop:onSend(element)
    WZLog("--------------------save--------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local dressList = self.selectDress
	if self.leftIndex == 6 then
		dressList = self.sendDress
	end

	--没有试穿时装,提示返回
    if dressList ~= nil and dressList[1] == nil and dressList[2] == nil and dressList[3] == nil and dressList[4] == nil then
		if LocalStrings.SHOP_DRESS_NULL ~= nil then
        	MsgBoxManager:showTipBox(LocalStrings.SHOP_DRESS_NULL)
		end
        return
    end

    local temp = {}
    for i=1,4 do
        if dressList[i] then
            table.insert(temp,dressList[i])
        end
    end

    -- 拥有当前套装，如果列表为0，那么时装满了或者没有选择时装
    if #temp == 0 then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DRESS_FULL)
        return
    end
    -- 存在购买时装，弹出购买窗口
    if #temp > 0 then 
		if self.leftIndex ~= 6 then
			WndBuy:showBuyInterface(temp,self.selSex,self.leftIndex) 
		else
			WndBuy:showBuyInterface(temp,self.selSex,tonumber(element:getTag())) 
		end
	end
end

-- 初始人物形象
function WndShop:onInit()
    WZLog("--------------------onInit--------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self:onInit1()
end

function WndShop:onInit1()
    -- 选择时装清空，身上的时装还原
    self.selectDress = {}
    self.tryDress = self:getMyDress()

    -- 初始化根据当前选择的性别来初始化，如果当前的性别相同，则选择自己的时装
    if self.selSex == CacheCenter:getPlayerInfo().sex then
        self:_createRole()
    else
        self:_createRole(true,self.selSex,{})
    end
    self:_updatePropSelState()
    self:playDressAni()
end

function WndShop:_haveFlagAndHaveDays(data)
    local equip = CacheCenter:getPlayerItems()
    for k,v in pairs(equip) do
        if v.maintype == 5 and v.id == data.initData.shopItemId then
            return true,v.lastTime
        end
    end
    return false,0
end

-- 更新列表cell的试穿状态
function WndShop:_updatePropSelState()
	if self.leftIndex == 7 then return end
	if self.leftIndex == 8 then return end

    local subIndex = {1,self.dressTopIndex,self.propTopIndex,self.limitTopIndex,1,self.giveTopIndex }
    local cellData = {self.hotCellData,self.dressCellData,self.propCellData,self.limitCellData,self.CellData6,self.giveCellData,self.CellData6,self.CellData8}
    local propData = self.propDescData[self.leftIndex][subIndex[self.leftIndex]]
    if propData == nil then return end
    for i = 1, #propData do
        WZLog("ldfssasgskkh",cellData[self.leftIndex])
        --WZLog("ldfssasgskkh",cellData[self.leftIndex][i])
        --WZLog("ldfssasgskkh",cellData[self.leftIndex][i].tcell)
        if cellData[self.leftIndex][i] ~= nil and cellData[self.leftIndex][i].tcell ~= nil then
        local tcell = cellData[self.leftIndex][i].tcell
        WZLog("----------tcell--------------",tcell)
        if tcell then
            local state = self:_judgePropIsSel(propData[i])
            tcell:SetPropSelState(state)
        end
        end
    end
end

-- 设置当前界面限制个数道具的显示
function WndShop:_updataLimitCount()
    local cellData = {self.hotCellData,self.dressCellData,self.propCellData,self.limitCellData,self.CellData6,self.giveCellData,self.CellData6,self.CellData8}
    local curCellData = cellData[self.leftIndex]
    if curCellData then
        for i = 1, #curCellData do
            local tcell = curCellData[i].tcell
            tcell:SetLimitCount()
        end
    end
end

-- 玩家穿戴时装
function WndShop:_playerDressEquip()
    local conPlayer = self:_getConPlayer()
    if not conPlayer then return end
	local dressList = self.selectDress
	if self.leftIndex == 6 then
		dressList = self.sendDress
	elseif self.leftIndex == 1 then
		dressList = self.m_tNewGoods
	end

	--首先还原
	local head,face,body,wing
    local gameParam = CacheCenter:getGameParam()
    if tonumber(self.selSex) == 0 then
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultManFaceId or  4902)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultManBodyId or  4901)].animation_index_code end
    else
        if head == nil then head = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code end
        if face == nil then face = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code end
        if body == nil then body = GDatatab_item["id_"..(gameParam.defaultWomanBodyId or 4904)].animation_index_code end
    end
    conPlayer:setHead(head,0)
    conPlayer:setFace(face)
    conPlayer:setBody(body)

	if self.leftIndex ~= 6 then
    	-- 初始化根据当前选择的性别来初始化，如果当前的性别相同，则选择自己的时装
    	if self.selSex == CacheCenter:getPlayerInfo().sex then
    	    self:_createRole()
    	else
    	    self:_createRole(true,self.selSex,{})
    	end
	end

	--显示试穿列表时装
    conPlayer = self:_getConPlayer()
    for i = 1, 4 do
        if dressList[i] then
            local equipData = GetItemLocalData(dressList[i].initData.shopItemId)
            local ani = equipData.animation_index_code
			WZLog("显示试穿装备",Serialize(dressList[i].initData))
            if i == 1 then
                conPlayer:setHead(ani,0)
            elseif i == 2 then
                conPlayer:setFace(ani)
            elseif i == 3 then
                conPlayer:setBody(ani)
                conPlayer:setBodyRanSe(0)
            else
                conPlayer:setWing(ani)
            end
        end
    end
    conPlayer:play("wait0",true)
end

-- 保存方式购买时装后
function WndShop:afterBuyAndSaveImage(shopId)
    local curDress = CacheCenter:getDecorationList()
    local playerItemId = {}

    -- 根据当前实际时装列表，找到对应的穿戴时装列表
    for i = 1, 4 do
        if self.selectDress[i] then
            for k,v in pairs(curDress) do
                if self.selectDress[i].initData.shopItemId == v.id and v.isUse ~= true then
                    table.insert(playerItemId,v.playerItemId)
                    WZLog("---------------------shopid----playerItemid--------------",v.id,v.playerItemId)
                end
            end
        end
    end

    -- 发送穿戴协议
    local id = WZLuaVector_int_:create()
    for i = 1, #playerItemId do
        id:push(playerItemId[i])
    end
    ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)

    -- 初始化玩家形象，然后穿戴对应购买的时装
    self:_createRole()
    self:_playerDressEquip()

    -- 清空时装列表，还原按键状态
    self.selectDress = {}
    self.tryDress = self:getMyDress()
end

-- 播放穿戴动画
function WndShop:playDressAni()
    local conPlayer = self:_getConPlayer()
    if conPlayer then
        conPlayer:play("change", false)
        local spine = GetElement(self.m_root,"spineDress_WndShop",WZUISpine)
        spine:play("2",false)
    end
end

-- 用于判断时装是否可以购买(异性服装不能购买)
function WndShop:canBuyShopItem()
    if self.selSex ~= CacheCenter:getPlayerInfo().sex then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DESC4)
        return false
    end
    return true
end

-- 性别选择
function WndShop:onSelSex(element)
    WZLog("WndShop:onSelSex")
    self.startTime = WZThread:getUTickCount()
    local tag
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end

    if tag == self.selSex then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.selectDress = {}
	self.sendDress = {}
    self.selSex = tag
    if tag == CacheCenter:getPlayerInfo().sex then
        self:_createRole(true)
    else
        self:_createRole(true,tag,{})
    end
    --self:_changeCurDress()
    self:playDressAni()
    self.sexFlag = true
    self:createLoadingBox()
    ProtocolProcessorWndShop:send_MALL_GetMallListBySex (tag )
    WZLog("切换标签消耗时间", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
end

-- 初始化性别checkbox
function WndShop:initSexCheckBox()
    local sex = CacheCenter:getPlayerInfo().sex
    WZLog("---------------player sex-------------",sex)
    for i = 1, 2 do
        local check = GetElement(self.m_root,"checkbSex"..i.."_WndShop",WZUICheckBox)
        if sex == i-1 then
            check:setCheckIndex(1)
        else
            check:setCheckIndex(0)
        end
    end
end

--  更新右边checkbox的选中状态，改变top标题
function WndShop:_updateCheckBoxRightSel(tag)
    WZLog("--WndShop:_updateCheckBoxRightSel--",tag)
    local mainTitle = self:_getMainTitleData()

    -- 创建右边标题
    --for i = 1, #mainTitle do
    for i = 1, 6 do
        local state = i == tag and true or false
        local conSel = GetElement(self.m_root, "conCheck"..i.."_WndShop", WZUIContainer)
        conSel:setVisible(state)
    end
    local txtNor = GetElement(self.m_root, "txtCheck"..tag.."_WndShop", WZUILabelTTF)
    txtNor:setStrokeColor(GlobalMethod:ccc3(105,65,46))

    -- 创建上方标题
    --self:_createTopTitle()
end

-- 点击左边，选择大类型
function WndShop:onTempTab(element)
    local tag
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end

	--切换到标签一重新获取热销商品
	if type(element) ~= "number" and tonumber(element:getTag()) == 1 then
    	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    	GetElement(self.m_root, "leftCheckBox_WndShop", WZUICheckBoxGroup):setCheckIndex(0)
		ProtocolProcessorWndShop:send_MALL_GetHotMallList( )
		return
	end

    --local mySex = CacheCenter:getPlayerInfo().sex
    ---- 如果是切换性别
    --if self.newDataFlag == false and self.selSex ~= mySex then
    --    self.leftIndex = tag
    --    self:initSexCheckBox()
    --    self:onSelSex(mySex)
    --    return
    --end

    -- 是否点击的是当前栏
    if tag == self.leftIndex and self.newDataFlag == false then return end
    --从兑换栏切换到其它栏清空试穿时装
    if self.leftIndex == 5 then
        self:onInit1()
    end
    --从其它栏切换到兑换栏，清空时装
    if tag == 5 then
        self:onInit1()
    end

	if type(element) ~= "number" then
    	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	end

    WZLog("-------------cur left tag-------------",tag,self.leftIndex)
    self.leftIndex = tag
    self.newDataFlag = false

	self:_update5Cost()

	--更新左边内容
	self:_updateLeft(tag)

    GetElement(self.m_root, "leftCheckBox_WndShop", WZUICheckBoxGroup):setCheckIndex(self.leftIndex - 1)
    -- 右边 tab 容器
    for i = 1, 8 do
        local conR = GetElement(self.m_root,"conRight"..i.."_WndShop",WZUIContainer)
        conR:setVisible(i == tag)
        WZLog("设置当前显示容器",i,(i == tag))
    end

	if tag == 7 then
		GetElement(self.m_root,"conMain",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conMain",WZUIContainer):setVisible(true)
	end

    -- 创建商品列表
    self:_createRightShopList(tag)

	if tag == 1 then
		GetElement(self.m_root,"conRightBg",WZUIContainer):setVisible(false)
	elseif tag == 5 then
		GetElement(self.m_root,"conRightBg",WZUIContainer):setVisible(false)
	elseif tag == 8 then
		GetElement(self.m_root,"conRightBg",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conRightBg",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRightBg",WZUIContainer):setScaleY(1)
	end
end

--点击格子
function WndShop:onItemClick(tCell,tag,tData,conItem) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local other = {interface = 2,tcell = WndShop }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    WndItemInfo:showInfo(tCell.m_root,con,1,tData,true,nil,nil,other)
end

-- 选择时装上面类型
function WndShop:onTopDressTitle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTopDressTitle----------",tag)
    self.dressTopIndex = tag
    self:_createRightShopList(2)
end

-- 选择道具上面类型
function WndShop:onTopPropTitle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTopPropTitle----------",tag)
    self.propTopIndex = tag
    --GetElement(self.m_root,"checkboxRight3_WndShop",WZUICheckBoxGroup):setCheckIndex(self.propTopIndex - 1)
    self:_createRightShopList(3)
end

-- 选择限购上面类型
function WndShop:onTopLimitTitle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTopLimitTitle----------",tag)
    self.limitTopIndex = tag
    --GetElement(self.m_root,"checkboxRight4_WndShop",WZUICheckBoxGroup):setCheckIndex(self.limitTopIndex - 1)
    self:_createRightShopList(4)
end

-- 选择兑换上面类型
function WndShop:onTop5Title(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTop5Title----------",tag)
    self.top5Index = tag
    self:_createRightShopList(5)

	self:_update5Cost()
end

function WndShop:_update5Cost() 
	if self.m_root == nil then return end
	if self.leftIndex ~= 5 then return end
	local costIds
    if CacheCenter:getGameParam().isUseTicket == "0" then
        costIds = {57,71,72,78}
    else
        costIds = {57,71,71,78}
    end
	GetElement(self.m_root,"imgCost5",WZUIImage):setFile(GDatatab_item["id_"..costIds[self.top5Index]].icon)
	GetElement(self.m_root,"txtCost5",WZUILabelTTF):setText("X"..CacheCenter:getPlayerItemCountById(costIds[self.top5Index]))
end

-- 选择赠送上面类型
function WndShop:onTopGiveTitle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTopGiveTitle----------",tag)
    self.giveTopIndex = tag
    self:_createRightShopList(6)
end

-- 选择装备上面类型
function WndShop:onTop8Title(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 0
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    WZLog("WndShop:onTop8Title----------",tag)
    self.top8Index = tag
    self:_createRightShopList(8)

	--self:_update5Cost()
end

-- 初始化玩家装扮
-- changeSex 是否切换性别
-- sex 玩家性别性别
-- tEquip 玩家时装
function WndShop:_createRole(changeSex,sex,tEquip)
    WZLog("----------create role--------------changeSex",changeSex)
    WZLog("----------create role--------------sex",sex)
    WZLog("----------create role--------------tEquip",tEquip)
    local mySex = CacheCenter:getPlayerInfo().sex
    local sex = sex or mySex
    local tEquip = tEquip or CacheCenter:getEquipmentList()
    local conRole = GetElement(self.m_root,"conRole_WndShop",WZUIContainer)
    if changeSex then conRole:removeChildByTag(188,true) end

    local conPObj = self:_getConPlayer()
    local head,body = CacheCenter:getHeadAndBodyColor()
    if not conPObj then
        local conP
        if sex == mySex then
			WZLog("还原形象1")
            conP = CreatePlayerFigure(sex, tEquip,nil,nil,nil,nil,nil,nil,nil,nil,head,body,false)
        else
            conP = CreatePlayerFigure(sex, tEquip,nil,nil,nil,nil,nil,nil,nil,nil,0,0,false)
        end
		conP:getAnimNode():setScale(0.8)
        conRole:addChild(conP:getAnimNode(),5,188)
    else
        UpdatePlayerFigure(conPObj:getAnimNode(),tEquip,sex,head,body)
    end
    --WZLog("进入商城消耗时间n", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
end

-- 创建商品列表
function WndShop:_createShopItemList(tabCon,tabData,tabCell)
    --local moveEle= tabCon:getMoveElement()
    --self.m_nY = moveEle:getPositionY()
    --local poX = moveEle:getPositionX()
    tabCon:cleanTable()
    tabCon:stopMoveAction()
    tabCon:updateContainerSize()
    local pos = tabCon:getMinPosition()
    tabCon:getMoveElement():setPosition(pos)

    --WZLog("--------------_createShopItemList--------------",#self.oldProp,self.leftIndex,#self.oldProp,#tabData)
    if tabData == nil or #tabData == 0 then return end
    --WZLog("-------curRightData",self.leftIndex,self.dressTopIndex,Serialize(tabData))
	WZLog("快速购买ID:", type(WndFastGetItems.m_nShopTipItemId), WndFastGetItems.m_nShopTipItemId)
	local num = nil
    for i = 1, #tabData do
        local tag = i - 1
        local cell,tcell
        --if self.leftIndex == 3 or self.leftIndex == 4 or self.leftIndex == 5 then
        if self.leftIndex == 3 or self.leftIndex == 4 then
            cell,tcell = CellGoodsListBig:createElement()
        else
            cell,tcell = CellGoodsList:createElement()
            tcell:setLeftTabIndex(self.leftIndex)
        end
        cell:setTag(tag)
        tabCon:setCellElement(cell)
        tcell:setCellAllElement(tabData[i])
        self:saveCellData(tabCell,cell,tcell,i)

		--如果需要快速打开tips，移动列表到相应位置
		if WndFastGetItems.m_nShopTipItemId ~= nil and tabData[i].initData.basicInfo.id == WndFastGetItems.m_nShopTipItemId then
			WZLog("第几个物品", tag + 1)
			local moveEle= tabCon:getMoveElement()
			WZLog("高度",moveEle:getPositionY())
			num = tag + 1
		end

        -- 显示试穿
        if self:_judgePropIsSel(tabData[i]) then tcell:SetPropSelState(true) end
    end

	--需要快速打开tips时，移动列表到相应位置
	if num ~= nil and num > 6 then
		local moveEle= tabCon:getMoveElement()
    	local posY = tabCon:getMinPosition().y
		local moveRow = math.ceil((num - 6)/3)
   		moveEle:setPositionY(posY+193*moveRow)
	end

	--WZLog("保存位置",self.m_nY,poX)
	--moveEle:setPositionY(self.m_nY)
	--moveEle:setPositionX(poX)

    if self.leftIndex == 1 then
        if #self.oldProp > 0 then
            self:downLoadOldPic(self.oldProp)
        end
    end
end

--清除其他子标签内容
function WndShop:_cleanSubWin() 
	WZLog("WndShop:_cleanSubWin")
	GetElement(self.m_root, "tabHot_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root, "tabDress_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root, "tabProp_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root, "tabLimit_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root, "tabGive_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root, "tabCon6_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root,"conMain7",WZUIContainer):removeAllChildrenWithCleanup(true)
	GetElement(self.m_root, "tabCon8_WndShop", WZUITableContainer):cleanTable()
	GetElement(self.m_root,"conLuckyGift1",WZUIContainer):removeAllChildrenWithCleanup(true)
end

--添加右侧子标签栏
function WndShop:_addSubCheckBox() 
	--加载子check栏
	if self.leftIndex ~= 1 and WndShopSubCheck.m_root == nil then
		local win = WndShopSubCheck:createElement()
		GetElement(self.m_root,"conSubCheck",WZUIContainer):addChild(win)
	end
	if WndShopSubCheck.m_root ~= nil then
		WndShopSubCheck:_update() 
    	local checkboxRight = GetElement(WndShopSubCheck.m_root, "checkboxRight_WndShop", WZUICheckBoxGroup)
		local tag = self.leftIndex
    	if checkboxRight then
    	    WZLog("WndShop:_addSubCheckBox",self.m_nTag7, self.dressTopIndex, self.propTopIndex, self.limitTopIndex, self.giveTopIndex)
    	    if tag == 2 then
    	        checkboxRight:setCheckIndex(self.dressTopIndex - 1)
    	    elseif tag == 3 then
    	        checkboxRight:setCheckIndex(self.propTopIndex - 1)
    	    elseif tag == 4 then
    	        checkboxRight:setCheckIndex(self.limitTopIndex - 1)
    	    elseif tag == 5 then
    	        checkboxRight:setCheckIndex(self.top5Index - 1)
    	    elseif tag == 6 then
    	        checkboxRight:setCheckIndex(self.giveTopIndex - 1)
    	    elseif tag == 7 then
    	        checkboxRight:setCheckIndex(self.m_nTag7 - 1)
    	    elseif tag == 8 then
    	        checkboxRight:setCheckIndex(self.top8Index - 1)
    	    end
    	end
	end
end

-- 根据左边check的选择创建对应的tab
function WndShop:_createRightShopList(leftIndex)
    --WZLog("WndShop:_createRightShopList", Serialize(self.propDescData))
	self:_cleanSubWin()
	self:_addSubCheckBox()
	--标签七是抽奖，特殊处理
	if leftIndex == 7 then
		if WndShopLottery.m_root == nil then
			local win = WndShopLottery:createElement()
			GetElement(self.m_root,"conMain7",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"conMain7",WZUIContainer):addChild(win)
		end
		if WndLuckyGift.m_root == nil then
        	local element, tCell = WndLuckyGift:createElement()
        	element = WZUIContainer:luaTo(element)
			GetElement(self.m_root,"conLuckyGift1",WZUIContainer):addChild(element)
		end
		return
	end

    local tabRecommend = GetElement(self.m_root, "tabHot_WndShop", WZUITableContainer)
    local tabDress = GetElement(self.m_root, "tabDress_WndShop", WZUITableContainer)
    local tabProp = GetElement(self.m_root, "tabProp_WndShop", WZUITableContainer)
    local tabLimit = GetElement(self.m_root, "tabLimit_WndShop", WZUITableContainer)
    local tabGive = GetElement(self.m_root, "tabGive_WndShop", WZUITableContainer)
    local tabCon6 = GetElement(self.m_root, "tabCon6_WndShop", WZUITableContainer)
    local tabCon8 = GetElement(self.m_root, "tabCon8_WndShop", WZUITableContainer)
    local tabCon = {tabRecommend,tabDress,tabProp,tabLimit,tabGive,tabCon6,tabCon6,tabCon8}
    local cellData = {self.hotCellData,self.dressCellData,self.propCellData,self.limitCellData,self.CellData6,self.giveCellData,self.CellData6,self.CellData8}
    local tabData = {
        --self.propDescData[1][1],
        self.m_tHotItems,
        self.propDescData[2][self.dressTopIndex],
        self.propDescData[3][self.propTopIndex],
        self.propDescData[4][self.limitTopIndex],
        self.propDescData[5][self.top5Index],
        self.propDescData[6][self.giveTopIndex],
        self.propDescData[5][self.top7Index],
        self.propDescData[7][self.top8Index],
    }
    WZLog("-------_createRightShopList---------",leftIndex)

    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
    self:_createShopItemList(tabCon[leftIndex],tabData[leftIndex],cellData[leftIndex])

    if leftIndex == 2 and self.dressTopIndex ~= 4 and isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        WZLog("WndShop:_schedulePropList two-1")
        WindowManager:removeTeachShelterLayer()
        TeachGroup1:startGroup({26,4,self.m_root})
    elseif leftIndex == 2 and self.dressTopIndex == 4 and isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        local tabCon = GetElement(WndShop.m_root, "tabDress_WndShop", WZUITableContainer)
        local pos = tabCon:getMaxPosition()
        tabCon:getMoveElement():setPosition(pos)
        WindowManager:removeTeachShelterLayer()
        local shopList = {}
        local data = tabData[leftIndex]
        for i, v in pairs (data) do
            table.insert(shopList, v.shopItemId)
        end

        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local last = #data % 3
        local index = math.floor(math.random(1,last == 0 and 6 or 3 + last))
        local shopId = shopList[index]

        local isExist = false
        for i, v in pairs (CacheCenter:getDecorationList()) do
            WZLog("WndShop:_schedulePropList three",i,v.basicInfo.main_type,v.basicInfo.sub_type,v.basicInfo.name)
            if v.basicInfo.main_type == 5 and v.basicInfo.sub_type == 2 then
                isExist = true
                break
            end
        end

        WZLog("WndShop:_schedulePropList two-2", index, tostring(isExist), #data, "last", last, "shopId", shopId)
        ---[[
        if isExist then
            TeachGroup1:setTeachFinish(26, -1)
            TeachGroup1:removeTeach()
        else
            local img = GetElement(self.m_root,"imgTeach_WndShop",WZUIImage)
            if index == 1 then
                img:setRelativePositionLuaTo(0.159207,0.640538)
            elseif index == 2 then
                img:setRelativePositionLuaTo(0.443554,0.640538)
            elseif index == 3 then
                img:setRelativePositionLuaTo(0.740331,0.640538)
            elseif index == 4 then
                img:setRelativePositionLuaTo(0.159207,0.235121)
            elseif index == 5 then
                img:setRelativePositionLuaTo(0.443554,0.235121)
            elseif index == 6 then
                img:setRelativePositionLuaTo(0.740331,0.235121)
            end
            TeachGroup1:endTeachStep({26,4})
            TeachGroup1:startGroup({26,5,self.m_root})
        end
    elseif isEndTeach26 == true or teachStep26 == 0 or CacheCenter:getPlayerInfo().level ~= 10 then
        WZLog("WndShop:_schedulePropList two-3")
        WindowManager:removeTeachShelterLayer()
    end
end

-- 拷贝玩家身上的时装
function WndShop:getMyDress()
    local equip = CacheCenter:getEquipedDecorationList()
    local myEquip = {}
    for i = 1, #equip do
        local index = equip[i].subtype +1
        myEquip[index] = equip[i]
    end
    return myEquip
end

-- 改变默认服装
function WndShop:_changeCurDress(index)
    -- 默认时装ID
    local boyId = {4903,4902,4901,0}
    local girlId = {4906,4905,4904,0 }
    local dressId = boyId
    if self.selSex == 1 then dressId = girlId end

    local conPlayer = self:_getConPlayer()
    if not conPlayer then return end

    -- 更新玩家形象
    if index then
        local equipData = GetItemLocalData(dressId[index])
        if index == 1 then
            conPlayer:setHead(equipData.animation_index_code)
        elseif index == 2 then
            conPlayer:setFace(equipData.animation_index_code)
        elseif index == 3 then
            conPlayer:setBody(equipData.animation_index_code)
            conPlayer:setBodyRanSe(0)
        elseif index == 4 then
            conPlayer:setWing(0)
        end
    end

    -- 播放动画
    conPlayer:play("wait0",true)

    -- 更新试穿状态
    self:_updatePropSelState()
end

-- 监听时装改变
function WndShop:updateDecorationData()
    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    local conPlayer = self:_getConPlayer()
    local head,body = CacheCenter:getHeadAndBodyColor()
    if conPlayer then
        UpdatePlayerFigure(conPlayer:getAnimNode(),tEquip,sex,head,body)
    end
end

-- 监听玩家信息改变
function WndShop:updatePlayerInfoData()
    
end


function WndShop:getFileName(filename)
    local dest_filename = ""
    local fn_flag = string.find(filename, "\\")
    if fn_flag then
        dest_filename = string.match(filename, ".+\\([^\\]*%.%w+)$")
    end

    fn_flag = string.find(filename, "/")
    if fn_flag then
        dest_filename = string.match(filename, ".+/([^/]*%.%w+)$")
    end
    return dest_filename
end

--@brief    下载图片
function WndShop:downLoadOldPic(data)
    WZLog("------osTime1------------",os.time())
    self.oldExistCnt = 0
    local pageOld = GetElement(self.m_root,"pageConOld_WndShop",WZUIPageContainer)
    for i=1,#data do
        local downURL = data[i].initData.ad

        local photoName = self:getFileName(downURL)
        downURL = downURL:gsub("\n","")
        downURL = downURL:gsub("\r","")

        --如果文件存在，不下载，直接使用
        local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
        local bExist = WZFileUtil:isFileExist(path)
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        WZLog("判断文件是否存在",path,photoName)

        WZLog("--------downLoad--------------","i = ",i,"downURL = ",downURL,"bExist =",bExist)
        if bExist then
            data[i].imgPath = path
            self.oldExistCnt = self.oldExistCnt + 1
        elseif downURL ~= "" then
            if platForm == 3 then
                path = photoName
            end
            local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
            local downloadTask = WZHTTPFileLuaTask:create(i, downURL, path, self.downLoadOldPicCB, self)
            multiThread:addDownloadTaskInFront(downloadTask)
        end

        local cell,tcell = CellShopOld:createElement()
        pageOld:setPageElement(i-1,cell)
        tcell:setData(data[i])
        self:saveCellData(self.oldCellData,cell,tcell,i)
    end
    pageOld:setDefaultCenterPage(0)

    -- 如果图片都存在，那么注册定时器
    if self.oldExistCnt == #data and self.oldExistCnt >= 2 then
        WZLog("--------all old pic is Exist---------------")
        pageOld:enableSchedule("_updateOldPicIndex",3)
    end
end


--@brief    下载图片回调函数
function WndShop:downLoadOldPicCB(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("----------WndShop:downLoadOldPicCB------------",taskId)
    WZLog("WndAdvertising:downLoadPhotoBackFun",taskId,finish,path,failed)
    if self.m_root == nil then return end
    if finish then
        WZLog("path-------------",path)
        local tcell = self.oldCellData[taskId].tcell
        tcell:setOldImgPath(path)
        WZLog("------osTime------------","task = ",taskId,os.time())
    else
        --WZLog("taskId:::::::::::::::::::::::::::::::failed",taskId)
    end
    if finish or failed then
        self.oldExistCnt = self.oldExistCnt + 1
        if self.oldExistCnt == #self.oldProp then
            WZLog("oldDownFinish--------all old pic is Exist---------------")
            local pageOld = GetElement(self.m_root,"pageConOld_WndShop",WZUIPageContainer)
            pageOld:enableSchedule("_updateOldPicIndex",3)
        end
    end
end


--@brief    下载图片
function WndShop:downLoadNewPic(data)
    self.newExistCnt = 0
    local pageNew = GetElement(self.m_root,"pageConNew_WndShop",WZUIPageContainer)
    for i=1,#data do
        local downURL = data[i].initData.newad

        local photoName = self:getFileName(downURL)
        downURL = downURL:gsub("\n","")
        downURL = downURL:gsub("\r","")

        --如果文件存在，不下载，直接使用
        local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
        local bExist = WZFileUtil:isFileExist(path)
        local platForm =  WZUISystem:getInstance():getPlatformInfo()
        WZLog("判断文件是否存在",path,photoName)

        WZLog("--------downLoad--------------","i = ",i,"downURL = ",downURL,"bExist =",bExist)
        if bExist then
            data[i].imgPath = path
            self.newExistCnt = self.newExistCnt + 1
        elseif downURL ~= "" then
            if platForm == 3 then
                path = photoName
            end
            local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
            local downloadTask = WZHTTPFileLuaTask:create(i, downURL, path, self.downLoadNewPicCB, self)
            multiThread:addDownloadTaskInFront(downloadTask)
        end

        local cell,tcell = CellShopNew:createElement()
        pageNew:setPageElement(i-1,cell)
        tcell:setData(data[i])
        self:saveCellData(self.newCellData,cell,tcell,i)
    end
    pageNew:setDefaultCenterPage(0)
    -- 如果图片都存在，那么注册定时器
    if self.newExistCnt == #data then
        WZLog("--------all new pic is Exist---------------")
        pageNew:enableSchedule("_updateNewPicIndex",3)
    end
end


--@brief    下载图片回调函数
function WndShop:downLoadNewPicCB(taskId, path, totalSize, nowSize, finish, failed)
    WZLog("----------WndShop:downLoadNewPicCB------------",taskId)
    WZLog("WndAdvertising:downLoadPhotoBackFun",taskId,finish,path,failed)
    if self.m_root == nil then return end
    if finish then
        WZLog("path-------------",path)
        local tcell = self.newCellData[taskId].tcell
        tcell:setNewImgPath(path)
    else
        --WZLog("taskId:::::::::::::::::::::::::::::::failed",taskId)
    end

    if finish or failed then
        self.newExistCnt = self.newExistCnt + 1
        if self.newExistCnt == #self.newProp then
            WZLog("newDownFinish--------all new pic is Exist---------------")
            local pageNew = GetElement(self.m_root,"pageConNew_WndShop",WZUIPageContainer)
            pageNew:enableSchedule("_updateNewPicIndex",3)
        end
    end
end

-- 折扣商品动态图
function WndShop:_updateOldPicIndex()
    if #self.oldProp == 1 then return end
    local pageOld = GetElement(self.m_root,"pageConOld_WndShop",WZUIPageContainer)
    local oldIndex = pageOld:getCurrentPageIndex()
    if oldIndex >= #self.oldProp -1 then
        self.oldPageAdd = false
    elseif oldIndex <= 0 then
        self.oldPageAdd = true
    end

    if self.oldPageAdd then
        pageOld:moveToNextPage()
    else
        pageOld:moveToPrePage()
    end
end

--@brief    购买时装后，更新时装状态
function WndShop:_updateDressState()
    -- body
    if self.leftIndex ~= 2 and self.leftIndex ~= 5 then return end 

    local tabRecommend = GetElement(self.m_root, "tabHot_WndShop", WZUITableContainer)
    local tabDress = GetElement(self.m_root, "tabDress_WndShop", WZUITableContainer)
    local tabProp = GetElement(self.m_root, "tabProp_WndShop", WZUITableContainer)
    local tabLimit = GetElement(self.m_root, "tabLimit_WndShop", WZUITableContainer)
    local tabGive = GetElement(self.m_root, "tabGive_WndShop", WZUITableContainer)
    local tabCon = {tabRecommend,tabDress,tabProp,tabLimit,tabGive}

    local nTag = 0 
    local cellElement = tabCon[self.leftIndex]:getCellElement(nTag)
    while cellElement do
        cellElement = WZUIContainer:luaTo(cellElement)
        local cellItem = cellElement:getChildElement("__CellGoodsList")
        if cellItem then
            local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
            if cellObj then
                cellObj:setEquipState()
            end
        end
        nTag = nTag + 1
        cellElement = tabCon[self.leftIndex]:getCellElement(nTag)
    end
end






function WndShop:_updateLeft(tag) 
	for i=1,6 do
		GetElement(self.m_root,"conLeft"..i.."_WndShop",WZUIContainer):setVisible(false)
	end
	local showFun = {"showNewDiscount","showTryWear","showPromotion","_updateLeft4","showTryWear","showSendWear","",""}
	local showRole = {true,true,false,false,false,true,false,false}
	--显示左边
	if showFun[tag] ~= "" then
		WndShop[showFun[tag]](WndShop)
		GetElement(self.m_root,"conLeft"..tag.."_WndShop",WZUIContainer):setVisible(true)
	end
	--显示人物
	GetElement(self.m_root,"conLeftRoleBg",WZUIContainer):setVisible(showRole[tag])
	GetElement(self.m_root,"conLeftRole",WZUIContainer):setVisible(showRole[tag])
	GetElement(self.m_root,"conLeftMainBg",WZUIContainer):setVisible(showRole[tag])
	GetElement(self.m_root,"conLeftMainBg1",WZUIContainer):setVisible(showRole[tag])

	GetElement(self.m_root,"imgLeftMainBg1",WZUIImage):setVisible(showRole[tag])
	GetElement(self.m_root,"imgLeftMainBg2",WZUIImage):setVisible(tag==1)
	if self.leftIndex == 3 then
		GetElement(self.m_root,"conLeftMainBg",WZUIContainer):setVisible(true)
	end
	if self.leftIndex == 4 then
		GetElement(self.m_root,"conLeftMainBg",WZUIContainer):setVisible(true)
	end
end

function WndShop:onClickbuyBtn(tData) 
	WndShop:showShopInterfaceByTag(tData.basicInfo.id,3,tData.shopItemId)
end

-------------------------------------新品折扣模块Start----------------------------------------
--显示折扣新品
function WndShop:showNewDiscount() 
		WZLog("显示新品推荐")
		self.m_tNewGoods = {}    	--标签一新品推荐
		--self.m_tNewGoods[1] = self.propDescData[2][1][2]
		--self.m_tNewGoods[2] = self.propDescData[2][1][1]
		--self.m_tNewGoods[3] = self.propDescData[2][1][3]
		
	local cost1 = 0
	local cost2 = 0
	local discount = 10000

		--找出新品时装
		for i=1,#self.propDescData[2][1] do
			local tNew = self.propDescData[2][1][i].initData
			if tNew.isNew and (tNew.basicInfo.sex == self.selSex or tNew.basicInfo.sex == 2) and tNew.suit ~= 255 then
				local sub_type = self.propDescData[2][1][i].initData.basicInfo.sub_type
				self.m_tNewGoods[sub_type+1] = self.propDescData[2][1][i]
				--table.insert(self.m_tNewGoods, self.propDescData[2][1][i])
			end
		end

		local conLeft1 = GetElement(self.m_root,"conLeft1_WndShop",WZUIContainer)
        conLeft1:enableSchedule("_updateNewDiscount",1)

		local n = math.min(3, #self.m_tNewGoods)
		for i=1,n do
		   local celElement,tLuaObj = CellGoodItem:createElement()
           if celElement ~= nil then 
		    	celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellGoodItem(self.m_tNewGoods[i].initData, 4)
                tLuaObj:setItemClickFun(self, self.onItemClick)
                celElement:setTag(i)
				celElement:setScale(0.9)
				GetElement(self.m_root,"conItem1"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
				GetElement(self.m_root,"conItem1"..i,WZUIContainer):addChild(celElement)
           end

		   local tData = self.m_tNewGoods[i].initData
		   discount = tData.discount
			--self.m_nNewTime = tData.discountTime   	--新品推荐剩余秒数
			if tData.moneyId == 1 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				cost1 = cost1 + tData.floorPrice
				cost2 = cost2 + math.ceil(tData.floorPrice*discount/10000)
			elseif tData.moneyId == 70 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				
			end
		end

	--如果已经拥有全部新品时装，但是不是永久
	if cost1 == 0 then
		local n = math.min(3, #self.m_tNewGoods)
		for i=1,n do
		    local tData = self.m_tNewGoods[i].initData
		    discount = tData.discount
			--self.m_nNewTime = tData.discountTime   	--新品推荐剩余秒数
			local lastTime = CacheCenter:getPlayerItemCountById(tData.shopItemId)
			if tData.moneyId == 1 and lastTime ~= 0 and lastTime ~= -1 then
    			local agingPrice = json.decode(tData.agingPrice)
				WZLog("时装价格", tData.agingPrice)
				for k,v in pairs(agingPrice) do
					WZLog(Serialize(v))
					if v["-1"] ~= nil then
						cost1 = cost1 + tonumber(v["-1"])
						cost2 = cost2 + math.ceil(v["-1"]*discount/10000)
					end
				end
				--cost1 = cost1 + tData.floorPrice
				--cost2 = cost2 + math.ceil(tData.floorPrice*discount/10000)
			end
		end
	end

	GetElement(self.m_root,"imgGet1",WZUIImage):setVisible(false)
	GetElement(self.m_root,"conPrice1",WZUIContainer):setVisible(true)
	--已经拥有全部永久时装
	if cost1 == 0 then
		GetElement(self.m_root,"imgGet1",WZUIImage):setVisible(true)
		GetElement(self.m_root,"conPrice1",WZUIContainer):setVisible(false)
	end

	--设置红线长度
	if cost1 < 10 then
		GetElement(self.m_root,"imgLine1",WZUIImage):setScaleX(0.1)
	elseif cost1 < 100 then
		GetElement(self.m_root,"imgLine1",WZUIImage):setScaleX(0.2)
	elseif cost1 < 1000 then
		GetElement(self.m_root,"imgLine1",WZUIImage):setScaleX(0.3)
	elseif cost1 < 10000 then
		GetElement(self.m_root,"imgLine1",WZUIImage):setScaleX(0.4)
	end

	GetElement(self.m_root,"txtDiscount1",WZUIFreeTextBox):setShowText( string.format(LocalStrings.NEWSHOP11, tostring(cost1)) )
	GetElement(self.m_root,"txtDiscount2",WZUILabelTTF):setText(cost2)

    --商品折扣
    local conDis = GetElement(self.m_root, "conDiscount_WndShop", WZUIContainer)
	conDis:setVisible(false)
    if discount < 10000 then
        -- 折扣标签
        conDis:setVisible(true)

        -- 商品的折扣 = 现价/原价*10
        -- 为了方便显示，在原来的折扣上再*10，如果此时小于1，则补一个0在前面
        -- 50 显示5， 38显示38， 1 显示01
        local lab = GetElement(self.m_root, "labCnt_WndShop", WZUILabelAtlasFont)
        local dis = math.floor(discount/10000*10*10)
        if dis > 10 then
            -- 整数倍时比如10，20，30，等，就取1，2，3
            local desc = dis
            if math.ceil(dis/10) == dis/10 then desc = dis/10 end
            lab:setText(desc)
        else
            lab:setText("0"..dis)
        end

        -- 折扣不是整数，显示小数点
        local imgPoint = GetElement(self.m_root, "imgNumPoint_WndShop", WZUIImage)
		imgPoint:setVisible(false)
        if math.ceil(dis/10) ~= dis/10 or dis < 10 then
            imgPoint:setVisible(true)
        end
	end

	--人物形象
    self:_playerDressEquip()

    local conPlayer = self:_getConPlayer()
	if conPlayer ~= nil then
    	conPlayer:setWing(0)
	end
end

function WndShop:_updateNewDiscount() 
	WZLog("WndShop:_updateNewDiscount", self.m_nNewTime)
	if self.m_nNewTime == nil then 
		local conLeft1 = GetElement(self.m_root,"conLeft1_WndShop",WZUIContainer)
    	conLeft1:disableSchedule()
		GetElement(self.m_root,"txtDiscount1",WZUIFreeTextBox):setVisible(false)
		GetElement(self.m_root,"imgLine1",WZUIImage):setVisible(false)
		return	
	end

	self.m_nNewTime = self.m_nNewTime - 1
	local t = self.m_nNewTime

	local day = math.floor(t / 86400)
	t = t - day * 86400
	--if day < 10 then day = "0"..day end
	local h = math.floor(t / 3600)
	t = t - h * 3600
	if h < 10 then h = "0"..h end
	local m = math.floor(t / 60)
	t = t - m * 60
	if m < 10 then m = "0"..m end
	local s = t
	if s < 10 then s = "0"..s end

	local txtTime
	if day > 0 then
		txtTime = day..LocalStrings.DAY
	else
		txtTime = h..":"..m..":"..s
	end
	GetElement(self.m_root,"discountTime",WZUILabelTTF):setText(LocalStrings.NEWSHOP2..":"..txtTime)
	GetElement(self.m_root,"discountTime",WZUILabelTTF):setVisible(true)

		GetElement(self.m_root,"txtDiscount1",WZUIFreeTextBox):setVisible(true)
		GetElement(self.m_root,"imgLine1",WZUIImage):setVisible(true)
	if self.m_nNewTime <= 0 then
		local conLeft1 = GetElement(self.m_root,"conLeft1_WndShop",WZUIContainer)
    	conLeft1:disableSchedule()
		GetElement(self.m_root,"txtDiscount1",WZUIFreeTextBox):setVisible(false)
		GetElement(self.m_root,"imgLine1",WZUIImage):setVisible(false)
		GetElement(self.m_root,"discountTime",WZUILabelTTF):setVisible(false)
		ProtocolProcessorWndShop:send_MALL_GetMallList( )
	end
end

-- 购买新品折扣套装
function WndShop:onBuy1()
    WZLog("-------------------onBuy1-------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    -- 已经有的装备不放到购买表中
    local tDress = CacheCenter:getDecorationList()		--获取玩家装备列表
    local temp = {}
    for i=1,3 do
        if self.m_tNewGoods[i] then
            local isAdd = true
            if self.selSex == CacheCenter:getPlayerInfo().sex then
                for j,k in ipairs(tDress) do
                    if self.m_tNewGoods[i].initData.shopItemId == k.id then
                        isAdd = false
                        break
                    end
                end
            end
            -- 自己没有的时装假如购买列表
            if isAdd then
                table.insert(temp,self.m_tNewGoods[i])
            end
        end
    end

	--如果已经拥有全部新品，再计算无限期
    if #tDress > 0 and #temp == 0 then
    	for i=1,3 do
    	    if self.m_tNewGoods[i] then
    	        local isAdd = true
    	        if self.selSex == CacheCenter:getPlayerInfo().sex then
    	            for j,k in ipairs(tDress) do
    	                if self.m_tNewGoods[i].initData.shopItemId == k.id and k.lastTime == -1 then
    	                    isAdd = false
    	                    break
    	                end
    	            end
    	        end
    	        -- 自己没有的时装假如购买列表
    	        if isAdd then
    	            table.insert(temp,self.m_tNewGoods[i])
    	        end
    	    end
    	end
	end

    -- 拥有当前套装，如果列表为0，那么时装满了或者没有选择时装
    if #tDress > 0 and #temp == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NEWSHOP3)
        return
    end
    -- 存在购买时装，弹出购买窗口
    if #temp > 0 then WndBuy:showBuyInterface(temp,self.selSex,2) end
end

-------------------------------------新品折扣模块End----------------------------------------

-------------------------------------时装试穿模块Start----------------------------------------
function WndShop:showTryWear() 
	--更新时装显示
    self:_playerDressEquip()

	local cost1 = 0
	local cost2 = 0

	for i=1,4 do
	    local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
	     	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setItemClickFun(self, self.onItemClick)
            celElement:setTag(i)
	     	celElement:setScale(0.82)
	     	GetElement(self.m_root,"conItem2"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
	     	GetElement(self.m_root,"conItem2"..i,WZUIContainer):addChild(celElement)
        end

	    if self.selectDress[i] then
			local tData = self.selectDress[i].initData
            tLuaObj:setCellGoodItem(tData, 4)
			if tData.moneyId == 1 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				cost1 = cost1 + tData.floorPrice
			elseif tData.moneyId == 70 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				cost2 = cost2 + tData.floorPrice
			end
		else
            tLuaObj:removeAllChild()
		end
	end

	GetElement(self.m_root,"imgCost21",WZUIImage):setFile("")
	GetElement(self.m_root,"imgCost22",WZUIImage):setFile("")
	GetElement(self.m_root,"txtCost21",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtCost22",WZUILabelTTF):setText("")
	local index = 1
	if cost1 ~= 0 then
		GetElement(self.m_root,"imgCost2"..index,WZUIImage):setFile("shopitems/diamond.png")
		GetElement(self.m_root,"txtCost2"..index,WZUILabelTTF):setText(cost1)
		index = index + 1
	end
	if cost2 ~= 0 then
		GetElement(self.m_root,"imgCost2"..index,WZUIImage):setFile("shopitems/lizuan.png")
		GetElement(self.m_root,"txtCost2"..index,WZUILabelTTF):setText(cost2)
	end
end

function WndShop:onItemClick2(tCell,tag,tData,conItem) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.selectDress[tag] = nil
    self:_updatePropSelState()
	self:showTryWear()
end
-------------------------------------时装试穿模块End----------------------------------------

-------------------------------------促销道具模块Start----------------------------------------
function WndShop:showPromotion() 
		--self.m_tPromotion = {}    	--标签一新品推荐

		--找出促销时装
		--for j=1,6 do
		--	if self.propDescData[3][j] ~= nil then
		--	for i=1,#self.propDescData[3][j] do
		--		if self.propDescData[3][j][i].initData.isPromotion then
		--			table.insert(self.m_tPromotion, self.propDescData[3][j][i])
		--		end
		--	end
		--	end
		--end

	local tbCon = GetElement(self.m_root,"freecon3_WndShop",WZUIFreeListContainer)
	tbCon:removeAll()

	for i=1,#self.m_tPromotion do
		local celElement,tCell = CellShopPromotion:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tPromotion[i])
			tbCon:pushBack(celElement)
		end 
	end

	tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
end
-------------------------------------促销道具模块End----------------------------------------

-------------------------------------特价限购模块Start----------------------------------------
--@brief  更新cell界面元素
function WndShop:_updateLeft4()
	if self.m_root == nil then return end
	if self.leftIndex ~= 4 then return end
	GetElement(self.m_root,"conSellUp4_WndShop",WZUIContainer):setVisible(false)
	ProtocolProcessorWndShop:send_MALL_GetSpecialOffer( )
end

function WndShop:setLeft4Data( mallId, itemId, moneyId, oldPrice, newPrice, limitLeave)
	WZLog("WndShop:setLeft4Data", #mallId ,itemId[1], moneyId[1], oldPrice[1], newPrice[1], limitLeave[1])
	--local cellData = self.m_tItem4.initData
	if limitLeave[1] <= 0 then
		GetElement(self.m_root,"conSellUp4_WndShop",WZUIContainer):setVisible(true)
	end
	
	local cellData = {}
	cellData.id = mallId[1]
	cellData.shopItemId = itemId[1]
	cellData.basicInfo = GDatatab_item["id_"..itemId[1]]
	cellData.price = newPrice[1]
	cellData.moneyId = moneyId[1]
	self.m_tItem4 = cellData

    --商品名字描述
    local txtDescript = GetElement(self.m_root,"txtName4",WZUILabelTTF)
    txtDescript:setText(cellData.basicInfo.name)
    txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])
	WZLog("WndShop:setLeft4Data1", cellData.basicInfo.name)

	GetElement(self.m_root,"txtTip4",WZUILabelTTF):setText(LocalStrings.SHOP_GOODSSHEGN..":"..limitLeave[1]..LocalStrings.SHOP_IND)
	WZLog("WndShop:setLeft4Data2", cellData.basicInfo.name)

    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItem41_WndShop", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(cellData,5)
        conItemIcon:addChild(cell)
    end
	WZLog("WndShop:setLeft4Data3", cellData.basicInfo.name)

	--货币类型
	local icon = GDatatab_item["id_"..moneyId[1]].icon
	GetElement(self.m_root,"img1_CellShopPromotion",WZUIImage):setFile(icon)
	GetElement(self.m_root,"img2_CellShopPromotion",WZUIImage):setFile(icon)
	--商品价格
	GetElement(self.m_root,"txt41_WndShop",WZUILabelTTF):setText(oldPrice[1])
	GetElement(self.m_root,"txt42_WndShop",WZUILabelTTF):setText(newPrice[1])
	WZLog("WndShop:setLeft4Data4", cellData.basicInfo.name)

	--折扣
	local discount = math.ceil(newPrice[1]/oldPrice[1]*100)
	GetElement(self.m_root,"discount4",WZUILabelTTF):setText(string.format(LocalStrings.NEWSHOP17, tostring(100-discount), "%"))
	WZLog("WndShop:setLeft4Data5", cellData.basicInfo.name)
end

function WndShop:onClick4(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local price = self.m_tItem4.price
	local moneyId = self.m_tItem4.moneyId
	WZLog("WndShop:onClick41", price)
	if not JudgeMoneyIsEnough(moneyId,price, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onClick4Call) then 
		return 
	end

	WZLog("WndShop:onClick4", Serialize(self.m_tItem4))
    local count = WZLuaVector_int_:create()
    local mallId = WZLuaVector_int_:create()
	count:push(0)
	mallId:push(self.m_tItem4.id)
	ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, 1, 1)
end

function WndShop:onClick4Call() 
	WZLog("WndShop:onClick4Call")
    local count = WZLuaVector_int_:create()
    local mallId = WZLuaVector_int_:create()
	count:push(0)
	mallId:push(self.m_tItem4.id)
	ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, 1, 1)
end

function WndShop:onClick41(element) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--local price = self.m_tItem4.price
	--local moneyId = self.m_tItem4.moneyId
	--WZLog("WndShop:onClick41", moneyId, price)
	--if not JudgeMoneyIsEnough(moneyId, price) then
    --    return
    --end

    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
	self.m_tItem4.tBtnList = {}
   	WndItemInfo:showInfo(element,con,1,self.m_tItem4,false,nil,nil,other)
	WndItemInfo:setClickButtonCallback(self,self.buyLeft4)
end

function WndShop:buyLeft4(tag, tData) 
	WndShop:showShopInterfaceByTag(tData.basicInfo.id, 3, tData.shopItemId, true)
end

function WndShop:_countDown4() 
	if self.m_root == nil then return end
	if self.leftIndex ~= 4 then return end
	local t = os.date("*t", SystemTime:getServerTime())
	t.hour = 23
	t.min = 59
	t.sec = 59
	local left = os.time(t) - SystemTime:getServerTime()
	local h = math.floor(left/3600)
	left = left - 3600*h
	if h < 10 then h = "0"..h end
	local m = math.floor(left/60)
	left = left - 60*m
	if m < 10 then m = "0"..m end
	local s = left
	if s < 10 then s = "0"..s end
	GetElement(self.m_root,"txtLeftTime4",WZUILabelTTF):setText(LocalStrings.NEWSHOP25..h..":"..m..":"..s)
end
-------------------------------------特价限购模块End----------------------------------------

-------------------------------------赠送模块Start----------------------------------------
function WndShop:showSendWear() 
	if self.m_root == nil then return end
	if self.leftIndex ~= 6 then return end
	--更新时装显示
    self:_playerDressEquip()

	local cost1 = 0
	local cost2 = 0

	for i=1,4 do
	    local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
	     	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setItemClickFun(self, self.onItemClick)
            celElement:setTag(i)
	     	celElement:setScale(0.82)
	     	GetElement(self.m_root,"conItem6"..i,WZUIContainer):removeAllChildrenWithCleanup(true)
	     	GetElement(self.m_root,"conItem6"..i,WZUIContainer):addChild(celElement)
        end

	    if self.sendDress[i] then
			local tData = self.sendDress[i].initData
            tLuaObj:setCellGoodItem(tData, 4)
			if tData.moneyId == 1 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				cost1 = cost1 + tData.floorPrice
			elseif tData.moneyId == 70 and CacheCenter:getPlayerItemCountById(tData.shopItemId) == 0 then
				cost2 = cost2 + tData.floorPrice
			end
		else
            tLuaObj:removeAllChild()
		end
	end

	GetElement(self.m_root,"imgCost61",WZUIImage):setFile("")
	GetElement(self.m_root,"imgCost62",WZUIImage):setFile("")
	GetElement(self.m_root,"txtCost61",WZUILabelTTF):setText("")
	GetElement(self.m_root,"txtCost62",WZUILabelTTF):setText("")
	local index = 1
	if cost1 ~= 0 then
		GetElement(self.m_root,"imgCost6"..index,WZUIImage):setFile("shopitems/diamond.png")
		GetElement(self.m_root,"txtCost6"..index,WZUILabelTTF):setText(cost1)
		index = index + 1
	end
	if cost2 ~= 0 then
		GetElement(self.m_root,"imgCost6"..index,WZUIImage):setFile("shopitems/lizuan.png")
		GetElement(self.m_root,"txtCost6"..index,WZUILabelTTF):setText(cost2)
	end
end

function WndShop:onItemClick6(tCell,tag,tData,conItem) 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.sendDress[tag] = nil
    self:_updatePropSelState()
	self:showSendWear()
end
-------------------------------------赠送模块End----------------------------------------

-------------------------------------幸运礼盒Start----------------------------------------
function WndShop:onCheck7(element) 
	-- WZLog("WndShop:onCheck7", element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tag = 1
	if type(element) == "number" then
		tag = element
	else
		tag = tonumber(element:getTag())
	end
    
	local conMain7 = GetElement(self.m_root,"conMain7",WZUIContainer)
	local conLuckyGift = GetElement(self.m_root,"conLuckyGift",WZUIContainer)

	conLuckyGift:setVisible(false)
	conMain7:setVisible(false)
	conMain7:removeAllChildrenWithCleanup(true)

	self.m_nTag7 = tag
	
	if WndShopSubCheck.m_root ~= nil then
    	local checkboxRight = GetElement(WndShopSubCheck.m_root, "checkboxRight_WndShop", WZUICheckBoxGroup)
		checkboxRight:setCheckIndex(self.m_nTag7 - 1)
	end

    if CacheCenter:getGameParam().isUseTicket == "1" then
        if tag == 2 then
            tag = 1
        end
    end
	
	if tag == 1 then
		local win = WndShopLottery:createElement()
		conMain7:addChild(win)
		conMain7:setVisible(true)
		ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo(1)
	elseif tag == 2 then
		local win = WndShopLottery:createElement()
		conMain7:addChild(win)
		conMain7:setVisible(true)
		ProtocolProcessorWndShop:send_MALL_GetLuckDrawInfo(2)
	elseif tag == 3 then
		conLuckyGift:setVisible(true)
	end
end
-------------------------------------幸运礼盒End----------------------------------------

-------------------------------------装备Start----------------------------------------
function WndShop:access(tag, tData)
	WZLog("WndShop:access", tag, tData.basicInfo.id)
	WndFastGetItems:show(tData.basicInfo.id)
end
-------------------------------------装备End----------------------------------------
function WndShop:onRuleClick(element)
	if self.leftIndex ~= 5 then return end
    WndSingleMapDesc:showInterface(LocalStrings["SHOP_5_RULE"..self.top5Index])
end
function WndShop:onRuleClick(element)
    if self.leftIndex ~= 5 then return end
    WndSingleMapDesc:showInterface(LocalStrings["SHOP_5_RULE"..self.top5Index])
end

function WndShop:_adaptLanguage_en()
    WZLog("WndShop:_adaptLanguage_en")
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndShop",WZUILabelTTF)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndShop",WZUILabelTTF)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndShop",WZUILabelTTF)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndShop",WZUILabelTTF)
    local txtCheck6 = GetElement(self.m_root,"txtCheck6_WndShop",WZUILabelTTF)
    local txtCheck7 = GetElement(self.m_root,"txtCheck7_WndShop",WZUILabelTTF)
    local txtCheck8 = GetElement(self.m_root,"txtCheck8_WndShop",WZUILabelTTF)
    txtCheck1:setScale(0.62)
    txtCheck1:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck2:setScale(0.62)
    txtCheck2:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck3:setScale(0.62)
    txtCheck3:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck4:setScale(0.62)
    txtCheck4:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck5:setScale(0.62)
    txtCheck5:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck6:setScale(0.62)
    txtCheck6:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck7:setScale(0.62)
    txtCheck7:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck8:setScale(0.62)
    txtCheck8:setDimensions(GlobalMethod:CCSize(140,0))

    GetElement(self.m_root,"txtName41_WndShop",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80))
    GetElement(self.m_root,"txtName42_WndShop",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80))

    local txtName4 = GetElement(self.m_root,"txtName4",WZUILabelTTF)
    txtName4:setScale(0.7)
    txtName4:setRelativePosition(GlobalMethod:ccp(0.585308,0.765))
    txtName4:setDimensions(GlobalMethod:CCSize(260))

    local txtLeft1 = GetElement(self.m_root,"txtLeft1_WndShop",WZUILabelTTF)
    txtLeft1:setScale(0.7)
    txtLeft1:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft2 = GetElement(self.m_root,"txtLeft2_WndShop",WZUILabelTTF)
    txtLeft2:setScale(0.7)
    txtLeft2:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft6 = GetElement(self.m_root,"txtLeft6_WndShop",WZUILabelTTF)
    txtLeft6:setScale(0.7)
    txtLeft6:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndShop:_adaptLanguage_pt(  )
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndShop",WZUILabelTTF)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndShop",WZUILabelTTF)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndShop",WZUILabelTTF)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndShop",WZUILabelTTF)
    local txtCheck6 = GetElement(self.m_root,"txtCheck6_WndShop",WZUILabelTTF)
    local txtCheck7 = GetElement(self.m_root,"txtCheck7_WndShop",WZUILabelTTF)
    local txtCheck8 = GetElement(self.m_root,"txtCheck8_WndShop",WZUILabelTTF)
    txtCheck1:setScale(0.7)
    txtCheck1:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck2:setScale(0.7)
    txtCheck2:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck3:setScale(0.7)
    txtCheck3:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck4:setScale(0.7)
    txtCheck4:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck5:setScale(0.7)
    txtCheck5:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck6:setScale(0.7)
    txtCheck6:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck7:setScale(0.7)
    txtCheck7:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck8:setScale(0.7)
    txtCheck8:setDimensions(GlobalMethod:CCSize(140,0))

    GetElement(self.m_root,"txtLeft1_WndShop",WZUILabelTTF):setScale(0.8)
    local txtLeft2 = GetElement(self.m_root,"txtLeft2_WndShop",WZUILabelTTF)
    txtLeft2:setScale(0.7)
    txtLeft2:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft6 = GetElement(self.m_root,"txtLeft6_WndShop",WZUILabelTTF)
    txtLeft6:setScale(0.7)
    txtLeft6:setDimensions(GlobalMethod:CCSize(130,0))

    local txtName41 = GetElement(self.m_root,"txtName41_WndShop",WZUILabelTTF)
    txtName41:setScale(0.8)
    txtName41:setDimensions(GlobalMethod:CCSize(100))
    local txtName42 = GetElement(self.m_root,"txtName42_WndShop",WZUILabelTTF)
    txtName42:setScale(0.8)
    txtName42:setDimensions(GlobalMethod:CCSize(100))

    local txtName4 = GetElement(self.m_root,"txtName4",WZUILabelTTF)
    txtName4:setScale(0.7)
    txtName4:setRelativePosition(GlobalMethod:ccp(0.585308,0.765))
    txtName4:setDimensions(GlobalMethod:CCSize(260))
end

function WndShop:_adaptLanguage_vn()
    WZLog("WndShop:_adaptLanguage_vn")

    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndShop",WZUILabelTTF)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndShop",WZUILabelTTF)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndShop",WZUILabelTTF)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndShop",WZUILabelTTF)
    local txtCheck6 = GetElement(self.m_root,"txtCheck6_WndShop",WZUILabelTTF)
    local txtCheck7 = GetElement(self.m_root,"txtCheck7_WndShop",WZUILabelTTF)
    txtCheck1:setScale(0.8)
    txtCheck2:setScale(0.8)
    txtCheck3:setScale(0.8)
    txtCheck4:setScale(0.8)
    txtCheck5:setScale(0.8)
    txtCheck6:setScale(0.8)
    txtCheck7:setScale(0.8)

    GetElement(self.m_root,"txtLeft1_WndShop",WZUILabelTTF):setScale(0.55)
    
    GetElement(self.m_root,"txtName42_WndShop",WZUILabelTTF):setScale(0.6)

    -- local txtCheckRight4 = GetElement(self.m_root,"txtCheckRight4_1_WndShop",WZUILabelTTF)
    -- txtCheckRight4:setDimensions(GlobalMethod:CCSize(110,0))
    -- txtCheckRight4:setScale(0.9)
    -- local txtCheckRight4Sel = GetElement(self.m_root,"txtCheckRight4Sel_1_WndShop",WZUILabelTTF)
    -- txtCheckRight4Sel:setDimensions(GlobalMethod:CCSize(110,0))
    -- txtCheckRight4Sel:setScale(0.9)
end

function WndShop:_adaptLanguage_tr()
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndShop",WZUILabelTTF)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndShop",WZUILabelTTF)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndShop",WZUILabelTTF)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndShop",WZUILabelTTF)
    local txtCheck6 = GetElement(self.m_root,"txtCheck6_WndShop",WZUILabelTTF)
    local txtCheck7 = GetElement(self.m_root,"txtCheck7_WndShop",WZUILabelTTF)
    local txtCheck8 = GetElement(self.m_root,"txtCheck8_WndShop",WZUILabelTTF)
    txtCheck1:setScale(0.7)
    txtCheck1:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck2:setScale(0.7)
    txtCheck2:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck3:setScale(0.7)
    txtCheck3:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck4:setScale(0.7)
    txtCheck4:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck5:setScale(0.7)
    txtCheck5:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck6:setScale(0.7)
    txtCheck6:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck7:setScale(0.7)
    txtCheck7:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck8:setScale(0.7)
    txtCheck8:setDimensions(GlobalMethod:CCSize(140,0))

    GetElement(self.m_root,"txtLeft1_WndShop",WZUILabelTTF):setScale(0.7)
    local txtLeft2 = GetElement(self.m_root,"txtLeft2_WndShop",WZUILabelTTF)
    txtLeft2:setScale(0.7)
    txtLeft2:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft6 = GetElement(self.m_root,"txtLeft6_WndShop",WZUILabelTTF)
    txtLeft6:setScale(0.7)
    txtLeft6:setDimensions(GlobalMethod:CCSize(130,0))

    local txtName41 = GetElement(self.m_root,"txtName41_WndShop",WZUILabelTTF)
    txtName41:setScale(0.8)
    txtName41:setDimensions(GlobalMethod:CCSize(100))
    local txtName42 = GetElement(self.m_root,"txtName42_WndShop",WZUILabelTTF)
    txtName42:setScale(0.8)
    txtName42:setDimensions(GlobalMethod:CCSize(100))

    GetElement(self.m_root,"txtLeft6Btn1_WndShop",WZUILabelTTF):setScale(1)
    GetElement(self.m_root,"txtLeft6Btn2_WndShop",WZUILabelTTF):setScale(1)
end

function WndShop:_adaptLanguage_th(  )
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    txtCheck4:setScale(0.8)
    txtCheck4:setRelativePosition(GlobalMethod:ccp(0.471154,0.5))
end

function WndShop:_adaptLanguage_es(  )
    local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndShop",WZUILabelTTF)
    local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndShop",WZUILabelTTF)
    local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndShop",WZUILabelTTF)
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndShop",WZUILabelTTF)
    local txtCheck5 = GetElement(self.m_root,"txtCheck5_WndShop",WZUILabelTTF)
    local txtCheck6 = GetElement(self.m_root,"txtCheck6_WndShop",WZUILabelTTF)
    local txtCheck7 = GetElement(self.m_root,"txtCheck7_WndShop",WZUILabelTTF)
    local txtCheck8 = GetElement(self.m_root,"txtCheck8_WndShop",WZUILabelTTF)
    txtCheck1:setScale(0.7)
    txtCheck1:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck2:setScale(0.7)
    txtCheck2:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck3:setScale(0.7)
    txtCheck3:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck4:setScale(0.7)
    txtCheck4:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck5:setScale(0.7)
    txtCheck5:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck6:setScale(0.7)
    txtCheck6:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck7:setScale(0.7)
    txtCheck7:setDimensions(GlobalMethod:CCSize(140,0))
    txtCheck8:setScale(0.7)
    txtCheck8:setDimensions(GlobalMethod:CCSize(140,0))

    local txtLeft1 = GetElement(self.m_root,"txtLeft1_WndShop",WZUILabelTTF)
    txtLeft1:setScale(0.7)
    txtLeft1:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft2 = GetElement(self.m_root,"txtLeft2_WndShop",WZUILabelTTF)
    txtLeft2:setScale(0.7)
    txtLeft2:setDimensions(GlobalMethod:CCSize(130,0))
    local txtLeft6 = GetElement(self.m_root,"txtLeft6_WndShop",WZUILabelTTF)
    txtLeft6:setScale(0.7)
    txtLeft6:setDimensions(GlobalMethod:CCSize(130,0))

    local txtName41 = GetElement(self.m_root,"txtName41_WndShop",WZUILabelTTF)
    txtName41:setScale(0.8)
    txtName41:setDimensions(GlobalMethod:CCSize(100))
    local txtName42 = GetElement(self.m_root,"txtName42_WndShop",WZUILabelTTF)
    txtName42:setScale(0.8)
    txtName42:setDimensions(GlobalMethod:CCSize(100))

    GetElement(self.m_root,"txtLeftTime4",WZUILabelTTF):setScale(0.8)

    local txtName4 = GetElement(self.m_root,"txtName4",WZUILabelTTF)
    txtName4:setScale(0.7)
    txtName4:setRelativePosition(GlobalMethod:ccp(0.585308,0.765))
    txtName4:setDimensions(GlobalMethod:CCSize(260))
end
-------------------------------------语言适配End----------------------------------------
