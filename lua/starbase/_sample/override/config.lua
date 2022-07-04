-- you can fetch these settings by injecting the starbase_settings component
-- and accessing the value through dot notation.
-- Example: value = self.starbase_settings:get('stages.lua.enabled')
return {
  stages = {
    lua = {
      enabled = true,
    }
  }
}