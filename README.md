# alfred-apple-tv-converter ([download](http://pedro.bbde.org/files/apple-tv-converter.alfredworkflow))

Alfred workflow to control the [apple-tv-converter](https://github.com/gokuu/apple-tv-converter) gem. Currently using [apple-tv-converter](https://github.com/gokuu/apple-tv-converter) v0.3.3.

## Main features

* Convert movies to MP4 format playable on Apple TV (does not allow multiple conversions in parallel)
* Can convert multiple files and/or folders in one batch
* Can optionally fetch movie metadata from [IMDB](http://www.imdb.com) (check [apple-tv-converter](https://github.com/gokuu/apple-tv-converter)'s documentation on how to do this)

## Caveats

* Requires [rvm](https://rvm.io) to be installed ([apple-tv-converter](https://github.com/gokuu/apple-tv-converter) requires ruby v1.9 and the system ruby is v1.8, will try to make it work in v1.8 later)
* Requires [ffmpeg](http://ffmpeg.org) to be installed for the conversion process (recommended installation via [Homebrew](http://mxcl.github.io/homebrew/))

Everything else that's necessary should already be bundled in the workflow (hence the ~11Mb).

## Usage

### Converting

First, select one or more files or folders either in Finder or [Path Finder](http://www.cocoatech.com), and then use the `atc` keyword on Alfred 2 to start the conversion

### Status report

Use the keyword `atc status` to get a status report for the conversion in a Large Type message

### Cancel conversion

Use the keyword `atc cancel` to cancel the conversion. Note: no cleanup is made, and a partly converted file will be left on the directory

## Thanks

* [Zhao Cai](https://github.com/zhaocai) for his [Alfred 2 Workflow Ruby Template](https://github.com/zhaocai/alfred2-ruby-template)

## LICENSE:

Copyright (c) 2013 Pedro Rodrigues <pedro@bbde.org>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.