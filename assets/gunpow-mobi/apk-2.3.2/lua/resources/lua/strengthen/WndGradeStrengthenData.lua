--WndGradeStrengthenData.lua
--@brief	WndGradeStrengthen的数据模块
--@date		2017/05/16
--@author	zsq
--@note		调品

WndGradeStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGradeStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bRunning = nil
	self.m_bUpdateLucky = nil
	self.original = nil
	self.first = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGradeStrengthen:_unInit()
	self.m_root = nil
	self.m_bRunning = nil
	self.m_bUpdateLucky = nil
	self.original = nil
	self.first = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGradeStrengthen:createElement()
	if WndGradeStrengthen.m_root ~= nil then
		WindowManager:removeWindow(WndGradeStrengthen.m_root, WndGradeStrengthen, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGradeStrengthen")
	assert(element, "WndGradeStrengthen create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndGradeStrengthen:updatePlayerItemNum()
		--拥有图纸数量
		if self.m_tEquipBefore ~= nil then
			local blueprintID = blueprintIDList[self.m_tEquipBefore.basicInfo.sub_type+1]
			GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
			self.m_nOwnM = CacheCenter:getPlayerItemCountById(blueprintID)
		end
		self:updateMNum()
end

--@brief	获取当前装备品质信息
function WndGradeStrengthen:getEquiGradeInfo()
	local equiGradeInfo
	local items = CacheCenter:getPlayerItems()
	local tEquip
	if self.m_tEquipBefore then
		for i=1,#items do
			if items[i].playerItemId == self.m_tEquipBefore.playerItemId then
				tEquip = items[i]
				break
			end
		end
	end
	if tEquip == nil or tEquip.extraInfo.orangeEquiGrade == nil or tEquip.extraInfo.orangeEquiGrade == "" then
		equiGradeInfo = GDatatab_item_orange_equi_grade["id_1"]
	else
		local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade, "|")
		equiGradeInfo = GDatatab_item_orange_equi_grade["id_"..grade[1]]
	end
	return equiGradeInfo
end

--@brief	获取最大品质
function WndGradeStrengthen:getMaxGrade()
	local nMaxGrade
	for k,v in pairs(GDatatab_item_orange_equi_grade) do
		if nMaxGrade == nil then
			nMaxGrade = v.id
		else
			if nMaxGrade < v.id then
				nMaxGrade = v.id
			end
		end
	end
	return nMaxGrade
end


-------------------------------------私有方法模块End----------------------------------------
