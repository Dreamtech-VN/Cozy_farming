--CellActorInfo.lua
--@brief	CellActorInfo的UI模块
--@date		2016-10-20
--@author	binshao

-------------------------------------公有方法模块--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
--param 
function CellActorInfo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActorInfo:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellActorInfo:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellActorInfo")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end


-- 点击回调
function CellActorInfo:onSelectActor()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = self.m_root:getTag()
    WZLog("--------------onSelectActor------------",tag)
    SceneSelectActor:updateRoleInfo(tag+1)
end

-------------------------------------私有方法模块--------------------------------------

--@brief  更新cell界面元素
function CellActorInfo:_update()
	if self.m_root == nil then return end
	if self.loadEnd == false then return end
    local data = self.data

    -- 玩家名字和等级
    local ftbNameLv = GetElement(self.m_root, "ftbNameLv_CellActorInfo", WZUIFreeTextBox)
    ftbNameLv:setShowText(string.format(LocalStrings.ACTOR_NAME_LV,data.level,data.name))

    -- 战斗力
    local ftbFight = GetElement(self.m_root, "ftbFight_CellActorInfo", WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.ACTOR_FIGHT,data.fighting))

    -- 头像
    local con = GetElement(self.m_root, "conHead_CellActorInfo", WZUIContainer)
    local cell,tcell = CellHead:show(con,data.headId,data.faceId,data.sex,nil,nil,data.vipLevel, data.colour)
    cell:setScale(1.5)

    SceneSelectActor:setSelectState()
end

--@brief 设置试穿图片的显示状态
function CellActorInfo:setSelect(bVisible)
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conPar_CellActorInfo", WZUIContainer)
    con:setVisible(bVisible)
end

-----------------------------------------------语言适配Begin-----------------------------------------------------------
function CellActorInfo:_adaptLanguage_en(  )
    GetElement(self.m_root,"ftbNameLv_CellActorInfo",WZUIFreeTextBox):setScale(0.8)
end
-----------------------------------------------语言适配End-------------------------------------------------------------