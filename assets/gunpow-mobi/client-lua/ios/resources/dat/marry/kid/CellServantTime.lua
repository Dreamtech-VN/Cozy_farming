--CellServantTime.lua
--@brief	CellServantTime的UI模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		菲佣时长cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellServantTime:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellServantTime:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellServantTime:onClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndKidServant:onClickTimeItemCallBack(self, self.m_tData)
end

--@brief 	设置选中是否可见
function CellServantTime:setSelState(bVisible)
	-- body
	GetElement(self.m_root, "conSel_CellServantTime", WZUIContainer):setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellServantTime:_update()
	-- body
	local ftxtCost = GetElement(self.m_root, "ftxtCost_CellServantTime", WZUIFreeTextBox)
	if ftxtCost then
		local sFormat = [[<T C="255,236,193" S="24" P="1" SC="127,70,26" SS="4" SE="0">%d</T><I Z="0.5">%s</I><T C="99,255,95" S="24" P="1" SC="127,70,26" SS="4" SE="0">           %d%s</T>]]
		local string = string.sub(self.m_tData.cost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]
		local basicData = GDatatab_item["id_" .. id]
		ftxtCost:setShowText(string.format(sFormat, tonumber(num), basicData.icon, self.m_tData.lastHour, LocalStrings.HOUR1))
	end
end

-------------------------------------私有方法模块End----------------------------------------
