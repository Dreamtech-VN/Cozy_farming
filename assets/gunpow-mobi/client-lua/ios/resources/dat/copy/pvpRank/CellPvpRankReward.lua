--CellPvpRankReward.lua
--@brief	CellPvpRankReward的UI模块
--@date		2015-11-11
--@author	binshao
--@note		排位赛奖励物品

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankReward:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellPvpRankReward:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellPvpRankReward")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief    其它Item点击回调
function CellPvpRankReward:onItemClick(luaObject,tag)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.callFunc[2](self.callFunc[1],luaObject,self.reward[tag])
end
-------------------------------------公有方法模块End----------------------------------------


--------------------------------私有方法模块Begin--------------------------------------

function CellPvpRankReward:_update( )
    -- 描述
    local tData = self.data
    local ftxtDesc = GetElement(self.m_root, "ftxtDesc_CellPvpRankReward", WZUIFreeTextBox)
    if ftxtDesc then
        ftxtDesc:setShowText(tData.text)
    end
    -- 奖励
    local reward
    if CacheCenter:getPlayerInfo().sex == 0 then
        reward = tData.reward
    else
        reward = tData.reward2
    end

    local nIndex = 3 
    for i = #reward, 1, -1 do
        local conItem = GetElement(self.m_root, "conItem"..nIndex.."_CellPvpRankReward", WZUIContainer)

        local shopItems = GDatatab_item["id_"..reward[i][1]]
        local itemInfo = {id=reward[i][1], name=shopItems.name,icon=shopItems.icon,lastNum=reward[i][2],quality=shopItems.quality ,basicInfo=shopItems}
        self.reward[i] = itemInfo
        local cell,tcell = CellGoodItem:createElement()
        if cell and tcell then
            cell = WZUIContainer:luaTo(cell)
            if shopItems.main_type == 5 then
                tcell:setCellGoodItem(itemInfo,17)
            else
                tcell:setCellGoodItem(itemInfo,4)
            end
            cell:setScale(0.8)
            tcell:setItemClickFun(self,self.onItemClick)
            conItem:addChild(cell)
            cell:setTag(i)
        end
        if i == 1 then
            local imgCornerIcon = GetElement(self.m_root, "imgCornerIcon" .. nIndex .. "_CellPvpRankReward", WZUIImage)
            if self.m_nIndex == 1 then
                imgCornerIcon:setVisible(true)
                imgCornerIcon:setFile("ui/common/common_icon_zhuanshu.png")
            end
        end

        nIndex = nIndex - 1
    end
end
--------------------------------私有方法模块End----------------------------------------

---------------------------------语言适配Begin-----------------------------------------------
function CellPvpRankReward:_adaptLanguage_en(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(500)
end

function CellPvpRankReward:_adaptLanguage_pt(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(450)
end

function CellPvpRankReward:_adaptLanguage_tr(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(450)
end

function CellPvpRankReward:_adaptLanguage_th(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(400)
end

function CellPvpRankReward:_adaptLanguage_vn(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(450)
end

function CellPvpRankReward:_adaptLanguage_es(  )
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellPvpRankReward",WZUIFreeTextBox)
    ftxtDesc:setMaxWidth(450)
end
---------------------------------语言适配End--------------------------------------------------