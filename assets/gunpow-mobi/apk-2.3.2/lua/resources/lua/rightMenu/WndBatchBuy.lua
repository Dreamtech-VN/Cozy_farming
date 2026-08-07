--WndBatchBuy.lua
--@brief	WndBatchBuy的UI模块
--@date		2021/10/12
--@author	hyc
--@note		批量购买界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBatchBuy:onEnter(element)
	WZLog("WndBatchBuy:onEnter")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBatchBuy:onExit(element)
	self:_unInit()
end

function WndBatchBuy:onLoadData()
	-- body
	WZLog("WndBatchBuy:onLoadData")
	self:updateView()
end

function WndBatchBuy:updateView()
	-- body
	WZLog("WndBatchBuy:updateView()",Serialize(self.m_data))
	local txt = GetElement(self.m_root,"txtShow",WZUIFreeTextBox)
	WZLog("批量购买礼包",self.m_data.number,self.m_data.name,self.m_data.showPrice)
	txt:setShowText(string.format(LocalStrings.BATCH_BUY_TEXT,tonumber(self.m_data.number),self.m_data.name,self.m_data.showPrice))
	local txtPrice1 = GetElement(self.m_root,"txtPrice1",WZUILabelTTF)
	txtPrice1:setUseSystemFont(true)
	txtPrice1:setText(self.m_data.showPrice .. LocalStrings.BUY)
end

function WndBatchBuy:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

function WndBatchBuy:onBuy(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndApartmentAct:buy4(nil, 1)
	
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
