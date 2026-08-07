--CellWorldBossRankRewardItem.lua
--@brief	CellWorldBossRankRewardItem的UI模块
--@date		2015-9-18
--@author	binshao
--@note		排行奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWorldBossRankRewardItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWorldBossRankRewardItem:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellWorldBossRankRewardItem:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellWorldBossRankRewardItem")
    self.m_root:addChild(cellElement)
    self:_update()
end

--@brief    其它Item点击回调
function CellWorldBossRankRewardItem:onOthersClick(luaTable,tag,tData)
    WndItemInfo:onCloseClick()
    local con = GetElement(SceneWorldBoss.m_root,"conTips_SceneWorldBoss",WZUIContainer)
    WndItemInfo:showInfo(luaTable.m_root,con,1,tData,false)
end
-------------------------------------公有方法模块End----------------------------------------

-- 更新
local imgRankPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
function CellWorldBossRankRewardItem:_update( )
    -- 排名
    local rank = self.rankInfo.rank[1]
    local startRank = rank[1]
    local endRank = rank[2]
    if startRank <= 3 then
        local imgRank = GetElement(self.m_root,"imgRank_CellRankRewardItem",WZUIImage)
        imgRank:setFile(imgRankPath[startRank])
        imgRank:setVisible(true)
    else
        local txtRank = GetElement(self.m_root,"txtRank_CellRankRewardItem",WZUILabelTTF)
        if startRank <= 100 then txtRank:setFontSize(24) end
        if endRank == -1 then
            txtRank:setText(startRank.."+")
        else
            local strR = startRank == endRank and startRank or startRank.."-"..endRank
            txtRank:setText(strR)
        end
    end

    -- 奖励
    local reward = self.rankInfo.reward
	for i=1,#reward do
		local conItem = GetElement(self.m_root, "conItem"..i.."_CellWorldBossRankRewardItem", WZUIContainer)
		local shopItems = GDatatab_item["id_"..reward[i][1]]
        local itemInfo = {id=reward[i][1], name=shopItems.name,icon=shopItems.icon,
            lastNum=reward[i][2],quality=shopItems.quality,
            basicInfo = GetItemLocalData(reward[i][1]),customizeLastTime = reward[i][2]*86400}
		local celElement,tLuaObj = CellGoodItem:createElement()
		if celElement  then
        	celElement = WZUIContainer:luaTo(celElement)
        	tLuaObj:setCellGoodItem(itemInfo,16)
        	celElement:setScale(0.8)
        	tLuaObj:setItemClickFun(self,self.onOthersClick)
        	conItem:addChild(celElement)
    	end
	end
end

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------