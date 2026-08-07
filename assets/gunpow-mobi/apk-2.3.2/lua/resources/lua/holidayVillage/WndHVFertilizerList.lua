--WndHVFertilizerList.lua
--@brief	WndHVFertilizerList的UI模块
--@date		2022/06/23
--@author	XTX
--@note		度假村-肥料


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVFertilizerList:onEnter(element)
	self.m_root = element

	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVFertilizerList:onExit(element)
	self:_unInit()
end

--@brief 	点击关闭按钮回调
function WndHVFertilizerList:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self.m_tLuaTable:_createFertilizerList(2, false)
end
function WndHVFertilizerList:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    --限制增产化肥的使用次数，只能使用1次
    local fertilizerInc = self.m_tFieldData.fertilizerIncr
    local bCanDo = true 
    if fertilizerInc and fertilizerInc > 0 then 
    	local basicData = GDatatab_item["id_" .. fertilizerInc]
    	if basicData and basicData.main_type == 45 and basicData.sub_type == tData.basicInfo.sub_type and tData.basicInfo.main_type == basicData.main_type then 
    		bCanDo = false 
    	end
    end
    if bCanDo then 
	    self.m_tLuaTable:setOperateType(2, tData, self.m_tFieldData)
	else
		MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[62])
	end
	self.m_tLuaTable:_createFertilizerList(2, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新列表
function WndHVFertilizerList:_update()
	local conItem1 = GetElement(self.m_root, "conItem1_WndHVFertilizerList", WZUIContainer)
	local conItem2 = GetElement(self.m_root, "conItem2_WndHVFertilizerList", WZUIContainer)
	local conBg = GetElement(self.m_root, "conBg_WndHVFertilizerList", WZUIContainer)
	conItem1:removeAllChildrenWithCleanup(true)
	conItem2:removeAllChildrenWithCleanup(true)

	local nCount = #self.m_tDataList
	local posList = {GlobalMethod:ccp(0.155, 0.5), GlobalMethod:ccp(0.5,0.5), GlobalMethod:ccp(0.845, 0.5)}
	if nCount > 3 then 
		conItem2:setVisible(true)
		conBg:setAbsContentSize(GlobalMethod:CCSize(294, 180))
		conBg:updateRelativeSize()
	else
		conItem2:setVisible(false)
	end

	for i = 1, #self.m_tDataList do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.9)
			tNewObj:setCellGoodLocalId(self.m_tDataList[i].id, self.m_tDataList[i].num, 17)
			tNewObj:setItemClickFun(self,self.onItemClick)

			if i > 3 then 
				element:setRelativePosition(posList[i - 3])
				conItem2:addChild(element)
			else
				element:setRelativePosition(posList[i])
				conItem1:addChild(element)
			end
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
