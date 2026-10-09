return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts = require("nvim-treesitter")

    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local languages = {
      "bash",
      "c",
      "c_sharp",
      "cpp",
      "css",
      "dockerfile",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "php",
      "python",
      "query",
      "rust",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    local disabled = {
      css = true,
    }

    local function enable(buf)
      if not vim.api.nvim_buf_is_loaded(buf) then
        return
      end

      local filetype = vim.bo[buf].filetype
      if filetype == "" or disabled[filetype] then
        return
      end

      local lang = vim.treesitter.language.get_lang(filetype)
      if not lang or disabled[lang] or not vim.treesitter.language.add(lang) then
        return
      end

      vim.treesitter.start(buf, lang)
    end

    local group = vim.api.nvim_create_augroup("treesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      desc = "enable treesitter highlighting",
      group = group,
      callback = function(ev)
        enable(ev.buf)
      end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      enable(buf)
    end

    ts.install(languages):await(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        enable(buf)
      end
    end)

    require("nvim-ts-autotag").setup()
  end,
}
