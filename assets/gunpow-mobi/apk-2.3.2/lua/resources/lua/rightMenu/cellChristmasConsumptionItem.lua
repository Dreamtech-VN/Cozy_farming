--cellChristmasConsumptionItem.lua
--@brief	cellChristmasConsumptionItem的UI模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞排行榜子item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function cellChristmasConsumptionItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function cellChristmasConsumptionItem:onExit(element)
	self:_unInit()
end

-- 加载数据
function cellChristmasConsumptionItem:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("cellChristmasConsumptionItem")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:setRankItemData()
    -- AdaptLanguage(self)
end

function CellShopRankItem:setRankItemData()
	if not self.m_RankData then return end

	local img_rank = GetElement(self.m_root,"rankIcon_cellChristmasConsumptionItem",WZUIImage)
	img_rank:setVisible(false)
	local txt_rank = GetElement(self.m_root,"rankTxt_cellChristmasConsumptionItem",WZUILabelTTF)
	local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	txt_rank:setVisible(false)
	if self.index <= 3 then
		img_rank:setVisible(true)
		img_rank:setFile(rank_name[self.index])
	else
		txt_rank:setVisible(true)
		txt_rank:setText(tostring(self.index))
	end

	GetElement(self.m_root,"name_cellChristmasConsumptionItem",WZUILabelTTF):setText(self.m_sShopRankData.name)
	GetElement(self.m_root,"lvNum_cellChristmasConsumptionItem",WZUILabelTTF):setText(self.m_sShopRankData.level)
	GetElement(self.m_root,"consumptionNum_cellChristmasConsumptionItem",WZUILabelTTF):setText(self.m_RankData.point)

	local head_contianer = GetElement(self.m_root,"head_cellChristmasConsumptionItem",WZUIContainer)
	CellHead:show(head_contianer, self.RankData.headId, self.RankData.faceId, self.RankData.sex, false, nil, nil, self.RankData.headColor)
	local reward_container = GetElement(self.m_root,"reward_cellChristmasConsumptionItem",WZUIContainer)
	if self.RankData.reward_id then
		for i, v in ipairs(self.m_RankData.reward_id) do
			local key = "id_"..v
			if GDatatab_item[key] then
			    local name = GDatatab_item[key].name
			    local path = GDatatab_item[key].icon
			    local quality = GDatatab_item[key].quality
			    local num = self.m_RankData.reward_num[i]
				local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    tLuaObj:setCellGoodItem(itemInfo, 17)
			    celElement:setScale(0.8)
				reward_container:addChild(celElement)
				tLuaObj:setItemClickFun(WndShopRank,self.onRankRewardItemClick)

				celElement:setUseAbsCoordinate(true)
				celElement:setAbsPosition(GlobalMethod:ccp(260-(i-1)*70,40))
			end
		end
	end
end
--@brief	点击物品弹出对应的tips
function CellShopRankItem:onRankRewardItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndShopRank.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
