[//]: # (for the best experience open this file in VS Code)

# . (scripts)
Generator scripts are in this folder.

**Platform**: linux

**Entry point**: [`run.sh`](./run.sh) `1.70.0`

## Details
Default it download the selected boost version, compile tools, extract package information and install all headers and sources only. To deploy a subset of packages, create a package list in `output/install_libraries` file.

Parameter | Description
---       | ---
-c | clear output folder
-v | verbose mode

These files were checked / executed on Ubuntu 18.04 LTS under WSL (Windows Subsystem for Linux)  
Most of them are standalone scripts (not all cases were tested).  
Based on <https://github.com/ki11roy/header_only_boost>

File | Description
---  | ---
[run.sh](./run.sh) | Gather and execute files in order.
[prepare.sh](./prepare.sh) | Download and uncompress the selected boost, collect library names, compile `b2` and `bcp` if necessary (it takes a couple of minutes)
[list\_light.sh](./list_light.sh) | Collect information about libraries and generated [dependency files](#output/doc)
[deploy\_source.sh](./deploy_source.sh) | Deploy all libraries from `output/install_libraries` with `bcp`
[deploy\_all\_sources.sh](./deploy_all_sources.sh) | Copy sources from `libs/**/src/**` and `boost/*.[|cpp|hpp|h|c|ipp]`
[strip\_libs.sh](./strip_libs.sh) | backup `libs` folder and strip non-source files for faster processing
[redo\_strip.sh](./redo_strip.sh) | redo what `strip_libs.sh` did: delete stripped `libs` folder and restore it from the backup
[ensure\_variables.sh](./ensure_variables.sh) | set defaults of unset but required variables. Some of these variables are exported from `prepare.sh`.

# boost\_VERSION\_NUMBER
You can copy boost library here. If missing, script will offer to download/extract it. The tools will compile in this folder either.

# output/boost, output/libs
These folders are copied / stripped from the original boost package. Libs contains only source files.

# output/doc
The following files describe which library depends on which (**`libs`**) package:

* [01\_header\_only\_libraries.txt](output/doc/01_header_only_libraries.txt)
  * **use these libraries freely**

* [02\_other\_dependency\_libraries.txt](output/doc/02_other_dependency_libraries.txt)
  * **some** functionalities have lib **dependencies**

* [03\_own\_dependency\_libraries.txt](output/doc/03_own_dependency_libraries.txt)
  * **avoid usage** of any library from here

* [04\_with\_dependency\_libraries.txt](output/doc/04_with_dependency_libraries.txt)
  * list all libraries which have dependencies

* [05\_all\_libraries.txt](output/doc/05_all_libraries.txt)
  * list all libraries and their dependencies

# output/temp
Temp files generated during process. Most of them made during prepare.

* [to\_README.md](output/temp/to_README.md)
  * Markdown formatted version information about the selected boost version (source json is downloaded from boost.org).
