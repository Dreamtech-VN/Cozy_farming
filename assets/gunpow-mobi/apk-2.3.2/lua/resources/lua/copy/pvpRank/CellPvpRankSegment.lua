--CellPvpRankSegment.lua
--@brief	CellPvpRankReward的UI模块
--@date		2015-11-12
--@author	binshao
--@note		排位赛段位奖励物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankSegment:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankSegment:onExit(element)
	self:_unInit()
end

--@brief    其它Item点击回调
function CellPvpRankSegment:onItemClick(luaObject,tag)
    self.callFunc[2](self.callFunc[1],luaObject,self.reward[tag])
end

--@brief    加载
function CellPvpRankSegment:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellPvpRankSegment")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellPvpRankSegment:_update( )
    local data = self.data
    local img_rank = GetElement(self.m_root,"img_rank_CellPvpRankSegment",WZUIImage)
    img_rank:setVisible(false)
    local txt_rank = GetElement(self.m_root,"txt_rank_CellPvpRankSegment",WZUILabelTTF)
    local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
    txt_rank:setVisible(false)
    WZLog("img_rank_CellPvpRankSegment", Serialize(data))
    if tonumber(data.rank1) == tonumber(data.rank2) then
        if tonumber(data.rank1) <= 3 then 
            img_rank:setVisible(true)
            img_rank:setFile(rank_name[tonumber(data.rank1)])
        else
            txt_rank:setVisible(true)
            txt_rank:setText(data.rank1)
        end
    else
        txt_rank:setVisible(true)
        txt_rank:setText(data.rank1 .. "-" .. data.rank2)
    end

    -- 奖励
    local reward = data.ids
    if reward then
        for i, v in ipairs(reward) do
            local key = "id_"..v
            if GDatatab_item[key] then
                local conItem = GetElement(self.m_root, "conItem" .. i .. "_CellPvpRankSegment", WZUIContainer)
                if conItem then 
                    local name = GDatatab_item[key].name
                    local path = GDatatab_item[key].icon
                    local quality = GDatatab_item[key].quality
                    local num = tonumber(data.nums[i])
                    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
                    local celElement,tLuaObj = CellGoodItem:createElement()
                    tLuaObj:setCellGoodItem(itemInfo, 17)
                    celElement:setScale(0.8)
                    conItem:addChild(celElement)
                    tLuaObj:setItemClickFun(WndPvpSegmentReward, WndPvpSegmentReward.onClickRewardItem)
                end
            end
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------