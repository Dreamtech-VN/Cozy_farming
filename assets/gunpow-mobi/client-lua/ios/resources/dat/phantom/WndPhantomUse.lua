--WndPhantomUse.lua
--@brief	WndPhantomUse的UI模块
--@date		2017/04/25
--@author	zsq
--@note		使用体验卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomUse:onEnter(element)
	self.m_root = element
end

function WndPhantomUse:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root, true, "onEnterCall", self)

	self:update()
end

function WndPhantomUse:onEnterCall() 
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomUse:onExit(element)
	self:_unInit()
end

function WndPhantomUse:onClose() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	显示接口
function WndPhantomUse:show(tData)
	WZLog("WndPhantomUse:show")
	self.m_tData = tData
	local wnd = WndPhantomUse:createElement()
	WindowManager:addWindow(wnd, WndPhantomUse, nil, nil, true)
end

function WndPhantomUse:onUse() 
	--使用体验卡
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPhantomUse:update() 
	local con = GetElement(self.m_root,"tbcon_WndPhantomUse",WZUITableContainer)
	con:cleanTable() 

	local tData = self.m_tData
	--获得皮肤对应的体验卡id
	local cardIds = {}
	for i=0,100 do
		local tItem = GDatatab_item["id_"..(8000+i)]
		if tItem == nil then break end
		if tItem.property[1][1] == tData.id and CacheCenter:getPlayerItemCountById(tItem.id) > 0 then
			local cellElement,tCell
			cellElement,tCell = CellPhantomUse:createElement()
			cellElement:setTag(i-1)
			tData.cardId = tItem.id
			tCell:setData(tData)
			con:setCellElement(cellElement)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
