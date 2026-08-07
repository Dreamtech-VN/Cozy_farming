--CellTransactionTab3.lua
--@brief	CellTransactionTab3的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行小标签


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionTab3:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionTab3:onExit(element)
	self:_unInit()
end

function CellTransactionTab3:onSubTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	if self.m_tData.m_nTag == 4 then
		tag = 4
	elseif self.m_tData.m_nTag == 5 then
		tag = 1
	end
	WndTransaction.m_nCurType = self.m_tData.m_nTag
	WndTransaction.m_nCurQuality = tag

	--取商品列表
	WndTransaction:sendGetCommodityList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTransactionTab3:setTitle(text)
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setText(text)
end

function CellTransactionTab3:setSubTitle(text)
	GetElement(self.m_root,"txtSubTitle1_CellTransactionTab3",WZUILabelTTF):setText(text)
end

function CellTransactionTab3:setData(tData)
	local mainTab = {LocalStrings.TRANSACTION3,LocalStrings.TRANSACTION2,LocalStrings.TRANSACTION4,LocalStrings.TRANSACTION5,LocalStrings.TRANSACTION58}
	self.m_tData = tData

	self:setTitle(mainTab[tData.m_nTag])

	local str = ""
	if tData.m_nTag == 4 then
		str = LocalStrings.TRANSACTION57
	elseif tData.m_nTag == 5 then
		str = LocalStrings.TRANSACTION58
	end
	self:setSubTitle(str)
	
	if WndTransaction.m_nCurQuality == nil then WndTransaction.m_nCurQuality = 1 end
	GetElement(self.m_root,"checkBoxGroup",WZUICheckBoxGroup):setCheckIndex(WndTransaction.m_nCurQuality-1)
end


-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTransactionTab3:_adaptLanguage_en( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab3:_adaptLanguage_pt( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab3:_adaptLanguage_es( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab3:_adaptLanguage_tr( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab3:_adaptLanguage_ug( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtQuality_CellTransactionTab3",WZUILabelTTF):setScale(0.75)
end
---------------------------------------语言适配End------------------------------------------