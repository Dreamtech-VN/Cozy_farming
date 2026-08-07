--CellBlessBagItem.lua
--@brief	CellBlessBagItem的UI模块
--@date		2021/07/28
--@author	yrd
--@note		祈福背包格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBlessBagItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBlessBagItem:onExit(element)
	self:_unInit()
end

--@brief	更新ui
function CellBlessBagItem:updateUI()
	if self.m_root == nil then
		return
	end

	local QUALITY_COLOR = {GlobalMethod:ccc3(255,255,255), GlobalMethod:ccc3(99,255,95), GlobalMethod:ccc3(93,222,254), GlobalMethod:ccc3(198,130,255), GlobalMethod:ccc3(233,166,62)}

    local spineItem = GetElement(self.m_root, "spineItem_CellBlessBagItem", WZUISpine)
    local txtName = GetElement(self.m_root, "txtName_CellBlessBagItem", WZUILabelTTF)

    spineItem:setAnimationName(self.m_tData.basicInfo.icon)

    if self.m_tData.bGray == true then
    	spineItem:setGrayRender(true)
    	txtName:setText(self.m_tData.basicInfo.name)
    	txtName:setColor(QUALITY_COLOR[1])
    else
    	spineItem:setGrayRender(false)
    	txtName:setText("Lv"..self.m_tData.level..self.m_tData.basicInfo.name)
    	txtName:setColor(QUALITY_COLOR[self.m_tData.basicInfo.quality + 1])
    end

    if self.m_tData.bSelect then
		GetElement(self.m_root,"conSelected_CellBlessBagItem",WZUIContainer):setVisible(self.m_tData.bSelect)
	end
end

--@brief	设置选中数量数量
function CellBlessBagItem:setChooseNum(nChooseNum)
	if self.m_root == nil then
		return
	end

	self.m_nChooseNum = nChooseNum
	local strNum = ""
	if self.m_tData.num > 1 then
		if nChooseNum and nChooseNum ~= 0 then
			strNum = nChooseNum.."/"..self.m_tData.num
		else
			strNum = self.m_tData.num
		end
	end
	GetElement(self.m_root,"txtNum_CellBlessBagItem",WZUILabelTTF):setText(strNum)
end

--@brief	获取选择数量
function CellBlessBagItem:getChooseNum()
	return self.m_nChooseNum
end

--@brief	设置选中状态
function CellBlessBagItem:setSelectedStates(bSelect)
	if self.m_root == nil then
		return
	end

	self.m_tData.bSelect = bSelect
	GetElement(self.m_root,"conSelected_CellBlessBagItem",WZUIContainer):setVisible(bSelect)
end

--@brief	获取勾选状态
function CellBlessBagItem:getConGouVisible()
	return self.bIsChoose
end

--@brief    设置勾选状态
function CellBlessBagItem:setConGouVisible(bVisible)
	if self.m_root == nil then
		return
	end

    self.bIsChoose = bVisible
    GetElement(self.m_root, "conGou_CellBlessBagItem", WZUIContainer):setVisible(bVisible)
end

--@brief	设置名字
function CellBlessBagItem:setName(sName)
	if self.m_root == nil then
		return
	end

	GetElement(self.m_root,"txtName_CellBlessBagItem",WZUILabelTTF):setText(sName)
end

--@brief	设置红点状态
function CellBlessBagItem:setRedDotStates(bRed)
	if self.m_root == nil then
		return
	end

	self.bRed = bRed
	GetElement(self.m_root,"imgRed_CellBlessBagItem",WZUIImage):setVisible(bRed)
end

--@brief	点击祈福回调
function CellBlessBagItem:onClickItem(element)
	if self.m_tClickCallback and self.m_tClickCallback[1] and self.m_tClickCallback[2] then
	    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		self.m_tClickCallback[2](self.m_tClickCallback[1],self.m_tData,self)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
