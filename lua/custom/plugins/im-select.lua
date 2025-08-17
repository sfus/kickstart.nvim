return {
  'keaising/im-select.nvim',
  config = function()
    require('im_select').setup {
      default_command = 'im-select',
      default_im_select = 'com.google.inputmethod.Japanese.Roman',
      set_default_events = { 'VimEnter', 'InsertLeave' },
      set_previous_events = { 'InsertEnter' },
    }
  end,
}
