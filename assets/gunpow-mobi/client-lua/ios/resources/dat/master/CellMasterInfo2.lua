--CellMasterInfo2.lua
--@brief	CellMasterInfo2的UI模块
--@date		2015/05/29
--@author	zsq
--@note		类型2师徒消息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterInfo2:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterInfo2:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置消息
function CellMasterInfo2:setMasterInfo2(tData)
	WZLog("CellMasterInfo2:setMasterInfo2",Serialize(tData))
	self.m_tData = tData
	GetElement(self.m_root,"ttfLevel_CellMasterInfo2",WZUILabelTTF):setText(tData.message)

	CellHead:show(GetElement(self.m_root,"conHead_CellMasterInfo2",WZUIContainer),tData.headId,tData.faceId,tData.sex,nil,nil,nil,tData.headColor)
end

--@brief	查看人物信息
function CellMasterInfo2:onCheck(element)
	WZLog("CellMasterInfo2:onCheck",self.m_tData.playerId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)  --点击音效
	WndCheckOther:show(self.m_tData.playerId)
end


-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellMasterInfo2:_adaptLanguage_en(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterInfo2",WZUILabelTTF)
	ttfLevel:setMaxLength(350)
	ttfLevel:setDimensions(GlobalMethod:CCSize(720))
end

function CellMasterInfo2:_adaptLanguage_pt(  )
	local ttf = GetElement(self.m_root,"ttfLevel_CellMasterInfo2",WZUILabelTTF)
	ttf:setMaxLength(350)
	ttf:setFontSize(18)
end

function CellMasterInfo2:_adaptLanguage_th(  )
	GetElement(self.m_root,"ttfLevel_CellMasterInfo2",WZUILabelTTF):setMaxLength(350)
end

function CellMasterInfo2:_adaptLanguage_tr(  )
	local ttfLevel = GetElement(self.m_root,"ttfLevel_CellMasterInfo2",WZUILabelTTF)
	ttfLevel:setMaxLength(350)
	ttfLevel:setDimensions(GlobalMethod:CCSize(720))
end
--------------------------------------语言适配End-------------------------------------------