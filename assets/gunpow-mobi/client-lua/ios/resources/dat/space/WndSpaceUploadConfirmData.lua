--WndSpaceUploadConfirmData.lua
--@brief	WndSpaceUploadConfirm的数据模块
--@date		2016/01/06
--@author	zsq
--@note		个人上传照片确认

WndSpaceUploadConfirm = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceUploadConfirm:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sPhotoName = nil
	self.m_nLoadingCircleId = nil       --加载圆圈的ID
	self.m_bUploading = nil
	self.m_bUploadOutTime = nil			--是否上传超时
	self.m_nUploadTime = nil
	self.m_nType = nil 					--1->空间照片上传；2->个人信息头像上传
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceUploadConfirm:_unInit()
	self.m_root = nil
	self.m_sPhotoName = nil
	self.m_nLoadingCircleId = nil       	  --加载圆圈的ID
	self.m_bUploading = nil
	self.m_nUploadTime = nil
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceUploadConfirm:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpaceUploadConfirm")
	assert(element, "WndSpaceUploadConfirm create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	nType : 1->空间照片上传；2->个人信息头像上传
function WndSpaceUploadConfirm:showInterface(nType)
	-- body
	local wnd = WndSpaceUploadConfirm:createElement()
	if wnd then
		self.m_nType = nType or 1
		WindowManager:addWindow(wnd, WndSpaceUploadConfirm, true, nil, nil, true)
	end

	return wnd
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
