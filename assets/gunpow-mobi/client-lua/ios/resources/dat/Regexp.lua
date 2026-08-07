--Regexp.lua
--@brief    基本校验方法定义
--@date     2013/12/18
--@author   叶威
--@note     基本的一些正则表达式的校验方法

Regexp = {}

--@brief    校验字符串是否为手机号码
--@param    str:被校验的字符串
--@note     仅校验第一位数字是1，且长度为11
function Regexp:isPhoneNumber(str)
    if string.find(str, "1%d%d%d%d%d%d%d%d%d%d") ~= nil and string.len(str) == 11 then
        return true
    end
    return false
end

--@brief    校验字符串是否为邮件地址
--@param    str:被校验的字符串
function Regexp:isEmailAddress(str)
    if string.find(str,".+@.+%..+") ~= nil then
        return true
    end
    return false
end

--@brief    校验字符串是否全部为数字
--@param    str:被校验的字符串
function Regexp:isNumbers(str)
    if string.find(str,"^%d+$") ~= nil and string.len(str) > 0 then
        return true
    end
    return false
end

--@brief    校验字符串是否全部为字母
--@param    str:被校验的字符串
function Regexp:isLetters(str)
    if string.find(str,"^%a+$") ~= nil and string.len(str) > 0 then
        return true
    end
    return false
end

--@brief    校验字符串是否为字母和数字的组合
--@param    str:被校验的字符串
function Regexp:isLettersAndNumbers(str)
    if string.find(str,"^%w+$") ~= nil and string.len(str) > 0 then
        return true
    end
    return false
end

--@brief    校验字符串是否为合法用户名
--@param    str:被校验的字符串
--@note     用户名可含有字母，数字，下划线
function Regexp:isAccountChar(str)
    if string.find(str,"^[0-9a-zA-Z_]+$") ~= nil and string.len(str) > 0 then
        return true
    end
    return false
end

--@brief    校验字符串是否含有空白字符
--@param    str:被校验的字符串
function Regexp:isHasBlankChar(str)
    if string.find(str,"%s") ~= nil then
        return true
    end
    return false
end

--@brief    校验字符串是否含有控制字符
--@param    str:被校验的字符串
function Regexp:isHasControlChar(str)
    if string.find(str,"%c") ~= nil then --安卓下中文匹配控制字符有问题，暂时屏蔽掉，待以后解决
        return true
    end
    return false
end

--@brief    校验字符串是否含有标点符号
--@param    str:被校验的字符串
function Regexp:isHasPunctuation(str)
    if string.find(str,"%p") ~= nil then
        return true
    end
    return false
end

--@brief    获取字符串的第N个字符
--@param    str:被校验的字符串
--@param    tag:第N个字符
function Regexp:getStrByIndex(str,tag)
	if str == nil or str == ""  then
		return str
	end
	tag = tag or 1
	local strLen = string.len(str)
	return string.sub(str,tag,tag-strLen-1)
end

--@brief    校验第一个字符是空白字符串或全部字符串都是空白字符串
--@param    str:被校验的字符串
function Regexp:isAllBlankChar(str)
	if str == nil or str == "" then
		return str 
	end
	local desc = str --检查全部字符串是否是空白键
	if string.find(desc,"%s") == nil then
		return false
	else
		desc = desc:gsub(" ","")
		if string.find(desc,"%s") == nil and desc ~= "" then
			return false
		else
			return true
		end
	end
end


