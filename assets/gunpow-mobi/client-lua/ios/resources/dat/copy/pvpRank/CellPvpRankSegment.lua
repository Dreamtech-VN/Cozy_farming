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
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellPvpRankSegment:_update( )
    local data = self.data
    local imgDi = GetElement(self.m_root,"imgLvDi_CellPvpRankSegment",WZUIImage)
    imgDi:setFile("ui/common/"..data.iocn..".png")
    local lafLv = GetElement(self.m_root,"lafLv_CellPvpRankSegment",WZUILabelAtlasFont)
    lafLv:setText(data.iocn_level)

    local txtName = GetElement(self.m_root,"txtLevelName_CellPvpRankSegment",WZUILabelTTF)
    txtName:setText(data.name)

    -- 奖励
    local reward = self.data.unlock
    for i=1,#reward do
        WZLog("----------------888----------------",i)
        local conItem = GetElement(self.m_root, "conItem"..i.."_CellPvpRankSegment", WZUIContainer)
        local shopItems = GDatatab_item["id_"..reward[i][1]]
        local itemInfo = {id=reward[i][1], name=shopItems.name,icon=shopItems.icon,lastNum=reward[i][2],quality=shopItems.quality }
        self.reward[i] = itemInfo
        local cell,tcell = CellGoodItem:createElement()
        if cell  then
            cell = WZUIContainer:luaTo(cell)
            tcell:setCellGoodItem(itemInfo,4)
            cell:setScale(0.9)
            tcell:setItemClickFun(self,self.onItemClick)
            conItem:addChild(cell)
            cell:setTag(i)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------