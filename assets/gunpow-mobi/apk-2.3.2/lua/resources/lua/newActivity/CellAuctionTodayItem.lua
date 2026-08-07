--CellAuctionTodayItem.lua
--@brief	CellAuctionTodayItem的UI模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍榜子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAuctionTodayItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAuctionTodayItem:onExit(element)
	self:_unInit()
end

function CellAuctionTodayItem:updateUI()
	local tag = self.m_root:getTag()+1

	local tItemInfo = GDatatab_item["id_"..self.m_tData[1]]
	local txtAuctionName = GetElement(self.m_root,"txtAuctionName_CellAuctionTodayItem",WZUILabelTTF)
	txtAuctionName:setText(string.format(LocalStrings.AUCTION_HOUSE_TEXT17,tag))
    if ProjConfig.LANGUAGE == "vn" then
        txtAuctionName:setFontSize(20)
        txtAuctionName:setScale(0.8)
        txtAuctionName:setDimensions(GlobalMethod:CCSize(120))
    end

    --商品图标
	local conAuctionItem = GetElement(self.m_root, "conAuctionItem_CellAuctionTodayItem", WZUIContainer)
	local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodLocalId(self.m_tData[1],self.m_tData[2],5)
        conAuctionItem:addChild(cell)
    end

    local nNum = self.m_tData[2]
    if tItemInfo and tItemInfo.main_type == 5 then
    	if self.m_tData[2] == -1 then
    		nNum = LocalStrings.YJ
    	else
    		nNum = self.m_tData[2]..LocalStrings.DAY
    	end
    end
	local txtAuctionNum = GetElement(self.m_root,"txtAuctionNum_CellAuctionTodayItem",WZUILabelTTF)
    txtAuctionNum:setText(nNum)

end

--@brief	点击回调
function CellAuctionTodayItem:onClickItem(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndAuctionRank:addTips(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
