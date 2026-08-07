--CellTransactionTab1.lua
--@brief	CellTransactionTab1的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行大标签


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionTab1:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionTab1:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTransactionTab1:setTitle(text)
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setText(text)
end

function CellTransactionTab1:setData(tData)
	local mainTab = {LocalStrings.TRANSACTION3,LocalStrings.TRANSACTION2,LocalStrings.TRANSACTION4,LocalStrings.TRANSACTION5,LocalStrings.TRANSACTION58}
	self.m_tData = tData

	self:setTitle(mainTab[tData.m_nTag])
end

function CellTransactionTab1:onClickCellItem()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndTransaction.m_nCurType = self.m_tData.m_nTag
	if self.m_tData.m_nTag == 4 then 
		WndTransaction.m_nCurType = self.m_tData.m_nTag
		WndTransaction.m_nCurQuality = 4

		--取商品列表
		WndTransaction:sendGetCommodityList()
		return 
	elseif self.m_tData.m_nTag == 5 then 
		WndTransaction.m_nCurType = self.m_tData.m_nTag
		WndTransaction.m_nCurQuality = 1

		--取商品列表
		WndTransaction:sendGetCommodityList()
		return 
	else
		WndTransaction.m_nCurType = self.m_tData.m_nTag
		if WndTransaction.m_nCurQuality == 4 or WndTransaction.m_nCurQuality == 5 then
			WndTransaction.m_nCurQuality = 1
		end

		--取商品列表
		WndTransaction:sendGetCommodityList()
	end
	WndTransaction:update()
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTransactionTab1:_adaptLanguage_en( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab1:_adaptLanguage_pt( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab1:_adaptLanguage_es( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab1:_adaptLanguage_tr( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end

function CellTransactionTab1:_adaptLanguage_ug( )
	GetElement(self.m_root,"txt_subItemName",WZUILabelTTF):setScale(0.6)
end
---------------------------------------语言适配End------------------------------------------