--WndSingleSellRune.lua
--@brief	WndSingleSellRune的UI模块
--@date		2017/03/24
--@author	peiting_mao
--@note		单独出售符文


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleSellRune:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndSingleSellRune:showWindow( item,isUsed,num )
	if self.m_root == nil then
		local wnd = WndSingleSellRune:createElement()
		WindowManager:addWindow(wnd,WndSingleSellRune,nil,nil,nil,true)
		--ProtocolProcessorSceneRune:regAll()
		self.item = item
		self.isUsed = isUsed
		self.num = num
		self:_update()
	else
		return
	end
end

-- function WndSingleSellRune:onEnterTransitionDidFinish( )
-- 	WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
-- end

-- function WndSingleSellRune:actionCallback(  )
	
-- end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleSellRune:onExit(element)
	self:_unInit()
	--ProtocolProcessorSceneRune:unregAll()
end

--@brief	关闭窗口
function WndSingleSellRune:onClose( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root,self,true)
	--ProtocolProcessorSceneRune:send_RUNE_GetRuneList( )
end

--@brief 	出售符文事件
function WndSingleSellRune:onSell( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("--WndSingleSellRune:onSale--",self.num,self.isUsed)
	local cout = self.num - self.isUsed
	if cout <= 0 then --已装载符文
		MsgBoxManager:showConfirmBox(LocalStrings.RUNEBOOK11, self,self.clickSale)
	else --未装载符文
		MsgBoxManager:showConfirmBox(LocalStrings.RUNEBOOK12, self,self.clickSale)
	end
end

function WndSingleSellRune:_update(  )
	GetElement(self.m_root,"txtNum_WndSingleSellRune",WZUILabelTTF):setText("×1")
	local name = GetElement(self.m_root,"txtName_WndSingleSellRune",WZUILabelTTF)
	name:setText(self.item.name)
	name:setColor(QUALITYCOLOR[self.item.quality])
	for i=1,#self.item.property do
		GetElement(self.m_root,"txtProperty"..i.."_WndSingleSellRune",WZUILabelTTF):setText(ATTR_TITLE[self.item.property[i][1]])
		GetElement(self.m_root,"txtPropertyVal"..i.."_WndSingleSellRune",WZUILabelTTF):setText(self.item.property[i][2])
	end
	GetElement(self.m_root,"txtPrice_WndSingleSellRune",WZUILabelTTF):setText(self.item.recycleMess[1][2])
	GetElement(self.m_root,"imgRune_WndSingleSellRune",WZUIImage):setFile(self.item.icon)
end

function WndSingleSellRune:clickSale(  )
	local id = WZLuaVector_int_:create()
	id:push(self.item.id)
	local num = WZLuaVector_int_:create()
	num:push(1)
	ProtocolProcessorSceneRune:send_RUNE_SellRune(id,num)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSingleSellRune:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtName_WndSingleSellRune",WZUILabelTTF):setFontSize(14)
end

function WndSingleSellRune:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_WndSingleSellRune",WZUILabelTTF):setFontSize(14)
end

function WndSingleSellRune:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtName_WndSingleSellRune",WZUILabelTTF):setFontSize(14)
end
-------------------------------------语言适配End--------------------------------------------