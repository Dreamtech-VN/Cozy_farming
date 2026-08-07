--CellMultiVideo.lua
--@brief	CellMultiVideo的UI模块
--@date		2016-6-12
--@author	binshao
--@note		组队副本录像单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMultiVideo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMultiVideo:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellMultiVideo:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellMultiVideo")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

-- 回调函数
function CellMultiVideo:onLook(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("------------send video data------------",self.data.recordId,self.data.mapId)
    WndMultiCopy:createLoadingBox()
    ProtocolProcessorGlobal:send_BATTLE_Record(self.data.recordId,6,self.data.mapId)
end


-- 查看第一个玩家
function CellMultiVideo:onCheckInfo1()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.pInfo[1].playerId)
end

-- 查看第二个玩家
function CellMultiVideo:onCheckInfo2()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.pInfo[2].playerId)
end

-- 查看第三个玩家
function CellMultiVideo:onCheckInfo3()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.pInfo[3].playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面
function CellMultiVideo:_update()
    -- 难度
    local path = {"ui/copy/copy_icon_jd1.png","ui/copy/copy_icon_kn1.png","ui/copy/copy_icon_dy1.png"}
    local imgDif = GetElement(self.m_root, "imgDif_CellMultiVideo", WZUIImage)
    imgDif:setFile(path[self.data.difficulty])

    local str = {LocalStrings.BEST_VIDEO_DIF1,LocalStrings.BEST_VIDEO_DIF2,LocalStrings.BEST_VIDEO_DIF3 }
    local txtDif = GetElement(self.m_root, "txtDif_CellMultiVideo", WZUILabelTTF)
    txtDif:setText(str[self.data.difficulty])

    -- 战斗力
    local txtFight = GetElement(self.m_root, "txtFight_CellMultiVideo", WZUILabelTTF)
    txtFight:setText(self.data.fight)

    -- 头像
    for i = 1, 3 do
        local pInfo = self.data.pInfo[i]
        local con = GetElement(self.m_root,"conHead"..i.."_CellMultiVideo",WZUIContainer)
        CellHead:show(con,pInfo.headId,pInfo.faceId,pInfo.sex,nil,nil,nil,pInfo.headColor)
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------------------------------------
function CellMultiVideo:_adaptLanguage_en(  )
    GetElement(self.m_root,"txt_CellMultiVideo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.427,0.5))
end

function CellMultiVideo:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txt_CellMultiVideo",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.449878,0.5))
    txt:setFontSize(18)
    GetElement(self.m_root,"txtFight_CellMultiVideo",WZUILabelTTF):setScale(0.8)
end

function CellMultiVideo:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txt_CellMultiVideo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.42,0.5))
    GetElement(self.m_root,"txtFight_CellMultiVideo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.755128,0.5))
end

function CellMultiVideo:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtFight_CellMultiVideo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.5))
end

function CellMultiVideo:_adaptLanguage_tr(  )
    local txt = GetElement(self.m_root,"txt_CellMultiVideo",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.449878,0.5))
    txt:setFontSize(18)
    GetElement(self.m_root,"txtFight_CellMultiVideo",WZUILabelTTF):setScale(0.8)
end

function CellMultiVideo:_adaptLanguage_es(  )
    local txt = GetElement(self.m_root,"txt_CellMultiVideo",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    txt:setScale(0.7)
    local txtFight = GetElement(self.m_root,"txtFight_CellMultiVideo",WZUILabelTTF)
    txtFight:setScale(0.7)
    txtFight:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
    GetElement(self.m_root,"txtDif_CellMultiVideo",WZUILabelTTF):setScale(0.6)
end
--------------------------------------语言适配End-------------------------------------------------------------------------