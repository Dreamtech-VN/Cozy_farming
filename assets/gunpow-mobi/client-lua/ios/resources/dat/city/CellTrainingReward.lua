--CellTrainingReward.lua
--@brief	CellTrainingReward的UI模块
--@date     2017/02/13
--@author   jianfeng_mo
--@note     训练营奖励

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTrainingReward:onEnter(element)
	self.m_root = element
	--WZUIButton:luaTo(self.m_root:getChildElement("btnClick_CellTrainingReward")):setLocalInterval(1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTrainingReward:onExit(element)
	self:_unInit() 
end

--@brief	回调函数
function CellTrainingReward:onBackClick(element)
    WZLog("********************* CellTrainingReward:onBackClick ********************* ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 8 and TeachGroup1.STEP == 5
	if self.m_tBackFun and isTeach ~= true then
		local tag = self.m_root:getTag()
        if self.m_nType == 4 or self.m_nType == 16 or self.m_nType == 10 or self.m_nType == 11 then 
            local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
            conItem = WZUIContainer:luaTo(conItem)
            conItem:removeChildByTag(999,true)
        end 
		self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tItem,conItem)
	end
end

--@brief 物品品质
function CellTrainingReward:setQuality(quality)
    do return end
	WZLog("CellTrainingReward:setQuality",quality)
    if quality == nil then
       quality = 5
    end

	if quality == 4 then self:_createChengAni() end

	local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/common_scale9_beibaodi1.png"}
	local qualityPic5 = {"ui/common/common_icon_lg.png",
					"ui/common/common_icon_ng.png",
					"ui/common/common_icon_zg.png",
					"ui/common/common_icon_hg.png"}
	local qualityPic2 = {"ui/common/common_icon_szlv.png",
					"ui/common/common_icon_szlan.png",
					"ui/common/common_icon_szzi.png",
					"ui/common/common_icon_szcheng.png",
					"ui/common/common_icon_zbmoren.png"}
	local qualityPic16 = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
    
    local btnImg1 = GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image)
    local btnImg2 = GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image)
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
		btnImg1:setFile(qualityPic5[quality])
		btnImg2:setFile(qualityPic5[quality])
	end

    if btnImg1 and btnImg2 and self.m_nType == 14 then
    	local conItem = GetElement(self.m_root, "conItem_CellTrainingReward", WZUIContainer)
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
		--btnImg2:setFile(qualityPic2[quality])
   		btnImg2:setFile("ui/common/common_icon_szxz.png")
		btnImg2:setScale(1.03)
	end

    if btnImg1 and btnImg2 and self.m_nType == 16 then
		btnImg1:setFile(qualityPic16[quality])
		btnImg2:setFile(qualityPic16[quality])
	end

	if self.m_nType == 1 then
    	local conItem = GetElement(self.m_root, "conItem_CellTrainingReward", WZUIContainer)
    	if self.m_imgBk2 == nil then
    	    self.m_imgBk2 = WZUIImage:create()
    	    self.m_imgBk2:setAnchorPoint(ccp(0.5,0.5))
    	    self.m_imgBk2:setRelativePosition(ccp(0.5,0.5))
    	    self.m_imgBk2:setUseOriginSize(true)
			self.m_imgBk2:setFile(qualityPic16[quality])
    	    conItem:addChild(self.m_imgBk2)
    	end
	end

	if self.m_nType == 2 or self.m_nType == 4 or self.m_nType == 16 or self.m_nType == 17 or self.m_nType == 13 or self.m_nType == 11 then
    	local conItem = GetElement(self.m_root, "conItem_CellTrainingReward", WZUIContainer)
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


--@brief	物品所有属性容器是否可见
function CellTrainingReward:setConItemVisible(bShow)
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
		conItem:setVisible(bShow)
	end
end

--@brief	物品数量
function CellTrainingReward:setItemCount(count)
	if self.m_root == nil then return end
	if count == nil then
       return
    end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
	if conItem then
		conItem = WZUIContainer:luaTo(conItem)
	end
    if self.m_nType == 16 or self.m_nType == 17 then
        if self.m_tItem.basicInfo then
            if self.m_tItem.basicInfo.main_type == 5 then 
                local pos = {x=0.5, y=0}
                if count == -1 then
                    if self.m_imgCornerIcon == nil then
                        self.m_imgCornerIcon = WZUIImage:create()
                        self.m_imgCornerIcon:setAnchorPoint(ccp(0,1))
                        self.m_imgCornerIcon:setRelativePosition(pos)--ccp(-0.03,1.03))
                        self.m_imgCornerIcon:setUseOriginSize(true)
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                        conItem:addChild(self.m_imgCornerIcon, 2)
                        WZLog("CellTrainingReward:setItemCount1")
                    else
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_yongjiu.png")
                    end
                else
                    if self.m_imgCornerIcon == nil then
                        self.m_imgCornerIcon = WZUIImage:create()
                        self.m_imgCornerIcon:setAnchorPoint(ccp(0,1))
                        self.m_imgCornerIcon:setRelativePosition(pos)
                        self.m_imgCornerIcon:setUseOriginSize(true)
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_ts.png")
                        conItem:addChild(self.m_imgCornerIcon, 2)
                        WZLog("CellTrainingReward:setItemCount2")
                    else
                        self.m_imgCornerIcon:setFile("ui/common/common_icon_ts.png")
                    end
                    self.m_imgCornerIcon:removeAllChildrenWithCleanup(true)
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
                end
                return
            end
        end
    end
	if self.m_txtCount == nil then
		self.m_txtCount = WZUILabelTTF:create()
		self.m_txtCount:setText(count)
        self.m_txtCount:setAnchorPoint(ccp(0,0.5))
        self.m_txtCount:setRelativePosition(ccp(0.4,0.45))
        self.m_txtCount:setColor(ccc3(255,255,255))
        self.m_txtCount:setFontSize(26)
        self.m_txtCount:setAlignment(kCCTextAlignmentRight)
        self.m_txtCount:setEnableStroke(true)
        self.m_txtCount:setStrokeColor(ccc3(79,60,48))
        self.m_txtCount:setStrokeSize(2)
        self.m_txtCount:setBoldFont(true)
        conItem:addChild(self.m_txtCount,100,0)
        WZLog("CellTrainingReward:setItemCount3", self.m_txtCount)
    else
        self.m_txtCount:setText(count)
	end
end

--@brief	设置数字颜色
function CellTrainingReward:setNumColor(color, strokeColor)
	if self.m_txtCount == nil then return end
    self.m_txtCount:setColor(color)
    self.m_txtCount:setStrokeColor(strokeColor)
end

--@brief	物品图片
function CellTrainingReward:setItemIcon(icon)
	if self.m_root == nil then return end
	if icon == nil then return end
    local conItem = self.m_root:getChildElement("btnClick_CellTrainingReward")
	if conItem then
		conItem = WZUIButton:luaTo(conItem)
	end
	local order = 2
	if self.m_nType == 5 then order = 5 end
    if self.m_imgItem == nil then
        self.m_imgItem = WZUIImage:create()
        self.m_imgItem:setZOrder(order)
        self.m_imgItem:setTag(8)
        self.m_imgItem:setUseOriginSize(true)
        conItem:addChild(self.m_imgItem)
        self.m_imgItem:setScale(0.5)
        self.m_imgItem:setAnchorPoint(ccp(0,0.5))
        self.m_imgItem:setRelativePosition(ccp(0.0,0.5))
        Teach:isStartTeach("CellTrainingReward:setItemIcon")
    end
    self.m_imgItem:setFile(icon)
    return self.m_imgItem
end

--@brief	物品名称
function CellTrainingReward:setItemName(sName,nQuality)
	if self.m_root == nil then return end
    if sName == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:setItemNumber(count)
    if count == nil then return end

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
function CellTrainingReward:setWear()
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
	conItem = WZUIContainer:luaTo(conItem)
	if self.m_imgWear == nil then
		self.m_imgWear = WZUIImage:create()
		self.m_imgWear:setFile("ui/bag/common_icon_yizhuangbei.png")
		self.m_imgWear:setUseOriginSize(true)
		self.m_imgWear:setRelativePosition(ccp(0.31,0.63))
        conItem:addChild(self.m_imgWear,19)
	end
end
--@brief	设置是否高亮格子
--@param _bIsShow:true/false
function CellTrainingReward:setHightLightVisible(_bIsShow)
   if self.m_hightLight then
       self.m_hightLight:setVisible(_bIsShow)
    end
end
--@brief 开关锁的显示
--@param true/false
function CellTrainingReward:showLock()
    self:_showLock()
end

--@brief    锁定cell
--@author   hyq
function CellTrainingReward:lockCell()
	if self.m_root == nil then return end
    --不可触摸
    self.m_root:setTouchEnable(false)
end
--@brief    解锁cell
--@author   hyq
function CellTrainingReward:unLockCell()
	if self.m_root == nil then return end
    self.m_root:setTouchEnable(true)
end
--@brief 开关选择图标的显示
--@param true/false
function CellTrainingReward:showSeletedImg(bShow)
    if self.m_seletedImg then
        self.m_seletedImg:setVisible(bShow)
    end
end
--@brief 开关已装备的显示
--@param bShow:true/false
function CellTrainingReward:showWear(bShow)
    if self.m_imgWear then
        self.m_imgWear:setVisible(bShow)
    end
end
--@brief 格子动画的显示
--@param bShow:true/false
function CellTrainingReward:showAnimation(bShow)
    if self.m_animation then
        self.m_animation:setVisible(bShow)
    end
end
--@brief 获取锁的状态
function CellTrainingReward:getLock()
    if self.m_lock then
        return self.m_lock:isVisible()
    end
    return nil
end
--@brief 获取已装备图标的状态
function CellTrainingReward:getWearVisible()
    if self.m_imgWear then
        return self.m_imgWear:isVisible()
    end
    return nil
end
--@brief 获取选择的状态
function CellTrainingReward:getSeleted()
    if self.m_seletedImg then
        return self.m_seletedImg:isVisible()
    end
    return nil
end

--@brief 清空格子的所有子节点
function CellTrainingReward:removeAllChild()
	if self.m_root == nil then return end

	--删除物品图片，物品图片加在按钮上
    local btnItem = GetElement(self.m_root, "btnClick_CellTrainingReward", WZUIButton)
	if btnItem:getChildByTag(8) then
		btnItem:removeChildByTag(8,true)
	end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
    conItem = WZUIContainer:luaTo(conItem)
    conItem:removeAllChildrenWithCleanup(true)

	GetElement(self.m_root,"btnImg_CellTrainingReward",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
	GetElement(self.m_root,"btnImg1_CellTrainingReward",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
	GetElement(self.m_root,"btnImg2_CellTrainingReward",WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")

	if self.m_nType == 14 then
   		GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   		GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
	end

    self.m_tItem = nil
    self:_resetItem()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellTrainingReward:_update()
    if self.m_root == nil then return end
	--删除物品图片，物品图片加在按钮上
    local btnItem = GetElement(self.m_root, "btnClick_CellTrainingReward", WZUIButton)
	if btnItem:getChildByTag(8) then
		btnItem:removeChildByTag(8,true)
	end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
    conItem:removeAllChildrenWithCleanup(true)
    self:_resetItem()
    
	if self.m_tItem == nil then return end
    
	--显示物品图片
    if self.m_tItem.basicInfo == nil then
        self:setQuality(self.m_tItem.quality)
        self:setItemIcon(self.m_tItem.icon)--显示物品图片
    else
        self:setQuality(self.m_tItem.basicInfo.quality)
        self:setItemIcon(self.m_tItem.basicInfo.icon)--显示物品图片
    end
    
    if self.m_nType == 1 then
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showLevel()
        self:_showStone()
        self:_setStart()
    elseif self.m_nType == 2 then
        if self.m_tItem.isUse == nil or self.m_tItem.isUse ~= true then
            self:_showRecommend()
        end
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
        self:_showItemDate()
        self:_showWear()
        self:_showItemNum()
		self:showLock()
		self:showExtraInfo()
    elseif self.m_nType == 3 then
        self:_showItemNum()
        self:_hightlight()
		self:showLock()
    elseif self.m_nType == 4 then
        self:_showItemNum()
		self:showLock()
    	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 5 then
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setVisible(false)
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
    	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 9 then
        self:_showWear()
    elseif self.m_nType == 10 then
        self:_showItemNum()
		self:_showSell()
		self:showExtraInfo()
    	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 11 then
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 12 then
        self:_showItemNum()
		if self.m_tItem.own == true then
			self:_addSidebarOwn()
		end
        self:_showWear()
    	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	elseif self.m_nType == 13 then
		self:_addSidebarTime()
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	elseif self.m_nType == 14 then
		self:_addSidebarTime()
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 15 then
		self:_setBgImgVisible(false)
    elseif self.m_nType == 16 then
        self:_showItemNum()
        GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 17 then
        self:_showItemNum()
        GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    elseif self.m_nType == 18 then
   		GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		self:_addSidebarTime()
    elseif self.m_nType == 19 then
        self:_showItemNum()
        self:_showStone()
        GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
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
    	local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
    	local img = WZUIImage:create()
    	img:setZOrder(99969)
   		conItem:addChild(img)
    	img:setFile("ui/common/common_icon_suipian.png")
		--img:setUseOriginSize(true)
		img:setOpacity(255)
		img:setScale(0.4)
		img:setRelativePosition(ccp(0.72,0.7))
	end
end

function CellTrainingReward:showExtraInfo()
	if self.m_tItem == nil then return end
    if self.m_tItem.extraInfo == nil then return end
	if self.m_tItem.basicInfo.main_type == 4 then
       	self:_showLevel()
       	self:_showStone()
    	self:_setStart()
	end
end

--@brief 设置时装格子背景图
function CellTrainingReward:setSZBg()
	WZLog("CellTrainingReward:setSZBg")
	if self.m_root == nil then return end
	self.m_nType = 14
   	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
   	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setScale(0.9)
   	GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   	--GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setFile("ui/common/common_icon_szxz.png")
   	GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setFile("ui/common/common_icon_zbmoren.png")
   	GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image):setVisible(true)
   	GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setVisible(true)
end

--@brief 设置背景图片是否可见
function CellTrainingReward:_setBgImgVisible(bool)
	if self.m_root == nil then return end
	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setVisible(bool)
	GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image):setVisible(bool)
	GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setVisible(bool)
end

--@brief 设置底层背景图片
function CellTrainingReward:setBackImgFile(fileName)
	if self.m_root == nil then return end
    GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile(fileName)
end

--@brief 	设置背景图片文件
function CellTrainingReward:_setRewardBg1()
	if self.m_root == nil then return end
   	GetElement(self.m_root, "btnImg_CellTrainingReward", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
end

--@brief	显示物品数量
function CellTrainingReward:_showItemNum()
	if self.m_tItem == nil then return end

    local count = nil
    if self.m_tItem.lastTime then
        count = self.m_tItem.lastTime
    end
    if self.m_tItem.lastNum then
        count = self.m_tItem.lastNum
    end
    if self.m_tItem.basicInfo then
        if self.m_tItem.basicInfo.main_type == 4 then
            if self.m_nType == 17 then 
                local conItem = GetElement(self.m_root, "conItem_CellTrainingReward", WZUIContainer)
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
	if tonumber(count) == -1 then
        if self.m_nType == 16 or self.m_nType == 17 then
            self:setItemCount(-1)
        else
    		self:setItemCount(LocalStrings.NOLIMIT)
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
function CellTrainingReward:_hightlight()
    WZLog("CellTrainingReward:_hightlight")
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:_stats()
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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

function CellTrainingReward:_showStats(bShow)
   if  self.m_stats then
       self.m_stats:setVisible(bShow)
   end
end


--@brief	物品数量是否可见
function CellTrainingReward:_setItemVisible(bShow)
	if self.m_root == nil then return end
	
	if self.m_txtCount then
		self.m_txtCount:setVisible(bShow)
--		self:_setItemBkVisible(bShow)
	end
end
--@brief	显示物品名称
function CellTrainingReward:_kaLevel(sLevel)
	if self.m_root == nil then return end
	if self.m_tItem == nil then return end
    if self.m_tItem.extraInfo == nil then return end
    
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:_showItemDate()
	if self.m_tItem == nil or self.m_tItem.expired == nil or self.m_tItem.expired ~= true or self.m_imgOutTime then
		return
	end
	 self:_setOUtTime()
end

--@brief	物品过期
function CellTrainingReward:_setOUtTime()
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
	conItem = WZUIContainer:luaTo(conItem)
	self.m_imgOutTime = WZUIImage:create()
	self.m_imgOutTime:setFile("common/text/expired.png")
	self.m_imgOutTime:setUseOriginSize(true)
	conItem:addChild(self.m_imgOutTime)
end

--@brief	物品背景是否可见
function CellTrainingReward:_setItemBkVisible(bShow)
	if self.m_root == nil then return end
	local imgBk = self.m_root:getChildElement("imgBk_CellTrainingReward")
	if imgBk then
		imgBk = WZUI9Image:luaTo(imgBk)
		imgBk:setVisible(bShow)
	end
end

--@brief	推荐
function CellTrainingReward:_showRecommend()
	if self.m_tItem == nil or self.m_tItem.recommended == nil or self.m_tItem.recommended ~= true or (self.m_tItem.isUse and self.m_tItem.isUse == true) then
		return
	end
	self:_setRecommend()
end

--@brief	显示推荐
function CellTrainingReward:_setRecommend()
	if self.m_root == nil then return end
	local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:_showWear()
	if self.m_tItem == nil or self.m_tItem.isUse == nil or self.m_tItem.isUse ~= true then
		return
	end
	self:setWear()
end

--@brief 锁
function CellTrainingReward:_showLock()
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
		local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
		self.m_lock = WZUIImage:create()
		self.m_lock:setScale(0.6)
		self.m_lock:setAnchorPoint(ccp(0,0))
        self.m_lock:setRelativePosition(ccp(0.05,0.05))
        self.m_lock:setUseOriginSize(true)
        self.m_lock:setFile("ui/hall/roomlist_lock.png")
        conItem:addChild(self.m_lock)
	end
end

--@brief	选中出售
function CellTrainingReward:_showSell()
    if self.m_root == nil or self.m_tItem == nil or self.m_tItem.sellHook == nil or self.m_tItem.sellHook == false then
		return
	end
	if self.m_sell == nil then
		local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
		local imgBg = WZUIImage:create()
		imgBg:setAnchorPoint(ccp(0.5,0.5))
        imgBg:setRelativePosition(ccp(0.5,0.5))
        imgBg:setUseOriginSize(true)
        imgBg:setFile("ui/common/common_shade_chushouheidi.png")
		imgBg:setOpacity(130)
        conItem:addChild(imgBg,198)

		self.m_sell = WZUIImage:create()
		self.m_sell:setAnchorPoint(ccp(0,0))
        self.m_sell:setRelativePosition(ccp(0.65,0.1))
        self.m_sell:setUseOriginSize(true)
        self.m_sell:setFile("ui/common/common_icon_gou.png")
        conItem:addChild(self.m_sell,199)
	end
end

--@brief	显示套装特效
function CellTrainingReward:_showSuitAni(itemSuitNum, itemSuitId)
	do return end
	WZLog("CellTrainingReward:_showSuitAni")
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
    local con = self.m_root:getChildElement("conItem_CellTrainingReward")
	if isSuit and itemSuitNum >= 3 and suitID == itemSuitId then
		local ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
	    ani:getAnimNode():setUseAbsCoordinate(true)
	    ani:getAnimNode():setAbsPosition(ccp(42,95))
	    ani:getAnimNode():setLoop(true)
	    --ani:getAnimNode():setScale(0.79)
	    con:addChild(ani:getAnimNode(),9)

		local aniName = {"taozhuang_lv","taozhuang_lan","taozhuang_zi","taozhuang_cheng"}
		ani:play(aniName[self.m_tItem.basicInfo.quality],true)	
	end
end

--@brief	显示物品等级
function CellTrainingReward:_showLevel()
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
function CellTrainingReward:_setLevel(level)
	if self.m_root == nil then return end
    if level == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
	if conItem then conItem = WZUIContainer:luaTo(conItem) end

	if self.m_labelLevel == nil then
		self.m_labelLevel = WZUILabelAtlasFont:create()
		self.m_labelLevel:setText(level)
        self.m_labelLevel:setRelativePosition(ccp(0.8,0.93))
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

--@brief	装备升星
function CellTrainingReward:_setStart()
	if self.m_root == nil then return end
	if self.m_tItem == nil or self.m_tItem.extraInfo == nil then
		return
	end
    
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
	local level = self.m_tItem.extraInfo.starLevel
	if level == 0 or level == nil then
		return
	end

	local sFile = "ui/common/common_icon_xingxing2.png"
	local nStartLevel
    
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
        nStartLevel:setRelativePosition(ccp(0.18,0.88))
        nStartLevel:setFontSize(16)
        nStartLevel:setColor(ccc3(255,255,255))
        conItem:addChild(nStartLevel)
    end
	if (self.m_nType == 10 or self.m_nType == 2) and (self.m_tItem.isUse == true or self.m_tItem.recommended == true) then
        self.m_imgStart:setVisible(false)
		if nStartLevel ~= nil then
			nStartLevel:setVisible(false)
		end
	end

	if level < 8 then return end

	if self.m_aniStar == nil then
		self.m_aniStar = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
        self.m_aniStar:getAnimNode():setUseAbsCoordinate(true)

        self.m_aniStar:getAnimNode():setAbsPosition(ccp(40,93))
        self.m_aniStar:getAnimNode():setLoop(true)
        conItem:addChild(self.m_aniStar:getAnimNode())
		if self.m_tItem.basicInfo.quality == 4 then
			if level == 8 or level == 9 then
				self.m_aniStar:play("shengxing_cheng",true)	
			elseif level == 10 or level == 11 then
				self.m_aniStar:play("shengxing_cheng2",true)	
			elseif level == 12 then
				self.m_aniStar:play("shengxing_cheng3",true)	
			end
		else
			if level == 8 or level == 9 then
				self.m_aniStar:play("shengxing_lv",true)	
			elseif level == 10 or level == 11 then
				self.m_aniStar:play("shengxing_lan",true)	
			elseif level == 12 then
				self.m_aniStar:play("shengxing_zi",true)	
			end
		end
	end
end

--@brief	强化栏适配动画位置
function CellTrainingReward:AdaptAniPosition()
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
function CellTrainingReward:_setMaxStart()
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
function CellTrainingReward:_showStone()
	if self.m_root == nil then return end
	if self.m_tStone == nil or #self.m_tStone == 0 then
		return
	end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
	local x = -0.01
	local hasStone = false
	local index = 1
	for i,data in pairs(self.m_tStone) do
		x = x + self.m_nSpace
        local image = self:_createImgStone(data.icon,ccp(x,0.25),0.24)
		conItem:addChild(image,10)
		self:_createAniStone(data,index,0+i*15)
		index = index + 1
		hasStone = true
	end
	--有宝石的话加上底图
	if hasStone then
        local image = self:_createImgStone("ui/common/common_scale9_di40.png",ccp(0.35,0.128),1,ccp(0.5,0.5),true)
		conItem:addChild(image)
	end
end

--@brief	装备镶嵌图片
function CellTrainingReward:_createImgStone(icon,pt,scale,anchor,bOrigin)
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
function CellTrainingReward:_createAniStone(tData,index,positionX)
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)
	local ani = self["m_aniStone"..index]
	WZLog("CellTrainingReward:_createAniStone","m_aniStone"..index)
	local level  = tData.value
	if level < 8 then return end
	if ani == nil then
		ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
        ani:getAnimNode():setUseAbsCoordinate(true)
        ani:getAnimNode():setAbsPosition(ccp(positionX,63))
        ani:getAnimNode():setLoop(true)
        conItem:addChild(ani:getAnimNode(),9)

		if level == 8 or level == 9 then
			ani:play("xiangqian_bai",true)	
		elseif level == 10 then
			ani:play("xiangqian_jin",true)	
		end
	end
	self["m_aniStone"..index] = ani
end

--@brief	橙装自带特效
function CellTrainingReward:_createChengAni()
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)
	if conItem:getChildByTag(421) then
		conItem:removeChildByTag(421,true)
	end
	local main_type 
	if self.m_tItem.basicInfo ~= nil then
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
   	spine:setRelativePosition(GlobalMethod:ccp(0.5,1.08))
	spine:play("cheng",true)
	spine:setScale(0.8)
   	conItem:addChild(spine,421,421)

	if main_type == 11 then
		spine:play("zuoqi_cheng", true)	
   		spine:setRelativePosition(GlobalMethod:ccp(0.5,1.1))
		spine:setScale(1)
	end
	end
end

--@brief	是否显示选中图标
function CellTrainingReward:_showSeletedImg()
	if self.m_root == nil then return end
    local conItem = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
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
function CellTrainingReward:GoodMark(nGoodsMark,nGoodsMarkNum)
	if self.m_root == nil then return end
    if nGoodsMark == nil then nGoodsMark = 0 end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:_hightLightAnimation()
	if self.m_root == nil then return end
    local conItem = self.m_root:getChildElement("conItem_CellTrainingReward")
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
function CellTrainingReward:_showChipMasking()
	if self.m_root == nil then return end
    local conItem = GetElement(self.m_root, "conItem_CellTrainingReward", WZUIContainer)
    if self.m_imgChipMask == nil then
        self.m_imgChipMask = WZUIImage:create()
        self.m_imgChipMask:setFile("ui/synthesis/suipian .png")
        self.m_imgChipMask:setScale(0.82)
        conItem:addChild(self.m_imgChipMask)
    end
end

--设置格子高亮
function CellTrainingReward:setHighLight(bool)
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root,"btnClick_CellTrainingReward",WZUIButton)
	if btn == nil then return end
    GetElement(self.m_root, "btnImg2_CellTrainingReward", WZUI9Image):setVisible(true)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--设置格子灰色
function CellTrainingReward:setGrayRender(bool)
	WZLog("CellTrainingReward:setGrayRender",bool)
	if self.m_root == nil then return end
    GetElement(self.m_root, "btnImg1_CellTrainingReward", WZUI9Image):setGrayRender(bool)
	if self.m_imgItem ~= nil then
		self.m_imgItem:setGrayRender(bool)
	end
	if self.m_imgBk2 ~= nil then
		self.m_imgBk2:setGrayRender(bool)
	end
end

--设置透明度
function CellTrainingReward:setOpacity(opacity)
	if self.m_imgItem ~= nil then
		self.m_imgItem:setOpacity(opacity)
	end
end
--    fadeTo:setOpacity(curFade)
-------------------------------------私有方法模块End----------------------------------------
--@brief	重置格子
function CellTrainingReward:_resetItem()
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
	self.m_imgCornerIcon = nil
end
--@brief	执行物品项被选中动作
function CellTrainingReward:_runSelectedAction(scaleTo,scaleEnd)
	if self.m_root == nil then return end
	scaleTo = scaleTo or 0.8
    local rootScale = self.m_root:getScale() or 1
    WZLog("rootScale===",rootScale)
	scaleEnd = scaleEnd or rootScale
	WZLog("CellTrainingReward:_runSelectedAction",scaleTo,scaleEnd)
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
function CellTrainingReward:showGetCondition(condition)
	if self.m_root == nil then return end
    WZLog("CellTrainingReward:showGetCondition")
    local con = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellTrainingReward"))
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
function CellTrainingReward:_addTryWear()
    WZLog("CellTrainingReward:_addTryWear")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)

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
function CellTrainingReward:_removeTryWear()
    WZLog("CellTrainingReward:_delTryWear")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)
    
	if conItem:getChildByTag(300) then
		conItem:removeChildByTag(300,true)
	end
end

--@brief	添加已拥有角标
function CellTrainingReward:_addSidebarOwn()
	WZLog("CellTrainingReward:_addSidebarOwn")
	if self.m_root == nil then return end
	local con = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    cornerIcon:setRelativePosition(GlobalMethod:ccp(0.325,0.64))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_yiyongyou.png")
	con:addChild(cornerIcon,9)
end

--@brief	添加过期时间角标
--@brief    nCount:時效
function CellTrainingReward:_addSidebarTime(nCount, position)
	WZLog("CellTrainingReward:_addSidebarTime")
	if self.m_root == nil then return end
	local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)

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

	if position ~= nil then
		cornerIcon:setRelativePosition(position)
	end
end

--@brief	添加价格角标
--@brief    price:价格
function CellTrainingReward:_addSidebarPrice(price)
	WZLog("CellTrainingReward:_addSidebarPrice",price,self.m_tItem.lastTime)
	if self.m_root == nil then return end

	--计算剩余天数
	local countdown = self.m_tItem.lastTime
	--if countdown == nil then return end
    if countdown ~= nil then return end
    --if countdown == -1 or countdown > 0 then return end

	local conItem = GetElement(self.m_root,"conItem_CellTrainingReward",WZUIContainer)

	local cornerIcon = WZUIImage:create()
    cornerIcon:setAnchorPoint(ccp(0,1))
    cornerIcon:setRelativePosition(ccp(-0.32,1.22))
    cornerIcon:setUseOriginSize(true)
    cornerIcon:setFile("ui/common/common_icon_hts.png")
    conItem:addChild(cornerIcon, 2000)
    --天
    local imgDay = WZUIImage:create()
    imgDay:setRelativePosition(ccp(0.16,0.47))
    imgDay:setFile("ui/common/common_icon_zuanshi.png")
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
	txtDayNum:setStrokeColor(ccc3(79,60,48))
	txtDayNum:setStrokeSize(4)
	txtDayNum:setBoldFont(true)
	txtDayNum:setTouchEnable(false)
	txtDayNum:setEnableStroke(true)
	txtDayNum:setColor(ccc3(255,255,255))
    cornerIcon:addChild(txtDayNum,1)
end
