--CellAthRankReward.lua
--@brief	CellAthRankReward的UI模块
--@date		2015-1-25
--@author	binshao
--@note		竞技场排名奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthRankReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthRankReward:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellAthRankReward:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellAthRankReward")
    self.m_root:addChild(cellElement)
    self:_update()
end

--@brief 点击物品图标弹出信息框
function CellAthRankReward:onIconClick(luaTable,tag)
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndAthRank.m_root,1,self.data.reward[tag],false,nil,nil,other)
end

-- 设置玩家信息
local imgRankPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
function CellAthRankReward:_update()
    -- 排名
    local starR,endR = self.data.rank[1][1],self.data.rank[1][2]
    --if endR == -1 then endR = "" end
    if starR == endR and starR <= 3 then
        local imgRank = GetElement(self.m_root,"imgRank_CellAthRankReward",WZUIImage)
        imgRank:setFile(imgRankPath[starR])
        imgRank:setVisible(true)
    else
        local txtRank = GetElement(self.m_root,"txtRank_CellAthRankReward",WZUILabelTTF)
        if endR == -1 then
            txtRank:setText(starR.."+")
        else
            txtRank:setText(starR.."-"..endR)
        end
    end

    -- 奖励
    local mySex = CacheCenter:getPlayerInfo().sex
    local reward = mySex == 0 and self.data.reward_boy or self.data.reward_girl
    self.data.reward = reward
    local cnt = #reward > 5 and 5 or #reward
    for i = 1, cnt do
        local conR = GetElement(self.m_root,"conItem"..i.."_CellAthRankReward",WZUIContainer)

        -- 为了显示物品，构造部分道具的数据
        local key = "id_"..reward[i][1]
        reward[i].basicInfo = GDatatab_item[key]
        local count = reward[i][2]
        reward[i].lastNum = count

        local cell,tcell = CellGoodItem:createElement()
        conR:addChild(cell)
        cell:setScale(0.8)
        cell:setTag(i)
        tcell:setCellGoodItem(reward[i],2)
        tcell:setItemClickFun(self,self.onIconClick)
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------