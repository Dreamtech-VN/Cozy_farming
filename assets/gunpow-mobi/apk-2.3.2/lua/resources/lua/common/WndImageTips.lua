--WndImageTips.lua
--@brief	WndImageTips的UI模块
--@date		2023/03/11
--@author	nijinlin
--@note		创建一个显示图片的弹框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndImageTips:onEnter(element)
	WZLog("WndImageTips:onEnter", self.imagePath)
	self.m_root = element
	local img_WndImageTips = GetElement(self.m_root,"img_WndImageTips",WZUI9Image)
	if img_WndImageTips and self.imagePath and self.imagePath ~= "" then
		WZLog("WndImageTips:onEnter 111", self.imagePath)
		img_WndImageTips:setFile(self.imagePath)
	end
	local freeText_WndImageTips = GetElement(self.m_root,"freeText_WndImageTips",WZUIFreeTextBox)
	if freeText_WndImageTips and self.content and self.content ~= "" then
		WZLog("WndImageTips:onEnter 222", self.content)
		freeText_WndImageTips:setShowText(self.content)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndImageTips:onExit(element)
	self:_unInit()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndImageTips:onCloseBtnClicked(element)
	--删除二维码图片
	if isChannelFlashHall() then
		if WZFileUtil and WZFileUtil.removeFile then
			WZLog("WndImageTips:onCloseBtnClicked go to remove local image:", self.imagePath)
			WZFileUtil:removeFile(self.imagePath)
		end
	end		
	if WndImageTips.m_root ~= nil then
		WindowManager:removeWindow(WndImageTips.m_root, WndImageTips, true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
