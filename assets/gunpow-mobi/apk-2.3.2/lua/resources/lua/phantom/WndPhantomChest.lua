--WndPhantomChest.lua
--@brief	WndPhantomChest的UI模块
--@date		2017/04/25
--@author	zsq
--@note		幻化主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomChest:onEnter(element)
	self.m_root = element
	self:_adaptationIphoneX()
	AdaptLanguage(self)
end

--@brief	加载动画
function WndPhantomChest:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"desc1",WZUIFreeTextBox):setShowText(LocalStrings.PHANTOM4)
	GetElement(self.m_root,"desc2",WZUIFreeTextBox):setShowText(LocalStrings.PHANTOM5)
	GetElement(self.m_root,"desc3",WZUIFreeTextBox):setShowText(LocalStrings.PHANTOM6)

	for i=1,3 do
		if GDatatab_shape_box ~= nil and GDatatab_shape_box["id_"..i] ~= nil then
			local cost = GDatatab_shape_box["id_"..i].cost
			GetElement(self.m_root,"cost"..i,WZUILabelTTF):setText(cost[1][2])
		end
	end 
	local num = CacheCenter:getPlayerItemCountById(61)
	local txtNum = GetElement(self.m_root,"storeNum_wndPhantomChest",WZUILabelTTF)
	txtNum:setText(num)
end

function WndPhantomChest:addCoin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(61)	
	-- body
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomChest:onExit(element)
	self:_unInit()
end

--@brief
function WndPhantomChest:onClickClose( )
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)	
end

--@brief	背包接口
function WndPhantomChest:show()
	WZLog("WndPhantomChest:show")
	--if self.m_root == nil then  不需要判断，创建时如果之前有背包窗口，会先移除
		local wnd = WndPhantomChest:createElement()
		WindowManager:addWindow(wnd, WndPhantomChest, nil, nil, true,true)
		-- WndSummonEntrance:showInterface(4)
	--end
end

function WndPhantomChest:onChest1() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断货币是否足够开启宝箱
	local cost = GDatatab_shape_box["id_1"].cost
	-- self.m_nTag = 1
	if JudgeMoneyIsEnough(cost[1][1], cost[1][2],nil,nil,201) then
		ProtocolProcessorPhantom:send_SHAPE_OpenBox(1 )
	end
end

function WndPhantomChest:onChest2() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断货币是否足够开启宝箱
	local cost = GDatatab_shape_box["id_2"].cost
	-- self.m_nTag = 2
	if JudgeMoneyIsEnough(cost[1][1], cost[1][2],nil,nil,201) then
		ProtocolProcessorPhantom:send_SHAPE_OpenBox(2 )
	end
end

function WndPhantomChest:onChest3() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断货币是否足够开启宝箱
	local cost = GDatatab_shape_box["id_3"].cost
	-- self.m_nTag = 3
	if JudgeMoneyIsEnough(cost[1][1], cost[1][2],nil,nil,201) then
		ProtocolProcessorPhantom:send_SHAPE_OpenBox(3 )
	end
end

function WndPhantomChest:updateCoin()
	-- body
	local num = CacheCenter:getPlayerItemCountById(61)
	local txtNum = GetElement(self.m_root,"storeNum_wndPhantomChest",WZUILabelTTF)
	txtNum:setText(num)
end

--@brief	幻化规则
function WndPhantomChest:onRule() 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PHANTOM_CHEST_DESC)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPhantomChest:getSkin(tData) 
		self.m_tData = tData
	-- GetElement(self.m_root,"conChest",WZUIContainer):setVisible(false)


	GetElement(self.m_root,"conShelter_WndPhantomChest",WZUIContainer):setVisible(true)	--遮罩
	
	local spineBox = GetElement(self.m_root,"spineBox_WndPhantomChest",WZUISpine)
	spineBox:play("box2_open", false)
	self.m_root:enableSchedule("getSkinCall",3.6)
end

function WndPhantomChest:getSkinCall() 
	self.m_root:disableSchedule()

	GetElement(self.m_root,"conShelter_WndPhantomChest",WZUIContainer):setVisible(false)	--遮罩

	local spineBox = GetElement(self.m_root,"spineBox_WndPhantomChest",WZUISpine)
	spineBox:play("box2", true)

	WndPhantomShow:show(self.m_tData)
end



--适配iphoneX
function WndPhantomChest:_adaptationIphoneX()
    -- body
    WZLog("WndPhantomChest:_adaptationIphoneX")
    if IsIphoneX() then
		local btnExplain = GetElement(self.m_root,"btnExplain_WndPhantomChest",WZUIButton)
		btnExplain:setRelativePosition(GlobalMethod:ccp(0.9,0.4))
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndPhantomChest:_adaptLanguage_en(  )
	for i=1,3 do
		local desc = GetElement(self.m_root,"desc"..i,WZUIFreeTextBox)
		desc:setMaxWidth(260)
		local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_WndPhantomChest",WZUILabelTTF)
		txtBtn:setScale(0.8)
	end
end

function WndPhantomChest:_adaptLanguage_tr(  )
	GetElement(self.m_root,"desc1",WZUIFreeTextBox):setScale(0.75)
	GetElement(self.m_root,"desc2",WZUIFreeTextBox):setScale(0.75)
	GetElement(self.m_root,"desc3",WZUIFreeTextBox):setScale(0.75)
end

function WndPhantomChest:_adaptLanguage_vn(  )
	GetElement(self.m_root,"desc1",WZUIFreeTextBox):setScale(0.8)
	GetElement(self.m_root,"desc2",WZUIFreeTextBox):setScale(0.8)
	GetElement(self.m_root,"desc3",WZUIFreeTextBox):setScale(0.8)
end

function WndPhantomChest:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtBtn1_WndPhantomChest",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtBtn2_WndPhantomChest",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtBtn3_WndPhantomChest",WZUILabelTTF):setScale(0.8)
end

function WndPhantomChest:_adaptLanguage_pt(  )
	for i=1,3 do
		local desc = GetElement(self.m_root,"desc"..i,WZUIFreeTextBox)
		desc:setScale(0.7)
		desc:setMaxWidth(320)
		local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_WndPhantomChest",WZUILabelTTF)
		txtBtn:setScale(0.8)
	end
end

function WndPhantomChest:_adaptLanguage_es(  )
	for i=1,3 do
		local desc = GetElement(self.m_root,"desc"..i,WZUIFreeTextBox)
		desc:setScale(0.7)
		desc:setMaxWidth(320)
		local txtBtn = GetElement(self.m_root,"txtBtn"..i.."_WndPhantomChest",WZUILabelTTF)
		txtBtn:setScale(0.8)
	end
end
-------------------------------------语言适配End--------------------------------------------