--[[-------------------------------------------------------------------------
--
--  Core Model
--  内核模块
--
--  功能:一些常用,可重复使用的公共函数
--
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
--  从消息获取物品ID和链接:如CHAT_MSG_LOOT:Util.lua
-------------------------------------------------------------------------]]--
function Tinom.GetItemInfoFromHyperlink(link)
	local strippedItemLink, itemID = link:match("|Hitem:((%d+).-)|h");
	if itemID then
		return tonumber(itemID), strippedItemLink;
	end
end