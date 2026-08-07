--WndMarryTipsData.lua
--@brief	WndMarryTips的数据模块
--@date		2014/01/13
--@author	叶威
--@note		结婚礼堂提示框

WndMarryTips = {
	--请不要在这里定义变量
}

--@brief  窗口类型
WndMarryTips.wndType = {
    TIPS = 1,           --温馨提示类型窗口
    WEDDING_OK = 2,     --举行婚礼成功类型窗口
    WEDDING_FAILD = 3,  --举行婚礼败类型窗口
    ROB_TRUE = 4,       --成功抢到东西
    ROB_FALSE = 5,
}
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryTips:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nWindowType = 1              --窗口类型
    self.m_sText = nil                  --提示内容
    self.m_sTipImgPath = nil            --内容上面的图片文字路径
    self.m_callBackLuaObj = nil         --确定按钮回调的表对象
    self.m_callBackLuaFun = nil         --确定按钮回调的表方法	
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryTips:_unInit()
	self.m_root = nil
    self.m_nWindowType = 1
    self.m_callBackLuaObj = nil
    self.m_callBackLuaFun = nil
    self.m_sText = nil
    self.m_sTipImgPath = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryTips:createElement()
    --只能弹出一个提示框
    WindowManager:removeWindow(self.m_root, self, true)
	local element = WZUISystem:getInstance():createElement("WndMarryTips")
	assert(element, "WndMarryTips create element failed!")
	self:_init()
	return element
end

--@brief	设置确定按钮事件回调的表对象和函数
--@param	obj:表对象
--@param	fun:函数变量
--@note     可选，不设置则按钮事件仅关闭窗口
function WndMarryTips:setSureCallBackObjAndFun(obj,fun)
    WZLog("WndMarryTips:setSureCallBackObjAndFun ",obj,fun)
    self.m_callBackLuaObj = obj
    self.m_callBackLuaFun = fun
end

--@brief	设置提示框内容
--@param	wndType:窗口类型WndMarryTips.wndType，必填
--@param	txt:提示内容，可选
--@param    tipImgPath:内容上边的订婚成功类型图片文字，可选
function WndMarryTips:setTipsContent(wndType,txt,tipImgPath)
    self.m_nWindowType = wndType
    self.m_sText = txt
    self.m_sTipImgPath = tipImgPath
   
end






-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
