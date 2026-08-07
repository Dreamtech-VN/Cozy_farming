--SceneCreateActorData.lua
--@brief	SceneCreateActor的数据模块
--@date		2015-8-14
--@author	binshao
--@note		角色创建界面

SceneCreateActor = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCreateActor:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_actorName = nil				--角色名称
	self.m_nLoadingID = nil				--加载框ID
    self.btnTime = 0
    self.btnClick = true
    self.actionInfo = {}

    self.randomTime = 0         -- 名字随机按键频率控制
    self.checkTime = 0          -- 性别点击频率控制
    self.aniMissTime = 0        -- 动画消失的时间,人物消失后再发送进入游戏消息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCreateActor:_unInit()
	self.m_root = nil
	self.m_actorName = nil				
	self.m_nLoadingID = nil
    --self.defaultSex = nil       -- 创建账号时默认登陆性别
    self.btnTime = nil
    self.btnClick = nil
    self.actionInfo = nil
    self.randomTime = 0         -- 名字随机按键频率控制
    self.checkTime = 0
    self.aniMissTime = 0      -- 动画消失的时间
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCreateActor:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCreateActor")
	assert(element, "SceneCreateActor create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
