# Dynamic slideshow

This is my first try of a slideshow using the "Ken Burns Effect". It was created to be used with the
photo_party_sync tool (https://github.com/kayssun/photo_party_sync). Before the slide changes, the browser will
query the backend for the next image. The backend will provide the one of the newest images that were added to
the list. If there are no new images, an old one is randomly chosen.

I will use this slideshow at a wedding where the guest can take photos that are automatically addded to
the slideshow.

My JavaScript knowledge is somehow basic. So this is probably not the fastest or most beautiful slider you may find.

## Usage

Download the files

    $ git clone https://github.com/kayssun/dynamic_slideshow

switch into the new directory

    $ cd dynamic_slideshow

install dependencies

    $ bundle install

run the server

    $ ./server.rb

and open a browser to http://localhost:4567


## Images

Images need to be put into the public/images directory. You can put them in subfolders. You can add new images while
the server is running. That is the whole point. :)