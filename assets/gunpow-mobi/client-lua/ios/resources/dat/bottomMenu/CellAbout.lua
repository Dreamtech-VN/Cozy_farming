--CellAbout.lua
--@brief	CellAbout的UI模块
--@date		2014/03/25
--@author	liangguang_long
--@note		微博模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAbout:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAbout:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------

--@brief	微博按钮回调函数
--@param	element:表绑定的UI节点引用
function CellAbout:onWeiboClick(element)
	self.m_sBackFun(self.m_tCell , self.m_sURL)
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellAbout:_update()
	if self.m_tAbout == nil then
		return
	end
	--设置按钮基本数据
	self:_setBtnData(self.m_tAbout)
end

--@brief	设置按钮基本数据
--@param	tIcon：状态图片路径列表
--@return	btnWeibo：返回按钮节的
function CellAbout:_setBtnData(tIcon)
	local btnWeibo = self.m_root:getChildElement("btnWeibo_CellAbout")
	if btnWeibo then
		btnWeibo = WZUIButton:luaTo(btnWeibo)
		local norElement = self:_createImage( tIcon[1] )
		local selElement = self:_createImage( tIcon[2] )
		btnWeibo:setNormalElement(norElement)
		btnWeibo:setSelectElement(selElement)
		return btnWeibo
	end
end

--@brief	创建图片函数
--@param	icon：图片路径(可nil)
--@param	bOriginal：是否用原始大小
--@return	img：返回图片节的
function CellAbout:_createImage(icon , bOriginal)
	bOriginal = bOriginal or true
	icon = icon or "ui/bottomMenu/setting/sina_icon.png"
	local img = WZUIImage:create()
	img:setUseOriginSize(bOriginal)
	img:setFile(icon)
	return img
end



-------------------------------------私有方法模块End----------------------------------------
