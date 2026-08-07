--WndMarryWeddingAskData.lua
--@brief	WndMarryWeddingAsk的数据模块
--@date		2014/01/17
--@author	叶威
--@note		请求举行婚礼的窗口

WndMarryWeddingAsk = {
	--请不要在这里定义变量
}

--@brief  窗口类型
WndMarryWeddingAsk.wndType = {
    SEND = 1,        --请求婚礼
    RECIEVE = 2,     --收到婚礼请求
    INVITE = 3 ,     --收到婚礼邀请
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryWeddingAsk:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_sTitleImgPath = nil          --标题图片文字路径
    self.m_sText = nil                  --文字内容
	self.m_sFrontImgPath = nil			--前景图路径
	self.m_nWndType = 1					--窗口类型
	self.m_nCoupleId = 0                --伴侣id
	self.m_nWeddingType = 0             --当前婚礼类型，定义参看WndMarryManager
	self.m_nTimeId = nil
	self.m_nMarryRecordId = nil
	self.m_callBackLuaObj = nil
    self.m_callBackLuaFun = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryWeddingAsk:_unInit()
	self.m_root = nil
    self.m_sTitleImgPath = nil
    self.m_sText = nil
    self.m_nMarryRecordId = nil
	self.m_nTimeId = nil
	self.m_nCoupleId = 0                --伴侣id
	self.m_callBackLuaObj = nil
    self.m_callBackLuaFun = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryWeddingAsk:createElement()
	local element = WZUISystem:getInstance():createElement("WndMarryWeddingAsk")
	assert(element, "WndMarryWeddingAsk create element failed!")
	self:_init()
	return element
end

--@brief   设置内容和标题图片路径
--@param   wndType:窗口类型
--@param   txt:内容
--@param   titleImgPath:标题图片路径
--@param   frontImgPath:前景图片路径
function WndMarryWeddingAsk:setTextAndTitleImgPath(wndType,txt,titleImgPath,frontImgPath)
	self.m_nWndType = wndType
    self.m_sText = txt
    self.m_sTitleImgPath = titleImgPath
	self.m_sFrontImgPath = frontImgPath
	if self.m_root == nil then
		return
	end
	self:_update()
end

--@brief   设置婚礼类型
--@param   nType:类型
function WndMarryWeddingAsk:setWeddingType(nType)
	self.m_nWeddingType = nType
end

--@brief	设置确定按钮事件回调的表对象和函数
--@param	obj:表对象
--@param	fun:函数变量
--@note     可选，不设置则按钮事件仅关闭窗口
function WndMarryWeddingAsk:setSureCallBackObjAndFun(obj,fun)
    WZLog("WndMarryWeddingAsk:setSureCallBackObjAndFun ",obj,fun)
    self.m_callBackLuaObj = obj
    self.m_callBackLuaFun = fun
end

--@brief   设置婚礼举办时间
--@param   nTimeId:时间ID
function WndMarryWeddingAsk:setWeddinTime(nTimeId)
	WZLog("WndMarryWeddingAsk:setWeddinTime(nTimeId)")
	self.m_nTimeId = nTimeId
	WZLog("self.m_nTimeId = ",self.m_nTimeId )
end 

--@brief   设置伴侣id
--@param   id:伴侣id
function WndMarryWeddingAsk:setCoupleId(id)
    self.m_nCoupleId = id
end

--@brief   设置伴侣id
--@param   id:伴侣id
function WndMarryWeddingAsk:setMarryRecordId(id)
    self.m_nMarryRecordId  = id
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
