--CellWakeupPowerItem.lua
--@brief	CellWakeupPowerItem的UI模块
--@date		2017/05/24
--@author	Tianxiang_Xu
--@note		觉醒之力的技能节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWakeupPowerItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWakeupPowerItem:onExit(element)
	self:_unInit()
end

--@brief    点击使用按钮回调
function CellWakeupPowerItem:onClickSkill(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = self.m_root:getTag()

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], element, self, self.m_tData)
    end
end

--@brief    开始加载
function CellWakeupPowerItem:onLoadData(element)
    -- body
    self:_update()
end

--@brief    刷新数据
function CellWakeupPowerItem:resetData(tData)
    -- body
    self.m_tData = tData 
    self:_update()
end

--@brief    获取天赋技能数据
function CellWakeupPowerItem:getData()
    -- body
    return self.m_tData 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellWakeupPowerItem:_update()
    -- body
    local tData = GDatatab_talent_Skill["id_" .. self.m_tData.id] 
    if tData == nil then return end 
    self.m_root:removeAllChildrenWithCleanup(true)
    local bGrayRender = false
    if tData.level == 0 then 
        bGrayRender = true
    end
    --图标框
    local imgRect = WZUIImage:create()
    imgRect:setFile("ui/common/common_icon_jinengkuang.png")
    imgRect:setGrayRender(bGrayRender)
    self.m_root:addChild(imgRect)

    imgRect = WZUIImage:create()
    imgRect:setFile("ui/combat/common_icon_kdi.png")
    imgRect:setScale(0.85)
    imgRect:setGrayRender(bGrayRender)
    self.m_root:addChild(imgRect)
    --图标
    local imgIcon = WZUIImage:create()
    imgIcon:setUseOriginSize(true)
    imgIcon:setFile(tData.icon)
    imgIcon:setGrayRender(bGrayRender)
    self.m_root:addChild(imgIcon)
    --等级
    imgRect = WZUIImage:create()
    imgRect:setUseOriginSize(true)
    if tData.level == 0 then 
        imgRect:setFile("battleitems/battle_icon_jnl1.png")
    else
        imgRect:setFile("battleitems/battle_icon_jnl" .. tData.level .. ".png")
    end
    imgRect:setAnchorPoint(GlobalMethod:ccp(1, 0))
    imgRect:setRelativePosition(GlobalMethod:ccp(0.95, 0.1))
    imgRect:setGrayRender(bGrayRender)
    self.m_root:addChild(imgRect)
    --名字
    -- local txtName = WZUILabelTTF:create()
    -- txtName:setFontSize(18)
    -- txtName:setText(tData.name)
    -- txtName:setColor(GlobalMethod:ccc3(255,236,193))
    -- txtName:setRelativePosition(GlobalMethod:ccp(0.5,0))
    -- self.m_root:addChild(txtName)
    --按钮
    local btnItem = WZUIButton:create()
    btnItem:setLuaDoneFunctionName("onClickSkill")
    self.m_root:addChild(btnItem)
end
-------------------------------------私有方法模块End----------------------------------------
