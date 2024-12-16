-- TODO: rewrite in Golang as server plugin for /api/v2/stores
function collect_enrichments(resp)
	local response_body = resp:data()

	local stores = {}

	local deliveries = response_body:get("deliveries")
	for i = 0, deliveries:len() - 1 do
		local store = deliveries:get(i)
		local store_id = store:get("id")
		stores[store_id] = store
	end
	print("Remove deliveries")
	response_body:del("deliveries")

	local extra_fields = response_body:get("extra_fields")
	for i = 0, extra_fields:len() - 1 do
		local store = extra_fields:get(i)
		local store_id = store:get("id")
		if stores[store_id] == nil then
			stores[store_id] = store
		else
			stores[store_id]:set("enrich_field", store:get("enrich_field"))
		end
	end
	print("Remove extra_fields")
	response_body:del("extra_fields")

	response_body:set("stores", stores)
end
