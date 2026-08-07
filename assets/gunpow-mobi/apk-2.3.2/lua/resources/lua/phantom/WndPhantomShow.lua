--WndPhantomShow.lua
--@brief	WndPhantomShow的UI模块
--@date		2017/04/25
--@author	zsq
--@note		获得皮肤


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomShow:onEnter(element)
	self.m_root = element
end

function WndPhantomShow:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root, true, "onEnterCall", self)

	self:showPlayer()
	self:showBtn()
	AdaptLanguage(self)
end

function WndPhantomShow:onEnterCall() 
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomShow:onExit(element)
	self:_unInit()
end

function WndPhantomShow:onClose(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)

	if WndPhantom.m_root ~= nil then
		WndPhantom.m_root:setVisible(true)
	end
	if WndPhantomChest.m_root ~= nil then
		WndPhantomChest.m_root:setVisible(true)
	end

	if WndPhantomChest.m_root ~= nil then
		GetElement(WndPhantomChest.m_root,"conChest",WZUIContainer):setVisible(true)
	end
end

--@brief 	点击使用按钮回调
function WndPhantomShow:onClickUse(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.equipData then
		g_UsingPhantomData = CopyTable(self.m_tData.equipData)
		ProtocolProcessorPhantom:send_SHAPE_UseItem(self.m_tData.equipData.playerItemId)
	end
end

--@brief	显示接口
function WndPhantomShow:show(tData)
	WZLog("WndPhantomShow:show")
	self.m_tData = tData
	local wnd = WndPhantomShow:createElement()
	WindowManager:addWindow(wnd, WndPhantomShow, nil, nil, true)

	if WndPhantom.m_root ~= nil then
		WndPhantom.m_root:setVisible(false)
	end
	if WndPhantomChest.m_root ~= nil then
		WndPhantomChest.m_root:setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示人物形象
function WndPhantomShow:showPlayer()
	WZLog("WndPhantomShow:showPlayer")
	if self.m_root == nil then return end
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end

	local tData = self.m_tData
	local playerInfo = CacheCenter:getPlayerInfo()
	local sex = playerInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conPhantom"))
    if not self.conPlayer then
		local conPlayer
      	conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true,tData.shapeId)
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.5))
       	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))

        self.conPlayer = conPlayer
        conP:addChild(conPlayer:getAnimNode(),5)
    end

	local tPhantom = GDatatab_shape_skins["id_"..tData.shapeId]
	--皮肤名字
	GetElement(self.m_root,"ttf_WndPhantomShow",WZUILabelTTF):setText(tPhantom.name)
	GetElement(self.m_root,"ttf_WndPhantomShow",WZUILabelTTF):setColor(QUALITYCOLOR[tPhantom.quality])
	--皮肤技能
	local skillId = tPhantom.passive_skill[1][1]
	local tSkill = GDatatab_skill["id_"..skillId]
	--GetElement(self.m_root,"ttf1_WndPhantomShow",WZUILabelTTF):setText(LocalStrings.PHANTOM29..":"..tSkill.tool_desc)
	--体验时间/幻力值
	if tData.remainTime == -1 then
		WndPhantom.show = 1
		GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setText(LocalStrings.PHANTOM8)
		GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(ccp(0.48,0.192))
		GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setText("+"..tPhantom.shape_exp)
		GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setVisible(true)
		if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
			GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(ccp(0.46,0.192))
			GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(ccp(0.55,0.192))
		end
	else
			local time = math.ceil(tData.remainTime/86400)
			if time == 0 then time = 1 end
		GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setText(string.format(LocalStrings.PHANTOM18,time))
		GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(ccp(0.5,0.192))
		GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setVisible(false)
	end
	if tData.changeItemId and #tData.changeItemId > 0 then
		local s = LocalStrings.PHANTOM24
		local num = 0
		for i=1,#tData.changeItemId do
			num = num + tData.changeNum[i]
		end
		s = s..GDatatab_item["id_"..tData.changeItemId[1]].name.."X"..num
		GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setText(s)
		GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setVisible(false)
	end
end

--@brief 	展示按钮
function WndPhantomShow:showBtn()
	-- body
	local tData = self.m_tData
	local btnSure = GetElement(self.m_root, "btnSure_WndPhantomShow", WZUIButton)
	local btnUse = GetElement(self.m_root, "btnUse_WndPhantomShow", WZUIButton)

	local haveNum = 0
	if tData.equipData.id and tData.equipData.id > 0 then 
		haveNum = CacheCenter:getPlayerItemCountById(tData.equipData.id)
	end

	if haveNum > 0 then
		btnSure:setVisible(true)
		btnUse:setVisible(true)
		btnSure:setRelativePosition(GlobalMethod:ccp(0.4,0.08))
		btnUse:setRelativePosition(GlobalMethod:ccp(0.6,0.08))
	else
		btnUse:setVisible(false)
		btnSure:setRelativePosition(GlobalMethod:ccp(0.5,0.08))
	end
end



-------------------------------------私有方法模块End----------------------------------------


-- --------------------------------------语言适配Begin-----------------------------------------
-- function WndPhantomShow:_adaptLanguage_th(  )
-- 	GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.192))
-- 	GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.192))
-- end

function WndPhantomShow:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.192))
	GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.192))
end

function WndPhantomShow:_adaptLanguage_pt(  )
	GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.192))
	GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.192))
end

function WndPhantomShow:_adaptLanguage_es(  )
	GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.192))
	GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.192))
end

function WndPhantomShow:_adaptLanguage_tr(  )
	GetElement(self.m_root,"ttf2_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.46,0.192))
	GetElement(self.m_root,"ttf3_WndPhantomShow",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.192))
end
---------------------------------------语言适配End------------------------------------------