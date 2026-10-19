-- In Noita's two-row Holy Mountain shop the upper row of items is spawned
-- directly above the lower row, at identical x coordinates. If that upper
-- shelf gets destroyed (for example by the Holy Mountain collapsing) or fails
-- to spawn, the upper items drop straight down and end up lying exactly on top
-- of the lower row, where they are nearly impossible to tell apart.
--
-- Shift the upper row sideways by half an item slot so that, if it falls, its
-- items settle in the gaps of the lower row instead of landing on top of them.

local ew_original_spawn_all_shopitems = spawn_all_shopitems

if ew_original_spawn_all_shopitems ~= nil then
    function spawn_all_shopitems(x, y, ...)
        local count = tonumber(GlobalsGetValue("TEMPLE_SHOP_ITEM_COUNT", "5"))
        local second_row_offset = (132 / count) * 0.5

        -- The lower row is spawned at y and the upper row at y - 30; only the
        -- upper row is shifted.
        local original_generate_shop_item = generate_shop_item
        generate_shop_item = function(item_x, item_y, ...)
            if item_y == y - 30 then
                item_x = item_x + second_row_offset
            end
            return original_generate_shop_item(item_x, item_y, ...)
        end

        local ok, err = pcall(ew_original_spawn_all_shopitems, x, y, ...)
        generate_shop_item = original_generate_shop_item

        if not ok then
            error(err)
        end
    end
end
