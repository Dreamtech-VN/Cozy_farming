--CellFund.lua
--@brief	CellFund的UI模块
--@date		2015/11/03
--@author	zsq
--@note		基金Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFund:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFund:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新Cell
function CellFund:update(tData)
	WZLog("CellFund:update",Serialize(tData))
	if tData == nil then return end
	self.m_tData = tData

	--self:updateCell()
end

function CellFund:updateCell()
	if self.m_tData == nil then return end
	WZLog("CellFund:updateCell",WndFund.m_bBuy)
	local level = tonumber(self.m_tData.level)
	local get

	GetElement(self.m_root,"finish",WZUILabelTTF):setVisible(false)
	--xx级可领取
	GetElement(self.m_root,"ttf1_CellFund",WZUILabelAtlasFont):setText(level)
	for k,v in pairs(GDatatab_fund_grow) do
		if v.level == level then
			get = v.diamond
			break 
		end
	end
	--图标
	local imgFundIcon = GetElement(self.m_root,"imgFundIcon_CellFund",WZUIImage)
	imgFundIcon:setFile(GDatatab_item["id_" .. get[1][1]].icon)
	--品质
	local QUALITY_RECT = {"ui/common/common_scale9_lv.png", "ui/common/common_scale9_lan.png", "ui/common/common_scale9_zi.png", "ui/common/common_scale9_cheng.png", "ui/common/common_scale9_wuse.png"}
	local imgQuality = GetElement(self.m_root, "imgQuality_CellFund", WZUIImage)
	imgQuality:setFile(QUALITY_RECT[GDatatab_item["id_" .. get[1][1]].quality])
	--可领取钻石数
	GetElement(self.m_root,"ttf2_CellFund",WZUILabelTTF):setText(get[1][2])
	--设置按钮状态
	GetElement(self.m_root,"txtBuy3_CellFund",WZUILabelTTF):setText(LocalStrings.ACTIVE_BTN_GET)
	if WndFund.m_bBuy == false then
		GetElement(self.m_root,"btnGet",WZUIButton):setTouchEnable(false)
	elseif self.m_tData.receive == 1 then
		--已领取
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"finish",WZUILabelTTF):setVisible(true)
	elseif self.m_tData.receive == 0 and tonumber(CacheCenter:getPlayerInfo().level) < level then
		--不能领取
		GetElement(self.m_root,"btnGet",WZUIButton):setTouchEnable(false)
	end
end

--@brief	用数据更新cell
function CellFund:onLoadData(element)
	WZLog("CellFund:onLoadData")
	local cellElement = WZUISystem:getInstance():createElement("CellFund")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

	self:updateCell()
	AdaptLanguage(self)
end

--@brief	领取基金
function CellFund:onGet(element)
	WZLog("CellFund:onGet",self.m_tData.level)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"finish",WZUILabelTTF):setVisible(true)
	element:setVisible(false)
	ProtocolProcessorFund:send_FUNDGROW_GetFundAward(tonumber(self.m_tData.level))
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellFund:_adaptLanguage_pt(  )
	GetElement(self.m_root,"ttf1_CellFund",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.0907381,0.5))
	GetElement(self.m_root,"txtBuy1_CellFund",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtBuy2_CellFund",WZUILabelTTF):setScale(0.75)
	GetElement(self.m_root,"txtBuy3_CellFund",WZUILabelTTF):setScale(0.75)
end

function CellFund:_adaptLanguage_es(  )
	GetElement(self.m_root,"ttf1_CellFund",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.09,0.5))
end
-------------------------------------语言适配End----------------------------------------