--WndStrengthenData.lua
--@brief	WndStrengthen的数据模块
--@date		2014/8/15
--@author	zsq
--@note		强化研究院窗口

WndStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = 1                --当前界面标签（1-4：强化、升星、镶嵌、转移）
	self.m_tIntensifyLuaObj	= nil		--强化窗口lua表对象
	self.m_tIntensifyElement = nil		--强化窗口控件节点引用
	self.m_tImproveLuaObj	= nil		--升星窗口lua表对象
	self.m_tImproveElement = nil		--升星窗口控件节点引用
	self.m_tGemMountingLuaObj	= nil	--镶嵌窗口lua表对象
	self.m_tGemMountingElement = nil	--镶嵌窗口控件节点引用
	self.m_tTransferLuaObj	= nil		--转移窗口lua表对象
	self.m_tTransferElement = nil		--转移窗口控件节点引用
    self.m_tSophisticLuaObj  = nil      --洗练窗口lua表对象
    self.m_tSophisticElement = nil      --洗练窗口控件节点引用
	self.m_tBackFun = nil 
	self.m_bStrengThen = nil 
	self.m_bFistLoad = true
	self.m_nSaveRightIndex = nil		--记录切换到洗练前右侧标签索引

    self.m_weaponElement = nil  --武器
    self.m_weaponLuaObj  = nil
    self.m_equipClassifyIndex = 1       --装备栏分类标签(1-7:身上->手镯)
    self.m_tCurSelectedEquip = nil      --当前选择的装备

    self.m_tCurSelectedEquip2 = nil     --转移界面第二件装备
    self.m_nEquipTag = nil              --保存添加设备是的tag参数
    self.m_nCurLoadEquipIndex = nil     --加载装备索引
    self.m_tEquipList = nil             --当前标签设备列表
    self.m_nConListPositionY = nil      --装备列表当前Y坐标
    self.m_bDontResetListY = nil        --是否重置列表Y坐标
    self.m_bReloadEquipList = true      --需重新加载装备列表

    self.m_tTitleBtn = {}				--左边标题按钮数据
    self.m_nCurUIId = 26 				--本界面对应功能开放表的id
    self.m_nMainIndex = 1
    self.m_nSubIndex = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndStrengthen:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tIntensifyLuaObj	= nil
	self.m_tIntensifyElement = nil
	self.m_tImproveLuaObj	= nil
	self.m_tImproveElement = nil
	self.m_tGemMountingLuaObj	= nil
	self.m_tGemMountingElement = nil
	self.m_tTransferLuaObj	= nil
	self.m_tTransferElement = nil
    self.m_tSophisticLuaObj  = nil       --洗练窗口lua表对象
    self.m_tSophisticElement = nil       --洗练窗口控件节点引用
	self.m_tBackFun = nil 
	self.m_bStrengThen = nil 
	self.m_nSaveRightIndex = nil		--记录切换到洗练前右侧标签索引

	self.timeonEnterEnd = nil
	self.timeEnd = nil
	self.m_bFistLoad = nil
	self.level = nil
	self.m_tBtn = nil
    self.m_weaponElement = nil  --武器
    self.m_weaponLuaObj  = nil
    self.m_equipClassifyIndex = nil
    self.m_tCurSelectedEquip = nil

    self.m_tCurSelectedEquip2 = nil

    self.m_nOpenLayerIndex = nil
    self.m_tOpenLayerEquip = nil
    self.m_nEquipTag = nil              --保存添加设备是的tag参数
    self.m_nCurLoadEquipIndex = nil     --加载装备索引
    self.m_tEquipList = nil             --当前标签设备列表
    self.m_nConListPositionY = nil      --装备列表当前Y坐标
    self.m_bDontResetListY = nil        --是否重置列表Y坐标
    self.m_bReloadEquipList = nil      --需重新加载装备列表

    self.m_tTitleBtn = nil
    self.m_nCurUIId = nil
    self.m_nMainIndex = nil
    self.m_nSubIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndStrengthen")
	assert(element, "WndStrengthen create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

--@brief	设置是否强化，或升星等等
function WndStrengthen:setHasStringthen(bStringthen)
	self.m_bStrengThen = bStringthen
end

--@brief	创建加载(不强制)
function WndStrengthen:_createLoadeing()
	self.m_root:removeChildByTag(-10,true)
	local con = WZUIContainer:create()
	con:setTag(-10)
	WndLoadingBox:createLoading(con,999999)
	self.m_root:addChild(con)
end

--@brief	关闭加载
function WndStrengthen:_closeLoading()
	self.m_root:removeChildByTag(-10,true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------



