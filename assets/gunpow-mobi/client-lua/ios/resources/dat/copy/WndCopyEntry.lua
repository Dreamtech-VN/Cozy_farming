--WndCopyEntry.lua
--@brief	WndCopyEntry的UI模块
--@date		2016/12/26
--@author	peiting_mao
--@note		副本入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyEntry:onEnter(element)
	self.m_root = element
	self:_addTop()
	self:_initText()
	AdaptLanguage(self)
    TeachGroup1:startGroup({1,3,self.m_root},{15,2,self.m_root},{29,2,self.m_root},CacheCenter:getPlayerInfo().level == 20 and {13,2,self.m_root} or nil)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyEntry:onExit(element)
	self:_unInit()
end

--@brief    触摸开始回调
function WndCopyEntry:onTouchBegin(element, pt)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

function WndCopyEntry:showScene(  )
    if self.m_root == nil then
        local wndCopyEntry = WndCopyEntry:createElement()
        WindowManager:addWindow(wndCopyEntry,WndCopyEntry)
    end
end


--@brief 	按钮点击事件
function WndCopyEntry:onFunctionClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	WZLog("--WndCopyEntry:tag--",tag)
	if tag == 1 then
		if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP) then
            TeachGroup1:endTeachStep({1,3},{29,2})
            GlobalGame.g_nSingleMapPage = nil
			SceneCopy:showScene(tag, nil, nil,nil,nil,false)
			WindowManager:removeWindow(self.m_root, self, true)
			
		end
	elseif tag == 2 then
		if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
			TeachGroup1:endTeachStep({15,2})
			SceneCopy:showScene(tag, nil, nil,true)
			WindowManager:removeWindow(self.m_root, self, true)
		end
	elseif tag == 3 then
		if CheckButtonOpen(ISLAND_BUILDING_DAILYMAP) then
			TeachGroup1:endTeachStep({13,2})
			SceneCopy:showScene(tag, nil, nil,true)
			WindowManager:removeWindow(self.m_root, self, true)
		end
	end
end

--@brief 	初始化文本
function WndCopyEntry:_initText(  )
	if CheckButtonOpen(ISLAND_BUILDING_DAILYMAP,false) then
		GetElement(self.m_root,"imgSuo3_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack3_WndCopyEntry",WZUIImage):setVisible(false)
	end
	if CheckButtonOpen(ISLAND_BUILDING_SINGLEMAP,false) then
		GetElement(self.m_root,"imgSuo1_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack1_WndCopyEntry",WZUIImage):setVisible(false)
	end
	if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP,false) then
		GetElement(self.m_root,"imgSuo2_WndCopyEntry",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgBlack2_WndCopyEntry",WZUIImage):setVisible(false)
	end

	local sex = CacheCenter:getPlayerInfo().sex --玩家性别
	local equip = CacheCenter:getPlayerItems() --玩家拥有的武器
	local tEquip = {}
	for k,v in pairs(equip) do
		if v.isUse == true then
			table.insert(tEquip, v)
		end
	end
	local headColor, bodyColor = CacheCenter:getHeadAndBodyColor() --玩家头部和身体颜色
	local conPlayer = GetElement(self.m_root,"conRole_WndCopyEntry",WZUIContainer)
	local player = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, headColor ,bodyColor)
	local pNode = player:getAnimNode()
	conPlayer:addChild(pNode)

	local pet = CacheCenter:getPlayerInfo().petInfo
	if pet then
		local conPet = GetElement(self.m_root,"conPet_WndCopyEntry",WZUIContainer)
		local ani,par =  CreatePetAni(conPet,pet.itemId,pet.animation,pet.advancedLevel, pet.petSkinItemId)
    end

    --判断是否显示小红点
    WndSingleCopy:_initData()
    local single = false
    for i = 0, WndSingleCopy.m_nCurCopyIndex do
        if WndSingleCopy:_getSectionRewardStateByIndex(1,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,1) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(1,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(2,i,2) == 2 or WndSingleCopy:_getSectionRewardStateByIndex(3,i,2) == 2 then
            single = true
            break
        end
    end
    WZLog("--WndCopyEntry:RedDot--",single)
  	GetElement(self.m_root,"imgRed_WndCopyEntry",WZUIImage):setVisible(single)

end

function WndCopyEntry:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_maoxian.png",WndCopyEntry,WndCopyEntry.onCloseClick,true,false,false,false)
end

function WndCopyEntry:onCloseClick(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
	if SceneCity.m_root then
		SceneCity:checkWelfare()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndCopyEntry:_adaptLanguage_th(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCopyEntry:_adaptLanguage_vn(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function WndCopyEntry:_adaptLanguage_pt(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setDimensions(GlobalMethod:CCSize(300))
end

function WndCopyEntry:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtSingle_WndCopyEntry",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtMult_WndCopyEntry",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtDaily_WndCopyEntry",WZUILabelTTF):setFontSize(18)
end

function WndCopyEntry:_adaptLanguage_tr(  )
	local txt = GetElement(self.m_root,"txt_WndCopyEntry",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txt:setDimensions(GlobalMethod:CCSize(380))
end
--------------------------------------语言适配End-------------------------------------------