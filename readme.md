# i18n lookup for NeoVim

This plugins provides a simply way to look up definitions for language keyed strings in your codebase.
It does so by simple key look up in the configured translation files.

This is intended to be used with setups like i18next and accompanying localization/en.json, localization/da.json, etc. files.

## Installation & Configuration

To set up the plugin, require the packager and supply a list of language configurations (filePath, keymap) to the setup function like so (example using Lazy):
```lua
return {
  "magerlinc/i18n.nvim",
  require('i18n').setup({
    {
      filePath = 'path/to/your/translations.json',
      keymap = 'your-keymap'
    },
    {
      filePath = 'path/to/your/other-translations.json',
      keymap = 'your-other-keymap'
    }
  })
}
```

For example, if you have a translation file `en.json` like this:
```json
{
  "hello": "Hello",
}
```
And you set up the configuration like this:
```lua
require('i18n').setup({
  {
    filePath = 'path/to/your/en.json',
    keymap = '<leader>en'
  }
})
```

You can press `<leader>en` while your cursor is anywhere inside the string "hello" to look it up in the `en.json` file.
```typescript
const greeting = t('hello'); // pressing <leader>en while your cursor is in the string will open the en.json file and go to the "hello" key
```




