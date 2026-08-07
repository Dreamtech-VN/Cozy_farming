--CellGoodItem.lua
--@brief	CellGoodItem的UI模块
--@date		2014/09/16
--@author	hugo.zheng
--@note		物品Item

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGoodItem:onEnter(element)
	self.m_root = element
	--WZUIButton:luaTo(self.m_root:getChildElement("btnClick_CellGoodItem")):setLocalInterval(1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGoodItem:onExit(element)
	self:_unInit() 
end

function CellGoodItem:onEvent(element)
	WZLog("CellGoodItem:onEvent")
    self.m_sTouchSelect = nil
    if WndMountStoneStong.m_root == nil then
    	if self.m_nType ~= 30 and self.m_nType ~= 31 and self.m_nType ~= 32 and self.m_nType ~= 33 then return end
    	if (self.m_nType == 30 or self.m_nType == 32 or self.m_nType == 33) and WndSell.m_root == nil then return end
    end
	WndItemInfo:_onCloseClick()
	self.onTouch = true
	self.m_root:enableSchedule("showTip",0.5)
end

function CellGoodItem:showTip()
	WZLog("CellGoodItem:showTip", Serialize(self.m_tItem))
    self.m_root:disableSchedule()
	if self.onTouch then
        if WndMountStoneStong.m_root == nil then
            if self.m_nType == 30 or self.m_nType == 32 or self.m_nType == 33 then 
                WndItemInfo:showInfo(self.m_root,WndSell.m_root,1,self.m_tItem,false)
            elseif self.m_nType == 31 then 
                if self.m_tItem.rootNode then 
                    WndItemInfo:showInfo(self.m_root,self.m_tItem.rootNode,1,self.m_tItem,false, nil, self.m_tItem.bShowAll)
                else
                    WndItemInfo:showInfo(self.m_root,WndHappyShake.m_root,1,self.m_tItem,false)
                end
            end
        else
            if self.m_tItem.maintype == 38 and (self.m_tItem.subtype >= 1 and self.m_tItem.subtype <= 8) then
                self.m_sTouchSelect = true
                WndTips:show(self.m_root,WndMountStoneStong.m_root,72,self.m_tItem, ccp(50,-110), false,nil, true, {bLongTouch = true, touchSwallow = true})
            else
                WndItemInfo:showInfo(self.m_root,WndMountStoneStong.m_root,1,self.m_tItem,false,nil,true)
            end
        end
	end
end

function CellGoodItem:setGoodItemCallFunc(func)
    self.m_sGoodCallFunc = func
end

--@brief	回调函数
function CellGoodItem:onBackClick(element)
    WZLog("********************* CellGoodItem:onBackClick ********************* ")
    self.m_root:disableSchedule()
	self.onTouch = false
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 5
	if self.m_tBackFun and isTeach ~= true then
		local tag = self.m_root:getTag()
        if self.m_nType == 4 or self.m_nType == 16 or self.m_nType == 10 or self.m_nType == 11 then 
            local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
            conItem = WZUIContainer:luaTo(conItem)
            if conItem:getChildByTag(999) then
                conItem:removeChildByTag(999,true)
            end
        end
        if not self.m_sTouchSelect then
    		self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tItem,conItem)
        end
	end
    if self.m_sGoodCallFunc then
        self.m_sGoodCallFunc(self, self.m_root:getTag(), self.m_tItem)
    end  
    if self.m_sReduceCallFunc then
        self.m_sReduceCallFunc(self.m_root:getTag(), self.m_tItem, self.m_sTxtReduceTitle, 1)
    end
    self.m_sTouchSelect = nil
end

--@brief 物品品质
function CellGoodItem:setQuality(quality)
	--WZLog("CellGoodItem:setQuality",quality)
    if quality == nil then
       quality = 5
    end

	if quality == 4 then self:_createChengAni() end

	local qualityPic2 = {"ui/common/common_icon_szlv.png",
					"ui/common/common_icon_szlan.png",
					"ui/common/common_icon_szzi.png",
					"ui/common/common_icon_szcheng.png",
					"ui/common/common_icon_szhong.png"}

    local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/common_scale9_hong.png","ui/common/common_scale9_cai.png"}
    qualityPic[0] = "ui/common/common_scale9_bai.png"

    local qualityPic16 = {"ui/common/common_scale9_lv.png",
        "ui/common/common_scale9_lan.png",
        "ui/common/common_scale9_zi.png",
        "ui/common/common_scale9_cheng.png",
        "ui/common/common_scale9_hong.png",
        "ui/common/common_scale9_cai.png"}
    qualityPic16[0] = "ui/common/common_scale9_bai.png"
    
    local btnImg1 = GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image)
    local btnImg2 = GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image)
    if btnImg1 and btnImg2 then
		btnImg1:setFile(qualityPic[quality])
		btnImg2:setFile("ui/common/common_scale9_beibaodi_sel.png")
    end

    if btnImg1 and btnImg2 and (self.m_nType == 1 or self.m_nType == 2 or self.m_nType == 13 or self.m_nType == 11) then
		btnImg1:setFile(qualityPic16[quality])
		btnImg2:setFile(qualityPic16[quality])
		btnImg1:setVisible(false)
		btnImg2:setFile("ui/common/common_scale9_beibaodi_sel.png")
	end

    if btnImg1 and btnImg2 and self.m_nType == 5 then
		btnImg1:setFile(g_tShopItemQuality[quality + 1])
		btnImg2:setFile(g_tShopItemQuality[quality + 1])
	end

    if btnImg1 and btnImg2 and self.m_nType == 20 then
		btnImg1:setVisible(false)
		btnImg2:setVisible(false)
	end

    if btnImg1 and btnImg2 and self.m_nType == 14 then
    	local conItem = GetElement(self.m_root, "conItem_CellGoodItem", WZUIContainer)
    	if self.m_imgBk2 == nil then
    	    self.m_imgBk2 = WZUIImage:create()
    	    self.m_imgBk2:setAnchorPoint(ccp(0.5,0.5))
    	    self.m_imgBk2:setRelativePosition(ccp(0.5,0.51))
    	    self.m_imgBk2:setUseOriginSize(true)
			self.m_imgBk2:setFile(qualityPic2[quality])
    	    conItem:addChild(self.m_imgBk2)
    	end
		btnImg1:setFile(qualityPic2[quality])
		btnImg1:setVisible(false)
   		btnImg2:setFile("ui/common/common_icon_szxz.png")
		btnImg2:setScale(1.03)
	end

    if btnImg1 and btnImg2 and self.m_nType == 16 then
		btnImg1:setFile(qualityPic16[quality])
		btnImg2:setFile(qualityPic16[quality])
	end

	if self.m_nType == 1 then
    	local conItem = GetElement(self.m_root, "conItem_CellGoodItem", WZUIContainer)
    	if self.m_imgBk2 == nil then
    	    self.m_imgBk2 = WZUIImage:create()
    	    self.m_imgBk2:setAnchorPoint(ccp(0.5,0.5))
    	    self.m_imgBk2:setRelativePosition(ccp(0.5,0.5))
    	    self.m_imgBk2:setUseOriginSize(true)
			self.m_imgBk2:setFile(qualityPic16[quality])
    	    conItem:addChild(self.m_imgBk2)
    	end
	end

	if self.m_nType == 2 or self.m_nType == 4 or self.m_nType == 16 or self.m_nType == 17 or self.m_nType == 13 or self.m_nType == 11 or self.m_nType == 31 or self.m_nType == 32 or self.m_nType == 33 then
    	local conItem = GetElement(self.m_root, "conItem_CellGoodItem", WZUIContainer)
    	if self.m_imgBk2 == nil then
    	    self.m_imgBk2 = WZUIImage:create()
    	    self.m_imgBk2:setAnchorPoint(ccp(0.5,0.5))
    	    self.m_imgBk2:setRelativePosition(ccp(0.5,0.5))
    	    self.m_imgBk2:setUseOriginSize(true)
			self.m_imgBk2:setFile(qualityPic[quality])
    	    
    	    conItem:addChild(self.m_imgBk2)
    	end
	end
end
--是否显示点击的光
function CellGoodItem:setTouchHeightVisible(visible)
    if not self.m_root then return end
    GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(visible)
end
--@brief    显示皮肤装备品质特效
function CellGoodItem:showPhantomequipmentAni(quality)
    WZLog("CellGoodItem:showPhantomequipmentAni", tostring(quality), tostring(self.m_tItem.basicInfo), tostring(self.m_tItem.basicInfo.main_type))
    if self.m_tItem and self.m_tItem.basicInfo and self.m_tItem.basicInfo.main_type == 37 then
        local animalName = {nil,nil,nil,nil,"zuoqi_hong","zuoqi_caise"}
        if self.m_tItem.basicInfo.quality == 5 or self.m_tItem.basicInfo.quality == 6 or self.m_tItem.basicInfo.quality == 4 then
            local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
            if conItem:getChildByTag(433) then
                conItem:removeChildByTag(433,true)
            end
            local spine = WZUISpine:create()
            spine:setTouchEnable(false)
            spine:setFileJson("ui/ui_icon_effect.json")
            spine:setFileAtlas("ui/ui_icon_effect.atlas")
            spine:play(animalName[self.m_tItem.basicInfo.quality], true) 
            spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            conItem:addChild(spine, 433, 433)
        end
    elseif self.m_tItem and self.m_tItem.basicInfo and self.m_tItem.basicInfo.main_type == 5 and quality then
        local animalName = {nil,nil,nil,nil,nil,"wait"}
        if quality == 6 then
            local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
            if self.m_nType and self.m_nType == 5 then 
                conItem = self.m_root:getChildElement("btnClick_CellGoodItem")
                if conItem then
                    conItem = WZUIButton:luaTo(conItem)
                end
            end
            if conItem:getChildByTag(433) then
                conItem:removeChildByTag(433,true)
            end
            local zOrder = 433 
            local spinePath = "ui/otherUI/ui_icon_effect01"
            local bIsExist = CheckEffectFile(spinePath)
            if bIsExist then 
                local spine = WZUISpine:create()
                spine:setTouchEnable(false)
                spine:setFileJson(spinePath .. ".json")
                spine:setFileAtlas(spinePath .. ".atlas")
                spine:play(animalName[quality], true) 
                if self.m_nType and self.m_nType == 5 then 
                    spine:setScale(1.3)
                    spine:setRelativePosition(GlobalMethod:ccp(0.488,0.6))
                    zOrder = 1
                else
                    spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
                end
                conItem:addChild(spine, zOrder, 433)
            end
        end
    end
end

--@brief    显示宝石品质特效
function CellGoodItem:showGemAni()
    if self.m_tItem and self.m_tItem.basicInfo and self.m_tItem.basicInfo.main_type == 6 then
        if self.m_tItem.basicInfo.quality == 5 then
            local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
            if conItem:getChildByTag(433) then
                conItem:removeChildByTag(433,true)
            end
            if self.m_nType == 15 then
                local data = {}
                data.path = "ui/otherUI/ui_icon_effect_yuan"
                data.play = "wait"
                data.loop = true
                data.zOrder = 433
                data.tag = 433
                createEffectSpine(conItem, data)
            else
                local data = {}
                data.path = "ui/ui_icon_effect"
                data.play = "hongkuang1"
                data.loop = true
                data.zOrder = 433
                data.tag = 433
                createEffectSpine(conItem, data)
            end
        end
    end
end

--去掉物品品质框然后底图70%
function CellGoodItem:clearItemQualityPic(is_quality, quality_score)
    is_quality = is_quality or nil
    quality_score = quality_score or nil
    local btnImg1 = GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image)
    local btnImg2 = GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image)
    if is_quality then
    else
        btnImg1:setVisible(false)
        btnImg2:setVisible(false)
    end
 
    local opacity = 178
    
    if quality_score then
        local qualityPic = {"ui/common/common_scale9_lv.png","ui/common/common_scale9_lan.png","ui/common/common_scale9_zi.png","ui/common/common_scale9_cheng.png"}
        opacity = 255
        local index = 1
        if quality_score >= 1 and quality_score <= 49 then
            index = 1
        elseif quality_score >= 50 and quality_score <= 79 then
            index = 2
        elseif quality_score >= 80 and quality_score <= 94 then
            index = 3
        elseif quality_score >= 95 and quality_score <= 100 then
            index = 4
        end
        self.m_imgBk2:setFile(qualityPic[index])
    end
    local btnImg_CellGoodItem = GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image)
    if btnImg_CellGoodItem then
        btnImg_CellGoodItem:setFile("ui/common/common_scale9_beibaodi.png")
        btnImg_CellGoodItem:setOpacity(opacity)
    end
    if self.m_imgBk2 and not quality_score then
        self.m_imgBk2:setVisible(false)
    end
end

--@brief	物品所有属性容器是否可见
function CellGoodItem:setConItemVisible(bShow)
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
		conItem:setVisible(bShow)
        if bShow == false then
            local img = WZUIImage:create()
            img:setFile("ui/common/commom_fuben_icon_di.png")
            img:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
            img:setUseOriginSize(true)
            self.m_root:addChild(img)
        end
	end
end

--@brief	物品数量
-- is_costom 是否自定义，目前只用于签到的物品
function CellGoodItem:setItemCount(count, is_costom)
--	WZLog("CellGoodItem:setItemCount")
	if self.m_root == nil then return end
	if count == nil then
       return
    end
    is_costom = is_costom or nil
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
	end
    if self.m_nType == 16 or self.m_nType == 17 or self.m_nType == 31 then
        if self.m_tItem.basicInfo then
            if self.m_tItem.basicInfo.main_type == 5 or self.m_tItem.basicInfo.main_type == 31 or (self.m_tItem.basicInfo.main_type==4 and self.m_tItem.basicInfo.time_limit~=-1) then 
                if count == -1 then
                    if self.m_imgCornerIcon == nil then
                        self.m_imgCornerIcon = WZUIImage:create()
                        self.m_imgCornerIcon:setAnchorPoint(ccp(0,1))
                        self.m_imgCornerIcon:setRelativePosition(ccp(-0.03,1.03))
                        self.m_imgCornerIcon:setUseOriginSize(true)
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                        conItem:addChild(self.m_imgCornerIcon, 2)
                    else
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                    end
                else
                    if self.m_imgCornerIcon == nil then
                        self.m_imgCornerIcon = WZUIImage:create()
                        self.m_imgCornerIcon:setAnchorPoint(ccp(0,1))
                        self.m_imgCornerIcon:setRelativePosition(ccp(-0.03,1.03))
                        self.m_imgCornerIcon:setUseOriginSize(true)
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_ts.png")
                        conItem:addChild(self.m_imgCornerIcon, 2)
                    else
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_ts.png")
                    end
                    -- self.m_imgCornerIcon:removeAllChildrenWithCleanup(true)
                    --天
                    local imgDay = WZUIImage:create()
                    imgDay:setRelativePosition(ccp(0.483333,0.784848))
                    imgDay:setFile("ui/common/common_icon_ts2.png")
                    imgDay:setUseOriginSize(true)
                    imgDay:setRotation(-45)
                    self.m_imgCornerIcon:addChild(imgDay,1)
                    --天数
                    local txtDayNum = WZUILabelAtlasFont:create()
                    txtDayNum:setRelativePosition(ccp(0.266667,0.569697))
                    txtDayNum:setCharMapFileName("ui/common_num/common_num_ts.png")
                    txtDayNum:setHeight(18)
                    txtDayNum:setWidth(12)
                    txtDayNum:setText(count)
                    txtDayNum:setRotation(-45)
                    txtDayNum:setUseOriginSize(true)
                    self.m_imgCornerIcon:addChild(txtDayNum,1)
                    if ProjConfig.LANGUAGE == "vn" then
                        txtDayNum:setRelativePosition(ccp(0.2,0.569697))
                        txtDayNum:setScale(0.83)
                    end
                end
                return
            end
        end
    end
    local strNum = count
    if count == -1 then
        strNum = LocalStrings.YJ
    end
	if self.m_txtCount == nil then
		self.m_txtCount = WZUILabelTTF:create()
		self.m_txtCount:setText(strNum)
        self.m_txtCount:setAlignment(kCCTextAlignmentRight)
        self.m_txtCount:setEnableStroke(true)
        self.m_txtCount:setBoldFont(true)
        self.m_txtCount:setColor(ccc3(255,236,193))
        self.m_txtCount:setFontSize(18)
        self.m_txtCount:setStrokeColor(ccc3(127,70,26))
        self.m_txtCount:setStrokeSize(4)
        if is_costom == true then
            self.m_txtCount:setAnchorPoint(ccp(0.5,0))
            self.m_txtCount:setRelativePosition(ccp(0.5,0))
        else
            self.m_txtCount:setAnchorPoint(ccp(1,0))
            self.m_txtCount:setRelativePosition(ccp(0.87,0.02))
        end
        conItem:addChild(self.m_txtCount,100,0)
    else
        self.m_txtCount:setText(strNum)
	end
    if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
        self.m_txtCount:setFontSize(20)
    elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
        self.m_txtCount:setFontSize(16) 
    end
end

--@brief	设置数字颜色
function CellGoodItem:setNumColor(color, strokeColor)
	if self.m_txtCount == nil then return end
    self.m_txtCount:setColor(color)
    self.m_txtCount:setStrokeColor(strokeColor)
end

--相对位置
function CellGoodItem:setNumRelativePosition()
    if self.m_txtCount then
        self.m_txtCount:setRelativePosition(ccp(0.9,0.02))
    end
end
--物品数量换成品质（目前用于坐骑灵石）
function CellGoodItem:setVisibleItemCount(count)
    if self.m_txtCount then
        count = count or 1
        self.m_txtCount:setText(count)
        self.m_txtCount:setAnchorPoint(ccp(0,0.5))
        self.m_txtCount:setRelativePosition(ccp(0.15,0.75))
    end
end

--@brief	物品图片
function CellGoodItem:setItemIcon(icon)
	if self.m_root == nil then return end
	if icon == nil then return end
    local conItem = self.m_root:getChildElement("btnClick_CellGoodItem")
	if conItem then
		conItem = WZUIButton:luaTo(conItem)
	end
	local order = 2
	if self.m_nType == 5 then order = 5 end
    if self.m_tItem.basicInfo ~= nil and (self.m_tItem.basicInfo.id >= 2001 and self.m_tItem.basicInfo.id <= 2154 or self.m_tItem.basicInfo.id >= 2161 and self.m_tItem.basicInfo.id <= 2162) then
        if self.m_imgItem == nil then
            self.m_imgItem = WZUISpine:create()
            self.m_imgItem:setZOrder(order)
            self.m_imgItem:setLoop(true)
            self.m_imgItem:setTouchEnable(false)
            self.m_imgItem:setTag(8)
            self.m_imgItem:setFileJson("ui/ui_qifu.json")
            self.m_imgItem:setFileAtlas("ui/ui_qifu.atlas")
            self.m_imgItem:setAnimationName(self.m_tItem.basicInfo.icon)
            conItem:addChild(self.m_imgItem)
            Teach:isStartTeach("CellGoodItem:setItemIcon")
        end
    else
        if self.m_imgItem == nil then
            self.m_imgItem = WZUIImage:create()
            self.m_imgItem:setZOrder(order)
            self.m_imgItem:setTag(8)
            if self.m_tItem.basicInfo ~= nil and ((self.m_tItem.basicInfo.main_type == 25 and (self.m_tItem.basicInfo.sub_type == 3 or self.m_tItem.basicInfo.sub_type == 4)) or self.m_tItem.basicInfo.main_type == 8) then 
                self.m_imgItem:setUseOriginSize(false)
            else
                self.m_imgItem:setUseOriginSize(true)
            end
            conItem:addChild(self.m_imgItem)
            Teach:isStartTeach("CellGoodItem:setItemIcon")
        end
        self.m_imgItem:setFile(icon)
    end
    if self.m_tItem.basicInfo ~= nil and ((self.m_tItem.basicInfo.id >= 1135 and self.m_tItem.basicInfo.id <= 1146) or (self.m_tItem.basicInfo.id >= 1548 and self.m_tItem.basicInfo.id <= 1550) or self.m_tItem.basicInfo.id == 161085) then
        self.m_imgItem:setScale(0.6)
    end
    if self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 19 then
        self.m_imgItem:setScale(0.4)
    end
    if self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 25 and (self.m_tItem.basicInfo.sub_type == 3 or self.m_tItem.basicInfo.sub_type == 4) then 
        self.m_imgItem:setScale(0.8)
    elseif self.m_tItem.basicInfo ~= nil and ((self.m_tItem.basicInfo.main_type == 25 and self.m_tItem.basicInfo.sub_type == 1) or (self.m_tItem.basicInfo.main_type == 9 and self.m_tItem.basicInfo.sub_type == 5)) then 
        self.m_imgItem:setScale(0.5)
        --self.m_imgItem:setRotation(45)
    elseif self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 38 and (self.m_tItem.basicInfo.sub_type >= 1 and self.m_tItem.basicInfo.sub_type <= 8) then
        self.m_imgItem:setScale(0.56)
    elseif self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 1 and self.m_tItem.basicInfo.sub_type == 59 then
        self.m_imgItem:setScale(0.65)
    elseif self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 8 then
        self.m_imgItem:setScale(0.85)
    elseif self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 9 and self.m_tItem.basicInfo.sub_type == 4 then
        self.m_imgItem:setScaleX(0.5)
    elseif self.m_tItem.basicInfo ~= nil and (self.m_tItem.basicInfo.id >= 160592 and self.m_tItem.basicInfo.id <= 160596) then 
        self.m_imgItem:setScale(0.2)
    end
	--语言适配
	local language = ProjConfig.LANGUAGE
    if ("pt" == language or "en" == language or "es" == language) and (icon == "shopitems/month_card_blue.png" or icon == "shopitems/month_card_gold.png" or icon == "shopitems/month_card_zhouka.png") then
        self.m_imgItem:setScale(0.8)
    end
    return self.m_imgItem
end

--@brief	物品名称
function CellGoodItem:setItemName(sName,nQuality)
	if self.m_root == nil then return end
    if sName == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then conItem = WZUIContainer:luaTo(conItem) end
   
    local coler = ccc3(255,255,255)
    if nQuality == 1 then
        coler = ccc3(131,255,0)
    elseif nQuality == 2 then
        coler = ccc3(0,176,240)
    elseif nQuality == 3 then
        coler = ccc3(255,0,174)
    elseif nQuality == 4 then
        coler = ccc3(255,204,0)
    else
        coler = ccc3(255,255,255)
    end
    
    sName = GetShortName(sName,12,9)
    if self.m_txtName == nil then
        self.m_txtName = WZUILabelTTF:create()
        self.m_txtName:setText(sName)
        self.m_txtName:setColor(coler)
        self.m_txtName:setFontSize(16)
        self.m_txtName:setAnchorPoint(ccp(0.5,1))
        --self.m_txtName:setAlignment(kCCTextAlignmentLeft)
        self.m_txtName:setRelativePosition(ccp(0.5,0.96))
        conItem:addChild(self.m_txtName)
    end
    return self.m_txtName
end

--@brief	设置物品的数量
--@paran   count:数量
function CellGoodItem:setItemNumber(count)
    if count == nil then return end
    if not self.m_tItem then return end

    if self.m_tItem.lastTime then
        self.m_tItem.lastTime = count
    end
    if self.m_tItem.lastNum then
        self.m_tItem.lastNum = count
    end
    if self.m_tItem.basicInfo then
        if self.m_tItem.basicInfo.use_type == 0 and self.m_tItem.lastNum then
            self.m_tItem.lastNum = count
        elseif self.m_tItem.basicInfo.use_type == 1 and self.m_tItem.lastTime then
            self.m_tItem.lastTime = count
        end
    end
    
    self:_showItemNum()
end

--@brief	是否穿上
function CellGoodItem:setWear(status)
    status = status or false
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	conItem = WZUIContainer:luaTo(conItem)
	if self.m_imgWear == nil then
		self.m_imgWear = WZUIImage:create()
		self.m_imgWear:setFile("ui/bag/common_icon_yizhuangbei.png")
		self.m_imgWear:setUseOriginSize(true)
		self.m_imgWear:setRelativePosition(ccp(0.31,0.63))
        conItem:addChild(self.m_imgWear,19)
        self.m_imgWear:setVisible(status)
    else
        self:showWear(status)
	end
end
--@brief	设置是否高亮格子
--@param _bIsShow:true/false
function CellGoodItem:setHightLightVisible(_bIsShow)
   if self.m_hightLight then
       self.m_hightLight:setVisible(_bIsShow)
    end
end
--@brief 开关锁的显示
--@param true/false
function CellGoodItem:showLock()
    self:_showLock()
end

--@brief    锁定cell
--@author   hyq
function CellGoodItem:lockCell()
	if self.m_root == nil then return end
    --不可触摸
    self.m_root:setTouchEnable(false)
end
--@brief    解锁cell
--@author   hyq
function CellGoodItem:unLockCell()
	if self.m_root == nil then return end
    self.m_root:setTouchEnable(true)
end
--@brief 开关选择图标的显示
--@param true/false
function CellGoodItem:showSeletedImg(bShow)
    if self.m_seletedImg then
        self.m_seletedImg:setVisible(bShow)
    end
end
--@brief 开关已装备的显示
--@param bShow:true/false
function CellGoodItem:showWear(bShow)
    if self.m_imgWear then
        self.m_imgWear:setVisible(bShow)
    end
end
--@brief 格子动画的显示
--@param bShow:true/false
function CellGoodItem:showAnimation(bShow)
    if self.m_animation then
        self.m_animation:setVisible(bShow)
    end
end
--@brief 获取锁的状态
function CellGoodItem:getLock()
    if self.m_lock then
        return self.m_lock:isVisible()
    end
    return nil
end
--@brief 获取已装备图标的状态
function CellGoodItem:getWearVisible()
    if self.m_imgWear then
        return self.m_imgWear:isVisible()
    end
    return nil
end
--@brief 获取选择的状态
function CellGoodItem:getSeleted()
    if self.m_seletedImg then
        return self.m_seletedImg:isVisible()
    end
    return nil
end

--@brief 清空格子的所有子节点
function CellGoodItem:removeAllChild()
	if self.m_root == nil then return end

	--删除物品图片，物品图片加在按钮上
    local btnItem = GetElement(self.m_root, "btnClick_CellGoodItem", WZUIButton)
	if btnItem:getChildByTag(8) then
		btnItem:removeChildByTag(8,true)
	end
    if btnItem:getChildByTag(433) then
        btnItem:removeChildByTag(433,true)
    end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    conItem = WZUIContainer:luaTo(conItem)
    conItem:removeAllChildrenWithCleanup(true)

	GetElement(self.m_root,"btnImg_CellGoodItem",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
	GetElement(self.m_root,"btnImg1_CellGoodItem",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
	GetElement(self.m_root,"btnImg2_CellGoodItem",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")

	if self.m_nType == 14 then
   		GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   		GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
	end

    self.m_tItem = nil
    self:_resetItem()
end

--@brief 返回大小
function CellGoodItem:getCellContentSize()
    local target = WZUIContainer:luaTo(self.m_root)
    local size = target:getAbsContentSize()
    
    size.width = size.width * target:getScaleX()
    size.height = size.height * target:getScaleY()
    return size
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellGoodItem:_update()
    if self.m_root == nil then return end
	--删除物品图片，物品图片加在按钮上
    local btnItem = GetElement(self.m_root, "btnClick_CellGoodItem", WZUIButton)
	if btnItem:getChildByTag(8) then
		btnItem:removeChildByTag(8,true)
	end
    if btnItem:getChildByTag(433) then
        btnItem:removeChildByTag(433,true)
    end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    conItem:removeAllChildrenWithCleanup(true)
    self:_resetItem()
    
	if self.m_tItem == nil then return end
    
	--显示物品图片
    local quality = nil 
    if self.m_tItem.basicInfo == nil then
        self:setQuality(self.m_tItem.quality)
        self:setItemIcon(self.m_tItem.icon)--显示物品图片
    else
        quality = self.m_tItem.basicInfo.quality
        --时装检查是否已进阶，已进阶的时装品质=5
        if self.m_tItem.basicInfo.main_type == 5 and (self.m_nType == 18 or self.m_nType == 5 or self.m_nType == 13) then 
            local _, _, bIsAdvance = GetDressAdvanceData(self.m_tItem.basicInfo.id)
            if bIsAdvance then 
                quality = self.m_tItem.basicInfo.quality + 1
            end
        end
        self:setQuality(quality)
        self:setItemIcon(self.m_tItem.basicInfo.icon)--显示物品图片
    end
    --显示调品框
    self:showGradeFrame()
    --皮肤装备品质特效
    self:showPhantomequipmentAni(quality)
    --宝石特效
    self:showGemAni()
    
    if self.m_nType == 1 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showLevel()
        self:_showStone()
        self:_setStart()
    elseif self.m_nType == 2 then
        if self.m_tItem.isUse == nil or self.m_tItem.isUse ~= true then
            self:_showRecommend()
        end
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showItemDate()
        self:_showWear() --装备图片
        self:_showItemNum()
		self:showLock()
		self:showExtraInfo()
		self:_addSidebarExperience()
    elseif self.m_nType == 3 then
        self:_showItemNum()
        self:_hightlight()
		self:showLock()
    elseif self.m_nType == 4 then
        self:_showItemNum()
		self:showLock()
		self:_addSidebarExperience()
    	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 5 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
    elseif self.m_nType == 6 then
        self:_showWear()
        if self.m_tItem.extraInfo ~= nil then
            if self.m_tItem.extraInfo.cardLevel > 0 then
                self:_kaLevel(self.m_tItem.extraInfo.cardLevel)
            end
        end
        self:_hightLightAnimation()
        self:_showSeletedImg()
    elseif self.m_nType == 7 then
        self:_showWear()
        self:_showSeletedImg()
    elseif self.m_nType == 8 then
        self:_showLevel()
        self:_showStone()
        self:_setStart()
    	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 9 then
        self:_showWear()
    elseif self.m_nType == 10 then
        self:_showItemNum()
		self:_showSell()
		self:showExtraInfo()
		self:_addSidebarExperience()
    	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 11 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 12 then
        self:_showItemNum()
		if self.m_tItem.own == true then
			self:_addSidebarOwn()
		end
        self:_showWear()
    	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	elseif self.m_nType == 13 then
		self:_addSidebarTime()
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	elseif self.m_nType == 14 then
		self:_addSidebarTime()
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 15 then
		self:_setBgImgVisible(false)
    elseif self.m_nType == 16 then
		if self.m_tItem.basicInfo then
            if self.m_tItem.basicInfo.main_type ~= 4 then
    			self:_showItemNum()
    		end
    		self:_addSidebarExperience()
        else
            self:_showItemNum()
        end
        GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 17 or self.m_nType == 31 then
        self:_showItemNum()
        GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 18 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		self:_addSidebarTime()
    elseif self.m_nType == 19 then
        self:_showItemNum()
        self:_showStone()
        GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 20 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
    elseif self.m_nType == 21 then
   		GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
        self:_showItemNum()
    elseif self.m_nType == 30 then
        self:_showItemNum()
		self:_showSell()
		self:showExtraInfo()
		self:_addSidebarExperience()
    	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 32 then
        --暂时用于WndSell回收-坐骑灵石
        GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showLevel()
        self:_showStone()
        self:_setStart()
        self:_showSell() 
        if self.m_tItem and self.m_tItem.maintype and self.m_tItem.subtype and self.m_tItem.maintype == 38 and self.m_tItem.subtype >= 9 and self.m_tItem.subtype <= 13 and self.m_tItem.extraInfo then
            --WZLog("CellGoodItem:_update spriteStoneQuality =", self.m_tItem.extraInfo.spriteStoneQuality)
            self:setVisibleItemCount(self.m_tItem.extraInfo.spriteStoneQuality)
            self:clearItemQualityPic(nil, self.m_tItem.extraInfo.spriteStoneQuality)
        end    
    elseif self.m_nType == 33 then
        --暂时用于WndSell回收-灵石之源
        if self.m_tItem.isUse == nil or self.m_tItem.isUse ~= true then
            self:_showRecommend()
        end
        GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showItemDate()
        self:_showWear() --装备图片
        self:_showItemNum()
        self:showLock()
        self:showExtraInfo()
        self:_addSidebarExperience() 
        self:_showSell()   
        if self.m_tItem and self.m_tItem.maintype and self.m_tItem.subtype and self.m_tItem.maintype == 38 and self.m_tItem.subtype >= 9 and self.m_tItem.subtype <= 13 and self.m_tItem.extraInfo then
            --WZLog("CellGoodItem:_update spriteStoneQuality =", self.m_tItem.extraInfo.spriteStoneQuality)
            self:setVisibleItemCount(self.m_tItem.extraInfo.spriteStoneQuality)
            self:clearItemQualityPic(nil, self.m_tItem.extraInfo.spriteStoneQuality)
        end   
    end
	--self:_showItemNum()--物品数量
	--self:_showRecommend()--推荐
	--self:_showWear()--是否穿上
	--self:_showItemDate()--是否过期
	--self:_showLevel()--显示物品等级
	--self:_setStart()--装备升星
	--self:_showStone()--装备镶嵌
    --self:_showChipMasking()--碎片蒙版
	--碎片类型加上小图片
	if self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.main_type == 9 then
    	local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    	local img = WZUIImage:create()
    	img:setZOrder(99969)
   		conItem:addChild(img)
    	img:setFile("ui/common/common_icon_suipian.png")
		--img:setUseOriginSize(true)
		img:setOpacity(255)
		img:setScale(0.4)
		img:setRelativePosition(ccp(0.72,0.7))
	end

    self:addMagicLevelStar()
end

function CellGoodItem:showExtraInfo()
	if self.m_tItem == nil then return end
    if self.m_tItem.extraInfo == nil then return end
	if self.m_tItem.basicInfo.main_type == 4 or self.m_tItem.basicInfo.main_type == 43 then
       	self:_showLevel()
       	self:_showStone()
    	self:_setStart()
	end
end

--@brief 设置时装格子背景图
function CellGoodItem:setSZBg()
--	WZLog("CellGoodItem:setSZBg")
	if self.m_root == nil then return end
	self.m_nType = 14
   	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
   	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   	GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   	--GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_icon_szxz.png")
   	GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   	GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setVisible(true)
   	GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(true)
end

--@brief 设置背景图片是否可见
function CellGoodItem:_setBgImgVisible(bool)
	if self.m_root == nil then return end
	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(bool)
	GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setVisible(bool)
	GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(bool)

    if bool == false then
        local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
        if conItem:getChildByTag(1212) then
            conItem:removeChildByTag(1212,true)
        end
    end
end

--@brief 设置底层背景图片
function CellGoodItem:setBackImgFile(fileName, is_opacity, nScale, rPt)
    if self.m_root == nil then return end
    is_opacity = is_opacity or nil
    local btnImg_CellGoodItem = GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image)
    if btnImg_CellGoodItem then
        btnImg_CellGoodItem:setFile(fileName)
        if is_opacity then
            btnImg_CellGoodItem:setOpacity(178)
        end
        if nScale then 
            btnImg_CellGoodItem:setScale(nScale)
        end
        if rPt then 
            btnImg_CellGoodItem:setRelativePosition(rPt)
        end
    end
end

--@brief 设置底层背景图片
function CellGoodItem:setBackImgFile2()
    if self.m_root == nil then return end
    local btnImg = GetElement(self.m_root,"btnImg_CellGoodItem",WZUI9Image)
    btnImg:setFile("ui/common/frame_12.png")
    btnImg:setUseOriginSize(false)
    btnImg:setScale(0.9)
    local btnImg2 = GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image)
    btnImg2:setRelativePosition(GlobalMethod:ccp(0.5,0.475))
end

--@brief 	设置背景图片文件
function CellGoodItem:_setRewardBg1()
	if self.m_root == nil then return end
   	GetElement(self.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
end

--@brief	显示物品数量
function CellGoodItem:_showItemNum()
--    WZLog("CellGoodItem:_showItemNum")
	if self.m_tItem == nil then return end

    local count = nil
    if self.m_tItem.lastTime then
        count = self.m_tItem.lastTime
    end
    if self.m_tItem.lastNum then
        count = self.m_tItem.lastNum
    end
    if self.m_tItem.basicInfo then
        if self.m_tItem.basicInfo.main_type == 43 then
            
        elseif self.m_tItem.basicInfo.main_type == 4 then

            --时效装备
            if self.m_nType == 17 then
                if self.m_tItem.basicInfo.time_limit ~= -1 then
                    local day = math.floor(self.m_tItem.basicInfo.time_limit/60/24)
                    self:setItemCount((self.m_tItem.basicInfo.time_limit/60/24))
                    return
                end
            end

            if self.m_nType == 17 or self.m_nType == 31 then 
                local conItem = GetElement(self.m_root, "conItem_CellGoodItem", WZUIContainer)
                if conItem then
                    conItem = WZUIContainer:luaTo(conItem)
                end
                if self.m_imgCornerIcon == nil then
                    self.m_imgCornerIcon = WZUIImage:create()
                    self.m_imgCornerIcon:setAnchorPoint(ccp(0,1))
                    self.m_imgCornerIcon:setRelativePosition(ccp(-0.03,1.03))
                    self.m_imgCornerIcon:setUseOriginSize(true)
                    self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                    conItem:addChild(self.m_imgCornerIcon, 2)
                else
                    self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                end
            end
            return
        end
        if self.m_tItem.basicInfo.use_type == 0 and self.m_tItem.lastNum then
            count = self.m_tItem.lastNum
        elseif self.m_tItem.basicInfo.use_type == 1 and self.m_tItem.lastTime then
            count = self.m_tItem.lastTime
        end
    end
	if self.m_tItem.timeLock ~= nil and self.m_tItem.timeLock > 0 then
		count = self.m_tItem.timeLock
	end
    if count == nil then
       return
    end
	local bShow = true
	if count ~= "" and tonumber(count) and tonumber(count) <= -1 then
        if self.m_nType == 16 or self.m_nType == 17 or self.m_nType == 31 then
            self:setItemCount(-1)
        else
            if WndSell.m_root then
            else
        		self:setItemCount(LocalStrings.NOLIMIT)
            end
        end
		bShow = false
    elseif tonumber(count) == 0 and self.m_tItem.isZero == nil then
		return--如果特制要求有零，就用isZero
	else
		--local num = "x"..tostring(count)
		local num = tostring(count)
		self:setItemCount(num)
	end
end

--@brief hightlight
function CellGoodItem:_hightlight()
    WZLog("CellGoodItem:_hightlight")
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
	end
    
    if self.m_hightLight == nil then
		self.m_hightLight = WZUI9Image:create()
		self.m_hightLight:setFile("ui/lottery/selected.png")
        self.m_hightLight:setVisible(false)
        conItem:addChild(self.m_hightLight)
	end
end

--@brief 状态
function CellGoodItem:_stats()
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    if conItem then conItem = WZUIContainer:luaTo(conItem) end
    if self.m_stats == nil then
        self.m_stats = WZUI9Image:create()
        self.m_stats:setFile("ui/pet/battle.png")
        self.m_stats:setVisible(false)
        self.m_stats:setUseOriginSize(true)
        self.m_stats:setRelativePosition(CCPoint(0.701341,0.2))
        conItem:addChild(self.m_stats)
    end
end

function CellGoodItem:_showStats(bShow)
   if  self.m_stats then
       self.m_stats:setVisible(bShow)
   end
end


--@brief	物品数量是否可见
function CellGoodItem:_setItemVisible(bShow)
	if self.m_root == nil then return end
	
	if self.m_txtCount then
		self.m_txtCount:setVisible(bShow)
--		self:_setItemBkVisible(bShow)
	end
end

--@brief    设置物品数量以及根据数量显示相应的颜色
function CellGoodItem:_setItemCountText(nHaveNum, nNeedNum, fontSize)
    if self.m_root == nil then return end
    
    if self.m_txtCount then
        self.m_nNeedCount = nNeedNum
        self.m_txtCount:setText(nHaveNum .. "/" .. nNeedNum)
        if nHaveNum < nNeedNum then
            self.m_txtCount:setColor(ccc3(255,236,193))
            self.m_txtCount:setStrokeColor(ccc3(127,70,26))
        else
            self.m_txtCount:setColor(ccc3(255,255,255))
            self.m_txtCount:setStrokeColor(ccc3(79,60,48))
        end

        if fontSize then 
            self.m_txtCount:setFontSize(fontSize)
        end
    end
end

--@brief	显示物品名称
function CellGoodItem:_kaLevel(sLevel)
	if self.m_root == nil then return end
	if self.m_tItem == nil then return end
    if self.m_tItem.extraInfo == nil then return end
    
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then conItem = WZUIContainer:luaTo(conItem) end
    
    local coler = ccc3(255,255,255)
    if self.m_kapaiLevel == nil and  sLevel >=  0 then
        self.m_kapaiLevel = WZUILabelTTF:create()
        self.m_kapaiLevel:setText(sLevel)
        self.m_kapaiLevel:setColor(coler)
        self.m_kapaiLevel:setFontSize(20)
        self.m_kapaiLevel:setAnchorPoint(ccp(1,1))
        self.m_kapaiLevel:setEnableStroke(true)
        self.m_kapaiLevel:setStrokeColor(ccc3(38,47,0))
        self.m_kapaiLevel:setStrokeSize(3)
        self.m_kapaiLevel:setRelativePosition(ccp(0.95,0.31))
        conItem:addChild(self.m_kapaiLevel)
    end
    if sLevel >= 0 then
        self.m_kapaiLevel:setText(sLevel)
    end
    return self.m_kapaiLevel
end
--@brief	物品过期
function CellGoodItem:_showItemDate()
	if self.m_tItem == nil or self.m_tItem.expired == nil or self.m_tItem.expired ~= true or self.m_imgOutTime then
		return
	end
	 self:_setOUtTime()
end

--@brief	物品过期
function CellGoodItem:_setOUtTime()
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	conItem = WZUIContainer:luaTo(conItem)
	self.m_imgOutTime = WZUIImage:create()
	self.m_imgOutTime:setFile("common/text/expired.png")
	self.m_imgOutTime:setUseOriginSize(true)
	conItem:addChild(self.m_imgOutTime)
end

--@brief	物品背景是否可见
function CellGoodItem:_setItemBkVisible(bShow)
	if self.m_root == nil then return end
	local imgBk = self.m_root:getChildElement("imgBk_CellGoodItem")
	if imgBk then
		imgBk = WZUI9Image:luaTo(imgBk)
		imgBk:setVisible(bShow)
	end
end

--@brief	推荐
function CellGoodItem:_showRecommend()
	if self.m_tItem == nil or self.m_tItem.recommended == nil or self.m_tItem.recommended ~= true or (self.m_tItem.isUse and self.m_tItem.isUse == true) then
		return
	end
	self:_setRecommend()
end

--@brief	显示推荐
function CellGoodItem:_setRecommend()
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	conItem = WZUIContainer:luaTo(conItem)
	if self.m_imgRecommended == nil then
		self.m_imgRecommended = WZUIImage:create() 
        self.m_imgRecommended:setFile("ui/bag/bag_icon_tuijian.png")
		self.m_imgRecommended:setUseOriginSize(true)
		self.m_imgRecommended:setRelativePosition(ccp(0.33,0.64))
        conItem:addChild(self.m_imgRecommended)
	end
end

--@brief	显示是否穿上
function CellGoodItem:_showWear()
	if self.m_tItem == nil or self.m_tItem.isUse == nil or self.m_tItem.isUse ~= true then
		return
	end
	self:setWear(self.m_tItem.isUse)
end

--@brief 锁
function CellGoodItem:_showLock()
    if self.m_root == nil or self.m_tItem == nil or self.m_tItem.lastTimeBak == nil or self.m_tItem.lastTimeBak == 0 then
		return
	elseif self.m_tItem.extraInfo == nil or self.m_tItem.extraInfo.strongLevel == nil then
		return 
	elseif CacheCenter:getStrenthenRateList() == nil or CacheCenter:getStrenthenRateList().indefiniteStrongLevel == nil then
		return 
	elseif self.m_tItem.extraInfo.strongLevel < CacheCenter:getStrenthenRateList().indefiniteStrongLevel then
		return 
	end
	if self.m_lock == nil then
		local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
		self.m_lock = WZUIImage:create()
		self.m_lock:setScale(0.6)
		self.m_lock:setAnchorPoint(ccp(0,0))
        self.m_lock:setRelativePosition(ccp(0.05,0.05))
        self.m_lock:setUseOriginSize(true)
        self.m_lock:setFile("ui/hall/roomlist_lock.png")
        conItem:addChild(self.m_lock)
	end
end

--@brief 锁
function CellGoodItem:showLock2()
    if self.m_lock2 == nil then
        local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
        local imgBg = WZUIImage:create()
        imgBg:setAnchorPoint(ccp(0.5,0.5))
        imgBg:setRelativePosition(ccp(0.5,0.5))
        imgBg:setUseOriginSize(true)
        imgBg:setFile("ui/common/common_shade_chushouheidi.png")
        imgBg:setOpacity(130)
        conItem:addChild(imgBg,196,196)

        self.m_lock2 = WZUIImage:create()
        self.m_lock2:setScale(0.5)
        self.m_lock2:setRelativePosition(ccp(0.5,0.5))
        self.m_lock2:setUseOriginSize(true)
        self.m_lock2:setFile("ui/common/common_icon_suo.png")
        conItem:addChild(self.m_lock2,197,197)
    end
end

--@brief    移除添加的勾号选中状态
function CellGoodItem:removeLock2()
    -- body
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    if conItem:getChildByTag(196) then
        conItem:removeChildByTag(196, true)
    end

    if conItem:getChildByTag(197) then
        conItem:removeChildByTag(197, true)
    end

    self.m_lock2 = nil 
end

--@brief	选中出售
--@brief    nType:类型1->默认；2->宝物鉴定背包
function CellGoodItem:_showSell(nType)
    local nTempType = nType or 1
    if nTempType == 1 then
        if self.m_root == nil or self.m_tItem == nil or self.m_tItem.sellHook == nil or self.m_tItem.sellHook == false then
    		return
    	end
    elseif nTempType == 2 then
        if self.m_root == nil or self.m_tItem == nil then
            return
        end
    end

	if self.m_sell == nil then
		local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
		local imgBg = WZUIImage:create()
		imgBg:setAnchorPoint(ccp(0.5,0.5))
        imgBg:setRelativePosition(ccp(0.5,0.5))
        imgBg:setUseOriginSize(true)
        imgBg:setFile("ui/common/common_shade_chushouheidi.png")
		imgBg:setOpacity(130)
        conItem:addChild(imgBg,198,198)

		self.m_sell = WZUIImage:create()
		self.m_sell:setAnchorPoint(ccp(0,0))
        self.m_sell:setRelativePosition(ccp(0.65,0.1))
        self.m_sell:setUseOriginSize(true)
        self.m_sell:setFile("ui/common/common_icon_gou.png")
        conItem:addChild(self.m_sell,199,199)
	end
end

--@brief    供外部调用，设置勾号选中状态
function CellGoodItem:showSelectedIcon(nType)
    -- body
    self:_showSell(nType)
end

--@brief    移除添加的勾号选中状态
function CellGoodItem:removeGouIcon()
    -- body
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    if conItem:getChildByTag(198) then
        conItem:removeChildByTag(198, true)
    end

    if conItem:getChildByTag(199) then
        conItem:removeChildByTag(199, true)
    end

    self.m_sell = nil 
end

--@brief	显示套装特效
function CellGoodItem:_showSuitAni(itemSuitNum, itemSuitId)
	do return end
	WZLog("CellGoodItem:_showSuitAni")
	WZLog("显示套装特效")
	if itemSuitNum == nil or itemSuitId == nil then return end
	if tonumber(itemSuitNum) < 3 then return end
	if self.m_root == nil then return end
	if self.m_tItem == nil or self.m_tItem.basicInfo == nil then return end
	local isSuit = false
	local suitID = -1
	for k,v in pairs(GDatatab_item_suit) do
		for i=1,6 do
			if tonumber(self.m_tItem.basicInfo.id) == tonumber(v.item_list[1][i]) then
				isSuit = true
				suitID = v.id
			end
		end
	end
    local con = self.m_root:getChildElement("conItem_CellGoodItem")
	if isSuit and itemSuitNum >= 3 and suitID == itemSuitId then
		local ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
	    ani:getAnimNode():setUseAbsCoordinate(true)
	    ani:getAnimNode():setAbsPosition(ccp(42,42))
	    ani:getAnimNode():setLoop(true)
	    --ani:getAnimNode():setScale(0.79)
	    con:addChild(ani:getAnimNode(),9)

		local aniName = {"taozhuang_lv","taozhuang_lan","taozhuang_zi","taozhuang_cheng"}
		ani:play(aniName[self.m_tItem.basicInfo.quality],true)	
	end
end

--@brief	显示物品等级
function CellGoodItem:_showLevel()
	if self.m_tItem == nil or self.m_tItem.extraInfo == nil or self.m_tItem.extraInfo.strongLevel == nil then
		return
	end
	if self.m_tItem.extraInfo.strongLevel >0 then
		local level = ":%d"
		level = string.format(level,self.m_tItem.extraInfo.strongLevel)
		self:_setLevel(level)
	end
end

--@brief	物品等级
function CellGoodItem:_setLevel(level)
	if self.m_root == nil then return end
    if level == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then conItem = WZUIContainer:luaTo(conItem) end

	if self.m_labelLevel == nil then
		self.m_labelLevel = WZUILabelAtlasFont:create()
		self.m_labelLevel:setText(level)
        self.m_labelLevel:setRelativePosition(ccp(0.8,0.87))
        self.m_labelLevel:setScaleX(1)
        self.m_labelLevel:setScaleY(1)
        self.m_labelLevel:setHeight(24)
        self.m_labelLevel:setWidth(14)
        self.m_labelLevel:setStartChar(48)
        self.m_labelLevel:setCharMapFileName("image/ui/common_num/common_num_qianghua.png")
        conItem:addChild(self.m_labelLevel,10)
	end
    return self.m_labelLevel
end

--@brief 显示宝石等级
function CellGoodItem:_showGemLv(lv)
    -- body
    if self.m_root == nil then return end
    if lv == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    if conItem then conItem = WZUIContainer:luaTo(conItem) end

    if self.m_lv == nil then
        self.m_lv = WZUILabelTTF:create()
        self.m_lv:setEnableStroke(true)
        self.m_lv:setStrokeColor(ccc3(128,54,13))
        self.m_lv:setTouchEnable(false)
        self.m_lv:setStrokeSize(4)
        self.m_lv:setText("Lv"..lv)
        self.m_lv:setBoldFont(true)
        self.m_lv:setRelativePosition(ccp(0.5,0.82))
        self.m_lv:setFontSize(16)
        self.m_lv:setColor(ccc3(255,255,255))
        conItem:addChild(self.m_lv)
    end
end

--@ 显示宝石数量
function CellGoodItem:_showGemNum(num1,num2)
    -- body
    if self.m_root == nil then return end
    if num1 == nil and num2 == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    if conItem then conItem = WZUIContainer:luaTo(conItem) end
    if self.m_txtCount then
        self.m_txtCount:setVisible(false)
    end
    if self.m_num == nil then
        self.m_num = WZUILabelTTF:create()
        self.m_num:setEnableStroke(true)
        self.m_num:setStrokeColor(ccc3(128,54,13))
        self.m_num:setTouchEnable(false)
        self.m_num:setStrokeSize(4)
        if num2 == nil then
            self.m_num:setText(num1)
        else
            self.m_num:setText(num1.."/"..num2)
        end
        self.m_num:setBoldFont(true)
        self.m_num:setRelativePosition(ccp(0.5,0.18))
        self.m_num:setFontSize(16)
        self.m_num:setColor(ccc3(255,255,255))
        conItem:addChild(self.m_num)
    else 
        if num2 == nil then
            self.m_num:setText(num1)
        else
            self.m_num:setText(num1.."/"..num2)
        end       
    end
end

--@brief	装备升星
function CellGoodItem:_setStart()
	if self.m_root == nil then return end
	if self.m_tItem == nil or self.m_tItem.extraInfo == nil then
		return
	end
    
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
	local level = self.m_tItem.extraInfo.starLevel
	if level == 0 or level == nil then
		return
	end

	local sFile = "ui/common/common_icon_xingxing2.png"
	local nStartLevel
    if level >= 13 then
        sFile = "ui/common/common_icon_xingxing2_h.png"
    end
    if self.m_imgStart == nil then
        self.m_imgStart = WZUIImage:create()
        self.m_imgStart:setFile(sFile)
        self.m_imgStart:setRelativePosition(ccp(0.18,0.86))
        self.m_imgStart:setScaleX(0.45)
        self.m_imgStart:setScaleY(0.45)
        conItem:addChild(self.m_imgStart)

        nStartLevel = WZUILabelTTF:create()
        nStartLevel:setEnableStroke(true)
        nStartLevel:setStrokeColor(ccc3(128,54,13))
        nStartLevel:setTouchEnable(false)
        nStartLevel:setStrokeSize(4)
        nStartLevel:setText(level)
        nStartLevel:setBoldFont(true)
        nStartLevel:setRelativePosition(ccp(0.5,0.5))
        nStartLevel:setFontSize(16)
        nStartLevel:setZOrder(1)
        nStartLevel:setScale(2.223)
        nStartLevel:setColor(ccc3(255,255,255))
        self.m_imgStart:addChild(nStartLevel)
    end
	if (self.m_nType == 10 or self.m_nType == 2) and (self.m_tItem.isUse == true or self.m_tItem.recommended == true) then
        self.m_imgStart:setVisible(false)
	end

	if level < 8 then return end

	if self.m_aniStar == nil then
		self.m_aniStar = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
        self.m_aniStar:getAnimNode():setUseAbsCoordinate(true)

        self.m_aniStar:getAnimNode():setAbsPosition(ccp(43,43))
        self.m_aniStar:getAnimNode():setLoop(true)
        conItem:addChild(self.m_aniStar:getAnimNode())
		if self.m_tItem.basicInfo.quality == 4 then
			if level == 8 or level == 9 then
				self.m_aniStar:play("shengxing_cheng",true)	
			elseif level == 10 or level == 11 then
				self.m_aniStar:play("shengxing_cheng2",true)
            elseif level == 12 then
                self.m_aniStar:play("shengxing_cheng3",true)
            elseif level >= 13 then
                self.m_aniStar:play("hongkuang1",true)
			end
		else
			if level == 8 or level == 9 then
				self.m_aniStar:play("shengxing_lv",true)	
			elseif level == 10 or level == 11 then
				self.m_aniStar:play("shengxing_lan",true)	
			elseif level >= 12 then
				self.m_aniStar:play("shengxing_zi",true)	
			end
		end
	end
end

--@brief	强化栏适配动画位置
function CellGoodItem:AdaptAniPosition()
	if self.m_aniStar ~= nil then
        self.m_aniStar:getAnimNode():setAbsPosition(ccp(41,42))
	end
	for i=1,3 do
		local ani = self["m_aniStone"..i]
		if ani ~= nil then
        	ani:getAnimNode():setAbsPosition(ccp(1+15*i,13))
		end
	end
end

--@brief	装备升星最大值动画
function CellGoodItem:_setMaxStart()
	if self.m_root == nil then return end
	local sprite = AnimationManager:createSpriteWithAnimation(IWCO_SHOPEFFICIENTS,"line3")
	sprite:playRepeat()
	local size = WZUIContainer:luaTo(self.m_root):getAbsContentSize()
	local nSpace = 1
	sprite:setScaleX(size.width*nSpace/ITEMSIZE.width)
	sprite:setScaleY(size.width*nSpace/ITEMSIZE.width)
	sprite:setPosition(ccp(size.width/2, size.height/2))
	self.m_root:addChild(sprite)
end

--@brief	装备镶嵌
function CellGoodItem:_showStone(xOffset, yOffset)
	if self.m_root == nil then return end
	if self.m_tStone == nil or #self.m_tStone == 0 then
		return
	end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    for i = 1, 5 do
        if conItem:getChildByTag(9990 + i) then 
            conItem:removeChildByTag(9990 + i, true)
        end
    end
	local x = -0.01
	local hasStone = false
	local index = 1
    local offsetX = xOffset or 0
    local offsetY = yOffset or 0
    WZLog("CellGoodItem:_showStone")
	for i,data in pairs(self.m_tStone) do
		x = x + self.m_nSpace
        local image
		if i==3 then
        	image = self:_createImgStone(data.icon,ccp(x + offsetX,0.255 + offsetY),0.24)
		else
        	image = self:_createImgStone(data.icon,ccp(x + offsetX,0.25 + offsetY),0.24)
		end
        image:setTag(9990 + i)
		conItem:addChild(image,10)
		self:_createAniStone(data,index,0+i*15)
		index = index + 1
		hasStone = true
	end
	--有宝石的话加上底图
	if hasStone then
        local image = self:_createImgStone("ui/common/common_scale9_di40.png",ccp(0.43 + offsetX,0.128 + offsetY),1,ccp(0.5,0.5),true)
		image:setScaleX(1.26)
        image:setTag(9995)
		conItem:addChild(image)
	end
end

--@brief	装备镶嵌图片
function CellGoodItem:_createImgStone(icon,pt,scale,anchor,bOrigin)
	pt = pt or ccp(0.5,0.5)
	anchor = anchor or ccp(0.5,1)
	scale = scale or 1
	bOrigin = bOrigin or true
	local image = WZUIImage:create()
	image:setFile(icon)
	image:setAnchorPoint(anchor)
	image:setRelativePosition(pt)
	image:setUseOriginSize(bOrigin)
	image:setScale(scale)
	return image
end

--@brief	装备镶嵌特效
function CellGoodItem:_createAniStone(tData,index,positionX)
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
	local ani = self["m_aniStone"..index]
	WZLog("CellGoodItem:_createAniStone","m_aniStone"..index)
	local level  = tData.value
	if level < 8 then return end
	if ani == nil then
		ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
        ani:getAnimNode():setUseAbsCoordinate(true)
        ani:getAnimNode():setAbsPosition(ccp(positionX,10))
        ani:getAnimNode():setLoop(true)
        conItem:addChild(ani:getAnimNode(),9)

		if level == 8 or level == 9 then
			ani:play("xiangqian_bai",true)	
		elseif level >= 10 then
			ani:play("xiangqian_jin",true)	
		end
	end
	self["m_aniStone"..index] = ani
end

--@brief	橙装自带特效
function CellGoodItem:_createChengAni()
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
	if conItem:getChildByTag(421) then
		conItem:removeChildByTag(421,true)
	end
	local main_type 
	if self.m_tItem and self.m_tItem.basicInfo ~= nil then
		main_type = self.m_tItem.basicInfo.main_type or 4
	else
		main_type = 4
	end
	if (main_type == 4 or main_type == 11) then 
	
   	local spine = WZUISpine:create()
   	spine:setTouchEnable(false)
   	spine:setFileJson("ui/ui_icon_effect.json")
   	spine:setFileAtlas("ui/ui_icon_effect.atlas")
   	spine:setAnimationName("cheng")
   	spine:setUseOriginSize(true)
   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	spine:play("cheng",true)
	spine:setScale(0.8)
   	conItem:addChild(spine,421,421)

	if main_type == 11 then
		spine:play("zuoqi_cheng", true)	
   		spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		spine:setScale(1)
	end
	end
end

--@brief	是否显示选中图标
function CellGoodItem:_showSeletedImg()
	if self.m_root == nil then return end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    if self.m_seletedImg == nil then
        self.m_seletedImg = WZUIImage:create()
        self.m_seletedImg:setFile("ui/main/shop/hook.png")
        self.m_seletedImg:setRelativePosition(ccp(0.703227,0.259773))
        self.m_seletedImg:setScaleX(0.5)
        self.m_seletedImg:setScaleY(0.5)
        self.m_seletedImg:setVisible(true)
        conItem:addChild(self.m_seletedImg)
    end
end

--@brief 商品类型描述图片
function CellGoodItem:GoodMark(nGoodsMark,nGoodsMarkNum)
	if self.m_root == nil then return end
    if nGoodsMark == nil then nGoodsMark = 0 end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
	end
	
    --商品类型描述图片
	if self.m_imgTuijian == nil then
        self.m_imgTuijian = WZUIImage:create()
        if nGoodsMark==0 then
            self.m_imgTuijian:setVisible(false)
        elseif nGoodsMark==1 then
            self.m_imgTuijian:setFile("common/text/label_recommend.png")
        elseif nGoodsMark==2 then
            self.m_imgTuijian:setFile("common/text/label_buy.png")
        elseif nGoodsMark==3 then
            self.m_imgTuijian:setFile("common/text/label_new_products.png")
        elseif nGoodsMark==4 then
            local index = 10-math.ceil(nGoodsMarkNum/10)
            self.m_imgTuijian:setFile("common/text/label_promotion"..index..".png")
        end
        self.m_imgTuijian:setRelativePosition(ccp(0.530303,0.478495))
        conItem:addChild(self.m_imgTuijian)
    end
    return self.m_imgTuijian
end
--@brief 格子边框动画
function CellGoodItem:_hightLightAnimation()
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    conItem = WZUIContainer:luaTo(conItem)
    if self.m_animation == nil then
        self.m_animation = WZArmature:create()
        self.m_animation:setUseOriginSize(false)
        self.m_animation:setArmatureName("kp_xuanzhuan")
		self.m_animation:setRelativePosition(ccp(0.5,-0.02))
        self.m_animation:setScaleY(1.05)
        self.m_animation:setVisible(false)
		local action = WZUIArmatureAnimationById:create()
		action:setAnimationId(0)
		action:setLoop(-1)
        conItem:addChild(self.m_animation)
        self.m_animation:runUIAction(action)
    end
end

--装备碎片蒙版
function CellGoodItem:_showChipMasking()
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root, "conItem_CellGoodItem", WZUIContainer)
    if self.m_imgChipMask == nil then
        self.m_imgChipMask = WZUIImage:create()
        self.m_imgChipMask:setFile("ui/synthesis/suipian.png")
        self.m_imgChipMask:setScale(0.82)
        conItem:addChild(self.m_imgChipMask)
    end
end

--设置格子高亮
function CellGoodItem:setHighLight(bool)
	if self.m_root == nil then return end
	if self.m_nType == 20 then return end
	local btn = GetElement(self.m_root,"btnClick_CellGoodItem",WZUIButton)
	if btn == nil then return end
    GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(true)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--设置格子灰色
function CellGoodItem:setGrayRender(bool)
	WZLog("CellGoodItem:setGrayRender",bool)
	if self.m_root == nil then return end
    GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setGrayRender(bool)
	if self.m_imgItem ~= nil then
		self.m_imgItem:setGrayRender(bool)
	end
	if self.m_imgBk2 ~= nil then
		self.m_imgBk2:setGrayRender(bool)
	end
end

--设置透明度
function CellGoodItem:setOpacity(opacity)
	if self.m_imgItem ~= nil then
		self.m_imgItem:setOpacity(opacity)
	end
end

--显示时装转化礼钻
--显示皮肤转化材料
--@param    bShowExchangeText：只是针对足迹物品
--@param	fashionCount	时装转化个数
--@param    bUseCopy    是否大奖界面
function CellGoodItem:showConversion(bShowExchangeText, fashionCount, bUseCopy)
--	WZLog("CellGoodItem:showConversion", self.m_tItem.basicInfo.id, self.m_tItem.basicInfo.name, Serialize(NOTRECYCLEIDS), Serialize(NOTRECYCLESKINIDS))
    if self.m_root == nil then return false end
	if self.m_tItem == nil then return false end
	--某些不转化的情况
	if utilsValueInTable(self.m_tItem.basicInfo.id, NOTRECYCLEIDS) then return false end
	if utilsValueInTable(self.m_tItem.basicInfo.id, NOTRECYCLESKINIDS) then return false end
    if bUseCopy then 
        if utilsValueInTable(self.m_tItem.basicInfo.id, NOTRECYCLEIDS_COPY) then return false end
    end
	local main_type = self.m_tItem.basicInfo.main_type
	if main_type == 5 or main_type == 20 or main_type == 23 then 

	local itemId = self.m_tItem.basicInfo.id
	--已拥有的时装不是无限期，返回
    if (main_type == 5 and CacheCenter:getPlayerItemCountById(itemId) ~= -1) then return false end
	if (main_type == 23 and not CacheCenter:wetherActiveForever(itemId)) then return false end
    if main_type == 23 and not bShowExchangeText then return false end
	--对应皮肤不是无限期，返回
	local skinNum = 0
	if main_type == 20 then
		if WndPhantom.m_tDataList == nil then return false end
		local sId = self.m_tItem.basicInfo.property[1][1]
		local own = false
		for i=1,#WndPhantom.m_tDataList do
            WZLog("皮肤转化材料",WndPhantom.m_tDataList[i].shapeId,sId)
			if WndPhantom.m_tDataList[i].shapeId == sId then
				if WndPhantom.m_tDataList[i].remainTime == -1 then
					own = true
					skinNum = WndPhantom.m_tDataList[i].remainTime
				end
			end
            if GDatatab_shape_skins["id_"..WndPhantom.m_tDataList[i].shapeId].channel == GDatatab_shape_skins["id_"..sId].channel then
                if GDatatab_shape_skins["id_"..WndPhantom.m_tDataList[i].shapeId].quality >= GDatatab_shape_skins["id_"..sId].quality then
                    if WndPhantom.m_tDataList[i].remainTime == -1 then
                        own = true
                        skinNum = WndPhantom.m_tDataList[i].remainTime
                    end  
                end
            end                   
		end

		if own ~= true then return false end
	end
	local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	if conItem:getChildByTag(600) then conItem:removeChildByTag(600,true) end
	if conItem:getChildByTag(601) then conItem:removeChildByTag(601,true) end
	if conItem:getChildByTag(602) then conItem:removeChildByTag(602,true) end
	if conItem:getChildByTag(603) then conItem:removeChildByTag(603,true) end

	local dressQualityModulus = CacheCenter:getGameParam().dressQualityModulus
	local dressUnlimitedModulus = CacheCenter:getGameParam().dressUnlimitedModulus
	WZLog("转化系数", dressQualityModulus, dressUnlimitedModulus)
	if dressQualityModulus == nil or dressQualityModulus == "" then dressQualityModulus = "[2,3]&[3,4]&[4,5]" end
	if dressUnlimitedModulus == nil or dressUnlimitedModulus == "" then dressUnlimitedModulus = [[100]] end

	local bg = WZUIImage:create()
	bg:setFile("ui/common/common_scale9_jldi.png")
	bg:setUseOriginSize(true)
    bg:setRelativePosition(ccp(0.5,-0.36))
    conItem:addChild(bg,9,602)

    local exPlain = WZUILabelTTF:create()
    exPlain:setColor(ccc3(255,236,193))
    exPlain:setFontSize(18)
    exPlain:setBoldFont(true)
    exPlain:setEnableStroke(true)
    exPlain:setStrokeColor(ccc3(79,60,48))
	exPlain:setStrokeSize(4)
    exPlain:setDimensions(CCSize(0,0))
    exPlain:setRelativePosition(ccp(0.5,-0.25))
    exPlain:setText(LocalStrings.CONVERSION1)
    conItem:addChild(exPlain, 10, 600)

    local exPlain = WZUILabelTTF:create()
    exPlain:setColor(ccc3(255,227,116))
    exPlain:setFontSize(18)
    exPlain:setBoldFont(true)
    exPlain:setEnableStroke(true)
    exPlain:setStrokeColor(ccc3(79,60,48))
	exPlain:setStrokeSize(4)
    exPlain:setDimensions(CCSize(0,0))
    exPlain:setRelativePosition(ccp(0.16,-0.5))
    exPlain:setText(LocalStrings.EXCHANGEEXP_TEXT3)
    conItem:addChild(exPlain, 10, 601)

	local tryWear = WZUIImage:create()
    tryWear:setFile("shopitems/lizuan.png")
    if CacheCenter:getGameParam().isUseTicket == "1" then
        tryWear:setFile("shopitems/diamond.png")
    end
	tryWear:setUseOriginSize(true)
	tryWear:setScale(0.45)
    tryWear:setRelativePosition(ccp(0.53,-0.5))
    conItem:addChild(tryWear,10,602)

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
        tryWear:setRelativePosition(ccp(1.3,-0.5))
    end

    local num = WZUILabelTTF:create()
    num:setColor(ccc3(255,227,116))
    num:setFontSize(18)
    num:setBoldFont(true)
    num:setEnableStroke(true)
    num:setStrokeColor(ccc3(79,60,48))
	num:setStrokeSize(4)
    num:setDimensions(CCSize(0,0))
    num:setRelativePosition(ccp(0.7,-0.5))
    num:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    num:setText(0)
    num:setAlignment(kCCTextAlignmentLeft)
    conItem:addChild(num, 10, 603)

    if ProjConfig.LANGUAGE == "vn" then
        exPlain:setScale(0.7)
        exPlain:setRelativePosition(GlobalMethod:ccp(0.277647,-0.5))
        num:setScale(0.7)
        num:setRelativePosition(GlobalMethod:ccp(0.641176,-0.5))
        tryWear:setScale(0.3)
        tryWear:setRelativePosition(GlobalMethod:ccp(1.00059,-0.5))
    end

	local lastTime = self.m_tItem.lastTime
	local multiple = 1
	if main_type == 5 then
		if lastTime == -1 then lastTime = tonumber(dressUnlimitedModulus) end

        if lastTime < -1 then
            if self.m_tItem.beforeUse and self.m_tItem.beforeUse ~= -1 then
                lastTime = (math.abs(lastTime)-1)*tonumber(dressUnlimitedModulus)
            else
                lastTime = math.abs(lastTime)*tonumber(dressUnlimitedModulus)
            end
        end
	end
	local quality, modulus = SplitItemString(dressQualityModulus)
	for i=1,#quality do
		if tonumber(quality[i]) == self.m_tItem.basicInfo.quality then
			multiple = modulus[i]
			break
		end
	end
	WZLog("显示转化",lastTime,multiple)
    if main_type == 23 then 
        local tTempData = GDatatab_item["id_" .. itemId]
	    num:setText(tTempData.recycleMess[1][2])
    else
		local count = lastTime*multiple
		if fashionCount ~= nil and fashionCount ~= 0 then
			count = lastTime*multiple*fashionCount
		end
        num:setText(count)
    end

	if main_type == 20 then
		tryWear:setFile("shopitems/common_icon_huanhua01.png")
		num:setText(GDatatab_item["id_"..itemId].recycleMess[1][2])
	end

	return true

	end
end

-------------------------------------私有方法模块End----------------------------------------
--@brief	重置格子
function CellGoodItem:_resetItem()
    self.m_imgItem = nil
    self.m_imgBk1 = nil
    self.m_imgBk2 = nil
    self.m_txtName = nil
    self.m_txtCount = nil
    self.m_imgRecommended = nil
    self.m_imgOutTime = nil
    self.m_imgWear = nil
    self.m_labelLevel = nil
    self.m_seletedImg = nil
    self.m_imgTuijian = nil
    self.m_imgStart = nil
    self.m_conStone = nil
    self.m_lock = nil
    self.m_animation = nil
    self.m_spriteUpgrade = nil
    self.m_kapaiLevel = nil
	self.m_sell = nil
	self.m_aniStar = nil		--升星动画
	self.m_aniSuit = nil		--套装动画
	self.m_aniStone1 = nil		--镶嵌动画
	self.m_aniStone2 = nil		--镶嵌动画
	self.m_aniStone3 = nil		--镶嵌动画
    self.m_aniStone4 = nil      --镶嵌动画
	self.m_imgCornerIcon = nil
    self.m_lock2 = nil
end
--@brief	执行物品项被选中动作
function CellGoodItem:_runSelectedAction(scaleTo,scaleEnd)
	if self.m_root == nil then return end
	scaleTo = scaleTo or 0.8
    local rootScale = self.m_root:getScale() or 1
    WZLog("rootScale===",rootScale)
	scaleEnd = scaleEnd or rootScale
	WZLog("CellGoodItem:_runSelectedAction",scaleTo,scaleEnd)
	local clickAction = WZUIActionSequence:create()
	if nil == clickAction then
		return
	end
	--缩小
	local actScaleSmall = WZUIActionScaleTo:create()
	if nil == actScaleSmall then
		return
	end
	actScaleSmall:setDuration(0.055)
	actScaleSmall:setScaleX(scaleTo)
	actScaleSmall:setScaleY(scaleTo)
	--还原
	local boyScaleBack = WZUIActionScaleTo:create()
	if nil == boyScaleBack then
		return
	end
	boyScaleBack:setDuration(0.055)
	boyScaleBack:setScaleX(scaleEnd)
	boyScaleBack:setScaleY(scaleEnd)
	--添加到动作序列
	clickAction:setChildAction(actScaleSmall)
	clickAction:setChildAction(boyScaleBack)
	--执行动作序列
	if self.m_root ~= nil then
		--WZUIContainer:luaTo(self.m_root):runUIAction(clickAction)
		self.m_root:runUIAction(clickAction)
	end
end

--@brief  显示物品获得条件
function CellGoodItem:showGetCondition(condition)
	if self.m_root == nil then return end
--    WZLog("CellGoodItem:showGetCondition")
    local con = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    local exPlain = WZUILabelTTF:create()
    exPlain:setColor(ccc3(220,211,185))
    exPlain:setFontSize(22)
    exPlain:setBoldFont(true)
    exPlain:setEnableStroke(true)
    exPlain:setStrokeColor(ccc3(60,19,12))
    exPlain:setDimensions(CCSize(60,60))
    exPlain:setRelativePosition(ccp(0.501352,0.449327))
    exPlain:setText(condition)
    con:addChild(exPlain)
end

--@brief	添加试穿图片
function CellGoodItem:_addTryWear()
--    WZLog("CellGoodItem:_addTryWear")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	if conItem:getChildByTag(300) then
		conItem:removeChildByTag(300,true)
	end
    
	local tryWear = WZUIImage:create()
	tryWear:setFile("ui/common/common_icon_scz.png")
	tryWear:setUseOriginSize(true)
	tryWear:setScale(0.8)
    conItem:addChild(tryWear,300,300)
end

--@brief	删除试穿图片
function CellGoodItem:_removeTryWear()
--    WZLog("CellGoodItem:_delTryWear")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    
	if conItem:getChildByTag(300) then
		conItem:removeChildByTag(300,true)
	end
end

--@brief    添加已拥有角标
function CellGoodItem:addSidebarOwn()
    self:_addSidebarOwn()
end

--@brief	添加已拥有角标
function CellGoodItem:_addSidebarOwn()
--	WZLog("CellGoodItem:_addSidebarOwn")
	if self.m_root == nil then return end
	local con = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    cornerIcon:setRelativePosition(GlobalMethod:ccp(0.325,0.64))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_yiyongyou.png")
	con:addChild(cornerIcon,9)
end

--@brief	添加时效角标
function CellGoodItem:_addSidebarTimeLimit()
--	WZLog("CellGoodItem:_addSidebarTimeLimit")
	if self.m_root == nil then return end
	local con = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	--限时装备角标
	if (self.m_tItem.basicInfo.main_type == 4) and self.m_tItem.showTimeLimit == true then

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    cornerIcon:setRelativePosition(GlobalMethod:ccp(0.325,0.665))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_xbth.png")
	cornerIcon:setScale(0.8)
	con:addChild(cornerIcon,9)

		local txt = WZUILabelTTF:create()
		txt:setFontSize(18)
    txt:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txt:setRelativePosition(GlobalMethod:ccp(0.25,0.74))
		txt:setColor(ccc3(255,255,255))
		txt:setText(LocalStrings.AGING)
		txt:setTouchEnable(false)
		txt:setEnableStroke(true)
		txt:setStrokeColor(ccc3(128,54,13))
		txt:setStrokeSize(4)
		txt:setBoldFont(true)
		txt:setRotation(-45)
		con:addChild(txt,10)
	end
end

--@brief	添加体验角标
function CellGoodItem:_addSidebarExperience()
--	WZLog("CellGoodItem:_addSidebarExperience")
	if self.m_root == nil then return end
	local main_type 
	local time
    if self.m_tItem.basicInfo then
		main_type = self.m_tItem.basicInfo.main_type
        if main_type == 35 or main_type == 45 or main_type == 46 then return end 
        if type(self.m_tItem.basicInfo.property) == "table" then
    		time = self.m_tItem.basicInfo.property[1][2]
        end
    else
		main_type = self.m_tItem.main_type
        if main_type == 35 or main_type == 46 then return end 
        if self.m_tItem.property then
    		time = self.m_tItem.property[1][2]
        end
    end

	if time and (main_type == 20 and time ~= -1) or (main_type == 23 and time ~= -1) then
		local con = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

		local cornerIcon = WZUIImage:create()
    	cornerIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    	cornerIcon:setRelativePosition(GlobalMethod:ccp(0.39,0.78))
    	cornerIcon:setUseOriginSize(true)
    	cornerIcon:setFile("ui/common/common_icon_tiyan1.png")
		con:addChild(cornerIcon,9)
	end
end

--@brief	添加过期时间角标
--@brief    nCount:時效
function CellGoodItem:_addSidebarTime(nCount, position)
--	WZLog("CellGoodItem:_addSidebarTime")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	--计算剩余天数
	local countdown = self.m_tItem.lastTime

	if countdown == nil then return end
    if countdown == 0 then return end
	local desc = ""
    if self.m_tItem.basicInfo.main_type == 4 then
        countdown = -1
    end
	if countdown == -86400 then countdown = -1 end
	if countdown == -1 then
		local cornerIcon = WZUIImage:create()
    	cornerIcon:setAnchorPoint(ccp(0,1))
    	cornerIcon:setRelativePosition(ccp(-0.03,1.03))
    	cornerIcon:setUseOriginSize(true)
    	cornerIcon:setFile("ui/common/common_icon_yongjiu.png")
    	conItem:addChild(cornerIcon, 2000)
		if position ~= nil then
			cornerIcon:setRelativePosition(position)
		end
		return
    elseif nCount then
        count = countdown
	elseif tonumber(countdown) > 86400 then
		count = math.ceil(countdown/86400)
	else
		count = 1
	end

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(ccp(0,1))
    cornerIcon:setRelativePosition(ccp(-0.03,1.03))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_ts.png")
    conItem:addChild(cornerIcon, 2000)
    if position ~= nil then
        cornerIcon:setRelativePosition(position)
    end
    --天
    local imgDay = WZUIImage:create()
    imgDay:setRelativePosition(ccp(0.483333,0.784848))
    imgDay:setFile("ui/common/common_icon_ts2.png")
    imgDay:setUseOriginSize(true)
    imgDay:setRotation(-45)
    cornerIcon:addChild(imgDay,1)
    --天数
    local txtDayNum = WZUILabelAtlasFont:create()
    txtDayNum:setRelativePosition(ccp(0.266667,0.569697))
    txtDayNum:setCharMapFileName("ui/common_num/common_num_ts.png")
    txtDayNum:setHeight(18)
    txtDayNum:setWidth(12)
    txtDayNum:setText(count)
    txtDayNum:setRotation(-45)
    txtDayNum:setUseOriginSize(true)
    cornerIcon:addChild(txtDayNum,1)
    if ProjConfig.LANGUAGE == "vn" then
        txtDayNum:setRelativePosition(ccp(0.2,0.569697))
        txtDayNum:setScale(0.83)
        if position ~= nil then
            cornerIcon:setRelativePosition(position)
        end
    end
end

--@brief	添加价格角标
--@brief    price:价格
function CellGoodItem:_addSidebarPrice(price, goldtype)
	WZLog("CellGoodItem:_addSidebarPrice",price,self.m_tItem.lastTime)
	if self.m_root == nil then return end

	--计算剩余天数
	local countdown = self.m_tItem.lastTime
	--if countdown == nil then return end
    if countdown ~= nil then return end
    --if countdown == -1 or countdown > 0 then return end

	local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(ccp(0,1))
    cornerIcon:setRelativePosition(ccp(-0.17,1.22))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_hts.png")
    conItem:addChild(cornerIcon, 2000)
    --天
    local imgDay = WZUIImage:create()
    imgDay:setRelativePosition(ccp(0.16,0.47))
    if goldtype then
        --WZLog("--%%%%%%1121--",goldtype)
        --if goldtype ~= 70 then 
            local iconPath = GDatatab_item["id_" .. goldtype].icon
            imgDay:setFile(iconPath)
            imgDay:setScale(0.15)
        --end
    else
        imgDay:setFile("ui/common/common_icon_zuanshi.png")
    end
    imgDay:setUseOriginSize(true)
    imgDay:setRotation(-45)
	imgDay:setScale(0.5)
    cornerIcon:addChild(imgDay,1)
    --天数
    local txtDayNum = WZUILabelTTF:create()
    txtDayNum:setRelativePosition(ccp(0.46,0.73))
	txtDayNum:setFontSize(18)
    txtDayNum:setText(price)
    txtDayNum:setRotation(-45)
	txtDayNum:setStrokeColor(ccc3(132,66,29))
	txtDayNum:setStrokeSize(4)
	txtDayNum:setBoldFont(true)
	txtDayNum:setTouchEnable(false)
	txtDayNum:setEnableStroke(true)
	txtDayNum:setColor(ccc3(255,255,255))
    cornerIcon:addChild(txtDayNum,1)
end

--@brief    设置选中状态
--@note     家园打工界面打工仔头像或守护兽头像
function CellGoodItem:setItemSelState(bVisible, filePath)
    -- body
    if bVisible then
        if not self.m_root:getChildByTag(777) then
            local imgState = WZUIImage:create()
            imgState:setTouchEnable(false)
            if filePath then
                imgState:setFile(filePath)
            else
                imgState:setAnchorPoint(ccp(0,0))
                imgState:setRelativePosition(ccp(0.6,0.05))
                imgState:setUseOriginSize(true)
                imgState:setFile("ui/common/common_icon_gou.png")
            end
            self.m_root:addChild(imgState,199,777)
        end
    else
        if self.m_root:getChildByTag(777) then
            self.m_root:removeChildByTag(777, true)
        end
    end
end

--@brief    设置头像状态
--@note     家园打工界面守护兽头像未符合品质的
function CellGoodItem:setItemGray(bVisible)
    -- body
    if bVisible then
        local imgState = WZUI9Image:create()
        imgState:setTouchEnable(false)
        imgState:setFile("ui/family/other/jy_007.png")
        self.m_root:addChild(imgState,100,778)
    else
        if self.m_root:getChildByTag(778) then
            self.m_root:removeChildByTag(778, true)
        end
    end
end

--@brief    获取守卫兽是否不可用
function CellGoodItem:getItemGray()
    -- body
    if self.m_root:getChildByTag(778) then
        return true
    end

    return false 
end

--@brief    设置头像状态
--@note     家园打工界面守护兽头像或打工仔打工中
function CellGoodItem:setItemStateWord(text)
    -- body
    if text then
        local txtDayNum = WZUILabelTTF:create()
        txtDayNum:setRelativePosition(ccp(0.5,0.1))
        txtDayNum:setFontSize(16)
        txtDayNum:setText(text)
        txtDayNum:setStrokeColor(ccc3(127,70,26))
        txtDayNum:setStrokeSize(4)
        txtDayNum:setTouchEnable(false)
        txtDayNum:setEnableStroke(true)
        txtDayNum:setColor(ccc3(255,255,255))
        self.m_root:addChild(txtDayNum,198,779)
    else
        if self.m_root:getChildByTag(779) then
            self.m_root:removeChildByTag(779, true)
        end
    end
end

--@brief    设置选中状态(高亮边框)
function CellGoodItem:setItemSelState2(bVisible)
    if bVisible then
        if not self.m_root:getChildByTag(780) then
            local imgState = WZUI9Image:create()
            imgState:setTouchEnable(false)
            -- imgState:setTouchSwallow(false)
            imgState:setFile("ui/common/frame_xz.png")
            self.m_root:addChild(imgState,199,780)
        end
    else
        if self.m_root:getChildByTag(780) then
            self.m_root:removeChildByTag(780, true)
        end
    end
end

--@brief    添加"发现"角标
--@brief    price:价格
function CellGoodItem:addSidebarFind()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(ccp(0,1))
    cornerIcon:setRelativePosition(ccp(-0.02,1.03))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_ts.png")
    conItem:addChild(cornerIcon, 2000)

    local txtDayNum = WZUILabelTTF:create()
    txtDayNum:setRelativePosition(ccp(0.37,0.66))
    txtDayNum:setFontSize(18)
    txtDayNum:setColor(ccc3(255,255,255))
    txtDayNum:setEnableStroke(true)
    txtDayNum:setStrokeSize(4)
    txtDayNum:setStrokeColor(ccc3(129,27,155))
    txtDayNum:setText(LocalStrings.RELIC_TEXT_11)
    txtDayNum:setRotation(312)
    txtDayNum:setUseOriginSize(true)
    cornerIcon:addChild(txtDayNum)

    if ProjConfig.LANGUAGE == "vn" then
        txtDayNum:setScale(0.75)
    end
end

--@brief    添加"击杀"角标
--@brief    price:价格
function CellGoodItem:addSidebarKill()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(ccp(0,1))
    cornerIcon:setRelativePosition(ccp(-0.02,1.03))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_ts.png")
    conItem:addChild(cornerIcon, 2000)

    local txtDayNum = WZUILabelTTF:create()
    txtDayNum:setRelativePosition(ccp(0.37,0.66))
    txtDayNum:setFontSize(18)
    txtDayNum:setColor(ccc3(255,255,255))
    txtDayNum:setEnableStroke(true)
    txtDayNum:setStrokeSize(4)
    txtDayNum:setStrokeColor(ccc3(129,27,155))
    txtDayNum:setText(LocalStrings.SETTLMENT_KILL)
    txtDayNum:setRotation(312)
    txtDayNum:setUseOriginSize(true)
    cornerIcon:addChild(txtDayNum)
end

--@brief    魔力宝石星级
--@brief    price:价格
function CellGoodItem:addMagicLevelStar()
    if self.m_nType == 2 and self.m_tItem.basicInfo ~= nil and self.m_tItem.basicInfo.id > 41000 and self.m_tItem.basicInfo.id <= 44000 then
        local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
        local pt = {ccp(0.13,0.125), ccp(0.13,0.275), ccp(0.13,0.425), ccp(0.13,0.575), ccp(0.13,0.725), ccp(0.13,0.875)}
        local star = GDatatab_dig_up["id_"..self.m_tItem.basicInfo.id].gemstone_starts
        for i=1,math.min(star,6) do
            local cornerIcon = WZUIImage:create()
            cornerIcon:setAnchorPoint(ccp(0.5,0.5))
            cornerIcon:setRelativePosition(pt[i])
            cornerIcon:setUseOriginSize(true)
            cornerIcon:setScale(0.7)
            cornerIcon:setFile("ui/common/common_icon_xingji.png")
            conItem:addChild(cornerIcon, 2000)
        end
    end
end

--@brief    重新设置数量的位置
function CellGoodItem:resetItemNumPt(pos, apPt)
    -- body
    if self.m_txtCount == nil then return end 

    if apPt then 
        self.m_txtCount:setAnchorPoint(apPt)
    end
    self.m_txtCount:setRelativePosition(pos)
end

--选中的位置（打钩）
function CellGoodItem:setChooseSelect()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    if not conItem then return end
    
    if not self.imgChooseIcon then
        self.imgChooseIcon = WZUIImage:create()
        self.imgChooseIcon:setAnchorPoint(ccp(0.5,0.5))
        self.imgChooseIcon:setRelativePosition(ccp(0.8,0.2))
        self.imgChooseIcon:setUseOriginSize(true)
        self.imgChooseIcon:setFile("ui/common/common_gx.png")
        conItem:addChild(self.imgChooseIcon, 2000)
    else
        if self.imgChooseIcon then
            self.imgChooseIcon:setVisible(true)
        end
    end
end
function CellGoodItem:setChooseNormal()
    if self.imgChooseIcon then
        self.imgChooseIcon:setVisible(false)
    end
end
--直接显示物品的数量
function CellGoodItem:setGoodItemCount(count)
    if self.m_txtCount then
        self.m_txtCount:setText(count)
    end
end
--升星强化的角标
function CellGoodItem:setProtomeSelect()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    if not conItem then return end
    
    local img_icon = WZUIImage:create()
    img_icon:setAnchorPoint(ccp(0,0.5))
    img_icon:setRelativePosition(ccp(0.05, 0.6))
    img_icon:setUseOriginSize(true)
    img_icon:setFile("ui/common/common_bq_3bts.png")
    conItem:addChild(img_icon)
end

--减号的表示
function CellGoodItem:setReduce(visible)
    if not self.m_btnReduce then
        self.m_btnReduce = WZUIButton:create()
        self.m_btnReduce:setUseAbsSize(true)
        self.m_btnReduce:setRelativePosition(GlobalMethod:ccp(0.8, 0.73))

        local imgNor = WZUIImage:create()
        imgNor:setUseOriginSize(true)
        imgNor:setFile("ui/common/common_btn_15.png")
        local imgSel = WZUIImage:create()
        imgSel:setUseOriginSize(true)
        imgSel:setFile("ui/common/common_btn_15.png")
        -- imgSel:setScale(0.8)
        self.m_btnReduce:setNormalElement(imgNor)
        self.m_btnReduce:setSelectElement(imgSel)
        self.m_btnReduce:setShowAll(true)
        self.m_btnReduce:setLuaDoneFunctionName("onClickReduce")
        self.m_btnReduce:setScale(0.6)
        self.m_root:addChild(self.m_btnReduce, 300)

        self.m_sTxtReduceTitle = WZUILabelTTF:create()
        self.m_sTxtReduceTitle:setText("1/"..self.m_tItem.lastNum)
        self.m_sTxtReduceTitle:setColor(GlobalMethod:ccc3(255,236,193))
        self.m_sTxtReduceTitle:setEnableStroke(true)
        self.m_sTxtReduceTitle:setStrokeColor(ccc3(127,70,26))
        self.m_sTxtReduceTitle:setStrokeSize(4)

        self.m_sTxtReduceTitle:setFontSize(18)
        self.m_sTxtReduceTitle:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        self.m_sTxtReduceTitle:setRelativePosition(GlobalMethod:ccp(0.5, 0.45))
        self.m_root:addChild(self.m_sTxtReduceTitle,300)
    else
        self.m_btnReduce:setVisible(visible)
    end
end
--
function CellGoodItem:setTxtReduceNumber(num1, num2)
    if self.m_sTxtReduceTitle then
        self.m_sTxtReduceTitle:setText(num1.."/"..num2)
    end
end
function CellGoodItem:setReduceCallFunc(func)
    self.m_sReduceCallFunc = func
end
function CellGoodItem:onClickReduce()
    if self.m_sReduceCallFunc then
        self.m_sReduceCallFunc(self.m_root:getTag(), self.m_tItem, self.m_sTxtReduceTitle, 2)
    end
end
--显示物品剩余的数量
function CellGoodItem:showGoodsRemainNum(txt)
    if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellGoodItem")
    if conItem then conItem = WZUIContainer:luaTo(conItem) end

    local _txt = WZUILabelTTF:create()
    _txt:setText(txt)
    _txt:setBoldFont(true)
    _txt:setRelativePosition(ccp(0.5,-0.2))
    _txt:setFontSize(18)
    _txt:setColor(ccc3(229,105,22))
    conItem:addChild(_txt)
end
--升星强化的角标
--is_txt 是否存在文字
function CellGoodItem:setProtomeSelect(file, anchor, pos, originSize, is_txt)
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    if not conItem then return end
    
    file = file or "ui/common/common_bq_3bts.png"
    anchor = anchor or ccp(0,0.5)
    pos = pos or ccp(0.05, 0.6)
    originSize = originSize or true
    local img_icon = WZUIImage:create()
    img_icon:setAnchorPoint(anchor)
    img_icon:setRelativePosition(pos)
    img_icon:setUseOriginSize(originSize)
    img_icon:setFile(file)
    conItem:addChild(img_icon)
    img_icon:setTag(4033)
    if is_txt then
        img_icon:setScale(0.78)
        local _txt = WZUILabelTTF:create()
        _txt:setText(LocalStrings.CAN_GET)
        _txt:setRelativePosition(ccp(0.5,0.5))
        _txt:setFontSize(16)
        _txt:setColor(ccc3(154,255,23))
        _txt:setEnableStroke(true)
        _txt:setStrokeSize(4)
        _txt:setStrokeColor(ccc3(0,97,8))
        img_icon:addChild(_txt,10)
    end
end

function CellGoodItem:setRemoveProtomeSelect()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    if not conItem then return end
    
    if conItem:getChildByTag(4033) then
        conItem:removeChildByTag(4033,true)
    end
end

--@brief    设置装备星级显示与否
function CellGoodItem:setStarLevelVisible(bVisible, levelVisible, stoneAniVisible, chengAniVisible, starAniVisible)
    if self.m_root == nil then return end 

    if self.m_imgStart then 
        self.m_imgStart:setVisible(bVisible)
    end

    if self.m_labelLevel then 
        self.m_labelLevel:setVisible(levelVisible)
    end

    if stoneAniVisible ~= nil then 
        for i = 1, 4 do
            if self["m_aniStone".. i] then 
                self["m_aniStone"..i]:getAnimNode():setVisible(stoneAniVisible)
            end
        end
    end

    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    local spineNode = conItem:getChildByTag(421)
    if spineNode and chengAniVisible ~= nil then
        spineNode:setVisible(chengAniVisible)
    end

    if self.m_aniStar and starAniVisible ~= nil then 
        self.m_aniStar:getAnimNode():setVisible(starAniVisible)
    end
end

--@brief    设置品质框不可见
function CellGoodItem:setQualityFrameVisible(bVisible)
    if self.m_root == nil then return end 

    if bVisible ~= nil then 
        GetElement(self.m_root, "btnImg1_CellGoodItem", WZUI9Image):setVisible(bVisible)
        if self.m_imgBk2 then 
            self.m_imgBk2:setVisible(bVisible)
        end
    end
end

--@brief    显示调品边框
function CellGoodItem:showGradeFrame()
    local conItem = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)
    if conItem:getChildByTag(1212) then
        conItem:removeChildByTag(1212,true)
    end
    
    if self.m_tItem.extraInfo and self.m_tItem.extraInfo.orangeEquiGrade then
        local grade = SplitStringWithSeparator(self.m_tItem.extraInfo.orangeEquiGrade, "|")
        if grade[1] then
            if tonumber(grade[1]) >= 6 and tonumber(grade[1]) <= 15 then
                local imgGrade = WZUIImage:create()
                imgGrade:setTag(1212)
                imgGrade:setAnchorPoint(ccp(0.5,0.5))
                imgGrade:setRelativePosition(ccp(0.5,0.5))
                imgGrade:setUseOriginSize(true)
                imgGrade:setFile("ui/common/common_scale9_cheng_zp.png")
                conItem:addChild(imgGrade)
            elseif tonumber(grade[1]) >= 16 and tonumber(grade[1]) <= 25 then
                local imgGrade = WZUIImage:create()
                imgGrade:setTag(1212)
                imgGrade:setAnchorPoint(ccp(0.5,0.5))
                imgGrade:setRelativePosition(ccp(0.5,0.5))
                imgGrade:setUseOriginSize(true)
                imgGrade:setFile("ui/common/common_scale9_hong_jp.png")
                conItem:addChild(imgGrade)
            end
        end
    end
end

--@brief    添加限量角标
function CellGoodItem:_addNumLimit(strLimit)
--  WZLog("CellGoodItem:_addNumLimit")
    if self.m_root == nil then return end
    local con = GetElement(self.m_root,"conItem_CellGoodItem",WZUIContainer)

    local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    cornerIcon:setRelativePosition(GlobalMethod:ccp(0.35,0.65))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_xbth.png")
    cornerIcon:setScale(0.85)
    con:addChild(cornerIcon,9)

    local txt = WZUILabelTTF:create()
    txt:setFontSize(12)
    txt:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txt:setRelativePosition(GlobalMethod:ccp(0.2875,0.7625))
    txt:setColor(ccc3(255,236,193))
    txt:setText(strLimit)
    txt:setTouchEnable(false)
    txt:setEnableStroke(true)
    txt:setStrokeColor(ccc3(132,66,29))
    txt:setStrokeSize(4)
    txt:setBoldFont(true)
    txt:setRotation(-45)
    con:addChild(txt,10)
end

--@brief 设置底层背景图片
function CellGoodItem:setbtnImg2Pos(pos)
    if self.m_root == nil then return end
    local btnImg2 = GetElement(self.m_root, "btnImg2_CellGoodItem", WZUI9Image)
    btnImg2:setRelativePosition(GlobalMethod:ccp(pos[1], pos[2]))
end