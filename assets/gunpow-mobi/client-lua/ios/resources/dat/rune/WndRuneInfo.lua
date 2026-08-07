--WndRuneInfo.lua
--@brief	WndRuneInfo的UI模块
--@date		2017/03/21
--@author	qixiang
--@note		符文信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRuneInfo:onEnter(element)
	self.m_root = element
	self:showRuneInfo()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRuneInfo:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndRuneInfo:showRuneInfo()
	WZLog("WndRuneInfo:showRuneIn")
	local itemInfo = GDatatab_item["id_" .. self.m_nRuneId]
	local getElement = GetElement
	local imgRune = getElement(self.m_root,"imgRune_WndRuneInfo",WZUIImage)
	imgRune:setFile(itemInfo.icon)

	local txtRuneName = getElement(self.m_root,"txtRuneName_WndRuneInfo",WZUILabelTTF)
	txtRuneName:setText(itemInfo.name)

	local conTab = getElement(self.m_root,"conTab_WndRuneInfo",WZUITableContainer)
	conTab:cleanTable()
	local temp = ATTR_TITLE
	local attrT = {}
	local key = nil
	for i,v in ipairs(itemInfo.property) do
		local cellAttribute = CreateElement("CellAttribute_SceneRune")
		cellAttribute = WZUIContainer:luaTo(cellAttribute)
		cellAttribute:setVisible(true)
		local txtName = getElement(cellAttribute,"txtName_CellRuneInfo",WZUILabelTTF)
		local txtV = getElement(cellAttribute,"txtV_CellRuneInfo",WZUILabelTTF)
		txtName:setText(temp[v[1]])
		txtV:setText("+" .. v[2])
		cellAttribute:setTag(i-1)
		conTab:setCellElement(cellAttribute)
		
		key = tostring(v[1])
		attrT[key] = v[2]
	end
	local txtFight = getElement(self.m_root,"txtFight_WndRuneInfo",WZUILabelTTF)
	local fightV = GlobalMethod:getCombatEffect(attrT)
	txtFight:setText(fightV)
end


function WndRuneInfo:onClickClose(element)
	-- body
	WZLog("WndRuneInfo:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCloseCallbackLua and self.m_tCloseCallbackFun  then
		self.m_tCloseCallbackFun(self.m_tCloseCallbackLua)
	end
end

--从某个槽位拆卸符文
function WndRuneInfo:unLoadRune(element)
	WZLog("WndRuneInfo:unLoadRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorSceneRune:send_RUNE_UpdateRune(self.m_nSlotIndex,0)
end

--更换符文槽位上的符文
function WndRuneInfo:onChangeRune(element)
	WZLog("WndRuneInfo:onChangeRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tLuaFun and self.m_tLuaFun2 then
		self.m_tLuaFun2(self.m_tLuaFun,self.m_nRuneId,self.m_nSlotIndex)
	end
	self.m_root:removeFromParentAndCleanup(true)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndRuneInfo:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTitle_WndRuneInfo",WZUILabelTTF):setScale(0.7)
	local txtRuneName = GetElement(self.m_root,"txtRuneName_WndRuneInfo",WZUILabelTTF)
	txtRuneName:setScale(0.7)
	txtRuneName:setDimensions(GlobalMethod:CCSize(140))
	txtRuneName:setRelativePosition(GlobalMethod:ccp(0.226444,0.738061))
	
end

function WndRuneInfo:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTitle_WndRuneInfo",WZUILabelTTF):setScale(0.7)
	local txtRuneName = GetElement(self.m_root,"txtRuneName_WndRuneInfo",WZUILabelTTF)
	txtRuneName:setScale(0.7)
	txtRuneName:setDimensions(GlobalMethod:CCSize(140))
	txtRuneName:setRelativePosition(GlobalMethod:ccp(0.226444,0.738061))
end

function WndRuneInfo:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTitle_WndRuneInfo",WZUILabelTTF):setScale(0.7)
	local txtRuneName = GetElement(self.m_root,"txtRuneName_WndRuneInfo",WZUILabelTTF)
	txtRuneName:setScale(0.7)
	txtRuneName:setDimensions(GlobalMethod:CCSize(140))
	txtRuneName:setRelativePosition(GlobalMethod:ccp(0.226444,0.738061))
end

function WndRuneInfo:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTitle_WndRuneInfo",WZUILabelTTF):setScale(0.7)
	local txtRuneName = GetElement(self.m_root,"txtRuneName_WndRuneInfo",WZUILabelTTF)
	txtRuneName:setScale(0.7)
	txtRuneName:setDimensions(GlobalMethod:CCSize(140))
	txtRuneName:setRelativePosition(GlobalMethod:ccp(0.226444,0.738061))
end
-------------------------------------语言适配End-------------------------------------------