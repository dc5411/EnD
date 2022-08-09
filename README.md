# EnD: Exploits & Dragons

## Dependencies

EnD requires `sinatra` and `ruby-zip` to work. You can install those dependencies by either running

```bash
#on the root folder
bundle install 
```

or

```bash
gem install rubyzip sinatra
```

## Tutorials and Sample Bosses

Two sample bosses (BlizardOne and Saruman) can be found on the Catalog. They are pretty easy to defeat and may be a good starting point for new players. Login into them as either `player1` or `player2` with password `dc5411`.

Feel free to ask for guidance if you are stuck!


## Tips

- New ASCII art can be manually added to the `bossdata/ascii` folder.
- Want to share your awesome boss? It is stored as a zip file in the `bossdata/catalog` folder.
- When adding "Interrupt a connection" as a damage condition, don't forget to add an entry for that connection on the `/etc/hosts` file. You can do so by issuing `echo '127.0.0.1 myconnection' >> /etc/hosts` on the "Additional Commands" field.
- When adding "Stop a service" as a damage condition, don't forget to allow users to interact with its `init.d` script.
- When adding "Lock a user" as a damage condition, allow users to use `sudo` against the `/usr/bin/usermod` binary.
- When adding "Delete a File" as a damage condition, the file will be created automatically, but you should set the permissions on the containing folder correctly on the "Additional Commands" field.
- Have fun, and share your new bosses with us (or invite us over)!

## Conferences

|#| Date | Conference | Link to Video | Link to Slides |
|---|---|---|---|---|
|1| AUG-2022 | DEF CON 30 VR | - | https://docs.google.com/presentation/d/1yxvkXteZYYxcUL-V_KHEonfcS74XGinC0tEFb55iDqQ/edit |

## Credits

**EnD** was created by [AdanZkx](https://github.com/adanzx) & [MauroEldritch](https://github.com/mauroeldritch) from [DC 5411](https://github.com/dc5411).