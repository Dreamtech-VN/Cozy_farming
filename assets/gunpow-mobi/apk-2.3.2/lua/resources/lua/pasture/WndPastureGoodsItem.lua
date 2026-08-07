--WndPastureGoodsItem.lua
--@brief	WndPastureGoodsItem的UI模块
--@date		2021/04/19
--@author	hyx
--@note		牧场背包物品


-------------------------------------公有方法模块Begin--------------------------------------
WndPastureGoodsItem.GOODS_WIDTH = 72
WndPastureGoodsItem.GOODS_HEIGHT = 72
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureGoodsItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureGoodsItem:onExit(element)
	self:_unInit()
end
function WndPastureGoodsItem:onEnterTransitionDidFinish(element)

end
--[[
icon: 物品资源
lv_icon: 等级
icon_num: 物品数量
]]
function WndPastureGoodsItem:_updata()
	if not self.m_root then return end
	self.m_root:setScale(self.m_nScale)
	local imgIcon = GetElement(self.m_root,"imgIcon",WZUIImage)
	imgIcon:setVisible(false)
	local imgLev = GetElement(self.m_root,"imgLev",WZUIImage)
	imgLev:setVisible(false)
	local imgAdd = GetElement(self.m_root,"imgAdd",WZUIContainer)
	imgAdd:setVisible(false)
	local img_kuang = GetElement(self.m_root,"img_kuang",WZUIImage)
	img_kuang:setVisible(false)
	if self.m_bIsAdd == true then
		imgAdd:setVisible(true)
	end
	if self.m_tItemData then
		imgIcon:setFile(self.m_tItemData.icon)
		imgIcon:setVisible(true)
		imgLev:setFile(self.m_tItemData.lv_icon)
		imgLev:setVisible(true)
		img_kuang:setVisible(true)
	end
end
--显示数量
function WndPastureGoodsItem:setHasNum(num)
	local txtNum = GetElement(self.m_root,"txtNum",WZUILabelTTF)
	if txtNum then
		txtNum:setText(num)
	end
end
function WndPastureGoodsItem:onBtnAdd()
	if self.m_sCallFunc then
		local tag = self.m_root:getTag()
		self.m_sCallFunc(tag)
	end
end
--是否显示tips
function WndPastureGoodsItem:onBtnTips(element)
	if self.m_bIsShowTips == false then return end

	if self.m_sOtherCallFunc then
		local tag = self.m_root:getTag()
		self.m_sOtherCallFunc(tag)
	end
	if self.m_tItemData and self.m_bIsShowTips == true then
		WndPastureTips:showInterface(self.m_tItemData.id)
		if self.m_tOteherData then
			self.m_tOteherData = self.m_tOteherData or {}
			WndPastureTips:setOtherVisible(self.m_tOteherData.next_desc or false)
		end
	end
end
--是否显示tips  默认不能弹tips
function WndPastureGoodsItem:setDefaultTip(isShowTips)
	self.m_bIsShowTips = isShowTips or false
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
