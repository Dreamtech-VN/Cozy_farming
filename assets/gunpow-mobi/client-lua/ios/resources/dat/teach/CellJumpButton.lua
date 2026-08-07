--CellJumpButton.lua
--@brief	CellItem的数据模块
--@date		2015/8/18
--@author	莫剑峰
--@note		跳转项

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellJumpButton:onEnter(element)
	self.m_root = element

    --多语言版本界面适配
    AdaptLanguage(self)
end

--点击回调
function CellJumpButton:setDesc(desc)
    GetElement(self.m_root,"txtDesc_CellJumpButton",WZUILabelTTF):setText(desc)
end

--点击回调
function CellJumpButton:OnClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    local data = self.m_tData
    data.uiMainId = tonumber(data.uiMainId)
    WZLog("CellJumpButton:OnClick", data.uiMainId, data.uiSubId)
    if data.uiMainId == -1 then
        WndTeachJumpTalk:_update()
    elseif data.uiMainId == -2 then
        SceneCity:playMovie()
    else
        JumpByUIId(data.uiMainId, data.uiSubId)
    end
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellJumpButton:onExit(element)
	self:_unInit()
end

-------------------------------------私有方法模块Start----------------------------------------

--@brief  EN适配函数
--@note   EN适配函数
function CellJumpButton:_adaptLanguage_en()
    local txtDesc = GetElement(self.m_root,"txtDesc_CellJumpButton",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(160,0))
end

function CellJumpButton:_adaptLanguage_vn()
    

end 

function CellJumpButton:_adaptLanguage_pt()
    local txtDesc = GetElement(self.m_root,"txtDesc_CellJumpButton",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(160,0))
end 

function CellJumpButton:_adaptLanguage_th(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_CellJumpButton",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(160,0))
end

function CellJumpButton:_adaptLanguage_es(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_CellJumpButton",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(160,0))
end
-------------------------------------


