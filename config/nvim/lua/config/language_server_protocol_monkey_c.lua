-- NOTE: Taken from: https://github.com/cyberang3l/garmin-monkey-c-neovim-language-server/tree/main
-- FIXME: Therre is a huge amount of unecessary setup here! Be good to remove most of it!

-- Define a custom language server for monkeyc
local configs = require("lspconfig.configs")
local lspconfig = require("lspconfig")

local function get_monkeyc_language_server_path()
  -- ~/.Garmin/ConnectIQ/current-sdk.cfg is the Linux path
  local current_sdk_cfg_path = "~/.Garmin/ConnectIQ/current-sdk.cfg"

  -- if the user overrides the path with the global variable
  -- g.monkeyc_current_sdk_cfg_path, use this path instead.
  --
  -- Else if the current OS is detected a Mac, use the Mac path
  if vim.g.monkeyc_current_sdk_cfg_path then
    current_sdk_cfg_path = vim.g.monkeyc_current_sdk_cfg_path
  elseif vim.loop.os_uname().sysname == "Darwin" then
    current_sdk_cfg_path = "~/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg"
  end

  local workspace_dir = table.concat(vim.fn.readfile(vim.fn.expand(current_sdk_cfg_path)), "\n")
  local jar_path = workspace_dir .. "/bin/LanguageServer.jar"

  if vim.fn.filereadable(jar_path) == 1 then
    return jar_path
  end
  print("Monkey C Language Server not found: " .. jar_path)
  return nil
end

local monkeyc_ls_jar = get_monkeyc_language_server_path()
if monkeyc_ls_jar then
  -- To enable tracing of the official VSCode plugin, add the following snippet
  -- under "contributes" -> "configuration" -> "properties"
  -- in ~/.vscode/extensions/garmin.monkey-c-1.1.1/package.json
  --
  -- "monkeyc.trace.server": {
  -- 	"scope": "window",
  -- 	"type": "string",
  -- 	"enum": [
  -- 		"off",
  -- 		"messages",
  -- 		"verbose"
  -- 	],
  -- 	"default": "verbose",
  -- 	"description": "Traces the communication between VS Code and the language server."
  -- },
  --
  -- Then open a MonkeyC project and check the VSCode "Output" window
  --
  -- To debug the nvim plugin:
  -- tail -f ~/.local/state/nvim/lsp.log
  --
  -- Uncomment the following to enable debug logging
  -- vim.lsp.set_log_level("debug")
  --
  -- Open a MonkeyC project and check the lsp.log output
  --
  local monkeycLspCapabilities = vim.lsp.protocol.make_client_capabilities()
  -- Need to set some variables in the client capabilities to prevent the
  -- LanguageServer from raising exceptions
  monkeycLspCapabilities.textDocument.declaration.dynamicRegistration = true
  monkeycLspCapabilities.textDocument.implementation.dynamicRegistration = true
  monkeycLspCapabilities.textDocument.typeDefinition.dynamicRegistration = true
  monkeycLspCapabilities.textDocument.documentHighlight.dynamicRegistration = true
  monkeycLspCapabilities.textDocument.hover.dynamicRegistration = true
  monkeycLspCapabilities.textDocument.signatureHelp.contextSupport = true
  monkeycLspCapabilities.textDocument.signatureHelp.dynamicRegistration = true
  monkeycLspCapabilities.workspace = {
    didChangeWorkspaceFolders = {
      dynamicRegistration = true,
    },
  }
  monkeycLspCapabilities.textDocument.foldingRange = {
    lineFoldingOnly = true,
    dynamicRegistration = true,
  }

  if not configs.monkeyc_ls then
    local jungleFiles = vim.g.monkeyc_jungle_files or "monkey.jungle"
    local root = lspconfig.util.root_pattern("monkey.jungle", "manifest.xml")
    local rootPath = root(vim.fn.getcwd()) or vim.fn.getcwd()
    local devKeyPath = "~/.Garmin/connect_iq_dev_key.der"
    local developerKeyPath = vim.fn.expand(devKeyPath)
    if vim.g.monkeyc_connect_iq_dev_key_path then
      developerKeyPath = vim.fn.expand(vim.g.monkeyc_connect_iq_dev_key_path)
    end
    configs.monkeyc_ls = {
      default_config = {
        cmd = {
          "java",
          "-Dapple.awt.UIElement=true",
          "-classpath",
          monkeyc_ls_jar,
          "com.garmin.monkeybrains.languageserver.LSLauncher",
        },
        filetypes = { "monkey-c", "monkeyc", "jungle", "mss" },
        root_dir = root,
        settings = {
          {
            developerKeyPath = developerKeyPath,
            compilerWarnings = true,
            compilerOptions = vim.g.monkeyc_compiler_options or "",
            developerId = "",
            jungleFiles = jungleFiles,
            javaPath = "",
            typeCheckLevel = "Default",
            optimizationLevel = "Default",
            testDevices = { "fr165" },
            debugLogLevel = "Default",
          },
        },
        capabilities = monkeycLspCapabilities,
        init_options = {
          publishWarnings = vim.g.monkeyc_publish_warnings or true,
          compilerOptions = vim.g.monkeyc_compiler_options or "",
          typeCheckMsgDisplayed = false,
          workspaceSettings = {
            {
              path = rootPath,
              jungleFiles = {
                rootPath .. "/monkey.jungle",
              },
            },
          },
        },
        ---@param client vim.lsp.Client
        on_attach = function(client, bufnr)
          client.server_capabilities.completionProvider = {
            triggerCharacters = {
              ".",
              ":",
            },
            resolveProvider = false,
            documentSelector = {
              {
                pattern = "**/*.{mc,mcgen}",
              },
            },
          }
          -- print(vim.inspect(client.config))
          local methods = vim.lsp.protocol.Methods
          local req = client.request

          client.request = function(method, params, handler, bufnr_req)
            -- The Garmin LanguageServer returns broken file URIs for
            -- "textDocument/definition" requests that look like this:
            --
            --   "file:/absolute/path/to/file"
            --
            -- This doesn't work (notice the single / after the 'file:')
            -- and must be converted to the following (notice the three
            -- slashes):
            --
            --   "file:///absolute/path/to/file"
            --
            -- The following code overrides the response 'handler' for
            -- "textDocument/definition" requests
            --
            -- https://www.reddit.com/r/neovim/comments/1j6tv9y/comment/mgyqbha/
            --
            if method == methods.textDocument_definition then
              -- Override the response handler for "textDocument/definition" requests
              return req(method, params, function(err, result, context, config)
                local function fix_uri(uri)
                  if uri:match("^file:/[^/]") then
                    uri = uri:gsub("^file:/", "file:///") -- Fix missing slashes
                  end
                  return uri
                end

                -- Fix the URLs as needed
                if vim.islist(result) then
                  for _, res in ipairs(result) do
                    if res.uri then
                      res.uri = fix_uri(res.uri)
                    end
                  end
                elseif result.uri then
                  result.uri = fix_uri(result.uri)
                end

                -- Call the response handler with the fixed URIs in the result
                return handler(err, result, context, config)
              end, bufnr_req)
            elseif method == methods.textDocument_signatureHelp then
              -- When calling the signature help, it seems like the server expects
              -- params.context to be set
              params.context = {
                triggerKind = 1,
              }
              return req(method, params, handler, bufnr_req)
            else
              -- Use the default response handlers for all other requests
              return req(method, params, handler, bufnr_req)
            end
          end
        end,
      },
    }
  end

  lspconfig.monkeyc_ls.setup({})
end

-- Configure docs hover popup toggle with <M-h> in normal mode
vim.keymap.set({ "n" }, "\x18@sh", function()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    -- if zindex > 0, it the window is a float window - hover popups are float windows
    if vim.api.nvim_win_get_config(winid).zindex then
      -- Close float windows and return
      vim.cmd.fclose()
      return
    end
  end
  -- If no hover windows found, call hover()
  vim.lsp.buf.hover()
end, { silent = true, noremap = true })

-- Configure <M-j> to enter the hover window if we need to scroll through a long docstring
-- Double calling of hover enters the float window and allows for browsing the window. Use
-- 'q' to exit the floating window if you've entered.
vim.keymap.set({ "n" }, "\x18@sj", function()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      vim.lsp.buf.hover()
      return
    end
  end
end, { silent = true, noremap = true })

-- Configure function signature help popup with <M-h> in Insert mode (C-K seems like is also working by default)
vim.keymap.set({ "i" }, "\x18@sh", function()
  -- If no hover windows found, call hover()
  vim.lsp.buf.signature_help()
end, { silent = true, noremap = true })

vim.lsp.enable({ "monkey_c" })
