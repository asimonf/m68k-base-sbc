# Introduction

This was made for helping me on a SBC 68K computer I've been working with. As much as I love the idea of using assembler to explore the full potential of these old architectures, I'm not well versed in it. So, in order to reduce variables and complexity, I setup this base project which can serve as a starting point for any kind of project targetting said system.

It supports C, C++ and Assembler, so it should span a wide spectrum of programming paradigms. It requires a toolchain, but there's a config file to build one with [crosstool-NG](http://crosstool-ng.github.io/). The toolchain is configured to include Newlib, but it does so with the bare minimum. Don't expect support for math.h, printf or file support. Given that this is a custom system, expect to program support for those things as you see fit according to your specific design.

The linker script memory map is easily modifiable to support variations. Right now it's set up to follow the memory map of the Sega Megadrive/Genesis. But that's because I started with one for that system as a base. I wanted a C startup script to make it more approachable to people like me. It copies data from initialized variables to the corresponding region of ram. The initializer for constructors and destructors is also included in a C version, so it's more readable.

I also added a small stub that calls Easy68K's print trap exception to print text on the simulator. This is to help me debug things on that simulator. The process of getting the binary running there is a bit involved, though. I'd like to be able to build a file listing that is compatible with that format that also shows the dissassembled version as a helper to know what it's executing, but that's a project for another time.

# References

The Makefile from this project was based of [this](https://spin.atomicobject.com/2016/08/26/makefile-c-projects/). As a Makefile noob, this was very very helpful.

The linker script was based on the one from the [Megadrive GCC project](https://github.com/noname22/megadrive-gcc). It was modified to fit my needs. [These](https://www.youtube.com/playlist?list=PLERTijJOmYrDiiWd10iRHY0VRHdJwUH4g) series of videos helped me understand what I was doing.

The GCC toolchain was created with the help of [crosstool-NG](http://crosstool-ng.github.io/). The config file is included with the project. Please refer to instructions on the project's web page for building. I was able to build it no problem on WLS 2.

