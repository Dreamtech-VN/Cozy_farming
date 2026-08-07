--WndRewardViewTipData.lua
--@brief	WndRewardViewTip的数据模块
--@date		2020/05/06
--@author	XTX
--@note		TIP类型的奖励预览界面

WndRewardViewTip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRewardViewTip:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardData = nil 
	self.m_nType = nil 					--0:深渊boss；1:世界boss
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRewardViewTip:_unInit()
	self.m_root = nil
	self.m_tRewardData = nil 
	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRewardViewTip:createElement()
	if WndRewardViewTip.m_root ~= nil then
		WindowManager:removeWindow(WndRewardViewTip.m_root, WndRewardViewTip, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRewardViewTip")
	assert(element, "WndRewardViewTip create element failed!")
	self:_init()
	return element
end

--@brief 	设置伤害榜数据
--@param 	nType : 0:深渊boss；1:世界boss
function WndRewardViewTip:showInterface(tData, nType)
	-- body
	local wndRank = WndRewardViewTip:createElement()
	if wndRank then 
		self.m_tRewardData = tData 
		self.m_nType = nType or 0
		WindowManager:addWindow(wndRank, WndRewardViewTip)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
