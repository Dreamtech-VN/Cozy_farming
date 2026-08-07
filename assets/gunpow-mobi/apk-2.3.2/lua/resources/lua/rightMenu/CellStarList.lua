--CellStarList.lua
--@brief	CellStarList的UI模块
--@date		2014/01/07
--@author	林庆凯
--@note		生成星星图片列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellStarList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellStarList:onExit(element)
	self:_unInit()
end



--@brief	是否设置星星当前图片的函数
--@param  #1 element 表对象引用 
--@param  #2 nWhichImg 显示那个图片
function CellStarList:setStarShowInCellStarList(element,nWhichImg)
	if element == nil then 
		WZLog("CellStarList:setStarShowInCellStarList(element,nWhichImg) element is nil ")
		return 
	end 

	local imgStar = element:getChildElement("imgStar_CellStarList")
	if imgStar ~= nil then  
		imgStar = WZUIImage:luaTo(imgStar)
		if imgStar ~= nil then 
			if nWhichImg == 1 then 		--显中
				imgStar:setFile("ui/rightMenu/exploration/star_1.png")
			elseif nWhichImg == 2 then  --没显中
				imgStar:setFile("ui/rightMenu/exploration/star_3.png")
			elseif nWhichImg == 3 then  --第二次选中
				imgStar:setFile("ui/rightMenu/exploration/star_6.png")
			end 
		end 
	end 
end 


--@brief	查看星星当前图片是否被选中的函数
--@param   element 表对象引用 
--@param  是否被选中
function CellStarList:getStarSelStatState(element)
	if element == nil then 
		WZLog("CellStarList:setStarShowInCellStarList(element,nWhichImg) element is nil ")
		return 
	end 

	local imgStar = element:getChildElement("imgStar_CellStarList")
	if imgStar ~= nil then  
		imgStar = WZUIImage:luaTo(imgStar)
		if imgStar ~= nil then 
			local sWhichImg = imgStar:getFile()
			if sWhichImg == "ui/rightMenu/exploration/star_3.png" then  --没显中
				return true
			else
				return false 
			end 
		end 
	end 
end 




--@brief	是否设置星星发光图片的函数
--@param  #1 element 表对象引用 
--@param  #2 bVisble 是否可见
function CellStarList:setStarLightVisableInCellStarList(element,bVisble)
	if element == nil then 
		WZLog("CellStarList:setStarLightVisable(element,bVisble) element  is nil ")
		return 
	end 
	local imgStarLight = element:getChildElement("imgStarLight_CellStarList")
	if imgStarLight ~= nil then 
		imgStarLight = WZUIImage:luaTo(imgStarLight)
		if imgStarLight ~= nil then 
			imgStarLight:setVisible(bVisble)
		end 
	end 
end 



--@brief	是否设置星星发光图片的函数
--@param	bVisble 是否可见
function CellStarList:setStarLightVisable(bVisble)
	if self.m_root == nil then 
		WZLog("CellStarList:setStarLightVisable() self.m_root is nil ")
		return 
	end 
	
	local imgStarLight = self.m_root:getChildElement("imgStarLight_CellStarList")
	if imgStarLight ~= nil then 
		imgStarLight = WZUIImage:luaTo(imgStarLight)
		if imgStarLight ~= nil then 
			imgStarLight:setVisible(bVisble)
		end 
	end 
end 





-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
