--CellGoodItem.lua
--@brief	CellEquip的数据模块
--@date		2014/09/16
--@author	hugo.zheng
--@note		物品Item

CellGoodItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGoodItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tItem = nil			--数据列表
	self.m_tBackFun = nil 		--回调函数列表
	self.m_tStone = nil 		--石头列表
	self.m_nSpace = 0.18
	self.m_nId = nil			--物品id
	self.m_nFromTag = nil		--来源tag
    self.m_nType = nil		--显示物品的形式
    self.m_imgItem = nil    --物品图标
    self.m_imgBk1 = nil     --名字背景图
    self.m_imgBk2 = nil     --数量背景图
    self.m_txtName = nil    --物品名称
    self.m_txtCount = nil   --物品数量
    self.m_imgRecommended = nil  --推荐图标
    self.m_imgOutTime = nil --物品国旗
    self.m_imgWear = nil    --是否已经装备
    self.m_labelLevel = nil --等级
	self.m_nTag = nil
    
    self.m_seletedImg = nil --显示选中
    self.m_imgTuijian = nil --物品促销等信息
    self.m_imgStart = nil   --显示星级
    self.m_conStone = nil   --钻石容器
    self.m_hightLight = nil --高亮
    self.m_stats = nil   --宠物状态
    self.m_lock = nil       --锁
    self.m_animation = nil  --格子动画
    self.m_spriteStone = nil --钻石动画
    self.m_spriteUpgrade = nil --钻石动画
    self.m_kapaiLevel = nil --卡牌等级
    self.m_imgCornerIcon = nil --时装有效期角标
    
    self.m_imgChipMask = nil    --蒙版图片

	self.m_aniStar = nil		--升星动画
	self.m_aniSuit = nil		--套装动画
	self.m_aniStone1 = nil		--镶嵌动画
	self.m_aniStone2 = nil		--镶嵌动画
	self.m_aniStone3 = nil		--镶嵌动画
	self.m_aniStone4 = nil		--镶嵌动画
	self.m_nNeedCount = nil
	self.m_sGoodCallFunc = nil
	self.m_lv = nil 			--宝石等级
	self.m_num = nil 			--宝石数量

	self.m_lock2 = nil 			--锁图标
	self.onTouch = false
	self.m_sTouchSelect = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGoodItem:_unInit()
	self.m_root = nil
	self.m_tItem = nil			--数据列表
	self.m_tBackFun = nil 		--回调函数列表
	self.m_tStone = nil 		--石头列表
	self.m_nSpace = nil
	self.m_nId = nil				--物品id
	self.m_nFromTag = nil		--来源tag
    self.m_nType = nil
    self.m_imgItem = nil    --物品图标
    self.m_imgBk1 = nil     --名字背景图
    self.m_imgBk2 = nil     --数量背景图
    self.m_txtName = nil    --物品名称
    self.m_txtCount = nil   --物品数量
    self.m_imgRecommended = nil  --推荐图标
    self.m_imgOutTime = nil --物品国旗
    self.m_imgWear = nil    --是否已经装备
    self.m_labelLevel = nil --等级
	self.m_nTag = nil

    self.m_stats = nil
    self.m_seletedImg = nil --显示选中
    self.m_imgTuijian = nil --物品促销等信息
    self.m_imgStart = nil   --显示星级
    self.m_conStone = nil   --钻石容器
    self.m_hightLight = nil
    self.m_lock = nil
    self.m_animation = nil
    self.m_kapaiLevel = nil
    self.m_imgCornerIcon = nil --时装有效期角标
    
    self.m_imgChipMask = nil   --蒙版图片

	self.m_aniStar = nil		--升星动画
	self.m_aniSuit = nil		--套装动画
	self.m_aniStone1 = nil		--镶嵌动画
	self.m_aniStone2 = nil		--镶嵌动画
	self.m_aniStone3 = nil		--镶嵌动画
	self.m_aniStone4 = nil		--镶嵌动画
	self.m_nNeedCount = nil
	self.m_sGoodCallFunc = nil
	self.m_lv = nil
	self.m_num = nil
	
	self.m_lock2 = nil 			--锁图标
	self.onTouch = nil
	self.m_sTouchSelect = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGoodItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGoodItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellGoodItem")
	assert(element, "CellGoodItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	物品项是否为空
--@return	#1:物品项是否为空（true表示物品项为空，没有物品。false表示有物品）
--@note		判断物品项是否有物品
function CellGoodItem:isItemNil()
	if self.m_imgItem ~= nil then
		return false
	end
	return true	
end

--@brief	获取数据列表
--@param tData:传入Item的数据
--@param nType:格子类型,
--@nType=1:显示等级、钻石、星级
--@nType=2:是否已装备、推荐、过期、数量、天数
--@nType=3:数量、天数、高亮效果
--@nType=4:名字、数量、天数
--@nType=5: 商品格子
--@nType=6:卡是否已装备、高亮动画、选中效果、上锁效果
--@nType=7:卡是否已装备、选中效果
--@nType=8:商城列表
--@nType=9:兑换商品列表
--@nType=10:碎片，显示碎片蒙版、数量、图标、品质
--@nType=13:时装格子,显示方形底图
--@nType=14:时装格子,显示时装专用底图
--@nType=15:只有图片没有边框
--@nType=16:和4一样，只是时装加个有效期的角标
--@nType=17:和4一样，只是时装和武器都加个有效期的角标
--@nType=18:衣橱时装格子
--@nType=19:圣光系统格子
--@nType=30:回收格子，带长按弹tips功能
--@nType=31:和17一样，带长按弹tips功能
--@nType=32:nType=1基础上，带长按弹tips功能，暂时用于WndSell回收-坐骑灵石
--@nType=33:nType=2基础上，带长按弹tips功能，暂时用于WndSell回收-灵石之源
function CellGoodItem:setCellGoodItem(tData,nType)
    self.m_tItem = {}
	self.m_tItem = tData
    self.m_nType = nType
	self:_setStoneData(tData)
	self:_update()
end

--@brief 设置一个本地配置的物品ID,去初始化改物品框
--@param nShowType:对应setCellGoodItem中的nType值
function CellGoodItem:setCellGoodLocalId(localGoodsId, number, nShowType, isZero, playerItemId)
	local sKey = string.format("id_%s", localGoodsId)
	local mData = GDatatab_item[sKey]
	if nil == mData then
		return
	end
	local t = {}
	t.basicInfo = mData
	t.lastNum = tonumber(number)
	t.lastTime = tonumber(number)
	t.isZero = isZero
	t.playerItemId = playerItemId
	self:setCellGoodItem(t, nShowType)
end

--@brief	item点击回调
--@param tCell:父节点
--@param backFun：回调函数
function CellGoodItem:setItemClickFun(tCell,backFun)
	if tCell and backFun then
		self.m_tBackFun = {}  --回调函数列表
		table.insert(self.m_tBackFun,tCell)
		table.insert(self.m_tBackFun,backFun)
	end
end

--@brief	设置物品Id
function CellGoodItem:setItemId(id)
	self.m_nId = id
end

--@brief	获取物品Id
function CellGoodItem:getItemId()
	return self.m_nId
end

--@brief	设置来源的Tag
function CellGoodItem:setFromTag(tag)
	self.m_nFromTag = tag
end

--@brief	获取来源的Tag
function CellGoodItem:getFromTag()
	return self.m_nFromTag
end

--@brief	设置使用状态
function CellGoodItem:setUseData(bUse)
	self.m_tItem.isUse = bUse
end

--@brief	获取数据表
--@return   格子数据表
function CellGoodItem:getData()
    return self.m_tItem
end

function CellGoodItem:setTag(tag)
	self.m_nTag = tag
end

function CellGoodItem:getTag()
	return self.m_nTag
end

--@brief 	更新数据
function CellGoodItem:updateChooseStateData(status)
	self.m_tItem.chooseState = status
end

--@brief 	设置宠物装备物品tips是否显示随机属性查看按钮
function CellGoodItem:setRandomBtnVisible(bVisible)
	if self.m_tItem and bVisible ~= nil then
		self.m_tItem.randomBtnVisible = bVisible
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGoodItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	宝石列表
function CellGoodItem:_setStoneData(tItemData)
	if tItemData == nil then
		return
	end
	self.m_tStone = {}
    local tData = tItemData.extraInfo
    
    if tData ~= nil then
        if tData.attackStone and tData.attackStone > 0 then--攻击宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.attackStone])
        end
        if tData.defendStone and tData.defendStone > 0 then--防御宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.defendStone])
        end
        if tData.hpStone and tData.hpStone > 0 then--生命宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.hpStone])
        end
        if tData.gongmingStone and tData.gongmingStone > 0 then--共鸣宝石等级
            table.insert(self.m_tStone,GDatatab_item["id_"..tData.gongmingStone])
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
