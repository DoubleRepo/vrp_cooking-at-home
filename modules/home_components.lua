-- Kitchen

local function kitchen_create(owner_id, stype, sid, cid, config, data, x, y, z, player)

  local function cook(player, ingrd, ingrd2, food, name, amount1, amount2, amountf)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
      if vRP.getInventoryItemAmount(user_id, ingrd) > 0 and vRP.getInventoryItemAmount(user_id, ingrd2) > 0 then
		vRP.tryGetInventoryItem(user_id,ingrd,amount1)
		vRP.tryGetInventoryItem(user_id,ingrd2,amount2)
		vRP.giveInventoryItem(user_id,food,amountf)
		vRPclient.playAnim(player, {true, {{"amb@prop_human_bbq@male@base","base",1}}, false})
		--TriggerClientEvent("pNotify:SendNotification",user_id,{text = "You create" ..name, type = "success", timeout = (3000),layout = "centerRight"})
		vRPclient.notify(player,{"You cooked "..name})
      else
		--TriggerClientEvent("pNotify:SendNotification",user_id,{text = "You don't  have ingredients", type = "error", timeout = (3000),layout = "centerRight"})
		vRPclient.notify(player,{"You don't have the required ingredients"})
	  end
	end
  end

  local kitchen_enter = function(player,area)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- build menu
      local menu = {name="Kitchen",css={top = "75px", header_color="rgba(0,255,125,0.75)"}}
	  menu["Scrambled eggs & bacon "] = {function(player, choice) cook(player, "egg", "bacon", "eggbac", "scrambled eggs with bacon", 1, 1, 1) end, "Ingredients: one egg and  one bacon."}
      -- open the menu
      vRP.openMenu(player,menu)
    end
  end

  local kitchen_leave = function(player,area)
    vRP.closeMenu(player)
  end

  local nid = "vRP:home:slot"..stype..sid..":kitchen"
  vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
  vRP.setArea(player,nid,x,y,z,1,1.5,kitchen_enter,kitchen_leave)
end

local function kitchen_destroy(owner_id, stype, sid, cid, config, data, x, y, z, player)
  local nid = "vRP:home:slot"..stype..sid..":kitchen"
  vRPclient.removeNamedMarker(player,{nid})
  vRP.removeArea(player,nid)
end

vRP.defHomeComponent("kitchen", kitchen_create, kitchen_destroy)
