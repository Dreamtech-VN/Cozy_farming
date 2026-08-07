--CellEquipName.lua
--@brief	CellEquipName的UI模块
--@date		2016/05/21
--@author	maopeiting
--@note		装备栏物品名称分类


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEquipName:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEquipName:onExit(element)
	self:_unInit()
end

--@brief	更新标题名
function CellEquipName:_update(  )
	--WZLog("-------CellEquipName:_update-------",self.id,element)
	local name = GetElement(self.m_root,"ttfName_CellEquipName",WZUILabelTTF)
	if self.tag == 1 then
		if self.id == 1 then
			name:setText(LocalStrings.WEAPON)
		elseif self.id == 2 then
			name:setText(LocalStrings.RING)
		elseif self.id == 3 then
			name:setText(LocalStrings.NECKLACE)
		elseif self.id == 4 then
			name:setText(LocalStrings.BRACELET)
		elseif self.id == 5 then
			name:setText(LocalStrings.TREASURE)
		elseif self.id == 6 then
			name:setText(LocalStrings.MEDAL)
		end
	elseif self.tag == 4 then
		if self.id == 1 then
			name:setText(LocalStrings.HEAD)
		elseif self.id == 2 then
			name:setText(LocalStrings.FACE)
		elseif self.id == 3 then
			name:setText(LocalStrings.CLOTHES)
		elseif self.id == 4 then
			name:setText(LocalStrings.WING)
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-------------------------------
function CellEquipName:_adaptLanguage_en(  )
	local name = GetElement(self.m_root,"ttfName_CellEquipName",WZUILabelTTF)
	name:setRelativePosition(GlobalMethod:ccp(0,0.5))
	name:setFontSize(22)
end

function CellEquipName:_adaptLanguage_pt(  )
	local name = GetElement(self.m_root,"ttfName_CellEquipName",WZUILabelTTF)
	name:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
end
---------------------------------------语言适配End--------------------------------------------