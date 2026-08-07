--WndAchie.lua
--@brief	WndAchie的UI模块
--@date		2015/04/02
--@author	clc
--@note		符合成就弹出框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAchie:onEnter(element)
	self.m_root = element

	g_bHaveRedPointForAchieEntry = true

	local  nText = self.achieQuene[1].nText
	local 	id = self.achieQuene[1].id
	self:_initText(id, nText)
	self:_initImage()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAchie:onExit(element)
	self:_unInit()
end

--@brief   调用弹出成就到达函数接口
--@param   nText:成就名
function WndAchie:showAchieWithText(id, nText)
	-- body
	--初始化队列
	if self.achieQuene  == nil then
		self.achieQuene = {}
	end
	table.insert(self.achieQuene , {id = id, nText = nText})
	--保持只有队列里的第一条信息触发
	if #self.achieQuene <= 1 then
		self:_nextAchie()
	end
end


function WndAchie:_nextAchie()
	-- body
	--播放效果音效
	SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)

	if  self.m_root == nil then
		local currentRoot = WindowManager:getSceneRoot()

		local sceneLuaObj = currentRoot:getLuaObjectIndex()
		
		local wndAchie = WndAchie:createElement()
		if WndBuyActivity.m_root then
			wndAchie:setZOrder(7)
			local conRoot = GetElement(WndBuyActivity.m_root, "conBuyActivity_WndBuyActivity", WZUIContainer)
			conRoot:addChild(wndAchie)
		else
			GetElement(wndAchie, "conForAchie_WndAchie", WZUIContainer):setShowAll(true)
			wndAchie:setZOrder(ARCHIE_ZORDER)
			WindowManager:addWindow(wndAchie,WndAchie,false, nil, true)
		end

		local effectGetAchie = GetElement(wndAchie, "spineGetAchie_WndAchie", WZUISpine)
		effectGetAchie:play("chengjiu", false)
		effectGetAchie:enableSchedule("displayContinueSpine", 1.5)
	elseif  self.m_root ~= nil then
		self.m_root:disableSchedule()
		local  nText = self.achieQuene[1].nText
		local 	id = self.achieQuene[1].id
		self:_initText(id, nText)
		AdaptLanguage(self)
		WZLog("***** WndAchie:_nextAchie *****")

		local effectGetAchie = GetElement(self.m_root, "spineGetAchie_WndAchie", WZUISpine)
		effectGetAchie:play("chengjiu", false)
		effectGetAchie:enableSchedule("displayContinueSpine", 0.7)
	end
end

--@brief 	播放持续动画
function WndAchie:displayContinueSpine(element)
	-- body
	WZLog("***** WndAchie:displayContinueSpine *****")
	local effectGetAchie = GetElement(self.m_root, "spineGetAchie_WndAchie", WZUISpine)
	if effectGetAchie then
		effectGetAchie:disableSchedule()
		effectGetAchie:play("chengjiu_chixu", false)
		effectGetAchie:enableSchedule("onFinish", 1.5)
	end
end

--@brief 	设置成就名字
--@param 	id: 称号id
--@param 	nText: 称号名字
function WndAchie:_initText(id, nText )
	-- body
	local tData = GDatatab_achievement["id_"..id]
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	if text_Label == nil then
		return
	end
	local sTitle = SplitStringWithSeparator(nText,"&")
	local conForAchie = GetElement(self.m_root, "conForAchie_WndAchie", WZUIContainer)

	local tempPoint = GlobalMethod:ccp(0.5,0.643)
	CreateDesiSpine(conForAchie, text_Label, nText, tempPoint, true)
end

function WndAchie:_initImage( )
	-- body
end

--@brief 	获取成就效果完成后的回调
function WndAchie:onFinish(element)
	-- body
	WZLog("*************************   WndAchie:onFinish   1111******************************")
	element:disableSchedule()
	if self.m_root ~= nil then
		table.remove(self.achieQuene, 1)
		if #self.achieQuene >=1 then
			self.m_root:enableSchedule("_nextAchie", 1.5)
		else
			self.m_root:enableSchedule("removeEffects", 1)
		end
	end
end

--@brief 	获得成就提示效果播放完成后移除掉
function WndAchie:removeEffects()
	self.m_root:disableSchedule()
	if WndBuyActivity.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	else
		WindowManager:removeWindow(self.m_root, WndAchie, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndAchie:_adaptLanguage_en()
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	text_Label:setFontSize(18)
end

function WndAchie:_adaptLanguage_th()
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	text_Label:setFontSize(18)
end

function WndAchie:_adaptLanguage_pt()
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	text_Label:setFontSize(18)
end

function WndAchie:_adaptLanguage_es()
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	text_Label:setFontSize(18)
end

function WndAchie:_adaptLanguage_tr()
	local text_Label =  GetElement(self.m_root, "text_Label", WZUILabelTTF)
	text_Label:setFontSize(18)
end
-------------------------------------语言适配End----------------------------------------