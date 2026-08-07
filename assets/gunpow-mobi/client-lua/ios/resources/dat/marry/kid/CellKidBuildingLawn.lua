--CellKidBuildingLawn.lua
--@brief	CellKidBuildingLawn的UI模块
--@date		2017/08/10
--@author	Tianxiang_Xu
--@note		家园建筑草地节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidBuildingLawn:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidBuildingLawn:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellKidBuildingLawn:_update()
    -- body
    --设置相应容器大小
    self:_setContainerSize()
    --设置建筑底部草地
    self:setBuildingBG()
end

--@brief    设置Cell容器大小
function CellKidBuildingLawn:_setContainerSize()
    -- body
    local tData = self.m_tData.basicData
    local element = WZUIContainer:luaTo(self.m_root)

    --计算容器大小
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

    element:setContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
    element:setRelativeSize(GlobalMethod:CCSize(1,1))
    element:updateRelativeSize()
end

--@brief    设置建筑底部草地
--@brief    state:默认显示草地；1->显示绿色；2->显示红色
function CellKidBuildingLawn:setBuildingBG(state)
    -- body
    local tData = self.m_tData.basicData

    local conForBG = self:_createConForBG()
    local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 

    if conForBG then
        conForBG:removeAllChildrenWithCleanup(true)
        if state == -1 then return end 
        
        for i = 1, tData.size[1][1] do
            local startX = 0 + (i - 1) * gapX
            local startY = tData.size[1][1] * 0.5 * KID_MAP_SIZEY - (i - 1) * gapY
            for j = 1, tData.size[1][2] do
                local imgMap = WZUIImage:create()
                imgMap:setUseOriginSize(true)
                imgMap:setUseAbsCoordinate(true)
                if state == 1 then 
                    imgMap:setFile("ui/kid/kidicon/kid_sel.png")
                elseif state == 2 then 
                    imgMap:setFile("ui/kid/kidicon/kid_sel.png")
                    imgMap:setColor(GlobalMethod:ccc3(200,0,0))
                end 
                imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
                
                conForBG:addChild(imgMap)
            end
        end
    end
end

--@brief    创建背景容器节点
function CellKidBuildingLawn:_createConForBG()
    -- body
    local conForBG = self.m_root:getChildByTag(93)

    if not conForBG then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

        conForBG = WZUIContainer:create()
        conForBG:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conForBG:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        conForBG:setTouchEnable(false)
        conForBG:setUseAbsSize(true)
        conForBG:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForBG:setZOrder(0)
        conForBG:setTag(93)

        BattleAnimation:addRect({x=nConWidth/2, y=nConHeight/2, w=nConWidth, h=nConHeight},{r = 0,g = 0,b = 255,a = 1.0},conForBG)

        self.m_root:addChild(conForBG)
    end

    return conForBG
end
-------------------------------------私有方法模块End----------------------------------------
