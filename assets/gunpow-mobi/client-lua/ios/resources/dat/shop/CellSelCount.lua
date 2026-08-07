--CellSelCount.lua
--@brief	CellSelCount的UI模块
--@date		2015-5-26
--@author	binshao
--@note		商城道具g购买的cell模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSelCount:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSelCount:onExit(element)
	self:_unInit()
end

-- 点击第1个checkbox
function CellSelCount:OnCheckType1(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.curInfo.index = self.curInfo.data[1].index
    self.curInfo.tag = self.curInfo.data[1].tag
    self:SetCurPropPrice(self.curInfo.data[1].price)
end

-- 点击第2个checkbox
function CellSelCount:OnCheckType2(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.curInfo.index = self.curInfo.data[2].index
    self.curInfo.tag = self.curInfo.data[2].tag
    self:SetCurPropPrice(self.curInfo.data[2].price)
end

-- 点击第3个checkbox
function CellSelCount:OnCheckType3(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.curInfo.index = self.curInfo.data[3].index
    self.curInfo.tag = self.curInfo.data[3].tag
    self:SetCurPropPrice(self.curInfo.data[3].price)
end

-- 获取当前商品的价格
function CellSelCount:GetCurPropPrice()
    return self.m_nCurPrice,self.curInfo.data[self.curInfo.tag].num,self.showDay
end

function CellSelCount:GetTData()
    return self.curData
end


-- 获取当前的购买商品信息
function CellSelCount:GetCurCellData()
    return self.curInfo
end

-- 设置当前商品的价格
function CellSelCount:SetCurPropPrice(price)
    self.m_nCurPrice = price
    self.m_tCallBackFunc[2](self.m_tCallBackFunc[1])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 更新
function CellSelCount:_update()
    self:_setPropIcon()
    self:_initAllCheckBoxIndex()
    self:_setPropInfo()
end

-- 设置商品的图标
function CellSelCount:_setPropIcon()
    local conIcon = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellSelCount"))
    local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement then
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setSZBg()
        local type = 2
        if self.curData.subType >= 4 and self.curData.subType <= 7 then type = 14 end
        tLuaObj:setCellGoodItem(self.curData.initData,type)
        conIcon:addChild(celElement)
    end
end

-- 设置cell上的商品购买信息
function CellSelCount:_setPropInfo()
    -- 解析商品的每个档次的信息
    local agingPrice = json.decode(self.curData.initData.agingPrice)
    self.curInfo.data = {}

    self.maxTag = 1
    for i = 0, 2 do
        local index = tostring(i)
        local data = agingPrice[index]
        if data then
            for k,v in pairs(data) do
                local tem = {}
                tem.num = tonumber(k)
                tem.price = tonumber(v)
                tem.index = i
                tem.tag = self.maxTag
                table.insert(self.curInfo.data,tem)
                self.maxTag = self.maxTag + 1
            end
        end
    end

    -- 限购商品需要特殊处理,限购商品的购买类型少于3时需要自动补充一个
    local limit = self.curData.initData.limitLeave
    if limit ~= -1 and #self.curInfo.data < 3 then
        local onePrice = self.curInfo.data[1].price/self.curInfo.data[1].num
        table.insert(self.curInfo.data,{num = limit, price = onePrice*limit,index = -1,tag = self.maxTag})
        self.maxTag = self.maxTag + 1
    end

    self:_initDownPrice()

    local curDiamond = CacheCenter:getMoneyList().blueDiamond
    local moneyIcon = GDatatab_item["id_"..self.curData.initData.moneyId].icon
    local descInfo = self.showDay and LocalStrings.DAY or LocalStrings.SHOP_IND
    local curData = self.curInfo.data

    for i = 1, #curData do
        local checkbox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkboxPrice"..i.."_CellSelCount"))
        checkbox:setVisible(true)

        local conDesc = WZUIContainer:luaTo(self.m_root:getChildElement("conDesc"..i.."_CellSelCount"))
        conDesc:setVisible(true)

        local moneyId = self.curData.initData.moneyId
        local imgIcon = WZUI9Image:luaTo(self.m_root:getChildElement("imgIcon"..i.."_CellSelCount"))
        imgIcon:setFile(moneyIcon)

        local txtPrice =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPrice"..i.."_CellSelCount"))
        txtPrice:setText(curData[i].price)

        -- 暂时修改
        local txtCount =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCount"..i.."_CellSelCount"))
        if CacheCenter:getGameParam().gameStatus == "1" then
            if  curData[i].num == -1 then
                txtCount:setText("1"..LocalStrings.SHOP_IND)
            else
                txtCount:setText(curData[i].num..descInfo)
            end
        else
            if  curData[i].num == -1 then
                txtCount:setText(LocalStrings.NOLIMIT)
            else
                txtCount:setText(curData[i].num..descInfo)
            end
        end

		--数量为0的格子隐藏
		if self.curData.initData.basicInfo.main_type ~= 5 and self.curData.initData.basicInfo.main_type ~= 31 and curData[i].num <= 0 then
			GetElement(self.m_root,"checkboxPrice"..i.."_CellSelCount",WZUICheckBox):setVisible(false)
			GetElement(self.m_root,"conDesc"..i.."_CellSelCount",WZUIContainer):setVisible(false)
		else
			GetElement(self.m_root,"checkboxPrice"..i.."_CellSelCount",WZUICheckBox):setVisible(true)
			GetElement(self.m_root,"conDesc"..i.."_CellSelCount",WZUIContainer):setVisible(true)
		end

		--限购数量剩1的时候，不要显示两个1的选择购买框
		if i == 2 and self.curData.initData.basicInfo.main_type ~= 5 and self.curData.initData.basicInfo.main_type ~= 31 and curData[i].num <= 1 then
			GetElement(self.m_root,"checkboxPrice"..i.."_CellSelCount",WZUICheckBox):setVisible(false)
			GetElement(self.m_root,"conDesc"..i.."_CellSelCount",WZUIContainer):setVisible(false)
		end

        if not self.showDay then
            local txtOff = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtOff"..i.."_CellSelCount"))
            if tonumber(self.curInfo.down[i]) > 0 and tonumber(self.curInfo.down[i]) < 10 then
                local conDis = GetElement(self.m_root, "conDiscount"..i.."_CellSelCount", WZUIContainer)
                conDis:setVisible(true)
                -- 商品的折扣 = 现价/原价*10
                -- 为了方便显示，在原来的折扣上再*10，如果此时小于1，则补一个0在前面
                -- 50 显示5， 38显示38， 1 显示01
                local lab = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
                lab:setVisible(true)
                local dis = math.floor(self.curInfo.down[i]*10)
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
                    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
                        lab:setText(100-dis)
                    else
                        lab:setText("0"..dis)
                    end
                end
                -- 小数点位置，当前折扣为小数时使用
                if math.ceil(dis/10) ~= dis/10 or dis < 10 then
                    local imgPoint = GetElement(self.m_root, "imgNumPoint"..i.."_CelllSelCount", WZUIImage)
                    imgPoint:setVisible(true)
                    if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
                        imgPoint:setVisible(false)
                    end
                end
            end
        end
    end
    self:SetCurPropPrice(curData[1].price)

    local txtName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtName:setText(self.curData.initData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[self.curData.initData.basicInfo.quality])
end

-- 设置选择商品类型的checkbox状态
function CellSelCount:_setCheckboxPriceIndex(t_index)
    for i = 1, 3 do
        local checkbox = WZUICheckBox:luaTo(self.m_root:getChildElement("checkboxPrice"..i.."_CellSelCount"))
        checkbox:setCheckIndex(t_index[i])
    end
end

-- 初始化checkbox 的状态，默认选择第一个
function CellSelCount:_initAllCheckBoxIndex()
    local group_index = {1,0,0 }
    self:_setCheckboxPriceIndex(group_index)
end

-------------------------------------私有方法模块End--------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellSelCount:_adaptLanguage_vn()
    WZLog("CellSelCount:_adaptLanguage_vn ")
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setDimensions(GlobalMethod:CCSize(120,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0714286))
    txtShopName:setFontSize(14)

    for i = 1, 3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setRelativePosition(GlobalMethod:ccp(0.647117,0.252306))
        labCnt:setScale(0.9)
        local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
        imgOff:setScale(0.9)
    end
end

function CellSelCount:_adaptLanguage_en()
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setDimensions(GlobalMethod:CCSize(130))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0714286))
    txtShopName:setFontSize(14)

    for i = 1, 3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
        labCnt:setScale(0.75)
        local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
        imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
        imgOff:setScale(0.8)
    end
end

function CellSelCount:_adaptLanguage_pt(  )
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setFontSize(12)
    txtShopName:setDimensions(GlobalMethod:CCSize(130,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.05))

    for i=1,3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
        labCnt:setScale(0.75)
        local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
        imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
        imgOff:setScale(0.8)

        GetElement(self.m_root,"txtCount"..i.."_CellSelCount",WZUILabelTTF):setFontSize(22)
    end

end

-- function CellSelCount:_adaptLanguage_th()
--     WZLog("CellSelPrice:_adaptLanguage_th ")
    
--     for i = 1, 3 do
--         local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
--         labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
--         labCnt:setScale(0.75)
--         local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
--         imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
--         imgOff:setScale(0.8)
--     end

--     GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF):setFontSize(16)
-- end

function CellSelCount:_adaptLanguage_tr()
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setFontSize(14)
    txtShopName:setDimensions(GlobalMethod:CCSize(120,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0803573))

    for i=1,3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setScale(0.5)
        labCnt:setRelativePosition(GlobalMethod:ccp(0.48,0.132894))
        local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
        imgOff:setScale(0.6)
        imgOff:setRelativePosition(GlobalMethod:ccp(0.76,0.433622))

        GetElement(self.m_root,"txtCount"..i.."_CellSelCount",WZUILabelTTF):setFontSize(22)
    end
end

function CellSelCount:_adaptLanguage_es(  )
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setFontSize(12)
    txtShopName:setDimensions(GlobalMethod:CCSize(130,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.05))

    for i=1,3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setRelativePosition(GlobalMethod:ccp(0.566842,0.185294))
        labCnt:setScale(0.75)
        local imgOff = GetElement(self.m_root, "imgOff"..i.."_CellSelCount", WZUIImage)
        imgOff:setRelativePosition(GlobalMethod:ccp(0.817093,0.464855))
        imgOff:setScale(0.8)

        GetElement(self.m_root,"txtCount"..i.."_CellSelCount",WZUILabelTTF):setFontSize(22)
    end
end

function CellSelCount:_adaptLanguage_th()
    local txtShopName = GetElement(self.m_root,"txtShopName_CellSelCount",WZUILabelTTF)
    txtShopName:setFontSize(14)
    txtShopName:setDimensions(GlobalMethod:CCSize(120,0))
    txtShopName:setRelativePosition(GlobalMethod:ccp(0.5,-0.0803573))

    for i = 1, 3 do
        local labCnt = GetElement(self.m_root, "labCnt"..i.."_CelllSelCount", WZUILabelAtlasFont)
        labCnt:setScale(0.75)
        local imgNumPoint = GetElement(self.m_root, "imgNumPoint"..i.."_CelllSelCount", WZUIImage)
        imgNumPoint:setRelativePosition(GlobalMethod:ccp(0.683234,0.165777))
    end
end
-------------------------------------语言适配End--------------------------------------------