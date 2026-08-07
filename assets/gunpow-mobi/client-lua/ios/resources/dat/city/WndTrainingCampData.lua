--WndTrainingCamp.lua
--@brief    WndTrainingCamp的UI模块
--@date     2017/2/10
--@author   莫剑峰
--@note     训练营

WndTrainingCamp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTrainingCamp:_init()
	self.m_root = nil	 	  			--场景根节点
    self.index = nil
    self.indexFirst = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTrainingCamp:_unInit()
	self.m_root = nil
    self.index = nil
    self.indexFirst = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTrainingCamp:createElement()
	local element = WZUISystem:getInstance():createElement("WndTrainingCamp")
	assert(element, "WndTrainingCamp create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndTrainingCamp:showInterface(index)
    -- body
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end

    local wndChallenge = WndTrainingCamp:createElement()
    WndTrainingCamp.indexFirst = index
    if wndChallenge then
        WindowManager:addWindow(wndChallenge, WndTrainingCamp,nil,nil,nil)
    end
end

-------------------------------------私有方法模块Begin--------------------------------------


function WndTrainingCamp:setRebateList(ids)
    self.m_tRebateList = {}
    self.m_tRebateList[1] = {}
    self.m_tRebateList[2] = {}
    self.m_tRebateList[3] = {}
    self.m_tRebateList[4] = {}
    for i,v in pairs(GDatatab_train_map) do
        local info = {
            id = v.id,
            name = v.map_name,
            reward = v.fixed_reward,
            state = 0,
            open = v.parent_id,
            difficulty = v.map_num,
            level = v.level,

        }
        for j,w in pairs(ids) do
            if w == info.id then
                info.state = 1
            end
            if info.open ~= -1 and w == info.open then
                info.open = -1
            end
        end
        self.m_tRebateList[v.section][v.map_num] = info
    end


    -- id = {1,2,3}
    -- name = {"累计充值200钻石", "累计充值320钻石", "累计充值640钻石"}
    -- reward = {"[165,10]&[110,5]&[165,10]", "[102,1]&[108,20]&[2,200000]", "[102,10]&[108,200]&[2,200000]"}
    -- state = {1,2,1}
    -- complete = {100,100,250}
    -- total = {100,100,300}

    -- self.m_tRebateList0 = {}
    -- for i = 1, #name do
    --     local info = {
    --         id = id[i],
    --         name = name[i],
    --         reward = reward[i],
    --         state = state[i], -- 未完成,可领取,已领取
    --         complete = complete,
    --         total = total[i],
    --     }
    --     table.insert(self.m_tRebateList0,info)
    -- end
    -- local function sort(v1,v2)
    --     return v1.id < v2.id
    -- end
    -- table.sort(self.m_tRebateList0, sort)
    WZLog("WndTrainingCamp:setRebateList", Serialize(self.m_tRebateList))
end



-------------------------------------私有方法模块End----------------------------------------
