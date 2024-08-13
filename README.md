The Cron Parser
===
This is a simple little Ruby script that will accept a cron string, and then return a formatted output based on the provided string.

For example, given the following input:
```
*/15 0 1,15 * 1-5 /usr/bin/find
```

It will output the following:
```
Minute        0 15 30 45
Hour          0
Day of Month  1 15
Month         1 2 3 4 5 6 7 8 9 10 11 12
Day of Week   1 2 3 4 5
Command       /usr/bin/find
```

Usage
---
Pass the cron string as the first argument to the script:
```shell
ruby the_cron_parser.rb "*/15 0 1,15 * 1-5 /usr/bin/find"
```

Development
---
Install the version of Ruby as specified in the `.ruby-version` file.

Assuming you're on a completely fresh machine, you'll want to use some sort of Ruby version manager.
`rbenv` is a great option, and you can find the installation instructions here: https://github.com/rbenv/rbenv?tab=readme-ov-file#installation

Once `rbenv` is installed, you can then use it to install Ruby 3.3.4:
```shell
$ rbenv install 3.3.4
```

Now install the impressively short list of dependencies:
```shell
$ bundle install
```

And finally, you can now run the tests with:
```shell
$ bin/rspec .
```
