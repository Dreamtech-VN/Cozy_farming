--CellEquipItem.lua
--@brief	CellEquipItem的UI模块
--@date		2016/05/21
--@author	maopeiting
--@note		装备栏物品分类


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEquipItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEquipItem:onExit(element)
	self:_unInit()
end

--@brief	更新物品格子
function CellEquipItem:_update(  )
	local con1 = GetElement(self.m_root,"con1_CellEquipItem",WZUIContainer)
	local con2 = GetElement(self.m_root,"con2_CellEquipItem",WZUIContainer)
	local con3 = GetElement(self.m_root,"con3_CellEquipItem",WZUIContainer)
	local con4 = GetElement(self.m_root,"con4_CellEquipItem",WZUIContainer)
	
	WZLog("CellEquipItem:_update ",#self.m_tData)

	for i,data in ipairs(self.m_tData) do 
		WZLog("------------CellEquipItem:------------",self.tag,self.id)
		local celElement,tcell = CellGoodItem:createElement()
		celElement:setTag(self.tag)

		local cellData = {}
		if data.extraInfo == nil then
			cellData.basicInfo = data
			cellData.gray = true
		else
			cellData = data
		end
		--判断是否为时装
		if self.id == 4 then
			tcell:setCellGoodItem(cellData,13)
		else
			tcell:setCellGoodItem(cellData,4)
			if cellData.gray ~= true then
			    --为拥有的物品设置已拥有角标
				tcell:_addSidebarOwn()
			end	
		end

		--cell的点击事件
		tcell:setItemClickFun(WndLibrary,WndLibrary.onItem)

		if i == 1 then
			con1:addChild(celElement)
		elseif i == 2 then 
			con2:addChild(celElement)
		elseif i == 3 then
			con3:addChild(celElement)
		elseif i == 4 then 
			con4:addChild(celElement)
		end
		--标签栏的第一个物品默认高亮显示
		if self.tag == 1 then
			tcell:setHighLight(true)
			WndLibrary.preCell = tcell
		end
		self.tag = self.tag + 1
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
