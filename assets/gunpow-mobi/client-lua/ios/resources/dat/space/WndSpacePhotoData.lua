--WndSpacePhotoData.lua
--@brief	WndSpacePhoto的数据模块
--@date		2016/01/06
--@author	zsq
--@note		个人照片墙

WndSpacePhoto = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpacePhoto:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_nPhotoIndex = nil
	self.m_nUploadType = nil			--上传照片类型0:拍照上传,1:本地上传
	self.m_tUploadCell = nil			--上传照片的cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpacePhoto:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nPhotoIndex = nil
	self.m_nUploadType = nil			--上传照片类型0:拍照上传,1:本地上传
	self.m_tUploadCell = nil			--上传照片的cell
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpacePhoto:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpacePhoto")
	assert(element, "WndSpacePhoto create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存照片数据
function WndSpacePhoto:setData(photoUrl, photoStatus)
	self.m_tData = {}
	self.m_tData.photoUrl = VectorToTable(photoUrl)
	self.m_tData.photoStatus = VectorToTable(photoStatus)

	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
