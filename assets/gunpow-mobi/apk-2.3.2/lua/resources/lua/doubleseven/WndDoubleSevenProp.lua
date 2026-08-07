--WndDoubleSevenProp.lua
--@brief	WndDoubleSevenProp的UI模块
--@date		2020/08/04
--@author	hyx
--@note		告白道具


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleSevenProp:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleSevenProp:onExit(element)
	self:_unInit()
end
function WndDoubleSevenProp:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDoubleSevenProp:actionCallback()
	self:initShow()
end
function WndDoubleSevenProp:initShow()
	GetElement(self.m_root, "title_name", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT16)
	GetElement(self.m_root, "tip_desc", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT17[self.propIndex])

	local prop_item = {70,857,858}
	if ProjConfig.LANGUAGE == "vn" then
		prop_item = {1,857,858}
	end
	local answer = CacheCenter:getGameParam().qixiConfessItem
	local array = SplitStringWithSeparator(answer,"&")
	local ids = {}
	local nums = {}
	local send_id = {}
	local table_insert = table.insert
	if array then
		for i=1,#array do
			local string = string.sub(array[i],2,-2)
			local id = SplitStringWithSeparator(string,",")[1]
			local num = SplitStringWithSeparator(string,",")[2]
			if prop_item[self.propIndex] == tonumber(id) then
				table_insert(ids,id)
				table_insert(nums,num)
				table_insert(send_id,i-1)
			end
		end
	end

	self.prop_freelist = GetElement(self.m_root,"prop_freelist",WZUIFreeListContainer)
	for i = 1, #ids do
        local element, tLuaObj = CellDoubleSevenPropItem:createElement()
        self.prop_freelist:pushBack(WZUIContainer:luaTo(element))
        self.prop_freelist:getMoveElement():setPositionY(self.prop_freelist:getMinPosition().y)
        tLuaObj:setPropInitMessage(send_id[i], ids[i], nums[i], prop_item[self.propIndex])
    end
end


function WndDoubleSevenProp:onClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
