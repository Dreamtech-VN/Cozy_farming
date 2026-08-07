--CellStarSoul.lua
--@brief	CellStarSoul的UI模块
--@date		2015/12/19
--@author	Tianxiang_Xu
--@note		星魂图标


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellStarSoul:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellStarSoul:onExit(element)
	self:_unInit()
end

--@brief    点击回调
function CellStarSoul:onClickCallBack(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WZLog("******** CellStarSoul:onClickCallBack ***********", self.m_tData.id, self.m_tData.star,self.m_tData.star_soul, self.m_tData.status) 
   if self.m_tCallbackFunction ~= nil and self.m_tCallback ~=nil then
      self.m_tCallbackFunction(self.m_tCallback, element, self.m_tData.id, self.m_tData.star,self.m_tData.star_soul, self.m_tData.status, self.m_tData.cost, self.m_tData.absPosition)
   end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新子节点信息
function CellStarSoul:_updateInfo()
    --body
    
    local spineStar = GetElement(self.m_root, "spineStar_CellStarSoul", WZUISpine)
    if self.m_tData.status == 2 then
        WZLog("**********000***********",self.m_tData.starsoul_icon)
        spineStar:play(self.m_tData.starsoul_icon,true)
        WZLog("**********111***********")
    elseif self.m_tData.status == 1 then
        spineStar:play(self.m_tData.starsoul_icon .. "_unlock",true)
    else
        spineStar:play(self.m_tData.starsoul_icon .. "_lock",true)
    end

    if self.m_tData.status == 1 then
        GetElement(self.m_root, "conNextStar_CellStarSoul", WZUIContainer):setVisible(true)
        --星座名字
        GetElement(self.m_root, "txtStarName_CellStarSoul", WZUILabelTTF):setText(self.m_tData.star_name)
        --属性加成
        GetElement(self.m_root, "txtPropertyName_CellStatSoul", WZUILabelTTF):setText(ATTR_TITLE[self.m_tData.property[1][1]])
        GetElement(self.m_root, "txtPropertyValue_CellStarSoul", WZUILabelTTF):setText("+" .. tostring(self.m_tData.property[1][2]))
        --消耗类型，数量
        local sNeedName = LocalStrings.NEED_STAR
        local sCoinIconFile = self:_getIconFile(self.m_tData.cost[1][1])
        GetElement(self.m_root, "imgCoins_CellStarSoul", WZUIImage):setFile(sCoinIconFile)
        GetElement(self.m_root, "txtNeedName_CellStatSoul", WZUILabelTTF):setText(sNeedName)
        GetElement(self.m_root, "txtNeedValue_CellStarSoul", WZUILabelTTF):setText(self.m_tData.cost[1][2])
    else
        GetElement(self.m_root, "conNextStar_CellStarSoul", WZUIContainer):setVisible(false)
    end

end

--@brief    获取奖励物品的图标
function CellStarSoul:_getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

-------------------------------------私有方法模块End----------------------------------------
