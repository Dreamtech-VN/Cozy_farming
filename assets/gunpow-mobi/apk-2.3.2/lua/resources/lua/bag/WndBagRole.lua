--WndBagRole.lua
--@brief	WndBagRole的UI模块
--@date		2017/07/07
--@author	zsq
--@note		玩家背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBagRole:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndBag:regAll()
	ProtocolProcessorWndMonthCards:regAll()
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief	加载完成
function WndBagRole:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	self:_addEquip()
	self:_addPlayer()
	self.m_nVigor = CacheCenter:getPlayerInfo().vigor

    self:setExchangeExp()

	local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
	if isEndTeach8 ~= true and step8 > 0 and step8 < 5 then
	    TeachGroup1:startGroup({8,4,WndBagRole.m_root})
	end
end

--@brief	更新红点
function WndBagRole:updateRedDot()
	if self.m_root == nil then
		return
	end

	--一键装备按钮红点
	local equipList = CacheCenter:getEquipList()
	local bHasRecommended = false
	for k,v in pairs(equipList) do
		if v.recommended == true then
			bHasRecommended = true
			break
		end
	end
	local imgEquipAllRedDot = GetElement(self.m_root,"imgEquipAllRedDot_WndBag",WZUIImage)
	imgEquipAllRedDot:setVisible(bHasRecommended)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBagRole:onExit(element)
	self:_unInit()
	ProtocolProcessorWndBag:unregAll()
	ProtocolProcessorWndMonthCards:unregAll()
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndBagRole:onCloseClick(element)
    WZLog("WndBagRole:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then return end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	背包接口
function WndBagRole:showWin()
	WZLog("WndBagRole:showBag")
	-- local wnd = WndBagRole:createElement()
	-- WindowManager:addWindow(wnd, WndBagRole, nil, nil, true)
	if WndBagMain.m_root == nil then return end
	local wndBagRole = WndBagRole:createElement()
	GetElement(WndBagMain.m_root,"conSubWin",WZUIContainer):addChild(wndBagRole)
end

--@brief   添加右侧背包栏
function WndBagRole:_addEquip()
	local conPlayer = self.m_root:getChildElement("conRight_WndBag")
	local celElement = WndEquipNew:createElement()
	if conPlayer:getChildByTag(1) then
		conPlayer:removeChildByTag(1,true)
	end
	celElement:setTag(1)
	WndEquipNew:setItemBackFun(WndBag,WndBag.onItemClick,self.onItem)
	conPlayer:addChild(celElement)
end

--@brief   添加人物形象和装备栏
function WndBagRole:_addPlayer()
	local conPlayer = self.m_root:getChildElement("conRoleEquip_WndBag")
	if conPlayer:getChildByTag(20) then
		conPlayer:removeChildByTag(20,true)
	end
	local celElement = WndPlayer:createElement()
	celElement:setTag(20)
	conPlayer:addChild(celElement)
	WndPlayer.m_bCheckOther = false
	--隐藏角色脚下投影imgYY	
	if WndPlayer and WndPlayer.m_root then
		local imgYY_player = WndPlayer.m_root:getChildElement("imgYY")
		if imgYY_player then
			imgYY_player:setVisible(false)
		end
	end
	if ProjConfig.LANGUAGE == "vn" then
		local btnEquipAll = GetElement(self.m_root,"btnEquipAll_WndBagRole",WZUIButton)
		btnEquipAll:setAbsContentSize(GlobalMethod:CCSize(100,36))
		btnEquipAll:updateRelativeSize()
	end
end


--@brief	背包标签：一键装备
--@brief	时装标签：时装属性
function WndBagRole:onSwitchBtn()
	WZLog("WndBagRole:onSwitchBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
	if isEndTeach8 ~= true and step8 > 0 then
		TeachGroup1:endTeachStep({8,4})
	end

	--一键换装
	local equipList = CacheCenter:getEquipList()
	local id = WZLuaVector_int_:create()
	local sell = false
	local tEquipList = {}
	for k,v in pairs(equipList) do
		if v.recommended == true then
        	id:push(v.playerItemId)
			sell = true

			table.insert(tEquipList, CopyTable(v))
		end
	end
	WZLog("要换上的装备是",Serialize(VectorToTable(id)))
	if sell == true then
		WndWorldBoss:showWnd(tEquipList, id)
	end
end

--@brief	汇总属性tip
function WndBagRole:onTotalAttrTip(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	WndPropertyInfo:show(CacheCenter:getPlayerInfo())
end


--@brief    转化
function WndBagRole:onClickExchange(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndExchangeExp:showInterface()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
