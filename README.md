# mkcpio

Create a CPIO filesystem and install it as the rootfs.

## Quick Start

Make sure you have the following environment variables set:

- SYSROOT: The full path to your project root directory.

If you are using the rpos-project git repo, you can use once of the build
profiles. See if you have one set with the command `build-profile`.

Build and install mkcpio

```bash
make
make install
```

## Usage

CPIO will remeber the SYSROOT path it was installed with. So you can simply run
`mkcpio` after it is installed and it is availible in your path.

For more usage details, run `mkcpio -h`.

## mkcpio.conf

The mkcpio.conf file, located in `$SYSROOT/etc/`, is used to tell mkcpio what
files to place in the initfs.cpio image. 

There are 2 facilities to accomplish this goal:

- FILES= used to add specific files into the CPIO archive.
- DIRS= used to add entire directory trees into the CPIO arcive.

Example

```bash
# Add files to include in initfs.cpio
# Note: paths are relative to SYSROOT
FILES="/bin/hello /bin/shell"
```
