--WndPhantomEquAlbum.lua
--@brief	WndPhantomEquAlbum的UI模块
--@date		2021/05/11
--@author	yrd
--@note		幻化装备图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomEquAlbum:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomEquAlbum:onExit(element)
	self:_unInit()
end

--@brief window的点击事件
function WndPhantomEquAlbum:onTouchBegan(element,pt)

end

--@brief	加载动画
function WndPhantomEquAlbum:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief 关闭
function WndPhantomEquAlbum:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	更新界面
function WndPhantomEquAlbum:updateUI()

	local flcSuit = GetElement(self.m_root,"flcSuit_WndPhantomEquAlbum",WZUIFreeListContainer)
	flcSuit:removeAll()

	local tCollect = {}
	for i=1,GetTableLen(GDatatab_skinequip_collect) do
		tCollect[i] = {}
		tCollect[i].data = CopyTable(GDatatab_skinequip_collect["id_"..i])

		tCollect[i].status = 0
    	local tAlbumList = WndPhantomEquipment:getAlbumList() --图鉴领取状态数据列表
    	if tAlbumList then
    		for j=1,#tAlbumList do
    			if tAlbumList[j].gId == GDatatab_skinequip_collect["id_"..i].id then
    				tCollect[i].status = tAlbumList[j].status
    			end
    		end
		end
	end
	local function getSortIndexByStatus(status)
		if status == 1 then
			return 1
		elseif status == 0 then
			return 2
		elseif status == 2 then
			return 3
		end
	end
	table.sort( tCollect, function(a,b)
		local nASortIndex = getSortIndexByStatus(a.status)
		local nBSortIndex = getSortIndexByStatus(b.status)
		if nASortIndex ~= nBSortIndex then
			return nASortIndex < nBSortIndex
		else
			return a.data.id < b.data.id
		end
	end )

	self.m_tSuitObjList = {}
	for i=1,#tCollect do
		local element,tNewObj = CellPhantomEquAlbum:createElement()
		element:setTag(i-1)
		tNewObj:setData(tCollect[i])
		table.insert(self.m_tSuitObjList,tNewObj)

    	flcSuit:pushBack(WZUIContainer:luaTo(element))

		flcSuit:getMoveElement():setPositionY(flcSuit:getMinPosition().y)
	end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
