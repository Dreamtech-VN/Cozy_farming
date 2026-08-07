--CellCircleOfFriendData.lua
--@brief	CellCircleOfFriend的数据模块
--@date		2020/07/02
--@author	XTX
--@note		朋友圈Cell

CellCircleOfFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCircleOfFriend:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false
	self.m_bIsStartComment = false 
	self.m_bIsExtend = false 	--是否展开
	self.m_nPhotoType = 3 	--标记是好友界面还是单独某个人的界面3:好友界面；4：WndCircleOfFriend界面
	self.m_tCommentCallBack = nil 	--评论回调
	self.m_tCellBeingComment = nil 
	self.m_nTab = 0 			--FRIENDCIRCLE_INDEX:好友圈；0：其他
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCircleOfFriend:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
	self.m_bIsStartComment = nil  
	self.m_bIsExtend = nil 
	self.m_nPhotoType = nil 
	self.m_tCommentCallBack = nil 	--评论回调
	self.m_tCellBeingComment = nil 
	self.m_nTab = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCircleOfFriend:createElement(conSize)
	local tNewObj = self:_new()
	assert(tNewObj, "CellCircleOfFriend table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellCircleOfFriend")
    element:setAbsContentSize(conSize)
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	设置数据
function CellCircleOfFriend:setData(tData)
	-- body
	self.m_tData = tData 
end

--@brief 	获取圈Id
function CellCircleOfFriend:getCircleId()
	-- body
	return self.m_tData.id
end

--@brief 	更新圈的评论和点赞数据
function CellCircleOfFriend:updateCommentData(tData)
	-- body
	self.m_tData.goodNum = tData.goodNum
	self.m_tData.goodData = tData.goodData
	self.m_tData.commentNum = tData.commentNum
	self.m_tData.commentData = tData.commentData

	self:showGoodNumAndCommentNum()
end

--@brief 	设置照片类型
function CellCircleOfFriend:setPhotoType(nType)
	-- body
	self.m_nPhotoType = nType 
end

--@brief	展示评论输入框回调
function CellCircleOfFriend:setShowCommentEditBoxCallback(tCell, func, func2)
	-- body
	self.m_tCellBeingComment = {}

	self.m_tCellBeingComment[1] = tCell
	self.m_tCellBeingComment[2] = func
	self.m_tCellBeingComment[3] = func2
end

--@brief 	设置界面类型
function CellCircleOfFriend:setInterfaceTab(nTab)
	-- body
	self.m_nTab = nTab 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCircleOfFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
