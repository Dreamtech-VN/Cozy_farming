--WndSingleSellRuneData.lua
--@brief	WndSingleSellRune的数据模块
--@date		2017/03/24
--@author	peiting_mao
--@note		单独出售符文

WndSingleSellRune = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleSellRune:_init()
	self.m_root = nil	 	  			--场景根节点
	self.item = nil					
	self.isUsed = nil		--装载的个数
	self.num = nil			--拥有的个数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleSellRune:_unInit()
	self.m_root = nil
	self.item = nil
	self.isUsed = nil
	self.num = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleSellRune:createElement()
	local element = WZUISystem:getInstance():createElement("WndSingleSellRune")
	assert(element, "WndSingleSellRune create element failed!")
	self:_init()
	return element
end

function WndSingleSellRune:onSaleStatus(status)
	WZLog("--WndSingleSellRune:onSaleStatus--",status)
	--local txtStatus = GetElement(self.m_root,"txtStatus1_WndSingleSellRune",WZUILabelTTF)
	local btnSale = GetElement(self.m_root,"btnSale_WndSingleSellRune",WZUIButton)
	if status == 0 then
		--txtStatus:setText(LocalStrings.SALE_SUCCESS)
		--btnSale:setTouchEnable(false)
		WndRewardShow:showById({59},{self.item.recycleMess[1][2]})
    	WndRewardShow:closeCallBack(self,nil, _G, pushEquipInList)
    	WindowManager:removeWindow(self.m_root,self,true)
		ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
	else
		MsgBoxManager:showTipBox(LocalStrings.RUNEBOOK18)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
