--WndCopyExpInfoView.lua
--@brief	WndCopyExpInfoView的UI模块
--@date		2015/09/08
--@author	moboqing
--@note		日常副本UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyExpInfoView:onEnter(element)
	self.m_root = element
	 --语言适配函数
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyExpInfoView:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin--------------------------------------

--@brief 英文适配函数
--@note  英文适配
function WndCopyExpInfoView:_adaptLanguage_en()
    --body
	GetElement(self.m_root,"txtFailNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.85,0.2))
end


--@brief 越南适配函数
function WndCopyExpInfoView:_adaptLanguage_vn()
    --body
	GetElement(self.m_root,"eliteNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.793414,0.6))
end
function WndCopyExpInfoView:_adaptLanguage_pt(  )
	GetElement(self.m_root,"bossNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.288414,0.8))
	GetElement(self.m_root,"eliteNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.648414,0.6))
	GetElement(self.m_root,"commonNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.753414,0.4))
	GetElement(self.m_root,"txtFailNum_WndCopperInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.828414,0.2))
end

function WndCopyExpInfoView:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtCommon_WndCopyExpInfoView",WZUILabelTTF):setScale(0.76)
end

function WndCopyExpInfoView:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtElite_WndCopyExpInfoView",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtCommon_WndCopyExpInfoView",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtFail_WndCopyExpInfoView",WZUILabelTTF):setFontSize(14)
	local eliteNum = GetElement(self.m_root,"eliteNum_WndCopperInfoView",WZUILabelTTF)
	eliteNum:setRelativePosition(GlobalMethod:ccp(0.838,0.6))
	local txtFailNum = GetElement(self.m_root,"txtFailNum_WndCopperInfoView",WZUILabelTTF)
	txtFailNum:setRelativePosition(GlobalMethod:ccp(0.768,0.2))
end
-------------------------------------语言适配模块End----------------------------------------
