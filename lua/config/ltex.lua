-- LTeX+ (LanguageTool) spell & grammar checking for German + English.
-- Persistent "add to dictionary" / "disable rule" code actions are stored in
-- spell/ltex.json inside this config.
local M = {}

local path = vim.fn.stdpath "config" .. "/spell/ltex.json"

local function load()
  local data = {}
  local f = io.open(path, "r")
  if f then
    local ok, decoded = pcall(vim.json.decode, f:read "*a")
    f:close()
    if ok and type(decoded) == "table" then
      data = decoded
    end
  end
  data.dictionary = data.dictionary or {}
  data.disabledRules = data.disabledRules or {}
  return data
end

local function save(data)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local f = assert(io.open(path, "w"))
  f:write(vim.json.encode(data))
  f:close()
end

-- code action handlers (nvim runs these client-side for "_ltex.*" commands)
local function register(command, kind, arg_key)
  vim.lsp.commands[command] = function(cmd, ctx)
    local data = load()
    for lang, items in pairs((cmd.arguments and cmd.arguments[1] or {})[arg_key] or {}) do
      data[kind][lang] = data[kind][lang] or {}
      for _, item in ipairs(items) do
        if not vim.tbl_contains(data[kind][lang], item) then
          table.insert(data[kind][lang], item)
        end
      end
    end
    save(data)

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      client.settings = client.settings or {}
      client.settings.ltex = client.settings.ltex or {}
      client.settings.ltex[kind] = data[kind]
      client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end
end

function M.setup()
  register("_ltex.addToDictionary", "dictionary", "words")
  register("_ltex.disableRules", "disabledRules", "ruleIds")

  local data = load()

  -- ltex-ls-plus ships its own JDK 21; a globally set (older) JAVA_HOME would break it
  local bundled_jdk = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/ltex-ls-plus/*/jdk-*", false, true)[1]

  vim.lsp.config("ltex_plus", {
    cmd_env = bundled_jdk and { JAVA_HOME = bundled_jdk } or nil,
    settings = {
      ltex = {
        language = "auto", -- detects German / English per document; override with :LtexLang
        dictionary = data.dictionary,
        disabledRules = data.disabledRules,
      },
    },
  })

  -- :LtexToggle / <leader>ts  -> turn spell & grammar check on/off
  local enabled = true
  local function toggle()
    enabled = not enabled
    vim.lsp.enable("ltex_plus", enabled)
    if enabled then
      -- vim.lsp.enable() doesn't attach to already open buffers: re-trigger FileType (after the old client stopped)
      vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
            vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
          end
        end
      end, 500)
    end
    vim.notify("LTeX spell/grammar check: " .. (enabled and "on" or "off"))
  end
  vim.api.nvim_create_user_command("LtexToggle", toggle, { desc = "Toggle LTeX spell/grammar check" })
  vim.keymap.set("n", "<leader>ts", toggle, { desc = "Toggle spell/grammar check (LTeX)" })

  -- :LtexLang de-DE | en-US | auto
  vim.api.nvim_create_user_command("LtexLang", function(opts)
    for _, client in ipairs(vim.lsp.get_clients { name = "ltex_plus" }) do
      client.settings = client.settings or {}
      client.settings.ltex = client.settings.ltex or {}
      client.settings.ltex.language = opts.args
      client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
    vim.notify("LTeX language: " .. opts.args)
  end, {
    nargs = 1,
    complete = function()
      return { "auto", "de-DE", "en-US", "en-GB" }
    end,
    desc = "Set the LTeX spell/grammar check language",
  })
end

return M

