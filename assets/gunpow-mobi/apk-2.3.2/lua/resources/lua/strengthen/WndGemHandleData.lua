--WndGemHandleData.lua
--@brief	WndGemHandle的数据模块
--@date		2019/07/22
--@author	yrd
--@note		宝石融合

WndGemHandle = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGemHandle:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCurSelectedEquip = nil 		--当前装备信息
	self.m_tGemData = nil 				--当前装备宝石信息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGemHandle:_unInit()
	self.m_root = nil
	self.m_tCurSelectedEquip = nil 		--当前装备信息
	self.m_tGemData = nil 				--当前装备宝石信息
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGemHandle:createElement()
	local element = WZUISystem:getInstance():createElement("WndGemHandle")
	assert(element, "WndGemHandle create element failed!")
	self:_init()
	return element
end

function WndGemHandle:showInterface(tCurSelEquip, tGemData, parentNode)
	local wndGemHandle = WndGemHandle:createElement()
	parentNode:addChild(wndGemHandle)


	self.m_tCurSelectedEquip = tCurSelEquip
	self.m_tGemData = tGemData

	local magicUpInfo = GDatatab_dig_up["id_"..self.m_tGemData.id]

	if self.m_tGemData.id <= 41000 and self.m_tGemData.basicInfo.value >= 7 then --宝石融合成魔力宝石
		self:_updateFuse()
	elseif self.m_tGemData.id > 41000 and magicUpInfo.ad_up ~= -1 then --魔力宝石进阶
		self:_updateAscending()
	end
end


function WndGemHandle:getGemOperateOk(result, operateType)
	--刷新
	local tEquip
	local equipList = CacheCenter:getEquipList()
	for k,v in pairs(equipList) do
		if v.playerItemId == self.m_tCurSelectedEquip.playerItemId then
			tEquip = v
		end
	end
	self.m_tCurSelectedEquip = tEquip
	WndStrengthen:updateCellEquip(tEquip)

	if operateType == 1 then
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_5)
		else
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_6)
		end
	elseif operateType == 3 then
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_7)
			self:_showAnimal()
			return
		else
			MsgBoxManager:showTipBox(LocalStrings.GEM_MOUNTING_8)
		end
	else
		if result == true then
			MsgBoxManager:showTipBox(LocalStrings.SUCCESS)
		else
			MsgBoxManager:showTipBox(LocalStrings.FAIL)
		end
	end

	--关闭
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
