local queries = cmsgpack.unpack(ARGV[1])
local ids = cmsgpack.unpack(ARGV[2])
local model_name = cmsgpack.unpack(ARGV[3])

local function remove_indices(model_key, id)
    local memo = model_key  .. ":_indices"
    local existing = redis.call("SMEMBERS", memo)

    for _, key in ipairs(existing) do
        redis.call("SREM", key, id)
        redis.call("SREM", memo, key)
    end
end

local function delete(model_key, model_name, id)
    local keys = {
        model_key .. ":counters",
        model_key .. ":_indices",
        model_key .. ":_uniques",
        model_key
    }

    redis.call("SREM", model_name .. ":all", id)
    redis.call("DEL", unpack(keys))
end

local results = {}
for _, query in pairs(queries) do
    results = redis.call(unpack(query))
end

if next(ids) then
    redis.call("DEL", unpack(ids))
end

if results[1] ~= nil then
    local model = redis.call("HGETALL", model_name .. ":" .. results[1])
    table.insert(model, 'id')
    table.insert(model, results[1])

    local model_key = model_name .. ":" .. results[1]

    remove_indices(model_key, results[1])
    delete(model_key, model_name, results[1])

    return model
end

return nil
