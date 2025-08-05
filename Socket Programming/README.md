# HTTP-ASM64

A minimal HTTP server written in 64-bit Assembly using NASM. Currently serves a single static page (`index.html`) as a proof of concept for low-level network programming.

## What I Learned

- Learning NASM (Linux)
- 64-bit Assembly programming fundamentals
- Linux system calls for network operations
- Socket programming at the assembly level
- Makefile automation
- HTTP protocol basics

## Quick Start

**Dependencies:**
```bash
sudo apt-get install nasm build-essential
```

**Build and Run:**
```bash
make build && ./server
# or
./Run-NASM.sh server.asm
```

Server runs on `http://127.0.0.1:3926`

## Screenshots

### Console Output
![Console](screenshots/console.png)

### Server Response
![Index Page](screenshots/index.png)

### Network Debug
![Firefox Console](screenshots/firefox-console.png)

## Roadmap

- [ ] Refactor duplicate code into reusable functions
- [ ] Proper HTTP error handling (404, 500)
- [ ] Multiple file serving (CSS, JS, images)
- [ ] POST method support
- [ ] Graceful socket shutdown
- [ ] Content-Type header detection

## Technical References

- [GNU C Sockets Documentation](http://www.delorie.com/gnu/docs/glibc/libc_301.html)
- [Linux System Calls Reference](https://filippo.io/linux-syscall-table/)
- [x86-64 Assembly Reference](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html)
- [Network Programming with Sockets](http://beej.us/net2/html/syscalls.html)