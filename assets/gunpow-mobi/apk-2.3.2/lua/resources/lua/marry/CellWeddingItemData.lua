--CellWeddingItem.lua
--@brief	CellWeddingItem的数据模块
--@date		2013/4/22
--@author	LQK
--@note		结婚大厅中房间列表的单元格

CellWeddingItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWeddingItem:_init()
	self.m_root = nil  			  	  --Cell的根节点
	self.m_nWeddingId = nil       	  --结婚列表ID
	self.m_sBrigeGroomName = nil  	  --新郎名字
	self.m_sBrigeName = nil       	  --新娘名字
	self.m_nWeddingStatus = nil   	  --婚礼状态
	self.m_nWeddingMode = nil     	  --婚礼模式
	self.m_sWeddingTime = nil     	  --结婚时间
	self.m_sBrigeGroomHeadInfo = nil  --新郎头发信息
	self.m_sBrigeHeadInfo = nil       --新娘头发信息
	self.m_sBrigeGroomFaceInfo = nil  --新郎脸部信息
    self.m_sBridgeFaceInfo = nil      --新娘脸部信息	
	self.m_nDtataTableIndex = nil     --单元格在表格中的索引
	self.m_bUserPass = false
	self.m_nManServerId = nil 
	self.m_nWomanServerId = nil 
end                                

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWeddingItem:_unInit()
	self.m_root = nil
	self.m_nWeddingId = nil       	  --结婚列表ID
	self.m_sBrigeGroomName = nil  	  --新郎名字
	self.m_sBrigeName = nil       	  --新娘名字
	self.m_nWeddingStatus = nil   	  --婚礼状态
	self.m_nWeddingMode = nil     	  --婚礼模式
	self.m_sWeddingTime = nil     	  --结婚时间
	self.m_sBrigeGroomHeadInfo = nil  --新郎头发信息
    self.m_sBrigeHeadInfo = nil       --新娘头发信息
    self.m_sBrigeGroomFaceInfo = nil  --新郎脸部信息
    self.m_sBridgeFaceInfo = nil      --新娘脸部信息	
	self.m_nDtataTableIndex = nil     --单元格在表格中的索引
	self.m_bUserPass = nil
	self.m_nManServerId = nil 
	self.m_nWomanServerId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWeddingItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWeddingItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellWeddingItem")
	assert(element, "CellWeddingItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置点击回调函数
--@param	callback:回调函数引用,可置空
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于点击时外部的回调用
function CellWeddingItem:setClickCallback(callback,tLuaObj)
    self.m_lpClickCallback = callback
	self.m_tCallbackTable = tLuaObj
end



--@brief	设置结婚列表界面UI 
--@param #1  nWeddingId： 结婚列表ID
--@param #2  sBrigeGroomName：新郎名字
--@param #3  nWeddingStatus：新娘名字
--@param #4  nWeddingMode：婚礼状态
--@param #5  nWeddingMode：婚礼模式
--@param #6  sWeddingTime：结婚时间
function CellWeddingItem:setWeddingListUi(nWeddingId,sBrigeGroomName,sBrigeName,nWeddingStatus,nWeddingMode,sWeddingTime,userpass, manServerId, womanServerId, progress)
	self.m_nWeddingId = nWeddingId
	self.m_sBrigeGroomName = sBrigeGroomName
	self.m_sBrigeName = sBrigeName
	self.m_nWeddingStatus = nWeddingStatus
	self.m_nWeddingMode = nWeddingMode
	self.m_sWeddingTime = sWeddingTime
	self.m_bUserPass = userpass
	self.m_nManServerId = manServerId 
	self.m_nWomanServerId = womanServerId 
	self.m_nProgress = progress
	WZLog("self.m_nWeddingId  = ",self.m_nWeddingId )
	WZLog("self.m_sBrigeGroomName = ",self.m_sBrigeGroomName)
	WZLog("self.m_nWeddingStatus = ",self.m_nWeddingStatus)
	WZLog("self.m_nWeddingMode = ",self.m_nWeddingMode)
	WZLog("self.m_sWeddingTime = ",self.m_sWeddingTime)
	self:_update()
end 


--@brief	设置新郎新郎相关信息 
--@param #1  新郎名字 
--@param #2  新娘名字
--@param #3  婚礼时间
--@param #4  新郎头发信息
--@param #5  新娘头发信息
--@param #6  新郎脸部信息
--@param #7  新娘脸部信息	
function CellWeddingItem:setBrigeGroomAndBrigeInfo(sBrigeGroomName,sBrigeName,sWeddingTime,sBrigeGroomHeadInfo,
													sBrigeHeadInfo,sBrigeGroomFaceInfo,sBridgeFaceInfo)
	self.m_sBrigeGroomName = sBrigeGroomName
	self.m_sBrigeName = sBrigeName
	self.m_sWeddingTime = sWeddingTime
	self.m_sBrigeGroomHeadInfo = sBrigeGroomHeadInfo
	self.m_sBrigeHeadInfo = sBrigeHeadInfo
	self.m_sBrigeGroomFaceInfo = sBrigeGroomFaceInfo
	self.m_sBridgeFaceInfo = sBridgeFaceInfo
	WZLog("sBrigeGroomName = ",sBrigeGroomName)
	WZLog("sBrigeName = ",sBrigeName)
	WZLog("sWeddingTime = ",sWeddingTime)
	WZLog("sBrigeGroomHeadInfo = ",sBrigeGroomHeadInfo)
end 


--@brief 设置数据表单元格索引
--@param #1  nTableDataIndex 单元格在表格中的索引
function CellWeddingItem:setTableDataIndex(nTableDataIndex)
	self.m_nDtataTableIndex = nTableDataIndex
end 


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWeddingItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
