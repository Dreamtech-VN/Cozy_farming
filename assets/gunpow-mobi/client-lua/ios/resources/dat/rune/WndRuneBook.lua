--WndRuneBook.lua
--@brief	WndRuneBook的UI模块
--@date		2017/03/14
--@author	peiting_mao
--@note		符文图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRuneBook:onEnter(element)
	self.m_root = element
	--ProtocolProcessorSceneRune:regAll()
	self:_addTop()
	self:_updateType()
	ProtocolProcessorSceneRune:send_RUNE_GetRuneList( )
	self:_adaptSize()
	AdaptLanguage(self)
	--self:_update(0)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRuneBook:onExit(element)
	self:_unInit()
	--ProtocolProcessorSceneRune:unregAll()
end

--@brief    触摸开始回调
function WndRuneBook:onTouchBegin(element)
    -- body
    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

function WndRuneBook:_addTop(  )
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/rune/common_icon_fuwentujian.png",WndRuneBook,WndRuneBook.onClose,true,false,false,"WndRuneBook",{goldType=8})

    self.m_topCellLua = tcell
end

function WndRuneBook:onClose(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	初始化默认的复选框
function WndRuneBook:_initCheckBox(  )
	--obj:setIsVisble(true)
	local checkBox = GetElement(self.m_root,"checkBox_WndRuneBook",WZUICheckBoxGroup)
	checkBox:setCheckIndex(0)
end

--@brief	筛选符文等级点击事件
function WndRuneBook:onCheckLevel( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self.levelTag = element:getTag()
	if self.preLevel ~= self.levelTag then
		self.preLevel = self.levelTag
		self:_update(self.typeTag)
	end
end

--@brief 	批量出售点击事件
function WndRuneBook:onSale( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("--WndRuneBook:onSale--")
	WndSellRune:showWindow(self.itemIds,self.itemNums,self.isUseds)
end

--@brief	获得符文点击事件
function WndRuneBook:onGetRune( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	SceneRuneLockDraw:show()
end

--@brief	符文图鉴类型切换
function WndRuneBook:onSelect( luaObj1, luaObj2)
	if luaObj1 ~= nil then
		luaObj1:setIsVisble(false)
		self.preCell = luaObj2
	end
end

--@brief	更新符文图鉴类型
function WndRuneBook:_updateType(  )
	local tab = GetElement(self.m_root,"tabType_WndRuneBook",WZUITableContainer)
	tab:cleanTable()
	--local pro = {0,PRO_HP,PRO_ATTACK,PRO_DEFEND,PRO_CRIT,PRO_REDUCECRIT,PRO_PHYSIQUE,PRO_FORCE,
					--PRO_ARMOR,PRO_AGILITY,PRO_LUCK,PRO_WRECKDEFENSE,PRO_INJURYFREE}
	local pro = {0,PRO_HP,PRO_ATTACK,PRO_DEFEND}
	for i=1,#pro do
		local tElement,tCell = CellRuneType:createElement()
		if tElement and tCell then
			tElement:setTag(i-1)
			tCell:setData(pro[i])
			tab:setCellElement(tElement)
			if i == 1 then
				self:_initCheckBox()
			end
		end
	end
	tab:getMoveElement():setPositionY(tab:getMinPosition().y)
end

--@brief	更新图鉴内容
function WndRuneBook:_update( tag )
	self.typeTag = tag
	local tab = GetElement(self.m_root,"tab_WndRuneBook",WZUITableContainer)
	local txtIsRune = GetElement(self.m_root,"txtIsRune_WndRuneBook",WZUILabelTTF)
	tab:cleanTable()
	txtIsRune:setVisible(false)
	local index = 1
	local num
	for k,v in pairs(GDatatab_item) do
		if v.main_type == 18 then
			num = 0
			if self.typeTag == 0 and self.levelTag == v.value then --判断是否展示全部的符文和筛选的符文等级
				if self.itemIds ~= nil then
					for i=1,#self.itemIds do --展示已拥有的符文
						if v.id == self.itemIds[i] then
							local elem,tCell = CellRuneBook:createElement()
							if elem and tCell then
								elem:setTag(index-1)
								tCell:setData(v,self.itemNums[i],self.isUseds[i],true)
								tab:setCellElement(elem)
								index = index + 1
							end
							num = 1
							break
						end
					end
				end
				if num == 0 then --未拥有符文
					local elem,tCell = CellRuneBook:createElement()
					if elem and tCell then
						elem:setTag(index-1)
						tCell:setData(v,nil,nil,false)
						tab:setCellElement(elem)
						index = index + 1
					end
				end
			else
				for i=1,#v.property do
					if self.typeTag == v.property[i][1] then
						if self.levelTag == v.value then
							if self.itemIds ~= nil then
								for i=1,#self.itemIds do --展示已拥有的符文
									if v.id == self.itemIds[i] then
										local elem,tCell = CellRuneBook:createElement()
										if elem and tCell then
											elem:setTag(index-1)
											tCell:setData(v,self.itemNums[i],self.isUseds[i],true)
											tab:setCellElement(elem)
											index = index + 1
										end
										num = 1
										break
									end
								end
							end
							if num == 0 then --未拥有符文
								local elem,tCell = CellRuneBook:createElement()
								if elem and tCell then
									elem:setTag(index-1)
									tCell:setData(v,nil,nil,false)
									tab:setCellElement(elem)
									index = index + 1
								end
							end
							break
						end
					end
				end
			end
		end
	end
	if index == 1 then --判断该类型的符文是否配置
		txtIsRune:setVisible(true)
	end
	tab:getMoveElement():setPositionY(tab:getMinPosition().y)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    屏幕适配
function WndRuneBook:_adaptSize()
    -- body
    --do return end 
    local conTop = GetElement(self.m_root, "conTop_WndRuneBook", WZUIContainer)
    local topOriginSize = conTop:getAbsContentSize()
    local conMid = GetElement(self.m_root, "conMiddle_WndRuneBook", WZUIContainer)
    local midOriginSize = conMid:getAbsContentSize()
    local conTotal = GetElement(self.m_root, "conTotal_WndRuneBook", WZUIContainer)
    local totalOriginSize = conTotal:getAbsContentSize()
    local tempScaleY = conTop:getScaleY()
    local tabType = GetElement(self.m_root, "tabType_WndRuneBook", WZUITableContainer)
    local tabOriginSize = tabType:getAbsContentSize()
    local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local conMidBg = GetElement(self.m_root, "conMidBg_WndRuneBook", WZUIContainer)

    local tempHeight = midOriginSize.height
    if tempScaleY < 1 then
        local scaleY = 1 / tempScaleY
        tempHeight = totalOriginSize.height * scaleY - 124
        
    --    conTotal:setAbsContentSize(GlobalMethod:CCSize(screenSize.width, totalOriginSize.height * scaleY))
    --    conTotal:updateRelativeSize()

        conMid:setAbsContentSize(GlobalMethod:CCSize(midOriginSize.width, tempHeight))
    	conMid:updateRelativeSize()
    	WZLog("7777777777777", tempHeight)

        local tab = GetElement(self.m_root, "tab_WndRuneBook", WZUITableContainer)
        local nCellHeight = tab:getCellElementHeight()
        tab:setCellElementHeight(nCellHeight / scaleY)

        -- local tabType = GetElement(self.m_root, "tabType_WndRuneBook", WZUITableContainer)
        -- nCellHeight = tabType:getCellElementHeight()
        -- tabType:setCellElementHeight(nCellHeight / scaleY)
    else

    end
--    tabType:setCellElementHeight(103/(0.972 * screenSize.width))
    
    conMidBg:setAbsContentSize(GlobalMethod:CCSize(screenSize.width, tempHeight))
    conMidBg:updateRelativeSize()
    WZLog("aaa",screenSize.width,topOriginSize.height)
    -- conTop:setAbsContentSize(GlobalMethod:CCSize(screenSize.width, topOriginSize.height))
    -- conTop:updateRelativeSize()

    local conBottomBG = GetElement(self.m_root, "conBottomBG_WndRuneBook", WZUIContainer)
    conBottomBG:setAbsContentSize(GlobalMethod:CCSize(screenSize.width, conBottomBG:getAbsContentSize().height))
    conBottomBG:updateRelativeSize()
end
-- function WndRuneBook:_adaptSize(  )
-- 	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
-- 	if screenSize.width == 1136 then
-- 		GetElement(self.m_root,"checkBox_WndRuneBook",WZUICheckBoxGroup):setRelativePosition(GlobalMethod:ccp(0.23,0.520318))
-- 		local conType = GetElement(self.m_root,"conType_WndRuneBook",WZUIContainer)
-- 		local tab = GetElement(self.m_root,"tab_WndRuneBook",WZUITableContainer)
-- 		tab:setCellElementHeight(0.38)
-- 		--tab:setAbsContentSize(GlobalMethod:CCSize(1110,440))
-- 		--tab:setNoBorder(true)
-- 		--tab:setShowAll(false)
-- 		--conType:setAbsContentSize(GlobalMethod:CCSize(100,55))
-- 		conType:setNoBorder(true)
-- 		conType:setShowAll(false)
-- 		conType:setRelativePosition(GlobalMethod:ccp(0.03,0.8483))
-- 		--conType:setRelativeSize(GlobalMethod:CCSize(3,1))
-- 		--conType:setAbsPosition(GlobalMethod:ccp(32.0817,541.469))
-- 		--conType:setUseAbsCoordinate(true)
-- 	elseif screenSize.width == 1024 then
-- 		WZLog("--WndRuneBook:_adaptSize--1")
-- 		local conType = GetElement(self.m_root,"conType_WndRuneBook",WZUIContainer)
-- 		--conType:setNoBorder(false)
-- 		--conType:setShowAll(true)
-- 		conType:setRelativePosition(GlobalMethod:ccp(0.03,0.842))
-- 		--conType:setRelativeSize(GlobalMethod:CCSize(0.7,1))
-- 		local tab = GetElement(self.m_root,"tab_WndRuneBook",WZUITableContainer)
-- 		tab:setAbsContentSize(GlobalMethod:CCSize(940,520))
-- 		tab:setCellElementHeight(0.285)
-- 	elseif screenSize.width >= 1136 then
-- 		local conType = GetElement(self.m_root,"conType_WndRuneBook",WZUIContainer)
-- 		conType:setNoBorder(true)
-- 		conType:setShowAll(false)
-- 		conType:setRelativePosition(GlobalMethod:ccp(0.03,0.8488))
-- 		local tab = GetElement(self.m_root,"tab_WndRuneBook",WZUITableContainer)
-- 		tab:setCellElementHeight(0.38)
-- 		--tab:setNoBorder(true)
-- 		--tab:setShowAll(false)
-- 	end
-- end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndRuneBook:_adaptLanguage_pt( )
	local txtTypeLv = GetElement(self.m_root,"txtTypeLv_WndRuneBook",WZUILabelTTF)
	txtTypeLv:setDimensions(GlobalMethod:CCSize(80,0))
	txtTypeLv:setFontSize(16)
	local txtSell = GetElement(self.m_root,"txtSell_WndRuneBook",WZUILabelTTF)
	txtSell:setDimensions(GlobalMethod:CCSize(130,0))
	txtSell:setFontSize(18)
	local txtChest = GetElement(self.m_root,"txtChest_WndRuneBook",WZUILabelTTF)
	txtChest:setFontSize(18)
end

function WndRuneBook:_adaptLanguage_es( )
	local txtTypeLv = GetElement(self.m_root,"txtTypeLv_WndRuneBook",WZUILabelTTF)
	txtTypeLv:setDimensions(GlobalMethod:CCSize(80,0))
	txtTypeLv:setFontSize(16)
	local txtSell = GetElement(self.m_root,"txtSell_WndRuneBook",WZUILabelTTF)
	txtSell:setDimensions(GlobalMethod:CCSize(130,0))
	txtSell:setFontSize(18)
	local txtChest = GetElement(self.m_root,"txtChest_WndRuneBook",WZUILabelTTF)
	txtChest:setFontSize(18)
end

function WndRuneBook:_adaptLanguage_tr( )
	local txtTypeLv = GetElement(self.m_root,"txtTypeLv_WndRuneBook",WZUILabelTTF)
	txtTypeLv:setDimensions(GlobalMethod:CCSize(80,0))
	txtTypeLv:setFontSize(16)

	local txtSell = GetElement(self.m_root,"txtSell_WndRuneBook",WZUILabelTTF)
	txtSell:setDimensions(GlobalMethod:CCSize(130,0))
	txtSell:setFontSize(18)
	
	local txtChest = GetElement(self.m_root,"txtChest_WndRuneBook",WZUILabelTTF)
	txtChest:setFontSize(18)
end
-------------------------------------语言适配End--------------------------------------------