--WndGangsterInnActivity.lua
--@brief	WndGangsterInnActivity的UI模块
--@date		2016/10/11
--@author	zsq
--@note		黑店活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGangsterInnActivity:onEnter(element)
	self.m_root = element
	ProtocolProcessorStore:send_MALL_GetBlackMarketInfo()
end

function WndGangsterInnActivity:onEnterTransitionDidFinish(element)
	self:update()
	AdaptLanguage(self)
end

function WndGangsterInnActivity:update()
	WZLog("WndGangsterInnActivity:update")
	if not self.m_root then return end
    if WndGangsterInn.m_bOpen == nil or WndGangsterInn.m_bOpen == false then
		GetElement(self.m_root,"con1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con2",WZUIContainer):setVisible(true)
	elseif WndGangsterInn.m_bOpen == true then
		GetElement(self.m_root,"con1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"con2",WZUIContainer):setVisible(false)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGangsterInnActivity:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGangsterInnActivity:onOpen()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndGangsterInnActivity:onOpen")
	if WndGangsterInn.m_bOpen == true then
		--local wnd = WndGangsterInn:createElement()
    	--WindowManager:addWindow(wnd, WndGangsterInn, false)
		WndStore:showStoreByType(6)
	end
end

function WndGangsterInnActivity:onSingle()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndGangsterInnActivity:onSingle")
	JumpByUIId(12)
end

function WndGangsterInnActivity:onMultiple()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndGangsterInnActivity:onMultiple")
	JumpByUIId(15)
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin-----------------------------------------
function WndGangsterInnActivity:_adaptLanguage_en(  )
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setDimensions(GlobalMethod:CCSize(120,0))
end

function WndGangsterInnActivity:_adaptLanguage_pt(  )
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.75)
	txtTeam:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndGangsterInnActivity:_adaptLanguage_vn(  )
	local txtTeam = GetElement(self.m_root,"txtAdvanture_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setDimensions(GlobalMethod:CCSize(120,0))
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setDimensions(GlobalMethod:CCSize(120,0))
end

function WndGangsterInnActivity:_adaptLanguage_es(  )
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.8)
	txtTeam:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndGangsterInnActivity:_adaptLanguage_tr(  )
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.8)
	local txtOpen = GetElement(self.m_root,"txtOpen_WndGangsterInnActivity",WZUILabelTTF)
	txtOpen:setScale(0.7)
	txtOpen:setDimensions(GlobalMethod:CCSize(120,0))
end

function WndGangsterInnActivity:_adaptLanguage_ug(  )
	local txtOpen = GetElement(self.m_root,"txtOpen_WndGangsterInnActivity",WZUILabelTTF)
	txtOpen:setScale(0.6)
	txtOpen:setDimensions(GlobalMethod:CCSize(200,0))
	local txtAdvanture = GetElement(self.m_root,"txtAdvanture_WndGangsterInnActivity",WZUILabelTTF)
	txtAdvanture:setScale(0.6)
	txtAdvanture:setDimensions(GlobalMethod:CCSize(200,0))
	local txtTeam = GetElement(self.m_root,"txtTeam_WndGangsterInnActivity",WZUILabelTTF)
	txtTeam:setScale(0.5)
	txtTeam:setDimensions(GlobalMethod:CCSize(240,0))
end
-------------------------------------语言适配End-------------------------------------------