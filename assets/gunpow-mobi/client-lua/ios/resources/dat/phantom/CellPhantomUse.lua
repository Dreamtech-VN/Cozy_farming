--CellPhantomUse.lua
--@brief	CellPhantomUse的UI模块
--@date		2017/04/25
--@author	zsq
--@note		幻化Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomUse:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantomUse:onExit(element)
	self:_unInit()
end

function CellPhantomUse:setData(tData) 
	self.m_tData = tData
	self:update()
end

function CellPhantomUse:setHighLight(bool) 
	local bool = bool or false
	GetElement(self.m_root,"imgHighlight_CellPhantomUse",WZUI9Image):setVisible(bool)
end

--@brief	使用体验卡
function CellPhantomUse:onUse() 
	WZLog("CellPhantomUse:onUse")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPhantomUse:update() 
	local tData = self.m_tData
	--怪物图片
	GetElement(self.m_root,"imgMonster",WZUIImage):setFile(tData.bust)
	--怪物名字
	GetElement(self.m_root,"ttfName_CellPhantomUse", WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root,"ttfName_CellPhantomUse", WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
end




-------------------------------------私有方法模块End----------------------------------------
