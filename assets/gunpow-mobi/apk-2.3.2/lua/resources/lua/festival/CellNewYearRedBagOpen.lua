--CellNewYearRedBagOpen.lua
--@brief	CellNewYearRedBagOpen的UI模块
--@date		2021/01/07
--@author	hyx
--@note		新年红包开启


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearRedBagOpen:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearRedBagOpen:onExit(element)
	self:_unInit()
end

function CellNewYearRedBagOpen:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellNewYearRedBagOpen:actionCallback()
	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	local goodFreeList = GetElement(self.m_root,"goodFreeList",WZUIFreeListContainer)

	GetElement(self.m_root,"txtDesc",WZUIFreeTextBox):setShowText(LocalStrings.NEWYEAR_TEXT25)
	if #self.m_tOpenReward == 1 or #self.m_tOpenReward == 2 then
		local pos = {115,70}
		for i = 1, #self.m_tOpenReward do
			local items = GDatatab_item["id_"..self.m_tOpenReward[i].id]
			if items then
				local celElement, tNewObj = CellGoodItem:createElement()
				good_con:addChild(celElement)
			    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=self.m_tOpenReward[i].num,quality=items.quality,basicInfo=items}
			    tNewObj:setCellGoodItem(itemInfo,17)
			    tNewObj:setItemClickFun(self,self.onItemClick)
			    celElement:setAbsPosition(GlobalMethod:ccp(pos[#self.m_tOpenReward]+(90 * (i-1)),60))
			end
		end
	else
		goodFreeList:removeAll()
		for i = 1, #self.m_tOpenReward do
			local items = GDatatab_item["id_"..self.m_tOpenReward[i].id]
			if items then
				local element, tLuaObj = CellGoodItem:createElement()
				goodFreeList:pushBack(WZUIContainer:luaTo(element))
				local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=self.m_tOpenReward[i].num,quality=items.quality,basicInfo=items}
			    tLuaObj:setCellGoodItem(itemInfo,17)
			    tLuaObj:setItemClickFun(self,self.onItemClick)
			    goodFreeList:getMoveElement():setPositionX(goodFreeList:getMaxPosition().x)
			end
		end
	end
end
function CellNewYearRedBagOpen:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tData == nil then
        return
    end
	WndItemInfo:showInfo(tCell.m_root,CellNewYearRedBagOpen.m_root,1,tData,false,nil,true)	
end
function CellNewYearRedBagOpen:showInterface(reward)
	local wndOpenRedBag = CellNewYearRedBagOpen:createElement(reward)
	if wndOpenRedBag then
	    WindowManager:addWindow(wndOpenRedBag,CellNewYearRedBagOpen,nil,false)
	end
end

function CellNewYearRedBagOpen:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
