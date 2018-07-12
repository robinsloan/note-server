# A note server

![An example of a note in a browser tab](/img/note-example.png)

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I have been meaning to do this FOREVER and I finally did: a local service that populates new browser tabs with random selections from my very large database of notes. The idea is to keep the stew circulating. Aerate the deeper layers. Maybe it will drive me mad. We&#39;ll see. <a href="https://t.co/t6c9JT5uju">pic.twitter.com/t6c9JT5uju</a></p>&mdash; Robin Sloan (@robinsloan) <a href="https://twitter.com/robinsloan/status/1017202162219143168?ref_src=twsrc%5Etfw">July 12, 2018</a></blockquote>

Here, you'll find the hacky work of an afternoon packaged up for macOS and... odds are good you *won't* be able to get it to run on your computer! I'm sharing this only in the spirit of not _totally_ hogging the code for myself.

If you want to give it a shot, here's what you should do.

First, clone this project, install the requirements, and tell your computer it's okay to run the script that launches the server.

```
git clone https://github.com/robinsloan/note-server
cd note-server
gem install rack
gem install bundler
bundle install
chmod +x serve_note_server.sh
```

Now, get your notes together in however many directories you desire. The two supported formats are:

1. a bunch of plain text files, each containing the text of one note, and
2. one or more YAML files, each containing one unnamed array with one note per line.

Next, specify the paths to those directories in `directories.yml`. I'm using relative paths that point to subdirectories within the `notes-server` directory, but you can point elsewhere if you prefer, e.g. `/Users/robin/Documents/All\ My\ Thoughts\ And\ Feelings/` or `~/Dropbox/my_directory_full_of_notes/`

**Here is a fiddly but important step.**

Still in the directory that contains this project, find its absolute path on your particular computer:

```
pwd
```

Then, open the file `com.robinsloan.note_server.plist` with a text editor and replace the string `PATH_TO_NOTE_SERVER_DIRECTORY_HERE` with the absolute path you just printed out.

**I will repeat that this is the fiddliest but most important step.**

Having fiddled with that successfully, you can register the ✨LaunchAgent✨ that will automatically start this server when you log into your computer:

```
bash install.sh
```

After you restart, you should be able to reach this server at `http://localhost:9988` in your browser and see that it loads a random note each time you visit. If that's not the case... whew, I don't even know.

If it *is* the case, that's fine, but the idea here is to encounter these snippets of text whenever you create a new tab. Here's how to set that up.

* If you're using Safari, go to Preferences > General and set new tabs to open with a Homepage, which you'll specify as `http://localhost:9988`.
* If you're using Chrome, install the [New Tab Redirect extension](https://chrome.google.com/webstore/detail/new-tab-redirect/icpgjfneehieebagbmdbhnlpiopdcmna) and, in its preferences, specify the URL as `http://localhost:9988`. **Importantly,** also check the "Always update tab" option or I guarantee it will drive you insane.

That's it! Good luck!