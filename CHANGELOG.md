# Changelog

Breaking changes, bugfixes, and new features for each release are summarized here.
For full details, please consult the SCM changelog.

## v0.0.3
 * Breaking change: Moved require_dir from :namespace to :source_loader.
 * Breaking change: Plugins are now loaded into the injected module.
   This will break any load path manipulation or lazy require usage.
 * Breaking change: The block passed to boot is now evaluated directly
   against the context, rather then the provided object or main.
 * Add support for registering run blocks which will run against the
   provided object or main.
 * Add the beginnings of a test suite.
 * Add supporting documents to gem build.
 * Add the plugin_injector plugin, which creates proxy classes
   for all registered plugins on the root namespace. For example,
   the context plugin instance will be available through the Context
   class in the namespace.

## v0.0.2
 * Fixed gemspec.

## v0.0.1
 * First release, yanked due to invalid gemspec.
