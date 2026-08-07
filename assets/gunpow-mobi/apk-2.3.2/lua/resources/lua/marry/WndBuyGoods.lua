--WndBuyGoods.lua
--@brief	WndBuyGoods的UI模块
--@date		2014/04/28
--@author	林庆凯
--@modify   qixiang_xie
--@note		购买红包/礼炮的窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuyGoods:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuyGoods:onExit(element)
	self:_unInit()
end



--@brief	关闭窗口的函数
--@param	element:表绑定的UI节点引用
function WndBuyGoods:onClose(element)
	WZLog("WndBuyGoods:onClose(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, WndBuyGoods, true)
end 

--@brief	点击确定按钮的函数
--@param	element:表绑定的UI节点引用
function WndBuyGoods:onSureBtn(element)
	WZLog("WndBuyGoods:onSureBtn(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCostType == 1 then
		self.m_nCostType = 2
	else
		self.m_nCostType = 1
	end
	local hasGoodsCount =  CacheCenter:getPlayerItemCountById(self.m_nCostType) 
	if hasGoodsCount >= self.m_nPrice then
		if self.m_lpBackButtonCallback ~= nil then
    	   local tLuaObj = self.m_tCallBackLuaObjMap[self.m_lpBackButtonCallback]
    	   self.m_lpBackButtonCallback(tLuaObj)
        end
	else
		local tips = nil
		if  self.m_nCostType == 2 then
			tips = string.format(LocalStrings.COST_GOODS_TIPS1,self.m_nPrice)
		else
			tips = string.format(LocalStrings.COST_GOODS_TIPS2,self.m_nPrice)
		end
		MsgBoxManager:showTipBox(tips)
	end
	WindowManager:removeWindow(self.m_root, WndBuyGoods, true)
end 


--@brief 设置购买商品类型，需要钻石数
--@param  goodsName : 商品名
--@param goodsCostType : 花费类型(1：金币 2：钻石)
--@param goodsCostCount : 花费总数
--@param #1  sNum  数量
function WndBuyGoods:SetPlaceHollText(goodsName,goodsCostType,goodsCostCount)
	WZLog("WndBuyGoods:SetPlaceHollText")
	local txtCostCountTips = GetElement(self.m_root,"txtCostCountTips_WndBuyGoods",WZUILabelTTF)
	txtCostCountTips:setText(LocalStrings.BUY..goodsName.."?")
    local costType = WZUIImage:luaTo(self.m_root:getChildElement("imgCostType_WndBuyGoods"))
    if goodsCostType == 1 then
        costType:setFile("ui/common/common_icon_jinbi.png")
    elseif goodsCostType ==2 then
    	costType:setFile("ui/common/common_icon_zuanshi.png")
    end
    self.m_nCostType = goodsCostType
    self.m_nPrice = goodsCostCount
     WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCostCount_WndBuyGoods")):setText(goodsCostCount)
end 


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function WndBuyGoods:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtCostDesc_WndBuyGoods",WZUILabelTTF):setFontSize(16)
end

-------------------------------------语言适配模块End----------------------------------------




