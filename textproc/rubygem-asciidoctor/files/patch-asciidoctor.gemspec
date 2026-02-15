--- asciidoctor.gemspec.orig	2026-02-15 19:41:43 UTC
+++ asciidoctor.gemspec
@@ -21,6 +21,10 @@ Gem::Specification.new do |s|

   s.specification_version = 4

+# Until https://github.com/asciidoctor/asciidoctor/issues/4684 is resolved
+# Adding patch from https://github.com/asciidoctor/asciidoctor/pull/4834
+  s.add_dependency 'logger'
+
   s.add_development_dependency(%q<concurrent-ruby>.freeze, ["~> 1.1.0".freeze])
   s.add_development_dependency(%q<cucumber>.freeze, ["~> 3.1.0".freeze])
   s.add_development_dependency(%q<erubi>.freeze, ["~> 1.10.0".freeze])
