--CellGoodsList.lua
--@brief	CellGoodsList的UI模块
--@date		2015-6-1
--@author	binshao

-------------------------------------公有方法模块--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGoodsList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGoodsList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellGoodsList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellGoodsList")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
	if self.cellData.isSuit == true then
    	self:_updateSuit()
	else
    	self:_update()
	end
    AdaptLanguage(self)
end

--@brief  设置cell中的内容
function CellGoodsList:setCellAllElement(tData)
	self.cellData =  tData
	--self:_update()
end

-- 点击回调
function CellGoodsList:onBtnClickGoods()
	if WndItemInfo.m_root ~= nil then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--WZLog("CellGoodsList:onBtnClickGoods",Serialize(self.cellData))
	--如果显示套装,商城试穿套装,返回
	if self.cellData.isSuit == true then
		for i=1,#self.cellData do
    		WndShop:UpdatePlayerDress(self.cellData[i])
		end
    	WndShop:playDressAni()
		return
	end

	--如果是坐骑,检查是否拥有坐骑
	if checkOwnMount(self.cellData.initData.basicInfo.id) then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
		return
	end

	self:event_SureBuyAgain()
end

function CellGoodsList:event_SureBuyAgain()
	if self.cellData.initData.basicInfo.main_type == 5 then
    	WndShop:UpdatePlayerDress(self.cellData)
    	WndShop:playDressAni()
	end

	self:initTipBtnInfo()

    TeachGroup1:endTeachStep({26,5})

    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
    if isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        TeachGroup1:startGroup({26,6,WndItemInfo.m_root})
    end
end

-- 购买，根据情况弹出购买界面
function CellGoodsList:onClickAllBtn(buyType)
    local cellData = self.cellData
    local tag = self.m_root:getTag()
    local itemId = cellData.initData.shopItemId
    if cellData.initData.limitLeave == -1 or cellData.initData.limitLeave > 0 then
		WZLog("购买商品k",cellData.initData.id)
        WndShop:showShopInterfaceByTag(itemId,buyType,cellData.initData.id)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED )
    end
end

-- 购买
function CellGoodsList:onBuy()
    WZLog("------------onBuy--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(3)
end

-- 赠送
function CellGoodsList:onGive()
    WZLog("------------onGive--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(1)
end

-- 试穿
function CellGoodsList:onTry()
    WZLog("------------onTry--------------")
    WndItemInfo:onCloseClick()
    WndShop:UpdatePlayerDress(self.cellData)
    WndShop:playDressAni()
end

-- 赠送，索要，购买
function CellGoodsList:onTips()
    local tipData = CopyTable(self.cellData.initData)
    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
end

function CellGoodsList:onClickbuyBtn()
    WZLog("------------onClickbuyBtn--------------")
    WndItemInfo:onCloseClick()
    self:onClickAllBtn(3)
end

function CellGoodsList:tab5Btn(tag)
	if tag == nil then return end
    self:onClickAllBtn(tag)
end

---- 当前物品是限购，那么tips只有一个购买按键
---- 当前是时装，如果性别相同，那么显示 索要，赠送, 根据自己是否拥有显示购买和续费
---- 当前是时装，如果性别不同，那么显示赠送按键
function CellGoodsList:initTipBtnInfo()
	WZLog("CellGoodsList:initTipBtnInfo", WndShop.leftIndex)
    local tipData = CopyTable(self.cellData.initData)
    local other = {interface = 2,tcell = self }
    local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)

	local showBtn = true
	if self.cellData.initData.moneyId == -1 then
		showBtn = false		
	end

	if WndShop.m_root ~= nil and WndShop.leftIndex == 6 then
    	if WndShop.selSex == CacheCenter:getPlayerInfo().sex then
			if CacheCenter:getPlayerItemCountById(tipData.basicInfo.id) == -1 then
				tipData.tBtnList = {LocalStrings.GIVE}
			else
				tipData.tBtnList = {LocalStrings.GIVE,LocalStrings.SHOP_BUY_DESC1}
			end
    	else
			tipData.tBtnList = {LocalStrings.GIVE}
    	end
    	WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
		WndItemInfo:setClickButtonCallback(self,self.tab5Btn)
	else
		if showBtn == false then
			tipData.tBtnList = {LocalStrings.GET_ACCESS}
		end
    	if WndShop.selSex == CacheCenter:getPlayerInfo().sex then
    		WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
			WndItemInfo:setClickButtonCallback(WndShop,WndShop.access)
    	else
    		WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,false,nil,nil,other)
    	end
	end
end

--@brief    设置显示的标签类型
function CellGoodsList:setLeftTabIndex(nIndex)
    -- body
    self.m_nLeftTabIndex = nIndex
    if not self.loadEnd then return end

    if self.m_nLeftTabIndex == 1 then
        local conTop = GetElement(self.m_root, "conTop_CellGoodsList", WZUIContainer)
        if conTop then
            conTop:setAbsContentSize(GlobalMethod:CCSize(210,226))
            conTop:setRelativeSize(GlobalMethod:CCSize(1,1))
            conTop:updateRelativeSize()
        end

        local img9BK = GetElement(self.m_root, "img9BK_CellGoodsList", WZUI9Image)
        if img9BK then
            img9BK:setFile("ui/common/common_scale9_di53.png")
        end
    end 
end
-------------------------------------私有方法模块--------------------------------------

--@brief  更新cell界面元素
--@brief  更新cell界面元素
function CellGoodsList:_update()
	if self.m_root == nil then return end
	local cellData = self.cellData.initData

    --商品名字描述
    local txtDescript = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDescript_CellGoodsList"))
    txtDescript:setText(cellData.basicInfo.name)
    txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])
	WZLog("CellGoodsList:_update", cellData.basicInfo.name)

    --商品图标
	local conItemIcon = GetElement(self.m_root, "conItemIcon_CellGoodsList", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(cellData,5)
        conItemIcon:addChild(cell)
    end
    self.goodItemCell = {cell = cell, tcell = tcell }

    -- 商品类型 折扣，热， 新 等
    WZLog("CellGoodsList.cellData.discount=",cellData.basicInfo.id,cellData.discount)
    if cellData.discount < 10000 then
        -- 折扣标签
        local conDis = GetElement(self.m_root, "conDiscount_CellGoodsList", WZUIContainer)
        conDis:setVisible(true)

        -- 商品的折扣 = 现价/原价*10
        -- 为了方便显示，在原来的折扣上再*10，如果此时小于1，则补一个0在前面
        -- 50 显示5， 38显示38， 1 显示01
        local lab = GetElement(self.m_root, "labCnt_CelllGoodsList", WZUILabelAtlasFont)
        local dis = math.floor(cellData.discount/10000*10*10)
        WZLog("CellGoodsList:update dis",dis)
        if dis > 10 then
            -- 整数倍时比如10，20，30，等，就取1，2，3
            local desc = dis
            if math.ceil(dis/10) == dis/10 then desc = dis/10 end
            if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                lab:setText(100-dis)
            else
                lab:setText(desc)
            end
        else
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                lab:setText(100-dis)
            else
                lab:setText("0"..dis)
            end
        end

        -- 折扣不是整数，显示小数点
        if math.ceil(dis/10) ~= dis/10 or dis < 10 then
            local imgPoint = GetElement(self.m_root, "imgNumPoint_CellGoodsList", WZUIImage)
            imgPoint:setVisible(true)
            if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                imgPoint:setVisible(false)
            end
        end
    else
        -- 显示热，新等商品
        local conNormal = GetElement(self.m_root, "conNormal_CellGoodsList", WZUIContainer)
        local imgTuijian = WZUIImage:luaTo(self.m_root:getChildElement("imgTuijian_CellGoodsList"))
        if cellData.isHot then
            conNormal:setVisible(true)
            imgTuijian:setFile("ui/common/common_icon_hot.png")
        elseif cellData.isNew then
            conNormal:setVisible(true)
            imgTuijian:setFile("ui/common/common_icon_new.png")
        else
            conNormal:setVisible(false)
        end
    end

    -- 是否限购
    local conLimit = GetElement(self.m_root, "conLimitTxt_CellGoodsList", WZUIContainer)
    local conNotLimit = GetElement(self.m_root, "conNotLimitTxt_CellGoodsList", WZUIContainer)
    local isLimit = cellData.limitLeave ~= -1 and true or false
    conLimit:setVisible(isLimit)
    conNotLimit:setVisible(not isLimit)
    
	WZLog("货币id", cellData.moneyId)
	if cellData.moneyId == -1 then
			GetElement(self.m_root, "text1", WZUILabelTTF):setVisible(true)	

    	    local imgMoney = GetElement(self.m_root,"imgMoneyNotLimit_CellGoodsList",WZUIImage)
    	    imgMoney:setVisible(false)

    	    --商品价格
    	    local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostNotLimit_CellGoodsList"))
    	    txtCost:setVisible(false)
	else
			GetElement(self.m_root, "text1", WZUILabelTTF):setVisible(false)	

    	local moneyIcon = GDatatab_item["id_"..cellData.moneyId].icon
    	if cellData.limitLeave ~= -1 then
    	    --限购个数
    	    local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
    	    txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,cellData.limitLeave))

    	    -- 售罄
    	    if cellData.limitLeave == 0 then
    	        local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
    	        conLimit:setVisible(true)
    	    end

    	    local imgMoney = GetElement(self.m_root,"imgMoneyLimit_CellGoodsList",WZUIImage)
    	    imgMoney:setFile(moneyIcon)

    	    --商品价格
    	    local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostLimit_CellGoodsList"))
    	    txtCost:setText(math.ceil(cellData.floorPrice*cellData.discount/10000))
    	else
    	    local imgMoney = GetElement(self.m_root,"imgMoneyNotLimit_CellGoodsList",WZUIImage)
    	    imgMoney:setFile(moneyIcon)

    	    --商品价格
    	    local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostNotLimit_CellGoodsList"))
    	    txtCost:setText(math.ceil(cellData.floorPrice*cellData.discount/10000))
    	end

	end

    -- 试穿状态
    local con = GetElement(self.m_root, "conSelFlag_CellGoodsList", WZUIContainer)
    con:setVisible(self.tryState)
	if cellData.basicInfo.main_type ~= 5 then
    	con:setVisible(false)
	end

    -- 选中状态
    local con = GetElement(self.m_root, "conSel_CellGoodsList", WZUIContainer)
    con:setVisible(self.selState)

    -- 限购
    local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
    if cellData.limitLeave ~= -1 then
        txtLimit:setVisible(true)
        txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,cellData.limitLeave))

        if cellData.limitLeave == 0 then
            local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
            conLimit:setVisible(true)
        end
    else
        txtLimit:setVisible(false)
    end

	if WndFastGetItems.m_nShopTipItemId ~= nil and cellData.basicInfo.id == WndFastGetItems.m_nShopTipItemId then
		WZLog("显示tips:", cellData.basicInfo.name)
		WndFastGetItems.m_nShopTipItemId = nil
    	local tipData = CopyTable(self.cellData.initData)
    	local other = {interface = 2,tcell = self }
    	local con = GetElement(WndShop.m_root,"conTips_WndShop",WZUIContainer)
    	WndItemInfo:showInfo(self.goodItemCell.tcell.m_root,con,1,tipData,true,nil,nil,other)
	end
end

function CellGoodsList:_updateSuit() 
	if self.m_root == nil then return end
	local cellData = self.cellData
	WZLog("CellGoodsList:_updateSuit", quality)

	local quality,moneyId,cost
	cost = 0
	for k,v in pairs(cellData) do
		if type(v) == "table" then
			quality = v.initData.basicInfo.quality
			moneyId = v.initData.moneyId
			cost = cost + v.initData.floorPrice
		end
	end

	GetElement(self.m_root, "text1", WZUILabelTTF):setVisible(false)	

    --商品名字描述
    local txtDescript = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDescript_CellGoodsList"))
    txtDescript:setText("")
    --txtDescript:setColor(QUALITYCOLOR[cellData.basicInfo.quality])
	
    --商品价格
	GetElement(self.m_root, "conNotLimitTxt_CellGoodsList", WZUIContainer):setVisible(true)
    local moneyIcon = GDatatab_item["id_"..moneyId].icon
    local imgMoney = GetElement(self.m_root,"imgMoneyNotLimit_CellGoodsList",WZUIImage)
    imgMoney:setFile(moneyIcon)

    local txtCost = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostNotLimit_CellGoodsList"))
    txtCost:setText(cost)
	
	--套装品质
	local qualityPic5 = {"ui/common/common_icon_lg.png",
					"ui/common/common_icon_lg.png",
					"ui/common/common_icon_ng.png",
					"ui/common/common_icon_zg.png",
					"ui/common/common_icon_hg.png"}
	GetElement(self.m_root,"RoleBg",WZUIImage):setFile(qualityPic5[quality+1])
	
	local tEquip = {}
	for i=1,#cellData do
		table.insert(tEquip,cellData[i].initData.basicInfo.id)
	end

	local conPlayerAni = self.m_root:getChildElement("conRole")

	local conPlayer
	local nSex = WndShop.selSex
	conPlayer = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, nil, nil, false)
	conPlayer:getAnimNode():setScale(0.55)

	local conRole = GetElement(self.m_root,"conRole",WZUIContainer)
	conRole:removeAllChildrenWithCleanup(true)
	conRole:addChild(conPlayer:getAnimNode())
end

--@brief 设置试穿图片的显示状态
function CellGoodsList:SetPropSelState(bVisible)
    self.tryState = bVisible
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conSelFlag_CellGoodsList", WZUIContainer)
    con:setVisible(bVisible)
	if WndShop.leftIndex == 1 then
    	con:setVisible(false)
	end
end

function CellGoodsList:setCellSel(bVisible)
    self.selState = bVisible
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conSel_CellGoodsList", WZUIContainer)
    con:setVisible(bVisible)
end

-- 设置显示限购次数
function CellGoodsList:SetLimitCount()
    if self.loadEnd == false then return end

    local data = self.cellData.initData
    local txtLimit = GetElement(self.m_root, "txtLimit_CellGoodsList", WZUILabelTTF)
    if data.limitLeave ~= -1 then
        txtLimit:setVisible(true)
        txtLimit:setText(string.format(LocalStrings.SHOP_LIMIT,data.limitLeave))
        WZLog("----------cell list tag-----------",data.limitLeave,self.m_root:getTag())

        if data.limitLeave == 0 then
            local conLimit = GetElement(self.m_root, "conSellUp_CellGoodsList", WZUIContainer)
            conLimit:setVisible(true)
        end
    else
        txtLimit:setVisible(false)
    end
end

--@brief    设置时效和装备状态
function CellGoodsList:setEquipState()
    -- body
    if not self.loadEnd then return end 
    if self.m_nLeftTabIndex == 1 then return end 
    --时装时效
    local flag, nTempDays = self:_haveFlag()
    local conTimeMark = GetElement(self.m_root, "conTimeMark_CellGoodsList", WZUIContainer)
    if conTimeMark then
        conTimeMark:setVisible(flag)
        if nTempDays ~= nil then
            local imgConorBK = GetElement(self.m_root, "imgConorBK_CellGoodsList", WZUIImage)
            imgConorBK:setVisible(true)
            if nTempDays == -1 then
                imgConorBK:setFile("ui/common/common_icon_yongjiu.png")
            else
                local sDaysFormat = [[<A IMG="ui/common_num/common_num_ts.png" Z="1" W="12" H="18" CHAR="0">%d</A><I Z="1" P="1">ui/common/common_icon_ts2.png</I>]]
                local ftxtDays = GetElement(self.m_root, "ftxtDays_CellGoodsList", WZUIFreeTextBox)
                ftxtDays:setVisible(true)
                ftxtDays:setShowText(string.format(sDaysFormat, nTempDays))
            end
        end
    end
    --装备状态
    flag = self:_bTakeOnFlag()
    local con = GetElement(self.m_root, "conHaveThis_CellGoodsList", WZUIContainer)
	if con ~= nil then
    	con:setVisible(flag)
	end
end

--@brief    判断是否拥有该时装
function CellGoodsList:_haveFlag()
    local equip = CacheCenter:getPlayerItems()
    for k,v in pairs(equip) do
        if self.cellData.initData ~= nil and v.maintype == 5 and v.id == self.cellData.initData.shopItemId then
            if v.lastTime == 0 then
                return false
            else
                local nDays = v.lastTime
                if v.lastTime ~= -1 then
                    nDays = math.ceil(v.lastTime/(3600 * 24))
                end
                return true, nDays
            end
        end
    end
    return false
end

--@brief    判断是否装备该时装
function CellGoodsList:_bTakeOnFlag()
    local equip = CacheCenter:getEquipedDecorationList()
    for k,v in pairs(equip) do
        if v.id == self.cellData.initData.shopItemId then
            return true
        end
    end
    return false
end


-------------------------语言适配Begin-------------------------
function CellGoodsList:_adaptLanguage_en()
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
    labCnt:setScale(0.75)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
    imgOff:setScale(0.8)
    
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setFontSize(18)

    local text1 = GetElement(self.m_root, "text1", WZUILabelTTF)
    text1:setScale(0.7)
    text1:setRelativePosition(GlobalMethod:ccp(0.5,0.457265))
    text1:setDimensions(GlobalMethod:CCSize(200))
end

function CellGoodsList:_adaptLanguage_th(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
    labCnt:setScale(0.75)
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
    imgOff:setScale(0.8)

    local txtLimit = GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF)
    txtLimit:setFontSize(18)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setFontSize(18)

    GetElement(self.m_root, "text1", WZUILabelTTF):setScale(0.7)
end

function CellGoodsList:_adaptLanguage_vn()
    WZLog("CellGoodsList:_adaptLanguage_vn")
    GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF):setFontSize(18)

    GetElement(self.m_root, "text1", WZUILabelTTF):setScale(0.7)
end

function CellGoodsList:_adaptLanguage_pt(  )
    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setScale(0.5)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.475804,0.132894))
    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setScale(0.6)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.759565,0.433622))

    
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setScale(0.65)
    txtDescript:setDimensions(GlobalMethod:CCSize(220))

    GetElement(self.m_root, "text1", WZUILabelTTF):setScale(0.7)
end

function CellGoodsList:_adaptLanguage_tr()
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF):setFontSize(18)

    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.528696,0.134659))
    labCnt:setScale(0.7)

    GetElement(self.m_root, "text1", WZUILabelTTF):setScale(0.6)
end

function CellGoodsList:_adaptLanguage_es(  )
    local txtDescript = GetElement(self.m_root,"txtDescript_CellGoodsList",WZUILabelTTF)
    txtDescript:setScale(0.65)
    txtDescript:setDimensions(GlobalMethod:CCSize(220))
    GetElement(self.m_root,"txtCostLimit_CellGoodsList",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtLimit_CellGoodsList",WZUILabelTTF):setFontSize(14)

    local labCnt = GetElement(self.m_root,"labCnt_CelllGoodsList",WZUILabelAtlasFont)
    labCnt:setRelativePosition(GlobalMethod:ccp(0.57,0.185294))
    labCnt:setScale(0.75)

    local imgOff = GetElement(self.m_root, "imgOff_CelllGoodsList", WZUIImage)
    imgOff:setRelativePosition(GlobalMethod:ccp(0.82,0.464855))
    imgOff:setScale(0.8)

    GetElement(self.m_root, "text1", WZUILabelTTF):setScale(0.7)
end
