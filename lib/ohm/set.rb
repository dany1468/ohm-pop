module Ohm
  class Set
    LUA_POP  = File.expand_path("../lua/pop.lua", __FILE__)

    def pop(options = {})
      if options[:by]
        options.merge!(:by => to_key(options.delete(:by)))
      end

      if options.has_key?(:limit)
        raise ArgumentError, 'limit options is not supported. always limit: [0, 1]'
      end

      options.merge!(limit: [0, 1])

      ids = []
      ops = []

      expr = ["SORT", key, *Utils.sort_options(options)]
      ops.push(Stal.compile(expr, ids, ops))

      response = script(
        LUA_POP,
        0,
        ops.to_msgpack,
        ids.to_msgpack,
        @model.name.to_msgpack
      )

      return nil unless response

      @model.new(Utils.dict(response))
    end

    # NOTE This method is the same as Ohm::Model#script
    def script(file, *args)
      cache = LUA_CACHE[redis.url]

      if cache.key?(file)
        sha = cache[file]
      else
        src = File.read(file)
        sha = redis.call("SCRIPT", "LOAD", src)

        cache[file] = sha
      end

      redis.call("EVALSHA", sha, *args)
    end
  end
end
