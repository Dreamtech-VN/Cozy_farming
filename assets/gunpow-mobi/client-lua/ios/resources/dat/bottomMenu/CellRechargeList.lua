--CellRechargeList.lua
--@brief	CellRechargeList的UI模块
--@date		2014/01/20
--@author	林庆凯
--@note		充值产品列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRechargeList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRechargeList:onExit(element)
	self:_unInit()
end


--@brief	退出单元格背景时被调用的函数
--@param	element:表绑定的UI节点引用
function CellRechargeList:onClickCellBtn(element)
	WZLog("CellRechargeList:onClickCellBtn(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndRecharge:onClickRecharge(self.m_root:getTag())
end 



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 更新产品价格、图片、钻石数量的函数
function CellRechargeList:_update()
	if self.m_root == nil then 
		WZLog("CellRechargeList:_update() self.m_root is nil")
		return 
	end 
	
	--产品价格
	local txtPrice = self.m_root:getChildElement("txtPrice_CellRechargeList")
	if txtPrice ~= nil and self.m_sTxtPrice ~= nil then 
		WZUILabelTTF:luaTo(txtPrice):setText(self.m_sTxtPrice)
	end 
	
	--产品图片
	self:_setImgProduct()
	
	--钻石数量
	local txtDiamondNum = self.m_root:getChildElement("txtDiamondNum_CellRechargeList")
	if txtDiamondNum ~= nil and self.m_nDiamondNum ~= nil then 
		WZUILabelTTF:luaTo(txtDiamondNum):setText(tostring(self.m_nDiamondNum))
        WZLog("CellRechargeList:_update",tostring(self.m_nDiamondNum))
	end 

	--优惠比率
    local conDiscountNum = self.m_root:getChildElement("conDiscountNum_CellRechargeList")

  --   if conDiscountNum ~= nil then
  --   	if tostring(self.m_sDisCountNum) == "0" then
		-- 	self.m_root.getChildElement("conDiscountNum_CellRechargeList"):setVisible(false)
		-- else
		-- 	local sDisCount = ":%d"
		-- 	local atlas = WZUILabelAtlasFont:create()			
		-- 	atlas:setCharMapFileName("image/common/num/payment_num.png")
		-- 	atlas:setWidth(16)			
		-- 	atlas:setHeight(21)			
		-- 	sDisCount = string.format( sDisCount , tonumber(self.m_sDisCountNum)/100)
			
		-- 	atlas:setUseOriginSize( true )	
		-- 	atlas:setScale(1.5)
		-- 	atlas:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
  --           atlas:setText(tostring(sDisCount))

  --           conDiscountNum:addChild(atlas)

  --           local imagesprite = WZUI9Image:create()
  --           imagesprite:setFile("image/common/num/payment_Percentage.png")
		-- 	imagesprite:setScale(1.5)
		-- 	imagesprite:setUseOriginSize( true )	
		-- 	imagesprite:setPosition(GlobalMethod:ccp(200,10))
		-- 	--imagesprite:setPosition(GlobalMethod:ccp(tonumber(atlas:getPosition().x+atlas:getContentSize().width/2),tonumber(atlas:getPosition().y)))
		-- 	conDiscountNum:addChild(imagesprite)
		-- end	
--   end;
	local txtDisCount =  self.m_root:getChildElement("txtDiscountNum_CellRechargeList")
	--WZLog("g=============y==============q",tostring(txtDisCount),tostring(self.m_nDisCountNum))
	if txtDisCount ~= nil then
		if tostring(self.m_sDisCountNum) == "0" then
        self.m_root:getChildElement("conDiscountNum_CellRechargeList"):setVisible(false)
		else
			local sDisCount = "+%d"
		    sDisCount = string.format( sDisCount , tonumber(self.m_sDisCountNum)/100).."%"
            WZLog("tLabelImage.desc::",sDisCount)
		    WZUILabelTTF:luaTo(txtDisCount):setText(tostring(sDisCount))
		    WZUILabelTTF:luaTo(txtDisCount):setColor(GlobalMethod:ccc3(255,215,0))
		end
	end
	--WZUILabelTTF:luaTo(txtDisCount):setVisible(false)
end 



--@brief 设置产品图片的函数
function CellRechargeList:_setImgProduct()
	if self.m_root == nil then 
		WZLog("CellRechargeList:_setImgProduct() self.m_root is nil")
		return 
	end 
	local imgProduct = self.m_root:getChildElement("imgProduct_CellRechargeList")
	if imgProduct ~= nil then 
		WZUIImage:luaTo(imgProduct):setFile(self.m_sImgProductPath)
	end 
end 






-------------------------------------私有方法模块End----------------------------------------
