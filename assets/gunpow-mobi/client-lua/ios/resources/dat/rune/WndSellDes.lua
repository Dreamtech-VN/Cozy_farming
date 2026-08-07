--WndSellDes.lua
--@brief	WndSellDes的UI模块
--@date		2017/03/24
--@author	peiting_mao
--@note		出售详情


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSellDes:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSellDes:onExit(element)
	self:_unInit()
end

function WndSellDes:showWindow(item, tag)
	if self.m_root == nil then
		local wnd = WndSellDes:createElement()
		WindowManager:addWindow(wnd,WndSellDes,nil,nil,nil,true)
		self.item = item
		self.m_nTag = tag
		self:_update()
	end
end

function WndSellDes:_update(  )
	WZLog("--WndSellDes:_update--",Serialize(self.item))
	local tab = GetElement(self.m_root,"tab_WndSellDes",WZUITableContainer)
	tab:cleanTable()
	if self.item ~= nil and #self.item > 0 then
		for i=1,#self.item do
			local tElement,tCell = CellRuneSellDes:createElement()
			if tElement and tCell then
				tElement:setTag(i-1)
				tCell:setData(self.item[i])
				tab:setCellElement(tElement)
			end
		end
	else
		GetElement(self.m_root,"txtSale_WndSellDes",WZUILabelTTF):setVisible(true)
	end
	tab:getMoveElement():setPositionY(tab:getMinPosition().y)
end

function WndSellDes:onClose( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WndSellRune:reCaculateGain()
	WindowManager:removeWindow(self.m_root,self,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
