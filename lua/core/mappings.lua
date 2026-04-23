local M = {}

-- ============================================================================
-- MAP DEFINITIONS
-- ============================================================================
M.general = {
  n = {
    -- Wrapped text movement (notice the extra opts at the end)
    ["j"] = { function() return vim.v.count == 0 and "gj" or "j" end, "Down (wrap-aware)", expr = true, silent = true },
    ["k"] = { function() return vim.v.count == 0 and "gk" or "k" end, "Up (wrap-aware)", expr = true, silent = true },

    -- Search and centering
    ["<leader>c"] = { ":nohlsearch<CR>", "Clear search highlights" },
    ["n"] = { "nzzzv", "Next search result (centered)" },
    ["N"] = { "Nzzzv", "Previous search result (centered)" },
    ["<C-d>"] = { "<C-d>zz", "Half page down (centered)" },
    ["<C-u>"] = { "<C-u>zz", "Half page up (centered)" },

    -- Clipboard / Deletion
    ["<leader>x"] = { '"_d', "Delete without yanking" },

    -- Buffers
    ["<leader>bn"] = { ":bnext<CR>", "Next buffer" },
    ["<leader>bp"] = { ":bprevious<CR>", "Previous buffer" },

    -- Window navigation
    ["<C-h>"] = { "<C-w>h", "Move to left window" },
    ["<C-j>"] = { "<C-w>j", "Move to bottom window" },
    ["<C-k>"] = { "<C-w>k", "Move to top window" },
    ["<C-l>"] = { "<C-w>l", "Move to right window" },

    -- Window splitting and resizing
    ["<leader>sv"] = { ":vsplit<CR>", "Split window vertically" },
    ["<leader>sh"] = { ":split<CR>", "Split window horizontally" },
    ["<C-Up>"] = { ":resize +2<CR>", "Increase window height" },
    ["<C-Down>"] = { ":resize -2<CR>", "Decrease window height" },
    ["<C-Left>"] = { ":vertical resize -2<CR>", "Decrease window width" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "Increase window width" },

    -- Line movement
    ["<A-j>"] = { ":m .+1<CR>==", "Move line down" },
    ["<A-k>"] = { ":m .-2<CR>==", "Move line up" },

    -- Misc
    ["J"] = { "mzJ`z", "Join lines and keep cursor position" },
    ["<leader>pa"] = {
      function()
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        print("file:", path)
      end,
      "Copy full file path"
    },
    ["<leader>td"] = {
      function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
      "Toggle diagnostics"
    },
  },

  v = {
    -- Clipboard / Deletion
    ["<leader>x"] = { '"_d', "Delete without yanking" },

    -- Line movement
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move selection down" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move selection up" },

    -- Indentation
    ["<"] = { "<gv", "Indent left and reselect" },
    [">"] = { ">gv", "Indent right and reselect" },
  },

  x = {
    -- Paste without overwriting register
    ["<leader>p"] = { '"_dP', "Paste without yanking" },
  }
}

-- ============================================================================
-- THE PARSER LOGIC
-- ============================================================================
function M.setup()
  -- Loop through all groups (e.g., M.general)
  for _, mappings in pairs(M) do
    if type(mappings) == "table" then
      -- Loop through modes (e.g., n, v, x)
      for mode, mode_maps in pairs(mappings) do
        -- Loop through individual keymaps
        for keymap, options in pairs(mode_maps) do
          local action = options[1]
          local desc = options[2]

          -- Construct the opts table
          local opts = { desc = desc }

          -- Extract any extra options (like expr = true, silent = true)
          for k, v in pairs(options) do
            if type(k) ~= "number" then
              opts[k] = v
            end
          end

          -- Apply the mapping
          vim.keymap.set(mode, keymap, action, opts)
        end
      end
    end
  end
end

return M
