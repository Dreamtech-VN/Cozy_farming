--WndDoubleSevenData.lua
--@brief	WndDoubleSeven的数据模块
--@date		2020/07/30
--@author	hyx
--@note		七夕活动主界面

WndDoubleSeven = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleSeven:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil
	self.m_tConfreeMyValue = {} --告白值.我的
	self.m_tConfreeOtherValue = {}--告白值.他人
	self.m_nIsBind = 0 --0:未绑定 否则绑定
	self.m_nMyConfreeValue = 0 --自已 的告白值
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleSeven:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_tConfreeMyValue = {}
	self.m_tConfreeOtherValue = {}
	self.m_nMyConfreeValue = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleSeven:createElement()
	if WndDoubleSeven.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleSeven.m_root, WndDoubleSeven, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleSeven")
	assert(element, "WndDoubleSeven create element failed!")
	self:_init()
	return element
end
--是否存在绑定好友
function WndDoubleSeven:setBindFriend(value)
	self.m_nIsBind = value
end
function WndDoubleSeven:getBindFriend()
	return self.m_nIsBind
end
--我的告白值
function WndDoubleSeven:setMyConfreeValue( value )
	value = value or 0
	self.m_nMyConfreeValue = value
end
function WndDoubleSeven:getMyConfreeValue()
	return self.m_nMyConfreeValue
end

--告白值
function WndDoubleSeven:setConfreeValue()
	local confreeInfo = CacheCenter:getGameParam().qixiConfessConfig
	if confreeInfo then
	confreeInfo = json.decode(confreeInfo)
		--价格
		self.m_nflowerPrice = confreeInfo.flowerPrice
		local temp_value = 70
		if ProjConfig.LANGUAGE == "vn" then
			temp_value = 1
		end
		self.m_tConfreeMyValue[temp_value] = confreeInfo.flowerAddMe
		self.m_tConfreeMyValue[857] = confreeInfo.chocolateAddMe
		self.m_tConfreeMyValue[858] = confreeInfo.ringAddMe

		self.m_tConfreeOtherValue[temp_value] = confreeInfo.flowerAddOther
		self.m_tConfreeOtherValue[857] = confreeInfo.chocolateAddOther
		self.m_tConfreeOtherValue[858] = confreeInfo.ringAddOther
	end  
end
--获取告白值 70:玫瑰  857:蛋糕  858:戒指
function WndDoubleSeven:getConfreeMyValue(index)
	if self.m_tConfreeMyValue and self.m_tConfreeMyValue[index] then
		return self.m_tConfreeMyValue[index]
	end
	return 0
end
function WndDoubleSeven:getConfreeOtherValue(index)
	if self.m_tConfreeOtherValue and self.m_tConfreeOtherValue[index] then
		return self.m_tConfreeOtherValue[index]
	end
	return 0
end
function WndDoubleSeven:getFlowerPriceValue()
	return tonumber(self.m_nflowerPrice) or 0
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

