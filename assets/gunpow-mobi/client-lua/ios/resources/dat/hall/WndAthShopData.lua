--WndAthShopData.lua
--@brief	WndAthShop的数据模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Wnd

WndAthShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthShop:_init()
	self.m_root = nil	 	    -- 场景根节点
    self.tData = {}
    self.cell = {}
    self.vipLimit = nil
    self.curSelData = nil           -- 当前选中的cell
    self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthShop:_unInit()
	self.m_root = nil
    self.tData = nil
    self.cell = nil
    self.vipLimit = nil
    self.curSelData = nil
    self.loadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthShop:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthShop")
	assert(element, "WndAthShop create element failed!")
	self:_init()
	WZLog("---------------create----WndAthShop------------------------------------")
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndAthShop:_setCell(tag,cell,tcell)
    if not self.cell[tag] then self.cell[tag] = {} end
    self.cell[tag].cell = cell
    self.cell[tag].tcell = tcell
end

function WndAthShop:_findIndexById(id)
    for i = 1, #self.tData.prop do
        if self.tData.prop[i].storeId == id then
            return i
        end
    end
end

-- 初始化VIP限购
function WndAthShop:_initVipLimit()
    self.vipLimit = {}
    for k,v in pairs(GDatatab_vip_restriction) do
        if v.type == 3 then
            table.insert(self.vipLimit,v)
        end
    end

    local function sort(v1,v2)
        return v1.count > v2.count
    end

    table.sort(self.vipLimit,sort)
end

-- 获取当前刷新消耗
function WndAthShop:_getCost()
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount = self.tData.refreshCount + 1

    -- 先判断刷新次数是否达到当前最大值
    for i = 1, #self.vipLimit do
        if self.vipLimit[i].vip_level == curLv then
            if nextCount > self.vipLimit[i].count then
                return false,false
            else
                break
            end
        end
    end

    -- 寻找当前次数需要的消耗
    for i = 1, #self.vipLimit do
        if self.vipLimit[i].count == nextCount then
            return self.vipLimit[i].cost[1][1],self.vipLimit[i].cost[1][2]
        end
    end
end

function WndAthShop:setCurSelCellData(data)
    self.curSelData = data
end
-------------------------------------私有方法模块End----------------------------------------