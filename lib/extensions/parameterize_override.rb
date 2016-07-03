# Patches #safe_parameterize to swap out entire strings
# before processing them correctly as the superclass will.
#
# Done so we can override some tag names
#
module ParameterizeOverride
  def self.substitutions
    @substitutions ||= {}
  end

  def self.add_override(original, correction)
    substitutions[original] = correction
  end

  def safe_parameterize(str)
    if (replacement = ParameterizeOverride.substitutions[str])
      super(replacement)
    else
      super
    end
  end
end

# These implementations are identical, but both called so we have to intercept them both. 😂
[Middleman::Util::UriTemplates, Middleman::Blog::UriTemplates].each do |mod|
  mod.prepend(ParameterizeOverride)
  mod.singleton_class.prepend(ParameterizeOverride)
end
