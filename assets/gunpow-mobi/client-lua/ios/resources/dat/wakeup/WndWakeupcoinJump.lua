--WndWakeupcoinJump.lua
--@brief	WndWakeupcoinJump的UI模块
--@date		2017/05/27
--@author	Tianxiang_Xu
--@note		觉醒之晶解析界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWakeupcoinJump:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWakeupcoinJump:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成调用
function WndWakeupcoinJump:onEnterTransitionDidFinish(element)
    -- body
    local pageCon = GetElement(self.m_root, "pgConForImg_WndWakeupcoinJump", WZUIPageContainer)
    pageCon:setMoveActionFinishCallback("onPageChanged")

    self:_loadAllPage()
end

--@brief    关闭按钮回调
function WndWakeupcoinJump:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    翻页时被调用的函数
--@param    nIndex:当前序号
function WndWakeupcoinJump:onPageChanged(nIndex)
    WZLog("WndWakeupcoinJump:onPageChanged ")
    if nIndex == nil then
        local pageCon = GetElement(self.m_root, "pgConForImg_WndWakeupcoinJump", WZUIPageContainer)
        nIndex = pageCon:getCurrentPageIndex()
    end
    if  self.m_nCurPageIndex == nIndex then
        return
    end
    
    self.m_nCurPageIndex = nIndex
    self:_resetSelDot()
end

--@brief    点击前往萃取按钮回调
function WndWakeupcoinJump:onClickGotoExtraction(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndExtraction:showInterface()
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击前往合成按钮回调
function WndWakeupcoinJump:onClickGotoCompose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndBag:showBagSynthesis(4)
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndWakeupcoinJump:_loadAllPage(element,delay)
    -- body
    if self.m_root == nil then return end

    local pageCon = GetElement(self.m_root, "pgConForImg_WndWakeupcoinJump", WZUIPageContainer)
    pageCon:setTouchEnable(true)

    self.m_tImageList = {"ui/extraction/common_pic_jxzj.png"}
    local tImgList = self.m_tImageList
    --先加载当前星魂
    local nImgNum = #tImgList
    local conForDot = GetElement(self.m_root, "conForDot_WndWakeupcoinJump", WZUIContainer)
    conForDot:removeAllChildrenWithCleanup(true)
    local nStartX = 0.5 - math.floor(nImgNum / 2) * 0.03
    for i = 1, nImgNum do
        local cellElement = WZUISystem:getInstance():createElement("CellPerPageForImage")
        cellElement:setVisible(true)
        GetElement(cellElement, "imgShow_CellPerPageForImage", WZUIImage):setFile(tImgList[i])
        pageCon:setPageElement(i - 1,cellElement)
        --分页点
        -- local imgPoint = WZUIImage:create()
        -- if i == 1 then
        --     imgPoint:setFile("ui/common/common_icon_diandian2.png")
        -- else
        --     imgPoint:setFile("ui/common/common_icon_diandian3.png")
        -- end
        -- imgPoint:setUseOriginSize(true)
        -- imgPoint:setTag(i)
        -- imgPoint:setRelativePosition(GlobalMethod:ccp(nStartX + (i - 1) * 0.03 , 0.5))
        -- conForDot:addChild(imgPoint)
    end

    self.m_nCurPageIndex = 0
    pageCon:setDefaultCenterPage(0)
end

--@brief    翻页后更新页签
function WndWakeupcoinJump:_resetSelDot()
    -- body
    local conForDot = GetElement(self.m_root, "conForDot_WndWakeupcoinJump", WZUIContainer)
    WZLog("WndWakeupcoinJump:_resetSelDot", self.m_nCurPageIndex)
    for i = 1, #self.m_tImageList do
        local element = conForDot:getChildByTag(i)
        element = WZUIImage:luaTo(element)
        if i == self.m_nCurPageIndex + 1 then
            element:setFile("ui/common/common_icon_diandian2.png")
        else
            element:setFile("ui/common/common_icon_diandian3.png")
        end
    end
end


-------------------------------------私有方法模块End----------------------------------------
