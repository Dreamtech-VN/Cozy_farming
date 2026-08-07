--TeachChatDialog.lua
--@brief	教学对话弹出框
--@date		2013/2/27
--@author	TaoYinqing
--@note		教学对话弹出框


--@brief	boss数据表
TeachChatDialog = {
	m_tNode = nil , 	--对话框所在的层
    m_sStr = nil,       --对话内容
    m_sTitle = nil,     --标题
    m_nOpecity = nil,
    m_nWidth = nil,
    m_nHeight = nil,
    m_fDelta = nil,
    m_fCurrentPass = nil,
    m_nCurrentPos = nil,
    m_uLabel = nil,
    m_bLeft = nil,
    m_fSpan = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    创建一个对话框
function TeachChatDialog:create(sTitle,sStr,nOpecity,bLeft,fSpan,fWidth,fHeight)
	local obj = {}
	setmetatable(obj,{__index = TeachChatDialog})

    WZLog("TeachChatDialog:create",sStr,nOpecity,bLeft,fSpan,fWidth,fHeight)
    obj.m_sTitle = sTitle..":" or ":"
    obj.m_sStr = sStr or ""
    obj.m_nOpecity = nOpecity or 255
    obj.m_fDelta = 0.125
    obj.m_fCurrentPass = 0
    obj.m_nCurrentPos = 1
    obj.m_bLeft = bLeft
    if obj.m_bLeft == nil then
        obj.m_bLeft = true
    end
    obj.m_fSpan = fSpan or 200
    obj.m_nWidth = fWidth or 960
    obj.m_nHeight = fHeight or 200
    obj:__initDialog()
	return obj
end

--@brief    显示所有的字符串
function TeachChatDialog:showAll()
    self.m_nCurrentPos = self:strLen(self.m_sStr)
end

--@brief    是否已经显示了所有
function TeachChatDialog:isShowAll()
    return self.m_nCurrentPos == self:strLen(self.m_sStr)
end

--@brief    获得高度
function TeachChatDialog:getHeight()
    return self.m_nHeight
end

--@brief    设置间隔时间
function TeachChatDialog:setDelta(fDelta)
    self.m_fDelta = fDelta
end

--@brief    字符串的子串
function TeachChatDialog:subStr(sStr,sPos,ePos)
	 --string.sub(sStr,sPos,ePos)
    local startPos = 1
    if sPos ~= 1 then
        local startPos = self:strASCIILen(sStr,sPos)
        local byte = string.byte(sStr,startPos)
        if BattleUtil:bitAnd(byte,0xC0) == 0x80 then
            startPos = startPos + 1
        end
    end
    local endPos = self:strASCIILen(sStr,ePos)
    return string.sub(sStr,startPos,endPos)
end


--@brief    字符串的子串 utf8
function TeachChatDialog:subUtfStr(sStr,ePos)
    --string.sub(sStr,sPos,ePos)
    local len = string.len(sStr)
    local i = 1
    local n = 0
    local hasMulti = false
    repeat
        local byte = string.byte(sStr,i)
        if BattleUtil:bitAnd(byte,0xC0) ~= 0x80 then
            if ePos <= 0 then
                i = i - 1
                break
            end
            if i < len and BattleUtil:bitAnd(string.byte(sStr,i+1),0xC0) == 0x80 then
                ePos = ePos - 2
            else
                ePos = ePos - 1
            end
        end
        i = i + 1
    until i > len
    local result = string.sub(sStr,1,i)
    return result
end


--@brief    获得字符串的utf8长度
--@param    sStr 字符串
--@return   #1,返回字符串的utf8长度
function TeachChatDialog:strLen(sStr)
	--return string.len(sStr)
    local len = string.len(sStr)
    local i = 1
    local n = 0
    repeat
        local byte = string.byte(sStr,i)
        if BattleUtil:bitAnd(byte,0xC0) ~= 0x80 then
            n = n + 1
        end
        i = i + 1
    until i > len
    return n
end
--@brief    utf8的长度到ascii长度
--@param    sStr字符串
--@param    nULen utf8长度
function TeachChatDialog:strASCIILen(sStr,nULen)
   if nULen >= string.len(sStr) then
        return string.len(sStr)
   end
    local i = 1
    repeat
        local byte = string.byte(sStr,i)
        if BattleUtil:bitAnd(byte,0xC0) ~= 0x80 then
            nULen = nULen - 1
        end
        if nULen <= 0 then
           break
        end
        i = i + 1
    until i > string.len(sStr)
    if i < string.len(sStr) then
        local byte = string.byte(sStr,i+1)
        if BattleUtil:bitAnd(byte,0xC0) == 0x80 then
            i = i + 2
        end
    end
    return i
end

--@brief    滴答
function TeachChatDialog:update(dt)
	self.m_fCurrentPass = self.m_fCurrentPass + dt
	if self.m_fCurrentPass >= self.m_fDelta then
		self.m_fCurrentPass = self.m_fCurrentPass - self.m_fDelta
		self.m_nCurrentPos = self.m_nCurrentPos + 1
	end

	if self.m_nCurrentPos > self:strLen(self.m_sStr) then
		self.m_nCurrentPos = self:strLen(self.m_sStr)
	end
    local str = self:subStr(self.m_sStr,1,self.m_nCurrentPos)
	self.m_uLabel:setString(str)
end

--@brief    获得当前的节点
--@return   ＃1,返回当前节点
function TeachChatDialog:getNode()
	return self.m_tNode
end

--@brief    获得字符串的全部长度
--@param    sStr 字符串，将非数字,英文字符的长度当2个字符来计算
--@return   #1,返回字符串的真实全部长度
function TeachChatDialog:strLenReally(sStr)	
	if sStr == nil or sStr == "" then
		return 0
	end
    local len = string.len(sStr)
    local i = 1
    local n = 0
    local hasMulti = false
	for i=1,len do
		local byte = string.byte(sStr,i)
        if BattleUtil:bitAnd(byte,0xC0) ~= 0x80 then
            hasMulti = true
            if i < len and BattleUtil:bitAnd(string.byte(sStr,i+1),0xC0) == 0x80 then
                n = n + 2
            else
                n = n + 1
            end
        end
	end
	return n 
end


-------------------------------------私有方法模块--------------------------------------
--@brief    初始话
function TeachChatDialog:__initDialog()
    WZLog("TeachChatDialog:__initDialog")

    local title = CCLabelTTF:create(self.m_sTitle,"",35)
    title:setColor(GlobalMethod:ccc3(255,255,0))
    self.m_uLabel = CCLabelTTF:create(self.m_sStr,"",28,CCSize:new(self.m_nWidth-40-self.m_fSpan,0),kCCTextAlignmentLeft)
    local maxHeight = self.m_uLabel:getContentSize().height + 40 + title:getContentSize().height
    if self.m_nHeight < maxHeight or self.m_nHeight < 10 then
        self.m_nHeight = maxHeight
    end
	self.m_tNode = CCLayerColor:create(ccc4(20,20,20,self.m_nOpecity),self.m_nWidth + 200,self.m_nHeight)	--create(const ccColor4B

    title:setAnchorPoint(GlobalMethod:ccp(0,1))
    self.m_uLabel:setAnchorPoint(GlobalMethod:ccp(0,1))
	if self.m_bLeft ~= true then
        title:setPosition(120,self.m_nHeight-20)
        self.m_uLabel:setPosition(120,self.m_nHeight-20-title:getContentSize().height)
    else
        title:setPosition(self.m_fSpan+120,self.m_nHeight-20)
        self.m_uLabel:setPosition(self.m_fSpan+120,self.m_nHeight-20-title:getContentSize().height)
    end
	self.m_tNode:addChild(self.m_uLabel)
    self.m_tNode:addChild(title)

	self.m_uLabel:setString("")
end
