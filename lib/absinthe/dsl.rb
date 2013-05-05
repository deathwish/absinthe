module Absinthe
  module Dsl
    def boot! boot_file, calling_context = nil, &block
      root_context.configure do
        const :app_root, File.expand_path(File.dirname(boot_file))
        const :calling_context, calling_context
        const :boot_proc, block
        boot!
      end
    end

    def halt!
      root_context.halt!
    end
  end
end
