--CellNearbyFriendData.lua
--@brief	CellNearbyFriend的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

CellNearbyFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellNearbyFriend:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_tDown = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNearbyFriend:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 		--好友数据列表
	self.m_tBackFun = nil 		--回调列表
	self.m_tDown = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellNearbyFriend:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellNearbyFriend table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNearbyFriend")
	assert(element, "CellNearbyFriend element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获取好友列表数据
--@param	tFriend[1]:好友ID
--@param	tFriend[2]:好友性别
--@param	tFriend[3]:好友名称
--@param	tFriend[4]:好友战斗力
--@param	tFriend[5]:好友距离
--@param	tFriend[6]:好友邮件
--@param	tFriend[7]:好友在线情况(true在线，false下线)
--@param	tFriend[8]:头
--@param	tFriend[9]:脸
--@param	tFriend[10]:好友图像路径
--@param	tFriend[11]:是否是玩家的好友,true是好友，false为不是
function CellNearbyFriend:setAllData(tFriend)
	self.m_tFriend = {}
	self.m_tFriend = tFriend
	--更新函数
	self:_update()
end

--@brief	设置获得函数
--@param	tCell:表名
--@param	backFun:回调函数
--@param	mailBackFun:邮件回调函数
function CellNearbyFriend:setcallBackFun(tCell , backFun , mailBackFun)
	self.m_tBackFun = {}
	table.insert(self.m_tBackFun , tCell)
	table.insert(self.m_tBackFun , backFun)
	table.insert(self.m_tBackFun , mailBackFun)
end

function CellNearbyFriend:setDownLoadBack(lua,downBackFun)
	self.m_tDown = {}
	self.m_tDown[1] = lua 
	self.m_tDown[2] = downBackFun
end

function CellNearbyFriend:onBegainDownLoad()
	WZLog("self.m_tFriend[10]:::",self.m_tFriend[10])
	if self.m_tFriend[10] == nil or self.m_tFriend[10] == "" or string.find(self.m_tFriend[10],"/")==nil then
		self:_setPlayerPhotoVisible(false)--玩家头像不显示
		self:_setPlayerIconVisible(true)--玩家默认头像是显示
		if self.m_tDown then
			self.m_tDown[2](self.m_tDown[1],self.m_root:getTag() + 1)
		end
	else
		self:_setPlayerPhotoVisible(true)--玩家头像显示
		self:_setPlayerIconVisible(false)--玩家默认头像是不显示
		local bExist = WZFileUtil:isFileExist(self:_checkPicturePath(RolePhoto:checkFileName(self.m_tFriend[10])))
		WZLog("bExist::::",bExist)
		if bExist == true then
			local fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. RolePhoto:checkFileName(self.m_tFriend[10])
			WZLog("0::::",fileName)
			self:_setPhoto(fileName)--玩家头像
			if self.m_tDown then
				self.m_tDown[2](self.m_tDown[1],self.m_root:getTag() + 1)
			end
		else
			self:_setPlayerIconVisible(true)--玩家默认头像是显示
			self:downLoadPhoto()--下载图片
		end
	end
end
	
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellNearbyFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	好友获得函数
function CellNearbyFriend:_friendDistance(distance)
	--distance = distance/1000000
	if tonumber(distance) < 1000 then
		local nDistance = (math.floor( distance / 100 ) + 1) * 100
		return tostring(nDistance) .. "M"
	elseif tonumber(distance) == 1000 then
		return "1000M"
	elseif tonumber(distance) > 1000 then 
		local desc = string.format( "%5.2f" , tonumber(distance)/1000)
		return desc .. "KM"
	else
		return distance/100 .."KM"
	end
end

function CellNearbyFriend:_checkPicturePath(name)
	local file = "/storage/sdcard1/Android/data/com.wyd.dandandao.egame/files/"
	if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
		return file..name
	else
		return CCFileUtils:sharedFileUtils():getWritablePath() .. name
	end
end
-------------------------------------私有方法模块End----------------------------------------


