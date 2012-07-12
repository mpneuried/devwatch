devwatch
===========

# Flexible file watcher.

`devwatch` is a super flexible file watcher. You can watch different files for changes and run a bash command.

**Note: This module is only tested on OSX!**

*Written in coffee-script*

# Install

**Note:** You have to install it global

```bash
  npm -g install devwatch
```

## RUN

`devwatch` takes at least 2 arguments. But you can add multiple commands.
On start the module scans the current folder plus subfolders for files matching the given `file-regex`

```
devwatch 'file-regex' 'command 1' 'command 2' … 'command n'
```

### Arguments:

- `file-regex`: is a regular expression to filter all files under the current folder tree 
- `command` is a bash command with will be called from the current folder.

## Example

```
devwatch '.soy$' 'soy2js {NAME} de_de' 'soy2js {NAME} en_us'
```

In this example `devwatch` searches for files that end with *.soy*.
On start and on a file change 2 commands called `soy2js` with different arguments will be called.

## Replacements

You can define different variables to be replaced by `devwatch`

- `{PATH}`: the path to the watched file *( e.g. /my/special/path )*
- `{FILE}`: the watched file *( e.g. mywatchedfile.js )*
- `{NAME}`: the watched filename *( e.g. mywatchedfile )*
- `{EXT}`: the watched file extension *( e.g. js )*

# Work in progress

`nodecache` is work in progress. Your ideas, suggestions etc. are very welcome.

# License 

(The MIT License)

Copyright (c) 2010 TCS &lt;dev (at) tcs.de&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.