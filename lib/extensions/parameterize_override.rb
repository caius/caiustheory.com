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

Middleman::Blog::UriTemplates.prepend(ParameterizeOverride)
Middleman::Blog::UriTemplates.singleton_class.prepend(ParameterizeOverride)
