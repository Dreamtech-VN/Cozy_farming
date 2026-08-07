-- 公会战奖励列表内容 UI部分
-- @brief:
-- @date: 2017-02-22 16:47:24
-- @author: zhenwei_jian
-- @note:公会战奖励列表内容

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCompeteGift:onEnter(element)
	self.m_root = element
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCompeteGift:onExit(element)
	self:_unInit()
end


--@brief    点击奖励物品回调
function CellCompeteGift:onOthersClick(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndCompeteGift.m_root, 1, tData, false, nil, true)
end


-------------------------------------公有方法模块End--------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------


--@brief 更新显示
function CellCompeteGift:_update() 
    if nil == self.m_root then return end 
    if nil == self.m_tData then return end


    local conRankLabel  = GetElement(self.m_root, "conRankLabel", WZUIContainer)    --文字显示排名 容器
    local conRankPic    = GetElement(self.m_root, "conRankPic", WZUIContainer)      --图片显示排名 容器

    local labelRank     = GetElement(self.m_root, "labelRank", WZUILabelTTF)        --排名文字

    local imgNum1       = GetElement(self.m_root, "imgNum1", WZUIImage)             --图片冠军
    local imgNum2       = GetElement(self.m_root, "imgNum2", WZUIImage)             --图片亚军
    local imgNum3       = GetElement(self.m_root, "imgNum3", WZUIImage)             --图片季军

    imgNum1:setVisible(false)
    imgNum2:setVisible(false)
    imgNum3:setVisible(false)
    local _tmpMap = {
        [1] = imgNum1,
        [2] = imgNum2,
        [3] = imgNum3,
    }

	local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
	if WndCompeteGift.m_nType == 2 or WndCompeteGift.m_nType == 3 then
		imgNum1:setFile(picName[1])
		imgNum2:setFile(picName[2])
		imgNum3:setFile(picName[3])
	end

    local rank = self.m_tData.rank      --排名
    rank = rank[1][#rank]

    if rank > 3 then--排名大于3用文字显示
        conRankLabel:setVisible(true)
        conRankPic:setVisible(false)
        --设置排名label
        if WndCompeteGift.m_nType == 3 then
            labelRank:setText(string.format(LocalStrings.RANK_TIPS_3, self.m_tData.rank[1][1], self.m_tData.rank[1][2]))
        else
            labelRank:setText(self.m_tData.desc)
        end
    else
        conRankLabel:setVisible(false)
        conRankPic:setVisible(true)

        --显示排名图片
        local imgTarget = _tmpMap[rank]
        if nil ~= imgTarget then
            imgTarget:setVisible(true)
        end
    end


    -- 奖励
    for i, mData in ipairs(self.m_tData.rank_reward) do
        self:_createGoodsIcon(mData, i)
    end
end

--@brief 创建物品icon
function CellCompeteGift:_createGoodsIcon(tGoodsData, nGoodsIndex)
    if nil == tGoodsData then
        return
    end

	local conItem = GetElement(self.m_root, string.format("conItem%d_Cell", nGoodsIndex), WZUIContainer) 
	local cell, tCell = CellGoodItem:createElement()
    tCell:setItemClickFun(self, self.onOthersClick)
	conItem:addChild(cell)
	cell:setTag(nGoodsIndex)
    -- cell:setScale(0.9)

    tCell:setCellGoodLocalId(tGoodsData[1], 4)
    tCell:setItemNumber(tGoodsData[2])
end

-------------------------------------私有方法模块End--------------------------------------


