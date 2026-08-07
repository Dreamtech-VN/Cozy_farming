-- 许愿池奖励
-- @brief:许愿池奖励 UI 模块
-- @date: 2017-03-13 17:37:34
-- @author: zhenwei_jian
-- @note:许愿池奖励

-------------------------------------公有方法模块Begin--------------------------------------
 

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPromiseShrineGiftItem:onEnter(element)
	self.m_root 	= element 
	self.conItem 	= GetElement(self.m_root, "conItem", WZUIContainer)
	self.spriteGold = GetElement(self.m_root, "spriteGold", WZUIImage)

	self:_initControls()
	self:_update()
end

--@brief    onenter函数已执行
function CellPromiseShrineGiftItem:onEnterTransitionDidFinish(element)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPromiseShrineGiftItem:onExit(element)
	self:_unInit()
end 
-------------------------------------公有方法模块End--------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------

function CellPromiseShrineGiftItem:_initControls()
	self.spriteGold:setVisible(false)
end

--@brief	更新界面
function CellPromiseShrineGiftItem:_update()
	if nil == self.m_itemId then
		return
	end
	if nil ~= self.conItem then
		self.conItem:removeAllChildrenWithCleanup(true)
	end
	local tData = GDatatab_item[string.format("id_%s", self.m_itemId)]
	-- local m_imgItem = WZUIImage:create()
 --    m_imgItem:setUseOriginSize(true)
 --    m_imgItem:setFile(tData.icon)

    if self.m_bIsGood then
		-- self.spriteGold:setVisible(true)
    end


    local cell, tCell = CellGoodItem:createElement()
	cell:setTag(self.m_itemId)
	-- cell:setScale(0.8)
	tCell:setCellGoodLocalId(self.m_itemId, 4)
	tCell:setItemClickFun(self, self.onOthersClick)
	
	local container = GetElement(self.m_root, "conItem", WZUIContainer)
	container:addChild(cell)

	tCell:_setBgImgVisible(false)
end
 


--@brief    点击奖励物品回调
function CellPromiseShrineGiftItem:onOthersClick(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    WZLog("tData:::", tData)
    if nil == tData then
       return
    end
    WZLog("tData:::", WndPromiseShrine.m_root)
    if nil == WndPromiseShrine.m_root then
    	return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndPromiseShrine.m_root, 1, tData, false, nil, true, nil, nil, false)
end

-------------------------------------私有方法模块End--------------------------------------
