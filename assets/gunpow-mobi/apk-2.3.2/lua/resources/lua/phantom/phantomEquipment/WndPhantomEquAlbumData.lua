--WndPhantomEquAlbumData.lua
--@brief	WndPhantomEquAlbum的数据模块
--@date		2021/05/11
--@author	yrd
--@note		幻化装备图鉴

WndPhantomEquAlbum = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPhantomEquAlbum:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSuitObjList = nil 			--套装对象列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPhantomEquAlbum:_unInit()
	self.m_root = nil
	self.m_tSuitObjList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantomEquAlbum:createElement()
	if WndPhantomEquAlbum.m_root ~= nil then
		WindowManager:removeWindow(WndPhantomEquAlbum.m_root, WndPhantomEquAlbum, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPhantomEquAlbum")
	assert(element, "WndPhantomEquAlbum create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndPhantomEquAlbum:showInterface()
	-- body
	local wnd = WndPhantomEquAlbum:createElement()
	if wnd then 
		WindowManager:addWindow(wnd, WndPhantomEquAlbum, nil, nil, nil, true)
	end
end

--@brief 	领取图鉴奖励成功
function WndPhantomEquAlbum:getShapeEquipRewardOk(gId, itemId, num)
	WndRewardShow:showById(itemId, num)

	local tAlbumList = WndPhantomEquipment:getAlbumList()
	for i=1,#tAlbumList do
		if tAlbumList[i].gId == gId then
			tAlbumList[i].status = 2 --已领取
		end
	end

	--刷新图鉴
	self:updateUI()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
