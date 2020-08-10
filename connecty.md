<style>
  
code {
    display: inline-block;
    color: rgb(0, 128, 255);
    padding: 0.1em 0.5em;
    background-color: #eee;
    font-weight: 800;
    border-style: none;
    border-radius: 1em;
    font-size: 15px;
    word-wrap: break-word;
}

.bot-img img {
	background-color: rgb(114, 137, 218) !important;
}
  
</style>

# Connecty
Connecty will redirect messages from channels to other channels.
This will effectively merge multiple channels into a single channel (cross server chat) or create announcement channels.
Announcement channels can be subscribed to by any server, using a single id.
Cross server chats are a great way to get more members since members will befriend each other across servers.
The bot also has a global chat which any server can sign up for and which is moderated from the support server.
Some of the other features include: viewing all your connections, toggling them on/off and customizing them.
Connections can be customized in many ways, such as using webhooks to show the author, have it be anonymous or change the font.

Visit the support server for more help and info about all the commands there are!

## Quick Start

### Connect to the global chat
* Type `c/global` in the channel you wish to connect
* Type `c/unsubscribe` to stop the connection

### Connect two or more of your own channels or servers
* Type `c/auto` in all the channels you wish to connect
* Type `c/delete` to start over

### Connect to a server you don't administrate
* Type `c/auto` in your channels 
* You receive a 10 digit id from Connecty, send it to the second admin
* They send it, through DM, to Connecty
* They type `c/auto` in their channels 

## Good to know
* `c/help` lists all the avaliable commands, even some that aren't mentioned here. For a detailed description of the command, do `c/help <command>`
* The commands `c/cmd_usage` and `c/flags` give helpful information about the bot, try them!
* Each connection has a unique id, channels can leave or join it, customization is configured for the connection as a whole
* A connection id is *not* some sort of one-time token. Not more than a user id or channe id is.
* Remember that `c/new` (ignoring `c/auto`) is the only command that can create new connections (and with each connection, an id), but also *does* not connect to existing connections. `c/subscribe` does that
* When using a command that does something to a channel, connecty will always use the channel, the command was used in. Don't bother with channel id's.
* When using a command that does something to an existing connection, connecty will look for it in the following order (The first one to match, will be used)
  1. An id provided in command parameters
  2. A connection using the channel you used the command in
  3. An id in the last message of your dm's
 
## Recipes
### Connecting channels the proper way
* Type `c/new` in your channel  
* You receive a 10 digit id from Connecty
* Type `c/subscribe` in all the channels you wish to connect
* If you regret connecting a channel, type `c/unsubscribe`
* For servers you don't administrate, send them your id
* If you regret the whole connection, type `c/delete`
* Once you're finished, you can view your connection with `c/view`
* In case you got more connections type `c/view_all` to view them all

### Subscribing to an existing connection in another server
* Ask the owner for the id of their connection. They can obtain it with `c/view_all`
* Type `c/subscribe <id>` in the channel you wish to connect
* Type `c/unsubscribe` if you regret

### Customizing a connection
* Type `c/text_modes` and pick a style you prefer. For the sake of example, let it be style 4 (sorc)
* Type `c/text_mode 4` or `c/text_mode sorc`
* Type `c/flags` to see all the avaliable flags. These are options that can either be on or off
* For the sake of example, lets say we want our messages to replace (replace) and be anonymous (anon)
* Type `c/enable_flags replace anon`
* Now all our messages look the same and super fancy

### Creating an announcement channel
* Use `c/new` in the channel you want to be the source of announcements
* Add at least one channel yourself, with `c/subscribe`
* Type `c/enable_flags oneway` This will make the messages only go one way, from your channel to other channels
* Type `c/view` to get your id
* Share the id!

### Creating a busy server network connection
* Enable the flags `clean` and `protected` with the `enable_flags` command
* `clean` will filter out most spam, such as bots, images and links
* `protected` will give you control over what channels are added, with the `elevate` mechanic
* When a channel is to be added with the `subscribe` command, first use the `elevate` command in the origin channel
* The origin is the channel where the connection was created i.e. the channel where `new` was used
* The origin channel can be found with the view commands
* To have another channel (in the connection) be the origin, first use `elevate` in the origin then `origin` in the new channel
* Some basic modding, across servers, is possible. It might require setting up some custom commands, so send me a DM first



### Still need help? Got any suggestions?
* I'm always available to help people out in the [support server](https://discord.gg/fcZBB2v)

<br>

<img src="https://i.imgur.com/ospzvEb.png" style="width:300px">
<img src="https://i.imgur.com/WrskUCg.png" style="width:300px">
<img src="https://i.imgur.com/i3rmwht.png" style="width:300px">
