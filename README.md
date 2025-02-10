# KBrowse

Create links to https://elixir.bootlin.com/linux/ from a local kernel source
tree.

Handy when browsing kernel trees downloaded directly from git.kernel.org

## Usage

Call the setup function from your favorite package manager:
```
require("kbrowse").setup()
```

Two user commands are then installed.

`KBrowse` - Opens a browser to the line(s) at the cursor.

`KBrowseClipboard` - Copy the link created directly to your clipboard.

Both commands will work in visual mode.
