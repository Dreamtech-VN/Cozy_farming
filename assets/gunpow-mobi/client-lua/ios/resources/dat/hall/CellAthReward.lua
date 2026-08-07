--CellAthReward.lua
--@brief	CellAthReward的UI模块
--@date		2015-6-6
--@author	binshao
--@note		竞技场奖励模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthReward:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellAthReward:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellAthReward")
    self.m_root:addChild(cellElement)
    self:_update()
end

--@brief 点击物品图标弹出信息框
function CellAthReward:onIconClick(luaTable,tag)
    local data = self.tData.data
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndAthReward.m_root,1,self.tData.reward[tag],false,nil,nil,other)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellAthReward:_update()
    self:_setLevelUI()
    self:_createRewardUI()

    local curLv = CacheCenter:getPlayerInfo().tournamentLevel
    local conR = GetElement(self.m_root,"conGet_CellAthReward",WZUIContainer)
    conR:setVisible(curLv >= self.tData.level)
end

function CellAthReward:_createRewardUI()
    local reward = self.tData.reward
    local cnt = #reward > 4 and 4 or #reward
    for i = 1, cnt do
        local conR = GetElement(self.m_root,"conDescReward"..i.."_CellAthReward",WZUIContainer)

        -- 为了显示物品，构造部分道具的数据
        local key = "id_"..reward[i][1]
        reward[i].basicInfo = GDatatab_item[key]
        local count = reward[i][2]
        reward[i].lastNum = count

        local cell,tcell = CellGoodItem:createElement()
        conR:addChild(cell)
        cell:setTag(i)
        tcell:setCellGoodItem(reward[i],2)
        tcell:setItemClickFun(self,self.onIconClick)
    end

    local imgLv = GetElement(self.m_root,"imgAthLv_CellAthReward",WZUIImage)
    imgLv:setFile("ui/common/"..self.tData.iocn..".png")


    local txtLv = GetElement(self.m_root,"txtAthLv_CellAthReward",WZUILabelAtlasFont)
    txtLv:setText(self.tData.iocn_level)
end

function CellAthReward:_setLevelUI()
    local txtLevel = GetElement(self.m_root,"txtLevel_CellAthReward",WZUILabelTTF)
    txtLevel:setText(self.tData.dan)
end
-------------------------------------私有方法模块End----------------------------------------