--WndMountsCenterData.lua
--@brief	WndMountsCenter的数据模块
--@date		2015-12-5
--@author	binshao
--@note		坐骑模块

WndMountsCenter = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMountsCenter:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMounts = nil                --当前坐骑
    self.maxUpLevel = 0                 -- 升级最大等级
    self.maxStarLevel = 0               -- 进阶最大等级
    self.flag = 1                       -- 进阶升级标志位
    self.loadingId = nil                -- loadingID
    self.isResult = nil                 -- 进阶升级的结果
    self.isClick = true                 -- 升级和进阶按键是否可点
    self.leftLv = 0                     -- 剩余升级等级
    self.logTime = 0 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMountsCenter:_unInit()
	self.m_root = nil
	self.m_tMounts = nil
    self.maxUpLevel = nil
    self.maxStarLevel = nil
    self.flag = nil
    self.loadingId = nil
    self.isResult = nil
    self.isClick = nil
    self.leftLv = 0                     -- 剩余升级等级
    self.logTime = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMountsCenter:createElement()
	WZLog("WndMountsCenter:createElement")
	local element = WZUISystem:getInstance():createElement("WndMountsCenter")
	assert(element, "WndMountsCenter create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndMountsCenter:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

function WndMountsCenter:initStarAndUpMaxLevel()
	self.maxUpLevel = tonumber(CacheCenter:getGameParam().gameMaxLevel)
    self.maxStarLevel = tonumber(CacheCenter:getGameParam().maxMountsAdvancedLevel)
    local addLv = CacheCenter:getGameParam().orangeMountLvlUpperLimitAddtion
    if self.m_tMounts.basicInfo.quality == 4 then
        self.maxUpLevel = self.maxUpLevel + addLv
    end
    WZLog("----------self.maxUpLevel----------1",addLv)
    WZLog("----------self.maxUpLevel----------2",self.m_tMounts.basicInfo.quality)
    WZLog("----------self.maxUpLevel----------3",self.maxUpLevel)
    WZLog("----------self.maxUpLevel----------4",self.m_tMounts.basicInfo.id)
end
-------------------------------------私有方法模块End----------------------------------------
