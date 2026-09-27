# Sam

My own git adventure from scratch.

### Origin's name

Sam – Samwise Gamgee, a beloved character from J.R.R. Tolkien's Middle-earth, best known as Frodo's loyal companion in The Lord of the Rings.

Click [here](https://tolkiengateway.net/wiki/Samwise_Gamgee) to learn more.

## Installation

Every time we changed the application, we must run this command:

```
mix escript.build
```

`escript` let us package the whole application into a single executable file that we can run directly from our command line. It provides a convinient way to pack our Command Line Interface (CLI).

Now, type the `init` command:

```
~/temp › ../sam/sam init sam
Initialized empty sam repository in sam/.git
```

Create the `hello.txt` file with hello content.

```
sam commit
```

The command must be run with your working directory set to the repo root (/Users/dhonysilva/estudos/temp/sam, where .git lives), while invoking the binary by its full path from wherever it was built:

```
cd /Users/dhonysilva/estudos/temp/sam
/Users/dhonysilva/estudos/sam/sam cat-file CE013625030BA8DBA906F756967F9E9CA394464A
```
