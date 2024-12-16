function collect_store_ids(resp)
	local response_body = resp:data()

	-- becase of mapping stores => search
	local stores = response_body:get("search")
	local store_ids = {}

	for i = 0, stores:len() - 1 do
		local store = stores:get(i)
		table.insert(store_ids, store:get("id"))
	end

	value = table.concat(store_ids, ",")
	print("Collect store_ids finished: " .. value)

	response_body:set("store_ids", value)
end
