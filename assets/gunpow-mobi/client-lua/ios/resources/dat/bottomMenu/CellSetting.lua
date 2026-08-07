--CellSetting.lua
--@brief	CellSetting的UI模块
--@date		2014/03/27
--@author	liangguang_long
--@note		设置模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSetting:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSetting:onExit(element)
	self:_unInit()
end

function CellSetting:onClickFun(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element = WZUIButton:luaTo(element)
	self.m_tData[2](self.m_tData[1] , element)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellSetting:_update()
	--显示按钮
	self:_showBtn()
	--显示按钮文本
	self:_setBtnTxt()
end

--@brief	创建图片
--@param	icon:图片路径
function CellSetting:_createImage(icon)
	local img = WZUI9Image:create()
	img:setFile(icon)
	return img
end

--@brief	显示按钮
function CellSetting:_showBtn()
	if self.m_tData then
		local btnSDK = self.m_root:getChildElement("btnSDK_CellSetting")
		if btnSDK then
			btnSDK = WZUIButton:luaTo(btnSDK)
			local norElement = self:_createImage(self.m_tData[3])
			local selElement = self:_createImage(self.m_tData[4])
			btnSDK:setNormalElement(norElement)
			btnSDK:setSelectElement(selElement)
		end
	end
end

--@brief	显示按钮文本
function CellSetting:_setBtnTxt()
	if self.m_tData then
		local txtBtn = self.m_root:getChildElement("txtBtn_CellSetting")
		if txtBtn then
			txtBtn = WZUILabelTTF:luaTo(txtBtn)
			local str = LocalStrings[self.m_tData[5]] or self.m_tData[5]
			txtBtn:setText(str)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------





