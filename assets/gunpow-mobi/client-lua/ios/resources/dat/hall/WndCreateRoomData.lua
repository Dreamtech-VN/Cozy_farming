--WndCreateRoomData.lua
--@brief	WndCreateRoom的数据模块
--@date		2015-6-10
--@author	binshao
--@note		创建竞技场房间

WndCreateRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCreateRoom:_init()
	self.m_root = nil	 	  			--场景根节点
    self.gameModeTag = 1                -- 游戏模式tag 1竞技 2复活
    self.fightModeTag = 1               -- 战斗模式tag 1随机（匹配） 2组队（自由） 3混战
    self.personNumTag = 1               -- 房间人数tag 1 1v1 2 2v2 3 3v3
    self.callBack = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCreateRoom:_unInit()
	self.m_root = nil
    self.gameModeTag = nil
    self.fightModeTag = nil
    self.personNumTag = nil
    self.callBack = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCreateRoom:createElement()
	local element = WZUISystem:getInstance():createElement("WndCreateRoom")
	assert(element, "WndCreateRoom create element failed!")
	self:_init()
	return element
end

--@brief	设置完成回调函数
--@para		callback:回调函数的引用
--@param	tLuaObj:回调函数所属表对象
--@note		主要用于外部回调之用
function WndCreateRoom:setEnterRoomCallBack(tLuaObj,callback)
    if not self.callBack then self.callBack = {} end
    self.callBack[1] = tLuaObj
    self.callBack[2] = callback
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------